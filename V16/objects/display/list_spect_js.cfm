<!--- Bu blok aşağıda değerler oluştuktan sonra submit oluyor. --->
<script type="text/javascript">
function setToBasket(id,name_,price,other_price,money_type,prod_cost,main_id)
{
	<cfif isdefined("attributes.field_id")>
		<cfif not isDefined("attributes.draggable")>opener<cfelse>document</cfif>.<cfoutput>#attributes.field_id#</cfoutput>.value = id;
	</cfif>
	<cfif isdefined("attributes.field_main_id")>//Main spect id atmak için
		<cfif not isDefined("attributes.draggable")>opener<cfelse>document</cfif>.<cfoutput>#attributes.field_main_id#</cfoutput>.value = main_id;
	</cfif>
	<cfif isdefined("attributes.field_name")>
		<cfif not isDefined("attributes.draggable")>opener<cfelse>document</cfif>.<cfoutput>#attributes.field_name#</cfoutput>.value = name_;
	</cfif>
 	<cfif isdefined("attributes.basket") >
		<cfif not isDefined("attributes.draggable")>opener.</cfif>clear_fields();/* kalsın erk 20031106*/
		<cfif not isDefined("attributes.draggable")>opener<cfelse>document</cfif>.form_basket.submit();
	</cfif>
	<cfif isdefined("attributes.is_refresh") and isdefined("attributes.form_name")>
		<cfif not isDefined("attributes.draggable")>opener<cfelse>document</cfif>.<cfoutput>#form_name#</cfoutput>.submit();
	</cfif>
	<cfif isdefined("attributes.row_id") and len(attributes.row_id)>
		var satir = <cfoutput>#attributes.row_id#</cfoutput>;
	<cfelse>
		var satir = -1;
	</cfif>
	if(<cfif not isDefined("attributes.draggable")>window.opener.</cfif>basket && satir > -1) 
	{
		
		<cfif not isDefined("attributes.draggable")>window.opener.</cfif>updateBasketItemFromPopup(satir, 
		{ 
		<cfoutput>
			SPECT_ID: id, 
			SPECT_NAME: name_ 
			<cfif (isdefined("attributes.price_change") and attributes.price_change eq 1) or isdefined("attributes.x_is_basket_price") and attributes.x_is_basket_price eq 1 and isdefined("attributes.price") and len(attributes.price)><!--- fiyat guncellenecekse --->
				,PRICE: commaSplit(price,4)
				,PRICE_OTHER: commaSplit(other_price,2);
				,OTHER_MONEY: '<cfif len(money_type)>money_type<cfelse>#session.ep.money#</cfif>'
				,NET_MALIYET: #commaSplit(prod_cost,4)#
			</cfif> 
		</cfoutput> 
		}); 
		<cfif (isdefined("attributes.price_change") and attributes.price_change eq 1) or isdefined("attributes.x_is_basket_price") and attributes.x_is_basket_price eq 1 and isdefined("attributes.price") and len(attributes.price)><!--- fiyat guncellenecekse --->
			<cfif not isDefined("attributes.draggable")>opener.</cfif>hesapla('Price','<cfoutput>#attributes.row_id#</cfoutput>');
		</cfif>
		
	}
	<cfif isDefined("attributes.draggable") and isDefined("attributes.modal_id")>closeBoxDraggable('<cfoutput>#attributes.modal_id#</cfoutput>')<cfelse>window.close()</cfif>;	
}
</script>
<cfset toplam_fiyat=0>
<cfset toplam_spect_maliyet=0>
<cfset toplam_fiyat_other=0>
<cfset main_product_money=session.ep.money>
<cfquery name="GET_SPECT" datasource="#dsn3#">
	SELECT STOCK_ID,PRODUCT_ID,OTHER_MONEY_CURRENCY,SPECT_VAR_NAME,SPECT_TYPE FROM SPECTS WHERE SPECT_VAR_ID = #attributes.spect_id#
</cfquery>
<cfset my_spect_name = replace(GET_SPECT.SPECT_VAR_NAME,"'","","all")>
<cfset my_spect_name = replace(my_spect_name,'"','','all')>
<cfset my_spect_name = replace(my_spect_name,'#chr(13)#','','all')>
<cfset my_spect_name = replace(my_spect_name,'#chr(10)#','','all')>
<cfif isdefined("attributes.x_is_basket_price") and attributes.x_is_basket_price eq 1 and isdefined("attributes.price") and len(attributes.price)>
	<cfset toplam_fiyat = attributes.price>
