<cfquery name="GET_WORK_RATES" datasource="#DSN#">
	<cfif isdefined('attributes.type') and attributes.type eq 1>
		SELECT
			PRO_WORKS.RECORD_AUTHOR RECORD_AUTHOR,
			EMPLOYEES.EMPLOYEE_NAME,
			EMPLOYEES.EMPLOYEE_SURNAME,
			(SELECT SUM((ISNULL(TOTAL_TIME_HOUR,0)*60) + ISNULL(TOTAL_TIME_MINUTE,0)) FROM PRO_WORKS_HISTORY WHERE PRO_WORKS.WORK_ID = PRO_WORKS_HISTORY.WORK_ID GROUP BY WORK_ID)  HARCANAN_DAKIKA,
			PRO_WORKS.WORK_ID
		FROM
			PRO_WORKS,
			EMPLOYEES
		WHERE
			PRO_WORKS.RECORD_AUTHOR = EMPLOYEES.EMPLOYEE_ID AND
			PRO_WORKS.WORK_STATUS = 1  AND
			EMPLOYEES.EMPLOYEE_STATUS = 1 
	<cfelseif isdefined('attributes.type') and attributes.type eq 2>
		SELECT
			PRO_WORKS.WORK_CAT_ID WORK_CAT_ID,
			PRO_WORK_CAT.WORK_CAT,
			(SELECT SUM((ISNULL(TOTAL_TIME_HOUR,0)*60) + ISNULL(TOTAL_TIME_MINUTE,0)) FROM PRO_WORKS_HISTORY WHERE PRO_WORKS.WORK_ID = PRO_WORKS_HISTORY.WORK_ID GROUP BY WORK_ID)  HARCANAN_DAKIKA,
			PRO_WORKS.WORK_ID
		FROM
			PRO_WORKS,
			PRO_WORK_CAT
		WHERE
			PRO_WORKS.WORK_CAT_ID = PRO_WORK_CAT.WORK_CAT_ID AND
			PRO_WORKS.WORK_STATUS = 1
	</cfif>
</cfquery>

