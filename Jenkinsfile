pipeline {
    // The main pipeline runs on our Jenkins container (which has the Docker CLI)
    agent any 

    environment {
        // Docker Hub details
        DOCKER_CREDENTIALS_ID = '8672f384-f8a2-4982-9e4b-205929ae05ed'
        IMAGE_NAME = 'hossain101/isec6000-app'
        IMAGE_TAG = "build-${env.BUILD_NUMBER}"
    }

    stages {
        stage('Install Dependencies') {
            agent {
                docker {
                    image 'node:16'
                    reuseNode true
                }
            }
            steps {
                echo "Installing NPM dependencies..."
                sh 'npm install'
            }
        }

        stage('Security Vulnerability Scan') {
            agent {
                docker {
                    image 'node:16'
                    reuseNode true
                }
            }
            steps {
                echo "Running security gate: checking for High/Critical vulnerabilities..."
                // This command natively fails the build if it detects high or critical vulnerabilities
                sh 'npm audit --audit-level=high'
            }
        }

        stage('Run Tests') {
            agent {
                docker {
                    image 'node:16'
                    reuseNode true
                }
            }
            steps {
                echo "Executing unit tests..."
                
                sh 'npm test' 
            }
        }

        stage('Build Docker Image') {
            // This runs on the Jenkins host to utilize the Docker-in-Docker engine
            steps {
                echo "Building Docker image for the Node.js app..."
                sh "docker build -t ${IMAGE_NAME}:${IMAGE_TAG} -t ${IMAGE_NAME}:latest ."
            }
        }

        stage('Push to Docker Hub') {
            steps {
                echo "Pushing image to Docker Hub securely..."
                // Securely bind the credentials without exposing them in the logs
                withCredentials([usernamePassword(credentialsId: DOCKER_CREDENTIALS_ID, usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh "echo \$DOCKER_PASS | docker login -u \$DOCKER_USER --password-stdin"
                    sh "docker push ${IMAGE_NAME}:${IMAGE_TAG}"
                    sh "docker push ${IMAGE_NAME}:latest"
                }
            }
        }
    }
    
    post {
        always {
            echo "Cleaning up workspace..."
            cleanWs()
        }
    }
}