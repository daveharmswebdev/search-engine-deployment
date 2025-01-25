const lambda = require("./index");

const mockS3Event = {
  Records: [
    {
      s3: {
        bucket: {
          name: "pdf-bucket-cpnf2ube1t5m",
        },
        object: {
          key: "TEST2.pdf",
        },
      },
    },
  ],
};

lambda
  .handler(mockS3Event)
  .then((result) => {
    console.log(result);
  })
  .catch((err) => {
    console.log(err);
  });
