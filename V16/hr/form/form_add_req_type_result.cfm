<!--- hesaplama : aldığı_puan * ağırlık/  enyüksek alacağı puan(ağırlıklı punalar)--->
<cfinclude template="../query/target_perf_control.cfm">
<cfquery name="GET_PER_TARGET" datasource="#dsn#">
	SELECT 
		EPT.*,
		EP.START_DATE,
		EP.FINISH_DATE
	FROM 
		EMPLOYEE_PERFORMANCE_TARGET EPT,
		EMPLOYEE_PERFORMANCE EP
	WHERE 
		EPT.PER_ID=#attributes.per_id#
		AND EP.PER_ID=EPT.PER_ID
</cfquery>
<cfquery name="GET_TARGET" datasource="#dsn#">
	SELECT 
		TC.*
	FROM 
		TARGET TC
	WHERE 
		TC.PER_ID=#attributes.per_id#
</cfquery>

<cfquery name="GET_EMP" datasource="#dsn#">
	SELECT
		EP.EMPLOYEE_ID, 
		EP.POSITION_CODE,
		EP.EMPLOYEE_NAME,
		EP.EMPLOYEE_SURNAME,
		EP.POSITION_NAME,
		D.DEPARTMENT_ID,
		D.DEPARTMENT_HEAD,
		B.BRANCH_NAME,
		OC.COMPANY_NAME,
		B.BRANCH_ID,
		OC.COMP_ID
	FROM
		EMPLOYEE_POSITIONS EP,
		DEPARTMENT D,
		BRANCH B,
		OUR_COMPANY OC
	WHERE 
		POSITION_CODE=#attributes.position_code# AND
		EP.DEPARTMENT_ID=D.DEPARTMENT_ID AND
		B.BRANCH_ID=D.BRANCH_ID AND
		OC.COMP_ID=B.COMPANY_ID
</cfquery>

<cfif listlen(GET_PER_TARGET.REQ_TYPE_LIST,',')>
	<cfset attributes.all_req_type_id=GET_PER_TARGET.REQ_TYPE_LIST&','&GET_PER_TARGET.DEP_MANAGER_REQ_TYPE&','&GET_PER_TARGET.COACH_REQ_TYPE&','&GET_PER_TARGET.STD_REQ_TYPE>
