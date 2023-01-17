<cfinclude template="../query/get_training_sec_names.cfm">
<cfform name="add_ex_class" method="post" action="#request.self#?fuseaction=training_management.emptypopup_add_ex_class">
  <table width="98%" align="center" cellpadding="0" cellspacing="0" border="0" height="35">
    <tr>
      <td class="headbold"><cf_get_lang no='217.Dış Eğitim Ekle'></td>
    </tr>
  </table>
  <table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
    <tr clasS="color-border">
      <td>
        <table width="100%" border="0" cellspacing="1" cellpadding="2">
          <tr class="color-row">
            <td valign="top">
              <table  border="0" cellspacing="2" cellpadding="2">
                <tr>
                  <td><cf_get_lang_main no='74.bölüm'></td>
                  <td colspan="2">
                    <select name="training_sec_id" id="training_sec_id" style="width:320px;">
                      <cfoutput query="get_training_sec_names">
                        <option value="#training_sec_id#">#training_cat# / #section_name#</option>
                      </cfoutput>
                    </select>
                  </td>
                </tr>
			    <tr>
                  <td><cf_get_lang_main no='7.Eğitim'>*</td>
                  <td colspan="2">
				  <cfsavecontent variable="message"><cf_get_lang no='293.Eğitim Adı girmelisiniz'></cfsavecontent>
				  <cfinput type="text" name="class_name" style="width:320px;" required="Yes" message="#message#" maxlength="100"></td>
                </tr>
				  <tr>
					<td><cf_get_lang no='187.Eğitim Yeri'></td>
					<td colspan="2"><cfinput type="text" name="CLASS_PLACE" style="width:320px;" maxlength="100">
					</td>
				  </tr>
				  <tr>
					<td><cf_get_lang no='239.Eğitim Maliyeti'></td>
					<td colspan="2">
					<cfinput type="text" name="class_cost" style="width:262px;" maxlength="100" onkeyup="return(FormatCurrency(this,event));">
					<cfquery name="GET_MONEY" datasource="#DSN#">
						SELECT
							*
						FROM
							SETUP_MONEY
						WHERE
							PERIOD_ID = #SESSION.EP.PERIOD_ID#
					</cfquery>
					<select name="money_type" id="money_type">
					<cfoutput query="get_money">
					<option value="#money_id#" <cfif money_id eq 1>selected</cfif>>#money#</option>
					</cfoutput>
					</select>
					</td>
				  </tr>
                <tr>
                  <td><cf_get_lang_main no='330.Tarih'> - <cf_get_lang no='170.Eğitim Toplam Saat'></td>
                  <td colspan="2">
					<cfsavecontent variable="message"><cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='330.Tarih'></cfsavecontent>
					<cfinput  validate="#validate_style#" message="#message#" type="text" name="class_date" style="width:200px;" maxlength="10">
					<cf_wrk_date_image date_field="class_date">
					<cfsavecontent variable="message"><cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no='170.toplam saat'></cfsavecontent>
					<cfinput type="text" value="" name="HOUR_NO" style="width:97;" validate="integer" message="#message#" maxlength="100">
                  </td>
                </tr>
				<tr>
				  <td><cf_get_lang no='313.Değerlendirme Formu'></td>
				  <td>
				    <input type="hidden" name="quiz_id" id="quiz_id" value="">
					<input type="text" name="quiz_head" id="quiz_head" value="" style="width:320px;" readonly>
					<a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=training_management.popup_list_eval_quizes2&field_quiz_id=add_ex_class.quiz_id&field_quiz_head=add_ex_class.quiz_head</cfoutput>','list');">
					 <img src="/images/plus_thin.gif" border="0" align="absmiddle">
					</a> 
				  </td>
				</tr>
				 <tr>
				   <td><cf_get_lang no='23.Eğitimci'></td>
				   <td>
					<input type="hidden" name="emp_id" id="emp_id" value="">
					<input type="hidden" name="par_id" id="par_id" value="">
					<input type="hidden" name="member_type" id="member_type" value="">
					<input type="text" name="emp_par_name" id="emp_par_name" value="" style="width:320px;"><!---  readonly --->
					<!--- <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=add_ex_class.emp_id&field_name=add_ex_class.emp_par_name&field_type=add_ex_class.member_type&field_partner=add_ex_class.par_id&select_list=1,2</cfoutput>','list');">
					<img src="/images/plus_thin.gif" border="0" align="absmiddle">
					</a> ---> 
                  </td>
				 </tr> 
                <tr>
				<td></td>
                  <td height="35" colspan="2" style="text-align:right;">
				  <cf_workcube_buttons is_upd='0' add_function='unformat_fields()'><!---  add_function='kontrol()' --->
                  </td>
                </tr>
              </table>
            </td>
          </tr>
        </table>
      </td>
    </tr>
  </table>
</cfform>
<script type="text/javascript">
function unformat_fields()
{
	add_ex_class.class_cost.value = filterNum(add_ex_class.class_cost.value);
	return true;
}
</script>
