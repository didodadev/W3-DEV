<cf_xml_page_edit fuseact="hr.form_add_position"> 
<cfinclude template="../query/get_titles.cfm">
<cfinclude template="../query/get_modules.cfm">
<cfinclude template="../query/get_moneys.cfm">
<cfinclude template="../query/get_user_groups.cfm">
<cfinclude template="../query/get_position_cats.cfm">
<cfif fuseaction contains "popup">
	<cfset is_popup = 1 >
<cfelse>
	<cfset is_popup = 0 >
</cfif>
<cfif not get_user_groups.recordcount>
	<script type="text/javascript">
		alert("<cf_get_lang dictionary_id='56067.Pozisyon Ekleyebileceğiniz Standart Bir Yetki Grubu Tanımlaması veya Gecerli Kullanıcı Grubu Bulunmamaktadır'>!");
		history.back();
	</script>	
	<cfabort>
</cfif>
<cfif not isDefined("attributes.isAjax")><!--- Organizasyon Yönetimi sayfasında gözükmesin diye eklendi--->
    <cf_catalystHeader>
</cfif>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cfform name="add_pos" action="#request.self#?fuseaction=hr.emptypopup_add_position" method="post"><!--- onsubmit="return control();"--->
            <input type="Hidden" id="counter">
            <input type="hidden" name="group_id" id="group_id" value="<cfoutput>#get_user_groups.user_group_id#</cfoutput>">
            <input type="hidden" name="x_position_change_control" id="x_position_change_control" value="<cfoutput>#x_position_change_control#</cfoutput>">
            <cfif isdefined("attributes.isAjax") and len(attributes.isAjax)>
                <cfoutput>
                    <input type="hidden" name="callAjax" id="callAjax" value = "1">
                    <input type="hidden" name="branch_id" id="branch_id" value = "#attributes.branch_id#">
                    <input type="hidden" name="branch" id="branch" value = "#attributes.branch#">
                    <input type="hidden" name="comp_id" id="comp_id" value = "#attributes.comp_id#">
                    <input type="hidden" name="department_id" id="department_id" value = "#attributes.department_id#">
                    <input type="hidden" name="position_catid" id="position_catid" value = "#attributes.position_catid#">
                </cfoutput>
            </cfif> 
            <!--- <cfif isDefined("attributes.isAjax") and attributes.isAjax eq 1><!--- Organizasyon Yönetimi sayfasından Ajax ile yüklendiyse --->
                <cf_box title="#title#" closable="0">
            </cfif> --->
            <cfoutput>
                <cf_box_elements>
                    <div class="col col-12 col-md-12 col-sm-12 col-xs-12" type="column" index="1" sort="true">
                        <div class="form-group col col-2 col-md-2 col-sm-6 col-xs-12" id="item-status">
                            <label class="col col-12 col-md-12 col-sm-12 col-xs-12">
                                <input type="checkbox" name="status" id="status" value="" checked><cf_get_lang dictionary_id='57493.Aktif'>
                            </label>
                        </div>
                        <div class="form-group col col-2 col-md-2 col-sm-6 col-xs-12" id="item-is_master">
                            <label class="col col-12 col-md-12 col-sm-12 col-xs-12">
                                <input type="checkbox" name="is_master" id="is_master" value="1" checked><cf_get_lang dictionary_id='56058.Master'>
                            </label>
                        </div>
                        <div class="form-group col col-2 col-md-2 col-sm-6 col-xs-12" id="item-is_critical">
                            <label class="col col-12 col-md-12 col-sm-12 col-xs-12">
                                <input type="checkbox" name="is_critical" id="is_critical"><cf_get_lang dictionary_id='55992.Kritik Pozisyon'>
                            </label>
                        </div>
                        <div class="form-group col col-2 col-md-2 col-sm-6 col-xs-12" id="item-is_org_view">
                            <label class="col col-12 col-md-12 col-sm-12 col-xs-12">
                                <input type="checkbox" name="is_org_view" id="is_org_view" checked><cf_get_lang dictionary_id='56059.Org Şemada Göster'>
                            </label>
                        </div>
                    </div>
                    <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                        <div class="form-group" id="item-reason_id">
                            <label class="col col-4"><cf_get_lang dictionary_id ='55550.Gerekçe'></label>
                            <div class="col col-8">
                                <cf_wrk_combo 
                                    query_name="GET_FIRE_REASONS"
                                    name="reason_id"
                                    option_value="reason_id"
                                    option_name="reason"
                                    width="444"
                                    where="IS_ACTIVE=1 AND IS_POSITION=1">
                            </div>                
                        </div>
                        <div class="form-group" id="item-branch">
                            <label class="col col-4"><cf_get_lang dictionary_id ='57453.Şube'></label>
                            <div class="col col-8">
                                <input type="hidden" name="branch_id" id="branch_id" value="<cfif isdefined("attributes.branch_id") and len(attributes.branch_id)><cfoutput>#attributes.branch_id#</cfoutput></cfif>">
                                <input type="text" name="branch" id="branch" value="<cfif isdefined("attributes.branch") and len(attributes.branch)>#attributes.branch#</cfif>" readonly>
                            </div>                
                        </div>
                        <div class="form-group" id="item-department">
                            <label class="col col-4"><cf_get_lang dictionary_id='57572.Departman'> *</label>
                            <div class="col col-8">
                                <div class="input-group">
                                    <input type="hidden" name="department_id" id="department_id" value="<cfif isdefined("attributes.department_id") and len(attributes.department_id)>#attributes.department_id#</cfif>">
                                    <input type="text" name="department" id="department" value="<cfif isdefined("attributes.department") and len(attributes.department)>#attributes.department#</cfif>" readonly>
                                    <span class="input-group-addon btnPointer icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=hr.popup_list_departments&field_id=add_pos.department_id&field_name=add_pos.department&field_branch_name=add_pos.branch&field_branch_id=add_pos.branch_id<cfif isdefined("x_position_manager_set") and x_position_manager_set eq 1>&field_manager1_poscode=add_pos.upper_position_code&field_manager1_pos=add_pos.upper_position&field_manager2_poscode=add_pos.upper_position_code2&field_manager2_pos=add_pos.upper_position2</cfif></cfoutput>');"></span>              
                                </div>
                            </div>                
                        </div>
                        <div class="form-group" id="item-position_name">
                            <label class="col col-4"><cf_get_lang dictionary_id='58497.Pozisyon'></label>
                            <div class="col col-8">
                                <div class="input-group">
                                    <cfif x_pos_type_manuel eq 0>
                                        <cfinput type="text" name="position_name" id="position_name" value=""  maxlength="50" readonly>
                                    <cfelse>
                                        <cfinput type="text" name="position_name" id="position_name" value=""  maxlength="50" > 
                                    </cfif>
                                    <span class="input-group-addon btnPointer icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_list_position_names&field_name=add_pos.position_name');"></span>              
                                </div>
                            </div>                
                        </div>
                        <div class="form-group" id="item-position_cat_id">
                            <label class="col col-4"><cf_get_lang dictionary_id='59004.Pozisyon Tipi'> *</label>
                            <div class="col col-8">
                                <div class="input-group">
                                    <select name="position_cat_id" id="position_cat_id" onchange="change_fields();">
                                        <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                        <cfloop query="get_position_cats">
                                            <option value="#POSITION_CAT_ID#;#POSITION_CAT#" <cfif isdefined("attributes.position_catid") and len(attributes.position_catid) and attributes.position_catid eq POSITION_CAT_ID >selected</cfif>>#POSITION_CAT#</option>
                                        </cfloop>
                                    </select>
                                    <span class="input-group-addon btnPointer icon-question" onclick="open_position_norm();"></span>              
                                </div>
                            </div>                
                        </div>
                        <div class="form-group" id="item-title_id">
                            <label class="col col-4"><cf_get_lang dictionary_id='57571.Ünvan'> *</label>
                            <div class="col col-8">
                                <select name="title_id" id="title_id">
                                    <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                    <cfloop query="titles"> 
                                        <option value="#title_ID#">#title#</option> 
                                    </cfloop>
                                </select>                           
                            </div>
                        </div>
                        <div class="form-group" id="item-process_stage">
                            <label class="col col-4"><cf_get_lang dictionary_id="58859.Süreç"></label>
                            <div class="col col-8">
                                <cf_workcube_process is_upd='0' process_cat_width='150' is_detail='0'>
                            </div>                
                        </div>
                    </div>
                    <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
                        <div class="form-group" id="item-func_id">
                            <label class="col col-4"><cf_get_lang dictionary_id='58701.Fonksiyon'></label>
                            <div class="col col-8">
                                <cfquery name="get_units" datasource="#DSN#">
                                    SELECT * FROM SETUP_CV_UNIT ORDER BY UNIT_NAME
                                </cfquery>
                                <select name="func_id" id="func_id">
                                    <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'>
                                    <cfloop query="get_units">
                                        <option value="#get_units.unit_id#">#get_units.unit_name#
                                    </cfloop>
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="item-organization_step_id">
                            <label class="col col-4"><cf_get_lang dictionary_id='58710.Kademe'></label>
                            <div class="col col-8">
                                <cfquery name="get_organization_steps" datasource="#dsn#">
                                    SELECT 
                                        ORGANIZATION_STEP_ID,
                                        ORGANIZATION_STEP_NAME
                                    FROM
                                        SETUP_ORGANIZATION_STEPS
                                    ORDER BY
                                        ORGANIZATION_STEP_NAME
                                </cfquery>
                                <select name="organization_step_id" id="organization_step_id">
                                    <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'>
                                    <cfloop query="get_organization_steps">
                                        <option value="#organization_step_id#">#ORGANIZATION_STEP_NAME#                            
                                    </cfloop>
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="item-collar_type">
                            <label class="col col-4"><cf_get_lang dictionary_id='56063.Yaka Tipi'></label>
                            <div class="col col-8">
                                <select name="collar_type" id="collar_type">
                                    <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'>
                                    <option value="1"><cf_get_lang dictionary_id='56065.Mavi Yaka'> 
                                    <option value="2"><cf_get_lang dictionary_id='56066.Beyaz Yaka'> 
                                </select>		
                            </div>
                        </div>
                        <cfif fusebox.dynamic_hierarchy>
                            <div class="form-group" id="item-dynamic_hierarchy">
                                <label class="col col-4"><cf_get_lang dictionary_id ='56318.Dinamik Hiyerarşi'></label>
                                <div class="col col-4">
                                    <input type="text" name="dynamic_hierarchy" id="dynamic_hierarchy" value="" readonly>
                                </div>
                                <div class="col col-4">
                                    <input type="text" name="dynamic_hierarchy_add" id="dynamic_hierarchy_add" value="">
                                </div>                
                            </div>
                        </cfif>
                        <div class="form-group" id="item-ozel_kod">
                            <label class="col col-4"><cf_get_lang dictionary_id='57789.Özel kod'></label>
                            <div class="col col-8">
                                <input type="text" name="ozel_kod" id="ozel_kod" value="" maxlength="50">
                            </div>                
                        </div>
                        <div class="form-group" id="item-employee">
                            <label class="col col-4"><cf_get_lang dictionary_id='57576.Çalışan'></label>
                            <div class="col col-8">
                                <div class="input-group">
                                    <input type="hidden" name="pos" id="pos" value="0" >
                                    <input type="hidden" name="employee_id" id="employee_id" value="<cfif isdefined('attributes.employee_id') and len(attributes.employee_id)><cfoutput>#attributes.employee_id#</cfoutput></cfif>">
                                    <input type="text" name="employee" id="employee" value="<cfif isdefined('attributes.employee_id') and len(attributes.employee_id)><cfoutput>#get_emp_info(attributes.employee_id,0,0)#</cfoutput></cfif>">
                                    <span class="input-group-addon icon-ellipsis btnPointer" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=hr.popup_list_emps&field_id=add_pos.employee_id&field_name=add_pos.employee&pos=1</cfoutput>');"></span>
                                </div>
                            </div>                
                        </div>
                    </div>
                    <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="4" sort="true">
                        <div class="form-group" id="item-upper_position">
                            <label class="col col-4"><cf_get_lang dictionary_id='56110.Birinci Amir'></label>
                            <div class="col col-8">
                                <div class="input-group">
                                    <input type="hidden" name="upper_position_code" id="upper_position_code" value="">
                                    <input type="text" name="upper_position" id="upper_position" value="">
                                    <span class="input-group-addon btnPointer icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_list_positions&field_code=add_pos.upper_position_code&position_employee=add_pos.upper_position&show_empty_pos=1');return false"></span>
                                </div>
                            </div>                
                        </div>
                        <div class="form-group" id="item-upper_position2">
                            <label class="col col-4"><cf_get_lang dictionary_id='56111.İkinci Amir'></label>
                            <div class="col col-8">
                                <div class="input-group">
                                    <input type="hidden" name="upper_position_code2" id="upper_position_code2" value="">
                                    <input type="text" name="upper_position2" id="upper_position2" value="">
                                    <span class="input-group-addon btnPointer icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_list_positions&field_code=add_pos.upper_position_code2&position_employee=add_pos.upper_position2&show_empty_pos=1');return false"></span>
                                </div>
                            </div>                
                        </div>
                        <div class="form-group" id="item-vekaleten_date">
                            <label class="col col-4"><cf_get_lang dictionary_id='55573.Vekaleten'></label>	       
                            <div class="col col-8">
                                <div class="input-group">
                                    <span class="input-group-addon">
                                        <input type="Checkbox" name="is_vekaleten" id="is_vekaleten" value="1">
                                        <cfif browserDetect() contains 'Chrome'>&nbsp;</cfif>
                                    </span>
                                    <cfinput type="text" name="vekaleten_date" value="" validate="#validate_style#" maxlength="10">
                                    <span class="input-group-addon">
                                        <cf_wrk_date_image date_field="vekaleten_date">
                                    </span>
                                </div>
                            </div>
                        </div>
                        <!--- görev tarihi kisi kartinda hangi pozisyonlara hangi tarihlerde giris cikis yapmis oldugunu görebilmek için eklenmiştir. SG20120723--->   
                        <div class="form-group" id="item-position_in_out_date">
                            <label class="col col-4"><cf_get_lang dictionary_id='55438.Görev Başlangıç Tarihi'></label>
                            <div class="col col-8">
                                <div class="input-group">
                                    <cfinput type="text" name="position_in_out_date" id="position_in_out_date" value="" validate="#validate_style#" maxlength="10">
                                    <span class="input-group-addon"><cf_wrk_date_image date_field="position_in_out_date"></span>
                                </div>
                            </div>                
                        </div> 
                        <div class="form-group" id="item-detail">
                            <label class="col col-4"><cf_get_lang dictionary_id='57629.Açıklama'></label>
                            <div class="col col-8">
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='29484.Fazla karakter sayısı'></cfsavecontent>
                                <textarea name="detail" id="detail" maxlength="100" rows="4" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="<cfoutput>#message#</cfoutput>"></textarea>
                            </div>                
                        </div>  
                    </div>
                </cf_box_elements>
                <cf_box_footer>
                    <cf_workcube_buttons type_format="1" is_upd='0' add_function='control()'> <!---///butonlar--->
                </cf_box_footer>
            </cfoutput>
        </cfform>
    </cf_box>
