<!---form--->
<cfinclude template="../query/get_quiz_info.cfm">
<cfinclude template="../query/get_emp_chiefs.cfm">
<cfinclude template="../query/get_employee.cfm">
<cfquery name="GET_STANDBYS" datasource="#DSN#">
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
<cfsavecontent variable="message"><cf_get_lang dictionary_id="29764.Form"></cfsavecontent>
<cf_form_box title="#message# #get_quiz_info.QUIZ_HEAD#">
<cfform name="add_perform" method="post" action="#request.self#?fuseaction=hr.emptypopup_add_perf_emp">
<!--- <input type="hidden" name="perf_salary_check" value="<cfif IsDefined('attributes.perf_salary_check')>1<cfelse>0</cfif>"> ---><!--- Performans ucret  etkisi Senay 20060928 --->
<input type="hidden" name="form_open_type" id="form_open_type" value="<cfoutput>#get_quiz_info.form_open_type#</cfoutput>"><!--- Form tipi acik,yari_acik--->
<input type="hidden" name="valid1" id="valid1" value=""><!--- 1.amir onay --->
<input type="hidden" name="valid2" id="valid2" value=""><!--- 2.amir onay --->
<input type="hidden" name="valid3" id="valid3" value=""><!--- gorus bildiren onay --->
<input type="hidden" name="valid" id="valid" value=""><!--- calisan onay --->
<input type="hidden" name="valid4" id="valid4" value=""><!--- ortak degerlendirme onay --->
<input type="hidden" name="start_date" id="start_date" value="<cfoutput>#attributes.start_date#</cfoutput>">
<input type="hidden" name="finish_date" id="finish_date" value="<cfoutput>#attributes.finish_date#</cfoutput>">
    <table>
        <tr>
          <td height="22" class="txtboldblue"><cf_get_lang dictionary_id ='57629.Açıklama'>/<cf_get_lang dictionary_id ='55943.Örnek Olaylar: “Bekleneni Karşılıyor” (3) dışında değerlendirdiğiniz davranış ifadeleri için Açıklama kısımlarını doldurunuz'>,2 <cf_get_lang dictionary_id ='56756.örnek davranış yazınız'>.</td>
        </tr>
    </table>
      <table height="22">
          <tr>
            <td width="100"><cf_get_lang dictionary_id='57576.Çalışan'></td>
            <td width="185"><cfoutput>#GET_EMPLOYEE.employee_name# #GET_EMPLOYEE.employee_surname#</cfoutput>
              <input type="hidden" name="EMP_ID" id="EMP_ID" value="<cfoutput>#attributes.employee_id#</cfoutput>">
            </td>
            <cfif get_quiz_info.is_manager_1 is 1>
			<td width="100">1.<cf_get_lang dictionary_id='29666.Amir'></td>
            <td>
				<cfif IsNumeric(get_standbys.CHIEF1_CODE)>
					<cfquery name="get_chief1_name" datasource="#dsn#">
						SELECT EMPLOYEE_NAME,EMPLOYEE_SURNAME,EMPLOYEE_ID FROM EMPLOYEE_POSITIONS WHERE POSITION_CODE=#get_standbys.CHIEF1_CODE#
					</cfquery>
				</cfif> 
				<input readonly="yes" name="MANAGER_1_POS_NAME" type="text" id="MANAGER_1_POS_NAME" style="width:150px;" 
				<cfif IsNumeric(get_standbys.CHIEF1_CODE)>value="<cfoutput>#get_chief1_name.EMPLOYEE_NAME# #get_chief1_name.EMPLOYEE_SURNAME#</cfoutput>"</cfif>>
				<input type="hidden" name="MANAGER_1_POS" id="MANAGER_1_POS" 
				<cfif IsNumeric(get_standbys.CHIEF1_CODE)>value="<cfoutput>#get_standbys.CHIEF1_CODE#</cfoutput>"</cfif>>
				<input type="hidden" name="MANAGER_1_EMP_ID" id="MANAGER_1_EMP_ID" 
				<cfif IsNumeric(get_standbys.CHIEF1_CODE)>value="<cfoutput>#get_chief1_name.EMPLOYEE_ID#</cfoutput>"</cfif>>
				<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_list_positions&field_emp_name=add_perform.MANAGER_1_POS_NAME&field_emp_id=add_perform.MANAGER_1_EMP_ID&field_code=add_perform.MANAGER_1_POS','list');"><img src="/images/plus_thin.gif" border="0"></a> 
			</td>
           </cfif>
		  </tr>
          <tr>
            <td><cf_get_lang dictionary_id='58497.Pozisyonu'></td>
            <td><cfoutput>#GET_EMP_CODES.POSITION_NAME#</cfoutput><input type="hidden" name="position_name" id="position_name" value="<cfoutput>#GET_EMP_CODES.POSITION_NAME#</cfoutput>"></td>
            <cfif get_quiz_info.is_manager_2 is 1>
			<td>2.<cf_get_lang dictionary_id='29666.Amir'></td>
            <td>
				<cfif IsNumeric(get_standbys.CHIEF2_CODE)>
					<cfquery name="get_chief2_name" datasource="#dsn#">
						SELECT EMPLOYEE_NAME,EMPLOYEE_SURNAME,EMPLOYEE_ID FROM EMPLOYEE_POSITIONS WHERE POSITION_CODE=#get_standbys.CHIEF2_CODE#
					</cfquery>
				</cfif> 
				<input readonly="yes" name="MANAGER_2_POS_NAME" type="text" id="MANAGER_2_POS_NAME" style="width:150px;" 
				<cfif IsNumeric(get_standbys.CHIEF2_CODE)>value="<cfoutput>#get_chief2_name.EMPLOYEE_NAME# #get_chief2_name.EMPLOYEE_SURNAME#</cfoutput>"</cfif>>
				<input type="hidden" name="MANAGER_2_POS" id="MANAGER_2_POS" 
				<cfif IsNumeric(get_standbys.CHIEF2_CODE)>value="<cfoutput>#get_standbys.CHIEF2_CODE#</cfoutput>"</cfif>>
				<input type="hidden" name="MANAGER_2_EMP_ID" id="MANAGER_2_EMP_ID" 
				<cfif IsNumeric(get_standbys.CHIEF2_CODE)>value="<cfoutput>#get_chief2_name.EMPLOYEE_ID#</cfoutput>"</cfif>>
				<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_list_positions&field_emp_name=add_perform.MANAGER_2_POS_NAME&field_emp_id=add_perform.MANAGER_2_EMP_ID&field_code=add_perform.MANAGER_2_POS','list');"><img src="/images/plus_thin.gif" border="0"></a> 
			</td>
          </cfif>
		  </tr>
          <tr>
            <td><cf_get_lang dictionary_id='58472.Dönem'></td>
            <td><cfoutput>#attributes.start_date# - #attributes.finish_date#</cfoutput></td>
            <cfif get_quiz_info.is_manager_3 is 1>
			<td><cf_get_lang dictionary_id ='29908.Görüş Bildiren'></td>
            <td>
				<cfif IsNumeric(get_standbys.CHIEF3_CODE)>
					<cfquery name="get_chief3_name" datasource="#dsn#">
						SELECT EMPLOYEE_NAME,EMPLOYEE_SURNAME,EMPLOYEE_ID FROM EMPLOYEE_POSITIONS WHERE POSITION_CODE=#get_standbys.CHIEF3_CODE#
					</cfquery>
				</cfif> 
				<input readonly="yes" name="MANAGER_3_POS_NAME" type="text" id="MANAGER_3_POS_NAME" style="width:150px;" 
				<cfif IsNumeric(get_standbys.CHIEF3_CODE)>value="<cfoutput>#get_chief3_name.EMPLOYEE_NAME# #get_chief3_name.EMPLOYEE_SURNAME#</cfoutput>"</cfif>>
				<input type="hidden" name="MANAGER_3_POS" id="MANAGER_3_POS" 
				<cfif IsNumeric(get_standbys.CHIEF3_CODE)>value="<cfoutput>#get_standbys.CHIEF3_CODE#</cfoutput>"</cfif>>
				<input type="hidden" name="MANAGER_3_EMP_ID" id="MANAGER_3_EMP_ID" <cfif IsNumeric(get_standbys.CHIEF3_CODE)>value="<cfoutput>#get_chief3_name.EMPLOYEE_ID#</cfoutput>"</cfif>>
				<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_list_positions&field_emp_name=add_perform.MANAGER_3_POS_NAME&field_emp_id=add_perform.MANAGER_3_EMP_ID&field_code=add_perform.MANAGER_3_POS','list');"><img src="/images/plus_thin.gif" border="0"></a>
			</td>
			</cfif>
          </tr>
          <tr>
            <td><cf_get_lang dictionary_id ='55944.Değerlendirme Tarihi'> *</td>
            <cfsavecontent variable="alert"><cf_get_lang dictionary_id ='56240.Değerlendirme Tarihi Girmelisiniz'></cfsavecontent>
			<td><cfinput type="text" name="eval_date" validate="#validate_style#" value="#dateformat(now(),dateformat_style)#" style="width:80px;" required="yes" message="!">
			<cf_wrk_date_image date_field="eval_date"></td>
            <td><cf_get_lang dictionary_id ='56236.Kayıt tipi'></td>
            <td>
				<select name="RECORD_TYPE" id="RECORD_TYPE" style="width:150px">
					<option value="1"><cf_get_lang dictionary_id ='56015.Asıl'></option>
					<option value="2"><cf_get_lang dictionary_id ='56016.Görüş'> 1</option>
					<option value="3"><cf_get_lang dictionary_id ='56016.Görüş'> 2</option>
					<option value="4" <cfif dateformat(attributes.finish_date,'MM') lte 6>selected</cfif>><cf_get_lang dictionary_id ='56241.Ara Değerlendirme'></option>
				</select>
            </td>
          </tr>
		  <!--- <cfif get_quiz_info.IS_RECORD_TYPE is 1> --->
          <tr>
            <td></td>
            <td></td>
          </tr>
		  <tr>
		  	<td></td>
			<td></td>
			<td><cf_get_lang dictionary_id="58859.Süreç"></td>
			<td><cf_workcube_process is_upd='0' process_cat_width='150' is_detail='0'></td>
		  </tr>
		  <!--- </cfif> --->
        </table>
    <!--- seçilen form --->
	<!--- <cfset chapter_not_gd='1205,1206,1207,1208,1201,1202,1203,1204,1193,1194,1195,1196,1189,1190,1191,1192,1169,1170,1171,1172,1197,1198,1199,1200,1182,1183,1184,1186,1178,1179,1180,1185'> --->
    <cfinclude template="../display/performance_quiz.cfm">
    <cfinclude template="../query/act_quiz_perf_point.cfm">
    <!--- görüşler --->
	<cfif get_quiz_info.IS_OPINION is 1>
	  <cfsavecontent variable="message"><cf_get_lang dictionary_id="55527.Amirlerin Görüşleri"></cfsavecontent>
      <cf_seperator id="b_man_evaluation" title="#message#">
        <table id="b_man_evaluation">
			<cfsavecontent variable="text"><cf_get_lang dictionary_id='29484.Fazla karakter sayısı'></cfsavecontent>
		  <cfif len(get_standbys.CHIEF1_CODE) and get_standbys.CHIEF1_CODE eq session.ep.position_code>
		  <tr>
            <td><cf_get_lang dictionary_id ='56310.Birinci Değerlendirme Yöneticisinin Görüş ve Düşünceleri'></td>
          </tr>
		  <tr>
            <td><textarea name="POWERFUL_ASPECTS" id="POWERFUL_ASPECTS" style="width:500px;height:40px;" maxlength="1000" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="<cfoutput>#text#</cfoutput>"></textarea></td>
          </tr>
		  </cfif>
		  <tr>
            <td><input type="hidden" name="TRAIN_NEED_ASPECTS" id="TRAIN_NEED_ASPECTS"></td>
          </tr>
		  <cfif len(get_standbys.CHIEF3_CODE) and get_standbys.CHIEF1_CODE eq session.ep.position_code>
		  <tr>
            <td><cf_get_lang dictionary_id ='56716.Görüş Bildirenin Görüş ve Düşünceleri'></td>
          </tr>
          <tr>
            <td><textarea name="MANAGER_3_EVALUATION" id="MANAGER_3_EVALUATION" style="width:500px;height:40px;" maxlength="1000" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="<cfoutput>#text#</cfoutput>"></textarea></td>
          </tr>
		  </cfif>
		  <cfif len(get_standbys.CHIEF2_CODE) and get_standbys.CHIEF2_CODE eq session.ep.position_code>
		  <tr>
            <td><cf_get_lang dictionary_id ='56311.İkinci Değerlendirme Yöneticisinin Görüş ve Düşünceleri'></td>
          </tr>
          <tr>
            <td><textarea name="MANAGER_2_EVALUATION" id="MANAGER_2_EVALUATION" style="width:500px;height:40px;" maxlength="1000" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="<cfoutput>#text#</cfoutput>"></textarea></td>
          </tr>
		  </cfif>
		  <cfif get_quiz_info.form_open_type neq 2>
		  <cfif attributes.employee_id eq session.ep.userid>
		  <tr>
            <td><cf_get_lang dictionary_id ='56309.Çalışanın Görüş ve Düşünceleri'></td>
          </tr>
          <tr>
            <td><textarea name="EMPLOYEE_OPINION" id="EMPLOYEE_OPINION" style="width:500px;height:40px;" maxlength="1000" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="<cfoutput>#text#</cfoutput>"></textarea></td>
          </tr>
		  </cfif>
		  </cfif>
           <cfif get_quiz_info.form_open_type neq 2 and attributes.employee_id eq session.ep.userid>
		  <tr>
            <td>
				<input type="radio" name="EMPLOYEE_OPINION_ID" id="EMPLOYEE_OPINION_ID" value="1"><cf_get_lang dictionary_id ='55543.Değerlendirmeye Katılıyorum'> 
				&nbsp;&nbsp;&nbsp;
				<input type="radio" name="EMPLOYEE_OPINION_ID" id="EMPLOYEE_OPINION_ID" value="0"><cf_get_lang dictionary_id ='55544.Değerlendirmeye Katılmıyorum'>
				&nbsp; (<cf_get_lang dictionary_id ='56757.Bu alan çalışan tarafından doldurulacaktır'>!)
			</td>
          </tr>
		  </cfif>
        </table>
	</cfif>
	<cfif get_quiz_info.is_career is 1>
		<cfsavecontent variable="message"><cf_get_lang dictionary_id="56717.Kariyer Durumu"></cfsavecontent>
    <cf_seperator id="b_carrer" title="#message#">
		<table id="b_carrer">
			<tr align="center">
				<cfif attributes.employee_id eq session.ep.userid>
				<td class="txtboldblue"><cf_get_lang dictionary_id='57576.Çalışan'></td>
				<td align="left">
					<select name="emp_career_status" id="emp_career_status">
						<option value=""> <cf_get_lang dictionary_id ='57734.seçiniz'></option>
						<option value="1"><cf_get_lang dictionary_id ='56718.Bir Üst Görev İçin Uygun Değildir'></option>
						<option value="2"><cf_get_lang dictionary_id ='56719.Bir Üst Görev İçin Henüz Yetişmektedir'></option>
						<option value="3"><cf_get_lang dictionary_id ='56720.Bir Üst Görev İçin Yetişmiştir'></option>
						<option value="4"><cf_get_lang dictionary_id ='56721.Bir Üst Göreve Yükseltilebilir'></option>
						<option value="5"><cf_get_lang dictionary_id ='56722.Bir Üst Göreve Yükseltilmesi Gereklidir'></option>
					</select>
				</td>
				</cfif>
				<cfif len(get_standbys.CHIEF1_CODE) and get_standbys.CHIEF1_CODE eq session.ep.position_code>
				<td class="txtboldblue"><cf_get_lang dictionary_id="30367.Yönetici"></td>
				<td align="left">
					<select name="manager_career_status" id="manager_career_status">
						<option value=""> <cf_get_lang dictionary_id ='57734.seçiniz'></option>
						<option value="1"><cf_get_lang dictionary_id ='56718.Bir Üst Görev İçin Uygun Değildir'></option>
						<option value="2"><cf_get_lang dictionary_id ='56719.Bir Üst Görev İçin Henüz Yetişmektedir'></option>
						<option value="3"><cf_get_lang dictionary_id ='56720.Bir Üst Görev İçin Yetişmiştir'></option>
						<option value="4"><cf_get_lang dictionary_id ='56721.Bir Üst Göreve Yükseltilebilir'></option>
						<option value="5"><cf_get_lang dictionary_id ="56722.Bir Üst Göreve Yükseltilmesi Gereklidir"></option>
					</select>
				</td>
				</cfif>
				<cfif len(get_standbys.CHIEF3_CODE) and get_standbys.CHIEF3_CODE eq session.ep.position_code>
				<td class="txtboldblue"><cf_get_lang dictionary_id="29908.Görüş Bildiren"></td>
				<td align="left">
					<select name="manager_3_career_status" id="manager_3_career_status">
						<option value=""> <cf_get_lang dictionary_id ='57734.seçiniz'></option>
						<option value="1"><cf_get_lang dictionary_id ='56718.Bir Üst Görev İçin Uygun Değildir'></option>
						<option value="2"><cf_get_lang dictionary_id ='56719.Bir Üst Görev İçin Henüz Yetişmektedir'></option>
						<option value="3"><cf_get_lang dictionary_id ='56720.Bir Üst Görev İçin Yetişmiştir'></option>
						<option value="4"><cf_get_lang dictionary_id ='56721.Bir Üst Göreve Yükseltilebilir'></option>
						<option value="5"><cf_get_lang dictionary_id ='56722.Bir Üst Göreve Yükseltilmesi Gereklidir'></option>
					</select>
				</td>
				</cfif>
			</tr>
			<tr>
				<td class="txtboldblue"><cf_get_lang dictionary_id='58156.Diğer'></td>
				<td colspan="5"><textarea name="other_career_exp" id="other_career_exp" style="width:500px;height:40px;"></textarea></td>
			</tr>
			<cfif attributes.employee_id eq session.ep.userid>
			<tr>
				<td class="txtboldblue"><cf_get_lang dictionary_id ='56758.Çalışan Açıklama'></td>
				<td colspan="5"><textarea name="emp_career_exp" id="emp_career_exp" style="width:500px;height:40px;" maxlength="500" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="<cfoutput>#text#</cfoutput>"></textarea></td>
			</tr>
			</cfif>
			<cfif len(get_standbys.CHIEF3_CODE) and get_standbys.CHIEF3_CODE eq session.ep.position_code>
			<tr>
				<td class="txtboldblue"><cf_get_lang dictionary_id ='56723.Görüş Bildiren Açıklama'></td>
				<td colspan="5"><textarea name="manager_3_career_exp" id="manager_3_career_exp" style="width:500px;height:40px;" maxlength="500" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="<cfoutput>#text#</cfoutput>"></textarea></td>
			</tr>
			</cfif>
			<cfif len(get_standbys.CHIEF1_CODE) and get_standbys.CHIEF1_CODE eq session.ep.position_code>
			<tr>
				<td class="txtboldblue"><cf_get_lang dictionary_id ='31729.Yönetici Açıklama'></td>
				<td colspan="5"><textarea name="manager_career_exp" id="manager_career_exp" style="width:500px;height:40px;" maxlength="500" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="<cfoutput>#text#</cfoutput>"></textarea></td>
			</tr>
			</cfif>
		</table>
	</cfif>
	<cfif get_quiz_info.is_training is 1>
	<cfsavecontent variable="message"><cf_get_lang dictionary_id="56459.Gelişim"></cfsavecontent>
    <cf_seperator id="b_gelisim" title="#message#"><!---Gelişim'--->
		<cfquery name="get_training_cat" datasource="#dsn#">
			SELECT TRAINING_CAT_ID,TRAINING_CAT FROM TRAINING_CAT
		</cfquery>
		<table id="b_gelisim">
				<tr>
					<td class="txtbold"><cf_get_lang dictionary_id ='29912.Eğitimler'></td>
					<cfif attributes.employee_id eq session.ep.userid><td class="txtbold" align="center"><cf_get_lang dictionary_id='57576.Çalışan'></td></cfif>
					<cfif len(get_standbys.CHIEF1_CODE) and get_standbys.CHIEF1_CODE eq session.ep.position_code><td class="txtbold" align="center"><cf_get_lang dictionary_id='29511.Yönetici'></td></cfif>
					<cfif len(get_standbys.CHIEF3_CODE) and get_standbys.CHIEF3_CODE eq session.ep.position_code><td class="txtbold" align="center"><cf_get_lang dictionary_id='29908.Görüş Bildiren'></td></cfif>
				</tr>
				<cfoutput query="get_training_cat">
				<tr>
					<td class="txtboldblue">#get_training_cat.training_cat#</td>
					<cfif attributes.employee_id eq session.ep.userid><td align="center"><input type="checkbox" name="emp_training_cat" id="emp_training_cat" value="#get_training_cat.training_cat_id#"></td></cfif>
					<cfif len(get_standbys.CHIEF1_CODE) and get_standbys.CHIEF1_CODE eq session.ep.position_code><td align="center"><input type="checkbox" name="manager_training_cat" id="manager_training_cat" value="#get_training_cat.training_cat_id#"></td></cfif>
					<cfif len(get_standbys.CHIEF3_CODE) and get_standbys.CHIEF3_CODE eq session.ep.position_code><td align="center"><input type="checkbox" name="manager_3_training_cat" id="manager_3_training_cat" value="#get_training_cat.training_cat_id#"></td></cfif>
				</tr>
				</cfoutput>
				<tr>
					<td class="txtboldblue"><cf_get_lang dictionary_id='58156.Diğer'></td>
					<td colspan="2"><textarea name="other_training_exp" id="other_training_exp" style="width:500px;height:40px;"></textarea></td>
				</tr>
				<cfif attributes.employee_id eq session.ep.userid>
				<tr>
					<td class="txtboldblue"><cf_get_lang dictionary_id ='56758.Çalışan Açıklama'></td>
					<td colspan="2"><textarea name="emp_training_exp" id="emp_training_exp" style="width:500px;height:40px;" maxlength="500" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="<cfoutput>#text#</cfoutput>"></textarea></td>
				</tr>
				</cfif>
				<cfif len(get_standbys.CHIEF3_CODE) and get_standbys.CHIEF3_CODE eq session.ep.position_code>
				<tr>
					<td class="txtboldblue"><cf_get_lang dictionary_id ='56723.Görüş Bildiren Açıklama'></td>
					<td colspan="2"><textarea name="manager_3_training_exp" id="manager_3_training_exp" style="width:500px;height:40px;" maxlength="500" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="<cfoutput>#text#</cfoutput>"></textarea></td>
				</tr>
				</cfif>
				<cfif len(get_standbys.CHIEF1_CODE) and get_standbys.CHIEF1_CODE eq session.ep.position_code>
				<tr>
					<td class="txtboldblue"><cf_get_lang dictionary_id ='31729.Yönetici Açıklama'></td>
					<td colspan="2"><textarea name="manager_training_exp" id="manager_training_exp" style="width:500px;height:40px;" maxlength="500" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="<cfoutput>#text#</cfoutput>"></textarea></td>
				</tr>
				</cfif>
			</table>
	</cfif>
    <input name="USER_POINT" id="USER_POINT" value="" type="hidden">
	<input name="PERFORM_POINT"  id="PERFORM_POINT" value="<cfoutput>#Round(quiz_point)#</cfoutput>" type="hidden">
	<input name="PERFORM_POINT_ID" id="PERFORM_POINT_ID" type="hidden" value="1">
<cf_form_box_footer><cf_workcube_buttons is_upd='0' add_function='process_cat_control()'></cf_form_box_footer>
</cfform>
</cf_form_box>
