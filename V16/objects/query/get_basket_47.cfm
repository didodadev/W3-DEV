<cfif isdefined("attributes.ship_id")>
	<cfquery name="GET_SHIP_ROW" datasource="#dsn2#">
		SELECT
			SH.*,
			S.IS_INVENTORY,
			S.IS_PRODUCTION,
			S.STOCK_CODE,
			S.BARCOD,
			S.IS_SERIAL_NO,
			S.MANUFACT_CODE,
			S.STOCK_CODE_2
		FROM 
			SHIP_ROW SH,
			#dsn3_alias#.STOCKS S
		WHERE 
			SH.SHIP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ship_id#"> AND
			SH.STOCK_ID=S.STOCK_ID
		ORDER BY
			SH.SHIP_ROW_ID
	</cfquery>
<cfelse>
	<cfquery name="GET_SHIP_ROW" datasource="#dsn2#">
		SELECT  DISTINCT
			SH.*,
			SG.PROCESS_CAT,
			S.IS_INVENTORY,
			S.IS_PRODUCTION,
			S.STOCK_CODE,
			S.BARCOD,
			S.IS_SERIAL_NO,
			S.MANUFACT_CODE,
			S.STOCK_CODE_2
		FROM 
			SHIP_ROW SH,
			#dsn3_alias#.STOCKS S,
			#dsn3_alias#.SERVICE_GUARANTY_NEW SG,
			#dsn3_alias#.SERVICE SR
		WHERE 
			SR.SERVICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.service_id#"> AND
			SG.STOCK_ID = S.STOCK_ID AND
			S.STOCK_ID = SR.STOCK_ID AND
			SG.SERIAL_NO = SR.PRO_SERIAL_NO AND
			SH.SHIP_ID = SG.PROCESS_ID AND
			SG.PROCESS_CAT IN (70,71,72,83) AND
			SH.STOCK_ID = SG.STOCK_ID
		ORDER BY
			SH.SHIP_ROW_ID
	</cfquery>
	<cfif not GET_SHIP_ROW.recordcount>
		<cfquery name="GET_SHIP_ROW" datasource="#dsn3#">
			SELECT
				SR.LOCATION_ID AS DELIVER_LOC,
				SR.DEPARTMENT_ID AS DELIVER_DEPT,
				S.PRODUCT_ID,
				S.STOCK_ID,
				S.MANUFACT_CODE,
				S.PROPERTY,
				S.BARCOD,
				S.STOCK_CODE,
				S.PRODUCT_NAME AS NAME_PRODUCT,
				S.IS_INVENTORY,
				S.IS_PRODUCTION,
				S.TAX,
				S.TAX_PURCHASE,
				PRODUCT_UNIT.MAIN_UNIT_ID AS UNIT_ID,
				PRODUCT_UNIT.MAIN_UNIT AS UNIT,
				0 AS PRICE,
				1 AS AMOUNT,
				0 AS PRICE_OTHER,
				0 AS NETTOTAL,
				0 AS PRICE_KDV,
				0 AS TAXTOTAL,
				0 AS IS_SERIAL_NO,
				'#session.ep.money#' AS MONEY,
				'#session.ep.money#' AS OTHER_MONEY,
				0 AS OTHER_MONEY_GROSS_TOTAL,
				0 AS DISCOUNTTOTAL,
				0 AS DISCOUNT,
				0 AS DISCOUNT2,
				0 AS DISCOUNT3,
				0 AS DISCOUNT4,
				0 AS DISCOUNT5,
				0 AS DISCOUNT6,
				0 AS DISCOUNT7,
				0 AS DISCOUNT8,
				0 AS DISCOUNT9,
				0 AS DISCOUNT10,
				'' AS paymethod_id,
				#NOW()# AS DELIVER_DATE,
				'' AS WIDTH_VALUE,
				'' AS DEPTH_VALUE,
				'' AS HEIGHT_VALUE,
				'' AS ROW_PROJECT_ID,
				S.STOCK_CODE_2,
                '' AS WRK_ROW_ID 
			FROM
				STOCKS S,
				SERVICE SR,
				PRODUCT_UNIT
			WHERE
				SR.SERVICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.service_id#"> AND
				S.STOCK_ID = SR.STOCK_ID AND
				PRODUCT_UNIT.PRODUCT_ID = S.PRODUCT_ID AND
				PRODUCT_UNIT.PRODUCT_UNIT_ID = S.PRODUCT_UNIT_ID AND
				SR.LOCATION_ID IS NOT NULL
		</cfquery>
	</cfif>
