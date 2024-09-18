<cfinclude template="utils.cfm">
<cfparam name="form.rss" default="https://www.raymondcamden.com/feed.xml">

<style>
input {
	width: 500px;
}
</style>

<form method="post">
<h2>RSS Feed Summarizer</h2>
<p>
<label for="rss">RSS URL:</label>
<cfoutput><input type="url" id="rss" name="rss" value="#form.rss#"></cfoutput>
</p>
<input type="submit" value="Generate AI Awesomeness">
</form>

<cfif len(form.rss)>

	<cfscript>
	function generateSummary(input) {

		var prompt = "Generate a summary of the following text:\n\n#input#";
		var result = "";

		var body = {
			"contents": [
				{
				"role": "user",
				"parts": [
					{
					"text": prompt
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
	</cfscript>


	<cffeed source="#form.rss#" name="result">

	<!--- summarize just the first three --->
	<cfloop index="x" from="1" to="#min(2, result.entry.len())#">
		<cfset content = result.entry[x].content[1].value>
		<cfoutput>
		<p>
		<b>Summarizing: #result.entry[x].title.value#</b>
		</p>
		</cfoutput>
		<cfflush>

		<cfset summary = generateSummary(content)>
		<cfdump var="#summary#" expand="false">
		<cfif structKeyExists(summary, "candidates") and structKeyExists(summary.candidates[1], "content")>
			<cfoutput>
			#md2HTML(summary.candidates[1].content.parts[1].text)#
			</cfoutput>
		</cfif>
		<hr>
	</cfloop>
</cfif>