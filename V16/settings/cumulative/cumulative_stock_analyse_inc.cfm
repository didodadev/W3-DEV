<cfif isdefined("acilis_miktar_#PRODUCT_GROUPBY_ID#") and len(evaluate("acilis_miktar_#PRODUCT_GROUPBY_ID#"))>
	<cfset donem_basi_stok = evaluate("acilis_miktar_#PRODUCT_GROUPBY_ID#")>
</cfif>
<cfset net_satis_miktar1=0>
<cfset db_maliyet_temp = 0>
<cfset db_maliyet2_temp = 0>
<cfif isdefined('attributes.display_cost')>
	<cfif donem_basi_stok neq 0>
		<cfif IS_PRODUCTION eq 1><!--- uretilen urunler icin donem basi specli maliyet toplamı getiriliyor --->
			<cfif isdefined("donem_basi_specli_maliyet_#PRODUCT_GROUPBY_ID#") and len(evaluate("donem_basi_specli_maliyet_#PRODUCT_GROUPBY_ID#") and evaluate("donem_basi_specli_maliyet_#PRODUCT_GROUPBY_ID#") neq 0)>
				<cfset db_maliyet_temp= TLFormat(evaluate("donem_basi_specli_maliyet_#PRODUCT_GROUPBY_ID#")/donem_basi_kur)>
			</cfif>
			<cfif isdefined('attributes.is_system_money_2') and isdefined("donem_basi_specli_maliyet2_#PRODUCT_GROUPBY_ID#") and len(evaluate("donem_basi_specli_maliyet2_#PRODUCT_GROUPBY_ID#") and evaluate("donem_basi_specli_maliyet_#PRODUCT_GROUPBY_ID#") neq 0)>
				<cfset db_maliyet2_temp= TLFormat(evaluate("donem_basi_specli_maliyet2_#PRODUCT_GROUPBY_ID#"))>
			</cfif>
		<cfelse>
			<cfif donem_basi_stok neq 0>
				<cfset start_period_cost_date = dateformat(start_date,dateformat_style)>
				<cfif start_period_cost_date is '01/01/#session.ep.period_year#'>
					<cfset start_period_cost_date=start_date>
				<cfelse>
					<cfset start_period_cost_date=date_add('d',-1,start_date)>
				</cfif>
				<cfset db_maliyet2 = produc_cost_func(cost_product_id:GET_ALL_STOCK.PRODUCT_ID,cost_date:start_period_cost_date)>
				<cfset donem_basi_maliyet=(donem_basi_stok*( db_maliyet2.PURCHASE_NET_SYSTEM + db_maliyet2.PURCHASE_EXTRA_COST_SYSTEM))>
				<cfif donem_basi_maliyet neq 0>
					<cfset db_maliyet_temp= TLFormat(donem_basi_maliyet/donem_basi_kur)>
				</cfif>
				<cfif isdefined('attributes.is_system_money_2')>
					<cfset donem_basi_other_cost=(donem_basi_stok*( db_maliyet2.PURCHASE_NET_SYSTEM_2 + db_maliyet2.PURCHASE_EXTRA_COST_SYSTEM_2))>
					<cfif donem_basi_other_cost neq 0>
						<cfset db_maliyet2_temp= TLFormat(donem_basi_other_cost)>
					</cfif>
				</cfif>
			</cfif>
		</cfif>
	</cfif>
</cfif>
<!--- alıs ve alıs iadeler bolumu --->
<cfif len(attributes.process_type) and listfind(attributes.process_type,2)>
	<cfset net_alis=0>
    <cfset net_alis2=0>
	<cfif isdefined("alis_miktar_#PRODUCT_GROUPBY_ID#") and len(evaluate("alis_miktar_#PRODUCT_GROUPBY_ID#"))>
        <cfset net_alis=(net_alis+wrk_round(evaluate("alis_miktar_#PRODUCT_GROUPBY_ID#"),4))>
    </cfif>
    <cfif isdefined("alis_iade_miktar_#PRODUCT_GROUPBY_ID#") and len(evaluate("alis_iade_miktar_#PRODUCT_GROUPBY_ID#"))>
        <cfset net_alis= (net_alis - wrk_round(evaluate("alis_iade_miktar_#PRODUCT_GROUPBY_ID#"),4))>
    </cfif>
	<cfif isdefined('attributes.display_cost')>
		<cfset alis_mal_1=0>
		<cfset alis_mal_2 = 0> <!--- sistem 2. para birimi net alış tutarını gösterir --->
		<cfif isdefined("alis_maliyet_#PRODUCT_GROUPBY_ID#") and len(evaluate("alis_maliyet_#PRODUCT_GROUPBY_ID#"))>
			<cfset alis_mal_1=alis_mal_1 + evaluate("alis_maliyet_#PRODUCT_GROUPBY_ID#")> 	
		</cfif>
		<cfif isdefined("alis_iade_maliyet_#PRODUCT_GROUPBY_ID#") and len(evaluate("alis_iade_maliyet_#PRODUCT_GROUPBY_ID#"))>
			<cfset alis_mal_1=alis_mal_1 - evaluate("alis_iade_maliyet_#PRODUCT_GROUPBY_ID#")>
		</cfif>
		<cfif isdefined('attributes.is_system_money_2')>
			<cfif isdefined("alis_maliyet2_#PRODUCT_GROUPBY_ID#") and len(evaluate("alis_maliyet2_#PRODUCT_GROUPBY_ID#"))>
				<cfset alis_mal_2=alis_mal_2 + evaluate("alis_maliyet2_#PRODUCT_GROUPBY_ID#")> 	
			</cfif>
			<cfif isdefined("alis_iade_maliyet2_#PRODUCT_GROUPBY_ID#") and len(evaluate("alis_iade_maliyet2_#PRODUCT_GROUPBY_ID#"))>
				<cfset alis_mal_2=alis_mal_2 - evaluate("alis_iade_maliyet2_#PRODUCT_GROUPBY_ID#")>
			</cfif>
		</cfif>
	</cfif>
