<!--- 
	Bu sayfanın aynısı Objects modulu altında bulunmaktadır. 
	Burada yapılan degisiklikler oraya da yansıtılmalıdır.
	BK 051026
 --->
<cfscript>
	attributes.fullname = trim(attributes.fullname);
	attributes.nickname = trim(attributes.nickname);
	attributes.name = trim(attributes.name);
	attributes.surname = trim(attributes.surname);
	attributes.tel_code = trim(attributes.tel_code);
	attributes.telefon = trim(attributes.telefon);
</cfscript>
<cfquery name="GET_COMP_KONTROL" datasource="#dsn#">
	SELECT 
		COMPANY.COMPANY_ID,
		COMPANY.FULLNAME,
		COMPANY_PARTNER.COMPANY_PARTNER_NAME,
		COMPANY_PARTNER.COMPANY_PARTNER_SURNAME,
		COMPANY.TAXOFFICE,
		COMPANY.TAXNO,
		COMPANY.COMPANY_TELCODE,
		COMPANY.COMPANY_TEL1,
		COMPANY.ISPOTANTIAL,
		COMPANY.COMPANY_STATE,
		COMPANY_CAT.COMPANYCAT_TYPE,
		COMPANY_CAT.COMPANYCAT
	FROM 
		COMPANY,
		COMPANY_PARTNER,
		COMPANY_CAT
	WHERE 
		COMPANY.COMPANY_ID = COMPANY_PARTNER.COMPANY_ID AND
		COMPANY_CAT.COMPANYCAT_ID = COMPANY.COMPANYCAT_ID AND
		COMPANY_PARTNER.PARTNER_ID = COMPANY.MANAGER_PARTNER_ID AND
		(
			COMPANY.COMPANY_ID IS NULL
			<cfif len(attributes.name)>OR COMPANY.FULLNAME LIKE '%#attributes.fullname#%'</cfif>
			<cfif len(attributes.name) or len(attributes.soyad)>
				<cfif database_type is "MSSQL">
					OR COMPANY_PARTNER.COMPANY_PARTNER_NAME + ' '+ COMPANY_PARTNER.COMPANY_PARTNER_SURNAME = '#attributes.name# #attributes.surname#'
				<cfelseif database_type is "DB2">
					OR COMPANY_PARTNER.COMPANY_PARTNER_NAME ||' '|| COMPANY_PARTNER.COMPANY_PARTNER_SURNAME = '#attributes.name# #attributes.surname#'
				</cfif>
			</cfif>
			<cfif len(attributes.nickname)>OR NICKNAME = '#attributes.nickname#'</cfif>
			<cfif len(attributes.telefon)>OR COMPANY.COMPANY_TEL1 = '#attributes.telefon#'</cfif>
		)
	ORDER BY
		COMPANY.FULLNAME
</cfquery>
<table align="center" width="98%" cellpadding="0" cellspacing="0" border="0">
  <tr>
	<td height="35" class="headbold"><cf_get_lang dictionary_id='30241.Benzer Kriterlerde Kayitlar Bulundu'></td>
  </tr>
</table>
<table cellspacing="0" cellpadding="0" width="98%" border="0" align="center">
  <tr class="color-border">
    <td>
      <table cellspacing="1" cellpadding="2" width="100%" border="0">
		<tr height="22" class="color-header">
            <td class="form-title" width="25"><cf_get_lang dictionary_id='57487.No'></td>
			<td class="form-title" nowrap width="120"><cf_get_lang dictionary_id='57750.İşyeri Adı'></td>
			<td class="form-title" nowrap><cf_get_lang dictionary_id='57751.Kısa Ad'></td>
			<td class="form-title" nowrap><cf_get_lang dictionary_id='57486.Kategori'></td>
            <td class="form-title" nowrap><cf_get_lang dictionary_id='57570.Ad Soyad'></td>
            <td class="form-title" width="80"><cf_get_lang dictionary_id='57752.Vergi No'></td>
            <td class="form-title" nowrap width="80"><cf_get_lang dictionary_id='57499.Telefon'></td>
		  </tr>
		  <form name="search_" method="post" action="">
		  <cfif get_comp_kontrol.recordcount>
			  <cfoutput query="get_comp_kontrol">
				<tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
				<td>#currentrow#</td>
				<td nowrap><a href="://javascript" onClick="control(1,#company_id#);" class="tableyazi"><cfif attributes.fullname eq trim(fullname)><font color="##990000">#fullname#</font><cfelse>#fullname#</cfif></a></td>
				<td><cfif attributes.nickname eq trim(nickname)><font color="##990000">#nickname#</font><cfelse>#nickname#</cfif></td>
				<td nowrap>#companycat#</td>
				<td nowrap><cfif attributes.name eq trim(company_partner_name)><font color="##990000">#company_partner_name#</font><cfelse>#company_partner_name#</cfif>
				<cfif attributes.surname eq trim(company_partner_surname)><font color="##990000">#company_partner_surname#</font><cfelse>#company_partner_surname#</cfif></td>
				<td>#taxno#</td>
				<td nowrap><cfif attributes.telefon eq trim(company_tel1)><font color="##990000">#company_telcode# #company_tel1#</font><cfelse>#company_telcode# #company_tel1#</cfif></td>
			</tr>
			</cfoutput>
			<tr class="color-row">
			<td height="35" colspan="8"  style="text-align:right;"><input type="submit" name="Devam" id="Devam" value="<cf_get_lang dictionary_id='30247.Varolan Kayıtları Gözardi Et'>" onClick="control(2,0);"></td>
			</tr>
			<cfelse>
				<tr class="color-row">
					<td height="20" colspan="8"><cf_get_lang dictionary_id='57484.Kayit Bulunamadi'> !</td>
				</tr>
			</cfif>
			</form>
      </table>
    </td>
  </tr>
</table>
<script type="text/javascript">
<cfif not get_comp_kontrol.recordcount>
	opener.form_add_company.submit();
	window.close();
</cfif>
function control(id,value)
{
	if(id==1)
	{
		opener.location.href='<cfoutput>#request.self#?fuseaction=member.form_list_company&event=upd&is_search=1&cpid=</cfoutput>' + value;
		window.close();
	}
	if(id==2)
	{
		
		opener.form_add_company.submit();
		window.close();
	}
}
</script>
