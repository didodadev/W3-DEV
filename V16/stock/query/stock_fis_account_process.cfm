<!--- depo fişleri için, muhasebe tutar ve hesapları bu sayfada set ediliyor ozden20060424 --->
<cfif not isdefined("new_comp_id")><cfset new_comp_id = session.ep.company_id></cfif>
<cfif not isdefined("new_dsn3_group")><cfset new_dsn3_group = dsn3></cfif>
<cfif not isdefined("new_dsn2_group")><cfset new_dsn2_group = dsn2></cfif>
<cfif not isdefined("new_dsn3_group_alias")><cfset new_dsn3_group_alias = dsn3_alias></cfif>
<cfif not isdefined("new_dsn2_group_alias")><cfset new_dsn2_group_alias = dsn2_alias></cfif>
<cfif not isdefined("new_period_id")><cfset new_period_id = session.ep.period_id></cfif>
<cfscript>
	str_borclu_hesaplar = '' ;
	str_alacakli_hesaplar = '' ;
	borc_alacak_tutar = '' ;
	str_dovizli_tutarlar = '' ;
	str_doviz_currency = '';
	is_project_acc = 0;
	acc_project_list_alacak='';
	acc_project_list_borc='';
	currency_multiplier = '';//basketin secili olan kurun degeri muh islemlerinde kullaniliyor
	is_project_based_acc = get_process_type.is_project_based_acc;
	if(isDefined('attributes.project_id'))attributes.project_id = attributes.project_id;
	if(isDefined('attributes.kur_say') and len(attributes.kur_say))
		for(mon=1;mon lte attributes.kur_say;mon=mon+1)
			if(evaluate("attributes.hidden_rd_money_#mon#") is session.ep.money2)
				currency_multiplier = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');
	if(is_project_based_acc eq 1 and session.ep.our_company_info.project_followup eq 1 and isdefined("attributes.project_id") and len(attributes.project_id) and len(attributes.project_head))	// proje bazlı muhasebe islemi yapılacaksa
	{
		main_product_account_codes=cfquery(datasource:"#new_dsn2_group#",sqlstring:"SELECT ACCOUNT_EXPENDITURE,ACCOUNT_LOSS,MATERIAL_CODE,PRODUCTION_COST,ACCOUNT_CODE_PUR,'' SCRAP_CODE,OVER_COUNT FROM #dsn3_alias#.PROJECT_PERIOD WHERE PROJECT_ID = #attributes.project_id# AND PERIOD_ID = #session.ep.period_id# ");
	}
	if(is_project_based_acc eq 1 and session.ep.our_company_info.project_followup eq 1 and isdefined("attributes.project_id_in") and len(attributes.project_id_in) and len(attributes.project_head_in))	// proje bazlı muhasebe islemi yapılacaksa
	{
		main_product_account_codes_in=cfquery(datasource:"#new_dsn2_group#",sqlstring:"SELECT ACCOUNT_EXPENDITURE,ACCOUNT_LOSS,MATERIAL_CODE,PRODUCTION_COST,ACCOUNT_CODE_PUR,'' SCRAP_CODE,OVER_COUNT FROM #dsn3_alias#.PROJECT_PERIOD WHERE PROJECT_ID = #attributes.project_id_in# AND PERIOD_ID = #session.ep.period_id# ");
	}

	for(i=1;i lte attributes.rows_;i=i+1)
	{
		if(isdefined('location_type_in') and len(location_type_in)) //giris depo lokasyonu tipi kontrol ediliyor
		{
			if(is_dept_based_acc eq 1)
			{
				
					dept_id = attributes.department_in;
					loc_id = attributes.location_in;
					
					product_account_codes = get_product_account(prod_id:evaluate("attributes.product_id#i#"),period_id:new_period_id,product_account_db:dsn2,product_alias_db:new_dsn3_group_alias,department_id:dept_id,location_id:loc_id);
					if(is_scrap_in eq 1)
						str_borclu_hesaplar = ListAppend(str_borclu_hesaplar, product_account_codes.SCRAP_CODE, ",");
					else if(location_type_in eq 1) //giriş depo hammadde lokasyon 
						str_borclu_hesaplar = ListAppend(str_borclu_hesaplar, product_account_codes.MATERIAL_CODE, ",");		
					else if(location_type_in eq 3) //giriş depo mamul lokasyon 
						str_borclu_hesaplar = ListAppend(str_borclu_hesaplar, product_account_codes.PRODUCTION_COST, ",");		
					else //giriş mal depo 
						str_borclu_hesaplar = ListAppend(str_borclu_hesaplar, product_account_codes.ACCOUNT_CODE_PUR, ",");	
				
			}
			else
			{
				dept_id = 0;
				loc_id = 0;
				
				if(is_project_based_acc eq 1 and session.ep.our_company_info.project_followup eq 1 and isdefined("attributes.row_project_id#i#") and len(evaluate("attributes.row_project_id#i#")) and len(evaluate("attributes.row_project_name#i#")))// proje bazlı muhasebe islemi yapılacaksa ve satırda proje seçili ise
				{//proje bazlı muhasebe yapılıyorsa ve satırda proje varsa
					product_account_codes=cfquery(datasource:"#new_dsn2_group#",sqlstring:"SELECT ACCOUNT_EXPENDITURE,ACCOUNT_LOSS,MATERIAL_CODE,PRODUCTION_COST,ACCOUNT_CODE_PUR,'' SCRAP_CODE,OVER_COUNT FROM #dsn3_alias#.PROJECT_PERIOD WHERE PROJECT_ID = #evaluate("attributes.row_project_id#i#")# AND PERIOD_ID = #session.ep.period_id# ");
					is_project_acc=1;
				}
				else if(is_project_based_acc eq 1 and session.ep.our_company_info.project_followup eq 1 and isdefined("attributes.project_id") and len(attributes.project_id) and len(attributes.project_head))	// proje bazlı muhasebe islemi yapılacaksa
				{//proje bazlı muhasebe yapılıyorsa ve belgede proje varsa
					product_account_codes=main_product_account_codes;
					is_project_acc=1;
				}
				else
					product_account_codes = get_product_account(prod_id:evaluate("attributes.product_id#i#"),period_id:new_period_id,product_account_db:dsn2,product_alias_db:new_dsn3_group_alias,department_id:dept_id,location_id:loc_id);
				
				if(attributes.fis_type eq 111) //sarf fisi 
					str_borclu_hesaplar = ListAppend(str_borclu_hesaplar, product_account_codes.ACCOUNT_EXPENDITURE, ",");
				else if (attributes.fis_type eq 112) //fire fisi 
					str_borclu_hesaplar = ListAppend(str_borclu_hesaplar, product_account_codes.ACCOUNT_LOSS, ",");
				else if(attributes.fis_type eq 113) //ambar fisi bu kısımda giri depo da borçlu hesap belirleme
					{
						if(is_project_acc eq 1 and isdefined("main_product_account_codes_in"))
						{
							if(location_type_in eq 1) //cikis depo hammadde lokasyon 
								str_borclu_hesaplar = ListAppend(str_borclu_hesaplar, main_product_account_codes_in.MATERIAL_CODE, ",");		
							else if(location_type_in eq 3) //cikis depo mamul lokasyon 
								str_borclu_hesaplar = ListAppend(str_borclu_hesaplar, main_product_account_codes_in.PRODUCTION_COST, ",");		
							else //cikis mal lokasyon 
								str_borclu_hesaplar = ListAppend(str_borclu_hesaplar, main_product_account_codes_in.ACCOUNT_CODE_PUR, ",");		
						}
						else
						{
							if(is_scrap_in eq 1)
								str_borclu_hesaplar = ListAppend(str_borclu_hesaplar, product_account_codes.SCRAP_CODE, ",");
							else if(location_type_in eq 1) //cikis depo hammadde lokasyon 
								str_borclu_hesaplar = ListAppend(str_borclu_hesaplar, product_account_codes.MATERIAL_CODE, ",");		
							else if(location_type_in eq 3) //cikis depo mamul lokasyon 
								str_borclu_hesaplar = ListAppend(str_borclu_hesaplar, product_account_codes.PRODUCTION_COST, ",");		
							else //cikis mal lokasyon 
								str_borclu_hesaplar = ListAppend(str_borclu_hesaplar, product_account_codes.ACCOUNT_CODE_PUR, ",");		
						}	
					}
				else if(attributes.fis_type eq 115) //sayım fişi ise sayım fazlası hesabına alacak yazacak (muhasebeciye atarken borca alacak alacaga borc yaziyor, ters kayit atiyor)
					str_borclu_hesaplar = ListAppend(str_borclu_hesaplar, product_account_codes.OVER_COUNT, ",");
			}
		}
		if(isdefined('location_type_out') and len(location_type_out)) //çıkış depo lokasyonu tipi kontrol ediliyor
		{
			if(is_dept_based_acc eq 1)
			{
				
					dept_id = attributes.department_out;
					loc_id = attributes.location_out;
					
					product_account_codes = get_product_account(prod_id:evaluate("attributes.product_id#i#"),period_id:new_period_id,product_account_db:dsn2,product_alias_db:new_dsn3_group_alias,department_id:dept_id,location_id:loc_id);
					if(is_scrap_out eq 1)
						str_borclu_hesaplar = ListAppend(str_borclu_hesaplar, product_account_codes.SCRAP_CODE, ",");
					else if(location_type_out eq 1) //çıkış depo hammadde lokasyon 
						str_borclu_hesaplar = ListAppend(str_borclu_hesaplar, product_account_codes.MATERIAL_CODE, ",");		
					else if(location_type_out eq 3) //çıkış depo mamul lokasyon 
						str_borclu_hesaplar = ListAppend(str_borclu_hesaplar, product_account_codes.PRODUCTION_COST, ",");		
					else //giriş mal depo 
						str_borclu_hesaplar = ListAppend(str_borclu_hesaplar, product_account_codes.ACCOUNT_CODE_PUR, ",");	
				
			}
			else
			{
				dept_id = 0;
				loc_id = 0;
				if(is_project_based_acc eq 1 and session.ep.our_company_info.project_followup eq 1 and isdefined("attributes.row_project_id#i#") and len(evaluate("attributes.row_project_id#i#")) and len(evaluate("attributes.row_project_name#i#")))//proje bazlı muhasebe islemi yapılacaksa ve satırda proje seçili ise
				{//proje bazlı muhasebe yapılıyorsa ve satırda proje varsa
					product_account_codes=cfquery(datasource:"#new_dsn2_group#",sqlstring:"SELECT ACCOUNT_EXPENDITURE,ACCOUNT_LOSS,MATERIAL_CODE,PRODUCTION_COST,ACCOUNT_CODE_PUR,'' SCRAP_CODE,OVER_COUNT FROM #dsn3_alias#.PROJECT_PERIOD WHERE PROJECT_ID = #evaluate("attributes.row_project_id#i#")# AND PERIOD_ID = #session.ep.period_id# ");
					is_project_acc=1;
				}
				else if(is_project_based_acc eq 1 and session.ep.our_company_info.project_followup eq 1 and isdefined("attributes.project_id") and len(attributes.project_id) and len(attributes.project_head))	// proje bazlı muhasebe islemi yapılacaksa
				{//proje bazlı muhasebe yapılıyorsa ve belgede proje varsa
					product_account_codes=main_product_account_codes;
					is_project_acc=1;
				}
				else
					product_account_codes = get_product_account(prod_id:evaluate("attributes.product_id#i#"),period_id:new_period_id,product_account_db:dsn2,product_alias_db:new_dsn3_group_alias,department_id:dept_id,location_id:loc_id);
					
					if(attributes.fis_type eq 111) //sarf fisi 
					str_borclu_hesaplar = ListAppend(str_borclu_hesaplar, product_account_codes.ACCOUNT_EXPENDITURE, ",");
				else if (attributes.fis_type eq 112) //fire fisi 
					str_borclu_hesaplar = ListAppend(str_borclu_hesaplar, product_account_codes.ACCOUNT_LOSS, ",");
				/* else if(attributes.fis_type eq 113) //ambar fisi giriş depo borçlu hesap atımı var tekrar burada atama yapınca borç-alacak eşitsizliği oluyor
				{
					if(is_project_acc eq 1 and isdefined("main_product_account_codes_in"))
					{
						if(location_type_in eq 1) //cikis depo hammadde lokasyon 
							str_borclu_hesaplar = ListAppend(str_borclu_hesaplar, main_product_account_codes_in.MATERIAL_CODE, ",");		
						else if(location_type_in eq 3) //cikis depo mamul lokasyon 
							str_borclu_hesaplar = ListAppend(str_borclu_hesaplar, main_product_account_codes_in.PRODUCTION_COST, ",");		
						else //cikis mal lokasyon 
							str_borclu_hesaplar = ListAppend(str_borclu_hesaplar, main_product_account_codes_in.ACCOUNT_CODE_PUR, ",");		
					}
					else
					{
						if(is_scrap_in eq 1)
							str_borclu_hesaplar = ListAppend(str_borclu_hesaplar, product_account_codes.SCRAP_CODE, ",");
						else if(location_type_in eq 1) //cikis depo hammadde lokasyon 
							str_borclu_hesaplar = ListAppend(str_borclu_hesaplar, product_account_codes.MATERIAL_CODE, ",");		
						else if(location_type_in eq 3) //cikis depo mamul lokasyon 
							str_borclu_hesaplar = ListAppend(str_borclu_hesaplar, product_account_codes.PRODUCTION_COST, ",");		
						else //cikis mal lokasyon 
							str_borclu_hesaplar = ListAppend(str_borclu_hesaplar, product_account_codes.ACCOUNT_CODE_PUR, ",");		
					}	
				} */
				else if(attributes.fis_type eq 115) //sayım fişi ise sayım fazlası hesabına alacak yazacak (muhasebeciye atarken borca alacak alacaga borc yaziyor, ters kayit atiyor)
					str_borclu_hesaplar = ListAppend(str_borclu_hesaplar, product_account_codes.OVER_COUNT, ",");
			}
			if(is_project_acc eq 1 and isdefined("main_product_account_codes"))
			{
				if(location_type_out eq 1) //cikis depo hammadde lokasyon 
					str_alacakli_hesaplar = ListAppend(str_alacakli_hesaplar, main_product_account_codes.MATERIAL_CODE, ",");		
				else if(location_type_out eq 3) //cikis depo mamul lokasyon 
					str_alacakli_hesaplar = ListAppend(str_alacakli_hesaplar, main_product_account_codes.PRODUCTION_COST, ",");		
				else //cikis depo mal lokasyon 
					str_alacakli_hesaplar = ListAppend(str_alacakli_hesaplar, main_product_account_codes.ACCOUNT_CODE_PUR, ",");		
			}
			else
			{
				if(is_scrap_out eq 1)
					str_alacakli_hesaplar = ListAppend(str_alacakli_hesaplar, product_account_codes.SCRAP_CODE, ",");
				else if(location_type_out eq 1) //cikis depo hammadde lokasyon 
					str_alacakli_hesaplar = ListAppend(str_alacakli_hesaplar, product_account_codes.MATERIAL_CODE, ",");		
				else if(location_type_out eq 3) //cikis depo mamul lokasyon 
					str_alacakli_hesaplar = ListAppend(str_alacakli_hesaplar, product_account_codes.PRODUCTION_COST, ",");		
				else //cikis depo mal lokasyon 
					str_alacakli_hesaplar = ListAppend(str_alacakli_hesaplar, product_account_codes.ACCOUNT_CODE_PUR, ",");	
					
			}		
		}
		else if(attributes.fis_type eq 115) 
		{ //sayım fişi ise lokasyon türüne göre giriş hesabına borç yazacak.(muhasebeciye atarken borca alacak alacaga borc yaziyor, ters kayit atiyor)
				if(is_scrap_in eq 1)
					str_alacakli_hesaplar = ListAppend(str_alacakli_hesaplar, product_account_codes.SCRAP_CODE, ",");
				else if(location_type_in eq 1) //cikis depo hammadde lokasyon 
					str_alacakli_hesaplar = ListAppend(str_alacakli_hesaplar, product_account_codes.MATERIAL_CODE, ",");		
				else if(location_type_in eq 3) //cikis depo mamul lokasyon 
					str_alacakli_hesaplar = ListAppend(str_alacakli_hesaplar, product_account_codes.PRODUCTION_COST, ",");		
				else //cikis depo mal lokasyon 
					str_alacakli_hesaplar = ListAppend(str_alacakli_hesaplar, product_account_codes.ACCOUNT_CODE_PUR, ",");	
		}
		else
		{
			dept_id = 0;
			loc_id = 0;	
		}
		
		if(attributes.fis_type eq 113)//ambar fişinde borç proje giriş proje olacak
		{
			if(isdefined("attributes.row_project_id#i#") and len(evaluate("attributes.row_project_id#i#")) and len(evaluate("attributes.row_project_name#i#")))
				acc_project_list_borc = ListAppend(acc_project_list_borc,evaluate("attributes.row_project_id#i#"),",");
			else if(isdefined("attributes.project_id_in") and len(attributes.project_id_in) and len(attributes.project_head_in))
				acc_project_list_borc = ListAppend(acc_project_list_borc,attributes.project_id_in,",");
			else
				acc_project_list_borc = ListAppend(acc_project_list_borc,0,",");
		}
		else
		{
			if(isdefined("attributes.row_project_id#i#") and len(evaluate("attributes.row_project_id#i#")) and len(evaluate("attributes.row_project_name#i#")))
				acc_project_list_borc = ListAppend(acc_project_list_borc,evaluate("attributes.row_project_id#i#"),",");
			else if(isdefined("attributes.project_id") and len(attributes.project_id) and len(attributes.project_head))
				acc_project_list_borc = ListAppend(acc_project_list_borc,attributes.project_id,",");
			else
				acc_project_list_borc = ListAppend(acc_project_list_borc,0,",");
		}	
		if(isdefined("attributes.row_project_id#i#") and len(evaluate("attributes.row_project_id#i#")) and len(evaluate("attributes.row_project_name#i#")))
			acc_project_list_alacak = ListAppend(acc_project_list_alacak,evaluate("attributes.row_project_id#i#"),",");
		else if(isdefined("attributes.project_id") and len(attributes.project_id) and len(attributes.project_head))
			acc_project_list_alacak = ListAppend(acc_project_list_alacak,attributes.project_id,",");
		else
			acc_project_list_alacak = ListAppend(acc_project_list_alacak,0,",");
		if(isdefined("attributes.x_cost_acc") and attributes.x_cost_acc eq 1)
		{
			if(not len(evaluate("attributes.extra_cost#i#"))) "attributes.extra_cost#i#" = 0;
			if(not len(evaluate("attributes.net_maliyet#i#"))) "attributes.net_maliyet#i#" = 0;
			borc_alacak_tutar = ListAppend(borc_alacak_tutar, wrk_round(evaluate("attributes.amount#i#")*(evaluate("attributes.net_maliyet#i#")+evaluate("attributes.extra_cost#i#"))), ","); 
			str_dovizli_tutarlar = ListAppend(str_dovizli_tutarlar,wrk_round(evaluate("attributes.amount#i#")*(evaluate("attributes.net_maliyet#i#")+evaluate("attributes.extra_cost#i#"))),",");
			str_doviz_currency = ListAppend(str_doviz_currency,session.ep.money,",");
		}
		else
		{
			borc_alacak_tutar = ListAppend(borc_alacak_tutar, wrk_round(evaluate("attributes.row_nettotal#i#")), ","); 
			if(isdefined("attributes.other_money_#i#") and  isdefined("attributes.other_money_value_#i#") and len(evaluate("attributes.other_money_value_#i#")) )
			{
				str_dovizli_tutarlar = ListAppend(str_dovizli_tutarlar,wrk_round(evaluate("attributes.other_money_value_#i#")),",");
				str_doviz_currency = ListAppend(str_doviz_currency,evaluate("attributes.other_money_#i#"),",");
			}
		}
	}
</cfscript>
