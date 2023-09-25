# Segue abaixo o script irá listar todos os arquivos com a extensão .log no diretório desejado e gerar um arquivo html com um link para cada arquivo:

$timeStamp = Get-Date -Format "dddd dd/MM/yyyy HH:mm:ss"
$u = (whoami).Split('\')[1]
$estilos = Get-Content C:\Users\jreis\Documents\styles.css
$styleTag = "<style> $estilos </style>"
$tituloPagina = "HCL Logs"
$tituloBody = "<h1> $tituloPagina  </h1>"
$footer = "<p> $timeStamp </p>"



# Define o diretório onde o script irá buscar os arquivos:
$dir = "D:\HCL\AppScanSrcData\logs"

# Define o nome do arquivo HTML a ser gerado:
$htmlFile = "$env:userprofile\Documents\list_logs.html"

# Busca todos os arquivos com a extensão .log no diretório especificado:
$logs = Get-ChildItem -Path $dir #-Filter *log*

# Define o endereço do arquivo:
$logFullName = "$dir\$log"

# Abre o arquivo HTML para escrita:
$writer = New-Object System.IO.StreamWriter $htmlFile

# Escreve o cabeçalho do arquivo HTML:
$writer.WriteLine("$tituloBody")


# Escreve os linlks para dos arquivos encontrados:
foreach ($log in $logs) {
    $link = "file:///$dir\$log"
    $writer.WriteLine("<a href='$link'>$log</a><br>")
}

# Escreve o rodapé do arquivo HTML
$writer.WriteLine("</body>$footer</html>")


# Fecha o arquivo HTML
$writer.Close()

Invoke-Expression C:\Users\jreis\Documents\list_logs.html


