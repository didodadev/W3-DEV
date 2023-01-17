<cfparam name="attributes.module_id_control" default="3,48">
<cfinclude template="report_authority_control.cfm">
<cfparam name="attributes.is_excel" default="0">
<cfparam name="attributes.in_date1" default="">
<cfparam name="attributes.in_date2" default="">
<cfparam name="attributes.salary_year" default="#session.ep.period_year#">
<cfparam name="attributes.salary_month" default="#dateformat(now(),'m')#">

<cfif isdefined("attributes.is_submit")>
<cfquery name="GET_UCRET" datasource="#dsn#">
	SELECT
		<cfif isdefined('attributes.show_salary_change')>
		ESH.RECORD_EMP AS CHANGE_EMP,
		ESH.RECORD_DATE AS CHANGE_DATE,
		ESH.PERIOD_YEAR,
		ESH.M1,
		ESH.M2,
		ESH.M3,
		ESH.M4,
		ESH.M5,
		ESH.M6,
		ESH.M7,
		ESH.M8,
		ESH.M9,
		ESH.M10,
		ESH.M11,
		ESH.M12,
		ESHE.EMPLOYEE_NAME AS CHANGE_EMPNAME,
		ESHE.EMPLOYEE_SURNAME AS CHANGE_EMPSURNAME,
		ES.M#MONTH(NOW())# AS SON_UCRET,
		</cfif>
		EPR.GELIR_VERGISI,
		EPR.GELIR_VERGISI_MATRAH,
		EIO.*,
		EIO.START_DATE AS STARTDATE,
		EIO.FINISH_DATE,
		EI.TC_IDENTY_NO,
		E.EMPLOYEE_NAME,
		E.EMPLOYEE_SURNAME,
		E.EMPLOYEE_ID,
		B.BRANCH_NAME,
		ED.SHIFT_ID
		<cfif isdefined('attributes.odkes_id') and len(attributes.odkes_id)>
		,SP.COMMENT_PAY
		,SP.AMOUNT_PAY
		,SP.FROM_SALARY AS ODENEK_SALARY
		</cfif>
		<cfif isdefined('attributes.odkes_id2') and len(attributes.odkes_id2)>
		,SG.METHOD_GET
		,SG.COMMENT_GET
		,SG.AMOUNT_GET
		,SG.FROM_SALARY
		</cfif>
		<cfif isdefined('attributes.tax_exception_id') and len(attributes.tax_exception_id)>
		,ET.TAX_EXCEPTION
		,ET.AMOUNT
		</cfif>
	FROM
		EMPLOYEES_PUANTAJ_ROWS EPR,
		EMPLOYEES_PUANTAJ EP,
		EMPLOYEES_IN_OUT EIO,
		EMPLOYEES_IDENTY EI,
		EMPLOYEES E,
		EMPLOYEES_DETAIL ED,
		BRANCH B
		<cfif isdefined('attributes.odkes_id') and len(attributes.odkes_id)>,SALARYPARAM_PAY SP</cfif>
		<cfif isdefined('attributes.odkes_id2') and len(attributes.odkes_id2)>,SALARYPARAM_GET SG</cfif>
		<cfif isdefined('attributes.tax_exception_id') and len(attributes.tax_exception_id)>,SALARYPARAM_EXCEPT_TAX ET</cfif>
		<cfif isdefined('attributes.show_salary_change')>
			,EMPLOYEES_SALARY ES
			,EMPLOYEES_SALARY_HISTORY ESH
			,EMPLOYEES ESHE
		</cfif>
 	WHERE
		EP.SAL_MON = #attributes.salary_month# AND
		EP.SAL_YEAR = #attributes.salary_year# AND
		EPR.PUANTAJ_ID = EP.PUANTAJ_ID AND
		E.EMPLOYEE_ID = EPR.EMPLOYEE_ID AND
		EIO.EMPLOYEE_ID = EI.EMPLOYEE_ID AND
		EIO.EMPLOYEE_ID = E.EMPLOYEE_ID AND
		E.EMPLOYEE_ID = ED.EMPLOYEE_ID AND
		<cfif isdefined('attributes.show_salary_change')>
		EIO.IN_OUT_ID = ESH.IN_OUT_ID AND
		EIO.IN_OUT_ID = ES.IN_OUT_ID AND
		ESH.RECORD_EMP = ESHE.EMPLOYEE_ID AND
		</cfif>
		<cfif not session.ep.ehesap>EIO.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#) AND</cfif>
		EIO.BRANCH_ID = B.BRANCH_ID
		AND
		(
			(
			EIO.START_DATE <= #createdatetime(attributes.salary_year,attributes.salary_month,1,0,0,0)# AND
			EIO.FINISH_DATE >= #createdatetime(attributes.salary_year,attributes.salary_month,daysinmonth(createdate(attributes.salary_year,attributes.salary_month,1)),0,0,0)#
			)
			OR
			(
			EIO.START_DATE <= #createdatetime(attributes.salary_year,attributes.salary_month,1,0,0,0)# AND
			EIO.FINISH_DATE IS NULL
			)
			OR
			(
			EIO.START_DATE >= #createdatetime(attributes.salary_year,attributes.salary_month,1,0,0,0)# AND
			EIO.START_DATE <= #createdatetime(attributes.salary_year,attributes.salary_month,daysinmonth(createdate(attributes.salary_year,attributes.salary_month,1)),0,0,0)#
			)
			OR
			(
			EIO.FINISH_DATE >= #createdatetime(attributes.salary_year,attributes.salary_month,1,0,0,0)# AND
			EIO.FINISH_DATE <= #createdatetime(attributes.salary_year,attributes.salary_month,daysinmonth(createdate(attributes.salary_year,attributes.salary_month,1)),0,0,0)#
			)
		)
		<cfif isdefined('attributes.odkes_id') and len(attributes.odkes_id)>
		AND EIO.IN_OUT_ID = SP.IN_OUT_ID 
		AND SP.TERM = #attributes.salary_year#
		AND #attributes.salary_month# BETWEEN SP.START_SAL_MON AND SP.END_SAL_MON
		AND SP.COMMENT_PAY IN ('#Replace(attributes.odkes_id,",","','",'all')#')
		<cfif isdefined('attributes.is_bordro')>AND SP.SHOW = 1</cfif>
		</cfif>
		<cfif isdefined('attributes.odkes_id2') and len(attributes.odkes_id2)>
		AND EIO.IN_OUT_ID = SG.IN_OUT_ID 
		AND SG.TERM = #attributes.salary_year#
		AND #attributes.salary_month# BETWEEN SG.START_SAL_MON AND SG.END_SAL_MON
		AND SG.COMMENT_GET IN ('#Replace(attributes.odkes_id2,",","','",'all')#')
		<cfif isdefined('attributes.is_bordro')>AND SG.SHOW = 1</cfif>
		</cfif>
		<cfif isdefined('attributes.tax_exception_id') and len(attributes.tax_exception_id)>
		AND EIO.IN_OUT_ID = ET.IN_OUT_ID 
		AND ET.TERM = #attributes.salary_year#
		AND #attributes.salary_month# BETWEEN ET.START_MONTH AND ET.FINISH_MONTH
		AND ET.TAX_EXCEPTION IN ('#Replace(attributes.tax_exception_id,",","','",'all')#')
		</cfif> 
		<cfif isdefined("attributes.employee_id") and len(attributes.employee_id) and len(attributes.employee)>AND EIO.EMPLOYEE_ID = #attributes.employee_id#</cfif>
		<cfif isdefined("attributes.branch_id") and len(attributes.branch_id) and len(attributes.branch_name)>AND EIO.BRANCH_ID = #attributes.branch_id#</cfif>
		<cfif isdefined("attributes.expense_id") and len(attributes.expense_id) and len(attributes.expense_code_name)>AND EIO.IN_OUT_ID IN(SELECT IN_OUT_ID FROM EMPLOYEES_IN_OUT_PERIOD WHERE PERIOD_YEAR = #attributes.salary_year# AND EXPENSE_CENTER_ID = #attributes.expense_id#)</cfif>
		<cfif isdefined("attributes.account_code") and len(attributes.account_code) and len(attributes.account_name)>AND EIO.IN_OUT_ID IN(SELECT IN_OUT_ID FROM EMPLOYEES_IN_OUT_PERIOD WHERE PERIOD_YEAR = #attributes.salary_year# AND ACCOUNT_CODE = '#attributes.account_code#')</cfif>
		<cfif isdefined("attributes.duty_type") and len(attributes.duty_type)> AND EIO.DUTY_TYPE IN (#attributes.duty_type#)</cfif>
		<cfif isdefined("attributes.sabit_prim") and len(attributes.sabit_prim)> AND EIO.SABIT_PRIM = #attributes.sabit_prim#</cfif>
		<cfif isdefined("attributes.salary_type") and len(attributes.salary_type)> AND EIO.SALARY_TYPE = #attributes.salary_type#</cfif>
		<cfif isdefined("attributes.gross_net") and len(attributes.gross_net)> AND EIO.GROSS_NET = #attributes.gross_net#</cfif>
		<cfif isdefined("attributes.is_vardiya") and len(attributes.is_vardiya)> AND EIO.IS_VARDIYA = #attributes.is_vardiya#</cfif>
		<cfif isdefined("attributes.ssk_statute") and listlen(attributes.ssk_statute)> AND EIO.SSK_STATUTE IN (#attributes.ssk_statute#)</cfif>
		<cfif isdefined("attributes.defection_level") and len(attributes.defection_level)> AND EIO.DEFECTION_LEVEL IN (#attributes.defection_level#)</cfif>
		<cfif isdefined("attributes.use_ssk") and len(attributes.use_ssk)> AND EIO.USE_SSK = #use_ssk#</cfif>
		<cfif isdefined("attributes.use_tax") and len(attributes.use_tax)> AND EIO.USE_TAX = #use_tax#</cfif>
		<cfif isdefined("attributes.use_pdks") and len(attributes.use_pdks)> AND EIO.USE_PDKS = #use_pdks#</cfif>
		<cfif isdefined("attributes.effected_corporate_change") and len(attributes.effected_corporate_change)> AND EIO.EFFECTED_CORPORATE_CHANGE = 1</cfif>
		<cfif isdefined("attributes.shift_id") and len(attributes.shift_id)>AND ED.SHIFT_ID IN (#attributes.shift_id#)</cfif>
		<cfif isdefined("attributes.pdks_status") and attributes.pdks_status eq 1>
		AND	EIO.PDKS_NUMBER IS NOT NULL
		<cfelseif isdefined("attributes.pdks_status") and attributes.pdks_status eq 0>
		AND	(EIO.PDKS_NUMBER IS NULL OR EIO.PDKS_NUMBER = '')
		</cfif>
		<!---<cfif len(attributes.in_date1)>AND EIO.START_DATE >= #attributes.in_date1#</cfif>
		<cfif len(attributes.in_date2)>AND EIO.FINISH_DATE <= #attributes.in_date2#</cfif>
		<cfif len(attributes.in_date1) and len(attributes.in_date2)> AND EIO.START_DATE BETWEEN #attributes.in_date1# AND #attributes.in_date2#</cfif>--->
		<cfif isdefined('attributes.status') and attributes.status eq 1>
			AND E.EMPLOYEE_STATUS = 1
		<cfelseif isdefined('attributes.status') and attributes.status eq 0>
			AND E.EMPLOYEE_STATUS = 0
		</cfif>
	ORDER BY 
		E.EMPLOYEE_NAME,
		E.EMPLOYEE_SURNAME
		<cfif isdefined('attributes.show_salary_change')>
		,ESH.IN_OUT_ID DESC
		,ESH.HISTORY_ID DESC
		</cfif>
</cfquery>
	<cfelse>
		<cfset arama_yapilmali = 1>
		<cfset get_ucret.recordcount = 0>
</cfif>
<cfquery name="get_active_shifts" datasource="#dsn#">
	SELECT SHIFT_ID, SHIFT_NAME, START_HOUR, END_HOUR FROM SETUP_SHIFTS
</cfquery>
<cfquery name="get_odeneks" datasource="#dsn#">
	SELECT ODKES_ID, COMMENT_PAY FROM SETUP_PAYMENT_INTERRUPTION WHERE IS_ODENEK = 1
</cfquery>
<cfquery name="get_odeneks2" datasource="#dsn#">
	SELECT ODKES_ID,COMMENT_PAY FROM SETUP_PAYMENT_INTERRUPTION WHERE IS_ODENEK = 0
</cfquery>
<cfquery name="get_vergi" datasource="#dsn#">
	SELECT TAX_EXCEPTION_ID,TAX_EXCEPTION FROM TAX_EXCEPTION
</cfquery>
<cfquery name="get_our_company_hours" datasource="#dsn#">
	SELECT SSK_MONTHLY_WORK_HOURS,DAILY_WORK_HOURS FROM OUR_COMPANY_HOURS WHERE OUR_COMPANY_ID = #session.ep.company_id#
</cfquery>
<cfparam name="attributes.maxrows" default=20>
<cfsavecontent variable="head"><cf_get_lang dictionary_id='39171.Detaylı Ücret Analiz'></cfsavecontent>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.totalrecords" default='#GET_UCRET.recordcount#'>
<cfform name="search_ucret" method="post" action="#request.self#?fuseaction=#attributes.fuseaction#">
	<cf_report_list_search title="#head#">
		<cf_report_list_search_area>
			<div class="row">
				<div class="col col-12 col-xs-12">
					<div class="row formContent">
						<div class="row" type="row">
							<div class="col col-3 col-md-4 col-sm-6 col-xs-12">
								<div class="col col-12 col-md-12 col-xs-12">
									<div class="col col-12 col-md-12 col-xs-12">
										<div class="form-group">
											<label class="col col-12 col-md-12 col-xs-12"><cf_get_lang dictionary_id='57576.Çalışan'></label>
											<div class="col col-12 col-md-12 col-xs-12">
												<div class="input-group">
													<input type="hidden" name="employee_id" id="employee_id" value="<cfif isdefined("attributes.employee_id")><cfoutput>#attributes.employee_id#</cfoutput></cfif>">
													<input type="hidden" name="in_out_id" id="in_out_id" value="<cfif isdefined("attributes.in_out_id")><cfoutput>#attributes.in_out_id#</cfoutput></cfif>">
													<input type="text" name="EMPLOYEE" id="EMPLOYEE" value="<cfif isdefined("attributes.employee")><cfoutput>#attributes.employee#</cfoutput></cfif>" onFocus="AutoComplete_Create('EMPLOYEE','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','POSITION_CODE,MEMBER_NAME','employee_id,EMPLOYEE','','3','135');">
													<span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#?fuseaction=hr.popup_list_emp_in_out&field_in_out_id=search_ucret.in_out_id&field_emp_name=search_ucret.EMPLOYEE&field_emp_id=search_ucret.employee_id'</cfoutput>,'list');"></span>
												</div>
											</div>
										</div>
										<div class="form-group">
											<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57453.Şube'></label>
											<div class="col col-12 col-md-12 col-xs-12">
												<div class="input-group">
													<input type="hidden" name="branch_id" id="branch_id" value="<cfif isdefined("attributes.branch_id")><cfoutput>#attributes.branch_id#</cfoutput></cfif>">
													<input type="text" name="branch_name" id="branch_name" value="<cfif isdefined("attributes.branch_name")><cfoutput>#attributes.branch_name#</cfoutput></cfif>" onFocus="AutoComplete_Create('branch_name','BRANCH_NAME','BRANCH_NAME','get_position_branch','','BRANCH_ID','branch_id','3','120')">
													<span class="input-group-addon btnPointer icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_branches&field_branch_id=search_ucret.branch_id&field_branch_name=search_ucret.branch_name','list');"></span>
												</div>
											</div>
										</div>
										<div class="form-group">
											<label class="col col-12 col-md-12 col-xs-12"><cf_get_lang dictionary_id='58460.Masraf Mrkz'></label>
											<div class="col col-12 col-md-12 col-xs-12">
												<div class="input-group">
													<input type="hidden" name="expense_id" id="expense_id" value="<cfif isdefined("attributes.expense_id")><cfoutput>#attributes.expense_id#</cfoutput></cfif>">
													<input type="text" name="expense_code_name" id="expense_code_name" value="<cfif isdefined("attributes.expense_code_name")><cfoutput>#attributes.expense_code_name#</cfoutput></cfif>" onfocus="AutoComplete_Create('expense_code_name','EXPENSE,EXPENSE_CODE','EXPENSE,EXPENSE_CODE','get_expense_center','<cfif session.ep.isBranchAuthorization>1<cfelse>0</cfif>','EXPENSE_code','expense_code','','3','150');">
													<span class="input-group-addon btnPointer icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_expense_center&field_id=search_ucret.expense_id&field_name=search_ucret.expense_code_name','list');"></span>
												</div>
											</div>
										</div>
										<div class="form-group">
											<label class="col col-12 col-md-12 col-xs-12"><cf_get_lang dictionary_id='58811.Muhasebe K'></label>
											<div class="col col-12 col-md-12 col-xs-12">
												<div class="input-group">
													<cf_wrk_account_codes form_name='search_ucret' account_code="account_code" is_sub_acc='1' account_name='account_name' search_from_name='1' is_multi_no = '1'>
													<input type="hidden" name="account_code" id="account_code" value="<cfif isdefined("attributes.account_code")><cfoutput>#attributes.account_code#</cfoutput></cfif>">
													<input type="text" name="account_name" id="account_name" value="<cfif isdefined("attributes.account_name")><cfoutput>#attributes.account_name#</cfoutput></cfif>" onKeyUp="get_wrk_acc_code_1();" onFocus="AutoComplete_Create('account_name','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','CODE_NAME,ACCOUNT_CODE','account_name','3','250');">
													<span class="input-group-addon btnPointer icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_name=search_ucret.account_name&field_id=search_ucret.account_code','list')"></span>
												</div>
											</div>
										</div>
										<div class="form-group">
											<label class="col col-12 col-md-12 col-xs-12"><cf_get_lang dictionary_id='38979.Ücret Tipi'></label>
											<div class="col col-12 col-md-12 col-xs-12">
												<select name="sabit_prim" id="sabit_prim">
												<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
												<option value="0"<cfif isdefined("attributes.sabit_prim") and attributes.sabit_prim eq 0>selected</cfif>><cf_get_lang dictionary_id='58544.Sabit'></option>
												<option value="1"<cfif isdefined("attributes.sabit_prim") and attributes.sabit_prim eq 1> selected</cfif>><cf_get_lang dictionary_id='38981.Primli'></option>
												</select>
											</div>
										</div>
										<div class="form-group">
											<label class="col col-12 col-md-12 col-xs-12"><cf_get_lang dictionary_id='38983.Ücret Yöntemi'></label>
											<div class="col col-12 col-md-12 col-xs-12">
												<select name="SALARY_TYPE" id="SALARY_TYPE">
													<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
													<option value="2" <cfif isdefined("attributes.salary_type") and attributes.salary_type eq 2>selected</cfif>><cf_get_lang dictionary_id='58724.Ay'></option>
													<option value="1" <cfif isdefined("attributes.salary_type") and attributes.salary_type eq 1>selected</cfif>><cf_get_lang dictionary_id='57490.Gün'></option>
													<option value="0" <cfif isdefined("attributes.salary_type") and attributes.salary_type eq 0>selected</cfif>><cf_get_lang dictionary_id='57491.Saat'></option>
												</select>
											</div>
										</div>
										<div class="form-group">
											<label class="col col-12 col-md-12 col-xs-12"><cf_get_lang dictionary_id='58543.Mesai Tipi'></label>
											<div class="col col-12 col-md-12 col-xs-12">
												<select name="is_vardiya" id="is_vardiya">
													<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
													<option value="0" <cfif isdefined("attributes.is_vardiya") and attributes.is_vardiya eq 0>selected</cfif>><cf_get_lang dictionary_id='58544.Sabit'></option>
													<option value="1" <cfif isdefined("attributes.is_vardiya") and attributes.is_vardiya eq 1>selected</cfif>><cf_get_lang dictionary_id='58545.Vardiyalı'></option>
												</select>
											</div>
										</div>
										<div class="form-group">
											<label class="col col-12 col-md-12 col-xs-12"><cf_get_lang dictionary_id='38989.Brüt / Net'></label>
											<div class="col col-12 col-md-12 col-xs-12">
												<select name="gross_net" id="gross_net">
													<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
													<option value="0"<cfif isdefined("attributes.gross_net") and attributes.gross_net eq 0>selected</cfif>><cf_get_lang dictionary_id='38990.Brüt'></option>
													<option value="1"<cfif isdefined("attributes.gross_net") and attributes.gross_net eq 1> selected</cfif>><cf_get_lang dictionary_id='58083.Net'></option>
												</select>
											</div>
										</div>
									</div>
								</div>
							</div>
							<div class="col col-3 col-md-4 col-sm-6 col-xs-12">
								<div class="col col-12 col-md-12 col-xs-12">
									<div class="col col-12 col-md-12 col-xs-12">
										<div class="form-group">
											<label class="col col-12 col-md-12 col-xs-12"><cf_get_lang dictionary_id='58538.Görev Tipi'></label>
											<div class="col col-12 col-md-12 col-xs-12">
												<select name="DUTY_TYPE" id="DUTY_TYPE" style="height:69px;" multiple="multiple">
													<option value="2" <cfif isdefined("attributes.duty_type") and listfindnocase(attributes.duty_type,'2')>selected</cfif>><cf_get_lang dictionary_id='57576.Çalışan'></option>
													<option value="1" <cfif isdefined("attributes.duty_type") and listfindnocase(attributes.duty_type,'1')>selected</cfif>><cf_get_lang dictionary_id='38967.İşveren Vekili'></option>
													<option value="0" <cfif isdefined("attributes.duty_type") and listfindnocase(attributes.duty_type,'0')>selected</cfif>><cf_get_lang dictionary_id='38968.İşveren'></option>
												</select>
											</div>
										</div>
										<div class="form-group">
											<label class="col col-12 col-md-12 col-xs-12"><cf_get_lang dictionary_id='38993.SSK Durumu'></label>
											<div class="col col-12 col-md-12 col-xs-12">
											<cfoutput>
												<select name="ssk_statute" id="ssk_statute" style="height:69px;" multiple="multiple">
													<cfloop list="#list_ucret()#" index="i">
														<option value="#i#" <cfif isdefined("attributes.ssk_statute") and listfindnocase(attributes.ssk_statute,i)>selected</cfif>>#listgetat(list_ucret_names(),listfindnocase(list_ucret(),i,','),'*')#</option>
													</cfloop>
												</select>
											</cfoutput>
											</div>
										</div>
										<div class="form-group">
											<label class="col col-12 col-md-12 col-xs-12"><cf_get_lang dictionary_id='38988.Vergi İst'></label>
											<div class="col col-12 col-md-12 col-xs-12">
											<cfoutput>
												<select name="tax_exception_id" id="tax_exception_id" style="height:69px;" multiple="multiple">
													<cfloop query="get_vergi">
													<option value="#TAX_EXCEPTION#"<cfif isdefined("attributes.tax_exception_id") and listfindnocase(attributes.tax_exception_id,TAX_EXCEPTION)>selected</cfif>>#TAX_EXCEPTION#</option>
													</cfloop>
												</select>
											</cfoutput>
											</div>
										</div>
										<div class="form-group">
											<label class="col col-12 col-md-12 col-xs-12"><cf_get_lang dictionary_id='38969.Vardiyalar'></label>
											<div class="col col-12 col-md-12 col-xs-12">
											<cfoutput>
												<select name="shift_id" id="shift_id" style="height:69px;" multiple="multiple">
													<cfif get_active_shifts.recordcount eq 0>
													<cfelse>
													<cfloop query="get_active_shifts">
														<option value="#shift_id#" <cfif isdefined("attributes.shift_id") and listfindnocase(attributes.shift_id,shift_id)>selected</cfif>>#shift_name# (#start_hour#-#end_hour#)</option>
													</cfloop>
													</cfif>
												</select>
											</cfoutput>
											</div>
										</div>
									</div>
								</div>
							</div>
							<div class="col col-3 col-md-4 col-sm-6 col-xs-12">
								<div class="col col-12 col-md-12 col-xs-12">
									<div class="col col-12 col-md-12 col-xs-12">
										<div class="form-group">
											<label class="col col-12 col-md-12 col-xs-12"><cf_get_lang dictionary_id='38975.S Derecesi'></label>
											<div class="col col-12 col-md-12 col-xs-12">
												<select name="defection_level" id="defection_level" style="height:69px;" multiple="multiple">
												<option value="0" <cfif isdefined("attributes.defection_level") and listfindnocase(attributes.defection_level,'0')>selected</cfif>><cf_get_lang dictionary_id='58546.Yok'></option>
												<option value="1" <cfif isdefined("attributes.defection_level") and listfindnocase(attributes.defection_level,'1')>selected</cfif>>1</option>
												<option value="2" <cfif isdefined("attributes.defection_level") and listfindnocase(attributes.defection_level,'2')>selected</cfif>>2</option>
												<option value="3" <cfif isdefined("attributes.defection_level") and listfindnocase(attributes.defection_level,'3')>selected</cfif>>3</option>
												</select>
											</div>
										</div>
										<div class="form-group">
											<label class="col col-12 col-md-12 col-xs-12"><cf_get_lang dictionary_id ='40444.İşe Giriş'></label>
											<div class="col col-6 col-md-6">
												<div class="input-group">
													<cfsavecontent variable="message"><cf_get_lang dictionary_id="58194.Zorunlu Alan"> : <cf_get_lang dictionary_id="58053.Başlangıç Tarihi"></cfsavecontent>
													<cfinput value="#attributes.in_date1#" type="text" name="in_date1" message="#message#" validate="#validate_style#">
													<span class="input-group-addon">
														<cf_wrk_date_image date_field="in_date1">
													</span>
												</div>
											</div>
											<div class="col col-6 col-md-6">
												<div class="input-group">
													<cfsavecontent variable="message1"><cf_get_lang dictionary_id="58194.Zorunlu Alan"> : <cf_get_lang dictionary_id="57700.Bitiş Tarihi"></cfsavecontent>
													<cfinput value="#attributes.in_date2#" type="text" name="in_date2" message="#message1#" validate="#validate_style#">
													<span class="input-group-addon">
														<cf_wrk_date_image date_field="in_date2">
													</span>
												</div>
											</div>
										</div>
										<div class="form-group">
											<label class="col col-12 col-md-12 col-xs-12"><cf_get_lang dictionary_id='57756'></label>
											<div class="col col-12 col-md-12 col-xs-12">
												<select name="status" id="status" style="width:69px;">
													<option value=""><cf_get_lang dictionary_id='57708.Tümü'></option>
													<option value="1" <cfif isdefined('attributes.status') and attributes.status eq 1>selected</cfif>><cf_get_lang dictionary_id='57493.Aktif'></option>
													<option value="0" <cfif isdefined('attributes.status') and attributes.status eq 0>selected</cfif>><cf_get_lang dictionary_id='57494.Pasif'></option>
												</select>
											</div>
										</div>
										<div class="form-group">
											<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='38970.Ödenek Türü'></label>
											<div class="col col-12 col-md-12 col-xs-12">
												<cfoutput>
													<select name="odkes_id" id="odkes_id" style="height:69px;" multiple="multiple">
														<cfif get_odeneks.recordcount eq 0>
															<cfelse>
															<cfloop query="get_odeneks">
															<option value="#COMMENT_PAY#"<cfif isdefined("attributes.odkes_id") and listfindnocase(attributes.odkes_id,COMMENT_PAY)>selected</cfif>>#COMMENT_PAY#</option>
															</cfloop>
														</cfif>
													</select>
												</cfoutput>
											</div>
										</div>
										<div class="form-group">
											<label class="col col-12 col-md-12 col-xs-12"><cf_get_lang dictionary_id='38977.Kesintiler'></label>
											<div class="col col-12 col-md-12 col-xs-12">
												<cfoutput>
													<cfif get_odeneks2.recordcount eq 0>
													<cfelse>	
														<select name="odkes_id2" id="odkes_id2" style="height:69px;" multiple="multiple">
															<cfloop query="get_odeneks2">
															<option value="#COMMENT_PAY#"<cfif isdefined("attributes.odkes_id2") and listfindnocase(attributes.odkes_id2,COMMENT_PAY)>selected</cfif>>#COMMENT_PAY#</option>
															</cfloop>
														</select>
													</cfif>
												</cfoutput>
											</div>
										</div>
									</div>
								</div>
							</div>
							<div class="col col-3 col-md-4 col-sm-6 col-xs-12">
								<div class="col col-12 col-md-12 col-xs-12">
									<div class="col col-12 col-md-12 col-xs-12">
										<div class="form-group">
											<label class="col col-12 col-md-12 col-xs-12"><cf_get_lang dictionary_id='58455.Yıl'>-<cf_get_lang dictionary_id='58724.Ay'></label>		
											<div class="col col-6 col-md-6 paddingnone">
													<cfoutput>
														<select name="salary_year" id="salary_year">
																<cfloop from="#session.ep.period_year#" to="#session.ep.period_year-3#" index="i" step="-1">
																	<cfoutput>
																	<option value="#i#"<cfif attributes.salary_year eq i> selected</cfif>>#i#</option>
																	</cfoutput>
																</cfloop>
															</select>	
													</div>
												<div class="col col-6 col-md-6">	
													<select name="salary_month" id="salary_month">
														<cfloop from="1" to="12" index="i">
															<cfoutput>
															<option value="#i#"<cfif attributes.salary_month eq i> selected</cfif>>#i#</option>
															</cfoutput>
														</cfloop>
													</select>
												</cfoutput>
											</div>
										</div>
											<div class="form-group">
												<label><input type="checkbox" name="use_tax" id="use_tax" value="1"<cfif isdefined("attributes.use_tax")> checked</cfif>><cf_get_lang dictionary_id='38971.Vergi İndirimi'></label>
											</div>
											<div class="form-group">
												<label><input type="checkbox" name="use_ssk" id="use_ssk" value="1" <cfif isdefined("attributes.use_ssk")>checked</cfif>><cf_get_lang dictionary_id='38973.SSK Çalışanı'></label>
											</div>
											<div class="form-group">
											</div>
												<label style="margin-left: 1px"><input type="checkbox" name="use_pdks" id="use_pdks" value="1"<cfif isdefined("attributes.use_pdks") eq 1> checked</cfif>><cf_get_lang dictionary_id='39713.PDKS ye bağlı'></label>
											
													<select name="pdks_status" id="pdks_status">
														<option value=""><cf_get_lang dictionary_id='58009.PDKS'></option>
														<option value="1" <cfif isdefined("attributes.pdks_status") and attributes.pdks_status eq 1>selected</cfif>><cf_get_lang dictionary_id='39965.Dolu Olanlar'></option>
														<option value="0" <cfif isdefined("attributes.pdks_status") and attributes.pdks_status eq 0>selected</cfif>><cf_get_lang dictionary_id='39966.Boş Olanlar'></option>												
													</select>
												
												<div class="form-group">
													<label><input type="checkbox" name="effected_corporate_change" id="effected_corporate_change" value="1" <cfif isdefined("attributes.effected_corporate_change") eq 1>checked</cfif>><cf_get_lang dictionary_id='38982.Toplu Ücret Ayarlamasından Etkilensin'></label>
												</div>
												<div class="form-group">
													<label><input type="checkbox" name="is_bordro" id="is_bordro" value="1" <cfif isdefined("attributes.is_bordro") eq 1>checked</cfif>><cf_get_lang dictionary_id='38985.Bordroya Dahil'></label>
												</div>
												<div class="form-group">
												<label><input type="checkbox" name="use_sabit_prim" id="use_sabit_prim" value="1" <cfif isdefined("attributes.use_sabit_prim")>checked</cfif>><cf_get_lang dictionary_id='38979.Ücret Tipi'></label>
												</div>
												<div class="form-group">
													<label><input type="checkbox" name="use_salary_type" id="use_salary_type" value="1" <cfif isdefined("attributes.use_salary_type")>checked</cfif>><cf_get_lang dictionary_id='38983.Ücret Yöntemi'></label>
												</div>
												<div class="form-group">
													<label><input type="checkbox" name="use_vardiya" id="use_vardiya" value="1" <cfif isdefined("attributes.use_vardiya")>checked</cfif>><cf_get_lang dictionary_id='58543.Mesai Tipi'></label>
												</div>
												<div class="form-group">
													<label><input type="checkbox" name="use_gross_net" id="use_gross_net" value="1" <cfif isdefined("attributes.use_gross_net")>checked</cfif>><cf_get_lang dictionary_id='38989.Brüt Net'></label>
												</div>
												<div class="form-group">
													<label><input type="checkbox" name="use_duty_type" id="use_duty_type" value="1" <cfif isdefined("attributes.use_duty_type")>checked</cfif>><cf_get_lang dictionary_id='58538.Görev Tipi'></label>
												</div>
												<div class="form-group">
													<label><input type="checkbox" name="use_ssk_statute" id="use_ssk_statute" value="1" <cfif isdefined("attributes.use_ssk_statute")>checked</cfif>><cf_get_lang dictionary_id='38993.SSK Statüsü'></label>
												</div>
												<div class="form-group">
													<label><input type="checkbox" name="use_defection" id="use_defection" value="1" <cfif isdefined("attributes.use_defection")>checked</cfif>><cf_get_lang dictionary_id='38994.Sakatlık Durumu'></label>
												</div>
												<div class="form-group">
													<label><input type="checkbox" name="show_salary_change" id="show_salary_change" value="1" <cfif isdefined("attributes.show_salary_change")>checked</cfif>><cf_get_lang dictionary_id='39712.Ücret Değişimi'></label>
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
								<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" onKeyUp="isNumber(this)" message="#message#" maxlength="3" style="width:25px;">
							<cfelse>
								<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" onKeyUp="isNumber(this)" range="1,250" message="#message#" maxlength="3" style="width:25px;">
							</cfif>
							<input name="is_submit" id="is_submit" value="1" type="hidden">
							<cf_wrk_report_search_button button_type='1' is_excel='1' search_function="control()">
						</div>
					</div>
				</div>
			</div> 
		</cf_report_list_search_area>
	</cf_report_list_search>
</cfform>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
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
<!--- arama --->
<cfif isdefined('attributes.is_submit')>
	<cf_report_list>
		<cfif isdefined('attributes.is_submit')>
			<cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
				<cfset type_ = 1>
				<cfset attributes.startrow=1>
				<cfset attributes.maxrows=GET_UCRET.recordcount>		
			<cfelse>
				<cfset type_ = 0>
			</cfif>
				
				<thead>
					<tr> 
						<th width="25"><cf_get_lang dictionary_id='58577.Sira'></th>
						<th><cf_get_lang dictionary_id='57576.Çalışan'></th>
						<th><cf_get_lang dictionary_id='58025.TC No'></th>
						<th><cf_get_lang dictionary_id='39705.SSK No'></th>
						<cfif session.ep.ehesap>
						<cfif isdefined('attributes.show_salary_change')>
							<th><cf_get_lang dictionary_id ='40445.Son Ücret'></th>
							<th><cf_get_lang dictionary_id ='40446.Ücret Yılı'></th>
							<th><cf_get_lang dictionary_id ='57592.Ocak'></th>
							<th><cf_get_lang dictionary_id ='57593.Şubat'></th>
							<th><cf_get_lang dictionary_id ='57594.Mart'></th>
							<th><cf_get_lang dictionary_id ='57595.Nisan'></th>
							<th><cf_get_lang dictionary_id ='57596.Mayıs'></th>
							<th><cf_get_lang dictionary_id ='57597.Haziran'></th>
							<th><cf_get_lang dictionary_id ='57598.Temmuz'></th>
							<th><cf_get_lang dictionary_id ='57599.Ağustos'></th>
							<th><cf_get_lang dictionary_id ='57600.Eylül'></th>
							<th><cf_get_lang dictionary_id ='57601.Ekim'></th>
							<th><cf_get_lang dictionary_id ='57602.Kasım'></th>
							<th><cf_get_lang dictionary_id ='57603.Aralık'></th>
							<th><cf_get_lang dictionary_id ='40447.Değişiklik Yapan'></th>
							<th><cf_get_lang dictionary_id ='40448.Değişiklik Tarihi'></th>
						</cfif>
						<th><cf_get_lang dictionary_id ='40449.Dönem Ücreti'></th>
						<th nowrap="nowrap"><cf_get_lang dictionary_id ='57489.Para Br'></th>
						<th><cf_get_lang dictionary_id='40450.Ücret Yönetimi'></th>
						<th><cf_get_lang dictionary_id='38996.Toplam Brüt Kazanç'></th> 
						<th><cf_get_lang dictionary_id='38997.Ek Kazanç'></th>
						<th><cf_get_lang dictionary_id='58204.Avans'></th>
						<th><cf_get_lang dictionary_id='38999.Net Ücret'></th>
						</cfif>
						<th><cf_get_lang dictionary_id='39000.Ek Kazanç Saat (Hafta İçi)'></th>
						<th><cf_get_lang dictionary_id='39001.Ek Kazanç Saat (Hafta Sonu)'></th> 
						<th><cf_get_lang dictionary_id='39002.Ek Kazanç Saat (Resmi Tatil)'></th> 
						<th><cf_get_lang dictionary_id='39003.45 saati aşan ek mesai'></th>
						<th><cf_get_lang dictionary_id='40451.Son İşe Başlama'></th>
						<th><cf_get_lang dictionary_id='57453.Şube'></th>
						<cfif isdefined("attributes.use_sabit_prim")><th><cf_get_lang dictionary_id='38979.Ücret Tipi'></th></cfif>
						<cfif isdefined("attributes.use_salary_type")><th><cf_get_lang dictionary_id='29472.Yöntem'></th></cfif>
						<cfif isdefined("attributes.use_vardiya")><th><cf_get_lang dictionary_id='58543.Mesai Tipi'></th></cfif>
						<cfif isdefined("attributes.use_gross_net")><th><cf_get_lang dictionary_id='38989.Brüt Net'></th></cfif>
						<cfif isdefined("attributes.use_duty_type")><th><cf_get_lang dictionary_id='58538.Görev Tipi'></th></cfif>
						<cfif isdefined("attributes.use_ssk_statute")><th><cf_get_lang dictionary_id ='38993.SSK Statüs'></th></cfif>
						<th><cf_get_lang dictionary_id='38969.Vardiyalar'></th>
						<cfif isdefined("attributes.use_defection")><th><cf_get_lang dictionary_id='38994.Sakatlık D'>.</th></cfif>
						<th><cf_get_lang dictionary_id='58714.SSK'></th>
						<th><cf_get_lang dictionary_id='38971.Vergi İndirimi'></th>
						<th><cf_get_lang dictionary_id='40452.Gelir vergisi'></th>
						<th><cf_get_lang dictionary_id='40453.G V Matrahı'></th>
						<th><cf_get_lang dictionary_id='39006.P D K S'></th>
						<th><cf_get_lang dictionary_id='39968.PDKS No'></th>
						<th><cf_get_lang dictionary_id='38982.T Ücret A E'></th>
						<th>FM</th>
						<cfif isdefined('attributes.odkes_id') and len(attributes.odkes_id)>
						<th><cf_get_lang dictionary_id='38970.Ödenek Türü'></th>
						<th><cf_get_lang dictionary_id='38989.Brüt Net'></th>
						<th><cf_get_lang dictionary_id='57673.Tutar'></th>
						</cfif>
						<cfif isdefined('attributes.odkes_id2') and len(attributes.odkes_id2)>
						<th><cf_get_lang dictionary_id='39008.Kesinti Türü'></th>
						<th><cf_get_lang dictionary_id='38989.Net Brüt'></th>
						<!--- <th width="20">Ynt.</td> --->
						<th><cf_get_lang dictionary_id='57673.Tutar'></th>
						</cfif>
						<cfif isdefined('attributes.tax_exception_id') and len(attributes.tax_exception_id)>
						<th><cf_get_lang dictionary_id='53615.İstisna Türü'></th>
						<th><cf_get_lang dictionary_id='57673.Tutar'></th>
						</cfif>
					</tr>
				</thead>
				<cfset shift_id_list = ''>
				<cfset salary_in_out_id_list = ''>
				<cfset employee_id_list = ''>
				<cfoutput query="GET_UCRET" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
					<cfset salary_in_out_id_list = listappend(salary_in_out_id_list,IN_OUT_ID,',')>
					<cfif len(shift_id) and not listfind(shift_id_list,shift_id,'')>
					<cfset shift_id_list = listappend(shift_id_list,shift_id,',')>
					</cfif>
					<cfset employee_id_list = listappend(employee_id_list,employee_id,',')>
				</cfoutput>
				<cfset salary_in_out_id_list=listsort(salary_in_out_id_list,"numeric","ASC",",")>
				<cfset shift_id_list = listsort(shift_id_list,"numeric","ASC",",")>
				<cfset employee_id_list = listsort(employee_id_list,"numeric","ASC",",")>
				<cfif listlen(salary_in_out_id_list)>
					<cfquery name="get_maas_all" datasource="#dsn#">
						SELECT
							M#attributes.salary_month# AS MAAS,
							MONEY AS SALARY_MONEY,
							IN_OUT_ID
						FROM 
							EMPLOYEES_SALARY 
						WHERE
							IN_OUT_ID IN (#salary_in_out_id_list#) AND
							PERIOD_YEAR = #attributes.salary_year#
						ORDER BY
							IN_OUT_ID
					</cfquery>
					<cfset salary_in_out_id_list = listsort(listdeleteduplicates(valuelist(get_maas_all.IN_OUT_ID,',')),'numeric','ASC',',')>
				</cfif>
				<cfif listlen(shift_id_list)>
					<cfquery name="get_shifts" datasource="#dsn#">
						SELECT SHIFT_ID,SHIFT_NAME,START_HOUR,END_HOUR FROM SETUP_SHIFTS WHERE SHIFT_ID IN(#shift_id_list#) ORDER BY SHIFT_ID
					</cfquery>
					<cfset shift_id_list = listsort(listdeleteduplicates(valuelist(get_shifts.SHIFT_ID,',')),'numeric','ASC',',')>
				</cfif>
				<cfif listlen(employee_id_list)>
					<cfquery name="get_puantaj" datasource="#dsn#">
						SELECT 
							EMPLOYEES_PUANTAJ_ROWS.SALARY,
							EMPLOYEES_PUANTAJ_ROWS.MONEY,
							EMPLOYEES_PUANTAJ_ROWS.EMPLOYEE_ID,
							EMPLOYEES_PUANTAJ_ROWS.EXT_TOTAL_HOURS_0,
							EMPLOYEES_PUANTAJ_ROWS.EXT_TOTAL_HOURS_1,
							EMPLOYEES_PUANTAJ_ROWS.EXT_TOTAL_HOURS_2,
							EMPLOYEES_PUANTAJ_ROWS.EXT_TOTAL_HOURS_3,
							EMPLOYEES_PUANTAJ_ROWS.TOTAL_SALARY,
							EMPLOYEES_PUANTAJ_ROWS.EXT_SALARY,
							EMPLOYEES_PUANTAJ_ROWS.AVANS,
							EMPLOYEES_PUANTAJ_ROWS.NET_UCRET
						FROM 
							EMPLOYEES_PUANTAJ,
							EMPLOYEES_PUANTAJ_ROWS
						WHERE 
							EMPLOYEES_PUANTAJ.PUANTAJ_ID = EMPLOYEES_PUANTAJ_ROWS.PUANTAJ_ID AND
							EMPLOYEES_PUANTAJ_ROWS.EMPLOYEE_ID IN(#employee_id_list#) AND
							EMPLOYEES_PUANTAJ.SAL_YEAR = #attributes.salary_year# AND
							EMPLOYEES_PUANTAJ.SAL_MON = #attributes.salary_month#
						ORDER BY 
							EMPLOYEE_ID
					</cfquery>
					<cfset employee_id_list = listsort(listdeleteduplicates(valuelist(get_puantaj.employee_id,',')),'numeric','ASC',',')>
				</cfif><cfif get_ucret.recordcount>
				<tbody>
					<cfoutput query="GET_UCRET" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
					<tr>
						<td width="25">#currentrow#</td>
						<td height="20" width="100">#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#</td>
						<td>#TC_IDENTY_NO#</td>
						<td>#SOCIALSECURITY_NO#</td>
						<cfif session.ep.ehesap>
						<cfif isdefined('attributes.show_salary_change')>
							<td><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(SON_UCRET)#"></td>
							<td>#period_year#</td>
							<td><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(m1)#"></td>
							<td><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(m2)#"></td>
							<td><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(m3)#"></td>
							<td><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(m4)#"></td>
							<td><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(m5)#"></td>
							<td><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(m6)#"></td>
							<td><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(m7)#"></td>
							<td><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(m8)#"></td>
							<td><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(m9)#"></td>
							<td><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(m10)#"></td>
							<td><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(m11)#"></td>
							<td><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(m12)#"></td>
							<td>#change_empname# #change_empsurname#</td>
							<td>#dateformat(change_date,dateformat_style)#</td>
						</cfif>
						<td><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(get_puantaj.salary[listfind(employee_id_list,employee_id,',')])#"></td>
						<td>#get_puantaj.money[listfind(employee_id_list,employee_id,',')]#</td>
						<td>
							<cfif GET_UCRET.SALARY_TYPE EQ 0><cf_get_lang dictionary_id='57491.Saat'>
							<cfelseif GET_UCRET.SALARY_TYPE EQ 1><cf_get_lang dictionary_id='57490.Gün'>
							<cfelseif GET_UCRET.SALARY_TYPE EQ 2><cf_get_lang dictionary_id='58724.Ay'></cfif>
						</td>
						<td><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(get_puantaj.total_salary[listfind(employee_id_list,employee_id,',')])#"></td>
						<td><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(get_puantaj.ext_salary[listfind(employee_id_list,employee_id,',')])#"></td>
						<td><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(get_puantaj.avans[listfind(employee_id_list,employee_id,',')])#"></td>
						<td><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(get_puantaj.net_ucret[listfind(employee_id_list,employee_id,',')])#"></td>
						</cfif>
						<td>#get_puantaj.ext_total_hours_0[listfind(employee_id_list,employee_id,',')]#</td>
						<td>#get_puantaj.ext_total_hours_1[listfind(employee_id_list,employee_id,',')]#</td>
						<td>#get_puantaj.ext_total_hours_2[listfind(employee_id_list,employee_id,',')]#</td>
						<td>#get_puantaj.ext_total_hours_3[listfind(employee_id_list,employee_id,',')]#</td>
						<td>#dateformat(STARTDATE,dateformat_style)#</td>
						<td>#BRANCH_NAME#</td>
						<cfif isdefined("attributes.use_sabit_prim")><td><cfif sabit_prim eq 1><cf_get_lang dictionary_id='38981.Primli'><cfelseif sabit_prim eq 0><cf_get_lang dictionary_id='58544.Sabit'><cfelse><cf_get_lang dictionary_id='58845.Tanımsız'></cfif></td></cfif>
						<cfif isdefined("attributes.use_salary_type")><td><cfif salary_type eq 0><cf_get_lang dictionary_id='57491.Saat'><cfelseif salary_type eq 1><cf_get_lang dictionary_id='57490.Gün'><cfelseif salary_type eq 2><cf_get_lang dictionary_id='58724.Ay'></cfif></td></cfif>
						<cfif isdefined("attributes.use_vardiya")><td><cfif is_vardiya eq 0><cf_get_lang dictionary_id='58544.Sabit'><cfelseif is_vardiya eq 1><cf_get_lang dictionary_id='58545.Vardiyalı'><cfelse><cf_get_lang dictionary_id='58845.Tanımsız'></cfif></td></cfif>
						<cfif isdefined("attributes.use_gross_net")><td><cfif get_ucret.gross_net><cf_get_lang dictionary_id='58083.Net'><cfelse><cf_get_lang dictionary_id='38990.Brüt'></cfif></td></cfif>
						<cfif isdefined("attributes.use_duty_type")><td><cfif duty_type eq 2><cf_get_lang dictionary_id='57576.Çalışan'><cfelseif duty_type eq 1><cf_get_lang dictionary_id='38967.İşveren V'><cfelseif duty_type eq 0><cf_get_lang dictionary_id='38968.İşveren'><cfelse><cf_get_lang dictionary_id='58845.Tanımsız'></cfif></td></cfif>
						<cfif isdefined("attributes.use_ssk_statute")><td><cfif len(ssk_statute)>#listgetat(list_ucret_names(),listfind(list_ucret(),ssk_statute,','),'*')#</cfif></td></cfif>
						<td><cfif len(shift_id)>#get_shifts.shift_name[listfind(shift_id_list,shift_id,',')]#(#get_shifts.start_hour[listfind(shift_id_list,shift_id,',')]#-#get_shifts.end_hour[listfind(shift_id_list,shift_id,',')]#)<cfelse><cf_get_lang dictionary_id='58845.Tanımsız'></cfif></td>
						<cfif isdefined("attributes.use_defection")><td><cfif defection_level eq 0><cf_get_lang dictionary_id='58546.Yok'><cfelseif defection_level eq 1>1<cfelseif defection_level eq 2>2<cfelseif defection_level eq 3>3<cfelse><cf_get_lang dictionary_id='58845.Tanımsız'></cfif></td></cfif>
						<td><cfif use_ssk eq 1><cf_get_lang dictionary_id='40671.SSK lı'><cfelseif use_ssk eq 0><cf_get_lang dictionary_id='39011.Değil'></cfif></td>
						<td><cfif use_tax eq 1><cf_get_lang dictionary_id='58564.Var'><cfelseif use_tax eq 0><cf_get_lang dictionary_id='58546.Yok'><cfelse><cf_get_lang dictionary_id='58845.Tanımsız'></cfif></td>
						<td><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#TLFormat(GELIR_VERGISI)#"></td>
						<td><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#TLFormat(GELIR_VERGISI_MATRAH)#"></td>
						<td><cfif use_pdks eq 1><cf_get_lang dictionary_id='39014.Bağlı'><cfelseif use_pdks eq 0><cf_get_lang dictionary_id='39011.Değil'></cfif></td>
						<td>#PDKS_NUMBER#</td>
						<td><cfif effected_corporate_change eq 1><cf_get_lang dictionary_id='39015.Etkilensin'><cfelseif effected_corporate_change eq 0><cf_get_lang dictionary_id='39012.Etkilenmesin'></cfif></td>
						<td>#fazla_mesai_saat#</td>
						<cfif isdefined('attributes.odkes_id') and len(attributes.odkes_id)>
						<td>#comment_pay#</td>
						<td><cfif odenek_salary eq 1><cf_get_lang dictionary_id='38990.Brüt'><cfelseif odenek_salary eq 0><cf_get_lang dictionary_id='58083.Net'></cfif></td>
						<td><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(amount_pay)#"></td>
						</cfif>
						<cfif isdefined('attributes.odkes_id2') and len(attributes.odkes_id2)>
						<td>#comment_get#</td>
						<td><cfif from_salary eq 1><cf_get_lang dictionary_id='38990.Brüt'><cfelseif from_salary eq 0><cf_get_lang dictionary_id='58083.Net'></cfif></td>
						<td><cfif METHOD_GET eq 2>#amount_get# %<cfelse><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(amount_get)#"></cfif></td>
						</cfif>
						<cfif isdefined('attributes.tax_exception_id') and len(attributes.tax_exception_id)>
						<td>#tax_exception#</td>
						<td><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(amount)#"></td>
						</cfif>
					</tr>
					</cfoutput>
				</tbody>
				<cfelse>
				<tbody>
					<tr>
						<td colspan="26"><!-- sil --><cfif isdefined('attributes.is_submit') and len(attributes.is_submit)><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'><cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'></cfif>!<!-- sil --></td>
					</tr>
				</tbody>
			</cfif>
		</cfif>
	</cf_report_list>
</cfif>
<cfif attributes.totalrecords gt attributes.maxrows>
		<cfset adres="#attributes.fuseaction#&is_submit=1">
		<cfif isdefined("attributes.branch_id") and len(attributes.branch_id) and len(attributes.branch_name)>
			<cfset adres="#adres#&branch_id=#attributes.branch_id#&branch_name=#attributes.branch_name#">
		</cfif>
		<cfif isdefined("attributes.duty_type") and len(attributes.duty_type)>
			<cfset adres="#adres#&duty_type=#attributes.duty_type#">
		</cfif>
		<cfif isdefined("attributes.sabit_prim") and len(attributes.sabit_prim)>
			<cfset adres="#adres#&sabit_prim=#attributes.sabit_prim#">
		</cfif>
		<cfif isdefined("attributes.salary_type") and len(attributes.salary_type)>
			<cfset adres="#adres#&salary_type=#attributes.salary_type#">
		</cfif>
		<cfif isdefined("attributes.use_ssk") and len(attributes.use_ssk)>
			<cfset adres="#adres#&use_ssk=#attributes.use_ssk#">
		</cfif>
		<cfif isdefined("attributes.use_tax") and len(attributes.use_tax)>
			<cfset adres="#adres#&use_tax=#attributes.use_tax#">
		</cfif>
		<cfif isdefined("attributes.is_vardiya") and len(attributes.is_vardiya)>
			<cfset adres="#adres#&is_vardiya=#attributes.is_vardiya#">
		</cfif>
		<cfif isdefined("attributes.ssk_statute") and len(attributes.ssk_statute)>
			<cfset adres="#adres#&ssk_statute=#attributes.ssk_statute#">
		</cfif>
		<cfif isdefined("attributes.defection_level") and len(attributes.defection_level)>
			<cfset adres="#adres#&defection_level=#attributes.defection_level#">
		</cfif>
		<cfif isdefined("attributes.use_pdks") and len(attributes.use_pdks)>
			<cfset adres="#adres#&use_pdks=#attributes.use_pdks#">
		</cfif>
		<cfif isdefined("attributes.effected_corporate_change")>
			<cfset adres="#adres#&effected_corporate_change=#attributes.effected_corporate_change#">
		</cfif>
		<cfif isdefined("attributes.gross_net") and len(attributes.gross_net)>
			<cfset adres="#adres#&gross_net=#attributes.gross_net#">
		</cfif>
		<cfif isdefined("attributes.expense_id") and len(attributes.expense_id) and isdefined("attributes.expense_code_name") and len(attributes.expense_code_name)>
			<cfset adres="#adres#&expense_id=#attributes.expense_id#&expense_code_name=#attributes.expense_code_name#">
		</cfif>
		<cfif isdefined("attributes.employee_id") and len(attributes.employee_id) and isdefined("attributes.employee") and len(attributes.employee)>
			<cfset adres="#adres#&employee_id=#attributes.employee_id#&employee=#attributes.employee#">
		</cfif>
		<cfif isdefined("attributes.shift_id") and len(attributes.shift_id)>
			<cfset adres="#adres#&shift_id=#attributes.shift_id#">
		</cfif>
		<cfif isdefined("attributes.account_code") and len(attributes.account_code) and isdefined("attributes.account_name") and len(attributes.account_name)>
			<cfset adres="#adres#&account_code=#attributes.account_code#&account_name=#attributes.account_name#">
		</cfif>
		<cfif isdefined("attributes.tax_exception_id") and len(attributes.tax_exception_id)>
			<cfset adres="#adres#&tax_exception_id=#attributes.tax_exception_id#">
		</cfif>
		<cfif isdefined("attributes.odkes_id") and len(attributes.odkes_id)>
			<cfset adres="#adres#&odkes_id=#attributes.odkes_id#">
		</cfif>
		<cfif isdefined("attributes.odkes_id2") and len(attributes.odkes_id2)>
			<cfset adres="#adres#&odkes_id2=#attributes.odkes_id2#">
		</cfif>
		<cfif isdefined("attributes.use_sabit_prim")>
			<cfset adres="#adres#&use_sabit_prim=#attributes.use_sabit_prim#">
		</cfif>
		<cfif isdefined("attributes.use_salary_type")>
			<cfset adres="#adres#&use_salary_type=#attributes.use_salary_type#">
		</cfif>
		<cfif isdefined("attributes.use_vardiya")>
			<cfset adres="#adres#&use_vardiya=#attributes.use_vardiya#">
		</cfif>
		<cfif isdefined("attributes.use_gross_net")>
			<cfset adres="#adres#&use_gross_net=#attributes.use_gross_net#">
		</cfif>
		<cfif isdefined("attributes.use_duty_type")>
			<cfset adres="#adres#&use_duty_type=#attributes.use_duty_type#">
		</cfif>
		<cfif isdefined("attributes.use_ssk_statute")>
			<cfset adres="#adres#&use_ssk_statute=#attributes.use_ssk_statute#">
		</cfif>
		<cfif isdefined("attributes.use_defection")>
			<cfset adres="#adres#&use_defection=#attributes.use_defection#">
		</cfif>
		<cfif isdefined("attributes.status") and len(attributes.status)>
			<cfset adres="#adres#&status=#attributes.status#">
		</cfif>
		<cf_paging page="#attributes.page#" 
		maxrows="#attributes.maxrows#" 
		totalrecords="#attributes.totalrecords#" 
		startrow="#attributes.startrow#"
		adres="#adres#&salary_year=#attributes.salary_year#&salary_month=#attributes.salary_month#">
</cfif>

<script type="text/javascript">


  function control()	
	{
		if(!date_check(search_ucret.in_date1,search_ucret.in_date2,"<cf_get_lang dictionary_id ='40310.Başlama Tarihi Bitiş Tarihinden Küçük Olmalıdır'>!")){
			return false;
		}
		if(document.search_ucret.is_excel.checked==false)
		{
			document.search_ucret.action="<cfoutput>#request.self#?fuseaction=#attributes.fuseaction#</cfoutput>"
			return true;
		}
		else
			document.search_ucret.action="<cfoutput>#request.self#?fuseaction=#fusebox.circuit#.emptypopup_employee_salary_analyse_report</cfoutput>"
    }
</script>

