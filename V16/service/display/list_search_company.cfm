<table cellspacing="0" cellpadding="0" border="0" width="98%" align="center">
  <tr class="color-border">
    <td>
      <table cellspacing="1" cellpadding="2" width="100%" border="0">
        <tr class="color-header" height="22">
          <td class="form-title" width="30">No</td>
          <td class="form-title">İşyeri Adı</td>
          <td class="form-title">Ad Soyadı</td>
          <td class="form-title">Vergi No</td>
          <td class="form-title">İlçe</td>
          <td class="form-title" width="85">İl</td>
          <td class="form-title" width="65">Telefon</td>
          <td class="form-title">Cari Hesap</td>
        </tr>
        <cfif len(attributes.is_submitted)>
          <cfif get_company.recordcount>
            <cfoutput query="get_company" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
              <cfquery name="GET_COMPANY_ACCOUNT" datasource="#dsn#">
					SELECT
						OUR_COMPANY.NICK_NAME,
						COMPANY_BRANCH_RELATED.CARIHESAPKOD
					FROM
						BRANCH,
						COMPANY_BRANCH_RELATED,
						OUR_COMPANY
					WHERE
						COMPANY_BRANCH_RELATED.COMPANY_ID = #company_id# AND
						COMPANY_BRANCH_RELATED.BRANCH_ID = BRANCH.BRANCH_ID AND 
						OUR_COMPANY.COMP_ID = BRANCH.COMPANY_ID AND
						COMPANY_BRANCH_RELATED.IS_SELECT = 1 AND
						OUR_COMPANY.COMP_ID = #session.ep.company_id#
					ORDER BY
						OUR_COMPANY.COMPANY_NAME,
						BRANCH.BRANCH_NAME
              </cfquery>
              <tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
                <td width="30">#currentrow#</td>
                <td><a href="#request.self#?fuseaction=service.add_service&company_id=#company_id#" class="tableyazi">#fullname#</a></td>
                <td><a href="#request.self#?fuseaction=service.add_service&company_id=#company_id#&partner_id=#partner_id#" class="tableyazi">#get_par_info(partner_id,0,-1,0)#</a></td>
                <td>#taxno#</td>
                <td>#county_name#</td>
                <td>#city_name#</td>
                <td>#company_telcode# #company_tel1#</td>
                <td><cfloop query="get_company_account">#get_company_account.nick_name# <cfif len(get_company_account.carihesapkod)>/ #get_company_account.carihesapkod#</cfif><cfif get_company_account.recordcount neq currentrow></cfif><br/></cfloop></td>
              </tr>
            </cfoutput>
            <cfelse>
            <tr height="22">
              <td colspan="8" class="color-row">Kayıt Bulunamadı !</td>
            </tr>
          </cfif>
          <cfelse>
          <tr height="22">
            <td colspan="8" class="color-row">Filtre Ediniz !</td>
          </tr>
        </cfif>
      </table>
    </td>
  </tr>
</table>
<!-- sil -->
<cfif attributes.totalrecords gt attributes.maxrows>
  <table width="98%" align="center" cellpadding="0" cellspacing="0" height="35">
    <tr>
      <td><cf_pages 
	  		page="#attributes.page#"
			maxrows="#attributes.maxrows#"
			totalrecords="#attributes.totalrecords#"
			startrow="#attributes.startrow#"
			adres="service.#fusebox.fuseaction##url_str#"></td>
      <td align="right" style="text-align:right;"><cf_get_lang_main no='128.Toplam Kayıt'><cfoutput>:#attributes.totalrecords#&nbsp;-&nbsp;<cf_get_lang_main no='169.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td>
    </tr>
  </table>
<cfelse>
<br/>
</cfif>
