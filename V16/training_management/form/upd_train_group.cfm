<cfset groups = createObject("component","V16.training_management.cfc.training_groups")>
<!--- <cfinclude template="../query/get_train_groups.cfm"> --->
<cfset get_group = groups.get_training_group(train_group_id: attributes.train_group_id)>
<!--- <cfset GET_SITE_MENU = groups.SELECTSITE_MENU()/> --->
<cfset GET_SITE_DOMAIN = groups.getSiteDomain(train_group_id:attributes.train_group_id)/>
<cfset cmp = createObject("component","V16.training_management.cfc.training_management")>
<cfset get_site_menu = cmp.GET_COMPANY_F()>
<cfset cmp_branch = createObject("component","V16.hr.cfc.get_branch_comp")>
<cfset cmp_branch.dsn = dsn>
<cfset get_branches = cmp_branch.get_branch(branch_status:1,comp_id : session.ep.company_id)>
<cfset cmp_department = createObject("component","V16.hr.cfc.get_departments")>
<cfset cmp_department.dsn = dsn>
<cfset get_department = cmp_department.get_department()>

<cf_catalystHeader>
<div class="col col-9 col-xs-12 uniqueRow">
    <cfform name="upd_group" method="post" action="#request.self#?fuseaction=training_management.emptypopup_upd_train_group">
        <cf_box title="#get_group.group_head#">
            <cf_box_elements>
                <div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                    <cfinput type="hidden" name="train_group_id" id="train_group_id" value="#attributes.train_group_id#">
                    <div class="form-group" id="item-process">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57493.Aktif'></label>
                        <div class="col col-8 col-xs-12"> 
                            <input type="checkbox" name="statu" id="statu" value="1" <cfif get_group.statu eq 1>checked</cfif>>
                        </div>
                    </div>
                    <div class="form-group" id="item-process">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='58859.Süreç'></label>
                        <div class="col col-8 col-xs-12"> 
                            <cf_workcube_process is_upd='0' select_value='#get_group.PROCESS_STAGE#' is_detail='1'>
                        </div>
                    </div>
                    <div class="form-group" id="item-group_head">
                        <label class="col col-4 col-xs-12"><cf_get_lang_main no='1408.Başlık'> *</label>
                        <div class="col col-8 col-xs-12">
                        <cfsavecontent variable="message"><cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='1408.başlık'></cfsavecontent>
                        <cfinput type="text" name="group_head" id="group_head" value="#get_group.group_head#" required="yes" message="#message#" style="width:250px;">
                        </div>
                    </div>
                    <div class="form-group" id="item-process">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='46013.Kontenjan'></label>
                        <div class="col col-8 col-xs-12"> 
                            <cfinput type="text" name="quota" id="quota" maxlength="3" value="#get_group.QUOTA#">
                        </div>
                    </div>
                    <div class="form-group col-xs-12" id="item-start_date">
                        <label class="col col-4 col-xs-12"><cf_get_lang no='424.Başlangıç'>*</label>
                        <div class="col col-8 col-xs-12">	
                            <div class="input-group">
                            <cfsavecontent variable="message"><cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no ='641.başlangıç tarihi'></cfsavecontent>
                            <cfinput type="text" required="yes" name="start_date" id="start_date" value="#dateformat(get_group.start_date,dateformat_style)#" message="#message#"  style="width:70px;" validate="#validate_style#" maxlength="10">
                            <span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>
                                <span class="input-group-addon no-bg"></span>
                            <cfsavecontent variable="message1"><cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='288.bitis tarihi'></cfsavecontent>
                            <cfinput type="text" required="yes" name="finish_date" id="finish_date" value="#dateformat(get_group.finish_date,dateformat_style)#" style="width:70px;margin-left:2%;" message="#message1#" validate="#validate_style#" maxlength="10">
                            <span class="input-group-addon"><cf_wrk_date_image date_field="finish_date"></span>
                            </div>
                        </div>
                    </div>                      
                    <div class="form-group" id="item-group_detail">
                        <label class="col col-4 col-xs-12"><cf_get_lang_main no='217.Açıklama'></label>
                            <div class="col col-8 col-xs-12">
                            <textarea name="group_detail" id="group_detail" style="width:250px;height:60px;"><cfoutput>#get_group.group_detail#</cfoutput></textarea>
                            </div>
                    </div>                 
                    <div class="form-group" id="item-employee_id">
                        <label class="col col-4 col-xs-12"><cf_get_lang_main no='132.Sorumlu'></label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <cfif len(get_group.group_emp)>
                                    <cfset attributes.employee_id = get_group.group_emp>
                                    <cfinclude template="../query/get_employee.cfm">
                                    <cfset isim="#get_employee.employee_name# #get_employee.employee_surname#">
                                <cfelse>
                                    <cfset isim="">
                                </cfif>
                                <input type="hidden" name="employee_id" id="employee_id" value="<cfoutput>#get_group.group_emp#</cfoutput>">
                                <input type="text" name="emp_name" id="emp_name" value="<cfoutput>#isim#</cfoutput>" style="width:110px;" readonly>
                                <span class="input-group-addon icon-ellipsis btnPointer" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=upd_group.employee_id&field_name=upd_group.emp_name&select_list=1','list');"></span>
                            </div>
                        </div>
                    </div>
                    
                    <div class="form-group" id="item-branch">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57453.Şube'></label>
                        <div class="col col-8 col-xs-12">
                        <select name="branch_id" id="branch_id" onChange="showDepartment(this.value)">
                            <option value=""><cf_get_lang_main no="322.Seçiniz"></option>
                            <cfoutput query="get_branches" group="NICK_NAME">
                                <optgroup label="#get_branches.NICK_NAME#"></optgroup>
                                <cfoutput>
                                    <option value="#get_branches.BRANCH_ID#" <cfif get_group.BRANCH_ID eq get_branches.BRANCH_ID>selected</cfif>>#get_branches.BRANCH_NAME#</option>
                                </cfoutput>
                            </cfoutput>
                        </select>
                        </div>
                    </div>
                    
                    <div class="form-group" id="item-department">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57572.Departman'></label>
                        <div class="col col-8 col-xs-12" id="department_div">
                        <select name="DEPARTMENT_ID" id="DEPARTMENT_ID"  onChange="showDepartment(this.value)">
                            <option value=""><cf_get_lang_main no="322.Seçiniz"></option>
                            <cfoutput query="get_department">
                                <option value="#get_department.DEPARTMENT_ID#" <cfif get_group.DEPARTMENT_ID eq get_department.DEPARTMENT_ID>selected</cfif>>#get_department.DEPARTMENT_HEAD#</option>
                            </cfoutput>        
                        </select>
                        </div>
                    </div>

                    <div class="form-group" id="item-is_internet">
                        <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
							<label><cf_get_lang no='40.İnternette Gözüksün'></label>
						</div>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<input type="checkbox" name="is_internet" id="is_internet" value="1" onClick="gizle_goster_sites(this)" <cfif get_group.is_internet eq 1>checked</cfif>>
						</div>
                    </div>
                    <div class="form-group" id="more">
                        <input type="hidden" name="more" id="more" value="0">
                        <cfset my_training_group_list = valuelist(get_site_domain.menu_id)>
                    </div>         
                    <div class="form-group" id="is_site_display" style="<cfif get_group.is_internet eq 0>display:none;</cfif>">
                        <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                            <label><cf_get_lang no='104.Extranet/Internet'></label>
                        </div>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <cfoutput query="get_site_menu">
                                <label><input type="checkbox" name="menu_#menu_id#" id="menu_#menu_id#" value="#menu_id#"<cfif len(my_training_group_list) and ListFindNoCase(my_training_group_list,menu_id,',')>checked</cfif>>#site_domain#</label>
                            </cfoutput>
                        </div>
                    </div>
                </div>
            </cf_box_elements>
            <div class="ui-form-list-btn">
                <cf_record_info query_name="get_group">
                <cf_workcube_buttons
                    is_upd='1'
                    data_action = "/V16/training_management/cfc/training_groups:UPDDB" 
                    next_page = "#request.self#?fuseaction=training_management.list_training_groups&event=upd&train_group_id=#attributes.train_group_id#"
                    del_action = '/V16/training_management/cfc/training_groups:DELDB:train_group_id=#attributes.train_group_id#'
                    del_next_page = "#request.self#?fuseaction=training_management.list_training_groups"
                >
            </div>
        </cf_box>
    </cfform>
    <!--- Müfredat --->
    <cf_box
        title="#getLang('','Müfredat',46049)#"
        add_href="#request.self#?fuseaction=training_management.list_training_subjects&event=add"
        info_href="javascript:openBoxDraggable('#request.self#?fuseaction=training_management.popup_list_training_subjects_popup&train_group_id=#attributes.TRAIN_GROUP_ID#')"
        info_href_size="list" 
        id="curriculum"
        closable="0"
        collapsable="1"
        widget_load="listTrainSubjects&train_group_id=#attributes.TRAIN_GROUP_ID#">
    </cf_box>
    <!--- Katılımcılar --->
    <cf_box
        title="#getLang('','Katılımcılar',57590)#"
        print_title="#getLang('','Yazdır',57474)#"
        id="attenders"
        print_href="#request.self#?fuseaction=objects.popup_print_files&action=#attributes.fuseaction#&print_type=128&action_id=#attributes.train_group_id#"
        add_href="javascript:openBoxDraggable('#request.self#?fuseaction=objects.popup_list_positions_multiuser&is_branch_control=1&url_direction=training_management.emptypopup_add_training_group_potential_attenders&train_group_id=#attributes.train_group_id#&url_params=train_group_id&form_submit=1&select_list=1,7,8&draggable=1','','ui-draggable-box-large')"
        box_page="#request.self#?fuseaction=training_management.popup_list_group_joiners&train_group_id=#attributes.train_group_id#&group_head=#get_group.group_head#">
    </cf_box>
</div>
<div class="col col-3 col-xs-12">   
    <!--- Dersler --->
    <cf_box 
        closable="0" 
        title="#getLang('','Dersler',58063)#"
        id="train_group"
        add_href="#request.self#?fuseaction=training_management.list_class&event=add&train_group_id=#attributes.train_group_id#"
        info_href="javascript:windowopen('#request.self#?fuseaction=training_management.popup_list_training_classes&train_group_id=#attributes.train_group_id#','medium')"
        box_page="#request.self#?fuseaction=training_management.train_group_ajax&train_group_id=#attributes.train_group_id#">
    </cf_box>
</div>
<div class="col col-3 col-xs-12">  
    <!--- Images --->
    <cf_wrk_images class_id="#attributes.train_group_id#" type="train_group">
</div>
<script type="text/javascript">
	function gizle_goster_sites(deger)
	{
		if(deger.checked==true)
		document.getElementById('is_site_display').style.display = 'block';
		else
		document.getElementById('is_site_display').style.display = 'none';
	}
</script>