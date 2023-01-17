<cf_xml_page_edit fuseact="ehesap.form_add_position_in">
<cfscript>
	my_employee_id = '';
	my_position_code = '';
	my_position_name = '';
	my_branch_id = '';
	my_branch = '';
	my_department_id = '';
	my_department = '';
	my_kidem_date = now();
	use_ssk = 1;
	socialsecurity_no = "";
	gross_net = 0;
	salary_type = 2;
	emp_business_code_id = '';
	emp_business_code_name = '';
	emp_business_code = '';
	/*cmp_business_code = createobject("component","V16.hr.ehesap.cfc.get_business_codes");
	cmp_business_code.dsn = dsn;
	get_business_codes = cmp_business_code.get_business_code();*/
	if (isdefined("attributes.position_code"))
	{
		include "../query/get_position.cfm";
		my_employee_id = get_position.employee_id;
		my_position_code = get_position.position_code;
		my_position_name = '#get_position.employee_name# #get_position.employee_surname#';
		my_branch_id = get_position.branch_id;
		my_branch = get_position.branch_name;
		my_department_id = get_position.department_id;
		my_department = get_position.department_head;
		if(len(get_position.kidem_date))
			my_kidem_date = get_position.kidem_date;
		if(len(get_position.business_code_id))
		{
			emp_business_code_id = get_position.business_code_id;
			emp_business_code_name = get_position.business_code_name;
			emp_business_code = get_position.business_code;
		}
	}
	else if (isdefined("attributes.employee_id"))
	{
		cmp_branch_dept = createobject("component","V16.hr.ehesap.cfc.get_branch_dept_info");
		cmp_branch_dept.dsn = dsn;
		get_branch_dept_info = cmp_branch_dept.get_branch_dept_info(employee_id : attributes.employee_id);
		my_employee_id = attributes.employee_id;
		my_position_name = "#get_emp_info(attributes.employee_id,0,0)#";
		my_branch_id = get_branch_dept_info.branch_id;
		my_branch = get_branch_dept_info.branch_name;
		my_department_id = get_branch_dept_info.department_id;
		my_department = get_branch_dept_info.department_head;
		if(len(get_branch_dept_info.business_code_id))
		{
			emp_business_code_id = get_branch_dept_info.business_code_id;
			emp_business_code_name = get_branch_dept_info.business_code_name;
			emp_business_code = get_branch_dept_info.business_code;
		}
	}
	
	if (len(my_employee_id))
	{
		cmp = createobject("component","V16.hr.ehesap.cfc.get_emp_last_in_out");
		cmp.dsn = dsn;
		get_emp_last_in_out = cmp.get_emp_last_in_out(employee_id : my_employee_id, date_ : now());
		if (get_emp_last_in_out.recordcount and len(get_emp_last_in_out.in_out_id))
		{
			use_ssk = get_emp_last_in_out.use_ssk;
			socialsecurity_no = get_emp_last_in_out.socialsecurity_no;
			gross_net = get_emp_last_in_out.gross_net;
			salary_type = get_emp_last_in_out.salary_type;
			if (emp_business_code_id eq '' and len(get_emp_last_in_out.business_code_id))
			{
				emp_business_code_id = get_emp_last_in_out.business_code_id;
				emp_business_code_name = get_emp_last_in_out.business_code_name;
				emp_business_code = get_emp_last_in_out.business_code;
			}
		}
	}
</cfscript>

<cfif not isdefined('attributes.position_code') and isdefined('attributes.employee_id')>
	<cfquery name="get_kidem_date" datasource="#dsn#">
		SELECT KIDEM_DATE FROM EMPLOYEES WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">
	</cfquery>
	<cfif len(get_kidem_date.kidem_date)>
		<cfset my_kidem_date = get_kidem_date.kidem_date>
	</cfif>
