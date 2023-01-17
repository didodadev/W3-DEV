<cfinclude template="../query/get_det_promotion.cfm">
<cfoutput>
  <table cellspacing="0" cellpadding="0" border="0" height="100%" width="100%">
    <tr class="color-border">
      <td valign="middle">
        <table cellspacing="1" cellpadding="2" border="0" width="100%" height="100%">
          <tr class="color-list" valign="middle">
            <td height="35">
              <table width="98%" align="center">
                <tr>
                  <td valign="bottom" class="headbold"><cf_get_lang no='412.Promosyon Bilgileri'>: <cfoutput>#get_main_product.product_name#</cfoutput></td>
                </tr>
              </table>
            </td>
          </tr>
          <tr class="color-row" valign="top">
            <td>
              <table align="center" width="98%" cellpadding="0" cellspacing="0" border="0">
                <tr>
                  <td colspan="2"> <br/>
                    <table>
					<tr height="22">
					<td class="txtbold" width="110"><cf_get_lang no='413.Promosyon No'></td>
                    <td width="150">: #get_det_promotion.prom_no#</td>
					<td class="txtbold"><cf_get_lang_main no='68.Başlık'></td>
                    <td>: #get_det_promotion.prom_head#</td>
					</tr>
                      <tr height="22">
                        <td class="txtbold"> <cf_get_lang_main no='245.Ürün'></td>
                        <td>: #get_main_product.product_name#</td>
						<td class="txtbold" width="110"><cf_get_lang no='414.Ürün Kategorisi'></td>
						<td>: #get_main_product.product_cat#</td>
                      </tr>
                      <tr  height="22">
                        <td class="txtbold"><cf_get_lang no='416.İlişkili Kampanya'></td>
                        <td>:
                          <cfif len(get_det_promotion.camp_id)>
                            #get_camp_name.camp_head#
                          </cfif>
                        </td>
                        <td class="txtbold"><cf_get_lang no='415.Alışveriş Miktarı'></td>
                        <td><cfif get_det_promotion.LIMIT_type is 1 or get_det_promotion.LIMIT_type is 3>
                            : #get_det_promotion.LIMIT_VALUE# <cf_get_lang no='429.Adet'>
                            <cfelseif get_det_promotion.LIMIT_type is 2>
                            : #TLFormat(get_det_promotion.LIMIT_VALUE)# <cf_get_lang_main no='261.Tutar'>
                          </cfif>
                        </td>
                      </tr>
                      <tr  height="22">
                        <td class="txtbold" width="100"><cf_get_lang no='352.Fiyat Listesi'></td>
                        <td>:
						<cfif get_det_promotion.price_catid is '-2'><cf_get_lang no='580.Standart Satış'>
						<cfelseif get_det_promotion.price_catid is '-1'><cf_get_lang no='579.Standart Alış'>
						<cfelse>
							<cfquery name="PRICE_CATS" datasource="#dsn3#">
								SELECT
									PRICE_CAT
								FROM
									PRICE_CAT
								WHERE
									PRICE_CATID = #get_det_promotion.price_catid#
								ORDER BY
									PRICE_CAT
							</cfquery>
							#price_cats.PRICE_CAT#
						</cfif>
						</td>
                        <td class="txtbold" width="100" ><cf_get_lang_main no='229.İndirim'> %</td>
                        <td>: #get_det_promotion.discount# </td>
                      </tr>
                      <tr  height="22">
                        <td class="txtbold"><cf_get_lang_main no='243.Başlangıç Tar'>.</td>
                        <td class="color-row">: #dateformat(get_det_promotion.startdate,dateformat_style)# </td>
                        <td class="txtbold"><cf_get_lang no='419.Bedava Ürün Ver'></td>
                        <td class="color-row" >:
                          <cfif len(get_det_promotion.free_stock_id)>
                            #get_free_product.product_name#
                          </cfif>
                        </td>
                      </tr>
                      <tr  height="22">
                        <td class="txtbold"><cf_get_lang_main no='288.Bitiş Tar'></td>
                        <td class="color-row">: #dateformat(get_det_promotion.finishdate,dateformat_style)#</td>
                        <td class="txtbold"><cf_get_lang no='421.Armağan Ver'></td>
                        <td class="color-row">: #get_det_promotion.gift_head#</td>
                      </tr>
                      <tr  height="22">
                        <td class="txtbold"><cf_get_lang no='422.Kaydeden'></td>
                        <td class="color-row">:#get_emp.employee_name#&nbsp;#get_emp.employee_surname#</td>
                        <td class="txtbold"><cf_get_lang no='423.Puan Ver'></td>
                        <td class="color-row">: #get_det_promotion.prom_point#</td>
                      </tr>
                      <tr  height="22">
                        <td class="txtbold"><cf_get_lang_main no='215.Kayıt Tarihi'></td>
                        <td class="color-row">: #dateformat(get_det_promotion.record_date,dateformat_style)#-#timeformat(get_det_promotion.record_date,'hh:mm:ss')# </td>
                        <td class="txtbold"><cf_get_lang no='424.Şans Kuponu Ver'></td>
                        <td class="color-row">: #get_det_promotion.coupon_id#</td>
                      </tr>
                      <tr height="22">
                        <td class="txtbold"><cf_get_lang_main no='88.Onay'></td>
                        <td class="color-row">:
                          <cfif len(get_det_promotion.valid_emp) and len(get_det_promotion.valid)>
                            #get_position.employee_name#&nbsp;#get_position.employee_surname#
                            <cfif get_det_promotion.valid eq 1>
                              -<cf_get_lang_main no='204.Onaylı'>
                              <cfelse>
                              <cf_get_lang_main no='205.Reddedilmiş'>
                            </cfif>
                            <cfelse>
                            <cf_get_lang no='428.Onay İşlemi Görmemiş'>
                          </cfif>
                        </td>
                        <td class="txtbold"><cf_get_lang no='425.Dönem Primi Ver'></td>
                        <td class="color-row">: #get_det_promotion.prim_percent#</td>
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
