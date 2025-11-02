pipeline {
  agent any
  environment {
    AWS_REGION = 'us-east-1'
    ECR_REPO = 'vite-react-app'
    AWS_CREDS = credentials('aws-creds')
    SSH_CRED_ID = 'jenkins-ssh-key'
    DEPLOY_HOST = 'ec2-user@54.167.114.21'
    IMAGE_TAG = "build-${env.BUILD_NUMBER}"
  }

  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Build React app') {
      steps {
        dir('frontend') {
          bat 'npm ci'
          bat 'npm run build'
        }
      }
    }

    stage('Build and Push Docker Image') {
      steps {
        script {
          def accountId = bat(script: "aws sts get-caller-identity --query Account --output text", returnStdout: true).trim()
          def repoUri = "${accountId}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPO}"

          bat """
          aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${repoUri}
          docker build -t ${ECR_REPO}:${IMAGE_TAG} .
          docker tag ${ECR_REPO}:${IMAGE_TAG} ${repoUri}:${IMAGE_TAG}
          docker tag ${ECR_REPO}:${IMAGE_TAG} ${repoUri}:latest
          docker push ${repoUri}:${IMAGE_TAG}
          docker push ${repoUri}:latest
          """
          env.IMAGE_URI = "${repoUri}:${IMAGE_TAG}"
        }
      }
    }

    stage('Deploy to EC2') {
      steps {
        sshagent (credentials: [env.SSH_CRED_ID]) {
          bat "bash deploy.sh ${DEPLOY_HOST} ${env.IMAGE_URI}"
        }
      }
    }
  }

  post {
    success {
      echo "✅ Deployed successfully: ${env.IMAGE_URI}"
    }
    failure {
      echo "❌ Deployment failed."
    }
  }
}
