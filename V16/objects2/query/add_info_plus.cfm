<cfscript>
STR_COLUMN="";
STR_VALUE="";

for (i=1; i lte 20; i=i+1)
	if (isDefined("attributes.PROPERTY#i#"))
		{
			STR_COLUMN = STR_COLUMN & " PROPERTY#i#,";
			STR_VALUE = STR_VALUE & "'"& evaluate("attributes.PROPERTY#i#")& "',";
		}
</cfscript>

<cfif len(STR_VALUE)>
	<cfquery name="ADD_INFO" datasource="#DSN3#">
		INSERT INTO 
			ORDER_INFO_PLUS
			(
				#PreserveSingleQuotes(STR_COLUMN)#
				COOKIE_NAME,
				RECORD_GUEST,
				RECORD_IP
			)
				VALUES
			(
				#PreserveSingleQuotes(STR_VALUE)#	
				'#attributes.COOKIE_NAME#',
				1,
				'#cgi.remote_addr#'
			)
	</cfquery>
</cfif>
<cflocation url="#cgi.referer#" addtoken="no">
