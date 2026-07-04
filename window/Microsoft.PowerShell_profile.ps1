chcp 65001
$OutputEncoding = [Console]::OutputEncoding = [System.Text.Encoding]::UTF8
Invoke-Expression (&sfsu hook)
Invoke-Expression (&starship init powershell)
Invoke-Expression (& { (zoxide init powershell | Out-String) })
Remove-Item alias:ls
Remove-Item alias:cat
function Invoke-EzaCommand {
    eza --icons "auto" $args
}
Set-Alias -Name "ls" -Value Invoke-EzaCommand
Set-Alias -Name "cat" -Value "bat"
Import-Module gsudoModule
