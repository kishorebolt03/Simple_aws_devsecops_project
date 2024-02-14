# deelproject
Interview round II 

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
4. Docker (Container / virtualization)
5. Python3 (Scripting language used in Web application)
6. Terraform (IaC used to create the AWS services)
7. Trivy (Security scanner for IaC and SCA)
8. CircleCI (CI/CD tool)
9. Git and Github (for version control)


### How it works

