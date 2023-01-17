<cfquery name="GET_CC_CONS" datasource="#DSN#">
	SELECT
		CONSUMER_ID,
		CONSUMER_NAME,
		CONSUMER_SURNAME,
		CONSUMER_EMAIL
	FROM 
		CONSUMER
	WHERE
		CONSUMER_ID IN(#ListSort(attributes.cc_cons,"NUMERIC")#)
</cfquery>
<cfset cc_id = "">
<cfloop query="get_cc_cons">
   <cfif len(consumer_email)>
	   <cfset cc_id = '#consumer_email#,'>
   </cfif>
</cfloop>
<cfif len(cc_id)>
	<cfset cc_id = Left(cc_id,(Len(cc_id) -1))>
</cfif>
<cfset get_cc_cons_fullname = "">
<cfoutput query="get_cc_cons">
   	<cfset get_cc_cons_fullname = get_cc_cons_fullname & "," & consumer_name & " " & consumer_surname>
</cfoutput>	
