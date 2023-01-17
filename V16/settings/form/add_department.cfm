<cf_xml_page_edit fuseact="hr.form_upd_department">
<cf_get_lang_set module_name="settings">
<cfquery name="BRANCHES" datasource="#dsn#">
	SELECT 
		BRANCH.BRANCH_ID, 
		BRANCH.BRANCH_NAME,
		BRANCH.BRANCH_STATUS,
		BRANCH.COMPANY_ID,
		OUR_COMPANY.COMP_ID,
		OUR_COMPANY.NICK_NAME
	FROM 
		BRANCH
		INNER JOIN OUR_COMPANY ON BRANCH.COMPANY_ID = OUR_COMPANY.COMP_ID
	<cfif fusebox.circuit eq 'hr' and not get_module_power_user(67)>
	WHERE
	    BRANCH.BRANCH_ID IS NOT NULL
		AND BRANCH.BRANCH_ID IN(SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#)
	</cfif> 
	ORDER BY
		OUR_COMPANY.NICK_NAME,
		BRANCH.BRANCH_NAME
</cfquery>
<cfquery name="get_dep_cat" datasource="#dsn#">
	SELECT DEPARTMENT_CAT,DEPARTMENT_CAT_ID FROM SETUP_DEPARTMENT_CAT
</cfquery>
<cfquery name="get_dep_type" datasource="#dsn#">
	SELECT DEPARTMENT_TYPE,DEPARTMENT_TYPE_ID FROM SETUP_DEPARTMENT_TYPE
</cfquery>
<cfif not (isdefined("attributes.isAjax") and attributes.isAjax eq 1)><!--- Organizasyon Yönetimi sayfasından Ajax ile yüklendiyse --->
	<cf_catalystHeader>
</cfif>
<cfform action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_department_add" method="post" name="departman">
	<cfif isdefined("attributes.isAjax") and attributes.isAjax eq 1>
		<input type="hidden" name="callAjaxBranch" id="callAjaxBranch" value="1"><!--- Organizasyon Yönetimi sayfasıdan ajax ile çağırıldıysa 20190912ERU --->		
		<input type="hidden" name="comp_id" id="comp_id" value="<cfoutput>#attributes.comp_id#</cfoutput>">	
		<input type="hidden" name="branch" id="branch" value="<cfoutput>#attributes.branch#</cfoutput>">	
	</cfif>
	<input type="hidden" name="x_show_process" id="x_show_process" value="<cfoutput>#x_show_process#</cfoutput>">
	<!--- <cfif isDefined("attributes.isAjax") and attributes.isAjax eq 1>
		<cfsavecontent variable="title"><cf_get_lang dictionary_id = "53549.Departmanlar"> : <cf_get_lang dictionary_id = "45697.Yeni Kayıt"></cfsavecontent>
		<cf_box title="#title#" closable="0">
	</cfif>	 --->
	<cf_box>
		<cf_box_elements>
			<div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
				<div class="form-group" id="item-department_status">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57756.durum'></label>
					<div class="col col-8 col-xs-12"> 
						<label><input type="Checkbox" name="department_status" id="department_status" value="1" checked><cf_get_lang dictionary_id='57493.Aktif'></label>
						<label><input type="Checkbox" name="is_organization" id="is_organization" value="1" checked><cf_get_lang dictionary_id='42936.Org Şemada Göster'></label>
					</div>
				</div>
				<cfif x_show_process eq 1>
					<div class="form-group" id="item-dept_stage">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58859.Süreç'> *</label>
						<div class="col col-8 col-xs-12">
							<cf_workcube_process is_upd='0' process_cat_width='120' is_detail='0'>
						</div>
					</div>
				</cfif>
				<div class="form-group" id="item-is_store">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57630.Tip'></label>
					<div class="col col-8 col-xs-12"> 
						<select name="is_store" id="is_store">
							<option value="2"><cf_get_lang dictionary_id='57572.Departman'></option>
							<option value="1"><cf_get_lang dictionary_id='58763.Depo'></option>
							<option value="3"><cf_get_lang dictionary_id='58763.Depo'> <cf_get_lang dictionary_id='57989.ve'> <cf_get_lang dictionary_id='57572.Departman'></option>
						</select>
					</div>
				</div>
				<div class="form-group" id="item-depatment_cat">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='64604.Departman Kategorisi'></label>
					<div class="col col-8 col-xs-12"> 
						<select name="depatment_cat" id="depatment_cat">
							<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
								<cfoutput query="get_dep_cat">
									<option value="#DEPARTMENT_CAT_ID#">#DEPARTMENT_CAT#</option>
								</cfoutput>
						</select>
					</div>
				</div>
				<div class="form-group" id="item-depatment_type">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='64601.Departman Türü'></label>
					<div class="col col-8 col-xs-12"> 
						<select name="depatment_type" id="depatment_type">
							<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
								<cfoutput query="get_dep_type">
									<option value="#DEPARTMENT_TYPE_ID#">#DEPARTMENT_TYPE#</option>
								</cfoutput>
						</select>
					</div>
				</div>
				<div class="form-group" id="item-department_Head">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='42424.Department Name'>*</label>
					<div class="col col-8 col-xs-12"> 
						<cfsavecontent variable="message"><cfoutput>#getLang('cubetv',164)#</cfoutput></cfsavecontent>
						<!---<input type="hidden" name="department_name_id" id="department_name_id" value="">--->
						<cfinput type="Text" name="department_Head" id="department_Head"  value="" maxlength="100" required="Yes" message="#message#">
						<!--- <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_department_name&field_name=departman.department_Head&field_id=departman.department_name_id','list');return false;"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a> --->
					</div>
				</div>
				<div class="form-group" id="item-email">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="57428.Email"></label>
					<div class="col col-8 col-xs-12"> 
						<cfinput type="text" validate="email" name="email">
					</div>
				</div>
				<div class="form-group" id="item-department_Detail">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='42009.Ayrıntı'></label>
					<div class="col col-8 col-xs-12"> 
						<Textarea name="department_Detail" id="department_Detail" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" maxlength="100" message="100 Karakterden Fazla Yazmayınız" cols="60" rows="2" style="width:250px;height:50px;"></TEXTAREA>
					</div>
				</div>
				<div class="form-group" id="item-branch_name">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57453.Şube'>*</label>
					<div class="col col-8 col-xs-12"> 
						<select name="branch_id" id="branch_id">
							<option value=""><cf_get_lang dictionary_id='57734.Şube Seçiniz'></option>
							<cfoutput query="branches" group="NICK_NAME">
								<optgroup label="#NICK_NAME#"></optgroup>
								<cfoutput>
									<option value="#branch_ID#" <cfif isDefined("attributes.branch_id") and attributes.branch_id eq branch_ID>selected</cfif>>#branch_name# <cfif not branches.BRANCH_STATUS>(Pasif)</cfif></option>
								</cfoutput>
							</cfoutput>
						</select>
					</div>
				</div>
				<div class="form-group" id="item-up_department">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='42335.Üst Departman'></label>
					<div class="col col-8 col-xs-12"> 
						<div class="input-group">
							<input type="hidden" name="up_department_id" id="up_department_id" value="">
							<input type="text" name="up_department" id="up_department" value="">
							<span class="input-group-addon icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_departments&field_id=departman.up_department_id&field_name=departman.up_department&is_all_departments</cfoutput>','','ui-draggable-box-small');"></span>
						</div>
					</div>
				</div>
				<div class="form-group" id="item-admin1_position">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='29511.Yönetici'> 1</label>
					<div class="col col-8 col-xs-12"> 
						<div class="input-group">
							<input type="Hidden" name="admin1_position_code" id="admin1_position_code" value="">
							<input type="text" name="admin1_position" id="admin1_position" value="" readonly="">
							<span class="input-group-addon icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_code=departman.admin1_position_code&field_name=departman.admin1_position');return false;"></span>
						</div>
					</div>
				</div>
				<div class="form-group" id="item-admin2_position">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='29511.Yönetici'> 2</label>
					<div class="col col-8 col-xs-12"> 
						<div class="input-group">
							<input type="Hidden" name="admin2_position_code" id="admin2_position_code" value="">
							<input type="text" name="admin2_position" id="admin2_position" value="" readonly="">
							<span class="input-group-addon icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_code=departman.admin2_position_code&field_name=departman.admin2_position');return false;"></span>
						</div>
					</div>
				</div>
				<div class="form-group" id="item-level_no">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='43091.Kademe Numarası'></label>
					<div class="col col-8 col-xs-12"> 
						<cfinput type="text" name="level_no" value="" onkeyup="return(FormatCurrency(this,event));" required="no" validate="integer" >
					</div>
				</div>
				<div class="form-group" id="item-hierarchy">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57761.Hiyerarşi'></label>
					<div class="col col-8 col-xs-12"> 
						<input type="text" name="hierarchy" id="hierarchy" maxlength="75" value="">
					</div>
				</div>
				<div class="form-group" id="item-special_code">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57789.Özel Kod'></label>
					<div class="col col-8 col-xs-12"> 
						<input type="text" name="special_code" id="special_code"  maxlength="75" value="">
					</div>
				</div>
				<div class="form-group" id="item-special_code_2">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='30338.Özel Kod 2'></label>
					<div class="col col-8 col-xs-12"> 
						<input type="text" name="special_code_2" id="special_code_2"  maxlength="75" value="">
					</div>
				</div>
				<div class="form-group" id="item-is_production">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='42058.Üretim Yapılıyor'></label>
					<div class="col col-8 col-xs-12"> 
						<input type="Checkbox" name="is_production" id="is_production" value="1" >
					</div>
				</div>
			</div>
		</cf_box_elements>	
		<cf_box_footer>
			<cf_workcube_buttons type_format="1" is_upd='0' add_function="kontrol_et()"> 
		</cf_box_footer>
	</cf_box>
				
</cfform>
<script type="text/javascript">
	function kontrol_et()
	{
		a = document.getElementById('branch_id').value;
		if(a=="")
		{
			alert("<cf_get_lang dictionary_id='42986.Şube Seçmelisiniz'>!");
			return false;
		}
		else
			{
				var is_production_branch = wrk_safe_query("set_is_production_branch","dsn",0,a);
				if(is_production_branch.IS_PRODUCTION == 0 && document.getElementById('is_production').checked == true)
					{
						alert(is_production_branch.BRANCH_NAME + " Şubesinde Üretim Yapılmazken Bağlı Departmanında Üretim Yapılamaz.");
						return false;
					}
			}
		return true;
	}
</script>
<cf_get_lang_set module_name="#fusebox.circuit#">
