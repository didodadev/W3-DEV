<cfscript>
	gdpr_comp = createObject("component","addons.devonomy.gdpr.cfc.classification");
	gdpr_comp.dsn = dsn;
	is_error = false;
	if(attributes.event == "del"){
		if(not gdpr_comp.del_classification(data_officer_id:attributes.data_officer_id, classification_id: attributes.id))
		{
			is_error = true;
			writeOutput("<script>alert('Silme Hata Oluştu');history.back();</script>");
		}
	}

	if(isDefined("attributes.form_submitted") and len(attributes.form_submitted)){	
		if(not len(attributes.id)){
			if(gdpr_comp.add_classification(
				data_officer_id:'#attributes.data_officer_id#',
				sensitivity_label_id: attributes.sensitivity_label_id,
				classification_type_id: '#attributes.classification_type_id#',
				data_category_id: '#attributes.data_category_id#',
				db_name:'#attributes.db_name#',
				schema_name: '#attributes.schema_name#',
				table_name: '#attributes.table_name#',
				column_name: '#attributes.column_name#',
				file_path: '#attributes.file_path#',
				classification_description: '#attributes.classification_description#',
				plevne_door: attributes.plevne_door,
				key_column: '#attributes.key_column#',
				data_fuseaction: '#attributes.data_fuseaction#'
				)
			){ 
				attributes.actionid = gdpr_comp.get_classification_maxId(data_officer_id:'#attributes.data_officer_id#');
			}
			else {
				is_error = true;
				writeOutput("<script>alert('Hata Oluştu');</script>");
			}
		}else{
			attributes.actionid = attributes.id;
			
			if(NOT gdpr_comp.upd_classification(
				data_officer_id:'#attributes.data_officer_id#',
				sensitivity_label_id: attributes.sensitivity_label_id,
				classification_id: '#attributes.id#',
				classification_type_id: '#attributes.classification_type_id#',
				data_category_id: '#attributes.data_category_id#',
				db_name:'#attributes.db_name#',
				schema_name: '#attributes.schema_name#',
				table_name: '#attributes.table_name#',
				column_name: '#attributes.column_name#',
				file_path: '#attributes.file_path#',
				classification_description: '#attributes.classification_description#',
				plevne_door: attributes.plevne_door,
				key_column: '#attributes.key_column#',
				data_fuseaction: '#attributes.data_fuseaction#'
			)){
				is_error = true;
				writeOutput("<script>alert('Hata Oluştu');</script>");
			}
		}
	}
</cfscript>
<script type="text/javascript">
	<cfif is_error>
		history.back();
	<cfelseif attributes.event eq "del">
		window.location.href="<cfoutput>#request.self#?fuseaction=gdpr.data_classification&data_officer_id=#attributes.data_officer_id#</cfoutput>";	
	<cfelse>
		window.location.href="<cfoutput>#request.self#?fuseaction=gdpr.data_classification&event=upd&id=#attributes.id#&data_officer_id=#attributes.data_officer_id#</cfoutput>";
	</cfif>
</script>