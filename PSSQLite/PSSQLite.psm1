#handle PS2
if (-not $PSScriptRoot) {
    $PSScriptRoot = Split-Path $MyInvocation.MyCommand.Path -Parent
}


#Pick and import assemblies:
<# 
Switch ($PSEdition) {
    { $_ -eq 'Desktop' -and $IsWindows -and ([IntPtr]::size -eq 8) } {
        write-verbose -message "is Windows 64 PS Desktop, loading..."
        $OS = 'x64'
    }
    { $_ -eq 'Desktop' -and $IsWindows -and ([IntPtr]::size -eq 4) } {
        write-verbose -message "is Windows 64 PS Desktop, loading..."
        $OS = 'x86'
    }
    { $_ -eq 'Core' -and $IsWindows -and ([IntPtr]::size -eq 8) } {
        write-verbose -message "is Windows 64 PS Core, loading..."
        $OS = 'win-x64'
    }
    { $_ -eq 'Core' -and $IsWindows -and ([IntPtr]::size -eq 4) } {
        write-verbose -message "is Windows 64 PS Core, loading..."
        $OS = 'win-x86'
    }
    { $_ -eq 'Core' -and $IsLinux } {
        write-verbose -message "is Linux PS Core, loading..."
        $OS = 'linux-x64'
    }
    { $_ -eq 'Core' -and $isMacOS } {
        write-verbose -message "is MacOS PS Core, loading..."
        $OS = 'osx-x64'
    }
    default {
        Throw "Something is odd with bitness..."
    }
}

Try {
    $PSScriptRoot2 = 'C:\Shared\Powershell\Modules\PSSQLite\1.1.0'
    $SQLiteAssembly = Join-path $PSScriptRoot2 "core\$OS\System.Data.SQLite.dll"
    $SQLiteInterop = Join-path $PSScriptRoot2 "core\$OS\SQLite.Interop.dll"
    Add-Type -path $SQLiteAssembly -CompilerOptions "CFLAGS=-DSQLITE_ENABLE_JSON1" -PassThru -ErrorAction Stop
}
Catch {
    "This module requires the ADO.NET driver for SQLite:`n`thttp://system.data.sqlite.org/index.html/doc/trunk/www/downloads.wiki"
}
 #>

#Get public and private function definition files.
$Public = Get-ChildItem $PSScriptRoot\*.ps1 -ErrorAction SilentlyContinue
#$Private = Get-ChildItem $PSScriptRoot\Private\*.ps1 -ErrorAction SilentlyContinue 

#Dot source the files
Foreach ($import in @($Public)) {
    Try {
        #PS2 compatibility
        if ($import.fullname) {
            . $import.fullname
        }
    }
    Catch {
        Write-Error "Failed to import function $($import.fullname): $_"
    }
}
    
#Create some aliases, export public functions
Export-ModuleMember -Function $($Public | Select -ExpandProperty BaseName)
