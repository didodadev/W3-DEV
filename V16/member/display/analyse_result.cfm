<cfif len(attributes.date_1) and len(attributes.date_2) and len(attributes.service_company_id)>
	<cf_date tarih='attributes.date_1'>
	<cf_date tarih='attributes.date_2'>
  <cfquery name="GET_COST" datasource="#DSN2#">
  		SELECT 
			SUM(INVOICE_ROW_POS.AMOUNT) AS TOTAL_AMOUNT,
			SUM(INVOICE_ROW_POS.GROSSTOTAL) AS TOTAL_GROSSTOTAL,
			INVOICE_ROW_POS.UNIT,
			PRODUCT.PRODUCT_ID,
			PRODUCT.PRODUCT_NAME
		FROM
			INVOICE,
			INVOICE_ROW_POS,
			#dsn3_alias#.PRODUCT AS PRODUCT,
			#dsn3_alias#.STOCKS AS STOCKS
		WHERE
			INVOICE_ROW_POS.INVOICE_ID = INVOICE.INVOICE_ID AND
			INVOICE.INVOICE_CAT = 67 AND
			INVOICE.COMPANY_ID = #attributes.service_company_id# AND
			INVOICE.INVOICE_DATE > = #attributes.date_1# AND
			INVOICE.INVOICE_DATE < = #attributes.date_2# AND
			INVOICE_ROW_POS.PRODUCT_ID = PRODUCT.PRODUCT_ID AND
			STOCKS.PRODUCT_ID = PRODUCT.PRODUCT_ID
		GROUP BY
			PRODUCT.PRODUCT_ID,
			PRODUCT.PRODUCT_NAME,
			INVOICE_ROW_POS.UNIT
		ORDER BY
			PRODUCT.PRODUCT_NAME
  </cfquery>
  <table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
    <tr>
      <td class="headbold" height="35"><cfoutput>#get_par_info(attributes.service_company_id,1,1,0)#</cfoutput></td>
    </tr>
  </table>
  <table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
    <tr>
      <td  valign="top">
	  
              <table width="98%" border="0" cellspacing="1" cellpadding="2" class="color-border" align="center">
                <tr class="color-header" >
                  <td class="form-title" height="22" colspan="4"><cfif attributes.category eq 1><cf_get_lang dictionary_id ='57448.Satış'>
                      <cfelseif attributes.category eq 2><cf_get_lang dictionary_id ='57449.Satınalma'>
                      <cfelseif attributes.category eq 3><cf_get_lang dictionary_id ='30010.Ciro'>
                      <cfelseif attributes.category eq 4><cf_get_lang dictionary_id ='58052.Özet'>
                    </cfif></td>
                </tr>
                <tr class="color-list">
                  <td width="70" height="22" class="txtboldblue"><cf_get_lang dictionary_id ='57487.No'></td>
                  <td class="txtboldblue"width="120"><cf_get_lang dictionary_id ='57657.Ürün'></td>
                  <td class="txtboldblue"width="70"><cf_get_lang dictionary_id ='57673.Tutar'></td>
                </tr>
                <cfif attributes.date_1 eq 1>
                  <cfoutput query="get_ches_to_pay">
                    <tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
                      <td>-</td>
                      <td>-</td>
                      <td>-</td>
                    </tr>
                  </cfoutput>
                  <cfelse>
                  <tr class="color-row" height="20">
                    <td colspan="3"><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
                  </tr>
                </cfif>
              </table>

        <br/>
      </td>
      <cfoutput>
      <td width="350"  valign="top" style="text-align:right;">
        <table width="350" border="0" cellspacing="0" cellpadding="0" align="center" height="300">
          <tr>
            <td>
              <table width="98%" border="0" cellspacing="0" cellpadding="0">
                <tr class="color-border">
                  <td width="100%"  valign="top" style="text-align:right;">
                    <table cellspacing="1" cellpadding="2" border="0" width="100%">
                      <tr class="color-header">
                        <td height="20">
                          <table>
                            <tr>
                              <td class="form-title"><cf_get_lang dictionary_id ='57457.Müşteri'> <cf_get_lang dictionary_id ='57560.Analiz'></td>
                            </tr>
                          </table>
                        </td>
                      </tr>
                      <tr bgcolor="##FFFFFF">
                        <td><cfchart 
					show3d="yes" 
					labelformat="number" 
					pieslicestyle="solid" 
					format="jpg" 
					chartWidth="300"
					chartHeight="300"
					font="Times"
					fontSize="11"
					xAxisTitle ="Dönemler" showlegend="no">
                          <cfchartseries type="pie" itemcolumn="Deneme">
                          <cfchartdata item="1" value="1">
                          <cfchartdata item="2" value="2">
                          <cfchartdata item="3" value="3">
                          <cfchartdata item="4" value="4">
                          <cfchartdata item="5" value="5">
                          <cfchartdata item="6" value="6">
                          </cfchartseries>
                          </cfchart>
                        </td>
                      </tr>
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
  </cfoutput>
</cfif>

