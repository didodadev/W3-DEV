<cfquery name="DELCOMPANYCAT" datasource="#dsn#">
	DELETE FROM COMPANY_CAT	WHERE COMPANYCAT_ID=#COMPANYCAT_ID#
</cfquery>
<cfquery name="DELCOMPANYCAT_OUR" datasource="#dsn#">
	DELETE FROM COMPANY_CAT_OUR_COMPANY	WHERE COMPANYCAT_ID = #COMPANYCAT_ID#
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_company_cat" addtoken="no">