<cf_grid_list>
	<cfif isdefined('attributes.type') and attributes.type eq 1>
		<cfquery name="GET_RECORD_EMPS" dbtype="query">
			SELECT
				RECORD_AUTHOR,
				EMPLOYEE_NAME +' '+ EMPLOYEE_SURNAME AS NAME,
				COUNT(WORK_ID) WORK_COUNT
			FROM
				GET_WORK_RATES
			GROUP BY
				RECORD_AUTHOR,
				EMPLOYEE_NAME,
				EMPLOYEE_SURNAME
			ORDER BY
				EMPLOYEE_NAME ASC,
				EMPLOYEE_SURNAME ASC
		</cfquery>	
	<cfelseif isdefined('attributes.type') and attributes.type eq 2>
		<cfquery name="GET_RECORD_EMPS" dbtype="query">
			SELECT
				WORK_CAT_ID,
				WORK_CAT AS NAME,
				COUNT(WORK_ID) WORK_COUNT
			FROM
				GET_WORK_RATES
			GROUP BY
				WORK_CAT_ID,
				WORK_CAT
			ORDER BY
				WORK_CAT ASC
		</cfquery>	
	</cfif>
		<thead>
			<cfoutput>
				<tr>
					<th class="txtbold"><cfif isdefined('attributes.type') and attributes.type eq 1><cf_get_lang dictionary_id='52916.Delege Eden'><cfelseif isdefined('attributes.type') and attributes.type eq 2><cf_get_lang dictionary_id='57486.Kategori'></cfif></th>
					<th class="txtbold" style="text-align:center">< 1 <cf_get_lang dictionary_id='57491.saat'></th>
					<th class="txtbold" style="text-align:center">1 <cf_get_lang dictionary_id='57491.saat'> < x < 2 <cf_get_lang dictionary_id='57491.saat'></th>
					<th class="txtbold" style="text-align:center">2 <cf_get_lang dictionary_id='57491.saat'> < x < 5 <cf_get_lang dictionary_id='57491.saat'></th>
					<th class="txtbold" style="text-align:center">5 <cf_get_lang dictionary_id='57491.saat'> < x < 10 <cf_get_lang dictionary_id='57491.saat'></th>
					<th class="txtbold" style="text-align:center">1 <cf_get_lang dictionary_id='57490.gün'> < x < 1 <cf_get_lang dictionary_id='58734.hafta'></th>
					<th class="txtbold" style="text-align:center"><cf_get_lang dictionary_id='57492.Toplam'></th>
				</tr>
			</cfoutput>
		</thead>
		<tbody>
			<cfoutput query="get_record_emps">
				<tr class="color-row" height="20">
					<td class="txtbold">#name#</td>
					<cfset row_total = 0>
					<cfquery name="GET_WORK_RATE" dbtype="query">
						SELECT COUNT(WORK_ID) WORK_COUNT FROM GET_WORK_RATES WHERE <cfif isdefined('attributes.type') and attributes.type eq 1>RECORD_AUTHOR = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_record_emps.record_author#"><cfelseif isdefined('attributes.type') and attributes.type eq 2>WORK_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_record_emps.work_cat_id#"></cfif> AND HARCANAN_DAKIKA <= 60
					</cfquery>
					<td style="text-align:right"><cfif get_work_rate.recordcount>#get_work_rate.work_count#</cfif></td>
					<cfif get_work_rate.recordcount>
						<cfset row_total = row_total + get_work_rate.work_count>
					</cfif>
					<cfquery name="GET_WORK_RATE" dbtype="query">
						SELECT COUNT(WORK_ID) WORK_COUNT FROM GET_WORK_RATES WHERE <cfif isdefined('attributes.type') and attributes.type eq 1>RECORD_AUTHOR = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_record_emps.record_author#"><cfelseif isdefined('attributes.type') and attributes.type eq 2>WORK_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_record_emps.work_cat_id#"></cfif> AND HARCANAN_DAKIKA > 60 AND HARCANAN_DAKIKA <= 120 
					</cfquery>
					<td style="text-align:right"><cfif get_work_rate.recordcount>#get_work_rate.work_count#</cfif></td>
					<cfif get_work_rate.recordcount>
						<cfset row_total = row_total + get_work_rate.work_count>
					</cfif>
					<cfquery name="GET_WORK_RATE" dbtype="query">
						SELECT COUNT(WORK_ID) WORK_COUNT FROM GET_WORK_RATES WHERE <cfif isdefined('attributes.type') and attributes.type eq 1>RECORD_AUTHOR = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_record_emps.record_author#"><cfelseif isdefined('attributes.type') and attributes.type eq 2>WORK_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_record_emps.work_cat_id#"></cfif> AND HARCANAN_DAKIKA > 120 AND HARCANAN_DAKIKA <= 300 
					</cfquery>
					<td style="text-align:right"><cfif get_work_rate.recordcount>#get_work_rate.work_count#</cfif></td>
					<cfif get_work_rate.recordcount>
						<cfset row_total = row_total + get_work_rate.work_count>
					</cfif>
					<cfquery name="GET_WORK_RATE" dbtype="query">
						SELECT COUNT(WORK_ID) WORK_COUNT FROM GET_WORK_RATES WHERE <cfif isdefined('attributes.type') and attributes.type eq 1>RECORD_AUTHOR = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_record_emps.record_author#"><cfelseif isdefined('attributes.type') and attributes.type eq 2>WORK_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_record_emps.work_cat_id#"></cfif>  AND HARCANAN_DAKIKA > 300 AND HARCANAN_DAKIKA <= 600 
					</cfquery>
					<td style="text-align:right"><cfif get_work_rate.recordcount>#get_work_rate.work_count#</cfif></td>
					<cfif get_work_rate.recordcount>
						<cfset row_total = row_total + get_work_rate.work_count>
					</cfif>
					<cfquery name="GET_WORK_RATE" dbtype="query">
						SELECT COUNT(WORK_ID) WORK_COUNT FROM GET_WORK_RATES WHERE <cfif isdefined('attributes.type') and attributes.type eq 1>RECORD_AUTHOR = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_record_emps.record_author#"><cfelseif isdefined('attributes.type') and attributes.type eq 2>WORK_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_record_emps.work_cat_id#"></cfif>  AND HARCANAN_DAKIKA > 600 AND HARCANAN_DAKIKA <= 1440 
					</cfquery>
					<td style="text-align:right"><cfif get_work_rate.recordcount>#get_work_rate.work_count#</cfif></td>
					<cfif get_work_rate.recordcount>
						<cfset row_total = row_total + get_work_rate.work_count>
					</cfif>
					<td style="text-align:right" class="txtbold">#row_total#</td>
				</tr>
			</cfoutput>
			<cfset general_row_total = 0>
			<tr class="color-row">
				<td></td>
				<cfquery name="GET_TOTAL_COUNTS" dbtype="query">
					SELECT COUNT(WORK_ID) WORK_COUNT FROM GET_WORK_RATES WHERE HARCANAN_DAKIKA <= 60
				</cfquery>
				<td style="text-align:right" class="txtbold"><cfif get_total_counts.recordcount><cfoutput>#get_total_counts.work_count#</cfoutput></cfif></td>
				<cfif get_total_counts.recordcount><cfset general_row_total = general_row_total + get_total_counts.work_count></cfif>
				<cfquery name="GET_TOTAL_COUNTS" dbtype="query">
					SELECT COUNT(WORK_ID) WORK_COUNT FROM GET_WORK_RATES WHERE HARCANAN_DAKIKA > 60 AND HARCANAN_DAKIKA <= 120 
				</cfquery>
				<td style="text-align:right" class="txtbold"><cfif get_total_counts.recordcount><cfoutput>#get_total_counts.work_count#</cfoutput></cfif></td>
				<cfif get_total_counts.recordcount><cfset general_row_total = general_row_total + get_total_counts.work_count></cfif>
				<cfquery name="GET_TOTAL_COUNTS" dbtype="query">
					SELECT COUNT(WORK_ID) WORK_COUNT FROM GET_WORK_RATES WHERE HARCANAN_DAKIKA > 120 AND HARCANAN_DAKIKA <= 300 
				</cfquery>
				<td style="text-align:right" class="txtbold"><cfif get_total_counts.recordcount><cfoutput>#get_total_counts.work_count#</cfoutput></cfif></td>
				<cfif get_total_counts.recordcount><cfset general_row_total = general_row_total + get_total_counts.work_count></cfif>
				<cfquery name="GET_TOTAL_COUNTS" dbtype="query">
					SELECT COUNT(WORK_ID) WORK_COUNT FROM GET_WORK_RATES WHERE HARCANAN_DAKIKA > 300 AND HARCANAN_DAKIKA <= 600 
				</cfquery>
				<td style="text-align:right" class="txtbold"><cfif get_total_counts.recordcount><cfoutput>#get_total_counts.work_count#</cfoutput></cfif></td>
				<cfif get_total_counts.recordcount><cfset general_row_total = general_row_total + get_total_counts.work_count></cfif>
				<cfquery name="GET_TOTAL_COUNTS" dbtype="query">
					SELECT COUNT(WORK_ID) WORK_COUNT FROM GET_WORK_RATES WHERE HARCANAN_DAKIKA > 600 AND HARCANAN_DAKIKA <= 1440
				</cfquery>
				<td style="text-align:right" class="txtbold"><cfif get_total_counts.recordcount><cfoutput>#get_total_counts.work_count#</cfoutput></cfif></td>	
				<cfif get_total_counts.recordcount><cfset general_row_total = general_row_total + get_total_counts.work_count></cfif>	
				<td style="text-align:right" class="txtbold"><cfoutput>#general_row_total#</cfoutput></td>
			</tr>
		</tbody>
</cf_grid_list>
