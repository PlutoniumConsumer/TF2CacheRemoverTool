$global:DefaultFolderPath = "C:\Program Files (x86)\Steam\steamapps\common\Team Fortress 2\tf\custom"
$global:CustomFolderPath = $global:DefaultFolderPath
$global:SecretInput = ""

$global:MenuHeaderColor = 'DarkCyan'
$global:MenuTitleColor = 'Yellow'
$global:MenuOptionColors = @{
    '1' = 'White'
    '2' = 'White'
    '3' = 'White'
    '4' = 'White'
    '5' = 'White'
    '6' = 'White'
    '7' = 'White'
    '8' = 'White'
    '9' = 'White'
}

function Pause-Terminal {
    Write-Host ""
    Read-Host -Prompt "Press Enter to continue..."
}

function Show-Header {
    Clear-Host
    Write-Host ""
    Write-Host "==========================================" -ForegroundColor $global:MenuHeaderColor
    Write-Host "         TF2 Cache Remover Tool           " -ForegroundColor $global:MenuTitleColor
    Write-Host "==========================================" -ForegroundColor $global:MenuHeaderColor
    Write-Host ""
}

function Show-Menu {
    Show-Header
    Write-Host "  [1] Start Cleanup" -ForegroundColor $global:MenuOptionColors['1']
    Write-Host "  [2] Set Custom Folder Location" -ForegroundColor $global:MenuOptionColors['2']
    Write-Host "  [3] Credits" -ForegroundColor $global:MenuOptionColors['3']
    Write-Host "  [4] View Current Folder Path" -ForegroundColor $global:MenuOptionColors['4']
    Write-Host "  [5] Reset Folder Path to Default" -ForegroundColor $global:MenuOptionColors['5']
    Write-Host "  [6] Customize Menu Colors" -ForegroundColor $global:MenuOptionColors['6']
    Write-Host "  [7] Exit" -ForegroundColor $global:MenuOptionColors['7']
    Write-Host "  [8] More stuff by Plutonium" -ForegroundColor $global:MenuOptionColors['8']
    Write-Host "  [9] Tool page on GameBanana" -ForegroundColor $global:MenuOptionColors['9']
    Write-Host ""
}

function Start-Cleanup {
    Clear-Host
    Write-Host "Starting cleanup..." -ForegroundColor Green
    Write-Host ""

    if (-not (Test-Path $global:CustomFolderPath)) {
        Write-Host "Error: Path does not exist: $global:CustomFolderPath" -ForegroundColor Red
        Pause-Terminal
        return
    }

    $deletedCount = 0
    Get-ChildItem -Path $global:CustomFolderPath -Recurse -Include *.cache -File | ForEach-Object {
        try {
            Remove-Item -Path $_.FullName -Force
            Write-Host "Deleted: $($_.FullName)" -ForegroundColor DarkGreen
            $deletedCount++
        } catch {
            Write-Host "Failed to delete: $($_.FullName) - $($_.Exception.Message)" -ForegroundColor Red
        }
    }

    Write-Host "`nTotal .cache files deleted: $deletedCount" -ForegroundColor Yellow
    Pause-Terminal
}

function Set-CustomPath {
    Write-Host "Current path: $global:CustomFolderPath" -ForegroundColor Yellow
    $newPath = Read-Host "Enter new path to your tf/custom folder"

    if (-not (Test-Path $newPath)) {
        Write-Host "Invalid path. Keeping the current path." -ForegroundColor Yellow
        Pause-Terminal
        return
    }

    $folderName = Split-Path $newPath -Leaf

    if ($folderName -ne "custom") {
        Write-Host "`nThis doesn't look like the correct custom folder. Proceed? (Y/N)" -ForegroundColor Red
        $confirmation = Read-Host

        if ($confirmation.ToUpper() -ne "Y") {
            Write-Host "Path not updated." -ForegroundColor Yellow
            Pause-Terminal
            return
        }
    }

    $global:CustomFolderPath = $newPath
    Write-Host "Custom folder path updated successfully." -ForegroundColor Green
    Pause-Terminal
}

