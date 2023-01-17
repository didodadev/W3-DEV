<cfquery name="GET_SECTORSIZE_COMPANY" datasource="#DSN#" maxrows="1">
	SELECT
		COMPANY_SIZE_CAT_ID
	FROM
		COMPANY
	WHERE
		COMPANY_SIZE_CAT_ID=#COMPANY_SIZE_CAT_ID#
</cfquery>
<table width="98%" height="35" border="0" align="center" cellpadding="0" cellspacing="0" >
  <tr>
    <td  class="headbold"><cf_get_lang no='141.Şirket Çalışan Sayısı'></td>
    <td align="right" style="text-align:right;"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=settings.form_add_company_size_cat"><img src="/images/plus1.gif" border="0" alt="<cf_get_lang_main no='170.Ekle'>"></a></td>
  </tr>
</table>
      <table width="98%" border="0" align="center" cellpadding="2" cellspacing="1" class="color-border">
        <tr class="color-row">
          <td width="200" valign="top">
            <cfinclude template="../query/get_company_size_cats.cfm">
            <cfinclude template="../display/list_company_size_cats.cfm">
          </td>
          <td valign="top" >
            <table border="0">
              <cfform action="#request.self#?fuseaction=settings.emptypopup_company_size_cat_upd" method="post" name="upd_company_size_cat">
                <cfquery name="CAT" datasource="#dsn#">
					SELECT 
						* 
					FROM 
						SETUP_COMPANY_SIZE_CATS 
					WHERE 
						COMPANY_SIZE_CAT_ID= #COMPANY_SIZE_CAT_ID#
                </cfquery>
                <input type="Hidden" name="company_size_cat_id" id="company_size_cat_id" value="<cfoutput>#company_size_cat_id#</cfoutput>">
                <tr>
                  <td width="100"><cf_get_lang_main no='68.Başlık'> *</td>
                  <td>
				  <cfsavecontent variable="message"><cf_get_lang_main no='647.Başlık girmelisiniz'></cfsavecontent>
				  <cfinput type="Text" name="company_size_cat" style="width:150px;" value="#cat.company_size_cat#" maxlength="255" required="Yes" message="#message#">
                  </td>
                </tr>
				 <tr height="35">
				 <td></td>
                  <td>
				  <cfif get_sectorsize_company.recordcount>
				  <cf_workcube_buttons is_upd='1' is_delete='0'>
				  <cfelse>
				  <cf_workcube_buttons is_upd='1' delete_page_url='#request.self#?fuseaction=settings.emptypopup_company_size_cat_del&company_size_cat_id=#URL.COMPANY_SIZE_CAT_ID#'>
                  </cfif>
				  </td>
                </tr>
				<tr>
				<td colspan="2">
				<cf_get_lang_main no='71.Kayıt'> :
				<cfoutput>
					<cfif len(cat.record_emp)>#get_emp_info(cat.record_emp,0,0)#</cfif>
					<cfif len(cat.record_date)>#dateformat(cat.record_date,dateformat_style)#</cfif>
					<cfif len(cat.update_emp)>
					<br/><cf_get_lang_main no='479.Guncelleyen'> :
					<cfif len(cat.update_emp)>#get_emp_info(cat.update_emp,0,0)#</cfif>
					<cfif len(cat.update_date)>#dateformat(cat.update_date,dateformat_style)#</cfif>
					</cfif>
				</cfoutput>
				</td>
				</tr>
				</cfform>
            </table>
          </td>
        </tr>
      </table>
