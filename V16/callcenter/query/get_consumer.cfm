<!--- get_consumer.cfm --->
<cfquery name="GET_CONSUMER" datasource="#dsn#">
	SELECT 
		* 
	FROM 
		CONSUMER
	WHERE 
		CONSUMER_ID = #URL.CID#
<!--- AND CONSUMER_STATUS = 1 ---> 
</cfquery>

