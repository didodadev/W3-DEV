<cfscript>
    gdpr_comp = createObject("component","addons.devonomy.gdpr.cfc.data_category_type");
	gdpr_comp.dsn = dsn;
	if(attributes.event == "del"){
		if(not gdpr_comp.del_data_category_type(data_category_type_id: '#attributes.id#')){
            writeOutput("<script>alert('Silme Hata Oluştu');</script>");
		}
	}
	if(isDefined("attributes.form_submitted") and len(attributes.form_submitted)){	
		if(not len(attributes.id)){
			if(gdpr_comp.add_data_category_type(
				data_category_type: '#attributes.data_category_type#',
				data_category_type_description: '#attributes.data_category_type_description#',
				is_active: '#attributes.is_active#')
			){
                attributes.actionid = gdpr_comp.get_data_category_type_maxId();
			}
			else {
				writeOutput("<script>alert('Hata Oluştu');</script>");
			}
		}else{
            attributes.actionid = attributes.id;
            if(not gdpr_comp.upd_data_category_type(
				data_category_type_id: '#attributes.id#',
				data_category_type: '#attributes.data_category_type#',
				data_category_type_description: '#attributes.data_category_type_description#',
				is_active: '#attributes.is_active#'
            )){
                writeOutput("<script>alert('Hata Oluştu');</script>");
            }
		}	
    }
</cfscript>