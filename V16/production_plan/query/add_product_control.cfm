<cfif isDefined("attributes.check_ids") and len(attributes.check_ids)>
    <cfset stock_json='{'>
    <cfset counter=0>
    <cfloop list="#attributes.check_ids#" index="columns">
        <cfif counter neq 0><cfset stock_json=stock_json&','></cfif><cfset counter=counter+1>
        <cfset stock_json=stock_json&'"#listgetat(stock_id,columns)#":"1"'>
    </cfloop>
    <cfset stock_json=stock_json&'}'>
</cfif>
<cfquery name="UPD_ORDER" datasource="#dsn3#">
    UPDATE
        PRODUCTION_ORDERS
    SET
        STOCKS_JSON = <cfif isDefined("attributes.check_ids") and len(attributes.check_ids)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#stock_json#"><cfelse>NULL</cfif>
    WHERE
        P_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.p_order_id#">
</cfquery>
<script type="text/javascript">
    window.location.href="<cfoutput>#request.self#?fuseaction=production.order_operator&list_type=#attributes.list_type#&part=#attributes.part#</cfoutput>";
</script>    