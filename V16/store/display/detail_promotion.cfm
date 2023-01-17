<cfinclude template="../../product/query/get_price_cats.cfm">
<cfinclude template="../../product/query/get_catalog_promotion_detail.cfm">
<cfif len(get_catalog_detail.valid_emp)>
  <cfquery name="GET_EMP2" datasource="#DSN#">
	  SELECT EMPLOYEE_NAME,EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEE_ID = #get_catalog_detail.VALID_EMP#
  </cfquery>
  <cfelseif len(get_catalog_detail.VALIDATOR_POSITION_CODE)>
  <cfquery name="GET_EMP_POSITION" datasource="#DSN#">
	  SELECT EMPLOYEE_ID, EMPLOYEE_NAME, EMPLOYEE_SURNAME FROM EMPLOYEE_POSITIONS WHERE POSITION_ID = #get_catalog_detail.VALIDATOR_POSITION_CODE#
  </cfquery>
</cfif>
<cfif len(get_catalog_detail.camp_id)>
  <cfquery name="GET_CAMPAIGN" datasource="#DSN3#">
	  SELECT CAMP_ID,CAMP_HEAD, CAMP_FINISHDATE,CAMP_STARTDATE FROM CAMPAIGNS WHERE CAMP_ID = #get_catalog_detail.camp_id#
  </cfquery>
</cfif>
<cfsavecontent variable="img_">
    <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.emptypopup_save_action_barcodes&catalog_id=#attributes.id#</cfoutput>','small')"><img src="/images/barcode.gif" title="<cf_get_lang no='112.Aksiyon İçin Barcode File Oluştur'>"></a>
    <cfif len(get_catalog_detail.camp_id)><a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.emptypopup_save_action_campaign_barcodes&camp_id=#GET_CATALOG_DETAIL.camp_id#</cfoutput>','small')"><img src="/images/barcode_print.gif" title="<cf_get_lang no='109.Kampanya İçin Barcode File Oluştur'>"></a></cfif>
</cfsavecontent>
<cf_form_box title="#getLang('store',142)#" right_images="#img_#" nofooter="1">
    <table>
        <tr>
            <td width="140" class="txtbold"><cf_get_lang no='140.Aksiyon'></td>
            <td width="300">: <cfoutput>#get_catalog_detail.catalog_head#</cfoutput></td>
            <td width="100" class="txtbold"><cf_get_lang_main no='34.Kampanya'></td>
            <td>:
				<cfif len(get_catalog_detail.camp_id)>
					<cfoutput>#get_campaign.camp_head# (#dateformat(get_campaign.camp_startdate,dateformat_style)# - #dateformat(get_campaign.camp_finishdate,dateformat_style)#)</cfoutput>
                </cfif>
            </td>
        </tr>
        <tr>
            <td class="txtbold"><cf_get_lang_main no='1212.Geçerlilik Tarihi'></td>
            <td>: <cfoutput>#dateformat(get_catalog_detail.startdate,dateformat_style)# - #dateformat(get_catalog_detail.finishdate,dateformat_style)#</cfoutput></td>
            <td class="txtbold"><cf_get_lang_main no='75.No'></td>
            <td>:
				<cfoutput>#get_catalog_detail.cat_prom_no#</cfoutput> -
                <cfif get_catalog_detail.catalog_status is 1><cf_get_lang_main no='81.Aktif'></cfif>
            </td>
        </tr>
        <tr>
            <td class="txtbold"><cf_get_lang no='141.Kondüsyon Tarihi'></td>
            <td>: <cfoutput>#dateformat(get_catalog_detail.kondusyon_date,dateformat_style)# - #dateformat(get_catalog_detail.kondusyon_finish_date,dateformat_style)#</cfoutput></td>
            <td class="txtbold"><cf_get_lang_main no='70.Aşama'></td>
            <td>: <cfquery name="get_action_stages" datasource="#dsn#">
                 SELECT 
                 	* 
                 FROM 
                 	SETUP_ACTION_STAGES 
                 WHERE 
                 	STAGE_ID = #get_catalog_detail.stage_id#
                </cfquery>
                <cfoutput>#get_action_stages.stage_name#</cfoutput>
           </td>
        </tr>
        <tr>
        	<td colspan="2"></td>
            <td class="txtbold"><cf_get_lang_main no='217.Açıklama'></td>
            <td>: <cfoutput>#get_catalog_detail.catalog_detail#</cfoutput></td>
        </tr>
        <tr>
            <td colspan="4">
				<cfif len(get_catalog_detail.valid)>
                        <cfif get_catalog_detail.valid eq 1> <cf_get_lang_main no='204.Onaylandı'>
                          <cfelseif get_catalog_detail.valid eq 0> <cf_get_lang_main no='205.Reddedildi'>
                          <cfelse>&nbsp;<cf_get_lang_main no='203.Onay Bekliyor'>
                        </cfif>
                        <cfif len(get_catalog_detail.valid)>
                          -
                          <cfif get_emp2.recordcount>
                            <cfset record_date = date_add('h',session.ep.time_zone,get_catalog_detail.validate_date)>
                            <cfoutput> #get_emp2.employee_name# #get_emp2.employee_surname# (#dateformat(date_add('h',session.ep.time_zone,record_date),dateformat_style)# #timeformat(date_add('h',session.ep.time_zone,record_date),timeformat_style)#) </cfoutput>
                            <cfelse><cf_get_lang no='128.Bilinmiyor'></cfif>
                        </cfif>
                </cfif>
            	<br />
				<cfset attributes.emp_id = get_catalog_detail.record_emp>
                <cfinclude template="../../product/query/get_employee_name.cfm"> <cf_record_info query_name="get_catalog_detail">
            </td>
        </tr>
    </table>
