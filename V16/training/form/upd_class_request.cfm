<cfquery name="GET_EMP_POS" datasource="#dsn#">
	SELECT POSITION_CODE FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_ID = #session.ep.userid#
</cfquery>
<cfset position_list = valuelist(get_emp_pos.POSITION_CODE,',')>
<cfquery name="GET_TRAINS_ALL" datasource="#dsn#">
		SELECT
			TRR.REQUEST_ROW_ID,
			TR.TRAIN_REQUEST_ID,
			TR.EMPLOYEE_ID,
			TR.POSITION_CODE,
			TR.REQUEST_YEAR,
			TRAINING_PRIORITY,
			WORK_TARGET_ADDITION,
			TR.FIRST_BOSS_ID,
			TR.FIRST_BOSS_CODE,
			TR.FIRST_BOSS_VALID,
			TR.SECOND_BOSS_ID,
			TR.SECOND_BOSS_CODE,
			TR.SECOND_BOSS_VALID,
			TR.THIRD_BOSS_ID,
			TR.THIRD_BOSS_CODE,
			TR.THIRD_BOSS_VALID,
			TR.FOURTH_BOSS_ID,
			TR.FOURTH_BOSS_CODE,	
			TR.FOURTH_BOSS_VALID,
			TR.FIFTH_BOSS_ID,
			TR.FIFTH_BOSS_CODE,	
			TR.FIFTH_BOSS_VALID,			
			TR.RECORD_EMP,
			TR.RECORD_DATE,
			TR.UPDATE_DATE,
			TR.UPDATE_EMP,
			TRR.REQUEST_TYPE,
			TRR.REQUEST_STATUS,
			TRR.CLASS_ID,
			TC.CLASS_TARGET,
			TC.CLASS_OBJECTIVE,
			TC.CLASS_NAME,
			TRR.FIRST_BOSS_VALID_ROW,
			TRR.FIRST_BOSS_DATE_ROW,
			TRR.FIRST_BOSS_DETAIL_ROW,
			TRR.SECOND_BOSS_VALID_ROW,
			TRR.SECOND_BOSS_DATE_ROW,
			TRR.SECOND_BOSS_DETAIL_ROW,
			TRR.THIRD_BOSS_VALID_ROW,
			TRR.THIRD_BOSS_DATE_ROW,
			TRR.THIRD_BOSS_DETAIL_ROW,
			TRR.FOURTH_BOSS_VALID_ROW,
			TRR.FOURTH_BOSS_DATE_ROW,
			TRR.FOURTH_BOSS_DETAIL_ROW,
			TRR.FIFTH_BOSS_VALID_ROW,
			TRR.FIFTH_BOSS_DATE_ROW,
			TRR.FIFTH_BOSS_DETAIL_ROW,
			TR.IS_VALID_VALUE,
			'' AS TRAINING_ID
		FROM 
			TRAINING_REQUEST TR,
			TRAINING_REQUEST_ROWS TRR,
			TRAINING_CLASS TC
		WHERE 
			TR.TRAIN_REQUEST_ID=#attributes.train_req_id# AND
			TRR.TRAIN_REQUEST_ID=TR.TRAIN_REQUEST_ID AND
			TC.CLASS_ID=TRR.CLASS_ID AND
			TRR.CLASS_ID IS NOT NULL
			<cfif not session.ep.ehesap>
			AND (
				TR.FIRST_BOSS_CODE IN (#position_list#) OR
				TR.SECOND_BOSS_CODE IN (#position_list#) OR
				TR.THIRD_BOSS_CODE IN (#position_list#) OR
				TR.FOURTH_BOSS_CODE IN (#position_list#) OR
				TR.FIFTH_BOSS_CODE IN (#position_list#)
				)
			</cfif>
	UNION ALL
		SELECT
			TRR.REQUEST_ROW_ID,
			TR.TRAIN_REQUEST_ID,
			TR.EMPLOYEE_ID,
			TR.POSITION_CODE,
			TR.REQUEST_YEAR,
			TRAINING_PRIORITY,
			WORK_TARGET_ADDITION,
			TR.FIRST_BOSS_ID,
			TR.FIRST_BOSS_CODE,	
			TR.FIRST_BOSS_VALID,
			TR.SECOND_BOSS_ID,
			TR.SECOND_BOSS_CODE,
			TR.SECOND_BOSS_VALID,
			TR.THIRD_BOSS_ID,
			TR.THIRD_BOSS_CODE,	
			TR.THIRD_BOSS_VALID,
			TR.FOURTH_BOSS_ID,
			TR.FOURTH_BOSS_CODE,	
			TR.FOURTH_BOSS_VALID,
			TR.FIFTH_BOSS_ID,
			TR.FIFTH_BOSS_CODE,	
			TR.FIFTH_BOSS_VALID,					
			TR.RECORD_EMP,
			TR.RECORD_DATE,
			TR.UPDATE_DATE,
			TR.UPDATE_EMP,
			TRR.REQUEST_TYPE,
			TRR.REQUEST_STATUS,
			0 CLASS_ID,
			NULL CLASS_TARGET,
			NULL CLASS_OBJECTIVE,
			OTHER_TRAIN_NAME CLASS_NAME,
			TRR.FIRST_BOSS_VALID_ROW,
			TRR.FIRST_BOSS_DATE_ROW,
			TRR.FIRST_BOSS_DETAIL_ROW,
			TRR.SECOND_BOSS_VALID_ROW,
			TRR.SECOND_BOSS_DATE_ROW,
			TRR.SECOND_BOSS_DETAIL_ROW,
			TRR.THIRD_BOSS_VALID_ROW,
			TRR.THIRD_BOSS_DATE_ROW,
			TRR.THIRD_BOSS_DETAIL_ROW,
			TRR.FOURTH_BOSS_VALID_ROW,
			TRR.FOURTH_BOSS_DATE_ROW,
			TRR.FOURTH_BOSS_DETAIL_ROW,
			TRR.FIFTH_BOSS_VALID_ROW,
			TRR.FIFTH_BOSS_DATE_ROW,
			TRR.FIFTH_BOSS_DETAIL_ROW,
			TR.IS_VALID_VALUE,
			'' AS TRAINING_ID
		FROM 
			TRAINING_REQUEST TR,
			TRAINING_REQUEST_ROWS TRR
		WHERE
			TR.TRAIN_REQUEST_ID=#attributes.train_req_id# AND
			TRR.TRAIN_REQUEST_ID=TR.TRAIN_REQUEST_ID
			AND CLASS_ID IS NULL
			AND TRR.TRAINING_ID IS NULL
			<cfif not session.ep.ehesap>
			AND (
				TR.FIRST_BOSS_CODE IN (#position_list#) OR
				TR.SECOND_BOSS_CODE IN (#position_list#) OR
				TR.THIRD_BOSS_CODE IN (#position_list#) OR
				TR.FOURTH_BOSS_CODE IN (#position_list#) OR
				TR.FIFTH_BOSS_CODE IN (#position_list#)
				)
			</cfif>
	UNION ALL
		SELECT
			TRR.REQUEST_ROW_ID,
			TR.TRAIN_REQUEST_ID,
			TR.EMPLOYEE_ID,
			TR.POSITION_CODE,
			TR.REQUEST_YEAR,
			TRAINING_PRIORITY,
			WORK_TARGET_ADDITION,
			TR.FIRST_BOSS_ID,
			TR.FIRST_BOSS_CODE,	
			TR.FIRST_BOSS_VALID,
			TR.SECOND_BOSS_ID,
			TR.SECOND_BOSS_CODE,
			TR.SECOND_BOSS_VALID,
			TR.THIRD_BOSS_ID,
			TR.THIRD_BOSS_CODE,	
			TR.THIRD_BOSS_VALID,
			TR.FOURTH_BOSS_ID,
			TR.FOURTH_BOSS_CODE,	
			TR.FOURTH_BOSS_VALID,
			TR.FIFTH_BOSS_ID,
			TR.FIFTH_BOSS_CODE,	
			TR.FIFTH_BOSS_VALID,					
			TR.RECORD_EMP,
			TR.RECORD_DATE,
			TR.UPDATE_DATE,
			TR.UPDATE_EMP,
			TRR.REQUEST_TYPE,
			TRR.REQUEST_STATUS,
			0 CLASS_ID,
			NULL CLASS_TARGET,
			NULL CLASS_OBJECTIVE,
			T.TRAIN_HEAD,
			TRR.FIRST_BOSS_VALID_ROW,
			TRR.FIRST_BOSS_DATE_ROW,
			TRR.FIRST_BOSS_DETAIL_ROW,
			TRR.SECOND_BOSS_VALID_ROW,
			TRR.SECOND_BOSS_DATE_ROW,
			TRR.SECOND_BOSS_DETAIL_ROW,
			TRR.THIRD_BOSS_VALID_ROW,
			TRR.THIRD_BOSS_DATE_ROW,
			TRR.THIRD_BOSS_DETAIL_ROW,
			TRR.FOURTH_BOSS_VALID_ROW,
			TRR.FOURTH_BOSS_DATE_ROW,
			TRR.FOURTH_BOSS_DETAIL_ROW,
			TRR.FIFTH_BOSS_VALID_ROW,
			TRR.FIFTH_BOSS_DATE_ROW,
			TRR.FIFTH_BOSS_DETAIL_ROW,
			TR.IS_VALID_VALUE,
			TRR.TRAINING_ID AS TRAINING_ID 
		FROM 
			TRAINING_REQUEST TR,
			TRAINING_REQUEST_ROWS TRR,
			TRAINING T
		WHERE 
			TR.EMPLOYEE_ID=#session.ep.userid# AND
			TR.TRAIN_REQUEST_ID=#attributes.train_req_id# AND
			TRR.TRAIN_REQUEST_ID=TR.TRAIN_REQUEST_ID AND
			T.TRAIN_ID=TRR.TRAINING_ID AND
			TRR.TRAINING_ID IS NOT NULL	
			<cfif not session.ep.ehesap>
			AND (
				TR.FIRST_BOSS_CODE IN (#position_list#) OR
				TR.SECOND_BOSS_CODE IN (#position_list#) OR
				TR.THIRD_BOSS_CODE IN (#position_list#) OR
				TR.FOURTH_BOSS_CODE IN (#position_list#) OR
				TR.FIFTH_BOSS_CODE IN (#position_list#)
				)
			</cfif>
</cfquery>
<cfif not get_trains_all.recordcount>
	<script type="text/javascript">
		alert("<cf_get_lang no ='168.Eğitim Talepleri Silinmiş Veya Yetkiniz Yok'>!");
		history.go(-1);
	</script>
	<cfabort>
</cfif>
<!---<cfquery name="GET_TRAINS_STANDART" dbtype="query">
	SELECT * FROM get_trains_all WHERE REQUEST_TYPE = 1
</cfquery>
<cfquery name="GET_TRAINS_REQUIRED" dbtype="query">
	SELECT * FROM get_trains_all WHERE REQUEST_TYPE = 2
</cfquery>
<cfquery name="GET_TRAINS_TECH" dbtype="query">
	SELECT * FROM get_trains_all WHERE REQUEST_TYPE = 4
</cfquery>
--->
<cfquery name="GET_TRAINS_POS_REQ" dbtype="query">
	SELECT * FROM get_trains_all <!---WHERE REQUEST_TYPE = 3--->
</cfquery>
<cfsavecontent variable="img_">
	<cfif get_module_user(3)>
        <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=training.popup_dsp_performance_form&emp_id=#get_trains_all.employee_id#</cfoutput>','project');"><img src="/images/carier.gif" title="<cf_get_lang no ='166.Hedef Yetkinlik Değerlendirme Formu'>" border="0"></a>
    </cfif>
</cfsavecontent>
<cf_form_box title="#getLang('training',169)# : <cfoutput>#get_emp_info(get_trains_all.employee_id,0,0)#</cfoutput>" right_images="#img_#">
	<cfform name="add_class_request" method="post" action="#request.self#?fuseaction=training.emptypopup_upd_class_request">
		<table>
			<tr>
				<td width="60"><cf_get_lang no ='104.Talep Yılı'>&nbsp;&nbsp;&nbsp;</td>
				<td valign="top" class="txtbold">: <cfoutput>#get_trains_all.request_year#</cfoutput></td>
				<cfif (get_trains_all.employee_id eq session.ep.userid) and (get_trains_all.is_valid_value eq 1)>
				<cfsavecontent variable="message"><cf_get_lang no ='206.Yıllık Talep Formunuzu Sürecinizi Siliyorsunuz Süreç Tekrar İşleyecek Emin misiniz'></cfsavecontent>
					<td><cfoutput><a href="javascript://" onClick="if (confirm('#message#')) windowopen('#request.self#?fuseaction=training.emptypopup_add_valid_traning_request&train_req_id=#train_req_id#&type=delete','small');"><img src="/images/close.gif" align="absmiddle" border="0"></a></cfoutput></td>
				</cfif>
			</tr>
		</table>
        <input type="hidden" name="request_year" id="request_year" value="<cfoutput>#get_trains_all.REQUEST_YEAR#</cfoutput>">
        <input type="hidden" name="train_req_id" id="train_req_id" value="<cfoutput>#get_trains_all.TRAIN_REQUEST_ID#</cfoutput>">	
		<cf_form_list>
            <thead>
                <tr>
                    <th colspan="9"><cf_get_lang no ='109.Yetkinlik Gelişim Eğitimleri'></th>
                </tr>
                <tr>
                    <input type="hidden" name="record_num_pos_req" id="record_num_pos_req" value="<cfoutput>#get_trains_pos_req.recordcount#</cfoutput>">
                    <cfif get_trains_all.is_valid_value neq 1>
                        <th width="18"><input type="button" class="eklebuton" title="" onClick="add_row_pos_req();"></th>
                    </cfif>
                    <th><cf_get_lang no ='72.Eğitim Adı'></th>
                    <th width="30"><cf_get_lang_main no ='73.Öncellik'></th>
                    <th width="200"><cf_get_lang no ='110.İş Hedefine Katkısı'></th>
                    <cfif get_trains_all.is_valid_value eq 1>
                        <cfoutput>
                        <input type="hidden" name="amir_id_1_old" id="amir_id_1_old" value="#get_trains_all.first_boss_id#">
                        <input type="hidden" name="amir_id_1" id="amir_id_1" value="#get_trains_all.first_boss_id#">
                        <input type="hidden" name="amir_code_1" id="amir_code_1" value="#get_trains_all.first_boss_code#">
                        <input type="hidden" name="amir_id_2_old" id="amir_id_2_old" value="#get_trains_all.second_boss_id#">
                        <input type="hidden" name="amir_id_2" id="amir_id_2" value="#get_trains_all.second_boss_id#">
                        <input type="hidden" name="amir_code_2" id="amir_code_2" value="#get_trains_all.second_boss_code#">
                        <input type="hidden" name="amir_id_3_old" id="amir_id_3_old" value="#get_trains_all.third_boss_id#">
                        <input type="hidden" name="amir_id_3" id="amir_id_3" value="#get_trains_all.third_boss_id#">
                        <input type="hidden" name="amir_code_3" id="amir_code_3" value="#get_trains_all.third_boss_code#">
                        <input type="hidden" name="amir_id_4_old" id="amir_id_4_old" value="#get_trains_all.fourth_boss_id#">
                        <input type="hidden" name="amir_id_4" id="amir_id_4" value="#get_trains_all.fourth_boss_id#">
                        <input type="hidden" name="amir_code_4" id="amir_code_4" value="#get_trains_all.fourth_boss_code#">
                        <input type="hidden" name="amir_id_5_old" id="amir_id_5_old" value="#get_trains_all.fifth_boss_id#">
                        <input type="hidden" name="amir_id_5" id="amir_id_5" value="#get_trains_all.fifth_boss_id#">
                        <input type="hidden" name="amir_code_5" id="amir_code_5" value="#get_trains_all.fifth_boss_code#">
                        </cfoutput>
                        <th width="125"><cfinput type="text" name="amir_name_1" value="#get_emp_info(get_trains_all.first_boss_code,1,0)#" style="width:100px;" readonly="true"> <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=add_class_request.amir_id_1&field_name=add_class_request.amir_name_1&field_code=add_class_request.amir_code_1&select_list=1</cfoutput>','list')"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a></th>
                        <th width="125"><cfinput type="text" name="amir_name_2" value="#get_emp_info(get_trains_all.second_boss_code,1,0)#" style="width:100px;" readonly="true"> <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=add_class_request.amir_id_2&field_name=add_class_request.amir_name_2&field_code=add_class_request.amir_code_2&select_list=1</cfoutput>','list')"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a></th>
                        <th width="125"><cfinput type="text" name="amir_name_3" value="#get_emp_info(get_trains_all.third_boss_code,1,0)#" style="width:100px;" readonly="true"> <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=add_class_request.amir_id_3&field_name=add_class_request.amir_name_3&field_code=add_class_request.amir_code_3&select_list=1</cfoutput>','list')"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a></th>
                        <th width="125"><cfinput type="text" name="amir_name_4" value="#get_emp_info(get_trains_all.fourth_boss_code,1,0)#" style="width:100px;" readonly="true"> <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=add_class_request.amir_id_4&field_name=add_class_request.amir_name_4&field_code=add_class_request.amir_code_4&select_list=1</cfoutput>','list')"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a></th>
                        <th width="125"><cfinput type="text" name="amir_name_5" value="#get_emp_info(get_trains_all.fifth_boss_code,1,0)#" style="width:100px;" readonly="true"> <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=add_class_request.amir_id_5&field_name=add_class_request.amir_name_5&field_code=add_class_request.amir_code_5&select_list=1</cfoutput>','list')"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a></th>
                        <cfif session.ep.ehesap eq 1>
                        <cfsavecontent variable="message"><cf_get_lang no ='61.Amirlerinizi Değiştirirseniz Sürecin Yeniden İşlemesine Seben Olacaksınız Emin misiniz'></cfsavecontent>
                            <th width="25"><a href="javascript://" onClick="javascript:if(confirm('<cfoutput>#message#</cfoutput>')) gonder(); else return false;"><img src="/images/oriantation.gif" align="absmiddle" title="<cf_get_lang no ='174.Amir Değiştir'>" border="0"></a></th>
                        </cfif>
                    <cfelse>
                    </cfif>
                </tr>
              </thead>
              <tbody id="table_pos_req">
                <cfif get_trains_pos_req.recordcount>
                    <cfoutput query="get_trains_pos_req">
                        <tr id="frm_row_pos_req#currentrow#" name="frm_row_pos_req#currentrow#">
                            <input type="hidden" name="class_id_pos_req#currentrow#" id="class_id_pos_req#currentrow#" value="#training_id#">
                            <input  type="hidden"  value="1"  name="row_kontrol_pos_req#currentrow#" id="row_kontrol_pos_req#currentrow#">
                            <input type="hidden" name="class_name_pos_req#currentrow#" id="class_name_pos_req#currentrow#" value="#class_name#">
                            <cfif get_trains_all.is_valid_value neq 1>
                                <td><a style="cursor:pointer" onclick="sil_pos_req(#currentrow#);"><img  src="/images/delete_list.gif" border="0"></a></td>
							</cfif>
                            <td>#CLASS_NAME#</td>
                            <td><input type="text" name="priority_pos_req#currentrow#" id="priority_pos_req#currentrow#" onBlur="control1('#currentrow#');" value="#TRAINING_PRIORITY#" maxlength="150" style="width:30px;"></td>
                            <td><textarea name="work_addition_pos_req#currentrow#" id="work_addition_pos_req#currentrow#" style="width:200px;height:45;">#WORK_TARGET_ADDITION#</textarea></td>
                            <cfsavecontent variable="messagee"><cf_get_lang_main no='13.uyarı'>:<cf_get_lang_main no ='784.Onaylamak İstediğnizden Emin misiniz ?'></cfsavecontent>
                            <cfif get_trains_all.is_valid_value eq 1>
                                <td><cfif listfind(position_list,get_trains_all.first_boss_code,',') and first_boss_valid_row neq 1>
                                        <input type="hidden" name="amir_valid_1" id="amir_valid_1" value="#first_boss_valid_row#">
                                        <a href="javascript://" onClick="javascript:if(confirm('#messagee#')) windowopen('#request.self#?fuseaction=training.emptypopup_add_training_request_valid_emp&request_row_id=#request_row_id#&type=1','small'); else return false;"><img src="/images/valid.gif" align="absmiddle" title="<cf_get_lang_main no ='1063.Onayla'>" border="0"></a>
                                    <cfelseif first_boss_valid_row eq 1>
                                        <input type="hidden" name="amir_valid_1" id="amir_valid_1" value="2">
                                        <img src="/images/add_lesson.gif" title="#first_boss_detail_row#" align="absmiddle"><cf_get_lang_main no ='88.Onay'> T:#dateformat(first_boss_date_row,dateformat_style)#
                                    <cfelse>
                                        <cfif len(first_boss_id)><cf_get_lang_main no ='203.Onay Bekliyor'></cfif>
                                    </cfif>
                                </td>
                                <td><cfif listfind(position_list,second_boss_code,',') and second_boss_valid_row neq 1 and first_boss_valid_row eq 1>
                                        <input type="hidden" name="amir_valid_2" id="amir_valid_2" value="#second_boss_valid_row#">
                                        <a href="javascript://" onClick="javascript:if(confirm('#messagee#')) windowopen('#request.self#?fuseaction=training.emptypopup_add_training_request_valid_emp&request_row_id=#request_row_id#&type=2','small'); else return false;"><img src="/images/valid.gif" align="absmiddle" title="<cf_get_lang_main no ='1063.Onayla'>" border="0">
                                    <cfelseif second_boss_valid_row eq 1>
                                        <input type="hidden" name="amir_valid_2" id="amir_valid_2" value="2">
                                        <img src="/images/add_lesson.gif" title="#second_boss_detail_row#" align="absmiddle"><cf_get_lang_main no ='88.Onay'>T:#dateformat(second_boss_date_row,dateformat_style)#
                                    <cfelse>
                                        <cfif len(get_trains_all.second_boss_id)><cf_get_lang_main no ='203.Onay Bekliyor'></cfif>
                                    </cfif>
                                </td>
                                <td><cfif listfind(position_list,third_boss_code,',') and third_boss_valid_row neq 1 and second_boss_valid_row eq 1>
                                        <input type="hidden" name="amir_valid_3" id="amir_valid_3" value="#get_trains_all.third_boss_valid_row#">
                                        <a href="javascript://" onClick="javascript:if(confirm('#messagee#')) windowopen('#request.self#?fuseaction=training.emptypopup_add_training_request_valid_emp&request_row_id=#request_row_id#&type=3','small'); else return false;"><img src="/images/valid.gif" align="absmiddle" title="<cf_get_lang_main no ='1063.Onayla'>" border="0">
                                    <cfelseif third_boss_valid_row eq 1>
                                        <input type="hidden" name="amir_valid_3" id="amir_valid_3" value="2">
                                        <img src="/images/add_lesson.gif" title="#third_boss_detail_row#" align="absmiddle"><cf_get_lang_main no ='88.Onay'>T:#dateformat(third_boss_date_row,dateformat_style)#
                                    <cfelse>
                                        <cfif len(get_trains_all.third_boss_id)><cf_get_lang_main no ='203.Onay Bekliyor'></cfif>
                                    </cfif>
                                </td>
                                <td><cfif listfind(position_list,get_trains_all.fourth_boss_code,',') and fourth_boss_valid_row neq 1 and third_boss_valid_row eq 1>
                                        <input type="hidden" name="amir_valid_4" id="amir_valid_4" value="#get_trains_all.fourth_boss_valid_row#">
                                        <a href="javascript://" onClick="javascript:if(confirm('#messagee#')) windowopen('#request.self#?fuseaction=training.emptypopup_add_training_request_valid_emp&request_row_id=#request_row_id#&type=4','small'); else return false;"><img src="/images/valid.gif" align="absmiddle" title="<cf_get_lang_main no ='1063.Onayla'>" border="0">
                                    <cfelseif fourth_boss_valid_row eq 1>
                                        <input type="hidden" name="amir_valid_4" id="amir_valid_4" value="2">
                                        <img src="/images/add_lesson.gif" title="#fourth_boss_detail_row#" align="absmiddle"><cf_get_lang_main no ='88.Onay'>T:#dateformat(fourth_boss_date_row,dateformat_style)#
                                    <cfelse>
                                        <cfif len(get_trains_all.fourth_boss_id)><cf_get_lang_main no ='203.Onay Bekliyor'></cfif>
                                    </cfif>
                                </td>
                                <td><cfif listfind(position_list,get_trains_all.fifth_boss_code,',') and fifth_boss_valid_row neq 1 and fourth_boss_valid_row eq 1>
                                        <input type="hidden" name="amir_valid_5" id="amir_valid_5" value="#get_trains_all.fifth_boss_valid_row#">
                                        <a href="javascript://" onClick="javascript:if(confirm('#messagee#')) windowopen('#request.self#?fuseaction=training.emptypopup_add_training_request_valid_emp&request_row_id=#request_row_id#&type=5','small'); else return false;"><img src="/images/valid.gif" align="absmiddle" title="<cf_get_lang_main no ='1063.Onayla'>" border="0">
                                    <cfelseif fifth_boss_valid_row eq 1>
                                        <input type="hidden" name="amir_valid_5" id="amir_valid_5" value="2">
                                        <img src="/images/add_lesson.gif" title="#fifth_boss_detail_row#" align="absmiddle"><cf_get_lang_main no ='88.Onay'>T:#dateformat(fifth_boss_date_row,dateformat_style)#
                                    <cfelse>
                                        <cfif len(get_trains_all.fifth_boss_id)><cf_get_lang_main no ='203.Onay Bekliyor'></cfif>
                                    </cfif>
                                </td>
                                <cfif session.ep.ehesap eq 1>
                                    <td width="15">&nbsp;</td>
                                </cfif>
                            <cfelse>
                            </cfif>
                        </tr>
                    </cfoutput>
                </cfif>
            </tbody>
        </cf_form_list>
        <cf_form_box_footer>
        	<cfif (get_trains_all.is_valid_value neq 1)>
				<cfif get_trains_all.first_boss_valid neq 1><cf_workcube_buttons is_upd='1' add_function="controlform()" delete_page_url='#request.self#?fuseaction=training.emptypopup_del_class_request&train_req_id=#attributes.train_req_id#'></cfif>
                <cfsavecontent variable="message1"><cf_get_lang_main no='13.uyarı'>:<cf_get_lang_main no ='784.Onaylamak İstediğinizden Emin misiniz?'></cfsavecontent>
                &nbsp;<cfoutput><a href="javascript://" onClick="if (confirm('#message1#')) windowopen('#request.self#?fuseaction=training.emptypopup_add_valid_traning_request&train_req_id=#train_req_id#','small');"><img src="images/valid.gif" align="absmiddle" border="0"></a></cfoutput>
			</cfif>
		</cf_form_box_footer>
	</cfform>
</cf_form_box>
<script type="text/javascript">
var row_count_pos_req=<cfoutput>#get_trains_pos_req.recordcount#</cfoutput>;
<!---var row_count_tech=<cfoutput>#get_trains_tech.recordcount#</cfoutput>;--->
var row_count_tech = 0; // alt satırlarda row_count_tech hatalı olarak geliyordu diye bu satırı ekledim.. M.E.Y 20120806
function kontrol_pos_req()
{
	var satir=0;
	for(var i=1;i<=row_count_pos_req;i++)
		if(eval("add_class_request.row_kontrol_pos_req"+i).value==1) satir=satir+1;
	if(satir >= 3) <!---<cfoutput>#get_trains_standart.recordcount#</cfoutput>+satir >= 3--->
	{
		alert(" <cf_get_lang_main no='13.uyarı'>:<cf_get_lang no='147.En Fazla 3 '><cf_get_lang no='105.standart eğitim'>!");
		return false;
	}
	return true;
}
function add_row_pos_req()
{
	if(!kontrol_pos_req())return false;
	row_count_pos_req++;
	var newRow;
	var newCell;
	newRow = document.getElementById("table_pos_req").insertRow(document.getElementById("table_pos_req").rows.length);
	newRow.className = 'color-row';
	newRow.setAttribute("name","frm_row_pos_req" + row_count_pos_req);
	newRow.setAttribute("id","frm_row_pos_req" + row_count_pos_req);		
	
	document.add_class_request.record_num_pos_req.value=row_count_pos_req;
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<a style="cursor:pointer" onclick="sil_pos_req('+ row_count_pos_req +');"><img  src="/images/delete_list.gif" border="0"></a>';
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<input  type="hidden"  value="1"  name="row_kontrol_pos_req' + row_count_pos_req +'" ><input type="text" readonly name="class_name_pos_req' + row_count_pos_req + '" value="" style="width:200px;"><input type="hidden" name="class_id_pos_req' + row_count_pos_req + '" value=""> <a onclick="javascript:open_train('+row_count_pos_req+',1);"><img src="/images/plus_thin.gif" border="0" align="absmiddle" style="cursor:pointer;"></a>';
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<input type="text" name="priority_pos_req' + row_count_pos_req + '" value="" onBlur="control1(' + row_count_pos_req + ');" style="width:30px;" maxlength="2">';
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<textarea name="work_addition_pos_req' + row_count_pos_req + '" style="width:200px;height:45;"></textarea>';
}
function sil_pos_req(sy)
{
	var my_element=eval("add_class_request.row_kontrol_pos_req"+sy);
	my_element.value=0;
	var my_element=eval("frm_row_pos_req"+sy);
	my_element.style.display="none";	
}
function add_row_tech()
{
	alert("asdasdasdasd");
	row_count_tech++;
	var newRow;
	var newCell;
	newRow = document.getElementById("table_tech").insertRow(document.getElementById("table_tech").rows.length);
	newRow.className = 'color-row';
	newRow.setAttribute("name","frm_row_tech" + row_count_tech);
	newRow.setAttribute("id","frm_row_tech" + row_count_tech);		
	
	document.record_num_tech.record_num_tech.value=row_count_tech;
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<a style="cursor:pointer" onclick="sil_pos_tech('+ row_count_tech +');"><img  src="/images/delete_list.gif" border="0"></a>';
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<input  type="text"  value="1"  name="row_kontrol_tech' + row_count_tech +'" ><input type="text" name="class_name_tech' + row_count_tech + '" onBlur="tech_id_kontrol('+ row_count_tech +')" value="" style="width:200px;"><input type="hidden" name="class_id_tech' + row_count_tech + '" value=""> <a onclick="javascript:open_train('+row_count_tech+',2);"><img src="/images/plus_thin.gif" border="0" align="absmiddle" style="cursor:pointer;"></a>';
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<input type="text" name="priority_tech' + row_count_tech + '" value="" onBlur="control2(' + row_count_tech + ');" style="width:30px;" maxlength="2">';
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<textarea name="work_addition_tech' + row_count_tech + '" style="width:200px;height:45;"></textarea>';
}
function sil_pos_tech(sy)
{
	var my_element=eval("add_class_request.row_kontrol_tech"+sy);
	my_element.value=0;
	var my_element=eval("frm_row_tech"+sy);
	my_element.style.display="none";	
}
function tech_id_kontrol(st)
{
	var my_element=eval("add_class_request.class_id_tech"+st);
	my_element.value='';
}
function gonder()
{
	<cfoutput>
		windowopen('#request.self#?fuseaction=training.emptypopup_add_training_request_valid_emp&train_req_id=#attributes.train_req_id#&deger=1&amir_1_id=' + add_class_request.amir_id_1.value + '&amir_id_1_old=' + add_class_request.amir_id_1_old.value + '&amir_2_id=' + add_class_request.amir_id_2.value + '&amir_id_2_old=' + add_class_request.amir_id_2_old.value + '&amir_3_id=' + add_class_request.amir_id_3.value + '&amir_id_3_old=' + add_class_request.amir_id_3_old.value +'&amir_4_id=' + add_class_request.amir_id_4.value + '&amir_id_4_old=' + add_class_request.amir_id_4_old.value + '&amir_5_id=' + add_class_request.amir_id_5.value + '&amir_id_5_old=' + add_class_request.amir_id_5_old.value +'&amir_code_1=' + add_class_request.amir_code_1.value + '&amir_code_2=' + add_class_request.amir_code_2.value +'&amir_code_3=' + add_class_request.amir_code_3.value + '&amir_code_4=' + add_class_request.amir_code_4.value +'&amir_code_5=' + add_class_request.amir_code_5.value,'small');
	</cfoutput>
}
function open_train(sy,type)
{
if(type == 1)
	windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=training.popup_list_training_subjects&field_id=add_class_request.class_id_pos_req'+sy+'&field_name=add_class_request.class_name_pos_req'+sy+'&list_type=1','project');
else
	windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=training.popup_list_training_subjects&field_id=add_class_request.class_id_tech'+sy+'&field_name=add_class_request.class_name_tech'+sy+'&class_type=2','project');
}
function control1(id)
{
	deger_my_value = eval("document.add_class_request.priority_pos_req"+id);
	if(deger_my_value.value > 3 || deger_my_value.value < 0)
	{
		alert("<cf_get_lang_main no='13.uyarı'>:<cf_get_lang_main no ='73.Öncelik '>-<cf_get_lang no ='149.1 İle 3 Arası'> !");
		deger_my_value.value = "";
	}
	if(deger_my_value.value != "")
	{
		var oneChar = deger_my_value.value.substring(0,1)
		if (oneChar < "1" ||  oneChar > "9") 
		{
			alert("<cf_get_lang_main no='65.hatalı veri'>:<cf_get_lang_main no ='73.Öncelik '>-<cf_get_lang_main no='783.tam sayı'>!");
			deger_my_value.value = '';
			deger_my_value.focus();
		}
		else
		{
			for (var r=1;r<=row_count_pos_req;r++)
			{
				deger_row_kontrol = eval("document.add_class_request.row_kontrol_pos_req"+r);
				if(deger_row_kontrol.value == 1)
				{
					if(r != id)
					{
						deger_other_value = eval("document.add_class_request.priority_pos_req"+r);
						if(deger_my_value.value == deger_other_value.value)
						{
							alert("<cf_get_lang_main no='13.uyarı'>:<cf_get_lang_main no ='250.alan'> <cf_get_lang_main no='781.tekrarı'> !");
							deger_my_value.value = "";
							break;
						}
					}
				}
			}
		}
	}
}
function control2(id)
{
	deger_my_value = eval("document.add_class_request.priority_tech"+id);
	if(deger_my_value.value > 3 || deger_my_value.value < 0)
	{
		alert("<cf_get_lang_main no='13.uyarı'>:<cf_get_lang_main no ='73.Öncelik '>-<cf_get_lang no ='149.1 İle 3 Arası'>!");
		deger_my_value.value = "";
	}
	if(deger_my_value.value != "")
	{
		var oneChar = deger_my_value.value.substring(0,1)
		if (oneChar < "1" ||  oneChar > "9") 
		{
			alert("<cf_get_lang_main no='65.hatalı veri'>:<cf_get_lang_main no ='73.Öncelik '>-<cf_get_lang_main no='783.tam sayı'>!");
			deger_my_value.value = '';
			deger_my_value.focus();
		}
		else
		{
			for (var r=1;r<=row_count_tech;r++)
			{
				deger_row_kontrol = eval("document.add_class_request.row_kontrol_tech"+r);
				if(deger_row_kontrol.value == 1)
				{
					if(r != id)
					{
						deger_other_value = eval("document.add_class_request.priority_tech"+r);
						if(deger_my_value.value == deger_other_value.value)
						{
							alert("<cf_get_lang_main no='13.uyarı'>:<cf_get_lang_main no ='250.alan'> <cf_get_lang_main no='781.tekrarı'>!");
							deger_my_value.value = "";
							break;
						}
					}
				}
			}
		}
	}
}
function controlform()
{
	for (var r=1;r<=row_count_pos_req;r++)
	{
		deger_row_kontrol = eval("document.add_class_request.row_kontrol_pos_req"+r);
		deger_my_value = eval("document.add_class_request.priority_pos_req"+r);
		deger_work_addition_pos_req = eval("document.add_class_request.work_addition_pos_req"+r);
		if(deger_row_kontrol.value == 1)
		{
			if(deger_my_value.value == "")
			{
				alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no='138.yetkinlik gelişim eğitimi'>-<cf_get_lang_main no ='73.Öncelik '>!");
				return false;
				break;
			}
			if(deger_work_addition_pos_req.value == "")
			{
				alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no='138.yetkinlik gelişim eğitimi'>-<cf_get_lang no ='110.İş Hedefine Katkısı'>!");
				return false;
				break;
			}
		}
	}

	for (var r=1;r<=row_count_tech;r++)
	{
		deger_row_kontrol = eval("document.add_class_request.row_kontrol_tech"+r);
		deger_my_value = eval("document.add_class_request.priority_tech"+r);
		deger_work_addition_tech = eval("document.add_class_request.work_addition_tech"+r);
		if(deger_row_kontrol.value == 1)
		{
			if(deger_my_value.value == "")
			{
				alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no='121.teknik gelişim eğitimi'>-<cf_get_lang_main no ='73.Öncelik '>!");
				return false;
				break;
			}
			if(deger_work_addition_tech.value == "")
			{
				alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no='121.teknik gelişim eğitimi'>-<cf_get_lang no ='110.İş Hedefine Katkısı'>!");
				return false;
				break;
			}
		}
	}
}
</script>
