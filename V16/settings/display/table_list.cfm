			<table width="100%" border="0" cellspacing="1" cellpadding="5" bgcolor="#000000">
			 <tr  class="color-header">
			  <td class="form-title" width="62%"><cf_get_lang no='1587.Tablo'></td>
			  <td class="form-title" width="10%"><cf_get_lang no='1318.Sahibi'></td>
			  <td class="form-title" width="10%"><cf_get_lang no='1627.Tipi'></td>
			  <td class="form-title" width="18%"><cf_get_lang no='1610.Yaratılma Tarihi'></td>
			 </tr>
			<cfoutput query="table_list">
			 <tr onMouseOver="this.bgColor='ffff33';" onMouseOut="this.bgColor='F1F0FF';" bgcolor="F1F0FF">
			  <td><a href="#request.self#?fuseaction=settings.db_admin&action_type=column_list&database_name=#attributes.database_name#&table_id=#id#&currow=#attributes.currow#&table_name=#NAME#">#NAME#</a></td>
			  <td>#OWNER_NAME#</td>
			  <td>#ReplaceList(xtype,"S,U","System,User")#</td>
			  <td>#DateFormat(crdate,dateformat_style)# #TimeFormat(crdate,"HH:mm:ss")#</td>
			 </tr>
			</cfoutput>
			</table>
