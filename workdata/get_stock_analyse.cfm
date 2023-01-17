<cfif isdefined("attributes.is_form_submitted")>
	<cfif attributes.report_type neq 7>
		<cfif isdate(attributes.date)>
			<cf_date tarih = 'attributes.date'>
			<cfset start_date =attributes.date>
		</cfif>
		<cfif isdate(attributes.date2)>
			<cf_date tarih = 'attributes.date2'>
			<cfset finish_date =attributes.date2>
		</cfif>
		<cfif len(trim(attributes.sup_company)) and len(attributes.sup_company_id)>
			<cfset stock_table=1>
		<cfelseif len(trim(attributes.employee_name)) and len(attributes.product_employee_id)>
			<cfset stock_table=1>
		<cfelseif len(trim(attributes.product_name)) and len(attributes.product_id)>
			<cfset stock_table=1>
		<cfelseif len(trim(attributes.brand_name)) and len(attributes.brand_id)>
			<cfset stock_table=1>
		<cfelseif len(trim(attributes.product_cat)) and len(attributes.product_code)>
			<cfset stock_table=1>
		<cfelse>
			<cfset stock_table=0>
		</cfif>
        <cfset islem_tipi = '78,81,82,83,112,113,114,811,761,70,71,72,73,74,75,76,77,79,80,84,85,86,88,110,111,115,116,118,1182,119,140,141,811,1131'>
        <cfquery name="GET_PROCESS_CAT" datasource="#DSN3#">
            SELECT PROCESS_TYPE,PROCESS_CAT_ID,PROCESS_CAT FROM SETUP_PROCESS_CAT WHERE PROCESS_TYPE IN (#islem_tipi#) ORDER BY PROCESS_TYPE
        </cfquery>
		<cfquery name="GET_PERIODS_" datasource="#dsn#">
			SELECT PERIOD_ID FROM SETUP_PERIOD WHERE OUR_COMPANY_ID=#session.ep.company_id#
		</cfquery>
		<cfset new_period_id_list_ = valuelist(GET_PERIODS_.PERIOD_ID)>
		<cf_get_cfc
				path="report.cfc.get_stock_analyses"
				method_name="get_start_rate_func"
				date="#iif(isdefined("attributes.date"),"attributes.date",DE(""))#"
				period_id="#session.ep.period_id#"
				cost_money="#iif(isdefined("attributes.cost_money"),"attributes.cost_money",DE(""))#"
				query_name="START_RATE">
		
        <cfif len(START_RATE.RATE)>
			<cfset donem_basi_kur = START_RATE.RATE>
		<cfelse>
			<cfset donem_basi_kur=1>
		</cfif>
		<!--- donem sonu stok maliyeti bu kurdan hesaplanıyor --->
		<cf_get_cfc
				path="report.cfc.get_stock_analyses"
				method_name="get_finish_rate_func"
				date="#iif(isdefined("attributes.date2"),"attributes.date2",DE(""))#"
				period_id="#iif(isdefined("session.ep.period_id"),"session.ep.period_id",DE(""))#"
				cost_money="#iif(isdefined("attributes.cost_money"),"attributes.cost_money",DE(""))#"
				query_name="FINISH_RATE">
		
		<cfif len(FINISH_RATE.RATE)>
			<cfset donem_sonu_kur = FINISH_RATE.RATE>
		<cfelse>
			<cfset donem_sonu_kur=1>
		</cfif>
		<cfset start_period_cost_date = dateformat(start_date,'dd/mm/yyyy')>
		<cfif start_period_cost_date is '01/01/#session.ep.period_year#'>
			<cfset start_period_cost_date=start_date>
		<cfelse>
			<cfset start_period_cost_date=date_add('d',-1,start_date)>
		</cfif>

<cfif attributes.REPORT_TYPE eq 2>
	<cfquery name="get_total_stock_create" datasource="#dsn2#">
			IF  EXISTS (SELECT TABLE_NAME FROM workcube_cf_report.INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='get_total_stok')
				BEGIN
					DROP TABLE workcube_cf_report.get_total_stok
				END
			
			SELECT * 
			INTO workcube_cf_report.get_total_stok
			FROM (	
				
				 SELECT 
								SUM(AMOUNT) AS TOTAL_STOCK,
								SUM(AMOUNT*MALIYET) AS TOTAL_PRODUCT_COST,
								<cfif isdefined('attributes.is_system_money_2')>
								SUM(AMOUNT*MALIYET_2) AS TOTAL_PRODUCT_COST_2,
								</cfif>
								<cfif listfind('2,3,4,5,6,9',attributes.report_type) and isdefined("attributes.location_based_cost")>
									STORE,
									STORE_LOCATION,
								</cfif>
								<cfif attributes.report_type eq 9 or attributes.report_type eq 10>
								   PRODUCT_ID AS GROUPBY_ALANI,
								   #ALAN_ADI# AS GROUPBY_ALANI_2
								<cfelse>
								   #ALAN_ADI# AS GROUPBY_ALANI
								</cfif>
							FROM
								(
								SELECT 
									SR.UPD_ID,
									S.STOCK_ID,
									S.PRODUCT_ID,
									<cfif listfind('2,3,4,5,6,9',attributes.report_type) and isdefined("attributes.location_based_cost")>
										SR.STORE,
										SR.STORE_LOCATION,
									</cfif>
									<cfif attributes.report_type eq 9>
										SR.STORE,
									</cfif>
									<cfif attributes.report_type eq 10>
										CAST(SR.STORE AS NVARCHAR(50)) +'_'+ CAST(ISNULL(SR.STORE_LOCATION,0) AS NVARCHAR(50)) STORE_LOCATION,
									</cfif>
									SR.SPECT_VAR_ID SPECT_VAR_ID,
									<cfif attributes.report_type eq 8>
										CAST(SR.STOCK_ID AS NVARCHAR(50))+'_'+CAST(ISNULL(SR.SPECT_VAR_ID,0) AS NVARCHAR(50)) AS STOCK_SPEC_ID,
									</cfif>
									S.PRODUCT_MANAGER,
									S.PRODUCT_CATID,
									S.BRAND_ID,
									SUM(SR.STOCK_IN-SR.STOCK_OUT) AMOUNT,
									SR.PROCESS_DATE ISLEM_TARIHI,
									SR.PROCESS_TYPE,
									0 AS MALIYET
									<cfif isdefined('attributes.is_system_money_2')>
									,0 AS MALIYET_2
									</cfif>
								FROM        
									STOCKS_ROW SR WITH (NOLOCK),
									#dsn3_alias#.STOCKS S WITH (NOLOCK),
									#dsn_alias#.STOCKS_LOCATION SL WITH (NOLOCK)
								WHERE
									SR.STOCK_ID=S.STOCK_ID
									AND SR.STORE = SL.DEPARTMENT_ID
									AND SR.STORE_LOCATION=SL.LOCATION_ID
									<cfif not isdefined('is_belognto_institution')>
									AND SL.BELONGTO_INSTITUTION = 0
									</cfif>
									AND SR.PROCESS_DATE <= #attributes.date2#	
									<cfif len(attributes.department_id)>
									AND
										(
										<cfloop list="#attributes.department_id#" delimiters="," index="dept_i">
										(SR.STORE = #listfirst(dept_i,'-')# AND SR.STORE_LOCATION = #listlast(dept_i,'-')#)
										<cfif dept_i neq listlast(attributes.department_id,',') and listlen(attributes.department_id,',') gte 1> OR</cfif>
										</cfloop>  
										)
									<cfelseif is_store>
										AND SR.STORE IN (#branch_dep_list#)
									</cfif>
									<cfif len(trim(attributes.sup_company)) and len(attributes.sup_company_id)>
										AND S.COMPANY_ID = #attributes.sup_company_id#
									</cfif>
									<cfif len(trim(attributes.employee_name)) and len(attributes.product_employee_id)>
										AND S.PRODUCT_MANAGER = #attributes.product_employee_id#
									</cfif>
									<cfif len(trim(attributes.product_name)) and len(attributes.product_id)>
										AND S.PRODUCT_ID = #attributes.product_id#
									</cfif>
									<cfif len(trim(attributes.brand_name)) and len(attributes.brand_id)>
										AND S.BRAND_ID = #attributes.brand_id# 
									</cfif>	
									<cfif len(trim(attributes.product_cat)) and len(attributes.product_code)>
										AND S.STOCK_CODE LIKE '#attributes.product_code#%'
									</cfif>
								GROUP BY
									SR.UPD_ID,
									S.STOCK_ID,
									S.PRODUCT_ID,
									SR.SPECT_VAR_ID,
									<cfif listfind('2,3,4,5,6,9',attributes.report_type) and isdefined("attributes.location_based_cost")>
										SR.STORE,
										SR.STORE_LOCATION,
									</cfif>
									<cfif attributes.report_type eq 8>
										CAST(SR.STOCK_ID AS NVARCHAR(50))+'_'+CAST(ISNULL(SR.SPECT_VAR_ID,0) AS NVARCHAR(50)),
									</cfif>
									<cfif attributes.report_type eq 9>
										SR.STORE,
									</cfif>
									<cfif attributes.report_type eq 10>
										SR.STORE,
										SR.STORE_LOCATION,
									</cfif>
									S.PRODUCT_MANAGER,
									S.PRODUCT_CATID,
									S.BRAND_ID,
									SR.PROCESS_DATE,
									SR.PROCESS_TYPE) AS GET_STOCK_ROWS
							WHERE
								ISLEM_TARIHI <= #attributes.date2#
								<cfif not len(attributes.department_id) and attributes.report_type neq 9 and attributes.report_type neq 10>
								AND PROCESS_TYPE NOT IN (81,811)
								</cfif>
							GROUP BY
								<cfif listfind('2,3,4,5,6,9',attributes.report_type) and isdefined("attributes.location_based_cost")>
									STORE,
									STORE_LOCATION,
								</cfif>
								<cfif attributes.report_type eq 9 or attributes.report_type eq 10>
								   PRODUCT_ID,
								   #ALAN_ADI#
								<cfelse>
								   #ALAN_ADI#
								</cfif>
							) AS get_total_stok 
	</cfquery>
	<cfquery name="add_index" datasource="workcube_cf_report">
		CREATE UNIQUE CLUSTERED INDEX [GET_TOTAL_STOK_DENEME_1] ON [get_total_stok] 
		(
			[GROUPBY_ALANI] ASC
		)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	</cfquery>
</cfif>


	<!---<cfquery name="GET_ALL_STOCK" datasource="#dsn2#">---><cfoutput><pre>
	SELECT
		<!--- STOCK_CODE
		,ACIKLAMA
		,BARCOD
		,PRODUCT_CODE
		,MANUFACT_CODE
		,MAIN_UNIT
		,DB_STOK_MIKTAR
		,(DB_STOK_MIKTAR*ALL_START_COST)/1 AS STOK_MALIYET_ILK
		,d_alis_miktar.TOPLAM_ALIS 
		,d_alis_iade_miktar.TOPLAM_ALIS_IADE 
		,(d_alis_miktar.TOPLAM_ALIS - d_alis_iade_miktar.TOPLAM_ALIS_IADE) AS TOPLAM_ALIS_MIKTAR_NET_1
		,d_alis_tutar.TOPLAM_ALIS_MALIYET 
		,d_alis_iade_tutar.TOPLAM_ALIS_IADE_MALIYET 
		,(d_alis_tutar.TOPLAM_ALIS_MALIYET - d_alis_iade_tutar.TOPLAM_ALIS_IADE_MALIYET ) AS TOPLAM_ALIS_MALIYET_NET_1
		,d_satis.TOPLAM_SATIS 
		,d_satis_iade.TOPLAM_SATIS_IADE 
		,(d_satis.TOPLAM_SATIS - d_satis_iade.TOPLAM_SATIS_IADE) AS TOPLAM_SATIS_MIKTAR_NET_1 
		,d_satis.TOPLAM_SATIS_MALIYET 
		,d_satis_iade.TOP_SAT_IADE_MALIYET 
		,(d_satis.TOPLAM_SATIS_MALIYET - d_satis_iade.TOP_SAT_IADE_MALIYET) AS TOPLAM_SATIS_MALIYET_NET_1
		,servis_giris.SERVIS_GIRIS_MIKTAR
		,servis_giris.SERVIS_GIRIS_MALIYET
		,servis_cikis.SERVIS_CIKIS_MIKTAR 
		,servis_cikis.SERVIS_CIKIS_MALIYET 
		,rma_giris.RMA_GIRIS_MIKTAR 
		,rma_giris.RMA_GIRIS_MALIYET	
		,rma_cikis.RMA_CIKIS_MIKTAR 
		,rma_cikis.RMA_CIKIS_MALIYET 
		,donemici_uretim.TOPLAM_URETIM 
		,donemici_uretim.URETIM_MALIYET 					
		,donemici_sarf.TOPLAM_SARF 
		,donemici_production_sarf.TOPLAM_URETIM_SARF 
		,donemici_fire.TOPLAM_FIRE
		,donemici_sarf.SARF_MALIYET 
		,donemici_production_sarf.URETIM_SARF_MALIYET 
		,donemici_fire.FIRE_MALIYET 
		,donemici_sayim.TOPLAM_SAYIM 
		,donemici_sayim.SAYIM_MALIYET 
		,donemici_demontaj_giris.DEMONTAJ_GIRIS 
		,donemici_demontaj_giris.DEMONTAJ_GIRIS_MALIYET 
		,demontaj_giden.DEMONTAJ_GIDEN
		,demontaj_giden.DEMONTAJ_GIDEN_MALIYET
		,donemici_masraf.TOPLAM_MASRAF_MIKTAR 
		,donemici_masraf.MASRAF_MALIYET 
		,get_total_stok.TOTAL_STOCK 
		,((get_total_stok.TOTAL_STOCK * GET_ALL_STOCK.ALL_FINISH_COST)/1) AS XXX,
		 KONS_CIKIS_MIKTAR,
		 KONS_CIKIS_MALIYET ,
		 KONS_IADE_MIKTAR,
		 KONS_IADE_MALIYET ,
		 KONS_GIRIS_MIKTAR,
		 KONS_GIRIS_MALIYET ,
		 KONS_GIRIS_IADE_MIKTAR  ,
		 KONS_GIRIS_IADE_MALIYET  ---> 
        GET_ALL_STOCK.STOCK_CODE,
        GET_ALL_STOCK.ACIKLAMA,
       	GET_ALL_STOCK.BARCOD,
        GET_ALL_STOCK.PRODUCT_CODE,
        GET_ALL_STOCK.MANUFACT_CODE,
        MAIN_UNIT ,
        DB_STOK_MIKTAR AS DONEM_BASI_STOK_MIKTARI,
        DB_STOK_MIKTAR * ALL_FINISH_COST AS DONEM_BASI_STOK_MALIYETI,
        DB_STOK_MIKTAR AS DONEM_SONU_STOK_MIKTARI,
        DB_STOK_MIKTAR * ALL_FINISH_COST AS DONEM_SONU_STOK_MALIYETI,
        ALL_FINISH_COST AS DONEM_SONU_BIRIM_MALIYET
        <cfif isdefined("attributes.stock_age") and attributes.stock_age eq 1>
        	,GET_STOCK_AGE.GUN_FARKI
        </cfif> 
           
	 FROM(
			SELECT DISTINCT	
			S.STOCK_CODE,		 
			<cfif attributes.report_type eq 1>
                S.STOCK_ID AS PRODUCT_GROUPBY_ID,
                (S.PRODUCT_NAME + ' ' + ISNULL(S.PROPERTY,'')) ACIKLAMA,
                S.MANUFACT_CODE,
                S.PRODUCT_UNIT_ID,
                PU.MAIN_UNIT,
                PU.DIMENTION,
                S.BARCOD,
                S.PRODUCT_CODE,
                S.STOCK_CODE_2,
            <cfelseif attributes.report_type eq 2>
                S.PRODUCT_ID AS PRODUCT_GROUPBY_ID,
                S.PRODUCT_NAME AS ACIKLAMA,
                S.MANUFACT_CODE,
                PU.MAIN_UNIT,
                PU.DIMENTION,
                S.PRODUCT_BARCOD AS BARCOD,
                S.PRODUCT_CODE,
            <cfelseif attributes.report_type eq 3>
                S.PRODUCT_CATID AS PRODUCT_GROUPBY_ID,
                PC.PRODUCT_CAT AS ACIKLAMA,
            <cfelseif attributes.report_type eq 4>
                S.PRODUCT_MANAGER AS PRODUCT_GROUPBY_ID,
                (EP.EMPLOYEE_NAME + ' ' + EP.EMPLOYEE_SURNAME) AS ACIKLAMA,
            <cfelseif attributes.report_type eq 5>
                 PB.BRAND_ID AS PRODUCT_GROUPBY_ID,
                 PB.BRAND_NAME AS ACIKLAMA,
            <cfelseif attributes.report_type eq 6>
                 S.COMPANY_ID AS PRODUCT_GROUPBY_ID,
                 C.NICKNAME AS ACIKLAMA,
            <cfelseif attributes.report_type eq 9>
                 SR.STORE AS PRODUCT_GROUPBY_ID,
                 D.DEPARTMENT_HEAD AS ACIKLAMA,
            <cfelseif attributes.report_type eq 10>
                 CAST(SR.STORE AS NVARCHAR(50)) +'_'+ CAST(ISNULL(SR.STORE_LOCATION,0) AS NVARCHAR(50)) AS PRODUCT_GROUPBY_ID,
                 D.DEPARTMENT_HEAD+' - '+SL.COMMENT AS ACIKLAMA,
            <cfelseif attributes.report_type eq 8>
                S.STOCK_CODE,
                S.STOCK_ID,
                CAST(S.STOCK_ID AS NVARCHAR(50)) +'_'+ CAST(ISNULL(SR.SPECT_VAR_ID,0) AS NVARCHAR(50)) AS PRODUCT_GROUPBY_ID,
                SR.SPECT_VAR_ID SPECT_VAR_ID,
                <cfif isdefined('x_dsp_spec_name') and x_dsp_spec_name eq 1>
                ISNULL((SELECT SPECT_MAIN_NAME FROM #dsn3_alias#.SPECT_MAIN SP WHERE SP.SPECT_MAIN_ID = SR.SPECT_VAR_ID),'') AS SPECT_NAME,
                </cfif>
                (S.PRODUCT_NAME + ' ' + ISNULL(S.PROPERTY,'')) ACIKLAMA,
                S.MANUFACT_CODE,
                S.PRODUCT_UNIT_ID,
                PU.MAIN_UNIT,
                PU.DIMENTION,
                S.BARCOD,
                S.PRODUCT_CODE,
            </cfif>
                S.PRODUCT_STATUS,
                S.PRODUCT_ID,
                S.IS_PRODUCTION,
                <cfif listfind('2,3,4,5,6,9',attributes.report_type) and isdefined("attributes.location_based_cost")>
                    SL.DEPARTMENT_ID,
                    SL.LOCATION_ID,
                </cfif>
				P.ALL_START_COST,
                P.ALL_START_COST_2,
                ISNULL(P1.ALL_FINISH_COST,0) AS ALL_FINISH_COST,
                P1.ALL_FINISH_COST_2
                <cfif isdefined("attributes.display_cost_money")>
                    ,ISNULL((
                        SELECT TOP 1 
                            <cfif isdefined("attributes.location_based_cost")>
                                PURCHASE_NET_MONEY_LOCATION
                            <cfelse>
                                PURCHASE_NET_MONEY
                            </cfif>
                        FROM 
                            #dsn3_alias#.PRODUCT_COST WITH (NOLOCK) 
                        WHERE 
                            START_DATE <= #start_period_cost_date# 
                            AND PRODUCT_ID = S.PRODUCT_ID
                            <cfif attributes.report_type eq 8>
                                 AND ISNULL(PRODUCT_COST.SPECT_MAIN_ID,0) = ISNULL(SR.SPECT_VAR_ID,0)
                            </cfif>
                           
                            <cfif isdefined("attributes.location_based_cost")>
                                <cfif len(attributes.department_id)>
                                    AND DEPARTMENT_ID = #listgetat(attributes.department_id,1,'-')#
                                    AND LOCATION_ID = #listgetat(attributes.department_id,2,'-')#
                                <cfelse>
                                    AND DEPARTMENT_ID = D.DEPARTMENT_ID
                                    AND LOCATION_ID = SL.LOCATION_ID
                                </cfif>
                            </cfif>
                        ORDER BY 
                            START_DATE DESC, 
                            RECORD_DATE DESC,
                            PRODUCT_COST_ID DESC
                    ),'') ALL_START_MONEY,
                    ISNULL((
                        SELECT TOP 1 
                            <cfif isdefined("attributes.location_based_cost")>
                                PURCHASE_NET_MONEY_LOCATION
                            <cfelse>
                                PURCHASE_NET_MONEY
                            </cfif>
                        FROM 
                            #dsn3_alias#.PRODUCT_COST WITH (NOLOCK) 
                        WHERE 
                            START_DATE <= #finish_date# 
                            AND PRODUCT_ID = S.PRODUCT_ID
                            <cfif attributes.report_type eq 8>
                                 AND ISNULL(PRODUCT_COST.SPECT_MAIN_ID,0) = ISNULL(SR.SPECT_VAR_ID,0)
                            </cfif>
                           
                            <cfif isdefined("attributes.location_based_cost")>
                                <cfif len(attributes.department_id)>
                                    AND DEPARTMENT_ID = #listgetat(attributes.department_id,1,'-')#
                                    AND LOCATION_ID = #listgetat(attributes.department_id,2,'-')#
                                <cfelse>
                                    AND DEPARTMENT_ID = D.DEPARTMENT_ID
                                    AND LOCATION_ID = SL.LOCATION_ID
                                </cfif>
                            </cfif>
                        ORDER BY 
                            START_DATE DESC, 
                            RECORD_DATE DESC,
                            PRODUCT_COST_ID DESC
                    ),'') ALL_FINISH_MONEY
                </cfif>
            FROM        
                STOCKS_ROW AS SR WITH (NOLOCK),
                #dsn3_alias#.STOCKS S WITH (NOLOCK)
				OUTER APPLY
				(
                    SELECT TOP 1
                        <cfif isdefined("attributes.location_based_cost")>
                            <cfif isdefined("attributes.display_cost_money")>
                                (PURCHASE_NET_LOCATION+PURCHASE_EXTRA_COST_LOCATION) AS ALL_START_COST,
                            <cfelse>
                                (PURCHASE_NET_SYSTEM_LOCATION+PURCHASE_EXTRA_COST_SYSTEM_LOCATION) AS ALL_START_COST,
                            </cfif>
                        <cfelse>
                            <cfif isdefined("attributes.display_cost_money")>
                                (PURCHASE_NET+PURCHASE_EXTRA_COST) AS ALL_START_COST,
                            <cfelse>
                                (PURCHASE_NET_SYSTEM+PURCHASE_EXTRA_COST_SYSTEM) AS ALL_START_COST,
                            </cfif>	
                        </cfif>
						 <cfif isdefined("attributes.location_based_cost")>
                            (PURCHASE_NET_SYSTEM_2_LOCATION+PURCHASE_EXTRA_COST_SYSTEM_2_LOCATION) AS ALL_START_COST_2
                        <cfelse>
                            (PURCHASE_NET_SYSTEM_2+PURCHASE_EXTRA_COST_SYSTEM_2) AS ALL_START_COST_2
                        </cfif>
                    FROM 
                        #dsn3_alias#.PRODUCT_COST WITH (NOLOCK)
                    WHERE 
                        START_DATE <= #start_period_cost_date# 
                        AND PRODUCT_ID = S.PRODUCT_ID
                        <cfif attributes.report_type eq 8>
                             AND ISNULL(PRODUCT_COST.SPECT_MAIN_ID,0) = ISNULL(SR.SPECT_VAR_ID,0)
                        </cfif>
                        <cfif isdefined("attributes.location_based_cost")>
                            <cfif len(attributes.department_id)>
                                AND DEPARTMENT_ID = #listgetat(attributes.department_id,1,'-')#
                                AND LOCATION_ID = #listgetat(attributes.department_id,2,'-')#
                            <cfelse>
                                AND DEPARTMENT_ID = D.DEPARTMENT_ID
                                AND LOCATION_ID = SL.LOCATION_ID
                            </cfif>
                        </cfif>
                    ORDER BY 
                        START_DATE DESC, 
                        RECORD_DATE DESC,
                        PRODUCT_COST_ID DESC
				) AS P
				OUTER APPLY
				(
                    SELECT TOP 1 
                        <cfif isdefined("attributes.location_based_cost")>
                            <cfif isdefined("attributes.display_cost_money")>
                                (PURCHASE_NET_LOCATION+PURCHASE_EXTRA_COST_LOCATION) AS ALL_FINISH_COST,
                            <cfelse>
                                (PURCHASE_NET_SYSTEM_LOCATION+PURCHASE_EXTRA_COST_SYSTEM_LOCATION) AS ALL_FINISH_COST,
                            </cfif>
                        <cfelse>
                            <cfif isdefined("attributes.display_cost_money")>
                                (PURCHASE_NET+PURCHASE_EXTRA_COST) AS ALL_FINISH_COST,
                            <cfelse>
                                (PURCHASE_NET_SYSTEM+PURCHASE_EXTRA_COST_SYSTEM) AS ALL_FINISH_COST,
                            </cfif>	
                        </cfif>
						<cfif isdefined("attributes.location_based_cost")>
                            (PURCHASE_NET_SYSTEM_2_LOCATION+PURCHASE_EXTRA_COST_SYSTEM_2_LOCATION) AS ALL_FINISH_COST_2
                        <cfelse>
                            (PURCHASE_NET_SYSTEM_2+PURCHASE_EXTRA_COST_SYSTEM_2) AS ALL_FINISH_COST_2
                        </cfif>
                    FROM 
                        #dsn3_alias#.PRODUCT_COST WITH (NOLOCK) 
                    WHERE 
                        START_DATE <= #finish_date# 
                        AND PRODUCT_ID = S.PRODUCT_ID
                        <cfif attributes.report_type eq 8>
                             AND ISNULL(PRODUCT_COST.SPECT_MAIN_ID,0) = ISNULL(SR.SPECT_VAR_ID,0)
                        </cfif>
              
                        <cfif isdefined("attributes.location_based_cost")>
                            <cfif len(attributes.department_id)>
                                AND DEPARTMENT_ID = #listgetat(attributes.department_id,1,'-')#
                                AND LOCATION_ID = #listgetat(attributes.department_id,2,'-')#
                            <cfelse>
                                AND DEPARTMENT_ID = D.DEPARTMENT_ID
                                AND LOCATION_ID = SL.LOCATION_ID
                            </cfif>
                        </cfif>
                    ORDER BY 
                        START_DATE DESC, 
                        RECORD_DATE DESC,
                        PRODUCT_COST_ID DESC
				) AS P1,
                #dsn3_alias#.PRODUCT_UNIT PU WITH (NOLOCK)
            <cfif attributes.report_type eq 3>
                ,#dsn3_alias#.PRODUCT_CAT PC WITH (NOLOCK)
            <cfelseif attributes.report_type eq 4>
                ,#dsn_alias#.EMPLOYEE_POSITIONS EP WITH (NOLOCK)
            <cfelseif attributes.report_type eq 5>
                ,#dsn3_alias#.PRODUCT_BRANDS PB WITH (NOLOCK)
            <cfelseif attributes.report_type eq 6>
                 ,#dsn_alias#.COMPANY C WITH (NOLOCK)
            <cfelseif attributes.report_type eq 9>
                 ,#dsn_alias#.DEPARTMENT D WITH (NOLOCK)
            <cfelseif attributes.report_type eq 10>
                 ,#dsn_alias#.DEPARTMENT D WITH (NOLOCK)
                 ,#dsn_alias#.STOCKS_LOCATION SL WITH (NOLOCK)
            </cfif>
            <cfif listfind('2,3,4,5,6,9',attributes.report_type) and isdefined("attributes.location_based_cost")>
                <cfif attributes.report_type neq 9>
                     ,#dsn_alias#.DEPARTMENT D WITH (NOLOCK)
                </cfif>
                 ,#dsn_alias#.STOCKS_LOCATION SL WITH (NOLOCK)
            </cfif>
            WHERE
                SR.STOCK_ID=S.STOCK_ID
                <cfif attributes.report_type neq 9>
                    <cfif len(attributes.department_id)>
                        AND
                            (
                            <cfloop list="#attributes.department_id#" delimiters="," index="dept_i">
                            (SR.STORE = #listfirst(dept_i,'-')# AND SR.STORE_LOCATION = #listlast(dept_i,'-')#)
                            <cfif dept_i neq listlast(attributes.department_id,',') and listlen(attributes.department_id,',') gte 1> OR</cfif>
                            </cfloop>  
                            )
                    <cfelseif is_store>
                        AND	SR.STORE IN (#branch_dep_list#)
                    </cfif>
                <cfelse>
                    <cfif len(attributes.department_id_new)>
                        AND SR.STORE IN (#attributes.department_id_new#)
                    <cfelseif is_store>
                        AND	SR.STORE IN (#branch_dep_list#)
                    </cfif>	
                </cfif>
                <cfif len(attributes.product_status)>AND S.PRODUCT_STATUS = #attributes.product_status#</cfif>
                AND S.PRODUCT_ID=PU.PRODUCT_ID
                AND S.PRODUCT_UNIT_ID=PU.PRODUCT_UNIT_ID
            <cfif isdefined('attributes.is_envantory')>
                AND S.IS_INVENTORY=1
            </cfif>
            <cfif attributes.report_type eq 3>
                AND PC.PRODUCT_CATID = S.PRODUCT_CATID
            <cfelseif attributes.report_type eq 4>
                AND EP.POSITION_CODE = S.PRODUCT_MANAGER
            <cfelseif attributes.report_type eq 5>
                AND PB.BRAND_ID=S.BRAND_ID
            <cfelseif attributes.report_type eq 6>
                AND S.COMPANY_ID=C.COMPANY_ID
            <cfelseif attributes.report_type eq 9>
                AND SR.STORE=D.DEPARTMENT_ID
            <cfelseif attributes.report_type eq 10>
                AND SR.STORE=D.DEPARTMENT_ID
                AND SR.STORE=SL.DEPARTMENT_ID
                AND SR.STORE_LOCATION=SL.LOCATION_ID
            </cfif>
            <cfif listfind('2,3,4,5,6,9',attributes.report_type) and isdefined("attributes.location_based_cost")>
                AND SR.STORE=D.DEPARTMENT_ID
                AND SR.STORE=SL.DEPARTMENT_ID
                AND SR.STORE_LOCATION=SL.LOCATION_ID
            </cfif>
            <cfif len(trim(attributes.sup_company)) and len(attributes.sup_company_id)>
                AND S.COMPANY_ID = #attributes.sup_company_id#
            </cfif>
            <cfif len(trim(attributes.employee_name)) and len(attributes.product_employee_id)>
                AND S.PRODUCT_MANAGER = #attributes.product_employee_id#
            </cfif>
            <cfif len(trim(attributes.product_name)) and len(attributes.product_id)>
                AND S.PRODUCT_ID = #attributes.product_id#
            </cfif>
            <cfif len(trim(attributes.brand_name)) and len(attributes.brand_id)>
                AND S.BRAND_ID = #attributes.brand_id# 
            </cfif>	
            <cfif len(trim(attributes.product_cat)) and len(attributes.product_code)>
                AND S.STOCK_CODE LIKE '#attributes.product_code#%'
            </cfif>
            <cfif listfind('1,2,3,4,5,6,8,9,10',attributes.report_type,',') and ((isdefined('attributes.control_total_stock') and len(attributes.control_total_stock)) or isdefined('attributes.is_stock_action'))><!--- sadece pozitif stoklar veya sadece hareket gormus stokların gelmesi --->
                AND <cfif attributes.report_type eq 8>(CAST(S.STOCK_ID AS NVARCHAR(50)) +'_'+ CAST(ISNULL(SR.SPECT_VAR_ID,0) AS NVARCHAR(50)))<cfelse>S.STOCK_ID</cfif>
                <cfif isdefined('attributes.control_total_stock') and attributes.control_total_stock eq 0 and not isdefined('attributes.is_stock_action')>
                    NOT IN
                <cfelse>
                    IN
                </cfif>
                    (
                    SELECT   
                        <cfif attributes.report_type eq 8>
                        (CAST(SR.STOCK_ID AS NVARCHAR(50)) +'_'+ CAST(ISNULL(SR.SPECT_VAR_ID,0) AS NVARCHAR(50))) <!--- spec bazında stok durumu kontrol ediliyor --->
                        <cfelse>
                        SR.STOCK_ID
                        </cfif>
                    FROM        
                        STOCKS_ROW SR WITH (NOLOCK),
                        #dsn_alias#.STOCKS_LOCATION SL
                    WHERE
                        SR.STORE = SL.DEPARTMENT_ID
                        AND SR.STORE_LOCATION=SL.LOCATION_ID
                        <cfif isdefined('attributes.is_stock_action')>
                        AND SR.UPD_ID IS NOT NULL
                        </cfif>
                        <cfif not isdefined('is_belognto_institution')>
                        AND SL.BELONGTO_INSTITUTION = 0
                        </cfif>
                        AND SR.PROCESS_DATE <= #attributes.date2#	
                         <cfif attributes.report_type neq 9>
                            <cfif len(attributes.department_id)>
                                AND
                                    (
                                    <cfloop list="#attributes.department_id#" delimiters="," index="dept_i">
                                    (SR.STORE = #listfirst(dept_i,'-')# AND SR.STORE_LOCATION = #listlast(dept_i,'-')#)
                                    <cfif dept_i neq listlast(attributes.department_id,',') and listlen(attributes.department_id,',') gte 1> OR</cfif>
                                    </cfloop>  
                                    )
                            <cfelseif is_store>
                                AND	SR.STORE IN (#branch_dep_list#)
                            </cfif>
                        <cfelse>
                            <cfif len(attributes.department_id_new)>
                                AND SR.STORE IN (#attributes.department_id_new#)
                            <cfelseif is_store>
                                AND	SR.STORE IN (#branch_dep_list#)
                            </cfif>	
                        </cfif>
                        <cfif isdefined('attributes.control_total_stock') and len(attributes.control_total_stock)>
                            GROUP BY STOCK_ID
                            <cfif attributes.report_type eq 8>
                            ,ISNULL(SR.SPECT_VAR_ID,0)
                            ,SR.SPECT_VAR_ID
                            </cfif>
                            <cfif attributes.control_total_stock eq 0> <!--- sıfır stok --->
                                <cfif not isdefined('attributes.is_stock_action')>
                                    HAVING round((SUM(STOCK_IN)-SUM(STOCK_OUT)),2) <> 0
                                <cfelse>
                                    HAVING round((SUM(STOCK_IN)-SUM(STOCK_OUT)),2) = 0
                                </cfif>
                            <cfelseif attributes.control_total_stock eq 1> <!--- pozitif stok --->
                                HAVING round((SUM(STOCK_IN)-SUM(STOCK_OUT)),2) > 0
                            <cfelseif attributes.control_total_stock eq 2> <!--- negatif stok --->
                                HAVING round((SUM(STOCK_IN)-SUM(STOCK_OUT)),2) < 0
                            </cfif>
                        </cfif>
                    )
            </cfif>
        ) AS GET_ALL_STOCK
<cfif attributes.report_type neq 7>        
	LEFT JOIN (
                SELECT	
                    SUM(AMOUNT) AS DB_STOK_MIKTAR,
                    SUM(AMOUNT*MALIYET) AS DB_STOK_MALIYET,
                    <cfif isdefined('attributes.is_system_money_2')>
                    SUM(AMOUNT*MALIYET_2) AS DB_STOK_MALIYET_2,
                    </cfif>
                    #ALAN_ADI# AS GROUPBY_ALANI
                FROM
					(
                    SELECT 
                        SR.UPD_ID,
                        S.STOCK_ID,
                        S.PRODUCT_ID,
                        <cfif listfind('2,3,4,5,6,9',attributes.report_type) and isdefined("attributes.location_based_cost")>
                            SR.STORE,
                            SR.STORE_LOCATION,
                        </cfif>
                        <cfif attributes.report_type eq 9>
                            SR.STORE,
                        </cfif>
                        <cfif attributes.report_type eq 10>
                            CAST(SR.STORE AS NVARCHAR(50)) +'_'+ CAST(ISNULL(SR.STORE_LOCATION,0) AS NVARCHAR(50)) STORE_LOCATION,
                        </cfif>
                        SR.SPECT_VAR_ID SPECT_VAR_ID,
                        <cfif attributes.report_type eq 8>
                            CAST(SR.STOCK_ID AS NVARCHAR(50))+'_'+CAST(ISNULL(SR.SPECT_VAR_ID,0) AS NVARCHAR(50)) AS STOCK_SPEC_ID,
                        </cfif>
                        S.PRODUCT_MANAGER,
                        S.PRODUCT_CATID,
                        S.BRAND_ID,
                        SUM(SR.STOCK_IN-SR.STOCK_OUT) AMOUNT,
                        SR.PROCESS_DATE ISLEM_TARIHI,
                        SR.PROCESS_TYPE,
                        0 AS MALIYET
                        <cfif isdefined('attributes.is_system_money_2')>
                        ,0 AS MALIYET_2
                        </cfif>
                    FROM        
                        STOCKS_ROW SR WITH (NOLOCK),
                        #dsn3_alias#.STOCKS S WITH (NOLOCK),
                        #dsn_alias#.STOCKS_LOCATION SL WITH (NOLOCK)
                    WHERE
                        SR.STOCK_ID=S.STOCK_ID
                        AND SR.STORE = SL.DEPARTMENT_ID
                        AND SR.STORE_LOCATION=SL.LOCATION_ID
                        <cfif not isdefined('is_belognto_institution')>
                        AND SL.BELONGTO_INSTITUTION = 0
                        </cfif>
                        AND SR.PROCESS_DATE <= #attributes.date2#	
                        <cfif len(attributes.department_id)>
                        AND
                            (
                            <cfloop list="#attributes.department_id#" delimiters="," index="dept_i">
                            (SR.STORE = #listfirst(dept_i,'-')# AND SR.STORE_LOCATION = #listlast(dept_i,'-')#)
                            <cfif dept_i neq listlast(attributes.department_id,',') and listlen(attributes.department_id,',') gte 1> OR</cfif>
                            </cfloop>  
                            )
                        <cfelseif is_store>
                            AND SR.STORE IN (#branch_dep_list#)
                        </cfif>
                        <cfif len(trim(attributes.sup_company)) and len(attributes.sup_company_id)>
                            AND S.COMPANY_ID = #attributes.sup_company_id#
                        </cfif>
                        <cfif len(trim(attributes.employee_name)) and len(attributes.product_employee_id)>
                            AND S.PRODUCT_MANAGER = #attributes.product_employee_id#
                        </cfif>
                        <cfif len(trim(attributes.product_name)) and len(attributes.product_id)>
                            AND S.PRODUCT_ID = #attributes.product_id#
                        </cfif>
                        <cfif len(trim(attributes.brand_name)) and len(attributes.brand_id)>
                            AND S.BRAND_ID = #attributes.brand_id# 
                        </cfif>	
                        <cfif len(trim(attributes.product_cat)) and len(attributes.product_code)>
                            AND S.STOCK_CODE LIKE '#attributes.product_code#%'
                        </cfif>
                    GROUP BY
                        SR.UPD_ID,
                        S.STOCK_ID,
                        S.PRODUCT_ID,
                        SR.SPECT_VAR_ID,
                        <cfif listfind('2,3,4,5,6,9',attributes.report_type) and isdefined("attributes.location_based_cost")>
                            SR.STORE,
                            SR.STORE_LOCATION,
                        </cfif>
                        <cfif attributes.report_type eq 8>
                            CAST(SR.STOCK_ID AS NVARCHAR(50))+'_'+CAST(ISNULL(SR.SPECT_VAR_ID,0) AS NVARCHAR(50)),
                        </cfif>
                        <cfif attributes.report_type eq 9>
                            SR.STORE,
                        </cfif>
                        <cfif attributes.report_type eq 10>
                            SR.STORE,
                            SR.STORE_LOCATION,
                        </cfif>
                        S.PRODUCT_MANAGER,
                        S.PRODUCT_CATID,
                        S.BRAND_ID,
                        SR.PROCESS_DATE,
                        SR.PROCESS_TYPE) AS GET_STOCK_ROWS
                WHERE
                <cfif attributes.date is '01/01/#session.ep.period_year#'>
                    ISLEM_TARIHI <= #attributes.date#
                    AND PROCESS_TYPE = 114
                <cfelse>
                    (
                        (
                        ISLEM_TARIHI <= #DATEADD('d',-1,attributes.date)#
                        <cfif not len(attributes.department_id)>
                            AND PROCESS_TYPE NOT IN (81,811)
                        </cfif>
                        )
                        OR
                        (
                        ISLEM_TARIHI = #attributes.date#
                        AND PROCESS_TYPE = 114
                        )
                    )
                </cfif>
                GROUP BY
                    #ALAN_ADI#
                ) AS acilis_stok2 ON GET_ALL_STOCK.PRODUCT_GROUPBY_ID = acilis_stok2.GROUPBY_ALANI
<!--- 1 --->                
                
    LEFT JOIN 
			<cfif attributes.report_type eq 2 >
			 	workcube_cf_report.get_total_stok	ON GET_ALL_STOCK.PRODUCT_GROUPBY_ID = get_total_stok.GROUPBY_ALANI
			<cfelse>
				(
					SELECT 
						SUM(AMOUNT) AS TOTAL_STOCK,
						SUM(AMOUNT*MALIYET) AS TOTAL_PRODUCT_COST,
						<cfif isdefined('attributes.is_system_money_2')>
						SUM(AMOUNT*MALIYET_2) AS TOTAL_PRODUCT_COST_2,
						</cfif>
						<cfif listfind('2,3,4,5,6,9',attributes.report_type) and isdefined("attributes.location_based_cost")>
							STORE,
							STORE_LOCATION,
						</cfif>
						<cfif attributes.report_type eq 9 or attributes.report_type eq 10>
						   PRODUCT_ID AS GROUPBY_ALANI,
						   #ALAN_ADI# AS GROUPBY_ALANI_2
						<cfelse>
						   #ALAN_ADI# AS GROUPBY_ALANI
						</cfif>
					FROM
						(
						SELECT 
							SR.UPD_ID,
							S.STOCK_ID,
							S.PRODUCT_ID,
							<cfif listfind('2,3,4,5,6,9',attributes.report_type) and isdefined("attributes.location_based_cost")>
								SR.STORE,
								SR.STORE_LOCATION,
							</cfif>
							<cfif attributes.report_type eq 9>
								SR.STORE,
							</cfif>
							<cfif attributes.report_type eq 10>
								CAST(SR.STORE AS NVARCHAR(50)) +'_'+ CAST(ISNULL(SR.STORE_LOCATION,0) AS NVARCHAR(50)) STORE_LOCATION,
							</cfif>
							SR.SPECT_VAR_ID SPECT_VAR_ID,
							<cfif attributes.report_type eq 8>
								CAST(SR.STOCK_ID AS NVARCHAR(50))+'_'+CAST(ISNULL(SR.SPECT_VAR_ID,0) AS NVARCHAR(50)) AS STOCK_SPEC_ID,
							</cfif>
							S.PRODUCT_MANAGER,
							S.PRODUCT_CATID,
							S.BRAND_ID,
							SUM(SR.STOCK_IN-SR.STOCK_OUT) AMOUNT,
							SR.PROCESS_DATE ISLEM_TARIHI,
							SR.PROCESS_TYPE,
							0 AS MALIYET
							<cfif isdefined('attributes.is_system_money_2')>
							,0 AS MALIYET_2
							</cfif>
						FROM        
							STOCKS_ROW SR WITH (NOLOCK),
							#dsn3_alias#.STOCKS S WITH (NOLOCK),
							#dsn_alias#.STOCKS_LOCATION SL WITH (NOLOCK)
						WHERE
							SR.STOCK_ID=S.STOCK_ID
							AND SR.STORE = SL.DEPARTMENT_ID
							AND SR.STORE_LOCATION=SL.LOCATION_ID
							<cfif not isdefined('is_belognto_institution')>
							AND SL.BELONGTO_INSTITUTION = 0
							</cfif>
							AND SR.PROCESS_DATE <= #attributes.date2#	
							<cfif len(attributes.department_id)>
							AND
								(
								<cfloop list="#attributes.department_id#" delimiters="," index="dept_i">
								(SR.STORE = #listfirst(dept_i,'-')# AND SR.STORE_LOCATION = #listlast(dept_i,'-')#)
								<cfif dept_i neq listlast(attributes.department_id,',') and listlen(attributes.department_id,',') gte 1> OR</cfif>
								</cfloop>  
								)
							<cfelseif is_store>
								AND SR.STORE IN (#branch_dep_list#)
							</cfif>
							<cfif len(trim(attributes.sup_company)) and len(attributes.sup_company_id)>
								AND S.COMPANY_ID = #attributes.sup_company_id#
							</cfif>
							<cfif len(trim(attributes.employee_name)) and len(attributes.product_employee_id)>
								AND S.PRODUCT_MANAGER = #attributes.product_employee_id#
							</cfif>
							<cfif len(trim(attributes.product_name)) and len(attributes.product_id)>
								AND S.PRODUCT_ID = #attributes.product_id#
							</cfif>
							<cfif len(trim(attributes.brand_name)) and len(attributes.brand_id)>
								AND S.BRAND_ID = #attributes.brand_id# 
							</cfif>	
							<cfif len(trim(attributes.product_cat)) and len(attributes.product_code)>
								AND S.STOCK_CODE LIKE '#attributes.product_code#%'
							</cfif>
						GROUP BY
							SR.UPD_ID,
							S.STOCK_ID,
							S.PRODUCT_ID,
							SR.SPECT_VAR_ID,
							<cfif listfind('2,3,4,5,6,9',attributes.report_type) and isdefined("attributes.location_based_cost")>
								SR.STORE,
								SR.STORE_LOCATION,
							</cfif>
							<cfif attributes.report_type eq 8>
								CAST(SR.STOCK_ID AS NVARCHAR(50))+'_'+CAST(ISNULL(SR.SPECT_VAR_ID,0) AS NVARCHAR(50)),
							</cfif>
							<cfif attributes.report_type eq 9>
								SR.STORE,
							</cfif>
							<cfif attributes.report_type eq 10>
								SR.STORE,
								SR.STORE_LOCATION,
							</cfif>
							S.PRODUCT_MANAGER,
							S.PRODUCT_CATID,
							S.BRAND_ID,
							SR.PROCESS_DATE,
							SR.PROCESS_TYPE) AS GET_STOCK_ROWS
					WHERE
						ISLEM_TARIHI <= #attributes.date2#
						<cfif not len(attributes.department_id) and attributes.report_type neq 9 and attributes.report_type neq 10>
						AND PROCESS_TYPE NOT IN (81,811)
						</cfif>
					GROUP BY
						<cfif listfind('2,3,4,5,6,9',attributes.report_type) and isdefined("attributes.location_based_cost")>
							STORE,
							STORE_LOCATION,
						</cfif>
						<cfif attributes.report_type eq 9 or attributes.report_type eq 10>
						   PRODUCT_ID,
						   #ALAN_ADI#
						<cfelse>
						   #ALAN_ADI#
						</cfif>
					) AS get_total_stok ON GET_ALL_STOCK.PRODUCT_GROUPBY_ID = get_total_stok.GROUPBY_ALANI
				
		</cfif>		
<!--- 2 --->
	<cfif listfind('1,2,8',attributes.report_type)>
    	<cfif len(attributes.process_type) and listfind(attributes.process_type,2)>
		<!---Dönem İçi Alış Miktar : Yurtiçi ve Yurtdışı Mal alım irsaliyelerindeki toplam miktar (Demirbaş, Konsinye, İade olmayacak)  --->
        	LEFT JOIN(
                        SELECT	
                            SUM(AMOUNT) AS TOPLAM_ALIS,
                            SUM(TOTAL_COST) AS TOPLAM_ALIS_MALIYET,
                            <cfif isdefined('attributes.is_system_money_2')>
                            SUM(TOTAL_COST_2) AS TOPLAM_ALIS_MALIYET_2,
                            </cfif>
                            #ALAN_ADI# AS GROUPBY_ALANI
                        FROM
                            (
                                SELECT
										GC.STOCK_ID,
										GC.PRODUCT_ID,
										<cfif attributes.report_type eq 8>
										CAST(GC.STOCK_ID AS NVARCHAR(50)) +'_'+ CAST(ISNULL(GC.SPECT_VAR_ID,0) AS NVARCHAR(50)) STOCK_SPEC_ID,
										</cfif>
										1 AS INVOICE_CAT,
										<cfif stock_table>
										S.PRODUCT_MANAGER,
										S.PRODUCT_CATID,
										S.BRAND_ID,
										</cfif>
										<cfif isdefined('attributes.is_system_money_2')>
										GC.MALIYET_2,
										GC.MALIYET,
										((GC.MALIYET_2*ABS(GC.STOCK_IN-GC.STOCK_OUT))) AS TOTAL_COST_2,
										(GC.MALIYET*ABS(GC.STOCK_IN-GC.STOCK_OUT)) AS TOTAL_COST,
										<cfelse>
											<cfif attributes.cost_money is not session.ep.money>
											(GC.MALIYET/(SM.RATE2/SM.RATE1)) AS MALIYET,
											((GC.MALIYET*ABS(GC.STOCK_IN-GC.STOCK_OUT))/(SM.RATE2/SM.RATE1)) AS TOTAL_COST,
											<cfelse>
											GC.MALIYET,
											(GC.MALIYET*ABS(GC.STOCK_IN-GC.STOCK_OUT)) AS TOTAL_COST,				
											</cfif>
										</cfif>
										ABS(GC.STOCK_IN-GC.STOCK_OUT) AS AMOUNT,
										GC.STOCK_IN,
										GC.STOCK_OUT,
										GC.PROCESS_DATE ISLEM_TARIHI,
										GC.PROCESS_TYPE PROCESS_TYPE,
										ISNULL(ABS(GC.STOCK_IN-GC.STOCK_OUT)*(
											SELECT TOP 1 
												<cfif isdefined("attributes.location_based_cost")>
													<cfif isdefined("attributes.display_cost_money")>
														(PURCHASE_NET_LOCATION+PURCHASE_EXTRA_COST_LOCATION)
													<cfelse>
														(PURCHASE_NET_SYSTEM_LOCATION+PURCHASE_EXTRA_COST_SYSTEM_LOCATION)
													</cfif>
												<cfelse>
													<cfif isdefined("attributes.display_cost_money")>
														(PURCHASE_NET+PURCHASE_EXTRA_COST)
													<cfelse>
														(PURCHASE_NET_SYSTEM+PURCHASE_EXTRA_COST_SYSTEM)
													</cfif>	
												</cfif>
											FROM 
												#dsn3_alias#.PRODUCT_COST WITH (NOLOCK) 
											WHERE 
												START_DATE <= #finish_date# 
												AND PRODUCT_ID = GC.PRODUCT_ID
												<cfif attributes.report_type eq 8>
													 AND ISNULL(PRODUCT_COST.SPECT_MAIN_ID,0) = ISNULL(GC.SPECT_VAR_ID,0)
												</cfif>
												<cfif session.ep.our_company_info.is_stock_based_cost eq 1 and attributes.report_type neq 2>
													AND PRODUCT_COST.STOCK_ID = GC.STOCK_ID 
												</cfif>
												<cfif isdefined("attributes.location_based_cost")>
													<cfif len(attributes.department_id)>
														AND DEPARTMENT_ID = #listgetat(attributes.department_id,1,'-')#
														AND LOCATION_ID = #listgetat(attributes.department_id,2,'-')#
													<cfelse>
														AND DEPARTMENT_ID = SL.DEPARTMENT_ID
														AND LOCATION_ID = SL.LOCATION_ID
													</cfif>
												</cfif>
											ORDER BY 
												START_DATE DESC, 
												RECORD_DATE DESC,
												PRODUCT_COST_ID DESC
										),0) ALL_FINISH_COST,
										ISNULL(ABS(GC.STOCK_IN-GC.STOCK_OUT)*(
											SELECT TOP 1 
												<cfif isdefined("attributes.location_based_cost")>
													(PURCHASE_NET_SYSTEM_2_LOCATION+PURCHASE_EXTRA_COST_SYSTEM_2_LOCATION)
												<cfelse>
													(PURCHASE_NET_SYSTEM_2+PURCHASE_EXTRA_COST_SYSTEM_2)
												</cfif>
											FROM 
												#dsn3_alias#.PRODUCT_COST WITH (NOLOCK) 
											WHERE 
												START_DATE <= #finish_date# 
												AND PRODUCT_ID = GC.PRODUCT_ID
												<cfif attributes.report_type eq 8>
													 AND ISNULL(PRODUCT_COST.SPECT_MAIN_ID,0) = ISNULL(GC.SPECT_VAR_ID,0)
												</cfif>
												<cfif session.ep.our_company_info.is_stock_based_cost eq 1 and attributes.report_type neq 2>
													AND PRODUCT_COST.STOCK_ID = GC.STOCK_ID 
												</cfif>
												<cfif isdefined("attributes.location_based_cost")>
													<cfif len(attributes.department_id)>
														AND DEPARTMENT_ID = #listgetat(attributes.department_id,1,'-')#
														AND LOCATION_ID = #listgetat(attributes.department_id,2,'-')#
													<cfelse>
														AND DEPARTMENT_ID = SL.DEPARTMENT_ID
														AND LOCATION_ID = SL.LOCATION_ID
													</cfif>
												</cfif>
											ORDER BY 
												START_DATE DESC, 
												RECORD_DATE DESC,
												PRODUCT_COST_ID DESC
										),0) ALL_FINISH_COST_2
									FROM
										<cfif is_store or isdefined("attributes.location_based_cost")>
											<cfif attributes.report_type eq 8>
												GET_STOCKS_ROW_COST_SPECT_LOCATION AS GC,
											<cfelse>
												GET_STOCKS_ROW_COST_LOCATION AS GC,
											</cfif>
										<cfelse>
											<cfif attributes.report_type eq 8>
												GET_STOCKS_ROW_COST_SPECT AS GC,
											<cfelse>
												GET_STOCK_ROW_COST_TABLE AS GC,
											</cfif>
										</cfif>
										<cfif attributes.cost_money is not session.ep.money or isdefined('attributes.is_system_money_2') or listfind(attributes.process_type,3)>
										SHIP WITH (NOLOCK),	
										</cfif>
										<cfif attributes.cost_money is not session.ep.money or isdefined('attributes.is_system_money_2')>
										SHIP_MONEY SM,
										</cfif>
										<cfif stock_table>
										#dsn3_alias#.STOCKS S,
										</cfif>
										#dsn_alias#.STOCKS_LOCATION SL
									WHERE
										GC.STORE = SL.DEPARTMENT_ID
										AND GC.STORE_LOCATION=SL.LOCATION_ID
										<cfif not isdefined('is_belognto_institution')>
										AND SL.BELONGTO_INSTITUTION = 0
										</cfif>
										<cfif attributes.cost_money is not session.ep.money or isdefined('attributes.is_system_money_2') or listfind(attributes.process_type,3)>
										AND GC.UPD_ID = SHIP.SHIP_ID
										AND SHIP.SHIP_TYPE = GC.PROCESS_TYPE
										AND ISNULL(SHIP.IS_WITH_SHIP,0)=0
										</cfif>
										<cfif attributes.cost_money is not session.ep.money or isdefined('attributes.is_system_money_2')>
										AND SHIP.SHIP_ID = SM.ACTION_ID
											<cfif isdefined('attributes.is_system_money_2')>
												AND SM.MONEY_TYPE = '#session.ep.money2#'
											<cfelse>
												AND SM.MONEY_TYPE = '#attributes.cost_money#'
											</cfif>
										</cfif>
										AND GC.PROCESS_DATE >= #attributes.date#
										AND GC.PROCESS_DATE <= #attributes.date2#
										<cfif len(attributes.department_id)>
										AND
											(
											<cfloop list="#attributes.department_id#" delimiters="," index="dept_i">
											(GC.STORE = #listfirst(dept_i,'-')# AND GC.STORE_LOCATION = #listlast(dept_i,'-')#)
											<cfif dept_i neq listlast(attributes.department_id,',') and listlen(attributes.department_id,',') gte 1> OR</cfif>
											</cfloop>  
											)
										<cfelseif is_store>
											AND GC.STORE IN (#branch_dep_list#)
										</cfif>
										<cfif stock_table>
										AND	GC.STOCK_ID=S.STOCK_ID
										</cfif>
										<cfif len(trim(attributes.sup_company)) and len(attributes.sup_company_id)>
										AND S.COMPANY_ID = #attributes.sup_company_id#
										</cfif>
										<cfif len(trim(attributes.employee_name)) and len(attributes.product_employee_id)>
										AND S.PRODUCT_MANAGER = #attributes.product_employee_id#
										</cfif>
										<cfif len(trim(attributes.product_name)) and len(attributes.product_id)>
										AND S.PRODUCT_ID = #attributes.product_id#
										</cfif>
										<cfif len(trim(attributes.brand_name)) and len(attributes.brand_id)>
										AND S.BRAND_ID = #attributes.brand_id# 
										</cfif>	
										<cfif len(trim(attributes.product_cat)) and len(attributes.product_code)>
										AND S.STOCK_CODE LIKE '#attributes.product_code#%'
										</cfif>
								<cfif attributes.cost_money is not session.ep.money or listfind(attributes.process_type,3)>
								UNION ALL
									SELECT
										GC.STOCK_ID,
										GC.PRODUCT_ID,
										<cfif attributes.report_type eq 8>
										CAST(GC.STOCK_ID AS NVARCHAR(50)) +'_'+ CAST(ISNULL(GC.SPECT_VAR_ID,0) AS NVARCHAR(50)) STOCK_SPEC_ID,
										</cfif>
										INVOICE.INVOICE_CAT,
										<cfif stock_table>
										S.PRODUCT_MANAGER,
										S.PRODUCT_CATID,
										S.BRAND_ID,
										</cfif>
										<cfif isdefined('attributes.is_system_money_2') or attributes.cost_money is not session.ep.money>
											<cfif isdefined('attributes.is_system_money_2')>
											GC.MALIYET_2,
											GC.MALIYET,
											((GC.MALIYET_2*ABS(GC.STOCK_IN-GC.STOCK_OUT))) AS TOTAL_COST_2,
											(GC.MALIYET*ABS(GC.STOCK_IN-GC.STOCK_OUT)) AS TOTAL_COST,
											<cfelse>
												(GC.MALIYET/(IM.RATE2/IM.RATE1)) AS MALIYET,
												((GC.MALIYET*ABS(GC.STOCK_IN-GC.STOCK_OUT))/(IM.RATE2/IM.RATE1)) AS TOTAL_COST,
											</cfif>
										<cfelse>
											(GC.MALIYET) AS MALIYET,
											((GC.MALIYET*ABS(GC.STOCK_IN-GC.STOCK_OUT))) AS TOTAL_COST,
										</cfif>
										ABS(GC.STOCK_IN-GC.STOCK_OUT) AS AMOUNT,
										GC.STOCK_IN,
										GC.STOCK_OUT,
										GC.PROCESS_DATE ISLEM_TARIHI,
										GC.PROCESS_TYPE PROCESS_TYPE,
										ISNULL(ABS(GC.STOCK_IN-GC.STOCK_OUT)*(
											SELECT TOP 1 
												<cfif isdefined("attributes.location_based_cost")>
													<cfif isdefined("attributes.display_cost_money")>
														(PURCHASE_NET_LOCATION+PURCHASE_EXTRA_COST_LOCATION)
													<cfelse>
														(PURCHASE_NET_SYSTEM_LOCATION+PURCHASE_EXTRA_COST_SYSTEM_LOCATION)
													</cfif>
												<cfelse>
													<cfif isdefined("attributes.display_cost_money")>
														(PURCHASE_NET+PURCHASE_EXTRA_COST)
													<cfelse>
														(PURCHASE_NET_SYSTEM+PURCHASE_EXTRA_COST_SYSTEM)
													</cfif>	
												</cfif>
											FROM 
												#dsn3_alias#.PRODUCT_COST WITH (NOLOCK) 
											WHERE 
												START_DATE <= #finish_date# 
												AND PRODUCT_ID = GC.PRODUCT_ID
												<cfif attributes.report_type eq 8>
													 AND ISNULL(PRODUCT_COST.SPECT_MAIN_ID,0) = ISNULL(GC.SPECT_VAR_ID,0)
												</cfif>
												<cfif session.ep.our_company_info.is_stock_based_cost eq 1 and attributes.report_type neq 2>
													AND PRODUCT_COST.STOCK_ID = GC.STOCK_ID 
												</cfif>
												<cfif isdefined("attributes.location_based_cost")>
													<cfif len(attributes.department_id)>
														AND DEPARTMENT_ID = #listgetat(attributes.department_id,1,'-')#
														AND LOCATION_ID = #listgetat(attributes.department_id,2,'-')#
													<cfelse>
														AND DEPARTMENT_ID = SL.DEPARTMENT_ID
														AND LOCATION_ID = SL.LOCATION_ID
													</cfif>
												</cfif>
											ORDER BY 
												START_DATE DESC, 
												RECORD_DATE DESC,
												PRODUCT_COST_ID DESC
										),0) ALL_FINISH_COST,
										ISNULL(ABS(GC.STOCK_IN-GC.STOCK_OUT)*(
											SELECT TOP 1 
												<cfif isdefined("attributes.location_based_cost")>
													(PURCHASE_NET_SYSTEM_2_LOCATION+PURCHASE_EXTRA_COST_SYSTEM_2_LOCATION)
												<cfelse>
													(PURCHASE_NET_SYSTEM_2+PURCHASE_EXTRA_COST_SYSTEM_2)
												</cfif>
											FROM 
												#dsn3_alias#.PRODUCT_COST WITH (NOLOCK) 
											WHERE 
												START_DATE <= #finish_date# 
												AND PRODUCT_ID = GC.PRODUCT_ID
												<cfif attributes.report_type eq 8>
													 AND ISNULL(PRODUCT_COST.SPECT_MAIN_ID,0) = ISNULL(GC.SPECT_VAR_ID,0)
												</cfif>
												<cfif session.ep.our_company_info.is_stock_based_cost eq 1 and attributes.report_type neq 2>
													AND PRODUCT_COST.STOCK_ID = GC.STOCK_ID 
												</cfif>
												<cfif isdefined("attributes.location_based_cost")>
													<cfif len(attributes.department_id)>
														AND DEPARTMENT_ID = #listgetat(attributes.department_id,1,'-')#
														AND LOCATION_ID = #listgetat(attributes.department_id,2,'-')#
													<cfelse>
														AND DEPARTMENT_ID = SL.DEPARTMENT_ID
														AND LOCATION_ID = SL.LOCATION_ID
													</cfif>
												</cfif>
											ORDER BY 
												START_DATE DESC, 
												RECORD_DATE DESC,
												PRODUCT_COST_ID DESC
										),0) ALL_FINISH_COST_2
									FROM
										SHIP WITH (NOLOCK),
										INVOICE WITH (NOLOCK),
										INVOICE_SHIPS INV_S,
										<cfif isdefined('attributes.is_system_money_2') or attributes.cost_money is not session.ep.money>
										INVOICE_MONEY IM,
										</cfif>
										<cfif is_store or isdefined("attributes.location_based_cost")>
											<cfif attributes.report_type eq 8>
												GET_STOCKS_ROW_COST_SPECT_LOCATION AS GC,
											<cfelse>
												GET_STOCKS_ROW_COST_LOCATION AS GC,
											</cfif>
										<cfelse>
											<cfif attributes.report_type eq 8>
												GET_STOCKS_ROW_COST_SPECT AS GC,
											<cfelse>
												GET_STOCK_ROW_COST_TABLE AS GC,
											</cfif>
										</cfif>
										<cfif stock_table>
										#dsn3_alias#.STOCKS S,
										</cfif>
										#dsn_alias#.STOCKS_LOCATION SL
									WHERE
										SHIP.SHIP_ID = INV_S.SHIP_ID
										AND INVOICE.INVOICE_ID= INV_S.INVOICE_ID
										AND INV_S.IS_WITH_SHIP = 1
										AND INV_S.SHIP_PERIOD_ID = #session.ep.period_id#
										AND SHIP.IS_WITH_SHIP=1
										AND SHIP.SHIP_ID = GC.UPD_ID
										AND SHIP.SHIP_TYPE = GC.PROCESS_TYPE
										AND GC.STORE = SL.DEPARTMENT_ID
										AND GC.STORE_LOCATION=SL.LOCATION_ID
										<cfif not isdefined('is_belognto_institution')>
										AND SL.BELONGTO_INSTITUTION = 0
										</cfif>
										<cfif isdefined('attributes.is_system_money_2') or attributes.cost_money is not session.ep.money>
											AND IM.ACTION_ID=INVOICE.INVOICE_ID
											<cfif isdefined('attributes.is_system_money_2')>
											AND IM.MONEY_TYPE = '#session.ep.money2#'
											<cfelse>
											AND IM.MONEY_TYPE = '#attributes.cost_money#'
											</cfif>
										</cfif>
										AND GC.PROCESS_DATE >= #attributes.date#
										AND GC.PROCESS_DATE <= #attributes.date2#
										<cfif len(attributes.department_id)>
										AND
											(
											<cfloop list="#attributes.department_id#" delimiters="," index="dept_i">
											(GC.STORE = #listfirst(dept_i,'-')# AND GC.STORE_LOCATION = #listlast(dept_i,'-')#)
											<cfif dept_i neq listlast(attributes.department_id,',') and listlen(attributes.department_id,',') gte 1> OR</cfif>
											</cfloop>  
											)
										<cfelseif is_store>
											AND GC.STORE IN (#branch_dep_list#)
										</cfif>
										<cfif stock_table>
										AND	GC.STOCK_ID=S.STOCK_ID
										</cfif>
										<cfif len(trim(attributes.sup_company)) and len(attributes.sup_company_id)>
											AND S.COMPANY_ID = #attributes.sup_company_id#
										</cfif>
										<cfif len(trim(attributes.employee_name)) and len(attributes.product_employee_id)>
											AND S.PRODUCT_MANAGER = #attributes.product_employee_id#
										</cfif>
										<cfif len(trim(attributes.product_name)) and len(attributes.product_id)>
											AND S.PRODUCT_ID = #attributes.product_id#
										</cfif>
										<cfif len(trim(attributes.brand_name)) and len(attributes.brand_id)>
											AND S.BRAND_ID = #attributes.brand_id# 
										</cfif>	
										<cfif len(trim(attributes.product_cat)) and len(attributes.product_code)>
											AND S.STOCK_CODE LIKE '#attributes.product_code#%'
										</cfif>
								</cfif>
                            )AS GET_SHIP_ROWS
                        WHERE
                            PROCESS_TYPE IN (76,80,84,87)<!--- 811 kaldırıldı neden var?--->
                            AND INVOICE_CAT NOT IN (54,55) <!--- satıs iade faturaları da mal alım irs. kaydediyor, bunları alıslara dahil etmiyoruz zaten satıs iade bolumunde gosteriliyor --->
                        GROUP BY
                            #ALAN_ADI#
                        ) AS d_alis_miktar ON GET_ALL_STOCK.PRODUCT_GROUPBY_ID = d_alis_miktar.GROUPBY_ALANI
           LEFT JOIN(
                        SELECT
                            <cfif isdefined('attributes.is_system_money_2')>
                            SUM(BIRIM_COST_2 + EXTRA_COST_2) AS TOPLAM_ALIS_MALIYET_2,
                            SUM(BIRIM_COST_2) AS TOPLAM_ALIS_TUTAR_2,
                            </cfif>
                            SUM(BIRIM_COST + EXTRA_COST) AS TOPLAM_ALIS_MALIYET,
                            SUM(BIRIM_COST) AS TOPLAM_ALIS_TUTAR,
                            #ALAN_ADI# AS GROUPBY_ALANI
                        FROM
                            (
                            SELECT 
                                IR.STOCK_ID,
                                IR.PRODUCT_ID,
                                <cfif attributes.report_type eq 8>
                                CAST(IR.STOCK_ID AS NVARCHAR(50)) +'_'+ CAST(ISNULL((SELECT SPECT_MAIN_ID FROM #dsn3_alias#.SPECTS SP WHERE SP.SPECT_VAR_ID = IR.SPECT_VAR_ID),0) AS NVARCHAR(50))  STOCK_SPEC_ID,
                                </cfif>
                                <cfif stock_table>
                                S.PRODUCT_MANAGER,
                                S.PRODUCT_CATID,
                                S.BRAND_ID,
                                </cfif>
                                IR.AMOUNT,
                                I.INVOICE_DATE ISLEM_TARIHI,
                                I.INVOICE_CAT PROCESS_TYPE,
                                <cfif isdefined('attributes.from_invoice_actions') and isdefined('x_show_sale_inoice_cost') and x_show_sale_inoice_cost eq 1><!--- satış faturası satırlarındaki maliyet alınıyor --->
                                    <cfif isdefined('attributes.is_system_money_2')>
                                        (IR.COST_PRICE* IR.AMOUNT) INV_COST,
                                        (IR.EXTRA_COST* IR.AMOUNT) INV_EXTRA_COST,
                                        ((IR.COST_PRICE* IR.AMOUNT)/(IM.RATE2/IM.RATE1)) INV_COST_2,
                                        ((IR.EXTRA_COST* IR.AMOUNT)/(IM.RATE2/IM.RATE1)) INV_EXTRA_COST_2,
                                    <cfelseif attributes.cost_money is not session.ep.money>
                                        ((IR.COST_PRICE* IR.AMOUNT)/(IM.RATE2/IM.RATE1)) INV_COST,
                                        ((IR.EXTRA_COST* IR.AMOUNT)/(IM.RATE2/IM.RATE1)) INV_EXTRA_COST,
                                    <cfelse>
                                        (IR.COST_PRICE* IR.AMOUNT) INV_COST,
                                        (IR.EXTRA_COST* IR.AMOUNT) INV_EXTRA_COST,
                                    </cfif>
                                </cfif>
                                <cfif isdefined('attributes.is_system_money_2') or attributes.cost_money is not session.ep.money>
                                    <cfif isdefined('attributes.is_system_money_2')>
                                    (IR.EXTRA_COST * IR.AMOUNT) EXTRA_COST,
                                    CASE WHEN I.SA_DISCOUNT=0 THEN IR.NETTOTAL ELSE ( (1- I.SA_DISCOUNT/(I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT)) * IR.NETTOTAL) END AS BIRIM_COST,
                                    ((IR.EXTRA_COST * IR.AMOUNT)/(IM.RATE2/IM.RATE1))EXTRA_COST_2,
                                    CASE WHEN I.SA_DISCOUNT=0 THEN (IR.NETTOTAL/(IM.RATE2/IM.RATE1)) ELSE (( (1- I.SA_DISCOUNT/(I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT)) * IR.NETTOTAL)/(IM.RATE2/IM.RATE1)) END AS BIRIM_COST_2
                                    <cfelse>
                                    ((IR.EXTRA_COST * IR.AMOUNT)/(IM.RATE2/IM.RATE1))EXTRA_COST,
                                    CASE WHEN I.SA_DISCOUNT=0 THEN (IR.NETTOTAL/(IM.RATE2/IM.RATE1)) ELSE (( (1- I.SA_DISCOUNT/(I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT)) * IR.NETTOTAL)/(IM.RATE2/IM.RATE1)) END AS BIRIM_COST
                                    </cfif>
                                <cfelse>
                                    (IR.EXTRA_COST * IR.AMOUNT) EXTRA_COST,
                                    CASE WHEN I.SA_DISCOUNT=0 THEN IR.NETTOTAL ELSE (( (1- I.SA_DISCOUNT/(I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT)) * IR.NETTOTAL)) END AS BIRIM_COST
                                </cfif>
                            FROM 
                                INVOICE I WITH (NOLOCK),
                                INVOICE_ROW IR WITH (NOLOCK)
                                <cfif isdefined('attributes.is_system_money_2') or attributes.cost_money is not session.ep.money>
                                ,INVOICE_MONEY IM
                                </cfif>
                                <cfif stock_table>
                                ,#dsn3_alias#.STOCKS S
                                </cfif>
                            WHERE 
                                I.INVOICE_ID = IR.INVOICE_ID AND
                                <cfif not isdefined('attributes.from_invoice_actions')>
                                I.INVOICE_CAT IN (51,54,55,59,60,61,62,63,64,65,68,690,691,591,592) AND
                                </cfif>
                                I.IS_IPTAL = 0 AND
                                I.NETTOTAL > 0 AND
                                I.INVOICE_DATE >= #attributes.date# AND 
                                I.INVOICE_DATE <= #attributes.date2#
                                <cfif isdefined('attributes.is_system_money_2') or attributes.cost_money is not session.ep.money>
                                     AND I.INVOICE_ID = IM.ACTION_ID
                                    <cfif isdefined('attributes.is_system_money_2')>
                                     AND IM.MONEY_TYPE = '#session.ep.money2#'
                                    <cfelse>
                                     AND IM.MONEY_TYPE = '#attributes.cost_money#'
                                    </cfif>
                                </cfif>
                                <cfif stock_table>
                                AND IR.STOCK_ID=S.STOCK_ID
                                </cfif>
                                <cfif len(attributes.department_id)>
                                    AND
                                    (
                                    <cfloop list="#attributes.department_id#" delimiters="," index="dept_i">
                                    (I.DEPARTMENT_ID = #listfirst(dept_i,'-')# AND I.DEPARTMENT_LOCATION = #listlast(dept_i,'-')#)
                                    <cfif dept_i neq listlast(attributes.department_id,',') and listlen(attributes.department_id,',') gte 1> OR</cfif>
                                    </cfloop>  
                                    )
                                 <cfelseif is_store>
                                    AND I.DEPARTMENT_ID IN (#branch_dep_list#)
                                </cfif>
                                <cfif len(trim(attributes.sup_company)) and len(attributes.sup_company_id)>
                                    AND S.COMPANY_ID = #attributes.sup_company_id#
                                </cfif>
                                <cfif len(trim(attributes.employee_name)) and len(attributes.product_employee_id)>
                                    AND S.PRODUCT_MANAGER = #attributes.product_employee_id#
                                </cfif>
                                <cfif len(trim(attributes.product_name)) and len(attributes.product_id)>
                                    AND S.PRODUCT_ID = #attributes.product_id#
                                </cfif>
                                <cfif len(trim(attributes.brand_name)) and len(attributes.brand_id)>
                                    AND S.BRAND_ID = #attributes.brand_id# 
                                </cfif>	
                                <cfif len(trim(attributes.product_cat)) and len(attributes.product_code)>
                                    AND S.STOCK_CODE LIKE '#attributes.product_code#%'
                                </cfif>
                			) AS GET_INV_PURCHASE
                        WHERE
                            PROCESS_TYPE IN (59,64,68,690,591) 
                        GROUP BY
                            #ALAN_ADI#                        
                    ) AS d_alis_tutar ON GET_ALL_STOCK.PRODUCT_GROUPBY_ID = d_alis_tutar.GROUPBY_ALANI
           LEFT JOIN(
                        SELECT
                            SUM(AMOUNT) AS TOPLAM_ALIS_IADE,
                            SUM(TOTAL_COST) AS TOPLAM_ALIS_IADE_MALIYET,
                            <cfif isdefined('attributes.is_system_money_2')>
                            SUM(TOTAL_COST_2) AS TOPLAM_ALIS_IADE_MALIYET_2,
                            </cfif>
                            #ALAN_ADI# AS GROUPBY_ALANI
                        FROM
                            (
                                SELECT
                                    GC.STOCK_ID,
                                    GC.PRODUCT_ID,
                                    <cfif attributes.report_type eq 8>
                                    CAST(GC.STOCK_ID AS NVARCHAR(50)) +'_'+ CAST(ISNULL(GC.SPECT_VAR_ID,0) AS NVARCHAR(50)) STOCK_SPEC_ID,
                                    </cfif>
                                    1 AS INVOICE_CAT,
                                    <cfif stock_table>
                                    S.PRODUCT_MANAGER,
                                    S.PRODUCT_CATID,
                                    S.BRAND_ID,
                                    </cfif>
                                    <cfif isdefined('attributes.is_system_money_2')>
                                    GC.MALIYET_2,
                                    GC.MALIYET,
                                    ((GC.MALIYET_2*ABS(GC.STOCK_IN-GC.STOCK_OUT))) AS TOTAL_COST_2,
                                    (GC.MALIYET*ABS(GC.STOCK_IN-GC.STOCK_OUT)) AS TOTAL_COST,
                                    <cfelse>
                                        <cfif attributes.cost_money is not session.ep.money>
                                        (GC.MALIYET/(SM.RATE2/SM.RATE1)) AS MALIYET,
                                        ((GC.MALIYET*ABS(GC.STOCK_IN-GC.STOCK_OUT))/(SM.RATE2/SM.RATE1)) AS TOTAL_COST,
                                        <cfelse>
                                        GC.MALIYET,
                                        (GC.MALIYET*ABS(GC.STOCK_IN-GC.STOCK_OUT)) AS TOTAL_COST,				
                                        </cfif>
                                    </cfif>
                                    ABS(GC.STOCK_IN-GC.STOCK_OUT) AS AMOUNT,
                                    GC.STOCK_IN,
                                    GC.STOCK_OUT,
                                    GC.PROCESS_DATE ISLEM_TARIHI,
                                    GC.PROCESS_TYPE PROCESS_TYPE
                                    <!---ISNULL(ABS(GC.STOCK_IN-GC.STOCK_OUT)*(
                                        SELECT TOP 1 
                                            <cfif isdefined("attributes.location_based_cost")>
                                                <cfif isdefined("attributes.display_cost_money")>
                                                    (PURCHASE_NET_LOCATION+PURCHASE_EXTRA_COST_LOCATION)
                                                <cfelse>
                                                    (PURCHASE_NET_SYSTEM_LOCATION+PURCHASE_EXTRA_COST_SYSTEM_LOCATION)
                                                </cfif>
                                            <cfelse>
                                                <cfif isdefined("attributes.display_cost_money")>
                                                    (PURCHASE_NET+PURCHASE_EXTRA_COST)
                                                <cfelse>
                                                    (PURCHASE_NET_SYSTEM+PURCHASE_EXTRA_COST_SYSTEM)
                                                </cfif>	
                                            </cfif>
                                        FROM 
                                            #dsn3_alias#.PRODUCT_COST WITH (NOLOCK) 
                                        WHERE 
                                            START_DATE <= #finish_date# 
                                            AND PRODUCT_ID = GC.PRODUCT_ID
                                            <cfif attributes.report_type eq 8>
                                                 AND ISNULL(PRODUCT_COST.SPECT_MAIN_ID,0) = ISNULL(GC.SPECT_VAR_ID,0)
                                            </cfif>
                                            
                                            <cfif isdefined("attributes.location_based_cost")>
                                                <cfif len(attributes.department_id)>
                                                    AND DEPARTMENT_ID = #listgetat(attributes.department_id,1,'-')#
                                                    AND LOCATION_ID = #listgetat(attributes.department_id,2,'-')#
                                                <cfelse>
                                                    AND DEPARTMENT_ID = SL.DEPARTMENT_ID
                                                    AND LOCATION_ID = SL.LOCATION_ID
                                                </cfif>
                                            </cfif>
                                        ORDER BY 
                                            START_DATE DESC, 
                                            RECORD_DATE DESC,
                                            PRODUCT_COST_ID DESC
                                    ),0) ALL_FINISH_COST,
                                    ISNULL(ABS(GC.STOCK_IN-GC.STOCK_OUT)*(
                                        SELECT TOP 1 
                                            <cfif isdefined("attributes.location_based_cost")>
                                                (PURCHASE_NET_SYSTEM_2_LOCATION+PURCHASE_EXTRA_COST_SYSTEM_2_LOCATION)
                                            <cfelse>
                                                (PURCHASE_NET_SYSTEM_2+PURCHASE_EXTRA_COST_SYSTEM_2)
                                            </cfif>
                                        FROM 
                                            #dsn3_alias#.PRODUCT_COST WITH (NOLOCK) 
                                        WHERE 
                                            START_DATE <= #finish_date# 
                                            AND PRODUCT_ID = GC.PRODUCT_ID
                                            <cfif attributes.report_type eq 8>
                                                 AND ISNULL(PRODUCT_COST.SPECT_MAIN_ID,0) = ISNULL(GC.SPECT_VAR_ID,0)
                                            </cfif>
                                            
                                            <cfif isdefined("attributes.location_based_cost")>
                                                <cfif len(attributes.department_id)>
                                                    AND DEPARTMENT_ID = #listgetat(attributes.department_id,1,'-')#
                                                    AND LOCATION_ID = #listgetat(attributes.department_id,2,'-')#
                                                <cfelse>
                                                    AND DEPARTMENT_ID = SL.DEPARTMENT_ID
                                                    AND LOCATION_ID = SL.LOCATION_ID
                                                </cfif>
                                            </cfif>
                                        ORDER BY 
                                            START_DATE DESC, 
                                            RECORD_DATE DESC,
                                            PRODUCT_COST_ID DESC
                                    ),0) ALL_FINISH_COST_2--->
                                FROM
                                    <cfif is_store or isdefined("attributes.location_based_cost")>
                                        <cfif attributes.report_type eq 8>
                                            GET_STOCKS_ROW_COST_SPECT_LOCATION AS GC,
                                        <cfelse>
                                            GET_STOCKS_ROW_COST_LOCATION AS GC,
                                        </cfif>
                                    <cfelse>
                                        <cfif attributes.report_type eq 8>
                                            GET_STOCKS_ROW_COST_SPECT AS GC,
                                        <cfelse>
                                            GET_STOCK_ROW_COST_TABLE AS GC,
                                        </cfif>
                                    </cfif>
                                    <cfif attributes.cost_money is not session.ep.money or isdefined('attributes.is_system_money_2') or listfind(attributes.process_type,3)>
                                    SHIP WITH (NOLOCK),	
                                    </cfif>
                                    <cfif attributes.cost_money is not session.ep.money or isdefined('attributes.is_system_money_2')>
                                    SHIP_MONEY SM,
                                    </cfif>
                                    <cfif stock_table>
                                    #dsn3_alias#.STOCKS S,
                                    </cfif>
                                    #dsn_alias#.STOCKS_LOCATION SL
                                WHERE
                                    GC.STORE = SL.DEPARTMENT_ID
                                    AND GC.STORE_LOCATION=SL.LOCATION_ID
                                    <cfif not isdefined('is_belognto_institution')>
                                    AND SL.BELONGTO_INSTITUTION = 0
                                    </cfif>
                                    <cfif attributes.cost_money is not session.ep.money or isdefined('attributes.is_system_money_2') or listfind(attributes.process_type,3)>
                                    AND GC.UPD_ID = SHIP.SHIP_ID
                                    AND SHIP.SHIP_TYPE = GC.PROCESS_TYPE
                                    AND ISNULL(SHIP.IS_WITH_SHIP,0)=0
                                    </cfif>
                                    <cfif attributes.cost_money is not session.ep.money or isdefined('attributes.is_system_money_2')>
                                    AND SHIP.SHIP_ID = SM.ACTION_ID
                                        <cfif isdefined('attributes.is_system_money_2')>
                                            AND SM.MONEY_TYPE = '#session.ep.money2#'
                                        <cfelse>
                                            AND SM.MONEY_TYPE = '#attributes.cost_money#'
                                        </cfif>
                                    </cfif>
                                    AND GC.PROCESS_DATE >= #attributes.date#
                                    AND GC.PROCESS_DATE <= #attributes.date2#
                                    <cfif len(attributes.department_id)>
                                    AND
                                        (
                                        <cfloop list="#attributes.department_id#" delimiters="," index="dept_i">
                                        (GC.STORE = #listfirst(dept_i,'-')# AND GC.STORE_LOCATION = #listlast(dept_i,'-')#)
                                        <cfif dept_i neq listlast(attributes.department_id,',') and listlen(attributes.department_id,',') gte 1> OR</cfif>
                                        </cfloop>  
                                        )
                                    <cfelseif is_store>
                                        AND GC.STORE IN (#branch_dep_list#)
                                    </cfif>
                                    <cfif stock_table>
                                    AND	GC.STOCK_ID=S.STOCK_ID
                                    </cfif>
                                    <cfif len(trim(attributes.sup_company)) and len(attributes.sup_company_id)>
                                    AND S.COMPANY_ID = #attributes.sup_company_id#
                                    </cfif>
                                    <cfif len(trim(attributes.employee_name)) and len(attributes.product_employee_id)>
                                    AND S.PRODUCT_MANAGER = #attributes.product_employee_id#
                                    </cfif>
                                    <cfif len(trim(attributes.product_name)) and len(attributes.product_id)>
                                    AND S.PRODUCT_ID = #attributes.product_id#
                                    </cfif>
                                    <cfif len(trim(attributes.brand_name)) and len(attributes.brand_id)>
                                    AND S.BRAND_ID = #attributes.brand_id# 
                                    </cfif>	
                                    <cfif len(trim(attributes.product_cat)) and len(attributes.product_code)>
                                    AND S.STOCK_CODE LIKE '#attributes.product_code#%'
                                    </cfif>
                            <cfif attributes.cost_money is not session.ep.money or listfind(attributes.process_type,3)>
                            UNION ALL
                                SELECT
                                    GC.STOCK_ID,
                                    GC.PRODUCT_ID,
                                    <cfif attributes.report_type eq 8>
                                    CAST(GC.STOCK_ID AS NVARCHAR(50)) +'_'+ CAST(ISNULL(GC.SPECT_VAR_ID,0) AS NVARCHAR(50)) STOCK_SPEC_ID,
                                    </cfif>
                                    INVOICE.INVOICE_CAT,
                                    <cfif stock_table>
                                    S.PRODUCT_MANAGER,
                                    S.PRODUCT_CATID,
                                    S.BRAND_ID,
                                    </cfif>
                                    <cfif isdefined('attributes.is_system_money_2') or attributes.cost_money is not session.ep.money>
                                        <cfif isdefined('attributes.is_system_money_2')>
                                        GC.MALIYET_2,
                                        GC.MALIYET,
                                        ((GC.MALIYET_2*ABS(GC.STOCK_IN-GC.STOCK_OUT))) AS TOTAL_COST_2,
                                        (GC.MALIYET*ABS(GC.STOCK_IN-GC.STOCK_OUT)) AS TOTAL_COST,
                                        <cfelse>
                                            (GC.MALIYET/(IM.RATE2/IM.RATE1)) AS MALIYET,
                                            ((GC.MALIYET*ABS(GC.STOCK_IN-GC.STOCK_OUT))/(IM.RATE2/IM.RATE1)) AS TOTAL_COST,
                                        </cfif>
                                    <cfelse>
                                        (GC.MALIYET) AS MALIYET,
                                        ((GC.MALIYET*ABS(GC.STOCK_IN-GC.STOCK_OUT))) AS TOTAL_COST,
                                    </cfif>
                                    ABS(GC.STOCK_IN-GC.STOCK_OUT) AS AMOUNT,
                                    GC.STOCK_IN,
                                    GC.STOCK_OUT,
                                    GC.PROCESS_DATE ISLEM_TARIHI,
                                    GC.PROCESS_TYPE PROCESS_TYPE
                                    <!---ISNULL(ABS(GC.STOCK_IN-GC.STOCK_OUT)*(
                                        SELECT TOP 1 
                                            <cfif isdefined("attributes.location_based_cost")>
                                                <cfif isdefined("attributes.display_cost_money")>
                                                    (PURCHASE_NET_LOCATION+PURCHASE_EXTRA_COST_LOCATION)
                                                <cfelse>
                                                    (PURCHASE_NET_SYSTEM_LOCATION+PURCHASE_EXTRA_COST_SYSTEM_LOCATION)
                                                </cfif>
                                            <cfelse>
                                                <cfif isdefined("attributes.display_cost_money")>
                                                    (PURCHASE_NET+PURCHASE_EXTRA_COST)
                                                <cfelse>
                                                    (PURCHASE_NET_SYSTEM+PURCHASE_EXTRA_COST_SYSTEM)
                                                </cfif>	
                                            </cfif>
                                        FROM 
                                            #dsn3_alias#.PRODUCT_COST WITH (NOLOCK) 
                                        WHERE 
                                            START_DATE <= #finish_date# 
                                            AND PRODUCT_ID = GC.PRODUCT_ID
                                            <cfif attributes.report_type eq 8>
                                                 AND ISNULL(PRODUCT_COST.SPECT_MAIN_ID,0) = ISNULL(GC.SPECT_VAR_ID,0)
                                            </cfif>
                                            
                                            <cfif isdefined("attributes.location_based_cost")>
                                                <cfif len(attributes.department_id)>
                                                    AND DEPARTMENT_ID = #listgetat(attributes.department_id,1,'-')#
                                                    AND LOCATION_ID = #listgetat(attributes.department_id,2,'-')#
                                                <cfelse>
                                                    AND DEPARTMENT_ID = SL.DEPARTMENT_ID
                                                    AND LOCATION_ID = SL.LOCATION_ID
                                                </cfif>
                                            </cfif>
                                        ORDER BY 
                                            START_DATE DESC, 
                                            RECORD_DATE DESC,
                                            PRODUCT_COST_ID DESC
                                    ),0) ALL_FINISH_COST,
                                    ISNULL(ABS(GC.STOCK_IN-GC.STOCK_OUT)*(
                                        SELECT TOP 1 
                                            <cfif isdefined("attributes.location_based_cost")>
                                                (PURCHASE_NET_SYSTEM_2_LOCATION+PURCHASE_EXTRA_COST_SYSTEM_2_LOCATION)
                                            <cfelse>
                                                (PURCHASE_NET_SYSTEM_2+PURCHASE_EXTRA_COST_SYSTEM_2)
                                            </cfif>
                                        FROM 
                                            #dsn3_alias#.PRODUCT_COST WITH (NOLOCK) 
                                        WHERE 
                                            START_DATE <= #finish_date# 
                                            AND PRODUCT_ID = GC.PRODUCT_ID
                                            <cfif attributes.report_type eq 8>
                                                 AND ISNULL(PRODUCT_COST.SPECT_MAIN_ID,0) = ISNULL(GC.SPECT_VAR_ID,0)
                                            </cfif>
                                           
                                            <cfif isdefined("attributes.location_based_cost")>
                                                <cfif len(attributes.department_id)>
                                                    AND DEPARTMENT_ID = #listgetat(attributes.department_id,1,'-')#
                                                    AND LOCATION_ID = #listgetat(attributes.department_id,2,'-')#
                                                <cfelse>
                                                    AND DEPARTMENT_ID = SL.DEPARTMENT_ID
                                                    AND LOCATION_ID = SL.LOCATION_ID
                                                </cfif>
                                            </cfif>
                                        ORDER BY 
                                            START_DATE DESC, 
                                            RECORD_DATE DESC,
                                            PRODUCT_COST_ID DESC
                                    ),0) ALL_FINISH_COST_2--->
                                FROM
                                    SHIP WITH (NOLOCK),
                                    INVOICE WITH (NOLOCK),
                                    INVOICE_SHIPS INV_S,
                                    <cfif isdefined('attributes.is_system_money_2') or attributes.cost_money is not session.ep.money>
                                    INVOICE_MONEY IM,
                                    </cfif>
                                    <cfif is_store or isdefined("attributes.location_based_cost")>
                                        <cfif attributes.report_type eq 8>
                                            GET_STOCKS_ROW_COST_SPECT_LOCATION AS GC,
                                        <cfelse>
                                            GET_STOCKS_ROW_COST_LOCATION AS GC,
                                        </cfif>
                                    <cfelse>
                                        <cfif attributes.report_type eq 8>
                                            GET_STOCKS_ROW_COST_SPECT AS GC,
                                        <cfelse>
                                            GET_STOCK_ROW_COST_TABLE AS GC,
                                        </cfif>
                                    </cfif>
                                    <cfif stock_table>
                                    #dsn3_alias#.STOCKS S,
                                    </cfif>
                                    #dsn_alias#.STOCKS_LOCATION SL
                                WHERE
                                    SHIP.SHIP_ID = INV_S.SHIP_ID
                                    AND INVOICE.INVOICE_ID= INV_S.INVOICE_ID
                                    AND INV_S.IS_WITH_SHIP = 1
                                    AND INV_S.SHIP_PERIOD_ID = #session.ep.period_id#
                                    AND SHIP.IS_WITH_SHIP=1
                                    AND SHIP.SHIP_ID = GC.UPD_ID
                                    AND SHIP.SHIP_TYPE = GC.PROCESS_TYPE
                                    AND GC.STORE = SL.DEPARTMENT_ID
                                    AND GC.STORE_LOCATION=SL.LOCATION_ID
                                    <cfif not isdefined('is_belognto_institution')>
                                    AND SL.BELONGTO_INSTITUTION = 0
                                    </cfif>
                                    <cfif isdefined('attributes.is_system_money_2') or attributes.cost_money is not session.ep.money>
                                        AND IM.ACTION_ID=INVOICE.INVOICE_ID
                                        <cfif isdefined('attributes.is_system_money_2')>
                                        AND IM.MONEY_TYPE = '#session.ep.money2#'
                                        <cfelse>
                                        AND IM.MONEY_TYPE = '#attributes.cost_money#'
                                        </cfif>
                                    </cfif>
                                    AND GC.PROCESS_DATE >= #attributes.date#
                                    AND GC.PROCESS_DATE <= #attributes.date2#
                                    <cfif len(attributes.department_id)>
                                    AND
                                        (
                                        <cfloop list="#attributes.department_id#" delimiters="," index="dept_i">
                                        (GC.STORE = #listfirst(dept_i,'-')# AND GC.STORE_LOCATION = #listlast(dept_i,'-')#)
                                        <cfif dept_i neq listlast(attributes.department_id,',') and listlen(attributes.department_id,',') gte 1> OR</cfif>
                                        </cfloop>  
                                        )
                                    <cfelseif is_store>
                                        AND GC.STORE IN (#branch_dep_list#)
                                    </cfif>
                                    <cfif stock_table>
                                    AND	GC.STOCK_ID=S.STOCK_ID
                                    </cfif>
                                    <cfif len(trim(attributes.sup_company)) and len(attributes.sup_company_id)>
                                        AND S.COMPANY_ID = #attributes.sup_company_id#
                                    </cfif>
                                    <cfif len(trim(attributes.employee_name)) and len(attributes.product_employee_id)>
                                        AND S.PRODUCT_MANAGER = #attributes.product_employee_id#
                                    </cfif>
                                    <cfif len(trim(attributes.product_name)) and len(attributes.product_id)>
                                        AND S.PRODUCT_ID = #attributes.product_id#
                                    </cfif>
                                    <cfif len(trim(attributes.brand_name)) and len(attributes.brand_id)>
                                        AND S.BRAND_ID = #attributes.brand_id# 
                                    </cfif>	
                                    <cfif len(trim(attributes.product_cat)) and len(attributes.product_code)>
                                        AND S.STOCK_CODE LIKE '#attributes.product_code#%'
                                    </cfif>
                            </cfif>
                            )AS GET_SHIP_ROWS
                        WHERE
                            PROCESS_TYPE=78
                        GROUP BY
                            #ALAN_ADI#
                    ) AS d_alis_iade_miktar ON GET_ALL_STOCK.PRODUCT_GROUPBY_ID = d_alis_iade_miktar.GROUPBY_ALANI
           LEFT JOIN(
                        SELECT	
                            SUM(EXTRA_COST + BIRIM_COST) AS TOPLAM_ALIS_IADE_MALIYET,
                            <cfif isdefined('attributes.is_system_money_2')>
                            SUM(EXTRA_COST_2 + BIRIM_COST_2) AS TOPLAM_ALIS_IADE_MALIYET_2,
                            </cfif>
                            #ALAN_ADI# AS GROUPBY_ALANI
                        FROM
                            (
                            SELECT 
                                IR.STOCK_ID,
                                IR.PRODUCT_ID,
                                <cfif attributes.report_type eq 8>
                                CAST(IR.STOCK_ID AS NVARCHAR(50)) +'_'+ CAST(ISNULL((SELECT SPECT_MAIN_ID FROM #dsn3_alias#.SPECTS SP WHERE SP.SPECT_VAR_ID = IR.SPECT_VAR_ID),0) AS NVARCHAR(50))  STOCK_SPEC_ID,
                                </cfif>
                                <cfif stock_table>
                                S.PRODUCT_MANAGER,
                                S.PRODUCT_CATID,
                                S.BRAND_ID,
                                </cfif>
                                IR.AMOUNT,
                                I.INVOICE_DATE ISLEM_TARIHI,
                                I.INVOICE_CAT PROCESS_TYPE,
                                <cfif isdefined('attributes.from_invoice_actions') and isdefined('x_show_sale_inoice_cost') and x_show_sale_inoice_cost eq 1><!--- satış faturası satırlarındaki maliyet alınıyor --->
                                    <cfif isdefined('attributes.is_system_money_2')>
                                        (IR.COST_PRICE* IR.AMOUNT) INV_COST,
                                        (IR.EXTRA_COST* IR.AMOUNT) INV_EXTRA_COST,
                                        ((IR.COST_PRICE* IR.AMOUNT)/(IM.RATE2/IM.RATE1)) INV_COST_2,
                                        ((IR.EXTRA_COST* IR.AMOUNT)/(IM.RATE2/IM.RATE1)) INV_EXTRA_COST_2,
                                    <cfelseif attributes.cost_money is not session.ep.money>
                                        ((IR.COST_PRICE* IR.AMOUNT)/(IM.RATE2/IM.RATE1)) INV_COST,
                                        ((IR.EXTRA_COST* IR.AMOUNT)/(IM.RATE2/IM.RATE1)) INV_EXTRA_COST,
                                    <cfelse>
                                        (IR.COST_PRICE* IR.AMOUNT) INV_COST,
                                        (IR.EXTRA_COST* IR.AMOUNT) INV_EXTRA_COST,
                                    </cfif>
                                </cfif>
                                <cfif isdefined('attributes.is_system_money_2') or attributes.cost_money is not session.ep.money>
                                    <cfif isdefined('attributes.is_system_money_2')>
                                    (IR.EXTRA_COST * IR.AMOUNT) EXTRA_COST,
                                    CASE WHEN I.SA_DISCOUNT=0 THEN IR.NETTOTAL ELSE ( (1- I.SA_DISCOUNT/(I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT)) * IR.NETTOTAL) END AS BIRIM_COST,
                                    ((IR.EXTRA_COST * IR.AMOUNT)/(IM.RATE2/IM.RATE1))EXTRA_COST_2,
                                    CASE WHEN I.SA_DISCOUNT=0 THEN (IR.NETTOTAL/(IM.RATE2/IM.RATE1)) ELSE (( (1- I.SA_DISCOUNT/(I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT)) * IR.NETTOTAL)/(IM.RATE2/IM.RATE1)) END AS BIRIM_COST_2
                                    <cfelse>
                                    ((IR.EXTRA_COST * IR.AMOUNT)/(IM.RATE2/IM.RATE1))EXTRA_COST,
                                    CASE WHEN I.SA_DISCOUNT=0 THEN (IR.NETTOTAL/(IM.RATE2/IM.RATE1)) ELSE (( (1- I.SA_DISCOUNT/(I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT)) * IR.NETTOTAL)/(IM.RATE2/IM.RATE1)) END AS BIRIM_COST
                                    </cfif>
                                <cfelse>
                                    (IR.EXTRA_COST * IR.AMOUNT) EXTRA_COST,
                                    CASE WHEN I.SA_DISCOUNT=0 THEN IR.NETTOTAL ELSE (( (1- I.SA_DISCOUNT/(I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT)) * IR.NETTOTAL)) END AS BIRIM_COST
                                </cfif>
                            FROM 
                                INVOICE I WITH (NOLOCK),
                                INVOICE_ROW IR WITH (NOLOCK)
                                <cfif isdefined('attributes.is_system_money_2') or attributes.cost_money is not session.ep.money>
                                ,INVOICE_MONEY IM
                                </cfif>
                                <cfif stock_table>
                                ,#dsn3_alias#.STOCKS S
                                </cfif>
                            WHERE 
                                I.INVOICE_ID = IR.INVOICE_ID AND
                                <cfif not isdefined('attributes.from_invoice_actions')>
                                I.INVOICE_CAT IN (51,54,55,59,60,61,62,63,64,65,68,690,691,591,592) AND
                                </cfif>
                                I.IS_IPTAL = 0 AND
                                I.NETTOTAL > 0 AND
                                I.INVOICE_DATE >= #attributes.date# AND 
                                I.INVOICE_DATE <= #attributes.date2#
                                <cfif isdefined('attributes.is_system_money_2') or attributes.cost_money is not session.ep.money>
                                     AND I.INVOICE_ID = IM.ACTION_ID
                                    <cfif isdefined('attributes.is_system_money_2')>
                                     AND IM.MONEY_TYPE = '#session.ep.money2#'
                                    <cfelse>
                                     AND IM.MONEY_TYPE = '#attributes.cost_money#'
                                    </cfif>
                                </cfif>
                                <cfif stock_table>
                                AND IR.STOCK_ID=S.STOCK_ID
                                </cfif>
                                <cfif len(attributes.department_id)>
                                    AND
                                    (
                                    <cfloop list="#attributes.department_id#" delimiters="," index="dept_i">
                                    (I.DEPARTMENT_ID = #listfirst(dept_i,'-')# AND I.DEPARTMENT_LOCATION = #listlast(dept_i,'-')#)
                                    <cfif dept_i neq listlast(attributes.department_id,',') and listlen(attributes.department_id,',') gte 1> OR</cfif>
                                    </cfloop>  
                                    )
                                 <cfelseif is_store>
                                    AND I.DEPARTMENT_ID IN (#branch_dep_list#)
                                </cfif>
                                <cfif len(trim(attributes.sup_company)) and len(attributes.sup_company_id)>
                                    AND S.COMPANY_ID = #attributes.sup_company_id#
                                </cfif>
                                <cfif len(trim(attributes.employee_name)) and len(attributes.product_employee_id)>
                                    AND S.PRODUCT_MANAGER = #attributes.product_employee_id#
                                </cfif>
                                <cfif len(trim(attributes.product_name)) and len(attributes.product_id)>
                                    AND S.PRODUCT_ID = #attributes.product_id#
                                </cfif>
                                <cfif len(trim(attributes.brand_name)) and len(attributes.brand_id)>
                                    AND S.BRAND_ID = #attributes.brand_id# 
                                </cfif>	
                                <cfif len(trim(attributes.product_cat)) and len(attributes.product_code)>
                                    AND S.STOCK_CODE LIKE '#attributes.product_code#%'
                                </cfif>
                			) AS GET_INV_PURCHASE
                        WHERE
                            PROCESS_TYPE = 62
                        GROUP BY
                            #ALAN_ADI#
                       ) AS d_alis_iade_tutar ON GET_ALL_STOCK.PRODUCT_GROUPBY_ID = d_alis_iade_tutar.GROUPBY_ALANI
		</cfif>
        <!---depo-lokasyon secili, islem tiplerinde de ithal mal girişi secili ise ithal mal girişi ayrı bölümde gosterilir.--->             
        <cfif len(attributes.department_id) and len(attributes.process_type) and listfind(attributes.process_type,17)>
        	LEFT JOIN(
                        SELECT 
                            SUM(STOCK_IN) AS ITHAL_MAL_GIRIS_MIKTARI,
                            SUM(STOCK_IN*MALIYET) AS ITHAL_MAL_GIRIS_MALIYETI,
                            SUM(STOCK_OUT) AS ITHAL_MAL_CIKIS_MIKTARI,
                            SUM(STOCK_OUT*MALIYET) AS ITHAL_MAL_CIKIS_MALIYETI,
                            <cfif isdefined('attributes.is_system_money_2')>
                            SUM(STOCK_IN*MALIYET_2) AS ITHAL_MAL_GIRIS_MALIYETI_2,
                            SUM(STOCK_OUT*MALIYET_2) AS ITHAL_MAL_CIKIS_MALIYETI_2,
                            </cfif>
                            #ALAN_ADI# AS GROUPBY_ALANI
                        FROM
                            (
                                SELECT
                                    GC.STOCK_ID,
                                    GC.PRODUCT_ID,
                                    <cfif attributes.report_type eq 8>
                                    CAST(GC.STOCK_ID AS NVARCHAR(50)) +'_'+ CAST(ISNULL(GC.SPECT_VAR_ID,0) AS NVARCHAR(50)) STOCK_SPEC_ID,
                                    </cfif>
                                    1 AS INVOICE_CAT,
                                    <cfif stock_table>
                                    S.PRODUCT_MANAGER,
                                    S.PRODUCT_CATID,
                                    S.BRAND_ID,
                                    </cfif>
                                    <cfif isdefined('attributes.is_system_money_2')>
                                    GC.MALIYET_2,
                                    GC.MALIYET,
                                    ((GC.MALIYET_2*ABS(GC.STOCK_IN-GC.STOCK_OUT))) AS TOTAL_COST_2,
                                    (GC.MALIYET*ABS(GC.STOCK_IN-GC.STOCK_OUT)) AS TOTAL_COST,
                                    <cfelse>
                                        <cfif attributes.cost_money is not session.ep.money>
                                        (GC.MALIYET/(SM.RATE2/SM.RATE1)) AS MALIYET,
                                        ((GC.MALIYET*ABS(GC.STOCK_IN-GC.STOCK_OUT))/(SM.RATE2/SM.RATE1)) AS TOTAL_COST,
                                        <cfelse>
                                        GC.MALIYET,
                                        (GC.MALIYET*ABS(GC.STOCK_IN-GC.STOCK_OUT)) AS TOTAL_COST,				
                                        </cfif>
                                    </cfif>
                                    ABS(GC.STOCK_IN-GC.STOCK_OUT) AS AMOUNT,
                                    GC.STOCK_IN,
                                    GC.STOCK_OUT,
                                    GC.PROCESS_DATE ISLEM_TARIHI,
                                    GC.PROCESS_TYPE PROCESS_TYPE
                                    <!---ISNULL(ABS(GC.STOCK_IN-GC.STOCK_OUT)*(
                                        SELECT TOP 1 
                                            <cfif isdefined("attributes.location_based_cost")>
                                                <cfif isdefined("attributes.display_cost_money")>
                                                    (PURCHASE_NET_LOCATION+PURCHASE_EXTRA_COST_LOCATION)
                                                <cfelse>
                                                    (PURCHASE_NET_SYSTEM_LOCATION+PURCHASE_EXTRA_COST_SYSTEM_LOCATION)
                                                </cfif>
                                            <cfelse>
                                                <cfif isdefined("attributes.display_cost_money")>
                                                    (PURCHASE_NET+PURCHASE_EXTRA_COST)
                                                <cfelse>
                                                    (PURCHASE_NET_SYSTEM+PURCHASE_EXTRA_COST_SYSTEM)
                                                </cfif>	
                                            </cfif>
                                        FROM 
                                            #dsn3_alias#.PRODUCT_COST WITH (NOLOCK) 
                                        WHERE 
                                            START_DATE <= #finish_date# 
                                            AND PRODUCT_ID = GC.PRODUCT_ID
                                            <cfif attributes.report_type eq 8>
                                                 AND ISNULL(PRODUCT_COST.SPECT_MAIN_ID,0) = ISNULL(GC.SPECT_VAR_ID,0)
                                            </cfif>
                                            
                                            <cfif isdefined("attributes.location_based_cost")>
                                                <cfif len(attributes.department_id)>
                                                    AND DEPARTMENT_ID = #listgetat(attributes.department_id,1,'-')#
                                                    AND LOCATION_ID = #listgetat(attributes.department_id,2,'-')#
                                                <cfelse>
                                                    AND DEPARTMENT_ID = SL.DEPARTMENT_ID
                                                    AND LOCATION_ID = SL.LOCATION_ID
                                                </cfif>
                                            </cfif>
                                        ORDER BY 
                                            START_DATE DESC, 
                                            RECORD_DATE DESC,
                                            PRODUCT_COST_ID DESC
                                    ),0) ALL_FINISH_COST,
                                    ISNULL(ABS(GC.STOCK_IN-GC.STOCK_OUT)*(
                                        SELECT TOP 1 
                                            <cfif isdefined("attributes.location_based_cost")>
                                                (PURCHASE_NET_SYSTEM_2_LOCATION+PURCHASE_EXTRA_COST_SYSTEM_2_LOCATION)
                                            <cfelse>
                                                (PURCHASE_NET_SYSTEM_2+PURCHASE_EXTRA_COST_SYSTEM_2)
                                            </cfif>
                                        FROM 
                                            #dsn3_alias#.PRODUCT_COST WITH (NOLOCK) 
                                        WHERE 
                                            START_DATE <= #finish_date# 
                                            AND PRODUCT_ID = GC.PRODUCT_ID
                                            <cfif attributes.report_type eq 8>
                                                 AND ISNULL(PRODUCT_COST.SPECT_MAIN_ID,0) = ISNULL(GC.SPECT_VAR_ID,0)
                                            </cfif>
                                            
                                            <cfif isdefined("attributes.location_based_cost")>
                                                <cfif len(attributes.department_id)>
                                                    AND DEPARTMENT_ID = #listgetat(attributes.department_id,1,'-')#
                                                    AND LOCATION_ID = #listgetat(attributes.department_id,2,'-')#
                                                <cfelse>
                                                    AND DEPARTMENT_ID = SL.DEPARTMENT_ID
                                                    AND LOCATION_ID = SL.LOCATION_ID
                                                </cfif>
                                            </cfif>
                                        ORDER BY 
                                            START_DATE DESC, 
                                            RECORD_DATE DESC,
                                            PRODUCT_COST_ID DESC
                                    ),0) ALL_FINISH_COST_2--->
                                FROM
                                    <cfif is_store or isdefined("attributes.location_based_cost")>
                                        <cfif attributes.report_type eq 8>
                                            GET_STOCKS_ROW_COST_SPECT_LOCATION AS GC,
                                        <cfelse>
                                            GET_STOCKS_ROW_COST_LOCATION AS GC,
                                        </cfif>
                                    <cfelse>
                                        <cfif attributes.report_type eq 8>
                                            GET_STOCKS_ROW_COST_SPECT AS GC,
                                        <cfelse>
                                            GET_STOCK_ROW_COST_TABLE AS GC,
                                        </cfif>
                                    </cfif>
                                    <cfif attributes.cost_money is not session.ep.money or isdefined('attributes.is_system_money_2') or listfind(attributes.process_type,3)>
                                    SHIP WITH (NOLOCK),	
                                    </cfif>
                                    <cfif attributes.cost_money is not session.ep.money or isdefined('attributes.is_system_money_2')>
                                    SHIP_MONEY SM,
                                    </cfif>
                                    <cfif stock_table>
                                    #dsn3_alias#.STOCKS S,
                                    </cfif>
                                    #dsn_alias#.STOCKS_LOCATION SL
                                WHERE
                                    GC.STORE = SL.DEPARTMENT_ID
                                    AND GC.STORE_LOCATION=SL.LOCATION_ID
                                    <cfif not isdefined('is_belognto_institution')>
                                    AND SL.BELONGTO_INSTITUTION = 0
                                    </cfif>
                                    <cfif attributes.cost_money is not session.ep.money or isdefined('attributes.is_system_money_2') or listfind(attributes.process_type,3)>
                                    AND GC.UPD_ID = SHIP.SHIP_ID
                                    AND SHIP.SHIP_TYPE = GC.PROCESS_TYPE
                                    AND ISNULL(SHIP.IS_WITH_SHIP,0)=0
                                    </cfif>
                                    <cfif attributes.cost_money is not session.ep.money or isdefined('attributes.is_system_money_2')>
                                    AND SHIP.SHIP_ID = SM.ACTION_ID
                                        <cfif isdefined('attributes.is_system_money_2')>
                                            AND SM.MONEY_TYPE = '#session.ep.money2#'
                                        <cfelse>
                                            AND SM.MONEY_TYPE = '#attributes.cost_money#'
                                        </cfif>
                                    </cfif>
                                    AND GC.PROCESS_DATE >= #attributes.date#
                                    AND GC.PROCESS_DATE <= #attributes.date2#
                                    <cfif len(attributes.department_id)>
                                    AND
                                        (
                                        <cfloop list="#attributes.department_id#" delimiters="," index="dept_i">
                                        (GC.STORE = #listfirst(dept_i,'-')# AND GC.STORE_LOCATION = #listlast(dept_i,'-')#)
                                        <cfif dept_i neq listlast(attributes.department_id,',') and listlen(attributes.department_id,',') gte 1> OR</cfif>
                                        </cfloop>  
                                        )
                                    <cfelseif is_store>
                                        AND GC.STORE IN (#branch_dep_list#)
                                    </cfif>
                                    <cfif stock_table>
                                    AND	GC.STOCK_ID=S.STOCK_ID
                                    </cfif>
                                    <cfif len(trim(attributes.sup_company)) and len(attributes.sup_company_id)>
                                    AND S.COMPANY_ID = #attributes.sup_company_id#
                                    </cfif>
                                    <cfif len(trim(attributes.employee_name)) and len(attributes.product_employee_id)>
                                    AND S.PRODUCT_MANAGER = #attributes.product_employee_id#
                                    </cfif>
                                    <cfif len(trim(attributes.product_name)) and len(attributes.product_id)>
                                    AND S.PRODUCT_ID = #attributes.product_id#
                                    </cfif>
                                    <cfif len(trim(attributes.brand_name)) and len(attributes.brand_id)>
                                    AND S.BRAND_ID = #attributes.brand_id# 
                                    </cfif>	
                                    <cfif len(trim(attributes.product_cat)) and len(attributes.product_code)>
                                    AND S.STOCK_CODE LIKE '#attributes.product_code#%'
                                    </cfif>
                            <cfif attributes.cost_money is not session.ep.money or listfind(attributes.process_type,3)>
                            UNION ALL
                                SELECT
                                    GC.STOCK_ID,
                                    GC.PRODUCT_ID,
                                    <cfif attributes.report_type eq 8>
                                    CAST(GC.STOCK_ID AS NVARCHAR(50)) +'_'+ CAST(ISNULL(GC.SPECT_VAR_ID,0) AS NVARCHAR(50)) STOCK_SPEC_ID,
                                    </cfif>
                                    INVOICE.INVOICE_CAT,
                                    <cfif stock_table>
                                    S.PRODUCT_MANAGER,
                                    S.PRODUCT_CATID,
                                    S.BRAND_ID,
                                    </cfif>
                                    <cfif isdefined('attributes.is_system_money_2') or attributes.cost_money is not session.ep.money>
                                        <cfif isdefined('attributes.is_system_money_2')>
                                        GC.MALIYET_2,
                                        GC.MALIYET,
                                        ((GC.MALIYET_2*ABS(GC.STOCK_IN-GC.STOCK_OUT))) AS TOTAL_COST_2,
                                        (GC.MALIYET*ABS(GC.STOCK_IN-GC.STOCK_OUT)) AS TOTAL_COST,
                                        <cfelse>
                                            (GC.MALIYET/(IM.RATE2/IM.RATE1)) AS MALIYET,
                                            ((GC.MALIYET*ABS(GC.STOCK_IN-GC.STOCK_OUT))/(IM.RATE2/IM.RATE1)) AS TOTAL_COST,
                                        </cfif>
                                    <cfelse>
                                        (GC.MALIYET) AS MALIYET,
                                        ((GC.MALIYET*ABS(GC.STOCK_IN-GC.STOCK_OUT))) AS TOTAL_COST,
                                    </cfif>
                                    ABS(GC.STOCK_IN-GC.STOCK_OUT) AS AMOUNT,
                                    GC.STOCK_IN,
                                    GC.STOCK_OUT,
                                    GC.PROCESS_DATE ISLEM_TARIHI,
                                    GC.PROCESS_TYPE PROCESS_TYPE
                                   <!--- ISNULL(ABS(GC.STOCK_IN-GC.STOCK_OUT)*(
                                        SELECT TOP 1 
                                            <cfif isdefined("attributes.location_based_cost")>
                                                <cfif isdefined("attributes.display_cost_money")>
                                                    (PURCHASE_NET_LOCATION+PURCHASE_EXTRA_COST_LOCATION)
                                                <cfelse>
                                                    (PURCHASE_NET_SYSTEM_LOCATION+PURCHASE_EXTRA_COST_SYSTEM_LOCATION)
                                                </cfif>
                                            <cfelse>
                                                <cfif isdefined("attributes.display_cost_money")>
                                                    (PURCHASE_NET+PURCHASE_EXTRA_COST)
                                                <cfelse>
                                                    (PURCHASE_NET_SYSTEM+PURCHASE_EXTRA_COST_SYSTEM)
                                                </cfif>	
                                            </cfif>
                                        FROM 
                                            #dsn3_alias#.PRODUCT_COST WITH (NOLOCK) 
                                        WHERE 
                                            START_DATE <= #finish_date# 
                                            AND PRODUCT_ID = GC.PRODUCT_ID
                                            <cfif attributes.report_type eq 8>
                                                 AND ISNULL(PRODUCT_COST.SPECT_MAIN_ID,0) = ISNULL(GC.SPECT_VAR_ID,0)
                                            </cfif>
                                           
                                            <cfif isdefined("attributes.location_based_cost")>
                                                <cfif len(attributes.department_id)>
                                                    AND DEPARTMENT_ID = #listgetat(attributes.department_id,1,'-')#
                                                    AND LOCATION_ID = #listgetat(attributes.department_id,2,'-')#
                                                <cfelse>
                                                    AND DEPARTMENT_ID = SL.DEPARTMENT_ID
                                                    AND LOCATION_ID = SL.LOCATION_ID
                                                </cfif>
                                            </cfif>
                                        ORDER BY 
                                            START_DATE DESC, 
                                            RECORD_DATE DESC,
                                            PRODUCT_COST_ID DESC
                                    ),0) ALL_FINISH_COST,
                                    ISNULL(ABS(GC.STOCK_IN-GC.STOCK_OUT)*(
                                        SELECT TOP 1 
                                            <cfif isdefined("attributes.location_based_cost")>
                                                (PURCHASE_NET_SYSTEM_2_LOCATION+PURCHASE_EXTRA_COST_SYSTEM_2_LOCATION)
                                            <cfelse>
                                                (PURCHASE_NET_SYSTEM_2+PURCHASE_EXTRA_COST_SYSTEM_2)
                                            </cfif>
                                        FROM 
                                            #dsn3_alias#.PRODUCT_COST WITH (NOLOCK) 
                                        WHERE 
                                            START_DATE <= #finish_date# 
                                            AND PRODUCT_ID = GC.PRODUCT_ID
                                            <cfif attributes.report_type eq 8>
                                                 AND ISNULL(PRODUCT_COST.SPECT_MAIN_ID,0) = ISNULL(GC.SPECT_VAR_ID,0)
                                            </cfif>
                                          
                                            <cfif isdefined("attributes.location_based_cost")>
                                                <cfif len(attributes.department_id)>
                                                    AND DEPARTMENT_ID = #listgetat(attributes.department_id,1,'-')#
                                                    AND LOCATION_ID = #listgetat(attributes.department_id,2,'-')#
                                                <cfelse>
                                                    AND DEPARTMENT_ID = SL.DEPARTMENT_ID
                                                    AND LOCATION_ID = SL.LOCATION_ID
                                                </cfif>
                                            </cfif>
                                        ORDER BY 
                                            START_DATE DESC, 
                                            RECORD_DATE DESC,
                                            PRODUCT_COST_ID DESC
                                    ),0) ALL_FINISH_COST_2--->
                                FROM
                                    SHIP WITH (NOLOCK),
                                    INVOICE WITH (NOLOCK),
                                    INVOICE_SHIPS INV_S,
                                    <cfif isdefined('attributes.is_system_money_2') or attributes.cost_money is not session.ep.money>
                                    INVOICE_MONEY IM,
                                    </cfif>
                                    <cfif is_store or isdefined("attributes.location_based_cost")>
                                        <cfif attributes.report_type eq 8>
                                            GET_STOCKS_ROW_COST_SPECT_LOCATION AS GC,
                                        <cfelse>
                                            GET_STOCKS_ROW_COST_LOCATION AS GC,
                                        </cfif>
                                    <cfelse>
                                        <cfif attributes.report_type eq 8>
                                            GET_STOCKS_ROW_COST_SPECT AS GC,
                                        <cfelse>
                                            GET_STOCK_ROW_COST_TABLE AS GC,
                                        </cfif>
                                    </cfif>
                                    <cfif stock_table>
                                    #dsn3_alias#.STOCKS S,
                                    </cfif>
                                    #dsn_alias#.STOCKS_LOCATION SL
                                WHERE
                                    SHIP.SHIP_ID = INV_S.SHIP_ID
                                    AND INVOICE.INVOICE_ID= INV_S.INVOICE_ID
                                    AND INV_S.IS_WITH_SHIP = 1
                                    AND INV_S.SHIP_PERIOD_ID = #session.ep.period_id#
                                    AND SHIP.IS_WITH_SHIP=1
                                    AND SHIP.SHIP_ID = GC.UPD_ID
                                    AND SHIP.SHIP_TYPE = GC.PROCESS_TYPE
                                    AND GC.STORE = SL.DEPARTMENT_ID
                                    AND GC.STORE_LOCATION=SL.LOCATION_ID
                                    <cfif not isdefined('is_belognto_institution')>
                                    AND SL.BELONGTO_INSTITUTION = 0
                                    </cfif>
                                    <cfif isdefined('attributes.is_system_money_2') or attributes.cost_money is not session.ep.money>
                                        AND IM.ACTION_ID=INVOICE.INVOICE_ID
                                        <cfif isdefined('attributes.is_system_money_2')>
                                        AND IM.MONEY_TYPE = '#session.ep.money2#'
                                        <cfelse>
                                        AND IM.MONEY_TYPE = '#attributes.cost_money#'
                                        </cfif>
                                    </cfif>
                                    AND GC.PROCESS_DATE >= #attributes.date#
                                    AND GC.PROCESS_DATE <= #attributes.date2#
                                    <cfif len(attributes.department_id)>
                                    AND
                                        (
                                        <cfloop list="#attributes.department_id#" delimiters="," index="dept_i">
                                        (GC.STORE = #listfirst(dept_i,'-')# AND GC.STORE_LOCATION = #listlast(dept_i,'-')#)
                                        <cfif dept_i neq listlast(attributes.department_id,',') and listlen(attributes.department_id,',') gte 1> OR</cfif>
                                        </cfloop>  
                                        )
                                    <cfelseif is_store>
                                        AND GC.STORE IN (#branch_dep_list#)
                                    </cfif>
                                    <cfif stock_table>
                                    AND	GC.STOCK_ID=S.STOCK_ID
                                    </cfif>
                                    <cfif len(trim(attributes.sup_company)) and len(attributes.sup_company_id)>
                                        AND S.COMPANY_ID = #attributes.sup_company_id#
                                    </cfif>
                                    <cfif len(trim(attributes.employee_name)) and len(attributes.product_employee_id)>
                                        AND S.PRODUCT_MANAGER = #attributes.product_employee_id#
                                    </cfif>
                                    <cfif len(trim(attributes.product_name)) and len(attributes.product_id)>
                                        AND S.PRODUCT_ID = #attributes.product_id#
                                    </cfif>
                                    <cfif len(trim(attributes.brand_name)) and len(attributes.brand_id)>
                                        AND S.BRAND_ID = #attributes.brand_id# 
                                    </cfif>	
                                    <cfif len(trim(attributes.product_cat)) and len(attributes.product_code)>
                                        AND S.STOCK_CODE LIKE '#attributes.product_code#%'
                                    </cfif>
                            </cfif>
                            )AS GET_SHIP_ROWS
                        WHERE
                            ISLEM_TARIHI <= #attributes.date2#
                            AND PROCESS_TYPE = 811
                        GROUP BY
                            #ALAN_ADI#
                        ) AS get_ithal_mal_girisi_total ON GET_ALL_STOCK.PRODUCT_GROUPBY_ID = get_ithal_mal_girisi_total.GROUPBY_ALANI 
        </cfif>
        <!---depo-lokasyon secili, islem tiplerinde de depo sevk secili ise sevk irs. ayrı bölümde gosterilir.--->
        <cfif len(attributes.department_id) and len(attributes.process_type) and listfind(attributes.process_type,16)>
			LEFT JOIN (
                        SELECT 
                            SUM(STOCK_IN) AS SEVK_GIRIS_MIKTARI,
                            SUM(STOCK_IN*MALIYET) AS SEVK_GIRIS_MALIYETI,
                            SUM(STOCK_OUT) AS SEVK_CIKIS_MIKTARI,
                            SUM(STOCK_OUT*MALIYET) AS SEVK_CIKIS_MALIYETI,
                            <cfif isdefined('attributes.is_system_money_2')>
                            SUM(STOCK_IN*MALIYET_2) AS SEVK_GIRIS_MALIYETI_2,
                            SUM(STOCK_OUT*MALIYET_2) AS SEVK_CIKIS_MALIYETI_2,
                            </cfif>
                            #ALAN_ADI# AS GROUPBY_ALANI
                        FROM
                            (
                                SELECT
                                    GC.STOCK_ID,
                                    GC.PRODUCT_ID,
                                    <cfif attributes.report_type eq 8>
                                    CAST(GC.STOCK_ID AS NVARCHAR(50)) +'_'+ CAST(ISNULL(GC.SPECT_VAR_ID,0) AS NVARCHAR(50)) STOCK_SPEC_ID,
                                    </cfif>
                                    1 AS INVOICE_CAT,
                                    <cfif stock_table>
                                    S.PRODUCT_MANAGER,
                                    S.PRODUCT_CATID,
                                    S.BRAND_ID,
                                    </cfif>
                                    <cfif isdefined('attributes.is_system_money_2')>
                                    GC.MALIYET_2,
                                    GC.MALIYET,
                                    ((GC.MALIYET_2*ABS(GC.STOCK_IN-GC.STOCK_OUT))) AS TOTAL_COST_2,
                                    (GC.MALIYET*ABS(GC.STOCK_IN-GC.STOCK_OUT)) AS TOTAL_COST,
                                    <cfelse>
                                        <cfif attributes.cost_money is not session.ep.money>
                                        (GC.MALIYET/(SM.RATE2/SM.RATE1)) AS MALIYET,
                                        ((GC.MALIYET*ABS(GC.STOCK_IN-GC.STOCK_OUT))/(SM.RATE2/SM.RATE1)) AS TOTAL_COST,
                                        <cfelse>
                                        GC.MALIYET,
                                        (GC.MALIYET*ABS(GC.STOCK_IN-GC.STOCK_OUT)) AS TOTAL_COST,				

                                        </cfif>
                                    </cfif>
                                    ABS(GC.STOCK_IN-GC.STOCK_OUT) AS AMOUNT,
                                    GC.STOCK_IN,
                                    GC.STOCK_OUT,
                                    GC.PROCESS_DATE ISLEM_TARIHI,
                                    GC.PROCESS_TYPE PROCESS_TYPE
                                   <!--- ISNULL(ABS(GC.STOCK_IN-GC.STOCK_OUT)*(
                                        SELECT TOP 1 
                                            <cfif isdefined("attributes.location_based_cost")>
                                                <cfif isdefined("attributes.display_cost_money")>
                                                    (PURCHASE_NET_LOCATION+PURCHASE_EXTRA_COST_LOCATION)
                                                <cfelse>
                                                    (PURCHASE_NET_SYSTEM_LOCATION+PURCHASE_EXTRA_COST_SYSTEM_LOCATION)
                                                </cfif>
                                            <cfelse>
                                                <cfif isdefined("attributes.display_cost_money")>
                                                    (PURCHASE_NET+PURCHASE_EXTRA_COST)
                                                <cfelse>
                                                    (PURCHASE_NET_SYSTEM+PURCHASE_EXTRA_COST_SYSTEM)
                                                </cfif>	
                                            </cfif>
                                        FROM 
                                            #dsn3_alias#.PRODUCT_COST WITH (NOLOCK) 
                                        WHERE 
                                            START_DATE <= #finish_date# 
                                            AND PRODUCT_ID = GC.PRODUCT_ID
                                            <cfif attributes.report_type eq 8>
                                                 AND ISNULL(PRODUCT_COST.SPECT_MAIN_ID,0) = ISNULL(GC.SPECT_VAR_ID,0)
                                            </cfif>
                                           
                                            <cfif isdefined("attributes.location_based_cost")>
                                                <cfif len(attributes.department_id)>
                                                    AND DEPARTMENT_ID = #listgetat(attributes.department_id,1,'-')#
                                                    AND LOCATION_ID = #listgetat(attributes.department_id,2,'-')#
                                                <cfelse>
                                                    AND DEPARTMENT_ID = SL.DEPARTMENT_ID
                                                    AND LOCATION_ID = SL.LOCATION_ID
                                                </cfif>
                                            </cfif>
                                        ORDER BY 
                                            START_DATE DESC, 
                                            RECORD_DATE DESC,
                                            PRODUCT_COST_ID DESC
                                    ),0) ALL_FINISH_COST,
                                    ISNULL(ABS(GC.STOCK_IN-GC.STOCK_OUT)*(
                                        SELECT TOP 1 
                                            <cfif isdefined("attributes.location_based_cost")>
                                                (PURCHASE_NET_SYSTEM_2_LOCATION+PURCHASE_EXTRA_COST_SYSTEM_2_LOCATION)
                                            <cfelse>
                                                (PURCHASE_NET_SYSTEM_2+PURCHASE_EXTRA_COST_SYSTEM_2)
                                            </cfif>
                                        FROM 
                                            #dsn3_alias#.PRODUCT_COST WITH (NOLOCK) 
                                        WHERE 
                                            START_DATE <= #finish_date# 
                                            AND PRODUCT_ID = GC.PRODUCT_ID
                                            <cfif attributes.report_type eq 8>
                                                 AND ISNULL(PRODUCT_COST.SPECT_MAIN_ID,0) = ISNULL(GC.SPECT_VAR_ID,0)
                                            </cfif>
                                            
                                            <cfif isdefined("attributes.location_based_cost")>
                                                <cfif len(attributes.department_id)>
                                                    AND DEPARTMENT_ID = #listgetat(attributes.department_id,1,'-')#
                                                    AND LOCATION_ID = #listgetat(attributes.department_id,2,'-')#
                                                <cfelse>
                                                    AND DEPARTMENT_ID = SL.DEPARTMENT_ID
                                                    AND LOCATION_ID = SL.LOCATION_ID
                                                </cfif>
                                            </cfif>
                                        ORDER BY 
                                            START_DATE DESC, 
                                            RECORD_DATE DESC,
                                            PRODUCT_COST_ID DESC
                                    ),0) ALL_FINISH_COST_2--->
                                FROM
                                    <cfif is_store or isdefined("attributes.location_based_cost")>
                                        <cfif attributes.report_type eq 8>
                                            GET_STOCKS_ROW_COST_SPECT_LOCATION AS GC,
                                        <cfelse>
                                            GET_STOCKS_ROW_COST_LOCATION AS GC,
                                        </cfif>
                                    <cfelse>
                                        <cfif attributes.report_type eq 8>
                                            GET_STOCKS_ROW_COST_SPECT AS GC,
                                        <cfelse>
                                            GET_STOCK_ROW_COST_TABLE AS GC,
                                        </cfif>
                                    </cfif>
                                    <cfif attributes.cost_money is not session.ep.money or isdefined('attributes.is_system_money_2') or listfind(attributes.process_type,3)>
                                    SHIP WITH (NOLOCK),	
                                    </cfif>
                                    <cfif attributes.cost_money is not session.ep.money or isdefined('attributes.is_system_money_2')>
                                    SHIP_MONEY SM,
                                    </cfif>
                                    <cfif stock_table>
                                    #dsn3_alias#.STOCKS S,
                                    </cfif>
                                    #dsn_alias#.STOCKS_LOCATION SL
                                WHERE
                                    GC.STORE = SL.DEPARTMENT_ID
                                    AND GC.STORE_LOCATION=SL.LOCATION_ID
                                    <cfif not isdefined('is_belognto_institution')>
                                    AND SL.BELONGTO_INSTITUTION = 0
                                    </cfif>
                                    <cfif attributes.cost_money is not session.ep.money or isdefined('attributes.is_system_money_2') or listfind(attributes.process_type,3)>
                                    AND GC.UPD_ID = SHIP.SHIP_ID
                                    AND SHIP.SHIP_TYPE = GC.PROCESS_TYPE
                                    AND ISNULL(SHIP.IS_WITH_SHIP,0)=0
                                    </cfif>
                                    <cfif attributes.cost_money is not session.ep.money or isdefined('attributes.is_system_money_2')>
                                    AND SHIP.SHIP_ID = SM.ACTION_ID
                                        <cfif isdefined('attributes.is_system_money_2')>
                                            AND SM.MONEY_TYPE = '#session.ep.money2#'
                                        <cfelse>
                                            AND SM.MONEY_TYPE = '#attributes.cost_money#'
                                        </cfif>
                                    </cfif>
                                    AND GC.PROCESS_DATE >= #attributes.date#
                                    AND GC.PROCESS_DATE <= #attributes.date2#
                                    <cfif len(attributes.department_id)>
                                    AND
                                        (
                                        <cfloop list="#attributes.department_id#" delimiters="," index="dept_i">
                                        (GC.STORE = #listfirst(dept_i,'-')# AND GC.STORE_LOCATION = #listlast(dept_i,'-')#)
                                        <cfif dept_i neq listlast(attributes.department_id,',') and listlen(attributes.department_id,',') gte 1> OR</cfif>
                                        </cfloop>  
                                        )
                                    <cfelseif is_store>
                                        AND GC.STORE IN (#branch_dep_list#)
                                    </cfif>
                                    <cfif stock_table>
                                    AND	GC.STOCK_ID=S.STOCK_ID
                                    </cfif>
                                    <cfif len(trim(attributes.sup_company)) and len(attributes.sup_company_id)>
                                    AND S.COMPANY_ID = #attributes.sup_company_id#
                                    </cfif>
                                    <cfif len(trim(attributes.employee_name)) and len(attributes.product_employee_id)>
                                    AND S.PRODUCT_MANAGER = #attributes.product_employee_id#
                                    </cfif>
                                    <cfif len(trim(attributes.product_name)) and len(attributes.product_id)>
                                    AND S.PRODUCT_ID = #attributes.product_id#
                                    </cfif>
                                    <cfif len(trim(attributes.brand_name)) and len(attributes.brand_id)>
                                    AND S.BRAND_ID = #attributes.brand_id# 
                                    </cfif>	
                                    <cfif len(trim(attributes.product_cat)) and len(attributes.product_code)>
                                    AND S.STOCK_CODE LIKE '#attributes.product_code#%'
                                    </cfif>
                            <cfif attributes.cost_money is not session.ep.money or listfind(attributes.process_type,3)>
                            UNION ALL
                                SELECT
                                    GC.STOCK_ID,
                                    GC.PRODUCT_ID,
                                    <cfif attributes.report_type eq 8>
                                    CAST(GC.STOCK_ID AS NVARCHAR(50)) +'_'+ CAST(ISNULL(GC.SPECT_VAR_ID,0) AS NVARCHAR(50)) STOCK_SPEC_ID,
                                    </cfif>
                                    INVOICE.INVOICE_CAT,
                                    <cfif stock_table>
                                    S.PRODUCT_MANAGER,
                                    S.PRODUCT_CATID,
                                    S.BRAND_ID,
                                    </cfif>
                                    <cfif isdefined('attributes.is_system_money_2') or attributes.cost_money is not session.ep.money>
                                        <cfif isdefined('attributes.is_system_money_2')>
                                        GC.MALIYET_2,
                                        GC.MALIYET,
                                        ((GC.MALIYET_2*ABS(GC.STOCK_IN-GC.STOCK_OUT))) AS TOTAL_COST_2,
                                        (GC.MALIYET*ABS(GC.STOCK_IN-GC.STOCK_OUT)) AS TOTAL_COST,
                                        <cfelse>
                                            (GC.MALIYET/(IM.RATE2/IM.RATE1)) AS MALIYET,
                                            ((GC.MALIYET*ABS(GC.STOCK_IN-GC.STOCK_OUT))/(IM.RATE2/IM.RATE1)) AS TOTAL_COST,
                                        </cfif>
                                    <cfelse>
                                        (GC.MALIYET) AS MALIYET,
                                        ((GC.MALIYET*ABS(GC.STOCK_IN-GC.STOCK_OUT))) AS TOTAL_COST,
                                    </cfif>
                                    ABS(GC.STOCK_IN-GC.STOCK_OUT) AS AMOUNT,
                                    GC.STOCK_IN,
                                    GC.STOCK_OUT,
                                    GC.PROCESS_DATE ISLEM_TARIHI,
                                    GC.PROCESS_TYPE PROCESS_TYPE
                                    <!---ISNULL(ABS(GC.STOCK_IN-GC.STOCK_OUT)*(
                                        SELECT TOP 1 
                                            <cfif isdefined("attributes.location_based_cost")>
                                                <cfif isdefined("attributes.display_cost_money")>
                                                    (PURCHASE_NET_LOCATION+PURCHASE_EXTRA_COST_LOCATION)
                                                <cfelse>
                                                    (PURCHASE_NET_SYSTEM_LOCATION+PURCHASE_EXTRA_COST_SYSTEM_LOCATION)
                                                </cfif>
                                            <cfelse>
                                                <cfif isdefined("attributes.display_cost_money")>
                                                    (PURCHASE_NET+PURCHASE_EXTRA_COST)
                                                <cfelse>
                                                    (PURCHASE_NET_SYSTEM+PURCHASE_EXTRA_COST_SYSTEM)
                                                </cfif>	
                                            </cfif>
                                        FROM 
                                            #dsn3_alias#.PRODUCT_COST WITH (NOLOCK) 
                                        WHERE 
                                            START_DATE <= #finish_date# 
                                            AND PRODUCT_ID = GC.PRODUCT_ID
                                            <cfif attributes.report_type eq 8>
                                                 AND ISNULL(PRODUCT_COST.SPECT_MAIN_ID,0) = ISNULL(GC.SPECT_VAR_ID,0)
                                            </cfif>
                                            
                                            <cfif isdefined("attributes.location_based_cost")>
                                                <cfif len(attributes.department_id)>
                                                    AND DEPARTMENT_ID = #listgetat(attributes.department_id,1,'-')#
                                                    AND LOCATION_ID = #listgetat(attributes.department_id,2,'-')#
                                                <cfelse>
                                                    AND DEPARTMENT_ID = SL.DEPARTMENT_ID
                                                    AND LOCATION_ID = SL.LOCATION_ID
                                                </cfif>
                                            </cfif>
                                        ORDER BY 
                                            START_DATE DESC, 
                                            RECORD_DATE DESC,
                                            PRODUCT_COST_ID DESC
                                    ),0) ALL_FINISH_COST,
                                    ISNULL(ABS(GC.STOCK_IN-GC.STOCK_OUT)*(
                                        SELECT TOP 1 
                                            <cfif isdefined("attributes.location_based_cost")>
                                                (PURCHASE_NET_SYSTEM_2_LOCATION+PURCHASE_EXTRA_COST_SYSTEM_2_LOCATION)
                                            <cfelse>
                                                (PURCHASE_NET_SYSTEM_2+PURCHASE_EXTRA_COST_SYSTEM_2)
                                            </cfif>
                                        FROM 
                                            #dsn3_alias#.PRODUCT_COST WITH (NOLOCK) 
                                        WHERE 
                                            START_DATE <= #finish_date# 
                                            AND PRODUCT_ID = GC.PRODUCT_ID
                                            <cfif attributes.report_type eq 8>
                                                 AND ISNULL(PRODUCT_COST.SPECT_MAIN_ID,0) = ISNULL(GC.SPECT_VAR_ID,0)
                                            </cfif>
                                           
                                            <cfif isdefined("attributes.location_based_cost")>
                                                <cfif len(attributes.department_id)>
                                                    AND DEPARTMENT_ID = #listgetat(attributes.department_id,1,'-')#
                                                    AND LOCATION_ID = #listgetat(attributes.department_id,2,'-')#
                                                <cfelse>
                                                    AND DEPARTMENT_ID = SL.DEPARTMENT_ID
                                                    AND LOCATION_ID = SL.LOCATION_ID
                                                </cfif>
                                            </cfif>
                                        ORDER BY 
                                            START_DATE DESC, 
                                            RECORD_DATE DESC,
                                            PRODUCT_COST_ID DESC
                                    ),0) ALL_FINISH_COST_2--->
                                FROM
                                    SHIP WITH (NOLOCK),
                                    INVOICE WITH (NOLOCK),
                                    INVOICE_SHIPS INV_S,
                                    <cfif isdefined('attributes.is_system_money_2') or attributes.cost_money is not session.ep.money>
                                    INVOICE_MONEY IM,
                                    </cfif>
                                    <cfif is_store or isdefined("attributes.location_based_cost")>
                                        <cfif attributes.report_type eq 8>
                                            GET_STOCKS_ROW_COST_SPECT_LOCATION AS GC,
                                        <cfelse>
                                            GET_STOCKS_ROW_COST_LOCATION AS GC,
                                        </cfif>
                                    <cfelse>
                                        <cfif attributes.report_type eq 8>
                                            GET_STOCKS_ROW_COST_SPECT AS GC,
                                        <cfelse>
                                            GET_STOCK_ROW_COST_TABLE AS GC,
                                        </cfif>
                                    </cfif>
                                    <cfif stock_table>
                                    #dsn3_alias#.STOCKS S,
                                    </cfif>
                                    #dsn_alias#.STOCKS_LOCATION SL
                                WHERE
                                    SHIP.SHIP_ID = INV_S.SHIP_ID
                                    AND INVOICE.INVOICE_ID= INV_S.INVOICE_ID
                                    AND INV_S.IS_WITH_SHIP = 1
                                    AND INV_S.SHIP_PERIOD_ID = #session.ep.period_id#
                                    AND SHIP.IS_WITH_SHIP=1
                                    AND SHIP.SHIP_ID = GC.UPD_ID
                                    AND SHIP.SHIP_TYPE = GC.PROCESS_TYPE
                                    AND GC.STORE = SL.DEPARTMENT_ID
                                    AND GC.STORE_LOCATION=SL.LOCATION_ID
                                    <cfif not isdefined('is_belognto_institution')>
                                    AND SL.BELONGTO_INSTITUTION = 0
                                    </cfif>
                                    <cfif isdefined('attributes.is_system_money_2') or attributes.cost_money is not session.ep.money>
                                        AND IM.ACTION_ID=INVOICE.INVOICE_ID
                                        <cfif isdefined('attributes.is_system_money_2')>
                                        AND IM.MONEY_TYPE = '#session.ep.money2#'
                                        <cfelse>
                                        AND IM.MONEY_TYPE = '#attributes.cost_money#'
                                        </cfif>
                                    </cfif>
                                    AND GC.PROCESS_DATE >= #attributes.date#
                                    AND GC.PROCESS_DATE <= #attributes.date2#
                                    <cfif len(attributes.department_id)>
                                    AND
                                        (
                                        <cfloop list="#attributes.department_id#" delimiters="," index="dept_i">
                                        (GC.STORE = #listfirst(dept_i,'-')# AND GC.STORE_LOCATION = #listlast(dept_i,'-')#)
                                        <cfif dept_i neq listlast(attributes.department_id,',') and listlen(attributes.department_id,',') gte 1> OR</cfif>
                                        </cfloop>  
                                        )
                                    <cfelseif is_store>
                                        AND GC.STORE IN (#branch_dep_list#)
                                    </cfif>
                                    <cfif stock_table>
                                    AND	GC.STOCK_ID=S.STOCK_ID
                                    </cfif>
                                    <cfif len(trim(attributes.sup_company)) and len(attributes.sup_company_id)>
                                        AND S.COMPANY_ID = #attributes.sup_company_id#
                                    </cfif>
                                    <cfif len(trim(attributes.employee_name)) and len(attributes.product_employee_id)>
                                        AND S.PRODUCT_MANAGER = #attributes.product_employee_id#
                                    </cfif>
                                    <cfif len(trim(attributes.product_name)) and len(attributes.product_id)>
                                        AND S.PRODUCT_ID = #attributes.product_id#
                                    </cfif>
                                    <cfif len(trim(attributes.brand_name)) and len(attributes.brand_id)>
                                        AND S.BRAND_ID = #attributes.brand_id# 
                                    </cfif>	
                                    <cfif len(trim(attributes.product_cat)) and len(attributes.product_code)>
                                        AND S.STOCK_CODE LIKE '#attributes.product_code#%'
                                    </cfif>
                            </cfif>
                            )AS GET_SHIP_ROWS
                        WHERE
                            ISLEM_TARIHI <= #attributes.date2#
                            AND PROCESS_TYPE = 81
                        GROUP BY
                            #ALAN_ADI#
                       )AS get_sevk_irs_total ON GET_ALL_STOCK.PRODUCT_GROUPBY_ID = get_sevk_irs_total.GROUPBY_ALANI 
		</cfif>
        <cfif len(attributes.process_type) and listfind(attributes.process_type,3)>
	        <cfif isdefined('attributes.from_invoice_actions')>
            	LEFT JOIN(
                            SELECT	
                                SUM(BIRIM_COST) AS FATURA_SATIS_TUTAR,
                                <cfif isdefined('attributes.is_system_money_2')>
                                SUM(BIRIM_COST_2) AS FATURA_SATIS_TUTAR_2,
                                </cfif>
                                <cfif isdefined('x_show_sale_inoice_cost') and x_show_sale_inoice_cost eq 1><!--- satış faturası satırlarındaki maliyet alınıyor --->
                                    SUM(INV_COST+INV_EXTRA_COST) AS FATURA_SATIS_MALIYET,
                                    <cfif isdefined('attributes.is_system_money_2')>
                                    SUM(INV_COST_2+INV_EXTRA_COST_2) AS FATURA_SATIS_MALIYET_2,
                                    </cfif>
                                </cfif>
                                SUM(ISNULL(AMOUNT,0)) AS FATURA_SATIS_MIKTAR,
                                #ALAN_ADI# AS GROUPBY_ALANI
                            FROM
                                (
                                SELECT 
                                    IR.STOCK_ID,
                                    IR.PRODUCT_ID,
                                    <cfif attributes.report_type eq 8>
                                    CAST(IR.STOCK_ID AS NVARCHAR(50)) +'_'+ CAST(ISNULL((SELECT SPECT_MAIN_ID FROM #dsn3_alias#.SPECTS SP WHERE SP.SPECT_VAR_ID = IR.SPECT_VAR_ID),0) AS NVARCHAR(50))  STOCK_SPEC_ID,
                                    </cfif>
                                    <cfif stock_table>
                                    S.PRODUCT_MANAGER,
                                    S.PRODUCT_CATID,
                                    S.BRAND_ID,
                                    </cfif>
                                    IR.AMOUNT,
                                    I.INVOICE_DATE ISLEM_TARIHI,
                                    I.INVOICE_CAT PROCESS_TYPE,
                                    <cfif isdefined('attributes.from_invoice_actions') and isdefined('x_show_sale_inoice_cost') and x_show_sale_inoice_cost eq 1><!--- satış faturası satırlarındaki maliyet alınıyor --->
                                        <cfif isdefined('attributes.is_system_money_2')>
                                            (IR.COST_PRICE* IR.AMOUNT) INV_COST,
                                            (IR.EXTRA_COST* IR.AMOUNT) INV_EXTRA_COST,
                                            ((IR.COST_PRICE* IR.AMOUNT)/(IM.RATE2/IM.RATE1)) INV_COST_2,
                                            ((IR.EXTRA_COST* IR.AMOUNT)/(IM.RATE2/IM.RATE1)) INV_EXTRA_COST_2,
                                        <cfelseif attributes.cost_money is not session.ep.money>
                                            ((IR.COST_PRICE* IR.AMOUNT)/(IM.RATE2/IM.RATE1)) INV_COST,
                                            ((IR.EXTRA_COST* IR.AMOUNT)/(IM.RATE2/IM.RATE1)) INV_EXTRA_COST,
                                        <cfelse>
                                            (IR.COST_PRICE* IR.AMOUNT) INV_COST,
                                            (IR.EXTRA_COST* IR.AMOUNT) INV_EXTRA_COST,
                                        </cfif>
                                    </cfif>
                                    <cfif isdefined('attributes.is_system_money_2') or attributes.cost_money is not session.ep.money>
                                        <cfif isdefined('attributes.is_system_money_2')>
                                        (IR.EXTRA_COST * IR.AMOUNT) EXTRA_COST,
                                        CASE WHEN I.SA_DISCOUNT=0 THEN IR.NETTOTAL ELSE ( (1- I.SA_DISCOUNT/(I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT)) * IR.NETTOTAL) END AS BIRIM_COST,
                                        ((IR.EXTRA_COST * IR.AMOUNT)/(IM.RATE2/IM.RATE1))EXTRA_COST_2,
                                        CASE WHEN I.SA_DISCOUNT=0 THEN (IR.NETTOTAL/(IM.RATE2/IM.RATE1)) ELSE (( (1- I.SA_DISCOUNT/(I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT)) * IR.NETTOTAL)/(IM.RATE2/IM.RATE1)) END AS BIRIM_COST_2
                                        <cfelse>
                                        ((IR.EXTRA_COST * IR.AMOUNT)/(IM.RATE2/IM.RATE1))EXTRA_COST,
                                        CASE WHEN I.SA_DISCOUNT=0 THEN (IR.NETTOTAL/(IM.RATE2/IM.RATE1)) ELSE (( (1- I.SA_DISCOUNT/(I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT)) * IR.NETTOTAL)/(IM.RATE2/IM.RATE1)) END AS BIRIM_COST
                                        </cfif>
                                    <cfelse>
                                        (IR.EXTRA_COST * IR.AMOUNT) EXTRA_COST,
                                        CASE WHEN I.SA_DISCOUNT=0 THEN IR.NETTOTAL ELSE (( (1- I.SA_DISCOUNT/(I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT)) * IR.NETTOTAL)) END AS BIRIM_COST
                                    </cfif>
                                FROM 
                                    INVOICE I WITH (NOLOCK),
                                    INVOICE_ROW IR WITH (NOLOCK)
                                    <cfif isdefined('attributes.is_system_money_2') or attributes.cost_money is not session.ep.money>
                                    ,INVOICE_MONEY IM
                                    </cfif>
                                    <cfif stock_table>
                                    ,#dsn3_alias#.STOCKS S
                                    </cfif>
                                WHERE 
                                    I.INVOICE_ID = IR.INVOICE_ID AND
                                    <cfif not isdefined('attributes.from_invoice_actions')>
                                    I.INVOICE_CAT IN (51,54,55,59,60,61,62,63,64,65,68,690,691,591,592) AND
                                    </cfif>
                                    I.IS_IPTAL = 0 AND
                                    I.NETTOTAL > 0 AND
                                    I.INVOICE_DATE >= #attributes.date# AND 
                                    I.INVOICE_DATE <= #attributes.date2#
                                    <cfif isdefined('attributes.is_system_money_2') or attributes.cost_money is not session.ep.money>
                                         AND I.INVOICE_ID = IM.ACTION_ID
                                        <cfif isdefined('attributes.is_system_money_2')>
                                         AND IM.MONEY_TYPE = '#session.ep.money2#'
                                        <cfelse>
                                         AND IM.MONEY_TYPE = '#attributes.cost_money#'
                                        </cfif>
                                    </cfif>
                                    <cfif stock_table>
                                    AND IR.STOCK_ID=S.STOCK_ID
                                    </cfif>
                                    <cfif len(attributes.department_id)>
                                        AND
                                        (
                                        <cfloop list="#attributes.department_id#" delimiters="," index="dept_i">
                                        (I.DEPARTMENT_ID = #listfirst(dept_i,'-')# AND I.DEPARTMENT_LOCATION = #listlast(dept_i,'-')#)
                                        <cfif dept_i neq listlast(attributes.department_id,',') and listlen(attributes.department_id,',') gte 1> OR</cfif>
                                        </cfloop>  
                                        )
                                     <cfelseif is_store>
                                        AND I.DEPARTMENT_ID IN (#branch_dep_list#)
                                    </cfif>
                                    <cfif len(trim(attributes.sup_company)) and len(attributes.sup_company_id)>
                                        AND S.COMPANY_ID = #attributes.sup_company_id#
                                    </cfif>
                                    <cfif len(trim(attributes.employee_name)) and len(attributes.product_employee_id)>
                                        AND S.PRODUCT_MANAGER = #attributes.product_employee_id#
                                    </cfif>
                                    <cfif len(trim(attributes.product_name)) and len(attributes.product_id)>
                                        AND S.PRODUCT_ID = #attributes.product_id#
                                    </cfif>
                                    <cfif len(trim(attributes.brand_name)) and len(attributes.brand_id)>
                                        AND S.BRAND_ID = #attributes.brand_id# 
                                    </cfif>	
                                    <cfif len(trim(attributes.product_cat)) and len(attributes.product_code)>
                                        AND S.STOCK_CODE LIKE '#attributes.product_code#%'
                                    </cfif>
                                ) AS GET_INV_PURCHASE
                            WHERE
                                PROCESS_TYPE IN (52,53,531) 
                            GROUP BY
                                #ALAN_ADI#
                              ) AS d_fatura_satis_tutar ON GET_ALL_STOCK.PRODUCT_GROUPBY_ID = d_fatura_satis_tutar.GROUPBY_ALANI
                LEFT JOIN(
                            SELECT	
                                SUM(BIRIM_COST) AS FATURA_SATIS_IADE_TUTAR,
                                <cfif isdefined('attributes.is_system_money_2')>
                                SUM(BIRIM_COST_2) AS FATURA_SATIS_IADE_TUTAR_2,
                                </cfif>
                                <cfif isdefined('x_show_sale_inoice_cost') and x_show_sale_inoice_cost eq 1><!--- satış faturası satırlarındaki maliyet alınıyor --->
                                    SUM(INV_COST+INV_EXTRA_COST) AS  FATURA_SATIS_IADE_MALIYET,
                                    <cfif isdefined('attributes.is_system_money_2')>
                                        SUM(INV_COST_2+INV_EXTRA_COST_2) AS FATURA_SATIS_IADE_MALIYET_2,
                                    </cfif>
                                </cfif>
                                SUM(AMOUNT) AS FATURA_SATIS_IADE_MIKTAR,
                                #ALAN_ADI# AS GROUPBY_ALANI
                            FROM
                                (
                                SELECT 
                                    IR.STOCK_ID,
                                    IR.PRODUCT_ID,
                                    <cfif attributes.report_type eq 8>
                                    CAST(IR.STOCK_ID AS NVARCHAR(50)) +'_'+ CAST(ISNULL((SELECT SPECT_MAIN_ID FROM #dsn3_alias#.SPECTS SP WHERE SP.SPECT_VAR_ID = IR.SPECT_VAR_ID),0) AS NVARCHAR(50))  STOCK_SPEC_ID,
                                    </cfif>
                                    <cfif stock_table>
                                    S.PRODUCT_MANAGER,
                                    S.PRODUCT_CATID,
                                    S.BRAND_ID,
                                    </cfif>
                                    IR.AMOUNT,
                                    I.INVOICE_DATE ISLEM_TARIHI,
                                    I.INVOICE_CAT PROCESS_TYPE,
                                    <cfif isdefined('attributes.from_invoice_actions') and isdefined('x_show_sale_inoice_cost') and x_show_sale_inoice_cost eq 1><!--- satış faturası satırlarındaki maliyet alınıyor --->
                                        <cfif isdefined('attributes.is_system_money_2')>
                                            (IR.COST_PRICE* IR.AMOUNT) INV_COST,
                                            (IR.EXTRA_COST* IR.AMOUNT) INV_EXTRA_COST,
                                            ((IR.COST_PRICE* IR.AMOUNT)/(IM.RATE2/IM.RATE1)) INV_COST_2,
                                            ((IR.EXTRA_COST* IR.AMOUNT)/(IM.RATE2/IM.RATE1)) INV_EXTRA_COST_2,
                                        <cfelseif attributes.cost_money is not session.ep.money>
                                            ((IR.COST_PRICE* IR.AMOUNT)/(IM.RATE2/IM.RATE1)) INV_COST,
                                            ((IR.EXTRA_COST* IR.AMOUNT)/(IM.RATE2/IM.RATE1)) INV_EXTRA_COST,
                                        <cfelse>
                                            (IR.COST_PRICE* IR.AMOUNT) INV_COST,
                                            (IR.EXTRA_COST* IR.AMOUNT) INV_EXTRA_COST,
                                        </cfif>
                                    </cfif>
                                    <cfif isdefined('attributes.is_system_money_2') or attributes.cost_money is not session.ep.money>
                                        <cfif isdefined('attributes.is_system_money_2')>
                                        (IR.EXTRA_COST * IR.AMOUNT) EXTRA_COST,
                                        CASE WHEN I.SA_DISCOUNT=0 THEN IR.NETTOTAL ELSE ( (1- I.SA_DISCOUNT/(I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT)) * IR.NETTOTAL) END AS BIRIM_COST,
                                        ((IR.EXTRA_COST * IR.AMOUNT)/(IM.RATE2/IM.RATE1))EXTRA_COST_2,
                                        CASE WHEN I.SA_DISCOUNT=0 THEN (IR.NETTOTAL/(IM.RATE2/IM.RATE1)) ELSE (( (1- I.SA_DISCOUNT/(I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT)) * IR.NETTOTAL)/(IM.RATE2/IM.RATE1)) END AS BIRIM_COST_2
                                        <cfelse>
                                        ((IR.EXTRA_COST * IR.AMOUNT)/(IM.RATE2/IM.RATE1))EXTRA_COST,
                                        CASE WHEN I.SA_DISCOUNT=0 THEN (IR.NETTOTAL/(IM.RATE2/IM.RATE1)) ELSE (( (1- I.SA_DISCOUNT/(I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT)) * IR.NETTOTAL)/(IM.RATE2/IM.RATE1)) END AS BIRIM_COST
                                        </cfif>
                                    <cfelse>
                                        (IR.EXTRA_COST * IR.AMOUNT) EXTRA_COST,
                                        CASE WHEN I.SA_DISCOUNT=0 THEN IR.NETTOTAL ELSE (( (1- I.SA_DISCOUNT/(I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT)) * IR.NETTOTAL)) END AS BIRIM_COST
                                    </cfif>
                                FROM 
                                    INVOICE I WITH (NOLOCK),
                                    INVOICE_ROW IR WITH (NOLOCK)
                                    <cfif isdefined('attributes.is_system_money_2') or attributes.cost_money is not session.ep.money>
                                    ,INVOICE_MONEY IM
                                    </cfif>
                                    <cfif stock_table>
                                    ,#dsn3_alias#.STOCKS S
                                    </cfif>
                                WHERE 
                                    I.INVOICE_ID = IR.INVOICE_ID AND
                                    <cfif not isdefined('attributes.from_invoice_actions')>
                                    I.INVOICE_CAT IN (51,54,55,59,60,61,62,63,64,65,68,690,691,591,592) AND
                                    </cfif>
                                    I.IS_IPTAL = 0 AND
                                    I.NETTOTAL > 0 AND
                                    I.INVOICE_DATE >= #attributes.date# AND 
                                    I.INVOICE_DATE <= #attributes.date2#
                                    <cfif isdefined('attributes.is_system_money_2') or attributes.cost_money is not session.ep.money>
                                         AND I.INVOICE_ID = IM.ACTION_ID
                                        <cfif isdefined('attributes.is_system_money_2')>
                                         AND IM.MONEY_TYPE = '#session.ep.money2#'
                                        <cfelse>
                                         AND IM.MONEY_TYPE = '#attributes.cost_money#'
                                        </cfif>
                                    </cfif>
                                    <cfif stock_table>
                                    AND IR.STOCK_ID=S.STOCK_ID
                                    </cfif>
                                    <cfif len(attributes.department_id)>
                                        AND
                                        (
                                        <cfloop list="#attributes.department_id#" delimiters="," index="dept_i">
                                        (I.DEPARTMENT_ID = #listfirst(dept_i,'-')# AND I.DEPARTMENT_LOCATION = #listlast(dept_i,'-')#)
                                        <cfif dept_i neq listlast(attributes.department_id,',') and listlen(attributes.department_id,',') gte 1> OR</cfif>
                                        </cfloop>  
                                        )
                                     <cfelseif is_store>
                                        AND I.DEPARTMENT_ID IN (#branch_dep_list#)
                                    </cfif>
                                    <cfif len(trim(attributes.sup_company)) and len(attributes.sup_company_id)>
                                        AND S.COMPANY_ID = #attributes.sup_company_id#
                                    </cfif>
                                    <cfif len(trim(attributes.employee_name)) and len(attributes.product_employee_id)>
                                        AND S.PRODUCT_MANAGER = #attributes.product_employee_id#
                                    </cfif>
                                    <cfif len(trim(attributes.product_name)) and len(attributes.product_id)>
                                        AND S.PRODUCT_ID = #attributes.product_id#
                                    </cfif>
                                    <cfif len(trim(attributes.brand_name)) and len(attributes.brand_id)>
                                        AND S.BRAND_ID = #attributes.brand_id# 
                                    </cfif>	
                                    <cfif len(trim(attributes.product_cat)) and len(attributes.product_code)>
                                        AND S.STOCK_CODE LIKE '#attributes.product_code#%'
                                    </cfif>
                                ) AS GET_INV_PURCHASE
                            WHERE
                                PROCESS_TYPE IN (54,55) 
                            GROUP BY
                                #ALAN_ADI#
                          ) AS d_fatura_satis_iade_tutar ON GET_ALL_STOCK.PRODUCT_GROUPBY_ID = d_fatura_satis_iade_tutar.GROUPBY_ALANI 
            </cfif>
            LEFT JOIN (
                        SELECT	
                            SUM(AMOUNT) AS TOPLAM_SATIS,
                            SUM(TOTAL_COST) AS TOPLAM_SATIS_MALIYET,
                            <cfif isdefined('attributes.is_system_money_2')>
                            SUM(TOTAL_COST_2) AS TOPLAM_SATIS_MALIYET_2,
                            </cfif>
                            #ALAN_ADI# AS GROUPBY_ALANI
                        FROM
                            (
                                SELECT
                                    GC.STOCK_ID,
                                    GC.PRODUCT_ID,
                                    <cfif attributes.report_type eq 8>
                                    CAST(GC.STOCK_ID AS NVARCHAR(50)) +'_'+ CAST(ISNULL(GC.SPECT_VAR_ID,0) AS NVARCHAR(50)) STOCK_SPEC_ID,
                                    </cfif>
                                    1 AS INVOICE_CAT,
                                    <cfif stock_table>
                                    S.PRODUCT_MANAGER,
                                    S.PRODUCT_CATID,
                                    S.BRAND_ID,
                                    </cfif>
                                    <cfif isdefined('attributes.is_system_money_2')>
                                    GC.MALIYET_2,
                                    GC.MALIYET,
                                    ((GC.MALIYET_2*ABS(GC.STOCK_IN-GC.STOCK_OUT))) AS TOTAL_COST_2,
                                    (GC.MALIYET*ABS(GC.STOCK_IN-GC.STOCK_OUT)) AS TOTAL_COST,
                                    <cfelse>
                                        <cfif attributes.cost_money is not session.ep.money>
                                        (GC.MALIYET/(SM.RATE2/SM.RATE1)) AS MALIYET,
                                        ((GC.MALIYET*ABS(GC.STOCK_IN-GC.STOCK_OUT))/(SM.RATE2/SM.RATE1)) AS TOTAL_COST,
                                        <cfelse>
                                        GC.MALIYET,
                                        (GC.MALIYET*ABS(GC.STOCK_IN-GC.STOCK_OUT)) AS TOTAL_COST,				
                                        </cfif>
                                    </cfif>
                                    ABS(GC.STOCK_IN-GC.STOCK_OUT) AS AMOUNT,
                                    GC.STOCK_IN,
                                    GC.STOCK_OUT,
                                    GC.PROCESS_DATE ISLEM_TARIHI,
                                    GC.PROCESS_TYPE PROCESS_TYPE
                                    <!---ISNULL(ABS(GC.STOCK_IN-GC.STOCK_OUT)*(
                                        SELECT TOP 1 
                                            <cfif isdefined("attributes.location_based_cost")>
                                                <cfif isdefined("attributes.display_cost_money")>
                                                    (PURCHASE_NET_LOCATION+PURCHASE_EXTRA_COST_LOCATION)
                                                <cfelse>
                                                    (PURCHASE_NET_SYSTEM_LOCATION+PURCHASE_EXTRA_COST_SYSTEM_LOCATION)
                                                </cfif>
                                            <cfelse>
                                                <cfif isdefined("attributes.display_cost_money")>
                                                    (PURCHASE_NET+PURCHASE_EXTRA_COST)
                                                <cfelse>
                                                    (PURCHASE_NET_SYSTEM+PURCHASE_EXTRA_COST_SYSTEM)
                                                </cfif>	
                                            </cfif>
                                        FROM 
                                            #dsn3_alias#.PRODUCT_COST WITH (NOLOCK) 
                                        WHERE 
                                            START_DATE <= #finish_date# 
                                            AND PRODUCT_ID = GC.PRODUCT_ID
                                            <cfif attributes.report_type eq 8>
                                                 AND ISNULL(PRODUCT_COST.SPECT_MAIN_ID,0) = ISNULL(GC.SPECT_VAR_ID,0)
                                            </cfif>
                                            
                                            <cfif isdefined("attributes.location_based_cost")>
                                                <cfif len(attributes.department_id)>
                                                    AND DEPARTMENT_ID = #listgetat(attributes.department_id,1,'-')#
                                                    AND LOCATION_ID = #listgetat(attributes.department_id,2,'-')#
                                                <cfelse>
                                                    AND DEPARTMENT_ID = SL.DEPARTMENT_ID
                                                    AND LOCATION_ID = SL.LOCATION_ID
                                                </cfif>
                                            </cfif>
                                        ORDER BY 
                                            START_DATE DESC, 
                                            RECORD_DATE DESC,
                                            PRODUCT_COST_ID DESC
                                    ),0) ALL_FINISH_COST,
                                    ISNULL(ABS(GC.STOCK_IN-GC.STOCK_OUT)*(
                                        SELECT TOP 1 
                                            <cfif isdefined("attributes.location_based_cost")>
                                                (PURCHASE_NET_SYSTEM_2_LOCATION+PURCHASE_EXTRA_COST_SYSTEM_2_LOCATION)
                                            <cfelse>
                                                (PURCHASE_NET_SYSTEM_2+PURCHASE_EXTRA_COST_SYSTEM_2)
                                            </cfif>
                                        FROM 
                                            #dsn3_alias#.PRODUCT_COST WITH (NOLOCK) 
                                        WHERE 
                                            START_DATE <= #finish_date# 
                                            AND PRODUCT_ID = GC.PRODUCT_ID
                                            <cfif attributes.report_type eq 8>
                                                 AND ISNULL(PRODUCT_COST.SPECT_MAIN_ID,0) = ISNULL(GC.SPECT_VAR_ID,0)
                                            </cfif>
                                            
                                            <cfif isdefined("attributes.location_based_cost")>
                                                <cfif len(attributes.department_id)>
                                                    AND DEPARTMENT_ID = #listgetat(attributes.department_id,1,'-')#
                                                    AND LOCATION_ID = #listgetat(attributes.department_id,2,'-')#
                                                <cfelse>
                                                    AND DEPARTMENT_ID = SL.DEPARTMENT_ID
                                                    AND LOCATION_ID = SL.LOCATION_ID
                                                </cfif>
                                            </cfif>
                                        ORDER BY 
                                            START_DATE DESC, 
                                            RECORD_DATE DESC,
                                            PRODUCT_COST_ID DESC
                                    ),0) ALL_FINISH_COST_2--->
                                FROM
                                    <cfif is_store or isdefined("attributes.location_based_cost")>
                                        <cfif attributes.report_type eq 8>
                                            GET_STOCKS_ROW_COST_SPECT_LOCATION AS GC,
                                        <cfelse>
                                            GET_STOCKS_ROW_COST_LOCATION AS GC,
                                        </cfif>
                                    <cfelse>
                                        <cfif attributes.report_type eq 8>
                                            GET_STOCKS_ROW_COST_SPECT AS GC,
                                        <cfelse>
                                            GET_STOCK_ROW_COST_TABLE AS GC,
                                        </cfif>
                                    </cfif>
                                    <cfif attributes.cost_money is not session.ep.money or isdefined('attributes.is_system_money_2') or listfind(attributes.process_type,3)>
                                    SHIP WITH (NOLOCK),	
                                    </cfif>
                                    <cfif attributes.cost_money is not session.ep.money or isdefined('attributes.is_system_money_2')>
                                    SHIP_MONEY SM,
                                    </cfif>
                                    <cfif stock_table>
                                    #dsn3_alias#.STOCKS S,
                                    </cfif>
                                    #dsn_alias#.STOCKS_LOCATION SL
                                WHERE
                                    GC.STORE = SL.DEPARTMENT_ID
                                    AND GC.STORE_LOCATION=SL.LOCATION_ID
                                    <cfif not isdefined('is_belognto_institution')>
                                    AND SL.BELONGTO_INSTITUTION = 0
                                    </cfif>
                                    <cfif attributes.cost_money is not session.ep.money or isdefined('attributes.is_system_money_2') or listfind(attributes.process_type,3)>
                                    AND GC.UPD_ID = SHIP.SHIP_ID
                                    AND SHIP.SHIP_TYPE = GC.PROCESS_TYPE
                                    AND ISNULL(SHIP.IS_WITH_SHIP,0)=0
                                    </cfif>
                                    <cfif attributes.cost_money is not session.ep.money or isdefined('attributes.is_system_money_2')>
                                    AND SHIP.SHIP_ID = SM.ACTION_ID
                                        <cfif isdefined('attributes.is_system_money_2')>
                                            AND SM.MONEY_TYPE = '#session.ep.money2#'
                                        <cfelse>
                                            AND SM.MONEY_TYPE = '#attributes.cost_money#'
                                        </cfif>
                                    </cfif>
                                    AND GC.PROCESS_DATE >= #attributes.date#
                                    AND GC.PROCESS_DATE <= #attributes.date2#
                                    <cfif len(attributes.department_id)>
                                    AND
                                        (
                                        <cfloop list="#attributes.department_id#" delimiters="," index="dept_i">
                                        (GC.STORE = #listfirst(dept_i,'-')# AND GC.STORE_LOCATION = #listlast(dept_i,'-')#)
                                        <cfif dept_i neq listlast(attributes.department_id,',') and listlen(attributes.department_id,',') gte 1> OR</cfif>
                                        </cfloop>  
                                        )
                                    <cfelseif is_store>
                                        AND GC.STORE IN (#branch_dep_list#)
                                    </cfif>
                                    <cfif stock_table>
                                    AND	GC.STOCK_ID=S.STOCK_ID
                                    </cfif>
                                    <cfif len(trim(attributes.sup_company)) and len(attributes.sup_company_id)>
                                    AND S.COMPANY_ID = #attributes.sup_company_id#
                                    </cfif>
                                    <cfif len(trim(attributes.employee_name)) and len(attributes.product_employee_id)>
                                    AND S.PRODUCT_MANAGER = #attributes.product_employee_id#
                                    </cfif>
                                    <cfif len(trim(attributes.product_name)) and len(attributes.product_id)>
                                    AND S.PRODUCT_ID = #attributes.product_id#
                                    </cfif>
                                    <cfif len(trim(attributes.brand_name)) and len(attributes.brand_id)>
                                    AND S.BRAND_ID = #attributes.brand_id# 
                                    </cfif>	
                                    <cfif len(trim(attributes.product_cat)) and len(attributes.product_code)>
                                    AND S.STOCK_CODE LIKE '#attributes.product_code#%'
                                    </cfif>
                            <cfif attributes.cost_money is not session.ep.money or listfind(attributes.process_type,3)>
                            UNION ALL
                                SELECT
                                    GC.STOCK_ID,
                                    GC.PRODUCT_ID,
                                    <cfif attributes.report_type eq 8>
                                    CAST(GC.STOCK_ID AS NVARCHAR(50)) +'_'+ CAST(ISNULL(GC.SPECT_VAR_ID,0) AS NVARCHAR(50)) STOCK_SPEC_ID,
                                    </cfif>
                                    INVOICE.INVOICE_CAT,
                                    <cfif stock_table>
                                    S.PRODUCT_MANAGER,
                                    S.PRODUCT_CATID,
                                    S.BRAND_ID,
                                    </cfif>
                                    <cfif isdefined('attributes.is_system_money_2') or attributes.cost_money is not session.ep.money>
                                        <cfif isdefined('attributes.is_system_money_2')>
                                        GC.MALIYET_2,
                                        GC.MALIYET,
                                        ((GC.MALIYET_2*ABS(GC.STOCK_IN-GC.STOCK_OUT))) AS TOTAL_COST_2,
                                        (GC.MALIYET*ABS(GC.STOCK_IN-GC.STOCK_OUT)) AS TOTAL_COST,
                                        <cfelse>
                                            (GC.MALIYET/(IM.RATE2/IM.RATE1)) AS MALIYET,
                                            ((GC.MALIYET*ABS(GC.STOCK_IN-GC.STOCK_OUT))/(IM.RATE2/IM.RATE1)) AS TOTAL_COST,
                                        </cfif>
                                    <cfelse>
                                        (GC.MALIYET) AS MALIYET,
                                        ((GC.MALIYET*ABS(GC.STOCK_IN-GC.STOCK_OUT))) AS TOTAL_COST,
                                    </cfif>
                                    ABS(GC.STOCK_IN-GC.STOCK_OUT) AS AMOUNT,
                                    GC.STOCK_IN,
                                    GC.STOCK_OUT,
                                    GC.PROCESS_DATE ISLEM_TARIHI,
                                    GC.PROCESS_TYPE PROCESS_TYPE
                                   <!--- ISNULL(ABS(GC.STOCK_IN-GC.STOCK_OUT)*(
                                        SELECT TOP 1 
                                            <cfif isdefined("attributes.location_based_cost")>
                                                <cfif isdefined("attributes.display_cost_money")>
                                                    (PURCHASE_NET_LOCATION+PURCHASE_EXTRA_COST_LOCATION)
                                                <cfelse>
                                                    (PURCHASE_NET_SYSTEM_LOCATION+PURCHASE_EXTRA_COST_SYSTEM_LOCATION)
                                                </cfif>
                                            <cfelse>
                                                <cfif isdefined("attributes.display_cost_money")>
                                                    (PURCHASE_NET+PURCHASE_EXTRA_COST)
                                                <cfelse>
                                                    (PURCHASE_NET_SYSTEM+PURCHASE_EXTRA_COST_SYSTEM)
                                                </cfif>	
                                            </cfif>
                                        FROM 
                                            #dsn3_alias#.PRODUCT_COST WITH (NOLOCK) 
                                        WHERE 
                                            START_DATE <= #finish_date# 
                                            AND PRODUCT_ID = GC.PRODUCT_ID
                                            <cfif attributes.report_type eq 8>
                                                 AND ISNULL(PRODUCT_COST.SPECT_MAIN_ID,0) = ISNULL(GC.SPECT_VAR_ID,0)
                                            </cfif>
                                           
                                            <cfif isdefined("attributes.location_based_cost")>
                                                <cfif len(attributes.department_id)>
                                                    AND DEPARTMENT_ID = #listgetat(attributes.department_id,1,'-')#
                                                    AND LOCATION_ID = #listgetat(attributes.department_id,2,'-')#
                                                <cfelse>
                                                    AND DEPARTMENT_ID = SL.DEPARTMENT_ID
                                                    AND LOCATION_ID = SL.LOCATION_ID
                                                </cfif>
                                            </cfif>
                                        ORDER BY 
                                            START_DATE DESC, 
                                            RECORD_DATE DESC,
                                            PRODUCT_COST_ID DESC
                                    ),0) ALL_FINISH_COST,
                                    ISNULL(ABS(GC.STOCK_IN-GC.STOCK_OUT)*(
                                        SELECT TOP 1 
                                            <cfif isdefined("attributes.location_based_cost")>
                                                (PURCHASE_NET_SYSTEM_2_LOCATION+PURCHASE_EXTRA_COST_SYSTEM_2_LOCATION)
                                            <cfelse>
                                                (PURCHASE_NET_SYSTEM_2+PURCHASE_EXTRA_COST_SYSTEM_2)
                                            </cfif>
                                        FROM 
                                            #dsn3_alias#.PRODUCT_COST WITH (NOLOCK) 
                                        WHERE 
                                            START_DATE <= #finish_date# 
                                            AND PRODUCT_ID = GC.PRODUCT_ID
                                            <cfif attributes.report_type eq 8>
                                                 AND ISNULL(PRODUCT_COST.SPECT_MAIN_ID,0) = ISNULL(GC.SPECT_VAR_ID,0)
                                            </cfif>
                                            
                                            <cfif isdefined("attributes.location_based_cost")>
                                                <cfif len(attributes.department_id)>
                                                    AND DEPARTMENT_ID = #listgetat(attributes.department_id,1,'-')#
                                                    AND LOCATION_ID = #listgetat(attributes.department_id,2,'-')#
                                                <cfelse>
                                                    AND DEPARTMENT_ID = SL.DEPARTMENT_ID
                                                    AND LOCATION_ID = SL.LOCATION_ID
                                                </cfif>
                                            </cfif>
                                        ORDER BY 
                                            START_DATE DESC, 
                                            RECORD_DATE DESC,
                                            PRODUCT_COST_ID DESC
                                    ),0) ALL_FINISH_COST_2--->
                                FROM
                                    SHIP WITH (NOLOCK),
                                    INVOICE WITH (NOLOCK),
                                    INVOICE_SHIPS INV_S,
                                    <cfif isdefined('attributes.is_system_money_2') or attributes.cost_money is not session.ep.money>
                                    INVOICE_MONEY IM,
                                    </cfif>
                                    <cfif is_store or isdefined("attributes.location_based_cost")>
                                        <cfif attributes.report_type eq 8>
                                            GET_STOCKS_ROW_COST_SPECT_LOCATION AS GC,
                                        <cfelse>
                                            GET_STOCKS_ROW_COST_LOCATION AS GC,
                                        </cfif>
                                    <cfelse>
                                        <cfif attributes.report_type eq 8>
                                            GET_STOCKS_ROW_COST_SPECT AS GC,
                                        <cfelse>
                                            GET_STOCK_ROW_COST_TABLE AS GC,
                                        </cfif>
                                    </cfif>
                                    <cfif stock_table>
                                    #dsn3_alias#.STOCKS S,
                                    </cfif>
                                    #dsn_alias#.STOCKS_LOCATION SL
                                WHERE
                                    SHIP.SHIP_ID = INV_S.SHIP_ID
                                    AND INVOICE.INVOICE_ID= INV_S.INVOICE_ID
                                    AND INV_S.IS_WITH_SHIP = 1
                                    AND INV_S.SHIP_PERIOD_ID = #session.ep.period_id#
                                    AND SHIP.IS_WITH_SHIP=1
                                    AND SHIP.SHIP_ID = GC.UPD_ID
                                    AND SHIP.SHIP_TYPE = GC.PROCESS_TYPE
                                    AND GC.STORE = SL.DEPARTMENT_ID
                                    AND GC.STORE_LOCATION=SL.LOCATION_ID
                                    <cfif not isdefined('is_belognto_institution')>
                                    AND SL.BELONGTO_INSTITUTION = 0
                                    </cfif>
                                    <cfif isdefined('attributes.is_system_money_2') or attributes.cost_money is not session.ep.money>
                                        AND IM.ACTION_ID=INVOICE.INVOICE_ID
                                        <cfif isdefined('attributes.is_system_money_2')>
                                        AND IM.MONEY_TYPE = '#session.ep.money2#'
                                        <cfelse>
                                        AND IM.MONEY_TYPE = '#attributes.cost_money#'
                                        </cfif>
                                    </cfif>
                                    AND GC.PROCESS_DATE >= #attributes.date#
                                    AND GC.PROCESS_DATE <= #attributes.date2#
                                    <cfif len(attributes.department_id)>
                                    AND
                                        (
                                        <cfloop list="#attributes.department_id#" delimiters="," index="dept_i">
                                        (GC.STORE = #listfirst(dept_i,'-')# AND GC.STORE_LOCATION = #listlast(dept_i,'-')#)
                                        <cfif dept_i neq listlast(attributes.department_id,',') and listlen(attributes.department_id,',') gte 1> OR</cfif>
                                        </cfloop>  
                                        )
                                    <cfelseif is_store>
                                        AND GC.STORE IN (#branch_dep_list#)
                                    </cfif>
                                    <cfif stock_table>
                                    AND	GC.STOCK_ID=S.STOCK_ID
                                    </cfif>
                                    <cfif len(trim(attributes.sup_company)) and len(attributes.sup_company_id)>
                                        AND S.COMPANY_ID = #attributes.sup_company_id#
                                    </cfif>
                                    <cfif len(trim(attributes.employee_name)) and len(attributes.product_employee_id)>
                                        AND S.PRODUCT_MANAGER = #attributes.product_employee_id#
                                    </cfif>
                                    <cfif len(trim(attributes.product_name)) and len(attributes.product_id)>
                                        AND S.PRODUCT_ID = #attributes.product_id#
                                    </cfif>
                                    <cfif len(trim(attributes.brand_name)) and len(attributes.brand_id)>
                                        AND S.BRAND_ID = #attributes.brand_id# 
                                    </cfif>	
                                    <cfif len(trim(attributes.product_cat)) and len(attributes.product_code)>
                                        AND S.STOCK_CODE LIKE '#attributes.product_code#%'
                                    </cfif>
                            </cfif>
                            )AS GET_SHIP_ROWS
                        WHERE
                            PROCESS_TYPE IN (70,71,88)
                        GROUP BY
                            #ALAN_ADI#
                        )AS d_satis ON GET_ALL_STOCK.PRODUCT_GROUPBY_ID = d_satis.GROUPBY_ALANI
                    LEFT JOIN (
                        SELECT	
                            SUM(AMOUNT) AS TOPLAM_SATIS_IADE,
                            SUM(TOTAL_COST) AS TOP_SAT_IADE_MALIYET,
                            <cfif isdefined('attributes.is_system_money_2')>
                            SUM(TOTAL_COST_2) AS TOP_SAT_IADE_MALIYET_2,
                            </cfif>
                            #ALAN_ADI# AS GROUPBY_ALANI
                        FROM
                            (
                                SELECT
                                    GC.STOCK_ID,
                                    GC.PRODUCT_ID,
                                    <cfif attributes.report_type eq 8>
                                    CAST(GC.STOCK_ID AS NVARCHAR(50)) +'_'+ CAST(ISNULL(GC.SPECT_VAR_ID,0) AS NVARCHAR(50)) STOCK_SPEC_ID,
                                    </cfif>
                                    1 AS INVOICE_CAT,
                                    <cfif stock_table>
                                    S.PRODUCT_MANAGER,
                                    S.PRODUCT_CATID,
                                    S.BRAND_ID,
                                    </cfif>
                                    <cfif isdefined('attributes.is_system_money_2')>
                                    GC.MALIYET_2,
                                    GC.MALIYET,
                                    ((GC.MALIYET_2*ABS(GC.STOCK_IN-GC.STOCK_OUT))) AS TOTAL_COST_2,
                                    (GC.MALIYET*ABS(GC.STOCK_IN-GC.STOCK_OUT)) AS TOTAL_COST,
                                    <cfelse>
                                        <cfif attributes.cost_money is not session.ep.money>
                                        (GC.MALIYET/(SM.RATE2/SM.RATE1)) AS MALIYET,
                                        ((GC.MALIYET*ABS(GC.STOCK_IN-GC.STOCK_OUT))/(SM.RATE2/SM.RATE1)) AS TOTAL_COST,
                                        <cfelse>
                                        GC.MALIYET,
                                        (GC.MALIYET*ABS(GC.STOCK_IN-GC.STOCK_OUT)) AS TOTAL_COST,				
                                        </cfif>
                                    </cfif>
                                    ABS(GC.STOCK_IN-GC.STOCK_OUT) AS AMOUNT,
                                    GC.STOCK_IN,
                                    GC.STOCK_OUT,
                                    GC.PROCESS_DATE ISLEM_TARIHI,
                                    GC.PROCESS_TYPE PROCESS_TYPE
                                    <!---ISNULL(ABS(GC.STOCK_IN-GC.STOCK_OUT)*(
                                        SELECT TOP 1 
                                            <cfif isdefined("attributes.location_based_cost")>
                                                <cfif isdefined("attributes.display_cost_money")>
                                                    (PURCHASE_NET_LOCATION+PURCHASE_EXTRA_COST_LOCATION)
                                                <cfelse>
                                                    (PURCHASE_NET_SYSTEM_LOCATION+PURCHASE_EXTRA_COST_SYSTEM_LOCATION)
                                                </cfif>
                                            <cfelse>
                                                <cfif isdefined("attributes.display_cost_money")>
                                                    (PURCHASE_NET+PURCHASE_EXTRA_COST)
                                                <cfelse>
                                                    (PURCHASE_NET_SYSTEM+PURCHASE_EXTRA_COST_SYSTEM)
                                                </cfif>	
                                            </cfif>
                                        FROM 
                                            #dsn3_alias#.PRODUCT_COST WITH (NOLOCK) 
                                        WHERE 
                                            START_DATE <= #finish_date# 
                                            AND PRODUCT_ID = GC.PRODUCT_ID
                                            <cfif attributes.report_type eq 8>
                                                 AND ISNULL(PRODUCT_COST.SPECT_MAIN_ID,0) = ISNULL(GC.SPECT_VAR_ID,0)
                                            </cfif>
                                           
                                            <cfif isdefined("attributes.location_based_cost")>
                                                <cfif len(attributes.department_id)>
                                                    AND DEPARTMENT_ID = #listgetat(attributes.department_id,1,'-')#
                                                    AND LOCATION_ID = #listgetat(attributes.department_id,2,'-')#
                                                <cfelse>
                                                    AND DEPARTMENT_ID = SL.DEPARTMENT_ID
                                                    AND LOCATION_ID = SL.LOCATION_ID
                                                </cfif>
                                            </cfif>
                                        ORDER BY 
                                            START_DATE DESC, 
                                            RECORD_DATE DESC,
                                            PRODUCT_COST_ID DESC
                                    ),0) ALL_FINISH_COST,
                                    ISNULL(ABS(GC.STOCK_IN-GC.STOCK_OUT)*(
                                        SELECT TOP 1 
                                            <cfif isdefined("attributes.location_based_cost")>
                                                (PURCHASE_NET_SYSTEM_2_LOCATION+PURCHASE_EXTRA_COST_SYSTEM_2_LOCATION)
                                            <cfelse>
                                                (PURCHASE_NET_SYSTEM_2+PURCHASE_EXTRA_COST_SYSTEM_2)
                                            </cfif>
                                        FROM 
                                            #dsn3_alias#.PRODUCT_COST WITH (NOLOCK) 
                                        WHERE 
                                            START_DATE <= #finish_date# 
                                            AND PRODUCT_ID = GC.PRODUCT_ID
                                            <cfif attributes.report_type eq 8>
                                                 AND ISNULL(PRODUCT_COST.SPECT_MAIN_ID,0) = ISNULL(GC.SPECT_VAR_ID,0)
                                            </cfif>
                                            
                                            <cfif isdefined("attributes.location_based_cost")>
                                                <cfif len(attributes.department_id)>
                                                    AND DEPARTMENT_ID = #listgetat(attributes.department_id,1,'-')#
                                                    AND LOCATION_ID = #listgetat(attributes.department_id,2,'-')#
                                                <cfelse>
                                                    AND DEPARTMENT_ID = SL.DEPARTMENT_ID
                                                    AND LOCATION_ID = SL.LOCATION_ID
                                                </cfif>
                                            </cfif>
                                        ORDER BY 
                                            START_DATE DESC, 
                                            RECORD_DATE DESC,
                                            PRODUCT_COST_ID DESC
                                    ),0) ALL_FINISH_COST_2--->
                                FROM
                                    <cfif is_store or isdefined("attributes.location_based_cost")>
                                        <cfif attributes.report_type eq 8>
                                            GET_STOCKS_ROW_COST_SPECT_LOCATION AS GC,
                                        <cfelse>
                                            GET_STOCKS_ROW_COST_LOCATION AS GC,
                                        </cfif>
                                    <cfelse>
                                        <cfif attributes.report_type eq 8>
                                            GET_STOCKS_ROW_COST_SPECT AS GC,
                                        <cfelse>
                                            GET_STOCK_ROW_COST_TABLE AS GC,
                                        </cfif>
                                    </cfif>
                                    <cfif attributes.cost_money is not session.ep.money or isdefined('attributes.is_system_money_2') or listfind(attributes.process_type,3)>
                                    SHIP WITH (NOLOCK),	
                                    </cfif>
                                    <cfif attributes.cost_money is not session.ep.money or isdefined('attributes.is_system_money_2')>
                                    SHIP_MONEY SM,
                                    </cfif>
                                    <cfif stock_table>
                                    #dsn3_alias#.STOCKS S,
                                    </cfif>
                                    #dsn_alias#.STOCKS_LOCATION SL
                                WHERE
                                    GC.STORE = SL.DEPARTMENT_ID
                                    AND GC.STORE_LOCATION=SL.LOCATION_ID
                                    <cfif not isdefined('is_belognto_institution')>
                                    AND SL.BELONGTO_INSTITUTION = 0
                                    </cfif>
                                    <cfif attributes.cost_money is not session.ep.money or isdefined('attributes.is_system_money_2') or listfind(attributes.process_type,3)>
                                    AND GC.UPD_ID = SHIP.SHIP_ID
                                    AND SHIP.SHIP_TYPE = GC.PROCESS_TYPE
                                    AND ISNULL(SHIP.IS_WITH_SHIP,0)=0
                                    </cfif>
                                    <cfif attributes.cost_money is not session.ep.money or isdefined('attributes.is_system_money_2')>
                                    AND SHIP.SHIP_ID = SM.ACTION_ID
                                        <cfif isdefined('attributes.is_system_money_2')>
                                            AND SM.MONEY_TYPE = '#session.ep.money2#'
                                        <cfelse>
                                            AND SM.MONEY_TYPE = '#attributes.cost_money#'
                                        </cfif>
                                    </cfif>
                                    AND GC.PROCESS_DATE >= #attributes.date#
                                    AND GC.PROCESS_DATE <= #attributes.date2#
                                    <cfif len(attributes.department_id)>
                                    AND
                                        (
                                        <cfloop list="#attributes.department_id#" delimiters="," index="dept_i">
                                        (GC.STORE = #listfirst(dept_i,'-')# AND GC.STORE_LOCATION = #listlast(dept_i,'-')#)
                                        <cfif dept_i neq listlast(attributes.department_id,',') and listlen(attributes.department_id,',') gte 1> OR</cfif>
                                        </cfloop>  
                                        )
                                    <cfelseif is_store>
                                        AND GC.STORE IN (#branch_dep_list#)
                                    </cfif>
                                    <cfif stock_table>
                                    AND	GC.STOCK_ID=S.STOCK_ID
                                    </cfif>
                                    <cfif len(trim(attributes.sup_company)) and len(attributes.sup_company_id)>
                                    AND S.COMPANY_ID = #attributes.sup_company_id#
                                    </cfif>
                                    <cfif len(trim(attributes.employee_name)) and len(attributes.product_employee_id)>
                                    AND S.PRODUCT_MANAGER = #attributes.product_employee_id#
                                    </cfif>
                                    <cfif len(trim(attributes.product_name)) and len(attributes.product_id)>
                                    AND S.PRODUCT_ID = #attributes.product_id#
                                    </cfif>
                                    <cfif len(trim(attributes.brand_name)) and len(attributes.brand_id)>
                                    AND S.BRAND_ID = #attributes.brand_id# 
                                    </cfif>	
                                    <cfif len(trim(attributes.product_cat)) and len(attributes.product_code)>
                                    AND S.STOCK_CODE LIKE '#attributes.product_code#%'
                                    </cfif>
                            <cfif attributes.cost_money is not session.ep.money or listfind(attributes.process_type,3)>
                            UNION ALL
                                SELECT
                                    GC.STOCK_ID,
                                    GC.PRODUCT_ID,
                                    <cfif attributes.report_type eq 8>
                                    CAST(GC.STOCK_ID AS NVARCHAR(50)) +'_'+ CAST(ISNULL(GC.SPECT_VAR_ID,0) AS NVARCHAR(50)) STOCK_SPEC_ID,
                                    </cfif>
                                    INVOICE.INVOICE_CAT,
                                    <cfif stock_table>
                                    S.PRODUCT_MANAGER,
                                    S.PRODUCT_CATID,
                                    S.BRAND_ID,
                                    </cfif>
                                    <cfif isdefined('attributes.is_system_money_2') or attributes.cost_money is not session.ep.money>
                                        <cfif isdefined('attributes.is_system_money_2')>
                                        GC.MALIYET_2,
                                        GC.MALIYET,
                                        ((GC.MALIYET_2*ABS(GC.STOCK_IN-GC.STOCK_OUT))) AS TOTAL_COST_2,
                                        (GC.MALIYET*ABS(GC.STOCK_IN-GC.STOCK_OUT)) AS TOTAL_COST,
                                        <cfelse>
                                            (GC.MALIYET/(IM.RATE2/IM.RATE1)) AS MALIYET,
                                            ((GC.MALIYET*ABS(GC.STOCK_IN-GC.STOCK_OUT))/(IM.RATE2/IM.RATE1)) AS TOTAL_COST,
                                        </cfif>
                                    <cfelse>
                                        (GC.MALIYET) AS MALIYET,
                                        ((GC.MALIYET*ABS(GC.STOCK_IN-GC.STOCK_OUT))) AS TOTAL_COST,
                                    </cfif>
                                    ABS(GC.STOCK_IN-GC.STOCK_OUT) AS AMOUNT,
                                    GC.STOCK_IN,
                                    GC.STOCK_OUT,
                                    GC.PROCESS_DATE ISLEM_TARIHI,
                                    GC.PROCESS_TYPE PROCESS_TYPE
                                    <!---ISNULL(ABS(GC.STOCK_IN-GC.STOCK_OUT)*(
                                        SELECT TOP 1 
                                            <cfif isdefined("attributes.location_based_cost")>
                                                <cfif isdefined("attributes.display_cost_money")>
                                                    (PURCHASE_NET_LOCATION+PURCHASE_EXTRA_COST_LOCATION)
                                                <cfelse>
                                                    (PURCHASE_NET_SYSTEM_LOCATION+PURCHASE_EXTRA_COST_SYSTEM_LOCATION)
                                                </cfif>
                                            <cfelse>
                                                <cfif isdefined("attributes.display_cost_money")>
                                                    (PURCHASE_NET+PURCHASE_EXTRA_COST)
                                                <cfelse>
                                                    (PURCHASE_NET_SYSTEM+PURCHASE_EXTRA_COST_SYSTEM)
                                                </cfif>	
                                            </cfif>
                                        FROM 
                                            #dsn3_alias#.PRODUCT_COST WITH (NOLOCK) 
                                        WHERE 
                                            START_DATE <= #finish_date# 
                                            AND PRODUCT_ID = GC.PRODUCT_ID
                                            <cfif attributes.report_type eq 8>
                                                 AND ISNULL(PRODUCT_COST.SPECT_MAIN_ID,0) = ISNULL(GC.SPECT_VAR_ID,0)
                                            </cfif>
                                           
                                            <cfif isdefined("attributes.location_based_cost")>
                                                <cfif len(attributes.department_id)>
                                                    AND DEPARTMENT_ID = #listgetat(attributes.department_id,1,'-')#
                                                    AND LOCATION_ID = #listgetat(attributes.department_id,2,'-')#
                                                <cfelse>
                                                    AND DEPARTMENT_ID = SL.DEPARTMENT_ID
                                                    AND LOCATION_ID = SL.LOCATION_ID
                                                </cfif>
                                            </cfif>
                                        ORDER BY 
                                            START_DATE DESC, 
                                            RECORD_DATE DESC,
                                            PRODUCT_COST_ID DESC
                                    ),0) ALL_FINISH_COST,
                                    ISNULL(ABS(GC.STOCK_IN-GC.STOCK_OUT)*(
                                        SELECT TOP 1 
                                            <cfif isdefined("attributes.location_based_cost")>
                                                (PURCHASE_NET_SYSTEM_2_LOCATION+PURCHASE_EXTRA_COST_SYSTEM_2_LOCATION)
                                            <cfelse>
                                                (PURCHASE_NET_SYSTEM_2+PURCHASE_EXTRA_COST_SYSTEM_2)
                                            </cfif>
                                        FROM 
                                            #dsn3_alias#.PRODUCT_COST WITH (NOLOCK) 
                                        WHERE 
                                            START_DATE <= #finish_date# 
                                            AND PRODUCT_ID = GC.PRODUCT_ID
                                            <cfif attributes.report_type eq 8>
                                                 AND ISNULL(PRODUCT_COST.SPECT_MAIN_ID,0) = ISNULL(GC.SPECT_VAR_ID,0)
                                            </cfif>
                                          
                                            <cfif isdefined("attributes.location_based_cost")>
                                                <cfif len(attributes.department_id)>
                                                    AND DEPARTMENT_ID = #listgetat(attributes.department_id,1,'-')#
                                                    AND LOCATION_ID = #listgetat(attributes.department_id,2,'-')#
                                                <cfelse>
                                                    AND DEPARTMENT_ID = SL.DEPARTMENT_ID
                                                    AND LOCATION_ID = SL.LOCATION_ID
                                                </cfif>
                                            </cfif>
                                        ORDER BY 
                                            START_DATE DESC, 
                                            RECORD_DATE DESC,
                                            PRODUCT_COST_ID DESC
                                    ),0) ALL_FINISH_COST_2--->
                                FROM
                                    SHIP WITH (NOLOCK),
                                    INVOICE WITH (NOLOCK),
                                    INVOICE_SHIPS INV_S,
                                    <cfif isdefined('attributes.is_system_money_2') or attributes.cost_money is not session.ep.money>



                                    INVOICE_MONEY IM,
                                    </cfif>
                                    <cfif is_store or isdefined("attributes.location_based_cost")>
                                        <cfif attributes.report_type eq 8>
                                            GET_STOCKS_ROW_COST_SPECT_LOCATION AS GC,
                                        <cfelse>
                                            GET_STOCKS_ROW_COST_LOCATION AS GC,
                                        </cfif>
                                    <cfelse>
                                        <cfif attributes.report_type eq 8>
                                            GET_STOCKS_ROW_COST_SPECT AS GC,
                                        <cfelse>
                                            GET_STOCK_ROW_COST_TABLE AS GC,
                                        </cfif>
                                    </cfif>
                                    <cfif stock_table>
                                    #dsn3_alias#.STOCKS S,
                                    </cfif>
                                    #dsn_alias#.STOCKS_LOCATION SL
                                WHERE
                                    SHIP.SHIP_ID = INV_S.SHIP_ID
                                    AND INVOICE.INVOICE_ID= INV_S.INVOICE_ID
                                    AND INV_S.IS_WITH_SHIP = 1
                                    AND INV_S.SHIP_PERIOD_ID = #session.ep.period_id#
                                    AND SHIP.IS_WITH_SHIP=1
                                    AND SHIP.SHIP_ID = GC.UPD_ID
                                    AND SHIP.SHIP_TYPE = GC.PROCESS_TYPE
                                    AND GC.STORE = SL.DEPARTMENT_ID
                                    AND GC.STORE_LOCATION=SL.LOCATION_ID
                                    <cfif not isdefined('is_belognto_institution')>
                                    AND SL.BELONGTO_INSTITUTION = 0
                                    </cfif>
                                    <cfif isdefined('attributes.is_system_money_2') or attributes.cost_money is not session.ep.money>
                                        AND IM.ACTION_ID=INVOICE.INVOICE_ID
                                        <cfif isdefined('attributes.is_system_money_2')>
                                        AND IM.MONEY_TYPE = '#session.ep.money2#'
                                        <cfelse>
                                        AND IM.MONEY_TYPE = '#attributes.cost_money#'
                                        </cfif>
                                    </cfif>
                                    AND GC.PROCESS_DATE >= #attributes.date#
                                    AND GC.PROCESS_DATE <= #attributes.date2#
                                    <cfif len(attributes.department_id)>
                                    AND
                                        (
                                        <cfloop list="#attributes.department_id#" delimiters="," index="dept_i">
                                        (GC.STORE = #listfirst(dept_i,'-')# AND GC.STORE_LOCATION = #listlast(dept_i,'-')#)
                                        <cfif dept_i neq listlast(attributes.department_id,',') and listlen(attributes.department_id,',') gte 1> OR</cfif>
                                        </cfloop>  
                                        )
                                    <cfelseif is_store>
                                        AND GC.STORE IN (#branch_dep_list#)
                                    </cfif>
                                    <cfif stock_table>
                                    AND	GC.STOCK_ID=S.STOCK_ID
                                    </cfif>
                                    <cfif len(trim(attributes.sup_company)) and len(attributes.sup_company_id)>
                                        AND S.COMPANY_ID = #attributes.sup_company_id#
                                    </cfif>
                                    <cfif len(trim(attributes.employee_name)) and len(attributes.product_employee_id)>
                                        AND S.PRODUCT_MANAGER = #attributes.product_employee_id#
                                    </cfif>
                                    <cfif len(trim(attributes.product_name)) and len(attributes.product_id)>
                                        AND S.PRODUCT_ID = #attributes.product_id#
                                    </cfif>
                                    <cfif len(trim(attributes.brand_name)) and len(attributes.brand_id)>
                                        AND S.BRAND_ID = #attributes.brand_id# 
                                    </cfif>	
                                    <cfif len(trim(attributes.product_cat)) and len(attributes.product_code)>
                                        AND S.STOCK_CODE LIKE '#attributes.product_code#%'
                                    </cfif>
                            </cfif>
                            )AS GET_SHIP_ROWS
                        WHERE
                            PROCESS_TYPE IN (73,74)
                            OR INVOICE_CAT IN (54,55)
                        GROUP BY
                            #ALAN_ADI#
                        )AS d_satis_iade ON GET_ALL_STOCK.PRODUCT_GROUPBY_ID = d_satis_iade.GROUPBY_ALANI
        </cfif>
        <!--- giden konsinye --->
        <cfif len(attributes.process_type) and listfind(attributes.process_type,6)>
        	LEFT JOIN (
                        SELECT	
                            SUM(AMOUNT) AS KONS_CIKIS_MIKTAR,
                            <cfif isdefined("x_kons_cost_date") and x_kons_cost_date eq 1>
                                SUM(ALL_FINISH_COST) AS KONS_CIKIS_MALIYET,
                                <cfif isdefined('attributes.is_system_money_2')>
                                SUM(ALL_FINISH_COST_2) AS KONS_CIKIS_MALIYET_2,
                                </cfif>
                            <cfelse>	
                                SUM(TOTAL_COST) AS KONS_CIKIS_MALIYET,
                                <cfif isdefined('attributes.is_system_money_2')>
                                SUM(TOTAL_COST_2) AS KONS_CIKIS_MALIYET_2,
                                </cfif>
                            </cfif>
                            #ALAN_ADI# AS GROUPBY_ALANI
                        FROM
                            (
                                SELECT
                                    GC.STOCK_ID,
                                    GC.PRODUCT_ID,
                                    <cfif attributes.report_type eq 8>
                                    CAST(GC.STOCK_ID AS NVARCHAR(50)) +'_'+ CAST(ISNULL(GC.SPECT_VAR_ID,0) AS NVARCHAR(50)) STOCK_SPEC_ID,
                                    </cfif>
                                    1 AS INVOICE_CAT,
                                    <cfif stock_table>
                                    S.PRODUCT_MANAGER,
                                    S.PRODUCT_CATID,
                                    S.BRAND_ID,
                                    </cfif>
                                    <cfif isdefined('attributes.is_system_money_2')>
                                    GC.MALIYET_2,
                                    GC.MALIYET,
                                    ((GC.MALIYET_2*ABS(GC.STOCK_IN-GC.STOCK_OUT))) AS TOTAL_COST_2,
                                    (GC.MALIYET*ABS(GC.STOCK_IN-GC.STOCK_OUT)) AS TOTAL_COST,
                                    <cfelse>
                                        <cfif attributes.cost_money is not session.ep.money>
                                        (GC.MALIYET/(SM.RATE2/SM.RATE1)) AS MALIYET,
                                        ((GC.MALIYET*ABS(GC.STOCK_IN-GC.STOCK_OUT))/(SM.RATE2/SM.RATE1)) AS TOTAL_COST,
                                        <cfelse>
                                        GC.MALIYET,
                                        (GC.MALIYET*ABS(GC.STOCK_IN-GC.STOCK_OUT)) AS TOTAL_COST,				
                                        </cfif>
                                    </cfif>
                                    ABS(GC.STOCK_IN-GC.STOCK_OUT) AS AMOUNT,
                                    GC.STOCK_IN,
                                    GC.STOCK_OUT,
                                    GC.PROCESS_DATE ISLEM_TARIHI,
                                    GC.PROCESS_TYPE PROCESS_TYPE,
                                    ISNULL(ABS(GC.STOCK_IN-GC.STOCK_OUT)*(
                                        SELECT TOP 1 
                                            <cfif isdefined("attributes.location_based_cost")>
                                                <cfif isdefined("attributes.display_cost_money")>
                                                    (PURCHASE_NET_LOCATION+PURCHASE_EXTRA_COST_LOCATION)
                                                <cfelse>
                                                    (PURCHASE_NET_SYSTEM_LOCATION+PURCHASE_EXTRA_COST_SYSTEM_LOCATION)
                                                </cfif>
                                            <cfelse>
                                                <cfif isdefined("attributes.display_cost_money")>
                                                    (PURCHASE_NET+PURCHASE_EXTRA_COST)
                                                <cfelse>
                                                    (PURCHASE_NET_SYSTEM+PURCHASE_EXTRA_COST_SYSTEM)
                                                </cfif>	
                                            </cfif>
                                        FROM 
                                            #dsn3_alias#.PRODUCT_COST WITH (NOLOCK) 
                                        WHERE 
                                            START_DATE <= #finish_date# 
                                            AND PRODUCT_ID = GC.PRODUCT_ID
                                            <cfif attributes.report_type eq 8>
                                                 AND ISNULL(PRODUCT_COST.SPECT_MAIN_ID,0) = ISNULL(GC.SPECT_VAR_ID,0)
                                            </cfif>
                                            
                                            <cfif isdefined("attributes.location_based_cost")>
                                                <cfif len(attributes.department_id)>
                                                    AND DEPARTMENT_ID = #listgetat(attributes.department_id,1,'-')#
                                                    AND LOCATION_ID = #listgetat(attributes.department_id,2,'-')#
                                                <cfelse>
                                                    AND DEPARTMENT_ID = SL.DEPARTMENT_ID
                                                    AND LOCATION_ID = SL.LOCATION_ID
                                                </cfif>
                                            </cfif>
                                        ORDER BY 
                                            START_DATE DESC, 
                                            RECORD_DATE DESC,
                                            PRODUCT_COST_ID DESC
                                    ),0) ALL_FINISH_COST,
                                    ISNULL(ABS(GC.STOCK_IN-GC.STOCK_OUT)*(
                                        SELECT TOP 1 
                                            <cfif isdefined("attributes.location_based_cost")>
                                                (PURCHASE_NET_SYSTEM_2_LOCATION+PURCHASE_EXTRA_COST_SYSTEM_2_LOCATION)
                                            <cfelse>
                                                (PURCHASE_NET_SYSTEM_2+PURCHASE_EXTRA_COST_SYSTEM_2)
                                            </cfif>
                                        FROM 
                                            #dsn3_alias#.PRODUCT_COST WITH (NOLOCK) 
                                        WHERE 
                                            START_DATE <= #finish_date# 
                                            AND PRODUCT_ID = GC.PRODUCT_ID
                                            <cfif attributes.report_type eq 8>
                                                 AND ISNULL(PRODUCT_COST.SPECT_MAIN_ID,0) = ISNULL(GC.SPECT_VAR_ID,0)
                                            </cfif>
                                            
                                            <cfif isdefined("attributes.location_based_cost")>
                                                <cfif len(attributes.department_id)>
                                                    AND DEPARTMENT_ID = #listgetat(attributes.department_id,1,'-')#
                                                    AND LOCATION_ID = #listgetat(attributes.department_id,2,'-')#
                                                <cfelse>
                                                    AND DEPARTMENT_ID = SL.DEPARTMENT_ID
                                                    AND LOCATION_ID = SL.LOCATION_ID
                                                </cfif>
                                            </cfif>
                                        ORDER BY 
                                            START_DATE DESC, 
                                            RECORD_DATE DESC,
                                            PRODUCT_COST_ID DESC
                                    ),0) ALL_FINISH_COST_2
                                FROM
                                    <cfif is_store or isdefined("attributes.location_based_cost")>
                                        <cfif attributes.report_type eq 8>
                                            GET_STOCKS_ROW_COST_SPECT_LOCATION AS GC,
                                        <cfelse>
                                            GET_STOCKS_ROW_COST_LOCATION AS GC,
                                        </cfif>
                                    <cfelse>
                                        <cfif attributes.report_type eq 8>
                                            GET_STOCKS_ROW_COST_SPECT AS GC,
                                        <cfelse>
                                            GET_STOCK_ROW_COST_TABLE AS GC,
                                        </cfif>
                                    </cfif>
                                    <cfif attributes.cost_money is not session.ep.money or isdefined('attributes.is_system_money_2') or listfind(attributes.process_type,3)>
                                    SHIP WITH (NOLOCK),	
                                    </cfif>
                                    <cfif attributes.cost_money is not session.ep.money or isdefined('attributes.is_system_money_2')>
                                    SHIP_MONEY SM,
                                    </cfif>
                                    <cfif stock_table>
                                    #dsn3_alias#.STOCKS S,
                                    </cfif>
                                    #dsn_alias#.STOCKS_LOCATION SL
                                WHERE
                                    GC.STORE = SL.DEPARTMENT_ID
                                    AND GC.STORE_LOCATION=SL.LOCATION_ID
                                    <cfif not isdefined('is_belognto_institution')>
                                    AND SL.BELONGTO_INSTITUTION = 0
                                    </cfif>
                                    <cfif attributes.cost_money is not session.ep.money or isdefined('attributes.is_system_money_2') or listfind(attributes.process_type,3)>
                                    AND GC.UPD_ID = SHIP.SHIP_ID
                                    AND SHIP.SHIP_TYPE = GC.PROCESS_TYPE
                                    AND ISNULL(SHIP.IS_WITH_SHIP,0)=0
                                    </cfif>
                                    <cfif attributes.cost_money is not session.ep.money or isdefined('attributes.is_system_money_2')>
                                    AND SHIP.SHIP_ID = SM.ACTION_ID
                                        <cfif isdefined('attributes.is_system_money_2')>
                                            AND SM.MONEY_TYPE = '#session.ep.money2#'
                                        <cfelse>
                                            AND SM.MONEY_TYPE = '#attributes.cost_money#'
                                        </cfif>
                                    </cfif>
                                    AND GC.PROCESS_DATE >= #attributes.date#
                                    AND GC.PROCESS_DATE <= #attributes.date2#
                                    <cfif len(attributes.department_id)>
                                    AND
                                        (
                                        <cfloop list="#attributes.department_id#" delimiters="," index="dept_i">
                                        (GC.STORE = #listfirst(dept_i,'-')# AND GC.STORE_LOCATION = #listlast(dept_i,'-')#)
                                        <cfif dept_i neq listlast(attributes.department_id,',') and listlen(attributes.department_id,',') gte 1> OR</cfif>
                                        </cfloop>  
                                        )
                                    <cfelseif is_store>
                                        AND GC.STORE IN (#branch_dep_list#)
                                    </cfif>
                                    <cfif stock_table>
                                    AND	GC.STOCK_ID=S.STOCK_ID
                                    </cfif>
                                    <cfif len(trim(attributes.sup_company)) and len(attributes.sup_company_id)>
                                    AND S.COMPANY_ID = #attributes.sup_company_id#
                                    </cfif>
                                    <cfif len(trim(attributes.employee_name)) and len(attributes.product_employee_id)>
                                    AND S.PRODUCT_MANAGER = #attributes.product_employee_id#
                                    </cfif>
                                    <cfif len(trim(attributes.product_name)) and len(attributes.product_id)>
                                    AND S.PRODUCT_ID = #attributes.product_id#
                                    </cfif>
                                    <cfif len(trim(attributes.brand_name)) and len(attributes.brand_id)>
                                    AND S.BRAND_ID = #attributes.brand_id# 
                                    </cfif>	
                                    <cfif len(trim(attributes.product_cat)) and len(attributes.product_code)>
                                    AND S.STOCK_CODE LIKE '#attributes.product_code#%'
                                    </cfif>
                            <cfif attributes.cost_money is not session.ep.money or listfind(attributes.process_type,3)>
                            UNION ALL
                                SELECT
                                    GC.STOCK_ID,
                                    GC.PRODUCT_ID,
                                    <cfif attributes.report_type eq 8>
                                    CAST(GC.STOCK_ID AS NVARCHAR(50)) +'_'+ CAST(ISNULL(GC.SPECT_VAR_ID,0) AS NVARCHAR(50)) STOCK_SPEC_ID,
                                    </cfif>
                                    INVOICE.INVOICE_CAT,
                                    <cfif stock_table>
                                    S.PRODUCT_MANAGER,
                                    S.PRODUCT_CATID,
                                    S.BRAND_ID,
                                    </cfif>
                                    <cfif isdefined('attributes.is_system_money_2') or attributes.cost_money is not session.ep.money>
                                        <cfif isdefined('attributes.is_system_money_2')>
                                        GC.MALIYET_2,
                                        GC.MALIYET,
                                        ((GC.MALIYET_2*ABS(GC.STOCK_IN-GC.STOCK_OUT))) AS TOTAL_COST_2,
                                        (GC.MALIYET*ABS(GC.STOCK_IN-GC.STOCK_OUT)) AS TOTAL_COST,
                                        <cfelse>
                                            (GC.MALIYET/(IM.RATE2/IM.RATE1)) AS MALIYET,
                                            ((GC.MALIYET*ABS(GC.STOCK_IN-GC.STOCK_OUT))/(IM.RATE2/IM.RATE1)) AS TOTAL_COST,
                                        </cfif>
                                    <cfelse>
                                        (GC.MALIYET) AS MALIYET,
                                        ((GC.MALIYET*ABS(GC.STOCK_IN-GC.STOCK_OUT))) AS TOTAL_COST,
                                    </cfif>
                                    ABS(GC.STOCK_IN-GC.STOCK_OUT) AS AMOUNT,
                                    GC.STOCK_IN,
                                    GC.STOCK_OUT,
                                    GC.PROCESS_DATE ISLEM_TARIHI,
                                    GC.PROCESS_TYPE PROCESS_TYPE,
                                    ISNULL(ABS(GC.STOCK_IN-GC.STOCK_OUT)*(
                                        SELECT TOP 1 
                                            <cfif isdefined("attributes.location_based_cost")>
                                                <cfif isdefined("attributes.display_cost_money")>
                                                    (PURCHASE_NET_LOCATION+PURCHASE_EXTRA_COST_LOCATION)
                                                <cfelse>
                                                    (PURCHASE_NET_SYSTEM_LOCATION+PURCHASE_EXTRA_COST_SYSTEM_LOCATION)
                                                </cfif>
                                            <cfelse>
                                                <cfif isdefined("attributes.display_cost_money")>
                                                    (PURCHASE_NET+PURCHASE_EXTRA_COST)
                                                <cfelse>
                                                    (PURCHASE_NET_SYSTEM+PURCHASE_EXTRA_COST_SYSTEM)
                                                </cfif>	
                                            </cfif>
                                        FROM 
                                            #dsn3_alias#.PRODUCT_COST WITH (NOLOCK) 
                                        WHERE 
                                            START_DATE <= #finish_date# 
                                            AND PRODUCT_ID = GC.PRODUCT_ID
                                            <cfif attributes.report_type eq 8>
                                                 AND ISNULL(PRODUCT_COST.SPECT_MAIN_ID,0) = ISNULL(GC.SPECT_VAR_ID,0)
                                            </cfif>
                                           
                                            <cfif isdefined("attributes.location_based_cost")>
                                                <cfif len(attributes.department_id)>
                                                    AND DEPARTMENT_ID = #listgetat(attributes.department_id,1,'-')#
                                                    AND LOCATION_ID = #listgetat(attributes.department_id,2,'-')#
                                                <cfelse>
                                                    AND DEPARTMENT_ID = SL.DEPARTMENT_ID
                                                    AND LOCATION_ID = SL.LOCATION_ID
                                                </cfif>
                                            </cfif>
                                        ORDER BY 
                                            START_DATE DESC, 
                                            RECORD_DATE DESC,
                                            PRODUCT_COST_ID DESC
                                    ),0) ALL_FINISH_COST,
                                    ISNULL(ABS(GC.STOCK_IN-GC.STOCK_OUT)*(
                                        SELECT TOP 1 
                                            <cfif isdefined("attributes.location_based_cost")>
                                                (PURCHASE_NET_SYSTEM_2_LOCATION+PURCHASE_EXTRA_COST_SYSTEM_2_LOCATION)
                                            <cfelse>
                                                (PURCHASE_NET_SYSTEM_2+PURCHASE_EXTRA_COST_SYSTEM_2)
                                            </cfif>
                                        FROM 
                                            #dsn3_alias#.PRODUCT_COST WITH (NOLOCK) 
                                        WHERE 
                                            START_DATE <= #finish_date# 
                                            AND PRODUCT_ID = GC.PRODUCT_ID
                                            <cfif attributes.report_type eq 8>
                                                 AND ISNULL(PRODUCT_COST.SPECT_MAIN_ID,0) = ISNULL(GC.SPECT_VAR_ID,0)
                                            </cfif>
                                            
                                            <cfif isdefined("attributes.location_based_cost")>
                                                <cfif len(attributes.department_id)>
                                                    AND DEPARTMENT_ID = #listgetat(attributes.department_id,1,'-')#
                                                    AND LOCATION_ID = #listgetat(attributes.department_id,2,'-')#
                                                <cfelse>
                                                    AND DEPARTMENT_ID = SL.DEPARTMENT_ID
                                                    AND LOCATION_ID = SL.LOCATION_ID
                                                </cfif>
                                            </cfif>
                                        ORDER BY 
                                            START_DATE DESC, 
                                            RECORD_DATE DESC,
                                            PRODUCT_COST_ID DESC
                                    ),0) ALL_FINISH_COST_2
                                FROM
                                    SHIP WITH (NOLOCK),
                                    INVOICE WITH (NOLOCK),
                                    INVOICE_SHIPS INV_S,
                                    <cfif isdefined('attributes.is_system_money_2') or attributes.cost_money is not session.ep.money>
                                    INVOICE_MONEY IM,
                                    </cfif>
                                    <cfif is_store or isdefined("attributes.location_based_cost")>
                                        <cfif attributes.report_type eq 8>
                                            GET_STOCKS_ROW_COST_SPECT_LOCATION AS GC,
                                        <cfelse>
                                            GET_STOCKS_ROW_COST_LOCATION AS GC,
                                        </cfif>
                                    <cfelse>
                                        <cfif attributes.report_type eq 8>
                                            GET_STOCKS_ROW_COST_SPECT AS GC,
                                        <cfelse>
                                            GET_STOCK_ROW_COST_TABLE AS GC,
                                        </cfif>
                                    </cfif>
                                    <cfif stock_table>
                                    #dsn3_alias#.STOCKS S,
                                    </cfif>
                                    #dsn_alias#.STOCKS_LOCATION SL
                                WHERE
                                    SHIP.SHIP_ID = INV_S.SHIP_ID
                                    AND INVOICE.INVOICE_ID= INV_S.INVOICE_ID
                                    AND INV_S.IS_WITH_SHIP = 1
                                    AND INV_S.SHIP_PERIOD_ID = #session.ep.period_id#
                                    AND SHIP.IS_WITH_SHIP=1
                                    AND SHIP.SHIP_ID = GC.UPD_ID
                                    AND SHIP.SHIP_TYPE = GC.PROCESS_TYPE
                                    AND GC.STORE = SL.DEPARTMENT_ID
                                    AND GC.STORE_LOCATION=SL.LOCATION_ID
                                    <cfif not isdefined('is_belognto_institution')>
                                    AND SL.BELONGTO_INSTITUTION = 0
                                    </cfif>
                                    <cfif isdefined('attributes.is_system_money_2') or attributes.cost_money is not session.ep.money>
                                        AND IM.ACTION_ID=INVOICE.INVOICE_ID
                                        <cfif isdefined('attributes.is_system_money_2')>
                                        AND IM.MONEY_TYPE = '#session.ep.money2#'
                                        <cfelse>
                                        AND IM.MONEY_TYPE = '#attributes.cost_money#'
                                        </cfif>
                                    </cfif>
                                    AND GC.PROCESS_DATE >= #attributes.date#
                                    AND GC.PROCESS_DATE <= #attributes.date2#
                                    <cfif len(attributes.department_id)>
                                    AND
                                        (
                                        <cfloop list="#attributes.department_id#" delimiters="," index="dept_i">
                                        (GC.STORE = #listfirst(dept_i,'-')# AND GC.STORE_LOCATION = #listlast(dept_i,'-')#)
                                        <cfif dept_i neq listlast(attributes.department_id,',') and listlen(attributes.department_id,',') gte 1> OR</cfif>
                                        </cfloop>  
                                        )
                                    <cfelseif is_store>
                                        AND GC.STORE IN (#branch_dep_list#)
                                    </cfif>
                                    <cfif stock_table>
                                    AND	GC.STOCK_ID=S.STOCK_ID
                                    </cfif>
                                    <cfif len(trim(attributes.sup_company)) and len(attributes.sup_company_id)>
                                        AND S.COMPANY_ID = #attributes.sup_company_id#
                                    </cfif>
                                    <cfif len(trim(attributes.employee_name)) and len(attributes.product_employee_id)>
                                        AND S.PRODUCT_MANAGER = #attributes.product_employee_id#
                                    </cfif>
                                    <cfif len(trim(attributes.product_name)) and len(attributes.product_id)>
                                        AND S.PRODUCT_ID = #attributes.product_id#
                                    </cfif>
                                    <cfif len(trim(attributes.brand_name)) and len(attributes.brand_id)>
                                        AND S.BRAND_ID = #attributes.brand_id# 
                                    </cfif>	
                                    <cfif len(trim(attributes.product_cat)) and len(attributes.product_code)>
                                        AND S.STOCK_CODE LIKE '#attributes.product_code#%'
                                    </cfif>
                            </cfif>
                            )AS GET_SHIP_ROWS
                        WHERE
                            PROCESS_TYPE = 72
                        GROUP BY
                            #ALAN_ADI#
                        )AS konsinye_cikis ON GET_ALL_STOCK.PRODUCT_GROUPBY_ID = konsinye_cikis.GROUPBY_ALANI
        </cfif>
        <!--- iade gelen konsinye --->
		<cfif len(attributes.process_type) and listfind(attributes.process_type,7)>
			LEFT JOIN(
                        SELECT	
                            SUM(AMOUNT) AS KONS_IADE_MIKTAR,
                            <cfif  isdefined("x_kons_cost_date") and x_kons_cost_date eq 1>
                                SUM(ALL_FINISH_COST) AS KONS_IADE_MALIYET,
                                <cfif isdefined('attributes.is_system_money_2')>
                                SUM(ALL_FINISH_COST_2) AS KONS_IADE_MALIYET_2,
                                </cfif>
                            <cfelse>	
                                SUM(TOTAL_COST) AS KONS_IADE_MALIYET,
                                <cfif isdefined('attributes.is_system_money_2')>
                                SUM(TOTAL_COST_2) AS KONS_IADE_MALIYET_2,
                                </cfif>
                            </cfif>
                            #ALAN_ADI# AS GROUPBY_ALANI
                        FROM
                            (
                                SELECT
                                    GC.STOCK_ID,
                                    GC.PRODUCT_ID,
                                    <cfif attributes.report_type eq 8>
                                    CAST(GC.STOCK_ID AS NVARCHAR(50)) +'_'+ CAST(ISNULL(GC.SPECT_VAR_ID,0) AS NVARCHAR(50)) STOCK_SPEC_ID,
                                    </cfif>
                                    1 AS INVOICE_CAT,
                                    <cfif stock_table>
                                    S.PRODUCT_MANAGER,
                                    S.PRODUCT_CATID,
                                    S.BRAND_ID,
                                    </cfif>
                                    <cfif isdefined('attributes.is_system_money_2')>
                                    GC.MALIYET_2,
                                    GC.MALIYET,
                                    ((GC.MALIYET_2*ABS(GC.STOCK_IN-GC.STOCK_OUT))) AS TOTAL_COST_2,
                                    (GC.MALIYET*ABS(GC.STOCK_IN-GC.STOCK_OUT)) AS TOTAL_COST,
                                    <cfelse>
                                        <cfif attributes.cost_money is not session.ep.money>
                                        (GC.MALIYET/(SM.RATE2/SM.RATE1)) AS MALIYET,
                                        ((GC.MALIYET*ABS(GC.STOCK_IN-GC.STOCK_OUT))/(SM.RATE2/SM.RATE1)) AS TOTAL_COST,
                                        <cfelse>
                                        GC.MALIYET,
                                        (GC.MALIYET*ABS(GC.STOCK_IN-GC.STOCK_OUT)) AS TOTAL_COST,				
                                        </cfif>
                                    </cfif>
                                    ABS(GC.STOCK_IN-GC.STOCK_OUT) AS AMOUNT,
                                    GC.STOCK_IN,
                                    GC.STOCK_OUT,
                                    GC.PROCESS_DATE ISLEM_TARIHI,
                                    GC.PROCESS_TYPE PROCESS_TYPE,
                                    ISNULL(ABS(GC.STOCK_IN-GC.STOCK_OUT)*(
                                        SELECT TOP 1 
                                            <cfif isdefined("attributes.location_based_cost")>
                                                <cfif isdefined("attributes.display_cost_money")>
                                                    (PURCHASE_NET_LOCATION+PURCHASE_EXTRA_COST_LOCATION)
                                                <cfelse>
                                                    (PURCHASE_NET_SYSTEM_LOCATION+PURCHASE_EXTRA_COST_SYSTEM_LOCATION)
                                                </cfif>
                                            <cfelse>
                                                <cfif isdefined("attributes.display_cost_money")>
                                                    (PURCHASE_NET+PURCHASE_EXTRA_COST)
                                                <cfelse>
                                                    (PURCHASE_NET_SYSTEM+PURCHASE_EXTRA_COST_SYSTEM)
                                                </cfif>	
                                            </cfif>
                                        FROM 
                                            #dsn3_alias#.PRODUCT_COST WITH (NOLOCK) 
                                        WHERE 
                                            START_DATE <= #finish_date# 
                                            AND PRODUCT_ID = GC.PRODUCT_ID
                                            <cfif attributes.report_type eq 8>
                                                 AND ISNULL(PRODUCT_COST.SPECT_MAIN_ID,0) = ISNULL(GC.SPECT_VAR_ID,0)
                                            </cfif>
                                            
                                            <cfif isdefined("attributes.location_based_cost")>
                                                <cfif len(attributes.department_id)>
                                                    AND DEPARTMENT_ID = #listgetat(attributes.department_id,1,'-')#
                                                    AND LOCATION_ID = #listgetat(attributes.department_id,2,'-')#
                                                <cfelse>
                                                    AND DEPARTMENT_ID = SL.DEPARTMENT_ID
                                                    AND LOCATION_ID = SL.LOCATION_ID
                                                </cfif>
                                            </cfif>
                                        ORDER BY 
                                            START_DATE DESC, 
                                            RECORD_DATE DESC,
                                            PRODUCT_COST_ID DESC
                                    ),0) ALL_FINISH_COST,
                                    ISNULL(ABS(GC.STOCK_IN-GC.STOCK_OUT)*(
                                        SELECT TOP 1 
                                            <cfif isdefined("attributes.location_based_cost")>
                                                (PURCHASE_NET_SYSTEM_2_LOCATION+PURCHASE_EXTRA_COST_SYSTEM_2_LOCATION)
                                            <cfelse>
                                                (PURCHASE_NET_SYSTEM_2+PURCHASE_EXTRA_COST_SYSTEM_2)
                                            </cfif>
                                        FROM 
                                            #dsn3_alias#.PRODUCT_COST WITH (NOLOCK) 
                                        WHERE 
                                            START_DATE <= #finish_date# 
                                            AND PRODUCT_ID = GC.PRODUCT_ID
                                            <cfif attributes.report_type eq 8>
                                                 AND ISNULL(PRODUCT_COST.SPECT_MAIN_ID,0) = ISNULL(GC.SPECT_VAR_ID,0)
                                            </cfif>
                                            
                                            <cfif isdefined("attributes.location_based_cost")>
                                                <cfif len(attributes.department_id)>
                                                    AND DEPARTMENT_ID = #listgetat(attributes.department_id,1,'-')#
                                                    AND LOCATION_ID = #listgetat(attributes.department_id,2,'-')#
                                                <cfelse>
                                                    AND DEPARTMENT_ID = SL.DEPARTMENT_ID
                                                    AND LOCATION_ID = SL.LOCATION_ID
                                                </cfif>
                                            </cfif>
                                        ORDER BY 
                                            START_DATE DESC, 
                                            RECORD_DATE DESC,
                                            PRODUCT_COST_ID DESC
                                    ),0) ALL_FINISH_COST_2
                                FROM
                                    <cfif is_store or isdefined("attributes.location_based_cost")>
                                        <cfif attributes.report_type eq 8>
                                            GET_STOCKS_ROW_COST_SPECT_LOCATION AS GC,
                                        <cfelse>
                                            GET_STOCKS_ROW_COST_LOCATION AS GC,
                                        </cfif>
                                    <cfelse>
                                        <cfif attributes.report_type eq 8>
                                            GET_STOCKS_ROW_COST_SPECT AS GC,
                                        <cfelse>
                                            GET_STOCK_ROW_COST_TABLE AS GC,
                                        </cfif>
                                    </cfif>
                                    <cfif attributes.cost_money is not session.ep.money or isdefined('attributes.is_system_money_2') or listfind(attributes.process_type,3)>
                                    SHIP WITH (NOLOCK),	
                                    </cfif>
                                    <cfif attributes.cost_money is not session.ep.money or isdefined('attributes.is_system_money_2')>
                                    SHIP_MONEY SM,
                                    </cfif>
                                    <cfif stock_table>
                                    #dsn3_alias#.STOCKS S,
                                    </cfif>
                                    #dsn_alias#.STOCKS_LOCATION SL
                                WHERE
                                    GC.STORE = SL.DEPARTMENT_ID
                                    AND GC.STORE_LOCATION=SL.LOCATION_ID
                                    <cfif not isdefined('is_belognto_institution')>
                                    AND SL.BELONGTO_INSTITUTION = 0
                                    </cfif>
                                    <cfif attributes.cost_money is not session.ep.money or isdefined('attributes.is_system_money_2') or listfind(attributes.process_type,3)>
                                    AND GC.UPD_ID = SHIP.SHIP_ID
                                    AND SHIP.SHIP_TYPE = GC.PROCESS_TYPE
                                    AND ISNULL(SHIP.IS_WITH_SHIP,0)=0
                                    </cfif>
                                    <cfif attributes.cost_money is not session.ep.money or isdefined('attributes.is_system_money_2')>
                                    AND SHIP.SHIP_ID = SM.ACTION_ID
                                        <cfif isdefined('attributes.is_system_money_2')>
                                            AND SM.MONEY_TYPE = '#session.ep.money2#'
                                        <cfelse>
                                            AND SM.MONEY_TYPE = '#attributes.cost_money#'
                                        </cfif>
                                    </cfif>
                                    AND GC.PROCESS_DATE >= #attributes.date#
                                    AND GC.PROCESS_DATE <= #attributes.date2#
                                    <cfif len(attributes.department_id)>
                                    AND
                                        (
                                        <cfloop list="#attributes.department_id#" delimiters="," index="dept_i">
                                        (GC.STORE = #listfirst(dept_i,'-')# AND GC.STORE_LOCATION = #listlast(dept_i,'-')#)
                                        <cfif dept_i neq listlast(attributes.department_id,',') and listlen(attributes.department_id,',') gte 1> OR</cfif>
                                        </cfloop>  
                                        )
                                    <cfelseif is_store>
                                        AND GC.STORE IN (#branch_dep_list#)
                                    </cfif>
                                    <cfif stock_table>
                                    AND	GC.STOCK_ID=S.STOCK_ID
                                    </cfif>
                                    <cfif len(trim(attributes.sup_company)) and len(attributes.sup_company_id)>
                                    AND S.COMPANY_ID = #attributes.sup_company_id#
                                    </cfif>
                                    <cfif len(trim(attributes.employee_name)) and len(attributes.product_employee_id)>
                                    AND S.PRODUCT_MANAGER = #attributes.product_employee_id#
                                    </cfif>
                                    <cfif len(trim(attributes.product_name)) and len(attributes.product_id)>
                                    AND S.PRODUCT_ID = #attributes.product_id#
                                    </cfif>
                                    <cfif len(trim(attributes.brand_name)) and len(attributes.brand_id)>
                                    AND S.BRAND_ID = #attributes.brand_id# 
                                    </cfif>	
                                    <cfif len(trim(attributes.product_cat)) and len(attributes.product_code)>
                                    AND S.STOCK_CODE LIKE '#attributes.product_code#%'
                                    </cfif>
                            <cfif attributes.cost_money is not session.ep.money or listfind(attributes.process_type,3)>
                            UNION ALL
                                SELECT
                                    GC.STOCK_ID,
                                    GC.PRODUCT_ID,
                                    <cfif attributes.report_type eq 8>
                                    CAST(GC.STOCK_ID AS NVARCHAR(50)) +'_'+ CAST(ISNULL(GC.SPECT_VAR_ID,0) AS NVARCHAR(50)) STOCK_SPEC_ID,
                                    </cfif>
                                    INVOICE.INVOICE_CAT,
                                    <cfif stock_table>
                                    S.PRODUCT_MANAGER,
                                    S.PRODUCT_CATID,
                                    S.BRAND_ID,
                                    </cfif>
                                    <cfif isdefined('attributes.is_system_money_2') or attributes.cost_money is not session.ep.money>
                                        <cfif isdefined('attributes.is_system_money_2')>
                                        GC.MALIYET_2,
                                        GC.MALIYET,
                                        ((GC.MALIYET_2*ABS(GC.STOCK_IN-GC.STOCK_OUT))) AS TOTAL_COST_2,
                                        (GC.MALIYET*ABS(GC.STOCK_IN-GC.STOCK_OUT)) AS TOTAL_COST,
                                        <cfelse>
                                            (GC.MALIYET/(IM.RATE2/IM.RATE1)) AS MALIYET,
                                            ((GC.MALIYET*ABS(GC.STOCK_IN-GC.STOCK_OUT))/(IM.RATE2/IM.RATE1)) AS TOTAL_COST,
                                        </cfif>
                                    <cfelse>
                                        (GC.MALIYET) AS MALIYET,
                                        ((GC.MALIYET*ABS(GC.STOCK_IN-GC.STOCK_OUT))) AS TOTAL_COST,
                                    </cfif>
                                    ABS(GC.STOCK_IN-GC.STOCK_OUT) AS AMOUNT,
                                    GC.STOCK_IN,
                                    GC.STOCK_OUT,
                                    GC.PROCESS_DATE ISLEM_TARIHI,
                                    GC.PROCESS_TYPE PROCESS_TYPE,
                                    ISNULL(ABS(GC.STOCK_IN-GC.STOCK_OUT)*(
                                        SELECT TOP 1 
                                            <cfif isdefined("attributes.location_based_cost")>
                                                <cfif isdefined("attributes.display_cost_money")>
                                                    (PURCHASE_NET_LOCATION+PURCHASE_EXTRA_COST_LOCATION)
                                                <cfelse>
                                                    (PURCHASE_NET_SYSTEM_LOCATION+PURCHASE_EXTRA_COST_SYSTEM_LOCATION)
                                                </cfif>
                                            <cfelse>
                                                <cfif isdefined("attributes.display_cost_money")>
                                                    (PURCHASE_NET+PURCHASE_EXTRA_COST)
                                                <cfelse>
                                                    (PURCHASE_NET_SYSTEM+PURCHASE_EXTRA_COST_SYSTEM)
                                                </cfif>	
                                            </cfif>
                                        FROM 
                                            #dsn3_alias#.PRODUCT_COST WITH (NOLOCK) 
                                        WHERE 
                                            START_DATE <= #finish_date# 
                                            AND PRODUCT_ID = GC.PRODUCT_ID
                                            <cfif attributes.report_type eq 8>
                                                 AND ISNULL(PRODUCT_COST.SPECT_MAIN_ID,0) = ISNULL(GC.SPECT_VAR_ID,0)
                                            </cfif>
                                            
                                            <cfif isdefined("attributes.location_based_cost")>
                                                <cfif len(attributes.department_id)>
                                                    AND DEPARTMENT_ID = #listgetat(attributes.department_id,1,'-')#
                                                    AND LOCATION_ID = #listgetat(attributes.department_id,2,'-')#
                                                <cfelse>
                                                    AND DEPARTMENT_ID = SL.DEPARTMENT_ID
                                                    AND LOCATION_ID = SL.LOCATION_ID
                                                </cfif>
                                            </cfif>
                                        ORDER BY 
                                            START_DATE DESC, 
                                            RECORD_DATE DESC,
                                            PRODUCT_COST_ID DESC
                                    ),0) ALL_FINISH_COST,
                                    ISNULL(ABS(GC.STOCK_IN-GC.STOCK_OUT)*(
                                        SELECT TOP 1 
                                            <cfif isdefined("attributes.location_based_cost")>
                                                (PURCHASE_NET_SYSTEM_2_LOCATION+PURCHASE_EXTRA_COST_SYSTEM_2_LOCATION)
                                            <cfelse>
                                                (PURCHASE_NET_SYSTEM_2+PURCHASE_EXTRA_COST_SYSTEM_2)
                                            </cfif>
                                        FROM 
                                            #dsn3_alias#.PRODUCT_COST WITH (NOLOCK) 
                                        WHERE 
                                            START_DATE <= #finish_date# 
                                            AND PRODUCT_ID = GC.PRODUCT_ID
                                            <cfif attributes.report_type eq 8>
                                                 AND ISNULL(PRODUCT_COST.SPECT_MAIN_ID,0) = ISNULL(GC.SPECT_VAR_ID,0)
                                            </cfif>
                                           
                                            <cfif isdefined("attributes.location_based_cost")>
                                                <cfif len(attributes.department_id)>
                                                    AND DEPARTMENT_ID = #listgetat(attributes.department_id,1,'-')#
                                                    AND LOCATION_ID = #listgetat(attributes.department_id,2,'-')#
                                                <cfelse>
                                                    AND DEPARTMENT_ID = SL.DEPARTMENT_ID
                                                    AND LOCATION_ID = SL.LOCATION_ID
                                                </cfif>
                                            </cfif>
                                        ORDER BY 
                                            START_DATE DESC, 
                                            RECORD_DATE DESC,
                                            PRODUCT_COST_ID DESC
                                    ),0) ALL_FINISH_COST_2
                                FROM
                                    SHIP WITH (NOLOCK),
                                    INVOICE WITH (NOLOCK),
                                    INVOICE_SHIPS INV_S,
                                    <cfif isdefined('attributes.is_system_money_2') or attributes.cost_money is not session.ep.money>
                                    INVOICE_MONEY IM,
                                    </cfif>
                                    <cfif is_store or isdefined("attributes.location_based_cost")>
                                        <cfif attributes.report_type eq 8>
                                            GET_STOCKS_ROW_COST_SPECT_LOCATION AS GC,
                                        <cfelse>
                                            GET_STOCKS_ROW_COST_LOCATION AS GC,
                                        </cfif>
                                    <cfelse>
                                        <cfif attributes.report_type eq 8>
                                            GET_STOCKS_ROW_COST_SPECT AS GC,
                                        <cfelse>
                                            GET_STOCK_ROW_COST_TABLE AS GC,
                                        </cfif>
                                    </cfif>
                                    <cfif stock_table>
                                    #dsn3_alias#.STOCKS S,
                                    </cfif>
                                    #dsn_alias#.STOCKS_LOCATION SL
                                WHERE
                                    SHIP.SHIP_ID = INV_S.SHIP_ID
                                    AND INVOICE.INVOICE_ID= INV_S.INVOICE_ID
                                    AND INV_S.IS_WITH_SHIP = 1
                                    AND INV_S.SHIP_PERIOD_ID = #session.ep.period_id#
                                    AND SHIP.IS_WITH_SHIP=1
                                    AND SHIP.SHIP_ID = GC.UPD_ID
                                    AND SHIP.SHIP_TYPE = GC.PROCESS_TYPE
                                    AND GC.STORE = SL.DEPARTMENT_ID
                                    AND GC.STORE_LOCATION=SL.LOCATION_ID
                                    <cfif not isdefined('is_belognto_institution')>
                                    AND SL.BELONGTO_INSTITUTION = 0
                                    </cfif>
                                    <cfif isdefined('attributes.is_system_money_2') or attributes.cost_money is not session.ep.money>
                                        AND IM.ACTION_ID=INVOICE.INVOICE_ID
                                        <cfif isdefined('attributes.is_system_money_2')>
                                        AND IM.MONEY_TYPE = '#session.ep.money2#'
                                        <cfelse>
                                        AND IM.MONEY_TYPE = '#attributes.cost_money#'
                                        </cfif>
                                    </cfif>
                                    AND GC.PROCESS_DATE >= #attributes.date#
                                    AND GC.PROCESS_DATE <= #attributes.date2#
                                    <cfif len(attributes.department_id)>
                                    AND
                                        (
                                        <cfloop list="#attributes.department_id#" delimiters="," index="dept_i">
                                        (GC.STORE = #listfirst(dept_i,'-')# AND GC.STORE_LOCATION = #listlast(dept_i,'-')#)
                                        <cfif dept_i neq listlast(attributes.department_id,',') and listlen(attributes.department_id,',') gte 1> OR</cfif>
                                        </cfloop>  
                                        )
                                    <cfelseif is_store>
                                        AND GC.STORE IN (#branch_dep_list#)
                                    </cfif>
                                    <cfif stock_table>
                                    AND	GC.STOCK_ID=S.STOCK_ID
                                    </cfif>
                                    <cfif len(trim(attributes.sup_company)) and len(attributes.sup_company_id)>
                                        AND S.COMPANY_ID = #attributes.sup_company_id#
                                    </cfif>
                                    <cfif len(trim(attributes.employee_name)) and len(attributes.product_employee_id)>
                                        AND S.PRODUCT_MANAGER = #attributes.product_employee_id#
                                    </cfif>
                                    <cfif len(trim(attributes.product_name)) and len(attributes.product_id)>
                                        AND S.PRODUCT_ID = #attributes.product_id#
                                    </cfif>
                                    <cfif len(trim(attributes.brand_name)) and len(attributes.brand_id)>
                                        AND S.BRAND_ID = #attributes.brand_id# 
                                    </cfif>	
                                    <cfif len(trim(attributes.product_cat)) and len(attributes.product_code)>
                                        AND S.STOCK_CODE LIKE '#attributes.product_code#%'
                                    </cfif>
                            </cfif>
                            )AS GET_SHIP_ROWS
                        WHERE
                            PROCESS_TYPE = 75
                        GROUP BY
                            #ALAN_ADI#
                        )AS konsinye_iade ON GET_ALL_STOCK.PRODUCT_GROUPBY_ID = konsinye_iade.GROUPBY_ALANI
		</cfif>
        <!--- konsinye giris--->
		<cfif len(attributes.process_type) and listfind(attributes.process_type,19)>
			LEFT JOIN(
                        SELECT	
                            SUM(AMOUNT) AS KONS_GIRIS_MIKTAR,
                            <cfif isdefined("x_kons_cost_date") and x_kons_cost_date eq 1 >
                                SUM(ALL_FINISH_COST) AS KONS_GIRIS_MALIYET,
                                <cfif isdefined('attributes.is_system_money_2')>
                                SUM(ALL_FINISH_COST_2) AS KONS_GIRIS_MALIYET_2,
                                </cfif>
                            <cfelse>	
                                SUM(TOTAL_COST) AS KONS_GIRIS_MALIYET,
                                <cfif isdefined('attributes.is_system_money_2')>
                                SUM(TOTAL_COST_2) AS KONS_GIRIS_MALIYET_2,
                                </cfif>
                            </cfif>
                            #ALAN_ADI# AS GROUPBY_ALANI
                        FROM
                            (
                                SELECT
                                    GC.STOCK_ID,
                                    GC.PRODUCT_ID,
                                    <cfif attributes.report_type eq 8>
                                    CAST(GC.STOCK_ID AS NVARCHAR(50)) +'_'+ CAST(ISNULL(GC.SPECT_VAR_ID,0) AS NVARCHAR(50)) STOCK_SPEC_ID,
                                    </cfif>
                                    1 AS INVOICE_CAT,
                                    <cfif stock_table>
                                    S.PRODUCT_MANAGER,
                                    S.PRODUCT_CATID,
                                    S.BRAND_ID,
                                    </cfif>
                                    <cfif isdefined('attributes.is_system_money_2')>
                                    GC.MALIYET_2,
                                    GC.MALIYET,
                                    ((GC.MALIYET_2*ABS(GC.STOCK_IN-GC.STOCK_OUT))) AS TOTAL_COST_2,
                                    (GC.MALIYET*ABS(GC.STOCK_IN-GC.STOCK_OUT)) AS TOTAL_COST,
                                    <cfelse>
                                        <cfif attributes.cost_money is not session.ep.money>
                                        (GC.MALIYET/(SM.RATE2/SM.RATE1)) AS MALIYET,
                                        ((GC.MALIYET*ABS(GC.STOCK_IN-GC.STOCK_OUT))/(SM.RATE2/SM.RATE1)) AS TOTAL_COST,
                                        <cfelse>
                                        GC.MALIYET,
                                        (GC.MALIYET*ABS(GC.STOCK_IN-GC.STOCK_OUT)) AS TOTAL_COST,				
                                        </cfif>
                                    </cfif>
                                    ABS(GC.STOCK_IN-GC.STOCK_OUT) AS AMOUNT,
                                    GC.STOCK_IN,
                                    GC.STOCK_OUT,
                                    GC.PROCESS_DATE ISLEM_TARIHI,
                                    GC.PROCESS_TYPE PROCESS_TYPE,
                                    ISNULL(ABS(GC.STOCK_IN-GC.STOCK_OUT)*(
                                        SELECT TOP 1 
                                            <cfif isdefined("attributes.location_based_cost")>
                                                <cfif isdefined("attributes.display_cost_money")>
                                                    (PURCHASE_NET_LOCATION+PURCHASE_EXTRA_COST_LOCATION)
                                                <cfelse>
                                                    (PURCHASE_NET_SYSTEM_LOCATION+PURCHASE_EXTRA_COST_SYSTEM_LOCATION)
                                                </cfif>
                                            <cfelse>
                                                <cfif isdefined("attributes.display_cost_money")>
                                                    (PURCHASE_NET+PURCHASE_EXTRA_COST)
                                                <cfelse>
                                                    (PURCHASE_NET_SYSTEM+PURCHASE_EXTRA_COST_SYSTEM)
                                                </cfif>	
                                            </cfif>
                                        FROM 
                                            #dsn3_alias#.PRODUCT_COST WITH (NOLOCK) 
                                        WHERE 
                                            START_DATE <= #finish_date# 
                                            AND PRODUCT_ID = GC.PRODUCT_ID
                                            <cfif attributes.report_type eq 8>
                                                 AND ISNULL(PRODUCT_COST.SPECT_MAIN_ID,0) = ISNULL(GC.SPECT_VAR_ID,0)
                                            </cfif>
                                           
                                            <cfif isdefined("attributes.location_based_cost")>
                                                <cfif len(attributes.department_id)>
                                                    AND DEPARTMENT_ID = #listgetat(attributes.department_id,1,'-')#
                                                    AND LOCATION_ID = #listgetat(attributes.department_id,2,'-')#
                                                <cfelse>
                                                    AND DEPARTMENT_ID = SL.DEPARTMENT_ID
                                                    AND LOCATION_ID = SL.LOCATION_ID
                                                </cfif>
                                            </cfif>
                                        ORDER BY 
                                            START_DATE DESC, 
                                            RECORD_DATE DESC,
                                            PRODUCT_COST_ID DESC
                                    ),0) ALL_FINISH_COST,
                                    ISNULL(ABS(GC.STOCK_IN-GC.STOCK_OUT)*(
                                        SELECT TOP 1 
                                            <cfif isdefined("attributes.location_based_cost")>
                                                (PURCHASE_NET_SYSTEM_2_LOCATION+PURCHASE_EXTRA_COST_SYSTEM_2_LOCATION)
                                            <cfelse>
                                                (PURCHASE_NET_SYSTEM_2+PURCHASE_EXTRA_COST_SYSTEM_2)
                                            </cfif>
                                        FROM 
                                            #dsn3_alias#.PRODUCT_COST WITH (NOLOCK) 
                                        WHERE 
                                            START_DATE <= #finish_date# 
                                            AND PRODUCT_ID = GC.PRODUCT_ID
                                            <cfif attributes.report_type eq 8>
                                                 AND ISNULL(PRODUCT_COST.SPECT_MAIN_ID,0) = ISNULL(GC.SPECT_VAR_ID,0)
                                            </cfif>
                                            
                                            <cfif isdefined("attributes.location_based_cost")>
                                                <cfif len(attributes.department_id)>
                                                    AND DEPARTMENT_ID = #listgetat(attributes.department_id,1,'-')#
                                                    AND LOCATION_ID = #listgetat(attributes.department_id,2,'-')#
                                                <cfelse>
                                                    AND DEPARTMENT_ID = SL.DEPARTMENT_ID
                                                    AND LOCATION_ID = SL.LOCATION_ID
                                                </cfif>
                                            </cfif>
                                        ORDER BY 
                                            START_DATE DESC, 
                                            RECORD_DATE DESC,
                                            PRODUCT_COST_ID DESC
                                    ),0) ALL_FINISH_COST_2
                                FROM
                                    <cfif is_store or isdefined("attributes.location_based_cost")>
                                        <cfif attributes.report_type eq 8>
                                            GET_STOCKS_ROW_COST_SPECT_LOCATION AS GC,
                                        <cfelse>
                                            GET_STOCKS_ROW_COST_LOCATION AS GC,
                                        </cfif>
                                    <cfelse>
                                        <cfif attributes.report_type eq 8>
                                            GET_STOCKS_ROW_COST_SPECT AS GC,
                                        <cfelse>
                                            GET_STOCK_ROW_COST_TABLE AS GC,
                                        </cfif>
                                    </cfif>
                                    <cfif attributes.cost_money is not session.ep.money or isdefined('attributes.is_system_money_2') or listfind(attributes.process_type,3)>
                                    SHIP WITH (NOLOCK),	
                                    </cfif>
                                    <cfif attributes.cost_money is not session.ep.money or isdefined('attributes.is_system_money_2')>
                                    SHIP_MONEY SM,
                                    </cfif>
                                    <cfif stock_table>
                                    #dsn3_alias#.STOCKS S,
                                    </cfif>
                                    #dsn_alias#.STOCKS_LOCATION SL
                                WHERE
                                    GC.STORE = SL.DEPARTMENT_ID
                                    AND GC.STORE_LOCATION=SL.LOCATION_ID
                                    <cfif not isdefined('is_belognto_institution')>
                                    AND SL.BELONGTO_INSTITUTION = 0
                                    </cfif>
                                    <cfif attributes.cost_money is not session.ep.money or isdefined('attributes.is_system_money_2') or listfind(attributes.process_type,3)>
                                    AND GC.UPD_ID = SHIP.SHIP_ID
                                    AND SHIP.SHIP_TYPE = GC.PROCESS_TYPE
                                    AND ISNULL(SHIP.IS_WITH_SHIP,0)=0
                                    </cfif>
                                    <cfif attributes.cost_money is not session.ep.money or isdefined('attributes.is_system_money_2')>
                                    AND SHIP.SHIP_ID = SM.ACTION_ID
                                        <cfif isdefined('attributes.is_system_money_2')>
                                            AND SM.MONEY_TYPE = '#session.ep.money2#'
                                        <cfelse>
                                            AND SM.MONEY_TYPE = '#attributes.cost_money#'
                                        </cfif>
                                    </cfif>
                                    AND GC.PROCESS_DATE >= #attributes.date#
                                    AND GC.PROCESS_DATE <= #attributes.date2#
                                    <cfif len(attributes.department_id)>
                                    AND
                                        (
                                        <cfloop list="#attributes.department_id#" delimiters="," index="dept_i">
                                        (GC.STORE = #listfirst(dept_i,'-')# AND GC.STORE_LOCATION = #listlast(dept_i,'-')#)
                                        <cfif dept_i neq listlast(attributes.department_id,',') and listlen(attributes.department_id,',') gte 1> OR</cfif>
                                        </cfloop>  
                                        )
                                    <cfelseif is_store>
                                        AND GC.STORE IN (#branch_dep_list#)
                                    </cfif>
                                    <cfif stock_table>
                                    AND	GC.STOCK_ID=S.STOCK_ID
                                    </cfif>
                                    <cfif len(trim(attributes.sup_company)) and len(attributes.sup_company_id)>
                                    AND S.COMPANY_ID = #attributes.sup_company_id#
                                    </cfif>
                                    <cfif len(trim(attributes.employee_name)) and len(attributes.product_employee_id)>
                                    AND S.PRODUCT_MANAGER = #attributes.product_employee_id#
                                    </cfif>
                                    <cfif len(trim(attributes.product_name)) and len(attributes.product_id)>
                                    AND S.PRODUCT_ID = #attributes.product_id#
                                    </cfif>
                                    <cfif len(trim(attributes.brand_name)) and len(attributes.brand_id)>
                                    AND S.BRAND_ID = #attributes.brand_id# 
                                    </cfif>	
                                    <cfif len(trim(attributes.product_cat)) and len(attributes.product_code)>
                                    AND S.STOCK_CODE LIKE '#attributes.product_code#%'
                                    </cfif>
                            <cfif attributes.cost_money is not session.ep.money or listfind(attributes.process_type,3)>
                            UNION ALL
                                SELECT
                                    GC.STOCK_ID,
                                    GC.PRODUCT_ID,
                                    <cfif attributes.report_type eq 8>
                                    CAST(GC.STOCK_ID AS NVARCHAR(50)) +'_'+ CAST(ISNULL(GC.SPECT_VAR_ID,0) AS NVARCHAR(50)) STOCK_SPEC_ID,
                                    </cfif>
                                    INVOICE.INVOICE_CAT,
                                    <cfif stock_table>
                                    S.PRODUCT_MANAGER,
                                    S.PRODUCT_CATID,
                                    S.BRAND_ID,
                                    </cfif>
                                    <cfif isdefined('attributes.is_system_money_2') or attributes.cost_money is not session.ep.money>
                                        <cfif isdefined('attributes.is_system_money_2')>
                                        GC.MALIYET_2,
                                        GC.MALIYET,
                                        ((GC.MALIYET_2*ABS(GC.STOCK_IN-GC.STOCK_OUT))) AS TOTAL_COST_2,
                                        (GC.MALIYET*ABS(GC.STOCK_IN-GC.STOCK_OUT)) AS TOTAL_COST,
                                        <cfelse>
                                            (GC.MALIYET/(IM.RATE2/IM.RATE1)) AS MALIYET,
                                            ((GC.MALIYET*ABS(GC.STOCK_IN-GC.STOCK_OUT))/(IM.RATE2/IM.RATE1)) AS TOTAL_COST,
                                        </cfif>
                                    <cfelse>
                                        (GC.MALIYET) AS MALIYET,
                                        ((GC.MALIYET*ABS(GC.STOCK_IN-GC.STOCK_OUT))) AS TOTAL_COST,
                                    </cfif>
                                    ABS(GC.STOCK_IN-GC.STOCK_OUT) AS AMOUNT,
                                    GC.STOCK_IN,
                                    GC.STOCK_OUT,
                                    GC.PROCESS_DATE ISLEM_TARIHI,
                                    GC.PROCESS_TYPE PROCESS_TYPE,
                                    ISNULL(ABS(GC.STOCK_IN-GC.STOCK_OUT)*(
                                        SELECT TOP 1 
                                            <cfif isdefined("attributes.location_based_cost")>
                                                <cfif isdefined("attributes.display_cost_money")>
                                                    (PURCHASE_NET_LOCATION+PURCHASE_EXTRA_COST_LOCATION)
                                                <cfelse>
                                                    (PURCHASE_NET_SYSTEM_LOCATION+PURCHASE_EXTRA_COST_SYSTEM_LOCATION)
                                                </cfif>
                                            <cfelse>
                                                <cfif isdefined("attributes.display_cost_money")>
                                                    (PURCHASE_NET+PURCHASE_EXTRA_COST)
                                                <cfelse>
                                                    (PURCHASE_NET_SYSTEM+PURCHASE_EXTRA_COST_SYSTEM)
                                                </cfif>	
                                            </cfif>
                                        FROM 
                                            #dsn3_alias#.PRODUCT_COST WITH (NOLOCK) 
                                        WHERE 
                                            START_DATE <= #finish_date# 
                                            AND PRODUCT_ID = GC.PRODUCT_ID
                                            <cfif attributes.report_type eq 8>
                                                 AND ISNULL(PRODUCT_COST.SPECT_MAIN_ID,0) = ISNULL(GC.SPECT_VAR_ID,0)
                                            </cfif>
                                           
                                            <cfif isdefined("attributes.location_based_cost")>
                                                <cfif len(attributes.department_id)>
                                                    AND DEPARTMENT_ID = #listgetat(attributes.department_id,1,'-')#
                                                    AND LOCATION_ID = #listgetat(attributes.department_id,2,'-')#
                                                <cfelse>
                                                    AND DEPARTMENT_ID = SL.DEPARTMENT_ID
                                                    AND LOCATION_ID = SL.LOCATION_ID
                                                </cfif>
                                            </cfif>
                                        ORDER BY 
                                            START_DATE DESC, 
                                            RECORD_DATE DESC,
                                            PRODUCT_COST_ID DESC
                                    ),0) ALL_FINISH_COST,
                                    ISNULL(ABS(GC.STOCK_IN-GC.STOCK_OUT)*(
                                        SELECT TOP 1 
                                            <cfif isdefined("attributes.location_based_cost")>
                                                (PURCHASE_NET_SYSTEM_2_LOCATION+PURCHASE_EXTRA_COST_SYSTEM_2_LOCATION)
                                            <cfelse>
                                                (PURCHASE_NET_SYSTEM_2+PURCHASE_EXTRA_COST_SYSTEM_2)
                                            </cfif>
                                        FROM 
                                            #dsn3_alias#.PRODUCT_COST WITH (NOLOCK) 
                                        WHERE 
                                            START_DATE <= #finish_date# 
                                            AND PRODUCT_ID = GC.PRODUCT_ID
                                            <cfif attributes.report_type eq 8>
                                                 AND ISNULL(PRODUCT_COST.SPECT_MAIN_ID,0) = ISNULL(GC.SPECT_VAR_ID,0)
                                            </cfif>
                                            
                                            <cfif isdefined("attributes.location_based_cost")>
                                                <cfif len(attributes.department_id)>
                                                    AND DEPARTMENT_ID = #listgetat(attributes.department_id,1,'-')#
                                                    AND LOCATION_ID = #listgetat(attributes.department_id,2,'-')#
                                                <cfelse>
                                                    AND DEPARTMENT_ID = SL.DEPARTMENT_ID
                                                    AND LOCATION_ID = SL.LOCATION_ID
                                                </cfif>
                                            </cfif>
                                        ORDER BY 
                                            START_DATE DESC, 
                                            RECORD_DATE DESC,
                                            PRODUCT_COST_ID DESC
                                    ),0) ALL_FINISH_COST_2
                                FROM
                                    SHIP WITH (NOLOCK),
                                    INVOICE WITH (NOLOCK),
                                    INVOICE_SHIPS INV_S,
                                    <cfif isdefined('attributes.is_system_money_2') or attributes.cost_money is not session.ep.money>
                                    INVOICE_MONEY IM,
                                    </cfif>
                                    <cfif is_store or isdefined("attributes.location_based_cost")>
                                        <cfif attributes.report_type eq 8>
                                            GET_STOCKS_ROW_COST_SPECT_LOCATION AS GC,
                                        <cfelse>
                                            GET_STOCKS_ROW_COST_LOCATION AS GC,
                                        </cfif>
                                    <cfelse>
                                        <cfif attributes.report_type eq 8>
                                            GET_STOCKS_ROW_COST_SPECT AS GC,
                                        <cfelse>
                                            GET_STOCK_ROW_COST_TABLE AS GC,
                                        </cfif>
                                    </cfif>
                                    <cfif stock_table>
                                    #dsn3_alias#.STOCKS S,
                                    </cfif>
                                    #dsn_alias#.STOCKS_LOCATION SL
                                WHERE
                                    SHIP.SHIP_ID = INV_S.SHIP_ID
                                    AND INVOICE.INVOICE_ID= INV_S.INVOICE_ID
                                    AND INV_S.IS_WITH_SHIP = 1
                                    AND INV_S.SHIP_PERIOD_ID = #session.ep.period_id#
                                    AND SHIP.IS_WITH_SHIP=1
                                    AND SHIP.SHIP_ID = GC.UPD_ID
                                    AND SHIP.SHIP_TYPE = GC.PROCESS_TYPE
                                    AND GC.STORE = SL.DEPARTMENT_ID
                                    AND GC.STORE_LOCATION=SL.LOCATION_ID
                                    <cfif not isdefined('is_belognto_institution')>
                                    AND SL.BELONGTO_INSTITUTION = 0
                                    </cfif>
                                    <cfif isdefined('attributes.is_system_money_2') or attributes.cost_money is not session.ep.money>
                                        AND IM.ACTION_ID=INVOICE.INVOICE_ID
                                        <cfif isdefined('attributes.is_system_money_2')>
                                        AND IM.MONEY_TYPE = '#session.ep.money2#'
                                        <cfelse>
                                        AND IM.MONEY_TYPE = '#attributes.cost_money#'
                                        </cfif>
                                    </cfif>
                                    AND GC.PROCESS_DATE >= #attributes.date#
                                    AND GC.PROCESS_DATE <= #attributes.date2#
                                    <cfif len(attributes.department_id)>
                                    AND
                                        (
                                        <cfloop list="#attributes.department_id#" delimiters="," index="dept_i">
                                        (GC.STORE = #listfirst(dept_i,'-')# AND GC.STORE_LOCATION = #listlast(dept_i,'-')#)
                                        <cfif dept_i neq listlast(attributes.department_id,',') and listlen(attributes.department_id,',') gte 1> OR</cfif>
                                        </cfloop>  
                                        )
                                    <cfelseif is_store>
                                        AND GC.STORE IN (#branch_dep_list#)
                                    </cfif>
                                    <cfif stock_table>
                                    AND	GC.STOCK_ID=S.STOCK_ID
                                    </cfif>
                                    <cfif len(trim(attributes.sup_company)) and len(attributes.sup_company_id)>
                                        AND S.COMPANY_ID = #attributes.sup_company_id#
                                    </cfif>
                                    <cfif len(trim(attributes.employee_name)) and len(attributes.product_employee_id)>
                                        AND S.PRODUCT_MANAGER = #attributes.product_employee_id#
                                    </cfif>
                                    <cfif len(trim(attributes.product_name)) and len(attributes.product_id)>
                                        AND S.PRODUCT_ID = #attributes.product_id#
                                    </cfif>
                                    <cfif len(trim(attributes.brand_name)) and len(attributes.brand_id)>
                                        AND S.BRAND_ID = #attributes.brand_id# 
                                    </cfif>	
                                    <cfif len(trim(attributes.product_cat)) and len(attributes.product_code)>
                                        AND S.STOCK_CODE LIKE '#attributes.product_code#%'
                                    </cfif>
                            </cfif>
                            )AS GET_SHIP_ROWS
                        WHERE
                            PROCESS_TYPE = 77
                        GROUP BY
                            #ALAN_ADI#
                        )AS konsinye_giris ON GET_ALL_STOCK.PRODUCT_GROUPBY_ID = konsinye_giris.GROUPBY_ALANI
		</cfif>
        <!--- konsinye giris iade--->
		<cfif len(attributes.process_type) and listfind(attributes.process_type,20)>
			LEFT JOIN(
                        SELECT	
                            SUM(AMOUNT) AS KONS_GIRIS_IADE_MIKTAR,
                            <cfif isdefined("x_kons_cost_date") and x_kons_cost_date eq 1>
                                SUM(ALL_FINISH_COST) AS KONS_GIRIS_IADE_MALIYET,
                                <cfif isdefined('attributes.is_system_money_2')>
                                SUM(ALL_FINISH_COST_2) AS KONS_GIRIS_IADE_MALIYET_2,
                                </cfif>
                            <cfelse>	
                                SUM(TOTAL_COST) AS KONS_GIRIS_IADE_MALIYET,
                                <cfif isdefined('attributes.is_system_money_2')>
                                SUM(TOTAL_COST_2) AS KONS_GIRIS_IADE_MALIYET_2,
                                </cfif>
                            </cfif>
                            #ALAN_ADI# AS GROUPBY_ALANI
                        FROM
                            (
                                SELECT
                                    GC.STOCK_ID,
                                    GC.PRODUCT_ID,
                                    <cfif attributes.report_type eq 8>
                                    CAST(GC.STOCK_ID AS NVARCHAR(50)) +'_'+ CAST(ISNULL(GC.SPECT_VAR_ID,0) AS NVARCHAR(50)) STOCK_SPEC_ID,
                                    </cfif>
                                    1 AS INVOICE_CAT,
                                    <cfif stock_table>
                                    S.PRODUCT_MANAGER,
                                    S.PRODUCT_CATID,
                                    S.BRAND_ID,
                                    </cfif>
                                    <cfif isdefined('attributes.is_system_money_2')>
                                    GC.MALIYET_2,
                                    GC.MALIYET,
                                    ((GC.MALIYET_2*ABS(GC.STOCK_IN-GC.STOCK_OUT))) AS TOTAL_COST_2,
                                    (GC.MALIYET*ABS(GC.STOCK_IN-GC.STOCK_OUT)) AS TOTAL_COST,
                                    <cfelse>
                                        <cfif attributes.cost_money is not session.ep.money>
                                        (GC.MALIYET/(SM.RATE2/SM.RATE1)) AS MALIYET,
                                        ((GC.MALIYET*ABS(GC.STOCK_IN-GC.STOCK_OUT))/(SM.RATE2/SM.RATE1)) AS TOTAL_COST,
                                        <cfelse>
                                        GC.MALIYET,
                                        (GC.MALIYET*ABS(GC.STOCK_IN-GC.STOCK_OUT)) AS TOTAL_COST,				
                                        </cfif>
                                    </cfif>
                                    ABS(GC.STOCK_IN-GC.STOCK_OUT) AS AMOUNT,
                                    GC.STOCK_IN,
                                    GC.STOCK_OUT,
                                    GC.PROCESS_DATE ISLEM_TARIHI,
                                    GC.PROCESS_TYPE PROCESS_TYPE,
                                    ISNULL(ABS(GC.STOCK_IN-GC.STOCK_OUT)*(
                                        SELECT TOP 1 
                                            <cfif isdefined("attributes.location_based_cost")>
                                                <cfif isdefined("attributes.display_cost_money")>
                                                    (PURCHASE_NET_LOCATION+PURCHASE_EXTRA_COST_LOCATION)
                                                <cfelse>
                                                    (PURCHASE_NET_SYSTEM_LOCATION+PURCHASE_EXTRA_COST_SYSTEM_LOCATION)
                                                </cfif>
                                            <cfelse>
                                                <cfif isdefined("attributes.display_cost_money")>
                                                    (PURCHASE_NET+PURCHASE_EXTRA_COST)
                                                <cfelse>
                                                    (PURCHASE_NET_SYSTEM+PURCHASE_EXTRA_COST_SYSTEM)
                                                </cfif>	
                                            </cfif>
                                        FROM 
                                            #dsn3_alias#.PRODUCT_COST WITH (NOLOCK) 
                                        WHERE 
                                            START_DATE <= #finish_date# 
                                            AND PRODUCT_ID = GC.PRODUCT_ID
                                            <cfif attributes.report_type eq 8>
                                                 AND ISNULL(PRODUCT_COST.SPECT_MAIN_ID,0) = ISNULL(GC.SPECT_VAR_ID,0)
                                            </cfif>
                                            
                                            <cfif isdefined("attributes.location_based_cost")>
                                                <cfif len(attributes.department_id)>
                                                    AND DEPARTMENT_ID = #listgetat(attributes.department_id,1,'-')#
                                                    AND LOCATION_ID = #listgetat(attributes.department_id,2,'-')#
                                                <cfelse>
                                                    AND DEPARTMENT_ID = SL.DEPARTMENT_ID
                                                    AND LOCATION_ID = SL.LOCATION_ID
                                                </cfif>
                                            </cfif>
                                        ORDER BY 
                                            START_DATE DESC, 
                                            RECORD_DATE DESC,
                                            PRODUCT_COST_ID DESC
                                    ),0) ALL_FINISH_COST,
                                    ISNULL(ABS(GC.STOCK_IN-GC.STOCK_OUT)*(
                                        SELECT TOP 1 
                                            <cfif isdefined("attributes.location_based_cost")>
                                                (PURCHASE_NET_SYSTEM_2_LOCATION+PURCHASE_EXTRA_COST_SYSTEM_2_LOCATION)
                                            <cfelse>
                                                (PURCHASE_NET_SYSTEM_2+PURCHASE_EXTRA_COST_SYSTEM_2)
                                            </cfif>
                                        FROM 
                                            #dsn3_alias#.PRODUCT_COST WITH (NOLOCK) 
                                        WHERE 
                                            START_DATE <= #finish_date# 
                                            AND PRODUCT_ID = GC.PRODUCT_ID
                                            <cfif attributes.report_type eq 8>
                                                 AND ISNULL(PRODUCT_COST.SPECT_MAIN_ID,0) = ISNULL(GC.SPECT_VAR_ID,0)
                                            </cfif>
                                           
                                            <cfif isdefined("attributes.location_based_cost")>
                                                <cfif len(attributes.department_id)>
                                                    AND DEPARTMENT_ID = #listgetat(attributes.department_id,1,'-')#
                                                    AND LOCATION_ID = #listgetat(attributes.department_id,2,'-')#
                                                <cfelse>
                                                    AND DEPARTMENT_ID = SL.DEPARTMENT_ID
                                                    AND LOCATION_ID = SL.LOCATION_ID
                                                </cfif>
                                            </cfif>
                                        ORDER BY 
                                            START_DATE DESC, 
                                            RECORD_DATE DESC,
                                            PRODUCT_COST_ID DESC
                                    ),0) ALL_FINISH_COST_2
                                FROM
                                    <cfif is_store or isdefined("attributes.location_based_cost")>
                                        <cfif attributes.report_type eq 8>
                                            GET_STOCKS_ROW_COST_SPECT_LOCATION AS GC,
                                        <cfelse>
                                            GET_STOCKS_ROW_COST_LOCATION AS GC,
                                        </cfif>
                                    <cfelse>
                                        <cfif attributes.report_type eq 8>
                                            GET_STOCKS_ROW_COST_SPECT AS GC,
                                        <cfelse>
                                            GET_STOCK_ROW_COST_TABLE AS GC,
                                        </cfif>
                                    </cfif>
                                    <cfif attributes.cost_money is not session.ep.money or isdefined('attributes.is_system_money_2') or listfind(attributes.process_type,3)>
                                    SHIP WITH (NOLOCK),	
                                    </cfif>
                                    <cfif attributes.cost_money is not session.ep.money or isdefined('attributes.is_system_money_2')>
                                    SHIP_MONEY SM,
                                    </cfif>
                                    <cfif stock_table>
                                    #dsn3_alias#.STOCKS S,
                                    </cfif>
                                    #dsn_alias#.STOCKS_LOCATION SL
                                WHERE
                                    GC.STORE = SL.DEPARTMENT_ID
                                    AND GC.STORE_LOCATION=SL.LOCATION_ID
                                    <cfif not isdefined('is_belognto_institution')>
                                    AND SL.BELONGTO_INSTITUTION = 0
                                    </cfif>
                                    <cfif attributes.cost_money is not session.ep.money or isdefined('attributes.is_system_money_2') or listfind(attributes.process_type,3)>
                                    AND GC.UPD_ID = SHIP.SHIP_ID
                                    AND SHIP.SHIP_TYPE = GC.PROCESS_TYPE
                                    AND ISNULL(SHIP.IS_WITH_SHIP,0)=0
                                    </cfif>
                                    <cfif attributes.cost_money is not session.ep.money or isdefined('attributes.is_system_money_2')>
                                    AND SHIP.SHIP_ID = SM.ACTION_ID
                                        <cfif isdefined('attributes.is_system_money_2')>
                                            AND SM.MONEY_TYPE = '#session.ep.money2#'
                                        <cfelse>
                                            AND SM.MONEY_TYPE = '#attributes.cost_money#'
                                        </cfif>
                                    </cfif>
                                    AND GC.PROCESS_DATE >= #attributes.date#
                                    AND GC.PROCESS_DATE <= #attributes.date2#
                                    <cfif len(attributes.department_id)>
                                    AND
                                        (
                                        <cfloop list="#attributes.department_id#" delimiters="," index="dept_i">
                                        (GC.STORE = #listfirst(dept_i,'-')# AND GC.STORE_LOCATION = #listlast(dept_i,'-')#)
                                        <cfif dept_i neq listlast(attributes.department_id,',') and listlen(attributes.department_id,',') gte 1> OR</cfif>
                                        </cfloop>  
                                        )
                                    <cfelseif is_store>
                                        AND GC.STORE IN (#branch_dep_list#)
                                    </cfif>
                                    <cfif stock_table>
                                    AND	GC.STOCK_ID=S.STOCK_ID
                                    </cfif>
                                    <cfif len(trim(attributes.sup_company)) and len(attributes.sup_company_id)>
                                    AND S.COMPANY_ID = #attributes.sup_company_id#
                                    </cfif>
                                    <cfif len(trim(attributes.employee_name)) and len(attributes.product_employee_id)>
                                    AND S.PRODUCT_MANAGER = #attributes.product_employee_id#
                                    </cfif>
                                    <cfif len(trim(attributes.product_name)) and len(attributes.product_id)>
                                    AND S.PRODUCT_ID = #attributes.product_id#
                                    </cfif>
                                    <cfif len(trim(attributes.brand_name)) and len(attributes.brand_id)>
                                    AND S.BRAND_ID = #attributes.brand_id# 
                                    </cfif>	
                                    <cfif len(trim(attributes.product_cat)) and len(attributes.product_code)>
                                    AND S.STOCK_CODE LIKE '#attributes.product_code#%'
                                    </cfif>
                            <cfif attributes.cost_money is not session.ep.money or listfind(attributes.process_type,3)>
                            UNION ALL
                                SELECT
                                    GC.STOCK_ID,
                                    GC.PRODUCT_ID,
                                    <cfif attributes.report_type eq 8>
                                    CAST(GC.STOCK_ID AS NVARCHAR(50)) +'_'+ CAST(ISNULL(GC.SPECT_VAR_ID,0) AS NVARCHAR(50)) STOCK_SPEC_ID,
                                    </cfif>
                                    INVOICE.INVOICE_CAT,
                                    <cfif stock_table>
                                    S.PRODUCT_MANAGER,
                                    S.PRODUCT_CATID,
                                    S.BRAND_ID,
                                    </cfif>
                                    <cfif isdefined('attributes.is_system_money_2') or attributes.cost_money is not session.ep.money>
                                        <cfif isdefined('attributes.is_system_money_2')>
                                        GC.MALIYET_2,
                                        GC.MALIYET,
                                        ((GC.MALIYET_2*ABS(GC.STOCK_IN-GC.STOCK_OUT))) AS TOTAL_COST_2,
                                        (GC.MALIYET*ABS(GC.STOCK_IN-GC.STOCK_OUT)) AS TOTAL_COST,
                                        <cfelse>
                                            (GC.MALIYET/(IM.RATE2/IM.RATE1)) AS MALIYET,
                                            ((GC.MALIYET*ABS(GC.STOCK_IN-GC.STOCK_OUT))/(IM.RATE2/IM.RATE1)) AS TOTAL_COST,
                                        </cfif>
                                    <cfelse>
                                        (GC.MALIYET) AS MALIYET,
                                        ((GC.MALIYET*ABS(GC.STOCK_IN-GC.STOCK_OUT))) AS TOTAL_COST,
                                    </cfif>
                                    ABS(GC.STOCK_IN-GC.STOCK_OUT) AS AMOUNT,
                                    GC.STOCK_IN,
                                    GC.STOCK_OUT,
                                    GC.PROCESS_DATE ISLEM_TARIHI,
                                    GC.PROCESS_TYPE PROCESS_TYPE,
                                    ISNULL(ABS(GC.STOCK_IN-GC.STOCK_OUT)*(
                                        SELECT TOP 1 
                                            <cfif isdefined("attributes.location_based_cost")>
                                                <cfif isdefined("attributes.display_cost_money")>
                                                    (PURCHASE_NET_LOCATION+PURCHASE_EXTRA_COST_LOCATION)
                                                <cfelse>
                                                    (PURCHASE_NET_SYSTEM_LOCATION+PURCHASE_EXTRA_COST_SYSTEM_LOCATION)
                                                </cfif>
                                            <cfelse>
                                                <cfif isdefined("attributes.display_cost_money")>
                                                    (PURCHASE_NET+PURCHASE_EXTRA_COST)
                                                <cfelse>
                                                    (PURCHASE_NET_SYSTEM+PURCHASE_EXTRA_COST_SYSTEM)
                                                </cfif>	
                                            </cfif>
                                        FROM 
                                            #dsn3_alias#.PRODUCT_COST WITH (NOLOCK) 
                                        WHERE 
                                            START_DATE <= #finish_date# 
                                            AND PRODUCT_ID = GC.PRODUCT_ID
                                            <cfif attributes.report_type eq 8>
                                                 AND ISNULL(PRODUCT_COST.SPECT_MAIN_ID,0) = ISNULL(GC.SPECT_VAR_ID,0)
                                            </cfif>
                                           
                                            <cfif isdefined("attributes.location_based_cost")>
                                                <cfif len(attributes.department_id)>
                                                    AND DEPARTMENT_ID = #listgetat(attributes.department_id,1,'-')#
                                                    AND LOCATION_ID = #listgetat(attributes.department_id,2,'-')#
                                                <cfelse>
                                                    AND DEPARTMENT_ID = SL.DEPARTMENT_ID
                                                    AND LOCATION_ID = SL.LOCATION_ID
                                                </cfif>
                                            </cfif>
                                        ORDER BY 
                                            START_DATE DESC, 
                                            RECORD_DATE DESC,
                                            PRODUCT_COST_ID DESC
                                    ),0) ALL_FINISH_COST,
                                    ISNULL(ABS(GC.STOCK_IN-GC.STOCK_OUT)*(
                                        SELECT TOP 1 
                                            <cfif isdefined("attributes.location_based_cost")>
                                                (PURCHASE_NET_SYSTEM_2_LOCATION+PURCHASE_EXTRA_COST_SYSTEM_2_LOCATION)
                                            <cfelse>
                                                (PURCHASE_NET_SYSTEM_2+PURCHASE_EXTRA_COST_SYSTEM_2)
                                            </cfif>
                                        FROM 
                                            #dsn3_alias#.PRODUCT_COST WITH (NOLOCK) 
                                        WHERE 
                                            START_DATE <= #finish_date# 
                                            AND PRODUCT_ID = GC.PRODUCT_ID
                                            <cfif attributes.report_type eq 8>
                                                 AND ISNULL(PRODUCT_COST.SPECT_MAIN_ID,0) = ISNULL(GC.SPECT_VAR_ID,0)
                                            </cfif>
                                            
                                            <cfif isdefined("attributes.location_based_cost")>
                                                <cfif len(attributes.department_id)>
                                                    AND DEPARTMENT_ID = #listgetat(attributes.department_id,1,'-')#
                                                    AND LOCATION_ID = #listgetat(attributes.department_id,2,'-')#
                                                <cfelse>
                                                    AND DEPARTMENT_ID = SL.DEPARTMENT_ID
                                                    AND LOCATION_ID = SL.LOCATION_ID
                                                </cfif>
                                            </cfif>
                                        ORDER BY 
                                            START_DATE DESC, 
                                            RECORD_DATE DESC,
                                            PRODUCT_COST_ID DESC
                                    ),0) ALL_FINISH_COST_2
                                FROM
                                    SHIP WITH (NOLOCK),
                                    INVOICE WITH (NOLOCK),
                                    INVOICE_SHIPS INV_S,
                                    <cfif isdefined('attributes.is_system_money_2') or attributes.cost_money is not session.ep.money>
                                    INVOICE_MONEY IM,
                                    </cfif>
                                    <cfif is_store or isdefined("attributes.location_based_cost")>
                                        <cfif attributes.report_type eq 8>
                                            GET_STOCKS_ROW_COST_SPECT_LOCATION AS GC,
                                        <cfelse>
                                            GET_STOCKS_ROW_COST_LOCATION AS GC,
                                        </cfif>
                                    <cfelse>
                                        <cfif attributes.report_type eq 8>
                                            GET_STOCKS_ROW_COST_SPECT AS GC,
                                        <cfelse>
                                            GET_STOCK_ROW_COST_TABLE AS GC,
                                        </cfif>
                                    </cfif>
                                    <cfif stock_table>
                                    #dsn3_alias#.STOCKS S,
                                    </cfif>
                                    #dsn_alias#.STOCKS_LOCATION SL
                                WHERE
                                    SHIP.SHIP_ID = INV_S.SHIP_ID
                                    AND INVOICE.INVOICE_ID= INV_S.INVOICE_ID
                                    AND INV_S.IS_WITH_SHIP = 1
                                    AND INV_S.SHIP_PERIOD_ID = #session.ep.period_id#
                                    AND SHIP.IS_WITH_SHIP=1
                                    AND SHIP.SHIP_ID = GC.UPD_ID
                                    AND SHIP.SHIP_TYPE = GC.PROCESS_TYPE
                                    AND GC.STORE = SL.DEPARTMENT_ID
                                    AND GC.STORE_LOCATION=SL.LOCATION_ID
                                    <cfif not isdefined('is_belognto_institution')>
                                    AND SL.BELONGTO_INSTITUTION = 0
                                    </cfif>
                                    <cfif isdefined('attributes.is_system_money_2') or attributes.cost_money is not session.ep.money>
                                        AND IM.ACTION_ID=INVOICE.INVOICE_ID
                                        <cfif isdefined('attributes.is_system_money_2')>
                                        AND IM.MONEY_TYPE = '#session.ep.money2#'
                                        <cfelse>
                                        AND IM.MONEY_TYPE = '#attributes.cost_money#'
                                        </cfif>
                                    </cfif>
                                    AND GC.PROCESS_DATE >= #attributes.date#
                                    AND GC.PROCESS_DATE <= #attributes.date2#
                                    <cfif len(attributes.department_id)>
                                    AND
                                        (
                                        <cfloop list="#attributes.department_id#" delimiters="," index="dept_i">
                                        (GC.STORE = #listfirst(dept_i,'-')# AND GC.STORE_LOCATION = #listlast(dept_i,'-')#)
                                        <cfif dept_i neq listlast(attributes.department_id,',') and listlen(attributes.department_id,',') gte 1> OR</cfif>
                                        </cfloop>  
                                        )
                                    <cfelseif is_store>
                                        AND GC.STORE IN (#branch_dep_list#)
                                    </cfif>
                                    <cfif stock_table>
                                    AND	GC.STOCK_ID=S.STOCK_ID
                                    </cfif>
                                    <cfif len(trim(attributes.sup_company)) and len(attributes.sup_company_id)>
                                        AND S.COMPANY_ID = #attributes.sup_company_id#
                                    </cfif>
                                    <cfif len(trim(attributes.employee_name)) and len(attributes.product_employee_id)>
                                        AND S.PRODUCT_MANAGER = #attributes.product_employee_id#
                                    </cfif>
                                    <cfif len(trim(attributes.product_name)) and len(attributes.product_id)>
                                        AND S.PRODUCT_ID = #attributes.product_id#
                                    </cfif>
                                    <cfif len(trim(attributes.brand_name)) and len(attributes.brand_id)>
                                        AND S.BRAND_ID = #attributes.brand_id# 
                                    </cfif>	
                                    <cfif len(trim(attributes.product_cat)) and len(attributes.product_code)>
                                        AND S.STOCK_CODE LIKE '#attributes.product_code#%'
                                    </cfif>
                            </cfif>
                            )AS GET_SHIP_ROWS
                        WHERE
                            PROCESS_TYPE = 79
                        GROUP BY
                            #ALAN_ADI#
                        )AS konsinye_giris_iade ON GET_ALL_STOCK.PRODUCT_GROUPBY_ID = konsinye_giris_iade.GROUPBY_ALANI
		</cfif>
        <!--- Teknik Servis Giriş --->
		<cfif len(attributes.process_type) and listfind(attributes.process_type,8)>
			LEFT JOIN(
                        SELECT	
                            SUM(AMOUNT) AS SERVIS_GIRIS_MIKTAR,
                            SUM(TOTAL_COST) AS SERVIS_GIRIS_MALIYET,
                            <cfif isdefined('attributes.is_system_money_2')>
                            SUM(TOTAL_COST) AS SERVIS_GIRIS_MALIYET_2,
                            </cfif>
                            #ALAN_ADI# AS GROUPBY_ALANI
                        FROM
                            (
                                SELECT
                                    GC.STOCK_ID,
                                    GC.PRODUCT_ID,
                                    <cfif attributes.report_type eq 8>
                                    CAST(GC.STOCK_ID AS NVARCHAR(50)) +'_'+ CAST(ISNULL(GC.SPECT_VAR_ID,0) AS NVARCHAR(50)) STOCK_SPEC_ID,
                                    </cfif>
                                    1 AS INVOICE_CAT,
                                    <cfif stock_table>
                                    S.PRODUCT_MANAGER,

                                    S.PRODUCT_CATID,
                                    S.BRAND_ID,
                                    </cfif>
                                    <cfif isdefined('attributes.is_system_money_2')>
                                    GC.MALIYET_2,
                                    GC.MALIYET,
                                    ((GC.MALIYET_2*ABS(GC.STOCK_IN-GC.STOCK_OUT))) AS TOTAL_COST_2,
                                    (GC.MALIYET*ABS(GC.STOCK_IN-GC.STOCK_OUT)) AS TOTAL_COST,
                                    <cfelse>
                                        <cfif attributes.cost_money is not session.ep.money>
                                        (GC.MALIYET/(SM.RATE2/SM.RATE1)) AS MALIYET,
                                        ((GC.MALIYET*ABS(GC.STOCK_IN-GC.STOCK_OUT))/(SM.RATE2/SM.RATE1)) AS TOTAL_COST,
                                        <cfelse>
                                        GC.MALIYET,
                                        (GC.MALIYET*ABS(GC.STOCK_IN-GC.STOCK_OUT)) AS TOTAL_COST,				
                                        </cfif>
                                    </cfif>
                                    ABS(GC.STOCK_IN-GC.STOCK_OUT) AS AMOUNT,
                                    GC.STOCK_IN,
                                    GC.STOCK_OUT,
                                    GC.PROCESS_DATE ISLEM_TARIHI,
                                    GC.PROCESS_TYPE PROCESS_TYPE
                                   <!--- ISNULL(ABS(GC.STOCK_IN-GC.STOCK_OUT)*(
                                        SELECT TOP 1 
                                            <cfif isdefined("attributes.location_based_cost")>
                                                <cfif isdefined("attributes.display_cost_money")>
                                                    (PURCHASE_NET_LOCATION+PURCHASE_EXTRA_COST_LOCATION)
                                                <cfelse>
                                                    (PURCHASE_NET_SYSTEM_LOCATION+PURCHASE_EXTRA_COST_SYSTEM_LOCATION)
                                                </cfif>
                                            <cfelse>
                                                <cfif isdefined("attributes.display_cost_money")>
                                                    (PURCHASE_NET+PURCHASE_EXTRA_COST)
                                                <cfelse>
                                                    (PURCHASE_NET_SYSTEM+PURCHASE_EXTRA_COST_SYSTEM)
                                                </cfif>	
                                            </cfif>
                                        FROM 
                                            #dsn3_alias#.PRODUCT_COST WITH (NOLOCK) 
                                        WHERE 
                                            START_DATE <= #finish_date# 
                                            AND PRODUCT_ID = GC.PRODUCT_ID
                                            <cfif attributes.report_type eq 8>
                                                 AND ISNULL(PRODUCT_COST.SPECT_MAIN_ID,0) = ISNULL(GC.SPECT_VAR_ID,0)
                                            </cfif>
                                            
                                            <cfif isdefined("attributes.location_based_cost")>
                                                <cfif len(attributes.department_id)>
                                                    AND DEPARTMENT_ID = #listgetat(attributes.department_id,1,'-')#
                                                    AND LOCATION_ID = #listgetat(attributes.department_id,2,'-')#
                                                <cfelse>
                                                    AND DEPARTMENT_ID = SL.DEPARTMENT_ID
                                                    AND LOCATION_ID = SL.LOCATION_ID
                                                </cfif>
                                            </cfif>
                                        ORDER BY 
                                            START_DATE DESC, 
                                            RECORD_DATE DESC,
                                            PRODUCT_COST_ID DESC
                                    ),0) ALL_FINISH_COST,
                                    ISNULL(ABS(GC.STOCK_IN-GC.STOCK_OUT)*(
                                        SELECT TOP 1 
                                            <cfif isdefined("attributes.location_based_cost")>
                                                (PURCHASE_NET_SYSTEM_2_LOCATION+PURCHASE_EXTRA_COST_SYSTEM_2_LOCATION)
                                            <cfelse>

                                                (PURCHASE_NET_SYSTEM_2+PURCHASE_EXTRA_COST_SYSTEM_2)
                                            </cfif>
                                        FROM 
                                            #dsn3_alias#.PRODUCT_COST WITH (NOLOCK) 
                                        WHERE 
                                            START_DATE <= #finish_date# 
                                            AND PRODUCT_ID = GC.PRODUCT_ID
                                            <cfif attributes.report_type eq 8>
                                                 AND ISNULL(PRODUCT_COST.SPECT_MAIN_ID,0) = ISNULL(GC.SPECT_VAR_ID,0)
                                            </cfif>
                                            
                                            <cfif isdefined("attributes.location_based_cost")>
                                                <cfif len(attributes.department_id)>
                                                    AND DEPARTMENT_ID = #listgetat(attributes.department_id,1,'-')#
                                                    AND LOCATION_ID = #listgetat(attributes.department_id,2,'-')#
                                                <cfelse>
                                                    AND DEPARTMENT_ID = SL.DEPARTMENT_ID
                                                    AND LOCATION_ID = SL.LOCATION_ID
                                                </cfif>
                                            </cfif>
                                        ORDER BY 
                                            START_DATE DESC, 
                                            RECORD_DATE DESC,
                                            PRODUCT_COST_ID DESC
                                    ),0) ALL_FINISH_COST_2--->
                                FROM
                                    <cfif is_store or isdefined("attributes.location_based_cost")>
                                        <cfif attributes.report_type eq 8>
                                            GET_STOCKS_ROW_COST_SPECT_LOCATION AS GC,
                                        <cfelse>
                                            GET_STOCKS_ROW_COST_LOCATION AS GC,
                                        </cfif>
                                    <cfelse>
                                        <cfif attributes.report_type eq 8>
                                            GET_STOCKS_ROW_COST_SPECT AS GC,
                                        <cfelse>
                                            GET_STOCK_ROW_COST_TABLE AS GC,
                                        </cfif>
                                    </cfif>
                                    <cfif attributes.cost_money is not session.ep.money or isdefined('attributes.is_system_money_2') or listfind(attributes.process_type,3)>
                                    SHIP WITH (NOLOCK),	
                                    </cfif>
                                    <cfif attributes.cost_money is not session.ep.money or isdefined('attributes.is_system_money_2')>
                                    SHIP_MONEY SM,
                                    </cfif>
                                    <cfif stock_table>
                                    #dsn3_alias#.STOCKS S,
                                    </cfif>
                                    #dsn_alias#.STOCKS_LOCATION SL
                                WHERE
                                    GC.STORE = SL.DEPARTMENT_ID
                                    AND GC.STORE_LOCATION=SL.LOCATION_ID
                                    <cfif not isdefined('is_belognto_institution')>
                                    AND SL.BELONGTO_INSTITUTION = 0
                                    </cfif>
                                    <cfif attributes.cost_money is not session.ep.money or isdefined('attributes.is_system_money_2') or listfind(attributes.process_type,3)>
                                    AND GC.UPD_ID = SHIP.SHIP_ID
                                    AND SHIP.SHIP_TYPE = GC.PROCESS_TYPE
                                    AND ISNULL(SHIP.IS_WITH_SHIP,0)=0
                                    </cfif>
                                    <cfif attributes.cost_money is not session.ep.money or isdefined('attributes.is_system_money_2')>
                                    AND SHIP.SHIP_ID = SM.ACTION_ID
                                        <cfif isdefined('attributes.is_system_money_2')>
                                            AND SM.MONEY_TYPE = '#session.ep.money2#'
                                        <cfelse>
                                            AND SM.MONEY_TYPE = '#attributes.cost_money#'
                                        </cfif>
                                    </cfif>
                                    AND GC.PROCESS_DATE >= #attributes.date#
                                    AND GC.PROCESS_DATE <= #attributes.date2#
                                    <cfif len(attributes.department_id)>
                                    AND
                                        (
                                        <cfloop list="#attributes.department_id#" delimiters="," index="dept_i">
                                        (GC.STORE = #listfirst(dept_i,'-')# AND GC.STORE_LOCATION = #listlast(dept_i,'-')#)
                                        <cfif dept_i neq listlast(attributes.department_id,',') and listlen(attributes.department_id,',') gte 1> OR</cfif>
                                        </cfloop>  
                                        )
                                    <cfelseif is_store>
                                        AND GC.STORE IN (#branch_dep_list#)
                                    </cfif>
                                    <cfif stock_table>
                                    AND	GC.STOCK_ID=S.STOCK_ID
                                    </cfif>
                                    <cfif len(trim(attributes.sup_company)) and len(attributes.sup_company_id)>
                                    AND S.COMPANY_ID = #attributes.sup_company_id#
                                    </cfif>
                                    <cfif len(trim(attributes.employee_name)) and len(attributes.product_employee_id)>
                                    AND S.PRODUCT_MANAGER = #attributes.product_employee_id#
                                    </cfif>
                                    <cfif len(trim(attributes.product_name)) and len(attributes.product_id)>
                                    AND S.PRODUCT_ID = #attributes.product_id#
                                    </cfif>
                                    <cfif len(trim(attributes.brand_name)) and len(attributes.brand_id)>
                                    AND S.BRAND_ID = #attributes.brand_id# 
                                    </cfif>	
                                    <cfif len(trim(attributes.product_cat)) and len(attributes.product_code)>
                                    AND S.STOCK_CODE LIKE '#attributes.product_code#%'
                                    </cfif>
                            <cfif attributes.cost_money is not session.ep.money or listfind(attributes.process_type,3)>
                            UNION ALL
                                SELECT
                                    GC.STOCK_ID,
                                    GC.PRODUCT_ID,
                                    <cfif attributes.report_type eq 8>
                                    CAST(GC.STOCK_ID AS NVARCHAR(50)) +'_'+ CAST(ISNULL(GC.SPECT_VAR_ID,0) AS NVARCHAR(50)) STOCK_SPEC_ID,
                                    </cfif>
                                    INVOICE.INVOICE_CAT,
                                    <cfif stock_table>
                                    S.PRODUCT_MANAGER,
                                    S.PRODUCT_CATID,
                                    S.BRAND_ID,
                                    </cfif>
                                    <cfif isdefined('attributes.is_system_money_2') or attributes.cost_money is not session.ep.money>
                                        <cfif isdefined('attributes.is_system_money_2')>
                                        GC.MALIYET_2,
                                        GC.MALIYET,
                                        ((GC.MALIYET_2*ABS(GC.STOCK_IN-GC.STOCK_OUT))) AS TOTAL_COST_2,
                                        (GC.MALIYET*ABS(GC.STOCK_IN-GC.STOCK_OUT)) AS TOTAL_COST,
                                        <cfelse>
                                            (GC.MALIYET/(IM.RATE2/IM.RATE1)) AS MALIYET,
                                            ((GC.MALIYET*ABS(GC.STOCK_IN-GC.STOCK_OUT))/(IM.RATE2/IM.RATE1)) AS TOTAL_COST,
                                        </cfif>
                                    <cfelse>
                                        (GC.MALIYET) AS MALIYET,
                                        ((GC.MALIYET*ABS(GC.STOCK_IN-GC.STOCK_OUT))) AS TOTAL_COST,
                                    </cfif>
                                    ABS(GC.STOCK_IN-GC.STOCK_OUT) AS AMOUNT,
                                    GC.STOCK_IN,
                                    GC.STOCK_OUT,
                                    GC.PROCESS_DATE ISLEM_TARIHI,
                                    GC.PROCESS_TYPE PROCESS_TYPE
                                    <!---ISNULL(ABS(GC.STOCK_IN-GC.STOCK_OUT)*(
                                        SELECT TOP 1 
                                            <cfif isdefined("attributes.location_based_cost")>
                                                <cfif isdefined("attributes.display_cost_money")>
                                                    (PURCHASE_NET_LOCATION+PURCHASE_EXTRA_COST_LOCATION)
                                                <cfelse>
                                                    (PURCHASE_NET_SYSTEM_LOCATION+PURCHASE_EXTRA_COST_SYSTEM_LOCATION)
                                                </cfif>
                                            <cfelse>
                                                <cfif isdefined("attributes.display_cost_money")>
                                                    (PURCHASE_NET+PURCHASE_EXTRA_COST)
                                                <cfelse>
                                                    (PURCHASE_NET_SYSTEM+PURCHASE_EXTRA_COST_SYSTEM)
                                                </cfif>	
                                            </cfif>
                                        FROM 
                                            #dsn3_alias#.PRODUCT_COST WITH (NOLOCK) 
                                        WHERE 
                                            START_DATE <= #finish_date# 
                                            AND PRODUCT_ID = GC.PRODUCT_ID
                                            <cfif attributes.report_type eq 8>
                                                 AND ISNULL(PRODUCT_COST.SPECT_MAIN_ID,0) = ISNULL(GC.SPECT_VAR_ID,0)
                                            </cfif>
                                            
                                            <cfif isdefined("attributes.location_based_cost")>
                                                <cfif len(attributes.department_id)>
                                                    AND DEPARTMENT_ID = #listgetat(attributes.department_id,1,'-')#
                                                    AND LOCATION_ID = #listgetat(attributes.department_id,2,'-')#
                                                <cfelse>
                                                    AND DEPARTMENT_ID = SL.DEPARTMENT_ID
                                                    AND LOCATION_ID = SL.LOCATION_ID
                                                </cfif>
                                            </cfif>
                                        ORDER BY 
                                            START_DATE DESC, 
                                            RECORD_DATE DESC,
                                            PRODUCT_COST_ID DESC
                                    ),0) ALL_FINISH_COST,
                                    ISNULL(ABS(GC.STOCK_IN-GC.STOCK_OUT)*(
                                        SELECT TOP 1 
                                            <cfif isdefined("attributes.location_based_cost")>
                                                (PURCHASE_NET_SYSTEM_2_LOCATION+PURCHASE_EXTRA_COST_SYSTEM_2_LOCATION)
                                            <cfelse>
                                                (PURCHASE_NET_SYSTEM_2+PURCHASE_EXTRA_COST_SYSTEM_2)
                                            </cfif>
                                        FROM 
                                            #dsn3_alias#.PRODUCT_COST WITH (NOLOCK) 
                                        WHERE 
                                            START_DATE <= #finish_date# 
                                            AND PRODUCT_ID = GC.PRODUCT_ID
                                            <cfif attributes.report_type eq 8>
                                                 AND ISNULL(PRODUCT_COST.SPECT_MAIN_ID,0) = ISNULL(GC.SPECT_VAR_ID,0)
                                            </cfif>
                                            
                                            <cfif isdefined("attributes.location_based_cost")>
                                                <cfif len(attributes.department_id)>
                                                    AND DEPARTMENT_ID = #listgetat(attributes.department_id,1,'-')#
                                                    AND LOCATION_ID = #listgetat(attributes.department_id,2,'-')#
                                                <cfelse>
                                                    AND DEPARTMENT_ID = SL.DEPARTMENT_ID
                                                    AND LOCATION_ID = SL.LOCATION_ID
                                                </cfif>
                                            </cfif>
                                        ORDER BY 
                                            START_DATE DESC, 
                                            RECORD_DATE DESC,
                                            PRODUCT_COST_ID DESC
                                    ),0) ALL_FINISH_COST_2--->
                                FROM
                                    SHIP WITH (NOLOCK),
                                    INVOICE WITH (NOLOCK),
                                    INVOICE_SHIPS INV_S,
                                    <cfif isdefined('attributes.is_system_money_2') or attributes.cost_money is not session.ep.money>
                                    INVOICE_MONEY IM,
                                    </cfif>
                                    <cfif is_store or isdefined("attributes.location_based_cost")>
                                        <cfif attributes.report_type eq 8>
                                            GET_STOCKS_ROW_COST_SPECT_LOCATION AS GC,
                                        <cfelse>
                                            GET_STOCKS_ROW_COST_LOCATION AS GC,
                                        </cfif>
                                    <cfelse>
                                        <cfif attributes.report_type eq 8>
                                            GET_STOCKS_ROW_COST_SPECT AS GC,
                                        <cfelse>
                                            GET_STOCK_ROW_COST_TABLE AS GC,
                                        </cfif>
                                    </cfif>
                                    <cfif stock_table>
                                    #dsn3_alias#.STOCKS S,
                                    </cfif>
                                    #dsn_alias#.STOCKS_LOCATION SL
                                WHERE
                                    SHIP.SHIP_ID = INV_S.SHIP_ID
                                    AND INVOICE.INVOICE_ID= INV_S.INVOICE_ID
                                    AND INV_S.IS_WITH_SHIP = 1
                                    AND INV_S.SHIP_PERIOD_ID = #session.ep.period_id#
                                    AND SHIP.IS_WITH_SHIP=1
                                    AND SHIP.SHIP_ID = GC.UPD_ID
                                    AND SHIP.SHIP_TYPE = GC.PROCESS_TYPE
                                    AND GC.STORE = SL.DEPARTMENT_ID
                                    AND GC.STORE_LOCATION=SL.LOCATION_ID
                                    <cfif not isdefined('is_belognto_institution')>
                                    AND SL.BELONGTO_INSTITUTION = 0
                                    </cfif>
                                    <cfif isdefined('attributes.is_system_money_2') or attributes.cost_money is not session.ep.money>
                                        AND IM.ACTION_ID=INVOICE.INVOICE_ID
                                        <cfif isdefined('attributes.is_system_money_2')>
                                        AND IM.MONEY_TYPE = '#session.ep.money2#'
                                        <cfelse>
                                        AND IM.MONEY_TYPE = '#attributes.cost_money#'
                                        </cfif>
                                    </cfif>
                                    AND GC.PROCESS_DATE >= #attributes.date#
                                    AND GC.PROCESS_DATE <= #attributes.date2#
                                    <cfif len(attributes.department_id)>
                                    AND
                                        (
                                        <cfloop list="#attributes.department_id#" delimiters="," index="dept_i">
                                        (GC.STORE = #listfirst(dept_i,'-')# AND GC.STORE_LOCATION = #listlast(dept_i,'-')#)
                                        <cfif dept_i neq listlast(attributes.department_id,',') and listlen(attributes.department_id,',') gte 1> OR</cfif>
                                        </cfloop>  
                                        )
                                    <cfelseif is_store>
                                        AND GC.STORE IN (#branch_dep_list#)
                                    </cfif>
                                    <cfif stock_table>
                                    AND	GC.STOCK_ID=S.STOCK_ID
                                    </cfif>
                                    <cfif len(trim(attributes.sup_company)) and len(attributes.sup_company_id)>
                                        AND S.COMPANY_ID = #attributes.sup_company_id#
                                    </cfif>
                                    <cfif len(trim(attributes.employee_name)) and len(attributes.product_employee_id)>
                                        AND S.PRODUCT_MANAGER = #attributes.product_employee_id#
                                    </cfif>
                                    <cfif len(trim(attributes.product_name)) and len(attributes.product_id)>
                                        AND S.PRODUCT_ID = #attributes.product_id#
                                    </cfif>
                                    <cfif len(trim(attributes.brand_name)) and len(attributes.brand_id)>
                                        AND S.BRAND_ID = #attributes.brand_id# 
                                    </cfif>	
                                    <cfif len(trim(attributes.product_cat)) and len(attributes.product_code)>
                                        AND S.STOCK_CODE LIKE '#attributes.product_code#%'
                                    </cfif>
                            </cfif>
                            )AS GET_SHIP_ROWS
                        WHERE
                            PROCESS_TYPE = 140
                        GROUP BY
                            #ALAN_ADI#
                        )AS servis_giris ON GET_ALL_STOCK.PRODUCT_GROUPBY_ID = servis_giris.GROUPBY_ALANI
		</cfif>
        <!--- Teknik Servis Çıkıs --->
		<cfif len(attributes.process_type) and listfind(attributes.process_type,9)>
			LEFT JOIN(
                        SELECT	
                            SUM(AMOUNT) AS SERVIS_CIKIS_MIKTAR,
                            SUM(TOTAL_COST) AS SERVIS_CIKIS_MALIYET,
                            <cfif isdefined('attributes.is_system_money_2')>
                            SUM(TOTAL_COST_2) AS SERVIS_CIKIS_MALIYET_2,
                            </cfif>
                            #ALAN_ADI# AS GROUPBY_ALANI
                        FROM
                            (
                                SELECT
                                    GC.STOCK_ID,
                                    GC.PRODUCT_ID,
                                    <cfif attributes.report_type eq 8>
                                    CAST(GC.STOCK_ID AS NVARCHAR(50)) +'_'+ CAST(ISNULL(GC.SPECT_VAR_ID,0) AS NVARCHAR(50)) STOCK_SPEC_ID,
                                    </cfif>
                                    1 AS INVOICE_CAT,
                                    <cfif stock_table>
                                    S.PRODUCT_MANAGER,
                                    S.PRODUCT_CATID,
                                    S.BRAND_ID,
                                    </cfif>
                                    <cfif isdefined('attributes.is_system_money_2')>
                                    GC.MALIYET_2,
                                    GC.MALIYET,
                                    ((GC.MALIYET_2*ABS(GC.STOCK_IN-GC.STOCK_OUT))) AS TOTAL_COST_2,
                                    (GC.MALIYET*ABS(GC.STOCK_IN-GC.STOCK_OUT)) AS TOTAL_COST,
                                    <cfelse>
                                        <cfif attributes.cost_money is not session.ep.money>
                                        (GC.MALIYET/(SM.RATE2/SM.RATE1)) AS MALIYET,
                                        ((GC.MALIYET*ABS(GC.STOCK_IN-GC.STOCK_OUT))/(SM.RATE2/SM.RATE1)) AS TOTAL_COST,
                                        <cfelse>
                                        GC.MALIYET,
                                        (GC.MALIYET*ABS(GC.STOCK_IN-GC.STOCK_OUT)) AS TOTAL_COST,				
                                        </cfif>
                                    </cfif>
                                    ABS(GC.STOCK_IN-GC.STOCK_OUT) AS AMOUNT,
                                    GC.STOCK_IN,
                                    GC.STOCK_OUT,
                                    GC.PROCESS_DATE ISLEM_TARIHI,
                                    GC.PROCESS_TYPE PROCESS_TYPE
                                   <!--- ISNULL(ABS(GC.STOCK_IN-GC.STOCK_OUT)*(
                                        SELECT TOP 1 
                                            <cfif isdefined("attributes.location_based_cost")>
                                                <cfif isdefined("attributes.display_cost_money")>
                                                    (PURCHASE_NET_LOCATION+PURCHASE_EXTRA_COST_LOCATION)
                                                <cfelse>
                                                    (PURCHASE_NET_SYSTEM_LOCATION+PURCHASE_EXTRA_COST_SYSTEM_LOCATION)
                                                </cfif>
                                            <cfelse>
                                                <cfif isdefined("attributes.display_cost_money")>
                                                    (PURCHASE_NET+PURCHASE_EXTRA_COST)
                                                <cfelse>
                                                    (PURCHASE_NET_SYSTEM+PURCHASE_EXTRA_COST_SYSTEM)
                                                </cfif>	
                                            </cfif>
                                        FROM 
                                            #dsn3_alias#.PRODUCT_COST WITH (NOLOCK) 
                                        WHERE 
                                            START_DATE <= #finish_date# 
                                            AND PRODUCT_ID = GC.PRODUCT_ID
                                            <cfif attributes.report_type eq 8>
                                                 AND ISNULL(PRODUCT_COST.SPECT_MAIN_ID,0) = ISNULL(GC.SPECT_VAR_ID,0)
                                            </cfif>
                                           
                                            <cfif isdefined("attributes.location_based_cost")>
                                                <cfif len(attributes.department_id)>
                                                    AND DEPARTMENT_ID = #listgetat(attributes.department_id,1,'-')#
                                                    AND LOCATION_ID = #listgetat(attributes.department_id,2,'-')#
                                                <cfelse>
                                                    AND DEPARTMENT_ID = SL.DEPARTMENT_ID
                                                    AND LOCATION_ID = SL.LOCATION_ID
                                                </cfif>
                                            </cfif>
                                        ORDER BY 
                                            START_DATE DESC, 
                                            RECORD_DATE DESC,
                                            PRODUCT_COST_ID DESC
                                    ),0) ALL_FINISH_COST,
                                    ISNULL(ABS(GC.STOCK_IN-GC.STOCK_OUT)*(
                                        SELECT TOP 1 
                                            <cfif isdefined("attributes.location_based_cost")>
                                                (PURCHASE_NET_SYSTEM_2_LOCATION+PURCHASE_EXTRA_COST_SYSTEM_2_LOCATION)
                                            <cfelse>
                                                (PURCHASE_NET_SYSTEM_2+PURCHASE_EXTRA_COST_SYSTEM_2)
                                            </cfif>
                                        FROM 
                                            #dsn3_alias#.PRODUCT_COST WITH (NOLOCK) 
                                        WHERE 
                                            START_DATE <= #finish_date# 
                                            AND PRODUCT_ID = GC.PRODUCT_ID
                                            <cfif attributes.report_type eq 8>
                                                 AND ISNULL(PRODUCT_COST.SPECT_MAIN_ID,0) = ISNULL(GC.SPECT_VAR_ID,0)
                                            </cfif>
                                           
                                            <cfif isdefined("attributes.location_based_cost")>
                                                <cfif len(attributes.department_id)>
                                                    AND DEPARTMENT_ID = #listgetat(attributes.department_id,1,'-')#
                                                    AND LOCATION_ID = #listgetat(attributes.department_id,2,'-')#
                                                <cfelse>
                                                    AND DEPARTMENT_ID = SL.DEPARTMENT_ID
                                                    AND LOCATION_ID = SL.LOCATION_ID
                                                </cfif>
                                            </cfif>
                                        ORDER BY 
                                            START_DATE DESC, 
                                            RECORD_DATE DESC,
                                            PRODUCT_COST_ID DESC
                                    ),0) ALL_FINISH_COST_2--->
                                FROM
                                    <cfif is_store or isdefined("attributes.location_based_cost")>
                                        <cfif attributes.report_type eq 8>
                                            GET_STOCKS_ROW_COST_SPECT_LOCATION AS GC,
                                        <cfelse>
                                            GET_STOCKS_ROW_COST_LOCATION AS GC,
                                        </cfif>
                                    <cfelse>
                                        <cfif attributes.report_type eq 8>
                                            GET_STOCKS_ROW_COST_SPECT AS GC,
                                        <cfelse>
                                            GET_STOCK_ROW_COST_TABLE AS GC,
                                        </cfif>

                                    </cfif>
                                    <cfif attributes.cost_money is not session.ep.money or isdefined('attributes.is_system_money_2') or listfind(attributes.process_type,3)>
                                    SHIP WITH (NOLOCK),	
                                    </cfif>
                                    <cfif attributes.cost_money is not session.ep.money or isdefined('attributes.is_system_money_2')>
                                    SHIP_MONEY SM,
                                    </cfif>
                                    <cfif stock_table>
                                    #dsn3_alias#.STOCKS S,
                                    </cfif>
                                    #dsn_alias#.STOCKS_LOCATION SL
                                WHERE
                                    GC.STORE = SL.DEPARTMENT_ID
                                    AND GC.STORE_LOCATION=SL.LOCATION_ID
                                    <cfif not isdefined('is_belognto_institution')>
                                    AND SL.BELONGTO_INSTITUTION = 0
                                    </cfif>
                                    <cfif attributes.cost_money is not session.ep.money or isdefined('attributes.is_system_money_2') or listfind(attributes.process_type,3)>
                                    AND GC.UPD_ID = SHIP.SHIP_ID
                                    AND SHIP.SHIP_TYPE = GC.PROCESS_TYPE
                                    AND ISNULL(SHIP.IS_WITH_SHIP,0)=0
                                    </cfif>
                                    <cfif attributes.cost_money is not session.ep.money or isdefined('attributes.is_system_money_2')>
                                    AND SHIP.SHIP_ID = SM.ACTION_ID
                                        <cfif isdefined('attributes.is_system_money_2')>
                                            AND SM.MONEY_TYPE = '#session.ep.money2#'
                                        <cfelse>
                                            AND SM.MONEY_TYPE = '#attributes.cost_money#'
                                        </cfif>
                                    </cfif>
                                    AND GC.PROCESS_DATE >= #attributes.date#
                                    AND GC.PROCESS_DATE <= #attributes.date2#
                                    <cfif len(attributes.department_id)>
                                    AND
                                        (
                                        <cfloop list="#attributes.department_id#" delimiters="," index="dept_i">
                                        (GC.STORE = #listfirst(dept_i,'-')# AND GC.STORE_LOCATION = #listlast(dept_i,'-')#)
                                        <cfif dept_i neq listlast(attributes.department_id,',') and listlen(attributes.department_id,',') gte 1> OR</cfif>
                                        </cfloop>  
                                        )
                                    <cfelseif is_store>
                                        AND GC.STORE IN (#branch_dep_list#)
                                    </cfif>
                                    <cfif stock_table>
                                    AND	GC.STOCK_ID=S.STOCK_ID
                                    </cfif>
                                    <cfif len(trim(attributes.sup_company)) and len(attributes.sup_company_id)>
                                    AND S.COMPANY_ID = #attributes.sup_company_id#
                                    </cfif>
                                    <cfif len(trim(attributes.employee_name)) and len(attributes.product_employee_id)>
                                    AND S.PRODUCT_MANAGER = #attributes.product_employee_id#
                                    </cfif>
                                    <cfif len(trim(attributes.product_name)) and len(attributes.product_id)>
                                    AND S.PRODUCT_ID = #attributes.product_id#
                                    </cfif>
                                    <cfif len(trim(attributes.brand_name)) and len(attributes.brand_id)>
                                    AND S.BRAND_ID = #attributes.brand_id# 
                                    </cfif>	
                                    <cfif len(trim(attributes.product_cat)) and len(attributes.product_code)>
                                    AND S.STOCK_CODE LIKE '#attributes.product_code#%'
                                    </cfif>
                            <cfif attributes.cost_money is not session.ep.money or listfind(attributes.process_type,3)>
                            UNION ALL
                                SELECT
                                    GC.STOCK_ID,
                                    GC.PRODUCT_ID,
                                    <cfif attributes.report_type eq 8>
                                    CAST(GC.STOCK_ID AS NVARCHAR(50)) +'_'+ CAST(ISNULL(GC.SPECT_VAR_ID,0) AS NVARCHAR(50)) STOCK_SPEC_ID,
                                    </cfif>
                                    INVOICE.INVOICE_CAT,
                                    <cfif stock_table>
                                    S.PRODUCT_MANAGER,
                                    S.PRODUCT_CATID,
                                    S.BRAND_ID,
                                    </cfif>
                                    <cfif isdefined('attributes.is_system_money_2') or attributes.cost_money is not session.ep.money>
                                        <cfif isdefined('attributes.is_system_money_2')>
                                        GC.MALIYET_2,
                                        GC.MALIYET,
                                        ((GC.MALIYET_2*ABS(GC.STOCK_IN-GC.STOCK_OUT))) AS TOTAL_COST_2,
                                        (GC.MALIYET*ABS(GC.STOCK_IN-GC.STOCK_OUT)) AS TOTAL_COST,
                                        <cfelse>
                                            (GC.MALIYET/(IM.RATE2/IM.RATE1)) AS MALIYET,
                                            ((GC.MALIYET*ABS(GC.STOCK_IN-GC.STOCK_OUT))/(IM.RATE2/IM.RATE1)) AS TOTAL_COST,
                                        </cfif>
                                    <cfelse>
                                        (GC.MALIYET) AS MALIYET,
                                        ((GC.MALIYET*ABS(GC.STOCK_IN-GC.STOCK_OUT))) AS TOTAL_COST,
                                    </cfif>
                                    ABS(GC.STOCK_IN-GC.STOCK_OUT) AS AMOUNT,
                                    GC.STOCK_IN,
                                    GC.STOCK_OUT,
                                    GC.PROCESS_DATE ISLEM_TARIHI,
                                    GC.PROCESS_TYPE PROCESS_TYPE
                                    <!---ISNULL(ABS(GC.STOCK_IN-GC.STOCK_OUT)*(
                                        SELECT TOP 1 
                                            <cfif isdefined("attributes.location_based_cost")>
                                                <cfif isdefined("attributes.display_cost_money")>
                                                    (PURCHASE_NET_LOCATION+PURCHASE_EXTRA_COST_LOCATION)
                                                <cfelse>
                                                    (PURCHASE_NET_SYSTEM_LOCATION+PURCHASE_EXTRA_COST_SYSTEM_LOCATION)
                                                </cfif>
                                            <cfelse>
                                                <cfif isdefined("attributes.display_cost_money")>
                                                    (PURCHASE_NET+PURCHASE_EXTRA_COST)
                                                <cfelse>
                                                    (PURCHASE_NET_SYSTEM+PURCHASE_EXTRA_COST_SYSTEM)
                                                </cfif>	
                                            </cfif>
                                        FROM 
                                            #dsn3_alias#.PRODUCT_COST WITH (NOLOCK) 
                                        WHERE 
                                            START_DATE <= #finish_date# 
                                            AND PRODUCT_ID = GC.PRODUCT_ID
                                            <cfif attributes.report_type eq 8>
                                                 AND ISNULL(PRODUCT_COST.SPECT_MAIN_ID,0) = ISNULL(GC.SPECT_VAR_ID,0)
                                            </cfif>
                                           
                                            <cfif isdefined("attributes.location_based_cost")>
                                                <cfif len(attributes.department_id)>
                                                    AND DEPARTMENT_ID = #listgetat(attributes.department_id,1,'-')#
                                                    AND LOCATION_ID = #listgetat(attributes.department_id,2,'-')#
                                                <cfelse>
                                                    AND DEPARTMENT_ID = SL.DEPARTMENT_ID
                                                    AND LOCATION_ID = SL.LOCATION_ID
                                                </cfif>
                                            </cfif>
                                        ORDER BY 
                                            START_DATE DESC, 
                                            RECORD_DATE DESC,
                                            PRODUCT_COST_ID DESC
                                    ),0) ALL_FINISH_COST,
                                    ISNULL(ABS(GC.STOCK_IN-GC.STOCK_OUT)*(
                                        SELECT TOP 1 
                                            <cfif isdefined("attributes.location_based_cost")>
                                                (PURCHASE_NET_SYSTEM_2_LOCATION+PURCHASE_EXTRA_COST_SYSTEM_2_LOCATION)
                                            <cfelse>
                                                (PURCHASE_NET_SYSTEM_2+PURCHASE_EXTRA_COST_SYSTEM_2)
                                            </cfif>
                                        FROM 
                                            #dsn3_alias#.PRODUCT_COST WITH (NOLOCK) 
                                        WHERE 
                                            START_DATE <= #finish_date# 
                                            AND PRODUCT_ID = GC.PRODUCT_ID
                                            <cfif attributes.report_type eq 8>
                                                 AND ISNULL(PRODUCT_COST.SPECT_MAIN_ID,0) = ISNULL(GC.SPECT_VAR_ID,0)
                                            </cfif>
                                            
                                            <cfif isdefined("attributes.location_based_cost")>
                                                <cfif len(attributes.department_id)>
                                                    AND DEPARTMENT_ID = #listgetat(attributes.department_id,1,'-')#
                                                    AND LOCATION_ID = #listgetat(attributes.department_id,2,'-')#
                                                <cfelse>
                                                    AND DEPARTMENT_ID = SL.DEPARTMENT_ID
                                                    AND LOCATION_ID = SL.LOCATION_ID
                                                </cfif>
                                            </cfif>
                                        ORDER BY 
                                            START_DATE DESC, 
                                            RECORD_DATE DESC,
                                            PRODUCT_COST_ID DESC
                                    ),0) ALL_FINISH_COST_2--->
                                FROM
                                    SHIP WITH (NOLOCK),
                                    INVOICE WITH (NOLOCK),
                                    INVOICE_SHIPS INV_S,
                                    <cfif isdefined('attributes.is_system_money_2') or attributes.cost_money is not session.ep.money>
                                    INVOICE_MONEY IM,
                                    </cfif>
                                    <cfif is_store or isdefined("attributes.location_based_cost")>
                                        <cfif attributes.report_type eq 8>
                                            GET_STOCKS_ROW_COST_SPECT_LOCATION AS GC,
                                        <cfelse>
                                            GET_STOCKS_ROW_COST_LOCATION AS GC,
                                        </cfif>
                                    <cfelse>
                                        <cfif attributes.report_type eq 8>
                                            GET_STOCKS_ROW_COST_SPECT AS GC,
                                        <cfelse>
                                            GET_STOCK_ROW_COST_TABLE AS GC,
                                        </cfif>
                                    </cfif>
                                    <cfif stock_table>
                                    #dsn3_alias#.STOCKS S,
                                    </cfif>
                                    #dsn_alias#.STOCKS_LOCATION SL
                                WHERE
                                    SHIP.SHIP_ID = INV_S.SHIP_ID
                                    AND INVOICE.INVOICE_ID= INV_S.INVOICE_ID
                                    AND INV_S.IS_WITH_SHIP = 1
                                    AND INV_S.SHIP_PERIOD_ID = #session.ep.period_id#
                                    AND SHIP.IS_WITH_SHIP=1
                                    AND SHIP.SHIP_ID = GC.UPD_ID
                                    AND SHIP.SHIP_TYPE = GC.PROCESS_TYPE
                                    AND GC.STORE = SL.DEPARTMENT_ID
                                    AND GC.STORE_LOCATION=SL.LOCATION_ID
                                    <cfif not isdefined('is_belognto_institution')>
                                    AND SL.BELONGTO_INSTITUTION = 0
                                    </cfif>
                                    <cfif isdefined('attributes.is_system_money_2') or attributes.cost_money is not session.ep.money>
                                        AND IM.ACTION_ID=INVOICE.INVOICE_ID
                                        <cfif isdefined('attributes.is_system_money_2')>
                                        AND IM.MONEY_TYPE = '#session.ep.money2#'
                                        <cfelse>
                                        AND IM.MONEY_TYPE = '#attributes.cost_money#'
                                        </cfif>
                                    </cfif>
                                    AND GC.PROCESS_DATE >= #attributes.date#
                                    AND GC.PROCESS_DATE <= #attributes.date2#
                                    <cfif len(attributes.department_id)>
                                    AND
                                        (
                                        <cfloop list="#attributes.department_id#" delimiters="," index="dept_i">
                                        (GC.STORE = #listfirst(dept_i,'-')# AND GC.STORE_LOCATION = #listlast(dept_i,'-')#)
                                        <cfif dept_i neq listlast(attributes.department_id,',') and listlen(attributes.department_id,',') gte 1> OR</cfif>
                                        </cfloop>  
                                        )
                                    <cfelseif is_store>
                                        AND GC.STORE IN (#branch_dep_list#)
                                    </cfif>
                                    <cfif stock_table>
                                    AND	GC.STOCK_ID=S.STOCK_ID
                                    </cfif>
                                    <cfif len(trim(attributes.sup_company)) and len(attributes.sup_company_id)>
                                        AND S.COMPANY_ID = #attributes.sup_company_id#
                                    </cfif>
                                    <cfif len(trim(attributes.employee_name)) and len(attributes.product_employee_id)>
                                        AND S.PRODUCT_MANAGER = #attributes.product_employee_id#
                                    </cfif>
                                    <cfif len(trim(attributes.product_name)) and len(attributes.product_id)>
                                        AND S.PRODUCT_ID = #attributes.product_id#
                                    </cfif>
                                    <cfif len(trim(attributes.brand_name)) and len(attributes.brand_id)>
                                        AND S.BRAND_ID = #attributes.brand_id# 
                                    </cfif>	
                                    <cfif len(trim(attributes.product_cat)) and len(attributes.product_code)>
                                        AND S.STOCK_CODE LIKE '#attributes.product_code#%'
                                    </cfif>
                            </cfif>
                            )AS GET_SHIP_ROWS
                        WHERE
                            PROCESS_TYPE = 141
                        GROUP BY
                            #ALAN_ADI#
                        )AS servis_cikis ON GET_ALL_STOCK.PRODUCT_GROUPBY_ID = servis_cikis.GROUPBY_ALANI
		</cfif>
        <!--- RMA Giriş :Servis - Üreticiden Giriş İrsaliyesi  --->
		<cfif len(attributes.process_type) and listfind(attributes.process_type,11)>
			LEFT JOIN(
                        SELECT	
                            SUM(AMOUNT) AS RMA_GIRIS_MIKTAR,
                            SUM(TOTAL_COST) AS RMA_GIRIS_MALIYET,
                            <cfif isdefined('attributes.is_system_money_2')>
                            SUM(TOTAL_COST_2) AS RMA_GIRIS_MALIYET_2,
                            </cfif>
                            #ALAN_ADI# AS GROUPBY_ALANI
                        FROM
                            (
                                SELECT
                                    GC.STOCK_ID,
                                    GC.PRODUCT_ID,
                                    <cfif attributes.report_type eq 8>
                                    CAST(GC.STOCK_ID AS NVARCHAR(50)) +'_'+ CAST(ISNULL(GC.SPECT_VAR_ID,0) AS NVARCHAR(50)) STOCK_SPEC_ID,
                                    </cfif>
                                    1 AS INVOICE_CAT,
                                    <cfif stock_table>
                                    S.PRODUCT_MANAGER,
                                    S.PRODUCT_CATID,
                                    S.BRAND_ID,
                                    </cfif>
                                    <cfif isdefined('attributes.is_system_money_2')>
                                    GC.MALIYET_2,
                                    GC.MALIYET,
                                    ((GC.MALIYET_2*ABS(GC.STOCK_IN-GC.STOCK_OUT))) AS TOTAL_COST_2,
                                    (GC.MALIYET*ABS(GC.STOCK_IN-GC.STOCK_OUT)) AS TOTAL_COST,
                                    <cfelse>
                                        <cfif attributes.cost_money is not session.ep.money>
                                        (GC.MALIYET/(SM.RATE2/SM.RATE1)) AS MALIYET,
                                        ((GC.MALIYET*ABS(GC.STOCK_IN-GC.STOCK_OUT))/(SM.RATE2/SM.RATE1)) AS TOTAL_COST,
                                        <cfelse>
                                        GC.MALIYET,
                                        (GC.MALIYET*ABS(GC.STOCK_IN-GC.STOCK_OUT)) AS TOTAL_COST,				
                                        </cfif>
                                    </cfif>
                                    ABS(GC.STOCK_IN-GC.STOCK_OUT) AS AMOUNT,
                                    GC.STOCK_IN,
                                    GC.STOCK_OUT,
                                    GC.PROCESS_DATE ISLEM_TARIHI,
                                    GC.PROCESS_TYPE PROCESS_TYPE
                                   <!--- ISNULL(ABS(GC.STOCK_IN-GC.STOCK_OUT)*(
                                        SELECT TOP 1 
                                            <cfif isdefined("attributes.location_based_cost")>
                                                <cfif isdefined("attributes.display_cost_money")>
                                                    (PURCHASE_NET_LOCATION+PURCHASE_EXTRA_COST_LOCATION)
                                                <cfelse>
                                                    (PURCHASE_NET_SYSTEM_LOCATION+PURCHASE_EXTRA_COST_SYSTEM_LOCATION)
                                                </cfif>
                                            <cfelse>
                                                <cfif isdefined("attributes.display_cost_money")>
                                                    (PURCHASE_NET+PURCHASE_EXTRA_COST)
                                                <cfelse>
                                                    (PURCHASE_NET_SYSTEM+PURCHASE_EXTRA_COST_SYSTEM)
                                                </cfif>	
                                            </cfif>
                                        FROM 
                                            #dsn3_alias#.PRODUCT_COST WITH (NOLOCK) 
                                        WHERE 
                                            START_DATE <= #finish_date# 
                                            AND PRODUCT_ID = GC.PRODUCT_ID
                                            <cfif attributes.report_type eq 8>
                                                 AND ISNULL(PRODUCT_COST.SPECT_MAIN_ID,0) = ISNULL(GC.SPECT_VAR_ID,0)
                                            </cfif>
                                          
                                            <cfif isdefined("attributes.location_based_cost")>
                                                <cfif len(attributes.department_id)>
                                                    AND DEPARTMENT_ID = #listgetat(attributes.department_id,1,'-')#
                                                    AND LOCATION_ID = #listgetat(attributes.department_id,2,'-')#
                                                <cfelse>
                                                    AND DEPARTMENT_ID = SL.DEPARTMENT_ID
                                                    AND LOCATION_ID = SL.LOCATION_ID
                                                </cfif>
                                            </cfif>
                                        ORDER BY 
                                            START_DATE DESC, 
                                            RECORD_DATE DESC,
                                            PRODUCT_COST_ID DESC
                                    ),0) ALL_FINISH_COST,
                                    ISNULL(ABS(GC.STOCK_IN-GC.STOCK_OUT)*(
                                        SELECT TOP 1 
                                            <cfif isdefined("attributes.location_based_cost")>
                                                (PURCHASE_NET_SYSTEM_2_LOCATION+PURCHASE_EXTRA_COST_SYSTEM_2_LOCATION)
                                            <cfelse>
                                                (PURCHASE_NET_SYSTEM_2+PURCHASE_EXTRA_COST_SYSTEM_2)
                                            </cfif>
                                        FROM 
                                            #dsn3_alias#.PRODUCT_COST WITH (NOLOCK) 
                                        WHERE 
                                            START_DATE <= #finish_date# 
                                            AND PRODUCT_ID = GC.PRODUCT_ID

                                            <cfif attributes.report_type eq 8>
                                                 AND ISNULL(PRODUCT_COST.SPECT_MAIN_ID,0) = ISNULL(GC.SPECT_VAR_ID,0)
                                            </cfif>
                                          
                                            <cfif isdefined("attributes.location_based_cost")>
                                                <cfif len(attributes.department_id)>
                                                    AND DEPARTMENT_ID = #listgetat(attributes.department_id,1,'-')#
                                                    AND LOCATION_ID = #listgetat(attributes.department_id,2,'-')#
                                                <cfelse>
                                                    AND DEPARTMENT_ID = SL.DEPARTMENT_ID
                                                    AND LOCATION_ID = SL.LOCATION_ID
                                                </cfif>
                                            </cfif>
                                        ORDER BY 
                                            START_DATE DESC, 
                                            RECORD_DATE DESC,
                                            PRODUCT_COST_ID DESC
                                    ),0) ALL_FINISH_COST_2--->
                                FROM
                                    <cfif is_store or isdefined("attributes.location_based_cost")>
                                        <cfif attributes.report_type eq 8>
                                            GET_STOCKS_ROW_COST_SPECT_LOCATION AS GC,
                                        <cfelse>
                                            GET_STOCKS_ROW_COST_LOCATION AS GC,
                                        </cfif>
                                    <cfelse>
                                        <cfif attributes.report_type eq 8>
                                            GET_STOCKS_ROW_COST_SPECT AS GC,
                                        <cfelse>
                                            GET_STOCK_ROW_COST_TABLE AS GC,
                                        </cfif>
                                    </cfif>
                                    <cfif attributes.cost_money is not session.ep.money or isdefined('attributes.is_system_money_2') or listfind(attributes.process_type,3)>
                                    SHIP WITH (NOLOCK),	
                                    </cfif>
                                    <cfif attributes.cost_money is not session.ep.money or isdefined('attributes.is_system_money_2')>
                                    SHIP_MONEY SM,
                                    </cfif>
                                    <cfif stock_table>
                                    #dsn3_alias#.STOCKS S,
                                    </cfif>
                                    #dsn_alias#.STOCKS_LOCATION SL
                                WHERE
                                    GC.STORE = SL.DEPARTMENT_ID
                                    AND GC.STORE_LOCATION=SL.LOCATION_ID
                                    <cfif not isdefined('is_belognto_institution')>
                                    AND SL.BELONGTO_INSTITUTION = 0
                                    </cfif>
                                    <cfif attributes.cost_money is not session.ep.money or isdefined('attributes.is_system_money_2') or listfind(attributes.process_type,3)>
                                    AND GC.UPD_ID = SHIP.SHIP_ID
                                    AND SHIP.SHIP_TYPE = GC.PROCESS_TYPE
                                    AND ISNULL(SHIP.IS_WITH_SHIP,0)=0
                                    </cfif>
                                    <cfif attributes.cost_money is not session.ep.money or isdefined('attributes.is_system_money_2')>
                                    AND SHIP.SHIP_ID = SM.ACTION_ID
                                        <cfif isdefined('attributes.is_system_money_2')>
                                            AND SM.MONEY_TYPE = '#session.ep.money2#'
                                        <cfelse>
                                            AND SM.MONEY_TYPE = '#attributes.cost_money#'
                                        </cfif>
                                    </cfif>
                                    AND GC.PROCESS_DATE >= #attributes.date#
                                    AND GC.PROCESS_DATE <= #attributes.date2#
                                    <cfif len(attributes.department_id)>
                                    AND
                                        (
                                        <cfloop list="#attributes.department_id#" delimiters="," index="dept_i">
                                        (GC.STORE = #listfirst(dept_i,'-')# AND GC.STORE_LOCATION = #listlast(dept_i,'-')#)
                                        <cfif dept_i neq listlast(attributes.department_id,',') and listlen(attributes.department_id,',') gte 1> OR</cfif>
                                        </cfloop>  
                                        )
                                    <cfelseif is_store>
                                        AND GC.STORE IN (#branch_dep_list#)
                                    </cfif>
                                    <cfif stock_table>
                                    AND	GC.STOCK_ID=S.STOCK_ID
                                    </cfif>
                                    <cfif len(trim(attributes.sup_company)) and len(attributes.sup_company_id)>
                                    AND S.COMPANY_ID = #attributes.sup_company_id#
                                    </cfif>
                                    <cfif len(trim(attributes.employee_name)) and len(attributes.product_employee_id)>
                                    AND S.PRODUCT_MANAGER = #attributes.product_employee_id#
                                    </cfif>
                                    <cfif len(trim(attributes.product_name)) and len(attributes.product_id)>
                                    AND S.PRODUCT_ID = #attributes.product_id#
                                    </cfif>
                                    <cfif len(trim(attributes.brand_name)) and len(attributes.brand_id)>
                                    AND S.BRAND_ID = #attributes.brand_id# 
                                    </cfif>	
                                    <cfif len(trim(attributes.product_cat)) and len(attributes.product_code)>
                                    AND S.STOCK_CODE LIKE '#attributes.product_code#%'
                                    </cfif>
                            <cfif attributes.cost_money is not session.ep.money or listfind(attributes.process_type,3)>
                            UNION ALL
                                SELECT
                                    GC.STOCK_ID,
                                    GC.PRODUCT_ID,
                                    <cfif attributes.report_type eq 8>
                                    CAST(GC.STOCK_ID AS NVARCHAR(50)) +'_'+ CAST(ISNULL(GC.SPECT_VAR_ID,0) AS NVARCHAR(50)) STOCK_SPEC_ID,
                                    </cfif>
                                    INVOICE.INVOICE_CAT,
                                    <cfif stock_table>
                                    S.PRODUCT_MANAGER,
                                    S.PRODUCT_CATID,
                                    S.BRAND_ID,
                                    </cfif>
                                    <cfif isdefined('attributes.is_system_money_2') or attributes.cost_money is not session.ep.money>
                                        <cfif isdefined('attributes.is_system_money_2')>
                                        GC.MALIYET_2,
                                        GC.MALIYET,
                                        ((GC.MALIYET_2*ABS(GC.STOCK_IN-GC.STOCK_OUT))) AS TOTAL_COST_2,
                                        (GC.MALIYET*ABS(GC.STOCK_IN-GC.STOCK_OUT)) AS TOTAL_COST,
                                        <cfelse>
                                            (GC.MALIYET/(IM.RATE2/IM.RATE1)) AS MALIYET,
                                            ((GC.MALIYET*ABS(GC.STOCK_IN-GC.STOCK_OUT))/(IM.RATE2/IM.RATE1)) AS TOTAL_COST,
                                        </cfif>
                                    <cfelse>
                                        (GC.MALIYET) AS MALIYET,
                                        ((GC.MALIYET*ABS(GC.STOCK_IN-GC.STOCK_OUT))) AS TOTAL_COST,
                                    </cfif>
                                    ABS(GC.STOCK_IN-GC.STOCK_OUT) AS AMOUNT,
                                    GC.STOCK_IN,
                                    GC.STOCK_OUT,
                                    GC.PROCESS_DATE ISLEM_TARIHI,
                                    GC.PROCESS_TYPE PROCESS_TYPE
                                    <!---ISNULL(ABS(GC.STOCK_IN-GC.STOCK_OUT)*(
                                        SELECT TOP 1 
                                            <cfif isdefined("attributes.location_based_cost")>
                                                <cfif isdefined("attributes.display_cost_money")>
                                                    (PURCHASE_NET_LOCATION+PURCHASE_EXTRA_COST_LOCATION)
                                                <cfelse>
                                                    (PURCHASE_NET_SYSTEM_LOCATION+PURCHASE_EXTRA_COST_SYSTEM_LOCATION)
                                                </cfif>
                                            <cfelse>
                                                <cfif isdefined("attributes.display_cost_money")>
                                                    (PURCHASE_NET+PURCHASE_EXTRA_COST)
                                                <cfelse>
                                                    (PURCHASE_NET_SYSTEM+PURCHASE_EXTRA_COST_SYSTEM)
                                                </cfif>	
                                            </cfif>
                                        FROM 
                                            #dsn3_alias#.PRODUCT_COST WITH (NOLOCK) 
                                        WHERE 
                                            START_DATE <= #finish_date# 
                                            AND PRODUCT_ID = GC.PRODUCT_ID
                                            <cfif attributes.report_type eq 8>
                                                 AND ISNULL(PRODUCT_COST.SPECT_MAIN_ID,0) = ISNULL(GC.SPECT_VAR_ID,0)
                                            </cfif>
                                            
                                            <cfif isdefined("attributes.location_based_cost")>
                                                <cfif len(attributes.department_id)>
                                                    AND DEPARTMENT_ID = #listgetat(attributes.department_id,1,'-')#
                                                    AND LOCATION_ID = #listgetat(attributes.department_id,2,'-')#
                                                <cfelse>
                                                    AND DEPARTMENT_ID = SL.DEPARTMENT_ID
                                                    AND LOCATION_ID = SL.LOCATION_ID
                                                </cfif>
                                            </cfif>
                                        ORDER BY 
                                            START_DATE DESC, 
                                            RECORD_DATE DESC,
                                            PRODUCT_COST_ID DESC
                                    ),0) ALL_FINISH_COST,
                                    ISNULL(ABS(GC.STOCK_IN-GC.STOCK_OUT)*(
                                        SELECT TOP 1 
                                            <cfif isdefined("attributes.location_based_cost")>
                                                (PURCHASE_NET_SYSTEM_2_LOCATION+PURCHASE_EXTRA_COST_SYSTEM_2_LOCATION)

                                            <cfelse>
                                                (PURCHASE_NET_SYSTEM_2+PURCHASE_EXTRA_COST_SYSTEM_2)
                                            </cfif>
                                        FROM 
                                            #dsn3_alias#.PRODUCT_COST WITH (NOLOCK) 
                                        WHERE 
                                            START_DATE <= #finish_date# 
                                            AND PRODUCT_ID = GC.PRODUCT_ID
                                            <cfif attributes.report_type eq 8>
                                                 AND ISNULL(PRODUCT_COST.SPECT_MAIN_ID,0) = ISNULL(GC.SPECT_VAR_ID,0)
                                            </cfif>
                                           
                                            <cfif isdefined("attributes.location_based_cost")>
                                                <cfif len(attributes.department_id)>
                                                    AND DEPARTMENT_ID = #listgetat(attributes.department_id,1,'-')#
                                                    AND LOCATION_ID = #listgetat(attributes.department_id,2,'-')#
                                                <cfelse>
                                                    AND DEPARTMENT_ID = SL.DEPARTMENT_ID
                                                    AND LOCATION_ID = SL.LOCATION_ID
                                                </cfif>
                                            </cfif>
                                        ORDER BY 
                                            START_DATE DESC, 
                                            RECORD_DATE DESC,
                                            PRODUCT_COST_ID DESC
                                    ),0) ALL_FINISH_COST_2--->
                                FROM
                                    SHIP WITH (NOLOCK),
                                    INVOICE WITH (NOLOCK),
                                    INVOICE_SHIPS INV_S,
                                    <cfif isdefined('attributes.is_system_money_2') or attributes.cost_money is not session.ep.money>
                                    INVOICE_MONEY IM,
                                    </cfif>
                                    <cfif is_store or isdefined("attributes.location_based_cost")>
                                        <cfif attributes.report_type eq 8>
                                            GET_STOCKS_ROW_COST_SPECT_LOCATION AS GC,
                                        <cfelse>
                                            GET_STOCKS_ROW_COST_LOCATION AS GC,
                                        </cfif>
                                    <cfelse>
                                        <cfif attributes.report_type eq 8>
                                            GET_STOCKS_ROW_COST_SPECT AS GC,
                                        <cfelse>
                                            GET_STOCK_ROW_COST_TABLE AS GC,
                                        </cfif>
                                    </cfif>
                                    <cfif stock_table>
                                    #dsn3_alias#.STOCKS S,
                                    </cfif>
                                    #dsn_alias#.STOCKS_LOCATION SL
                                WHERE
                                    SHIP.SHIP_ID = INV_S.SHIP_ID
                                    AND INVOICE.INVOICE_ID= INV_S.INVOICE_ID
                                    AND INV_S.IS_WITH_SHIP = 1
                                    AND INV_S.SHIP_PERIOD_ID = #session.ep.period_id#
                                    AND SHIP.IS_WITH_SHIP=1
                                    AND SHIP.SHIP_ID = GC.UPD_ID
                                    AND SHIP.SHIP_TYPE = GC.PROCESS_TYPE
                                    AND GC.STORE = SL.DEPARTMENT_ID
                                    AND GC.STORE_LOCATION=SL.LOCATION_ID
                                    <cfif not isdefined('is_belognto_institution')>
                                    AND SL.BELONGTO_INSTITUTION = 0
                                    </cfif>
                                    <cfif isdefined('attributes.is_system_money_2') or attributes.cost_money is not session.ep.money>
                                        AND IM.ACTION_ID=INVOICE.INVOICE_ID
                                        <cfif isdefined('attributes.is_system_money_2')>
                                        AND IM.MONEY_TYPE = '#session.ep.money2#'
                                        <cfelse>
                                        AND IM.MONEY_TYPE = '#attributes.cost_money#'
                                        </cfif>
                                    </cfif>
                                    AND GC.PROCESS_DATE >= #attributes.date#
                                    AND GC.PROCESS_DATE <= #attributes.date2#
                                    <cfif len(attributes.department_id)>
                                    AND
                                        (
                                        <cfloop list="#attributes.department_id#" delimiters="," index="dept_i">
                                        (GC.STORE = #listfirst(dept_i,'-')# AND GC.STORE_LOCATION = #listlast(dept_i,'-')#)
                                        <cfif dept_i neq listlast(attributes.department_id,',') and listlen(attributes.department_id,',') gte 1> OR</cfif>
                                        </cfloop>  
                                        )
                                    <cfelseif is_store>
                                        AND GC.STORE IN (#branch_dep_list#)
                                    </cfif>
                                    <cfif stock_table>
                                    AND	GC.STOCK_ID=S.STOCK_ID
                                    </cfif>
                                    <cfif len(trim(attributes.sup_company)) and len(attributes.sup_company_id)>
                                        AND S.COMPANY_ID = #attributes.sup_company_id#
                                    </cfif>
                                    <cfif len(trim(attributes.employee_name)) and len(attributes.product_employee_id)>
                                        AND S.PRODUCT_MANAGER = #attributes.product_employee_id#
                                    </cfif>
                                    <cfif len(trim(attributes.product_name)) and len(attributes.product_id)>
                                        AND S.PRODUCT_ID = #attributes.product_id#
                                    </cfif>
                                    <cfif len(trim(attributes.brand_name)) and len(attributes.brand_id)>
                                        AND S.BRAND_ID = #attributes.brand_id# 
                                    </cfif>	
                                    <cfif len(trim(attributes.product_cat)) and len(attributes.product_code)>
                                        AND S.STOCK_CODE LIKE '#attributes.product_code#%'
                                    </cfif>
                            </cfif>
                            )AS GET_SHIP_ROWS
                        WHERE
                            PROCESS_TYPE = 86
                        GROUP BY
                            #ALAN_ADI#
                        )AS rma_giris ON GET_ALL_STOCK.PRODUCT_GROUPBY_ID = rma_giris.GROUPBY_ALANI
		</cfif>
        <!--- RMA Çıkış :Servis-Üreticiye Çıkış İrsaliyesi (Çıkış)--->
		<cfif len(attributes.process_type) and listfind(attributes.process_type,10)>
			LEFT JOIN(
                        SELECT	
                            SUM(AMOUNT) AS RMA_CIKIS_MIKTAR,
                            SUM(TOTAL_COST) AS RMA_CIKIS_MALIYET,
                            <cfif isdefined('attributes.is_system_money_2')>
                            SUM(TOTAL_COST_2) AS RMA_CIKIS_MALIYET_2,
                            </cfif>
                            #ALAN_ADI# AS GROUPBY_ALANI
                        FROM
                            (
                                SELECT
                                    GC.STOCK_ID,
                                    GC.PRODUCT_ID,
                                    <cfif attributes.report_type eq 8>
                                    CAST(GC.STOCK_ID AS NVARCHAR(50)) +'_'+ CAST(ISNULL(GC.SPECT_VAR_ID,0) AS NVARCHAR(50)) STOCK_SPEC_ID,
                                    </cfif>
                                    1 AS INVOICE_CAT,
                                    <cfif stock_table>
                                    S.PRODUCT_MANAGER,
                                    S.PRODUCT_CATID,
                                    S.BRAND_ID,
                                    </cfif>
                                    <cfif isdefined('attributes.is_system_money_2')>
                                    GC.MALIYET_2,
                                    GC.MALIYET,
                                    ((GC.MALIYET_2*ABS(GC.STOCK_IN-GC.STOCK_OUT))) AS TOTAL_COST_2,
                                    (GC.MALIYET*ABS(GC.STOCK_IN-GC.STOCK_OUT)) AS TOTAL_COST,
                                    <cfelse>
                                        <cfif attributes.cost_money is not session.ep.money>
                                        (GC.MALIYET/(SM.RATE2/SM.RATE1)) AS MALIYET,
                                        ((GC.MALIYET*ABS(GC.STOCK_IN-GC.STOCK_OUT))/(SM.RATE2/SM.RATE1)) AS TOTAL_COST,
                                        <cfelse>
                                        GC.MALIYET,
                                        (GC.MALIYET*ABS(GC.STOCK_IN-GC.STOCK_OUT)) AS TOTAL_COST,				
                                        </cfif>
                                    </cfif>
                                    ABS(GC.STOCK_IN-GC.STOCK_OUT) AS AMOUNT,
                                    GC.STOCK_IN,
                                    GC.STOCK_OUT,
                                    GC.PROCESS_DATE ISLEM_TARIHI,
                                    GC.PROCESS_TYPE PROCESS_TYPE
                                   <!--- ISNULL(ABS(GC.STOCK_IN-GC.STOCK_OUT)*(
                                        SELECT TOP 1 
                                            <cfif isdefined("attributes.location_based_cost")>
                                                <cfif isdefined("attributes.display_cost_money")>
                                                    (PURCHASE_NET_LOCATION+PURCHASE_EXTRA_COST_LOCATION)
                                                <cfelse>
                                                    (PURCHASE_NET_SYSTEM_LOCATION+PURCHASE_EXTRA_COST_SYSTEM_LOCATION)
                                                </cfif>
                                            <cfelse>
                                                <cfif isdefined("attributes.display_cost_money")>
                                                    (PURCHASE_NET+PURCHASE_EXTRA_COST)
                                                <cfelse>
                                                    (PURCHASE_NET_SYSTEM+PURCHASE_EXTRA_COST_SYSTEM)
                                                </cfif>	
                                            </cfif>
                                        FROM 
                                            #dsn3_alias#.PRODUCT_COST WITH (NOLOCK) 
                                        WHERE 
                                            START_DATE <= #finish_date# 
                                            AND PRODUCT_ID = GC.PRODUCT_ID
                                            <cfif attributes.report_type eq 8>
                                                 AND ISNULL(PRODUCT_COST.SPECT_MAIN_ID,0) = ISNULL(GC.SPECT_VAR_ID,0)
                                            </cfif>
                                            
                                            <cfif isdefined("attributes.location_based_cost")>
                                                <cfif len(attributes.department_id)>
                                                    AND DEPARTMENT_ID = #listgetat(attributes.department_id,1,'-')#
                                                    AND LOCATION_ID = #listgetat(attributes.department_id,2,'-')#
                                                <cfelse>
                                                    AND DEPARTMENT_ID = SL.DEPARTMENT_ID
                                                    AND LOCATION_ID = SL.LOCATION_ID
                                                </cfif>
                                            </cfif>
                                        ORDER BY 
                                            START_DATE DESC, 
                                            RECORD_DATE DESC,
                                            PRODUCT_COST_ID DESC
                                    ),0) ALL_FINISH_COST,
                                    ISNULL(ABS(GC.STOCK_IN-GC.STOCK_OUT)*(
                                        SELECT TOP 1 
                                            <cfif isdefined("attributes.location_based_cost")>
                                                (PURCHASE_NET_SYSTEM_2_LOCATION+PURCHASE_EXTRA_COST_SYSTEM_2_LOCATION)
                                            <cfelse>
                                                (PURCHASE_NET_SYSTEM_2+PURCHASE_EXTRA_COST_SYSTEM_2)
                                            </cfif>
                                        FROM 
                                            #dsn3_alias#.PRODUCT_COST WITH (NOLOCK) 
                                        WHERE 
                                            START_DATE <= #finish_date# 
                                            AND PRODUCT_ID = GC.PRODUCT_ID
                                            <cfif attributes.report_type eq 8>
                                                 AND ISNULL(PRODUCT_COST.SPECT_MAIN_ID,0) = ISNULL(GC.SPECT_VAR_ID,0)
                                            </cfif>
                                            
                                            <cfif isdefined("attributes.location_based_cost")>
                                                <cfif len(attributes.department_id)>
                                                    AND DEPARTMENT_ID = #listgetat(attributes.department_id,1,'-')#
                                                    AND LOCATION_ID = #listgetat(attributes.department_id,2,'-')#
                                                <cfelse>
                                                    AND DEPARTMENT_ID = SL.DEPARTMENT_ID
                                                    AND LOCATION_ID = SL.LOCATION_ID
                                                </cfif>
                                            </cfif>
                                        ORDER BY 
                                            START_DATE DESC, 
                                            RECORD_DATE DESC,
                                            PRODUCT_COST_ID DESC
                                    ),0) ALL_FINISH_COST_2--->
                                FROM
                                    <cfif is_store or isdefined("attributes.location_based_cost")>
                                        <cfif attributes.report_type eq 8>
                                            GET_STOCKS_ROW_COST_SPECT_LOCATION AS GC,
                                        <cfelse>
                                            GET_STOCKS_ROW_COST_LOCATION AS GC,
                                        </cfif>
                                    <cfelse>
                                        <cfif attributes.report_type eq 8>
                                            GET_STOCKS_ROW_COST_SPECT AS GC,
                                        <cfelse>
                                            GET_STOCK_ROW_COST_TABLE AS GC,
                                        </cfif>
                                    </cfif>
                                    <cfif attributes.cost_money is not session.ep.money or isdefined('attributes.is_system_money_2') or listfind(attributes.process_type,3)>
                                    SHIP WITH (NOLOCK),	
                                    </cfif>
                                    <cfif attributes.cost_money is not session.ep.money or isdefined('attributes.is_system_money_2')>
                                    SHIP_MONEY SM,
                                    </cfif>
                                    <cfif stock_table>
                                    #dsn3_alias#.STOCKS S,
                                    </cfif>
                                    #dsn_alias#.STOCKS_LOCATION SL
                                WHERE
                                    GC.STORE = SL.DEPARTMENT_ID
                                    AND GC.STORE_LOCATION=SL.LOCATION_ID
                                    <cfif not isdefined('is_belognto_institution')>
                                    AND SL.BELONGTO_INSTITUTION = 0
                                    </cfif>
                                    <cfif attributes.cost_money is not session.ep.money or isdefined('attributes.is_system_money_2') or listfind(attributes.process_type,3)>
                                    AND GC.UPD_ID = SHIP.SHIP_ID
                                    AND SHIP.SHIP_TYPE = GC.PROCESS_TYPE
                                    AND ISNULL(SHIP.IS_WITH_SHIP,0)=0
                                    </cfif>
                                    <cfif attributes.cost_money is not session.ep.money or isdefined('attributes.is_system_money_2')>
                                    AND SHIP.SHIP_ID = SM.ACTION_ID
                                        <cfif isdefined('attributes.is_system_money_2')>
                                            AND SM.MONEY_TYPE = '#session.ep.money2#'
                                        <cfelse>
                                            AND SM.MONEY_TYPE = '#attributes.cost_money#'
                                        </cfif>
                                    </cfif>
                                    AND GC.PROCESS_DATE >= #attributes.date#
                                    AND GC.PROCESS_DATE <= #attributes.date2#
                                    <cfif len(attributes.department_id)>
                                    AND
                                        (
                                        <cfloop list="#attributes.department_id#" delimiters="," index="dept_i">
                                        (GC.STORE = #listfirst(dept_i,'-')# AND GC.STORE_LOCATION = #listlast(dept_i,'-')#)
                                        <cfif dept_i neq listlast(attributes.department_id,',') and listlen(attributes.department_id,',') gte 1> OR</cfif>
                                        </cfloop>  
                                        )
                                    <cfelseif is_store>
                                        AND GC.STORE IN (#branch_dep_list#)
                                    </cfif>
                                    <cfif stock_table>
                                    AND	GC.STOCK_ID=S.STOCK_ID
                                    </cfif>
                                    <cfif len(trim(attributes.sup_company)) and len(attributes.sup_company_id)>
                                    AND S.COMPANY_ID = #attributes.sup_company_id#
                                    </cfif>
                                    <cfif len(trim(attributes.employee_name)) and len(attributes.product_employee_id)>
                                    AND S.PRODUCT_MANAGER = #attributes.product_employee_id#
                                    </cfif>
                                    <cfif len(trim(attributes.product_name)) and len(attributes.product_id)>
                                    AND S.PRODUCT_ID = #attributes.product_id#
                                    </cfif>
                                    <cfif len(trim(attributes.brand_name)) and len(attributes.brand_id)>
                                    AND S.BRAND_ID = #attributes.brand_id# 
                                    </cfif>	
                                    <cfif len(trim(attributes.product_cat)) and len(attributes.product_code)>
                                    AND S.STOCK_CODE LIKE '#attributes.product_code#%'
                                    </cfif>
                            <cfif attributes.cost_money is not session.ep.money or listfind(attributes.process_type,3)>
                            UNION ALL
                                SELECT
                                    GC.STOCK_ID,
                                    GC.PRODUCT_ID,
                                    <cfif attributes.report_type eq 8>
                                    CAST(GC.STOCK_ID AS NVARCHAR(50)) +'_'+ CAST(ISNULL(GC.SPECT_VAR_ID,0) AS NVARCHAR(50)) STOCK_SPEC_ID,
                                    </cfif>
                                    INVOICE.INVOICE_CAT,
                                    <cfif stock_table>
                                    S.PRODUCT_MANAGER,
                                    S.PRODUCT_CATID,
                                    S.BRAND_ID,
                                    </cfif>
                                    <cfif isdefined('attributes.is_system_money_2') or attributes.cost_money is not session.ep.money>
                                        <cfif isdefined('attributes.is_system_money_2')>
                                        GC.MALIYET_2,
                                        GC.MALIYET,
                                        ((GC.MALIYET_2*ABS(GC.STOCK_IN-GC.STOCK_OUT))) AS TOTAL_COST_2,
                                        (GC.MALIYET*ABS(GC.STOCK_IN-GC.STOCK_OUT)) AS TOTAL_COST,
                                        <cfelse>
                                            (GC.MALIYET/(IM.RATE2/IM.RATE1)) AS MALIYET,
                                            ((GC.MALIYET*ABS(GC.STOCK_IN-GC.STOCK_OUT))/(IM.RATE2/IM.RATE1)) AS TOTAL_COST,
                                        </cfif>
                                    <cfelse>
                                        (GC.MALIYET) AS MALIYET,
                                        ((GC.MALIYET*ABS(GC.STOCK_IN-GC.STOCK_OUT))) AS TOTAL_COST,
                                    </cfif>
                                    ABS(GC.STOCK_IN-GC.STOCK_OUT) AS AMOUNT,
                                    GC.STOCK_IN,
                                    GC.STOCK_OUT,
                                    GC.PROCESS_DATE ISLEM_TARIHI,
                                    GC.PROCESS_TYPE PROCESS_TYPE
                                   <!--- ISNULL(ABS(GC.STOCK_IN-GC.STOCK_OUT)*(
                                        SELECT TOP 1 
                                            <cfif isdefined("attributes.location_based_cost")>
                                                <cfif isdefined("attributes.display_cost_money")>
                                                    (PURCHASE_NET_LOCATION+PURCHASE_EXTRA_COST_LOCATION)
                                                <cfelse>
                                                    (PURCHASE_NET_SYSTEM_LOCATION+PURCHASE_EXTRA_COST_SYSTEM_LOCATION)
                                                </cfif>
                                            <cfelse>
                                                <cfif isdefined("attributes.display_cost_money")>
                                                    (PURCHASE_NET+PURCHASE_EXTRA_COST)
                                                <cfelse>
                                                    (PURCHASE_NET_SYSTEM+PURCHASE_EXTRA_COST_SYSTEM)
                                                </cfif>	
                                            </cfif>
                                        FROM 
                                            #dsn3_alias#.PRODUCT_COST WITH (NOLOCK) 
                                        WHERE 
                                            START_DATE <= #finish_date# 
                                            AND PRODUCT_ID = GC.PRODUCT_ID
                                            <cfif attributes.report_type eq 8>
                                                 AND ISNULL(PRODUCT_COST.SPECT_MAIN_ID,0) = ISNULL(GC.SPECT_VAR_ID,0)
                                            </cfif>
                                            
                                            <cfif isdefined("attributes.location_based_cost")>
                                                <cfif len(attributes.department_id)>
                                                    AND DEPARTMENT_ID = #listgetat(attributes.department_id,1,'-')#
                                                    AND LOCATION_ID = #listgetat(attributes.department_id,2,'-')#
                                                <cfelse>
                                                    AND DEPARTMENT_ID = SL.DEPARTMENT_ID
                                                    AND LOCATION_ID = SL.LOCATION_ID
                                                </cfif>
                                            </cfif>
                                        ORDER BY 
                                            START_DATE DESC, 
                                            RECORD_DATE DESC,
                                            PRODUCT_COST_ID DESC
                                    ),0) ALL_FINISH_COST,
                                    ISNULL(ABS(GC.STOCK_IN-GC.STOCK_OUT)*(
                                        SELECT TOP 1 
                                            <cfif isdefined("attributes.location_based_cost")>
                                                (PURCHASE_NET_SYSTEM_2_LOCATION+PURCHASE_EXTRA_COST_SYSTEM_2_LOCATION)
                                            <cfelse>
                                                (PURCHASE_NET_SYSTEM_2+PURCHASE_EXTRA_COST_SYSTEM_2)
                                            </cfif>
                                        FROM 
                                            #dsn3_alias#.PRODUCT_COST WITH (NOLOCK) 
                                        WHERE 
                                            START_DATE <= #finish_date# 
                                            AND PRODUCT_ID = GC.PRODUCT_ID
                                            <cfif attributes.report_type eq 8>
                                                 AND ISNULL(PRODUCT_COST.SPECT_MAIN_ID,0) = ISNULL(GC.SPECT_VAR_ID,0)
                                            </cfif>
                                           
                                            <cfif isdefined("attributes.location_based_cost")>
                                                <cfif len(attributes.department_id)>
                                                    AND DEPARTMENT_ID = #listgetat(attributes.department_id,1,'-')#
                                                    AND LOCATION_ID = #listgetat(attributes.department_id,2,'-')#
                                                <cfelse>
                                                    AND DEPARTMENT_ID = SL.DEPARTMENT_ID
                                                    AND LOCATION_ID = SL.LOCATION_ID
                                                </cfif>
                                            </cfif>
                                        ORDER BY 
                                            START_DATE DESC, 
                                            RECORD_DATE DESC,
                                            PRODUCT_COST_ID DESC
                                    ),0) ALL_FINISH_COST_2--->
                                FROM
                                    SHIP WITH (NOLOCK),
                                    INVOICE WITH (NOLOCK),
                                    INVOICE_SHIPS INV_S,
                                    <cfif isdefined('attributes.is_system_money_2') or attributes.cost_money is not session.ep.money>
                                    INVOICE_MONEY IM,
                                    </cfif>
                                    <cfif is_store or isdefined("attributes.location_based_cost")>
                                        <cfif attributes.report_type eq 8>
                                            GET_STOCKS_ROW_COST_SPECT_LOCATION AS GC,
                                        <cfelse>
                                            GET_STOCKS_ROW_COST_LOCATION AS GC,
                                        </cfif>
                                    <cfelse>
                                        <cfif attributes.report_type eq 8>
                                            GET_STOCKS_ROW_COST_SPECT AS GC,
                                        <cfelse>
                                            GET_STOCK_ROW_COST_TABLE AS GC,
                                        </cfif>
                                    </cfif>
                                    <cfif stock_table>
                                    #dsn3_alias#.STOCKS S,
                                    </cfif>
                                    #dsn_alias#.STOCKS_LOCATION SL
                                WHERE
                                    SHIP.SHIP_ID = INV_S.SHIP_ID
                                    AND INVOICE.INVOICE_ID= INV_S.INVOICE_ID
                                    AND INV_S.IS_WITH_SHIP = 1
                                    AND INV_S.SHIP_PERIOD_ID = #session.ep.period_id#
                                    AND SHIP.IS_WITH_SHIP=1
                                    AND SHIP.SHIP_ID = GC.UPD_ID
                                    AND SHIP.SHIP_TYPE = GC.PROCESS_TYPE
                                    AND GC.STORE = SL.DEPARTMENT_ID
                                    AND GC.STORE_LOCATION=SL.LOCATION_ID
                                    <cfif not isdefined('is_belognto_institution')>
                                    AND SL.BELONGTO_INSTITUTION = 0
                                    </cfif>
                                    <cfif isdefined('attributes.is_system_money_2') or attributes.cost_money is not session.ep.money>
                                        AND IM.ACTION_ID=INVOICE.INVOICE_ID
                                        <cfif isdefined('attributes.is_system_money_2')>
                                        AND IM.MONEY_TYPE = '#session.ep.money2#'
                                        <cfelse>
                                        AND IM.MONEY_TYPE = '#attributes.cost_money#'
                                        </cfif>
                                    </cfif>
                                    AND GC.PROCESS_DATE >= #attributes.date#
                                    AND GC.PROCESS_DATE <= #attributes.date2#
                                    <cfif len(attributes.department_id)>
                                    AND
                                        (
                                        <cfloop list="#attributes.department_id#" delimiters="," index="dept_i">
                                        (GC.STORE = #listfirst(dept_i,'-')# AND GC.STORE_LOCATION = #listlast(dept_i,'-')#)
                                        <cfif dept_i neq listlast(attributes.department_id,',') and listlen(attributes.department_id,',') gte 1> OR</cfif>
                                        </cfloop>  
                                        )
                                    <cfelseif is_store>
                                        AND GC.STORE IN (#branch_dep_list#)
                                    </cfif>
                                    <cfif stock_table>
                                    AND	GC.STOCK_ID=S.STOCK_ID
                                    </cfif>
                                    <cfif len(trim(attributes.sup_company)) and len(attributes.sup_company_id)>
                                        AND S.COMPANY_ID = #attributes.sup_company_id#
                                    </cfif>
                                    <cfif len(trim(attributes.employee_name)) and len(attributes.product_employee_id)>
                                        AND S.PRODUCT_MANAGER = #attributes.product_employee_id#
                                    </cfif>
                                    <cfif len(trim(attributes.product_name)) and len(attributes.product_id)>
                                        AND S.PRODUCT_ID = #attributes.product_id#
                                    </cfif>
                                    <cfif len(trim(attributes.brand_name)) and len(attributes.brand_id)>
                                        AND S.BRAND_ID = #attributes.brand_id# 
                                    </cfif>	
                                    <cfif len(trim(attributes.product_cat)) and len(attributes.product_code)>
                                        AND S.STOCK_CODE LIKE '#attributes.product_code#%'
                                    </cfif>
                            </cfif>
                            )AS GET_SHIP_ROWS
                        WHERE
                            PROCESS_TYPE = 85
                        GROUP BY
                            #ALAN_ADI#
                        )AS rma_cikis ON GET_ALL_STOCK.PRODUCT_GROUPBY_ID = rma_cikis.GROUPBY_ALANI
		</cfif>
        <!--- donemici uretim --->
		<cfif len(attributes.process_type) and listfind(attributes.process_type,4)>
			LEFT JOIN(
                        SELECT	
                            SUM(AMOUNT) AS TOPLAM_URETIM,
                            SUM(TOTAL_COST) AS URETIM_MALIYET,
                            <cfif isdefined('attributes.is_system_money_2')>
                            SUM(TOTAL_COST_2) AS URETIM_MALIYET_2,
                            </cfif>
                            #ALAN_ADI# AS GROUPBY_ALANI
                        FROM
	                        (
                                SELECT
                                    GC.PRODUCT_ID,
                                    GC.STOCK_ID,
                                    <cfif stock_table>
                                        S.PRODUCT_CATID,
                                        S.BRAND_ID,
                                    </cfif>
                                    SFR.AMOUNT,
                                    SF.DEPARTMENT_IN,
                                    SF.DEPARTMENT_OUT,
                                    SF.LOCATION_IN,
                                    SF.LOCATION_OUT,
                                    GC.STOCK_IN,
                                    GC.STOCK_OUT,
                                    ((GC.MALIYET_2*ABS(GC.STOCK_IN-GC.STOCK_OUT))) AS TOTAL_COST_2,
                                    (GC.MALIYET*ABS(GC.STOCK_IN-GC.STOCK_OUT)) AS TOTAL_COST,
                                    <cfif isdefined('attributes.is_system_money_2') or attributes.cost_money is not session.ep.money>
                                        <cfif isdefined('attributes.is_system_money_2')> <!--- sistem 2. para br. checkboxı işaretlenmişse, maliyet para br. olarak sadece sistem para br secilebilir --->
                                        GC.MALIYET MALIYET,
                                        GC.MALIYET_2 MALIYET_2,
                                        (SFR.AMOUNT*ISNULL(COST_PRICE,0)) AS TOTAL_COST_PRICE,<!--- uretimden giris fislerinde belge uzerindeki maliyet kullanılıyor --->
                                        (SFR.AMOUNT*ISNULL(EXTRA_COST,0)) AS TOTAL_EXTRA_COST,
                                        (SFR.AMOUNT*ISNULL(COST_PRICE,0))/(SF_M.RATE2/SF_M.RATE1) AS TOTAL_COST_PRICE_2,
                                        (SFR.AMOUNT*ISNULL(EXTRA_COST,0))/(SF_M.RATE2/SF_M.RATE1) AS TOTAL_EXTRA_COST_2,
                                        <cfelse>
                                        (GC.MALIYET/(SF_M.RATE2/SF_M.RATE1)) MALIYET,
                                        (SFR.AMOUNT*ISNULL(COST_PRICE,0)) AS TOTAL_COST_PRICE,
                                        (SFR.AMOUNT*ISNULL(EXTRA_COST,0)) AS TOTAL_EXTRA_COST,
                                        </cfif>
                                    <cfelse>
                                        (GC.MALIYET) MALIYET,
                                        (SFR.AMOUNT*ISNULL(COST_PRICE,0)) AS TOTAL_COST_PRICE,
                                        (SFR.AMOUNT*ISNULL(EXTRA_COST,0)) AS TOTAL_EXTRA_COST,
                                    </cfif>
                                    <cfif attributes.report_type eq 8>
                                    CAST(GC.STOCK_ID AS NVARCHAR(50)) +'_'+ CAST(ISNULL(GC.SPECT_VAR_ID,0) AS NVARCHAR(50)) STOCK_SPEC_ID,
                                    </cfif>
                                    SF.FIS_DATE ISLEM_TARIHI,
                                    SF.PROCESS_CAT,
                                    SF.FIS_TYPE PROCESS_TYPE,
                                    ISNULL(SF.PROD_ORDER_NUMBER,0) AS PROD_ORDER_NUMBER,
                                    ISNULL(SF.PROD_ORDER_RESULT_NUMBER,0) AS PROD_ORDER_RESULT_NUMBER
                                FROM 
                                    STOCK_FIS SF WITH (NOLOCK),
                                    STOCK_FIS_ROW SFR WITH (NOLOCK),
                                    <cfif isdefined('attributes.is_system_money_2') or attributes.cost_money is not session.ep.money>
                                    STOCK_FIS_MONEY SF_M,
                                    </cfif>
                                    <cfif is_store or isdefined("attributes.location_based_cost")>
                                        <cfif attributes.report_type eq 8>
                                            GET_STOCKS_ROW_COST_SPECT_LOCATION AS GC
                                        <cfelse>
                                            GET_STOCKS_ROW_COST_LOCATION AS GC
                                        </cfif>
                                    <cfelse>
                                        <cfif attributes.report_type eq 8>
                                            GET_STOCKS_ROW_COST_SPECT AS GC
                                        <cfelse>
                                            GET_STOCK_ROW_COST_TABLE AS GC
                                        </cfif>
                                    </cfif>
                                    <cfif stock_table>
                                    ,#dsn3_alias#.STOCKS S WITH (NOLOCK)
                                    </cfif>
                                WHERE 
                                    GC.UPD_ID = SF.FIS_ID AND
                                    SFR.FIS_ID=	SF.FIS_ID AND
                                    GC.PROCESS_TYPE = SF.FIS_TYPE AND
                                    <cfif stock_table>
                                    S.STOCK_ID = GC.STOCK_ID AND
                                    </cfif>
                                    GC.STOCK_ID=SFR.STOCK_ID AND
                                    SF.FIS_TYPE  IN (110,111,112,113,115,119) AND 
                                    SF.FIS_DATE >= #attributes.date# AND 
                                    SF.FIS_DATE <= #attributes.date2#
                                    <cfif isdefined('attributes.is_system_money_2') or attributes.cost_money is not session.ep.money>
                                         AND SF.FIS_ID = SF_M.ACTION_ID
                                        <cfif isdefined('attributes.is_system_money_2')>
                                         AND SF_M.MONEY_TYPE = '#session.ep.money2#'
                                        <cfelse>
                                         AND SF_M.MONEY_TYPE = '#attributes.cost_money#'
                                        </cfif>
                                    </cfif>
                                    <cfif len(attributes.department_id)>
                                    AND(
                                        (
                                            SF.DEPARTMENT_OUT IS NOT NULL AND
                                            <cfloop list="#attributes.department_id#" delimiters="," index="dept_i">
                                            (SF.DEPARTMENT_OUT = #listfirst(dept_i,'-')# AND SF.LOCATION_OUT = #listlast(dept_i,'-')#)
                                            <cfif dept_i neq listlast(attributes.department_id,',') and listlen(attributes.department_id,',') gte 1> OR</cfif>
                                            </cfloop>  
                                        )
                                    OR 
                                        (
                                            SF.DEPARTMENT_IN IS NOT NULL AND
                                            <cfloop list="#attributes.department_id#" delimiters="," index="dept_i">
                                            (SF.DEPARTMENT_IN  = #listfirst(dept_i,'-')# AND SF.LOCATION_IN = #listlast(dept_i,'-')#)
                                            <cfif dept_i neq listlast(attributes.department_id,',') and listlen(attributes.department_id,',') gte 1> OR</cfif>
                                            </cfloop>  
                                        )
                                    )
                                    <cfelseif is_store>
                                        AND (
                                                SF.DEPARTMENT_OUT IN (#branch_dep_list#) OR SF.DEPARTMENT_IN IN (#branch_dep_list#)
                                             )
                                    </cfif>
                                    <cfif len(trim(attributes.sup_company)) and len(attributes.sup_company_id)>
                                        AND S.COMPANY_ID = #attributes.sup_company_id#
                                    </cfif>
                                    <cfif len(trim(attributes.employee_name)) and len(attributes.product_employee_id)>
                                        AND S.PRODUCT_MANAGER = #attributes.product_employee_id#
                                    </cfif>
                                    <cfif len(trim(attributes.product_name)) and len(attributes.product_id)>
                                        AND S.PRODUCT_ID = #attributes.product_id#
                                    </cfif>
                                    <cfif len(trim(attributes.brand_name)) and len(attributes.brand_id)>
                                        AND S.BRAND_ID = #attributes.brand_id# 
                                    </cfif>	
                                    <cfif len(trim(attributes.product_cat)) and len(attributes.product_code)>
                                        AND S.STOCK_CODE LIKE '#attributes.product_code#%'
                                    </cfif>
                            )
                            AS GET_STOCK_FIS
                        WHERE
                            ISLEM_TARIHI >= #attributes.date#
                            AND PROCESS_TYPE = 110
                            <cfif isdefined('process_cat_list') and len(process_cat_list)>
                            AND PROCESS_CAT  IN (#process_cat_list#)
                            </cfif>
                        GROUP BY
                            #ALAN_ADI#		
                        )AS donemici_uretim ON GET_ALL_STOCK.PRODUCT_GROUPBY_ID = donemici_uretim.GROUPBY_ALANI
		</cfif>
        <cfif len(attributes.process_type) and listfind(attributes.process_type,15)> <!--- uretimle ilgisi olmayan sarflar --->
			LEFT JOIN(
                        SELECT	
                            SUM(AMOUNT) AS TOPLAM_MASRAF_MIKTAR,
                            SUM(MALIYET*AMOUNT) AS MASRAF_MALIYET,
                            <cfif isdefined('attributes.is_system_money_2')>
                            SUM(MALIYET_2*AMOUNT) AS MASRAF_MALIYET_2,
                            </cfif>
                            #ALAN_ADI# AS GROUPBY_ALANI			
                        FROM
                            (
                            SELECT
                                GC.PRODUCT_ID,
                                GC.STOCK_ID,
                                <cfif stock_table>
                                S.PRODUCT_CATID,
                                S.BRAND_ID,
                                </cfif>
                                EIR.QUANTITY AS AMOUNT,
                                <cfif isdefined('attributes.is_system_money_2')> <!--- sistem 2. para br. checkboxı işaretlenmişse, maliyet para br. olarak sadece sistem para br secilebilir --->
                                GC.MALIYET MALIYET,
                                GC.MALIYET_2 MALIYET_2,
                                <cfelse>
                                (GC.MALIYET/(EIRM.RATE2/EIRM.RATE1)) MALIYET,
                                </cfif>
                                <cfif attributes.report_type eq 8>
                                CAST(GC.STOCK_ID AS NVARCHAR(50)) +'_'+ CAST(ISNULL(GC.SPECT_VAR_ID,0) AS NVARCHAR(50)) STOCK_SPEC_ID,
                                </cfif>
                                EIP.EXPENSE_DATE ISLEM_TARIHI,
                                EIP.ACTION_TYPE PROCESS_TYPE
                            FROM 
                                EXPENSE_ITEM_PLANS EIP,
                                EXPENSE_ITEMS_ROWS EIR,
                                EXPENSE_ITEM_PLANS_MONEY EIRM,
                                <cfif is_store>
                                    <cfif attributes.report_type eq 8>
                                        GET_STOCKS_ROW_COST_SPECT_LOCATION AS GC
                                    <cfelse>
                                        GET_STOCKS_ROW_COST_LOCATION AS GC
                                    </cfif>
                                <cfelse>
                                    <cfif attributes.report_type eq 8>
                                        GET_STOCKS_ROW_COST_SPECT AS GC
                                    <cfelse>
                                        GET_STOCK_ROW_COST_TABLE AS GC
                                    </cfif>
                                </cfif>
                                <cfif stock_table>
                                ,#dsn3_alias#.STOCKS S
                                </cfif>
                            WHERE 
                                GC.UPD_ID = EIP.EXPENSE_ID AND
                                EIR.EXPENSE_ID=	EIP.EXPENSE_ID AND
                                EIP.EXPENSE_ID = EIRM.ACTION_ID AND
                                GC.PROCESS_TYPE = EIP.ACTION_TYPE AND
                                <cfif stock_table>
                                S.STOCK_ID = GC.STOCK_ID AND
                                </cfif>
                                GC.STOCK_ID=EIR.STOCK_ID_2 AND 
                                EIP.ACTION_TYPE=122 AND
                                EIP.EXPENSE_DATE >= #attributes.date# AND 
                                EIP.EXPENSE_DATE <= #attributes.date2# AND
                                <cfif isdefined('attributes.is_system_money_2')>
                                    EIRM.MONEY_TYPE = '#session.ep.money2#'
                                <cfelse>
                                    EIRM.MONEY_TYPE = '#attributes.cost_money#'
                                </cfif>
                                <cfif len(attributes.department_id)>
                                AND(
                                    (
                                        EIP.DEPARTMENT_ID IS NOT NULL AND
                                        <cfloop list="#attributes.department_id#" delimiters="," index="dept_i">
                                        (EIP.DEPARTMENT_ID = #listfirst(dept_i,'-')# AND EIP.LOCATION_ID = #listlast(dept_i,'-')#)
                                        <cfif dept_i neq listlast(attributes.department_id,',') and listlen(attributes.department_id,',') gte 1> OR</cfif>
                                        </cfloop>  
                                    )
                                )
                                </cfif>
                                <cfif len(trim(attributes.sup_company)) and len(attributes.sup_company_id)>
                                    AND S.COMPANY_ID = #attributes.sup_company_id#
                                </cfif>
                                <cfif len(trim(attributes.employee_name)) and len(attributes.product_employee_id)>
                                    AND S.PRODUCT_MANAGER = #attributes.product_employee_id#
                                </cfif>
                                <cfif len(trim(attributes.product_name)) and len(attributes.product_id)>
                                    AND S.PRODUCT_ID = #attributes.product_id#
                                </cfif>
                                <cfif len(trim(attributes.brand_name)) and len(attributes.brand_id)>
                                    AND S.BRAND_ID = #attributes.brand_id# 
                                </cfif>	
                                <cfif len(trim(attributes.product_cat)) and len(attributes.product_code)>
                                    AND S.STOCK_CODE LIKE '#attributes.product_code#%'
                                </cfif>
                            )AS GET_EXPENSE
                        WHERE
                            ISLEM_TARIHI >= #attributes.date#
                        GROUP BY
                            #ALAN_ADI#			
                        )AS donemici_masraf ON GET_ALL_STOCK.PRODUCT_GROUPBY_ID = donemici_masraf.GROUPBY_ALANI
		</cfif>
        <!---depo-lokasyon secili, islem tiplerinde de ambar fişi secili ise fişler ayrı bölümde gosterilir.--->
		<cfif len(attributes.department_id) and len(attributes.process_type) and listfind(attributes.process_type,18)>
        	LEFT JOIN(
                        SELECT 
                            SUM(STOCK_IN) AS AMBAR_FIS_GIRIS_MIKTARI,
                            SUM(STOCK_IN*MALIYET) AS AMBAR_FIS_GIRIS_MALIYETI,
                            <cfif isdefined('attributes.is_system_money_2')>
                            SUM(STOCK_IN*MALIYET_2) AS AMBAR_FIS_GIRIS_MALIYETI_2,
                            </cfif>
                            #ALAN_ADI# AS GROUPBY_ALANI
                        FROM
                            (
                                SELECT
                                    GC.PRODUCT_ID,
                                    GC.STOCK_ID,
                                    <cfif stock_table>
                                        S.PRODUCT_CATID,
                                        S.BRAND_ID,
                                    </cfif>
                                    SFR.AMOUNT,
                                    SF.DEPARTMENT_IN,
                                    SF.DEPARTMENT_OUT,
                                    SF.LOCATION_IN,
                                    SF.LOCATION_OUT,
                                    GC.STOCK_IN,
                                    GC.STOCK_OUT,
                                    ((GC.MALIYET_2*ABS(GC.STOCK_IN-GC.STOCK_OUT))) AS TOTAL_COST_2,
                                    (GC.MALIYET*ABS(GC.STOCK_IN-GC.STOCK_OUT)) AS TOTAL_COST,
                                    <cfif isdefined('attributes.is_system_money_2') or attributes.cost_money is not session.ep.money>
                                        <cfif isdefined('attributes.is_system_money_2')> <!--- sistem 2. para br. checkboxı işaretlenmişse, maliyet para br. olarak sadece sistem para br secilebilir --->
                                        GC.MALIYET MALIYET,
                                        GC.MALIYET_2 MALIYET_2,
                                        (SFR.AMOUNT*ISNULL(COST_PRICE,0)) AS TOTAL_COST_PRICE,<!--- uretimden giris fislerinde belge uzerindeki maliyet kullanılıyor --->
                                        (SFR.AMOUNT*ISNULL(EXTRA_COST,0)) AS TOTAL_EXTRA_COST,
                                        (SFR.AMOUNT*ISNULL(COST_PRICE,0))/(SF_M.RATE2/SF_M.RATE1) AS TOTAL_COST_PRICE_2,
                                        (SFR.AMOUNT*ISNULL(EXTRA_COST,0))/(SF_M.RATE2/SF_M.RATE1) AS TOTAL_EXTRA_COST_2,
                                        <cfelse>
                                        (GC.MALIYET/(SF_M.RATE2/SF_M.RATE1)) MALIYET,
                                        (SFR.AMOUNT*ISNULL(COST_PRICE,0)) AS TOTAL_COST_PRICE,
                                        (SFR.AMOUNT*ISNULL(EXTRA_COST,0)) AS TOTAL_EXTRA_COST,
                                        </cfif>
                                    <cfelse>
                                        (GC.MALIYET) MALIYET,
                                        (SFR.AMOUNT*ISNULL(COST_PRICE,0)) AS TOTAL_COST_PRICE,
                                        (SFR.AMOUNT*ISNULL(EXTRA_COST,0)) AS TOTAL_EXTRA_COST,
                                    </cfif>
                                    <cfif attributes.report_type eq 8>
                                    CAST(GC.STOCK_ID AS NVARCHAR(50)) +'_'+ CAST(ISNULL(GC.SPECT_VAR_ID,0) AS NVARCHAR(50)) STOCK_SPEC_ID,
                                    </cfif>
                                    SF.FIS_DATE ISLEM_TARIHI,
                                    SF.PROCESS_CAT,
                                    SF.FIS_TYPE PROCESS_TYPE,
                                    ISNULL(SF.PROD_ORDER_NUMBER,0) AS PROD_ORDER_NUMBER,
                                    ISNULL(SF.PROD_ORDER_RESULT_NUMBER,0) AS PROD_ORDER_RESULT_NUMBER
                                FROM 
                                    STOCK_FIS SF WITH (NOLOCK),
                                    STOCK_FIS_ROW SFR WITH (NOLOCK),
                                    <cfif isdefined('attributes.is_system_money_2') or attributes.cost_money is not session.ep.money>
                                    STOCK_FIS_MONEY SF_M,
                                    </cfif>
                                    <cfif is_store or isdefined("attributes.location_based_cost")>
                                        <cfif attributes.report_type eq 8>
                                            GET_STOCKS_ROW_COST_SPECT_LOCATION AS GC
                                        <cfelse>
                                            GET_STOCKS_ROW_COST_LOCATION AS GC
                                        </cfif>
                                    <cfelse>
                                        <cfif attributes.report_type eq 8>
                                            GET_STOCKS_ROW_COST_SPECT AS GC
                                        <cfelse>
                                            GET_STOCK_ROW_COST_TABLE AS GC
                                        </cfif>
                                    </cfif>
                                    <cfif stock_table>
                                    ,#dsn3_alias#.STOCKS S WITH (NOLOCK)
                                    </cfif>
                                WHERE 
                                    GC.UPD_ID = SF.FIS_ID AND
                                    SFR.FIS_ID=	SF.FIS_ID AND
                                    GC.PROCESS_TYPE = SF.FIS_TYPE AND
                                    <cfif stock_table>
                                    S.STOCK_ID = GC.STOCK_ID AND
                                    </cfif>
                                    GC.STOCK_ID=SFR.STOCK_ID AND
                                    SF.FIS_TYPE  IN (110,111,112,113,115,119) AND 
                                    SF.FIS_DATE >= #attributes.date# AND 
                                    SF.FIS_DATE <= #attributes.date2#
                                    <cfif isdefined('attributes.is_system_money_2') or attributes.cost_money is not session.ep.money>
                                         AND SF.FIS_ID = SF_M.ACTION_ID
                                        <cfif isdefined('attributes.is_system_money_2')>
                                         AND SF_M.MONEY_TYPE = '#session.ep.money2#'
                                        <cfelse>
                                         AND SF_M.MONEY_TYPE = '#attributes.cost_money#'
                                        </cfif>
                                    </cfif>
                                    <cfif len(attributes.department_id)>
                                    AND(
                                        (
                                            SF.DEPARTMENT_OUT IS NOT NULL AND
                                            <cfloop list="#attributes.department_id#" delimiters="," index="dept_i">
                                            (SF.DEPARTMENT_OUT = #listfirst(dept_i,'-')# AND SF.LOCATION_OUT = #listlast(dept_i,'-')#)
                                            <cfif dept_i neq listlast(attributes.department_id,',') and listlen(attributes.department_id,',') gte 1> OR</cfif>
                                            </cfloop>  
                                        )
                                    OR 
                                        (
                                            SF.DEPARTMENT_IN IS NOT NULL AND
                                            <cfloop list="#attributes.department_id#" delimiters="," index="dept_i">
                                            (SF.DEPARTMENT_IN  = #listfirst(dept_i,'-')# AND SF.LOCATION_IN = #listlast(dept_i,'-')#)
                                            <cfif dept_i neq listlast(attributes.department_id,',') and listlen(attributes.department_id,',') gte 1> OR</cfif>
                                            </cfloop>  
                                        )
                                    )
                                    <cfelseif is_store>
                                        AND (
                                                SF.DEPARTMENT_OUT IN (#branch_dep_list#) OR SF.DEPARTMENT_IN IN (#branch_dep_list#)
                                             )
                                    </cfif>
                                    <cfif len(trim(attributes.sup_company)) and len(attributes.sup_company_id)>
                                        AND S.COMPANY_ID = #attributes.sup_company_id#
                                    </cfif>
                                    <cfif len(trim(attributes.employee_name)) and len(attributes.product_employee_id)>
                                        AND S.PRODUCT_MANAGER = #attributes.product_employee_id#
                                    </cfif>
                                    <cfif len(trim(attributes.product_name)) and len(attributes.product_id)>
                                        AND S.PRODUCT_ID = #attributes.product_id#
                                    </cfif>
                                    <cfif len(trim(attributes.brand_name)) and len(attributes.brand_id)>
                                        AND S.BRAND_ID = #attributes.brand_id# 
                                    </cfif>	
                                    <cfif len(trim(attributes.product_cat)) and len(attributes.product_code)>
                                        AND S.STOCK_CODE LIKE '#attributes.product_code#%'
                                    </cfif>
                            )
                            AS GET_STOCK_FIS
                        WHERE
                            ISLEM_TARIHI <= #attributes.date2#
                            AND PROCESS_TYPE = 113
                            <cfif len(attributes.department_id)>
                            AND(
                                DEPARTMENT_IN IS NOT NULL AND
                                <cfloop list="#attributes.department_id#" delimiters="," index="dept_i">
                                (DEPARTMENT_IN  = #listfirst(dept_i,'-')# AND LOCATION_IN = #listlast(dept_i,'-')#)
                                <cfif dept_i neq listlast(attributes.department_id,',') and listlen(attributes.department_id,',') gte 1> OR</cfif>
                                </cfloop>  
                            )
                            </cfif>
                        GROUP BY
                            #ALAN_ADI#
                        )AS get_ambar_fis_total_in ON GET_ALL_STOCK.PRODUCT_GROUPBY_ID = get_ambar_fis_total_in.GROUPBY_ALANI
             LEFT JOIN(
                        SELECT 
                            SUM(STOCK_OUT) AS AMBAR_FIS_CIKIS_MIKTARI,
                            SUM(STOCK_OUT*MALIYET) AS AMBAR_FIS_CIKIS_MALIYET,
                            <cfif isdefined('attributes.is_system_money_2')>
                            SUM(STOCK_OUT*MALIYET_2) AS AMBAR_FIS_CIKIS_MALIYET_2,
                            </cfif>
                            #ALAN_ADI# AS GROUPBY_ALANI
                        FROM
                            (
                                SELECT
                                    GC.PRODUCT_ID,
                                    GC.STOCK_ID,
                                    <cfif stock_table>
                                        S.PRODUCT_CATID,
                                        S.BRAND_ID,
                                    </cfif>
                                    SFR.AMOUNT,
                                    SF.DEPARTMENT_IN,
                                    SF.DEPARTMENT_OUT,
                                    SF.LOCATION_IN,
                                    SF.LOCATION_OUT,
                                    GC.STOCK_IN,
                                    GC.STOCK_OUT,
                                    ((GC.MALIYET_2*ABS(GC.STOCK_IN-GC.STOCK_OUT))) AS TOTAL_COST_2,
                                    (GC.MALIYET*ABS(GC.STOCK_IN-GC.STOCK_OUT)) AS TOTAL_COST,
                                    <cfif isdefined('attributes.is_system_money_2') or attributes.cost_money is not session.ep.money>
                                        <cfif isdefined('attributes.is_system_money_2')> <!--- sistem 2. para br. checkboxı işaretlenmişse, maliyet para br. olarak sadece sistem para br secilebilir --->
                                        GC.MALIYET MALIYET,
                                        GC.MALIYET_2 MALIYET_2,
                                        (SFR.AMOUNT*ISNULL(COST_PRICE,0)) AS TOTAL_COST_PRICE,<!--- uretimden giris fislerinde belge uzerindeki maliyet kullanılıyor --->
                                        (SFR.AMOUNT*ISNULL(EXTRA_COST,0)) AS TOTAL_EXTRA_COST,
                                        (SFR.AMOUNT*ISNULL(COST_PRICE,0))/(SF_M.RATE2/SF_M.RATE1) AS TOTAL_COST_PRICE_2,
                                        (SFR.AMOUNT*ISNULL(EXTRA_COST,0))/(SF_M.RATE2/SF_M.RATE1) AS TOTAL_EXTRA_COST_2,
                                        <cfelse>
                                        (GC.MALIYET/(SF_M.RATE2/SF_M.RATE1)) MALIYET,
                                        (SFR.AMOUNT*ISNULL(COST_PRICE,0)) AS TOTAL_COST_PRICE,
                                        (SFR.AMOUNT*ISNULL(EXTRA_COST,0)) AS TOTAL_EXTRA_COST,
                                        </cfif>
                                    <cfelse>
                                        (GC.MALIYET) MALIYET,
                                        (SFR.AMOUNT*ISNULL(COST_PRICE,0)) AS TOTAL_COST_PRICE,
                                        (SFR.AMOUNT*ISNULL(EXTRA_COST,0)) AS TOTAL_EXTRA_COST,
                                    </cfif>
                                    <cfif attributes.report_type eq 8>
                                    CAST(GC.STOCK_ID AS NVARCHAR(50)) +'_'+ CAST(ISNULL(GC.SPECT_VAR_ID,0) AS NVARCHAR(50)) STOCK_SPEC_ID,
                                    </cfif>
                                    SF.FIS_DATE ISLEM_TARIHI,
                                    SF.PROCESS_CAT,
                                    SF.FIS_TYPE PROCESS_TYPE,
                                    ISNULL(SF.PROD_ORDER_NUMBER,0) AS PROD_ORDER_NUMBER,
                                    ISNULL(SF.PROD_ORDER_RESULT_NUMBER,0) AS PROD_ORDER_RESULT_NUMBER
                                FROM 
                                    STOCK_FIS SF WITH (NOLOCK),
                                    STOCK_FIS_ROW SFR WITH (NOLOCK),
                                    <cfif isdefined('attributes.is_system_money_2') or attributes.cost_money is not session.ep.money>
                                    STOCK_FIS_MONEY SF_M,
                                    </cfif>
                                    <cfif is_store or isdefined("attributes.location_based_cost")>
                                        <cfif attributes.report_type eq 8>
                                            GET_STOCKS_ROW_COST_SPECT_LOCATION AS GC
                                        <cfelse>
                                            GET_STOCKS_ROW_COST_LOCATION AS GC
                                        </cfif>
                                    <cfelse>
                                        <cfif attributes.report_type eq 8>
                                            GET_STOCKS_ROW_COST_SPECT AS GC
                                        <cfelse>
                                            GET_STOCK_ROW_COST_TABLE AS GC
                                        </cfif>
                                    </cfif>
                                    <cfif stock_table>
                                    ,#dsn3_alias#.STOCKS S WITH (NOLOCK)
                                    </cfif>
                                WHERE 
                                    GC.UPD_ID = SF.FIS_ID AND
                                    SFR.FIS_ID=	SF.FIS_ID AND
                                    GC.PROCESS_TYPE = SF.FIS_TYPE AND
                                    <cfif stock_table>
                                    S.STOCK_ID = GC.STOCK_ID AND
                                    </cfif>
                                    GC.STOCK_ID=SFR.STOCK_ID AND
                                    SF.FIS_TYPE  IN (110,111,112,113,115,119) AND 
                                    SF.FIS_DATE >= #attributes.date# AND 
                                    SF.FIS_DATE <= #attributes.date2#
                                    <cfif isdefined('attributes.is_system_money_2') or attributes.cost_money is not session.ep.money>
                                         AND SF.FIS_ID = SF_M.ACTION_ID
                                        <cfif isdefined('attributes.is_system_money_2')>
                                         AND SF_M.MONEY_TYPE = '#session.ep.money2#'
                                        <cfelse>
                                         AND SF_M.MONEY_TYPE = '#attributes.cost_money#'
                                        </cfif>
                                    </cfif>
                                    <cfif len(attributes.department_id)>
                                    AND(
                                        (
                                            SF.DEPARTMENT_OUT IS NOT NULL AND
                                            <cfloop list="#attributes.department_id#" delimiters="," index="dept_i">
                                            (SF.DEPARTMENT_OUT = #listfirst(dept_i,'-')# AND SF.LOCATION_OUT = #listlast(dept_i,'-')#)
                                            <cfif dept_i neq listlast(attributes.department_id,',') and listlen(attributes.department_id,',') gte 1> OR</cfif>
                                            </cfloop>  
                                        )
                                    OR 
                                        (
                                            SF.DEPARTMENT_IN IS NOT NULL AND
                                            <cfloop list="#attributes.department_id#" delimiters="," index="dept_i">
                                            (SF.DEPARTMENT_IN  = #listfirst(dept_i,'-')# AND SF.LOCATION_IN = #listlast(dept_i,'-')#)
                                            <cfif dept_i neq listlast(attributes.department_id,',') and listlen(attributes.department_id,',') gte 1> OR</cfif>
                                            </cfloop>  
                                        )
                                    )
                                    <cfelseif is_store>
                                        AND (
                                                SF.DEPARTMENT_OUT IN (#branch_dep_list#) OR SF.DEPARTMENT_IN IN (#branch_dep_list#)
                                             )
                                    </cfif>
                                    <cfif len(trim(attributes.sup_company)) and len(attributes.sup_company_id)>
                                        AND S.COMPANY_ID = #attributes.sup_company_id#
                                    </cfif>
                                    <cfif len(trim(attributes.employee_name)) and len(attributes.product_employee_id)>
                                        AND S.PRODUCT_MANAGER = #attributes.product_employee_id#
                                    </cfif>
                                    <cfif len(trim(attributes.product_name)) and len(attributes.product_id)>
                                        AND S.PRODUCT_ID = #attributes.product_id#
                                    </cfif>
                                    <cfif len(trim(attributes.brand_name)) and len(attributes.brand_id)>
                                        AND S.BRAND_ID = #attributes.brand_id# 
                                    </cfif>	
                                    <cfif len(trim(attributes.product_cat)) and len(attributes.product_code)>
                                        AND S.STOCK_CODE LIKE '#attributes.product_code#%'
                                    </cfif>
                            )
                            AS GET_STOCK_FIS
                        WHERE
                            ISLEM_TARIHI <= #attributes.date2#
                            AND PROCESS_TYPE = 113
                            <cfif len(attributes.department_id)>
                            AND(
                                DEPARTMENT_OUT IS NOT NULL AND
                                <cfloop list="#attributes.department_id#" delimiters="," index="dept_i">
                                (DEPARTMENT_OUT  = #listfirst(dept_i,'-')# AND LOCATION_OUT = #listlast(dept_i,'-')#)
                                <cfif dept_i neq listlast(attributes.department_id,',') and listlen(attributes.department_id,',') gte 1> OR</cfif>
                                </cfloop>  
                            )
                            </cfif>
                        GROUP BY
                            #ALAN_ADI#
			             )AS get_ambar_fis_total_out ON GET_ALL_STOCK.PRODUCT_GROUPBY_ID = get_ambar_fis_total_out.GROUPBY_ALANI
        </cfif>
        <!--- donemici sarf --->
		<cfif len(attributes.process_type) and listfind(attributes.process_type,5)>
        	<!--- uretimle ilgisi olmayan sarflar --->
            LEFT JOIN(																
                        SELECT	
                            SUM(AMOUNT) AS TOPLAM_SARF,
                            SUM(MALIYET*AMOUNT) AS SARF_MALIYET,
                            <cfif isdefined('attributes.is_system_money_2')>
                            SUM(MALIYET_2*AMOUNT) AS SARF_MALIYET_2,
                            </cfif>
                            #ALAN_ADI# AS GROUPBY_ALANI			
                        FROM
                            (
                                SELECT
                                    GC.PRODUCT_ID,
                                    GC.STOCK_ID,
                                    <cfif stock_table>
                                        S.PRODUCT_CATID,
                                        S.BRAND_ID,
                                    </cfif>
                                    SFR.AMOUNT,
                                    SF.DEPARTMENT_IN,
                                    SF.DEPARTMENT_OUT,
                                    SF.LOCATION_IN,
                                    SF.LOCATION_OUT,
                                    GC.STOCK_IN,
                                    GC.STOCK_OUT,
                                    ((GC.MALIYET_2*ABS(GC.STOCK_IN-GC.STOCK_OUT))) AS TOTAL_COST_2,
                                    (GC.MALIYET*ABS(GC.STOCK_IN-GC.STOCK_OUT)) AS TOTAL_COST,
                                    <cfif isdefined('attributes.is_system_money_2') or attributes.cost_money is not session.ep.money>
                                        <cfif isdefined('attributes.is_system_money_2')> <!--- sistem 2. para br. checkboxı işaretlenmişse, maliyet para br. olarak sadece sistem para br secilebilir --->
                                        GC.MALIYET MALIYET,
                                        GC.MALIYET_2 MALIYET_2,
                                        (SFR.AMOUNT*ISNULL(COST_PRICE,0)) AS TOTAL_COST_PRICE,<!--- uretimden giris fislerinde belge uzerindeki maliyet kullanılıyor --->
                                        (SFR.AMOUNT*ISNULL(EXTRA_COST,0)) AS TOTAL_EXTRA_COST,
                                        (SFR.AMOUNT*ISNULL(COST_PRICE,0))/(SF_M.RATE2/SF_M.RATE1) AS TOTAL_COST_PRICE_2,
                                        (SFR.AMOUNT*ISNULL(EXTRA_COST,0))/(SF_M.RATE2/SF_M.RATE1) AS TOTAL_EXTRA_COST_2,
                                        <cfelse>
                                        (GC.MALIYET/(SF_M.RATE2/SF_M.RATE1)) MALIYET,
                                        (SFR.AMOUNT*ISNULL(COST_PRICE,0)) AS TOTAL_COST_PRICE,
                                        (SFR.AMOUNT*ISNULL(EXTRA_COST,0)) AS TOTAL_EXTRA_COST,
                                        </cfif>
                                    <cfelse>
                                        (GC.MALIYET) MALIYET,
                                        (SFR.AMOUNT*ISNULL(COST_PRICE,0)) AS TOTAL_COST_PRICE,
                                        (SFR.AMOUNT*ISNULL(EXTRA_COST,0)) AS TOTAL_EXTRA_COST,
                                    </cfif>
                                    <cfif attributes.report_type eq 8>
                                    CAST(GC.STOCK_ID AS NVARCHAR(50)) +'_'+ CAST(ISNULL(GC.SPECT_VAR_ID,0) AS NVARCHAR(50)) STOCK_SPEC_ID,
                                    </cfif>
                                    SF.FIS_DATE ISLEM_TARIHI,
                                    SF.PROCESS_CAT,
                                    SF.FIS_TYPE PROCESS_TYPE,
                                    ISNULL(SF.PROD_ORDER_NUMBER,0) AS PROD_ORDER_NUMBER,
                                    ISNULL(SF.PROD_ORDER_RESULT_NUMBER,0) AS PROD_ORDER_RESULT_NUMBER
                                FROM 
                                    STOCK_FIS SF WITH (NOLOCK),
                                    STOCK_FIS_ROW SFR WITH (NOLOCK),
                                    <cfif isdefined('attributes.is_system_money_2') or attributes.cost_money is not session.ep.money>
                                    STOCK_FIS_MONEY SF_M,
                                    </cfif>
                                    <cfif is_store or isdefined("attributes.location_based_cost")>
                                        <cfif attributes.report_type eq 8>
                                            GET_STOCKS_ROW_COST_SPECT_LOCATION AS GC
                                        <cfelse>
                                            GET_STOCKS_ROW_COST_LOCATION AS GC
                                        </cfif>
                                    <cfelse>
                                        <cfif attributes.report_type eq 8>
                                            GET_STOCKS_ROW_COST_SPECT AS GC
                                        <cfelse>
                                            GET_STOCK_ROW_COST_TABLE AS GC
                                        </cfif>
                                    </cfif>
                                    <cfif stock_table>
                                    ,#dsn3_alias#.STOCKS S WITH (NOLOCK)
                                    </cfif>
                                WHERE 
                                    GC.UPD_ID = SF.FIS_ID AND
                                    SFR.FIS_ID=	SF.FIS_ID AND
                                    GC.PROCESS_TYPE = SF.FIS_TYPE AND
                                    <cfif stock_table>
                                    S.STOCK_ID = GC.STOCK_ID AND
                                    </cfif>
                                    GC.STOCK_ID=SFR.STOCK_ID AND
                                    SF.FIS_TYPE  IN (110,111,112,113,115,119) AND 
                                    SF.FIS_DATE >= #attributes.date# AND 
                                    SF.FIS_DATE <= #attributes.date2#
                                    <cfif isdefined('attributes.is_system_money_2') or attributes.cost_money is not session.ep.money>
                                         AND SF.FIS_ID = SF_M.ACTION_ID
                                        <cfif isdefined('attributes.is_system_money_2')>
                                         AND SF_M.MONEY_TYPE = '#session.ep.money2#'
                                        <cfelse>
                                         AND SF_M.MONEY_TYPE = '#attributes.cost_money#'
                                        </cfif>
                                    </cfif>
                                    <cfif len(attributes.department_id)>
                                    AND(
                                        (
                                            SF.DEPARTMENT_OUT IS NOT NULL AND
                                            <cfloop list="#attributes.department_id#" delimiters="," index="dept_i">
                                            (SF.DEPARTMENT_OUT = #listfirst(dept_i,'-')# AND SF.LOCATION_OUT = #listlast(dept_i,'-')#)
                                            <cfif dept_i neq listlast(attributes.department_id,',') and listlen(attributes.department_id,',') gte 1> OR</cfif>
                                            </cfloop>  
                                        )
                                    OR 
                                        (
                                            SF.DEPARTMENT_IN IS NOT NULL AND
                                            <cfloop list="#attributes.department_id#" delimiters="," index="dept_i">
                                            (SF.DEPARTMENT_IN  = #listfirst(dept_i,'-')# AND SF.LOCATION_IN = #listlast(dept_i,'-')#)
                                            <cfif dept_i neq listlast(attributes.department_id,',') and listlen(attributes.department_id,',') gte 1> OR</cfif>
                                            </cfloop>  
                                        )
                                    )
                                    <cfelseif is_store>
                                        AND (
                                                SF.DEPARTMENT_OUT IN (#branch_dep_list#) OR SF.DEPARTMENT_IN IN (#branch_dep_list#)
                                             )
                                    </cfif>
                                    <cfif len(trim(attributes.sup_company)) and len(attributes.sup_company_id)>
                                        AND S.COMPANY_ID = #attributes.sup_company_id#
                                    </cfif>
                                    <cfif len(trim(attributes.employee_name)) and len(attributes.product_employee_id)>
                                        AND S.PRODUCT_MANAGER = #attributes.product_employee_id#
                                    </cfif>
                                    <cfif len(trim(attributes.product_name)) and len(attributes.product_id)>
                                        AND S.PRODUCT_ID = #attributes.product_id#
                                    </cfif>
                                    <cfif len(trim(attributes.brand_name)) and len(attributes.brand_id)>
                                        AND S.BRAND_ID = #attributes.brand_id# 
                                    </cfif>	
                                    <cfif len(trim(attributes.product_cat)) and len(attributes.product_code)>
                                        AND S.STOCK_CODE LIKE '#attributes.product_code#%'
                                    </cfif>
                            )
                            AS GET_STOCK_FIS
                        WHERE
                            ISLEM_TARIHI >= #attributes.date#
                            AND PROCESS_TYPE = 111
                            <cfif isdefined('process_cat_list') and len(process_cat_list)>
                            AND PROCESS_CAT  IN (#process_cat_list#)
                            </cfif>
                            AND PROD_ORDER_NUMBER=0
                            AND PROD_ORDER_RESULT_NUMBER=0
                        GROUP BY
                            #ALAN_ADI#			
                        )AS donemici_sarf ON GET_ALL_STOCK.PRODUCT_GROUPBY_ID = donemici_sarf.GROUPBY_ALANI
         <!--- üretim sarfları--->
         LEFT JOIN(																						 
                    SELECT	
                        SUM(AMOUNT) AS TOPLAM_URETIM_SARF,
                        SUM(MALIYET*AMOUNT) AS URETIM_SARF_MALIYET,
                        <cfif isdefined('attributes.is_system_money_2')>
                        SUM(MALIYET_2*AMOUNT) AS URETIM_SARF_MALIYET_2,
                        </cfif>
                        #ALAN_ADI# AS GROUPBY_ALANI			
                    FROM
                        (
                                SELECT
                                    GC.PRODUCT_ID,
                                    GC.STOCK_ID,
                                    <cfif stock_table>
                                        S.PRODUCT_CATID,
                                        S.BRAND_ID,
                                    </cfif>
                                    SFR.AMOUNT,
                                    SF.DEPARTMENT_IN,
                                    SF.DEPARTMENT_OUT,
                                    SF.LOCATION_IN,
                                    SF.LOCATION_OUT,
                                    GC.STOCK_IN,
                                    GC.STOCK_OUT,
                                    ((GC.MALIYET_2*ABS(GC.STOCK_IN-GC.STOCK_OUT))) AS TOTAL_COST_2,
                                    (GC.MALIYET*ABS(GC.STOCK_IN-GC.STOCK_OUT)) AS TOTAL_COST,
                                    <cfif isdefined('attributes.is_system_money_2') or attributes.cost_money is not session.ep.money>
                                        <cfif isdefined('attributes.is_system_money_2')> <!--- sistem 2. para br. checkboxı işaretlenmişse, maliyet para br. olarak sadece sistem para br secilebilir --->
                                        GC.MALIYET MALIYET,
                                        GC.MALIYET_2 MALIYET_2,
                                        (SFR.AMOUNT*ISNULL(COST_PRICE,0)) AS TOTAL_COST_PRICE,<!--- uretimden giris fislerinde belge uzerindeki maliyet kullanılıyor --->
                                        (SFR.AMOUNT*ISNULL(EXTRA_COST,0)) AS TOTAL_EXTRA_COST,
                                        (SFR.AMOUNT*ISNULL(COST_PRICE,0))/(SF_M.RATE2/SF_M.RATE1) AS TOTAL_COST_PRICE_2,
                                        (SFR.AMOUNT*ISNULL(EXTRA_COST,0))/(SF_M.RATE2/SF_M.RATE1) AS TOTAL_EXTRA_COST_2,
                                        <cfelse>
                                        (GC.MALIYET/(SF_M.RATE2/SF_M.RATE1)) MALIYET,
                                        (SFR.AMOUNT*ISNULL(COST_PRICE,0)) AS TOTAL_COST_PRICE,
                                        (SFR.AMOUNT*ISNULL(EXTRA_COST,0)) AS TOTAL_EXTRA_COST,
                                        </cfif>
                                    <cfelse>
                                        (GC.MALIYET) MALIYET,
                                        (SFR.AMOUNT*ISNULL(COST_PRICE,0)) AS TOTAL_COST_PRICE,
                                        (SFR.AMOUNT*ISNULL(EXTRA_COST,0)) AS TOTAL_EXTRA_COST,
                                    </cfif>
                                    <cfif attributes.report_type eq 8>
                                    CAST(GC.STOCK_ID AS NVARCHAR(50)) +'_'+ CAST(ISNULL(GC.SPECT_VAR_ID,0) AS NVARCHAR(50)) STOCK_SPEC_ID,
                                    </cfif>
                                    SF.FIS_DATE ISLEM_TARIHI,
                                    SF.PROCESS_CAT,
                                    SF.FIS_TYPE PROCESS_TYPE,
                                    ISNULL(SF.PROD_ORDER_NUMBER,0) AS PROD_ORDER_NUMBER,
                                    ISNULL(SF.PROD_ORDER_RESULT_NUMBER,0) AS PROD_ORDER_RESULT_NUMBER
                                FROM 
                                    STOCK_FIS SF WITH (NOLOCK),
                                    STOCK_FIS_ROW SFR WITH (NOLOCK),
                                    <cfif isdefined('attributes.is_system_money_2') or attributes.cost_money is not session.ep.money>
                                    STOCK_FIS_MONEY SF_M,
                                    </cfif>
                                    <cfif is_store or isdefined("attributes.location_based_cost")>
                                        <cfif attributes.report_type eq 8>
                                            GET_STOCKS_ROW_COST_SPECT_LOCATION AS GC
                                        <cfelse>
                                            GET_STOCKS_ROW_COST_LOCATION AS GC
                                        </cfif>
                                    <cfelse>
                                        <cfif attributes.report_type eq 8>
                                            GET_STOCKS_ROW_COST_SPECT AS GC
                                        <cfelse>
                                            GET_STOCK_ROW_COST_TABLE AS GC
                                        </cfif>
                                    </cfif>
                                    <cfif stock_table>
                                    ,#dsn3_alias#.STOCKS S WITH (NOLOCK)
                                    </cfif>
                                WHERE 
                                    GC.UPD_ID = SF.FIS_ID AND
                                    SFR.FIS_ID=	SF.FIS_ID AND

                                    GC.PROCESS_TYPE = SF.FIS_TYPE AND
                                    <cfif stock_table>
                                    S.STOCK_ID = GC.STOCK_ID AND
                                    </cfif>
                                    GC.STOCK_ID=SFR.STOCK_ID AND
                                    SF.FIS_TYPE  IN (110,111,112,113,115,119) AND 
                                    SF.FIS_DATE >= #attributes.date# AND 
                                    SF.FIS_DATE <= #attributes.date2#
                                    <cfif isdefined('attributes.is_system_money_2') or attributes.cost_money is not session.ep.money>
                                         AND SF.FIS_ID = SF_M.ACTION_ID
                                        <cfif isdefined('attributes.is_system_money_2')>
                                         AND SF_M.MONEY_TYPE = '#session.ep.money2#'

                                        <cfelse>
                                         AND SF_M.MONEY_TYPE = '#attributes.cost_money#'
                                        </cfif>
                                    </cfif>
                                    <cfif len(attributes.department_id)>
                                    AND(
                                        (
                                            SF.DEPARTMENT_OUT IS NOT NULL AND
                                            <cfloop list="#attributes.department_id#" delimiters="," index="dept_i">
                                            (SF.DEPARTMENT_OUT = #listfirst(dept_i,'-')# AND SF.LOCATION_OUT = #listlast(dept_i,'-')#)
                                            <cfif dept_i neq listlast(attributes.department_id,',') and listlen(attributes.department_id,',') gte 1> OR</cfif>
                                            </cfloop>  
                                        )
                                    OR 
                                        (
                                            SF.DEPARTMENT_IN IS NOT NULL AND
                                            <cfloop list="#attributes.department_id#" delimiters="," index="dept_i">
                                            (SF.DEPARTMENT_IN  = #listfirst(dept_i,'-')# AND SF.LOCATION_IN = #listlast(dept_i,'-')#)
                                            <cfif dept_i neq listlast(attributes.department_id,',') and listlen(attributes.department_id,',') gte 1> OR</cfif>
                                            </cfloop>  
                                        )
                                    )
                                    <cfelseif is_store>
                                        AND (
                                                SF.DEPARTMENT_OUT IN (#branch_dep_list#) OR SF.DEPARTMENT_IN IN (#branch_dep_list#)
                                             )
                                    </cfif>
                                    <cfif len(trim(attributes.sup_company)) and len(attributes.sup_company_id)>
                                        AND S.COMPANY_ID = #attributes.sup_company_id#
                                    </cfif>
                                    <cfif len(trim(attributes.employee_name)) and len(attributes.product_employee_id)>
                                        AND S.PRODUCT_MANAGER = #attributes.product_employee_id#
                                    </cfif>
                                    <cfif len(trim(attributes.product_name)) and len(attributes.product_id)>
                                        AND S.PRODUCT_ID = #attributes.product_id#
                                    </cfif>
                                    <cfif len(trim(attributes.brand_name)) and len(attributes.brand_id)>
                                        AND S.BRAND_ID = #attributes.brand_id# 
                                    </cfif>	
                                    <cfif len(trim(attributes.product_cat)) and len(attributes.product_code)>
                                        AND S.STOCK_CODE LIKE '#attributes.product_code#%'
                                    </cfif>
                            )
                            AS GET_STOCK_FIS
                    WHERE
                        ISLEM_TARIHI >= #attributes.date#
                        AND PROCESS_TYPE = 111
                        <cfif isdefined('process_cat_list') and len(process_cat_list)>
                        AND PROCESS_CAT  IN (#process_cat_list#)
                        </cfif>
                        AND PROD_ORDER_NUMBER <> 0
                    GROUP BY
                        #ALAN_ADI#			
                    )AS donemici_production_sarf ON GET_ALL_STOCK.PRODUCT_GROUPBY_ID = donemici_production_sarf.GROUPBY_ALANI
			<!--- donemici fire --->
			LEFT JOIN(
                        SELECT	
                            SUM(AMOUNT) AS TOPLAM_FIRE,
                            SUM(MALIYET*AMOUNT) AS FIRE_MALIYET,
                            <cfif isdefined('attributes.is_system_money_2')>
                            SUM(MALIYET_2*AMOUNT) AS FIRE_MALIYET_2,
                            </cfif>
                            #ALAN_ADI# AS GROUPBY_ALANI			
                        FROM
                            (
                                SELECT
                                    GC.PRODUCT_ID,
                                    GC.STOCK_ID,
                                    <cfif stock_table>
                                        S.PRODUCT_CATID,
                                        S.BRAND_ID,
                                    </cfif>
                                    SFR.AMOUNT,
                                    SF.DEPARTMENT_IN,
                                    SF.DEPARTMENT_OUT,
                                    SF.LOCATION_IN,
                                    SF.LOCATION_OUT,
                                    GC.STOCK_IN,
                                    GC.STOCK_OUT,
                                    ((GC.MALIYET_2*ABS(GC.STOCK_IN-GC.STOCK_OUT))) AS TOTAL_COST_2,
                                    (GC.MALIYET*ABS(GC.STOCK_IN-GC.STOCK_OUT)) AS TOTAL_COST,
                                    <cfif isdefined('attributes.is_system_money_2') or attributes.cost_money is not session.ep.money>
                                        <cfif isdefined('attributes.is_system_money_2')> <!--- sistem 2. para br. checkboxı işaretlenmişse, maliyet para br. olarak sadece sistem para br secilebilir --->
                                        GC.MALIYET MALIYET,
                                        GC.MALIYET_2 MALIYET_2,
                                        (SFR.AMOUNT*ISNULL(COST_PRICE,0)) AS TOTAL_COST_PRICE,<!--- uretimden giris fislerinde belge uzerindeki maliyet kullanılıyor --->
                                        (SFR.AMOUNT*ISNULL(EXTRA_COST,0)) AS TOTAL_EXTRA_COST,
                                        (SFR.AMOUNT*ISNULL(COST_PRICE,0))/(SF_M.RATE2/SF_M.RATE1) AS TOTAL_COST_PRICE_2,
                                        (SFR.AMOUNT*ISNULL(EXTRA_COST,0))/(SF_M.RATE2/SF_M.RATE1) AS TOTAL_EXTRA_COST_2,
                                        <cfelse>
                                        (GC.MALIYET/(SF_M.RATE2/SF_M.RATE1)) MALIYET,
                                        (SFR.AMOUNT*ISNULL(COST_PRICE,0)) AS TOTAL_COST_PRICE,
                                        (SFR.AMOUNT*ISNULL(EXTRA_COST,0)) AS TOTAL_EXTRA_COST,
                                        </cfif>
                                    <cfelse>
                                        (GC.MALIYET) MALIYET,
                                        (SFR.AMOUNT*ISNULL(COST_PRICE,0)) AS TOTAL_COST_PRICE,
                                        (SFR.AMOUNT*ISNULL(EXTRA_COST,0)) AS TOTAL_EXTRA_COST,
                                    </cfif>
                                    <cfif attributes.report_type eq 8>
                                    CAST(GC.STOCK_ID AS NVARCHAR(50)) +'_'+ CAST(ISNULL(GC.SPECT_VAR_ID,0) AS NVARCHAR(50)) STOCK_SPEC_ID,
                                    </cfif>
                                    SF.FIS_DATE ISLEM_TARIHI,
                                    SF.PROCESS_CAT,
                                    SF.FIS_TYPE PROCESS_TYPE,
                                    ISNULL(SF.PROD_ORDER_NUMBER,0) AS PROD_ORDER_NUMBER,
                                    ISNULL(SF.PROD_ORDER_RESULT_NUMBER,0) AS PROD_ORDER_RESULT_NUMBER
                                FROM 
                                    STOCK_FIS SF WITH (NOLOCK),
                                    STOCK_FIS_ROW SFR WITH (NOLOCK),
                                    <cfif isdefined('attributes.is_system_money_2') or attributes.cost_money is not session.ep.money>
                                    STOCK_FIS_MONEY SF_M,
                                    </cfif>
                                    <cfif is_store or isdefined("attributes.location_based_cost")>
                                        <cfif attributes.report_type eq 8>
                                            GET_STOCKS_ROW_COST_SPECT_LOCATION AS GC
                                        <cfelse>
                                            GET_STOCKS_ROW_COST_LOCATION AS GC
                                        </cfif>
                                    <cfelse>
                                        <cfif attributes.report_type eq 8>
                                            GET_STOCKS_ROW_COST_SPECT AS GC
                                        <cfelse>
                                            GET_STOCK_ROW_COST_TABLE AS GC
                                        </cfif>
                                    </cfif>
                                    <cfif stock_table>
                                    ,#dsn3_alias#.STOCKS S WITH (NOLOCK)
                                    </cfif>
                                WHERE 
                                    GC.UPD_ID = SF.FIS_ID AND
                                    SFR.FIS_ID=	SF.FIS_ID AND
                                    GC.PROCESS_TYPE = SF.FIS_TYPE AND
                                    <cfif stock_table>
                                    S.STOCK_ID = GC.STOCK_ID AND
                                    </cfif>
                                    GC.STOCK_ID=SFR.STOCK_ID AND
                                    SF.FIS_TYPE  IN (110,111,112,113,115,119) AND 
                                    SF.FIS_DATE >= #attributes.date# AND 
                                    SF.FIS_DATE <= #attributes.date2#
                                    <cfif isdefined('attributes.is_system_money_2') or attributes.cost_money is not session.ep.money>
                                         AND SF.FIS_ID = SF_M.ACTION_ID
                                        <cfif isdefined('attributes.is_system_money_2')>
                                         AND SF_M.MONEY_TYPE = '#session.ep.money2#'
                                        <cfelse>
                                         AND SF_M.MONEY_TYPE = '#attributes.cost_money#'
                                        </cfif>
                                    </cfif>
                                    <cfif len(attributes.department_id)>
                                    AND(
                                        (
                                            SF.DEPARTMENT_OUT IS NOT NULL AND
                                            <cfloop list="#attributes.department_id#" delimiters="," index="dept_i">
                                            (SF.DEPARTMENT_OUT = #listfirst(dept_i,'-')# AND SF.LOCATION_OUT = #listlast(dept_i,'-')#)
                                            <cfif dept_i neq listlast(attributes.department_id,',') and listlen(attributes.department_id,',') gte 1> OR</cfif>
                                            </cfloop>  
                                        )
                                    OR 
                                        (
                                            SF.DEPARTMENT_IN IS NOT NULL AND
                                            <cfloop list="#attributes.department_id#" delimiters="," index="dept_i">
                                            (SF.DEPARTMENT_IN  = #listfirst(dept_i,'-')# AND SF.LOCATION_IN = #listlast(dept_i,'-')#)
                                            <cfif dept_i neq listlast(attributes.department_id,',') and listlen(attributes.department_id,',') gte 1> OR</cfif>
                                            </cfloop>  
                                        )
                                    )
                                    <cfelseif is_store>
                                        AND (
                                                SF.DEPARTMENT_OUT IN (#branch_dep_list#) OR SF.DEPARTMENT_IN IN (#branch_dep_list#)
                                             )
                                    </cfif>
                                    <cfif len(trim(attributes.sup_company)) and len(attributes.sup_company_id)>
                                        AND S.COMPANY_ID = #attributes.sup_company_id#
                                    </cfif>
                                    <cfif len(trim(attributes.employee_name)) and len(attributes.product_employee_id)>
                                        AND S.PRODUCT_MANAGER = #attributes.product_employee_id#
                                    </cfif>
                                    <cfif len(trim(attributes.product_name)) and len(attributes.product_id)>
                                        AND S.PRODUCT_ID = #attributes.product_id#
                                    </cfif>
                                    <cfif len(trim(attributes.brand_name)) and len(attributes.brand_id)>
                                        AND S.BRAND_ID = #attributes.brand_id# 
                                    </cfif>	
                                    <cfif len(trim(attributes.product_cat)) and len(attributes.product_code)>
                                        AND S.STOCK_CODE LIKE '#attributes.product_code#%'
                                    </cfif>
                            )
                            AS GET_STOCK_FIS
                        WHERE
                            ISLEM_TARIHI >=#attributes.date#
                            AND PROCESS_TYPE =112
                            <cfif isdefined('process_cat_list') and len(process_cat_list)>
                            AND PROCESS_CAT  IN (#process_cat_list#)
                            </cfif>
                        GROUP BY
                            #ALAN_ADI#			
                        )AS donemici_fire ON GET_ALL_STOCK.PRODUCT_GROUPBY_ID = donemici_fire.GROUPBY_ALANI                 
        </cfif>
        <!--- demontajdan giris --->
		<cfif len(attributes.process_type) and listfind(attributes.process_type,14)>
			LEFT JOIN(
                        SELECT	
                            SUM(AMOUNT) AS DEMONTAJ_GIRIS,
                            SUM(MALIYET*AMOUNT) AS DEMONTAJ_GIRIS_MALIYET,
                            <cfif isdefined('attributes.is_system_money_2')>
                            SUM(MALIYET_2*AMOUNT) AS DEMONTAJ_GIRIS_MALIYET_2,
                            </cfif>
                            #ALAN_ADI# AS GROUPBY_ALANI			
                        FROM
                            (
                                SELECT
                                    GC.PRODUCT_ID,
                                    GC.STOCK_ID,
                                    <cfif stock_table>
                                        S.PRODUCT_CATID,
                                        S.BRAND_ID,
                                    </cfif>
                                    SFR.AMOUNT,
                                    SF.DEPARTMENT_IN,
                                    SF.DEPARTMENT_OUT,
                                    SF.LOCATION_IN,
                                    SF.LOCATION_OUT,
                                    GC.STOCK_IN,
                                    GC.STOCK_OUT,
                                    ((GC.MALIYET_2*ABS(GC.STOCK_IN-GC.STOCK_OUT))) AS TOTAL_COST_2,
                                    (GC.MALIYET*ABS(GC.STOCK_IN-GC.STOCK_OUT)) AS TOTAL_COST,
                                    <cfif isdefined('attributes.is_system_money_2') or attributes.cost_money is not session.ep.money>
                                        <cfif isdefined('attributes.is_system_money_2')> <!--- sistem 2. para br. checkboxı işaretlenmişse, maliyet para br. olarak sadece sistem para br secilebilir --->
                                        GC.MALIYET MALIYET,
                                        GC.MALIYET_2 MALIYET_2,
                                        (SFR.AMOUNT*ISNULL(COST_PRICE,0)) AS TOTAL_COST_PRICE,<!--- uretimden giris fislerinde belge uzerindeki maliyet kullanılıyor --->
                                        (SFR.AMOUNT*ISNULL(EXTRA_COST,0)) AS TOTAL_EXTRA_COST,
                                        (SFR.AMOUNT*ISNULL(COST_PRICE,0))/(SF_M.RATE2/SF_M.RATE1) AS TOTAL_COST_PRICE_2,
                                        (SFR.AMOUNT*ISNULL(EXTRA_COST,0))/(SF_M.RATE2/SF_M.RATE1) AS TOTAL_EXTRA_COST_2,
                                        <cfelse>
                                        (GC.MALIYET/(SF_M.RATE2/SF_M.RATE1)) MALIYET,
                                        (SFR.AMOUNT*ISNULL(COST_PRICE,0)) AS TOTAL_COST_PRICE,
                                        (SFR.AMOUNT*ISNULL(EXTRA_COST,0)) AS TOTAL_EXTRA_COST,
                                        </cfif>
                                    <cfelse>
                                        (GC.MALIYET) MALIYET,
                                        (SFR.AMOUNT*ISNULL(COST_PRICE,0)) AS TOTAL_COST_PRICE,
                                        (SFR.AMOUNT*ISNULL(EXTRA_COST,0)) AS TOTAL_EXTRA_COST,
                                    </cfif>
                                    <cfif attributes.report_type eq 8>
                                    CAST(GC.STOCK_ID AS NVARCHAR(50)) +'_'+ CAST(ISNULL(GC.SPECT_VAR_ID,0) AS NVARCHAR(50)) STOCK_SPEC_ID,
                                    </cfif>
                                    SF.FIS_DATE ISLEM_TARIHI,
                                    SF.PROCESS_CAT,
                                    SF.FIS_TYPE PROCESS_TYPE,
                                    ISNULL(SF.PROD_ORDER_NUMBER,0) AS PROD_ORDER_NUMBER,
                                    ISNULL(SF.PROD_ORDER_RESULT_NUMBER,0) AS PROD_ORDER_RESULT_NUMBER
                                FROM 
                                    STOCK_FIS SF WITH (NOLOCK),
                                    STOCK_FIS_ROW SFR WITH (NOLOCK),
                                    <cfif isdefined('attributes.is_system_money_2') or attributes.cost_money is not session.ep.money>
                                    STOCK_FIS_MONEY SF_M,
                                    </cfif>
                                    <cfif is_store or isdefined("attributes.location_based_cost")>
                                        <cfif attributes.report_type eq 8>
                                            GET_STOCKS_ROW_COST_SPECT_LOCATION AS GC
                                        <cfelse>
                                            GET_STOCKS_ROW_COST_LOCATION AS GC
                                        </cfif>
                                    <cfelse>
                                        <cfif attributes.report_type eq 8>
                                            GET_STOCKS_ROW_COST_SPECT AS GC
                                        <cfelse>
                                            GET_STOCK_ROW_COST_TABLE AS GC
                                        </cfif>
                                    </cfif>
                                    <cfif stock_table>
                                    ,#dsn3_alias#.STOCKS S WITH (NOLOCK)
                                    </cfif>
                                WHERE 
                                    GC.UPD_ID = SF.FIS_ID AND
                                    SFR.FIS_ID=	SF.FIS_ID AND
                                    GC.PROCESS_TYPE = SF.FIS_TYPE AND
                                    <cfif stock_table>
                                    S.STOCK_ID = GC.STOCK_ID AND
                                    </cfif>
                                    GC.STOCK_ID=SFR.STOCK_ID AND
                                    SF.FIS_TYPE  IN (110,111,112,113,115,119) AND 
                                    SF.FIS_DATE >= #attributes.date# AND 
                                    SF.FIS_DATE <= #attributes.date2#
                                    <cfif isdefined('attributes.is_system_money_2') or attributes.cost_money is not session.ep.money>
                                         AND SF.FIS_ID = SF_M.ACTION_ID
                                        <cfif isdefined('attributes.is_system_money_2')>
                                         AND SF_M.MONEY_TYPE = '#session.ep.money2#'
                                        <cfelse>
                                         AND SF_M.MONEY_TYPE = '#attributes.cost_money#'
                                        </cfif>
                                    </cfif>
                                    <cfif len(attributes.department_id)>
                                    AND(
                                        (
                                            SF.DEPARTMENT_OUT IS NOT NULL AND
                                            <cfloop list="#attributes.department_id#" delimiters="," index="dept_i">
                                            (SF.DEPARTMENT_OUT = #listfirst(dept_i,'-')# AND SF.LOCATION_OUT = #listlast(dept_i,'-')#)
                                            <cfif dept_i neq listlast(attributes.department_id,',') and listlen(attributes.department_id,',') gte 1> OR</cfif>
                                            </cfloop>  
                                        )
                                    OR 
                                        (
                                            SF.DEPARTMENT_IN IS NOT NULL AND
                                            <cfloop list="#attributes.department_id#" delimiters="," index="dept_i">
                                            (SF.DEPARTMENT_IN  = #listfirst(dept_i,'-')# AND SF.LOCATION_IN = #listlast(dept_i,'-')#)
                                            <cfif dept_i neq listlast(attributes.department_id,',') and listlen(attributes.department_id,',') gte 1> OR</cfif>
                                            </cfloop>  
                                        )
                                    )
                                    <cfelseif is_store>
                                        AND (
                                                SF.DEPARTMENT_OUT IN (#branch_dep_list#) OR SF.DEPARTMENT_IN IN (#branch_dep_list#)
                                             )
                                    </cfif>
                                    <cfif len(trim(attributes.sup_company)) and len(attributes.sup_company_id)>
                                        AND S.COMPANY_ID = #attributes.sup_company_id#
                                    </cfif>
                                    <cfif len(trim(attributes.employee_name)) and len(attributes.product_employee_id)>
                                        AND S.PRODUCT_MANAGER = #attributes.product_employee_id#
                                    </cfif>
                                    <cfif len(trim(attributes.product_name)) and len(attributes.product_id)>
                                        AND S.PRODUCT_ID = #attributes.product_id#
                                    </cfif>
                                    <cfif len(trim(attributes.brand_name)) and len(attributes.brand_id)>
                                        AND S.BRAND_ID = #attributes.brand_id# 
                                    </cfif>	
                                    <cfif len(trim(attributes.product_cat)) and len(attributes.product_code)>
                                        AND S.STOCK_CODE LIKE '#attributes.product_code#%'
                                    </cfif>
                            )
                            AS GET_STOCK_FIS
                        WHERE
                            ISLEM_TARIHI >= #attributes.date#
                            AND PROCESS_TYPE = 119
                            <cfif isdefined('process_cat_list') and len(process_cat_list)>
                            AND PROCESS_CAT  IN (#process_cat_list#)
                            </cfif>
                        GROUP BY
                            #ALAN_ADI#			
				)AS donemici_demontaj_giris ON GET_ALL_STOCK.PRODUCT_GROUPBY_ID = donemici_demontaj_giris.GROUPBY_ALANI
		</cfif>
        <!--- demontaja giden --->
		<cfif len(attributes.process_type) and listfind(attributes.process_type,13)>
			LEFT JOIN(
                        SELECT	
                            (SUM(STOCK_IN)-SUM(STOCK_OUT)) AS DEMONTAJ_GIDEN,
                            SUM((STOCK_IN-STOCK_OUT)*MALIYET) AS DEMONTAJ_GIDEN_MALIYET,
                            <cfif isdefined('attributes.is_system_money_2')>
                            SUM((STOCK_IN-STOCK_OUT)*MALIYET_2) AS DEMONTAJ_GIDEN_MALIYET_2,
                            </cfif>
                            #ALAN_ADI# AS GROUPBY_ALANI			
                        FROM
                            (
                            SELECT
                                GC.PRODUCT_ID,
                                GC.STOCK_ID,
                                <cfif stock_table>
                                S.PRODUCT_CATID,
                                S.BRAND_ID,
                                </cfif>
                                GC.STOCK_IN,
                                GC.STOCK_OUT,
                                <cfif isdefined('attributes.is_system_money_2') or attributes.cost_money is not session.ep.money>
                                    <cfif isdefined('attributes.is_system_money_2')>
                                    GC.MALIYET MALIYET,
                                    GC.MALIYET_2 MALIYET_2,
                                    <cfelse>
                                    (GC.MALIYET/(SF_M.RATE2/SF_M.RATE1)) MALIYET,
                                    </cfif>
                                <cfelse>
                                    (GC.MALIYET) MALIYET,
                                </cfif>
                                <cfif attributes.report_type eq 8>
                                CAST(GC.STOCK_ID AS NVARCHAR(50)) +'_'+ CAST(ISNULL(GC.SPECT_VAR_ID,0) AS NVARCHAR(50)) STOCK_SPEC_ID,
                                </cfif>
                                SF.FIS_DATE ISLEM_TARIHI,
                                SF.FIS_TYPE PROCESS_TYPE
                            FROM 
                                STOCK_FIS SF,
                                <cfif isdefined('attributes.is_system_money_2') or attributes.cost_money is not session.ep.money>
                                STOCK_FIS_MONEY SF_M,
                                </cfif>
                                 <cfif is_store>
                                    <cfif attributes.report_type eq 8>
                                        GET_STOCKS_ROW_COST_SPECT_LOCATION AS GC,
                                    <cfelse>
                                        GET_STOCKS_ROW_COST_LOCATION AS GC,
                                    </cfif>
                                <cfelse>
                                    <cfif attributes.report_type eq 8>
                                        GET_STOCKS_ROW_COST_SPECT AS GC,
                                    <cfelse>
                                        GET_STOCK_ROW_COST_TABLE AS GC,
                                    </cfif>
                                </cfif>
                                #dsn3_alias#.PRODUCTION_ORDERS PO
                                <cfif stock_table>
                                ,#dsn3_alias#.STOCKS S
                                </cfif>
                            WHERE 
                                GC.UPD_ID = SF.FIS_ID AND
                                GC.PROCESS_TYPE = SF.FIS_TYPE AND
                                SF.PROD_ORDER_NUMBER = PO.P_ORDER_ID AND
                                SF.PROD_ORDER_NUMBER IS NOT NULL AND
                                PO.IS_DEMONTAJ = 1 AND 
                                <cfif stock_table>
                                S.STOCK_ID = GC.STOCK_ID AND
                                </cfif>
                                SF.FIS_TYPE =111 AND 
                                SF.FIS_DATE >= #attributes.date# AND 
                                SF.FIS_DATE <= #attributes.date2#
                                <cfif isdefined('attributes.is_system_money_2') or attributes.cost_money is not session.ep.money>
                                     AND SF.FIS_ID = SF_M.ACTION_ID
                                    <cfif isdefined('attributes.is_system_money_2')>
                                     AND SF_M.MONEY_TYPE = '#session.ep.money2#'
                                    <cfelse>
                                    AND SF_M.MONEY_TYPE = '#attributes.cost_money#'
                                    </cfif>
                                </cfif>
                                <cfif len(attributes.department_id)>
                                    AND(
                                        (
                                            SF.DEPARTMENT_OUT IS NOT NULL AND
                                            <cfloop list="#attributes.department_id#" delimiters="," index="dept_i">
                                            (SF.DEPARTMENT_OUT = #listfirst(dept_i,'-')# AND SF.LOCATION_OUT = #listlast(dept_i,'-')#)
                                            <cfif dept_i neq listlast(attributes.department_id,',') and listlen(attributes.department_id,',') gte 1> OR</cfif>
                                            </cfloop>  
                                        )
                                    OR 
                                        (
                                            SF.DEPARTMENT_IN IS NOT NULL AND
                                            <cfloop list="#attributes.department_id#" delimiters="," index="dept_i">
                                            (SF.DEPARTMENT_IN  = #listfirst(dept_i,'-')# AND SF.LOCATION_IN = #listlast(dept_i,'-')#)
                                            <cfif dept_i neq listlast(attributes.department_id,',') and listlen(attributes.department_id,',') gte 1> OR</cfif>
                                            </cfloop>  
                                        )
                                    )
                                <cfelseif is_store>
                                    AND (
                                            SF.DEPARTMENT_OUT IN (#branch_dep_list#) OR SF.DEPARTMENT_IN IN (#branch_dep_list#)
                                         )
                                </cfif>
                                <cfif len(trim(attributes.sup_company)) and len(attributes.sup_company_id)>
                                    AND S.COMPANY_ID = #attributes.sup_company_id#
                                </cfif>
                                <cfif len(trim(attributes.employee_name)) and len(attributes.product_employee_id)>
                                    AND S.PRODUCT_MANAGER = #attributes.product_employee_id#
                                </cfif>
                                <cfif len(trim(attributes.product_name)) and len(attributes.product_id)>
                                    AND S.PRODUCT_ID = #attributes.product_id#
                                </cfif>
                                <cfif len(trim(attributes.brand_name)) and len(attributes.brand_id)>
                                    AND S.BRAND_ID = #attributes.brand_id# 
                                </cfif>	
                                <cfif len(trim(attributes.product_cat)) and len(attributes.product_code)>
                                    AND S.STOCK_CODE LIKE '#attributes.product_code#%'
                                </cfif>
                            )AS GET_DEMONTAJ
                        WHERE
                            ISLEM_TARIHI >= #attributes.date#
                        GROUP BY
                            #ALAN_ADI#			
                        )AS demontaj_giden ON GET_ALL_STOCK.PRODUCT_GROUPBY_ID = demontaj_giden.GROUPBY_ALANI
		</cfif>
        <!--- Sayım fişleri --->
		<cfif len(attributes.process_type) and listfind(attributes.process_type,12)>
			LEFT JOIN(
				SELECT
					SUM(AMOUNT) AS TOPLAM_SAYIM,
					SUM(MALIYET*AMOUNT) AS SAYIM_MALIYET,
					<cfif isdefined('attributes.is_system_money_2')>
					SUM(MALIYET_2*AMOUNT) AS SAYIM_MALIYET_2,
					</cfif>
					#ALAN_ADI# AS GROUPBY_ALANI			
				FROM
					(
                                SELECT
                                    GC.PRODUCT_ID,
                                    GC.STOCK_ID,
                                    <cfif stock_table>
                                        S.PRODUCT_CATID,
                                        S.BRAND_ID,
                                    </cfif>
                                    SFR.AMOUNT,
                                    SF.DEPARTMENT_IN,
                                    SF.DEPARTMENT_OUT,
                                    SF.LOCATION_IN,
                                    SF.LOCATION_OUT,
                                    GC.STOCK_IN,
                                    GC.STOCK_OUT,
                                    ((GC.MALIYET_2*ABS(GC.STOCK_IN-GC.STOCK_OUT))) AS TOTAL_COST_2,
                                    (GC.MALIYET*ABS(GC.STOCK_IN-GC.STOCK_OUT)) AS TOTAL_COST,
                                    <cfif isdefined('attributes.is_system_money_2') or attributes.cost_money is not session.ep.money>
                                        <cfif isdefined('attributes.is_system_money_2')> <!--- sistem 2. para br. checkboxı işaretlenmişse, maliyet para br. olarak sadece sistem para br secilebilir --->
                                        GC.MALIYET MALIYET,
                                        GC.MALIYET_2 MALIYET_2,
                                        (SFR.AMOUNT*ISNULL(COST_PRICE,0)) AS TOTAL_COST_PRICE,<!--- uretimden giris fislerinde belge uzerindeki maliyet kullanılıyor --->
                                        (SFR.AMOUNT*ISNULL(EXTRA_COST,0)) AS TOTAL_EXTRA_COST,
                                        (SFR.AMOUNT*ISNULL(COST_PRICE,0))/(SF_M.RATE2/SF_M.RATE1) AS TOTAL_COST_PRICE_2,
                                        (SFR.AMOUNT*ISNULL(EXTRA_COST,0))/(SF_M.RATE2/SF_M.RATE1) AS TOTAL_EXTRA_COST_2,
                                        <cfelse>
                                        (GC.MALIYET/(SF_M.RATE2/SF_M.RATE1)) MALIYET,
                                        (SFR.AMOUNT*ISNULL(COST_PRICE,0)) AS TOTAL_COST_PRICE,
                                        (SFR.AMOUNT*ISNULL(EXTRA_COST,0)) AS TOTAL_EXTRA_COST,
                                        </cfif>
                                    <cfelse>
                                        (GC.MALIYET) MALIYET,
                                        (SFR.AMOUNT*ISNULL(COST_PRICE,0)) AS TOTAL_COST_PRICE,
                                        (SFR.AMOUNT*ISNULL(EXTRA_COST,0)) AS TOTAL_EXTRA_COST,
                                    </cfif>
                                    <cfif attributes.report_type eq 8>
                                    CAST(GC.STOCK_ID AS NVARCHAR(50)) +'_'+ CAST(ISNULL(GC.SPECT_VAR_ID,0) AS NVARCHAR(50)) STOCK_SPEC_ID,
                                    </cfif>
                                    SF.FIS_DATE ISLEM_TARIHI,
                                    SF.PROCESS_CAT,
                                    SF.FIS_TYPE PROCESS_TYPE,
                                    ISNULL(SF.PROD_ORDER_NUMBER,0) AS PROD_ORDER_NUMBER,
                                    ISNULL(SF.PROD_ORDER_RESULT_NUMBER,0) AS PROD_ORDER_RESULT_NUMBER
                                FROM 
                                    STOCK_FIS SF WITH (NOLOCK),
                                    STOCK_FIS_ROW SFR WITH (NOLOCK),
                                    <cfif isdefined('attributes.is_system_money_2') or attributes.cost_money is not session.ep.money>
                                    STOCK_FIS_MONEY SF_M,
                                    </cfif>
                                    <cfif is_store or isdefined("attributes.location_based_cost")>
                                        <cfif attributes.report_type eq 8>
                                            GET_STOCKS_ROW_COST_SPECT_LOCATION AS GC
                                        <cfelse>
                                            GET_STOCKS_ROW_COST_LOCATION AS GC
                                        </cfif>
                                    <cfelse>
                                        <cfif attributes.report_type eq 8>
                                            GET_STOCKS_ROW_COST_SPECT AS GC
                                        <cfelse>
                                            GET_STOCK_ROW_COST_TABLE AS GC
                                        </cfif>
                                    </cfif>
                                    <cfif stock_table>
                                    ,#dsn3_alias#.STOCKS S WITH (NOLOCK)
                                    </cfif>
                                WHERE 
                                    GC.UPD_ID = SF.FIS_ID AND
                                    SFR.FIS_ID=	SF.FIS_ID AND
                                    GC.PROCESS_TYPE = SF.FIS_TYPE AND
                                    <cfif stock_table>
                                    S.STOCK_ID = GC.STOCK_ID AND
                                    </cfif>
                                    GC.STOCK_ID=SFR.STOCK_ID AND
                                    SF.FIS_TYPE  IN (110,111,112,113,115,119) AND 
                                    SF.FIS_DATE >= #attributes.date# AND 
                                    SF.FIS_DATE <= #attributes.date2#
                                    <cfif isdefined('attributes.is_system_money_2') or attributes.cost_money is not session.ep.money>
                                         AND SF.FIS_ID = SF_M.ACTION_ID
                                        <cfif isdefined('attributes.is_system_money_2')>
                                         AND SF_M.MONEY_TYPE = '#session.ep.money2#'
                                        <cfelse>
                                         AND SF_M.MONEY_TYPE = '#attributes.cost_money#'
                                        </cfif>
                                    </cfif>
                                    <cfif len(attributes.department_id)>
                                    AND(
                                        (
                                            SF.DEPARTMENT_OUT IS NOT NULL AND
                                            <cfloop list="#attributes.department_id#" delimiters="," index="dept_i">
                                            (SF.DEPARTMENT_OUT = #listfirst(dept_i,'-')# AND SF.LOCATION_OUT = #listlast(dept_i,'-')#)
                                            <cfif dept_i neq listlast(attributes.department_id,',') and listlen(attributes.department_id,',') gte 1> OR</cfif>
                                            </cfloop>  
                                        )
                                    OR 
                                        (
                                            SF.DEPARTMENT_IN IS NOT NULL AND
                                            <cfloop list="#attributes.department_id#" delimiters="," index="dept_i">
                                            (SF.DEPARTMENT_IN  = #listfirst(dept_i,'-')# AND SF.LOCATION_IN = #listlast(dept_i,'-')#)
                                            <cfif dept_i neq listlast(attributes.department_id,',') and listlen(attributes.department_id,',') gte 1> OR</cfif>
                                            </cfloop>  
                                        )
                                    )
                                    <cfelseif is_store>
                                        AND (
                                                SF.DEPARTMENT_OUT IN (#branch_dep_list#) OR SF.DEPARTMENT_IN IN (#branch_dep_list#)
                                             )
                                    </cfif>
                                    <cfif len(trim(attributes.sup_company)) and len(attributes.sup_company_id)>
                                        AND S.COMPANY_ID = #attributes.sup_company_id#
                                    </cfif>
                                    <cfif len(trim(attributes.employee_name)) and len(attributes.product_employee_id)>
                                        AND S.PRODUCT_MANAGER = #attributes.product_employee_id#
                                    </cfif>
                                    <cfif len(trim(attributes.product_name)) and len(attributes.product_id)>
                                        AND S.PRODUCT_ID = #attributes.product_id#
                                    </cfif>
                                    <cfif len(trim(attributes.brand_name)) and len(attributes.brand_id)>
                                        AND S.BRAND_ID = #attributes.brand_id# 
                                    </cfif>	
                                    <cfif len(trim(attributes.product_cat)) and len(attributes.product_code)>
                                        AND S.STOCK_CODE LIKE '#attributes.product_code#%'
                                    </cfif>
                            )
                            AS GET_STOCK_FIS
				WHERE
					ISLEM_TARIHI >= #attributes.date#
					AND PROCESS_TYPE =115
				GROUP BY
					#ALAN_ADI#			
				)AS donemici_sayim ON GET_ALL_STOCK.PRODUCT_GROUPBY_ID = donemici_sayim.GROUPBY_ALANI
                
		</cfif>
    </cfif>
</cfif>
	<cfif isdefined('attributes.stock_age')>
			LEFT JOIN 	
                    (
                        SELECT 
                            IR.STOCK_ID,
                            IR.PRODUCT_ID,
                            <cfif attributes.report_type eq 8>
                                CAST(IR.STOCK_ID AS NVARCHAR(50)) +'_'+ CAST(ISNULL((SELECT SPECT_MAIN_ID FROM #dsn3_alias#.SPECTS SP WHERE SP.SPECT_VAR_ID = IR.SPECT_VAR_ID),0) AS NVARCHAR(50))  STOCK_SPEC_ID,
                            </cfif>
                            IR.AMOUNT,
                            ISNULL(I.DELIVER_DATE,I.SHIP_DATE) AS ISLEM_TARIHI,
                            ISNULL(DATEDIFF(day,I.DELIVER_DATE,#attributes.date2#),DATEDIFF(day,I.SHIP_DATE,#attributes.date2#))  AS GUN_FARKI,
                            I.DEPARTMENT_IN,
                            I.LOCATION_IN,
                            S.BRAND_ID,
                            S.PRODUCT_CATID,
                            S.PRODUCT_MANAGER
                        FROM 
                            SHIP I WITH (NOLOCK),
                            SHIP_ROW IR WITH (NOLOCK),
                            #dsn3_alias#.STOCKS S
                        WHERE 
                            I.SHIP_ID = IR.SHIP_ID AND
                            S.STOCK_ID=IR.STOCK_ID AND	
                            <cfif len(attributes.department_id)><!--- depo varsa depolar arası sevk VE ithal mal girisine bak --->
                                I.SHIP_TYPE IN (76,81,811,87) AND
                            <cfelse>
                                I.SHIP_TYPE IN(76,87) AND
                            </cfif>
                            I.IS_SHIP_IPTAL = 0 AND
                            <!--- I.SHIP_DATE >= #attributes.date# AND  --->
                            I.SHIP_DATE <= #attributes.date2#
                            <cfif len(attributes.department_id)>
                            AND
                                (
                                <cfloop list="#attributes.department_id#" delimiters="," index="dept_i">
                                (I.DEPARTMENT_IN = #listfirst(dept_i,'-')# AND I.LOCATION_IN = #listlast(dept_i,'-')#)
                                <cfif dept_i neq listlast(attributes.department_id,',') and listlen(attributes.department_id,',') gte 1> OR</cfif>
                                </cfloop>  
                                )
                            <cfelseif is_store>
                                AND I.DEPARTMENT_IN IN (#branch_dep_list#)
                            </cfif>
                            <cfif len(trim(attributes.employee_name)) and len(attributes.product_employee_id)>
                                AND S.PRODUCT_MANAGER = #attributes.product_employee_id#
                            </cfif>
                            <cfif len(trim(attributes.product_name)) and len(attributes.product_id)>
                                AND S.PRODUCT_ID = #attributes.product_id#
                            </cfif>
                            <cfif len(trim(attributes.brand_name)) and len(attributes.brand_id)>
                                AND S.BRAND_ID = #attributes.brand_id# 
                            </cfif>	
                            <cfif len(trim(attributes.product_cat)) and len(attributes.product_code)>
                                AND S.STOCK_CODE LIKE '#attributes.product_code#%'
                            </cfif>
                    UNION ALL
                        SELECT 
                            IR.STOCK_ID,
                            S.PRODUCT_ID,
                            <cfif attributes.report_type eq 8>
                                CAST(IR.STOCK_ID AS NVARCHAR(50)) +'_'+ CAST(ISNULL((SELECT SPECT_MAIN_ID FROM #dsn3_alias#.SPECTS SP WHERE SP.SPECT_VAR_ID = IR.SPECT_VAR_ID),0) AS NVARCHAR(50))  STOCK_SPEC_ID,
                            </cfif>
                            IR.AMOUNT,
                            I.FIS_DATE ISLEM_TARIHI,
                            <!--- ISNULL(DATEDIFF(day,DATEADD(day,-1*DUE_DATE,FIS_DATE),#attributes.date2#),DATEDIFF(day,FIS_DATE,#attributes.date2#)) AS GUN_FARKI, --->
							DATEDIFF(day,FIS_DATE,#attributes.date2#) + ISNULL(DUE_DATE,0) GUN_FARKI,
                            I.DEPARTMENT_IN,
                            I.LOCATION_IN,
                            S.BRAND_ID,
                            S.PRODUCT_CATID,
                            S.PRODUCT_MANAGER
                        FROM 
                            STOCK_FIS I,
                            STOCK_FIS_ROW IR,
                            #dsn3_alias#.STOCKS S
                        WHERE 
                            I.FIS_ID = IR.FIS_ID AND
                            S.STOCK_ID=IR.STOCK_ID AND
                            <cfif len(attributes.department_id)><!--- depo varsa ambar fisine bak --->
                            I.FIS_TYPE IN (110,113,114,115,119) AND
                            <cfelse>
                            I.FIS_TYPE IN (110,114,115,119) AND
                            </cfif>
                            <!--- I.FIS_DATE >= #attributes.date# AND  --->
                            I.FIS_DATE <= #attributes.date2#
                            <cfif len(attributes.department_id)>
                            AND
                                (
                                <cfloop list="#attributes.department_id#" delimiters="," index="dept_i">
                                (I.DEPARTMENT_IN = #listfirst(dept_i,'-')# AND I.LOCATION_IN = #listlast(dept_i,'-')#)
                                <cfif dept_i neq listlast(attributes.department_id,',') and listlen(attributes.department_id,',') gte 1> OR</cfif>
                                </cfloop>  
                                )
                            <cfelseif is_store>
                                AND I.DEPARTMENT_IN IN (#branch_dep_list#)
                            </cfif>
                            <cfif len(trim(attributes.employee_name)) and len(attributes.product_employee_id)>
                                AND S.PRODUCT_MANAGER = #attributes.product_employee_id#
                            </cfif>
                            <cfif len(trim(attributes.product_name)) and len(attributes.product_id)>
                                AND S.PRODUCT_ID = #attributes.product_id#
                            </cfif>
                            <cfif len(trim(attributes.brand_name)) and len(attributes.brand_id)>
                                AND S.BRAND_ID = #attributes.brand_id# 
                            </cfif>	
                            <cfif len(trim(attributes.product_cat)) and len(attributes.product_code)>
                                AND S.STOCK_CODE LIKE '#attributes.product_code#%'
                            </cfif>
                 )AS GET_STOCK_AGE ON GET_STOCK_AGE.STOCK_SPEC_ID ='GET_ALL_STOCK.PRODUCT_GROUPBY_ID'
        </cfif>
	ORDER BY STOCK_CODE
<!---</cfquery>--->
</pre></cfoutput><cfabort>
		<cfif listfind('1,2',attributes.is_excel) and not isdefined('attributes.ajax')>
			<cfset page_maxrows = 100000>
		<cfelse>
			<cfset page_maxrows = attributes.maxrows>
		</cfif>
		
        <cfif listfind('1,2,8',attributes.report_type)>
		<cfelse>
			<cfset GET_STOCK_FIS.recordcount = 0>
			<cfset GET_DEMONTAJ.recordcount = 0>
			<cfset GET_INV_PURCHASE.recordcount = 0>
		</cfif>
</cfif>
<cfelse>
	<cfscript>
		GET_STOCK_ROWS.recordcount = 0;
		GET_ALL_STOCK.recordcount = 0;
		GET_ALL_STOCK.query_count = 0;
		GET_INV_PURCHASE.recordcount = 0;
		GET_SHIP_ROWS.recordcount = 0;
		GET_DS_SPEC_COST.recordcount = 0;
		DB_SPEC_COST.recordcount = 0;
		GET_EXPENSE.recordcount = 0;
	</cfscript>
</cfif>
	<cfif isdate(attributes.date)>
		<cfset attributes.date = dateformat(attributes.date, "dd/mm/yyyy")>
	</cfif>
	<cfif isdate(attributes.date2)>
		<cfset attributes.date2 = dateformat(attributes.date2, "dd/mm/yyyy")>
	</cfif>
	

