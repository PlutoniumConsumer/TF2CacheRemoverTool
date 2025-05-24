
# Default path
$global:CustomFolderPath = "C:\Program Files (x86)\Steam\steamapps\common\Team Fortress 2\tf\custom"

# For Easter egg tracking
$global:SecretInput = ""

function Show-Menu {
    Clear-Host
    Write-Host "============================"
    Write-Host " TF2 Cache Remover Tool Menu"
    Write-Host "============================"
    Write-Host "1) Start"
    Write-Host "2) Set custom folder location"
    Write-Host "3) Credits"
    Write-Host ""
}

function Start-Cleanup {
    if (-not (Test-Path $global:CustomFolderPath)) {
        Write-Host "Error: Path does not exist: $global:CustomFolderPath" -ForegroundColor Red
        Pause
        return
    }

    $deletedCount = 0
    Get-ChildItem -Path $global:CustomFolderPath -Recurse -Include *.cache -File | ForEach-Object {
        try {
            Remove-Item -Path $_.FullName -Force
            Write-Host "Deleted: $($_.FullName)"
            $deletedCount++
        } catch {
            Write-Host "Failed to delete: $($_.FullName) - $($_.Exception.Message)" -ForegroundColor Red
        }
    }

    Write-Host "`nTotal .cache files deleted: $deletedCount"
    Pause
}

function Set-CustomPath {
    Write-Host "Current path: $global:CustomFolderPath"
    $newPath = Read-Host "Enter new path to your tf/custom folder"

    if (-not (Test-Path $newPath)) {
        Write-Host "Invalid path. Keeping the current path." -ForegroundColor Yellow
        Pause
        return
    }

    $folderName = Split-Path $newPath -Leaf

    if ($folderName -ne "custom") {
        Write-Host "`nHmmm, this doesn't look like the correct custom folder. Are you sure you want to proceed? (Y/N)" -ForegroundColor Green
        $confirmation = Read-Host

        if ($confirmation.ToUpper() -ne "Y") {
            Write-Host "Path not updated." -ForegroundColor Yellow
            Pause
            return
        }
    }

    $global:CustomFolderPath = $newPath
    Write-Host "Custom folder path updated successfully."
    Pause
}

function Show-Credits {
    Write-Host "`nCreated by Plutonium`n"
    Pause
}

function Check-EasterEgg {
    param($inputChar)

    $global:SecretInput += $inputChar.ToUpper()

    if ($global:SecretInput.Length -gt 9) {
        $global:SecretInput = $global:SecretInput.Substring($global:SecretInput.Length - 9)
    }

    if ($global:SecretInput -eq "PLUTONIUM") {
        Write-Host "`nYou looked at the code of my script, right? ( ͡° ͜ʖ ͡°)`n" -ForegroundColor Cyan
        Pause
        $global:SecretInput = ""  # Reset after success
    }
}

# Main loop
do {
    Show-Menu
    $choice = Read-Host "Select an option (1-3)"

    # Check for Easter egg input
    if ($choice.Length -eq 1 -and $choice -match "[a-zA-Z]") {
        Check-EasterEgg $choice
    }

    switch ($choice) {
        "1" { Start-Cleanup }
        "2" { Set-CustomPath }
        "3" { Show-Credits }
        default { Write-Host "Invalid option. Try again." -ForegroundColor Yellow; Pause }
    }
} while ($true)

