<cfquery name="GET_SPECT_ROW" datasource="#dsn3#">
        SELECT 
			STOCKS.IS_PRODUCTION,
			SPECTS_ROW.RELATED_SPECT_ID AS SPECT_MAIN_ID,
			SPECTS_ROW.*,
			STOCKS.STOCK_CODE,
			STOCKS.PROPERTY,
			STOCKS.IS_PRODUCTION,
            SPECTS_ROW.LINE_NUMBER,
			(SELECT SPECT_MAIN_NAME FROM SPECT_MAIN SM WHERE SM.SPECT_MAIN_ID = SPECTS_ROW.RELATED_SPECT_ID) SPECT_MAIN_NAME
		FROM 
			SPECTS_ROW,
			STOCKS
		WHERE 
			SPECT_ID = <cfqueryparam value = "#attributes.id#" CFSQLType = "cf_sql_integer">
			AND SPECTS_ROW.STOCK_ID=STOCKS.STOCK_ID
	UNION 
		SELECT
			0 AS IS_PRODUCTION,
			SPECTS_ROW.RELATED_SPECT_ID AS SPECT_MAIN_ID,
			SPECTS_ROW.*,
			'',
			'',
			0 AS IS_PRODUCTION,
            SPECTS_ROW.LINE_NUMBER,
			(SELECT SPECT_MAIN_NAME FROM SPECT_MAIN SM WHERE SM.SPECT_MAIN_ID = SPECTS_ROW.RELATED_SPECT_ID) SPECT_MAIN_NAME
		FROM 
			SPECTS_ROW
		WHERE 
			SPECT_ID = <cfqueryparam value = "#attributes.id#" CFSQLType = "cf_sql_integer"> AND
			STOCK_ID IS NULL
       ORDER BY  
       		SPECTS_ROW.LINE_NUMBER    
</cfquery>
<cfquery name="get_tree_types" datasource="#dsn#">
	SELECT TYPE_ID, #dsn#.Get_Dynamic_Language(TYPE_ID,'#session.ep.language#','PRODUCT_TREE_TYPE','TYPE',NULL,NULL,TYPE) AS TYPE
	 FROM PRODUCT_TREE_TYPE
</cfquery>
<cfset all_product_id_list = listdeleteduplicates(ValueList(GET_SPECT_ROW.PRODUCT_ID,','))>
<cfset all_product_conf_id_list = listdeleteduplicates(ValueList(GET_SPECT_ROW.CONFIGURATOR_VARIATION_ID,','))>
<cfif listlen(all_product_conf_id_list,',')>
    <cfloop list="#all_product_conf_id_list#" index="pfi_">
        <cfset 'selected_prod_conf_row_id_#pfi_#' = 1>
    </cfloop>
