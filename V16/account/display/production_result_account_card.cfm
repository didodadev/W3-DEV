<!---Select  ifadeleri ile ilgili çalışma yapıldı. Egemen Ateş 16.07.2012 --->
<cf_xml_page_edit fuseact="account.production_result_account_card">
<cfsetting showdebugoutput="no">
<cfparam name="attributes.startdate" default="#dateformat(now(),dateformat_style)#">
<cfparam name="attributes.finishdate" default="#dateformat(now(),dateformat_style)#">
<cf_date tarih='attributes.finishdate'>
<cf_date tarih='attributes.startdate'>
<cfif isdefined('attributes.is_form_submitted') and attributes.is_form_submitted eq 1>
	<cfquery name="get_prod" datasource="#dsn3#">
		SELECT
			PRODUCTION_ORDER_RESULTS.PR_ORDER_ID,
			SPC.IS_ACCOUNT_GROUP,
			SPC.IS_DISCOUNT,
			SPC.IS_PROD_COST_ACC_ACTION
		FROM 
			PRODUCTION_ORDER_RESULTS,
			SETUP_PROCESS_CAT SPC
		WHERE 
			PRODUCTION_ORDER_RESULTS.PROCESS_ID = SPC.PROCESS_CAT_ID
		<cfif isDefined("attributes.startdate") and isdate(attributes.startdate)>
			AND FINISH_DATE >= #attributes.startdate#
		</cfif>
		<cfif isDefined("attributes.finishdate") and isdate(attributes.finishdate)>
			AND FINISH_DATE < #dateadd('d',1,attributes.finishdate)#
		</cfif>
		ORDER BY
			PR_ORDER_ID
	</cfquery>
	<cfif get_prod.recordcount>
		<cfscript>
			GET_NO_ = cfquery(datasource:"#dsn2#", sqlstring:"SELECT FARK_GELIR,FARK_GIDER FROM #dsn3_alias#.SETUP_INVOICE_PURCHASE");
			str_fark_gelir =GET_NO_.FARK_GELIR;
			str_fark_gider =GET_NO_.FARK_GIDER;
			str_max_round = 0.9;
		</cfscript>
		<cfquery name="get_sarf" datasource="#dsn3#">
			SELECT 
				SUM(ISNULL(PURCHASE_NET_SYSTEM,0)*AMOUNT) PURCHASE_NET_SYSTEM,
				SUM(ISNULL(PURCHASE_EXTRA_COST_SYSTEM,0)*AMOUNT) PURCHASE_EXTRA_COST_SYSTEM,
				SUM(ISNULL(PURCHASE_EXTRA_COST,0)*AMOUNT) PURCHASE_EXTRA_COST,
				SUM(ISNULL(PURCHASE_NET,0)*AMOUNT) PURCHASE_NET,
				PRODUCTION_ORDER_RESULTS_ROW.PRODUCT_ID,
				STOCKS.PRODUCT_NAME	,
				(SELECT MATERIAL_CODE FROM PRODUCT_PERIOD WHERE PRODUCT_ID = PRODUCTION_ORDER_RESULTS_ROW.PRODUCT_ID AND PERIOD_ID = #session.ep.period_id#) MATERIAL_CODE,
				(SELECT DIMM_CODE FROM PRODUCT_PERIOD WHERE PRODUCT_ID = PRODUCTION_ORDER_RESULTS_ROW.PRODUCT_ID AND PERIOD_ID = #session.ep.period_id#) DIMM_CODE
			 FROM 
				PRODUCTION_ORDER_RESULTS_ROW,
				STOCKS
			WHERE 
				PR_ORDER_ID IN(#valuelist(get_prod.pr_order_id)#) AND 
				TYPE = 2 AND 
				STOCKS.STOCK_ID = PRODUCTION_ORDER_RESULTS_ROW.STOCK_ID
			GROUP BY
				PRODUCTION_ORDER_RESULTS_ROW.PRODUCT_ID,
				STOCKS.PRODUCT_NAME	
		</cfquery>
		<cfquery name="get_fire" datasource="#dsn3#">
			SELECT 
				SUM(ISNULL(PURCHASE_NET_SYSTEM,0)*AMOUNT) PURCHASE_NET_SYSTEM,
				SUM(ISNULL(PURCHASE_EXTRA_COST_SYSTEM,0)*AMOUNT) PURCHASE_EXTRA_COST_SYSTEM,
				SUM(ISNULL(PURCHASE_EXTRA_COST,0)*AMOUNT) PURCHASE_EXTRA_COST,
				SUM(ISNULL(PURCHASE_NET,0)*AMOUNT) PURCHASE_NET,
				PRODUCTION_ORDER_RESULTS_ROW.PRODUCT_ID,
				STOCKS.PRODUCT_NAME	
			 FROM 
				PRODUCTION_ORDER_RESULTS_ROW,
				STOCKS
			WHERE 
				PR_ORDER_ID IN(#valuelist(get_prod.pr_order_id)#) AND 
				TYPE = 3 AND 
				STOCKS.STOCK_ID = PRODUCTION_ORDER_RESULTS_ROW.STOCK_ID
			GROUP BY
				AMOUNT,
				PRODUCTION_ORDER_RESULTS_ROW.PRODUCT_ID,
				STOCKS.PRODUCT_NAME	
		</cfquery>
		<cfquery name="get_order_result_prods" datasource="#dsn3#">
			SELECT 
				SUM(ISNULL(PURCHASE_NET_SYSTEM,0)*AMOUNT) PURCHASE_NET_SYSTEM,
				SUM(ISNULL(PURCHASE_EXTRA_COST_SYSTEM,0)*AMOUNT) PURCHASE_EXTRA_COST_SYSTEM,
				SUM(ISNULL(PURCHASE_EXTRA_COST,0)*AMOUNT) PURCHASE_EXTRA_COST,
				SUM(ISNULL(PURCHASE_NET,0)*AMOUNT) PURCHASE_NET,
				SUM(ISNULL(LABOR_COST_SYSTEM,0)*AMOUNT) LABOR_COST_SYSTEM,
				SUM(ISNULL(STATION_REFLECTION_COST_SYSTEM,0)*AMOUNT) STATION_REFLECTION_COST_SYSTEM,
				PRODUCTION_ORDER_RESULTS_ROW.PRODUCT_ID,
				STOCKS.PRODUCT_NAME		
			 FROM 
				PRODUCTION_ORDER_RESULTS_ROW,
				STOCKS 
			WHERE 
				PR_ORDER_ID IN(#valuelist(get_prod.pr_order_id)#) AND 
				TYPE = 1 AND 
				STOCKS.STOCK_ID = PRODUCTION_ORDER_RESULTS_ROW.STOCK_ID
			GROUP BY
				AMOUNT,
				PRODUCTION_ORDER_RESULTS_ROW.PRODUCT_ID,
				STOCKS.PRODUCT_NAME		
		</cfquery>

		<cfset muhasebe_uyari = ''>
		<cflock name="#CreateUUID()#" timeout="60">
			<cftransaction>
            	<cfquery name="truncate_table" datasource="#dsn3#">
                	DELETE FROM #dsn2_alias#.PRODUCTION_COST_ROWS WHERE START_DATE = #attributes.startdate# AND FINISH_DATE =  #attributes.finishdate#
                </cfquery>
				<cfquery name="Get_Account_Control" datasource="#dsn3#">
					SELECT
						CARD_ID
					FROM
						#dsn2_alias#.ACCOUNT_CARD
					WHERE
						ACTION_ID = 0 AND
						ACTION_TYPE = 171 AND
						ACTION_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#">
				</cfquery>
				<cfif Get_Account_Control.RecordCount>
					<cfquery name="Del_Account_Card_Rows" datasource="#dsn3#">
						DELETE FROM #dsn2_alias#.ACCOUNT_CARD_ROWS WHERE CARD_ID IN (#ValueList(Get_Account_Control.Card_Id)#)
					</cfquery>
					<cfquery name="Del_Account_Card_Rows2" datasource="#dsn3#">
						DELETE FROM #dsn2_alias#.ACCOUNT_ROWS_IFRS WHERE CARD_ID IN (#ValueList(Get_Account_Control.Card_Id)#)
					</cfquery>
					<cfquery name="Del_Account_Cards" datasource="#dsn3#">
						DELETE FROM #dsn2_alias#.ACCOUNT_CARD WHERE CARD_ID IN (#ValueList(Get_Account_Control.Card_Id)#)
					</cfquery>
				</cfif>
				<cfscript>
					Date_Detail = "#DateFormat(attributes.startdate,dateformat_style)# - #DateFormat(attributes.finishdate,dateformat_style)#";
					str_borclu_hesaplar = '' ;
					str_alacakli_hesaplar = '' ;
					str_borc_tutar = '' ;
					str_alacak_tutar = '' ;
					str_alacak_dovizli = '' ;
					str_borc_dovizli = '' ;
					str_other_currency_borc = '' ;
					str_other_currency_alacak = '';
					//sarf urunleri
					for(ii=1;ii lte get_sarf.recordcount; ii=ii+1) 
					{	
						temp_cost_price_system_exit=get_sarf.PURCHASE_NET_SYSTEM[ii];
						temp_cost_price_system_exit=temp_cost_price_system_exit+get_sarf.PURCHASE_EXTRA_COST_SYSTEM[ii];
						temp_cost_price_exit=get_sarf.PURCHASE_NET_SYSTEM[ii];
						temp_cost_price_exit = temp_cost_price_exit + get_sarf.PURCHASE_EXTRA_COST_SYSTEM[ii];							
						
						if(ListFind(str_borclu_hesaplar,get_sarf.DIMM_CODE[ii],",") eq 0) {
							str_borclu_hesaplar = ListAppend(str_borclu_hesaplar, get_sarf.DIMM_CODE[ii], ",");	 //urunun İlk Madde Malzeme Hesabı borc yazılır
							str_borc_tutar = ListAppend(str_borc_tutar, wrk_round(temp_cost_price_system_exit),",");	
							str_borc_dovizli = ListAppend(str_borc_dovizli, wrk_round(temp_cost_price_exit),",");
							str_other_currency_borc = ListAppend(str_other_currency_borc,session.ep.money,",");
						} else {
							str_borc_tutar = ListSetAt(str_borc_tutar,ListFind(str_borclu_hesaplar,get_sarf.DIMM_CODE[ii],","), ListGetAt(str_borc_tutar,ListFind(str_borclu_hesaplar,get_sarf.DIMM_CODE[ii],",")) + wrk_round(temp_cost_price_system_exit));
							str_borc_dovizli = ListSetAt(str_borc_dovizli,ListFind(str_borclu_hesaplar,get_sarf.DIMM_CODE[ii],","), ListGetAt(str_borc_dovizli,ListFind(str_borclu_hesaplar,get_sarf.DIMM_CODE[ii],",")) + wrk_round(temp_cost_price_exit));
						}

						if(ListFind(str_alacakli_hesaplar,get_sarf.MATERIAL_CODE[ii],",") eq 0) {
							str_alacakli_hesaplar = ListAppend(str_alacakli_hesaplar, get_sarf.MATERIAL_CODE[ii], ",");	// urunun hammadde alacakli
							str_alacak_tutar = ListAppend(str_alacak_tutar, wrk_round(temp_cost_price_system_exit),",");	
							str_alacak_dovizli = ListAppend(str_alacak_dovizli, wrk_round(temp_cost_price_exit),",");
							str_other_currency_alacak = ListAppend(str_other_currency_alacak,session.ep.money,",");
						} else {
							str_alacak_tutar = ListSetAt(str_alacak_tutar,ListFind(str_alacakli_hesaplar,get_sarf.MATERIAL_CODE[ii],","), ListGetAt(str_alacak_tutar,ListFind(str_alacakli_hesaplar,get_sarf.MATERIAL_CODE[ii],",")) + wrk_round(temp_cost_price_system_exit));
							str_alacak_dovizli = ListSetAt(str_alacak_dovizli,ListFind(str_alacakli_hesaplar,get_sarf.MATERIAL_CODE[ii],","), ListGetAt(str_alacak_dovizli,ListFind(str_alacakli_hesaplar,get_sarf.MATERIAL_CODE[ii],",")) + wrk_round(temp_cost_price_exit));
						}						
						if(not len(get_sarf.DIMM_CODE[ii]))
							muhasebe_uyari = "#muhasebe_uyari#;#get_sarf.PRODUCT_NAME[ii]# #getlang('','Ürünü İçin İlk Madde Malzeme Hesabı Eksik','34151')#.";
						if(not len(get_sarf.MATERIAL_CODE[ii]))
							muhasebe_uyari = "#muhasebe_uyari#;#get_sarf.PRODUCT_NAME[ii]# #getlang('','Ürünü İçin Hammadde Eksik','64334')#.";
					}
					if(len(muhasebe_uyari))
					{
						for(kk=1;kk<=listlen(muhasebe_uyari,';');kk=kk+1)
						{							
							writeoutput("#listgetat(muhasebe_uyari,kk,';')#<br />");
							abort("#getLang(dictionary_id:34154)#!"); //<cf_get_lang dictionary_id='34154.Yukarıdaki Ürünler İçin Düzenleme Yapmalısınız'>
						}
					}
					
					GET_NO_ = cfquery(datasource:"#dsn3#", sqlstring:"SELECT * FROM #dsn3_alias#.SETUP_INVOICE_PURCHASE");
					str_fark_gelir =GET_NO_.FARK_GELIR;
					str_fark_gider =GET_NO_.FARK_GIDER;
					str_max_round = 0.9;
					str_round_detail = '#Date_Detail# ÜRETİM ÇIKIŞ FİŞİ';
					muhasebeci
					(
						action_id : 0,
						workcube_process_type : 171,
						workcube_process_cat : 0,
						muhasebe_db : '#dsn3#',
						account_card_type : 13,
						islem_tarihi : attributes.finishdate,
						borc_hesaplar : str_borclu_hesaplar,
						borc_tutarlar : str_borc_tutar,
						other_amount_borc : str_borc_dovizli,
						other_currency_borc : str_other_currency_borc,
						alacak_hesaplar : str_alacakli_hesaplar,
						alacak_tutarlar : str_alacak_tutar,
						other_amount_alacak : str_alacak_dovizli,
						other_currency_alacak :str_other_currency_alacak,
						fis_detay : '#Date_Detail# ÜRETİM ÇIKIŞ FİŞİ',
						fis_satir_detay : '#Date_Detail# ÜRETİM ÇIKIŞ FİŞİ',
						is_account_group : 1,
						dept_round_account :str_fark_gider,
						claim_round_account : str_fark_gelir,
						max_round_amount :str_max_round,
						round_row_detail:str_round_detail
					);
				</cfscript>
                <!--- uretimden cikis fisine ait satirlar tabloya kaydedilir : type:1 --->
                <cfif get_sarf.recordcount>
					<cfoutput query="get_sarf">
                        <cfquery name="add_sarf" datasource="#dsn3#">
                            INSERT INTO
                                #dsn2_alias#.PRODUCTION_COST_ROWS
                                (
                                    PRODUCT_ID,
                                    PRODUCT_NAME,
                                    DEBT_ACCOUNT_CODE,
                                    CLAIM_ACCOUNT_CODE,
                                    CLAIM_ACCOUNT_CODE_LABOR,
                                    AMOUNT,
                                    TYPE,
                                    START_DATE,
                                    FINISH_DATE
                          		)
                                VALUES
                                (
                                 	#get_sarf.PRODUCT_ID#,
                                    '#get_sarf.PRODUCT_NAME#',
                                    '#get_sarf.DIMM_CODE#',
                                    '#get_sarf.MATERIAL_CODE#',
                                    NULL,
                                    #get_sarf.PURCHASE_NET_SYSTEM+get_sarf.PURCHASE_EXTRA_COST_SYSTEM#,
                                    1,
                                    <cfif isDefined("attributes.startdate") and isdate(attributes.startdate)>#attributes.startdate#<cfelse>NULL</cfif>,
                                    <cfif isDefined("attributes.finishdate") and isdate(attributes.finishdate)>#attributes.finishdate#<cfelse>NULL</cfif>
                              	)
                        </cfquery>
                    </cfoutput>
                </cfif>
				<!--- İş emri gerçekleşme(üretim sonucu) için tarih aralığında muhasebe kaydı oluşturulacak. Üretilen ürünün Üretim/Yarı mamul hesabına borç, işçilik yansıtma hesabına ve ilk madde/malzeme hesabına alacak yazacak. Hammaddelerin toplam maliyetini ve işçiliğin toplam maliyetini alacağa yazacak--->
				<cfscript>
					str_borclu_hesaplar = '' ;
					str_alacakli_hesaplar = '' ;
					str_borc_tutar = '' ;
					str_alacak_tutar = '' ;
					str_alacak_dovizli = '' ;
					str_borc_dovizli = '' ;
					str_other_currency_borc = '' ;
					str_other_currency_alacak = '';
					//üretilen ürün
					for(iii=1;iii lte get_order_result_prods.recordcount; iii=iii+1) 
					{	
						account_codes =  cfquery(datasource:'#dsn3#',sqlstring:'SELECT DIMM_YANS_CODE,PROD_LABOR_COST_CODE,HALF_PRODUCTION_COST FROM PRODUCT_PERIOD WHERE PRODUCT_ID = #get_order_result_prods.PRODUCT_ID[iii]# AND PERIOD_ID = #session.ep.period_id#');
						
						if(ListFind(str_alacakli_hesaplar,account_codes.PROD_LABOR_COST_CODE,",") eq 0) {
							str_alacakli_hesaplar = ListAppend(str_alacakli_hesaplar, account_codes.PROD_LABOR_COST_CODE, ",");	
							str_alacak_tutar = ListAppend(str_alacak_tutar, wrk_round(get_order_result_prods.LABOR_COST_SYSTEM[iii]),",");
							str_alacak_dovizli = ListAppend(str_alacak_dovizli, wrk_round(get_order_result_prods.LABOR_COST_SYSTEM[iii]),",");
							str_other_currency_alacak = ListAppend(str_other_currency_alacak,session.ep.money,",");
						} else {
							str_alacak_tutar = ListSetAt(str_alacak_tutar,ListFind(str_alacakli_hesaplar,account_codes.PROD_LABOR_COST_CODE,","), ListGetAt(str_alacak_tutar,ListFind(str_alacakli_hesaplar,account_codes.PROD_LABOR_COST_CODE,",")) + wrk_round(get_order_result_prods.LABOR_COST_SYSTEM[iii]));
							str_alacak_dovizli = ListSetAt(str_alacak_dovizli,ListFind(str_alacakli_hesaplar,account_codes.PROD_LABOR_COST_CODE,","), ListGetAt(str_alacak_dovizli,ListFind(str_alacakli_hesaplar,account_codes.PROD_LABOR_COST_CODE,",")) + wrk_round(get_order_result_prods.LABOR_COST_SYSTEM[iii]));
						}
						
						if (isDefined("is_dimm_code") and is_dimm_code eq 1)
						{
							//sarflar
							if(get_sarf.recordcount)
							{
								for(xxx=1;xxx lte get_sarf.recordcount; xxx=xxx+1) 
								{
									sarf_dimm_code =  cfquery(datasource:'#dsn3#',sqlstring:'SELECT DIMM_YANS_CODE FROM PRODUCT_PERIOD WHERE PRODUCT_ID = #get_sarf.PRODUCT_ID[xxx]# AND PERIOD_ID = #session.ep.period_id#');
									if (sarf_dimm_code.recordcount)
									{
										if(ListFind(str_alacakli_hesaplar,sarf_dimm_code.DIMM_YANS_CODE,",") eq 0) {
											str_alacakli_hesaplar = ListAppend(str_alacakli_hesaplar, sarf_dimm_code.DIMM_YANS_CODE, ",");
											str_alacak_tutar = ListAppend(str_alacak_tutar, wrk_round(get_sarf.PURCHASE_NET_SYSTEM[xxx] + get_sarf.PURCHASE_EXTRA_COST_SYSTEM[xxx]),",");	
											str_alacak_dovizli = ListAppend(str_alacak_dovizli, wrk_round(get_sarf.PURCHASE_NET_SYSTEM[xxx] + get_sarf.PURCHASE_EXTRA_COST_SYSTEM[xxx]),",");
											str_other_currency_alacak = ListAppend(str_other_currency_alacak,session.ep.money,",");
										} else {
											str_alacak_tutar = ListSetAt(str_alacak_tutar,ListFind(str_alacakli_hesaplar,sarf_dimm_code.DIMM_YANS_CODE,","), ListGetAt(str_alacak_tutar,ListFind(str_alacakli_hesaplar,sarf_dimm_code.DIMM_YANS_CODE,",")) + wrk_round(get_sarf.PURCHASE_NET_SYSTEM[xxx] + get_sarf.PURCHASE_EXTRA_COST_SYSTEM[xxx]));
											str_alacak_dovizli = ListSetAt(str_alacak_dovizli,ListFind(str_alacakli_hesaplar,sarf_dimm_code.DIMM_YANS_CODE,","), ListGetAt(str_alacak_dovizli,ListFind(str_alacakli_hesaplar,sarf_dimm_code.DIMM_YANS_CODE,",")) + wrk_round(get_sarf.PURCHASE_NET_SYSTEM[xxx] + get_sarf.PURCHASE_EXTRA_COST_SYSTEM[xxx]));
										}
									}
								}
							}
							//fireler
							if(get_fire.recordcount)
							{
								for(yyy=1;yyy lte get_fire.recordcount; yyy=yyy+1) 
								{
									fire_dimm_code =  cfquery(datasource:'#dsn3#',sqlstring:'SELECT DIMM_YANS_CODE FROM PRODUCT_PERIOD WHERE PRODUCT_ID = #get_fire.PRODUCT_ID[yyy]# AND PERIOD_ID = #session.ep.period_id#');
									if(ListFind(str_alacakli_hesaplar,fire_dimm_code.DIMM_YANS_CODE,",") eq 0) {
										str_alacakli_hesaplar = ListAppend(str_alacakli_hesaplar, fire_dimm_code.DIMM_YANS_CODE, ",");
										str_alacak_tutar = ListAppend(str_alacak_tutar, wrk_round(get_fire.PURCHASE_NET_SYSTEM[yyy] + get_fire.PURCHASE_EXTRA_COST_SYSTEM[yyy]),",");	
										str_alacak_dovizli = ListAppend(str_alacak_dovizli, wrk_round(get_fire.PURCHASE_NET_SYSTEM[yyy] + get_fire.PURCHASE_EXTRA_COST_SYSTEM[yyy]),",");
										str_other_currency_alacak = ListAppend(str_other_currency_alacak,session.ep.money,",");
									} else {
										str_alacak_tutar = ListSetAt(str_alacak_tutar,ListFind(str_alacakli_hesaplar,fire_dimm_code.DIMM_YANS_CODE,","), ListGetAt(str_alacak_tutar,ListFind(str_alacakli_hesaplar,fire_dimm_code.DIMM_YANS_CODE,",")) + wrk_round(get_fire.PURCHASE_NET_SYSTEM[yyy] + get_fire.PURCHASE_EXTRA_COST_SYSTEM[yyy]));
										str_alacak_dovizli = ListSetAt(str_alacak_dovizli,ListFind(str_alacakli_hesaplar,fire_dimm_code.DIMM_YANS_CODE,","), ListGetAt(str_alacak_dovizli,ListFind(str_alacakli_hesaplar,fire_dimm_code.DIMM_YANS_CODE,",")) + wrk_round(get_fire.PURCHASE_NET_SYSTEM[yyy] + get_fire.PURCHASE_EXTRA_COST_SYSTEM[yyy]));
									}
								}
							}
						}
						else
						{
							if(ListFind(str_alacakli_hesaplar,account_codes.DIMM_YANS_CODE,",") eq 0) {
								str_alacakli_hesaplar = ListAppend(str_alacakli_hesaplar, account_codes.DIMM_YANS_CODE, ",");
								str_alacak_tutar = ListAppend(str_alacak_tutar, wrk_round(get_order_result_prods.PURCHASE_NET_SYSTEM[iii] + get_order_result_prods.PURCHASE_EXTRA_COST_SYSTEM[iii]),",");	
								str_alacak_dovizli = ListAppend(str_alacak_dovizli, wrk_round(get_order_result_prods.PURCHASE_NET_SYSTEM[iii] + get_order_result_prods.PURCHASE_EXTRA_COST_SYSTEM[iii]),",");
								str_other_currency_alacak = ListAppend(str_other_currency_alacak,session.ep.money,",");
							} else {
								str_alacak_tutar = ListSetAt(str_alacak_tutar,ListFind(str_alacakli_hesaplar,account_codes.DIMM_YANS_CODE,","), ListGetAt(str_alacak_tutar,ListFind(str_alacakli_hesaplar,account_codes.DIMM_YANS_CODE,",")) + wrk_round(get_order_result_prods.PURCHASE_NET_SYSTEM[iii] + get_order_result_prods.PURCHASE_EXTRA_COST_SYSTEM[iii]));
								str_alacak_dovizli = ListSetAt(str_alacak_dovizli,ListFind(str_alacakli_hesaplar,account_codes.DIMM_YANS_CODE,","), ListGetAt(str_alacak_dovizli,ListFind(str_alacakli_hesaplar,account_codes.DIMM_YANS_CODE,",")) + wrk_round(get_order_result_prods.PURCHASE_NET_SYSTEM[iii] + get_order_result_prods.PURCHASE_EXTRA_COST_SYSTEM[iii]));
							}
						}
						if(ListFind(str_borclu_hesaplar,account_codes.HALF_PRODUCTION_COST,",") eq 0) {
							str_borclu_hesaplar = ListAppend(str_borclu_hesaplar, account_codes.HALF_PRODUCTION_COST, ",");	
							str_borc_tutar = ListAppend(str_borc_tutar, wrk_round(get_order_result_prods.PURCHASE_NET_SYSTEM[iii]+get_order_result_prods.LABOR_COST_SYSTEM[iii] + get_order_result_prods.PURCHASE_EXTRA_COST_SYSTEM[iii]),",");	
							str_borc_dovizli = ListAppend(str_borc_dovizli, wrk_round(get_order_result_prods.PURCHASE_NET_SYSTEM[iii]+get_order_result_prods.LABOR_COST_SYSTEM[iii] + get_order_result_prods.PURCHASE_EXTRA_COST_SYSTEM[iii]),",");
							str_other_currency_borc = ListAppend(str_other_currency_borc,session.ep.money,",");
						} else {
							str_borc_tutar = ListSetAt(str_borc_tutar,ListFind(str_borclu_hesaplar,account_codes.HALF_PRODUCTION_COST,","), ListGetAt(str_borc_tutar,ListFind(str_borclu_hesaplar,account_codes.HALF_PRODUCTION_COST,",")) + wrk_round(get_order_result_prods.PURCHASE_NET_SYSTEM[iii]+get_order_result_prods.LABOR_COST_SYSTEM[iii] + get_order_result_prods.PURCHASE_EXTRA_COST_SYSTEM[iii]));
							str_borc_dovizli = ListSetAt(str_borc_dovizli,ListFind(str_borclu_hesaplar,account_codes.HALF_PRODUCTION_COST,","), ListGetAt(str_borc_dovizli,ListFind(str_borclu_hesaplar,account_codes.HALF_PRODUCTION_COST,",")) + wrk_round(get_order_result_prods.PURCHASE_NET_SYSTEM[iii]+get_order_result_prods.LABOR_COST_SYSTEM[iii] + get_order_result_prods.PURCHASE_EXTRA_COST_SYSTEM[iii]));
						}
						
						if(not len(account_codes.DIMM_YANS_CODE))
							muhasebe_uyari = "#muhasebe_uyari#;#get_order_result_prods.PRODUCT_NAME[iii]# Ürünü İçin İlk Madde Malzeme Yansıtma Hesabı Eksik.";
						if(not len(account_codes.PROD_LABOR_COST_CODE))
							muhasebe_uyari = "#muhasebe_uyari#;#get_order_result_prods.PRODUCT_NAME[iii]# Ürünü İçin Üretim İşçilik Yansıtma Hesabı Eksik.";
						if(not len(account_codes.HALF_PRODUCTION_COST))
							muhasebe_uyari = "#muhasebe_uyari#;#get_order_result_prods.PRODUCT_NAME[iii]# Ürünü İçin Yarı Mamül Hesabı Eksik.";
					}
							
					GET_NO_ = cfquery(datasource:"#dsn3#", sqlstring:"SELECT * FROM #dsn3_alias#.SETUP_INVOICE_PURCHASE");
					str_fark_gelir =GET_NO_.FARK_GELIR;
					str_fark_gider =GET_NO_.FARK_GIDER;
					str_max_round = 0.9;
					str_round_detail = '#Date_Detail# ÜRETİM SONUCU';
					if(len(muhasebe_uyari))
					{
						for(kk=1;kk<=listlen(muhasebe_uyari,';');kk=kk+1)
						{
							writeoutput("#listgetat(muhasebe_uyari,kk,';')#<br />");
							abort("#getLang(dictionary_id:34154)#!"); //<cf_get_lang dictionary_id='34154.Yukarıdaki Ürünler İçin Düzenleme Yapmalısınız'>
						}
					}
					muhasebeci
					(
						action_id : 0,
						workcube_process_type : 171,
						workcube_process_cat : 0,
						muhasebe_db : '#dsn3#',
						account_card_type : 13,
						islem_tarihi : attributes.finishdate,
						borc_hesaplar : str_borclu_hesaplar,
						borc_tutarlar : str_borc_tutar,
						other_amount_borc : str_borc_dovizli,
						other_currency_borc : str_other_currency_borc,
						alacak_hesaplar : str_alacakli_hesaplar,
						alacak_tutarlar : str_alacak_tutar,
						other_amount_alacak : str_alacak_dovizli,
						other_currency_alacak :str_other_currency_alacak,
						fis_detay : '#Date_Detail# ÜRETİM SONUCU',
						fis_satir_detay : '#Date_Detail# ÜRETİM SONUCU',
						is_account_group : 1,
						dept_round_account :str_fark_gider,
						claim_round_account : str_fark_gelir,
						max_round_amount :str_max_round,
						round_row_detail:str_round_detail
					);
				</cfscript>	
                <!--- uretim sonucu fisine ait satirlar tabloya kaydedilir : type:2 --->
                <cfif get_order_result_prods.recordcount>
					<cfoutput query="get_order_result_prods">
                    	<cfquery name="get_acc_codes_" datasource="#dsn3#">
                        	SELECT DIMM_YANS_CODE,PROD_LABOR_COST_CODE,HALF_PRODUCTION_COST FROM PRODUCT_PERIOD WHERE PRODUCT_ID = #get_order_result_prods.PRODUCT_ID# AND PERIOD_ID = #session.ep.period_id#
                        </cfquery>
                        <cfquery name="add_order_result_prods" datasource="#dsn3#">
                            INSERT INTO
                                #dsn2_alias#.PRODUCTION_COST_ROWS
                                (
                                    PRODUCT_ID,
                                    PRODUCT_NAME,
                                    DEBT_ACCOUNT_CODE,
                                    CLAIM_ACCOUNT_CODE,
                                    CLAIM_ACCOUNT_CODE_LABOR,
                                    AMOUNT,
                                    TYPE,
                                    START_DATE,
                                    FINISH_DATE
                          		)
                                VALUES
                                (
                                 	#get_order_result_prods.PRODUCT_ID#,
                                    '#get_order_result_prods.PRODUCT_NAME#',
                                    '#get_acc_codes_.HALF_PRODUCTION_COST#',
                                    '#get_acc_codes_.DIMM_YANS_CODE#',
                                    '#get_acc_codes_.PROD_LABOR_COST_CODE#',
                                    #get_order_result_prods.PURCHASE_NET_SYSTEM+get_order_result_prods.PURCHASE_EXTRA_COST_SYSTEM+get_order_result_prods.LABOR_COST_SYSTEM#,
                                    2,
                                    <cfif isDefined("attributes.startdate") and isdate(attributes.startdate)>#attributes.startdate#<cfelse>NULL</cfif>,
                                    <cfif isDefined("attributes.finishdate") and isdate(attributes.finishdate)>#attributes.finishdate#<cfelse>NULL</cfif>
                              	)
                        </cfquery>
                    </cfoutput>
                </cfif>
				<!--- Endirek maliyet muhasebe kaydı oluşacak. Üretilen ürünün detayındaki Genel Üretim Giderleri Yansıtma Hesabına alacak, üretim yarı mamul hesabına borç yazacak. Masraflardan yansıtma tutarına göre borç-alacak yazacak --->
				<cfscript>
					str_borclu_hesaplar = '' ;
					str_alacakli_hesaplar = '' ;
					str_borc_tutar = '' ;
					str_alacak_tutar = '' ;
					str_alacak_dovizli = '' ;
					str_borc_dovizli = '' ;
					str_other_currency_borc = '' ;
					str_other_currency_alacak = '';
					temp_cost_price_system_exit = 0;
					temp_cost_price_exit = 0;
					//sarf urunleri
					for(i=1;i lte get_sarf.recordcount; i=i+1) 
					{	
						temp_cost_price_system_exit=temp_cost_price_system_exit+ get_sarf.PURCHASE_NET_SYSTEM[i];
						temp_cost_price_exit=temp_cost_price_exit + get_sarf.PURCHASE_NET[i];
					}
					//üretilen ürün
					for(i=1;i lte get_order_result_prods.recordcount; i=i+1) 
					{	
						account_codes =  cfquery(datasource:'#dsn3#',sqlstring:'SELECT HALF_PRODUCTION_COST,PROD_GENERAL_CODE,PRODUCTION_COST FROM PRODUCT_PERIOD WHERE PRODUCT_ID = #get_order_result_prods.PRODUCT_ID[i]# AND PERIOD_ID = #session.ep.period_id#');
						
						if(ListFind(str_borclu_hesaplar,account_codes.HALF_PRODUCTION_COST,",") eq 0) {
							str_borclu_hesaplar = ListAppend(str_borclu_hesaplar, account_codes.HALF_PRODUCTION_COST, ",");	
							str_borc_tutar = ListAppend(str_borc_tutar, wrk_round(get_order_result_prods.STATION_REFLECTION_COST_SYSTEM[i]),",");	
							str_borc_dovizli = ListAppend(str_borc_dovizli, wrk_round(get_order_result_prods.STATION_REFLECTION_COST_SYSTEM[i]),",");
							str_other_currency_borc = ListAppend(str_other_currency_borc,session.ep.money,",");
						} else {
							str_borc_tutar = ListSetAt(str_borc_tutar,ListFind(str_borclu_hesaplar,account_codes.HALF_PRODUCTION_COST,","), ListGetAt(str_borc_tutar,ListFind(str_borclu_hesaplar,account_codes.HALF_PRODUCTION_COST,",")) + wrk_round(get_order_result_prods.STATION_REFLECTION_COST_SYSTEM[i]));
							str_borc_dovizli = ListSetAt(str_borc_dovizli,ListFind(str_borclu_hesaplar,account_codes.HALF_PRODUCTION_COST,","), ListGetAt(str_borc_dovizli,ListFind(str_borclu_hesaplar,account_codes.HALF_PRODUCTION_COST,",")) + wrk_round(get_order_result_prods.STATION_REFLECTION_COST_SYSTEM[i]));
						}

						if(ListFind(str_alacakli_hesaplar,account_codes.PROD_GENERAL_CODE,",") eq 0) {
							str_alacakli_hesaplar = ListAppend(str_alacakli_hesaplar, account_codes.PROD_GENERAL_CODE, ",");	
							str_alacak_tutar = ListAppend(str_alacak_tutar, wrk_round(get_order_result_prods.STATION_REFLECTION_COST_SYSTEM[i]),",");
							str_alacak_dovizli = ListAppend(str_alacak_dovizli, wrk_round(get_order_result_prods.STATION_REFLECTION_COST_SYSTEM[i]),",");
							str_other_currency_alacak = ListAppend(str_other_currency_alacak,session.ep.money,",");
						} else {
							str_alacak_tutar = ListSetAt(str_alacak_tutar,ListFind(str_alacakli_hesaplar,account_codes.PROD_GENERAL_CODE,","), ListGetAt(str_alacak_tutar,ListFind(str_alacakli_hesaplar,account_codes.PROD_GENERAL_CODE,",")) + wrk_round(get_order_result_prods.STATION_REFLECTION_COST_SYSTEM[i]));
							str_alacak_dovizli = ListSetAt(str_alacak_dovizli,ListFind(str_alacakli_hesaplar,account_codes.PROD_GENERAL_CODE,","), ListGetAt(str_alacak_dovizli,ListFind(str_alacakli_hesaplar,account_codes.PROD_GENERAL_CODE,",")) + wrk_round(get_order_result_prods.STATION_REFLECTION_COST_SYSTEM[i]));
						}
						
						if(not len(account_codes.PROD_GENERAL_CODE))
							muhasebe_uyari = "#muhasebe_uyari#;#get_order_result_prods.PRODUCT_NAME[i]# Ürünü İçin Genel Üretim Giderleri Yansıtma Hesabı Eksik.";
						if(not len(account_codes.HALF_PRODUCTION_COST))
							muhasebe_uyari = "#muhasebe_uyari#;#get_order_result_prods.PRODUCT_NAME[i]# Ürünü İçin Yarı Mamül Hesabı Eksik.";
					}
					GET_NO_ = cfquery(datasource:"#dsn3#", sqlstring:"SELECT * FROM #dsn3_alias#.SETUP_INVOICE_PURCHASE");
					str_fark_gelir =GET_NO_.FARK_GELIR;
					str_fark_gider =GET_NO_.FARK_GIDER;
					str_max_round = 0.9;
					str_round_detail = '#Date_Detail# ENDİREKT MALİYET';
					if(len(muhasebe_uyari))
					{
						for(kk=1;kk<=listlen(muhasebe_uyari,';');kk=kk+1)
						{
							writeoutput("#listgetat(muhasebe_uyari,kk,';')#<br />");
							abort("#getLang(dictionary_id:34154)#!"); //<cf_get_lang dictionary_id='34154.Yukarıdaki Ürünler İçin Düzenleme Yapmalısınız'>
						}
					}
					muhasebeci
					(
						action_id : 0,
						workcube_process_type : 171,
						workcube_process_cat : 0,
						muhasebe_db : '#dsn3#',
						account_card_type : 13,
						islem_tarihi : attributes.finishdate,
						borc_hesaplar : str_borclu_hesaplar,
						borc_tutarlar : str_borc_tutar,
						other_amount_borc : str_borc_dovizli,
						other_currency_borc : str_other_currency_borc,
						alacak_hesaplar : str_alacakli_hesaplar,
						alacak_tutarlar : str_alacak_tutar,
						other_amount_alacak : str_alacak_dovizli,
						other_currency_alacak :str_other_currency_alacak,
						fis_detay : '#Date_Detail# ENDİREKT MALİYET',
						fis_satir_detay : '#Date_Detail# ENDİREKT MALİYET',
						is_account_group : 1,
						dept_round_account :str_fark_gider,
						claim_round_account : str_fark_gelir,
						max_round_amount :str_max_round,
						round_row_detail:str_round_detail
					);
				</cfscript>
                <!--- endirekt maliyete ait ait satirlar tabloya kaydedilir : type:3 --->
                <cfif get_order_result_prods.recordcount>
					<cfoutput query="get_order_result_prods">
                    	<cfquery name="get_acc_codes_" datasource="#dsn3#">
                        	SELECT HALF_PRODUCTION_COST,PROD_GENERAL_CODE,PRODUCTION_COST FROM PRODUCT_PERIOD WHERE PRODUCT_ID = #get_order_result_prods.PRODUCT_ID# AND PERIOD_ID = #session.ep.period_id#
                        </cfquery>
                        <cfquery name="add_order_result_prods_2" datasource="#dsn3#">
                            INSERT INTO
                                #dsn2_alias#.PRODUCTION_COST_ROWS
                                (
                                    PRODUCT_ID,
                                    PRODUCT_NAME,
                                    DEBT_ACCOUNT_CODE,
                                    CLAIM_ACCOUNT_CODE,
                                    CLAIM_ACCOUNT_CODE_LABOR,
                                    AMOUNT,
                                    TYPE,
                                    START_DATE,
                                    FINISH_DATE
                          		)
                                VALUES
                                (
                                 	#get_order_result_prods.PRODUCT_ID#,
                                    '#get_order_result_prods.PRODUCT_NAME#',
                                    '#get_acc_codes_.HALF_PRODUCTION_COST#',
                                    '#get_acc_codes_.PROD_GENERAL_CODE#',
                                    NULL,
                                    #get_order_result_prods.STATION_REFLECTION_COST_SYSTEM#,
                                    3,
                                    <cfif isDefined("attributes.startdate") and isdate(attributes.startdate)>#attributes.startdate#<cfelse>NULL</cfif>,
                                    <cfif isDefined("attributes.finishdate") and isdate(attributes.finishdate)>#attributes.finishdate#<cfelse>NULL</cfif>
                              	)
                        </cfquery>
                    </cfoutput>
                </cfif>
				<!--- Ürün maliyet muhasebe kaydı oluşturulacak. Ürünün üretim/yarı mamul hesabına alacak, mamul hesabına borç yazacak. --->
				<cfscript>
					str_borclu_hesaplar = '' ;
					str_alacakli_hesaplar = '' ;
					str_borc_tutar = '' ;
					str_alacak_tutar = '' ;
					str_alacak_dovizli = '' ;
					str_borc_dovizli = '' ;
					str_other_currency_borc = '' ;
					str_other_currency_alacak = '';
					temp_cost_price_system_exit = 0;
					temp_cost_price_exit = 0;
					//üretilen ürün
					for(i=1;i lte get_order_result_prods.recordcount; i=i+1) 
					{	
						account_codes =  cfquery(datasource:'#dsn3#',sqlstring:'SELECT HALF_PRODUCTION_COST,PRODUCTION_COST,PRODUCTION_COST FROM PRODUCT_PERIOD WHERE PRODUCT_ID = #get_order_result_prods.PRODUCT_ID[i]# AND PERIOD_ID = #session.ep.period_id#');
						
						if(ListFind(str_borclu_hesaplar,account_codes.PRODUCTION_COST,",") eq 0) {
							str_borclu_hesaplar = ListAppend(str_borclu_hesaplar, account_codes.PRODUCTION_COST, ",");	
							str_borc_tutar = ListAppend(str_borc_tutar, wrk_round(get_order_result_prods.PURCHASE_EXTRA_COST_SYSTEM[i]+get_order_result_prods.PURCHASE_NET_SYSTEM[i]+get_order_result_prods.STATION_REFLECTION_COST_SYSTEM[i]+get_order_result_prods.LABOR_COST_SYSTEM[i]),",");
							str_borc_dovizli = ListAppend(str_borc_dovizli, wrk_round(get_order_result_prods.PURCHASE_EXTRA_COST_SYSTEM[i]+get_order_result_prods.PURCHASE_NET_SYSTEM[i]+get_order_result_prods.STATION_REFLECTION_COST_SYSTEM[i]+get_order_result_prods.LABOR_COST_SYSTEM[i]),",");
							str_other_currency_borc = ListAppend(str_other_currency_borc,session.ep.money,",");
						} else {
							str_borc_tutar = ListSetAt(str_borc_tutar,ListFind(str_borclu_hesaplar,account_codes.PRODUCTION_COST,","), ListGetAt(str_borc_tutar,ListFind(str_borclu_hesaplar,account_codes.PRODUCTION_COST,",")) + wrk_round(get_order_result_prods.PURCHASE_EXTRA_COST_SYSTEM[i]+get_order_result_prods.PURCHASE_NET_SYSTEM[i]+get_order_result_prods.STATION_REFLECTION_COST_SYSTEM[i]+get_order_result_prods.LABOR_COST_SYSTEM[i]));
							str_borc_dovizli = ListSetAt(str_borc_dovizli,ListFind(str_borclu_hesaplar,account_codes.PRODUCTION_COST,","), ListGetAt(str_borc_dovizli,ListFind(str_borclu_hesaplar,account_codes.PRODUCTION_COST,",")) + wrk_round(get_order_result_prods.PURCHASE_EXTRA_COST_SYSTEM[i]+get_order_result_prods.PURCHASE_NET_SYSTEM[i]+get_order_result_prods.STATION_REFLECTION_COST_SYSTEM[i]+get_order_result_prods.LABOR_COST_SYSTEM[i]));
						}

						if(ListFind(str_alacakli_hesaplar,account_codes.HALF_PRODUCTION_COST,",") eq 0) {
							str_alacakli_hesaplar = ListAppend(str_alacakli_hesaplar, account_codes.HALF_PRODUCTION_COST, ",");	
							str_alacak_tutar = ListAppend(str_alacak_tutar, wrk_round(get_order_result_prods.PURCHASE_EXTRA_COST_SYSTEM[i]+get_order_result_prods.PURCHASE_NET_SYSTEM[i]+get_order_result_prods.STATION_REFLECTION_COST_SYSTEM[i]+get_order_result_prods.LABOR_COST_SYSTEM[i]),",");	
							str_alacak_dovizli = ListAppend(str_alacak_dovizli, wrk_round(get_order_result_prods.PURCHASE_EXTRA_COST_SYSTEM[i]+get_order_result_prods.PURCHASE_NET_SYSTEM[i]+get_order_result_prods.STATION_REFLECTION_COST_SYSTEM[i]+get_order_result_prods.LABOR_COST_SYSTEM[i]),",");
							str_other_currency_alacak = ListAppend(str_other_currency_alacak,session.ep.money,",");
						} else {
							str_alacak_tutar = ListSetAt(str_alacak_tutar,ListFind(str_alacakli_hesaplar,account_codes.HALF_PRODUCTION_COST,","), ListGetAt(str_alacak_tutar,ListFind(str_alacakli_hesaplar,account_codes.HALF_PRODUCTION_COST,",")) + wrk_round(get_order_result_prods.PURCHASE_EXTRA_COST_SYSTEM[i]+get_order_result_prods.PURCHASE_NET_SYSTEM[i]+get_order_result_prods.STATION_REFLECTION_COST_SYSTEM[i]+get_order_result_prods.LABOR_COST_SYSTEM[i]));
							str_alacak_dovizli = ListSetAt(str_alacak_dovizli,ListFind(str_alacakli_hesaplar,account_codes.HALF_PRODUCTION_COST,","), ListGetAt(str_alacak_dovizli,ListFind(str_alacakli_hesaplar,account_codes.HALF_PRODUCTION_COST,",")) + wrk_round(get_order_result_prods.PURCHASE_EXTRA_COST_SYSTEM[i]+get_order_result_prods.PURCHASE_NET_SYSTEM[i]+get_order_result_prods.STATION_REFLECTION_COST_SYSTEM[i]+get_order_result_prods.LABOR_COST_SYSTEM[i]));
						}
						
						if(not len(account_codes.PRODUCTION_COST))
							muhasebe_uyari = "#muhasebe_uyari#;#get_order_result_prods.PRODUCT_NAME[i]# Ürünü İçin Mamül Hesabı Eksik.";
						if(not len(account_codes.HALF_PRODUCTION_COST))
							muhasebe_uyari = "#muhasebe_uyari#;#get_order_result_prods.PRODUCT_NAME[i]# Ürünü İçin Yarı Mamül Hesabı Eksik.";
					}
					GET_NO_ = cfquery(datasource:"#dsn3#", sqlstring:"SELECT * FROM #dsn3_alias#.SETUP_INVOICE_PURCHASE");
					str_fark_gelir =GET_NO_.FARK_GELIR;
					str_fark_gider =GET_NO_.FARK_GIDER;
					str_max_round = 0.9;
					str_round_detail = '#Date_Detail# ÜRÜN MALİYET';
					if(len(muhasebe_uyari))
					{
						for(kk=1;kk<=listlen(muhasebe_uyari,';');kk=kk+1)
						{
							writeoutput("#listgetat(muhasebe_uyari,kk,';')#<br />");
							abort("#getLang(dictionary_id:34154)#!"); //<cf_get_lang dictionary_id='34154.Yukarıdaki Ürünler İçin Düzenleme Yapmalısınız'>
						}
					}
					muhasebeci
					(
						action_id : 0,
						workcube_process_type : 171,
						workcube_process_cat : 0,
						muhasebe_db : '#dsn3#',
						account_card_type : 13,
						islem_tarihi : attributes.finishdate,
						borc_hesaplar : str_borclu_hesaplar,
						borc_tutarlar : str_borc_tutar,
						other_amount_borc : str_borc_dovizli,
						other_currency_borc : str_other_currency_borc,
						alacak_hesaplar : str_alacakli_hesaplar,
						alacak_tutarlar : str_alacak_tutar,
						other_amount_alacak : str_alacak_dovizli,
						other_currency_alacak :str_other_currency_alacak,
						fis_detay : '#Date_Detail# ÜRÜN MALİYET',
						fis_satir_detay : '#Date_Detail# ÜRÜN MALİYET',
						is_account_group : 1,
						dept_round_account :str_fark_gider,
						claim_round_account : str_fark_gelir,
						max_round_amount :str_max_round,
						round_row_detail:str_round_detail
					);
				</cfscript>
                <!--- urun maliyete ait satirlar tabloya kaydedilir : type:4 --->
                <cfif get_order_result_prods.recordcount>
					<cfoutput query="get_order_result_prods">
                    	<cfquery name="get_acc_codes_" datasource="#dsn3#">
                        	SELECT HALF_PRODUCTION_COST,PRODUCTION_COST,PRODUCTION_COST FROM PRODUCT_PERIOD WHERE PRODUCT_ID = #get_order_result_prods.PRODUCT_ID# AND PERIOD_ID = #session.ep.period_id#
                        </cfquery>
                        <cfquery name="add_order_result_prods_3" datasource="#dsn3#">
                            INSERT INTO
                                #dsn2_alias#.PRODUCTION_COST_ROWS
                                (
                                    PRODUCT_ID,
                                    PRODUCT_NAME,
                                    DEBT_ACCOUNT_CODE,
                                    CLAIM_ACCOUNT_CODE,
                                    CLAIM_ACCOUNT_CODE_LABOR,
                                    AMOUNT,
                                    TYPE,
                                    START_DATE,
                                    FINISH_DATE
                          		)
                                VALUES
                                (
                                 	#get_order_result_prods.PRODUCT_ID#,
                                    '#get_order_result_prods.PRODUCT_NAME#',
                                    '#get_acc_codes_.PRODUCTION_COST#',
                                    '#get_acc_codes_.HALF_PRODUCTION_COST#',
                                    NULL,
                                    #get_order_result_prods.PURCHASE_EXTRA_COST_SYSTEM+get_order_result_prods.PURCHASE_NET_SYSTEM+get_order_result_prods.STATION_REFLECTION_COST_SYSTEM+get_order_result_prods.LABOR_COST_SYSTEM#,
                                    4,
                                    <cfif isDefined("attributes.startdate") and isdate(attributes.startdate)>#attributes.startdate#<cfelse>NULL</cfif>,
                                    <cfif isDefined("attributes.finishdate") and isdate(attributes.finishdate)>#attributes.finishdate#<cfelse>NULL</cfif>
                              	)
                        </cfquery>
                    </cfoutput>
                </cfif>	
				<!--- Bir de fire fişi oluşması gerekiyor. Oluşan fire fişinde fire ürünlerin maliyetini
					710  (Direkt İlk Madde Malz. Hesabı)          BORÇ
					152 (Fire Hesabı)                                                     ALACAK
				 --->
				<cfif get_fire.recordcount>
					<cfscript>
						str_borclu_hesaplar = '' ;
						str_alacakli_hesaplar = '' ;
						str_borc_tutar = '' ;
						str_alacak_tutar = '' ;
						str_alacak_dovizli = '' ;
						str_borc_dovizli = '' ;
						str_other_currency_borc = '' ;
						str_other_currency_alacak = '';
						temp_cost_price_system_exit = 0;
						temp_cost_price_exit = 0;
						//fire ürün
						for(i=1;i lte get_fire.recordcount; i=i+1) 
						{	
							temp_cost_price_system_exit=get_fire.PURCHASE_NET_SYSTEM[i];
							temp_cost_price_system_exit=temp_cost_price_system_exit+get_fire.PURCHASE_EXTRA_COST_SYSTEM[i];
							temp_cost_price_exit=get_fire.PURCHASE_NET_SYSTEM[i];
							temp_cost_price_exit = temp_cost_price_exit + get_fire.PURCHASE_EXTRA_COST_SYSTEM[i];							
							
							sarf_account_codes =  cfquery(datasource:'#dsn3#',sqlstring:'SELECT DIMM_CODE, ACCOUNT_LOSS FROM PRODUCT_PERIOD WHERE PRODUCT_ID = #get_fire.PRODUCT_ID[i]# AND PERIOD_ID = #session.ep.period_id#');
							
							if(ListFind(str_borclu_hesaplar,sarf_account_codes.DIMM_CODE,",") eq 0) {
								str_borclu_hesaplar = ListAppend(str_borclu_hesaplar, sarf_account_codes.DIMM_CODE, ",");	
								str_borc_tutar = ListAppend(str_borc_tutar, wrk_round(temp_cost_price_system_exit),",");	
								str_borc_dovizli = ListAppend(str_borc_dovizli, wrk_round(temp_cost_price_exit),",");
								str_other_currency_borc = ListAppend(str_other_currency_borc,session.ep.money,",");
							} else {
								str_borc_tutar = ListSetAt(str_borc_tutar,ListFind(str_borclu_hesaplar,sarf_account_codes.DIMM_CODE,","), ListGetAt(str_borc_tutar,ListFind(str_borclu_hesaplar,sarf_account_codes.DIMM_CODE,",")) + wrk_round(temp_cost_price_system_exit));
								str_borc_dovizli = ListSetAt(str_borc_dovizli,ListFind(str_borclu_hesaplar,sarf_account_codes.DIMM_CODE,","), ListGetAt(str_borc_dovizli,ListFind(str_borclu_hesaplar,sarf_account_codes.DIMM_CODE,",")) + wrk_round(temp_cost_price_exit));
							}
	
							if(ListFind(str_alacakli_hesaplar,sarf_account_codes.ACCOUNT_LOSS,",") eq 0) {
								str_alacakli_hesaplar = ListAppend(str_alacakli_hesaplar, sarf_account_codes.ACCOUNT_LOSS, ",");	
								str_alacak_tutar = ListAppend(str_alacak_tutar, wrk_round(temp_cost_price_system_exit),",");	
								str_alacak_dovizli = ListAppend(str_alacak_dovizli, wrk_round(temp_cost_price_exit),",");
								str_other_currency_alacak = ListAppend(str_other_currency_alacak,session.ep.money,",");
							} else {
								str_alacak_tutar = ListSetAt(str_alacak_tutar,ListFind(str_alacakli_hesaplar,sarf_account_codes.ACCOUNT_LOSS,","), ListGetAt(str_alacak_tutar,ListFind(str_alacakli_hesaplar,sarf_account_codes.ACCOUNT_LOSS,",")) + wrk_round(temp_cost_price_system_exit));
								str_alacak_dovizli = ListSetAt(str_alacak_dovizli,ListFind(str_alacakli_hesaplar,sarf_account_codes.ACCOUNT_LOSS,","), ListGetAt(str_alacak_dovizli,ListFind(str_alacakli_hesaplar,sarf_account_codes.ACCOUNT_LOSS,",")) + wrk_round(temp_cost_price_exit));
							}
							
							if(not len(sarf_account_codes.DIMM_CODE))
								muhasebe_uyari = "#muhasebe_uyari#;#get_fire.PRODUCT_NAME[i]# #getLang(dictionary_id:34151)#."; //<cf_get_lang dictionary_id='34151.Ürünü İçin İlk Madde Malzeme Hesabı Eksik'>
							if(not len(sarf_account_codes.ACCOUNT_LOSS))
								muhasebe_uyari = "#muhasebe_uyari#;#get_fire.PRODUCT_NAME[i]# #getLang(dictionary_id:34150)#."; //<cf_get_lang dictionary_id='34150.Ürünü İçin Fire Hesabı Eksik'>
						}
						GET_NO_ = cfquery(datasource:"#dsn3#", sqlstring:"SELECT * FROM #dsn3_alias#.SETUP_INVOICE_PURCHASE");
						str_fark_gelir =GET_NO_.FARK_GELIR;
						str_fark_gider =GET_NO_.FARK_GIDER;
						str_max_round = 0.9;
						str_round_detail = '#Date_Detail# FİRE FİŞİ';
						if(len(muhasebe_uyari))
						{
							for(kk=1;kk<=listlen(muhasebe_uyari,';');kk=kk+1)
							{
								writeoutput("#listgetat(muhasebe_uyari,kk,';')#<br />");
								abort("#getLang(dictionary_id:34154)#!"); //<cf_get_lang dictionary_id='34154.Yukarıdaki Ürünler İçin Düzenleme Yapmalısınız'>
							}
						}
						muhasebeci
						(
							action_id : 0,
							workcube_process_type : 171,
							workcube_process_cat : 0,
							muhasebe_db : '#dsn3#',
							account_card_type : 13,
							islem_tarihi : attributes.finishdate,
							borc_hesaplar : str_borclu_hesaplar,
							borc_tutarlar : str_borc_tutar,
							other_amount_borc : str_borc_dovizli,
							other_currency_borc : str_other_currency_borc,
							alacak_hesaplar : str_alacakli_hesaplar,
							alacak_tutarlar : str_alacak_tutar,
							other_amount_alacak : str_alacak_dovizli,
							other_currency_alacak :str_other_currency_alacak,
							fis_detay : '#Date_Detail# FİRE FİŞİ',
							fis_satir_detay : '#Date_Detail# FİRE FİŞİ',
							is_account_group : 1,
							dept_round_account :str_fark_gider,
							claim_round_account : str_fark_gelir,
							max_round_amount :str_max_round,
							round_row_detail:str_round_detail
						);
					</cfscript>
                    <!--- fire fisine ait satirlar tabloya kaydedilir : type:5 --->
					<cfoutput query="get_fire">
                    	<cfquery name="get_acc_codes_" datasource="#dsn3#">
                        	SELECT DIMM_CODE, ACCOUNT_LOSS FROM PRODUCT_PERIOD WHERE PRODUCT_ID = #get_fire.PRODUCT_ID# AND PERIOD_ID = #session.ep.period_id#
                        </cfquery>
                        <cfquery name="add_order_result_prods_4" datasource="#dsn3#">
                            INSERT INTO
                                #dsn2_alias#.PRODUCTION_COST_ROWS
                                (
                                    PRODUCT_ID,
                                    PRODUCT_NAME,
                                    DEBT_ACCOUNT_CODE,
                                    CLAIM_ACCOUNT_CODE,
                                    CLAIM_ACCOUNT_CODE_LABOR,
                                    AMOUNT,
                                    TYPE,
                                    START_DATE,
                                    FINISH_DATE
                                )
                                VALUES
                                (
                                    #get_fire.PRODUCT_ID#,
                                    '#get_fire.PRODUCT_NAME#',
                                    '#get_acc_codes_.DIMM_CODE#',
                                    '#get_acc_codes_.ACCOUNT_LOSS#',
                                    NULL,
                                    #get_fire.PURCHASE_EXTRA_COST_SYSTEM+get_fire.PURCHASE_NET_SYSTEM#,
                                    5,
                                    <cfif isDefined("attributes.startdate") and isdate(attributes.startdate)>#attributes.startdate#<cfelse>NULL</cfif>,
                                    <cfif isDefined("attributes.finishdate") and isdate(attributes.finishdate)>#attributes.finishdate#<cfelse>NULL</cfif>
                                )
                        </cfquery>
                    </cfoutput>
				</cfif>
			</cftransaction>
        </cflock>
		<cfquery name="get_cards" datasource="#dsn2#">
			SELECT BILL_NO,ACTION_DATE FROM ACCOUNT_CARD WHERE ACTION_ID = 0 AND ACTION_TYPE = 171 AND RECORD_EMP = #session.ep.userid# AND ACTION_DATE = #attributes.finishdate#
		</cfquery>
		<cfset warning_txt = ''>
		<cfoutput query="get_cards">
			<cfif len(warning_txt)>
				<cfset warning_txt = '#warning_txt#,#get_cards.bill_no#'>
			<cfelse>
				<cfset warning_txt = '#get_cards.bill_no#'>
			</cfif>
		</cfoutput>
		<cfoutput>
			<script>
				alertObject({type: 'success', message: '<cf_get_lang dictionary_id="34152.Seçilen Tarih Aralığındaki Üretim Sonuçlarının Muhasebe Fişleri Oluşturuldu">! <cf_get_lang dictionary_id="47490.Fiş Numaraları"> :  #warning_txt#',closeTime:999999});
			</script>	
		</cfoutput>
	<cfelse>
		<script>
			alertObject({message: "<cf_get_lang dictionary_id='34153.Seçilen Tarih Aralığındaki Üretim Sonucu Bulunamadı!'>",closeTime:999999});
		</script>	
	</cfif>
</cfif>
<cfset pageHead = "#getLang('account',286)#">
<cf_catalystHeader>
<div id="message_box"></div>
<style>
	#message_box div.alert{ margin-top:45px;}
</style>
<cfform name="report_special" action="" method="post">
	<input name="is_form_submitted" id="is_form_submitted" type="hidden" value="1">	
	<div class="row"> 
		<div class="col col-12 uniqueRow">
			<div class="row formContent">
				<div class="row" type="row">
					<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
						<div class="form-group" id="item-startdate">
							<label class="col col-3 col-xs-12"><cfoutput>#getLang('main',641)#</cfoutput></label>
							<div class="col col-9 col-xs-12"> 
								<div class="input-group">
									<cfsavecontent variable="message1"><cf_get_lang_main no='370.Tarih Değerlerini Kontrol Ediniz'> !</cfsavecontent>
									<cfinput type="text" name="startdate" validate="#validate_style#" message="#message1#" value="#dateformat(attributes.startdate,dateformat_style)#" required="yes" style="width:65px;">
									<span class="input-group-addon"><cf_wrk_date_image date_field="startdate"></span>
								</div>
							</div>
						</div>
						<div class="form-group" id="item-finishdate">
							<label class="col col-3 col-xs-12"><cfoutput>#getLang('main',288)#</cfoutput></label>
							<div class="col col-9 col-xs-12"> 
								<div class="input-group">
									<cfinput type="text" name="finishdate" validate="#validate_style#" message="#message1#" value="#dateformat(attributes.finishdate,dateformat_style)#" required="yes" style="width:65px;">
									<span class="input-group-addon"><cf_wrk_date_image date_field="finishdate"></span>
								</div>
							</div>
						</div>
					</div>
				</div>	
				<div class="row formContentFooter">
					<div class="col col-12 text-right">
						<cf_wrk_search_button button_type="2" button_name="#getLang('main',499)#">
					</div> 
				</div>
			</div>
		</div>
	</div>
</cfform>
<script>
/*
	alertObject({
		container: 'message_box', //  eklendiği content
		type: 'warning',  // warning,danger,succes
		message: 'Mesajınız',  //  mesaj
		closeTime: 30000, // otomatik süresi
	});
*/
</script>​