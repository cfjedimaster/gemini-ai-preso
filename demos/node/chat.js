const readline = require('readline');
const { styleText } = require('node:util');

const {
  GoogleGenerativeAI,
  HarmCategory,
  HarmBlockThreshold,
} = require("@google/generative-ai");

const MODEL_NAME = "gemini-1.5-pro-latest";
const API_KEY = process.env.GEMINI_API_KEY;

const genAI = new GoogleGenerativeAI(API_KEY);
const model = genAI.getGenerativeModel({ model: MODEL_NAME });
let chat = null;

async function callGemini(text) {

	if(!chat) {
		chat = model.startChat({
			history:[]
		});
	}

	const result = await chat.sendMessage(text);
	//console.log(JSON.stringify(result, null, '\t'));
	return result.response.text();
	
}

// Credit: https://stackoverflow.com/a/50890409/52160
function askQuestion(query) {
    const rl = readline.createInterface({
        input: process.stdin,
        output: process.stdout,
    });

    return new Promise(resolve => rl.question(query, ans => {
        rl.close();
        resolve(ans);
    }))
}

(async () => {

	while(true) {
		let input = await askQuestion('Your input: ');
		process.stdout.write('...working...');
		let resp = await callGemini(input);
		process.stdout.clearLine();
		process.stdout.cursorTo(0);
		console.log(styleText('yellow',`Gemini: ${resp}`));
	}

})();