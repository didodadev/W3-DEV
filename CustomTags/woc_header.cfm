<cfset getPrintTemplate = createObject("component","cfc.get_print_template")>
<cfset get_templates_css = getPrintTemplate.get_template( template_id : caller.attributes.template_id )>
<cfparam name="title" default="">
<cfset check = getPrintTemplate.check(our_company_id : iif(isdefined('caller.attributes.our_company_id'),'caller.attributes.our_company_id',DE('')))>
<thead>
    <tr class="bottom_border print_header" id="print_header"> 
        <td class="print_title"><cfoutput><cfif isDefined('attributes.title') and len(attributes.title)>#attributes.title#<cfelseif len(get_templates_css.dictionary_id)><cf_get_lang dictionary_id='#get_templates_css.dictionary_id#'><cfelse>#get_templates_css.WRK_OUTPUT_TEMPLATE_NAME#</cfif></cfoutput></td>
        <td class="text-right">
            <cfif len(check.asset_file_name2) and get_templates_css.use_logo EQ 1>
                <cfset attributes.type = 1>
                <cf_get_server_file output_file="/settings/#check.asset_file_name2#" output_server="#check.asset_file_name2_server_id#" output_type="5" image_width="#get_templates_css.LOGO_WIDTH#" image_height="#get_templates_css.LOGO_HEIGHT#">
            </cfif>
        </td>        
    </tr>
</thead>
<cfif caller.attributes.fuseaction eq 'objects.popup_print_designer'>
    <script type="text/javascript">
        $( "#print_header" ).draggable();
    </script>
</cfif>