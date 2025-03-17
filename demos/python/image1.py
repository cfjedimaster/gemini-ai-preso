import sys
import os
from google import genai

client = genai.Client(api_key=os.environ["GEMINI_API_KEY"])


def processImage(path):
	file_ref = client.files.upload(file=path)
	prompt = 'Describe what you see in this image'
	response = client.models.generate_content(
		model="gemini-2.0-flash", contents=[prompt, file_ref]
	)
	return response.text

if len(sys.argv) == 1:
	print("Pass a path to an image.")
	sys.exit()

file = sys.argv[1]

results = processImage(file)
print(results)
