<!---
    File: data_inventory_detail.cfm
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
</cfscript>

<!--- Sayfa başlığı ve ikonlar --->

<cfset pageHead = "Veri Envanteri: #attributes.id#">
<cf_catalystHeader>
<!--- Sayfa ana kısım --->
<div class="row"> <!---///ilk row--->
	<div class="col col-9 col-xs-12 uniqueRow"> <!---///content sol--->
		<!--- Geniş alan: içerik --->
		<cf_box id="inventory_form" closable="0"  title="Veri Envanteri" box_page="#request.self#?fuseaction=gdpr.data_inventory&event=upd&data_officer_id=#attributes.data_officer_id#&id=#attributes.id#"></cf_box>
		

		<!--- Icerikler --->
		<cf_box 
			id="data_subject" 
			title="Veri İşleme Amacı" 
			box_page="#request.self#?fuseaction=gdpr.data_processing_purpose&id=#attributes.id#">
		</cf_box>

	</div>
	<div class="col col-3 col-xs-12 uniqueRow"> <!---///content sağ--->
		<!--- Yan kısım --->
		<cf_box 
			id="pa" 
			title="Organizasyon ve Süreç" 
			box_page="#request.self#?fuseaction=project.list_workgroup&project_id=#attributes.id#">
		</cf_box>
		<cf_box 
			id="p" 
			title="Tedbirler" 
			box_page="#request.self#?fuseaction=project.list_workgroup&project_id=#attributes.id#">
		</cf_box>
		<cf_box 
			id="workgroup" 
			title="Veri Aktarım Grupları" 
			box_page="#request.self#?fuseaction=project.list_workgroup&project_id=#attributes.id#">
		</cf_box>  
		
	</div>
</div>


