'Wrote two scripts. This is the first one I wrote. Seemed like the PS one gave me better output so I may
'just revisit this one to see if I can make it better. Its just a matter of comparing the WMI commands. 
'TODO. I need to make sure this writes out to a file and that it automatically executes. Otherwise we should be good to
go when I finish making sure the output is where it should be. Anyone with vbscript knowledge is welcome to provide feedback. 
'I'm also a little concerned about people just downloading scripts. These scripts may be treated as viruses by many AV software
'programs. 

'Global Variables
Dim objWMIService, objItem, colItems, strComputer

'Create file to dump output from WMI retrival. 
Set objFSO = CreateObject("Scripting.FileSystemObject")
Set objFile = objFSO.CreateTextFile("sysinfo.txt", True)


'Pulls OS information
Function OSInfo()
strComputer = "."
Set objWMIService = GetObject("winmgmts:" _
    & "{impersonationLevel=impersonate}!\\" & strComputer & "\root\cimv2")
Set colOSes = objWMIService.ExecQuery("Select * from Win32_OperatingSystem")
For Each objOS in colOSes
    objFile.WriteLine "Name: " & objOS.Caption 
'   objFile.WriteLine "OSArchitecture: " & objOS.OSArchitecture 
    objFile.WriteLine "Service Pack: " & objOS.ServicePackMajorVersion & "." & _ 
    objOS.ServicePackMinorVersion
    objFile.WriteLine ""
Next
End Function

'pulls memory information and evaluates if the memory passes the KOC requirements. 
Function MemInfo()
Set colSettings = objWMIService.ExecQuery _
    ("Select * from Win32_ComputerSystem")
For Each objComputer in colSettings
    objFile.WriteLine "Total Physical Memory: " & _
    (Round(objComputer.TotalPhysicalMemory / 2^20,2)) & " Megabytes"
    if (objComputer.TotalPhysicalMemory / 2^20 > 500) Then
	objFile.WriteLine "This computer meets minimum RAM requirements."
    else
	objFile.WriteLine "This computer does not meet minimum RAM requirements."
    End If
Next
End Function

Function HDInfo()
Set colItems = objWMIService.ExecQuery _
("Select * from Win32_LogicalDisk")
For Each objItem in colItems
    objFile.WriteLine "Description: " & objItem.Description 
    objFile.WriteLine "Volume Name: " & objItem.VolumeName 
    objFile.WriteLine "Drive Type: " & objItem.DriveType 
    objFile.WriteLine "Media Type: " & objItem.MediaType 
    objFile.WriteLine "VolumeSerialNumber: " & objItem.VolumeSerialNumber 
    objFile.WriteLine "Size: " & Int(objItem.Size /1048576) & " MB" 
    objFile.WriteLine "Free Space: " & Int(objItem.FreeSpace /1048576) & " MB"  
Next
End Function 


Function CompInfo()
Set colSettings = objWMIService.ExecQuery _
    ("Select * from Win32_ComputerSystem")
For Each objComputer in colSettings 
    objFile.WriteLine "System Manufacturer: " & objComputer.Manufacturer 
    objFile.WriteLine "System Model: " & objComputer.Model 
Next
End Function

Function ProcInfo()
Set colSettings = objWMIService.ExecQuery _
    ("Select * from Win32_Processor")
For Each objProcessor in colSettings 
    objFile.WriteLine "Processor Name: " & objProcessor.Name  
Next
End Function

Function CDInfo()
Set colItems = objWMIService.ExecQuery( _
	"Select * from Win32_CDROMDrive")
For Each objItem in colItems
    objFile.WriteLine "Description: " & objItem.Description
    objFile.WriteLine "Name: " & objItem.Name 
Next
End Function 

'USB Info
Function USBInfo()
Set objWMIService = GetObject("winmgmts:\\" & strComputer & "\root\cimv2") 
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
   Next    
Next
End Function


Function NetworkInfo()
Set colItems = objWMIService.ExecQuery("Select * from Win32_NetworkAdapter",,48)
For Each objItem in colItems
	objFile.WriteLine "DeviceID: " & objItem.DeviceID
	objFile.WriteLine "Description: " & objItem.Description
    objFile.WriteLine "Manufacturer: " & objItem.Manufacturer
Next
End Function

'Call all the functions and display information 

Wscript.Echo "System Information Generator Tool"
Wscript.Echo ""
Wscript.Echo "" 
Wscript.Echo "Operating System Information"
OSInfo()
Wscript.Echo "" 
Wscript.Echo "Memory Information"
MemInfo()
Wscript.Echo "" 
Wscript.Echo "Hard Drive Information"
HDInfo()
Wscript.Echo "Computer Information"
CompInfo()
Wscript.Echo "" 
Wscript.Echo "Processor Information"
ProcInfo()
Wscript.Echo ""
Wscript.Echo "CD Information"
CDInfo()
Wscript.Echo ""
Wscript.Echo "USB Information"
USBInfo()
Wscript.Echo "" 
Wscript.Echo "Network Information"
NetworkInfo()