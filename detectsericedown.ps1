$hostname = [System.Net.Dns]::GetHostName()
function sendEventToInstana {
    # This function receives a servicename and creates the event through the host agent api. this is always available on port 42699 (when the agent is installed).
    param (
        [Parameter(Mandatory)]
        [string[]]$ServiceName
    )
    $sendtext = $hostname + ":" + $ServiceName
    $sendtext
    $body = '{"title":"Service Down ", "text": ' + """$sendtext""" +  ', "duration": 60000, "severity": 10}'
    [void] (Invoke-WebRequest -Uri http://localhost:42699/com.instana.plugin.generic.event -Method Post -Body $body)
    # NOTE: In order to restart the service, the script should be run with Administrator privileges. 
    # start-service -name $ServiceName
}

#for each service that should be monitoried, get the status and create an event in Instana if stopped. The Instana backend can then be configued to create an alert
get-service -name "wisvc", "wlansvc", "wpnservice", "xblauthmanager", "Wsearch" | ForEach-Object -Process {if ($_.status -eq "Stopped") {sendEventToInstana -ServiceName $_.Name}}