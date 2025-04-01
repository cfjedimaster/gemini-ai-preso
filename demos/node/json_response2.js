import { GoogleGenAI } from "@google/genai";

const MODEL_NAME = "gemini-2.0-flash";
const API_KEY = process.env.GEMINI_API_KEY;
const ai = new GoogleGenAI({ apiKey: API_KEY });

async function processPrompt(prompt) {

  prompt = `
    For the prompt given below, your answer should be returned in a JSON array with each
    array element containing a summary and a link to research that backs it up. The result
    should look like this:

    [
      { reason: "reason here", link: "link to a reference" }
    ]
    
    Prompt: ${prompt}
  `;

  const response = await ai.models.generateContent({
    model: MODEL_NAME,
    contents: prompt,
    config: {
      responseMimeType:'application/json'
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

