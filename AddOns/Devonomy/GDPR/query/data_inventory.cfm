<cfscript>
	gdpr_comp = new addons.devonomy.gdpr.cfc.data_inventory(data_officer_id:attributes.data_officer_id);
	is_error = false;
	if(attributes.event == "del"){
		if(not gdpr_comp.del_data_inventory(data_inventory_id: '#attributes.id#'))
		{
			is_error=true;
		}
	}
	if(isDefined("attributes.form_submitted") and len(attributes.form_submitted)){
		if(not len(attributes.id)){
			transaction {
				if(gdpr_comp.add_data_inventory(
					data_inventory: attributes.data_inventory,
					data_inventory_description: attributes.data_inventory_description,
					data_inventory_legal_justification:attributes.data_inventory_legal_justification,
					data_category_id:attributes.data_category_id,
					data_subject_group_id:attributes.data_subject_group_id,
					is_transfer:iif(isDefined("attributes.is_transfer"),true,false),
					is_foreign_transfer:iif(isDefined("attributes.is_foreign_transfer"),true,false),
					storage_type:attributes.storage_type,
					period:iif(isNumeric(period),attributes.period,0),
					is_active:'#attributes.is_active#')
				
				){ 
					attributes.actionid = gdpr_comp.get_data_inventory_maxId();
					if(isDefined("attributes.is_foreign_transfer") && attributes.is_foreign_transfer){
						
						gdpr_transfer_comp = new addons.devonomy.gdpr.cfc.data_inventory_transfer(data_officer_id:attributes.data_officer_id,data_inventory_id:attributes.actionid);
						gdpr_transfer_comp.add_data_inventory_transfer(
							adequate_protection:iif(isDefined("attributes.adequate_protection"),true,false),
							corporation_desicion:iif(isDefined("attributes.corporation_desicion"),true,false),
							written_commitment:iif(isDefined("attributes.written_commitment"),true,false),
							clear_consent:iif(isDefined("attributes.clear_consent"),true,false),
							other_law:iif(isDefined("attributes.other_law"),true,false),
							transfer_detail:attributes.transfer_detail
						);
					}
				}
				else {
					is_error=true;
				}
			}
		}else{
			attributes.actionid = attributes.id;
			if(gdpr_comp.upd_data_inventory(
				data_inventory_id : attributes.id,
				data_inventory: attributes.data_inventory,
				data_inventory_description: attributes.data_inventory_description,
				data_inventory_legal_justification:attributes.data_inventory_legal_justification,
				data_category_id:attributes.data_category_id,
				data_subject_group_id:attributes.data_subject_group_id,
				is_transfer:iif(isDefined("attributes.is_transfer"),true,false),
				is_foreign_transfer:iif(isDefined("attributes.is_foreign_transfer"),true,false),
				storage_type:attributes.storage_type,
				period:iif(isNumeric(period),attributes.period,0),
				is_active:'#attributes.is_active#')
			){
				gdpr_transfer_comp = new addons.devonomy.gdpr.cfc.data_inventory_transfer(data_officer_id:attributes.data_officer_id,data_inventory_id:attributes.actionid);
				if(isDefined("attributes.data_inventory_transfer_id") && len(attributes.data_inventory_transfer_id)){
					gdpr_transfer_comp.upd_data_inventory_transfer(
						data_inventory_transfer_id:attributes.data_inventory_transfer_id,
						adequate_protection:iif(isDefined("attributes.adequate_protection"),true,false),
						corporation_desicion:iif(isDefined("attributes.corporation_desicion"),true,false),
						written_commitment:iif(isDefined("attributes.written_commitment"),true,false),
						clear_consent:iif(isDefined("attributes.clear_consent"),true,false),
						other_law:iif(isDefined("attributes.other_law"),true,false),
						transfer_detail:attributes.transfer_detail
					);
				}
			}else{
				is_error=true;
			}

		}
	}
</cfscript>
<script type="text/javascript">
	<cfif is_error>
		alert("Hata Oluştu.");
		history.back();
	<cfelseif attributes.event eq "del">
		window.location.href="<cfoutput>#request.self#?fuseaction=gdpr.data_inventory&data_officer_id=#attributes.data_officer_id#</cfoutput>";	
	<cfelse>
		window.location.href="<cfoutput>#request.self#?fuseaction=gdpr.data_inventory&event=upd&id=#attributes.id#&data_officer_id=#attributes.data_officer_id#</cfoutput>";
	</cfif>
</script>