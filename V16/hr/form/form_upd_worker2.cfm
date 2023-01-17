<cf_get_lang_set module_name="hr"><!--- sayfanin en altinda kapanisi var --->
<cfset upper_name = ''>
<cfquery name="CATEGORY" datasource="#dsn#">
	SELECT 
		WG.HIERARCHY AS WORKGROUP_HIERARCHY,
		WG.WORKGROUP_NAME,
		WEP.*
	FROM 
		WORK_GROUP WG,
		WORKGROUP_EMP_PAR WEP 
	WHERE 
		WG.WORKGROUP_ID=WEP.WORKGROUP_ID AND 
		WEP.WRK_ROW_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.WRK_ROW_ID#">
</cfquery>
<cfquery name="CATEGORY_ALTS" dbtype="query">
	select 
		*
	from
		CATEGORY
		where
		HIERARCHY LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#REReplace(CATEGORY.HIERARCHY,"[^0-9A-Za-z ]","","all")#.%">
</cfquery>

<cfset upper_hierarchy = '#CATEGORY.WORKGROUP_HIERARCHY#'>

<cfif len(CATEGORY.UPPER_ROW_ID)>
	<cfquery name="upper_rol" datasource="#dsn#">
		SELECT * FROM WORKGROUP_EMP_PAR WHERE WRK_ROW_ID = #CATEGORY.upper_row_id#
	</cfquery>
	<cfset upper_hierarchy = upper_rol.hierarchy>
	<cfif len(upper_rol.employee_id)>
		<cfset upper_name = upper_rol.ROLE_HEAD & ' ' & get_emp_info(upper_rol.employee_id,0,0)>
	<cfelseif len(upper_rol.partner_id)>
		<cfset upper_name = upper_rol.ROLE_HEAD & ' ' & get_par_info(upper_rol.partner_id,1,1,0)>
	<cfelse>
		<cfset upper_name = upper_rol.ROLE_HEAD>
	</cfif>
</cfif>
<cfset aa=len(category.hierarchy)-len(upper_hierarchy)>
<cfif aa lt 0>
	<cfset aa=0>
</cfif>

<cfparam name="attributes.modal_id" default="">

