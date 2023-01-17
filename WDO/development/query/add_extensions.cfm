<cfset getComponent = createObject('component','WDO.development.cfc.extensions')>



<cfset MAX_ID = getComponent.insert_extension(
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
            
	<cfquery name="GET_MAXID" datasource="#DSN#">
        SELECT MAX(WRK_EXTENSION_ID) AS MAX_ID FROM WRK_EXTENSIONS
    </cfquery>

<script>
    window.location.href = "<cfoutput>#request.self#?fuseaction=dev.extensions&event=upd&id=#GET_MAXID.MAX_ID#</cfoutput>";
</script>
   

