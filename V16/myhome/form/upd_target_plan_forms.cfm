<cfif fusebox.circuit eq 'myhome'>
    <cfset attributes.per_id = contentEncryptingandDecodingAES(isEncode:0,content:attributes.per_id,accountKey:session.ep.userid)>
</cfif>
<cfinclude template="../query/target_perf_control.cfm">
<cfquery name="GET_PERF" datasource="#dsn#">
	SELECT
		EPT.IS_COACH,
		EPT.IS_DEP_ADMIN,
		EPT.REQ_TYPE_LIST,
		EPT.EMP_VALID_FORM,
		EPT.EMP_VALID_DATE_FORM,
		EPT.FIRST_BOSS_ID,
		EPT.FIRST_BOSS_CODE,
		EPT.FIRST_BOSS_VALID,
		EPT.FIRST_BOSS_VALID_FORM,
		EPT.FIRST_BOSS_VALID_DATE_FORM,
		EPT.SECOND_BOSS_ID,
		EPT.SECOND_BOSS_CODE,
		EPT.SECOND_BOSS_VALID,
		EPT.SECOND_BOSS_VALID_FORM,
		EPT.SECOND_BOSS_VALID_DATE_FORM,
		EPT.THIRD_BOSS_ID,
		EPT.THIRD_BOSS_CODE,
		EPT.THIRD_BOSS_VALID,
		EPT.THIRD_BOSS_VALID_FORM,
		EPT.THIRD_BOSS_VALID_DATE_FORM,
		EPT.FOURTH_BOSS_ID,
		EPT.FOURTH_BOSS_CODE,
		EPT.FOURTH_BOSS_VALID,
		EPT.FOURTH_BOSS_VALID_FORM,
		EPT.FOURTH_BOSS_VALID_DATE_FORM,
		EPT.FIFTH_BOSS_ID,
		EPT.FIFTH_BOSS_CODE,
		EPT.FIFTH_BOSS_VALID,
		EPT.FIFTH_BOSS_VALID_FORM,
		EPT.FIFTH_BOSS_VALID_DATE_FORM,	
		EP.*
	FROM 
		EMPLOYEE_PERFORMANCE_TARGET EPT,
		EMPLOYEE_PERFORMANCE EP
	WHERE 
		EPT.PER_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.per_id#">
		AND EP.PER_ID=EPT.PER_ID
</cfquery>
<cfif not GET_PERF.RECORDCOUNT>
	<script type="text/javascript">
		alert("<cf_get_lang dictionary_id ='31613.Görüntülemek İstediğiniz form yok'>!");
		history.back();
	</script>
	<cfabort>
</cfif>
<cfquery name="GET_TARGET" datasource="#dsn#">
	SELECT 
		TC.*
	FROM 
		TARGET TC
	WHERE 
		TC.PER_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.per_id#">
</cfquery>
<cfinclude template="../query/get_moneys.cfm">
<cfquery name="GET_EMP" datasource="#dsn#">
	SELECT
		EP.EMPLOYEE_ID,
		EP.POSITION_CODE,
		EP.POSITION_NAME,
		D.DEPARTMENT_ID,
		D.DEPARTMENT_HEAD,
		B.BRANCH_NAME,
		OC.COMPANY_NAME,
		B.BRANCH_ID,
		OC.COMP_ID,
		EP.POSITION_CAT_ID,
        EIO.START_DATE,
        SPC.POSITION_CAT,
        ST.TITLE
	FROM
		EMPLOYEE_POSITIONS EP,
		DEPARTMENT D,
		BRANCH B,
		OUR_COMPANY OC,
        EMPLOYEES_IN_OUT EIO,
        SETUP_POSITION_CAT SPC,
        SETUP_TITLE ST
	WHERE 
		EP.POSITION_CODE= <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_PERF.POSITION_CODE#"> AND
		EP.DEPARTMENT_ID=D.DEPARTMENT_ID AND
		B.BRANCH_ID=D.BRANCH_ID AND
		OC.COMP_ID=B.COMPANY_ID AND
        EIO.EMPLOYEE_ID = EP.EMPLOYEE_ID AND
        EP.POSITION_CAT_ID = SPC.POSITION_CAT_ID AND
        ST.TITLE_ID = EP.TITLE_ID
