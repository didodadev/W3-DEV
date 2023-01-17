<cfquery name="CONSUMERS" datasource="#DSN#">
	SELECT
		CONSUMER_ID,
		CONSUMER_NAME,
		CONSUMER_USERNAME,
		CONSUMER_SURNAME
	FROM
		CONSUMER
	WHERE
		CONSUMER_STATUS = 1
		<cfif isDefined("attributes.consumer_poss")>
			AND
				CONSUMER_ID IN (#Listsort(attributes.consumer_poss,'numeric')#)
		</cfif>
</cfquery>	
	
