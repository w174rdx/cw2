//Jenkinsfile (Declarative pipeline)
pipeline {
	agent any
	environment {
		DOCKERHUB_CREDS = credentials('docker')
        }
	stages {
		stage('Docker image build') {
			steps {
				echo 'Building docker image'
				sh 'docker build --tag snaxzee/cw2-server:1.0 .'
				echo 'Docker image built successfully'
			}
		}

		stage('Test docker image') {
			steps {
				echo 'Testing docker image'
				sh '''
					docker image inspect snaxzee/cw2-server:1.0
					docker run --name test-container -p 8081:8080 -d snaxzee/cw2-server:1.0
					docker ps
					docker stop test-container
					docker rm test-container
				'''
			}
		}
		
		stage('Dockerhub login') {
			steps {
				sh 'echo $DOCKERHUB_CREDS_PSW | docker login -u $DOCKERHUB_CREDS_USR --password-stdin'
			}
		}

		stage('Dockerhub image push') {
			steps {
				sh 'docker push snaxzee/cw2-server:1.0'
			}
		}

		stage('Deploy') {
			steps { 
				sshagent(['jenkins-k8s-ssh-key']) {
					sh 'kubectl create deployment cw2-server --image=snaxzee/cw2-server:1.0'
				}
			}
		}
	}
}
