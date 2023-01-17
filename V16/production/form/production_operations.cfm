<!--- Üretim Duraklama Tipleri --->
<cfquery name="get_prod_pause_type" datasource="#dsn3#">
	SELECT DISTINCT
		SPPT.PROD_PAUSE_TYPE_ID,
		SPPT.PROD_PAUSE_TYPE
	FROM
		SETUP_PROD_PAUSE_TYPE SPPT,
		SETUP_PROD_PAUSE_TYPE_ROW SPPTR
	WHERE
		SPPT.PROD_PAUSE_TYPE_ID=SPPTR.PROD_PAUSE_TYPE_ID AND
		SPPTR.PROD_PAUSE_PRODUCTCAT_ID = #attributes.product_catid#
</cfquery>
<cfif attributes.is_oper_row eq 1><!--- operasyon sayfasına gidiyorsa --->
	<cfset fuseact_ = '#request.self#?fuseaction=production.emptypopup_ajax_add_p_order_operation_row'>
<cfelse>
	<cfset fuseact_ = '#request.self#?fuseaction=production.emptypopup_ajax_add_production_order_results'>
</cfif>
<cfsavecontent variable="message"><cf_get_lang dictionary_id='37910.Duraklama Nedeni'></cfsavecontent>
<cf_popup_box title="#message#">
<cfform name="prod_pause" method="post" action="#fuseact_#">
    <cfoutput>
        <input type="hidden" name="p_order_id" id="p_order_id" value="#attributes.p_order_id#">
        <input type="hidden" name="type" id="type" value="#attributes.type#">
        <input type="hidden" name="employee" id="employee" value="#attributes.employee#">
        <input type="hidden" name="asset_id" id="asset_id" value="#attributes.asset_id#">
        <input type="hidden" name="is_del" id="is_del" value="#attributes.is_del#">
        <input type="hidden" name="wrk_row_id" id="wrk_row_id" value="#attributes.wrk_row_id#">
        <input type="hidden" name="start_counter" id="start_counter" value="#attributes.start_counter#">
        <input type="hidden" name="finish_counter" id="finish_counter" value="#attributes.finish_counter#">
        <input type="hidden" name="no" id="no" value="#attributes.no#">
        <input type="hidden" name="amount" id="amount" value="#attributes.amount#">
        <input type="hidden" name="record_num" id="record_num" value="#attributes.record_num#">
    </cfoutput>
    <cfif attributes.is_oper_row eq 1>
        <cfoutput>
            <input type="hidden" name="wrk_row_relation_id" id="wrk_row_relation_id" value="#attributes.wrk_row_relation_id#">
            <input type="hidden" name="operation" id="operation" value="#attributes.operation#">
        </cfoutput>
    </cfif>
    <cfif isdefined("attributes.serial_no") and len(attributes.serial_no)>
        <input type="hidden" name="serial_no" id="serial_no" value="<cfoutput>#attributes.serial_no#</cfoutput>">
    </cfif>
        <table>
        <cfoutput query="get_prod_pause_type">
            <tr class="txtbold" nowrap="nowrap">
                <td style="font-size:18px">
                    <input type="Radio" size="20" name="pause_type" id="pause_type" value="#PROD_PAUSE_TYPE_ID#">&nbsp;#PROD_PAUSE_TYPE#
                </td>
            </tr>
        </cfoutput>
        </table>
        <cf_popup_box_footer>
			<cf_workcube_buttons is_upd='0'>
		</cf_popup_box_footer>
</cfform>
</cf_popup_box>
