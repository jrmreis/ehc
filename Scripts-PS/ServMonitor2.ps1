$servers = 'LOGRADOURO','JURU-APP01','JURU-APP02','MANAIRA','SAPE-APP01','SAPE-APP02','CARRAPATEIRA'
$u = (whoami).Split('\')[1]
$timeStamp = Get-Date -Format "dddd dd/MM/yyyy HH:mm:ss"
$T_Stamp = Get-Date -Format "yyyyMMdd_HHmmss"
$estilos = Get-Content C:\Users\$u\Documents\styles.css
$styleTag = "<style> $estilos </style>"
$tituloPagina = "Disponibilidades de servilos no Ambiente"
$tituloBody = "<h1> $tituloPagina  </h1>"
$footer = "<p>Gerado na $timeStamp</p>"
$path1 = 'C:\Users\' + $u + '\Documents\'
$filename = 'Serv_SysAppScan' + $T_Stamp + '.html'
$htmreportpath = $path1 + $filename
#$uptime = Get-CimInstance -ComputerName $_ -ClassName win32_operatingsystem | Select-Object -exp LastBootUpTime 



$servers |
     ForEach-Object {
     $a = $_
     try{test-connection -ComputerName $_ -Count 1 -ErrorAction 'stop' }
     Catch { "$a    Inacessível" }
 }
 

$servers |
     ForEach-Object{
          $b = $_

          try { Write-Host "Server $_" -fore green
          get-service *AppScan*,*WFAlertSvc*,*WFAgentSvc*,*git*, *MSSQLSERVER* -ComputerName $_ -EA SilentlyContinue }
          catch  { @{n='Machinename'; Expression={ 'down' }} }    
     } | 
#    Select-object @{n='Servidor';e={$_.Machinename }}, @{n='Nome do Serviço';e={$_.DisplayName }} , Status, @{n='UP?';e={ $_ -isnot 'System.Collections.Hashtable' }} |
#    Select-object @{n='Servidor';e={$_.Machinename }}, @{n='Nome do Serviço';e={$_.DisplayName }} , Status, @{n='UP?';e={ $Error.item(1) }} |
#    Select-object @{n='Servidor';e={$_.Machinename }}, @{n='Nome do Serviço';e={$_.DisplayName }} , Status, @{n='UP?';e={ $ }} |
#    Select-object @{n='Servidor';e={$_.Machinename }}, @{n='Nome do Serviço';e={$_.DisplayName }} , Status, @{n="ping?";e={[bool](Test-Connection -ComputerName $_.Machinename -Quiet -Count 1)}} |
     Select-object @{n='Servidor';e={$b }}, @{n='Nome do Serviço';e={$_.DisplayName }} , Status, @{n="ping?";e={if ((Test-Connection -ComputerName $b -q -Count 1) -eq 'True')  { 'Server up!' } else { 'Server down' } } } |

     

     ConvertTo-Html -Head $styleTag -Title $tituloPagina -Body $tituloBody -PostContent $footer | 
     Out-File -FilePath $htmreportpath |
     get-content -Path $htmreportpath  | out-printer $path1

$servers |
     ForEach-Object{
          $c = $_
          try { get-service *AppScan*,*WFAlertSvc*,*WFAgentSvc*,*git*, *MSSQLSERVER* -ComputerName $_ -EA SilentlyContinue }
          catch  {"$c   Host inacessível "}
     } | 
     format-table Machinename, DisplayName, Status -autosize 

$servers |
    ForEach-Object{
          get-service *AppScan*,*WFAlertSvc*,*WFAgentSvc*,*git*, *MSSQLSERVER* -ComputerName $_ -EA SilentlyContinue |
          where {$_.Status -eq 'Stopped'} | Start-Service
    }


&'C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe' @($htmreportpath)
