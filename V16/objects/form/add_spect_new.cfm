<cfif not isdefined("session_base.money")><cfset session_base.money = session.ep.money></cfif>
<cfset xml_str=''>
<cfif isdefined('attributes.add_main_spect')>
	<cfset is_show_detail = 0>
	<cfset is_show_cost = 0>
	<cfset is_show_diff_price = 0>
	<cfset is_show_price = 0>
	<cfset is_show_property_amount = 1>
	<cfset is_show_property_price = 0>
	<cfset is_show_tolerance_property = 1>
	<cfset is_show_line_number = 1>
    <cfset is_show_value = 0>
	<cfset xml_str = "&is_show_value=0&is_show_configure=0&is_show_line_number=0&is_show_property_and_calculate=#is_show_property_and_calculate#&is_show_detail=0&is_spect_name_to_property=#is_spect_name_to_property#&is_show_cost=0&is_show_diff_price=0&is_show_price=0&is_show_property_amount=1&is_show_property_price=0&is_show_tolerance_property=1&is_change_spect_name=#is_change_spect_name#">
</cfif>
<cfquery name="GET_MONEY" datasource="#DSN#">
    SELECT	
        PERIOD_ID,
        MONEY,
        RATE1,
        RATE2 
    FROM
        SETUP_MONEY 
    WHERE 
        PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.period_id#"> AND 
        MONEY_STATUS = 1
</cfquery>
<cfquery name="GET_MONEY_2" dbtype="query">
	SELECT * FROM GET_MONEY WHERE MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session_base.money2#">
</cfquery>
<cfif spec_purchasesales eq 1>
	<!--- uyenin fiyat listesini bulmak icin--->
	<cfif isdefined("attributes.company_id") and len(attributes.company_id)>
		<cfquery name="GET_PRICE_CAT_CREDIT" datasource="#DSN#">
			SELECT
				PRICE_CAT
			FROM
				COMPANY_CREDIT
			WHERE
				COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">  AND
				OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.company_id#">
		</cfquery>
		<cfif get_price_cat_credit.recordcount and len(get_price_cat_credit.price_cat)>
			<cfset attributes.price_catid=get_price_cat_credit.price_cat>
		<cfelse>
			<cfquery name="GET_COMP_CAT" datasource="#DSN#">
				SELECT COMPANYCAT_ID FROM COMPANY WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
			</cfquery>
			<cfquery name="GET_PRICE_CAT_COMP" datasource="#DSN3#">
				SELECT 
					PRICE_CATID
				FROM
					PRICE_CAT
				WHERE
					COMPANY_CAT LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#get_comp_cat.companycat_id#,%">
			</cfquery>
			<cfset attributes.price_catid = get_price_cat_comp.price_catid>
		</cfif>
	</cfif>
	<cfif isdefined("attributes.consumer_id") and len(attributes.consumer_id)>
		<cfquery name="GET_COMP_CAT" datasource="#DSN#">
			SELECT CONSUMER_CAT_ID FROM CONSUMER WHERE CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
		</cfquery>
		<cfquery name="GET_PRICE_CAT" datasource="#DSN3#">
			SELECT PRICE_CATID FROM PRICE_CAT WHERE CONSUMER_CAT LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#get_comp_cat.consumer_cat_id#,%">
		</cfquery>
		<cfset attributes.price_catid=get_price_cat.price_catid>
	</cfif>
