
$u = (whoami).Split('\')[1]
$timeStamp = Get-Date -Format "dddd dd/MM/yyyy HH:mm:ss"
$dia = Get-Date -Format "yyyyMMdd_HHmmss"
$estilos = Get-Content C:\Users\hcl_app_scan\Documents\styles.css
$styleTag = "<style> $estilos </style>"
$tituloPagina = "Status das Portas no ambiente AppScan"
$tituloBody = "<h1> $tituloPagina  </h1>"
$footer = "<p>$timeStamp</p>"
$path1 = 'C:\Users\' + $u + '\Documents\'
$filename = 'PortStatus'+ $dia +'.html'
$htmreportpath = $path1 + $filename


#$data = netstat -n
#$data.count
#$data[3]
#$data[4..$data.count]

FOREACH ($line in $data)
{
    
    # Remove the whitespace at the beginning on the line
    $line = $line -replace '^\s+', ''
    
    # Split on whitespaces characteres
    $line = $line -split '\s+'
    
    # Define Properties
    $properties = @{
        Protocol = $line[0]
        LocalAddress = $line[1]
        ForeignAddress = $line[2]
        State = $line[3]
    }
    
    # Output object
    New-Object -TypeName PSObject -Property $properties


} 

$properties | ConvertTo-Html -Head $styleTag -Title $tituloPagina -Body $tituloBody -PostContent $footer  | Out-File -FilePath $htmreportpath

&'C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe' @($htmreportpath)
