const fs = require("fs");
const pdf = require("pdf-parse");

(async () => {
  try {
    // Load the PDF file locally
    const pdfBuffer = fs.readFileSync("TEST2.pdf"); // Ensure TEST2.pdf is in the same directory
    const pdfData = await pdf(pdfBuffer);
    console.log("Extracted Text:", pdfData.text);
  } catch (error) {
    console.error("Error processing local PDF file:", error);
  }
})();
