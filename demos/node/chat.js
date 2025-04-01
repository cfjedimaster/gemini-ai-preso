
import readline from 'readline';
import { styleText } from 'node:util';
import { GoogleGenAI } from "@google/genai";

const MODEL_NAME = "gemini-2.0-flash";
const API_KEY = process.env.GEMINI_API_KEY;

const ai = new GoogleGenAI({ apiKey: API_KEY });
let chat = null;

async function callGemini(text) {

	if(!chat) {

		chat = ai.chats.create({
			model: MODEL_NAME,
			history: [
			],
		});
		

	}

	const result = await chat.sendMessage({message:text});
	return result.text;
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