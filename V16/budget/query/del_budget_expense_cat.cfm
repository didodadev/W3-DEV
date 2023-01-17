<cflock name="#CreateUUID()#" timeout="60">
	<cftransaction>
		<cfquery name="del_expense_category" datasource="#dsn2#">
			DELETE FROM
				EXPENSE_CATEGORY
			WHERE
				EXPENSE_CAT_ID = #attributes.cat_id#
		</cfquery>
	</cftransaction>
</cflock>
<script type="text/javascript">
	window.location.href="<cfoutput>#request.self#</cfoutput>?fuseaction=budget.list_expense_cat";
</script>
