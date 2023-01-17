<cfsavecontent variable="tilte"><cf_get_lang dictionary_id='57810.Ek Bilgi'></cfsavecontent>
<cf_popup_box title="#tilte#">
	<table width="100%" cellpadding="0" cellspacing="0" align="center">
		<tr>
			<td align="center">
			<cf_get_workcube_asset company_id="#session.ep.company_id#" asset_cat_id="-12" module_id='12' action_section='ORDER_ID' action_id='#attributes.order_id#' design_id='1'>
			<br/>
			</td>
		</tr>
		<tr>
			<td align="center">
			<cf_get_workcube_note company_id="#session.ep.company_id#" action_section='ORDER_ID' action_id='#attributes.order_id#' design_id='1'>
			</td>
		</tr>
	</table>
</cf_popup_box>
