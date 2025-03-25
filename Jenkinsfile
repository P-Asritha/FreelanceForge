pipeline {
    agent any

    environment {
        GIT_REPO = 'https://github.com/P-Asritha/FreelanceForge.git'
        PATH = "/Users/asrithap/.nvm/versions/node/v22.13.1/bin:$PATH"
    }

    stages {
        stage('Clone Repository') {
            steps {
                script {
                    echo '🔄 Cleaning workspace...'
                    sh 'rm -rf *'
                    sh 'git clone ${GIT_REPO} .'
                    sh 'ls -la'  // ✅ Check if api/ and client/ exist
                }
            }
        }

        // 🚀 Install Backend (API)
        stage('Install Backend Dependencies') {
            steps {
                script {
                    echo '📦 Installing backend dependencies...'
                    sh 'cd api && npm install'
                }
            }
        }

        // 🚀 Install Frontend (Client)
        stage('Install Frontend Dependencies') {
            steps {
                script {
                    echo '📦 Installing frontend dependencies...'
                    sh 'cd client && npm install'
                }
            }
        }

        // 🚀 Build Backend (API)
        stage('Build Backend') {
            steps {
                script {
                    echo '⚙️ Building backend...'
                    sh 'cd api && npm run build'
                }
            }
        }

        // 🚀 Build Frontend (React)
        stage('Build Frontend') {
            steps {
                script {
                    echo '⚙️ Building frontend...'
                    sh 'cd client && npm run build'
                }
            }
        }

        // 🚀 Test Backend
        stage('Test Backend') {
            steps {
                script {
                    echo '🛠 Running backend tests...'
                    sh 'cd api && npm test'
                }
            }
        }

        // 🚀 Test Frontend
        stage('Test Frontend') {
            steps {
                script {
                    echo '🛠 Running frontend tests...'
                    sh 'cd client && npm test'
                }
            }
        }

        // 🚀 Deploy Backend
        stage('Deploy Backend') {
            steps {
                script {
                    echo '🚀 Deploying Backend (API)...'
                    sh 'chmod +x deploy-dev.sh deploy-qa.sh'
                    sh './deploy-dev.sh'
                }
            }
        }

        // 🚀 Deploy Frontend
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
}
