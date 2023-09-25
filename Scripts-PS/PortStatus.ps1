

#$servers = 'LOGRADOURO','JURU-APP01','JURU-APP02','MANAIRA','SAPE-APP01','SAPE-APP02','CARRAPATEIRA'
$servers = 10.200.6.141, 10.200.6.140, 10.200.6.139, 10.200.6.138, 10.200.6.137, 10.200.6.136

#New-CimSession -ComputerName 'LOGRADOURO' -Name 'LOG'
#Get-CimSession -Name 'LOG'

$u = (whoami).Split('\')[1]
$timeStamp = Get-Date -Format "dddd dd/MM/yyyy HH:mm:ss"
$dia = Get-Date -Format "yyyyMMdd_HHmmss"
$pathestilo = 'C:\Users\' + $u + '\Documents\styles.css'
$estilos = Get-Content $pathestilo
$styleTag = "<style> $estilos </style>"
$tituloPagina = "Status das Portas no ambiente AppScan"
$tituloBody = "<h1> $tituloPagina  </h1>"
$footer = "<p>$timeStamp</p>"
$path1 = 'C:\Users\' + $u + '\Documents\'
$filename = 'PortStatus'+ $dia +'.html'
$htmreportpath = $path1 + $filename


#$servers |
    ForEach-Object{
        
Get-NetTCPConnection  -LocalAddress 10.200.6.142 -RemoteAddress * | 
Sort-Object OwningProcess -unique } |
#C:\Windows\System32\SysinternalsSuite\PsExec.exe \\logradouro netstat -f | findstr  ESTABLISHED | findstr 10.200.6.137
#C:\Windows\System32\SysinternalsSuite\PsExec.exe @C:\Users\jreis\Desktop\teste_XMLs\AppScan.txt netstat -f | findstr  ESTABLISHED | findstr /V 127.0.0.1*
#Get-NetTCPConnection -State Established -CimSession 'LOG' |
     Select-Object LocalAddress, RemoteAddress, RemotePort, State, AppliedSetting, OwningProcess | 
     Select-Object -Property *,@{'Name' = 'ProcessName';'Expression'={(Get-Process -Id $_.OwningProcess).Name}} | 
     Select-Object -Property *,@{'Name' = 'CPU';'Expression'={(Get-Process -Id $_.OwningProcess).cpu}} | 
     Select-Object -Property *,@{'Name' = 'Handle';'Expression'={(Get-Process -Id $_.OwningProcess).handle}} | 
     Select-Object -Property *,@{'Name' = 'StartTime';'Expression'={(Get-Process -Id $_.OwningProcess).StartTime}} |

     ConvertTo-Html -Head $styleTag -Title $tituloPagina -Body $tituloBody -PostContent $footer  | 
     Out-File -FilePath $htmreportpath

&'C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe' @($htmreportpath)