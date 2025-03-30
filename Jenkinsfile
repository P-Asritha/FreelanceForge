pipeline {
    agent any

    parameters {
        choice(name: 'ENV', choices: ['dev', 'qa'], description: 'Choose the environment to deploy')
    }

    environment {
        AWS_ACCESS_KEY_ID = credentials('aws-credentials')
        AWS_SECRET_ACCESS_KEY = credentials('aws-credentials')
        SSH_KEY = credentials('ssh-private-key')
        SLACK_WEBHOOK_URL = credentials('SLACK_WEBHOOK')
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/P-Asritha/FreelanceForge.git'
            }
        }

        stage('Build Docker Images') {
            steps {
                sh 'docker build --platform linux/amd64 -t freelanceforge-client ./client'
                sh 'docker build --platform linux/amd64 -t freelanceforge-api ./api'
            }
        }

        stage('Tag & Push Images to ECR') {
            steps {
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: 'aws-credentials'
                ]]) {
                    sh '''
                        aws ecr-public get-login-password --region us-east-1 | docker login --username AWS --password-stdin public.ecr.aws
                        docker tag freelanceforge-client public.ecr.aws/c3t3f9g9/freelanceforge-client:latest
                        docker tag freelanceforge-api public.ecr.aws/c3t3f9g9/freelanceforge-api:latest
                        docker push public.ecr.aws/c3t3f9g9/freelanceforge-client:latest
                        docker push public.ecr.aws/c3t3f9g9/freelanceforge-api:latest
                    '''
                }
            }
        }

        stage('Remote Deploy to EC2') {
            steps {
                withCredentials([sshUserPrivateKey(credentialsId: 'ssh-private-key', keyFileVariable: 'SSH_KEY')]) {
                    script {
                        if (params.ENV == 'dev') {
                            echo '🚀 Deploying to DEV server...'
                            sh "ssh -i ${SSH_KEY} -o StrictHostKeyChecking=no ec2-user@54.235.10.152 'bash ~/run-docker.sh'"
                        } else if (params.ENV == 'qa') {
                            echo '🚀 Deploying to QA server...'
                            sh "ssh -i ${SSH_KEY} -o StrictHostKeyChecking=no ec2-user@54.166.163.248 'bash ~/run-docker.sh'"
                        }
                    }
                }
            }
        }
    }

    post {
        success {
            withCredentials([string(credentialsId: 'SLACK_WEBHOOK', variable: 'SLACK_WEBHOOK_URL')]) {
                sh 'curl -X POST -H \'Content-type: application/json\' --data \'{"text":"✅ *FreelanceForge ${ENV.toUpperCase()} Deployment Successful!*"}\' $SLACK_WEBHOOK_URL'
            }
        }
        failure {
            withCredentials([string(credentialsId: 'SLACK_WEBHOOK', variable: 'SLACK_WEBHOOK_URL')]) {
                sh 'curl -X POST -H \'Content-type: application/json\' --data \'{"text":"❌ *FreelanceForge ${ENV.toUpperCase()} Deployment Failed!*"}\' $SLACK_WEBHOOK_URL'
            }
        }
    }
}
