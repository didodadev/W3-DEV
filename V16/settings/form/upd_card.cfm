<cfquery name="GET_SETUP_CREDITCARD_ID" datasource="#DSN#" maxrows="1">
	SELECT
		COMPANY_CC_TYPE
	FROM
		COMPANY_CC
	WHERE
		COMPANY_CC_TYPE=#URL.ID#
</cfquery>
<table width="98%" height="35" border="0" align="center" cellpadding="0" cellspacing="0" >
  <tr>
    <td class="headbold"><cf_get_lang no='595.Ödeme Kartı Tipi Güncelle'></td>
    <td align="right" class="headbold" style="text-align:right;"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=settings.form_add_card"><img src="/images/plus1.gif" border="0" alt="<cf_get_lang_main no='170.Ekle'>"></a></td>
  </tr>
</table>
<table width="98%" border="0" align="center" cellpadding="2" cellspacing="1" class="color-border">
<tr class="color-row">
  <td width="200" valign="top">
    <cfinclude template="../display/list_card.cfm">
  </td>
  <td valign="top" >
    <table>
      <cfform action="#request.self#?fuseaction=settings.emptypopup_card_upd" method="post" >
        <cfquery name="CATEGORY" datasource="#dsn#">
            SELECT 
                * 
            FROM 
                SETUP_CREDITCARD 
            WHERE 
                CARDCAT_ID=#URL.ID#
        </cfquery>
        <input type="Hidden" name="cardcat_ID" id="cardcat_ID" value="<cfoutput>#URL.ID#</cfoutput>">
        <tr>
          <td width="100"><cf_get_lang no='296.Kart Tipi'><font color=black>*</font></td>
          <td>
            <cfsavecontent variable="message"><cf_get_lang no='722.Kart Tipi Girmelisiniz'></cfsavecontent>
            <cfinput type="Text" name="cardcat" size="40" value="#category.cardcat#" maxlength="30" required="Yes" message="#message#" style="width:150px;">
          </td>
        </tr>
        <tr>
          <td height="35" colspan="2" align="right" style="text-align:right;">
        <cfif get_setup_creditcard_id.recordcount>
            <cf_workcube_buttons is_upd='1' is_delete='0'>
        <cfelse>
            <cf_workcube_buttons is_upd='1' delete_page_url='#request.self#?fuseaction=settings.emptypopup_card_del&cardcat_id=#URL.ID#'>
        </cfif>
          </td>
        </tr>
        <tr>
            <td align="left" colspan="2"><p><br/>
            <cfoutput>
            <cfif len(category.RECORD_EMP)>
                <cf_get_lang_main no='71.Kayit'> : #get_emp_info(category.RECORD_EMP,0,0)# - #dateformat(category.RECORD_DATE,dateformat_style)#
            </cfif><br/>
            <cfif len(category.UPDATE_EMP)>
                <cf_get_lang_main no='291.Son Gncelleme'> : #get_emp_info(category.UPDATE_EMP,0,0)# - #dateformat(category.UPDATE_DATE,dateformat_style)#
            </cfif>
            </cfoutput>
            </td>
        </tr>
      </cfform>
    </table>
  </td>
</tr>
</table>
