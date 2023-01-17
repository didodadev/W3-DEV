<cf_xml_page_edit fuseact="process.upd_process">
<cfquery name="GET_PROCESS" datasource="#DSN#">
	SELECT #dsn#.Get_Dynamic_Language(PROCESS_ID,'#session.ep.language#','PROCESS_TYPE','PROCESS_NAME',NULL,NULL,PROCESS_NAME) AS PROCESS_NAME,* FROM PROCESS_TYPE WHERE PROCESS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_id#">
</cfquery>
<cfquery name="Get_Our_Company" datasource="#dsn#">
	SELECT COMP_ID, NICK_NAME FROM OUR_COMPANY ORDER BY NICK_NAME
</cfquery>
<cfquery name="Get_Process_Type_Our_Company" datasource="#dsn#"><!--- Ilıskili Sirketler --->
	SELECT OUR_COMPANY_ID FROM PROCESS_TYPE_OUR_COMPANY WHERE PROCESS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_id#">
</cfquery>
<cfset Process_Our_Comp_List = ValueList(Get_Process_Type_Our_Company.Our_Company_Id,',')>
<cf_catalystHeader>
<div style="display:none;z-index:999;" id="history"></div>
<div style="display:none;z-index:999;" id="process_templates"></div>
<div style="display:none;z-index:999;" id="folder"></div>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cfsavecontent  variable="head"><cf_get_lang dictionary_id='36203.Süreç Tasarım'></cfsavecontent>
	<cf_box title="#head#">
	<cfform name="upd_process" method="post" enctype="multipart/form-data" action="#request.self#?fuseaction=process.emptypopup_upd_process">
		<cfparam name="attributes.item_process_main_id" default="">
	
		<cfquery name="get_general_processes" datasource="#dsn#">
			SELECT
				PM.PROCESS_MAIN_ID,
				#dsn#.Get_Dynamic_Language(PROCESS_MAIN_ID,'#session.ep.language#','PROCESS_MAIN','PROCESS_MAIN_HEADER',NULL,NULL,PROCESS_MAIN_HEADER) AS PROCESS_MAIN_HEADER,
				PM.PROJECT_ID
			FROM
				PROCESS_MAIN PM
		</cfquery>
		<cfquery name="get_general_item_processes" datasource="#DSN#">
			SELECT
			PROCESS_MAIN_ID
			FROM
			PROCESS_MAIN_ROWS
			WHERE PROCESS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_id#">
				
		</cfquery>
		<input type="hidden" name="process_id" id="process_id" value="<cfoutput>#attributes.process_id#</cfoutput>">

		<cf_box_elements>
			<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1">
				<div class="form-group" id="item-is_active">
					<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57493.Aktif'></label>
					<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
						<input type="checkbox" name="is_active" id="is_active" value="1" <cfif get_process.is_active eq 1>checked</cfif>>
					</div>
				</div>
				<div class="form-group">
					<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id="36294.Ana süreç"></label>
					<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
						<select id="item_process_main_id" name="item_process_main_id">
							<option value="" <cfif not len(get_general_item_processes.PROCESS_MAIN_ID)>selected</cfif>><cf_get_lang dictionary_id='57734.Seçiniz'></option>
							<cfoutput query="get_general_processes">
								<option value="#PROCESS_MAIN_ID#" <cfif get_general_item_processes.PROCESS_MAIN_ID eq get_general_processes.PROCESS_MAIN_ID>selected</cfif>>#PROCESS_MAIN_HEADER#</option>
							</cfoutput>
						</select>
					</div>
				</div>
				<div class="form-group" id="item-process_name">
					<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58859.Süreç'>*</label>
					<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
						<div class="input-group">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='36208.Süreç Adı Girmelisiniz'> !</cfsavecontent>
							<cfinput type="text" name="process_name" id="process_name" value="#get_process.process_name#" maxlength="200" required="Yes" message="#message#" >
							<span class="input-group-addon">
								<cf_language_info 
								table_name="PROCESS_TYPE" 
								column_name="PROCESS_NAME" 
								column_id_value="#attributes.process_id#"
								maxlength="500" 
								datasource="#dsn#" 
								column_id="PROCESS_ID" 
								control_type="0">
							</span>
						</div>
					</div>
				</div>
					<div class="form-group" id="item-detail">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<div class="input-group">
								<textarea name="detail" id="detail"><cfif len(get_process.detail)><cfoutput>#get_process.detail#</cfoutput></cfif></textarea>
								<span class="input-group-addon">
									<cf_language_info 
									table_name="PROCESS_TYPE" 
									column_name="DETAIL" 
									column_id_value="#attributes.process_id#" 
									maxlength="500" 
									datasource="#dsn#" 
									column_id="PROCESS_ID" 
									control_type="0">
								</span>
							</div>
						</div>
				</div>
				<div class="form-group">
					<!---dikkat:Burada MAIN_ACTION_FILE yazdığına bakmayın aslında MAIN_DISPLAY_FILE'ı tutuyor. --->
					<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58206.Main'><cf_get_lang dictionary_id='59000.Display File'></label>
					<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
						<input type="hidden" name="is_main_action_file" id="is_main_action_file" value="<cfoutput>#get_process.is_main_action_file#</cfoutput>" >
						<div class="input-group">
							<cfif len(get_process.main_action_file)>
								<input type="file" name="main_action_file" id="main_action_file" value=""  onclick="temizle_action();" style="display:none;">
								<input type="text" name="main_action_file_rex" id="main_action_file_rex" value="<cfoutput>#get_process.main_action_file#</cfoutput>" readonly >
								<span class="input-group-addon" id="value11" href="javascript://" style="display:none;" onClick="open_history('<cfoutput>#request.self#</cfoutput>?fuseaction=process.popup_dsp_template&field_name=upd_process.main_action_file_rex&field_id=upd_process.main_action_file&is_file=upd_process.is_main_action_file&type=1&is_submitted=1&action=1&process_type=1','process_templates');"><i class="fa fa-plus"></i></span>
								<span class="input-group-addon" href="javascript://" id="value12" onclick="temizle_action();"><i class="fa fa-minus"></i></span>
							<cfelse>
								<input type="file" name="main_action_file" id="main_action_file" value="" onclick="temizle_action();" >
								<input type="text" name="main_action_file_rex" id="main_action_file_rex" style="display:none;" readonly="">
								<span class="input-group-addon" id="value11" href="javascript://" onClick="open_history('<cfoutput>#request.self#</cfoutput>?fuseaction=process.popup_dsp_template&field_name=upd_process.main_action_file_rex&field_id=upd_process.main_action_file&is_file=upd_process.is_main_action_file&type=1&is_submitted=1&action=1&process_type=1','process_templates');"><i class="fa fa-plus"></i></span>
								<span class="input-group-addon" href="javascript://" id="value12" onclick="temizle_action();" style="display:none;"><i class="fa fa-minus"></i></span>
							</cfif>
						</div>
					</div>
				</div>
			</div>	
			<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="2">
				<div class="form-group" id="item-process_our_company_id">
					<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58017.İlişkili Şirketler'></label>
					<div class="col col-8 col-md-8 col-sm-8 col-xs-12"> 			
						<select name="process_our_company_id" id="process_our_company_id" multiple>
							<cfoutput query="Get_Our_Company">
								<option value="#comp_id#"  <cfif ListFind(Process_Our_Comp_List,comp_id)>selected</cfif>>#nick_name#</option>
							</cfoutput>
						</select>
					</div>
				</div>
				<div class="form-group" id="item-module_field_name">
					<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='36185.Fuseaction'>
						<a href="javascript://" onclick="gonder();"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='36185.Fuseaction'> <cf_get_lang dictionary_id='57582.Ekle'>"></i></a>
					</label>
					<div class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
						<textarea name="module_field_name" id="module_field_name" rows="3"><cfif len(get_process.faction)><cfoutput>#get_process.faction#</cfoutput></cfif></textarea>
					</div>
				</div>
				<div class="form-group" id="item-module_page_name">
					<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='65451.B2B-B2C Pages'></label>
					<div class="col col-8 col-md-8 col-sm-8 col-xs-12">    
						<textarea name="module_page_name" id="module_page_name" rows="3"><cfif len(get_process.page_name)><cfoutput>#get_process.page_name#</cfoutput></cfif></textarea>
					</div>
				</div>
				<div class="form-group" id="item-widget_friendly_url">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='61176.Widget'><a href="javascript://"onclick="send_widget();"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='29812.Add Widget'>"></i></a></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">    
                            <textarea name="widget_friendly_url" id="widget_friendly_url" rows="3"><cfif len(get_process.friendly_url)><cfoutput>#get_process.friendly_url#</cfoutput></cfif></textarea>
                        </div>
                    </div>
				<div class="form-group">
					<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58206.Main'> <cf_get_lang dictionary_id='59001.Action File'></label>
					<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
						<input type="hidden" name="is_main_file" id="is_main_file" value="<cfoutput>#get_process.is_main_file#</cfoutput>" >
						<div class="input-group">
							<cfif len(get_process.main_file)>
								<input type="file" name="main_file" id="main_file" onclick="temizle();" style="display:none;">
								<input type="text" name="main_file_rex" id="main_file_rex"  readonly="" value="<cfoutput>#get_process.main_file#</cfoutput>">
								<span class="input-group-addon" id="value21" href="javascript://" style="display:none;" onClick="open_history('<cfoutput>#request.self#</cfoutput>?fuseaction=process.popup_dsp_template&field_name=upd_process.main_file_rex&field_id=upd_process.main_file&is_file=upd_process.is_main_file&type=2&is_submitted=1&process_type=1','process_templates');"><i class="fa fa-plus"></i></span>
								<span class="input-group-addon" href="javascript://" id="value22" onclick="temizle();"><i class="fa fa-minus"></i></span>
							<cfelse>
								<input type="file" name="main_file" id="main_file" onclick="temizle();" >
								<input type="text" name="main_file_rex" id="main_file_rex" style="display:none;" readonly="">
								<span class="input-group-addon" id="value21" href="javascript://" onClick="open_history('<cfoutput>#request.self#</cfoutput>?fuseaction=process.popup_dsp_template&field_name=upd_process.main_file_rex&field_id=upd_process.main_file&is_file=upd_process.is_main_file&type=2&is_submitted=1&process_type=1','process_templates');"><i class="fa fa-plus"></i></span>
								<span class="input-group-addon" href="javascript://" id="value22" onclick="temizle();" style="display:none;"><i class="fa fa-minus"></i></span>
							</cfif>
						</div>
					</div>
				</div>
			</div>
			<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="3">
				<div class="form-group" id="item-is_stage_back">
					<label class="col col-12 col-md-12 col-sm-12 col-xs-12">	<input type="checkbox" name="is_stage_back" id="is_stage_back" value="1" <cfif get_process.is_stage_back eq 1>checked</cfif>><cf_get_lang dictionary_id='36226.Aşamalar Geriye Dönebilir'></label>
				</div>
				<div class="form-group" id="item-is_stage_manuel_change">
					<label class="col col-12 col-md-12 col-sm-12 col-xs-12"><input type="checkbox" name="is_stage_manuel_change" id="is_stage_manuel_change" value="1" <cfif get_process.is_stage_manuel_change eq 1>checked</cfif>><cf_get_lang dictionary_id='60363.Aşamalar manuel değiştirilebilir'></label>
				</div>
		
				<div class="form-group" id="item-up_department">
					<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='42335.Üst Departman'></label>
					<div class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
						<div class="input-group">
							<cfset up_dep_name="">
							<cfif len(get_process.upper_dep_id)>
								<cfquery name="UPPER_DEPARTMANS" datasource="#dsn#">
									SELECT 
										DEPARTMENT_HEAD 
									FROM
										DEPARTMENT
									WHERE 
										DEPARTMENT_ID = #get_process.upper_dep_id#
								</cfquery>
								<cfset up_dep_name="#UPPER_DEPARTMANS.DEPARTMENT_HEAD#">
							</cfif>
							<input type="hidden" name="up_department_id" id="up_department_id" value="<cfoutput>#get_process.upper_dep_id#</cfoutput>">
							<input type="text" name="up_department" id="up_department" value="<cfoutput>#up_dep_name#</cfoutput>">
							<span class="input-group-addon icon-ellipsis btnPointer" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=hr.popup_list_departments&field_id=upd_process.up_department_id&is_form_submitted=1&field_name=upd_process.up_department</cfoutput>');"></span>
						</div>
					</div>
				</div>
				<div class="form-group" id="item-department">
					<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57572.Departman'></label>
					<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
						<div class="input-group">
							<cfset dep_name="">
							<cfif len(get_process.department_id)>
								<cfquery name="DEPARTMANS" datasource="#dsn#">
									SELECT 
										DEPARTMENT_HEAD 
									FROM
										DEPARTMENT
									WHERE 
										DEPARTMENT_ID = #get_process.department_id#
								</cfquery>
								<cfset dep_name="#DEPARTMANS.DEPARTMENT_HEAD#">
							</cfif>
							<input type="hidden" name="department_id" id="department_id" value="<cfoutput>#get_process.department_id#</cfoutput>">
							<input type="text" name="department" id="department" value="<cfoutput>#dep_name#</cfoutput>">
							<span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=hr.popup_list_departments&field_id=upd_process.department_id&is_form_submitted=1&field_name=upd_process.department</cfoutput>');"></span>              
						</div>
					</div>              
				</div>
				<div class="form-group" id="item-form_ul_employee_name">
					<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang_main no='132.Sorumlu'></label>
					<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
						<div class="input-group">
							<input type="hidden" name="emp_id" id="emp_id" value="<cfoutput>#get_process.resp_emp_id#</cfoutput>" />
							<input type="text" name="employee_name" id="employee_name" value="<cfif len(get_process.resp_emp_id)><cfoutput>#get_emp_info(get_process.resp_emp_id,0,0)#</cfoutput></cfif>" onfocus="AutoComplete_Create('employee_name','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','POSITION_CODE,EMPLOYEE_ID','position_code,emp_id','','3','135','fill_department()');" />
							<span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_name=upd_process.employee_name&is_form_submitted=1&function_name=fill_department&field_emp_id=upd_process.emp_id&select_list=1&branch_related=1')"></span>
						</div>
					</div>
				</div>
			</div>
			
		</cf_box_elements>
		<div class="ui-form-list-btn">
			<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
				<cf_record_info query_name="get_process">
			</div>
			<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
				<cf_workcube_buttons is_upd='1' is_delete='0' add_function='kontrol()'>
			</div>
		</div>
		<!--- Asamalara Ait Bilgilerin Geldigi Div --->
		<div id="process_stage"></div>
