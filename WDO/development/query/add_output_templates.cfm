<cfset getComponent = createObject('component','WDO.development.cfc.output_template')>
<cfset MAX_ID = getComponent.insert_output_template(
    output_template_name : '#iif(isdefined("attributes.output_template_name"),"attributes.output_template_name",DE(""))#',
    output_template_patent : '#iif(isdefined("attributes.output_template_patent"),"attributes.output_template_patent",DE(""))#',
    active : '#iif(isdefined("attributes.active"),"attributes.active",DE(""))#',
    bp_code : '#iif(isdefined("attributes.bp_code"),"attributes.bp_code",DE(""))#',
    output_template_detail : '#iif(isdefined("attributes.output_template_detail"),"attributes.output_template_detail",DE(""))#',
    product_id : '#iif(isdefined("attributes.product_id"),"attributes.product_id",DE(""))#',
    licence : '#iif(isdefined("attributes.licence"),"attributes.licence",DE(""))#',
    related_wo : '#iif(isdefined("attributes.related_wo"),"attributes.related_wo",DE(""))#',
    author_partner_id : '#iif(isdefined("attributes.author_partner_id"),"attributes.author_partner_id",DE(""))#',
    author : '#iif(isdefined("attributes.author"),"attributes.author",DE(""))#',
    view_path : '#iif(isdefined("attributes.view_path"),"attributes.view_path",DE(""))#',
    related_sectors : '#iif(isdefined("attributes.related_sectors"),"attributes.related_sectors",DE(""))#',
    process_stage : '#iif(isdefined("attributes.process_stage"),"attributes.process_stage",DE(""))#',
    version : '#iif(isdefined("attributes.version"),"attributes.version",DE(""))#',
    print_type : '#iif(isdefined("attributes.print_type"),"attributes.print_type",DE(""))#',
    template_path : '#iif(isdefined("attributes.template_path"),"attributes.template_path",DE(""))#',
    use_logo: '#iif(isdefined("attributes.use_logo"),"attributes.use_logo",DE(""))#',
    use_adress: '#iif(isdefined("attributes.use_adress"),"attributes.use_adress",DE(""))#',
    page_width: '#iif(isdefined("attributes.page_width"),"attributes.page_width",DE(""))#',
    page_height: '#iif(isdefined("attributes.page_height"),"attributes.page_height",DE(""))#',
    page_margin_left: '#iif(isdefined("attributes.page_margin_left"),"attributes.page_margin_left",DE(""))#',
    page_margin_right: '#iif(isdefined("attributes.page_margin_right"),"attributes.page_margin_right",DE(""))#',
    Page_margin_top: '#iif(isdefined("attributes.Page_margin_top"),"attributes.Page_margin_top",DE(""))#',
    page_margin_bottom: '#iif(isdefined("attributes.page_margin_bottom"),"attributes.page_margin_bottom",DE(""))#',
    page_header_height: '#iif(isdefined("attributes.page_header_height"),"attributes.page_header_height",DE(""))#',
    page_footer_height: '#iif(isdefined("attributes.page_footer_height"),"attributes.page_footer_height",DE(""))#',
    rule_unit: '#iif(isdefined("attributes.rule_unit"),"attributes.rule_unit",DE(""))#',
    logo_width: '#iif(isdefined("attributes.page_width"),"attributes.logo_width",DE(""))#',
    logo_height: '#iif(isdefined("attributes.page_height"),"attributes.logo_height",DE(""))#',
    schema_markup: '#iif(isdefined("attributes.schema_markup"),"attributes.schema_markup",DE(""))#',
    dictionary_id: '#iif(isdefined("attributes.dictionary_id"),"attributes.dictionary_id",DE(""))#'
)>            
<cfquery name="GET_MAXID" datasource="#DSN#">
    SELECT MAX(WRK_output_template_ID) AS MAX_ID FROM WRK_OUTPUT_TEMPLATES
</cfquery>
<script>
    window.location.href = "<cfoutput>#request.self#?fuseaction=dev.output_templates&event=upd&id=#GET_MAXID.MAX_ID#</cfoutput>";
</script>   