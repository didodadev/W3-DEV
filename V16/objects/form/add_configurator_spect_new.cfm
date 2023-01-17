<cfif isdefined("get_conf.ORIGIN") and len(get_conf.ORIGIN) and get_conf.ORIGIN eq 1>
<cfquery name="GET_PROD_TREE" datasource="#DSN3#">
	SELECT 
		STOCKS.PRODUCT_NAME,
		STOCKS.PRODUCT_ID,
		STOCKS.IS_PRODUCTION,
		STOCKS.STOCK_ID,
		STOCKS.STOCK_CODE,
		STOCKS.PROPERTY,
		PRODUCT_TREE.AMOUNT,
		PRODUCT_TREE.PRODUCT_TREE_ID,
		PRODUCT_TREE.SPECT_MAIN_ID,
		PRODUCT_UNIT.MAIN_UNIT,
		PRODUCT_TREE.IS_CONFIGURE,
		PRODUCT_TREE.IS_SEVK,
		PRODUCT_TREE.LINE_NUMBER,
		(SELECT SPECT_MAIN_NAME FROM SPECT_MAIN SM WHERE SM.SPECT_MAIN_ID = PRODUCT_TREE.SPECT_MAIN_ID) SPECT_MAIN_NAME
	FROM
		STOCKS,
		PRODUCT_TREE,
		PRODUCT_UNIT
	WHERE
		PRODUCT_UNIT.PRODUCT_UNIT_ID = PRODUCT_TREE.UNIT_ID AND
		PRODUCT_TREE.RELATED_ID = STOCKS.STOCK_ID AND
		PRODUCT_TREE.STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.stock_id#">
	ORDER BY  PRODUCT_TREE.LINE_NUMBER,STOCKS.PRODUCT_NAME
</cfquery>
<cfelse>
	<cfset get_prod_tree.recordcount=0>
</cfif>
<cfif get_prod_tree.recordcount>
	<cfoutput query="get_prod_tree">
		<cfset product_id_list=listappend(product_id_list,get_prod_tree.product_id,',')>
		<cfset tree_product_id_list=listappend(tree_product_id_list,get_prod_tree.product_id,',')>
	</cfoutput>