</cfif>
<cfif not isdefined('is_show_cost') or (isdefined('is_show_cost') and is_show_cost eq 1)>
<!---Maliyet Kısmı  --->
<cfif listlen(GET_SPECT_ROW.recordcount) and listlen(all_product_id_list)>
    <cfquery name="get_product_cost_all" datasource="#dsn1#"><!--- Maliyetler geliyor. --->
        SELECT  
            PRODUCT_ID,
            PURCHASE_NET_SYSTEM,
            PURCHASE_EXTRA_COST_SYSTEM
        FROM
            PRODUCT_COST	
        WHERE
            PRODUCT_COST_STATUS = 1
            AND PRODUCT_ID IN (#all_product_id_list#)
            ORDER BY START_DATE DESC,RECORD_DATE DESC
    </cfquery>
</cfif>
<!---Maliyet  --->
</cfif>
<cfset is_upd_ = 1>	
<cfquery name="GET_SPECT_PRO" dbtype="query">
	SELECT * FROM GET_SPECT_ROW WHERE IS_PROPERTY = 1
</cfquery>
<cfset row = get_spect_row.recordcount>
<cfset new_var_list = valuelist(GET_SPECT_PRO.CONFIGURATOR_VARIATION_ID)>
<cfset new_property_list = valuelist(GET_SPECT_PRO.property_id)>
<cfquery name="GET_SPECT_TREE" dbtype="query">
    SELECT * FROM GET_SPECT_ROW WHERE IS_PROPERTY IN(0,3,4)
</cfquery>
<cfset product_id_list = ''>
<cfoutput query="GET_SPECT_TREE">
    <cfif len(product_id)>
    <cfset product_id_list=listappend(product_id_list,product_id)>
    </cfif>
</cfoutput>
<cfif isdefined("product_id_list") and len(product_id_list)>
    <cfquery name="GET_ALTERNATE_PRODUCT" datasource="#dsn3#">
        SELECT
            DISTINCT
            AP.PRODUCT_ID ASIL_PRODUCT,
            AP.ALTERNATIVE_PRODUCT_ID,
            P.PRODUCT_NAME, 
            P.PRODUCT_ID,
            P.STOCK_ID,
            P.PROPERTY,
            P.IS_PRODUCTION
        FROM
            STOCKS AS P,
            ALTERNATIVE_PRODUCTS AS AP
        WHERE
            <cfif len(attributes.product_id)>
            P.PRODUCT_ID NOT IN (SELECT PRODUCT_ID FROM ALTERNATIVE_PRODUCTS_EXCEPT WHERE ALTERNATIVE_PRODUCT_ID=#attributes.product_id#) AND
            </cfif>
            (
                (
                P.PRODUCT_ID=AP.PRODUCT_ID AND
                AP.ALTERNATIVE_PRODUCT_ID IN (#product_id_list#)
                )
            OR
                (
                P.PRODUCT_ID=AP.ALTERNATIVE_PRODUCT_ID AND
                AP.PRODUCT_ID IN (#product_id_list#)
                )
            )
    </cfquery>
    <cfset product_id_alter_list=0>
    <cfoutput query="GET_ALTERNATE_PRODUCT">
        <cfset product_id_alter_list=ListAppend(product_id_alter_list,GET_ALTERNATE_PRODUCT.PRODUCT_ID,',')>
    </cfoutput>
    <cfquery name="GET_PRICE_STANDART" datasource="#dsn3#">
        SELECT
            PRICE_STANDART.PRODUCT_ID,
            SM.MONEY,
            PRICE_STANDART.PRICE,
            (PRICE_STANDART.PRICE*(SM.RATE2/SM.RATE1)) AS PRICE_STDMONEY,
            (PRICE_STANDART.PRICE_KDV*(SM.RATE2/SM.RATE1)) AS PRICE_KDV_STDMONEY,
            SM.RATE2,
            SM.RATE1
        FROM
            PRODUCT,
            PRICE_STANDART,
            #dsn_alias#.SETUP_MONEY AS SM
        WHERE
            PRODUCT.PRODUCT_ID = PRICE_STANDART.PRODUCT_ID AND
            PURCHASESALES = <cfif spec_purchasesales eq 1>1<cfelse>0</cfif> AND
            PRICESTANDART_STATUS = 1 AND
            <cfif session.ep.period_year lt 2009>
                ((SM.MONEY = PRICE_STANDART.MONEY) OR (SM.MONEY = 'YTL') AND PRICE_STANDART.MONEY = 'TL') AND
            <cfelse>
                SM.MONEY = PRICE_STANDART.MONEY AND
            </cfif>
            SM.PERIOD_ID = #session.ep.period_id# AND
            PRODUCT.PRODUCT_ID IN (#product_id_alter_list#)
    </cfquery>
</cfif>
<cf_grid_list id="product_tree">
    <thead>
        <tr>
            <cfoutput>
            <th></th>
            <th></th>
            <th colspan = "5">#GET_SPECT.SPECT_VAR_NAME#</th>
            <th class="text-right" colspan = "1">#TLFormat(1)#</th>
            <th></th>
            <th class="text-right">#GET_SPECT.PRODUCT_AMOUNT_CURRENCY#</th>
            <th></th>
            <th class="text-right">#TLFormat(GET_SPECT.PRODUCT_AMOUNT)#</th>
            <th colspan="6"></th>
            </cfoutput>
        </tr>
        <tr>
            <th class="text-center" style="width:15px;"><a href="javascript://" onClick="open_tree_add_row();"><i class="fa fa-plus"></a></th>
            <cfif isdefined('is_show_line_number') and is_show_line_number eq 1><th style="width:15px;"><cf_get_lang dictionary_id='57487.No'></th></cfif>
            <th style="width:120px;"><cf_get_lang dictionary_id ='57518.Stok Kodu'></th>
            <th style="width:200px;"><cf_get_lang dictionary_id ='57657.Ürün'>/<cf_get_lang dictionary_id ='57629.Açıklama'></th>
            <cfif is_change_spect_name eq 1>
                <th style="width:60px;"><cf_get_lang dictionary_id='54851.Spec Adı'></th>
            </cfif>
            <th style="width:60px;"><cf_get_lang dictionary_id='54850.Spec ID'></th>
            <th style="width:15px;"><cf_get_lang dictionary_id ='33926.Sevkte Birleştir'></th>
            <th class="text-center" style="width:15px;"><img src="/images/shema_list.gif" align="absmiddle" border="0" title="<cf_get_lang dictionary_id ='33927.Alt Ağaç'>"></th>
            <th class="text-right" style="width:45px;"><cf_get_lang dictionary_id ='57635.Miktar'>*</th>
            <th class="text-right" <cfif isdefined('is_show_diff_price') and is_show_diff_price eq 0> style="width:80px;display:none;"<cfelse>style="width:80px;"</cfif>><cf_get_lang dictionary_id ='33928.Fiyat Farkı'>*</th>
            <th class="text-right" <cfif isdefined('is_show_price') and is_show_price eq 0> style="width:60px;display:none;"<cfelse>style="width:60px;"</cfif>><cf_get_lang dictionary_id ='57489.Para Birimi'></th>
            <th class="text-right" <cfif isdefined('is_show_cost') and is_show_cost eq 0> style="width:60px;display:none;"<cfelse>style="width:60px;"</cfif>><cf_get_lang dictionary_id='58258.Maliyet'></th>
            <th class="text-right" <cfif isdefined('is_show_price') and is_show_price eq 0> style="width:100px;display:none;"<cfelse> style="width:100px;"</cfif>><cf_get_lang dictionary_id='58084.Fiyat'></th>
            <cfif isdefined('get_conf.origin') and get_conf.origin eq 3><th style="width:100px;" ><cf_get_lang dictionary_id='63502.Bileşen Tipi'></th></cfif>
            <cfif isdefined('get_conf.origin') and get_conf.origin eq 3 and len(get_conf.USE_WIDTH) and get_conf.USE_WIDTH eq 1><th><cf_get_lang dictionary_id='48152.En'></th></cfif>
            <cfif isdefined('get_conf.origin') and get_conf.origin eq 3 and len(get_conf.USE_SIZE) and get_conf.USE_SIZE eq 1><th><cf_get_lang dictionary_id='55735.Boy'></th></cfif>
            <cfif isdefined('get_conf.origin') and get_conf.origin eq 3 and len(get_conf.USE_HEIGHT) and get_conf.USE_HEIGHT eq 1><th><cf_get_lang dictionary_id='57696.Yükseklik'></th></cfif>
            <cfif isdefined('get_conf.origin') and get_conf.origin eq 3 and len(get_conf.USE_THICKNESS) and get_conf.USE_THICKNESS eq 1><th><cf_get_lang dictionary_id='75.Kalınlık'></th></cfif>
            <cfif isdefined('get_conf.origin') and get_conf.origin eq 3 and len(get_conf.USE_FIRE) and get_conf.USE_FIRE eq 1><th><cf_get_lang dictionary_id='36356.Fire Miktarı'></th></cfif>              
            </tr>
    </thead>
    <tbody>
        <cfoutput query="GET_SPECT_TREE">
            <cfif session.ep.period_year gt 2008 and GET_SPECT_TREE.MONEY_CURRENCY is 'YTL'><cfset GET_SPECT_TREE.MONEY_CURRENCY = 'TL'></cfif>
            <cfif session.ep.period_year lt 2009 and GET_SPECT_TREE.MONEY_CURRENCY is 'TL'><cfset GET_SPECT_TREE.MONEY_CURRENCY = 'YTL'></cfif>
            <cfif is_configure and len(product_id)>
                <cfquery name="get_alternative" dbtype="query">
                    SELECT * FROM GET_ALTERNATE_PRODUCT WHERE ASIL_PRODUCT=#PRODUCT_ID# OR ALTERNATIVE_PRODUCT_ID=#PRODUCT_ID#
                </cfquery>
            </cfif>
            <tr id="tree_row#currentrow#"<cfif isdefined('is_show_configure') and is_show_configure eq 1 and IS_CONFIGURE neq 1> style="display:none;"</cfif>>
                <td>
                    <input type="hidden" name="tree_row_kontrol#currentrow#" id="tree_row_kontrol#currentrow#" value="1">
                    <input type="hidden" name="tree_is_configure#currentrow#" id="tree_is_configure#currentrow#" value="<cfif is_configure>1</cfif>">
                    <cfif is_configure><a href="javascript://" onClick="sil_tree_row(#currentrow#)"><i class="fa fa-minus" title = "<cf_get_lang dictionary_id ='50765.Ürün Sil'>"></i></a></cfif>
                </td>
                <cfif isdefined('is_show_line_number') and is_show_line_number eq 1>
                    <td align="center">
                        <div class="form-group">
                            <input type="text" name="line_number#currentrow#" id="line_number#currentrow#" style="width:15px;text-align:right" class="box" readonly value="#LINE_NUMBER#">
                        </div>
                    </td>
                </cfif>
                <td>
                    <div class="form-group">
                        <input type="hidden" name="tree_stock_id#currentrow#" id="tree_stock_id#currentrow#" value="#GET_SPECT_TREE.STOCK_ID#">
                        <input type="text" name="tree_stock_code#currentrow#" id="tree_stock_code#currentrow#" value="#GET_SPECT_TREE.STOCK_CODE#" style="width:120px" readonly>
                    </div>
                </td>
                <cfquery name="GET_FISRT_PRO_PRICE" dbtype="query"><!--- Sistem para birimi cinsinden tutarı buluyoruz --->
                    SELECT (RATE2/RATE1) RATE FROM GET_MONEY WHERE MONEY = '#GET_SPECT_TREE.MONEY_CURRENCY#'
                </cfquery>
                <cfset first_pro_rate=GET_FISRT_PRO_PRICE.RATE>
                <cfif not len(first_pro_rate)><cfset first_pro_rate = 1></cfif><!--- Sonradan Eklenmiş Olan Para Birimi Varsa,bulamayacağı için 1 set ediyoruz. --->
                <td>
                    <div class="form-group">
                        <div class="input-group">	
                            <select name="tree_product_id#currentrow#" id="tree_product_id#currentrow#" <cfif isdefined('get_alternative') and get_alternative.recordcount  and IS_CONFIGURE></cfif> onChange="UrunDegis(this,'#currentrow#');">
                                <cfif not len(stock_id)><cfset stock_id_ = 0><cfset product_id_ = 0><cfelse><cfset stock_id_ = stock_id><cfset product_id_ = product_id></cfif>
                                <cfif not len(operation_type_id)><cfset operation_type_id_ = 0><cfelse><cfset operation_type_id_ = operation_type_id></cfif>
                                <option value="#product_id_#,#stock_id_#,#GET_SPECT_TREE.TOTAL_VALUE#,#GET_SPECT_TREE.MONEY_CURRENCY#,#GET_SPECT_TREE.TOTAL_VALUE*first_pro_rate#,'0',#replace(PRODUCT_NAME,',','')#,#IS_PRODUCTION#,#operation_type_id_#">#PRODUCT_NAME#</option>
                                <cfif is_configure and len(product_id)>
                                    <cfloop query="get_alternative">
                                        <cfif isQuery(get_price)>
                                            <cfquery name="GET_PRICE_ALTER#get_alternative.currentrow#" dbtype="query">
                                                SELECT
                                                    *
                                                FROM
                                                    GET_PRICE
                                                WHERE
                                                    PRODUCT_ID=#get_alternative.product_id#
                                            </cfquery>
                                        </cfif>
                                        <cfif not isdefined("GET_PRICE_ALTER#get_alternative.currentrow#") or evaluate('GET_PRICE_ALTER#get_alternative.currentrow#.RECORDCOUNT') eq 0 or evaluate('GET_PRICE_ALTER#get_alternative.currentrow#.price') eq 0>
                                            <cfquery name="GET_PRICE_ALTER#get_alternative.currentrow#" dbtype="query">
                                                SELECT
                                                    *
                                                FROM
                                                    GET_PRICE_STANDART
                                                WHERE
                                                    PRODUCT_ID=#get_alternative.product_id#
                                            </cfquery>
                                        </cfif>
                                        <option value="#get_alternative.PRODUCT_ID#,#get_alternative.stock_id#,#evaluate('get_price_alter#get_alternative.currentrow#.price')#,#evaluate('get_price_alter#get_alternative.currentrow#.money')#,#evaluate('get_price_alter#get_alternative.currentrow#.PRICE_STDMONEY')#,#evaluate('get_price_alter#get_alternative.currentrow#.PRICE_KDV_STDMONEY')#,#get_alternative.product_name# #get_alternative.PROPERTY#, #get_alternative.IS_PRODUCTION#" <cfif get_alternative.stock_id eq GET_SPECT_TREE.stock_id>selected</cfif>>#get_alternative.product_name# #get_alternative.PROPERTY#</option>
                                    </cfloop>
                                </cfif>
                            </select>
                            <span class="input-group-addon btnPointer icon-ellipsis" onClick="windowopen('#request.self#?fuseaction=objects.popup_detail_product&pid='+list_getat(document.add_spect_variations.tree_product_id#currentrow#.value,1)+'&sid='+list_getat(document.add_spect_variations.tree_product_id#currentrow#.value,2),'medium')" title="<cf_get_lang dictionary_id ='46799.Ürün Detay'>"></span>
                        </div>
                    </div>	
                </td>
                <cfif is_change_spect_name eq 1>
                    <td>
                        <div class="form-group"><input type="text" id="related_spect_main_name#currentrow#" name="related_spect_main_name#currentrow#" value="#SPECT_MAIN_NAME#"></div>
                    </td>
                </cfif>
                <td><input type="text" id="related_spect_main_id#currentrow#" title="Spect Bileşenleri" <cfif is_production eq 1> style="cursor:pointer;" onClick="document.getElementById('tree_std_money#currentrow#').value=document.getElementById('old_tree_std_money#currentrow#').value;goster(SHOW_PRODUCT_TREE_ROW#currentrow#);AjaxPageLoad('#request.self#?fuseaction=objects.popup_ajax_spect_detail_ajax#xml_str#&stock_id='+list_getat(document.getElementById('tree_product_id#currentrow#').value,2,',')+'&product_id='+list_getat(document.getElementById('tree_product_id#currentrow#').value,1,',')+'&satir=#currentrow#&spec_purchasesales=#spec_purchasesales#&RATE1=#get_money_2.RATE1#&RATE2=#get_money_2.RATE2#&is_spect_or_tree='+document.getElementById('related_spect_main_id#currentrow#').value+'','SHOW_PRODUCT_TREE_INFO#currentrow#',1);"</cfif> name="related_spect_main_id#currentrow#" style="width:125px;" class="box" value="<cfif len(SPECT_MAIN_ID) and SPECT_MAIN_ID neq 0 and is_production eq 1>#SPECT_MAIN_ID#</cfif>" readonly></td><!--- Spec --->
                <cfif is_production eq 1 and (not len(SPECT_MAIN_ID) or SPECT_MAIN_ID eq 0)><!--- Eğer ürün üretiliyor ise,o anki main spect'ini alıcaz ve 1 üst satırdaki related_spect_main_id kısmına yazdırıcaz --->
                    <script type="text/javascript">
                        var deger = workdata('get_main_spect_id','#stock_id#');
                        if(deger.SPECT_MAIN_ID != undefined)//ürün üretilsede ağacı olmayabilir,o sebeble fonksiyondan undefined değeri dönebilir,hata olursa  boşaltıyoruz related_spect_main_id'yi
                        var SPECT_MAIN_ID = deger.SPECT_MAIN_ID;else	var SPECT_MAIN_ID ='';
                        document.getElementById('related_spect_main_id#currentrow#').value= SPECT_MAIN_ID;
                        document.getElementById('related_spect_main_id#currentrow#').style.background ='CCCCCC';
                    </script>
                </cfif>
                <td><div class="form-group"><input type="checkbox" name="tree_is_sevk#currentrow#" id="tree_is_sevk#currentrow#" value="1" <cfif GET_SPECT_TREE.IS_SEVK>checked</cfif>></div></td>
                <!--- Alt Ağaç --->
                <td class="text-center"><img src="/images/shema_list.gif" id="under_tree#currentrow#" title="<cf_get_lang dictionary_id ='33930.Ağaç Bileşenleri'>" style="cursor:pointer;" <cfif is_production neq 1>style="display:none"</cfif>  align="absmiddle" border="0" onClick="document.getElementById('tree_std_money#currentrow#').value=document.getElementById('old_tree_std_money#currentrow#').value;goster(SHOW_PRODUCT_TREE_ROW#currentrow#);AjaxPageLoad('#request.self#?fuseaction=objects.popup_ajax_spect_detail_ajax#xml_str#&stock_id='+list_getat(document.getElementById('tree_product_id#currentrow#').value,2,',')+'&product_id='+list_getat(document.getElementById('tree_product_id#currentrow#').value,1,',')+'&satir=#currentrow#&spec_purchasesales=#spec_purchasesales#&RATE1=#get_money_2.RATE1#&RATE2=#get_money_2.RATE2#','SHOW_PRODUCT_TREE_INFO#currentrow#',1);"></td>
                <!--- Alt Ağaç --->
                <td><div class="form-group"><input name="tree_amount#currentrow#" id="tree_amount#currentrow#" type="text" class="moneybox" style="width:col col-12" onFocus="document.getElementById('reference_amount').value=filterNum(this.value,8)"  onKeyUp="UrunDegis(document.getElementById('tree_product_id#currentrow#'),'#currentrow#',1);" value="#TLFormat(wrk_round(GET_SPECT_TREE.AMOUNT_VALUE,8,1),8)#" <cfif IS_CONFIGURE eq 0>readonly</cfif> autocomplete="off"></div></td>
                <td>
                    <div class="form-group" <cfif isdefined('is_show_diff_price') and is_show_diff_price eq 0> style="display:none;"</cfif>>
                        <!--- Ana ürün bazında fiyat farkı --->
                        <input type="hidden" name="tree_total_amount#currentrow#" id="tree_total_amount#currentrow#" value="#TLFormat(GET_SPECT_TREE.DIFF_PRICE,8)#" onkeyup="return(FormatCurrency(this,event,8));" class="moneybox" onBlur="hesapla_('');" style="width:80px"  <cfif IS_CONFIGURE eq 0>readonly</cfif>>
                        <!--- Kendi para biriminde fiyat farkı --->
                        <input type="text" name="tree_diff_price#currentrow#" id="tree_diff_price#currentrow#" value="#TLFormat(0,8)#" onkeyup="return(FormatCurrency(this,event,8));" class="moneybox" onBlur="hesapla_('');" style="width:80px"  <cfif IS_CONFIGURE eq 0>readonly</cfif>>
                        <!--- <input type="hidden" name="tree_kdvstd_money#currentrow#" value="#get_price_main.price_kdv_stdmoney#"> --->
                        <!--- Fiyat Farkı --->
                    </div>
                </td>
                <td><div class="form-group" <cfif isdefined('is_show_price') and is_show_price eq 0> style="display:none"</cfif>><input name="tree_total_amount_money#currentrow#" id="tree_total_amount_money#currentrow#" readonly  type="text" value="#GET_SPECT_TREE.money_currency#" style="width:50px"></div></td><!--- Para Br --->
                <cfif not isdefined('is_show_cost') or (isdefined('is_show_cost') and is_show_cost eq 1)>
                    <!--- Maliyet --->
                    <cfif len(PRODUCT_ID)>
                        <cfquery name="get_product_cost" dbtype="query"><!--- Maliyetler geliyor. --->
                            SELECT * FROM get_product_cost_all WHERE PRODUCT_ID = #PRODUCT_ID#
                        </cfquery>
                    <cfelse>
                        <cfset get_product_cost.PURCHASE_NET_SYSTEM = 0>
                        <cfset get_product_cost.PURCHASE_EXTRA_COST_SYSTEM = 0>
                    </cfif>
                    <!--- maliyetleri yoksa 0 set ediliyor. --->
                    <cfif len(get_product_cost.PURCHASE_NET_SYSTEM)><cfset PURCHASE_NET_SYSTEM = get_product_cost.PURCHASE_NET_SYSTEM><cfelse><cfset PURCHASE_NET_SYSTEM = 0></cfif>
                    <cfif len(get_product_cost.PURCHASE_EXTRA_COST_SYSTEM)><cfset PURCHASE_EXTRA_COST_SYSTEM = get_product_cost.PURCHASE_EXTRA_COST_SYSTEM><cfelse><cfset PURCHASE_EXTRA_COST_SYSTEM = 0></cfif>
                    <td><div class="form-group"><input type="text" name="tree_product_cost#currentrow#" id="tree_product_cost#currentrow#" value="#TLFormat(PURCHASE_NET_SYSTEM+PURCHASE_EXTRA_COST_SYSTEM,8)#" readonly class="moneybox" style="width:50px"></div></td>
                    <!--- Maliyet --->
                <cfelse>
                    <td></td>
                </cfif>
                <!--- spectin satırlarındaki secili ürünlerin fiyatlarının session.ep.money cinsinden tutarını bulmak için kur seçiliyor--->
                <td>
                    <div class="form-group" <cfif isdefined('is_show_price') and is_show_price eq 0> style="display:none"</cfif>>
                        <input type="hidden" name="reference_std_money#currentrow#" id="reference_std_money#currentrow#" value="#TLFormat(GET_SPECT_TREE.TOTAL_VALUE*first_pro_rate,8)#" class="moneybox" style="width:50px">
                        <input type="hidden" name="old_tree_std_money#currentrow#" id="old_tree_std_money#currentrow#" value="#TLFormat(GET_SPECT_TREE.TOTAL_VALUE*first_pro_rate,8)#" class="moneybox" style="width:50px">
                        <input type="text" name="tree_std_money#currentrow#" id="tree_std_money#currentrow#" value="#TLFormat(GET_SPECT_TREE.TOTAL_VALUE*first_pro_rate,8)#"class="moneybox" style="width:50px">
                    </div>
                </td>
				    <cfif isdefined('get_conf.origin') and get_conf.origin eq 3>
                    <td>
                        <div class="form-group">
                            <select name="tree_types#currentrow#" id="tree_types#currentrow#"><option value=""><cf_get_lang dictionary_id='63502.Bileşen Tipi'></option><cfloop query="get_tree_types"><option value="#TYPE_ID#" <cfif TYPE_ID eq GET_SPECT_TREE.TREE_TYPE>selected</cfif>>#TYPE#</option></cfloop></select>
                        </div>
                    </td>
                    </cfif>
					<cfif isdefined('get_conf.origin') and get_conf.origin eq 3 and len(get_conf.USE_WIDTH) and get_conf.USE_WIDTH eq 1>
                    <td>
                        <div class="form-group">
                            <input type="text" name="product_width#currentrow#" id="product_width#currentrow#" value="#TLFormat(PRODUCT_WIDTH)#">
                        </div>
                    </td>
                    </cfif>
					<cfif isdefined('get_conf.origin') and get_conf.origin eq 3 and len(get_conf.USE_SIZE) and get_conf.USE_SIZE eq 1>
                    <td>
                        <div class="form-group">
                            <input type="text" name="product_size#currentrow#" id="product_size#currentrow#" value="#TLFormat(PRODUCT_SIZE)#">
                        </div>
                    </td>
                    </cfif>
					<cfif isdefined('get_conf.origin') and get_conf.origin eq 3 and len(get_conf.USE_HEIGHT) and get_conf.USE_HEIGHT eq 1>
                    <td>
                        <div class="form-group">
                            <input type="text" name="product_height#currentrow#" id="product_height#currentrow#" value="#TLFormat(PRODUCT_HEIGHT)#">
                        </div>
                    </td>
                    </cfif>
					<cfif isdefined('get_conf.origin') and get_conf.origin eq 3 and len(get_conf.USE_THICKNESS) and get_conf.USE_THICKNESS eq 1>
                        <td>
                            <div class="form-group">
                                <input type="text" name="product_thickness#currentrow#" id="product_thickness#currentrow#" value="#TLFormat(PRODUCT_THICKNESS)#">
                            </div>
                        </td>
                    </cfif>
					<cfif isdefined('get_conf.origin') and get_conf.origin eq 3 and len(get_conf.USE_FIRE) and get_conf.USE_FIRE eq 1>
                        <td>
                            <div class="form-group"><input type="text" name="fire_amount#currentrow#" id="fire_amount#currentrow#" value="#TLFormat(FIRE_AMOUNT)#">
                            </div>
                        </td>
                    </cfif>
            </tr>
            <tr id="SHOW_PRODUCT_TREE_ROW#currentrow#" style="display:none;">
                <td colspan="11"><div id="SHOW_PRODUCT_TREE_INFO#currentrow#"></div></td>
            </tr>
        </cfoutput>
        <input type="hidden" name="tree_record_num" id="tree_record_num" value="<cfoutput>#GET_SPECT_TREE.RECORDCOUNT#</cfoutput>">
    </tbody>
</cf_grid_list>
<div id="sepetim_total" class="col col-12 pdn-l-0 pdn-r-0">
    <div class="col col-4 col-md-5 col-sm-6 col-xs-12 pdn-l-0">
        <div class="totalBox">
            <div class="totalBoxHead font-grey-mint">
                <span class="headText"><cf_get_lang dictionary_id ='33851.Dövizler'></span>
                <div class="collapse">
                    <span class="icon-minus"></span>
                </div>
            </div>
            <div class="totalBoxBody">
                <table>
                    <cfoutput>
                        <cfset money_selected_list = ValueList(get_money.IS_SELECTED,',')>
                        <!--- Bu kısım eğer üretim emrinden spect güncelleme ekranı açılırsa rd_money boş geldiği için eklendi,M.ER --->
                        <!--- Eğer get_money'dan true değer dönmüyorsa yani hepsi 0 geliyor ise rd_money'i get_money query'sinin içinden  session.ep.money2'i hangisine eşitse onu seçiyorum. --->
                        <cfif not ListFind(money_selected_list,true,',') and len(session.ep.money2)>
                            <cfset rd_money = ListGetAt(ValueList(get_money.MONEY,','),ListFind(ValueList(get_money.MONEY,','),session.ep.money2,','),',')>
                        </cfif>
                        <input type="hidden" name="rd_money_num" id="rd_money_num" value="#get_money.recordcount#">
                        <cfloop query="get_money">
                            <tr>
                                <input type="hidden" name="urun_para_birimi#money#" id="urun_para_birimi#money#" value="#rate2/rate1#">
                                <input type="hidden" name="rd_money_name_#currentrow#" id="rd_money_name_#currentrow#" value="#money#">
                                <input type="hidden" name="txt_rate1_#currentrow#" id="txt_rate1_#currentrow#" value="#rate1#">
                                <td><input type="radio" name="rd_money" id="rd_money" value="#money#,#rate1#,#rate2#" onClick="hesapla_();" <cfif money eq session_base.money2>checked</cfif>>#money#</td>
                                <td>#TLFormat(rate1,4)#/</td>
                                <td><input type="text" name="txt_rate2_#currentrow#" id="txt_rate2_#currentrow#" value="#TLFormat(rate2,4)#" style="width:50px;" class="box" onkeyup="return(FormatCurrency(this,event,4));" onBlur="hesapla_();"></td>
                            </tr>
                        </cfloop>
                    </cfoutput>
                </table>
            </div>
        </div>
    </div>
    <div class="col col-4 col-md-5 col-sm-6 col-xs-12">
        <div class="totalBox">
            <div class="totalBoxHead font-grey-mint">
                <span class="headText">Toplam </span>
                <div class="collapse">
                    <span class="icon-minus"></span>
                </div>
            </div>
            <div class="totalBoxBody">
                <table>
                    <tr>
                        <td style="text-align:right;"><cf_get_lang dictionary_id ='57492.Toplam'></td>
                        <td style="text-align:right;"><cf_get_lang dictionary_id ='58124.Döviz Toplam'></td>
                    </tr>
                    <cfoutput>
                        <tr>
                            <td style="text-align:right;"><input type="text" name="toplam_miktar" id="toplam_miktar" value="0" style="width:100px;" class="box" readonly=""><cfoutput>#session_base.money#</cfoutput></td>
                            <td style="text-align:right;"><input type="text" name="other_toplam" id="other_toplam" value="" style="width:100px;" class="box" readonly="">&nbsp;
                            <input type="text" name="doviz_name" id="doviz_name" value="" style="width:50px;" class="box" readonly=""></td>
                        </tr>
                    </cfoutput>
                </table>
            </div>
        </div>
    </div>
</div>