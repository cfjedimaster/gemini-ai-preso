<!---
Ray, before you show this, be sure to show chat code from AI Studio.
--->
<cfscript>
model_id = "gemini-2.5-flash";

/*
I take an array of items that look like so:

{
 "role":"user OR model", 
 "parts": [
	"text":"what they said"
 ]
}

*/
function chat(chatHistory) {
	var result = "";

	var body = {
		"contents": chatHistory,
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

</cfscript>

<cfparam name="form.history" default="">

<cfset history = []>
<cfif isJSON(form.history)>
	<cfset history = deserializeJSON(form.history)>
</cfif>

<cfif structKeyExists(form, "newMessage") and len(trim(form.newMessage))>
	<cfset newChat = {
		"role":"user",
		"parts": [
			{"text":form.newMessage}
		]
	}>
	<cfset arrayAppend(history, newChat)>
	<cfset result = chat(history)>
	<cfif structKeyExists(result, "error")>
		<cfoutput>
		<p>Sorry, Google messed up. Try again.</p>
		</cfoutput>
	<cfelse>
		<cfset arrayAppend(history, result.candidates[1].content)>
	</cfif>
</cfif>

<cfset chat = "">
<cfif arrayLen(history)>
	<cfloop index="x" from="1" to="#arrayLen(history)#">
		<cfset chat = chat & history[x].role & " said: " & history[x].parts[1].text & chr(10) & chr(10)>
	</cfloop>
</cfif>


<h2>Chat</h2>
<cfoutput>
<form method="post" action="chat.cfm">
<textarea style="width:500px;height:500px">
#chat#
</textarea>
<input type="hidden" name="history" value="#encodeForHTMLAttribute(serializeJSON(history))#">
<p>
<input type="text" name="newMessage" style="width:450px"> <input type="submit">
</p>
</form>
</cfoutput>