<cfif session.ep.period_year lt 2009 and session.ep.money is 'TL'>
	<cfset session.ep.money  ='YTL'>
</cfif>
<cfset xml_str=''>
<cfif not isdefined('attributes.add_main_spect')><!--- Eğer main spect ekleme sayfasından gelmiyorsa buraya gir,ve sayfayı XML yapısına göre oluştur --->
<cf_xml_page_edit>
<cfelse><!--- Main Spect Ekleme Sayfasından Geliyorsa eğer,zaten fiyatlar olmayacağı için XML yapısındaki fiyatları elle set edicez--->
	<!--- <cfset is_show_property_and_calculate = 0> ---><!--- Özelllikler İşlemler Kısmı standart da gelmesin kullanıcının seçimine göre gelsin--->
	<cfset is_show_detail = 0><!--- Main Spect'e detay girmiyoruz,detaylar sadece spect'de tutuluyor --->
	<cfset is_show_cost = 0><!--- Maliyet tutulmuyor zaten tablolarda, --->
	<cfset is_show_diff_price = 0><!--- Main Spect'de Fiyat tutulmuyor o sebeble burda fiyat farkı da göstermiyoruz  --->
	<cfset is_show_price = 0><!--- Main Spect'de Fiyat tutulmuyor o sebeble burda fiyat da göstermiyoruz  --->
	<cfset is_show_property_amount = 1>
	<cfset is_show_property_price = 0><!--- Main Spect'de Fiyat tutulmuyor o sebeble burda fiyat göstermiyoruz  --->
	<cfset is_show_tolerance_property = 1>
	<cfset is_show_line_number = 1>
    <cfset is_show_value = 0>
	<cfset xml_str = "&is_show_value=0&is_show_configure=0&is_show_line_number=0&is_show_property_and_calculate=#is_show_property_and_calculate#&is_show_detail=0&is_spect_name_to_property=#is_spect_name_to_property#&is_show_cost=0&is_show_diff_price=0&is_show_price=0&is_show_property_amount=1&is_show_property_price=0&is_show_tolerance_property=1">
</cfif>
<cfquery name="GET_MONEY" datasource="#dsn#">
    SELECT	
        PERIOD_ID,
        MONEY,
        RATE1,
        RATE2 
    FROM
        SETUP_MONEY 
    WHERE 
        PERIOD_ID = #session.ep.period_id# AND MONEY_STATUS = 1
</cfquery>
<cfquery name="get_money_2" dbtype="query">
	SELECT * FROM GET_MONEY WHERE MONEY = '#session.ep.money2#'
</cfquery>
<cfif spec_purchasesales eq 1>
	<!--- uyenin fiyat listesini bulmak icin--->
	<cfif isdefined("attributes.company_id") and len(attributes.company_id)>
		<cfquery name="GET_PRICE_CAT_CREDIT" datasource="#dsn#">
			SELECT
				PRICE_CAT
			FROM
				COMPANY_CREDIT
			WHERE
				COMPANY_ID = #attributes.company_id#  AND
				OUR_COMPANY_ID = #session.ep.company_id#
		</cfquery>
		<cfif GET_PRICE_CAT_CREDIT.RECORDCOUNT and len(GET_PRICE_CAT_CREDIT.PRICE_CAT)>
			<cfset attributes.price_catid=GET_PRICE_CAT_CREDIT.PRICE_CAT>
		<cfelse>
			<cfquery name="GET_COMP_CAT" datasource="#dsn#">
				SELECT COMPANYCAT_ID FROM COMPANY WHERE COMPANY_ID = #attributes.company_id#
			</cfquery>
			<cfquery name="GET_PRICE_CAT_COMP" datasource="#dsn3#">
				SELECT 
					PRICE_CATID
				FROM
					PRICE_CAT
				WHERE
					COMPANY_CAT LIKE '%,#GET_COMP_CAT.COMPANYCAT_ID#,%'
			</cfquery>
			<cfset attributes.price_catid = GET_PRICE_CAT_COMP.PRICE_CATID>
		</cfif>
	</cfif>
	<cfif isdefined("attributes.consumer_id") and len(attributes.consumer_id)>
		<cfquery name="GET_COMP_CAT" datasource="#DSN#">
			SELECT CONSUMER_CAT_ID FROM CONSUMER WHERE CONSUMER_ID = #attributes.consumer_id#
		</cfquery>
		<cfquery name="GET_PRICE_CAT" datasource="#DSN3#">
			SELECT PRICE_CATID FROM PRICE_CAT WHERE CONSUMER_CAT LIKE '%,#get_comp_cat.consumer_cat_id#,%'
		</cfquery>
		<cfset attributes.price_catid=get_price_cat.PRICE_CATID>
	</cfif>
