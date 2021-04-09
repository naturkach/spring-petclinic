pipeline {
    agent any
    stages {
        stage('Build') {           
           
            steps {
                dir ('project') {
                    echo 'Building..'
                    sh './mvnw package'
                    archiveArtifacts artifacts: 'target/*'
                }
            }
        
        }
        stage('Build Docker Image') {            
            steps {
                script {                    
                       app = docker.build("naturkach/petclinic")
                       }
                  }
        }
        stage('Push Docker Image') {
          
            steps {
                script {
                  docker.withRegistry('https://registry.hub.docker.com', 'docker_hub_login') {
                    app.push("${env.BUILD_NUMBER}")
                    app.push("latest")
                    }
                }
            }
            
        }    
              
      
        stage('Deploy') {
            steps {
                echo 'Deploying....'
            }
        }
    }
}
