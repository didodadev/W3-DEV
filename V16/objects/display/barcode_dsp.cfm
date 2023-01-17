<cfinclude template="../query/get_print_barcode_queries.cfm">
<cfloop from="1" to="#listlen(attributes.barcode)#" index="i">
	<cfloop from="1" to="#listgetat(attributes.barcode_count,i)#" index="j">
		<cfset attributes.barcod = listgetat(attributes.barcode,i)>
		<cfif not findoneof('+eE*',attributes.barcod,1)>
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
					BARCODE='#attributes.barcod#'
			</cfquery>
		<cfelse>
			<cfset GET_PRODUCT_DETAIL.recordcount = 0>
		</cfif>

		<cfif GET_PRODUCT_DETAIL.recordcount>
		<cfoutput>
		<cfset fullname = "#ucase(GET_PRODUCT_DETAIL.PRODUCT_NAME)#">
		<cfif GET_PRODUCT_DETAIL.PROPERTY is not "-"><cfset fullname = "#fullname#-#GET_PRODUCT_DETAIL.PROPERTY#"></cfif>
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
					<td>#dateformat(GET_PRODUCT_DETAIL.STARTDATE,dateformat_style)# - #dateformat(GET_PRODUCT_DETAIL.FINISHDATE,dateformat_style)#</td>
					<td  style="text-align:right;">*** <cf_get_lang dictionary_id='60023.KAZANÇLI ALIŞVERİŞ'> ***</td>
				  </tr>
				</table>
				</td>
			</tr>					
			<tr>
			  <td height="60" width="50">
				<font style="font-size:8px;">&nbsp;</font>
				<cfif isdefined('attributes.barcod')>
					<cfset barcod = attributes.barcod>
				<cfelse>
					<cfset barcod = attributes.barcode>
				</cfif>
				<cfif GET_PRODUCT_DETAIL.ADD_UNIT neq "kg">
					<cfif (len(barcod) eq 13) or (len(barcod) eq 12)>
						<cf_barcode type="EAN13" barcode="#barcod#" extra_height="0"> <cfif len(errors)>#errors#</cfif>
					<cfelseif (len(barcod) eq 8) or (len(barcod) eq 7)>
						<cf_barcode type="EAN8" barcode="#barcod#" extra_height="0"> <cfif len(errors)>#errors#</cfif>
					</cfif>
				<cfelseif len(barcod) eq 7>
					<cf_barcode type="EAN13" barcode="#barcod#010000" extra_height="0"> <cfif len(errors)>#errors#</cfif>
				</cfif>
			  </td> 
			  <td style="text-align:right;" valign="bottom" style="font-size:30px;font-family:arial;"><strong><cfif GET_PRODUCT_DETAIL.IS_KDV EQ 1>#TLFormat(GET_PRODUCT_DETAIL.PRICE_KDV)#<cfelse><cfif len(GET_PRODUCT_DETAIL.TAX) AND LEN(GET_PRODUCT_DETAIL.PRICE)>#TLFormat((GET_PRODUCT_DETAIL.PRICE*(GET_PRODUCT_DETAIL.TAX+100))/100)#<cfelse>! KDV !</cfif></cfif><font style="font-size:11px;font-family:tahoma;">&nbsp;#GET_PRODUCT_DETAIL.MONEY#/#GET_PRODUCT_DETAIL.ADD_UNIT#</font></strong></td>
			</tr>
			<tr>
				<td class="print" colspan="2">
				<table cellpadding="0" cellspacing="0" width="100%">
					<tr>
						<td class="print">#dateformat(now(),dateformat_style)#  &nbsp;&nbsp;&nbsp;&nbsp;***
						<cf_get_lang dictionary_id='60022.KDV FİYATA DAHİLDİR'> ***</td>
						<td  class="print" style="text-align:right;">
						<cfif len(GET_PRODUCT_DETAIL.UNIT_MULTIPLIER_STATIC) and len(GET_PRODUCT_DETAIL.UNIT_MULTIPLIER)and (GET_PRODUCT_DETAIL.UNIT_MULTIPLIER neq 0)>
							<cf_get_lang dictionary_id='57638.Birim Fiyat'> : <cfif GET_PRODUCT_DETAIL.IS_KDV EQ 1>#TLFormat(GET_PRODUCT_DETAIL.PRICE_KDV/GET_PRODUCT_DETAIL.UNIT_MULTIPLIER)#<cfelse><cfif len(GET_PRODUCT_DETAIL.TAX) AND LEN(GET_PRODUCT_DETAIL.PRICE)>#TLFormat(((GET_PRODUCT_DETAIL.PRICE*(GET_PRODUCT_DETAIL.TAX+100))/100)/GET_PRODUCT_DETAIL.UNIT_MULTIPLIER)#</cfif></cfif><cfif len(GET_PRODUCT_DETAIL.MONEY)>#GET_PRODUCT_DETAIL.MONEY#</cfif>/ 
							<cfif GET_PRODUCT_DETAIL.UNIT_MULTIPLIER_STATIC eq 1><cf_get_lang dictionary_id='37613.Litre'>
							<cfelseif GET_PRODUCT_DETAIL.UNIT_MULTIPLIER_STATIC eq 2><cf_get_lang dictionary_id='53804.Kg'>
							<cfelseif GET_PRODUCT_DETAIL.UNIT_MULTIPLIER_STATIC eq 3><cf_get_lang dictionary_id='58082.Adet'>
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

