<cf_get_lang_set module_name="settings">
<cf_xml_page_edit fuseact="hr.form_upd_department">
<cfinclude template="../query/get_dep_emp_count.cfm">
<cfquery name="CATEGORY" datasource="#dsn#">
	SELECT 
		DEPARTMENT_ID,
		IS_STORE,
		DEPARTMENT_STATUS,
		IS_ORGANIZATION,
		BRANCH_ID,
		DEPARTMENT_EMAIL,
		#dsn#.Get_Dynamic_Language(DEPARTMENT_ID,'#session.ep.language#','DEPARTMENT','DEPARTMENT_DETAIL',NULL,NULL,DEPARTMENT_DETAIL) AS DEPARTMENT_DETAIL,
		HIERARCHY_DEP_ID,
		ADMIN1_POSITION_CODE,
		ADMIN2_POSITION_CODE,
		IS_PRODUCTION,
		LEVEL_NO,
		HIERARCHY,
		SPECIAL_CODE,
		SPECIAL_CODE2,
		DEPARTMENT_CAT,
		DEPARTMENT_TYPE,
		IN_COMPANY_REASON_ID,
		RECORD_DATE,
		RECORD_IP,
		RECORD_EMP,
		UPDATE_DATE,
		UPDATE_IP,
		UPDATE_EMP,
		#dsn#.Get_Dynamic_Language(DEPARTMENT_ID,'#session.ep.language#','DEPARTMENT','DEPARTMENT_HEAD',NULL,NULL,DEPARTMENT_HEAD) AS DEPARTMENT_HEAD
	FROM 
		DEPARTMENT									
	WHERE 
		DEPARTMENT_ID = <cfqueryparam value="#url.id#" cfsqltype="cf_sql_integer">
</cfquery>
<cfif not (isdefined('category.change_date') and len(category.change_date))>
	<cfquery name="dep_change_date" datasource="#dsn#">
        SELECT 
            MAX(CHANGE_DATE) AS CHANGE_DATE
        FROM 
            DEPARTMENT_HISTORY							
        WHERE 
            DEPARTMENT_ID = #url.id#
    </cfquery>
    <cfif isdefined('dep_change_date.change_date') and len(dep_change_date.change_date)>
		<cfset last_change_date = dateformat(dep_change_date.change_date,dateformat_style)>
   	<cfelse>
    	<cfset last_change_date = ''>
	</cfif>
<cfelse>
	<cfset last_change_date = dateformat(category.change_date,dateformat_style)>
</cfif>
<cfquery name="fire_reasons" datasource="#dsn#"> <!---20191205ERU pozisyon için şirket içi gerekçeler--->
	SELECT REASON_ID,REASON FROM SETUP_EMPLOYEE_FIRE_REASONS WHERE IS_DEPARTMENT = 1 ORDER BY REASON
</cfquery>
<cfquery name="get_dep_cat" datasource="#dsn#">
	SELECT DEPARTMENT_CAT,DEPARTMENT_CAT_ID FROM SETUP_DEPARTMENT_CAT
</cfquery>
<cfquery name="get_dep_type" datasource="#dsn#">
	SELECT DEPARTMENT_TYPE,DEPARTMENT_TYPE_ID FROM SETUP_DEPARTMENT_TYPE
</cfquery>
<cfif not(isdefined("attributes.isAjax") and len(attributes.isAjax))>
	<cf_catalystHeader>
