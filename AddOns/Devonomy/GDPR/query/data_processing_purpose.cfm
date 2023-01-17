<cfscript>
    gdpr_comp = createObject("component","addons.devonomy.gdpr.cfc.data_processing_purpose");
	gdpr_comp.dsn = dsn;
	if(attributes.event == "del"){
		if(not gdpr_comp.del_data_processing_purpose(data_processing_purpose_id: '#attributes.id#')){
            writeOutput("<script>alert('Silme Hata Oluştu');</script>");
		}
	}
	if(isDefined("attributes.form_submitted") and len(attributes.form_submitted)){	
		if(not len(attributes.id)){
			if(gdpr_comp.add_data_processing_purpose(
				data_processing_purpose: '#attributes.data_processing_purpose#',
				data_processing_purpose_description: '#attributes.data_processing_purpose_description#',
				is_active:'#attributes.is_active#')
			){
                attributes.actionid = gdpr_comp.get_data_processing_purpose_maxId();
			}
			else {
				writeOutput("<script>alert('Hata Oluştu');</script>");
			}
		}else{
            attributes.actionid = attributes.id;
            if(not gdpr_comp.upd_data_processing_purpose(
				data_processing_purpose_id: '#attributes.id#',
				data_processing_purpose: '#attributes.data_processing_purpose#',
				data_processing_purpose_description: '#attributes.data_processing_purpose_description#',
				is_active:'#attributes.is_active#'
            )){
                writeOutput("<script>alert('Hata Oluştu');</script>");
            }
		}	
    }
</cfscript>