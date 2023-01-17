<cfquery name="UPD_SALE" datasource="#DSN2#">
	UPDATE
		STOCK_FIS
	SET
		FIS_TYPE = #attributes.process_type#,
		PROCESS_CAT = #attributes.PROCESS_CAT#,
		FIS_NUMBER = '#attributes.FIS_NO#',
		DEPARTMENT_OUT = <cfif len(attributes.department_name_2) and len(attributes.department_id_2)>#attributes.department_id_2#<cfelse>NULL</cfif>,
		LOCATION_OUT = <cfif len(attributes.department_name_2) and len(attributes.location_id_2)>#attributes.location_id_2#<cfelse>NULL</cfif>,
		DEPARTMENT_IN = <cfif len(attributes.department_name) and len(attributes.department_id)>#attributes.department_id#<cfelse>NULL</cfif>,
		LOCATION_IN = <cfif len(attributes.department_name) and len(attributes.location_id)>#attributes.location_id#<cfelse>NULL</cfif>,
		EMPLOYEE_ID = #DELIVER_GET_ID#,
		FIS_DATE = #attributes.start_date#,
		REF_NO = <cfif isdefined("attributes.ref_no") and len(attributes.ref_no)>'#attributes.ref_no#'<cfelse>NULL</cfif>,
		PROJECT_ID = <cfif isdefined("attributes.project_id") and len(attributes.project_id)>#attributes.project_id#<cfelse>NULL</cfif>,
		UPDATE_DATE = #now()#,
		UPDATE_EMP = #session.ep.userid#,
		UPDATE_IP = '#cgi.remote_addr#',
		FIS_DETAIL = '#attributes.detail#',
		SUBSCRIPTION_ID = <cfif isDefined("attributes.subscription_id") and len(attributes.subscription_id)>#attributes.subscription_id#<cfelse>NULL</cfif>           
	WHERE
		FIS_ID = #attributes.fis_id#
</cfquery>	
<cfquery name="DEL_STOCKS_ROW" datasource="#DSN2#">
	DELETE FROM STOCK_FIS_ROW WHERE FIS_ID = #attributes.fis_id#
</cfquery>
<cfquery name="DEL_STOCKS_ROW" datasource="#dsn2#">
	DELETE FROM STOCKS_ROW WHERE PROCESS_TYPE=#attributes.process_type# AND UPD_ID=#attributes.fis_id#
</cfquery>
<cfquery name="DEL_SHIP_ROW_MONEY" datasource="#dsn2#">
	DELETE FROM STOCK_FIS_MONEY WHERE ACTION_ID = #attributes.fis_id#
</cfquery>			
<cfquery name="DEL_INVENTORY_ROW" datasource="#dsn2#">
	DELETE FROM #dsn3_alias#.INVENTORY_ROW WHERE ACTION_ID = #attributes.fis_id# AND PROCESS_TYPE = #attributes.process_type# AND PERIOD_ID = #session.ep.period_id#
</cfquery>
<cfif len(attributes.department_id) and len(attributes.location_id)>
	<cfquery name="GET_LOCATION_TYPE" datasource="#dsn2#">
		SELECT LOCATION_TYPE,IS_SCRAP FROM #dsn_alias#.STOCKS_LOCATION WHERE DEPARTMENT_ID=#attributes.department_id# AND LOCATION_ID=#attributes.location_id#
	</cfquery>
	<cfset location_type=GET_LOCATION_TYPE.LOCATION_TYPE>
	<cfset is_scrap=GET_LOCATION_TYPE.IS_SCRAP>
<cfelse>
	<cfset location_type = "">
	<cfset is_scrap = "">
