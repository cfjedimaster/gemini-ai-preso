
import { GoogleAIFileManager } from "@google/generative-ai/server";
import { GoogleGenerativeAI } from "@google/generative-ai";
import fs from 'fs';
import slugify from '@sindresorhus/slugify';

const MODEL_NAME = "gemini-1.5-pro";
const API_KEY = process.env.GEMINI_API_KEY;

async function processImage(img) {
  const genAI = new GoogleGenerativeAI(API_KEY);
  const model = genAI.getGenerativeModel({ model: MODEL_NAME });
  const fileManager = new GoogleAIFileManager(API_KEY);

  const uploadResult = await fileManager.uploadFile(img,
	{
	  mimeType: "image/*"
	},
  );


  const result = await model.generateContent([
	'Describe what you see in this image in one sentence only.', 
	{
	  fileData: {
		fileUri: uploadResult.file.uri, 
		mimeType: uploadResult.file.mimeType
	  }
	}
  ]);

  return result.response.text();
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