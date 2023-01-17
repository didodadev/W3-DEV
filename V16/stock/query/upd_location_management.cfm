<cf_date tarih = 'attributes.action_date'>
<cftransaction>
	<cfquery name="add_warehouse_task" datasource="#dsn3#" result="add_r">
		UPDATE
			WAREHOUSE_TASKS_LOCATION_MANAGEMENT
		SET
			ACTION_DATE = #attributes.action_date#,		
			UPDATE_DATE = #now()#,
			UPDATE_EMP = <cfif isdefined("session.ep.userid")>#session.ep.userid#<cfelse>NULL</cfif>,
			UPDATE_IP = '#cgi.remote_addr#'
		WHERE
			MANAGEMENT_ID = #attributes.management_id#
	</cfquery>


	<cfif isdefined("attributes.product_count")>
		<cfquery name="del_" datasource="#dsn3#">
			DELETE FROM WAREHOUSE_TASKS_LOCATION_MANAGEMENT_PRODUCTS WHERE MANAGEMENT_ID = #attributes.management_id#
		</cfquery>

		<cfloop from="1" to="#attributes.product_count#" index="i">
			<cfset pid_ = evaluate("attributes.product_id_#i#")>
			<cfset is_active_ = evaluate("attributes.is_active_#i#")>
			<cfset sid_ = evaluate("attributes.stock_id_#i#")>
			<cfset pamount_ = filternum(evaluate("attributes.product_amount_#i#"))>
			<cfset from_pp_id_ = filternum(evaluate("attributes.from_pp_id_#i#"))>
			<cfset to_pp_id_ = filternum(evaluate("attributes.to_pp_id_#i#"))>
			
			<cfif is_active_ eq 1>
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
						#pid_#,
						#sid_#,
						#pamount_#,
						<cfif len(from_pp_id_)>#from_pp_id_#<cfelse>NULL</cfif>,
						<cfif len(to_pp_id_)>#to_pp_id_#<cfelse>NULL</cfif>
						)
				</cfquery>
			</cfif>
		</cfloop>
	</cfif>
</cftransaction>
<script>
	window.location.href = '<cfoutput>#request.self#?fuseaction=stock.location_management&event=upd&management_id=#attributes.management_id#</cfoutput>';
</script>
<cfabort>