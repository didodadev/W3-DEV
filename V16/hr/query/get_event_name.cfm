
<cfquery name="GET_EVENT_NAME" datasource="#dsn#">
SELECT EVENT_HEAD,EVENT_ID 
FROM 
	EVENT 
WHERE 
	EVENT_ID= #GET_TIME_COST.EVENT_ID#
</cfquery>
