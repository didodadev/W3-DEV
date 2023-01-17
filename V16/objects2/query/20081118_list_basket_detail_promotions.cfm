<!--- order_pre_rows kayıtları cekilerek bu ürünlerin detaylı promosyonları incelenir OZDEN20081106--->
<!---PROM_TYPE 2:dönemsel, 1:sipariş bazlı promosyon  --->
<cfset useable_promotion_list=''>
<cfinclude template="../query/get_basket_express_member_detail.cfm">
<cfif get_all_pre_order_rows.recordcount>
<cfset used_promotion_list=listsort(valuelist(get_all_pre_order_rows.PROM_ID),"numeric","asc")>
<cfquery name="get_prom_info" datasource="#dsn3#"><!--- sipariş bazlı oncelikli promosyon alınıyor --->
	SELECT 
		* 
	FROM 
		PROMOTIONS 
	WHERE 
		<cfif isdefined('attributes.price_catid') and len(attributes.price_catid)>
		PRICE_CATID=#attributes.price_catid# AND
		<cfelse>
		PRICE_CATID=-2 AND
		</cfif>
		IS_DETAIL=1 AND
		LIST_WORK_TYPE=0 AND <!--- kazanclar çalışma şekli 'veya' olan promosyonlar --->
		PROM_STATUS=1 AND
		PROM_TYPE=0 AND 
		<cfif isdefined('used_promotion_list') and len(used_promotion_list)><!--- bir siparişte aynı promosyon sadece 1 kez kullanılır --->
		PROM_ID NOT IN (#used_promotion_list#) AND
		</cfif>
		STARTDATE <=#CreateODBCDateTime(now())# AND
		FINISHDATE >=#CreateODBCDateTime(now())#
	ORDER BY PROM_HIERARCHY
</cfquery>
<cfif get_prom_info.recordcount>
	<cfloop query="get_prom_info">
		<cfset is_prom_flag =1>
		<cfif len(get_prom_info.IS_ONLY_FIRST_ORDER) and get_prom_info.IS_ONLY_FIRST_ORDER eq 1>
			<cfquery name="control_orders" datasource="#dsn3#">
				SELECT 
					ORDER_ID
				FROM
					ORDERS
				WHERE
				<cfif len(attributes.consumer_id)>
					CONSUMER_ID=#attributes.consumer_id#
				<cfelse>
					PARTNER_ID=#attributes.partner_id#
				</cfif>
			</cfquery>
			<cfif control_orders.recordcount>
				<cfset is_prom_flag =0>
			<cfelse>
				<cfset 'is_only_first_order_#control_prom_id#'=1>
			</cfif>
		<cfelseif len(PROM_WORK_COUNT)>
			<cfquery name="control_prom_count" datasource="#dsn3#">
				SELECT 
					COUNT(PROM_ID) AS PROM_COUNT
				FROM
					ORDERS ORD,
					ORDER_ROW ORDR
				WHERE
					ORD.ORDER_ID=ORDR.ORDER_ID AND
					ORDR.PROM_ID=#get_prom_info.prom_id# AND
				<cfif len(attributes.consumer_id)>
					ORD.CONSUMER_ID=#attributes.consumer_id#
				<cfelse>
					ORD.PARTNER_ID=#attributes.partner_id#
				</cfif> 
			</cfquery>
			<cfif len(control_prom_count.PROM_COUNT) and control_prom_count.PROM_COUNT gte get_prom_info.PROM_WORK_COUNT> <!--- uye icin verilen siparislerde calısma sayısından fazla kullanılmıs --->
				<cfset is_prom_flag =0>
			</cfif>
		</cfif>
		<cfif is_prom_flag>
			<cfset used_prom_flag=0>
			<cfquery name="get_prom_conditions" datasource="#dsn3#">
				SELECT 
					*
				FROM 
					PROMOTION_CONDITIONS PROM_C,
					PROMOTION_CONDITIONS_PRODUCTS PROM_CP
				WHERE 
					PROM_CP.PROM_CONDITION_ID =PROM_C.PROM_CONDITION_ID AND
					PROM_C.PROMOTION_ID=#get_prom_info.prom_id[currentrow]# 
				ORDER BY
					PROM_CP.PROM_CONDITION_ID,
					PROM_CP.STOCK_ID
			</cfquery>
			<cfset cond_prod_list_=''>
			<cfset use_promotion=0>
			<cfset use_condition_count=0>
			<cfset condition_prod_flag=0>
			<cfif get_prom_conditions.recordcount>
			<cfset is_total_product_amount_condition=valuelist(get_prom_conditions.total_product_amount,';')>
			<cfset is_total_product_price_condition=valuelist(get_prom_conditions.total_product_price,';')>
			<cfif len(is_total_product_amount_condition) or len(is_total_product_price_condition)>
				<cfquery name="get_total_info" dbtype="query">
					SELECT SUM(QUANTITY) TOTAL_QUANTITY, SUM(PRICE_KDV*QUANTITY*RATE2) AS TOTAL_PRICE FROM get_all_pre_order_rows
				</cfquery>
			<cfelse>
				<cfquery name="get_order_rows" dbtype="query">
					SELECT SUM(QUANTITY) QUANTITY,STOCK_ID FROM get_all_pre_order_rows GROUP BY STOCK_ID
				</cfquery>
				<cfset ord_row_list=listsort(valuelist(get_order_rows.STOCK_ID),'numeric','asc')>
			</cfif>
			<cfset prom_condition_id_list=valuelist(get_prom_conditions.prom_condition_id)>
			<cfset cond_prod_list_=''>
			<cfset use_promotion=0>
			<cfset use_condition_count=0>
			<cfset condition_prod_flag=0>
			<cfoutput query="get_prom_conditions">
				<cfset cond_prod_list_=listappend(cond_prod_list_,STOCK_ID)>
				<cfif (get_prom_conditions.prom_condition_id neq get_prom_conditions.prom_condition_id[currentrow+1]) or (currentrow eq get_prom_conditions.recordcount)>
					<cfif not isdefined('condition_prod_flag_#get_prom_conditions.prom_condition_id#')>
						<cfset 'condition_prod_flag_#get_prom_conditions.prom_condition_id#'=0>
					</cfif>
					<cfif not isdefined('condition_flag_#get_prom_conditions.prom_condition_id#')>
						<cfset 'condition_flag_#get_prom_conditions.prom_condition_id#'=0>
					</cfif>
					<cfif len(get_prom_conditions.total_product_amount) and get_prom_conditions.total_product_amount gt 0 and len(get_prom_conditions.total_product_price) and get_prom_conditions.total_product_price gt 0>
						<cfif get_total_info.recordcount and get_total_info.TOTAL_QUANTITY gte get_prom_conditions.total_product_amount and get_total_info.recordcount and wrk_round(get_total_info.TOTAL_PRICE) gte wrk_round(get_prom_conditions.total_product_amount)>
							<cfset 'condition_flag_#get_prom_conditions.prom_condition_id#'=1>
							<cfset use_condition_count =use_condition_count+1>
						</cfif>
					<cfelseif len(get_prom_conditions.total_product_amount) and get_prom_conditions.total_product_amount gt 0><!--- koşul toplam miktara gore --->
						<cfif get_total_info.recordcount and get_total_info.TOTAL_QUANTITY gte get_prom_conditions.total_product_amount>
							<cfset 'condition_flag_#get_prom_conditions.prom_condition_id#'=1>
							<cfset use_condition_count =use_condition_count+1>
						</cfif>
					<cfelseif len(get_prom_conditions.total_product_price) and get_prom_conditions.total_product_price gt 0><!--- koşul toplam tutara gore --->
						<cfif get_total_info.recordcount and wrk_round(get_total_info.TOTAL_PRICE) gte wrk_round(get_prom_conditions.total_product_amount)>
							<cfset 'condition_flag_#get_prom_conditions.prom_condition_id#'=1>
							<cfset use_condition_count =use_condition_count+1>
						</cfif>
					<cfelse> <!--- urunler kontrol ediliyor --->
						<cfloop list="cond_prod_list_" index="cond_s">
							<cfif listfind(ord_row_list,cond_s) and get_order_rows.QUANTITY[listfind(ord_row_list,cond_s)] gte get_prom_conditions.PRODUCT_AMOUNT>
								<cfset condition_prod_flag=condition_prod_flag+1>
								<cfif list_work_type neq 1> <!--- kosulun calısma sekli "veya" ise tek bir koşul ürününü bulunması yeterlidir --->
									<cfset 'condition_flag_#get_prom_conditions.prom_condition_id#'=1>
									<cfset use_condition_count =use_condition_count+1>
									<cfbreak>
								</cfif>
							</cfif>
						</cfloop>
						<cfif condition_prod_flag neq 0 and condition_prod_flag eq listlen(cond_prod_list_)> <!--- kosulun calısma sekli "ve" ise tüm urunler kontrol edilir --->
							<cfset 'condition_flag_#get_prom_conditions.prom_condition_id#'=1>
							<cfset use_condition_count =use_condition_count+1>
						</cfif>
					</cfif>
					<cfset cond_prod_list_=''>
					<cfset condition_prod_flag=''>
				</cfif>
			</cfoutput>
			<cfoutput>
				<cfloop list="prom_condition_id_list" index="cond_id_">
					<cfif isdefined('condition_flag_#cond_id_#') and evaluate('condition_flag_#cond_id_#') eq 1>
						<cfset use_promotion=use_promotion+1>
					</cfif>
				</cfloop>
				<cfif (get_prom_info.condition_list_work_type eq 1 and use_condition_count eq listlen(prom_condition_id_list)) or (get_prom_info.condition_list_work_type neq 1 and use_condition_count gte 1)>
					<cfset use_promotion=1>
				</cfif>
			</cfoutput>
			<cfelseif isdefined('is_only_first_order_#control_prom_id#') and evaluate('is_only_first_order_#control_prom_id#') eq 1>
				<cfset use_promotion=1>
			</cfif>
			<cfif use_promotion>
				<cfset useable_promotion_list=listappend(useable_promotion_list,get_prom_info.prom_id)><!--- promosyon kazanılmıssa --->
			</cfif>
		</cfif>
	</cfloop>
</cfif>
<cfif listlen(useable_promotion_list) neq 0>
	<cfquery name="get_all_useable_prom_products" datasource="#dsn3#">
		SELECT 
			PROM_P.*,GS.SALEABLE_STOCK,S.IS_ZERO_STOCK ,S.IS_INVENTORY,
			S.PROPERTY,S.PRODUCT_NAME,S.PRODUCT_UNIT_ID,
			P.PROM_HEAD,P.PROM_NO,P.PRODUCT_PROMOTION_NONEFFECT
		FROM
			PROMOTIONS P,
			PROMOTION_PRODUCTS PROM_P,
			#dsn2_alias#.GET_STOCK_LAST GS,
			STOCKS S
		WHERE
			P.PROM_ID=PROM_P.PROMOTION_ID AND 
			PROM_P.STOCK_ID=S.STOCK_ID AND
			GS.STOCK_ID=S.STOCK_ID AND
			P.PROM_ID IN (#useable_promotion_list#)
	</cfquery>
<cfif get_all_useable_prom_products.recordcount>
		<table width="100%" cellspacing="1" cellpadding="1" border="0" align="center" class="color-border">
			<tr> 
				<td class="form-title"><cf_get_lang no ='389.Promosyon'>No</td>
				<td class="form-title"><cf_get_lang no ='389.Promosyon'></td>
				<td class="form-title"><cf_get_lang no ='1465.Promosyon Ürünleri'></td>
			</tr>
			<cfloop list="#useable_promotion_list#" index="useable_prom_id">
				<cfquery name="get_useable_prom_" dbtype="query"><!--- sıfır stokla calısan veya envantere dahil olmayan veya satılabilir stogu pormosyon miktarını karsılayabilen kazan urunleri cekiliyor --->
					SELECT 
						* 
					FROM 
						get_all_useable_prom_products 
					WHERE 
						PROMOTION_ID =#useable_prom_id# AND
						(IS_INVENTORY=0 OR IS_ZERO_STOCK=1 OR SALEABLE_STOCK >= PRODUCT_AMOUNT)
				</cfquery>
				<cfif get_useable_prom_.recordcount>
					<tr class="color-row">
						<td><cfoutput>#get_useable_prom_.PROM_NO#</cfoutput></td>
						<td><cfoutput>#get_useable_prom_.PROM_HEAD#</cfoutput></td>
						<td>
							<table>
								<tr>
									<td class="txtbold"><cf_get_lang_main no='809.Ürün Adı'></td>
									<td class="txtbold"><cf_get_lang_main no ='670.Adet'></td>
									<td class="txtbold"><cf_get_lang_main no ='672.Fiyat'></td>
								</tr>
								<cfoutput query="get_useable_prom_">
									<tr>
										<td>#PRODUCT_NAME# <cfif len(PROPERTY)>-#PROPERTY#</cfif></td>
										<td align="right" style="text-align:right;">#PRODUCT_AMOUNT# Adet</td>
										<td align="right" style="text-align:right;">#TLFormat(PRODUCT_PRICE)#</td>
										<td><a href="javascript://" onClick="add_prom_row('#get_useable_prom_.PROMOTION_ID#','#get_useable_prom_.STOCK_ID#',<cfif len(PRODUCT_PROMOTION_NONEFFECT)>#PRODUCT_PROMOTION_NONEFFECT#<cfelse>0</cfif>);window.location.reload();"><img src="/images/plus_list.gif" align="absmiddle" border="0"></a> </td>
									</tr>
								</cfoutput>
							</table>
						</td>
					</tr>				
				</cfif>
			</cfloop>
		</table>
	</cfif>
</cfif>
</cfif>
<script type="text/javascript">
	function add_prom_row(prom_id,prom_stock_id,is_prom_effect)
	{
		AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=objects2.emptypopup_ajax_add_basket_prom_row&prom_id_='+prom_id+'&prom_stock_id_='+prom_stock_id+'&is_prom_effect='+is_prom_effect,'SHOW_LIST_PAGE',1);
	}
</script>
