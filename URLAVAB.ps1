$customerId = "9e89c852-fd84-42bb-8d43-2b843171fde8"
$sharedKey = "A8BTHbsgNjcoY1wPbU7FrN9uloQZ33ob7hp7yZS7npaG6MQ7LW2bvQPG+Njf5Y6dm8LeVcSu5/Jw/xoIJicTrw=="
$logType = "url_json"
$TimeStampField = Get-Date -format s
$URLList = "http://10.220.0.140:443/BrowserWeb/servlet/BrowserServlet" , "http://10.220.0.4:8443/BrowserWeb/servlet/BrowserServlet" , "http://10.220.0.5:8443/BrowserWeb/servlet/BrowserServlet"
$ResultList = @() 
$request = $null 
$URLListFile=   $URLList.Split(",") 
  Foreach($Uri in $URLListFile) { 
  $request = $null 
  $time = try{ 
 
   ## Request the URI, and measure how long the response took. 
  $result1 = Measure-Command { $request = Invoke-WebRequest -Uri $uri } 
  $result1.TotalMilliseconds 
  }
    catch {

      $request      = $_.Exception.Response
      $time =      -1
    }   
    
   
  $result = [PSCustomObject] @{ 
  Timestamp = $TimeStampField; 
  Uri = $uri; 
  StatusCode = [int] $request.StatusCode; 
  StatusDescription = $request.StatusDescription;
  ResponseLength = $request.RawContentLength;
   TimeTaken    = $time; 
   productName = "T24"
   ClientName = "Temenos"
   EnvName = "UAT"
   
  }
  
   $ResultList  +=$result
   $finalresult = $ResultList | ConvertTo-Json;  
} 

Write-Output $finalresult

Send-OMSAPIIngestionFile -customerId $customerId -sharedKey $SharedKey -body $finalresult -logType $LogType -TimeStampField $TimeStampField 
