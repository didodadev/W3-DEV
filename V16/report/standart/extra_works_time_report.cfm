<cf_xml_page_edit fuseact='report.extra_works_time_report'>
<cfset cmp_org_step = createObject("component","V16.hr.cfc.get_organization_steps")>
<cfset cmp_org_step.dsn = dsn>
<cfparam name="attributes.module_id_control" default="3,48">
<cfinclude template="report_authority_control.cfm">
<cfparam name="attributes.comp_id" default="">
<cfparam name="attributes.branch_place" default="">
<cfparam name="attributes.expense_center_code" default="">
<cfparam name="attributes.department_id" default="">
<cfparam name="attributes.department_name" default="">
<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.up_department" default="">
<cfparam name="attributes.is_excel" default="">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.page" default="1">
<cfif isdefined('attributes.start_date') and len(attributes.start_date) and attributes.page eq 1>
	<cf_date tarih = "attributes.start_date">
<cfelse>
	<cfif session.ep.our_company_info.UNCONDITIONAL_LIST>
		<cfset attributes.start_date=''>
	<cfelse>
		<cfset attributes.start_date = date_add('d',-7,createodbcdatetime('#session.ep.period_year#-#month(now())#-#day(now())#'))>
	</cfif>
</cfif>
<cfif isdefined('attributes.finish_date') and len(attributes.finish_date) and attributes.page eq 1>
	<cf_date tarih = "attributes.finish_date">
<cfelse>
	<cfif session.ep.our_company_info.UNCONDITIONAL_LIST>
		<cfset attributes.finish_date=''>
	<cfelse>
		<cfset attributes.finish_date = date_add('d',7,attributes.start_date)>
	</cfif>
