
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

<cfif isdefined("attributes.employee_id") and len(attributes.employee_id)>
    <cfparam name="attributes.employee_id" default="#attributes.employee_id#">
<cfelse>
    <cfparam name="attributes.employee_id" default="#session.ep.userid#">
</cfif>
<cfparam name="attributes.emp_name" default="#get_emp_info(session.ep.userid,0,0)#">
<cfif isdefined("attributes.departure_date") and len(attributes.departure_date)>
    <cf_date tarih="attributes.departure_date">
<cfelse>
    <cfparam name="attributes.departure_date" default="">
</cfif>
<cfif isdefined("attributes.departure_of_date") and len(attributes.departure_of_date)>
    <cf_date tarih="attributes.departure_of_date">
<cfelse>
    <cfparam name="attributes.departure_of_date" default="">
</cfif>
<cfquery name="get_upper_emps" datasource="#dsn#">
    SELECT EMPLOYEE_ID FROM EMPLOYEE_POSITIONS WHERE POSITION_CODE IN (#list_pos_code#)
</cfquery>
<cfset list_emp_ids = 0>
<cfset list_emp_ids = listappend(valuelist(get_upper_emps.employee_id),list_emp_ids)>
<cfquery name="get_travel_demand_approve" datasource="#dsn#">
    SELECT
        ETD.TRAVEL_DEMAND_ID,
        ETD.EMPLOYEE_ID,
        ETD.DEPARTURE_DATE,
        ETD.DEPARTURE_OF_DATE,
        ETD.RECORD_DATE,
        ETD.MANAGER1_POS_CODE,
        ETD.MANAGER1_EMP_ID,
        ETD.MANAGER1_VALID,
        ETD.MANAGER2_POS_CODE,
        ETD.MANAGER2_EMP_ID,
        ETD.MANAGER2_VALID,
        EMPLOYEES.EMPLOYEE_NAME,
        EMPLOYEES.EMPLOYEE_SURNAME,
        BRANCH.BRANCH_NAME,
        PROCESS_TYPE_ROWS.STAGE,
        ETD.DEMAND_STAGE,
        BRANCH.BRANCH_NAME,
        PW.W_ID
    FROM
        PAGE_WARNINGS PW
        LEFT JOIN PAGE_WARNINGS_ACTIONS AS PWA ON PW.W_ID = PWA.WARNING_ID
        INNER JOIN EMPLOYEES_TRAVEL_DEMAND ETD ON PW.ACTION_ID = ETD.TRAVEL_DEMAND_ID
        INNER JOIN EMPLOYEES ON EMPLOYEES.EMPLOYEE_ID = ETD.EMPLOYEE_ID
        INNER JOIN EMPLOYEES_IN_OUT ON EMPLOYEES.EMPLOYEE_ID = EMPLOYEES_IN_OUT.EMPLOYEE_ID
        INNER JOIN BRANCH ON EMPLOYEES_IN_OUT.BRANCH_ID = BRANCH.BRANCH_ID
        INNER JOIN PROCESS_TYPE_ROWS ON ETD.DEMAND_STAGE = PROCESS_TYPE_ROWS.PROCESS_ROW_ID
    WHERE           
        PW.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">
        AND PW.ACTION_TABLE = 'EMPLOYEES_TRAVEL_DEMAND'
        <cfif len(attributes.process_status) and (attributes.process_status eq 1 OR attributes.process_status eq 0)>
            AND ETD.VALID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_status#">
        <cfelseif len(attributes.process_status) and attributes.process_status eq 2>
            AND ETD.VALID IS NULL
        </cfif>
        <cfif len(attributes.process_filter)>
            AND PW.ACTION_STAGE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_filter#"> 
            AND PWA.ACTION_STAGE_ID IS NULL
        </cfif>
    ORDER BY
        ETD.DEPARTURE_DATE DESC,
        ETD.RECORD_DATE DESC,		
        EMPLOYEES.EMPLOYEE_NAME ASC,
        EMPLOYEES.EMPLOYEE_SURNAME ASC
</cfquery>
<cfsavecontent variable="title"><cf_get_lang dictionary_id="37233.Onay Bekleyen"><cf_get_lang dictionary_id="49729.Seyahat Talepleri"></cfsavecontent>
<cf_box>
    <cfform name = "search_form" method="post" action=""> 
        <cf_box_search more="0">
            <div class="form-group">
                <select name="process_status" id="process_status" onchange="show_hide_process()">
                    <option value="2" <cfif attributes.process_status eq 2>selected</cfif>>İK Sürecini Bekleyenler</option>
                    <option value="1" <cfif attributes.process_status eq 1>selected</cfif>>IK Tarafından Onaylananlar</option>
                    <option value="0" <cfif attributes.process_status eq 0>selected</cfif>>IK Tarafından Red Edilenler</option>
                    <option value="3" <cfif attributes.process_status eq 3>selected</cfif>>Benim Onayımı Bekleyenler</option>
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
<!--- Onay Bekleyen Seyahat Talepleri--->
<cfform name = "setProcessForm" id="setProcessForm" method="post" action="#request.self#?fuseaction=myhome.emptypopup_upd_list_warning">
    <cf_box title="#title#" closable="0" collapsable="0">
        <cf_flat_list>
                <thead>
                    <tr>
                        <th width="20"><cf_get_lang dictionary_id='57487.No'></th>
                        <th><cf_get_lang dictionary_id='57570.Ad Soyad'></th>
                        <th><cf_get_lang dictionary_id='57453.Şube'></th>                                    
                        <th><cf_get_lang dictionary_id='45410.Gidiş Tarihi'></th>
                        <th><cf_get_lang dictionary_id='45408.Dönüş Tarihi'></th>
                        <th><cf_get_lang dictionary_id='57482.Aşama'></th>
                        <th  width="20" class="header_icn_none"><i class="fa fa-pencil"></i></th>
                        <th  width="20"><input class="checkControl" type="checkbox" id="checkAll" name="checkAll" value="0"/></th>                               
                    </tr>
                </thead>
                <tbody>
                    <cfif get_travel_demand_approve.recordcount>
                        <cfoutput query="get_travel_demand_approve">
                            <tr>
                                <td width="20">#currentrow#</td>
                                <td>#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#</td>
                                <td>#branch_name#</td>
                                <td>#dateformat(DEPARTURE_DATE,dateformat_style)#</td>
                                <td>#dateformat(DEPARTURE_OF_DATE,dateformat_style)#</td>
                                <td><cf_workcube_process type="color-status" process_stage="#DEMAND_STAGE#"></td>                               
                                <td width="20"><a href="#request.self#?fuseaction=myhome.travel_demand_approve&event=upd&TRAVEL_DEMAND_ID=#TRAVEL_DEMAND_ID#"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='30923.İzin Güncelle'>"></a></td>
                                <td width="20">
                                    <input class="checkControl" type="checkbox" name="action_list_id" id="action_list_id" value="#W_ID#"/>
                                </td>
                            </tr>
                        </cfoutput>
                    <cfelse>
                        <tr> 
                            <td colspan="17"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
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
                    <cf_workcube_buttons extraButton="1" extraButtonText="#reddet#" extraFunction="setTravelDemandProcess(2)" update_status="0">
                    <cf_workcube_buttons extraButton="1" extraButtonText="#onayla#" extraFunction="setTravelDemandProcess(1)" update_status="0">
            </cf_box_footer>
        </cfif>
    </cf_box>
</cfform>
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
            function setTravelDemandProcess(type){
                var controlChc = 0;
                $('.checkControl').each(function(){
                    if(this.checked){
                        controlChc += 1;
                    }
                });
                if(controlChc == 0){
                    alert("<cf_get_lang dictionary_id="59973.Seyahat"><cf_get_lang dictionary_id="57734.Seçiniz">");
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