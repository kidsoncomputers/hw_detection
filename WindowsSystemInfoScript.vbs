strComputer = "."
Set objWMIService = GetObject("winmgmts:" _
    & "{impersonationLevel=impersonate}!\\" & strComputer & "\root\cimv2")
Set colOSes = objWMIService.ExecQuery("Select * from Win32_OperatingSystem")
For Each objOS in colOSes
  Wscript.Echo "Operating System" >> testscript2.txt
  Wscript.Echo "  Name: " & objOS.Caption 
  Wscript.Echo "  OSArchitecture: " & objOS.OSArchitecture 
    WScript.Echo "  ServicePackMajorVersion: " & objOS.ServicePackMajorVersion & "." & _
   objOS.ServicePackMinorVersion 
Next
Set colSettings = objWMIService.ExecQuery _
    ("Select * from Win32_ComputerSystem")
For Each objComputer in colSettings
  Wscript.Echo "Memory Information"  
   Wscript.Echo "	Total Physical Memory: " & _
        objComputer.TotalPhysicalMemory / 2^20 & "Megabytes"
Next
Set colSettings = objWMIService.ExecQuery _
    ("Select * from Win32_ComputerSystem")
For Each objComputer in colSettings 
    Wscript.Echo "Computer Manufacturer Information" 
	Wscript.Echo "	System Manufacturer: " & objComputer.Manufacturer 
    Wscript.Echo "	System Model: " & objComputer.Model 
Next
Set colSettings = objWMIService.ExecQuery _
    ("Select * from Win32_Processor")
For Each objProcessor in colSettings 
    Wscript.Echo "Processor Information" 
	Wscript.Echo "	Processor Name: " & objProcessor.Name 
Next
Set colItems = objWMIService.ExecQuery( _
    "Select * from Win32_CDROMDrive")
For Each objItem in colItems
    Wscript.Echo "Device ID: " & objItem.DeviceID
    Wscript.Echo "Description: " & objItem.Description
    Wscript.Echo "Name: " & objItem.Name 
Next
Set colChassis = objWMIService.ExecQuery _
    ("Select * from Win32_SystemEnclosure")
For Each objChassis in colChassis
    For Each objItem in objChassis.ChassisTypes
        Wscript.Echo "Chassis Type: " & objItem
    Next
Next

