	<cfquery name="get_task" datasource="#dsn3#">
		SELECT * FROM WAREHOUSE_TASKS WHERE TASK_ID = #attributes.task_id#
	</cfquery>
	<cfquery name="get_products" datasource="#dsn3#">
		SELECT * FROM WAREHOUSE_TASKS_PRODUCTS WHERE TASK_ID = #attributes.task_id#
	</cfquery>
	<cfquery name="get_management" datasource="#dsn3#">
		SELECT * FROM WAREHOUSE_TASKS_LOCATION_MANAGEMENT WHERE TASK_ID = #attributes.task_id#
	</cfquery>
	
	<cfset attributes.company_id = get_task.company_id>
	<cfset attributes.project_id = get_task.project_id>
	<cfset attributes.employee_id = get_task.employee_id>
	<cfset attributes.action_date = createodbcdatetime(get_task.action_date)>
	
	<cfif not get_management.recordcount>
		<cftransaction>
			<cfquery name="add_warehouse_task" datasource="#dsn3#" result="add_r">
				INSERT INTO
					WAREHOUSE_TASKS_LOCATION_MANAGEMENT
					(
						IS_ACTIVE,
						TASK_ID,
						COMPANY_ID,
						PROJECT_ID,
						EMPLOYEE_ID,
						ACTION_DATE,		
						RECORD_DATE,
						RECORD_EMP,
						RECORD_IP
					)
					VALUES
					(
						1,
						#attributes.task_id#,
						<cfif len(attributes.company_id)>#attributes.company_id#<cfelse>NULL</cfif>,
						<cfif len(attributes.project_id)>#attributes.project_id#<cfelse>NULL</cfif>,
						#attributes.employee_id#,
						#attributes.action_date#,
						#now()#,
						<cfif isdefined("session.ep.userid")>#session.ep.userid#<cfelse>NULL</cfif>,
						'#cgi.remote_addr#'
					)
			</cfquery>
			<cfset attributes.management_id = add_r.identitycol>
			
			<cfquery name="upd_warehouse_task" datasource="#dsn3#">
				UPDATE
					WAREHOUSE_TASKS_LOCATION_MANAGEMENT
				SET
					MANAGEMENT_NO = MANAGEMENT_ID
				WHERE
					MANAGEMENT_ID = #attributes.management_id#
			</cfquery>

			<cfoutput query="get_products">
				<cfif len(PALLET_CODE) or not TOTAL_UNIT_TYPE is 'Pallet'>
					<cfset dongu_ = 1>
				<cfelse>
					<cfset dongu_ = ceiling(AMOUNT / PALLET_AMOUNT)>
				</cfif>
				<cfloop from="1" to="#dongu_#" index="i">
					<cfif len(PALLET_CODE) or not TOTAL_UNIT_TYPE is 'Pallet'>
						<cfset pamount_ = AMOUNT>
					<cfelse>
						<cfif i neq dongu_>
							<cfset pamount_ = PALLET_AMOUNT>
						<cfelse>
							<cfset pamount_ = AMOUNT - ((i - 1) * PALLET_AMOUNT)>
						</cfif>
					</cfif>
					<cfquery name="add_" datasource="#dsn3#">
						INSERT INTO
							WAREHOUSE_TASKS_LOCATION_MANAGEMENT_PRODUCTS
							(
							MANAGEMENT_ID,
							PRODUCT_ID,
							STOCK_ID,
							AMOUNT,
							FROM_PP_ID,
							TO_PP_ID
							)
							VALUES
							(
							#attributes.management_id#,
							#product_id#,
							#stock_id#,
							#pamount_#,
							<cfif get_task.warehouse_in_out eq 0>-1<cfelse>NULL</cfif>,
							<cfif get_task.warehouse_in_out eq 1>-2<cfelse>NULL</cfif>
							)
					</cfquery>
				</cfloop>
			</cfoutput>
		</cftransaction>
	<cfelse>
		<cfset attributes.management_id = get_management.MANAGEMENT_ID>
	</cfif>
<script>
	window.location.href = '<cfoutput>#request.self#?fuseaction=stock.location_management&event=upd&management_id=#attributes.management_id#</cfoutput>';
</script>