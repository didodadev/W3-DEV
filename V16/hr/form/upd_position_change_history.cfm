<cf_xml_page_edit fuseact="hr.form_add_position">
<cfscript>
	get_position_change_action = createObject("component","V16.hr.cfc.get_change_position_history");
	get_position_change_action.dsn = dsn;
	get_position_history = get_position_change_action.get_change_history_fnc
					(
						module_name : fusebox.circuit,
						id : attributes.id
					);
</cfscript>
<cfquery name="GET_UNITS" datasource="#DSN#">
	SELECT UNIT_ID,UNIT_NAME FROM SETUP_CV_UNIT WHERE IS_ACTIVE = 1 ORDER BY UNIT_NAME
</cfquery>
<cfquery name="fire_reasons" datasource="#dsn#">
	SELECT REASON_ID, REASON FROM SETUP_EMPLOYEE_FIRE_REASONS ORDER BY REASON
</cfquery>
<cfquery name="GET_ORGANIZATION_STEPS" datasource="#DSN#">
	SELECT ORGANIZATION_STEP_ID,ORGANIZATION_STEP_NAME FROM SETUP_ORGANIZATION_STEPS ORDER BY ORGANIZATION_STEP_NAME
</cfquery>

<cfif len(get_position_history.upper_position_code)>
	<cfquery name="get_upper_pos" datasource="#dsn#">
		SELECT
			TOP 1 POSITION_NAME
		FROM
			EMPLOYEE_POSITIONS_HISTORY
		WHERE
			POSITION_CODE = #get_position_history.upper_position_code#
			<cfif len(get_position_history.finish_date)>
				AND START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#get_position_history.finish_date#">
				AND (FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#get_position_history.finish_date#"> OR FINISH_DATE IS NULL)
			</cfif>
		ORDER BY
			START_DATE DESC,FINISH_DATE
	</cfquery>
	<cfif get_upper_pos.RecordCount>
		<cfset upper_pos_name = get_upper_pos.position_name>
	</cfif>
</cfif>
<cfif len(get_position_history.upper_position_code2)>
	<cfquery name="get_upper_pos2" datasource="#dsn#">
		SELECT
			TOP 1 POSITION_NAME
		FROM
			EMPLOYEE_POSITIONS_HISTORY
		WHERE
			POSITION_CODE = #get_position_history.upper_position_code2#
			<cfif len(get_position_history.finish_date)>
				AND START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#get_position_history.finish_date#">
				AND (FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#get_position_history.finish_date#"> OR FINISH_DATE IS NULL)
			</cfif>
		ORDER BY
			START_DATE DESC,FINISH_DATE
	</cfquery>
	<cfif get_upper_pos2.RecordCount>
		<cfset upper_pos_name2 = get_upper_pos2.position_name>
	</cfif>
</cfif>
<cfsavecontent variable="message"><cf_get_lang dictionary_id="58497.Pozisyon"></cfsavecontent>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box title="#message#" popup_box="1">
		<cfform name="upd_change_history" method="post" action="#request.self#?fuseaction=hr.emptypopup_upd_change_history">
		<input type="hidden" name="id" id="id" value="<cfoutput>#attributes.id#</cfoutput>">
		<cf_box_elements>
			<cfquery name="get_department" datasource="#dsn#">
				SELECT
					D.DEPARTMENT_ID,
					D.DEPARTMENT_HEAD,
					B.BRANCH_ID,
					B.BRANCH_NAME,
					OC.NICK_NAME
				FROM
					DEPARTMENT D,
					BRANCH B,
					OUR_COMPANY OC
				WHERE
					D.BRANCH_ID = B.BRANCH_ID AND
					B.COMPANY_ID = OC.COMP_ID AND
					D.DEPARTMENT_ID = #get_position_history.department_id#
			</cfquery>
			<div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
				<div class="form-group" id="item-NICK_NAME">
					<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57574.Şirket'></label>
					<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
						<cfoutput>#get_department.NICK_NAME#</cfoutput>
					</div>
				</div>
				<div class="form-group" id="item-department_id">
					<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id ='57572.Departman'>*</label>
					<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
					<div class="input-group">
						<input type="hidden" name="department_id" id="department_id" value="<cfoutput>#get_department.department_id#</cfoutput>">
						<input type="text" name="department" id="department" value="<cfoutput>#get_department.department_head#</cfoutput>" readonly>
						<span class="input-group-addon icon-ellipsis" href="javascript://"  onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=hr.popup_list_departments&field_id=upd_change_history.department_id&field_name=upd_change_history.department</cfoutput>&field_branch_name=upd_change_history.branch&field_branch_id=upd_change_history.branch_id&is_all_departments');"></span>
					</div>
				</div>
			</div>
			<div class="form-group" id="item-branch_id">
				<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57453.Şube'></label>
				<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
					<input type="hidden" name="branch_id" id="branch_id" value="<cfoutput>#get_department.branch_id#</cfoutput>">
					<input type="text" name="branch" id="branch" maxlength="" value="<cfoutput>#get_department.branch_name#</cfoutput>" readonly>
				</div>
			</div>
			
			<div class="form-group" id="item-POSITION_NAME">
				<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58497.Pozisyon'>*</label>
				<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='58497.Pozisyon'></cfsavecontent>
					<cfinput required="yes" maxlength="50" message="#message#" type="Text" name="POSITION_NAME" value="#get_position_history.POSITION_NAME#">
				</div>
			</div>
			<div class="form-group" id="item-position_cat">
				<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id ='59004.Pozisyon tipi'>*</label>
				<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
					<cfinclude template="../query/get_position_cats.cfm">			
					<select name="POSITION_CAT_ID" id="POSITION_CAT_ID" onchange="change_fields();">
					<cfoutput query="get_position_cats">
						<option value="#position_cat_id#;#position_cat#"<cfif get_position_history.position_cat_id eq position_cat_id>selected</cfif>>#position_cat#</option>
					</cfoutput>
					</select>
				</div>
			</div>
			<div class="form-group" id="item-title">
				<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57571.Ünvan'>*</label>
				<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
					<cfsavecontent variable="text"><cf_get_lang dictionary_id='57734.Seçiniz'></cfsavecontent>
					<cf_wrk_selectlang 
						name="title_id"
						option_name="title"
						option_value="title_id"
						width="200"
						table_name="SETUP_TITLE"
						option_text="#text#" value=#get_position_history.title_id#>
					</div>
				</div>
				<div class="form-group" id="item-unit_name">
					<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58701.Fonksiyon'>*</label>
					<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
						<select name="func_id" id="func_id" >
							<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
							<cfoutput query="get_units">
								<option value="#get_units.unit_id#"<cfif get_position_history.func_id eq get_units.unit_id>selected</cfif>>#unit_name#</option>
							</cfoutput>
						</select>
					</div>
				</div>
			</div>
			<div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="2" sort="true">
				<div class="form-group" id="item-organization_step_id">
					<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58710.Kademe'></label>
					<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
						<select name="organization_step_id" id="organization_step_id" >
							<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
							<cfoutput query="get_organization_steps">
								<option value="#organization_step_id#"<cfif get_position_history.organization_step_id eq get_organization_steps.organization_step_id>selected</cfif>>#organization_step_name#</option>
							</cfoutput>
						</select>                                       
					</div>
				</div>
				<div class="form-group" id="item-collar_type">
					<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='56063.Yaka Tipi'></label>
					<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
						<select name="collar_type" id="collar_type" >
							<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
							<option value="1" <cfif get_position_history.collar_type eq 1>selected</cfif>><cf_get_lang dictionary_id='56065.Mavi Yaka'></option> 
							<option value="2" <cfif get_position_history.collar_type eq 2>selected</cfif>><cf_get_lang dictionary_id='56066.Beyaz Yaka'></option>
						</select>
					</div>
				</div>
				<div class="form-group" id="item-upper_position">
					<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='56110.Birinci Amir'></label>
					<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
						<div class="input-group">
							<cfif len(get_position_history.upper_position_code)>
								<cfset attributes.pos_code = get_position_history.upper_position_code>
								<cfinclude template="../query/get_position_info.cfm">
							</cfif>
							<input type="hidden" name="position_id" id="position_id" value="<cfoutput>#get_position_history.upper_position_code#</cfoutput>">
							<input type="hidden" name="upper_position_code" id="upper_position_code" value="<cfoutput>#get_position_history.upper_position_code#</cfoutput>">
							<input type="text" name="upper_position" id="upper_position" value="<cfif len(get_position_history.upper_position_code)><cfoutput><cfif isdefined('upper_pos_name')>#upper_pos_name#<cfelse>#get_position_info.position_name#</cfif> - #get_position_info.employee_name# #get_position_info.employee_surname#</cfoutput></cfif>" >
							<span class="input-group-addon icon-ellipsis" href="javascript://" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_list_positions&field_code=upd_change_history.upper_position_code&position_employee=upd_change_history.upper_position&show_empty_pos=1');return false"></span>
						</div>
					</div>
				</div>
				<div class="form-group" id="item-upper_position2">
					<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='56111.İkinci Amir'></label>
					<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
						<div class="input-group">
							<cfif len(get_position_history.upper_position_code2)>
								<cfset attributes.pos_code = get_position_history.upper_position_code2>
								<cfinclude template="../query/get_position_info.cfm">
							</cfif>
							<input type="hidden" name="upper_position_code2" id="upper_position_code2" value="<cfoutput>#get_position_history.upper_position_code2#</cfoutput>">
							<input type="text" name="upper_position2" id="upper_position2" value="<cfif len(get_position_history.upper_position_code2)><cfoutput><cfif isdefined('upper_pos_name2')>#upper_pos_name2#<cfelse>#get_position_info.position_name#</cfif> - #get_position_info.employee_name# #get_position_info.employee_surname#</cfoutput></cfif>" >
							<span class="input-group-addon icon-ellipsis" href="javascript://" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_list_positions&field_code=upd_change_history.upper_position_code2&position_employee=upd_change_history.upper_position2&show_empty_pos=1');return false"></span>
						</div>
					</div>
				</div>
				<div class="form-group" id="item-reason_id">
					<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='55550.Gerekçe'>*</label>
					<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
						<select name="reason_id" id="reason_id" >
							<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
							<cfoutput query="fire_reasons">
								<option value="#reason_id#" <cfif get_position_history.reason_id eq reason_id>selected</cfif>>#reason#</option>
							</cfoutput>
						</select>						
					</div>
				</div>
				<div class="form-group" id="item-start_date">
					<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58467.Başlama'></label>
					<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
						<div class="input-group">
							<cfinput type="text" name="start_date" id="start_date"  value="#dateformat(get_position_history.start_date,dateformat_style)#" validate="#validate_style#" maxlength="10">				
							<span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="start_date">	</span>					
						</div>
					</div>
				</div>
				<div class="form-group" id="item-finish_date">
					<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57502.Bitiş'></label>
					<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
						<div class="input-group">
						<cfinput type="text" name="finish_date" id="finish_date"  value="#dateformat(get_position_history.finish_date,dateformat_style)#" validate="#validate_style#" maxlength="10">
						<span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="finish_date">	</span>	
						</div>								
					</div>
				</div>
			</div>
		</cf_box_elements>
		<cf_box_footer>
			<cf_record_info 
				query_name="get_position_history"
				record_emp="record_emp" 
				record_date="record_date"
				update_emp="update_emp"
				update_date="update_date"
				>
			<cf_workcube_buttons is_upd='1' is_delete='1' add_function='kontrol()' delete_page_url='#request.self#?fuseaction=hr.emptypopup_del_position_change_history&id=#get_position_history.id#'>
			</cf_box_footer>
		</cfform>
	</cf_box>
</div>
<script language="javascript">
	function kontrol()
	{
		if(document.upd_change_history.POSITION_CAT_ID.value == "")
		{	alert("<cf_get_lang dictionary_id ='59004.Pozisyon tipi'>");
			return false;
		}
		if(document.upd_change_history.title_id.value == "")
		{	alert("<cf_get_lang dictionary_id ='57571.Ünvan'>");
			return false;
		}
		if(document.upd_change_history.reason_id.value == "")
		{	alert("<cf_get_lang dictionary_id='55550.Gerekçe'>");
			return false;
		}
	}
	function change_fields()
	{
		var dizi = document.upd_change_history.POSITION_CAT_ID.value.split(';');
		var pos_cat_det = wrk_query('SELECT TITLE_ID, FUNC_ID FROM SETUP_POSITION_CAT WHERE POSITION_CAT_ID = '+dizi[0],'dsn');
		if (pos_cat_det.TITLE_ID != '')
			document.getElementById('title_id').value = pos_cat_det.TITLE_ID;
		if (pos_cat_det.FUNC_ID != '')
			document.getElementById('func_id').value = pos_cat_det.FUNC_ID;
	}
</script>
