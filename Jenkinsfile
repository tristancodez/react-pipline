pipeline {
    agent any

    stages {
        stage('Clone Repository') {
            steps {
                git branch: 'main', url: 'https://github.com/tristancodez/react-pipline.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t simple-html-site .'
            }
        }

        stage('Run Container') {
            steps {
                sh 'docker rm -f html-site || true'
                sh 'docker run -d -p 80:80 --name html-site simple-html-site'
            }
        }
    }

    post {
        success {
            echo "✅ Deployment successful! Access your site via EC2 public IP:80"
        }
        failure {
            echo "❌ Deployment failed."
        }
    }
}
