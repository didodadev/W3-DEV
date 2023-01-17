<cftransaction>
		<cfquery datasource="#DSN#">
			DELETE
			FROM
				EMPLOYEE_NORM_POSITIONS
			WHERE
				BRANCH_ID=#attributes.BRANCH_ID#
		</cfquery>
		<cfloop from="1" to="#attributes.record_num#" index="i">
			<cfif isdefined("attributes.department_id#i#")>
						<cfset dep_id=evaluate("attributes.department_id#i#")>
						<cfset pos_id=evaluate("attributes.position_cat_id#i#")>
						<cfset money_=evaluate("attributes.MONEY#i#")>
						<cfset salary=evaluate("attributes.salary#i#")>
						<cfset row_kontrol=evaluate("attributes.row_kontrol#i#")>
						<cfif LEN(dep_id) and LEN(pos_id) and row_kontrol eq 1>
							<cfquery datasource="#DSN#">
								INSERT INTO EMPLOYEE_NORM_POSITIONS
								(
										DEPARTMENT_ID, 
										POSITION_CAT_ID, 
										MONEY,      
										AVERAGE_SALARY,                                       
										EMPLOYEE_COUNT1, 
										EMPLOYEE_COUNT2, 
										EMPLOYEE_COUNT3, 
										EMPLOYEE_COUNT4, 
										EMPLOYEE_COUNT5, 
										EMPLOYEE_COUNT6, 
										EMPLOYEE_COUNT7, 
										EMPLOYEE_COUNT8, 
										EMPLOYEE_COUNT9, 
										EMPLOYEE_COUNT10, 
										EMPLOYEE_COUNT11, 
										EMPLOYEE_COUNT12,
										BRANCH_ID,
										NORM_YEAR
								)
								VALUES
								(
										#dep_id#,
										#pos_id#,
										'#money_#',
										<cfif len(salary)>#salary#<cfelse>NULL</cfif>
										<cfloop from="0" to="11" index="k">
											<cfset deger=evaluate("attributes.count_#i#_#k#")>
											<cfif LEN(deger)>,#deger#<cfelse>,NULL</cfif>	
										</cfloop>		
										,#attributes.BRANCH_ID#	,
										#attributes.NORM_YEAR#
								)
						</cfquery>
					</cfif>
			</cfif>
		</cfloop>
</cftransaction>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>

