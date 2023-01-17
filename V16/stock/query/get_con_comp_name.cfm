<cffunction  name="get_name">
	<cfargument name="get_id">
	<cfargument name="get_type">
	<cfif get_type eq 1 >
	<cfquery datasource="#DSN#" name="GET_NAME_OF"> 
		SELECT
			NICKNAME
		FROM
			COMPANY
		WHERE
			COMPANY_ID=#get_id#	
	</cfquery>
	<cfreturn GET_NAME_OF.NICKNAME>
	<cfelse>
	<cfquery datasource="#dsn#" name="get_name_of"> 
		SELECT
			CONSUMER_NAME NAME,
			CONSUMER_SURNAME SNAME
		FROM
			CONSUMER
		WHERE
			CONSUMER_ID=#get_id#
</cfquery>
<cfset name=GET_NAME_OF.NAME & " " & GET_NAME_OF.SNAME>
<cfreturn name>
</cfif>
</cffunction>
