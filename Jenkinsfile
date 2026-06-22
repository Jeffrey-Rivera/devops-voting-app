pipeline {
    agent any

    environment {
        DOCKERHUB_USER = 'jeffreyrivera'
        IMAGE_TAG = 'phase6'
    }

    stages {
        stage('Checkout GitHub') {
            steps {
                git branch: 'main', url: 'https://github.com/Jeffrey-Rivera/devops-voting-app'
            }
        }

        stage('Build Vote Image') {
            steps {
                bat 'docker build -t %DOCKERHUB_USER%/voting-app-vote:%IMAGE_TAG% ./vote'
            }
        }

        stage('Build Result Image') {
            steps {
                bat 'docker build -t %DOCKERHUB_USER%/voting-app-result:%IMAGE_TAG% ./result'
            }
        }

        stage('Build Worker Image') {
            steps {
                bat 'docker build -t %DOCKERHUB_USER%/voting-app-worker:%IMAGE_TAG% ./worker'
            }
        }

        stage('Docker Login') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    bat 'echo %DOCKER_PASS% | docker login -u %DOCKER_USER% --password-stdin'
                }
            }
        }

        stage('Push Vote Image') {
            steps {
                bat 'docker push %DOCKERHUB_USER%/voting-app-vote:%IMAGE_TAG%'
            }
        }

        stage('Push Result Image') {
            steps {
                bat 'docker push %DOCKERHUB_USER%/voting-app-result:%IMAGE_TAG%'
            }
        }

        stage('Push Worker Image') {
            steps {
                bat 'docker push %DOCKERHUB_USER%/voting-app-worker:%IMAGE_TAG%'
            }
        }
    }
}