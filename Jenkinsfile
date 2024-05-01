pipeline {
    agent any


    environment {
        APP_NAME = "govwa"
        RELEASE = "1.0.0"
        DOCKER_USER = "dmancloud"
        DOCKER_PASS = 'dockerhub'
        IMAGE_NAME  = "${DOCKER_USER}" + "/" + "${APP_NAME}"
        IMAGE_TAG = "${RELEASE}-${BUILD_NUMBER}"
        JENKINS_API_TOKEN = credentials("JENKINS_API_TOKEN")
        CIMON_CLIENT_ID = credentials("CIMON_CLIENT_ID")
        CIMON_SECRET = credentials("CIMON_SECRET")
    }

    stages {
        stage('Cleanup Workspace') {
            steps {
                cleanWs()
            }
        }

        stage('Install Cimon') {
            steps {
                sh 'curl -sSfL https://cimon-releases.s3.amazonaws.com/install.sh | sudo sh -s -- -b /usr/local/bin'
            }
         }

        stage('Run Cimon') {
            steps {
                sh 'sudo -E cimon agent start-background'
            }
        }
        
        stage('Checkout Code') {
            steps {
                git branch: 'main', credentialsId: 'github', url: 'https://github.com/dmancloud/GoVWA'
            }
        }  
                  
        
        stage('Docker Build & Push') {
            steps {
                script {
                   // docker.withRegistry(' ',DOCKER_PASS) {
                    withDockerRegistry(credentialsId: 'dockerhub') {
                        docker_image = docker.build "${IMAGE_NAME}"
                    }

                   // docker.withRegistry(' ',DOCKER_PASS) {
                    withDockerRegistry(credentialsId: 'dockerhub') {
                        docker_image.push("${IMAGE_TAG}")
                        docker_image.push('latest')
                    }
                    
                }            
            }
        } 

        stage ('Cleanup Artifacts') {
            steps {
                script {
                    sh "docker rmi ${IMAGE_NAME}:${IMAGE_TAG}"
                    sh "docker rmi ${IMAGE_NAME}:latest"
                }
            }
        }
               
    }
    post {
        always {
            sh 'sudo -E cimon agent stop'
        }
    }
}