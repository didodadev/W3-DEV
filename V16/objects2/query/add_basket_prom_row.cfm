<cfif isdefined('attributes.add_prom_id_') and len(attributes.add_prom_id_)>
<cfif not (isdefined('attributes.prom_action_type_') and len(attributes.prom_action_type_))><!--- promosyon ekle-degistir secenegi --->
	<cfset attributes.prom_action_type_=1>
</cfif>
<cfquery name="GET_PROM_STOCK" datasource="#DSN3#">
    SELECT 
        S.PRODUCT_ID,
        S.STOCK_ID,
        S.PRODUCT_UNIT_ID,
        S.PROPERTY,
        S.TAX,
        S.PRODUCT_NAME,
        S.STOCK_CODE,
        PROM_P.PROMOTION_ID,
        PROM_P.IS_NONDELETE_PRODUCT,
        PROM_P.PRODUCT_AMOUNT,
        PROM_P.PRODUCT_PRICE,
        PROM_P.PRODUCT_COST
    FROM 
        PROMOTION_PRODUCTS PROM_P,
        STOCKS S
    WHERE
        PROM_P.STOCK_ID = S.STOCK_ID AND 
        PROM_P.PROMOTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.add_prom_id_#">
    ORDER BY
        S.STOCK_ID
</cfquery>
    
