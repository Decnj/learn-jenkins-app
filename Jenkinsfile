pipeline {
    agent any {

        stages {
            stage('Build') {
                agent {
                    docker {
                        image 'node:18-alpine'
                        reuseNode true
                    }
                }
                steps {
                    npm --version
                    npm ci
                    ls -la
                }
            }

            stage('Test') {
                agent {
                    docker {
                        image 'node:18-alpine'
                        reuseNode true
                    }
                }
                steps {
                    sh '''
                        npm test
                        find . -type d -name 'build'  
                        find . -type f -name '*.html'
                    '''
                }
            }
        }
    }
}