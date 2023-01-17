<cfset cmp = createObject("component","V16.settings.cfc.setupCountry") />
<cfset get_country = cmp.getCountry(country_id:attributes.c_id)>
<table border="0" cellspacing="0" cellpadding="0" width="98%" align="center" height="35">
	<tr>
		<td align="left" class="headbold"><cf_get_lang no='910.Ülkeler'></td>
		<td width="100" align="right" style="text-align:right;"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=settings.form_add_country"><img src="/images/plus1.gif" border="0" alt=<cf_get_lang_main no='170.Ekle'>></a></td>
	</tr>
</table>
<table border="0" cellspacing="1" cellpadding="3" width="98%" class="color-border" align="center">
	<tr class="color-row" valign="top">
		<td width="250"><cfinclude template="../display/list_country.cfm"></td>
		<td valign="top">
			<cfform name="add_country" method="post" action="#request.self#?fuseaction=settings.emptypopup_upd_country">
			<input name="country_id" id="country_id" value="<cfoutput>#attributes.c_id#</cfoutput>" type="hidden">
			<table>
				<tr>
					<td width="50"><cf_get_lang_main no='807.Ülke'>*</td>
					<td><cfsavecontent variable="message"><cf_get_lang no='1131.Ülke Adı Giriniz'>!</cfsavecontent>
						<cfinput type="text" name="country_name" style="width:150px;" value="#get_country.country_name#" maxlength="50" required="Yes" message="#message#">
						<cf_language_info 
							table_name="SETUP_COUNTRY" 
							column_name="COUNTRY_NAME" 
							column_id_value="#attributes.c_id#" 
							maxlength="500" 
							datasource="#dsn#" 
							column_id="COUNTRY_ID" 
							control_type="0">
					</td>
				</tr>
				<tr>
					<td><cf_get_lang_main no='1632.Tel Kodu'></td>
					<td><cfinput type="Text" name="country_phone_code" value="#get_country.country_phone_code#" onKeyUp="isNumber(this);" style="width:150px;" maxlength="10"></td>
				</tr>
                <tr>
					<td><cf_get_lang no='2842.Ülke Kodu'></td>
					<td><cfinput type="Text" name="country_code" value="#get_country.country_code#" style="width:150px;" maxlength="10"></td>
				</tr>
				<tr>
					<td width="50"></td>
					<td><input type="checkbox" name="is_default" id="is_default" value="1" <cfif get_country.is_default eq 1>checked</cfif>> <cf_get_lang no='1132.Standart Seçenek Olarak Gelsin'>(Default)</td>
				</tr>
				<tr>
					<td height="35">&nbsp;</td>
					<td><cf_workcube_buttons is_upd='1' is_delete='0'> </td>
				</tr>
				<tr>
					<td colspan="3"><p><br/>
						<cfoutput>
						<cf_get_lang_main no='71.Kayıt'> : #get_emp_info(get_country.record_emp,0,0)# - #dateformat(get_country.record_date,dateformat_style)#<br/>
						<cfif len(get_country.update_emp)><cf_get_lang_main no='291.Son Güncelleme'> : #get_emp_info(get_country.update_emp,0,0)# - #dateformat(get_country.update_date,dateformat_style)#</cfif>
						</cfoutput>
					</td>
				</tr>
			</table>
			</cfform>
		</td>
	</tr>
</table>
