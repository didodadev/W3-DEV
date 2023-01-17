<cfinclude template="../query/get_purchase_general_discount_detail.cfm">
<table width="98%" border="0" cellpadding="0" cellspacing="0" align="center" >
  <tr class="color-border">
    <td>
      <table width="100%" ccellpadding="2" cellspacing="1" border="0">
        <tr class="color-header">
          <td class="form-title" style="text-align:right;">
            <table border="0" cellpadding="0" cellspacing="0">
              <tr>
                <td  style="text-align:right;"> 
				<cfoutput> 
				<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=contract.popup_purchase_list_general_discount&contract_id=#url.contract_id#','medium');return false;"><img src="/images/update_list_beyaz.gif" border="0"></a> 
				</cfoutput> </td>
              </tr>
            </table>
            <cf_get_lang dictionary_id="54761.Satınalma - Genel İskontolar"> </td>
        </tr>
        <tr class="color-row">
          <td colspan="2">
            <table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
              <tr class="color-row">
                <td valign="top">
                  <table>
                    <tr>
                      <td class="formbold" colspan="16"><!--- <cf_get_lang no='173.Satınalma Aylara Göre Bedel Dışı Katılım (her ay otomotik firmadan mal istenir)'> ---></td>
                    </tr>
                    <tr class="txtboldblue">
						<td><cf_get_lang dictionary_id="50930.İskonto Başlığı"></td>
						<td><cf_get_lang dictionary_id="57501.Başlangıç"></td>
						<td><cf_get_lang dictionary_id="57502.Bitiş"></td>
						<td><cf_get_lang dictionary_id="57641.İskonto"></td>
                    </tr>
                    <cfoutput query="GET_PURCHASE_GENERAL_DISCOUNT">
                      <tr>
						  <td>#discount_head#</td>
						  <td>#dateformat(start_date,dateformat_style)#</td>
						  <td>#dateformat(finish_date,dateformat_style)#</td>
						  <td>#TLFormat(discount)#</td>
                      </tr>
                    </cfoutput>
                  </table>
                </td>
              </tr>
            </table>
		  </td>
	    </tr>
      </table>
    </td>
  </tr>
</table>

