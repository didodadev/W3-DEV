<cfparam name="attributes.station_id" default="">
<cfparam name="attributes.station_name" default="">
<cf_xml_page_edit fuseact="assetcare.form_add_asset_failure">
<cf_get_lang_set module_name="assetcare">
<cf_papers paper_type="asset_failure">
<cfset system_paper_no=paper_code & '-' & paper_number>
<cfset system_paper_no_add=paper_number>
<cfif len(paper_number)>
	<cfset asset_failure_no = system_paper_no>
<cfelse>
	<cfset asset_failure_no = ''>
</cfif>
<cfif isDefined("attributes.assetp_id") and len(attributes.assetp_id)>
	<cfquery name="GET_ASSETP" datasource="#DSN#">
		SELECT ASSETP FROM ASSET_P WHERE ASSETP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.assetp_id#">
	</cfquery>
</cfif>
<cfquery  name="GET_EMPLOYEE" datasource="#DSN#">
	SELECT EMPLOYEE_NAME+' '+EMPLOYEE_SURNAME NAME FROM EMPLOYEES WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
</cfquery>
<cfquery name="GET_SERVICE_CODE" datasource="#DSN3#">
	SELECT 
		SERVICE_CODE_ID,
		SERVICE_CODE 
	FROM 
		SETUP_SERVICE_CODE
	ORDER BY
		SERVICE_CODE
</cfquery>
<cfif LEN(send_to_pos_id)>
	<cfquery name="GET_EMP_INFO" datasource="#DSN#">
		SELECT 
			EMPLOYEE_NAME + ' '+ EMPLOYEE_SURNAME AS 'EMP_NAME' 
		FROM 
			EMPLOYEES
		WHERE
			EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#send_to_pos_id#">
	</cfquery>
