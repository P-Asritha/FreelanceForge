        stage('Install Dependencies') {
            steps {
                script {
                    echo '📦 Installing backend & frontend dependencies...'

                    // 🔹 Install API dependencies
                    sh 'cd api && npm install --legacy-peer-deps'

                    // 🔹 Install Frontend dependencies
                    sh 'cd client && npm install --legacy-peer-deps'

                    // 🔹 Ensure `node_modules/.vite` exists to prevent Vite issues
                    sh 'mkdir -p client/node_modules/.vite'
                }
            }
        }
