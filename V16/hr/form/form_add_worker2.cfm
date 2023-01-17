<cf_get_lang_set module_name="hr"><!--- sayfanin en altinda kapanisi var --->
<cfset upper_hierarchy = ''>
<cfset upper_name = ''>
<cfif isdefined("attributes.workgroup_id") and len(attributes.workgroup_id)>
	<cfquery name="CATEGORY" datasource="#dsn#">
		SELECT * FROM WORK_GROUP WHERE WORKGROUP_ID=#URL.WORKGROUP_ID#
	</cfquery>
	<cfset upper_hierarchy = CATEGORY.hierarchy>
<cfelse>
	<cfinclude template="../query/get_workgroup_uppers.cfm">
</cfif>
<cfif isdefined("attributes.upper_row_id")>
	<cfquery name="upper_rol" datasource="#dsn#">
		SELECT * FROM WORKGROUP_EMP_PAR WHERE WRK_ROW_ID = #attributes.upper_row_id#
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
<cfparam name="attributes.modal_id" default="">

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box title="#iif(isDefined("attributes.draggable"),"getLang('','Grup Çalışanı Ekle',64584)",DE(''))#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),DE(1),DE(0))#">
		<cfform name="worker" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_worker_add2" method="post"> 
			<cf_box_elements>
				<div class="col col-12 col-md-12 col-sm-12 col-xs-12" type="column" index="1" sort="true">
					<div class="form-group col col-2 col-md-1 col-sm-6 col-xs-12" id="item-is_real">
						<label class="col col-12 col-md-12 col-sm-12 col-xs-12">
							<input type="checkbox" name="is_real" id="is_real" value="1" checked><cf_get_lang dictionary_id='56015.Asıl'>/<cf_get_lang dictionary_id='56088.Vekil'>
						</label>
					</div>
					<div class="form-group col col-2 col-md-2 col-sm-6 col-xs-12" id="item-is_critical">
						<label class="col col-12 col-md-12 col-sm-12 col-xs-12">
							<input type="checkbox" name="is_critical" id="is_critical" value="1"><cf_get_lang dictionary_id='55992.Kritik Pozisyon'>
						</label>
					</div>
					<cfif listgetat(attributes.fuseaction,1,'.') is not 'service'>
					<div class="form-group col col-2 col-md-2 col-sm-6 col-xs-12" id="item-is_org_view">
						<label class="col col-12 col-md-12 col-sm-12 col-xs-12">
							<input type="checkbox" name="is_org_view" id="is_org_view" value="1" checked><cf_get_lang dictionary_id='57972.Organizasyon'>
						</label>
					</div>
					</cfif>
				</div>
				<div class="col col-4 col-md-4 col-sm-4 col-xs-12" type="column" index="2" sort="true">
					<div class="form-group" id="item-role_head">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55478.Rol'> *</label>
						<div class="col col-8 col-xs-12">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='56087.Rol Adı Girmelisiniz'>!</cfsavecontent>
							<cfinput type="text" name="role_head" value="" maxlength="100" required="yes" message="#message#">
						</div>
					</div>
					<div class="form-group" id="item-member_name">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57576.Çalışan'> *</label>
						<div class="col col-8 col-xs-12">
							<div class="input-group">
								<input type="hidden" name="employee_id" id="employee_id" value="">
								<input type="hidden" name="consumer_id" id="consumer_id" value="">
								<input type="hidden" name="company_id" id="company_id"  value="">
								<input type="hidden" name="partner_id" id="partner_id"  value="">
								<input type="hidden" name="member_type" id="member_type" value="">
								<input type="text" name="member_name" readonly="readonly" value="" id="member_name">
								<span class="input-group-addon icon-ellipsis btnPointer" title="" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&&field_consumer=worker.consumer_id&field_comp_id=worker.company_id&field_partner=worker.partner_id&field_name=worker.member_name&field_emp_id=worker.employee_id&field_type=worker.member_type&select_list=1,2,3</cfoutput>','list');"></span>
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
								width="250"
								option_text="#text#">
						</div>
					</div>
					<div class="form-group" id="item-work_group">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58140.İş Grubu'></label>
						<div class="col col-8 col-xs-12">
							<input type="hidden" name="workgroup_hierarchy" id="workgroup_hierarchy" value="<cfif isdefined("attributes.workgroup_id") and len(attributes.workgroup_id)><cfoutput>#category.hierarchy#</cfoutput></cfif>">
							<cfif isdefined("attributes.workgroup_id") and len(attributes.workgroup_id)>
								<input type="text" name="work_group" id="work_group" value="<cfoutput>#category.workgroup_name#</cfoutput>" readonly>
								<input type="hidden" name="workgroup_id" id="workgroup_id" value="<cfoutput>#attributes.workgroup_id#</cfoutput>">
							<cfelse>
								<select value="" name="upper_hierarchy" id="upper_hierarchy" onChange="gonder_code();">
									<option value="" selected><cf_get_lang dictionary_id='57734.Seçiniz'>
									<cfoutput query="GET_WORKGROUPS"> 
										<option value="#HIERARCHY#">#HIERARCHY# #WORKGROUP_NAME#</option>
									</cfoutput> 
								</select>
							</cfif>
						</div>
					</div>
				</div>
				<div class="col col-4 col-md-4 col-sm-4 col-xs-12" type="column" index="3" sort="true">
					<div class="form-group" id="item-UPPER_ROLE_HEAD">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='56089.Üst Rol'></label>
						<div class="col col-8 col-xs-12">
							<div class="input-group">
								<input type="hidden" name="UPPER_ROW_ID" id="UPPER_ROW_ID" value="<cfif isdefined("attributes.upper_row_id")><cfoutput>#attributes.upper_row_id#</cfoutput></cfif>">
								<input type="text" name="UPPER_ROLE_HEAD" id="UPPER_ROLE_HEAD" value="<cfoutput>#upper_name#</cfoutput>">
								<span class="input-group-addon icon-ellipsis" title="" onclick="rol_getir();"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-order_no">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55657.Sıra No'></label>
						<div class="col col-8 col-xs-12">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='56090.Sıra No Sayısal Olmalıdır'>!</cfsavecontent>
							<cfinput type="text" name="order_no" value="" validate="integer" message="#message#">
						</div>
					</div>
					<div class="form-group" id="item-hierarchy">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57761.Hiyerarşi'> *</label>
						<div class="col col-4 col-xs-12">
							<input type="text" name="hierarchy1_code" id="hierarchy1_code" value="<cfoutput>#upper_hierarchy#</cfoutput>" readonly>
						</div>
						<div class="col col-4 col-xs-12">
							<cfinput type="text" name="hierarchy" value="" maxlength="50" required="yes" message="#getLang('','Hierarşi Kodu Girmelisiniz',56091)#">
						</div>
					</div>
				</div>
			</cf_box_elements>
			<cf_box_footer>
				<div class="col col-12">
					<cfif isdefined("attributes.workgroup_id")>
						<cf_workcube_buttons is_upd='0' add_function="kontrol()"> 
					<cfelse>
						<cf_workcube_buttons is_upd='0' add_function="kontrol()">
					</cfif>
				</div>
			</cf_box_footer>
		</cfform>
	</cf_box>
