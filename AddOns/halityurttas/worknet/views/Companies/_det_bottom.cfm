<cfsavecontent variable="message"><cf_get_lang_main no='1463.Çalışanlar'></cfsavecontent>
<cf_box
    id="list_company_partner"
    unload_body="1"
    closable="0"
    title="#message#"
    box_page="#request.self#?fuseaction=#WOStruct['#attributes.fuseaction#']['list-partner']['fuseaction']#&cpid=#attributes.cpid#&maxrows=#session.ep.maxrows#&is_active=#is_only_active_partners#">
</cf_box>
<cfsavecontent variable="message"><cf_get_lang no='54.Adresler/Şubeler'></cfsavecontent>
<cf_box
    id="detail_company_address_branch"
    unload_body="1"
    closable="0"
    title="#message#"
    box_page="#request.self#?fuseaction=#WOStruct['#attributes.fuseaction#']['list-branch']['fuseaction']#&cpid=#attributes.cpid#&maxrows=#session.ep.maxrows#">
</cf_box>
