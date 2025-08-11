#!/bin/bash

# Config - update these before running
GITHUB_REPO="https://github.com/Harish-raju-454/Automate.git"
GITHUB_BRANCH="main"
JENKINS_URL="http://localhost:8080"
JENKINS_USER="admin"
JENKINS_API_TOKEN="your_jenkins_api_token"
JOB_NAME="my-flask-app-pipeline"

cat > pipeline-job-config.xml <<EOF
<?xml version='1.1' encoding='UTF-8'?>
<flow-definition plugin="workflow-job@2.40">
  <description>Automated pipeline job for my-flask-app</description>
  <keepDependencies>false</keepDependencies>
  <properties/>
  <definition class="org.jenkinsci.plugins.workflow.cps.CpsScmFlowDefinition" plugin="workflow-cps@2.93">
    <scm class="hudson.plugins.git.GitSCM" plugin="git@4.13.2">
      <configVersion>2</configVersion>
      <userRemoteConfigs>
        <hudson.plugins.git.UserRemoteConfig>
          <url>${GITHUB_REPO}</url>
        </hudson.plugins.git.UserRemoteConfig>
      </userRemoteConfigs>
      <branches>
        <hudson.plugins.git.BranchSpec>
          <name>${GITHUB_BRANCH}</name>
        </hudson.plugins.git.BranchSpec>
      </branches>
      <doGenerateSubmoduleConfigurations>false</doGenerateSubmoduleConfigurations>
      <submoduleCfg class="list"/>
      <extensions/>
    </scm>
    <scriptPath>Jenkinsfile</scriptPath>
    <lightweight>true</lightweight>
  </definition>
  <triggers/>
  <disabled>false</disabled>
</flow-definition>
EOF

echo "Creating/updating Jenkins job '${JOB_NAME}'..."

curl -X POST "${JENKINS_URL}/createItem?name=${JOB_NAME}" \
  --user "${JENKINS_USER}:${JENKINS_API_TOKEN}" \
  -H "Content-Type: application/xml" \
  --data-binary @pipeline-job-config.xml 2>/dev/null || echo "Job exists, updating..."

curl -X POST "${JENKINS_URL}/job/${JOB_NAME}/config.xml" \
  --user "${JENKINS_USER}:${JENKINS_API_TOKEN}" \
  -H "Content-Type: application/xml" \
  --data-binary @pipeline-job-config.xml

echo "Jenkins job created/updated."

echo "Triggering Jenkins job build..."
curl -X POST "${JENKINS_URL}/job/${JOB_NAME}/build" --user "${JENKINS_USER}:${JENKINS_API_TOKEN}"

echo "Jenkins job build triggered."
