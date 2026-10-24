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
                                publishHTML([allowMissing: false, alwaysLinkToLastBuild: false, icon: '', keepAll: false, reportDir: 'playwright-report', reportFiles: 'index.html', reportName: 'HTML Report', reportTitles: '', useWrapperFileDirectly: true])
                            }
                        }
                    }
                }
            }

            stage('Deploy') {
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
                        npx netlify deploy --dir=build --prod --site=$NETLIFY_SITE_ID --auth=$NETLIFY_AUTH_TOKEN
                    '''
                }
            }
        }
        
}
