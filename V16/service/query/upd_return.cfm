<cflock name="#CreateUUID()#" timeout="30">
	<cftransaction>
		<cfquery name="UPD_RETURN" datasource="#DSN3#">
			UPDATE
				SERVICE_PROD_RETURN
			SET
				RETURN_TYPE = <cfif isdefined("attributes.return_type") and len(attributes.return_type)>#attributes.return_type#<cfelse>NULL</cfif>,
				UPDATE_DATE = #now()#,
				UPDATE_IP = '#cgi.remote_addr#',
				UPDATE_EMP = #session.ep.userid#
			WHERE
				RETURN_ID = #attributes.return_id#
		</cfquery>
		<cfif len(attributes.is_check)>
			<cfloop list="#attributes.is_check#" index="ccc">
				<cfquery name="UPD_STAGE" datasource="#DSN3#">
					UPDATE
						SERVICE_PROD_RETURN_ROWS
					SET
					<cfif attributes.is_process_row eq 1>
						RETURN_STAGE = #evaluate("attributes.row_stage_#ccc#")#,
					<cfelse>	
						RETURN_STAGE = #attributes.process_stage#,
					</cfif>
						RETURN_CANCEL_TYPE = <cfif isdefined("attributes.row_cancel_type_#ccc#") and len(evaluate("attributes.row_cancel_type_#ccc#"))>#evaluate("attributes.row_cancel_type_#ccc#")#<cfelse>NULL</cfif>,
						DETAIL = '#wrk_eval("attributes.detail_#ccc#")#',
						AMOUNT = #filterNum(evaluate("attributes.amount_#ccc#"))#
					<cfif isdefined("attributes.package_#ccc#")>
						,PACKAGE = #evaluate("attributes.package_#ccc#")#
					</cfif>
					WHERE
						RETURN_ROW_ID = #ccc#
				</cfquery>
				<!--- Degisim ve xml de takip eklensin secili ise uyeye ait takip kaydi guncelleniyor --->
				<cfif isdefined("attributes.return_act_type_#ccc#") and len(evaluate('attributes.return_act_type_#ccc#')) and evaluate('attributes.return_act_type_#ccc#') eq 2 and attributes.is_order_demand eq 1>
					<cfquery name="UPD_STOCK_STRATEGY" datasource="#DSN3#">
						UPDATE
							ORDER_DEMANDS
						SET
							DEMAND_AMOUNT = #evaluate('attributes.amount_#ccc#')#
						WHERE
							RETURN_ROW_ID = #attributes.return_id#							
					</cfquery>
				<cfelseif isdefined("attributes.return_act_type_#ccc#") and len(evaluate('attributes.return_act_type_#ccc#')) and evaluate('attributes.return_act_type_#ccc#') eq 3><!--- fazla ürün ise stoğun bloke stok miktarı 1 arttırılır--->
					<cfquery name="UPD_STOCK_STRATEGY" datasource="#DSN3#">
						UPDATE
							STOCK_STRATEGY
						SET
							BLOCK_STOCK_VALUE = ISNULL(BLOCK_STOCK_VALUE,0) - ISNULL(RETURN_BLOCK_VALUE,0) + #evaluate('attributes.amount_#ccc#')#,
							RETURN_BLOCK_VALUE = #evaluate('attributes.amount_#ccc#')#
						WHERE
							STOCK_ID = #evaluate('attributes.stock_id_#ccc#')# AND
							STRATEGY_TYPE = 0
					</cfquery>
				</cfif>
			</cfloop>
			<cfif attributes.is_process_row eq 0>
				<cf_workcube_process 
					is_upd='1'
					data_source='#dsn3#' 
					old_process_line='#attributes.process_stage#'
					process_stage='#attributes.process_stage#' 
					record_member='#session.ep.userid#'
					record_date='#now()#' 
					action_table='SERVICE_PROD_RETURN'
					action_column='RETURN_ID'
					action_id='#attributes.return_id#' 
					action_page='#request.self#?fuseaction=service.product_return&event=upd&return_id=#attributes.return_id#' 
					warning_description='İade No : #attributes.return_id#'>
			<cfelse>
				<cfloop list="#attributes.is_check#" index="ccc">
					<cf_workcube_process 
						is_upd='1'
						data_source='#dsn3#' 
						old_process_line='#evaluate("attributes.row_stage_#ccc#")#'
						process_stage='#evaluate("attributes.row_stage_#ccc#")#' 
						record_member='#session.ep.userid#'
						record_date='#now()#' 
						action_table='SERVICE_PROD_RETURN_ROWS'
						action_column='RETURN_ROW_ID'
						action_id='#ccc#' 
						action_page='#request.self#?fuseaction=service.product_return&event=upd&return_id=#attributes.return_id#' 
						warning_description='İade Satır No : #ccc#'>
				</cfloop>
			</cfif>
		</cfif>
	</cftransaction>
</cflock>
<cfset attributes.actionId = attributes.return_id>
<script type="text/javascript">
	window.location.href = '<cfoutput>#request.self#</cfoutput>?fuseaction=service.product_return&event=upd&return_id=<cfoutput>#attributes.return_id#</cfoutput>';
</script>
<script type="text/javascript">
	window.location.href ="<cfoutput>#request.self#?fuseaction=service.product_return&event=upd&return_id=#attributes.return_id#</cfoutput>";
</script>
