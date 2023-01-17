<cfset getComponent = createObject('component','WDO.development.cfc.extensions')>
<cfif isdefined("attributes.is_add_comp") and attributes.is_add_comp eq 1>
    <cfset comp = getComponent.insert_component(
    extension_id : '#attributes.extension_id#',
    number : '#iif(isdefined("attributes.number"),"attributes.number",DE(""))#',
    component_name : '#iif(isdefined("attributes.component_name"),"attributes.component_name",DE(""))#',
    file_path : '#iif(isdefined("attributes.file_path"),"attributes.file_path",DE(""))#',
    place : '#iif(isdefined("attributes.place"),"attributes.place",0)#',
    action : '#iif(isdefined("attributes.action"),"attributes.action",0)#',
    is_active : '#iif(isdefined("attributes.is_active"),"attributes.is_active",DE(""))#',
    is_add : '#iif(isdefined("attributes.is_add"),"attributes.is_add",DE(""))#',
    is_upd : '#iif(isdefined("attributes.is_upd"),"attributes.is_upd",DE(""))#',
    is_det : '#iif(isdefined("attributes.is_det"),"attributes.is_det",DE(""))#',
    is_list : '#iif(isdefined("attributes.is_list"),"attributes.is_list",DE(""))#',
    is_dash : '#iif(isdefined("attributes.is_dash"),"attributes.is_dash",DE(""))#',
    is_info : '#iif(isdefined("attributes.is_info"),"attributes.is_info",DE(""))#',
    is_del : '#iif(isdefined("attributes.is_del"),"attributes.is_del",DE(""))#',
    component_detail : '#iif(isdefined("attributes.component_detail"),"attributes.component_detail",DE(""))#'

    )>
<cfelseif isdefined("attributes.is_del_comp") and len(attributes.is_del_comp)>
    <cfset comp = getComponent.del_component(
        component_id : '#attributes.component_id#'
    )>
<cfelseif isdefined("attributes.is_upd_comp") and attributes.is_upd_comp eq 1>
    <cfset comp = getComponent.upd_component(
        component_id : '#attributes.component_id#',
        number : '#iif(isdefined("attributes.number"),"attributes.number",DE(""))#',
        component_name : '#iif(isdefined("attributes.component_name"),"attributes.component_name",DE(""))#',
        file_path : '#iif(isdefined("attributes.file_path"),"attributes.file_path",DE(""))#',
        place : '#iif(isdefined("attributes.place"),"attributes.place",0)#',
        action : '#iif(isdefined("attributes.action"),"attributes.action",0)#',
        is_active : '#iif(isdefined("attributes.is_active"),"attributes.is_active",DE(""))#',
        is_add : '#iif(isdefined("attributes.is_add"),"attributes.is_add",DE(""))#',
        is_upd : '#iif(isdefined("attributes.is_upd"),"attributes.is_upd",DE(""))#',
        is_det : '#iif(isdefined("attributes.is_det"),"attributes.is_det",DE(""))#',
        is_list : '#iif(isdefined("attributes.is_list"),"attributes.is_list",DE(""))#',
        is_dash : '#iif(isdefined("attributes.is_dash"),"attributes.is_dash",DE(""))#',
        is_info : '#iif(isdefined("attributes.is_info"),"attributes.is_info",DE(""))#',
        is_del : '#iif(isdefined("attributes.is_del"),"attributes.is_del",DE(""))#',
        component_detail : '#iif(isdefined("attributes.component_detail"),"attributes.component_detail",DE(""))#'
    
        )>
<cfelseif isdefined("attributes.all_del") and attributes.all_del eq 1>
    <cfset comp = getComponent.all_del_component(
        extension_id : '#attributes.extension_id#'
    )>
    <script>
        location.href="<cfoutput>#request.self#?fuseaction=dev.extensions</cfoutput>";
    </script>
<cfelse>
    <cfset comp = getComponent.upd_extension(
    extension_id : '#attributes.id#',
    extension_name : '#iif(isdefined("attributes.extension_name"),"attributes.extension_name",DE(""))#',
    active : '#iif(isdefined("attributes.active"),"attributes.active",DE(""))#',
    bp_code : '#iif(isdefined("attributes.bp_code"),"attributes.bp_code",DE(""))#',
    extension_detail : '#iif(isdefined("attributes.extension_detail"),"attributes.extension_detail",DE(""))#',
    product_id : '#iif(isdefined("attributes.product_id"),"attributes.product_id",DE(""))#',
    licence : '#iif(isdefined("attributes.licence"),"attributes.licence",DE(""))#',
    related_wo : '#iif(isdefined("attributes.related_wo"),"attributes.related_wo",DE(""))#',
    author_partner_id : '#iif(isdefined("attributes.author_partner_id"),"attributes.author_partner_id",DE(""))#',
    author : '#iif(isdefined("attributes.author"),"attributes.author",DE(""))#',
    icon_path : '#iif(isdefined("attributes.icon_path"),"attributes.icon_path",DE(""))#',
    related_sectors : '#iif(isdefined("attributes.related_sectors"),"attributes.related_sectors",DE(""))#',
    process_stage : '#iif(isdefined("attributes.process_stage"),"attributes.process_stage",DE(""))#',
    version : '#iif(isdefined("attributes.version"),"attributes.version",DE(""))#'

    )>
</cfif>
<script>
    location.href=document.referrer;
</script>


