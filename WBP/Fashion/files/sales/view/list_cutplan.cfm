<cfparam name="attributes.page" default="1">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.req_no" default="">
<cfparam name="attributes.order_no" default="">
<cfparam name="attributes.emp_id" default="">
<cfparam name="attributes.emp_name" default="">
<cfparam name="attributes.process_stage" default="">
<cfparam name="attributes.not_is_task" default="">
<cfparam name="attributes.project_id" default="">
<cfparam name="attributes.project_title" default="">
<cfparam name="attributes.date_start" default="">
<cfparam name="attributes.date_end" default="">

<cfobject name="cutplan" component="WBP.Fashion.files.cfc.cutplan">
<cfif isdefined("attributes.is_filtre")>
    <cfset query_cutplans = cutplan.list_cutplan(
        attributes.req_no,
        attributes.order_no,
        attributes.emp_id,
        attributes.emp_name,
        attributes.process_stage,
        attributes.not_is_task,
        attributes.project_id,
        attributes.date_start,
        attributes.date_end
    )>
<cfelse>
    <cfset query_cutplans.recordcount = 0>
</cfif>
<cfparam name="attributes.totalrecords" default='#query_cutplans.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cfset header = "Kesim Plan Listesi">
        <cfform name="list_#listlast(attributes.fuseaction,'.')#" method="post">
            <input type="hidden" name="is_filtre" id="is_filtre" value="1">
            <cf_box_search plus="0">
                <div class="form-group" id="form-opp_id">
                    <cfinput type="text" name="req_no" id="req_no" value="#attributes.req_no#" placeholder="#getLang('','Numune Numarası',62136)#">
                </div>
                    <div class="form-group" id="form-order_no">
                    <cfinput type="text" name="order_no" id="order_no" value="#attributes.order_no#" placeholder="#getLang('','Emir No',29474)#">
                </div>
                    <div class="form-group" id="form-task_emp_id">
                    <div class="input-group">
                        <cfinput type="hidden" name="emp_id" id="emp_id"  value="#attributes.emp_id#">
                        <cfinput type="text" name="emp_name" id="emp_name" placeholder="#getLang('','Görevli',44021)#" value="#attributes.emp_name#"  onFocus="AutoComplete_Create('emp_name','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_PARTNER_NAME2,MEMBER_NAME2','get_member_autocomplete','\'1,3\',0,0,0','PARTNER_ID,EMPLOYEE_ID','outsrc_partner_id,emp_id','plan','3','250');">
                        <!--- <span class="input-group-addon icon-ellipsis" onclick="javascript:gonder2('list_fabric_price.emp_name');"></span> --->
                        <span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('<cfoutput>index.cfm?fuseaction=objects.popup_list_positions&field_emp_id=list_#listlast(attributes.fuseaction,'.')#.emp_id&field_name=list_#listlast(attributes.fuseaction,'.')#.emp_name &select_list=1,2&is_form_submitted=1&keyword='+encodeURIComponent(list_#listlast(attributes.fuseaction,'.')#.emp_name.value)</cfoutput>);"></span>
                    </div>
                </div>
                <cfquery name="get_process_type" datasource="#dsn#">
                    SELECT
                        PTR.STAGE,
                        PTR.PROCESS_ROW_ID
                    FROM
                        PROCESS_TYPE_ROWS PTR,
                        PROCESS_TYPE_OUR_COMPANY PTO,
                        PROCESS_TYPE PT
                    WHERE
                        PT.IS_ACTIVE = 1 AND
                        PT.PROCESS_ID = PTR.PROCESS_ID AND
                        PT.PROCESS_ID = PTO.PROCESS_ID AND
                        PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
                        PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.fuseaction#%">
                    ORDER BY
                        PTR.LINE_NUMBER
                </cfquery>
                <div class="form-group medium" id="form-stage">
                    <cf_multiselect_check
                        name="process_stage"
                        query_name="get_process_type"
                        option_name="stage"
                        option_value="process_row_id"
                        option_text="#getLang('','Süreç',58859)#"
                        value="#attributes.process_stage#">
                </div>
                <div class="form-group" id="form-task_emp_id">
                    <div class="input-group">
                        <label><cf_get_lang dictionary_id='62558.Görev atanmamış kayıtlar'> <input type="checkbox" name="not_is_task" <cfif isDefined("attributes.not_is_task")>checked</cfif> value="" class="checkbox"> 
                        </label> 
                    </div>
                </div>
                <div class="form-group small">
                    <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#getLang('','Kayıt Sayısı Hatalı',57537)#" maxlength="3">
                </div>
                <div class="form-group">
                    <cf_wrk_search_button button_type="4">
                    <cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'>
                </div>
                <div class="form-group">
                    <a class="ui-btn ui-btn-gray2" href="<cfoutput>#request.self#</cfoutput>?fuseaction=textile.list_sample_request&event=dashboard"><i class="fa fa-bar-chart fa-2x" aria-hidden="true" title="<cf_get_lang dictionary_id='62574.Numune Dashboard'>" alt="<cf_get_lang dictionary_id='62574.Numune Dashboard'>"></i></a>
                </div>
            </cf_box_search>
            <cf_box_search_detail>
                <cfoutput>
                    <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                        <div class="form-group" id="item-project_id">
                            <label class="col col-12"><cf_get_lang dictionary_id='57416.Proje'> <cf_get_lang dictionary_id='57487.No'></label>
                            <div class="col col-12">
                                <div class="input-group">
                                    <input type="hidden" name="project_id" id="project_id" value="#attributes.project_id#">
                                    <input type="text" name="project_title" id="project_title" value="#attributes.project_title#" onfocus="AutoComplete_Create('project_title','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','','3','200');" autocomplete="off">
                                    <span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('index.cfm?fuseaction=objects.popup_list_projects&amp;project_id=list_stretching_test.project_id&amp;project_head=list_stretching_test.project_title');"></span>
                                </div>
                            </div>
                        </div>

                    </div>
                    <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                        <div class="form-group" id="item-test_date_start">
                            <label class="col col-12"><cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></label>
                            <div class="col col-12">
                                <div class="input-group">
                                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='57782.Tarih Değerini Kontrol Ediniz'></cfsavecontent>
                                    <cfinput type="text" name="date_start" id="date_start" value="#dateformat(attributes.date_start,dateformat_style)#" validate="#validate_style#" maxlength="10" message="#message#">
                                    <span class="input-group-addon"><cf_wrk_date_image date_field="date_start"></span>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
                        <div class="form-group" id="item-test_date_end">
                            <label class="col col-12"><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></label>
                            <div class="col col-12">
                                <div class="input-group">
                                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='57782.Tarih Değerini Kontrol Ediniz'></cfsavecontent>
                                    <cfinput type="text" name="date_end" id="date_end" value="#dateformat(attributes.date_end,dateformat_style)#" validate="#validate_style#" maxlength="10" message="#message#">
                                    <span class="input-group-addon"><cf_wrk_date_image date_field="date_end"></span>
                                </div>
                            </div>
                        </div>
                    </div>
                </cfoutput>
            </cf_box_search_detail>
        </cfform>
    </cf_box>
    <cf_box title="#getLang('','Kesim Plan Listesi',62562)#" uidrop="1" hide_table_column="1">
        <cf_grid_list>
            <thead>
                <tr>
                    <th><cf_get_lang dictionary_id='58080.Resim'></th>
                    <th><cf_get_lang dictionary_id='62559.Kesim No'></th>
                    <th><cf_get_lang dictionary_id="57742.Tarih"></th>
                    <th><cf_get_lang dictionary_id='62560.Numune Talep No'></th>
                    <th><cf_get_lang dictionary_id='62561.Müşteri Order No'></th>
                    <th><cf_get_lang dictionary_id='58859.Süreç'></th>
                    <th><cf_get_lang dictionary_id='57457.Müşteri'></th>
                    <th><cf_get_lang dictionary_id='57416.Proje'> <cf_get_lang dictionary_id='57487.No'></th>
                    <th><cf_get_lang dictionary_id='57569.Görevli'></th>
                    <th><cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></th>
                    <th><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></th>
                    <th width="20" class="header_icn_none text-center"></th>
                </tr>
            </thead>
            <tbody>
                <cfif query_cutplans.recordcount>
                <cfoutput query="query_cutplans" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                    <tr>
                        
                        <td>
                        <div>
                            <div class="image">
                                <cfif len(MEASURE_FILENAME)>
                                    <img src="documents/assets/#MEASURE_FILENAME#" style="margin-left: 10px; width:70px; height:50px;" class="img-thumbnail">
                                <cfelse>
                                <img src="images/intranet/no-image.png" style="margin-left: 10px; width:70px; height:50px;" class="img-thumbnail">
                                </cfif>
                            </div>
                        </div>
                        </td>
                        <td><a style="color: blue;" href="#request.self#?fuseaction=#attributes.fuseaction#&event=add&id=#CUTPLAN_ID#">KP-#CUTPLAN_ID#</a></td>
                        <td>#dateFormat( PLAN_DATE, dateformat_style )#</td>
                        <td>#REQ_NO#</td>
                        <td>#ORDER_NUMBER#</td>
                        <td>#STAGE#</td>
                        <td>#COMPANY_NAME#</td>
                        <td>#PROJECT_HEAD#</td>
                        <td>#EMP_NAME#</td>
                        <td>#dateformat(START_DATE, dateformat_style)#</td>
                        <td>#dateformat(FINISH_DATE, dateformat_style)#</td>
                        <td><a href="#request.self#?fuseaction=#attributes.fuseaction#&event=add&id=#CUTPLAN_ID#"><i class="fa fa-edit fa-2x"></i></a></td>
                    </tr>
                </cfoutput>
                <cfelse>
                    <tr>
                        <td colspan="12"><cfif isdefined("attributes.is_filtre")><cf_get_lang dictionary_id='57484.Kayıt Yok'>!<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'>!</cfif></td>
                    </tr>
                </cfif>
            </tbody>
        </cf_grid_list>
        <cfset url_str = "&is_filtre=1">
        <cfif len(attributes.req_no)>
            <cfset url_str = url_str & "&req_no=" & attributes.req_no> 
        </cfif>
        <cfif len(attributes.order_no)>
            <cfset url_str = url_str & "&order_no=" & attributes.order_no> 
        </cfif>
        <cfif len(attributes.emp_id)>
            <cfset url_str = url_str & "&emp_id=" & attributes.emp_id> 
        </cfif>
        <cfif len(attributes.emp_name)>
            <cfset url_str = url_str & "&emp_name=" & attributes.emp_name> 
        </cfif>
        <cfif len(attributes.process_stage)>
            <cfset url_str = url_str & "&process_stage=" & attributes.process_stage> 
        </cfif>
        <cfif len(attributes.project_id)>
            <cfset url_str = url_str & "&project_id=" & attributes.project_id> 
        </cfif>
        <cfif len(attributes.not_is_task)>
            <cfset url_str = url_str & "&not_is_task=" & attributes.not_is_task> 
        </cfif>
        <cfif len(attributes.project_title)>
            <cfset url_str = url_str & "&project_title=" & attributes.project_title> 
        </cfif>
        <cfif len(attributes.date_start)>
            <cfset url_str = url_str & "&date_start=" & attributes.date_start> 
        </cfif>
        <cfif len(attributes.date_end)>
            <cfset url_str = url_str & "&date_end=" & attributes.date_end> 
        </cfif>
        <cfif query_cutplans.recordcount and ( attributes.totalrecords gt attributes.maxrows )>
            <cf_paging 
                page="#attributes.page#"
                maxrows="#attributes.maxrows#"
                totalrecords="#attributes.totalrecords#"
                startrow="#attributes.startrow#"
                adres="textile.cutplan#url_str#">
        </cfif>
    </cf_box>
</div>
<script>
    $(document).ready(function() {
        $("#big_list_search_image .icon-pluss").hide();
    });
</script>