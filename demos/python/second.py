from google import genai
import os 
import sys

if len(sys.argv) == 1:
	print("Pass a prompt argument... or else!")
	sys.exit()

prompt = sys.argv[1]

client = genai.Client(api_key=os.environ.get("GEMINI_API_KEY"))
response = client.models.generate_content(
    model="gemini-2.0-flash", contents=prompt
)
print(response.text)