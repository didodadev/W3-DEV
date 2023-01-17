<cffunction name="get_cost_info" returntype="string" output="false">
<!---
	by : TolgaS 20061110
	notes : 
		.....URUN, SPEC VEYA AGAC MALIYETINI LISTE SEKLINDE PURCHASE_NET_SYSTEM PARA TURUNDEN BULUR .....
	usage :
	sadece main_spec_id den degerler alinarak kaydedilecekse
		get_cost_info(
				stock_id: ,
				main_spec_id: ,
				spec_id: ,
				cost_date: ,
				is_purchasesales:
			);
	--->
	<cfargument name="stock_id" type="numeric" required="yes"><!--- maliyeti bulunacak stock_id stock_id cunku stock_id bazında agac--->
	<cfargument name="main_spec_id" type="numeric" required="no"><!--- main_spec id icerigine gore maliyeti bulur bu deger varsa spec_id gerek yok --->
	<cfargument name="spec_id" type="numeric" required="no"><!--- spec_id bundan maın_spec_id bulunarak maliyeti hesaplanır --->
	<cfargument name="cost_date" type="date" required="no" default="#now()#"><!--- maliyet bulunacak tarih --->
	<cfargument name="dsn_type" type="string" required="no" default="#dsn3#"><!--- olurda cftransaction icinde olursa diye dsn yollansın --->
	<cfargument name="is_purchasesales" type="boolean" required="no" default="1"><!--- alis (0) veya satis(1) tipi. alis tipinde alis fiyatini getirir --->

	<cfif not len(arguments.cost_date) gt 9><cfset arguments.cost_date=now()></cfif>
	<cf_date tarih='cost_date'>
	<cfscript>
	maliyet_id=0;
	toplam_maliyet_sistem = 0;
	toplam_maliyet_extra_sistem = 0;
	GET_PROD=cfquery(SQLString:'SELECT IS_COST,PRODUCT_ID FROM #dsn3_alias#.STOCKS STOCKS WHERE STOCK_ID = #arguments.stock_id#',Datasource:'#dsn_type#',is_select:1);
	if(len(GET_PROD.IS_COST) and GET_PROD.IS_COST eq 1)
	{
		if(is_purchasesales eq 1)
		{
			if(isdefined('arguments.spec_id') and len(arguments.spec_id))
			{
				GET_MAIN_SPEC=cfquery(SQLString:'SELECT SPECT_MAIN_ID FROM SPECTS WHERE SPECT_VAR_ID=#arguments.spec_id#',Datasource:'#dsn_type#',is_select:1);
				if(GET_MAIN_SPEC.RECORDCOUNT) arguments.main_spec_id=GET_MAIN_SPEC.SPECT_MAIN_ID;
			}
			if(isdefined('arguments.main_spec_id') and len(arguments.main_spec_id))
			{
				GET_SPEC_ROW=cfquery(SQLString:'SELECT PRODUCT_ID, STOCK_ID, AMOUNT FROM SPECT_MAIN_ROW WHERE SPECT_MAIN_ID=#arguments.main_spec_id# AND PRODUCT_ID IS NOT NULL AND IS_PROPERTY=0',Datasource:'#dsn_type#',is_select:1);//sadece sarfları aldık fireler maliyette etki etmeyecek diye düsünüldü ama degise bilir
				cost_info_product_list=listsort(valuelist(GET_SPEC_ROW.PRODUCT_ID,','),'Numeric');
				if(listlen(cost_info_product_list) eq 0)cost_info_product_list=0;
				GET_COST_ALL=cfquery(SQLString:'SELECT PRODUCT_ID, PRODUCT_COST, PRODUCT_COST_ID,MONEY, PURCHASE_NET_SYSTEM, PURCHASE_EXTRA_COST_SYSTEM, START_DATE, RECORD_DATE FROM #dsn3_alias#.PRODUCT_COST PRODUCT_COST WHERE START_DATE <= #arguments.cost_date# AND PRODUCT_ID IN(#cost_info_product_list#)',Datasource:'#dsn_type#',is_select:1);
				for(ww=1;ww lte GET_SPEC_ROW.RECORDCOUNT;ww=ww+1)
				{
					GET_TREE=cfquery(SQLString:"SELECT PRODUCT_TREE.RELATED_ID,PRODUCT_TREE.AMOUNT,STOCKS.PRODUCT_ID FROM PRODUCT_TREE,STOCKS WHERE PRODUCT_TREE.PRODUCT_ID IS NOT NULL AND PRODUCT_TREE.STOCK_ID = #evaluate('GET_SPEC_ROW.STOCK_ID[#ww#]')# AND PRODUCT_TREE.STOCK_ID=STOCKS.STOCK_ID AND STOCKS.IS_PRODUCTION=1",Datasource:"#dsn_type#",is_select:1);
					if(GET_TREE.RECORDCOUNT)
					{
						for(ss=1;ss lte GET_TREE.RECORDCOUNT;ss=ss+1)
						{
							GET_COST=cfquery(SQLString:'SELECT PRODUCT_COST, PRODUCT_COST_ID,MONEY, PURCHASE_NET_SYSTEM, PURCHASE_EXTRA_COST_SYSTEM FROM GET_COST_ALL WHERE PRODUCT_ID = #evaluate('GET_TREE.PRODUCT_ID[#ss#]')# ORDER BY START_DATE DESC,RECORD_DATE DESC,PRODUCT_COST_ID DESC',Datasource:'',dbtype='query',is_select:1);
							if(len(GET_COST.PURCHASE_NET_SYSTEM))toplam_maliyet_sistem=toplam_maliyet_sistem+(GET_COST.PURCHASE_NET_SYSTEM * evaluate('GET_SPEC_ROW.AMOUNT[#ww#]') * evaluate('GET_TREE.AMOUNT[#ss#]'));
							if(len(GET_COST.PURCHASE_EXTRA_COST_SYSTEM))toplam_maliyet_extra_sistem=toplam_maliyet_extra_sistem+(GET_COST.PURCHASE_EXTRA_COST_SYSTEM * evaluate('GET_SPEC_ROW.AMOUNT[#ww#]') * evaluate('GET_TREE.AMOUNT[#ss#]'));
						}
					}else
					{
						GET_COST=cfquery(SQLString:'SELECT PRODUCT_COST, PRODUCT_COST_ID,MONEY, PURCHASE_NET_SYSTEM, PURCHASE_EXTRA_COST_SYSTEM FROM GET_COST_ALL WHERE PRODUCT_ID = #evaluate('GET_SPEC_ROW.PRODUCT_ID[#ww#]')# ORDER BY START_DATE DESC,RECORD_DATE DESC,PRODUCT_COST_ID DESC',Datasource:'',dbtype='query',is_select:1);
						if(len(GET_COST.PURCHASE_NET_SYSTEM))toplam_maliyet_sistem=toplam_maliyet_sistem+(GET_COST.PURCHASE_NET_SYSTEM* evaluate('GET_SPEC_ROW.AMOUNT[#ww#]'));
						if(len(GET_COST.PURCHASE_EXTRA_COST_SYSTEM))toplam_maliyet_extra_sistem=toplam_maliyet_extra_sistem+(GET_COST.PURCHASE_EXTRA_COST_SYSTEM*evaluate('GET_SPEC_ROW.AMOUNT[#ww#]'));
					}
				}
			}
			else
			{
				GET_TREE_PROD=cfquery(SQLString:"SELECT PRODUCT_TREE.RELATED_ID STOCK_ID,PRODUCT_TREE.AMOUNT,STOCKS.PRODUCT_ID FROM PRODUCT_TREE,STOCKS WHERE PRODUCT_TREE.PRODUCT_ID IS NOT NULL AND PRODUCT_TREE.STOCK_ID = #arguments.stock_id# AND PRODUCT_TREE.RELATED_ID=STOCKS.STOCK_ID",Datasource:"#dsn_type#",is_select:1);
				if(GET_TREE_PROD.RECORDCOUNT)
				{
					cost_info_product_list=listsort(valuelist(GET_TREE_PROD.PRODUCT_ID,','),'Numeric');
					GET_COST_ALL=cfquery(SQLString:'SELECT PRODUCT_ID, PRODUCT_COST, PRODUCT_COST_ID,MONEY, PURCHASE_NET_SYSTEM, PURCHASE_EXTRA_COST_SYSTEM, START_DATE, RECORD_DATE FROM #dsn3_alias#.PRODUCT_COST PRODUCT_COST WHERE START_DATE <= #arguments.cost_date# AND PRODUCT_ID IN(#cost_info_product_list#)',Datasource:'#dsn_type#',is_select:1);
					for(ww=1;ww lte GET_TREE_PROD.RECORDCOUNT;ww=ww+1)
					{
						GET_TREE=cfquery(SQLString:"SELECT PRODUCT_TREE.RELATED_ID,PRODUCT_TREE.AMOUNT,STOCKS.PRODUCT_ID FROM PRODUCT_TREE,STOCKS WHERE PRODUCT_TREE.PRODUCT_ID IS NOT NULL AND PRODUCT_TREE.STOCK_ID = #evaluate('GET_TREE_PROD.STOCK_ID[#ww#]')# AND PRODUCT_TREE.STOCK_ID=STOCKS.STOCK_ID",Datasource:"#dsn_type#",is_select:1);
						if(GET_TREE.RECORDCOUNT)
						{
							for(ss=1;ss lte GET_TREE.RECORDCOUNT;ss=ss+1)
							{
								GET_COST=cfquery(SQLString:'SELECT PRODUCT_COST, PRODUCT_COST_ID,MONEY, PURCHASE_NET_SYSTEM, PURCHASE_EXTRA_COST_SYSTEM FROM GET_COST_ALL WHERE PRODUCT_ID = #evaluate('GET_TREE.PRODUCT_ID[#ss#]')# ORDER BY START_DATE DESC,RECORD_DATE DESC,PRODUCT_COST_ID DESC',Datasource:'#dsn_type#',dbtype:'query',is_select:1);
								if(len(GET_COST.PURCHASE_NET_SYSTEM))toplam_maliyet_sistem=toplam_maliyet_sistem+(GET_COST.PURCHASE_NET_SYSTEM * evaluate('GET_TREE_PROD.AMOUNT[#ww#]') * evaluate('GET_TREE.AMOUNT[#ss#]'));
								if(len(GET_COST.PURCHASE_EXTRA_COST_SYSTEM))toplam_maliyet_extra_sistem=toplam_maliyet_extra_sistem+(GET_COST.PURCHASE_EXTRA_COST_SYSTEM * evaluate('GET_TREE_PROD.AMOUNT[#ww#]') * evaluate('GET_TREE.AMOUNT[#ss#]'));
							}
						}else
						{
							GET_COST=cfquery(SQLString:'SELECT PRODUCT_COST, PRODUCT_COST_ID,MONEY, PURCHASE_NET_SYSTEM, PURCHASE_EXTRA_COST_SYSTEM FROM GET_COST_ALL WHERE PRODUCT_ID = #evaluate('GET_TREE_PROD.PRODUCT_ID[#ww#]')# ORDER BY START_DATE DESC,RECORD_DATE DESC,PRODUCT_COST_ID DESC',Datasource:'#dsn_type#',dbtype:'query',is_select:1);
							if(len(GET_COST.PURCHASE_NET_SYSTEM))toplam_maliyet_sistem=toplam_maliyet_sistem+(GET_COST.PURCHASE_NET_SYSTEM * evaluate('GET_TREE_PROD.AMOUNT[#ww#]'));
							if(len(GET_COST.PURCHASE_EXTRA_COST_SYSTEM))toplam_maliyet_extra_sistem=toplam_maliyet_extra_sistem+(GET_COST.PURCHASE_EXTRA_COST_SYSTEM * evaluate('GET_TREE_PROD.AMOUNT[#ww#]'));
						}
					}
				
				}else
				{
					//GET_PROD=cfquery(SQLString:'SELECT PRODUCT_ID FROM #dsn3_alias#.STOCKS STOCKS WHERE STOCK_ID = #arguments.stock_id#',Datasource:'#dsn_type#',is_select:1);
					if(GET_PROD.RECORDCOUNT)
					{
						GET_COST=cfquery(SQLString:'SELECT PRODUCT_ID, PRODUCT_COST, PRODUCT_COST_ID,MONEY, PURCHASE_NET_SYSTEM, PURCHASE_EXTRA_COST_SYSTEM, START_DATE, RECORD_DATE FROM #dsn3_alias#.PRODUCT_COST PRODUCT_COST WHERE START_DATE <= #arguments.cost_date# AND PRODUCT_ID = #GET_PROD.PRODUCT_ID# ORDER BY START_DATE DESC,RECORD_DATE DESC,PRODUCT_COST_ID DESC',Datasource:'#dsn_type#',is_select:1);
						if(len(GET_COST.RECORDCOUNT))maliyet_id=GET_COST.PRODUCT_COST_ID;
						if(len(GET_COST.PURCHASE_NET_SYSTEM))toplam_maliyet_sistem=toplam_maliyet_sistem+GET_COST.PURCHASE_NET_SYSTEM;
						if(len(GET_COST.PURCHASE_EXTRA_COST_SYSTEM))toplam_maliyet_extra_sistem=toplam_maliyet_extra_sistem+GET_COST.PURCHASE_EXTRA_COST_SYSTEM;
					}
				}
			}
		}else
		{//alis islemi ise standart alisi yollar maliyet olarak
			GET_PROD=cfquery(SQLString:'SELECT PRODUCT_ID FROM #dsn3_alias#.STOCKS STOCKS WHERE STOCK_ID = #arguments.stock_id#',Datasource:'#dsn_type#',is_select:1);
			if(GET_PROD.RECORDCOUNT)
			{
				GET_COST=cfquery(SQLString:'SELECT PRICE, MONEY FROM #dsn3_alias#.PRICE_STANDART PRICE_STANDART WHERE PRICE_STANDART.PURCHASESALES = 0 AND PRICE_STANDART.PRICESTANDART_STATUS = 1 AND PRICE_STANDART.PRODUCT_ID = #GET_PROD.PRODUCT_ID#',Datasource:'#dsn_type#',is_select:1);
				if(GET_COST.MONEY eq session.ep.money)
				{
					if(len(GET_COST.PRICE))toplam_maliyet_sistem=toplam_maliyet_sistem+GET_COST.PRICE;
				}else
				{
					GET_MONEY=cfquery(SQLString:"SELECT (RATE2/RATE1) RATE FROM #dsn_alias#.SETUP_MONEY PRICE_STANDART WHERE PERIOD_ID=#session.ep.period_id# AND MONEY_STATUS = 1 AND MONEY='#GET_COST.MONEY#' AND COMPANY_ID=#session.ep.company_id#",Datasource:"#dsn_type#",is_select:1);
					if(len(GET_COST.PRICE) and GET_MONEY.RECORDCOUNT) toplam_maliyet_sistem=GET_COST.PRICE*GET_MONEY.RATE;
				}
				toplam_maliyet_extra_sistem=0;
			}
		}
	}
	if(not len(maliyet_id)) maliyet_id=0;
	if(not len(toplam_maliyet_sistem)) toplam_maliyet_sistem=0;
	if(not len(toplam_maliyet_extra_sistem)) toplam_maliyet_extra_sistem=0;
	return '#maliyet_id#,#toplam_maliyet_sistem#,#toplam_maliyet_extra_sistem#';
	</cfscript>
</cffunction>
