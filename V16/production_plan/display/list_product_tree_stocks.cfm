<cfquery name="GET_STOCKS" datasource="#DSN2#" >
	SELECT 
		SUM(STOCK_IN)-SUM(STOCK_OUT) AS TOTAL_STOCK, 
		P.PRODUCT_NAME,
		P.PRODUCT_ID
	FROM 
		STOCKS_ROW SR, 
		#dsn_alias#.PRODUCT_TREE PT, 
		#dsn_alias#.PRODUCT P 
	WHERE
		PT.PRODUCT_ID=#attributes.PRODUCT_ID# 
	AND 
		PT.RELATED_ID=SR.PRODUCT_ID 
	AND 
		P.PRODUCT_ID=PT.RELATED_ID
	GROUP BY 
		P.PRODUCT_NAME,	
		P.PRODUCT_ID
</cfquery>
<table cellSpacing="0" cellpadding="0" width="96%" border="0">
  <tr class="color-border">
    <td>
      <table cellspacing="1" cellpadding="2" width="100%" border="0">
        <tr class="color-header" height="22">
          <td class="form-title"  colspan="2" width="250" style="cursor:pointer;" onclick="gizle_goster(stok);"><cf_get_lang dictionary_id='36631.Malzeme Kontrol'></td>
        </tr>
        <cfif GET_STOCKS.RECORDCOUNT >
          <tr style="display:visible;" id="stok" class="color-row">
            <td colspan="2"> <cfoutput  query="GET_STOCKS">
                <table cellpadding="0" cellspacing="0" border="0" width="100%">
                  <tr>
                    <td width="230"><a href="javascript://"  class="tableyazi" onClick="windowopen('#request.self#?fuseaction=objects.popup_detail_product&pid=#PRODUCT_ID#','list');">#PRODUCT_NAME#</a></td>
                    <td width="50" align="right" style="text-align:right;">#TOTAL_STOCK#</td>
                  </tr>
                </table>
              </cfoutput> </td>
          </tr>
          <cfelse>
          <tr class="color-row" height="20" style="display:visible;" id="stok" >
            <td colspan="2"> <cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
          </tr>
        </cfif>
      </table>
    </td>
  </tr>
</table>

