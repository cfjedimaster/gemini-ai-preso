<cfinclude template="utils.cfm">

<!---
Remember to say you used the Curl code
--->
<cfscript>
model_id = "gemini-2.5-flash";
//generate_content_api="streamGenerateContent";
generate_content_api="generateContent";

body = {
    "contents": [
      {
        "role": "user",
        "parts": [
          {
            "text": "why are cats so much better than dogs?"
          },
        ]
      },
    ],
    "generationConfig": {
      "thinkingConfig": {
        "thinkingBudget": 0,
      },
    },
}
</cfscript>

<cfhttp url="https://generativelanguage.googleapis.com/v1beta/models/#model_id#:#generate_content_api#?key=#application.GEMINI_API_KEY#"
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