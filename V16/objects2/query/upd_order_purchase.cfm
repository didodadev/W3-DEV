<cfquery name="CONTROL_ORDER_PROCESS" datasource="#DSN3#">
	SELECT IS_PROCESSED FROM ORDERS WHERE ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.order_id#">
</cfquery>
<cfif CONTROL_ORDER_PROCESS.IS_PROCESSED eq 1>
	<script type="text/javascript">
		alert("<cf_get_lang no ='1447.Bu Sipariş İşlenmiştir,Güncellenemez'>!");
		window.location.href='<cfoutput>#cgi.referer#</cfoutput>';
	</script>
	<cfabort>
</cfif>

<cfloop from="1" to="#listlen(attributes.order_row_id)#" index="i">
	<cfif evaluate("attributes.quantity_after#i#") lt evaluate("attributes.quantity#i#")>
		<script type="text/javascript">
			alert("<cf_get_lang no ='1448.Girilen Miktar Var Olan Miktardan Fazla Olamaz'>!");
			window.location.href='<cfoutput>#cgi.referer#</cfoutput>';
		</script>
		<cfabort>
	</cfif>
</cfloop>

<cfquery name="upd_order_purchase" datasource="#dsn3#">
	UPDATE 
		ORDERS 
	SET 
		ORDER_STAGE = #attributes.process_stage# 
	WHERE 
		ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.order_id#">
</cfquery>

<cfloop from="1" to="#listlen(attributes.order_row_id)#" index="i">
	<cfquery name="upd_orders_row_purchase" datasource="#dsn3#">
		UPDATE
			ORDER_ROW
		SET
			PRODUCT_NAME2 = '#wrk_eval("attributes.product_name2#i#")#',
			ORDER_ROW_CURRENCY = #evaluate("attributes.order_currency#i#")#,
			QUANTITY = #evaluate("attributes.quantity#i#")#
		WHERE
			ORDER_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Listgetat(attributes.order_row_id,i,',')#">
	</cfquery>
</cfloop>

<cfif isdefined("attributes.process_stage")>
	<cf_workcube_process is_upd='1' 
		data_source='#dsn3#' 
		old_process_line='#attributes.old_process_line#'
		process_stage='#attributes.process_stage#' 
		record_member='#session.pp.userid#'
		record_date='#now()#' 
		action_table='ORDERS'
		action_column='ORDER_ID'
		action_id='#attributes.order_id#' 
		action_page='#request.self#?fuseaction=objects2.order_detail&order_id=#attributes.order_id#'
		warning_description="#getLang('','Sipariş',57611)# : #attributes.order_id#">	
</cfif>
<cflocation url="#request.self#?fuseaction=objects2.order_detail_purchase&order_id=#attributes.order_id#" addtoken="No">
