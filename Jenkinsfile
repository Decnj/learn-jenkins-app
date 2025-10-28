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
	    	agent {
				docker {
		    		image 'node:18-alpine'
		    		reuseNode true
				}
	    	}
	    	steps {
	        	sh '''
		    		test -f build/index.html
				'''
	    	}
		}
		
		stage(E2E) {
			agent {
				docker{
					image
					reuseNode true
				}
			}
			steps {
				sh '''
					npm install -g serve
					serve -s build
					npx playwright test
				'''
			}
		}
    }
}
	        
