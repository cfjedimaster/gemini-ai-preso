from google import genai
from google.genai import types
import os 
import sys

if len(sys.argv) == 1:
	print("Pass a prompt argument... or else!")
	sys.exit()

prompt = sys.argv[1]

prompt = f"""
    For the prompt given below, your answer should be returned in a JSON array with each
    array element containing a summary and a link to research that backs it up. The result
    should look like this:

    [
      {{ reason: "reason here", link: "link to a reference" }}
    ]
    
    Prompt: {prompt}
"""

client = genai.Client(api_key=os.environ.get("GEMINI_API_KEY"))
response = client.models.generate_content(
    model="gemini-2.0-flash", contents=prompt,
	config=types.GenerateContentConfig(
		response_mime_type='application/json'
	)
)
print(response.text)