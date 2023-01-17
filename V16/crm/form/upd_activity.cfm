<cfquery name="GET_VISIT_TYPES" datasource="#dsn#">
	SELECT * FROM SETUP_ACTIVITY_TYPES ORDER BY ACTIVITY_TYPE
</cfquery>
<cfquery name="GET_MONEY" datasource="#dsn#">
	SELECT * FROM SETUP_MONEY WHERE PERIOD_ID = #SESSION.EP.PERIOD_ID# AND MONEY_STATUS = 1
</cfquery>
<cfquery name="GET_EXPENSE" datasource="#dsn2#">
	SELECT EXPENSE_ITEM_ID, EXPENSE_ITEM_NAME FROM EXPENSE_ITEMS
</cfquery>		
<cfquery name="GET_STAGE" datasource="#dsn#">
	SELECT * FROM SETUP_ACTIVITY_STAGES ORDER BY ACTIVITY_STAGE
</cfquery>
<cfquery name="GET_EVENT_ROW" datasource="#dsn#">
	SELECT 
		ACTIVITY_PLAN_ROW.COMPANY_ID,
		ACTIVITY_PLAN_ROW.PARTNER_ID,
		ACTIVITY_PLAN_ROW.WARNING_ID,
		ACTIVITY_PLAN_ROW.RESULT_DETAIL,
		ACTIVITY_PLAN_ROW.VISIT_STAGE,
		ACTIVITY_PLAN_ROW.EXPENSE,
		ACTIVITY_PLAN_ROW.MONEY_CURRENCY,
		ACTIVITY_PLAN_ROW.EXPENSE_ITEM,
		ACTIVITY_PLAN_ROW.EXPENSE,
		ACTIVITY_PLAN_ROW.POSITION_ID,
		ACTIVITY_PLAN_ROW.EXECUTE_STARTDATE,
		ACTIVITY_PLAN_ROW.EXECUTE_FINISHDATE,
		ACTIVITY_PLAN_ROW.RESULT_RECORD_EMP,
		ACTIVITY_PLAN_ROW.RESULT_RECORD_DATE,
		ACTIVITY_PLAN_ROW.RESULT_UPDATE_DATE,
		ACTIVITY_PLAN_ROW.RESULT_UPDATE_EMP
	FROM 
		ACTIVITY_PLAN_ROW
	WHERE 
		ACTIVITY_PLAN_ROW.EVENT_PLAN_ROW_ID = #attributes.event_plan_row_id#
