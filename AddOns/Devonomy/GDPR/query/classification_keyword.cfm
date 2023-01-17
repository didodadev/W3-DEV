<cfscript>
	gdpr_comp = createObject("component","addons.devonomy.gdpr.cfc.classification_keyword");
	gdpr_comp.dsn = dsn;
	if(attributes.event == "del"){
		if(not gdpr_comp.del_classification_keyword(keyword_id: '#attributes.id#'))
		{
			writeOutput("<script>alert('Silme Hata Oluştu');history.back();</script>");
		}
	}
	if(isDefined("attributes.form_submitted") and len(attributes.form_submitted)){	
		if(not len(attributes.id)){
			if(gdpr_comp.add_classification_keyword(
				keyword: '#attributes.keyword#',
				data_category_id: '#attributes.data_category_id#',
				search_type:'#attributes.search_type#',
				keyword_type: '#attributes.keyword_type#',
				is_active: '#attributes.is_active#')
			){ 
				attributes.actionid = gdpr_comp.get_classification_keyword_maxId();
			}
			else {
				writeOutput("<script>alert('Hata Oluştu');</script>");
			}
		}else{
			attributes.actionid = attributes.id;
			
			if(NOT gdpr_comp.upd_classification_keyword(
				keyword_id: '#attributes.id#',
				keyword: '#attributes.keyword#',
				data_category_id: '#attributes.data_category_id#',
				search_type:'#attributes.search_type#',
				keyword_type: '#attributes.keyword_type#',
				is_active: '#attributes.is_active#'
			)){
				writeOutput("<script>alert('Hata Oluştu');</script>");
			}
		}
	}
</cfscript>