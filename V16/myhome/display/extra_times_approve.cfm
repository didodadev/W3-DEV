<cf_xml_page_edit fuseact="myhome.list_my_extra_worktimes">
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
    <cfparam name="attributes.emp_name" default="get_emp_info(session.ep.userid,0,0)">
    
    <!---İzinde olan kişilerin vekalet bilgileri alınıypr --->
    <cfquery name="Get_Offtime_Valid" datasource="#dsn#">
        SELECT
            O.EMPLOYEE_ID,
            EP.POSITION_CODE
        FROM
            OFFTIME O,
            EMPLOYEE_POSITIONS EP
        WHERE
            O.EMPLOYEE_ID = EP.EMPLOYEE_ID AND
            O.VALID = 1 AND
            <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> BETWEEN O.STARTDATE AND O.FINISHDATE
    </cfquery>
    <cfif Get_Offtime_Valid.recordcount>
        <cfset Now_Offtime_PosCode = ValueList(Get_Offtime_Valid.Position_Code)>
        <cfquery name="Get_StandBy_Position1" datasource="#dsn#"><!--- Asil Kisi Izinli ise ve 1.Yedek Izinli Degilse --->
            SELECT POSITION_CODE, CANDIDATE_POS_1 FROM EMPLOYEE_POSITIONS_STANDBY WHERE POSITION_CODE IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#now_offtime_poscode#">) AND CANDIDATE_POS_1 IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#list_pos_code#">)
        </cfquery>
        <cfoutput query="Get_StandBy_Position1">
            <cfset list_pos_code = ListAppend(list_pos_code,ValueList(Get_StandBy_Position1.Position_Code))>
        </cfoutput>
        <cfquery name="Get_StandBy_Position2" datasource="#dsn#"><!--- Asil Kisi, 1.Yedek Izinli ise ve 2.Yedek Izinli Degilse --->
            SELECT POSITION_CODE, CANDIDATE_POS_1, CANDIDATE_POS_2 FROM EMPLOYEE_POSITIONS_STANDBY WHERE POSITION_CODE IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#now_offtime_poscode#">) AND CANDIDATE_POS_1 IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#now_offtime_poscode#">) AND CANDIDATE_POS_2 IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#list_pos_code#">)
        </cfquery>
        <cfoutput query="Get_StandBy_Position2">
            <cfset list_pos_code = ListAppend(list_pos_code,ValueList(Get_StandBy_Position2.Position_Code))>
        </cfoutput>
        <cfquery name="Get_StandBy_Position3" datasource="#dsn#"><!--- Asil Kisi, 1.Yedek,2.Yedek Izinli ise ve 3.Yedek Izinli Degilse --->
            SELECT POSITION_CODE, CANDIDATE_POS_1, CANDIDATE_POS_2 FROM EMPLOYEE_POSITIONS_STANDBY WHERE POSITION_CODE IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#now_offtime_poscode#">) AND CANDIDATE_POS_1 IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#now_offtime_poscode#">) AND CANDIDATE_POS_2 IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#now_offtime_poscode#">) AND CANDIDATE_POS_3 IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#list_pos_code#">)
        </cfquery>
        <cfoutput query="Get_StandBy_Position3">
            <cfset list_pos_code = ListAppend(list_pos_code,ValueList(Get_StandBy_Position3.Position_Code))>
        </cfoutput>
    </cfif>
    <cfset puantaj_gun_ = daysinmonth(now())>
    <cfset puantaj_start_ = CREATEODBCDATETIME(CREATEDATE(year(now()),month(now()),1))>
    <cfset puantaj_finish_ = CREATEODBCDATETIME(date_add("d",1,CREATEDATE(year(now()),month(now()),puantaj_gun_)))>
    <cfset gecen_ay_ = date_add("m",-1,puantaj_start_)>
    <cfif isdefined("attributes.startdate") and len(attributes.startdate)>
        <cf_date tarih="attributes.startdate">
    <cfelse>
        <cfparam name="attributes.startdate" default="">
    </cfif>
    <cfif isdefined("attributes.finishdate") and len(attributes.finishdate)>
        <cf_date tarih="attributes.finishdate">
    <cfelse>
        <cfparam name="attributes.finishdate" default="">
    </cfif>
    
    <cfquery name="get_upper_emps" datasource="#dsn#">
        SELECT EMPLOYEE_ID FROM EMPLOYEE_POSITIONS WHERE POSITION_CODE IN (#list_pos_code#)
    </cfquery>
    <cfset list_emp_ids = 0>
    <cfset list_emp_ids = listappend(valuelist(get_upper_emps.employee_id),list_emp_ids)>

    <cfquery name="get_other_ext_worktimes" datasource="#dsn#">
        SELECT
            EMPLOYEES_EXT_WORKTIMES.EWT_ID,
            EMPLOYEES_EXT_WORKTIMES.EMPLOYEE_ID,
            EMPLOYEES_EXT_WORKTIMES.START_TIME,
            EMPLOYEES_EXT_WORKTIMES.DAY_TYPE,
            EMPLOYEES_EXT_WORKTIMES.END_TIME,
            EMPLOYEES_EXT_WORKTIMES.RECORD_DATE,
            EMPLOYEES_EXT_WORKTIMES.VALIDATOR_POSITION_CODE_1,
            EMPLOYEES_EXT_WORKTIMES.VALIDATOR_POSITION_CODE_2,
            EMPLOYEES_EXT_WORKTIMES.VALID_EMPLOYEE_ID_1,
            EMPLOYEES_EXT_WORKTIMES.VALID_EMPLOYEE_ID_2,
            EMPLOYEES_EXT_WORKTIMES.VALID_1,
            EMPLOYEES_EXT_WORKTIMES.VALID_2,
            EMPLOYEES.EMPLOYEE_NAME,
            EMPLOYEES.EMPLOYEE_SURNAME,
            BRANCH.BRANCH_NAME,
            PROCESS_TYPE_ROWS.STAGE,
            EMPLOYEES_EXT_WORKTIMES.PROCESS_STAGE,
            PW.W_ID
        FROM
            PAGE_WARNINGS PW
            LEFT JOIN PAGE_WARNINGS_ACTIONS AS PWA ON PW.W_ID = PWA.WARNING_ID
            INNER JOIN EMPLOYEES_EXT_WORKTIMES ON PW.ACTION_ID = EMPLOYEES_EXT_WORKTIMES.EWT_ID
            INNER JOIN EMPLOYEES ON EMPLOYEES.EMPLOYEE_ID = EMPLOYEES_EXT_WORKTIMES.EMPLOYEE_ID
            INNER JOIN EMPLOYEES_IN_OUT ON EMPLOYEES.EMPLOYEE_ID = EMPLOYEES_IN_OUT.EMPLOYEE_ID AND EMPLOYEES_IN_OUT.IN_OUT_ID = EMPLOYEES_EXT_WORKTIMES.IN_OUT_ID
            INNER JOIN BRANCH ON EMPLOYEES_IN_OUT.BRANCH_ID = BRANCH.BRANCH_ID
            INNER JOIN PROCESS_TYPE_ROWS ON EMPLOYEES_EXT_WORKTIMES.PROCESS_STAGE = PROCESS_TYPE_ROWS.PROCESS_ROW_ID
        WHERE           
            PW.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">
            AND PW.ACTION_TABLE = 'EMPLOYEES_EXT_WORKTIMES'
            <cfif len(attributes.process_status) and (attributes.process_status eq 1 OR attributes.process_status eq 0)>
                AND EMPLOYEES_EXT_WORKTIMES.VALID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_status#">
            <cfelseif len(attributes.process_status) and attributes.process_status eq 2>
                AND EMPLOYEES_EXT_WORKTIMES.VALID IS NULL
            </cfif>
            <cfif len(attributes.process_filter)>
                AND PW.ACTION_STAGE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_filter#"> 
			    AND PWA.ACTION_STAGE_ID IS NULL
            </cfif>
        ORDER BY
            EMPLOYEES_EXT_WORKTIMES.START_TIME DESC,
            EMPLOYEES_EXT_WORKTIMES.RECORD_DATE DESC,		
            EMPLOYEES.EMPLOYEE_NAME ASC,
            EMPLOYEES.EMPLOYEE_SURNAME ASC
    </cfquery>
 <!---    <cf_box title="" closable="0" collapsable="0">
        <cfform name="list_ext_worktimes" action="#request.self#?fuseaction=myhome.extra_times_approve" method="post">
            <div class="row form-inline">
                <div class="form-group" id="item-emp_name">
                    <div class="input-group x-18">
                        <cfquery name="get_position_code" datasource="#dsn#">
                            SELECT POSITION_CODE FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#"> AND IS_MASTER = 1
                        </cfquery>
                        <input type="hidden" name="display_mode" id="display_mode" value="1">
                        <input type="hidden" name="parent_position_code" id="parent_position_code" value="<cfoutput>#get_position_code.position_code#</cfoutput>">
                        <input type="hidden" name="employee_id" id="employee_id" value="<cfoutput>#attributes.employee_id#</cfoutput>">
                        <input name="emp_name" type="text" id="emp_name" placeholder="<cfoutput>#getLang('main','164')#</cfoutput>" value="<cfif len(attributes.emp_name)><cfoutput>#get_emp_info(attributes.employee_id,0,0)#</cfoutput></cfif>">
                        <span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=list_ext_worktimes.employee_id&call_function=change_upper_pos_codes()&field_name=list_ext_worktimes.emp_name&upper_pos_code=<cfoutput>#session.ep.position_code#</cfoutput>&select_list=1','list');"></span>
                    </div>
                </div>    
                    <cfsavecontent variable="message">
                            <cf_get_lang_main no='326.Başlangıç Tarihi girmelisiniz'>
                    </cfsavecontent>
                <div class="form-group" id="item-startdate">
                    <div class="input-group x-12">
                        <cfinput type="text" name="startdate" style="width:65px;" value="#dateformat(attributes.startdate,dateformat_style)#" validate="#validate_style#" message="#message#" maxlength="10">
                        <span class="input-group-addon"><cf_wrk_date_image date_field="startdate"></span>
                    </div>
                </div>    
                    <cfsavecontent variable="message">
                        <cf_get_lang_main no='327.Bitiş Tarihi girmelisiniz'>
                </cfsavecontent>
            <div class="form-group" id="item-finishdate">
                <div class="input-group x-12">
                    <cfinput type="text" name="finishdate" style="width:65px;" value="#dateformat(attributes.finishdate,dateformat_style)#" validate="#validate_style#" message="#message#" maxlength="10">
                    <span class="input-group-addon"><cf_wrk_date_image date_field="finishdate"></span>
                </div>
            </div>    
            <div class="form-group">
                    <cf_wrk_search_button search_function='kontrol()'>
                </div>
            </div> 
        </cfform>
    </cf_box> --->
    <cfsavecontent variable="title"><cf_get_lang dictionary_id='31469.Onay Bekleyen'><cf_get_lang dictionary_id='56018.Fazla Mesailer'></cfsavecontent>
    <cf_box>
        <cfform name = "search_form" method="post" action=""> 
            <div class="ui-form-list flex-list">
                <div class="form-group">
                    <select name="process_status" id="process_status" onchange="show_hide_process()">
                        <option value="2" <cfif attributes.process_status eq 2>selected</cfif>><cf_get_lang dictionary_id='61148.İK Sürecini Bekleyenler'></option>
                        <option value="1" <cfif attributes.process_status eq 1>selected</cfif>><cf_get_lang dictionary_id='61149.IK Tarafından Onaylananlar'></option>
                        <option value="0" <cfif attributes.process_status eq 0>selected</cfif>><cf_get_lang dictionary_id='61150.IK Tarafından Red Edilenler'></option>
                        <option value="3" <cfif attributes.process_status eq 3>selected</cfif>><cf_get_lang dictionary_id='63247.Benim Onayımı Bekleyenler'></option>
                    </select>
                </div>
                <div class="form-group" style="display:none" id="process_div">
                    <cf_workcube_process is_upd='0' select_value='#attributes.process_filter#' is_select_text='1' process_cat_width='150' is_detail='0' select_name="process_filter">
                </div>
                <div class="form-group">
                    <cf_wrk_search_button button_type="4">
                </div>
            </div>
        </cfform>
    </cf_box>
    <cfform name = "setProcessForm" id="setProcessForm" method="post" action="#request.self#?fuseaction=myhome.emptypopup_upd_list_warning">
        <cf_box title="#title#" closable="0" collapsable="0">
            <cf_ajax_list>
                <div class="extra_list">
                    <thead>
                        <tr> 		 
                            <th><cf_get_lang dictionary_id='57576.Çalışan'></th>  
                            <th><cf_get_lang dictionary_id='57453.Şube'></th>
                            <th width="65"><cf_get_lang dictionary_id='57742.Tarih'></th>
                            <th width="40"><cf_get_lang dictionary_id='58467.Başlama'></th>
                            <th width="40"><cf_get_lang dictionary_id='57502.Bitiş'></th>
                            <th nowrap="nowrap"><cf_get_lang dictionary_id='31471.Fark (dk)'></th>
                            <th><cf_get_lang dictionary_id = "41129.Süreç/Aşama"></th>
                            <th width="80"><cf_get_lang dictionary_id='57982.Tür'></th>
                            <th width="65"><cf_get_lang dictionary_id='57483.Kayıt'></th>
                            <th class="header_icn_none"><span class="fa fa-pencil"></th>
                            <th><input class="checkControl" type="checkbox" id="checkAll" name="checkAll" value="0"/></th>
                        </tr>
                    </thead>
                    <tbody>
                        <cfif get_other_ext_worktimes.recordcount>
                            <cfoutput query="get_other_ext_worktimes"> 
                                <tr>		
                                    <td>#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#</td>  
                                    <td>#BRANCH_NAME#</td>
                                    <td>#dateformat(START_TIME,dateformat_style)#</td>
                                    <td>#TIMEFORMAT(START_TIME,timeformat_style)#</td>
                                    <td>#TIMEFORMAT(END_TIME,timeformat_style)#</td>
                                    <td>#datediff("n",START_TIME,END_TIME)#</td>
                                    <td><cf_workcube_process type="color-status" process_stage="#PROCESS_STAGE#"></td>
                                    <td><cfif day_type eq 0><cf_get_lang dictionary_id='31474.Normal Gün'><cfelseif day_type eq 1><cf_get_lang dictionary_id='31472.Hafta Sonu'><cfelseif day_type eq 2><cf_get_lang dictionary_id='31473.Resmi Tatil'></cfif></td>
                                    <td>#dateformat(RECORD_DATE,dateformat_style)#</td>
                                    <td align="center" width="20">
                                        <cfset ewt_id_ = contentEncryptingandDecodingAES(isEncode:1,content:EWT_ID,accountKey:'wrk')>
                                        <a href="#request.self#?fuseaction=myhome.extra_times_approve&event=upd&ewt_id=#ewt_id_#"  title="<cf_get_lang dictionary_id = "57464.Güncelle">"><i class="fa fa-pencil"></i></a>
                                    </td>
                                    <td>
                                        <cfif isdefined("w_id") and len(w_id)>
                                            <input class="checkControl" type="checkbox" name="action_list_id" id="action_list_id" value="#W_ID#"/>
                                        </cfif>
                                    </td>
                                </tr>
                            </cfoutput> 
                        <cfelse>
                            <tr> 
                                <td colspan="12"><cf_get_lang dictionary_id='57484.Kayit Bulunamadi'> !</td>
                            </tr>
                        </cfif>
                    </tbody>
                </div>
            </cf_ajax_list>
            <cfif isdefined("attributes.process_filter") and len(attributes.process_filter)>
                <cf_box_footer>
                    <div class="col col-12 col-xs-12 text-right">
                        <input type="hidden" name="approve_submit" id="approve_submit" value="1">
                         <input type="hidden" name="valid_ids" id="valid_ids" value="">
                        <input type="hidden" name="refusal_ids" id="refusal_ids" value="">
                        <input type="hidden" name="fuseaction_" id="fuseaction_" value="<cfoutput>#attributes.fuseaction#</cfoutput>">
                        <input type="hidden" name="fuseaction_reload" id="fuseaction_reload" value="<cfoutput>#attributes.fuseaction#</cfoutput>">
                        <input type="hidden" name="process_filter" id="process_filter" value="<cfoutput>#attributes.process_filter#</cfoutput>">
                        <input type="hidden" name="process_status" id="process_status" value="<cfoutput>#attributes.process_status#</cfoutput>">
                        <cfsavecontent variable="onayla"><cf_get_lang dictionary_id="58475.Onayla"></cfsavecontent>
                        <cfsavecontent variable="reddet"><cf_get_lang dictionary_id="58461.reddet"></cfsavecontent>
                        <cf_workcube_buttons extraButton="1" extraButtonText="#reddet#" extraFunction="setExtWorktimeProcess(2)" update_status="0">
                        <cf_workcube_buttons extraButton="1" extraButtonText="#onayla#" extraFunction="setExtWorktimeProcess(1)" update_status="0">
                    </div>
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
        function setExtWorktimeProcess(type){
            var controlChc = 0;
            $('.checkControl').each(function(){
                if(this.checked){
                    controlChc += 1;
                }
            });
            if(controlChc == 0){
                alert("İzin Seçiniz");
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
        function showDepartment(branch_id)	
        {
            var branch_id = document.search.branch_id.value;
            if (branch_id != "")
            {
                var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_ajax_list_hr&branch_id="+branch_id;
                AjaxPageLoad(send_address,'DEPARTMENT_PLACE',1,'İlişkili Departmanlar');
            }
        }
        function kontrol()
        {
            if(!date_check(document.list_ext_worktimes.startdate, document.list_ext_worktimes.finishdate, "<cf_get_lang dictionary_id='58862.Başlangıç Tarihi Bitiş Tarihinden Büyük Olamaz!'>") )
                return false;
            else
                return true;
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