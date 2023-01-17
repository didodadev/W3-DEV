<cfparam name="attributes.process_status" default="2">
<cfparam name="attributes.process_stage" default="">
<cfparam name="attributes.process_filter" default="">
<cfquery name="get_upper_pos_code" datasource="#dsn#">

SELECT 
POSITION_CODE 
FROM 
EMPLOYEES E, 
EMPLOYEE_POSITIONS EP 
WHERE 
E.EMPLOYEE_ID = EP.EMPLOYEE_ID 
AND (
UPPER_POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">
OR UPPER_POSITION_CODE2 = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">
)
AND EMPLOYEE_STATUS = 1
</cfquery>
<cfset list_pos_code = 0>
<cfset list_pos_code = listappend(valuelist(get_upper_pos_code.position_code),list_pos_code)>

<cfif isdefined("attributes.START_DATE") and len(attributes.START_DATE)>
<cf_date tarih="attributes.START_DATE">
<cfelse>
<cfparam name="attributes.START_DATE" default="">
</cfif>
<cfquery name="get_upper_emps" datasource="#dsn#">
SELECT EMPLOYEE_ID FROM EMPLOYEE_POSITIONS WHERE POSITION_CODE IN (#list_pos_code#)
</cfquery>
<cfset list_emp_ids = 0>
<cfset list_emp_ids = listappend(valuelist(get_upper_emps.employee_id),list_emp_ids)>
<cfquery name="get_survey_main_approve" datasource="#dsn#">
SELECT
SMR.SURVEY_MAIN_RESULT_ID,
SMR.EMP_ID,
SMR.START_DATE,
SMR.ACTION_ID,
SMR.SURVEY_MAIN_ID,
SMR.MANAGER1_POS,
SMR.MANAGER1_EMP_ID,
SMR.VALID1,
SMR.MANAGER2_POS,
SMR.MANAGER2_EMP_ID,
SMR.VALID2,
SMR.MANAGER3_POS,
SMR.MANAGER3_EMP_ID,
SMR.VALID3,
EMPLOYEES.EMPLOYEE_NAME,
EMPLOYEES.EMPLOYEE_SURNAME,
PROCESS_TYPE_ROWS.STAGE,
SMR.PROCESS_ROW_ID,
PW.ACTION_STAGE_ID,
PW.W_ID
FROM
PAGE_WARNINGS PW
LEFT JOIN PAGE_WARNINGS_ACTIONS AS PWA ON PW.W_ID = PWA.WARNING_ID
INNER JOIN SURVEY_MAIN_RESULT SMR ON PW.ACTION_ID = SMR.SURVEY_MAIN_RESULT_ID
INNER JOIN EMPLOYEES ON EMPLOYEES.EMPLOYEE_ID = SMR.ACTION_ID
INNER JOIN EMPLOYEES_IN_OUT ON EMPLOYEES.EMPLOYEE_ID = EMPLOYEES_IN_OUT.EMPLOYEE_ID
INNER JOIN PROCESS_TYPE_ROWS ON SMR.PROCESS_ROW_ID = PROCESS_TYPE_ROWS.PROCESS_ROW_ID
WHERE           
PW.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">
AND PW.ACTION_TABLE = 'SURVEY_MAIN_RESULT'
<cfif len(attributes.process_status) and (attributes.process_status eq 1 OR attributes.process_status eq 0)>
    AND SMR.VALID3 = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_status#">
<cfelseif len(attributes.process_status) and attributes.process_status eq 2>
    AND SMR.VALID3 IS NULL
</cfif>
<cfif len(attributes.process_filter)>
    AND PW.ACTION_STAGE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_filter#"> 
    AND PWA.ACTION_STAGE_ID IS NULL
</cfif>
ORDER BY
SMR.START_DATE DESC,
SMR.RECORD_DATE DESC,		
EMPLOYEES.EMPLOYEE_NAME ASC,
EMPLOYEES.EMPLOYEE_SURNAME ASC
</cfquery>
<cfif get_survey_main_approve.recordCount>
<cfquery name="get_survey_head" datasource="#dsn#">
    SELECT SURVEY_MAIN_HEAD FROM SURVEY_MAIN WHERE SURVEY_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_survey_main_approve.survey_main_id#">  
</cfquery>
</cfif>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cfform name = "search_form" method="post" action=""> 
            <cf_box_search more="0">
                <div class="form-group">
                    <select name="process_status" id="process_status" onchange="show_hide_process()">
                        <option value="2" <cfif attributes.process_status eq 2>selected</cfif>><cf_get_lang dictionary_id='61148.İK Sürecini Bekleyenler'></option>
                        <option value="1" <cfif attributes.process_status eq 1>selected</cfif>><cf_get_lang dictionary_id='61149.IK Tarafından Onaylananlar'></option>
                        <option value="0" <cfif attributes.process_status eq 0>selected</cfif>><cf_get_lang dictionary_id='61150.IK Tarafından Red Edilenler'></option>
                        <option value="3" <cfif attributes.process_status eq 3>selected</cfif>><cf_get_lang dictionary_id='59337.Onay Bekleyenler'></option>
                    </select>
                </div>
                <div class="form-group" style="display:none"  id="process_div">
                    <cf_workcube_process is_upd='0' select_value='#attributes.process_filter#' is_select_text='1' process_cat_width='150' is_detail='0' select_name="process_filter">
                </div>
                <div class="form-group">
                    <cf_wrk_search_button button_type="4">
                </div>
            </cf_box_search>
        </cfform>
    </cf_box>
    <!--- Onay Bekleyen Değerlendirme Formları--->
    <cfform name = "setProcessForm" id="setProcessForm" method="post" action="#request.self#?fuseaction=myhome.emptypopup_upd_list_warning">
        <cfsavecontent variable="title"><cf_get_lang dictionary_id="37233.Onay Bekleyen"><cf_get_lang dictionary_id='29744.Değerlendirme Formları'></cfsavecontent>
        <cf_box title="#title#" uidrop="1" hide_table_column="1">
            <cf_flat_list>
                <thead>
                    <tr>
                        <th width="30"><cf_get_lang dictionary_id='57487.No'></th>
                        <th><cf_get_lang dictionary_id='57570.Ad Soyad'></th>
                        <th><cf_get_lang dictionary_id='55907.Değerlendirme Formu'></th>
                        <th><cf_get_lang dictionary_id='55620.Değerlendirici'></th>                                    
                        <th><cf_get_lang dictionary_id='57627.Kayıt Tarihi'></th>
                        <th><cf_get_lang dictionary_id='57482.Aşama'></th>
                        <th width="20" class="header_icn_none text-center"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></th>
                        <th width="20"><input class="checkControl" type="checkbox" id="checkAll" name="checkAll" value="0"/></th>                               
                    </tr>
                </thead>
                <tbody>
                    <cfif get_survey_main_approve.recordcount>
                        <cfoutput query="get_survey_main_approve">
                            <cfset attributes.survey_main_id = contentEncryptingandDecodingAES(isEncode:1,content:survey_main_id,accountKey:session.ep.userid)>
                            <cfset attributes.survey_main_result_id = contentEncryptingandDecodingAES(isEncode:1,content:survey_main_result_id,accountKey:session.ep.userid)>                        
                            <tr>
                                <td width="20">#currentrow#</td>
                                <td>#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#</td>
                                <td>#get_survey_head.survey_main_head#</td>
                                <td>#get_emp_info(emp_id,0,0)#</td>
                                <td>#dateformat(START_DATE,dateformat_style)#</td>
                                <td><cf_workcube_process type="color-status" process_stage="#PROCESS_ROW_ID#"></td> 
                                <td>
                                    <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_form_upd_detailed_survey_main_result&fbx=myhome&survey_id=#attributes.survey_main_id#&result_id=#attributes.survey_main_result_id#&is_popup=1','page')">
                                        <i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a>
                                </td>                              
                                <td width="20">
                                    <input class="checkControl" type="checkbox" name="action_list_id" id="action_list_id" value="#W_ID#"/>
                                </td>
                                
                            </tr>
                        </cfoutput>
                    <cfelse>
                        <tr> 
                            <td colspan="20"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
                        </tr>
                    </cfif>
                </tbody>
            </cf_flat_list>
            <cfif isdefined("attributes.process_filter") and len(attributes.process_filter)>
                <cf_box_footer>
                        <input type="hidden" name="approve_submit" id="approve_submit" value="1">
                        <input type="hidden" name="valid_ids" id="valid_ids" value="">
                        <input type="hidden" name="refusal_ids" id="refusal_ids" value="">
                        <input type="hidden" name="fuseaction_" id="fuseaction_" value="<cfoutput>#attributes.fuseaction#</cfoutput>">
                        <input type="hidden" name="fuseaction_reload" id="fuseaction_reload" value="<cfoutput>#attributes.fuseaction#</cfoutput>">
                        <input type="hidden" name="process_filter" id="process_filter" value="<cfoutput>#attributes.process_filter#</cfoutput>">
                        <input type="hidden" name="process_status" id="process_status" value="<cfoutput>#attributes.process_status#</cfoutput>">
                        <cfsavecontent variable="onayla"><cf_get_lang dictionary_id="58475.Onayla"></cfsavecontent>
                        <cfsavecontent variable="reddet"><cf_get_lang dictionary_id="58461.reddet"></cfsavecontent>
                        <cf_workcube_buttons extraButton="1" extraButtonText="#reddet#" extraFunction="setSurveyResultProcess(2)" update_status="0">
                        <cf_workcube_buttons extraButton="1" extraButtonText="#onayla#" extraFunction="setSurveyResultProcess(1)" update_status="0">
                </cf_box_footer>
            </cfif>
        </cf_box>
    </cfform>
</div>
<script type="text/javascript">
    show_hide_process();
    $(function(){
        $('input[name=checkAll]').click(function(){
            if(this.checked){
                $('.checkControl').each(function(){
                    $(this).prop("checked", true);
                });
            }
            else{
                $('.checkControl').each(function(){
                    $(this).prop("checked", false);
                });
            }
        });
    });
    function setSurveyResultProcess(type){
        var controlChc = 0;
        $('.checkControl').each(function(){
            if(this.checked){
                controlChc += 1;
            }
        });
        if(controlChc == 0){
            alert("<cf_get_lang dictionary_id='29764.Form'> <cf_get_lang dictionary_id='57734.Seçiniz'>");
            return false;
        }
        if(type == 2){
            $("#action_list_id:checked").each(function () {
                $(this).attr('name', 'refusal_ids');
            });
        }else{
            $("#action_list_id:checked").each(function () {
                $(this).attr('name', 'valid_ids');

            });
        }
        $('#setProcessForm').submit();
        
    }
    
    function show_hide_process(){
        process_status = $('#process_status').val();
        if (process_status != 3){
            document.getElementById('process_div').style.display = 'none';
            document.getElementById('process_stage').value = '';  
            document.getElementById('process_filter').value = ''
        }else{
            document.getElementById('process_div').style.display = '';
        }
    }
</script>