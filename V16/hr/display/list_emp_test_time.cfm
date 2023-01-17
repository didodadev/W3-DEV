<cf_xml_page_edit fuseact="hr.emp_test_time">
<cfset attributes.employee_id = attributes.emp_id>
<cfinclude template="../query/get_hr.cfm"> 
<cfinclude template="../query/get_position_master.cfm">
<cfquery name="get_test_time" datasource="#dsn#">
    SELECT  ET.TEST_TIME_ID 
        , ET.EMPLOYEE_ID 
        , ET.QUIZ_ID 
        , ET.TEST_TIME_STAGE 
        , ET.TEST_TIME_TYPE 
        , ET.TEST_TIME_DAY 
        , ET.CAUTION_TIME_DAY 
        , ET.CAUTION_EMP_ID 
        , ET.TEST_TIME_DETAIL 
        , ET.RECORD_DATE 
        , ET.RECORD_EMP 
        , ET.RECORD_IP 
        , ET.UPDATE_DATE 
        , ET.UPDATE_EMP 
        , ET.UPDATE_IP
        ,ETT.TEST_TIME_TYPE_NAME
    FROM  EMPLOYEES_TEST_TIME ET
        LEFT JOIN EMPLOYEES_TEST_TIME_TYPE ETT ON ET.TEST_TIME_TYPE = ETT.EMPLOYEES_TEST_TIME_TYPE_ID
    WHERE 
        ET.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.emp_id#">
</cfquery>
<cfquery name="get_work_startdate" datasource="#dsn#" maxrows="1">
    SELECT 
        START_DATE,
        IN_OUT_ID
    FROM
        EMPLOYEES_IN_OUT
    WHERE
        EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.emp_id#">
    ORDER BY IN_OUT_ID DESC
</cfquery>
<div style="display:none;z-index:999999;" id="upd_test_time"></div>
<div style="display:none;z-index:999999;" id="add_test_time"></div>
<cfparam name="attributes.test_time_id" default="">
<cfsavecontent variable="message"><cf_get_lang dictionary_id="55325.Deneme Süresi Bilgileri"></cfsavecontent>
<cf_box id="trial_box" title="#message#" closable="1" draggable="1" scroll="1" collapsable="0" resize="0" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
    <cfform action="" name="employe_detail" method="post">
        <input type="hidden" name="control_upd" id="control_upd" value="<cfif not len(get_test_time.test_time_day)>1</cfif>">

        <cf_box_elements>
            <cfoutput>
            <div class="col col-12 col-xs-12">
                <div class="form-group">
                    <label class="col col-4 col-md-4 col-sm-4 col-xs-4 bold"><cf_get_lang dictionary_id='57570.Ad Soyad'></label>
                    <label class="col col-8 col-md-8 col-sm-8 col-xs-8">
                            #get_emp_info(attributes.emp_id,0,0)#
                    </label>
                </div>
                <div class="form-group">
                    <label class="col col-4 col-md-4 col-sm-4 col-xs-4 bold"><cf_get_lang dictionary_id='58497.Pozisyon'>/ <cf_get_lang dictionary_id='57572.Departman'></label>
                    <label class="col col-8 col-md-8 col-sm-8 col-xs-8">
                        <cfoutput>
                            #get_position.position_name# / #get_position.department_head#
                        </cfoutput>
                    </label>
                </div>
            </div>
        </cfoutput>
        </cf_box_elements>       
    </cfform>
    <cf_ajax_list>
        <thead>
            <th><cf_get_lang dictionary_id='30631.Tarih'></th>
            <th><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></th>
            <th><cf_get_lang dictionary_id='46520.Değerlendirme Formu'></th>
            <th><cf_get_lang dictionary_id='59264.Form Tipi'></th>
            <th><cf_get_lang dictionary_id='36199.Açıklama'></th>
            <th><cf_get_lang dictionary_id='58859.Süreç'></th>
            <th><a href="javascript://"  onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=hr.popup_emp_add_test_time&emp_id=#attributes.emp_id#</cfoutput>','trial_time');"><i class="fa fa-plus"></i></a></th>
        </thead>
        <cfif get_test_time.recordcount>
        <cfloop query="get_test_time">
            <cfoutput>
                <cfquery name="GET_QUIZ" datasource="#DSN#">
                    SELECT SURVEY_MAIN_HEAD,PROCESS_ROW_ID FROM SURVEY_MAIN  WHERE SURVEY_MAIN_ID IN ( #get_test_time.QUIZ_ID# )
                </cfquery>
                <cfif len(test_time_stage)>
                    <cfquery name="GET_PROCESS" datasource="#DSN#">
                        SELECT PROCESS_ROW_ID,STAGE FROM PROCESS_TYPE_ROWS  WHERE PROCESS_ROW_ID=#test_time_stage#
                    </cfquery>
                </cfif>
                <tbody>
                    <td>#Dateformat(get_test_time.record_date,dateformat_style)#</td>
                    <td><cfif get_work_startdate.recordcount>
                        #dateformat(dateadd('d',test_time_day,get_work_startdate.start_date),dateformat_style)#
                    </cfif></td>
                    <td>#GET_QUIZ.SURVEY_MAIN_HEAD#</td>
                    <td>#TEST_TIME_TYPE_NAME#</td>
                    <td>#TEST_TIME_DETAIL#</td>
                    <td><cfif len(test_time_stage)>#GET_PROCESS.stage#</cfif></td>
                    <td><a href="javascript://"  onClick="openBoxDraggable('#request.self#?fuseaction=hr.popup_emp_upd_test_time&emp_id=#attributes.emp_id#&test_time_id=#test_time_id#','upd_test_time');"><i class="fa fa-pencil"></i></a></td>
                </tbody>
            </cfoutput>
        </cfloop>
        <cfelse>
            <tbody><td colspan="7">Kayıt Yok</td></tbody>
        </cfif>
        
    </cf_ajax_list>
</cf_box>
<script type="text/javascript">
    function open_tab(url,id) {
        document.getElementById(id).style.display ='';	
        document.getElementById(id).style.width ='450px';	
        $("#"+id).css('margin-left',$("#tabMenu").position().left - 640);
        $("#"+id).css('margin-top',$("#tabMenu").position().top - 100);
        $("#"+id).css('position','absolute');	
        
        AjaxPageLoad(url,id,1);
        return false;
    }
</script>