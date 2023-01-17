<cfquery name="get_survey_main" datasource="#dsn#">
	SELECT 
		TYPE,
		SURVEY_MAIN_HEAD,
		SURVEY_MAIN_DETAILS, 
		AVERAGE_SCORE, 
		TOTAL_SCORE,
		PROCESS_ID,
		IS_MANAGER_0,
		IS_MANAGER_1,
		IS_MANAGER_2,
		IS_MANAGER_3,
		IS_MANAGER_4,
		EMP_QUIZ_WEIGHT,
		MANAGER_QUIZ_WEIGHT_1,
		MANAGER_QUIZ_WEIGHT_2,
		MANAGER_QUIZ_WEIGHT_3,
		MANAGER_QUIZ_WEIGHT_4,
		IS_SELECTED_ATTENDER,
        IS_NOT_SHOW_SAVED
	FROM 
		SURVEY_MAIN 
	WHERE 
		SURVEY_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.survey_id#">
</cfquery>
<!--- Doldurulacak anketin, bilgilerini getirir --->
<cfquery name="get_survey_info" datasource="#dsn#">
	SELECT
		SC.SURVEY_CHAPTER_ID,
		SC.SURVEY_CHAPTER_HEAD,
		SC.SURVEY_CHAPTER_DETAIL,
		SC.IS_CHAPTER_DETAIL2,
		SC.SURVEY_CHAPTER_DETAIL2,
		SC.SURVEY_CHAPTER_WEIGHT,
		SC.IS_SHOW_GD,
		SQ.SURVEY_QUESTION_ID,
		SQ.QUESTION_HEAD,
		SQ.QUESTION_DETAIL,
		SQ.QUESTION_TYPE,
		SQ.QUESTION_DESIGN,
		SQ.QUESTION_IMAGE_PATH,
		SQ.IS_REQUIRED,
		SQ.IS_SHOW_GD AS QUESTION_GD
	FROM
		SURVEY_CHAPTER SC,
		SURVEY_QUESTION SQ
	WHERE
		SC.SURVEY_CHAPTER_ID = SQ.SURVEY_CHAPTER_ID AND
		SC.SURVEY_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.survey_id#">
	ORDER BY
		SC.SURVEY_CHAPTER_ID,
		SQ.SURVEY_QUESTION_ID
</cfquery><!--- İlgili anketin, bolum ve sorularini getirir, optionları loop edebilmek için kullanılır --->
<cfquery name="get_main_result_info" datasource="#dsn#">
	SELECT 
		PARTNER_ID,
		CONSUMER_ID,
		COMPANY_ID,
		EMP_ID,
		START_DATE,
		FINISH_DATE,
		COMMENT,
		PROCESS_ROW_ID,
		RESULT_NOTE,
		ACTION_TYPE,
		ACTION_ID,
		VALID,
		VALID1,
		VALID2,
		VALID3,
		VALID4,
		MANAGER1_EMP_ID,
		MANAGER1_POS,
		MANAGER2_EMP_ID,
		MANAGER2_POS,
		MANAGER3_EMP_ID,
		MANAGER3_POS,
		SCORE_RESULT_EMP,
		SCORE_RESULT_MANAGER1,
		SCORE_RESULT_MANAGER2,
		SCORE_RESULT_MANAGER3,
		SCORE_RESULT_MANAGER4,
		SCORE_RESULT,
		IS_CLOSED,
		CLASS_ATTENDER_EMP_ID,
		CLASS_ATTENDER_CONS_ID,
		CLASS_ATTENDER_PAR_ID,
		RECORD_EMP,
		RECORD_DATE,
		UPDATE_EMP,
		IS_SHOW_EMPLOYEE,
		UPDATE_DATE
	FROM 
		SURVEY_MAIN_RESULT 
	WHERE 
		SURVEY_MAIN_RESULT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.result_id#">
</cfquery> <!--- ilgili anketin result_id sini verir --->
<cf_box title="#get_survey_main.survey_main_head#"
    closable="1"
    add_href="#request.self#?fuseaction=objects.popup_form_add_detailed_survey_main_result&survey_id=#attributes.survey_id#&is_popup=#attributes.is_popup#&ACTION_TYPE_ID=#get_main_result_info.action_id#"
    lock_href="#get_main_result_info.is_closed EQ 1 ? "#session.ep.ehesap or session.ep.admin ? "#get_main_result_info.action_id NEQ session.ep.userid ? "unlock_send();": ""#":"" #":"" #"
    lock_href_title="#get_main_result_info.is_closed EQ 1 ? "#session.ep.ehesap or session.ep.admin ? "#getLang('hr',863)#" : "#getLang('hr',865)#"#" : "" #"
    unlock_href="#get_main_result_info.is_closed NEQ 1 ? "#get_main_result_info.action_id NEQ session.ep.userid ? "#get_module_user(3) ? "lock_send();": "" # "  :"" #":"" #"
    print_href="#request.self#?fuseaction=objects.popup_print_files&action_id=#attributes.survey_id#&action_row_id=#attributes.result_id#"
    scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
    <cf_box_elements>
