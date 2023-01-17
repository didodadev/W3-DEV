<cfquery name="GET_CARIS" datasource="#dsn2#">
	SELECT 
		*		
	FROM
		CARI_ROWS
	WHERE
		CARI_ACTION_ID IS NOT NULL
		<cfif isdefined("attributes.card_type") and len(attributes.card_type)>
		AND IS_ACCOUNT_TYPE = #ATTRIBUTES.CARD_TYPE#
		</cfif>
		<cfif  ListFind("2,3,4",attributes.process_type) and len(attributes.process_type)>
			AND ACTION_TYPE_ID IN (#process_list#)
		<cfelseif len(process_list)>
			AND 1=0
		</cfif>
		AND IS_ACCOUNT=0
		<cfif isdefined("attributes.date1") and isDefined("attributes.date2") and len(attributes.date2) and  len(attributes.date1)>
		AND ACTION_DATE <= #ATTRIBUTES.DATE2#
		AND ACTION_DATE >= #ATTRIBUTES.DATE1#
		</cfif>
		AND ACTION_TYPE_ID  NOT IN (41,42)
	ORDER BY 
		ACTION_DATE		
</cfquery>
