<cfquery name="GET_KARMA_PRODUCT" datasource="#dsn1#">
	SELECT 
		KP.PRODUCT_NAME,
		KP.UNIT,
		KP.PRODUCT_AMOUNT,
		S.STOCK_CODE,
		S.STOCK_ID,
		S.PROPERTY,
		S.IS_PRODUCTION,
		SP.PROPERTY_ID,
		SP.PROPERTY_DETAIL_ID,
		P.BARCOD,
		P.TAX,
		P.PRODUCT_CODE,
		P.BRAND_ID,
		PB.BRAND_NAME
	FROM 
		KARMA_PRODUCTS AS KP
		LEFT JOIN #DSN3#.PRODUCT AS P ON P.PRODUCT_ID=KP.KARMA_PRODUCT_ID
		LEFT JOIN #DSN3#.PRODUCT_BRANDS AS PB ON PB.BRAND_ID=P.BRAND_ID
		LEFT JOIN #dsn3#.STOCKS S ON S.STOCK_ID=KP.STOCK_ID
		LEFT JOIN STOCKS_PROPERTY SP ON SP.STOCK_ID =KP.STOCK_ID AND SP.PROPERTY_ID=1<!--- renk için --->
	WHERE
		KP.KARMA_PRODUCT_ID = <cfqueryparam value = "#attributes.iid#" CFSQLType = "cf_sql_integer">
	ORDER BY 
		ENTRY_ID
</cfquery>
<cfif GET_KARMA_PRODUCT.recordcount>
	<cfoutput>
		<table style="width:60mm;height:90mm;margin:5mm;">
			<tr valign="top" style="text-align:center">
				<td style="text-align:center">
					<div class="col col-12"style="text-align:left;">
						<label class="td-label"style="text-align:left;font-size:14px;">#GET_KARMA_PRODUCT.PRODUCT_CODE#</label>
					</div>
					<div class="col col-12"style="text-align:left;">
						<label class="td-label"style="text-align:left;font-size:18px;font-weight: bold;color:black;">#get_product_name(attributes.iid)#</label>
					</div>
					<cfif GET_KARMA_PRODUCT.product_name contains '.'>
						<div class="col col-12"style="text-align:left;">
							<label class="td-label"style="text-align:left;font-size:14px;font-weight: bold;color:black;">#ListGetAt(GET_KARMA_PRODUCT.product_name,2,'.')#</label>
						</div>
					<cfelseif ListLen(GET_KARMA_PRODUCT.product_name,'-') neq 1>
						<div class="col col-12"style="text-align:left;">
							<label class="td-label"style="text-align:left;font-size:14px;font-weight: bold;color:black;">#ListGetAt(GET_KARMA_PRODUCT.product_name,2,'-')#</label>
						</div>
					</cfif>
						<div class="col col-12"style="text-align:left;">
							<cfset startrow= 1>
							<cfset endrow=7>
							<cfset startrow_= 1>
							<cfset endrow_=7>
							<table style="margin-left:2px;">
								<cfset paket_icerik = 0>
								<cfset degisken=1>
								<cfset currentrow =0>
								<cfloop query="GET_KARMA_PRODUCT">
									<cfset degisken =(GET_KARMA_PRODUCT.recordcount)/2>
								</cfloop>
								<cfif GET_KARMA_PRODUCT.PROPERTY contains '.'>
									<cfloop query="GET_KARMA_PRODUCT">
										<tr>
											<cfloop query="GET_KARMA_PRODUCT" startRow = "#startrow#"  endRow = "#endrow#">
												<cfif GET_KARMA_PRODUCT.PROPERTY contains '.'>
													<td style="text-align:center;font-weight: bold;color:black;padding:8px;font-size:14px;border:1px solid ##555;">
														<cfoutput>#ListGetAt(GET_KARMA_PRODUCT.PROPERTY,1,'.')#</cfoutput>
													</td>
												</cfif>
											</cfloop>
											<cfset startrow = startrow+7>
											<cfset endrow=endrow+7>
										</tr>
									
										<tr>
											<cfloop query="GET_KARMA_PRODUCT" startRow = "#startrow_#"  endRow = "#endrow_#">
												<cfif GET_KARMA_PRODUCT.PROPERTY contains '.'>
													<td style="text-align:center;font-size:14px;padding:8px;border:1px solid ##555;">
														<cfoutput>#GET_KARMA_PRODUCT.product_amount#</cfoutput>
													</td>
													<cfset paket_icerik= paket_icerik + GET_KARMA_PRODUCT.product_amount>
												</cfif>
											
											</cfloop>
											<cfset startrow_ = startrow_+7>
											<cfset endrow_=endrow_+7>
										</tr>
									</cfloop>
								</cfif>
								<cfif GET_KARMA_PRODUCT.PROPERTY contains '-'>
									<cfloop query="GET_KARMA_PRODUCT">
										<tr>
											<cfloop query="GET_KARMA_PRODUCT" startRow = "#startrow#"  endRow = "#endrow#">
											<cfif GET_KARMA_PRODUCT.PROPERTY contains '-'>
													<td style="text-align:center;font-weight: bold;color:black;padding:8px;font-size:14px;border:1px solid ##555;">
													<cfoutput>#ListGetAt(GET_KARMA_PRODUCT.PROPERTY,2,'-')#</cfoutput>
													</td>
												</cfif>
											</cfloop>
											<cfset startrow = startrow+7>
											<cfset endrow=endrow+7>
										</tr>
									
										<tr>
											<cfloop query="GET_KARMA_PRODUCT" startRow = "#startrow_#"  endRow = "#endrow_#">
											<cfif GET_KARMA_PRODUCT.PROPERTY contains '-'>
													<td style="text-align:center;font-size:14px;padding:8px;border:1px solid ##555;">
														<cfoutput>#GET_KARMA_PRODUCT.product_amount#</cfoutput>
													</td>
													<cfset paket_icerik= paket_icerik + GET_KARMA_PRODUCT.product_amount>
												</cfif>
											
											</cfloop>
											<cfset startrow_ = startrow_+7>
											<cfset endrow_=endrow_+7>
										</tr>
									</cfloop> 
								</cfif>
							</table>
						</div>
						<cfif len(GET_KARMA_PRODUCT.product_amount) and GET_KARMA_PRODUCT.PROPERTY contains '.' or  GET_KARMA_PRODUCT.PROPERTY contains '-'>
							<div  class="col col-12"style="text-align:left;">
								<label class="td-label"style="text-align:left;font-size:10px;"><cf_get_lang dictionary_id='34714.Paket İçeriği'>:<b>#paket_icerik#</b></label>
							</div>
						</cfif>
						
					
					<cfif len(GET_KARMA_PRODUCT.BARCOD)>
						<div class="col col-12">
							<br>
							<label class="td-label"style="text-align:center;" >
								<cf_workcube_barcode type="code39" show="1" value="#GET_KARMA_PRODUCT.BARCOD#" height="60" width="50">
							</label>
						</div>
						<div class="col col-12">
							<label class="td-label"style="text-align:center;font-size:9px;letter-spacing:2mm;line-height: 1px !important;" >
								#GET_KARMA_PRODUCT.BARCOD#
							</label>
						</div>
					</cfif>
				</td>
			</tr>
		</table>
		<div style="page-break-after:always"></div>
	</cfoutput>
<cfelse>
	<script language="JavaScript">
		alert("<cf_get_lang dictionary_id='30029.Gönderilen veriler ile bu şablon kullanılamaz.'>!");
		history.back();
	</script>
	<cfabort> 
</cfif>
