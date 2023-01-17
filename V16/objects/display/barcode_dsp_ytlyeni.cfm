<cfinclude template="../query/get_print_barcode_queries.cfm">
<cfloop from="1" to="#listlen(attributes.barcode,',')#" index="i">
 	<cfsavecontent variable="barkod_icerik">
		<cfset attributes.barcod = listgetat(attributes.barcode,i,',')>
			<cfquery name="GET_PRODUCT_DETAIL" dbtype="query">
				SELECT
					PRODUCT_NAME,
					TAX, 
					ADD_UNIT, 
					UNIT_MULTIPLIER,
					UNIT_MULTIPLIER_STATIC,
					PROPERTY, 
					BARCODE, 
					PRICE, 
					PRICE_KDV,
					PRICE_DISCOUNT, 
					MONEY, 
					IS_KDV,				
					STARTDATE, 
					FINISHDATE
				FROM 
					get_product_detail_hepsi
				WHERE
				<cfif isnumeric(attributes.barcod)>
					BARCODE='#attributes.barcod#'
				<cfelse><!--- 20050113 kayit getirmesin diye yazildi degistirmeyin --->
					BARCODE IS NULL
				</cfif>
			</cfquery>
	
			<cfif get_product_detail.recordcount>
				<!--- Ürün Adı --->
				<cfset fullname = "#ucase(Left(get_product_detail.product_name,30))#">
				<cfif get_product_detail.property is not "-">
					<cfset fullname = "#fullname#-#ucase(get_product_detail.property)#">
					<cfset fullname = Left(fullname,30)>
				</cfif>
				<!--- Başlangıc - Bitis Tarihi --->
				<cfif len(get_product_detail.finishdate)>
					<cfset tarih=dateformat(get_product_detail.startdate,dateformat_style)&"-"&dateformat(get_product_detail.finishdate,dateformat_style)>
				<cfelse>
					<cfset tarih=dateformat(get_product_detail.startdate,dateformat_style)>
				</cfif>
				<!--- YTL Tutarı --->
				<cfif get_product_detail.is_kdv eq 1>
					<cfset ytl_fiyat=get_product_detail.price_kdv>
				<cfelse>
					<cfif len(get_product_detail.tax) and len(get_product_detail.price)>
						<cfset ytl_fiyat=(get_product_detail.price*(get_product_detail.tax+100))/100>
					<cfelse>
						<cfset ytl_fiyat='! KDV !'>
					</cfif>
				</cfif>
				<cfif isdefined("attributes.price_catid") and (attributes.price_catid neq -2)>
					<cfset indirimli_tutar = ytl_fiyat - get_product_detail.price_discount>
				<cfelse>
					<cfset indirimli_tutar = 0>
				</cfif>
						<cfif ytl_fiyat eq indirimli_tutar>
							<cfset indirimli_tutar = 0>
						</cfif>
					<cfset ytl_fiyat=TLFormat(ytl_fiyat)>
					<cfset indirimli_tutar_ytl=TLFormat(indirimli_tutar)>
				<!--- Urun Birimi --->
				<cfset birim=get_product_detail.add_unit>
				<!--- Birim Bilgileri --->
				<cfif len(get_product_detail.unit_multiplier_static) and len(get_product_detail.unit_multiplier)and (get_product_detail.unit_multiplier neq 0)>
					<cfif get_product_detail.is_kdv eq 1>
						<cfset birim_fiyat=TLFormat(get_product_detail.price_kdv/get_product_detail.unit_multiplier)>
					<cfelseif len(get_product_detail.tax) and len(get_product_detail.price)>
						<cfset birim_fiyat=TLFormat(((get_product_detail.price*(get_product_detail.tax+100))/100)/get_product_detail.unit_multiplier)>
					</cfif>
				<cfelse>
					<cfset birim_fiyat=0>
				</cfif>
				
				<cfif get_product_detail.unit_multiplier_static eq 1>
					<cfset alt_birim='Litre'>
				<cfelseif get_product_detail.unit_multiplier_static eq 2>
					<cfset alt_birim='Kg'>
				<cfelseif get_product_detail.unit_multiplier_static eq 3>
					<cfset alt_birim='Adet'>
				<cfelse>
					<cfset alt_birim=''>
				</cfif>
				<!--- Birim Detayı Sag Alt --->
				<cfif birim_fiyat neq 0>
					<cfset birim_detay="Birim Fiyat :#birim_fiyat# #session.ep.money#/#alt_birim#">
				<cfelse>
					<cfset birim_detay=''>
				</cfif>
				<cfoutput>
	
				<table cellpadding="0" cellspacing="0" style="width:4in;height:2in;">
				  <tr>
					<td valign="top">
					  <table width="100%" border="0" cellpadding="0" cellspacing="0">
						<tr>
						  <td class="txtbold" style="overflow: hidden;font-size:17px;font-family:arial;" height="25" valign="bottom" colspan="2">#fullname#</td>
						</tr>
						<tr>
						  <td nowrap>#tarih#</td>
						  <td rowspan="2"  valign="top" style="text-align:right;">
								  <cfif len(ytl_fiyat)>
									<table cellpadding="0" cellspacing="0">
									  <tr>
										<td colspan="3" class="txtbold" valign="top"><cfif indirimli_tutar gt 0><FONT style="font-size:12px;">KazançCard</font></cfif></td>
									  </tr>
									  <tr>
										<td><div style="font-size:44px;">#listfirst(indirimli_tutar_ytl)#</div></td>
										<td><strong style="font-size:16px;">,&nbsp;</strong></td>
										<td>
										  <table cellpadding="0" cellspacing="0">
											<tr>
											  <td style="font-size:20px;font-family:arial;" valign="top" height="25"><u><strong>
												<cfif listlen(indirimli_tutar_ytl) eq 2>#listlast(indirimli_tutar_ytl)#<cfif len(listlast(indirimli_tutar_ytl)) eq 1>0</cfif><cfelse>00</cfif></strong></u></td>
											</tr>
											<tr>
											  <td>#session.ep.money#/#birim#</td>
											</tr>
										  </table>
										</td>
									  </tr>
									</table>
								  </cfif>
								  <table>
									<tr>
									<td  class="txtbold" style="text-align:right;"><FONT style="font-size:15px;">#ytl_fiyat# #session.ep.money#/#birim#</font></td>
								  </tr>
								  </table>
						  </td>
						</tr>
						<tr>
						  <td height="60" width="50"> <FONT style="font-size:8px;">&nbsp;</FONT>
							<!--- ic 20050714
								ersanin 9,10 ve 11 haneli barkodlu ürünlerini basabilmek için sonlarina 12 ye tammamlamaak adina sifirlar eklendi
							--->
							<cfif get_product_detail.add_unit neq "kg">
								<cfif (len(attributes.barcod) eq 13) or (len(attributes.barcod) eq 12)><cf_barcode type="EAN13" barcode="#attributes.barcod#" extra_height="0">
									<cfif len(errors)>#errors#</cfif>
								<cfelseif (len(attributes.barcod) eq 8) or (len(attributes.barcod) eq 7)><cf_barcode type="EAN8" barcode="#attributes.barcod#" extra_height="0">
									<cfif len(errors)>#errors#</cfif>
								<cfelseif (len(attributes.barcod) eq 9)>
									<cf_barcode type="EAN13" barcode="#attributes.barcod#000" extra_height="0"> <cfif len(errors)><cfoutput>#errors#</cfoutput></cfif>
								<cfelseif (len(attributes.barcod) eq 10)>
									<cf_barcode type="EAN13" barcode="#attributes.barcod#00" extra_height="0"> <cfif len(errors)><cfoutput>#errors#</cfoutput></cfif>
								<cfelseif (len(attributes.barcod) eq 11)>
									<cf_barcode type="EAN13" barcode="#attributes.barcod#0" extra_height="0"> <cfif len(errors)><cfoutput>#errors#</cfoutput></cfif>
								</cfif>
							<cfelseif len(attributes.barcod) eq 7><cf_barcode type="EAN13" barcode="#attributes.barcod#010000" extra_height="0">
								<cfif len(errors)>#errors#</cfif>
							</cfif>			
						  </td>
						</tr>
						<tr>
						  <td colspan="2">
							<table cellpadding="0" cellspacing="0" width="100%">
							  <tr>
								<td class="print">#dateformat(now(),dateformat_style)# &nbsp;&nbsp;&nbsp;&nbsp;*** <cf_get_lang dictionary_id='60022.KDV FİYATA DAHİLDİR'> ***</td>
								<td  class="print" style="text-align:right;">#birim_detay#</td>
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
	</cfsavecontent>
	<cfloop from="1" to="#listgetat(attributes.barcode_count,i,',')#" index="j"><cfoutput>#barkod_icerik#</cfoutput></cfloop>
</cfloop>

