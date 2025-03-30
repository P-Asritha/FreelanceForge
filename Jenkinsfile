pipeline {
    agent any

    parameters {
        choice(name: 'ENV', choices: ['dev', 'qa'], description: 'Choose the environment to deploy to')
    }

    environment {
        CLIENT_IMAGE = "freelanceforge-client"
        API_IMAGE = "freelanceforge-api"
        AWS_REGION = "us-east-1"
        ECR_REPO_CLIENT = "public.ecr.aws/c3t3f9g9/freelanceforge-client"
        ECR_REPO_API = "public.ecr.aws/c3t3f9g9/freelanceforge-api"
    }

    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/P-Asritha/FreelanceForge.git'
            }
        }

        stage('Build Docker Images') {
            steps {
                sh 'docker build --platform=linux/amd64 -t $CLIENT_IMAGE ./client'
                sh 'docker build --platform=linux/amd64 -t $API_IMAGE ./api'
            }
        }

        stage('Tag & Push Images to ECR') {
            steps {
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: 'aws-credentials'
                ]]) {
                    sh '''
                        aws ecr-public get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin public.ecr.aws
                        docker tag $CLIENT_IMAGE $ECR_REPO_CLIENT:latest
                        docker tag $API_IMAGE $ECR_REPO_API:latest
                        docker push $ECR_REPO_CLIENT:latest
                        docker push $ECR_REPO_API:latest
                    '''
                }
            }
        }

        stage('Remote Deploy to EC2') {
            steps {
                withCredentials([sshUserPrivateKey(credentialsId: 'ssh-private-key', keyFileVariable: 'SSH_KEY')]) {
                    script {
                        def ec2_ip = (params.ENV == 'dev') ? '54.235.10.152' : '18.204.143.100'
                        echo "🚀 Deploying to ${params.ENV.toUpperCase()} server..."
                        sh """ssh -i ${SSH_KEY} -o StrictHostKeyChecking=no ec2-user@${ec2_ip} 'bash ~/run-docker.sh'"""
                    }
                }
            }
        }
    }

    post {
        success {
            withCredentials([string(credentialsId: 'SLACK_WEBHOOK', variable: 'SLACK_WEBHOOK_URL')]) {
                sh '''
                    curl -X POST -H 'Content-type: application/json' --data '{"text":"✅ *FreelanceForge ${ENV.toUpperCase()} Deployment Successful!*"}' $SLACK_WEBHOOK_URL
                '''
            }
        }
        failure {
            withCredentials([string(credentialsId: 'SLACK_WEBHOOK', variable: 'SLACK_WEBHOOK_URL')]) {
                sh '''
                    curl -X POST -H 'Content-type: application/json' --data '{"text":"❌ *FreelanceForge ${ENV.toUpperCase()} Deployment Failed!*"}' $SLACK_WEBHOOK_URL
                '''
            }
        }
    }
}
