<cfif isdefined("fusebox.use_spect_company") and len(fusebox.use_spect_company)>
	<cfset new_dsn3 = "#dsn#_#fusebox.use_spect_company#">
	<cfset new_dsn3_alias = "#dsn#_#fusebox.use_spect_company#">
<cfelseif isdefined("dsn3")>
	<cfset new_dsn3 = dsn3>
	<cfset new_dsn3_alias = dsn3_alias>
</cfif>
<cfif isdefined('attributes.id')>
	<cfquery name="GET_SPECT" datasource="#new_dsn3#">
		SELECT * FROM SPECTS WHERE SPECT_VAR_ID = #attributes.id#
	</cfquery>
	<cfif GET_SPECT.RECORDCOUNT>
		<cfset attributes.stock_id=GET_SPECT.STOCK_ID>
		<cfset attributes.product_id=GET_SPECT.PRODUCT_ID>
	</cfif>
<cfelse>
	<cfset GET_SPECT.SPECT_TYPE = 1>	
	<cfquery name="GET_SPECT" datasource="#new_dsn3#">
		SELECT SPECT_MAIN_NAME AS SPECT_VAR_NAME,* FROM SPECT_MAIN AS SM 
		WHERE 
		<cfif isdefined("attributes.spect_main_id") and len(attributes.spect_main_id)>
			SM.SPECT_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.spect_main_id#">
		<cfelse>
			SM.STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.stock_id#"> AND SM.IS_TREE = 1 
		</cfif>
	</cfquery>
	<cfif GET_SPECT.RECORDCOUNT>
		<cfset attributes.stock_id=GET_SPECT.STOCK_ID>
		<cfset attributes.product_id=GET_SPECT.PRODUCT_ID>
	</cfif>
</cfif>
<cfquery name="get_product_info" datasource="#new_dsn3#">
	SELECT PRODUCT_NAME,PRODUCT_ID,IS_PROTOTYPE,IS_PRODUCTION FROM STOCKS WHERE STOCK_ID = #attributes.stock_id#
</cfquery>

<cfset spec_purchasesales = (isdefined('attributes.sepet_process_type') and ListFind("59,62,591,76,78,77,79,811,761",attributes.sepet_process_type)) ? 0 : 1 />

<cfquery name="GET_MONEY" datasource="#dsn#">
	SELECT PERIOD_ID,MONEY,RATE1,RATE2 FROM SETUP_MONEY WHERE PERIOD_ID = #session.ep.period_id# AND MONEY_STATUS = 1 AND COMPANY_ID = #session.ep.company_id#
</cfquery>
<cfquery name="GET_MONEY_2" dbtype="query">
	SELECT * FROM GET_MONEY WHERE MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money2#">
</cfquery>

<cfset url_str = "">
<cfset excludeList = "fuseaction,ajax,ajax_box_page,isAjax,draggable" />
<cfloop list="#cgi.QUERY_STRING#" index="param" delimiters="&">
    <cfset url_str &= not ListFindNoCase(excludeList, listFirst(param,"=")) ? "&" & param : "">
</cfloop>

<!--- belge tarihi varsa onun uzerinden fiyat bulunur yoksa now dan--->
<cfset attributes.search_process_date = attributes.search_process_date?:now() />

<cfif isdefined("attributes.stock_id") and len(attributes.stock_id)>
    <cfquery name="GET_PRODUCT" datasource="#DSN3#">
		SELECT 
			IS_PROTOTYPE,
			PRODUCT_NAME,
			PRODUCT_ID,
			STOCK_ID,
			PROPERTY,
			STOCK_CODE,
			BRAND_ID,
			PRODUCT_CATID
		FROM 
			STOCKS
		WHERE 
			STOCKS.STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.stock_id#">
	</cfquery>
	<cfquery name="GET_PRODUCT_IMAGE" datasource="#DSN3#" maxrows="1">
        SELECT PATH,PRODUCT_ID,PATH_SERVER_ID,DETAIL FROM PRODUCT_IMAGES WHERE IMAGE_SIZE = 2 AND PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_PRODUCT.product_id#"> ORDER BY PRODUCT_ID
    </cfquery>
    <cfset attributes.product_id = GET_PRODUCT.PRODUCT_ID>
	<cfset attributes.product_name = GET_PRODUCT.PRODUCT_NAME>
	<cfset product_id_list = get_product.product_id>
	<cfset tree_product_id_list = "">
