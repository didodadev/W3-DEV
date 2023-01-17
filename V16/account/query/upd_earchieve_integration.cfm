<cfscript>
	earchieve = createObject("component","V16.e_government.cfc.earchieve");
	earchieve.dsn = dsn;
	earchieve.dsn2 = dsn2;
	get_integration_definitions = earchieve.get_our_company_fnc(session.ep.company_id);

	if(isdefined('attributes.earchive_test_system')) earchive_test_system = 1; else earchive_test_system = 0;
	if(isdefined('attributes.multiple_prefix')) multiple_prefix = 1; else multiple_prefix = 0;
	
	if(get_integration_definitions.recordcount)
	{
        updIntegrationDefinitions = earchieve.updIntegrationDefinitions(
                                        earchive_integration_type : attributes.earchive_integration_type,
                                        earchive_test_system : earchive_test_system,
                                        earchive_company_code : attributes.earchive_company_code,
                                        earchive_username : attributes.earchive_username,
                                        earchive_password : attributes.earchive_password,
                                        earchive_prefix : attributes.earchive_prefix,
										earchive_prefix_internet : attributes.earchive_prefix_internet,
										earchive_template: '#iif(isdefined("attributes.earchive_template"),"attributes.earchive_template",DE(""))#',
										earchive_internet_template: '#iif(isdefined("attributes.earchive_internet_template"),"attributes.earchive_internet_template",DE(""))#',
										earchive_internet_del_template:'#iif(isdefined("attributes.earchive_internet_del_template"),"attributes.earchive_internet_del_template",DE(""))#',
										earchive_del_template:'#iif(isdefined("attributes.earchive_del_template"),"attributes.earchive_del_template",DE(""))#',
										save_folder:'#iif(isdefined("attributes.save_folder"),"attributes.save_folder",DE(""))#',
										earchive_ublversion:attributes.earchive_ublversion,
										attachment_file: '#iif(isdefined("attributes.attachment_file"),"attributes.attachment_file",DE(""))#',
										attachment_file_del:'#iif(isdefined("attributes.attachment_file_del"),"attributes.attachment_file_del",DE(""))#',
										multiple_prefix:'#multiple_prefix#',
										earchive_type_alias : '#attributes.earchive_type#'
        );
	} else {
        addIntegrationDefinitions = earchieve.addIntegrationDefinitions(
                                        earchive_integration_type : attributes.earchive_integration_type,
                                        earchive_test_system : earchive_test_system,
                                        earchive_company_code : attributes.earchive_company_code,
                                        earchive_username : attributes.earchive_username,
                                        earchive_password : attributes.earchive_password,
                                        earchive_prefix : attributes.earchive_prefix,
										earchive_prefix_internet : attributes.earchive_prefix_internet,
										earchive_template: '#iif(isdefined("attributes.earchive_template"),"attributes.earchive_template",DE(""))#',
										earchive_internet_template: '#iif(isdefined("attributes.earchive_internet_template"),"attributes.earchive_internet_template",DE(""))#',
										save_folder:'#iif(isdefined("attributes.save_folder"),"attributes.save_folder",DE(""))#',
										earchive_internet_del_template:'#iif(isdefined("attributes.earchive_internet_del_template"),"attributes.earchive_internet_del_template",DE(""))#',
										earchive_del_template:'#iif(isdefined("attributes.earchive_del_template"),"attributes.earchive_del_template",DE(""))#',
										multiple_prefix:'#multiple_prefix#',
										earchive_type_alias : '#attributes.earchive_type#'
       );
	}
</cfscript>
<script type="text/javascript">
	window.location.href = '<cfoutput>#request.self#?fuseaction=account.earchieve_integration_definitions</cfoutput>';
</script>