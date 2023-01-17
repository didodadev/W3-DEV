<table width="98%" border="0" cellspacing="1" cellpadding="2" class="color-border" align="center">
	<tr class="color-list" height="22"> 
		<td class="txtboldblue">
			<a href="javascript://" onclick="gizle_goster_img('mail_img1','mail_img2','mail_menu');"><img src="/images/listele_down.gif" title="<cf_get_lang no='116.Ayrıntıları Gizle'>" width="12" height="7" border="0" align="absmiddle" id="mail_img1" style="display:;cursor:pointer;"></a>
			<a href="javascript://" onclick="gizle_goster_img('mail_img1','mail_img2','mail_menu');"><img src="/images/listele.gif" title="<cf_get_lang no='337.Ayrıntıları Göster'>" width="7" height="12" border="0" align="absmiddle" id="mail_img2" style="display:none;cursor:pointer;"></a>
			<cf_get_lang no='26.Maillerim'>
		</td>
	</tr>
	<tr class="color-row" id="mail_menu">
		<td>
		<table cellspacing="0" cellpadding="0" width="100%" border="0">
			<cfoutput>
			<tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
			</cfoutput>
				<td width="1%" align="left">*</td>
				<td width="97%" align="left">
					<a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=myhome.popup_list_inbox&module=myhome&type=1</cfoutput>','list');" clasS="tableyazi"><cf_get_lang no='138.Gelen Mail'></a>
				</td>
			</tr>
			<tr>
				<td width="1%" align="left">*</td>
				<td width="97%" align="left">
					<a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=myhome.popup_list_inbox&module=myhome&type=0</cfoutput>','list');" clasS="tableyazi"><cf_get_lang_main no='713.Giden Mail'></a>
				</td>
			</tr>
		</table>
		</td>
	</tr>
</table>
<br/>