</cfif>
<cfset get_service_class = createObject("component","V16.settings.cfc.service_class").listServiceClass()/>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box title="#getLang('','İşe Giriş Çıkışlar','52965')#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
		<cfform name="add_in_out" method="post" action="#request.self#?fuseaction=ehesap.emptypopup_add_position_in">
            <cfinput type="hidden" name="draggable" id="draggable" value="#iif(isdefined("attributes.draggable"),1,0)#"> 
			<cf_box_elements>
				<div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
					<div class="form-group" id="item-process_cat">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='58859.Süreç'></label>
						<div class="col col-8 col-xs-12">
							<cf_workcube_process is_upd='0' process_cat_width='130' is_detail='0'>
						</div>
					</div>
					<div class="form-group" id="item-use_ssk">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='53606.SSK Durumu'></label>
						<div class="col col-8 col-xs-12">
							<select  name="use_ssk" id="use_ssk" <cfif xml_salaryparam_pay eq 1>onchange="change_use_ssk(this.value)"</cfif>>
								<option value="1"><cf_get_lang dictionary_id='45049.Worker'></option>
								<option value="2"><cf_get_lang dictionary_id='62870.Memur'></option>
								<option value="3"><cf_get_lang dictionary_id='62871.Serbest Çalışan'></option>
							</select>
						</div>
					</div>
					<cfif xml_sgk_no eq 1>
						<div class="form-group" id="item-socialsecurity_no">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='53237.SSK No'></label>
							<div class="col col-8 col-xs-12">
								<cfinput type="text" name="socialsecurity_no" onKeyUp="isNumber(this);" maxlength="13" value="#socialsecurity_no#">
							</div>
						</div>
					</cfif>
					<div class="form-group" id="item-employee_id">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57576.Çalışan'>*</label>
						<div class="col col-8 col-xs-12">
							<div class="input-group">
								<input type="hidden" name="employee_id" id="employee_id" value="<cfoutput>#my_employee_id#</cfoutput>">
								<cfsavecontent variable="message"><cf_get_lang dictionary_id="57471.Eksik Veri"> : <cf_get_lang dictionary_id ='58497.Pozisyon'></cfsavecontent>
								<cfinput type="text" name="employee" id="employee" value="#my_position_name#" readonly required="yes" message="#message#">
								<span class="input-group-addon icon-ellipsis btnPointer" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=hr.popup_list_emps&field_id=add_in_out.employee_id&field_name=add_in_out.employee&conf_=1&field_tc_no=add_in_out.tc_identy_no&field_birth_date=add_in_out.birth_date&field_branch_id=add_in_out.branch_id&field_branch=add_in_out.branch&field_dept_id=add_in_out.department_id&field_dept_head=add_in_out.department&bes_kontrol=1</cfoutput>&run_function=get_bill_type()','','ui-draggable-box-medium');"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-branch">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57453.Şube'>*</label>
						<div class="col col-8 col-xs-12">
							<input type="hidden" name="branch_id" id="branch_id" value="<cfoutput>#my_branch_id#</cfoutput>">
							<input type="text" name="branch" id="branch" value="<cfoutput>#my_branch#</cfoutput>" readonly>
						</div>
					</div>
					<div class="form-group" id="item-department_id">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57572.Department'>*</label>
						<div class="col col-8 col-xs-12">
							<div class="input-group">
								<input type="hidden" name="department_id" id="department_id" value="<cfoutput>#my_department_id#</cfoutput>">
								<cfsavecontent variable="message1"><cf_get_lang dictionary_id="58194.Zorunlu Alan"> : <cf_get_lang dictionary_id='57453.Şube'> - <cf_get_lang dictionary_id='57572.Department'></cfsavecontent>
								<cfinput type="text" name="department" id="department" value="#my_department#" readonly required="yes" message="#message1#">
								<span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('<cfoutput>#request.self#?fuseaction=hr.popup_list_departments&field_id=add_in_out.department_id&field_name=add_in_out.department&field_branch_name=add_in_out.branch&field_branch_id=add_in_out.branch_id&is_only_sgk_departments=1</cfoutput>&run_function=get_bill_type()'),'list';"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-tc_identy_no"> 
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='58025.TC Kimlik'></label>
						<div class="col col-8 col-xs-12">
							<cfif len(my_employee_id)>
								<cfquery name="get_tc_identy" datasource="#dsn#">
									SELECT EI.TC_IDENTY_NO FROM EMPLOYEES E,EMPLOYEES_IDENTY EI WHERE E.EMPLOYEE_ID = #my_employee_id# AND EI.EMPLOYEE_ID = E.EMPLOYEE_ID
								</cfquery>
							</cfif>
							<input type="text" name="tc_identy_no" id="tc_identy_no" maxlength="11" value="<cfif len(my_employee_id)><cfoutput>#get_tc_identy.tc_identy_no#</cfoutput></cfif>">
						</div>
					</div>
					<div class="form-group" id="item-business_code_id">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="53861.Meslek Grubu"></label>
						<div class="col col-8 col-xs-12">
							<div class="input-group">
								<input type="hidden" name="business_code_id" id="business_code_id" value="<cfoutput>#emp_business_code_id#</cfoutput>">
								<input type="text" name="business_code" id="business_code" value="<cfoutput>#emp_business_code_name# <cfif len(emp_business_code)>(#emp_business_code#)</cfif></cfoutput>" style="width:230px;">
								<span class="input-group-addon icon-ellipsis btnPointer" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_business_codes&field_id=add_in_out.business_code_id&field_name=add_in_out.business_code</cfoutput>','list');"></span>
							</div>
						</div>
					</div>
					<div id="is_officer" style="display:none">
						<div class="form-group" id="item-administrative_academic">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='46563.Akademik'> - <cf_get_lang dictionary_id='58428.idari'></label>
							<div class="col col-8 col-xs-12">
								<select name="administrative_academic" id="administrative_academic">
									<option value="0"><cf_get_lang dictionary_id='58428.idari'></option>
									<option value="1"><cf_get_lang dictionary_id='46563.Akademik'></option>
									<option value="2"><cf_get_lang dictionary_id='64624.Emekli Akademik'></option>
								</select>
							</div>
						</div>
						<div class="form-group" id="item-service_class">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='64104.Hizmet Sınıfı'>*</label>
							<div class="col col-8 col-xs-12">
								<select name="service_class" id="service_class" onchange="get_service_title(this.value)">
									<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
									<cfoutput query="get_service_class">
										<option value="#SERVICE_CLASS_ID#">#SERVICE_CLASS#</option>
									</cfoutput>
								</select>
							</div>
						</div>
						<div class="form-group" id="item-service_title">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='64617.Unvan Kodu'>- <cf_get_lang dictionary_id='64618.Unvan Adı'></label>
								<div class="col col-8 col-xs-12">
									<cfinput type="hidden" name="service_title_id" id="service_title_id" value="">
									<select name="service_title" id="service_title" onchange="get_title_detail(this.value)"></select>
								</div>
						</div>
						<div class="form-group" id="item-service_title_detail">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='64616.Unvan Detayı'></label>
								<div class="col col-8 col-xs-12">
									<input type="text" name="service_title_detail" id="service_title_detail">
								</div>
						</div>
					</div>
					<div class="form-group" id="item-START_DATE">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='53348.İşe Giriş Tarihi'>*</label>
						<div class="col col-8 col-xs-12">
							<div class="input-group">
								<cfsavecontent variable="alert"><cf_get_lang dictionary_id="58194.Zorunlu alan"> : <cf_get_lang dictionary_id ='58053.Başlangıç Tarihi'></cfsavecontent>
								<cfinput type="text" name="START_DATE" id="START_DATE" value="#dateformat(my_kidem_date,dateformat_style)#" validate="#validate_style#" message="#alert#" maxlength="10" required="yes">
								<span class="input-group-addon"><cf_wrk_date_image date_field="START_DATE"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-GROSS_NET">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='53131.Brüt'> / <cf_get_lang dictionary_id='58083.Net'></label>
						<div class="col col-8 col-xs-12">
								<select name="GROSS_NET" id="GROSS_NET">
								<option value="0" <cfif gross_net eq 0>selected</cfif>><cf_get_lang dictionary_id='53131.Brüt'></option>
								<option value="1" <cfif gross_net eq 1>selected</cfif>><cf_get_lang dictionary_id='58083.Net'></option>
								</select>
						</div>
					</div>
					<div class="form-group" id="item-SALARY_TYPE">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='53554.Ücret Yöntemi'></label>
						<div class="col col-8 col-xs-12">
							<select name="SALARY_TYPE" id="SALARY_TYPE">
								<option value="2" <cfif salary_type eq 2>selected</cfif>><cf_get_lang dictionary_id='58724.Ay'></option>
								<option value="1" <cfif salary_type eq 1>selected</cfif>><cf_get_lang dictionary_id='57490.Gün'></option>
								<option value="0" <cfif salary_type eq 0>selected</cfif>><cf_get_lang dictionary_id='57491.Saat'></option>
								</select>
						</div>
					</div>
					<cfif xml_salaryparam_pay eq 1>
						<div class="form-group" id="item-salaryparam_pay">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='53399.Additional Allowances'></label>
							<div class="col col-8 col-xs-12">
								<select class="multiSelect" id="salaryparam_pay_id" name="salaryparam_pay_id" multiple="multiple">
								</select>
							</div>
						</div>
						<div class="form-group" id="item-salaryparam_pay_process">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='56249.Ek Ödenek'> <cf_get_lang dictionary_id ='58859.Süreç'></label>
							<div class="col col-8 col-xs-12">
								<cf_workcube_process select_name= "salaryparam_pay_process" select_id="salaryparam_pay_process" is_upd='0' is_detail='0' fusepath="ehesap.list_payments">
							</div>
						</div>
					</cfif>
					<div class="form-group" id="item-test_process">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='53639.Deneme Süreci'></label>
						<div class="col col-8 col-xs-12">
							<input type="checkbox" value="1" name="test_process" id="test_process" onchange="sec_form();">
						</div>
					</div>
					<div class="form-group" style="display:none" id="row_form1">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='53647.Uyarılacak Kişi'></label>
						<div class="col col-8 col-xs-12">
							<div class="input-group">
								<input type="hidden" name="caution_emp_id" id="caution_emp_id" value="<cfoutput>#session.ep.userid#</cfoutput>">
								<cfinput type="text" name="caution_emp" value="#get_emp_info(session.ep.userid,0,0)#" style="width:230px;" readonly="yes">
								<span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('<cfoutput>#request.self#?fuseaction=hr.popup_list_positions&field_emp_id=add_in_out.caution_emp_id&field_emp_name=add_in_out.caution_emp</cfoutput>&select_list=1','list');"></span>
							</div>
						</div>
					</div>
					<div class="form-group" style="display:none" id="row_form">
						<cfquery name="get_survey_form" datasource="#dsn#" maxrows="1">
							SELECT
								TOP 1 
								SM.SURVEY_MAIN_ID,
								SM.SURVEY_MAIN_HEAD
							FROM 
								CONTENT_RELATION CR,
								SURVEY_MAIN SM
							WHERE
								SM.TYPE = 6 AND
								CR.SURVEY_MAIN_ID = SM.SURVEY_MAIN_ID AND
								CR.RELATION_TYPE = 6 AND<!--- deneme süresi--->
								CR.RELATED_ALL =1 AND
								SM.IS_ACTIVE = 1
							ORDER BY
								SM.RECORD_DATE DESC		
						</cfquery>
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='29764.Form'></label>
						<div class="col col-8 col-xs-12">
							<div class="input-group">
								<input type="hidden" name="quiz_id" id="quiz_id" value="<cfoutput>#get_survey_form.SURVEY_MAIN_ID#</cfoutput>">
								<input type="text" name="quiz_name" id="quiz_name" value="<cfoutput>#get_survey_form.SURVEY_MAIN_HEAD#</cfoutput>" style="width:230px;">			
								<span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('<cfoutput>#request.self#?fuseaction=hr.popup_list_form_generators&type=6&is_form_generators=1&field_id=add_in_out.quiz_id&field_name=add_in_out.quiz_name</cfoutput>','list');" title="<cf_get_lang dictionary_id='57582.Ekle'>"></span>
							</div>
						</div>
					</div>
					<!--- Otomatik BES Uyarısı --->
					<cfif isDefined("attributes.employee_id")>
						<cfquery name="get_emp_birth_date" datasource="#dsn#" maxrows="1">
							SELECT
								BIRTH_DATE
							FROM
								EMPLOYEES_IDENTY
							WHERE
								EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">
						</cfquery>
					</cfif>
					<cfif isdefined("get_emp_birth_date.birth_date") and len(get_emp_birth_date.birth_date)>
						<cfset yasHesap = year(now()) - dateFormat(get_emp_birth_date.birth_date, 'yyyy')>
						<cfif isDefined("attributes.employee_id") AND (yasHesap lt 45)>
							<div class="form-group" id="item-birth_date"> 
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='61639.BES Uyarısı'></label>
								<div class="col col-8 col-xs-12">
									<label style="color:red;" id="birth_date" name="birth_date">İşe girişini yaptığınız personel 45 yaşın altında, otomatik bes tanımı yapılacaksa ücret kartından yapılabilir.</label>
								</div>
							</div>
						</cfif>
					</cfif>
					<div class="form-group" id="item-birth_date" hidden = "hidden"> 
						<div class="col col-8 col-xs-12">
						<label style="color:red;" id="birth_date" name="birth_date"></label>
					</div>
						
					<!--- Otomatik BES Uyarısı --->
					</div>
					<div class="form-group" id="ACCOUNT_BILL_TYPE_PLACE">
						<label class="col col-4 col-xs-12"></label>
						<cfif len(my_branch_id)>
							<cfquery name="get_period" datasource="#dsn#">
								SELECT 
									SP.PERIOD_ID 
								FROM 
									SETUP_PERIOD SP INNER JOIN OUR_COMPANY OC ON SP.OUR_COMPANY_ID = OC.COMP_ID
									INNER JOIN BRANCH B ON OC.COMP_ID = B.COMPANY_ID
								WHERE
									B.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#my_branch_id#"> AND
									SP.PERIOD_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#year(my_kidem_date)#">
							</cfquery>
							<cfscript>
								if(get_period.recordcount)
								{
									cmp = createObject("component","V16.hr.cfc.create_account_period");
									cmp.dsn = dsn;
									get_acc_def = cmp.get_account_definition(period_id : get_period.period_id,branch_id:my_branch_id,department_id:my_department_id);
									if(not get_acc_def.recordcount)
									{
										get_acc_def = cmp.get_account_definition(period_id : get_period.period_id,branch_id:my_branch_id);
									}	
									if(get_acc_def.recordcount)
									{
										get_account_bill_type = cmp.get_account_definiton_code_row(account_definition_id:get_acc_def.id);
									}
									else
									{
										get_account_bill_type.recordcount = 0;	
									}
								}
								else
									get_account_bill_type.recordcount = 0;	
							</cfscript>
							<cfif get_account_bill_type.recordcount>
								<input type="hidden" name="account_bill_type_count" id="account_bill_type_count" value="<cfoutput>#get_account_bill_type.recordcount#</cfoutput>">
								<b><cf_get_lang dictionary_id='54117.Muhasebe Kod Grubu'></b><br />
								<cfoutput query="get_account_bill_type">
									<label class="col col-4 col-xs-12"></label>
									<input type="radio" name="account_bill_type" id="account_bill_type" value="#account_bill_type#" <cfif currentrow eq 1> checked="checked"</cfif>> #definition#
									<br />
								</cfoutput>
							<cfelse>
								<input type="hidden" name="account_bill_type_count" id="account_bill_type_count" value="0">
							</cfif>
						</cfif>
					</div>
					<a href="javascript://" onclick="openEdu()" class="tableyazi"><cf_get_lang dictionary_id='844.En son eğitim bilgisi ekle'></a>					
				</div>
			</cf_box_elements>
			<cf_box_footer>
				<cf_workcube_buttons is_upd='0' add_function='control()'>
			</cf_box_footer>
		</cfform>
	</cf_box>
