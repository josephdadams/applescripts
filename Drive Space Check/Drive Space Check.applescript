global webhookurl
global computername

set webhookurl to "#####" --slack webhook here
set computername to "Control Room 2 Video Server"

spaceCheck("/Volumes/FG Tech Recordings", 40)
spaceCheck("/", 35)

on spaceCheck(volume, threshold)
	--get the amount of free space
	set dSize to (do shell script "df -h '" & volume & "' | grep %") as text
	
	--pull out the percent used from the result
	set theCapacity to word 16 in dSize as number
	
	--get the percent remaining
	set theRemaining to 100 - theCapacity
	
	--build the request command
	set jsonString to "{\"text\":\"" & computername & " - Free Space Remaining on " & volume & ": " & theRemaining & "%\"}"
	set curl_command to "curl -X POST -H 'Content-type: application/json' --data '" & jsonString & "' " & webhookurl
	
	--if the space remaining is 35% or less, send out an alert
	if theRemaining is less than or equal to threshold then
		do shell script curl_command
	end if
end spaceCheck