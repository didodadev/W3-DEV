<cfsetting showdebugoutput="no">
<cfquery name="getHobim" datasource="#dsn2#">
	SELECT
        FE.FILE_NAME,
        FE.FILE_STAGE,
        FE.RECORD_DATE,
        FE.RECORD_EMP,
        FE.E_ID
    FROM
        FILE_EXPORTS FE
    WHERE 
    	FE.E_ID = #attributes.hobim_id#
</cfquery>

<cfsavecontent variable="img_">
       <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_page_warnings&action=invoice.popup_form_export_hobim&action_name=hobim_id&action_id=#attributes.hobim_id#</cfoutput>','list');"><img src="/images/uyar.gif" title="<cf_get_lang_main no='345.Uyarılar'>" border="0"></a>
</cfsavecontent>
<cf_popup_box title="Hobim Dosyası" right_images="#img_#">
    <cfform name="export_hobim" id="export_hobim" method="post" action="#request.self#?fuseaction=invoice.emptypopup_form_export_hobim">
        <input type="hidden" name="hobim_id" id="hobim_id" value="<cfoutput>#attributes.hobim_id#</cfoutput>" />
        <table>
            <tr>
                <td><cf_get_lang dictionary_id="58859.Süreç">*</td>
                <td><cf_workcube_process is_upd='0' is_detail="1" select_value="#getHobim.file_stage#" process_cat_width='150'></td>
            </tr>
        </table>
        <cf_popup_box_footer>
            <cf_record_info query_name="getHobim" record_emp="record_emp">
            <cf_workcube_buttons type_format="1" is_upd='0'>
        </cf_popup_box_footer>
    </cfform>
</cf_popup_box>

