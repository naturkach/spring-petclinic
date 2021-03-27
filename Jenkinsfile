pipeline {
    agent any
    environment {
        DOCKER_IMAGE_NAME = "naturkach/petclinic"   
    }

    stages {
        stage('Build') {
            steps {
                echo 'Building..'
                sh './mvnw package'
                archiveArtifacts artifacts: 'target/*'
            }
        
        }
        stage('Build Docker Image') {
            when {
                branch 'master'
            }
            steps {
                script {
                    app = docker.build(DOCKER_IMAGE_NAME)
                       }
                   }
            }
        

        
        
        stage('Test') {
            steps {
                echo 'Testing..'
            }
        }
        stage('Deploy') {
            steps {
                echo 'Deploying....'
            }
        }
    }
}
