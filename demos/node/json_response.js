import { GoogleGenAI } from "@google/genai";

const MODEL_NAME = "gemini-2.0-flash";
const API_KEY = process.env.GEMINI_API_KEY;
const ai = new GoogleGenAI({ apiKey: API_KEY });

async function processPrompt(prompt, mimetype="text/plain") {

  const response = await ai.models.generateContent({
    model: MODEL_NAME,
    contents: prompt,
    config: {
      responseMimeType:mimetype
      },
  });

  return response.text;
}

if(process.argv.length < 3) {
  console.log('Pass a prompt argument... or else!');
  process.exit();
}

(async () => {

  let prompt = process.argv[2];
  console.log(`Generating text response for prompt: ${prompt}`);
  let result = await processPrompt(prompt);
  console.log(result);
  console.log('-'.repeat(50));
  
  console.log(`Generating JSON response for prompt: ${prompt}`);
  result = await processPrompt(prompt,'application/json');
  console.log(result);
  
})();