 <!---Promosyon  Gösterme --->
<cfif not isdefined("attributes.purchase")>
<cfset req="#var_#_prom_list">

	<cfif isdefined("session.#req#") and len(session[req])>
	<cfloop list="#session[req]#" index="i">

			<cfoutput>
				<cfset var=LISTGETAT(I,2,"-")>
				<cfset varnew=LISTGETAT(I,1,"-")>
				<cfquery name="GET_DET_PROMOTION" datasource="#dsn3#">
					SELECT * FROM PROMOTIONS
						WHERE PROM_ID= #VAR#
				</cfquery>
				<cfquery name="GET_PRODUCT_NAME" datasource="#dsn3#">
					SELECT
						STOCKS.STOCK_ID,
						STOCKS.PROPERTY,
						PRODUCT.PRODUCT_ID,
						PRODUCT.PRODUCT_NAME
					FROM
						STOCKS,
						PRODUCT
					WHERE
						STOCKS.STOCK_ID=#GET_DET_PROMOTION.STOCK_ID#
						AND
						STOCKS.PRODUCT_ID=PRODUCT.PRODUCT_ID
				</cfquery>
				<cfset say=0>
				<cfif len(get_det_promotion.LIMIT_VALUE)>
					<!--- #get_det_promotion.limit_amount# --->
					<cfscript>
					bir = 1;
					for (i=1;i lte ARRAYLEN(SESSION[var_]);i=i+1)
						if (SESSION[var_][i][10] eq varnew)
							{
							say=SESSION[var_][i][4];
							name=SESSION[var_][i][2];
							}
					if (say gt get_det_promotion.LIMIT_VALUE)
						{
						not_free=(say/get_det_promotion.LIMIT_VALUE);
						free=round(say/get_det_promotion.LIMIT_VALUE);
						if (not_free lt free)
							free=free-1;
						}
					else
						free=0;
					</cfscript>
						<cfif free gt 0>
							<table>
							<tr><td><strong>#get_product_name.product_name#-#get_product_name.property#</strong> Ürünü Promosyonları</td></tr>
							<cfif len(get_det_promotion.free_stock_id)>
								<cfquery name="GET_NAME" datasource="#dsn3#">
									SELECT
										STOCKS.STOCK_ID,
										STOCKS.PROPERTY,
										PRODUCT.PRODUCT_ID,
										PRODUCT.PRODUCT_NAME
									FROM
										STOCKS,
										PRODUCT
									WHERE
										STOCKS.STOCK_ID=#GET_DET_PROMOTION.FREE_STOCK_ID#
										AND
										STOCKS.PRODUCT_ID=PRODUCT.PRODUCT_ID
								</cfquery>
								<tr><td>
								Bedava Ürün=
								#free# Adet #get_name.product_name#-#get_name.property#
								</td></tr>
							</cfif>
							<cfif len(get_det_promotion.gift_head)>
								<tr><td>
								Hediye Ürün=#get_det_promotion.gift_head#
								</td></tr>
							</cfif>
							<cfif len(get_det_promotion.prom_point)>
								<tr><td>
								Promosyon Puanı=
								<cfset promo_point = free * get_det_promotion.prom_point>
								#promo_point#
								</td></tr>
							</cfif>
							<cfif len(get_det_promotion.coupon_id)>
								<tr><td>
								Kupon Numarası=#get_det_promotion.coupon_id#
								</td></tr>
							</cfif>
						</table>
					</cfif>
				<cfelse>
					<cfscript>
					bir=2;
					for (i=1;i lte ARRAYLEN(SESSION[var_]);i=i+1)
						if (SESSION[var_][i][10] eq varnew)
							{
							say=SESSION[var_][i][15];
							name=SESSION[var_][i][2];
							}
					if (say gt get_det_promotion.LIMIT_VALUE)
						{
						not_free=(say/get_det_promotion.LIMIT_VALUE);
						free=round(say/get_det_promotion.LIMIT_VALUE);
						if (not_free lt free)
							free=free-1;
						}
					else
						free=0;
					</cfscript>
					<cfif free gt 0>
					<table>
					<tr><td><strong>#get_product_name.product_name#-#get_product_name.property#</strong> Ürünü Promosyonları</td></tr>
							<cfif len(get_det_promotion.free_stock_id)>
								<tr><td>
								Bedava Ürün=
								<cfquery name="GET_NAME" datasource="#dsn3#">
									SELECT
										STOCKS.STOCK_ID,
										STOCKS.PROPERTY,
										PRODUCT.PRODUCT_ID,
										PRODUCT.PRODUCT_NAME
									FROM
										STOCKS,
										PRODUCT
									WHERE
										STOCKS.STOCK_ID=#GET_DET_PROMOTION.FREE_STOCK_ID#
										AND
										STOCKS.PRODUCT_ID=PRODUCT.PRODUCT_ID
								</cfquery>
								#free# Adet #get_name.product_name#-#get_name.property#
								</td></tr>
							</cfif>
							<cfif len(get_det_promotion.gift_head)>
								 <tr><td>
								Hediye Ürün=#get_det_promotion.gift_head#<br/>
								</td></tr>
							</cfif>
							<cfif len(get_det_promotion.prom_point)>
								<tr><td>
								Promosyon Puanı=
								<cfset promo_point=free * get_det_promotion.prom_point>
								#promo_point#
								</td></tr>
							</cfif>
							<cfif len(get_det_promotion.coupon_id)>
								<tr><td>
								Kupon Numarası=#get_det_promotion.coupon_id#
								</td></tr>
							</cfif>
						</table>
					</cfif>
				</cfif>
			</cfoutput>

	</cfloop>
	</cfif>

</cfif>  
<!--- promosyon Gösterme Sonu --->
