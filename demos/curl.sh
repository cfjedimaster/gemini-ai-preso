# Ray, remember to export GEMINI_API_KEY= your secret key
curl \
  -H 'Content-Type: application/json' \
  -d '{"contents":[{"parts":[{"text":"Write a story about a magic backpack"}]}]}' \
  -X POST "https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=$GEMINI_API_KEY"
