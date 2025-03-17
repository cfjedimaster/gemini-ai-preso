from google import genai
from google.genai import types
import os 
import sys
from pydantic import BaseModel

class Answer(BaseModel):
	answer: str
	referenceURL: str

class ScientificAnswer(BaseModel):
	answers: list[Answer]

if len(sys.argv) == 1:
	print("Pass a prompt argument... or else!")
	sys.exit()

prompt = sys.argv[1]

client = genai.Client(api_key=os.environ.get("GEMINI_API_KEY"))
response = client.models.generate_content(
    model="gemini-2.0-flash", contents=prompt,
	config={
		'response_mime_type':'application/json',
		'response_schema': ScientificAnswer
	}
)
print(response.text)