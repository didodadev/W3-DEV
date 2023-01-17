<cf_xml_page_edit fuseact="hr.form_add_position">
<cfif not isdefined("attributes.position_id") or (isdefined("attributes.position_id") and not len(attributes.position_id))>
	<script type="text/javascript">
		alert("<cf_get_lang dictionary_id='56079.Eksik Parametre'> !");	
		history.back();
	</script>
	<cfabort>
</cfif>
<script type="text/javascript">
	function chk()
	{
		document.getElementById('is_change_position').value = 0;
		if(document.getElementById('old_emp_id').value == 0 && document.getElementById('employee_id').value != "" && document.getElementById('x_position_change_control').value == 1)
		{
			document.getElementById('is_change_position').value = 1;
			if(document.getElementById('position_in_out_date').value == "")
			{
			alert("<cf_get_lang dictionary_id='56040.Göreve başlama tarihini giriniz'>");
			return false;
			}
			if(document.getElementById('reason_id').value == "")
			{
				alert("<cf_get_lang dictionary_id='56041.Gerekçe seçiniz'>");
				return false;
			}
		}
		if(document.getElementById('employee_id').value != "" && document.getElementById('employee').value=="" && document.getElementById('x_position_change_control').value == 1)
		{
			document.getElementById('is_change_position').value = 1;
			if(document.getElementById('position_in_out_date').value == "")
			{
                alert("<cf_get_lang dictionary_id='56048.Pozisyonu boşaltıyorsunuz.Lütfen Görev Bitiş tarihini giriniz !'>");
                return false;
			}
			if(document.getElementById('reason_id').value == "")
			{
			    alert("<cf_get_lang dictionary_id='56050.Pozisyonu boşaltıyorsunuz.Lütfen Gerekçe seçiniz'>");
				return false;
			}
		}
		if(document.getElementById('employee_id').value != "")
		{
			if(document.getElementById('x_position_change_control').value == 1)
			{
				new_pos_cat_id = document.getElementById('position_cat_id').value.substring(0,document.getElementById('position_cat_id').value.indexOf(';'));
				if(
					(document.getElementById('old_position_name') != undefined && document.getElementById('old_position_name').value != document.getElementById('position_name').value) || document.getElementById('old_department_id').value != document.getElementById('department_id').value || document.getElementById('old_title_id').value != document.getElementById('title_id').value || document.getElementById('old_position_cat_id').value != new_pos_cat_id || document.getElementById('old_func_id').value != document.getElementById('func_id').value || document.getElementById('old_collar_type').value != document.getElementById('collar_type').value || document.getElementById('old_organization_step_id').value != document.getElementById('organization_step_id').value)
				{
					document.getElementById('is_change_position').value = 1;
					if(document.getElementById('position_in_out_date').value == "")
					{
						alert("<cf_get_lang dictionary_id='56054.Pozisyon bilgilerinde değişiklik yaptınız. Lütfen Görev Değişiklik tarihini giriniz'>");
						return false;
					}
					if(document.getElementById('reason_id').value == "")
					{
						alert("<cf_get_lang dictionary_id='56055.Pozisyon bilgilerinde değişiklik yaptınız.Lütfen Gerekçe seçiniz'>");
						return false;
					}
				}
			}
			<cfif x_upper_pos_hist eq 1>
				if (document.getElementById('old_upper_position_code').value != document.getElementById('upper_position_code').value || document.getElementById('old_upper_position').value != document.getElementById('upper_position').value || document.getElementById('old_upper_position_code2').value != document.getElementById('upper_position_code2').value || document.getElementById('old_upper_position2').value != document.getElementById('upper_position2').value)
				{
					document.getElementById('is_change_position').value = 1;
					if(document.getElementById('position_in_out_date').value == "")
					{
						alert("<cf_get_lang dictionary_id='56054.Pozisyon bilgilerinde değişiklik yaptınız. Lütfen Görev Değişiklik tarihini giriniz'>");
						return false;
					}
					if(document.getElementById('reason_id').value == "")
					{
						alert("<cf_get_lang dictionary_id='56055.Pozisyon bilgilerinde değişiklik yaptınız.Lütfen Gerekçe seçiniz'>");
						return false;
					}
				}
			</cfif>
		}
		if(document.getElementById('employee').value=="")	
		{
			document.getElementById('employee_id').value="";
		}
		if(trim(document.getElementById('title_id').value) == "")
		{
			alert("<cf_get_lang dictionary_id='57571.Ünvan'>");
			return false;
		}
		return process_cat_control();
	}
	function reset_reason(){
		if(document.getElementById('old_emp_id').value == 0 && document.getElementById('employee_id').value != "" && document.getElementById('x_position_change_control').value == 1)
		{ 
			document.getElementById('reason_id').value = "";
		}
		if(document.getElementById('employee_id').value != "" && document.getElementById('employee').value=="" && document.getElementById('x_position_change_control').value == 1)
		{
			document.getElementById('reason_id').value = "";
		}
		if(document.getElementById('employee_id').value != "")
		{
            if(document.getElementById('x_position_change_control').value == 1)
            {
                new_pos_cat_id = document.getElementById('position_cat_id').value.substring(0,document.getElementById('position_cat_id').value.indexOf(';'));
                if((document.getElementById('old_position_name') != undefined && document.getElementById('old_position_name').value != document.getElementById('POSITION_NAME').value) || document.getElementById('old_department_id').value != document.getElementById('department_id').value || document.getElementById('old_title_id').value != document.getElementById('title_id').value || document.getElementById('old_position_cat_id').value != new_pos_cat_id || document.getElementById('old_func_id').value != document.getElementById('func_id').value || document.getElementById('old_collar_type').value != document.getElementById('collar_type').value || document.getElementById('old_organization_step_id').value != document.getElementById('organization_step_id').value)

                {
                    document.getElementById('reason_id').value = "";
                }

            }
          
			<cfif x_upper_pos_hist eq 1>
				if (document.getElementById('old_upper_position_code').value != document.getElementById('upper_position_code').value || document.getElementById('old_upper_position').value != document.getElementById('upper_position').value || document.getElementById('old_upper_position_code2').value != document.getElementById('upper_position_code2').value || document.getElementById('old_upper_position2').value != document.getElementById('upper_position2').value)
				{
					document.getElementById('reason_id').value = "";
				}
			</cfif>
		}
	}
	function reset_level()
	{
		if (td_group.style.display == 'none')
			document.getElementById('GROUP_ID').selectedIndex = 0;
	}
	
	function set_conf()
	{
		alert("<cf_get_lang dictionary_id='58699.Onaylandı'> ");
		document.getElementById('confirmed').value=1;
		document.getElementById('rejected').value="";
		document.getElementById('change').value=1;
		upd_pos.submit();
	}
	function set_rej()
	{
		alert("<cf_get_lang dictionary_id='57617.Reddedildi'>");
		document.getElementById('confirmed').value="";
		document.getElementById('rejected').value=1;
		document.getElementById('change').value=1;
		upd_pos.submit();
	}
