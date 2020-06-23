
# Jenkins-Maven-Terraform


### Instructions to use the project

**Pre-Requisites:**

1. Docker
2. Terraform
3. You're ready to go!

**Steps**:

1. Run `docker build -t customjenkins:latest .`
2. Run `docker run -d --restart-always -p 50000:50000 -p 8080:8080 --name jenkins customjenkins:latest`
3. Open localhost:8080 in your browser and paste the output of `docker exec -it jenkins cat /var/lib/jenkins/home/secrets/initialAdminPassword` in the initial jenkins setup.
4. Install the default plugins and once done go to manage plugins and add the "AWS Global Configuration" plugin and install it.
5. Make a new global credential with the type AWS and paste in your AWS Account Access Key and Secret.
6. Make a new Jenkins Pipeline and use the Jenkinsfile.jenkinsfile provided in the repo as pipeline code.
7. Run terraform init on your machine and then terraform apply.
8. Run the pipeline, which will checkout a simple hello-world maven project and deploy the image on AWS ECS (Fargate)
9. Go to your AWS Console and update the ECS service and access your Maven WebApp from the task's public IP. 
