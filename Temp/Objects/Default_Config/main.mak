SHELL := cmd.exe
CYGWIN=nontsec
export PATH := C:\WINDOWS\system32;C:\WINDOWS;C:\WINDOWS\System32\Wbem;C:\WINDOWS\System32\WindowsPowerShell\v1.0\;C:\Program Files (x86)\Windows Live\Shared;C:\Program Files\NVIDIA Corporation\NVIDIA NvDLISR;C:\Program Files (x86)\Windows Kits\8.1\Windows Performance Toolkit\;C:\Program Files (x86)\NVIDIA Corporation\PhysX\Common;C:\Program Files\dotnet\;C:\Users\Admin\AppData\Local\Microsoft\WindowsApps;C:\Users\Admin\AppData\Local\Programs\Microsoft VS Code\bin;C:\Program Files (x86)\Common Files\Hilscher GmbH\TLRDecode;C:\Users\Admin\AppData\Local\Microsoft\WindowsApps;C:\Users\Admin\AppData\Local\Programs\Microsoft VS Code\bin;C:\Program Files (x86)\Common Files\Hilscher GmbH\TLRDecode;D:\BRAutomation\AS410\Bin-en\4.10;D:\BRAutomation\AS410\Bin-en\4.9;D:\BRAutomation\AS410\Bin-en\4.8;D:\BRAutomation\AS410\Bin-en\4.7;D:\BRAutomation\AS410\Bin-en\4.6;D:\BRAutomation\AS410\Bin-en\4.5;D:\BRAutomation\AS410\Bin-en\4.4;D:\BRAutomation\AS410\Bin-en\4.3;D:\BRAutomation\AS410\Bin-en\4.2;D:\BRAutomation\AS410\Bin-en\4.1;D:\BRAutomation\AS410\Bin-en\4.0;D:\BRAutomation\AS410\Bin-en
export AS_BUILD_MODE := BuildAndCreateCompactFlash
export AS_VERSION := 4.10.2.37
export AS_WORKINGVERSION := 4.10
export AS_COMPANY_NAME :=  
export AS_USER_NAME := Admin
export AS_PATH := D:/BRAutomation/AS410
export AS_BIN_PATH := D:/BRAutomation/AS410/Bin-en
export AS_PROJECT_PATH := D:/Downloads/ASDP\ Exam\ -\ Group\ 4B/Palletizer
export AS_PROJECT_NAME := Palletizer
export AS_SYSTEM_PATH := D:/BRAutomation/AS/System
export AS_VC_PATH := D:/BRAutomation/AS410/AS/VC
export AS_TEMP_PATH := D:/Downloads/ASDP\ Exam\ -\ Group\ 4B/Palletizer/Temp
export AS_CONFIGURATION := Default_Config
export AS_BINARIES_PATH := D:/Downloads/ASDP\ Exam\ -\ Group\ 4B/Palletizer/Binaries
export AS_GNU_INST_PATH := D:/BRAutomation/AS410/AS/GnuInst/V4.1.2
export AS_GNU_BIN_PATH := D:/BRAutomation/AS410/AS/GnuInst/V4.1.2/4.9/bin
export AS_GNU_INST_PATH_SUB_MAKE := D:/BRAutomation/AS410/AS/GnuInst/V4.1.2
export AS_GNU_BIN_PATH_SUB_MAKE := D:/BRAutomation/AS410/AS/GnuInst/V4.1.2/4.9/bin
export AS_INSTALL_PATH := D:/BRAutomation/AS410
export WIN32_AS_PATH := "D:\BRAutomation\AS410"
export WIN32_AS_BIN_PATH := "D:\BRAutomation\AS410\Bin-en"
export WIN32_AS_PROJECT_PATH := "D:\Downloads\ASDP Exam - Group 4B\Palletizer"
export WIN32_AS_SYSTEM_PATH := "D:\BRAutomation\AS\System"
export WIN32_AS_VC_PATH := "D:\BRAutomation\AS410\AS\VC"
export WIN32_AS_TEMP_PATH := "D:\Downloads\ASDP Exam - Group 4B\Palletizer\Temp"
export WIN32_AS_BINARIES_PATH := "D:\Downloads\ASDP Exam - Group 4B\Palletizer\Binaries"
export WIN32_AS_GNU_INST_PATH := "D:\BRAutomation\AS410\AS\GnuInst\V4.1.2"
export WIN32_AS_GNU_BIN_PATH := "$(WIN32_AS_GNU_INST_PATH)\\bin" 
export WIN32_AS_INSTALL_PATH := "D:\BRAutomation\AS410"

.suffixes:

ProjectMakeFile:

	@'$(AS_BIN_PATH)/4.9/BR.AS.AnalyseProject.exe' '$(AS_PROJECT_PATH)/Palletizer.apj' -t '$(AS_TEMP_PATH)' -c '$(AS_CONFIGURATION)' -o '$(AS_BINARIES_PATH)'   -sfas -buildMode 'BuildAndCreateCompactFlash'   

