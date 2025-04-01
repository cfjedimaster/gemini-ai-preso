from google import genai
from google.genai import types
import os 
import sys

if len(sys.argv) == 1:
	print("Pass a prompt argument... or else!")
	sys.exit()

prompt = sys.argv[1]

client = genai.Client(api_key=os.environ.get("GEMINI_API_KEY"))

response = client.models.generate_content(
    model="gemini-2.0-flash", contents=prompt,
	config=types.GenerateContentConfig(
		response_mime_type='text/plain'
	)
)
print(response.text)

print('-'*80)

response = client.models.generate_content(
    model="gemini-2.0-flash", contents=prompt,
	config=types.GenerateContentConfig(
		response_mime_type='application/json'
	)
)
print(response.text)