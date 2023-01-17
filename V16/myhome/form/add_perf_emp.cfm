<cfif not isdefined("attributes.quiz_id")>
	<script type="text/javascript">
		alert("<cf_get_lang dictionary_id ='31933.Bu Tipe Ait Form Bulunmamaktadır Kontrol Ediniz'> !");
		history.back();	
	</script>
	<cfabort>
</cfif>
<cfquery name="GET_POSITION_CATS" datasource="#dsn#">
	SELECT POSITION_CAT, POSITION_CAT_ID FROM SETUP_POSITION_CAT WHERE PERF_STATUS = 1
</cfquery>
<cfquery name="GET_QUIZ_INFO" datasource="#dsn#">
	SELECT 
		QUIZ_HEAD,
		IS_EXTRA_RECORD,
		IS_EXTRA_RECORD_EMP,
		IS_RECORD_TYPE,
		IS_VIEW_QUESTION,
		IS_EXTRA_QUIZ,
		IS_MANAGER_0,
		IS_MANAGER_1,
		IS_MANAGER_2,
		IS_MANAGER_3,
		IS_MANAGER_4,
		IS_CAREER,
		IS_TRAINING,
		IS_OPINION,
		FORM_OPEN_TYPE
	FROM 
		EMPLOYEE_QUIZ
	WHERE
		QUIZ_ID = #attributes.QUIZ_ID#
</cfquery>
<cfquery name="GET_EMP_CODES" datasource="#dsn#">
	SELECT 
		DEPARTMENT.BRANCH_ID, 
		DEPARTMENT.ADMIN1_POSITION_CODE AS DEPT_ADMIN1_POSITION_CODE, 
		BRANCH.ADMIN1_POSITION_CODE AS BRANCH_ADMIN1_POSITION_CODE,
		EMPLOYEE_POSITIONS.POSITION_NAME,
		EMPLOYEE_POSITIONS.POSITION_CODE
	FROM 
		EMPLOYEE_POSITIONS, DEPARTMENT, BRANCH
	WHERE
		EMPLOYEE_POSITIONS.EMPLOYEE_ID = #attributes.EMPLOYEE_ID# AND
		EMPLOYEE_POSITIONS.DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID AND
		DEPARTMENT.BRANCH_ID = BRANCH.BRANCH_ID AND
		EMPLOYEE_POSITIONS.IS_MASTER=1
</cfquery>
<cfquery name="GET_EMPLOYEE" datasource="#dsn#">
	SELECT EMPLOYEE_NAME, EMPLOYEE_SURNAME, MEMBER_CODE FROM EMPLOYEES WHERE EMPLOYEE_ID = #attributes.EMPLOYEE_ID#
</cfquery>
<cfquery name="get_standbys" datasource="#dsn#">
	SELECT
		EMPLOYEE_POSITIONS.POSITION_CODE,
		EMPLOYEE_POSITIONS.EMPLOYEE_ID,		
		EMPLOYEE_POSITIONS_STANDBY.CHIEF1_CODE,
		EMPLOYEE_POSITIONS_STANDBY.CHIEF2_CODE,
		EMPLOYEE_POSITIONS_STANDBY.CHIEF3_CODE
	FROM
		EMPLOYEE_POSITIONS_STANDBY,
		EMPLOYEE_POSITIONS,
		EMPLOYEES
	WHERE
		EMPLOYEES.EMPLOYEE_ID = EMPLOYEE_POSITIONS.EMPLOYEE_ID AND
		EMPLOYEE_POSITIONS.POSITION_CODE = EMPLOYEE_POSITIONS_STANDBY.POSITION_CODE AND
		EMPLOYEE_POSITIONS_STANDBY.POSITION_CODE=#GET_EMP_CODES.POSITION_CODE#
