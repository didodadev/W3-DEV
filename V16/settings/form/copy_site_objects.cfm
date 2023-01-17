<!--- Site Objelerini Kopyalama 20120213 --->
<cfquery name="get_main_menu" datasource="#dsn#">
	SELECT MENU_NAME, MENU_ID FROM MAIN_MENU_SETTINGS WHERE MENU_ID NOT IN (SELECT MENU_ID FROM MAIN_SITE_LAYOUTS WHERE FACTION = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.faction#">)
</cfquery>
<table cellspacing="1" cellpadding="2" width="100%" class="color-border" align="center" height="100%">
	<tr class="color-list">
		<td height="35">
        <table width="100%">
            <tr>
                <td class="headbold">Sayfa Kopyala</td>
            </tr>
        </table>
		</td>
	</tr>
	<tr class="color-row">
		<td valign="top">
        <table>
            <cfform action="#request.self#?fuseaction=settings.emptypopup_copy_site_objects" name="add_main_" method="post">
				<input type="hidden" name="faction" id="faction" value="<cfoutput>#attributes.faction#</cfoutput>">
				<input type="hidden" name="old_menu_id" id="old_menu_id" value="<cfoutput>#attributes.old_menu_id#</cfoutput>">
				<input type="hidden" name="is_add" id="" value="1">
				<tr>
					<td><cf_get_lang no='891.Menu'> *</td>
					<td>
						<select name="menu_id" id="menu_id" style="width:200px;">
						<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
						<cfoutput query="get_main_menu">
							<option value="#menu_id#">#menu_name#</option>
						</cfoutput>
						</select>
					</td>
				</tr>
				<tr>
					<td colspan="2" style="text-align:right;"><cf_workcube_buttons is_upd="0" add_function='kontrol()'></td>
            	</tr>
            </cfform>
        </table>
		</td>
	</tr>
</table>
<script type="text/javascript">
function kontrol()
{
	if(document.add_main_.menu_id.value == '')
	{
		alert("<cf_get_lang no ='1991.Menu Seçiniz'> !");
		return false;
	} 
}
</script>