</script>
<cfinclude template="../query/get_position_detail.cfm">
<cfif not get_position_detail.recordcount>
	<script type="text/javascript">
		alert("<cf_get_lang dictionary_id='56081.Böyle bir pozisyon yok veya Yetki dışı erişim denemesi yaptınız'> !");
		history.back();
	</script>
	<cfexit method="exittemplate">
</cfif>
<cfinclude template="../query/get_titles.cfm">
<cfinclude template="../query/get_modules.cfm">
<cfinclude template="../query/get_position_cats.cfm">
<cfquery name="fire_reasons" datasource="#dsn#"> <!---20131107 GSO pozisyon için şirket içi gerekçeler--->
	SELECT 
        REASON_ID,
        #dsn#.Get_Dynamic_Language(REASON_ID,'#session.ep.language#','SETUP_EMPLOYEE_FIRE_REASONS','REASON',NULL,NULL,REASON) AS REASON
    FROM 
        SETUP_EMPLOYEE_FIRE_REASONS 
    WHERE 
        IS_POSITION = 1 
    ORDER BY 
        REASON
</cfquery>
<cfset attributes.POSITION_CAT_ID = get_position_detail.POSITION_CAT_ID>
<cfinclude template="../query/get_position_cat.cfm">

<cfquery name="CHECK" datasource="#dsn#">
	SELECT 
		SB_ID, 
		POSITION_CODE 
	FROM 
		EMPLOYEE_POSITIONS_STANDBY 
	WHERE 
		POSITION_CODE = #get_position_detail.position_code#
</cfquery>
<cfquery name="DENIED_PAGE" datasource="#DSN#" maxrows="1">
	SELECT 
		POSITION_CODE 
	FROM
		EMPLOYEE_POSITIONS_DENIED
	WHERE 
		POSITION_CODE = #get_position_detail.position_code#
</cfquery>
<cfquery name="GET_LAST_HIST_ROW" datasource="#DSN#" maxrows="1">
	SELECT
		START_DATE,
		FINISH_DATE
	FROM
		EMPLOYEE_POSITIONS_HISTORY
	WHERE
		POSITION_ID=#URL.POSITION_ID#
	ORDER BY
		HISTORY_ID DESC
