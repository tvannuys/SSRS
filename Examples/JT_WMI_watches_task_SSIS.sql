

----------------
--
-- WMC Services

-- WITHIN 10 is 10 seconds (Default is 0)
-- ISA = is a .....

--Report when a file hits a folder:
SELECT * FROM __instanceCreationEvent WITHIN 10 
WHERE TargetInstance ISA "CIM_DirectoryContainsFile"
AND TagertInstance.GroupComponent = "Win32_Directory.Name=\"c:\\\\SSISFileWatcher\""



-- Watch for a specific app to kick off:
-- Just like in TASK MGR under services/name
SELECT * FROM __InstanceCreationEvent WITHIN 10
WHERE TargetInstance ISA "Win32_process"
AND TargetInstance.Name = "profiler.exe"

-- Watch for writes to Application event log:
SELECT * FROM __InstanceCreationEvent WITHIN 10
WHERE TargetInstance ISA "Win32_NTLogEvent"
AND TargetInstance.Logfile = "Application"