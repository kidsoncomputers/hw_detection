
Dim objWMIService, objItem, colItems, strComputer
'Create file to dump output from WMI retrival. 
Set objFSO = CreateObject("Scripting.FileSystemObject")
Set objFile = objFSO.CreateTextFile("sysinfo.txt", True)

'Create a message box to inform user the script is working. 
MsgBox "Generating System Information....", 1, "System Info Generator"

'Tells the computer to grab the information locally and sets up the OS retrieval. 
strComputer = "."
Set objWMIService = GetObject("winmgmts:" _
    & "{impersonationLevel=impersonate}!\\" & strComputer & "\root\cimv2")
	
'Pulls OS information
Set colOSes = objWMIService.ExecQuery("Select * from Win32_OperatingSystem")
For Each objOS in colOSes
objFile.WriteLine "Operating System Information"
objFile.WriteLine "---------------------------------------------------"
objFile.WriteLine "Name: " & objOS.Caption 
objFile.WriteLine "OSArchitecture: " & objOS.OSArchitecture 
objFile.WriteLine "Service Pack: " & objOS.ServicePackMajorVersion & "." & _ 
   objOS.ServicePackMinorVersion
 objFile.WriteLine ""
Next

'pulls memory information and evaluates if the memory passes the KOC requirements. 
Set colSettings = objWMIService.ExecQuery _
    ("Select * from Win32_ComputerSystem")
For Each objComputer in colSettings
objFile.WriteLine "Memory Information"  
objFile.WriteLine "---------------------------------------------------"
objFile.WriteLine "Total Physical Memory: " & _
(Round(objComputer.TotalPhysicalMemory / 2^20,2)) & " Megabytes"
if (objComputer.TotalPhysicalMemory / 2^20 > 500) Then
	objFile.WriteLine "This computer meets minimum RAM requirements."
	else
		objFile.WriteLine "This computer does not meet minimum RAM requirements."
End If
objFile.WriteLine""
Next

Set colItems = objWMIService.ExecQuery _
("Select * from Win32_LogicalDisk")
objFile.WriteLine "Description: " & objItem.Description 
objFile.WriteLine "Volume Name: " & objItem.VolumeName 
objFile.WriteLine "Drive Type: " & objItem.DriveType 
objFile.WriteLine "Media Type: " & objItem.MediaType 
objFile.WriteLine "VolumeSerialNumber: " & objItem.VolumeSerialNumber 
objFile.WriteLine "Size: " & Int(objItem.Size /1073741824) & " GB" 
objFile.WriteLine "Free Space: " & Int(objItem.FreeSpace /1073741824) & " GB"  

'Pulls information about the computer System itself
Set colSettings = objWMIService.ExecQuery _
    ("Select * from Win32_ComputerSystem")
For Each objComputer in colSettings 
objFile.WriteLine "Computer Manufacturer Information" 
objFile.WriteLine "---------------------------------------------------"
objFile.WriteLine "System Manufacturer: " & objComputer.Manufacturer 
objFile.WriteLine "System Model: " & objComputer.Model 
objFile.WriteLine "" 
Next

'Pulls Process Info
Set colSettings = objWMIService.ExecQuery _
    ("Select * from Win32_Processor")
For Each objProcessor in colSettings 
objFile.WriteLine "Processor Information"
objFile.WriteLine "---------------------------------------------------"
objFile.WriteLine "Processor Name: " & objProcessor.Name 
objFile.WriteLine "" 
Next

'Optical Drive Info
Set colItems = objWMIService.ExecQuery( _
    "Select * from Win32_CDROMDrive")
For Each objItem in colItems
objFile.WriteLine "Optical Drive Information"
objFile.WriteLine "---------------------------------------------------"
objFile.WriteLine "Description: " & objItem.Description
objFile.WriteLine "Name: " & objItem.Name 
objFile.WriteLine ""
Next

'USB Info
Set objWMIService = GetObject("winmgmts:\\" & strComputer & "\root\cimv2") 
objFile.WriteLine "USB Information"
objFile.WriteLine "---------------------------------------------------"
Set colDevices = objWMIService.ExecQuery _ 
   ("Select * From Win32_USBControllerDevice") 

For Each objDevice in colDevices 
   strDeviceName = objDevice.Dependent 
   strQuotes = Chr(34) 
   strDeviceName = Replace(strDeviceName, strQuotes, "") 
   arrDeviceNames = Split(strDeviceName, "=") 
   strDeviceName = arrDeviceNames(1) 

Set colUSBDevices = objWMIService.ExecQuery _ 
       ("Select * From Win32_PnPEntity Where DeviceID = '" & strDeviceName & "'") 
   For Each objUSBDevice in colUSBDevices
       objFile.WriteLine "Description: " & objUSBDevice.Description 
       objFile.WriteLine "PnpDevID: " & objUSBDevice.PnPDeviceID                       
	   objFile.WriteLine ""
   Next    
Next
'Network Adapter Information
objFile.WriteLine "Network Adapter Information"
objFile.WriteLine "---------------------------------------------------"
Set colItems = objWMIService.ExecQuery("Select * from Win32_NetworkAdapter",,48)
For Each objItem in colItems
    objFile.WriteLine ""
	objFile.WriteLine "DeviceID: " & objItem.DeviceID
	objFile.WriteLine "Description: " & objItem.Description
    objFile.WriteLine "Manufacturer: " & objItem.Manufacturer
	objFile.WriteLine ""
Next

MsgBox "Generated System Information. Please review the file sysinfo.txt on the Desktop.", 1, "System Info Generator"