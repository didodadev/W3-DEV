<cf_xml_page_edit fuseact="myhome.form_add_payment_request,myhome.welcome">
<cfparam name="attributes.is_installment" default="">
<cfparam name="attributes.from_hr" default="0">
<cfquery name="GET_PRIORITY" datasource="#DSN#">
	SELECT PRIORITY_ID,PRIORITY FROM SETUP_PRIORITY ORDER BY PRIORITY
</cfquery>
<cfquery name="PAY_METHODS" datasource="#DSN#">
	SELECT 
		SP.PAYMETHOD_ID,
		SP.PAYMETHOD 
	FROM 
		SETUP_PAYMETHOD SP,
		SETUP_PAYMETHOD_OUR_COMPANY SPOC
	WHERE 
		SP.PAYMETHOD_STATUS = 1
		AND SP.PAYMETHOD_ID = SPOC.PAYMETHOD_ID 
		AND SPOC.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
</cfquery>
<cfquery name="GET_POSITION_DETAIL" datasource="#DSN#">
	SELECT UPPER_POSITION_CODE, UPPER_POSITION_CODE2 FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"> AND IS_MASTER = 1
</cfquery>
<cfquery name="GET_REQUEST_STAGE" datasource="#DSN#">
	SELECT
		PTR.STAGE,
		PTR.PROCESS_ROW_ID 
	FROM
		PROCESS_TYPE_ROWS PTR,
		PROCESS_TYPE_OUR_COMPANY PTO,
		PROCESS_TYPE PT
	WHERE
		PT.IS_ACTIVE = 1 AND
		PT.PROCESS_ID = PTR.PROCESS_ID AND
		PT.PROCESS_ID = PTO.PROCESS_ID AND
		PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
		PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%myhome.form_add_payment_request%">
	ORDER BY 
		PTR.LINE_NUMBER