</cfif>
<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cfsavecontent variable="title"><cf_get_lang dictionary_id='51048.Arıza Bildirimleri'></cfsavecontent>
	<cf_box title="#title#">
		<form name="add_failure" id="add_failure" method="post"action="<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#</cfoutput>.emtypopup_add_asset_failue">
			<cf_box_elements>
				<input name="is_detail" id="is_detail" type="hidden" value="1">
				<div class="col col-6 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
					<div class="form-group" id="item-document_no">
						<label class="col col-4 col-xs-12"><cf_get_lang_main no='468.Belge No'></label>
						<div class="col col-8 col-xs-12">
							<input type="text" name="document_no" id="document_no" value="<cfoutput>#asset_failure_no#</cfoutput>"/>
						</div>
					</div>
					<div class="form-group" id="item-surecler">
						<label class="col col-4 col-xs-12"><cf_get_lang_main no="1447.Süreç"></label>
						<div class="col col-8 col-xs-12">
							<cf_workcube_process is_upd='0' process_cat_width='145' is_detail='0'>
						</div>
					</div>
					<div class="form-group" id="item-assetp_name">
						<label class="col col-4 col-xs-12"><cf_get_lang_main no='1421.Fiziki Varlık'></label>
						<div class="col col-8 col-xs-12">
							<cfif x_km_record eq 1 or x_counter eq 1>
								<cf_wrkAssetp fieldId='assetp_id' fieldName='assetp_name' form_name='add_failure' width='145' call_function_name='find_value'><!--- xmlvalue='#xml_add_care_asset#' --->
							<cfelse>
								<cf_wrkAssetp fieldId='assetp_id' fieldName='assetp_name' form_name='add_failure' width='145'>
							</cfif>
						</div>
					</div>
					<div class="form-group" id="item-station_id">
						<label class="col col-4 col-xs-12"><cf_get_lang_main no ='1422.İstasyon'></label>
						<div class="col col-8 col-xs-12">
							<div class="input-group">
								<input type="hidden" name="station_id" id="station_id" value="">
								<input type="hidden" name="station_company_id" id="station_company_id" value="<cfoutput>#session.ep.company_id#</cfoutput>">
								<input type="text" name="station_name" id="station_name"  value="">
								<span class="input-group-addon icon-ellipsis btnPointer" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=prod.popup_list_workstation&field_name=add_failure.station_name&field_id=add_failure.station_id&draggable=1</cfoutput>')"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-care_type">
						<label class="col col-4 col-xs-12"><cf_get_lang no='42.Bakım Tipi'></label>
						<div class="col col-8 col-xs-12">
							<div class="input-group">
								<input type="hidden" name="care_type_id" id="care_type_id" value="">
								<input type="text" name="care_type" id="care_type" readonly>
								<span class="input-group-addon icon-ellipsis btnPointer" title="<cf_get_lang no='42.Bakım Tipi'>" onClick="pencere_ac();"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-failure_emp">
						<label class="col col-4 col-xs-12"><cf_get_lang no='11.Bildiren'></label>
						<div class="col col-8 col-xs-12">
							<div class="input-group">
								<input type="hidden" name="failure_emp_id" id="failure_emp_id" value="<cfoutput>#session.ep.userid#</cfoutput>">
								<input type="text" name="failure_emp" id="failure_emp" value="<cfoutput>#get_employee.name#</cfoutput>">
								<span class="input-group-addon icon-ellipsis btnPointer" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=add_failure.failure_emp_id&field_name=add_failure.failure_emp&draggable=1');"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-project_head">
						<label class="col col-4 col-xs-12"><cf_get_lang_main no='4.proje'></label>
						<div class="col col-8 col-xs-12">
							<div class="input-group">
								<input type="hidden" name="project_id" id="project_id" value="<cfif isdefined("attributes.prj_id")><cfoutput>#get_project.project_id#</cfoutput></cfif>">
								<input type="text" name="project_head" id="project_head"   value="<cfif isdefined("attributes.prj_id")><cfoutput>#get_project.project_id# - #get_project.project_head#</cfoutput></cfif>">
								<span class="input-group-addon icon-ellipsis btnPointer" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_projects&project_id=add_failure.project_id&project_head=add_failure.project_head');"></span>
							</div>
						</div>
					</div>
					<div class="motorized_vehicle1" id="motorized_vehicle1" style="display: none">
						<div class="form-group" id="item-m_v_previous_km">
							<label class="col col-4 col-xs-12"><cf_get_lang no='74.Araç Önceki_km'></label>
							<div class="col col-8 col-xs-12">
								<input type="text" id="m_v_previous_km" name="m_v_previous_km" readonly="readonly" value="">
							</div>
						</div>
						<div class="form-group" id="item-m_v_previous_date">
							<label class="col col-4 col-xs-12" id="item-m_v_last_km"></label>
							<div class="col col-8 col-xs-12">
								<input type="text" id="m_v_previous_date" readonly="readonly" name="m_v_previous_date"  value="">
							</div>
						</div>
					</div>
				</div>
				<div class="col col-6 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
					<div class="form-group" id="item-failure_date">
						<label class="col col-4 col-xs-12"><cf_get_lang no='8.Arıza Tarihi'></label>
						<div class="col col-4 col-xs-6">
							<div class="input-group">
								<input type="text" name="failure_date" id="failure_date" validate="#validate_style#" maxlength="10" value="<cfoutput>#dateformat(now(),dateformat_style)#</cfoutput>">
								<span class="input-group-addon"><cf_wrk_date_image date_field="failure_date"></span>
							</div>
						</div>
						<div class="col col-2 col-xs-3">
							<cfoutput>
								<cf_wrkTimeFormat name="finish_clock" value="#datepart('h',date_add('n',session.ep.time_zone,now()))#">
							</cfoutput>
						</div>
						<div class="col col-2 col-xs-3">
						<cfoutput>
							<select name="finish_minute" id="finish_minute">
								<option value=""><cf_get_lang_main no='1415.Dk'></option>
								<cfloop from="0" to="59" step="1" index="k">
									<option value="#numberformat(k,00)#" <cfif datepart('n',date_add('n',session.ep.time_zone,now())) eq k>selected="selected"</cfif>>#numberformat(k,00)#</option>
								</cfloop>
							</select>
						</cfoutput>
						</div>
					</div>
					<div class="form-group" id="item-failure_code">
						<label class="col col-4 col-xs-12"><cf_get_lang_main no='1522.Arıza Kodu'></label>
						<div class="col col-8 col-xs-12">
							<cfif session.ep.our_company_info.guaranty_followup eq 1>
								<select multiple name="failure_code" id="failure_code">
									<cfoutput query="get_service_code">
										<option value="#service_code_id#">#service_code#</option>
									</cfoutput>
								</select>
							</cfif>
						</div>
					</div>
					<div class="form-group" id="item-send_to">
						<label class="col col-4 col-xs-12"><cf_get_lang_main no='512.Kime'></label>
						<div class="col col-8 col-xs-12">
							<div class="input-group">
								<cfoutput>
									<cfif len(send_to_pos_id) >
										<input type="hidden" name="send_to_id" id="send_to_id" value="#send_to_pos_id#">
										<input type="text" name="send_to" id="send_to" value="#GET_EMP_INFO.EMP_NAME#" onFocus="AutoComplete_Create('send_to','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','send_to_id','','3','125');" autocomplete="off">
										<span class="input-group-addon icon-ellipsis btnPointer" onClick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=add_failure.send_to_id&field_name=add_failure.send_to<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&select_list=1&draggable=1');"></span>
									<cfelse>
										<input type="hidden" name="send_to_id" id="send_to_id" value="">
										<input type="text" name="send_to" id="send_to" value="" onFocus="AutoComplete_Create('send_to','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','send_to_id','','3','125');" autocomplete="off">
										<span class="input-group-addon icon-ellipsis btnPointer" onClick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=add_failure.send_to_id&field_name=add_failure.send_to<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&select_list=1&draggable=1');"></span>
									</cfif>
								</cfoutput>
							</div>
						</div>
					</div>
					<div class="motorized_vehicle1" id="motorized_vehicle1" style="display: none">
						<div class="form-group" id="item-m_v_last_km">
							<label class="col col-4 col-xs-12"><cf_get_lang no='83.Araç Son Km'></label>
							<div class="col col-8 col-xs-12">
								<input type="text" id="m_v_last_km" name="m_v_last_km" onchange="control_value();" onkeyup="IsNumber(this);" value="">
							</div>
						</div>
						<div class="form-group" id="item-m_v_last_date">
							<label class="col col-4 col-xs-12"><cf_get_lang no='80.Araç Son Km Tarihi'></label>
							<div class="col col-8 col-xs-12">
								<input type="text" id="m_v_last_date" name="m_v_last_date" readonly="readonly" value="<cfoutput>#dateformat(now(),dateformat_style)#</cfoutput>">
							</div>
						</div>
					</div>
					<div class="form-group" id="item-template_id">
						<label class="col col-4 col-xs-12"><cf_get_lang_main no ='1228.Şablon'></label>
						<div class="col col-8 col-xs-12">
							<cfquery name="GET_MODULE_TEMP" datasource="#DSN#">
								SELECT TEMPLATE_ID,TEMPLATE_HEAD FROM TEMPLATE_FORMS WHERE TEMPLATE_MODULE = 40
							</cfquery>
							<select name="template_id" id="template_id" onchange="document.add_failure.action = ''; document.add_failure.submit();">
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
							<input type="text" name="failure_head" id="failure_head" value="">
						</div>
					</div>
				</div>
				<div class="col col-12 col-md-8 col-sm-12 col-xs-12" type="column" index="3" sort="true">
					<div class="form-group" id="item-fckedit">
						<div class="col col-12 col-xs-12">
							<cfmodule template="/fckeditor/fckeditor.cfm" toolbarset="Basic" basepath="/fckeditor/" instancename="failure_detail" valign="top" value="">
						</div>
					</div>
				</div>
			</cf_box_elements>
			<cf_box_footer><cf_workcube_buttons is_upd='0' type_format="1" is_cancel='1' add_function='kontrol()'></cf_box_footer>
		</form>
	</cf_box>
