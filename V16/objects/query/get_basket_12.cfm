<cfif isdefined('attributes.type') and len(CONVERT_STOCKS_ID)><!--- Üretim Malzeme İhtiyaçları listesinden dönüşüm yapılıyorsa --->
	<cfset GET_UPD_PURCHASE.OTHER_MONEY = '#session.ep.MONEY2#'>
	<cfset deliver_date ="#now()#"><!--- Üretim Malzeme İhtiyaçları listesinden dönüşüm yapılıyorsa --->
	<cfset CONVERT_STOCKS_ID = left(attributes.CONVERT_STOCKS_ID,len(attributes.CONVERT_STOCKS_ID)-1)>
	<cfset CONVERT_MONEY = left(attributes.CONVERT_MONEY,len(attributes.CONVERT_MONEY)-1)>
	<cfset CONVERT_PRICE = left(attributes.CONVERT_PRICE,len(attributes.CONVERT_PRICE)-1)>
	<cfset CONVERT_AMOUNT_STOCKS_ID = left(attributes.CONVERT_AMOUNT_STOCKS_ID,len(attributes.CONVERT_AMOUNT_STOCKS_ID)-1)>
    <cfset CONVERT_PRICE_OTHER = left(attributes.CONVERT_PRICE_OTHER,len(attributes.CONVERT_PRICE_OTHER)-1)>
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
	<cfquery name="GET_FIS_DETAIL" datasource="#DSN3#">
		SELECT
			S.IS_PRODUCTION IS_PRODUCTION_,
			S.PRODUCT_ID,
			S.STOCK_ID,
			S.STOCK_CODE_2,
			S.MANUFACT_CODE AS PRODUCT_MANUFACT_CODE,
			S.PROPERTY,
			S.BARCOD,
			S.STOCK_CODE,
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
			'' AS OTHER_MONEY_VALUE,
			'' AS UNIQUE_RELATION_ID,
			'' AS PRODUCT_NAME2,
			'' AS AMOUNT2,
			'' AS UNIT2,
			'' AS EXTRA_PRICE,
			'' AS EXTRA_PRICE_TOTAL,
			'' AS EXTRA_PRICE_OTHER_TOTAL,
			'' AS SHELF_NUMBER,
			'' AS TO_SHELF_NUMBER,
			'' AS DELIVER_DEPT,
			'' AS SPECT_VAR_ID,
			'' AS SPECT_VAR_NAME,
			'' AS LOT_NO,
			0 AS PRICE_OTHER,
			'' AS OTV_ORAN,
			'' AS NETTOTAL,
			'' AS DISCOUNT_COST,
			'' AS COST_PRICE,
			'' AS EXTRA_COST,
			'' AS NET_TOTAL,
			'' AS TOTAL_TAX,
			'' AS ROW_DELIVER_DATE ,
			'' AS ROW_RESERVE_DATE,
			'' AS ROW_INTERNALDEMAND_ID,
			'' AS WRK_ROW_ID,
			'' AS WRK_ROW_RELATION_ID,
			'' AS WIDTH_VALUE,
			'' AS DEPTH_VALUE,
			'' AS HEIGHT_VALUE,
			'' AS ROW_PROJECT_ID,
            '' AS ROW_WORK_ID,
			'' PBS_ID,
            '' OTVTOTAL,
			'' BASKET_EXTRA_INFO_ID,
			'' SELECT_INFO_EXTRA,
			'' DETAIL_INFO_EXTRA
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
		/* ORDER BY
			S.PRODUCT_NAME */
	</cfquery>
