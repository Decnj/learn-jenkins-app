pipeline {
    agent any 

    environment {
        NETLIFY_SITE_ID = credentials('netlify-site-id')
        NETLIFY_AUTH_TOKEN = credentials('netlify-token')
    }

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
            //             npm ci --no-fund --no-audit --prefer-offline
            //             npm run build
            //             ls -la
            //         '''
            //     }
            // }

            stage('Test') {
                parallel {
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
                        post {
                            always {
                                junit 'jest-results/junit.xml'
                            }
                        }
                    }
                    
                    stage('E2E') {
                        agent {
                            docker {
                                image 'mcr.microsoft.com/playwright:v1.63.0-jammy'
                                args '-v $HOME/.npm:/root/.npm'
                                reuseNode true
                            }
                        }
                        steps {
                            sh '''
                                node --version 
                                npm --version
                                npm install serve --no-fund --no-audit --prefer-offline
                                node_modules/.bin/serve --version 
                                npx serve --version
                                npx serve -s build &
                                sleep 15
                                npx playwright test --reporter=html 
                            '''
                        }
                        post {
                            always {
                                publishHTML([allowMissing: false, alwaysLinkToLastBuild: false, icon: '', keepAll: false, reportDir: 'playwright-report', reportFiles: 'index.html', reportName: 'Playwright local', reportTitles: '', useWrapperFileDirectly: true])
                            }
                        }
                    }
                }
            }
                    

            stage('Deploy Staging') {
                agent {
                    docker {
                        image 'node:22-alpine'
                        args '-v $HOME/.npm:/root/.npm'
                        reuseNode true
                    }
                }
                steps {
                    sh '''
                        npm install netlify-cli@20.1.1 --no-fund --no-audit --prefer-offline
                        npx netlify --version
                        npx netlify status
                        echo "Deploying to staging..."
                        npx netlify deploy --dir=build
                    '''
                }
            }

            stage('Approval') {
                steps {
                    timeout(time: 10, unit: 'MINUTES') {
                        input cancel: 'Review', message: 'Approve deployment to production?', ok: 'Deploy!!!'
                    }
                }
            }

            stage('Deploy Prod') {
                agent {
                    docker {
                        image 'node:22-alpine'
                        args '-v $HOME/.npm:/root/.npm'
                        reuseNode true
                    }
                }
                steps {
                    sh '''
                        npm install netlify-cli@20.1.1 --no-fund --no-audit --prefer-offline
                        npx netlify --version
                        npx netlify status
                        echo "Deploying to production..."
                        npx netlify deploy --dir=build --prod 
                    '''
                }
            }

            stage('Prod E2E') {
                agent {
                    docker {
                        image 'mcr.microsoft.com/playwright:v1.63.0-jammy'
                        args '-v $HOME/.npm:/root/.npm'
                        reuseNode true
                    }
                }

                environment {
                    CI_ENVIRONMENT_URL = credentials('netlify-prod-url')
                }
                steps {
                    sh '''
                        npx playwright test --reporter=html 
                    '''
                }
                post {
                    always {
                        publishHTML([allowMissing: false, alwaysLinkToLastBuild: false, icon: '', keepAll: false, reportDir: 'playwright-report', reportFiles: 'index.html', reportName: 'Playwright Prod', reportTitles: '', useWrapperFileDirectly: true])
                    }
                }
            }
        }
        
}
