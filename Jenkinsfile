pipeline {
    agent any 

        stages {
            // stage('Build') {
            //     agent {
            //         docker {
            //             image 'node:22-alpine'
            //             args '-v $HOME/.npm:/root/.npm'
            //             reuseNode true
            //         }
            //     }
            //     steps {
            //         sh '''
            //             node --version
            //             npm --version
            //             npm ci
            //             npm run build
            //             ls -la
            //         '''
            //     }
            // }

            stage('Unit Test') {
                agent {
                    docker {
                        image 'node:22-alpine'
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
                        image 'mcr.microsoft.com/playwright:v1.63.0-jammy'
                        reuseNode true
                    }
                }
                steps {
                    sh '''
                        node --version 
                        npm --version
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