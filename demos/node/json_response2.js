
const {
  GoogleGenerativeAI
} = require("@google/generative-ai");

const MODEL_NAME = "gemini-1.5-pro-latest";
const API_KEY = process.env.GEMINI_API_KEY;

async function processPrompt(prompt, mimetype="text/plain") {
  const genAI = new GoogleGenerativeAI(API_KEY);
  const model = genAI.getGenerativeModel({ model: MODEL_NAME });

  const generationConfig = {
    temperature: 1,
    topK: 0,
    topP: 0.95,
    maxOutputTokens: 8192,
    response_mime_type:mimetype

  };

  const parts = [
    {text: `
    For the prompt given below, your answer should be returned in a JSON array with each
    array element containing a summary and a link to research that backs it up. The result
    should look like this:

    [
      { reason: "reason here", link: "link to a reference" }
    ]
    
    Prompt: ${prompt}
    `}];

  const result = await model.generateContent({
    contents: [{ role: "user", parts }],
    generationConfig,
  });

  const response = result.response;
  return response.text();
}

if(process.argv.length < 3) {
  console.log('Pass a prompt argument... or else!');
  process.exit();
}

(async () => {

  let prompt = process.argv[2];
  
  console.log(`Generating JSON response for prompt: ${prompt}`);
  result = await processPrompt(prompt,'application/json');
  console.log(result);
  
})();