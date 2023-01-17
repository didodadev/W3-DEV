<cfquery name="get_expense_requests" datasource="#dsn2#">
	SELECT * FROM EXPENSE_ITEM_PLAN_REQUESTS WHERE EXPENSE_ID = #attributes.request_id#
</cfquery>
<cfif not get_expense_requests.recordcount>
	<script type="text/javascript">
		alert("<cf_get_lang_main no ='1531.Böyle Bir Kayıt Bulunamamaktadır'> !");
		window.location.href='<cfoutput>#request.self#?fuseaction=cost.list_expense_requests</cfoutput>';
	</script>
	<cfabort>
</cfif>
<cfquery name="get_expense_requests_row" datasource="#dsn2#">
	SELECT * FROM EXPENSE_ITEM_PLAN_REQUESTS_ROWS WHERE EXPENSE_ID = #attributes.request_id#
</cfquery>
<cflock name="#CREATEUUID()#" timeout="20">
	<cftransaction>
    <cf_wrk_get_history datasource="#dsn2#" source_table="EXPENSE_ITEM_PLAN_REQUESTS" target_table="EXPENSE_ITEM_PLAN_REQUESTS_HISTORY" record_id= "#attributes.request_id#" record_name="EXPENSE_ID">
    <cfquery name="get_max_hist_id" datasource="#dsn2#">
    	SELECT MAX(EXPENSE_HISTORY_ID) MAX_ID FROM EXPENSE_ITEM_PLAN_REQUESTS_HISTORY
    </cfquery>
    <cf_wrk_get_history datasource="#dsn2#" source_table="EXPENSE_ITEM_PLAN_REQUESTS_ROWS" target_table="EXPENSE_ITEM_PLAN_REQUESTS_ROW_HISTORY"  record_id= "#valuelist(get_expense_requests_row.EXP_ITEM_ROWS_ID)#" record_name="EXP_ITEM_ROWS_ID">
	</cftransaction>
</cflock>
