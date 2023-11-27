# DetectServiceDown
Create Instana events when service goes down
This simple script will detect a service that is down (from a list that is supplied) and create an event in Instana using the agent host API. 
These events can then be used to generate alerts. By default, the event has a duration of 1 min, and is created as a "critical" event.
