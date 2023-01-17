
<cf_xml_page_edit fuseact="assetcare.form_add_care_period">
<cf_get_lang_set module_name="assetcare">
<cfparam name="attributes.station_id" default="">
<cfparam name="attributes.station_name" default="">
<cfset list_level="#session.ep.power_user_level_id#">
<!---<cfif isDefined("attributes.assetp_id")>
	<cfquery name="GET_ASSETP" datasource="#DSN#">
		SELECT ASSETP FROM ASSET_P WHERE ASSETP_ID = '#attributes.assetp_id#'
	</cfquery>
</cfif>--->
<cfquery name="get_service_code" datasource="#DSN3#">
	SELECT 
		SERVICE_CODE_ID,
		SERVICE_CODE 
	FROM 
		SETUP_SERVICE_CODE
	ORDER BY
		SERVICE_CODE
</cfquery>
<cfquery name="get_failure_using_code" datasource="#dsn3#">
	SELECT
		SETUP_SERVICE_CODE.SERVICE_CODE_ID,
		SETUP_SERVICE_CODE.SERVICE_CODE
	FROM 
		#dsn_alias#.FAILURE_CODE_ROWS FAILURE_CODE_ROWS,
		SETUP_SERVICE_CODE
	WHERE 
		FAILURE_CODE_ROWS.FAILURE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.failure_id#"> AND
		FAILURE_CODE_ROWS.FAILURE_CODE_ID = SETUP_SERVICE_CODE.SERVICE_CODE_ID
</cfquery>
<cfset get_failure_code=valuelist(get_failure_using_code.SERVICE_CODE_ID)>
<cfquery name="GET_ASSET_FAILURE" datasource="#DSN#">
	SELECT 
		ASSET_FAILURE_NOTICE.*,
		AP.ASSETP,
		AP.ASSETP_ID,
		ASSET_CARE_CAT.ASSET_CARE,
		ASSET_CARE_CAT.IS_YASAL,
		EMP.EMPLOYEE_NAME + ' ' + EMP.EMPLOYEE_SURNAME AS EMP_NAME
	FROM
		ASSET_FAILURE_NOTICE
		LEFT JOIN EMPLOYEES EMP ON EMP.EMPLOYEE_ID = ASSET_FAILURE_NOTICE.SEND_TO_ID
		LEFT JOIN ASSET_P AP ON AP.ASSETP_ID = ASSET_FAILURE_NOTICE.ASSETP_ID,
		ASSET_CARE_CAT
	WHERE
		FAILURE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.failure_id#"> AND
		ASSET_FAILURE_NOTICE.ASSET_CARE_ID = ASSET_CARE_CAT.ASSET_CARE_ID 
</cfquery>
<cfif isdefined("get_asset_failure.project_id") and  len(get_asset_failure.project_id)>
	<cfquery name="GET_PROJECT" datasource="#DSN#">
		SELECT PROJECT_HEAD,PROJECT_ID FROM PRO_PROJECTS WHERE PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_asset_failure.project_id#">
	</cfquery>
