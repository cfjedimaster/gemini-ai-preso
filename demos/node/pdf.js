import {
  GoogleGenAI,
  createUserContent,
  createPartFromUri,
} from "@google/genai";

const MODEL_NAME = "gemini-2.0-flash";
const API_KEY = process.env.GEMINI_API_KEY;

const ai = new GoogleGenAI({ apiKey: API_KEY });

async function processDoc(img) {

  const image = await ai.files.upload({
	file: img,
  });

  const result = await ai.models.generateContent({
	model:MODEL_NAME,
	contents: 
	  createUserContent([
		'Write a one paragraph summary of this document, followed by three to four bullet points', 
		createPartFromUri(image.uri, image.mimeType)
	  ])
  })
  
  return result.text;
}

if(process.argv.length < 3) {
  console.log('Pass a path to a PDF.');
  process.exit();
}

(async () => {

  let pdf = process.argv[2];
  console.log(`Asking Gemini about: ${pdf}`);
  let result = await processDoc(pdf);
  console.log(result);

})();