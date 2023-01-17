<cfquery name="CHANGE_VALUE" datasource="#DSN#">
	UPDATE COMPANY_BRANCH_RELATED SET IS_CONTRACT_REQUIRED = #attributes.is_contract_required# WHERE RELATED_ID = #attributes.related_id#
</cfquery>
<cflocation url="#request.self#?fuseaction=crm.popup_upd_consumer_branch&cpid=#attributes.cpid#&iframe=1" addtoken="no">
