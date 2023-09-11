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
                junit '**/target/surefire-reports/*.xml'
                jacoco execPattern: 'target/jacoco.exec'
              }
            }
    }   
    stage('Mutation Tests - PIT') {
      steps {
        sh "mvn org.pitest:pitest-maven:mutationCoverage"
      }
      post {
        always {
          pitmutation mutationStatsFile: '**/target/pit-reports/**/mutations.xml'
        }
      }
    }
    // SonarQube 
    stage('SonarQube - SAST') {
      steps {
        withSonarQubeEnv('SonarQube') {
          //sh "mvn sonar:sonar -Dsonar.projectKey=numeric-application -Dsonar.host.url=http://devsecops-demo.ukwest.cloudapp.azure.com:9000"         
          //sh "mvn sonar:sonar -Dsonar.projectKey=numeric-application -Dsonar.host.url=http://devsecops-demo.ukwest.cloudapp.azure.com:9000 -Dsonar.login=e8d9829654013f23fcc93b734688a349cecfca79"
          sh "mvn clean verify sonar:sonar -Dsonar.projectKey=numeric-application -Dsonar.host.url=http://devsecops-demo.ukwest.cloudapp.azure.com:30012 -Dsonar.login=sqp_1fb07acaaede2dc197dc45a84fdbd7ec5eae994b"
        }
        timeout(time: 2, unit: 'MINUTES') {
          script {
            waitForQualityGate abortPipeline: true
          }
        }
      }
    }   

    stage('Vulnerability Scan - Docker ') {
      steps {
        sh "mvn dependency-check:check"
      }
      post {
        always {
          dependencyCheckPublisher pattern: 'target/dependency-check-report.xml'
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
    stage('Kubernetes Deployment - DEV') {
      steps {
        withKubeConfig([credentialsId: 'kubeconfig']) {
          sh "sed -i 's#replace#ingearturojimenez/numeric-app:${GIT_COMMIT}#g' k8s_deployment_service.yaml"
          sh "kubectl apply -f k8s_deployment_service.yaml"
        }
      }
    }
  }
}