<cfset form.process_cat=attributes.process_type>
<cfinclude template="get_process_cat.cfm">
<cfquery name="GET_STOCK_EXCHANGE_NUMBER" datasource="#DSN2#">
	SELECT EXCHANGE_NUMBER FROM STOCK_EXCHANGE WHERE STOCK_EXCHANGE.STOCK_EXCHANGE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.exchange_id#">
</cfquery>
<cfif not GET_STOCK_EXCHANGE_NUMBER.recordcount>
	<script type="text/javascript">
		alert("<cf_get_lang_main no ='1531.Böyle Bir Kaydı Bulunamadı'>!");
		window.location.href='<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_purchase</cfoutput>';
	</script>
	<cfabort>
</cfif>

<cfquery name="GET_EXCHANGE" datasource="#DSN2#">
	SELECT 
		STOCK_EXCHANGE_ID 
	FROM 
		STOCK_EXCHANGE 
	WHERE 
		EXCHANGE_NUMBER IN (SELECT EXCHANGE_NUMBER FROM STOCK_EXCHANGE WHERE STOCK_EXCHANGE_ID=#attributes.exchange_id#)
</cfquery>
<cfset exchange_list=valuelist(GET_EXCHANGE.STOCK_EXCHANGE_ID,',')>
<cflock name="#createUUID()#" timeout="20">
	<cftransaction>
		<cfquery name="del_exchange_stock" datasource="#dsn2#">
			DELETE FROM STOCKS_ROW WHERE PROCESS_TYPE = #get_process_type.PROCESS_TYPE# AND UPD_ID IN (#exchange_list#)
		</cfquery>
		<cfquery name="del_exchange_stock" datasource="#dsn2#">
			DELETE FROM STOCK_EXCHANGE WHERE STOCK_EXCHANGE_ID IN (#exchange_list#)
		</cfquery>
        <cfquery name="del_serials" datasource="#dsn2#">
			DELETE FROM #dsn3_alias#.SERVICE_GUARANTY_NEW WHERE PROCESS_CAT = 116 AND PROCESS_ID IN (#exchange_list#)
		</cfquery>
		<cfscript>
			muhasebe_sil(action_id:attributes.acc_id, process_type:form.old_process_type);
		</cfscript>
	</cftransaction>
</cflock>
<cfif session.ep.our_company_info.is_cost eq 1>
	<cfif not isdefined('attributes.is_stock') or attributes.is_stock neq 1>
		<cfscript>cost_action(action_type:5,action_id:attributes.exchange_id,query_type:3);</cfscript>
	<cfelse>
		<cfscript>cost_action(action_type:7,action_id:attributes.exchange_id,query_type:3);</cfscript>
	</cfif>
	<script type="text/javascript">
		window.location.href="<cfoutput>#request.self#?fuseaction=#fusebox.circuit#.list_purchase</cfoutput>";
	</script>
<cfelse>
	<cflocation url="#request.self#?fuseaction=#fusebox.circuit#.list_purchase" addtoken="No">
</cfif>
