<table width="100%" border="0" cellpadding="2" cellspacing="1" height="100%" class="color-border">
	<cfform name="add_order_simple" method="post" action="#request.self#?fuseaction=member.popup_make_analysis&analysis_id=#attributes.analysis_id#" enctype="multipart/form-data">
		<input type="hidden" name="member_id" id="member_id" value="">
		<input type="hidden" name="member_type" id="member_type" value="">
		<tr class="color-list">
			<td class="headbold" height="35">&nbsp;<cf_get_lang dictionary_id='57560.Analiz'></td>
		</tr>
		<tr class="color-row">
			<td valign="top">
				<table>
					<tr>
						<td colspan="2"><cf_get_lang dictionary_id='30189.Analiz Edilecek Kişi veya Kurumu Seçiniz'></td>
					</tr>
					<tr>
						<td><input type="text" name="company" id="company" style="width:150px;" value="" readonly></td>
						<td><cfsavecontent variable="message"><cf_get_lang dictionary_id='57785.Üye Seçmediniz'></cfsavecontent>
							<cfinput type="Text" name="member_name" style="width:150px;" value="" required="yes" message="#message#" passthrough="readonly">
							<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&select_list=7,8&field_id=add_order_simple.member_id&field_comp_name=add_order_simple.company&field_name=add_order_simple.member_name&field_type=add_order_simple.member_type','list','popup_list_pars');"><img src="/images/plus_list.gif" align="absmiddle" border="0"></a>
						</td>
					</tr>
					<tr height="30">
						<td>&nbsp;</td>
						<cfsavecontent variable="message"><cf_get_lang dictionary_id ='58126.Devam'></cfsavecontent>
						<td><cf_workcube_buttons is_upd='0' insert_info='#message#' insert_alert=''></td>
					</tr>
				</table>
			</td>
		</tr>
	</cfform>
</table>
