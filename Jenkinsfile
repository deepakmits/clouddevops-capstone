pipeline {
    agent any

    environment {
        AWS_ECR_URI = "615529889392.dkr.ecr.us-west-2.amazonaws.com/deep-capstone"
        CAPSTONE_ML_APP = "capstone-ml-app"
        VERSION = "${env.BRANCH_NAME}.${BUILD_NUMBER}"
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Install Dependencies') {
            steps {
                echo 'Installing application dependencies'
                withPythonEnv('python3') {
                    sh 'pip3 install -r ./app/requirements.txt'
                }
            }
        }
        
        stage('Lint') {
            steps {
                echo 'Performing liniting checks.'
                withPythonEnv('python3') {
                    sh 'pylint ./app/app.py'
                }
            }
        }

        stage('Build Image') {
            steps {
                echo 'Building Image'
                sh "docker build --tag ${CAPSTONE_ML_APP}:${VERSION} ."
                sh 'docker images'
            }
        }

        stage('Deploy to ECR') {
            when {
                anyOf { branch 'master'; branch 'develop' }
            }
            steps {
                echo 'Deploying application image to AWS ECR.'
                sh "docker tag ${CAPSTONE_ML_APP} ${AWS_ECR_URI}:${VERSION}"
                sh "docker push ${AWS_ECR_URI}"
            }
        }

        stage('Deploy ECR Image to AWS EKS Cluster') {
            when {
                anyOf { branch 'master'; branch 'develop' }
            }
            steps {
                echo 'Deploying application to AWS EKS Cluster'
                sh "kubectl set image deployment/ml-app ml-app=${AWS_ECR_URI}:${VERSION}"
                sh 'kubectl get pods'
            }
        }
    }

    post {
            success {
                echo 'Build successful. Cleaning workspace and docker images'
                sh "docker image rm ${AWS_ECR_URI}:${VERSION}"
            }

            failure {
                echo 'Pipeline failed. Cleaning workspace and docker images'
                sh "docker image rm ${AWS_ECR_URI}:${VERSION}"
            }
        }
}