</cfif>
<cfloop from="1" to="#attributes.record_num#" index="i">
	<cfif isdefined("attributes.row_kontrol#i#") and evaluate("attributes.row_kontrol#i#")>
		<cfif isDefined("attributes.invent_id#i#") and len(evaluate("attributes.invent_id#i#"))>
			<cfquery name="get_inv_count" datasource="#dsn2#">
				SELECT ISNULL(AMORTIZATION_COUNT,0) AS INV_COUNT FROM #dsn3_alias#.INVENTORY WHERE INVENTORY_ID = #evaluate("attributes.invent_id#i#")#
			</cfquery>
			<cfquery name="UPD_INVT" datasource="#DSN2#">
				UPDATE
					#dsn3_alias#.INVENTORY
				SET
					SALE_DIFF_ACCOUNT_ID = <cfif len(evaluate("attributes.budget_account_id#i#"))>'#wrk_eval("attributes.budget_account_id#i#")#'<cfelse>NULL</cfif>,
					AMORT_DIFF_ACCOUNT_ID = <cfif len(evaluate("attributes.amort_account_id#i#"))>'#wrk_eval("attributes.amort_account_id#i#")#'<cfelse>NULL</cfif>,
					SALE_EXPENSE_CENTER_ID = <cfif len(evaluate("attributes.expense_center_id#i#"))>#evaluate("attributes.expense_center_id#i#")#<cfelse>NULL</cfif>,
					SALE_EXPENSE_ITEM_ID = <cfif len(evaluate("attributes.budget_item_id#i#"))>#evaluate("attributes.budget_item_id#i#")#<cfelse>NULL</cfif>
				WHERE
					INVENTORY_ID = #evaluate("attributes.invent_id#i#")#
			</cfquery>
			<cfset invent_id_info = evaluate("attributes.invent_id#i#")>
		</cfif>
		<cfif len(evaluate("attributes.stock_id#i#"))>
			<cfquery name="GET_PRODUCT_INFO_" datasource="#dsn2#">
				SELECT PRODUCT_ID FROM #dsn3_alias#.STOCKS WHERE STOCK_ID = #evaluate("attributes.stock_id#i#")#
			</cfquery>
		<cfelse>
			<cfset GET_PRODUCT_INFO_.product_id = ''>
		</cfif>
		<cfquery name="ADD_INVENT_ROW" datasource="#dsn2#">
			INSERT INTO 
			#dsn3_alias#.INVENTORY_ROW
			(
				INVENTORY_ID,
				PERIOD_ID,
				ACTION_ID,
				PAPER_NO,
				PROCESS_TYPE,
				QUANTITY,
				STOCK_OUT,
				SUBSCRIPTION_ID,
				ACTION_DATE,
				STOCK_ID,
				PRODUCT_ID
			)
			VALUES
			(
				#invent_id_info#,
				#session.ep.period_id#,
				#attributes.fis_id#,
				'#attributes.fis_no#',
				#attributes.process_type#,
				#evaluate("attributes.quantity#i#")#,
				#evaluate("attributes.quantity#i#")#,
				<cfif isDefined("attributes.subscription_id") and len(attributes.subscription_id)>#attributes.subscription_id#<cfelse>NULL</cfif>,
				#attributes.start_date#,
				<cfif len(evaluate("attributes.stock_id#i#"))>#evaluate("attributes.stock_id#i#")#<cfelse>NULL</cfif>,
				<cfif len(GET_PRODUCT_INFO_.product_id)>#GET_PRODUCT_INFO_.product_id#<cfelse>NULL</cfif>
			)
		</cfquery>
		<cfquery name="ADD_STOCK_FIS_ROW" datasource="#DSN2#">
			INSERT INTO 
				STOCK_FIS_ROW
					(
						FIS_ID,
						FIS_NUMBER,
						STOCK_ID,
						AMOUNT,
						UNIT,
						UNIT_ID,							
						PRICE,
						PRICE_OTHER,
						TAX,
						DISCOUNT1,
						DISCOUNT2,
						DISCOUNT3,
						DISCOUNT4,
						DISCOUNT5,
						TOTAL,
						TOTAL_TAX, 
						NET_TOTAL,
						OTHER_MONEY,
						INVENTORY_ID,
						WRK_ROW_ID
					)
			VALUES
					(
						#attributes.fis_id#,
						'#attributes.FIS_NO#',							
						#evaluate("attributes.stock_id#i#")#,
						#evaluate("attributes.quantity#i#")#,
						'#wrk_eval("attributes.stock_unit#i#")#',
						#evaluate("attributes.stock_unit_id#i#")#,							
						#evaluate("attributes.row_total#i#")#,
						#(evaluate("attributes.row_other_total#i#")/evaluate("attributes.quantity#i#"))#,
						#evaluate("attributes.tax_rate#i#")#,
						0,
						0,
						0,
						0,
						0,
						#evaluate("attributes.row_total#i#") * evaluate("attributes.quantity#i#")#,
						 #evaluate("attributes.kdv_total#i#")#, 
						#(evaluate("attributes.row_total#i#") * evaluate("attributes.quantity#i#")) + evaluate("attributes.kdv_total#i#")#,
						'#listgetat(evaluate("attributes.money_id#i#"),1,',')#',
						#invent_id_info#,
						<cfif isdefined('attributes.wrk_row_id#i#') and len(evaluate('attributes.wrk_row_id#i#'))>'#wrk_eval('attributes.wrk_row_id#i#')#'<cfelse>NULL</cfif>
					)
		</cfquery>
		<cfif is_stock_act>
			<cfquery name="GET_PRODUCT_INFO" datasource="#dsn2#">
				SELECT PRODUCT_ID FROM #dsn3_alias#.STOCKS WHERE STOCK_ID = #evaluate("attributes.stock_id#i#")#
			</cfquery>
			<cfquery name="GET_UNIT" datasource="#dsn2#">
				SELECT 
					ADD_UNIT,
					MULTIPLIER,
					MAIN_UNIT,
					PRODUCT_UNIT_ID
				FROM
					#dsn3_alias#.PRODUCT_UNIT
				WHERE 
					PRODUCT_ID = #GET_PRODUCT_INFO.PRODUCT_ID# AND
					ADD_UNIT = '#wrk_eval("attributes.stock_unit#i#")#'
			</cfquery>
			<cfif get_unit.recordcount and len(get_unit.multiplier)>
				<cfset multi = get_unit.multiplier*evaluate("attributes.quantity#i#")>
			<cfelse>
				<cfset multi = evaluate("attributes.quantity#i#")>
			</cfif>
			<cfquery name="ADD_STOCK_ROW" datasource="#dsn2#">
				INSERT INTO 
						STOCKS_ROW
						(
							UPD_ID,
							PRODUCT_ID,
							STOCK_ID,
							PROCESS_TYPE,
							STOCK_IN,
							STORE,
							STORE_LOCATION,
							PROCESS_DATE
						)
						VALUES
						(
							#attributes.fis_id#,
							#GET_PRODUCT_INFO.PRODUCT_ID#,
							#evaluate("attributes.stock_id#i#")#,
							#attributes.process_type#,
							#MULTI#,
							#attributes.department_id#,
							#attributes.location_id#,				
							#attributes.start_date#
						)
			</cfquery>
		</cfif>
	</cfif>
