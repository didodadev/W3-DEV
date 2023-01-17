<table border="0" cellpadding="0" cellspacing="0">
  <tr class="color-border">
    <td>
      <table cellspacing="1" cellpadding="2" border="0">
        <tr class="color-header" height="22">
          <td class="form-title" colspan="2"><cf_get_lang dictionary_id='37205.En Çok İlgi Gören Ürünler'></td>
        </tr>
        <cfoutput query="high_sales_products">
          <tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
            <td width="150"><a href="##" class="tableyazi">#product_name#</a></td>
            <td width="75" align="right" style="text-align:right;">&nbsp;</td>
          </tr>
        </cfoutput>
      </table>
    </td>
  </tr>
</table>

