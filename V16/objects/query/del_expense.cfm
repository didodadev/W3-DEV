<cfquery name="EXPENSE" datasource="#dsn2#">
	SELECT
		EXPENSE_CODE
	FROM
		EXPENSE_CENTER
	WHERE
		EXPENSE_ID = #attributes.expense_id#
</cfquery>
<cfset attributes.EXPENSE_CODE = EXPENSE.EXPENSE_CODE>

<cfquery name="DEL_EXPENSE" datasource="#dsn2#">
	DELETE FROM
		EXPENSE_CENTER 
	WHERE
		EXPENSE_ID = #attributes.expense_id#
</cfquery>

<cfif listlen(attributes.EXPENSE_CODE,".") gt 1>
	<cfset upper_code = listdeleteat(attributes.EXPENSE_CODE,listlen(attributes.EXPENSE_CODE,"."),".")>
	<cfquery name="GET_SUBS" datasource="#dsn2#">
	SELECT
		EXPENSE_ID
	FROM
		EXPENSE_CENTER
	WHERE
		EXPENSE_CODE LIKE '#UPPER_CODE#.%'
	</cfquery>
	<cfif get_subs.recordcount eq 0>
		<cfquery name="UPD_UPPER" datasource="#dsn2#">
		UPDATE
			EXPENSE_CENTER
		SET
			HIERARCHY = 0
		WHERE
			EXPENSE_CODE = '#UPPER_CODE#'
		</cfquery>
	</cfif>
</cfif> 
<cflocation url="#request.self#?fuseaction=objects.popup_expense_center#url_string#" addtoken="No">

