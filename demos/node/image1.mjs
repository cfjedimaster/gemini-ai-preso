import {
  GoogleGenAI,
  createUserContent,
  createPartFromUri,
} from "@google/genai";

const MODEL_NAME = "gemini-2.0-flash";
const API_KEY = process.env.GEMINI_API_KEY;

const ai = new GoogleGenAI({ apiKey: API_KEY });

async function processImage(img) {

  const image = await ai.files.upload({
    file: img,
  });

  const result = await ai.models.generateContent({
    model:MODEL_NAME,
    contents: 
      createUserContent([
        'Describe what you see in this image', 
        createPartFromUri(image.uri, image.mimeType)
      ])
  })
  
  return result.text;
}

if(process.argv.length < 3) {
  console.log('Pass a path to an image.');
  process.exit();
}

(async () => {

  let img = process.argv[2];
  console.log(`Asking Gemini about: ${img}`);
  let result = await processImage(img);
  console.log(result);

})();