<cfset buay=month(now())>
<cfquery name="get_norm" datasource="#DSN#">
	SELECT 
		EMPLOYEE_NORM_POSITIONS.*,
		ZONE.ZONE_NAME,
		BRANCH.BRANCH_NAME,
		BRANCH.BRANCH_ID,
		OUR_COMPANY.NICK_NAME,
		DEPARTMENT.DEPARTMENT_HEAD,
		SETUP_POSITION_CAT.POSITION_CAT
	FROM 
		EMPLOYEE_NORM_POSITIONS
		INNER JOIN BRANCH ON BRANCH.BRANCH_ID=EMPLOYEE_NORM_POSITIONS.BRANCH_ID
		INNER JOIN ZONE ON ZONE.ZONE_ID = BRANCH.ZONE_ID
		INNER JOIN OUR_COMPANY ON BRANCH.COMPANY_ID = OUR_COMPANY.COMP_ID
		LEFT JOIN DEPARTMENT ON DEPARTMENT.DEPARTMENT_ID = EMPLOYEE_NORM_POSITIONS.DEPARTMENT_ID
		LEFT JOIN SETUP_POSITION_CAT ON SETUP_POSITION_CAT.POSITION_CAT_ID = EMPLOYEE_NORM_POSITIONS.POSITION_CAT_ID
	WHERE	
		EMPLOYEE_NORM_POSITIONS.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#branch_id#"> AND	
		ZONE.ZONE_STATUS = 1 AND
		BRANCH.BRANCH_STATUS = 1 AND
		EMPLOYEE_NORM_POSITIONS.NORM_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.norm_year#">		
</cfquery>
<cfinclude template="../query/get_emp_norm_count_with_func.cfm">
<cfinclude template="../query/get_setup_moneys.cfm">
<!--- toplamlar icin ilk deger atamalari yapiliyor --->
<cfloop from="0" to="11" index="i">
  <cfset "toplam_#i#"=0>
  <cfset "toplam_#i#_sal"=0>
  <cfset "toplam_gercek_#i#"=0>
  <cfset "toplam_gercek_#i#_sal"=0>
</cfloop>
<cfset toplam_yan=0>
<cfset toplam_yan_gercek=0>
<cfset toplam_salary=0>
<cfset salary=0>
<!--- //toplamlar icin ilk deger atamalari yapiliyor --->
<cfsavecontent variable="title_">
	<cfif get_norm.recordcount><cfoutput>#get_norm.nick_name# - #get_norm.branch_name#</cfoutput><cfelse><cf_get_lang dictionary_id="55211.Norm Kadrolar"></cfif>
