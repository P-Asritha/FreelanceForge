pipeline {
    agent any

    parameters {
        choice(name: 'ENV', choices: ['dev', 'qa'], description: 'Select the environment to deploy')
    }

    environment {
        ECR_CLIENT = 'public.ecr.aws/c3t3f9g9/freelanceforge-client'
        ECR_API = 'public.ecr.aws/c3t3f9g9/freelanceforge-api'
        DEV_SERVER = 'ec2-user@54.235.10.152'
        QA_SERVER = 'ec2-user@54.166.163.248'
        REGION = 'us-east-1'
    }

    stages {
        stage('Checkout') {
            steps {
                git url: 'https://github.com/P-Asritha/FreelanceForge.git', branch: 'main'
            }
        }

        stage('Build Docker Images') {
            steps {
                sh 'docker build -t freelanceforge-client ./client'
                sh 'docker build -t freelanceforge-api ./api'
            }
        }

        stage('Tag & Push Images to ECR') {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-credentials']]) {
                    sh '''
                        aws ecr-public get-login-password --region $REGION | docker login --username AWS --password-stdin public.ecr.aws
                        docker tag freelanceforge-client $ECR_CLIENT:latest
                        docker tag freelanceforge-api $ECR_API:latest
                        docker push $ECR_CLIENT:latest
                        docker push $ECR_API:latest
                    '''
                }
            }
        }

        stage('Remote Deploy to EC2') {
            steps {
                withCredentials([sshUserPrivateKey(credentialsId: 'ssh-private-key', keyFileVariable: 'SSH_KEY')]) {
                    script {
                        def target = (params.ENV == 'dev') ? DEV_SERVER : QA_SERVER
                        echo "🚀 Deploying to ${params.ENV.toUpperCase()} server..."

                        sh """
                            ssh -i $SSH_KEY -o StrictHostKeyChecking=no $target 'bash ~/run-docker.sh'
                        """
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
