<cfset stock_id_ary=''>
<cfset dtime=now()>
<cfif isdefined("attributes.stock_id")>
	<cfset MAIN_STOCK_ID=attributes.stock_id>
<cfelseif attributes.MAIN_STOCK_ID eq 0 and isdefined('attributes.HISTORY_STOCK')>
	<cfset MAIN_STOCK_ID=attributes.history_stock>
<cfelse>
    <cfset MAIN_STOCK_ID=attributes.main_stock_id>
</cfif>
<cfquery name="stock_control" datasource="#dsn3#">
	SELECT PRODUCT_TREE_ID FROM PRODUCT_TREE WHERE STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#MAIN_STOCK_ID#">
</cfquery>
<cfif stock_control.recordcount>
    <cfquery name="stock_control_history" datasource="#dsn3#">
        UPDATE 
    		PRODUCT_TREE 
        SET 
        	HISTORY_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#dtime#">,
            HISTORY_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
        WHERE
        	STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#MAIN_STOCK_ID#">
    </cfquery>
    <cf_wrk_get_history datasource="#dsn3#" source_table="PRODUCT_TREE" target_table="PRODUCT_TREE_HISTORY" record_id="#MAIN_STOCK_ID#" record_name="STOCK_ID">
</cfif>
<cfif len(stock_id_ary)>
    <cfquery name="stock_relation_history" datasource="#dsn3#">
    	UPDATE 
        	PRODUCT_TREE 
        SET 
        	HISTORY_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#dtime#">,
            HISTORY_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
        WHERE
        	PRODUCT_TREE_ID IN (#stock_id_ary#) 
    </cfquery>
    <cf_wrk_get_history datasource="#dsn3#" source_table="PRODUCT_TREE" target_table="PRODUCT_TREE_HISTORY" record_id=#stock_id_ary#  record_name="PRODUCT_TREE_ID">
</cfif>