</div>

<script type="text/javascript">
	a = "";
	<cfif not (isdefined("attributes.workgroup_id") and len(attributes.workgroup_id))>
		function gonder_code()
		{
			a = document.worker.upper_hierarchy[document.worker.upper_hierarchy.selectedIndex].value;
			document.worker.hierarchy1_code.value = a 
			document.worker.workgroup_hierarchy.value = a;
		}
	</cfif>
	function kontrol()
	{
		if (document.getElementById('member_name').value == "")
		{
			alert("<cf_get_lang dictionary_id='56353.Çalışan Seçmediniz Lütfen Kontrol Ediniz'>");
			return false;
		}

		<cfif not (isdefined("attributes.workgroup_id") and len(attributes.workgroup_id))>
			a = document.worker.upper_hierarchy[document.worker.upper_hierarchy.selectedIndex].value;
			if(a == "")
			{
				alert("<cf_get_lang dictionary_id='56092.İş Grubu Seçiniz'>!");
				return false;
			}
		</cfif>
		<cfif isdefined("attributes.draggable")>
			loadPopupBox('worker' , <cfoutput>#attributes.modal_id#</cfoutput>);
			return false;
		<cfelse>
			return true;
		</cfif>
	}
	function rol_getir()
	{
		if(document.worker.workgroup_hierarchy.value=='')
			{
				alert("<cf_get_lang dictionary_id='56093.Önce İş Grubu Seçiniz'>!");
				return false;
			}

			<cfif isdefined("attributes.workgroup_id") and len(attributes.workgroup_id)>
				my_workgroup_id = document.worker.workgroup_id.value;
			<cfelse>
				var run_query = wrk_safe_query('hr_wrk_grp','dsn',0,document.worker.upper_hierarchy.value);
				my_workgroup_id = run_query.WORKGROUP_ID;
			</cfif>
			windowopen('<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.popup_list_upper_roles&upper_rol_id=worker.UPPER_ROW_ID&upper_rol_head=worker.UPPER_ROLE_HEAD&hierarchy_code=worker.hierarchy1_code&WORKGROUP_ID=</cfoutput>'+my_workgroup_id,'list');
	}
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
