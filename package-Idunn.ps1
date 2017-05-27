$root = (split-path -parent $MyInvocation.MyCommand.Definition)
$lib = "$root\.package\Idunn\lib\45\"
$tools = "$root\.package\Idunn\tools\"

if (Test-Path $root\.package\Idunn\)
{
	Remove-Item $root\.package\Idunn\ -recurse
}


Copy-Item $root\packaging\Idunn $root\.package\Idunn -Recurse

if (-not (Test-Path $tools))
{
    new-item -Path $tools -ItemType directory
}
Copy-Item $root\Idunn.Console\bin\Debug\Idunn.exe $tools
Copy-Item $root\Idunn.Console\bin\Debug\Idunn.pdb $tools

$version = $env:GitVersion_NuGetVersion
if ([string]::IsNullOrEmpty($version))
{
    Write-Warning "No version found in environment variables, using version of the dll"
    $version = (Get-Item $tools\Idunn.exe).VersionInfo.FileVersion
}
Write-Host "Setting .nuspec version tag to $version"

$content = (Get-Content $root\Idunn.nuspec -Encoding UTF8) 
$content = $content -replace '\$version\$',$version

$content | Out-File $root\.package\Idunn\Idunn.compiled.nuspec -Encoding UTF8

new-item -Path $root\.nupkg -ItemType directory -force
& NuGet.exe pack $root\.package\Idunn\Idunn.compiled.nuspec -Version $version -OutputDirectory $root\.nupkg

