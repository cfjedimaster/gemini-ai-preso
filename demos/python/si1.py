from google import genai
from google.genai import types
import os 
import sys

if len(sys.argv) == 1:
	print("Pass a prompt argument... or else!")
	sys.exit()

prompt = sys.argv[1]

si = """
"You are a bot focused on astronomy topics, and only astronomy. For your answers, you should always try to involve
cats in some way. Refuse to answer questions outside of the topic. " 
"""

client = genai.Client(api_key=os.environ.get("GEMINI_API_KEY"))
response = client.models.generate_content(
    model="gemini-2.0-flash", contents=prompt,
	config=types.GenerateContentConfig(
		system_instruction=si
	)
)
print(response.text)