			<table width="100%" border="0" cellspacing="1" cellpadding="2">
			<cfoutput><form action="#request.self#?fuseaction=settings.db_admin&action_type=login_access_list" method="post" name="db_user_form" id="db_user_form"></cfoutput>
			<cfif isdefined("attributes.login_name")><input type="hidden" name="login_name" id="login_name" value="<cfoutput>#attributes.login_name#</cfoutput>"></cfif>
			<cfif isdefined("attributes.currow")><input type="hidden" name="currow" id="currow" value="<cfoutput>#attributes.currow#</cfoutput>"></cfif>
			<input type="hidden" name="is_update" id="is_update" value="0">
			<input type="hidden" name="is_add" id="is_add" value="0">
			<input type="hidden" name="is_delete" id="is_delete" value="0">
			 <tr>
			  <td width="50%" valign="top">
				  <table width="100%" border="0" cellspacing="0" cellpadding="5">
				   <tr class="color-header">
					<td class="form-title" colspan="2"><cf_get_lang no ='1196.Kullanıcı Bilgileri'></td>
				   </tr>
				   <tr class="color-row">
					<td width="40%" align="right" style="text-align:right;"><cf_get_lang_main no ='139.Kullanıcı Adı'> :</td>
					<td width="60%" align="left"><input type="text" name="db_user_name" id="db_user_name" style="width:150px;" value="<cfoutput>#attributes.login_name#</cfoutput>"></td>
				   </tr>
				   <tr class="color-row">
					<td align="right" style="text-align:right;"><cf_get_lang_main no ='140.Şifre'> :</td>
					<td align="left"><input type="password" name="db_user_password" id="db_user_password" style="width:150px;" value="<cfif login_details.recordcount></cfif>"></td>
				   </tr>
				   <tr class="color-row">
					<td align="right" style="text-align:right;"> <cf_get_lang no ='3091.Default Database'> :</td>
					<td align="left"><select name="database_name" id="database_name" size="1" style="width:150px;"><option value=""></option><cfoutput query="database_list"><option value="#NAME#"<cfif dbid is login_details.DBID> selected</cfif>>#NAME#</option></cfoutput></select></td>
				   </tr>
				   <tr class="color-row">
					<td colspan="2" align="center"><input name="add_button" id="add_button" type="button" value="<cf_get_lang_main no ='518.Kullanıcı'> <cfif login_details.recordcount><cf_get_lang_main no ='52.Güncelle'><cfelse><cf_get_lang_main no ='49.Kaydet'></cfif>" onClick="check_form(<cfif login_details.recordcount>1<cfelse>0</cfif>);">&nbsp;<cfif login_details.recordcount><input name="delete_button" id="delete_button" type="button" value="<cf_get_lang_main no ='1285.Kullanıcı Sil'>" onClick="del_user();"></cfif></td>
				   </tr>
				   <tr class="color-header">
					<td class="form-title" colspan="2"><cf_get_lang no ='1197.Sunucu Rolleri'></td>
				   </tr>
				  </table>
				
			  </td>
			  <td width="50%" valign="top">
			  
			   	<table width="100%" border="0" cellspacing="1" cellpadding="2">
				 <tr height="22" class="color-header">
				  <td class="form-title" colspan="2"><cf_get_lang no ='1207.Erişim İzinleri'></td>
				 </tr>
				 <tr height="22" class="color-header">
				  <td class="form-title" width="1%"><cf_get_lang no ='1268.Erişim'></td>
				  <td class="form-title" width="99%"><cf_get_lang no ='1269.Veritabanı'></td>
				 </tr>
				<cfoutput query="database_list">
				<cfquery datasource="workcube_db_admin" name="database_access">
					SELECT 
						COUNT(*) AS DB_CONTROL 
					FROM 
						#NAME#.sysusers
					WHERE 
						NAME='#attributes.login_name#'
				</cfquery>
				 <tr>
				  <td align="center"><input type="checkbox" name="db_access" id="db_access" value="#NAME#"<cfif database_access.DB_CONTROL IS 1> checked</cfif>></td>
				  <td><cfif database_access.DB_CONTROL IS 1><a href="#request.self#?fuseaction=settings.db_admin&action_type=table_list&database_name=#name#&currow=#currentrow#" class="tableyazi">#NAME#</a><cfelse>#NAME#</cfif></td>
				 </tr>
				</cfoutput>
				</table>
			  
			  </td>
			 </tr>
			</form>
			</table>
<script language="JavaScript" type="text/javascript">
	function check_form(actiontype){
		/*actiontype 0:add 1:update*/
		if(actiontype==0){
			document.db_user_form.add_button.disabled=true;
			document.db_user_form.is_update.value=0;
			document.db_user_form.is_add.value=1;
			document.db_user_form.is_delete.value=0;
			document.db_user_form.submit();
		}
		else{
			document.db_user_form.add_button.disabled=true;
			document.db_user_form.delete_button.disabled=true;
			document.db_user_form.is_update.value=1;
			document.db_user_form.is_add.value=0;
			document.db_user_form.is_delete.value=0;
			document.db_user_form.submit();
		}
	}
	function del_user(){
		var kullanici = document.db_user_form.db_user_name.value;
		var confirm_str = '!!! ' + kullanici + ' <cf_get_lang no ="1270.isimli kullanıcıyı silmek üzeresiniz eminmisiniz">?'
		if(confirm(confirm_str)){
			document.db_user_form.add_button.disabled=true;
			document.db_user_form.delete_button.disabled=true;
			document.db_user_form.is_update.value=0;
			document.db_user_form.is_add.value=0;
			document.db_user_form.is_delete.value=1;
			document.db_user_form.submit();
		}
	}
</script>
