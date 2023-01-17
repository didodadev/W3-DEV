<cfquery name="GET_IMCAT" datasource="#dsn#">
	SELECT * FROM SETUP_IM  <cfif isdefined("attributes.IMCAT_ID") and len(attributes.IMCAT_ID)>WHERE IMCAT_ID=#attributes.IMCAT_ID#</cfif>
</cfquery>
