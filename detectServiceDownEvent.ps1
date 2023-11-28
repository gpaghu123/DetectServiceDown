# this script requires Admin rights to register the event watcher
$serviceArray = @("wisvc", "wlansvc", "wpnservice", "xblauthmanager", "Wsearch")
$FilterQuery="Select * from __InstanceModificationEvent within 5 where TargetInstance ISA 'Win32_Service'"

$sendToInstana = {
	$ev =  $event.sourceEventArgs.newevent.targetinstance
	if (($ev.started -ne $true) -and ($ev.name -in $serviceArray))
	{
			$sendtext = $ev.SystemName + ":" + $ev.Name + ":" + $ev.DisplayName
			$body = '{"title":"Service Down ", "text": ' + """$sendtext""" +  ', "duration": 60000, "severity": 10}'
			[void] (Invoke-WebRequest -Uri http://localhost:42699/com.instana.plugin.generic.event -Method Post -Body $body)
			#Start-Service -Name $ev.Name
	}
  }

Register-CimIndicationEvent -Namespace 'ROOT\CIMv2' -Query $filterquery -SourceIdentifier 'WindowsServices' -MessageData 'Service Status Change' -Action $sendToInstana