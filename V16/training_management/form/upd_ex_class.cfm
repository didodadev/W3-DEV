<cfinclude template="../query/get_training_sec_names.cfm">
<cfquery name="get_ex_class" datasource="#dsn#">
	SELECT
		*
	FROM
		TRAINING_EX_CLASS
	WHERE
		EX_CLASS_ID IS NOT NULL
	<cfif isDefined("attributes.EX_CLASS_ID") and len(attributes.EX_CLASS_ID)>
		AND EX_CLASS_ID = #attributes.EX_CLASS_ID#
	</cfif>
	<cfif isDefined("attributes.KEYWORD") and len(attributes.KEYWORD)>
		AND CLASS_NAME LIKE '%#attributes.KEYWORD#%'
	</cfif>
</cfquery>
<cfform name="add_ex_class" method="post" action="#request.self#?fuseaction=training_management.emptypopup_upd_ex_class">
  <input type="hidden" name="ex_class_id" id="ex_class_id" value="<cfoutput>#ex_class_id#</cfoutput>">
  <table width="98%" align="center" cellpadding="0" cellspacing="0" border="0" height="35">
    <cfoutput>
	<tr>
      <td class="headbold">#get_ex_class.class_name#</td>
      <td style="text-align:right;">
		<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=training_management.popup_list_ex_class_potential_attenders&ex_class_id=#attributes.ex_class_id#','project');"><img src="/images/partner.gif" title="<cf_get_lang no='160.Potansiyel Katılımcılar'>" border="0"></a>
		<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=training_management.popup_list_ex_class_attenders&ex_class_id=#attributes.ex_class_id#','project');"><img src="/images/family.gif" title="<cf_get_lang_main no='178.katılımcılar'>" border="0"></a>
      </td>
    </tr>
	</cfoutput>
  </table>
  <table width="98%" border="0" align="center" cellpadding="0" cellspacing="0">
    <tr>
      <td valign="top">
        <table width="98%" border="0" cellspacing="0" cellpadding="0">
          <tr clasS="color-border">
            <td>
              <table width="100%" border="0" cellspacing="1" cellpadding="2">
                <tr class="color-row">
                  <td valign="top">
                    <table border="0">
                      <tr>
                        <td width="100"><cf_get_lang_main no='74.bölüm'></td>
                        <td colspan="2">
                          <select name="training_sec_id" id="training_sec_id" style="width:250px;">
                            <cfoutput query="get_training_sec_names">
                              <option value="#training_sec_id#"<cfif get_ex_class.training_sec_id eq training_sec_id><cfset sec_id = currentrow> selected</cfif>>#training_cat# / #section_name#</option>
                            </cfoutput>
                          </select>
                        </td>
                      </tr>
					  <tr>
		                <td><cf_get_lang_main no='7.Eğitim'>*</td>
                        <td colspan="2">
						<cfsavecontent variable="message"><cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no='1.sınıf'></cfsavecontent>
						<cfinput type="text" value="#get_ex_class.class_name#" name="class_name" style="width:250px;" required="Yes" message="#message#" maxlength="100">
                        </td>
                      </tr>
					  <tr>
                        <td><cf_get_lang no='187.Eğitim Yeri'></td>
                        <td colspan="2"><cfinput type="text" value="#get_ex_class.CLASS_PLACE#" name="CLASS_PLACE" style="width:250px;" maxlength="100">
                        </td>
                      </tr>
					  <tr>
						<td><cf_get_lang no='239.Eğitim Maliyeti'></td>
						<td colspan="2">
						<cfquery name="GET_MONEY" datasource="#DSN#">
							SELECT
								*
							FROM
								SETUP_MONEY
							WHERE
								PERIOD_ID = #SESSION.EP.PERIOD_ID#
						</cfquery>
						<cfinput type="text" name="class_cost" VALUE="#TLformat(get_ex_class.CLASS_COST)#" style="width:192px;" maxlength="100" onBlur="add();" onkeyup=""return(FormatCurrency(this,event));""">
						<select name="money_type" id="money_type">
						<cfoutput query="get_money">
						<option value="#money_id#" <cfif money_id eq get_ex_class.money_type>selected</cfif>>#money#</option>
						</cfoutput>
						</select>
						</td>
					  </tr>
                      <tr>
                        <td><cf_get_lang_main no='330.Tarih'>/<cf_get_lang no='170.Eğitim Toplam Saat'></td>
                        <td colspan="2">
                          <cfsavecontent variable="message"><cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no ='641.başlangıç tarihi'></cfsavecontent>
						  <cfinput value="#dateformat(get_ex_class.class_date,dateformat_style)#" validate="#validate_style#" message="#message#" type="text" name="class_date" style="width:145px;" maxlength="10">
                          <cf_wrk_date_image date_field="class_date">
							<cfsavecontent variable="message"><cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no='170.toplam saat'></cfsavecontent>
							<cfinput type="text" value="#get_ex_class.HOUR_NO#" name="HOUR_NO" style="width:83;" validate="integer" message="#message#"  maxlength="100">
                        </td>
                      </tr>
					  <tr>
				         <td><cf_get_lang no='313.Değerlendirme Formu'></td>
				        <td>
				        <cfif LEN(get_ex_class.QUIZ_ID)>
						  <cfquery name="GET_Q_NAME" datasource="#DSN#">
						    SELECT
								QUIZ_ID,
							  	QUIZ_HEAD
							FROM
							  	EMPLOYEE_QUIZ
							WHERE
							  	QUIZ_ID = #get_ex_class.QUIZ_ID# 
						  </cfquery>
						  <input type="hidden" name="quiz_id" id="quiz_id" value="<cfoutput>#get_ex_class.QUIZ_ID#</cfoutput>">
					      <input type="text" name="quiz_head" id="quiz_head" value="<cfoutput>#GET_Q_NAME.QUIZ_HEAD#</cfoutput>" style="width:250px;" readonly>
					    <cfelse>
						  <input type="hidden" name="quiz_id" id="quiz_id" value="">
					      <input type="text" name="quiz_head" id="quiz_head" value="" style="width:250px;" readonly>
						</cfif>   
						 <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=training_management.popup_list_eval_quizes2&field_quiz_id=add_ex_class.quiz_id&field_quiz_head=add_ex_class.quiz_head</cfoutput>','list');">
					      <img src="/images/plus_thin.gif"  border="0" align="absmiddle">
					     </a> 
				        </td>
				      </tr>					  
					   <tr>
				        <td><cf_get_lang no='23.Eğitimci'></td>
				        <td>
						 <input type="hidden" name="emp_id" id="emp_id" value="<cfif len(get_ex_class.trainer_emp)><cfoutput>#get_ex_class.trainer_emp#</cfoutput></cfif>"> 
						 <input type="hidden" name="par_id" id="par_id" value="<cfif len(get_ex_class.trainer_par)><cfoutput>#get_ex_class.trainer_par#</cfoutput></cfif>">
						 <input type="hidden" name="member_type" id="member_type" value="<cfif len(get_ex_class.trainer_emp)><cfoutput>partner</cfoutput><cfelse><cfoutput>partner</cfoutput></cfif>">
						 <cfif len(get_ex_class.trainer_emp)>
						   <cfquery name="get_emp_name" datasource="#dsn#">
						    SELECT EMPLOYEE_NAME, EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEE_ID = #get_ex_class.trainer_emp#
 						  </cfquery>
						  <input type="text" name="emp_par_name" id="emp_par_name" value="<cfoutput>#get_emp_name.EMPLOYEE_NAME# #get_emp_name.EMPLOYEE_SURNAME#</cfoutput>" style="width:250px;" readonly>
						 <cfelseif len(get_ex_class.trainer_par)>
						   <cfquery name="get_par_name" datasource="#dsn#">
						     SELECT COMPANY_PARTNER_NAME , COMPANY_PARTNER_SURNAME FROM COMPANY_PARTNER WHERE PARTNER_ID = #get_ex_class.trainer_par#
						  </cfquery>
						  <input type="text" name="emp_par_name" id="emp_par_name" value="<cfoutput>#get_par_name.COMPANY_PARTNER_NAME# #get_par_name.COMPANY_PARTNER_SURNAME#</cfoutput>"  style="width:250px;" readonly> 
						 <cfelse>
						  <input type="text" name="emp_par_name" id="emp_par_name" value="" style="width:250px;" readonly>
						 </cfif>
						   <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=add_ex_class.emp_id&field_name=add_ex_class.emp_par_name&field_type=add_ex_class.member_type&field_partner=add_ex_class.par_id&select_list=1,2</cfoutput>','list');">
						    <img src="/images/plus_thin.gif" border="0" align="absmiddle">
						   </a> 
                       </td>
				      </tr> 
                        <tr>
                        <td height="35" colspan="3" style="text-align:right;">
						<cf_workcube_buttons is_upd='1' delete_page_url='#request.self#?fuseaction=training_management.emptypopup_del_ex_class&ex_class_id=#attributes.ex_class_id#' add_function='unformat_fields()'><!---  add_function='kontrol()' --->
                        </td>
                      </tr>
                    </table>
                  </td>
                </tr>
              </table>
            </td>
          </tr>
        </table>
      </td>
      <td width="250" valign="top">
<!--- eğitim formlari  --->
		  <table cellspacing="0" cellpadding="0" border="0" width="98%">
			<tr class="color-border">
			  <td>							
				<table cellspacing="1" cellpadding="2" width="100%" border="0">
				  <tr class="color-header" height="22">
					<td class="form-title" colspan="2"><cf_get_lang no='185.Eğitim Değerlendirme Formları'></td>
				  </tr>								 
				 <cfif LEN(get_ex_class.QUIZ_ID)>
				  <tr class="color-list" height="22">
					<td class="txtboldblue" colspan="2"><cf_get_lang no='277.Form Adı'></td>
				  </tr>
					  <cfoutput query="GET_Q_NAME">
						<tr class="color-row">
						  <td>
							<a  class="tableyazi" href="#request.self#?fuseaction=training_management.dsp_eval_quiz&quiz_id=#QUIZ_ID#">#QUIZ_HEAD#</a>
						  </td>
						  <td>
							  <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=training_management.popup_form_add_ex_class_eval&ex_class_id=#attributes.ex_class_id#&quiz_id=#QUIZ_ID#','list');">
							  <img  src="images/butcegider.gif" border="0"></a>
						  </td>
						</tr>
					  </cfoutput> 
				  <cfelse>
					<tr class="color-row">
					  <td colspan="2">&nbsp;<cf_get_lang_main no='72.Kayıt Bulunamadı'>!</td>
					</tr>							
				  </cfif>
				</table>
			 </td>
		  </tr>
		</table>							
	<!--- eğitim formlari --->
			<br/>		 
		<!--- sections  --->  
			<!--- <cfinclude template="dsp_class_sections.cfm"> --->
		<!--- sections --->				  
			 <!--- <br/> --->
			  <!--- Varlıklar --->
					<cf_get_workcube_asset company_id="#session.ep.company_id#" asset_cat_id="-6" module_id='34' action_section='EX_CLASS_ID' action_id='#url.ex_class_id#'>
			  <!--- Varlıklar --->
			<br/>
			  <!--- Notlar --->
					<cf_get_workcube_note  action_section='EX_CLASS_ID' action_id='#attributes.ex_class_id#'>
			  <!--- Notlar --->
						<br/> 
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