</cfquery>
<cfquery name="GET_ORGANIZATION_STEPS" datasource="#DSN#">
	SELECT 
		ORGANIZATION_STEP_ID,
        #dsn#.Get_Dynamic_Language(ORGANIZATION_STEP_ID,'#session.ep.language#','SETUP_ORGANIZATION_STEPS','ORGANIZATION_STEP_NAME',NULL,NULL,ORGANIZATION_STEP_NAME) AS ORGANIZATION_STEP_NAME
	FROM
		SETUP_ORGANIZATION_STEPS
	ORDER BY
		ORGANIZATION_STEP_NAME
</cfquery>
<cfquery name="GET_UNITS" datasource="#DSN#">
	SELECT 
        UNIT_ID,
        #dsn#.Get_Dynamic_Language(UNIT_ID,'#session.ep.language#','SETUP_CV_UNIT','UNIT_NAME',NULL,NULL,UNIT_NAME) AS UNIT_NAME
    FROM 
        SETUP_CV_UNIT 
    WHERE 
        IS_ACTIVE = 1 
    ORDER BY 
        UNIT_NAME
</cfquery>
<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cfform action="#request.self#?fuseaction=hr.emptypopup_upd_position&id=#attributes.position_id#" method="post" name="upd_pos">
        <cf_box>
            <input type="hidden" name="id" id="id" value="<cfoutput>#attributes.position_id#</cfoutput>">
            <input type="hidden" name="x_upd_in_out" id="x_upd_in_out" value="<cfoutput>#x_upd_in_out#</cfoutput>">
            <input type="hidden" name="x_position_change_control" id="x_position_change_control" value="<cfoutput>#x_position_change_control#</cfoutput>">
            <input type="hidden" id="counter" name="counter">
            <input type="hidden" name="position_code" id="position_code" value="<cfoutput>#get_position_detail.position_code#</cfoutput>">
            <input type="hidden" name="position_id" id="position_id" value="<cfoutput>#get_position_detail.position_id#</cfoutput>">
            <input type="hidden" name="is_change_position" id="is_change_position" value="0"><!---gorev degisikligi tablosuna bu deger 1 oldugunda kayit atilir --->
            <cf_box_elements>
                <div class="col col-12 col-md-12 col-sm-12 col-xs-12" type="column" index="1" sort="true">
                    <div class="form-group col col-2 col-md-2 col-sm-6 col-xs-12" id="item-status">
                        <label class="col col-12 col-md-12 col-sm-12 col-xs-12">
                            <input type="checkbox" name="status" id="status" value="" <cfif get_position_detail.position_status eq 1>checked</cfif>><cf_get_lang dictionary_id='57493.Aktif'>
                        </label>
                    </div>
                    <div class="form-group col col-2 col-md-2 col-sm-6 col-xs-12" id="item-is_master">
                        <label class="col col-12 col-md-12 col-sm-12 col-xs-12">
                            <input type="checkbox" name="is_master" id="is_master" value="" <cfif get_position_detail.is_master eq 1>checked</cfif>><cf_get_lang dictionary_id='56058.Master'>
                        </label>
                    </div>
                    <div class="form-group col col-2 col-md-2 col-sm-6 col-xs-12" id="item-is_critical">
                        <label class="col col-12 col-md-12 col-sm-12 col-xs-12">
                            <input type="checkbox" name="is_critical" id="is_critical" <cfif get_position_detail.is_critical eq 1> checked</cfif>><cf_get_lang dictionary_id='55992.Kritik Pozisyon'>
                        </label>
                    </div>
                    <div class="form-group col col-2 col-md-2 col-sm-6 col-xs-12" id="item-is_org_view">
                        <label class="col col-12 col-md-12 col-sm-12 col-xs-12">
                            <input type="Checkbox" name="is_org_view" id="is_org_view" <cfif get_position_detail.is_org_view eq 1>checked</cfif>><cf_get_lang dictionary_id='56059.Org Şemada Göster'>
                        </label>
                    </div>
                    <div class="form-group col col-2 col-md-2 col-sm-6 col-xs-12" id="item-is_org_view">
                        <label class="col col-12 col-md-12 col-sm-12 col-xs-12">
                            <cf_get_lang dictionary_id='56369.Üst Düzey IK Yetkisi'><input type="Checkbox" name="ehesap" id="ehesap" value="1" <cfif get_position_detail.ehesap eq 1>checked</cfif>>
                        </label>
                    </div>
                </div>
                <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                    <div class="form-group" id="item-reason_id">
                        <label class="col col-4"><cf_get_lang dictionary_id='55550.Gerekçe'></label>
                        <div class="col col-8">
                            <select name="reason_id" id="reason_id">
                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                <cfoutput query="fire_reasons">
                                    <option value="#reason_id#" <cfif get_position_detail.in_company_reason_id eq reason_id>selected</cfif>>#reason#</option>
                                </cfoutput>
                            </select>
                        </div>                
                    </div>
                    <div class="form-group" id="item-branch">
                        <label class="col col-4"><cf_get_lang dictionary_id ='57453.Şube'></label>
                        <div class="col col-8">
                            <input type="hidden" name="branch_id" id="branch_id" value="<cfoutput>#get_position_detail.branch_id#</cfoutput>">
                            <input type="text" name="branch" id="branch" maxlength="" value="<cfoutput>#get_position_detail.branch_name#</cfoutput>" readonly>
                        </div>                
                    </div>
                    <div class="form-group" id="item-department">
                        <label class="col col-4"><cf_get_lang dictionary_id='57572.Departman'>*</label>
                        <div class="col col-8">
                            <div class="input-group">
                                <input type="hidden" name="old_department_id" id="old_department_id" value="<cfoutput>#get_position_detail.department_id#</cfoutput>">
                                <input type="hidden" name="department_id" id="department_id" value="<cfoutput>#get_position_detail.department_id#</cfoutput>">
                                <input type="text" name="department" id="department" value="<cfoutput>#get_position_detail.department_head#</cfoutput>" readonly>
                                <span class="input-group-addon btnPointer icon-ellipsis" onclick="javascript:openBoxDraggable('<cfoutput>#request.self#?fuseaction=hr.popup_list_departments&field_id=upd_pos.department_id&field_name=upd_pos.department</cfoutput>&field_branch_name=upd_pos.branch&field_branch_id=upd_pos.branch_id<cfif isdefined("x_position_manager_set") and x_position_manager_set eq 1>&field_manager1_poscode=upd_pos.upper_position_code&field_manager1_pos=upd_pos.upper_position&field_manager2_poscode=upd_pos.upper_position_code2&field_manager2_pos=upd_pos.upper_position2</cfif>');"></span>              
                            </div>
                        </div>              
                    </div>
                    <input type="hidden" name="old_position_name" id="old_position_name" value="<cfoutput>#get_position_detail.POSITION_NAME#</cfoutput>">
                    <div class="form-group" id="item-position_name">
                        <label class="col col-4"><cf_get_lang dictionary_id='58497.Pozisyon'></label>
                        <div class="col col-8">
                            <div class="input-group">
                                <cfinput maxlength="50"  type="Text" name="POSITION_NAME" id="position_name" value="#get_position_detail.POSITION_NAME_#">
                                <span class="input-group-addon btnPointer icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_list_position_names&field_name=upd_pos.POSITION_NAME');"></span>              
                                <span class="input-group-addon">
                                    <cf_language_info
                                        table_name="EMPLOYEE_POSITIONS"
                                        column_name="POSITION_NAME" 
                                        column_id_value="#attributes.POSITION_ID#" 
                                        maxlength="500" 
                                        datasource="#dsn#" 
                                        column_id="POSITION_ID" 
                                        control_type="0">
                                </span>
                            </div>
                        </div>                
                    </div>
                    <div class="form-group" id="item-position_cat_id">
                        <label class="col col-4"><cf_get_lang dictionary_id='59004.Pozisyon Tipi'> *</label>
                        <div class="col col-8">
                            <div class="input-group">
                                <input type="hidden" name="old_position_cat_id" id="old_position_cat_id" value="<cfoutput>#get_position_detail.position_cat_id#</cfoutput>">
                                <select name="position_cat_id" id="position_cat_id" onchange="change_fields();">
                                    <cfoutput query="get_position_cats">
                                        <option value="#position_cat_id#;#position_cat#" <cfif get_position_detail.position_cat_id eq position_cat_id> selected</cfif>>#position_cat#</option>
                                    </cfoutput>
                                </select>
                                <span class="input-group-addon btnPointer icon-question" onclick="open_position_norm();"></span>              
                            </div>
                        </div>                
                    </div>
                    <div class="form-group" id="item-title_id">
                        <label class="col col-4"><cf_get_lang dictionary_id='57571.Ünvan'></label>
                        <div class="col col-8">
                            <input type="hidden" name="old_title_id" id="old_title_id" value="<cfoutput>#get_position_detail.title_id#</cfoutput>">
                            <select name="title_id" id="title_id">
                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                <cfoutput query="titles"> 
                                    <option value="#title_id#" <cfif get_position_detail.title_id eq title_id>selected</cfif>>#title#</option> 
                                </cfoutput>
                            </select>
                        </div> 
                    </div>
                    <div class="form-group" id="item-process_stage">
                        <label class="col col-4"><cf_get_lang dictionary_id="58859.Süreç"></label>
                        <div class="col col-8">
                            <cf_workcube_process 
                                is_upd='0' 
                                select_value='#get_position_detail.position_stage#' 
                                process_cat_width='201' 
                                is_detail='1'>
                        </div>                
                    </div>
                    <div class="form-group" id="item-textfield">
                        <label class="col col-4"><cf_get_lang dictionary_id='55661.Açılış Tarihi'></label>
                        <div class="col col-8">
                            <input type="text" name="textfield" id="textfield" value="<cfoutput>#dateformat(get_last_hist_row.start_date,dateformat_style)#</cfoutput>" readonly>
                        </div>                
                    </div>
                    <div class="form-group" id="item-is_observation">
                        <label class="col col-4"><cf_get_lang dictionary_id='55089.Gözlem Süresi'></label>
                        <div class="col col-8">
                            <div class="input-group">
                                <span class="input-group-addon"><input type="checkbox" name="is_observation" id="is_observation" value="1"<cfif get_position_detail.is_observation eq 1> checked</cfif>></span>
                                <cfinput type="text" name="observation_date" value="#dateformat(get_position_detail.observation_date,dateformat_style)#" validate="#validate_style#" maxlength="10">
                                <span class="input-group-addon"><cf_wrk_date_image date_field="observation_date"></span>
                            </div>
                        </div>                
                    </div>
                </div>
                <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
                    <div class="form-group" id="item-func_id">
                        <label class="col col-4"><cf_get_lang dictionary_id='58701.Fonksiyon'></label>
                        <div class="col col-8">
                            <input type="hidden" name="old_func_id" id="old_func_id" value="<cfoutput>#get_position_detail.func_id#</cfoutput>">
                            <select name="func_id" id="func_id">
                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                <cfoutput query="get_units">
                                    <option value="#get_units.unit_id#" <cfif unit_id eq get_position_detail.func_id>selected</cfif>>#unit_name#</option>
                                </cfoutput>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-organization_step_id">
                        <label class="col col-4"><cf_get_lang dictionary_id='58710.Kademe'></label>
                        <div class="col col-8">
                            <input type="hidden" name="old_organization_step_id" id="old_organization_step_id" value="<cfoutput>#get_position_detail.organization_step_id#</cfoutput>">
                            <select name="organization_step_id" id="organization_step_id">
                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                <cfoutput query="get_organization_steps">
                                    <option value="#organization_step_id#" <cfif organization_step_id eq get_position_detail.organization_step_id>selected</cfif>>#organization_step_name#</option>
                                </cfoutput>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-collar_type">
                        <label class="col col-4"><cf_get_lang dictionary_id='56063.Yaka Tipi'></label>
                        <div class="col col-8">
                            <input type="hidden" name="old_collar_type" id="old_collar_type" value="<cfoutput>#get_position_detail.collar_type#</cfoutput>">
                            <select name="collar_type" id="collar_type">
                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                <option value="1" <cfif get_position_detail.collar_type eq 1> selected</cfif>><cf_get_lang dictionary_id='56065.Mavi Yaka'></option> 
                                <option value="2" <cfif get_position_detail.collar_type eq 2> selected</cfif>><cf_get_lang dictionary_id='56066.Beyaz Yaka'></option>
                            </select>		
                        </div>
                    </div>
                    <div class="form-group" id="item-ozel_kod">
                        <label class="col col-4"><cf_get_lang dictionary_id='57789.Özel kod'></label>
                        <div class="col col-8">
                            <input type="Text" name="ozel_kod" id="ozel_kod" value="<cfoutput>#get_position_detail.ozel_kod#</cfoutput>" maxlength="50">
                        </div>                
                    </div>
                    <div class="form-group" id="item-employee">
                        <label class="col col-4"><cf_get_lang dictionary_id='57576.Çalışan'></label>
                        <div class="col col-8">
                            <div <cfif get_position_detail.employee_id eq 0 or get_position_detail.employee_id is "">class="input-group"</cfif>>
                                <input type="hidden" name="pos" id="pos" value="0">
                                <cfif get_position_detail.EMPLOYEE_ID neq 0 and len(get_position_detail.EMPLOYEE_ID)>
                                    <cfset emp_name="#get_position_detail.EMPLOYEE_NAME# #get_position_detail.EMPLOYEE_SURNAME#">
                                    <cfset emp_id=get_position_detail.EMPLOYEE_ID>
                                    <input type="hidden" name="old_emp_id" id="old_emp_id" value="<cfoutput>#emp_id#</cfoutput>">
                                <cfelse>
                                    <cfset emp_name="Pozisyon Boş">
                                    <input type="hidden" name="old_emp_id" id="old_emp_id" value="0">
                                    <cfset emp_id="">
                                </cfif>
                                <input type="hidden" name="employee_id" id="employee_id" value="<cfoutput>#emp_id#</cfoutput>">
                                <input type="text" name="employee" id="employee" value="<cfoutput>#emp_name#</cfoutput>" >
                                <cfif get_position_detail.employee_id eq 0 or get_position_detail.employee_id is "">
                                    <span class="input-group-addon icon-ellipsis btnPointer" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=hr.popup_list_emps&field_id=upd_pos.employee_id&field_name=upd_pos.employee&pos=1</cfoutput>');"></span>
                                </cfif>
                            </div>
                        </div>                
                    </div>
                    <div class="form-group" id="item-upper_position">
                        <label class="col col-4"><cf_get_lang dictionary_id='56110.Birinci Amir'></label>
                        <div class="col col-8">
                            <div class="input-group">
                                <cfif len(get_position_detail.upper_position_code)>
                                    <cfset attributes.pos_code = get_position_detail.upper_position_code>
                                    <cfinclude template="../query/get_position_info.cfm">
                                </cfif>
                                <input type="hidden" name="old_upper_position_code" id="old_upper_position_code" value="<cfoutput>#get_position_detail.upper_position_code#</cfoutput>">
                                <input type="hidden" name="old_upper_position" id="old_upper_position" value="<cfif len(get_position_detail.upper_position_code)><cfoutput>#get_position_info.position_name# - #get_position_info.employee_name# #get_position_info.employee_surname#</cfoutput></cfif>">
                                <input type="hidden" name="position_id" id="position_id" value="<cfoutput>#get_position_detail.upper_position_code#</cfoutput>">
                                <input type="hidden" name="upper_position_code" id="upper_position_code" value="<cfoutput>#get_position_detail.upper_position_code#</cfoutput>">
                                <input type="text" name="upper_position" id="upper_position" value="<cfif len(get_position_detail.upper_position_code)><cfoutput>#get_position_info.position_name# - #get_position_info.employee_name# #get_position_info.employee_surname#</cfoutput></cfif>">
                                <span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_list_positions&field_code=upd_pos.upper_position_code&position_employee=upd_pos.upper_position&show_empty_pos=1');return false"></span>
                            </div>
                        </div>                
                    </div>
                    <div class="form-group" id="item-upper_position2">
                        <label class="col col-4"><cf_get_lang dictionary_id='56111.İkinci Amir'></label>
                        <div class="col col-8">
                            <div class="input-group">
                                <cfif len(get_position_detail.upper_position_code2)>
                                    <cfset attributes.pos_code = get_position_detail.upper_position_code2>
                                    <cfinclude template="../query/get_position_info.cfm">
                                </cfif>
                                <input type="hidden" name="old_upper_position_code2" id="old_upper_position_code2" value="<cfoutput>#get_position_detail.upper_position_code2#</cfoutput>">
                                <input type="hidden" name="old_upper_position2" id="old_upper_position2" value="<cfif len(get_position_detail.upper_position_code2)><cfoutput>#get_position_info.position_name# - #get_position_info.employee_name# #get_position_info.employee_surname#</cfoutput></cfif>">
                                <input type="hidden" name="upper_position_code2" id="upper_position_code2" value="<cfoutput>#get_position_detail.upper_position_code2#</cfoutput>">
                                <input type="text" name="upper_position2" id="upper_position2" value="<cfif len(get_position_detail.upper_position_code2)><cfoutput>#get_position_info.position_name# - #get_position_info.employee_name# #get_position_info.employee_surname#</cfoutput></cfif>">
                                <span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_list_positions&field_code=upd_pos.upper_position_code2&position_employee=upd_pos.upper_position2&show_empty_pos=1');return false"></span>
                            </div>
                        </div>                
                    </div>
                </div>
                <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="4" sort="true">
                    <div class="form-group" id="item-hierarchy">
                        <label class="col col-4"><cf_get_lang dictionary_id='57761.Hiyerarşi'></label>
                        <div class="col col-8">
                            <input type="Text" name="hierarchy" id="hierarchy" value="<cfoutput>#get_position_detail.hierarchy#</cfoutput>" readonly>
                        </div>                
                    </div>
                    <cfif fusebox.dynamic_hierarchy>
                        <div class="form-group" id="item-dynamic_hierarchy">
                            <label class="col col-4"><cf_get_lang dictionary_id='56318.Dinamik Hiyerarşi'></label>
                            <div class="col col-4">                    
                                <input type="text" name="dynamic_hierarchy" id="dynamic_hierarchy" value="<cfoutput>#get_position_detail.dynamic_hierarchy#</cfoutput>" readonly>                                         
                            </div>
                            <div class="col col-4">
                                <input type="text" name="dynamic_hierarchy_add" id="dynamic_hierarchy_add" value="<cfoutput>#get_position_detail.dynamic_hierarchy_add#</cfoutput>">  
                            </div>
                        </div>
                    </cfif>
                    <div class="form-group" id="item-detail">
                        <label class="col col-4"><cf_get_lang dictionary_id='57629.Açıklama'></label>
                        <div class="col col-8">
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='56884.100 karakterden fazla yazmayınız'></cfsavecontent>
                            <textarea name="detail" id="detail" maxlength="100" onkeyup="return ismaxlength(this)" onblur="return ismaxlength(this);" message="<cfoutput>#message#</cfoutput>"><cfoutput>#get_position_detail.DETAIL#</cfoutput></textarea>
                        </div>                
                    </div>
                    <input type="hidden" name="confirmed" id="confirmed" value="">
                    <input type="hidden" name="change" id="change" value="">
                    <input type="hidden" name="rejected" id="rejected" value=""> 
                    <div class="form-group" id="item-vekaleten_date">
                        <label class="col col-4"><cf_get_lang dictionary_id='55573.Vekaleten'></label>	       
                        <div class="col col-8">
                            <div class="input-group">
                                <span class="input-group-addon">
                                    <input type="checkbox" name="is_vekaleten" id="is_vekaleten" value="1"<cfif get_position_detail.is_vekaleten eq 1> checked</cfif>>
                                    <cfif browserDetect() contains 'Chrome'>&nbsp;</cfif>
                                </span>
                                <cfinput type="text" name="vekaleten_date" value="#dateformat(get_position_detail.vekaleten_date,dateformat_style)#" validate="#validate_style#" maxlength="10">
                                <span class="input-group-addon">
                                    <cf_wrk_date_image date_field="vekaleten_date">
                                </span>
                            </div>
                        </div>
                    </div>
                    <!--- görev tarihi kisi kartinda hangi pozisyonlara hangi tarihlerde giris cikis yapmis oldugunu görebilmek için eklenmiştir. SG20120723--->   
                    <div class="form-group" id="item-position_in_out_date">
                        <label class="col col-4"><cf_get_lang dictionary_id="57569.Görevli"><cf_get_lang dictionary_id="55602.Başl/Bitiş Tarihi"></label>
                        <div class="col col-8">
                            <div class="input-group">
                                <cfif x_position_change_reason_control eq 1>
                                    <cfinput type="text" name="position_in_out_date" id="position_in_out_date" onChange="reset_reason();" value="" validate="#validate_style#" maxlength="10">
                                <cfelse>
                                    <cfinput type="text" name="position_in_out_date" id="position_in_out_date" value="" validate="#validate_style#" maxlength="10">
                                </cfif>
                                <span class="input-group-addon"><cf_wrk_date_image date_field="position_in_out_date"></span>
                            </div>
                        </div>                
                    </div>
                    <cfoutput>
                        <cfif listlen(get_position_detail.hierarchy_dep_id,'.') gt 1>
                            <div class="form-group" id="item-upper_department">
                                <label class="col col-4 bold"><cf_get_lang dictionary_id="55989.Üst Departmanlar"></label>
                                <div class="col col-8">
                                    <cfloop list="#get_position_detail.hierarchy_dep_id#" index="dep_id" delimiters=".">
                                        <cfif ListLast(get_position_detail.hierarchy_dep_id,'.') neq dep_id>
                                            <cfquery name="get_dep_name" datasource="#dsn#">
                                                SELECT DEPARTMENT_ID,#dsn#.Get_Dynamic_Language(DEPARTMENT_ID,'#session.ep.language#','DEPARTMENT','DEPARTMENT_HEAD',NULL,NULL,DEPARTMENT_HEAD) AS DEPARTMENT_HEAD FROM DEPARTMENT WHERE DEPARTMENT_ID = #dep_id#
                                            </cfquery>
                                            <cfif get_dep_name.recordcount>
                                                #get_dep_name.department_head#<br>
                                            </cfif>
                                        </cfif>
                                    </cfloop>
                                </div>
                            </div>
                        </cfif>
                    </cfoutput>
                </div>
            </cf_box_elements>
            <cf_box_footer>
                <div class="col col-6"><cf_record_info query_name="get_position_detail"></div>
                <div class="col col-6"><cf_workcube_buttons type_format="1" is_upd='1' is_delete='0' add_function="chk()"></div>
            </cf_box_footer>
        </cf_box>
            <cfif get_position_detail.employee_id neq 0 and len(get_position_detail.employee_id)>
                <cfset attributes.employee_id = get_position_detail.employee_id>
                <cf_box
                    closable="1" 
                    id="multi_pos_id"
                    unload_body="1" 
                    title="#getLang('hr',498)#"
                    style="width:99%"
                    box_page="#request.self#?fuseaction=hr.dsp_multi_pos&position_id=#attributes.position_id#&employee_id=#attributes.employee_id#">
                </cf_box>
            </cfif>
            <cfif len(get_position_detail.employee_id) and (get_position_detail.employee_id neq 0)>
                    <cfset attributes.employee_id = get_position_detail.employee_id>
                    <!--- Diger Roller Is Grupları --->
                    <cfscript>
                        info_href = "#request.self#?fuseaction=hr.popup_list_select_roles&employee_id=#attributes.employee_id#";
                        add_href = "#request.self#?fuseaction=hr.list_workgroup&event=add&employee_id=#attributes.employee_id#";
                    </cfscript>
                    <cf_box
                        closable="0" 
                        id="pos_work_groups"
                        unload_body="1" 
                        info_href="#info_href#"
                        add_href="#add_href#"
                        add_href_size="small"
                        title="#getLang('main','İş Grupları',29818)#"
                        style="width:99%"
                        box_page="#request.self#?fuseaction=hr.upd_position_work_groups&position_id=#attributes.position_id#&employee_id=#attributes.employee_id#">
                    </cf_box>
            </cfif>
    </cfform>
