def awsCredentials = [[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'AWS vedant-cli']]

pipeline {
    agent any
    stages {
        stage('Source Code Checkout') {
            steps {
				git credentialsId: 'Github-Vedant', url: 'https://github.com/vedant15188/maven-project'
            }
        }
		stage('Build') {
            steps {
				sh 'ls -la'
				sh 'docker build -t tomcat:latest .'
            }
        }
        stage('Push to AWS ECR') {
            steps {
				withCredentials(awsCredentials) {
					sh 'aws ecr get-login-password --region ap-south-1 | docker login --username AWS --password-stdin 893529477324.dkr.ecr.ap-south-1.amazonaws.com'
                    sh 'docker tag tomcat:latest 893529477324.dkr.ecr.ap-south-1.amazonaws.com/myrepo:latest'
                    sh 'docker push 893529477324.dkr.ecr.ap-south-1.amazonaws.com/myrepo:latest'
				}
            }
        }
        stage('AWS ECS Update Service') {
            steps {
                withCredentials(awsCredentials) {
                    sh 'aws ecs update-service --cluster MavenCluster --service MavenService --force-new-deployment'
                }
            }
        }
    }
}