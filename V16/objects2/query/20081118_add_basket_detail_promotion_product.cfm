<!--- order_pre_rows kayıtları cekilerek bu ürünlerin detaylı promosyonları incelenir OZDEN20081106--->
<!---PROM_TYPE 2:dönemsel, 0:sipariş bazlı promosyon  --->
<cfif get_all_pre_order_rows.recordcount>
	<cfset ord_row_list=''>
	<cfset used_prom_id_list=''>
	<cfset pre_order_promotion_list_=listdeleteduplicates(valuelist(get_all_pre_order_rows.PROM_ID))>
	 <cfquery name="get_prom_info" datasource="#dsn3#"><!--- sipariş bazlı oncelikli promosyon alınıyor --->
		SELECT 
			PROM_ID,PROM_TYPE,IS_ONLY_FIRST_ORDER,PROM_WORK_COUNT,ONLY_SAME_PRODUCT,CONDITION_LIST_WORK_TYPE,PRODUCT_PROMOTION_NONEFFECT
		FROM 
			PROMOTIONS 
		WHERE 
			<cfif isdefined('attributes.price_catid') and len(attributes.price_catid)>
			PRICE_CATID=#attributes.price_catid# AND
			<cfelse>
			PRICE_CATID=-2 AND
			</cfif>
			IS_DETAIL=1 AND
			LIST_WORK_TYPE=1 AND <!--- kazanclar çalışma şekli 've' olan promosyonlar --->
			PROM_STATUS=1 AND
			--PROM_TYPE=0 AND
			--PROM_ID=212 AND 
			STARTDATE <=#CreateODBCDateTime(now())# AND
			FINISHDATE >=#CreateODBCDateTime(now())#
			<cfif isdefined('pre_order_promotion_list_') and len(pre_order_promotion_list_)>
			AND PROM_ID NOT IN (#pre_order_promotion_list_#)
			</cfif>
		ORDER BY PROM_HIERARCHY
	</cfquery>
	<cfif get_prom_info.recordcount>
		<cfloop query="get_prom_info">
			<cfif listfind(used_prom_id_list,get_prom_info.prom_id[currentrow-1]) or get_prom_info.PROM_TYPE eq 2>
				<cfinclude template="get_basket_rows_for_promotion.cfm"><!--- yeni eklenen promosyonlarla beraber siparis satırları alınıyor --->
			</cfif>
			<!--- <cfif get_prom_info.PROM_TYPE eq 2><!--- donem bazında promosyon ise baslangıc-bitis tarihleri arasındaki kayıtlı siparis bilgileri dahil edilir --->
				<cfquery name="get_all_other_orders" datasource="#dsn3#">
					SELECT 
						ORD_R.QUANTITY,
						ORD_R.STOCK_ID,
						ORD_R.PRODUCT_ID,
						ORD_R.IS_GENERAL_PROM,
						ORD_R.IS_PRODUCT_PROMOTION_NONEFFECT,
						ORD.NETTOTAL
					FROM
						ORDERS ORD,
						ORDER_ROW ORD_R
					WHERE
						ORD.ORDER_ID=ORD_R.ORDER_ID AND
					<cfif isdefined('attributes.consumer_id') and len(attributes.consumer_id)>
						ORD.CONSUMER_ID=#attributes.consumer_id#
					<cfelseif isdefined('attributes.company_id') and len(attributes.company_id)>
						ORD.COMPANY_ID=#attributes.company_id# AND
						ORD.PARTNER_ID=#attributes.partner_id#
					</cfif>
						
				</cfquery>
				<cfdump var="#get_all_other_orders#">
			</cfif> --->
			<cfset control_prom_id=get_prom_info.prom_id>
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
						ORDR.PROM_ID=#control_prom_id# AND
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
			<cfset is_prom_stock_list=''>
			<cfset add_prom_stock_list=''>
			<cfif is_prom_flag><!--- promosyon calısma sayısı asılmamıssa --->
				<cfquery name="get_prom_conditions" datasource="#dsn3#">
					SELECT 
						PROM_C.TOTAL_PRODUCT_AMOUNT,PROM_C.TOTAL_PRODUCT_PRICE,*
					FROM 
						PROMOTION_CONDITIONS PROM_C,
						PROMOTION_CONDITIONS_PRODUCTS PROM_CP
					WHERE 
						PROM_CP.PROM_CONDITION_ID =PROM_C.PROM_CONDITION_ID AND
						PROM_C.PROMOTION_ID=#control_prom_id# 
					ORDER BY
						PROM_CP.PROM_CONDITION_ID,
						PROM_CP.STOCK_ID
				</cfquery>
				<cfscript>
				cond_prod_list_='';
				use_promotion=0;
				use_condition_count=0;
				condition_prod_flag=0;
				if( get_prom_conditions.recordcount neq 0)
				{
					is_total_product_amount_condition=listsort(valuelist(get_prom_conditions.total_product_amount,';'),'numeric','asc',';');
					is_total_product_price_condition=listsort(valuelist(get_prom_conditions.total_product_price,';'),'numeric','asc',';');
				
					if(listlen(is_total_product_amount_condition,';') or listlen(is_total_product_price_condition,';') )
						get_total_info=cfquery(dbtype:'query',datasource:'',sqlstring:"SELECT SUM(QUANTITY) TOTAL_QUANTITY, SUM(PRICE_KDV*QUANTITY*RATE2) AS TOTAL_PRICE FROM get_all_pre_order_rows");
					else
					{
						get_order_rows=cfquery(dbtype:'query',datasource:'',sqlstring:'SELECT SUM(QUANTITY) QUANTITY,STOCK_ID FROM get_all_pre_order_rows GROUP BY STOCK_ID');
						ord_row_list=listsort(valuelist(get_order_rows.STOCK_ID),'numeric','asc');
					}
					prom_condition_id_list=listdeleteduplicates(valuelist(get_prom_conditions.prom_condition_id));
					for(kk=0;kk lte get_prom_conditions.recordcount; kk=kk+1)
					{
						cond_prod_list_=listappend(cond_prod_list_,get_prom_conditions.STOCK_ID[kk]);
						if(get_prom_conditions.recordcount eq 1 or (get_prom_conditions.prom_condition_id[kk] neq get_prom_conditions.prom_condition_id[kk+1]) or (kk eq get_prom_conditions.recordcount))
						{
							if(not isdefined('condition_flag_#get_prom_conditions.prom_condition_id[kk]#'))
								'condition_flag_#get_prom_conditions.prom_condition_id[kk]#'=0;
							if(len(get_prom_conditions.total_product_amount[kk]) and get_prom_conditions.total_product_amount[kk] gt 0 and len(get_prom_conditions.total_product_price[kk]) and get_prom_conditions.total_product_price[kk] gt 0)
							{
								if(get_total_info.recordcount and get_total_info.TOTAL_QUANTITY gte get_prom_conditions.total_product_amount[kk] and get_total_info.recordcount and wrk_round(get_total_info.TOTAL_PRICE) gte wrk_round(get_prom_conditions.total_product_amount[kk]) )
								{
									'condition_flag_#get_prom_conditions.prom_condition_id[kk]#'=1;
									use_condition_count =use_condition_count+1;
								}
							}
							else if(len(get_prom_conditions.total_product_amount[kk]) and get_prom_conditions.total_product_amount[kk] gt 0) //koşul toplam miktara gore
							{
								if(get_total_info.recordcount and get_total_info.TOTAL_QUANTITY gte get_prom_conditions.total_product_amount[kk])
								{
									'condition_flag_#get_prom_conditions.prom_condition_id[kk]#'=1;
									use_condition_count =use_condition_count+1;
								}
							}
							else if(len(get_prom_conditions.total_product_price[kk]) and get_prom_conditions.total_product_price[kk] gt 0) //koşul toplam tutara gore
							{	
								if(get_total_info.recordcount and wrk_round(get_total_info.TOTAL_PRICE) gte wrk_round(get_prom_conditions.total_product_amount[kk]))
								{
									'condition_flag_#get_prom_conditions.prom_condition_id[kk]#'=1;
									use_condition_count =use_condition_count+1;
								}
							}
							else //urunler kontrol ediliyor
							{writeoutput("<br/>dd#cond_prod_list_#dd<br/>");
								for(nn=1;nn lte listlen(cond_prod_list_); nn=nn+1)
								{
									cond_s=listgetat(cond_prod_list_,nn);
									writeoutput("<br/>*******#ord_row_list#-----#cond_s#--#get_order_rows.QUANTITY[listfind(ord_row_list,cond_s)]#---#get_prom_conditions.PRODUCT_AMOUNT[kk]#******<br/>");
									if(listfind(ord_row_list,cond_s) and get_order_rows.QUANTITY[listfind(ord_row_list,cond_s)] gte get_prom_conditions.PRODUCT_AMOUNT[kk])
									{
										condition_prod_flag=condition_prod_flag+1;
										is_prom_stock_list=listappend(is_prom_stock_list,cond_s); //promosyon kazandıran urunler
										if(len(get_prom_info.ONLY_SAME_PRODUCT) and get_prom_info.ONLY_SAME_PRODUCT eq 1)
											add_prom_stock_list=listappend(add_prom_stock_list,('#cond_s#-#get_prom_conditions.PRODUCT_AMOUNT[kk]#'),';');
										writeoutput("***********#get_prom_conditions.list_work_type[kk]#***********");
										if(len(get_prom_conditions.list_work_type[kk]) and get_prom_conditions.list_work_type[kk] neq 1) //kosulun calısma sekli "veya" ise tek bir koşul ürününü bulunması yeterlidir
										{
											writeoutput("cccccccc");
											'condition_flag_#get_prom_conditions.prom_condition_id[kk]#'=1;
											writeoutput('#get_prom_conditions.prom_condition_id[kk]#--aaa--<br/>');
											use_condition_count =use_condition_count+1;
											break;
										}
									} 
								}
								if(condition_prod_flag neq 0 and condition_prod_flag eq listlen(cond_prod_list_)) //kosulun calısma sekli "ve" ise tüm urunler kontrol edilir
								{
									'condition_flag_#get_prom_conditions.prom_condition_id[kk]#'=1;
									use_condition_count =use_condition_count+1;
								}
								if(get_prom_info.condition_list_work_type neq 1 and use_condition_count gte 1) //promosyon veya kosuluyla calısıyorsa bir kosulun saglanmasıyla promosyon kazanılmıs olur
								{
									use_promotion=1;
									break;
								}
							}
							cond_prod_list_='';
						}
					}		
				}
				for(tt=1; tt lte listlen(prom_condition_id_list); tt=tt+1)
				{
					cond_id_=listgetat(prom_condition_id_list,tt);
					if(isdefined('condition_flag_#cond_id_#') and evaluate('condition_flag_#cond_id_#') eq 1)
						use_promotion=use_promotion+1;
				}
				if((get_prom_info.condition_list_work_type eq 1 and use_condition_count eq listlen(prom_condition_id_list)) or (get_prom_info.condition_list_work_type neq 1 and use_condition_count gte 1))
					use_promotion=1;
				</cfscript>
			<cfelseif isdefined('is_only_first_order_#control_prom_id#') and evaluate('is_only_first_order_#control_prom_id#') eq 1>
				<cfset use_promotion=1>
			</cfif>
			<cfif use_promotion><!--- promosyon kazanılmıssa --->
				<cfset used_prom_id_list=listappend(used_prom_id_list,control_prom_id)>
				<cfif len(is_prom_stock_list)>
					<cfquery name="upd_pre_order_rows" datasource="#dsn3#">
						UPDATE ORDER_PRE_ROWS SET PROM_ID=#control_prom_id#,IS_PROM_ASIL_HEDIYE= 0 WHERE STOCK_ID IN (#is_prom_stock_list#)
					</cfquery>
				</cfif>
				<cfif len(ONLY_SAME_PRODUCT) and ONLY_SAME_PRODUCT eq 1 and isdefined('add_prom_stock_list')><!--- sadece aynı urunu ekle secilmisse, kosullardaki urunler kazanc olarak eklenir --->
					<cfquery name="get_prom_products" datasource="#dsn3#">
						SELECT 
							GS.SALEABLE_STOCK,S.IS_ZERO_STOCK ,S.IS_INVENTORY,
							S.PROPERTY,S.PRODUCT_NAME,S.PRODUCT_UNIT_ID,S.STOCK_ID,S.PRODUCT_ID
						FROM 
							#dsn2_alias#.GET_STOCK_LAST GS,
							STOCKS S
						WHERE
							GS.STOCK_ID=S.STOCK_ID AND
							GS.PRODUCT_ID=S.PRODUCT_ID AND
							S.STOCK_ID IN (#is_prom_stock_list#)
						ORDER BY S.STOCK_ID
					</cfquery>
					<cfset control_stock_list=valuelist(get_prom_products.STOCK_ID)>
					<cfloop list="#add_prom_stock_list#" index="add_stock_id" delimiters=";">
						<cfif (get_prom_products.SALEABLE_STOCK[listfind(control_stock_list,listfirst(add_stock_id,'-'))] gte listlast(add_stock_id,'-')) or get_prom_products.IS_ZERO_STOCK[listfind(control_stock_list,listfirst(add_stock_id,'-'))] eq 1 or get_prom_products.IS_INVENTORY[listfind(control_stock_list,listfirst(add_stock_id,'-'))] eq 0><!--- promosyon kazanılan urunun satılabilir stogu yeterliyse veya sıfır stokla calısabiliyorsa veya envantere dahil degilse  urun baskete eklenir --->
							<cfquery name="add_main_product_" datasource="#dsn3#">
								INSERT INTO
									ORDER_PRE_ROWS
										(
										PRODUCT_ID,
										CATALOG_ID,
										PRODUCT_NAME,
										QUANTITY,
										PRICE,
										PRICE_KDV,
										PRICE_MONEY,
										TAX,
										STOCK_ID,
										STOCK_ACTION_ID,
										PRODUCT_UNIT_ID,
										PROM_STOCK_AMOUNT,
										IS_PROM_ASIL_HEDIYE,
										PROM_FREE_STOCK_ID,
										IS_PRODUCT_PROMOTION_NONEFFECT,
										PROM_ID,
										PROM_COST,
										PROM_PRODUCT_PRICE,
										IS_GENERAL_PROM,
										IS_COMMISSION,
										PRICE_STANDARD,
										PRICE_STANDARD_KDV,
										PRICE_STANDARD_MONEY,
										IS_FROM_SERI_SONU,
										TO_CONS,
										RECORD_PERIOD_ID,
										RECORD_PAR,
										RECORD_CONS,
										RECORD_EMP,
										RECORD_GUEST,
										COOKIE_NAME,
										RECORD_IP,
										RECORD_DATE
										)
										VALUES
										(
										#get_prom_products.PRODUCT_ID[listfind(control_stock_list,listfirst(add_stock_id,'-'))]#,
										<cfif isdefined("attributes.catalog_id") and len(attributes.catalog_id)>#attributes.catalog_id#,<cfelse>NULL,</cfif>
										<cfif trim(get_prom_products.PROPERTY[listfind(control_stock_list,listfirst(add_stock_id,'-'))]) is '-'>'#get_prom_products.PRODUCT_NAME[listfind(control_stock_list,listfirst(add_stock_id,'-'))]#'<cfelse>'#get_prom_products.PRODUCT_NAME[listfind(control_stock_list,listfirst(add_stock_id,'-'))]# #get_prom_products.PROPERTY[listfind(control_stock_list,listfirst(add_stock_id,'-'))]#'</cfif>,
										#wrk_round(listlast(add_stock_id,'-'))#,
										0,
										0,
										<cfif isdefined('session.pp')>'#session.pp.money#'<cfelseif isdefined('session.ww')>'#session.ww.money#'<cfelse>'#session.ep.money#'</cfif>,
										0,
										#get_prom_products.STOCK_ID[listfind(control_stock_list,listfirst(add_stock_id,'-'))]#,
										0,
										#get_prom_products.PRODUCT_UNIT_ID[listfind(control_stock_list,listfirst(add_stock_id,'-'))]#,
										1,
										1,
										0, 
										<cfif len(get_prom_info.PRODUCT_PROMOTION_NONEFFECT)>#get_prom_info.PRODUCT_PROMOTION_NONEFFECT#<cfelse>0</cfif>,
										#control_prom_id#,
										0,
										0,
										0, <!--- promosyon genel tutar veya genel toplama uygulanmıssa --->
										<cfif isDefined("attributes.is_commission") and attributes.is_commission eq 1>1<cfelse>0</cfif>,
										0,
										0,
										<cfif isdefined('session.pp')>'#session.pp.money#'<cfelseif isdefined('session.ww')>'#session.ww.money#'<cfelse>'#session.ep.money#'</cfif>,
										0,
										<cfif isdefined('attributes.consumer_id') and len(attributes.consumer_id)>#attributes.consumer_id#<cfelse>NULL</cfif>,
										#session_base.period_id#,
										<cfif isdefined("session.pp")>#session.pp.userid#<cfelse>NULL</cfif>,
										<cfif isdefined("session.ww.userid")>#session.ww.userid#<cfelse>NULL</cfif>,
										<cfif isdefined("session.ep.userid")>#session.ep.userid#<cfelse>NULL</cfif>,
										<cfif not isdefined("session.pp") and not isdefined("session.ww.userid")>1<cfelse>0</cfif>,
										<cfif isdefined("cookie.wrk_basket_#ReplaceList(cgi.http_host,'-,:','_,_')#")>'#wrk_eval("cookie.wrk_basket_#ReplaceList(cgi.http_host,'-,:','_,_')#")#'<cfelse>NULL</cfif>,
										'#cgi.remote_addr#',
										#now()#
										)
							</cfquery>
						</cfif>
					</cfloop>
				<cfelse>
					<cfquery name="get_prom_products" datasource="#dsn3#">
						SELECT 
							PROM_P.*,GS.SALEABLE_STOCK,S.IS_ZERO_STOCK ,S.IS_INVENTORY,
							S.PROPERTY,S.PRODUCT_NAME,S.PRODUCT_UNIT_ID
						FROM 
							PROMOTION_PRODUCTS PROM_P,
							#dsn2_alias#.GET_STOCK_LAST GS,
							STOCKS S
						WHERE
							PROM_P.STOCK_ID=S.STOCK_ID AND
							GS.STOCK_ID=S.STOCK_ID AND
							GS.PRODUCT_ID=S.PRODUCT_ID AND
							PROM_P.PROMOTION_ID=#control_prom_id#
					</cfquery>
					<cfif get_prom_products.recordcount>
						<cfoutput query="get_prom_products">
						<cfif (SALEABLE_STOCK gte PRODUCT_AMOUNT) or IS_ZERO_STOCK eq 1 or IS_INVENTORY eq 0><!--- promosyon kazanılan urunun satılabilir stogu yeterliyse veya sıfır stokla calısabiliyorsa veya envantere dahil degilse  urun baskete eklenir --->
							<cfquery name="add_main_product_" datasource="#dsn3#">
								INSERT INTO
									ORDER_PRE_ROWS
										(
										PRODUCT_ID,
										CATALOG_ID,
										PRODUCT_NAME,
										QUANTITY,
										PRICE,
										PRICE_KDV,
										PRICE_MONEY,
										TAX,
										STOCK_ID,
										STOCK_ACTION_ID,
										PRODUCT_UNIT_ID,
										PROM_STOCK_AMOUNT,
										IS_PROM_ASIL_HEDIYE,
										PROM_FREE_STOCK_ID,
										IS_PRODUCT_PROMOTION_NONEFFECT,
										PROM_ID,
										PROM_COST,
										PROM_PRODUCT_PRICE,
										IS_GENERAL_PROM,
										IS_COMMISSION,
										PRICE_STANDARD,
										PRICE_STANDARD_KDV,
										PRICE_STANDARD_MONEY,
										IS_FROM_SERI_SONU,
										TO_CONS,
										RECORD_PERIOD_ID,
										RECORD_PAR,
										RECORD_CONS,
										RECORD_EMP,
										RECORD_GUEST,
										COOKIE_NAME,
										RECORD_IP,
										RECORD_DATE
										)
										VALUES
										(
										#get_prom_products.PRODUCT_ID#,
										<cfif isdefined("attributes.catalog_id") and len(attributes.catalog_id)>#attributes.catalog_id#,<cfelse>NULL,</cfif>
										<cfif trim(get_prom_products.PROPERTY) is '-'>'#get_prom_products.PRODUCT_NAME#'<cfelse>'#get_prom_products.PRODUCT_NAME# #get_prom_products.PROPERTY#'</cfif>,
										#get_prom_products.product_amount#,
										#get_prom_products.product_price#,
										#get_prom_products.product_price#,
										<cfif isdefined('session.pp')>'#session.pp.money#'<cfelseif isdefined('session.ww')>'#session.ww.money#'<cfelse>'#session.ep.money#'</cfif>,
										0,
										#get_prom_products.stock_id#,
										0,
										#get_prom_products.PRODUCT_UNIT_ID#,
										1,
										1,
										0, 
										<cfif len(get_prom_info.PRODUCT_PROMOTION_NONEFFECT)>#get_prom_info.PRODUCT_PROMOTION_NONEFFECT#<cfelse>0</cfif>,
										#control_prom_id#,
										<cfif len(get_prom_products.product_cost)>#get_prom_products.product_cost#<cfelse>0</cfif>,
										<cfif len(get_prom_products.product_price)>#get_prom_products.product_price#<cfelse>NULL</cfif>,
										<cfif not len(is_prom_stock_list)>1<cfelse>0</cfif>, <!--- promosyon genel tutar veya genel toplama uygulanmıssa --->
										<cfif isDefined("attributes.is_commission") and attributes.is_commission eq 1>1<cfelse>0</cfif>,
										#get_prom_products.product_price#,
										#get_prom_products.product_price#,
										<cfif isdefined('session.pp')>'#session.pp.money#'<cfelseif isdefined('session.ww')>'#session.ww.money#'<cfelse>'#session.ep.money#'</cfif>,
										0,
										<cfif isdefined('attributes.consumer_id') and len(attributes.consumer_id)>#attributes.consumer_id#<cfelse>NULL</cfif>,
										#session_base.period_id#,
										<cfif isdefined("session.pp")>#session.pp.userid#<cfelse>NULL</cfif>,
										<cfif isdefined("session.ww.userid")>#session.ww.userid#<cfelse>NULL</cfif>,
										<cfif isdefined("session.ep.userid")>#session.ep.userid#<cfelse>NULL</cfif>,
										<cfif not isdefined("session.pp") and not isdefined("session.ww.userid")>1<cfelse>0</cfif>,
										<cfif isdefined("cookie.wrk_basket_#ReplaceList(cgi.http_host,'-,:','_,_')#")>'#wrk_eval("cookie.wrk_basket_#ReplaceList(cgi.http_host,'-,:','_,_')#")#'<cfelse>NULL</cfif>,
										'#cgi.remote_addr#',
										#now()#
										)
							</cfquery>
						</cfif>
						</cfoutput>
					</cfif>
				</cfif>
			</cfif>
		</cfloop>
	</cfif>
</cfif>
