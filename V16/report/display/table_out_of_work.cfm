<cfquery name="GET_WORKS" datasource="#DSN#">
	SELECT
		PRO_WORKS.WORK_CAT_ID,
		PRO_WORK_CAT.WORK_CAT,
		PRO_WORKS.PROJECT_EMP_ID,
		EMPLOYEES.EMPLOYEE_NAME,
		EMPLOYEES.EMPLOYEE_SURNAME,
		COUNT(PRO_WORKS.WORK_ID) WORK_COUNT
	FROM
		PRO_WORKS,
		PRO_WORK_CAT,
		EMPLOYEES
	WHERE
		PRO_WORKS.WORK_CAT_ID = PRO_WORK_CAT.WORK_CAT_ID AND
		PRO_WORKS.PROJECT_EMP_ID = EMPLOYEES.EMPLOYEE_ID AND
		PRO_WORKS.WORK_STATUS = 1  AND
		PRO_WORKS.TARGET_FINISH < #now()# AND
		EMPLOYEES.EMPLOYEE_STATUS = 1
	GROUP BY
		PRO_WORKS.WORK_CAT_ID,
		PRO_WORK_CAT.WORK_CAT,
		PRO_WORKS.PROJECT_EMP_ID,
		EMPLOYEES.EMPLOYEE_NAME,
		EMPLOYEES.EMPLOYEE_SURNAME
	ORDER BY
		PRO_WORK_CAT.WORK_CAT ASC
</cfquery>

<cf_grid_list>
	<thead>
		<cfquery name="GET_WORK_CATS" dbtype="query">
			SELECT DISTINCT WORK_CAT_ID, WORK_CAT FROM GET_WORKS ORDER BY WORK_CAT ASC
		</cfquery>
		<cfquery name="GET_PROJECT_EMPS" dbtype="query">
			SELECT DISTINCT PROJECT_EMP_ID, EMPLOYEE_NAME, EMPLOYEE_SURNAME FROM GET_WORKS ORDER BY EMPLOYEE_NAME ASC, EMPLOYEE_SURNAME ASC
		</cfquery>
		<cfset rcrd = get_project_emps.recordcount + 1>	
			<tr>
				<th class="txtbold"><cf_get_lang dictionary_id='57486.Kategori'></th>
				<cfoutput query="get_project_emps">
					<th class="txtbold" >#employee_name# #employee_surname#</th>
				</cfoutput>
				<th class="txtbold" style="text-align:center"><cf_get_lang dictionary_id='57492.Toplam'></th>
			</tr>
		<cfset general_row_total = 0>
	</thead>
	<tbody>
		<cfoutput query="get_work_cats">
			<cfset row_total = 0>
			<tr>
				<td class="txtbold">#work_cat#</td>
				<cfloop query="get_project_emps">
					<cfquery name="GET_WORK_RATE" dbtype="query">
						SELECT * FROM GET_WORKS WHERE WORK_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_work_cats.work_cat_id#"> AND PROJECT_EMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_project_emps.project_emp_id#">
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
		<tr>
			<td></td>
			<cfloop query="get_project_emps">
				<cfquery name="GET_RATE_COUNTS" dbtype="query">
					SELECT SUM(WORK_COUNT) FROM GET_WORKS WHERE PROJECT_EMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_project_emps.project_emp_id#">
				</cfquery>
				<td style="text-align:right" class="txtbold"><cfif get_rate_counts.recordcount><cfoutput>#get_rate_counts.column_0#</cfoutput></cfif></td>
			</cfloop>
			<td style="text-align:right" class="txtbold"><cfoutput>#general_row_total#</cfoutput></td>
		</tr>

	</tbody>
</cf_grid_list>