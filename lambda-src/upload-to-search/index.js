const AWS = require("@aws-sdk/client-s3");
const axios = require("axios");
const { defaultProvider } = require("@aws-sdk/credential-provider-node");

// Configuration
const region = process.env.REGION;
const host = process.env.OPENSEARCH_DASHBOARD_URL;
const index = process.env.OPENSEARCH_INDEX;
const username = process.env.OPENSEARCH_USERNAME;
const password = process.env.OPENSEARCH_PASSWORD;
const datatype = "_doc"; // OpenSearch datatype
const headers = { "Content-Type": "application/json" };

const s3 = new AWS.S3({ region, credentials: defaultProvider() });

function listToString(bufferList) {
  return bufferList.join("");
}

exports.handler = async (event) => {
  for (const record of event.Records) {
    try {
      // Extract bucket name and object key from event
      const bucket = record.s3.bucket.name;
      const key = record.s3.object.key;

      // Fetch the object from S3
      const s3Object = await s3.getObject({ Bucket: bucket, Key: key });
      const body = await s3Object.Body.transformToByteArray(); // Read S3 file as byte array
      const lines = Buffer.from(body).toString("utf-8").split("\n"); // Convert to string and split into lines

      // Extract metadata and body content
      const custId = key;
      const url = `${host}/${index}/${datatype}/${custId}`;
      const title = lines[0];
      const author = lines[1];
      const date = lines[2];
      const finalBody = lines.slice(3); // Everything after the third line
      const size = finalBody.length;
      const endIndex = Math.floor(size / 10);
      const summary = finalBody.slice(1, 2); // Grab the second line after the split

      // Log extracted information
      console.log("Key:", key);
      console.log("Size:", size);
      console.log("End index:", endIndex);
      console.log("Title:", title);
      console.log("Author:", author);
      console.log("Date:", date);
      console.log("Summary:", summary);

      // Build the document to send to OpenSearch
      const document = {
        Title: title,
        Author: author,
        Date: date,
        Body: listToString(finalBody),
        Summary: summary.join(""),
      };

      // Send the document to OpenSearch using Axios
      const response = await axios.post(url, document, {
        headers,
        auth: { username, password },
      });
      console.log("Response:", response.data);
    } catch (error) {
      console.error("Error processing record:", error);
    }
  }
};
