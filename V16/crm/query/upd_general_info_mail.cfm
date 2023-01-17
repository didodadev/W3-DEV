<cfquery name="ADD_COMPANY" datasource="#DSN#">
	UPDATE
		COMPANY
	SET
		COMPANY_EMAIL = '#attributes.email#',
		EKSTRE = <cfif isdefined("attributes.ekstre")>1<cfelse>0</cfif>
	WHERE
		COMPANY_ID = #attributes.cpid#
</cfquery>
<script type="text/javascript">
	alert("<cf_get_lang no ='1014.Mail Adresi Güncellendi'>");
	window.location.href='<cfoutput>#request.self#?fuseaction=crm.popup_general_info&cpid=#attributes.cpid#&iframe=1</cfoutput>';
</script>

