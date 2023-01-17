<cfquery name="GET_MEMBER_ADD_OPTIONS" datasource="#DSN#">
	SELECT 
		* 
	FROM 
		SETUP_MEMBER_ADD_OPTIONS
	WHERE 
		MEMBER_ADD_OPTION_ID = #attributes.member_option_id#
</cfquery>
<table border="0" cellspacing="0" cellpadding="0" width="98%" align="center" height="35">
  	<tr>
    	<td class="headbold"><cf_get_lang no='2644.Üye Özel Tanım Güncelle'></td>
		<td align="right" class="headbold" style="text-align:right;"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=settings.add_member_add_option"><img src="/images/plus1.gif" border="0" alt="<cf_get_lang_main no='170.Ekle'>"></a></td>
	</tr>
</table>
<table border="0" cellspacing="1" cellpadding="2" width="98%" class="color-border" align="center">
	<tr class="color-row" valign="top">
		<td width="200"><cfinclude template="../display/list_member_add_options.cfm"></td>
		<td>
		<table>
		<cfform name="upd_member_option" method="post" action="#request.self#?fuseaction=settings.emptypopup_upd_member_add_option">
		<input type="hidden" name="member_option_id" id="member_option_id" value="<cfoutput>#attributes.member_option_id#</cfoutput>">
			<tr>
				<td width="100"><cf_get_lang no='1094.Satış Özel Tanım'> *</td>
				<td>
			  		<cfsavecontent variable="message"><cf_get_lang no ='1092.Ozel Tanim Giriniz'></cfsavecontent>
					<cfinput type="text" required="yes" message="#message#" name="add_option_name" maxlength="50" value="#get_member_add_options.member_add_option_name#" style="width:150px;">
				</td>
			</tr>
			<tr>
				<td valign="top"><cf_get_lang_main no='217.Açıklama'></td>
			  	<td><textarea name="add_option_detail" id="add_option_detail" style="width:150px;height:40px;" maxlength="250" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="Maksimum Karakter Sayısı : 250"><cfoutput>#get_member_add_options.detail#</cfoutput></textarea></td>
			</tr>
			<tr>
				<td align="right">&nbsp;</td>
			  	<td align="right" height="35"><cf_workcube_buttons is_upd='1' ></td>
			<tr>
				<td colspan="3"><p><br/>
					<cfoutput>
					<cf_get_lang_main no='71.Kayıt'> : #get_emp_info(get_member_add_options.record_emp,0,0)# - #dateformat(get_member_add_options.record_date,dateformat_style)#<br/>
					<cfif len(get_member_add_options.update_emp)>
						<cf_get_lang_main no='291.Son Güncelleme'> : #get_emp_info(get_member_add_options.update_emp,0,0)# - #dateformat(get_member_add_options.update_date,dateformat_style)#
					</cfif>
					</cfoutput>
				</td>
			</tr>
		</cfform>
		</table>
		</td>
	</tr>
</table>
