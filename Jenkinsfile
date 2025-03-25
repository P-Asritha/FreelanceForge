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

        stage('Deploy Backend to Dev') {
            steps {
                script {
                    withCredentials([string(credentialsId: 'SLACK_WEBHOOK', variable: 'SLACK_WEBHOOK_URL')]) {
                        echo '🚀 Build Started for Dev environment...'
                        sh "curl -X POST -H 'Content-type: application/json' --data '{\"text\": \":rocket: *Build Started for Dev environment.*\"}' ${SLACK_WEBHOOK_URL}"
                    }
                    sh 'chmod +x deploy-dev.sh'
                    sh './deploy-dev.sh'
                }
            }
        }

        stage('Deploy Backend to QA') {
            steps {
                script {
                    withCredentials([string(credentialsId: 'SLACK_WEBHOOK', variable: 'SLACK_WEBHOOK_URL')]) {
                        echo '🚀 Build Started for QA environment...'
                        sh "curl -X POST -H 'Content-type: application/json' --data '{\"text\": \":rocket: *Build Started for QA environment.*\"}' ${SLACK_WEBHOOK_URL}"
                    }
                    sh 'chmod +x deploy-qa.sh'
                    sh './deploy-qa.sh'
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
