<cfquery name="get_menu_css_path" datasource="#dsn#">
	SELECT CSS_FILE FROM MAIN_MENU_SETTINGS WHERE MENU_ID = #attributes.menu_id#
</cfquery>
<cffile action="read" file="#index_folder##replace(get_menu_css_path.css_file,'/','\','all')#" variable="dosya">
<cfform action="#request.self#?fuseaction=settings.emptypopup_add_css_property&menu_id=#attributes.menu_id#" method="post">
	<table width="100%">
		<tr>
			<td><textarea style="width:98%;" rows="30" name="dosya" id="dosya"><cfoutput>#dosya#</cfoutput></textarea></td>
		</tr>
		<tr>
			<td><cf_workcube_buttons is_upd='0'></td>
		</tr>
	</table>
</cfform>

