<cfquery name="GET_CONSUMER_DETAIL" datasource="#dsn#">
	SELECT
		*
	FROM
		CONSUMER,
		CONSUMER_CAT
	WHERE
		<cfif isdefined("attributes.consumer_id") and len(attributes.consumer_id)>
			CONSUMER.CONSUMER_ID = #attributes.CONSUMER_ID# AND
		</cfif>
		<cfif isdefined("consumer_id_list") and len(consumer_id_list)>
			CONSUMER.CONSUMER_ID IN (#consumer_id_list#) AND
		</cfif>
		CONSUMER.CONSUMER_CAT_ID=CONSUMER_CAT.CONSCAT_ID 
</cfquery>


