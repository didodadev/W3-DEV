<cfif not isdefined("puantaj_action")>
	<cfset puantaj_action = createObject("component", "V16.hr.ehesap.cfc.create_puantaj")>
	<cfset puantaj_action.dsn = dsn />
	
	<cfset get_hr_ssk = puantaj_action.get_hr_ssk(attributes.sal_mon,attributes.sal_year,attributes.employee_id)/>
</cfif>

<cfset gelir_vergisi_matrah_ay_icinde_nakil = 0>
<cfscript>
	employee_id_ = attributes.EMPLOYEE_ID;
	this_expense_code_ = get_hr_ssk.expense_code;
	this_account_code_ = get_hr_ssk.account_code;
	this_account_bill_type_ = get_hr_ssk.account_bill_type;
</cfscript>

<!---SG 20130227 --->
<cfset get_half_offtimes = { recordcount: 0 }>
<cfset get_half_offtimes_total_hour = 0>
<!---// --->
<cfset last_branch_id = get_hr_ssk.BRANCH_ID>
<cfif not isdefined("attributes.in_out_id") or not len(attributes.in_out_id)>
	<cfset attributes.in_out_id = get_hr_ssk.in_out_id>
</cfif>
<cfset attributes.branch_id = get_hr_ssk.BRANCH_ID>	
<cfset attributes.group_id = "">
<cfif len(get_hr_ssk.puantaj_group_ids)>
	<cfset attributes.group_id = "#get_hr_ssk.PUANTAJ_GROUP_IDS#,">
</cfif>
<cfinclude template="../query/get_program_parameter.cfm">
<cfquery name="get_active_program_parameter" dbtype="query"><!--- maxrows="1" --->
	SELECT * FROM get_program_parameters  <!---WHERE STARTDATE <= #last_month_1#  AND FINISHDATE >= #last_month_30# --->
</cfquery>
<cfscript>
	//Bordro akış parametrelerinden eğer bordro tarihleri girildiyse o tarihleri alır
	if(isdefined("get_active_program_parameter.FIRST_DAY_MONTH") and len(get_active_program_parameter.FIRST_DAY_MONTH) and not(get_active_program_parameter.FIRST_DAY_MONTH eq 1 and get_program_parameters.LAST_DAY_MONTH eq 0))
	{
		last_month_1 = CreateDateTime(attributes.sal_year, attributes.sal_mon,get_active_program_parameter.FIRST_DAY_MONTH,0,0,0);
		last_month_1_general = CreateDateTime(attributes.sal_year, attributes.sal_mon,get_active_program_parameter.FIRST_DAY_MONTH,0,0,0);

		last_month_30 = CreateDateTime(attributes.sal_year, attributes.sal_mon,get_active_program_parameter.LAST_DAY_MONTH,23,59,59);
		last_month_30 = dateadd("m",1,last_month_30);

		last_month_30_general = CreateDateTime(attributes.sal_year, attributes.sal_mon,get_active_program_parameter.LAST_DAY_MONTH,23,59,59);
		last_month_30_general = dateadd("m",1,last_month_30_general);
	}
	else
	{
		last_month_1 = CreateDateTime(attributes.sal_year, attributes.sal_mon,1,0,0,0);
		last_month_30 = CreateDateTime(attributes.sal_year, attributes.sal_mon,daysinmonth(last_month_1),23,59,59);
		
		last_month_1_general = CreateDateTime(attributes.sal_year, attributes.sal_mon,1,0,0,0);
		last_month_30_general = CreateDateTime(attributes.sal_year, attributes.sal_mon,daysinmonth(last_month_1_general),23,59,59);
		
	} 
	if (datediff("h",last_month_1,get_hr_ssk.start_date) gte 0)
		last_month_1 = get_hr_ssk.start_date;
	last_month_1 = date_add("d",0,last_month_1);
	if (len(get_hr_ssk.finish_date) and datediff("d",get_hr_ssk.finish_date,last_month_30) gt 0)
		last_month_30 = CreateDateTime(year(get_hr_ssk.finish_date),month(get_hr_ssk.finish_date),day(get_hr_ssk.finish_date), 23,59,59);
