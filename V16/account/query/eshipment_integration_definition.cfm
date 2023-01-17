<cf_date tarih = 'attributes.eshipment_date'>
<cfscript>
	eshipment = createObject("Component","V16.e_government.cfc.eirsaliye.common");
	eshipment.dsn = dsn;
    eshipment.dsn2 = dsn2;
    
    get_integration_definitions = eshipment.get_our_company_fnc(session.ep.company_id);

    if(isdefined('attributes.eshipment_test_system')) eshipment_test_system = 1; else eshipment_test_system = 0;
    if(isdefined('attributes.multiple_prefix')) multiple_prefix = 1; else multiple_prefix = 0;
    if(isdefined('attributes.is_active')) is_active = 1; else is_active = 0;
    if(isdefined('attributes.is_receiving_process')) is_receiving_process = 1; else is_receiving_process = 0;
    if(isdefined('attributes.special_period')) special_period = 1; else special_period = 0;

    addIntegrationDefinitions = eshipment.addIntegrationDefinitions(
                                    record : get_integration_definitions.recordcount,
                                    eshipment_test_system : eshipment_test_system,
                                    eshipment_signature_url : '#iif(isdefined("attributes.eshipment_signature_url"),"attributes.eshipment_signature_url",DE(""))#',
                                    eshipment_company_code : attributes.eshipment_company_code,
                                    eshipment_username : attributes.eshipment_user_name,
                                    eshipment_password : attributes.eshipment_password,
                                    eshipment_prefix : attributes.eshipment_prefix,
                                    eshipment_number : attributes.eshipment_number,
                                    eshipment_template: '#iif(isdefined("attributes.eshipment_template"),"attributes.eshipment_template",DE(""))#',
                                    del_template:'#iif(isdefined("attributes.del_template"),"attributes.del_template",DE(""))#',
                                    save_folder:'#iif(isdefined("attributes.save_folder"),"attributes.save_folder",DE(""))#',
                                    multiple_prefix: multiple_prefix,
                                    is_receiving_process : is_receiving_process,
                                    ubl_version :'#listfirst(attributes.eshipment_ublversion,';')#',
                                    customization_id : '#listlast(attributes.eshipment_ublversion,';')#',
                                    special_period : special_period,
                                    eshipment_live_url : '#attributes.eshipment_live_url#',
                                    eshipment_test_url : '#attributes.eshipment_test_url#',
                                    is_active : is_active,
                                    eshipment_date : "#attributes.eshipment_date#",
                                    eshipment_type_alias : '#attributes.eshipment_type#'
       );
    </cfscript>

    <cfif addIntegrationDefinitions and attributes.eshipment_type eq 'dp'>
        <cfset soap = createObject("Component","V16.e_government.cfc.eirsaliye.soap")>
        <cfset soap.init() />
        <cfset getAuthorization = soap.GetFormsAuthentication()>

        <cfif not len(getAuthorization)>
            <script type="text/javascript">
                alert("Dijital Planet Kullanıcı Bilgilerinizi Kontrol Ediniz. Ticket Alınamadı! ");
            </script>
        </cfif>

    </cfif>

<script type="text/javascript">
	window.location.href = '<cfoutput>#request.self#?fuseaction=account.eshipment_integration_definitions</cfoutput>';
</script>