</cfif>
<!--- satıs ve satıs iade bolumu --->
<cfif len(attributes.process_type) and listfind(attributes.process_type,3)>
	<cfset satis_mal_1=0>
     <cfif isdefined("satis_maliyet_#PRODUCT_GROUPBY_ID#") and len(evaluate("satis_maliyet_#PRODUCT_GROUPBY_ID#"))>
        <cfset satis_mal_1 = satis_mal_1 + evaluate("satis_maliyet_#PRODUCT_GROUPBY_ID#")>
    </cfif>
    <cfif isdefined("satis_iade_maliyet_#PRODUCT_GROUPBY_ID#") and len(evaluate("satis_iade_maliyet_#PRODUCT_GROUPBY_ID#"))>
        <cfset satis_mal_1=satis_mal_1 - evaluate("satis_iade_maliyet_#PRODUCT_GROUPBY_ID#")>
    </cfif>
	<cfif isdefined("satis_miktar_#PRODUCT_GROUPBY_ID#") and len(evaluate("satis_miktar_#PRODUCT_GROUPBY_ID#"))>
        <cfset net_satis_miktar1=net_satis_miktar1+wrk_round(evaluate("satis_miktar_#PRODUCT_GROUPBY_ID#"),4)>
    </cfif>
    <cfif isdefined("satis_iade_miktar_#PRODUCT_GROUPBY_ID#") and len(evaluate("satis_iade_miktar_#PRODUCT_GROUPBY_ID#"))>
        <cfset net_satis_miktar1=net_satis_miktar1-wrk_round(evaluate("satis_iade_miktar_#PRODUCT_GROUPBY_ID#"),4)>
    </cfif>
	<cfif isdefined('attributes.display_cost')>
        <cfset satis_net_tutar_2=0> 
        <cfif isdefined('attributes.is_system_money_2')>						
            <cfif isdefined("satis_maliyet2_#PRODUCT_GROUPBY_ID#") and len(evaluate("satis_maliyet2_#PRODUCT_GROUPBY_ID#"))>
                <cfset satis_net_tutar_2 = satis_net_tutar_2 + evaluate("satis_maliyet2_#PRODUCT_GROUPBY_ID#")>
            </cfif>
            <cfif isdefined("satis_iade_maliyet2_#PRODUCT_GROUPBY_ID#") and len(evaluate("satis_iade_maliyet2_#PRODUCT_GROUPBY_ID#"))>
                <cfset satis_net_tutar_2 = satis_net_tutar_2 - evaluate("satis_iade_maliyet2_#PRODUCT_GROUPBY_ID#")>
            </cfif>
        </cfif>
    </cfif>
</cfif>
<cfif isdefined("donem_sonu_#PRODUCT_GROUPBY_ID#") and len(evaluate("donem_sonu_#PRODUCT_GROUPBY_ID#"))>
	<cfset donem_sonu_stok=evaluate("donem_sonu_#PRODUCT_GROUPBY_ID#")>
</cfif>
<cfset ds_toplam_maliyet=0>
<cfset ds_toplam_maliyet2=0>
<cfif isdefined('attributes.display_cost')>
	<cfif wrk_round(donem_sonu_stok) neq 0>
		<cfif IS_PRODUCTION eq 1><!--- uretilen urunler icin donem sonu specli maliyet toplamı getiriliyor --->
			<cfif isdefined("donem_sonu_specli_maliyet_#PRODUCT_GROUPBY_ID#") and len(evaluate("donem_sonu_specli_maliyet_#PRODUCT_GROUPBY_ID#") and evaluate("donem_sonu_specli_maliyet_#PRODUCT_GROUPBY_ID#") neq 0)>
				<cfset ds_toplam_maliyet =evaluate("donem_sonu_specli_maliyet_#PRODUCT_GROUPBY_ID#")/donem_sonu_kur>
			</cfif>
			<cfif isdefined('attributes.is_system_money_2')>
				<cfif isdefined("donem_sonu_specli_maliyet2_#PRODUCT_GROUPBY_ID#") and len(evaluate("donem_sonu_specli_maliyet2_#PRODUCT_GROUPBY_ID#") and evaluate("donem_sonu_specli_maliyet_#PRODUCT_GROUPBY_ID#") neq 0)>
					<cfset ds_toplam_maliyet2 =evaluate("donem_sonu_specli_maliyet2_#PRODUCT_GROUPBY_ID#")>
				</cfif>
			</cfif>
		<cfelse>
			<cfif wrk_round(donem_sonu_stok) neq 0>
				<cfset db_maliyet = produc_cost_func(cost_product_id:GET_ALL_STOCK.PRODUCT_ID,cost_date:finish_date)>
				<cfset donem_sonu_maliyet=(donem_sonu_stok*( db_maliyet.PURCHASE_NET_SYSTEM + db_maliyet.PURCHASE_EXTRA_COST_SYSTEM))>
				<cfif donem_sonu_maliyet neq 0>
					<cfset ds_toplam_maliyet =donem_sonu_maliyet/donem_sonu_kur>
				</cfif>
				<cfif isdefined('attributes.is_system_money_2')>
					<cfset donem_sonu_maliyet2=(donem_sonu_stok*( db_maliyet.PURCHASE_NET_SYSTEM_2 + db_maliyet.PURCHASE_EXTRA_COST_SYSTEM_2))>
					<cfif donem_sonu_maliyet2 neq 0>
						<cfset ds_toplam_maliyet2 =donem_sonu_maliyet2>
					</cfif>
				</cfif>
			</cfif> 
		</cfif> 
	</cfif> 
</cfif>
<cfif isdefined('attributes.stock_age')>
	<cfset agirlikli_toplam=0>
	<cfif donem_sonu_stok gt 0>
		<cfset kalan=donem_sonu_stok>
		<cfquery name="get_product_detail" dbtype="query">
			SELECT 
				AMOUNT AS PURCHASE_AMOUNT,
				GUN_FARKI 
			FROM 
				GET_STOCK_AGE 
			WHERE 
				#ALAN_ADI# =#GET_ALL_STOCK.PRODUCT_GROUPBY_ID# 
			ORDER BY ISLEM_TARIHI DESC
		</cfquery>
		<cfloop query="get_product_detail">
			<cfif kalan gt 0 and PURCHASE_AMOUNT lte kalan>
				<cfset kalan = kalan - PURCHASE_AMOUNT>
				<cfset agırlıklı_toplam=  agırlıklı_toplam + (PURCHASE_AMOUNT*GUN_FARKI)>
			<cfelseif kalan gt 0 and PURCHASE_AMOUNT gt kalan>
				<cfset agırlıklı_toplam=  agırlıklı_toplam + (kalan*GUN_FARKI)>
				<cfbreak>
			</cfif>
		</cfloop>
		<cfset agırlıklı_toplam=agırlıklı_toplam/donem_sonu_stok>
	</cfif>
