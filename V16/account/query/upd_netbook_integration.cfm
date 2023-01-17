<cfscript>
	netbook = createObject("component","V16.e_government.cfc.netbook");
	netbook.dsn = dsn;
	netbook.dsn2 = dsn2;
	get_integration_definitions = netbook.getIntegrationDefinitions();

	if(isdefined('attributes.netbook_test_system')) { netbook_test_system = 1; } else { netbook_test_system = 0; }
	
	if(get_integration_definitions.recordcount)
	{
        updIntegrationDefinitions = netbook.updIntegrationDefinitions(
                                        netbook_integration_type : attributes.netbook_integration_type,
                                        netbook_test_system : netbook_test_system,
                                        netbook_test_webservice_url : attributes.netbook_test_webservice_url,
                                        netbook_test_company_code : attributes.netbook_test_company_code,
                                        netbook_test_username : attributes.netbook_test_username,
                                        netbook_test_password : attributes.netbook_test_password,
                                        netbook_webservice_url : attributes.netbook_webservice_url,
                                        netbook_company_code : attributes.netbook_company_code,
                                        netbook_username : attributes.netbook_username,
                                        netbook_password : attributes.netbook_password,
										
										netbook_test_ftp_server : attributes.netbook_test_ftp_server,
                                        netbook_test_ftp_port : attributes.netbook_test_ftp_port,
                                        netbook_test_ftp_username : attributes.netbook_test_ftp_username,
                                        netbook_test_ftp_password : attributes.netbook_test_ftp_password,
                                        netbook_ftp_server : attributes.netbook_ftp_server,
                                        netbook_ftp_port : attributes.netbook_ftp_port,
                                        netbook_ftp_username : attributes.netbook_ftp_username,
                                        netbook_ftp_password : attributes.netbook_ftp_password
                                                );
	} else {
        addIntegrationDefinitions = netbook.addIntegrationDefinitions(
                                        netbook_integration_type : attributes.netbook_integration_type,
                                        netbook_test_system : netbook_test_system,
                                        netbook_test_webservice_url : attributes.netbook_test_webservice_url,
                                        netbook_test_company_code : attributes.netbook_test_company_code,
                                        netbook_test_username : attributes.netbook_test_username,
                                        netbook_test_password : attributes.netbook_test_password,
                                        netbook_webservice_url : attributes.netbook_webservice_url,
                                        netbook_company_code : attributes.netbook_company_code,
                                        netbook_username : attributes.netbook_username,
                                        netbook_password : attributes.netbook_password,
										netbook_test_ftp_server : attributes.netbook_test_ftp_server,
                                        netbook_test_ftp_port : attributes.netbook_test_ftp_port,
                                        netbook_test_ftp_username : attributes.netbook_test_ftp_username,
                                        netbook_test_ftp_password : attributes.netbook_test_ftp_password,
                                        netbook_ftp_server : attributes.netbook_ftp_server,
                                        netbook_ftp_port : attributes.netbook_ftp_port,
                                        netbook_ftp_username : attributes.netbook_ftp_username,
                                        netbook_ftp_password : attributes.netbook_ftp_password
                                                );
	}
	//BK 20150728 E-Defter durumu guncellenmiyor
	//if(isdefined('attributes.is_edefter')) { is_edefter = 1; } else { is_edefter = 0; }
	//updEdefterInfo = netbook.updEdefterInfo(
								//is_edefter : is_edefter
										//);
</cfscript>
<script type="text/javascript">
	window.location.href = '<cfoutput>#request.self#?fuseaction=account.netbook_integration_definitions</cfoutput>';
</script>