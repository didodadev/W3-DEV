<cfinclude template="../query/low_sales_products.cfm">
 <table cellpadding="0" cellspacing="0" border="0">
  <tr class="color-border"> 
   <td>  
      <table cellspacing="1" cellpadding="2" border="0">
        <tr class="color-header"> 
          <td class="form-title" colspan="2" height="22"><cf_get_lang dictionary_id='37267.En Az Satanlar'></td>
        </tr>
        <cfoutput query="low_sales_products"> 
          <tr class="color-row" height="20"> 
            <td width="150"><a href="#request.self#?fuseaction=product.list_product&event=det&pid=#product_id#" class="tableyazi">#product_name#</a></td>
            <td width="75" align="right" style="text-align:right;">#wrk_round(satis)#-#main_unit#</td>
          </tr>
        </cfoutput> 
      </table>
   </td>
 </tr>
 </table>

