pipeline {
    agent any 

        stages {
            stage('Build') {
                agent {
                    docker {
                        image 'node:18-alpine'
                        reuseNode true
                    }
                }
                steps {
                    sh '''
                        node --version
                        npm --version
                        npm ci
                        ls -la
                    '''
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
                        find . -type d build  
                        find . -type f build/index.html
                        test -d build
                        test -f build/index.html
                    '''
                }
            }
        }
}