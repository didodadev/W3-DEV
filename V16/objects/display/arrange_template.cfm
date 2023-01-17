<cfinclude template="../query/get_templates.cfm">
<cfsavecontent variable="message"><cf_get_lang dictionary_id='32515.Ek Form'></cfsavecontent>
<cf_popup_box title="#message# : #get_templates.template_head#">
<cfform action="#request.self#?fuseaction=objects.emptypopup_add_template#page_code#" method="post" name="template_form">
    <input type="hidden" name="assetcat_id" id="assetcat_id" value="<cfoutput>#attributes.assetcat_id#</cfoutput>">
    <input type="hidden" name="module" id="module" value="<cfoutput>#attributes.module#</cfoutput>">
    <input type="hidden" name="template_id" id="template_id" value="<cfoutput>#attributes.template_id#</cfoutput>">
    <table>
        <tr>
            <td><input type="text" name="template_head" id="template_head" value="<cfoutput>#get_templates.template_head#</cfoutput>" style="width:500;"></td>
        </tr>
        <tr>
            <td valign="top">
                <cfmodule
                template="/fckeditor/fckeditor.cfm"
                toolbarSet="WRKContent"
                basePath="/fckeditor/"
                instanceName="content"
                valign="top"
                value="#get_templates.TEMPLATE_CONTENT#"
                width="700"
                height="380">					 
            </td>
        </tr>
    </table>
	<cfoutput>
    <cf_popup_box_footer>
    	<table style="text-align:right;" style="height:30px;">
        	<tr>
				<td style="vertical-align:top"><input type="button" name="print" id="print" value="<cf_get_lang dictionary_id='57474.Yazdır'>" onClick="windowopen('#request.self#?fuseaction=objects.popup_print_editor&editor_name=template_form.content&module=content&title1=&title2=&iframe=1','list');"></td>
            	<td style="vertical-align:top; width:160px;"><cf_workcube_buttons is_upd='0'></td>
            </tr>
        </table>
    </cf_popup_box_footer>
	</cfoutput>
</cfform>
</cf_popup_box>
