<cfquery name="GET_TO_CONS" datasource="#dsn#">
	SELECT
		CONSUMER_ID,
		CONSUMER_NAME,
		CONSUMER_SURNAME
	FROM 
		CONSUMER
	WHERE
		CONSUMER_ID  IN  (#LISTSORT(attributes.TO_CONS,"NUMERIC")#)
</cfquery>
<cfset fullname = ''>
<cfloop query="get_to_cons">
	<cfset fullname = fullname & get_to_cons.consumer_name & ' ' & get_to_cons.consumer_surname & ','>
</cfloop>
<cfif Len(fullname) gt 1>
<cfset fullname = Left(fullname,len(fullname) - 1)>
</cfif>
