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
                        npm run build
                        ls -la
                        ls -la $HOME
                        ls -la /var/jenkins_home 
                        ls -la /var/jenkins_home/workspace
                        ls -la /var/jenkins_home/.npm
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
                        node_modules/.bin/serve --version 
                        npx serve --version
                        npx serve -s build &
                        ls -la node_modules/serve/node_modules 
                        sleep 15
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