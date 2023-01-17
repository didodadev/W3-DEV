<cfsetting showdebugoutput="no">
<cflock name="#createUUID()#" timeout="60">			
	<cftransaction>
    	<cfif isdefined('attributes.is_delete')>
			<cfquery name="DELETE_RESULT" datasource="#dsn3#">
            	DELETE PRODUCTION_OPERATION_RESULT WHERE OPERATION_RESULT_ID = #attributes.is_delete#
            </cfquery>
		<cfelseif isdefined("attributes.is_upd")><!--- Güncelleme --->
			<cfloop from="1" to="#attributes.operation_count#" index="op_ind">
				<cfif len(evaluate("attributes.realized_amount_#op_ind#")) and len(evaluate("attributes.realized_duration_#op_ind#"))>
					<cfquery name="UPD_RESULT" datasource="#dsn3#">
						UPDATE
							PRODUCTION_OPERATION_RESULT
						SET
							STATION_ID = #listfirst(evaluate("attributes.station_id_#op_ind#"),";")#,
							REAL_AMOUNT = <cfif len(evaluate("attributes.realized_amount_#op_ind#"))>#evaluate("attributes.realized_amount_#op_ind#")#<cfelse>NULL</cfif>,
							LOSS_AMOUNT = <cfif len(evaluate("attributes.fire_#op_ind#"))>#evaluate("attributes.fire_#op_ind#")#<cfelse>NULL</cfif>,
							REAL_TIME = <cfif len(evaluate("attributes.realized_duration_#op_ind#"))>#evaluate("attributes.realized_duration_#op_ind#")#<cfelse>NULL</cfif>,
							WAIT_TIME = <cfif len(evaluate("attributes.duration_time_#op_ind#"))>#evaluate("attributes.duration_time_#op_ind#")#<cfelse>NULL</cfif>,
							ACTION_EMPLOYEE_ID = <cfif len(evaluate("attributes.employee_id_#op_ind#")) and len(evaluate("attributes.employee_name_#op_ind#"))>#evaluate("attributes.employee_id_#op_ind#")#<cfelse>NULL</cfif>,
							UPDATE_EMP = #SESSION.EP.USERID#,
							UPDATE_DATE = #NOW()#,
							UPDATE_IP = '#CGI.REMOTE_ADDR#'
						WHERE
							OPERATION_RESULT_ID = #evaluate("attributes.operation_result_id_#op_ind#")#
					</cfquery>
				<cfelse>
					<cfquery name="DEL_RESULT" datasource="#dsn3#">
						DELETE FROM PRODUCTION_OPERATION_RESULT WHERE OPERATION_RESULT_ID = #evaluate("attributes.operation_result_id_#op_ind#")#
					</cfquery>
				</cfif>
			</cfloop>
		<cfelse><!--- Ekleme --->
			<cfloop from="1" to="#attributes.operation_count#" index="op_ind">
				<cfif isdefined("attributes.is_record_#op_ind#") and len(evaluate("attributes.realized_amount_#op_ind#")) and len(evaluate("attributes.realized_duration_#op_ind#"))>
					<cfquery name="ADD_RESULT" datasource="#dsn3#">
						INSERT INTO
							PRODUCTION_OPERATION_RESULT
						(
							P_ORDER_ID,
							OPERATION_ID,
							STATION_ID,
							REAL_AMOUNT,
							LOSS_AMOUNT,
							REAL_TIME,
							WAIT_TIME,
							RECORD_EMP,
							RECORD_DATE,
							RECORD_IP,
							ACTION_EMPLOYEE_ID
						)
						VALUES
						(
							#attributes.upd_id#,
							#evaluate("attributes.operation_id_#op_ind#")#,
							#listfirst(evaluate("attributes.station_id_#op_ind#"),";")#,
							<cfif len(evaluate("attributes.realized_amount_#op_ind#"))>#evaluate("attributes.realized_amount_#op_ind#")#<cfelse>NULL</cfif>,
							<cfif len(evaluate("attributes.fire_#op_ind#"))>#evaluate("attributes.fire_#op_ind#")#<cfelse>NULL</cfif>,
							<cfif len(evaluate("attributes.realized_duration_#op_ind#"))>#evaluate("attributes.realized_duration_#op_ind#")#<cfelse>NULL</cfif>,
							<cfif len(evaluate("attributes.duration_time_#op_ind#"))>#evaluate("attributes.duration_time_#op_ind#")#<cfelse>NULL</cfif>,
							#SESSION.EP.USERID#,
							#NOW()#,
							'#CGI.REMOTE_ADDR#',
							<cfif len(evaluate("attributes.employee_id_#op_ind#")) and len(evaluate("attributes.employee_name_#op_ind#"))>#evaluate("attributes.employee_id_#op_ind#")#<cfelse>NULL</cfif>
						)
					</cfquery>
				</cfif>
			</cfloop>
		</cfif>
	</cftransaction>
</cflock>
<script type="text/javascript">
	<cfif isdefined("attributes.from_prod")>
		<cfquery name="UPD_RESULT" datasource="#dsn3#">
			UPDATE
				PRODUCTION_ORDERS
			SET
				IS_STAGE = 0
			WHERE
				P_ORDER_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.p_order_id#">
		</cfquery>
		window.location.href="<cfoutput>#request.self#?fuseaction=production.order_operator&list_type=#attributes.list_type#&part=#attributes.part#</cfoutput>";
	<cfelseif not isdefined('attributes.is_delete')>
		AjaxPageLoad('<cfoutput>#request.self#?fuseaction=prod.popup_ajax_related_operation&upd=#attributes.upd_id#&stock_id=#attributes.stock_id#</cfoutput>','REL_OP',1);<!--- div_REL_OP --->
	</cfif>
</script>