</cfif>
<cfif isdefined("attributes.stock_id") and len(attributes.stock_id)>
	<cfquery name="GET_PRODUCT" datasource="#DSN3#">
		SELECT 
			IS_PROTOTYPE,
			PRODUCT_NAME,
			PRODUCT_ID,
			STOCK_ID,
			PROPERTY,
			STOCK_CODE
		FROM 
			STOCKS
		WHERE 
			STOCKS.STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.stock_id#">
	</cfquery>
	<cfset attributes.product_id=get_product.product_id>
	<cfset product_id_list=get_product.product_id>
	<cfset tree_product_id_list="">
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
	<cfif spec_purchasesales eq 1>
		<cfif isdefined("attributes.price_catid") and len(attributes.price_catid)>
			<cfquery name="GET_PRICE" datasource="#DSN3#">
				SELECT
					PRICE_STANDART.PRODUCT_ID,
					SM.MONEY,
					PRICE_STANDART.PRICE,
					(PRICE_STANDART.PRICE*(SM.RATE2/SM.RATE1)) AS PRICE_STDMONEY,
					(PRICE_STANDART.PRICE_KDV*(SM.RATE2/SM.RATE1)) AS PRICE_KDV_STDMONEY,
					SM.RATE2,
					SM.RATE1
				FROM
					PRICE PRICE_STANDART,	
					PRODUCT_UNIT,
					#dsn_alias#.SETUP_MONEY AS SM
				WHERE
					PRICE_STANDART.PRICE_CATID=#attributes.price_catid# AND
					ISNULL(PRICE_STANDART.STOCK_ID,0)=0 AND
					ISNULL(PRICE_STANDART.SPECT_VAR_ID,0)=0 AND
					PRICE_STANDART.STARTDATE< #now()# AND 
					(PRICE_STANDART.FINISHDATE >= #now()# OR PRICE_STANDART.FINISHDATE IS NULL) AND
					PRODUCT_UNIT.PRODUCT_ID = PRICE_STANDART.PRODUCT_ID AND 
					PRICE_STANDART.PRODUCT_ID IN (#product_id_list#) AND 
					PRODUCT_UNIT.IS_MAIN = 1 AND
                    <cfif session_base.period_year lt 2009>
						((SM.MONEY = PRICE_STANDART.MONEY) OR (SM.MONEY = 'YTL') AND PRICE_STANDART.MONEY = 'TL') AND
					<cfelse>
                        SM.MONEY = PRICE_STANDART.MONEY AND
					</cfif>
					SM.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.period_id#">
			</cfquery>
		</cfif>
	</cfif>
	<cfquery name="GET_PRICE_STANDART" datasource="#DSN3#">
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
</cfif>
<cfset url_str = "">
<cfif isdefined("attributes.stock_id")>
	<cfset url_str = "#url_str#&stock_id=#attributes.stock_id#">
</cfif>
<cfif isdefined("attributes.row_id")>
	<cfset url_str = "#url_str#&row_id=#attributes.row_id#">
</cfif>
<cfif isdefined("attributes.field_id")>
	<cfset url_str = "#url_str#&field_id=#attributes.field_id#">
</cfif>
<cfif isdefined("attributes.field_main_id")>
	<cfset url_str = "#url_str#&field_main_id=#attributes.field_main_id#">
</cfif>
<cfif isdefined("attributes.field_name")>
	<cfset url_str = "#url_str#&field_name=#attributes.field_name#">
</cfif>
<cfif isdefined("attributes.main_stock_amount")>
	<cfset url_str = "#url_str#&main_stock_amount=#attributes.main_stock_amount#">
</cfif>
<cfif isdefined("attributes.basket_id")>
	<cfset url_str = "#url_str#&basket_id=#attributes.basket_id#">
<cfelse>
	<cfset attributes.basket_id=2>
	<cfset url_str = "#url_str#&basket_id=2">
</cfif>
<cfif isdefined("attributes.is_refresh")>
	<cfset url_str = "#url_str#&is_refresh=#attributes.is_refresh#">
</cfif>
<cfif isdefined("attributes.form_name")>
	<cfset url_str = "#url_str#&form_name=#attributes.form_name#">
</cfif>
<cfif isdefined("attributes.company_id")>
	<cfset url_str = "#url_str#&company_id=#attributes.company_id#">
</cfif>
<cfif isdefined("attributes.consumer_id")>
	<cfset url_str = "#url_str#&consumer_id=#attributes.consumer_id#">
</cfif>
<cfloop query="get_money">
	<cfif isdefined("attributes.#money#") >
		<cfset url_str = "#url_str#&#money#=#evaluate("attributes.#money#")#">
	</cfif>
</cfloop>
<cfif isdefined("attributes.search_process_date")>
	<cfset url_str = "#url_str#&search_process_date=#attributes.search_process_date#">
</cfif>
<cfif isdefined("is_spect_name_to_property")>
	<cfset url_str = "#url_str#&is_spect_name_to_property=#is_spect_name_to_property#">
</cfif>
<cfsavecontent variable="right_images_">
<cfoutput>
	<cfif isdefined("attributes.stock_id") and len(attributes.stock_id)><a href="#request.self#?fuseaction=objects.popup_list_spect_main&main_to_add_spect=1&#url_str#"><img src="/images/cuberelation.gif" align="absmiddle" border="0" title="<cf_get_lang dictionary_id ='33920.Konfigüratör'>"></a></cfif>
</cfoutput> 
</cfsavecontent>
<cfform  name="add_spect_variations" action="#request.self#?fuseaction=objects.emptypopup_upd_spect_query_new#url_str#" method="post" enctype="multipart/form-data">
	<cfsavecontent variable="message"><cf_get_lang dictionary_id='33919.Konfigürasyon/Spekt'></cfsavecontent>
	<cf_popup_box title="#message#" right_images="#right_images_#">  
    	<cf_area>
        	<cfinclude template="add_spect_new_conf.cfm">
    	</cf_area>
    	<cf_area>
            <input type="hidden" name="basket_id" id="basket_id" value="">
            <input type="hidden" name="new_price" id="new_price" value="">
            <cfif isdefined('attributes.add_main_spect')><input type="hidden" name="add_main_spect" id="add_main_spect" value="1"></cfif>
            <input type="hidden" name="order_id" id="order_id" value="">
            <input type="hidden" name="ship_id" id="ship_id" value="">
            <input type="hidden" name="is_change" id="is_change" value="0">
            <input type="hidden" name="is_add_same_name_spect" id="is_add_same_name_spect" value="<cfif isdefined("is_add_same_name_spect")><cfoutput>#is_add_same_name_spect#</cfoutput><cfelse>0</cfif>">
            <input type="hidden" name="reference_amount" id="reference_amount" value="0">
            <cfif isdefined("attributes.field_id") and isdefined("attributes.field_name")>
                <input type="hidden" name="field_name" id="field_name" value="<cfoutput>#attributes.field_name#</cfoutput>">
                <input type="hidden" name="field_id" id="field_id" value="<cfoutput>#attributes.field_id#</cfoutput>">
            </cfif>
            <cfif isdefined("attributes.row_id")>
                <input type="hidden" name="row_id" id="row_id" value="<cfoutput>#attributes.row_id#</cfoutput>">
            </cfif>
            <table>
                <tr>
                    <cfif isdefined("attributes.product_id")>
                        <cfif spec_purchasesales eq 1 and isdefined("attributes.price_catid") and len(attributes.price_catid)>
                            <cfquery name="GET_PRICE_MAIN_PROD" dbtype="query">
                                SELECT
                                    *
                                FROM
                                    GET_PRICE
                                WHERE
                                    PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_id#">
                              </cfquery>
                        </cfif>
                      	<cfif not isdefined("get_price_main_prod") or get_price_main_prod.recordcount eq 0>
                            <cfquery name="GET_PRICE_MAIN_PROD" dbtype="query">
                                SELECT
                                    *
                                FROM
                                    GET_PRICE_STANDART
                                WHERE
                                    PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_id#">
                            </cfquery>
                        </cfif>
                        <cfset spec_name=get_product.product_name>
                        <cfif len(get_product.property)><cfset spec_name="#spec_name# #get_product.property#"></cfif>
                        <input type="hidden" name="value_product_id" id="value_product_id" value="<cfoutput>#get_product.product_id#</cfoutput>">
                        <input type="hidden" name="value_stock_id" id="value_stock_id" value="<cfoutput>#get_product.stock_id#</cfoutput>">
                        <input type="hidden" name="main_prod_price" id="main_prod_price" value="<cfoutput>#get_price_main_prod.price#</cfoutput>">
                        <input type="hidden" name="main_prod_price_currency" id="main_prod_price_currency" value="<cfoutput>#get_price_main_prod.money#</cfoutput>">
                        <input type="hidden" name="main_std_money" id="main_std_money" value="<cfoutput>#get_price_main_prod.price_stdmoney#</cfoutput>">
                        <input type="hidden" name="main_kdvstd_money" id="main_kdvstd_money" value="<cfoutput>#get_price_main_prod.price_kdv_stdmoney#</cfoutput>">
                        <cfquery name="GET_MAIN_PRICE" dbtype="query">
                            SELECT RATE2, RATE1 FROM GET_MONEY WHERE MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#get_price_main_prod.money#"> AND PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.period_id#">
                        </cfquery>
                    <cfelse>
                        <input type="hidden" name="value_product_id" id="value_product_id" value="">
                        <input type="hidden" name="value_stock_id" id="value_stock_id" value="">
                        <input type="hidden" name="main_prod_price" id="main_prod_price" value="0">
                        <input type="hidden" name="main_prod_price_currency" id="main_prod_price_currency" value="<cfoutput>#session_base.money#</cfoutput>">
                        <input type="hidden" name="main_std_money" id="main_std_money" value="0">
                        <input type="hidden" name="main_kdvstd_money" id="main_kdvstd_money" value="">
                    </cfif>
                    <td style="width:100px;"><cf_get_lang dictionary_id ='33921.Spec Ad'>/<cf_get_lang dictionary_id ='58585.Kod'></td>
                    <td style="width:170px;">
                    <cfif isdefined("attributes.product_id")>
                        <cfinput type="text" name="spect_name" id="spect_name"  style="width:250;" value="#spec_name#" maxlength="500">
                    <cfelse>
                        <cfinput type="text" name="spect_name" id="spect_name"  style="width:250;" value="" maxlength="500">
                    </cfif>
                    </td>
                    <td style="width:100px;"><input type="checkbox" name="is_price_change" id="is_price_change" value="1" checked><cf_get_lang dictionary_id ='33922.Fiyatı Güncelle'></td>
                    <td style="width:100px;"><input type="checkbox" name="is_limited_stock" id="is_limited_stock" value="1"><cf_get_lang dictionary_id='40169.Stoklarla Sınırlı'></td>
                </tr>
                <tr>
                    <cfif isdefined('is_show_detail') and is_show_detail eq 1>
                        <td style="width:100px; vertical-align:top;"><cf_get_lang dictionary_id ='57771.Detay'> /<cf_get_lang dictionary_id ='33923.Talimat'> </td>
                        <td rowspan="3" style="width:170px;"><textarea name="spect_detail" id="spect_detail" style="width:250px; height:65px;"></textarea></td>
                    </cfif>
                    <cfif not isdefined('attributes.add_main_spect')>
                        <td style="width:100px; vertical-align:top;"><cf_get_lang dictionary_id ='57515.Dosya Ekle'></td>
                        <td style="width:100px; vertical-align:top;"><input type="file" name="spect_file_name" id="spect_file_name" style="width:200;"></td>
                    </cfif>
                </tr>
                <tr>
                    <td></td>
                    <td>
						<cfif is_show_special_code_1 eq 1>
                            <cf_get_lang dictionary_id='57789.Özel Kod'> 1 <input type="text" name="special_code_1" id="special_code_1" onBlur="if(!special_code_control('1',this.value))this.value='';">
                        <cfelse>
                            <input type="hidden" name="special_code_1" id="special_code_1" value="">
                        </cfif>
                    </td>
                    <td>
						<cfif is_show_special_code_2 eq 1>
                            <cf_get_lang dictionary_id='57789.Özel Kod'> 2 <input type="text" name="special_code_2" id="special_code_2" onBlur="if(!special_code_control('2',this.value))this.value='';">
                        <cfelse>
                            <input type="hidden" name="special_code_2" id="special_code_2" value="">
                        </cfif>	
                    </td>
                </tr>
                <script type="text/javascript">
                    function special_code_control(type,value){
                        if(type==1)
                            special_code_query_text ="obj_sp_query_result_3";
                        else
                            special_code_query_text ="obj_sp_query_result_4";
                        var sp_query_result = wrk_safe_query(special_code_query_text,'dsn3',0,value);
                        if(sp_query_result.recordcount) {alert(''+sp_query_result.SPECT_MAIN_ID+' nolu Spec Main ve '+sp_query_result.SPECT_VAR_ID+' Spec Var ID de bu özel kodlar kullanılmış.'); return false}
                        else return true;
                    }
                </script>
                <tr>
                    <td></td>
                    <td>
						<cfif is_show_special_code_3 eq 1>
							<cf_get_lang dictionary_id='57789.Özel Kod'> 3 <input type="text" name="special_code_3" id="special_code_3" value="">
						<cfelse>
							<input type="hidden" name="special_code_3" id="special_code_3" value="">
						</cfif>
                    </td>
                    <td>
						<cfif is_show_special_code_4 eq 1>
							<cf_get_lang dictionary_id='57789.Özel Kod'> 4 <input type="text" name="special_code_4" id="special_code_4" value="">
						<cfelse>
							<input type="hidden" name="special_code_4" id="special_code_4" value="">
						</cfif>	
                    </td>
                </tr>
			</table>
			<cfsavecontent variable="message"><cf_get_lang dictionary_id='33924.Konfigüratör Bileşenleri'></cfsavecontent>
            <cf_seperator id="konfigurator_bilesenleri" header="#message#">
			<table id="konfigurator_bilesenleri">
           	  	<tr>
              		<td>
                    	<table name="table_tree" id="table_tree" class="medium_list">
                    		<thead>
                    			<tr>
									<cfoutput>
                                    <th style="width:35px;"></th>
                                    <th style="width:120px;">#get_product.stock_code#</th>
                                    <th style="width:360px;">#get_product.product_name# #get_product.property#</th>
                                    </cfoutput>
                                    <th style="text-align:right;" style="width:80px;"><cfoutput>#get_price_main_prod.price#</th>
                                    <th style="width:60px;">#get_price_main_prod.money#</th></cfoutput>
                                    <th colspan="7">&nbsp;</th>
                                </tr>
								<cfset satir=0>
                                <tr class="color-list" style="height:20px;">
                                    <th style="width:15px;"><input type="button" class="eklebuton" title="" onClick="open_tree_add_row();"></th>
                                    <cfif isdefined('is_show_line_number') and is_show_line_number eq 1><th style="width:15px;"><cf_get_lang dictionary_id='57487.No'></th></cfif>
                                    <th style="width:120px;"><cf_get_lang dictionary_id ='57518.Stok Kodu'></th>
                                    <th style="width:200px;"><cf_get_lang dictionary_id ='57657.Ürün'>/<cf_get_lang dictionary_id ='57629.Açıklama'></th>
                                    <cfif is_change_spect_name eq 1>
                           				<th style="width:60px;"><cf_get_lang dictionary_id='54851.Spec Adı'></th>
                                    </cfif>
                                    <th style="width:60px;"><cf_get_lang dictionary_id='54850.Spec ID'></th>
                                    <th style="width:15px;"><cf_get_lang dictionary_id ='33926.SB'></th>
                                    <th style="width:15px;"><img src="/images/shema_list.gif" align="absmiddle" border="0" title="<cf_get_lang dictionary_id ='33927.Alt Ağaç'>"></th>
                                    <th style="width:45px;"><cf_get_lang dictionary_id ='57635.Miktar'>*</th>
                                    <th <cfif isdefined('is_show_diff_price') and is_show_diff_price eq 0> style="width:80px;display:none;"<cfelse>style="width:80px;"</cfif>class="txtboldblue"><cf_get_lang dictionary_id ='33928.Fiyat Farkı'>*</th>
                                    <th <cfif isdefined('is_show_price') and is_show_price eq 0> style="width:60px;display:none;"<cfelse>style="width:60px;"</cfif>><cf_get_lang dictionary_id ='57489.Para Br'></th>
                                    <th <cfif isdefined('is_show_cost') and is_show_cost eq 0> style="width:60px;display:none;"<cfelse>style="width:60px;"</cfif>><cf_get_lang dictionary_id='58258.Maliyet'></th>
                                    <th <cfif isdefined('is_show_price') and is_show_price eq 0> style="width:100px;display:none;"<cfelse> style="width:100px;"</cfif> class="txtboldblue"><cf_get_lang dictionary_id='58084.Fiyat'></th>
                                </tr>
                     		</thead>
                     		<tbody>
							<cfoutput query="get_prod_tree">
                                <cfset satir=satir+1>
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
                            	<tr id="tree_row#satir#"<cfif isdefined('is_show_configure') and is_show_configure eq 1 and is_configure neq 1> style="display:none;"</cfif>>
                                    <td width="15">
                                    	<input type="hidden" name="tree_row_kontrol#satir#" id="tree_row_kontrol#satir#" value="1"><cfif is_configure><a href="javascript://" onClick="sil_tree_row(#satir#)"><img src="/images/delete_list.gif" title"<cf_get_lang dictionary_id ='50765.Ürün Sil'>" border="0"></a>
                                   		<input type="hidden" name="tree_is_configure#satir#" id="tree_is_configure#satir#" value="1"></cfif></td>
                                    	<cfif isdefined('is_show_line_number') and is_show_line_number eq 1><td align="center">
                                            <input type="text" name="line_number#satir#" id="line_number#satir#" style="width:15px;text-align:right" class="box" readonly value="#LINE_NUMBER#"></td></cfif>
                                    <td width="120"><input type="text" name="tree_stock_code#satir#" id="tree_stock_code#satir#" value="#STOCK_CODE#" style="width:120px" readonly></td>
                                    <td nowrap="nowrap">
                                        <select name="tree_product_id#satir#" id="tree_product_id#satir#" <cfif isdefined('get_alternative') and get_alternative.recordcount and IS_CONFIGURE>style="background:FFCCCC;"</cfif> style="width:280px;" onChange="UrunDegis(this,'#satir#');document.getElementById('tree_total_amount_money#satir#').value=list_getat(this.value,4);">
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
                                        <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_detail_product&pid='+list_getat(document.add_spect_variations.tree_product_id#satir#.value,1)+'&sid='+list_getat(document.add_spect_variations.tree_product_id#satir#.value,2),'medium')"><img src="/images/plus_thin.gif" title="<cf_get_lang dictionary_id ='46799.Ürün Detay'>" border="0" align="absmiddle"></a>
                                    </td>
                            <cfif is_change_spect_name eq 1>
                                <td>
                                    <input type="text" id="related_spect_main_name#satir#" name="related_spect_main_name#satir#" value="#SPECT_MAIN_NAME#">	
                                </td>
                            </cfif>
                            <td><input title="Spec Bileşenleri" id="related_spect_main_id#satir#" <cfif is_production eq 1>style="width:43px;cursor:pointer;" onClick="document.getElementById('tree_std_money#satir#').value=document.getElementById('old_tree_std_money#satir#').value;goster(SHOW_PRODUCT_TREE_ROW#satir#);AjaxPageLoad('#request.self#?fuseaction=objects.popup_ajax_spect_detail_ajax#xml_str#&stock_id='+list_getat(document.all.tree_product_id#satir#.value,2,',')+'&product_id='+list_getat(document.all.tree_product_id#satir#.value,1,',')+'&satir=#satir#&spec_purchasesales=#spec_purchasesales#&RATE1=#get_money_2.RATE1#&RATE2=#get_money_2.RATE2#&is_spect_or_tree='+document.getElementById('related_spect_main_id#satir#').value+'','SHOW_PRODUCT_TREE_INFO#satir#',1)"</cfif> name="related_spect_main_id#satir#" style="width:43px;" class="box" value="<cfif is_production eq 1>#SPECT_MAIN_ID#</cfif>" readonly></td><!--- Spec --->
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
                                            document.getElementById('related_spect_main_name#satir#').value= SPECT_MAIN_NAME;
                                        </cfif>
                                        document.getElementById('related_spect_main_id#satir#').value= SPECT_MAIN_ID;
                                        document.getElementById('related_spect_main_id#satir#').style.background ='CCCCCC';
                                    </script>
                                </cfif>
                            <td><input type="checkbox" name="tree_is_sevk#satir#" id="tree_is_sevk#satir#" value="1" <cfif is_sevk>checked</cfif>></td>
                            <td><img src="/images/shema_list.gif"  title="<cf_get_lang dictionary_id ='33930.Ağaç Bileşenleri'>" id="under_tree#satir#"  style="cursor:pointer;"<cfif is_production neq 1>style="display:none"</cfif>  align="absmiddle" border="0" onClick="document.getElementById('tree_std_money#satir#').value=document.getElementById('old_tree_std_money#satir#').value;goster(SHOW_PRODUCT_TREE_ROW#satir#);AjaxPageLoad('#request.self#?fuseaction=objects.popup_ajax_spect_detail_ajax#xml_str#&stock_id='+list_getat(document.all.tree_product_id#satir#.value,2,',')+'&product_id='+list_getat(document.all.tree_product_id#satir#.value,1,',')+'&satir=#satir#&spec_purchasesales=#spec_purchasesales#&RATE1=#get_money_2.RATE1#&RATE2=#get_money_2.RATE2#','SHOW_PRODUCT_TREE_INFO#satir#',1);"></td>
                            <td><input name="tree_amount#satir#" id="tree_amount#satir#" type="text" class="moneybox" style="width:50px" onFocus="document.getElementById('reference_amount').value=filterNum(this.value,4)"  onKeyUp="FormatCurrency(this,event,2);UrunDegis(document.getElementById('tree_product_id#satir#'),'#satir#',1);" value="#TLFormat(AMOUNT,4)#" <cfif IS_CONFIGURE eq 0>readonly</cfif> autocomplete="off"></td>
                            <td <cfif isdefined('is_show_diff_price') and is_show_diff_price eq 0> style="display:none;"</cfif>>
                                <input type="hidden" name="tree_total_amount#satir#" id="tree_total_amount#satir#" value="#TLFormat(0,4)#" onkeyup="return(FormatCurrency(this,event,2));" class="moneybox" onBlur="hesapla('');" style="width:80px"  <cfif IS_CONFIGURE eq 0>readonly</cfif>>
                                <input type="text" name="tree_diff_price#satir#" id="tree_diff_price#satir#" value="#TLFormat(0,4)#" onkeyup="return(FormatCurrency(this,event,2));" class="moneybox" onBlur="hesapla('');" style="width:80px"  <cfif IS_CONFIGURE eq 0>readonly</cfif>>
                                <input type="hidden" name="tree_kdvstd_money#satir#" id="tree_kdvstd_money#satir#" value="#get_price_main.price_kdv_stdmoney#">
                            </td>
                            <td <cfif isdefined('is_show_price') and is_show_price eq 0> style="display:none"</cfif>><input name="tree_total_amount_money#satir#" id="tree_total_amount_money#satir#" class="box" readonly  type="text" value="#get_price_main.money#" style="width:50px"></td><!--- Para Br --->
                            <cfif not isdefined('is_show_cost') or (isdefined('is_show_cost') and is_show_cost eq 1)>
                                <cfquery name="get_product_cost" dbtype="query">
                                    SELECT * FROM get_product_cost_all WHERE PRODUCT_ID = #PRODUCT_ID#
                                </cfquery>
                                <cfif len(get_product_cost.PURCHASE_NET_SYSTEM)><cfset PURCHASE_NET_SYSTEM = get_product_cost.PURCHASE_NET_SYSTEM><cfelse><cfset PURCHASE_NET_SYSTEM = 0></cfif>
                                <cfif len(get_product_cost.PURCHASE_EXTRA_COST_SYSTEM)><cfset PURCHASE_EXTRA_COST_SYSTEM = get_product_cost.PURCHASE_EXTRA_COST_SYSTEM><cfelse><cfset PURCHASE_EXTRA_COST_SYSTEM = 0></cfif>
                                <td><input type="text" name="tree_product_cost#satir#" id="tree_product_cost#satir#" value="#TLFormat(PURCHASE_NET_SYSTEM+PURCHASE_EXTRA_COST_SYSTEM,4)#" readonly class="moneybox" style="width:50px"></td>
                            </cfif>
                            <td <cfif isdefined('is_show_price') and is_show_price eq 0> style="display:none"</cfif>>
                                <input type="hidden" name="reference_std_money#satir#" id="reference_std_money#satir#" value="#TLFormat(get_price_main.price_stdmoney,4)#" class="moneybox" style="width:50px">
                                <input type="hidden" name="old_tree_std_money#satir#" id="old_tree_std_money#satir#" value="#TLFormat(get_price_main.price_stdmoney,4)#" class="moneybox" style="width:50px">
                                <input type="text" name="tree_std_money#satir#" id="tree_std_money#satir#" value="#TLFormat(get_price_main.price_stdmoney,4)#" class="moneybox" style="width:50px">
                            </td>
                            </tr>
                            <tr id="SHOW_PRODUCT_TREE_ROW#satir#" style="display:none;">
                                <td colspan="11"><div id="SHOW_PRODUCT_TREE_INFO#satir#"></div></td>
                            </tr>
                        </cfoutput>
                        <input type="hidden" name="tree_record_num" id="tree_record_num" value="<cfoutput>#satir#</cfoutput>">
                      </tbody>
                    </table>
                </td>
           	 </tr>
            </table>
            <table>
				<cfif isdefined('is_show_property_and_calculate') and is_show_property_and_calculate eq 1>
                    <tr class="color-header">
                        <td class="form-title" height="22"><cf_get_lang dictionary_id='58910.Özellikler'>/<cf_get_lang dictionary_id ='57777.İşlemler'></td>
                    </tr>
                    <tr class="color-row">
                        <td>
                            <table id="property_table">
                                <input type="hidden" name="pro_record_num" id="pro_record_num" value="0">
                            </table>
                        </td>
                    </tr>
                </cfif>
                <tr class="color-list"<cfif isdefined('attributes.add_main_spect')>style="display:none"</cfif>>
                    <td>
                        <table cellpadding="2" cellspacing="1">
                            <tr>
                                <td>
                                    <table width="100%" height="10" border="0" cellpadding="2" cellspacing="1">
                                        <tr class="color-header">
                                            <td colspan="3" class="form-title" >&nbsp;&nbsp;<cf_get_lang dictionary_id ='33851.Dövizler'></td>
                                        </tr>
                                        <cfoutput>
                                            <input type="hidden" name="rd_money_num" id="rd_money_num" value="#get_money.recordcount#">
                                            <cfloop query="get_money">
												<tr>
													<input type="hidden" name="urun_para_birimi#money#" id="urun_para_birimi#money#" value="#rate2/rate1#">
													<input type="hidden" name="rd_money_name_#currentrow#" id="rd_money_name_#currentrow#" value="#money#">
													<input type="hidden" name="txt_rate1_#currentrow#" id="txt_rate1_#currentrow#" value="#rate1#">
													<td><input type="radio" name="rd_money" id="rd_money" value="#money#,#rate1#,#rate2#" onClick="hesapla();" <cfif money eq session_base.money2>checked</cfif>>#money#</td>
													<td>#TLFormat(rate1,4)#/</td>
													<td><input type="text" name="txt_rate2_#currentrow#" id="txt_rate2_#currentrow#" value="#TLFormat(rate2,4)#" style="width:50px;" class="box" onkeyup="return(FormatCurrency(this,event,4));" onBlur="hesapla();"></td>
												</tr>
                                            </cfloop>
                                        </cfoutput>
                                    </table>
                                </td>
                                <td valign="top">
                                    <table border="0" style="text-align:right;" cellpadding="2" cellspacing="1">
                                        <tr class="form-title">
                                            <td  class="color-header" style="text-align:right;"><cf_get_lang dictionary_id ='57492.Toplam'></td>
                                            <td  class="color-header" style="text-align:right;"><cf_get_lang dictionary_id ='58124.Döviz Toplam'></td>
                                        </tr>
                                        <cfoutput>
											<tr class="color-list">
												<td  valign="top" nowrap style="text-align:right;"><input type="text" name="toplam_miktar" id="toplam_miktar" value="0" style="width:100px;" class="box" readonly=""><cfoutput>#session_base.money#</cfoutput></td>
												<td  valign="top" style="text-align:right;"><input type="text" name="other_toplam" id="other_toplam" value="" style="width:100px;" class="box" readonly="">&nbsp;
												<input type="text" name="doviz_name" id="doviz_name" value="" style="width:50px;" class="box" readonly=""></td>
											</tr>
                                        </cfoutput>
                                    </table>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
        	</table>
	</cf_area>
    <cf_popup_box_footer><cfif isdefined('GET_PRODUCT.IS_PROTOTYPE') and GET_PRODUCT.IS_PROTOTYPE><cf_workcube_buttons is_upd='0' add_function='kontrol()'></cfif></cf_popup_box_footer>
 </cf_popup_box>
</cfform>
<script type="text/javascript">
	var tree_row_count=<cfoutput>#satir#</cfoutput>;
	<cfif isdefined("GET_MAIN_PRICE")>
		var product_rate=<cfoutput>#GET_MAIN_PRICE.RATE2/GET_MAIN_PRICE.RATE1#</cfoutput>;
		var product_rate2=<cfoutput>#GET_MAIN_PRICE.RATE1/GET_MAIN_PRICE.RATE2#</cfoutput>;
	<cfelse>
		var product_rate=1;
		var product_rate2=1;
	</cfif>
	function hesapla()
	{
		var is_change=0; //spect üzerinde değişiklik yapılıp yapılmadığını tutmak için
		toplam_deger = 0;
		 for (var r=1;r<=add_spect_variations.tree_record_num.value;r++)
		{
			if(document.getElementById('tree_row_kontrol'+r)!=undefined && document.getElementById('tree_row_kontrol'+r).value!='0')
			{
				form_amount = document.getElementById('tree_amount'+r);
				form_total_amount = document.getElementById('tree_total_amount'+r);
				form_total_amount.value = filterNum(form_total_amount.value,4);
				if(form_amount.value == "")
					value_form_amount = 0;
				else
					value_form_amount = filterNum(form_amount.value,4);
				if(form_total_amount.value == "")
					form_total_amount.value = 0;
				toplam_deger = toplam_deger + (value_form_amount*form_total_amount.value);
				form_total_amount.value=commaSplit(form_total_amount.value,4);
				if(( document.getElementById('tree_product_id'+r).selectedIndex>0 ||  document.getElementById('tree_product_id'+r).selectedIndex==undefined) && is_change!=1)is_change=1;	
			}else{is_change=1;}//satir silinmiş
		} 
		toplam_deger=parseFloat(toplam_deger*product_rate);
		<cfif isdefined("is_show_property_and_calculate") and is_show_property_and_calculate eq 1>//eğer özellikler görünsün seçili ise
		for (var r=1;r<=add_spect_variations.pro_record_num.value;r++)//özellikler işlemler
			{
				is_change=1;
				form_sum_amount = document.getElementById('pro_sum_amount'+r);
				form_amount = document.getElementById('pro_amount'+r);
				form_total_amount = document.getElementById('pro_total_amount'+r);
				form_money_type = document.getElementById('pro_money_type'+r);
				form_total_amount.value = filterNum(form_total_amount.value,4);
				form_sum_amount.value=commaSplit(filterNum(form_amount.value,4)*filterNum(form_total_amount.value),4);
				if(form_amount.value == "")
					value_form_amount = 0;
				else
					value_form_amount = filterNum(form_amount.value,4);
				if(form_total_amount.value == "")
					form_total_amount.value = 0;
				value_money_type = form_money_type.value.split(',');
				value_money_type_ilk = value_money_type[0];
				value_money_type_son = value_money_type[1];
				toplam_deger = toplam_deger + (value_form_amount*(form_total_amount.value*(value_money_type_son/value_money_type_ilk)));
				form_total_amount.value = commaSplit(form_total_amount.value,4);
			}
		</cfif>
		add_spect_variations.toplam_miktar.value = toplam=parseFloat(add_spect_variations.main_std_money.value)+parseFloat(toplam_deger);
		var value_deger_rd_money_orta =[];
		var value_deger_rd_money_son =[];
		var value_deger_rd_money_ilk =[];
		for(var j=0;j<add_spect_variations.rd_money.length;j++)
		{
			if(document.add_spect_variations.rd_money[j].checked)
			{
				value_deger_rd_money_orta[j]=filterNum(document.getElementById('txt_rate1_'+(j+1)).value,4);
				value_deger_rd_money_son[j]=filterNum(document.getElementById('txt_rate2_'+(j+1)).value,4);
				value_deger_rd_money_ilk[j]=document.getElementById('rd_money_name_'+(j+1)).value;
			}
		}
		if(!value_deger_rd_money_son || (value_deger_rd_money_son!=undefined && value_deger_rd_money_son.value==''))
		{
			value_deger_rd_money_orta=1;
			value_deger_rd_money_son=1;
		}
		add_spect_variations.doviz_name.value = value_deger_rd_money_ilk;
		add_spect_variations.other_toplam.value = commaSplit(parseFloat(add_spect_variations.toplam_miktar.value) * (parseFloat(value_deger_rd_money_orta)/parseFloat(value_deger_rd_money_son)),4);
		add_spect_variations.toplam_miktar.value = commaSplit(add_spect_variations.toplam_miktar.value,4);
		add_spect_variations.is_change.value =is_change;
	}
	function open_tree_add_row()
	{
		var money='';
		var islem_tarih='<cfoutput>#dateformat(now(),dateformat_style)#</cfoutput>';
		satir =-1 ;
		if(opener.moneyArray!=undefined && opener.rate2Array!=undefined && opener.rate1Array!=undefined)
			for(var i=0;i<opener.moneyArray.length;i++)
				money=money+'&'+opener.moneyArray[i]+'='+parseFloat(opener.rate2Array[i]/opener.rate1Array[i]);
		else
			money=money+'<cfoutput query="get_money">&#get_money.money#=#get_money.rate2/get_money.rate1#</cfoutput>';
		if(opener.form_basket!=undefined && opener.form_basket.search_process_date!=undefined)
		    islem_tarih= window.opener.document.getElementById(search_process_date).value; 
		windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_products&_spec_page_=2&update_product_row_id=0&<cfif isdefined("attributes.company_id")>company_id=#attributes.company_id#</cfif></cfoutput>&is_sale_product=1'+money+'&rowCount='+tree_row_count+'&search_process_date='+islem_tarih+'&sepet_process_type=-1&int_basket_id=<cfoutput>#attributes.basket_id#</cfoutput><cfif isdefined('attributes.unsalable')>&unsalable=1</cfif>&is_condition_sale_or_purchase=1&satir='+satir,'list');//is_price=1&is_price_other=1&is_cost=1&
	}
	function open_product_detail(pro_id,s_id)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_detail_product&pid='+pro_id+'&sid='+s_id,'list'); 
	}
	function  add_basket_row(product_id, stock_id, stock_code, barcod, manufact_code, product_name, unit_id_, unit_, spect_id, spect_name, price, price_other, tax, duedate, d1, d2, d3, d4, d5, d6, d7, d8, d9, d10, deliver_date, deliver_dept, department_head, lot_no, money, row_ship_id, amount_,product_account_code,is_inventory,is_production,net_maliyet,marj,extra_cost,row_promotion_id,promosyon_yuzde,promosyon_maliyet,iskonto_tutar,is_promotion,prom_stock_id)
	{
		if(document.getElementById('value_stock_id').value == stock_id)
		{
			alert("<cf_get_lang dictionary_id ='33934.Ana ürünü kendine bileşen olarak ekleyemezsiniz'>!");
			return false;
		}
		if(document.getElementById('main_prod_price_currency').value != money)
			price_other=wrk_round(price*product_rate2,2);//ana urun fiyat disindaki bir para biri ise onun ana urun fiyati cinsinden fiyat farki
		tree_row_count++;
		var newRow;
		var newCell;
		newRow = document.getElementById("table_tree").insertRow(document.getElementById("table_tree").rows.length);
		newRow.setAttribute("name","tree_row" + tree_row_count);
		newRow.setAttribute("id","tree_row" + tree_row_count);
		newRow.setAttribute("NAME","tree_row" + tree_row_count);
		newRow.setAttribute("ID","tree_row" + tree_row_count);
		document.all.tree_record_num.value=tree_row_count;
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="hidden" name="tree_is_configure'+tree_row_count+'" id="tree_is_configure'+tree_row_count+'" value="1"><input type="hidden" name="tree_row_kontrol'+tree_row_count+'" id="tree_row_kontrol'+tree_row_count+'" value="1"><input type="hidden" name="tree_product_id'+tree_row_count+'" id="tree_product_id'+tree_row_count+'" value="'+product_id+','+stock_id+','+price_other+','+money+','+price+',0,'+product_name+'"><a href="javascript://" onClick="sil_tree_row('+tree_row_count+')"><img src="/images/delete_list.gif" alt="<cf_get_lang dictionary_id='50765.Ürün Sil'>" border="0"></a>';
		<cfif isdefined('is_show_line_number') and is_show_line_number eq 1>
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<td></td>';
		</cfif>
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="tree_stock_code'+tree_row_count+'" id="tree_stock_code'+tree_row_count+'" value="'+stock_code+'" style="col col-12" readonly>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="tree_product_name'+tree_row_count+'" id="tree_product_name'+tree_row_count+'" value="'+product_name+'" style="width:280px" readonly><a href="javascript://" onclick="open_product_detail('+product_id+','+stock_id+')"> <img src="/images/plus_thin.gif" alt="<cf_get_lang dictionary_id ='46799.Ürün Detay'>" border="0" align="absmiddle"></a>';
		<cfif is_change_spect_name eq 1>
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="text" name="tree_stock_code'+tree_row_count+'" id="tree_stock_code'+tree_row_count+'" value="'+spect_name+'" style="col col-12" readonly>';                   			
	</cfif>
		//spec
		newCell = newRow.insertCell(newRow.cells.length);
		if(is_production==1)//üretilen ürün ise
			{
				if(spect_id == '')
				{
					var deger = workdata('get_main_spect_id',stock_id);
					if(deger.SPECT_MAIN_ID != undefined)//ürün üretilsede ağacı olmayabilir,o sebeble fonksiyondan undefined değeri dönebilir,hata olursa  boşaltıyoruz spect_main_id'yi
					var SPECT_MAIN_ID =deger.SPECT_MAIN_ID;else	var SPECT_MAIN_ID ='';
				}
				else if(spect_id != '')
				{
					var _get_main_spect_ = wrk_safe_query('obj_get_main_spect','dsn3',0,spect_id);
					var SPECT_MAIN_ID = _get_main_spect_.SPECT_MAIN_ID;
		
				}
				newCell.innerHTML = '<input name="related_spect_main_id'+tree_row_count+'" id="related_spect_main_id'+tree_row_count+'" style="width:43px;" class="box" value="'+SPECT_MAIN_ID+'" readonly>';
			}
		else
			newCell.innerHTML = '<input name="related_spect_main_id'+tree_row_count+'"  id="related_spect_main_id'+tree_row_count+'" style="width:43px;" class="box" value="" readonly>';
		//spec	
		//sb
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="checkbox" name="tree_is_sevk'+tree_row_count+'" id="tree_is_sevk'+tree_row_count+'" value="1">';
		//sb
		//alt ağaç
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '';
		//alt ağaç
		//miktar
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="tree_amount'+tree_row_count+'" id="tree_amount'+tree_row_count+'" value="1" class="moneybox" style="width:50px" onBlur="hesapla();">';
		//miktar
		//fiyat farkıalert(newCell);
		newCell = newRow.insertCell(newRow.cells.length);<cfif isdefined('is_show_diff_price') and is_show_diff_price eq 0>newCell.style.display='none';</cfif>
		newCell.innerHTML = '<input type="hidden" name="tree_total_amount'+tree_row_count+'" id="tree_total_amount'+tree_row_count+'" value="'+commaSplit(price_other,4)+'" onkeyup="return(FormatCurrency(this,event,2));" class="moneybox" onBlur="hesapla();" style="width:80px"><input type="text" name="tree_diff_price'+tree_row_count+'" id="tree_diff_price'+tree_row_count+'" value="'+commaSplit(price/document.getElementById('urun_para_birimi'+money).value,4)+'" onkeyup="return(FormatCurrency(this,event,2));" class="moneybox" onBlur="hesapla();" style="width:80px"><input type="hidden" name="tree_kdvstd_money'+tree_row_count+'" value="">';
		//fiyat farkı
		newCell = newRow.insertCell(newRow.cells.length);<cfif isdefined('is_show_price') and is_show_price eq 0>newCell.style.display='none';</cfif>
		newCell.innerHTML = '<input name="tree_total_amount_money'+tree_row_count+'" id="tree_total_amount_money'+tree_row_count+'" class="box" readonly  type="text" value="'+money+'" class="moneybox" style="width:50px">';//para br
		<cfif (isdefined('is_show_cost') and is_show_cost eq 1) or not isdefined("is_show_cost")><!--- Setup XML'den gelen kayıtlara göre maliyet geliyor yada gelmiyor --->
		//maliyet
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text"  id="tree_product_cost'+tree_row_count+'" name="tree_product_cost'+tree_row_count+'" value="'+commaSplit(net_maliyet,4)+'" readonly style="width:50px">';//maliyet
		//maliyet
		</cfif>
		//toplam miktar sistem para birimini tutar
		newCell = newRow.insertCell(newRow.cells.length);<cfif isdefined('is_show_price') and is_show_price eq 0>newCell.style.display='none';</cfif>
		newCell.innerHTML = '<input type="text" name="tree_std_money'+tree_row_count+'" id="tree_std_money'+tree_row_count+'" value="'+commaSplit(price,4)+'" class="moneybox" style="width:50px"><input type="hidden" name="reference_std_money'+tree_row_count+'" value="'+commaSplit(price,4)+'"style="width:50px"><input type="hidden" name="old_tree_std_money'+tree_row_count+'" value="'+commaSplit(price,4)+'" style="width:50px">';
		hesapla();
	}
	function calculate_spects(field_name_list)
	{
		for(i=1;i<=list_len(field_name_list)-1;i++)
		{
			var control = 'control'+list_getat(field_name_list,i,',');
			if(document.getElementById(control).value!=1)
			{	var spect_id = 'related_spect_main_id'+list_getat(field_name_list,i,',');
				var stock_id = 'stock_id'+list_getat(field_name_list,i,',');
				var deger = workdata('get_main_spect_id',document.getElementById(stock_id).value);
				if(deger.SPECT_MAIN_ID != undefined)//ürün üretilsede ağacı olmayabilir,o sebeble fonksiyondan undefined değeri dönebilir,hata olursa  boşaltıyoruz spect_main_id'yi
				var SPECT_MAIN_ID =deger.SPECT_MAIN_ID;else	var SPECT_MAIN_ID ='';
				//alert(document.getElementById(eval('add_spect_variations.spect_main_id#attributes.satir#_#satir#')).value);//=SPECT_MAIN_ID;
				document.getElementById(spect_id).value=SPECT_MAIN_ID
				document.getElementById(spect_id).style.background ='CCCCCC';
				document.getElementById(control).value=1;
			}	
		}
	}
	function sil_tree_row(sy)
	{
		var my_element=document.getElementById('tree_row_kontrol'+sy);
		my_element.value=0;
		var my_element=document.getElementById('tree_row'+sy);
		my_element.style.display="none";
		hesapla();
	}
	function UrunDegis(field,no,type)
	{
		var urun_para_birimi = document.getElementById('urun_para_birimi'+list_getat(field.value,4,',')).value;
		if(type==undefined)gizle(document.getElementById('SHOW_PRODUCT_TREE_ROW'+no));//ürün değiştiğinde değişen ürüne ait açılmış bir detayı varsa kapatıyoruz.
		var _stock_id_ = list_getat(field.value,2,',');//stock id göndererek main spect id'si varsa onu alıyoruz.
		var _is_production_ = list_getat(field.value,8,',')//is_production olup olmadığı
		if(type==undefined)
		{	
			if(_is_production_ == 1)
			{
				var deger = workdata('get_main_spect_id',_stock_id_);
				if(deger.SPECT_MAIN_ID != undefined)//ürün üretilsede ağacı olmayabilir,o sebeble fonksiyondan undefined değeri dönebilir,hata olursa  boşaltıyoruz spect_main_id'yi
				var SPECT_MAIN_ID =deger.SPECT_MAIN_ID;else	var SPECT_MAIN_ID ='';
				document.getElementById('related_spect_main_id'+no).value = SPECT_MAIN_ID;//spect_main_id değiştir.
				goster(document.getElementById('under_tree'+no));//alt ağaç ikonunu göster
			}
			else
			{
				gizle(document.getElementById('under_tree'+no));
				document.getElementById('related_spect_main_id'+no).value ='';
			}
		}	
		var price = list_getat(field.value,5,',');//5.ci eleman sistem para birimini ifade ediyor(YTL).
		if(price=="")price=0;
		var miktar = parseFloat(filterNum(document.getElementById('tree_amount'+no).value,4));
		if(isNaN(miktar) == true || miktar<=0 || miktar==''){document.getElementById('tree_amount'+no).value=1;miktar=1;}//alert(miktar);
		var fark = miktar*(price-parseFloat(filterNum(document.getElementById('reference_std_money'+no).value,4)));//alert(fark);
		main_product_rate=product_rate2;
		form_total_amount=filterNum(document.getElementById('tree_total_amount'+no).value,4);//fiyat farkı
		document.getElementById('tree_total_amount'+no).value = commaSplit(parseFloat(form_total_amount-main_product_rate*(filterNum(document.getElementById('tree_std_money'+no).value,4)-price)),4);//fiyat farkı yazdırılıyor 
		document.getElementById('tree_diff_price'+no).value = commaSplit(fark/urun_para_birimi,4);  
		//seçilen ürünün para birimi  bazında fiyat farkı
		document.getElementById('tree_std_money'+no).value=commaSplit(price,4);//satırdaki fiyat yazdırılıyor(seçilen alternatif ürünün fiyatı YTL olarak)
		hesapla();
	}
	function kontrol()
	{
		if(document.getElementById('tree_record_num').value==0)
		{
			alert("<cf_get_lang dictionary_id='60234.Satıra Ürün Ekleyiniz'>!");
			return false;	
		}
		hesapla();
		//ağaç
		for (var r=1;r<=add_spect_variations.tree_record_num.value;r++)
		{
			form_tree_amount = document.getElementById('tree_amount'+r);
			form_tree_total_amount = document.getElementById('tree_total_amount'+r);
			form_tree_diff_price = document.getElementById('tree_diff_price'+r);
			form_tree_std_money = document.getElementById('tree_std_money'+r);
			form_tree_std_money.value=filterNum(form_tree_std_money.value,4); 
			form_tree_diff_price.value=filterNum(form_tree_diff_price.value,4);
			form_tree_amount.value = filterNum(form_tree_amount.value,4);
			form_tree_total_amount.value = filterNum(form_tree_total_amount.value,4);
		}
		//özellikli
		<cfif isdefined('is_show_property_and_calculate') and is_show_property_and_calculate eq 1>//özellikler görülsün seçili ise
		for (var r=1;r<=add_spect_variations.pro_record_num.value;r++)
		{
			form_pro_tolerance = document.getElementById('pro_tolerance'+r);
			form_pro_amount = document.getElementById('pro_amount'+r);
			form_pro_total_amount = document.getElementById('pro_total_amount'+r);
			pro_total_min =document.getElementById('pro_total_min'+r);
			pro_total_max =document.getElementById('pro_total_max'+r);
			form_pro_tolerance.value=filterNum(form_pro_tolerance.value,4);
			pro_total_min.value=filterNum(pro_total_min.value,4);
			pro_total_max.value=filterNum(pro_total_max.value,4);
			form_pro_amount.value = filterNum(form_pro_amount.value,4);
			form_pro_total_amount.value = filterNum(form_pro_total_amount.value,4);
		}
		</cfif>
		//döviz kurları
		for (var r=1;r<=add_spect_variations.rd_money_num.value;r++)
		{
			form_txt_rate1 = document.getElementById('txt_rate1_'+r);
			form_txt_rate2 = document.getElementById('txt_rate2_'+r);
			form_txt_rate1.value = filterNum(form_txt_rate1.value,4);
			form_txt_rate2.value = filterNum(form_txt_rate2.value,4);
		}
		add_spect_variations.toplam_miktar.value = filterNum(add_spect_variations.toplam_miktar.value,4);
		add_spect_variations.other_toplam.value = filterNum(add_spect_variations.other_toplam.value,4);
		<cfif not isdefined("attributes.product_id")>
			if(add_spect_variations.is_change.value!=1)add_spect_variations.is_change.value=1;
		</cfif>
		return true;
	}
	hesapla();
</script>

