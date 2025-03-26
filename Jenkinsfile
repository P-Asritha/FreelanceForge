pipeline {
    agent any

    environment {
        GIT_REPO = 'https://github.com/P-Asritha/FreelanceForge.git'
        PATH = "/Users/asrithap/.nvm/versions/node/v22.13.1/bin:$PATH"
        DEV_SERVER = "ec2-user@54.226.35.143"
        QA_SERVER = "ec2-user@18.205.238.248"
        SSH_KEY = "~/.ssh/NewJenkinsKey.pem"
    }

    stages {
        stage('Clean Workspace & Fetch Latest Code') {
            steps {
                script {
                    echo '🔄 Cleaning workspace and pulling latest changes...'
                    sh 'git reset --hard'  
                    sh 'git clean -fd'    
                    sh 'git pull origin main'  
                    sh 'ls -la'
                }
            }
        }

        stage('Install Dependencies') {
            steps {
                script {
                    echo '📦 Installing backend & frontend dependencies...'
                    sh 'cd api && npm install --only=prod'
                    sh 'cd client && npm install --legacy-peer-deps'  // ✅ Install ALL dependencies for frontend
                }
            }
        }

        stage('Build Application') {
            steps {
                script {
                    echo '⚙️ Building application...'
                    sh 'cd api && npm run build || echo "No build step needed for backend"'
                    sh 'cd client && npm run build'
                }
            }
        }

        stage('Deploy to Dev') {
            steps {
                script {
                    withCredentials([string(credentialsId: 'SLACK_WEBHOOK', variable: 'SLACK_WEBHOOK_URL')]) {
                        echo '🚀 Build Started for Dev environment...'
                        sh "curl -X POST -H 'Content-type: application/json' --data '{\"text\": \":rocket: *Build Started for Dev environment.*\"}' ${SLACK_WEBHOOK_URL}"
                    }

                    sh "ssh -i ${SSH_KEY} -o StrictHostKeyChecking=no ${DEV_SERVER} 'npm install -g pm2'"

                    sh "scp -i ${SSH_KEY} -o StrictHostKeyChecking=no -r api client package.json deploy-dev.sh ${DEV_SERVER}:~/app"

                    sh "ssh -i ${SSH_KEY} -o StrictHostKeyChecking=no ${DEV_SERVER} 'cd ~/app && npm install --only=prod && pm2 restart all || pm2 start api/server.js --name FreelanceForge'"
                }
            }
        }

        stage('Deploy to QA') {
            steps {
                script {
                    withCredentials([string(credentialsId: 'SLACK_WEBHOOK', variable: 'SLACK_WEBHOOK_URL')]) {
                        echo '🚀 Build Started for QA environment...'
                        sh "curl -X POST -H 'Content-type: application/json' --data '{\"text\": \":rocket: *Build Started for QA environment.*\"}' ${SLACK_WEBHOOK_URL}"
                    }

                    sh "ssh -i ${SSH_KEY} -o StrictHostKeyChecking=no ${QA_SERVER} 'npm install -g pm2'"

                    sh "scp -i ${SSH_KEY} -o StrictHostKeyChecking=no -r api client package.json deploy-qa.sh ${QA_SERVER}:~/app"

                    sh "ssh -i ${SSH_KEY} -o StrictHostKeyChecking=no ${QA_SERVER} 'cd ~/app && npm install --only=prod && pm2 restart all || pm2 start api/server.js --name FreelanceForge'"
                }
            }
        }
    }

    post {
        success {
            script {
                withCredentials([string(credentialsId: 'SLACK_WEBHOOK', variable: 'SLACK_WEBHOOK_URL')]) {
                    echo '✅ Build & Deployment Successful!'
                    sh "curl -X POST -H 'Content-type: application/json' --data '{\"text\": \":white_check_mark: *Build SUCCESSFUL for Dev environment!*\"}' ${SLACK_WEBHOOK_URL}"
                    sh "curl -X POST -H 'Content-type: application/json' --data '{\"text\": \":white_check_mark: *Build SUCCESSFUL for QA environment!*\"}' ${SLACK_WEBHOOK_URL}"
                }
            }
        }
        failure {
            script {
                withCredentials([string(credentialsId: 'SLACK_WEBHOOK', variable: 'SLACK_WEBHOOK_URL')]) {
                    echo '❌ Build Failed!'
                    sh "curl -X POST -H 'Content-type: application/json' --data '{\"text\": \":x: *Build FAILED for Dev environment!*\"}' ${SLACK_WEBHOOK_URL}"
                    sh "curl -X POST -H 'Content-type: application/json' --data '{\"text\": \":x: *Build FAILED for QA environment!*\"}' ${SLACK_WEBHOOK_URL}"
                }
            }
        }
    }
}
