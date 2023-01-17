<cfif fusebox.circuit eq 'myhome' and isdefined("attributes.id") and len(attributes.id) and  not isnumeric(attributes.id)><!---gündem den çağrılan sayfalarda id encrypt li gönderildiği için eklendi SG 20131021 --->​
	<cfset attributes.id = contentEncryptingandDecodingAES(isEncode:0,content:attributes.id,accountKey:'wrk')>
</cfif>
<cfif listgetat(attributes.fuseaction,2,'.') eq 'list_purchasedemand'>
	<cfset is_demand = 1>
<cfelse>
	<cfset is_demand = 0>
</cfif>
<cf_get_lang_set module_name="correspondence"><!--- sayfanin en altinda kapanisi var --->
<cfif listlast(fuseaction,'.') eq "list_internaldemand">
	<cf_xml_page_edit fuseact ="correspondence.add_internaldemand">
<cfelseif listlast(fuseaction,'.') eq "list_purchasedemand"> 
	<cf_xml_page_edit fuseact ="correspondence.add_purchasedemand">
</cfif>
<cfif isdefined("attributes.id") and len(attributes.id)>
	<cfif not isnumeric(attributes.id)><cfset attributes.id = contentEncryptingandDecodingAES(isEncode:0,content:attributes.id,accountKey:'wrk')></cfif>
	<cfscript>
		get_dep = createObject("component","V16.myhome.cfc.get_travel_demands");
		get_dep.dsn = dsn;
	</cfscript>
	<cfscript>
		get_demand_list_action = CreateObject("component","V16.correspondence.cfc.get_demand");
		get_demand_list_action.dsn = dsn3;
		get_internaldemand = get_demand_list_action.get_demand_list_fnc(
		is_demand:is_demand,
		id:attributes.id
		);
		if(len(get_internaldemand.department_id))
			get_department = get_demand_list_action.get_department(department_id : get_internaldemand.department_id);
		else 
			get_department = get_dep.get_department(position_code : get_internaldemand.from_position_code);
	</cfscript>
<cfelse>
	<cfset get_internaldemand.recordcount=0>
</cfif>
<cfif not get_internaldemand.recordcount or (isdefined("attributes.active_company") and attributes.active_company neq session.ep.company_id)>
	<cfset hata  = 11>
	<cfsavecontent variable="message"><cf_get_lang dictionary_id='58943.Böyle Bir Kayıt Bulunmamaktadır'>!</cfsavecontent>
	<cfset hata_mesaj  = message>
	<cfinclude template="../../dsp_hata.cfm">
<cfelse>
	<cfscript>
		session_basket_kur_ekle(table_type_id:7,action_id:attributes.id,process_type:1);
		xml_all_depo_entry = iif(isdefined("xml_location_auth_entry"),xml_location_auth_entry,DE('-1'));
		xml_all_depo_outer = iif(isdefined("xml_location_auth_outer"),xml_location_auth_outer,DE('-1'));
	</cfscript>
	<cfquery name="get_offer" datasource="#DSN3#">
		SELECT OFFER_ID FROM OFFER WHERE INTERNALDEMAND_ID = #attributes.id# AND PURCHASE_SALES = 0
	</cfquery> 
	<cfif attributes.fuseaction is 'purchase.list_purchasedemand' or attributes.fuseaction is 'myhome.list_purchasedemand'>
		<cfset pageHead = "#getlang('objects',873)#: #get_internaldemand.internal_number#">
	<cfelse>
		<cfset pageHead = "#getlang('correspondence',142)#: #get_internaldemand.internal_number#">
	</cfif>
    <cf_catalystHeader>
	<div class="col col-12 col-xs-12">
		<cf_box>
			<div id="basket_main_div">
				<cfform action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_upd_internaldemand" name="form_basket" method="post">
					<cf_basket_form  id="detail_internaldemand">
						<cf_box_elements>
							<cfoutput>
								<input type="hidden" name="form_action_address" id="form_action_address" value="#listgetat(attributes.fuseaction,1,'.')#.emptypopup_upd_internaldemand">
								<input type="hidden" name="id" id="id" value="#attributes.id#">
								<input type="hidden" name="pro_material_id_list" id="pro_material_id_list" value="#listdeleteduplicates(valuelist(GET_INTERNALDEMAND.PRO_MATERIAL_ID))#"><!--- belgeyle ilgili proje malzeme planı id leri --->
								<input type="hidden" name="company_id" id="company_id">
								<input type="hidden" name="consumer_id" id="consumer_id">
								<input type="hidden" name="search_process_date" id="search_process_date" value="target_date">
								<input type="hidden"  name="is_demand" id="is_demand" value="#is_demand#">
							</cfoutput>
							<cfinclude template="upd_internaldemand_noeditor.cfm">
						</cf_box_elements>
						<cf_box_footer>
							<div class="col col-6">
								<cf_record_info query_name="get_internaldemand">
							</div>
							<div class="col col-6">
								<cfset head_ = Replace(get_internaldemand.subject,'"','','all')>
								<cfset head_ = Replace(head_,"'","","all")>
								<cf_workcube_buttons is_upd='1' is_reset=false delete_page_url='#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_del_internaldemand&id=#id#&head=#head_#- #get_internaldemand.internal_number#&type_=#get_internaldemand.demand_type#' add_function='form_kontrol()'>
							</div>
						</cf_box_footer> 
					</cf_basket_form>			
					<cfif session.ep.isBranchAuthorization>
						<cfset attributes.basket_id = 39>
					<cfelseif listgetat(attributes.fuseaction,1,'.') is 'correspondence'>
						<cfset attributes.basket_id = 8>
					<cfelse>
						<cfset attributes.basket_id = 7>
					</cfif>
					<cfif isdefined("attributes.file_format")>
						<cfset attributes.basket_sub_id = 4>
					</cfif>
					<cfinclude template="../../objects/display/basket.cfm">
				</cfform>
			</div>
		</cf_box>
	</div>		
</cfif>
<script type="text/javascript">
	function form_kontrol()
	{
		<cfif isdefined("xml_show_process_cat") and len(xml_show_process_cat) and xml_show_process_cat eq 1 and is_demand eq 1> 
		if(!chk_process_cat('form_basket')) return false;
		</cfif>
		if(document.form_basket.to_position_code.value == "" || document.form_basket.position_code.value == "")
		{
			alert("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='57924.Kime '>!");
			return false;
		}
		<!---
		<cfif is_department_in eq 1 and x_project_department_in eq 1>
			if(document.form_basket.department_in_id.value == "" || document.form_basket.department_in_txt.value == "" )
			{
				alert("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='51192.Giriş Depo'>!");
				return false;
			}
		</cfif>
		--->
		<cfif isdefined('x_apply_deliverdate_to_rows') and x_apply_deliverdate_to_rows eq 1>
			apply_deliver_date('target_date');
		</cfif>
		<cfif isdefined("xml_upd_row_project") and xml_upd_row_project eq 1>
			project_field_name = 'project_head';
			project_field_id = 'project_id';
			apply_deliver_date('',project_field_name,project_field_id);
		</cfif>
		return (process_cat_control() && saveForm());
	}
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
