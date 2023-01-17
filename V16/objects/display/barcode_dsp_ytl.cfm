<cfinclude template="../query/get_print_barcode_queries.cfm">
<cfloop from="1" to="#listlen(attributes.barcode,',')#" index="i">
	<cfloop from="1" to="#listgetat(attributes.barcode_count,i,',')#" index="j">
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
				<cfset tarih=dateformat(get_product_detail.startdate,dateformat_style)&" - "&dateformat(get_product_detail.finishdate,dateformat_style)>
			<cfelse>
				<cfset tarih=dateformat(get_product_detail.startdate,dateformat_style)>
			</cfif>
			<!--- TL Fiyatı --->
			<cfif get_product_detail.is_kdv eq 1>
				<cfset tl_fiyat = TLFormat(get_product_detail.price_kdv*1000000,0)>
			<cfelse>
				<cfif len(get_product_detail.tax) and len(get_product_detail.price)>
					<cfset urun_fiyat = (get_product_detail.price*(get_product_detail.tax+100))/100>
					<cfset tl_fiyat = TLFormat(urun_fiyat*1000000,0)>
				<cfelse>
					<cfset urun_fiyat=''>
					<cfset tl_fiyat=''>	  		
				</cfif>
			</cfif>
			<!--- YTL Tutarı --->
			<cfif get_product_detail.is_kdv eq 1>
				<cfset ytl_fiyat=TLFormat(get_product_detail.price_kdv)>
			<cfelse>
				<cfif len(get_product_detail.tax) and len(get_product_detail.price)>
					<cfset ytl_fiyat=TLFormat((get_product_detail.price*(get_product_detail.tax+100))/100)>
				<cfelse>
					<cfset ytl_fiyat='! KDV !'>
				</cfif>
			</cfif>
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
	<table style="width:4in;height:2in;">
		<tr height="25" >
			<td class="txtbold" colspan="3" style="overflow: hidden;font-size:17px;font-family:arial;">#fullname#</td>
			<td width="20" rowspan="4"></td>
		</tr>
		<tr height="20" style="font-size:13px;">
			<td><strong>#tarih#</strong></td>
			<td colspan="2"  style="text-align:right;">&nbsp;</td>
		</tr>
  		<tr height="50">
  			<cfif len(tl_fiyat)>
    		<td>
			<!--- ic 20050714
				ersanin 9,10 ve 11 haneli barkodlu ürünlerini basabilmek için sonlarina 12 ye tammamlamaak adina sifirlar eklendi
			--->
			<cfif get_product_detail.add_unit neq "kg">
				<cfif (len(attributes.barcod) eq 13) or (len(attributes.barcod) eq 12)>
					<cf_barcode type="EAN13" barcode="#attributes.barcod#" extra_height="0"><cfif len(errors)>#errors#</cfif>
				<cfelseif (len(attributes.barcod) eq 8) or (len(attributes.barcod) eq 7)>
					<cf_barcode type="EAN8" barcode="#attributes.barcod#" extra_height="0"><cfif len(errors)>#errors#</cfif>
				<cfelseif (len(attributes.barcod) eq 9)>
					<cf_barcode type="EAN13" barcode="#attributes.barcod#000" extra_height="0"><cfif len(errors)><cfoutput>#errors#</cfoutput></cfif>
				<cfelseif (len(attributes.barcod) eq 10)>
					<cf_barcode type="EAN13" barcode="#attributes.barcod#00" extra_height="0"><cfif len(errors)><cfoutput>#errors#</cfoutput></cfif>
				<cfelseif (len(attributes.barcod) eq 11)>
					<cf_barcode type="EAN13" barcode="#attributes.barcod#0" extra_height="0"><cfif len(errors)><cfoutput>#errors#</cfoutput></cfif>
				</cfif>
			<cfelseif len(attributes.barcod) eq 7><cf_barcode type="EAN13" barcode="#attributes.barcod#010000" extra_height="0">
				<cfif len(errors)>#errors#</cfif>
			</cfif>			
			</td>
    		<td style="font-size:48px;font-family:arial;" style="text-align:right;"><strong>#listfirst(ytl_fiyat)#</strong></td>
    		<td valign="middle">
			<br/><u><strong>, 
			<font style="font-size:24px;font-family:arial;"><cfif listlen(ytl_fiyat) eq 2>#listlast(ytl_fiyat)#<cfif len(listlast(ytl_fiyat)) eq 1>0</cfif><cfelse>00</cfif></font></strong></u>
			<br/>
			#session.ep.money#/#birim#
			</td>
			</cfif>
  		</tr>
  		<tr valign="top">
    		<td class="print" colspan="3">#dateformat(now(),dateformat_style)# &nbsp;&nbsp;&nbsp;*** <cf_get_lang dictionary_id='60022.KDV FİYATA DAHİLDİR'> ***  #birim_detay#</td>
  		</tr>
	</table>
</cfoutput>
		</cfif>
	</cfloop>
</cfloop>

