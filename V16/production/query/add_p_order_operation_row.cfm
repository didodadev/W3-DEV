<!--- Üretim emri operasyon counter sayfası --->
<cfsetting showdebugoutput="no">
<cfif is_del eq 1>
	<cfquery name="del_operations" datasource="#dsn3#">
		DELETE FROM P_ORDER_OPERATIONS_ROW WHERE WRK_ROW_ID = '#attributes.wrk_row_id#'
	</cfquery>
	<cfquery name="del_row_product" datasource="#dsn3#">
		DELETE FROM P_ORDER_OPERATIONS_ROW_PRODUCT WHERE WRK_ROW_ID = '#attributes.wrk_row_id#'
	</cfquery>
<cfelse>
	<cfquery name="add_operations" datasource="#dsn3#">
		INSERT INTO
			P_ORDER_OPERATIONS_ROW
		(
			P_ORDER_ID,
			TYPE,
			PAUSE_TYPE,
			EMPLOYEE_ID,
			ASSET_ID,
			OPERATION_TYPE_ID,
			P_OPERATION_ID,
			QUANTITY,
			OPERATION_DATE,
			START_COUNTER,
			FINISH_COUNTER,
			RECORD_DATE,
			RECORD_EMP,
			RECORD_IP,
			WRK_ROW_ID,
			WRK_ROW_RELATION_ID
		)
		VALUES
		(
			#p_order_id#,
			#attributes.type#,
			<cfif isdefined("attributes.pause_type") and len(attributes.pause_type)>#attributes.pause_type#<cfelse>NULL</cfif>,
			#attributes.employee#,
			<cfif isdefined("attributes.asset_id") and len(attributes.asset_id)>#attributes.asset_id#<cfelse>NULL</cfif>,
			#listgetat(attributes.operation,1,'-')#,
			#listgetat(attributes.operation,2,'-')#,
			#attributes.amount#,
			#now()#,
			<cfif len(attributes.start_counter)>#attributes.start_counter#<cfelse>NULL</cfif>,
			<cfif len(attributes.finish_counter)>#attributes.finish_counter#<cfelse>NULL</cfif>,
			#now()#,
			#session.ep.userid#,
			'#CGI.REMOTE_ADDR#',
			'#attributes.wrk_row_id#',
			'#attributes.wrk_row_relation_id#'
		)
	</cfquery>
	<cfif len(attributes.record_num)>
		<cfloop from="1" to="#attributes.record_num#" index="i">
			<cfif isdefined("attributes.row_kontrol#no#_#i#") and evaluate("attributes.row_kontrol#no#_#i#") eq 1>
				<cfquery name="add_row_product" datasource="#dsn3#">
					INSERT INTO
						P_ORDER_OPERATIONS_ROW_PRODUCT
					(
						WRK_ROW_ID,
						P_ORDER_ID,
						PRODUCT_ID,
						STOCK_ID,
						PRODUCT_NAME,
						AMOUNT,
						RECORD_DATE,
						RECORD_EMP,
						RECORD_IP
					)
					VALUES
					(
						'#attributes.wrk_row_id#',
						#p_order_id#,
						#evaluate('attributes.product_id#no#_#i#')#,
						#evaluate('attributes.stock_id#no#_#i#')#,
						'#evaluate('attributes.product_name#no#_#i#')#',
						#evaluate('attributes.amount#no#_#i#')#,
						#now()#,
						#session.ep.userid#,
						'#CGI.REMOTE_ADDR#'
					)
				</cfquery>
			</cfif>
		</cfloop>
	</cfif>
	<cfif attributes.type eq 0>
		<script type="text/javascript">
			window.close();
		</script>
	</cfif>
	<cfif attributes.type eq 2>
		<script type="text/javascript">
			no = "<cfoutput>#attributes.no#</cfoutput>";
			document.getElementById('op_finish'+no+'').value = 'OPERASYON SONLANDIRILDI';
			alert("Operasyon Sonuçlandırıldı!");
		</script>
	</cfif>
</cfif>