</cfif>
<cf_catalystHeader>
<form name="upd_failure" id="upd_failure" method="post" action="<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emtypopup_upd_asset_failure&failure_id=#attributes.failure_id#</cfoutput>">

        <div class="col col-9 col-xs-12">
            <cf_box>
                <cf_box_elements>
                    <div class="col col-6 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                        <div class="form-group" id="item-document_no">
                            <label class="col col-4 col-xs-12"><cf_get_lang_main no='468.Belge No'></label>
                            <div class="col col-8 col-xs-12">
                                <input name="failure_id" id="failure_id" type="hidden" value="<cfoutput>#attributes.failure_id#</cfoutput>">
                                <input name="is_detail" id="is_detail" type="hidden" value="1">
                                <input type="text" name="document_no" id="document_no" value="<cfif isdefined("get_asset_failure.document_no")><cfoutput>#get_asset_failure.document_no#</cfoutput></cfif>"/>
                            </div>
                        </div>
                        <div class="form-group" id="item-surecler">
                            <label class="col col-4 col-xs-12"><cf_get_lang_main no="1447.Süreç"></label>
                            <div class="col col-8 col-xs-12">
                                <cf_workcube_process is_upd='0' select_value='#get_asset_failure.failure_stage#' process_cat_width='145' is_detail='1'>
                            </div>
                        </div>
                        <div class="form-group" id="item-assetp_name">
                            <label class="col col-4 col-xs-12"><cf_get_lang_main no='1421.Fiziki Varlık'></label>
                            <div class="col col-8 col-xs-12">
                                <cf_wrkassetp asset_id="#get_asset_failure.assetp_id#" fieldid='assetp_id' fieldname='assetp_name' form_name='upd_failure' xmlvalue='#xml_add_care_asset#'>
                            </div>
                        </div>
                        <div class="form-group" id="item-station_id">
                            <label class="col col-4 col-xs-12"><cf_get_lang_main no ='1422.İstasyon'></label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <input type="hidden" name="station_id" id="station_id" <cfif isdefined("get_asset_failure.station_id") and len(get_asset_failure.station_id)>value="<cfoutput>#get_asset_failure.station_id#</cfoutput>"</cfif>>
                                    <input type="hidden" name="station_company_id" id="station_company_id" value="<cfoutput>#session.ep.company_id#</cfoutput>">
                                    <cfif len(get_asset_failure.station_id)>
                                        <cfset new_dsn3 = "#dsn#_#session.ep.company_id#">
                                        <cfquery name="GET_STATION" datasource="#new_dsn3#">
                                            SELECT STATION_ID, STATION_NAME FROM WORKSTATIONS WHERE STATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_asset_failure.station_id#">
                                        </cfquery>
                                            <input type="text" name="station_name" id="station_name" value="<cfoutput>#GET_STATION.STATION_NAME#</cfoutput>">
                                    <cfelse>
                                            <input type="text" name="station_name" id="station_name" value="">
                                    </cfif>
                                    <span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=prod.popup_list_workstation&field_name=upd_failure.station_name&field_id=upd_failure.station_id</cfoutput>',draggable=1)"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-care_type">
                            <label class="col col-4 col-xs-12"><cf_get_lang no='42.Bakım Tipi'></label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <input type="hidden" name="care_type_id" id="care_type_id" value="<cfoutput>#get_asset_failure.asset_care_id#</cfoutput>">
                                    <input type="text" name="care_type" id="care_type" value="<cfoutput>#get_asset_failure.asset_care#</cfoutput>">
                                    <span class="input-group-addon btnPointer icon-ellipsis" title="<cf_get_lang no='42.Bakım Tipi'>" onclick="pencere_ac();"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-failure_emp">
                            <label class="col col-4 col-xs-12"><cf_get_lang no='11.Bildiren'></label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <input type="hidden" name="failure_emp_id" id="failure_emp_id" value="<cfoutput>#get_asset_failure.failure_emp_id#</cfoutput>">
                                    <input type="text" name="failure_emp" id="failure_emp"  value="<cfif len(get_asset_failure.failure_emp_id)><cfoutput>#get_emp_info(get_asset_failure.failure_emp_id,0,0)#</cfoutput></cfif>">
                                    <span class="input-group-addon icon-ellipsis btnPointer" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=upd_failure.failure_emp_id&field_name=upd_failure.failure_emp',draggable=1);"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-project_head">
                            <label class="col col-4 col-xs-12"><cf_get_lang_main no='4.proje'></label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <input type="hidden" name="project_id" id="project_id" value="<cfif len(get_asset_failure.project_id)><cfoutput>#get_asset_failure.project_id#</cfoutput></cfif>">
                                    <input type="text" name="project_head" id="project_head"  value="<cfif len(get_asset_failure.project_id)><cfoutput>#get_asset_failure.project_id# - #get_project.project_head#</cfoutput></cfif>">
                                    <span class="input-group-addon icon-ellipsis btnPointer" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_projects&project_id=upd_failure.project_id&project_head=upd_failure.project_head');"></span>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col col-6 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                        <div class="form-group" id="item-failure_date">
                            <label class="col col-4 col-xs-12"><cf_get_lang no='8.Arıza Tarihi'></label>
                            <div class="col col-4 col-xs-6">
                                <div class="input-group">
                                    <input type="text" name="failure_date" id="failure_date" value="<cfoutput>#dateformat(get_asset_failure.failure_date,dateformat_style)#</cfoutput>" validate="#validate_style#" maxlength="10">
                                    <span class="input-group-addon"><cf_wrk_date_image date_field="failure_date"></span>
                                </div>
                            </div>
                            <cfif len(get_asset_failure.failure_date)>
                                <cfset finish_hour = hour(get_asset_failure.failure_date)>
                                <cfset finish_minute = minute(get_asset_failure.failure_date)>
                            <cfelse>
                                <cfset finish_hour = ''>
                                <cfset finish_minute = ''>
                            </cfif>
                            <div class="col col-2 col-xs-3">
                                <cfoutput>
                                <cfif datepart('h',date_add('h',session.ep.time_zone,now()))>
                                    <cf_wrkTimeFormat name="finish_clock" value="#datepart('h',date_add('h',session.ep.time_zone,now()))#" >
                                    <cfelse>
                                    <cf_wrkTimeFormat name="finish_clock" value="">
                                    </cfif>
                                </cfoutput>
                            </div>
                            <div class="col col-2 col-xs-3">
                                <cfoutput>
                                    <select name="finish_minute" id="finish_minute">
                                        <option value=""><cf_get_lang_main no='1415.Dk'></option>
                                        <cfloop from="0" to="55" step="1" index="k">
                                            <option value="#numberformat(k,00)#" <cfif finish_minute eq k> selected</cfif>>#numberformat(k,00)#</option>
                                        </cfloop>
                                    </select>
                                </cfoutput>
                            </div>
                        </div>
                        <cfif session.ep.our_company_info.guaranty_followup eq 1>
                            <div class="form-group" id="item-failure_code">
                                <label class="col col-4 col-xs-12"><cf_get_lang_main no='1522.Arıza Kodu'></label>
                                <div class="col col-8 col-xs-12">
                                    <select multiple name="failure_code" id="failure_code" style="width:176px;height:85px;">
                                        <cfoutput query="get_service_code">
                                            <option  value="#service_code_id#"
                                            <cfif len(get_failure_code) and listfindnocase(get_failure_code,SERVICE_CODE_ID)>selected</cfif>>#service_code#</option>
                                        </cfoutput>
                                    </select>
                                </div>
                            </div>
                        </cfif>
                        <div class="form-group" id="item-send_to">
                            <label class="col col-4 col-xs-12"><cf_get_lang_main no='157.Görevli'></label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <cfoutput>
                                        <input type="hidden" name="send_to_id" id="send_to_id" value="<cfoutput>#get_asset_failure.SEND_TO_ID#</cfoutput>">
                                        <input type="text" name="send_to" id="send_to" value="<cfif len(get_asset_failure.emp_name)><cfoutput>#get_asset_failure.EMP_NAME#</cfoutput></cfif>" onfocus="AutoComplete_Create('send_to','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','send_to_id','','3','125');" autocomplete="off">
                                        <span class="input-group-addon icon-ellipsis btnPointer" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=upd_failure.send_to_id&field_name=upd_failure.send_to<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&select_list=1',draggable=1);"></span>
                                    </cfoutput>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-template_id">
                            <label class="col col-4 col-xs-12"><cf_get_lang_main no ='1228.Şablon'></label>
                            <div class="col col-8 col-xs-12">
                                <cfquery name="GET_MODULE_TEMP" datasource="#DSN#">
                                    SELECT TEMPLATE_ID,TEMPLATE_HEAD FROM TEMPLATE_FORMS WHERE TEMPLATE_MODULE = 40
                                </cfquery>
                                <select name="template_id" id="template_id" onchange="document.upd_failure.action = ''; document.upd_failure.submit();">
                                    <option value="" selected><cf_get_lang_main no ='1228.Şablon'>
                                    <cfoutput query="get_module_temp">
                                        <option value="#template_id#"<cfif isDefined("attributes.template_id") and (attributes.template_id eq template_id)> selected</cfif>>#template_head#
                                    </cfoutput>
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="item-failure_head">
                            <label class="col col-4 col-xs-12"><cf_get_lang_main no='1408.Başlık'></label>
                            <div class="col col-8 col-xs-12">
                                <input type="text" name="failure_head" id="failure_head" value="<cfoutput>#get_asset_failure.NOTICE_HEAD#</cfoutput>">
                            </div>
                        </div>
                    </div>
                    <div class="col col-12 col-md-8 col-sm-12 col-xs-12" type="column" index="3" sort="true">
                        <div class="form-group" id="item-fckedit">
                            <div class="col col-12 col-xs-12">
                                <cfmodule template="/fckeditor/fckeditor.cfm" toolbarset="Basic" basepath="/fckeditor/" instancename="subject" valign="top" value="">
                            </div>
                        </div>
                    </div>
                </cf_box_elements>
                <cf_box_footer> 
                    <cf_record_info query_name="get_asset_failure">
                    <cfif fusebox.circuit eq 'assetcare'>
                        <div>
                            <input type="button" value="<cf_get_lang dictionary_id='47891.Bakım Planı Yap'>" onclick="bakim_plani_yap(1);" >
                            <input type="button" value="<cf_get_lang dictionary_id='47883.Sonuç Gir'>" onclick="bakim_plani_yap(2);">
                        </div>
                    </cfif>
                    <cfquery name="get_relation_care" datasource="#dsn#">
                        SELECT CARE_ID FROM CARE_STATES WHERE FAILURE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.failure_id#">
                    </cfquery>
                    <cfquery name="get_relation_report" datasource="#dsn#">
                        SELECT CARE_REPORT_ID FROM ASSET_CARE_REPORT WHERE FAILURE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.failure_id#">
                    </cfquery>
                    <cfif fusebox.circuit eq 'assetcare'>
                        <cfset url_del="#request.self#?fuseaction=assetcare.emptypopup_del_asset_failure&failure_id=#attributes.failure_id#">
                    <cfelse>
                        <cfset url_del="#request.self#?fuseaction=assetcare.emptypopup_del_asset_failure&failure_id=#attributes.failure_id#&correspondence=1">
                    </cfif>
                    <cfif get_relation_care.recordcount or get_relation_report.recordcount>
                        <cf_workcube_buttons is_upd='1' type_format="1" is_cancel='0' add_function='kontrol()' is_delete='0'>
                    <cfelse>
                        <cf_workcube_buttons type_format="1" is_upd='1' is_cancel='0' add_function='kontrol()' is_delete='1' delete_page_url="#url_del#">
                    </cfif>
                </cf_box_footer>
            </cf_box>
            <!--- Bakım Planı --->
            <cf_get_assetcare action_section='asset_id' action_id='#attributes.failure_id#' head="#getLang('main',1885)#" >
            <!--- Bakım Sonucu --->
            <cf_get_assetcare_report action_section='asset_id' action_id='#attributes.failure_id#' head="#getLang('assetcare',34)#" care_id='0' width="100%">
            <!--- Servis Tarihçesi--->
            <cfsavecontent variable="text"><cf_get_lang dictionary_id='60969.Bakım Tarihçesi'></cfsavecontent>
            <cf_box 
                id="History_Failure"
                title="#text#"
                box_page="#request.self#?fuseaction=assetcare.popup_ajax_failure_history&failure_id=#attributes.failure_id#"
                closable="0">
            </cf_box>
        </div>
        <div class="col col-3 col-xs-12 uniqueRow">
            <!--- Notlar --->
            <cf_get_workcube_note action_section='FAILURE_ID' action_id='#attributes.failure_id#' width="99%">
            <!--- Belgeler --->
            <cf_get_workcube_asset company_id="#session.ep.company_id#" asset_cat_id="-9" module_id='4' action_section='FAILURE_ID' action_id='#attributes.failure_id#' width="99%"><br/>
        </div>
    </div>
