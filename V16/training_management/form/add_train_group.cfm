<cfset groups = createObject("component","V16.training_management.cfc.training_groups")>
<!--- <cfset GET_SITE_MENU = groups.SELECTSITE_MENU()/> --->
<cfset cmp = createObject("component","V16.training_management.cfc.training_management")>
<cfset get_site_menu = cmp.GET_COMPANY_F()>
<cfset cmp_branch = createObject("component","V16.hr.cfc.get_branch_comp")>
<cfset cmp_branch.dsn = dsn>
<cfset get_branches = cmp_branch.get_branch(branch_status:1,comp_id : session.ep.company_id)>
<cfset cmp_department = createObject("component","V16.hr.cfc.get_departments")>
<cfset cmp_department.dsn = dsn>
<cfset get_department = cmp_department.get_department()>

<cf_catalystHeader> 
<cfform  name="add_group" method="post" action="#request.self#?fuseaction=training_management.emptypopup_add_train_group">
	<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
		<cf_box>
			<cf_box_elements>
				<div class="col col-5 col-md-5 col-sm-5 col-xs-12" type="column" index="1" sort="true">
					<input type="hidden" name="link_type" id="link_type" value="<cfif isdefined("attributes.link_type") and attributes.link_type eq 1><cfoutput>#attributes.link_type#</cfoutput></cfif>">
					<div class="form-group" id="item-process">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='58859.Süreç'></label>
						<div class="col col-8 col-xs-12"> 
							<cf_workcube_process is_upd='0' is_detail='0'>
						</div>
					</div>
					<div class="form-group" id="item-group_head">
						<label class="col col-4 col-xs-12"><cf_get_lang_main no='1408.Başlık'> *</label>
						<div class="col col-8 col-xs-12"><cfsavecontent variable="message"><cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='1408.Başlık'> *</cfsavecontent>
							<cfinput type="text" name="group_head" id="group_head" required="yes" message="#message#" style="width:250px;">
						</div>
					</div>
					<div class="form-group" id="item-process">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='46013.Kontenjan'></label>
						<div class="col col-8 col-xs-12"> 
							<cfinput type="text" name="quota" id="quota" maxlength="3">
						</div>
					</div>
					<div class="form-group col-xs-12" id="item-start_date">
						<label class="col col-4 col-md-6 col-sm-6 col-xs-12"><cf_get_lang no='424.Başlangıç - Bitiş'>*</label>
						<div class="col col-8 col-md-6 col-sm-6 col-xs-12">
							<div class="input-group">
								<cfsavecontent variable="message"><cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no ='641.başlangıç tarihi'></cfsavecontent>
								<cfinput type="text" name="start_date" id="start_date" validate="#validate_style#" message="#message#" style="width:70px;" maxlength="10" required="yes">
								<span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>
									<span class="input-group-addon no-bg"></span>
								<cfsavecontent variable="message"><cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='288.bitis tarihi'></cfsavecontent>
								<cfinput type="text" name="finish_date" id="finish_date" style="width:70px;" message="#message#" validate="#validate_style#" maxlength="10" required="yes">
								<span class="input-group-addon"><cf_wrk_date_image date_field="finish_date"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-group_detail">
						<label class="col col-4 col-xs-12"><cf_get_lang_main no='217.Açıklama'></label>
						<div class="col col-8 col-xs-12">
							<textarea name="group_detail" id="group_detail" style="width:250px;height:60px;"></textarea>
						</div>
					</div>
					<div class="form-group" id="item-employee_id">
						<label class="col col-4 col-xs-12"><cf_get_lang_main no='132.Sorumlu'>*</label>
						<div class="col col-8 col-xs-12">
							<div class="input-group">
								<input type="hidden" name="employee_id" id="employee_id"  value="">
								<input type="text" name="emp_name" id="emp_name" value="" style="width:110px;" readonly>
								<span class="input-group-addon icon-ellipsis btnPointer" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=add_group.employee_id&field_name=add_group.emp_name&select_list=1','list','popup_list_positions');"></span> 
							</div>
						</div>
					</div>

					<div class="form-group" id="item-branch">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57453.Şube'></label>
                        <div class="col col-8 col-xs-12">
                        <select name="branch_id" id="branch_id" onChange="showDepartment(this.value)" >
                            <cfoutput query="get_branches" group="NICK_NAME">
                            <optgroup label="#get_branches.NICK_NAME#"></optgroup>
                            <cfoutput>
                                <option value="#get_branches.BRANCH_ID#">#get_branches.BRANCH_NAME#</option>
                            </cfoutput>
                            </cfoutput>
                        </select>
                        </div>
                    </div>
                    
                    <div class="form-group" id="item-department">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57572.Departman'></label>
                        <div class="col col-8 col-xs-12" id="department_div">
                        <select name="DEPARTMENT_ID" id="DEPARTMENT_ID"  onChange="showDepartment(this.value)">
                            <cfoutput query="get_department">
                                <option value="#get_department.DEPARTMENT_ID#" >#get_department.DEPARTMENT_HEAD#</option>
                            </cfoutput>        
                        </select>
                        </div>
                    </div>

					<div class="form-group" id="item-is_internet">
						<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
							<label><cf_get_lang no='40.İnternette Gözüksün'></label>
						</div>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<input type="checkbox" name="is_internet" id="is_internet" value="1" onClick="gizle_goster(is_site_class)">
						</div>
					</div>
					
					<div class="form-group" id="item-more">
						<div style="text-align:right;"> 
							<input type="Hidden" name="more" id="more" value="0">
						</div>
					</div>
					<div class="form-group" id="is_site_class" style="display:none;">
						<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
							<label><cf_get_lang no='24.Yayınlanacak Site'></label>
						</div>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<cfoutput query="get_site_menu">
								<label><input type="checkbox" name="menu_#menu_id#" id="menu_#menu_id#" value="#menu_id#">#site_domain#</label>
							</cfoutput>
						</div>
					</div>
				</div>
			</cf_box_elements>
			<div class="ui-form-list-btn">
				<cf_workcube_buttons type_format='1' is_upd='0' add_function="kontrol()">
			</div>
		</cf_box>
	</div>
</cfform>


<script type="text/javascript">
	function kontrol()
   	{
        if (!document.getElementById('employee_id').value.length){
            alert("Sorumlu alanı boş olamaz");
            return false;
        }
		if(document.getElementById('start_date').value != '' && document.getElementById('finish_date').value != '' )
		{
			return date_check(add_group.start_date,add_group.finish_date,"<cf_get_lang_main no='1450.Başlangıç Tarihi Bitiş Tarihinden Büyük Olamaz'> !");
		}
	}
	function showDepartment(branch_id)	{
		var branch_id = document.getElementById('branch_id').value;
		if (branch_id != "")
		{
			var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_ajax_list_hr&show_div=0&branch_id="+branch_id;
			AjaxPageLoad(send_address,'department_div',1,'İlişkili Departmanlar');
		}
    } 
</script>