<cfif get_prom_stock.recordcount>
	<cfset _prom_stock_list_=valuelist(get_prom_stock.stock_id)>
	<cflock name="#CREATEUUID()#" timeout="20">
		<cftransaction> 
			<cfloop from="1" to="#attributes.add_prom_prod_count_#" index="pr_i">
				<cfif isdefined('add_prom_stock_id_#pr_i#') and len(evaluate('add_prom_stock_id_#pr_i#')) and isdefined('add_prom_amount_#pr_i#') and len(evaluate('add_prom_amount_#pr_i#'))>
					<cfset add_prom_stock_amount=evaluate('add_prom_amount_#pr_i#')>
					<cfif attributes.prom_action_type_ eq 1><!--- hareket tipi ekle ise --->
						<cfscript>
							add_pre_order_rows(
								stock_id:evaluate('add_prom_stock_id_#pr_i#'),
								stock_amount:add_prom_stock_amount,
								product_unit_id:get_prom_stock.product_unit_id[listfind(_prom_stock_list_,evaluate('add_prom_stock_id_#pr_i#'))],
								is_promotion:1,
								company_id:iif(len(attributes.company_id),de('#attributes.company_id#'),de('')),
								consumer_id:iif(len(attributes.consumer_id),de('#attributes.consumer_id#'),de('')),
								partner_id:iif(len(attributes.partner_id),de('#attributes.partner_id#'),de('')),
								price_catid:-2,
								prom_work_type:1,
								is_nondelete_product:iif(len(get_prom_stock.is_nondelete_product[listfind(_prom_stock_list_,evaluate('add_prom_stock_id_#pr_i#'))]),de('#get_prom_stock.is_nondelete_product[listfind(_prom_stock_list_,evaluate('add_prom_stock_id_#pr_i#'))]#'),de('')),
								is_product_promotion_noneffect:iif(isdefined('attributes.add_prom_prod_noneffect_') and len(attributes.add_prom_prod_noneffect_),de('#attributes.add_prom_prod_noneffect_#'),de('0')),
								is_general_prom:iif(isdefined('attributes.prom_related_stocks') and len(attributes.prom_related_stocks),de('0'),de('1')),
								prom_product_price:iif(len(get_prom_stock.product_price[listfind(_prom_stock_list_,evaluate('add_prom_stock_id_#pr_i#'))]),de('#get_prom_stock.product_price[listfind(_prom_stock_list_,evaluate('add_prom_stock_id_#pr_i#'))]#'),de('')),
								prom_cost: iif(len(get_prom_stock.product_cost[listfind(_prom_stock_list_,evaluate('add_prom_stock_id_#pr_i#'))]),de('#get_prom_stock.product_cost[listfind(_prom_stock_list_,evaluate('add_prom_stock_id_#pr_i#'))]#'),de('')),
								prom_id:attributes.add_prom_id_,
								price:iif(len(get_prom_stock.product_price[listfind(_prom_stock_list_,evaluate('add_prom_stock_id_#pr_i#'))]),de('#get_prom_stock.product_price[listfind(_prom_stock_list_,evaluate('add_prom_stock_id_#pr_i#'))]#'),de('0')),
								price_kdv:iif(len(get_prom_stock.product_price[listfind(_prom_stock_list_,evaluate('add_prom_stock_id_#pr_i#'))]),de('#get_prom_stock.product_price[listfind(_prom_stock_list_,evaluate('add_prom_stock_id_#pr_i#'))]#'),de('0')),
								price_money:session_base.money,
								product_tax:0,
								prom_stock_amount:1,
								is_prom_asil_hediye:1,
								prom_free_stock_id:0,
								price_standard:iif(len(get_prom_stock.product_price[listfind(_prom_stock_list_,evaluate('add_prom_stock_id_#pr_i#'))]),de('#get_prom_stock.product_price[listfind(_prom_stock_list_,evaluate('add_prom_stock_id_#pr_i#'))]#'),de('0')),
								price_standard_kdv:iif(len(get_prom_stock.product_price[listfind(_prom_stock_list_,evaluate('add_prom_stock_id_#pr_i#'))]),de('#get_prom_stock.product_price[listfind(_prom_stock_list_,evaluate('add_prom_stock_id_#pr_i#'))]#'),de('0')),
								price_standard_money:session_base.money,
								to_cons:iif(isdefined('attributes.consumer_id') and len(attributes.consumer_id),de('#attributes.consumer_id#'),de('')),
								to_comp:iif(isdefined('attributes.company_id') and len(attributes.company_id),de('#attributes.company_id#'),de('')),
								to_par:iif(isdefined('attributes.partner_id') and len(attributes.partner_id),de('#attributes.partner_id#'),de(''))
							);
						</cfscript>
					<cfelseif listfind('2,3',attributes.prom_action_type_)><!--- hareket tipi: değiştir - ekle veya degiştir  --->
						<cfquery name="CONTROL_SAME_PROD_" datasource="#DSN3#">
							SELECT 
								ORDER_ROW_ID,STOCK_ID,QUANTITY,PRE_STOCK_AMOUNT,PRICE,PRICE_KDV,PROM_ID,PRICE_MONEY
							FROM
								ORDER_PRE_ROWS
							WHERE
								STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('add_prom_stock_id_#pr_i#')#">
								AND ISNULL(PRE_STOCK_ID,STOCK_ID) = <cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('add_prom_stock_id_#pr_i#')#">
								AND PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_prom_stock.product_id[listfind(_prom_stock_list_,evaluate('add_prom_stock_id_#pr_i#'))]#">
								<!--- AND ISNULL(PROM_ID,0)<>#attributes.add_prom_id_# --->
								<!--- AND ISNULL(IS_PROM_ASIL_HEDIYE,0)=0 --->
								AND ISNULL(IS_COMMISSION,0)=0
								<cfif isdefined('attributes.consumer_id') and len(attributes.consumer_id)>
                                    AND TO_CONS = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
                                <!--- <cfelse>
                                    AND TO_CONS IS NULL --->
                                </cfif>
                                <cfif isdefined('attributes.company_id') and len(attributes.company_id)>
                                    AND TO_COMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
                                <!--- <cfelse>
                                    AND TO_COMP IS NULL --->
                                </cfif>
                                <cfif isdefined('attributes.partner_id') and len(attributes.partner_id)>
                                    AND TO_PAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.partner_id#">
                                <!--- <cfelse>
                                    AND TO_PAR IS NULL --->
                                </cfif>
								AND RECORD_PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.period_id#">
								<cfif isdefined("session.pp")>AND RECORD_PAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#"><cfelse>AND RECORD_PAR IS NULL</cfif>
                                <cfif isdefined("session.ww.userid")>AND RECORD_CONS = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#"><cfelse>AND RECORD_CONS IS NULL</cfif>
                                <cfif isdefined("session.ep.userid")>AND RECORD_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"><cfelse>AND RECORD_EMP IS NULL</cfif>
                        	ORDER BY QUANTITY DESC
						</cfquery>
						<cfif control_same_prod_.recordcount>
							<cfif len(control_same_prod_.prom_id) and control_same_prod_.prom_id eq attributes.add_prom_id_ and attributes.prom_action_type_ eq 3><!--- ekle-değiştirse, sepette aynı promosyona ait aynı kazanc urununden bulursa degiştirme yerine miktarı arttırır --->
								<cfif len(get_prom_stock.product_price[listfind(_prom_stock_list_,evaluate('add_prom_stock_id_#pr_i#'))])>
									<cfset row_price_=wrk_round(((get_prom_stock.product_price[listfind(_prom_stock_list_,evaluate('add_prom_stock_id_#pr_i#'))])/(100+get_prom_stock.tax[listfind(_prom_stock_list_,evaluate('add_prom_stock_id_#pr_i#'))])*100),4)>
								<cfelse>
									<cfset row_price_=0>
								</cfif>
								<cfquery name="ADD_MAIN_PRODUCT_" datasource="#DSN3#">
									UPDATE
										ORDER_PRE_ROWS
									SET
										<cfif not len(control_same_prod_.prom_id)><!--- promosyonlar silindiginde bu satır standart urun satırı oldugundan  geri alınacaktır, promosyon satır urunuyle update edilmiş --->
                                            PROD_PROM_ACTION_TYPE=1,
                                            PRICE_OLD_2=#control_same_prod_.price#,
                                            price_old_money_2 = '#control_same_prod_.price_money#',
                                            price_kdv_old=#control_same_prod_.price_kdv#,
                                            quantity_old=#control_same_prod_.quantity#,
										</cfif>
										PROM_WORK_TYPE=1,
										IS_NONDELETE_PRODUCT=<cfif len(get_prom_stock.is_nondelete_product[listfind(_prom_stock_list_,evaluate('add_prom_stock_id_#pr_i#'))])>#get_prom_stock.is_nondelete_product[listfind(_prom_stock_list_,evaluate('add_prom_stock_id_#pr_i#'))]#<cfelse>NULL</cfif>,
										QUANTITY=#control_same_prod_.quantity+add_prom_stock_amount#,
										PRE_STOCK_AMOUNT=#control_same_prod_.quantity#,
										PRICE=#row_price_#,
										PRICE_KDV=<cfif len(get_prom_stock.product_price[listfind(_prom_stock_list_,evaluate('add_prom_stock_id_#pr_i#'))])>#get_prom_stock.product_price[listfind(_prom_stock_list_,evaluate('add_prom_stock_id_#pr_i#'))]#<cfelse>0</cfif>,
										PRICE_MONEY=<cfif isdefined('session.pp')>'#session.pp.money#'<cfelseif isdefined('session.ww')>'#session.ww.money#'<cfelse>'#session.ep.money#'</cfif>,
										<!--- TAX=0, --->
										STOCK_ACTION_ID=0,
										PROM_STOCK_AMOUNT=1,
										IS_PROM_ASIL_HEDIYE=1,
										IS_PRODUCT_PROMOTION_NONEFFECT=	<cfif isdefined('attributes.add_prom_prod_noneffect_') and len(attributes.add_prom_prod_noneffect_)>#attributes.add_prom_prod_noneffect_#<cfelse>0</cfif>,
										PROM_ID=#attributes.add_prom_id_#,
										PROM_COST=<cfif len(get_prom_stock.product_cost[listfind(_prom_stock_list_,evaluate('add_prom_stock_id_#pr_i#'))])>#get_prom_stock.product_cost[listfind(_prom_stock_list_,evaluate('add_prom_stock_id_#pr_i#'))]#<cfelse>0</cfif>,
										PROM_PRODUCT_PRICE = <cfif len(get_prom_stock.product_price[listfind(_prom_stock_list_,evaluate('add_prom_stock_id_#pr_i#'))])>#get_prom_stock.product_price[listfind(_prom_stock_list_,evaluate('add_prom_stock_id_#pr_i#'))]#<cfelse>NULL</cfif>,
										IS_GENERAL_PROM = <cfif isdefined('attributes.prom_related_stocks') and len(attributes.prom_related_stocks)>0<cfelse>1</cfif><!--- promosyon genel tutar veya genel toplama uygulanmıssa --->
										<!--- PRICE_STANDARD=#get_prom_products.product_price#,
										PRICE_STANDARD_KDV=#get_prom_products.product_price#,
										PRICE_STANDARD_MONEY=<cfif isdefined('session.pp')>'#session.pp.money#'<cfelseif isdefined('session.ww')>'#session.ww.money#'<cfelse>'#session.ep.money#'</cfif>
									 --->
									WHERE
										ORDER_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#control_same_prod_.order_row_id#">
										AND STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#control_same_prod_.stock_id#">
								</cfquery>		
							<cfelse>
								<cfif control_same_prod_.quantity lte add_prom_stock_amount>
									<cfif len(get_prom_stock.product_price[listfind(_prom_stock_list_,evaluate('add_prom_stock_id_#pr_i#'))])>
										<cfset row_price_=wrk_round(((get_prom_stock.product_price[listfind(_prom_stock_list_,evaluate('add_prom_stock_id_#pr_i#'))])/(100+get_prom_stock.tax[listfind(_prom_stock_list_,evaluate('add_prom_stock_id_#pr_i#'))])*100),4)>
									<cfelse>
										<cfset row_price_=0>
									</cfif>
									<cfquery name="ADD_MAIN_PRODUCT_" datasource="#DSN3#">
										UPDATE
											ORDER_PRE_ROWS
										SET
											<cfif not len(control_same_prod_.PROM_ID)><!--- promosyonlar silindiginde bu satır standart urun satırı oldugundan  geri alınacaktır, promosyon satır urunuyle update edilmiş --->
                                                PROD_PROM_ACTION_TYPE=1,
                                                PRICE_OLD_2=#control_same_prod_.price#,
                                                PRICE_OLD_MONEY_2 = '#control_same_prod_.price_money#',
                                                PRICE_KDV_OLD=#control_same_prod_.price_kdv#,
                                                QUANTITY_OLD=#control_same_prod_.quantity#,
											</cfif>
											PROM_WORK_TYPE=1,
											IS_NONDELETE_PRODUCT=<cfif len(get_prom_stock.is_nondelete_product[listfind(_prom_stock_list_,evaluate('add_prom_stock_id_#pr_i#'))])>#get_prom_stock.IS_NONDELETE_PRODUCT[listfind(_prom_stock_list_,evaluate('add_prom_stock_id_#pr_i#'))]#<cfelse>NULL</cfif>,
											QUANTITY=#control_same_prod_.quantity#,
											PRE_STOCK_AMOUNT=#control_same_prod_.quantity#,
											PRICE=#row_price_#,
											PRICE_KDV=<cfif len(get_prom_stock.PRODUCT_PRICE[listfind(_prom_stock_list_,evaluate('add_prom_stock_id_#pr_i#'))])>#get_prom_stock.PRODUCT_PRICE[listfind(_prom_stock_list_,evaluate('add_prom_stock_id_#pr_i#'))]#<cfelse>0</cfif>,
											PRICE_MONEY=<cfif isdefined('session.pp')>'#session.pp.money#'<cfelseif isdefined('session.ww')>'#session.ww.money#'<cfelse>'#session.ep.money#'</cfif>,
											<!--- TAX=0, --->
											STOCK_ACTION_ID=0,
											PROM_STOCK_AMOUNT=1,
											IS_PROM_ASIL_HEDIYE=1,
											IS_PRODUCT_PROMOTION_NONEFFECT=	<cfif isdefined('attributes.add_prom_prod_noneffect_') and len(attributes.add_prom_prod_noneffect_)>#attributes.add_prom_prod_noneffect_#<cfelse>0</cfif>,
											PROM_ID=#attributes.add_prom_id_#,
											PROM_COST=<cfif len(get_prom_stock.PRODUCT_COST[listfind(_prom_stock_list_,evaluate('add_prom_stock_id_#pr_i#'))])>#get_prom_stock.PRODUCT_COST[listfind(_prom_stock_list_,evaluate('add_prom_stock_id_#pr_i#'))]#<cfelse>0</cfif>,
											PROM_PRODUCT_PRICE = <cfif len(get_prom_stock.PRODUCT_PRICE[listfind(_prom_stock_list_,evaluate('add_prom_stock_id_#pr_i#'))])>#get_prom_stock.PRODUCT_PRICE[listfind(_prom_stock_list_,evaluate('add_prom_stock_id_#pr_i#'))]#<cfelse>NULL</cfif>,
											IS_GENERAL_PROM = <cfif isdefined('attributes.prom_related_stocks') and len(attributes.prom_related_stocks)>0<cfelse>1</cfif><!--- promosyon genel tutar veya genel toplama uygulanmıssa --->
											<!--- PRICE_STANDARD=#get_prom_products.product_price#,
											PRICE_STANDARD_KDV=#get_prom_products.product_price#,
											PRICE_STANDARD_MONEY=<cfif isdefined('session.pp')>'#session.pp.money#'<cfelseif isdefined('session.ww')>'#session.ww.money#'<cfelse>'#session.ep.money#'</cfif>
										 --->
										WHERE
											ORDER_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#control_same_prod_.order_row_id#">
											AND STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#control_same_prod_.stock_id#">
									</cfquery>		
									<cfif (add_prom_stock_amount-control_same_prod_.QUANTITY) gt 0 and attributes.prom_action_type_ eq 3> <!--- promosyon miktarı fazlaysa ekle-degiştir tipinde fazla olan kısım yeni satır olarak eklenir --->
										<cfscript>
											add_pre_order_rows(
												stock_id:evaluate('add_prom_stock_id_#pr_i#'),
												stock_amount:wrk_round((add_prom_stock_amount-control_same_prod_.QUANTITY)),
												product_unit_id:get_prom_stock.PRODUCT_UNIT_ID[listfind(_prom_stock_list_,evaluate('add_prom_stock_id_#pr_i#'))],
												is_promotion:1,
												company_id:iif(len(attributes.company_id),de('#attributes.company_id#'),de('')),
												consumer_id:iif(len(attributes.consumer_id),de('#attributes.consumer_id#'),de('')),
												partner_id:iif(len(attributes.partner_id),de('#attributes.partner_id#'),de('')),
												price_catid:-2,
												prom_work_type:1,
												is_nondelete_product:iif(len(get_prom_stock.IS_NONDELETE_PRODUCT[listfind(_prom_stock_list_,evaluate('add_prom_stock_id_#pr_i#'))]),de('#get_prom_stock.IS_NONDELETE_PRODUCT[listfind(_prom_stock_list_,evaluate('add_prom_stock_id_#pr_i#'))]#'),de('')),
												is_product_promotion_noneffect:iif(isdefined('attributes.add_prom_prod_noneffect_') and len(attributes.add_prom_prod_noneffect_),de('#attributes.add_prom_prod_noneffect_#'),de('0')),
												is_general_prom:iif(isdefined('attributes.prom_related_stocks') and len(attributes.prom_related_stocks),de('0'),de('1')),
												prom_product_price:iif(len(get_prom_stock.PRODUCT_PRICE[listfind(_prom_stock_list_,evaluate('add_prom_stock_id_#pr_i#'))]),de('#get_prom_stock.PRODUCT_PRICE[listfind(_prom_stock_list_,evaluate('add_prom_stock_id_#pr_i#'))]#'),de('')),
												prom_cost: iif(len(get_prom_stock.PRODUCT_COST[listfind(_prom_stock_list_,evaluate('add_prom_stock_id_#pr_i#'))]),de('#get_prom_stock.PRODUCT_COST[listfind(_prom_stock_list_,evaluate('add_prom_stock_id_#pr_i#'))]#'),de('')),
												prom_id:attributes.add_prom_id_,
												price:iif(len(get_prom_stock.PRODUCT_PRICE[listfind(_prom_stock_list_,evaluate('add_prom_stock_id_#pr_i#'))]),de('#get_prom_stock.PRODUCT_PRICE[listfind(_prom_stock_list_,evaluate('add_prom_stock_id_#pr_i#'))]#'),de('0')),
												price_kdv:iif(len(get_prom_stock.PRODUCT_PRICE[listfind(_prom_stock_list_,evaluate('add_prom_stock_id_#pr_i#'))]),de('#get_prom_stock.PRODUCT_PRICE[listfind(_prom_stock_list_,evaluate('add_prom_stock_id_#pr_i#'))]#'),de('0')),
												price_money:session_base.money,
												product_tax:0,
												prom_stock_amount:1,
												IS_PROM_ASIL_HEDIYE:1,
												PROM_FREE_STOCK_ID:0,
												PRICE_STANDARD:iif(len(get_prom_stock.PRODUCT_PRICE[listfind(_prom_stock_list_,evaluate('add_prom_stock_id_#pr_i#'))]),de('#get_prom_stock.PRODUCT_PRICE[listfind(_prom_stock_list_,evaluate('add_prom_stock_id_#pr_i#'))]#'),de('0')),
												PRICE_STANDARD_KDV:iif(len(get_prom_stock.PRODUCT_PRICE[listfind(_prom_stock_list_,evaluate('add_prom_stock_id_#pr_i#'))]),de('#get_prom_stock.PRODUCT_PRICE[listfind(_prom_stock_list_,evaluate('add_prom_stock_id_#pr_i#'))]#'),de('0')),
												PRICE_STANDARD_MONEY:session_base.money,
												TO_CONS:iif(isdefined('attributes.consumer_id') and len(attributes.consumer_id),de('#attributes.consumer_id#'),de('')),
												TO_COMP:iif(isdefined('attributes.company_id') and len(attributes.company_id),de('#attributes.company_id#'),de('')),
												TO_PAR:iif(isdefined('attributes.partner_id') and len(attributes.partner_id),de('#attributes.partner_id#'),de(''))
											);
										</cfscript>
									</cfif>
								<cfelseif control_same_prod_.QUANTITY gt add_prom_stock_amount>
									<cfquery name="add_main_product_" datasource="#dsn3#"><!--- satır miktarından promosyon olarak ayrılan bolum cıkarılıyor--->
										UPDATE
											ORDER_PRE_ROWS
										SET
											QUANTITY=#control_same_prod_.QUANTITY-add_prom_stock_amount#,
											PRE_STOCK_AMOUNT=#control_same_prod_.QUANTITY#,
											QUANTITY_OLD=#control_same_prod_.QUANTITY#, <!--- promosyonlar silindiginde bu miktarlar geri alınacak --->
											PROD_PROM_ACTION_TYPE=1
										WHERE
											ORDER_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#control_same_prod_.order_row_id#">
											AND STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#control_same_prod_.stock_id#">
									</cfquery>
									<cfscript>
										add_pre_order_rows(
											stock_id:evaluate('add_prom_stock_id_#pr_i#'),
											stock_amount:add_prom_stock_amount,
											product_unit_id:get_prom_stock.PRODUCT_UNIT_ID[listfind(_prom_stock_list_,evaluate('add_prom_stock_id_#pr_i#'))],
											is_promotion:1,
											company_id:iif(len(attributes.company_id),de('#attributes.company_id#'),de('')),
											consumer_id:iif(len(attributes.consumer_id),de('#attributes.consumer_id#'),de('')),
											partner_id:iif(len(attributes.partner_id),de('#attributes.partner_id#'),de('')),
											price_catid:-2,
											prom_work_type:1,
											is_nondelete_product:iif(len(get_prom_stock.IS_NONDELETE_PRODUCT[listfind(_prom_stock_list_,evaluate('add_prom_stock_id_#pr_i#'))]),de('#get_prom_stock.IS_NONDELETE_PRODUCT[listfind(_prom_stock_list_,evaluate('add_prom_stock_id_#pr_i#'))]#'),de('')),
											is_product_promotion_noneffect:iif(isdefined('attributes.add_prom_prod_noneffect_') and len(attributes.add_prom_prod_noneffect_),de('#attributes.add_prom_prod_noneffect_#'),de('0')),
											is_general_prom:iif(isdefined('attributes.prom_related_stocks') and len(attributes.prom_related_stocks),de('0'),de('1')),
											prom_product_price:iif(len(get_prom_stock.PRODUCT_PRICE[listfind(_prom_stock_list_,evaluate('add_prom_stock_id_#pr_i#'))]),de('#get_prom_stock.PRODUCT_PRICE[listfind(_prom_stock_list_,evaluate('add_prom_stock_id_#pr_i#'))]#'),de('')),
											prom_cost: iif(len(get_prom_stock.PRODUCT_COST[listfind(_prom_stock_list_,evaluate('add_prom_stock_id_#pr_i#'))]),de('#get_prom_stock.PRODUCT_COST[listfind(_prom_stock_list_,evaluate('add_prom_stock_id_#pr_i#'))]#'),de('')),
											prom_id:attributes.add_prom_id_,
											price:iif(len(get_prom_stock.PRODUCT_PRICE[listfind(_prom_stock_list_,evaluate('add_prom_stock_id_#pr_i#'))]),de('#get_prom_stock.PRODUCT_PRICE[listfind(_prom_stock_list_,evaluate('add_prom_stock_id_#pr_i#'))]#'),de('0')),
											price_kdv:iif(len(get_prom_stock.PRODUCT_PRICE[listfind(_prom_stock_list_,evaluate('add_prom_stock_id_#pr_i#'))]),de('#get_prom_stock.PRODUCT_PRICE[listfind(_prom_stock_list_,evaluate('add_prom_stock_id_#pr_i#'))]#'),de('0')),
											price_money:session_base.money,
											product_tax:0,
											prom_stock_amount:1,
											IS_PROM_ASIL_HEDIYE:1,
											PROM_FREE_STOCK_ID:0,
											PRICE_STANDARD:iif(len(get_prom_stock.PRODUCT_PRICE[listfind(_prom_stock_list_,evaluate('add_prom_stock_id_#pr_i#'))]),de('#get_prom_stock.PRODUCT_PRICE[listfind(_prom_stock_list_,evaluate('add_prom_stock_id_#pr_i#'))]#'),de('0')),
											PRICE_STANDARD_KDV:iif(len(get_prom_stock.PRODUCT_PRICE[listfind(_prom_stock_list_,evaluate('add_prom_stock_id_#pr_i#'))]),de('#get_prom_stock.PRODUCT_PRICE[listfind(_prom_stock_list_,evaluate('add_prom_stock_id_#pr_i#'))]#'),de('0')),
											PRICE_STANDARD_MONEY:session_base.money,
											TO_CONS:iif(isdefined('attributes.consumer_id') and len(attributes.consumer_id),de('#attributes.consumer_id#'),de('')),
											TO_COMP:iif(isdefined('attributes.company_id') and len(attributes.company_id),de('#attributes.company_id#'),de('')),
											TO_PAR:iif(isdefined('attributes.partner_id') and len(attributes.partner_id),de('#attributes.partner_id#'),de(''))
										);
									</cfscript>
								</cfif>
							</cfif>
						<cfelseif attributes.prom_action_type_ eq 3><!--- hareket tipi ekle veya değiştir ise ve ürün bulunamazsa promosyonu ekliyor --->
							<cfscript>
							add_pre_order_rows(
								stock_id:evaluate('add_prom_stock_id_#pr_i#'),
								stock_amount:add_prom_stock_amount,
								product_unit_id:get_prom_stock.PRODUCT_UNIT_ID[listfind(_prom_stock_list_,evaluate('add_prom_stock_id_#pr_i#'))],
								is_promotion:1,
								company_id:iif(len(attributes.company_id),de('#attributes.company_id#'),de('')),
								consumer_id:iif(len(attributes.consumer_id),de('#attributes.consumer_id#'),de('')),
								partner_id:iif(len(attributes.partner_id),de('#attributes.partner_id#'),de('')),
								price_catid:-2,
								prom_work_type:1,
								is_nondelete_product:iif(len(get_prom_stock.IS_NONDELETE_PRODUCT[listfind(_prom_stock_list_,evaluate('add_prom_stock_id_#pr_i#'))]),de('#get_prom_stock.IS_NONDELETE_PRODUCT[listfind(_prom_stock_list_,evaluate('add_prom_stock_id_#pr_i#'))]#'),de('')),
								is_product_promotion_noneffect:iif(isdefined('attributes.add_prom_prod_noneffect_') and len(attributes.add_prom_prod_noneffect_),de('#attributes.add_prom_prod_noneffect_#'),de('0')),
								is_general_prom:iif(isdefined('attributes.prom_related_stocks') and len(attributes.prom_related_stocks),de('0'),de('1')),
								prom_product_price:iif(len(get_prom_stock.PRODUCT_PRICE[listfind(_prom_stock_list_,evaluate('add_prom_stock_id_#pr_i#'))]),de('#get_prom_stock.PRODUCT_PRICE[listfind(_prom_stock_list_,evaluate('add_prom_stock_id_#pr_i#'))]#'),de('')),
								prom_cost: iif(len(get_prom_stock.PRODUCT_COST[listfind(_prom_stock_list_,evaluate('add_prom_stock_id_#pr_i#'))]),de('#get_prom_stock.PRODUCT_COST[listfind(_prom_stock_list_,evaluate('add_prom_stock_id_#pr_i#'))]#'),de('')),
								prom_id:attributes.add_prom_id_,
								price:iif(len(get_prom_stock.PRODUCT_PRICE[listfind(_prom_stock_list_,evaluate('add_prom_stock_id_#pr_i#'))]),de('#get_prom_stock.PRODUCT_PRICE[listfind(_prom_stock_list_,evaluate('add_prom_stock_id_#pr_i#'))]#'),de('0')),
								price_kdv:iif(len(get_prom_stock.PRODUCT_PRICE[listfind(_prom_stock_list_,evaluate('add_prom_stock_id_#pr_i#'))]),de('#get_prom_stock.PRODUCT_PRICE[listfind(_prom_stock_list_,evaluate('add_prom_stock_id_#pr_i#'))]#'),de('0')),
								price_money:session_base.money,
								product_tax:0,
								prom_stock_amount:1,
								IS_PROM_ASIL_HEDIYE:1,
								PROM_FREE_STOCK_ID:0,
								PRICE_STANDARD:iif(len(get_prom_stock.PRODUCT_PRICE[listfind(_prom_stock_list_,evaluate('add_prom_stock_id_#pr_i#'))]),de('#get_prom_stock.PRODUCT_PRICE[listfind(_prom_stock_list_,evaluate('add_prom_stock_id_#pr_i#'))]#'),de('0')),
								PRICE_STANDARD_KDV:iif(len(get_prom_stock.PRODUCT_PRICE[listfind(_prom_stock_list_,evaluate('add_prom_stock_id_#pr_i#'))]),de('#get_prom_stock.PRODUCT_PRICE[listfind(_prom_stock_list_,evaluate('add_prom_stock_id_#pr_i#'))]#'),de('0')),
								PRICE_STANDARD_MONEY:session_base.money,
								TO_CONS:iif(isdefined('attributes.consumer_id') and len(attributes.consumer_id),de('#attributes.consumer_id#'),de('')),
								TO_COMP:iif(isdefined('attributes.company_id') and len(attributes.company_id),de('#attributes.company_id#'),de('')),
								TO_PAR:iif(isdefined('attributes.partner_id') and len(attributes.partner_id),de('#attributes.partner_id#'),de(''))
							);
						</cfscript>
						</cfif><!--- urun varsa guncelliyor --->
					</cfif>
				</cfif> 
			</cfloop>
			</cftransaction>
		</cflock>
	</cfif>
</cfif>
<form name="send_form_to_basket_" action="<cfoutput>#request.self#?fuseaction=objects2.list_basket</cfoutput>"method="post">
	<input type="hidden" name="is_from_add_prom_prod" id="is_from_add_prom_prod" value="1">
	<input type="hidden" name="run_basket_promotions" id="run_basket_promotions" value="1">
</form>
<script type="text/javascript"> 
	document.send_form_to_basket_.submit();
</script>
<!--- <cflocation url="#request.self#?fuseaction=objects2.list_basket&run_proms=1" addtoken="no"> --->