</form>
<script type="text/javascript">
	function kontrol()
	{
            if($('#assetp_name').val() == "")
            {
            alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='1655.Varlık'>!");
                    return false;
                }
        if($('#care_type').val() == "")
        {
        alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no='42.Bakım Tipi'>!");
            return false;
        }
        if($('#failure_head').val() == "")
        {
        alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='1408.Konu'>!");
            return false;
        }
        if($('#failure_date').val() == "")
        {
        alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>: Arıza Tarihi!");
            return false;
        }
        if(!CheckEurodate($('#failure_date').val(),"<cf_get_lang no='41.Bakım Tarihi'>"))
        {
            return false;
        }
    return process_cat_control();
	}
	
	function pencere_ac()
	{
		if (document.upd_failure.assetp_id == undefined || document.upd_failure.assetp_id.value == "")
			alert("<cf_get_lang_main no='13.uyarı'>:<cf_get_lang_main no='73.öncelik'>-varlık");
		else
			openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_care_type&field_id=upd_failure.care_type_id&field_name=upd_failure.care_type&asset_id=' + upd_failure.assetp_id.value);
	}
	function bakim_plani_yap(type)
	{
		if(type == 1)
			{
			window.location.href ='<cfoutput>#request.self#?fuseaction=assetcare.list_assetp_period&event=add&failure_id=#attributes.failure_id#</cfoutput>';
			}
		else if (type == 2)
			{
            assetp_id = document.upd_failure.assetp_id.value;
            station_id = document.upd_failure.station_id.value;
            station_company_id = document.upd_failure.station_company_id.value;
            station_name = document.upd_failure.station_name.value;
            project_id = document.upd_failure.project_id.value;
            project_head = document.upd_failure.project_head.value;
            care_type_id = document.upd_failure.care_type_id.value;
            document_no = document.upd_failure.document_no.value;
			window.location.href ='<cfoutput>#request.self#?fuseaction=assetcare.list_asset_care&event=add&failure_id=#attributes.failure_id#</cfoutput>&document_no='+document_no+'&care_type_id='+care_type_id+'&project_head='+project_head+'&project_id='+project_id+'&station_name='+station_name+'&station_company_id='+station_company_id+'&station_id='+station_id+'&assetp_id='+assetp_id;
			}
    }
    <cfif isdefined("attributes.template_id")>
		<cfset getComp = createObject("component","V16.assetcare.cfc.failure")>
		<cfset get_module_temp = getComp.get_module_temp(template_id : attributes.template_id , module_id : 40)>
        document.getElementById('subject').value = '<cfoutput>#get_module_temp.TEMPLATE_CONTENT#</cfoutput>';
    <cfelse>
        document.getElementById('subject').value = '<cfoutput>#get_asset_failure.detail#</cfoutput>';
    </cfif>
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
