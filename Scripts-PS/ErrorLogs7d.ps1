$servers = 'LOGRADOURO','JURU-APP01','JURU-APP02','MANAIRA','SAPE-APP01','SAPE-APP02','CARRAPATEIRA'
$u = (whoami).Split('\')[1]
$timeStamp = Get-Date -Format "dddd dd/MM/yyyy HH:mm:ss"
$diasAtras = 5
$estilos = Get-Content C:\Users\hcl_app_scan\Documents\styles.css
$styleTag = "<style> $estilos </style>"
$tituloPagina = "Últimos erros de cada Máquina do AppScan, nos últimos $diasAtras dias"
$tituloBody = "<h1> $tituloPagina  </h1>"
$begin = (Get-Date).AddDays(-$diasAtras) | Get-Date -Format "dddd dd/MM/yyyy HH:mm:ss"
$footer = "<p>desde $begin <br> até $timeStamp  </p>"
$path1 = 'C:\Users\' + $u + '\Documents\'
$filename = 'LogsSysAppScan'+ $diasAtras +'d.html'
$htmreportpath = $path1 + $filename


$servers |
     ForEach-Object{  
          Write-Host " Server $_" -fore green | 
          Get-EventLog -LogName System -After $begin -EntryType Error -Newest 5 -ComputerName $_ | %{ Write-Host  ">" -fore green -NoNewline; $_ }
     } |
     
     Select-object TimeGenerated, MachineName, UserName, Source, EntryType, Message | ConvertTo-Html -Head $styleTag -Title $tituloPagina -Body $tituloBody -PostContent $footer  | Out-File -FilePath $htmreportpath

&'C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe' @($htmreportpath)