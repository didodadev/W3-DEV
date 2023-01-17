<cflock name="#CREATEUUID()#" timeout="20">
	<cftransaction>
	<cfquery name="del_store_expense_type" datasource="#dsn#">
		DELETE
		FROM
			STORE_EXPENSE_TYPE
		WHERE
			EXPENSE_TYPE_ID = #attributes.expense_type_id#
	</cfquery>
	<cf_add_log  log_type="-1" action_id="#attributes.expense_type_id#" action_name="#attributes.head#">
	</cftransaction>
</cflock>
<cflocation addtoken="no" url="#request.self#?fuseaction=settings.form_add_store_expense_type">
