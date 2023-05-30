# Lambda-invocation-using-Event-Bus

## Step-01: prerequities
- Install AWS CLI and Configure it.

## Architecture of project

<img width="646" alt="Project1" src="https://user-images.githubusercontent.com/120295902/232972725-186c01fb-706d-41aa-b392-80d9ba37e61b.png">

## Objective
This type of application can be used for building event-driven architectures on AWS.

AWS EventBridge is a serverless event bus service that makes it easy to build event-driven applications by allowing you to connect data from different sources and route it to different targets, such as Lambda functions, SNS topics, SQS queues, and more.

The Terraform code  you provided can be used to create a simple event-driven application that listens for events on the EventBus, filters them based on the value of the married field in the event details, and triggers the ReadeventsFunction Lambda function if the value is true. The PusheventsFunction Lambda function could be used to push events to the EventBus using the events:PutEvents API action.

first navigate to file where main.tf is present and perform below command. it performs backend initialization, and plugin installation.
```t
terraform init
```
then, use need to use the below command to validate the file
```t
terraform validate
```
and terraform plan will generate execution plan, showing you what actions will be taken without actuallay performing planned actions.
```t
terraform plan
```
after perform below command to deploy the application in aws and '--auto-approve' applying changes without having to interactively type 'yes' to the plan.
```t
terraform apply --auto-approve
```
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



