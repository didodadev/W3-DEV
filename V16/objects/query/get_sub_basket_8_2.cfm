<cfquery name="GET_SHIP_ROW" datasource="#dsn3#">
	SELECT
		S.*,
		PU.ADD_UNIT,
		PU.PRODUCT_UNIT_ID,
		PU.MULTIPLIER,
		'Adet' AS UNIT,
		S.PRODUCT_UNIT_ID AS UNIT_ID,
		0 AS PRICE,
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
		0 AS EXTRA_COST,
		0 AS NETTOTAL,
		0 AS DISCOUNTTOTAL,
		0 AS TAXTOTAL,
		'#session.ep.money#' AS OTHER_MONEY,
		0 AS OTHER_MONEY_VALUE,
		0 AS OTHER_MONEY_GROSS_TOTAL,
		0 AS PRICE_OTHER
	FROM
		STOCKS S,
		PRODUCT_UNIT AS PU
	WHERE
		<cfif isdefined("invent_return_row_ids")>
			S.STOCK_ID IN (#invent_return_row_ids#) AND
		<cfelse>
			S.STOCK_ID IN (#kons_row_ids#) AND
		</cfif>
		S.PRODUCT_UNIT_ID = PU.PRODUCT_UNIT_ID
</cfquery>
<cfscript>
	sepet = StructNew();
	sepet.satir = ArrayNew(1);
	sepet.kdv_array = ArrayNew(2);
	sepet.total = 0;
	sepet.toplam_indirim = 0;
	sepet.total_tax = 0;
	sepet.net_total = 0;
	sepet.genel_indirim = 0;
	sepet.other_money = session.ep.MONEY2;
</cfscript>
<cfif GET_SHIP_ROW.recordcount>
<cfset i = 0>
<cfset attributes.irsaliye_id_listesi = ''>
<cfset attributes.irsaliye_project_id_listesi = ''>
<cfset attributes.irsaliye = ''>
<cfset row_iade_amount = 0>
<cfquery name="get_periods" datasource="#dsn#">
	SELECT * FROM SETUP_PERIOD WHERE OUR_COMPANY_ID = #session.ep.company_id# ORDER BY PERIOD_YEAR DESC
</cfquery>
<cfoutput query="GET_SHIP_ROW">
	<cfif isdefined("attributes.invent_return_amount_#stock_id#")>
		<cfset row_amount = replace(evaluate("attributes.invent_return_amount_#stock_id#"),'.','','all')>
	<cfelseif isdefined("attributes.kons_return_type") and attributes.kons_return_type eq 1>
		<cfset row_amount = replace(evaluate("attributes.kons_iade_#stock_id#"),'.','','all')>
	<cfelseif isdefined("attributes.kons_return_type") and attributes.kons_return_type eq 2>
		<cfset row_amount = replace(evaluate("attributes.sale_iade_#stock_id#"),'.','','all')>
	<cfelse>
		<cfset row_amount = 1>
	</cfif>
	<cfif row_amount gt 0>
		<cfset count_row_new = 0>
		<cfset kalan_amount = row_amount>
		<cfif isdefined("attributes.kons_return_type") and attributes.kons_return_type eq 1>
			<cfset kons_irsaliye_list = evaluate("kons_irsaliye_list_#stock_id#")>
			<cfloop list="#kons_irsaliye_list#" delimiters="," index="kk">
				<cfset new_ship_id_value = listgetat(kons_irsaliye_list,listfind(kons_irsaliye_list,kk))>
				<cfset new_ship_id = listgetat(new_ship_id_value,1,";")>
				<cfset new_period_id = listgetat(new_ship_id_value,2,";")>
				<cfset new_amount = listgetat(new_ship_id_value,3,";")>
				<cfset new_year = listgetat(new_ship_id_value,4,";")>
				<cfset new_number = listgetat(new_ship_id_value,5,";")>
				<cfset new_project_id = listgetat(new_ship_id_value,6,";")>
				<cfquery name="get_wrk_row_relation_id" datasource="#dsn2#">
					SELECT TOP 1 WRK_ROW_ID FROM #dsn#_#new_year#_#session.ep.company_id#.SHIP_ROW WHERE SHIP_ID = #new_ship_id# AND STOCK_ID=#get_ship_row.stock_id#
				</cfquery>
				<cfquery name="get_inv_amount" datasource="#dsn2#">
					SELECT
						SUM(AMOUNT) AMOUNT
					FROM
					(
						<cfset count_ = 0>
						<cfloop query="get_periods">
							<cfset count_ = count_ + 1>
							SELECT ISNULL(SUM(AMOUNT),0) AMOUNT FROM #dsn#_#get_periods.period_year#_#session.ep.company_id#.INVOICE_ROW WHERE INVOICE_ID IN(SELECT I.INVOICE_ID FROM #dsn#_#get_periods.period_year#_#session.ep.company_id#.INVOICE I WHERE I.IS_IPTAL = 0) AND WRK_ROW_RELATION_ID = '#get_wrk_row_relation_id.wrk_row_id#' 
							UNION ALL
							SELECT ISNULL(SUM(AMOUNT),0) AMOUNT FROM #dsn#_#get_periods.period_year#_#session.ep.company_id#.SHIP_ROW WHERE SHIP_ID IN(SELECT S.SHIP_ID FROM #dsn#_#get_periods.period_year#_#session.ep.company_id#.SHIP S WHERE S.SHIP_TYPE = 75 AND ISNULL(S.IS_SHIP_IPTAL,0) = 0) AND WRK_ROW_RELATION_ID = '#get_wrk_row_relation_id.wrk_row_id#'
							<cfif get_periods.recordcount neq count_>UNION ALL</cfif>
						</cfloop>
					)T1
				</cfquery>
				<cfset new_amount = new_amount - get_inv_amount.amount>
				<cfif kalan_amount lt new_amount>
					<cfset count_row_new = count_row_new + 1>
					<cfset "amount_#count_row_new#" = kalan_amount>
					<cfset "wrk_row_relation_id_info_#count_row_new#" = get_wrk_row_relation_id.wrk_row_id>
					<cfset "row_ship_id_info_#count_row_new#" = "#new_ship_id#;#new_period_id#">
					<cfset attributes.irsaliye_id_listesi = listappend(attributes.irsaliye_id_listesi,"#new_ship_id#;#new_period_id#")>
					<cfset attributes.irsaliye_project_id_listesi = listappend(attributes.irsaliye_project_id_listesi,new_project_id)>
					<cfset attributes.irsaliye = listappend(attributes.irsaliye,"#new_number#")>
					<cfset kalan_amount = 0>
					<cfbreak>
				<cfelseif new_amount neq 0>
					<cfset kalan_amount =  kalan_amount - new_amount > 
					<cfset attributes.irsaliye_id_listesi = listappend(attributes.irsaliye_id_listesi,"#new_ship_id#;#new_period_id#")>
					<cfset attributes.irsaliye_project_id_listesi = listappend(attributes.irsaliye_project_id_listesi,new_project_id)>
					<cfset attributes.irsaliye = listappend(attributes.irsaliye,"#new_number#")>
					<cfset count_row_new = count_row_new + 1>
					<cfset "amount_#count_row_new#" = new_amount>
					<cfset "row_ship_id_info_#count_row_new#" = "#new_ship_id#;#new_period_id#">
					<cfset "wrk_row_relation_id_info_#count_row_new#" = get_wrk_row_relation_id.wrk_row_id>
				</cfif>
			</cfloop>
		<cfelseif isdefined("attributes.kons_return_type") and attributes.kons_return_type eq 2>
			<cfset inv_irsaliye_list = evaluate("inv_irsaliye_list_#stock_id#")>
			<cfif inv_irsaliye_list neq 0>
				<cfloop list="#inv_irsaliye_list#" delimiters="," index="kk">
					<cfset new_ship_id_value = listgetat(inv_irsaliye_list,listfind(inv_irsaliye_list,kk))>
					<cfset new_ship_id = listgetat(new_ship_id_value,1,";")>
					<cfset new_period_id = listgetat(new_ship_id_value,2,";")>
					<cfset new_amount = listgetat(new_ship_id_value,3,";")>
					<cfset new_number = listgetat(new_ship_id_value,5,";")>
					<cfset new_year = listgetat(new_ship_id_value,4,";")>
					<cfset new_project_id = listgetat(new_ship_id_value,6,";")>
					<cfquery name="get_wrk_row_relation_id" datasource="#dsn2#">
						SELECT TOP 1 WRK_ROW_ID FROM #dsn#_#new_year#_#session.ep.company_id#.SHIP_ROW WHERE SHIP_ID = #new_ship_id# AND STOCK_ID=#get_ship_row.stock_id#
					</cfquery>
					<cfquery name="get_inv_amount" datasource="#dsn2#">
						SELECT
							SUM(AMOUNT) AMOUNT
						FROM
						(
							<cfset count_ = 0>
							<cfloop query="get_periods">
								<cfset count_ = count_ + 1>
								SELECT ISNULL(SUM(AMOUNT),0) AMOUNT FROM #dsn#_#get_periods.period_year#_#session.ep.company_id#.INVOICE_ROW WHERE INVOICE_ID IN(SELECT I.INVOICE_ID FROM #dsn#_#get_periods.period_year#_#session.ep.company_id#.INVOICE I WHERE I.IS_IPTAL = 0) AND WRK_ROW_RELATION_ID = '#get_wrk_row_relation_id.wrk_row_id#' 
								UNION ALL
								SELECT ISNULL(SUM(AMOUNT),0) AMOUNT FROM #dsn#_#get_periods.period_year#_#session.ep.company_id#.SHIP_ROW WHERE SHIP_ID IN(SELECT S.SHIP_ID FROM #dsn#_#get_periods.period_year#_#session.ep.company_id#.SHIP S WHERE S.SHIP_TYPE IN(74,73) AND ISNULL(S.IS_SHIP_IPTAL,0) = 0) AND WRK_ROW_RELATION_ID = '#get_wrk_row_relation_id.wrk_row_id#'
								<cfif get_periods.recordcount neq count_>UNION ALL</cfif>
							</cfloop>
						)T1
					</cfquery>
					<cfset new_amount = new_amount - get_inv_amount.amount>
					<cfif kalan_amount lt new_amount>
						<cfset count_row_new = count_row_new + 1>
						<cfset "amount_#count_row_new#" = kalan_amount>
						<cfset "wrk_row_relation_id_info_#count_row_new#" = get_wrk_row_relation_id.wrk_row_id>
						<cfset "row_ship_id_info_#count_row_new#" = "#new_ship_id#;#new_period_id#">
						<cfset attributes.irsaliye_id_listesi = listappend(attributes.irsaliye_id_listesi,"#new_ship_id#;#new_period_id#")>
						<cfset attributes.irsaliye_project_id_listesi = listappend(attributes.irsaliye_project_id_listesi,new_project_id)>
						<cfset attributes.irsaliye = listappend(attributes.irsaliye,"#new_number#")>
						<cfset kalan_amount = 0>
						<cfbreak>
					<cfelseif new_amount neq 0>
						<cfset kalan_amount =  kalan_amount - new_amount>
						<cfset attributes.irsaliye_id_listesi = listappend(attributes.irsaliye_id_listesi,"#new_ship_id#;#new_period_id#")>
						<cfset attributes.irsaliye_project_id_listesi = listappend(attributes.irsaliye_project_id_listesi,new_project_id)>
						<cfset attributes.irsaliye = listappend(attributes.irsaliye,"#new_number#")>
						<cfset count_row_new = count_row_new + 1>
						<cfset "amount_#count_row_new#" = new_amount>
						<cfset "wrk_row_relation_id_info_#count_row_new#" = get_wrk_row_relation_id.wrk_row_id>
						<cfset "row_ship_id_info_#count_row_new#" = "#new_ship_id#;#new_period_id#">
					</cfif>
				</cfloop>
			</cfif>
			<cfset kons_irsaliye_list = evaluate("kons_irsaliye_list_#stock_id#")>
			<cfloop list="#kons_irsaliye_list#" delimiters="," index="kk">
				<cfset new_ship_id_value = listgetat(kons_irsaliye_list,listfind(kons_irsaliye_list,kk))>
				<cfset new_ship_id = listgetat(new_ship_id_value,1,";")>
				<cfset new_period_id = listgetat(new_ship_id_value,2,";")>
				<cfset new_amount = listgetat(new_ship_id_value,3,";")>
				<cfset new_year = listgetat(new_ship_id_value,4,";")>
				<cfset new_number = listgetat(new_ship_id_value,5,";")>
				<cfset new_project_id = listgetat(new_ship_id_value,6,";")>
				<cfquery name="get_wrk_row_relation_id" datasource="#dsn2#">
					SELECT TOP 1 WRK_ROW_ID FROM #dsn#_#new_year#_#session.ep.company_id#.SHIP_ROW WHERE SHIP_ID = #new_ship_id# AND STOCK_ID=#get_ship_row.stock_id#
				</cfquery>
				<cfquery name="get_inv_amount" datasource="#dsn2#">
					SELECT
						SUM(AMOUNT) AMOUNT
					FROM
					(
						<cfset count_ = 0>
						<cfloop query="get_periods">
							<cfset count_ = count_ + 1>
							SELECT ISNULL(SUM(AMOUNT),0) AMOUNT FROM #dsn#_#get_periods.period_year#_#session.ep.company_id#.SHIP_ROW WHERE SHIP_ID IN(SELECT S.SHIP_ID FROM #dsn#_#get_periods.period_year#_#session.ep.company_id#.SHIP S WHERE S.SHIP_TYPE = 75 AND ISNULL(S.IS_SHIP_IPTAL,0) = 0) AND WRK_ROW_RELATION_ID = '#get_wrk_row_relation_id.wrk_row_id#'
							<cfif get_periods.recordcount neq count_>UNION ALL</cfif>
						</cfloop>
					)T1
				</cfquery>
				<cfset new_amount = new_amount - get_inv_amount.amount>
				<cfif kalan_amount lt new_amount>
					<cfset count_row_new = count_row_new + 1>
					<cfset "amount_#count_row_new#" = kalan_amount>
					<cfset "wrk_row_relation_id_info_#count_row_new#" = "">
					<cfset "row_ship_id_info_#count_row_new#" = "#new_ship_id#;#new_period_id#">
					<cfset attributes.irsaliye_id_listesi = listappend(attributes.irsaliye_id_listesi,"#new_ship_id#;#new_period_id#")>
					<cfset attributes.irsaliye_project_id_listesi = listappend(attributes.irsaliye_project_id_listesi,new_project_id)>
					<cfset attributes.irsaliye = listappend(attributes.irsaliye,"#new_number#")>
					<cfset kalan_amount = 0>
					<cfbreak>
				<cfelseif new_amount neq 0>
					<cfset kalan_amount =  kalan_amount - new_amount > 
					<cfset attributes.irsaliye_id_listesi = listappend(attributes.irsaliye_id_listesi,"#new_ship_id#;#new_period_id#")>
					<cfset attributes.irsaliye_project_id_listesi = listappend(attributes.irsaliye_project_id_listesi,new_project_id)>
					<cfset attributes.irsaliye = listappend(attributes.irsaliye,"#new_number#")>
					<cfset count_row_new = count_row_new + 1>
					<cfset "amount_#count_row_new#" = new_amount>
					<cfset "row_ship_id_info_#count_row_new#" = "#new_ship_id#;#new_period_id#">
					<cfset "wrk_row_relation_id_info_#count_row_new#" = "">
				</cfif>
			</cfloop>
		<cfelse>
			<cfset count_row_new = 1>
		</cfif>
		<cfif count_row_new neq 0>
			<cfloop from="1" to="#count_row_new#" index="i_index">
				<cfscript>
				i = i + 1;
				sepet.satir[i] = StructNew();
				
				sepet.satir[i].wrk_row_id ="WRK#i##round(rand()*65)##dateformat(now(),'YYYYMMDD')##timeformat(now(),'HHmmssL')##session.ep.userid##round(rand()*100)##i#";
				if(isdefined("wrk_row_relation_id_info_#i_index#"))
					sepet.satir[i].wrk_row_relation_id = evaluate("wrk_row_relation_id_info_#i_index#");
				else
					sepet.satir[i].wrk_row_relation_id = '';
					
				sepet.satir[i].product_id = PRODUCT_ID;
				sepet.satir[i].is_inventory = IS_INVENTORY;
				sepet.satir[i].is_production = IS_PRODUCTION;
				sepet.satir[i].product_name = PRODUCT_NAME;
				
				if(isdefined("amount_#i_index#"))
					sepet.satir[i].amount = evaluate("amount_#i_index#");
				else
					sepet.satir[i].amount = row_amount;
				
				if(len(sepet.satir[i].amount) and sepet.satir[i].amount neq 0)
				{
					AMOUNT = sepet.satir[i].amount;
					SATIR_AMOUNT = sepet.satir[i].amount;
				}
				else
				{
					AMOUNT = 1;
					SATIR_AMOUNT = 1;
				}
				LOT_NO = '';
				
				sepet.satir[i].unit = UNIT;
				sepet.satir[i].unit_id = UNIT_ID;
				sepet.satir[i].price = PRICE;
				if(isdefined("row_ship_id_info_#i_index#"))
					sepet.satir[i].row_ship_id = evaluate("row_ship_id_info_#i_index#");
				else
					sepet.satir[i].row_ship_id = '';
				if (not len(DISCOUNT1)) sepet.satir[i].indirim1 = 0; else sepet.satir[i].indirim1 = DISCOUNT1;
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
				if (len(EXTRA_COST)) sepet.satir[i].extra_cost = EXTRA_COST; else sepet.satir[i].extra_cost = 0;
				sepet.satir[i].paymethod_id = '';
				sepet.satir[i].stock_id = STOCK_ID;
				sepet.satir[i].barcode = BARCOD;
				sepet.satir[i].special_code = STOCK_CODE_2;
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
					sepet.satir[i].row_total = ((NETTOTAL+DISCOUNTTOTAL)/AMOUNT)*SATIR_AMOUNT;
					sepet.satir[i].row_nettotal = (NETTOTAL/AMOUNT)*SATIR_AMOUNT;
					sepet.satir[i].row_taxtotal = (TAXTOTAL/AMOUNT)*SATIR_AMOUNT;
					sepet.satir[i].row_lasttotal = sepet.satir[i].row_nettotal + sepet.satir[i].row_taxtotal;
					//if(len(GROSSTOTAL)) (GROSSTOTAL/AMOUNT)*SATIR_AMOUNT; else sepet.satir[i].row_lasttotal = 0;
				}
				else
				{
					sepet.satir[i].row_total = sepet.satir[i].amount * sepet.satir[i].price;
					sepet.satir[i].row_nettotal = (sepet.satir[i].row_total/100000000000000000000) * sepet.satir[i].indirim_carpan;
					sepet.satir[i].row_taxtotal = sepet.satir[i].row_nettotal * (sepet.satir[i].tax_percent/100);
					sepet.satir[i].row_lasttotal = sepet.satir[i].row_nettotal + sepet.satir[i].row_taxtotal;
				}
				sepet.satir[i].other_money = OTHER_MONEY;
				if(len(OTHER_MONEY_VALUE))
					sepet.satir[i].other_money_value = OTHER_MONEY_VALUE;
				else
					sepet.satir[i].other_money_value =0;
				sepet.satir[i].other_money_grosstotal = OTHER_MONEY_GROSS_TOTAL;
				
				sepet.satir[i].deliver_date = dateformat(now(),dateformat_style);
				
				sepet.satir[i].deliver_dept = ''; 
			
				sepet.satir[i].spect_id = '';
				sepet.satir[i].spect_name = '';
				
				
				sepet.satir[i].lot_no = LOT_NO;
				
				
				if(len(PRICE_OTHER))
					sepet.satir[i].price_other = PRICE_OTHER;
				else
					sepet.satir[i].price_other = PRICE;
			
				sepet.total = sepet.total + wrk_round(sepet.satir[i].row_total,basket_total_round_number); //subtotal_
				sepet.toplam_indirim = sepet.toplam_indirim + (wrk_round(sepet.satir[i].row_total,price_round_number) - wrk_round(sepet.satir[i].row_nettotal,price_round_number)); //discount_
				
				sepet.total_tax = sepet.total_tax + sepet.satir[i].row_taxtotal; //totaltax_
				sepet.net_total = sepet.net_total + sepet.satir[i].row_lasttotal; //nettotal_
			
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
			</cfloop>
		</cfif>
	</cfif>
</cfoutput>
</cfif>
<cfif len(attributes.irsaliye_id_listesi)>
	<script type="text/javascript">
		document.all.irsaliye_id_listesi.value = "<cfoutput>#attributes.irsaliye_id_listesi#</cfoutput>";
		document.all.irsaliye_project_id_listesi.value = "<cfoutput>#attributes.irsaliye_project_id_listesi#</cfoutput>";
		document.all.irsaliye.value = "<cfoutput>#attributes.irsaliye#</cfoutput>";
	</script>
</cfif>

