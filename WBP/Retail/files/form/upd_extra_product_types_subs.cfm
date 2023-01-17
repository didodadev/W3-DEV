<cfquery name="get_types" datasource="#dsn_dev#">
	SELECT * FROM EXTRA_PRODUCT_TYPES ORDER BY TYPE_NAME
</cfquery>
<cfquery name="get_def" datasource="#dsn_dev#">
	SELECT * FROM EXTRA_PRODUCT_TYPES_SUBS WHERE SUB_TYPE_ID = #attributes.sub_type_id#
</cfquery>
<cf_popup_box title="Ürün Ektra Tanımları Güncelle (Alt Tanımlar)">
<cfform name="add_form" action="">
<cfinput type="hidden" name="sub_type_id" value="#attributes.sub_type_id#">
	<table>
    	<tr>
        	<td>Kriter</td>
            <td>
            	<cfselect name="type_id" required="yes" message="Kriter Seçmelisiniz!">
                    <option value="">Seçiniz</option>
                    <cfoutput query="get_types">
                    <option value="#type_id#" <cfif get_def.type_id eq type_id>selected</cfif>>#type_name#</option>
                    </cfoutput>
                </cfselect>
            </td>
        </tr>
        <tr>
        	<td>Alt Tanım</td>
            <td>
            	<cfinput type="text" name="sub_type_name" required="yes" value="#get_def.sub_type_name#" message="Alt Tanım Girmelisiniz!" maxlength="100" style="width:200px;">
            </td>
        </tr>
    </table>
    <cf_popup_box_footer>
    	<cf_record_info query_name="get_def">
        <cf_workcube_buttons is_upd="1" delete_page_url="#request.self#?fuseaction=retail.emptypopup_del_extra_product_types_subs&sub_type_id=#attributes.sub_type_id#">
    </cf_popup_box_footer>
</cfform>
</cf_popup_box>