$packagesBasicos = 'googlechrome', 'firefox', '7zip', 'jre8', 'notepadplusplus', 'vlc', 'adobereader', 'anydesk.install', 'foxitreader', 'spotify', 'winrar', 'imgburn'
$packagesGaming = 'discord', 'steam-client', 'epicgameslauncher', 'origin', 'battle.net', 'ubisoft-connect'

Function mostrarMenu {
	Clear-Host
	Write-Host "================ Instalación automatica de programas mediante chocolatey ================" -ForegroundColor Cyan
	Write-Host "================ El script necesita ser ejecutado como administrador ================" -ForegroundColor Cyan

	Write-Host "1 - Programas básicos" -ForegroundColor White
	Write-Host "2 - Aplicaciones básicas + Gaming" -ForegroundColor White
	Write-Host "3 - Actualizar aplicaciones" -ForegroundColor White
	Write-Host "4 - SALIR" -ForegroundColor White
}

Function programasBasicos {
	checkChocolatey
	Write-Host "";
	Write-Host "======= Inicio instalación de programas básicos =======" -ForegroundColor Cyan
	ForEach ($package in $packagesBasicos){
		Write-Host "Instalando"$package"..." -ForegroundColor Cyan
		choco install $package -y
	}
	Write-Host "======= Fin instalación de programas básicos =======" -ForegroundColor Cyan
	Write-Host "";
}

Function programasGaming {
	checkChocolatey
	$packages = $packagesBasicos + $packagesGaming
	Write-Host "";
	Write-Host "======= Inicio instalación de programas básicos =======" -ForegroundColor Cyan
	ForEach ($package in $packages){
		Write-Host "Instalando"$package"..." -ForegroundColor Cyan
		choco install $package -y
	}
	Write-Host "======= Fin instalación de programas básicos =======" -ForegroundColor Cyan
	Write-Host "";
}

function actualizarChocolatey{
	checkChocolatey
	Write-Host "";
	Write-Host "======= Inicio actualización de programas =======" -ForegroundColor Cyan
	choco upgrade all
	Write-Host "======= Fin actualización de programas =======" -ForegroundColor Cyan
	Write-Host "";
}

Function checkChocolatey{
	Write-Host "";
	Write-Host "======= Inicio comprobación Chocolatey =======" -ForegroundColor Cyan
	if (Get-Command choco.exe -ErrorAction SilentlyContinue) {
		Write-Host "Chocolatey está instalado correctamente" -ForegroundColor Cyan
	}else{
		Write-Host "Se va a proceder a instalar Chocolatey" -ForegroundColor Cyan
		Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
	}
	Write-Host "======= Fin comprobación Chocolatey =======" -ForegroundColor Cyan
	Write-Host "";
}

If([Security.Principal.WindowsIdentity]::GetCurrent().Groups -contains 'S-1-5-32-544' -eq $false){
	Write-Host "Se necesitan permisos de administrator para ejecutar el script" -ForegroundColor Red
	Start-Process Powershell -ArgumentList $PSCommandPath -Verb RunAs
}Else{
	do{
		mostrarMenu

		$selection = Read-Host "Selecciona una opción:"

		switch ($selection){
			'1'{
				programasBasicos
			}
			'2'{
				programasGaming
			}
			'3'{
				actualizarChocolatey
			}
		}
		pause
	}
	until ($selection -eq '4')
}