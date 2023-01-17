<cf_xml_page_edit fuseact="product.detail_product_price">
<cffunction name="get_currency">
	<cfargument name="cur_ty">
	<cfquery name="get_mon" datasource="#DSN#">
		SELECT 
			RATE2/RATE1 AS RATE 
		FROM 
			SETUP_MONEY
		WHERE 
			PERIOD_ID = #session.ep.period_id# AND
			MONEY ='#arguments.cur_ty#'
 	</cfquery>
	<cfif (session.ep.period_year lt 2009 and arguments.cur_ty is 'TL') or (session.ep.period_year gte 2009 and arguments.cur_ty is 'YTL')>
		<cfreturn 1>
	<cfelse>
		<cfreturn get_mon.rate>	
	</cfif>	
</cffunction> 
<cfscript>
	get_product_list_action = createObject("component", "V16.product.cfc.get_product");
	get_product_list_action.dsn1 = dsn1;
	get_product_list_action.dsn_alias = dsn_alias;
	GET_PRODUCT = get_product_list_action.get_product_
	(
		module_name : fusebox.circuit,
		pid : attributes.pid
	);
</cfscript>
<cfinclude template="../query/get_rival_prices.cfm">
<cfinclude template="../query/get_product_price_sales.cfm">
<cfquery name="GET_COMPETITIVE_LIST" datasource="#DSN3#">
	SELECT 
		COMPETITIVE_ID
	FROM
		PRODUCT_COMP_PERM 
	WHERE 
		POSITION_CODE = #session.ep.position_code#
</cfquery>
<cfset COMPETITIVE_LIST = ValueList(GET_COMPETITIVE_LIST.COMPETITIVE_ID)>
<!--- net maliyet hesabı --->
<cfquery name="GET_PURCHASE_PROD_DISCOUNT_DETAIL" datasource="#dsn3#" maxrows="1">
	SELECT
		*
	FROM
		CONTRACT_PURCHASE_PROD_DISCOUNT
	WHERE
		PRODUCT_ID = #attributes.pid# AND
		CONTRACT_ID IS NULL
	ORDER BY
		START_DATE DESC
</cfquery>
<cfquery name="GET_PRODUCT_COST" DATASOURCE="#DSN3#" MAXROWS="1">
	SELECT 
		*
	FROM 
		PRODUCT_COST 
	WHERE 
		PRODUCT_ID = #PID# 
	ORDER BY 
		RECORD_DATE DESC
