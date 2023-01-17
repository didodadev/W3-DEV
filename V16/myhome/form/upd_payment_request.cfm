<cf_xml_page_edit fuseact="myhome.form_add_payment_request">
<cfif fusebox.circuit eq 'myhome'>
    <cfset attributes.id = contentEncryptingandDecodingAES(isEncode:0,content:attributes.id,accountKey:'wrk')>
</cfif>
<cfsavecontent variable="title"><cf_get_lang dictionary_id = "30914.Avans talebi"></cfsavecontent>
<cfset pageHead = title>
<cf_catalystHeader>
<cfquery name="GET_PRIORITY" datasource="#DSN#">
	SELECT PRIORITY_ID,PRIORITY FROM SETUP_PRIORITY
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
<cfquery name="GET_MONEYS" datasource="#DSN#">
    SELECT MONEY_ID, MONEY FROM SETUP_MONEY WHERE PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#"> 
</cfquery>
<cfquery name="GET_PAYMENT_REQUEST" datasource="#DSN#">
    SELECT * FROM CORRESPONDENCE_PAYMENT WHERE ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.id#"> 
</cfquery>
<cfif fuseaction contains "popup">
	<cfset is_popup=1>
<cfelse>
	<cfset is_popup=0>
</cfif>
<cfquery name="get_salary" datasource="#dsn#">
	SELECT 
		M#month(now())# SALARY,
		SALARY_TYPE,
		EIO.IN_OUT_ID,
		EIO.PUANTAJ_GROUP_IDS,
		EIO.BRANCH_ID
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
			(
			EIO.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
			)
		)
</cfquery>
<cfset attributes.sal_year = year(now())>
<cfset attributes.sal_mon = month(now())>
<cfif get_salary.recordcount>
	<cfset branch_id = get_salary.branch_id>
	<cfif len(get_salary.PUANTAJ_GROUP_IDS)>
		<cfset attributes.group_id = "#get_salary.PUANTAJ_GROUP_IDS#,">
	</cfif>
</cfif>
<cfset not_kontrol_parameter = 1>
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
	SELECT SUM(AMOUNT) AS TOTAL_AMOUNT FROM CORRESPONDENCE_PAYMENT WHERE ID <> <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.id#"> AND TO_EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"> AND YEAR(RECORD_DATE) = YEAR(GETDATE()) AND MONTH(RECORD_DATE) = MONTH(GETDATE()) AND (STATUS IS NULL OR STATUS = 1)
</cfquery>
<cfif get_last_payment_request.recordcount and get_last_payment_request.TOTAL_AMOUNT gt 0>
	<cfset max_payment_request = max_payment_request-get_last_payment_request.TOTAL_AMOUNT>
