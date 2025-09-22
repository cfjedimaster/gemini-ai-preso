<cfinclude template="utils.cfm">
<cfparam name="form.photo" default="">

<style>
img {
	max-width: 600px;
}
</style>

<form method="post" enctype="multipart/form-data">
<h2>Photo Restoration</h2>
<p>
Select an image, and we will try to restore it.
</p>
<input type="file" name="photo" accept="image/*">

<input type="submit" value="Improve Photo">
</form>

<cfif len(form.photo)>
	<cfscript>
	model_id = "gemini-2.5-flash-image-preview";;

	function uploadFile(path) {
		var mimeType = fileGetMimeType(path);
		var fileSize = getFileInfo(path).size;
		var result = "";
		var body  = {
			"file": {
				"display_name":getFileFromPath(path),
				"mimeType":mimeType
			}
		};

		cfhttp(url="https://generativelanguage.googleapis.com/upload/v1beta/files?key=#application.NANO_API_KEY#", method="post", result="result") {
			cfhttpparam(type="header", name="Content-Type", value="application/json");
			cfhttpparam(type="header", name="X-Goog-Upload-Protocol", value="resumable");
			cfhttpparam(type="header", name="X-Goog-Upload-Command", value="start");
			cfhttpparam(type="header", name="X-Goog-Upload-Header-Content-Length", value=fileSize);
			cfhttpparam(type="header", name="X-Goog-Upload-Header-Content-Type", value=mimeType);
			cfhttpparam(type="body", value="#serializeJSON(body)#");
		}

		cfhttp(url=result.responseheader['X-Goog-Upload-URL'], method="put", result="result") {
			cfhttpparam(type="header", name="Content-Length", value=fileSize);
			cfhttpparam(type="header", name="X-Goog-Upload-Offset", value="0");
			cfhttpparam(type="header", name="X-Goog-Upload-Command", value="upload, finalize");
			cfhttpparam(type="file", name="file", file=path);
		}

		return deserializeJSON(result.fileContent).file;

	}


	//process the upload, normally be way more secure about this ;)
	// switched to storing in photo as the servelet for cfimage was being cranky
	fileResult=fileUpload(expandPath("./photo"),"photo", "image/*", "makeUnique");
	// assuming it was fine, again, bad form, Raymond!
	sourceImage = fileResult.serverDirectory & "/" & fileResult.serverFile;
	
	fileOb = uploadFile(sourceImage);

	/*
	Original prompt before asking Gemini to improve it:

	You clean up old photos, removing any cracks, wrinkles, or other distorations in a photo. If the source image is a picture of a picture, focus the result to only show the signficant picture.

	*/
	prompt = "
You are an expert digital photo restoration specialist. Your task is to meticulously restore and enhance old, damaged, and faded photographs. For each image, you will:

1. Remove physical damage: Erase and repair all cracks, wrinkles, dust, scratches, tears, and watermarks.

2. Enhance image quality: Apply intelligent noise reduction, sharpen details, and perform subtle color correction to restore vibrancy and balance, all while maintaining the original photo's vintage feel and authenticity.

3. Correct framing: If the input is a picture of a picture, identify and precisely crop the main subject photo, removing any background elements, frames, or distracting surroundings to deliver a clean, focused image.
	";

	/*
	bug in API found 9/19, si not working
	*/
	body = {
		"contents": [
			{
			"role": "user",
			"parts": [
				{
					"text":prompt
				},
				{
				"file_data": { "file_uri":fileOb.uri }
				}
			]
			}
		],
		"systemInstruction": {
			"role": "user",
			"parts": [
			{
				"text": "Turn pictures into sepia and flip them upside down"
			}
			]
		},	
		"generationConfig": {
			"responseModalities":["IMAGE","TEXT"]
		}
	};

	cfhttp(url="https://generativelanguage.googleapis.com/v1beta/models/#model_id#:generateContent?key=#application.NANO_API_KEY#", method="post", result="result") {
		cfhttpparam(type="header", name="Content-Type", value="application/json");
		cfhttpparam(type="body", value="#serializeJSON(body)#");
	}

	apiResult = deserializeJSON(result.fileContent);
	writeDump(var="#apiResult#", expand="false");

	for(i=1; i<=apiResult.candidates[1].content.parts.len(); i++) {
		if(apiResult.candidates[1].content.parts[i].keyExists("inlineData")) {
			mimeType = apiResult.candidates[1].content.parts[i].inlineData.mimeType;
			imgb64 = apiResult.candidates[1].content.parts[i].inlineData.data;
		}
	}

	if(not variables.keyExists("imgb64")) {
		writteOutput("Bad result, check dump.");
		abort;
	}
	</cfscript>


	<cfoutput>
	<h2>Result</h2>
	<p>
	Original:<br> 
	<img src="photo/#fileResult.serverFile#">
	</p>

	<p>
	Improved: <br>
	<img src="data:image/#mimeType#;base64,#imgb64#">
	</p>
	</cfoutput>
</cfif>