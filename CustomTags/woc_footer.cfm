<cfset getPrintTemplate = createObject("component","cfc.get_print_template")>
<cfset get_templates_css = getPrintTemplate.get_template( template_id : caller.attributes.template_id )>
<cfset check = getPrintTemplate.check(our_company_id : iif(isdefined('caller.attributes.our_company_id'),'caller.attributes.our_company_id',DE('')))>
<tfoot>
    <cfif get_templates_css.use_adress eq 1>
        <tr class="fixed top_border print_footer" id="print_footer">
            <cfoutput query="check">
                <td><b>© Copyright</b> #COMPANY_NAME# dışında kullanılamaz, paylaşılamaz.<br>#COMPANY_NAME#<br>#ADDRESS#<br>Web Sitesi: #WEB#<br>Vergi Dairesi: #TAX_OFFICE#<br>VKN: #TAX_NO#</td>
            </cfoutput>
        </tr>
    </cfif>
</tfoot>
<cfif caller.attributes.fuseaction eq 'objects.popup_print_designer'>
    <script type="text/javascript">
        $( "#print_footer" ).draggable();
    </script>
</cfif>