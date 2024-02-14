# Sample DevSecOps project 

### Problem Statement
```
Take-Home Assignment: DevSecOps Engineer
Write a simple web application in any language that prints the origin public IP of any request it receives in reverse:
e.g. if my IP is 1.2.3.4 it should be printed as 4.3.2.1.
Create a simple CI/CD pipeline to build the docker image for your app and deploy the application. You can deploy it wherever you are comfortable ( Kubernetes \ VM \ Managed service ).
The pipeline should include infrastructure as code (IaC) for environment setup, and security checks for IaC misconfigurations and secrets exposure scanning.
(you can sign up to GCP/AWS and use a free tier quota which should be more than enough).
  
Please share with us the repository with app source code + CI\CD and any other details you think may be important to your implementation
Note:
Feel free to use any tools or technologies you are comfortable with, and ensure that your solution is well-documented and easily understandable.
```

### Tech stack used
1. AWS Lambda (Application runs in the lambda)
2. AWS API gateway (API proxy)
3. AWS ECR (Container image registry)
4. AWS Cloudwatch Logs (Logging)
5. Docker (Container / virtualization)
6. Python3 (Scripting language used in Web application)
7. Terraform (IaC used to create the AWS services)
8. Trivy (Security scanner for IaC and SCA)
9. CircleCI (CI/CD tool)
10. Git and Github (for version control)


### Application code: 

Programming language : Python3
File Path: Repository/printIP/lambda_function.py

Results:
1. Open the below link in browser
     - https://7rgwvfza7f.execute-api.us-east-1.amazonaws.com/prod/printIP
       
2. cURL command:
Request:
  ```sh
    curl https://7rgwvfza7f.execute-api.us-east-1.amazonaws.com/prod/printIP
  ```
Response:
  ```sh
  $ curl https://7rgwvfza7f.execute-api.us-east-1.amazonaws.com/prod/printIP
  "Requester IP address: 14.194.85.42\n IP address in Reverse: 42.85.194.14"
  ```

### CI/CD pipeline: 

CI/CD tool: CircleCI
Configuration file: Repository/.circleci/config

Details:

1. Total three jobs:
    1. Trivy security scanner
    2. Build docker image and push to ECR
    3. Deploy application using terraform commands



### Infrastructure as Code (IaC): 
Iac Tool : terraform
Config path : Repository/.terraform/

Commands:
```sh
$ terraform init #Initiate the terraform in the respective directory
$ terraform plan -out plan.out #shows you what Terraform will do before it actually does it.
$ terraform apply plan.out #Perform the changes

```

### Security checks: 

1. Branch restriction for triggering the pipeline
2. Rate limiting API gateway to restrict from unnecessary DOS / DDOS attacks.
3. Strict IAM policy
4. Secured sensitive information in Environmental variabled of CircleCI. 
5. Trivy in CI/CD for Dependency scan, IaC secrets and misconfig scan.



## More information

1. Below attached is the architecture diagram of this project. 

![image](https://github.com/kishorebolt03/deelproject/assets/45748742/8f78f6c3-6a2c-413f-b5e2-df63b8e57cf6)

From the above diagram we can understand the below:

User POV
  1. When users hit the URL, the API gateway calls the Lambda function.
  2. The Lambda function will process the invocation event, fetch the IP address and display it in reverse.

Developer POV
  1. Developer pushes the code in to Github.
  2. Github hooks will trigger the CircleCI workflows.
  3. In CI/CD, The Trivy scan runs to identify any secrets, misconfigurations, dependency check and vulnerabilities. Using this data we can take necessary actions on security the application.
  4. Once the Trivy scan is successful, the build image job runs. Here, A new docker image is created which will have the updated code base and environmental variables. And push the new image into AWS ECR. 
  5. Terraform is a IaC tool used to automate the AWS resource creation and updation process and manage the AWS services.
  6. AWS Lambda, AWS API Gateway, AWS cloudwatch log group are created using terraform.