<cfset my_hierarchy = mid(category.hierarchy,len(upper_hierarchy)+2,aa)>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box title="#iif(isDefined("attributes.draggable"),"getLang('','Grup Çalışanı Güncelle',64583)",DE(''))#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),DE(1),DE(0))#">
	<cfform action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_worker_upd2" method="post" name="worker">
			<input type="hidden" name="WRK_ROW_ID" id="WRK_ROW_ID" value="<cfoutput>#attributes.WRK_ROW_ID#</cfoutput>">
			<input type="hidden" name="pageDelEvent" id="pageDelEvent" value="delWorker">
			<cf_box_elements>
				<div class="col col-12 col-md-12 col-sm-12 col-xs-12" type="column" index="1" sort="true">
					<div class="form-group col col-2 col-md-1 col-sm-6 col-xs-12" id="item-is_real">
						<label class="col col-12 col-md-12 col-sm-12 col-xs-12"><input type="checkbox" name="is_real" id="is_real" value="1" <cfif len(category.IS_REAL) and category.IS_REAL eq 1>checked</cfif>><cf_get_lang dictionary_id ='56388.Asıl/Vekil'></label>
					</div>
					<div class="form-group col col-2 col-md-2 col-sm-6 col-xs-12" id="item-is_critical">
						<label class="col col-12 col-md-12 col-sm-12 col-xs-12"><input type="checkbox" name="is_critical" id="is_critical" value="1" <cfif category.IS_CRITICAL eq 1>checked</cfif>><cf_get_lang dictionary_id ='55992.Kritik Pozisyon'></label>
					</div>
					<cfif #listgetat(attributes.fuseaction,1,'.')# is not 'service'>
					<div class="form-group col col-2 col-md-2 col-sm-6 col-xs-12" id="item-is_org_view">
						<label class="col col-12 col-md-12 col-sm-12 col-xs-12"><input type="checkbox" name="is_org_view" id="is_org_view" value="1" <cfif category.IS_ORG_VIEW eq 1>checked</cfif>><cf_get_lang dictionary_id ='56059.Org Şemada Göster'></label>
					</div>
					</cfif>
				</div>
				<div class="col col-4 col-md-4 col-sm-4 col-xs-12" type="column" index="2" sort="true">
					<div class="form-group" id="item-role_head">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55478.Rol'> *</label>
						<div class="col col-8 col-xs-12">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='56087.Rol Adı Girmelisiniz'></cfsavecontent>
							<cfinput type="text" name="role_head" value="#category.role_head#" style="width:250px;" maxlength="100" required="yes" message="#message#">
						</div>
					</div>
					<div class="form-group" id="item-member_name">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57576.Çalışan'> *</label>
						<div class="col col-8 col-xs-12">
							<div class="input-group">
								<input type="hidden" name="employee_id" id="employee_id" value="<cfoutput>#category.employee_id#</cfoutput>">
								<input type="hidden" name="consumer_id" id="consumer_id" value="<cfoutput>#category.consumer_id#</cfoutput>">
								<input type="hidden" name="company_id" id="company_id"  value="<cfoutput>#category.company_id#</cfoutput>">
								<input type="hidden" name="partner_id" id="partner_id"  value="<cfoutput>#category.partner_id#</cfoutput>">
								<input type="hidden" name="member_type" id="member_type" value="">
								<cfif len(category.employee_id)>
									<input type="text" name="member_name" id="member_name" readonly="readonly" value="<cfoutput>#get_emp_info(category.employee_id,0,0)#</cfoutput>" style="width:250px;"> <span class="input-group-addon icon-ellipsis btnPointer" title="" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&&field_consumer=worker.consumer_id&field_comp_id=worker.company_id&field_partner=worker.partner_id&field_name=worker.member_name&field_emp_id=worker.employee_id&field_type=worker.member_type&select_list=1,2,3</cfoutput>','list');"></span>
								<cfelseif len(category.consumer_id)>
									<input type="text" name="member_name" id="member_name" readonly="readonly" value="<cfoutput>#get_cons_info(category.CONSUMER_ID,1,0)#</cfoutput>" style="width:250px;"> <span class="input-group-addon icon-ellipsis btnPointer" title="" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&&field_consumer=worker.consumer_id&field_comp_id=worker.company_id&field_partner=worker.partner_id&field_name=worker.member_name&field_emp_id=worker.employee_id&field_type=worker.member_type&select_list=1,2,3</cfoutput>','list');"></span>
								<cfelseif len(category.partner_id)>
									<input type="text" name="member_name" id="member_name" readonly="readonly" value="<cfoutput>#get_par_info(category.PARTNER_ID,0,0,0)#</cfoutput>" style="width:250px;"> <span class="input-group-addon icon-ellipsis btnPointer" title="" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&&field_consumer=worker.consumer_id&field_comp_id=worker.company_id&field_partner=worker.partner_id&field_name=worker.member_name&field_emp_id=worker.employee_id&field_type=worker.member_type&select_list=1,2,3</cfoutput>','list');"></span>
								</cfif>
								
							</div>
						</div>
					</div>
					<div class="form-group" id="item-role_id">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57630.Tip'></label>
						<div class="col col-8 col-xs-12">
							<cfsavecontent variable="text"><cf_get_lang dictionary_id='55202.Rol Seçiniz'></cfsavecontent>
							<cf_wrk_combo
								name="role_id"
								query_name="GET_PROJECT_ROL"
								option_name="PROJECT_ROLES"
								option_value="PROJECT_ROLES_ID"
								value="#category.role_id#"
								width="250"
								option_text="#text#">
								</div>
					</div>
					<div class="form-group" id="item-work_group">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58140.İş Grubu'></label>
						<div class="col col-8 col-xs-12">
							<input type="hidden" name="workgroup_hierarchy" id="workgroup_hierarchy" value="<cfoutput>#category.workgroup_hierarchy#</cfoutput>">
							<input type="text" name="work_group" id="work_group" value="<cfoutput>#category.workgroup_name#</cfoutput>" style="width:250px;" readonly>
							<input type="hidden" name="workgroup_id" id="workgroup_id" value="<cfoutput>#category.workgroup_id#</cfoutput>">
						</div>
					</div>
				</div>
				<div class="col col-4 col-md-4 col-sm-4 col-xs-12" type="column" index="3" sort="true">
					<div class="form-group" id="item-UPPER_ROLE_HEAD">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='56089.Üst Rol'></label>
						<div class="col col-8 col-xs-12">
							<div class="input-group">
								<input type="hidden" name="UPPER_ROW_ID" id="UPPER_ROW_ID" value="<cfif len(CATEGORY.UPPER_ROW_ID)><cfoutput>#CATEGORY.UPPER_ROW_ID#</cfoutput></cfif>">
								<input type="text" name="UPPER_ROLE_HEAD" id="UPPER_ROLE_HEAD" value="<cfoutput>#upper_name#</cfoutput>" style="width:250px;">
								<span class="input-group-addon icon-ellipsis btnPointer" title="" onclick="rol_getir();"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-order_no">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55657.Sıra No'></label>
						<div class="col col-8 col-xs-12">
							<cfinput type="text" name="order_no" value="#category.order_no#" style="width:250px;" validate="integer" message="#getLang('','',56090)#">
						</div>
					</div>
					<div class="form-group" id="item-hierarchy">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57761.Hiyerarşi'> *</label>
						<div class="col col-4 col-xs-12">
							<input type="hidden" name="old_hierarchy_code" id="old_hierarchy_code" value="<cfoutput>#upper_hierarchy#.#my_hierarchy#</cfoutput>">
							<input type="text" name="hierarchy1_code" id="hierarchy1_code" value="<cfoutput>#upper_hierarchy#</cfoutput>" readonly>
						</div>
						<div class="col col-4 col-xs-12">
							<cfinput type="text" name="hierarchy" value="#my_hierarchy#" maxlength="50" required="yes" message="#getLang('','',56091)#">
						</div>
					</div>
				</div>
			</cf_box_elements>
			<cf_box_footer>
				<div class="col col-6">
					<cf_record_info query_name="category">
				</div>
				<div class="col col-6">
					<cfif CATEGORY_ALTS.recordcount>
						<cf_workcube_buttons is_upd='1' add_function='kontrol_et()' is_delete='0'> 
					<cfelse>
						<cf_workcube_buttons is_upd='1' add_function='kontrol_et()' delete_page_url='#request.self#?fuseaction=#fusebox.circuit#.emptypopup_worker_del&wrk_row_id=#category.wrk_row_id#'  delete_alert='#getLang('','Kademeyi Siliyorsunuz! Emin misiniz',56390)#'> 
					</cfif>
				</div>
			</cf_box_footer>
		</cfform>
	</cf_box>
