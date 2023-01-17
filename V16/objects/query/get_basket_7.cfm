<cfif isdefined('attributes.type') and len(CONVERT_STOCKS_ID)><!--- Üretim Malzeme İhtiyaçları listesinden dönüşüm yapılıyorsa --->
	<cfset GET_UPD_PURCHASE.OTHER_MONEY = '#session.ep.money2#'>
	<cfset deliver_date =""><!--- Üretim Malzeme İhtiyaçları listesinden dönüşüm yapılıyorsa --->
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
	<cfif isDefined("attributes.CONVERT_LIST_PRICE")>
		<cfset CONVERT_LIST_PRICE = left(attributes.CONVERT_LIST_PRICE, len(attributes.CONVERT_LIST_PRICE)-1)>
	<cfelse>
		<cfset CONVERT_LIST_PRICE = "">
	</cfif>
	<cfif isDefined("attributes.CONVERT_MONEY_TYPE") AND len(attributes.CONVERT_MONEY_TYPE)>
		<cfset CONVERT_MONEY_TYPE = left(attributes.CONVERT_MONEY_TYPE, len(attributes.CONVERT_MONEY_TYPE)-1)>
	<cfelse>
		<cfset CONVERT_MONEY_TYPE = "">
	</cfif>
	<cfquery name="GET_INTERNALDEMAND_PRODUCTS" datasource="#DSN3#">
		SELECT
			S.PRODUCT_ID,
			S.STOCK_ID,
			S.MANUFACT_CODE AS PRODUCT_MANUFACT_CODE,
			S.PROPERTY,
			S.BARCOD,
			S.STOCK_CODE,
			S.PRODUCT_NAME+' - '+ISNULL(S.PROPERTY,'') PRODUCT_NAME,
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
			'' AS DELIVER_LOCATION,
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
			'' AS UNIQUE_RELATION_ID,
			'' AS PROM_RELATION_ID,
			'' AS PRODUCT_NAME2,
			'' AS UNIT2,
			'' AS SHELF_NUMBER,
			'' AS BASKET_EXTRA_INFO_ID,
			'' SELECT_INFO_EXTRA,
			'' DETAIL_INFO_EXTRA,
			0 AS DISCOUNT_1,
			0 AS DISCOUNT_2,
			0 AS DISCOUNT_3,
			0 AS DISCOUNT_4,
			0 AS DISCOUNT_5,
			0 AS DISCOUNT_6,
			0 AS DISCOUNT_7,
			0 AS DISCOUNT_8,
			0 AS DISCOUNT_9,
			0 AS DISCOUNT_10,
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
			'' OIV_RATE,
			'' OIV_AMOUNT,
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
<cfelseif isdefined("attributes.ID")>
	<cfquery name="GET_INTERNALDEMAND_PRODUCTS" datasource="#dsn3#">
		SELECT 
			IR.* ,
			S.IS_INVENTORY,
			S.IS_PRODUCTION,
			S.PRODUCT_NAME,
			S.PROPERTY,
			S.BARCOD,
			S.STOCK_CODE,
			S.MANUFACT_CODE,
			S.STOCK_CODE_2,
			EXC.EXPENSE,
        	EXI.EXPENSE_ITEM_NAME
		FROM 
			INTERNALDEMAND_ROW IR
			LEFT JOIN #dsn2#.EXPENSE_CENTER AS EXC ON IR.EXPENSE_CENTER_ID = EXC.EXPENSE_ID
        	LEFT JOIN #dsn2#.EXPENSE_ITEMS AS EXI ON IR.EXPENSE_ITEM_ID = EXI.EXPENSE_ITEM_ID,
			STOCKS S
		WHERE 
			IR.I_ID = #attributes.ID#
			AND IR.STOCK_ID=S.STOCK_ID
		ORDER BY
			IR.I_ROW_ID
	</cfquery>
<cfelse>
	<cfset GET_INTERNALDEMAND_PRODUCTS.recordcount = 0>
