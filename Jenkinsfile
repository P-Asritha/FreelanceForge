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

                    // 🔹 Install API dependencies
                    sh 'cd api && npm ci --legacy-peer-deps'

                    // 🔹 Install Frontend dependencies
                    sh 'cd client && npm ci --legacy-peer-deps'

                    // 🔹 Ensure `node_modules/.vite` exists to prevent Vite issues
                    sh 'mkdir -p client/node_modules/.vite'
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

                    // 🔹 Ensure Dev instance has required software
                    sh "ssh -i ${SSH_KEY} -o StrictHostKeyChecking=no ${DEV_SERVER} 'node -v && npm -v && npx pm2 -v'"

                    // 🔹 Transfer only the required files
                    sh "scp -i ${SSH_KEY} -o StrictHostKeyChecking=no -r api client deploy-dev.sh ${DEV_SERVER}:~/app"

                    // 🔹 Run the application in AWS Dev instance
                    sh "ssh -i ${SSH_KEY} -o StrictHostKeyChecking=no ${DEV_SERVER} 'cd ~/app && npm install --only=prod && npx pm2 restart api/server.js --name FreelanceForge'"
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

                    // 🔹 Ensure QA instance has required software
                    sh "ssh -i ${SSH_KEY} -o StrictHostKeyChecking=no ${QA_SERVER} 'node -v && npm -v && npx pm2 -v'"

                    // 🔹 Transfer only the required files
                    sh "scp -i ${SSH_KEY} -o StrictHostKeyChecking=no -r api client deploy-qa.sh ${QA_SERVER}:~/app"

                    // 🔹 Run the application in AWS QA instance
                    sh "ssh -i ${SSH_KEY} -o StrictHostKeyChecking=no ${QA_SERVER} 'cd ~/app && npm install --only=prod && npx pm2 restart api/server.js --name FreelanceForge'"
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
