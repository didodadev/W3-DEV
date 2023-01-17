<table width="98%" height="35" border="0" align="center" cellpadding="0" cellspacing="0" >
	<tr>
		<td class="headbold">Envanter Talep Nedenleri Parametreleri</td>
	</tr>
</table>
<table width="98%" border="0" align="center" cellpadding="2" cellspacing="1" class="color-border">
	<tr class="color-row">
		<td width="200" valign="top"><cfinclude template="../display/list_inventory_demand_reason.cfm"></td>
		<td valign="top">
		<table>
			<cfform name="reason" action="#request.self#?fuseaction=settings.emptypopup_add_inventory_demand_reason" method="post">
				<tr>
					<td width="100"><cf_get_lang_main no='81.Aktif'></td>
					<td>	
                    	<input name="active" id="active" type="checkbox" value="1">
					</td>
				</tr>
				<tr>
					<td width="100">Talep Nedeni *</td>
					<td><cfsavecontent variable="message"><cf_get_lang_main no='324.Başlık girmelisiniz'></cfsavecontent>
						<cfinput type="Text" name="demand_reason" id="demand_reason" size="20" value="" maxlength="100" required="Yes" message="#message#" style="width:175px;">
					</td>
				</tr>
				<tr height="35">
					<td>&nbsp;</td>
					<td><cf_workcube_buttons is_upd='0' add_function="check()"></td>
				</tr>
			</cfform>
		</table>
		</td>
	</tr>
</table>
<script type="text/javascript">
function check()
{	
	if(document.reason.demand_reason.value == '')
		{
			alert("Talep Nedeni Giriniz.");
		}
}
</script>
