<!--- form generator formları sonuç raporu SG 20140715--->
<cfsetting showdebugoutput="no" >
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.emp_id" default="">
<cfparam name="attributes.employee_name" default="">
<cfparam name="attributes.department_id" default="">
<cfparam name="attributes.is_excel" default="0">
<cfparam name="attributes.survey_id" default="">
<cfparam name="attributes.startdate" default="">
<cfif isdefined("attributes.startdate") and isdate(attributes.startdate)>
    <cf_date tarih = "attributes.startdate">
<cfelse>
    <cfset attributes.startdate = ''>
</cfif>
<cfif isdefined("attributes.form_submitted")>
	<cfquery name="get_survey_info" datasource="#dsn#">
			SELECT 
				  SQ.SURVEY_QUESTION_ID,
				  SQ.QUESTION_HEAD,
                  SC.SURVEY_CHAPTER_HEAD,
                  SC.SURVEY_CHAPTER_ID,
                  SQ.QUESTION_TYPE
			FROM 
				  SURVEY_QUESTION SQ
                  LEFT JOIN SURVEY_CHAPTER SC ON SQ.SURVEY_CHAPTER_ID = SC.SURVEY_CHAPTER_ID
			WHERE
				  SC.SURVEY_MAIN_ID = #attributes.survey_id#         
	</cfquery>
<cfelse>
	<cfset get_survey_info.recordcount = 0>
