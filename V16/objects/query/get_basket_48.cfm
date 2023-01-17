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
			'' AS SERVICE_NO,
			S.STOCK_CODE_2
		FROM 
			SHIP_ROW SH,
			#dsn3_alias#.STOCKS S
		WHERE 
			SH.SHIP_ID=#attributes.ship_id# AND
			SH.STOCK_ID=S.STOCK_ID
		ORDER BY
			SH.SHIP_ROW_ID
	</cfquery>
<cfelseif isdefined("attributes.service_ids") and not isdefined("attributes.is_from_operations")>
	<cfscript>
		this_year = session.ep.period_year;
		last_year = session.ep.period_year-1;
		next_year = session.ep.period_year+1;
		if (database_type is 'MSSQL') 
			{
			last_year_dsn2 = '#dsn#_#this_year-1#_#session.ep.company_id#';
			next_year_dsn2 = '#dsn#_#this_year+1#_#session.ep.company_id#';
			}
		else if (database_type is 'DB2') 
			{
			last_year_dsn2 = '#dsn#_#session.ep.company_id#_#this_year-1#';
			next_year_dsn2 = '#dsn#_#session.ep.company_id#_#this_year+1#';
			}	
	</cfscript>
	
	<cfquery name="get_periods" datasource="#dsn#">
		SELECT PERIOD_YEAR FROM SETUP_PERIOD WHERE OUR_COMPANY_ID = #session.ep.company_id#
	</cfquery>
	
	<cfquery name="control_last_year" dbtype="query" maxrows="1">
		SELECT PERIOD_YEAR FROM get_periods WHERE PERIOD_YEAR = #last_year#
	</cfquery>
	
	<cfquery name="control_next_year" dbtype="query">
		SELECT PERIOD_YEAR FROM get_periods WHERE PERIOD_YEAR = #next_year#
	</cfquery>
	
	<cfquery name="GET_SHIP_ROW" datasource="#dsn3#">
		SELECT DISTINCT
			SH.SHIP_ROW_ID,
			SH.ROW_PROJECT_ID,
			SH.OTHER_MONEY,
			SH.SERVICE_ID, 
			SH.PRODUCT_ID, 
			SH.NAME_PRODUCT, 
			SH.AMOUNT,
			SH.UNIT,
			SH.UNIT_ID, 
			SH.PRICE,
			SH.DISCOUNT, 
			SH.DISCOUNT2,
			SH.DISCOUNT3,
			SH.DISCOUNT4,
			SH.DISCOUNT5,
			SH.DISCOUNT6,
			SH.DISCOUNT7,
			SH.DISCOUNT8,
			SH.DISCOUNT9,
			SH.DISCOUNT10,
			SH.TAX, 
			SH.PAYMETHOD_ID,
			SH.STOCK_ID, 
			SH.NETTOTAL,
			SH.DISCOUNTTOTAL,
			SH.TAXTOTAL,
			SH.OTHER_MONEY_GROSS_TOTAL,
			SH.DELIVER_DATE,
			SH.DELIVER_LOC,
			SH.DELIVER_DEPT,
			SH.PRICE_OTHER,
			SH.PROM_COMISSION, 
			SH.WIDTH_VALUE,
			SH.DEPTH_VALUE,
			SH.HEIGHT_VALUE,
			S.IS_INVENTORY,
			S.IS_PRODUCTION,
			S.STOCK_CODE,
			S.BARCOD,
			S.IS_SERIAL_NO,
			S.MANUFACT_CODE,
			SR.SERVICE_NO,
			S.STOCK_CODE_2,
            SH.PRODUCT_NAME2
		FROM 
			#dsn2_alias#.SHIP_ROW SH,
			#dsn2_alias#.SHIP SHIP,
			STOCKS S,
			SERVICE SR
		WHERE 
			SH.SERVICE_ID = SR.SERVICE_ID AND
			SHIP.SHIP_ID = SH.SHIP_ID AND
			SR.SERVICE_ID IN (#attributes.service_ids#) AND
			SHIP.SHIP_TYPE = 140 AND 
			SR.SERVICE_ID IS NOT NULL AND
			SR.STOCK_ID = S.STOCK_ID<!--- SH --->
		<cfif control_last_year.recordcount or control_next_year.recordcount>
			UNION ALL
		</cfif>
		<cfif control_last_year.recordcount>
			SELECT DISTINCT
				SH.SHIP_ROW_ID,
				SH.ROW_PROJECT_ID,
				SH.OTHER_MONEY,
				SH.SERVICE_ID,
				SH.PRODUCT_ID,
				SH.NAME_PRODUCT,
				SH.AMOUNT, 
				SH.UNIT,
				SH.UNIT_ID,
				SH.PRICE, 
				SH.DISCOUNT,
				SH.DISCOUNT2,
				SH.DISCOUNT3,
				SH.DISCOUNT4,
				SH.DISCOUNT5,
				SH.DISCOUNT6,
				SH.DISCOUNT7,
				SH.DISCOUNT8,
				SH.DISCOUNT9,
				SH.DISCOUNT10,
				SH.TAX,
				SH.PAYMETHOD_ID,
				SH.STOCK_ID,
				SH.NETTOTAL,
				SH.DISCOUNTTOTAL,
				SH.TAXTOTAL,
				SH.OTHER_MONEY_GROSS_TOTAL,
				SH.DELIVER_DATE,
				SH.DELIVER_LOC,
				SH.DELIVER_DEPT,
				SH.PRICE_OTHER,
				SH.PROM_COMISSION,
				SH.WIDTH_VALUE,
				SH.DEPTH_VALUE,
				SH.HEIGHT_VALUE,
				S.IS_INVENTORY,
				S.IS_PRODUCTION,
				S.STOCK_CODE,
				S.BARCOD,
				S.IS_SERIAL_NO,
				S.MANUFACT_CODE,
				SR.SERVICE_NO,
				S.STOCK_CODE_2,
                SH.PRODUCT_NAME2
			FROM 
				#last_year_dsn2#.SHIP_ROW SH,
				#last_year_dsn2#.SHIP SHIP,
				STOCKS S,
				SERVICE SR
			WHERE 
				SH.SERVICE_ID = SR.SERVICE_ID AND
				SHIP.SHIP_ID = SH.SHIP_ID AND
				SR.SERVICE_ID IN (#attributes.service_ids#) AND
				SR.STOCK_ID = S.STOCK_ID AND
				SHIP.SHIP_TYPE = 140 AND 
				SR.SERVICE_ID IS NOT NULL
			<cfif control_next_year.recordcount>
				UNION
			</cfif>
		</cfif>
			<cfif control_next_year.recordcount>
				SELECT DISTINCT
					SH.SHIP_ROW_ID,
					SH.ROW_PROJECT_ID,
					SH.OTHER_MONEY,
					SH.SERVICE_ID,
					SH.PRODUCT_ID,
					SH.NAME_PRODUCT,
					SH.AMOUNT,
					SH.UNIT,
					SH.UNIT_ID, 
					SH.PRICE,
					SH.DISCOUNT,
					SH.DISCOUNT2, 
					SH.DISCOUNT3,
					SH.DISCOUNT4,
					SH.DISCOUNT5,
					SH.DISCOUNT6,
					SH.DISCOUNT7,
					SH.DISCOUNT8,
					SH.DISCOUNT9,
					SH.DISCOUNT10,
					SH.TAX,
					SH.PAYMETHOD_ID,
					SH.STOCK_ID,
					SH.NETTOTAL,
					SH.DISCOUNTTOTAL,
					SH.TAXTOTAL,
					SH.OTHER_MONEY_GROSS_TOTAL,
					SH.DELIVER_DATE,
					SH.DELIVER_LOC,
					SH.DELIVER_DEPT, 
					SH.PRICE_OTHER,
					SH.PROM_COMISSION,
					SH.WIDTH_VALUE, 
					SH.DEPTH_VALUE,
					SH.HEIGHT_VALUE, 
					S.IS_INVENTORY,
					S.IS_PRODUCTION,
					S.STOCK_CODE,
					S.BARCOD,
					S.IS_SERIAL_NO,
					S.MANUFACT_CODE,
					SR.SERVICE_NO,
					S.STOCK_CODE_2,
                    SH.PRODUCT_NAME2
				FROM 
					#next_year_dsn2#.SHIP_ROW SH,
					#next_year_dsn2#.SHIP SHIP,
					STOCKS S,
					SERVICE SR
				WHERE 
					SH.SERVICE_ID = SR.SERVICE_ID AND
					SHIP.SHIP_ID = SH.SHIP_ID AND
					SR.SERVICE_ID IN (#attributes.service_ids#) AND
					SR.STOCK_ID = S.STOCK_ID AND
					SHIP.SHIP_TYPE = 140 AND 
					SR.SERVICE_ID IS NOT NULL
			</cfif>
	</cfquery>
<cfelseif isdefined("attributes.service_ids") and isdefined("attributes.is_from_operations")>
	<cfquery name="GET_SHIP_ROW" datasource="#dsn3#">
		SELECT
			SR.SERVICE_ID,
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
			SH.PRICE AS PRICE,
			SH.AMOUNT,
			SH.PRICE AS PRICE_OTHER,
			'' AS NETTOTAL,
			SH.TOTAL_PRICE AS OTHER_MONEY_VALUE,
			0 AS PRICE_KDV,
			0 AS TAXTOTAL,
			0 AS IS_SERIAL_NO,
			SH.CURRENCY AS MONEY,
			SH.CURRENCY AS OTHER_MONEY,
			0 AS OTHER_MONEY_GROSS_TOTAL,
			0 AS DISCOUNTTOTAL,
			SH.DISCOUNT AS DISCOUNT,
			0 AS DISCOUNT2,
			0 AS DISCOUNT3,
			0 AS DISCOUNT4,
			0 AS DISCOUNT5,
			0 AS DISCOUNT6,
			0 AS DISCOUNT7,
			0 AS DISCOUNT8,
			0 AS DISCOUNT9,
			0 AS DISCOUNT10,
			0 AS PROM_COMISSION,
			'' AS paymethod_id,
			getdate() AS DELIVER_DATE,
			'' AS SERVICE_NO,
			'' AS WIDTH_VALUE,
			'' AS DEPTH_VALUE,
			'' AS HEIGHT_VALUE,
			'' AS ROW_PROJECT_ID,
			S.STOCK_CODE_2,
            '' AS  PRODUCT_NAME2
		FROM
			STOCKS S,
			SERVICE SR,
			PRODUCT_UNIT,
			SERVICE_OPERATION SH
		WHERE
			SR.SERVICE_ID IN (#attributes.service_ids#) AND
			SH.SERVICE_OPE_ID IN (#attributes.service_operation_id#) AND
			SR.SERVICE_ID = SH.SERVICE_ID AND
			S.STOCK_ID = SH.STOCK_ID AND
			PRODUCT_UNIT.PRODUCT_ID = S.PRODUCT_ID AND
			PRODUCT_UNIT.PRODUCT_UNIT_ID = S.PRODUCT_UNIT_ID AND
			SR.LOCATION_ID IS NOT NULL
	</cfquery>
</cfif>
	<cfif (isdefined("GET_SHIP_ROW") and not GET_SHIP_ROW.recordcount) or not isdefined("GET_SHIP_ROW")>
		<cfquery name="GET_SHIP_ROW" datasource="#dsn3#">
			SELECT
				SR.SERVICE_ID,
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
				0 AS PROM_COMISSION,
				'' AS paymethod_id,
				getdate() AS DELIVER_DATE,
				'' AS SERVICE_NO,
				'' AS WIDTH_VALUE,
				'' AS DEPTH_VALUE,
				'' AS HEIGHT_VALUE,
				'' AS ROW_PROJECT_ID,
				S.STOCK_CODE_2,
                '' AS WRK_ROW_ID,
                '' AS PRODUCT_NAME2
			FROM
				STOCKS S,
				SERVICE SR,
				PRODUCT_UNIT
			WHERE
				SR.SERVICE_ID IN (#attributes.service_ids#) AND
				S.STOCK_ID = SR.STOCK_ID AND
				PRODUCT_UNIT.PRODUCT_ID = S.PRODUCT_ID AND
				PRODUCT_UNIT.PRODUCT_UNIT_ID = S.PRODUCT_UNIT_ID AND
				SR.LOCATION_ID IS NOT NULL
		</cfquery>
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
	<cfif isdefined("attributes.service_ids") and isdefined("attributes.is_from_operations")>
		<cfquery name="get_rate2" dbtype="query">
			SELECT RATE2 FROM get_money_bskt WHERE MONEY_TYPE = '#GET_SHIP_ROW.OTHER_MONEY#'
		</cfquery>
		<cfif get_rate2.recordcount>
			<cfset price_row = GET_SHIP_ROW.PRICE_OTHER*get_rate2.rate2>
		<cfelse>
			<cfset price_row = GET_SHIP_ROW.PRICE_OTHER>
		</cfif>
	</cfif>
	<cfscript>
	i = currentrow;
	sepet.satir[i] = StructNew();
	
	if(isdefined('GET_SHIP_ROW.wrk_row_id') and len(GET_SHIP_ROW.wrk_row_id) and  isdefined("attributes.ship_id"))
		sepet.satir[i].wrk_row_id = GET_SHIP_ROW.WRK_ROW_ID;
	else
		sepet.satir[i].wrk_row_id ="WRK#i##round(rand()*65)##dateformat(now(),'YYYYMMDD')##timeformat(now(),'HHmmssL')##session.ep.userid##round(rand()*100)##i#";
	sepet.satir[i].wrk_row_relation_id = '';
	
	sepet.satir[i].row_service_id = service_id;
	sepet.satir[i].product_id = product_id;
	sepet.satir[i].is_inventory = is_inventory;
	sepet.satir[i].is_production = IS_PRODUCTION;
	sepet.satir[i].special_code = STOCK_CODE_2;
	if(len(service_no))
		sepet.satir[i].product_name = '#name_product#-(#service_no#)';
	else
		sepet.satir[i].product_name = name_product;
	if(len(amount))
		sepet.satir[i].amount = amount;
	else
		sepet.satir[i].amount = 1;
	sepet.satir[i].unit = unit;
	sepet.satir[i].unit_id = unit_id;
	if(not (isdefined("attributes.service_ids") and isdefined("attributes.is_from_operations")))
		sepet.satir[i].price = price;	
	else
		sepet.satir[i].price = price_row;
	
	if(not (isdefined("attributes.event") and attributes.event is 'copy') and isdefined("ROW_ORDER_ID") and len(ROW_ORDER_ID))
		sepet.satir[i].row_ship_id = ROW_ORDER_ID;
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
	if(len(tax))sepet.satir[i].tax_percent = tax;else sepet.satir[i].tax_percent = 0;
	if (isdefined("COST_PRICE") and len(COST_PRICE)) sepet.satir[i].net_maliyet = COST_PRICE; else sepet.satir[i].net_maliyet=0;
	if (isdefined("MARGIN") and len(MARGIN)) sepet.satir[i].marj = MARGIN; else sepet.satir[i].marj = 0;
	if (isdefined("extra_cost") and len(extra_cost)) sepet.satir[i].extra_cost = extra_cost; else sepet.satir[i].extra_cost = 0;
	sepet.satir[i].paymethod_id = paymethod_id;
    if(len(PRODUCT_NAME2)) sepet.satir[i].product_name_other = PRODUCT_NAME2; else sepet.satir[i].product_name_other = "";
	sepet.satir[i].stock_id = stock_id;
	sepet.satir[i].barcode = BARCOD;
	sepet.satir[i].stock_code = STOCK_CODE;
	sepet.satir[i].manufact_code = MANUFACT_CODE;
	sepet.satir[i].duedate = "";
	//sepet.satir[i].row_total = amount*price;
	if(len(nettotal))
	{
		sepet.satir[i].row_total = nettotal+discounttotal;//amount*price;
		sepet.satir[i].row_nettotal = nettotal;
		sepet.satir[i].row_taxtotal = taxtotal;
		sepet.satir[i].row_lasttotal = nettotal + taxtotal;
		//if(len(grosstotal)) sepet.satir[i].row_lasttotal = grosstotal; else sepet.satir[i].row_lasttotal = 0;
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
	sepet.satir[i].assortment_array = ArrayNew(1);
	
	sepet.satir[i].promosyon_yuzde = PROM_COMISSION;	
	if (isdefined("PROM_COST") and len(PROM_COST)) sepet.satir[i].promosyon_maliyet = PROM_COST; else sepet.satir[i].promosyon_maliyet = 0;
	if(isdefined("ROW_ORDER_ID"))
	{
	sepet.satir[i].iskonto_tutar = DISCOUNT_COST;
	sepet.satir[i].is_promotion = IS_PROMOTION;
	sepet.satir[i].prom_stock_id = prom_stock_id;
	}
	else
	{
	sepet.satir[i].iskonto_tutar = '';
	sepet.satir[i].is_promotion = 0;
	sepet.satir[i].prom_stock_id = '';
	}
	if(len(WIDTH_VALUE)) sepet.satir[i].row_width = WIDTH_VALUE; else sepet.satir[i].row_width = '';
	if(len(DEPTH_VALUE)) sepet.satir[i].row_depth = DEPTH_VALUE; else  sepet.satir[i].row_depth = '';
	if(len(HEIGHT_VALUE)) sepet.satir[i].row_height = HEIGHT_VALUE; else  sepet.satir[i].row_height = '';
	if(len(ROW_PROJECT_ID))
		{
			sepet.satir[i].row_project_id=ROW_PROJECT_ID;
			sepet.satir[i].row_project_name=GET_ROW_PROJECTS.PROJECT_HEAD[listfind(row_project_id_list_,ROW_PROJECT_ID)];
		}
	</cfscript>
</cfoutput>
<cfscript>
	for (k=1;k lte arraylen(sepet.kdv_array);k=k+1)
		sepet.kdv_array[k][2] = wrk_round(sepet.kdv_array[k][3] * sepet.kdv_array[k][1] /100,basket_total_round_number);
	
	for (k=1;k lte arraylen(sepet.kdv_array);k=k+1)
		sepet.total_tax = sepet.total_tax + sepet.kdv_array[k][2];
	
	sepet.net_total = sepet.net_total + sepet.total_tax;
</cfscript>
