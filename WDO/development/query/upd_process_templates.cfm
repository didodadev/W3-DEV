<cfset getComponent = createObject('component','WDO.development.cfc.process_template')>

<cfif isdefined("attributes.is_del") and attributes.is_del eq 1>
    <cfset comp = getComponent.del_process_template(
        process_template_id : '#attributes.process_template_id#'
    )>
    <script>
        location.href="<cfoutput>#request.self#?fuseaction=dev.process_templates</cfoutput>";
    </script>
<cfelse>
    <cfset comp = getComponent.upd_process_template(
    process_template_id : '#attributes.id#',
    process_template_name : '#iif(isdefined("attributes.process_template_name"),"attributes.process_template_name",DE(""))#',
    active : '#iif(isdefined("attributes.active"),"attributes.active",DE(""))#',
    bp_code : '#iif(isdefined("attributes.bp_code"),"attributes.bp_code",DE(""))#',
    process_template_detail : '#iif(isdefined("attributes.process_template_detail"),"attributes.process_template_detail",DE(""))#',
    product_id : '#iif(isdefined("attributes.product_id"),"attributes.product_id",DE(""))#',
    licence : '#iif(isdefined("attributes.licence"),"attributes.licence",DE(""))#',
    related_wo : '#iif(isdefined("attributes.related_wo"),"attributes.related_wo",DE(""))#',
    author_partner_id : '#iif(isdefined("attributes.author_partner_id"),"attributes.author_partner_id",DE(""))#',
    author : '#iif(isdefined("attributes.author"),"attributes.author",DE(""))#',
    icon_path : '#iif(isdefined("attributes.icon_path"),"attributes.icon_path",DE(""))#',
    related_sectors : '#iif(isdefined("attributes.related_sectors"),"attributes.related_sectors",DE(""))#',
    process_stage : '#iif(isdefined("attributes.process_stage"),"attributes.process_stage",DE(""))#',
    version : '#iif(isdefined("attributes.version"),"attributes.version",DE(""))#',
    template_path : '#iif(isdefined("attributes.template_path"),"attributes.template_path",DE(""))#',
    main : '#iif(isdefined("attributes.main"),"attributes.main",DE(""))#',
    stage : '#iif(isdefined("attributes.stage"),"attributes.stage",DE(""))#',
    display : '#iif(isdefined("attributes.display"),"attributes.display",DE(""))#',
    action : '#iif(isdefined("attributes.action"),"attributes.action",DE(""))#',
    module : '#iif(isdefined("attributes.module"),"attributes.module",DE(""))#'

    )>
</cfif>
<script>
    location.href=document.referrer;
</script>


