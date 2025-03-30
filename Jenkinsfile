pipeline {
    agent any

    parameters {
        choice(name: 'ENV', choices: ['dev', 'qa'], description: 'Select environment')
    }

    environment {
        AWS_REGION = 'us-east-1'
        CLIENT_IMAGE = 'freelanceforge-client'
        API_IMAGE = 'freelanceforge-api'
        ECR_URI = 'public.ecr.aws/c3t3f9g9'
        DEV_HOST = '54.235.10.152'
        QA_HOST = '54.166.163.248'
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/P-Asritha/FreelanceForge.git'
            }
        }

        stage('Build Docker Images') {
            steps {
                sh 'docker build -t $CLIENT_IMAGE ./client'
                sh 'docker build -t $API_IMAGE ./api'
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
                        docker tag $CLIENT_IMAGE $ECR_URI/$CLIENT_IMAGE:latest
                        docker tag $API_IMAGE $ECR_URI/$API_IMAGE:latest
                        docker push $ECR_URI/$CLIENT_IMAGE:latest
                        docker push $ECR_URI/$API_IMAGE:latest
                    '''
                }
            }
        }

        stage('Remote Deploy to EC2') {
            steps {
                withCredentials([sshUserPrivateKey(
                    credentialsId: 'ssh-private-key',
                    keyFileVariable: 'SSH_KEY',
                    usernameVariable: 'SSH_USER'
                )]) {
                    script {
                        def host = params.ENV == 'dev' ? env.DEV_HOST : env.QA_HOST
                        echo "🚀 Deploying to ${params.ENV.toUpperCase()} server..."
                        sh "ssh -i $SSH_KEY -o StrictHostKeyChecking=no ec2-user@${host} 'bash ~/run-docker.sh'"
                    }
                }
            }
        }
    }

    post {
        success {
            withCredentials([string(credentialsId: 'SLACK_WEBHOOK', variable: 'SLACK_WEBHOOK_URL')]) {
                sh '''
                    curl -X POST -H 'Content-type: application/json' \
                    --data '{"text":"✅ *FreelanceForge ${ENV.toUpperCase()} Deployment Successful!*"}' \
                    $SLACK_WEBHOOK_URL
                '''
            }
        }

        failure {
            withCredentials([string(credentialsId: 'SLACK_WEBHOOK', variable: 'SLACK_WEBHOOK_URL')]) {
                sh '''
                    curl -X POST -H 'Content-type: application/json' \
                    --data '{"text":"❌ *FreelanceForge ${ENV.toUpperCase()} Deployment Failed!*"}' \
                    $SLACK_WEBHOOK_URL
                '''
            }
        }
    }
}
