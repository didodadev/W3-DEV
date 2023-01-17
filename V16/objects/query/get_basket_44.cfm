<cfif isdefined('attributes.type') and len(attributes.CONVERT_STOCKS_ID)><!--- Rapordan dönüşüm yapılıyorsa --->
	<cfset GET_SHIP_ROW.OTHER_MONEY = '#session.ep.money2#'>
	<cfset deliver_date =""><!--- Rapordan dönüşüm yapılıyorsa --->
	<cfset CONVERT_STOCKS_ID = left(attributes.CONVERT_STOCKS_ID,len(attributes.CONVERT_STOCKS_ID)-1)>
	<cfif isdefined("attributes.convert_date_list")>
		<cfset convert_date_list = left(attributes.convert_date_list,len(attributes.convert_date_list)-1)>
	</cfif>
	<cfset CONVERT_STOCKS_ID = left(attributes.CONVERT_STOCKS_ID,len(attributes.CONVERT_STOCKS_ID)-1)>
	<cfif isdefined("attributes.CONVERT_MONEY")>
		<cfset CONVERT_MONEY = left(attributes.CONVERT_MONEY,len(attributes.CONVERT_MONEY)-1)>
		<cfset CONVERT_PRICE = left(attributes.CONVERT_PRICE,len(attributes.CONVERT_PRICE)-1)>
		<cfset CONVERT_PRICE_OTHER = left(attributes.CONVERT_PRICE_OTHER,len(attributes.CONVERT_PRICE_OTHER)-1)>
	</cfif>
    <cfquery name="GET_SHIP_ROW" datasource="#DSN3#">
		SELECT
			S.PRODUCT_ID,
			S.STOCK_ID,
			S.MANUFACT_CODE AS PRODUCT_MANUFACT_CODE,
			S.PROPERTY,
			S.BARCOD,
			S.STOCK_CODE,
			S.PRODUCT_NAME+' - '+ISNULL(S.PROPERTY,'') NAME_PRODUCT,
			S.IS_INVENTORY,
			S.IS_PRODUCTION,
			S.STOCK_CODE_2,
			S.TAX,
			S.TAX_PURCHASE,
			PRODUCT_UNIT.MAIN_UNIT AS UNIT,
			PRODUCT_UNIT.PRODUCT_UNIT_ID AS UNIT_ID,
			PS.PRICE,
			PS.MONEY AS OTHER_MONEY,
			0 AS OTHER_MONEY_VALUE,
			'' AS PRODUCT_NAME2,
			'' AS DELIVER_DEPT,
			'' AS DELIVER_LOC,
			'' AS SPECT_VAR_ID,
			'' AS SPECT_VAR_NAME,
			'' AS LOT_NO,
			'' AS I_ROW_ID,
			0 AS PRICE_OTHER,
			'' AS NETTOTAL,
			'' AS NET_TOTAL,
			'' AS TOTAL_TAX,
			0 AS OTV_ORAN,
			0 AS OTVTOTAL,
			'' AS TAXTOTAL,
			0 AS COST_PRICE,
			'' AS MARJ,
			0 AS EXTRA_COST,
			0 AS DISCOUNT_COST,
			0 AS AMOUNT2,
			0 AS EXTRA_PRICE,
			0 AS EK_TUTAR_PRICE,
			0 AS EXTRA_PRICE_TOTAL,
			0 AS EXTRA_PRICE_OTHER_TOTAL,
            0 AS OTHER_MONEY_GROSS_TOTAL,
			'' AS UNIQUE_RELATION_ID,
			'' AS PROM_RELATION_ID,
			'' AS PRODUCT_NAME2,
			'' AS UNIT2,
			'' AS SHELF_NUMBER,
			'' AS BASKET_EXTRA_INFO_ID,
			'' SELECT_INFO_EXTRA,
			'' DETAIL_INFO_EXTRA,
            0 AS DISCOUNT,
			0 AS DISCOUNT1,
			0 AS DISCOUNT2,
			0 AS DISCOUNT3,
			0 AS DISCOUNT4,
			0 AS DISCOUNT5,
			0 AS DISCOUNT6,
			0 AS DISCOUNT7,
			0 AS DISCOUNT8,
			0 AS DISCOUNT9,
			0 AS DISCOUNT10,
			'' AS PRO_MATERIAL_ID,
			'' AS WRK_ROW_ID,
			'' AS WRK_ROW_RELATION_ID,
			'' AS WIDTH_VALUE,
			'' AS DEPTH_VALUE,
			'' AS HEIGHT_VALUE,
			'' AS ROW_PROJECT_ID,
			'' AS LIST_PRICE,
			'' AS CATALOG_ID,
			'' AS NUMBER_OF_INSTALLMENT,
			'' PBS_ID,
			'' BASKET_EMPLOYEE_ID,
            '' ROW_WORK_ID,
            '' DUEDATE,
            '' PAYMETHOD_ID,
			<cfif isdefined("attributes.price_catid") and len(attributes.price_catid)>
				ISNULL((SELECT PP.PRICE FROM PRICE PP WHERE PP.PRODUCT_ID = S.PRODUCT_ID AND PP.PRICE_CATID = #attributes.price_catid# AND (PP.STARTDATE <=#now()# AND (PP.FINISHDATE IS NULL OR PP.FINISHDATE >=#now()#))),0) PRICE,
				#attributes.price_catid# PRICE_CAT
			<cfelse>	
				0 PRICE,
				'' PRICE_CAT
			</cfif>
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
<cfelse>
    <cfquery name="GET_SHIP_ROW" datasource="#dsn2#">		
		 SELECT
			*
			<cfif isdefined("attributes.dispatch_ship_id")>
			,(
				SELECT
					CASE 
						WHEN SUM(SHIP_ROW.AMOUNT) > 0 THEN SHIP_INTERNAL_ROW.AMOUNT - SUM(SHIP_ROW.AMOUNT)
						ELSE SHIP_INTERNAL_ROW.AMOUNT
					END AS SSSSAMOUNT
				FROM SHIP JOIN SHIP_ROW ON SHIP.SHIP_ID = SHIP_ROW.SHIP_ID AND SHIP_INTERNAL_ROW.STOCK_ID = SHIP_ROW.STOCK_ID
				WHERE SHIP.DISPATCH_SHIP_ID = <cfqueryparam value = "#attributes.dispatch_ship_id#" CFSQLType = "cf_sql_integer">
				GROUP BY SHIP.DISPATCH_SHIP_ID
			) AS DISPATCHED_AMOUNT
			</cfif>
		FROM 
			SHIP_INTERNAL_ROW
		WHERE 
			DISPATCH_SHIP_ID = <cfqueryparam value = "#attributes.ship_id#" CFSQLType = "cf_sql_integer">
			<cfif isDefined("attributes.dispatch_ship_id") and len(attributes.dispatch_ship_id)>
				AND AMOUNT NOT IN (SELECT
						SHIP_ROW.AMOUNT
					FROM SHIP JOIN SHIP_ROW ON SHIP.SHIP_ID = SHIP_ROW.SHIP_ID
					WHERE SHIP.DISPATCH_SHIP_ID = <cfqueryparam value = "#attributes.dispatch_ship_id#" CFSQLType = "cf_sql_integer">
					GROUP BY SHIP_ROW.AMOUNT)
			</cfif>
		ORDER BY
			SHIP_ROW_ID
	</cfquery>
	
</cfif>

<cfset row_project_id_list_=listsort(ListDeleteDuplicates(valuelist(GET_SHIP_ROW.ROW_PROJECT_ID)),'numeric','asc',',')>
<cfset satir_serino_index = 1>
<cfif len(row_project_id_list_)>
	<cfquery name="GET_ROW_PROJECTS" datasource="#dsn#">
		SELECT PROJECT_HEAD,PROJECT_ID FROM PRO_PROJECTS WHERE PROJECT_ID IN (#row_project_id_list_#) ORDER BY PROJECT_ID
	</cfquery>
	<cfset row_project_id_list_=valuelist(GET_ROW_PROJECTS.PROJECT_ID)>
</cfif>
<cfscript>
	sepet = StructNew();
	sepet.satir = ArrayNew(1);
	sepet.kdv_array = ArrayNew(2);
	sepet.total = 0;
	sepet.toplam_indirim = 0;
	sepet.total_tax = 0;
	sepet.net_total = 0;
	sepet.genel_indirim = 0;
</cfscript>
<cfoutput query="GET_SHIP_ROW">
	<cfquery name="GET_PRODUCT_NAME" datasource="#dsn3#">
		SELECT
			PRODUCT_ID,
			IS_INVENTORY,
			IS_PRODUCTION,
			BARCOD,
			STOCK_CODE,
			MANUFACT_CODE,
			STOCK_CODE_2
		FROM
			STOCKS
		WHERE
			STOCK_ID=#STOCK_ID#
	</cfquery>
	<cfscript>
	i = currentrow;
	sepet.satir[i] = StructNew();
	
	sepet.satir[i].wrk_row_id="WRK#i##round(rand()*65)##dateformat(now(),'YYYYMMDD')##timeformat(now(),'HHmmssL')##session.ep.userid##round(rand()*100)##i#";
	sepet.satir[i].wrk_row_relation_id ='';

	sepet.satir[i].product_id = GET_PRODUCT_NAME.product_id;
	sepet.satir[i].is_inventory = GET_PRODUCT_NAME.is_inventory;
	sepet.satir[i].is_production = GET_PRODUCT_NAME.is_production;
	sepet.satir[i].product_name = name_product;
	//sepet.satir[i].amount = amount;
	sepet.satir[i].unit = unit;
	sepet.satir[i].unit_id = unit_id;
	if( len(UNIT2) ) sepet.satir[i].unit_other = UNIT2; else sepet.satir[i].unit_other = "";
	if( len(AMOUNT2) ) sepet.satir[i].amount_other = AMOUNT2; else sepet.satir[i].amount_other = "";
	sepet.satir[i].price = price;	
	if (isdefined('attributes.type')) //Üretim planlamadaki malzeme listesinde seçilen ürünlerin miktarlarınıda alır.
		sepet.satir[i].amount  = listgetat(CONVERT_AMOUNT_STOCKS_ID,listfind(CONVERT_STOCKS_ID,GET_SHIP_ROW.STOCK_ID[i],','),',');
	else{
		if (isdefined("attributes.dispatch_ship_id")){
			sepet.satir[i].amount = iif(len(DISPATCHED_AMOUNT),DISPATCHED_AMOUNT,DE(amount));
		}else
			sepet.satir[i].amount = amount;
	}

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
	sepet.satir[i].indirim_carpan = (100-sepet.satir[i].indirim1) * (100-sepet.satir[i].indirim2) * (100-sepet.satir[i].indirim3) * (100-sepet.satir[i].indirim4) * (100-sepet.satir[i].indirim5) * (100-sepet.satir[i].indirim6) * (100-sepet.satir[i].indirim7) * (100-sepet.satir[i].indirim8) * (100-sepet.satir[i].indirim9) * (100-sepet.satir[i].indirim10);
	sepet.satir[i].net_maliyet = 0;	
	sepet.satir[i].marj = 0;
	if(len(tax))sepet.satir[i].tax_percent = tax;else sepet.satir[i].tax_percent = 0;
	sepet.satir[i].paymethod_id = paymethod_id;
	sepet.satir[i].stock_id = stock_id;
	sepet.satir[i].barcode = GET_PRODUCT_NAME.BARCOD;
	sepet.satir[i].special_code = GET_PRODUCT_NAME.STOCK_CODE_2;
	sepet.satir[i].stock_code = GET_PRODUCT_NAME.STOCK_CODE;
	sepet.satir[i].manufact_code = PRODUCT_MANUFACT_CODE;
	sepet.satir[i].duedate = "";
	//sepet.satir[i].row_total = amount*price;
	sepet.satir[i].row_total = sepet.satir[i].amount * sepet.satir[i].price;
	sepet.satir[i].row_nettotal = wrk_round((sepet.satir[i].row_total/100000000000000000000) * sepet.satir[i].indirim_carpan,price_round_number);
	sepet.satir[i].row_taxtotal = wrk_round(sepet.satir[i].row_nettotal * (sepet.satir[i].tax_percent/100),price_round_number);
	sepet.satir[i].row_lasttotal = sepet.satir[i].row_nettotal + sepet.satir[i].row_taxtotal;
	sepet.total = sepet.total + wrk_round(sepet.satir[i].row_total,basket_total_round_number); //subtotal_
	sepet.toplam_indirim = sepet.toplam_indirim + (wrk_round(sepet.satir[i].row_total,price_round_number) - wrk_round(sepet.satir[i].row_nettotal,price_round_number)); //discount_
	sepet.net_total = sepet.net_total + sepet.satir[i].row_nettotal; //nettotal_

	sepet.satir[i].other_money = OTHER_MONEY;
	if(len(OTHER_MONEY_VALUE))
		sepet.satir[i].other_money_value = OTHER_MONEY_VALUE;
	else
		sepet.satir[i].other_money_value =0;
	if(len(PRICE_OTHER))
		sepet.satir[i].price_other = PRICE_OTHER;
	else
		sepet.satir[i].price_other = PRICE;
	sepet.satir[i].other_money_grosstotal = OTHER_MONEY_GROSS_TOTAL;
	
	sepet.satir[i].deliver_date = dateformat(DELIVER_DATE,dateformat_style);
	
	if(len(DELIVER_LOC)) 
		sepet.satir[i].deliver_dept = DELIVER_DEPT & "-" & DELIVER_LOC ; 
	else 
		sepet.satir[i].deliver_dept = DELIVER_DEPT ; 
	
	sepet.satir[i].spect_id = spect_var_id;
	sepet.satir[i].spect_name = spect_var_name;
	sepet.satir[i].lot_no = LOT_NO;
	if(len(ROW_PROJECT_ID))
	{
		sepet.satir[i].row_project_id=ROW_PROJECT_ID;
		sepet.satir[i].row_project_name=GET_ROW_PROJECTS.PROJECT_HEAD[listfind(row_project_id_list_,ROW_PROJECT_ID)];
	}
	if(len(BASKET_EXTRA_INFO_ID)) sepet.satir[i].basket_extra_info = BASKET_EXTRA_INFO_ID; else sepet.satir[i].basket_extra_info="";
	if(len(SELECT_INFO_EXTRA)) sepet.satir[i].select_info_extra = SELECT_INFO_EXTRA; else sepet.satir[i].select_info_extra="";
	if(len(DETAIL_INFO_EXTRA)) sepet.satir[i].detail_info_extra = DETAIL_INFO_EXTRA; else sepet.satir[i].detail_info_extra="";
	if(len(PRODUCT_NAME2)) sepet.satir[i].product_name_other = PRODUCT_NAME2; else sepet.satir[i].product_name_other = "";

	if(len(tax))
		{
		sepet.satir[i].tax_percent =TAX;
		}
	else
		{
		if(nettotal neq 0) 
			sepet.satir[i].tax_percent =(taxtotal/nettotal)*100; 
		else 
			sepet.satir[i].tax_percent=0;
		}

	// kdv array
		kdv_flag = 0;
		for (k=1;k lte arraylen(sepet.kdv_array);k=k+1)
			{
			if (sepet.kdv_array[k][1] eq sepet.satir[i].tax_percent)
				{
				kdv_flag = 1;
				sepet.kdv_array[k][2] = sepet.kdv_array[k][2] + 0;
				sepet.kdv_array[k][3] = sepet.kdv_array[k][3] + wrk_round(sepet.satir[i].row_nettotal,basket_total_round_number);			
				}
			}
		if (not kdv_flag)
			{
			sepet.kdv_array[arraylen(sepet.kdv_array)+1][1] = sepet.satir[i].tax_percent;
			sepet.kdv_array[arraylen(sepet.kdv_array)][2] = 0;
			sepet.kdv_array[arraylen(sepet.kdv_array)][3] = wrk_round(sepet.satir[i].row_nettotal,basket_total_round_number);
			}
			
			
		sepet.satir[i].lot_no = "";
	sepet.satir[i].assortment_array = ArrayNew(1);
	</cfscript>
</cfoutput>
<cfscript>
	for (k=1;k lte arraylen(sepet.kdv_array);k=k+1)
		sepet.kdv_array[k][2] = wrk_round(sepet.kdv_array[k][3] * sepet.kdv_array[k][1] /100,basket_total_round_number);
	
	for (k=1;k lte arraylen(sepet.kdv_array);k=k+1)
		sepet.total_tax = sepet.total_tax + sepet.kdv_array[k][2];
		
	sepet.net_total = sepet.net_total + sepet.total_tax;
</cfscript>
