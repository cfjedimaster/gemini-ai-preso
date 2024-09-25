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
			"text": "When giving answers, return it in a JSON object with a key, answer, that contains the answer, and then an array named 'urls' that consist of links to resources."
		}
		]
	},
	"generationConfig": {
		"temperature": 1,
		"topK": 64,
		"topP": 0.95,
		"maxOutputTokens": 8192,
		"responseMimeType": "application/json"
	}
	};
	</cfscript>

	<cfhttp url="https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-pro:generateContent?key=#application.GEMINI_API_KEY#"
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