</cfif>
<cfset satir_serino_index = 1>
<cfif GET_INTERNALDEMAND_PRODUCTS.recordcount>
	<cfset row_project_id_list_=listsort(ListDeleteDuplicates(valuelist(GET_INTERNALDEMAND_PRODUCTS.ROW_PROJECT_ID)),'numeric','asc',',')>
	<cfif len(row_project_id_list_)>
		<cfquery name="GET_ROW_PROJECTS" datasource="#dsn#">
			SELECT PROJECT_HEAD,PROJECT_ID FROM PRO_PROJECTS WHERE PROJECT_ID IN (#row_project_id_list_#) ORDER BY PROJECT_ID
		</cfquery>
		<cfset row_project_id_list_=valuelist(GET_ROW_PROJECTS.PROJECT_ID)>
	</cfif>
    <cfset row_work_id_list_=listsort(ListDeleteDuplicates(valuelist(GET_INTERNALDEMAND_PRODUCTS.ROW_WORK_ID)),'numeric','asc',',')>
	<cfif len(row_work_id_list_)>
		<cfquery name="GET_ROW_WORKS" datasource="#dsn#">
			SELECT WORK_HEAD,WORK_ID FROM PRO_WORKS WHERE WORK_ID IN (#row_work_id_list_#) ORDER BY WORK_ID
		</cfquery>
		<cfset row_work_id_list_=valuelist(GET_ROW_WORKS.WORK_ID)>
	</cfif>
	<cfset row_employee_id_list_=listsort(ListDeleteDuplicates(valuelist(GET_INTERNALDEMAND_PRODUCTS.BASKET_EMPLOYEE_ID)),'numeric','asc',',')>
	<cfif len(row_employee_id_list_)>
		<cfquery name="GET_ROW_EMPLOYEE" datasource="#dsn#">
			SELECT EMPLOYEE_ID,EMPLOYEE_NAME +' '+ EMPLOYEE_SURNAME AS NAME FROM EMPLOYEES WHERE EMPLOYEE_ID IN (#row_employee_id_list_#) ORDER BY EMPLOYEE_ID
		</cfquery>
		<cfset row_employee_id_list_=valuelist(GET_ROW_EMPLOYEE.EMPLOYEE_ID)>
	</cfif>
</cfif>
<cfscript>
	sepet = StructNew();
	sepet.satir = ArrayNew(1);
	sepet.kdv_array = ArrayNew(2);
	sepet.total = 0;
	sepet.otv_array = ArrayNew(2);
	sepet.total_otv = 0;
	sepet.toplam_indirim = 0;
	sepet.total_tax = 0;
	sepet.net_total = 0;
	sepet.genel_indirim = 0;
</cfscript>
<cfif GET_INTERNALDEMAND_PRODUCTS.recordcount>	
	<cfoutput query="GET_INTERNALDEMAND_PRODUCTS">
		<cfscript>
		i = currentrow;
		sepet.satir[i] = StructNew();
		sepet.satir[i].action_row_id = GET_INTERNALDEMAND_PRODUCTS.I_ROW_ID;  //satır id si tutuluyor
		sepet.satir[i].product_id = PRODUCT_ID;
		sepet.satir[i].is_inventory = IS_INVENTORY;
		sepet.satir[i].is_production = IS_PRODUCTION;
		sepet.satir[i].product_name = PRODUCT_NAME;
		if(len(PRO_MATERIAL_ID))
			sepet.satir[i].row_ship_id=PRO_MATERIAL_ID;
	
		if (isdefined('attributes.type')) //Üretim planlamadaki malzeme listesinde seçilen ürünlerin miktarlarınıda alır.
			sepet.satir[i].amount  = listgetat(CONVERT_AMOUNT_STOCKS_ID,listfind(CONVERT_STOCKS_ID,GET_INTERNALDEMAND_PRODUCTS.STOCK_ID[i],','),',');
		else
			sepet.satir[i].amount = QUANTITY;
		
		//Ic Talep Kopyalandiginda WRK_ROW_ID de kopyalaniyordu, bu sekilde duzenlendi, sorun olursa duzeltin fbs 20120724
		if(isDefined("attributes.id") and (isdefined("attributes.event") and attributes.event is 'add'))
			sepet.satir[i].wrk_row_id ="WRK#i##round(rand()*65)##dateformat(now(),'YYYYMMDD')##timeformat(now(),'HHmmssL')##session.ep.userid##round(rand()*100)##i#";
		else if(len(WRK_ROW_ID))
			sepet.satir[i].wrk_row_id =WRK_ROW_ID;
		else
			sepet.satir[i].wrk_row_id ="WRK#i##round(rand()*65)##dateformat(now(),'YYYYMMDD')##timeformat(now(),'HHmmssL')##session.ep.userid##round(rand()*100)##i#";
		
		if(isDefined("attributes.id") and (isdefined("attributes.event") and attributes.event is 'add'))
			sepet.satir[i].wrk_row_relation_id ="";
		else if(len(WRK_ROW_RELATION_ID))
			sepet.satir[i].wrk_row_relation_id=WRK_ROW_RELATION_ID;
		else
			sepet.satir[i].wrk_row_relation_id ="";
			
		sepet.satir[i].unit = unit;
		sepet.satir[i].unit_id = unit_id;
		sepet.satir[i].stock_id = STOCK_ID;
		sepet.satir[i].barcode = BARCOD;
		sepet.satir[i].special_code = STOCK_CODE_2;
		sepet.satir[i].stock_code = STOCK_CODE;
		sepet.satir[i].manufact_code = PRODUCT_MANUFACT_CODE;
		sepet.satir[i].pbs_id = PBS_ID;
		sepet.satir[i].duedate = DUEDATE;
		sepet.satir[i].paymethod_id = "";
		sepet.satir[i].spect_id = spect_var_id;
		sepet.satir[i].spect_name = spect_var_name;
		sepet.satir[i].lot_no = LOT_NO;
		if (isdefined("attributes.convert_date_list"))
			sepet.satir[i].deliver_date =  listgetat(attributes.convert_date_list,listfind(CONVERT_STOCKS_ID,GET_INTERNALDEMAND_PRODUCTS.STOCK_ID[i],','),',');
		else
			sepet.satir[i].deliver_date = dateformat(DELIVER_DATE,dateformat_style);
		sepet.satir[i].deliver_dept = "#deliver_dept#-#deliver_location#";
		sepet.satir[i].assortment_array = ArrayNew(1);	
		
		if (isdefined('attributes.type') and isdefined("CONVERT_MONEY")){//Üretim planlamadaki malzeme listesinde seçilen ürünlerin miktarlarınıda alır.
			sepet.satir[i].price_other = listgetat(CONVERT_PRICE_OTHER,listfind(CONVERT_STOCKS_ID,GET_INTERNALDEMAND_PRODUCTS.STOCK_ID[i],','),',');
			sepet.satir[i].other_money_value = listgetat(CONVERT_PRICE_OTHER,listfind(CONVERT_STOCKS_ID,GET_INTERNALDEMAND_PRODUCTS.STOCK_ID[i],','),',');
			sepet.satir[i].other_money = listgetat(CONVERT_MONEY,listfind(CONVERT_STOCKS_ID,GET_INTERNALDEMAND_PRODUCTS.STOCK_ID[i],','),',');
		}	
		else{
			sepet.satir[i].other_money = OTHER_MONEY;
			sepet.satir[i].other_money_value = OTHER_MONEY_VALUE;
			if(len(PRICE_OTHER)) 
				sepet.satir[i].price_other = PRICE_OTHER; 
			else
				sepet.satir[i].price_other = PRICE;
		}
		if (isdefined('attributes.type') and isdefined("attributes.CONVERT_MONEY"))
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
		if(len(DISCOUNT_1))sepet.satir[i].indirim1 = DISCOUNT_1;else sepet.satir[i].indirim1 = 0;
		if(len(DISCOUNT_2))sepet.satir[i].indirim2 = DISCOUNT_2;else sepet.satir[i].indirim2 = 0;
		if(len(DISCOUNT_3))sepet.satir[i].indirim3 = DISCOUNT_3;else sepet.satir[i].indirim3 = 0;
		if(len(DISCOUNT_4))sepet.satir[i].indirim4 = DISCOUNT_4;else sepet.satir[i].indirim4 = 0;
		if(len(DISCOUNT_5))sepet.satir[i].indirim5 = DISCOUNT_5;else sepet.satir[i].indirim5 = 0;
		if(len(DISCOUNT_6))sepet.satir[i].indirim6 = DISCOUNT_6;else sepet.satir[i].indirim6 = 0;
		if(len(DISCOUNT_7))sepet.satir[i].indirim7 = DISCOUNT_7;else sepet.satir[i].indirim7 = 0;
		if(len(DISCOUNT_8))sepet.satir[i].indirim8 = DISCOUNT_8;else sepet.satir[i].indirim8 = 0;
		if(len(DISCOUNT_9))sepet.satir[i].indirim9 = DISCOUNT_9;else sepet.satir[i].indirim9 = 0;
		if(len(DISCOUNT_10))sepet.satir[i].indirim10 = DISCOUNT_10;else sepet.satir[i].indirim10 = 0;
		
		if(len(TAX))sepet.satir[i].tax_percent = TAX; else sepet.satir[i].tax_percent = 0;
		if(len(OTV_ORAN)) sepet.satir[i].otv_oran = OTV_ORAN; else sepet.satir[i].otv_oran = 0;
		if(len(OTVTOTAL))sepet.satir[i].row_otvtotal =OTVTOTAL;else sepet.satir[i].row_otvtotal = 0;
		sepet.satir[i].indirim_carpan = (100-sepet.satir[i].indirim1) * (100-sepet.satir[i].indirim2) * (100-sepet.satir[i].indirim3) * (100-sepet.satir[i].indirim4) * (100-sepet.satir[i].indirim5) * (100-sepet.satir[i].indirim6) * (100-sepet.satir[i].indirim7) * (100-sepet.satir[i].indirim8) * (100-sepet.satir[i].indirim9) * (100-sepet.satir[i].indirim10);
		if(len(EXTRA_PRICE_TOTAL)) sepet.satir[i].ek_tutar_total = EXTRA_PRICE_TOTAL; else sepet.satir[i].ek_tutar_total = 0;
		if(len(EXTRA_PRICE_OTHER_TOTAL)) sepet.satir[i].ek_tutar_other_total = EXTRA_PRICE_OTHER_TOTAL; else sepet.satir[i].ek_tutar_other_total = 0;
		sepet.satir[i].row_total = (sepet.satir[i].amount*sepet.satir[i].price)+sepet.satir[i].ek_tutar_total;
		//sepet.satir[i].row_total = sepet.satir[i].amount * sepet.satir[i].price;
		if(len(NETTOTAL))
			sepet.satir[i].row_nettotal = NETTOTAL;
		else
			sepet.satir[i].row_nettotal = wrk_round((sepet.satir[i].row_total/100000000000000000000) * sepet.satir[i].indirim_carpan,price_round_number);
		if(len(TAXTOTAL))
			sepet.satir[i].row_taxtotal =TAXTOTAL;
		else
			sepet.satir[i].row_taxtotal = wrk_round(sepet.satir[i].row_nettotal * (sepet.satir[i].tax_percent/100),price_round_number);
		
		sepet.satir[i].row_oiv_rate = ( len( OIV_RATE ) ) ? OIV_RATE : '';
		sepet.satir[i].row_oiv_amount = ( len( OIV_AMOUNT ) ) ? OIV_AMOUNT : 0;
		sepet.satir[i].row_lasttotal = sepet.satir[i].row_nettotal + sepet.satir[i].row_taxtotal+sepet.satir[i].row_otvtotal;
		if (not isdefined('attributes.type')){ //malzeme ihtiyaç listesinden gelmiyor ise...
		sepet.satir[i].other_money =OTHER_MONEY;
		sepet.satir[i].other_money_value = OTHER_MONEY_VALUE;
		}
		sepet.satir[i].other_money_grosstotal = sepet.satir[i].row_lasttotal;
		if(len(COST_PRICE)) sepet.satir[i].net_maliyet = COST_PRICE; else sepet.satir[i].net_maliyet=0;
		if(len(MARJ)) sepet.satir[i].marj = MARJ; else sepet.satir[i].marj = 0;
		if(len(EXTRA_COST)) sepet.satir[i].extra_cost = EXTRA_COST; else sepet.satir[i].extra_cost =0;
		//iscilik birim ucretinden maliyet ve ektutar hesaplaması iscilik marj oranı dahil edilerek
		if(len(AMOUNT2)) sepet.satir[i].amount_other = AMOUNT2; else sepet.satir[i].amount_other = "";
		if(len(EXTRA_PRICE)) sepet.satir[i].ek_tutar = EXTRA_PRICE;	else sepet.satir[i].ek_tutar = 0;
		if(len(WIDTH_VALUE[i])) sepet.satir[i].row_width = WIDTH_VALUE[i]; else sepet.satir[i].row_width = '';
		if(len(DEPTH_VALUE[i])) sepet.satir[i].row_depth = DEPTH_VALUE[i]; else  sepet.satir[i].row_depth = '';
		if(len(HEIGHT_VALUE[i])) sepet.satir[i].row_height = HEIGHT_VALUE[i]; else  sepet.satir[i].row_height = '';
		if(len(ROW_PROJECT_ID[i]))
		{
			sepet.satir[i].row_project_id=ROW_PROJECT_ID[i];
			sepet.satir[i].row_project_name=GET_ROW_PROJECTS.PROJECT_HEAD[listfind(row_project_id_list_,ROW_PROJECT_ID[i])];
		}
		if(len(ROW_WORK_ID[i]))
		{
			sepet.satir[i].row_work_id=ROW_WORK_ID[i];
			sepet.satir[i].row_work_name=GET_ROW_WORKS.WORK_HEAD[listfind(row_work_id_list_,ROW_WORK_ID[i])];
		}
		if(len(BASKET_EMPLOYEE_ID[i]))
		{
			sepet.satir[i].basket_employee_id=BASKET_EMPLOYEE_ID[i];
			sepet.satir[i].basket_employee=GET_ROW_EMPLOYEE.NAME[listfind(row_employee_id_list_,BASKET_EMPLOYEE_ID[i])];
		}
		
		if(len(EK_TUTAR_PRICE))
		{
			sepet.satir[i].ek_tutar_price = EK_TUTAR_PRICE;
			if(len(AMOUNT2)) sepet.satir[i].ek_tutar_cost = EK_TUTAR_PRICE*AMOUNT2; else sepet.satir[i].ek_tutar_cost = EK_TUTAR_PRICE;
		}
		else
		{ sepet.satir[i].ek_tutar_price = 0;sepet.satir[i].ek_tutar_cost =0;}
	
		if(len(sepet.satir[i].ek_tutar_cost) and sepet.satir[i].ek_tutar_cost neq 0)
			sepet.satir[i].ek_tutar_marj = (sepet.satir[i].ek_tutar*100/sepet.satir[i].ek_tutar_cost)-100;
		else
			sepet.satir[i].ek_tutar_marj ='';
		//iscilik birim ucretinden maliyet ve ektutar hesaplaması iscilik marj oranı dahil edilerek
		if(len(UNIQUE_RELATION_ID)) sepet.satir[i].row_unique_relation_id = UNIQUE_RELATION_ID; else sepet.satir[i].row_unique_relation_id = "";
		if(len(PROM_RELATION_ID)) sepet.satir[i].prom_relation_id = PROM_RELATION_ID; else sepet.satir[i].prom_relation_id = "";
		if(len(PRODUCT_NAME2)) sepet.satir[i].product_name_other = PRODUCT_NAME2; else sepet.satir[i].product_name_other = "";
		if(len(UNIT2)) sepet.satir[i].unit_other = UNIT2; else sepet.satir[i].unit_other = "";
		if(len(SHELF_NUMBER)) sepet.satir[i].shelf_number = SHELF_NUMBER; else sepet.satir[i].shelf_number = "";
		if(len(BASKET_EXTRA_INFO_ID)) sepet.satir[i].basket_extra_info = BASKET_EXTRA_INFO_ID; else sepet.satir[i].basket_extra_info="";
		if(len(SELECT_INFO_EXTRA)) sepet.satir[i].select_info_extra = SELECT_INFO_EXTRA; else sepet.satir[i].select_info_extra="";
		if(len(DETAIL_INFO_EXTRA)) sepet.satir[i].detail_info_extra = DETAIL_INFO_EXTRA; else sepet.satir[i].detail_info_extra="";
		sepet.satir[i].iskonto_tutar = DISCOUNT_COST;
	
		
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
					//writeoutput(sepet.kdv_array[k][3]);
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
				
			
			
		// otv array
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
		
		
		if(isDefined("CONVERT_MONEY_TYPE") and len(CONVERT_MONEY_TYPE)) sepet.satir[i].other_money = listgetat(CONVERT_MONEY_TYPE,listfind(CONVERT_STOCKS_ID,GET_INTERNALDEMAND_PRODUCTS.STOCK_ID[i],','),',');
		

		if(len(PRICE_CAT)) sepet.satir[i].price_cat = PRICE_CAT; else  sepet.satir[i].price_cat = '';
		if(len(CATALOG_ID)) sepet.satir[i].row_catalog_id = CATALOG_ID; else  sepet.satir[i].row_catalog_id = '';
		if(len(NUMBER_OF_INSTALLMENT)) sepet.satir[i].number_of_installment = NUMBER_OF_INSTALLMENT; else sepet.satir[i].number_of_installment = 0;
		
		sepet.net_total = sepet.net_total + sepet.satir[i].row_nettotal; //nettotal_
		sepet.total = sepet.total + wrk_round(sepet.satir[i].row_total,basket_total_round_number); //subtotal_
		sepet.toplam_indirim = sepet.toplam_indirim + (wrk_round(sepet.satir[i].row_total,price_round_number) - wrk_round(sepet.satir[i].row_nettotal,price_round_number)); //discount_
		if (isdefined("attributes.ID"))
		{
			/*Masraf Merkezi*/
			if( len(GET_INTERNALDEMAND_PRODUCTS.EXPENSE_CENTER_ID[i]) )
			{
				sepet.satir[i].row_exp_center_id = GET_INTERNALDEMAND_PRODUCTS.EXPENSE_CENTER_ID[i];
				sepet.satir[i].row_exp_center_name = GET_INTERNALDEMAND_PRODUCTS.EXPENSE[i];
			}

			//Aktivite Tipi
			sepet.satir[i].row_activity_id = GET_INTERNALDEMAND_PRODUCTS.ACTIVITY_TYPE_ID[i];

			//Bütçe Kalemi
			if( len(GET_INTERNALDEMAND_PRODUCTS.EXPENSE_ITEM_ID[i]) )
			{
				sepet.satir[i].row_exp_item_id = GET_INTERNALDEMAND_PRODUCTS.EXPENSE_ITEM_ID[i];
				sepet.satir[i].row_exp_item_name = GET_INTERNALDEMAND_PRODUCTS.EXPENSE_ITEM_NAME[i];
			}

			//Muhasebe Kodu
			if(len(GET_INTERNALDEMAND_PRODUCTS.ACC_CODE[i]))
			{
				sepet.satir[i].row_acc_code = GET_INTERNALDEMAND_PRODUCTS.ACC_CODE[i];
			}
		}
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
	<cfif isdefined('attributes.type') and isdefined("convert_spect_id") and len(convert_spect_id)>
		<cfoutput query="GET_INTERNALDEMAND_PRODUCTS">
			<cfset spect_main_id_row = listgetat(convert_spect_id,listfind(CONVERT_STOCKS_ID,GET_INTERNALDEMAND_PRODUCTS.STOCK_ID[currentrow],','),',')>
			<cfif len(spect_main_id_row) and spect_main_id_row gt 0>
				<cfscript>
					new_cre_spect_id = specer(
						dsn_type:dsn3,
						add_to_main_spec:1,
						main_spec_id:spect_main_id_row
					);
				</cfscript>
				<cfif isdefined("new_cre_spect_id") and len(new_cre_spect_id)>
					<cfset sepet.satir[currentrow].spect_id = listgetat(new_cre_spect_id,2,',')>
					<cfset sepet.satir[currentrow].spect_name = listgetat(new_cre_spect_id,3,',')>
				</cfif>
			</cfif>
		</cfoutput>
	</cfif>
</cfif>
