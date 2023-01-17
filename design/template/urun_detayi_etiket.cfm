<cfquery name="GET_PRODUCT" datasource="#dsn3#">
	SELECT * FROM PRODUCT WHERE PRODUCT_ID = #attributes.iid#
</cfquery>
<cfquery name="GET_PROPERTY" datasource="#DSN1#">
	SELECT 
		PRODUCT_DT_PROPERTIES.DETAIL,
		PRODUCT_DT_PROPERTIES.VARIATION_ID,
		PRODUCT_PROPERTY.PROPERTY
	FROM 
		PRODUCT_DT_PROPERTIES,
		PRODUCT_PROPERTY,
		#dsn3_alias#.PRODUCT PRODUCT
	WHERE 
		PRODUCT.PRODUCT_ID = #attributes.iid# AND
		PRODUCT_DT_PROPERTIES.PRODUCT_ID = #attributes.iid# AND
		PRODUCT_DT_PROPERTIES.PROPERTY_ID = PRODUCT_PROPERTY.PROPERTY_ID AND
		PRODUCT_DT_PROPERTIES.IS_INTERNET = 1
	ORDER BY	
		PRODUCT_DT_PROPERTIES.LINE_VALUE,
		PRODUCT_DT_PROPERTIES.PRODUCT_DT_PROPERTY_ID
</cfquery>
<cfform name="change_width" method="post" action="#request.self#?fuseaction=objects2.popupflush_print_files_inner&form_type=#attributes.form_type#&iid=#attributes.iid#">
<br/><br/>
<table align="center" style="width:100mm;height:100mm">
	<cfoutput query="get_product">
	<tr>
		<td colspan="2">
		<table width="100%">
			<tr>
				<td style="font-size:8px;font-weight:bold"><cf_get_lang_main no='245.Ürün'></td>
				<td colspan="2" style="font-size:8px;font-weight:bold">#get_product.product_name#</td>
			</tr>
			<tr valign="top">
				<td style="font-size:8px;font-weight:bold"><cf_get_lang_main no='672.Fiyat'></td>
					<cfquery name="GET_PRICE" datasource="#DSN3#">
						SELECT
							PRICE,
							MONEY,
							IS_KDV,
							PRICE_KDV
						FROM 
							PRICE_STANDART,
							PRODUCT_UNIT
						WHERE 
							PRICE_STANDART.PURCHASESALES = 1 AND 
							PRODUCT_UNIT.IS_MAIN = 1 AND 
							PRICE_STANDART.PRICESTANDART_STATUS = 1 AND 
							PRICE_STANDART.PRODUCT_ID = #attributes.iid# AND					
							PRODUCT_UNIT.PRODUCT_ID = #attributes.iid# 
					</cfquery>
					<cfquery name="get_money_info" datasource="#dsn2#">
						SELECT (RATE2/RATE1) RATE FROM SETUP_MONEY WHERE MONEY = '#get_price.money#'
					</cfquery>
				<td  style="font-size:8px">#TLFormat(get_price.price)#	#get_price.money# + <cf_get_lang_main no='227.KDV'></td>
			</tr>
		</table>
	</tr>
	</cfoutput>
	<cfset count_ = 0>
	<cfif GET_PROPERTY.recordcount>
			<tr>
				<td colspan="2" valign="top">
				<table width="100%">
					<tr>
						<td width="100" style="font-size:8px;font-weight:bold" bgcolor="999999"><cf_get_lang_main no='220.Özellik'></td>
						<td style="font-size:8px;font-weight:bold" bgcolor="999999"><cf_get_lang_main no='217.Açıklama'></td>
					</tr>
					<cfoutput query="GET_PROPERTY" maxrows="24">
						<cfif len(VARIATION_ID) or len(DETAIL)>
							<cfset count_ = count_ + 1>
							<tr <cfif count_ mod 2>bgcolor="D2D2D2"</cfif>>
								<td style="font-size:8px;font-weight:bold">#PROPERTY#</td>
								<td  style="font-size:8px">
									<cfif len(VARIATION_ID)>
										<cfquery name="get_variation" datasource="#DSN1#">
											SELECT PROPERTY_DETAIL FROM PRODUCT_PROPERTY_DETAIL WHERE PROPERTY_DETAIL_ID = #VARIATION_ID#
										</cfquery>
										<cfif get_variation.recordcount>#get_variation.PROPERTY_DETAIL#</cfif>
									</cfif>
									#DETAIL#
								</td>
							</tr>
						</cfif>
					</cfoutput>
				</table>
				</td>
			</tr>
		</cfif>
	</table>
</cfform>
