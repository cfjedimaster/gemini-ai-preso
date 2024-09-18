<cfinclude template="utils.cfm">

<!---
Remember to say you used the Curl code
--->
<cfscript>
body = {
  "contents": [
    {
      "role": "user",
      "parts": [
        {
          "text": "Why is the sky blue, and how are cats involved in that process?"
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
</cfscript>

<cfhttp url="https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-pro:generateContent?key=#application.GEMINI_API_KEY#"
		method="post"
		result="result"
		>
	<cfhttpparam type="header" name="Content-Type" value="application/json">
	<cfhttpparam type="body" value="#serializeJSON(body)#">
</cfhttp>

<cfset apiResult = deserializeJSON(result.fileContent)>
<cfdump var="#apiResult#">

<hr>

<!--- note the markdown --->
<cfoutput>
#md2HTML(apiResult.candidates[1].content.parts[1].text)#
</cfoutput>