<cfelse>
    <script type="text/javascript">
        alert("<cf_get_lang dictionary_id ='57725.Ürün Seçiniz'>!");
    </script>
    <cfabort>
</cfif>

<cfscript>
	_deep_level_main_stock_id_0 = attributes.stock_id;
	_deep_level_main_product_id_0 = GET_PRODUCT.product_id;
	_deep_level_main_product_name_0 = GET_PRODUCT.product_name;
    is_limited_stock =GET_SPECT.is_limited_stock;
    special_code_1 = GET_SPECT.special_code_1;
    special_code_2 = GET_SPECT.special_code_2;
    special_code_3 = GET_SPECT.special_code_3;
    special_code_4 = GET_SPECT.special_code_4;
    spec_name = GET_SPECT.SPECT_VAR_NAME;
    spec_name = replace(spec_name,',','','all');
    spec_name = replace(spec_name,'/','','all');
    spec_name = replace(spec_name,':','','all');
    _deep_level_main_product_name_0 = replace(_deep_level_main_product_name_0,',','','all');
    _deep_level_main_product_name_0 = replace(_deep_level_main_product_name_0,'/','','all');
    _deep_level_main_product_name_0 = replace(_deep_level_main_product_name_0,':','','all');
	main_spec_id_0 = GET_SPECT.spect_main_id;
</cfscript>

<cfif spec_purchasesales eq 1 and not (isdefined("attributes.price_catid") and len(attributes.price_catid))>
	<!--- uyenin fiyat listesini bulmak icin--->
	<cfif isdefined("attributes.company_id") and len(attributes.company_id)>
		<cfquery name="GET_PRICE_CAT_CREDIT" datasource="#DSN#">
			SELECT
				PRICE_CAT
			FROM
				COMPANY_CREDIT
			WHERE
				COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">  AND
				OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
		</cfquery>
		<cfif get_price_cat_credit.recordcount and len(get_price_cat_credit.price_cat)>
			<cfset attributes.price_catid=get_price_cat_credit.price_cat>
		<cfelse>
			<cfquery name="GET_COMP_CAT" datasource="#DSN#">
				SELECT COMPANYCAT_ID FROM COMPANY WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
			</cfquery>
			<cfquery name="GET_PRICE_CAT_COMP" datasource="#new_dsn3#">
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
		<cfquery name="GET_PRICE_CAT" datasource="#new_dsn3#">
			SELECT PRICE_CATID FROM PRICE_CAT WHERE CONSUMER_CAT LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#get_comp_cat.consumer_cat_id#,%">
		</cfquery>
		<cfset attributes.price_catid=get_price_cat.price_catid>
	</cfif>
</cfif>