</cfif>
<cfquery name="get_our_company" datasource="#dsn#">
	SELECT 
		COMP_ID,
		COMPANY_NAME
	FROM
		OUR_COMPANY
	<cfif not session.ep.ehesap>
		WHERE
			COMP_ID IN (SELECT DISTINCT B.COMPANY_ID FROM EMPLOYEE_POSITION_BRANCHES EBR LEFT JOIN BRANCH B ON B.BRANCH_ID = EBR.BRANCH_ID WHERE EBR.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
	</cfif>
	ORDER BY
		COMPANY_NAME
</cfquery>
<cfquery name="get_branches" datasource="#dsn#">
	SELECT BRANCH_NAME,BRANCH_ID FROM BRANCH,OUR_COMPANY WHERE
		<cfif isdefined('attributes.comp_id') and len(attributes.comp_id)>
            OUR_COMPANY.COMP_ID=BRANCH.COMPANY_ID AND COMPANY_ID IN(#attributes.comp_id#) 
            <cfif not session.ep.ehesap>
                AND BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = #session.ep.position_code#)
            </cfif>
        <cfelse>
            1=0
        </cfif>
	    ORDER BY BRANCH_NAME
</cfquery>
<cfquery name="get_departments" datasource="#dsn#">
	SELECT D.DEPARTMENT_HEAD,D.DEPARTMENT_ID FROM DEPARTMENT D,BRANCH B WHERE 
	<cfif isdefined("attributes.branch_place") and len(attributes.branch_place)>D.BRANCH_ID=B.BRANCH_ID AND D.BRANCH_ID IN(#attributes.branch_place#)<cfelse>1=0</cfif>
</cfquery>
<cfif fusebox.use_period eq true>
    <cfset dsn_ei = dsn2>
<cfelse>
    <cfset dsn_ei = dsn>
</cfif>
<cfquery name="get_expense_center" datasource="#dsn_ei#">
	SELECT EXPENSE_ID,EXPENSE_CODE,EXPENSE FROM EXPENSE_CENTER ORDER BY EXPENSE_CODE
</cfquery>
 <cfif isdefined('attributes.form_submitted')>
<cfquery name="get_employees" datasource="#dsn#">
	SELECT 
		EIO.SALARY_TYPE,
		OC.COMPANY_NAME,
		OC.COMP_ID,
		E.EMPLOYEE_ID,
		EIO.IN_OUT_ID,
		EIO.GROSS_NET,
		E.EMPLOYEE_NAME,
		E.EMPLOYEE_SURNAME ,
		D.DEPARTMENT_HEAD ,
		D.HIERARCHY,
		EEW.START_TIME,
		EEW.WORK_START_TIME,
		EEW.WORK_END_TIME,
		EEW.END_TIME,
		EEW.DAY_TYPE,
		B.BRANCH_NAME,
		B.POSITION_NAME,
		ST.TITLE,
		SPC.POSITION_CAT,
		EI.TC_IDENTY_NO,
		EEW.RECORD_DATE,
		ES.MONEY,
		D.HIERARCHY_DEP_ID AS HIERARCHY_DEP_ID1,
		(SELECT TOP 1 EIOP1.EXPENSE_CODE FROM EMPLOYEES_IN_OUT_PERIOD EIOP1 WHERE EIOP1.PERIOD_YEAR = YEAR(EEW.RECORD_DATE) AND EIOP1.PERIOD_COMPANY_ID = B.COMPANY_ID AND EIOP1.IN_OUT_ID = EIO.IN_OUT_ID) AS EXPENSE_CODE,
		ES.*,
		EIO.BRANCH_ID,
		EIO.PUANTAJ_GROUP_IDS,
		CASE 
			WHEN E.EMPLOYEE_ID IN (SELECT EMPLOYEE_ID FROM EMPLOYEES_IN_OUT WHERE START_DATE <= GETDATE() AND (FINISH_DATE >= GETDATE() OR FINISH_DATE IS NULL))
		THEN	
			D.HIERARCHY_DEP_ID
		ELSE 
			CASE WHEN 
				D.DEPARTMENT_ID IN (SELECT DEPARTMENT_ID FROM DEPARTMENT_HISTORY WHERE CHANGE_DATE IS NOT NULL AND CONVERT(DATE,CHANGE_DATE) <= (SELECT CONVERT(DATE,MAX(FINISH_DATE)) FROM EMPLOYEES_IN_OUT WHERE EMPLOYEE_ID = E.EMPLOYEE_ID))
			THEN
				(SELECT TOP 1 HIERARCHY_DEP_ID FROM DEPARTMENT_HISTORY WHERE DEPARTMENT_ID = D.DEPARTMENT_ID AND CONVERT(DATE,CHANGE_DATE) <= (SELECT CONVERT(DATE,MAX(FINISH_DATE)) FROM EMPLOYEES_IN_OUT WHERE EMPLOYEE_ID = E.EMPLOYEE_ID) ORDER BY CHANGE_DATE DESC, DEPT_HIST_ID DESC)
			ELSE
				D.HIERARCHY_DEP_ID
			END
		END AS HIERARCHY_DEP_ID
	FROM
		EMPLOYEES E,
		EMPLOYEES_IN_OUT EIO,
		EMPLOYEES_EXT_WORKTIMES EEW,
		DEPARTMENT D,
		BRANCH B,
		OUR_COMPANY OC,
		EMPLOYEE_POSITIONS EP,
		SETUP_TITLE ST,
		SETUP_POSITION_CAT SPC,
		EMPLOYEES_SALARY ES,
		 EMPLOYEES_IDENTY EI 
		
	WHERE
		E.EMPLOYEE_ID = EIO.EMPLOYEE_ID AND
		E.EMPLOYEE_ID = EEW.EMPLOYEE_ID AND
		D.DEPARTMENT_ID = EIO.DEPARTMENT_ID AND
		EIO.BRANCH_ID=B.BRANCH_ID AND
		B.COMPANY_ID=OC.COMP_ID AND
		E.EMPLOYEE_ID=EP.EMPLOYEE_ID AND
		EP.IS_MASTER=1 AND
		EI.EMPLOYEE_ID = E.EMPLOYEE_ID and
		EP.TITLE_ID=ST.TITLE_ID AND
		EP.POSITION_CAT_ID=SPC.POSITION_CAT_ID AND
		EIO.IN_OUT_ID=ES.IN_OUT_ID AND
		EIO.IN_OUT_ID=EEW.IN_OUT_ID AND
		YEAR(EEW.START_TIME) = ES.PERIOD_YEAR
    <!--- branch id --->
	<cfif not session.ep.ehesap>
		AND B.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = #session.ep.position_code#)
		AND OC.COMP_ID IN (SELECT DISTINCT BR.COMPANY_ID FROM EMPLOYEE_POSITION_BRANCHES EBR LEFT JOIN BRANCH BR ON BR.BRANCH_ID = EBR.BRANCH_ID WHERE EBR.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
	</cfif>
	<cfif len(attributes.comp_id)>
		AND OC.COMP_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.comp_id#" list = "yes">)
	</cfif>
	<cfif len(attributes.branch_place)>
	 	AND	B.BRANCH_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_place#" list = "yes">)
	</cfif>
	<cfif isdefined('attributes.expense_center_code') and len(attributes.expense_center_code)>
		AND	EIO.IN_OUT_ID IN (SELECT EIOP.IN_OUT_ID FROM EMPLOYEES_IN_OUT_PERIOD EIOP WHERE EIOP.PERIOD_YEAR = YEAR(EEW.RECORD_DATE) AND EIOP.PERIOD_COMPANY_ID = B.COMPANY_ID AND EIOP.EXPENSE_CODE IN ('#Replace(attributes.expense_center_code,",","','",'all')#'))
	</cfif>
	<cfif isdefined('attributes.employee_name') and isdefined('attributes.employee_id')and len(attributes.employee_name) and len(attributes.employee_id)>
		AND E.EMPLOYEE_ID = #attributes.employee_id#
	</cfif>
	<cfif isdefined('attributes.start_date') and len(attributes.start_date)>
		AND EEW.WORK_START_TIME >= #attributes.start_date#
	</cfif>
	<cfif isdefined('attributes.finish_date') and len(attributes.finish_date)>
		AND EEW.WORK_END_TIME <= #attributes.finish_date#
	</cfif>
	<cfif isdefined('attributes.up_department') and len(attributes.up_department)>
		AND D.HIERARCHY='#attributes.up_department#'
	</cfif>
	<cfif isdefined('attributes.department_id') and len(attributes.department_id)>
		AND D.DEPARTMENT_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department_id#" list = "yes">)
	</cfif> 
	ORDER BY 
		E.EMPLOYEE_NAME,
		E.EMPLOYEE_SURNAME
		<!--- ORDER BY EEW.RECORD_DATE --->
</cfquery>
	<cfelse>
		<cfset get_employees.recordcount=0>
  </cfif>
<cfparam name="attributes.totalrecords" default="#get_employees.recordCount#">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<cfquery name="get_our_company_hours" datasource="#dsn#">
	SELECT SSK_MONTHLY_WORK_HOURS,DAILY_WORK_HOURS FROM OUR_COMPANY_HOURS WHERE OUR_COMPANY_ID = #session.ep.company_id#
</cfquery>
<cfsavecontent variable="head"><cf_get_lang dictionary_id='39923.Fazla Çalışma Saat Raporu' ></cfsavecontent>
<cfform name="extra_works" method="post" action="#request.self#?fuseaction=report.extra_works_time_report">
	<cf_report_list_search title="#head#">
        <cf_report_list_search_area>
			<div class="row">
				<div class="col col-12 col-xs-12">
                    <div class="row formContent">
						<div class="row" type="row">
							<div class="col col-4 col-md-4 col-sm-6 col-xs-12">
								<div class="col col-12 col-md-12 col-xs-12">
									<div class="col col-12 col-md-12 col-xs-12">
										<div class="form-group">
											<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='29531.Şirketler'></label>
											<div class="col col-12">
												<div class="multiselect-z2">
													<cf_multiselect_check 
													query_name="get_our_company"  
													name="comp_id"
													option_value="COMP_ID"
													option_name="company_name"
													option_text="#getLang('main',322)#"
													value="#attributes.comp_id#"
													onchange="get_branch_list(this.value)">
												</div>
											</div>
										</div>
										<div class="form-group">
											<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='29434.Şubeler'></label>
											<div class="col col-12">
												<div id="BRANCH_PLACE" class="multiselect-z2">
													<cf_multiselect_check 
													query_name="get_branches"  
													name="branch_id"
													option_value="BRANCH_ID"
													option_name="BRANCH_NAME"
													option_text="#getLang('main',322)#"
													value="#attributes.branch_id#"
													onchange="get_department_list(this.value)">
												</div>
											</div>
										</div>
										<div class="form-group">
											<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id ='40141.Departmanlar'></label>
											<div class="col col-12">
												<div class="multiselect-z2" id="DEPARTMENT_PLACE">
													<cf_multiselect_check 
													query_name="get_departments"  
													name="department"
													option_text="#getLang('main',322)#" 
													option_value="department_id"
													option_name="department_head"
													value="#iif(isdefined("attributes.department"),"attributes.department",DE(""))#">
												</div>
											</div>
										</div>
									</div>
								</div>
							</div>
							<div class="col col-4 col-md-4 col-sm-6 col-xs-12">
								<div class="col col-12 col-md-12 col-xs-12">
									<div class="col col-12 col-md-12 col-xs-12">
										<div class="form-group">
											<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='58460.Masraf Merkezi'></label>
											<div class="col col-12">
												<div  class="multiselect-z2">
													<cf_multiselect_check 
													query_name="get_expense_center"  
													name="expense_center_code"
													option_value="EXPENSE_CODE"
													option_name="expense"
													option_text="#getLang('main',322)#"
													value="#attributes.expense_center_code#">
												</div>
											</div>	
										</div>
									</div>
								</div>
							</div>
							<div class="col col-4 col-md-4 col-sm-6 col-xs-12">
								<div class="col col-12 col-md-12 col-xs-12">
									<div class="col col-12 col-md-12 col-xs-12">
										<div class="form-group">
											<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57576.Çalışan'></label>
											<div class="col col-12">
												<div class="input-group">
													<input type="hidden" name="employee_id" id="employee_id" value="<cfif isdefined('attributes.employee_id') and len(attributes.employee_id) and isdefined('attributes.employee_name') and len(attributes.employee_name)><cfoutput>#attributes.employee_id#</cfoutput></cfif>">
													<input type="text" name="employee_name" id="employee_name" style="width:158px;" value="<cfif isdefined('attributes.employee_name') and len(attributes.employee_name) and isdefined('attributes.employee_id') and len(attributes.employee_id)><cfoutput>#attributes.employee_name#</cfoutput></cfif>">
													<span class="input-group-addon btnPointer icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_list_emps&field_id=extra_works.employee_id&field_name=extra_works.employee_name&conf_=1','list');return false"></span>
												</div>
											</div>	
										</div>
										<div class="form-group">
											<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='58690.Tarih Aralığı'></label>
											<div class="col col-6">
												<div class="input-group">
													<cfsavecontent variable="message"><cf_get_lang dictionary_id ='57782.Tarih Değerini Kontrol Ediniz'>!></cfsavecontent>
													<cfinput type="text" name="start_date" value="#DateFormat(attributes.start_date,dateformat_style)#" validate="#validate_style#" maxlength="10" style="width:65px;">
													<span class="input-group-addon">
														<cf_wrk_date_image date_field="start_date">
													</span>
												</div>
											</div>
											<div class="col col-6">
												<div class="input-group">
													<cfsavecontent variable="message"><cf_get_lang dictionary_id ='57782.Tarih Değerini Kontrol Ediniz'>!></cfsavecontent>
													<cfinput type="text" name="finish_date" value="#DateFormat(attributes.finish_date,dateformat_style)#" validate="#validate_style#" maxlength="10" style="width:65px;">
													<span class="input-group-addon">
														<cf_wrk_date_image date_field="finish_date">
													</span>
												</div>
											</div>	
										</div>
										<div class="form-group">
											<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id ='39710.Üst Departman'></label>
											<div class="col col-12">
												<div class="input-group">
													<input type="hidden" name="up_department_id" id="up_department_id" value="">
													<input type="text" name="up_department" id="up_department" value="<cfif len(attributes.up_department)><cfoutput>#attributes.up_department#</cfoutput></cfif>" style="width:155px;">
													<span class="input-group-addon btnPointer icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_departments&field_id=extra_works.up_department_id&field_name=extra_works.up_department&is_all_departments</cfoutput>','list');"></span>
												</div>
											</div>	
										</div>
									</div>
								</div>
							</div>
						</div>	
					</div>
					<div class="row ReportContentBorder">
						<div class="ReportContentFooter">
							<label><input type="checkbox" name="is_excel" id="is_excel" value="1" <cfif attributes.is_excel eq 1>checked</cfif>><cf_get_lang dictionary_id='57858.Excel Getir'></label>
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
							<cfif session.ep.our_company_info.is_maxrows_control_off eq 1>
								<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" message="#message#" maxlength="3" style="width:25px;">
							<cfelse>
								<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,250" message="#message#" maxlength="3" style="width:25px;">
							</cfif>
							<input type="hidden" name="form_submitted" id="form_submitted" value="1"/>
							<cf_wrk_report_search_button button_type="1" is_excel="1" search_function="control()">
						</div>
					</div>	
				</div>
			</div>		
		</cf_report_list_search_area>
    </cf_report_list_search>    
</cfform>
<cfif attributes.is_excel eq 1>
		<cfset type_ = 1>
		<cfset filename = "#createuuid()#">
		<cfheader name="Expires" value="#Now()#">
		<cfcontent type="application/vnd.msexcel;charset=utf-8">
		<cfheader name="Content-Disposition" value="attachment; filename=#filename#.xls">
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	<cfelse>
		<cfset type_ = 0>
</cfif>
<cfif isdefined("attributes.form_submitted")>
	<cf_report_list>
		<cfset ara_toplam=0>
		<cfset normal_toplam=0>
		<cfset haftasonu_toplam=0>
		<cfset resmitatil_toplam=0>
		<cfset toplam_ucret=0>
			<thead>
				<tr>
					<th><cf_get_lang dictionary_id ='58577.Sıra'></th>
					<th><cf_get_lang dictionary_id ='57576.Çalışan'></th>
					<th><cf_get_lang dictionary_id ='57571.Ünvan'></th>
					<th><cf_get_lang dictionary_id='57574.Şirket'></th>
					<th><cf_get_lang dictionary_id='57453.Şube'></th>
					<th><cf_get_lang dictionary_id='58025.TC Kimlik No'></th>
					<th><cf_get_lang dictionary_id ='58497.Pozisyon'></th>
					<th><cf_get_lang dictionary_id ='57572.Departman'></th>
					<th><cf_get_lang dictionary_id ='39710.Üst Departman'></th>
					<th><cf_get_lang dictionary_id ='40142.Masraf Merkez Kodu'></th>
					<th><cf_get_lang dictionary_id ='29472.Yöntem'></th>
					<th><cf_get_lang dictionary_id ='40071.Maaş'></th>
					<th>&nbsp;&nbsp;&nbsp;</th>
					<th><cf_get_lang dictionary_id ='58651.Türü'></th>
					<th><cf_get_lang dictionary_id ='58865.Çarpan'></th>
					<th><cf_get_lang dictionary_id='61647.Bordro Aktarım Tarihi'></th>
					<th><cf_get_lang dictionary_id='61649.Çalışma Günü Tarihi'></th>
					<th><cf_get_lang dictionary_id ='57501.Başlangıç'></th>
					<th><cf_get_lang dictionary_id ='57502.Bitiş'></th>
					<th><cf_get_lang dictionary_id ='58827.dk'></th>
					<th><cf_get_lang dictionary_id ='57491.Saat'></th>
					<th><cf_get_lang dictionary_id ='40144.S Ücret'></th>
					<th><cf_get_lang dictionary_id ='40145.T Ücret'></th>
					<cfif isDefined("x_show_level") and x_show_level eq 1><th><cf_get_lang dictionary_id='62040.Kademeli Departman'></th></cfif>
				</tr>
			</thead>
			<tbody>
				<cfif get_employees.recordcount>
					<cfoutput query="get_employees" maxrows="#attributes.maxrows#" startrow="#attributes.startrow#">
					<cfset maas_ = evaluate('M#month(RECORD_DATE)#')>
					
					<tr>
						<td>#currentrow#</td>
						
						<cfif attributes.is_excel eq 1>
						<td>#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#</td>	
							<cfelse>
								<td><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#employee_id#','medium');" class="tableyazi">#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#</a></td>
							</cfif>
						<td>#TITLE#</td>
						<td>#company_name#</td>
						<td>#BRANCH_NAME#</td>
						<td>#TC_IDENTY_NO#</td>
						<td>#POSITION_CAT#</td>
						<td>#DEPARTMENT_HEAD#</td>
						<td>#HIERARCHY#</td>
						<td>#EXPENSE_CODE#</td>
						<td>
							<cfif len(SALARY_TYPE)>
								<cfswitch expression = "#SALARY_TYPE#">
									<cfcase value="0"><cf_get_lang dictionary_id ='57491.Saat'></cfcase>
									<cfcase value="1"><cf_get_lang dictionary_id ='57490.Gün'></cfcase>
									<cfcase value="2"><cf_get_lang dictionary_id ='58724.Ay'></cfcase>
								</cfswitch>	
							</cfif>
						</td>
						<td><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#TLFormat(maas_)#"></td>
						<td>
							<cfif GROSS_NET eq True>
								<cf_get_lang dictionary_id ='58083.Net'>
							<cfelse>
								<cf_get_lang dictionary_id ='38990.Brüt'>
							</cfif>
						</td>				
						<cfset fark_ = datediff("n",START_TIME,END_TIME)>
						<cfset fark_saat_ = fark_/60>
						<td><cfif DAY_TYPE eq 0><cf_get_lang dictionary_id ='40147.Normal Gün'>	<cfelseif DAY_TYPE eq 1><cf_get_lang dictionary_id ='40148.Hafta Sonu'><cfelseif DAY_TYPE eq 2><cf_get_lang dictionary_id ='40150.Resmi Tatil'></cfif></td>
						<cfif DAY_TYPE eq 0>
							<cfset normal_toplam = normal_toplam + fark_>
						<cfelseif DAY_TYPE eq 1>
							<cfset haftasonu_toplam = haftasonu_toplam + fark_>
						<cfelseif DAY_TYPE eq 2>
							<cfset resmitatil_toplam = resmitatil_toplam + fark_>
						</cfif>
						<td>
							<cfset attributes.sal_mon = MONTH(START_TIME)>
							<cfset attributes.sal_year = YEAR(START_TIME)>
							<cfset attributes.group_id = "">
							<cfif len(get_employees.puantaj_group_ids)>
								<cfset attributes.group_id = "#get_employees.PUANTAJ_GROUP_IDS#,">
							</cfif>
							<cfset attributes.branch_id = get_employees.branch_id>
							<cfset not_kontrol_parameter = 1>
							<cfinclude template="../../hr/ehesap/query/get_program_parameter.cfm">
							<cfset carpan_ = 0>
							<cfif DAY_TYPE eq 0 and len(get_program_parameters.EX_TIME_PERCENT)>
									<cfif fark_ lte get_program_parameters.EX_TIME_LIMIT>
										<cfset carpan_ = get_program_parameters.EX_TIME_PERCENT/100>
									<cfelse>
										<cfset carpan_ = get_program_parameters.EX_TIME_PERCENT_HIGH/100>
									</cfif>
							<cfelseif DAY_TYPE eq 1 and len(get_program_parameters.WEEKEND_MULTIPLIER)><cfset carpan_ = get_program_parameters.WEEKEND_MULTIPLIER>
							<cfelseif DAY_TYPE eq 1 and not len(get_program_parameters.WEEKEND_MULTIPLIER) and len(get_program_parameters.EX_TIME_PERCENT)><cfset carpan_ = get_program_parameters.EX_TIME_PERCENT/100>
							<cfelseif DAY_TYPE eq 2 and len(get_program_parameters.OFFICIAL_MULTIPLIER)><cfset carpan_ = get_program_parameters.OFFICIAL_MULTIPLIER>
							<cfelseif DAY_TYPE eq 2 and not len(get_program_parameters.OFFICIAL_MULTIPLIER)><cfset carpan_ = 1>
							</cfif>
							#carpan_#
						</td>
						<td>#DateFormat(START_TIME,dateformat_style)#</td>
						<td>#DateFormat(WORK_START_TIME,dateformat_style)#</td>
						<td>#TimeFormat(START_TIME,timeformat_style)#</td>
						<td>#TimeFormat(END_TIME,timeformat_style)#</td>
						<td>#fark_# </td>
						<td>#wrk_round(fark_saat_)#</td>
							<!---  aylık günlük hesaplamalarına dikkat ederek göz ardı etmeden hesaplasın --->
							<cfif get_employees.SALARY_TYPE eq 1>
								<cfset birimucret=maas_/get_our_company_hours.DAILY_WORK_HOURS>
							<cfelseif get_employees.SALARY_TYPE eq 2>
								<cfset birimucret = maas_ / get_our_company_hours.SSK_MONTHLY_WORK_HOURS>
							<cfelseif get_employees.SALARY_TYPE eq 0>
								<cfset birimucret = maas_>
							</cfif>
							<!---<cfset birimucret = maas_ / get_our_company_hours.SSK_MONTHLY_WORK_HOURS>--->
							<cfset tahmini_ucret_ = birimucret * fark_saat_ * carpan_>
							<cfset toplam_ucret = toplam_ucret + tahmini_ucret_>
						<td><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#TLFormat(birimucret)#"></td>
						<td><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#TLFormat(tahmini_ucret_)#"></td>
						<cfset ara_toplam = ara_toplam + fark_>
						<cfif isDefined("x_show_level") and x_show_level eq 1>
								<td>                            
									<cfset up_dep_len = listlen(HIERARCHY_DEP_ID1,'.')>
									<cfif up_dep_len gt 0>
										<cfset temp = up_dep_len> 
										<cfloop from="1" to="#up_dep_len#" index="i" step="1">
											<cfif isdefined("HIERARCHY_DEP_ID1") and listlen(HIERARCHY_DEP_ID1,'.') gt temp>
												<cfset up_dep_id = ListGetAt(HIERARCHY_DEP_ID1, listlen(HIERARCHY_DEP_ID1,'.')-temp,".")>
												<cfquery name="get_upper_departments" datasource="#dsn#">
													SELECT DEPARTMENT_HEAD, LEVEL_NO FROM DEPARTMENT WHERE DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#up_dep_id#">
												</cfquery>
												<cfset up_dep_head = get_upper_departments.department_head>
												#up_dep_head# 
													<cfset get_org_level = cmp_org_step.get_organization_step(level_no : get_upper_departments.LEVEL_NO)>
													<cfif get_org_level.recordcount>
														(#get_org_level.ORGANIZATION_STEP_NAME#)
													</cfif>
												<cfif up_dep_len neq i>
													>
												</cfif>
											<cfelse>
												<cfset up_dep_head = ''>
											</cfif>
											<cfset temp = temp - 1>
										</cfloop>
									</cfif>
								</td>
							</cfif>
					</tr>
					<cfif (currentrow neq get_employees.recordcount and employee_id neq employee_id[currentrow+1]) or currentrow eq get_employees.recordcount>
						<tr height="25" class="total">
							<td colspan="2" style="text-align:right;" class="txtbold"><cf_get_lang dictionary_id ='57492.Toplam'></td>
							<td colspan="16" style="text-align:right;" class="txtbold"><cf_get_lang dictionary_id ='40153.Normal Gün Toplam '>: #normal_toplam#(#wrk_round(normal_toplam/60)#)
							<cf_get_lang dictionary_id ='40155.Hafta Sonu Toplam'> : #haftasonu_toplam#(#wrk_round(haftasonu_toplam/60)#)
							<cf_get_lang dictionary_id ='40157.Resmi Tatil Toplam'> : #resmitatil_toplam#(#wrk_round(resmitatil_toplam/60)#)
							<cf_get_lang dictionary_id ="40145.Toplam Ücret"> : <cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#TLFormat(toplam_ucret)#">
							<cfset ara_toplam = 0>
							<cfset normal_toplam=0>
							<cfset haftasonu_toplam=0>
							<cfset resmitatil_toplam=0>
							<cfset toplam_ucret=0>
							</td>
						</tr>
					</cfif>
			</tbody>
			</cfoutput>
		<cfelse>
			<tbody>
				<tr>
					<!-- sil --><td colspan="18"><cfif isdefined('attributes.form_submitted')><cf_get_lang dictionary_id='57484.Kayıt Yok'>!<cfelse><cf_get_lang dictionary_id ='57701.Filtre Ediniz'>!</cfif></td><!-- sil -->
				</tr>
			</tbody>
		</cfif>
	</cf_report_list>

	<cfif attributes.totalrecords gt attributes.maxrows>
		<cfset adres=''>
		<cfif isDefined('attributes.comp_id') and len(attributes.comp_id)>
			<cfset adres = adres&"&comp_id="&attributes.comp_id>
		</cfif>
		<cfif isDefined('attributes.expense_center_code') and len(attributes.expense_center_code)>
			<cfset adres = adres&"&expense_center_code="&attributes.expense_center_code>
		</cfif>
		<cfif isDefined('attributes.employee_name') and len(attributes.employee_name)>
			<cfset adres = adres&"&employee_name="&attributes.employee_name>
		</cfif>
		<cfif isDefined('attributes.BRANCH_PLACE') and len(attributes.BRANCH_PLACE)>
			<cfset adres = adres&"&BRANCH_PLACE="&attributes.BRANCH_PLACE>
		</cfif>	
		<cfif isDefined('attributes.start_date') and len(attributes.start_date)>
			<cfset adres = adres&"&start_date="&attributes.start_date>
		</cfif>
		<cfif isDefined('attributes.finish_date') and len(attributes.finish_date)>
			<cfset adres = adres&"&finish_date="&attributes.finish_date>
		</cfif>
		<cfif isDefined('attributes.department_id') and len(attributes.department_id)>
			<cfset adres = adres & "&department_id="&attributes.department_id>
		</cfif>
		<cfif isDefined('attributes.up_department') and len(attributes.up_department)>
			<cfset adres = adres & "&up_department="&attributes.up_department>
		</cfif>
		<cfif isDefined('attributes.form_submitted') and len(attributes.form_submitted)>
			<cfset adres = adres & "&form_submitted="&attributes.form_submitted>
		</cfif>
					<cf_paging
					page="#attributes.page#"
					maxrows="#attributes.maxrows#"
					totalrecords="#attributes.totalrecords#"
					startrow="#attributes.startrow#"
					adres="report.extra_works_time_report#adres#">
		<br/>
	</cfif>
</cfif>
<script type="text/javascript">

function get_branch_list(gelen)
	{
		checkedValues_b = $("#comp_id").multiselect("getChecked");
		var comp_id_list='';
		for(kk=0;kk<checkedValues_b.length; kk++)
		{
			if(comp_id_list == '')
				comp_id_list = checkedValues_b[kk].value;
			else
				comp_id_list = comp_id_list + ',' + checkedValues_b[kk].value;
		}
		var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_ajax_list_hr&is_multiselect=1&name=branch_id&comp_id="+comp_id_list;
		AjaxPageLoad(send_address,'BRANCH_PLACE',1,'İlişkili Şubeler');
	}
	function get_department_list(gelen)
	{
		checkedValues_b = $("#branch_id").multiselect("getChecked");
		var branch_id_list='';
		for(kk=0;kk<checkedValues_b.length; kk++)
		{
			if(branch_id_list == '')
				branch_id_list = checkedValues_b[kk].value;
			else
				branch_id_list = branch_id_list + ',' + checkedValues_b[kk].value;
		}
		var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_ajax_list_hr&is_multiselect=1&name=department&branch_id="+branch_id_list;
		AjaxPageLoad(send_address,'DEPARTMENT_PLACE',1,'İlişkili Departmanlar');
	}

 function control()	{
	 	if(!date_check(extra_works.start_date,extra_works.finish_date,"<cf_get_lang dictionary_id ='40310.Başlama Tarihi Bitiş Tarihinden Küçük Olmalıdır'>!")){
			return false;
		}
		
		
            if(document.extra_works.is_excel.checked==false)
            {
                document.extra_works.action="<cfoutput>#request.self#?fuseaction=#attributes.fuseaction#</cfoutput>"
                return true;
            }
            else
                document.extra_works.action="<cfoutput>#request.self#?fuseaction=#fusebox.circuit#.emptypopup_extra_works_time_report</cfoutput>"
            		}
</script>
