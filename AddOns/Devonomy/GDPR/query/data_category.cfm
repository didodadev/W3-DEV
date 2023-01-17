<cfscript>
	gdpr_comp = createObject("component","addons.devonomy.gdpr.cfc.data_category");
	gdpr_comp.dsn = dsn;
	if(attributes.event == "del"){
		if(not gdpr_comp.del_data_category(data_category_id: '#attributes.id#'))
		{
			writeOutput("<script>alert('Silme Hata Oluştu');history.back();</script>");
		}
	}
	if(isDefined("attributes.form_submitted") and len(attributes.form_submitted)){	
		if(not len(attributes.id)){
			if(gdpr_comp.add_data_category(
				data_category: '#attributes.data_category#',
				data_category_description: '#attributes.data_category_description#',
				data_category_type_id: '#attributes.data_category_type_id#',
				sensitivity_label_id:'#attributes.sensitivity_label_id#',
				is_active: '#attributes.is_active#')
			){ 
				attributes.actionid = gdpr_comp.get_data_category_maxId();
			}
			else {
				writeOutput("<script>alert('Hata Oluştu');history.back();</script>");
			}
		}else{
			attributes.actionid = attributes.id;
			if(NOT gdpr_comp.upd_data_category(
				data_category_id: '#attributes.id#',
				data_category: '#attributes.data_category#',
				data_category_description: '#attributes.data_category_description#',
				data_category_type_id: '#attributes.data_category_type_id#',
				sensitivity_label_id:'#attributes.sensitivity_label_id#',
				is_active: '#attributes.is_active#'
			)){
				writeOutput("<script>alert('Hata Oluştu');</script>");
			}

		}
	}
</cfscript>