</div>
<script type="text/javascript">
	function dsp_button()
	{
		buton.style.display='';
	}
	function open_position_norm()
	{
		mk = document.getElementById('position_cat_id').selectedIndex;
		if(document.add_pos.position_cat_id[mk].value == "")
			alert("<cf_get_lang dictionary_id ='56323.Pozisyon Tipi Seçmelisiniz'>!");
		else
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_list_position_cat_norms&position_cat_id=' + list_getat(document.add_pos.position_cat_id[mk].value,1,';'),'horizantal');
	}
	function control()
	{
		if (document.getElementById('department_id').value == "")
		{
			alert("<cf_get_lang dictionary_id='57572.Departman'> !");
			return false;
		}
		if (document.getElementById('title_id').selectedIndex == 0)
		{
			alert("<cf_get_lang dictionary_id='57571.Ünvan'> !");
			return false;
		}
		if (document.getElementById('position_cat_id').selectedIndex == 0)
		{
			alert("<cf_get_lang dictionary_id='59004.Pozisyon Tipi'> !");
			return false;
		}
		if(document.getElementById('x_position_change_control').value == 1 && document.getElementById('employee_id').value != "" && document.getElementById('employee').value != "" && document.getElementById('position_in_out_date').value == "") //görev değişikliği kontrolleri yapılsın evet ise
		{
			alert("<cf_get_lang dictionary_id='38648.Lütfen Görev Başlangıç Tarihini Giriniz'>!");
			return false;
		}
		return process_cat_control();
		
		<cfif isdefined("attributes.position_name") and len(attributes.position_name)>
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_list_simular_employees&position_cat_id=' + list_getat(document.getElementById('position_cat_id').value,1,';') + '&position_name=' + document.getElementById('position_name').value + '&department_id=' + document.getElementById('department_id').value + '&title_id=' + document.getElementById('title_id').value,'medium');
		<cfelse>
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_list_simular_employees&position_cat_id=' + list_getat(document.getElementById('position_cat_id').value,1,';') + '&position_name=&department_id=' + document.getElementById('department_id').value + '&title_id=' + document.getElementById('title_id').value,'medium');
		</cfif>
		return false;
	}
	function change_fields(){
		var dizi = document.add_pos.position_cat_id.value.split(';');
		$("#title_id").find("option").prop('selected',false);
		$("#organization_step_id").find("option").prop('selected',false);
		$("#func_id").find("option").prop('selected',false);
		$("#collar_type").find("option").prop('selected',false);
		if(dizi[0] != '')
		{
			var pos_cat_det = wrk_query('SELECT TITLE_ID, FUNC_ID, ORGANIZATION_STEP_ID, COLLAR_TYPE FROM SETUP_POSITION_CAT WHERE POSITION_CAT_ID = '+dizi[0],'dsn');
			if (pos_cat_det)
			{
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
