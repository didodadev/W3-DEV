<cf_date tarih = 'attributes.evoucher_date'>
    <cfscript>
        evoucher = createObject("Component","V16.e_government.cfc.emeslekmakbuzu.common");
        get_integration_definitions = evoucher.get_our_company_fnc(session.ep.company_id);
    
        if(isdefined('attributes.evoucher_test_system')) evoucher_test_system = 1; else evoucher_test_system = 0;
        if(isdefined('attributes.is_active')) is_active = 1; else is_active = 0;

        addIntegrationDefinitions = evoucher.addIntegrationDefinitions(
                                        record : get_integration_definitions.recordcount,
                                        evoucher_test_system : evoucher_test_system,
                                        evoucher_company_code : attributes.evoucher_company_code,
                                        evoucher_username : attributes.evoucher_user_name,
                                        evoucher_password : attributes.evoucher_password,
                                        evoucher_template: '#iif(isdefined("attributes.evoucher_template"),"attributes.evoucher_template",DE(""))#',
                                        del_template:'#iif(isdefined("attributes.del_template"),"attributes.del_template",DE(""))#',
                                        save_folder:'#iif(isdefined("attributes.save_folder"),"attributes.save_folder",DE(""))#',
                                        evoucher_live_url : '#attributes.evoucher_live_url#',
                                        evoucher_test_url : '#attributes.evoucher_test_url#',
                                        is_active : is_active,
                                        evoucher_date : "#attributes.evoucher_date#"
           );
        </cfscript>
    
        <cfif addIntegrationDefinitions>
            <cfset soap = createObject("Component","V16.e_government.cfc.emeslekmakbuzu.soap")>
            <cfset soap.init() />
            <cfset getAuthorization = soap.GetFormsAuthentication()>
    
            <cfif not len(getAuthorization)>
                <script type="text/javascript">
                    alert("Dijital Planet Kullanıcı Bilgilerinizi Kontrol Ediniz. Ticket Alınamadı! ");
                </script>
            </cfif>
    
        </cfif>
    
    <script type="text/javascript">
        window.location.href = '<cfoutput>#request.self#?fuseaction=account.evoucher_integration_definitions</cfoutput>';
    </script>