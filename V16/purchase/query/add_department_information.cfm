<cfif not isdefined("new_dsn3_group_pur")><cfset new_dsn3_group_pur = dsn3></cfif>
<cfif ACTION_TYPE_ID eq 1>
	<!--- offer --->
	<cfset tablo_adi = "OFFER_ROW_DEPARTMENTS">
	<cfset alan_adi = "OFFER_ROW_ID">
<cfelseif  ACTION_TYPE_ID eq 2>
	<cfset tablo_adi = "ORDER_ROW_DEPARTMENTS">
	<cfset alan_adi = "ORDER_ROW_ID">
</cfif>
<cfquery name="del_row_" datasource="#new_dsn3_group_pur#">
	DELETE FROM #tablo_adi# WHERE #alan_adi# = #attributes.ROW_MAIN_ID#
</cfquery>
<cfif isdefined("attributes.department_#i#_count") and evaluate("attributes.department_#i#_count") gt 1 and len(evaluate("attributes.department_#i#_count"))>
	<cfloop from="1" to="#evaluate('attributes.department_#i#_count')#" index="dep_counter">
		<cfset int_rowdepartment = Evaluate("attributes.department_#i#_#dep_counter#_2")>
		<cfset int_rowlocation = Evaluate("attributes.department_#i#_#dep_counter#_3")>
		<cfset float_rowamount = Evaluate("attributes.department_#i#_#dep_counter#_1")>
		<cfquery name="add_dp" datasource="#new_dsn3_group_pur#">
			INSERT INTO #tablo_adi#
			(#alan_adi#,DEPARTMENT_ID,LOCATION_ID,AMOUNT)
			VALUES 
			(#attributes.ROW_MAIN_ID#,#int_rowdepartment#,#int_rowlocation#,#float_rowamount#)
		</cfquery>
	</cfloop>
<cfelse>
	<cfif ((isdefined("attributes.deliver_state") and len(attributes.deliver_state)) or (isdefined("attributes.deliver_dept_name") and len(attributes.deliver_dept_name))) and len(attributes.deliver_loc_id) and isdefined("attributes.deliver_dept_id") and len(attributes.deliver_dept_id) and isnumeric(attributes.deliver_loc_id) and (isdefined("attributes.deliver_dept_id") and  isnumeric(attributes.deliver_dept_id))>
		<cfif isdefined("attributes.department_#i#_count") and evaluate("attributes.department_#i#_count") eq 1 ><!---and Evaluate("attributes.amount#i#") eq Evaluate("attributes.department_#i#_1_1")--->
			<cfset int_rowdepartment = Evaluate("attributes.department_#i#_1_2")>
			<cfset int_rowlocation = Evaluate("attributes.department_#i#_1_3")>
			<cfset float_rowamount = Evaluate("attributes.department_#i#_1_1")>
			<cfif Evaluate("attributes.amount#i#") neq float_rowamount>
				<cfset float_rowamount = Evaluate("attributes.amount#i#")>
			</cfif>
		<cfelse>
			<cfif isdefined("attributes.deliver_dept#i#") and len(trim(evaluate("attributes.deliver_dept#i#"))) and len(listfirst(evaluate("attributes.deliver_dept#i#"),"-"))>
				<cfset int_rowdepartment = listfirst(evaluate("attributes.deliver_dept#i#"),"-")>
			<cfelseif len(attributes.deliver_dept_id)>
				<cfset int_rowdepartment = attributes.deliver_dept_id >
			</cfif>
			<cfif isdefined("attributes.deliver_dept#i#") and listlen(trim(evaluate("attributes.deliver_dept#i#")),"-") eq 2 and len(listlast(evaluate("attributes.deliver_dept#i#"),"-"))>
				<cfset int_rowlocation = listlast(evaluate("attributes.deliver_dept#i#"),"-") >
			<cfelseif len(attributes.deliver_loc_id)>
				<cfset int_rowlocation = attributes.deliver_loc_id >
			</cfif>
			<cfset float_rowamount = Evaluate("attributes.amount#i#")>
		</cfif>
		<cfquery name="add_dp" datasource="#new_dsn3_group_pur#">
			INSERT INTO #tablo_adi#
				(#alan_adi#,DEPARTMENT_ID,LOCATION_ID,AMOUNT)
			VALUES 
				(#attributes.ROW_MAIN_ID#,#int_rowdepartment#,#int_rowlocation#,#float_rowamount#)
		</cfquery>
	</cfif>
</cfif>

