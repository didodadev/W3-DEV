<cfscript>
    gdpr_comp = createObject("component","addons.devonomy.gdpr.cfc.sensitivity_label");
	gdpr_comp.dsn = dsn;
	if(attributes.event == "del"){
		if(gdpr_comp.del_data_category_type_byId(sensitivity_label_id: '#attributes.id#')){
			writeOutput("<script type='text/javascript'>window.location.href='#request.self#?fuseaction=gdpr.sensitivity_label';</script>");
		}else{
			writeOutput("<script type='text/javascript'>alert('Bir Hata Oluştu Lütfen Daha sonra tekrar deneyiniz!');window.location.href='#request.self#?fuseaction=gdpr.sensitivity_label&event=upd&id=#attributes.id#';</script>");
		}
	}
	if(isDefined("attributes.form_submitted") and len(attributes.form_submitted)){	
		if(not len(attributes.id)){
			if(gdpr_comp.add_sensitivity_label(
				sensitivity_label: '#attributes.sensitivity_label#',
				sensitivity_label_description: '#attributes.sensitivity_label_description#')
			){
                attributes.actionid = gdpr_comp.get_sensitivity_label_maxId();
			}
			else {
				writeOutput("<script>alert('Hata Oluştu');</script>");
			}
		}else{
            attributes.actionid = attributes.id;
            if(not gdpr_comp.upd_sensitivity_label(
				sensitivity_label_id: '#attributes.id#',
				sensitivity_label: '#attributes.sensitivity_label#',
				sensitivity_label_description: '#attributes.sensitivity_label_description#'
            )){
                writeOutput("<script>alert('Hata Oluştu');</script>");
            }
		}	
    }
</cfscript>