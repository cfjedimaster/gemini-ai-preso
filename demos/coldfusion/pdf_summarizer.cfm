<cfinclude template="utils.cfm">

<cfscript>
setting requesttimeout=900;
model_id = "gemini-2.5-flash";

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

	cfhttp(url="https://generativelanguage.googleapis.com/v1beta/models/#model_id#:generateContent?key=#application.GEMINI_API_KEY#", method="post", result="result") {
		cfhttpparam(type="header", name="Content-Type", value="application/json");
		cfhttpparam(type="body", value="#serializeJSON(body)#");
	}

	return deserializeJSON(result.fileContent);
}

sourcePDFs = directoryList(path=expandPath("../pdfs"),filter="*.pdf");

for(i=1;i<=sourcePDFs.len();i++) {

	// do we _need_ to analyze this?
	possibleTextFile = sourcePDFs[i].replace(".pdf",".txt");
	possibleSummary = fileExists(possibleTextFile);

	writeoutput("<p><strong>Summary for #sourcePDFs[i]#</strong></p>");

	if(possibleSummary) {
		summary = fileRead(possibleTextFile);
		writeoutput(summary);
	} else {
		fileOb = uploadFile(sourcePDFs[i]);

		result = promptWithFile("
		Please act as an expert summarizer. Analyze the provided PDF document and create a concise and comprehensive summary of its key contents. Your summary should focus on the main arguments, conclusions, and any significant data or findings. It should be written in a clear, neutral tone and be easy for a non-expert to understand.
		", fileOb);

		try {
			summary = md2HTML(result.candidates[1].content.parts[1].text);
			writeoutput(summary);
			fileWrite(possibleTextFile, summary);
		} catch(any e) {
			/* The day I built this, Gemini was having "issues" - aren't we all? */
		}
	}

	writeoutput("<hr>");
}

</cfscript>