<cfset attributes.survey_id = attributes.action_id>
<cfset attributes.result_id = attributes.action_row_id>
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
<cfif isdefined("attributes.start_date") and isdate(attributes.start_date)>
    <cf_date tarih="attributes.start_date">
<cfelse>
    <cfset attributes.start_date = wrk_get_today()>
</cfif>
<cf_woc_header>
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
    <cf_woc_elements>
        <tr class="color-list">
            <cfset chapter_current_row = 1>
            <cfset all_chapter_total_point = 0>
            <cfoutput query="get_survey_info" group="survey_chapter_id">
            <label class="bold margin-left-5" style="color:red">#survey_chapter_head# #getLang('','Form Tipi','56000')#: #action_type_#</label>
            <table id="chapter_#chapter_current_row#"  width="50%">
                
                    <cfif len(survey_chapter_detail)>
                    <tr>
                        <td class="bold">#survey_chapter_detail#</td>
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
                                        <tr>
                                            <td>
                                                <div class="col col-12 col-md-12 col-sm-12 col-xs-12 bold">
                                                    <cfif is_required eq 1>#question_current_row#. #question_head# *</cfif>
                                                    <cfif len(question_detail)><i class="fa fa-question-circle" title="#question_detail#"></i></cfif>
                                                </div>
                                            </td>
                                        </tr>
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
    </cf_woc_elements>
</cfif>
<cf_woc_footer>