</cfquery>
<cf_popup_box title="#getLang('myhome',1967)# #get_quiz_info.quiz_head#">
    <cfform name="add_perform" method="post" action="#request.self#?fuseaction=myhome.emptypopup_add_perf_emp">
        <input type="hidden" name="form_open_type" id="form_open_type" value="<cfoutput>#get_quiz_info.form_open_type#</cfoutput>"><!--- Form tipi 1 acik,2 yari_acik--->
        <input type="hidden" name="valid" id="valid" value=""><!--- calisan onay --->
        <input type="hidden" name="valid1" id="valid1" value=""><!--- 1.amir onay --->
        <input type="hidden" name="valid2" id="valid2" value=""><!--- 2.amir onay --->
        <input type="hidden" name="valid3" id="valid3" value=""><!--- gorus bildiren onay --->
        <input type="hidden" name="valid4" id="valid4" value=""><!--- ortak degerlendirme onay --->
        <input type="hidden" name="start_date" id="start_date" value="<cfif not isdefined("attributes.display")><cfoutput>#attributes.start_date#</cfoutput></cfif>">
        <input type="hidden" name="finish_date"  id="finish_date" value="<cfif not isdefined("attributes.display")><cfoutput>#attributes.finish_date#</cfoutput></cfif>">
        <input type="hidden" name="diplay" id="display" value="<cfif isdefined("attributes.display")><cfoutput>#attributes.display#</cfoutput></cfif>">
        <table width="100%" cellspacing="1" cellpadding="2">
			<cfif not isdefined("attributes.display")>
            <tr>
                <td height="22" class="txtboldblue"><cf_get_lang dictionary_id ='57629.Açıklama'>/<cf_get_lang dictionary_id ='31420.Örnek Olaylar "Bekleneni Karşılıyor" (3) dışında değerlendirdiğiniz davranış ifadeleri için Açıklama kısımlarını doldurunuz,2 örnek davranış yazınız'></td>
            </tr>
            <tr>
                <td>
                <table>
                    <tr>
                        <td width="100"><cf_get_lang dictionary_id='57576.Çalışan'> </td>
                        <td width="180">
                            <cfoutput>#GET_EMPLOYEE.employee_name# #GET_EMPLOYEE.employee_surname#</cfoutput>
                            <input type="hidden" name="EMP_ID" id="EMP_ID" value="<cfoutput>#attributes.employee_id#</cfoutput>">
                            <cfif get_quiz_info.is_manager_0 eq 1>
                                <input type="hidden" name="MANAGER_0_EMP_ID" id="MANAGER_0_EMP_ID" value="<cfoutput>#attributes.employee_id#</cfoutput>">
                            </cfif>
                        </td>
                        <cfif get_quiz_info.is_manager_1 eq 1>
                            <td width="110">1.<cf_get_lang dictionary_id='29666.Amir'></td>
                            <td width="180">
                                <cfif IsNumeric(get_standbys.CHIEF1_CODE)>
                                    <cfquery name="get_chief1_name" datasource="#dsn#">
                                        SELECT EMPLOYEE_NAME,EMPLOYEE_SURNAME,EMPLOYEE_ID FROM EMPLOYEE_POSITIONS WHERE POSITION_CODE=#get_standbys.CHIEF1_CODE#
                                    </cfquery>
                                </cfif> 
                                <input type="text" readonly="yes" name="MANAGER_1_POS_NAME" id="MANAGER_1_POS_NAME" style="width:150px;" <cfif IsNumeric(get_standbys.CHIEF1_CODE)>value="<cfoutput>#get_chief1_name.EMPLOYEE_NAME# #get_chief1_name.EMPLOYEE_SURNAME#</cfoutput>"</cfif>>
                                <input type="hidden" name="MANAGER_1_POS" id="MANAGER_1_POS" <cfif IsNumeric(get_standbys.CHIEF1_CODE)>value="<cfoutput>#get_standbys.CHIEF1_CODE#</cfoutput>"</cfif>>
                                <input type="hidden" name="MANAGER_1_EMP_ID" id="MANAGER_1_EMP_ID" <cfif IsNumeric(get_standbys.CHIEF1_CODE)>value="<cfoutput>#get_chief1_name.EMPLOYEE_ID#</cfoutput>"</cfif>>
                                <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_list_positions&field_emp_name=add_perform.MANAGER_1_POS_NAME&field_emp_id=add_perform.MANAGER_1_EMP_ID','list');"><img src="/images/plus_thin.gif" border="0" align="absmiddle"></a>
                            </td>
                        </cfif>
                    </tr>
                    <tr>
                        <td><cf_get_lang dictionary_id ='30978.Pozisyonu'></td>
                        <td><cfoutput>#GET_EMP_CODES.POSITION_NAME#</cfoutput><input type="hidden" name="position_name" id="position_name" value="<cfoutput>#GET_EMP_CODES.POSITION_NAME#</cfoutput>"></td>
                        <cfif get_quiz_info.is_manager_2 eq 1>
                            <td>2.<cf_get_lang dictionary_id='29666.Amir'></td>
                            <td><cfif IsNumeric(get_standbys.CHIEF2_CODE)>
                                    <cfquery name="get_chief2_name" datasource="#dsn#">
                                        SELECT EMPLOYEE_NAME,EMPLOYEE_SURNAME,EMPLOYEE_ID FROM EMPLOYEE_POSITIONS WHERE POSITION_CODE=#get_standbys.CHIEF2_CODE#
                                    </cfquery>
                                </cfif>
                                <input type="text" name="MANAGER_2_POS_NAME" id="MANAGER_2_POS_NAME" style="width:150px;" readonly="yes" <cfif IsNumeric(get_standbys.CHIEF2_CODE)>value="<cfoutput>#get_chief2_name.EMPLOYEE_NAME# #get_chief2_name.EMPLOYEE_SURNAME#</cfoutput>"</cfif>>
                                <input type="hidden" name="MANAGER_2_POS" id="MANAGER_2_POS" <cfif IsNumeric(get_standbys.CHIEF2_CODE)>value="<cfoutput>#get_standbys.CHIEF2_CODE#</cfoutput>"</cfif>>
                                <input type="hidden" name="MANAGER_2_EMP_ID" id="MANAGER_2_EMP_ID" <cfif IsNumeric(get_standbys.CHIEF2_CODE)>value="<cfoutput>#get_chief2_name.EMPLOYEE_ID#</cfoutput>"</cfif>>
                            </td>
                        </cfif>
                        <cfif get_quiz_info.is_manager_4 eq 1><!--- Ortak Degerlendirme Icin Eklendi --->
                            <input type="hidden" name="MANAGER_4_EMP_ID" id="MANAGER_4_EMP_ID" value="<cfif IsNumeric(get_standbys.CHIEF1_CODE)><cfoutput>#get_chief1_name.EMPLOYEE_ID#</cfoutput></cfif>">
                       </cfif>
                    </tr>
                    <tr>
                        <td><cf_get_lang dictionary_id='58472.Dönem'></td>
                        <td><cfoutput>#attributes.start_date# - #attributes.finish_date#</cfoutput></td>
                        <cfif get_quiz_info.is_manager_3 eq 1>
                            <td><cf_get_lang dictionary_id ='29908.Görüş Bildiren'></td>
                            <td><cfif IsNumeric(get_standbys.CHIEF3_CODE)>
                                    <cfquery name="get_chief3_name" datasource="#dsn#">
                                        SELECT EMPLOYEE_NAME,EMPLOYEE_SURNAME,EMPLOYEE_ID FROM EMPLOYEE_POSITIONS WHERE POSITION_CODE=#get_standbys.CHIEF3_CODE#
                                    </cfquery>
                                </cfif> 
                                <input type="text" readonly="yes" name="MANAGER_3_POS_NAME" id="MANAGER_3_POS_NAME" style="width:150px;" <cfif IsNumeric(get_standbys.CHIEF3_CODE)>value="<cfoutput>#get_chief3_name.EMPLOYEE_NAME# #get_chief3_name.EMPLOYEE_SURNAME#</cfoutput>"</cfif>>
                                <input type="hidden" name="MANAGER_3_POS" id="MANAGER_3_POS" <cfif IsNumeric(get_standbys.CHIEF3_CODE)>value="<cfoutput>#get_standbys.CHIEF3_CODE#</cfoutput>"</cfif>>
                                <input type="hidden" name="MANAGER_3_EMP_ID" id="MANAGER_3_EMP_ID" <cfif IsNumeric(get_standbys.CHIEF3_CODE)>value="<cfoutput>#get_chief3_name.EMPLOYEE_ID#</cfoutput>"</cfif>>
                            </td>
                        </cfif>
                    </tr>
                    <tr>
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>
                        <td><cf_get_lang dictionary_id='31401.Değerlendirme Tarihi'> *</td>
                        <td><cfsavecontent variable="alert"><cf_get_lang dictionary_id ='31419.Değerlendirme Tarihi Girmelisiniz'></cfsavecontent>
                            <cfinput type="text" name="eval_date" id="eval_date" validate="#validate_style#" value="#dateformat(now(),dateformat_style)#" style="width:75px;" required="yes" message="#alert#">
                            <cf_wrk_date_image date_field="eval_date">
                        </td>
                    </tr>
                    <tr>
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>
                        <td><cf_get_lang dictionary_id='31402.Kayıt Tipi'></td>
                        <td><select name="RECORD_TYPE" id="RECORD_TYPE" style="width:150px;">
                                <option value="1"><cf_get_lang dictionary_id='31403.Asıl'></option>
                                <option value="2"><cf_get_lang dictionary_id='31406.Görüş'> 1</option>
                                <option value="3"><cf_get_lang dictionary_id='31406.Görüş'> 2</option>
                                <option value="4" <cfif dateformat(attributes.finish_date,'MM') lte 6>selected</cfif>><cf_get_lang dictionary_id='31408.Ara Değerlendirme'></option>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>
                        <td><cf_get_lang dictionary_id="58859.Süreç"></td>
                        <td><cf_workcube_process is_upd='0' process_cat_width='150' is_detail='0'></td>
                    </tr>
                </table>
                </td>
            </tr>
            </cfif>
            <cfinclude template="../display/performance_quiz.cfm">
            <cfinclude template="../query/act_quiz_perf_point.cfm">
			<cfif get_quiz_info.IS_OPINION is 1>
				<cfsavecontent variable="message"><cf_get_lang dictionary_id='31724.Amirlerin Görüşleri'></cfsavecontent>
                <cf_seperator id="b_man_evaluation_table" title="#message#">
                <table id="b_man_evaluation_table">
                    <cfsavecontent variable="message1"><cf_get_lang dictionary_id='29484.Fazla karakter sayısı'></cfsavecontent>
                    <cfif get_quiz_info.form_open_type neq 2>
                        <cfif attributes.employee_id eq session.ep.userid or isdefined("attributes.display")>
                            <tr>
                                <td><cf_get_lang dictionary_id ='31435.Çalışanın Görüş ve Düşünceleri'></td>
                            </tr>
                            <tr>
                                <td><textarea name="EMPLOYEE_OPINION" id="EMPLOYEE_OPINION" style="width:500px;height:40px;" maxlength="1000" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="<cfoutput>#message1#</cfoutput>"></textarea></td>
                            </tr>
                        </cfif>
                    </cfif>
                    <cfif len(get_standbys.CHIEF1_CODE) and get_standbys.CHIEF1_CODE eq session.ep.position_code>
                        <tr>
                            <td><cf_get_lang dictionary_id ='31436.Birinci Değerlendirme Yöneticisinin Değerlendirmesi'></td>
                        </tr>
                        <tr>
                            <td><textarea name="POWERFUL_ASPECTS" id="POWERFUL_ASPECTS" style="width:500px;height:40px;" maxlength="1000" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="<cfoutput>#message1#</cfoutput>"></textarea></td>
                        </tr>
                    </cfif>
                    <tr>
                        <td><input type="hidden" name="TRAIN_NEED_ASPECTS" id="TRAIN_NEED_ASPECTS"></td>
                    </tr>
                    <cfif len(get_standbys.CHIEF3_CODE) and get_standbys.CHIEF1_CODE eq session.ep.position_code>
                        <tr>
                            <td><cf_get_lang dictionary_id ='31725.Görüş Bildirenin Görüş ve Düşünceleri'></td>
                        </tr>
                        <tr>
                            <td><textarea name="MANAGER_3_EVALUATION" id="MANAGER_3_EVALUATION" style="width:500px;height:40px;" maxlength="1000" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="<cfoutput>#message1#</cfoutput>"></textarea></td>
                        </tr>
                    </cfif>
                    <cfif len(get_standbys.CHIEF2_CODE) and get_standbys.CHIEF1_CODE eq session.ep.position_code>
                        <tr>
                            <td><cf_get_lang dictionary_id ='31437.İkinci Değerlendirme Yöneticisinin Görüş ve Düşünceleri'></td>
                        </tr>
                        <tr>
                            <td><textarea name="MANAGER_2_EVALUATION" id="MANAGER_2_EVALUATION" style="width:500px;height:40px;" maxlength="1000" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="<cfoutput>#message1#</cfoutput>"></textarea></td>
                        </tr>
                    </cfif>
                </table>
            </cfif>
			<cfif get_quiz_info.is_career is 1>
				<cfsavecontent variable="message"><cf_get_lang dictionary_id='31727.Kariyer Durumu'></cfsavecontent>
                <cf_seperator id="b_carrer_table" title="#message#">
                <table id="b_carrer_table">
                    <tr valign="top">
                        <td>
                        <table>
                            <tr>
                                <cfif attributes.employee_id eq session.ep.userid or isdefined("attributes.display")>
                                    <td><cf_get_lang dictionary_id='57576.Çalışan'></td>
                                    <td><select name="emp_career_status" id="emp_career_status">
                                            <option value=""><cf_get_lang dictionary_id ='57734.Seçiniz'></option>
                                            <option value="1"><cf_get_lang dictionary_id ='29664.Bir Üst Görev İçin Uygundur'></option>
                                            <option value="2"><cf_get_lang dictionary_id ='29665.Bir Üst Görev İçin Yetişmektedir'></option>
                                            <option value="3"><cf_get_lang dictionary_id ='31732.Bir Üst Görev İçin Uygun Değildir'></option>
                                        </select>
                                    </td>
                                </cfif>
                                <cfif len(get_standbys.CHIEF1_CODE) and get_standbys.CHIEF1_CODE eq session.ep.position_code>
                                    <td><cf_get_lang dictionary_id='29511.Yönetici'></td>
                                    <td><select name="manager_career_status" id="manager_career_status" onchange="islem_yap_perf_pos_info();">
                                            <option value=""><cf_get_lang dictionary_id ='57734.Seçiniz'></option>
                                            <option value="1"><cf_get_lang dictionary_id ='29664.Bir Üst Görev İçin Uygundur'></option>
                                            <option value="2"><cf_get_lang dictionary_id ='29665.Bir Üst Görev İçin Yetişmektedir'></option>
                                            <option value="3"><cf_get_lang dictionary_id ='31732.Bir Üst Görev İçin Uygun Değildir'></option>
                                        </select>
                                    </td>
                                </cfif>
                                <cfif len(get_standbys.CHIEF3_CODE) and get_standbys.CHIEF3_CODE eq session.ep.position_code>
                                    <td><cf_get_lang dictionary_id ='29908.Görüş Bildiren'></td>
                                    <td align="left">
                                        <select name="manager_3_career_status" id="manager_3_career_status">
                                            <option value=""><cf_get_lang dictionary_id ='57734.Seçiniz'></option>
                                            <option value="1"><cf_get_lang dictionary_id ='29664.Bir Üst Görev İçin Uygun Değildir'></option>
                                            <option value="2"><cf_get_lang dictionary_id ='31733.Bir Üst Görev İçin Henüz Yetişmektedir'></option>
                                            <option value="3"><cf_get_lang dictionary_id ='31734.Bir Üst Görev İçin Yetişmiştir'></option>
                                            <option value="4"><cf_get_lang dictionary_id ='31735.Bir Üst Göreve Yükseltilebilir'></option>
                                            <option value="5"><cf_get_lang dictionary_id ='31736.Bir Üst Göreve Yükseltilmesi Gereklidir'></option>
                                        </select>
                                    </td>
                                </cfif>
                            </tr>
                            <cfif attributes.employee_id eq session.ep.userid or isdefined("attributes.display")>
                                <tr>
                                    <td><cf_get_lang dictionary_id ='31617.Çalışan Açıklama'></td>
                                    <td colspan="5"><textarea name="emp_career_exp" id="emp_career_exp" style="width:500px;height:40px;" maxlength="500" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="<cfoutput>#message1#</cfoutput>"></textarea></td>
                                </tr>
                            </cfif>
                            <cfif len(get_standbys.CHIEF3_CODE) and get_standbys.CHIEF3_CODE eq session.ep.position_code>
                                <tr>
                                    <td><cf_get_lang dictionary_id ='31728.Görüş Bildiren Açıklama'></td>
                                    <td colspan="5"><textarea name="manager_3_career_exp" id="manager_3_career_exp" style="width:500px;height:40px;" maxlength="500" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="<cfoutput>#message1#</cfoutput>"></textarea></td>
                                </tr>
                            </cfif>
                            <cfif len(get_standbys.CHIEF1_CODE) and get_standbys.CHIEF1_CODE eq session.ep.position_code>
                                <tr>
                                    <td><cf_get_lang dictionary_id ='31729.Yönetici Açıklama'></td>
                                    <td colspan="5"><textarea name="manager_career_exp" id="manager_career_exp" style="width:500px;height:40px;" maxlength="500" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="<cfoutput>#message1#</cfoutput>"></textarea></td>
                                </tr>
                            </cfif>
                        </table>
                        </td>
                        <td id="perf_pos_info" style="<cfif len(get_standbys.CHIEF1_CODE) and get_standbys.CHIEF1_CODE eq session.ep.position_code>display:;<cfelse>display:none;</cfif>">
                        <table>
                            <tr>
                                <td colspan="2"><cf_get_lang dictionary_id='41535.Uygun Görevler'></td>
                            </tr>
                            <tr>
                                <td>1-</td>
                                <td><select name="POSITION_CAT_ID_1" id="POSITION_CAT_ID_1" style="width:200px;">
                                        <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                        <cfoutput query="get_position_cats">
                                            <option value="#position_cat_id#">#position_cat#</option>
                                        </cfoutput>
                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <td>2-</td>
                                <td><select name="POSITION_CAT_ID_2" id="POSITION_CAT_ID_2" style="width:200px;">
                                        <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                        <cfoutput query="get_position_cats">
                                            <option value="#position_cat_id#">#position_cat#</option>
                                        </cfoutput>
                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <td>3-</td>
                                <td><select name="POSITION_CAT_ID_3" id="POSITION_CAT_ID_3" style="width:200px;">
                                        <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                        <cfoutput query="get_position_cats">
                                            <option value="#position_cat_id#">#position_cat#</option>
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
                <cfquery name="get_training_cat" datasource="#dsn#">
                    SELECT TRAINING_CAT_ID,TRAINING_CAT FROM TRAINING_CAT
				</cfquery>
				<cfsavecontent variable="message"><cf_get_lang dictionary_id='31730.Gelişim'></cfsavecontent>
                <cf_seperator id="b_gelisim_table" title="#message#">
                <table id="b_gelisim_table">
                    <tr>
                        <td><cf_get_lang dictionary_id ='29912.Eğitimler'></td>
                        <cfif attributes.employee_id eq session.ep.userid or isdefined("attributes.display")><td align="center"><cf_get_lang dictionary_id='57576.Çalışan'></td></cfif>
                        <cfif len(get_standbys.CHIEF1_CODE) and get_standbys.CHIEF1_CODE eq session.ep.position_code><td align="center"><cf_get_lang dictionary_id='29511.Yönetici'></td></cfif>
                        <cfif len(get_standbys.CHIEF3_CODE) and get_standbys.CHIEF3_CODE eq session.ep.position_code><td align="center"><cf_get_lang dictionary_id ='29908.Görüş Bildiren'></td></cfif>
                    </tr>
                    <cfoutput query="GET_QUIZ_CHAPTERS">
                        <tr>
                            <td>#chapter#</td>
                            <cfif attributes.employee_id eq session.ep.userid or isdefined("attributes.display")><td align="center"><input type="checkbox" name="emp_training_cat" id="emp_training_cat" value="#chapter_id#"></td></cfif>
                            <cfif len(get_standbys.CHIEF1_CODE) and get_standbys.CHIEF1_CODE eq session.ep.position_code><td align="center"><input type="checkbox" name="manager_training_cat" id="manager_training_cat" value="#chapter_id#"></td></cfif>
                            <cfif len(get_standbys.CHIEF3_CODE) and get_standbys.CHIEF3_CODE eq session.ep.position_code><td align="center"><input type="checkbox" name="manager_3_training_cat" id="manager_3_training_cat" value="#chapter_id#"></td></cfif>
                        </tr>
                    </cfoutput>
                    <cfif attributes.employee_id eq session.ep.userid or isdefined("attributes.display")>
                        <tr>
                            <td><cf_get_lang dictionary_id ='31617.Çalışan Açıklama'></td>
                            <td colspan="2"><textarea name="emp_training_exp" id="emp_training_exp" style="width:500px;height:40px;" maxlength="500" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="<cfoutput>#message1#</cfoutput>"></textarea></td>
                        </tr>
                    </cfif>
                    <cfif len(get_standbys.CHIEF3_CODE) and get_standbys.CHIEF3_CODE eq session.ep.position_code>
                        <tr>
                            <td><cf_get_lang dictionary_id ='31728.Görüş Bildiren Açıklama'></td>
                            <td colspan="2"><textarea name="manager_3_training_exp" id="manager_3_training_exp" style="width:500px;height:40px;" maxlength="500" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="<cfoutput>#message1#</cfoutput>"></textarea></td>
                        </tr>
                    </cfif>
                    <cfif len(get_standbys.CHIEF1_CODE) and get_standbys.CHIEF1_CODE eq session.ep.position_code>
                        <tr>
                            <td><cf_get_lang dictionary_id ='31729.Yönetici Açıklama'></td>
                            <td colspan="2"><textarea name="manager_training_exp" id="manager_training_exp" style="width:500px;height:40px;" maxlength="500" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="<cfoutput>#message1#</cfoutput>"></textarea></td>
                        </tr>
                    </cfif>
                </table>
            </cfif>    
		<cf_popup_box_footer>
            <input name="USER_POINT" id="USER_POINT" value="" type="hidden">
            <input name="PERFORM_POINT" id="PERFORM_POINT" value="<cfoutput>#Round(quiz_point)#</cfoutput>" type="hidden">
            <input name="PERFORM_POINT_ID" id="PERFORM_POINT_ID" type="hidden" value="1">
            <cf_workcube_buttons is_upd='0' add_function='kontrol()'>
        </cf_popup_box_footer>
	</cfform>
