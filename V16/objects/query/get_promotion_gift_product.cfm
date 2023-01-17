<cfset attributes.price_catid_gift = attributes.price_catid>
<cfquery name="get_promotion_gift_product" datasource="#DSN1#">
	SELECT  
		STOCKS.STOCK_ID,
		STOCKS.PRODUCT_ID,
		STOCKS.STOCK_CODE,
		GS.PRODUCT_STOCK,
		PRODUCT.PRODUCT_NAME,
		STOCKS.PROPERTY,
		STOCKS.BARCOD AS BARCOD,
		PRODUCT.IS_INVENTORY,
		PRODUCT.TAX AS TAX,
		PRODUCT.IS_ZERO_STOCK,
		PRODUCT.PRODUCT_CATID,
		PRODUCT.PRODUCT_CODE,
		PRODUCT.IS_SERIAL_NO,
		STOCKS.MANUFACT_CODE,
	<cfif attributes.price_catid_gift gt 0>
		PRICE.PRICE,
		PRICE.MONEY,
	<cfelse>
		PRICE_STANDART.PRICE,
		PRICE_STANDART.MONEY,
	</cfif>
		PRODUCT_UNIT.ADD_UNIT,
		PRODUCT_UNIT.UNIT_ID,
		PRODUCT_UNIT.PRODUCT_UNIT_ID,
		PRODUCT_UNIT.MAIN_UNIT,
		PRODUCT_UNIT.MULTIPLIER
	FROM
		PRODUCT,
		PRODUCT_CAT,
		STOCKS,
	<cfif isdefined("attributes.is_store")>
		#dsn2_alias#.GET_STOCK_PRODUCT_BRANCH GS,
	<cfelse>
		#dsn2_alias#.GET_STOCK GS,
	</cfif>
	<cfif attributes.price_catid_gift gt 0>
		#dsn3_alias#.PRICE PRICE, <!--- PRICE_CAT, --->
	<cfelse>
		PRICE_STANDART,
	</cfif>
		PRODUCT_UNIT,
		PRODUCT_OUR_COMPANY
	WHERE
		STOCKS.STOCK_ID = #GET_PRO.FREE_STOCK_ID# AND
		PRODUCT_OUR_COMPANY.PRODUCT_ID = PRODUCT.PRODUCT_ID AND
		PRODUCT_OUR_COMPANY.OUR_COMPANY_ID = #session.ep.company_id# AND
		PRODUCT.PRODUCT_STATUS = 1 AND 
		PRODUCT_UNIT.PRODUCT_ID = PRODUCT.PRODUCT_ID AND 
		PRODUCT_UNIT.PRODUCT_UNIT_STATUS = 1 AND 
		PRODUCT.PRODUCT_ID = STOCKS.PRODUCT_ID AND 
		GS.STOCK_ID = STOCKS.STOCK_ID AND
		PRODUCT_CAT.PRODUCT_CATID = PRODUCT.PRODUCT_CATID AND 
		PRODUCT.IS_SALES=1 
	<cfif attributes.price_catid_gift gt 0>
		<!--- AND PRICE.PRICE_CATID = PRICE_CAT.PRICE_CATID --->
		AND PRICE.PRODUCT_ID = STOCKS.PRODUCT_ID
		AND PRODUCT_UNIT.PRODUCT_UNIT_ID = PRICE.UNIT
		AND PRICE.PRICE_CATID = #attributes.price_catid_gift#
	<cfelse>
		AND PRICE_STANDART.PRICESTANDART_STATUS = 1			
		AND PRICE_STANDART.PURCHASESALES = 1
		AND PRICE_STANDART.PRODUCT_ID = STOCKS.PRODUCT_ID
		AND PRODUCT_UNIT.PRODUCT_UNIT_ID = PRICE_STANDART.UNIT_ID
	</cfif>
	<cfif isdefined("attributes.is_store")>
		AND GS.BRANCH_ID = #listgetat(session.ep.user_location,2,'-')#
	</cfif>
	<cfif attributes.stok_turu eq 2 >
		AND GS.PRODUCT_STOCK > 0
	</cfif>
	<cfif isdefined("attributes.zero_stock_status") and (attributes.zero_stock_status eq 1)>
		AND GS.PRODUCT_STOCK > 0
	</cfif>
		AND 
			(
				(
				GS.PRODUCT_STOCK < 0 AND
				PRODUCT.IS_ZERO_STOCK = 1 
				)
				OR
				GS.PRODUCT_STOCK >= 0
			)
	<cfif isdefined("sepet_process_type") and (sepet_process_type neq -1)>
		<cfif ListFind("56,58,60,63",sepet_process_type)>
			AND PRODUCT.IS_INVENTORY = 0
		</cfif>
	</cfif>						
	ORDER BY
		PRODUCT_NAME,STOCKS.PROPERTY
