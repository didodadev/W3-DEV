<cf_xml_page_edit fuseact="hr.emp_test_time">
<cfquery name="get_empapp" datasource="#dsn#">
	SELECT
		EA.EMPAPP_ID,
		EA.NAME,
		EA.SURNAME
	FROM
		EMPLOYEES_APP_SEL_LIST_ROWS LR,
		EMPLOYEES_APP EA
	WHERE
		EA.EMPAPP_ID=LR.EMPAPP_ID 
		<cfif isdefined("attributes.list_row_id")>
		AND LR.LIST_ROW_ID IN (#attributes.list_row_id#)
		</cfif>
		<cfif isdefined("attributes.empapp_id")>
		AND EA.EMPAPP_ID IN (#attributes.empapp_id#)
		</cfif>
</cfquery>
<cfset count=1>
<cf_box title="#getLang('','Deneme Süresi Bilgileri','55325')#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
  
	<cfif not isdefined('attributes.toplu')>
        <cfform action="#request.self#?fuseaction=hr.emptypopup_start_employee&employee_stage_=#process_stage_#" name="employe_detail" method="post">
            <cf_box_elements>
                <cfinput type="hidden" name="draggable" id="draggable" value="#iif(isdefined("attributes.draggable"),1,0)#">
                <cfoutput>
                    <input type="hidden" name="empapp_id_list" id="empapp_id_list" value="#attributes.empapp_id#">
                    <input type="hidden" name="list_app_pos_id" id="list_app_pos_id" value="<cfif isdefined("attributes.list_row_id")>#attributes.list_app_pos_id#</cfif>">
                    <input type="hidden" name="emp_count" id="emp_count" value="#count#">
                </cfoutput>
                <div class="col col-6  col-xs-12" type="column" index="1" sort="true">
                    <div class="ui-info-bottom">
                        <label class="col col-12 bold"><cfoutput>#get_empapp.name# #get_empapp.surname#</cfoutput></label>
                    </div>
                    <div class="form-group" id="item-process_cat">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="58859.Süreç"></label>
                        <div class="col col-8 col-xs-12">
                            <cf_workcube_process is_upd='0' process_cat_width='150' is_detail='0'>
                        </div>
                    </div>

                    <div class="form-group" id="item-test_time">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='29776.Deneme Süresi'></label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <cfif len(xml_test_time)>
                                    <cfset test_time_value = xml_test_time>
                                <cfelse>
                                    <cfset test_time_value = 0>
                                </cfif>
                                <cfoutput><input type="text" name="test_time_#count#" id="test_time_#count#"  value="#test_time_value#"></cfoutput>
                                <span class="input-group-addon"><cf_get_lang dictionary_id='57490.gün'></label></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-caution_time">
                        <label class="col col-4 col-xs-12"></label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <cfif len(xml_caution_time)>
                                    <cfset caution_time_value = xml_caution_time>
                                <cfelse>
                                    <cfset caution_time_value = 0>
                                </cfif> 
                                <cfoutput><input type="text" name="caution_time_#count#" id="caution_time_#count#"  value="#caution_time_value#"></cfoutput>
                                
                                <span class="input-group-addon"><cf_get_lang dictionary_id='55321.gün önce uyar'></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-caution_emp">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55323.Uyarılacak Kişi'></label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <input type="hidden" name="<cfoutput>caution_emp_id_#count#</cfoutput>" id="<cfoutput>caution_emp_id_#count#</cfoutput>" value="">
                                <input type="text" name="<cfoutput>caution_emp_#count#</cfoutput>" id="<cfoutput>caution_emp_#count#</cfoutput>" value="" readonly>
                                <span class="input-group-addon icon-ellipsis btnPointer" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=hr.popup_list_positions&field_emp_id=employe_detail.caution_emp_id_#count#&field_emp_name=employe_detail.caution_emp_#count#</cfoutput>');return false"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-quiz_head">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55907.Değerlendirme Formu'></label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <cfoutput>
                                <input type="text" name="quiz_head_#count#" id="quiz_head_#count#" value="">
                                <input type="hidden" name="quiz_id_#count#" id="quiz_id_#count#" value="">
                                <span class="input-group-addon icon-ellipsis btnPointer" title="<cf_get_lang no='706.Ö D Formu'>" onclick="openBoxDraggable('#request.self#?fuseaction=hr.popup_app_list_quizs&field_quiz_id=employe_detail.quiz_id_#count#&field_quiz_head=employe_detail.quiz_head_#count#&form_type=6');"></span>
                                </cfoutput>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-test_detail">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
                        <div class="col col-8 col-xs-12">
                            <textarea name="<cfoutput>test_detail_#count#</cfoutput>" id="<cfoutput>test_detail_#count#</cfoutput>" ><!---<cfoutput>#get_app.test_detail#</cfoutput>---></textarea>
                        </div>
                    </div>
                </div>
            </cf_box_elements>
            <cf_box_footer>
                <cfsavecontent variable="message"><cf_get_lang dictionary_id="36953.İşe Eleman Alıyorsunuz. Emin misiniz?"></cfsavecontent>
                <cf_workcube_buttons is_upd='0' insert_info = "#getLang('','İşe Başlat','55703')#" add_function='kontrol()' insert_alert='#message#'>
            </cf_box_footer>
        </cfform>
    <cfelse>
        <cfform action="#request.self#?fuseaction=hr.emptypopup_start_employee&employee_stage_=#process_stage_#" name="employe_detail" method="post">
          <cf_box_elements>
            <div class="col col-6 col-xs-12" type="column" index="1" sort="true">
              <div class="form-group" >
                <cfoutput query="get_empapp">
                  <input type="hidden" name="list_row_id" id="list_row_id" value="<cfoutput>#attributes.list_row_id#</cfoutput>">
                  <input type="hidden" name="list_app_pos_id" id="list_app_pos_id" value="<cfoutput>#attributes.list_app_pos_id#</cfoutput>">
                  <input type="hidden" name="empapp_id_list" id="empapp_id_list" value="#get_empapp.empapp_id#">
                  <label class="col col-4 col-xs-12">#get_empapp.name# #get_empapp.surname#</label>
                  </cfoutput>
                  
              </div> 
              <div class="form-group" >
                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="58859.Süreç"></label>
                <div class="col col-8 col-xs-12">
                  <cf_workcube_process is_upd='0' process_cat_width='150' is_detail='0'>
                </div>
              </div> 
              <div class="form-group" >
                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='29776.Deneme Süresi'></label>
                <div class="col col-8 col-xs-12">
                  <div class="input-group">
                <cfoutput query="get_empapp">
                  <cfif len(xml_test_time)>
                    <cfset test_time_value = xml_test_time>
                  <cfelse>
                    <cfset test_time_value = 0>
                  </cfif>
									<input type="text" name="test_time_#count#" id="test_time_#count#" value="#test_time_value#">
                  <span class="input-group-addon"><cf_get_lang dictionary_id='57490.gün'></span>
                </cfoutput>
                </div>
                </div>
              </div> 
              <div class="form-group" >
                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="57425.Uyarı"></label>
                <div class="col col-8 col-xs-12">
                  <div class="input-group">
                <cfoutput query="get_empapp">
                  <cfif len(xml_caution_time)>
                    <cfset caution_time_value = xml_caution_time>
                  <cfelse>
                    <cfset caution_time_value = 0>
                  </cfif> 
											<input type="text" name="caution_time_#count#" id="caution_time_#count#" value="#caution_time_value#">
                      <span class="input-group-addon"><cf_get_lang dictionary_id='55321.gün önce uyar'></span>
                      </cfoutput>
                </div>
                </div>
              </div> 

              <div class="form-group" >
                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55323.Uyarılacak Kişi'></label>
                <div class="col col-8 col-xs-12">
                  <div class="input-group">
                    <cfoutput query="get_empapp">
                    <input type="hidden" name="<cfoutput>caution_emp_id_#count#</cfoutput>" id="<cfoutput>caution_emp_id_#count#</cfoutput>" value="">
            <input type="text" name="<cfoutput>caution_emp_#count#</cfoutput>" id="<cfoutput>caution_emp_#count#</cfoutput>" style="width:150px;" value="" readonly>
                    <span class="input-group-addon icon-ellipsis btnPointer" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=hr.popup_list_positions&field_emp_id=employe_detail.caution_emp_id_#count#&field_emp_name=employe_detail.caution_emp_#count#</cfoutput>');return false"></span>
                  </cfoutput>
                  </div>
                </div>
              </div>

                <div class="form-group" >
                  <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55907.Değerlendirme Formu'></label>
                  <div class="col col-8 col-xs-12">
                    <div class="input-group">
                      <cfoutput query="get_empapp">
                        <input type="text" name="quiz_head_#count#" id="quiz_head_#count#" value="">
                        <input type="hidden" name="quiz_id_#count#" id="quiz_id_#count#" value="">
                        <span class="input-group-addon icon-ellipsis btnPointer" title="<cf_get_lang no='706.Ö D Formu'>" onclick="openBoxDraggable('#request.self#?fuseaction=hr.popup_app_list_quizs&field_quiz_id=employe_detail.quiz_id_#count#&field_quiz_head=employe_detail.quiz_head_#count#&form_type=6');"></span>
                      </cfoutput>
                    </div>
                  </div>
                </div> 
                <div class="form-group" >
                  <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
                  <div class="col col-8 col-xs-12">
                    <textarea name="<cfoutput query="get_empapp">test_detail_#count#</cfoutput>" id="<cfoutput query="get_empapp">test_detail_#count#</cfoutput>"><!---<cfoutput>#get_app.test_detail#</cfoutput>---></textarea>
                    
                  </div>
                </div> 
                <cfoutput query="get_empapp"><cfset count=count+1></cfoutput>

            </div>
          </cf_box_elements>

                </td>
            </tr>

        <cf_box_footer>
            <cf_workcube_buttons is_upd='0' insert_info = "#getLang('','İşe Başlat','55703')#" add_function='kontrol()' insert_alert='#getLang("","İşe Eleman Alıyorsunuz. Emin misiniz?","36953")#'>
        </cf_box_footer>
        <input type="hidden" name="emp_count" id="emp_count" value="<cfoutput>#count-1#</cfoutput>">
        </cfform>
    </cfif>
</cf_box>
<!---25082005 TolgaS

<cfform action="#request.self#?fuseaction=hr.emptypopup_start_employee&empapp_id=#empapp_id#&step_no=#attributes.step_no#" name="employe_detail" method="post">
  <input type="hidden" name="empapp_id" value="<cfoutput>#empapp_id#</cfoutput>">
  <input type="hidden" name="step_no" value="<cfoutput>#step_no#</cfoutput>">
  <table width="100%" height="100%" cellpadding="0" cellspacing="0">
    <tr class="color-border">
      <td>
        <table width="100%" border="0" cellspacing="1" cellpadding="2" height="100%">
          <tr height="35" class="color-list">
            <td class="headbold">&nbsp;<cf_get_lang no='240.Deneme Süresi Bilgileri'></td>
          </tr>
          <tr class="color-row">
            <td valign="top">
              <table>
                <tr>
                  <td>&nbsp;</td>
                  <td width="100"><cf_get_lang_main no='1979.Deneme Süresi'></td>
                  <td>
                    <cfinput type="text" name="test_time" style="width:150px;" value="0">
                    <cf_get_lang_main no='78.gün'> </td>
                </tr>
                <tr>
                  <td></td>
                  <td></td>
                  <td>
                    <cfinput type="text" name="caution_time" style="width:150px;" value="0" >
                    <cf_get_lang no='236.gün önce uyar'> </td>
                </tr>
                <tr>
                  <td>&nbsp;</td>
                  <td><cf_get_lang no='238.Uyarılacak Kişi'></td>
                  <td>
                    <input type="hidden" name="caution_emp_id" value="">
                    <input type="text" name="caution_emp" style="width:150px;" value="" readonly>
                    <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_list_positions&field_emp_id=employe_detail.caution_emp_id&field_emp_name=employe_detail.caution_emp','list');return false"><img src="/images/plus_thin.gif"  align="absmiddle" border="0"></a> </td>
                </tr>
                <tr>
                  <td>&nbsp;</td>
                  <td><cf_get_lang no='822.Değerlendirme Formu'></td>
                  <td><input type="text" name="quiz_head" value="" style="width:150px;">
                    <input type="hidden" name="quiz_id" value="">
                    <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=hr.popup_app_list_quizs&field_quiz_id=employe_detail.quiz_id&field_quiz_head=employe_detail.quiz_head&form_type=6</cfoutput>','large');"> <img src="/images/plus_thin.gif" alt="<cf_get_lang no='706.Ö D Formu'>" border="0"></a> </td>
                </tr>
                <tr>
                  <td valign="top">&nbsp;</td>
                  <td valign="top"><cf_get_lang_main no='217.Açıklama'></td>
                  <td><textarea name="test_detail" style="width:255px;height:60px;"><!---<cfoutput>#get_app.test_detail#</cfoutput>---></textarea>
                  </td>
                </tr>
                <tr>
                  <td colspan="3" align="left"><input type="checkbox" name="mail_gonder" value="1">
                    <cf_get_lang_main no='63.Mail Gönder'></td>
                </tr>
                <tr>
                  <td colspan="3" align="left"><input type="checkbox" name="welcome_mail" value="1">
                    <cf_get_lang no='59.Hoşgeldin Mektubu'></td>
                </tr>
                <tr>
                  <td height="35" colspan="3"  style="text-align:right;"> <cf_workcube_buttons is_upd='0' insert_info = 'İşe başlat' insert_alert='İşe Eleman Alıyorsunuz. Emin misiniz?'> </td>
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
  function kontrol()
  {
    if (employe_detail.test_time.value =='')
	{
	  alert("Test Süresi giriniz !");
	  return false;
	}
	if (employe_detail.caution_time.value == '')
	{
	  alert("Kaç Gün Önce uyarılacak, Giriniz !");
	  return false;
	}
	if (employe_detail.caution_emp_id.value =='')
	{
	  alert("Uyarılacak Kişi Giriniz !");
	  return false;
	}
	
  }
</script>

--->
<script type="text/javascript">
	function kontrol()
	{
		if(employe_detail.process_stage.value == "")
					{
						if(employe_detail.process_stage.length > 1){
							alertObject({message: "<cf_get_lang dictionary_id='52167.Lütfen Süreç-Aşama Seçiniz'>!"});
						}
						else{
							alertObject({message: "<cf_get_lang dictionary_id='57976.Lütfen Süreçlerinizi Tanımlayınız ve/veya Tanımlanan Süreçler Üzerinde Yetkiniz Yok'>!"});
						}
						return false;
					}
					else{
          <cfoutput>  loadPopupBox('employe_detail','#attributes.modal_id#');</cfoutput>
          }
					
	}
</script>