</cfif>
<cf_box>
	<cfform action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_department_upd" method="post" name="departman">
		<input type="hidden" name="department_id" id="department_id" value="<cfoutput>#attributes.id#</cfoutput>">
		<input type="hidden" name="head" id="head" value="<cfoutput>#category.department_Head#</cfoutput>">
		<input type="hidden" name="id" id="id" value="<cfoutput>#attributes.id#</cfoutput>">
		<input type="hidden" name="x_change_date" id="x_change_date" value="<cfoutput>#x_change_date#</cfoutput>">
		<input type="hidden" name="x_show_process" id="x_show_process" value="<cfoutput>#x_show_process#</cfoutput>">
		<cfif isdefined("attributes.isAjax") and len(attributes.isAjax)>
			<cfoutput>
				<input type="hidden" name="callAjaxBranch" id="callAjaxBranch" value="1">  
				<input type="hidden" name="comp_id" id="callAjaxBranch" value="#attributes.comp_id#">  		
				<input type="hidden" name="branch_id" id="branch_id" value="#attributes.branch_id#"> 
			</cfoutput>
		</cfif>
		<!--- <cfif isDefined("attributes.isAjax") and attributes.isAjax eq 1><!--- Organizasyon Yönetimi sayfasından Ajax ile yüklendiyse --->
			<cf_box title="#title#" closable="0">
		</cfif> --->
		<cf_box_elements>
			<div class="col col-6 col-md-6 col-sm-12 col-xs-12" type="column" index="1" sort="true">
				<div class="form-group" id="item-department_status">
					<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57756.durum'></label>
					<div class="col col-9 col-xs-12"> 
						<label><input type="Checkbox" name="department_status" id="department_status" <cfif len(trim(category.department_status)) and category.department_status>checked</cfif> value="1"><cf_get_lang dictionary_id='57493.Aktif'></label>
						<label><input type="Checkbox" name="is_organization" id="is_organization" <cfif len(trim(category.is_organization)) and category.is_organization>checked</cfif> value="1"><cf_get_lang dictionary_id='42936.Org Şemada Göster'></label>
					</div>
				</div>
				<cfif x_show_process eq 1>
					<div class="form-group" id="item-expense_stage">
						<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='58859.Süreç'> *</label>
						<div class="col col-9 col-xs-12">
							<cf_workcube_process is_upd='0' is_detail='1' select_value='#CATEGORY.DEPT_STAGE#' >
						</div>
					</div>
				</cfif>
				<div class="form-group" id="item-is_store">
					<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57630.Tip'></label>
					<div class="col col-9 col-xs-12"> 
						<select name="is_store" id="is_store" style="width:250px;">
							<option value="2" <cfif category.is_store eq 2>selected</cfif>><cf_get_lang dictionary_id='57572.Departman'></option>
							<option value="1" <cfif category.is_store eq 1>selected</cfif>><cf_get_lang dictionary_id='58763.Depo'></option>
							<option value="3" <cfif category.is_store eq 3>selected</cfif>><cf_get_lang dictionary_id='58763.Depo'> <cf_get_lang dictionary_id='57989.ve'> <cf_get_lang dictionary_id='57572.Departman'></option>
						</select>
						<input type="hidden" name="old_is_store" id="old_is_store" value="<cfoutput>#category.is_store#</cfoutput>">
					</div>
				</div>
				<div class="form-group" id="item-depatment_cat">
					<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='64604.Departman Kategorisi'></label>
					<div class="col col-9 col-xs-12"> 
						<select name="depatment_cat" id="depatment_cat">
							<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
								<cfoutput query="get_dep_cat">
									<option value="#DEPARTMENT_CAT_ID#" <cfif category.DEPARTMENT_CAT eq DEPARTMENT_CAT_ID>selected</cfif>>#DEPARTMENT_CAT#</option>
								</cfoutput>
						</select>
					</div>
				</div>
				<div class="form-group" id="item-depatment_type">
					<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='64601.Departman Türü'></label>
					<div class="col col-9 col-xs-12"> 
						<select name="depatment_type" id="depatment_type">
							<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
								<cfoutput query="get_dep_type">
									<option value="#DEPARTMENT_TYPE_ID#" <cfif category.DEPARTMENT_TYPE eq DEPARTMENT_TYPE_ID>selected</cfif>>#DEPARTMENT_TYPE#</option>
								</cfoutput>
						</select>
					</div>
				</div>
				<div class="form-group" id="item-total_emp_count">
					<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='42613.Çalışan Sayısı'></label>
					<div class="col col-9 col-xs-12"> 
						<input type="Text" name="total_emp_count" id="total_emp_count" value="<cfoutput>#get_dep_emp_count.total#</cfoutput>" style="width:250px;" readonly>
					</div>
				</div>
				<div class="form-group" id="item-department_head">
					<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='42424.Department Name'>*</label>
					<div class="col col-9 col-xs-12"> 
						<div class="input-group">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='58059.Başlık girmelisiniz'></cfsavecontent>
							<!---SG Kaldırdı silinebilir departman adları kapatıldı 20121006 <input type="hidden" name="department_name_id" id="department_name_id" value="<cfoutput>#category.department_name_id#</cfoutput>"> --->
							<cfinput type="Text" name="department_head" id="department_head" size="60" value="#category.department_Head#" maxlength="100" required="Yes" message="#message#" style="width:250px;">
							<!---<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_department_name&field_name=departman.department_head&field_id=departman.department_name_id','list');return false;"><img src="/images/plus_thin.gif" align="absbottom" ></a> --->
							<input type="hidden" name="old_department_head" id="old_department_head" value="<cfoutput>#category.department_Head#</cfoutput>">
							<span class="input-group-addon">
								<cf_language_info 
								table_name="DEPARTMENT" 
								column_name="DEPARTMENT_HEAD" 
								column_id_value="#url.id#" 
								maxlength="500" 
								datasource="#dsn#" 
								column_id="DEPARTMENT_ID" 
								control_type="0">
							</span>	
						</div>
					</div>
				</div>
				<div class="form-group" id="item-email">
					<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id="57428.Email"></label>
					<div class="col col-9 col-xs-12"> 
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='58484.Lütfen geçerli bir e-mail adresi giriniz'></cfsavecontent>
						<cfinput type="text" validate="email" name="email" style="width:250px;" value="#category.department_email#" message="#message#">
						<input type="hidden" name="old_email" id="old_email" value="<cfoutput>#category.department_email#</cfoutput>">
					</div>
				</div>
				<div class="form-group" id="item-department_Detail">
					<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='42009.Ayrıntı'></label>
					<div class="col col-9 col-xs-12"> 
						<div class="input-group">
							<textarea name="department_Detail" id="department_Detail" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" maxlength="100" message="100 Karakterden Fazla Yazmayınız" style="width:250px;height:50px;"><cfoutput>#category.department_detail#</cfoutput></textarea>
							<input type="hidden" name="old_department_detail" id="old_department_detail" value="<cfoutput>#category.department_detail#</cfoutput>">
							<span class="input-group-addon">
								<cf_language_info 
								table_name="DEPARTMENT" 
								column_name="DEPARTMENT_DETAIL" 
								column_id_value="#url.id#" 
								maxlength="500" 
								datasource="#dsn#" 
								column_id="DEPARTMENT_ID" 
								control_type="0">
							</span>	
						</div>
					</div>
				</div>
				<div class="form-group" id="item-branch_name">
					<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57453.Şube'>*</label>
					<div class="col col-9 col-xs-12"> 
						<cfquery name="BRANCHES" datasource="#dsn#">
							SELECT BRANCH_ID, BRANCH_NAME, BRANCH_STATUS FROM BRANCH WHERE BRANCH_ID = #category.branch_ID#
						</cfquery>
						<cfoutput>#branches.branch_name#</cfoutput>
						<input type="hidden" value="<cfoutput>#branches.branch_id#</cfoutput>" id="branch_id">
					</div>
				</div>
				<div class="form-group" id="item-up_department">
					<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='42335.Üst Departman'></label>
					<div class="col col-9 col-xs-12"> 
						<div class="input-group">
							<input type="hidden" name="oldhierarchy" id="oldhierarchy" value="<cfoutput>#category.hierarchy_dep_id#</cfoutput>">
							<cfif listlen(CATEGORY.HIERARCHY_DEP_ID,'.') gt 1>
								<cfset up_dep=ListGetAt(CATEGORY.HIERARCHY_DEP_ID,evaluate("#listlen(CATEGORY.HIERARCHY_DEP_ID,".")#-1"),".") >	
								<cfquery name="DEPARTMANS" datasource="#dsn#">
									SELECT 
										DEPARTMENT_HEAD 
									FROM
										DEPARTMENT
									WHERE 
										DEPARTMENT_ID = #up_dep#
								</cfquery>
								<cfset up_dep_name="#DEPARTMANS.DEPARTMENT_HEAD#">
							<cfelse>
								<cfset up_dep="">
								<cfset up_dep_name="">	
							</cfif>
							<input type="hidden" name="old_up_department_id" id="old_up_department_id" value="<cfoutput>#up_dep#</cfoutput>">
							<input type="hidden" name="up_department_id" id="up_department_id" value="<cfoutput>#up_dep#</cfoutput>">
							<input type="text" name="up_department" id="up_department" value="<cfoutput>#up_dep_name#</cfoutput>" style="width:250px;">
							<span class="input-group-addon icon-ellipsis btnPointer" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_departments&field_id=departman.up_department_id&field_name=departman.up_department&is_all_departments</cfoutput>','','ui-draggable-box-small');"></span>
						</div>
					</div>
				</div>
				<div class="form-group" id="item-admin1_position">
					<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='29511.Yönetici'> 1</label>
					<div class="col col-9 col-xs-12"> 
						<div class="input-group">
							<input type="Hidden" name="admin1_position_code" id="admin1_position_code" value="<cfoutput>#category.admin1_position_code#</cfoutput>">
							<cfif len(category.admin1_position_code)>
								<cfset attributes.employee_id = "">
								<cfset attributes.position_code = category.admin1_position_code>
								<cfinclude template="../query/get_position.cfm">
								<input type="text" name="admin1_position" id="admin1_position" style="width:250px;"  value="<cfoutput>#get_position.employee_name# #get_position.employee_surname#</cfoutput>">
							<cfelse>
								<input type="text" name="admin1_position" id="admin1_position" style="width:250px;"  value="" readonly>
							</cfif>
							<span class="input-group-addon icon-ellipsis btnPointer" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_code=departman.admin1_position_code&field_name=departman.admin1_position');return false;"></span>
						</div>
					</div>
				</div>
				<div class="form-group" id="item-admin2_position">
					<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='29511.Yönetici'> 2</label>
					<div class="col col-9 col-xs-12"> 
						<div class="input-group">
							<input type="Hidden" name="admin2_position_code" id="admin2_position_code" value="<cfoutput>#category.admin2_position_code#</cfoutput>">
							<cfif len(category.admin2_position_code)>
								<cfset attributes.employee_id = "">
								<cfset attributes.position_code = category.admin2_position_code>
								<cfinclude template="../query/get_position.cfm">
								<input type="text" name="admin2_position" id="admin2_position" style="width:250px;"  value="<cfoutput>#get_position.employee_name# #get_position.employee_surname#</cfoutput>">
							<cfelse>
								<input type="text" name="admin2_position" id="admin2_position" style="width:250px;"  value="" readonly>
							</cfif>
							<span class="input-group-addon icon-ellipsis btnPointer" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_code=departman.admin2_position_code&field_name=departman.admin2_position');return false;"></span>
						</div>
					</div>
				</div>
				<div class="form-group" id="item-level_no">
					<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='43091.Kademe Numarası'></label>
					<div class="col col-9 col-xs-12"> 
						<cfinput type="text" name="level_no" value="#category.level_no#" onkeyup="return(FormatCurrency(this,event));" required="no" validate="integer" style="width:250px;">
						<input type="hidden" name="old_level_no" id="old_level_no" value="<cfoutput>#category.level_no#</cfoutput>">
					</div>
				</div>
				<div class="form-group" id="item-hierarchy">
					<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57761.Hiyerarşi'></label>
					<div class="col col-9 col-xs-12"> 
						<input type="text" name="hierarchy" id="hierarchy" style="width:155px;"  maxlength="75" value="<cfoutput>#category.HIERARCHY#</cfoutput>">
						<input type="hidden" name="old_hierarchy" id="old_hierarchy" value="<cfoutput>#category.HIERARCHY#</cfoutput>">
					</div>
				</div>
				<div class="form-group" id="item-hierarchy">
					<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57789.Özel Kod'></label>
					<div class="col col-9 col-xs-12"> 
						<input type="text" name="special_code" id="special_code" style="width:155px;"  maxlength="75" value="<cfoutput>#category.special_code#</cfoutput>">
					</div>
				</div>
				<div class="form-group" id="item-special_code_2">
					<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='30338.Özel Kod 2'></label>
					<div class="col col-9 col-xs-12"> 
						<cfinput type="text" name="special_code_2" id="special_code_2"  maxlength="75" value="#category.special_code2#">
					</div>
				</div>
				<cfif isdefined("x_in_company_reason_id") and x_in_company_reason_id eq 1>
					<div class="form-group" id="item-reason_id">
						<label class="col col-3"><cf_get_lang dictionary_id='55550.Gerekçe'></label>
						<div class="col col-9">
							<select name="reason_id" id="reason_id">
								<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
								<cfoutput query="fire_reasons">
									<option value="#reason_id#"  <cfif category.in_company_reason_id eq reason_id>selected</cfif>>#reason#</option>
								</cfoutput>
							</select>
						</div>                
					</div>
				</cfif>
				<div class="form-group" id="item-is_production">
					<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='42058.Üretim Yapılıyor'></label>
					<div class="col col-9 col-xs-12"> 
						<input type="Checkbox" name="is_production" id="is_production" <cfif category.is_production eq 1>checked</cfif> value="1">
					</div>
				</div>
				<cfif x_change_date eq 1>
					<div class="form-group" id="item-change_date">
						<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='40448.Değişiklik Tarihi'></label>
						<div class="col col-9 col-xs-12">
							<div class="input-group">
								<cfinput type="text" name="change_date" value="#dateFormat(category.change_date,dateformat_style)#" validate="#validate_style#" style="width:155px;">                                        
								<input type="hidden" name="last_change_date" id="last_change_date" value="<cfoutput>#last_change_date#</cfoutput>" />
								<span class="input-group-addon"><cf_wrk_date_image date_field="change_date"></span>
							</div>
						</div>
					</div>
				</cfif>
			</div>
		</cf_box_elements>	
		<cf_box_footer>
			<div class="col col-6"><cf_record_info query_name="category"></div>
			<div class="col col-6">
				<cfif GET_DEPARTMENT_KONTROL.recordcount or GET_DEPARTMENT_KONTROL2.recordcount or GET_DEPARTMENT_KONTROL3.recordcount>
					<cf_workcube_buttons type_format="1" is_upd='1' is_delete='0' add_function="kontrol_et()">
				<cfelse>
					<cf_workcube_buttons type_format="1" is_upd='1' delete_page_url='#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_department_del&department_id=#attributes.id#&head=#category.department_Head#' add_function="kontrol_et()">
				</cfif>
			</div>
		</cf_box_footer>
	</cfform>