</cfif>
<div class="col col-12 col-xs-12">
<cf_box>
	<cfform name="form_upd_payment_request" method="post" action="#request.self#?fuseaction=myhome.emptypopup_upd_payment_request">
		<input type="hidden" name="id" id="id" value="<cfoutput>#attributes.id#</cfoutput>">
		<input type="hidden" name="max_payment_request" id="max_payment_request" value="<cfoutput>#max_payment_request#</cfoutput>">
		<cf_box_elements>
			<div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
				<div class="form-group">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57576.Çalışan'></label>
					<div class="col col-8 col-xs-12">
						<input type="hidden" name="emp_id" id="emp_id" value="<cfoutput>#get_payment_request.to_employee_id#</cfoutput>">
						<input type="text" name="emp_name" id="emp_name" value="<cfoutput><cfif len(get_payment_request.to_employee_id)>#get_emp_info(get_payment_request.to_employee_id,0,0)#</cfif></cfoutput>" onFocus="AutoComplete_Create('emp_name','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','emp_id','','3','140');" autocomplete="off">
					</div>
				</div>
				<div class="form-group">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='31578.Avans Tipi'></label>
					<div class="col col-8 col-xs-12">
						<select name="demand_type" id="demand_type">
							<option value="-1"><cf_get_lang dictionary_id='57734.Seçiniz'></option>
							<cfoutput query="get_demand_type">
								<option value="#odkes_id#" <cfif odkes_id eq get_payment_request.demand_type>selected</cfif>>#comment_pay#</option>
							</cfoutput>
						</select>
					</div>
				</div>
				<div class="form-group">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='58859.Süreç'></label>
					<div class="col col-8 col-xs-12"><cf_workcube_process is_upd='0' process_cat_width='200' is_detail='1' select_value='#get_payment_request.PROCESS_STAGE#'></div>
				</div>
				<div class="form-group">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57480.Başlık'> *</label>
					<div class="col col-8 col-xs-12">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='58059.Başlık Girmelisiniz'></cfsavecontent>
						<cfinput type="text" name="subject" required="Yes" value="#get_payment_request.subject#" message="#message#">
					</div>
				</div>
				<div class="form-group">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
					<div class="col col-8 col-xs-12"><textarea name="detail" id="detail"><cfoutput>#get_payment_request.detail#</cfoutput></textarea></div>
				</div>
				<div class="form-group">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57556.Bilgi'></label>
					<div class="col col-8 col-xs-12">
						<div class="input-group">
							<cfset emp_name="">
							<cfif len(get_payment_request.cc_emp) and isnumeric(get_payment_request.cc_emp)>
								<cfset EMP_ID=get_payment_request.cc_emp>
								<cfset emp_name= get_emp_info(EMP_ID,0,0)>
							</cfif>
							<input type="hidden" name="emp_id_cc" id="emp_id_cc" value="<cfoutput>#get_payment_request.CC_EMP#</cfoutput>">
							<input type="text" name="emp_name_cc" id="emp_name_cc" value="<cfoutput>#emp_name#</cfoutput>" readonly>
							<span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=form_upd_payment_request.emp_id_cc&field_name=form_upd_payment_request.emp_name_cc&select_list=1</cfoutput>','list');"></span>
						</div>
					</div>
				</div>
				<div class="form-group">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57485.Öncelik'></label>
					<div class="col col-8 col-xs-12">
						<select name="priority" id="priority">
						<cfoutput query="get_priority">
							<option value="#get_priority.priority_id#" <cfif get_payment_request.priority eq priority_id>Selected</cfif>>#priority# </option>
						</cfoutput>
						</select>
					</div>
				</div>
				<div class="form-group">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57742.Tarih'> *</label>
					<div class="col col-8 col-xs-12">
						<div class="input-group">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='58503.Lutfen Tarih Giriniz'> !</cfsavecontent>
							<cfinput validate="#validate_style#" required="Yes" message="#message#" type="text" name="due_date"   value="#dateformat(get_payment_request.duedate,dateformat_style)#"style="width:200px;">
							<span class="input-group-addon"><cf_wrk_date_image date_field="due_date"></span>
						</div>
					</div>
				</div>
				<cfif isdefined("xml_show_paymethod") and xml_show_paymethod eq 1>
					<div class="form-group">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58516.Ödeme Yöntemi'></label>
						<div class="col col-8 col-xs-12">
							<select name="pay_method" id="pay_method">
							<cfoutput query="PAY_METHODS">
								<option value="#paymethod_id#" <cfif get_payment_request.paymethod_id eq paymethod_id> selected</cfif> >#paymethod#</option>
							</cfoutput>
							</select>
						</div>
					</div>
				</cfif>
				<div class="form-group">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57673.Tutar'> *</label>
					<div class="col col-8 col-xs-8">
						<div class="input-group">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='29535.Tutar Girmelisiniz'> !</cfsavecontent>
							<cfinput type="text" name="amount" id="amount" value="#tlformat(get_payment_request.amount)#" required="yes" onkeyup="return(FormatCurrency(this,event));" message="#message#" class="moneybox" style="width:145px;">
							<span class="input-group-addon width">
								<select name="MONEY_ID" id="MONEY_ID">
									<cfoutput query="get_moneys">
										<option value="#money#" <cfif money eq get_payment_request.money>selected</cfif>>#money#</option>
									</cfoutput>
								</select>
							</span>
						</div>
					</div>
				</div>
				<!---<tr>
					<td><cf_get_lang_main no ='88.Onay'>1</td>
					<td>
						<input type="hidden" name="validator_pos_code" id="validator_pos_code" value="<cfif  isdefined("get_payment_request.validator_position_code_1") and len(get_payment_request.validator_position_code_1)><cfoutput>#get_payment_request.validator_position_code_1#</cfoutput></cfif>">
						<!--- <cfif isdefined("get_payment_request.validator_position_code_1") and len(get_payment_request.validator_position_code_1)>
							<cfoutput>#get_emp_info(get_payment_request.validator_position_code_1,1,0)#</cfoutput>
						<cfelse>
							<input type="text" name="valid_name" id="valid_name" readonly="yes" value="" style="width:145px;">
						</cfif> --->
						<input type="text" name="valid_name" readonly="yes" value="<cfif len(get_payment_request.validator_position_code_1)><cfoutput>#get_emp_info(get_payment_request.validator_position_code_1,1,0)#</cfoutput></cfif>" style="width:145px;">
						<cfif isdefined('xml_select_manager') and xml_select_manager eq 1>
							<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_code=form_upd_payment_request.validator_pos_code&field_name=form_upd_payment_request.valid_name','list');return false"><img src="/images/plus_thin.gif"  align="absmiddle" border="0"></a>
						</cfif>
					</td>
				</tr>
				<tr>
					<td><cf_get_lang_main no ='88.Onay'>2</td>
					<td>
						<input type="hidden" name="validator_pos_code2" id="validator_pos_code2" value="<cfif isdefined("get_payment_request.validator_position_code_2") and len(get_payment_request.validator_position_code_2)><cfoutput>#get_payment_request.validator_position_code_2#</cfoutput></cfif>">
						<!--- <cfif isdefined("get_payment_request.validator_position_code_2") and len(get_payment_request.validator_position_code_2)>
							<cfoutput>#get_emp_info(get_payment_request.validator_position_code_2,1,0)#</cfoutput>
						<cfelse>
							<input type="text" name="valid_name2" id="valid_name2" readonly="yes" value="" style="width:145px;">
						</cfif> --->
						<input type="text" name="valid_name2" readonly="yes" value="<cfif len(get_payment_request.validator_position_code_2)><cfoutput>#get_emp_info(get_payment_request.validator_position_code_2,1,0)#</cfoutput></cfif>" style="width:145px;">
						<cfif isdefined('xml_select_manager') and xml_select_manager eq 1>
							<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_code=form_upd_payment_request.validator_pos_code2&field_name=form_upd_payment_request.valid_name2','list');return false"><img src="/images/plus_thin.gif"  align="absmiddle" border="0"></a>
						</cfif>
					</td>
				</tr>
					<cfif not len(get_payment_request.status) and not len(get_payment_request.valid_1) and not len(get_payment_request.valid_2)></cfif>
					--->
			</div>
		</cf_box_elements>
		<cf_box_footer><cf_workcube_buttons is_upd='1' is_delete ='0' type_format="1" add_function='unformat_fields()'></cf_box_footer>
	</cfform>
</cf_box>
</div>
<script type="text/javascript">
function unformat_fields()
{
	xx = document.getElementById('demand_type').selectedIndex;
	if(document.form_upd_payment_request.demand_type[xx].value == -1)
	{
		alert("<cf_get_lang dictionary_id='31852.Avans tipi seçiniz'>");
		return false;
	}

	x = (250 - form_upd_payment_request.detail.value.length);
	if ( x < 0 )
	{ 
		alert ("<cf_get_lang dictionary_id ='57629.Açıklama'>"+ ((-1) * x) +" <cf_get_lang dictionary_id='29538.Karakter Uzun'>");
		return false;
	}
	form_upd_payment_request.amount.value = filterNum(form_upd_payment_request.amount.value);
	return process_cat_control();
}
function delete_action()
{
	window.location.href="<cfoutput>#request.self#?fuseaction=myhome.del_payment_request&id=#attributes.id#</cfoutput>";
}	
</script>