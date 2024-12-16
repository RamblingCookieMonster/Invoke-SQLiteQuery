function Update-Sqlite {
	[CmdletBinding()]

	param(
		[Parameter()]
		[System.Version]
		$version = '1.0.119',

		[Parameter()]
		[ValidateSet('linux-x64', 'osx-x64', 'win-x64', 'win-x86')]
		[string[]]
		$OS = ('linux-x64', 'osx-x64', 'win-x64', 'win-x86')
	)

	Process {
		write-verbose "Creating build directory"
		New-Item -ItemType directory build
		Set-Location build

		$file = "stub.system.data.sqlite.core.netstandard.$version"

		write-verbose "downloading files from nuget"
		$dl = @{
			uri     = "https://www.nuget.org/api/v2/package/Stub.System.Data.SQLite.Core.NetStandard/$version"
			outfile = "$file.nupkg"
		}
		Invoke-WebRequest @dl

		write-verbose "unpacking and copying files to module directory"
		Expand-Archive $dl.outfile

		$InstallPath = (get-module PSSQlite).path.TrimEnd('PSSQLite.psm1')
		foreach ($o in $OS) {
			copy-item $file/lib/netstandard2.0/System.Data.SQLite.dll $InstallPath/core/$o/
			copy-item $file/runtimes/$o/native/SQLite.Interop.dll $InstallPath/core/$o/
		}

		write-verbose "removing build folder"
		Set-location ..
		#remove-item ./build -recurse
		write-verbose "complete"

		Write-Warning "Please reimport the module to use the latest files"
	}
}
