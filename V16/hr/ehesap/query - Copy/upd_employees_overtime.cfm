<cfloop from="1" to="#attributes.rowCount#" index="i">
	<cfif evaluate("attributes.row_kontrol_#i#") eq 1>
		<cfif evaluate("attributes.value0_#i#") gt 0 or evaluate("attributes.value1_#i#") gt 0 or evaluate("attributes.value2_#i#") gt 0 or evaluate("attributes.value3_#i#") gt 0>
			<cfquery name="add_worktimes" datasource="#dsn#">
				INSERT INTO 
					EMPLOYEES_OVERTIME
				(
					EMPLOYEE_ID,
					IN_OUT_ID,
					OVERTIME_PERIOD,
					OVERTIME_MONTH,
					OVERTIME_VALUE_0,
					OVERTIME_VALUE_1,
					OVERTIME_VALUE_2,
					OVERTIME_VALUE_3,
					RECORD_EMP,
					RECORD_DATE,
					RECORD_IP
				)
				VALUES
				(	
					#attributes.employee_id#,
					#attributes.in_out_id#,
					#evaluate("attributes.term#i#")#,
					#evaluate("attributes.start_mon#i#")#,
					#evaluate("attributes.value0_#i#")#,  
					#evaluate("attributes.value1_#i#")#,
					#evaluate("attributes.value2_#i#")#,
					#evaluate("attributes.value3_#i#")#,
					#session.ep.userid#,
					#now()#,
					'#cgi.REMOTE_ADDR#'
				)					 
			</cfquery>	
		</cfif>
	</cfif>
</cfloop>
<cfloop from="1" to="#attributes.rowCount_sabit#" index="i">
	<cfif evaluate("attributes.sabit_row_kontrol_#i#") eq 1>
		<cfif evaluate("attributes.sabit_value0_#i#") gt 0 or evaluate("attributes.sabit_value1_#i#") gt 0 or evaluate("attributes.sabit_value2_#i#") gt 0 or evaluate("attributes.sabit_value3_#i#") gt 0>
			<cfquery name="upd_worktimes" datasource="#dsn#">
				UPDATE
					EMPLOYEES_OVERTIME
				SET
					OVERTIME_PERIOD = #evaluate("attributes.sabit_term#i#")#,
					OVERTIME_MONTH = #evaluate("attributes.sabit_start_mon#i#")#,
					OVERTIME_VALUE_0 = #evaluate("attributes.sabit_value0_#i#")#,  
					OVERTIME_VALUE_1 = #evaluate("attributes.sabit_value1_#i#")#,
					OVERTIME_VALUE_2 = #evaluate("attributes.sabit_value2_#i#")#,
					OVERTIME_VALUE_3 = #evaluate("attributes.sabit_value3_#i#")#,
					UPDATE_EMP  = #session.ep.userid#,
					UPDATE_DATE =  #now()#,
					UPDATE_IP = '#cgi.REMOTE_ADDR#'
				WHERE
					WORKTIMES_ID = #evaluate("attributes.sabit_worktimes_id#i#")#
			</cfquery>
		</cfif>
	<cfelse>
		<cfquery name="del_" datasource="#dsn#">
			DELETE FROM EMPLOYEES_OVERTIME WHERE WORKTIMES_ID = #evaluate("attributes.sabit_worktimes_id#i#")#
		</cfquery>
	</cfif>
</cfloop>	
<cfif isdefined("attributes.from_upd_salary") and len(attributes.from_upd_salary)>
	<cflocation url="#request.self#?fuseaction=ehesap.list_salary&event=upd&in_out_id=#attributes.in_out_id#&employee_id=#attributes.employee_id#&type=10" addtoken="No">
<cfelse>
	<script type="text/javascript">
		window.close();
	</script>
</cfif>