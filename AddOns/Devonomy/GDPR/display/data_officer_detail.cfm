<!---
    File: data_officer_detail.cfm
    Author: 
    Date: 
    Controller: 
    Description:
--->
<cfscript>
	if(Not isDefined("attributes.id")) attributes.id =  "";
	if(not len(attributes.id)){
		writeOutput("<script>alert('Hata Oluştu');history.back();</script>");
		exit;
	}
	gdpr_comp = createObject("component","addons.devonomy.gdpr.cfc.data_officer");
	get_data_officer = gdpr_comp.get_data_officer_byId(data_officer_id : attributes.id);
	get_committee = gdpr_comp.get_committee(data_officer_id : attributes.id);

</cfscript>

<!--- Sayfa başlığı ve ikonlar --->
<cfset pageHead = "Veri Sorumlusu: #attributes.id#">
<cf_catalystHeader>
<!--- Sayfa ana kısım --->
<div class="row"> <!---///ilk row--->
	<div class="col col-9 col-xs-12 uniqueRow"> <!---///content sol--->
		<!--- Geniş alan: içerik --->
		<cf_box id="officer_summary" closable="1"  title="#getLang('','Veri Sorumluluğu ve Politikalar',65301)#" box_page="AddOns/Devonomy/GDPR/display/data_officer_detail_summary.cfm?id=#attributes.id#&form_action=#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_add_project"></cf_box>
		<!--- Geçerli Şirketler --->
		<cf_box id="our_company_id" closable="1"  title="#getLang('','Geçerli',959)# #getLang('','Şirketler',29531)#" >
			<cf_flat_list>
				<thead>
					<th><cf_get_lang dictionary_id='58485.Şirket Adı'></th>
					<th><cf_get_lang dictionary_id='51174.Yönetici'></th>
				</thead>
				<tbody>
					<cfloop from="1" to="#listlen(get_data_officer.our_company_id)#" index="i">
					<cfset get_company_data_officer = gdpr_comp.get_company_data_officer(comp_id : listgetat(get_data_officer.our_company_id,i,','))>
				
				
					<tr><td><cfoutput>#get_company_data_officer.company_name#</cfoutput></td>
					<td><cfoutput>#get_company_data_officer.manager#</cfoutput></td></tr>
				</cfloop>	</tbody>
			</cf_flat_list>
		</cf_box>
		<!--- Icerikler --->
		<div id="unique_content" class="uniqueBox">
			<cf_get_workcube_content action_type ='DATA_OFFICER_ID' style="box-shadow:none;" action_type_id ='#attributes.id#'design='1'>
		</div>
	</div>
	<div class="col col-3 col-xs-12 uniqueRow"> <!---///content sağ--->
		<!--- Yan kısım --->
		<cf_box 
			id="workgroup" 
			title="Kurul" 
			box_page="#request.self#?fuseaction=project.list_workgroup&committee_id=#attributes.id#">
		</cf_box>
		<!----Belgeler----->
		<div id="unique_asset" class="uniqueBox">    
			<cf_get_workcube_asset asset_cat_id="-1" module_id='1' action_section='DATA_OFFICER_ID' action_id='#attributes.id#'>    
		</div>    
		<!----Notlar------->
		<div id="unique_notes" class="uniqueBox">    
			<cf_get_workcube_note action_section='DATA_OFFICER_ID' closable="0"  module_id='1' action_id='#attributes.id#' style='1'>
		</div>
		<!---- İlişkili Olaylar ----->
		<!---<cf_get_related_events action_section='DATA_OFFICER_ID' action_id='#attributes.id#'>--->
    </div>
</div>


