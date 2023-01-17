<cfscript>
	cond_prod_list_='';
	prom_condition_id_list='';
	use_condition_count=0;
	condition_prod_flag=0;
	if( get_prom_conditions.recordcount neq 0)
	{
		if(control_prom_id eq  183)
			get_all_pre_order_rows=cfquery(dbtype:'query',datasource:'',sqlstring:'SELECT * FROM GET_ALL_PRE_ORDER_ROWS WHERE (PROM_ID IS NULL OR (PROM_ID IS NOT NULL AND PROM_ID NOT IN (199,198)))');
		else if(control_prom_id eq  199)
			get_all_pre_order_rows=cfquery(dbtype:'query',datasource:'',sqlstring:'SELECT * FROM GET_ALL_PRE_ORDER_ROWS WHERE (PROM_ID IS NULL OR (PROM_ID IS NOT NULL AND PROM_ID NOT IN (183,198)))');
		else if(control_prom_id eq  198)
			get_all_pre_order_rows=cfquery(dbtype:'query',datasource:'',sqlstring:'SELECT * FROM GET_ALL_PRE_ORDER_ROWS WHERE (PROM_ID IS NULL OR (PROM_ID IS NOT NULL AND PROM_ID NOT IN (183,199)))');
		
		prom_condition_stock_list=listdeleteduplicates(valuelist(get_prom_conditions.STOCK_ID));
		if(listlen(prom_condition_stock_list) and prom_condition_stock_list neq 0)
		{
			get_order_rows=cfquery(dbtype:'query',datasource:'',sqlstring:'SELECT SUM(QUANTITY) QUANTITY,STOCK_ID FROM GET_ALL_PRE_ORDER_ROWS WHERE STOCK_ID IN (#prom_condition_stock_list#) AND (IS_PROM_ASIL_HEDIYE<>1 OR PROM_ID<>#control_prom_id#) GROUP BY STOCK_ID');
		}
		else
			get_order_rows.recordcount=0;
		if(get_order_rows.recordcount)
			ord_row_list=listsort(valuelist(get_order_rows.STOCK_ID),'numeric','asc');
		else
			ord_row_list='';
		prom_condition_id_list=listdeleteduplicates(valuelist(get_prom_conditions.prom_condition_id));
		
		for(kk=1;kk lte get_prom_conditions.recordcount; kk=kk+1)
		{
			if(len(get_prom_conditions.STOCK_ID[kk]) and get_prom_conditions.STOCK_ID[kk] neq 0)
				cond_prod_list_=listappend(cond_prod_list_,get_prom_conditions.STOCK_ID[kk]);
			
			if((get_prom_conditions.prom_condition_id[kk] neq get_prom_conditions.prom_condition_id[kk+1]) or (kk eq get_prom_conditions.recordcount))
			{
				
				is_found_prom=0;
				if(get_prom_info.condition_list_work_type neq 1)//promosyon veya kosuluyla calısıyorsa kazanc prom katsayısı her kosulda sıfırlanır
					prom_prod_multiplier=0;
					
				is_total_product_price=''; is_total_product_amount=''; is_total_product_point='';
				//kosul puan kontrolleri
				
				if(isdefined('attributes.partner_id') and len(attributes.partner_id) and len(get_prom_conditions.total_product_point[kk]) and get_prom_conditions.total_product_point[kk] gt 0) //koşul toplam puana gore
				{
					get_user_points=cfquery(datasource:'#dsn#',sqlstring:"SELECT USER_POINT,USED_USER_POINT FROM COMPANY_PARTNER_POINTS WHERE PARTNER_ID = #attributes.partner_id#");
					get_prom_rows = cfquery(dbtype:'query',datasource:'',sqlstring:"SELECT PROM_ID FROM GET_ALL_PRE_ORDER_ROWS WHERE PROM_ID IS NOT NULL AND ROW_KONTROL = 0");
					used_basket_points = 0;
					if(get_prom_rows.recordcount neq 0)
						for(jjj=1;jjj lte get_prom_rows.recordcount; jjj=jjj+1)
						{
							get_prom_points=cfquery(datasource:'#dsn3#',sqlstring:"SELECT ISNULL(TOTAL_PRODUCT_POINT,0) TOTAL_PRODUCT_POINT FROM PROMOTION_CONDITIONS WHERE PROMOTION_ID= #get_prom_rows.prom_id[jjj]#");
							if(get_prom_points.recordcount neq 0 and len(get_prom_points.TOTAL_PRODUCT_POINT))
							{
								used_basket_points = used_basket_points + get_prom_points.TOTAL_PRODUCT_POINT;
							}
						}
					is_total_product_point=0;
					if(len(get_user_points.USED_USER_POINT) and len(get_user_points.USER_POINT))
						usable_point = get_user_points.USER_POINT - get_user_points.USED_USER_POINT;
					else if(not len(get_user_points.USED_USER_POINT) and len(get_user_points.USER_POINT))
						usable_point = get_user_points.USER_POINT;
					else
						usable_point = 0;
					usable_point = usable_point - used_basket_points ;
					
					if(usable_point gte get_prom_conditions.total_product_point[kk])
					{
						is_total_product_point=1;
						prom_prod_multiplier=1;
						is_found_prom=1;
						use_promotion=1;
					}					
				}
				//kosul toplam miktar kontrolleri
				if(len(get_prom_conditions.total_product_amount[kk]) and get_prom_conditions.total_product_amount[kk] gt 0) //koşul toplam miktara gore
				{
					if(listlen(cond_prod_list_))
						get_total_amount_info=cfquery(dbtype:'query',datasource:'',sqlstring:"SELECT SUM(QUANTITY) TOTAL_QUANTITY FROM GET_ALL_PRE_ORDER_ROWS WHERE STOCK_ID IN (#cond_prod_list_#) AND (IS_PROM_ASIL_HEDIYE<>1 OR PROM_ID<>#control_prom_id#)");
					else
						get_total_amount_info=cfquery(dbtype:'query',datasource:'',sqlstring:"SELECT SUM(QUANTITY) TOTAL_QUANTITY FROM GET_ALL_PRE_ORDER_ROWS WHERE (IS_PROM_ASIL_HEDIYE<>1 OR PROM_ID<>#control_prom_id#)");
				
					is_total_product_amount=0;
					
					if(len(get_total_amount_info.TOTAL_QUANTITY) and get_total_amount_info.TOTAL_QUANTITY gte get_prom_conditions.total_product_amount[kk])
					{
						is_total_product_amount=1;
						if( (prom_prod_multiplier neq 0 and Int(get_total_amount_info.TOTAL_QUANTITY/get_prom_conditions.total_product_amount[kk]) lt prom_prod_multiplier) or (prom_prod_multiplier eq 0))//toplam urun miktarının promosyon urun mıktarına oranı kazanc urunlerinin katsayısını veriyor
							prom_prod_multiplier=Int(get_total_amount_info.TOTAL_QUANTITY/get_prom_conditions.total_product_amount[kk]);
					}
				}
				//kosul toplam tutar kontrolleri

				if(len(get_prom_conditions.total_product_price[kk]) and get_prom_conditions.total_product_price[kk] gte 0) 
				{   
													
					if(len(get_prom_info.CONDITION_PRICE_CATID) and get_prom_info.CONDITION_PRICE_CATID neq get_prom_info.PRICE_CATID)
					{  

						prom_condition_price_catid=get_prom_info.CONDITION_PRICE_CATID;
						demand_product_type = get_prom_info.IS_DEMAND_PRODUCTS;
						demand_order_product_type = get_prom_info.IS_DEMAND_ORDER_PRODUCTS;
						include('get_total_prom_price.cfm','\objects2\query');
					}
					else if(listlen(cond_prod_list_))
						get_total_price_info=cfquery(dbtype:'query',datasource:'',sqlstring:"SELECT SUM(QUANTITY) TOTAL_QUANTITY, SUM(ROW_TOTAL)AS TOTAL_PRICE FROM GET_ALL_PRE_ORDER_ROWS WHERE STOCK_ID IN (#cond_prod_list_#) AND (IS_PROM_ASIL_HEDIYE<>1 OR PROM_ID<>#control_prom_id#)"); //IS_INVENTORY=1  niye eklemiştik hatırlamıyoruz, gerekirse tekrar kontrol edilecek
					else
						get_total_price_info=cfquery(dbtype:'query',datasource:'',sqlstring:"SELECT SUM(QUANTITY) TOTAL_QUANTITY, SUM(ROW_TOTAL) AS TOTAL_PRICE FROM GET_ALL_PRE_ORDER_ROWS WHERE (IS_PROM_ASIL_HEDIYE<>1 OR PROM_ID<>#control_prom_id#)"); //IS_INVENTORY=1
					if(get_total_price_info.recordcount and len(get_total_price_info.TOTAL_PRICE))
						order_total_price=get_total_price_info.TOTAL_PRICE;
					else
						order_total_price=0;

					is_total_product_price=0;
					if(len(get_prom_conditions.total_product_price_last[kk]) and get_prom_conditions.total_product_price_last[kk] gt 0)
					{
						if(len(order_total_price) and wrk_round(order_total_price) gte wrk_round(get_prom_conditions.total_product_price[kk]) and wrk_round(order_total_price) lte wrk_round(get_prom_conditions.total_product_price_last[kk]) and get_prom_conditions.total_product_price[kk] gte 0)
						{
							is_total_product_price=1;
							if( (prom_prod_multiplier neq 0 and Int(order_total_price/get_prom_conditions.total_product_price[kk]) lt prom_prod_multiplier) or (prom_prod_multiplier eq 0))//toplam urun miktarının promosyon urun mıktarına oranı kazanc urunlerinin katsayısını veriyor
								if(get_prom_conditions.total_product_price[kk] gt 0)	
									prom_prod_multiplier=Int(order_total_price/get_prom_conditions.total_product_price[kk]);
								else
									prom_prod_multiplier = 1;
						}
					}
					else
					{
						if(len(order_total_price) and wrk_round(order_total_price) gte wrk_round(get_prom_conditions.total_product_price[kk]))
						{
							is_total_product_price=1;
							if( (prom_prod_multiplier neq 0 and Int(order_total_price/get_prom_conditions.total_product_price[kk]) lt prom_prod_multiplier) or (prom_prod_multiplier eq 0))//toplam urun miktarının promosyon urun mıktarına oranı kazanc urunlerinin katsayısını veriyor
							{	
								if(get_prom_conditions.total_product_price[kk] gt 0)
									prom_prod_multiplier=Int(order_total_price/get_prom_conditions.total_product_price[kk]);
								else
									prom_prod_multiplier = 1;
							}
						}
					}
				}
				if(listlen(cond_prod_list_)) //kosul urunleri varsa
				{
					for(nn=1;nn lte listlen(cond_prod_list_); nn=nn+1) 
					{
						cond_s=listgetat(cond_prod_list_,nn);
						if((not len(is_total_product_price) and not len(is_total_product_amount) and listfind(ord_row_list,cond_s) and get_order_rows.QUANTITY[listfind(ord_row_list,cond_s)] gte get_prom_conditions.PRODUCT_AMOUNT[kk]) or ( (len(is_total_product_price) or len(is_total_product_amount)) and listfind(ord_row_list,cond_s)))
						{
							if(not len(is_total_product_amount) and not len(is_total_product_price)) //toplam miktar veya tutar belirtilmemisse kazanc katsayısı urunlerden hesaplanır
							{
								if(get_prom_conditions.list_work_type[kk] eq 0 and not (len(get_prom_info.ONLY_SAME_PRODUCT) and get_prom_info.ONLY_SAME_PRODUCT eq 1) ) //veyalı promosyonda sagladıgı her urun icin kazanc urunlerini yeniden almaya hak kazanır
									prom_prod_multiplier=prom_prod_multiplier+Int(get_order_rows.QUANTITY[listfind(ord_row_list,cond_s)]/get_prom_conditions.PRODUCT_AMOUNT[kk]);
								else
								{
									if( ( prom_prod_multiplier neq 0 and len(get_order_rows.QUANTITY[listfind(ord_row_list,cond_s)]) and Int(get_order_rows.QUANTITY[listfind(ord_row_list,cond_s)]/get_prom_conditions.PRODUCT_AMOUNT[kk]) lt prom_prod_multiplier) or prom_prod_multiplier eq 0) //toplam urun miktarının promosyon urun mıktarına oranı kazanc urunlerinin katsayısını veriyor
										prom_prod_multiplier=Int(get_order_rows.QUANTITY[listfind(ord_row_list,cond_s)]/get_prom_conditions.PRODUCT_AMOUNT[kk]);
								}
							}
							condition_prod_flag=condition_prod_flag+1;
							is_prom_stock_list=listappend(is_prom_stock_list,cond_s); //promosyon kazandıran urunler
							if(len(get_prom_info.ONLY_SAME_PRODUCT) and get_prom_info.ONLY_SAME_PRODUCT eq 1)
							{
								if(get_prom_conditions.list_work_type[kk] eq 0)
								{
									add_prom_stock_list=listappend(add_prom_stock_list,('#cond_s#-#Int(get_order_rows.QUANTITY[listfind(ord_row_list,cond_s)]/get_prom_conditions.PRODUCT_AMOUNT[kk])#'),';');
									prom_prod_multiplier=1; //sadece aynı urunu ekle ise ve kosul veyalı calısıyorsa promosyon katsayısı 1 olarak sabit tutulur, her bir ürünün katsayısı yukardaki satırda hesaplanıyor zaten
								}
								else
									add_prom_stock_list=listappend(add_prom_stock_list,('#cond_s#-#get_prom_conditions.PRODUCT_AMOUNT[kk]#'),';');
							}
							if(get_prom_conditions.list_work_type[kk] eq 0  and not (len(is_total_product_price) and is_total_product_price eq 0) and not (len(is_total_product_amount) and is_total_product_amount eq 0)) //kosulun calısma sekli "veya" ise tek bir koşul ürününü bulunması yeterlidir
							{
								is_found_prom=1;
								
							}
						} 
					}
				}
				else if(get_prom_conditions.list_work_type[kk] eq 0  and not (len(is_total_product_price) and is_total_product_price eq 0) and not (len(is_total_product_amount) and is_total_product_amount eq 0)) //kosulun calısma sekli "veya" ise tek bir koşul ürününü bulunması yeterlidir
					is_found_prom=1;
				/*kosul calısma sekli ve ise; toplam tutar ve toplam mıktar bos ya da 1 ise ve siparisle eslesen urun sayısı kosuldaki urun sayısına esitse, kosul saglanmıs olur*/
				if(get_prom_conditions.list_work_type[kk] eq 1 and not (len(is_total_product_price) and is_total_product_price eq 0) and not (len(is_total_product_amount) and is_total_product_amount eq 0)  and not (len(is_total_product_point) and is_total_product_point eq 0) and condition_prod_flag eq listlen(cond_prod_list_)) //condition_prod_flag neq 0   kosulun calısma sekli "ve" ise tüm urunler kontrol edilir
					use_condition_count =use_condition_count+1;
				else if(get_prom_conditions.list_work_type[kk] eq 0 and is_found_prom eq 1)
					use_condition_count =use_condition_count+1;
				if(get_prom_info.condition_list_work_type neq 1 and use_condition_count gte 1) //promosyon veya kosuluyla calısıyorsa bir kosulun saglanmasıyla promosyon kazanılmıs olur
				{
					use_promotion=1;
					break;
				}
				cond_prod_list_='';condition_prod_flag=0;
			}
		}		
	}
	if((get_prom_info.condition_list_work_type eq 1 and use_condition_count eq listlen(prom_condition_id_list)) or (get_prom_info.condition_list_work_type neq 1 and use_condition_count gte 1))
	{
		use_promotion=1;
	}
	if(prom_prod_multiplier eq 0)
		prom_prod_multiplier=1;
	
	if(len(prom_work_count) and prom_prod_multiplier gt prom_work_count)
		prom_prod_multiplier = prom_work_count;
</cfscript>