</cfif>
<cfset row_project_id_list_=listsort(ListDeleteDuplicates(valuelist(GET_SHIP_ROW.ROW_PROJECT_ID)),'numeric','asc',',')>
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
	sepet.other_money = GET_SHIP_ROW.OTHER_MONEY;
</cfscript>
<cfoutput query="GET_SHIP_ROW">
	<cfscript>
	i = currentrow;
	sepet.satir[i] = StructNew();
	
	if(isdefined('GET_SHIP_ROW.wrk_row_id') and len(GET_SHIP_ROW.wrk_row_id) and  isdefined("attributes.ship_id"))
		sepet.satir[i].wrk_row_id = GET_SHIP_ROW.WRK_ROW_ID;
	else
		sepet.satir[i].wrk_row_id ="WRK#i##round(rand()*65)##dateformat(now(),'YYYYMMDD')##timeformat(now(),'HHmmssL')##session.ep.userid##round(rand()*100)##i#";
	sepet.satir[i].wrk_row_relation_id = '';
	
	sepet.satir[i].product_id = PRODUCT_ID;
	sepet.satir[i].is_inventory = IS_INVENTORY;
	sepet.satir[i].is_production = IS_PRODUCTION;
	sepet.satir[i].special_code = STOCK_CODE_2;
	sepet.satir[i].product_name = NAME_PRODUCT;
	if(isdefined("attributes.ship_id"))
		sepet.satir[i].amount = AMOUNT;//BURADAKİ MİKTAR 1'di,değiştirildi servis güncellemeleri için.
	else
		sepet.satir[i].amount = 1;
	sepet.satir[i].unit = UNIT;
	sepet.satir[i].unit_id = UNIT_ID;
	sepet.satir[i].price = PRICE;
	sepet.satir[i].row_service_id = service_id;
	if(not (isdefined("attributes.event") and attributes.event is 'copy') and isdefined("ROW_ORDER_ID") and len(ROW_ORDER_ID))
		sepet.satir[i].row_ship_id = ROW_ORDER_ID;
	
	if(len(WIDTH_VALUE)) sepet.satir[i].row_width = WIDTH_VALUE; else sepet.satir[i].row_width = '';
	if(len(DEPTH_VALUE)) sepet.satir[i].row_depth = DEPTH_VALUE; else  sepet.satir[i].row_depth = '';
	if(len(HEIGHT_VALUE)) sepet.satir[i].row_height = HEIGHT_VALUE; else  sepet.satir[i].row_height = '';
	if(len(ROW_PROJECT_ID))
		{
			sepet.satir[i].row_project_id=ROW_PROJECT_ID;
			sepet.satir[i].row_project_name=GET_ROW_PROJECTS.PROJECT_HEAD[listfind(row_project_id_list_,ROW_PROJECT_ID)];
		}
	if (not len(DISCOUNT)) sepet.satir[i].indirim1 = 0; else sepet.satir[i].indirim1 = DISCOUNT;
	if (not len(DISCOUNT2)) sepet.satir[i].indirim2 = 0; else sepet.satir[i].indirim2 = DISCOUNT2;
	if (not len(DISCOUNT3)) sepet.satir[i].indirim3 = 0; else sepet.satir[i].indirim3 = DISCOUNT3;
	if (not len(DISCOUNT4)) sepet.satir[i].indirim4 = 0; else sepet.satir[i].indirim4 = DISCOUNT4;
	if (not len(DISCOUNT5)) sepet.satir[i].indirim5 = 0; else sepet.satir[i].indirim5 = DISCOUNT5;
	if (not len(DISCOUNT6)) sepet.satir[i].indirim6 = 0; else sepet.satir[i].indirim6 = DISCOUNT6;
	if (not len(DISCOUNT7)) sepet.satir[i].indirim7 = 0; else sepet.satir[i].indirim7 = DISCOUNT7;
	if (not len(DISCOUNT8)) sepet.satir[i].indirim8 = 0; else sepet.satir[i].indirim8 = DISCOUNT8;
	if (not len(DISCOUNT9)) sepet.satir[i].indirim9 = 0; else sepet.satir[i].indirim9 = DISCOUNT9;
	if (not len(DISCOUNT10)) sepet.satir[i].indirim10 = 0; else sepet.satir[i].indirim10 = DISCOUNT10;
	sepet.satir[i].indirim_carpan = (100-sepet.satir[i].indirim1) * (100-sepet.satir[i].indirim2) * (100-sepet.satir[i].indirim3) * (100-sepet.satir[i].indirim4) * (100-sepet.satir[i].indirim5) * (100-sepet.satir[i].indirim6) * (100-sepet.satir[i].indirim7) * (100-sepet.satir[i].indirim8) * (100-sepet.satir[i].indirim9) * (100-sepet.satir[i].indirim10);
	sepet.satir[i].net_maliyet = 0;	
	sepet.satir[i].marj = 0;
	sepet.satir[i].paymethod_id = PAYMETHOD_ID;
	sepet.satir[i].stock_id = STOCK_ID;
	sepet.satir[i].barcode = BARCOD;
	sepet.satir[i].stock_code = STOCK_CODE;
	sepet.satir[i].manufact_code = MANUFACT_CODE;
	sepet.satir[i].duedate = "";
	if(len(TAX))
		sepet.satir[i].tax_percent = TAX;
	else if(NETTOTAL neq 0) 
		sepet.satir[i].tax_percent = (TAXTOTAL/NETTOTAL)*100; 
	else 
		sepet.satir[i].tax_percent = 0;
	//sepet.satir[i].row_total = amount*price;
	if(len(NETTOTAL))
	{
		sepet.satir[i].row_total = NETTOTAL+DISCOUNTTOTAL;//amount*price;
		sepet.satir[i].row_nettotal = NETTOTAL;
		sepet.satir[i].row_taxtotal = TAXTOTAL;
		sepet.satir[i].row_lasttotal = NETTOTAL + TAXTOTAL;
		//if(len(GROSSTOTAL)) sepet.satir[i].row_lasttotal = GROSSTOTAL; else sepet.satir[i].row_lasttotal = 0;
	}else{
		sepet.satir[i].row_total = sepet.satir[i].amount * sepet.satir[i].price;
		sepet.satir[i].row_nettotal = (sepet.satir[i].row_total/100000000000000000000) * sepet.satir[i].indirim_carpan;
		sepet.satir[i].row_taxtotal = sepet.satir[i].row_nettotal * (sepet.satir[i].tax_percent/100);
		sepet.satir[i].row_lasttotal = sepet.satir[i].row_nettotal + sepet.satir[i].row_taxtotal;
	}
	sepet.satir[i].other_money = OTHER_MONEY;
	if(isdefined("OTHER_MONEY_VALUE") and len(OTHER_MONEY_VALUE))
		sepet.satir[i].other_money_value = OTHER_MONEY_VALUE;
	else
		sepet.satir[i].other_money_value =0;
	sepet.satir[i].other_money_grosstotal = OTHER_MONEY_GROSS_TOTAL;
	if(len(DELIVER_DATE) and isdate(DELIVER_DATE))
	sepet.satir[i].deliver_date = dateformat(DELIVER_DATE,dateformat_style);
	
	if(len(DELIVER_LOC)) 
		sepet.satir[i].deliver_dept = DELIVER_DEPT & "-" & DELIVER_LOC ; 
	else 
		sepet.satir[i].deliver_dept = DELIVER_DEPT ; 
	
	if(isdefined("ROW_ORDER_ID"))
	{
	sepet.satir[i].spect_id = spect_var_id;
	sepet.satir[i].spect_name = spect_var_name;
	sepet.satir[i].lot_no = LOT_NO;
	}
	else
	{
	sepet.satir[i].spect_id = '';
	sepet.satir[i].spect_name = '';
	sepet.satir[i].lot_no = '';
	}
	
	if(len(PRICE_OTHER))
		sepet.satir[i].price_other = PRICE_OTHER;
	else
		sepet.satir[i].price_other = PRICE;

	sepet.total = sepet.total + wrk_round(sepet.satir[i].row_total,basket_total_round_number); //subtotal_
	sepet.toplam_indirim = sepet.toplam_indirim + (wrk_round(sepet.satir[i].row_total,price_round_number) - wrk_round(sepet.satir[i].row_nettotal,price_round_number)); //discount_
	sepet.net_total = sepet.net_total + sepet.satir[i].row_nettotal; //nettotal_

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
	sepet.satir[i].assortment_array = ArrayNew(1);// asorti işlemleri duzenlenecek
	</cfscript>
</cfoutput>
<cfscript>
	for (k=1;k lte arraylen(sepet.kdv_array);k=k+1)
		sepet.kdv_array[k][2] = wrk_round(sepet.kdv_array[k][3] * sepet.kdv_array[k][1] /100,basket_total_round_number);
	
	for (k=1;k lte arraylen(sepet.kdv_array);k=k+1)
		sepet.total_tax = sepet.total_tax + sepet.kdv_array[k][2];

	sepet.net_total = sepet.net_total + sepet.total_tax;
</cfscript>