</div>
<div class="col col-12 col-xs-12">
    <cfset position_id_ = attributes.position_id>
    <cf_box id="PositionDiv" closable="1"  collapsable="1"  title="#getLang(dictionary_id: 61267)#" widget_load="PositionAssistant&position_id_=#position_id_#">
        
    </cf_box>
</div>
<script type="text/javascript">
    $( document ).ready(function() {
        <cfif x_pos_type_manuel eq 0>
            document.getElementById("position_name").readOnly = true;
        </cfif>
        document.getElementById("department").readOnly = true;
    });
	function open_position_norm()
	{
		mk = document.upd_pos.position_cat_id.selectedIndex;
		if(document.upd_pos.position_cat_id[mk].value == "")
			alert("<cf_get_lang dictionary_id ='56323.Pozisyon Tipi Seçmelisiniz'>!");
		else
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_list_position_cat_norms&position_cat_id=' + list_getat(document.upd_pos.position_cat_id[mk].value,1,';'),'horizantal');
	}
	function change_fields(){
		var dizi = document.upd_pos.position_cat_id.value.split(';');
		$("#title_id").find("option").prop('selected',false);
		$("#organization_step_id").find("option").prop('selected',false);
		$("#func_id").find("option").prop('selected',false);
		$("#collar_type").find("option").prop('selected',false);
		if(dizi[0] != '')
		{
			var pos_cat_det = wrk_query('SELECT TITLE_ID, FUNC_ID, ORGANIZATION_STEP_ID, COLLAR_TYPE FROM SETUP_POSITION_CAT WHERE POSITION_CAT_ID = '+dizi[0],'dsn');
			if (pos_cat_det){
				if (pos_cat_det.TITLE_ID != '')
					$("#title_id").find("option[value="+pos_cat_det.TITLE_ID+"]").prop("selected","selected");
				if (pos_cat_det.ORGANIZATION_STEP_ID != '')
					$("#organization_step_id").find("option[value="+pos_cat_det.ORGANIZATION_STEP_ID+"]").prop("selected","selected");
				if (pos_cat_det.FUNC_ID != '')
					$("#func_id").find("option[value="+pos_cat_det.FUNC_ID+"]").prop("selected","selected");
				if (pos_cat_det.COLLAR_TYPE != '')
					$("#collar_type").find("option[value="+pos_cat_det.COLLAR_TYPE+"]").prop("selected","selected");
			}
		}
	}
</script>