<div class="col col-12">
    <cfif isdefined('attributes.fbx') and attributes.fbx eq 'myhome'>
        <cfset attributes.survey_id = contentEncryptingandDecodingAES(isEncode:0,content:attributes.survey_id,accountKey:session.ep.userid)>
        <cfset attributes.result_id = contentEncryptingandDecodingAES(isEncode:0,content:attributes.result_id,accountKey:session.ep.userid)>
    </cfif>
    <cfsetting showdebugoutput="no">
    
    <cfif isdefined("attributes.start_date") and isdate(attributes.start_date)>
        <cf_date tarih="attributes.start_date">
    <cfelse>
        <cfset attributes.start_date = wrk_get_today()>
    </cfif>
    <cfif get_main_result_info.recordCount>
            <cfset head = "">
            <cfset action_type_="">
            <cfoutput>
                <cfsavecontent  variable="action_type_">
                <!---Fırsat --->
                <cfif get_main_result_info.action_type eq 1>
                    <cfquery name="get_opp" datasource="#dsn3#">
                        SELECT OPP_HEAD AS RELATION_HEAD FROM OPPORTUNITIES WHERE OPP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_main_result_info.action_id#">
                    </cfquery>
                    <cf_get_lang dictionary_id='57612.Fırsat'>
                    <cfset head=get_opp.RELATION_HEAD>
                <!--- İçerik--->
                <cfelseif get_main_result_info.action_type eq 2>
                    <cfquery name="get_content" datasource="#dsn#">
                        SELECT CONT_HEAD AS RELATION_HEAD FROM CONTENT WHERE CONTENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_main_result_info.action_id#">
                    </cfquery>
                    <cf_get_lang dictionary_id='57653.İçerik'>
                    <cfset head=get_content.RELATION_HEAD>
                <!---kampanya --->
                <cfelseif get_main_result_info.action_type eq 3>
                    <cfquery name="get_campaign" datasource="#dsn3#">
                        SELECT CAMP_HEAD AS RELATION_HEAD FROM CAMPAIGNS WHERE CAMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_main_result_info.action_id#">
                    </cfquery>
                    <cf_get_lang dictionary_id='57446.Kampanya'>
                    <cfset head=get_campaign.RELATION_HEAD>
                <!--- ürün--->
                <cfelseif get_main_result_info.action_type eq 4>
                    <cfquery name="get_product" datasource="#dsn3#">
                        SELECT PRODUCT_NAME AS RELATION_HEAD FROM STOCKS WHERE STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_main_result_info.action_id#">
                    </cfquery>
                    <cf_get_lang dictionary_id='57657.Ürün'>
                    <cfset head=get_product.RELATION_HEAD>
                <!--- proje--->
                <cfelseif get_main_result_info.action_type eq 5>
                    <cfquery name="get_project" datasource="#dsn#">
                        SELECT PROJECT_HEAD AS RELATION_HEAD FROM PRO_PROJECTS WHERE PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_main_result_info.action_id#">
                    </cfquery>
                    <cf_get_lang dictionary_id='57416.Proje'>
                    <cfset head=get_project.RELATION_HEAD>
                <!---deneme süresi --->
                <cfelseif get_main_result_info.action_type eq 6>
                    <cf_get_lang dictionary_id='29776.Deneme Süresi'>
                    <cfset head=get_emp_info(get_main_result_info.action_id,0,0)>
                <!--- işe alım--->
                <cfelseif get_main_result_info.action_type eq 7>
                    <cfquery name="get_cv" datasource="#dsn#">
                        SELECT NAME+' '+SURNAME AS RELATION_HEAD FROM EMPLOYEES_APP WHERE EMPAPP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_main_result_info.action_id#">
                    </cfquery>
                    <cf_get_lang dictionary_id='57996.İşe Alım'><cfset head=get_cv.RELATION_HEAD>
                <!--- Performans--->
                <cfelseif get_main_result_info.action_type eq 8>
                    <cf_get_lang dictionary_id='58003.Performans'>
                    <cfset head=get_emp_info(get_main_result_info.action_id,0,0)>
                <!--- eğitim--->
                <cfelseif get_main_result_info.action_type eq 9>
                    <cfquery name="get_class" datasource="#dsn#">
                        SELECT CLASS_NAME AS RELATION_HEAD FROM TRAINING_CLASS WHERE CLASS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_main_result_info.action_id#">
                    </cfquery>
                    <cf_get_lang dictionary_id='57419.Eğitim'><cfset head=get_class.RELATION_HEAD>
                <!--- işten çıkış çalışan--->
                <cfelseif get_main_result_info.action_type eq 10>
                    <cf_get_lang dictionary_id='29832.İşten Çıkış'><cfset head=get_emp_info(get_main_result_info.action_id,0,0)>
                <!--- teklif--->
                <cfelseif get_main_result_info.action_type eq 12>
                    <cf_get_lang dictionary_id='57545.Teklif'><cfset head=get_emp_info(get_main_result_info.action_id,0,0)>
                <!--- sipariş--->
                <cfelseif get_main_result_info.action_type eq 13>
                    <cf_get_lang dictionary_id='57611.Sipariş'><cfset head=get_emp_info(get_main_result_info.action_id,0,0)>
                <!--- Anket--->
                <cfelseif get_main_result_info.action_type eq 14>
                    <cf_get_lang dictionary_id='58662.Anket'><cfset head=get_emp_info(get_main_result_info.action_id,0,0)>
                <!--- Satın Alma Teklifi --->
                <cfelseif get_main_result_info.action_type eq 15>
                    <cf_get_lang dictionary_id='30048.Satınalma Teklifleri'><cfset head=get_emp_info(get_main_result_info.action_id,0,0)>
                <cfelseif get_main_result_info.action_type eq 16>
                    <cf_get_lang dictionary_id='29465.Etkinlik'><cfset head=get_emp_info(get_main_result_info.action_id,0,0)>
                <!--- Mal Kabul --->
                <cfelseif get_main_result_info.action_type eq 17>
                    <cf_get_lang dictionary_id='60095.Mal Kabul'><cfset head=get_emp_info(get_main_result_info.action_id,0,0)>
                <!--- Sevkiyat --->
                <cfelseif get_main_result_info.action_type eq 18>
                    <cf_get_lang dictionary_id='45452.Sevkiyat'><cfset head=get_emp_info(get_main_result_info.action_id,0,0)>
                <!--- Call Center --->
                <cfelseif get_main_result_info.action_type eq 19>
                    <cf_get_lang dictionary_id='57438.Call Center'><cfset head=get_emp_info(get_main_result_info.action_id,0,0)>
                </cfif>
                </cfsavecontent>
    
            </cfoutput>
    
                <!--- Kilitle, Kilidi Kaldır. --->
                <!--- <cfif get_main_result_info.is_closed EQ 1>
                    <cfif session.ep.ehesap or session.ep.admin>
                        <!--- ehesap kilit açabilir --->
                        <a href="##" onClick="unlock_send();"><img src="/images/lock_buton.gif" title="Form Kilidini Kaldır"></a>
                    <cfelse>
                        <!--- ehesap olmayan kilidi görür --->
                        <img src="/images/lock_buton.gif" title="Form Kilitli">
                    </cfif>
                <cfelse>
                    <cfif get_module_user(3)><!--- IK yetkisi olan kişi kilitleyebilir--->
                    <!--- kilitlenebilir --->
                    <a href="##" onClick="lock_send();"><img src="/images/lock_open.gif" title="Formu Kilitle"></a>
                    </cfif>
                </cfif> --->
                <!--- <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_print_files&action_id=#attributes.survey_id#&action_row_id=#attributes.result_id#&print_type=510</cfoutput>','page');"><img src="/images/print.gif" border="0" alt="<cf_get_lang_main no='62.Yazdır'>"></a> --->
                <!---
                SG 20130703 bu sayfa ortak kullanılan bir popup. alttaki link diğer formlarda da geliyor neden eklendi? link çalışmıyor bu nedenle kapatıldı tekrar açmak için bilgi veriniz
                <a href="<cfoutput>#request.self#?fuseaction=campaign.form_add_detailed_survey_main_result&survey_id=#survey_id#</cfoutput>"><img src="/images/plus1.gif" border="0" alt="<cf_get_lang_main no='170.Ekle'>" title="<cf_get_lang_main no='170.Ekle'>"></a>--->
    
    
    <!--- <cfsavecontent variable="txt">
        <a href="<cfoutput>#request.self#?fuseaction=objects.popup_form_add_detailed_survey_main_result&survey_id=#attributes.survey_id#&is_popup=#attributes.is_popup#&ACTION_TYPE_ID=#get_main_result_info.action_id#"</cfoutput>><img src="/images/plus1.gif" title="<cf_get_lang_main no ='170.Ekle'>"></a>
    </cfsavecontent>
    <cfif len(get_survey_main.survey_main_details)>
        <cfset title_ = "#get_survey_main.survey_main_details#<br/><br/>">
    <cfelse>
        <cfset title_="">
    </cfif>  --->
    <div class="col col-12">
        <cfform name="survey_main_result" method="post" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_upd_detailed_survey_main_result">
        <div class="col col-12">
            <cfoutput>
                <input type="hidden" name="MANAGER_1_POS" id="MANAGER_1_POS" value="#get_main_result_info.manager1_pos#">
                <input type="hidden" name="MANAGER_1_EMP_ID" id="MANAGER_1_EMP_ID" value="#get_main_result_info.manager1_emp_id#">
            </cfoutput>
            <input type="hidden" name="survey_id" id="survey_id" value="<cfoutput>#attributes.survey_id#</cfoutput>">
            <input type="hidden" name="result_id" id="result_id" value="<cfoutput>#attributes.result_id#</cfoutput>">
            <input type="hidden" name="empapp_id" id="empapp_id" value="<cfif isdefined("attributes.empapp_id")><cfoutput>#attributes.empapp_id#</cfoutput></cfif>">
            <cfif fuseaction contains 'popup'>
            <input type="hidden" name="is_popup" id="is_popup" value="<cfoutput>#attributes.is_popup#</cfoutput>"></cfif>
            <input type="hidden" name="action_type_id" id="action_type_id" value="<cfoutput><cfif isdefined('attributes.action_type_id') and len(attributes.action_type_id)>#attributes.action_type_id#<cfelseif len(get_main_result_info.action_id)>#get_main_result_info.action_id#</cfif></cfoutput>">
            <input type="hidden" name="action_type" id="action_type" value="<cfoutput><cfif isdefined('attributes.action_type') and len(attributes.action_type)>#attributes.action_type#<cfelseif len(get_main_result_info.action_type)>#get_main_result_info.action_type#</cfif></cfoutput>">
            <input type="hidden" name="is_selected_attender" id="is_selected_attender" value="<cfoutput>#get_survey_main.is_selected_attender#</cfoutput>">
                <table width="100%" border="0" cellspacing="1" cellpadding="2">
                    <cfif get_survey_main.type eq 9 and get_survey_main.is_selected_attender eq 1 and (len(get_main_result_info.class_attender_emp_id) or len(get_main_result_info.class_attender_par_id) or len(get_main_result_info.class_attender_cons_id))>
                        <tr class="color-list">
                            <table>
                                <div class="form-group col col-6  col-md-6 col-xs-12">
                                    <label ><cf_get_lang dictionary_id='29780.Katılımcı'> *</l>
                                    <div class="input-group">:
                                        <cfoutput>
                                            <cfif len(get_main_result_info.class_attender_emp_id)>
                                                <cfset user_type = 'employee'>
                                                <cfset user_name = '#get_emp_info(get_main_result_info.class_attender_emp_id,0,0)#'>
                                                <cfset user_id = '#get_main_result_info.class_attender_emp_id#'>
                                            <cfelseif len(get_main_result_info.class_attender_par_id)>
                                                <cfset user_type = 'partner'>
                                                <cfset user_name = '#get_par_info(get_main_result_info.class_attender_par_id,0,-1,0)#'>
                                                <cfset user_id = '#get_main_result_info.class_attender_par_id#'>
                                            <cfelseif len(get_main_result_info.class_attender_cons_id)>
                                                <cfset user_type = 'consumer'>
                                                <cfset user_name = '#get_cons_info(get_main_result_info.class_attender_cons_id,0,0)#'>
                                                <cfset user_id = '#get_main_result_info.class_attender_cons_id#'>
                                            <cfelse>
                                                <cfset user_type = ''>
                                                <cfset user_name = ''>
                                                <cfset user_id = ''>
                                            </cfif>
                                        <input type="hidden" name="user_type" value="#user_type#">
                                        <input type="hidden" name="user_id" id="user_id" value="#user_id#">
                                        <input type="text" name="user_name" id="user_name" value="#user_name#">
                                        </cfoutput>
                                        <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_training_attenders&field_id=survey_main_result.user_id&field_name=survey_main_result.user_name&field_user_type=survey_main_result.user_type&class_id=#get_main_result_info.action_id#</cfoutput>','list');"><img src="/images/plus_thin.gif" border="0" align="absmiddle"></a>
                                    </div>
                                </div>
                            </table>
                        </tr>
                    </cfif>
                    <cfif get_survey_info.recordcount>
                    <div class="col col-12">
                        <tr class="color-list">
                            <cfset chapter_current_row = 1>
                            <cfset all_chapter_total_point = 0>
                            <cfoutput query="get_survey_info" group="survey_chapter_id">
                            <cf_seperator id='chapter_#chapter_current_row#' title='#survey_chapter_head# (#getLang('','Form Tipi','56000')#: #action_type_#) '>
                            <table id="chapter_#chapter_current_row#"  width="50%">
                                
                                    <cfif len(survey_chapter_detail)>
                                    <tr>
                                        <td class="bold"><!--- <b><cf_get_lang_main no="217.Açıklama"> :</b> ---> #survey_chapter_detail#</td>
                                    </tr>
                                    </cfif>
                                    <cfset question_current_row = 1>
                                    <tr>
                                        <td>
                                                            <table border="0">
                                                            <cfset chapter_total_point = 0>
                                                            <cfset chapter_weight = get_survey_info.SURVEY_CHAPTER_WEIGHT>
                                                            <cfset max_point_survey = 0>
                                                            <cfset soru_sayisi = 0>
                                                            <cfquery name="get_survey_option_max" datasource="#dsn#">
                                                                SELECT MAX(OPTION_POINT) AS MAX_OPTION_POINT FROM SURVEY_OPTION WHERE SURVEY_CHAPTER_ID = #get_survey_info.SURVEY_CHAPTER_ID#
                                                            </cfquery>
                                                            <cfset max_point_survey = get_survey_option_max.MAX_OPTION_POINT>
                                                            <cfoutput>
                                                                <cfquery name="get_opt_question_id" datasource="#dsn#">
                                                                    SELECT SURVEY_QUESTION_ID FROM SURVEY_OPTION WHERE SURVEY_QUESTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_survey_info.survey_question_id#">
                                                                </cfquery>
                                                                <cfquery name="get_survey_chapter_questions_options" datasource="#dsn#">
                                                                    SELECT
                                                                        SO.SURVEY_CHAPTER_ID,
                                                                        SO.SURVEY_QUESTION_ID,
                                                                        SO.SURVEY_OPTION_ID,
                                                                        SO.OPTION_POINT,
                                                                        SO.OPTION_NOTE,
                                                                        <!--- SO.SCORE_RATE1,
                                                                        SO.SCORE_RATE2, --->
                                                                        SO.OPTION_HEAD,
                                                                        '' OPTION_HEAD_RESULT,
                                                                        0 SURVEY_QUESTION_RESULT_ID,
                                                                        0 RESULT_NUMBER,
                                                                        SO.OPTION_IMAGE_PATH,
                                                                        SO.OPTION_DETAIL
                                                                    FROM
                                                                        SURVEY_OPTION SO
                                                                    WHERE
                                                                        <cfif len(survey_question_id) and len(get_opt_question_id.SURVEY_QUESTION_ID)>SO.SURVEY_QUESTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#survey_question_id#">AND</cfif>
                                                                        SO.SURVEY_CHAPTER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_survey_info.survey_chapter_id#">
                                                                    <cfif get_survey_info.question_type eq 3>
                                                                    ORDER BY
                                                                        RESULT_NUMBER
                                                                    </cfif>
                                                                </cfquery><!--- Doldurulan anketin seçili yada seçili olmayan tüm optionlarını getirir --->
                                                                <cfif get_survey_info.question_type eq 3><!--- Acik uclu soruda satir sayisinin artirilabilirligi icin kullaniliyor --->
                                                                    <cfset Record_ = get_survey_chapter_questions_options.recordcount>
                                                                    <input type="hidden" name="record_num_result_#survey_question_id#" id="record_num_result_#survey_question_id#" value=""><!--- #Record_# --->
                                                                </cfif>
                                                                <cfif len(get_survey_info.question_image_path)>
                                                                <tr>
                                                                    <table width="100%">
                                                                        <div class="form-group col col-6  col-md-6 col-xs-12">
                                                                            <div class="input-group col col-8 col-md-8 col-sm-8 col-xs-12">
                                                                                <cf_get_server_file output_file="helpdesk/#dir_seperator##get_survey_info.question_image_path#" output_server="1" output_type="0" image_width = "100" image_height="50">
                                                                            </div>
                                                                        </div>
                                                                    </table>
                                                                </tr>
                                                                </cfif>
                                                                <cfif get_survey_info.question_type neq 3 and get_survey_info.question_design eq 2 and (survey_chapter_id neq survey_chapter_id[currentrow-1] or len(get_survey_chapter_questions_options.survey_question_id))>
                                                                    <!--- options --->
    
                                                                    <tr valign="top">
                                                                        <td>&nbsp;</td>
                                                                        <td  style="text-align:center"><cfif get_survey_info.is_show_gd eq 1 or get_survey_info.question_gd eq 1>GD</cfif></td>
    
                                                                        <cfloop query="get_survey_chapter_questions_options">
                                                                            <td style="text-align:center">#get_survey_chapter_questions_options.option_head#</td>
                                                                        </cfloop>
                                                                    </tr>
                                                                        <cfif get_survey_main.type eq 8><!--- performans tipi ise secilen degerleri goster--->
                                                                            <cfif get_survey_main.is_manager_0 eq 1><label ><cf_get_lang dictionary_id ='57576.Çalışan'></label></cfif>
                                                                            <cfif get_survey_main.is_manager_3 eq 1><label ><cf_get_lang dictionary_id ='29908.Görüş Bildiren'></label></cfif>
                                                                            <cfif get_survey_main.is_manager_1 eq 1><label ><cf_get_lang dictionary_id ='35927.Birinci Amir'></label></cfif>
                                                                            <cfif get_survey_main.is_manager_4 eq 1><label ><cf_get_lang dictionary_id ='29909.Ortak Değerlendirme'></label></cfif>
                                                                            <cfif get_survey_main.is_manager_2 eq 1><label ><cf_get_lang dictionary_id ='35921.İkinci Amir'></label></cfif>
                                                                        </cfif>
                                                                    </div>
    
                                                                    <!--- //options --->
                                                                    <!--- tipi skorlu-yatay olan sorularda kullanılır; belirtilen skor sayısı kadar döndürülür --->
    
                                                                    <!--- //tipi skorlu-yatay olan sorularda kullanılır; belirtilen skor sayısı kadar döndürülür --->
                                                                </cfif>
                                                                <cfif  get_survey_info.question_design eq 2><!--- yatay --->
                                                                <tr>
                                                                    <!--- sorular --->
                                                                    <td>
                                                                        <cfset soru_sayisi = soru_sayisi+1>
                                                                        <div class="col col-12 col-md-12 col-sm-12 col-xs-12 bold">
                                                                            <cfif is_required eq 1>#question_current_row#. #question_head# *</cfif>
                                                                            <cfif len(question_detail)><i class="fa fa-question-circle" title="#question_detail#"></i></cfif>
                                                                        </div>
                                                                    </td>
                                                                    <!--- //sorular --->
                                                                    <td >
                                                                        <cfif get_survey_info.is_show_gd eq 1 or get_survey_info.question_gd eq 1><!--- soruda veya seçenekler de GD işaretli ise--->
                                                                            <cfquery name="get_gd" datasource="#dsn#" maxrows="1">
                                                                                SELECT GD_OPTION FROM SURVEY_QUESTION_RESULT WHERE GD_OPTION = 1 AND SURVEY_MAIN_RESULT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.result_id#"> AND SURVEY_QUESTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_survey_info.survey_question_id#"> ORDER BY SURVEY_QUESTION_RESULT_ID DESC
                                                                            </cfquery>
                                                                            <input type="radio" name="user_answer_#get_survey_info.survey_question_id#" id="user_answer_#get_survey_info.survey_question_id#" value="-1" <cfif get_gd.gd_option eq 1>checked</cfif>>
                                                                            <cfif get_gd.gd_option eq 1><!--- gözlem dışı seçildiğinde değerlendirmeye max puanı ata--->
                                                                                <cfset chapter_total_point = chapter_total_point+max_point_survey>
                                                                            </cfif>
                                                                        </cfif>
                                                                    </td>
                                                                    <cfloop query="get_survey_chapter_questions_options">
                                                                        <cfquery name="get_survey_question_result" datasource="#dsn#">
                                                                            SELECT SURVEY_OPTION_ID,OPTION_POINT,CHAPTER_DETAIL2,GD_OPTION FROM SURVEY_QUESTION_RESULT WHERE <cfif len(get_survey_info.survey_question_id)>SURVEY_QUESTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_survey_info.survey_question_id#"> AND<cfelse>SURVEY_QUESTION_ID IS NULL AND</cfif> SURVEY_OPTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#survey_option_id#"> AND SURVEY_MAIN_RESULT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.result_id#">
                                                                        </cfquery>
                                                                        <cfif get_survey_question_result.recordcount and len(get_survey_question_result.option_point)>
                                                                            <cfset chapter_total_point = chapter_total_point+get_survey_question_result.option_point>
                                                                        </cfif>
                                                                        <td style="text-align:center;width:65px;">
                                                                        <cfswitch expression="#get_survey_info.question_type#">
                                                                            <cfcase value="1"><!--- tekli soru tipi --->
                                                                                <input type="radio" name="user_answer_#get_survey_info.survey_question_id#" id="user_answer_#get_survey_info.survey_question_id#" value="#survey_option_id#" <cfif ListFind(get_survey_question_result.survey_option_id,survey_option_id,",")> checked</cfif>>
                                                                            </cfcase>
                                                                            <cfcase value="2"><!--- çoklu soru tipi --->
                                                                                <input type="checkbox" name="user_answer_#get_survey_info.survey_question_id#" id="user_answer_#get_survey_info.survey_question_id#" value="#survey_option_id#" <cfif ListFind(get_survey_question_result.survey_option_id,survey_option_id,",")> checked</cfif>>
                                                                            </cfcase>
                                                                            <!--- <cfcase value="4"><!--- skor --->
                                                                                <table width="100%" border="0">
                                                                                    <tr>
                                                                                        <cfloop from="#get_survey_chapter_questions_options.score_rate1#" to="#get_survey_chapter_questions_options.score_rate2#" index="score_rate">
                                                                                            <td><input type="radio" name="user_answer_#get_survey_info.survey_question_id#_#survey_option_id#" id="user_answer_#get_survey_info.survey_question_id#_#survey_option_id#" value="#score_rate#"<cfif ListFind(get_survey_question_result.option_point,score_rate,",")> checked</cfif>></td>
                                                                                        </cfloop>
                                                                                    </tr>
                                                                                </table>
                                                                            </cfcase> --->
                                                                        </cfswitch>
                                                                        </td>
                                                                    </cfloop>
                                                                    <!--- <cfif get_survey_chapter_questions_options.option_note eq 1>
                                                                        <cfquery name="get_survey_question_result1" datasource="#dsn#">
                                                                            SELECT OPTION_NOTE,CHAPTER_DETAIL2,GD_OPTION FROM SURVEY_QUESTION_RESULT WHERE <cfif len(get_survey_info.survey_question_id)>SURVEY_QUESTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_survey_info.survey_question_id#"> AND<cfelse>SURVEY_QUESTION_ID IS NULL AND</cfif> <!--- SURVEY_OPTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#survey_option_id#">  AND---> SURVEY_MAIN_RESULT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.result_id#"> AND SURVEY_OPTION_ID IS NOT NULL
                                                                        </cfquery>
                                                                        <td><input type="text" name="add_note_#get_survey_info.survey_question_id#" id="add_note_#get_survey_info.survey_question_id#" value="#get_survey_question_result1.option_note#"></td>
                                                                    </cfif> --->
                                                                    <td>&nbsp;</td>
                                                                    <cfif get_survey_main.is_manager_0 eq 1>
                                                                    <cfquery name="get_question_result_history_emp" datasource="#dsn#">
                                                                        SELECT
                                                                            SURVEY_OPTION_GD_EMP,
                                                                            (SELECT OPTION_HEAD FROM SURVEY_OPTION WHERE SURVEY_OPTION_ID = SURVEY_OPTION_ID_EMP) AS SURVEY_OPTION_ID_EMP_,
                                                                            SURVEY_OPTION_ID_EMP,
                                                                            SURVEY_OPTION_POINT_EMP
                                                                        FROM
                                                                            SURVEY_QUESTION_RESULT
                                                                        WHERE
                                                                            SURVEY_QUESTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_survey_info.survey_question_id#"> AND
                                                                            SURVEY_MAIN_RESULT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.result_id#"> AND
                                                                            (SURVEY_OPTION_ID_EMP IS NOT NULL OR SURVEY_OPTION_GD_EMP = 1) AND
                                                                            ((SURVEY_OPTION_ID_EMP IS NOT NULL AND SURVEY_OPTION_GD_EMP IS NOT NULL) OR (SURVEY_OPTION_ID_EMP IS NULL AND SURVEY_OPTION_GD_EMP IS NOT NULL))
                                                                        ORDER BY
                                                                            RECORD_DATE DESC
                                                                    </cfquery>
                                                                    <td style="text-align:center">
                                                                        <cfif get_question_result_history_emp.survey_option_gd_emp eq 1><b>GD</b><cfelse>#get_question_result_history_emp.SURVEY_OPTION_ID_EMP_#</cfif>
                                                                        <input type="hidden" name="survey_option_id_emp_#get_survey_info.survey_question_id#" id="survey_option_id_emp_#get_survey_info.survey_question_id#" value="#get_question_result_history_emp.SURVEY_OPTION_ID_EMP#">
                                                                        <input type="hidden" name="survey_option_point_emp_#get_survey_info.survey_question_id#" id="survey_option_point_emp_#get_survey_info.survey_question_id#" value="#get_question_result_history_emp.SURVEY_OPTION_POINT_EMP#">
                                                                        <input type="hidden" name="survey_option_gd_emp_#get_survey_info.survey_question_id#" id="survey_option_gd_emp_#get_survey_info.survey_question_id#" value="#get_question_result_history_emp.SURVEY_OPTION_GD_EMP#">
                                                                    </td>
                                                                    </cfif>
                                                                    <cfif get_survey_main.is_manager_3 eq 1>
                                                                    <cfquery name="get_result_history_manag3" datasource="#dsn#" maxrows="1">
                                                                        SELECT
                                                                            SURVEY_OPTION_GD_MANAGER3,
                                                                            (SELECT OPTION_HEAD FROM SURVEY_OPTION WHERE SURVEY_OPTION_ID = SURVEY_OPTION_ID_MANAGER3) AS SURVEY_OPTION_ID_MANAGER3_,
                                                                            SURVEY_OPTION_ID_MANAGER3,
                                                                            SURVEY_OPTION_POINT_MANAGER3
                                                                        FROM
                                                                            SURVEY_QUESTION_RESULT
                                                                        WHERE
                                                                            SURVEY_QUESTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_survey_info.survey_question_id#"> AND
                                                                            SURVEY_MAIN_RESULT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.result_id#"> AND
                                                                            (SURVEY_OPTION_POINT_MANAGER3 IS NOT NULL OR SURVEY_OPTION_GD_MANAGER3 = 1) AND
                                                                            ((SURVEY_OPTION_ID_MANAGER3 IS NOT NULL AND SURVEY_OPTION_GD_MANAGER3 IS NOT NULL) OR (SURVEY_OPTION_ID_MANAGER3 IS NULL AND SURVEY_OPTION_GD_MANAGER3 IS NOT NULL))
                                                                        ORDER BY
                                                                            RECORD_DATE DESC
                                                                    </cfquery>
                                                                    <td>
                                                                        <cfif get_result_history_manag3.survey_option_gd_manager3 eq 1><b>GD</b><cfelse>#get_result_history_manag3.SURVEY_OPTION_ID_MANAGER3_#</cfif>
                                                                        <input type="hidden" name="survey_option_id_manager3_#get_survey_info.survey_question_id#" id="survey_option_id_manager3_#get_survey_info.survey_question_id#" value="#get_result_history_manag3.SURVEY_OPTION_ID_MANAGER3#">
                                                                        <input type="hidden" name="survey_option_point_manager3_#get_survey_info.survey_question_id#" id="survey_option_point_manager3_#get_survey_info.survey_question_id#" value="#get_result_history_manag3.SURVEY_OPTION_POINT_MANAGER3#">
                                                                        <input type="hidden" name="survey_option_gd_manager3_#get_survey_info.survey_question_id#" id="survey_option_gd_manager3_#get_survey_info.survey_question_id#" value="#get_result_history_manag3.SURVEY_OPTION_GD_MANAGER3#">
                                                                    </td>
                                                                    </cfif>
                                                                    <cfif get_survey_main.is_manager_1 eq 1>
                                                                    <cfquery name="get_result_history_manag1" datasource="#dsn#" maxrows="1">
                                                                        SELECT
                                                                            SURVEY_OPTION_GD_MANAGER1,
                                                                            (SELECT OPTION_HEAD FROM SURVEY_OPTION WHERE SURVEY_OPTION_ID = SURVEY_OPTION_ID_MANAGER1) AS SURVEY_OPTION_ID_MANAGER1_,
                                                                            SURVEY_OPTION_ID_MANAGER1,
                                                                            SURVEY_OPTION_POINT_MANAGER1,
                                                                            SURVEY_QUESTION_ID,
                                                                            SURVEY_MAIN_RESULT_ID
                                                                        FROM
                                                                            SURVEY_QUESTION_RESULT
                                                                        WHERE
                                                                            SURVEY_QUESTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_survey_info.survey_question_id#"> AND
                                                                            SURVEY_MAIN_RESULT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.result_id#"> AND
                                                                            (SURVEY_OPTION_POINT_MANAGER1 IS NOT NULL  OR SURVEY_OPTION_GD_MANAGER1 = 1) AND
                                                                            ((SURVEY_OPTION_ID_MANAGER1 IS NOT NULL AND SURVEY_OPTION_GD_MANAGER1 IS NOT NULL) OR (SURVEY_OPTION_ID_MANAGER1 IS NULL AND SURVEY_OPTION_GD_MANAGER1 IS NOT NULL))
                                                                        ORDER BY
                                                                            RECORD_DATE DESC
                                                                    </cfquery>
                                                                    <td>
                                                                        <cfif get_result_history_manag1.survey_option_gd_manager1 eq 1><b>GD</b><cfelse>#get_result_history_manag1.SURVEY_OPTION_ID_MANAGER1_#</cfif>
                                                                        <input type="hidden" name="survey_option_id_manager1_#get_survey_info.survey_question_id#" id="survey_option_id_manager1_#get_survey_info.survey_question_id#" value="#get_result_history_manag1.SURVEY_OPTION_ID_MANAGER1#">
                                                                        <input type="hidden" name="survey_option_point_manager1_#get_survey_info.survey_question_id#" id="survey_option_point_manager1_#get_survey_info.survey_question_id#" value="#get_result_history_manag1.SURVEY_OPTION_POINT_MANAGER1#">
                                                                        <input type="hidden" name="survey_option_gd_manager1_#get_survey_info.survey_question_id#" id="survey_option_gd_manager1_#get_survey_info.survey_question_id#" value="#get_result_history_manag1.SURVEY_OPTION_GD_MANAGER1#">
                                                                    </td>
                                                                    </cfif>
                                                                    <cfif get_survey_main.is_manager_4 eq 1>
                                                                    <cfquery name="get_result_history_manag4" datasource="#dsn#" maxrows="1">
                                                                        SELECT
                                                                            SURVEY_OPTION_GD_MANAGER4,
                                                                            (SELECT OPTION_HEAD FROM SURVEY_OPTION WHERE SURVEY_OPTION_ID = SURVEY_OPTION_ID_MANAGER4) AS SURVEY_OPTION_ID_MANAGER4_,
                                                                            SURVEY_OPTION_ID_MANAGER4,
                                                                            SURVEY_OPTION_POINT_MANAGER4
                                                                        FROM
                                                                            SURVEY_QUESTION_RESULT
                                                                        WHERE
                                                                            SURVEY_QUESTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_survey_info.survey_question_id#"> AND
                                                                            SURVEY_MAIN_RESULT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.result_id#"> AND
                                                                            (SURVEY_OPTION_POINT_MANAGER4 IS NOT NULL  OR SURVEY_OPTION_GD_MANAGER4 = 1) AND
                                                                            ((SURVEY_OPTION_ID_MANAGER4 IS NOT NULL AND SURVEY_OPTION_GD_MANAGER4 IS NOT NULL) OR (SURVEY_OPTION_ID_MANAGER4 IS NULL AND SURVEY_OPTION_GD_MANAGER4 IS NOT NULL))
                                                                        ORDER BY
                                                                            RECORD_DATE DESC
                                                                    </cfquery>
                                                                    <td>
                                                                        <cfif get_result_history_manag4.survey_option_gd_manager4 eq 1><b>GD</b><cfelse>#get_result_history_manag4.SURVEY_OPTION_ID_MANAGER4_#</cfif>
                                                                        <input type="hidden" name="survey_option_id_manager4_#get_survey_info.survey_question_id#" id="survey_option_id_manager4_#get_survey_info.survey_question_id#" value="#get_result_history_manag4.SURVEY_OPTION_ID_MANAGER4#">
                                                                        <input type="hidden" name="survey_option_point_manager4_#get_survey_info.survey_question_id#" id="survey_option_point_manager4_#get_survey_info.survey_question_id#" value="#get_result_history_manag4.SURVEY_OPTION_POINT_MANAGER4#">
                                                                        <input type="hidden" name="survey_option_gd_manager4_#get_survey_info.survey_question_id#" id="survey_option_gd_manager4_#get_survey_info.survey_question_id#" value="#get_result_history_manag4.SURVEY_OPTION_GD_MANAGER4#">
                                                                    </td>
                                                                    </cfif>
                                                                    <cfif get_survey_main.is_manager_2 eq 1>
                                                                    <cfquery name="get_result_history_manag2" datasource="#dsn#" maxrows="1">
                                                                        SELECT
                                                                            SURVEY_OPTION_GD_MANAGER2,
                                                                            (SELECT OPTION_HEAD FROM SURVEY_OPTION WHERE SURVEY_OPTION_ID = SURVEY_OPTION_ID_MANAGER2) AS SURVEY_OPTION_ID_MANAGER2_,
                                                                            SURVEY_OPTION_ID_MANAGER2,
                                                                            SURVEY_OPTION_POINT_MANAGER2
                                                                        FROM
                                                                            SURVEY_QUESTION_RESULT
                                                                        WHERE
                                                                            SURVEY_QUESTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_survey_info.survey_question_id#"> AND
                                                                            SURVEY_MAIN_RESULT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.result_id#"> AND
                                                                            (SURVEY_OPTION_ID_MANAGER2 IS NOT NULL OR SURVEY_OPTION_GD_MANAGER2 = 1) AND
                                                                            ((SURVEY_OPTION_ID_MANAGER2 IS NOT NULL AND SURVEY_OPTION_GD_MANAGER2 IS NOT NULL) OR (SURVEY_OPTION_ID_MANAGER2 IS NULL AND SURVEY_OPTION_GD_MANAGER2 IS NOT NULL))
                                                                        ORDER BY
                                                                            RECORD_DATE DESC
                                                                    </cfquery>
                                                                    <div class="form-group col col-6  col-md-6 col-xs-12">
                                                                        <cfif get_result_history_manag2.survey_option_gd_manager2 eq 1><b>GD</b><cfelse>#get_result_history_manag2.SURVEY_OPTION_ID_MANAGER2_#</cfif>
                                                                        <input type="hidden" name="survey_option_id_manager2_#get_survey_info.survey_question_id#" id="survey_option_id_manager2_#get_survey_info.survey_question_id#" value="#get_result_history_manag2.SURVEY_OPTION_ID_MANAGER2#">
                                                                        <input type="hidden" name="survey_option_point_manager2_#get_survey_info.survey_question_id#" id="survey_option_point_manager2_#get_survey_info.survey_question_id#" value="#get_result_history_manag2.SURVEY_OPTION_POINT_MANAGER2#">
                                                                        <input type="hidden" name="survey_option_gd_manager2_#get_survey_info.survey_question_id#" id="survey_option_gd_manager2_#get_survey_info.survey_question_id#" value="#get_result_history_manag2.SURVEY_OPTION_GD_MANAGER2#">
                                                                    </div>
                                                                    </cfif>
                                                                </tr>
                                                                <cfelse><!--- dikey --->
                                                                    <!--- sorular --->
                                                                <tr>
                                                                    <td>
                                                                        <div class="col col-12 col-md-12 col-sm-12 col-xs-12 bold">
                                                                            <cfif is_required eq 1>#question_current_row#. #question_head# *</cfif>
                                                                            <cfif len(question_detail)><i class="fa fa-question-circle" title="#question_detail#"></i></cfif>
                                                                        </div>
                                                                    </td>
                                                                </tr>
                                                                    <!--- //sorular --->
                                                                    <cfloop query="get_survey_chapter_questions_options">
                                                                        <cfquery name="get_survey_question_result" datasource="#dsn#">
                                                                            SELECT SURVEY_OPTION_ID,OPTION_POINT,CHAPTER_DETAIL2,GD_OPTION FROM SURVEY_QUESTION_RESULT WHERE <cfif len(get_survey_info.survey_question_id)>SURVEY_QUESTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_survey_info.survey_question_id#"> AND<cfelse>SURVEY_QUESTION_ID IS NULL AND</cfif> SURVEY_OPTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#survey_option_id#"> AND SURVEY_MAIN_RESULT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.result_id#">
                                                                        </cfquery>
    
                                                                        <cfswitch expression="#get_survey_info.question_type#">
                                                                            <cfcase value="1"><!--- tekli soru tipi --->
                                                                                <tr>
                                                                                    <td>
                                                                                        <div class="form-group">
                                                                                            <input type="radio" name="user_answer_#get_survey_info.survey_question_id#" id="user_answer_#get_survey_info.survey_question_id#" value="#survey_option_id#" <cfif ListFind(get_survey_question_result.survey_option_id,survey_option_id,",")> checked</cfif>>
                                                                                            <label>#get_survey_chapter_questions_options.option_head#</label>
                                                                                        </div>
                                                                                    </td>
                                                                                </tr>
                                                                            </cfcase>
                                                                            <cfcase value="2"><!--- çoklu soru tipi --->
                                                                                <tr>
                                                                                    <td>
                                                                                        <div class="form-group">
                                                                                            <input type="checkbox" name="user_answer_#get_survey_info.survey_question_id#" id="user_answer_#get_survey_info.survey_question_id#" value="#survey_option_id#"<cfif ListFind(get_survey_question_result.survey_option_id,survey_option_id,",")> checked</cfif>>
                                                                                            <label>#get_survey_chapter_questions_options.option_head#</label>
                                                                                        </div>
                                                                                    </td>
                                                                                </tr>
                                                                            </cfcase>
                                                                        </cfswitch>
    
                                                                    </cfloop>
                                                                    <!--- <cfif get_survey_chapter_questions_options.option_note eq 1>
                                                                    <tr>
                                                                        <cfquery name="get_survey_question_result1" datasource="#dsn#">
                                                                            SELECT OPTION_NOTE,CHAPTER_DETAIL2,GD_OPTION FROM SURVEY_QUESTION_RESULT WHERE <cfif len(get_survey_info.survey_question_id)>SURVEY_QUESTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_survey_info.survey_question_id#"> AND<cfelse>SURVEY_QUESTION_ID IS NULL AND</cfif> SURVEY_OPTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_survey_chapter_questions_options.survey_option_id#"> AND SURVEY_MAIN_RESULT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.result_id#"> AND SURVEY_OPTION_ID IS NOT NULL
                                                                        </cfquery>
                                                                        <td><input type="text" name="add_note_#get_survey_info.survey_question_id#" id="add_note_#get_survey_info.survey_question_id#" value="#get_survey_question_result1.option_note#"></td>
                                                                    </tr>
                                                                    </cfif> --->
                                                                </cfif>
                                                                <cfswitch expression="#get_survey_info.question_type#">
                                                                    <cfcase value="3"><!--- açık uçlu --->
                                                                    <tr>
                                                                        <table border="0" id="add_new_option_#get_survey_info.survey_question_id#">
                                                                            <cfset sira = 0>
                                                                            <cfloop query="get_survey_chapter_questions_options">
                                                                                <cfset sira = sira + 1>
                                                                                <cfif sira mod 2 eq 1><tr></cfif>
                                                                                    <cfquery name="get_survey_question_result" datasource="#dsn#">
                                                                                        SELECT SURVEY_OPTION_ID,OPTION_POINT,OPTION_HEAD,CHAPTER_DETAIL2,GD_OPTION FROM SURVEY_QUESTION_RESULT WHERE <cfif len(get_survey_info.survey_question_id)>SURVEY_QUESTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_survey_info.survey_question_id#"> AND<cfelse>SURVEY_QUESTION_ID IS NULL AND</cfif> SURVEY_OPTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#survey_option_id#"> AND SURVEY_MAIN_RESULT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.result_id#">
                                                                                    </cfquery>
                                                                                    <td class="bold">#OPTION_HEAD#</td>
                                                                                    <td><input type="text" name="user_answer_#get_survey_info.survey_question_id#_#survey_option_id#" id="user_answer_#get_survey_info.survey_question_id#_#survey_option_id#" value="#get_survey_question_result.OPTION_HEAD#"></td>
                                                                                    <td width="50" nowrap></td>
                                                                                <cfif sira mod 2 eq 0 or sira eq get_survey_chapter_questions_options.recordcount></tr></cfif>
                                                                            </cfloop>
                                                                        </table>
                                                                    </tr>
                                                                    </cfcase>
                                                                    <cfcase value="5"><!--- paragraf metin--->
                                                                    <tr>
                                                                        <table width="100%" border="0" id="add_new_option_#get_survey_info.survey_question_id#">
                                                                            <cfloop query="get_survey_chapter_questions_options">
                                                                                <cfquery name="get_survey_question_result" datasource="#dsn#">
                                                                                    SELECT
                                                                                        SURVEY_OPTION_ID,
                                                                                        OPTION_POINT,
                                                                                        OPTION_HEAD,
                                                                                        CHAPTER_DETAIL2,
                                                                                        GD_OPTION,
                                                                                        OPTION_HEAD_EMP,
                                                                                        OPTION_HEAD_MANAGER1,
                                                                                        OPTION_HEAD_MANAGER2,
                                                                                        OPTION_HEAD_MANAGER3,
                                                                                        OPTION_HEAD_MANAGER4
                                                                                    FROM
                                                                                        SURVEY_QUESTION_RESULT WHERE <cfif len(get_survey_info.survey_question_id)>SURVEY_QUESTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_survey_info.survey_question_id#"> AND<cfelse>SURVEY_QUESTION_ID IS NULL AND</cfif> SURVEY_OPTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#survey_option_id#"> AND SURVEY_MAIN_RESULT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.result_id#">
                                                                                </cfquery>
                                                                                <div class="form-group col col-6  col-md-6 col-xs-12" id="add_new_option_row_#get_survey_info.survey_question_id#_#currentrow#">
                                                                                    <label class="bold" valign="top">#OPTION_HEAD#</label>
                                                                                    <textarea name="user_answer_#get_survey_info.survey_question_id#_#survey_option_id#" id="user_answer_#get_survey_info.survey_question_id#_#survey_option_id#" style="width:400px;height:50px;">#get_survey_question_result.option_head#</textarea>
                                                                                    <input type="hidden" name="user_answer_ex_#get_survey_info.survey_question_id#_#survey_option_id#" id="user_answer_ex_#get_survey_info.survey_question_id#_#survey_option_id#" value="#get_survey_question_result.option_head#">
                                                                                </div>
                                                                                <cfif len(get_survey_question_result.OPTION_HEAD_EMP)>
                                                                                    <div class="form-group col col-6  col-md-6 col-xs-12">
                                                                                        <label class="bold"><cf_get_lang dictionary_id='30368.Çalışan'></label>
                                                                                        <label>#get_survey_question_result.OPTION_HEAD_EMP#</label>
                                                                                        <input type="hidden" name="user_answer_ex_emp_#get_survey_info.survey_question_id#_#survey_option_id#" id="user_answer_ex_emp_#get_survey_info.survey_question_id#_#survey_option_id#" value="#get_survey_question_result.OPTION_HEAD_EMP#">
                                                                                    </div>
                                                                                </cfif>
                                                                                <cfif len(get_survey_question_result.OPTION_HEAD_MANAGER3)>
                                                                                <div class="form-group col col-6  col-md-6 col-xs-12">
                                                                                    <label class="bold"><cf_get_lang dictionary_id='29908.Görüş Bildiren'></label>
                                                                                    <label>#get_survey_question_result.OPTION_HEAD_MANAGER3#</label>
                                                                                    <input type="hidden" name="user_answer_ex3_#get_survey_info.survey_question_id#_#survey_option_id#" id="user_answer_ex3_#get_survey_info.survey_question_id#_#survey_option_id#" value="#get_survey_question_result.OPTION_HEAD_MANAGER3#">
                                                                                </div>
                                                                                </cfif>
                                                                                <cfif len(get_survey_question_result.OPTION_HEAD_MANAGER1)>
                                                                                <div class="form-group col col-6  col-md-6 col-xs-12">
                                                                                    <label class="bold"><cf_get_lang dictionary_id='35927.Birinci Amir'></label>
                                                                                    <label>#get_survey_question_result.OPTION_HEAD_MANAGER1#</label>
                                                                                    <input type="hidden" name="user_answer_ex1_#get_survey_info.survey_question_id#_#survey_option_id#" id="user_answer_ex2_#get_survey_info.survey_question_id#_#survey_option_id#" value="#get_survey_question_result.OPTION_HEAD_MANAGER1#">
                                                                                </div>
                                                                                </cfif>
                                                                                <cfif len(get_survey_question_result.OPTION_HEAD_MANAGER2)>
                                                                                <div class="form-group col col-6  col-md-6 col-xs-12">
                                                                                    <label class="bold"><cf_get_lang dictionary_id='35921.İkinci Amir'></label>
                                                                                    <label>#get_survey_question_result.OPTION_HEAD_MANAGER2#</label>
                                                                                    <input type="hidden" name="user_answer_ex2_#get_survey_info.survey_question_id#_#survey_option_id#" id="user_answer_ex2_#get_survey_info.survey_question_id#_#survey_option_id#" value="#get_survey_question_result.OPTION_HEAD_MANAGER2#">
                                                                                </div>
                                                                                </cfif>
                                                                                <cfif len(get_survey_question_result.OPTION_HEAD_MANAGER4)>
                                                                                <div class="form-group col col-6  col-md-6 col-xs-12">
                                                                                    <label class="bold"><cf_get_lang dictionary_id='29909.Ortak Değerlendirme'></label>
                                                                                    <label>#get_survey_question_result.OPTION_HEAD_MANAGER4#</label>
                                                                                    <input type="hidden" name="user_answer_ex4_#get_survey_info.survey_question_id#_#survey_option_id#" id="user_answer_ex4_#get_survey_info.survey_question_id#_#survey_option_id#" value="#get_survey_question_result.OPTION_HEAD_MANAGER4#">
                                                                                </div>
                                                                                </cfif>
                                                                                <tr>
                                                                                    <td>&nbsp;</td>
                                                                                </tr>
                                                                                </cfloop>
                                                                        </table>
                                                                    </tr>
                                                                    </cfcase>
                                                                </cfswitch>
                                                                <cfset question_current_row = question_current_row + 1>
                                                            </cfoutput>
                                                            </table>
                                        </td>
                                    </tr>
                                    <cfquery name="get_survey_question_result_det" datasource="#dsn#">
                                        SELECT CHAPTER_DETAIL2 FROM SURVEY_QUESTION_RESULT WHERE <cfif len(get_survey_info.survey_question_id)>SURVEY_QUESTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_survey_info.survey_question_id#"> AND<cfelse>SURVEY_QUESTION_ID IS NULL AND</cfif>  SURVEY_MAIN_RESULT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.result_id#"> AND CHAPTER_DETAIL2 IS NOT NULL
                                    </cfquery>
                                    <cfif get_survey_info.is_chapter_detail2 eq 1>
                                        <tr>
                                            <table>
                                                <cfset chapter_detail_expl = get_survey_question_result_det.CHAPTER_DETAIL2>
                                                <cfif get_main_result_info.action_type eq 8>
                                                    <cfquery name="get_chapter_result" datasource="#dsn#">
                                                        SELECT EXPLANATION,EMP_EXPL,MANAGER1_EXPL,MANAGER2_EXPL,MANAGER3_EXPL,MANAGER4_EXPL FROM SURVEY_CHAPTER_RESULT WHERE SURVEY_MAIN_RESULT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.result_id#"> AND SURVEY_CHAPTER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#survey_chapter_id#">
                                                    </cfquery>
                                                    <cfif get_survey_main.is_manager_0 is 1 and session.ep.userid eq get_main_result_info.action_id><!--- calisan kendi aciklamasini gorecek--->
                                                        <cfset chapter_detail_expl = get_chapter_result.EMP_EXPL>
                                                    <cfelseif get_survey_main.is_manager_3 eq 1 and session.ep.userid eq get_main_result_info.manager3_emp_id>
                                                        <cfset chapter_detail_expl = get_chapter_result.MANAGER3_EXPL>
                                                    <cfelseif get_survey_main.is_manager_1 eq 1 and session.ep.userid eq get_main_result_info.manager1_emp_id>
                                                        <cfset chapter_detail_expl = get_chapter_result.MANAGER1_EXPL>
                                                    <cfelseif get_survey_main.is_manager_4 eq 1 and get_main_result_info.valid1 eq 1 and session.ep.userid eq get_main_result_info.manager1_emp_id>
                                                        <cfset chapter_detail_expl = get_chapter_result.MANAGER4_EXPL>
                                                    <cfelseif get_survey_main.is_manager_2 eq 1 and session.ep.userid eq get_main_result_info.manager2_emp_id>
                                                        <cfset chapter_detail_expl = get_chapter_result.MANAGER2_EXPL>
                                                    <cfelse>
                                                        <cfset chapter_detail_expl = get_chapter_result.EXPLANATION>
                                                    </cfif>
                                                </cfif>
                                                <div class="form-group col col-6  col-md-6 col-xs-12">
                                                    <label class="bold"><!--- <b><cf_get_lang_main no='217.Açıklama'> :</b> ---> #get_survey_info.survey_chapter_detail2#</label>
                                                    <textarea name="survey_chapter_detail2_#get_survey_info.survey_chapter_id#" id="survey_chapter_detail2_#get_survey_info.survey_chapter_id#" style="width:400px;height:50px;">#chapter_detail_expl#</textarea>
                                                </div>
                                                <cfif get_main_result_info.action_type eq 8>
                                                    <cfif get_chapter_result.recordcount>
                                                        <cfif len(get_chapter_result.emp_expl)>
                                                            <div class="form-group col col-6  col-md-6 col-xs-12">
                                                                <label class="bold"><cf_get_lang dictionary_id='56758.Çalışan Açıklama'></label>
                                                                <label>&nbsp;#get_chapter_result.EMP_EXPL#</label>
                                                            </div>
                                                        </cfif>
                                                        <cfif len(get_chapter_result.MANAGER3_EXPL)>
                                                            <div class="form-group col col-6  col-md-6 col-xs-12">
                                                                <label class="bold"><cf_get_lang dictionary_id ='56723.Görüş Bildiren Açıklama'></label>
                                                                <label>&nbsp;#get_chapter_result.MANAGER3_EXPL#</label>
                                                            </div>
                                                        </cfif>
                                                        <cfif len(get_chapter_result.MANAGER1_EXPL)>
                                                            <div class="form-group col col-6  col-md-6 col-xs-12">
                                                                <label class="bold"><cf_get_lang dictionary_id='35927.Birinci Amir'> <cf_get_lang dictionary_id='57629.Açıklama'></label>
                                                                <label>&nbsp;#get_chapter_result.MANAGER1_EXPL#</label>
                                                            </div>
                                                        </cfif>
                                                        <cfif len(get_chapter_result.MANAGER4_EXPL)>
                                                            <div class="form-group col col-6  col-md-6 col-xs-12">
                                                                <label class="bold"><cf_get_lang dictionary_id='29909.Ortak Değerlendirme'> <cf_get_lang dictionary_id='57629.Açıklama'></label>
                                                                <label>&nbsp;#get_chapter_result.MANAGER4_EXPL#</label>
                                                            </div>
                                                        </cfif>
                                                        <cfif len(get_chapter_result.MANAGER2_EXPL)>
                                                            <div class="form-group col col-6  col-md-6 col-xs-12">
                                                                <label class="bold"><cf_get_lang dictionary_id='35921.İkinci Amir'> <cf_get_lang dictionary_id='57629.Açıklama'></label>
                                                                <label>&nbsp;#get_chapter_result.MANAGER2_EXPL#</label>
                                                            </div>
                                                        </cfif>
                                                    </cfif>
                                                </cfif>
                                            </table>
                                        </tr>
                                    </cfif>
                                    <cfset chapter_current_row = chapter_current_row + 1>
                                    <cfif survey_chapter_id neq survey_chapter_id[currentrow-1]>
                                        <cfif len(chapter_weight) and (soru_sayisi gt 0) and len(max_point_survey) and (max_point_survey*soru_sayisi) gt 0>
                                            <cfset all_chapter_total_point = all_chapter_total_point+((chapter_total_point*chapter_weight)/(max_point_survey*soru_sayisi))>
                                        </cfif>
                                    </cfif>
                            </table>
                            
                            </cfoutput>
                        </tr>
                    </div>
                        <div class="col col-12">
                            <cfoutput query="get_main_result_info">
                                <cfif not (isdefined("session.pp") or isdefined("session.ww"))>
                                <tr>
                                    <cfif not listfind('14',get_survey_main.type)>
                                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='29883.Form Bilgileri'></cfsavecontent>
                                    <cf_seperator id='detail' title="#message#" is_closed="0">
                                    </cfif>
                                    <label></label>
                                        <div class="col col-6 col-md-6 col-sm-6 col-xs-12" id="detail" style="<cfif listfind('14',get_survey_main.type)>display:none;</cfif>">
    
                                            <div class="form-group">
                                                <cfif len(get_survey_main.total_score)>
                                                    <label class="bold"><cf_get_lang dictionary_id='58909.Max'> <cf_get_lang dictionary_id='58984.Puan'>:</label>
                                                    <label>#get_survey_main.total_score#&nbsp;&nbsp;</label>
                                                </cfif>
                                                <cfif len(get_survey_main.average_score)>
                                                    <label class="bold"><cf_get_lang dictionary_id='29774.uygunluk sınırı'>:</label>
                                                    <label>#get_survey_main.average_score#</label>
                                                </cfif>
                                            </div>
                                            <div class="form-group">
                                                <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58984.Puan'>:</label>
                                                <label class="input-group col col-8 col-md-8 col-sm-8 col-xs-12">
                                                    <cfset user_point = 0>
                                                    <cfif get_survey_main.type eq 8><!--- performans değerlendirme ise--->
                                                        <cfif not len(get_main_result_info.score_result_emp)><cfset get_main_result_info.score_result_emp = 0></cfif>
                                                        <cfif not len(get_main_result_info.score_result_manager1)><cfset get_main_result_info.score_result_manager1 = 0></cfif>
                                                        <cfif not len(get_main_result_info.score_result_manager2)><cfset get_main_result_info.score_result_manager2 = 0></cfif>
                                                        <cfif not len(get_main_result_info.score_result_manager3)><cfset get_main_result_info.score_result_manager3 = 0></cfif>
                                                        <cfif not len(get_main_result_info.score_result_manager4)><cfset get_main_result_info.score_result_manager4 = 0></cfif>
                                                        <!--- çalışan--->
                                                        <cfif get_survey_main.is_manager_0 is 1 and len(get_survey_main.emp_quiz_weight)>
                                                            <cfset user_point = user_point+(get_main_result_info.score_result_emp * get_survey_main.emp_quiz_weight)>
                                                        </cfif>
                                                        <!--- görüş bildiren--->
                                                        <cfif get_survey_main.is_manager_3 is 1 and len(get_survey_main.manager_quiz_weight_3)>
                                                            <cfset user_point = user_point+(get_main_result_info.score_result_manager3 * get_survey_main.manager_quiz_weight_3)>
                                                        </cfif>
                                                        <!--- 1.amir--->
                                                        <cfif get_survey_main.is_manager_1 is 1 and len(get_survey_main.manager_quiz_weight_1)>
                                                            <cfset user_point = user_point+(get_main_result_info.score_result_manager1 * get_survey_main.manager_quiz_weight_1)>
                                                        </cfif>
                                                        <!--- ortak değerlendirme--->
                                                        <cfif get_survey_main.is_manager_4 is 1 and len(get_survey_main.manager_quiz_weight_4)>
                                                            <cfset user_point = user_point+(get_main_result_info.score_result_manager4 * get_survey_main.manager_quiz_weight_4)>
                                                        </cfif>
                                                        <!--- 2.amir--->
                                                        <cfif get_survey_main.is_manager_2 is 1 and len(get_survey_main.manager_quiz_weight_2)>
                                                            <cfset user_point = user_point+(get_main_result_info.score_result_manager2 * get_survey_main.manager_quiz_weight_2)>
                                                        </cfif>
                                                        <!--- <cfset user_point_ = ((get_main_result_info.score_result_emp * get_survey_main.emp_quiz_weight)+(get_main_result_info.score_result_manager3*get_survey_main.manager_quiz_weight_3)+(get_main_result_info.score_result_manager2*get_survey_main.manager_quiz_weight_2)+(get_main_result_info.score_result_manager1*get_survey_main.manager_quiz_weight_1)+(get_main_result_info.score_result_manager4*get_survey_main.manager_quiz_weight_4))/100> --->
                                                        <cfset user_point_ = user_point/100>
                                                        #TlFormat(user_point_)# / 100
                                                    <cfelse>
                                                        <cfif len(get_main_result_info.score_result)>
                                                            <!--- #TlFormat((all_chapter_total_point*get_survey_main.total_score)/100)# --->
                                                            #TlFormat(get_main_result_info.score_result)#
                                                            <input type="hidden" name="total_point" id="total_point" value="#get_main_result_info.score_result#">
                                                        <cfelse>
                                                            <input type="hidden" name="total_point" id="total_point" value="0">
                                                        </cfif>
                                                    </cfif>
                                                </label>
                                            </div>
                                            <cfif get_main_result_info.action_type eq 8>
                                                <cfif len(get_main_result_info.score_result_emp) and get_survey_main.is_manager_0 is 1>
                                                    <div class="form-group">
                                                        <label class="col col-4bold"><cf_get_lang dictionary_id='57576.Çalışan'></label>
                                                        <label>#TlFormat(get_main_result_info.score_result_emp)#</label>
                                                    </div>
                                                </cfif>
                                                <cfif len(get_main_result_info.score_result_manager3) and get_survey_main.is_manager_3 is 1>
                                                    <div class="form-group">
                                                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='29908.Görüş Bildiren'></label>
                                                        <label>#TlFormat(get_main_result_info.score_result_manager3)#</label>
                                                    </div>
                                                </cfif>
                                                <cfif len(get_main_result_info.score_result_manager1) and get_survey_main.is_manager_1 is 1>
                                                    <div class="form-group">
                                                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='35927.Birinci Amir'></label>
                                                        <label>#TlFormat(get_main_result_info.score_result_manager1)#</label>
                                                    </div>
                                                </cfif>
                                                <cfif len(get_main_result_info.score_result_manager4) and get_survey_main.is_manager_4 is 1>
                                                    <div class="form-group">
                                                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='29909.Ortak Değerlendirme'></label>
                                                        <label>#TlFormat(get_main_result_info.score_result_manager4)#</label>
                                                    </div>
                                                </cfif>
                                                <cfif len(get_main_result_info.score_result_manager2) and get_survey_main.is_manager_2 eq 1>
                                                    <div class="form-group">
                                                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='35921.İkinci Amir'></label>
                                                        <label>#TlFormat(get_main_result_info.score_result_manager2)#</label>
                                                    </div>
                                                </cfif>
                                            </cfif>
    
                                            <cfif listfind('6,8',get_survey_main.type)>
                                                <input type="hidden" name="amir_onay" id="amir_onay" value="#get_main_result_info.valid1#">
                                                <input type="hidden" name="valid" id="valid" value="#get_main_result_info.valid#"><!--- calisan onay --->
                                                <input type="hidden" name="valid1" id="valid1" value="#get_main_result_info.valid1#"><!--- 1.amir onay --->
                                                <input type="hidden" name="valid2" id="valid2" value="#get_main_result_info.valid2#"><!--- 2.amir onay --->
                                                <input type="hidden" name="valid3" id="valid3" value="#get_main_result_info.valid3#"><!--- gorus bildiren onay --->
                                                <input type="hidden" name="valid4" id="valid4" value="#get_main_result_info.valid4#"><!--- ortak degerlendirme onay --->
                                                <div class="form-group">
                                                    <label class="col col-4 col-md-4 col-sm-4 col-xs-12" ><cf_get_lang dictionary_id='57576.Çalışan'></label>
                                                    <div class="input-group col col-8 col-md-8 col-sm-8 col-xs-12">
                                                        #get_emp_info(get_main_result_info.action_id,0,0)#
                                                        <input type="hidden" name="EMP_ID" id="EMP_ID" value="#get_main_result_info.action_id#">
                                                        <cfif get_survey_main.is_manager_0 eq 1><!--- Calisan Gelmemesi ile Ilgili Eklendi --->
                                                            <input type="hidden" name="MANAGER_0_EMP_ID" id="MANAGER_0_EMP_ID" value="#get_main_result_info.action_id#">
                                                        </cfif>
                                                    </div>
                                                </div>
                                                <div class="form-group">
                                                    <cfif get_survey_main.is_manager_3 eq 1>
                                                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id ='29908.Görüş Bildiren'></label>
                                                        <div class="input-group col col-8 col-md-8 col-sm-8 col-xs-12">
                                                            <input name="MANAGER_3_POS_NAME" type="text" id="MANAGER_3_POS_NAME" style="width:150px;" value="#get_emp_info(manager3_emp_id,0,0,0)#">
                                                            <input type="hidden" name="MANAGER_3_POS" id="MANAGER_3_POS" value="#manager3_pos#">
                                                            <input type="hidden" name="MANAGER_3_EMP_ID" id="MANAGER_3_EMP_ID" value="#manager3_emp_id#">
                                                            <!--- <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=hr.popup_list_positions&field_emp_name=survey_main_result.MANAGER_3_POS_NAME&field_emp_id=survey_main_result.MANAGER_3_EMP_ID&field_code=survey_main_result.MANAGER_3_POS','list');"><img src="/images/plus_thin.gif" border="0"></a>  --->
                                                        </div>
                                                    </cfif>
                                                </div>
                                            </cfif>
                                            <cfif fuseaction contains 'settings'>
                                                <div class="form-group">
                                                    <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57658.Üye'></label>
                                                    <div class="input-group col col-8 col-md-8 col-sm-8 col-xs-12">
                                                        <cfif len(partner_id)>
                                                            <cfset company_name=get_par_info(get_main_result_info.partner_id,0,1,0)>
                                                            <cfset partner_name=get_par_info(get_main_result_info.partner_id,0,-1,0)>
                                                        <cfelseif len(consumer_id)>
                                                            <cfquery name="GET_CONSUMER_NAME" datasource="#dsn#">
                                                                SELECT COMPANY FROM CONSUMER WHERE CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#consumer_id#">
                                                            </cfquery>
                                                            <cfset company_name=get_consumer_name.COMPANY>
                                                            <cfset partner_name=get_cons_info(consumer_id,0,0,0)>
                                                        </cfif>
                                                        <cfset str_linke_ait="field_partner=survey_main_result.partner_id&field_consumer=survey_main_result.consumer_id&field_comp_id=survey_main_result.company_id&field_comp_name=survey_main_result.company_name&field_name=survey_main_result.member_name">
                                                        <input type="text" name="company_name" id="company_name" value="<cfif isdefined('company_name') and len(company_name)>#company_name#</cfif>" style="width:150px;" onFocus="AutoComplete_Create('member_name','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete',''1,2,3',0,0,0','CONSUMER_ID,COMPANY_ID,PARTNER_ID','consumer_id,company_id,apply_id','','3','250');">
                                                        <span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('#request.self#?fuseaction=objects.popup_list_pars&<cfoutput>#str_linke_ait#</cfoutput>&select_list=2,3&keyword='+encodeURIComponent(document.survey_main_result.member_name.value),'list');"></span>
                                                    </div>
                                                </div>
                                                <div class="form-group">
                                                    <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='29804.Uygulayan'></label>
                                                    <div class="input-group col col-8 col-md-8 col-sm-8 col-xs-12">
                                                        <input type="hidden" name="consumer_id" id="consumer_id" value="#get_main_result_info.consumer_id#">
                                                        <input type="hidden" name="company_id" id="company_id" value="#get_main_result_info.company_id#">
                                                        <input type="hidden" name="partner_id" id="partner_id" value="#get_main_result_info.partner_id#">
                                                        <input type="text" name="member_name" id="member_name" value="<cfif isdefined('partner_name') and len(partner_name)>#partner_name#</cfif>" style="width:150px;" readonly="" />
                                                    </div>
                                                </div>
                                                <div class="form-group">
                                                    <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57576.Çalışan'></label>
                                                    <div class="input-group col col-8 col-md-8 col-sm-8 col-xs-12">
                                                        <input type="hidden" name="employee_id" id="employee_id" value="#get_main_result_info.emp_id#">
                                                        <input type="text" name="employee" id="employee" value="#get_emp_info(get_main_result_info.emp_id,0,0)#" style="width:150px;" onFocus="AutoComplete_Create('employee','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','employee_id','','3','135');" >
                                                        <span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=survey_main_result.employee_id&field_name=survey_main_result.employee&select_list=1&is_form_submitted=1&keyword='+encodeURIComponent(document.survey_main_result.employee.value),'list');" ></span>
                                                    </div>
                                                </div>
                                            </cfif>
                                            <div class="form-group">
                                                <cfif listfind('6,8',get_survey_main.type)>
                                                    <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58472.Dönem'></label>
                                                    <div class="input-group col col-8 col-md-8 col-sm-8 col-xs-12">
                                                        <cfinput type="text" name="start_date" id="start_date" validate="#validate_style#" value="#dateformat(get_main_result_info.start_date,dateformat_style)#" style="width:65px;">
                                                        <span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="start_date"></span>
                                                        <span class="input-group-addon no-bg"></span>
                                                        <cfinput type="text" name="finish_date" id="finish_date" validate="#validate_style#" value="#dateformat(get_main_result_info.finish_date,dateformat_style)#" style="width:65px;">
                                                        <span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="finish_date"></span>
                                                    </div>
                                                <cfelse>
                                                    <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57742.Tarih'></label>
                                                    <div class="input-group col col-8 col-md-8 col-sm-8 col-xs-12">
                                                        <cfinput type="text" name="start_date" value="#dateformat(get_main_result_info.start_date,dateformat_style)#" validate="#validate_style#" maxlength="10" style="width:65px;">
                                                        <span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="start_date"></span>
                                                    </div>
                                                </cfif>
                                            </div>
                                                <div class="form-group" id="process_stage">
                                                    <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id="58859.Süreç"></label>
                                                    <div class="input-group col col-8 col-md-8 col-sm-8 col-xs-12">
                                                        <cf_workcube_process is_upd='0' process_cat_width='130' is_detail='1' select_value="#get_main_result_info.process_row_id#">
                                                    </div>
                                                </div>
                                            <div class="form-group" id="item-company">
                                                <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='60002.Bilgiyi Veren Şirket'><!--- <cf_get_lang_main no='107.Cari Hesap'> ---></label>
                                                <div class="input-group col col-8 col-md-8 col-sm-8 col-xs-12">
                                                    <input type="text" name="company" id="company" value="<cfif len(company_id)>#get_par_info(company_id,1,1,0)#<cfelseif len(consumer_id)>#get_cons_info(consumer_id,0,0,0)#</cfif>" readonly>
                                                </div>
                                            </div>
                                            <div class="form-group" id="item-member_name">
                                                <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='60153.Bilgiyi Veren'><!--- <cf_get_lang_main no='166.Yetkili'> ---></label>
                                                <div class="input-group col col-8 col-md-8 col-sm-8 col-xs-12">
                                                    <input type="text" name="member_name" id="member_name" value="<cfif len(partner_id)>#get_par_info(partner_id,0,-1,0)#<cfelseif len(consumer_id)>#get_cons_info(consumer_id,0,0,0)#</cfif>" readonly>
                                                </div>
                                            </div>
                                            <div class="form-group require" id="item-order_employee">
                                                <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='33529.Bilgiyi Alan'><!--- <cf_get_lang no='357.Satış Çalışanı'> ---></label>
                                                <div class="input-group col col-8 col-md-8 col-sm-8 col-xs-12">
                                                    <input type="hidden" name="employee_order_id" id="employee_order_id" value="#emp_id#">
                                                    <input type="text" name="employee_order" id="employee_order" value="#get_emp_info(emp_id,0,0)#" readonly>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='29805.Yorum'></label>
                                                <div class="input-group col col-8 col-md-8 col-sm-8 col-xs-12"><textarea name="comment" id="comment">#comment#</textarea></div>
                                            </div>
                                            <cfif get_main_result_info.action_type eq 8><!--- performans formu ise amir bilgileri gelsin--->
                                            <div class="form-group">
                                                <cfif get_survey_main.is_manager_1 eq 1>
                                                <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='35927.Birinci Amir'></label>
                                                <div class="input-group col col-8 col-md-8 col-sm-8 col-xs-12">
                                                    <input name="MANAGER_1_POS_NAME" type="text" id="MANAGER_1_POS_NAME" style="width:150px;" value="#get_emp_info(get_main_result_info.manager1_emp_id,0,0,0)#">
                                                    <!---
                                                        cfform altında da var.
                                                        <input type="hidden" name="MANAGER_1_POS" id="MANAGER_1_POS" value="#manager1_pos#">
                                                        <input type="hidden" name="MANAGER_1_EMP_ID" id="MANAGER_1_EMP_ID" value="#manager1_emp_id#">
                                                    --->
                                                    <!--- <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=hr.popup_list_positions&field_emp_name=survey_main_result.MANAGER_1_POS_NAME&field_emp_id=survey_main_result.MANAGER_1_EMP_ID&field_code=survey_main_result.MANAGER_1_POS','list');"><img src="/images/plus_thin.gif" border="0"></a>  --->
                                                </div>
                                                </cfif>
                                                <cfif get_survey_main.is_manager_4 eq 1><!--- Ortak Degerlendirme Icin Eklendi --->
                                                    <input type="hidden" name="MANAGER_4_EMP_ID" id="MANAGER_4_EMP_ID" value="#get_main_result_info.manager1_emp_id#">
                                                </cfif>
                                            </div>
                                            <div class="form-group">
                                                <cfif get_survey_main.is_manager_2 eq 1>
                                                    <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='35921.İkinci Amir'></label>
                                                    <div class="input-group col col-8 col-md-8 col-sm-8 col-xs-12">
                                                        <input name="MANAGER_2_POS_NAME" type="text" id="MANAGER_2_POS_NAME" style="width:150px;" value="#get_emp_info(manager2_emp_id,0,0,0)#">
                                                        <input type="hidden" name="MANAGER_2_POS" id="MANAGER_2_POS" value="#manager2_pos#">
                                                        <input type="hidden" name="MANAGER_2_EMP_ID" id="MANAGER_2_EMP_ID" value="#manager2_emp_id#">
                                                        <!--- <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=hr.popup_list_positions&field_emp_name=survey_main_result.MANAGER_2_POS_NAME&field_emp_id=survey_main_result.MANAGER_2_EMP_ID&field_code=survey_main_result.MANAGER_2_POS','list');"><img src="/images/plus_thin.gif" border="0"></a>  --->
                                                    </div>
                                                </cfif>
                                            </div>
                                            </cfif>
                                            <cfif get_main_result_info.action_type eq 6><!--- deneme süresi ise gelsin--->
                                                <div class="form-group">
                                                    <label class="col col-3"><cf_get_lang dictionary_id='61023.Çalışan Görebilsin'></label>
                                                    <input type="checkbox" name="is_show_employee" id="is_show_employee" value="#is_show_employee#" <cfif is_show_employee eq 1>checked</cfif>>
                                                </div>
                                            </cfif>
                                        </div>
                                        <div class="col col-6 col-md-6 col-sm-6 col-xs-12" id="detail_1">
                                            <div class="form-group">
                                                <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57422.Notlar'></label>
                                                <div class="input-group col col-8 col-md-8 col-sm-8 col-xs-12"><textarea name="notes" id="notes">#get_main_result_info.result_note#</textarea></div>
                                            </div>
                                        </div>
                                    
                                </tr>
                                <cfelse>
                                    <div class="form-group" >
                                        <div class="input-group col col-8 col-md-8 col-sm-8 col-xs-12">
                                            <cf_workcube_process is_upd='0' select_value = '#get_main_result_info.process_row_id#' process_cat_width='130' is_detail='1'>
                                            <input type="text" name="start_date" id="start_date" value="#dateformat(get_main_result_info.start_date,dateformat_style)#">
                                            <input type="hidden" name="employee_id" id="employee_id" value="#get_main_result_info.emp_id#">
                                            <input type="hidden" name="consumer_id" id="consumer_id" value="#get_main_result_info.consumer_id#">
                                            <input type="hidden" name="company_id" id="company_id" value="#get_main_result_info.company_id#">
                                            <input type="hidden" name="partner_id" id="partner_id" value="#get_main_result_info.partner_id#">
                                        </div>
                                    </div>
                                </cfif>
                            </cfoutput>
                        </div>
                        <div class="col col-12">
                            <cf_box_footer>
                                <cfif get_survey_main.IS_NOT_SHOW_SAVED eq 0>
                                    <cf_record_info query_name="get_main_result_info">
                                </cfif>
                                <cfset kilitli = 0>
                                <cfif get_main_result_info.is_closed eq 1>
                                    <cfset kilitli = 1>
                                </cfif>
                                <cfif kilitli eq 0>
                                    <cfif (session.ep.ehesap or session.ep.admin) and get_main_result_info.action_id neq session.ep.userid>
                                        <cf_workcube_buttons is_upd='1' add_function='kontrol()' delete_page_url='#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_del_detailed_survey_main_result&result_id=#attributes.result_id#&survey_id=#attributes.survey_id#'>
                                    <cfelseif ((len(get_main_result_info.record_emp) and get_main_result_info.record_emp eq session.ep.userid) or (len(get_main_result_info.emp_id) and get_main_result_info.emp_id eq session.ep.userid) or not len(get_main_result_info.record_emp) or get_main_result_info.manager1_emp_id eq session.ep.userid or get_main_result_info.manager2_emp_id eq session.ep.userid or get_main_result_info.manager3_emp_id eq session.ep.userid)><!--- e hesap yetkim yoksa sadece kaydeden günceleyebilir sm --->
                                        <cf_workcube_buttons is_upd='1' add_function='kontrol()' is_delete="0">
                                    </cfif>
                                </cfif>
                            </cf_box_footer>
                        </div>
                    <cfelse>
                        <table>
                            <tr>
                                <label><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</label>
                            </tr>
                        </table>
                    </cfif>
                </table>
            </div>
        </cfform>
    </cfif>
