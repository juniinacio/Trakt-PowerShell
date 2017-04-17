###############################################################################
# Customize these properties and tasks
###############################################################################
param(
    $Artifacts = './artifacts',
    $ModuleName = 'Trakt-PowerShell',
    $ModulePath = './Trakt-PowerShell',
    $BuildNumber = $env:BUILD_NUMBER,
    $PercentCompliance  = '60'
)

###############################################################################
# Static settings -- no reason to include these in the param block
###############################################################################
$Settings = @{
    Author =  "Juni Inacio"
    Owners = "Juni Inacio"
    LicenseUrl = 'https://github.com/juniinacio/Trakt-PowerShell/blob/master/LICENSE'
    ProjectUrl = "https://github.com/juniinacio/Trakt-PowerShell/"
    PackageDescription = "A PowerShell module for managing your Trakt.TV account."
    Repository = 'https://github.com/juniinacio/Trakt-PowerShell'
    Tags = ""
    
    GitRepo = "juniinacio/Trakt-PowerShell"
    CIUrl = "http://jenkins/job/Trakt-PowerShell/"
}

###############################################################################
# Before/After Hooks for the Core Task: Clean
###############################################################################

# Synopsis: Executes before the Clean task.
task BeforeClean {}

# Synopsis: Executes after the Clean task.
task AfterClean {}

###############################################################################
# Before/After Hooks for the Core Task: Analyze
###############################################################################

# Synopsis: Executes before the Analyze task.
task BeforeAnalyze {}

# Synopsis: Executes after the Analyze task.
task AfterAnalyze {}

###############################################################################
# Before/After Hooks for the Core Task: Archive
###############################################################################

# Synopsis: Executes before the Archive task.
task BeforeArchive {}

# Synopsis: Executes after the Archive task.
task AfterArchive {}

###############################################################################
# Before/After Hooks for the Core Task: Publish
###############################################################################

# Synopsis: Executes before the Publish task.
task BeforePublish {}

# Synopsis: Executes after the Publish task.
task AfterPublish {}

###############################################################################
# Before/After Hooks for the Core Task: Test
###############################################################################

# Synopsis: Executes before the Test Task.
task BeforeTest {

}

# Synopsis: Executes after the Test Task.
task AfterTest {}