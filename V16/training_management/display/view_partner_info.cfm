<cfquery name="GET_PARTNER_DETAIL" datasource="#DSN#">
	SELECT 
		* 
	FROM 
		COMPANY_PARTNER 
	WHERE 
		PARTNER_ID = #attributes.PARTNER_ID#
</cfquery>
<table width="98%" align="center" cellpadding="0" cellspacing="0" border="0" height="35">
  <tr>
    <td class="headbold" align="center"><cf_get_lang no='13.KURUM İÇİ EĞİTMEN BİLGİ FORMU'></td>
  </tr>
</table>
<cfoutput query="GET_PARTNER_DETAIL">
  <table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
    <tr clasS="color-border">
      <td>
        <table width="100%" border="0" cellspacing="1" cellpadding="2">
          <tr class="color-row">
            <td valign="top">
              <table border="0">
                <tr>
                  <td class="txtbold" width="150"><cf_get_lang_main no='158.Ad Soyad'></td>
                  <td>: #COMPANY_PARTNER_NAME# #COMPANY_PARTNER_SURNAME#</td>
                </tr>
                <tr>
                  <td class="txtbold"><cf_get_lang_main no='216.Giriş Tarihi'></td>
                  <td>: #dateformat(RECORD_DATE,dateformat_style)# </td>
                </tr>
                <tr>
                  <td class="txtbold"><cf_get_lang_main no='161.Görev'></td>
                  <td>: #TITLE# </td>
                </tr>
                <tr>
                  <td class="txtbold"><cf_get_lang no='18.Son Mezun Olduğu Okul'></td>
                  <td>: </td>
                </tr>
                <tr>
                  <td class="txtbold"><cf_get_lang no='19.Meslek'></td>
                  <td>: #MISSION#</td>
                </tr>
                <tr>
                  <td class="txtbold"><cf_get_lang no='26.Önceki İş Tecrübesi'></td>
                  <td>: </td>
                </tr>
                <tr>
                  <td valign="top" class="txtbold"><cf_get_lang no='27.Uzmanlık Alanları'></td>
                  <td valign="top">: </td>
                </tr>
              </table>
            </td>
          </tr>
        </table>
      </td>
    </tr>
  </table>
</cfoutput>
