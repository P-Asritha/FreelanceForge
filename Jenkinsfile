pipeline {
  agent any

  parameters {
    choice(name: 'ENV', choices: ['dev', 'qa'], description: 'Choose deployment environment')
  }

  environment {
    AWS_ACCESS_KEY_ID = credentials('aws-credentials')
    AWS_SECRET_ACCESS_KEY = credentials('aws-credentials')
    SSH_KEY = credentials('ec2-ssh-key')
    SLACK_WEBHOOK_URL = credentials('slack-webhook')
  }

  stages {
    stage('Checkout') {
      steps {
        git url: 'https://github.com/P-Asritha/FreelanceForge.git', branch: 'main'
      }
    }

    stage('Build Docker Images') {
      steps {
        script {
          // Set up Docker Buildx builder (will skip if already created)
          sh 'docker buildx create --use || true'

          // Build client image for linux/amd64
          sh 'docker buildx build --platform linux/amd64 -t freelanceforge-client ./client --load'

          // Build API image for linux/amd64
          sh 'docker buildx build --platform linux/amd64 -t freelanceforge-api ./api --load'
        }
      }
    }

    stage('Tag & Push Images to ECR') {
      steps {
        withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-credentials']]) {
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
        withCredentials([sshUserPrivateKey(credentialsId: 'ec2-ssh-key', keyFileVariable: 'SSH_KEY')]) {
          script {
            def host = params.ENV == 'dev' ? '54.235.10.152' : '54.166.163.248'
            echo "🚀 Deploying to ${params.ENV.toUpperCase()} server..."
            sh "ssh -i ${SSH_KEY} -o StrictHostKeyChecking=no ec2-user@${host} 'bash ~/run-docker.sh'"
          }
        }
      }
    }
  }

  post {
    success {
      withCredentials([string(credentialsId: 'slack-webhook', variable: 'SLACK_WEBHOOK_URL')]) {
        sh '''
          curl -X POST -H 'Content-type: application/json' \
          --data '{"text":"✅ *FreelanceForge ${ENV.toUpperCase()} Deployment Successful!*"}' \
          $SLACK_WEBHOOK_URL
        '''
      }
    }

    failure {
      withCredentials([string(credentialsId: 'slack-webhook', variable: 'SLACK_WEBHOOK_URL')]) {
        sh '''
          curl -X POST -H 'Content-type: application/json' \
          --data '{"text":"❌ *FreelanceForge ${ENV.toUpperCase()} Deployment Failed!*"}' \
          $SLACK_WEBHOOK_URL
        '''
      }
    }
  }
}
