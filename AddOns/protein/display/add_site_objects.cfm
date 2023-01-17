<cfquery name="get_main_menu" datasource="#dsn#">
	SELECT MENU_NAME, MENU_ID FROM MAIN_MENU_SETTINGS ORDER BY MENU_NAME
</cfquery>

<table cellspacing="1" cellpadding="2" width="100%" class="color-border" align="center" height="100%">
	<tr class="color-list">
		<td height="35">
        <table width="100%">
            <tr>
                <td class="headbold"><cfoutput>#getLang('settings',1456)#</cfoutput></td>
            </tr>
        </table>
		</td>
	</tr>
	<tr class="color-row">
		<td valign="top">
        <table>
            <cfform action="#request.self#?fuseaction=protein.emptypopup_add_site_layout" name="add_main_" method="post">
            <input type="hidden" name="is_add" id="is_add" value="1">
            <tr>
                <td><cfoutput>#getLang('settings',891)#  </cfoutput>*</td>
                <td colspan="4">
                    <select name="menu_id" id="menu_id" style="width:200px;">
                    <option value=""><cfoutput>#getLang('main',322)#</cfoutput></option>
                    <cfoutput query="get_main_menu">
                        <option value="#menu_id#">#menu_name#</option>
                    </cfoutput>
                    </select>
                </td>
            </tr>
            <tr>
                <td><cfoutput>#getLang('settings',159)# </cfoutput>*</td>                
                <td colspan="6">
                	<cfsavecontent variable="message">#getLang('settings',1986)#></cfsavecontent>
                	<cfinput name="faction" type="text" value="" style="width:200px;" required="yes" message="#message#">
                    <cfoutput><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=protein.popup_list_select_switch&selected_link=add_main_.faction&is_faction=1','list');"><img src="/images/plus_thin.gif" border="0" align="absmiddle"></a></cfoutput>
                </td>
			</tr>
			<tr>
			    <td><cfoutput>#getLang('main',169)# #getLang('main',1408)#</cfoutput></td>   
				<td colspan="6">
					<cfinput name="header" type="text" value="" style="width:200px;" required="yes" message="#message#">
				</td>
			</tr>
            <tr>
                <td colspan="7" align="right" style="text-align:right;"><cf_workcube_buttons is_upd="0" add_function='kontrol()'></td>
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
