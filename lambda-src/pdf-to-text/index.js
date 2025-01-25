const {
  S3Client,
  GetObjectCommand,
  PutObjectCommand,
} = require("@aws-sdk/client-s3");
const pdf = require("pdf-parse");

const s3 = new S3Client({ region: "us-east-2" });

// Helper function: Stream to Buffer
const streamToBuffer = async (stream) => {
  const chunks = [];
  for await (const chunk of stream) {
    chunks.push(chunk);
  }
  return Buffer.concat(chunks);
};

// Lambda handler
exports.handler = async (event) => {
  try {
    console.log("Received event: ", JSON.stringify(event, null, 2));

    // Retrieve bucket name and file key from the event
    const bucketName = event.Records[0].s3.bucket.name;
    const pdfKey = event.Records[0].s3.object.key;

    console.log(`Processing file: ${pdfKey} from bucket: ${bucketName}`);

    // Step 1: Download the PDF file from S3
    const getObjectParams = {
      Bucket: bucketName,
      Key: pdfKey,
    };

    const pdfResponse = await s3.send(new GetObjectCommand(getObjectParams));
    const pdfBuffer = await streamToBuffer(pdfResponse.Body);

    // Debugging: Output details about the file buffer
    console.log("PDF Buffer Length:", pdfBuffer.length);
    console.log(
      "PDF Start (Hex Dump):",
      pdfBuffer.slice(0, 20).toString("hex"),
    );
    console.log("PDF Start (ASCII):", pdfBuffer.slice(0, 20).toString());

    // Check if the file has a valid PDF header
    if (!pdfBuffer.slice(0, 5).toString().startsWith("%PDF")) {
      throw new Error("File does not start with a valid PDF header");
    }

    // Step 2: Parse the PDF content using pdf-parse
    const pdfData = await pdf(pdfBuffer);
    console.log("Extracted Text:", pdfData.text);

    // Step 3: Save the extracted text back to S3
    const textKey = pdfKey.replace(".pdf", ".txt");
    const putObjectParams = {
      Bucket: bucketName,
      Key: textKey,
      Body: pdfData.text,
      ContentType: "text/plain",
    };

    await s3.send(new PutObjectCommand(putObjectParams));

    console.log(`Successfully saved extracted text to ${textKey}`);

    return {
      statusCode: 200,
      body: JSON.stringify({
        message: `Successfully extracted text from ${pdfKey} and saved to ${textKey}`,
      }),
    };
  } catch (error) {
    console.error("Error processing file:", error);
    return {
      statusCode: 500,
      body: JSON.stringify({
        message: `Error processing file: ${error.message}`,
      }),
    };
  }
};
