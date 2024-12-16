pipeline {
    agent any
    environment {
        DOCKERHUB_CREDS = credentials('docker')
    }
    stages {
        stage('Docker image build') {
            steps {
                echo 'Building Docker image'
                sh 'docker build --tag snaxzee/cw2-server:1.0 .'
                echo 'Docker image built successfully'
            }
        }

        stage('Test Docker image') {
            steps {
                echo 'Testing Docker image'
                sh '''
                    docker image inspect snaxzee/cw2-server:1.0
                    docker run --name test-container -p 8081:8080 -d snaxzee/cw2-server:1.0
                    docker ps
                    docker stop test-container
                    docker rm test-container
                '''
            }
        }
        
        stage('DockerHub login') {
            steps {
                echo 'Logging into DockerHub'
                sh 'echo $DOCKERHUB_CREDS_PSW | docker login -u $DOCKERHUB_CREDS_USR --password-stdin'
            }
        }

        stage('DockerHub image push') {
            steps {
                echo 'Pushing Docker image to DockerHub'
                sh 'docker push snaxzee/cw2-server:1.0'
            }
        }

        stage('Deploy to Kubernetes') {
            steps { 
                echo 'Deploying to Kubernetes'
                sshagent(['jenkins-k8s-ssh-key']) {
                   sh '''
                        kubectl delete deployment cw2-server --ignore-not-found=true
                        kubectl create deployment cw2-server --image=snaxzee/cw2-server:1.0
                        kubectl expose deployment cw2-server --type=LoadBalancer --port=80
                    '''
                }
            }
        }
    }
}
