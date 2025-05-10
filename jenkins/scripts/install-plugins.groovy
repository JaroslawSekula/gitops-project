#!groovy

import jenkins.model.*
import hudson.model.*
import java.util.logging.Logger

def logger = Logger.getLogger("")
def instance = Jenkins.getInstance()

def pluginParameterList = [
  "git",                       
  "workflow-aggregator",       
  "credentials",               
  "plain-credentials",         
  "matrix-auth",               
  "antisamy-markup-formatter", 
  "email-ext",                 
  "mailer",                    
  "pipeline-stage-view",       
  "pipeline-github-lib",       
  "git-client",                
  "ssh-slaves",               
  "timestamper",               
  "ws-cleanup",                
  "command-launcher",          
  "resource-disposer",         
  "durable-task",             
  "script-security",           
  "structs",                  
  "scm-api",                 
  "workflow-step-api",
  "workflow-support",
  "workflow-job",
  "workflow-cps",
  "workflow-api",
  "workflow-basic-steps"
]

def pm = instance.getPluginManager()
def uc = instance.getUpdateCenter()

pluginParameterList.each { pluginName ->
    if (!pm.getPlugin(pluginName)) {
        logger.info(">>> Installing plugin: ${pluginName}")
        def plugin = uc.getPlugin(pluginName)
        if (plugin) {
            plugin.deploy()
        } else {
            logger.warning(">>> Plugin ${pluginName} not found in Update Center")
        }
    }
}

instance.save()