</cfif>
<cfif isdefined("attributes.stock_id") and len(attributes.stock_id)>
	<cfquery name="GET_PRODUCT" datasource="#dsn3#">
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
			STOCKS.STOCK_ID =  #attributes.stock_id#
	</cfquery>
	<cfset attributes.product_id=GET_PRODUCT.PRODUCT_ID>
	<cfset product_id_list=GET_PRODUCT.PRODUCT_ID>
	<cfset tree_product_id_list="">
	<cfset operation_tree_id_list = ''>
	<cfscript>
		deep_level = 0;
		function GetDeepLevelMaınStockId(_deeplevel)
		{
			for (lind_ = _deeplevel-1;lind_ gte 0; lind_ = lind_-1){
				if(isdefined('_deep_level_main_stock_id_#lind_#') and len(Evaluate('_deep_level_main_stock_id_#lind_#')) and Evaluate('_deep_level_main_stock_id_#lind_#') gt 0)
					return Evaluate('_deep_level_main_stock_id_#lind_#');
			}
			return 1;
		}
		function isIncludeSubProduct(_deep_level_)
		{
			is_ok=1;
			for (lind = _deep_level_;lind gte 1; lind = lind-1){
				if(isdefined('type_#lind#') and Evaluate('type_#lind#') eq 3 and is_ok eq 1)
					is_ok = 1;
				else
					is_ok = 0;
			}
			return is_ok;
		}
		function get_subs(stock_id,spec_id,product_tree_id,type)//type 0 ise sarf 3 ise operasyon
		{
			if(type eq 0) where_parameter = 'PT.STOCK_ID = #stock_id#'; else where_parameter = 'RELATED_PRODUCT_TREE_ID = #product_tree_id#';
				SQLStr="
						SELECT
							0 AS SPECT_MAIN_ID,
							0 AS STOCK_ID,
							'-' AS STOCK_CODE,
							'<font color=purple>'+OP.OPERATION_TYPE+'</font>' AS PRODUCT_NAME,
							'-' AS PROPERTY,
							'-' AS MAIN_UNIT,
							1 AS IS_PRODUCTION,
							0 AS IS_CONFIGURE,
							ISNULL(PT.QUESTION_ID,0) AS QUESTION_ID,
							0 AS PRODUCT_ID,
							ISNULL(PT.AMOUNT,0) AS AMOUNT,
							PT.PRODUCT_TREE_ID,
							ISNULL(PT.IS_SEVK,0) AS IS_SEVK,
							0 AS IS_PHANTOM,
							ISNULL(PT.LINE_NUMBER,0) AS LINE_NUMBER,
							OP.OPERATION_TYPE_ID
						FROM 
							OPERATION_TYPES OP,
							PRODUCT_TREE PT
						WHERE 
							OP.OPERATION_TYPE_ID = PT.OPERATION_TYPE_ID AND
							#where_parameter#
				UNION ALL
						SELECT 
							ISNULL(PT.SPECT_MAIN_ID,0) AS SPECT_MAIN_ID,
							STOCKS.STOCK_ID,
							STOCKS.STOCK_CODE,
							STOCKS.PRODUCT_NAME,
							STOCKS.PROPERTY,
							PRODUCT_UNIT.MAIN_UNIT,
							STOCKS.IS_PRODUCTION,
							ISNULL(PT.IS_CONFIGURE,0) AS IS_CONFIGURE,
							ISNULL(PT.QUESTION_ID,0) AS QUESTION_ID,
							STOCKS.PRODUCT_ID,
							ISNULL(PT.AMOUNT,0) AS AMOUNT,
							PT.PRODUCT_TREE_ID,
							ISNULL(PT.IS_SEVK,0) AS IS_SEVK,
							ISNULL(PT.IS_PHANTOM,0) AS IS_PHANTOM,
							ISNULL(PT.LINE_NUMBER,0) AS LINE_NUMBER,
							0 AS OPERATION_TYPE_ID
						FROM
							STOCKS,
							PRODUCT_TREE PT,
							PRODUCT_UNIT
						WHERE
							PRODUCT_UNIT.PRODUCT_UNIT_ID = PT.UNIT_ID AND
							PT.RELATED_ID = STOCKS.STOCK_ID AND
							#where_parameter#
					 ORDER BY LINE_NUMBER ASC		
				";
			query1 = cfquery(SQLString : SQLStr, Datasource : dsn3);
			'type_#deep_level#' = type;
			stock_id_ary='';
			for (str_i=1; str_i lte query1.recordcount; str_i = str_i+1)
			{
				stock_id_ary=listappend(stock_id_ary,query1.STOCK_ID[str_i],'█');
				stock_id_ary=listappend(stock_id_ary,query1.PRODUCT_ID[str_i],'§');
				stock_id_ary=listappend(stock_id_ary,query1.STOCK_CODE[str_i],'§');
				if(len(query1.PROPERTY[str_i]))
					stock_id_ary=listappend(stock_id_ary,query1.PROPERTY[str_i],'§');
				else
					stock_id_ary=listappend(stock_id_ary,'-','§');
				stock_id_ary=listappend(stock_id_ary,query1.PRODUCT_NAME[str_i],'§');
				stock_id_ary=listappend(stock_id_ary,query1.SPECT_MAIN_ID[str_i],'§');
				stock_id_ary=listappend(stock_id_ary,query1.PRODUCT_TREE_ID[str_i],'§');
				stock_id_ary=listappend(stock_id_ary,query1.OPERATION_TYPE_ID[str_i],'§');
				stock_id_ary=listappend(stock_id_ary,query1.AMOUNT[str_i],'§');
				stock_id_ary=listappend(stock_id_ary,query1.IS_CONFIGURE[str_i],'§');
				stock_id_ary=listappend(stock_id_ary,query1.IS_SEVK[str_i],'§');
				stock_id_ary=listappend(stock_id_ary,query1.IS_PHANTOM[str_i],'§');
				stock_id_ary=listappend(stock_id_ary,query1.IS_PRODUCTION[str_i],'§');
				stock_id_ary=listappend(stock_id_ary,query1.LINE_NUMBER[str_i],'§');
				stock_id_ary=listappend(stock_id_ary,query1.QUESTION_ID[str_i],'§');
				if(len(query1.MAIN_UNIT[str_i]))
					stock_id_ary=listappend(stock_id_ary,query1.MAIN_UNIT[str_i],'§');
				else
					stock_id_ary=listappend(stock_id_ary,'-','§');
				if(len(query1.STOCK_ID[str_i]))
					operation_tree_id_list = listappend(operation_tree_id_list,query1.PRODUCT_TREE_ID[str_i]);
			}
			return stock_id_ary;
		}
		function writeTree(next_stock_id,next_spec_id,next_production_tree_id,type)
		{
			var i = 1;
			var sub_products = get_subs(next_stock_id,next_spec_id,next_production_tree_id,type);
			deep_level = deep_level + 1;
			for (i=1; i lte listlen(sub_products,'█'); i = i+1)
			{
				product_values_list = ListGetAt(sub_products,i,'█');
				leftSpace = RepeatString('&nbsp;', deep_level*5);
				_n_stock_id_ = ListGetAt(product_values_list,1,'§');
				_n_spec_main_id_ = ListGetAt(product_values_list,6,'§');
				_n_product_tree_id_ = ListGetAt(product_values_list,7,'§');
				_n_operation_type_id_ = ListGetAt(product_values_list,8,'§');
				if(_n_operation_type_id_ gt 0)
					writeTree(_n_stock_id_,_n_spec_main_id_,_n_product_tree_id_,3);
			}
			deep_level = deep_level-1;
		}
	</cfscript>
	<cfquery name="GET_PROD_TREE_OP" datasource="#dsn3#">
		SELECT
			OP.OPERATION_TYPE PRODUCT_NAME,
			'' PRODUCT_ID,
			'' IS_PRODUCTION,
			'' STOCK_ID,
			'' STOCK_CODE,
			'' PROPERTY,
			PRODUCT_TREE.AMOUNT,
			PRODUCT_TREE.PRODUCT_TREE_ID,
			PRODUCT_TREE.SPECT_MAIN_ID,
			'' MAIN_UNIT,
			PRODUCT_TREE.IS_CONFIGURE,
			PRODUCT_TREE.IS_SEVK,
			PRODUCT_TREE.LINE_NUMBER
		FROM 
			OPERATION_TYPES OP,
			PRODUCT_TREE
		WHERE 
			OP.OPERATION_TYPE_ID = PRODUCT_TREE.OPERATION_TYPE_ID AND
			PRODUCT_TREE.STOCK_ID = #attributes.stock_id#
	</cfquery>
	<cfif GET_PROD_TREE_OP.recordcount>
		<cfloop query="GET_PROD_TREE_OP">
			<cfscript>
				writeTree(attributes.stock_id,0,GET_PROD_TREE_OP.PRODUCT_TREE_ID,3);
			</cfscript>
		</cfloop>
	</cfif>
	<cfquery name="GET_PROD_TREE" datasource="#dsn3#">
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
            PRODUCT_TREE.LINE_NUMBER
		FROM
			STOCKS,
			PRODUCT_TREE,
			PRODUCT_UNIT
		WHERE
			PRODUCT_UNIT.PRODUCT_UNIT_ID = PRODUCT_TREE.UNIT_ID AND
			PRODUCT_TREE.RELATED_ID = STOCKS.STOCK_ID AND
			PRODUCT_TREE.STOCK_ID = #attributes.stock_id#
		<cfif len(operation_tree_id_list)>
		UNION ALL
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
				PRODUCT_TREE.LINE_NUMBER
			FROM
				STOCKS,
				PRODUCT_TREE,
				PRODUCT_UNIT
			WHERE
				PRODUCT_UNIT.PRODUCT_UNIT_ID = PRODUCT_TREE.UNIT_ID AND
				PRODUCT_TREE.RELATED_ID = STOCKS.STOCK_ID AND
				PRODUCT_TREE.PRODUCT_TREE_ID IN(#operation_tree_id_list#)
		</cfif>
       ORDER BY  PRODUCT_TREE.LINE_NUMBER,STOCKS.PRODUCT_NAME
	</cfquery>
	<cfif GET_PROD_TREE.RECORDCOUNT>
		<cfoutput query="GET_PROD_TREE">
			<cfset product_id_list=ListAppend(product_id_list,GET_PROD_TREE.PRODUCT_ID,',')>
			<cfset tree_product_id_list=ListAppend(tree_product_id_list,GET_PROD_TREE.PRODUCT_ID,',')>
		</cfoutput>
	</cfif>
	<!--- Ürün Özellik-işlemler --->
	<cfquery name="GET_PROPERTY" datasource="#DSN1#">
		SELECT 
			PRODUCT_DT_PROPERTIES.*,
			PRODUCT_PROPERTY.PROPERTY,
			PRODUCT_PROPERTY.PROPERTY_ID
		FROM 
			PRODUCT_DT_PROPERTIES,
			PRODUCT_PROPERTY
		WHERE 
			PRODUCT_DT_PROPERTIES.PRODUCT_ID = #attributes.product_id# AND
			PRODUCT_DT_PROPERTIES.PROPERTY_ID = PRODUCT_PROPERTY.PROPERTY_ID
        ORDER BY 
        	LINE_VALUE
	</cfquery>
	<cfif listlen(tree_product_id_list,',')>
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
				P.PRODUCT_ID NOT IN (SELECT PRODUCT_ID FROM ALTERNATIVE_PRODUCTS_EXCEPT WHERE ALTERNATIVE_PRODUCT_ID=#attributes.product_id#) AND
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
		<cfoutput query="GET_ALTERNATE_PRODUCT">
			<cfset product_id_list=ListAppend(product_id_list,GET_ALTERNATE_PRODUCT.PRODUCT_ID,',')>
		</cfoutput>
	</cfif>
	<cfset product_id_list=ListDeleteDuplicates(product_id_list)>
	<cfif spec_purchasesales eq 1>
		<!--- tum sayfadaki urunler icin fiyatları aliyor sonra query of query ile cekecek--->
		<cfif isdefined("attributes.price_catid") and len(attributes.price_catid)>
			<cfquery name="GET_PRICE" datasource="#dsn3#">
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
					PRICE_STANDART.STARTDATE< #now()# AND 
					(PRICE_STANDART.FINISHDATE >= #now()# OR PRICE_STANDART.FINISHDATE IS NULL) AND
					PRODUCT_UNIT.PRODUCT_ID = PRICE_STANDART.PRODUCT_ID AND 
					PRICE_STANDART.PRODUCT_ID IN (#product_id_list#) AND 
					PRODUCT_UNIT.IS_MAIN = 1 AND
                    <cfif session.ep.period_year lt 2009>
						((SM.MONEY = PRICE_STANDART.MONEY) OR (SM.MONEY = 'YTL') AND PRICE_STANDART.MONEY = 'TL') AND
					<cfelse>
                        SM.MONEY = PRICE_STANDART.MONEY AND
					</cfif>
					SM.PERIOD_ID = #session.ep.period_id#
			</cfquery>
		</cfif>
	</cfif>
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
			PRODUCT.PRODUCT_ID IN (#product_id_list#)
	</cfquery>
	<!---Maliyet Kısmı  --->
	<cfif not isdefined('is_show_cost') or (isdefined('is_show_cost') and is_show_cost eq 1)><!--- Setup XML'den gelen kayıtlara göre maliyet geliyor yada gelmiyor --->
		<cfif listlen(product_id_list)>
			<cfquery name="get_product_cost_all" datasource="#dsn1#"><!--- Maliyetler geliyor. --->
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
	<!---Maliyet  --->
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
<cfloop query="GET_MONEY">
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
<cfif isdefined("attributes.create_main_spect_and_add_new_spect_id")>
	<cfset url_str = "#url_str#&create_main_spect_and_add_new_spect_id=1">
</cfif>

<table cellspacing="1" cellpadding="2" border="0" width="100%" class="color-border">
	<cfform  name="add_spect_variations" action="#request.self#?fuseaction=objects.emptypopup_upd_spect_query_new#url_str#" method="post" enctype="multipart/form-data">
    <input type="hidden" name="basket_id" id="basket_id" value="<cfif isdefined("attributes.basket_id")>#attributes.basket_id#</cfif>">
	<cfif isdefined('attributes.add_main_spect')>
    <input type="hidden" name="add_main_spect" id="add_main_spect" value="1"></cfif><!--- Main Spec Ekleme Sayfası oluyor,burda fiyatları kaydetmiyor ve arkada sadece main spect kaydediyor --->
	<input type="hidden" name="order_id" id="order_id" value=""><!---spectin acildigi saydadaki order idnin alinacagı alan--->
	<input type="hidden" name="ship_id" id="ship_id" value=""><!---spectin acildigi saydadaki ship idnin alinacagı alan--->
	<input type="hidden" name="is_change" id="is_change" value="0">
	<input type="hidden" name="is_old_style" id="is_old_style" value="1">
	<input type="hidden" name="is_add_same_name_spect" id="is_add_same_name_spect" value="<cfif isdefined("is_add_same_name_spect")><cfoutput>#is_add_same_name_spect#</cfoutput><cfelse>0</cfif>">
	<input type="hidden" name="reference_amount" id="reference_amount" value="0">
	<cfif isdefined("attributes.field_id") and isdefined("attributes.field_name")>
		<input type="hidden" name="field_name" id="field_name" value="<cfoutput>#attributes.field_name#</cfoutput>">
		<input type="hidden" name="field_id" id="field_id" value="<cfoutput>#attributes.field_id#</cfoutput>">
	</cfif>
    <cfif isdefined("attributes.create_main_spect_and_add_new_spect_id")>
        <input type="hidden" name="create_main_spect_and_add_new_spect_id" id="create_main_spect_and_add_new_spect_id" value="1">
    </cfif>
    <cfif isdefined("attributes.field_main_id")>
		<input type="hidden" name="field_main_id" id="field_main_id" value="<cfoutput>#attributes.field_main_id#</cfoutput>">
	</cfif>
	<cfif isdefined("attributes.row_id")><!--- basketen geldi ise basketteki satırı--->
		<input type="hidden" name="row_id" id="row_id" value="<cfoutput>#attributes.row_id#</cfoutput>">
	</cfif>
	<tr class="color-list">
		<td class="headbold">
			<table width="100%" cellpadding="0" cellspacing="0" border="0">
				<tr>	
					<td class="headbold"><cf_get_lang dictionary_id ='33919.Konfigürasyon/Spec'></td>
					<td  style="text-align:right;">
					<cfoutput>
					<cfif isdefined("attributes.stock_id") and len(attributes.stock_id)><a href="#request.self#?fuseaction=objects.popup_list_spect_main&main_to_add_spect=1&#url_str#"><img src="/images/cuberelation.gif" align="absmiddle" border="0" title="<cf_get_lang dictionary_id ='33920.Konfigüratör'>"></a></cfif>
					</cfoutput>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr class="color-row">
		<td>
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
									PRODUCT_ID=#attributes.product_id#
							  </cfquery>
						</cfif>
						  <cfif not isdefined("GET_PRICE_MAIN_PROD") or GET_PRICE_MAIN_PROD.RECORDCOUNT eq 0>
							<cfquery name="GET_PRICE_MAIN_PROD" dbtype="query">
								SELECT
									*
								FROM
									GET_PRICE_STANDART
								WHERE
									PRODUCT_ID=#attributes.product_id#
							</cfquery>
						  </cfif>
						<cfset spec_name=get_product.product_name>
						<cfif len(get_product.PROPERTY)><cfset spec_name="#spec_name# #get_product.PROPERTY#"></cfif>
						<input type="hidden" name="value_product_id" id="value_product_id" value="<cfoutput>#get_product.product_id#</cfoutput>">
						<input type="hidden" name="value_stock_id" id="value_stock_id" value="<cfoutput>#get_product.stock_id#</cfoutput>">
						<input type="hidden" name="main_prod_price" id="main_prod_price" value="<cfoutput>#GET_PRICE_MAIN_PROD.PRICE#</cfoutput>">
						<input type="hidden" name="main_prod_price_currency" id="main_prod_price_currency" value="<cfoutput>#GET_PRICE_MAIN_PROD.MONEY#</cfoutput>">
						<input type="hidden" name="main_std_money" id="main_std_money" value="<cfoutput>#GET_PRICE_MAIN_PROD.PRICE_STDMONEY#</cfoutput>">
						<input type="hidden" name="main_kdvstd_money" id="main_kdvstd_money" value="<cfoutput>#GET_PRICE_MAIN_PROD.PRICE_KDV_STDMONEY#</cfoutput>">
						<cfquery name="GET_MAIN_PRICE" dbtype="query">
							SELECT RATE2, RATE1 FROM GET_MONEY WHERE MONEY = '#GET_PRICE_MAIN_PROD.MONEY#' AND PERIOD_ID = #session.ep.period_id#
						</cfquery>
					<cfelse>
						<input type="hidden" name="value_product_id" id="value_product_id" value="">
						<input type="hidden" name="value_stock_id" id="value_stock_id" value="">
						<input type="hidden" name="main_prod_price" id="main_prod_price" value="0">
						<input type="hidden" name="main_prod_price_currency" id="main_prod_price_currency" value="<cfoutput>#session.ep.money#</cfoutput>">
						<input type="hidden" name="main_std_money" id="main_std_money" value="0">
						<input type="hidden" name="main_kdvstd_money" id="main_kdvstd_money" value="">
					</cfif>
					<td width="100"><cf_get_lang dictionary_id ='33921.Spec Ad'>/<cf_get_lang dictionary_id ='58585.Kod'></td>
					<td width="170">
					<cfif isdefined("attributes.product_id")>
						<cfinput type="text" name="spect_name"  style="width:250;" value="#spec_name#" maxlength="500">
					<cfelse>
						<cfinput type="text" name="spect_name"  style="width:250;" value="" maxlength="500">
					</cfif>
					</td>
					<td width="100"><input type="checkbox" name="is_price_change" id="is_price_change" value="1" checked><cf_get_lang dictionary_id ='33922.Fiyatı Güncelle'></td>
					<td width="100"></td>
				</tr>
				<tr>
					<cfif isdefined('is_show_detail') and is_show_detail eq 1>
					<td width="100" valign="top"><cf_get_lang dictionary_id ='57771.Detay'> /<cf_get_lang dictionary_id ='33923.Talimat'> </td>
					<td width="170"><textarea name="spect_detail" id="spect_detail" style="width:250px; height:50px;"></textarea></td>
					</cfif>
					<cfif not isdefined('attributes.add_main_spect')><!--- Main Spect'e dosya yükleyemediğimz için,main spect eklerden burası görüntülenmeyecek! --->
					<td width="100" valign="top"><cf_get_lang dictionary_id ='57515.Dosya Ekle'></td>
					<td width="100" valign="top"><input type="file" name="spect_file_name" id="spect_file_name" style="width:200;"></td>
					</cfif>
				</tr>
				<tr>
					<td colspan="1"></td><cfif isdefined('GET_PRODUCT.IS_PROTOTYPE') and GET_PRODUCT.IS_PROTOTYPE><cf_workcube_buttons is_upd='0' add_function='kontrol()'></cfif></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr class="color-header">
		<td class="form-title" height="22"><cf_get_lang dictionary_id ='33924.Konfigüratör Bileşenleri'></td>
	</tr>
	<tr class="color-row">
		<td>
			<table>
				<tr class="txtbold" height="20">
					<cfoutput>
					<td width="35"></td>
					<td width="120">#GET_PRODUCT.STOCK_CODE#</td>
					<td width="360">#get_product.product_name# #get_product.PROPERTY#</td>
					</cfoutput>
					<td width="80" style="text-align:right;"><cfoutput>#GET_PRICE_MAIN_PROD.PRICE#</td>
					<td width="60">#GET_PRICE_MAIN_PROD.MONEY#</td></cfoutput>
				</tr>
			</table>
			<table name="table_tree" cellpadding="2" cellspacing="1" id="table_tree" border="0">
				<cfset satir=0>
				<tr class="color-list" height="20">
					<td width="15"><input type="button" class="eklebuton" title="" onClick="open_tree_add_row();"></td>
					<cfif isdefined('is_show_line_number') and is_show_line_number eq 1><td  class="txtboldblue" width="15"><cf_get_lang dictionary_id='57487.No'></td></cfif>
                    <td width="120" class="txtboldblue" ><cf_get_lang dictionary_id ='57518.Stok Kodu'></td>
					<td width="200" class="txtboldblue"><cf_get_lang dictionary_id ='57657.Ürün'>/<cf_get_lang dictionary_id ='57629.Açıklama'></td>
					<td width="40" class="txtboldblue"><cf_get_lang dictionary_id ='33925.Spec M'></td>
					<td width="15" class="txtboldblue"><cf_get_lang dictionary_id ='33926.SB'></td>
					<td width="15" class="txtboldblue"><img src="/images/shema_list.gif" align="absmiddle" border="0" title="<cf_get_lang dictionary_id ='33927.Alt Ağaç'>"></td>
					<td width="45" class="txtboldblue"><cf_get_lang dictionary_id ='57635.Miktar'>*</td>
					<td width="80" <cfif isdefined('is_show_diff_price') and is_show_diff_price eq 0> style="display:none;"</cfif>class="txtboldblue"><cf_get_lang dictionary_id ='33928.Fiyat Farkı'>*</td>
					<td width="60" <cfif isdefined('is_show_price') and is_show_price eq 0> style="display:none;"</cfif> class="txtboldblue"><cf_get_lang dictionary_id ='57489.Para Br'></td>
					<td width="60" <cfif isdefined('is_show_cost') and is_show_cost eq 0> style="display:none;"</cfif> class="txtboldblue"><cf_get_lang dictionary_id='58258.Maliyet'></td>
					<td width="100" <cfif isdefined('is_show_price') and is_show_price eq 0> style="display:none;"</cfif>class="txtboldblue"><cf_get_lang dictionary_id='58084.Fiyat'></td>
				</tr>
				<cfoutput query="get_prod_tree">
					<cfset satir=satir+1>
					<cfif isQuery(get_price) and isdefined("get_price.product_id")>
						<cfquery name="GET_PRICE_MAIN" dbtype="query">
							SELECT
									*
							FROM
									GET_PRICE
							WHERE
									PRODUCT_ID=#product_id#
						</cfquery>
					</cfif>
					<cfif not isdefined("GET_PRICE_MAIN") or  GET_PRICE_MAIN.RECORDCOUNT eq 0>
						<cfquery name="GET_PRICE_MAIN" dbtype="query">
                            SELECT
                                *
                            FROM
                                GET_PRICE_STANDART
                            WHERE
                                PRODUCT_ID=#product_id#
						</cfquery>
					</cfif>
					<cfif IS_CONFIGURE>
						<cfquery name="get_alternative" dbtype="query">
							SELECT * FROM GET_ALTERNATE_PRODUCT WHERE ASIL_PRODUCT = #PRODUCT_ID# OR ALTERNATIVE_PRODUCT_ID = #PRODUCT_ID#
						</cfquery>
					</cfif>
					<tr id="tree_row#satir#"<cfif isdefined('is_show_configure') and is_show_configure eq 1 and IS_CONFIGURE neq 1> style="display:none;"</cfif>>
                    <td width="15"><input type="hidden" name="tree_row_kontrol#satir#" id="tree_row_kontrol#satir#" value="1"><cfif IS_CONFIGURE><a href="javascript://" onClick="sil_tree_row(#satir#)"><img src="/images/delete_list.gif" title="<cf_get_lang dictionary_id ='50765.Ürün Sil'>" border="0"></a><input type="hidden" name="tree_is_configure#satir#"  id="tree_is_configure#satir#" value="1"></cfif></td>
                    <cfif isdefined('is_show_line_number') and is_show_line_number eq 1><td align="center">
                    <input type="text" name="line_number#satir#" id="line_number#satir#" style="width:15px;text-align:right" class="box" readonly value="#LINE_NUMBER#"></td></cfif>
					<td width="120"><input type="text" name="tree_stock_code#satir#" id="tree_stock_code#satir#" value="#STOCK_CODE#" style="width:120px" readonly></td>
					<td nowrap="nowrap" class="x-18">
						<div class="form-group mt-0">
							<div class="input-group col-12">
								<select name="tree_product_id#satir#" id="tree_product_id#satir#" <cfif isdefined('get_alternative') and get_alternative.recordcount and IS_CONFIGURE>style="background:FFCCCC;"</cfif> style="col col-12" onChange="UrunDegis(this,'#satir#');document.getElementById('tree_total_amount_money#satir#').value=list_getat(this.value,4);">
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
								<span class="input-group-addon btnPointer icon-ellipsis" onClick="windowopen('#request.self#?fuseaction=objects.popup_detail_product&pid='+list_getat(document.add_spect_variations.tree_product_id#satir#.value,1)+'&sid='+list_getat(document.add_spect_variations.tree_product_id#satir#.value,2),'medium')"></span>
							</div>
						</div>				
					</td>
					<td><input title="Spec Bileşenleri" id="related_spect_main_id#satir#" <cfif is_production eq 1>style="width:43px;cursor:pointer;" onClick="document.getElementById('tree_std_money#satir#').value=document.getElementById('old_tree_std_money#satir#').value;goster(SHOW_PRODUCT_TREE_ROW#satir#);AjaxPageLoad('#request.self#?fuseaction=objects.popup_ajax_spect_detail_ajax#xml_str#&stock_id='+list_getat(document.all.tree_product_id#satir#.value,2,',')+'&product_id='+list_getat(document.all.tree_product_id#satir#.value,1,',')+'&satir=#satir#&spec_purchasesales=#spec_purchasesales#&RATE1=#get_money_2.RATE1#&RATE2=#get_money_2.RATE2#&is_spect_or_tree='+document.getElementById('related_spect_main_id#satir#').value+'','SHOW_PRODUCT_TREE_INFO#satir#',1)"</cfif> name="related_spect_main_id#satir#" style="width:43px;" class="box" value="<cfif is_production eq 1>#SPECT_MAIN_ID#</cfif>" readonly></td><!--- Spec --->
						<cfif is_production eq 1 and (not len(SPECT_MAIN_ID) or SPECT_MAIN_ID eq 0)><!--- Eğer ürün üretiliyor ise,o anki main spect'ini alıcaz ve 1 üst satırdaki related_spect_main_id kısmına yazdırıcaz --->
                            <script type="text/javascript">
                                var deger = workdata('get_main_spect_id','#stock_id#');
                                if(deger.SPECT_MAIN_ID != undefined)//ürün üretilsede ağacı olmayabilir,o sebeble fonksiyondan undefined değeri dönebilir,hata olursa  boşaltıyoruz related_spect_main_id'yi
                                var SPECT_MAIN_ID = deger.SPECT_MAIN_ID;else	var SPECT_MAIN_ID ='';
                                document.getElementById('related_spect_main_id#satir#').value= SPECT_MAIN_ID;
								document.getElementById('related_spect_main_id#satir#').style.background ='CCCCCC';
                            </script>
                        </cfif>
					<td><input type="checkbox" name="tree_is_sevk#satir#" id="tree_is_sevk#satir#" value="1" <cfif is_sevk>checked</cfif>></td><!--- SB --->
					<!--- Alt Ağaç --->
					<td><img src="/images/shema_list.gif"  title="<cf_get_lang dictionary_id ='33930.Ağaç Bileşenleri'>" id="under_tree#satir#"  style="cursor:pointer;"<cfif is_production neq 1>style="display:none"</cfif>  align="absmiddle" border="0" onClick="document.getElementById('tree_std_money#satir#').value=document.getElementById('old_tree_std_money#satir#').value;goster(SHOW_PRODUCT_TREE_ROW#satir#);AjaxPageLoad('#request.self#?fuseaction=objects.popup_ajax_spect_detail_ajax#xml_str#&stock_id='+list_getat(document.all.tree_product_id#satir#.value,2,',')+'&product_id='+list_getat(document.all.tree_product_id#satir#.value,1,',')+'&satir=#satir#&spec_purchasesales=#spec_purchasesales#&RATE1=#get_money_2.RATE1#&RATE2=#get_money_2.RATE2#','SHOW_PRODUCT_TREE_INFO#satir#',1);"></td>
					<!--- Alt Ağaç --->
					<td><input name="tree_amount#satir#" id="tree_amount#satir#" type="text" class="moneybox" style="width:50px" onFocus="document.getElementById('reference_amount').value=filterNum(this.value,4)"  onKeyUp="FormatCurrency(this,event,2);UrunDegis(document.getElementById('tree_product_id#satir#'),'#satir#',1);" value="#TLFormat(AMOUNT,4)#" <cfif IS_CONFIGURE eq 0>readonly</cfif> autocomplete="off"></td>
					<td <cfif isdefined('is_show_diff_price') and is_show_diff_price eq 0> style="display:none;"</cfif>>
						<!--- Ana ürün bazında fiyat farkı --->
						<input type="hidden" name="tree_total_amount#satir#" id="tree_total_amount#satir#" value="#TLFormat(0,4)#" onkeyup="return(FormatCurrency(this,event,2));" class="moneybox" onBlur="hesapla('');" style="width:80px"  <cfif IS_CONFIGURE eq 0>readonly</cfif>>
						<!--- Kendi para biriminde fiyat farkı --->
						<input type="text" name="tree_diff_price#satir#"  id="tree_diff_price#satir#" value="#TLFormat(0,4)#" onkeyup="return(FormatCurrency(this,event,2));" class="moneybox" onBlur="hesapla('');" style="width:80px"  <cfif IS_CONFIGURE eq 0>readonly</cfif>>
						<input type="hidden" name="tree_kdvstd_money#satir#" id="tree_kdvstd_money#satir#" value="#get_price_main.price_kdv_stdmoney#"><!--- Fiyat Farkı --->
					</td>
					<td <cfif isdefined('is_show_price') and is_show_price eq 0> style="display:none"</cfif>><input name="tree_total_amount_money#satir#" id="tree_total_amount_money#satir#" class="box" readonly  type="text" value="#get_price_main.money#" style="width:50px"></td><!--- Para Br --->
					<cfif not isdefined('is_show_cost') or (isdefined('is_show_cost') and is_show_cost eq 1)><!--- Setup XML'den gelen kayıtlara göre maliyet geliyor yada gelmiyor --->
						<!--- Maliyet --->
						<cfquery name="get_product_cost" dbtype="query"><!--- Maliyetler geliyor. --->
							SELECT * FROM get_product_cost_all WHERE PRODUCT_ID = #PRODUCT_ID#
						</cfquery>
						<!--- maliyetleri yoksa 0 set ediliyor. --->
						<cfif len(get_product_cost.PURCHASE_NET_SYSTEM)><cfset PURCHASE_NET_SYSTEM = get_product_cost.PURCHASE_NET_SYSTEM><cfelse><cfset PURCHASE_NET_SYSTEM = 0></cfif>
						<cfif len(get_product_cost.PURCHASE_EXTRA_COST_SYSTEM)><cfset PURCHASE_EXTRA_COST_SYSTEM = get_product_cost.PURCHASE_EXTRA_COST_SYSTEM><cfelse><cfset PURCHASE_EXTRA_COST_SYSTEM = 0></cfif>
						<td><input type="text" name="tree_product_cost#satir#" id="tree_product_cost#satir#" value="#TLFormat(PURCHASE_NET_SYSTEM+PURCHASE_EXTRA_COST_SYSTEM,4)#" readonly class="moneybox" style="width:50px"></td>
						<!--- Maliyet --->
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
			</table>
		</td>
	</tr>
	<cfif isdefined('is_show_property_and_calculate') and is_show_property_and_calculate eq 1><!--- ÖZellikler görüntülenmek isteniyorsa --->
	<tr class="color-header">
		<td class="form-title" height="22"><cf_get_lang dictionary_id='58910.Özellikler'>/<cf_get_lang dictionary_id ='57777.İşlemler'></td>
	</tr>
	<tr class="color-row">
		<td>
			<table>
				<tr class="color-list">
					<td class="txtboldblue" width="100"><cf_get_lang dictionary_id ='57632.Özellik'></td>
					<td class="txtboldblue"  width="110"><cf_get_lang dictionary_id ='33615.Varyasyon'></td>
					<td class="txtboldblue" width="140"><cf_get_lang dictionary_id ='57629.Açıklama'></td>
                    <td class="txtboldblue" width="65" <cfif isdefined('is_show_value') and is_show_value eq 0> style="display:none" </cfif>><cf_get_lang dictionary_id ='33616.Değer'></td>
					<cfif isdefined('is_show_tolerance_property') and is_show_tolerance_property eq 1>
					<td class="txtboldblue" width="30"><cf_get_lang dictionary_id='29443.Tolerans'></td>
					</cfif>
					<cfif isdefined('is_show_property_amount') and is_show_property_amount eq 1>
					<td class="txtboldblue" width="50"><cf_get_lang dictionary_id ='57635.Miktar'></td>
					</cfif>
					<cfif isdefined('is_show_property_price') and is_show_property_price eq 1>
					<td class="txtboldblue" width="80"><cf_get_lang dictionary_id ='57673.Tutar'></td>
					<td class="txtboldblue" width="50"><cf_get_lang dictionary_id ='57489.Para Br'></td>
					<td class="txtboldblue" width="80"><cf_get_lang dictionary_id ='33932.Toplam Fiyat'></td>
					</cfif>
				</tr>
				<input type="hidden" name="pro_record_num" id="pro_record_num" value="<cfoutput>#get_property.recordcount#</cfoutput>">
				<cfoutput query="get_property">
					<tr>
						<cfquery name="GET_VARIATION" datasource="#DSN1#">
							SELECT PROPERTY_DETAIL_ID, PROPERTY_DETAIL FROM PRODUCT_PROPERTY_DETAIL WHERE PRPT_ID = #get_property.property_id#
						</cfquery>
						<td width="100"><b>#property#</b></td>
						<td>
						<input type="hidden" name="is_active#currentrow#" id="is_active#currentrow#" value="1">
						<input type="hidden" name="pro_property_id#currentrow#" id="pro_property_id#currentrow#" value="#PROPERTY_ID#">
							<select name="pro_variation_id#currentrow#" id="pro_variation_id#currentrow#" style="width:140px;">
								<cfset var_value = 0>
								<option value="">Varyasyon</option>
								<cfloop query="get_variation">	
									<option value="#PROPERTY_DETAIL_ID#" <cfif var_value eq PROPERTY_DETAIL_ID>selected</cfif>>#PROPERTY_DETAIL#</option>
								</cfloop>
							</select>
						</td>
						<td><input type="text" name="pro_product_name#currentrow#" id="pro_product_name#currentrow#" value="" style="width:140px"></td>
						<td nowrap="nowrap" <cfif isdefined('is_show_value') and is_show_value eq 0> style="display:none" </cfif>>
						<cfsavecontent variable="message"><cf_get_lang dictionary_id ='33933.Sayı Giriniz'></cfsavecontent>
							<cfinput type="text" name="pro_total_min#currentrow#" value="#TOTAL_MIN#" validate="float" message="#message#" style="width:30px">
							<cfinput type="text" name="pro_total_max#currentrow#" value="#TOTAL_MAX#" validate="float" message="#message#" style="width:30px">
						</td>
						<td <cfif isdefined('is_show_tolerance_property') and is_show_tolerance_property eq 0> style="display:none"</cfif>>
                        <input type="text" name="pro_tolerance#currentrow#" id="pro_tolerance#currentrow#" value="0" style="width:50px;"></td>
						<cfsavecontent variable="message"><cf_get_lang dictionary_id ='33933.Sayı Giriniz'></cfsavecontent>
						<td <cfif isdefined('is_show_property_amount') and is_show_property_amount eq 0> style="display:none"</cfif>><cfinput type="text" name="pro_amount#currentrow#" value="#TLFormat(1,4)#" onkeyup="return(FormatCurrency(this,event,4))" validate="float" message="#message#" style="width:50px" class="moneybox" onBlur="hesapla();"></td>
						<td <cfif isdefined('is_show_property_price') and is_show_property_price eq 0> style="display:none"</cfif>><input type="text" name="pro_total_amount#currentrow#" id="pro_total_amount#currentrow#" value="" onkeyup="return(FormatCurrency(this,event,4));" class="moneybox" style="width:80px" onBlur="hesapla();"></td>
						<td <cfif isdefined('is_show_property_price') and is_show_property_price eq 0> style="display:none"</cfif>><select name="pro_money_type#currentrow#" id="pro_money_type#currentrow#" style="width:50px;" onChange="hesapla();"><cfloop query="get_money"><option value="#rate1#,#rate2#,#money#">#money#</option></cfloop></select></td>
						<td <cfif isdefined('is_show_property_price') and is_show_property_price eq 0> style="display:none"</cfif>><input type="text" name="pro_sum_amount#currentrow#" id="pro_sum_amount#currentrow#" value="#TLFormat(0,4)#" onkeyup="return(FormatCurrency(this,event,4));" class="moneybox" style="width:80px" onBlur="hesapla();"></td>
						</td>
					</tr>
					</cfoutput>
			</table>
		</td>
	</tr>
	</cfif>
	<tr class="color-list"<cfif isdefined('attributes.add_main_spect')>style="display:none"</cfif>><!--- Eğer Main Spect Ekleme Sayfası olarak çalışacaksa,fiyatları göstermiyoruz,query sayfasında da kaydetmiycez....--->
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
									<td><input type="radio" name="rd_money" id="rd_money" value="#money#,#rate1#,#rate2#" onClick="hesapla();" <cfif money eq session.ep.money2 or money eq session.ep.money>checked</cfif>>#money#</td>
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
								<td class="color-header" style="text-align:right;"><cf_get_lang dictionary_id ='57492.Toplam'></td>
								<td  class="color-header" style="text-align:right;"><cf_get_lang dictionary_id='58124.Döviz Toplam'></td>
							</tr>
							<cfoutput>
							<tr class="color-list">
								<td  valign="top" nowrap style="text-align:right;"><input type="text" name="toplam_miktar" id="toplam_miktar" value="0" style="width:100px;" class="box" readonly=""><cfoutput>#session.ep.money#</cfoutput></td>
								<td  valign="top" style="text-align:right;"><input type="text" name="other_toplam" id="other_toplam" value="" style="width:100px;" class="box" readonly="">&nbsp;<input type="text" name="doviz_name" id="doviz_name" value="" style="width:50px;" class="box" readonly=""></td>
							</tr>
							</cfoutput>
						</table>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	</cfform>
</table>
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
			if((document.getElementById('tree_product_id'+r).selectedIndex>0 || document.getElementById('tree_product_id'+r).selectedIndex==undefined) && is_change!=1)is_change=1;
		//alert(toplam_deger);	
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
	if(opener.moneyArray!=undefined && opener.rate2Array!=undefined && opener.rate1Array!=undefined)
		for(var i=0;i<opener.moneyArray.length;i++)
			money=money+'&'+opener.moneyArray[i]+'='+parseFloat(opener.rate2Array[i]/opener.rate1Array[i]);
	else
		money=money+'<cfoutput query="get_money">&#get_money.money#=#get_money.rate2/get_money.rate1#</cfoutput>';
	if(opener.form_basket!=undefined && opener.form_basket.search_process_date!=undefined)
	    islem_tarih = window.opener.document.getElementById('search_process_date').value;
		windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_products&_spec_page_=2&update_product_row_id=0&<cfif isdefined("attributes.company_id")>company_id=#attributes.company_id#</cfif></cfoutput>&is_sale_product=1'+money+'&rowCount='+tree_row_count+'&search_process_date='+islem_tarih+'&sepet_process_type=-1&int_basket_id=<cfoutput>#attributes.basket_id#</cfoutput><cfif isdefined('attributes.unsalable')>&unsalable=1</cfif>&is_condition_sale_or_purchase=1','list');//is_price=1&is_price_other=1&is_cost=1&
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
	newCell.innerHTML = '<input type="text" name="tree_stock_code'+tree_row_count+'" id="tree_stock_code'+tree_row_count+'" value="'+stock_code+'" style="width:120px" readonly>';
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<div class="form-group mt-0"><div class="input-group col-12"><input type="text" name="tree_product_name'+tree_row_count+'" id="tree_product_name'+tree_row_count+'"  value="'+product_name+'" readonly><span class="input-group-addon btnPointer icon-ellipsis" onclick="open_product_detail('+product_id+','+stock_id+')"> </span></div></div>';
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
		newCell.innerHTML = '<input name="related_spect_main_id'+tree_row_count+'" id="related_spect_main_id'+tree_row_count+'" style="width:43px;" class="box" value="" readonly>';
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
		newCell.innerHTML = '<input type="text" name="tree_product_cost'+tree_row_count+'" id="tree_product_cost'+tree_row_count+'" value="'+commaSplit(net_maliyet,4)+'" readonly class="moneybox" style="width:50px">';//maliyet 
		//maliyet
	</cfif>
	//toplam miktar sistem para birimini tutar
	newCell = newRow.insertCell(newRow.cells.length);<cfif isdefined('is_show_price') and is_show_price eq 0>newCell.style.display='none';</cfif>
	newCell.innerHTML = '<input type="text" name="tree_std_money'+tree_row_count+'" id="tree_std_money'+tree_row_count+'" value="'+commaSplit(price,4)+'" class="moneybox" style="width:50px"><input type="hidden" name="reference_std_money'+tree_row_count+'" id="reference_std_money'+tree_row_count+'" value="'+commaSplit(price,4)+'"style="width:50px"><input type="hidden" name="old_tree_std_money'+tree_row_count+'" id="old_tree_std_money'+tree_row_count+'" value="'+commaSplit(price,4)+'" style="width:50px">';
	//toplam miktar
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
	var my_element=document.getElementById("tree_row_kontrol"+sy);
	my_element.value=0;
	var my_element=document.getElementById("tree_row"+sy);
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
	document.getElementById('tree_diff_price'+no).value = commaSplit(fark/urun_para_birimi,4);//seçilen ürünün para birimi  bazında fiyat farkı
	document.getElementById('tree_std_money'+no).value=commaSplit(price,4);//satırdaki fiyat yazdırılıyor(seçilen alternatif ürünün fiyatı YTL olarak)
	hesapla();
}
function kontrol()
{
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

