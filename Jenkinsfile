pipeline {
    agent any

    environment {
        NETLIFY_SITE_ID = 'da1e7219-d551-4fb1-b835-c47b9334ebe7'
        NETLIFY_AUTH_TOKEN = credentials ('netlify-token')
        REACT_APP_VERSION = "1.2.$BUILD_ID"
    }

    stages {
        stage('Docker') {
            steps {
                sh 'docker build -t decnj/node-build .'
            }
        }

        stage('Build') {
            agent {
                docker {
                    image 'node:18-alpine'
                    reuseNode true
                }
            }
            steps {
                sh '''
                    ls -la
                    node --version
                    npm --version
                    npm ci
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
                            image 'node:18-alpine'
                            reuseNode true
                        }
                    }

                    steps {
                        sh '''
                            test -f build/index.html
                            npm test
                        '''
                    }
                    post {
                        always {
                            // Publish JUnit test results
                            junit 'jest-results/junit.xml'
                        }
                    }
                }

                stage('E2E') {
                    agent {
                        docker{
                            image 'mcr.microsoft.com/playwright:v1.39.0-jammy'
                            reuseNode true
                        }
                    }

                    steps {
                        sh '''
                            whoami
                            npm install serve
                            node_modules/.bin/serve -s build &
                            sleep 10
                            npx playwright test --reporter=html
                        '''
                    }
                post {
                    always {
                        // Publish playwright test report
                        publishHTML([allowMissing: false, alwaysLinkToLastBuild: false, icon: '', keepAll: false, reportDir: 'playwright-report', reportFiles: 'index.html', reportName: 'Local E2E Report', reportTitles: '', useWrapperFileDirectly: true])
                    }
                }
                }
            } 
        }
        
        stage('Deploy staging') {
            agent {
                docker {
                    image 'decnj/node-build'
                    reuseNode true
                }
            }

            environment {
                CI_ENVIRONMENT_URL = 'STAGING_URL_TO_BE_SET'
            }

            steps {
                sh '''
                    netlify --version
                    echo "Deploying to production. Site ID: $NETLIFY_SITE_ID"
                    netlify status
                    netlify deploy --dir=build --json > deploy-url.json
                    CI_ENVIRONMENT_URL=$(node-jq -r '.deploy_url' deploy-url.json)
                    npx playwright test --reporter=html
                '''
            }

        post {
            always {
            // Publish playwright test
            publishHTML([allowMissing: false, alwaysLinkToLastBuild: false, icon: '', keepAll: false, reportDir: 'playwright-report', reportFiles: 'index.html', reportName: 'Staging E2E Report', reportTitles: '', useWrapperFileDirectly: true])
            }
        }
        }

        /*stage('Approval') {
            steps {
                timeout(time: 15, unit: 'MINUTES') {
                    input message: 'Do you wish to deploy to production?', ok: 'Yes, I am sure!'
                }
            }
        }
        */

        stage('Deploy prod') {
            agent {
                docker {
                    image 'mcr.microsoft.com/playwright:v1.39.0-jammy'
                    reuseNode true
                }
            }

            environment {
                CI_ENVIRONMENT_URL = 'https://thunderous-pegasus-03ae90.netlify.app'
            }

            steps {
                sh '''
                    npm install netlify-cli@20.1.1
                    node_modules/.bin/netlify --version
                    echo "Deploying to production. Site ID: $NETLIFY_SITE_ID"
                    node_modules/.bin/netlify status
                    node_modules/.bin/netlify deploy --dir=build --prod
                    npx playwright test --reporter=html
                '''
            }

        post {
            always {
            // Publish playwright test
            publishHTML([allowMissing: false, alwaysLinkToLastBuild: false, icon: '', keepAll: false, reportDir: 'playwright-report', reportFiles: 'index.html', reportName: 'Prod E2E Report', reportTitles: '', useWrapperFileDirectly: true])
            }
        }
        }
    }
}