</cfform>
</cf_box>
	<cfset action_section = "PROCESS_TYPE">
    <cfset relative_id = attributes.process_id>
    <cfinclude template="../../process/display/list_designer.cfm">
</div>

	<div id="unique_content" class="col col-12 uniqueBox">
		<cf_get_workcube_content action_type ='PROCESS_ID' style="box-shadow:none;" action_type_id ='#attributes.process_id#'design='1' come_project='1'>
	</div>

<script type="text/javascript">
	process_stage_div = 'process_stage';
	var send_address_head = "<cfoutput>#request.self#?fuseaction=process.emptypopupajax_dsp_process_stage&process_id=#process_id#&process_name=#get_process.process_name#</cfoutput>";
	AjaxPageLoad(send_address_head,process_stage_div,1);
	
	function kontrol()
	{
		var obj =  document.getElementById("main_file").value;
		extention = list_getat(obj,list_len(obj,'.'),'.');
		if(obj != '' && extention != 'cfm') 
		{
			alert("<cf_get_lang dictionary_id ='36242.Lütfen Action File İçin cfm Dosyası Seçiniz '>!");
			return false;
		}
		var obj2 =  document.getElementById("main_action_file").value;
		var extention2 = list_getat(obj2,list_len(obj2,'.'),'.');
		if(obj2 != '' && extention2 != 'cfm') 
		{
			alert("<cf_get_lang dictionary_id ='36243.Lütfen Display File İçin cfm Dosyası Seçiniz'> !");
			return false;
		}
	
		if("<cfoutput>#get_process.is_stage_back#</cfoutput>" == 0)
			if(document.getElementById("is_stage_back").checked == true)
			{
				var GET_KONTROL = wrk_safe_query('prc_get_kontrol','dsn',0,<cfoutput>#attributes.process_id#</cfoutput>);
				if(GET_KONTROL.recordcount != 0 && GET_KONTROL.recordcount != undefined)
				{
					alert("<cf_get_lang dictionary_id ='36251.Bu Süreçteki Aşamaların Zorunluluk Kontrollerine Bakınız'>!");
					return false;
				}
			}
		
		if(document.getElementById("process_our_company_id").value == '')
		{
			alert("<cf_get_lang dictionary_id='58194.Girilmesi Zorunlu Alan'> : <cf_get_lang dictionary_id='58017.İlişkili Şirketler'> !");
			return false;
		}
		if(document.getElementById("item_process_main_id").value == '')
		{
			alert("<cf_get_lang dictionary_id='58194.Girilmesi Zorunlu Alan'> : <cf_get_lang dictionary_id='36294.Ana süreç'> !");
			return false;
		}
		return true;
	}
	
	function gonder()
	{
		if(document.getElementById("module_field_name").value=="")
			windowopen('<cfoutput>#request.self#?fuseaction=process.popup_dsp_faction_list&field_name=upd_process.module_field_name&is_upd=0</cfoutput>','list');
		else
			windowopen('<cfoutput>#request.self#?fuseaction=process.popup_dsp_faction_list&field_name=upd_process.module_field_name&is_upd=1</cfoutput>','list');
	}

	function send_widget()
	{
		if(upd_process.widget_friendly_url.value=="")
			openBoxDraggable('<cfoutput>#request.self#?fuseaction=dev.popup_widget&field_name=upd_process.widget_friendly_url&widget_type=4&draggable=1&is_upd=0&only_choice=0&is_friendly=1</cfoutput>');
		else
			openBoxDraggable('<cfoutput>#request.self#?fuseaction=dev.popup_widget&field_name=upd_process.widget_friendly_url&widget_type=4&draggable=1&is_upd=1&only_choice=0&is_friendly=1</cfoutput>');
	}
	
	function temizle_action()
	{
		document.getElementById("is_main_action_file").value="";
		document.getElementById("main_action_file").style.display="";
		document.getElementById("main_action_file_rex").style.display='none';
		document.getElementById("value11").style.display='';
		document.getElementById("value12").style.display='none';
		document.getElementById("main_action_file_rex").value='';
	}
	
	function temizle()
	{
		document.getElementById("is_main_file").value="";
		document.getElementById("main_file").style.display='';
		document.getElementById("main_file_rex").style.display='none';
		document.getElementById("value21").style.display='';
		document.getElementById("value22").style.display='none';
		document.getElementById("main_file_rex").value='';
	}
	function open_history(url,id) {
		document.getElementById(id).style.display ='';	
		document.getElementById(id).style.width ='500px';	
		$("#"+id).css('margin-left',$("#tabMenu").position().left-500);
		$("#"+id).css('margin-top',$("#tabMenu").position().top);
		$("#"+id).css('position','absolute');	
		
		AjaxPageLoad(url,id,1);
		return false;
	}
</script>
