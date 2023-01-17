<cfquery name="GET_TO_CONS" datasource="#DSN#">
	SELECT	
		CONSUMER_ID,
		CONSUMER_NAME,
		CONSUMER_SURNAME,
		CONSUMER_EMAIL
	FROM 	
		CONSUMER
	WHERE
		CONSUMER_ID  IN  (#ListSort(attributes.to_cons,"NUMERIC")#)
</cfquery>
<cfset to_id = "">
<cfloop query="get_to_cons">
   <cfif len(consumer_email)>
	   <cfset to_id = '#consumer_email#,'>
   </cfif>
</cfloop>
<cfif len(to_id)>
	<cfset to_id = Left(to_id,(Len(to_id) -1))>
</cfif>
<cfset get_to_cons_fullname = "">
<cfoutput query="get_to_cons">
	<cfset get_to_cons_fullname = get_to_cons_fullname & "," & consumer_name & " " & consumer_surname>
</cfoutput>
