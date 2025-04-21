# Create folder structure summary
Get-ChildItem -Path lib -Recurse -Name | Out-File -Encoding utf8 lib_structure.txt

# Extract class and override-related code lines
Get-ChildItem -Recurse -Filter *.dart |
  Select-String -Pattern 'class ', '@override', 'Widget build', 'extends', 'implements', 'State<' |
  Sort-Object Filename, LineNumber |
  Out-File -Encoding utf8 lib_class_summary.txt

Write-Output "`n✅ Done! Files created:`n  - lib_structure.txt`n  - lib_class_summary.txt"
