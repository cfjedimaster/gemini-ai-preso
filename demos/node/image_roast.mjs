
import { GoogleAIFileManager } from "@google/generative-ai/server";
import { GoogleGenerativeAI } from "@google/generative-ai";

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
	'Roast what you see in this picture, but the contents of the picture as well as how the picture was taken.', 
	{
	  fileData: {
		fileUri: uploadResult.file.uri, 
		mimeType: uploadResult.file.mimeType
	  }
	}
  ]);

  return result.response.text();
}

if(process.argv.length < 3) {
  console.log('Pass a path to an image.');
  process.exit();
}

(async () => {

  let img = process.argv[2];
  console.log(`Asking Gemini to roast: ${img}`);
  let result = await processImage(img);
  console.log(result);

})();