</div>
<script type="text/javascript">
	function rol_getir()
	{
		if(document.worker.workgroup_hierarchy.value=='')
			{
			alert("<cf_get_lang dictionary_id ='56093.Önce İş Grubu Seçiniz'>");
			return false;
			}
			my_workgroup_id = document.worker.workgroup_id.value;
		windowopen('<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.popup_list_upper_roles&upper_rol_id=worker.UPPER_ROW_ID&upper_rol_head=worker.UPPER_ROLE_HEAD&hierarchy_code=worker.hierarchy1_code&WORKGROUP_ID=</cfoutput>'+my_workgroup_id+'&aktif_hierarchy='+document.worker.old_hierarchy_code.value,'list');
	}
	function kontrol_et()
	{
		if (document.getElementById('member_name').value == "")
		{
			alert("<cf_get_lang dictionary_id='56353.Çalışan Seçmediniz Lütfen Kontrol Ediniz'>");
			return false;
		}
		<cfif listgetat(attributes.fuseaction,1,'.') is not 'service'>
			if(document.worker.is_org_view.checked==false)
				{
				if(confirm("<cf_get_lang dictionary_id ='56389.Organizasyonda Görünmesin Seçerseniz Tüm Alt Pozisyonlarda Bu Özellik Kaldırılacak Emin misiniz'>")) return true; return false;
				}
		</cfif>
		<cfif isdefined("attributes.draggable")>
			loadPopupBox('worker' , <cfoutput>#attributes.modal_id#</cfoutput>);
			return false;
		<cfelse>
			return true;
		</cfif>

	}
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
