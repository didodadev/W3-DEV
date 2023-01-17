<cfquery name="GET_MONEY" datasource="#dsn#">
	SELECT * FROM SETUP_MONEY WHERE PERIOD_ID = #SESSION.EP.PERIOD_ID# AND MONEY_STATUS = 1
</cfquery>
<cfquery name="GET_EXPENSE" datasource="#dsn2#">
	SELECT EXPENSE_ITEM_ID, EXPENSE_ITEM_NAME FROM EXPENSE_ITEMS
</cfquery>		
<cfquery name="GET_BRANCH" datasource="#dsn#">
	SELECT
		BRANCH_NAME,
		BRANCH_ID
	FROM 
		BRANCH,
		COMPANY_BOYUT_DEPO_KOD
	WHERE
		COMPANY_BOYUT_DEPO_KOD.W_KODU = BRANCH.BRANCH_ID AND
		BRANCH_ID IN ( SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code# )
	ORDER BY 
		BRANCH_NAME
</cfquery>
<cfquery name="GET_EVENT_ROW" datasource="#dsn#">
	SELECT 
		EVENT_PLAN_ROW.COMPANY_ID,
		EVENT_PLAN_ROW.PARTNER_ID,
		EVENT_PLAN_ROW.START_DATE,
		EVENT_PLAN_ROW.FINISH_DATE,
		EVENT_PLAN_ROW.WARNING_ID,
		EVENT_PLAN_ROW.RESULT_DETAIL,
		EVENT_PLAN_ROW.VISIT_STAGE,
		EVENT_PLAN_ROW.EXPENSE,
		EVENT_PLAN_ROW.MONEY_CURRENCY,
		EVENT_PLAN_ROW.EXPENSE_ITEM,
		EVENT_PLAN_ROW.EXPENSE,
		EVENT_PLAN_ROW.EXECUTE_STARTDATE,
		EVENT_PLAN_ROW.EXECUTE_FINISHDATE,
		EVENT_PLAN_ROW.RESULT_RECORD_DATE,
		EVENT_PLAN_ROW.RESULT_RECORD_EMP,
		EVENT_PLAN_ROW.RESULT_UPDATE_DATE,
		EVENT_PLAN_ROW.RESULT_UPDATE_EMP,
		EVENT_PLAN_ROW.BRANCH_ID
	FROM 
		EVENT_PLAN_ROW
	WHERE 
		EVENT_PLAN_ROW.EVENT_PLAN_ROW_ID = #attributes.event_plan_row_id#
</cfquery>
<table width="100%" height="100%" cellpadding="0" cellspacing="0" border="0">
  <tr class="color-border">
    <td>
	<table width="100%" height="100%" border="0" cellpadding="2" cellspacing="1">
	  <tr class="color-list">
	  	<td height="35" class="headbold"><cf_get_lang no='404.Ziyaret Güncelle'></td>
	  </tr>
	  <tr class="color-row">
	  	<td valign="top"><table>
		<cfform name="upd_visit" method="post" action="#request.self#?fuseaction=crm.emptypopup_upd_visit_row">
		<input type="hidden" name="event_plan_row_id" id="event_plan_row_id" value="<cfoutput>#attributes.event_plan_row_id#</cfoutput>">
		<input type="hidden" name="today_value_" id="today_value_" value="<cfoutput>#dateformat(now(),dateformat_style)#</cfoutput>">
		<input type="hidden" name="kontrol_date_value" id="kontrol_date_value" value="<cfoutput>#dateformat(date_add('d',-7,createodbcdatetime('#year(now())#-#month(now())#-#day(now())#')),dateformat_style)#</cfoutput>">
		  <tr>
		  	<td width="100"><cf_get_lang no='207.Ziyaret Edilecek'> *</td>
		  	<td colspan="3"><input name="company_id" id="company_id" type="hidden" value="<cfoutput>#get_event_row.company_id#</cfoutput>">
		   	  <cfsavecontent variable="message"><cf_get_lang no='405.Ziyaret Edilecek Giriniz'> !</cfsavecontent>
		  	  <cfinput name="company_name" type="text" required="yes" message="#message#" style="width:180px;" value="#get_par_info(get_event_row.company_id,1,0,0)#">
		  	  <input type="hidden" name="partner_id" id="partner_id" value="<cfoutput>#get_event_row.partner_id#</cfoutput>">
		  	  <input type="text" name="partner_name" id="partner_name" style="width:180;" value="<cfoutput>#get_par_info(get_event_row.partner_id,0,-1,0)#</cfoutput>"> 
		  	  <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_multiuser_company&field_comp_id=upd_visit.company_id&field_comp_name=upd_visit.company_name&field_id=upd_visit.partner_id&field_name=upd_visit.partner_name&is_single=1','wide');"><img src="/images/plus_thin.gif" alt="<cf_get_lang no='207.Ziyaret Edilecek'>" align="absmiddle" border="0"></a></td>
		  </tr>
		  <tr>
			<td><cf_get_lang no='270.Ziyaret Nedeni'> *</td>
			<td width="200">
				<cf_wrk_combo	
					name="visit_type"
					query_name="GET_VISIT_TYPES"
					option_name="visit_type"
					option_value="visit_type_id"
					value="#get_event_row.warning_id#">		
			</td>
		  </tr>
		  <tr>
		  	<td><cf_get_lang no='107.Yetkili Şubeler'> *</td>
		  	<td>
              <select name="sales_zones" id="sales_zones" style="width:180px;">
                  <option value=""><cf_get_lang_main no='41.Şube'></option>
                  <cfoutput query="get_branch">
                    <option value="#branch_id#" <cfif get_event_row.branch_id eq branch_id>selected</cfif>>#branch_name#</option>
                  </cfoutput>
		  	  </select>
              </td>
		  </tr>
		  <tr>
		  	<td><cf_get_lang no='271.Gerçekleşme Tarihi'> *</td>
		  	<td colspan="3"><cfsavecontent variable="message"><cf_get_lang no='406.Lütfen Başlama Tarihi Formatını Doğru Girin'> !</cfsavecontent>
		      <cfinput type="text" name="execute_startdate" style="width:65" validate="#validate_style#" message="#message#" required="yes" value="#dateformat(get_event_row.execute_startdate,dateformat_style)#">
			  <cf_wrk_date_image date_field="execute_startdate">
			  <select name="execute_start_clock" id="execute_start_clock" style="width:50px;">
			  <option value="0" selected><cf_get_lang_main no='79.Saat'></option>
			  <cfloop from="7" to="30" index="i">
				<cfset saat=i mod 24>
				<cfoutput>
				<option value="#saat#" <cfif len(get_event_row.execute_startdate) and hour(get_event_row.execute_startdate) eq saat>selected</cfif>>#saat#</option>
			  	</cfoutput>
			  </cfloop>
			  </select>
			  <select name="execute_start_minute" id="execute_start_minute" style="width:40px;">
				<option value="00" <cfif len(get_event_row.execute_startdate) and minute(get_event_row.execute_startdate) eq 00>selected</cfif>>00</option>
				<option value="05" <cfif len(get_event_row.execute_startdate) and minute(get_event_row.execute_startdate) eq 05>selected</cfif>>05</option>
				<option value="10" <cfif len(get_event_row.execute_startdate) and minute(get_event_row.execute_startdate) eq 10>selected</cfif>>10</option>
				<option value="15" <cfif len(get_event_row.execute_startdate) and minute(get_event_row.execute_startdate) eq 15>selected</cfif>>15</option>
				<option value="20" <cfif len(get_event_row.execute_startdate) and minute(get_event_row.execute_startdate) eq 20>selected</cfif>>20</option>
				<option value="25" <cfif len(get_event_row.execute_startdate) and minute(get_event_row.execute_startdate) eq 25>selected</cfif>>25</option>
				<option value="30" <cfif len(get_event_row.execute_startdate) and minute(get_event_row.execute_startdate) eq 30>selected</cfif>>30</option>
				<option value="35" <cfif len(get_event_row.execute_startdate) and minute(get_event_row.execute_startdate) eq 35>selected</cfif>>35</option>
				<option value="40" <cfif len(get_event_row.execute_startdate) and minute(get_event_row.execute_startdate) eq 40>selected</cfif>>40</option>
				<option value="45" <cfif len(get_event_row.execute_startdate) and minute(get_event_row.execute_startdate) eq 45>selected</cfif>>45</option>
				<option value="50" <cfif len(get_event_row.execute_startdate) and minute(get_event_row.execute_startdate) eq 50>selected</cfif>>50</option>
				<option value="55" <cfif len(get_event_row.execute_startdate) and minute(get_event_row.execute_startdate) eq 55>selected</cfif>>55</option>
			  </select>
			  <select name="execute_finish_clock" id="execute_finish_clock" style="width:50px;">
			  <option value="0" selected><cf_get_lang_main no='79.Saat'></option>
			  <cfloop from="7" to="30" index="i">
			    <cfset saat=i mod 24>
				<cfoutput>
				<option value="#saat#" <cfif len(get_event_row.execute_finishdate) and hour(get_event_row.execute_finishdate) eq saat>selected</cfif>>#saat#</option>
			    </cfoutput>
			  </cfloop>
			  </select>
			  <select name="execute_finish_minute" id="execute_finish_minute" style="width:40px;">
				<option value="00" <cfif len(get_event_row.execute_finishdate) and minute(get_event_row.execute_finishdate) eq 00>selected</cfif>>00</option>
				<option value="05" <cfif len(get_event_row.execute_finishdate) and minute(get_event_row.execute_finishdate) eq 05>selected</cfif>>05</option>
				<option value="10" <cfif len(get_event_row.execute_finishdate) and minute(get_event_row.execute_finishdate) eq 10>selected</cfif>>10</option>
				<option value="15" <cfif len(get_event_row.execute_finishdate) and minute(get_event_row.execute_finishdate) eq 15>selected</cfif>>15</option>
				<option value="20" <cfif len(get_event_row.execute_finishdate) and minute(get_event_row.execute_finishdate) eq 20>selected</cfif>>20</option>
				<option value="25" <cfif len(get_event_row.execute_finishdate) and minute(get_event_row.execute_finishdate) eq 25>selected</cfif>>25</option>
				<option value="30" <cfif len(get_event_row.execute_finishdate) and minute(get_event_row.execute_finishdate) eq 30>selected</cfif>>30</option>
				<option value="35" <cfif len(get_event_row.execute_finishdate) and minute(get_event_row.execute_finishdate) eq 35>selected</cfif>>35</option>
				<option value="40" <cfif len(get_event_row.execute_finishdate) and minute(get_event_row.execute_finishdate) eq 40>selected</cfif>>40</option>
				<option value="45" <cfif len(get_event_row.execute_finishdate) and minute(get_event_row.execute_finishdate) eq 45>selected</cfif>>45</option>
				<option value="50" <cfif len(get_event_row.execute_finishdate) and minute(get_event_row.execute_finishdate) eq 50>selected</cfif>>50</option>
				<option value="55" <cfif len(get_event_row.execute_finishdate) and minute(get_event_row.execute_finishdate) eq 55>selected</cfif>>55</option>
			  </select></td>
		  </tr>
		  <tr>
			<td valign="top"><cf_get_lang_main no='217.Açıklama'></td>
			<td colspan="3"><textarea name="detail" id="detail" style="width:100%;height:100px;"><cfoutput>#get_event_row.result_detail#</cfoutput></textarea></td>
		  </tr>
		  <tr>
			<td><cf_get_lang_main no='272.Sonuç'> *</td>
			<td colspan="3">
				<cfsavecontent variable="text"><cf_get_lang_main no='272.Sonuç'></cfsavecontent>
				<cf_wrk_combo
						name="visit_stage"
						query_name="GET_VISIT_STAGES"
						option_name="visit_stage"
						option_value="visit_stage_id"
						value="#get_event_row.visit_stage#"
						option_text="#text#"
						width="190">
			</td>
		  </tr>
		  <tr>
			<td><cf_get_lang no='85.Harcama'></td>
			<td colspan="3"><cfsavecontent variable="message"><cf_get_lang no='407.sayısal Değer Giriniz '></cfsavecontent>
			  <cfinput type="text" name="visit_expense" validate="float" message="#message#" onKeyup="'return(FormatCurrency(this,event));'" value="#tlformat(get_event_row.expense)#" style="width:130px;" class="moneybox">
			  <select name="money" id="money" style="width:57px;">
			  <cfoutput query="get_money">
				<option value="#money#" <cfif money eq get_event_row.money_currency>selected</cfif>>#money#</option>
			  </cfoutput>
			  </select>					
			  <select name="expense_item" id="expense_item" style="width:190;">
			  <option value=""><cf_get_lang_main no ='1139.Gider Kalemi'></option>
			  <cfoutput query="get_expense">
				<option value="#expense_item_id#" <cfif expense_item_id eq get_event_row.expense_item>selected</cfif>>#expense_item_name#</option>
			  </cfoutput>
			  </select></td>
		  </tr>
		  <tr>
			<cfquery name="GET_ROW_POS" datasource="#DSN#">
				SELECT
					EVENT_POS_ID
				FROM
					EVENT_PLAN_ROW_PARTICIPATION_POS
				WHERE
					EVENT_ROW_ID = #attributes.event_plan_row_id#
			</cfquery>
			<td><cf_get_lang no ='384.Ziyaret Edecekler'></td>
			<td><input type="hidden" name="employee_id" id="employee_id" value="<cfoutput>#valuelist(get_row_pos.event_pos_id, ',')#</cfoutput>">
			  <input type="text" name="employee_name" id="employee_name" value="<cfoutput query="get_row_pos">#get_emp_info(event_pos_id,1,0)#<cfif get_row_pos.recordcount neq currentrow>,</cfif></cfoutput>" readonly style="width:370px;">
			  <a href="javascript://" onClick="temizlerim('');pencere_ac_pos('');"><img src="/images/plus_thin.gif" alt="<cf_get_lang no ='384.Ziyaret Edecekler'>" border="0" align="absmiddle"></a></td>
		  </tr>
			<cfif get_event_row.result_record_emp eq session.ep.userid>
			  <tr>
				<td></td>
				<td><cf_workcube_buttons is_upd='1' add_function='kontrol()' is_delete='0'></td>
			  </tr>
			</cfif>
			  <tr>
				<td><cf_get_lang_main no='71.Kayıt'></td>
				<td>: <cfoutput>#get_emp_info(get_event_row.result_record_emp,0,0)# - #dateformat(get_event_row.result_record_date, dateformat_style)#</cfoutput></td>
			  </tr>
			<cfif len(get_event_row.result_update_emp)>
			  <tr>
				<td><cf_get_lang_main no='291.Güncelleme'></td>
				<td>: <cfoutput>#get_emp_info(get_event_row.result_update_emp,0,0)#<cfif len(get_event_row.result_update_date)> - #dateformat(get_event_row.result_update_date, dateformat_style)#</cfif></cfoutput></td>
			  </tr>
			</cfif>
	  </cfform>
		</table>
		</td>
	  </tr>
	</table>
    </td>
  </tr>
</table>
<script type="text/javascript">
function kontrol()
{
	x = document.upd_visit.visit_type.selectedIndex;
	if (document.upd_visit.visit_type[x].value == ""){ 
		alert ("<cf_get_lang no='408.Lütfen Ziyaret Nedeni Giriniz'> !");
		return false;}
	x = document.upd_visit.visit_stage.selectedIndex;
	if (document.upd_visit.visit_stage[x].value == ""){ 
		alert ("<cf_get_lang no='409.Sonuç Girmelisiniz'> !");
		return false;}
	if(!date_check_hiddens(document.upd_visit.kontrol_date_value,document.upd_visit.execute_startdate," <cf_get_lang no ='921.Gerçekleşme Tarihi Bugunden 7 Gun Oncesi Olabilir'> !")){
		return false;}
	tarih1_1 = upd_visit.execute_startdate.value.substr(6,4) + upd_visit.execute_startdate.value.substr(3,2) + upd_visit.execute_startdate.value.substr(0,2);
	tarih2_2 = upd_visit.today_value_.value.substr(6,4) + upd_visit.today_value_.value.substr(3,2) + upd_visit.today_value_.value.substr(0,2);
	if((upd_visit.execute_startdate.value != "") && (tarih1_1 > tarih2_2)){
		alert("<cf_get_lang no='410.Lütfen Gerçekleşme Tarihini Bugünden Önce Giriniz'> !");
		return false;}
	if ((upd_visit.execute_startdate.value != "")){
		tarih1_ = upd_visit.execute_startdate.value.substr(6,4) + upd_visit.execute_startdate.value.substr(3,2) + upd_visit.execute_startdate.value.substr(0,2);
		tarih2_ = upd_visit.execute_startdate.value.substr(6,4) + upd_visit.execute_startdate.value.substr(3,2) + upd_visit.execute_startdate.value.substr(0,2);
		if (upd_visit.execute_start_clock.value.length < 2) saat1_ = '0' + upd_visit.execute_start_clock.value; else saat1_ = upd_visit.execute_start_clock.value;
		if (upd_visit.execute_start_minute.value.length < 2) dakika1_ = '0' + upd_visit.execute_start_minute.value; else dakika1_ = upd_visit.execute_start_minute.value;
		if (upd_visit.execute_finish_clock.value.length < 2) saat2_ = '0' + upd_visit.execute_finish_clock.value; else saat2_ = upd_visit.execute_finish_clock.value;
		if (upd_visit.execute_finish_minute.value.length < 2) dakika2_ = '0' + upd_visit.execute_finish_minute.value; else dakika2_ = upd_visit.execute_finish_minute.value;
		tarih1_ = tarih1_ + saat1_ + dakika1_;
		tarih2_ = tarih2_ + saat2_ + dakika2_;	
		if (tarih1_ >= tarih2_) {
			alert("<cf_get_lang no='411.Gerçekleşme Tarihi Başlama Saati Bitiş Saatinden Önce Olmalıdır'> !");
			return false;
	}}	
	upd_visit.visit_expense.value = filterNum(upd_visit.visit_expense.value);
}
function temizlerim(no){
	var my_element=eval("upd_visit.employee_id"+no);
	var my_element2=eval("upd_visit.employee_name"+no);
	my_element.value='';
	my_element2.value='';
}
function pencere_ac_pos(no){
	windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_multi_pars&field_id=upd_visit.employee_id&field_name=upd_visit.employee_name&select_list=1&is_upd=0','list');
}
</script>
