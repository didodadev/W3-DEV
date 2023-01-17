<!---
	Sayfa shelf tablosuna shelf bilgisini guncelleme sayfasi.
	del_id  delete icin kullanildi
	se_id ise update icin
--->
<cfquery name="GET_SHELF_TYPE_ID" datasource="#DSN3#" maxrows="1">
	SELECT
		SHELF_TYPE
	FROM
		PRODUCT_PLACE
	WHERE
		SHELF_TYPE=#attributes.S_ID#
</cfquery>
<table border="0" cellspacing="0" cellpadding="0" width="97%" align="center" height="35">
  <tr>
    <td class="headbold"> <cf_get_lang no='651.Raf Güncelle'></td>
    <td align="right" class="headbold" style="text-align:right;"><a href="<cfoutput>#request.self#?fuseaction=settings.form_add_shelf</cfoutput>"><img src="/images/plus1.gif" border="0" alt="<cf_get_lang_main no='170.Ekle'>"></a></td>
  </tr>
</table>
<table border="0" cellspacing="0" cellpadding="0" width="97%" align="center">
  <tr>
    <td class="color-border">
      <table border="0" cellspacing="1" cellpadding="2" width="100%">
        <tr>
          <td width="200" valign="top" class="color-row">
            <cfinclude template="../display/list_shelf.cfm">
          </td>
          <td valign="top" class="color-row">
            <table>
              <cfset attributes.se_id=attributes.s_id >
              <cfinclude template="../query/get_shelf.cfm">
              <cfform name="frm_upd_shelf" method="post" action="#request.self#?fuseaction=settings.upd_shelf&se_id=#attributes.s_id#">
			  <input type="hidden" name="old_code" id="old_code" value="<cfoutput>#GET_SHELF.SHELF_ID#</cfoutput>">
                <tr>
                  <td width="75"><cf_get_lang no='476.Raf Kod No'></td>
                  <td>
                    <cfsavecontent variable="message"><cf_get_lang no='302.Raf Kod No girmelisiniz'></cfsavecontent>
					<cfinput type="Text" name="shelf_no" size="60" value="#GET_SHELF.SHELF_ID#" maxlength="50" required="Yes" message="#message#" style="width:150px;">
                  </td>
                </tr>
                <tr>
                  <td><cf_get_lang no='477.Raf İsmi'></td>
                  <td>
                    <cfsavecontent variable="message"><cf_get_lang no='304.Raf İsmi girmelisiniz'></cfsavecontent>
					<cfinput type="Text"  name="shelf_name" size="60" value="#GET_SHELF.SHELF_NAME#" maxlength="50" required="Yes" message="#message#" style="width:150px;">
                  </td>
                </tr>
                <tr>
                  <td align="right" colspan="3" height="35">
				  <cfif get_shelf_type_id.recordcount>
				  <cf_workcube_buttons is_upd='1' is_delete='0'>
				  <cfelse>
				   <cf_workcube_buttons is_upd='1' delete_page_url='#request.self#?fuseaction=settings.del_shelf&del_id=#attributes.s_id#'>
                  </cfif>
				  </td>
                </tr>
				<tr>
					<td align="left" colspan="2"><p><br/>
					<cfoutput>
					<cfif len(GET_SHELF.record_emp)>
						<cf_get_lang_main no='71.Kayıt'> : #get_emp_info(GET_SHELF.record_emp,0,0)# - #dateformat(GET_SHELF.record_date,dateformat_style)#
					</cfif><br/>
					<cfif len(GET_SHELF.update_emp)>
						<cf_get_lang_main no='291.Son Güncelleme'> : #get_emp_info(GET_SHELF.update_emp,0,0)# - #dateformat(GET_SHELF.update_date,dateformat_style)#
					</cfif>
					</cfoutput>
					</td>
				</tr>
              </cfform>
            </table>
          </td>
        </tr>
      </table>
    </td>
  </tr>
</table>

