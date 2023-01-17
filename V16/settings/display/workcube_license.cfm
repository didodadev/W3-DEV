<cfquery name="license" datasource="#dsn#">
	SELECT
		WORKCUBE_ID,
		PROJECT_ID,
		COMPANY,
		COMPANY_PARTNER,
		TEL,
		FAX,
		EMAIL
	FROM
		WRK_LICENSE
</cfquery>

<table width="98%" height="35" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td class="headbold"><cf_get_lang no='205.WorkCube Lisans Bilgileri'></td>
  </tr>
</table>
<table width="98%" border="0" cellspacing="1" cellpadding="2" class="color-border" align="center">
  <tr class="color-row">
    <td>
	  <table>
<cfif license.recordcount>
	<cfoutput query="license">
	  <tr>
		<td class="txtbold"> WorkCube ID</td>
		<td>#WorkCube_ID#</td>
	  </tr>
	  <tr>
		<td class="txtbold"> Implementation Project ID</td>
		<td>#Project_ID#</td>
	  </tr>
	  <tr>
		<td class="txtbold"><cf_get_lang_main no='162.Şirket'></td>
		<td>#Company#</td>
	  </tr>
	  <tr>
		<td class="txtbold"><cf_get_lang_main no='166.Yetkili'></td>
		<td>#Company_Partner#</td>
	  </tr>
	  <tr>
		<td class="txtbold"><cf_get_lang_main no='87.Telefon'></td>
		<td><a href="tel://#Tel#">#Tel#</a></td>
	  </tr>
	  <tr>
		<td class="txtbold"><cf_get_lang_main no='76.Faks'></td>
		<td><cf_get_lang_main no='76.Faks'></td>
	  </tr>
	  <tr>
		<td class="txtbold"><cf_get_lang_main no='16.E-mail'></td>
		<td>#email#</td>
	  </tr>
	</cfoutput>
<cfelse>
 <tr>
    <td colspan="2"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</td>
  </tr>
 </cfif>
</table>
	</td>
  </tr>
</table>