</div>
<script type="text/javascript">
	function kontrol()
	{
    if($('#assetp_id').val() == "")
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
	alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='1408.Başlık'>!");
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
	if($('#document_no').val() == "")
	{
	alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>: Belge Numarası!");
		return false;
	}
	<cfif x_km_record eq 1>
    if($('#assetp_id').val()!=''&& $('#m_v_last_km').val()=='' && document.getElementById('motorized_vehicle2').style.display=='')
    {
    alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no='219.Son Km'>");
            return false;
        }
</cfif>
    return process_cat_control();
	}
	function pencere_ac()
	{
	<!---	if (document.getElementById('assetp_id').value==undefined || document.getElementById('assetp_id').value == "")
			alert("<cf_get_lang_main no='13.uyarı'>:<cf_get_lang_main no='73.öncelik'>-varlık");
		else--->
		openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_care_type&field_id=add_failure.care_type_id&field_name=add_failure.care_type&draggable=1&asset_id=' + add_failure.assetp_id.value);
	}
	function find_value()
	{
		getAssetCat=wrk_query('SELECT TOP 1  ASSET_P_CAT.MOTORIZED_VEHICLE,ASSET_P_KM_CONTROL.KM_FINISH,ASSET_P_KM_CONTROL.FINISH_DATE FROM  ASSET_P,ASSET_P_CAT,ASSET_P_KM_CONTROL WHERE ASSET_P_CAT.ASSETP_CATID = ASSET_P.ASSETP_CATID AND ASSET_P.ASSETP_ID=ASSET_P_KM_CONTROL.ASSETP_ID AND ASSET_P.ASSETP_ID='+document.getElementById('assetp_id').value+' ORDER BY KM_CONTROL_ID DESC','dsn');
		if(getAssetCat.MOTORIZED_VEHICLE==1)
		{
			document.getElementById('motorized_vehicle1').style.display='';
			//İlk önce boşaltılır..
			$('#m_v_previous_km').val("");
			$('#m_v_previous_date').val("");
			//query de ki değerler okutulur.
			$('#m_v_previous_km').val(getAssetCat.KM_FINISH);
			document.getElementById('m_v_previous_date').value=getAssetCat.FINISH_DATE;
			document.getElementById('m_v_previous_date').value=document.getElementById('m_v_previous_date').value.substring(8,10)+"/"+document.getElementById('m_v_previous_date').value.substring(5,7)+"/"+document.getElementById('m_v_previous_date').value.substring(0,4);
			// son km girilen textbox
			<cfif x_km_record eq 1>
				document.getElementById('motorized_vehicle2').style.display='';
			</cfif>
		}
		else
		{
			document.getElementById('motorized_vehicle1').style.display='none';
			document.getElementById('motorized_vehicle2').style.display='none';
		}
	}
	function control_value()
	{
	//parselleme yaparak al jquer ile.!!
		if(parseInt(document.getElementById('m_v_last_km').value) < parseInt(document.getElementById('m_v_previous_km').value))
		{
			alert("Son Km Önceki Km Büyük Olmalıdır!");
			$('#m_v_last_km').val("");
		}
	}
	<cfif isdefined("attributes.template_id")>
		<cfset getComp = createObject("component","V16.assetcare.cfc.failure")>
		<cfset get_module_temp = getComp.get_module_temp(template_id : attributes.template_id , module_id : 40)>
		document.getElementById('failure_detail').value = '<cfoutput>#get_module_temp.TEMPLATE_CONTENT#</cfoutput>';	
	</cfif>
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">

