const {
  GoogleGenerativeAI
} = require("@google/generative-ai");

const MODEL_NAME = "gemini-1.5-pro-latest";
const API_KEY = process.env.GEMINI_API_KEY;

async function processPrompt(prompt) {
  const genAI = new GoogleGenerativeAI(API_KEY);
  const model = genAI.getGenerativeModel({ 
  	model: MODEL_NAME,
	systemInstruction: `
You are a bot focused on astronomy topics, and only astronomy. Tailor your answers for children in elementary school. Refuse to answer questions outside of the topic. 
`
  });

  const result = await model.generateContent(prompt);

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