<cflock name="#CREATEUUID()#" timeout="20">
	<cftransaction>
<cfquery name="DEL_POTENTIAL_MEMBER" datasource="#DSN#">
	DELETE FROM COMPANY WHERE COMPANY_ID = #attributes.cpid#
</cfquery>
<cfquery name="DEL_BRANCH_RELATED" datasource="#DSN#">
	DELETE FROM COMPANY_BRANCH_RELATED WHERE COMPANY_ID = #attributes.cpid#
</cfquery>
<cfquery name="DEL_COMPANY_PARTNER" datasource="#DSN#">
	DELETE FROM COMPANY_PARTNER WHERE COMPANY_ID = #attributes.cpid#	
</cfquery>
<cfquery name="DEL_STORES_RELATED" datasource="#DSN#">
	DELETE FROM COMPANY_PARTNER_STORES_RELATED WHERE COMPANY_ID = #attributes.cpid#
</cfquery>
<cfquery name="DEL_SERVICE_INFO" datasource="#DSN#">
	DELETE FROM COMPANY_SERVICE_INFO WHERE COMPANY_ID = #attributes.cpid#
</cfquery>
<cfquery name="DEL_PARTNER_HOBBY" datasource="#DSN#">
	DELETE FROM COMPANY_PARTNER_HOBBY WHERE COMPANY_ID = #attributes.cpid#
</cfquery>
</cftransaction>
</cflock>
<cflocation url="#request.self#?fuseaction=crm.form_search_company" addtoken="no">
