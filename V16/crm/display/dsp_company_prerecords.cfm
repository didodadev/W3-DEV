<cfinclude template="../query/get_company_info.cfm">
<table width="98%" cellspacing="0" cellpadding="0" align="center">
	<tr height="35">
      <td class="headbold"><cf_get_lang_main no='1261.Müşteriler'></td>
    <tr>
</table>
<table width="98%" cellspacing="0" cellpadding="0" align="center">
  <td valign="top">
      <table cellSpacing="0" cellpadding="0" border="0" width="100%" align="center">
        <tr class="color-border">
          <td valign="top">
            <table cellspacing="1" cellpadding="2" width="100%" border="0">
              <tr class="color-header">
				<td height="22" class="form-title" width="30"><cf_get_lang_main no='75.No'></td>
                <td height="22" class="form-title" width="200"><cf_get_lang_main no='338.İşyeri Adı'></td>
                <td height="22" class="form-title" width="100"><cf_get_lang_main no='158.Ad Soyad'></td>
                <td height="22" class="form-title"><cf_get_lang_main no='340.Vergi No'></td>
                <td height="22" class="form-title"><cf_get_lang_main no='87.Telefon'></td>
                <td height="22" class="form-title"><cf_get_lang no='117.Grupla Çalıştığı Depolar'></td>
				<td height="22" class="form-title"><cf_get_lang_main no='344.Durum'></td>
              </tr>
			  <cfif  len(attributes.company_name) or len(attributes.company_partner_name) or len(attributes.company_partner_surname) or len(attributes.company_partner_tax_no) or len(attributes.company_partner_tel)>
			  <cfif get_company_info.recordcount>
              <cfoutput query="get_company_info">
					<cfquery name="GET_COMPANY_BRANCH" datasource="#dsn#">
						SELECT
							OUR_COMPANY.NICK_NAME,
							BRANCH.BRANCH_NAME
						FROM
							COMPANY_BRANCH_RELATED,
							OUR_COMPANY,
							BRANCH,
							COMPANY
						WHERE
							COMPANY_BRANCH_RELATED.MUSTERIDURUM IS NOT NULL AND
							COMPANY.COMPANY_ID = #company_id# AND
							COMPANY.COMPANY_ID = COMPANY_BRANCH_RELATED.COMPANY_ID AND
							BRANCH.BRANCH_ID = COMPANY_BRANCH_RELATED.BRANCH_ID AND
							BRANCH.COMPANY_ID = OUR_COMPANY.COMP_ID AND 
							COMPANY_BRANCH_RELATED.IS_SELECT = 1
					</cfquery>
					<tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
						<td width="30">#currentrow#</td>
						<td><a href="javascript://" class="tableyazi" onClick="yonlendir('#company_id#')"><cfif attributes.company_name eq get_company_info.fullname><font color="##990000">#fullname#</font><cfelse>#fullname#</cfif></a></td>
						<td><cfif company_partner_name eq attributes.company_partner_name><font color="##990000">#company_partner_name#</font><cfelse>#company_partner_name#</cfif>
						 <cfif attributes.company_partner_surname eq company_partner_surname><font color="##990000">#company_partner_surname#</font><cfelse>#company_partner_surname#</cfif></td>
						<td><cfif attributes.company_partner_surname eq taxno><font color="##990000">#taxno#</font><cfelse>#taxno#</cfif></td>
						<td>#company_telcode# 
						<cfif attributes.company_partner_surname eq company_tel1><font color="##990000">#company_tel1#</font><cfelse>#company_tel1#</cfif></td>
						<td><cfloop query="get_company_branch">#nick_name# - #branch_name#<br/></cfloop></td>
						<cfquery name="GET_COMPANY_STATE" datasource="#dsn#">
							SELECT
								PTR.STAGE
							FROM
								PROCESS_TYPE_ROWS PTR,
								PROCESS_TYPE_OUR_COMPANY PTO,
								PROCESS_TYPE PT
							WHERE
								PT.IS_ACTIVE = 1 AND
								PTR.PROCESS_ID = PT.PROCESS_ID AND
								PT.PROCESS_ID = PTO.PROCESS_ID AND
								PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
								PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%crm.form_add_company%">
						</cfquery>
						<td>#get_company_state.stage#</td>
                    </tr>
                </cfoutput>
                <cfelse>
                <tr class="color-row" height="20">
                  <td colspan="8"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</td>
                </tr>
              </cfif>
			  <cfelse>
                <tr class="color-row" height="20">
                  <td colspan="8"><cf_get_lang no='455.Lütfen Kriter Giriniz'> !</td>
                </tr>
			  </cfif>
            </table>
          </td>
        </tr>
      </table>
    </td>
  </tr>
</table>
<script type="text/javascript">
	function yonlendir(company_id)
	{
		window.opener.location.href='<cfoutput>#request.self#?fuseaction=crm.detail_company&cpid='+ company_id</cfoutput>;
		window.close();
	}
</script>
