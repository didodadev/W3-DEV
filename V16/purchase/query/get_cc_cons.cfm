<cfquery name="GET_CC_CONS" datasource="#dsn#">
	SELECT
		CONSUMER_ID,
		CONSUMER_NAME,
		CONSUMER_SURNAME
	FROM 
		CONSUMER
	WHERE
		CONSUMER_ID  IN  (#LISTSORT(attributes.CC_CONS,"NUMERIC")#)
</cfquery>
<cfset fullname = ''>
<cfloop query="GET_CC_CONS">
	<cfset fullname = fullname & get_cc_cons.consumer_name & ' ' & get_cc_cons.consumer_surname & ','>
</cfloop>
<cfif Len(fullname) gt 1>
<cfset fullname = Left(fullname,len(fullname) - 1)>
</cfif>