</cfif>
<cfif listlen(tree_product_id_list,',')>
	<cfquery name="GET_ALTERNATE_PRODUCT" datasource="#DSN3#">
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
			P.PRODUCT_ID NOT IN (SELECT PRODUCT_ID FROM ALTERNATIVE_PRODUCTS_EXCEPT WHERE ALTERNATIVE_PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_id#">) AND
			((
				P.PRODUCT_ID=AP.PRODUCT_ID AND
				AP.ALTERNATIVE_PRODUCT_ID IN (#tree_product_id_list#)
			)
			OR
			(
				P.PRODUCT_ID=AP.ALTERNATIVE_PRODUCT_ID AND
				AP.PRODUCT_ID IN (#tree_product_id_list#)
			))
	</cfquery>
	<cfoutput query="get_alternate_product">
		<cfset product_id_list=ListAppend(product_id_list,get_alternate_product.product_id,',')>
	</cfoutput>
</cfif>
<cfset product_id_list=ListDeleteDuplicates(product_id_list)>
<cfquery name="GET_PRICE_STANDART" datasource="#DSN3#">
	SELECT
		PRICE_STANDART.PRODUCT_ID,
		SM.MONEY,
		PRICE_STANDART.PRICE,
		PRICE_STANDART.PRICE_KDV,
		(PRICE_STANDART.PRICE*(SM.RATE2/SM.RATE1)) AS PRICE_STDMONEY,
		(PRICE_STANDART.PRICE_KDV*(SM.RATE2/SM.RATE1)) AS PRICE_KDV_STDMONEY,
		SM.RATE2,
		SM.RATE1,
		PRODUCT.IS_GIFT_CARD
	FROM
		PRODUCT,
		PRICE_STANDART,
		#dsn_alias#.SETUP_MONEY AS SM
	WHERE
		PRODUCT.PRODUCT_ID = PRICE_STANDART.PRODUCT_ID AND
		PURCHASESALES = <cfif spec_purchasesales eq 1>1<cfelse>0</cfif> AND
		PRICESTANDART_STATUS = 1 AND
			<cfif session_base.period_year lt 2009>
			((SM.MONEY = PRICE_STANDART.MONEY) OR (SM.MONEY = 'YTL') AND PRICE_STANDART.MONEY = 'TL') AND
		<cfelse>
			SM.MONEY = PRICE_STANDART.MONEY AND
		</cfif>
		SM.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.period_id#"> AND
		PRODUCT.PRODUCT_ID IN (#product_id_list#)
</cfquery>
<cfif not isdefined('is_show_cost') or (isdefined('is_show_cost') and is_show_cost eq 1)>
	<cfif listlen(product_id_list)>
		<cfquery name="GET_PRODUCT_COST_ALL" datasource="#DSN1#">
			SELECT  
				PRODUCT_ID,
				PURCHASE_NET_SYSTEM,
				PURCHASE_EXTRA_COST_SYSTEM
			FROM
				PRODUCT_COST	
			WHERE
				PRODUCT_COST_STATUS = 1
				AND PRODUCT_ID IN (#product_id_list#)
				ORDER BY START_DATE DESC,RECORD_DATE DESC
		</cfquery>
	</cfif>
</cfif>

<cfif spec_purchasesales eq 1 and isdefined("attributes.price_catid") and len(attributes.price_catid)>
	<cfquery name="GET_PRICE_MAIN_PROD" dbtype="query">
		SELECT * FROM GET_PRICE WHERE PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_id#">
	</cfquery>
</cfif>
<cfif not isdefined("get_price_main_prod") or get_price_main_prod.recordcount eq 0>
	<cfquery name="GET_PRICE_MAIN_PROD" dbtype="query">
		SELECT * FROM GET_PRICE_STANDART WHERE PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_id#">
	</cfquery>
</cfif>

<cf_grid_list id="product_tree">
	<thead>
		<tr>
			<cfoutput>
			<th style="width:35px;"></th>
			<th style="width:120px;">#get_product.stock_code#</th>
			<th style="width:300px;">#get_product.product_name# #get_product.property#</th>
			</cfoutput>
			<th style="text-align:right;" style="width:80px;"><cfoutput>#get_price_main_prod.price#</th>
			<th style="width:60px;">#get_price_main_prod.money#</th></cfoutput>
			<th colspan="13"></th>
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
			<th style="width:15px;"><cf_get_lang dictionary_id ='33926.SB'></th>
			<th class="text-center" style="width:15px;"><img src="/images/shema_list.gif" align="absmiddle" border="0" title="<cf_get_lang dictionary_id ='33927.Alt Ağaç'>"></th>
			<th class="text-right" style="width:45px;"><cf_get_lang dictionary_id ='57635.Miktar'>*</th>
			<th class="text-right" <cfif isdefined('is_show_diff_price') and is_show_diff_price eq 0> style="width:80px;display:none;"<cfelse>style="width:80px;"</cfif>><cf_get_lang dictionary_id ='33928.Fiyat Farkı'>*</th>
			<th <cfif isdefined('is_show_price') and is_show_price eq 0> style="width:60px;display:none;"<cfelse>style="width:60px;"</cfif>><cf_get_lang dictionary_id ='57489.Para Br'></th>
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
		<cfif get_prod_tree.recordCount gt 0>
		<cfoutput query="get_prod_tree">
			<cfif isQuery(get_price) and isdefined("get_price.product_id")>
				<cfquery name="GET_PRICE_MAIN" dbtype="query">
					SELECT
							*
					FROM
							GET_PRICE
					WHERE
							PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#product_id#">
				</cfquery>
			</cfif>
			<cfif not isdefined("get_price_main") or  get_price_main.recordcount eq 0>
				<cfquery name="GET_PRICE_MAIN" dbtype="query">
					SELECT
						*
					FROM
						GET_PRICE_STANDART
					WHERE
						PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#product_id#">
				</cfquery>
			</cfif>
			<cfif is_configure>
				<cfquery name="GET_ALTERNATIVE" dbtype="query">
					SELECT * FROM GET_ALTERNATE_PRODUCT WHERE ASIL_PRODUCT = <cfqueryparam cfsqltype="cf_sql_integer" value="#product_id#"> OR ALTERNATIVE_PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#product_id#">
				</cfquery>
			</cfif>
			<tr id="tree_row#currentrow#"<cfif isdefined('is_show_configure') and is_show_configure eq 1 and is_configure neq 1> style="display:none;"</cfif>>
				<td class="text-center" width="15">
					<input type="hidden" name="tree_row_kontrol#currentrow#" id="tree_row_kontrol#currentrow#" value="1">
					<input type="hidden" name="tree_is_configure#currentrow#" id="tree_is_configure#currentrow#" value="1">
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
						<input type="text" name="tree_stock_code#currentrow#" id="tree_stock_code#currentrow#" value="#STOCK_CODE#" style="width:120px" readonly>
					</div>
				</td>
				<td>
					<div class="form-group">
						<div class="input-group">
							<select name="tree_product_id#currentrow#" id="tree_product_id#currentrow#" <cfif isdefined('get_alternative') and get_alternative.recordcount and IS_CONFIGURE>style="background:FFCCCC;"</cfif> onChange="UrunDegis(this,'#currentrow#');document.getElementById('tree_total_amount_money#currentrow#').value=list_getat(this.value,4);">
								<option value="#product_id#,#stock_id#,#get_price_main.price#,#get_price_main.money#,#get_price_main.PRICE_STDMONEY#,#get_price_main.PRICE_KDV_STDMONEY#,#replace(PRODUCT_NAME,',','')# #PROPERTY#,#is_production#">#PRODUCT_NAME# #PROPERTY#</option>
								<cfif IS_CONFIGURE>
									<cfloop query="get_alternative">
										<cfif spec_purchasesales eq 1 and isQuery(get_price)>
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
										<option value="#get_alternative.PRODUCT_ID#,#get_alternative.stock_id#,#evaluate('get_price_alter#get_alternative.currentrow#.price')#,#evaluate('get_price_alter#get_alternative.currentrow#.money')#,#evaluate('get_price_alter#get_alternative.currentrow#.PRICE_STDMONEY')#,#evaluate('get_price_alter#get_alternative.currentrow#.PRICE_KDV_STDMONEY')#,#get_alternative.product_name# #get_alternative.PROPERTY#, #get_alternative.IS_PRODUCTION#">#get_alternative.product_name# #get_alternative.PROPERTY#</option>
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
				<td><div class="form-group"><input type="text" id="related_spect_main_id#currentrow#" title="Spec Bileşenleri" <cfif is_production eq 1>style="cursor:pointer;" onClick="document.getElementById('tree_std_money#currentrow#').value=document.getElementById('old_tree_std_money#currentrow#').value;goster(SHOW_PRODUCT_TREE_ROW#currentrow#);AjaxPageLoad('#request.self#?fuseaction=objects.popup_ajax_spect_detail_ajax&stock_id='+list_getat(document.all.tree_product_id#currentrow#.value,2,',')+'&product_id='+list_getat(document.all.tree_product_id#currentrow#.value,1,',')+'&currentrow=#currentrow#&spec_purchasesales=#spec_purchasesales#&RATE1=#get_money_2.RATE1#&RATE2=#get_money_2.RATE2#&is_spect_or_tree='+document.getElementById('related_spect_main_id#currentrow#').value+'','SHOW_PRODUCT_TREE_INFO#currentrow#',1)"</cfif> name="related_spect_main_id#currentrow#" value="<cfif is_production eq 1>#SPECT_MAIN_ID#</cfif>" readonly></div></td><!--- Spec --->
				<cfif is_production eq 1 and (not len(SPECT_MAIN_ID) or SPECT_MAIN_ID eq 0)>
					<script type="text/javascript">
						var deger = workdata('get_main_spect_id','#stock_id#');
						if(deger.SPECT_MAIN_ID != undefined)//ürün üretilsede ağacı olmayabilir,o sebeble fonksiyondan undefined değeri dönebilir,hata olursa  boşaltıyoruz related_spect_main_id'yi
						{
							var SPECT_MAIN_ID = deger.SPECT_MAIN_ID;
							var SPECT_MAIN_NAME = deger.SPECT_MAIN_NAME;
						}
						else
						{	
							var SPECT_MAIN_ID ='';
							var SPECT_MAIN_NAME ='';
						}
						<cfif is_change_spect_name eq 1>
							document.getElementById('related_spect_main_name#currentrow#').value= SPECT_MAIN_NAME;
						</cfif>
						document.getElementById('related_spect_main_id#currentrow#').value= SPECT_MAIN_ID;
						document.getElementById('related_spect_main_id#currentrow#').style.background ='CCCCCC';
					</script>
				</cfif>
				<td><div class="form-group"><input type="checkbox" name="tree_is_sevk#currentrow#" id="tree_is_sevk#currentrow#" value="1" <cfif is_sevk>checked</cfif>></div></td>
				<td class="text-center"><img src="/images/shema_list.gif"  title="<cf_get_lang dictionary_id ='33930.Ağaç Bileşenleri'>" id="under_tree#currentrow#"  style="cursor:pointer;"<cfif is_production neq 1>style="display:none"</cfif>  align="absmiddle" border="0" onClick="document.getElementById('tree_std_money#currentrow#').value=document.getElementById('old_tree_std_money#currentrow#').value;goster(SHOW_PRODUCT_TREE_ROW#currentrow#);AjaxPageLoad('#request.self#?fuseaction=objects.popup_ajax_spect_detail_ajax&stock_id='+list_getat(document.all.tree_product_id#currentrow#.value,2,',')+'&product_id='+list_getat(document.all.tree_product_id#currentrow#.value,1,',')+'&currentrow=#currentrow#&spec_purchasesales=#spec_purchasesales#&RATE1=#get_money_2.RATE1#&RATE2=#get_money_2.RATE2#','SHOW_PRODUCT_TREE_INFO#currentrow#',1);"></td>
				<td><div class="form-group"><input type="text" name="tree_amount#currentrow#" id="tree_amount#currentrow#" class="moneybox" onFocus="document.getElementById('reference_amount').value=filterNum(this.value,4)"  onKeyUp="FormatCurrency(this,event,2);UrunDegis(document.getElementById('tree_product_id#currentrow#'),'#currentrow#',1);" value="#TLFormat(AMOUNT,4)#" <cfif IS_CONFIGURE eq 0>readonly</cfif> autocomplete="off"></div></td>
				<td>
					<div class="form-group" <cfif isdefined('is_show_diff_price') and is_show_diff_price eq 0> style="display:none;"</cfif>>
						<input type="hidden" name="tree_total_amount#currentrow#" id="tree_total_amount#currentrow#" value="#TLFormat(0,4)#" onkeyup="return(FormatCurrency(this,event,2));" class="moneybox" onBlur="hesapla_('');" style="width:80px"  <cfif IS_CONFIGURE eq 0>readonly</cfif>>
						<input type="hidden" name="tree_kdvstd_money#currentrow#" id="tree_kdvstd_money#currentrow#" value="#get_price_main.price_kdv_stdmoney#">
						<input type="text" name="tree_diff_price#currentrow#" id="tree_diff_price#currentrow#" value="#TLFormat(0,4)#" onkeyup="return(FormatCurrency(this,event,2));" class="moneybox" onBlur="hesapla_('');" style="width:80px"  <cfif IS_CONFIGURE eq 0>readonly</cfif>>
					</div>
				</td>
				<td><div class="form-group" <cfif isdefined('is_show_price') and is_show_price eq 0> style="display:none"</cfif>><input name="tree_total_amount_money#currentrow#" id="tree_total_amount_money#currentrow#" readonly  type="text" value="#get_price_main.money#" style="width:50px"></div></td><!--- Para Br --->
				<cfif not isdefined('is_show_cost') or (isdefined('is_show_cost') and is_show_cost eq 1)>
					<cfquery name="get_product_cost" dbtype="query">
						SELECT * FROM get_product_cost_all WHERE PRODUCT_ID = #PRODUCT_ID#
					</cfquery>
					<cfif len(get_product_cost.PURCHASE_NET_SYSTEM)><cfset PURCHASE_NET_SYSTEM = get_product_cost.PURCHASE_NET_SYSTEM><cfelse><cfset PURCHASE_NET_SYSTEM = 0></cfif>
					<cfif len(get_product_cost.PURCHASE_EXTRA_COST_SYSTEM)><cfset PURCHASE_EXTRA_COST_SYSTEM = get_product_cost.PURCHASE_EXTRA_COST_SYSTEM><cfelse><cfset PURCHASE_EXTRA_COST_SYSTEM = 0></cfif>
					<td><div class="form-group"><input type="text" name="tree_product_cost#currentrow#" id="tree_product_cost#currentrow#" value="#TLFormat(PURCHASE_NET_SYSTEM+PURCHASE_EXTRA_COST_SYSTEM,4)#" readonly class="moneybox"></div></td>
				<cfelse>
					<td></td>
				</cfif>
				<td>
					<div class="form-group" <cfif isdefined('is_show_price') and is_show_price eq 0> style="display:none"</cfif>>
						<input type="hidden" name="reference_std_money#currentrow#" id="reference_std_money#currentrow#" value="#TLFormat(get_price_main.price_stdmoney,4)#" class="moneybox">
						<input type="hidden" name="old_tree_std_money#currentrow#" id="old_tree_std_money#currentrow#" value="#TLFormat(get_price_main.price_stdmoney,4)#" class="moneybox">
						<input type="text" name="tree_std_money#currentrow#" id="tree_std_money#currentrow#" value="#TLFormat(get_price_main.price_stdmoney,4)#" class="moneybox">
					</div>
				</td>
			</tr>
			<tr id="SHOW_PRODUCT_TREE_ROW#currentrow#" style="display:none;">
				<td colspan="11"><div id="SHOW_PRODUCT_TREE_INFO#currentrow#"></div></td>
			</tr>
		</cfoutput>
	</cfif>
		<input type="hidden" name="tree_record_num" id="tree_record_num" value="<cfoutput>#get_prod_tree.recordcount#</cfoutput>">
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
						<input type="hidden" name="rd_money_num" id="rd_money_num" value="#get_money.recordcount#">
						<cfloop query="get_money">
							<tr>
								<input type="hidden" name="urun_para_birimi#money#" id="urun_para_birimi#money#" value="#rate2/rate1#">
								<input type="hidden" name="rd_money_name_#currentrow#" id="rd_money_name_#currentrow#" value="#money#">
								<input type="hidden" name="txt_rate1_#currentrow#" id="txt_rate1_#currentrow#" value="#rate1#">
								<td><input type="radio" name="rd_money" id="rd_money" value="#money#,#rate1#,#rate2#" onClick="hesapla_();" <cfif money eq session.ep.money2>checked</cfif>>#money#</td>
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
							<td style="text-align:right;"><input type="text" name="toplam_miktar" id="toplam_miktar" value="0" style="width:100px;" class="box" readonly=""><cfoutput>#session.ep.money#</cfoutput></td>
							<td style="text-align:right;"><input type="text" name="other_toplam" id="other_toplam" value="" style="width:100px;" class="box" readonly="">&nbsp;
							<input type="text" name="doviz_name" id="doviz_name" value="" style="width:50px;" class="box" readonly=""></td>
						</tr>
					</cfoutput>
				</table>
			</div>
		</div>
	</div>
</div>