<cfelse>
	<cfquery name="GET_EMP_REQ" datasource="#dsn#">
		SELECT 
			POSITION_REQ_TYPE.REQ_TYPE_ID,
			POSITION_REQ_TYPE.REQ_TYPE,
			POSITION_REQ_TYPE.IS_GROUP
		FROM 
			RELATION_SEGMENT,
			POSITION_REQ_TYPE
		WHERE 
			POSITION_REQ_TYPE.REQ_TYPE_ID=RELATION_SEGMENT.RELATION_FIELD_ID
			AND RELATION_ACTION=2 
			AND RELATION_ACTION_ID=#get_emp.DEPARTMENT_ID#
			AND RELATION_TABLE='POSITION_REQ_TYPE'
			<cfif len(GET_PER_TARGET.START_DATE)>
			AND PERFECTION_YEAR = #dateformat(GET_PER_TARGET.START_DATE,'yyyy')#
			</cfif>
		GROUP BY 
			POSITION_REQ_TYPE.IS_GROUP,
			POSITION_REQ_TYPE.REQ_TYPE_ID,
			POSITION_REQ_TYPE.REQ_TYPE
		ORDER BY 
			POSITION_REQ_TYPE.IS_GROUP DESC
	</cfquery>
	<cfif GET_EMP_REQ.RECORDCOUNT>
		<cfset attributes.all_req_type_id=valuelist(GET_EMP_REQ.REQ_TYPE_ID,',')>
	<cfelse>
		<cfset attributes.all_req_type_id=0>
	</cfif>
	
	<cfset kocluk_yetkinlik_list=0>
	<cfif GET_PER_TARGET.IS_COACH eq 1>
		<cfquery name="GET_WORK_GROUP" datasource="#DSN#">
			SELECT 
				REQ_TYPE_ID
			FROM 
				POSITION_REQ_TYPE
			WHERE 
				IS_COACH=1
				<cfif len(GET_PER_TARGET.START_DATE)>
				AND PERFECTION_YEAR = #dateformat(GET_PER_TARGET.START_DATE,'yyyy')#
				</cfif>
		</cfquery>
		<cfif GET_WORK_GROUP.RECORDCOUNT>
			<cfset kocluk_yetkinlik_list=valuelist(GET_WORK_GROUP.REQ_TYPE_ID,',')>
		</cfif>
	</cfif>
	<cfset attributes.all_req_type_id=attributes.all_req_type_id&','&kocluk_yetkinlik_list>
	
	<cfset dep_yetkinlik_list=0>
	<cfif GET_PER_TARGET.IS_DEP_ADMIN eq 1>
		<cfquery name="GET_REQ_DEP" datasource="#DSN#">
			SELECT 
				REQ_TYPE_ID
			FROM 
				POSITION_REQ_TYPE
			WHERE 
				IS_DEP_ADMIN=1
				<cfif len(GET_PER_TARGET.START_DATE)>
				AND PERFECTION_YEAR = #dateformat(GET_PER_TARGET.START_DATE,'yyyy')#
				</cfif>
		</cfquery>
		<cfif GET_REQ_DEP.RECORDCOUNT>
			<cfset dep_yetkinlik_list=valuelist(GET_REQ_DEP.REQ_TYPE_ID,',')>
		</cfif>
	</cfif>
	<cfset attributes.all_req_type_id=attributes.all_req_type_id&','&dep_yetkinlik_list>
	<cfset std_yetkinlik_list=0>
	<cfif GET_PER_TARGET.IS_COACH neq 1 and GET_PER_TARGET.IS_DEP_ADMIN neq 1>
		<cfquery name="GET_REQ_DEP" datasource="#DSN#">
			SELECT 
				REQ_TYPE_ID,
				REQ_TYPE
			FROM 
				POSITION_REQ_TYPE
			WHERE 
				IS_STANDART=1
				<cfif len(GET_PER_TARGET.START_DATE)>
				AND PERFECTION_YEAR = #dateformat(GET_PER_TARGET.START_DATE,'yyyy')#
				</cfif>
		</cfquery>
		<cfif GET_REQ_DEP.RECORDCOUNT>
			<cfset std_yetkinlik_list=valuelist(GET_REQ_DEP.REQ_TYPE_ID,',')>
		</cfif>
	</cfif>
	<cfset attributes.all_req_type_id=attributes.all_req_type_id&','&std_yetkinlik_list>
</cfif>