</cfscript>
<cfset get_payroll_job = createObject("component", "V16.hr.ehesap.cfc.payroll_job")>
<!--- Memur değilse ve  parametrelerinden eğer bordro tarihleri 1-aysonu hariç seçilmişse --->
<cfif (get_hr_ssk.USE_SSK neq 2) and (isdefined("get_program_parameters.FIRST_DAY_MONTH") and len(get_program_parameters.FIRST_DAY_MONTH) and not(get_program_parameters.FIRST_DAY_MONTH eq 1 and get_program_parameters.LAST_DAY_MONTH eq 0)) >
	
	<cfset last_salary = get_payroll_job.get_salary_history(start_month: last_month_1,in_out_id : attributes.in_out_id)>
	<cfset last_salary_end = get_payroll_job.get_salary_history(start_month: last_month_1,in_out_id : attributes.in_out_id)>

	<!--- 2 ay arasında maaş farklıysa --->
	<cfif evaluate("last_salary.M#month(last_month_1)#") neq evaluate("last_salary_end.M#month(last_month_30)#")>

		<cfset last_month_1 = listappend(last_month_1,CreateDateTime(year(last_month_30),month(last_month_30),1,0,0,0))>

		<cfset temp_last = last_month_30>
		<cfset last_month_30 = CreateDateTime(attributes.sal_year, attributes.sal_mon,daysinmonth(last_month_1),23,59,59)>
		<cfset last_month_30 = listAppend(last_month_30,temp_last)>
		
		<cfset last_month_1_general = last_month_1>
		<cfset last_month_30_general = last_month_30>
		<cfset for_ssk_day = 1>

	</cfif>
</cfif>
<cfset last_month_30_temp = last_month_30>
<cfset last_month_30_general_temp = last_month_30_general>

