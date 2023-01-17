<cfset attributes.bugun = Now()>
<cfquery name="GET_TRAINING_CLASS" datasource="#DSN#">
	SELECT
		*
	FROM
		TRAINING_CLASS
	WHERE 
		CLASS_ID IS NOT NULL
		<cfif isDefined("attributes.keyword") and len(attributes.keyword)>
			AND	CLASS_NAME LIKE '%#attributes.keyword#%'
		</cfif>
		<cfif isDefined("attributes.date1") and len(attributes.date1)>
			AND
		(START_DATE >= #attributes.date1# OR
         FINISH_DATE >= #attributes.date1#)
		<cfelse>
    	AND FINISH_DATE > #attributes.bugun#
		</cfif>
</cfquery>
