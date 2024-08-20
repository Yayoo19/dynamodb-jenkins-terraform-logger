import jenkins.model.*
import hudson.model.*
import hudson.util.*

def jobName = 'LambdaJob'
def jobConfigXml = '''
<project>
  <actions/>
  <description>A job that invokes an AWS Lambda function during build</description>
  <keepDependencies>false</keepDependencies>
  <properties/>
  <scm class="hudson.scm.NullSCM"/>
  <builders>
    <hudson.tasks.Shell>
      <command>
        # Invoke the Lambda function
        aws lambda invoke \
          --function-name IncrementalLogFunction \
          --payload '{"timestamp": "2024-08-20T12:34:56Z", "message": "Sample log entry"}' \
          response.json cat response.json
      </command>
    </hudson.tasks.Shell>
  </builders>
  <publishers/>
  <buildWrappers/>
</project>
'''

def jenkins = Jenkins.getInstance()

if (jenkins.getItem(jobName) == null) {
  jenkins.createProjectFromXML(jobName, new ByteArrayInputStream(jobConfigXml.getBytes("UTF-8")))
  println "Job '${jobName}' created successfully."
} else {
  println "Job '${jobName}' already exists."
}
