pipeline {
    agent any 

    environment {
        NETLIFY_SITE_ID = credentials('netlify-site-id')
        NETLIFY_AUTH_TOKEN = credentials('netlify-token')
        REACT_APP_VERSION = "1.0.$BUILD_ID"
    }

        stages {

            stage('Docker Build') {
                steps {
                    sh '''
                        docker build -t my-playwright .
                    '''
                }
            }
            stage('Build') {
                agent {
                    docker {
                        image 'node:22-alpine'
                        args '-v $HOME/.npm:/root/.npm'
                        reuseNode true
                    }
                }
                steps {
                    sh '''
                        node --version
                        npm --version
                        npm ci --no-fund --no-audit --prefer-offline
                        npm run build
                        ls -la
                    '''
                }
            }

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
                                image 'my-playwright'
                                args '-v $HOME/.npm:/root/.npm'
                                reuseNode true
                            }
                        }
                        steps {
                            sh '''
                                node --version 
                                npm --version
                                serve --version
                                serve -s build &
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
                        image 'my-playwright'
                        args '-v $HOME/.npm:/root/.npm'
                        reuseNode true
                    }
                }
                environment {
                    CI_ENVIRONMENT_URL = 'SET_STAGING_URL'
                }
                steps {
                    sh '''
                        node --version
                        npm --version
                        netlify --version
                        netlify status
                        echo "Deploying to staging..."
                        netlify deploy --dir=build --json > netlify-deploy.json
                        CI_ENVIRONMENT_URL=$(node-jq -r '.deploy_url' netlify-deploy.json)
                        npx playwright test --reporter=html
                    '''
                    // script {
                    //     env.CI_ENVIRONMENT_URL = sh(
                    //         script: "npx node-jq -r '.deploy_url' netlify-deploy.json", 
                    //         returnStdout: true
                    //         ).trim()
                    // }
                }
                post {
                    always {
                        publishHTML([allowMissing: false, alwaysLinkToLastBuild: false, icon: '', keepAll: false, reportDir: 'playwright-report', reportFiles: 'index.html', reportName: 'Playwright Staging', reportTitles: '', useWrapperFileDirectly: true])
                    }
                }
            }

            // stage('Approval') {
            //     steps {
            //         timeout(time: 10, unit: 'MINUTES') {
            //             input cancel: 'Review', message: 'Approve deployment to production?', ok: 'Deploy!!!'
            //         }
            //     }
            // }

            stage('Deploy Prod') {
                agent {
                    docker {
                        image 'my-playwright'
                        args '-v $HOME/.npm:/root/.npm'
                        reuseNode true
                    }
                }
                environment {
                    CI_ENVIRONMENT_URL = credentials('netlify-prod-url')
                }
                steps {
                    sh '''
                        netlify --version
                        netlify status
                        echo "Deploying to production..."
                        netlify deploy --dir=build --prod 
                        sleep 10
                        playwright test --reporter=html
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
