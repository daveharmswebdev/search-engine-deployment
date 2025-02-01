const axios = require("axios");
const headers = { "Content-Type": "application/json" };

const host = process.env.OPENSEARCH_HOST; // OpenSearch domain URL
const index = process.env.OPENSEARCH_INDEX || "mygoogle"; // OpenSearch index

const getFromSearch = async (query) => {
  const url = `${host}/${index}/_search`;

  try {
    const response = await axios.post(url, query, {
      headers,
      auth: {
        username: process.env.OPENSEARCH_USERNAME, // OpenSearch username (if required)
        password: process.env.OPENSEARCH_PASSWORD, // OpenSearch password (if required)
      },
    });
    return response.data; // Returns the OpenSearch response data
  } catch (error) {
    console.error("Error querying OpenSearch:", error.message);
    throw new Error(
      "Unable to retrieve search results. Check OpenSearch configuration.",
    );
  }
};

exports.handler = async (event) => {
  try {
    console.log("Event received:", JSON.stringify(event)); // Log the full event for debugging

    // Parse the JSON body directly
    const requestBody = JSON.parse(event.body);
    console.log("Parsed request body:", requestBody); // Log the parsed JSON body

    // Validate and extract the search term array from the request body
    const searchTermArr = requestBody.searchTerm;
    console.log("Search Term Array:", searchTermArr); // Log the extracted search term array

    if (
      !searchTermArr ||
      !Array.isArray(searchTermArr) ||
      searchTermArr.length === 0
    ) {
      throw new Error("Search term is missing.");
    }

    // Use the first search term for the query
    const searchTerm = searchTermArr[0];
    console.log("Search term:", searchTerm);

    // Construct the OpenSearch query
    const query = {
      size: 25,
      query: {
        multi_match: {
          query: searchTerm,
          fields: ["Title", "Author", "Date", "Body"],
        },
      },
      fields: ["Title", "Author", "Date", "Summary"],
    };

    console.log("Sending query to OpenSearch...", query);
    const searchResponse = await getFromSearch(query);

    console.log("Search response:", JSON.stringify(searchResponse));

    // Map search results and extract relevant data
    const hits = searchResponse.hits?.hits || [];
    const results = hits.map((hit) => ({
      title: hit._source.Title,
      author: hit._source.Author,
      date: hit._source.Date,
      summary: hit._source.Summary,
    }));

    console.log("Final results:", JSON.stringify(results));

    // Successfully return the results
    return {
      statusCode: 200,
      headers: {
        "Content-Type": "application/json",
        "Access-Control-Allow-Origin": "*", // Modify based on your CORS policy
      },
      body: JSON.stringify(results),
    };
  } catch (error) {
    console.error("Error processing request:", error.message);

    // Return an error response
    return {
      statusCode: 500,
      headers: {
        "Content-Type": "application/json",
        "Access-Control-Allow-Origin": "*", // Modify based on your CORS policy
      },
      body: JSON.stringify({
        error: error.message || "Internal server error",
      }),
    };
  }
};
