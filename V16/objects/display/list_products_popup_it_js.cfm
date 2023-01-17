<!--- EA sql pagging ile alaklı olarak düzenleme yapıldı 09.07.2012--->
<cfparam name="attributes.keyword" default="">
<cfif isdefined("attributes.search_process_date")>
	<cfif isdate(attributes.search_process_date) and session_base.period_year neq year(attributes.search_process_date) and attributes.int_basket_id neq 7>
		<!--- 20050218 bu uyari da sadece donem db ye kaydedilen islemler icin yapilmali (fatura-irsaliye vb) ve kaldı ki bu da ustteki gibi control_comp_selected() js function in ilgili kisimlarina girmeli, 
			yani basket_id ile de kontrol edilmeli, teklif siparis icin boyle bir durum olmamali, yoksa aralikta ocak icin siparis veren sorun yasar. --->
		<script type="text/javascript">
			alert("<cf_get_lang dictionary_id ='34133.İşlem Tarihi döneminize uygun değil'>!");
			window.close();
		</script>
		<cfabort>
	</cfif>
</cfif>
<cfparam name="attributes.int_basket_id" default="">
<cfparam name="attributes.employee" default="">
<cfparam name="attributes.pos_code" default="">
<cfparam name="attributes.get_company_id" default="">
<cfparam name="attributes.get_company" default="">
<cfparam name="attributes.product_cat" default="">
<cfparam name="attributes.product_catid" default="0">
<cfparam name="attributes.brand_id" default="">
<cfparam name="attributes.brand_name" default="">
<cfif isdefined("xml_sort_type")>
	<cfparam name="attributes.sort_type" default="#xml_sort_type#">
<cfelse>
	<cfparam name="attributes.sort_type" default="0">
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default="#session.ep.maxrows#">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfif not (isDefined('attributes.amount_multiplier')and isnumeric(attributes.amount_multiplier)) or attributes.amount_multiplier lte 0>
  <cfset attributes.amount_multiplier = 1>