<cfelseif isdefined('attributes.internal_row_info') or (isdefined("attributes.internal_demand_id") and isdefined("internald_row_id_list") and len(internald_row_id_list))>
	<cfquery name="GET_FIS_DETAIL" datasource="#dsn3#">
		SELECT
			S.IS_PRODUCTION IS_PRODUCTION_,
			S.PRODUCT_ID,
			S.STOCK_ID,
			S.STOCK_CODE_2,
			INT_D.I_ID,
			INT_D.I_ROW_ID,
			INT_D.UNIT,
			INT_D.UNIT_ID,
			INT_D.PRICE,
			INT_D.UNIQUE_RELATION_ID,
			INT_D.PRODUCT_NAME2,
			INT_D.AMOUNT2,
			INT_D.UNIT2,
			INT_D.EXTRA_PRICE,
			INT_D.EXTRA_PRICE_TOTAL,
			INT_D.EXTRA_PRICE_OTHER_TOTAL,
			INT_D.SHELF_NUMBER,
			'' AS TO_SHELF_NUMBER,
			INT_D.DISCOUNT_COST,
			INT_D.COST_PRICE,
			INT_D.EXTRA_COST,
			INT_D.PRODUCT_MANUFACT_CODE,
			INT_D.OTHER_MONEY,
			INT_D.PRICE_OTHER,
			INT_D.SPECT_VAR_ID,
			INT_D.SPECT_VAR_NAME,
			INT_D.WIDTH_VALUE,
			INT_D.DEPTH_VALUE,
			INT_D.HEIGHT_VALUE,
			INT_D.ROW_PROJECT_ID,
            INT_D.ROW_WORK_ID,
			INT_D.TAX,
			INT_D.PRODUCT_NAME AS NAME_PRODUCT,
			INT_D.QUANTITY AS AMOUNT,
			INT_D.DISCOUNT_1 AS DISCOUNT1,
			INT_D.DISCOUNT_1 AS DISCOUNT1,
			INT_D.DISCOUNT_2 AS DISCOUNT2,
			INT_D.DISCOUNT_3 AS DISCOUNT3,
			INT_D.DISCOUNT_4 AS DISCOUNT4,
			INT_D.DISCOUNT_5 AS DISCOUNT5,
			INT_D.DISCOUNT_6 AS DISCOUNT6,
			INT_D.DISCOUNT_7 AS DISCOUNT7,
			INT_D.DISCOUNT_8 AS DISCOUNT8,
			INT_D.DISCOUNT_9 AS DISCOUNT9,
			INT_D.DISCOUNT_10 AS DISCOUNT10,
			INT_D.DUEDATE AS DUE_DATE,
			INT_D.NETTOTAL AS NET_TOTAL,
			INT_D.TAXTOTAL AS TOTAL_TAX,
			INT_D.DELIVER_DATE AS ROW_DELIVER_DATE,
			INT_D.EXPENSE_CENTER_ID,
			INT_D.EXPENSE_ITEM_ID,
			INT_D.ACTIVITY_TYPE_ID,
			INT_D.ACC_CODE,
			INT_D.RESERVE_DATE AS ROW_RESERVE_DATE,
			'' AS PAYMETHOD_ID,
			'' AS OTHER_MONEY_GROSS_TOTAL,
			'' AS DELIVER_LOC,
			'' AS DELIVER_DEPT,
			'' AS LOT_NO,
			S.IS_INVENTORY,
			S.PROPERTY,
			S.PRODUCT_NAME AS NAME_PRODUCT,
			S.IS_PRODUCTION,
			S.STOCK_CODE,
			S.BARCOD,
			S.IS_SERIAL_NO,
			S.MANUFACT_CODE,
			'' AS WRK_ROW_ID,
			WRK_ROW_ID AS WRK_ROW_RELATION_ID,
			PBS_ID,
            '' OTVTOTAL,
			'' BASKET_EXTRA_INFO_ID,
			'' SELECT_INFO_EXTRA,
			'' DETAIL_INFO_EXTRA,
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
<cfelseif isdefined('attributes.st_id')>
	<cfquery name="GET_FIS_DETAIL" datasource="#dsn3#">
		SELECT
			S.IS_PRODUCTION IS_PRODUCTION_,
			S.PRODUCT_ID,
			S.STOCK_ID,
			S.STOCK_CODE_2,
			STS.STRETCHING_TEST_ROWID AS I_ID,
			STS.STRETCHING_TEST_ROWID AS I_ROW_ID,
			PU.MAIN_UNIT AS UNIT,
			PU.MAIN_UNIT_ID AS UNIT_ID,
			0 AS PRICE,
			NULL AS UNIQUE_RELATION_ID,
			P.PRODUCT_NAME AS PRODUCT_NAME2,
			(ISNULL(STS.ROLL_TEST_METER, 0) / ISNULL(PU.MULTIPLIER, 1)) AS AMOUNT2,
			ISNULL(PU.ADD_UNIT, PU.MAIN_UNIT) AS UNIT2,
			0 AS EXTRA_PRICE,
			0 AS EXTRA_PRICE_TOTAL,
			0 AS EXTRA_PRICE_OTHER_TOTAL,
			'' AS SHELF_NUMBER,
			'' AS TO_SHELF_NUMBER,
			0 AS DISCOUNT_COST,
			0 AS COST_PRICE,
			0 AS EXTRA_COST,
			'' AS PRODUCT_MANUFACT_CODE,
			'#session.ep.MONEY#' AS OTHER_MONEY,
			0 AS PRICE_OTHER,
			NULL AS SPECT_VAR_ID,
			NULL AS SPECT_VAR_NAME,
			NULL AS WIDTH_VALUE,
			NULL AS DEPTH_VALUE,
			NULL AS HEIGHT_VALUE,
			STH.PROJECT_ID AS ROW_PROJECT_ID,
            NULL AS ROW_WORK_ID,
			0 AS TAX,
			P.PRODUCT_NAME AS NAME_PRODUCT,
			ISNULL(STS.ROLL_TEST_METER, 0) AS AMOUNT,
			0 AS DISCOUNT1,
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
			#now()# AS DUE_DATE,
			0 AS NET_TOTAL,
			0 AS TOTAL_TAX,
			#now()# AS ROW_DELIVER_DATE,
			NULL AS EXPENSE_CENTER_ID,
			NULL AS EXPENSE_ITEM_ID,
			NULL AS ACTIVITY_TYPE_ID,
			NULL AS ACC_CODE,
			NULL AS ROW_RESERVE_DATE,
			'' AS PAYMETHOD_ID,
			'' AS OTHER_MONEY_GROSS_TOTAL,
			'' AS DELIVER_LOC,
			'' AS DELIVER_DEPT,
			SR.LOT_NO,
			S.IS_INVENTORY,
			S.PROPERTY,
			S.PRODUCT_NAME AS NAME_PRODUCT,
			S.IS_PRODUCTION,
			S.STOCK_CODE,
			S.BARCOD,
			S.IS_SERIAL_NO,
			S.MANUFACT_CODE,
			'#dateformat(now(),'YYYYMMDD')&timeformat(now(),'HHmmss')&'_#session.ep.USERID#_'&round(rand()*100)#' AS WRK_ROW_ID,
			'' AS WRK_ROW_RELATION_ID,
			NULL AS PBS_ID,
            '' OTVTOTAL,
			'' BASKET_EXTRA_INFO_ID,
			'' SELECT_INFO_EXTRA,
			'' DETAIL_INFO_EXTRA,
			NULL AS EXPENSE,
        	NULL AS EXPENSE_ITEM_NAME,
			NULL AS ROW_INTERNALDEMAND_ID
		FROM 
			TEXTILE_STRETCHING_TEST_ROWS STS
			INNER JOIN TEXTILE_STRETCHING_TEST_HEAD STH ON STS.STRETCHING_TEST_ID = STH.STRETCHING_TEST_ID
			CROSS APPLY (
			SELECT TOP 1 * FROM
			#dsn2#.STOCKS_ROW
			WHERE PRODUCT_ID = STS.PRODUCT_ID AND LOT_NO = STS.ROLL_ID
			) SR
			INNER JOIN #dsn3#.STOCKS S ON SR.STOCK_ID = S.STOCK_ID
			INNER JOIN #dsn1#.PRODUCT P ON STS.PRODUCT_ID = P.PRODUCT_ID
			INNER JOIN #dsn1#.PRODUCT_UNIT PU ON S.PRODUCT_UNIT_ID = PU.PRODUCT_UNIT_ID
		WHERE 
			STS.STRETCHING_TEST_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#attributes.st_id#'>
	</cfquery>