function View-CurrentPath {
    Write-Host "`nCurrent custom folder path is:" -ForegroundColor Cyan
    Write-Host "$global:CustomFolderPath" -ForegroundColor Yellow
    Pause-Terminal
}

function Reset-ToDefaultPath {
    $global:CustomFolderPath = $global:DefaultFolderPath
    Write-Host "`nFolder path reset to default:" -ForegroundColor Green
    Write-Host "$global:CustomFolderPath" -ForegroundColor Yellow
    Pause-Terminal
}

function Customize-MenuColors {
    Write-Host "`nCustomize Menu Colors:" -ForegroundColor Cyan
    Write-Host "Valid Colors: Black, DarkBlue, DarkGreen, DarkCyan, DarkRed, DarkMagenta, DarkYellow," `
               + " Gray, DarkGray, Blue, Green, Cyan, Red, Magenta, Yellow, White" -ForegroundColor Gray
    Write-Host ""

    $color = Read-Host "Enter Header Color (current: $global:MenuHeaderColor)"
    if (Test-ConsoleColor $color) { $global:MenuHeaderColor = $color } else { Write-Host "Invalid color, skipping." }

    $color = Read-Host "Enter Title Color (current: $global:MenuTitleColor)"
    if (Test-ConsoleColor $color) { $global:MenuTitleColor = $color } else { Write-Host "Invalid color, skipping." }

    foreach ($key in $global:MenuOptionColors.Keys) {
        $currentColor = $global:MenuOptionColors[$key]
        $color = Read-Host "Enter color for option $key (current: $currentColor)"
        if (Test-ConsoleColor $color) {
            $global:MenuOptionColors[$key] = $color
        } else {
            Write-Host "Invalid color for option $key, skipping."
        }
    }
    Write-Host "`nMenu colors updated." -ForegroundColor Green
    Pause-Terminal
}

function Test-ConsoleColor {
    param([string]$colorName)
    $validColors = @(
        'Black', 'DarkBlue', 'DarkGreen', 'DarkCyan', 'DarkRed', 'DarkMagenta', 'DarkYellow',
        'Gray', 'DarkGray', 'Blue', 'Green', 'Cyan', 'Red', 'Magenta', 'Yellow', 'White'
    )
    return $validColors -contains $colorName
}

function Show-Credits {
    Write-Host "`nCreated by Plutonium`n" -ForegroundColor Yellow
    Pause-Terminal
}

function Check-EasterEgg {
    param($inputChar)

    $global:SecretInput += $inputChar.ToUpper()

    if ($global:SecretInput.Length -gt 9) {
        $global:SecretInput = $global:SecretInput.Substring($global:SecretInput.Length - 9)
    }

    if ($global:SecretInput -eq "PLUTONIUM") {
        Write-Host "`nYou looked at the code of my script, right? ( ͡° ͜ʖ ͡°)`n" -ForegroundColor DarkRed
        Pause-Terminal
        $global:SecretInput = ""
    }
}

function Open-Link {
    param([string]$path)
    if (Test-Path $path) {
        Start-Process $path
        Write-Host "`nLink opened!`n" -ForegroundColor Cyan
        Pause-Terminal
    } else {
        Write-Host "`nShortcut not found: $path`n" -ForegroundColor Red
        Pause-Terminal
    }
}


do {
    Show-Menu
    $choice = Read-Host "Select an option (1-9)"

    if ($choice.Length -eq 1 -and $choice -match "[a-zA-Z]") {
        Check-EasterEgg $choice
    }

    switch ($choice) {
        "1" { Start-Cleanup }
        "2" { Set-CustomPath }
        "3" { Show-Credits }
        "4" { View-CurrentPath }
        "5" { Reset-ToDefaultPath }
        "6" { Customize-MenuColors }
        "7" { break }
        "8" { Open-Link "C:\Users\small\Documents\TF2CacheRemover\msbp.url" }
        "9" { Open-Link "C:\Users\small\Documents\TF2CacheRemover\tp.url" }
        default { Write-Host "Invalid option. Try again." -ForegroundColor Yellow; Pause-Terminal }
    }
} while ($true)

Write-Host "`nExiting TF2 Cache Remover Tool. Goodbye!" -ForegroundColor Cyan