</cfquery>
<table width="100%" height="100%" cellpadding="0" cellspacing="0" border="0">
  <tr class="color-border">
    <td>
      <table width="100%" height="100%" border="0" cellpadding="2" cellspacing="1">
        <tr class="color-list">
          <td height="35" class="headbold"><cf_get_lang no='461.Etkinlik Güncelle'></td>
        </tr>
        <tr class="color-row">
          <td valign="top"><table>
              <cfform name="add_visit" method="post" action="#request.self#?fuseaction=crm.emptypopup_upd_activity_row">
			  <input type="hidden" name="event_plan_row_id" id="event_plan_row_id" value="<cfoutput>#attributes.event_plan_row_id#</cfoutput>">
			  <input type="hidden" name="today_value_" id="today_value_" value="<cfoutput>#dateformat(now(),dateformat_style)#</cfoutput>">
				<tr>
				  <td width="100"><cf_get_lang no='391.Etkinlik Yapılacak'> *</td>
                  <td colspan="3"><input name="company_id" id="company_id" type="hidden" value="<cfoutput>#get_event_row.company_id#</cfoutput>">
				  <cfsavecontent variable="message"><cf_get_lang no='405.Ziyaret Edilecek Giriniz '>!</cfsavecontent>
				  <cfinput name="company_name" type="text" required="yes" message="#message#" style="width:180px;" value="#get_par_info(get_event_row.company_id,1,0,0)#">
				  <input type="hidden" name="partner_id" id="partner_id" value="<cfoutput>#get_event_row.partner_id#</cfoutput>">
				  <input type="text" name="partner_name" id="partner_name" style="width:180;" value="<cfoutput>#get_par_info(get_event_row.partner_id,0,-1,0)#</cfoutput>"> 
				  <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_multiuser_company&field_comp_id=add_visit.company_id&field_comp_name=add_visit.company_name&field_id=add_visit.partner_id&field_name=add_visit.partner_name&is_single=1','wide');"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a></td>
				  </tr>
				  <tr>
					<td><cf_get_lang_main no='74.Kategori'> *</td>
					<td width="200">
                        <select name="visit_type" id="visit_type" style="width:180;">
                          <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                          <cfoutput query="get_visit_types">
                          <option value="#activity_type_id#" <cfif get_event_row.warning_id eq activity_type_id>selected</cfif>>#activity_type#</option>
                          </cfoutput>
                        </select>
                    </td>
				</tr>
				<tr>
					<td><cf_get_lang no='271.Gerçekleşme Tarihi'></td>
					<td colspan="3">
					<cfsavecontent variable="message"><cf_get_lang no='458.Lütfen Gerçekleşme Tarihi Formatını Doğru Giriniz !'></cfsavecontent>
					<cfinput  type="text"  name="execute_start_date" style="width:65" validate="#validate_style#" message="#message#" value="#dateformat(get_event_row.execute_startdate,dateformat_style)#">
					<cf_wrk_date_image date_field="execute_start_date"><cf_get_lang_main no='90.Bitiş'>
					<cfinput  type="text"  name="execute_finish_date" style="width:65" validate="#validate_style#" message="#message#" value="#dateformat(get_event_row.execute_finishdate,dateformat_style)#">
					<cf_wrk_date_image date_field="execute_finish_date"></td>
				</tr>
				<tr>
				<td valign="top"><cf_get_lang_main no='217.Açıklama'></td>
				<td colspan="3"><textarea name="detail" id="detail" style="width:100%;height:100;"><cfoutput>#get_event_row.result_detail#</cfoutput></textarea></td>
				</tr>
				<tr>
					<td><cf_get_lang_main no='272.Sonuç'> *</td>
					<td colspan="3">
                        <select name="visit_stage" id="visit_stage" style="width:190;">
                            <cfoutput query="get_stage">
                            <option value="#activity_stage_id#" <cfif get_event_row.visit_stage eq activity_stage_id>selected</cfif>>#activity_stage#</option>
                            </cfoutput>
                        </select>
                    </td>
				</tr>
				<tr>
				<td><cf_get_lang no='85.Harcama'></td>
				<td colspan="3">
                    <cfsavecontent variable="message"><cf_get_lang no='407.Sayısal Değer Giriniz !a'></cfsavecontent>
                    <cfinput type="text" name="visit_expense" validate="float" message="#message#" onKeyup="'return(FormatCurrency(this,event));'" value="#tlformat(get_event_row.expense)#" style="width:130px;" class="moneybox">
                    <select name="money" id="money" style="width:57px;">
                        <cfoutput query="get_money">
                        <option value="#money#" <cfif money eq get_event_row.money_currency>selected</cfif>>#money#</option>
                        </cfoutput>
                    </select>					
                    <select name="expense_item" id="expense_item" style="width:190;">
                        <option value=""><cf_get_lang_main no='1139.Gider Kalemi'></option>
                        <cfoutput query="get_expense">
                        <option value="#expense_item_id#" <cfif expense_item_id eq get_event_row.expense_item>selected</cfif>>#expense_item_name#</option>
                        </cfoutput>
                    </select>
                </td>
				</tr>
				<tr>
					<td><cf_get_lang no='272.Ziyaret Eden'></td>
					<td><input type="hidden" name="employee_id" id="employee_id" value="<cfoutput>#get_event_row.position_id#</cfoutput>">
					<input type="text" name="employee_name" id="employee_name" style="width:150;" value="<cfoutput>#get_emp_info(get_event_row.position_id,1,0)#</cfoutput>">
					<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_id=add_visit.employee_id&field_name=add_visit.employee_name','list');"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a></td>
				</tr>
				<cfif get_event_row.result_record_emp eq session.ep.userid>
				<tr>
				  <td>&nbsp;</td>
				  <td><cf_workcube_buttons is_upd='1' add_function='kontrol()' is_delete='0'></td>
				</tr>
				</cfif>
				<tr>
					<td><cf_get_lang_main no ='71.Kayıt'></td>
					<td>: <cfoutput>#get_emp_info(get_event_row.result_record_emp,0,0)# - #dateformat(get_event_row.result_record_date,dateformat_style)#</cfoutput></td>
				</tr>
				<tr>
					<td><cf_get_lang_main no ='291.Güncelleme'></td>
					<td>: <cfoutput>#get_emp_info(get_event_row.result_update_emp,0,0)# <cfif len(get_event_row.result_update_date)>- #dateformat(get_event_row.result_update_date,dateformat_style)#</cfif></cfoutput></td>
				</tr>
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
	x = document.add_visit.visit_type.selectedIndex;
	if (document.add_visit.visit_type[x].value == "")
	{ 
		alert ("<cf_get_lang no ='905.Lütfen Etkinlik Nedeni Giriniz'> !");
		return false;
	}
	x = document.add_visit.visit_stage.selectedIndex;
	if (document.add_visit.visit_stage[x].value == "")
	{ 
		alert ("<cf_get_lang no ='409.Sonuç Girmelisiniz'> !");
		return false;
	}
	/*if ((add_visit.start_date.value != ""))
	{
		tarih1_ = add_visit.start_date.value.substr(6,4) + add_visit.start_date.value.substr(3,2) + add_visit.start_date.value.substr(0,2);
		tarih2_ = add_visit.finish_date.value.substr(6,4) + add_visit.finish_date.value.substr(3,2) + add_visit.finish_date.value.substr(0,2);
			
		if (tarih1_ > tarih2_) 
		{
			alert("Başlama Tarihi Bitiş Tarihinden Önce Olmalıdır !");
			return false;
		}
	}*/	
	tarih1_1 = add_visit.execute_start_date.value.substr(6,4) + add_visit.execute_start_date.value.substr(3,2) + add_visit.execute_start_date.value.substr(0,2);
	tarih2_2 = add_visit.today_value_.value.substr(6,4) + add_visit.today_value_.value.substr(3,2) + add_visit.today_value_.value.substr(0,2);
	if((add_visit.execute_start_date.value != "") && (tarih1_1 > tarih2_2))
	{
		alert("<cf_get_lang no ='876.Lütfen Başlangıç Tarihini Bugünden Önce Giriniz'> !");
		return false;
	}
	tarih1_3 = add_visit.execute_finish_date.value.substr(6,4) + add_visit.execute_finish_date.value.substr(3,2) + add_visit.execute_finish_date.value.substr(0,2);
	tarih2_3 = add_visit.today_value_.value.substr(6,4) + add_visit.today_value_.value.substr(3,2) + add_visit.today_value_.value.substr(0,2);
	if((add_visit.execute_finish_date.value != "") && (tarih1_3 > tarih2_3))
	{
		alert("<cf_get_lang no ='877.Lütfen Bitiş Tarihini Bugünden Önce Giriniz'> !");
		return false;
	}
	add_visit.visit_expense.value = filterNum(add_visit.visit_expense.value);
}
</script>
