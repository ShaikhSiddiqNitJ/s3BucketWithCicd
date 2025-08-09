pipeline {
  agent any

  environment {
    NODE_VERSION = '22'
    AWS_DEFAULT_REGION = credentials('aws-default-region')
    AWS_ACCESS_KEY_ID = credentials('aws-access-key-id')
    AWS_SECRET_ACCESS_KEY = credentials('aws-secret-access-key')
    S3_BUCKET = credentials('s3-static-site-bucket')
  }

  options {
    timestamps()
    ansiColor('xterm')
  }

  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Setup Node') {
      steps {
        sh 'node -v || true'
        sh 'npm -v || true'
      }
    }

    stage('Install') {
      steps {
        sh 'npm ci || npm install'
      }
    }

    stage('Build') {
      steps {
        sh 'npm run build'
      }
      post {
        always {
          archiveArtifacts artifacts: 'dist/**', fingerprint: true, allowEmptyArchive: true
        }
      }
    }

    stage('Deploy to S3') {
      when { branch 'main' }
      steps {
        sh 'chmod +x scripts/deploy-s3.sh'
        sh 'AWS_REGION=$AWS_DEFAULT_REGION S3_BUCKET=$S3_BUCKET npm run deploy:s3'
      }
    }
  }

  post {
    failure {
      echo 'Pipeline failed.'
    }
    success {
      echo 'Build and deploy succeeded.'
    }
  }
} 