
const {
  GoogleGenerativeAI
} = require("@google/generative-ai");

const MODEL_NAME = "gemini-2.0-flash";
const API_KEY = process.env.GEMINI_API_KEY;

async function processPrompt(prompt) {
  let genAI = new GoogleGenerativeAI(API_KEY);
  let model = genAI.getGenerativeModel({ model: MODEL_NAME });

  let result = await model.generateContent(prompt);

  return result.response.text();
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