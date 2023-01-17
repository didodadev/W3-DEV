<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfinclude template="../../query/get_expense.cfm">
<cfparam name="attributes.totalrecords" default=#get_expense.recordcount#>
<table cellpadding="0" cellspacing="0" border="0" width="97%" align="center">
  <tr>
    <td class="headbold" height="35"><cf_get_lang no='25.Masraf Merkezleri'></td>
    <td height="35"  class="headbold" style="text-align:right;">
      <table>
        <cfform name="form" action="#request.self#?fuseaction=cost.definitions" method="post">
          <tr>
            <td height="34"><cf_get_lang_main no='48.Filtre'>:</td>
            <td height="34"><cfinput type="text" name="keyword" value="#attributes.keyword#"></td>
            <td height="34">
              <cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
              <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
            </td>
            <td height="34"><cf_wrk_search_button></td>
          </tr>
        </cfform>
      </table>
    </td>
  </tr>
</table>
<table cellSpacing="0" cellpadding="0" width="97%" border="0" align="center">
    <tr class="color-border">
        <td>
            <table cellspacing="1" cellpadding="2" width="100%" border="0">
                <tr class="color-header" height="22">
                    <td width="20" class="form-title"><cf_get_lang_main no='75.No'></td>
                    <td width="175" class="form-title"><cf_get_lang_main no='823.Masraf Merkezi'></td>
                    <td width="100" class="form-title"><cf_get_lang no='26.Kodu'></td>
                    <td width="175" class="form-title"><cf_get_lang_main no='1399.Muhasebe Kodu'></td>
                    <td class="form-title"><cf_get_lang_main no='217.Açıklama'></td>
                    <td width="10"><a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=cost.popup_add_expense','medium');"><img src="/images/plus_square.gif" alt="<cf_get_lang no='28.Alt Hesap Ekle'>" border="0" title="<cf_get_lang no='28.Alt Hesap Ekle'>"></a></td>
                </tr>
                <cfif get_expense.recordcount>
                    <cfoutput query="get_expense" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                    <tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
                        <td>#get_expense.currentrow#</td>
                        <td>
                        <cfif listlen(EXPENSE_CODE,".") neq 1>
                            <cfloop from="1" to="#ListLen(EXPENSE_CODE,".")#" index="i">&nbsp;</cfloop>
                        </cfif>
                        <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=cost.popup_upd_expense&obj=1&expense_id=#expense_id#',<cfif ListLen(EXPENSE_CODE,".") neq 1>'small'<cfelse>'medium'</cfif>);" class="tableyazi"> #EXPENSE# </a></td>
                        <td>#EXPENSE_CODE#</td>
                        <td>#DETAIL# </td>
                        <td width="5"> 
                        <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=cost.popup_upd_expense&obj=1&expense_id=#expense_id#','medium');"><img src="/images/update_list.gif" alt="<cf_get_lang no='28.Alt Hesap Ekle'>" border="0" title="<cf_get_lang no='28.Alt Hesap Ekle'>"></a></td>
                    </tr>
                    </cfoutput>
                <cfelse>
                <tr class="color-row" height="20">
                    <td colspan="6"><cf_get_lang_main  no='72.Kayıt Yok'>!</td>
                </tr>
                </cfif>
            </table>
        </td>
    </tr>
</table>
<cfif attributes.totalrecords gt attributes.maxrows>
  <table cellpadding="0" cellspacing="0" width="97%" align="center" height="35">
    <tr>
      <td>
	   <cf_pages 
			page="#attributes.page#" 
			maxrows="#attributes.maxrows#" 
			totalrecords="#attributes.totalrecords#" 
			startrow="#attributes.startrow#" 
			adres="cost.list_expense&keyword=#attributes.keyword#&"></td>
      <!-- sil --><td  style="text-align:right;"><cfoutput><cf_get_lang_main  no='128.Toplam Kayıt'>:#attributes.totalrecords#&nbsp;-&nbsp;<cf_get_lang_main  no='169.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td><!-- sil -->
    </tr>
  </table>
</cfif>
<br/>
