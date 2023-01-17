<table width="200" cellpadding="2" cellspacing="0" border="0">
 <cfoutput query="connection_list">
 <cfset datasource_name = datasource>
 <tr>
  <td width="10" align="right" valign="baseline" style="text-align:right;"><img src="/images/db_connection<cfif isdefined("attributes.action_type") and (attributes.action_type is "table_list" or attributes.action_type is "column_list") or (isdefined("attributes.datasource_name") and datasource_name is attributes.datasource_name)>2</cfif>.gif" width="13"></td>
  <td align="180" width="100%"><a href="#request.self#?fuseaction=#attributes.fuseaction#&datasource_name=#datasource_name#">#CONNECTION_NAME#</a></td>
 </tr>
 <cfif isdefined("attributes.datasource_name") and attributes.datasource_name is datasource_name>
 <tr id="main_list" style="display">
  <td width="100%" align="left" colspan="2">
  
   <table width="100%" align="left" cellpadding="2" cellspacing="0" border="0">
	 <tr>
	  <td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/db_folder.gif" width="13"></td>
	  <td width="170" align="left"><a href="javascript://" onClick="show_hide_dbs('db_list');"><cf_get_lang no ='1126.Veritabanları'></a></td>
	 </tr>
	 <tr id="db_list"<cfif isdefined("attributes.action_type") and (attributes.action_type is "table_list" or attributes.action_type is "column_list")> style="display"<cfelse> style="display:none"</cfif>>
	  <td width="100%" align="left" colspan="2">
	  
	   <table width="100%" align="left" cellpadding="0" cellspacing="0" border="0">
		<cfloop query="database_list">
		 <tr>
		  <td width="25" align="right" valign="baseline" style="text-align:right;"><img src="/images/database<cfif isdefined("attributes.action_type") and (attributes.action_type is "table_list" or attributes.action_type is "column_list") and isdefined("attributes.currow") and currentrow is attributes.currow>2</cfif>.gif" width="13"></td>
		  <td width="165"><a href="javascript://" onClick="show_hide_dbs('database_opts_list_#currentrow#');">#NAME#</a></td>
		 </tr>
		 <tr id="database_opts_list_#currentrow#"<cfif isdefined("attributes.action_type") and (attributes.action_type is "table_list" or attributes.action_type is "column_list") and  isdefined("attributes.currow") and attributes.currow is currentrow> style="display"<cfelse> style="display:none"</cfif>>
		  <td width="100%" align="left" colspan="3">
		  
		   <table width="100%" align="left" cellpadding="2" cellspacing="0" border="0">
			<tr>
			 <td width="30" align="right" valign="baseline" style="text-align:right;"><img src="/images/db_table<cfif isdefined("attributes.action_type") and (attributes.action_type is "table_list" or attributes.action_type is "column_list")>2</cfif>.gif" width="13"></td>
			 <td width="150"><a href="#request.self#?fuseaction=settings.db_admin&datasource_name=#datasource_name#&action_type=table_list&database_name=#NAME#&currow=#currentrow#" class="tableyazi"><cf_get_lang no ='1140.Tablolar'></a></td>
			</tr>
			<tr>
			 <td width="30" align="right" valign="baseline" style="text-align:right;"><img src="/images/db_user.GIF" width="13"></td>
			 <td width="150"><a href="#request.self#?fuseaction=settings.db_admin&datasource_name=#datasource_name#&action_type=db_user_list&database_name=#NAME#&currow=#currentrow#" class="tableyazi"><cf_get_lang_main no='1580.Kullanıcılar'></a></td>
			</tr>
		   </table>
		  
		  </td>
		 </tr>
		</cfloop>
	   </table>
	  
	  </td>
	 </tr>
	 <tr>
	  <td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/db_folder.gif" width="13"></td>
	  <td width="180" align="left"><a href="javascript://" onClick="show_hide_dbs('sec_list');"><cf_get_lang_main no='739.Güvenlik'></a></td>
	 </tr>
	 <tr id="sec_list"<cfif isdefined("attributes.action_type") and attributes.action_type is "login_access_list"> style="display"<cfelse> style="display:none"</cfif>>
	  <td width="100%" align="left" colspan="2">
	  
	   <table width="100%" align="left" cellpadding="2" cellspacing="0" border="0">
		<tr>
		 <td width="25" align="right" valign="baseline" style="text-align:right;"><img src="/images/db_login.gif" width="13"></td>
		 <td width="155"><a href="javascript://" onClick="show_hide_dbs('users_list');"><cf_get_lang_main no='1580.Kullanıcılar'></a></td>
		</tr>
		<tr id="users_list"<cfif isdefined("attributes.action_type") and attributes.action_type is "login_access_list"> style="display"<cfelse> style="display:none"</cfif>>
		 <td width="100%" align="left" colspan="3">
		  
		  <table width="100%" align="left" cellpadding="2" cellspacing="0" border="0">
		   <cfloop query="users_list">
			<tr>
			 <td width="30" align="right" valign="baseline" style="text-align:right;"><img src="/images/db_login<cfif isdefined("attributes.action_type") and attributes.action_type is "login_access_list" and isdefined("attributes.currow") and currentrow is attributes.currow>2</cfif>.gif" width="13"></td>
			 <td width="150"><a href="#request.self#?fuseaction=settings.db_admin&datasource_name=#datasource_name#&action_type=login_access_list&login_name=#NAME#&currow=#currentrow#" class="tableyazi">#NAME#</a></td>
			</tr>
		   </cfloop>
			<tr>
			 <td width="30" align="right" valign="baseline" style="text-align:right;"><img src="/images/db_login<cfif isdefined("attributes.action_type") and attributes.action_type is "login_access_list" and isdefined("attributes.currow") and users_list.recordcount+1 is attributes.currow>2</cfif>.gif" width="13"></td>
			 <td width="150"><a href="<cfoutput>#request.self#?fuseaction=settings.db_admin&datasource_name=#datasource_name#&action_type=login_access_list&login_name=&currow=#users_list.recordcount+1#</cfoutput>" class="tableyazi"><cf_get_lang no ='1658.Yeni Kullanıcı'></a></td>
			</tr>
		  </table>
		  
		 </td>
		</tr>
	   </table>
	  
	  </td>
	 </tr>
	</table>
	
  </td>
 </tr>
 </cfif>
 </cfoutput>
</table>
<script language="JavaScript" type="text/javascript">
function show_hide_dbs(id_name){
	var myobj=eval(id_name+".style");
	if(myobj.display=='none')
		myobj.display='';
	else
		myobj.display='none';
}
</script>