</cfif>
<cfif isdefined('attributes.form_submitted')>
    <cfquery name="get_main_report" datasource="#dsn#">
		SELECT 
            SR.SURVEY_MAIN_RESULT_ID,
			SM.SURVEY_MAIN_HEAD AS HEAD,
			SM.SURVEY_MAIN_ID,
            SR.SCORE_RESULT,
			SM.TYPE,			
			SR.ACTION_TYPE,
			SR.ACTION_ID,
			SR.RECORD_DATE,
            SR.START_DATE,
            E.EMPLOYEE_NAME AS AD, 
            E.EMPLOYEE_SURNAME AS SOYAD, 
            E.EMPLOYEE_ID AS NO,
            E.EMPLOYEE_NO AS EMPLOYEE_NO,
            D.DEPARTMENT_HEAD,
            D2.DEPARTMENT_HEAD AS UPPER_DEPARTMENT_HEAD
		FROM
            SURVEY_MAIN SM,	 
            SURVEY_MAIN_RESULT SR,
            EMPLOYEES E LEFT JOIN EMPLOYEE_POSITIONS EP ON E.EMPLOYEE_ID = EP.EMPLOYEE_ID
			INNER JOIN DEPARTMENT D ON EP.DEPARTMENT_ID = D.DEPARTMENT_ID
			LEFT JOIN DEPARTMENT as D2 ON D.HIERARCHY_DEP_ID  = CONCAT(D2.HIERARCHY_DEP_ID,'.',D.DEPARTMENT_ID)
        WHERE
			SR.SURVEY_MAIN_ID = SM.SURVEY_MAIN_ID AND
            SR.SURVEY_MAIN_ID = #attributes.survey_id# AND
            SR.EMP_ID = E.EMPLOYEE_ID     
            <cfif len(attributes.emp_id)>
				AND SR.EMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.emp_id#">
            </cfif>
			<cfif len(attributes.keyword)>
				AND (E.EMPLOYEE_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">)
            </cfif>
            <cfif len(attributes.startdate)>
                AND SR.START_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#">
            </cfif>     
            <cfif len(attributes.department_id)>
                AND D.DEPARTMENT_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department_id#" list="yes">)
            </cfif> 
		ORDER BY
			SR.START_DATE DESC
    </cfquery>           
<cfelse>
	<cfset get_main_report.recordcount = 0>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfparam name="attributes.totalrecords" default='#get_main_report.recordcount#'>
<div class="col col-12 col-xs-12">
    <cf_box>
        <cfform name="search_survey_detail" method="post" action="#request.self#?fuseaction=report.list_employee_survey_detail">
            <input name="form_submitted" id="form_submitted" value="1" type="hidden">
            <cf_box_search>
                <cfoutput>
                    <div class="form-group" id="item-keyword">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='57460.Filtre'></cfsavecontent>
                        <cfinput type="text" name="keyword" placeholder="#message#" value="#attributes.keyword#" maxlength="50">
                    </div>
                    <div class="form-group">
                        <cfquery name="get_survey_main" datasource="#dsn#">
                            SELECT
                                SURVEY_MAIN_ID,
                                SURVEY_MAIN_HEAD,
                                TYPE 
                            FROM 
                                SURVEY_MAIN
                            WHERE
                                TYPE = 14 AND
                                IS_ACTIVE = 1	
                            ORDER BY
                                SURVEY_MAIN_HEAD				
                            </cfquery>
                            <select name="survey_id" id="survey_id" style="width:150px;">
                                <cfloop query="get_survey_main">
                                    <option value="#survey_main_id#"<cfif attributes.survey_id eq survey_main_id>selected</cfif>>#survey_main_head#</option>
                                </cfloop>
                            </select>
                    </div>		 
                    <div class="form-group">
                        <div class="input-group">
                            <input type="hidden" name="emp_id" maxlength="50" id="emp_id" value="<cfif len(attributes.emp_id) and len(attributes.employee_name)><cfoutput>#attributes.emp_id#</cfoutput></cfif>">      
                            <input type="text" name="employee_name" maxlength="50" placeholder="<cf_get_lang dictionary_id='57576.Çalışan'>" id="employee_name" value="<cfif len(attributes.emp_id) and len(attributes.employee_name)><cfoutput>#attributes.employee_name#</cfoutput></cfif>" onfocus="AutoComplete_Create('employee_name','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','emp_id','','3','135');" />
                            <span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=search_survey_detail.emp_id&field_name=search_survey_detail.employee_name&select_list=1&branch_related','list','popup_list_positions')"></span>
                        </div>
                    </div>                                  
                    <div class="form-group">
                        <div class="input-group">
                            <input type="text" name="startdate" id="startdate" value="#dateformat(attributes.startdate,dateformat_style)#" validate="#validate_style#" placeholder="<cf_get_lang dictionary_id='59871.Katılım Tarihi'>" maxlength="10">
                            <span class="input-group-addon"><cf_wrk_date_image date_field="startdate"></span>
                        </div>
                    </div>
                    <div class="form-group small">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
                        <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
                    </div>
                    <div class="form-group">
                        <label><input type="checkbox" name="is_excel" id="is_excel" value="1" <cfif attributes.is_excel eq 1>checked</cfif>><cf_get_lang_main no='446.Excel Getir'></label>

                    </div>
                    <div class="form-group">
                        <cf_wrk_search_button button_type="1" is_excel="1">
                    </div>
                </cfoutput>
            </cf_box_search>
            <cf_box_search_detail>
                <div class="col col-4 col-sm-6 col-xs-12">
                    <div class="form-group" id="item-department_id">
                        <label class="col col-12"><cfoutput>#getLang(dictionary_id:35449)#</cfoutput></label>
                        <div class="col col-12">
                            <cf_wrkdepartmentbranch fieldid='department_id' is_department='1' selected_value='#attributes.DEPARTMENT_ID#' is_multiple="1">
                        </div>
                    </div>
                </div>  
            </cf_box_search_detail>
        </cfform>   
    </cf_box>
    <cfsavecontent variable="head"><cf_get_lang dictionary_id='60959.Detaylı Anket Raporu' ></cfsavecontent>
    <cf_box title="#head#" uidrop="1" hide_table_column="1">
            <cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
                <cfset type_ = 1>
                <cfset attributes.startrow=1>
                <cfset attributes.maxrows = get_main_report.recordcount>
            <cfelse>
                <cfset type_ = 0>
            </cfif>
        <cf_wrk_html_table bigList class="ajax_list" table_draw_type="#type_#" filename="list_survey_detail_employee_#dateformat(now(),'ddmmyyyy')#_#timeformat(now(),'HHMMl')#_#session.ep.userid#">
            <cf_wrk_html_thead>
                <cf_wrk_html_tr>
                        <cf_wrk_html_th width="35"><cf_get_lang dictionary_id='58577.Sira'></cf_wrk_html_th>
                        <cf_wrk_html_th width="75"><cf_get_lang dictionary_id='32328.Sicil No'></cf_wrk_html_th>
                        <cf_wrk_html_th><cf_get_lang dictionary_id='57576.Çalışan'></cf_wrk_html_th>
                        <cf_wrk_html_th><cf_get_lang dictionary_id='57985.Üst'> <cf_get_lang dictionary_id='57572.Departman'></cf_wrk_html_th>
                        <cf_wrk_html_th><cf_get_lang dictionary_id='57572.Departman'></cf_wrk_html_th>
                        <cf_wrk_html_th><cf_get_lang dictionary_id='59871.Katılım Tarihi'></cf_wrk_html_th>                        
                        <cfif isdefined("attributes.form_submitted")>
                            <cfoutput><cfloop query="get_survey_info"><cf_wrk_html_th>#question_head#</cf_wrk_html_th></cfloop></cfoutput>
                        </cfif>
                        <cf_wrk_html_th><cf_get_lang dictionary_id="58984.Puan"></cf_wrk_html_th>
                        <!-- sil --><cfif attributes.is_excel eq 1><cf_wrk_html_th></cf_wrk_html_th><cfelse><cf_wrk_html_th width="20"><i class="fa fa-cube"></i></cf_wrk_html_th></cfif> <!-- sil --> 
                </cf_wrk_html_tr>
            </cf_wrk_html_thead>                
            <cf_wrk_html_tbody>
                <cfif get_main_report.recordcount>                   
                    <cfoutput query="get_main_report" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#"> 
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
                                SO.SURVEY_CHAPTER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_survey_info.survey_chapter_id#">
                            <cfif get_survey_info.question_type eq 3>
                            ORDER BY 
                                RESULT_NUMBER
                            </cfif>
                        </cfquery>
                        <cf_wrk_html_tr>
                            <cf_wrk_html_td>#currentrow#</cf_wrk_html_td>
                            <cf_wrk_html_td>#Employee_no#</cf_wrk_html_td>
                            <cf_wrk_html_td>#ad# #soyad#</cf_wrk_html_td>	
                            <cf_wrk_html_td>#upper_department_head#</cf_wrk_html_td>
                            <cf_wrk_html_td>#department_head#</cf_wrk_html_td>                        			
                            <cf_wrk_html_td>#dateformat(START_DATE,dateformat_style)#</cf_wrk_html_td>                              
                            <cfloop query="get_survey_info">  
                                <cf_wrk_html_td>
                                    <cfloop query="get_survey_chapter_questions_options">
                                        <cfquery name="get_survey_question_result" datasource="#dsn#">
                                            SELECT 
                                                SURVEY_OPTION_ID,
                                                OPTION_POINT,
                                                CHAPTER_DETAIL2,
                                                GD_OPTION,
                                                OPTION_HEAD
                                            FROM 
                                                SURVEY_QUESTION_RESULT 
                                            WHERE 
                                                SURVEY_QUESTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_survey_info.survey_question_id#"> AND 
                                                SURVEY_OPTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_survey_chapter_questions_options.survey_option_id#"> AND
                                                SURVEY_MAIN_RESULT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_main_report.survey_main_result_id#"> 
                                        </cfquery>                                     
                                        <cfswitch expression="#get_survey_info.question_type#">
                                            <cfcase value="1"><!--- tekli soru tipi --->
                                                <cfif ListFind(get_survey_question_result.survey_option_id,get_survey_chapter_questions_options.survey_option_id,",")> #get_survey_chapter_questions_options.option_head#</cfif>
                                            </cfcase>
                                            <cfcase value="2"><!--- çoklu soru tipi --->
                                                <cfif ListFind(get_survey_question_result.survey_option_id,get_survey_chapter_questions_options.survey_option_id,",")>#get_survey_chapter_questions_options.option_head#/</cfif>
                                            </cfcase>
                                            <cfcase value="3,5"><!--- metin soru tipi --->
                                                <cfif ListFind(get_survey_question_result.survey_option_id,get_survey_question_result.survey_option_id,",")> #get_survey_question_result.option_head#</cfif>
                                            </cfcase>
                                        </cfswitch>  
                                    </cfloop>

                                </cf_wrk_html_td>                                  
                            </cfloop>   
                            <cf_wrk_html_td>#TlFormat(get_main_report.SCORE_RESULT)#</cf_wrk_html_td>
                          <!-- sil --> <cfif attributes.is_excel eq 1><cf_wrk_html_td></cf_wrk_html_td><cfelse><cf_wrk_html_td width="20">
                                <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_form_upd_detailed_survey_main_result&survey_id=#get_main_report.survey_main_id#&result_id=#get_main_report.survey_main_result_id#&is_popup=1','wide')"><i class="fa fa-cube" title="<cf_get_lang dictionary_id='57771.Detay'>"></i></a>
                            </cf_wrk_html_td></cfif>   <!-- sil -->                           
                        </cf_wrk_html_tr>
                    </cfoutput>
                <cfelse>
                    <cfoutput>
                        <cfset col ='#get_survey_info.recordCount#' + 8>
                        <tr>
                            <cf_wrk_html_td colspan="#col#"><cfif isdefined('attributes.form_submitted')><cf_get_lang dictionary_id='57484.Kayit Bulunamadi'><cfelse><cf_get_lang dictionary_id='57701.Filtre ediniz'></cfif>!</cf_wrk_html_td>
                        </tr>
                    </cfoutput>                        
                </cfif>
            </cf_wrk_html_tbody>
        </cf_wrk_html_table>
            <cfset url_str = "">
            <cfif len(attributes.keyword)>
                <cfset url_str = "#url_str#&keyword=#attributes.keyword#">
            </cfif>
            <cfif len(attributes.emp_id)>
                <cfset url_str = "#url_str#&emp_id=#attributes.emp_id#">
            </cfif>
            <cfif len(attributes.startdate)>
                <cfset url_str = "#url_str#&startdate=#dateformat(attributes.startdate,dateformat_style)#">
            </cfif>
            <cfif isdefined('attributes.department_id')>
                <cfset url_str = "#url_str#&department_id=#attributes.department_id#">
            </cfif>
            <cfif isdefined('attributes.survey_id')>
                <cfset url_str = "#url_str#&survey_id=#attributes.survey_id#">
            </cfif>
            <cfif isdefined('attributes.form_submitted')>
                <cfset url_str = "#url_str#&form_submitted=#attributes.form_submitted#">
            </cfif>
                <cf_paging
                    page="#attributes.page#" 
                    maxrows="#attributes.maxrows#" 
                    totalrecords="#attributes.totalrecords#" 
                    startrow="#attributes.startrow#" 
                    adres="report.list_employee_survey_detail#url_str#">
    </cf_box>
</div>
<script type="text/javascript">
   /*  function kontrol()	
    {
        if(document.search_survey_detail.is_excel.checked==false)
        {
            document.search_survey_detail.action="<cfoutput>#request.self#</cfoutput>?fuseaction=report.list_employee_survey_detail";
            return true;
        }
        else
			document.search_asset.action="<cfoutput>#request.self#?fuseaction=report.emptypopup_id_report</cfoutput>";
    } */
	document.getElementById('keyword').focus();
</script>