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

            stage('Unit Test') {
                agent {
                    docker {
                        image 'node:18-alpine'
                        reuseNode true
                    }
                }
                steps {
                    sh '''
                        npm test
                    '''
                }
            }
            stage('E2E') {
                agent {
                    docker {
                        image 'mcr.microsoft.com/playwright:v1.39.0-jammy'
                        reuseNode true
                    }
                }
                steps {
                    sh '''
                        npm install serve
                        serve --version
                        npx serve -s build
                        npx playwright test  
                    '''
                }
            }
        }

        post {
            always {
                junit 'test-results/junit.xml'
            }
        }
}