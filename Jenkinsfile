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
                    sh 'git reset --hard'  // ✅ Reset changes
                    sh 'git clean -fd'    // ✅ Remove untracked files
                    sh 'git pull origin main'  // ✅ Pull latest code
                    sh 'ls -la'  // ✅ Verify files exist
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
                    sh 'cd client && npm install'
                }
            }
        }

        stage('Build Backend') {
            steps {
                script {
                    echo '⚙️ Building backend...'
                    sh 'cd api && npm run build'
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
                    sh 'cd api && npm test'
                }
            }
        }

        stage('Test Frontend') {
            steps {
                script {
                    echo '🛠 Running frontend tests...'
                    sh 'cd client && npm test'
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
}

