<cf_get_lang_set module_name="myhome"><!--- sayfanin en altinda kapanisi var --->
<cfquery name="GET_POSITION_CATS" datasource="#DSN#">
	SELECT 
    	POSITION_CAT_ID, 
        POSITION_CAT, 
        RECORD_DATE, 
        RECORD_EMP, 
        RECORD_IP,
        UPDATE_DATE, 
        UPDATE_EMP, 
        UPDATE_IP, 
        HIERARCHY, 
        POSITION_CAT_STATUS, 
        PERF_STATUS
    FROM 
	    SETUP_POSITION_CAT <!---WHERE PERF_STATUS = 1--->
</cfquery>
<cfquery name="GET_PERF_DETAIL_1" datasource="#dsn#">
	SELECT
		EMPLOYEE_PERFORMANCE.PER_ID,
		EMPLOYEE_PERFORMANCE.EMP_ID,
		EMPLOYEE_PERFORMANCE.VALID,
		EMPLOYEE_PERFORMANCE.IS_CLOSED
	FROM 
		EMPLOYEE_PERFORMANCE
	WHERE
		EMPLOYEE_PERFORMANCE.PER_ID = #attributes.PER_ID#
</cfquery>
<cfif session.ep.userid eq GET_PERF_DETAIL_1.EMP_ID and GET_PERF_DETAIL_1.valid neq 1><!---  and get_perf_detail.valid_3 eq 1 --->
	<cfquery name="get_process_1" datasource="#dsn#" maxrows="1">
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
			PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%myhome.form_add_perf_emp%">
		ORDER BY 
			PTR.LINE_NUMBER 
	</cfquery>
	<cfquery name="get_perf" datasource="#dsn#">
		UPDATE EMPLOYEE_PERFORMANCE SET PER_STAGE = #get_process_1.process_row_id# WHERE PER_ID=#GET_PERF_DETAIL_1.PER_ID#
	</cfquery>
</cfif>
<cfinclude template="../../myhome//query/get_perf_details.cfm">
<cfscript>
	attributes.emp_id = get_perf_detail.emp_id;
	attributes.employee_id = get_perf_detail.emp_id;
	attributes.quiz_id = get_perf_detail.quiz_id;
	quiz_id = get_perf_detail.quiz_id;
	attributes.position_name = get_perf_detail.EMP_POSITION_NAME;
	attributes.employee_name = get_perf_detail.employee_name;
	attributes.employee_surname = get_perf_detail.employee_surname;
	attributes.manager_1_emp_id = get_perf_detail.manager_1_emp_id;
	attributes.manager_2_emp_id = get_perf_detail.manager_2_emp_id;
	attributes.manager_3_emp_id = get_perf_detail.manager_3_emp_id;
