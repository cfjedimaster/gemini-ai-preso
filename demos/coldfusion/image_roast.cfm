<cfinclude template="utils.cfm">

<cfscript>
/*
I figured this out looking at the Shell tab here, https://ai.google.dev/api/files#File
*/
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

	cfhttp(url="https://generativelanguage.googleapis.com/upload/v1beta/files?key=#application.GEMINI_API_KEY#", method="post", result="result") {
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

function promptWithFile(prompt, file) {
	var result = "";

	var body = {
		"contents": [
			{
			"role": "user",
			"parts": [
				{
				"text": prompt
				},
				{
				"file_data": { "file_uri":file.uri }
				}
			]
			}
		],
		"generationConfig": {
			"temperature": 1,
			"topK": 64,
			"topP": 0.95,
			"maxOutputTokens": 8192,
			"responseMimeType": "text/plain"
		}
	};

	cfhttp(url="https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-pro:generateContent?key=#application.GEMINI_API_KEY#", method="post", result="result") {
		cfhttpparam(type="header", name="Content-Type", value="application/json");
		cfhttpparam(type="body", value="#serializeJSON(body)#");
	}

	return deserializeJSON(result.fileContent);
}

sourceImages = directoryList(expandPath('../images'));

for(i=1;i<=sourceImages.len();i++) {
	fileOb = uploadFile(sourceImages[i]);

	result = promptWithFile("Look at this picture and roast it, describing just how bad it is.", fileOb);
	//writeDump(var=result,expand=false);

	imageBits = fileReadBinary(sourceImages[i]);
	image64 = toBase64(imageBits);
	writeoutput("<img src='data:image/jpeg;base64, #image64#'>");

	try {
		writeOutput(md2HTML(result.candidates[1].content.parts[1].text));
	} catch(any e) {
		writedump(var=e, expand=false);
		writedump(var=result, expand=false);
		/* The day I built this, Gemini was having "issues" - aren't we all? */
	}
}

</cfscript>