</cfquery>
<!--- akış parametresinde belirtilen avans tutar limitine gore alınabilecek max avans degeri hesaplanır --->
<cfquery name="get_salary" datasource="#dsn#">
	SELECT 
		M#month(now())# SALARY,
		SALARY_TYPE
	FROM
		EMPLOYEES_SALARY ES,
		EMPLOYEES_IN_OUT EIO
	WHERE
		ES.IN_OUT_ID = EIO.IN_OUT_ID AND
		ES.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"> AND 
		ES.PERIOD_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_year#"> 
		AND
		(
			(EIO.FINISH_DATE IS NULL AND EIO.START_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">)
			OR
			EIO.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
		)
</cfquery>
<cfquery name="get_in_out" datasource="#dsn#" maxrows="1">
	SELECT PUANTAJ_GROUP_IDS,BRANCH_ID FROM EMPLOYEES_IN_OUT WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"> AND FINISH_DATE IS NULL ORDER BY START_DATE DESC
</cfquery>
<cfif get_in_out.recordcount>
	<cfset attributes.branch_id = get_in_out.branch_id>
	<cfif len(get_in_out.puantaj_group_ids)>
		<cfset attributes.group_id = "#get_in_out.puantaj_group_ids#,">
	</cfif>
</cfif>
<cfset attributes.sal_year = year(now())>
<cfset attributes.sal_mon = month(now())>
<cfinclude template="../../hr/ehesap/query/get_program_parameter.cfm">
<cfquery name="get_demand_type" datasource="#dsn#">
	SELECT * FROM SETUP_PAYMENT_INTERRUPTION WHERE ISNULL(IS_DEMAND,0) = 1
</cfquery>
<!--- gunluk-saatlik-aylık --->
<cfif len(get_program_parameters.LIMIT_PAYMENT_REQUEST) and get_salary.recordcount and len(get_salary.salary)>
	<cfquery name="get_monthly_work_hours" datasource="#dsn#">
		SELECT SSK_MONTHLY_WORK_HOURS FROM OUR_COMPANY_HOURS WHERE OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
	</cfquery>
	<cfif get_salary.salary_type eq 0>
		<cfset max_payment_request = get_salary.salary*get_program_parameters.LIMIT_PAYMENT_REQUEST/100*get_monthly_work_hours.SSK_MONTHLY_WORK_HOURS>
	<cfelseif get_salary.salary_type eq 1>
		<cfset max_payment_request = get_salary.salary*get_program_parameters.LIMIT_PAYMENT_REQUEST/100*30>
	<cfelse>
		<cfset max_payment_request = (get_salary.salary*get_program_parameters.LIMIT_PAYMENT_REQUEST)/100>
	</cfif>
<cfelse>
	<cfset max_payment_request = 9999>
</cfif>
<cfquery name="get_last_payment_request" datasource="#dsn#">
	SELECT SUM(AMOUNT) AS TOTAL_AMOUNT FROM CORRESPONDENCE_PAYMENT WHERE TO_EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"> AND YEAR(RECORD_DATE) = YEAR(GETDATE()) AND MONTH(RECORD_DATE) = MONTH(GETDATE()) AND (STATUS IS NULL OR STATUS = 1)
</cfquery>
<cfif get_last_payment_request.recordcount and get_last_payment_request.TOTAL_AMOUNT gt 0>
	<cfset max_payment_request = max_payment_request-get_last_payment_request.TOTAL_AMOUNT>
</cfif>
<!--- akış parametresinde belirtilen avans tutar limitine gore alınabilecek max avans degeri hesaplanır --->
<cfif not get_request_stage.recordcount>
	<script type="text/javascript">
		alert("<cf_get_lang dictionary_id='54610.Avans Süreçleri Tanımlı Değil'>!");
		history.back();
	</script>
	<cfabort>
</cfif>
<cf_catalystHeader>
<div class="col col-12 col-md-12 col-xs-12">	
	<cf_box id="avans" closable="0">
		<cf_tab divId="sayfa_1,sayfa_2" defaultOpen="sayfa_#attributes.is_installment#" divLang="#getLang('','Avans',58204)#;#getLang('','Taksitli Avans',64980)#" tabcolor="fff">
			<div id="unique_sayfa_1" class="uniqueBox">
				<cfform  name="form_add_payment_request" method="post" action="#request.self#?fuseaction=myhome.emptypopup_add_payment_request">
						<input type="hidden" name="request_stage" id="request_stage" value="<cfif get_request_stage.recordcount><cfoutput>#get_request_stage.process_row_id#</cfoutput></cfif>">
						<input type="hidden" name="from_hr" id="from_hr" value="<cfoutput>#attributes.from_hr#</cfoutput>">
						<input type="hidden" name="max_payment_request" id="max_payment_request" value="<cfoutput>#max_payment_request#</cfoutput>">
						<cf_box_elements>
							<div class="col col-6 col-md-6 col-sm-12 col-xs-12" type="column" index="1" sort="true">
								<div class="form-group" id="item-pos_code">
									<label class="col col-4 col-sm-2"><cf_get_lang dictionary_id='57576.Calışan'></label>
									<input type="hidden" name="pos_code" id="pos_code" value="<cfoutput>#session.ep.position_code#</cfoutput>">
									<input type="hidden" name="pos_code_name" id="pos_code_name" value="<cfoutput>#session.ep.position_name#</cfoutput>">
									<input type="hidden" name="emp_id" id="emp_id" value="<cfoutput>#session.ep.userid#</cfoutput>">
									<div class="col col-8 col-sm-12 col-xs-12">
										<cfif isdefined("x_select_emp") and x_select_emp eq 1>
											<div class="input-group">
												<input name="emp_name" type="text" id="emp_name" value="<cfoutput>#session.ep.name# #session.ep.surname#</cfoutput>" readonly><!---onFocus="AutoComplete_Create('emp_name','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','emp_id','form_add_payment_request','3','140');" autocomplete="off"--->
												<span class="input-group-addon btnPointer icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&call_function=change_upper_pos_codes()&field_code=form_add_payment_request.pos_code&field_pos_name=form_add_payment_request.pos_code_name&field_name=form_add_payment_request.emp_name&field_emp_id=form_add_payment_request.emp_id&upper_pos_code=<cfoutput>#session.ep.position_code#</cfoutput>&select_list=1&show_rel_pos=1','list');return true"></span>
											</div>
										<cfelse>
											<input name="emp_name" type="text" id="emp_name" value="<cfoutput>#session.ep.name# #session.ep.surname#</cfoutput>" readonly><!---onFocus="AutoComplete_Create('emp_name','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','emp_id','form_add_payment_request','3','140');" autocomplete="off"--->
										</cfif>
									</div>
								</div>
								<div class="form-group" id="item-process_cat">
									<label class="col col-4 col-sm-12 col-xs-12"><cf_get_lang dictionary_id ='58859.Süreç'></label>
									<div class="col col-8 col-sm-12 col-xs-12"><cf_workcube_process is_upd='0' process_cat_width='200' is_detail='0'></div>
								</div>
								<div class="form-group" id="item-demand_type">
									<label class="col col-4 col-sm-12 col-xs-12"><cf_get_lang dictionary_id='31578.Avans Tipi'></label>
									<div class="col col-8 col-sm-12 col-xs-12">
										<select name="demand_type" id="demand_type">
											<option value="-1"><cf_get_lang dictionary_id='57734.Seçiniz'></option>
											<cfoutput query="get_demand_type">
												<option value="#odkes_id#">#comment_pay#</option>
											</cfoutput>
										</select>
									</div>
								</div>
								<div class="form-group" id="item-subject">
									<label class="col col-4 col-sm-12 col-xs-12"><cf_get_lang dictionary_id='57480.Başlık'>*</label>
									<div class="col col-8 col-sm-12 col-xs-12">
										<cfsavecontent variable="message"><cf_get_lang dictionary_id='58059.Başlık Girmelisiniz'></cfsavecontent>
										<cfinput type="text" name="subject" required="Yes" message="#message#">
									</div>
								</div>
								<div class="form-group" id="item-detail">
									<label class="col col-4 col-sm-12 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
									<div class="col col-8 col-sm-12 col-xs-12">
										<textarea name="detail" id="detail"></textarea>
									</div>
								</div>
								<div class="form-group" id="item-emp_name_cc">
									<label class="col col-4 col-sm-12 col-xs-12"><cf_get_lang dictionary_id='57556.Bilgi'></label>
									<div class="col col-8 col-sm-12 col-xs-12"><input type="hidden" name="emp_id_cc" id="emp_id_cc">
										<div class="input-group">
											<input type="text" name="emp_name_cc" id="emp_name_cc" value="" readonly>
											<span class="input-group-addon btnPointer icon-ellipsis"onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=form_add_payment_request.emp_id_cc&field_name=form_add_payment_request.emp_name_cc&select_list=1</cfoutput>','list');"></span>
										</div>
									</div>
								</div>
								<div class="form-group" id="item-priority">
									<label class="col col-4 col-sm-12 col-xs-12"><cf_get_lang dictionary_id='57485.Öncelik'></label>
									<div class="col col-8 col-sm-12 col-xs-12">
										<select name="priority" id="priority">
											<cfoutput query="get_priority">
												<option value="#get_priority.priority_id#">#priority# </option>
											</cfoutput>
										</select>
									</div>
								</div>
								<div class="form-group" id="item-due_date">
									<label class="col col-4 col-sm-12 col-xs-12"><cf_get_lang dictionary_id='57742.Tarih'>*</label>
									<cfsavecontent variable="message"><cf_get_lang dictionary_id='58503.Lutfen Tarih Giriniz'> !</cfsavecontent>
									<div class="col col-8 col-sm-12 col-xs-12">
										<div class="input-group">
											<cfinput validate="#validate_style#" value="#dateformat(now(),dateformat_style)#" required="Yes" message="#message#" type="text" name="due_date">
											<span class="input-group-addon"><cf_wrk_date_image date_field="due_date"></span>
										</div>
									</div>
								</div>
								<cfif isdefined("xml_show_paymethod") and xml_show_paymethod eq 1>
									<div class="form-group" id="item-pay_method">
										<label class="col col-4 col-sm-12 col-xs-12"><cf_get_lang dictionary_id='58516.Ödeme Yöntemi'></label>
										<div class="col col-8 col-sm-12 col-xs-12">
											<select name="pay_method" id="pay_method">
												<cfoutput query="pay_methods">
													<option value="#paymethod_id#">#paymethod#</option>
												</cfoutput>
											</select>
										</div>
									</div>
								</cfif>
								<div class="form-group" id="item-amount">
									<label class="col col-4 col-sm-12 col-xs-12"><cf_get_lang dictionary_id='57673.Tutar'>*</label>
									<div class="col col-8 col-sm-12 col-xs-12">
										<div class="input-group">
											<cfsavecontent variable="message"><cf_get_lang dictionary_id='29535.Tutar Girmelisiniz'> !</cfsavecontent>
											<cfinput type="text" name="amount" id="amount" required="yes" onkeyup="return(FormatCurrency(this,event));" message="#message#" class="moneybox" style="width:145px;">
											<span class="input-group-addon width">
												<cfquery name="GET_MONEYS" datasource="#DSN#">
													SELECT MONEY_ID,MONEY FROM SETUP_MONEY WHERE PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">
												</cfquery>
												<select name="MONEY_ID" id="MONEY_ID" style="width:50px;">
													<cfoutput query="get_moneys">
														<option value="#money#"<cfif money eq session.ep.money>selected</cfif>>#money#</option>
													</cfoutput>
												</select>
											</span>	
										</div>
									</div>
								</div>
								<!----<div class="form-group" id="item-valid_name">
									<label class="col col-4 col-sm-2"><cf_get_lang_main no ='88.Onay'>1</label>
									<div class="col col-4 col-sm-12 col-xs-12">
										<input type="hidden" name="validator_pos_code" id="validator_pos_code" value="<cfif  isdefined("get_position_detail.upper_position_code") and len(get_position_detail.upper_position_code)><cfoutput>#get_position_detail.upper_position_code#</cfoutput></cfif>">
										<cfif isdefined("get_position_detail.upper_position_code") and len(get_position_detail.upper_position_code)>
											<input type="text" name="valid_name" id="valid_name" readonly="yes" value="<cfoutput>#get_emp_info(get_position_detail.upper_position_code,1,0)#</cfoutput>" style="width:145px;">
										<cfelse>
											<input type="text" name="valid_name" id="valid_name" readonly="yes" value="" style="width:145px;">
										</cfif>
										<cfif isdefined('xml_select_manager') and xml_select_manager eq 1>
											<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_code=form_add_payment_request.validator_pos_code&field_name=form_add_payment_request.valid_name','list');return false"><img src="/images/plus_thin.gif"  align="absmiddle" border="0"></a>
										</cfif>
									</div>
								</div>
								<div class="form-group" id="item-valid_name2">
									<label class="col col-4 col-sm-2"><cf_get_lang_main no ='88.Onay'>2</label>
									<div class="col col-4 col-sm-12 col-xs-12">
										<input type="hidden" name="validator_pos_code2" id="validator_pos_code2" value="<cfif isdefined("get_position_detail.upper_position_code2") and len(get_position_detail.upper_position_code2)><cfoutput>#get_position_detail.upper_position_code2#</cfoutput></cfif>">
										<cfif isdefined("get_position_detail.upper_position_code2") and len(get_position_detail.upper_position_code2)>
											<input type="text" name="valid_name2" id="valid_name2" readonly="yes" value="<cfoutput>#get_emp_info(get_position_detail.upper_position_code2,1,0)#</cfoutput>" style="width:145px;">
										<cfelse>
											<input type="text" name="valid_name2" id="valid_name2" readonly="yes" value="" style="width:145px;">
										</cfif>
										<cfif isdefined('xml_select_manager') and xml_select_manager eq 1>
											<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_code=form_add_payment_request.validator_pos_code2&field_name=form_add_payment_request.valid_name2','list');return false"><img src="/images/plus_thin.gif"  align="absmiddle" border="0"></a>
										</cfif>
									</div>
								</div>--->
							</div>
						</cf_box_elements>
					<cf_box_footer><cf_workcube_buttons is_upd='0' type_format='1' add_function='control()'></cf_box_footer>
				</cfform>
			</div>
			<div id="unique_sayfa_2" class="uniqueBox">
				<cfinclude  template="../form/form_add_inst_request.cfm"> 
			</div>
		</cf_tab>
	</cf_box>
</div>
<script>
function change_upper_pos_codes()
{
	var emp_upper_pos_code = wrk_query('SELECT UPPER_POSITION_CODE,UPPER_POSITION_CODE2,POSITION_CODE FROM EMPLOYEE_POSITIONS WHERE POSITION_CODE = '+document.form_add_payment_request.pos_code.value,'dsn');
	var emp_upper_pos_name = wrk_query('SELECT E.EMPLOYEE_NAME FROM EMPLOYEE_POSITIONS EP,EMPLOYEES E WHERE E.EMPLOYEE_ID = EP.EMPLOYEE_ID AND EP.POSITION_CODE = '+emp_upper_pos_code.UPPER_POSITION_CODE,'dsn');
	var emp_upper_pos_surname = wrk_query('SELECT E.EMPLOYEE_SURNAME FROM EMPLOYEE_POSITIONS EP,EMPLOYEES E WHERE E.EMPLOYEE_ID = EP.EMPLOYEE_ID AND EP.POSITION_CODE = '+emp_upper_pos_code.UPPER_POSITION_CODE,'dsn');
	var emp_upper_pos_name2 = wrk_query('SELECT E.EMPLOYEE_NAME  FROM EMPLOYEE_POSITIONS EP,EMPLOYEES E WHERE E.EMPLOYEE_ID = EP.EMPLOYEE_ID AND EP.POSITION_CODE = '+emp_upper_pos_code.UPPER_POSITION_CODE2,'dsn');
	var emp_upper_pos_surname2 = wrk_query('SELECT E.EMPLOYEE_SURNAME  FROM EMPLOYEE_POSITIONS EP,EMPLOYEES E WHERE E.EMPLOYEE_ID = EP.EMPLOYEE_ID AND EP.POSITION_CODE = '+emp_upper_pos_code.UPPER_POSITION_CODE2,'dsn');
	//akış parametresinde belirtilen avans tutar limitine gore alınabilecek max avans degeri hesaplanır
	var todayDate = new Date();
	var month_ = todayDate.getMonth()+1;
	var get_salary_ = wrk_query('SELECT M'+month_+' SALARY,SALARY_TYPE,BRANCH_ID,PUANTAJ_GROUP_IDS FROM EMPLOYEES_SALARY ES,EMPLOYEES_IN_OUT EIO WHERE ES.IN_OUT_ID = EIO.IN_OUT_ID AND ES.PERIOD_YEAR = <cfoutput>#session.ep.period_year#</cfoutput> AND ((EIO.FINISH_DATE IS NULL AND EIO.START_DATE < GETDATE()) OR (EIO.FINISH_DATE >= GETDATE())) AND EIO.EMPLOYEE_ID='+document.form_add_payment_request.emp_id.value,'dsn');
	var get_monthly_work_hours_ = wrk_query('SELECT SSK_MONTHLY_WORK_HOURS FROM OUR_COMPANY_HOURS  WHERE OUR_COMPANY_ID = <cfoutput>#session.ep.company_id#</cfoutput>','dsn');
	var get_last_payment_request_ = wrk_query('SELECT SUM(AMOUNT) AS TOTAL_AMOUNT FROM CORRESPONDENCE_PAYMENT WHERE TO_EMPLOYEE_ID = '+ document.getElementById('emp_id').value +' AND YEAR(RECORD_DATE) = YEAR(GETDATE()) AND MONTH(RECORD_DATE) = MONTH(GETDATE()) AND (STATUS IS NULL OR STATUS = 1)','dsn');
	var last_payment_request = 0;
	if(get_last_payment_request_.recordcount && get_last_payment_request_.TOTAL_AMOUNT > 0)
	{
		last_payment_request =  get_last_payment_request_.TOTAL_AMOUNT;
	}
	if(get_salary_.recordcount)
	{	
		var branch_id_ = get_salary_.BRANCH_ID;
		var group_id_ = get_salary_.PUANTAJ_GROUP_IDS+',';
		var sql = "SELECT LIMIT_PAYMENT_REQUEST,PARAMETER_ID FROM SETUP_PROGRAM_PARAMETERS  WHERE GETDATE() BETWEEN STARTDATE AND FINISHDATE AND ','+BRANCH_IDS+',' LIKE '%,"+branch_id_+",%' AND ";
		sql = sql+"(";
		if(group_id_ != '')
		{
			for(var jj=1;jj <= list_len(group_id_)-1;jj++)
			{
				if(list_len(group_id_)-1 != jj)
				{sql = sql+" ','+GROUP_IDS+',' LIKE '%,"+list_getat(group_id_,jj,',')+",%' OR ";}
				else
				{sql = sql+"','+GROUP_IDS+',' LIKE '%,"+list_getat(group_id_,jj,',')+",%'";}
			}
		}
		else
		{
			sql = sql+" GROUP_IDS IS NULL";	
		}
		sql=sql+")";
		var get_program_parameters_ = wrk_query(sql,'dsn');
		if(get_program_parameters_.recordcount > 1)
		{
			alert("<cf_get_lang dictionary_id='59984.Çalışanın akış parametresi birden fazla olamaz kontrol ediniz'>");
			return false;
		}
		if(get_program_parameters_.LIMIT_PAYMENT_REQUEST)
		{
			if(get_salary_.SALARY_TYPE == 0)
			{
				var max_payment_request_ = get_salary_.SALARY*get_program_parameters_.LIMIT_PAYMENT_REQUEST/100*get_monthly_work_hours_.SSK_MONTHLY_WORK_HOURS;
				document.getElementById('max_payment_request').value = max_payment_request_-last_payment_request;
			}
			else if(get_salary_.SALARY_TYPE == 1)
			{
				var max_payment_request_ = get_salary_.SALARY*get_program_parameters_.LIMIT_PAYMENT_REQUEST/100*30;
				document.getElementById('max_payment_request').value = max_payment_request_-last_payment_request;
			}
			else if(get_salary_.SALARY_TYPE == 2)
			{
				var max_payment_request_ = (get_salary_.SALARY*get_program_parameters_.LIMIT_PAYMENT_REQUEST)/100;
				document.getElementById('max_payment_request').value = max_payment_request_-last_payment_request;
			}
		}
	}
	else
	{
		var max_payment_request_ = 9999;
		document.getElementById('max_payment_request').value = max_payment_request_-last_payment_request;
	}
	//akış parametresinde belirtilen avans tutar limitine gore alınabilecek max avans degeri hesaplanır
	if(<cfoutput>#session.ep.position_code#</cfoutput> != document.form_add_payment_request.pos_code.value)
	{
		if(emp_upper_pos_code.UPPER_POSITION_CODE)
			document.getElementById('validator_pos_code').value = emp_upper_pos_code.UPPER_POSITION_CODE;
		else
			document.getElementById('validator_pos_code').value = '';
		if(emp_upper_pos_name.EMPLOYEE_NAME)
			document.getElementById('valid_name').value = emp_upper_pos_name.EMPLOYEE_NAME;
		else
			document.getElementById('valid_name').value = '';
		if(emp_upper_pos_surname.EMPLOYEE_SURNAME)
			document.getElementById('valid_name').value += ' ' + emp_upper_pos_surname.EMPLOYEE_SURNAME;
		else
			document.getElementById('valid_name').value = '';
		if(emp_upper_pos_code.UPPER_POSITION_CODE2)
			document.getElementById('validator_pos_code2').value = emp_upper_pos_code.UPPER_POSITION_CODE2;
		else
			document.getElementById('validator_pos_code2').value = '';
		if(emp_upper_pos_name2.EMPLOYEE_NAME)
			document.getElementById('valid_name2').value = emp_upper_pos_name2.EMPLOYEE_NAME;
		else
			document.getElementById('valid_name2').value = '';
		if(emp_upper_pos_surname2.EMPLOYEE_SURNAME)
			document.getElementById('valid_name2').value += ' ' + emp_upper_pos_surname2.EMPLOYEE_SURNAME;
		else
			document.getElementById('valid_name2').value = '';
	}
}
function control()
{
	form_add_payment_request.amount.value = filterNum(form_add_payment_request.amount.value);
	if(parseInt(document.getElementById('amount').value) > parseInt(document.getElementById('max_payment_request').value))
	{
		alert("<cf_get_lang dictionary_id='59985.Talep edilen avansın maximum olabilecek değeri'>:" + document.getElementById('max_payment_request').value);
		return false;
	}
	x = (250 - form_add_payment_request.detail.value.length);
	if ( x < 0 )
	{ 
		alert ("<cf_get_lang dictionary_id ='57629.Açıklama'>"+ ((-1) * x) +"<cf_get_lang dictionary_id='29538.Karakter Uzun'>");
		return false;
	}
	//form_add_payment_request.max_payment_request.value = filterNum(form_add_payment_request.max_payment_request.value);
	x = document.getElementById('demand_type').selectedIndex;
	if(document.form_add_payment_request.demand_type[x].value == -1)
	{
		alert("<cf_get_lang dictionary_id='31852.Avans tipi seçiniz'>");
		return false;
	}
	return process_cat_control();
	
}
</script>