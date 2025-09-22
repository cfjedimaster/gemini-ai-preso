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
	generate_content_api="generateContent";

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
	"generationConfig": {
      "thinkingConfig": {
        "thinkingBudget": 0,
      },
	}
	};
	</cfscript>

	<cfhttp url="https://generativelanguage.googleapis.com/v1beta/models/#model_id#:#generate_content_api#?key=#application.GEMINI_API_KEY#"
			method="post"
			result="result"
			>
		<cfhttpparam type="header" name="Content-Type" value="application/json">
		<cfhttpparam type="body" value="#serializeJSON(body)#">
	</cfhttp>

	<cfset apiResult = deserializeJSON(result.fileContent)>
	<cfdump var="#apIResult#" expand="false">

	<h2>Result</h2>
	<cfoutput>
	#md2HTML(apiResult.candidates[1].content.parts[1].text)#
	</cfoutput>
</cfif>