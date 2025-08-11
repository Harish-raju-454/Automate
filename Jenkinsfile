pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "harishraju454/flaskapp:latest"
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    docker.build(DOCKER_IMAGE)
                }
            }
        }

        stage('Test Docker Image') {
            steps {
                script {
                    sh "docker run --rm ${DOCKER_IMAGE} curl -f http://localhost:5000 || exit 1"
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    script {
                        docker.withRegistry('https://index.docker.io/v1/', 'dockerhub-creds') {
                            docker.image(DOCKER_IMAGE).push()
                        }
                    }
                }
            }
        }
    }
}
