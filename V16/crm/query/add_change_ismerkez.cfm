<cfquery name="CHANGE_VALUE" datasource="#dsn#">
	UPDATE COMPANY_BRANCH_RELATED SET IS_MERKEZ = 0 WHERE RELATED_ID = #attributes.related_id#
</cfquery>
<cflocation url="#request.self#?fuseaction=crm.popup_upd_consumer_branch&cpid=139&iframe=1" addtoken="no">
