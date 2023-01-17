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
</cfscript>
<cfquery name="get_money" datasource="#DSN#">
	SELECT * FROM SETUP_MONEY WHERE PERIOD_ID = #SESSION.EP.PERIOD_ID#
</cfquery>
<cfif isdefined("attributes.internal_row_info") and len(attributes.internal_row_info)><!--- Satir Bazli Ic Talepten Olusturuluyorsa FBS --->
	<cfset int_id_list = "">
	<cfset int_row_id_list = "">
	<cfloop list="#attributes.internal_row_info#" index="iro">
		<cfset int_id_list = ListAppend(int_id_list,ListFirst(iro,';'),',')>
		<cfset int_row_id_list = ListAppend(int_row_id_list,ListLast(iro,';'),',')>
	</cfloop>
</cfif>
<cfif isdefined("attributes.sId") and len(attributes.sId) and isdefined("attributes.pType") and len(attributes.pType)>
	<cfquery name="GET_INTERNALDEMAND_PRODUCTS" datasource="#DSN3#">
		SELECT 
			PT.SPECT_MAIN_ID AS SPECT_VAR_ID,
			PT.AMOUNT AS QUANTITY,
			PT.RELATED_ID AS STOCK_ID,
			PT.PRODUCT_ID,
			PT.PRODUCTION_CODE,
			P.PRODUCT_ID,
			P.MANUFACT_CODE AS MANUFACT_CODE_,
			P.COMPANY_ID,
			PT.TARGET_PRICE AS PRICE,
			PT.TARGET_PRICE AS PRICE_OTHER,
			PT.UNIT_ID,
			'' PRODUCT_NAME2,
			'' BASKET_EXTRA_INFO_ID,
			'' SELECT_INFO_EXTRA,
			'' DETAIL_INFO_EXTRA,
			PT.AMOUNT AS AMOUNT2,
			PU.MAIN_UNIT AS UNIT2,
			PU.MAIN_UNIT UNIT,
			'' DUEDATE,
			'' PRODUCT_MANUFACT_CODE,
			'' ROW_WORK_ID,
			'' ROW_PROJECT_ID,
			'' I_ID,
			'' I_ROW_ID,
			'' WRK_ROW_ID,
			'TL' OTHER_MONEY,
			S.PROPERTY,
			S.STOCK_CODE,
			S.TAX_PURCHASE,
			S.MANUFACT_CODE,
			S.IS_INVENTORY,
			S.IS_PRODUCTION,
			S.BARCOD,
			S.STOCK_CODE_2,
			S.PRODUCT_NAME,
			0 TAX_PURCHASE,
			0 DISCOUNT_1,
			0 DISCOUNT_2,
			0 DISCOUNT_3,
			0 DISCOUNT_4,
			0 DISCOUNT_5,
			0 DISCOUNT_6,
			0 DISCOUNT_7,
			0 DISCOUNT_8,
			0 DISCOUNT_9,
			0 DISCOUNT_10,
			0 OTVTOTAL,
			0 OTHER_MONEY_VALUE,
			0 DISCOUNT_COST,
			0 EXTRA_PRICE,
			0 EXTRA_PRICE_TOTAL,
			0 EXTRA_PRICE_OTHER_TOTAL,
			0 OTV_ORAN,
			0 OIV_RATE,
			0 OIV_AMOUNT,
			'' DELIVER_DATE,
			'' DELIVER_DEPT,
			'' DEPARTMENT_IN,
			'' LOCATION_IN,
			'' SPECT_VAR_NAME,
			'' EXPENSE_CENTER_ID,
			'' EXPENSE_CETER_NAME,
			'' ACTIVITY_TYPE_ID,
			'' EXPENSE_ITEM_ID,
			'' ACC_CODE
		FROM 
		   PRODUCT_TREE AS PT
		   LEFT JOIN #dsn3#.PRODUCT AS P ON P.PRODUCT_ID = PT.PRODUCT_ID
		   JOIN STOCKS AS S ON S.STOCK_ID = PT.RELATED_ID 
		   LEFT JOIN #dsn3#.PRODUCT_UNIT AS PU ON PU.PRODUCT_UNIT_ID = PT.UNIT_ID
		   
		WHERE 
		   PT.STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sId#">
		   AND ISNULL(PT.TREE_TYPE,-1) = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pType#">
		ORDER BY 
			PT.TREE_TYPE ASC
	</cfquery>
