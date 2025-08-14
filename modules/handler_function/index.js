const AWS = require('aws-sdk');
const sns = new AWS.SNS();

exports.handler = async (event) => {
    try {
        console.log("Event: ", JSON.stringify(event, null, 2));

        // Get bucket name and object key from S3 event
        const bucketName = event.Records[0].s3.bucket.name;
        const objectKey = decodeURIComponent(event.Records[0].s3.object.key.replace(/\+/g, " "));

        console.log(`Bucket: ${bucketName}`);
        console.log(`Object Key: ${objectKey}`);

        // Publish to SNS
        const params = {
            Message: `New object uploaded: ${objectKey} in bucket: ${bucketName}`,
            TopicArn: process.env.SNS_TOPIC_ARN
        };

        await sns.publish(params).promise();
        console.log("Message published to SNS");

        return { statusCode: 200, body: "Success" };
    } catch (error) {
        console.error("Error: ", error);
        throw error;
    }
};
