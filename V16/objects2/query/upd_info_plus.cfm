<cfscript>
	STR_VALUE="";
	for (i=1; i lte 20; i=i+1)
		if (isDefined("attributes.PROPERTY#i#") )
			STR_VALUE = STR_VALUE & "PROPERTY#i#='" & evaluate("attributes.PROPERTY#i#")& "', ";
</cfscript>

<cfif len(STR_VALUE)>
	<cfquery name="UPD_INFO" datasource="#DSN3#">
		UPDATE
			ORDER_INFO_PLUS
		SET	
			#PreserveSingleQuotes(STR_VALUE)#
			COOKIE_NAME = '#attributes.cookie_name#',
			RECORD_GUEST = 1,
			RECORD_IP = '#cgi.remote_addr#'
		WHERE
			COOKIE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.cookie_name#"> AND
			RECORD_GUEST = 1 AND
			RECORD_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
	</cfquery>
</cfif>
<cflocation url="#cgi.referer#" addtoken="no"> 