<cfloop list="#last_month_1#" item="date" index="date_row">

	<cfset last_month_1 = date>
	<cfset last_month_1_general = date>
	<cfset last_month_30 = ListGetAt(last_month_30_temp,date_row)>
	<cfset last_month_30_general = ListGetAt(last_month_30_general_temp,date_row)>
	<cfset attributes.sal_mon = month(last_month_1)>
	<cfset attributes.sal_year = year(last_month_1)>

	<cfif not isdefined("get_general_offtimes_all.recordcount")>
		<cfset get_general_offtimes_all = puantaj_action.get_general_offtimes_all(last_month_1_general,last_month_30_general)/>
	</cfif>

	<cfquery name="get_general_offtimes" dbtype="query">
		SELECT 
			START_DATE,
			FINISH_DATE 
		FROM 
			get_general_offtimes_all
		WHERE 
			START_DATE BETWEEN #LAST_MONTH_1# AND #LAST_MONTH_30# OR 
			FINISH_DATE BETWEEN #LAST_MONTH_1# AND #LAST_MONTH_30#
		GROUP BY
			START_DATE,
			FINISH_DATE 
		ORDER BY
			START_DATE ASC
	</cfquery>


	<cfif len(get_active_program_parameter.CAST_STYLE)><!--- hesaplama turu , normal (0) - asgari gecim (1) --->
		<cfset this_cast_style_ = get_active_program_parameter.CAST_STYLE>
	<cfelse>
		<cfset this_cast_style_ = 0>
	</cfif>
	<cfif len(get_active_program_parameter.TAX_ACCOUNT_STYLE)>
		<cfset this_tax_account_style_ = get_active_program_parameter.TAX_ACCOUNT_STYLE>
	<cfelse>
		<cfset this_tax_account_style_ = 0>
	</cfif>
	<cfif get_active_program_parameter.is_avans_off eq 1><!--- avanslar puantaja yansisin veya yansimasin --->
		<cfset is_avans_off_ = 1>
	<cfelse>
		<cfset is_avans_off_ = 0>
	</cfif>
	<cfquery name="get_days" datasource="#dsn#">
		SELECT 
			ISNULL(SUM(EPR.TOTAL_DAYS),0) AS KUMULATIF_DAYS 
		FROM 
			EMPLOYEES_PUANTAJ_ROWS EPR INNER JOIN EMPLOYEES_PUANTAJ EP 
			ON EPR.PUANTAJ_ID = EP.PUANTAJ_ID 
		WHERE 
			EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#employee_id#"> AND 
			SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year#"> AND 
			SAL_MON = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon#">
	</cfquery>

	<cfif get_hr_ssk.USE_SSK eq 2>
		<cfinclude template="/V16/hr/ehesap/cfc/payroll_job.cfc">
		<!--- Memur Bordrosu ise --->
		<cfset get_salary_info = get_payroll_job.get_salary_history(start_month: last_month_1,in_out_id : attributes.in_out_id)>
		<cfif (evaluate("get_salary_info.M#month(last_month_1)#") eq 0 or not len(evaluate("get_salary_info.M#month(last_month_1)#"))) and get_hr_ssk.administrative_academic eq 2>
			<cfset a= getLang('','isimli çalışan için','64483')>
			<cfset b= getLang('','ayın Maaş, SSK, Para Kuru bilgilerinden bir veya birkaçı Eksik','64484')>
			<cfset response = "#get_hr_ssk.employee_name# #get_hr_ssk.employee_surname# #a# #attributes.sal_mon#. #b# !">
			<cfset this.returnResult( status: false, fileid: attributes.in_out_id, errorMessage: response, in_out_id:attributes.in_out_id ) />
			<cfabort>
		<cfelse>
			<cfscript>
				officer_payroll();
			</cfscript>
		</cfif>
	</cfif>

	<cfinclude template="get_hr_compass.cfm">
	<cfif isdefined("ssk_matrah_kullanilan") and ssk_matrah_kullanilan gt 0>
		<cfset devir_kalan_tutar = ssk_matrah_kullanilan>
		<cfquery name="get_onceki_ay" dbtype="query">
			SELECT 
				* 
			FROM 
				get_devir_mahrah 
			WHERE 
				<cfif attributes.sal_mon gt 2>
					(
					SAL_YEAR = #attributes.sal_year# AND
					SAL_MON = #attributes.sal_mon - 2#
					)
					<cfelseif attributes.sal_mon eq 1>
					(
					SAL_YEAR = #attributes.sal_year-1# AND
					SAL_MON = 11
					)
					<cfelseif attributes.sal_mon eq 2>
					(
					(SAL_YEAR = #attributes.sal_year-1# AND SAL_MON = 12)
					)
					</cfif>
				</cfquery>
		<cfif get_onceki_ay.recordcount and get_onceki_ay.amount gt get_onceki_ay.amount_used>
			<cfset onceki_aydan_gelen = get_onceki_ay.amount - get_onceki_ay.amount_used>
			<cfif onceki_aydan_gelen gte devir_kalan_tutar>
				<cfset onceki_aydan_dusulecek = devir_kalan_tutar>
				<cfset devir_kalan_tutar = 0>
				<cfquery name="upd_" datasource="#dsn#">
					UPDATE #add_puantaj_table# SET AMOUNT_USED = #get_onceki_ay.amount_used + onceki_aydan_dusulecek# WHERE ROW_ID = #get_onceki_ay.row_id#
				</cfquery>
			<cfelse>
				<cfset devir_kalan_tutar = devir_kalan_tutar - onceki_aydan_gelen>
				<cfset onceki_aydan_dusulecek = onceki_aydan_gelen>
				<cfquery name="upd_" datasource="#dsn#">
					UPDATE #add_puantaj_table# SET AMOUNT_USED = #get_onceki_ay.amount# WHERE ROW_ID = #get_onceki_ay.row_id#
				</cfquery>
			</cfif>
		</cfif>
		<cfif devir_kalan_tutar gt 0>
			<cfquery name="get_gecen_ay" dbtype="query">
				SELECT 
					* 
				FROM 
					get_devir_mahrah
				WHERE 
					<cfif attributes.sal_mon gt 2>
					(
					SAL_YEAR = #attributes.sal_year# AND
					SAL_MON = #attributes.sal_mon - 1# 
					)
					<cfelseif attributes.sal_mon eq 1>
					(
					SAL_YEAR = #attributes.sal_year-1# AND
					SAL_MON = 12
					)
					<cfelseif attributes.sal_mon eq 2>
					SAL_YEAR = #attributes.sal_year# AND 
					SAL_MON = 1		
					</cfif>
			</cfquery>
			<cfif get_gecen_ay.recordcount and get_gecen_ay.amount gt get_gecen_ay.amount_used>
				<cfset gecen_aydan_gelen = get_gecen_ay.amount - get_gecen_ay.amount_used>
				<cfif gecen_aydan_gelen gte devir_kalan_tutar>
					<cfset gecen_aydan_dusulecek = devir_kalan_tutar>
					<cfset devir_kalan_tutar = 0>
					<cfquery name="upd_" datasource="#dsn#">
						UPDATE #add_puantaj_table# SET AMOUNT_USED = #get_gecen_ay.amount_used + gecen_aydan_dusulecek# WHERE ROW_ID = #get_gecen_ay.row_id#
					</cfquery>
				<cfelse>
					<cfset devir_kalan_tutar = devir_kalan_tutar - gecen_aydan_gelen>
					<cfset gecen_aydan_dusulecek = gecen_aydan_gelen>
					<cfquery name="upd_" datasource="#dsn#">
						UPDATE #add_puantaj_table# SET AMOUNT_USED = #get_gecen_ay.amount# WHERE ROW_ID = #get_gecen_ay.row_id#
					</cfquery>
				</cfif>
			</cfif>
		</cfif>
	</cfif>
	<cfif attributes.action_type is "pusula_görüntüleme">
		<cfset attributes.comp_id = get_hr_ssk.company_id>
		<cfinclude template="get_our_comp_name.cfm">
		<cfsavecontent variable="icerik_mevcut_durum"><cfinclude template="../display/view_price_compass_2.cfm"></cfsavecontent>
		<table cellpadding="0" cellspacing="0" style="width:210mm;height:284.9mm;;" align="center" border="0">
			<tr>
				<td height="5">&nbsp;</td>
			</tr>
			<tr>
				<td valign="top"><cfoutput>#icerik_mevcut_durum#</cfoutput></td>
			</tr>
			<tr>
				<td valign="top"><cfoutput>#icerik_mevcut_durum#</cfoutput></td>
			</tr>
		</table>
	<cfelse>
		<cfinclude template="add_personal_puantaj_2.cfm">
	</cfif>
</cfloop>
<cfset attributes.in_out_id = "">
