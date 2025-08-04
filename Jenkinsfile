pipeline {
    agent any

    stages {
        stage('w/o docker') {
            steps {
                sh '''
                      echo "Hello World"
                      touch no-container.txt
                      ls -la
                   '''
            }
        }
        stage('w/ docker') {
            agent {
                docker {
                    image 'node:alpine'
                    reuseNode true
                }
            }
            steps {
                sh '''
                      echo "Welcome Docker"
                      ls -la
                      touch container.txt
                   '''
            }
        }
    }
}
