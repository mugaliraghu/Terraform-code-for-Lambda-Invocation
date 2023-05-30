# Lambda-invocation-using-Event-Bus

## Step-01: prerequities
- Install AWS CLI
- Install SAM ClI

## Architecture of project

<img width="646" alt="Project1" src="https://user-images.githubusercontent.com/120295902/232972725-186c01fb-706d-41aa-b392-80d9ba37e61b.png">

## Objective
This type of application can be used for building event-driven architectures on AWS.

AWS EventBridge is a serverless event bus service that makes it easy to build event-driven applications by allowing you to connect data from different sources and route it to different targets, such as Lambda functions, SNS topics, SQS queues, and more.

The CloudFormation template you provided can be used to create a simple event-driven application that listens for events on the EventBus, filters them based on the value of the married field in the event details, and triggers the ReadeventsFunction Lambda function if the value is true. The PusheventsFunction Lambda function could be used to push events to the EventBus using the events:PutEvents API action.

after that navigate to the file where SAM application template.yaml file is presenet and do

```
sam build
```
![sam build](https://user-images.githubusercontent.com/120295902/227849500-7a29951b-085b-42dc-9860-8b88fe9e9ae4.png)

In the next step use this below command to deploy the application on aws
```
sam deploy --guided
```
It will ask some information like cloudFormation Name, region and some other as shown in below image.
![sam deploy](https://user-images.githubusercontent.com/120295902/227849843-31055851-72ac-495a-b4db-3939aa7e3247.png)

After that it will create the things that you added in templates.yaml like Lambda Functions,EventBridge.EventBus,IAM rule and Permissions as shown in below image.
![sam deploy output](https://user-images.githubusercontent.com/120295902/227850335-a436d645-acb0-4e4e-a52f-6f5c51dfe6e1.png)

And check cloudFormation Stack, in that we will get our stack with the name that we have given in the time of sam deploy. inside that in resource section we will get the details of our Lambda Function, EventBus, EventBridge, IAm role And permissions.
As shown in below image.
![cloudFormation resource](https://user-images.githubusercontent.com/120295902/227856072-12b3677b-407a-41ca-8871-739dfe3fa1eb.png)


after that go to the pushEventFunction Lambda Function and in the TEST field add json file as shown in the below image.
```
{
  "name": "Name",
  "salary": "50000",
  "married": "true"
}
```
then Test the appllication with the filter as we given in EventRule. Check the ReadEvents Lambda Function monitor section, in that view CloudWatch logs section if we see the outputs, it will show like this.

![CloudWatch logs](https://user-images.githubusercontent.com/120295902/227856581-f214f5a3-ad6a-46df-9df2-b07d2e71f1a1.png)

and after test with the below json file
```
{
  "name": "Name",
  "salary": "50000",
  "married": "false"
}
```
it has not to show the output in CloudWatch logs section, then the filter is working properly and code also working as we expected. check in the below image it was showing like there is no newer events.
![CloudWatch logs](https://user-images.githubusercontent.com/120295902/227856581-f214f5a3-ad6a-46df-9df2-b07d2e71f1a1.png)



