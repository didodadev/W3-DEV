<cf_date tarih = 'attributes.eproducer_date'>
    <cfscript>
        eproducer = createObject("Component","V16.e_government.cfc.emustahsil.common");
        eproducer.dsn = dsn;
        eproducer.dsn2 = dsn2;
        
        get_integration_definitions = eproducer.get_our_company_fnc(session.ep.company_id);
    
        if(isdefined('attributes.eproducer_test_system')) eproducer_test_system = 1; else eproducer_test_system = 0;
        if(isdefined('attributes.is_active')) is_active = 1; else is_active = 0;

        addIntegrationDefinitions = eproducer.addIntegrationDefinitions(
                                        record : get_integration_definitions.recordcount,
                                        eproducer_test_system : eproducer_test_system,
                                        eproducer_company_code : attributes.eproducer_company_code,
                                        eproducer_username : attributes.eproducer_user_name,
                                        eproducer_password : attributes.eproducer_password,
                                        eproducer_template: '#iif(isdefined("attributes.eproducer_template"),"attributes.eproducer_template",DE(""))#',
                                        del_template:'#iif(isdefined("attributes.del_template"),"attributes.del_template",DE(""))#',
                                        save_folder:'#iif(isdefined("attributes.save_folder"),"attributes.save_folder",DE(""))#',
                                        eproducer_live_url : '#attributes.eproducer_live_url#',
                                        eproducer_test_url : '#attributes.eproducer_test_url#',
                                        is_active : is_active,
                                        eproducer_date : "#attributes.eproducer_date#"
           );
        </cfscript>
    
        <cfif addIntegrationDefinitions>
            <cfset soap = createObject("Component","V16.e_government.cfc.emustahsil.soap")>
            <cfset soap.init() />
            <cfset getAuthorization = soap.GetFormsAuthentication()>
    
            <cfif not len(getAuthorization)>
                <script type="text/javascript">
                    alert("Dijital Planet Kullanıcı Bilgilerinizi Kontrol Ediniz. Ticket Alınamadı! ");
                </script>
            </cfif>
    
        </cfif>
    
    <script type="text/javascript">
        window.location.href = '<cfoutput>#request.self#?fuseaction=account.eproducerreceipt_integration_definitions</cfoutput>';
    </script>