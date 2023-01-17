
<cfquery name="get_in_out_history" datasource="#dsn#">
	 SELECT
        OPR.GRADE,
        OPR.STEP,
        OPR.SEVERANCE_PENSION,
        OPR.ADDITIONAL_SCORE,
        SAL_MON,
        SAL_YEAR
    FROM
        EMPLOYEES_PUANTAJ EP
        INNER JOIN EMPLOYEES_PUANTAJ_ROWS EPR ON EPR.PUANTAJ_ID = EP.PUANTAJ_ID
        INNER JOIN OFFICER_PAYROLL_ROW OPR ON OPR.PAYROLL_ID = EP.PUANTAJ_ID AND EPR.EMPLOYEE_PUANTAJ_ID = OPR.EMPLOYEE_PAYROLL_ID

    WHERE
        EPR.IN_OUT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.in_out_id#">
    ORDER BY
        EP.SAL_YEAR DESC,
        EP.SAL_MON DESC
</cfquery>
<cfset get_factor_cmp = createObject("component", "V16.hr.ehesap.cfc.payroll_job")>

<cf_box title="#getLang('','Giriş Çıkış Tarihçesi',53671)#" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">	
	<cf_grid_list>
		<thead>
			<tr>
				<th><cf_get_lang dictionary_id='58724.Ay'> - <cf_get_lang dictionary_id='58455.Yıl'></th>
				<th><cf_get_lang dictionary_id='54179.Derece'> / <cf_get_lang dictionary_id='58710.Kademe'></th>
				<th><cf_get_lang dictionary_id='63278.Kıdem Aylığı'></th>
                <th><cf_get_lang dictionary_id='62877.Ek Gösterge Puanı'></th>
			</tr>
		</thead>
		<tbody>
			<cfif get_in_out_history.recordcount>
				<cfoutput query="get_in_out_history">
                    <cfset start_month = CreateDateTime(sal_year,sal_mon,1,0,0,0)>
                    <cfset get_factor = get_factor_cmp.get_factor_definition(
                        start_month : start_month,
                        end_month : start_month)
                    >
                    
					<tr>
						<td>#listgetat(ay_list(),SAL_MON,',')# - #SAL_YEAR#</td>
						<td>#GRADE# / #STEP#</td>
						<td class="text-right">#tlFormat(SEVERANCE_PENSION / get_factor.salary_factor)#</td>
						<td class="text-right">#tlFormat(ADDITIONAL_SCORE)#</td>
					</tr>
				</cfoutput>
				<cfelse>
				<tr>
					<td colspan="9"><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
				</tr>
			</cfif>
		</tbody>
	</cf_grid_list>
</cf_box>
