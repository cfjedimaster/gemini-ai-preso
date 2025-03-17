from google import genai
import os 
import sys

class bcolors:
    HEADER = '\033[95m'
    OKBLUE = '\033[94m'
    OKCYAN = '\033[96m'
    OKGREEN = '\033[92m'
    WARNING = '\033[93m'
    FAIL = '\033[91m'
    ENDC = '\033[0m'
    BOLD = '\033[1m'
    UNDERLINE = '\033[4m'

client = genai.Client(api_key=os.environ.get("GEMINI_API_KEY"))
chat = client.chats.create(model="gemini-2.0-flash")

def callGemini(str):
	return (chat.send_message(str)).text

print("Type 'quit' to, well, quit.\n")

prompt = ""
while prompt != "quit":
	prompt = input(f"{bcolors.OKBLUE}Your question: ")
	response = callGemini(prompt)
	print(f"{bcolors.OKGREEN}Gemini says: {response}")