</div>
<script language="javascript">
	function openEdu() {
			employee_id = $("#employee_id").val();
	
			openBoxDraggable('index.cfm?fuseaction=hr.popup_form_upd_emp_training&employee_id='+employee_id);
		}
	<cfif xml_salaryparam_pay eq 1>
		$( document ).ready(function() {
			change_use_ssk(1);
		});
	</cfif>

	function sec_form()
	{
		if ($('#test_process').is(':checked') == true)
		{
			$('#row_form').css('display','');
			$('#row_form1').css('display','');
		}
		else
		{
			$('#row_form').css('display','none');
			$('#row_form1').css('display','none');
		}	
	}
	function get_bill_type()
	{	
		var branch_id = document.getElementById('branch_id').value;
		var department_id = document.getElementById('department_id').value;
		var startdate =  document.getElementById('START_DATE').value;
		if (branch_id != "" && department_id != "")
		{ 
			var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=ehesap.popup_ajax_list_account_bill_type&branch_id="+branch_id+"&department_id="+department_id+"&startdate="+startdate;
			AjaxPageLoad(send_address,'ACCOUNT_BILL_TYPE_PLACE',1,'İlişkili Kod Grupları');
		}
	}
	function control()
	{
		// eger şube veya departmana ait birden fazla tanımlı kod grubu var ise 1 tanesini seçmesi gerekiyor SG 20150413
		if(document.add_in_out.account_bill_type != undefined && document.add_in_out.account_bill_type.length > 0)
		{
			var account = "";
			for (i = 0; i < document.add_in_out.account_bill_type.length; i++)
			{
				if ( document.add_in_out.account_bill_type[i].checked) 
				{
					account = document.add_in_out.account_bill_type[i].value;
					break;
				}
			}
		}
		if($('#use_ssk').val() == 2 && $('#service_class').val() == ""){
			alert("<cf_get_lang dictionary_id='58194.Zorunlu Alan'>: <cf_get_lang dictionary_id='64104.Hizmet Sınıfı'>");
			return false;
		}
		if(account != undefined && account == "")
		{
			alert('<cf_get_lang dictionary_id="54117.Muhasebe Kod Grubu">!');	
			return false;
		}
		if($('#test_process').is(':checked') == true && ($('#quiz_id').val() == "" || $('#quiz_name').val() == ""))
		{
			alert("<cf_get_lang dictionary_id='29764.Form'>");
			return false;
		}
		return process_cat_control();
		return false;
	}

	function change_use_ssk(type_id) {
		
		$('#salaryparam_pay_id').find('option').remove()
		
		var listParam = type_id ;
		get_param_pay = wrk_safe_query("get_param_pay",'dsn',0,listParam);//puantaj kontrolü

		if(get_param_pay.recordcount > 0)
		{
			for(i=0;i<get_param_pay.recordcount;i++){
				$("#salaryparam_pay_id").append($("<option />").val(get_param_pay.ODKES_ID[i]).text(get_param_pay.COMMENT_PAY[i]));
			}
			
		}

		if(type_id == 2){
			$('#is_officer').show();
			$('#item-GROSS_NET').hide();
			$('#item-SALARY_TYPE').hide();
			$('#item-test_process').hide();
			$('#item-business_code_id').hide();
		}
		else{
			$('#is_officer').hide();
			$('#item-GROSS_NET').show();
			$('#item-SALARY_TYPE').show();
			$('#item-test_process').show();
			$('#item-business_code_id').show();
		}
	}

	function get_service_title(class_id) {
		$("#service_title_detail").attr("value", "");
		if(class_id != ''){
			var get_service = wrk_query("SELECT SERVICE_TITLE_ID,SERVICE_TITLE,SERVICE_TITLE_CODE FROM SETUP_SERVICE_TITLE WHERE SERVICE_CLASS_ID = " + class_id,"dsn");
			$("#service_title option").remove();
			$("#service_title").append($("<option></option>").attr("value", '').text( "Seçiniz" ));
			if(get_service.recordcount > 0)	
			{
				for(i = 1;i<=get_service.recordcount;++i)
				{
					$("#service_title").append($("<option></option>").attr("value", get_service.SERVICE_TITLE_ID[i-1]).text(get_service.SERVICE_TITLE_CODE[i-1] +" - "+get_service.SERVICE_TITLE[i-1]  ));
					$("#service_title_id").attr("value", get_service.SERVICE_TITLE_ID);
				}
			}
		}
	}

	function get_title_detail(title_id) {
		if(title_id != ''){
			var get_service_detail = wrk_query("SELECT DETAIL FROM SETUP_SERVICE_TITLE WHERE SERVICE_TITLE_ID = " + title_id,"dsn");
			
			if(get_service_detail.recordcount > 0){
				$("#service_title_detail").attr("value", get_service_detail.DETAIL);
			}
		}
		else{
			$("#service_title_detail").attr("value", "");
		}
	}
	$( ".target" ).change(function() {
		
	});
</script>
