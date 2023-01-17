<cfquery name="GET_WORKS" datasource="#DSN#">
	SELECT
		<cfif isdefined('attributes.type') and attributes.type eq 1>
			PROCESS_TYPE_ROWS.PROCESS_ROW_ID ROW_ID,
			PROCESS_TYPE_ROWS.STAGE ROW_NAME,
		<cfelse>
			PRO_WORK_CAT.WORK_CAT_ID ROW_ID,
			PRO_WORK_CAT.WORK_CAT ROW_NAME,
		</cfif>
		PRO_WORKS.TO_COMPLETE,
		COUNT(PRO_WORKS.WORK_ID) WORK_COUNT
	FROM
		PRO_WORKS,
		<cfif isdefined('attributes.type') and attributes.type eq 1>
			PROCESS_TYPE_ROWS
		<cfelseif isdefined('attributes.type') and attributes.type eq 2>
			PRO_WORK_CAT
		</cfif>
	WHERE
		<cfif isdefined('attributes.type') and attributes.type eq 1>
			PRO_WORKS.WORK_CURRENCY_ID = PROCESS_TYPE_ROWS.PROCESS_ROW_ID AND
		<cfelse>
			PRO_WORKS.WORK_CAT_ID = PRO_WORK_CAT.WORK_CAT_ID AND
		</cfif>
		PRO_WORKS.WORK_STATUS = 1
	GROUP BY
		<cfif isdefined('attributes.type') and attributes.type eq 1>
			PROCESS_TYPE_ROWS.PROCESS_ROW_ID,
			PROCESS_TYPE_ROWS.STAGE,
		<cfelse>
			PRO_WORK_CAT.WORK_CAT_ID,
			PRO_WORK_CAT.WORK_CAT,
		</cfif>
		PRO_WORKS.TO_COMPLETE
	ORDER BY
		<cfif isdefined('attributes.type') and attributes.type eq 1>
			PROCESS_TYPE_ROWS.STAGE ASC
		<cfelse>
			PRO_WORK_CAT.WORK_CAT ASC
		</cfif>
</cfquery>

<cf_grid_list>
	<thead>
		<cfquery name="GET_STAGES" dbtype="query">
			SELECT DISTINCT ROW_ID, ROW_NAME FROM GET_WORKS ORDER BY ROW_NAME ASC
		</cfquery>
		<cfoutput>
			<tr>
				<th class="txtbold"><cfif isdefined('attributes.type') and attributes.type eq 1><cf_get_lang dictionary_id='57482.Aşama'><cfelse><cf_get_lang dictionary_id='57486.Kategori'></cfif></th>
				<cfloop from="60" to="100" step="10" index="i">
					<th class="txtbold" style="text-align:center"><cfoutput>#i#</cfoutput>%</th>
				</cfloop>
				<th class="txtbold" style="text-align:center"><cf_get_lang dictionary_id='57492.Toplam'></th>
			</tr>
		</cfoutput>
		<cfset general_row_total = 0>
	</thead>
	<tbody>
		<cfoutput query="get_stages">	
			<tr>
				<td class="txtbold">#row_name#</td>
				<cfset row_total = 0>
				<cfloop from="60" to="100" step="10" index="i">
					<cfquery name="GET_WORK_RATE" dbtype="query">
						SELECT * FROM GET_WORKS WHERE TO_COMPLETE = <cfqueryparam cfsqltype="cf_sql_integer" value="#i#"> AND ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_stages.row_id#">
					</cfquery>
					<td style="text-align:right"><cfif get_work_rate.recordcount>#get_work_rate.work_count#</cfif></td>
					<cfif get_work_rate.recordcount>
						<cfset row_total = row_total + get_work_rate.work_count>
					</cfif>
				</cfloop>
				<cfset general_row_total = general_row_total + row_total>
				<td style="text-align:right" class="txtbold">#row_total#</td>
			</tr>
		</cfoutput>
		<tr>
			<td></td>
			<cfloop from="60" to="100" step="10" index="i">
				<cfquery name="GET_RATE_COUNTS" dbtype="query">
					SELECT SUM(WORK_COUNT) FROM GET_WORKS WHERE TO_COMPLETE = <cfqueryparam cfsqltype="cf_sql_integer" value="#i#">
				</cfquery>
				<td style="text-align:right" class="txtbold"><cfif get_rate_counts.recordcount><cfoutput>#get_rate_counts.column_0#</cfoutput></cfif></td>
			</cfloop>
			<td style="text-align:right" class="txtbold"><cfoutput>#general_row_total#</cfoutput></td>
		</tr>

	</tbody>
</cf_grid_list>