</cfscript>
<cfinclude template="../query/get_quiz_info.cfm">
<cfinclude template="../../myhome/query/get_emp_quiz_answer.cfm">
<cfform name="add_perform" method="post" action="#request.self#?fuseaction=myhome.emptypopup_upd_perf_emp">
  <cfset sonuc_kontrol = 0>  
  <input type="hidden" name="form_open_type" id="form_open_type" value="<cfoutput>#get_quiz_info.form_open_type#</cfoutput>"><!--- form tipi acik,yari acik --->  
  <input type="hidden" name="amir_onay" id="amir_onay" value="<cfoutput>#get_perf_detail.valid_1#</cfoutput>">
  <input type="hidden" name="valid" id="valid" value="<cfoutput>#get_perf_detail.valid#</cfoutput>"><!--- calisan onay --->
  <input type="hidden" name="valid1" id="valid1" value="<cfoutput>#get_perf_detail.valid_1#</cfoutput>"><!--- 1.amir onay --->
  <input type="hidden" name="valid2" id="valid2" value="<cfoutput>#get_perf_detail.valid_2#</cfoutput>"><!--- 2.amir onay --->
  <input type="hidden" name="valid3" id="valid3" value="<cfoutput>#get_perf_detail.valid_3#</cfoutput>"><!--- gorus bildiren onay --->
  <input type="hidden" name="valid4" id="valid4" value="<cfoutput>#get_perf_detail.valid_4#</cfoutput>"><!--- ortak degerlendirme onay --->
  <input type="hidden" name="PER_ID" id="PER_ID" value="<cfoutput>#GET_PERF_DETAIL.PER_ID#</cfoutput>">
  <input type="hidden" name="RESULT_ID" id="RESULT_ID" value=" <cfoutput>#GET_PERF_DETAIL.RESULT_ID#</cfoutput>">
  <table class="dph">
    <tr>
      <td class="dpht"><cf_get_lang dictionary_id='29764.Form'> : <cfoutput>#get_quiz_info.QUIZ_HEAD#</cfoutput></td>
      <td class="dphb">
      <cfoutput>
          <cfif len(get_perf_detail.manager_3_emp_id) and session.ep.userid neq get_perf_detail.emp_id>
            <a href="javascript:windowopen('#request.self#?fuseaction=myhome.popup_perf_manager_display&per_id=#attributes.per_id#','page');"><img src="/images/partner.gif" border="0"></a>
          </cfif>
            <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_print_files&iid=#attributes.per_id#&print_type=176','page');"><img src="../images/print.gif" alt="<cf_get_lang no ='979.Puanlı'>" border="0"></a>
      </cfoutput>
      </td>
    </tr>
  </table>
  <table class="dpm">
  	<tr>
    	<td class="dpml">
  		<cf_form_box width="100%">
            <table>
                <tr>
                    <td><cf_get_lang dictionary_id='57629.Açıklama'>/<cf_get_lang dictionary_id='31420.Örnek Olaylar: Bekleneni Karşılıyor (3) dışında değerlendirdiğiniz davranış ifadeleri için Açıklama kısımlarını doldurunuz,2 örnek davranış yazınız'>.</td>
                </tr>
            </table>
            <table>
                <tr>
                    <td width="120"><cf_get_lang dictionary_id='57576.Çalışan'></td>
                    <td width="200"><cfoutput>#attributes.employee_name# #attributes.employee_surname#</cfoutput>
                        <input type="hidden" name="EMP_ID" id="EMP_ID" value="<cfoutput>#attributes.employee_id#</cfoutput>">
                        <cfif get_quiz_info.is_manager_0 eq 1><!--- Calisan Gelmemesi ile Ilgili Eklendi --->
                        <input type="hidden" name="MANAGER_0_EMP_ID" id="MANAGER_0_EMP_ID" value="<cfoutput>#attributes.employee_id#</cfoutput>">
                        </cfif>
                    </td>
						<cfif get_quiz_info.is_manager_1 eq 1>
                    <td width="100"><cf_get_lang dictionary_id ='35927.1 Amir'></td>
                    <td><input type="text" name="MANAGER_1_POS_NAME" id="MANAGER_1_POS_NAME" style="width:150px;" value="<cfif len(get_perf_detail.MANAGER_1_EMP_ID)><cfoutput>#GET_EMP_MANG_1.employee_name# #GET_EMP_MANG_1.employee_surname#</cfoutput></cfif>">
                        <input type="hidden" name="MANAGER_1_EMP_ID" id="MANAGER_1_EMP_ID" value="<cfoutput>#get_perf_detail.MANAGER_1_EMP_ID#</cfoutput>">
                        <cfif get_perf_detail.VALID_1 EQ "">
                            <a href="javascript:windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_list_positions&field_emp_name=add_perform.MANAGER_1_POS_NAME&field_emp_id=add_perform.MANAGER_1_EMP_ID','list');"><img src="/images/plus_thin.gif" border="0"></a>
                        </cfif>
                    </td>
                    </cfif>
                    <cfif get_quiz_info.is_manager_4 eq 1><!--- Ortak Degerlendirme Icin Eklendi --->
                        <input type="hidden" name="MANAGER_4_EMP_ID" id="MANAGER_4_EMP_ID" value="<cfoutput>#get_perf_detail.MANAGER_1_EMP_ID#</cfoutput>">
                    </cfif>
                </tr>
                <tr>
                    <td><cf_get_lang dictionary_id ='58497.Pozisyon'></td>
                    <td><cfoutput>#attributes.position_name#</cfoutput></td>
						<cfif get_quiz_info.is_manager_2 eq 1>
                    <td><cf_get_lang dictionary_id ='35921.2 Amir'></td>
                    <td><input type="text" name="MANAGER_2_POS_NAME" id="MANAGER_2_POS_NAME" style="width:150px;" value="<cfif len(get_perf_detail.MANAGER_2_EMP_ID)><cfoutput>#GET_EMP_MANG_2.employee_name# #GET_EMP_MANG_2.employee_surname#</cfoutput></cfif>">
                        <input type="hidden" name="MANAGER_2_EMP_ID" id="MANAGER_2_EMP_ID" value="<cfoutput>#get_perf_detail.MANAGER_2_EMP_ID#</cfoutput>">
                        <cfif get_perf_detail.VALID_2 eq "">
                            <a href="javascript:windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_list_positions&field_emp_name=add_perform.MANAGER_2_POS_NAME&field_emp_id=add_perform.MANAGER_2_EMP_ID','list');"><img src="/images/plus_thin.gif" border="0"></a>
                        </cfif>
                    </td>
                    </cfif>
                </tr>
                <tr>
                    <td><cf_get_lang dictionary_id ='58472.Dönem'> *</td>
                    <td>
                        <input type="hidden" name="old_start_date" id="old_start_date" value="<cfoutput>#DateFormat(get_perf_detail.start_date,dateformat_style)#</cfoutput>">
                        <input type="hidden" name="old_finish_date" id="old_finish_date" value="<cfoutput>#DateFormat(get_perf_detail.finish_date,dateformat_style)#</cfoutput>">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id="58053.Başlangıç Tarihi"></cfsavecontent>
                        <cfinput type="text" name="start_date" id="start_date" validate="#validate_style#" value="#DateFormat(get_perf_detail.start_date,dateformat_style)#" style="width:65px;" required="yes" message="#message#">
                        <cf_wrk_date_image date_field="start_date">				  
                        <cfsavecontent variable="message2"><cf_get_lang dictionary_id="57700.Bitiş Tarihi"></cfsavecontent>
                        <cfinput type="text" name="finish_date" id="finish_date" validate="#validate_style#" value="#DateFormat(get_perf_detail.finish_date,dateformat_style)#" style="width:65px;" required="yes" message="#message2#">
                        <cf_wrk_date_image date_field="finish_date">
                    </td>
						<cfif get_quiz_info.is_manager_3 eq 1>
                    <td><cf_get_lang dictionary_id ='29908.Görüş Bildiren'></td>
                    <td>
                        <input type="text" name="MANAGER_3_POS_NAME" id="MANAGER_3_POS_NAME" style="width:150px;" value="<cfif len(get_perf_detail.MANAGER_3_EMP_ID)><cfoutput>#GET_EMP_MANG_3.employee_name# #GET_EMP_MANG_3.employee_surname#</cfoutput></cfif>">
                        <input type="hidden" name="MANAGER_3_EMP_ID" id="MANAGER_3_EMP_ID" value="<cfoutput>#get_perf_detail.MANAGER_3_EMP_ID#</cfoutput>">
                        <cfif get_perf_detail.VALID_3 eq "">
                        <a href="javascript:windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_list_positions&field_emp_name=add_perform.MANAGER_3_POS_NAME&field_emp_id=add_perform.MANAGER_3_EMP_ID','list');"><img src="/images/plus_thin.gif" border="0"></a>
                        </cfif>
                    </td>
                    </cfif>
                </tr>
                <tr>
                    <td><cf_get_lang dictionary_id ='31401.Değerlendirme Tarihi'>*</td>
                    <td>
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='31419.Değerlendirme Tarihi girilmelidir'></cfsavecontent>
                        <cfinput type="text" name="eval_date" id="eval_date" validate="#validate_style#" value="#DateFormat(get_perf_detail.eval_date,dateformat_style)#" style="width:65px;" required="yes" message="<cf_get_lang no='662.Değerlendirme Tarihi girilmelidir'> !">
                        <cf_wrk_date_image date_field="eval_date">
                    </td>
						<cfif session.ep.userid neq get_perf_detail.MANAGER_3_EMP_ID>
                    <td><cf_get_lang dictionary_id ='31402.Kayıt tipi'></td>
                    <td>
                        <select name="RECORD_TYPE" id="RECORD_TYPE">
                            <option value="1" <cfif get_perf_detail.record_type is 1>selected</cfif>><cf_get_lang dictionary_id ='31403.Asıl'></option>
                            <option value="2" <cfif get_perf_detail.record_type is 2>selected</cfif>><cf_get_lang dictionary_id ='31406.Görüş'> 1</option>
                            <option value="4" <cfif get_perf_detail.record_type is 4>selected</cfif>><cf_get_lang dictionary_id ='31408.Ara Değerlendirme'></option>
                        </select>
                    </td>
                    </cfif>
                </tr>
                <tr>
                    <td colspan="2"></td>
                    <td><cf_get_lang dictionary_id="58859.Süreç"></td>
                    <td><cf_workcube_process is_upd='0' select_value='#get_perf_detail.per_stage#' process_cat_width='150' is_detail='1'></td>
                </tr>
            </table>
            <!--- seçilen form --->
            <cfinclude template="../../myhome/display/performance_quiz_upd.cfm">
            <cfinclude template="../query/act_quiz_perf_point.cfm"><!---burasına bakılacak niye yapıyor burdaki hesabı--->
            <input name="USER_POINT" id="USER_POINT" value="" type="hidden">
            <input name="PERFORM_POINT" id="PERFORM_POINT" value="<cfoutput>#Round(quiz_point)#</cfoutput>" type="hidden">
            <!--- görüşler --->
            <cfif get_quiz_info.is_opinion is 1>
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id="56051.Tüm Yazışma ve Değerlendirme"></cfsavecontent>
            		<cf_seperator title="#message#" id="amirlerin_gorusleri_">
                    <table id="amirlerin_gorusleri_">
                        <cfif get_quiz_info.form_open_type neq 2>
                            <cfif get_perf_detail.manager_3_emp_id neq session.ep.userid>
                                <tr>
                                    <td><cf_get_lang dictionary_id ='31435.Çalışanın Görüş ve Düşünceleri'></td>
                                </tr>
                                <tr>
                                    <td><cfif get_perf_detail.emp_id eq session.ep.userid>
                                            <textarea name="EMPLOYEE_OPINION" id="EMPLOYEE_OPINION" style="width:500px;height:40px;" onChange="CheckLen(this,1000)"><cfoutput>#get_perf_detail.EMPLOYEE_OPINION#</cfoutput></textarea>
                                        <cfelse>
                                            <cfoutput>#get_perf_detail.EMPLOYEE_OPINION#</cfoutput>
                                        </cfif>
                                    </td>
                                </tr>
                            </cfif>
                        </cfif>
                        <cfif get_perf_detail.manager_3_emp_id neq session.ep.userid and get_perf_detail.emp_id neq session.ep.userid>
                            <tr>
                                <td><cf_get_lang dictionary_id ='31436.Birinci Değerlendirme Yöneticisinin Görüş ve Düşünceleri'></td>
                            </tr>
                            <tr>
                                <td><cfif get_perf_detail.manager_1_emp_id eq session.ep.userid>
                                        <textarea name="POWERFUL_ASPECTS" id="POWERFUL_ASPECTS" style="width:500px;height:40px;" onChange="CheckLen(this,1000)"><cfoutput>#get_perf_detail.POWERFUL_ASPECTS#</cfoutput></textarea>
                                    <cfelse>
                                        <cfoutput>#get_perf_detail.POWERFUL_ASPECTS#</cfoutput>
                                    </cfif>
                                </td>
                            </tr>
                        </cfif>
                        <cfif get_perf_detail.MANAGER_3_EMP_ID eq session.ep.userid and get_perf_detail.emp_id neq session.ep.userid>
                            <tr>
                                <td><cf_get_lang dictionary_id ='31725.Görüş Bildirenin Görüş ve Düşünceleri'></td>
                            </tr>
                            <tr>
                                <td><textarea name="MANAGER_3_EVALUATION" id="MANAGER_3_EVALUATION" style="width:500px;height:40px;" onChange="CheckLen(this,1000)"><cfoutput>#get_perf_detail.MANAGER_3_EVALUATION#</cfoutput></textarea></td>
                            </tr>
                        </cfif>
                        <input type="hidden" name="TRAIN_NEED_ASPECTS" id="TRAIN_NEED_ASPECTS" value="<cfoutput>#get_perf_detail.TRAIN_NEED_ASPECTS#</cfoutput>">
                        <cfif get_perf_detail.manager_3_emp_id neq session.ep.userid and get_perf_detail.emp_id neq session.ep.userid>
                            <tr>
                                <td><cf_get_lang dictionary_id ='31437.İkinci Değerlendirme Yöneticisinin Görüş ve Düşünceleri'></td>
                            </tr>
                            <tr>
                                <td><cfif get_perf_detail.manager_2_emp_id eq session.ep.userid>
                                        <textarea name="MANAGER_2_EVALUATION" id="MANAGER_2_EVALUATION" style="width:500px;height:40px;" onChange="CheckLen(this,1000)"><cfoutput>#get_perf_detail.MANAGER_2_EVALUATION#</cfoutput></textarea>
                                    <cfelse>
                                        <cfoutput>#get_perf_detail.MANAGER_2_EVALUATION#</cfoutput>
                                    </cfif>
                                </td>
                            </tr>
                        </cfif>
                    </table>
            </cfif>
            <!--- görüşler Bitti --->
            <cfif get_quiz_info.is_career is 1>
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id="31727.Kariyer Durumu"></cfsavecontent>
                	<cf_seperator title="#message#" id="kariyer_durumu_">	
                    <table id="kariyer_durumu_">
                    <tr align="center">
                        <cfif get_quiz_info.form_open_type neq 2 and get_perf_detail.manager_3_emp_id neq session.ep.userid>
                        <td><cf_get_lang dictionary_id='57576.Çalışan'></td>
                        <td><select name="emp_career_status" id="emp_career_status" <cfif get_perf_detail.emp_id neq session.ep.userid>disabled</cfif>>
                                <option value=""><cf_get_lang dictionary_id ='57734.Seçiniz'></option>
                                <option value="1" <cfif get_perf_detail.emp_career_status eq 1>selected</cfif>><cf_get_lang dictionary_id ='29664.Bir Üst Görev İçin Uygundur'></option>
                                <option value="2" <cfif get_perf_detail.emp_career_status eq 2>selected</cfif>><cf_get_lang dictionary_id ='29665.Bir Üst Görev İçin Yetişmektedir'></option>
                                <option value="3" <cfif get_perf_detail.emp_career_status eq 3>selected</cfif>><cf_get_lang dictionary_id ='31732.Bir Üst Görev İçin Uygun Değildir'></option>
                            </select>
                        </td>
                        </cfif>
                        <cfif get_perf_detail.manager_3_emp_id eq session.ep.userid and get_perf_detail.emp_id neq session.ep.userid>
                        <td><cf_get_lang dictionary_id ='29908.Görüş Bildiren'></td>
                        <td><select name="manager_3_career_status" id="manager_3_career_status"<cfif get_perf_detail.manager_3_emp_id neq session.ep.userid>disabled</cfif>>
                                <option value=""><cf_get_lang dictionary_id ='57734.Seçiniz'></option>
                                <option value="1" <cfif get_perf_detail.manager_3_career_status eq 1>selected</cfif>><cf_get_lang dictionary_id ='29664.Bir Üst Görev İçin Uygundur'></option>
                                <option value="2" <cfif get_perf_detail.manager_3_career_status eq 2>selected</cfif>><cf_get_lang dictionary_id ='29665.Bir Üst Görev İçin Yetişmektedir'></option>
                                <option value="3" <cfif get_perf_detail.manager_3_career_status eq 3>selected</cfif>><cf_get_lang dictionary_id ='31732.Bir Üst Görev İçin Uygun Değildir'></option>
                            </select>
                        </td>
                        </cfif>
                        <cfif get_perf_detail.manager_3_emp_id neq session.ep.userid and get_perf_detail.emp_id neq session.ep.userid>
                        <td><cf_get_lang dictionary_id ='35927.birinci Amir'></td>
                        <td><select name="manager_career_status" id="manager_career_status" onchange="islem_yap_perf_pos_info();"<cfif get_perf_detail.manager_1_emp_id neq session.ep.userid>disabled</cfif>>
                                <option value=""><cf_get_lang dictionary_id ='57734.Seçiniz'></option>
                                <option value="1" <cfif get_perf_detail.manager_career_status eq 1>selected</cfif>><cf_get_lang dictionary_id ='29664.Bir Üst Görev İçin Uygundur'></option>
                                <option value="2" <cfif get_perf_detail.manager_career_status eq 2>selected</cfif>><cf_get_lang dictionary_id ='29665.Bir Üst Görev İçin Yetişmektedir'></option>
                                <option value="3" <cfif get_perf_detail.manager_career_status eq 3>selected</cfif>><cf_get_lang dictionary_id ='31732.Bir Üst Görev İçin Uygun Değildir'></option>
                            </select>
                        </td>
                        </cfif>
                        <cfif get_perf_detail.manager_3_emp_id neq session.ep.userid and get_perf_detail.emp_id neq session.ep.userid>
                        <td><cf_get_lang dictionary_id ='35921.ikinci Amir'></td>
                        <td><select name="manager_2_career_status" id="manager_2_career_status" onchange="islem_yap_perf_pos_info();"<cfif get_perf_detail.manager_2_emp_id neq session.ep.userid>disabled</cfif>>
                                <option value=""><cf_get_lang dictionary_id ='57734.Seçiniz'></option>
                                <option value="1" <cfif get_perf_detail.manager_2_career_status eq 1>selected</cfif>><cf_get_lang dictionary_id ='29664.Bir Üst Görev İçin Uygundur'></option>
                                <option value="2" <cfif get_perf_detail.manager_2_career_status eq 2>selected</cfif>><cf_get_lang dictionary_id ='29665.Bir Üst Görev İçin Yetişmektedir'></option>
                                <option value="3" <cfif get_perf_detail.manager_2_career_status eq 3>selected</cfif>><cf_get_lang dictionary_id ='31732.Bir Üst Görev İçin Uygun Değildir'></option>
                            </select>
                        </td>
                        </cfif>
                    </tr>
                    <cfif get_quiz_info.form_open_type neq 2 and get_perf_detail.manager_3_emp_id neq session.ep.userid>
                    <tr>
                        <td><cf_get_lang dictionary_id ='31617.Çalışan Açıklama'></td>
                        <td colspan="5">
                        <cfif get_perf_detail.emp_id eq session.ep.userid>
                        <textarea name="emp_career_exp" id="emp_career_exp" style="width:500px;height:40px;" onChange="CheckLen(this,500)"><cfoutput>#get_perf_detail.emp_career_exp#</cfoutput></textarea>
                        <cfelse>
                        <cfoutput>#get_perf_detail.emp_career_exp#</cfoutput>
                        </cfif>
                        </td>
                    </tr>
                    </cfif>
                    <cfif get_perf_detail.manager_3_emp_id eq session.ep.userid and get_perf_detail.emp_id neq session.ep.userid>
                    <tr>
                        <td><cf_get_lang dictionary_id ='31728.Görüş Bildiren Açıklama'></td>
                        <td colspan="5"><textarea name="manager_3_career_exp" id="manager_3_career_exp" style="width:500px;height:40px;" onChange="CheckLen(this,500)"><cfoutput>#get_perf_detail.manager_3_career_exp#</cfoutput></textarea></td>
                    </tr>
                    </cfif>
                    <cfif get_perf_detail.manager_3_emp_id neq session.ep.userid and get_perf_detail.emp_id neq session.ep.userid>
                    <tr>
                        <td><cf_get_lang dictionary_id ='35927.Birinci Amir'> <cf_get_lang dictionary_id="217.Acıklama"></td>
                        <td colspan="5">
                        <cfif get_perf_detail.manager_1_emp_id eq session.ep.userid>
                        <textarea name="manager_career_exp" id="manager_career_exp" style="width:500px;height:40px;" onChange="CheckLen(this,500)"><cfoutput>#get_perf_detail.manager_career_exp#</cfoutput></textarea>
                        <cfelse>
                        <cfoutput>#get_perf_detail.manager_career_exp#</cfoutput>
                        </cfif>
                        </td>
                    </tr>
                    </cfif>
                    <cfif get_perf_detail.manager_3_emp_id neq session.ep.userid and get_perf_detail.emp_id neq session.ep.userid>
                    <tr>
                        <td><cf_get_lang dictionary_id ='35921.İkinci Amir'> <cf_get_lang dictionary_id="57629.Acıklama"></td>
                        <td colspan="5">
                            <cfif get_perf_detail.manager_2_emp_id eq session.ep.userid>
                                <textarea name="manager_2_career_exp" id="manager_2_career_exp" style="width:500px;height:40px;" onChange="CheckLen(this,500)"><cfoutput>#get_perf_detail.manager_2_career_exp#</cfoutput></textarea>
                            <cfelse>
                                <cfoutput>#get_perf_detail.manager_2_career_exp#</cfoutput>
                            </cfif>
                        </td>
                    </tr>
                    </cfif>
                </table>
                <table>
                    <tr>
                        <td id="perf_pos_info" style="<cfif listfindnocase('1,2,3',get_perf_detail.manager_career_status)>display:;<cfelse>display:none;</cfif>">
                        <table>
                            <tr>
                                <td colspan="2"><cf_get_lang dictionary_id="41535.Uygun Görevler"></td>
                            </tr>
                            <tr>
                                <td>1-</td>
                                <td>
                                    <select name="POSITION_CAT_ID_1" id="POSITION_CAT_ID_1" style="width:200px;">
                                    <option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option>
                                    <cfoutput query="get_position_cats">
                                        <option value="#position_cat_id#"<cfif get_perf_detail.position_cat_id_1 eq position_cat_id> selected</cfif>>#position_cat#</option>
                                    </cfoutput>
                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <td>2-</td>
                                <td>
                                    <select name="POSITION_CAT_ID_2" id="POSITION_CAT_ID_2" style="width:200px;">
                                    <option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option>
                                    <cfoutput query="get_position_cats">
                                        <option value="#position_cat_id#"<cfif get_perf_detail.position_cat_id_2 eq position_cat_id> selected</cfif>>#position_cat#</option>
                                    </cfoutput>
                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <td>3-</td>
                                <td>
                                    <select name="POSITION_CAT_ID_3" id="POSITION_CAT_ID_3" style="width:200px;">
                                    <option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option>
                                    <cfoutput query="get_position_cats">
                                        <option value="#position_cat_id#"<cfif get_perf_detail.position_cat_id_3 eq position_cat_id> selected</cfif>>#position_cat#</option>
                                    </cfoutput>
                                    </select>
                                </td>
                            </tr>
                        </table>
                        </td>
                   </tr>
               </table>
            </cfif>
            <cfif get_quiz_info.is_training is 1>
                <cfsavecontent variable="message"><cf_get_lang dictionary_id="56057.Süper Kullanıcı Yetkiniz Bulunmamaktadır"></cfsavecontent>
                <cf_seperator title="#message#" id="gelisim_">	
                <cfquery name="get_training_cat" datasource="#dsn#">
                    SELECT TRAINING_CAT_ID,TRAINING_CAT FROM TRAINING_CAT
                </cfquery>
                <table id="gelisim_">
                    <tr>
                        <td><cf_get_lang dictionary_id ='29912.Eğitimler'></td>
                        <cfif get_quiz_info.form_open_type neq 2 and get_perf_detail.manager_3_emp_id neq session.ep.userid><td align="center"><cf_get_lang dictionary_id='57576.Çalışan'></td></cfif>
                        <cfif get_perf_detail.manager_3_emp_id eq session.ep.userid and get_perf_detail.emp_id neq session.ep.userid><td align="center"><cf_get_lang dictionary_id ='29908.Görüş Bildiren'></td></cfif>
                        <cfif get_perf_detail.manager_3_emp_id neq session.ep.userid and get_perf_detail.emp_id neq session.ep.userid><td align="center"><cf_get_lang dictionary_id ='35927.Birinci Amir'></td></cfif>
                        <cfif get_perf_detail.manager_3_emp_id neq session.ep.userid and get_perf_detail.emp_id neq session.ep.userid><td align="center"><cf_get_lang dictionary_id ='35921.İkinci Amir'></td></cfif>
                    </tr>
                    <cfoutput query="GET_QUIZ_CHAPTERS">
                    <tr>
                        <td>#chapter#</td>
                        <cfif get_quiz_info.form_open_type neq 2 and get_perf_detail.manager_3_emp_id neq session.ep.userid><td align="center"><input type="checkbox" name="emp_training_cat" id="emp_training_cat#currentrow#" value="#chapter_id#"<cfif get_perf_detail.emp_id neq session.ep.userid>disabled="disabled"</cfif> <cfif listfind(get_perf_detail.emp_training_cat,chapter_id,',')>checked</cfif>></td></cfif>
                        <cfif get_perf_detail.manager_3_emp_id eq session.ep.userid and get_perf_detail.emp_id neq session.ep.userid><td align="center"><input type="checkbox" name="manager_3_training_cat" id="manager_3_training_cat#currentrow#" value="#chapter_id#"<cfif get_perf_detail.manager_3_emp_id neq session.ep.userid>disabled="disabled"</cfif> <cfif listfind(get_perf_detail.manager_3_training_cat,chapter_id,',')>checked</cfif>></td></cfif>
                        <cfif get_perf_detail.manager_3_emp_id neq session.ep.userid and get_perf_detail.emp_id neq session.ep.userid><td align="center"><input type="checkbox" name="manager_training_cat" id="manager_training_cat#currentrow#" value="#chapter_id#"<cfif get_perf_detail.manager_1_emp_id neq session.ep.userid>disabled="disabled"</cfif> <cfif listfind(get_perf_detail.manager_training_cat,chapter_id,',')>checked</cfif>></td></cfif>
                        <cfif get_perf_detail.manager_3_emp_id neq session.ep.userid and get_perf_detail.emp_id neq session.ep.userid><td align="center"><input type="checkbox" name="manager_2_training_cat" id="manager_2_training_cat#currentrow#" value="#chapter_id#"<cfif get_perf_detail.manager_2_emp_id neq session.ep.userid>disabled="disabled"</cfif> <cfif listfind(get_perf_detail.manager_2_training_cat,chapter_id,',')>checked</cfif>></td></cfif>
                    </tr>
                    </cfoutput>
                    <cfif get_quiz_info.form_open_type neq 2 and get_perf_detail.manager_3_emp_id neq session.ep.userid>
                    <tr>
                        <td><cf_get_lang dictionary_id ='31617.Çalışan Açıklama'></td>
                        <td colspan="3">
                            <cfif get_perf_detail.emp_id eq session.ep.userid>
                                <textarea name="emp_training_exp" id="emp_training_exp" style="width:500px;height:40px;" onChange="CheckLen(this,500)"><cfoutput>#get_perf_detail.emp_training_exp#</cfoutput></textarea>
                            <cfelse>
                                <cfoutput>#get_perf_detail.emp_training_exp#</cfoutput>
                            </cfif>
                        </td>
                    </tr>
                    </cfif>
                    <cfif get_perf_detail.manager_3_emp_id eq session.ep.userid and get_perf_detail.emp_id neq session.ep.userid>
                    <tr>
                        <td><cf_get_lang dictionary_id ='31728.Görüş Bildiren Açıklama'></td>
                        <td colspan="3"><textarea name="manager_3_training_exp" id="manager_3_training_exp" style="width:500px;height:40px;" onChange="CheckLen(this,500)"><cfoutput>#get_perf_detail.manager_3_training_exp#</cfoutput></textarea></td>
                    </tr>
                    </cfif>
                    <cfif get_perf_detail.manager_3_emp_id neq session.ep.userid and get_perf_detail.emp_id neq session.ep.userid>
                    <tr>
                        <td><cf_get_lang dictionary_id ='35927.Birinci Amir'> <cf_get_lang dictionary_id="57629.Acıklama"></td>
                        <td colspan="3">
                            <cfif get_perf_detail.manager_1_emp_id eq session.ep.userid>
                            <textarea name="manager_training_exp" id="manager_training_exp" style="width:500px;height:40px;" onChange="CheckLen(this,500)"><cfoutput>#get_perf_detail.manager_training_exp#</cfoutput></textarea>
                            <cfelse>
                            <cfoutput>#get_perf_detail.manager_training_exp#</cfoutput>
                            </cfif>
                        </td>
                    </tr>
                    </cfif>
                    <cfif get_perf_detail.manager_3_emp_id neq session.ep.userid and get_perf_detail.emp_id neq session.ep.userid>
                    <tr>
                        <td><cf_get_lang dictionary_id ='35921.İkinci Amir'> <cf_get_lang dictionary_id="57629.Acıklama"></td>
                        <td colspan="3">
                            <cfif get_perf_detail.manager_2_emp_id eq session.ep.userid>
                            <textarea name="manager_2_training_exp" id="manager_2_training_exp" style="width:500px;height:40px;" onChange="CheckLen(this,500)"><cfoutput>#get_perf_detail.manager_2_training_exp#</cfoutput></textarea>
                            <cfelse>
                            <cfoutput>#get_perf_detail.manager_2_training_exp#</cfoutput>
                            </cfif>
                        </td>
                    </tr>
                    </cfif>
                </table>
            </cfif>
        <cfif fusebox.circuit is 'myhome'>
        <table>
            <tr>
                <td style="text-align:right;">
                <cfif datediff('m',get_perf_detail.finish_date,now()) lte 3><cf_workcube_buttons is_upd='1' add_function='kontrol()' is_delete='0'></cfif>
                </td>
            </tr>
        </table>
        <cfelseif fusebox.circuit is 'hr'>
            <cf_seperator title="IK Departmani Görüsleri" id="ik_departman_gorusleri_">	
            <table id="ik_departman_gorusleri_">
                <tr>
                    <td><cf_get_lang dictionary_id="41533.IK'nin Performans Formu Ile Ilgili Görüsü"></td>
                </tr>
                <tr>
                    <td><textarea name="hr_info" id="hr_info" style="width:500px;height:40px;" maxlength="1000" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message=""><cfoutput>#get_perf_detail.hr_info#</cfoutput></textarea></td><!--- <cfoutput>#text#</cfoutput> --->
                </tr>
                <tr>
                    <td><cf_get_lang dictionary_id="41532.IK Kariyer Görüsü"></td>
                </tr>
                <tr>
                    <td><textarea name="hr_career_info" id="hr_career_info" style="width:500px;height:40px;" maxlength="1000" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message=""><cfoutput>#get_perf_detail.hr_career_info#</cfoutput></textarea></td><!--- <cfoutput>#text#</cfoutput> --->
                </tr>
            </table>
             <cf_seperator title="Genel Degerlendirme (IK Departmani)" id="genel_degerlendirme_ik_">	 
             <table id="genel_degerlendirme_ik_">
             <input name="USER_POINT" id="USER_POINT" value="" type="hidden">
             <input name="PERFORM_POINT" id="PERFORM_POINT" value="<cfoutput>#Round(quiz_point)#</cfoutput>" type="hidden">
             <input name="PERFORM_POINT_ID" id="PERFORM_POINT_ID" type="hidden" value="1">
             <tr>
                <td><cf_get_lang dictionary_id="41531.Çalisanin Kendine Verdigi Puan"></td>
                <td><cfif not len(get_perf_detail.emp_point)><cfset get_perf_detail.emp_point=0></cfif>
                    <cfoutput>#wrk_round(get_perf_detail.emp_point)# / 100</cfoutput><!--- #get_perf_detail.emp_perform_point/10# ham puan olarak degilde 100 olarak alinmasi istendi--->
                </td>			
             </tr>
             <cfif len(get_perf_detail.MANAGER3_PERFORM_POINT) and len(get_perf_detail.MANAGER3_POINT)> 
                <tr>
                    <td><cf_get_lang dictionary_id="41530.Görüs Bildiren Degerlendirme Puani"></td>
                    <td><cfoutput>#wrk_round(get_perf_detail.MANAGER3_POINT)# / 100</cfoutput></td> <!--- #get_perf_detail.MANAGER3_PERFORM_POINT/10# --->
                </tr>
             </cfif>
             <cfif get_quiz_info.is_extra_record is 1>
                <tr>
                    <td><cf_get_lang dictionary_id="41529.Birinci Amirin Çalisana Verdigi Puan"></td>
                    <td><cfif not len(get_perf_detail.MANAGER_POINT)><cfset get_perf_detail.MANAGER_POINT=0></cfif>
                        <cfif not len(get_perf_detail.MANAGER_PERFORM_POINT)><cfset get_perf_detail.MANAGER_PERFORM_POINT=0></cfif>
                        <cfoutput>#wrk_round(get_perf_detail.MANAGER_POINT)# / 100</cfoutput><!--- #get_perf_detail.MANAGER_PERFORM_POINT/10# --->
                    </td> 
                </tr>
             </cfif>	
             <cfif get_quiz_info.is_extra_record is 1>
                <tr>
                    <td><cf_get_lang dictionary_id="41528.İkinci Amirin Çalisana Verdigi Puan"></td>
                    <td><cfif not len(get_perf_detail.MANAGER2_POINT)><cfset get_perf_detail.MANAGER2_POINT=0></cfif>
                        <cfif not len(get_perf_detail.MAN_EMP_PERFORM_POINT)><cfset get_perf_detail.MAN_EMP_PERFORM_POINT=0></cfif>
                        <cfoutput>#wrk_round(get_perf_detail.MANAGER2_POINT)# / 100</cfoutput><!--- #get_perf_detail.MAN_EMP_PERFORM_POINT/10# --->
                    </td> 
                </tr>
             </cfif>				 
             <tr>
                <td>Degerlendirme Puani</td>
                <td><cfquery name="get_weight" datasource="#dsn#">
                        SELECT ISNULL(EMP_QUIZ_WEIGHT,0) EMP_QUIZ_WEIGHT,ISNULL(MANAGER_QUIZ_WEIGHT_3,0) MANAGER_QUIZ_WEIGHT_3,ISNULL(MANAGER_QUIZ_WEIGHT_2,0) MANAGER_QUIZ_WEIGHT_2,ISNULL(MANAGER_QUIZ_WEIGHT_1,0) MANAGER_QUIZ_WEIGHT_1 FROM EMPLOYEE_QUIZ WHERE QUIZ_ID = #get_perf_detail.quiz_id# 
                    </cfquery>
                    <cfif not len(get_perf_detail.emp_point)><cfset get_perf_detail.emp_point = 0></cfif>
                    <cfif not len(get_perf_detail.MANAGER3_POINT)><cfset get_perf_detail.MANAGER3_POINT = 0></cfif>
                    <cfif not len(get_perf_detail.MANAGER_POINT)><cfset get_perf_detail.MANAGER_POINT = 0></cfif>
                    <cfif not len(get_perf_detail.MANAGER2_POINT)><cfset get_perf_detail.MANAGER2_POINT = 0></cfif>
                    <cfif not len(get_perf_detail.MAN_EMP_POINT)><cfset get_perf_detail.MAN_EMP_POINT = 0></cfif>
                    <cfset user_point_ = ((get_perf_detail.emp_point * get_weight.emp_quiz_weight)+(get_perf_detail.MANAGER3_POINT*get_weight.manager_quiz_weight_3)+(get_perf_detail.MANAGER2_POINT*get_weight.manager_quiz_weight_2)+(get_perf_detail.MANAGER_POINT*get_weight.manager_quiz_weight_1))/100><!--- +(get_perf_detail.MAN_EMP_POINT*get_weight.manager_quiz_weight_1) --->
                    <cfoutput>#wrk_round(user_point_)# / 100</cfoutput><!--- #get_perf_detail.PERFORM_POINT/10# --->
                </td> 
                <!---<td><cfif not len(get_perf_detail.USER_POINT)><cfset get_perf_detail.USER_POINT=0></cfif>
                    <cfoutput>#wrk_round(get_perf_detail.USER_POINT)# / #get_perf_detail.PERFORM_POINT#</cfoutput>
                </td> --->
            </tr>
            <!--- <cfif get_quiz_info.is_extra_record_emp is 1>
                <cfif IsNumeric(get_perf_detail.emp_point) and IsNumeric(get_perf_detail.emp_perform_point)>
                    <tr>
                        <td>Çalisanin Kendine Verdigi Degerlendirme Notu<!---  (5 üzerinden) ---></td>
                        <td><strong>(<cfoutput>#get_perf_detail.emp_point_over_5#</cfoutput> / 5)</strong></td>
                    </tr>
                </cfif>
            </cfif>
            <cfif get_quiz_info.is_extra_record is 1>	
                <cfif IsNumeric(get_perf_detail.manager_point) and IsNumeric(get_perf_detail.manager_perform_point)>
                    <tr>
                        <td>Amirin Çalisana Verdigi Puan Degerlendirme Notu<!---  (5 üzerinden) ---></td>
                        <td><strong>(<cfoutput>#get_perf_detail.manager_point_over_5#</cfoutput> / 5)</strong></td>
                    </tr>
                </cfif>
            </cfif>
            <cfif IsNumeric(get_perf_detail.USER_POINT) and IsNumeric(get_perf_detail.perform_point)>
                <tr>
                    <td>Degerlendirme Puani<!---  (5 üzerinden) ---></td>
                    <td><strong>(<cfoutput>#get_perf_detail.USER_POINT_OVER_5#</cfoutput> / 5)</strong></td>
                </tr>
            </cfif> --->
            </table>
       </cfif>
            <cf_form_box_footer>
            	<cf_record_info update_emp="UPDATE_KEY" record_emp="RECORD_KEY" query_name="GET_PERF_DETAIL">
              <cfif GET_PERF_DETAIL_1.is_closed neq 1 or session.ep.admin eq 1>
                <cfif session.ep.admin eq 1>
                    <cf_workcube_buttons add_function='kontrol()' is_upd='1' delete_page_url='#request.self#?fuseaction=hr.emptypopup_del_perf_emp&per_id=#get_perf_detail.PER_ID#&head=#attributes.employee_name# #attributes.employee_surname#'>
                <cfelseif session.ep.ehesap>
                    <cf_workcube_buttons add_function='kontrol()' is_upd='1' is_delete='0'>
                </cfif><!--- açiklmaa 2 tane olunca  add_function='check_expl()' kaldirildi---> 
            </cfif>
            </cf_form_box_footer>
        </cf_form_box>
   </td>
   <td class="dpmr">
	<cf_get_workcube_asset asset_cat_id="-9" module_id='3' action_section='QUIZ_ID' action_id='#attributes.quiz_id#'>
   </td>
  </tr>
 </table>
</cfform>
<script language="javascript">
function islem_yap_perf_pos_info()
{
	if(document.add_perform.manager_career_status != undefined && (document.add_perform.manager_career_status.value == '1' || document.add_perform.manager_career_status.value == '2' || document.add_perform.manager_career_status.value == '3' || document.add_perform.manager_2_career_status.value == '1' || document.add_perform.manager_2_career_status.value == '2' || document.add_perform.manager_2_career_status.value == '3'))
	{
		goster(perf_pos_info);
	}
	else
	{
		gizle(perf_pos_info);
	}
}

function kontrol()
{
	<cfif get_quiz_info.is_manager_3 eq 1 and get_perf_detail.manager_3_emp_id neq session.ep.userid>
	if(document.add_perform.manager_career_status != undefined && (document.add_perform.manager_career_status.value == '3' || document.add_perform.manager_career_status.value == '4' || document.add_perform.manager_career_status.value == '5'))
	{
		if(document.add_perform.POSITION_CAT_ID_1.value == '')
		{
			alert("<cf_get_lang dictionary_id='41527.Bu Aşamada Uygun Görülen Pozisyon Tipini Seçmelisiniz'>!");
			return false;
		}
	}
	</cfif>
	//return process_cat_control();
	if(process_cat_control())
	{
		var loop_count = <cfoutput>#GET_QUIZ_CHAPTERS.recordcount#</cfoutput>;
		for(i=1;i<=loop_count;++i)
		{
			document.getElementById('emp_training_cat'+i).disabled = false;
			document.getElementById('manager_training_cat'+i).disabled = false;
			document.getElementById('manager_2_training_cat'+i).disabled = false;
			if(document.getElementById('manager_3_training_cat'+i) != undefined)
			document.getElementById('manager_3_training_cat'+i).disabled = false;
		}
		return true;
	}
	else
		return false;
}

function CheckLen(Target,limit) 
{
	StrLen = Target.value.length;
	if (StrLen == 1 && Target.value.substring(0,1) == " ") 
	{
		Target.value = "";
		StrLen = 0;
	}
	if (StrLen > limit ) 
	{
		Target.value = Target.value.substring(0,limit);
		CharsLeft = 0;
		alert("<cf_get_lang dictionary_id ='58774.Maksimum açıklama uzunluğu'>" + ":" + limit);
	}
	else 
	{
		CharsLeft = StrLen;
	}
}

</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
