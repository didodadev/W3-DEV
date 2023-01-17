<cfset getComponent = createObject('component','WDO.development.cfc.process_template')>



<cfset MAX_ID = getComponent.insert_process_template(
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
            
	<cfquery name="GET_MAXID" datasource="#DSN#">
        SELECT MAX(WRK_PROCESS_template_ID) AS MAX_ID FROM WRK_PROCESS_TEMPLATES
    </cfquery>

<script>
    window.location.href = "<cfoutput>#request.self#?fuseaction=dev.process_templates&event=upd&id=#GET_MAXID.MAX_ID#</cfoutput>";
</script>
   