</cfloop>
<!--- muhasebe kayıtları --->
<!--- Demirbaş stok fişi muhasebesi --->
<cfscript>
	// alacak ve borc tutar, aciklama vs muhasebeciye ters gonderilmistir.
	// alacak icin satir_detay_list[1]; borc icin satir_detay_list[2]
	str_alacak_tutar_list="";
	str_alacak_kod_list="";
	str_borc_tutar_list="";
	str_borc_kod_list="";
	satir_detay_list = "";
	str_other_alacak_tutar_list = "";
	str_other_borc_tutar_list = "";
	str_other_borc_currency_list = "";
	str_other_alacak_currency_list = "";
	if(isDefined('attributes.detail') and len(attributes.detail))
		genel_fis_satir_detay = '#attributes.fis_no# - #attributes.detail#';
	else
		genel_fis_satir_detay = '#attributes.fis_no# DEMİRBAŞ STOK İADE FİŞİ';
		
	satir_detay_list = ArrayNew(2); //muhasebe fisi satır detaylarını tutar
	masraf_curr_multiplier =1;
	currency_multiplier = '';
	satir_currency_multiplier = 1;
			
	//Bütçe İşlemleri 
	butce_sil(action_id:attributes.fis_id,process_type:form.old_process_type);
	if(is_budget eq 1)
		{
		for(j=1;j lte attributes.record_num;j=j+1)
		{
			if(isDefined('attributes.kur_say') and len(attributes.kur_say))
				for(mon=1;mon lte attributes.kur_say;mon=mon+1)
				{
					if(evaluate("attributes.hidden_rd_money_#mon#") is listfirst(evaluate("attributes.money_id#j#"),','))
						masraf_curr_multiplier = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');
				}
			net_total=evaluate("attributes.row_total#j#")*evaluate("attributes.quantity#j#");//+evaluate("attributes.kdv_total#j#")
			temp_fis_date = CreateDateTime(year(attributes.start_date),month(attributes.start_date),day(attributes.start_date),0,0,0);
	 				temp_entry_date = CreateDateTime(year(evaluate("attributes.entry_date#j#")),month(evaluate("attributes.entry_date#j#")),day(evaluate("attributes.entry_date#j#")),0,0,0);					
					toplam_year = DateDiff("d",temp_entry_date,temp_fis_date)/360;
					if (toplam_year gte 1)
					{
						amor_net_total = net_total - (net_total * evaluate("attributes.amortization_rate#j#")/100);
					}						
					else {
						amor_net_total = net_total;
					}
			if (len(evaluate("attributes.budget_item_id#j#")) and len(evaluate("attributes.expense_center_id#j#")))
			butceci(
				action_id : attributes.fis_id,
				muhasebe_db : dsn2,
				is_income_expense : false,
				process_type : attributes.process_type,
				product_tax: evaluate("attributes.tax_rate#j#"),//kdv
				nettotal : wrk_round(amor_net_total),
				other_money_value : wrk_round(amor_net_total/masraf_curr_multiplier),
				action_currency : listfirst(evaluate("attributes.money_id#j#"),','),
				currency_multiplier : currency_multiplier,
				expense_date : attributes.start_date,
				expense_center_id : evaluate("attributes.expense_center_id#j#"),
				expense_item_id : evaluate("attributes.budget_item_id#j#"),
				detail : '#evaluate("attributes.invent_name#j#")#',
				paper_no : attributes.FIS_NO,
				branch_id : ListGetAt(session.ep.user_location,2,"-"),
				insert_type :1
				);
		}
	}
	
	if(is_account eq 1)
	{
		for(j=1;j lte attributes.record_num;j=j+1)
		{
		 if (isDefined('attributes.row_kontrol#j#') and evaluate("attributes.row_kontrol#j#") eq 1)
		 {
		 	if(evaluate("attributes.last_diff_value#j#") eq 0)//Eğer karlı veya zararlı bir satışsa ilk değer üzerinden gideceke değilse son değer üzerinden gidecek
				value_new = evaluate("attributes.last_inventory_value#j#")/evaluate("attributes.quantity#j#");
			else
				value_new = evaluate("attributes.unit_first_value#j#");
				
			//ürün
			get_tax_acc_code = cfquery(datasource : "#dsn2#", sqlstring : "SELECT PURCHASE_CODE,SALE_CODE FROM #dsn2_alias#.SETUP_TAX WHERE TAX = #evaluate("attributes.tax_rate#j#")#");
			get_product_id = cfquery(datasource : "#dsn2#", sqlstring : "SELECT PRODUCT_ID FROM #dsn3_alias#.STOCKS WHERE STOCK_ID = #evaluate("attributes.stock_id#j#")#");
			str_alacak_tutar_list = ListAppend(str_alacak_tutar_list,(evaluate("attributes.row_total#j#")*evaluate("attributes.quantity#j#")),",");
			str_other_alacak_tutar_list = ListAppend(str_other_alacak_tutar_list, wrk_round(((evaluate("attributes.row_total#j#")*evaluate("attributes.quantity#j#"))/satir_currency_multiplier),2),",");
			str_other_alacak_currency_list = ListAppend(str_other_alacak_currency_list,listgetat(evaluate("attributes.money_id#j#"), 1, ','),",");
			if(is_project_based_acc eq 1 and session.ep.our_company_info.project_followup eq 1 and len(attributes.project_id) and len(attributes.project_head))	// proje bazlı muhasebe islemi yapılacaksa
			{
				is_project_acc=1;
				product_account_codes=cfquery(datasource:"#dsn2#",sqlstring:"SELECT	ACCOUNT_CODE_PUR,SCRAP_CODE,MATERIAL_CODE,PRODUCTION_COST FROM #dsn3_alias#.PROJECT_PERIOD WHERE PROJECT_ID = #attributes.project_id# AND PERIOD_ID = #session.ep.period_id# ");
			}
			else
			{
				product_account_codes = get_product_account(prod_id:get_product_id.product_id);
			}
			if(isDefined('attributes.kur_say') and len(attributes.kur_say))
				for(mon=1;mon lte attributes.kur_say;mon=mon+1)
				{
					if(evaluate("attributes.hidden_rd_money_#mon#") is listfirst(evaluate("attributes.money_id#j#")))
						satir_currency_multiplier = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');
				}
			if(is_scrap eq 1)
				product_account_code = product_account_codes.SCRAP_CODE;
			else if (location_type eq 1) //hammadde lokasyonu secilmisse
				product_account_code = product_account_codes.MATERIAL_CODE;
			else if (location_type eq 3)//mamul lokasyonu secilmisse
				product_account_code = product_account_codes.PRODUCTION_COST;
			else
				product_account_code = product_account_codes.ACCOUNT_CODE_PUR;
			str_alacak_kod_list = ListAppend(str_alacak_kod_list,product_account_code,",");
			if(is_account_group eq 1)
				satir_detay_list[1][listlen(str_alacak_tutar_list)] = genel_fis_satir_detay;	
			else
				satir_detay_list[1][listlen(str_alacak_tutar_list)] = '#evaluate("attributes.invent_name#j#")#';
			//kdv
			if(evaluate("attributes.kdv_total#j#") gt 0)
			{
				str_alacak_tutar_list = ListAppend(str_alacak_tutar_list,(evaluate("attributes.kdv_total#j#")),",");
				str_other_alacak_tutar_list = ListAppend(str_other_alacak_tutar_list,wrk_round((evaluate("attributes.kdv_total#j#")/satir_currency_multiplier),2),",");
				str_other_alacak_currency_list = ListAppend(str_other_alacak_currency_list,listgetat(evaluate("attributes.money_id#j#"), 1, ','),",");
				str_alacak_kod_list = ListAppend(str_alacak_kod_list,get_tax_acc_code.purchase_code,",");
				if(is_account_group eq 1)
					satir_detay_list[1][listlen(str_alacak_tutar_list)] = genel_fis_satir_detay;
				else
					satir_detay_list[1][listlen(str_alacak_tutar_list)] = '#evaluate("attributes.invent_name#j#")#';
			}
			str_borc_tutar_list = ListAppend(str_borc_tutar_list,((evaluate("attributes.unit_first_value#j#")*evaluate("attributes.quantity#j#"))+evaluate("attributes.kdv_total#j#")),",");
			str_other_borc_tutar_list = ListAppend(str_other_borc_tutar_list,(((evaluate("attributes.unit_first_value#j#")*evaluate("attributes.quantity#j#"))+evaluate("attributes.kdv_total#j#"))/satir_currency_multiplier),",");
			str_other_borc_currency_list = ListAppend(str_other_borc_currency_list,listgetat(evaluate("attributes.money_id#j#"), 1, ','),",");
			str_borc_kod_list = ListAppend(str_borc_kod_list,evaluate("attributes.account_id#j#"),",");
			if(is_account_group eq 1)
				satir_detay_list[2][listlen(str_borc_tutar_list)] = genel_fis_satir_detay;
			else
				satir_detay_list[2][listlen(str_borc_tutar_list)] = '#evaluate("attributes.invent_name#j#")#';
			
			if(evaluate("attributes.last_diff_value#j#") gte 0)
			{
				if(evaluate("attributes.last_diff_value#j#") gt 0)
				{
					str_borc_tutar_list = listappend(str_borc_tutar_list,evaluate("attributes.last_diff_value#j#"),',');
					str_other_borc_tutar_list = listappend(str_other_borc_tutar_list,wrk_round(evaluate("attributes.last_diff_value#j#")/satir_currency_multiplier),',');
					str_other_borc_currency_list = listappend(str_other_borc_currency_list,listgetat(evaluate("attributes.money_id#j#"), 1, ','),',');
					str_borc_kod_list = listappend(str_borc_kod_list,evaluate("attributes.budget_account_id#j#"),',');
					if(is_account_group eq 1)
						satir_detay_list[2][listlen(str_borc_tutar_list)] = genel_fis_satir_detay;
					else
						satir_detay_list[2][listlen(str_borc_tutar_list)] = '#evaluate("attributes.invent_name#j#")#';
				}
				str_alacak_tutar_list = listappend(str_alacak_tutar_list,abs(evaluate("attributes.last_inventory_value#j#")-evaluate("attributes.total_first_value#j#")),',');
				str_other_alacak_tutar_list = listappend(str_other_alacak_tutar_list,wrk_round(abs(evaluate("attributes.last_inventory_value#j#")-evaluate("attributes.total_first_value#j#"))/satir_currency_multiplier),',');
				str_other_alacak_currency_list = listappend(str_other_alacak_currency_list,listgetat(evaluate("attributes.money_id#j#"), 1, ','),',');
				str_alacak_kod_list = listappend(str_alacak_kod_list,evaluate("attributes.amort_account_id#j#"),',');
				if(is_account_group eq 1)
					satir_detay_list[1][listlen(str_alacak_tutar_list)] = genel_fis_satir_detay;
				else
					satir_detay_list[1][listlen(str_alacak_tutar_list)] = '#evaluate("attributes.invent_name#j#")#';
			}
			else if(evaluate("attributes.last_diff_value#j#") lt 0)
			{
				str_alacak_tutar_list = listappend(str_alacak_tutar_list,abs(evaluate("attributes.last_diff_value#j#")),',');
				str_other_alacak_tutar_list = listappend(str_other_alacak_tutar_list,wrk_round(abs(evaluate("attributes.last_diff_value#j#"))/satir_currency_multiplier),',');
				str_other_alacak_currency_list = listappend(str_other_alacak_currency_list,listgetat(evaluate("attributes.money_id#j#"), 1, ','),',');
				str_alacak_kod_list = listappend(str_alacak_kod_list,evaluate("attributes.budget_account_id#j#"),',');
				if(is_account_group eq 1)
					satir_detay_list[1][listlen(str_alacak_tutar_list)] = genel_fis_satir_detay;
				else
					satir_detay_list[1][listlen(str_alacak_tutar_list)] = '#evaluate("attributes.invent_name#j#")#';
				
				str_alacak_tutar_list = listappend(str_alacak_tutar_list,abs(evaluate("attributes.last_inventory_value#j#")-evaluate("attributes.total_first_value#j#")),',');
				str_other_alacak_tutar_list = listappend(str_other_alacak_tutar_list,wrk_round(abs(evaluate("attributes.last_inventory_value#j#")-evaluate("attributes.total_first_value#j#"))/satir_currency_multiplier),',');
				str_other_alacak_currency_list = listappend(str_other_alacak_currency_list,listgetat(evaluate("attributes.money_id#j#"), 1, ','),',');
				str_alacak_kod_list = listappend(str_alacak_kod_list,evaluate("attributes.amort_account_id#j#"),',');
				if(is_account_group eq 1)
					satir_detay_list[1][listlen(str_alacak_tutar_list)] = genel_fis_satir_detay;
				else
					satir_detay_list[1][listlen(str_alacak_tutar_list)] = '#evaluate("attributes.invent_name#j#")#';
			}
		  }
	    }
		//BORC-ALACAK FARKI ICIN YUVARLAMA TUTARLARI EKLENIYOR
		temp_total_alacak = evaluate(ListChangeDelims(str_alacak_tutar_list,'+',','));/* alacakli hesaplar toplam degeri */
		temp_total_borc = evaluate(ListChangeDelims(str_borc_tutar_list,'+',','));/* borclu hesaplar toplam degeri */
		temp_fark = round((temp_total_alacak-temp_total_borc)*100);
		if(temp_fark neq 0)
			FARK_HESAP = cfquery(datasource:"#dsn2#",sqlstring:"SELECT FARK_GELIR,FARK_GIDER FROM #dsn3_alias#.SETUP_INVOICE_PURCHASE");
		
		if( temp_fark gte -3 and temp_fark lt 0 )
		{/* gelir hesabi alacaklilara eklenmeli, borc bakiye gelmis */
			str_alacak_kod_list = ListAppend(str_alacak_kod_list, FARK_HESAP.FARK_GELIR, ",");
			str_alacak_tutar_list = ListAppend(str_alacak_tutar_list, abs(temp_fark/100), ",");
			satir_detay_list[1][listlen(str_alacak_tutar_list)]=genel_fis_satir_detay;
			str_other_alacak_tutar_list = ListAppend(str_other_alacak_tutar_list, abs(temp_fark/100),",");
			str_other_alacak_currency_list = ListAppend(str_other_alacak_currency_list,session.ep.money,",");
		}
		else if( temp_fark lte 3 and temp_fark gt 0 )
		{/* gider hesabi borclulara eklenmeli, alacak bakiye gelmis */
			str_borc_kod_list = ListAppend(str_borc_kod_list, FARK_HESAP.FARK_GIDER, ",");
			str_borc_tutar_list = ListAppend(str_borc_tutar_list, abs(temp_fark/100), ",");
			satir_detay_list[2][listlen(str_borc_tutar_list)]=genel_fis_satir_detay;
			str_other_borc_tutar_list = ListAppend(str_other_borc_tutar_list, abs(temp_fark/100),",");
			str_other_borc_currency_list = ListAppend(str_other_borc_currency_list,session.ep.money,",");
		}
			muhasebeci (
			wrk_id:wrk_id,
			action_id:attributes.fis_id,
			workcube_process_type : attributes.process_type,
			workcube_old_process_type : form.old_process_type,
			account_card_type : 13,
			islem_tarihi : attributes.start_date,			
			alacak_hesaplar : str_borc_kod_list,
			alacak_tutarlar : str_borc_tutar_list,			
			borc_hesaplar : str_alacak_kod_list,
			borc_tutarlar : str_alacak_tutar_list,			
			fis_satir_detay: satir_detay_list,
			fis_detay : 'DEMİRBAŞ STOK İADE FİŞİ',
			belge_no : attributes.FIS_NO,
			other_amount_alacak : str_other_borc_tutar_list,
			other_currency_alacak : str_other_borc_currency_list,			
			other_amount_borc : str_other_alacak_tutar_list,
			other_currency_borc : str_other_alacak_currency_list,			
			from_branch_id : branch_id_2, //CIKIS depo
			to_branch_id : branch_id, //giris depo
			is_account_group : is_account_group,
			currency_multiplier : currency_multiplier,
			workcube_process_cat : form.process_cat,
			acc_project_id : iif((isdefined("attributes.project_id") and len(attributes.project_id) and isDefined("attributes.project_head") and len(attributes.project_head)),attributes.project_id,de(''))
		);
	}
	else
		muhasebe_sil(action_id:attributes.fis_id, process_type:form.old_process_type);
</cfscript>		
<!--- money kayıtları --->
<cfloop from="1" to="#attributes.kur_say#" index="i">
	<cfquery name="ADD_MONEY_INFO" datasource="#dsn2#">
		INSERT INTO STOCK_FIS_MONEY 
		(
			ACTION_ID,
			MONEY_TYPE,
			RATE2,
			RATE1,
			IS_SELECTED
		)
		VALUES
		(
			#attributes.fis_id#,
			'#wrk_eval("attributes.hidden_rd_money_#i#")#',
			#evaluate("attributes.txt_rate2_#i#")#,
			#evaluate("attributes.txt_rate1_#i#")#,
			<cfif evaluate("attributes.hidden_rd_money_#i#") is rd_money_value>1<cfelse>0</cfif>
		)
	</cfquery>
</cfloop>
<cfif len(get_process_type.action_file_name)> <!--- secilen islem kategorisine bir action file eklenmisse --->
	<cf_workcube_process_cat 
		process_cat="#form.process_cat#"
		action_id = #attributes.fis_id#
		is_action_file = 1
		action_file_name='#get_process_type.action_file_name#'
		action_db_type = '#dsn2#'
		is_template_action_file='#get_process_type.action_file_from_template#'>
</cfif>
