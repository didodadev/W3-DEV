<cfquery name="GET_WORK_RATES" datasource="#DSN#">
	SELECT
		PRO_WORKS.RECORD_AUTHOR RECORD_AUTHOR,
		EMPLOYEES.EMPLOYEE_NAME,
		EMPLOYEES.EMPLOYEE_SURNAME,
		PRO_WORKS.PROJECT_EMP_ID,
		COUNT(PRO_WORKS.WORK_ID) WORK_COUNT
	FROM
		PRO_WORKS,
		EMPLOYEES
	WHERE
		PRO_WORKS.RECORD_AUTHOR = EMPLOYEES.EMPLOYEE_ID AND
		PRO_WORKS.WORK_STATUS = 1  AND
		EMPLOYEES.EMPLOYEE_STATUS = 1
	GROUP BY
		PRO_WORKS.RECORD_AUTHOR,
		EMPLOYEES.EMPLOYEE_NAME,
		EMPLOYEES.EMPLOYEE_SURNAME,
		PRO_WORKS.PROJECT_EMP_ID
	ORDER BY
		EMPLOYEES.EMPLOYEE_NAME ASC,
		EMPLOYEES.EMPLOYEE_SURNAME ASC
</cfquery>

<cfquery name="GET_EMPS" dbtype="query">
	SELECT DISTINCT RECORD_AUTHOR, EMPLOYEE_NAME, EMPLOYEE_SURNAME FROM GET_WORK_RATES ORDER BY EMPLOYEE_NAME ASC, EMPLOYEE_SURNAME ASC
</cfquery>
<cfquery name="GET_RECORD_EMPS" dbtype="query">
	SELECT DISTINCT RECORD_AUTHOR, EMPLOYEE_NAME, EMPLOYEE_SURNAME FROM GET_WORK_RATES ORDER BY EMPLOYEE_NAME ASC, EMPLOYEE_SURNAME ASC
</cfquery>
<cfset rcrd = get_emps.recordcount + 1>	

<cf_grid_list>
	<thead>
		
			<tr>
				<th class="txtbold"><cf_get_lang dictionary_id='52916.Delege Eden'></td></th>
				<cfoutput query="get_emps">
					<th class="txtbold">#employee_name# #employee_surname#</th>
				</cfoutput>
				<th class="txtbold" style="text-align:center"><cf_get_lang dictionary_id='57492.Toplam'></th>
				
			</tr>
		
	</thead>
	<cfset general_row_total = 0>
	<tbody>
		<cfoutput query="get_record_emps">
			<tr class="color-row" height="20">
				<td class="txtbold">#employee_name# #employee_surname#</td>
				<cfset row_total = 0>
				<cfloop query="get_emps">
					<cfquery name="GET_WORK_RATE" dbtype="query">
						SELECT * FROM GET_WORK_RATES WHERE RECORD_AUTHOR = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_record_emps.record_author#"> AND PROJECT_EMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_emps.record_author#">
					</cfquery>
					<td style="text-align:right"><cfif get_work_rate.recordcount>#get_work_rate.work_count#</cfif></td>
					<cfif get_work_rate.recordcount>
						<cfset row_total = row_total + get_work_rate.work_count>
					</cfif>
				</cfloop>
				<td style="text-align:right" class="txtbold">#row_total#</td>
				<cfset general_row_total = general_row_total + row_total>
			</tr>
		</cfoutput>
		<tr class="color-row">
			<td></td>
			<cfloop query="get_emps">
				<cfquery name="GET_RATE_COUNTS" dbtype="query">
					SELECT SUM(WORK_COUNT) FROM GET_WORK_RATES WHERE PROJECT_EMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_emps.record_author#">
				</cfquery>
				<td style="text-align:right" class="txtbold"><cfif get_rate_counts.recordcount><cfoutput>#get_rate_counts.column_0#</cfoutput></cfif></td>
			</cfloop>
			<td style="text-align:right" class="txtbold"><cfoutput>#general_row_total#</cfoutput></td>
		</tr>
	</tbody>

</cf_grid_list>
