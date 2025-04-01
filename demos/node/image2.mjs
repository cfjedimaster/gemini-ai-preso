import {
  GoogleGenAI,
  createUserContent,
  createPartFromUri,
} from "@google/genai";

import fs from 'fs';
import slugify from '@sindresorhus/slugify';

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
		'Describe what you see in this image in one sentence only.', 
		createPartFromUri(image.uri, image.mimeType)
	  ])
  })
  
  return result.text;
}

(async () => {

	let files = fs.readdirSync('../images');
	for(let i=0; i<files.length; i++) {
		let f = files[i];
		console.log(`Looking at ${f}...`);
		let result = await processImage(`../images/${f}`);
		let ext = f.split('.').pop();
		let newName = slugify(result) + '.' + ext;
		console.log(`Will save to: ${newName}`);
	};

})();