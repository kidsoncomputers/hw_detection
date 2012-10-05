#* Retrieve Sys Info
Function SysInfo {
$colItems = Get-WmiObject Win32_ComputerSystem -ComputerName $strComputer
foreach($objItem in $colItems) {
Write-Host “Computer Manufacturer: ” $objItem.Manufacturer
Write-Host “Computer Model: ” $objItem.Model
$displayMB = [math]::round($objItem.TotalPhysicalMemory/1024/1024, 0)
write-host "Total Physical Memory: " $displayMB "MB"
if($objItem.TotalPhysicalMemory -ge "1048576"){write-host "This computer meets KOC RAM Standards."}elseif
($objItem.TotalPhysicalMemory -lt "1048576"){write-host "This computer does not meet KOC RAM Standards."}
}
}

#* Retrieve BIOS Info
Function BIOSInfo {
$colItems = Get-WmiObject Win32_BIOS -Computername $strComputer
foreach($objItem in $colItems) {
Write-Host “BIOS:”$objItem.Description
Write-Host “Version:”$objItem.SMBIOSBIOSVersion”.”`
$objItem.SMBIOSMajorVersion”.”$objItem.SMBIOSMinorVersion
}
}
#* Retrieve OSInfo
Function OSInfo {
$colItems = Get-WmiObject Win32_OperatingSystem -Computername $strComputer
foreach($objItem in $colItems) {
Write-Host “Operating System:” $objItem.Caption
}
}
#* Retrieve CPU Info
Function CPUInfo {
$colItems = Get-WmiObject Win32_Processor  -Computername $strComputer
foreach($objItem in $colItems) {
Write-Host “Processor:” $objItem.DeviceID $objItem.Name
}
}
Function DiskInfo {
$colItems = Get-WmiObject Win32_DiskDrive -ComputerName $strComputer
foreach($objItem in $colItems) {
Write-Host “Disk:” $objItem.DeviceID
Write-Host “Size:” $objItem.Size “bytes”
Write-Host “Drive Type:” $objItem.InterfaceType
Write-Host “Media Type: ” $objItem.MediaType
}
}
Function CDInfo {
$colItems = Get-Wmiobject Win32_CDROMDrive -ComputerName $strComputer
foreach($objItem in $colItems) {
Write-Host "Name: " $objItem.Caption
}
}
Function NetworkInfo {
$colItems = Get-WmiObject Win32_NetworkAdapterConfiguration -Computername $strComputer | where{$_.IPEnabled -eq “True”}
foreach($objItem in $colItems) {
Write-Host “Description:” $objItem.Description
}
}

Function USBInfo {
$colItems = Get-WmiObject Win32_USBControllerDevice | Foreach-Object { [Wmi]$_.Dependent }
foreach($objItem in $colItems) {
Write-Host "Name: " $objItem.Name
}
}

#* Connect to computer
$strComputer = “.”
#* Call SysInfo Function
Write-Host “Sytem Information”
SysInfo
Write-Host
#* Call BIOSinfo Function
Write-Host “System BIOS Information”
BIOSInfo
Write-Host
#* Call OSInfo Function
Write-Host “Operating System Information”
OSInfo
Write-Host
#* Call CPUInfo Function
Write-Host “Processor Information”
CPUInfo
Write-Host
#* Call DiskInfo Function
Write-Host “Disk Information”
DiskInfo
Write-Host
#* Call NetworkInfo Function
Write-Host “Network Information”
NetworkInfo
Write-Host
Write-Host "USB Information" 
USBInfo
Write-Host
Write-Host "CD Information"
CDInfo
Write-Host 