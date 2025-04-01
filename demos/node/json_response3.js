
import { GoogleGenAI, Type } from "@google/genai";

const MODEL_NAME = "gemini-2.0-flash";
const API_KEY = process.env.GEMINI_API_KEY;
const ai = new GoogleGenAI({ apiKey: API_KEY });

async function processPrompt(prompt) {

  const response = await ai.models.generateContent({
    model: 'gemini-2.0-flash',
    contents: prompt,
    config: {
      responseMimeType: 'application/json',
      responseSchema: {
        type: Type.ARRAY,
        items: {
          type: Type.OBJECT,
          properties: {
            'answer':{
              type: Type.STRING,
              description: 'Answer to the question',
              nullable: false,
            },
            'sources': {
              type: Type.ARRAY,
              items: {
                type: Type.STRING,                
                description: 'A link to the resource',
              },
              nullable: false,
            },
          },
          required: ['answer'],
        },
      },
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
  
  console.log(`Generating JSON response for prompt: ${prompt}`);
  let result = await processPrompt(prompt);
  console.log(result);
  
})();