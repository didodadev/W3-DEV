<cfif isdefined('attributes.is_from_report')><!--- özel rapordan geliyor. --->
	<cfset GET_UPD_PURCHASE.OTHER_MONEY = '#session.ep.MONEY2#'>
	<cfset deliver_date ="#now()#">
	<cfset CONVERT_STOCKS_ID = left(attributes.CONVERT_STOCKS_ID,len(attributes.CONVERT_STOCKS_ID)-1)>
	<cfquery name="GET_SHIP_ROW" datasource="#DSN3#">
		<cfloop from="1" to="#listlen(CONVERT_STOCKS_ID)#" index="i">
			SELECT
				S.PRODUCT_ID,
				S.STOCK_ID,
				S.MANUFACT_CODE AS PRODUCT_MANUFACT_CODE,
				S.PROPERTY,
				S.BARCOD,
				S.STOCK_CODE_2,
				S.STOCK_CODE,
				 <cfif isdefined("CONVERT_NAME_PRODUCT")>
                			'#listgetat(CONVERT_NAME_PRODUCT,i,',')#' AS NAME_PRODUCT,
                		<cfelse>
                			S.PRODUCT_NAME+' - '+ISNULL(S.PROPERTY,'') AS NAME_PRODUCT,
                		</cfif>
				S.IS_INVENTORY,
				S.IS_PRODUCTION,
				S.TAX,
				S.TAX_PURCHASE,
				PRODUCT_UNIT.MAIN_UNIT AS UNIT,
				PRODUCT_UNIT.ADD_UNIT,
				PRODUCT_UNIT.PRODUCT_UNIT_ID AS UNIT_ID,
				PS.PRICE,
				PS.PRICE_KDV,
                <cfif isdefined("convert_other_money")>
                	'#listgetat(CONVERT_OTHER_MONEY,i,',')#' AS OTHER_MONEY,
                <cfelse>
                	PS.MONEY AS OTHER_MONEY,
                </cfif>
				#listgetat(CONVERT_AMOUNT_STOCKS_ID,i,',')# AS AMOUNT,
				'' AS DARA,
				'' AS DARALI,
				'' AS ROW_INTERNALDEMAND_ID,
				 <cfif isdefined("CONVERT_OTHER_MONEY_VALUE")>
                	'#listgetat(CONVERT_OTHER_MONEY_VALUE,i,',')#' AS OTHER_MONEY_VALUE,
                <cfelse>
					'' AS OTHER_MONEY_VALUE,
                </cfif>
				'' AS OTHER_MONEY_GROSS_TOTAL,
				'' AS PAYMETHOD_ID,
				'' AS UNIQUE_RELATION_ID,
                <cfif isdefined("CONVERT_PRODUCT_NAME2")>
                	'#listgetat(CONVERT_PRODUCT_NAME2,i,',')#' AS PRODUCT_NAME2,
                <cfelse>
                    '' AS PRODUCT_NAME2,
                </cfif>
                <cfif isdefined("CONVERT_AMOUNT2")>
                	'#listgetat(CONVERT_AMOUNT2,i,',')#' AS AMOUNT2,
                <cfelse>
                    '' AS AMOUNT2,
                </cfif>
                <cfif isdefined("CONVERT_UNIT2")>
                	'#listgetat(CONVERT_UNIT2,i,',')#' AS UNIT2,
                <cfelse>
                    '' AS UNIT2,
                </cfif>
				'' AS EXTRA_PRICE,
				'' AS EXTRA_PRICE_TOTAL,
				'' AS EXTRA_PRICE_OTHER_TOTAL,
				'' AS SHELF_NUMBER,
				'' AS TO_SHELF_NUMBER,
				'' AS BASKET_EXTRA_INFO_ID,
				'' AS SELECT_INFO_EXTRA,
				'' AS DETAIL_INFO_EXTRA,
				'' AS OTVTOTAL,
				'' AS DELIVER_LOC,
				'' AS DELIVER_DEPT,
                '' as DISCOUNTTOTAL,
                '' as DUE_DATE,
                <cfif isdefined("CONVERT_SPECT_ID")>
                	#listgetat(CONVERT_SPECT_ID,i,',')# AS SPECT_VAR_ID,
                <cfelse>
                    '' AS SPECT_VAR_ID,
                </cfif>
                <cfif isdefined("CONVERT_SPECT_NAME")>
                	'#listgetat(CONVERT_SPECT_NAME,i,',')#' AS SPECT_VAR_NAME,
                <cfelse>
                    '' AS SPECT_VAR_NAME,
                </cfif>
				'' AS LOT_NO,
                <cfif isdefined("CONVERT_PRICE_OTHER")>
                	'#listgetat(CONVERT_PRICE_OTHER,i,',')#' AS PRICE_OTHER,
                <cfelse>
					'' AS PRICE_OTHER,
                </cfif>
				'' AS OTV_ORAN,
				<cfif isdefined("CONVERT_NETTOTAL")>
                	#listgetat(CONVERT_NETTOTAL,i,',')# AS NETTOTAL,
                <cfelse>
					'' AS NETTOTAL,
                </cfif>
				<cfif isdefined("CONVERT_NETTOTAL") and len(listgetat(CONVERT_NETTOTAL,i,',')) and listgetat(CONVERT_NETTOTAL,i,',') neq 0>
                	#listgetat(CONVERT_NETTOTAL,i,',')/listgetat(CONVERT_AMOUNT_STOCKS_ID,i,',')#
                <cfelseif isdefined("CONVERT_COST_PRICE") and len(listgetat(CONVERT_COST_PRICE,i,',')) and listgetat(CONVERT_COST_PRICE,i,',') neq 0>
                	#listgetat(CONVERT_COST_PRICE,i,',')#
                <cfelse> 0 </cfif> AS COST_PRICE,
				'' AS WIDTH_VALUE,
				'' AS DEPTH_VALUE,
				'' AS HEIGHT_VALUE,
                <cfif isdefined("CONVERT_ROW_PROJECT_ID")>
                	'#listgetat(CONVERT_ROW_PROJECT_ID,i,',')#' AS ROW_PROJECT_ID,
                <cfelse>
					'' AS ROW_PROJECT_ID,
                </cfif>
				'#listgetat(CONVERT_WRK_ROW_ID,i,',')#' AS MAIN_WRK_ROW_RELATION_ID,
				'' AS WRK_ROW_ID,
				'' AS EXTRA_COST,
                <cfif isdefined("CONVERT_DISCOUNT")>
                	'#listgetat(CONVERT_DISCOUNT,i,',')#' AS DISCOUNT,
                <cfelse>
					'' AS DISCOUNT,
                </cfif>
                <cfif isdefined("CONVERT_DISCOUNT_COST")>
                	'#listgetat(CONVERT_DISCOUNT_COST,i,',')#' AS DISCOUNT_COST
                <cfelse>
					'' AS DISCOUNT_COST
                </cfif>
			FROM
				STOCKS S,
				PRODUCT_UNIT,
				PRICE_STANDART AS PS 
			WHERE
				S.STOCK_ID = #listgetat(CONVERT_STOCKS_ID,i,',')# AND
				PRODUCT_UNIT.PRODUCT_ID = S.PRODUCT_ID AND
				PS.PRODUCT_ID = S.PRODUCT_ID AND
				PRODUCT_UNIT.PRODUCT_UNIT_ID = S.PRODUCT_UNIT_ID AND
				PS.UNIT_ID = PRODUCT_UNIT.PRODUCT_UNIT_ID AND
				PS.PRICESTANDART_STATUS = 1 AND
				PS.PURCHASESALES = <cfqueryparam cfsqltype="cf_sql_smallint" value="#attributes.purchase_sales#">
			<cfif i neq listlen(CONVERT_STOCKS_ID)>
				UNION ALL
			</cfif>
		</cfloop>
	</cfquery>	
