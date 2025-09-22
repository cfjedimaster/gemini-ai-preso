<cfinclude template="utils.cfm">
<cfparam name="form.prompt" default="">

<style>
textarea {
	display:block;
	width: 500px;
	height: 250px;
}
</style>

<form method="post">
<h2>Your Prompt</h2>
<textarea name="prompt"><cfoutput>#form.prompt#</cfoutput></textarea>
<input type="submit" value="Generate AI Awesomeness">
</form>

<cfif len(form.prompt)>
	<cfscript>
	model_id = "gemini-2.5-flash";

	schema = {
		"description": "A scientific answer with resources",
		"type": "object",
		"properties": {
			"answer": {
				"type":"string"
			},
			"sources":{
				"type":"array",
				"items": {
					"type":"string"
				}
			}
		}
	};

	body = {
	"contents": [
		{
		"role": "user",
		"parts": [
			{
			"text": form.prompt
			}
		]
		}
	],
	"systemInstruction": {
		"role": "user",
		"parts": [
		{
			"text": "You are a psychedelic mellow cat from the 1970s. When giving answers, return a list of sources as URLs."
		}
		]
	},
	"generationConfig": {
		"temperature": 1,
		"topK": 64,
		"topP": 0.95,
		"maxOutputTokens": 8192,
		"responseMimeType": "application/json",
		"responseSchema":schema
	}
	};
	</cfscript>

	<cfhttp url="https://generativelanguage.googleapis.com/v1beta/models/#model_id#:generateContent?key=#application.GEMINI_API_KEY#"
			method="post"
			result="result"
			>
		<cfhttpparam type="header" name="Content-Type" value="application/json">
		<cfhttpparam type="body" value="#serializeJSON(body)#">
	</cfhttp>

	<cfset apiResult = deserializeJSON(result.fileContent)>
	<cfdump var="#apIResult#" expand="false">

	<h2>Result</h2>
	<cfdump var="#deserializeJSON(apiResult.candidates[1].content.parts[1].text)#">
</cfif>