# Define el directorio que deseas recorrer
$directorio = ".\*.lrc"

# Obtiene todos los archivos en el directorio
$archivos = Get-ChildItem -Path $directorio -File -Recurse

# Itera sobre cada archivo y ejecuta un comando
foreach ($archivo in $archivos) {
    # Aquí puedes definir el comando que deseas ejecutar
    Write-Output "Procesando archivo: $($archivo.FullName)"

    # Ejemplo de comando: copiar el archivo a otro directorio
    # Copy-Item -Path $archivo.FullName -Destination "C:\Ruta\Destino"

    # Otro ejemplo: ejecutar un script o programa con el archivo como argumento
    # & "C:\Ruta\Al\Programa.exe" $archivo.FullName

	$nuevaRuta = $archivo.FullName + ".utf8"
	#Write-Output "nueva ruta: $($nuevaRuta)"
	
	Get-Content $archivo.FullName | Set-Content -Encoding utf8 $nuevaRuta
	
	Remove-Item -Path $archivo.FullName -Force
	Rename-Item -Path $nuevaRuta -NewName $archivo.FullName
}

# Pausa para evitar que la ventana se cierre
Write-Host "Presiona cualquier tecla para salir..."
Read-Host