</div>
</cf_box_elements>
</cf_box>
<script type="text/javascript">
function kontrol()
{
	if(document.getElementById('action_type').value == 9 && document.getElementById('is_selected_attender').value == 1 && (document.getElementById('user_name').value == '' || document.getElementById('user_id').value == ''))
	{
		alert("<cf_get_lang dictionary_id='29780.Katılımcı'>");
		return false;
	}
	if(document.getElementById('company_name')!= undefined && document.getElementById('company_name').value == '' && document.getElementById('employee').value == '')
	{
		alert("<cf_get_lang dictionary_id='57658.Üye'>/<cf_get_lang dictionary_id='29498.Çalışan Girmelisiniz'> !");
		return false;
	}
	if(document.getElementById('action_type').value == 8 & (document.getElementById('start_date').value == '' || (document.getElementById('finish_date') != undefined && document.getElementById('finish_date').value == '')))
	{
		alert("<cf_get_lang dictionary_id='58472.Dönem'>");
		return false;
	}
	//Tekli soru tipleri icin radiobutonun secili olup olmadigini kontrol eder
	var get_question_info = wrk_query("SELECT SURVEY_QUESTION_ID, IS_REQUIRED, QUESTION_HEAD, QUESTION_TYPE,SURVEY_CHAPTER_ID,IS_SHOW_GD FROM SURVEY_QUESTION WHERE SURVEY_MAIN_ID ="+ document.survey_main_result.survey_id.value+" ORDER BY SURVEY_QUESTION_ID","dsn");
	for (var xx=0; xx<get_question_info.recordcount; xx++)
	{	
		var get_opt_info = wrk_query("SELECT SURVEY_QUESTION_ID FROM SURVEY_OPTION WHERE SURVEY_CHAPTER_ID ="+ get_question_info.SURVEY_CHAPTER_ID[xx]+" ORDER BY SURVEY_QUESTION_ID","dsn");
		if(get_opt_info.SURVEY_QUESTION_ID[xx] == '')
			{
				var get_option_info_ = wrk_query("SELECT SURVEY_QUESTION_ID, SURVEY_OPTION_ID FROM SURVEY_OPTION WHERE SURVEY_CHAPTER_ID ="+ get_question_info.SURVEY_CHAPTER_ID[xx],"dsn");
			}
		else
			{
				var get_option_info_ = wrk_query("SELECT SURVEY_QUESTION_ID, SURVEY_OPTION_ID FROM SURVEY_OPTION WHERE SURVEY_QUESTION_ID ="+ get_question_info.SURVEY_QUESTION_ID[xx] + " AND SURVEY_CHAPTER_ID ="+ get_question_info.SURVEY_CHAPTER_ID[xx],"dsn");
			}
		if(get_question_info.IS_REQUIRED[xx] == 1)
		{
			if(get_question_info.QUESTION_TYPE[xx] == 1 || get_question_info.QUESTION_TYPE[xx] == 2)//Tekli yada coklu
			{
				gecti_ = 0;
				var question_id_ = get_question_info.SURVEY_QUESTION_ID[xx];
				var inputid = "user_answer_" + question_id_;
				var get_chapter = wrk_query("SELECT IS_SHOW_GD FROM SURVEY_CHAPTER WHERE SURVEY_CHAPTER_ID ="+get_question_info.SURVEY_CHAPTER_ID[xx],"DSN");
				if(get_question_info.IS_SHOW_GD[xx] == 1 || (get_chapter.recordcount >0 && get_chapter.IS_SHOW_GD[0] == 1)) //GD seçeneği geliyor ise
				{var sayac = get_opt_info.recordcount+1;}else var sayac = get_opt_info.recordcount;
				for (var yy=0; yy<sayac; yy++)
				{
					if(document.getElementsByName(inputid)[yy]!= undefined && document.getElementsByName(inputid)[yy].checked == true)
						{gecti_ = 1;break;}
				}
				if(gecti_ == 0)
				{
					alert(get_question_info.QUESTION_HEAD[xx] + ' ' +"<cf_get_lang dictionary_id='29781.Lütfen Zorunlu Alanları Doldurunuz'> !");
					return false;
				}
			}
			if(get_question_info.QUESTION_TYPE[xx] == 3 || get_question_info.QUESTION_TYPE[xx] == 5)//Acikuclu veya metin
			{
				var question_id = get_question_info.SURVEY_QUESTION_ID[xx];
				for (var zz=0; zz<get_option_info_.recordcount; zz++)
				{
					var inputid = "user_answer_" + question_id+'_'+get_option_info_.SURVEY_OPTION_ID[zz];
					if(document.getElementById(inputid).value == '')
					{
						alert(get_question_info.QUESTION_HEAD[xx] + ' ' +"<cf_get_lang dictionary_id='29781.Lütfen Zorunlu Alanları Doldurunuz'> !");
						return false;
					}
				}
			}
		}
	}
    if(document.survey_main_result.process_stage != undefined)
	return process_cat_control();
    loadPopupBox('survey_main_result' ,  "<cfoutput>#attributes.modal_id#</cfoutput>");
    return false;

}
var s = 98;//Ascii kodu a harfine karsilik geliyor
function add_new_option(x,row_count_options,survey_chapter_id)
{	
	aaa = document.getElementById("record_num_result_"+row_count_options).value;
	var get_option_info = wrk_query("SELECT SURVEY_QUESTION_ID, SURVEY_OPTION_ID, SURVEY_QUESTION_ID, OPTION_HEAD, OPTION_POINT, OPTION_NOTE FROM SURVEY_OPTION WHERE SURVEY_QUESTION_ID ="+ row_count_options,"dsn");
	var newRow;
	var newCell;
	newRow = document.getElementById("add_new_option_"+row_count_options).insertRow(document.getElementById("add_new_option_"+row_count_options).rows.length);
	newRow.setAttribute("name","add_new_option_row_'+row_count_options+'_'+aaa+'");
	newRow.setAttribute("id","add_new_option_row_'+row_count_options+'_'+aaa+'");	
	newRow.setAttribute("NAME","add_new_option_row_'+row_count_options+'_'+aaa+'");
	newRow.setAttribute("ID","add_new_option_row_'+row_count_options+'_'+aaa+'");
	for (var mm=0; mm<x; mm++)
	{
		
		newRow = document.getElementById("add_new_option_"+row_count_options).insertRow(document.getElementById("add_new_option_"+row_count_options).rows.length);
		newRow.setAttribute("name","add_new_option_row_" + row_count_options);
		newRow.setAttribute("id","add_new_option_row_" + row_count_options);	
		newRow.setAttribute("NAME","add_new_option_row_" + row_count_options);
		newRow.setAttribute("ID","add_new_option_row_" + row_count_options);
		newCell = newRow.insertCell();
		newCell.innerHTML = String.fromCharCode(s)+' ) '+get_option_info.OPTION_HEAD[mm];
		var option_id = parseInt(get_option_info.SURVEY_OPTION_ID[x-1]) + parseInt(mm+1);
		alert(option_id);
		document.getElementById("record_num_result_"+row_count_options).value = option_id;
	}
	s = s + 1;
}
function unlock_send()
{
	AjaxPageLoad('<cfoutput>#request.self#?fuseaction=objects.emptypopup_to_lock&survey_id=#attributes.survey_id#&survey_main_result_id=#attributes.result_id#&lock=1</cfoutput>','menu_1','0',"Form Kilidi Kaldırılıyor");
}
function lock_send()
{
	AjaxPageLoad('<cfoutput>#request.self#?fuseaction=objects.emptypopup_to_lock&survey_id=#attributes.survey_id#&survey_main_result_id=#attributes.result_id#&lock=0</cfoutput>','menu_1','0',"Form Kilitleniyor");
}
</script>