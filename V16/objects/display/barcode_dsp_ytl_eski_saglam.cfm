<cfinclude template="../query/get_print_barcode_queries.cfm">
<cfloop from="1" to="#listlen(attributes.barcode)#" index="i">
	<cfloop from="1" to="#listgetat(attributes.barcode_count,i)#" index="j">
		<cfset attributes.barcod = listgetat(attributes.barcode,i)>
		<cfif not findoneof('+eE*',attributes.barcod,1)> 
			<cfquery name="get_product_detail" dbtype="query">
				SELECT 
					PRODUCT_ID,
					PRODUCT_NAME,
					BRAND_ID,
					TAX,
					ADD_UNIT,
					UNIT_MULTIPLIER,
					UNIT_MULTIPLIER_STATIC,
					STOCK_CODE,
					STOCK_ID,
					PROPERTY,
					PRODUCT_UNIT_ID,
					TAX,
					TAX_PURCHASE,
					BARCODE,
					PRICE_ID
				FROM 
					get_product_detail_hepsi
				WHERE 
					BARCODE='#attributes.barcod#'
			</cfquery>
		<cfelse>
			<cfset get_product_detail.recordcount = 0>
		</cfif>

		<cfif get_product_detail.recordcount>
			<cfif isdefined("attributes.price_catid") and (attributes.price_catid gt 0)>
				<cfquery name="GET_PRICE" dbtype="query"> <!---  datasource="#DSN3#" --->
					SELECT	
						MONEY,
						IS_KDV,
						PRICE_KDV,
						PRICE,
						STARTDATE,
						FINISHDATE
					FROM 
						get_product_detail_hepsi
					WHERE
						PRICE_ID = #get_product_detail.PRICE_ID#
				</cfquery>	
			<cfelseif isdefined("attributes.price_catid") and (attributes.price_catid eq -2)>
				<cfquery name="GET_PRICE" dbtype="query"> <!---  datasource="#DSN3#" --->
					SELECT	
						PRICE,
						PRICE_KDV,				
						MONEY,
						IS_KDV,
						UNIT_ID,
						STARTDATE,
						FINISHDATE
					FROM 
						get_product_detail_hepsi
					WHERE
						PRICE_ID = #get_product_detail.PRICE_ID#
				</cfquery>
			</cfif>
		<cfoutput>
		<cfset fullname = "#ucase(get_product_detail.product_name)#">
		<cfif get_product_detail.property is not "-"><cfset fullname = "#fullname#-#get_product_detail.property#"></cfif>
		<table cellpadding="0" cellspacing="0" style="width:4in;height:2in;">
		  <tr>
			<td valign="top">
			<table width="100%" border="0">
			 <tr>
				<td class="txtbold" style="overflow: hidden;font-size:17px;font-family:arial;" height="25" valign="bottom" colspan="2">#Left(fullname,35)#</td>			
			  </tr>		
			   <tr>
				<td colspan="2">
				<table width="100%" border="0" cellspacing="0" cellpadding="0" class="formbold">
				  <tr>
					<td>#dateformat(GET_PRICE.startdate,dateformat_style)#<cfif len(GET_PRICE.FINISHDATE)>-#dateformat(GET_PRICE.FINISHDATE,dateformat_style)#</cfif></td>
					<td  style="text-align:right;">
					<FONT style="font-size:13px;">					
					<cfif GET_PRICE.IS_KDV EQ 1>#TLFormat(GET_PRICE.PRICE_KDV)#<cfelse><cfif len(get_product_detail.tax) AND LEN(GET_PRICE.PRICE)>#TLFormat((GET_PRICE.PRICE*(get_product_detail.tax+100))/100)#<cfelse>! <cf_get_lang dictionary_id='57639.KDV'> !</cfif></cfif>
					#GET_PRICE.money#/#get_product_detail.add_unit#
					</font>
					</td>
				  </tr>
				</table>
				 </td>
			  </tr>					
			<tr>
			  <td height="60" width="50">
				<FONT style="font-size:8px;">&nbsp;</FONT>
				<cfif isdefined('attributes.barcod')>
					<cfset barcod = attributes.barcod>
				<cfelse>
					<cfset barcod = attributes.barcode>
				</cfif>
				<cfif get_product_detail.add_unit neq "kg">
					<cfif (len(barcod) eq 13) or (len(barcod) eq 12)>
						<cf_barcode type="EAN13" barcode="#barcod#" extra_height="0"> <cfif len(errors)>#errors#</cfif>
					<cfelseif (len(barcod) eq 8) or (len(barcod) eq 7)>
						<cf_barcode type="EAN8" barcode="#barcod#" extra_height="0"> <cfif len(errors)>#errors#</cfif>
					</cfif>
				<cfelseif len(barcod) eq 7>
					<cf_barcode type="EAN13" barcode="#barcod#010000" extra_height="0"> <cfif len(errors)>#errors#</cfif>
				</cfif>
			  </td> 
			  <td  valign="bottom" style="text-align:right;">
			  <cfif GET_PRICE.IS_KDV EQ 1>
				<cfset gelen_fiyat = TLFormat(round(GET_PRICE.PRICE_KDV/10000)/100)>					
			  <cfelse>
				<cfif len(get_product_detail.tax) AND LEN(GET_PRICE.PRICE)>
					<cfset urun_fiyat = (GET_PRICE.PRICE*(get_product_detail.tax+100))/100>
					<cfset gelen_fiyat = TLFormat(round(urun_fiyat/10000)/100)>
				<cfelse>
					<cfset gelen_fiyat = ''>						
				</cfif>
			  </cfif>			  
			  <cfif len(gelen_fiyat)>
				<table cellpadding="0" cellspacing="0">
				  <tr>
					<td rowspan="2" style="font-size:48px;font-family:arial;" vstyle="text-align:right;"><strong>#listfirst(gelen_fiyat)#</strong></td>
					<td style="font-size:16px;font-family:arial;"><strong>,&nbsp;</strong></td>
					<td height="25">
					<table cellpadding="0" cellspacing="0">
						<tr>
							<td style="font-size:24px;font-family:arial;" valign="top" height="25"><u><strong><cfif listlen(gelen_fiyat) eq 2>#listlast(gelen_fiyat)#<cfif len(listlast(gelen_fiyat)) eq 1>0</cfif><cfelse>00</cfif></strong></u></td>
						</tr>
						<tr>
							<td>#session.ep.money# / #get_product_detail.add_unit#</td>
						</tr>
					</table>
					</td>
				  </tr>
				</table>
			  </cfif>
			  </td>
			</tr>	
			<tr>
				<td colspan="2">
					<table cellpadding="0" cellspacing="0" width="100%">
						<tr>
							<td class="print">#dateformat(now(),dateformat_style)#  &nbsp;&nbsp;&nbsp;&nbsp;*** <cf_get_lang dictionary_id='60022.KDV FİYATA DAHİLDİR'> ***</td>
							<td  class="print" style="text-align:right;">
								<cfif len(get_product_detail.UNIT_MULTIPLIER_STATIC) and len(get_product_detail.UNIT_MULTIPLIER)and (get_product_detail.UNIT_MULTIPLIER neq 0)>
									<cf_get_lang dictionary_id='57638.Birim Fiyat'> : <cfif GET_PRICE.IS_KDV EQ 1>#TLFormat(GET_PRICE.PRICE_KDV/get_product_detail.UNIT_MULTIPLIER)#<cfelse><cfif len(get_product_detail.tax) AND LEN(GET_PRICE.PRICE)>#TLFormat(((GET_PRICE.PRICE*(get_product_detail.tax+100))/100)/get_product_detail.UNIT_MULTIPLIER)#</cfif></cfif> <cfif len(GET_PRICE.money)>#GET_PRICE.money#</cfif>/ 
									<cfif get_product_detail.UNIT_MULTIPLIER_STATIC eq 1><cf_get_lang dictionary_id='37613.Litre'>
										<cfelseif get_product_detail.UNIT_MULTIPLIER_STATIC eq 2><cf_get_lang dictionary_id='37188.Kg'>
										<cfelseif get_product_detail.UNIT_MULTIPLIER_STATIC eq 3><cf_get_lang dictionary_id='58082.Adet'>
									</cfif>
								</cfif>
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
	</cfloop>
</cfloop>
