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
				sh ' docker build --tag snaxzee/cw22-server .'
				echo 'Docker image built succesfully'
			}
		}

		stage('Test docker image') {
			steps {
				echo 'Testing docker image'
				sh '''
					docker image inspect snaxzee/cw22-server
					docker run --name test-container -p 8081:8080 -d snaxzee/cw22-server
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
				sh 'docker push snaxzee/cw22-server'
			}
		}

		stage('Deploy') {
			steps { 
				sshagent(['jenkins-k8s-ssh-key']) {
					sh 'kubectl create deployment cw22-server --image=snaxzee/cw22-server:latest'
				}
			}
		}
	}
}