<cfelse>
	<cfquery name="GET_INTERNALDEMAND_PRODUCTS" datasource="#dsn3#">
		SELECT
			IDR.*,
			I.DEPARTMENT_IN,
			I.LOCATION_IN,
			S.PROPERTY,
			S.STOCK_CODE,
			S.TAX_PURCHASE, <!--- KDV alanı ürünün kendi kdv sinden alınıyor iç talep basketinden alınmıyor --->
			S.MANUFACT_CODE,
			S.IS_INVENTORY,
			S.IS_PRODUCTION,
			S.BARCOD,
			S.STOCK_CODE_2,
			EXC.EXPENSE,
			EXI.EXPENSE_ITEM_NAME
		FROM
			INTERNALDEMAND I,
			INTERNALDEMAND_ROW IDR
			LEFT JOIN #dsn2#.EXPENSE_CENTER AS EXC ON IDR.EXPENSE_CENTER_ID = EXC.EXPENSE_ID
			LEFT JOIN #dsn2#.EXPENSE_ITEMS AS EXI ON IDR.EXPENSE_ITEM_ID = EXI.EXPENSE_ITEM_ID,
			STOCKS S
		WHERE
			IDR.STOCK_ID = S.STOCK_ID AND
			IDR.I_ID = I.INTERNAL_ID
			<cfif isdefined("int_row_id_list") and len(int_row_id_list)><!--- Satir Bazli Ic Talepten Olusturuluyorsa --->
				AND IDR.I_ROW_ID IN (#int_row_id_list#)
			<cfelse>
				AND IDR.I_ID = #attributes.id#
			</cfif>
		<cfif not isdefined('attributes.all_product_convert')><!--- Eğer "Tüm ürünleri siparişe dönüştür" seçili değilse. --->
			<cfif isdefined("attributes.company_id") and len(attributes.company_id) and len(attributes.company_name)>
				AND S.COMPANY_ID = #attributes.company_id#
			</cfif>
		</cfif>
		<cfif isdefined("attributes.product_employee_id") and len(attributes.product_employee_id) and len(attributes.employee_name)><!--- Sorumlu seçildiyse sadece onun ürünleri gelecek --->
			AND S.PRODUCT_MANAGER = #attributes.product_employee_id#
		</cfif>
		ORDER BY
			I.INTERNAL_ID,
			IDR.I_ROW_ID
	</cfquery>
</cfif>
<cfset row_work_id_list_=listsort(ListDeleteDuplicates(valuelist(GET_INTERNALDEMAND_PRODUCTS.ROW_WORK_ID)),'numeric','asc',',')>
<cfif len(row_work_id_list_)>
	<cfquery name="GET_ROW_WORKS" datasource="#dsn#">
		SELECT WORK_HEAD,WORK_ID FROM PRO_WORKS WHERE WORK_ID IN (#row_work_id_list_#) ORDER BY WORK_ID
	</cfquery>
	<cfset row_work_id_list_=valuelist(GET_ROW_WORKS.WORK_ID)>
</cfif>
<cfset row_project_id_list_=listsort(ListDeleteDuplicates(valuelist(GET_INTERNALDEMAND_PRODUCTS.ROW_PROJECT_ID)),'numeric','asc',',')>
<cfif len(row_project_id_list_)>
	<cfquery name="GET_ROW_PROJECTS" datasource="#dsn#">
		SELECT PROJECT_HEAD,PROJECT_ID FROM PRO_PROJECTS WHERE PROJECT_ID IN (#row_project_id_list_#) ORDER BY PROJECT_ID
	</cfquery>
	<cfset row_project_id_list_=valuelist(GET_ROW_PROJECTS.PROJECT_ID)>
</cfif>

<cfset  i = 0>
<cfoutput query="GET_INTERNALDEMAND_PRODUCTS">
	<cfloop from="1" to="10" index="k">
		<cfset 'd#k#' = 0>
	</cfloop>
	<cfquery name="get_aksiyons" datasource="#dsn3#" maxrows="1">
		SELECT
			CPP.DISCOUNT1,
			CPP.DISCOUNT2,
			CPP.DISCOUNT3,
			CPP.DISCOUNT4,
			CPP.DISCOUNT5,
			CPP.DISCOUNT6,
			CPP.DISCOUNT7,
			CPP.DISCOUNT8,
			CPP.DISCOUNT9,
			CPP.DISCOUNT10
		FROM
			CATALOG_PROMOTION AS CP,
			CATALOG_PROMOTION_PRODUCTS AS CPP
		WHERE
			CPP.PRODUCT_ID = #PRODUCT_ID# AND
			CP.IS_APPLIED = 1 AND
			CP.STARTDATE <= #now()# AND
			CP.FINISHDATE >= #now()# AND
			CPP.CATALOG_ID = CP.CATALOG_ID 
		ORDER BY CPP.CATALOGPRODUCT_ID DESC
	</cfquery>
	<cfscript>
		if(get_aksiyons.recordcount){
			if (not len(get_aksiyons.discount1)) d1 = 0; else d1 = get_aksiyons.discount1;
			if (not len(get_aksiyons.discount2)) d2 = 0; else d2 = get_aksiyons.discount2;
			if (not len(get_aksiyons.discount3)) d3 = 0; else d3 = get_aksiyons.discount3;
			if (not len(get_aksiyons.discount4)) d4 = 0; else d4 = get_aksiyons.discount4;
			if (not len(get_aksiyons.discount5)) d5 = 0; else d5 = get_aksiyons.discount5;
			if (not len(get_aksiyons.discount6)) d6 = 0; else d6 = get_aksiyons.discount6;
			if (not len(get_aksiyons.discount7)) d7 = 0; else d7 = get_aksiyons.discount7;
			if (not len(get_aksiyons.discount8)) d8 = 0; else d8 = get_aksiyons.discount8;
			if (not len(get_aksiyons.discount9)) d9 = 0; else d9 = get_aksiyons.discount9;
			if (not len(get_aksiyons.discount10)) d10 = 0; else d10 = get_aksiyons.discount10;
		}
	</cfscript>
	<cfif (not get_aksiyons.recordcount)>
		<cfif isdefined("attributes.company_id") and len(attributes.company_id)>
			<cfquery name="get_contracts" datasource="#dsn3#" maxrows="1">
				SELECT
					CPPD.DISCOUNT1,
					CPPD.DISCOUNT2,
					CPPD.DISCOUNT3,
					CPPD.DISCOUNT4,
					CPPD.DISCOUNT5
				FROM
					CONTRACT_PURCHASE_PROD_DISCOUNT CPPD
				WHERE
					CPPD.PRODUCT_ID = #PRODUCT_ID# AND
					CPPD.COMPANY_ID = #ATTRIBUTES.COMPANY_ID#
				ORDER BY
					CPPD.START_DATE DESC
			</cfquery>
			<cfif not get_contracts.recordcount>
				<cfquery name="get_contracts" datasource="#dsn3#" maxrows="1">
					SELECT
						CPPD.DISCOUNT1,
						CPPD.DISCOUNT2,
						CPPD.DISCOUNT3,
						CPPD.DISCOUNT4,
						CPPD.DISCOUNT5
					FROM
						CONTRACT_PURCHASE_PROD_DISCOUNT CPPD
					WHERE
						CPPD.PRODUCT_ID = #PRODUCT_ID# AND
						CPPD.COMPANY_ID IS NULL
					ORDER BY
						CPPD.START_DATE DESC
				</cfquery>
			</cfif>
		<cfelse>
			<cfquery name="get_contracts" datasource="#dsn3#" maxrows="1">
				SELECT
					CPPD.DISCOUNT1,
					CPPD.DISCOUNT2,
					CPPD.DISCOUNT3,
					CPPD.DISCOUNT4,
					CPPD.DISCOUNT5
				FROM
					CONTRACT_PURCHASE_PROD_DISCOUNT CPPD
				WHERE
					CPPD.PRODUCT_ID = #PRODUCT_ID# AND
					CPPD.COMPANY_ID IS NULL
				ORDER BY
					CPPD.START_DATE DESC
			</cfquery>
		</cfif>
		<cfscript>//indirimler anlaşma varsa
			if(get_contracts.recordcount)
			{
				if (not len(get_contracts.discount1)) d1 = 0; else d1 = get_contracts.discount1;
				if (not len(get_contracts.discount2)) d2 = 0; else d2 = get_contracts.discount2;
				if (not len(get_contracts.discount3)) d3 = 0; else d3 = get_contracts.discount3;
				if (not len(get_contracts.discount4)) d4 = 0; else d4 = get_contracts.discount4;
				if (not len(get_contracts.discount5)) d5 = 0; else d5 = get_contracts.discount5;
				d6 = 0;
				d7 = 0;
				d8 = 0;
				d9 = 0;
				d10 = 0;
			}
		</cfscript>
		<cfscript>
			if(not get_contracts.recordcount)
			{
				if (not len(discount_1)) d1 = 0; else d1 = discount_1;
				if (not len(discount_2)) d2 = 0; else d2 = discount_2;
				if (not len(discount_3)) d3 = 0; else d3 = discount_3;
				if (not len(discount_4)) d4 = 0; else d4 = discount_4;
				if (not len(discount_5)) d5 = 0; else d5 = discount_5;
				if (not len(discount_6)) d6 = 0; else d6 = discount_6;
				if (not len(discount_7)) d7 = 0; else d7 = discount_7;
				if (not len(discount_8)) d8 = 0; else d8 = discount_8;
				if (not len(discount_9)) d9 = 0; else d9 = discount_9;
				if (not len(discount_10)) d10 = 0; else d10 = discount_10;
			}
		</cfscript>
	</cfif>
	<cfquery name="get_price_all" datasource="#DSN3#" maxrows="1">
		SELECT
			PS.PRICE,
			PS.MONEY
		FROM
			PRICE_STANDART AS PS,
			PRODUCT_UNIT AS PU
		WHERE
			PRICESTANDART_STATUS = 1
			AND PURCHASESALES = 0
			AND PS.PRODUCT_ID = #PRODUCT_ID#
			AND PS.UNIT_ID = PU.PRODUCT_UNIT_ID
			AND PU.PRODUCT_ID = #PRODUCT_ID#
			AND PU.IS_MAIN = 1
	</cfquery>	
	<cfquery name="get_price" dbtype="query">
		SELECT 
			PRICE*(RATE2/RATE1) AS PRICE
		FROM 
			get_price_all,
			get_money
		WHERE 
			get_money.MONEY = get_price_all.MONEY
	</cfquery>
	<cfscript>
		i=i+1;
		sepet.satir[i] = StructNew();
		sepet.satir[i].row_ship_id="#I_ID#;#I_ROW_ID#";
		sepet.satir[i].product_id = PRODUCT_ID;
		if(len(ROW_WORK_ID[i]))
		{
			sepet.satir[i].row_work_id = ROW_WORK_ID;
			sepet.satir[i].row_work_name = GET_ROW_WORKS.WORK_HEAD[listfind(row_work_id_list_,ROW_WORK_ID)];
		}
		if(len(ROW_PROJECT_ID[i]))
		{
			sepet.satir[i].row_project_id=ROW_PROJECT_ID[i];
			sepet.satir[i].row_project_name=GET_ROW_PROJECTS.PROJECT_HEAD[listfind(row_project_id_list_,ROW_PROJECT_ID[i])];
		}
		sepet.satir[i].stock_id = STOCK_ID;
		sepet.satir[i].product_name = PRODUCT_NAME;
		if(isdefined("attributes.internal_row_info") and len(attributes.internal_row_info))//satir bazli ic talepten geliyorsa
			sepet.satir[i].amount = Evaluate('add_stock_amount_#i_id#_#i_row_id#');
		else
			sepet.satir[i].amount = quantity;
			
		sepet.satir[i].unit = UNIT;
		sepet.satir[i].unit_id = UNIT_ID;
		
		sepet.satir[i].wrk_row_id="WRK#i##round(rand()*65)##dateformat(now(),'YYYYMMDD')##timeformat(now(),'HHmmssL')##session.ep.userid##round(rand()*100)##i#";
		sepet.satir[i].wrk_row_relation_id =GET_INTERNALDEMAND_PRODUCTS.wrk_row_id;
		
		if(len(price) and price gt 0)
			sepet.satir[i].price = price;
		else if(len(get_price.price) and get_price.price gt 0)
			sepet.satir[i].price = get_price.price;
		else
			sepet.satir[i].price = 0;

		if(len(OTHER_MONEY_VALUE))
			sepet.satir[i].other_money_value = OTHER_MONEY_VALUE;
		else
			sepet.satir[i].other_money_value = sepet.satir[i].price;

		if(len(OTHER_MONEY))
			sepet.satir[i].other_money = OTHER_MONEY;
		else
			sepet.satir[i].other_money = SESSION.EP.MONEY;
	
		if(len(GET_INTERNALDEMAND_PRODUCTS.PRICE_OTHER))
			sepet.satir[i].price_other = GET_INTERNALDEMAND_PRODUCTS.PRICE_OTHER;
		else
			sepet.satir[i].price_other = GET_INTERNALDEMAND_PRODUCTS.PRICE;
		if(findnocase('form_add_offer',fusebox.fuseaction))
		{
			sepet.satir[i].price = 0;
			sepet.satir[i].price_other = 0;
			sepet.satir[i].other_money_value = 0;
		}
		sepet.satir[i].is_inventory = IS_INVENTORY;
		sepet.satir[i].is_production = IS_PRODUCTION;
		sepet.satir[i].indirim1 = d1;
		sepet.satir[i].indirim2 = d2;
		sepet.satir[i].indirim3 = d3;
		sepet.satir[i].indirim4 = d4;
		sepet.satir[i].indirim5 = d5;
		sepet.satir[i].indirim6 = d6;
		sepet.satir[i].indirim7 = d7;
		sepet.satir[i].indirim8 = d8;
		sepet.satir[i].indirim9 = d9;
		sepet.satir[i].indirim10 = d10;		
		sepet.satir[i].paymethod_id = 0;
		sepet.satir[i].barcode = BARCOD;
		if(isDefined('attributes.sId') and isDefined('attributes.pType'))
		{		
			sepet.satir[i].special_code = PRODUCTION_CODE;	
			sepet.satir[i].manufact_code = MANUFACT_CODE_;
		}
		else{	
			sepet.satir[i].special_code = STOCK_CODE_2;	
			sepet.satir[i].manufact_code = PRODUCT_MANUFACT_CODE;
		}
		sepet.satir[i].tax_percent = TAX_PURCHASE;		
		sepet.satir[i].stock_code = STOCK_CODE;
		
		sepet.satir[i].duedate = duedate;
		sepet.satir[i].row_unique_relation_id = "";
		sepet.satir[i].iskonto_tutar = ( len(DISCOUNT_COST) ? DISCOUNT_COST : 0 );
		if( len(product_name2[i]) ) sepet.satir[i].product_name_other = product_name2[i]; else sepet.satir[i].product_name_other = "";
		if( len(BASKET_EXTRA_INFO_ID[i]) ) sepet.satir[i].basket_extra_info = BASKET_EXTRA_INFO_ID[i]; else sepet.satir[i].basket_extra_info="";
		if( len(SELECT_INFO_EXTRA[i]) ) sepet.satir[i].select_info_extra = SELECT_INFO_EXTRA[i]; else sepet.satir[i].select_info_extra="";
		if( len(DETAIL_INFO_EXTRA[i]) ) sepet.satir[i].detail_info_extra = DETAIL_INFO_EXTRA[i]; else sepet.satir[i].detail_info_extra="";

		
		sepet.satir[i].amount_other = ( len( AMOUNT2) ? AMOUNT2 : 0 );
		sepet.satir[i].unit_other = ( len( UNIT2) ? UNIT2 : "" );
		if(len(EXTRA_PRICE[i])) sepet.satir[i].ek_tutar = extra_price[i]; else sepet.satir[i].ek_tutar = 0;
		if(len(EXTRA_PRICE_TOTAL[i])) sepet.satir[i].ek_tutar_total = extra_price_total[i]; else sepet.satir[i].ek_tutar_total = 0;
		if(len(EXTRA_PRICE_OTHER_TOTAL[i])) sepet.satir[i].ek_tutar_other_total = extra_price_other_total[i]; else sepet.satir[i].ek_tutar_other_total = 0;
		sepet.satir[i].shelf_number = "";
		sepet.satir[i].otv_oran = ( len( OTV_ORAN) ? OTV_ORAN : 0 ); //ozel tuketim vergisi
		sepet.satir[i].row_otvtotal = 0; //otv satır toplam tutarı
		sepet.satir[i].row_total = (sepet.satir[i].amount*sepet.satir[i].price) +sepet.satir[i].ek_tutar_total;
		sepet.satir[i].indirim_carpan = (100-sepet.satir[i].indirim1) * (100-sepet.satir[i].indirim2) * (100-sepet.satir[i].indirim3) * (100-sepet.satir[i].indirim4) * (100-sepet.satir[i].indirim5) * (100-sepet.satir[i].indirim6) * (100-sepet.satir[i].indirim7) * (100-sepet.satir[i].indirim8) * (100-sepet.satir[i].indirim9) * (100-sepet.satir[i].indirim10);
		sepet.satir[i].row_nettotal = (sepet.satir[i].row_total/100000000000000000000) * sepet.satir[i].indirim_carpan;
		sepet.satir[i].row_taxtotal = sepet.satir[i].row_nettotal * (sepet.satir[i].tax_percent/100);
		sepet.satir[i].row_lasttotal = sepet.satir[i].row_nettotal + sepet.satir[i].row_taxtotal;
		sepet.total = sepet.total + wrk_round(sepet.satir[i].row_total,basket_total_round_number); //subtotal_
		sepet.toplam_indirim = sepet.toplam_indirim + (wrk_round(sepet.satir[i].row_total,price_round_number) - wrk_round(sepet.satir[i].row_nettotal,price_round_number)); //discount_
		sepet.total_tax = sepet.total_tax + sepet.satir[i].row_taxtotal; //totaltax_
		sepet.net_total = sepet.net_total + sepet.satir[i].row_lasttotal; //nettotal_
		sepet.satir[i].row_oiv_rate = ( len( OIV_RATE ) ) ? OIV_RATE : '';
        sepet.satir[i].row_oiv_amount = ( len( OIV_AMOUNT ) ) ? OIV_AMOUNT : 0;
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
		sepet.satir[i].deliver_date = dateformat(deliver_date,dateformat_style);
		if(len(deliver_dept) and len(deliver_location))
			sepet.satir[i].deliver_dept = "#deliver_dept#-#deliver_location#";
		else
			sepet.satir[i].deliver_dept = "#department_in#-#location_in#";
		sepet.satir[i].spect_id = spect_var_id;
		sepet.satir[i].spect_name = spect_var_name;
		sepet.satir[i].lot_no = "";
		sepet.satir[i].assortment_array = ArrayNew(1);

		/*Masraf Merkezi*/
		if( len(EXPENSE_CENTER_ID) )
		{
			sepet.satir[i].row_exp_center_id = EXPENSE_CENTER_ID;
			sepet.satir[i].row_exp_center_name = EXPENSE;
		}

		//Aktivite Tipi
		sepet.satir[i].row_activity_id = ACTIVITY_TYPE_ID;

		//Bütçe Kalemi
		if( len(EXPENSE_ITEM_ID) )
		{
			sepet.satir[i].row_exp_item_id = EXPENSE_ITEM_ID;
			sepet.satir[i].row_exp_item_name = EXPENSE_ITEM_NAME;
		}

		//Muhasebe Kodu
		if(len(ACC_CODE))
		{
			sepet.satir[i].row_acc_code = ACC_CODE;
		}

	</cfscript>
</cfoutput>