</cfquery>
<cfset emp_name=get_emp_info(GET_PERF.EMP_ID,0,0)>
<cfsavecontent variable="right">
	<!---<cfif GET_PERF.EMP_ID neq SESSION.EP.USERID><a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=myhome.popup_form_add_req_type_quiz&position_code=#GET_PERF.POSITION_CODE#&per_id=#attributes.per_id#</cfoutput>','list');"><img src="/images/quiz.gif" align="absmiddle" border="0" title="<cf_get_lang no ='1101.Yetkinlik Soruları'>"></a></cfif>--->
	<a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=myhome.popup_form_add_req_type_result&position_code=#GET_PERF.POSITION_CODE#&result_id=#GET_PERF.RESULT_ID#&#attributes.per_id#</cfoutput>','list');"><img src="/images/properties.gif"  align="absmiddle" border="0" title="<cf_get_lang dictionary_id ='31860.Hedef Yetkinlik Değerlendirme Sonuçları'>"></a>
	<a href="<cfoutput>#request.self#</cfoutput>?fuseaction=hr.target_plan_forms_info"><img src="/images/plus1.gif" align="absmiddle" title="<cf_get_lang dictionary_id='57582.Ekle'>"  border="0"></a>
</cfsavecontent>
<cfsavecontent variable="message"><cf_get_lang dictionary_id='29754.Abonelik'></cfsavecontent>
<cf_form_box title="#message# : #emp_name#" right_images="#right#">
    <cfsavecontent variable="message"><cf_get_lang dictionary_id='41512.Çalışan Hakkında Bilgiler'></cfsavecontent>
	<cf_seperator id="calisan_bilgileri" header="#message#" is_closed="1">
    <table align="left" id="calisan_bilgileri" style="display:none;">
        <tr class="nohover">
            <td class="txtbold"><cf_get_lang dictionary_id='32370.Adı Soyadı'></td>
            <td> : <cfoutput>#emp_name#</cfoutput></td>
            <td class="txtbold" style="padding-left:10px;"><cf_get_lang dictionary_id='31622.İşe Başlama Tarihi'></td>
            <td> : <cfoutput>#dateformat(get_emp.START_DATE, dateformat_style)#</cfoutput></td>
        </tr>
        <tr class="nohover">
            <td class="txtbold"><cf_get_lang dictionary_id='57572.Departman'> / <cf_get_lang dictionary_id='59004.Pozisyon Tipi'></td>
            <td> : <cfif len(GET_EMP.POSITION_CODE)><cfoutput>#GET_EMP.DEPARTMENT_HEAD# / #GET_EMP.POSITION_CAT#</cfoutput></cfif></td>
            <td class="txtbold" style="padding-left:10px;"><cf_get_lang dictionary_id='57571.Ünvan'></td>
            <td> : <cfoutput>#GET_EMP.TITLE#</cfoutput></td>
        </tr>
        <tr class="nohover">
            <td class="txtbold"><cf_get_lang dictionary_id='58472.Dönem'></td>
            <td> : <cfoutput>#dateformat(GET_PERF.start_date,dateformat_style)# - #dateformat(GET_PERF.finish_date,dateformat_style)#</cfoutput></td>
            <td class="txtbold" style="padding-left:10px;"><cf_get_lang dictionary_id='41511.Değerlendirmeyi Yapan Yönetici'></td>
            <td> : 
                <cfif GET_PERF.FIRST_BOSS_VALID_FORM eq 1>
                    <cfoutput>#get_emp_info(GET_PERF.FIRST_BOSS_ID,0,0)#</cfoutput>
                <cfelse>
                    <cfoutput>#get_emp_info(GET_PERF.FIRST_BOSS_CODE,1,0)#</cfoutput>
                </cfif>
            </td>
        </tr>
    </table>
    <cfsavecontent variable="message"><cf_get_lang dictionary_id='57964.Hedefler'></cfsavecontent>
    <cf_seperator id="target_table" header="#message#" is_closed="1">
    <!--- Kişi Hedefleri ---> 
	<cf_medium_list name="target_table" id="target_table" style="display:none;">
		<thead>
			<tr> 
				<th nowrap="nowrap"><cf_get_lang dictionary_id ='31598.Çalışanın İş Hedefleri, Ortak Hedefler ve Kişisel Gelişim Hedefleri'></th>
				<th nowrap="nowrap"><cf_get_lang dictionary_id ='31599.Hedef Ağırlığı'>(%)</th>
				<th nowrap="nowrap"><cf_get_lang dictionary_id ='31600.Hedef Gerçekleşme'></th>
				<th nowrap="nowrap"><cf_get_lang dictionary_id ='31601.Hedef için Çalışmadı /Çaba Gösterilmedi'></th>
				<th nowrap="nowrap"><cf_get_lang dictionary_id ='31602.Çaba Gösterildi Ama Beklenin Altında'></th>
				<th nowrap="nowrap"><cf_get_lang dictionary_id ='56473.Hedefe Ulaşıldı / İstenen Sonuç Elde Edildi'></th>
				<th nowrap="nowrap"><cf_get_lang dictionary_id ='31604.Hedef Aşıldı'></th>
				<th class="header_icn_none"><cfif GET_PERF.EMP_VALID_FORM neq 1><a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_form_add_target&position_code=#GET_PERF.POSITION_CODE#&emp_id=#GET_PERF.EMP_ID#&per_id=#attributes.per_id#</cfoutput>','list');"><img src="/images/plus_list.gif"  align="absmiddle" border="0" title="<cf_get_lang dictionary_id ='31422.Hedef Ekle'>"></a></cfif></th>
			</tr>
		</thead>
		<tbody>
			<cfif GET_PERF.recordcount><!--- Çalışanın son amirinin onayladıktan sonra hedef formlarının güncellemenmemesi için.. --->
			<cfif len(GET_PERF.FIRST_BOSS_CODE)>
				<cfset amir_onay='FIRST_BOSS_VALID'>
			</cfif>
			<cfif len(GET_PERF.SECOND_BOSS_CODE)>
				<cfset amir_onay='SECOND_BOSS_VALID'>
			</cfif>
			<cfif len(GET_PERF.THIRD_BOSS_CODE)>
				<cfset amir_onay='THIRD_BOSS_VALID'>
			</cfif>
			<cfif len(GET_PERF.FOURTH_BOSS_CODE)>
				<cfset amir_onay='FOURTH_BOSS_VALID'>
			</cfif>
			<cfif len(GET_PERF.FIFTH_BOSS_CODE)>
				<cfset amir_onay='FIFTH_BOSS_VALID'>
			</cfif>
			</cfif>
			<cfif GET_TARGET.recordcount>
				<cfoutput query="GET_TARGET">
                    <tr id="frm_target_row#currentrow#" class="color-row">
                        <td>
                            <cfif not len(Evaluate('GET_PERF.#amir_onay#'))><!--- Form eğer en son amir tarafından henüz onaylanmamışsa,yani formun güncellemeye kapatılması gerekmiyorsa. --->
                                <a class="tableyazi" href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_form_add_target&event=upd&target_id=#TARGET_ID#&position_code=#GET_PERF.POSITION_CODE#<cfif GET_PERF.EMP_VALID_FORM eq 1>&per_id=#attributes.per_id#</cfif>','page')">#TARGET_HEAD#</a>
                            <cfelse>
                                #TARGET_HEAD#
                            </cfif>
                        </td>
                        <td>#TARGET_WEIGHT#</td>
                        <td>#PERFORM_COMMENT#</td>
                        <td align="center"><cfif PERFORM_POINT_ID eq 1><b>*</b></cfif></td>
                        <td align="center"><cfif PERFORM_POINT_ID eq 2><b>*</b></cfif></td>
                        <td align="center"><cfif PERFORM_POINT_ID eq 3><b>*</b></cfif></td>
                        <td align="center"><cfif PERFORM_POINT_ID eq 4><b>*</b></cfif></td>
                        <td align="center"><cfif GET_PERF.EMP_VALID_FORM neq 1><a style="cursor:pointer" onclick="windowopen('#request.self#?fuseaction=objects.del_target&target_id=#TARGET_ID#&per_id=#attributes.per_id#','small');"><img  src="/images/delete_list.gif" border="0"></a></cfif></td>
                    </tr>
                </cfoutput>
			<cfelse>
				<tr id="frm_target_row0" height="30"> 
					<td colspan="8"><cf_get_lang dictionary_id ='31605.Kişiye Eklenmiş Hedef Kaydı Yok'></td>
				</tr>
			</cfif>
		</tbody>
    </cf_medium_list>
    <cfsavecontent variable="message"><cf_get_lang dictionary_id='58709.Yetkinlikler'></cfsavecontent>
    <cf_seperator id="multi_pos_id" header="#message#" is_closed="1">
    <cf_box
		closable="0" 
        id="multi_pos_id"
        unload_body="0" 
        style="width:99%"
        box_page="#request.self#?fuseaction=myhome.popup_form_add_req_type_quiz&position_code=#GET_PERF.POSITION_CODE#&per_id=#attributes.per_id#">
     </cf_box>
    <cf_seperator id="upd_perform_seperator" header="Onaylar" is_closed="1">
    <cfform name="upd_perform" style="display:none;" method="post" action="#request.self#?fuseaction=myhome.emptypopup_upd_target_plan_forms">
    <input type="hidden" name="per_id" id="per_id" value="<cfoutput>#attributes.per_id#</cfoutput>">
        <!--- onaylar --->
        <cf_form_list id="upd_perform_seperator" marginleft="1">
            <thead>  
                <tr>
                    <th width="100"></th>
                    <th width="400"><cf_get_lang dictionary_id='57570.Ad Soyad'></th>
                    <th width="100"><cf_get_lang dictionary_id='57500.Onay'></th>
                </tr>
            </thead>  
            <tbody>
                <tr>
                    <td><cf_get_lang dictionary_id ='31606.Çalışan Onay'></td>
                    <td><cfoutput>#emp_name#</cfoutput></td>
                    <td>
                    <input type="hidden" name="emp_valid" id="emp_valid" value="">
                    <cfif GET_PERF.EMP_VALID_FORM neq 1 and session.ep.userid eq GET_PERF.EMP_ID>
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id ='31575.Onaylamakta Olduğunuz belge şirketinizi ve sizi bağlayacak konular içerebilir Onaylamak istediğinizden emin misiniz '></cfsavecontent>
                        <input type="Image" src="/images/valid.gif" alt="<cf_get_lang dictionary_id='58475.Onayla'>"  onclick="if (confirm('<cfoutput>#message#</cfoutput>')) {upd_perform.emp_valid.value='1'} else {return false}" border="0">
                    <cfelseif GET_PERF.EMP_VALID_FORM eq 1>
                        <cfoutput>#dateformat(GET_PERF.EMP_VALID_DATE_FORM,dateformat_style)#</cfoutput>
                        <cfif session.ep.userid eq GET_PERF.EMP_ID>
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id ='31576.Onaylamakta Olduğunuz belge şirketinizi ve sizi bağlayacak konular içerebilir reddetmek istediğinizden emin misiniz '></cfsavecontent>
                            <input type="Image" src="/images/refusal.gif" alt="<cf_get_lang dictionary_id ='56805.Süreci İptal Et'>" onclick="if (confirm('<cfoutput>#message#</cfoutput> ')) {upd_perform.emp_valid.value='-1'} else {return false}" border="0">
                        </cfif>
                    <cfelse>
                        <cf_get_lang dictionary_id='57615.Onay Bekliyor'>
                    </cfif>
                    </td>
                </tr>
                <tr>
                    <td><cf_get_lang dictionary_id ='31612.Üst Amir'>1</td><!---form onaylandi ise emp_id den onay bekliyorsa position_code dan ismi getirir--->
                    <td><cfif GET_PERF.FIRST_BOSS_VALID_FORM eq 1>
                            <cfoutput>#get_emp_info(GET_PERF.FIRST_BOSS_ID,0,0)#</cfoutput>
                        <cfelse>
                            <cfoutput>#get_emp_info(GET_PERF.FIRST_BOSS_CODE,1,0)#</cfoutput>
                        </cfif>
                    </td>
                    <td>
                    <input type="hidden" name="amir_valid_1" id="amir_valid_1" value="">
                    <cfif GET_PERF.EMP_VALID_FORM eq 1 and GET_PERF.FIRST_BOSS_VALID_FORM neq 1 and listfind(position_list,GET_PERF.FIRST_BOSS_CODE,',')>
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id ='31575.Onaylamakta Olduğunuz belge şirketinizi ve sizi bağlayacak konular içerebilir Onaylamak istediğinizden emin misiniz '></cfsavecontent>
                        <input type="Image" src="/images/valid.gif" alt="<cf_get_lang dictionary_id='58475.Onayla'>" onclick="if (confirm('<cfoutput>#message#</cfoutput>')) {upd_perform.amir_valid_1.value='1'} else {return false}" border="0">
                    <cfelseif GET_PERF.FIRST_BOSS_VALID_FORM eq 1>
                        <cfoutput>#dateformat(GET_PERF.FIRST_BOSS_VALID_DATE_FORM,dateformat_style)#</cfoutput>
                    <cfelse>
                        <cf_get_lang dictionary_id='57615.Onay Bekliyor'>
                    </cfif>
                    </td>
                </tr>
                <tr>
                    <td><cf_get_lang dictionary_id ='31612.Üst Amir'>2</td>
                    <td><cfif GET_PERF.SECOND_BOSS_VALID_FORM eq 1>
                            <cfoutput>#get_emp_info(GET_PERF.SECOND_BOSS_ID,0,0)#</cfoutput>
                        <cfelse>
                            <cfoutput>#get_emp_info(GET_PERF.SECOND_BOSS_CODE,1,0)#</cfoutput>
                        </cfif>
                    </td>
                    <td>
                    <cfif GET_PERF.FIRST_BOSS_VALID_FORM eq 1 and GET_PERF.SECOND_BOSS_VALID_FORM neq 1 and listfind(position_list,GET_PERF.SECOND_BOSS_CODE,',')>
                        <input type="hidden" name="amir_valid_2" id="amir_valid_2" value="">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id ='31575.Onaylamakta Olduğunuz belge şirketinizi ve sizi bağlayacak konular içerebilir Onaylamak istediğinizden emin misiniz '></cfsavecontent>
                        <input type="Image" src="/images/valid.gif" alt="<cf_get_lang dictionary_id='58475.Onayla'>" onclick="if (confirm('<cfoutput>#message#</cfoutput>')) {upd_perform.amir_valid_2.value='1'} else {return false}" border="0">
                    <cfelseif GET_PERF.SECOND_BOSS_VALID_FORM eq 1>
                        <cfoutput>#dateformat(GET_PERF.SECOND_BOSS_VALID_DATE_FORM,dateformat_style)#</cfoutput>
                    <cfelse>
                        <cf_get_lang dictionary_id='57615.Onay Bekliyor'>
                    </cfif>
                    </td>
                </tr>
                <tr>
                    <td><cf_get_lang dictionary_id ='31612.Üst Amir'>3</td>
                    <td>
                    <cfif GET_PERF.THIRD_BOSS_VALID_FORM eq 1>
                        <cfoutput>#get_emp_info(GET_PERF.THIRD_BOSS_ID,0,0)#</cfoutput>
                    <cfelse>
                        <cfoutput>#get_emp_info(GET_PERF.THIRD_BOSS_CODE,1,0)#</cfoutput>
                    </cfif>
                    </td>
                    <td>
                    <cfif GET_PERF.SECOND_BOSS_VALID_FORM eq 1 and GET_PERF.THIRD_BOSS_VALID_FORM neq 1 and listfind(position_list,GET_PERF.THIRD_BOSS_CODE,',')>
                        <input type="hidden" name="amir_valid_3" id="amir_valid_3" value="">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id ='31575.Onaylamakta Olduğunuz belge şirketinizi ve sizi bağlayacak konular içerebilir Onaylamak istediğinizden emin misiniz '></cfsavecontent>
                        <input type="Image" src="/images/valid.gif" alt="<cf_get_lang dictionary_id='58475.Onayla'>" onclick="if (confirm('<cfoutput>#message#</cfoutput>')) {upd_perform.amir_valid_3.value='1'} else {return false}" border="0">
                    <cfelseif GET_PERF.THIRD_BOSS_VALID_FORM eq 1>
                        <cfoutput>#dateformat(GET_PERF.THIRD_BOSS_VALID_DATE_FORM,dateformat_style)#</cfoutput>
                    <cfelse>
                        <cf_get_lang dictionary_id='57615.Onay Bekliyor'>
                    </cfif>
                    </td>
                </tr>
                <tr>
                    <td><cf_get_lang dictionary_id ='31612.Üst Amir'>4</td>
                    <td>
                    <cfif GET_PERF.FOURTH_BOSS_VALID_FORM eq 1>
                        <cfoutput>#get_emp_info(GET_PERF.FOURTH_BOSS_ID,0,0)#</cfoutput>
                    <cfelse>
                        <cfoutput>#get_emp_info(GET_PERF.FOURTH_BOSS_CODE,1,0)#</cfoutput>
                    </cfif>
                    </td>
                    <td>
                    <cfif GET_PERF.THIRD_BOSS_VALID_FORM eq 1 and GET_PERF.FOURTH_BOSS_VALID_FORM neq 1 and listfind(position_list,GET_PERF.FOURTH_BOSS_CODE,',')>
                        <input type="hidden" name="amir_valid_4" id="amir_valid_4" value="">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id ='31575.Onaylamakta Olduğunuz belge şirketinizi ve sizi bağlayacak konular içerebilir Onaylamak istediğinizden emin misiniz '></cfsavecontent>
                        <input type="Image" src="/images/valid.gif" alt="<cf_get_lang dictionary_id='58475.Onayla'>" onclick="if (confirm('<cfoutput>#message#</cfoutput>')) {upd_perform.amir_valid_4.value='1'} else {return false}" border="0">
                    <cfelseif GET_PERF.FOURTH_BOSS_VALID_FORM eq 1>
                        <cfoutput>#dateformat(GET_PERF.FOURTH_BOSS_VALID_DATE_FORM,dateformat_style)#</cfoutput>
                    <cfelse>
                        <cf_get_lang dictionary_id='57615.Onay Bekliyor'>
                    </cfif>
                    </td>
                </tr>
                <tr>
                    <td><cf_get_lang dictionary_id ='31612.Üst Amir'>5</td>
                    <td>
                    <cfif GET_PERF.FIFTH_BOSS_VALID_FORM eq 1>
                        <cfoutput>#get_emp_info(GET_PERF.FIFTH_BOSS_ID,0,0)#</cfoutput>
                    <cfelse>
                        <cfoutput>#get_emp_info(GET_PERF.FIFTH_BOSS_CODE,1,0)#</cfoutput>
                    </cfif>
                    </td>
                    <td>
                    <cfif GET_PERF.FOURTH_BOSS_VALID_FORM eq 1 and GET_PERF.FIFTH_BOSS_VALID_FORM neq 1 and listfind(position_list,GET_PERF.FIFTH_BOSS_CODE,',')>
                        <input type="hidden" name="amir_valid_5" id="amir_valid_5" value="">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id ='31575.Onaylamakta Olduğunuz belge şirketinizi ve sizi bağlayacak konular içerebilir Onaylamak istediğinizden emin misiniz '></cfsavecontent>
                        <input type="Image" src="/images/valid.gif" alt="<cf_get_lang dictionary_id='58475.Onayla'>" onclick="if (confirm('<cfoutput>#message#</cfoutput>')) {upd_perform.amir_valid_5.value='1'} else {return false}" border="0">
                    <cfelseif GET_PERF.FIFTH_BOSS_VALID_FORM eq 1>
                        <cfoutput>#dateformat(GET_PERF.FIFTH_BOSS_VALID_DATE_FORM,dateformat_style)#</cfoutput>
                    <cfelse>
                        <cf_get_lang dictionary_id='57615.Onay Bekliyor'>
                    </cfif>
                    </td>
                </tr>
            </tbody>
        </cf_form_list>
        <!--- onaylar --->
        <br/>
        <cf_form_box_footer>
            <cf_record_info record_emp="RECORD_KEY" update_emp="UPDATE_KEY" query_name="GET_PERF">
        </cf_form_box_footer>
    </cfform>
</cf_form_box>
<script type="text/javascript">
	function kontrol()
	{ 
		if (add_target_plan.row_kontrol.value != "")
			for(var satir_i=1; satir_i <=add_target_plan.row_kontrol.value; satir_i++)
			{
				if(eval("add_target_plan.target_row_kontrol"+satir_i).value == 1 && eval("add_target_plan.new_target_amount"+satir_i).value == "")
				{ 
					alert(satir_i+ ".<cf_get_lang dictionary_id='37377.Satırdaki'> <cf_get_lang dictionary_id='60008.Hedef Rakamınızı Giriniz'>!");
					return false;
				}
			}
	}
</script>
