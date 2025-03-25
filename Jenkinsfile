pipeline {
    agent any

    environment {
        GIT_REPO = 'https://github.com/P-Asritha/FreelanceForge.git'
        PATH = "/Users/asrithap/.nvm/versions/node/v22.13.1/bin:$PATH"  // ✅ Add Node.js path for Jenkins
    }

    stages {
        stage('Clone Repository') {
            steps {
                git branch: 'main', url: env.GIT_REPO
            }
        }

        stage('Build - Dev') {
            steps {
                script {
                    echo 'Checking Node.js and npm versions...'
                    sh 'node -v'  // ✅ This should now work
                    sh 'npm -v'   // ✅ This should now work

                    echo 'Building in Dev Environment...'
                    sh 'npm install'
                    sh 'npm run build'
                }
            }
        }

        stage('Test - Dev') {
            steps {
                script {
                    echo 'Running tests in Dev...'
                    sh 'npm test'
                }
            }
        }

        stage('Deploy - Dev') {
            steps {
                script {
                    echo 'Granting execute permissions to deploy scripts...'
                    sh 'chmod +x deploy-dev.sh deploy-qa.sh'

                    echo 'Deploying to Dev Environment...'
                    sh './deploy-dev.sh'
                }
            }
        }

        stage('Build - QA') {
            steps {
                script {
                    echo 'Building in QA Environment...'
                    sh 'npm install'
                    sh 'npm run build'
                }
            }
        }

        stage('Test - QA') {
            steps {
                script {
                    echo 'Running tests in QA...'
                    sh 'npm test'
                }
            }
        }

        stage('Deploy - QA') {
            steps {
                script {
                    echo 'Granting execute permissions to deploy scripts...'
                    sh 'chmod +x deploy-dev.sh deploy-qa.sh'

                    echo 'Deploying to QA Environment...'
                    sh './deploy-qa.sh'
                }
            }
        }
    }
}