</cfsavecontent>
<cf_popup_box title="#title_#">
	<cf_medium_list>
		<thead>
			<tr>
			  <th nowrap><cf_get_lang dictionary_id='57572.Departman'></th>
			  <th nowrap><cf_get_lang dictionary_id='59004.Pozisyon Tipi'></th>
			  <th nowrap style="text-align:right;"><cf_get_lang dictionary_id='55123.ücret'></th>
			  <input name="record_num" id="record_num" type="hidden" value="<cfoutput>#get_norm.recordcount#</cfoutput>">
			  <input name="branch_id" id="branch_id" type="hidden" value="<cfoutput>#attributes.branch_id#</cfoutput>">
			  <cfloop from="1" to="12" index="i">
				<th align="center" colspan="2"><cfoutput>#ListGetAt(ay_list(),i,",")#</cfoutput></th>
			  </cfloop>
			</tr>
		</thead>
		<tbody>
		  <cfoutput query="get_norm">
		  <tr>
			<td nowrap>#department_head#</td>
			<td nowrap>#position_cat#</td>
			<td nowrap style="text-align:right;">
			  <cfquery name="get_money" datasource="#DSN#">
				  SELECT 
					  (RATE2/RATE1) AS RATE 
				  FROM 
					  SETUP_MONEY
				  WHERE
					  PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#"> AND
					  MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#money#">
			  </cfquery>
			  <cfif isnumeric(get_money.RATE)>
				<cfset rate=get_money.RATE>
				<cfelse>
				<cfset rate=0>
			  </cfif>

			  <cfif isnumeric(AVERAGE_SALARY)>
				<cfset salary = average_salary*rate>
				<cfset toplam_salary = toplam_salary + average_salary>
				#TLFormat(salary,0)# #money#
			  </cfif>
			</td>
			<cfset "toplam_yan_#currentrow#"=0>
			<cfset "toplam_yan_gercek_#currentrow#"=0>
			<cfloop from="0" to="11" index="i">
			<cfset ay = i + 1>
			<cfset yil = session.ep.period_year>
			  <td align="center">
			  <cfset tpl=evaluate("EMPLOYEE_COUNT#evaluate(i+1)#")>
			  #tpl#
			  </td>
			  <td align="center">
			  <cfquery name="get_e" datasource="#DSN#">
				SELECT DISTINCT
					ISNULL((SELECT TOP 1 M#ay# FROM EMPLOYEES_SALARY ES,EMPLOYEES_IN_OUT EIO WHERE ES.IN_OUT_ID = EIO.IN_OUT_ID AND EIO.EMPLOYEE_ID = EP.EMPLOYEE_ID AND EIO.BRANCH_ID = D.BRANCH_ID AND DATEPART(MM,EIO.START_DATE) <= #ay# AND DATEPART(YYYY,EIO.START_DATE) <= #yil# AND ((DATEPART(MM,EIO.FINISH_DATE) >= #ay# AND DATEPART(YYYY,EIO.FINISH_DATE) >= #yil#) OR EIO.FINISH_DATE IS NULL) AND ES.PERIOD_YEAR = #yil#),0) AS GERCEK_MAAS,
					EP.POSITION_ID
				FROM
					EMPLOYEE_POSITIONS_HISTORY EP,
					DEPARTMENT D
				WHERE
					D.DEPARTMENT_ID = EP.DEPARTMENT_ID AND
					D.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#branch_id#"> AND
					EP.DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#department_id#"> AND
					EP.POSITION_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#position_cat_id#"> AND
					DATEPART(MM,EP.START_DATE) <= #ay# AND
					DATEPART(YYYY,EP.START_DATE) <= #yil# AND
					(
						(
						DATEPART(MM,EP.FINISH_DATE) >= #ay# AND
						DATEPART(YYYY,EP.FINISH_DATE) >= #yil#
						)
					OR
						EP.FINISH_DATE IS NULL
					)
			</cfquery>
			  <cfset tpl_gercek=get_e.RECORDCOUNT>#tpl_gercek#</td>
			  <cfset gercek_total_maas_ = 0>
			  <cfset satir_ = 0>
			  <cfloop query="get_e">
					<cfset satir_ = satir_ + 1>
					<cfif get_e.recordcount and len(get_e.GERCEK_MAAS[satir_])>
						<cfset gercek_salary_ = get_e.GERCEK_MAAS[satir_]>
					<cfelse>
						<cfset gercek_salary_ = salary>
					</cfif>
					<cfset gercek_total_maas_ = gercek_total_maas_ + gercek_salary_>
			  </cfloop>
			 <cfif isnumeric(tpl)>
				<cfset "toplam_#i#"=evaluate("toplam_#i#")+tpl>
				<cfset "toplam_#i#_sal"=evaluate("toplam_#i#_sal")+(tpl*salary)>
				<cfset "toplam_yan_#currentrow#"=evaluate("toplam_yan_#currentrow#")+tpl>
			  </cfif>
			  <cfif isnumeric(tpl_gercek)>
				<cfset "toplam_gercek_#i#"= evaluate("toplam_gercek_#i#")+tpl_gercek>
				<cfset "toplam_gercek_#i#_sal"=evaluate("toplam_gercek_#i#_sal")+gercek_total_maas_>
				<cfset "toplam_yan_gercek_#currentrow#"=evaluate("toplam_yan_gercek_#currentrow#")+tpl_gercek>
			  </cfif>
			</cfloop>
		  </tr>
		</cfoutput>
		</tbody>
		<tfoot>
			<!--- alt satir toplami --->
			<tr>
			  <td colspan="3" class="txtbold"><cf_get_lang dictionary_id="58869.Planlanan"> / <cf_get_lang dictionary_id="55688.Gerçekleşen"></td>
			  <cfloop from="0" to="11" index="i">
				<td colspan="2" nowrap>
				<cfif evaluate("toplam_#i#_sal") neq 0>
				  <cfoutput>#TLFormat(evaluate(evaluate("toplam_#i#_sal")),0)# #SESSION.EP.MONEY#</cfoutput>
				</cfif>
				<cfif evaluate("toplam_gercek_#i#") neq 0>
				  <cfoutput><font color="FF0000">#TLFormat(evaluate(evaluate("toplam_gercek_#i#_sal")),0)# #SESSION.EP.MONEY#</font></cfoutput>
				</cfif>
				</td>
			  </cfloop>
			</tr>
       </tfoot>
	</cf_medium_list>
</cf_popup_box>
