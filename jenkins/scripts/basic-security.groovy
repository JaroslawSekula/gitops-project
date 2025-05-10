#!groovy

import jenkins.model.*
import hudson.security.*

def instance = Jenkins.getInstance()

// Tworzenie użytkownika admin z hasłem admin123
def hudsonRealm = new HudsonPrivateSecurityRealm(false)
hudsonRealm.createAccount("admin", "admin123")
instance.setSecurityRealm(hudsonRealm)

// Przydzielanie uprawnień
def strategy = new FullControlOnceLoggedInAuthorizationStrategy()
strategy.setAllowAnonymousRead(false)
instance.setAuthorizationStrategy(strategy)

instance.save()
