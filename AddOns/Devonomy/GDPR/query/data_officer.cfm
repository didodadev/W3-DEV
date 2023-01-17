<cfscript>
	gdpr_comp = createObject("component","addons.devonomy.gdpr.cfc.data_officer");
	if(attributes.event == "del"){
		if(not gdpr_comp.del_data_officer(data_officer_id: '#attributes.id#'))
		{
			writeOutput("<script>alert('Silme Hata Oluştu');history.back();</script>");
		}
	}
	if(isDefined("attributes.form_submitted") and len(attributes.form_submitted)){	
		if(not len(attributes.id)){
			if(gdpr_comp.add_data_officer(
				data_officer_name: '#attributes.data_officer_name#',
				data_officer_description: '#attributes.data_officer_description#',
				data_officer_kep_address: '#attributes.data_officer_kep_address#',
				data_officer_address: '#attributes.data_officer_address#',
				verbis_user: '#attributes.verbis_user#',
				verbis_password: '#attributes.verbis_password#',
				verbis_registration_date:'#iif(len("attributes.verbis_registration_date"),"attributes.verbis_registration_date",DE(""))#',
				contact_emp_id: '#iif(isdefined("attributes.contact_emp_id"),"attributes.contact_emp_id",DE("0"))#',
				contact_name:'#iif(isdefined("attributes.contact_name"),"attributes.contact_name",DE(""))#',
				our_company_id : '#iif(isdefined("attributes.our_company_id"),"attributes.our_company_id",DE(""))#',
				is_employee : '#iIf(isdefined("is_employee"),DE(1),DE(0))#',
				is_contacts : '#iIf(isdefined("is_contacts"),DE(1),DE(0))#',
				is_accounts : '#iIf(isdefined("is_accounts"),DE(1),DE(0))#'
			)){ 
				attributes.actionid = gdpr_comp.get_data_officer_maxId();
			}
			else {
				writeOutput("<script>alert('Hata Oluştu');history.back();</script>");
			}
		}else{
			attributes.actionid = attributes.id;
			if(NOT gdpr_comp.upd_data_officer(
				data_officer_id: '#attributes.id#',
				data_officer_name: '#attributes.data_officer_name#',
				data_officer_description: '#attributes.data_officer_description#',
				data_officer_kep_address: '#attributes.data_officer_kep_address#',
				data_officer_address: '#attributes.data_officer_address#',
				verbis_user: '#attributes.verbis_user#',
				verbis_password: '#attributes.verbis_password#',
				verbis_registration_date:'#iif(len("attributes.verbis_registration_date"),"attributes.verbis_registration_date",DE(""))#',
				contact_emp_id: '#iif(isdefined("attributes.contact_emp_id"),"attributes.contact_emp_id",DE("0"))#',
				contact_name:'#iif(isdefined("attributes.contact_name"),"attributes.contact_name",DE(""))#',
				our_company_id : '#iif(isdefined("attributes.our_company_id"),"attributes.our_company_id",DE(""))#',
				is_employee : '#iIf(isdefined("is_employee"),DE(1),DE(0))#',
				is_contacts : '#iIf(isdefined("is_contacts"),DE(1),DE(0))#',
				is_accounts : '#iIf(isdefined("is_accounts"),DE(1),DE(0))#'
			)){
				writeOutput("<script>alert('Hata Oluştu');</script>");
			}

		}
	}
</cfscript>