</cf_popup_box>
<!---
<cfform name="add_perform" method="post" action="#request.self#?fuseaction=myhome.emptypopup_add_perf_emp">
	<input type="hidden" name="form_open_type" id="form_open_type" value="<cfoutput>#get_quiz_info.form_open_type#</cfoutput>"><!--- Form tipi 1 acik,2 yari_acik--->
	<input type="hidden" name="valid" id="valid" value=""><!--- calisan onay --->
	<input type="hidden" name="valid1" id="valid1" value=""><!--- 1.amir onay --->
	<input type="hidden" name="valid2" id="valid2" value=""><!--- 2.amir onay --->
	<input type="hidden" name="valid3" id="valid3" value=""><!--- gorus bildiren onay --->
	<input type="hidden" name="valid4" id="valid4" value=""><!--- ortak degerlendirme onay --->
	<input type="hidden" name="start_date" id="start_date" value="<cfif not isdefined("attributes.display")><cfoutput>#attributes.start_date#</cfoutput></cfif>">
	<input type="hidden" name="finish_date"  id="finish_date" value="<cfif not isdefined("attributes.display")><cfoutput>#attributes.finish_date#</cfoutput></cfif>">
	<input type="hidden" name="diplay" id="display" value="<cfif isdefined("attributes.display")><cfoutput>#attributes.display#</cfoutput></cfif>">

	<table width="98%" height="35" align="center" cellpadding="0" cellspacing="0" border="0">
		<tr>
			<td class="headbold"><cf_get_lang_main no='1967.Form'><cfoutput>#get_quiz_info.quiz_head#</cfoutput></td>
		</tr>
	</table>
	<table width="98%" height="600" align="center" cellpadding="0" cellspacing="0">
		<tr>
			<td valign="top">
			<table width="98%" cellspacing="0" cellpadding="0">
				<tr class="color-border">
					<td>
					<table width="100%" cellspacing="1" cellpadding="2">
						<cfif not isdefined("attributes.display")>
						<tr class="color-row">
							<td height="22" class="txtboldblue"><cf_get_lang_main no ='217.Açıklama'>/<cf_get_lang no ='663.Örnek Olaylar “Bekleneni Karşılıyor” (3) dışında değerlendirdiğiniz davranış ifadeleri için Açıklama kısımlarını doldurunuz,2 örnek davranış yazınız'></td>
						</tr>
						<tr>
							<td class="color-row">
							<table>
								<tr>
									<td width="100"><cf_get_lang_main no='164.Çalışan'> </td>
									<td width="180">
										<cfoutput>#GET_EMPLOYEE.employee_name# #GET_EMPLOYEE.employee_surname#</cfoutput>
										<input type="hidden" name="EMP_ID" id="EMP_ID" value="<cfoutput>#attributes.employee_id#</cfoutput>">
										<cfif get_quiz_info.is_manager_0 eq 1>
											<input type="hidden" name="MANAGER_0_EMP_ID" id="MANAGER_0_EMP_ID" value="<cfoutput>#attributes.employee_id#</cfoutput>">
										</cfif>
									</td>
									<cfif get_quiz_info.is_manager_1 eq 1>
										<td width="110">1.<cf_get_lang_main no='1869.Amir'></td>
										<td width="180">
											<cfif IsNumeric(get_standbys.CHIEF1_CODE)>
												<cfquery name="get_chief1_name" datasource="#dsn#">
													SELECT EMPLOYEE_NAME,EMPLOYEE_SURNAME,EMPLOYEE_ID FROM EMPLOYEE_POSITIONS WHERE POSITION_CODE=#get_standbys.CHIEF1_CODE#
												</cfquery>
											</cfif> 
											<input type="text" readonly="yes" name="MANAGER_1_POS_NAME" id="MANAGER_1_POS_NAME" style="width:150px;" <cfif IsNumeric(get_standbys.CHIEF1_CODE)>value="<cfoutput>#get_chief1_name.EMPLOYEE_NAME# #get_chief1_name.EMPLOYEE_SURNAME#</cfoutput>"</cfif>>
											<input type="hidden" name="MANAGER_1_POS" id="MANAGER_1_POS" <cfif IsNumeric(get_standbys.CHIEF1_CODE)>value="<cfoutput>#get_standbys.CHIEF1_CODE#</cfoutput>"</cfif>>
											<input type="hidden" name="MANAGER_1_EMP_ID" id="MANAGER_1_EMP_ID" <cfif IsNumeric(get_standbys.CHIEF1_CODE)>value="<cfoutput>#get_chief1_name.EMPLOYEE_ID#</cfoutput>"</cfif>>
											<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_list_positions&field_emp_name=add_perform.MANAGER_1_POS_NAME&field_emp_id=add_perform.MANAGER_1_EMP_ID','list');"><img src="/images/plus_thin.gif" border="0" align="absmiddle"></a>
										</td>
									</cfif>
								</tr>
								<tr>
									<td><cf_get_lang no ='221.Pozisyonu'></td>
									<td><cfoutput>#GET_EMP_CODES.POSITION_NAME#</cfoutput><input type="hidden" name="position_name" value="<cfoutput>#GET_EMP_CODES.POSITION_NAME#</cfoutput>"></td>
									<cfif get_quiz_info.is_manager_2 eq 1>
										<td>2.<cf_get_lang_main no='1869.Amir'></td>
										<td><cfif IsNumeric(get_standbys.CHIEF2_CODE)>
												<cfquery name="get_chief2_name" datasource="#dsn#">
													SELECT EMPLOYEE_NAME,EMPLOYEE_SURNAME,EMPLOYEE_ID FROM EMPLOYEE_POSITIONS WHERE POSITION_CODE=#get_standbys.CHIEF2_CODE#
												</cfquery>
											</cfif>
											<input type="text" name="MANAGER_2_POS_NAME" id="MANAGER_2_POS_NAME" style="width:150px;" readonly="yes" <cfif IsNumeric(get_standbys.CHIEF2_CODE)>value="<cfoutput>#get_chief2_name.EMPLOYEE_NAME# #get_chief2_name.EMPLOYEE_SURNAME#</cfoutput>"</cfif>>
											<input type="hidden" name="MANAGER_2_POS" id="MANAGER_2_POS" <cfif IsNumeric(get_standbys.CHIEF2_CODE)>value="<cfoutput>#get_standbys.CHIEF2_CODE#</cfoutput>"</cfif>>
											<input type="hidden" name="MANAGER_2_EMP_ID" id="MANAGER_2_EMP_ID" <cfif IsNumeric(get_standbys.CHIEF2_CODE)>value="<cfoutput>#get_chief2_name.EMPLOYEE_ID#</cfoutput>"</cfif>>
										</td>
									</cfif>
									<cfif get_quiz_info.is_manager_4 eq 1><!--- Ortak Degerlendirme Icin Eklendi --->
										<input type="hidden" name="MANAGER_4_EMP_ID" id="MANAGER_4_EMP_ID" value="<cfif IsNumeric(get_standbys.CHIEF1_CODE)><cfoutput>#get_chief1_name.EMPLOYEE_ID#</cfoutput></cfif>">
								   </cfif>
								</tr>
								<tr>
									<td><cf_get_lang_main no='1060.Dönem'></td>
									<td><cfoutput>#attributes.start_date# - #attributes.finish_date#</cfoutput></td>
									<cfif get_quiz_info.is_manager_3 eq 1>
										<td><cf_get_lang_main no ='2111.Görüş Bildiren'></td>
										<td><cfif IsNumeric(get_standbys.CHIEF3_CODE)>
												<cfquery name="get_chief3_name" datasource="#dsn#">
													SELECT EMPLOYEE_NAME,EMPLOYEE_SURNAME,EMPLOYEE_ID FROM EMPLOYEE_POSITIONS WHERE POSITION_CODE=#get_standbys.CHIEF3_CODE#
												</cfquery>
											</cfif> 
											<input type="text" readonly="yes" name="MANAGER_3_POS_NAME" id="MANAGER_3_POS_NAME" style="width:150px;" <cfif IsNumeric(get_standbys.CHIEF3_CODE)>value="<cfoutput>#get_chief3_name.EMPLOYEE_NAME# #get_chief3_name.EMPLOYEE_SURNAME#</cfoutput>"</cfif>>
											<input type="hidden" name="MANAGER_3_POS" id="MANAGER_3_POS" <cfif IsNumeric(get_standbys.CHIEF3_CODE)>value="<cfoutput>#get_standbys.CHIEF3_CODE#</cfoutput>"</cfif>>
											<input type="hidden" name="MANAGER_3_EMP_ID" id="MANAGER_3_EMP_ID" <cfif IsNumeric(get_standbys.CHIEF3_CODE)>value="<cfoutput>#get_chief3_name.EMPLOYEE_ID#</cfoutput>"</cfif>>
										</td>
									</cfif>
								</tr>
								<tr>
									<td>&nbsp;</td>
									<td>&nbsp;</td>
									<td><cf_get_lang no='644.Değerlendirme Tarihi'> *</td>
									<td><cfsavecontent variable="alert"><cf_get_lang no ='662.Değerlendirme Tarihi Girmelisiniz'></cfsavecontent>
										<cfinput type="text" name="eval_date" id="eval_date" validate="#validate_style#" value="#dateformat(now(),dateformat_style)#" style="width:75px;" required="yes" message="#alert#">
										<cf_wrk_date_image date_field="eval_date">
									</td>
								</tr>
								<tr>
									<td>&nbsp;</td>
									<td>&nbsp;</td>
									<td><cf_get_lang no='645.Kayıt Tipi'></td>
									<td><select name="RECORD_TYPE" id="RECORD_TYPE" style="width:150px;">
											<option value="1"><cf_get_lang no='646.Asıl'></option>
											<option value="2"><cf_get_lang no='649.Görüş'> 1</option>
											<option value="3"><cf_get_lang no='649.Görüş'> 2</option>
											<option value="4" <cfif dateformat(attributes.finish_date,'MM') lte 6>selected</cfif>><cf_get_lang no='651.Ara Değerlendirme'></option>
										</select>
									</td>
								</tr>
								<tr>
									<td>&nbsp;</td>
									<td>&nbsp;</td>
									<td><cf_get_lang_main no ='70.Aşama'></td>
									<td><cf_workcube_process is_upd='0' process_cat_width='150' is_detail='0'></td>
								</tr>
							</table>
							</td>
						</tr>
						</cfif>
						<cfinclude template="../display/performance_quiz.cfm">
						<cfinclude template="../query/act_quiz_perf_point.cfm">
						<cfif get_quiz_info.IS_OPINION is 1>
							<tr class="color-list" height="22" onClick="gizle_goster(b_man_evaluation);" style="cursor:pointer;">
								<td height="22" class="txtboldblue"><cf_get_lang no ='966.Amirlerin Görüşleri'></td>
							</tr>
							<tr>
								<td class="color-row">
								<table id="b_man_evaluation">
									<cfsavecontent variable="message1"><cf_get_lang_main no='1687.Fazla karakter sayısı'></cfsavecontent>
									<cfif get_quiz_info.form_open_type neq 2>
										<cfif attributes.employee_id eq session.ep.userid or isdefined("attributes.display")>
											<tr>
												<td><cf_get_lang no ='678.Çalışanın Görüş ve Düşünceleri'></td>
											</tr>
											<tr>
												<td><textarea name="EMPLOYEE_OPINION" id="EMPLOYEE_OPINION" style="width:500px;height:40px;" maxlength="1000" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="<cfoutput>#message1#</cfoutput>"></textarea></td>
											</tr>
										</cfif>
									</cfif>
									<cfif len(get_standbys.CHIEF1_CODE) and get_standbys.CHIEF1_CODE eq session.ep.position_code>
										<tr>
											<td><cf_get_lang no ='679.Birinci Değerlendirme Yöneticisinin Değerlendirmesi'></td>
										</tr>
										<tr>
											<td><textarea name="POWERFUL_ASPECTS" id="POWERFUL_ASPECTS" style="width:500px;height:40px;" maxlength="1000" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="<cfoutput>#message1#</cfoutput>"></textarea></td>
										</tr>
									</cfif>
									<tr>
										<td><input type="hidden" name="TRAIN_NEED_ASPECTS" id="TRAIN_NEED_ASPECTS"></td>
									</tr>
									<cfif len(get_standbys.CHIEF3_CODE) and get_standbys.CHIEF1_CODE eq session.ep.position_code>
										<tr>
											<td><cf_get_lang no ='967.Görüş Bildirenin Görüş ve Düşünceleri'></td>
										</tr>
										<tr>
											<td><textarea name="MANAGER_3_EVALUATION" id="MANAGER_3_EVALUATION" style="width:500px;height:40px;" maxlength="1000" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="<cfoutput>#message1#</cfoutput>"></textarea></td>
										</tr>
									</cfif>
									<cfif len(get_standbys.CHIEF2_CODE) and get_standbys.CHIEF1_CODE eq session.ep.position_code>
										<tr>
											<td><cf_get_lang no ='680.İkinci Değerlendirme Yöneticisinin Görüş ve Düşünceleri'></td>
										</tr>
										<tr>
											<td><textarea name="MANAGER_2_EVALUATION" id="MANAGER_2_EVALUATION" style="width:500px;height:40px;" maxlength="1000" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="<cfoutput>#message1#</cfoutput>"></textarea></td>
										</tr>
									</cfif>
								</table>
								</td>
							</tr>
						</cfif>
						<cfif get_quiz_info.is_career is 1>
							<tr class="color-list" height="22"  onClick="gizle_goster(b_carrer);" style="cursor:pointer;">
								<td height="22" class="txtboldblue"><cf_get_lang no ='969.Kariyer Durumu'></td>
							</tr>
							<tr id="b_carrer">
								<td class="color-row">
								<table>
									<tr valign="top">
										<td>
										<table>
											<tr align="center" class="color-list">
												<cfif attributes.employee_id eq session.ep.userid or isdefined("attributes.display")>
													<td class="txtboldblue"><cf_get_lang_main no='164.Çalışan'></td>
													<td><select name="emp_career_status" id="emp_career_status">
															<option value=""><cf_get_lang_main no ='322.Seçiniz'></option>
															<option value="1"><cf_get_lang_main no ='1867.Bir Üst Görev İçin Uygundur'></option>
															<option value="2"><cf_get_lang_main no ='1868.Bir Üst Görev İçin Yetişmektedir'></option>
															<option value="3"><cf_get_lang no ='974.Bir Üst Görev İçin Uygun Değildir'></option>
														</select>
													</td>
												</cfif>
												<cfif len(get_standbys.CHIEF1_CODE) and get_standbys.CHIEF1_CODE eq session.ep.position_code>
													<td class="txtboldblue"><cf_get_lang_main no='1714.Yönetici'></td>
													<td><select name="manager_career_status" id="manager_career_status" onchange="islem_yap_perf_pos_info();">
															<option value=""><cf_get_lang_main no ='322.Seçiniz'></option>
															<option value="1"><cf_get_lang_main no ='1867.Bir Üst Görev İçin Uygundur'></option>
															<option value="2"><cf_get_lang_main no ='1868.Bir Üst Görev İçin Yetişmektedir'></option>
															<option value="3"><cf_get_lang no ='974.Bir Üst Görev İçin Uygun Değildir'></option>
														</select>
													</td>
												</cfif>
												<cfif len(get_standbys.CHIEF3_CODE) and get_standbys.CHIEF3_CODE eq session.ep.position_code>
													<td class="txtboldblue"><cf_get_lang_main no ='2111.Görüş Bildiren'></td>
													<td align="left">
														<select name="manager_3_career_status" id="manager_3_career_status">
															<option value=""><cf_get_lang_main no ='322.Seçiniz'></option>
															<option value="1"><cf_get_lang no ='974.Bir Üst Görev İçin Uygun Değildir'></option>
															<option value="2"><cf_get_lang no ='975.Bir Üst Görev İçin Henüz Yetişmektedir'></option>
															<option value="3"><cf_get_lang no ='976.Bir Üst Görev İçin Yetişmiştir'></option>
															<option value="4"><cf_get_lang no ='977.Bir Üst Göreve Yükseltilebilir'></option>
															<option value="5"><cf_get_lang no ='978.Bir Üst Göreve Yükseltilmesi Gereklidir'></option>
														</select>
													</td>
												</cfif>
											</tr>
											<cfif attributes.employee_id eq session.ep.userid or isdefined("attributes.display")>
												<tr class="color-list">
													<td class="txtboldblue"><cf_get_lang no ='859.Çalışan Açıklama'></td>
													<td colspan="5"><textarea name="emp_career_exp" id="emp_career_exp" style="width:500px;height:40px;" maxlength="500" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="<cfoutput>#message1#</cfoutput>"></textarea></td>
												</tr>
											</cfif>
											<cfif len(get_standbys.CHIEF3_CODE) and get_standbys.CHIEF3_CODE eq session.ep.position_code>
												<tr class="color-list">
													<td class="txtboldblue"><cf_get_lang no ='970.Görüş Bildiren Açıklama'></td>
													<td colspan="5"><textarea name="manager_3_career_exp" id="manager_3_career_exp" style="width:500px;height:40px;" maxlength="500" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="<cfoutput>#message1#</cfoutput>"></textarea></td>
												</tr>
											</cfif>
											<cfif len(get_standbys.CHIEF1_CODE) and get_standbys.CHIEF1_CODE eq session.ep.position_code>
												<tr class="color-list">
													<td class="txtboldblue"><cf_get_lang no ='971.Yönetici Açıklama'></td>
													<td colspan="5"><textarea name="manager_career_exp" id="manager_career_exp" style="width:500px;height:40px;" maxlength="500" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="<cfoutput>#message1#</cfoutput>"></textarea></td>
												</tr>
											</cfif>
										</table>
										</td>
										<td id="perf_pos_info" style="<cfif len(get_standbys.CHIEF1_CODE) and get_standbys.CHIEF1_CODE eq session.ep.position_code>display:;<cfelse>display:none;</cfif>">
										<table>
											<tr>
												<td class="txtboldblue" colspan="2">Uygun Görevler</td>
											</tr>
											<tr>
												<td>1-</td>
												<td><select name="POSITION_CAT_ID_1" id="POSITION_CAT_ID_1" style="width:200px;">
														<option value="">Seçiniz</option>
														<cfoutput query="get_position_cats">
															<option value="#position_cat_id#">#position_cat#</option>
														</cfoutput>
													</select>
												</td>
											</tr>
											<tr>
												<td>2-</td>
												<td><select name="POSITION_CAT_ID_2" id="POSITION_CAT_ID_2" style="width:200px;">
														<option value="">Seçiniz</option>
														<cfoutput query="get_position_cats">
															<option value="#position_cat_id#">#position_cat#</option>
														</cfoutput>
													</select>
												</td>
											</tr>
											<tr>
												<td>3-</td>
												<td><select name="POSITION_CAT_ID_3" id="POSITION_CAT_ID_3" style="width:200px;">
														<option value="">Seçiniz</option>
														<cfoutput query="get_position_cats">
															<option value="#position_cat_id#">#position_cat#</option>
														</cfoutput>
													</select>
												</td>
											</tr>
										</table>
										</td>
									</tr>
								</table>
								</td>
							</tr>
						</cfif>
						<cfif get_quiz_info.is_training is 1>
							<tr class="color-list" height="22"  onClick="gizle_goster(b_gelisim);" style="cursor:pointer;">
								<td height="22" class="txtboldblue"><cf_get_lang no ='972.Gelişim'></td>
							</tr>
							<tr>
								<td class="color-row">
								<cfquery name="get_training_cat" datasource="#dsn#">
									SELECT TRAINING_CAT_ID,TRAINING_CAT FROM TRAINING_CAT
								</cfquery>
								<table id="b_gelisim">
									<tr class="color-list">
										<td class="txtbold"><cf_get_lang no ='607.Eğitimler'></td>
										<cfif attributes.employee_id eq session.ep.userid or isdefined("attributes.display")><td class="txtbold" align="center"><cf_get_lang_main no='164.Çalışan'></td></cfif>
										<cfif len(get_standbys.CHIEF1_CODE) and get_standbys.CHIEF1_CODE eq session.ep.position_code><td class="txtbold" align="center"><cf_get_lang_main no='1714.Yönetici'></td></cfif>
										<cfif len(get_standbys.CHIEF3_CODE) and get_standbys.CHIEF3_CODE eq session.ep.position_code><td class="txtbold" align="center"><cf_get_lang_main no ='2111.Görüş Bildiren'></td></cfif>
									</tr>
									<cfoutput query="GET_QUIZ_CHAPTERS">
										<tr class="color-list">
											<td class="txtboldblue">#chapter#</td>
											<cfif attributes.employee_id eq session.ep.userid or isdefined("attributes.display")><td align="center"><input type="checkbox" name="emp_training_cat" id="emp_training_cat" value="#chapter_id#"></td></cfif>
											<cfif len(get_standbys.CHIEF1_CODE) and get_standbys.CHIEF1_CODE eq session.ep.position_code><td align="center"><input type="checkbox" name="manager_training_cat" id="manager_training_cat" value="#chapter_id#"></td></cfif>
											<cfif len(get_standbys.CHIEF3_CODE) and get_standbys.CHIEF3_CODE eq session.ep.position_code><td align="center"><input type="checkbox" name="manager_3_training_cat" id="manager_3_training_cat" value="#chapter_id#"></td></cfif>
										</tr>
									</cfoutput>
									<cfif attributes.employee_id eq session.ep.userid or isdefined("attributes.display")>
										<tr class="color-list">
											<td class="txtboldblue"><cf_get_lang no ='859.Çalışan Açıklama'></td>
											<td colspan="2"><textarea name="emp_training_exp" id="emp_training_exp" style="width:500px;height:40px;" maxlength="500" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="<cfoutput>#message1#</cfoutput>"></textarea></td>
										</tr>
									</cfif>
									<cfif len(get_standbys.CHIEF3_CODE) and get_standbys.CHIEF3_CODE eq session.ep.position_code>
										<tr class="color-list">
											<td class="txtboldblue"><cf_get_lang no ='970.Görüş Bildiren Açıklama'></td>
											<td colspan="2"><textarea name="manager_3_training_exp" id="manager_3_training_exp" style="width:500px;height:40px;" maxlength="500" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="<cfoutput>#message1#</cfoutput>"></textarea></td>
										</tr>
									</cfif>
									<cfif len(get_standbys.CHIEF1_CODE) and get_standbys.CHIEF1_CODE eq session.ep.position_code>
										<tr class="color-list">
											<td class="txtboldblue"><cf_get_lang no ='971.Yönetici Açıklama'></td>
											<td colspan="2"><textarea name="manager_training_exp" id="manager_training_exp" style="width:500px;height:40px;" maxlength="500" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="<cfoutput>#message1#</cfoutput>"></textarea></td>
										</tr>
									</cfif>
								</table>
								</td>
							</tr>
						</cfif>
						<tr class="color-row" height="22">    
							<td  style="text-align:right;">
								<input name="USER_POINT" id="USER_POINT" value="" type="hidden">
								<input name="PERFORM_POINT" id="PERFORM_POINT" value="<cfoutput>#Round(quiz_point)#</cfoutput>" type="hidden">
								<input name="PERFORM_POINT_ID" id="PERFORM_POINT_ID" type="hidden" value="1">
								<cf_workcube_buttons is_upd='0' add_function='kontrol()'>
							</td>       
						</tr>    
					</table>
					</td>
				</tr>  
			</table>
			<cfif not isdefined("attributes.display")>
			<td valign="top" width="190"><cf_get_workcube_asset asset_cat_id="-9" module_id='3' action_section='QUIZ_ID' action_id='#attributes.quiz_id#'><br/></td> 
			</cfif>
		</tr>
	</table> 
</cfform>
--->
<script type="text/javascript">
function islem_yap_perf_pos_info()
{
	if(document.add_perform.manager_career_status != undefined && (document.add_perform.manager_career_status.value == '3' || document.add_perform.manager_career_status.value == '4' || document.add_perform.manager_career_status.value == '5'))
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
	<cfif len(get_standbys.CHIEF1_CODE) and get_standbys.CHIEF1_CODE eq session.ep.position_code>
		if(document.add_perform.manager_career_status != undefined && (document.add_perform.manager_career_status.value == '3' || document.add_perform.manager_career_status.value == '4' || document.add_perform.manager_career_status.value == '5'))
			{
				if(document.add_perform.POSITION_CAT_ID_1.value == '')
					{
					alert("<cf_get_lang dictionary_id='41527.Bu Aşamada Uygun Görülen Pozisyon Tipini Seçmelisiniz'>!");
					return false;
					}
			}
	</cfif>
	return process_cat_control();
}
</script>