</cfquery>
<!--- net maliyet hesabı --->
<cfset alis_kdv = GET_PRODUCT.TAX_PURCHASE>
<cfset satis_kdv = GET_PRODUCT.TAX>
<cfset pageHead = "#getlang('product',105)#: #left(Replace(get_product.product_name,"'"," "),50)#">
<cf_catalystHeader>
    <div class="col col-9 col-xs-12 uniqueRow">
            <!--- Ürün Bilgileri --->
        <cf_box title="#getlang('','settings',57236)# #getlang('','settings',29411)#">
            <cf_grid_list id="product_title">
                <thead>
                    <tr> 
                        <th><cf_get_lang dictionary_id='57636.Birim'></th>
                        <th class="text-right"><cf_get_lang dictionary_id='58722.Standart Alış'></th>
                        <th class="text-right"><cf_get_lang dictionary_id='37426.KDV li Alış'></th>
                        <th class="text-right"><cf_get_lang dictionary_id='37358.Net Maliyet'></th>
                        <th class="text-right"><cf_get_lang dictionary_id='37411.KDV li Net Maliyet'></th>
                        <th class="text-right"><cf_get_lang dictionary_id='58721.Standart Satış'></th>
                        <th class="text-right"><cf_get_lang dictionary_id='58721.Standart Satış'> <cf_get_lang dictionary_id='58716.KDVli'></th>
                        <th class="text-right"><cf_get_lang dictionary_id='37045.Kar Marjı'>%</th>
                    </tr>
                </thead>
                <cfinclude template="../query/get_product_prices_sa_ss.cfm">
                <cfset sa_prices_units = valuelist(GET_PRICE_SA.ADD_UNIT,',') >
                <cfset sa_prices = valuelist(GET_PRICE_SA.PRICE,',') >
                <cfset sa_prices_moneys = valuelist(GET_PRICE_SA.MONEY,',') >
                <cfoutput query="GET_PRICE_SS">
                    <cfif listfindnocase(sa_prices_units,GET_PRICE_SS.ADD_UNIT,',')>
                        <cfscript>
                            toplam_diger_maliyet = 0;
                            indirimli_alis_fiyat = listgetat(sa_prices,listfindnocase(sa_prices_units,GET_PRICE_SS.ADD_UNIT,','),',');
                            sa_money = listgetat(sa_prices_moneys,listfindnocase(sa_prices_units,GET_PRICE_SS.ADD_UNIT,','),',');
                            if (not GET_PRICE_SS.ROUNDING) 
                                {
                                indirimli_alis_fiyat = wrk_round(indirimli_alis_fiyat,session.ep.our_company_info.purchase_price_round_num);
                                indirimli_alis_fiyat_kdvli = wrk_round(((indirimli_alis_fiyat * alis_kdv) / 100) + indirimli_alis_fiyat,session.ep.our_company_info.purchase_price_round_num);
                                }
                            if (GET_PRODUCT_COST.recordcount)
                                toplam_diger_maliyet =  GET_PRODUCT_COST.STANDARD_COST + ((GET_PRICE_SA.price*GET_PRODUCT_COST.STANDARD_COST_RATE)/100);;//GET_PRODUCT_COST.GENERAL_COST + GET_PRODUCT_COST.TRANSPORT_COST + GET_PRODUCT_COST.OTHER_COST
                            
                            standart_alis_fiyat = indirimli_alis_fiyat;
                            
                            indirim1 = GET_PURCHASE_PROD_DISCOUNT_DETAIL.DISCOUNT1;
                            indirim2 = GET_PURCHASE_PROD_DISCOUNT_DETAIL.DISCOUNT2;
                            indirim3 = GET_PURCHASE_PROD_DISCOUNT_DETAIL.DISCOUNT3;
                            indirim4 = GET_PURCHASE_PROD_DISCOUNT_DETAIL.DISCOUNT4;
                            indirim5 = GET_PURCHASE_PROD_DISCOUNT_DETAIL.DISCOUNT5;
                            if (not len(indirim1)){indirim1 = 0;}
                            if (not len(indirim2)){indirim2 = 0;}
                            if (not len(indirim3)){indirim3 = 0;}
                            if (not len(indirim4)){indirim4 = 0;}
                            if (not len(indirim5)){indirim5 = 0;}
                            
                            asil_indirimli_alis_fiyat = indirimli_alis_fiyat - toplam_diger_maliyet;
                            
                            asil_indirimli_alis_fiyat = asil_indirimli_alis_fiyat * (100-indirim1)/100;
                            asil_indirimli_alis_fiyat = asil_indirimli_alis_fiyat * (100-indirim2)/100;
                            asil_indirimli_alis_fiyat = asil_indirimli_alis_fiyat * (100-indirim3)/100;
                            asil_indirimli_alis_fiyat = asil_indirimli_alis_fiyat * (100-indirim4)/100;
                            asil_indirimli_alis_fiyat = asil_indirimli_alis_fiyat * (100-indirim5)/100;
                            
                            indirimli_alis_fiyat = asil_indirimli_alis_fiyat + toplam_diger_maliyet;
                        </cfscript>
                        <tbody>
                            <tr>
                                <td>#GET_PRICE_SS.ADD_UNIT#</td>
                                <td class="text-right" nowrap="nowrap">#TLFormat(standart_alis_fiyat,session.ep.our_company_info.purchase_price_round_num)#&nbsp;#sa_money#<cfif GET_PRODUCT_COST.recordcount and toplam_diger_maliyet><br/>(<cf_get_lang dictionary_id='37183.Ek Maliyet'>: #tlformat(toplam_diger_maliyet,4)#)</cfif></td>
                                <td class="text-right">#TLFormat(indirimli_alis_fiyat_kdvli,session.ep.our_company_info.purchase_price_round_num)#&nbsp;#sa_money#</td>
                                <cfset toplam_diger_maliyet = 0>
                                <td class="text-right" nowrap="nowrap">#TLFormat(indirimli_alis_fiyat,session.ep.our_company_info.purchase_price_round_num)#&nbsp;#sa_money#</td>
                                <td class="text-right">#TLFormat(((indirimli_alis_fiyat*alis_kdv)/100)+indirimli_alis_fiyat,session.ep.our_company_info.purchase_price_round_num)#&nbsp;#sa_money#</td>
                                <td class="text-right">#TLFormat(GET_PRICE_SS.PRICE,session.ep.our_company_info.purchase_price_round_num)# #GET_PRICE_SS.MONEY#</td>
                                <td class="text-right">#TLFormat((((GET_PRICE_SS.PRICE*satis_kdv)/100)+GET_PRICE_SS.PRICE),session.ep.our_company_info.purchase_price_round_num)# #GET_PRICE_SS.MONEY#</td>
                                <td class="text-right">
                                    <cfif len(sa_money) and len(indirimli_alis_fiyat) and isnumeric(get_currency(sa_money)) and isnumeric(indirimli_alis_fiyat) and indirimli_alis_fiyat>
                                        <cfset indirimli_alis_fiyat = indirimli_alis_fiyat*get_currency(sa_money)>
                                        <cfset satis_fiyat = GET_PRICE_SS.PRICE*get_currency(GET_PRICE_SS.MONEY)>
                                        #TLFormat(((satis_fiyat-indirimli_alis_fiyat)*100)/indirimli_alis_fiyat,session.ep.our_company_info.purchase_price_round_num)#
                                    </cfif>
                                </td>				
                            </tr>
                        </tbody>
                    </cfif>
                </cfoutput>
            </cf_grid_list>
        </cf_box>
        <!-- sil -->
        <cf_box title="#getLang('','Satış Fiyatları',37117)#" uidrop="1">
            <cf_grid_list> 
                <thead>             
                    <tr> 
                        <th width="35"><cf_get_lang dictionary_id='57487.No'></th>
                        <th width="150"><cf_get_lang dictionary_id='57509.Liste'></th>
                        <cfif isdefined('x_dsp_stock_based_price') and x_dsp_stock_based_price eq 1>
                        <th width="90"><cf_get_lang dictionary_id="57518.Stok Kodu"></th>				              
                        </cfif>
                        <cfif isdefined('x_dsp_spec_based_price') and x_dsp_spec_based_price eq 1>
                        <th width="90"><cf_get_lang dictionary_id="57647.Spec"></th>				              
                        </cfif>
                        <th width="45"><cf_get_lang dictionary_id='57636.Birim'></th>				              
                        <th width="90" class="text-right"><cf_get_lang dictionary_id='57638.Birim Fiyat'></th>				
                        <th width="90" class="text-right"><cf_get_lang dictionary_id='58084.Fiyat'></th>
                        <th width="90" class="text-right"><cf_get_lang dictionary_id='37427.KDV li Fiyat'></th>
                        <th width="45" align="center"><cf_get_lang dictionary_id='37045.Kar Marjı'>%</th>					 			 
                        <th><cf_get_lang dictionary_id='57483.Kayıt'></th>
                        <th width="115"><cf_get_lang dictionary_id='37119.Geçerlilik Tarihi'></th>  
                        <!-- sil -->
                        <th width="15" class="text-right">
                          <!---   <cfif len(get_product.PROD_COMPETITIVE) >
                                <cfif listfind(COMPETITIVE_LIST,get_product.PROD_COMPETITIVE,",")>
                                    <cfset dontshow = 1 >
                                    <cfset str_url_open = "product.popup_form_add_product_price&pid=#get_product.product_id#" >
                                <cfelse>
                                    <cfset dontshow = 0 >
                                    <cfset str_url_open = "product.list_price_change&event=add&pid=#get_product.product_id#">
                                </cfif>
                            <cfelse>
                                <cfset dontshow = 0 >
                                <cfset str_url_open = "product.list_price_change&event=add&pid=#get_product.product_id#">
                            </cfif> --->
                            <cfset dontshow = 1 >
                            <cfset str_url_open = "product.popup_form_add_product_price&pid=#get_product.product_id#" >
                            <a href="javascript://" title="<cf_get_lang dictionary_id='37124.Fiyat Ekle'>" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=#str_url_open#</cfoutput>');">
                                <i class="fa fa-plus"></i>
                            </a>
                        </th>
                        <!-- sil -->
                    </tr>
                </thead>
                <tbody>
                    <cfoutput query="GET_PRODUCT_PRICE">
                    <cfquery name="pricecat_sales" datasource="#DSN3#">
                        SELECT IS_SALES,IS_PURCHASE FROM PRICE_CAT WHERE PRICE_CATID = #price_catid#
                    </cfquery>
                    <cfif pricecat_sales.is_purchase eq 1 and pricecat_sales.is_sales eq 0>
                        <cfset round_num = session.ep.our_company_info.purchase_price_round_num>
                    <cfelse>
                        <cfset round_num = session.ep.our_company_info.sales_price_round_num>
                    </cfif>						  
                    <tr>
                        <td>#currentrow#</td>
                        <td><a href="javascript://" onClick="javascript:openBoxDraggable('#request.self#?fuseaction=product.popup_std_sale&pid=#attributes.pid#&pricecatid=#PRICE_CATID#');">#PRICE_CAT#</a></td>
                        <cfif (isdefined('x_dsp_stock_based_price') and x_dsp_stock_based_price eq 1)>
                            <td><cfif len(STOCK_CODE)>#STOCK_CODE#</cfif></td>
                        </cfif>
                        <cfif isdefined('x_dsp_spec_based_price') and x_dsp_spec_based_price eq 1>
                            <td class="txtboldblue" width="90"><cfif len(SPECT_VAR_ID) and SPECT_VAR_ID neq 0>#SPECT_VAR_ID#</cfif></td>				              
                        </cfif>
                        <td>#ADD_UNIT#</td>
                        <td class="text-right">
                            <cfif isnumeric(PRICE) and isnumeric(UNIT_MULTIPLIER) and UNIT_MULTIPLIER neq 0>#TLFormat(PRICE/UNIT_MULTIPLIER)#&nbsp;#money#
                                <cfif len(UNIT_MULTIPLIER_STATIC) and (UNIT_MULTIPLIER_STATIC eq 1)>/<cf_get_lang dictionary_id='37613.Litre'></cfif>
                                <cfif len(UNIT_MULTIPLIER_STATIC) and (UNIT_MULTIPLIER_STATIC eq 2)>/<cf_get_lang dictionary_id='37188.Kg'></cfif>
                                <cfif len(UNIT_MULTIPLIER_STATIC) and (UNIT_MULTIPLIER_STATIC eq 3)>/<cf_get_lang dictionary_id='58082.Adet'></cfif>
                            </cfif>
                        </td>
                        <td class="text-right">#TLFormat(PRICE,round_num)#&nbsp;#money#</td>
                        <td class="text-right"><cfif IS_KDV EQ 1>#TLFormat(PRICE_KDV,round_num)#<cfelse>#TLFormat(((PRICE*satis_kdv)/100)+PRICE,round_num)#</cfif>&nbsp;#money#</td>
                        <td class="text-right">
                            <!--- Marj hesaplamasında farklı unit lerden sonuç çıkarmasını önlemek için konuldu. --->
                            <cfif listfindnocase(sa_prices_units,ADD_UNIT,',')>
                                <cfscript>
                                    indirimli_alis_fiyat = listgetat(sa_prices,listfindnocase(sa_prices_units,ADD_UNIT,','),',');
                                    sa_money = listgetat(sa_prices_moneys,listfindnocase(sa_prices_units,ADD_UNIT,','),',');
                                    indirim1 = GET_PURCHASE_PROD_DISCOUNT_DETAIL.DISCOUNT1;
                                    indirim2 = GET_PURCHASE_PROD_DISCOUNT_DETAIL.DISCOUNT2;
                                    indirim3 = GET_PURCHASE_PROD_DISCOUNT_DETAIL.DISCOUNT3;
                                    indirim4 = GET_PURCHASE_PROD_DISCOUNT_DETAIL.DISCOUNT4;
                                    indirim5 = GET_PURCHASE_PROD_DISCOUNT_DETAIL.DISCOUNT5;
                                    if (not len(indirim1)){indirim1 = 0;}
                                    if (not len(indirim2)){indirim2 = 0;}
                                    if (not len(indirim3)){indirim3 = 0;}
                                    if (not len(indirim4)){indirim4 = 0;}
                                    if (not len(indirim5)){indirim5 = 0;}
                                    indirimli_alis_fiyat = indirimli_alis_fiyat*(100-indirim1)/100;
                                    indirimli_alis_fiyat = indirimli_alis_fiyat*(100-indirim2)/100;
                                    indirimli_alis_fiyat = indirimli_alis_fiyat*(100-indirim3)/100;
                                    indirimli_alis_fiyat = indirimli_alis_fiyat*(100-indirim4)/100;
                                    indirimli_alis_fiyat = indirimli_alis_fiyat*(100-indirim5)/100;
                                </cfscript>
                                <cfif isnumeric(get_currency(sa_money)) and isnumeric(indirimli_alis_fiyat) and indirimli_alis_fiyat>
                                    <cfset indirimli_alis_fiyat = indirimli_alis_fiyat*get_currency(sa_money)>
                                    <cfset satis_fiyat = PRICE*get_currency(MONEY)>
                                    #TLFormat(((satis_fiyat-indirimli_alis_fiyat)*100)/indirimli_alis_fiyat)#
                                </cfif>
                            </cfif>
                        </td>
                        <td>#get_emp_info(RECORD_EMP,0,1)#</td>
                        <td>#dateformat(startdate,dateformat_style)# #timeformat(startdate,timeformat_style)# -#dateformat(FINISHDATE,dateformat_style)#</td>
                        <!-- sil -->
                        <td>
                            <cfif dontshow eq 1>
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id ='37775.Kayıtlı Fiyatı Siliyorsunuz! Emin misiniz'></cfsavecontent>
                                    <a title="<cf_get_lang dictionary_id='57463.Sil'>" href="javascript://" onClick="javascript:if (confirm('#message#')) windowopen('#request.self#?fuseaction=product.emptypopup_del_price&price_id=#price_id#&pid=#attributes.pid#<cfif (isdefined('x_dsp_stock_based_price') and x_dsp_stock_based_price eq 1)>&is_stck_price=1</cfif><cfif isdefined('x_dsp_spec_based_price') and x_dsp_spec_based_price eq 1>&is_spc_price=1</cfif>','small'); else return false;">
                                      <i class="fa fa-minus"></i>
                                    </a>
                            </cfif>
                        </td>
                        <!-- sil -->
                        </tr>			  
                    </cfoutput> 
                </tbody>
            </cf_grid_list>
        </cf_box>
        <!-- sil -->
        <cf_box title="#getLang('','Son Alış Fiyatları',37122)#">
            <cf_grid_list>
                <thead>	
                    <tr> 
                        <th><cf_get_lang dictionary_id='29533.Tedarikçi'></th>
                        <th class="text-right"><cf_get_lang dictionary_id='57635.Miktar'></th>
                        <th><cf_get_lang dictionary_id='57636.Birim'></th>
                        <th class="text-right"><cf_get_lang dictionary_id='58084.Fiyat'></th>
                        <th class="text-right"><cf_get_lang dictionary_id='33366.Dövizli Fiyat'></th>
                        <th class="text-right"><cf_get_lang dictionary_id='37350.İndirimli Fiyat'></th>
                        <th class="text-right"><cf_get_lang dictionary_id='58716.KDV li'> <cf_get_lang dictionary_id='37350.İndirimli Fiyat'></th>
                        <th class="text-right"><cf_get_lang dictionary_id='57742.Tarih'></th>
                    </tr>
                </thead>
                <cfinclude template="../query/get_purchase_cost.cfm">
                <tbody>
                    <cfoutput query="get_purchase_cost">
                        <tr>
                            <td><cfif len(COMPANY_ID)>#get_par_info(member_id:COMPANY_ID,company_or_partner:1,with_link:1,with_company_partner:1)#<cfelse>#get_cons_info(consumer_id:CONSUMER_ID,with_company:1,with_link:1)#</cfif></td>
                            <td class="text-right">#TLFormat(Amount,4)#</td>
                            <td>#GET_PURCHASE_COST.UNIT#</td>
                            <td class="text-right">#TLFormat(PRICE,session.ep.our_company_info.purchase_price_round_num)#&nbsp;#SESSION.EP.MONEY#</td>
                            <td class="text-right">
                            <cfif len(OTHER_MONEY) and len(PRICE_OTHER)>
                                #TLFormat(PRICE_OTHER,session.ep.our_company_info.sales_price_round_num)#&nbsp;#OTHER_MONEY#
                            </cfif>
                            </td>
                            <cfscript>
                                indirimli_alis_fiyat = PRICE;
                                if(len(DISCOUNT_COST))
                                    indirimli_alis_fiyat =(indirimli_alis_fiyat-DISCOUNT_COST); 
                                indirim1 = DISCOUNT1;
                                indirim2 = DISCOUNT2;
                                indirim3 = DISCOUNT3;
                                indirim4 = DISCOUNT4;
                                indirim5 = DISCOUNT5;
                                if (not len(indirim1)){indirim1 = 0;}
                                if (not len(indirim2)){indirim2 = 0;}
                                if (not len(indirim3)){indirim3 = 0;}
                                if (not len(indirim4)){indirim4 = 0;}
                                if (not len(indirim5)){indirim5 = 0;}
                                indirimli_alis_fiyat = indirimli_alis_fiyat*(100-indirim1)/100;
                                indirimli_alis_fiyat = indirimli_alis_fiyat*(100-indirim2)/100;
                                indirimli_alis_fiyat = indirimli_alis_fiyat*(100-indirim3)/100;
                                indirimli_alis_fiyat = indirimli_alis_fiyat*(100-indirim4)/100;
                                indirimli_alis_fiyat = indirimli_alis_fiyat*(100-indirim5)/100;
                            </cfscript>
                            <td class="text-right">#TLFormat(indirimli_alis_fiyat,session.ep.our_company_info.purchase_price_round_num)#&nbsp;#SESSION.EP.MONEY#</td>
                            <td class="text-right">
                            <cfset kdvli_indirim = ((indirimli_alis_fiyat * alis_kdv) / 100) + indirimli_alis_fiyat>
                            #TLFormat(kdvli_indirim,session.ep.our_company_info.purchase_price_round_num)#&nbsp;#SESSION.EP.MONEY#</td>
                            <td class="text-right">#dateformat(INVOICE_DATE,dateformat_style)#</td>                
                        </tr>
                    </cfoutput>
                </tbody>
            </cf_grid_list>
        </cf_box>
            <!-- sil -->
        <cf_box title="#getLang('','Son Satış Fiyatları',37053)#">
            <cf_grid_list>
                <thead>
                    <tr> 
                        <th><cf_get_lang dictionary_id='57457.müşteri'></th>
                        <th><cf_get_lang dictionary_id='57636.Birim'></th>
                        <th class="text-right"><cf_get_lang dictionary_id='58084.Fiyat'></th>
                        <th class="text-right"><cf_get_lang dictionary_id='33366.Dövizli Fiyat'></th>
                        <th class="text-right"><cf_get_lang dictionary_id='37350.İndirimli Fiyat'></th>
                        <th class="text-right"><cf_get_lang dictionary_id='58716.KDV  li'> <cf_get_lang dictionary_id='37350.İndirimli Fiyat'></th>
                        <th class="text-right"><cf_get_lang dictionary_id='57742.Tarih'></th>
                    </tr>
                </thead>
                <tbody>
                    <cfinclude template="../query/get_sale_cost.cfm">
                    <cfoutput query="get_sale_cost">
                        <tr>
                            <td><cfif len(COMPANY_ID)>#get_par_info(member_id:COMPANY_ID,company_or_partner:1,with_link:1,with_company_partner:1)#<cfelse>#get_cons_info(consumer_id:CONSUMER_ID,with_company:1,with_link:1)#</cfif></td>					
                            <td>#UNIT#</td>
                            <td class="text-right">#TLFormat(PRICE,session.ep.our_company_info.sales_price_round_num)#&nbsp;#SESSION.EP.MONEY#</td>
                            <td class="text-right">
                            <cfif len(OTHER_MONEY) and len(PRICE_OTHER)>
                                #TLFormat(PRICE_OTHER,session.ep.our_company_info.sales_price_round_num)#&nbsp;#OTHER_MONEY#
                            </cfif>
                            </td>
                            <cfscript>
                                indirimli_satis_fiyat = PRICE;
                                indirim1 = DISCOUNT1;
                                indirim2 = DISCOUNT2;
                                indirim3 = DISCOUNT3;
                                indirim4 = DISCOUNT4;
                                indirim5 = DISCOUNT5;
                                if (not len(indirim1)){indirim1 = 0;}
                                if (not len(indirim2)){indirim2 = 0;}
                                if (not len(indirim3)){indirim3 = 0;}
                                if (not len(indirim4)){indirim4 = 0;}
                                if (not len(indirim5)){indirim5 = 0;}
                                indirimli_satis_fiyat = indirimli_satis_fiyat*(100-indirim1)/100;
                                indirimli_satis_fiyat = indirimli_satis_fiyat*(100-indirim2)/100;
                                indirimli_satis_fiyat = indirimli_satis_fiyat*(100-indirim3)/100;
                                indirimli_satis_fiyat = indirimli_satis_fiyat*(100-indirim4)/100;
                                indirimli_satis_fiyat = indirimli_satis_fiyat*(100-indirim5)/100;
                            </cfscript>
                            <td class="text-right">#TLFormat(indirimli_satis_fiyat,session.ep.our_company_info.sales_price_round_num)#&nbsp;#SESSION.EP.MONEY#</td>
                            <td class="text-right">
                            <cfset kdvli_indirimsatis = ((indirimli_satis_fiyat * satis_kdv) / 100) + indirimli_satis_fiyat>
                            #TLFormat(kdvli_indirimsatis,session.ep.our_company_info.sales_price_round_num)#&nbsp;#SESSION.EP.MONEY#</td>
                            <td class="text-right">#dateformat(INVOICE_DATE,dateformat_style)#</td>                
                        </tr>
                    </cfoutput>
                </tbody>
            </cf_grid_list>
        </cf_box>
            <!-- sil -->
        <cf_box title="#getLang('','Rakip Fiyatlar',37026)#">
            <cf_grid_list>
                <thead>
                    <tr> 
                        <th><cf_get_lang dictionary_id='58779.Rakip'></th>                
                        <th><cf_get_lang dictionary_id='57636.Birim'></th>
                        <th class="text-right"><cf_get_lang dictionary_id='58084.Fiyat'></th>
                        <th width="200"><cf_get_lang dictionary_id='37119.Geçerlilik Tarihi'></th>
                        <th width="20"><a href="javascript://" title="<cf_get_lang dictionary_id='37027.Rakip Fiyat Ekle'>" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=product.popup_form_add_rival_price&pid=#attributes.pid#</cfoutput>');"><i class="fa fa-plus"></i></a></th>
                    </tr>
                </thead>
                <tbody> 
                    <cfoutput query="GET_RIVAL_PRICES">
                        <tr>
                            <td height="20">#RIVAL_NAME#</td>                
                            <td>#UNIT#</td>
                            <td class="text-right"><a href="javascript://" class="tableyazi" onClick="windowopen('#request.self#?fuseaction=product.popup_form_upd_rival_price&pr_id=#pr_id#&pid=#attributes.pid#','small');">#TLFormat(PRICE,session.ep.our_company_info.sales_price_round_num)#&nbsp;#MONEY#</a></td>
                            <td>#dateformat(STARTDATE,dateformat_style)#-#dateformat(FINISHDATE,dateformat_style)#</td>
                            <cfsavecontent variable="delete_message"><cf_get_lang dictionary_id ='37775.Kayıtlı Fiyatı Siliyorsunuz! Emin misiniz'></cfsavecontent>
                            <td align="center"><a title="<cf_get_lang dictionary_id='57463.Sil'>" href="javascript://" onClick="javascript:if (confirm('#delete_message#')) document.location ='#request.self#?fuseaction=product.emptypopup_del_rival_price&pr_id=#pr_id#&head=#RIVAL_NAME#'; else return false;"><i class="fa fa-minus"></i></a></td>
                        </tr>
                    </cfoutput>
                </tbody> 
            </cf_grid_list>
        </cf_box>
        <cf_box title="#getLang('','settings',37230)#">
            <cf_grid_list>
                <thead>        
                    <tr> 
                        <th><cf_get_lang dictionary_id='58964.Fiyat Listesi'></th>
                        <th><cf_get_lang dictionary_id='37127.Önerilen Fiyat'></th>                
                        <th><cf_get_lang dictionary_id='37129.Öneriyi Yapan'></th>
                        <th><cf_get_lang dictionary_id='37119.Geçerlilik Tarihi'></th>
                            <th width="15" class="text-right">
                                <!--- <cfif len(get_product.PROD_COMPETITIVE) >
                                    <cfif listfind(COMPETITIVE_LIST,get_product.PROD_COMPETITIVE,",")>
                                        <cfset dontshow = 1 >
                                        <cfset str_url_open = "product.popup_form_add_product_price&pid=#get_product.product_id#" >
                                    <cfelse>
                                        <cfset dontshow = 0 >
                                        <cfset str_url_open = "product.list_price_change&event=add&pid=#get_product.product_id#">
                                    </cfif>
                                <cfelse>
                                    <cfset dontshow = 0 >
                                    <cfset str_url_open = "product.list_price_change&event=add&pid=#get_product.product_id#">
                                </cfif> --->
                                <cfset str_url_open = "product.list_price_change&event=add&pid=#get_product.product_id#">
                                <a href="javascript://" title="<cf_get_lang dictionary_id='37124.Fiyat Ekle'>" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=#str_url_open#</cfoutput>');">
                                    <i class="fa fa-plus"></i>
                                </a>
                            </th>
                    </tr>
                </thead>
                <tbody>
                    <cfset attributes.valid_only=1>
                    <cfinclude template="../query/get_price_change_detail.cfm">
                    <cfoutput query="GET_PRICE_CHANGE_DET" maxrows="10">
                        <tr>
                            <td>
                                <cfif PRICE_CATID gt 0>
                                    #PRICE_CAT#
                                <cfelseif PRICE_CATID eq -1>
                                    <cf_get_lang dictionary_id='58722.Standart Alış'>
                                <cfelse>
                                    <cf_get_lang dictionary_id='58721.Standart Satış'>
                                </cfif>
                            </td>
                            <td class="text-right">#TLFormat(PRICE,session.ep.our_company_info.sales_price_round_num)#&nbsp;#MONEY#</td>				
                            <td>#get_emp_info(RECORD_EMP,0,1)#</td>
                            <td>#dateformat(STARTDATE,dateformat_style)#<cfif len(FINISHDATE)> - #dateformat(FINISHDATE,dateformat_style)#</cfif></td>
                            <td width="15">
                                <a title="<cf_get_lang dictionary_id='57464.Güncelle'>" href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=product.list_price_change&event=upd&id=#PRICE_CHANGE_ID#&pid=#attributes.pid#');"><i class="fa fa-pencil"></i></a>                            </td>
                        </tr>
                    </cfoutput>
                </tbody> 
            </cf_grid_list>
        </cf_box>
    </div>
    <div class="col col-3 col-xs-12 uniqueRow">
        <cf_box title="#getLang('main',224)# - #getLang('product',188)#"
            id="stock_graph" 
            unload_body="1" 
            style="width:99%"
            closable="0"
            box_page="#request.self#?fuseaction=objects.popup_ajax_survey&pid=#pid#&type=5">
        </cf_box>
    </div>
</div>
<cfsetting showdebugoutput="yes">