</cf_box>
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
		if (document.getElementById('department_id').value == document.getElementById('up_department_id').value && document.getElementById('up_department').value != '')
		{
			alert("<cf_get_lang dictionary_id='62563.Departmanın üst departmanı kendisi olamaz!'>");
			return false;
		}
		if (document.getElementById('x_change_date').value == 1 && (document.getElementById('old_is_store').value != document.getElementById('is_store').value || document.getElementById('old_email').value != document.getElementById('email').value || document.getElementById('old_department_detail').value != document.getElementById('department_Detail').value || document.getElementById('old_level_no').value != document.getElementById('level_no').value
			|| document.getElementById('old_up_department_id').value != document.getElementById('up_department_id').value || document.getElementById('old_department_head').value != document.getElementById('department_head').value || document.getElementById('old_hierarchy').value != document.getElementById('hierarchy').value))
		{
			if(document.getElementById('change_date').value == "")
			{
				alert("<cf_get_lang dictionary_id='62564.Departman bilgilerinde değişiklik yaptınız. Lütfen Değişiklik tarihini giriniz'>");
				return false;
			}
		}
		<cfif isdefined("x_in_company_reason_id") and x_in_company_reason_id eq 1>
			if(document.getElementById('reason_id').value == "")
			{
				alert("<cf_get_lang dictionary_id = '56041.Gerekçe seçiniz'>");
				return false;
			}
		</cfif>
		return true;
	}
</script>
<cf_get_lang_set module_name="#fusebox.circuit#">
