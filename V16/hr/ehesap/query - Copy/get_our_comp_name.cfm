<cfquery name="get_company_name" datasource="#DSN#">
	SELECT NICK_NAME, COMPANY_NAME, T_NO, COMP_ID FROM OUR_COMPANY<cfif isdefined("attributes.COMP_ID")> WHERE COMP_ID=#attributes.COMP_ID#</cfif>
</cfquery>
