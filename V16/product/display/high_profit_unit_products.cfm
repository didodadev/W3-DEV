<cfinclude template="../query/high_profit_unit_products.cfm">
<table border="0" cellpadding="0" cellspacing="0">
  <tr class="color-border">
    <td>
      <table cellspacing="1" cellpadding="2" border="0">
        <tr class="color-header" height="22">
          <td class="form-title" colspan="2"><cf_get_lang dictionary_id='37206.En Karlı Ürünler'> (<cf_get_lang dictionary_id='37181.Birim Bazında'> - <cf_get_lang dictionary_id='58721.Standart Satış'>)</td>
        </tr>
        <cfoutput query="high_profit_unit_products">
         <tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
            <td width="150"><a href="#request.self#?fuseaction=product.list_product&event=det&pid=#product_id#" class="tableyazi">#product_name#(#UNIT#)</a></td>
            <td width="100" align="right" style="text-align:right;">#TLFormat(profit*rate2)#&nbsp;#session.ep.money#</td>
          </tr>
        </cfoutput>
      </table>
    </td>
  </tr>
</table>

