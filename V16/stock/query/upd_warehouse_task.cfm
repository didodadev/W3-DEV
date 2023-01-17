<cf_date tarih = 'attributes.action_date'>
	<cfquery name="add_warehouse_task" datasource="#dsn3#" result="add_r">
		UPDATE
			WAREHOUSE_TASKS
		SET
			WAREHOUSE_IN_OUT = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.task_in_out#"> ,
			COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">,
			PROJECT_ID = <cfif len(attributes.project_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#"><cfelse>NULL</cfif>,
			DEPARTMENT_ID = <cfif len(attributes.department_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department_id#"><cfelse>NULL</cfif>,
			LOCATION_ID = <cfif len(attributes.location_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.location_id#"><cfelse>NULL</cfif>,
			EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">,
			TASK_STAGE = <cfif isdefined("attributes.process_stage") and len(attributes.process_stage)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_stage#"><cfelse>NULL</cfif>,
			ACTION_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date#">,
			DETAIL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.detail#">,
			<cfif isdefined("attributes.other_detail")>EXTRA_DETAIL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.other_detail#">,</cfif>
			<cfif isdefined("attributes.other_amount")>EXTRA_AMOUNT = #attributes.other_amount#,</cfif>
			<cfif isdefined("attributes.CONTAINER")>CONTAINER = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.CONTAINER#">,</cfif>
			<cfif isdefined("attributes.CARRIER_NAME")>CARRIER_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.CARRIER_NAME#">,</cfif>
			<cfif isdefined("attributes.SPECIAL_INS")>SPECIAL_INS = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.SPECIAL_INS#">,</cfif>
			FREIGHT = <cfif isdefined("attributes.FREIGHT")><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.FREIGHT#"><cfelse>NULL</cfif>,
			COUNT_TYPE = <cfif isdefined("attributes.count_type")><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.count_type#"><cfelse>NULL</cfif>,
			BL_NUMBER = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.BL_NUMBER#">,
			CARGO_SHIP_RELATED_NUMBER = <cfif isdefined("attributes.CARGO_SHIP_RELATED_NUMBER")><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.CARGO_SHIP_RELATED_NUMBER#"><cfelse>NULL</cfif>,
			CARGO_SHIP_RELATED_POSTCODE = <cfif isdefined("attributes.CARGO_SHIP_RELATED_POSTCODE")><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.CARGO_SHIP_RELATED_POSTCODE#"><cfelse>NULL</cfif>,
			CARGO_SHIP_COMPANY = <cfif isdefined("attributes.CARGO_SHIP_COMPANY")><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.CARGO_SHIP_COMPANY#"><cfelse>NULL</cfif>,
			CARGO_SHIP_NAME = <cfif isdefined("attributes.CARGO_SHIP_NAME")><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.CARGO_SHIP_NAME#"><cfelse>NULL</cfif>,
			CARGO_SHIP_ADDRESS = <cfif isdefined("attributes.CARGO_SHIP_ADDRESS")><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.CARGO_SHIP_ADDRESS#"><cfelse>NULL</cfif>,
			CARGO_SHIP_PHONE = <cfif isdefined("attributes.CARGO_SHIP_PHONE")><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.CARGO_SHIP_PHONE#"><cfelse>NULL</cfif>,
			CARGO_SHIP_POSTCODE = <cfif isdefined("attributes.CARGO_SHIP_POSTCODE")><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.CARGO_SHIP_POSTCODE#"><cfelse>NULL</cfif>,
			CARGO_SHIP_COUNTY = <cfif isdefined("attributes.CARGO_SHIP_COUNTY")><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.CARGO_SHIP_COUNTY#"><cfelse>NULL</cfif>,
			CARGO_SHIP_CITY = <cfif isdefined("attributes.CARGO_SHIP_CITY")><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.CARGO_SHIP_CITY#"><cfelse>NULL</cfif>,
			CARGO_SHIP_COUNTY_ID = <cfif isdefined("attributes.CARGO_SHIP_COUNTY_ID") and len(attributes.CARGO_SHIP_COUNTY_ID)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.CARGO_SHIP_COUNTY_ID#"><cfelse>NULL</cfif>,
			CARGO_SHIP_CITY_ID = <cfif isdefined("attributes.CARGO_SHIP_CITY_ID") and len(attributes.CARGO_SHIP_CITY_ID)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.CARGO_SHIP_CITY_ID#"><cfelse>NULL</cfif>,
			CARGO_MYCOMPANY = <cfif isdefined("attributes.CARGO_MYCOMPANY")><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.CARGO_MYCOMPANY#"><cfelse>NULL</cfif>,
			CARGO_MYNAME = <cfif isdefined("attributes.CARGO_MYNAME")><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.CARGO_MYNAME#"><cfelse>NULL</cfif>,
			CARGO_MYADDRESS = <cfif isdefined("attributes.CARGO_MYADDRESS")><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.CARGO_MYADDRESS#"><cfelse>NULL</cfif>,
			CARGO_MYPHONE = <cfif isdefined("attributes.CARGO_MYPHONE")><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.CARGO_MYPHONE#"><cfelse>NULL</cfif>,
			CARGO_MYPOSTCODE = <cfif isdefined("attributes.CARGO_MYPOSTCODE")><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.CARGO_MYPOSTCODE#"><cfelse>NULL</cfif>,
			CARGO_MYCOUNTY = <cfif isdefined("attributes.CARGO_MYCOUNTY")><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.CARGO_MYCOUNTY#"><cfelse>NULL</cfif>,
			CARGO_MYCITY = <cfif isdefined("attributes.CARGO_MYCITY")><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.CARGO_MYCITY#"><cfelse>NULL</cfif>,
			UPDATE_DATE = #now()#,
			UPDATE_EMP = <cfif isdefined("session.ep.userid")><cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"> <cfelse>NULL</cfif>,
			UPDATE_IP =	<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#"> 
		WHERE
			TASK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.task_id#">
	</cfquery>
	
	<cfquery name="upd_" datasource="#dsn3#">
		UPDATE
			WAREHOUSE_TASKS
		SET
			IS_ACTIVE = -1
		WHERE
			TASK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.task_id#"> AND
			IS_ACTIVE = -2
	</cfquery>
	
	<cfquery name="del_warehouse_task" datasource="#dsn3#" result="add_r">
		DELETE FROM WAREHOUSE_TASKS_ROWS WHERE TASK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.task_id#">
	</cfquery>
	
	<cfif isdefined("attributes.rate_code_list") and listlen(attributes.rate_code_list)>
		<cfloop from="1" to="#listlen(attributes.rate_code_list)#" index="i">
			<cfset code_ = listgetat(attributes.rate_code_list,i)>
			<cfset type_id_ = evaluate("attributes.rate_type_id_#code_#")>
			<cfset row_amount_ = evaluate("attributes.rate_row_#code_#")>
			<cfif row_amount_ gt 0>
				<cfquery name="add_" datasource="#dsn3#">
					INSERT INTO
						WAREHOUSE_TASKS_ROWS
						(
						TASK_ID,
						WAREHOUSE_TASK_TYPE_ID,
						RATE_CODE,
						ROW_AMOUNT
						)
						VALUES
						(
						<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.task_id#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#type_id_#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#code_#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#row_amount_#">
						)
				</cfquery>
			</cfif>
		</cfloop>
	</cfif>
	
	<cfif isdefined("attributes.document_count")>
		<cfquery name="del_" datasource="#dsn3#">
			DELETE FROM WAREHOUSE_TASKS_ACTIONS WHERE TASK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.task_id#">
		</cfquery>
	
		<cfloop from="1" to="#attributes.document_count#" index="i">
			<cfset no_ = evaluate("attributes.document_no_#i#")>
			<cfif len(no_)>
				<cfquery name="add_" datasource="#dsn3#">
					INSERT INTO
						WAREHOUSE_TASKS_ACTIONS
						(
						TASK_ID,
						ACTION_PERIOD_ID,
						ACTION_NO,
						ACTION_DATE
						)
						VALUES
						(
						<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.task_id#">,
						<cfif isdefined("session.ep.period_id")><cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#"><cfelse>NULL</cfif>,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#no_#">,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date#">
						)
				</cfquery>
			</cfif>
		</cfloop>
	</cfif>
	
	<cfif isdefined("attributes.product_count")>
		<cfquery name="del_" datasource="#dsn3#">
			DELETE FROM WAREHOUSE_TASKS_PRODUCTS WHERE TASK_ID =<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.task_id#">
		</cfquery>
	
		<cfloop from="1" to="#attributes.product_count#" index="i">
			<cfset pid_ = evaluate("attributes.product_id_#i#")>
			<cfset pamount_ = filternum(evaluate("attributes.product_amount_#i#"))>
			<cfset pallet_amount_ = filternum(evaluate("attributes.pallet_amount_#i#"))>
			
			<cfset row_info_ = wrk_eval("attributes.product_info_#i#")>
			
			<cfset total_unit_type_ = evaluate("attributes.total_unit_type_#i#")>
			
			<cfif isdefined("attributes.document_no_#i#")>
				<cfset doc_no_ = evaluate("attributes.document_no_#i#")>
			<cfelse>
				<cfset doc_no_ = evaluate("attributes.document_no_1")>
			</cfif>
			
			<cfif isdefined("attributes.box_style_#i#")>
				<cfset box_style_ = evaluate("attributes.box_style_#i#")>
			<cfelse>
				<cfset box_style_ = "">
			</cfif>
			
			<cfif isdefined("attributes.size_style_#i#")>
				<cfset size_style_ = evaluate("attributes.size_style_#i#")>
			<cfelse>
				<cfset size_style_ = "1">
			</cfif>
			
			<cfif isdefined("attributes.pallet_code_#i#")>
				<cfset pallet_code_ = evaluate("attributes.pallet_code_#i#")>
			<cfelse>
				<cfset pallet_code_ = "">
			</cfif>
			
			<cfif isdefined("attributes.weight_#i#")>
				<cfset weight_ = evaluate("attributes.weight_#i#")>
			<cfelse>
				<cfset weight_ = "">
			</cfif>
			
			<cfif isdefined("attributes.dimension_#i#")>
				<cfset dimension_ = evaluate("attributes.dimension_#i#")>
			<cfelse>
				<cfset dimension_ = "">
			</cfif>
			
			<cfif isdefined("attributes.box_code_#i#")>
				<cfset box_code_ = evaluate("attributes.box_code_#i#")>
			<cfelse>
				<cfset box_code_ = "">
			</cfif>
			
			<cfif len(pid_) and len(pamount_)>
				<cfquery name="add_" datasource="#dsn3#">
					INSERT INTO
						WAREHOUSE_TASKS_PRODUCTS
						(
						TASK_ID,
						PRODUCT_ID,
						STOCK_ID,
						AMOUNT,
						PALLET_AMOUNT,
						PRODUCT_INFO,
						TOTAL_UNIT_TYPE,
						BOX_STYLE,
						SIZE_STYLE,
						PALLET_CODE,
						BOX_CODE,
						WEIGHT,
						DIMENSION,
						ACTION_PERIOD_ID,
						ACTION_NO,
						ACTION_DATE
						)
						VALUES
						(
						<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.task_id#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#listfirst(pid_,'-')#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(pid_,2,'-')#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#pamount_#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#pallet_amount_#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#row_info_#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#total_unit_type_#">,
						<cfif len(box_style_)>#box_style_#<cfelse>NULL</cfif>,
						#size_style_#,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#pallet_code_#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#box_code_#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#weight_#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#dimension_#">,
						<cfif isdefined("session.ep.period_id")><cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#"><cfelse>NULL</cfif>,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#doc_no_#">,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date#">
						)
				</cfquery>
			</cfif>
		</cfloop>
	</cfif>
	
	<script>
		window.location.href = '<cfoutput>#request.self#?fuseaction=stock.list_warehouse_tasks&event=upd&task_id=#attributes.task_id#</cfoutput>';
	</script>
	<cfabort>