</cfif>
<cfinclude template="../query/get_moneys.cfm">
<cfif isdefined('form.is_form_submitted') or (isDefined("attributes.keyword") and len(attributes.keyword))>
	<cfquery name="PRODUCTS" datasource="#DSN3#">
	WITH CTE1 AS (
		SELECT 
			STOCKS.STOCK_ID,
			STOCKS.PRODUCT_ID,
			STOCKS.STOCK_CODE,
			STOCKS.STOCK_CODE_2,
			PRODUCT.PRODUCT_NAME,
			STOCKS.PROPERTY,
			STOCKS.BARCOD AS BARCOD,
			PRODUCT.IS_INVENTORY,
			PRODUCT.IS_PRODUCTION,
			<cfif isdefined('attributes.is_sale_product') and attributes.is_sale_product eq 0>
				PRODUCT.TAX_PURCHASE AS TAX,
			<cfelse>
				PRODUCT.TAX AS TAX,
			</cfif>
			PRODUCT.OTV AS OTV,
			PRODUCT.IS_ZERO_STOCK,
			PRODUCT.PRODUCT_CATID,
			PRODUCT.PRODUCT_CODE,
			PRODUCT.IS_SERIAL_NO,
			PRODUCT.IS_SALES,
			PRODUCT.PRODUCT_DETAIL,
			STOCKS.MANUFACT_CODE,
			PU.ADD_UNIT,
			PU.UNIT_ID,
			PU.PRODUCT_UNIT_ID,
			PU.MAIN_UNIT,
			PU.MULTIPLIER,
			PRODUCT.TAX_PURCHASE 
		FROM
			PRODUCT,
			STOCKS,
			PRODUCT_UNIT PU
		WHERE
		 <!---  <cfif not isdefined('form.is_form_submitted')>
			PRODUCT.PRODUCT_ID IS NULL AND 
		  </cfif> --->
			PRODUCT.PRODUCT_STATUS = 1 AND
			STOCKS.STOCK_STATUS = 1 AND
			PU.PRODUCT_UNIT_ID = STOCKS.PRODUCT_UNIT_ID AND
			PRODUCT.PRODUCT_ID = STOCKS.PRODUCT_ID
		  	<cfif isdefined("attributes.is_sale_product") and attributes.is_sale_product eq 1>
                AND PRODUCT.IS_SALES = 1 
            </cfif>
            <cfif isdefined("attributes.is_sale_product") and attributes.is_sale_product eq 0>
            	<cfif isdefined("attributes.demand_type") and attributes.demand_type eq 0>
                AND (PRODUCT.IS_PURCHASE = 1 OR PRODUCT.IS_PRODUCTION = 1)
                <cfelse>
                AND PRODUCT.IS_PURCHASE = 1 
                </cfif>
            </cfif>
			<cfif len(attributes.product_cat) and len(attributes.product_catid)>
				AND PRODUCT.PRODUCT_CODE LIKE (SELECT HIERARCHY FROM PRODUCT_CAT WHERE PRODUCT_CATID=<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_catid#">)+'.%' <!---kategori hiyerarşisine gore arama yapıyor --->
		  	</cfif>
		  	<cfif len(attributes.employee) and len(attributes.pos_code)>
				AND PRODUCT.PRODUCT_MANAGER = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pos_code#">
		  	</cfif>
		  	<cfif len(attributes.get_company) and len(attributes.get_company_id)>
				AND PRODUCT.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.get_company_id#">
		  	</cfif>
		  	<cfif len(attributes.brand_id) and len(attributes.brand_name)>
				AND PRODUCT.BRAND_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.brand_id#">
		  	</cfif>
		  	<cfif isdefined("attributes.list_property_id") and len(attributes.list_property_id) and len(attributes.list_variation_id)>
				AND
				PRODUCT.PRODUCT_ID IN
				(
					SELECT
						PRODUCT_ID
					FROM
						#dsn1_alias#.PRODUCT_DT_PROPERTIES PRODUCT_DT_PROPERTIES
					WHERE
						(
					  <cfloop from="1" to="#listlen(attributes.list_property_id,',')#" index="pro_index">
						(PROPERTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ListGetAt(attributes.list_property_id,pro_index,",")#"> AND VARIATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ListGetAt(attributes.list_variation_id,pro_index,",")#">)
						<cfif pro_index lt listlen(attributes.list_property_id,',')>OR</cfif>
					  </cfloop>
						)
					GROUP BY
						PRODUCT_ID
					HAVING
						COUNT(PRODUCT_ID)> = <cfqueryparam cfsqltype="cf_sql_integer" value="#listlen(attributes.list_property_id,',')#">
				)
		  	</cfif>
		  	<cfif isDefined("attributes.keyword") and len(attributes.keyword) gt 1>
				AND
				(
					<cfif  isdefined('attributes.sort_type') and attributes.sort_type eq 1 >
						(STOCKS.STOCK_CODE LIKE '<cfif len(attributes.keyword) gt 3>%</cfif>#attributes.keyword#%'
						OR  
                    	STOCKS.STOCK_CODE_2 LIKE '<cfif len(attributes.keyword) gt 3>%</cfif>#attributes.keyword#%' 
                        )
                     </cfif>
                     <cfif  isdefined('attributes.sort_type') and attributes.sort_type eq 0 >
						PRODUCT.PRODUCT_NAME LIKE #sql_unicode()#'%#attributes.keyword#%'
                     </cfif>
					<!--- OR PRODUCT.PRODUCT_DETAIL LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#">  --->
                    <cfif  isdefined('attributes.sort_type') and attributes.sort_type eq 3 >
					   STOCKS.BARCOD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#"> 
                    </cfif>
                    <cfif  isdefined('attributes.sort_type') and attributes.sort_type eq 2 >
					   PRODUCT.MANUFACT_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
                    </cfif>
				)
		  	<cfelseif isDefined("attributes.keyword") and len(attributes.keyword) eq 1 and isdefined('attributes.sort_type') and attributes.sort_type eq 0>
				AND	PRODUCT.PRODUCT_NAME LIKE #sql_unicode()#'#attributes.keyword#%' 
		  	</cfif>
		  	<cfif isdefined("sepet_process_type") and (sepet_process_type neq -1)>
		  		<cfif ListFind("52,53,54,55,59,62,70,71,73,74,76,78,80,81,110,111,112,113,1131,114,115,141",sepet_process_type)>
					AND PRODUCT.IS_INVENTORY = 1
		  		<cfelse>
					AND PRODUCT.IS_INVENTORY = 0
		  		</cfif>
		  	</cfif>	
			
		),
		CTE2 AS (
				SELECT
					CTE1.*,
					ROW_NUMBER() OVER (
										<cfif isdefined('attributes.sort_type') and attributes.sort_type eq 0>
											ORDER BY PRODUCT_NAME,PROPERTY
										<cfelseif isdefined('attributes.sort_type') and attributes.sort_type eq 1>
											ORDER BY STOCK_CODE
										<cfelse>
											ORDER BY STOCK_CODE_2,PRODUCT_NAME
										</cfif>
										) AS RowNum,(SELECT COUNT(*) FROM CTE1) AS QUERY_COUNT
				FROM
					CTE1
			)
			SELECT
				CTE2.*
			FROM
				CTE2
			WHERE
				RowNum BETWEEN #attributes.startrow# and #attributes.startrow#+(#attributes.maxrows#-1)
	</cfquery>
	<cfset product_id_list=''>
	<cfoutput query="products">
		<cfif not listfind(product_id_list,products.PRODUCT_ID)>
			<cfset product_id_list = listappend(product_id_list,products.PRODUCT_ID)>
		</cfif>
	</cfoutput>
	<cfif len(product_id_list)>

		<cfquery name="GET_PRODUCT_UNITS" datasource="#DSN3#">
			SELECT ADD_UNIT,MAIN_UNIT,MULTIPLIER,PRODUCT_UNIT_ID,PRODUCT_ID FROM PRODUCT_UNIT WHERE PRODUCT_ID IN (#product_id_list#) AND PRODUCT_UNIT_STATUS = 1
		</cfquery>
	</cfif>
<cfelse>
	<cfset products.recordcount = 0>
</cfif>
<cfif  products.recordcount >
	<cfparam name="attributes.totalrecords" default="#products.query_count#">
<cfelse>	
	<cfparam name="attributes.totalrecords" default="#products.recordcount#">
</cfif>
<cfset url_str = ''>
<cfif isdefined("attributes.is_sale_product")>
	<cfset url_str = "#url_str#&is_sale_product=#attributes.is_sale_product#">
</cfif>
<cfif isdefined("attributes.is_cost")>
  	<cfset url_str = "#url_str#&is_cost=#attributes.is_cost#">
</cfif>
<cfif isdefined("attributes.int_basket_id")>
  	<cfset url_str = "#url_str#&int_basket_id=#attributes.int_basket_id#">
</cfif>
<cfif isdefined("attributes.update_product_row_id")>
  	<cfset url_str = "#url_str#&update_product_row_id=#attributes.update_product_row_id#">
</cfif>
<cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>
  	<cfset url_str = "#url_str#&branch_id=#attributes.branch_id#">
</cfif>
<cfif isdefined("attributes.company_id")>
  	<cfset url_str = "#url_str#&company_id=#attributes.company_id#">
</cfif>
<cfif isdefined("attributes.project_id")>
  	<cfset url_str = "#url_str#&project_id=#attributes.project_id#">
</cfif>
<cfif isDefined('attributes.rowcount') and len(attributes.rowcount)>
  	<cfset url_str = "#url_str#&rowcount=#attributes.rowcount#">
</cfif>
<cfif isDefined('attributes.is_price') and len(attributes.is_price)>
  	<cfset url_str = "#url_str#&is_price=#attributes.is_price#">
</cfif>
<cfif isDefined('attributes.is_price_other') and len(attributes.is_price_other)>
 	<cfset url_str = "#url_str#&is_price_other=#attributes.is_price_other#">
</cfif>
<cfif isdefined("sepet_process_type")>
  	<cfset url_str = "#url_str#&sepet_process_type=#sepet_process_type#">
</cfif>
<cfif isdefined("attributes.search_process_date") and isdate(attributes.search_process_date)>
	<cfset url_str = "#url_str#&search_process_date=#attributes.search_process_date#">
</cfif>
<cfif isdefined('attributes.department_out') and len(attributes.department_out)>
 	<cfset url_str = "#url_str#&department_out=#attributes.department_out#">
</cfif>
<cfif isdefined('attributes.location_out') and len(attributes.location_out)>
 	<cfset url_str = "#url_str#&location_out=#attributes.location_out#">
</cfif>
<cfif isdefined('attributes.department_in') and len(attributes.department_in)>
 	<cfset url_str = "#url_str#&department_in=#attributes.department_in#">
</cfif>
<cfif isdefined('attributes.location_in') and len(attributes.location_in)>
 	<cfset url_str = "#url_str#&location_in=#attributes.location_in#">
</cfif>
<cfif isdefined('attributes.demand_type') and len(attributes.demand_type)>
 	<cfset url_str = "#url_str#&demand_type=#attributes.demand_type#">
</cfif>
<cfif isdefined("attributes.satir")>
	<cfset url_str = "#url_str#&satir=#attributes.satir#">
</cfif>
<cfloop query="moneys">
  <cfif isdefined("attributes.#money#")>
	<cfset url_str = "#url_str#&#money#=#evaluate("attributes.#money#")#">
  </cfif>
</cfloop>
<cfset url_str = '#url_str#&is_form_submitted=1'>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cfsavecontent variable="message"><cf_get_lang dictionary_id='57564.Ürünler'></cfsavecontent>
	<cf_box title="#message#">
		<cf_wrk_alphabet keyword="url_str" popup_box="#iif(isdefined("attributes.draggable"),1,0)#"><!--- Harfler --->
		<cfform name="price_cat" method="post" action="#request.self#?fuseaction=objects.popup_products#url_str#">
			<input type="hidden" name="is_form_submitted" id="is_form_submitted">
			<input type="hidden" name="list_property_id" id="list_property_id" value="<cfif isdefined("attributes.list_property_id")><cfoutput>#attributes.list_property_id#</cfoutput></cfif>">
			<input type="hidden" name="list_variation_id" id="list_variation_id" value="<cfif isdefined("attributes.list_variation_id")><cfoutput>#attributes.list_variation_id#</cfoutput></cfif>">
    		<cf_box_search more="0">
    			<div class="form-group" id="item-keyword">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57460.Filtre'></cfsavecontent>
					<cfinput type="text" name="keyword" value="#attributes.keyword#" placeholder="#message#">
				</div>
				<div class="form-group" id="item-sort_type">
					<select name="sort_type" id="sort_type">
						<option value="0" <cfif attributes.sort_type eq 0>selected</cfif>><cf_get_lang dictionary_id='34282.Ürün Adına Göre'></option>
						<option value="1" <cfif attributes.sort_type eq 1>selected</cfif>><cf_get_lang dictionary_id='32751.Stok Koduna Göre'></option>
						<option value="2" <cfif attributes.sort_type eq 2>selected</cfif>><cf_get_lang dictionary_id='32764.Özel Koda Göre'></option>
					</select>
				</div>	
				<div class="form-group" id="item-product_cat">
        			<div class="input-group">
						<input type="hidden" name="product_catid" id="product_catid" value="<cfoutput>#attributes.product_catid#</cfoutput>">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='57486.Kategori'></cfsavecontent>
						<input type="text" name="product_cat" id="product_cat" placeholder="<cfoutput>#message#</cfoutput>"  value="<cfoutput>#attributes.product_cat#</cfoutput>">
						<span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_product_cat_names&is_sub_category=1&field_id=price_cat.product_catid&field_name=price_cat.product_cat&keyword='+encodeURIComponent(document.price_cat.product_cat.value)</cfoutput>);"></span>
					</div>
				</div>
				<div class="form-group" id="item-brand_name">
        			<div class="input-group">
						<cfif len(attributes.brand_id) and len(attributes.brand_name)>
							<cfquery name="GET_BRAND_NAME" datasource="#DSN3#">
								SELECT 
									BRAND_NAME	
								FROM
									PRODUCT_BRANDS
								WHERE
									BRAND_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.brand_id#">
							</cfquery>
						</cfif>
						<input type="hidden" name="brand_id" id="brand_id" value="<cfoutput>#attributes.brand_id#</cfoutput>">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='58847.Marka'></cfsavecontent>
						<input type="text" name="brand_name" id="brand_name" placeholder="<cfoutput>#message#</cfoutput>" value="<cfoutput>#attributes.brand_name#</cfoutput>">
						<span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_product_brands&brand_id=price_cat.brand_id&brand_name=price_cat.brand_name</cfoutput>','small');"></span>
					</div>
				</div>
                <div class="form-group" id="item-employee">
        			<div class="input-group">
						<input type="hidden" name="pos_code" id="pos_code"  value="<cfoutput>#attributes.pos_code#</cfoutput>">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='57544.Sorumlu'></cfsavecontent>
						<input type="text" name="employee" id="employee" placeholder="<cfoutput>#message#</cfoutput>" value="<cfoutput>#attributes.employee#</cfoutput>" maxlength="255">
						<span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_code=price_cat.pos_code&field_name=price_cat.employee&select_list=1&is_form_submitted=1&keyword='+encodeURIComponent(document.price_cat.employee.value),'list');"></span>
                    </div>
				</div>	
				<div class="form-group" id="item-get_company">
        			<div class="input-group">
						<input type="hidden" name="get_company_id" id="get_company_id" value="<cfoutput>#attributes.get_company_id#</cfoutput>">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='29533.Tedarikçi'></cfsavecontent>
						<input type="text" name="get_company" id="get_company" placeholder="<cfoutput>#message#</cfoutput>" value="<cfoutput>#attributes.get_company#</cfoutput>">
						<span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_comp_name=price_cat.get_company&field_comp_id=price_cat.get_company_id&select_list=2,3&is_form_submitted=1&keyword='+encodeURIComponent(document.price_cat.get_company.value),'list');"></span>
					</div>
				</div>
				<div class="form-group" id="item-amount_multiplier">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57635.Miktar'></cfsavecontent>
					<input type="text" name="amount_multiplier" id="amount_multiplier" placeholder="<cfoutput>#message#</cfoutput>" value="<cfoutput>#TlFormat(attributes.amount_multiplier,3)#</cfoutput>" onkeyup="return FormatCurrency(this,event,3);" class="moneybox">
				</div>
				<div class="form-group small">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" onKeyUp="isnumber(this)" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3">
				</div>
				<div class="form-group">
				 	<cf_wrk_search_button search_function='input_control()' button_type="4">
				</div>
			</cf_box_search>
			
			<cf_box_search_detail>
				<div id="detail_search">
					<cfinclude template="detailed_product_search.cfm">
				</div>
			</cf_box_search_detail>
		</cfform>					
		<cf_grid_list>
			<thead>			
				<tr> 
					<cfif isdefined('xml_is_dsp_stock_code') and xml_is_dsp_stock_code eq 1>
						<th><cf_get_lang dictionary_id='57518.Stok Kodu'></th>
					</cfif>
					<th><cf_get_lang dictionary_id='57657.Ürün'></th>
					<cfif isdefined('xml_is_list_products') and xml_is_list_products eq 1>
						<th><cf_get_lang dictionary_id='34281.Ürün Açıklaması'></th>
					</cfif>
					<th><cf_get_lang dictionary_id='57636.Birimler'></th>
					<th width="20"><a href="javascript://"><i class="icon-detail"></i></a></th>
				</tr>
			</thead>
			<tbody>
				<cfif products.recordcount>
					<cfoutput query="products" > 
					<tr>
						<cfif isdefined('xml_is_dsp_stock_code') and xml_is_dsp_stock_code eq 1>
							<td>#stock_code#</td>
						</cfif>
						<td width="200" nowrap="nowrap">#product_name#&nbsp;#property#</td>
						<cfif isdefined('xml_is_list_products') and xml_is_list_products eq 1>
							<td>#product_detail#</td>
						</cfif>
						<td style="cursor:pointer">
							<cfset int_cur_row=currentrow>
							<cfquery name="GET_UNITS" dbtype="query">
								SELECT DISTINCT ADD_UNIT,PRODUCT_UNIT_ID,MULTIPLIER,MAIN_UNIT FROM get_product_units WHERE PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#PRODUCT_ID#">
							</cfquery>
							<cfloop query="get_units">
							<cfscript>
								pro_id=products.product_id[products.currentrow];
								stk_id=products.stock_id[products.currentrow];
								stk_code=products.stock_code[products.currentrow];
								brc_code=products.barcod[products.currentrow];
								man_code=products.manufact_code[products.currentrow];
								pro_name=products.product_name[products.currentrow];
								pro_name=ReplaceNoCase(pro_name,'"','','all');
								pro_name=ReplaceNoCase(pro_name,"'","","all");
								prop=products.property[products.currentrow];
								prop=ReplaceNoCase(prop,'"','','all');
								prop=ReplaceNoCase(prop,"'","","all");
								pro_code=products.product_code[products.currentrow];
								inventory=products.is_inventory[products.currentrow];
								multi=products.multiplier[products.currentrow];
								pro_is_sales=products.is_sales[products.currentrow];
								if (isdefined("sepet_process_type") and (sepet_process_type neq -1) and ListFind("53,71",sepet_process_type))
								tax=products.tax_purchase[products.currentrow];
								else
								tax=products.tax[products.currentrow];	
								otv_=products.otv[products.currentrow];				
								ser_no=products.is_serial_no[products.currentrow];
								is_production=products.is_production[products.currentrow];
							</cfscript>
							<cfif isdefined("attributes.is_price_other") and attributes.is_price_other eq 1>
								<cfset flag_prc_other=1>
								<cfset str_js_detail="sepete_ekle(0,'#pro_id#', '#stk_id#', '#stk_code#', '#brc_code#', '#man_code#', '#pro_name# #prop#', '#PRODUCT_UNIT_ID#', '#main_unit#','#pro_code#', '1', '#ser_no#', '1','#pro_is_sales#','#tax#', '#otv_#','#flag_prc_other#','#session_base.money#','','','#inventory#','#get_units.multiplier#','','','','#get_units.multiplier#','','','#is_production#','','#get_units.add_unit#','','','','','#flag_prc_other#','');"> 
							<cfelse>
								<cfset flag_prc_other=0>
								<cfset str_js_detail="sepete_ekle(0,'#pro_id#', '#stk_id#', '#stk_code#', '#brc_code#', '#man_code#', '#pro_name# #prop#', '#PRODUCT_UNIT_ID#', '#main_unit#','#pro_code#','1', '#ser_no#', '1','#pro_is_sales#','#tax#','#otv_#', '#flag_prc_other#','#session_base.money#','','','#inventory#','#get_units.multiplier#','','','','#get_units.multiplier#','','','#is_production#','','#get_units.add_unit#','','','','','#flag_prc_other#','');"> 
							</cfif>
						<a href="javascript:#str_js_detail#" class="tableyazi">#ADD_UNIT# &nbsp;</a></cfloop>
						</td>
						<td width="15"><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_detail_product&pid=#products.product_id#&sid=#stock_id#','list')"><i class="icon-detail" title="<cf_get_lang dictionary_id='57771.Detay'>"></i></a></td>
					</tr>
					</cfoutput> 
				<cfelse>
					<tr> 
						<td colspan="<cfif not isdefined("attributes.is_promotion")>7<cfelse>6</cfif>"><cfif isdefined("is_form_submitted")><cf_get_lang dictionary_id='57484.Kayit Yok'><cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'></cfif>!</td>
					</tr>
				</cfif>
			</tbody>
		<cf_grid_list>
		<cfif attributes.totalrecords gt attributes.maxrows>
			<cfset adres = "objects.popup_products&is_form_submitted=1">
			<cfif len(attributes.keyword)>
				<cfset adres = "#adres#&keyword=#attributes.keyword#">
			</cfif>
			<cfif len(attributes.sort_type)>
				<cfset adres = "#adres#&sort_type=#attributes.sort_type#">
			</cfif>
			<cfif len(attributes.employee) and len(attributes.pos_code)>
				<cfset adres = "#adres#&employee=#attributes.employee#">
			</cfif>
			<cfif len(attributes.employee) and len(attributes.pos_code)>
				<cfset adres = "#adres#&pos_code=#attributes.pos_code#">
			</cfif>
			<cfif len(attributes.product_cat) and len(attributes.product_catid)>
				<cfset adres = "#adres#&product_cat=#attributes.product_cat#">
			</cfif>
			<cfif len(attributes.product_cat) and len(attributes.product_catid)>
				<cfset adres = "#adres#&product_catid=#attributes.product_catid#">
			</cfif>
			<cfif len(attributes.get_company_id) and len(attributes.get_company)>
				<cfset adres = "#adres#&get_company_id=#attributes.get_company_id#">
			</cfif>
			<cfif len(attributes.get_company_id) and len(attributes.get_company)>
				<cfset adres = "#adres#&get_company=#attributes.get_company#">
			</cfif>
			<cfif len(attributes.brand_id) and len(attributes.brand_name)>
				<cfset adres = "#adres#&brand_id=#attributes.brand_id#">
			</cfif>
			<cfif len(attributes.brand_id) and len(attributes.brand_name)>
				<cfset adres = "#adres#&brand_name=#attributes.brand_name#">
			</cfif>
			<cfif isdefined("attributes.amount_multiplier")>
				<cfset adres = "#adres#&amount_multiplier=#attributes.amount_multiplier#">
			</cfif>
			<cfif isDefined('attributes.list_property_id') and len(attributes.list_property_id)>
				<cfset adres = '#adres#&list_property_id=#attributes.list_property_id#'>
			</cfif>	
			<cfif isDefined('attributes.list_variation_id') and len(attributes.list_variation_id)>
				<cfset adres = '#adres#&list_variation_id=#attributes.list_variation_id#'>
			</cfif>	
			<cf_paging page="#attributes.page#"
					maxrows="#attributes.maxrows#"
					totalrecords="#attributes.totalrecords#"
					startrow="#attributes.startrow#"
					adres="#adres##url_str#">
		</cfif>
	</cf_box>
</div>
<script type="text/javascript">
	function input_control()
	{
		row_count=<cfoutput>#get_property_var.recordcount#</cfoutput>;
		for(r=1;r<=row_count;r++)
		{  
			if(eval("document.price_cat.variation_id"+r) != undefined)
			{
				deger_variation_id = eval("document.price_cat.variation_id"+r);
				if(deger_variation_id != undefined && deger_variation_id.value != "")
				{
					if(eval("document.price_cat.property_id"+r) != undefined)
					{
						deger_property_id = eval("document.price_cat.property_id"+r);
						if(document.price_cat.list_property_id.value.length==0) ayirac=''; else ayirac=',';
						document.price_cat.list_property_id.value=document.price_cat.list_property_id.value+ayirac+deger_property_id.value;
						document.price_cat.list_variation_id.value=document.price_cat.list_variation_id.value+ayirac+deger_variation_id.value;
					}
				}
			}
		}
		return true;
	}
	document.price_cat.list_property_id.value="";
	document.price_cat.list_variation_id.value="";
	document.getElementById('keyword').focus();
</script>
