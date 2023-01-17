<cfscript>
    gdpr_comp = createObject("component","addons.devonomy.gdpr.cfc.data_transfer_group");
	gdpr_comp.dsn = dsn;
	if(attributes.event == "del"){
		if(not gdpr_comp.del_data_transfer_group(data_transfer_group_id: '#attributes.id#')){
            writeOutput("<script>alert('Silme Hata Oluştu');</script>");
		}
	}
	if(isDefined("attributes.form_submitted") and len(attributes.form_submitted)){	
		if(not len(attributes.id)){
			if(gdpr_comp.add_data_transfer_group(
				data_transfer_group: '#attributes.data_transfer_group#',
				data_transfer_group_description: '#attributes.data_transfer_group_description#',
				is_active: '#attributes.is_active#')
			){
                attributes.actionid = gdpr_comp.get_data_transfer_group_maxId();
			}
			else {
				writeOutput("<script>alert('Hata Oluştu');</script>");
			}
		}else{
            attributes.actionid = attributes.id;
            if(not gdpr_comp.upd_data_transfer_group(
				data_transfer_group_id: '#attributes.id#',
				data_transfer_group: '#attributes.data_transfer_group#',
				data_transfer_group_description: '#attributes.data_transfer_group_description#',
				is_active: '#attributes.is_active#'
            )){
				abort;
                writeOutput("<script>alert('Hata Oluştu');</script>");
            }
		}	
    }
</cfscript>