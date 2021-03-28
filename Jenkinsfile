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
                branch 'main'
            }
            steps {
                script {
                    app = docker.build(DOCKER_IMAGE_NAME)
                       }
                   }
            }
//       stage('Push Docker Image') {
//          when {
//               branch 'main'
//          }
   //         steps {
     //           docker.withRegistry('https://registry.hub.docker.com', 'docker_hub_login') {
     //               app.push("${env.BUILD_NUMBER}")
     //               app.push("latest")
    //            }
  //         }
            
//        }
        

        
        
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
