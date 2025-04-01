import { GoogleGenAI } from "@google/genai";

const MODEL_NAME = "gemini-2.0-flash";
const API_KEY = process.env.GEMINI_API_KEY;

const ai = new GoogleGenAI({ apiKey: API_KEY });

async function processPrompt(prompt) {

  const response = await ai.models.generateContent({
    model: "gemini-2.0-flash",
    contents: prompt,
    config: {
      systemInstruction: `
You are a bot focused on astronomy topics, and only astronomy. For your answers, you should always try to involve
cats in some way. Refuse to answer questions outside of the topic. 
`
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
  console.log(`Generating response for prompt: ${prompt}`);
  let result = await processPrompt(prompt);
  console.log(result);

})();