<cfelseif isdefined('attributes.type')><!--- Üretim Malzeme İhtiyaçları listesinden dönüşüm yapılıyorsa --->
	<cfset GET_UPD_PURCHASE.OTHER_MONEY = '#session.ep.MONEY2#'>
	<cfset deliver_date ="#now()#"><!--- Üretim Malzeme İhtiyaçları listesinden dönüşüm yapılıyorsa --->
	<cfset CONVERT_STOCKS_ID = left(attributes.CONVERT_STOCKS_ID,len(attributes.CONVERT_STOCKS_ID)-1)>
	<cfif isdefined("attributes.CONVERT_MONEY")>
		<cfset CONVERT_MONEY = left(attributes.CONVERT_MONEY,len(attributes.CONVERT_MONEY)-1)>
		<cfset CONVERT_PRICE = left(attributes.CONVERT_PRICE,len(attributes.CONVERT_PRICE)-1)>
		<cfset CONVERT_PRICE_OTHER = left(attributes.CONVERT_PRICE_OTHER,len(attributes.CONVERT_PRICE_OTHER)-1)>
	</cfif>
	<cfif isdefined("attributes.CONVERT_COST_PRICE")>
		<cfset CONVERT_COST_PRICE = left(attributes.CONVERT_COST_PRICE,len(attributes.CONVERT_COST_PRICE)-1)>
	<cfelse>
		<cfset CONVERT_COST_PRICE = 0>
	</cfif>
	<cfif isdefined("attributes.CONVERT_EXTRA_COST")>
   		<cfset CONVERT_EXTRA_COST = left(attributes.CONVERT_EXTRA_COST,len(attributes.CONVERT_EXTRA_COST)-1)>
	<cfelse>
		<cfset CONVERT_EXTRA_COST = 0>
	</cfif>
    <cfif isdefined("attributes.CONVERT_WRK_ROW_ID")>
   		<cfset CONVERT_WRK_ROW_ID = left(attributes.CONVERT_WRK_ROW_ID,len(attributes.CONVERT_WRK_ROW_ID)-1)>
	<cfelse>
		<cfset CONVERT_WRK_ROW_ID = 0>
	</cfif>
	<cfif isdefined("attributes.CONVERT_PRODUCT_NAME2")>
   		<cfset CONVERT_PRODUCT_NAME2 = left(attributes.CONVERT_PRODUCT_NAME2,len(attributes.CONVERT_PRODUCT_NAME2)-1)>
	<cfelse>
		<cfset CONVERT_PRODUCT_NAME2 = 0>
	</cfif>
	<cfif isDefined("attributes.CONVERT_LIST_PRICE")>
		<cfset CONVERT_LIST_PRICE = left(attributes.CONVERT_LIST_PRICE, len(attributes.CONVERT_LIST_PRICE)-1)>
	<cfelse>
		<cfset CONVERT_LIST_PRICE = "">
	</cfif>
	<cfquery name="GET_SHIP_ROW" datasource="#DSN3#">
		SELECT
			S.PRODUCT_ID,
			S.STOCK_ID,
			S.MANUFACT_CODE AS PRODUCT_MANUFACT_CODE,
			S.PROPERTY,
			S.BARCOD,
			S.STOCK_CODE_2,
			S.STOCK_CODE,
			S.IS_SERIAL_NO,
			S.PRODUCT_NAME+' - '+ISNULL(S.PROPERTY,'') AS NAME_PRODUCT,
			S.IS_INVENTORY,
			S.IS_PRODUCTION,
			S.TAX,
			S.TAX_PURCHASE,
			PRODUCT_UNIT.MAIN_UNIT AS UNIT,
			PRODUCT_UNIT.ADD_UNIT,
			PRODUCT_UNIT.PRODUCT_UNIT_ID AS UNIT_ID,
			PS.PRICE,
			PS.PRICE_KDV,
			PS.MONEY AS OTHER_MONEY,
			'' AS DARA,
			'' AS DARALI,
			'' AS ROW_INTERNALDEMAND_ID,
			'' AS OTHER_MONEY_VALUE,
			'' AS OTHER_MONEY_GROSS_TOTAL,
			'' AS PAYMETHOD_ID,
			'' AS UNIQUE_RELATION_ID,
			'' AS PRODUCT_NAME2,
			'' AS AMOUNT2,
			'' AS UNIT2,
			'' AS EXTRA_PRICE,
			'' AS EXTRA_PRICE_TOTAL,
			'' AS EXTRA_PRICE_OTHER_TOTAL,
			'' AS SHELF_NUMBER,
			'' AS TO_SHELF_NUMBER,
			'' AS BASKET_EXTRA_INFO_ID,
			'' AS SELECT_INFO_EXTRA,
			'' AS DETAIL_INFO_EXTRA,
			'' AS OTVTOTAL,
			'' AS DELIVER_LOC,
			'' AS DELIVER_DEPT,
			'' AS SPECT_VAR_ID,
			'' AS SPECT_VAR_NAME,
			'' AS LOT_NO,
			'' AS PRICE_OTHER,
			'' AS OTV_ORAN,
			'' AS NETTOTAL,
			'' AS WIDTH_VALUE,
			'' AS DEPTH_VALUE,
			'' AS HEIGHT_VALUE,
			'' AS ROW_PROJECT_ID,
			'' AS MAIN_WRK_ROW_RELATION_ID,
			'' AS WRK_ROW_ID,
			'' AS EXTRA_COST,
            '' as DUE_DATE,
            '' as DISCOUNTTOTAL
			,'' as DISCOUNT_COST
		FROM
			STOCKS S,
			PRODUCT_UNIT,
			PRICE_STANDART AS PS 
		WHERE
			S.STOCK_ID IN (#CONVERT_STOCKS_ID#) AND
			PRODUCT_UNIT.PRODUCT_ID = S.PRODUCT_ID AND
			PS.PRODUCT_ID = S.PRODUCT_ID AND
			PRODUCT_UNIT.PRODUCT_UNIT_ID = S.PRODUCT_UNIT_ID AND
			PS.UNIT_ID = PRODUCT_UNIT.PRODUCT_UNIT_ID AND
			PS.PRICESTANDART_STATUS = 1 AND
			PS.PURCHASESALES = 0
		ORDER BY
			S.PRODUCT_NAME
	</cfquery>
<cfelseif isdefined('attributes.internal_row_info')  or (isdefined("attributes.internal_demand_id") and isdefined("internald_row_id_list") and len(internald_row_id_list))>
	<cfquery name="GET_SHIP_ROW" datasource="#dsn3#">
		SELECT
			INT_D.*,
			INT_D.PRODUCT_NAME AS NAME_PRODUCT,
			INT_D.QUANTITY AS AMOUNT,
			INT_D.DISCOUNT_1 AS DISCOUNT,
			INT_D.DISCOUNT_2 AS DISCOUNT2,
			INT_D.DISCOUNT_3 AS DISCOUNT3,
			INT_D.DISCOUNT_4 AS DISCOUNT4,
			INT_D.DISCOUNT_5 AS DISCOUNT5,
			INT_D.DISCOUNT_6 AS DISCOUNT6,
			INT_D.DISCOUNT_7 AS DISCOUNT7,
			INT_D.DISCOUNT_8 AS DISCOUNT8,
			INT_D.DISCOUNT_9 AS DISCOUNT9,
			INT_D.DISCOUNT_10 AS DISCOUNT10,
            '' as DUE_DATE,
			'' AS TO_SHELF_NUMBER,
			'' AS DARA,
			'' AS DARALI,
			'' AS PAYMETHOD_ID,
			'' AS OTHER_MONEY_GROSS_TOTAL,
			'' AS DELIVER_LOC,
			'' AS DELIVER_DEPT,
			'' AS LOT_NO,
			S.IS_INVENTORY,
			S.IS_PRODUCTION,
			S.STOCK_CODE,
			S.BARCOD,
			S.STOCK_CODE_2,
			S.IS_SERIAL_NO,
			S.MANUFACT_CODE,
            '' as DISCOUNTTOTAL,
			'' as DISCOUNT_COST,
			EXC.EXPENSE,
        	EXI.EXPENSE_ITEM_NAME
		FROM 
			INTERNALDEMAND_ROW INT_D
			LEFT JOIN #dsn2#.EXPENSE_CENTER AS EXC ON INT_D.EXPENSE_CENTER_ID = EXC.EXPENSE_ID
        	LEFT JOIN #dsn2#.EXPENSE_ITEMS AS EXI ON INT_D.EXPENSE_ITEM_ID = EXI.EXPENSE_ITEM_ID,
			STOCKS S
		WHERE 
		<cfif isdefined("interdemand_id_list") and  len(interdemand_id_list)>
				INT_D.I_ID IN (#interdemand_id_list#)
            <cfelseif isdefined("attributes.internal_demand_id") and len(attributes.internal_demand_id)>
            	INT_D.I_ID=#attributes.internal_demand_id#
			<cfelse>
				INT_D.I_ID < 0
			</cfif>
			<cfif len(internald_row_id_list)>
			AND INT_D.I_ROW_ID IN (#internald_row_id_list#)
			</cfif>
			AND INT_D.STOCK_ID=S.STOCK_ID
		ORDER BY
			INT_D.I_ID DESC,
			INT_D.I_ROW_ID
	</cfquery>
<cfelse>	
	<cfquery name="GET_SHIP_ROW" datasource="#dsn2#">
		SELECT
			SH.*,
			S.IS_INVENTORY,
			S.IS_PRODUCTION,
			S.STOCK_CODE,
			S.BARCOD,
			S.STOCK_CODE_2,
			S.IS_SERIAL_NO,
			S.MANUFACT_CODE,
			ISNULL((SELECT INT_D.I_ID FROM #dsn3_alias#.INTERNALDEMAND_ROW INT_D WHERE INT_D.I_ROW_ID = SH.ROW_INTERNALDEMAND_ID),0) I_ID,
			SH.WRK_ROW_RELATION_ID MAIN_WRK_ROW_RELATION_ID,
			E.EMPLOYEE_NAME + ' ' + E.EMPLOYEE_SURNAME AS BASKET_EMPLOYEE,
			P.PROJECT_HEAD,
			EXC.EXPENSE,
        	EXI.EXPENSE_ITEM_NAME
		FROM 
			#dsn3_alias#.STOCKS S,
			SHIP_ROW SH
			LEFT JOIN #dsn2#.EXPENSE_CENTER AS EXC ON SH.EXPENSE_CENTER_ID = EXC.EXPENSE_ID
        	LEFT JOIN #dsn2#.EXPENSE_ITEMS AS EXI ON SH.EXPENSE_ITEM_ID = EXI.EXPENSE_ITEM_ID
			LEFT JOIN #dsn_alias#.EMPLOYEES E ON E.EMPLOYEE_ID = SH.BASKET_EMPLOYEE_ID
			LEFT JOIN #dsn_alias#.PRO_PROJECTS P ON P.PROJECT_ID = SH.ROW_PROJECT_ID
		WHERE 
			SH.SHIP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ship_id#"> AND
			SH.STOCK_ID=S.STOCK_ID
		ORDER BY
			SH.SHIP_ROW_ID
	</cfquery>
</cfif>	
<cfscript>
	sepet = StructNew();
	sepet.satir = ArrayNew(1);
	sepet.kdv_array = ArrayNew(2);
	sepet.otv_array = ArrayNew(2);
	sepet.total = 0;
	sepet.toplam_indirim = 0;
	sepet.total_tax = 0;
	sepet.total_otv = 0;
	sepet.net_total = 0;
	sepet.genel_indirim = 0;
	if( isdefined('attributes.internal_row_info')  or (isdefined("attributes.internal_demand_id") and isdefined("internald_row_id_list") and len(internald_row_id_list)))
		sepet.other_money = session.ep.money;
	else if( isdefined("GET_UPD_PURCHASE")){
		sepet.other_money = GET_UPD_PURCHASE.OTHER_MONEY;
	}
</cfscript>
<cfoutput query="GET_SHIP_ROW">
	<cfset row_project_id_list_=listsort(ListDeleteDuplicates(valuelist(GET_SHIP_ROW.ROW_PROJECT_ID)),'numeric','asc',',')>
	<cfif len(row_project_id_list_)>
        <cfquery name="GET_ROW_PROJECTS" datasource="#dsn#">
            SELECT PROJECT_HEAD,PROJECT_ID FROM PRO_PROJECTS WHERE PROJECT_ID IN (#row_project_id_list_#) ORDER BY PROJECT_ID
        </cfquery>
        <cfset row_project_id_list_=valuelist(GET_ROW_PROJECTS.PROJECT_ID)>
    </cfif>
	<cfscript>
		i = currentrow;
		sepet.satir[i] = StructNew();
		sepet.satir[i].product_id = GET_SHIP_ROW.product_id;
		sepet.satir[i].is_inventory = GET_SHIP_ROW.is_inventory;
		sepet.satir[i].is_production = GET_SHIP_ROW.IS_PRODUCTION;
		sepet.satir[i].product_name = name_product;
		sepet.satir[i].IS_SERIAL_NO = IS_SERIAL_NO;        
		
		if(isdefined('attributes.internal_row_info') and len(attributes.internal_row_info)  or (isdefined("attributes.internal_demand_id") and isdefined("internald_row_id_list") and len(internald_row_id_list))) //iç talepten deposevk
			sepet.satir[i].row_ship_id='#GET_SHIP_ROW.I_ID#;#GET_SHIP_ROW.I_ROW_ID#';
		else if(len(GET_SHIP_ROW.ROW_INTERNALDEMAND_ID))
			sepet.satir[i].row_ship_id="#GET_SHIP_ROW.I_ID#;#GET_SHIP_ROW.ROW_INTERNALDEMAND_ID#";

		if (isdefined('attributes.type'))//Üretim planlamadaki malzeme listesinde seçilen ürünlerin miktarlarınıda alır. veya özel rapordan alır..
			sepet.satir[i].amount  = listgetat(CONVERT_AMOUNT_STOCKS_ID,listfind(CONVERT_STOCKS_ID,GET_SHIP_ROW.STOCK_ID[i],','),',');
		else if(isdefined('attributes.internal_row_info')) //satır bazlı ic talep listesinde secilen satırların miktarlarını alır
			sepet.satir[i].amount  = listgetat(internald_row_amount_list,listfind(internald_row_id_list,GET_SHIP_ROW.I_ROW_ID[i],','),',');
		else
			sepet.satir[i].amount = amount;
		sepet.satir[i].unit = unit;
		sepet.satir[i].unit_id = unit_id;
		if ((isdefined('attributes.type') or isdefined('attributes.is_from_report')) and isdefined("attributes.CONVERT_MONEY"))
				sepet.satir[i].price = listgetat(CONVERT_PRICE,i,',');
				if (isdefined("CONVERT_LIST_PRICE") and len(CONVERT_LIST_PRICE) and CONVERT_LIST_PRICE neq 0) {
					sepet.satir[i].list_price = listGetAt(CONVERT_LIST_PRICE,i, ',');
				}
			else{
				if(len(price))
					sepet.satir[i].price = price;	
				else
					sepet.satir[i].price = 0;
			}

		//Wrk_row_id Eklendi
		if(Len(GET_SHIP_ROW.WRK_ROW_ID) and not isdefined("attributes.is_ship_copy") and not isdefined("attributes.internal_demand_id"))
			sepet.satir[i].wrk_row_id = GET_SHIP_ROW.WRK_ROW_ID;
		else
			sepet.satir[i].wrk_row_id ="WRK#i##round(rand()*65)##dateformat(now(),'YYYYMMDD')##timeformat(now(),'HHmmssL')##session.ep.userid##round(rand()*100)##i#";
		
		if(isdefined("main_wrk_row_relation_id") and not isdefined("attributes.is_ship_copy"))
			sepet.satir[i].wrk_row_relation_id = '#main_wrk_row_relation_id#';
		else if (isdefined("attributes.internal_demand_id") and len(attributes.internal_demand_id))
			sepet.satir[i].wrk_row_relation_id = GET_SHIP_ROW.WRK_ROW_ID;
		else
			sepet.satir[i].wrk_row_relation_id = '';


		if(len(DARA)) sepet.satir[i].dara = DARA; else sepet.satir[i].dara = 0;
		if(len(DARALI)) sepet.satir[i].darali = DARALI;	else sepet.satir[i].darali = sepet.satir[i].amount;
		if (len(extra_cost)) sepet.satir[i].extra_cost = extra_cost; else sepet.satir[i].extra_cost =0;
		if(isdefined("COST_PRICE") and len(COST_PRICE)) sepet.satir[i].net_maliyet = COST_PRICE; else sepet.satir[i].net_maliyet=0;
		if( not isdefined('attributes.type') and not isdefined('attributes.internal_row_info') and not isdefined('attributes.is_from_report'))//Malzeme planından veya iç talepten gelmiyorsa normal şekilde alsın
			{
			if (not len(discount)) sepet.satir[i].indirim1 = 0; else sepet.satir[i].indirim1 = discount;
			if (not len(discount2)) sepet.satir[i].indirim2 = 0; else sepet.satir[i].indirim2 = discount2;
			if (not len(discount3)) sepet.satir[i].indirim3 = 0; else sepet.satir[i].indirim3 = discount3;
			if (not len(discount4)) sepet.satir[i].indirim4 = 0; else sepet.satir[i].indirim4 = discount4;
			if (not len(discount5)) sepet.satir[i].indirim5 = 0; else sepet.satir[i].indirim5 = discount5;
			if (not len(discount6)) sepet.satir[i].indirim6 = 0; else sepet.satir[i].indirim6 = discount6;
			if (not len(discount7)) sepet.satir[i].indirim7 = 0; else sepet.satir[i].indirim7 = discount7;
			if (not len(discount8)) sepet.satir[i].indirim8 = 0; else sepet.satir[i].indirim8 = discount8;
			if (not len(discount9)) sepet.satir[i].indirim9 = 0; else sepet.satir[i].indirim9 = discount9;
			if (not len(discount10)) sepet.satir[i].indirim10 = 0; else sepet.satir[i].indirim10 = discount10;
			}
		else
			{
			sepet.satir[i].indirim1 = 0;
			sepet.satir[i].indirim2 = 0;
			sepet.satir[i].indirim3 = 0;
			sepet.satir[i].indirim4 = 0;
			sepet.satir[i].indirim5 = 0;
			sepet.satir[i].indirim6 = 0;
			sepet.satir[i].indirim7 = 0;
			sepet.satir[i].indirim8 = 0;
			sepet.satir[i].indirim9 = 0;
			sepet.satir[i].indirim10 = 0;
			}	
		if(isdefined('attributes.is_from_report'))
		{
			if (not len(discount)) sepet.satir[i].indirim1 = 0; else sepet.satir[i].indirim1 = DISCOUNT;
			if (not len(DISCOUNT_COST)) sepet.satir[i].iskonto_tutar = 0; else sepet.satir[i].iskonto_tutar = DISCOUNT_COST;			
		}
		else
		{
			if (not len(DISCOUNT_COST)) sepet.satir[i].iskonto_tutar = 0; else sepet.satir[i].iskonto_tutar = DISCOUNT_COST;				
		}
		sepet.satir[i].indirim_carpan = (100-sepet.satir[i].indirim1) * (100-sepet.satir[i].indirim2) * (100-sepet.satir[i].indirim3) * (100-sepet.satir[i].indirim4) * (100-sepet.satir[i].indirim5) * (100-sepet.satir[i].indirim6) * (100-sepet.satir[i].indirim7) * (100-sepet.satir[i].indirim8) * (100-sepet.satir[i].indirim9) * (100-sepet.satir[i].indirim10);
		sepet.satir[i].marj = 0;
		if(len(tax))sepet.satir[i].tax_percent = tax;else sepet.satir[i].tax_percent = 0;
		sepet.satir[i].paymethod_id = paymethod_id;
		sepet.satir[i].stock_id = stock_id;
		sepet.satir[i].barcode = GET_SHIP_ROW.BARCOD;
		sepet.satir[i].special_code = GET_SHIP_ROW.STOCK_CODE_2;
		sepet.satir[i].stock_code = GET_SHIP_ROW.STOCK_CODE;
		sepet.satir[i].manufact_code = PRODUCT_MANUFACT_CODE;
		sepet.satir[i].duedate = GET_SHIP_ROW.DUE_DATE;
		if(len(UNIQUE_RELATION_ID)) sepet.satir[i].row_unique_relation_id = UNIQUE_RELATION_ID; else sepet.satir[i].row_unique_relation_id = "";
		if(len(PRODUCT_NAME2)) sepet.satir[i].product_name_other = PRODUCT_NAME2; else sepet.satir[i].product_name_other = "";
		if(len(AMOUNT2)) sepet.satir[i].amount_other = AMOUNT2; else sepet.satir[i].amount_other = "";
		if(len(UNIT2)) sepet.satir[i].unit_other = UNIT2; else sepet.satir[i].unit_other = "";
		if(len(EXTRA_PRICE)) sepet.satir[i].ek_tutar = EXTRA_PRICE; else sepet.satir[i].ek_tutar = 0;
		if(len(EXTRA_PRICE_TOTAL)) sepet.satir[i].ek_tutar_total = EXTRA_PRICE_TOTAL; else sepet.satir[i].ek_tutar_total = 0;
		if(len(EXTRA_PRICE_OTHER_TOTAL)) sepet.satir[i].ek_tutar_other_total = EXTRA_PRICE_OTHER_TOTAL; else sepet.satir[i].ek_tutar_other_total = 0;
		if(len(SHELF_NUMBER)) sepet.satir[i].shelf_number = SHELF_NUMBER; else sepet.satir[i].shelf_number = "";
		if(len(TO_SHELF_NUMBER)) sepet.satir[i].to_shelf_number = TO_SHELF_NUMBER; else sepet.satir[i].to_shelf_number = "";
		if(len(BASKET_EXTRA_INFO_ID)) sepet.satir[i].basket_extra_info = BASKET_EXTRA_INFO_ID; else sepet.satir[i].basket_extra_info="";
		if(len(SELECT_INFO_EXTRA)) sepet.satir[i].select_info_extra = SELECT_INFO_EXTRA; else sepet.satir[i].select_info_extra="";
		if(len(DETAIL_INFO_EXTRA)) sepet.satir[i].detail_info_extra = DETAIL_INFO_EXTRA; else sepet.satir[i].detail_info_extra="";
		//sepet.satir[i].row_total = amount*price;
		if( not isdefined('attributes.type'))//Malzeme planında gelmiyorsa normal şekilde alsın
		{
			sepet.satir[i].row_total = (sepet.satir[i].amount*sepet.satir[i].price)+sepet.satir[i].ek_tutar_total;
		}
		else
		{
			sepet.satir[i].row_total = (listgetat(CONVERT_AMOUNT_STOCKS_ID,i,',')*sepet.satir[i].price)+sepet.satir[i].ek_tutar_total;
		}
		//sepet.satir[i].row_nettotal = wrk_round((sepet.satir[i].row_total/100000000000000000000) * sepet.satir[i].indirim_carpan,price_round_number);
		if(len(NETTOTAL))
			sepet.satir[i].row_nettotal = wrk_round(NETTOTAL,price_round_number);
		else
			sepet.satir[i].row_nettotal = wrk_round((sepet.satir[i].row_total/100000000000000000000) * sepet.satir[i].indirim_carpan,price_round_number);	
		
		sepet.satir[i].row_taxtotal = wrk_round(sepet.satir[i].row_nettotal * (sepet.satir[i].tax_percent/100),price_round_number);
		if(len(OTVTOTAL))
		{ 
			sepet.satir[i].row_otvtotal =OTVTOTAL;
			sepet.satir[i].row_lasttotal = sepet.satir[i].row_nettotal + sepet.satir[i].row_taxtotal + sepet.satir[i].row_otvtotal;
		}
		else
		{
		 	sepet.satir[i].row_otvtotal = 0;
			sepet.satir[i].row_lasttotal = sepet.satir[i].row_nettotal + sepet.satir[i].row_taxtotal;
		}
		sepet.total = sepet.total + wrk_round(sepet.satir[i].row_total,basket_total_round_number); //subtotal_
		sepet.toplam_indirim = sepet.toplam_indirim + (wrk_round(sepet.satir[i].row_total,price_round_number) - wrk_round(sepet.satir[i].row_nettotal,price_round_number)); //discount_
		sepet.net_total = sepet.net_total + sepet.satir[i].row_nettotal; //nettotal_
	/*	if( isdefined('attributes.internal_row_info')  or (isdefined("attributes.internal_demand_id") and isdefined("internald_row_id_list") and len(internald_row_id_list)))
		{
			sepet.satir[i].other_money = other_money;
			sepet.satir[i].other_money_value =OTHER_MONEY_VALUE;
			sepet.satir[i].other_money_grosstotal = 0;
			sepet.satir[i].price_other = PRICE;
		}
		else
		{*/
			
			
			if(len(OTHER_MONEY_VALUE)) sepet.satir[i].other_money_value = OTHER_MONEY_VALUE; else sepet.satir[i].other_money_value =0;
			sepet.satir[i].other_money_grosstotal = OTHER_MONEY_GROSS_TOTAL;
			
			if (isdefined('attributes.type') and isdefined("attributes.CONVERT_MONEY")){//Üretim planlamadaki malzeme listesinde seçilen ürünlerin miktarlarınıda alır.
				sepet.satir[i].price_other = listgetat(CONVERT_PRICE_OTHER,listfind(CONVERT_STOCKS_ID,GET_SHIP_ROW.STOCK_ID[i],','),',');
				sepet.satir[i].other_money = listgetat(CONVERT_MONEY,listfind(CONVERT_STOCKS_ID,GET_SHIP_ROW.STOCK_ID[i],','),',');
			}	
			else{
				sepet.satir[i].other_money = OTHER_MONEY;
				if(len(PRICE_OTHER)) 
					sepet.satir[i].price_other = PRICE_OTHER; 
				else
					sepet.satir[i].price_other = PRICE;
			}
		//}
		sepet.satir[i].deliver_date = dateformat(DELIVER_DATE,dateformat_style);
		
		if(len(DELIVER_LOC)) 
			sepet.satir[i].deliver_dept = DELIVER_DEPT & "-" & DELIVER_LOC ; 
		else 
			sepet.satir[i].deliver_dept = DELIVER_DEPT ; 
		
		sepet.satir[i].spect_id = spect_var_id;
		sepet.satir[i].spect_name = spect_var_name;
		sepet.satir[i].lot_no = LOT_NO;
	
		if(len(tax)) sepet.satir[i].tax_percent =TAX; else sepet.satir[i].tax_percent=0;
		if(len(OTV_ORAN)) sepet.satir[i].otv_oran = OTV_ORAN; else sepet.satir[i].otv_oran = 0;
		// kdv array
		kdv_flag = 0;
		for (k=1;k lte arraylen(sepet.kdv_array);k=k+1)
			{
			if (sepet.kdv_array[k][1] eq sepet.satir[i].tax_percent)
				{
				kdv_flag = 1;
				sepet.kdv_array[k][2] = sepet.kdv_array[k][2] + 0;
				if (ListFindNoCase(display_list, "otv_from_tax_price"))
					sepet.kdv_array[k][3] = sepet.kdv_array[k][3] + wrk_round((sepet.satir[i].row_nettotal+sepet.satir[i].row_otvtotal),basket_total_round_number);
				else
					sepet.kdv_array[k][3] = sepet.kdv_array[k][3] + wrk_round(sepet.satir[i].row_nettotal,basket_total_round_number);		
				}
			}
		if (not kdv_flag)
			{
			sepet.kdv_array[arraylen(sepet.kdv_array)+1][1] = sepet.satir[i].tax_percent;
			sepet.kdv_array[arraylen(sepet.kdv_array)][2] = 0;
			if (ListFindNoCase(display_list, "otv_from_tax_price"))
				sepet.kdv_array[arraylen(sepet.kdv_array)][3] = wrk_round((sepet.satir[i].row_nettotal+sepet.satir[i].row_otvtotal),basket_total_round_number);
			else
				sepet.kdv_array[arraylen(sepet.kdv_array)][3] = wrk_round(sepet.satir[i].row_nettotal,basket_total_round_number);
			}
		// ötv array
		otv_flag = 0;
		for (z=1;z lte arraylen(sepet.otv_array);z=z+1)
			{
			if (sepet.otv_array[z][1] eq sepet.satir[i].otv_oran)
				{
				otv_flag = 1;
				sepet.otv_array[z][2] = sepet.otv_array[z][2] + sepet.satir[i].row_otvtotal;
				}
			}
		if (not otv_flag)
			{
			sepet.otv_array[arraylen(sepet.otv_array)+1][1] = sepet.satir[i].otv_oran;
			sepet.otv_array[arraylen(sepet.otv_array)][2] = sepet.satir[i].row_otvtotal;
			}
		sepet.satir[i].assortment_array = ArrayNew(1);
		
		if(isdefined("LIST_PRICE") and len(LIST_PRICE)) sepet.satir[i].list_price = LIST_PRICE; else sepet.satir[i].list_price = PRICE;
		if(isdefined("PRICE_CAT") and len(PRICE_CAT)) sepet.satir[i].price_cat = PRICE_CAT; else  sepet.satir[i].price_cat = '';
		if(isdefined("CATALOG_ID") and len(CATALOG_ID)) sepet.satir[i].row_catalog_id = CATALOG_ID; else  sepet.satir[i].row_catalog_id = '';
		if(isdefined("NUMBER_OF_INSTALLMENT") and len(NUMBER_OF_INSTALLMENT)) sepet.satir[i].number_of_installment = NUMBER_OF_INSTALLMENT; else sepet.satir[i].number_of_installment = 0;
		if(isdefined("WIDTH_VALUE") and len(WIDTH_VALUE)) sepet.satir[i].row_width = WIDTH_VALUE; else sepet.satir[i].row_width = '';
		if(isdefined("DEPTH_VALUE") and len(DEPTH_VALUE)) sepet.satir[i].row_depth = DEPTH_VALUE; else  sepet.satir[i].row_depth = '';
		if(isdefined("HEIGHT_VALUE") and len(HEIGHT_VALUE)) sepet.satir[i].row_height = HEIGHT_VALUE; else  sepet.satir[i].row_height = '';
		if((isdefined("ROW_PROJECT_ID") and len(ROW_PROJECT_ID)) and (isdefined("PROJECT_HEAD") and len(PROJECT_HEAD)))
		{
			sepet.satir[i].row_project_id=ROW_PROJECT_ID;
			sepet.satir[i].row_project_name=PROJECT_HEAD;
		}
		else if(isdefined("CONVERT_ROW_PROJECT_ID") and isdefined("ROW_PROJECT_ID") and len(ROW_PROJECT_ID))
		{
			sepet.satir[i].row_project_id=ROW_PROJECT_ID;
			sepet.satir[i].row_project_name=GET_ROW_PROJECTS.PROJECT_HEAD[listfind(row_project_id_list_,ROW_PROJECT_ID)];
		}
		
		if(isdefined("BASKET_EMPLOYEE_ID") and len(BASKET_EMPLOYEE_ID)) sepet.satir[i].BASKET_EMPLOYEE_ID = BASKET_EMPLOYEE_ID; else  sepet.satir[i].BASKET_EMPLOYEE_ID = '';
		if(isdefined("BASKET_EMPLOYEE") and len(BASKET_EMPLOYEE)) sepet.satir[i].BASKET_EMPLOYEE = BASKET_EMPLOYEE; else  sepet.satir[i].BASKET_EMPLOYEE = '';
		
		/*Masraf Merkezi*/
		if(isDefined("EXPENSE_CENTER_ID") and Len(EXPENSE_CENTER_ID))
		{
			sepet.satir[i].row_exp_center_id = EXPENSE_CENTER_ID;
			sepet.satir[i].row_exp_center_name = EXPENSE;
		}

		//Aktivite Tipi
		if(isDefined("ACTIVITY_TYPE_ID") and Len(ACTIVITY_TYPE_ID))
			sepet.satir[i].row_activity_id = ACTIVITY_TYPE_ID;

		//Bütçe Kalemi
		if(isDefined("EXPENSE_ITEM_ID") and Len(EXPENSE_ITEM_ID))
		{
			sepet.satir[i].row_exp_item_id = EXPENSE_ITEM_ID;
			sepet.satir[i].row_exp_item_name = EXPENSE_ITEM_NAME;
		}

		//Muhasebe Kodu
		if(isDefined("ACC_CODE") and Len(ACC_CODE))
			sepet.satir[i].row_acc_code = ACC_CODE;
	</cfscript>
</cfoutput>
<cfscript>
	for (k=1;k lte arraylen(sepet.kdv_array);k=k+1)
		sepet.kdv_array[k][2] = wrk_round(sepet.kdv_array[k][3] * sepet.kdv_array[k][1] /100,basket_total_round_number);
	
	for (k=1;k lte arraylen(sepet.kdv_array);k=k+1)
		sepet.total_tax = sepet.total_tax + sepet.kdv_array[k][2];
		
	
	for (t=1;t lte arraylen(sepet.otv_array);t=t+1)
		sepet.total_otv = sepet.total_otv + wrk_round(sepet.otv_array[t][2],price_round_number);
	
	sepet.net_total = sepet.net_total + sepet.total_tax + sepet.total_otv;

</cfscript>
