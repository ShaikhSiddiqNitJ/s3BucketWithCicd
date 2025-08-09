pipeline {
    agent any

    environment {
        AWS_REGION = 'us-east-1'
        S3_BUCKET = 'siddiq-shaikh-123-ab'
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/ShaikhSiddiqNitJ/s3BucketWithCicd.git'
            }
        }

        stage('Install Dependencies') {
            steps {
                sh 'npm install'
            }
        }

        stage('Build React App') {
            steps {
                sh 'npm run build'
            }
        }

        stage('Deploy to S3') {
            steps {
                sh '''
                    aws s3 sync dist/ s3://$S3_BUCKET --delete --region $AWS_REGION
                '''
            }
        }
    }

    post {
        success {
            echo "✅ Deployment successful! URL: http://$S3_BUCKET.s3-website-$AWS_REGION.amazonaws.com"
        }
        failure {
            echo "❌ Deployment failed!"
        }
    }
}