<cfelseif isdefined("attributes.upd_id")>	
	<cfquery name="GET_FIS_DETAIL" datasource="#dsn2#">
		SELECT
			S.IS_PRODUCTION IS_PRODUCTION_,
			SF.*,
			SFR.*,
			SFR.DELIVER_DATE AS ROW_DELIVER_DATE,
			SFR.RESERVE_DATE AS ROW_RESERVE_DATE,
			S.PRODUCT_NAME AS NAME_PRODUCT,
            SFR.BASKET_EMPLOYEE_ID,
			S.*,
			CASE 
				WHEN (SFR.ROW_INTERNALDEMAND_ID IS NOT NULL) 
				THEN (SELECT DISTINCT I_ID FROM #dsn3_alias#.INTERNALDEMAND_ROW WHERE I_ROW_ID = SFR.ROW_INTERNALDEMAND_ID) 
			ELSE 
			''
			END AS I_ID ,
            '' OTVTOTAL,
			E.EMPLOYEE_NAME + ' ' + E.EMPLOYEE_SURNAME AS BASKET_EMPLOYEE,
			EXC.EXPENSE,
        	EXI.EXPENSE_ITEM_NAME
		FROM
			STOCK_FIS SF,
			STOCK_FIS_ROW SFR
			LEFT JOIN #dsn2#.EXPENSE_CENTER AS EXC ON SFR.EXPENSE_CENTER_ID = EXC.EXPENSE_ID
        	LEFT JOIN #dsn2#.EXPENSE_ITEMS AS EXI ON SFR.EXPENSE_ITEM_ID = EXI.EXPENSE_ITEM_ID
			LEFT JOIN #dsn_alias#.EMPLOYEES AS E ON E.EMPLOYEE_ID = SFR.BASKET_EMPLOYEE_ID,
			#dsn3_alias#.STOCKS S
		WHERE
			SF.FIS_ID = SFR.FIS_ID AND
			SF.FIS_ID=#attributes.upd_id# AND
			SFR.STOCK_ID=S.STOCK_ID
		ORDER BY
			STOCK_FIS_ROW_ID
	</cfquery>
<cfelse>
	<cfset get_fis_detail.recordcount = 0>
</cfif>
<cfif get_fis_detail.recordcount>
	<cfset row_project_id_list_=listsort(ListDeleteDuplicates(valuelist(GET_FIS_DETAIL.ROW_PROJECT_ID)),'numeric','asc',',')>
	<cfif len(row_project_id_list_)>
		<cfquery name="GET_ROW_PROJECTS" datasource="#dsn#">
			SELECT PROJECT_HEAD,PROJECT_ID FROM PRO_PROJECTS WHERE PROJECT_ID IN (#row_project_id_list_#) ORDER BY PROJECT_ID
		</cfquery>
		<cfset row_project_id_list_=valuelist(GET_ROW_PROJECTS.PROJECT_ID)>
	</cfif>
    <cfset row_work_id_list_=listsort(ListDeleteDuplicates(valuelist(GET_FIS_DETAIL.ROW_WORK_ID)),'numeric','asc',',')>
	<cfif len(row_work_id_list_)>
		<cfquery name="GET_ROW_WORKS" datasource="#dsn#">
			SELECT WORK_HEAD,WORK_ID FROM PRO_WORKS WHERE WORK_ID IN (#row_work_id_list_#) ORDER BY WORK_ID
		</cfquery>
		<cfset row_work_id_list_=valuelist(GET_ROW_WORKS.WORK_ID)>
	</cfif>
<cfelse>
	<cfset row_project_id_list_ = 0>	
    <cfset row_work_id_list_ = 0>
</cfif>
<cfif isdefined('attributes.internal_row_info') or (isdefined("attributes.internal_demand_id") and isdefined("internald_row_id_list") and len(internald_row_id_list))>
 	<!--- satır bazlı ic talepten siparis olusturma cagrılmamıssa miktar kontrolu yapılır,satır bazlı da zaten miktar kontrolu yapılıp kalan miktar siparise gönderiliyor--->
	<cfquery name="get_order_internaldemands" datasource="#dsn3#">
		SELECT 
			SUM(AMOUNT) AS TOTAL_AMOUNT,STOCK_ID,PRODUCT_ID 
		FROM 
			INTERNALDEMAND_RELATION_ROW 
		WHERE 
			INTERNALDEMAND_ID IN (#attributes.internal_demand_id#)
			AND TO_STOCK_FIS_ID IS NOT NULL
		GROUP BY
			STOCK_ID,PRODUCT_ID 
	</cfquery>
<cfelse>
	<cfset get_order_internaldemands.recordcount=0>
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
	i=0;
</cfscript>
<cfif get_fis_detail.recordcount>
	<cfoutput query="get_fis_detail">
		<cfscript>
			used_stock_amount=0;
			if (isdefined('attributes.internal_row_info') or (isdefined("attributes.internal_demand_id") and isdefined("internald_row_id_list") and len(internald_row_id_list)))
			{
				if(isdefined('attributes.interd_row_amount_list') and isdefined('attributes.internaldemand_row_id')) //satır bazlı iç talepten siparis olusturulurken formdan gonderilen miktar alınır
				{
					if(len(listgetat(attributes.interd_row_amount_list,listfind(attributes.internaldemand_row_id,get_fis_detail.I_ROW_ID) )) ) 
						new_row_amount = listgetat(attributes.interd_row_amount_list,listfind(attributes.internaldemand_row_id,get_fis_detail.I_ROW_ID) );
					else
						new_row_amount = get_fis_detail.amount;
				}
				else if(get_order_internaldemands.recordcount) //siparisin cekildigi irsaliye varsa
				{
					SQLString = "SELECT TOTAL_AMOUNT FROM get_order_internaldemands WHERE PRODUCT_ID=#get_fis_detail.PRODUCT_ID# AND STOCK_ID=#get_fis_detail.STOCK_ID#";
					check_order_amount = cfquery(SQLString : SQLString, Datasource : DSN3, dbtype:'1');
					
					if(len(check_order_amount.total_amount))
					{
						if(isdefined('stock_left_amount_#get_fis_detail.STOCK_ID#') and len(evaluate('stock_left_amount_#get_fis_detail.STOCK_ID#')))
							used_stock_amount=evaluate('stock_left_amount_#get_fis_detail.STOCK_ID#');
						else
							used_stock_amount=check_order_amount.total_amount;
						if(used_stock_amount gte get_fis_detail.amount)
						{	
							'stock_left_amount_#get_fis_detail.STOCK_ID#'=used_stock_amount-get_fis_detail.amount;
							new_row_amount = 0;
						}
						else if(used_stock_amount lt get_fis_detail.amount)
						{
							new_row_amount = (get_fis_detail.amount-used_stock_amount);
							'stock_left_amount_#get_fis_detail.STOCK_ID#'=0;
						}
					}
					else
						new_row_amount = get_fis_detail.amount;
				 }
				 else
					new_row_amount = get_fis_detail.amount;
			}
		
			else if (isdefined('attributes.type'))//Üretim planlamadaki malzeme listesinde seçilen ürünlerin miktarlarınıda alır.
				new_row_amount  = listgetat(CONVERT_AMOUNT_STOCKS_ID,listfind(CONVERT_STOCKS_ID,GET_FIS_DETAIL.STOCK_ID,','),',');
			else if(isdefined('attributes.internal_row_info')) //satır bazlı ic talep listesinde secilen satırların miktarlarını alır
				new_row_amount  = listgetat(internald_row_amount_list,listfind(internald_row_id_list,GET_FIS_DETAIL.I_ROW_ID,','),',');
			else
				new_row_amount = amount;
			if(new_row_amount gt 0)//kalan miktar 0 dan büyükse baskete ekleyecek
			{
				i = i + 1;//basket indexi hesaplanıyor , ilk başta 0 atandı baskete ekleme yapıldıkça 1 arttırılacak
				sepet.satir[i] = StructNew(); 
				if(isdefined('attributes.type'))//Üretim planlamadaki malzeme listesinde seçilen ürünlerin miktarlarınıda alır.
					new_row_amount  = listgetat(CONVERT_AMOUNT_STOCKS_ID,listfind(CONVERT_STOCKS_ID,GET_FIS_DETAIL.STOCK_ID,','),',');
				sepet.satir[i].amount = new_row_amount;
				if(isdefined('get_fis_detail.wrk_row_id') and len(get_fis_detail.wrk_row_id) and isdefined("attributes.upd_id") and not isdefined("attributes.is_copy"))
					sepet.satir[i].wrk_row_id = get_fis_detail.wrk_row_id;
				else if(isdefined('get_fis_detail.wrk_row_id') and len(get_fis_detail.wrk_row_id) and isdefined("attributes.upd_id") and isdefined("attributes.is_copy"))
					sepet.satir[i].wrk_row_id ="WRK#i##round(rand()*65)##dateformat(now(),'YYYYMMDD')##timeformat(now(),'HHmmssL')##session.ep.userid##round(rand()*100)##i#";
				else
					sepet.satir[i].wrk_row_id ="WRK#i##round(rand()*65)##dateformat(now(),'YYYYMMDD')##timeformat(now(),'HHmmssL')##session.ep.userid##round(rand()*100)##i#";
				if(isdefined('CONVERT_WRK_ROW_ID') and len(CONVERT_WRK_ROW_ID) and CONVERT_WRK_ROW_ID neq 0)
					sepet.satir[i].wrk_row_relation_id = listgetat(CONVERT_WRK_ROW_ID,i,',');
				if(len(get_fis_detail.WRK_ROW_RELATION_ID))
					sepet.satir[i].wrk_row_relation_id = get_fis_detail.WRK_ROW_RELATION_ID;
				else
					sepet.satir[i].wrk_row_relation_id = '';
					
				if(isdefined('attributes.internal_row_info') and len(attributes.internal_row_info)) //iç talepten deposevk
					sepet.satir[i].row_ship_id='#get_fis_detail.I_ID#;#get_fis_detail.I_ROW_ID#';
				else if(isdefined('attributes.internal_demand_id') and isdefined('internald_row_id_list') and len(internald_row_id_list))
					sepet.satir[i].row_ship_id='#get_fis_detail.I_ID#;#get_fis_detail.I_ROW_ID#';
				else if(len(get_fis_detail.ROW_INTERNALDEMAND_ID))
					sepet.satir[i].row_ship_id='#get_fis_detail.I_ID#;#get_fis_detail.ROW_INTERNALDEMAND_ID#';
			
				sepet.satir[i].product_id = get_fis_detail.product_id;
				sepet.satir[i].is_inventory = get_fis_detail.is_inventory;
				sepet.satir[i].is_production = get_fis_detail.IS_PRODUCTION_;
				sepet.satir[i].pbs_id = get_fis_detail.PBS_ID;
				sepet.satir[i].product_name = get_fis_detail.name_product & " " & get_fis_detail.PROPERTY;
				
				sepet.satir[i].unit = unit;
				sepet.satir[i].unit_id = unit_id;
				if (isdefined('attributes.type'))
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
			
				if( not isdefined('attributes.type'))//Malzeme planında gelmiyorsa normal şekilde alsın
				{
					if (not len(get_fis_detail.discount1)) sepet.satir[i].indirim1=0; else  sepet.satir[i].indirim1=get_fis_detail.discount1;
					if (not len(get_fis_detail.discount2)) sepet.satir[i].indirim2=0; else  sepet.satir[i].indirim2=get_fis_detail.discount2;
					if (not len(get_fis_detail.discount3)) sepet.satir[i].indirim3=0; else  sepet.satir[i].indirim3=get_fis_detail.discount3;
					if (not len(get_fis_detail.discount4)) sepet.satir[i].indirim4=0; else  sepet.satir[i].indirim4=get_fis_detail.discount4;
					if (not len(get_fis_detail.discount5)) sepet.satir[i].indirim5=0; else  sepet.satir[i].indirim5=get_fis_detail.discount5;
				}
				else
				{
					sepet.satir[i].indirim1 = 0;
					sepet.satir[i].indirim2 = 0;
					sepet.satir[i].indirim3 = 0;
					sepet.satir[i].indirim4 = 0;
					sepet.satir[i].indirim5 = 0;
				}
				sepet.satir[i].indirim6 = 0;
				sepet.satir[i].indirim7 = 0;
				sepet.satir[i].indirim8 = 0;
				sepet.satir[i].indirim9 = 0;
				sepet.satir[i].indirim10 = 0;
			
				if(len(get_fis_detail.UNIQUE_RELATION_ID)) sepet.satir[i].row_unique_relation_id = get_fis_detail.UNIQUE_RELATION_ID; else sepet.satir[i].row_unique_relation_id = "";
				if(len(get_fis_detail.PRODUCT_NAME2)) sepet.satir[i].product_name_other = get_fis_detail.PRODUCT_NAME2; else sepet.satir[i].product_name_other = "";
				if(len(get_fis_detail.AMOUNT2)) sepet.satir[i].amount_other = get_fis_detail.AMOUNT2; else sepet.satir[i].amount_other= "";
				if(len(get_fis_detail.UNIT2)) sepet.satir[i].unit_other = get_fis_detail.UNIT2; else sepet.satir[i].unit_other = "";
				if(len(get_fis_detail.EXTRA_PRICE)) sepet.satir[i].ek_tutar = get_fis_detail.EXTRA_PRICE; else sepet.satir[i].ek_tutar = 0;
				if(len(get_fis_detail.EXTRA_PRICE_TOTAL)) sepet.satir[i].ek_tutar_total = get_fis_detail.EXTRA_PRICE_TOTAL; else sepet.satir[i].ek_tutar_total = 0;
				if(len(get_fis_detail.EXTRA_PRICE_OTHER_TOTAL)) sepet.satir[i].ek_tutar_other_total = get_fis_detail.EXTRA_PRICE_OTHER_TOTAL; else sepet.satir[i].ek_tutar_other_total = 0;
				if(len(get_fis_detail.SHELF_NUMBER)) sepet.satir[i].shelf_number = get_fis_detail.SHELF_NUMBER; else sepet.satir[i].shelf_number = "";
				if(len(get_fis_detail.TO_SHELF_NUMBER)) sepet.satir[i].to_shelf_number = get_fis_detail.TO_SHELF_NUMBER; else sepet.satir[i].to_shelf_number = "";
				if(len(get_fis_detail.DISCOUNT_COST)) sepet.satir[i].iskonto_tutar = get_fis_detail.DISCOUNT_COST; else sepet.satir[i].iskonto_tutar = 0;
			
				sepet.satir[i].marj = 0;
				
				sepet.satir[i].indirim_carpan = (100-sepet.satir[i].indirim1) * (100-sepet.satir[i].indirim2) * (100-sepet.satir[i].indirim3) * (100-sepet.satir[i].indirim4) * (100-sepet.satir[i].indirim5) * (100-sepet.satir[i].indirim6) * (100-sepet.satir[i].indirim7) * (100-sepet.satir[i].indirim8) * (100-sepet.satir[i].indirim9) * (100-sepet.satir[i].indirim10);
				sepet.satir[i].special_code = STOCK_CODE_2;
				sepet.satir[i].stock_id = stock_id;
				sepet.satir[i].barcode = get_fis_detail.BARCOD;
				sepet.satir[i].stock_code = get_fis_detail.STOCK_CODE;
				sepet.satir[i].manufact_code = get_fis_detail.PRODUCT_MANUFACT_CODE;
				if( not isdefined('attributes.type'))//Malzeme planında gelmiyorsa normal şekilde alsın
				{
					sepet.satir[i].duedate = get_fis_detail.DUE_DATE;
					sepet.satir[i].row_total = (amount*sepet.satir[i].price)+sepet.satir[i].ek_tutar_total;
				}
				else
				{
					sepet.satir[i].duedate = '';
					sepet.satir[i].row_total = (listgetat(CONVERT_AMOUNT_STOCKS_ID,i,',')*sepet.satir[i].price)+sepet.satir[i].ek_tutar_total;
				}
					
				if(len(OTVTOTAL))
				{ 
					sepet.satir[i].row_otvtotal =OTVTOTAL;
				}
				else
				{
					sepet.satir[i].row_otvtotal = 0;
				}
				if(len(NET_TOTAL))
					sepet.satir[i].row_nettotal = wrk_round(NET_TOTAL,price_round_number);
				else
					sepet.satir[i].row_nettotal = wrk_round((sepet.satir[i].row_total/100000000000000000000) * sepet.satir[i].indirim_carpan,price_round_number);
				if(len(TOTAL_TAX))
					sepet.satir[i].row_taxtotal = TOTAL_TAX;
				else
					sepet.satir[i].row_taxtotal = wrk_round(sepet.satir[i].row_nettotal * (tax/100),price_round_number);
				//if(len(TOTAL)) sepet.satir[i].row_lasttotal = TOTAL; else
				sepet.satir[i].row_lasttotal = sepet.satir[i].row_nettotal + sepet.satir[i].row_taxtotal;
				if (isdefined('attributes.type')){//Üretim planlamadaki malzeme listesinde seçilen ürünlerin miktarlarınıda alır.
					sepet.satir[i].price_other = listgetat(CONVERT_PRICE_OTHER,i,',');
					sepet.satir[i].other_money_value= listgetat(CONVERT_PRICE_OTHER,i,',');
					sepet.satir[i].other_money = listgetat(CONVERT_MONEY,i,',');
					if (isdefined("CONVERT_LIST_PRICE") and len(CONVERT_LIST_PRICE) and CONVERT_LIST_PRICE neq 0) {
						sepet.satir[i].list_price = listGetAt(CONVERT_LIST_PRICE,i, ',');
					}
					if(isdefined('CONVERT_COST_PRICE') and CONVERT_COST_PRICE neq 0)
						sepet.satir[i].net_maliyet = listgetat(CONVERT_COST_PRICE,i,',');
					if(isdefined('CONVERT_EXTRA_COST') and CONVERT_EXTRA_COST neq 0)
						sepet.satir[i].extra_cost = listgetat(CONVERT_EXTRA_COST,i,',');
				}	
				else
				{
					sepet.satir[i].other_money = OTHER_MONEY;
					sepet.satir[i].other_money_value = sepet.satir[i].row_nettotal;
					sepet.satir[i].price_other = PRICE_OTHER;
					if (len(COST_PRICE)) sepet.satir[i].net_maliyet = COST_PRICE; else sepet.satir[i].net_maliyet=0;
					if (len(extra_cost)) sepet.satir[i].extra_cost = extra_cost; else sepet.satir[i].extra_cost =0; 
				}	
				sepet.satir[i].other_money_grosstotal = sepet.satir[i].row_lasttotal;
				sepet.satir[i].deliver_date = dateformat(ROW_DELIVER_DATE,dateformat_style);
				if(len(ROW_RESERVE_DATE)) sepet.satir[i].reserve_date = dateformat(ROW_RESERVE_DATE,dateformat_style); else sepet.satir[i].reserve_date ='';
				sepet.satir[i].deliver_dept = "";
				sepet.satir[i].spect_id = spect_var_id;
				sepet.satir[i].spect_name = spect_var_name;
				sepet.satir[i].lot_no = LOT_NO;
			
				if(len(tax))
					sepet.satir[i].tax_percent = TAX;
				else
				{
					if(sepet.satir[i].price neq 0) 
						if(sepet.satir[i].row_nettotal neq 0)
							sepet.satir[i].tax_percent =(sepet.satir[i].row_taxtotal/sepet.satir[i].row_nettotal)*100; 
						else
							sepet.satir[i].tax_percent =0;
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
				
				if(len(WIDTH_VALUE)) sepet.satir[i].row_width = WIDTH_VALUE; else sepet.satir[i].row_width = '';
				if(len(DEPTH_VALUE)) sepet.satir[i].row_depth = DEPTH_VALUE; else  sepet.satir[i].row_depth = '';
				if(len(HEIGHT_VALUE)) sepet.satir[i].row_height = HEIGHT_VALUE; else  sepet.satir[i].row_height = '';
				if(isdefined("attributes.row_project_id#i#") && len(evaluate("attributes.row_project_id#i#")))//ak yapi stok sarf raporu
				{
					sepet.satir[i].row_project_id = evaluate("attributes.row_project_id#i#");
					sepet.satir[i].row_project_name = evaluate("attributes.row_project_name#i#");
				}
				else if(len(ROW_PROJECT_ID))
				{
					sepet.satir[i].row_project_id=ROW_PROJECT_ID;
					sepet.satir[i].row_project_name=GET_ROW_PROJECTS.PROJECT_HEAD[listfind(row_project_id_list_,ROW_PROJECT_ID)];
				}
				if(isdefined("attributes.row_work_id#i#") && len(evaluate("attributes.row_work_id#i#")))//ak yapi stok sarf raporu
				{
					sepet.satir[i].row_work_id = evaluate("attributes.row_work_id#i#");
					sepet.satir[i].row_work_name = evaluate("attributes.row_work_name#i#");
				}
				else if(len(ROW_WORK_ID))
				{
					sepet.satir[i].row_work_id=ROW_WORK_ID;
					sepet.satir[i].row_work_name=GET_ROW_WORKS.WORK_HEAD[listfind(row_work_id_list_,ROW_WORK_ID)];
				}
				if(len(BASKET_EXTRA_INFO_ID)) sepet.satir[i].basket_extra_info = BASKET_EXTRA_INFO_ID; else sepet.satir[i].basket_extra_info="";
				if(len(SELECT_INFO_EXTRA)) sepet.satir[i].select_info_extra = SELECT_INFO_EXTRA; else sepet.satir[i].select_info_extra="";
				if(len(DETAIL_INFO_EXTRA)) sepet.satir[i].detail_info_extra = DETAIL_INFO_EXTRA; else sepet.satir[i].detail_info_extra="";
			}
			if(isdefined("attributes.upd_id"))
			{
				if(len(BASKET_EMPLOYEE_ID))
				{	
					sepet.satir[i].basket_employee_id = BASKET_EMPLOYEE_ID; 
					sepet.satir[i].basket_employee = BASKET_EMPLOYEE; 
				}
				else
				{		
					sepet.satir[i].basket_employee_id = '';
					sepet.satir[i].basket_employee = '';
				}
			}

			if( (isdefined("attributes.internal_demand_id") and not isdefined("attributes.from_position_code")) or isdefined("attributes.upd_id")){
				
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

			}

		</cfscript>
    </cfoutput>
    <cfscript>
        for (k=1;k lte arraylen(sepet.kdv_array);k=k+1)
            sepet.kdv_array[k][2] = wrk_round(sepet.kdv_array[k][3] * sepet.kdv_array[k][1] /100,basket_total_round_number);
        
        for (k=1;k lte arraylen(sepet.kdv_array);k=k+1)
            sepet.total_tax = sepet.total_tax + sepet.kdv_array[k][2];
        sepet.total_otv=0;
        sepet.net_total = sepet.net_total + sepet.total_tax;
    </cfscript>
</cfif>
