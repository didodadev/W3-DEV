<!--- Harcama talebi silme sayfası --->
<cfquery name="get_paper_no" datasource="#dsn2#">
	SELECT PAPER_NO FROM EXPENSE_ITEM_PLAN_REQUESTS WHERE EXPENSE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.request_id#">
</cfquery>
<cflock name="#createUUID()#" timeout="20">
    <cftransaction>
        <cfquery name="del_expense_plan" datasource="#dsn2#">
            DELETE FROM EXPENSE_ITEM_PLAN_REQUESTS WHERE EXPENSE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.request_id#">
        </cfquery>
        <cfquery name="del_expense_plan_row" datasource="#dsn2#">
            DELETE FROM EXPENSE_ITEM_PLAN_REQUESTS_ROWS WHERE EXPENSE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.request_id#">
        </cfquery>
        <cfquery name="del_expense_plan_money" datasource="#dsn2#">
            DELETE FROM EXPENSE_ITEM_PLAN_REQUESTS_MONEY WHERE ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.request_id#">
        </cfquery>	
        <cf_add_log log_type="-1" action_id="#attributes.request_id#" action_name="#get_paper_no.paper_no#" paper_no="#get_paper_no.paper_no#" data_source="#dsn2#">
    </cftransaction>
</cflock>
<cfif isdefined("attributes.cost_type") and attributes.cost_type eq 1>
    <script type="text/javascript">
    	window.location.href = "<cfoutput>#request.self#?fuseaction=myhome.list_my_expense_requests</cfoutput>";
    </script>
<cfelseif isdefined("attributes.allowance_expense") and attributes.allowance_expense eq 1>
    <cfset allowance_expense_cmp = createObject("component","V16.myhome.cfc.allowance_expense") /><!--- Ek Ödenek--->
    <cfset delete_salaryparam = allowance_expense_cmp.DELETE_SALARYPARAM_PAY(expense_puantaj_id : attributes.request_id)><!--- Daha önce harcırahıı oluştuluşmuşsa siler--->
    <script type="text/javascript">
    	window.location.href = "<cfoutput>#request.self#?fuseaction=hr.allowance_expense</cfoutput>";
    </script>
<cfelse>   
	<script type="text/javascript">
    	window.location.href = "<cfoutput>#request.self#?fuseaction=cost.list_expense_requests</cfoutput>";
    </script>
</cfif>