</cfquery>
<cfif not get_promotion_gift_product.recordcount>
	<cfset attributes.price_catid_gift = -2>
	<cfquery name="get_promotion_gift_product" datasource="#DSN1#">
		SELECT  
			STOCKS.STOCK_ID,
			STOCKS.PRODUCT_ID,
			STOCKS.STOCK_CODE,
			GS.PRODUCT_STOCK,
			PRODUCT.PRODUCT_NAME,
			STOCKS.PROPERTY,
			STOCKS.BARCOD AS BARCOD,
			PRODUCT.IS_INVENTORY,
			PRODUCT.TAX AS TAX,
			PRODUCT.IS_ZERO_STOCK,
			PRODUCT.PRODUCT_CATID,
			PRODUCT.PRODUCT_CODE,
			PRODUCT.IS_SERIAL_NO,
			STOCKS.MANUFACT_CODE,
		<cfif attributes.price_catid_gift gt 0>
			PRICE.PRICE,
			PRICE.MONEY,
		<cfelse>
			PRICE_STANDART.PRICE,
			PRICE_STANDART.MONEY,
		</cfif>
			PRODUCT_UNIT.ADD_UNIT,
			PRODUCT_UNIT.UNIT_ID,
			PRODUCT_UNIT.PRODUCT_UNIT_ID,
			PRODUCT_UNIT.MAIN_UNIT,
			PRODUCT_UNIT.MULTIPLIER
		FROM
			PRODUCT,
			PRODUCT_CAT,
			STOCKS,
		<cfif isdefined("attributes.is_store")>
			#dsn2_alias#.GET_STOCK_PRODUCT_BRANCH GS,
		<cfelse>
			#dsn2_alias#.GET_STOCK GS,
		</cfif>
		<cfif attributes.price_catid_gift gt 0>
			#dsn3_alias#.PRICE PRICE, <!--- PRICE_CAT, --->
		<cfelse>
			PRICE_STANDART,
		</cfif>
			PRODUCT_UNIT,
			PRODUCT_OUR_COMPANY
		WHERE
			STOCKS.STOCK_ID = #GET_PRO.FREE_STOCK_ID# AND
			PRODUCT_OUR_COMPANY.PRODUCT_ID = PRODUCT.PRODUCT_ID AND
			PRODUCT_OUR_COMPANY.OUR_COMPANY_ID = #session.ep.company_id# AND
			PRODUCT.PRODUCT_STATUS = 1 AND 
			PRODUCT_UNIT.PRODUCT_ID = PRODUCT.PRODUCT_ID AND 
			PRODUCT_UNIT.PRODUCT_UNIT_STATUS = 1 AND 
			PRODUCT.PRODUCT_ID = STOCKS.PRODUCT_ID AND 
			GS.STOCK_ID = STOCKS.STOCK_ID AND
			PRODUCT_CAT.PRODUCT_CATID = PRODUCT.PRODUCT_CATID AND 
			PRODUCT.IS_SALES=1 
		<cfif attributes.price_catid_gift gt 0>
			<!--- AND PRICE.PRICE_CATID = PRICE_CAT.PRICE_CATID --->
			AND PRICE.PRODUCT_ID = STOCKS.PRODUCT_ID
			AND PRODUCT_UNIT.PRODUCT_UNIT_ID = PRICE.UNIT
			AND PRICE.PRICE_CATID = #attributes.price_catid_gift#
		<cfelse>
			AND PRICE_STANDART.PRICESTANDART_STATUS = 1			
			AND PRICE_STANDART.PURCHASESALES = 1
			AND PRICE_STANDART.PRODUCT_ID = STOCKS.PRODUCT_ID
			AND PRODUCT_UNIT.PRODUCT_UNIT_ID = PRICE_STANDART.UNIT_ID
		</cfif>
		<cfif isdefined("attributes.is_store")>
			AND GS.BRANCH_ID = #listgetat(session.ep.user_location,2,'-')#
		</cfif>
		<cfif attributes.stok_turu eq 2 >
			AND GS.PRODUCT_STOCK > 0
		</cfif>
		<cfif isdefined("attributes.zero_stock_status") and (attributes.zero_stock_status eq 1)>
			AND GS.PRODUCT_STOCK > 0
		</cfif>
			AND 
				(
					(
					GS.PRODUCT_STOCK < 0 AND
					PRODUCT.IS_ZERO_STOCK = 1 
					)
					OR
					GS.PRODUCT_STOCK >= 0
				)
		<cfif isdefined("sepet_process_type") and (sepet_process_type neq -1)>
			<cfif ListFind("56,58,60,63",sepet_process_type)>
				AND PRODUCT.IS_INVENTORY = 0
			</cfif>
		</cfif>						
		ORDER BY
			PRODUCT_NAME,STOCKS.PROPERTY
	</cfquery>
