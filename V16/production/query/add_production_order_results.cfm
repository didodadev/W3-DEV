<cfsetting showdebugoutput="yes">
<cfif is_del eq 1>
	<cfquery name="del_operations" datasource="#dsn3#">
		DELETE FROM PRODUCTION_ORDER_OPERATIONS WHERE WRK_ROW_ID = '#attributes.wrk_row_id#'
	</cfquery>
<cfelse>
	<cfquery name="add_operations" datasource="#dsn3#" result="max_id">
		INSERT INTO
			PRODUCTION_ORDER_OPERATIONS
		(
			P_ORDER_ID,
			TYPE,
			PAUSE_TYPE,
			OPERATION_DATE,
			ASSET_ID,
			SERIAL_NO,
			AMOUNT,
			START_COUNTER,
			FINISH_COUNTER,
			RECORD_DATE,
			RECORD_EMP,
			RECORD_IP,
			WRK_ROW_ID
		)
		VALUES
		(
			#p_order_id#,
			#attributes.type#,
			<cfif isdefined("attributes.pause_type") and len(attributes.pause_type)>#attributes.pause_type#<cfelse>NULL</cfif>,
			#now()#,
			<cfif isdefined("attributes.asset_id") and len(attributes.asset_id)>#attributes.asset_id#<cfelse>NULL</cfif>,
			<cfif isdefined("attributes.serial_no") and len(attributes.serial_no)>'#attributes.serial_no#'<cfelse>NULL</cfif>,
			#attributes.amount#,
			<cfif len(attributes.start_counter)>#attributes.start_counter#<cfelse>NULL</cfif>,
			<cfif len(attributes.finish_counter)>#attributes.finish_counter#<cfelse>NULL</cfif>,
			#now()#,
			#session.ep.userid#,
			'#CGI.REMOTE_ADDR#',
			'#attributes.wrk_row_id#'
		)
	</cfquery>
     <cfif isdefined("attributes.employee") and len(attributes.employee)>
        <cfquery name="add_emps" datasource="#dsn3#">
            <cfloop list="#attributes.employee#" index="cc">
            INSERT INTO 
                PRODUCTION_ORDER_OPERATIONS_EMPLOYEE
            (
                OPERATION_ID,
                EMPLOYEE_ID
            )
            VALUES
            (
                #max_id.IDENTITYCOL#,
                #cc#
            )
            </cfloop>
        </cfquery>
    </cfif>
    <cfif isdefined("attributes.pause_type") and len(attributes.pause_type)>
        <cfquery name="upd_prod_order" datasource="#dsn3#"><!--- 1 OLUNCA ÜRETİM BAŞLAMIŞ OLUYOR! --->
            UPDATE PRODUCTION_ORDERS SET IS_STAGE = 3 WHERE P_ORDER_ID =  #p_order_id#
        </cfquery>
    <cfelse>
        <cfquery name="upd_prod_order_start" datasource="#dsn3#">
            UPDATE PRODUCTION_ORDERS SET IS_STAGE = 1 WHERE P_ORDER_ID =  #p_order_id#
        </cfquery>
    </cfif>
	<cfif len(attributes.record_num)>
		<cfloop from="1" to="#attributes.record_num#" index="i">
			<cfif isdefined("attributes.row_kontrol#no#_#i#") and evaluate("attributes.row_kontrol#no#_#i#") eq 1>
				<cfquery name="add_row_product" datasource="#dsn3#">
					INSERT INTO
						PRODUCTION_ORDER_OPERATIONS_PRODUCT
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
</cfif>

