# Resume Website CI/CD Pipeline on AWS

## Author
**Tommy Phuong**

## Overview
This project demonstrates a fully automated **CI/CD pipeline** on AWS for deploying a personal resume website. The pipeline integrates:

- **GitHub** as the source code repository
- **AWS CodeBuild** for building artifacts
- **AWS CodeDeploy** for deploying to an EC2 instance
- **Amazon EC2** hosting for the website
- Optional monitoring via **AWS CloudWatch**

The website displays my professional resume and personal projects.

---

## Architecture

GitHub Repository
|
v
AWS CodePipeline (Pipeline)
|
v
AWS CodeBuild (Build Stage)
|
v
Artifact Storage (S3)
|
v
AWS CodeDeploy (Deploy Stage)
|
v
EC2 Instance


**Diagram Placeholder:**  


---

## File Structure

resume-site/
├── .gitignore
├── buildspec.yml
├── appspec.yml
├── index.html
├── style.css
├── script.js
├── README.md
└── scripts/
├── before_install.sh
├── after_install.sh
└── start_server.sh


- **buildspec.yml** – Defines CodeBuild build commands and artifacts.  
- **appspec.yml** – Defines CodeDeploy deployment instructions and lifecycle hooks.  
- **scripts/** – Contains deployment hook scripts for installing dependencies, copying files, and starting the web server.  

---

## Pipeline Setup Instructions

### 1. Prepare the EC2 Instance
1. Launch an Amazon Linux 2023 EC2 instance.
2. Create an **IAM role** for the instance:
   - Policies: `AmazonS3ReadOnlyAccess`, `AWSCodeDeployAgentAccess`
   - Attach the role to your EC2 instance.
3. Install the CodeDeploy agent:
   ```bash
   sudo dnf update -y
   sudo dnf install -y ruby wget
   cd /home/ec2-user
   wget https://aws-codedeploy-<REGION>.s3.<REGION>.amazonaws.com/latest/install
   chmod +x ./install
   sudo ./install auto
   sudo systemctl start codedeploy-agent
   sudo systemctl enable codedeploy-agent
2. Configure IAM Roles
a. CodePipeline Role
Trusted entity: codepipeline.amazonaws.com

Policies:

AWSCodePipelineFullAccess

AWSCodeBuildDeveloperAccess

AWSCodeDeployFullAccess

AmazonS3FullAccess

b. CodeBuild Role
Trusted entity: codebuild.amazonaws.com

Policies:

AWSCodeBuildAdminAccess

AmazonS3FullAccess

CloudWatchLogsFullAccess

c. CodeDeploy Role
Trusted entity: codedeploy.amazonaws.com

Policies:

AWSCodeDeployRole

CloudWatchLogsFullAccess

3. Setup CodePipeline
Go to AWS CodePipeline → Create Pipeline.

Choose pipeline name (e.g., ResumeWebsitePipeline) and existing CodePipeline service role.

Source Stage: GitHub repository (connect via OAuth), select branch (e.g., main), enable webhook.

Build Stage: CodeBuild project, use buildspec.yml.

Deploy Stage: CodeDeploy application targeting your EC2 instance, with the appspec.yml included in artifacts.

4. Deployment Scripts
before_install.sh
bash
Copy code
#!/bin/bash
echo "Running BeforeInstall..."
sudo dnf update -y
sudo dnf install -y httpd
sudo systemctl enable httpd
sudo systemctl start httpd
sudo rm -rf /var/www/html/*
after_install.sh
bash
Copy code
#!/bin/bash
echo "Running AfterInstall..."
sudo cp -r /opt/codedeploy-agent/deployment-root/*/deployment-archive/* /var/www/html/
sudo chown -R ec2-user:ec2-user /var/www/html
start_server.sh
bash
Copy code
#!/bin/bash
echo "Running ApplicationStart..."
sudo systemctl restart httpd
Maintenance Steps
Adding new content:

Update index.html, style.css, or script.js.

Commit and push to GitHub. The pipeline will automatically deploy changes.


Cleaning up resources:

Delete the CodePipeline, CodeBuild project, CodeDeploy application, and EC2 instance if no longer needed to avoid charges.

Troubleshooting
Issue	Cause	Solution
ApplicationStart ScriptFailed	Apache not installed or wrong service	Install Apache (sudo dnf install -y httpd) and update start_server.sh
Deployment fails at ApplicationStop	Script missing or unnecessary	Remove ApplicationStop hook or ensure script exists with execute permissions
Pipeline fails on CodeBuild	Incorrect buildspec.yml commands	Ensure artifacts and files paths are correct, include all files
Webpage not showing changes	Cached old files	Clear browser cache or ensure /var/www/html updated correctly

References
AWS CodeCommit Setup

AWS CodePipeline Tutorials

AWS CodeDeploy Tutorials