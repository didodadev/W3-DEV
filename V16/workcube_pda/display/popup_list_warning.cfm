<cfinclude template="../query/get_warnings.cfm">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.pda.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<table cellpadding="0" cellspacing="0" border="0" style="width:58mm;">
	<cfoutput>
		<tr class="color-row" height="25">
			<td >
			<a href="#request.self#?fuseaction=pda.list_warnings" class="txtsubmenu"><b>Uyarilarim</b></a> :
			<a href="#request.self#?fuseaction=pda.popup_form_add_warning" class="txtsubmenu">Uyari Ekle</a> :
			<td>&nbsp;</td>
			</td>
		</tr>
	</cfoutput>
</table>
<table cellpadding="2" cellspacing="1" border="0">
	<tr class="color-border">
		<td width="20">No</td>
		<td>Uyari</td>
		<td>Tarih</td>
	</tr>
	<cfoutput query="get_warnings">
		<tr>
			<td width="20">#currentrow# -</td>
			<td width="110"><a href="#request.self#?fuseaction=pda.popup_form_upd_warning&w_id=#get_warnings.w_id#" class="txtsubmenu">#get_warnings.warning_head#</a></td>
			<td>#dateformat(get_warnings.record_date,'dd/mm/yyyy')#</td>
		</tr>
	</cfoutput>
</table>