<cfquery name="GET_QUIZ_CHAPTERS" datasource="#dsn#">
	SELECT * FROM EMPLOYEE_QUIZ_CHAPTER WHERE REQ_TYPE_ID IN (#attributes.all_req_type_id#) 
</cfquery>
<!--- uyarı için eklenen form--->
<form name="add_warning" action="<cfoutput>#request.self#</cfoutput>?fuseaction=myhome.popup_form_add_warning" method="post">
	<input type="hidden" name="act" id="act" value="<cfoutput>hr.upd_target_plan_forms&per_id=#attributes.per_id#</cfoutput>">
</form>
<!---/// uyarı için eklenen form--->
<cfsavecontent variable="right_images_">
	<a href="javascript://" onClick="windowopen('','medium','add_warning_window');add_warning.target='add_warning_window';add_warning.submit();" class=""><img src="../images/bugpro.gif" title="<cf_get_lang_main no ='523.Uyarı Ekle'>" border="0"></a>
</cfsavecontent>
<cfsavecontent variable="message"><cf_get_lang dictionary_id="56798.Performans Formu Sonuç"></cfsavecontent>
<cf_popup_box title="#message#(#GET_EMP.EMPLOYEE_NAME# #GET_EMP.EMPLOYEE_SURNAME#)" right_images="#right_images_#">
	<cfform name="add_perform_result" method="post" action="#request.self#?fuseaction=hr.emptypopup_add_req_type_quiz_result">
        <input type="hidden" name="position_code" id="position_code" value="<cfoutput>#attributes.position_code#</cfoutput>">
        <input type="hidden" name="result_id" id="result_id" value="<cfoutput>#attributes.result_id#</cfoutput>">
        <input type="hidden" name="per_id" id="per_id" value="<cfoutput>#attributes.per_id#</cfoutput>">
        <table>
            <tr>
                <td colspan="4"><cf_get_lang dictionary_id='58472.Dönem'>:
					<cfif session.ep.userid eq GET_PER_TARGET.FIRST_BOSS_ID>
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='57655.Başlangıç Tarihi'></cfsavecontent>
                        <cfinput required="Yes" message="#message#" type="text" name="start_date" validate="#validate_style#" value="#dateformat(GET_PER_TARGET.START_DATE,dateformat_style)#" style="width:80px;">
                        <cf_wrk_date_image date_field="start_date">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='57700.Bitiş Tarihi'></cfsavecontent>
                        <cfinput required="Yes" message="#message#" type="text" name="finish_date" validate="#validate_style#" value="#dateformat(GET_PER_TARGET.FINISH_DATE,dateformat_style)#" style="width:77px;">
                        <cf_wrk_date_image date_field="finish_date">
                    <cfelse>
                        <cfoutput>#dateformat(GET_PER_TARGET.START_DATE,dateformat_style)# - #dateformat(GET_PER_TARGET.FINISH_DATE,dateformat_style)#</cfoutput>
                    </cfif>
                </td>
            </tr>
        </table>
        <cfsavecontent variable="message"><cf_get_lang dictionary_id="55945.Birinci Amirin Değerlendirmesi"></cfsavecontent>
        <cf_seperator id="degerlendirme" title="#message#">
        	<table id="degerlendirme">
                    <tr>
                        <td colspan="2" align="center"><cf_get_lang dictionary_id ='57964.Hedefler'></td>
                        <td colspan="2" align="center"><cf_get_lang dictionary_id ='58709.Yetkinlikler'></td>
                    </tr>
                    <tr>
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='29484.Fazla karakter sayısı'></cfsavecontent>
                        <cfif session.ep.userid eq GET_PER_TARGET.FIRST_BOSS_ID>
                            <td colspan="2"><textarea name="manager_target_opinion" id="manager_target_opinion" style="width:300px;height:40px;" maxlength="1000" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="<cfoutput>#message#</cfoutput>"><cfoutput>#GET_PER_TARGET.MANAGER_TARGET_OPINION#</cfoutput></textarea></td>
                            <td colspan="2"><textarea name="manager_req_opinion" id="manager_req_opinion" style="width:300px;height:40px;" maxlength="1000" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="<cfoutput>#message#</cfoutput>"><cfoutput>#GET_PER_TARGET.MANAGER_REQ_OPINION#</cfoutput></textarea></td>
                        <cfelse>
                            <td colspan="2"><cfoutput>#GET_PER_TARGET.MANAGER_TARGET_OPINION#</cfoutput></td>
                            <td colspan="2"><cfoutput>#GET_PER_TARGET.MANAGER_REQ_OPINION#</cfoutput></td>
                        </cfif>
                    </tr>
            </table>
        <cfsavecontent variable="message"><cf_get_lang dictionary_id="56237.Çalışan Değerlendirmesi"></cfsavecontent>
		<cf_seperator id="calisan_deg" title="#message#">
        	<table id="calisan_deg">
                <tr>
                    <td colspan="2" align="center"><cf_get_lang dictionary_id ='57964.Hedefler'></td>
                    <td colspan="2" align="center"><cf_get_lang dictionary_id ='58709.Yetkinlikler'></td>
                </tr>
                <tr>
					<cfif session.ep.userid eq GET_EMP.EMPLOYEE_ID>
                        <td colspan="2"><textarea name="emp_target_opinion" id="emp_target_opinion" style="width:300px;height:40px;" maxlength="1000" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="<cfoutput>#message#</cfoutput>"><cfoutput>#GET_PER_TARGET.EMP_TARGET_OPINION#</cfoutput></textarea></td>
                        <td colspan="2"><textarea name="emp_req_opinion" id="emp_req_opinion" style="width:300px;height:40px;" maxlength="1000" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="<cfoutput>#message#</cfoutput>"><cfoutput>#GET_PER_TARGET.EMP_REQ_OPINION#</cfoutput></textarea></td>
                    <cfelse>
                        <td colspan="2"><cfoutput>#GET_PER_TARGET.EMP_TARGET_OPINION#</cfoutput></td>
                        <td colspan="2"><cfoutput>#GET_PER_TARGET.EMP_REQ_OPINION#</cfoutput></td>
                    </cfif>
                </tr>
            </table>
        <cfsavecontent variable="message"><cf_get_lang dictionary_id="56799.Yetkinlik Gelişimine Dönük Öneriler & Eylem Planları"></cfsavecontent>
		<cf_seperator id="yetkinlik" title="#message#">
        	<table id="yetkinlik">
                <tr>
                    <cfif listfind(position_list,GET_PER_TARGET.FIRST_BOSS_CODE,',')>
                        <td colspan="4"><textarea name="manager_career_exp" id="manager_career_exp" style="width:600px;height:40px;" maxlength="500" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="<cfoutput>#message#</cfoutput>"><cfoutput>#GET_PER_TARGET.MANAGER_CAREER_EXP#</cfoutput></textarea></td>
                    <cfelse>
                        <td colspan="4"><cfoutput>#GET_PER_TARGET.MANAGER_CAREER_EXP#</cfoutput></td>
                    </cfif>
                </tr>
                <tr class="color-list">
                    <td class="txtbold"><cf_get_lang dictionary_id='57951.Hedef'>/<cf_get_lang dictionary_id ='57907.Yetkinlik'> <cf_get_lang dictionary_id="57487.No"> </td>
                    <td width="120" class="txtbold"><cf_get_lang dictionary_id ='57951.Hedef'>/<cf_get_lang dictionary_id ='56800.Yetkinlik Sonuç Değerlendirme'></td>
                    <td width="100" class="txtbold"><cf_get_lang dictionary_id ='29784.Ağırlık'></td>
                    <td width="100" class="txtbold"><cf_get_lang dictionary_id ='57684.Sonuç'></td>
                </tr>
                <cfset target_total=0>
                <cfset target_point_total=0>
                <cfset target_max_point_total=0>
                <cfoutput query="GET_TARGET">
                    <tr>
                        <td>#TARGET_HEAD#</td>
                        <cfif len(PERFORM_POINT_ID)>
                            <cfset target_point=PERFORM_POINT_ID>
                        <cfelse>
                            <cfset target_point=0>
                        </cfif>
                        <td align="center">#target_point#
                        <cfset target_point_total=target_point_total+target_point>
                        </td>
                        <td>#TARGET_WEIGHT#</td>
                        <td  style="text-align:right;">
                        <cfif len(TARGET_WEIGHT)>
                            #TLFormat(target_point*TARGET_WEIGHT,2)#
                            <cfset target_total=target_total+(target_point*TARGET_WEIGHT)>
                            <cfset target_max_point_total=target_max_point_total+(4*TARGET_WEIGHT)><!--- hedef puanlaması 4 üzerinden olacksa--->
                        </cfif>
                        </td>
                    </tr>
                </cfoutput>
                <tr>
                	<td colspan="4">&nbsp;</td>
                </tr>
                <tr>
                    <td colspan="3"  style="text-align:right;"><cf_get_lang dictionary_id ='56801.Hedef Toplam'></td>
                    <td><cfoutput>#target_total#</cfoutput></td>
                </tr>
                <tr>
                    <td colspan="3"  style="text-align:right;"><cf_get_lang dictionary_id ='56802.Hedefler Düzeltilmiş Toplam'></td>
                    <td>
                    <cfset target_edit_point=0>
                    <cfif target_max_point_total gt 0 and GET_TARGET.RECORDCOUNT>
                        <cfset target_edit_point=(target_total*50)/target_max_point_total>
                    </cfif>
                    <cfoutput>#TLFormat(target_edit_point,2)#</cfoutput></td>
                </tr>
                <cfset chapter_total=0>
                <cfset chapter_point_total=0>
                <cfset chapter_max_point_total=0>
                <cfset chapterweight_total=0>
                <cfquery name="GET_ALL_QUIZ_QUESTIONS" datasource="#dsn#">
                    SELECT 
                        EMPLOYEE_QUIZ_RESULTS_DETAILS.*,
                        EMPLOYEE_QUIZ_QUESTION.CHAPTER_ID
                    FROM 
                        EMPLOYEE_QUIZ_RESULTS_DETAILS, 
                        EMPLOYEE_QUIZ_QUESTION
                    WHERE
                        EMPLOYEE_QUIZ_QUESTION.QUESTION_ID = EMPLOYEE_QUIZ_RESULTS_DETAILS.QUESTION_ID AND
                        EMPLOYEE_QUIZ_RESULTS_DETAILS.RESULT_ID = #attributes.RESULT_ID#
                </cfquery>
                <cfoutput query="get_quiz_chapters">
                    <cfset attributes.chapter_id = chapter_id>
                    <cfif len(get_quiz_chapters.chapter_weight)>
                        <cfset chapterweight = get_quiz_chapters.chapter_weight>
                    <cfelse>
                        <cfset chapterweight = 1>
                    </cfif>
                    <cfset answer_number_gelen = get_quiz_chapters.answer_number>
                        <cfquery name="GET_QUIZ_QUESTIONS" dbtype="query">
                            SELECT 
                                *
                            FROM 
                                GET_ALL_QUIZ_QUESTIONS
                            WHERE
                                CHAPTER_ID=#attributes.chapter_id#
                        </cfquery>
                        <cfset puan=0>
                        <cfset max_puan=0>
                        <cfif get_quiz_questions.recordcount>
                            <cfset listem = "">
                            <cfset listem =valuelist(get_quiz_questions.QUESTION_POINT,',')>
                            <cfset listem=ListSort(listem,'numeric','ASC',',')>
                            <cfif listlen(listem) mod 2 eq 0 and listlen(listem) gt 2>
                                <cfset puan=(listgetat(listem,listlen(listem)\2+1,',')+listgetat(listem,listlen(listem)\2,','))/2>
                            <cfelseif listlen(listem) eq 2>
                                <cfset puan=(listgetat(listem,1,',')+listgetat(listem,2,','))/2>
                            <cfelseif listlen(listem)>
                                <cfset puan=listgetat(listem,listlen(listem)\2+1,',')>
                            </cfif>
                        </cfif>
                        <tr>
                            <td nowrap>#get_quiz_chapters.CHAPTER#</td>
                            <td align="center">#puan#
                                <cfset chapter_point_total=chapter_point_total+puan>
                            </td>
                            <td>#chapterweight#</td>
                            <td>
                                #TLFormat(puan*chapterweight,2)#
                                <cfset chapter_total=chapter_total+(puan*chapterweight)>
                                <cfset chapter_max_point_total=chapter_max_point_total+(answer_number_gelen*chapterweight)><!--- soru sayısı ile en yüksek puan olma olasılığı düşünülmeli--->
                            </td>
                        </tr>
                </cfoutput>
                <tr>
                    <td colspan="3"  style="text-align:right;"><cf_get_lang dictionary_id ='56803.Yetkinlikler Toplam'></td>
                    <td><cfoutput>#chapter_total#</cfoutput></td>
                </tr>
                <tr>
                    <td colspan="3"  style="text-align:right;"><cf_get_lang dictionary_id ='56797.Yetkinlikler Düzeltilmiş Toplam'></td>
                    <td>
                    <cfif chapter_max_point_total eq 0>
                        <cfset chapter_max_point_total =1>
                    </cfif>
                    <cfif GET_QUIZ_CHAPTERS.RECORDCOUNT>
                        <cfset chapter_edit_point=(chapter_total*50)/chapter_max_point_total>
                    <cfelse>
                        <cfset chapter_edit_point=0>
                    </cfif>
                    <cfoutput>#TLFormat(chapter_edit_point,2)#</cfoutput></td>
                </tr>
                <tr>
                    <td colspan="3"  style="text-align:right;"><cf_get_lang dictionary_id ='56804.Nihai Değerlendirme'></td>
                    <td><cfoutput>#TLFormat(chapter_edit_point+target_edit_point,2)#</cfoutput>
                    <input type="hidden" name="user_point" id="user_point" value="<cfoutput>#chapter_edit_point+target_edit_point#</cfoutput>"></td>
                </tr>
            </table>
            <cfsavecontent variable="message"><cf_get_lang dictionary_id="55490.Amirler"></cfsavecontent>
            <cf_seperator id="amirler" title="#message#">
                	<cf_ajax_list id="amirler">
                    	<thead>
                            <tr class="color-list">
                                <th width="100"></th>
                                <th width="400" class="txtbold"><cf_get_lang dictionary_id ='57570.Ad Soyad'></th>
                                <th width="100" class="txtbold"><cf_get_lang dictionary_id ='57500.Onay'></th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td><cf_get_lang dictionary_id ='56477.Üst Amir'>1</td>
                                <td>
                                <cfif GET_PER_TARGET.FIRST_BOSS_VALID_FORM eq 1>
                                    <cfoutput>#get_emp_info(GET_PER_TARGET.FIRST_BOSS_ID,0,0)#</cfoutput>
                                <cfelse>
                                    <cfoutput>#get_emp_info(GET_PER_TARGET.FIRST_BOSS_CODE,1,0)#</cfoutput>
                                </cfif>
                                </td>
                                <td>
                                    <input type="hidden" name="amir_valid_1" id="amir_valid_1" value="">
                                 <cfsavecontent variable="onay"><cf_get_lang dictionary_id ='56074.Onaylamakta Olduğunuz belge şirketinizi ve sizi bağlayacak konular içerebilir Onaylamak istediğinizden emin misiniz'></cfsavecontent> 
                                <cfif GET_PER_TARGET.FIRST_BOSS_VALID neq 1 and listfind(position_list,GET_PER_TARGET.FIRST_BOSS_CODE,',')>
                                    <input type="Image" src="/images/valid.gif" alt="<cf_get_lang dictionary_id='1063.Onayla'>" onClick="if (confirm('<cfoutput>#onay#</cfoutput>')) {document.add_perform_result.amir_valid_1.value='1'} else {return false}" border="0">
                                <cfelseif GET_PER_TARGET.FIRST_BOSS_VALID eq 1>
                                    <cfoutput>#dateformat(GET_PER_TARGET.FIRST_BOSS_VALID_DATE,dateformat_style)#</cfoutput>
                                     <cfsavecontent variable="iptal"><cf_get_lang dictionary_id ='56806.Süreci başa almak üzeresiniz tüm süreç baştan işleyecektir Süreci iptal etmek istediğinizden emin misiniz'></cfsavecontent> 
                                    <cfif session.ep.userid eq GET_PER_TARGET.FIRST_BOSS_ID>
                                        <input type="Image" src="/images/refusal.gif" alt="<cf_get_lang dictionary_id ='56805.Süreci İptal Et'>" onClick="if (confirm('<cfoutput>#iptal#</cfoutput>')) {document.add_perform_result.amir_valid_1.value='-1'} else {return false}" border="0">
                                    </cfif>
                                <cfelse>
                                    <cf_get_lang dictionary_id ='57615.Onay Bekliyor'>
                                </cfif>
                                </td>
                            </tr>
                            <tr>
                                <td><cf_get_lang dictionary_id ='56477.Üst Amir'>2</td>
                                <td>
                                <cfif GET_PER_TARGET.SECOND_BOSS_VALID eq 1>
                                    <cfoutput>#get_emp_info(GET_PER_TARGET.SECOND_BOSS_ID,0,0)#</cfoutput>
                                <cfelse>
                                    <cfoutput>#get_emp_info(GET_PER_TARGET.SECOND_BOSS_CODE,1,0)#</cfoutput>
                                </cfif>
                                </td>
                                <td>
                                <cfsavecontent variable="onay"><cf_get_lang dictionary_id ='56074.Onaylamakta Olduğunuz belge şirketinizi ve sizi bağlayacak konular içerebilir Onaylamak istediğinizden emin misiniz'></cfsavecontent>
                                <cfif GET_PER_TARGET.FIRST_BOSS_VALID eq 1 and GET_PER_TARGET.SECOND_BOSS_VALID neq 1 and listfind(position_list,GET_PER_TARGET.SECOND_BOSS_CODE,',')>
                                    <input type="hidden" name="amir_valid_2" id="amir_valid_2" value="">
                                    <input type="Image" src="/images/valid.gif" alt="<cf_get_lang dictionary_id='1063.Onayla'>" onClick="if (confirm('<cfoutput>#onay#</cfoutput>')) {document.add_perform_result.amir_valid_2.value='1'} else {return false}" border="0">
                                <cfelseif GET_PER_TARGET.SECOND_BOSS_VALID eq 1>
                                    <cfoutput>#dateformat(GET_PER_TARGET.SECOND_BOSS_VALID_DATE,dateformat_style)#</cfoutput>
                                <cfelse>
                                    <cf_get_lang dictionary_id ='57615.Onay Bekliyor'>
                                </cfif>
                                </td>
                            </tr>
                            <tr>
                                <td><cf_get_lang dictionary_id ='56477.Üst Amir'>3</td>
                                <td>
                                <cfif GET_PER_TARGET.THIRD_BOSS_VALID eq 1>
                                    <cfoutput>#get_emp_info(GET_PER_TARGET.THIRD_BOSS_ID,0,0)#</cfoutput>
                                <cfelse>
                                    <cfoutput>#get_emp_info(GET_PER_TARGET.THIRD_BOSS_CODE,1,0)#</cfoutput>
                                </cfif>
                                </td>
                                <td>
                                <cfsavecontent variable="onay"><cf_get_lang dictionary_id ='56074.Onaylamakta Olduğunuz belge şirketinizi ve sizi bağlayacak konular içerebilir Onaylamak istediğinizden emin misiniz'></cfsavecontent>
                                <cfif GET_PER_TARGET.SECOND_BOSS_VALID eq 1 and GET_PER_TARGET.THIRD_BOSS_VALID neq 1 and listfind(position_list,GET_PER_TARGET.THIRD_BOSS_CODE,',')>
                                    <input type="hidden" name="amir_valid_3" id="amir_valid_3" value="">
                                    <input type="Image" src="/images/valid.gif" alt="<cf_get_lang dictionary_id='58475.Onayla'>" onClick="if (confirm('<cfoutput>#onay#</cfoutput>')) {document.add_perform_result.amir_valid_3.value='1'} else {return false}" border="0">
                                <cfelseif GET_PER_TARGET.THIRD_BOSS_VALID eq 1>
                                    <cfoutput>#dateformat(GET_PER_TARGET.THIRD_BOSS_VALID_DATE,dateformat_style)#</cfoutput>
                                <cfelse>
                                    <cf_get_lang dictionary_id ='57615.Onay Bekliyor'>
                                </cfif>
                                </td>
                            </tr>
                            <tr>
                                <td><cf_get_lang dictionary_id ='56477.Üst Amir'>4</td>
                                <td>
                                <cfif GET_PER_TARGET.FOURTH_BOSS_VALID eq 1>
                                    <cfoutput>#get_emp_info(GET_PER_TARGET.FOURTH_BOSS_ID,0,0)#</cfoutput>
                                <cfelse>
                                    <cfoutput>#get_emp_info(GET_PER_TARGET.FOURTH_BOSS_CODE,1,0)#</cfoutput>
                                </cfif>
                                </td>
                                <td>
                                <cfsavecontent variable="onay"><cf_get_lang dictionary_id ='56074.Onaylamakta Olduğunuz belge şirketinizi ve sizi bağlayacak konular içerebilir Onaylamak istediğinizden emin misiniz'></cfsavecontent>
                                <cfif GET_PER_TARGET.THIRD_BOSS_VALID eq 1 and GET_PER_TARGET.FOURTH_BOSS_VALID neq 1 and listfind(position_list,GET_PER_TARGET.FOURTH_BOSS_CODE,',')>
                                    <input type="hidden" name="amir_valid_4" id="amir_valid_4" value="">
                                    <input type="Image" src="/images/valid.gif" alt="<cf_get_lang dictionary_id='58475.Onayla'>" onClick="if (confirm('<cfoutput>#onay#</cfoutput>')) {document.add_perform_result.amir_valid_4.value='1'} else {return false}" border="0">
                                <cfelseif GET_PER_TARGET.FOURTH_BOSS_VALID eq 1>
                                    <cfoutput>#dateformat(GET_PER_TARGET.FOURTH_BOSS_VALID_DATE,dateformat_style)#</cfoutput>
                                <cfelse>
                                    <cf_get_lang dictionary_id ='57615.Onay Bekliyor'>
                                </cfif>
                                </td>
                            </tr>
                            <tr>
                                <td><cf_get_lang dictionary_id ='56477.Üst Amir'>5</td>
                                <td>
                                    <cfif GET_PER_TARGET.FIFTH_BOSS_VALID eq 1>
                                        <cfoutput>#get_emp_info(GET_PER_TARGET.FIFTH_BOSS_ID,0,0)#</cfoutput>
                                    <cfelse>
                                        <cfoutput>#get_emp_info(GET_PER_TARGET.FIFTH_BOSS_CODE,1,0)#</cfoutput>
                                    </cfif>
                                </td>
                                <td>
                                    <cfsavecontent variable="onay"><cf_get_lang dictionary_id ='56074.Onaylamakta Olduğunuz belge şirketinizi ve sizi bağlayacak konular içerebilir Onaylamak istediğinizden emin misiniz'></cfsavecontent>
                                    <cfif GET_PER_TARGET.FOURTH_BOSS_VALID eq 1 and GET_PER_TARGET.FIFTH_BOSS_VALID neq 1 and listfind(position_list,GET_PER_TARGET.FIFTH_BOSS_CODE,',')>
                                        <input type="hidden" name="amir_valid_5" id="amir_valid_5" value="">
                                        <input type="Image" src="/images/valid.gif" alt="<cf_get_lang dictionary_id='58475.Onayla'>" onClick="if (confirm('<cfoutput>#onay#</cfoutput>')) {document.add_perform_result.amir_valid_5.value='1'} else {return false}" border="0">
                                    <cfelseif GET_PER_TARGET.FIFTH_BOSS_VALID eq 1>
                                        <cfoutput>#dateformat(GET_PER_TARGET.FIFTH_BOSS_VALID_DATE,dateformat_style)#</cfoutput>
                                    <cfelse>
                                        <cf_get_lang dictionary_id ='57615.Onay Bekliyor'>
                                    </cfif>
                                </td>
                            </tr>
                        </tbody>
                    </cf_ajax_list>
		<cf_popup_box_footer>
                <cfif listfind(position_list,GET_PER_TARGET.FIRST_BOSS_CODE,',') or session.ep.userid eq GET_EMP.EMPLOYEE_ID>
                    <cf_workcube_buttons is_upd='0'>
                </cfif>
        </cf_popup_box_footer>
	</cfform>
</cf_popup_box>
