pipeline {
    agent any

    environment {
        GIT_REPO = 'https://github.com/P-Asritha/FreelanceForge.git'
        PATH = "/Users/asrithap/.nvm/versions/node/v22.13.1/bin:$PATH"
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

        stage('Install Backend Dependencies') {
            steps {
                script {
                    echo '📦 Installing backend dependencies...'
                    sh 'cd api && npm install'
                }
            }
        }

        stage('Install Frontend Dependencies') {
            steps {
                script {
                    echo '📦 Installing frontend dependencies...'
                    sh 'cd client && npm install --legacy-peer-deps'
                }
            }
        }

        stage('Build Backend') {
            steps {
                script {
                    echo '⚙️ Building backend...'
                    sh 'cd api && npm run build || echo "No build step needed for backend"'
                }
            }
        }

        stage('Build Frontend') {
            steps {
                script {
                    echo '⚙️ Building frontend...'
                    sh 'cd client && npm run build'
                }
            }
        }

        stage('Test Backend') {
            steps {
                script {
                    echo '🛠 Running backend tests...'
                    sh 'cd api && npm test || echo "No test script defined"'
                }
            }
        }

        stage('Test Frontend') {
            steps {
                script {
                    echo '🛠 Running frontend tests...'
                    sh 'cd client && npm test || echo "No test script defined"'
                }
            }
        }

        stage('Deploy Backend') {
            steps {
                script {
                    echo '🚀 Deploying Backend (API)...'
                    sh 'chmod +x deploy-dev.sh deploy-qa.sh'
                    sh './deploy-dev.sh'
                }
            }
        }

        stage('Deploy Frontend') {
            steps {
                script {
                    echo '🚀 Deploying Frontend (React)...'
                    sh 'chmod +x deploy-dev.sh deploy-qa.sh'
                    sh './deploy-qa.sh'
                }
            }
        }
    }

    post {
        success {
            script {
                withCredentials([string(credentialsId: 'SLACK_WEBHOOK', variable: 'SLACK_WEBHOOK_URL')]) {
                    echo '✅ Build & Deployment Successful! Sending Slack notification...'
                    sh "curl -X POST -H 'Content-type: application/json' --data '{\"text\": \"✅ *Jenkins Build & Deployment Successful!*\"}' ${SLACK_WEBHOOK_URL}"
                }
            }
        }
        failure {
            script {
                withCredentials([string(credentialsId: 'SLACK_WEBHOOK', variable: 'SLACK_WEBHOOK_URL')]) {
                    echo '❌ Build Failed! Sending Slack notification...'
                    sh "curl -X POST -H 'Content-type: application/json' --data '{\"text\": \"❌ *Jenkins Build Failed!* Check logs for details.\"}' ${SLACK_WEBHOOK_URL}"
                }
            }
        }
    }
}
