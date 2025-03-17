import sys
import os
from google import genai
from slugify import slugify

client = genai.Client(api_key=os.environ["GEMINI_API_KEY"])


def processImage(path):
	file_ref = client.files.upload(file=path)
	prompt = 'Describe what you see in this image in one sentence only.'
	response = client.models.generate_content(
		model="gemini-2.0-flash", contents=[prompt, file_ref]
	)
	return response.text

files = os.listdir('../images')

for file in files:
	print(f"Looking at {file}...")	
	
	result = processImage(f"../images/{file}")
	ext = file.split('.').pop()
	newName = f"{slugify(result)}.{ext}"
	print(f"Will save to: {newName}")

