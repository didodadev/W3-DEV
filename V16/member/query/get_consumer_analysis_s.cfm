<cfquery name="GET_CONSUMER_ANALYSIS_S" datasource="#DSN#">
	SELECT 
		ANALYSIS_ID,
		ANALYSIS_HEAD,
		ANALYSIS_CONSUMERS	
	FROM 
		MEMBER_ANALYSIS,
		CONSUMER
	WHERE
		<cfif isdefined("attributes.result_status") and attributes.result_status eq 1>
			IS_ACTIVE = 1 AND
		<cfelseif isdefined("attributes.result_status") and attributes.result_status eq 0>
			IS_ACTIVE = 0 AND
		<cfelseif not isdefined("attributes.result_status")>
			IS_ACTIVE = 1 AND
		</cfif>
		IS_PUBLISHED = 1 AND
		CONSUMER.CONSUMER_ID = #attributes.cid# AND
		<cfif isdefined("attributes.consumer_cat_id")>
			MEMBER_ANALYSIS.ANALYSIS_CONSUMERS LIKE '%,#attributes.consumer_cat_id#,%'
		<cfelse>
			MEMBER_ANALYSIS.ANALYSIS_CONSUMERS LIKE '%,#get_consumer.consumer_cat_id#,%'
		</cfif>
</cfquery>