</cfif>
<cfif get_promotion_gift_product.recordcount>
<cfoutput query="get_promotion_gift_product">
	<cfif isDefined("money")>
		<cfset attributes.money_gift = money>
	</cfif>
	<cfloop query="moneys">
		<cfif moneys.money is attributes.money_gift>
			<cfset row_money_gift = money >
			<cfset row_money_rate1_gift = moneys.rate1 >
			<cfset row_money_rate2_gift = moneys.rate2 >
		</cfif>
	</cfloop>
	<cfset pro_price_gift = get_promotion_gift_product.price>
	<cfif attributes.price_catid_gift neq -2>
		<cfquery name="get_p_gift" datasource="#DSN3#">
		SELECT  
			P.UNIT,
			P.PRICE,
			P.PRODUCT_ID,
			P.MONEY
		FROM 
			PRICE P,
			PRODUCT PR
		WHERE 
			P.PRODUCT_ID = PR.PRODUCT_ID AND 
			P.PRICE_CATID = #attributes.price_catid_gift# AND
			(
				P.STARTDATE <= #now()# AND
				(P.FINISHDATE >= #now()# OR P.FINISHDATE IS NULL)
			) AND 
			P.PRODUCT_ID = #PRODUCT_ID#
		</cfquery>
		<!--- <cfquery name="get_p" dbtype="query">
			SELECT * FROM get_price_all WHERE UNIT = #get_promotion_gift_product.PRODUCT_UNIT_ID[currentrow]# AND PRODUCT_ID = #PRODUCT_ID#
		</cfquery> --->
		<cfscript>
			if(len(get_p_gift.PRICE)){ musteri_pro_price_gift = get_p_gift.PRICE; musteri_row_money_gift=get_p_gift.MONEY; }else{ musteri_pro_price_gift = 0;musteri_row_money_gift=default_money.money;}
		</cfscript>
		<cfloop query="moneys">
			<cfif moneys.money is musteri_row_money_gift>
				<cfset musteri_row_money_rate1_gift = moneys.rate1>
				<cfset musteri_row_money_rate2_gift = moneys.rate2>
			</cfif>
		</cfloop>				
		<cfscript>
			if(musteri_row_money_gift is default_money.money)
			{
				musteri_str_other_money_gift = musteri_row_money_gift; 
				musteri_flt_other_money_value_gift = musteri_pro_price_gift;	
				musteri_flag_prc_other_gift = 0;
			}
			else
			{
				musteri_flag_prc_other_gift = 1 ;
				/*30 güne silinsin aselam 20062003
				if(isdefined("attributes.is_fcurrency") and attributes.is_fcurrency eq 1)
				{
					musteri_str_other_money_gift = musteri_row_money_gift; 
					musteri_flt_other_money_value_gift = musteri_pro_price_gift;
				}
				else
				*/
				{
					musteri_str_other_money_gift = musteri_row_money_gift; 
					musteri_flt_other_money_value_gift = musteri_pro_price_gift;
				}
				musteri_pro_price_gift = musteri_pro_price_gift*(musteri_row_money_rate2_gift/musteri_row_money_rate1_gift);
			}
		</cfscript>
	<cfelse>
		<cfscript>
			musteri_flt_other_money_value_gift = pro_price_gift;
			musteri_str_other_money_gift = row_money_gift;
			musteri_row_money_gift = row_money_gift;
			/*30 güne silinsin aselam 20062003
			if((row_money_gift is default_money.money) and isdefined("attributes.is_fcurrency") and attributes.is_fcurrency eq 1)
			{
				musteri_flag_prc_other_gift = 0;
				musteri_str_other_money_gift = row_money_gift;
				musteri_pro_price_gift = pro_price_gift;
			}
			else
			*/
			{
				musteri_flag_prc_other_gift = 1;
				musteri_pro_price_gift = pro_price_gift*(row_money_rate2_gift/row_money_rate1_gift);
				musteri_str_other_money_gift = default_money.money;
			}
		</cfscript>
	</cfif>
</cfoutput>
<cfelse>
	<cfset musteri_flag_prc_other_gift = 0>
	<cfset musteri_flt_other_money_value_gift = 0>
	<cfset musteri_row_money_gift = 0>
</cfif>
