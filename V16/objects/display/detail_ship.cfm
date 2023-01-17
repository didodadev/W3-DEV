<cf_xml_page_edit>
<cfset module_name = "stock">
<cfset attributes.UPD_ID = attributes.ship_id>
<cfinclude template="../query/get_upd_purchase.cfm">

<cfquery name="get_invoice_ships" datasource="#dsn2#">
	SELECT * FROM INVOICE_SHIPS WHERE SHIP_ID = #attributes.ship_id#
</cfquery>
<cfsavecontent variable="message"><cf_get_lang dictionary_id='33090.İrsaliye Bilgileri'></cfsavecontent>
<cf_popup_box title="#message#">
	<table border="0"  cellpadding="0" cellspacing="0">
		<tr>
			<td valign="top" width="350">
			<table width="99%">
				<tr>
					<td colspan="2" class="txtbold">
						<cfif len(get_upd_purchase.company_id) and get_upd_purchase.company_id neq 0> 
							<cfset attributes.company_id = get_upd_purchase.company_id>
							<cfinclude template="../query/get_company_info.cfm">
							<cfoutput>#company_name.fullname#</cfoutput>
						<cfelseif len(get_upd_purchase.consumer_id)>
							<cfquery name="GET_CONSUMER" datasource="#DSN#">
								SELECT 
									CONSUMER_NAME,
									CONSUMER_SURNAME, 
									COMPANY,
									WORKADDRESS,
									WORK_COUNTY_ID,
									WORK_CITY_ID,
									WORK_COUNTRY_ID,
									TAX_OFFICE,
									TAX_NO,							  
									CONSUMER_ID 
								FROM 
									CONSUMER 
								WHERE 
									CONSUMER_ID = #get_upd_purchase.consumer_id#
							</cfquery>
							<cfoutput>#get_consumer.company#</cfoutput>
						</cfif>
					</td>
				</tr>
				<tr>
					<td colspan="2" class="txtbold">
						<cfif len(get_upd_purchase.company_id) and (get_upd_purchase.company_id neq 0)>
							<cfif len(company_name.city)>
								<cfquery name="GET_CITY" datasource="#DSN#">
									SELECT CITY_NAME FROM SETUP_CITY WHERE CITY_ID = #company_name.city# 
								</cfquery>
							</cfif>
							<cfif len(company_name.county)>
								<cfquery name="GET_COUNTY" datasource="#DSN#">
									SELECT COUNTY_NAME FROM SETUP_COUNTY WHERE COUNTY_ID = #company_name.county# 
								</cfquery>
							</cfif>
							<cfif len(company_name.country)>
								<cfquery name="GET_COUNTRY" datasource="#DSN#">
									SELECT COUNTRY_NAME FROM SETUP_COUNTRY WHERE COUNTRY_ID = #company_name.country# 
								</cfquery>
							</cfif>
							<cfoutput>
								#company_name.company_address#  
								<cfif isdefined('get_county') and get_county.recordcount> - #get_county.county_name#</cfif>
								<cfif isdefined('get_city') and get_city.recordcount> - #get_city.city_name#</cfif>
								<cfif isdefined('get_country') and get_country.recordcount> - #get_country.country_name#</cfif>
							</cfoutput>
						<cfelseif len(get_upd_purchase.consumer_id)>
							<cfoutput>#get_consumer.consumer_name# #get_consumer.consumer_surname#</cfoutput>
							<cfif len(get_consumer.work_county_id)>
								<cfquery name="GET_COUNTY2" datasource="#DSN#">
									SELECT COUNTY_NAME FROM SETUP_COUNTY WHERE COUNTY_ID = #get_consumer.work_county_id# 
								</cfquery>
							</cfif>
							<cfif len(get_consumer.work_city_id)>
								<cfquery name="GET_CITY2" datasource="#DSN#">
									SELECT CITY_NAME FROM SETUP_CITY WHERE CITY_ID = #get_consumer.work_city_id# 
								</cfquery>
							</cfif>
							<cfif len(get_consumer.work_country_id)>
								<cfquery name="GET_COUNTRY2" datasource="#DSN#">
									SELECT COUNTRY_NAME FROM SETUP_COUNTRY WHERE COUNTRY_ID = #get_consumer.work_country_id# 
								</cfquery>
							</cfif>				  
							<cfoutput>
								#get_consumer.workaddress#
								<cfif len(get_consumer.work_county_id)> - #get_county2.county_name#</cfif>
								<cfif len(get_consumer.work_city_id)> - #get_city2.city_name#</cfif>
								<cfif len(get_consumer.work_country_id)> - #get_country2.country_name#</cfif>
							</cfoutput>
						</cfif>
					</td>
				</tr>
				<tr>
					<td class="txtbold"><cf_get_lang dictionary_id='58762.Vergi Dairesi'> : </td>
					<td width="200">
						<cfif len(get_upd_purchase.company_id) and get_upd_purchase.company_id neq 0>
							<cfoutput>#company_name.taxoffice#</cfoutput>
						<cfelseif len(get_upd_purchase.consumer_id)>
							<cfoutput>#get_consumer.tax_office#</cfoutput>
						</cfif>
					</td>
				</tr>
				<tr>
					<td class="txtbold"><cf_get_lang dictionary_id='57752.Vergi No'> : </td>
					<td><cfif len(get_upd_purchase.company_id) and get_upd_purchase.company_id neq 0>
							<cfoutput>#company_name.taxno#</cfoutput>
						<cfelseif len(get_upd_purchase.consumer_id)>
							<cfoutput>#get_consumer.tax_no#</cfoutput>
						</cfif>
					</td>
				</tr>
				<tr>
					<td class="txtbold"><cf_get_lang dictionary_id='57416.Proje'> : </td>
					<td><cfif len(get_upd_purchase.project_id)>
							<cfquery name="get_project_name" datasource="#dsn#">
								SELECT PROJECT_HEAD FROM PRO_PROJECTS WHERE PROJECT_ID = #get_upd_purchase.project_id#
							</cfquery>
							<cfoutput>#get_project_name.project_head#</cfoutput>
						</cfif>
					</td>
				</tr>
			</table>
			</td>
			<td valign="top" width="350">
			<table width="98%">
				<tr>
					<td class="txtbold"><cf_get_lang dictionary_id='57487.No'> : </td>
					<td><cfoutput><strong>#get_upd_purchase.ship_number#</strong></cfoutput>
						<cfif get_upd_purchase.ship_type eq 70><cf_get_lang dictionary_id='29579.Parekande Satış İrsaliyesi'>
						<cfelseif get_upd_purchase.ship_type eq 71><cf_get_lang dictionary_id='58752.Toptan Satış İrsaliyesi'>
						<cfelseif get_upd_purchase.ship_type eq 72><cf_get_lang dictionary_id='58753.Konsinye Çıkış İrsaliyesi'>
						<cfelseif get_upd_purchase.ship_type eq 78><cf_get_lang dictionary_id='29584.Alım İade İrsaliyesi'>
						<cfelseif get_upd_purchase.ship_type eq 79><cf_get_lang dictionary_id='29585.Konsinye Giriş İade İrsaliye'>
						</cfif>
					</td>
				</tr>
				<cfif get_invoice_ships.recordcount>
					<tr>
						<td width="100" class="txtbold"><cf_get_lang dictionary_id='58133.Fatura No'> : </td>
						<td><cfoutput>#get_invoice_ships.invoice_number#</cfoutput></td>
					</tr>
				</cfif>
				<tr>
					<td width="100" class="txtbold"><cf_get_lang dictionary_id='33096.İrsaliye Tarihi'> : </td>
					<td><cfoutput>#dateformat(get_upd_purchase.ship_date,dateformat_style)#</cfoutput></td>
				</tr>
				<tr>
					<td class="txtbold"><cf_get_lang dictionary_id='57645.Teslim Tarihi'> :</td>
					<td><cfoutput>#dateformat(get_upd_purchase.deliver_date,dateformat_style)#</cfoutput></td>
				</tr>
				<tr>
					<td class="txtbold"><cf_get_lang dictionary_id='29500.Sevk'> :</td>
					<td><cfif len(get_upd_purchase.ship_method)>
							<cfquery name="SHIP_METHODS" datasource="#DSN#">
								SELECT * FROM SHIP_METHOD WHERE SHIP_METHOD_ID = #get_upd_purchase.ship_method#
							</cfquery>
							<cfoutput>#ship_methods.ship_method#</cfoutput>				
						</cfif>
					</td>								
				</tr>           
				<tr>
					<td class="txtbold"><cf_get_lang dictionary_id ='33658.Giriş Depo'>:</td>
					<td><cfif len(get_upd_purchase.department_in)>
							<cfquery name="get_dept" datasource="#dsn#">
								SELECT DEPARTMENT_HEAD FROM DEPARTMENT WHERE DEPARTMENT_ID = #get_upd_purchase.DEPARTMENT_IN#
							</cfquery>
							<cfoutput>#get_dept.DEPARTMENT_HEAD#</cfoutput>
						</cfif>
						<cfif len(get_upd_purchase.location_in)>
							<cfquery name="get_dept_location" datasource="#dsn#">
								SELECT COMMENT FROM STOCKS_LOCATION WHERE DEPARTMENT_ID = #get_upd_purchase.department_in# AND LOCATION_ID = #get_upd_purchase.LOCATION_IN#
							</cfquery>
							<cfoutput>-#get_dept_location.COMMENT#</cfoutput>
						</cfif>
					</td>
				</tr>
				<tr>
					<td class="txtbold"><cf_get_lang dictionary_id='29428.Çıkış Depo'>:</td>
					<td><cfif len(get_upd_purchase.deliver_store_id)>
							<cfquery name="get_dept1" datasource="#dsn#">
								SELECT DEPARTMENT_HEAD FROM DEPARTMENT WHERE DEPARTMENT_ID = #get_upd_purchase.DELIVER_STORE_ID#
							</cfquery>
							<cfoutput>#get_dept1.DEPARTMENT_HEAD#</cfoutput>
						</cfif>
						<cfif len(get_upd_purchase.location)>
							<cfquery name="get_dept_location1" datasource="#dsn#">
								SELECT COMMENT FROM STOCKS_LOCATION WHERE DEPARTMENT_ID = #get_upd_purchase.deliver_store_id# AND LOCATION_ID = #get_upd_purchase.LOCATION#
							</cfquery>
							<cfoutput>-#get_dept_location1.COMMENT#</cfoutput>
						</cfif>
					</td>
				</tr> 
				<tr>
					<td class="txtbold"><cf_get_lang dictionary_id ='57642.Net Toplam'> : </td>
					<td><cfoutput>
							<cfif get_upd_purchase.recordcount>
								#TLFormat(get_upd_purchase.nettotal-get_upd_purchase.taxtotal)#
							</cfif>
						</cfoutput>
					</td>
				</tr>
				<tr>
					<td class="txtbold"><cf_get_lang dictionary_id ='57643.KDV Toplam'> : </td>
					<td><cfoutput>#TLFormat(get_upd_purchase.taxtotal)#</cfoutput></td>
				</tr>
				<tr>
					<td class="txtbold"><cf_get_lang dictionary_id ='57680.Genel Toplam'> :</td>
					<td><cfoutput>#TLFormat(get_upd_purchase.nettotal)#</cfoutput></td>
				</tr>			
			</table>
			</td>
		</tr>
	</table>
	<br/><br/>	
		<cf_medium_list>
			<thead>
				<tr> 
					<th><cf_get_lang dictionary_id='57629.Açıklama'></th>
					<cfif isDefined("xml_show_detail2_info") and xml_show_detail2_info eq 1><th><cf_get_lang dictionary_id='57629.Açıklama'>2</th></cfif>
					<th><cf_get_lang dictionary_id='57635.Miktar'></th>
					<th><cf_get_lang dictionary_id='57636.Birim'></th>
					<th><cf_get_lang dictionary_id='57638.B Fiyat'></th>
					<th><cf_get_lang dictionary_id='57639.KDV'></th>
					<th><cf_get_lang dictionary_id='57640.Vade'></th>
					<th><cf_get_lang dictionary_id='58056.Dövizli Tutar'></th>
					<th><cf_get_lang dictionary_id='57641.İndirim'>1</th>
					<th><cf_get_lang dictionary_id='57641.İndirim'>2</th>
					<th><cf_get_lang dictionary_id='57641.İndirim'>3</th>
					<th><cf_get_lang dictionary_id='57492.Toplam'></th>
					<th><cf_get_lang dictionary_id='57642.NToplam'></th>
					<th><cf_get_lang dictionary_id='57643.KDV Top'></th>
					<th><cf_get_lang dictionary_id='57644.Son Toplam'></th>
				</tr>	
				</thead>	
				<tbody>
					<cfoutput query="get_upd_purchase">
						<tr>
							<td>#get_upd_purchase.name_product#</td>
							<cfif isDefined("xml_show_detail2_info") and xml_show_detail2_info eq 1><td>#get_upd_purchase.product_name2#</td></cfif>
							<td style="text-align:right;">#TLFormat(get_upd_purchase.amount)#</td>
							<td>#get_upd_purchase.unit#</td>
							<td style="text-align:right;">#TLFormat(get_upd_purchase.price,4)#</td>
							<td style="text-align:right;">#get_upd_purchase.tax#</td>
							<td style="text-align:right;"></td>
							<td style="text-align:right;">#TLFormat(get_upd_purchase.price_other,4)#&nbsp;#get_upd_purchase.other_money#</td>
							<td style="text-align:right;">#TLFormat(get_upd_purchase.discount)#</td>
							<td style="text-align:right;">#TLFormat(get_upd_purchase.discount2)#</td>
							<td style="text-align:right;">#TLFormat(get_upd_purchase.discount3)#</td>
							<cfif not len(get_upd_purchase.price)>
								<cfset get_upd_purchase.price = 0>
							</cfif>
							<td style="text-align:right;">#TLFormat(get_upd_purchase.amount * get_upd_purchase.price)#</td>
							<cfset net_satir = ( (get_upd_purchase.amount * get_upd_purchase.price)*(100-get_upd_purchase.discount) /100)>
							<td style="text-align:right;">#TLFormat(net_satir)#</td>
							<td style="text-align:right;">#TLFormat(net_satir*(get_upd_purchase.tax/100))#</td>
							<td style="text-align:right;">#TLFormat(net_satir+(net_satir*(get_upd_purchase.tax/100)))#</td>
						</tr>
					</cfoutput>
				</tbody>
			</cf_medium_list>
	<br/><br/><br/>
	<cfquery name="get_ship_money" datasource="#dsn2#">
		SELECT * FROM SHIP_MONEY WHERE ACTION_ID = #attributes.ship_id#
	</cfquery>
	<cfquery name="get_invoice_ships_money" datasource="#dsn2#">
		SELECT
			IM.*
		FROM
			INVOICE_SHIPS ISH,
			INVOICE_MONEY IM
		WHERE
			ISH.INVOICE_ID = IM.ACTION_ID AND
			ISH.SHIP_ID = #attributes.ship_id#
	</cfquery>
	<cfif get_ship_money.recordcount>
		<table>
			<tr>
				<td>&nbsp;</td>
				<td colspan="2" class="txtbold"><cf_get_lang dictionary_id='57674.Kur Bilgileri'></td>
			</tr>
			<cfoutput query="get_ship_money">
				<tr>
					<td>&nbsp;</td>
					<td>#get_ship_money.money_type#</td>
					<td>#get_ship_money.rate1# / #TLFormat(get_ship_money.rate2,session.ep.our_company_info.rate_round_num)#</td>
				</tr>
			</cfoutput>
		</table>
	<cfelseif get_invoice_ships_money.recordcount>
		<table>
			<tr>
				<td>&nbsp;</td>
				<td colspan="2" class="txtbold"><cf_get_lang dictionary_id='57674.Kur Bilgileri'></td>
			</tr>
			<cfoutput query="get_invoice_ships_money">
				<tr>
					<td>&nbsp;</td>
					<td>#get_invoice_ships_money.money_type#</td>
					<td>#get_invoice_ships_money.rate1# / #TLFormat(get_invoice_ships_money.rate2,session.ep.our_company_info.rate_round_num)#</td>
				</tr>
		</cfoutput>
		</table>
	</cfif>
</cf_popup_box>
