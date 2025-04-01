import sys
import os
from google import genai

client = genai.Client(api_key=os.environ["GEMINI_API_KEY"])


def processDoc(path):
	file_ref = client.files.upload(file=path)
	prompt = 'Write a one paragraph summary of this document, followed by three to four bullet points'
	response = client.models.generate_content(
		model="gemini-2.0-flash", contents=[prompt, file_ref]
	)
	return response.text

if len(sys.argv) == 1:
	print("Pass a path to the PDF.")
	sys.exit()

file = sys.argv[1]

results = processDoc(file)
print(results)