<cfif isdefined("attributes.price_catid") and len(attributes.price_catid)>	
	<cfquery name="GET_PRICE" datasource="#DSN3#">
		SELECT
			PRICE_STANDART.PRODUCT_ID,
			SM.MONEY,
			PRICE_STANDART.PRICE,
			PRICE_STANDART.PRICE_KDV,
			PRICE_STANDART.MONEY OTHER_MONEY,
			(PRICE_STANDART.PRICE*(SM.RATE2/SM.RATE1)) AS PRICE_STDMONEY,
			(PRICE_STANDART.PRICE_KDV*(SM.RATE2/SM.RATE1)) AS PRICE_KDV_STDMONEY,
			SM.RATE2,
			SM.RATE1,
			0 AS IS_GIFT_CARD
		FROM
			PRICE PRICE_STANDART,	
			PRODUCT_UNIT,
			#dsn#.SETUP_MONEY AS SM
		WHERE
			PRICE_STANDART.PRICE_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.price_catid#"> AND
			ISNULL(PRICE_STANDART.STOCK_ID,0) = 0 AND
			ISNULL(PRICE_STANDART.SPECT_VAR_ID,0) = 0 AND
			PRICE_STANDART.STARTDATE < #now()# AND 
			(PRICE_STANDART.FINISHDATE >= #now()# OR PRICE_STANDART.FINISHDATE IS NULL) AND
			PRODUCT_UNIT.PRODUCT_ID = PRICE_STANDART.PRODUCT_ID AND 
			PRICE_STANDART.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#_deep_level_main_product_id_0#"> AND 
			PRODUCT_UNIT.IS_MAIN = 1 AND
			<cfif session.ep.period_year lt 2009>
				((SM.MONEY = PRICE_STANDART.MONEY) OR (SM.MONEY = 'YTL') AND PRICE_STANDART.MONEY = 'TL') AND
			<cfelse>
				SM.MONEY = PRICE_STANDART.MONEY AND
			</cfif>
			SM.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">
	</cfquery>
<cfelse>
	<cfquery name="GET_PRICE" datasource="#DSN3#">
		SELECT
			PRICE_STANDART.PRODUCT_ID,
			SM.MONEY,
			PRICE_STANDART.PRICE,
			PRICE_STANDART.PRICE_KDV,
			PRICE_STANDART.MONEY OTHER_MONEY,
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
				<cfif session.ep.period_year lt 2009>
				((SM.MONEY = PRICE_STANDART.MONEY) OR (SM.MONEY = 'YTL') AND PRICE_STANDART.MONEY = 'TL') AND
			<cfelse>
				SM.MONEY = PRICE_STANDART.MONEY AND
			</cfif>
			SM.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#"> AND
			PRODUCT.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#_deep_level_main_product_id_0#">
	</cfquery>
</cfif>


<cfif attributes.type eq 'upd'>
	<cfquery name="GET_MONEY" datasource="#dsn3#">
		SELECT MONEY_TYPE MONEY, RATE1, RATE2, IS_SELECTED FROM SPECT_MONEY
		WHERE ACTION_ID = <cfqueryparam value="#attributes.id#" cfsqltype="cf_sql_integer">
		ORDER BY MONEY_TYPE
	</cfquery>

	<cfif GET_MONEY.recordcount eq 0 or GET_MONEY.rate2 eq 0>
		<cfquery name="GET_MONEY" datasource="#dsn2#">
			SELECT MONEY, RATE1, RATE2, 0 IS_SELECTED FROM SETUP_MONEY
		</cfquery>
	</cfif>
	<cfif isdefined('attributes.id')>
	<cfif GET_SPECT.PRODUCT_AMOUNT_CURRENCY is 'TL' and session.ep.period_year lt 2009>
		<cfset GET_SPECT.PRODUCT_AMOUNT_CURRENCY = 'YTL'>
	</cfif>
	</cfif>
	<cfquery name="GET_MAIN_PRICE" dbtype="query">
		SELECT RATE2, RATE1 FROM GET_MONEY WHERE 
		<cfif not isdefined('GET_SPECT.PRODUCT_AMOUNT_CURRENCY') or (GET_SPECT.PRODUCT_AMOUNT_CURRENCY is 'YTL' or GET_SPECT.PRODUCT_AMOUNT_CURRENCY is 'TL')>
			MONEY = 'YTL' or MONEY = 'TL'
		<cfelse>
		MONEY = '#GET_SPECT.PRODUCT_AMOUNT_CURRENCY#'
		</cfif>
	</cfquery>
	<cfif not GET_MAIN_PRICE.recordcount and GET_SPECT.PRODUCT_AMOUNT_CURRENCY is 'TL'>
		<cfquery name="GET_MAIN_PRICE" dbtype="query">
			SELECT RATE2, RATE1 FROM GET_MONEY WHERE MONEY = 'YTL'
		</cfquery>
	</cfif>
	<cfquery name="get_money_2" dbtype="query">
		SELECT * FROM GET_MONEY WHERE MONEY = '#session.ep.money2#'
	</cfquery>
</cfif>