<cfelseif isdefined("attributes.row_id") and isdefined("attributes.price_change") and attributes.price_change eq 1><!---fiyat degistir secili degil ve link basketten gelmedi ise yani fiyat vs atmayacaksa girmesine gerek yok--->
	<cfif isdefined("attributes.search_process_date") and len(attributes.search_process_date)>
		<cf_date tarih="attributes.search_process_date">
	<cfelse>
		<cfset attributes.search_process_date=now()>
	</cfif>
	<cfquery name="GET_MONEY" datasource="#dsn#">
		SELECT	MONEY,RATE1,RATE2 FROM SETUP_MONEY WHERE PERIOD_ID = #session.ep.period_id# AND MONEY_STATUS = 1 AND COMPANY_ID = #SESSION.EP.COMPANY_ID#
	</cfquery>
	<cfset attributes.stock_id=GET_SPECT.STOCK_ID>
	<cfset attributes.product_id=GET_SPECT.PRODUCT_ID>
	<cfset toplam_fark=0>
	<cfset toplam_ozel=0>
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
			<cfset attributes.price_catid=GET_PRICE_CAT_COMP.PRICE_CATID>
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
	<cfif isdefined("attributes.stock_id") and len(attributes.stock_id)>
		<cfif isdefined("attributes.price_catid") and len(attributes.price_catid)>
			<cfquery name="GET_PRICE_MAIN" datasource="#dsn3#">
				SELECT
					PRICE_STANDART.PRODUCT_ID,
					PRICE_STANDART.MONEY,
					PRICE_STANDART.PRICE
				FROM
					PRICE PRICE_STANDART,	
					PRODUCT_UNIT
				WHERE
					PRICE_STANDART.PRICE_CATID=#attributes.price_catid# AND
					PRICE_STANDART.STARTDATE< #attributes.search_process_date# AND 
					(PRICE_STANDART.FINISHDATE >= #attributes.search_process_date# OR PRICE_STANDART.FINISHDATE IS NULL) AND
					PRODUCT_UNIT.PRODUCT_ID = PRICE_STANDART.PRODUCT_ID AND 
					PRICE_STANDART.PRODUCT_ID = #attributes.product_id# AND 
					ISNULL(PRICE_STANDART.STOCK_ID,0)=0 AND
					ISNULL(PRICE_STANDART.SPECT_VAR_ID,0)=0 AND
					PRODUCT_UNIT.IS_MAIN = 1
			</cfquery>
		</cfif>
		<cfif not isdefined("GET_PRICE_MAIN") or not GET_PRICE_MAIN.RECORDCOUNT>
			<cfquery name="GET_PRICE_MAIN" datasource="#dsn3#">
				SELECT
					PRICE_STANDART.PRODUCT_ID,
					PRICE_STANDART.MONEY,
					PRICE_STANDART.PRICE
				FROM
					PRODUCT,
					PRICE_STANDART
				WHERE
					PRODUCT.PRODUCT_ID = PRICE_STANDART.PRODUCT_ID AND
					PURCHASESALES = 1 AND
					PRICESTANDART_STATUS = 1 AND
					PRODUCT.PRODUCT_ID=#attributes.product_id#
			</cfquery>
		</cfif>
	</cfif>
	<cfset main_product_money= GET_PRICE_MAIN.MONEY>
	<cfif session.ep.period_year gt 2008 and main_product_money is 'YTL'><cfset main_product_money = 'TL'></cfif>
    <cfif session.ep.period_year lt 2009 and main_product_money is 'TL'><cfset main_product_money = 'YTL'></cfif>
	<cfif main_product_money neq session.ep.money>
		<cfset PRICE_STDMONEY=GET_PRICE_MAIN.PRICE*#evaluate('attributes.#main_product_money#')#>
	<cfelse>
		<cfset PRICE_STDMONEY=GET_PRICE_MAIN.PRICE>
	</cfif>
	<cfquery name="GET_SPECT_ROW" datasource="#dsn3#">
		SELECT
			AMOUNT_VALUE AS AMOUNT,
			STOCK_ID,
			(SELECT S.PRODUCT_ID FROM STOCKS S WHERE S.STOCK_ID = SPECTS_ROW.STOCK_ID) PRODUCT_ID,
			DIFF_PRICE,
			TOTAL_VALUE,
			IS_PROPERTY
		FROM 
			SPECTS_ROW
		WHERE 
			SPECT_ID=#attributes.spect_id#
	</cfquery>
	<cfif GET_SPECT.SPECT_TYPE neq 3 and GET_SPECT.SPECT_TYPE neq 6 >
		<cfoutput query="GET_SPECT_ROW">	
			<cfif IS_PROPERTY eq 1><!--- Özellik ise ---><!--- <cfif IS_PROPERTY neq 1>--->
				<cfset toplam_fark=toplam_fark+DIFF_PRICE>
			<cfelseif IS_PROPERTY eq 0><!--- Sarf ise --->
				<cfif isdefined("attributes.price_catid") and len(attributes.price_catid)>
					<cfquery name="GET_PRICE" datasource="#dsn3#">
						SELECT
							PRICE_STANDART.PRODUCT_ID,
							PRICE_STANDART.MONEY,
							PRICE_STANDART.PRICE
						FROM
							PRICE PRICE_STANDART,	
							PRODUCT_UNIT
						WHERE
							PRICE_STANDART.PRICE_CATID=#attributes.price_catid# AND
							PRICE_STANDART.STARTDATE< #attributes.search_process_date# AND 
							(PRICE_STANDART.FINISHDATE >= #attributes.search_process_date# OR PRICE_STANDART.FINISHDATE IS NULL) AND
							PRODUCT_UNIT.PRODUCT_ID = PRICE_STANDART.PRODUCT_ID AND 
							PRICE_STANDART.PRODUCT_ID = #GET_SPECT_ROW.PRODUCT_ID# AND 
							PRODUCT_UNIT.IS_MAIN = 1
					</cfquery>
				</cfif>
				<cfif not isdefined("GET_PRICE") or (isQuery(get_price) and not GET_PRICE.RECORDCOUNT)>
					<cfquery name="GET_PRICE" datasource="#dsn3#">
						SELECT
							PRICE_STANDART.PRODUCT_ID,
							PRICE_STANDART.MONEY,
							PRICE_STANDART.PRICE
						FROM
							PRODUCT,
							PRICE_STANDART
						WHERE
							PRODUCT.PRODUCT_ID = PRICE_STANDART.PRODUCT_ID AND
							PURCHASESALES = 1 AND
							PRICESTANDART_STATUS = 1 AND
							PRODUCT.PRODUCT_ID=#PRODUCT_ID#
					</cfquery>
				</cfif>
				<cfset _money_ = GET_PRICE.money>
				<cfif session.ep.period_year gt 2008 and _money_ is 'YTL'><cfset _money_ = 'TL'></cfif>
                <cfif session.ep.period_year lt 2009 and _money_ is 'TL'><cfset  _money_ = 'YTL'></cfif>
				<cfset toplam_ozel=toplam_ozel+GET_PRICE.PRICE*evaluate('#_money_#')>
			</cfif>
		</cfoutput>
		<cfif GET_SPECT.OTHER_MONEY_CURRENCY neq session.ep.money and toplam_fark neq 0>
			<cfset toplam_fark=toplam_fark*evaluate('#GET_SPECT.OTHER_MONEY_CURRENCY#')>
		</cfif>
		<cfset toplam_fiyat=PRICE_STDMONEY+toplam_fark+toplam_ozel>
		<cfset toplam_fiyat_other=toplam_fiyat/evaluate('#main_product_money#')>
		<cfset toplam_spect_maliyet=0>
		<!--- <cfquery name="GET_SPECT_ROW_ALL" datasource="#dsn3#">
			SELECT 
				STOCK_ID,
				PRODUCT_ID,
				AMOUNT_VALUE AMOUNT
			FROM 
				SPECTS_ROW
			WHERE 
				SPECT_ID=#attributes.spect_id#
		</cfquery> --->
		<!--- <cfoutput query="GET_SPECT_ROW_ALL">
			<cfquery name="GET_COST" datasource="#dsn3#" maxrows="1">
				SELECT  
					PRODUCT_COST,
					PRODUCT_COST_ID,
					MONEY
				FROM
					#dsn1_alias#.PRODUCT_COST
				WHERE    
					PRODUCT_ID = #PRODUCT_ID# AND
					START_DATE <= #attributes.search_process_date#
				ORDER BY
					START_DATE DESC,
					RECORD_DATE DESC
			</cfquery>
			<cfif len(GET_COST.PRODUCT_COST)><cfset satir_maliyet=GET_COST.PRODUCT_COST><cfelse><cfset satir_maliyet=0></cfif>
		
			<cfif len(GET_COST.MONEY) and isdefined('main_product_money') and main_product_money neq GET_COST.MONEY>
				
				<cfquery name="GET_ROW_MONEY_COST" dbtype="query">
					SELECT	MONEY,RATE2 RATE FROM GET_MONEY WHERE MONEY='#GET_COST.MONEY#'
				</cfquery>
				<cfset satir_maliyet=satir_maliyet*GET_ROW_MONEY_COST.RATE>
				<cfif main_product_money neq session.ep.money>
					<cfquery name="GET_ROW_MONEY_COST_2" dbtype="query">
						SELECT	MONEY,RATE2 RATE FROM GET_MONEY WHERE MONEY=<cfif isdefined('main_product_money') and len(main_product_money)>'#main_product_money#'<cfelse>'#session.ep.money#'</cfif>
					</cfquery>
					<cfif GET_ROW_MONEY_COST_2.RECORDCOUNT>
						<cfset satir_maliyet=satir_maliyet/GET_ROW_MONEY_COST_2.RATE>
					</cfif>
				</cfif>
			</cfif>
			<cfif AMOUNT gt 1>
				<cfset satir_maliyet=satir_maliyet*AMOUNT>
			</cfif>
			<cfset toplam_spect_maliyet=toplam_spect_maliyet+satir_maliyet>
		</cfoutput> --->
		<cfoutput query="GET_SPECT_ROW">
			<cfif not len(PRODUCT_ID)><!--- IS_PROPERTY eq 1 OR IS_PROPERTY eq 3 OR (IS_PROPERTY eq 4 and not len())öZELİK İSE --->
				<cfset GET_COST.PRODUCT_COST = ''>
				<cfset GET_COST.MONEY = ''>
			<cfelseif len(PRODUCT_ID)><!--- SARF İSE --->
				<cfquery name="GET_COST" datasource="#dsn3#" maxrows="1">
					SELECT  
						PRODUCT_COST,
						PRODUCT_COST_ID,
						MONEY,
                        START_DATE
					FROM
						#dsn1_alias#.PRODUCT_COST
					WHERE    
						PRODUCT_ID = #PRODUCT_ID# AND
						START_DATE <= #attributes.search_process_date#
					ORDER BY
						START_DATE DESC,
						RECORD_DATE DESC
				</cfquery>
               <cfif session.ep.period_year gt 2008 and GET_COST.MONEY is 'YTL'><!--- 1 sene sonra kaldırılmalı! --->
					<cfset GET_COST.MONEY = 'TL'>
				</cfif>
			</cfif>
			<cfif isdefined("GET_COST") and len(GET_COST.PRODUCT_COST)><cfset satir_maliyet=GET_COST.PRODUCT_COST><cfelse><cfset satir_maliyet=0></cfif>
			<cfif isdefined("GET_COST") and len(GET_COST.MONEY) and isdefined('main_product_money') and main_product_money neq GET_COST.MONEY>
				<!--- ana urun fiyatla satir maliyet para birimi farkli ise once ana para birimine ordanda ana urun fiyat cinsine cevirir--->
				<cfif session.ep.period_year gt 2008 and GET_COST.MONEY is 'YTL'><cfset GET_COST.MONEY = 'TL'></cfif>
                <cfif session.ep.period_year lt 2009 and GET_COST.MONEY is 'TL'><cfset  GET_COST.MONEY = 'YTL'></cfif>
                <cfquery name="GET_ROW_MONEY_COST" dbtype="query">
					SELECT	MONEY,RATE2 RATE FROM GET_MONEY WHERE MONEY='#GET_COST.MONEY#'
				</cfquery>
				<cfset satir_maliyet=satir_maliyet*GET_ROW_MONEY_COST.RATE>
				<cfif main_product_money neq session.ep.money>
					<cfquery name="GET_ROW_MONEY_COST_2" dbtype="query">
						SELECT	MONEY,RATE2 RATE FROM GET_MONEY WHERE MONEY=<cfif isdefined('main_product_money') and len(main_product_money)>'#main_product_money#'<cfelse>'#session.ep.money#'</cfif>
					</cfquery>
					<cfif GET_ROW_MONEY_COST_2.RECORDCOUNT>
						<cfset satir_maliyet=satir_maliyet/GET_ROW_MONEY_COST_2.RATE>
					</cfif>
				</cfif>
			</cfif>
			<cfif AMOUNT gt 1>
				<cfset satir_maliyet=satir_maliyet*AMOUNT>
			</cfif>
			<cfset toplam_spect_maliyet=toplam_spect_maliyet+satir_maliyet>
		</cfoutput>
		<!--- baskete atmak icin ytl cinsinden olmali--->
		<cfif toplam_spect_maliyet GT 0>
			<cfquery name="GET_PRODUCT_COST" datasource="#dsn2#" maxrows="1">
				SELECT 
					#toplam_spect_maliyet#* (SM.RATE2 / SM.RATE1) SPECT_COST
				FROM 
					SETUP_MONEY SM
				WHERE
					SM.MONEY = '#main_product_money#'
			</cfquery>
			<cfif GET_PRODUCT_COST.RECORDCOUNT>
				<cfset toplam_spect_maliyet=GET_PRODUCT_COST.SPECT_COST>
			</cfif>
		</cfif>
		
	<cfelse>
		<cfoutput query="GET_SPECT_ROW">
			<cfset toplam_fiyat=TOTAL_VALUE+toplam_fiyat>
		</cfoutput>
	</cfif>
</cfif>
<script type="text/javascript">
	<cfoutput>setToBasket('#attributes.spect_id#','#my_spect_name#','#toplam_fiyat#','#toplam_fiyat_other#','#main_product_money#','#toplam_spect_maliyet#'<cfif isdefined('attributes.field_main_id')>,'#attributes.spect_main_id#'</cfif>);</cfoutput>
</script>