</cfif>
<cfquery name="add_temp_report" datasource="#dsn_report#">
	INSERT INTO #attributes.table_name#
	(
		<cfif isdefined('attributes.DEPARTMENT_ID') and len(attributes.DEPARTMENT_ID)>
		DEPARTMENT_ID,
        LOCATION_ID,
		</cfif>                        
        PERIOD_MONTH,
        PERIOD_YEAR,
        OUR_COMPANY_ID,
        MONEY,
        OTHER_MONEY,
        STOCK_CODE,
		ACIKLAMA,
		BARCOD,
		SPECT_VAR_ID,
		PRODUCT_CODE,
		MANUFACT_CODE,
		MAIN_UNIT,
		acilis_miktar_,
		db_maliyet_temp,
		db_maliyet2_temp,
		alis_miktar_,
		alis_iade_miktar_,
		net_alis,
        net_alis2,
		alis_maliyet_,
		alis_iade_maliyet_,
		alis_mal_1,
		alis_maliyet2_,
		alis_iade_maliyet2_,
		alis_mal_2,
		satis_miktar_,
		satis_iade_miktar_,
		net_satis_miktar1,
		fatura_satis_miktar_,
		fatura_satis_tutar_,
		fatura_satis_tutar2_,
		fatura_satis_iade_miktar_,
		fatura_satis_iade_tutar_,
		fatura_satis_iade_tutar2_,
		satis_maliyet_,
		satis_iade_maliyet_,
		satis_mal_1,
		satis_maliyet2_,
		satis_iade_maliyet2_,
		satis_net_tutar_2,
		kons_cikis_miktar_,
		kons_cikis_maliyet_,
		kons_cikis_maliyet2_,
		kons_iade_miktar_,
		kons_iade_maliyet_,
		kons_iade_maliyet2_,
		konsinye_giris_miktar_,
		konsinye_giris_maliyet_,
		konsinye_giris_maliyet2_,
		kons_giris_iade_miktar_,
		kons_giris_iade_maliyet_,
		kons_giris_iade_maliyet2_,
		servis_giris_miktar_,
		servis_giris_maliyet_,
		servis_giris_maliyet2_,
		servis_cikis_miktar_,
		servis_cikis_maliyet_,
		servis_cikis_maliyet2_,
		rma_giris_miktar_,
		rma_giris_maliyet_,
		rma_giris_maliyet2_,
		rma_cikis_miktar_,
		rma_cikis_maliyet_,
		rma_cikis_maliyet2_,
		uretim_miktar_,
		uretim_maliyet_,
		uretim_maliyet2_,
		sarf_miktar_,
		uretim_sarf_miktar_,
		fire_miktar_,
		sarf_maliyet_,
		uretim_sarf_maliyet_,
		fire_maliyet_,
		sarf_maliyet2_,
		uretim_sarf_maliyet2_,
		fire_maliyet2_,
		sayim_miktar_,
		sayim_maliyet_,
		sayim_maliyet2_,
		demontaj_giris_miktar_,
		demontaj_giris_maliyet_,
		demontaj_giris_maliyet2_,
		demontaj_giden_miktar_,
		demontaj_giden_maliyet_,
		demontaj_giden_maliyet2_,
		masraf_miktar_,
		masraf_maliyet_,
		masraf_maliyet2_,
		sevk_giris_miktar_,
		sevk_cikis_miktar_,
		sevk_giris_maliyet_,
		sevk_cikis_maliyet_,
		sevk_giris_maliyet2_,
		sevk_cikis_maliyet2_,
		ithal_mal_giris_miktari_,
        ithal_mal_giris_miktari2_,
		ithal_mal_cikis_miktari_,
        ithal_mal_cikis_miktari2_,
		ithal_mal_giris_maliyeti_,
		ithal_mal_cikis_maliyeti_,
		ithal_mal_giris_maliyeti2_,
		ithal_mal_cikis_maliyeti2_,
		ambar_fis_giris_miktari_,
		ambar_fis_cikis_miktari_,
		ambar_fis_giris_maliyeti_,
		ambar_fis_cikis_maliyeti_,
		ambar_fis_giris_maliyeti2_,
		ambar_fis_cikis_maliyeti2_,
		donem_sonu_,
		ds_toplam_maliyet2,
		ds_toplam_maliyet,
		ds_toplam_maliyet_bol_donem_sonu_stok,
		agırlıklı_toplam
	)
	VALUES
	(
    	<cfif isdefined('attributes.DEPARTMENT_ID') and len(attributes.DEPARTMENT_ID)>
		#ListGetAt(attributes.department_id,1,'-')#,
		#ListGetAt(attributes.department_id,2,'-')#,
		</cfif>  
		#attributes.period_month#,
        #attributes.period_year#,
        #attributes.period_our_company_id#,
        '#session.ep.money#',
        '#session.ep.money2#',
		'#GET_ALL_STOCK.STOCK_CODE#',
		'#GET_ALL_STOCK.ACIKLAMA#',
		'#GET_ALL_STOCK.BARCOD#',
		<cfif isdefined('GET_ALL_STOCK.SPECT_VAR_ID') and len(GET_ALL_STOCK.SPECT_VAR_ID)>#GET_ALL_STOCK.SPECT_VAR_ID#<cfelse>NULL</cfif>,
		'#GET_ALL_STOCK.PRODUCT_CODE#',
		'#GET_ALL_STOCK.MANUFACT_CODE#',
		'#GET_ALL_STOCK.MAIN_UNIT#',
		<cfif isdefined("acilis_miktar_#PRODUCT_GROUPBY_ID#") and len(evaluate("acilis_miktar_#PRODUCT_GROUPBY_ID#"))>#evaluate("acilis_miktar_#PRODUCT_GROUPBY_ID#")#<cfelse>NULL</cfif>,
		<cfif isdefined("db_maliyet_temp") and len(db_maliyet_temp)>'#db_maliyet_temp#'<cfelse>NULL</cfif>,
		<cfif isdefined("db_maliyet2_temp") and len(db_maliyet2_temp)>'#db_maliyet2_temp#'<cfelse>NULL</cfif>,
		<cfif isdefined("alis_miktar_#PRODUCT_GROUPBY_ID#") and len(evaluate("alis_miktar_#PRODUCT_GROUPBY_ID#"))>#evaluate("alis_miktar_#PRODUCT_GROUPBY_ID#")#<cfelse>NULL</cfif>,
		<cfif isdefined("alis_iade_miktar_#PRODUCT_GROUPBY_ID#") and len(evaluate("alis_iade_miktar_#PRODUCT_GROUPBY_ID#"))>#evaluate("alis_iade_miktar_#PRODUCT_GROUPBY_ID#")#<cfelse>NULL</cfif>,
		<cfif isdefined("net_alis") and len(net_alis)>#net_alis#<cfelse>NULL</cfif>,
        <cfif isdefined("net_alis2") and len(net_alis2)>#net_alis2#<cfelse>NULL</cfif>,
		<cfif isdefined("alis_maliyet_#PRODUCT_GROUPBY_ID#") and len(evaluate("alis_maliyet_#PRODUCT_GROUPBY_ID#"))>#evaluate("alis_maliyet_#PRODUCT_GROUPBY_ID#")#<cfelse>NULL</cfif>,
		<cfif isdefined("alis_iade_maliyet_#PRODUCT_GROUPBY_ID#") and len(evaluate("alis_iade_maliyet_#PRODUCT_GROUPBY_ID#"))>#evaluate("alis_iade_maliyet_#PRODUCT_GROUPBY_ID#")#<cfelse>NULL</cfif>,
		<cfif isdefined("alis_mal_1") and len(alis_mal_1)>#alis_mal_1#<cfelse>NULL</cfif>,
		<cfif isdefined("alis_maliyet2_#PRODUCT_GROUPBY_ID#") and len(evaluate("alis_maliyet2_#PRODUCT_GROUPBY_ID#"))>#evaluate("alis_maliyet2_#PRODUCT_GROUPBY_ID#")#<cfelse>NULL</cfif>,
		<cfif isdefined("alis_iade_maliyet2_#PRODUCT_GROUPBY_ID#") and len(evaluate("alis_iade_maliyet2_#PRODUCT_GROUPBY_ID#"))>#evaluate("alis_iade_maliyet2_#PRODUCT_GROUPBY_ID#")#<cfelse>NULL</cfif>,
		<cfif isdefined("alis_mal_2") and len(alis_mal_2)>#alis_mal_2#<cfelse>NULL</cfif>,
		<cfif isdefined("satis_miktar_#PRODUCT_GROUPBY_ID#") and len(evaluate("satis_miktar_#PRODUCT_GROUPBY_ID#"))>#evaluate("satis_miktar_#PRODUCT_GROUPBY_ID#")#<cfelse>NULL</cfif>,
		<cfif isdefined("satis_iade_miktar_#PRODUCT_GROUPBY_ID#") and len(evaluate("satis_iade_miktar_#PRODUCT_GROUPBY_ID#"))>#evaluate("satis_iade_miktar_#PRODUCT_GROUPBY_ID#")#<cfelse>NULL</cfif>,
		<cfif isdefined("net_satis_miktar1") and len(net_satis_miktar1)>#net_satis_miktar1#<cfelse>NULL</cfif>,
		<cfif isdefined("fatura_satis_miktar_#PRODUCT_GROUPBY_ID#") and len(evaluate("fatura_satis_miktar_#PRODUCT_GROUPBY_ID#"))>#evaluate("fatura_satis_miktar_#PRODUCT_GROUPBY_ID#")#<cfelse>NULL</cfif>,
		<cfif isdefined("fatura_satis_tutar_#PRODUCT_GROUPBY_ID#") and len(evaluate("fatura_satis_tutar_#PRODUCT_GROUPBY_ID#"))>#evaluate("fatura_satis_tutar_#PRODUCT_GROUPBY_ID#")#<cfelse>NULL</cfif>,
		<cfif isdefined("fatura_satis_tutar2_#PRODUCT_GROUPBY_ID#") and len(evaluate("fatura_satis_tutar2_#PRODUCT_GROUPBY_ID#"))>#evaluate("fatura_satis_tutar2_#PRODUCT_GROUPBY_ID#")#<cfelse>NULL</cfif>,
		<cfif isdefined("fatura_satis_iade_miktar_#PRODUCT_GROUPBY_ID#") and len(evaluate("fatura_satis_iade_miktar_#PRODUCT_GROUPBY_ID#"))>#evaluate("fatura_satis_iade_miktar_#PRODUCT_GROUPBY_ID#")#<cfelse>NULL</cfif>,
		<cfif isdefined("fatura_satis_iade_tutar_#PRODUCT_GROUPBY_ID#") and len(evaluate("fatura_satis_iade_tutar_#PRODUCT_GROUPBY_ID#"))>#evaluate("fatura_satis_iade_tutar_#PRODUCT_GROUPBY_ID#")#<cfelse>NULL</cfif>,
		<cfif isdefined("fatura_satis_iade_tutar2_#PRODUCT_GROUPBY_ID#") and len(evaluate("fatura_satis_iade_tutar2_#PRODUCT_GROUPBY_ID#"))>#evaluate("fatura_satis_iade_tutar2_#PRODUCT_GROUPBY_ID#")#<cfelse>NULL</cfif>,
		<cfif isdefined("satis_maliyet_#PRODUCT_GROUPBY_ID#") and len(evaluate("satis_maliyet_#PRODUCT_GROUPBY_ID#"))>#evaluate("satis_maliyet_#PRODUCT_GROUPBY_ID#")#<cfelse>NULL</cfif>,
		<cfif isdefined("satis_iade_maliyet_#PRODUCT_GROUPBY_ID#") and len(evaluate("satis_iade_maliyet_#PRODUCT_GROUPBY_ID#"))>#evaluate("satis_iade_maliyet_#PRODUCT_GROUPBY_ID#")#<cfelse>NULL</cfif>,
		<cfif isdefined("satis_mal_1") and len(satis_mal_1)>#satis_mal_1#<cfelse>NULL</cfif>,
		<cfif isdefined("satis_maliyet2_#PRODUCT_GROUPBY_ID#") and len(evaluate("satis_maliyet2_#PRODUCT_GROUPBY_ID#"))>#evaluate("satis_maliyet2_#PRODUCT_GROUPBY_ID#")#<cfelse>NULL</cfif>,
		<cfif isdefined("satis_iade_maliyet2_#PRODUCT_GROUPBY_ID#") and len(evaluate("satis_iade_maliyet2_#PRODUCT_GROUPBY_ID#"))>#evaluate("satis_iade_maliyet2_#PRODUCT_GROUPBY_ID#")#<cfelse>NULL</cfif>,
		<cfif isdefined("satis_net_tutar_2") and len(satis_net_tutar_2)>#satis_net_tutar_2#<cfelse>NULL</cfif>,
		<cfif isdefined("kons_cikis_miktar_#PRODUCT_GROUPBY_ID#") and len(evaluate("kons_cikis_miktar_#PRODUCT_GROUPBY_ID#"))>#evaluate("kons_cikis_miktar_#PRODUCT_GROUPBY_ID#")#<cfelse>NULL</cfif>,
		<cfif isdefined("kons_cikis_maliyet_#PRODUCT_GROUPBY_ID#") and len(evaluate("kons_cikis_maliyet_#PRODUCT_GROUPBY_ID#"))>#evaluate("kons_cikis_maliyet_#PRODUCT_GROUPBY_ID#")#<cfelse>NULL</cfif>,
		<cfif isdefined("kons_cikis_maliyet2_#PRODUCT_GROUPBY_ID#") and len(evaluate("kons_cikis_maliyet2_#PRODUCT_GROUPBY_ID#"))>#evaluate("kons_cikis_maliyet2_#PRODUCT_GROUPBY_ID#")#<cfelse>NULL</cfif>,
		<cfif isdefined("kons_iade_miktar_#PRODUCT_GROUPBY_ID#") and len(evaluate("kons_iade_miktar_#PRODUCT_GROUPBY_ID#"))>#evaluate("kons_iade_miktar_#PRODUCT_GROUPBY_ID#")#<cfelse>NULL</cfif>,
		<cfif isdefined("kons_iade_maliyet_#PRODUCT_GROUPBY_ID#") and len(evaluate("kons_iade_maliyet_#PRODUCT_GROUPBY_ID#"))>#evaluate("kons_iade_maliyet_#PRODUCT_GROUPBY_ID#")#<cfelse>NULL</cfif>,
		<cfif isdefined("kons_iade_maliyet2_#PRODUCT_GROUPBY_ID#") and len(evaluate("kons_iade_maliyet2_#PRODUCT_GROUPBY_ID#"))>#evaluate("kons_iade_maliyet2_#PRODUCT_GROUPBY_ID#")#<cfelse>NULL</cfif>,
		<cfif isdefined("konsinye_giris_miktar_#PRODUCT_GROUPBY_ID#") and len(evaluate("konsinye_giris_miktar_#PRODUCT_GROUPBY_ID#"))>#evaluate("konsinye_giris_miktar_#PRODUCT_GROUPBY_ID#")#<cfelse>NULL</cfif>,
		<cfif isdefined("konsinye_giris_maliyet_#PRODUCT_GROUPBY_ID#") and len(evaluate("konsinye_giris_maliyet_#PRODUCT_GROUPBY_ID#"))>#evaluate("konsinye_giris_maliyet_#PRODUCT_GROUPBY_ID#")#<cfelse>NULL</cfif>,
		<cfif isdefined("konsinye_giris_maliyet2_#PRODUCT_GROUPBY_ID#") and len(evaluate("konsinye_giris_maliyet2_#PRODUCT_GROUPBY_ID#"))>#evaluate("konsinye_giris_maliyet2_#PRODUCT_GROUPBY_ID#")#<cfelse>NULL</cfif>,
		<cfif isdefined("kons_giris_iade_miktar_#PRODUCT_GROUPBY_ID#") and len(evaluate("kons_giris_iade_miktar_#PRODUCT_GROUPBY_ID#"))>#evaluate("kons_giris_iade_miktar_#PRODUCT_GROUPBY_ID#")#<cfelse>NULL</cfif>,
		<cfif isdefined("kons_giris_iade_maliyet_#PRODUCT_GROUPBY_ID#") and len(evaluate("kons_giris_iade_maliyet_#PRODUCT_GROUPBY_ID#"))>#evaluate("kons_giris_iade_maliyet_#PRODUCT_GROUPBY_ID#")#<cfelse>NULL</cfif>,
		<cfif isdefined("kons_giris_iade_maliyet2_#PRODUCT_GROUPBY_ID#") and len(evaluate("kons_giris_iade_maliyet2_#PRODUCT_GROUPBY_ID#"))>#evaluate("kons_giris_iade_maliyet2_#PRODUCT_GROUPBY_ID#")#<cfelse>NULL</cfif>,
		<cfif isdefined("servis_giris_miktar_#PRODUCT_GROUPBY_ID#") and len(evaluate("servis_giris_miktar_#PRODUCT_GROUPBY_ID#"))>#evaluate("servis_giris_miktar_#PRODUCT_GROUPBY_ID#")#<cfelse>NULL</cfif>,
		<cfif isdefined("servis_giris_maliyet_#PRODUCT_GROUPBY_ID#") and len(evaluate("servis_giris_maliyet_#PRODUCT_GROUPBY_ID#"))>#evaluate("servis_giris_maliyet_#PRODUCT_GROUPBY_ID#")#<cfelse>NULL</cfif>,
		<cfif isdefined("servis_giris_maliyet2_#PRODUCT_GROUPBY_ID#") and len(evaluate("servis_giris_maliyet2_#PRODUCT_GROUPBY_ID#"))>#evaluate("servis_giris_maliyet2_#PRODUCT_GROUPBY_ID#")#<cfelse>NULL</cfif>,
		<cfif isdefined("servis_cikis_miktar_#PRODUCT_GROUPBY_ID#") and len(evaluate("servis_cikis_miktar_#PRODUCT_GROUPBY_ID#"))>#evaluate("servis_cikis_miktar_#PRODUCT_GROUPBY_ID#")#<cfelse>NULL</cfif>,
		<cfif isdefined("servis_cikis_maliyet_#PRODUCT_GROUPBY_ID#") and len(evaluate("servis_cikis_maliyet_#PRODUCT_GROUPBY_ID#"))>#evaluate("servis_cikis_maliyet_#PRODUCT_GROUPBY_ID#")#<cfelse>NULL</cfif>,
		<cfif isdefined("servis_cikis_maliyet2_#PRODUCT_GROUPBY_ID#") and len(evaluate("servis_cikis_maliyet2_#PRODUCT_GROUPBY_ID#"))>#evaluate("servis_cikis_maliyet2_#PRODUCT_GROUPBY_ID#")#<cfelse>NULL</cfif>,
		<cfif isdefined("rma_giris_miktar_#PRODUCT_GROUPBY_ID#") and len(evaluate("rma_giris_miktar_#PRODUCT_GROUPBY_ID#"))>#evaluate("rma_giris_miktar_#PRODUCT_GROUPBY_ID#")#<cfelse>NULL</cfif>,
		<cfif isdefined("rma_giris_maliyet_#PRODUCT_GROUPBY_ID#") and len(evaluate("rma_giris_maliyet_#PRODUCT_GROUPBY_ID#"))>#evaluate("rma_giris_maliyet_#PRODUCT_GROUPBY_ID#")#<cfelse>NULL</cfif>,
		<cfif isdefined("rma_giris_maliyet2_#PRODUCT_GROUPBY_ID#") and len(evaluate("rma_giris_maliyet2_#PRODUCT_GROUPBY_ID#"))>#evaluate("rma_giris_maliyet2_#PRODUCT_GROUPBY_ID#")#<cfelse>NULL</cfif>,
		<cfif isdefined("rma_cikis_miktar_#PRODUCT_GROUPBY_ID#") and len(evaluate("rma_cikis_miktar_#PRODUCT_GROUPBY_ID#"))>#evaluate("rma_cikis_miktar_#PRODUCT_GROUPBY_ID#")#<cfelse>NULL</cfif>,
		<cfif isdefined("rma_cikis_maliyet_#PRODUCT_GROUPBY_ID#") and len(evaluate("rma_cikis_maliyet_#PRODUCT_GROUPBY_ID#"))>#evaluate("rma_cikis_maliyet_#PRODUCT_GROUPBY_ID#")#<cfelse>NULL</cfif>,
		<cfif isdefined("rma_cikis_maliyet2_#PRODUCT_GROUPBY_ID#") and len(evaluate("rma_cikis_maliyet2_#PRODUCT_GROUPBY_ID#"))>#evaluate("rma_cikis_maliyet2_#PRODUCT_GROUPBY_ID#")#<cfelse>NULL</cfif>,
		<cfif isdefined("uretim_miktar_#PRODUCT_GROUPBY_ID#") and len(evaluate("uretim_miktar_#PRODUCT_GROUPBY_ID#"))>#evaluate("uretim_miktar_#PRODUCT_GROUPBY_ID#")#<cfelse>NULL</cfif>,
		<cfif isdefined("uretim_maliyet_#PRODUCT_GROUPBY_ID#") and len(evaluate("uretim_maliyet_#PRODUCT_GROUPBY_ID#"))>#evaluate("uretim_maliyet_#PRODUCT_GROUPBY_ID#")#<cfelse>NULL</cfif>,
		<cfif isdefined("uretim_maliyet2_#PRODUCT_GROUPBY_ID#") and len(evaluate("uretim_maliyet2_#PRODUCT_GROUPBY_ID#"))>#evaluate("uretim_maliyet2_#PRODUCT_GROUPBY_ID#")#<cfelse>NULL</cfif>,
		<cfif isdefined("sarf_miktar_#PRODUCT_GROUPBY_ID#") and len(evaluate("sarf_miktar_#PRODUCT_GROUPBY_ID#"))>#evaluate("sarf_miktar_#PRODUCT_GROUPBY_ID#")#<cfelse>NULL</cfif>,
		<cfif isdefined("uretim_sarf_miktar_#PRODUCT_GROUPBY_ID#") and len(evaluate("uretim_sarf_miktar_#PRODUCT_GROUPBY_ID#"))>#evaluate("uretim_sarf_miktar_#PRODUCT_GROUPBY_ID#")#<cfelse>NULL</cfif>,
		<cfif isdefined("fire_miktar_#PRODUCT_GROUPBY_ID#") and len(evaluate("fire_miktar_#PRODUCT_GROUPBY_ID#"))>#evaluate("fire_miktar_#PRODUCT_GROUPBY_ID#")#<cfelse>NULL</cfif>,
		<cfif isdefined("sarf_maliyet_#PRODUCT_GROUPBY_ID#") and len(evaluate("sarf_maliyet_#PRODUCT_GROUPBY_ID#"))>#evaluate("sarf_maliyet_#PRODUCT_GROUPBY_ID#")#<cfelse>NULL</cfif>,
		<cfif isdefined("uretim_sarf_maliyet_#PRODUCT_GROUPBY_ID#") and len(evaluate("uretim_sarf_maliyet_#PRODUCT_GROUPBY_ID#"))>#evaluate("uretim_sarf_maliyet_#PRODUCT_GROUPBY_ID#")#<cfelse>NULL</cfif>,
		<cfif isdefined("fire_maliyet_#PRODUCT_GROUPBY_ID#") and len(evaluate("fire_maliyet_#PRODUCT_GROUPBY_ID#"))>#evaluate("fire_maliyet_#PRODUCT_GROUPBY_ID#")#<cfelse>NULL</cfif>,
		<cfif isdefined("sarf_maliyet2_#PRODUCT_GROUPBY_ID#") and len(evaluate("sarf_maliyet2_#PRODUCT_GROUPBY_ID#"))>#evaluate("sarf_maliyet2_#PRODUCT_GROUPBY_ID#")#<cfelse>NULL</cfif>,
		<cfif isdefined("uretim_sarf_maliyet2_#PRODUCT_GROUPBY_ID#") and len(evaluate("uretim_sarf_maliyet2_#PRODUCT_GROUPBY_ID#"))>#evaluate("uretim_sarf_maliyet2_#PRODUCT_GROUPBY_ID#")#<cfelse>NULL</cfif>,
		<cfif isdefined("fire_maliyet2_#PRODUCT_GROUPBY_ID#") and len(evaluate("fire_maliyet2_#PRODUCT_GROUPBY_ID#"))>#evaluate("fire_maliyet2_#PRODUCT_GROUPBY_ID#")#<cfelse>NULL</cfif>,
		<cfif isdefined("sayim_miktar_#PRODUCT_GROUPBY_ID#") and len(evaluate("sayim_miktar_#PRODUCT_GROUPBY_ID#"))>#evaluate("sayim_miktar_#PRODUCT_GROUPBY_ID#")#<cfelse>NULL</cfif>,
		<cfif isdefined("sayim_maliyet_#PRODUCT_GROUPBY_ID#") and len(evaluate("sayim_maliyet_#PRODUCT_GROUPBY_ID#"))>#evaluate("sayim_maliyet_#PRODUCT_GROUPBY_ID#")#<cfelse>NULL</cfif>,
		<cfif isdefined("sayim_maliyet2_#PRODUCT_GROUPBY_ID#") and len(evaluate("sayim_maliyet2_#PRODUCT_GROUPBY_ID#"))>#evaluate("sayim_maliyet2_#PRODUCT_GROUPBY_ID#")#<cfelse>NULL</cfif>,
		<cfif isdefined("demontaj_giris_miktar_#PRODUCT_GROUPBY_ID#") and len(evaluate("demontaj_giris_miktar_#PRODUCT_GROUPBY_ID#"))>#evaluate("demontaj_giris_miktar_#PRODUCT_GROUPBY_ID#")#<cfelse>NULL</cfif>,
		<cfif isdefined("demontaj_giris_maliyet_#PRODUCT_GROUPBY_ID#") and len(evaluate("demontaj_giris_maliyet_#PRODUCT_GROUPBY_ID#"))>#evaluate("demontaj_giris_maliyet_#PRODUCT_GROUPBY_ID#")#<cfelse>NULL</cfif>,
		<cfif isdefined("demontaj_giris_maliyet2_#PRODUCT_GROUPBY_ID#") and len(evaluate("demontaj_giris_maliyet2_#PRODUCT_GROUPBY_ID#"))>#evaluate("demontaj_giris_maliyet2_#PRODUCT_GROUPBY_ID#")#<cfelse>NULL</cfif>,
		<cfif isdefined("demontaj_giden_miktar_#PRODUCT_GROUPBY_ID#") and len(evaluate("demontaj_giden_miktar_#PRODUCT_GROUPBY_ID#"))>#evaluate("demontaj_giden_miktar_#PRODUCT_GROUPBY_ID#")#<cfelse>NULL</cfif>,
		<cfif isdefined("demontaj_giden_maliyet_#PRODUCT_GROUPBY_ID#") and len(evaluate("demontaj_giden_maliyet_#PRODUCT_GROUPBY_ID#"))>#evaluate("demontaj_giden_maliyet_#PRODUCT_GROUPBY_ID#")#<cfelse>NULL</cfif>,
		<cfif isdefined("demontaj_giden_maliyet2_#PRODUCT_GROUPBY_ID#") and len(evaluate("demontaj_giden_maliyet2_#PRODUCT_GROUPBY_ID#"))>#evaluate("demontaj_giden_maliyet2_#PRODUCT_GROUPBY_ID#")#<cfelse>NULL</cfif>,
		<cfif isdefined("masraf_miktar_#PRODUCT_GROUPBY_ID#") and len(evaluate("masraf_miktar_#PRODUCT_GROUPBY_ID#"))>#evaluate("masraf_miktar_#PRODUCT_GROUPBY_ID#")#<cfelse>NULL</cfif>,
		<cfif isdefined("masraf_maliyet_#PRODUCT_GROUPBY_ID#") and len(evaluate("masraf_maliyet_#PRODUCT_GROUPBY_ID#"))>#evaluate("masraf_maliyet_#PRODUCT_GROUPBY_ID#")#<cfelse>NULL</cfif>,
		<cfif isdefined("masraf_maliyet2_#PRODUCT_GROUPBY_ID#") and len(evaluate("masraf_maliyet2_#PRODUCT_GROUPBY_ID#"))>#evaluate("masraf_maliyet2_#PRODUCT_GROUPBY_ID#")#<cfelse>NULL</cfif>,
		<cfif isdefined("sevk_giris_miktar_#PRODUCT_GROUPBY_ID#") and len(evaluate("sevk_giris_miktar_#PRODUCT_GROUPBY_ID#"))>#evaluate("sevk_giris_miktar_#PRODUCT_GROUPBY_ID#")#<cfelse>NULL</cfif>,
		<cfif isdefined("sevk_cikis_miktar_#PRODUCT_GROUPBY_ID#") and len(evaluate("sevk_cikis_miktar_#PRODUCT_GROUPBY_ID#"))>#evaluate("sevk_cikis_miktar_#PRODUCT_GROUPBY_ID#")#<cfelse>NULL</cfif>,
		<cfif isdefined("sevk_giris_maliyet_#PRODUCT_GROUPBY_ID#") and len(evaluate("sevk_giris_maliyet_#PRODUCT_GROUPBY_ID#"))>#evaluate("sevk_giris_maliyet_#PRODUCT_GROUPBY_ID#")#<cfelse>NULL</cfif>,
		<cfif isdefined("sevk_cikis_maliyet_#PRODUCT_GROUPBY_ID#") and len(evaluate("sevk_cikis_maliyet_#PRODUCT_GROUPBY_ID#"))>#evaluate("sevk_cikis_maliyet_#PRODUCT_GROUPBY_ID#")#<cfelse>NULL</cfif>,
		<cfif isdefined("sevk_giris_maliyet2_#PRODUCT_GROUPBY_ID#") and len(evaluate("sevk_giris_maliyet2_#PRODUCT_GROUPBY_ID#"))>#evaluate("sevk_giris_maliyet2_#PRODUCT_GROUPBY_ID#")#<cfelse>NULL</cfif>,
		<cfif isdefined("sevk_cikis_maliyet2_#PRODUCT_GROUPBY_ID#") and len(evaluate("sevk_cikis_maliyet2_#PRODUCT_GROUPBY_ID#"))>#evaluate("sevk_cikis_maliyet2_#PRODUCT_GROUPBY_ID#")#<cfelse>NULL</cfif>,
		<cfif isdefined("ithal_mal_giris_miktari_#PRODUCT_GROUPBY_ID#") and len(evaluate("ithal_mal_giris_miktari_#PRODUCT_GROUPBY_ID#"))>#evaluate("ithal_mal_giris_miktari_#PRODUCT_GROUPBY_ID#")#<cfelse>NULL</cfif>,
        <cfif isdefined("ithal_mal_giris_miktari2_#PRODUCT_GROUPBY_ID#") and len(evaluate("ithal_mal_giris_miktari2_#PRODUCT_GROUPBY_ID#"))>#evaluate("ithal_mal_giris_miktari2_#PRODUCT_GROUPBY_ID#")#<cfelse>NULL</cfif>,
		<cfif isdefined("ithal_mal_cikis_miktari_#PRODUCT_GROUPBY_ID#") and len(evaluate("ithal_mal_cikis_miktari_#PRODUCT_GROUPBY_ID#"))>#evaluate("ithal_mal_cikis_miktari_#PRODUCT_GROUPBY_ID#")#<cfelse>NULL</cfif>,
        <cfif isdefined("ithal_mal_cikis_miktari2_#PRODUCT_GROUPBY_ID#") and len(evaluate("ithal_mal_cikis_miktari2_#PRODUCT_GROUPBY_ID#"))>#evaluate("ithal_mal_cikis_miktari2_#PRODUCT_GROUPBY_ID#")#<cfelse>NULL</cfif>,
		<cfif isdefined("ithal_mal_giris_maliyeti_#PRODUCT_GROUPBY_ID#") and len(evaluate("ithal_mal_giris_maliyeti_#PRODUCT_GROUPBY_ID#"))>#evaluate("ithal_mal_giris_maliyeti_#PRODUCT_GROUPBY_ID#")#<cfelse>NULL</cfif>,
		<cfif isdefined("ithal_mal_cikis_maliyeti_#PRODUCT_GROUPBY_ID#") and len(evaluate("ithal_mal_cikis_maliyeti_#PRODUCT_GROUPBY_ID#"))>#evaluate("ithal_mal_cikis_maliyeti_#PRODUCT_GROUPBY_ID#")#<cfelse>NULL</cfif>,
		<cfif isdefined("ithal_mal_giris_maliyeti2_#PRODUCT_GROUPBY_ID#") and len(evaluate("ithal_mal_giris_maliyeti2_#PRODUCT_GROUPBY_ID#"))>#evaluate("ithal_mal_giris_maliyeti2_#PRODUCT_GROUPBY_ID#")#<cfelse>NULL</cfif>,
		<cfif isdefined("ithal_mal_cikis_maliyeti2_#PRODUCT_GROUPBY_ID#") and len(evaluate("ithal_mal_cikis_maliyeti2_#PRODUCT_GROUPBY_ID#"))>#evaluate("ithal_mal_cikis_maliyeti2_#PRODUCT_GROUPBY_ID#")#<cfelse>NULL</cfif>,
		<cfif isdefined("ambar_fis_giris_miktari_#PRODUCT_GROUPBY_ID#") and len(evaluate("ambar_fis_giris_miktari_#PRODUCT_GROUPBY_ID#"))>#evaluate("ambar_fis_giris_miktari_#PRODUCT_GROUPBY_ID#")#<cfelse>NULL</cfif>,
		<cfif isdefined("ambar_fis_cikis_miktari_#PRODUCT_GROUPBY_ID#") and len(evaluate("ambar_fis_cikis_miktari_#PRODUCT_GROUPBY_ID#"))>#evaluate("ambar_fis_cikis_miktari_#PRODUCT_GROUPBY_ID#")#<cfelse>NULL</cfif>,
		<cfif isdefined("ambar_fis_giris_maliyeti_#PRODUCT_GROUPBY_ID#") and len(evaluate("ambar_fis_giris_maliyeti_#PRODUCT_GROUPBY_ID#"))>#evaluate("ambar_fis_giris_maliyeti_#PRODUCT_GROUPBY_ID#")#<cfelse>NULL</cfif>,
		<cfif isdefined("ambar_fis_cikis_maliyeti_#PRODUCT_GROUPBY_ID#") and len(evaluate("ambar_fis_cikis_maliyeti_#PRODUCT_GROUPBY_ID#"))>#evaluate("ambar_fis_cikis_maliyeti_#PRODUCT_GROUPBY_ID#")#<cfelse>NULL</cfif>,
		<cfif isdefined("ambar_fis_giris_maliyeti2_#PRODUCT_GROUPBY_ID#") and len(evaluate("ambar_fis_giris_maliyeti2_#PRODUCT_GROUPBY_ID#"))>#evaluate("ambar_fis_giris_maliyeti2_#PRODUCT_GROUPBY_ID#")#<cfelse>NULL</cfif>,
		<cfif isdefined("ambar_fis_cikis_maliyeti2_#PRODUCT_GROUPBY_ID#") and len(evaluate("ambar_fis_cikis_maliyeti2_#PRODUCT_GROUPBY_ID#"))>#evaluate("ambar_fis_cikis_maliyeti2_#PRODUCT_GROUPBY_ID#")#<cfelse>NULL</cfif>,
		<cfif isdefined("donem_sonu_#PRODUCT_GROUPBY_ID#") and len(evaluate("donem_sonu_#PRODUCT_GROUPBY_ID#"))>#evaluate("donem_sonu_#PRODUCT_GROUPBY_ID#")#<cfelse>NULL</cfif>,
		<!--- #donem_sonu_stok#, --->
		#ds_toplam_maliyet2#,
		#ds_toplam_maliyet#,
		<cfif donem_sonu_stok neq 0>#ds_toplam_maliyet/donem_sonu_stok#<cfelse>0</cfif>,
		<cfif isdefined('agırlıklı_toplam') and len(agırlıklı_toplam)>#agırlıklı_toplam#<cfelse>NULL</cfif>
	)
</cfquery>
