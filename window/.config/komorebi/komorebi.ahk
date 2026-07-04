#Requires AutoHotkey v2.0.2
#SingleInstance Force

Komorebic(cmd) {
    RunWait(Format('komorebic.exe {}', cmd), , 'Hide')
}

RunWaitOne(command) {
    shell := ComObject("WScript.Shell")
    exec := shell.Exec(command)
    stdout := exec.StdOut.ReadAll()
    stderr := exec.StdErr.ReadAll()
    return stdout "`n" stderr
}

GetKomorebiJsonPath() {
    return EnvGet("USERPROFILE") "\.config\komorebi\komorebi.json"
}

ReloadKomorebiConfig() {
    RunWait("komorebic.exe reload-configuration", , "Hide")
    TrayTip "Komorebi", "已重載 komorebi.json", 1500
}

AddExeToIgnoreRules(exeName) {
    komorebiJson := GetKomorebiJsonPath()

    if !FileExist(komorebiJson) {
        MsgBox "找不到 komorebi.json:`n" komorebiJson
        return false
    }

    escPath := StrReplace(komorebiJson, "'", "''")
    escExe  := StrReplace(exeName, "'", "''")

    ps :=
    (
        "$path = '" escPath "'`n"
      . "$exe  = '" escExe "'`n"
      . "$utf8NoBom = New-Object System.Text.UTF8Encoding($false)`n"
      . "$jsonText = [System.IO.File]::ReadAllText($path)`n"
      . "$data = $jsonText | ConvertFrom-Json`n"
      . "if ($null -eq $data.ignore_rules) {`n"
      . "    $data | Add-Member -NotePropertyName ignore_rules -NotePropertyValue @()`n"
      . "}`n"
      . "$exists = $false`n"
      . "foreach ($rule in $data.ignore_rules) {`n"
      . "    if ($rule.kind -eq 'Exe' -and $rule.id -eq $exe -and $rule.matching_strategy -eq 'Equals') {`n"
      . "        $exists = $true`n"
      . "        break`n"
      . "    }`n"
      . "}`n"
      . "if (-not $exists) {`n"
      . "    $newRule = [pscustomobject]@{`n"
      . "        kind = 'Exe'`n"
      . "        id = $exe`n"
      . "        matching_strategy = 'Equals'`n"
      . "    }`n"
      . "    $data.ignore_rules += $newRule`n"
      . "    $newJson = $data | ConvertTo-Json -Depth 100`n"
      . "    [System.IO.File]::WriteAllText($path, $newJson, $utf8NoBom)`n"
      . "    komorebic reload-configuration`n"
      . "    Write-Output 'ADDED'`n"
      . "} else {`n"
      . "    Write-Output 'EXISTS'`n"
      . "}`n"
    )

    cmd := 'powershell -NoProfile -ExecutionPolicy Bypass -Command ' . Chr(34) . ps . Chr(34)
    result := RunWaitOne(cmd)

    if InStr(result, "ADDED") {
        TrayTip "Komorebi", "已加入 ignore_rules: " exeName, 2000
        return true
    } else if InStr(result, "EXISTS") {
        TrayTip "Komorebi", "ignore_rules 已存在: " exeName, 2000
        return true
    } else {
        MsgBox "寫入 ignore_rules 失敗:`n`n" result
        return false
    }
}

; Debug: 顯示目前作用中視窗資訊
^!p::
{
    hwnd := WinExist("A")
    if !hwnd {
        MsgBox 'WinExist("A") 拿不到 HWND'
        return
    }

    title := WinGetTitle("ahk_id " hwnd)
    class := WinGetClass("ahk_id " hwnd)
    exe := WinGetProcessName("ahk_id " hwnd)

    MsgBox("HWND: " hwnd "`nTitle: " title "`nClass: " class "`nExe: " exe)
}

; Reload shortcuts
^!r::ReloadKomorebiConfig()

^!+r::
{
    TrayTip "AHK", "重新載入 komorebi.ahk", 1000
    Reload()
}

; Komorebic window management shortcuts
!q::Komorebic("close")
!m::Komorebic("manage")

; Alt+U：先抓目前視窗 exe，再 unmanage，最後永久加入 ignore_rules
!u::
{
    hwnd := WinExist("A")
    if !hwnd {
        MsgBox 'WinExist("A") 拿不到 HWND'
        return
    }

    exeName := WinGetProcessName("ahk_id " hwnd)
    if !exeName {
        MsgBox "無法取得目前視窗的程序名稱"
        return
    }

    Komorebic("unmanage")
    AddExeToIgnoreRules(exeName)
}

!+m::Komorebic("minimize")

; Focus windows - Alt + h/j/k/l
!h::Komorebic("focus left")
!j::Komorebic("focus down")
!k::Komorebic("focus up")
!l::Komorebic("focus right")

; Cycle focus previous/next - Alt + Shift + [ or ]
!+SC1A::Komorebic("cycle-focus previous")
!+SC1B::Komorebic("cycle-focus next")

; Move windows - Alt + Shift + h/j/k/l
!+h::Komorebic("move left")
!+j::Komorebic("move down")
!+k::Komorebic("move up")
!+l::Komorebic("move right")
!+Enter::Komorebic("promote")

; Stack windows - Alt + Arrow keys
!Left::Komorebic("stack left")
!Down::Komorebic("stack down")
!Up::Komorebic("stack up")
!Right::Komorebic("stack right")

; Stack manipulation - Alt + ; / [ / ]
!;::Komorebic("unstack")
!SC1A::Komorebic("cycle-stack previous")
!SC1B::Komorebic("cycle-stack next")

; Resize windows - horizontal - Alt + + / -
!NumpadAdd::Komorebic("resize-axis horizontal increase")
!NumpadSub::Komorebic("resize-axis horizontal decrease")

; Resize windows - vertical - Alt + Shift + + / -
!+NumpadAdd::Komorebic("resize-axis vertical increase")
!+NumpadSub::Komorebic("resize-axis vertical decrease")

; Manipulate windows - Alt + t / Alt + Shift + f
!t::Komorebic("toggle-float")
!+f::Komorebic("toggle-monocle")

; Window manager options - Alt + Shift + r / Alt + p
!+r::Komorebic("retile")
!p::Komorebic("toggle-pause")

; Layout flips - Alt + x / y
!x::Komorebic("flip-layout horizontal")
!y::Komorebic("flip-layout vertical")

; Workspaces focus - Alt + 1..8 (workspaces 0..7)
!1::Komorebic("focus-workspace 0")
!2::Komorebic("focus-workspace 1")
!3::Komorebic("focus-workspace 2")
!4::Komorebic("focus-workspace 3")
!5::Komorebic("focus-workspace 4")
!6::Komorebic("focus-workspace 5")
!7::Komorebic("focus-workspace 6")
!8::Komorebic("focus-workspace 7")

; Move windows across workspaces - Alt + Shift + 1..8
!+1::Komorebic("move-to-workspace 0")
!+2::Komorebic("move-to-workspace 1")
!+3::Komorebic("move-to-workspace 2")
!+4::Komorebic("move-to-workspace 3")
!+5::Komorebic("move-to-workspace 4")
!+6::Komorebic("move-to-workspace 5")
!+7::Komorebic("move-to-workspace 6")
!+8::Komorebic("move-to-workspace 7")