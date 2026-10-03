pipeline {
    agent any

    stages {
        stage('W/o Docker') {
            steps {
                cleanWs()
                sh '''
                    ls -la
                    touch test.txt
                    ls -la
                '''
            }
        }

        stage('With Docker') {
            agent {
                docker {
                    image 'node:18-alpine'
                    reuseNode true
                }
            }
            steps {
                sh '''
                    ls -la
                    touch test2.txt
                    ls -la
                '''
            }
        }
    }

    post {
        success {
            archiveArtifacts artifacts: '/**'
        }
    }
}