<cfinclude template="../query/get_basket_rows.cfm">
<cfquery name="get_rows_open" dbtype="query">
	SELECT * FROM get_rows WHERE STOCK_ACTION_TYPE IS NOT NULL AND STOCK_ACTION_TYPE IN (2,3)
</cfquery>
<cflock name="#CREATEUUID()#" timeout="60">
	<cftransaction>
		<cfoutput query="get_rows_open">
			<cfquery name="add_demand" datasource="#dsn3#">
				INSERT INTO
					ORDER_DEMANDS
						(
							DEMAND_STATUS,
							STOCK_ID,
							DEMAND_TYPE,
							PRICE,
							PRICE_KDV,
							PRICE_MONEY,
							DEMAND_AMOUNT,
							GIVEN_AMOUNT,
							DEMAND_UNIT_ID,
							DOMAIN_NAME,
							STOCK_ACTION_TYPE,
							PROMOTION_ID,
							RECORD_CON,
							RECORD_PAR,
							RECORD_DATE,
							RECORD_IP				
						)
					VALUES
						(
							1,
							#STOCK_ID#,
							3,
							#PRICE#,
							#PRICE_KDV#,
							'#session_base.money#',
							#QUANTITY*PROM_STOCK_AMOUNT#,
							0,
							#PRODUCT_UNIT_ID#,
							'#cgi.http_host#',
							#STOCK_ACTION_TYPE#,
							<cfif len(prom_id)>#prom_id#<cfelse>NULL</cfif>,
							<cfif isdefined("session.ww.userid")>#session.ww.userid#,<cfelse>NULL,</cfif>
							<cfif isdefined("session.pp.userid")>#session.pp.userid#,<cfelse>NULL,</cfif>
							#now()#,
							'#cgi.remote_addr#'
						)
			</cfquery>
		</cfoutput>
		<cfquery name="del_rows" datasource="#dsn3#">
			DELETE FROM
				ORDER_PRE_ROWS
			WHERE
				<cfif isdefined("session.pp")>
					RECORD_PAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#"> AND
				<cfelseif isdefined("session.ww")>
					RECORD_CONS = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#"> AND
				<cfelseif isdefined("session.ep")>
					RECORD_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"> AND
				<cfelse>
					1 = 2
				</cfif>
				PRODUCT_ID IS NOT NULL
		</cfquery>
	</cftransaction>
</cflock>
<script type="text/javascript">
	window.location.href='<cfoutput>#request.self#?fuseaction=objects2.view_list_order<cfif not isdefined("session.ep")>&zone=1</cfif>&form_submitted=1</cfoutput>';
</script>