</cf_form_box>
<cfset recordnumber = 0>
<cfif IsDefined("attributes.id")>
	<cfinclude template="../../product/query/get_catalog_promotion_products.cfm">
	<cfset recordnumber = get_catalog_product.RecordCount>
</cfif>
<cfinclude template="../../contract/query/get_moneys.cfm">
<cfinclude template="../../contract/query/get_units.cfm">
<cf_big_list name="table1" id="table1">
    <thead>
        <tr class="color-list">
            <th nowrap>&nbsp;</th>
            <th nowrap>&nbsp;</th>
            <th colspan="2" align="center" nowrap><cf_get_lang no='139.Standart'></th>
            <th nowrap>&nbsp;</th>
            <th colspan="5" nowrap align="center"><cf_get_lang_main no='229.İskonto'></th>
            <th colspan="2" align="center"><cf_get_lang_main no='846.Maliyet'></th>
            <th colspan="2" align="center" nowrap><cf_get_lang_main no='227.KDV'></th>
            <th nowrap>&nbsp;</th>
            <th nowrap style="text-align:right;"><cf_get_lang no='136.Aksiyon Fiyat'></th>
            <th nowrap>&nbsp;</th>
            <th nowrap>&nbsp;</th>
        </tr>
        <tr>
            <th nowrap><cf_get_lang_main no='217.Açıklama'></th>
            <th nowrap width="30"><cf_get_lang_main no='224.Birim'></th>
            <th width="80" nowrap style="text-align:right;"><cf_get_lang_main no='1310.Standart Alış'></th>
            <th width="84" nowrap style="text-align:right;"><cf_get_lang_main no='1309.Standart Satış'></th>
            <th nowrap style="text-align:right;"><cf_get_lang no='138.S Mrj'></th>
            <th width="20" nowrap style="text-align:right;">1</th>
            <th width="20" nowrap style="text-align:right;">2</th>
            <th width="20" nowrap style="text-align:right;">3</th>
            <th width="20" nowrap style="text-align:right;">4</th>
            <th width="20" nowrap style="text-align:right;">5</th>
            <th width="70" style="text-align:right;"><cf_get_lang_main no='671.Net'></th>
            <th width="70" nowrap style="text-align:right;"><cf_get_lang_main no='1304.KDVli'></th>
            <th width="30" nowrap style="text-align:right;"><cf_get_lang_main no='764.Alış'></th>
            <th width="30" nowrap style="text-align:right;"><cf_get_lang_main no='36.Satış'></th>
            <th width="45" nowrap style="text-align:right;"><cf_get_lang no='137.A Mrj'></th>
            <th width="75" nowrap style="text-align:right;"><cf_get_lang no='79.KDV Dahil'></th>
            <th width="30" nowrap style="text-align:right;"><cf_get_lang_main no='228.Vade'></th>
            <th nowrap width="60"><cf_get_lang no='119.Raf Tipi'></th>
        </tr>
    </thead>
    <cfif IsDefined("attributes.id") and recordnumber>
        <cfoutput query="GET_CATALOG_PRODUCT">
            <cfquery name="GET_PRODUCT_NAME" datasource="#dsn3#">
                SELECT PRODUCT_NAME FROM PRODUCT WHERE PRODUCT_ID = #PRODUCT_ID#
            </cfquery>
            <tbody>
                <tr id="frm_row#currentrow#">
                    <td nowrap>#get_product_name.product_name#</td>
                    <td>#unit#</td>
                    <td style="text-align:right;">#TLFormat(purchase_price)#</td>
                    <td style="text-align:right;">#TLFormat(sales_price)#</td>
                    <td style="text-align:right;">#TLFormat(profit_margin)#</td>
                    <td style="text-align:right;">#TLFormat(discount1)#</td>
                    <td style="text-align:right;">#TLFormat(discount2)#</td>
                    <td style="text-align:right;">#TLFormat(discount3)#</td>
                    <td style="text-align:right;">#TLFormat(discount4)#</td>
                    <td style="text-align:right;">#TLFormat(discount5)#</td>
                    <td style="text-align:right;">#TLFormat(row_nettotal)#</td>
                    <td style="text-align:right;">#TLFormat(row_total)#</td>
                    <td style="text-align:right;">#TLFormat(tax_purchase)#</td>
                    <td style="text-align:right;">#TLFormat(tax)#</td>
                    <td style="text-align:right;">#TLFormat(action_profit_margin)#</td>
                    <td style="text-align:right;">#TLFormat(action_price)#</td>
                    <td>#duedate#</td>
                    <cfif len(shelf_id)>
                        <cfquery name="GET_SHELF_NAME" datasource="#dsn#">
                            SELECT SHELF_NAME FROM SHELF WHERE SHELF_MAIN_ID = #shelf_id#
                        </cfquery>
                    </cfif>
                    <td nowrap><cfif len(shelf_id)>#get_shelf_name.shelf_name#</cfif></td>
                </tr>
            </tbody>
        </cfoutput>
    </cfif>
</cf_big_list>

