<cfquery name="SALE_OPTIONS" datasource="#DSN3#">
	SELECT 
		* 
	FROM 
		SETUP_SALES_ADD_OPTIONS
	WHERE 
		SALES_ADD_OPTION_ID = #attributes.sale_option_id#
</cfquery>
<table border="0" cellspacing="0" cellpadding="0" width="98%" align="center" height="35">
  	<tr>
    	<td class="headbold"><cf_get_lang no='1345.Satış Özel Tanım Güncelle'></td>
		<td align="right" class="headbold" style="text-align:right;"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=settings.add_sales_add_option"><img src="/images/plus1.gif" border="0" alt="<cf_get_lang_main no='170.Ekle'>"></a></td>
	</tr>
</table>
<table border="0" cellspacing="1" cellpadding="2" width="98%" class="color-border" align="center">
	<tr class="color-row" valign="top">
		<td width="200"><cfinclude template="../display/list_sales_add_options.cfm"></td>
		<td>
		<table>
		<cfform name="form" method="post" action="#request.self#?fuseaction=settings.emptypopup_upd_sales_add_option">
		<input type="hidden" name="sale_option_id" id="sale_option_id" value="<cfoutput>#attributes.sale_option_id#</cfoutput>">
			<tr>
				<td width="100"><cf_get_lang no='1094.Satış Özel Tanım'> *</td>
				<td>
			  		<cfsavecontent variable="message"><cf_get_lang no ='1092.Özel Tanım Giriniz'></cfsavecontent>
					<cfinput type="text" required="yes" message="#message#" name="add_option_name" maxlength="50" value="#SALE_OPTIONS.SALES_ADD_OPTION_NAME#" style="width:150px;">
				</td>
			</tr>
			<tr>
				<td valign="top" ><cf_get_lang_main no='217.Açıklama'></td>
			  	<td><textarea name="add_option_detail" id="add_option_detail" style="width:150px;height:40px;" maxlength="250" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="Maksimum Karakter Sayısı : 250"><cfoutput>#SALE_OPTIONS.DETAIL#</cfoutput></textarea></td>
			</tr>
			<tr>
				<td><cf_get_lang no ='1356.İnternet ve Extranet'></td>
				<td><input type="checkbox" name="is_internet" id="is_internet" value="1" <cfif sale_options.is_internet eq 1>checked</cfif>/>&nbsp;<cf_get_lang no ='1844.Görünsün'></td>
			</tr>
			<tr>
				<td align="right">&nbsp;</td>
			  	<td align="right" height="35"><cf_workcube_buttons is_upd='1' delete_page_url='#request.self#?fuseaction=settings.emptypopup_del_sales_add_option&sale_option_id=#attributes.sale_option_id#'></td>
			<tr>
				<td colspan="3"><p><br/>
					<cfoutput>
					<cf_get_lang_main no='71.Kayıt'> : #get_emp_info(SALE_OPTIONS.RECORD_EMP,0,0)# - #dateformat(SALE_OPTIONS.RECORD_DATE,dateformat_style)#<br/>
					<cfif len(SALE_OPTIONS.UPDATE_EMP)>
						<cf_get_lang_main no='291.Son Güncelleme'> : #get_emp_info(SALE_OPTIONS.UPDATE_EMP,0,0)# - #dateformat(SALE_OPTIONS.UPDATE_DATE,dateformat_style)#
					</cfif>
					</cfoutput>
				</td>
			</tr>
		</cfform>
		</table>
		</td>
	</tr>
</table>
