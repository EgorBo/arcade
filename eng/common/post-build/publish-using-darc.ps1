param(
  [Parameter(Mandatory=$true)][int] $BuildId,
  [Parameter(Mandatory=$true)][string] $AzdoToken,
  [Parameter(Mandatory=$true)][string] $MaestroToken,
  [Parameter(Mandatory=$false)][string] $MaestroApiEndPoint = 'https://maestro-prod.westus2.cloudapp.azure.com',
  [Parameter(Mandatory=$true)][string] $WaitPublishingFinish,
  [Parameter(Mandatory=$true)][string] $EnableSourceLinkValidation,
  [Parameter(Mandatory=$true)][string] $EnableSigningValidation,
  [Parameter(Mandatory=$true)][string] $EnableNugetValidation,
  [Parameter(Mandatory=$true)][string] $PublishInstallersAndChecksums,
  [Parameter(Mandatory=$false)][string] $ArtifactsPublishingAdditionalParameters,
  [Parameter(Mandatory=$false)][string] $SigningValidationAdditionalParameters
)

try {
  . $PSScriptRoot\post-build-utils.ps1
  . $PSScriptRoot\..\darc-init.ps1

  $optionalParams = [System.Collections.ArrayList]::new()

  if ("" -ne $SigningValidationAdditionalParameters) {
    $optionalParams.Add("--signing-validation-parameters") | Out-Null
    $optionalParams.Add($SigningValidationAdditionalParameters) | Out-Null
  }

  if ("" -ne $ArtifactsPublishingAdditionalParameters) {
    $optionalParams.Add("artifact-publishing-parameters") | Out-Null
    $optionalParams.Add($ArtifactsPublishingAdditionalParameters) | Out-Null
  }

  if ("false" -eq $WaitPublishingFinish) {
    $optionalParams.Add("--no-wait") | Out-Null
    $optionalParams.Add("true") | Out-Null
  }

  & darc add-build-to-channel `
	--id $buildId `
	--default-channels `
	--source-branch master `
	--azdev-pat $AzdoToken `
	--bar-uri $MaestroApiEndPoint `
	--password $MaestroToken `
	--publish-installers-and-checksums $PublishInstallersAndChecksums `
	--validate-SDL false `
	--validate-nuget $EnableNugetValidation `
	--validate-sourcelink $EnableSourceLinkValidation `
	--validate-signing $EnableSigningValidation `
	@optionalParams

  if ($LastExitCode -ne 0) {
    Write-Host "Problems using Darc to promote build ${buildId} to default channels. Stopping execution..."
    exit 1
  }

  Write-Host 'done.'
} 
catch {
  Write-Host $_
  Write-PipelineTelemetryError -Category 'PromoteBuild' -Message "There was an error while trying to publish build '$BuildId' to default channels."
  ExitWithExitCode 1
}
