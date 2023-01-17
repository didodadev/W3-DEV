<cfif len(attributes.action_date)><cf_date tarih='attributes.action_date'></cfif>
<cflock name="#CreateUUID()#" timeout="30">
<cftransaction>
	<cfquery name="del_prod_pause" datasource="#dsn3#">
		DELETE FROM SETUP_PROD_PAUSE WHERE PR_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pr_order_id#">
	</cfquery>
	<cfloop from="1" to="#attributes.record_num#" index="i">
		<cfif isdefined("attributes.row_kontrol#i#") and evaluate("attributes.row_kontrol#i#") eq 1>
			<cfquery name="add_prod_pause" datasource="#dsn3#">
				INSERT INTO 
					SETUP_PROD_PAUSE
				(  
					PROD_PAUSE_TYPE_ID,
					PROD_DURATION,
					PROD_DETAIL,
					IS_WORKING_TIME,
					PR_ORDER_ID,
					RECORD_DATE,
					RECORD_IP,
					RECORD_EMP,
					ACTION_DATE				
				)				
				VALUES     
				(
					<cfif len(evaluate("attributes.prod_pause_type_id#i#"))><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.prod_pause_type_id#i#')#"><cfelse>NULL</cfif>,
					<cfif len(evaluate("attributes.duration#i#"))><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.duration#i#')#"><cfelse>NULL</cfif>,
					<cfif len(evaluate("attributes.detail#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.detail#i#')#"><cfelse>NULL</cfif>,
					<cfif len(evaluate("attributes.is_time#i#"))><cfqueryparam cfsqltype="cf_sql_smallint" value="#evaluate('attributes.is_time#i#')#"><cfelse>NULL</cfif>,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pr_order_id#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date#">			 
				)
			</cfquery>
		</cfif>
	</cfloop>
</cftransaction>
</cflock>
<script type="text/javascript">
		window.location.href ="<cfoutput>#request.self#?fuseaction=prod.list_results&event=upd&product_cat_list=#product_cat_list#&p_order_id=#attributes.p_order_id#&pr_order_id=#attributes.pr_order_id#</cfoutput>";
</script>
