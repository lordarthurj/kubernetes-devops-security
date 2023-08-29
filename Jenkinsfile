pipeline {
  agent any

  stages {
      stage('Build Artifact') {
            steps {
              sh "mvn clean package -DskipTests=true"
              //archive 'target/*.jar' //so that they can be downloaded later
              archive 'target/*.jar'
            }
        }   
    
    stage('Unit Test') {
            steps {
              sh "mvn test"              
            }
            post {
              always {
                junit 'target/surefire-reports/*.xml'
                jacoco execPattern: 'target/jacoco.exec'
              }
            }
    }   

    stage('Docker Build and Push') {
      steps {
        withDockerRegistry([credentialsId: "docker-hub", url: ""]) {
          sh 'printenv'
          sh 'docker build -t ingearturojimenez/numeric-app:""$GIT_COMMIT"" .'
          sh 'docker push ingearturojimenez/numeric-app:""$GIT_COMMIT""'
        }
      }
    }
  }
}