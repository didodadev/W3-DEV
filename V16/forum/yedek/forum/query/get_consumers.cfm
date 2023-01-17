<cfquery name="CONSUMERS" datasource="#dsn#">
	SELECT
		CONSUMER_ID,
		CONSUMER_NAME,
		CONSUMER_USERNAME,
		CONSUMER_SURNAME
	FROM
		CONSUMER
	WHERE
		CONSUMER_STATUS = 1
	<cfif isDefined("attributes.CONSUMER_posS") and listlen(attributes.CONSUMER_posS)>
		AND
		CONSUMER_ID IN (#Listsort(attributes.CONSUMER_posS,'numeric')#)
	</cfif>
</cfquery>	
	
