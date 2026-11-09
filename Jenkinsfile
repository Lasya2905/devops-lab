pipeline {
    agent any
    environment {
        PATH = "/opt/homebrew/bin:/usr/local/bin:/Applications/Docker.app/Contents/Resources/bin:${env.PATH}"
    }
    stages {
        stage('Checkout') {
            steps { checkout scm }
        }
        stage('Install') {
            steps {
                sh 'python3 -m venv venv'
                sh '. venv/bin/activate && pip install -r requirements.txt'
            }
        }
        stage('Test') {
            steps { sh '. venv/bin/activate && pytest -v' }
        }
        stage('Docker Build') {
            steps { sh 'docker build -t devops-lab:${BUILD_NUMBER} .' }
        }
        stage('Run') {
            steps {
                sh 'docker rm -f devops-lab || true'
                sh 'docker run -d --name devops-lab -p 5001:5000 devops-lab:${BUILD_NUMBER}'
            }
        }
    }
    post {
        success { echo 'Pipeline succeeded' }
        failure { echo 'Pipeline failed' }
    }
}
