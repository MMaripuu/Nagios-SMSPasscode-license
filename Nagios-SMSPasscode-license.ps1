#********************************************************
# NAME : Nagios-SMSPasscode-license.ps1
# Original script by : Patrick Ogenstad
# Modified by : Marius Maripuu & Margus Laul
# Version : 1.0
# DATE : 17th of June 2019
# Description : Compares SMS Passcode license expiration
# date with current date and reports results. 
# 
#
# Feedback & issues:
# https://github.com/MMaripuu/Nagios-SMSPasscode-license/issues
#
#********************************************************

Param(
 [int]$critical = 10,
 [int]$warning = 20
)

$dtSMSlicencexp = (Get-SmspcLicense).expires

$bReturnOK = $TRUE
$bReturnCritical = $FALSE
$bReturnWarning = $FALSE
$returnStateOK = 0
$returnStateWarning = 1
$returnStateCritical = 2
$returnStateUnknown = 3
$nWarning = $warning
$nCritical = $critical

$dtCurrent = Get-Date

$strCritical = ""
$strWarning = ""

$objSMSLicense = Get-SmspcLicense

$dtRemain =  $dtSMSlicencexp - $dtCurrent
$nRemainDays = $dtRemain.Days
 
 if ($nRemainDays -lt 0)
 {
	$strCritical = $strCritical + "EXPIRED " + $objSMSLicense.LicenseAgreement + " expired " + $dtSMSlicencexp.ToString("D") + "`n"
	$bReturnCritical = $TRUE
 } Elseif ( $nRemainDays -lt $nCritical)
 {
    $strCritical = $strCritical +  "Critical " + $objSMSLicense.LicenseAgreement + " expires " + $dtSMSlicencexp.ToString("D") + "`n"
	$bReturnCritical = $TRUE
 } Elseif ( $nRemainDays -lt $nWarning)
 {
    $strWarning = $strWarning + "Warning " + $objSMSLicense.LicenseAgreement + " expires " + $dtSMSlicencexp.ToString("D") + "`n"
	$bReturnWarning = $TRUE
 } 

 if ($bReturnCritical)
{
 write-output $strCritical
 write-output $strWarning
 exit $returnStateCritical
} elseif ($bReturnWarning)
{
 write-output $strWarning
 exit $returnStateWarning
} else
{
 write-output "OK"
 exit $returnStateOK
}
