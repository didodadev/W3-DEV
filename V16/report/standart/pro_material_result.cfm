<!---  stok hareketlerindeki işlem tipi kullanılack
hakedis miktar = satış fat miktar- sarf fisi miktar
hakedis tutar = satış fat tutar- sarf fisi tutar
ÖZDEN20061205
 --->
 <cfsetting showdebugoutput="yes">
<cfparam name="attributes.module_id_control" default="1">
<cfparam name="attributes.is_excel" default="0">
<cfparam name="attributes.listing_type" default="">
<cfparam name="attributes.project_id" default="">
<cfparam name="attributes.is_inventory" default="">
<cfparam name="attributes.project_head" default="">
<cfparam name="attributes.report_type" default="1">
<cfparam name="attributes.process_type" default="">

<cfparam name="attributes.start_date" default="">
<cfparam name="attributes.finish_date" default="">
<cfinclude template="report_authority_control.cfm">
<cfif isdefined('attributes.report_type') and  attributes.report_type eq 6> <!---Maliyet bazında ise --->
	<cfset islem_tipi='7,10,12,17'>
    <cfset secim_liste=''>
    <cfloop list="#islem_tipi#" index="eleman">
        <cfif ListFind(attributes.listing_type,eleman,',')>
        <cfset secim_liste = ListAppend(secim_liste,eleman,',')>
        </cfif>
    </cfloop>
    <cfset attributes.listing_type = secim_liste>
</cfif>
<cfif fuseaction contains 'popup'>
	<cfset submit_url = 'report.popup_pro_material_result'>
<cfelse>
	<cfset submit_url = 'report.pro_material_result'>
</cfif>
<cfquery name="GET_PROCESS_CAT" datasource="#DSN3#">
	SELECT PROCESS_TYPE,PROCESS_CAT_ID,PROCESS_CAT FROM SETUP_PROCESS_CAT ORDER BY PROCESS_TYPE
</cfquery>
<cfif attributes.is_excel eq 0>
<cfflush interval="3000">
</cfif>

<cfif isdate(attributes.start_date)><cf_date tarih ="attributes.start_date"></cfif>
<cfif isdate(attributes.finish_date)><cf_date tarih ="attributes.finish_date"></cfif>
<cfset colspan_number=4>
<cfset page_totals = arraynew(1)>

<cfif len(attributes.project_id)>
    <cfquery name="get_pro_head" datasource="#dsn#">
        SELECT PROJECT_HEAD FROM PRO_PROJECTS WHERE PROJECT_ID = #attributes.project_id#
    </cfquery>
    <cfset attributes.project_head = get_pro_head.project_head>
</cfif>

<cfif isdefined("attributes.is_form_submitted")>
	<cfif len(attributes.listing_type)>
		<cfset colspan_number = ((listlen(attributes.listing_type)*5)+4)>
	</cfif>
	<cfif (attributes.report_type neq 5) AND (attributes.report_type neq 6)>
		<cfquery name="GET_ALL_STOCK" datasource="#DSN#" cachedwithin="#fusebox.general_cached_time#">
			SELECT DISTINCT
				<cfif attributes.report_type eq 1>
					S.STOCK_CODE,
					S.STOCK_ID AS REPORT_GROUPBY_ID,
					S.PRODUCT_ID,
					(S.PRODUCT_NAME + ' ' + ISNULL(S.PROPERTY,'')) ACIKLAMA,
					S.COMPANY_ID
				<cfelseif attributes.report_type eq 2>
					C.NICKNAME AS ACIKLAMA,
					C.COMPANY_ID AS REPORT_GROUPBY_ID
				<cfelseif attributes.report_type eq 3>
					PB.BRAND_ID AS REPORT_GROUPBY_ID,
					PB.BRAND_NAME AS ACIKLAMA
				<cfelseif attributes.report_type eq 4>
					PC.HIERARCHY,
					S.PRODUCT_CATID AS REPORT_GROUPBY_ID,
					PC.PRODUCT_CAT AS ACIKLAMA
				</cfif>
			FROM
				#dsn2_alias#.GET_ACTION_PROJECT_PRODUCTS GPP,
				COMPANY C,     
				#dsn3_alias#.STOCKS S
				<cfif isdefined('attributes.pro_met_id') and len(attributes.pro_met_id)>
					,PRO_MATERIAL PM
					,PRO_MATERIAL_ROW PMR
				</cfif>
				<cfif attributes.report_type eq 1>
					,#dsn3_alias#.PRODUCT_UNIT PU
				</cfif>
				<cfif attributes.report_type eq 3>
					,#dsn3_alias#.PRODUCT_BRANDS PB
				</cfif>
				<cfif attributes.report_type eq 4>
					,#dsn3_alias#.PRODUCT_CAT PC
				</cfif>
			WHERE
            	<cfif isDefined('attributes.process_type') and len(attributes.process_type)>
	                (
                		<cfloop list="#attributes.process_type#" index="i">
                        	GPP.PROCESS_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(i,1,'-')#">                              
						   	<cfif listlast(attributes.process_type,',') neq i>
							   	OR  
							</cfif>
						</cfloop>
					) AND  
                </cfif>
                <cfif len(attributes.is_inventory)>
                	S.PRODUCT_ID IN (SELECT PRODUCT_ID FROM #dsn3_alias#.PRODUCT WHERE IS_INVENTORY = 0) AND	
                </cfif>
				GPP.STOCK_ID = S.STOCK_ID
				<cfif attributes.report_type eq 1>
					AND S.PRODUCT_ID=PU.PRODUCT_ID
					AND S.PRODUCT_UNIT_ID=PU.PRODUCT_UNIT_ID
					AND PU.PRODUCT_UNIT_STATUS=1
					AND PU.IS_MAIN=1
				<cfelseif attributes.report_type eq 2>
					AND S.COMPANY_ID=C.COMPANY_ID
				<cfelseif attributes.report_type eq 3>
					AND S.BRAND_ID = PB.BRAND_ID
				<cfelseif attributes.report_type eq 4>
					AND S.PRODUCT_CATID = PC.PRODUCT_CATID
				</cfif>
				<cfif len(attributes.project_id) and len(attributes.project_head)>AND GPP.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#"></cfif>
				<cfif isdefined('attributes.pro_met_id') and len(attributes.pro_met_id)><!--- proje malzeme planından raporu calıstırmak icin --->
					AND PM.PRO_MATERIAL_ID = PMR.PRO_MATERIAL_ID
					AND PMR.STOCK_ID=S.STOCK_ID
					AND GPP.PROJECT_ID=PM.PROJECT_ID
					AND PM.PRO_MATERIAL_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pro_met_id#">
				</cfif>
				<cfif len(attributes.listing_type) and not listfind(attributes.listing_type,1)>
					<!--- Burada kullanilan view icin pro_material deki date bos verilmis o yuzden tarih filtrelendiginde kayit donmuyor, bu kontrolu asagidaki queryde yapiyoruz --->
					<cfif isdate(attributes.start_date) and isdate(attributes.finish_date)>
						AND GPP.ACTION_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#dateadd('d',1,attributes.finish_date)#"> 
						AND GPP.ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#">
					<cfelseif isdate(attributes.finish_date)>
						AND GPP.ACTION_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#dateadd('d',1,attributes.finish_date)#">
					<cfelseif isdate(attributes.start_date)>
						AND GPP.ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#">
					</cfif>
				</cfif>
				<cfif isdefined('attributes.listing_type') and len(attributes.listing_type)>
                    AND (
                            <cfif listfind(attributes.listing_type,1)>
                                <cfif listfirst(attributes.listing_type) neq 1> OR</cfif>(GPP.ACTION_TYPE='PROMATERIAL' AND GPP.PURCHASE_SALES=2)
                            </cfif>
                            <cfif listfind(attributes.listing_type,2)>
                                <cfif listfirst(attributes.listing_type) neq 2> OR</cfif> (GPP.ACTION_TYPE='ORDER_SALE' AND GPP.PURCHASE_SALES=0)
                             </cfif>
                             <cfif listfind(attributes.listing_type,3)>
                                <cfif listfirst(attributes.listing_type) neq 3> OR</cfif> (GPP.ACTION_TYPE='ORDERS' AND GPP.PURCHASE_SALES=1)
                            </cfif>
                            <cfif listfind(attributes.listing_type,4)>
                                <cfif listfirst(attributes.listing_type) neq 4> OR</cfif> (GPP.ACTION_TYPE='SHIP' AND GPP.PURCHASE_SALES=0 AND GPP.PROCESS_TYPE NOT IN (811,81))
                            </cfif>
                            <cfif listfind(attributes.listing_type,5)>
                                <cfif listfirst(attributes.listing_type) neq 5> OR</cfif> (GPP.ACTION_TYPE='SHIP' AND GPP.PURCHASE_SALES=1 AND GPP.PROCESS_TYPE NOT IN (811,81))
                            </cfif>
                            <cfif listfind(attributes.listing_type,6)>
                                <cfif listfirst(attributes.listing_type) neq 6> OR</cfif> (GPP.ACTION_TYPE='SHIP' AND GPP.PROCESS_TYPE=811)
                            </cfif>
                            <cfif listfind(attributes.listing_type,7)>
                                 <cfif listfirst(attributes.listing_type) neq 7> OR </cfif> (GPP.ACTION_TYPE='STOCK_FIS' AND GPP.PROCESS_TYPE=111)
                            </cfif>
                            <cfif listfind(attributes.listing_type,17)>
                                 <cfif listfirst(attributes.listing_type) neq 17> OR </cfif> (GPP.ACTION_TYPE='STOCK_FIS' AND GPP.PROCESS_TYPE=112)
                            </cfif>
                            <cfif listfind(attributes.listing_type,8)>
                                 <cfif listfirst(attributes.listing_type) neq 8> OR </cfif> (GPP.ACTION_TYPE='STOCK_FIS' AND GPP.PROCESS_TYPE=110)
                            </cfif>
                            <cfif listfind(attributes.listing_type,9)>
                                 <cfif listfirst(attributes.listing_type) neq 9> OR</cfif> (GPP.ACTION_TYPE='INVOICE' AND GPP.PURCHASE_SALES =0)
                            </cfif>
                            <cfif listfind(attributes.listing_type,10)>
                                 <cfif listfirst(attributes.listing_type) neq 10> OR</cfif> (GPP.ACTION_TYPE='INVOICE' AND GPP.PURCHASE_SALES =1)
                            </cfif>
                            <cfif listfind(attributes.listing_type,11)>
                                 <cfif listfirst(attributes.listing_type) neq 11> OR</cfif> ((GPP.ACTION_TYPE='INVOICE' AND GPP.PURCHASE_SALES =1) OR (GPP.ACTION_TYPE='STOCK_FIS' AND GPP.PROCESS_TYPE=111))
                            </cfif>
                            <cfif listfind(attributes.listing_type,12)>
                                 <cfif listfirst(attributes.listing_type) neq 12> OR</cfif> (GPP.ACTION_TYPE='SHIP' AND GPP.PROCESS_TYPE=81)
                            </cfif>
                            <cfif listfind(attributes.listing_type,13)>
                                 <cfif listfirst(attributes.listing_type) neq 13> OR</cfif> GPP.ACTION_TYPE='INTERNAL'
                            </cfif>
                            <cfif listfind(attributes.listing_type,14)>
                                 <cfif listfirst(attributes.listing_type) neq 14> OR</cfif> GPP.ACTION_TYPE='PRODUCTION_ORDERS'
                            </cfif>
                            <cfif listfind(attributes.listing_type,15)>
                                 <cfif listfirst(attributes.listing_type) neq 15> OR</cfif> GPP.ACTION_TYPE='INTERNAL'
                            </cfif>
                            <cfif listfind(attributes.listing_type,16)>
                                 <cfif listfirst(attributes.listing_type) neq 16> OR</cfif> GPP.ACTION_TYPE='PRODUCTION_ORDERS'
                            </cfif>
                    )
				</cfif>
				<cfif attributes.report_type eq 1>
					ORDER BY S.STOCK_ID
				<cfelseif attributes.report_type eq 2>
					ORDER BY C.COMPANY_ID
				<cfelseif attributes.report_type eq 3>
					ORDER BY PB.BRAND_ID
				</cfif>
		</cfquery>
	</cfif>
<cfelse>
	<cfset get_all_stock.recordcount=0>
</cfif>
<cfif attributes.report_type eq 1>
	<cfset alan_adi = 'STOCK_ID'>
<cfelseif attributes.report_type eq 2>
	<cfset alan_adi = 'COMPANY_ID'>
<cfelseif attributes.report_type eq 3>
	<cfset alan_adi = 'BRAND_ID'>
<cfelseif attributes.report_type eq 4>
	<cfset alan_adi = 'PRODUCT_CATID'>
</cfif>

<cfif ((isdefined('get_all_stock') and get_all_stock.recordcount)) or (attributes.report_type eq 5)>
	<!--- sarf,üretim,fire veya hakedis islemlerinden biri secilmis ise --->
	<cfif listfind(attributes.listing_type,7) or listfind(attributes.listing_type,8) or listfind(attributes.listing_type,11) or listfind(attributes.listing_type,17)>
		<cfquery name="GET_STOCK_FIS" datasource="#DSN2#" cachedwithin="#fusebox.general_cached_time#">
			SELECT
				<cfif attributes.report_type neq 5>
					S.#alan_adi# AS GROUPBY_ALANI,
				</cfif>
				SFR.AMOUNT,
				SF.FIS_TYPE,
				(NET_TOTAL + TOTAL_TAX) AS SATIR_TOPLAM,
				(NET_TOTAL) AS SATIR_TOPLAM_KDVSIZ
				<cfif len(session.ep.money2)>
					,((NET_TOTAL + TOTAL_TAX)/(SFM.RATE2/SFM.RATE1)) AS SATIR_DOVIZ_TOPLAM
					,((NET_TOTAL)/(SFM.RATE2/SFM.RATE1)) AS SATIR_DOVIZ_TOPLAM_KDVSIZ
				</cfif>
			FROM 
				STOCK_FIS SF,
				STOCK_FIS_ROW SFR
				<cfif attributes.report_type neq 5>
					,#dsn3_alias#.STOCKS S
				</cfif>
				<cfif len(session.ep.money2)>
					,STOCK_FIS_MONEY SFM
				</cfif>
			WHERE 
            	<cfif isDefined('attributes.process_type') and len(attributes.process_type) and listlast(attributes.process_type,'-') neq 0>
	                (
                		<cfloop list="#attributes.process_type#" index="i">
                        	SF.PROCESS_CAT = <cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(i,2,'-')#">                              
						   	<cfif listlast(attributes.process_type,',') neq i>
							   	OR  
							</cfif>
						</cfloop>
					) AND  
                </cfif>
				SF.FIS_ID = SFR.FIS_ID
				<cfif attributes.report_type neq 5> 
					AND S.STOCK_ID = SFR.STOCK_ID 
				</cfif>
					AND SF.FIS_TYPE IN (110,111,112) 
				<cfif len(attributes.project_id) and len(attributes.project_head)>
					AND SF.PROJECT_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">	
				</cfif>
				<cfif isdate(attributes.start_date) and not isdate(attributes.finish_date)>
					AND SF.FIS_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#">
				<cfelseif isdate(attributes.finish_date) and not isdate(attributes.start_date)>
					AND SF.FIS_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date#">
				<cfelseif isdate(attributes.start_date) and isdate(attributes.finish_date)>
					AND SF.FIS_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#">
					AND SF.FIS_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date#">
				</cfif>
				<cfif len(session.ep.money2)>
					AND SF.FIS_ID = SFM.ACTION_ID
					AND SFM.MONEY_TYPE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money2#">
				</cfif>
		</cfquery>
		<cfif get_stock_fis.recordcount>
			<!--- uretim secilmisse --->
			<cfif listfind(attributes.listing_type,8)>
				<cfquery name="PROD_STOCK_FIS" dbtype="query">
					SELECT
						<cfif attributes.report_type neq 5>
                        	GROUPBY_ALANI,
                        </cfif>
                        SUM(AMOUNT) AS URETIM_MIKTAR,
                        SUM(SATIR_TOPLAM) AS URETIM_TUTAR,
                        SUM(SATIR_TOPLAM_KDVSIZ) AS URETIM_TUTAR_KDVSIZ
                        <cfif len(session.ep.money2)>
                        	,SUM(SATIR_DOVIZ_TOPLAM) AS URETIM_DOVIZ_TUTAR
                        	,SUM(SATIR_DOVIZ_TOPLAM_KDVSIZ) AS URETIM_DOVIZ_TUTAR_KDVSIZ
                        </cfif>
					FROM 
						GET_STOCK_FIS
					WHERE 
						FIS_TYPE =110
						<cfif attributes.report_type neq 5>
                            GROUP BY
                                GROUPBY_ALANI
                            ORDER BY
                                GROUPBY_ALANI
                        </cfif> 
				</cfquery>
			<cfelse>
				<cfset prod_stock_fis.recordcount=0>
			</cfif>
			<!--- sarf veya hakedis islemlerinden biri secilmisse --->
			<cfif listfind(attributes.listing_type,7) or listfind(attributes.listing_type,11)>
				<cfquery name="SARF_STOCK_FIS" dbtype="query">
					SELECT
						<cfif attributes.report_type neq 5>
                        	GROUPBY_ALANI,
                        </cfif>
                        SUM(AMOUNT) AS SARF_MIKTAR,
                        SUM(SATIR_TOPLAM) AS SARF_TUTAR,
                        SUM(SATIR_TOPLAM_KDVSIZ) AS SARF_TUTAR_KDVSIZ
                        <cfif len(session.ep.money2)>
                        	,SUM(SATIR_DOVIZ_TOPLAM) AS SARF_DOVIZ_TUTAR
                        	,SUM(SATIR_DOVIZ_TOPLAM_KDVSIZ) AS SARF_DOVIZ_TUTAR_KDVSIZ
                        </cfif>
					FROM 
						GET_STOCK_FIS
					WHERE 
						FIS_TYPE IN (111)
						<cfif attributes.report_type neq 5>
                            GROUP BY
                                GROUPBY_ALANI
                            ORDER BY
                                GROUPBY_ALANI
                        </cfif>
				</cfquery>
			<cfelse>
				<cfset sarf_stock_fis.recordcount=0>
			</cfif>
            <cfif listfind(attributes.listing_type,17)>
				<cfquery name="FIRE_STOCK_FIS" dbtype="query">
					SELECT
						<cfif attributes.report_type neq 5>
                        	GROUPBY_ALANI,
                        </cfif>
                        SUM(AMOUNT) AS SARF_MIKTAR,
                        SUM(SATIR_TOPLAM) AS SARF_TUTAR,
                        SUM(SATIR_TOPLAM_KDVSIZ) AS SARF_TUTAR_KDVSIZ
                        <cfif len(session.ep.money2)>
                        	,SUM(SATIR_DOVIZ_TOPLAM) AS SARF_DOVIZ_TUTAR
                        	,SUM(SATIR_DOVIZ_TOPLAM_KDVSIZ) AS SARF_DOVIZ_TUTAR_KDVSIZ
                        </cfif>
					FROM 
						GET_STOCK_FIS
					WHERE 
						FIS_TYPE IN (112)
						<cfif attributes.report_type neq 5>
                            GROUP BY
                                GROUPBY_ALANI
                            ORDER BY
                                GROUPBY_ALANI
                        </cfif>
				</cfquery>
			<cfelse>
				<cfset fire_stock_fis.recordcount=0>
			</cfif>
		</cfif>
	<cfelse>
		<cfset get_stock_fis.recordcount=0>
	</cfif>
	<!--- alış,satış veya ithalat işlemlerinden biri secilmisse --->
	<cfif listfind(attributes.listing_type,4) or listfind(attributes.listing_type,5) or listfind(attributes.listing_type,6) or listfind(attributes.listing_type,12)>
		<cfquery name="GET_SHIP_ROWS" datasource="#DSN2#" cachedwithin="#fusebox.general_cached_time#">
			SELECT DISTINCT
				<cfif attributes.report_type neq 5>
				S.#alan_adi# AS GROUPBY_ALANI,
				</cfif>
				SHIP_ROW.AMOUNT,
				SHIP_ROW.PRICE,
				SHIP.TAXTOTAL,
				SHIP_ROW.GROSSTOTAL,
				SHIP_ROW.NETTOTAL,
				<cfif len(session.ep.money2)>
					SHIP_ROW.GROSSTOTAL/(SHPM.RATE2/SHPM.RATE1) AS IRS_DOVIZ,
					SHIP_ROW.NETTOTAL/(SHPM.RATE2/SHPM.RATE1) AS IRS_DOVIZ_KDVSIZ,
					SHPM.RATE2,
					SHPM.RATE1,
				</cfif>
				SHIP.PURCHASE_SALES,
				SHIP.SHIP_TYPE,
				SHIP.IS_WITH_SHIP
			FROM
				SHIP,
				SHIP_ROW
				<cfif attributes.report_type neq 5>
				,#dsn3_alias#.STOCKS S
				</cfif>
				<cfif len(session.ep.money2)>
					,SHIP_MONEY SHPM
				</cfif>
			WHERE
            	<cfif isDefined('attributes.process_type') and len(attributes.process_type) and listlast(attributes.process_type,'-') neq 0>
	                (
                		<cfloop list="#attributes.process_type#" index="i">
                        	SHIP.PROCESS_CAT = <cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(i,2,'-')#">                              
						   	<cfif listlast(attributes.process_type,',') neq i>
							   	OR  
							</cfif>
						</cfloop>
					) AND  
                </cfif>
				SHIP.SHIP_ID = SHIP_ROW.SHIP_ID
				<cfif attributes.report_type neq 5>
                    AND S.STOCK_ID = SHIP_ROW.STOCK_ID
                </cfif>
                <cfif len(attributes.project_id) and len(attributes.project_head)>
                    AND SHIP.PROJECT_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">	
                </cfif>
                <cfif isdate(attributes.start_date) and not isdate(attributes.finish_date)>
                    AND SHIP.SHIP_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#">
                <cfelseif isdate(attributes.finish_date) and not isdate(attributes.start_date)>
                    AND SHIP.SHIP_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date#">
                <cfelseif isdate(attributes.start_date) and isdate(attributes.finish_date)>
                    AND SHIP.SHIP_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#">
                    AND SHIP.SHIP_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date#">
                </cfif>
                <cfif len(session.ep.money2)>
                    AND SHIP.SHIP_ID = SHPM.ACTION_ID
                    AND SHPM.MONEY_TYPE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money2#">
                </cfif>
			<!--- FBS 20150525 Verilerin Coklamasina Sebep Oluyor, Bu Sekilde Kullanilis Amaci Belli Olursa Farkli Bir Duzenleme Yapilabilir Sonrasında, Su An Bu Bloga Gerek Yok Gibi Gorunuyor
			UNION
            SELECT DISTINCT
                <cfif attributes.report_type neq 5>
                    S.#alan_adi# AS GROUPBY_ALANI,
                </cfif>
                SHIP_ROW.AMOUNT,
                SHIP_ROW.PRICE,
                SHIP.TAXTOTAL,
                SHIP_ROW.GROSSTOTAL,
                SHIP_ROW.NETTOTAL,
                <cfif len(session.ep.money2)>
                    SHIP_ROW.GROSSTOTAL/(INVM.RATE2/INVM.RATE1) AS IRS_DOVIZ,
                    SHIP_ROW.NETTOTAL/(INVM.RATE2/INVM.RATE1) AS IRS_DOVIZ_KDVSIZ,
                    INVM.RATE2,
                    INVM.RATE1,
                </cfif>
                SHIP.PURCHASE_SALES,
                SHIP.SHIP_TYPE,
                SHIP.IS_WITH_SHIP					
            FROM
                SHIP,
                SHIP_ROW
                <cfif attributes.report_type neq 5>
                	,#dsn3_alias#.STOCKS S
                </cfif>
                <cfif len(session.ep.money2)>
                    ,INVOICE_MONEY INVM
                    ,INVOICE_SHIPS INVSHP
                </cfif>		
            WHERE
            	<cfif isDefined('attributes.process_type') and len(attributes.process_type) and listlast(attributes.process_type,'-') neq 0>
	                (
                		<cfloop list="#attributes.process_type#" index="i">
                        	SHIP.PROCESS_CAT = <cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(i,2,'-')#">                              
						   	<cfif listlast(attributes.process_type,',') neq i>
							   	OR  
							</cfif>
						</cfloop>
					) AND  
                </cfif>
                SHIP.SHIP_ID = SHIP_ROW.SHIP_ID
                <cfif attributes.report_type neq 5>
                    AND S.STOCK_ID = SHIP_ROW.STOCK_ID
                </cfif>
                <cfif len(attributes.project_id) and len(attributes.project_head)>
                    AND SHIP.PROJECT_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">	
                </cfif>
                <cfif isdate(attributes.start_date) and not isdate(attributes.finish_date)>
                    AND SHIP.SHIP_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#">
                <cfelseif isdate(attributes.finish_date) and not isdate(attributes.start_date)>
                    AND SHIP.SHIP_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date#">
                <cfelseif isdate(attributes.start_date) and isdate(attributes.finish_date)>
                    AND SHIP.SHIP_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#">
                    AND SHIP.SHIP_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date#">
                </cfif>
                <cfif len(session.ep.money2)>
                    AND INVSHP.SHIP_ID = SHIP.SHIP_ID
                    AND INVM.ACTION_ID = INVSHP.INVOICE_ID
                    AND INVM.MONEY_TYPE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money2#">
                </cfif>
				 --->
		</cfquery>
		<cfif get_ship_rows.recordcount>
			<!--- alıs irsaliyeleri  --->
			<cfif listfind(attributes.listing_type,4)>
				<cfquery name="ALIS_IRS" dbtype="query">
					SELECT
						<cfif attributes.report_type neq 5>
                            GROUPBY_ALANI,
                        </cfif>
                            SUM(AMOUNT) AS ALIS_IRS_MIKTAR
                        <cfif len(session.ep.money2)>
                            ,SUM(IRS_DOVIZ) AS ALIS_IRS_DOVIZ_TUTAR
                            ,SUM(IRS_DOVIZ_KDVSIZ) AS ALIS_IRS_DOVIZ_TUTAR_KDVSIZ
                        </cfif>
						,SUM(GROSSTOTAL) AS ALIS_IRS_TUTAR
						,SUM(NETTOTAL) AS ALIS_IRS_TUTAR_KDVSIZ
					FROM 
						GET_SHIP_ROWS
					WHERE 
						PURCHASE_SALES =0
						AND SHIP_TYPE NOT IN (811,81)
						<cfif attributes.report_type neq 5>
                            GROUP BY
                                GROUPBY_ALANI
                            ORDER BY
                                GROUPBY_ALANI
                        </cfif>
				</cfquery>
			<cfelse>
				<cfset alis_irs.recordcount = 0>
			</cfif>
			<!--- satış irsaliyeleri  --->
			<cfif listfind(attributes.listing_type,5)>
				<cfquery name="SATIS_IRS" dbtype="query">
					SELECT
					<cfif attributes.report_type neq 5>
						GROUPBY_ALANI,
					</cfif>
						SUM(AMOUNT) AS SATIS_IRS_MIKTAR,
						SUM(GROSSTOTAL) AS SATIS_IRS_TUTAR,
						SUM(NETTOTAL) AS SATIS_IRS_TUTAR_KDVSIZ
					<cfif len(session.ep.money2)>
						,SUM(IRS_DOVIZ) AS SATIS_IRS_DOVIZ_TUTAR
						,SUM(IRS_DOVIZ_KDVSIZ) AS SATIS_IRS_DOVIZ_TUTAR_KDVSIZ
					</cfif>
					FROM 
						GET_SHIP_ROWS
					WHERE 
						PURCHASE_SALES =1
						AND SHIP_TYPE NOT IN (811,81)
					<cfif attributes.report_type neq 5>
					GROUP BY
						GROUPBY_ALANI
					ORDER BY
						GROUPBY_ALANI
					</cfif>
				</cfquery>
			<cfelse>
				<cfset satis_irs.recordcount = 0>
			</cfif>
			<!--- ithalat (ithal mal girisi) irsaliyeleri--->
			<cfif listfind(attributes.listing_type,6)>
				<cfquery name="ITHALAT_IRS" dbtype="query">
					SELECT
						<cfif attributes.report_type neq 5>
                            GROUPBY_ALANI,
                        </cfif>
                        SUM(AMOUNT) AS ITH_IRS_MIKTAR,
                        SUM(GROSSTOTAL) AS ITH_IRS_TUTAR,
                        SUM(NETTOTAL) AS ITH_IRS_TUTAR_KDVSIZ
                        <cfif len(session.ep.money2)>
                            ,SUM(IRS_DOVIZ) AS ITH_IRS_DOVIZ_TUTAR
                            ,SUM(IRS_DOVIZ_KDVSIZ) AS ITH_IRS_DOVIZ_TUTAR_KDVSIZ
                        </cfif>
					FROM 
						GET_SHIP_ROWS
					WHERE 
						SHIP_TYPE = 811
						<cfif attributes.report_type neq 5>
                            GROUP BY
                                GROUPBY_ALANI
                            ORDER BY
                                GROUPBY_ALANI
                        </cfif>
				</cfquery>
			<cfelse>
				<cfset ithalat_irs.recordcount = 0>
			</cfif>
			<!--- depolararası irsaliyeleri--->
			<cfif listfind(attributes.listing_type,12)>
				<cfquery name="DEPO_IRS" dbtype="query">
					SELECT
						<cfif attributes.report_type neq 5>
                            GROUPBY_ALANI,
                        </cfif>
                            SUM(AMOUNT) AS DEPO_IRS_MIKTAR,
                            SUM((PRICE*AMOUNT)+TAXTOTAL) AS DEPO_IRS_TUTAR,
                            SUM((PRICE*AMOUNT)) AS DEPO_IRS_TUTAR_KDVSIZ
                        <cfif len(session.ep.money2)>
                            ,SUM(((PRICE*AMOUNT)+TAXTOTAL)/(RATE2/RATE1)) AS DEPO_IRS_DOVIZ_TUTAR
                            ,SUM((PRICE*AMOUNT)/(RATE2/RATE1)) AS DEPO_IRS_DOVIZ_TUTAR_KDVSIZ
                        </cfif>
					FROM 
						GET_SHIP_ROWS
					WHERE 
						SHIP_TYPE = 81
						<cfif attributes.report_type neq 5>
                            GROUP BY
                                GROUPBY_ALANI
                            ORDER BY
                                GROUPBY_ALANI
                        </cfif>
				</cfquery>
			<cfelse>
				<cfset depo_irs.recordcount = 0>
			</cfif>
		</cfif>
	<cfelse>
		<cfset get_ship_rows.recordcount=0>
	</cfif>
	<cfif listfind(attributes.listing_type,9)>
		<cfquery name="GET_INV_PURCHASE" datasource="#DSN2#" cachedwithin="#fusebox.general_cached_time#">
			SELECT
				<cfif attributes.report_type neq 5>
                    S.#alan_adi# AS GROUPBY_ALANI,
                </cfif>
				SUM(IR.AMOUNT) AS ALIS_FAT_MIKTAR,
				SUM( (1- I.SA_DISCOUNT/(I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT)) * IR.NETTOTAL *(IR.TAX+100)/100) AS ALIS_FAT_TUTAR,
				SUM( (1- I.SA_DISCOUNT/(I.NETTOTAL+I.SA_DISCOUNT)) * IR.NETTOTAL ) AS ALIS_FAT_TUTAR_KDVSIZ
				<cfif len(session.ep.money2)>
                    ,SUM( ((1- I.SA_DISCOUNT/(I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT)) * IR.NETTOTAL *(IR.TAX+100)/100) /(IM.RATE2/IM.RATE1)) AS ALIS_FAT_DOVIZ_TUTAR
                    ,SUM( ((1- I.SA_DISCOUNT/(I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT)) * IR.NETTOTAL ) /(IM.RATE2/IM.RATE1)) AS ALIS_FAT_DOVIZ_TUTAR_KDVSIZ
				</cfif>
			FROM 
				INVOICE I,
				INVOICE_ROW IR
				<cfif attributes.report_type neq 5>
					,#dsn3_alias#.STOCKS S
				</cfif>
				<cfif len(session.ep.money2)>
					,INVOICE_MONEY IM
				</cfif>
			WHERE 
            	<cfif isDefined('attributes.process_type') and len(attributes.process_type) and listlast(attributes.process_type,'-') neq 0>
	                (
                		<cfloop list="#attributes.process_type#" index="i">
                        	I.PROCESS_CAT = <cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(i,1,'-')#">                              
						   	<cfif listlast(attributes.process_type,',') neq i>
							   	OR  
							</cfif>
						</cfloop>
					) AND  
                </cfif>
				I.INVOICE_ID = IR.INVOICE_ID
				AND I.PURCHASE_SALES =0
				AND I.IS_IPTAL = 0
				<cfif attributes.report_type neq 5>
                    AND IR.STOCK_ID=S.STOCK_ID 
                </cfif>
                    AND I.NETTOTAL > 0
                <cfif len(attributes.project_id) and len(attributes.project_head)>
                    AND I.PROJECT_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">	
                </cfif>
                <cfif isdate(attributes.start_date) and not isdate(attributes.finish_date)>
                    AND I.INVOICE_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#">
                <cfelseif isdate(attributes.finish_date) and not isdate(attributes.start_date)>
                    AND I.INVOICE_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date#">
                <cfelseif isdate(attributes.start_date) and isdate(attributes.finish_date)>
                    AND I.INVOICE_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#">
                    AND I.INVOICE_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date#">
                </cfif>
                <cfif len(session.ep.money2)>
                    AND I.INVOICE_ID = IM.ACTION_ID
                    AND IM.MONEY_TYPE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money2#">
                </cfif>
                <cfif attributes.report_type neq 5>
                    GROUP BY
                       S.#alan_adi#
                    ORDER BY
                       S.#alan_adi#
                </cfif>
		</cfquery>
	<cfelse>
		<cfset get_inv_purchase.recordcount=0>
	</cfif>
	<cfif listfind(attributes.listing_type,10) or listfind(attributes.listing_type,11)>
		<cfquery name="GET_INV_SALE" datasource="#DSN2#" cachedwithin="#fusebox.general_cached_time#">
			SELECT
				<cfif attributes.report_type neq 5>
                    S.#alan_adi# AS GROUPBY_ALANI,
                </cfif>
                SUM(IR.AMOUNT) AS SATIS_FAT_MIKTAR,
                SUM(( (1- I.SA_DISCOUNT/(I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT)) * IR.GROSSTOTAL)) AS SATIS_FAT_TUTAR,
                SUM(( (1- I.SA_DISCOUNT/(I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT)) * IR.NETTOTAL)) AS SATIS_FAT_TUTAR_KDVSIZ
                <cfif len(session.ep.money2)>
                    ,SUM(( (1- I.SA_DISCOUNT/(I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT)) * IR.GROSSTOTAL) /(IM.RATE2/RATE1)) AS SATIS_FAT_DOVIZ_TUTAR
                    ,SUM(( (1- I.SA_DISCOUNT/(I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT)) * IR.NETTOTAL) /(IM.RATE2/RATE1)) AS SATIS_FAT_DOVIZ_TUTAR_KDVSIZ
                </cfif>
			FROM 
				INVOICE I,
				INVOICE_ROW IR
				<cfif attributes.report_type neq 5>
					,#dsn3_alias#.STOCKS S
				</cfif>
				<cfif len(session.ep.money2)>
					,INVOICE_MONEY IM
				</cfif>
			WHERE 
            	<cfif isDefined('attributes.process_type') and len(attributes.process_type) and listlast(attributes.process_type,'-') neq 0>
	                (
                		<cfloop list="#attributes.process_type#" index="i">
                        	I.PROCESS_CAT = <cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(i,1,'-')#">                              
						   	<cfif listlast(attributes.process_type,',') neq i>
							   	OR  
							</cfif>
						</cfloop>
					) AND  
                </cfif>
				I.INVOICE_ID = IR.INVOICE_ID
				<cfif attributes.report_type neq 5>
					AND IR.STOCK_ID=S.STOCK_ID	
				</cfif>
				AND I.IS_IPTAL = 0 
				AND I.INVOICE_CAT <> 67 
				AND I.INVOICE_CAT <> 69
				AND I.PURCHASE_SALES = 1 
				AND I.NETTOTAL > 0 
				<cfif len(attributes.project_id) and len(attributes.project_head)>
                    AND I.PROJECT_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">	
                </cfif>
                <cfif isdate(attributes.start_date) and not isdate(attributes.finish_date)>
                    AND I.INVOICE_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#">
                <cfelseif isdate(attributes.finish_date) and not isdate(attributes.start_date)>
                    AND I.INVOICE_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date#">
                <cfelseif isdate(attributes.start_date) and isdate(attributes.finish_date)>
                    AND I.INVOICE_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#">
                    AND I.INVOICE_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date#">
                </cfif>
                <cfif len(session.ep.money2)>
                    AND I.INVOICE_ID = IM.ACTION_ID
                    AND IM.MONEY_TYPE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money2#">
                </cfif>
				<cfif attributes.report_type neq 5>
                    GROUP BY
                        S.#alan_adi#
                    ORDER BY
                        S.#alan_adi#
                </cfif>
		</cfquery>
	<cfelse>
		<cfset get_inv_sale.recordcount=0>
	</cfif>
	<!--- Satış Siparişleri --->
	<cfif listfind(attributes.listing_type,3)>
		<cfquery name="GET_SALE_ORDERS" datasource="#DSN3#" cachedwithin="#fusebox.general_cached_time#">
			SELECT
				SUM((ORR.QUANTITY*(ORR.PRICE)*(100+ORR.TAX)/100)+(ORR.OTVTOTAL)) SATIS_SIPARIS_TUTAR,
				SUM((ORR.QUANTITY*(ORR.PRICE))+(ORR.OTVTOTAL)) SATIS_SIPARIS_TUTAR_KDVSIZ
				<cfif len(session.ep.money2)>
                    ,SUM(((ORR.QUANTITY*(ORR.PRICE)*(100+ORR.TAX)/100)+(ORR.OTVTOTAL)) /(ORDER_MONEY.RATE2/ORDER_MONEY.RATE1)) SATIS_SIPARIS_DOVIZ_TUTAR
                    ,SUM(((ORR.QUANTITY*(ORR.PRICE))+(ORR.OTVTOTAL)) /(ORDER_MONEY.RATE2/ORDER_MONEY.RATE1)) SATIS_SIPARIS_DOVIZ_TUTAR_KDVSIZ
				</cfif>
				,SUM(ORR.QUANTITY) AS SATIS_SIPARIS_MIKTAR
				<cfif attributes.report_type neq 5>
					,S.#alan_adi# AS GROUPBY_ALANI
				</cfif>
			FROM
				ORDERS ORD,
				ORDER_ROW ORR
				<cfif len(session.ep.money2)>
					,ORDER_MONEY
				</cfif>
				<cfif attributes.report_type neq 5>
					,#dsn3_alias#.STOCKS S
				</cfif>
			WHERE
				(
					(	ORD.PURCHASE_SALES = 1 AND
						ORD.ORDER_ZONE = 0
					 )  
					OR
					(	ORD.PURCHASE_SALES = 0 AND
						ORD.ORDER_ZONE = 1
					)
				)
				<cfif len(attributes.project_id) and len(attributes.project_head)>
					AND ORD.PROJECT_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
				</cfif>
				<cfif isdate(attributes.start_date) and not isdate(attributes.finish_date)>
					AND ORD.ORDER_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#">
				<cfelseif isdate(attributes.finish_date) and not isdate(attributes.start_date)>
					AND ORD.ORDER_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date#">
				<cfelseif isdate(attributes.start_date) and isdate(attributes.finish_date)>
					AND ORD.ORDER_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#">
					AND ORD.ORDER_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date#">
				</cfif>
				AND ORR.ORDER_ID = ORD.ORDER_ID
				AND ORD.ORDER_STATUS = 1
				<cfif attributes.report_type neq 5>
					AND ORR.STOCK_ID=S.STOCK_ID
				</cfif>
				<cfif len(session.ep.money2)>
                    AND ORD.ORDER_ID = ORDER_MONEY.ACTION_ID
                    AND ORDER_MONEY.MONEY_TYPE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money2#">
				</cfif>
				<cfif attributes.report_type neq 5>
                    GROUP BY
                        S.#alan_adi#
                    ORDER BY
                        S.#alan_adi#
                </cfif>
		</cfquery>
	<cfelse>
		<cfset get_sale_orders.recordcount=0>
	</cfif>
	<cfif listfind(attributes.listing_type,2)>
		<cfquery name="GET_PURCHASE_ORDERS" datasource="#DSN3#" cachedwithin="#fusebox.general_cached_time#">
			SELECT
				SUM((ORR.QUANTITY*(ORR.PRICE)*(100+ORR.TAX)/100)+(ORR.OTVTOTAL)) AS SATINALMA_SIPARIS_TUTAR,
				SUM((ORR.QUANTITY*(ORR.PRICE))+(ORR.OTVTOTAL)) AS SATINALMA_SIPARIS_TUTAR_KDVSIZ,
				SUM(ORR.QUANTITY) AS SATINALMA_SIPARIS_MIKTAR
				<cfif len(session.ep.money2)>
                    ,SUM(((ORR.QUANTITY*(ORR.PRICE)*(100+ORR.TAX)/100)+(ORR.OTVTOTAL))/(ORM.RATE2/ORM.RATE1)) AS SATINALMA_SIPARIS_DOVIZ_TUTAR
                    ,SUM((ORR.QUANTITY*(ORR.PRICE)+(ORR.OTVTOTAL))/(ORM.RATE2/ORM.RATE1)) AS SATINALMA_SIPARIS_DOVIZ_TUTAR_KDVSIZ
				</cfif>
				<cfif attributes.report_type neq 5>
					,S.#alan_adi# AS GROUPBY_ALANI
				</cfif>
			FROM
				ORDERS ORD,
				ORDER_ROW ORR
				<cfif attributes.report_type neq 5>
					,#dsn3_alias#.STOCKS S
				</cfif>
				<cfif len(session.ep.money2)>
					,ORDER_MONEY ORM
				</cfif>
			WHERE
				ORR.ORDER_ID = ORD.ORDER_ID
				AND ORD.PURCHASE_SALES = 0
				AND ORD.ORDER_ZONE = 0
				AND ORD.ORDER_STATUS = 1
				<cfif attributes.report_type neq 5>
					AND ORR.STOCK_ID=S.STOCK_ID
				</cfif>
				<cfif len(attributes.project_id) and len(attributes.project_head)>
					AND ORD.PROJECT_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">	
				</cfif>
				<cfif isdate(attributes.start_date) and not isdate(attributes.finish_date)>
					AND ORD.ORDER_DATE >= #attributes.start_date#
				<cfelseif isdate(attributes.finish_date) and not isdate(attributes.start_date)>
					AND ORD.ORDER_DATE <= #attributes.finish_date#
				<cfelseif isdate(attributes.start_date) and isdate(attributes.finish_date)>
					AND ORD.ORDER_DATE >= #attributes.start_date#
					AND ORD.ORDER_DATE <= #attributes.finish_date#
				</cfif>
				<cfif len(session.ep.money2)>
					AND ORD.ORDER_ID = ORM.ACTION_ID
					AND ORM.MONEY_TYPE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money2#">
				</cfif>
				<cfif attributes.report_type neq 5>
                    GROUP BY
                        S.#alan_adi#
                    ORDER BY
                        S.#alan_adi#
                </cfif>
		</cfquery>
	<cfelse>
		<cfset get_purchase_orders.recordcount=0>
	</cfif>
	<cfif listfind(attributes.listing_type,1)>
		<cfquery name="GET_PRO_MATERIAL" datasource="#DSN#">
			SELECT
				SUM(PMR.GROSSTOTAL) AS PRO_MATERIAL_TUTAR,
				SUM(PMR.NETTOTAL) AS PRO_MATERIAL_TUTAR_KDVSIZ
				<cfif len(session.ep.money2)>
                    ,SUM((PMR.GROSSTOTAL)/(PMM.RATE2/PMM.RATE1)) AS PRO_MATERIAL_DOVIZ_TUTAR
                    ,SUM((PMR.NETTOTAL)/(PMM.RATE2/PMM.RATE1)) AS PRO_MATERIAL_DOVIZ_TUTAR_KDVSIZ
				</cfif>
				,SUM(PMR.AMOUNT) AS PRO_MATERIAL_MIKTAR
				<cfif attributes.report_type neq 5>
					,S.#alan_adi# AS GROUPBY_ALANI
				</cfif>
			FROM 
				PRO_MATERIAL PM,
				PRO_MATERIAL_ROW PMR
				<cfif attributes.report_type neq 5>
					,#dsn3_alias#.STOCKS S
				</cfif>
				<cfif len(session.ep.money2)>
					,PRO_MATERIAL_MONEY PMM
				</cfif>
			WHERE 
				PM.PRO_MATERIAL_ID = PMR.PRO_MATERIAL_ID
				<cfif attributes.report_type neq 5>
					AND PMR.STOCK_ID = S.STOCK_ID
				</cfif>
				<cfif len(attributes.project_id) and len(attributes.project_head)>
					AND PM.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">  
				</cfif>
				<cfif isdate(attributes.start_date) and not isdate(attributes.finish_date)>
					AND PM.ACTION_DATE >= #attributes.start_date#
				<cfelseif isdate(attributes.finish_date) and not isdate(attributes.start_date)>
					AND PM.ACTION_DATE <= #attributes.finish_date#
				<cfelseif isdate(attributes.start_date) and isdate(attributes.finish_date)>
					AND PM.ACTION_DATE >= #attributes.start_date#
					AND PM.ACTION_DATE <= #attributes.finish_date#
				</cfif>
				<cfif len(session.ep.money2)>
				AND PM.PRO_MATERIAL_ID = PMM.ACTION_ID
				AND PMM.MONEY_TYPE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money2#">
				</cfif>
					<cfif attributes.report_type neq 5>
                    GROUP BY
                        S.#alan_adi#
                    ORDER BY
                        S.#alan_adi#
                </cfif>
		</cfquery>
	<cfelse>
		<cfset get_pro_material.recordcount=0>
	</cfif>
	<cfif listfind(attributes.listing_type,13)>
		<cfquery name="GET_INTERNAL" datasource="#DSN3#" cachedwithin="#fusebox.general_cached_time#">
			SELECT
				<cfif attributes.report_type neq 5>
                    S.#alan_adi# AS GROUPBY_ALANI,
                </cfif>
                    SUM((INDR.QUANTITY*(INDR.PRICE)*(100+INDR.TAX)/100)) AS IC_TALEP_TUTAR,
                    SUM((INDR.QUANTITY*(INDR.PRICE))) AS IC_TALEP_TUTAR_KDVSIZ
                <cfif len(session.ep.money2)>
                    ,SUM(((INDR.QUANTITY*(INDR.PRICE)*(100+INDR.TAX)/100))/(IND_M.RATE2/IND_M.RATE1)) AS IC_TALEP_DOVIZ_TUTAR
                    ,SUM((INDR.QUANTITY*(INDR.PRICE))/(IND_M.RATE2/IND_M.RATE1)) AS IC_TALEP_DOVIZ_TUTAR_KDVSIZ
                </cfif>
				,SUM(INDR.QUANTITY) AS IC_TALEP_MIKTAR
			FROM
				INTERNALDEMAND IND,
				INTERNALDEMAND_ROW INDR
				<cfif attributes.report_type neq 5>
					,STOCKS S
				</cfif>
				<cfif len(session.ep.money2)>
					,INTERNALDEMAND_MONEY IND_M
				</cfif>
			WHERE
				INDR.I_ID = IND.INTERNAL_ID
				AND ISNULL(DEMAND_TYPE,0) = 0
				<cfif attributes.report_type neq 5>
					AND INDR.STOCK_ID = S.STOCK_ID
				</cfif>
				<cfif len(attributes.project_id) and len(attributes.project_head)>
					AND IND.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
				</cfif>
				<cfif isdate(attributes.start_date) and isdate(attributes.finish_date)>
					AND IND.RECORD_DATE < #DATEADD('d',1,attributes.finish_date)# 
					AND IND.RECORD_DATE >= #attributes.start_date#
				<cfelseif isdate(attributes.finish_date)>
					AND IND.RECORD_DATE < #DATEADD('d',1,attributes.finish_date)#
				<cfelseif isdate(attributes.start_date)>
					AND IND.RECORD_DATE >= #attributes.start_date#
				</cfif>
				<cfif len(session.ep.money2)>
					AND IND.INTERNAL_ID = IND_M.ACTION_ID
					AND IND_M.MONEY_TYPE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money2#">
				</cfif>
				<cfif attributes.report_type neq 5>
                    GROUP BY
                        S.#alan_adi#
                    ORDER BY
                        S.#alan_adi#
                </cfif>
		</cfquery>
	<cfelse>
		<cfset get_internal.recordcount=0>
	</cfif>
	<cfif listfind(attributes.listing_type,14)>
		<cfquery name="GET_PRODUCTION_ORDERS" datasource="#DSN3#" cachedwithin="#fusebox.general_cached_time#">
			SELECT
				SUM(PORD.QUANTITY) AS URETIM_EMIR_MIKTAR,
				0 AS URETIM_EMIR_TUTAR,
				0 AS URETIM_EMIR_TUTAR_KDVSIZ
				<cfif attributes.report_type neq 5>
					,S.#alan_adi# AS GROUPBY_ALANI
				</cfif>
			FROM 
				PRODUCTION_ORDERS PORD
				<cfif attributes.report_type neq 5>
					,STOCKS S
				</cfif>
			WHERE
				1=1
				<cfif attributes.report_type neq 5>
					AND PORD.STOCK_ID=S.STOCK_ID
				</cfif>
				<cfif len(attributes.project_id) and len(attributes.project_head)>
					AND PORD.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#"> 
				</cfif>
				<cfif isdate(attributes.start_date) and isdate(attributes.finish_date)>
					AND PORD.START_DATE < #DATEADD('d',1,attributes.finish_date)# 
					AND PORD.START_DATE >= #attributes.start_date#
				<cfelseif isdate(attributes.finish_date)>
					AND PORD.START_DATE < #DATEADD('d',1,attributes.finish_date)#
				<cfelseif isdate(attributes.start_date)>
					AND PORD.START_DATE >= #attributes.startdate#
				</cfif>
				<cfif attributes.report_type neq 5>
                    GROUP BY
                        S.#alan_adi#
                    ORDER BY
                        S.#alan_adi#
                </cfif>
		</cfquery>
	<cfelse>
		<cfset get_production_orders.recordcount=0>
	</cfif>
	<cfif listfind(attributes.listing_type,15)>
		<cfquery name="GET_PURCHASE_INTERNAL" datasource="#DSN3#" cachedwithin="#fusebox.general_cached_time#">
			SELECT
				<cfif attributes.report_type neq 5>
                    S.#alan_adi# AS GROUPBY_ALANI,
                </cfif>
                SUM((INDR.QUANTITY*(INDR.PRICE)*(100+INDR.TAX)/100)) AS SATINALMA_TALEP_TUTAR,
                SUM((INDR.QUANTITY*(INDR.PRICE))) AS SATINALMA_TALEP_TUTAR_KDVSIZ
                <cfif len(session.ep.money2)>
                    ,SUM(((INDR.QUANTITY*(INDR.PRICE)*(100+INDR.TAX)/100))/(IND_M.RATE2/IND_M.RATE1)) AS SATINALMA_TALEP_DOVIZ_TUTAR
                    ,SUM((INDR.QUANTITY*(INDR.PRICE))/(IND_M.RATE2/IND_M.RATE1)) AS SATINALMA_TALEP_DOVIZ_TUTAR_KDVSIZ
                </cfif>
				,SUM(INDR.QUANTITY) AS SATINALMA_TALEP_MIKTAR
			FROM
				INTERNALDEMAND IND,
				INTERNALDEMAND_ROW INDR
				<cfif attributes.report_type neq 5>
					,STOCKS S
				</cfif>
				<cfif len(session.ep.money2)>
					,INTERNALDEMAND_MONEY IND_M
				</cfif>
			WHERE
				INDR.I_ID = IND.INTERNAL_ID
				AND ISNULL(DEMAND_TYPE,0) = 1                	
				<cfif attributes.report_type neq 5>
					AND INDR.STOCK_ID = S.STOCK_ID
				</cfif>
				<cfif len(attributes.project_id) and len(attributes.project_head)>
					AND IND.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
				</cfif>
				<cfif isdate(attributes.start_date) and isdate(attributes.finish_date)>
					AND IND.RECORD_DATE < #DATEADD('d',1,attributes.finish_date)# 
					AND IND.RECORD_DATE >= #attributes.start_date#
				<cfelseif isdate(attributes.finish_date)>
					AND IND.RECORD_DATE < #DATEADD('d',1,attributes.finish_date)#
				<cfelseif isdate(attributes.start_date)>
					AND IND.RECORD_DATE >= #attributes.start_date#
				</cfif>
				<cfif len(session.ep.money2)>
					AND IND.INTERNAL_ID = IND_M.ACTION_ID
					AND IND_M.MONEY_TYPE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money2#">
				</cfif>
				<cfif attributes.report_type neq 5>
                    GROUP BY
                        S.#alan_adi#
                    ORDER BY
                        S.#alan_adi#
                </cfif>
		</cfquery>
	<cfelse>
		<cfset get_purchase_internal.recordcount=0>
	</cfif>
	<cfif listfind(attributes.listing_type,16)>
		<cfquery name="GET_PRODUCTION_INTERNALS" datasource="#DSN3#" cachedwithin="#fusebox.general_cached_time#">
			SELECT
				SUM(PORD.QUANTITY) AS URETIM_TALEP_MIKTAR,
				0 AS URETIM_TALEP_TUTAR,
				0 AS URETIM_TALEP_TUTAR_KDVSIZ
				<cfif attributes.report_type neq 5>
					,S.#alan_adi# AS GROUPBY_ALANI
				</cfif>
			FROM 
				PRODUCTION_ORDERS PORD
				<cfif attributes.report_type neq 5>
					,STOCKS S
				</cfif>
			WHERE
				1=1
                AND PORD.IS_STAGE = -1
				AND PORD.DEMAND_NO IS NOT NULL	
				<cfif attributes.report_type neq 5>
					AND PORD.STOCK_ID=S.STOCK_ID
				</cfif>
				<cfif len(attributes.project_id) and len(attributes.project_head)>
					AND PORD.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#"> 
				</cfif>
				<cfif isdate(attributes.start_date) and isdate(attributes.finish_date)>
					AND PORD.START_DATE < #DATEADD('d',1,attributes.finish_date)# 
					AND PORD.START_DATE >= #attributes.start_date#
				<cfelseif isdate(attributes.finish_date)>
					AND PORD.START_DATE < #DATEADD('d',1,attributes.finish_date)#
				<cfelseif isdate(attributes.start_date)>
					AND PORD.START_DATE >= #attributes.startdate#
				</cfif>
				<cfif attributes.report_type neq 5>
                    GROUP BY
                        S.#alan_adi#
                    ORDER BY
                        S.#alan_adi#
                </cfif>
		</cfquery>
	<cfelse>
		<cfset get_production_internals.recordcount=0>
	</cfif>
</cfif>
<cfif attributes.report_type eq 6 and len(secim_liste)>
	<cfset urun_id_list = ''>
    <cfquery name="GET_PRODUCT_SHIP_COST" datasource="#DSN2#">
        <cfif listfind(secim_liste,10,',')>
            SELECT 
                1 TYPE,<!--- TOPTAN SATIŞ FATURASI --->
                MALIYET,
                STOCKS.STOCK_ID,
                STOCKS.PRODUCT_ID,
                STOCKS.STOCK_CODE,
                STOCKS.PRODUCT_NAME,
                PROJECT_ID,
                STOCK_OUT 
            FROM 
                GET_STOCKS_ROW_COST,
                SHIP,
                #dsn3_alias#.STOCKS AS STOCKS
            WHERE
                STOCKS.STOCK_ID	= GET_STOCKS_ROW_COST.STOCK_ID
                AND STOCKS.PRODUCT_ID = GET_STOCKS_ROW_COST.PRODUCT_ID
                AND SHIP.SHIP_ID=GET_STOCKS_ROW_COST.UPD_ID
                AND SHIP.SHIP_TYPE=71
                AND GET_STOCKS_ROW_COST.PROCESS_TYPE=SHIP.SHIP_TYPE
                AND SHIP.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
                <cfif isdate(attributes.start_date)>
                    AND SHIP_DATE >= #attributes.start_date#
                </cfif>
                <cfif isdate(attributes.finish_date)>
                    AND SHIP_DATE <= #attributes.finish_date#
                </cfif>		
        </cfif>
        <cfif listfind(secim_liste,7,',')>
			<cfif listfind(secim_liste,10,',')>
	            UNION ALL
            </cfif>
            SELECT 
                2 TYPE,<!--- SARF --->
                MALIYET,
                STOCKS.STOCK_ID,
                STOCKS.PRODUCT_ID,
                STOCKS.STOCK_CODE,
                STOCKS.PRODUCT_NAME,
                PROJECT_ID,
                STOCK_OUT 
            FROM 
                GET_STOCKS_ROW_COST,
                STOCK_FIS,
                #dsn3_alias#.STOCKS AS STOCKS	
            WHERE
                STOCKS.STOCK_ID	= GET_STOCKS_ROW_COST.STOCK_ID
                AND STOCKS.PRODUCT_ID = GET_STOCKS_ROW_COST.PRODUCT_ID
                AND STOCK_FIS.FIS_ID=GET_STOCKS_ROW_COST.UPD_ID
                AND STOCK_FIS.FIS_TYPE=111
                AND GET_STOCKS_ROW_COST.PROCESS_TYPE=STOCK_FIS.FIS_TYPE
                AND STOCK_FIS.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
                <cfif isdate(attributes.start_date)>
                    AND FIS_DATE >= #attributes.start_date#
                </cfif>
                <cfif isdate(attributes.finish_date)>
                    AND FIS_DATE <= #attributes.finish_date#
                </cfif>		
        </cfif>     
        <cfif listfind(secim_liste,17,',')>
			<cfif listfind(secim_liste,10,',')>
	            UNION ALL
            </cfif>
            SELECT 
                4 TYPE,<!--- Fire --->
                MALIYET,
                STOCKS.STOCK_ID,
                STOCKS.PRODUCT_ID,
                STOCKS.STOCK_CODE,
                STOCKS.PRODUCT_NAME,
                PROJECT_ID,
                STOCK_OUT 
            FROM 
                GET_STOCKS_ROW_COST,
                STOCK_FIS,
                #dsn3_alias#.STOCKS AS STOCKS	
            WHERE
                STOCKS.STOCK_ID	= GET_STOCKS_ROW_COST.STOCK_ID
                AND STOCKS.PRODUCT_ID = GET_STOCKS_ROW_COST.PRODUCT_ID
                AND STOCK_FIS.FIS_ID=GET_STOCKS_ROW_COST.UPD_ID
                AND STOCK_FIS.FIS_TYPE=<cfqueryparam value = "112" CFSQLType = "cf_sql_integer"> 
                AND GET_STOCKS_ROW_COST.PROCESS_TYPE=STOCK_FIS.FIS_TYPE
                AND STOCK_FIS.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
                <cfif isdate(attributes.start_date)>
                    AND FIS_DATE >= <cfqueryparam value = "#attributes.start_date#" CFSQLType = "cf_sql_timestamp" >  
                </cfif>
                <cfif isdate(attributes.finish_date)>
                    AND FIS_DATE <= <cfqueryparam value = "#attributes.finish_date#" CFSQLType = "cf_sql_timestamp"> 
                </cfif>		
        </cfif>    
        <cfif listfind(secim_liste,12,',')>
			<cfif listfind(secim_liste,10,',') or listfind(secim_liste,7,',')>
                UNION ALL
            </cfif>
            SELECT 
                3 TYPE,<!--- DEPOLARARASI SEVK --->
                MALIYET,
                STOCKS.STOCK_ID,
                STOCKS.PRODUCT_ID,
                STOCKS.STOCK_CODE,
                STOCKS.PRODUCT_NAME,
                PROJECT_ID,
                STOCK_OUT 
            FROM 
                GET_STOCKS_ROW_COST,
                SHIP,
                #dsn3_alias#.STOCKS AS STOCKS	
            WHERE
                STOCKS.STOCK_ID	= GET_STOCKS_ROW_COST.STOCK_ID
                AND STOCKS.PRODUCT_ID = GET_STOCKS_ROW_COST.PRODUCT_ID
                AND SHIP.SHIP_ID=GET_STOCKS_ROW_COST.UPD_ID
                AND SHIP.SHIP_TYPE=81
                AND GET_STOCKS_ROW_COST.PROCESS_TYPE=SHIP.SHIP_TYPE
                AND SHIP.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
                <cfif isdate(attributes.start_date)>
                    AND SHIP_DATE >= #attributes.start_date#
                </cfif>
                <cfif isdate(attributes.finish_date)>
                    AND SHIP_DATE <= #attributes.finish_date#
                </cfif>
            </cfif>	
        ORDER BY STOCKS.STOCK_ID,STOCKS.PRODUCT_ID	
	</cfquery>
    <cfloop query="get_product_ship_cost">
        <cfif not ListFind(urun_id_list,product_id,',')><!--- Ürün listesinde yoksa --->
            <cfif type eq 1><!--- Toptan satış fatutası --->
                <cfset 'fatura_maliyet_#product_id#_#type#' = maliyet * stock_out><!--- Maliyet çarpı miktar. --->
                <cfset 'fatura_amount_#product_id#_#type#' = stock_out>
            <cfelseif type eq 2><!--- Sarf --->
                <cfset 'sarf_maliyet_#product_id#_#type#' = maliyet * stock_out>
                <cfset 'sarf_amount_#product_id#_#type#' = stock_out>
            <cfelseif type eq 3><!--- Depolararası sevk ise --->
                <cfset 'sevk_maliyet_#product_id#_#type#' = maliyet * stock_out>
                <cfset 'sevk_amount_#product_id#_#type#' = stock_out>
            <cfelseif type eq 4><!--- Fire --->
                <cfset 'fire_maliyet_#product_id#_#type#' = maliyet * stock_out>
                <cfset 'fire_amount_#product_id#_#type#' = stock_out>
            </cfif>
            <cfset urun_id_list = ListAppend(urun_id_list,product_id,',')>
        <cfelse>
            <cfif type eq 1 and not isdefined('fatura_maliyet_#product_id#_#type#')><!--- Toptan satış fatutası ise ve ürüne ait maliyet tanımlı değilse --->
                <cfset 'fatura_maliyet_#product_id#_#type#' = maliyet * stock_out>
                <cfset 'fatura_amount_#product_id#_#type#' = stock_out>
            <cfelseif type eq 1 and  isdefined('fatura_maliyet_#product_id#_#type#')>
                <cfset 'fatura_maliyet_#product_id#_#type#' = (maliyet * stock_out) + (Evaluate('fatura_maliyet_#product_id#_#type#'))>
                <cfset 'fatura_amount_#product_id#_#type#' = stock_out + Evaluate('fatura_amount_#product_id#_#type#')>
            </cfif>
            <cfif type eq 2 and not isdefined('sarf_maliyet_#product_id#_#type#')><!--- sarf ise ve ürüne ait maliyet tanımlı değilse --->
                <cfset 'sarf_maliyet_#product_id#_#type#' = maliyet * stock_out>
                <cfset 'sarf_amount_#product_id#_#type#' = stock_out>
            <cfelseif type eq 2 and  isdefined('sarf_maliyet_#product_id#_#type#')>
                <cfset 'sarf_maliyet_#product_id#_#type#' = (maliyet * stock_out) + (Evaluate('sarf_maliyet_#product_id#_#type#'))>
                <cfset 'sarf_amount_#product_id#_#type#' = stock_out + Evaluate('sarf_amount_#product_id#_#type#')>
            </cfif>
            <cfif type eq 4 and not isdefined('fire_maliyet_#product_id#_#type#')><!--- sarf ise ve ürüne ait maliyet tanımlı değilse --->
                <cfset 'fire_maliyet_#product_id#_#type#' = maliyet * stock_out>
                <cfset 'fire_amount_#product_id#_#type#' = stock_out>
            <cfelseif type eq 4 and  isdefined('fire_maliyet_#product_id#_#type#')>
                <cfset 'fire_maliyet_#product_id#_#type#' = (maliyet * stock_out) + (Evaluate('fire_maliyet_#product_id#_#type#'))>
                <cfset 'fire_amount_#product_id#_#type#' = stock_out + Evaluate('fire_amount_#product_id#_#type#')>
            </cfif>
            <cfif type eq 3 and not isdefined('sevk_maliyet_#product_id#_#type#')><!--- depolar arası sevk  fatutası ise ve ürüne ait maliyet tanımlı değilse --->
                <cfset 'sevk_maliyet_#product_id#_#type#' = maliyet * stock_out>
                <cfset 'sevk_amount_#product_id#_#type#' = stock_out>
            <cfelseif type eq 3 and  isdefined('sevk_maliyet_#product_id#_#type#') >
                <cfset 'sevk_maliyet_#product_id#_#type#' = (maliyet * stock_out) + (Evaluate('sevk_maliyet_#product_id#_#type#'))>
                <cfset 'sevk_amount_#product_id#_#type#' = stock_out + Evaluate('sevk_amount_#product_id#_#type#')>
        	</cfif>
		</cfif>
	</cfloop>
</cfif>

<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfif attributes.maxrows gt 1000>
	<cfset attributes.maxrows = 250>
</cfif>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfif attributes.report_type eq 5>
	<cfparam name="attributes.totalrecords" default="1">
<cfelseif isdefined('get_all_stock')>
	<cfparam name="attributes.totalrecords" default="#get_all_stock.recordcount#">
</cfif>
<cfif isdefined('attributes.is_excel') and  attributes.is_excel eq 1>
    <cfset attributes.startrow=1>
    <cfset attributes.maxrows=get_all_stock.recordcount>
</cfif>
<cfif isdefined('get_all_stock') and get_all_stock.recordcount>
	<cfoutput query="get_all_stock" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
		<cfscript>
			if(get_stock_fis.recordcount neq 0)
			{
				//sarf fisi miktar ve tutarları
				for(i=1;i lte sarf_stock_fis.recordcount;i=i+1)
				{
					if(sarf_stock_fis.groupby_alani[i] eq get_all_stock.report_groupby_id ) 
					{
						'sarf_miktar_#get_all_stock.report_groupby_id#' = sarf_stock_fis.sarf_miktar[i];
						'sarf_tutar_#get_all_stock.report_groupby_id#' = sarf_stock_fis.sarf_tutar[i];
						'sarf_tutar_kdvsiz_#get_all_stock.report_groupby_id#' = sarf_stock_fis.sarf_tutar_kdvsiz[i];
						if (len(session.ep.money2))
						{
							'sarf_doviz_tutar_#get_all_stock.report_groupby_id#' = sarf_stock_fis.sarf_doviz_tutar[i];
							'sarf_doviz_tutar_kdvsiz_#get_all_stock.report_groupby_id#' = sarf_stock_fis.sarf_doviz_tutar_kdvsiz[i];
						}
						break;
					}
				}
				//uretim fisi miktar ve tutarları
				for(t=1;t lte prod_stock_fis.recordcount;t=t+1)
				{
					if(prod_stock_fis.groupby_alani[t] eq get_all_stock.report_groupby_id) 
					{
						'uretim_miktar_#get_all_stock.report_groupby_id#' = prod_stock_fis.uretim_miktar[t];
						'uretim_tutar_#get_all_stock.report_groupby_id#' = prod_stock_fis.uretim_tutar[t];
						'uretim_tutar_kdvsiz_#get_all_stock.report_groupby_id#' = prod_stock_fis.uretim_tutar_kdvsiz[t];
						if (len(session.ep.money2))
						{
							'uretim_doviz_tutar_#get_all_stock.report_groupby_id#' = prod_stock_fis.uretim_doviz_tutar[t];
							'uretim_doviz_tutar_kdvsiz_#get_all_stock.report_groupby_id#' = prod_stock_fis.uretim_doviz_tutar_kdvsiz[t];
						}
						break;
					}
				}
			}
            if(get_stock_fis.recordcount neq 0)
			{
				//sarf fisi miktar ve tutarları
				for(i=1;i lte fire_stock_fis.recordcount;i=i+1)
				{
					if(fire_stock_fis.groupby_alani[i] eq get_all_stock.report_groupby_id ) 
					{
						'fire_miktar_#get_all_stock.report_groupby_id#' = fire_stock_fis.sarf_miktar[i];
						'fire_tutar_#get_all_stock.report_groupby_id#' = fire_stock_fis.sarf_tutar[i];
						'fire_tutar_kdvsiz_#get_all_stock.report_groupby_id#' = fire_stock_fis.sarf_tutar_kdvsiz[i];
						if (len(session.ep.money2))
						{
							'fire_doviz_tutar_#get_all_stock.report_groupby_id#' = fire_stock_fis.sarf_doviz_tutar[i];
							'fire_doviz_tutar_kdvsiz_#get_all_stock.report_groupby_id#' = fire_stock_fis.sarf_doviz_tutar_kdvsiz[i];
						}
						break;
					}
				}
				//uretim fisi miktar ve tutarları
				for(t=1;t lte prod_stock_fis.recordcount;t=t+1)
				{
					if(prod_stock_fis.groupby_alani[t] eq get_all_stock.report_groupby_id) 
					{
						'uretim_miktar_#get_all_stock.report_groupby_id#' = prod_stock_fis.uretim_miktar[t];
						'uretim_tutar_#get_all_stock.report_groupby_id#' = prod_stock_fis.uretim_tutar[t];
						'uretim_tutar_kdvsiz_#get_all_stock.report_groupby_id#' = prod_stock_fis.uretim_tutar_kdvsiz[t];
						if (len(session.ep.money2))
						{
							'uretim_doviz_tutar_#get_all_stock.report_groupby_id#' = prod_stock_fis.uretim_doviz_tutar[t];
							'uretim_doviz_tutar_kdvsiz_#get_all_stock.report_groupby_id#' = prod_stock_fis.uretim_doviz_tutar_kdvsiz[t];
						}
						break;
					}
				}
			}
			//satinalma siparisi miktar ve tutarlari
			for(nb=1; nb lte get_purchase_orders.recordcount; nb=nb+1)
			{
				if(get_purchase_orders.groupby_alani[nb] eq get_all_stock.report_groupby_id) 
				{
					'alis_siparis_miktar_#get_all_stock.report_groupby_id#' = get_purchase_orders.satinalma_siparis_miktar[nb];
					'alis_siparis_tutar_#get_all_stock.report_groupby_id#' = get_purchase_orders.satinalma_siparis_tutar[nb];
					'alis_siparis_tutar_kdvsiz_#get_all_stock.report_groupby_id#' = get_purchase_orders.satinalma_siparis_tutar_kdvsiz[nb];
					if (len(session.ep.money2))
					{
						'alis_siparis_doviz_tutar_#get_all_stock.report_groupby_id#' = get_purchase_orders.satinalma_siparis_doviz_tutar[nb];
						'alis_siparis_doviz_tutar_kdvsiz_#get_all_stock.report_groupby_id#' = get_purchase_orders.satinalma_siparis_doviz_tutar_kdvsiz[nb];
					}
					break;
				}
			}
			//satis siparisi miktar ve tutarlari
			for(tty=1; tty lte get_sale_orders.recordcount; tty=tty+1)
			{
				if( get_sale_orders.groupby_alani[tty] eq get_all_stock.report_groupby_id) 
				{
					'satis_siparis_miktar_#get_all_stock.report_groupby_id#' = get_sale_orders.satis_siparis_miktar[tty];
					'satis_siparis_tutar_#get_all_stock.report_groupby_id#' = get_sale_orders.satis_siparis_tutar[tty];
					'satis_siparis_tutar_kdvsiz_#get_all_stock.report_groupby_id#' = get_sale_orders.satis_siparis_tutar_kdvsiz[tty];
					if (len(session.ep.money2))
					{
						'satis_siparis_doviz_tutar_#get_all_stock.report_groupby_id#' = get_sale_orders.satis_siparis_doviz_tutar[tty];
						'satis_siparis_doviz_tutar_kdvsiz_#get_all_stock.report_groupby_id#' = get_sale_orders.satis_siparis_doviz_tutar_kdvsiz[tty];
					}
					break;
				}
			}
			//alis faturası miktar ve tutarlari
			for(mn=1; mn lte get_inv_purchase.recordcount; mn=mn+1)
			{
				if( get_inv_purchase.groupby_alani[mn] eq get_all_stock.report_groupby_id) 
				{
					'alis_fat_miktar_#get_all_stock.report_groupby_id#' = get_inv_purchase.alis_fat_miktar[mn];
					'alis_fat_tutar_#get_all_stock.report_groupby_id#' = get_inv_purchase.alis_fat_tutar[mn];
					'alis_fat_tutar_kdvsiz_#get_all_stock.report_groupby_id#' = get_inv_purchase.alis_fat_tutar_kdvsiz[mn];
					if (len(session.ep.money2))
					{
					'alis_fat_doviz_tutar_#get_all_stock.report_groupby_id#' = get_inv_purchase.alis_fat_doviz_tutar[mn];
					'alis_fat_doviz_tutar_kdvsiz_#get_all_stock.report_groupby_id#' = get_inv_purchase.alis_fat_doviz_tutar_kdvsiz[mn];
					}
					break;
				}
			}
			//satis faturası miktar ve tutarlari
			for(k=1; k lte get_inv_sale.recordcount; k=k+1)
			{
				if( get_inv_sale.groupby_alani[k] eq get_all_stock.report_groupby_id) 
				{
					'satis_fat_miktar_#get_all_stock.report_groupby_id#' = get_inv_sale.satis_fat_miktar[k];
					'satis_fat_tutar_#get_all_stock.report_groupby_id#' = get_inv_sale.satis_fat_tutar[k];
					'satis_fat_tutar_kdvsiz_#get_all_stock.report_groupby_id#' = get_inv_sale.satis_fat_tutar_kdvsiz[k];
					if (len(session.ep.money2))
					{
					'satis_fat_doviz_tutar_#get_all_stock.report_groupby_id#' = get_inv_sale.satis_fat_doviz_tutar[k];
					'satis_fat_doviz_tutar_kdvsiz_#get_all_stock.report_groupby_id#' = get_inv_sale.satis_fat_doviz_tutar_kdvsiz[k];
					}
					break;
				}
			}
			//malzeme planı miktar ve tutarlari
			for(ggf=1; ggf lte get_pro_material.recordcount; ggf=ggf+1)
			{
				if( get_pro_material.groupby_alani[ggf] eq get_all_stock.report_groupby_id) 
				{
					'pro_material_miktar_#get_all_stock.report_groupby_id#' = get_pro_material.pro_material_miktar[ggf];
					'pro_material_tutar_#get_all_stock.report_groupby_id#' = get_pro_material.pro_material_tutar[ggf];
					'pro_material_tutar_kdvsiz_#get_all_stock.report_groupby_id#' = get_pro_material.pro_material_tutar_kdvsiz[ggf];
					if (len(session.ep.money2))
					{
					'pro_material_doviz_tutar_#get_all_stock.report_groupby_id#' = get_pro_material.pro_material_doviz_tutar[ggf];
					'pro_material_doviz_tutar_kdvsiz_#get_all_stock.report_groupby_id#' = get_pro_material.pro_material_doviz_tutar_kdvsiz[ggf];
					}
					break;
				}
			}
			 //üretim emirleri miktar
			for(por=1; por lte get_production_orders.recordcount; por=por+1)
			{
				if( get_production_orders.groupby_alani[por] eq get_all_stock.report_groupby_id) 
				{
					'uretim_emir_miktar_#get_all_stock.report_groupby_id#' = get_production_orders.uretim_emir_miktar[por];
					'uretim_emir_tutar_#get_all_stock.report_groupby_id#' = get_production_orders.uretim_emir_tutar[por];
					'uretim_emir_tutar_kdvsiz_#get_all_stock.report_groupby_id#' = get_production_orders.uretim_emir_tutar_kdvsiz[por];
					break;
				}
			}
			//iç talepler miktar ve tutarlari
			for(ict=1; ict lte get_internal.recordcount; ict=ict+1)
			{
				if( get_internal.groupby_alani[ict] eq get_all_stock.report_groupby_id) 
				{
					'ic_talep_miktar_#get_all_stock.report_groupby_id#' = get_internal.ic_talep_miktar[ict];
					'ic_talep_tutar_#get_all_stock.report_groupby_id#' = get_internal.ic_talep_tutar[ict];
					'ic_talep_tutar_kdvsiz_#get_all_stock.report_groupby_id#' = get_internal.ic_talep_tutar_kdvsiz[ict];
					if (len(session.ep.money2))
					{
						'ic_talep_doviz_tutar_#get_all_stock.report_groupby_id#' = get_internal.ic_talep_doviz_tutar[ict];
						'ic_talep_doviz_tutar_kdvsiz_#get_all_stock.report_groupby_id#' = get_internal.ic_talep_doviz_tutar_kdvsiz[ict];
					}
					break;
				}
			}
			//satınalma talepleri miktar ve tutarlari
			for(ict=1; ict lte get_purchase_internal.recordcount; ict=ict+1)
			{
				if(get_purchase_internal.groupby_alani[ict] eq get_all_stock.report_groupby_id) 
				{
					'satınalma_talep_miktar_#get_all_stock.report_groupby_id#' = get_purchase_internal.satinalma_talep_miktar[ict];
					'satınalma_talep_tutar_#get_all_stock.report_groupby_id#' = get_purchase_internal.satinalma_talep_tutar[ict];
					'satınalma_talep_tutar_kdvsiz_#get_all_stock.report_groupby_id#' = get_purchase_internal.satinalma_talep_tutar_kdvsiz[ict];
					if (len(session.ep.money2))
					{
						'satınalma_talep_doviz_tutar_#get_all_stock.report_groupby_id#' = get_purchase_internal.satinalma_talep_doviz_tutar[ict];
						'satınalma_talep_doviz_tutar_kdvsiz_#get_all_stock.report_groupby_id#' = get_purchase_internal.satinalma_talep_doviz_tutar_kdvsiz[ict];
					}
					break;
				}
			}
			//üretim talepleri miktar ve tutarlari
			for(ict=1; ict lte get_production_internals.recordcount; ict=ict+1)
			{
				if(get_production_internals.groupby_alani[ict] eq get_all_stock.report_groupby_id) 
				{
					'uretim_talep_miktar_#get_all_stock.report_groupby_id#' = get_production_internals.uretim_talep_miktar[ict];
					'uretim_talep_tutar_#get_all_stock.report_groupby_id#' = get_production_internals.uretim_talep_tutar[ict];
					'uretim_talep_tutar_kdvsiz_#get_all_stock.report_groupby_id#' = get_production_internals.uretim_talep_tutar_kdvsiz[ict];
					/*if (len(session.ep.money2))
					{
						'uretim_talep_doviz_tutar_#get_all_stock.report_groupby_id#' = get_production_internals.uretim_talep_doviz_tutar[ict];
						'uretim_talep_doviz_tutar_kdvsiz_#get_all_stock.report_groupby_id#' = get_production_internals.uretim_talep_doviz_tutar_kdvsiz[ict];
					} */
					break;
				}
			}
			if(get_ship_rows.recordcount neq 0)
			{
				//alıs irsaliyesi miktar ve tutarlari
				for(jjh=1; jjh lte alis_irs.recordcount; jjh=jjh+1)
				{
					if( alis_irs.groupby_alani[jjh] eq get_all_stock.report_groupby_id) 
					{
						'alis_irs_miktar_#get_all_stock.report_groupby_id#' = alis_irs.alis_irs_miktar[jjh];
						'alis_irs_tutar_#get_all_stock.report_groupby_id#' = alis_irs.alis_irs_tutar[jjh];
						'alis_irs_tutar_kdvsiz_#get_all_stock.report_groupby_id#' = alis_irs.alis_irs_tutar_kdvsiz[jjh];
						if (len(session.ep.money2))
						{
						'alis_irs_doviz_tutar_#get_all_stock.report_groupby_id#' = alis_irs.alis_irs_doviz_tutar[jjh];
						'alis_irs_doviz_tutar_kdvsiz_#get_all_stock.report_groupby_id#' = alis_irs.alis_irs_doviz_tutar_kdvsiz[jjh];
						}
						break;
					}
				}
				//satis irsaliyesi miktar ve tutarlari
				for(xxx=1; xxx lte satis_irs.recordcount; xxx=xxx+1)
				{
					if( satis_irs.groupby_alani[xxx] eq get_all_stock.report_groupby_id) 
					{
						'satis_irs_miktar_#get_all_stock.report_groupby_id#' = satis_irs.satis_irs_miktar[xxx];
						'satis_irs_tutar_#get_all_stock.report_groupby_id#' = satis_irs.satis_irs_tutar[xxx];
						'satis_irs_tutar_kdvsiz_#get_all_stock.report_groupby_id#' = satis_irs.satis_irs_tutar_kdvsiz[xxx];
						if (len(session.ep.money2))
						{
						'satis_irs_doviz_tutar_#get_all_stock.report_groupby_id#' = satis_irs.satis_irs_doviz_tutar[xxx];
						'satis_irs_doviz_tutar_kdvsiz_#get_all_stock.report_groupby_id#' = satis_irs.satis_irs_doviz_tutar_kdvsiz[xxx];
						}
						break;
					}
				}
				//ithal mal girisi irsaliyesi miktar ve tutarlari
				for(jxx=1; jxx lte ithalat_irs.recordcount; jxx=jxx+1)
				{
					if( ithalat_irs.groupby_alani[jxx] eq get_all_stock.report_groupby_id) 
					{
						'ithalat_irs_miktar_#get_all_stock.report_groupby_id#' = ithalat_irs.ith_irs_miktar[jxx];
						'ithalat_irs_tutar_#get_all_stock.report_groupby_id#' = ithalat_irs.ith_irs_tutar[jxx];
						'ithalat_irs_tutar_kdvsiz_#get_all_stock.report_groupby_id#' = ithalat_irs.ith_irs_tutar_kdvsiz[jxx];
						if (len(session.ep.money2))
						{
						'ithalat_irs_doviz_tutar_#get_all_stock.report_groupby_id#' = ithalat_irs.ith_irs_doviz_tutar[jxx];
						'ithalat_irs_doviz_tutar_kdvsiz_#get_all_stock.report_groupby_id#' = ithalat_irs.ith_irs_doviz_tutar_kdvsiz[jxx];
						}
						break;
					}
				}
				//depolararası sevk irs miktar ve tutarlari
				for(dpa=1; dpa lte depo_irs.recordcount; dpa=dpa+1)
				{
					if( depo_irs.groupby_alani[dpa] eq get_all_stock.report_groupby_id) 
					{
						'depo_irs_miktar_#get_all_stock.report_groupby_id#' = depo_irs.depo_irs_miktar[dpa];
						'depo_irs_tutar_#get_all_stock.report_groupby_id#' = depo_irs.depo_irs_tutar[dpa];
						'depo_irs_tutar_kdvsiz_#get_all_stock.report_groupby_id#' = depo_irs.depo_irs_tutar_kdvsiz[dpa];
						if (len(session.ep.money2))
						{
						'depo_irs_doviz_tutar_#get_all_stock.report_groupby_id#' = depo_irs.depo_irs_doviz_tutar[dpa];
						'depo_irs_doviz_tutar_kdvsiz_#get_all_stock.report_groupby_id#' = depo_irs.depo_irs_doviz_tutar_kdvsiz[dpa];
						}
						break;
					}
				}
			}
		</cfscript>
	</cfoutput>
<cfelseif attributes.report_type eq 5>
	<cfscript>
		//miktar_toplam ve tutar_toplam yanındaki rakamlar işlem tipine göre manual olarak verilmiştir,aşağıda her işlem tipi için kullanılmaktadır..YD
		if(get_pro_material.recordcount neq 0)
		{
			'miktar_toplam_1' = get_pro_material.pro_material_miktar;
			'tutar_toplam_1' = get_pro_material.pro_material_tutar;
			'tutar_toplam_1_kdvsiz' = get_pro_material.pro_material_tutar_kdvsiz;
			if (len(session.ep.money2))
			{
				'tutar_doviz_toplam_1' = get_pro_material.pro_material_doviz_tutar;
				'tutar_doviz_toplam_1_kdvsiz' = get_pro_material.pro_material_doviz_tutar_kdvsiz;
			}
		}
		//üretim emirleri miktar
		if(get_production_orders.recordcount neq 0)
		{
			'miktar_toplam_14' = get_production_orders.uretim_emir_miktar;
			'tutar_toplam_14' = get_production_orders.uretim_emir_tutar;//neden miktar yazılmış
			'tutar_toplam_14_kdvsiz' = get_production_orders.uretim_emir_tutar_kdvsiz;
			
		}
		if(get_purchase_orders.recordcount neq 0)
		{
			'miktar_toplam_2' = get_purchase_orders.satinalma_siparis_miktar;
			'tutar_toplam_2' = get_purchase_orders.satinalma_siparis_tutar;
			'tutar_toplam_2_kdvsiz' = get_purchase_orders.satinalma_siparis_tutar_kdvsiz;
			if (len(session.ep.money2))
			{
				'tutar_doviz_toplam_2' = get_purchase_orders.satinalma_siparis_doviz_tutar;
				'tutar_doviz_toplam_2_kdvsiz' = get_purchase_orders.satinalma_siparis_doviz_tutar_kdvsiz;
			}
		}
		if(get_sale_orders.recordcount neq 0)
		{
			'miktar_toplam_3' = get_sale_orders.satis_siparis_miktar;
			'tutar_toplam_3' = get_sale_orders.satis_siparis_tutar;
			'tutar_toplam_3_kdvsiz' = get_sale_orders.satis_siparis_tutar_kdvsiz;
			if (len(session.ep.money2))
			{
				'tutar_doviz_toplam_3' = get_sale_orders.satis_siparis_doviz_tutar;
				'tutar_doviz_toplam_3_kdvsiz' = get_sale_orders.satis_siparis_doviz_tutar_kdvsiz;
			}
		}
		if(get_ship_rows.recordcount neq 0)
		//alıs irsaliyesi miktar ve tutar toplamları
		{
			if(alis_irs.recordcount neq 0)
			{
				'miktar_toplam_4' = alis_irs.alis_irs_miktar;
				'tutar_toplam_4' = alis_irs.alis_irs_tutar;
				'tutar_toplam_4_kdvsiz' = alis_irs.alis_irs_tutar_kdvsiz;
				if (len(session.ep.money2))
				{
					'tutar_doviz_toplam_4' = alis_irs.alis_irs_doviz_tutar;
					'tutar_doviz_toplam_4_kdvsiz' = alis_irs.alis_irs_doviz_tutar_kdvsiz;
				}
			}
			//satis irsaliyesi miktar ve tutar toplamları
			if(satis_irs.recordcount neq 0)
			{
				'miktar_toplam_5' = satis_irs.satis_irs_miktar;
				'tutar_toplam_5' = satis_irs.satis_irs_tutar;
				'tutar_toplam_5_kdvsiz' = satis_irs.satis_irs_tutar_kdvsiz;
				if (len(session.ep.money2))
				{
					'tutar_doviz_toplam_5' = satis_irs.satis_irs_doviz_tutar;
					'tutar_doviz_toplam_5_kdvsiz' = satis_irs.satis_irs_doviz_tutar_kdvsiz;
				}
			}
			//ithalat irsaliyesi miktar ve tutar toplamları
			if(ithalat_irs.recordcount neq 0)
			{
				'miktar_toplam_6' = ithalat_irs.ith_irs_miktar;
				'tutar_toplam_6' = ithalat_irs.ith_irs_tutar;
				'tutar_toplam_6_kdvsiz' = ithalat_irs.ith_irs_tutar_kdvsiz;
				if (len(session.ep.money2))
				{
					'tutar_doviz_toplam_6' = ithalat_irs.ith_irs_doviz_tutar;
					'tutar_doviz_toplam_6_kdvsiz' = ithalat_irs.ith_irs_doviz_tutar_kdvsiz;
				}
			}
			//depolararası sevk irsaliyesi miktar ve tutar toplamları
			if(depo_irs.recordcount neq 0)
			{
				'miktar_toplam_12' = depo_irs.depo_irs_miktar;
				'tutar_toplam_12' = depo_irs.depo_irs_tutar;
				'tutar_toplam_12_kdvsiz' = depo_irs.depo_irs_tutar_kdvsiz;
				if (len(session.ep.money2))
				{
					'tutar_doviz_toplam_12' = depo_irs.depo_irs_doviz_tutar;
					'tutar_doviz_toplam_12_kdvsiz' = depo_irs.depo_irs_doviz_tutar_kdvsiz;
				}
			}
		}
		if(get_stock_fis.recordcount neq 0)
		//sarf fisi miktar ve tutar toplamları
		{
			if(sarf_stock_fis.recordcount neq 0)
			{
				'miktar_toplam_7' = sarf_stock_fis.sarf_miktar;
				'tutar_toplam_7' = sarf_stock_fis.sarf_tutar;
				'tutar_toplam_7_kdvsiz' = sarf_stock_fis.sarf_tutar_kdvsiz;
				if (len(session.ep.money2))
				{
					'tutar_doviz_toplam_7' = sarf_stock_fis.sarf_doviz_tutar;
					'tutar_doviz_toplam_7_kdvsiz' = sarf_stock_fis.sarf_doviz_tutar_kdvsiz;
				}
			}
			if(prod_stock_fis.recordcount neq 0)
			{
				'miktar_toplam_8' = prod_stock_fis.uretim_miktar;
				'tutar_toplam_8' = prod_stock_fis.uretim_tutar;
				'tutar_toplam_8_kdvsiz' = prod_stock_fis.uretim_tutar_kdvsiz;
				if (len(session.ep.money2))
				{
					'tutar_doviz_toplam_8' = prod_stock_fis.uretim_doviz_tutar;
					'tutar_doviz_toplam_8_kdvsiz' = prod_stock_fis.uretim_doviz_tutar_kdvsiz;
				}
			}
		}
		if(get_inv_purchase.recordcount neq 0)
		{
			'miktar_toplam_9' = get_inv_purchase.alis_fat_miktar;
			'tutar_toplam_9' = get_inv_purchase.alis_fat_tutar;
			'tutar_toplam_9_kdvsiz' = get_inv_purchase.alis_fat_tutar_kdvsiz;
			if (len(session.ep.money2))
			{
				'tutar_doviz_toplam_9' = get_inv_purchase.alis_fat_doviz_tutar;
				'tutar_doviz_toplam_9_kdvsiz' = get_inv_purchase.alis_fat_doviz_tutar_kdvsiz;
			}
		}
		if(get_inv_sale.recordcount neq 0)
		{
			'miktar_toplam_10' = get_inv_sale.satis_fat_miktar;
			'tutar_toplam_10' = get_inv_sale.satis_fat_tutar;
			'tutar_toplam_10_kdvsiz' = get_inv_sale.satis_fat_tutar_kdvsiz;
			if (len(session.ep.money2))
			{
				'tutar_doviz_toplam_10' = get_inv_sale.satis_fat_doviz_tutar;
				'tutar_doviz_toplam_10_kdvsiz' = get_inv_sale.satis_fat_doviz_tutar_kdvsiz;
			}
		}
		if(get_internal.recordcount neq 0)
		{
			'miktar_toplam_13' = get_internal.ic_talep_miktar;
			'tutar_toplam_13' = get_internal.ic_talep_tutar;
			'tutar_toplam_13_kdvsiz' = get_internal.ic_talep_tutar_kdvsiz;
			if (len(session.ep.money2))
			{
				'tutar_doviz_toplam_13_kdvsiz' = get_internal.ic_talep_doviz_tutar_kdvsiz;
			}
		}
		if(get_purchase_internal.recordcount neq 0)
		{
			'miktar_toplam_15' = get_purchase_internal.satinalma_talep_miktar;
			'tutar_toplam_15' = get_purchase_internal.satinalma_talep_tutar;
			'tutar_toplam_15_kdvsiz' = get_purchase_internal.satinalma_talep_tutar_kdvsiz;
			if (len(session.ep.money2))
			{
				'tutar_doviz_toplam_15_kdvsiz' = get_purchase_internal.satinalma_talep_doviz_tutar_kdvsiz;
			}
		}
		if(get_production_internals.recordcount neq 0)
		{
			'miktar_toplam_16' = get_production_internals.uretim_talep_miktar;
			'tutar_toplam_16' = get_production_internals.uretim_talep_tutar;
			'tutar_toplam_16_kdvsiz' = get_production_internals.uretim_talep_tutar_kdvsiz;
			/*if (len(session.ep.money2))
			{
				'tutar_doviz_toplam_16_kdvsiz' = get_production_internals.uretim_talep_doviz_tutar_kdvsiz;
			} */
		}
	</cfscript>
</cfif><!-- sil -->

<cfsavecontent variable="head"><cf_get_lang dictionary_id='39439.Proje Malzeme ve İhtiyaç Raporu'></cfsavecontent>
<cfform name="search_form" action="#request.self#?fuseaction=#submit_url#" method="post">
    <cf_report_list_search title="#head#">
        <cf_report_list_search_area>
            <div class="row">
                <div class="col col-12 col-xs-12">
                    <div class="row formContent">
                        <div class="row" type="row">
                            <div class="col col-3 col-md-4 col-sm-6 col-xs-12">
                                <div class="col col-12 col-md-12 col-xs-12">
                                    <div class="form-group">
                                        <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57416.Proje'>*</label>
                                        <div class="col col-12 col-xs-12">
                                            <div class="input-group">
                                                <cfoutput>
                                                    <input type="hidden" name="pro_met_id" id="pro_met_id" value="<cfif isdefined('attributes.pro_met_id') and len(attributes.pro_met_id)>#attributes.pro_met_id#</cfif>">
                                                    <input type="hidden" name="project_id" id="project_id" value="<cfif len(attributes.project_id)>#attributes.project_id#</cfif>">
                                                    <input type="text" name="project_head" id="project_head" onfocus="AutoComplete_Create('project_head','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','project_work','3','250');" value="<cfif len(attributes.project_id)>#attributes.project_head#</cfif>" autocomplete="off">
                                                    <span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_projects&project_id=search_form.project_id&project_head=search_form.project_head');"> </span>
                                                </cfoutput>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='58960.Rapor Tipi'></label>
                                        <div class="col col-12 col-xs-12">
                                            <cfif isdefined("attributes.report_type") and len(attributes.report_type)>
                                                <select name="report_type" id="report_type" onchange="get_process_types(this.value)">
                                                    <option value="1" <cfif attributes.report_type eq 1>selected</cfif>><cf_get_lang dictionary_id ='39054.Stok Bazında'></option>
                                                    <option value="2" <cfif attributes.report_type eq 2>selected</cfif>><cf_get_lang dictionary_id ='39349.Tedarikçi Bazında'></option>
                                                    <option value="3" <cfif attributes.report_type eq 3>selected</cfif>><cf_get_lang dictionary_id ='39095.Marka Bazında'></option>
                                                    <option value="4" <cfif attributes.report_type eq 4>selected</cfif>><cf_get_lang dictionary_id ='39052.Kategori Bazında'></option>
                                                    <option value="5" <cfif attributes.report_type eq 5>selected</cfif>><cf_get_lang dictionary_id ='40040.Kümülatif Bazda'></option>
                                                    <option value="6" <cfif attributes.report_type eq 6>selected</cfif>><cf_get_lang dictionary_id ='40041.Maliyet Bazında'></option>
                                                </select>
                                            </cfif>
                                        </div>					
                                    </div>
                                    <div class="form-group">
                                        <label><input type="checkbox" name="is_inventory" id="is_inventory" value="1" <cfif isDefined('attributes.is_inventory') and attributes.is_inventory eq 1>checked</cfif>/> <cf_get_lang dictionary_id='40197.Envantere Dahil Olmayan Ürünler'></label>				
                                    </div>
                                </div>
                            </div>
                            <div class="col col-3 col-md-4 col-sm-6 col-xs-12">
                                <div class="col col-12 col-md-12 col-xs-12">
                                    <div class="form-group">
                                        <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='40170.Listeleme Sçenekleri'>*</label>
                                        <div class="col col-12 col-md-12 col-xs-12">
                                            <cfif isdefined("attributes.report_type") and len(attributes.report_type)>
                                                <select name="listing_type" id="listing_type" multiple>
                                                    <cfif attributes.report_type neq 6><option value="1" <cfif listfind(attributes.listing_type,1)>selected</cfif>><cf_get_lang dictionary_id='58123.Planlama'></option></cfif>
                                                    <cfif attributes.report_type neq 6><option value="2" <cfif listfind(attributes.listing_type,2)>selected </cfif>><cf_get_lang dictionary_id='39499.Alış Siparişleri'></option></cfif>
                                                    <cfif attributes.report_type neq 6><option value="3" <cfif listfind(attributes.listing_type,3)>selected</cfif>><cf_get_lang dictionary_id='58207.Satış Siparişleri'></option></cfif>
                                                    <cfif attributes.report_type neq 6><option value="4" <cfif listfind(attributes.listing_type,4)>selected</cfif>><cf_get_lang dictionary_id='39500.Alış İrsaliyeleri'></option></cfif>
                                                    <cfif attributes.report_type neq 6><option value="5" <cfif listfind(attributes.listing_type,5)>selected</cfif>><cf_get_lang dictionary_id='39502.Satış İrsaliyeleri'></option></cfif>
                                                    <cfif attributes.report_type neq 6><option value="6" <cfif listfind(attributes.listing_type,6)>selected</cfif>><cf_get_lang dictionary_id='39495.İthalat'></option></cfif>
                                                    <option value="7" <cfif listfind(attributes.listing_type,7)>selected</cfif>><cf_get_lang dictionary_id='30009.Sarf'></option>
                                                    <cfif attributes.report_type neq 6><option value="8" <cfif listfind(attributes.listing_type,8)>selected</cfif>><cf_get_lang dictionary_id='39088.Üretim Fişleri'></option></cfif>
                                                    <cfif attributes.report_type neq 6><option value="9" <cfif listfind(attributes.listing_type,9)>selected</cfif>><cf_get_lang dictionary_id='39503.Alış Faturaları'></option></cfif>
                                                    <option value="10" <cfif listfind(attributes.listing_type,10)>selected</cfif>><cf_get_lang dictionary_id='39504.Satış Faturaları'></option>
                                                    <cfif attributes.report_type neq 6><option value="11" <cfif listfind(attributes.listing_type,11)>selected</cfif>><cf_get_lang dictionary_id='39506.Hakediş'></option></cfif>
                                                    <option value="12" <cfif listfind(attributes.listing_type,12)>selected</cfif>><cf_get_lang dictionary_id ='40038.Depolar arası Sevk'></option>
                                                    <cfif attributes.report_type neq 6><option value="13" <cfif listfind(attributes.listing_type,13)>selected</cfif>><cf_get_lang dictionary_id ='40039.İç Talepler'></option></cfif>
                                                    <cfif attributes.report_type neq 6><option value="14" <cfif listfind(attributes.listing_type,14)>selected</cfif>><cf_get_lang dictionary_id ='40037.Üretim Emirleri'></option></cfif>
                                                    <cfif attributes.report_type neq 6><option value="15" <cfif listfind(attributes.listing_type,13)>selected</cfif>><cf_get_lang dictionary_id ='33263.Satınalma Talepleri'></option></cfif>
                                                    <cfif attributes.report_type neq 6><option value="16" <cfif listfind(attributes.listing_type,14)>selected</cfif>><cf_get_lang dictionary_id ='47243.Üretim Talepleri'></option></cfif>
                                                    <option value="17" <cfif listfind(attributes.listing_type,17)>selected</cfif>><cf_get_lang dictionary_id='29471.Fire'></option>
                                                </select>
                                            </cfif>
                                        </div>					
                                    </div>
                                </div>
                            </div>
                            <div class="col col-3 col-md-4 col-sm-6 col-xs-12">
                                <div class="col col-12 col-md-12 col-xs-12">
                                    <div class="form-group">
                                        <div class="col col-12 col-md-12 col-xs-12">
                                            <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id ='57501.Başlangıç'></label>
                                            <div class="input-group">
                                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='47709.Kayıt Tarihini Kontrol Ediniz!'>!</cfsavecontent> 
                                                <cfinput type="text" name="start_date" id="start_date" maxlength="10" value="#dateformat(attributes.start_date,dateformat_style)#" validate="#validate_style#" message="#message#">
                                                <span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <div class="col col-12 col-md-12 col-xs-12">
                                            <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id ='57502.Bitiş'></label>
                                            <div class="input-group">
                                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='47709.Kayıt Tarihini Kontrol Ediniz!'>!</cfsavecontent>
                                                <cfinput type="text" name="finish_date" id="finish_date" maxlength="10" value="#dateformat(attributes.finish_date,dateformat_style)#" validate="#validate_style#" message="#message#">
                                                <span class="input-group-addon"><cf_wrk_date_image date_field="finish_date"></span>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="col col-3 col-md-4 col-sm-6 col-xs-12">
                                <div class="col col-12 col-md-12 col-xs-12">
                                    <div class="form-group">
                                        <label class="col col-12 col-md-12 col-xs-12"><cf_get_lang dictionary_id ='57800.İşlem Tipi'></label>
                                            <div class="col col-12 col-md-12 col-xs-12">
                                                <cfif isdefined("attributes.report_type") and len(attributes.report_type)>
                                                    <select name="process_type" id="process_type" multiple>
                                                        <cfoutput query="get_process_cat" group="process_type">
                                                            <option value="#process_type#-0" <cfif listfindnocase(attributes.process_type,'#process_type#-0',',')> selected</cfif>>#get_process_name(process_type)#</option>										
                                                            <cfoutput>
                                                                <option value="#process_type#-#process_cat_id#" <cfif listfindnocase(attributes.process_type,'#process_type#-#process_cat_id#',',')>selected</cfif>>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#process_cat#</option>
                                                            </cfoutput>
                                                        </cfoutput>
                                                    </select> 
                                                </cfif>
                                            </div>					
                                        </div>
                                    </div>
                                </div>
                            </div>
                        
                    </div>
                    <div class="row ReportContentBorder">
                        <div class="ReportContentFooter">
                            <label><input type="checkbox" name="is_excel" id="is_excel" value="1" <cfif attributes.is_excel eq 1>checked</cfif>><cf_get_lang dictionary_id='57858.Excel Getir'></label>
                            <input type="hidden" name="is_form_submitted" id="is_form_submitted" value="1">
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
                            <cfif session.ep.our_company_info.is_maxrows_control_off eq 1>
                            <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" message="#message#" maxlength="3" style="width:25px;">
                            <cfelse>
                            <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,250" message="#message#" maxlength="3" style="width:25px;">
                            </cfif>
                                <cf_wrk_report_search_button button_type='1' is_excel="1" search_function="control()">
                        </div>
                    </div>
                </div>   
            </div>
        </cf_report_list_search_area>
    </cf_report_list_search>  
</cfform>
<cfif attributes.is_excel eq 1>
	<cfset type_ = 1>
	<cfset filename = "#createuuid()#">
	<cfheader name="Expires" value="#Now()#">
	<cfcontent type="application/vnd.msexcel;charset=utf-8">
	<cfheader name="Content-Disposition" value="attachment; filename=#filename#.xls">
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cfelse>
	<cfset type_ = 0>
</cfif>
<cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
    <cfset attributes.startrow=1>
    <cfset attributes.maxrows=GET_ALL_STOCK.recordcount>
</cfif>
<cfif isdefined("attributes.is_form_submitted")>
    <cf_report_list> 
        <thead>
            <tr>
            <cfif attributes.report_type neq 5>
                <cfif attributes.report_type eq 6>
                    <th colspan="4" rowspan="2">
                        <cf_get_lang dictionary_id='57657.Ürün'> <cf_get_lang dictionary_id='57989.ve'> <cf_get_lang dictionary_id='39489.Hizmetler'>
                    </th>
                    <cfif listfind(attributes.listing_type,10)>
                        <th colspan="2"><cf_get_lang dictionary_id='30096.Satış Fatura'></th>
                    </cfif>
                    <cfif listfind(attributes.listing_type,7)>
                        <th colspan="2"><cf_get_lang dictionary_id='30009.Sarf'></th>
                    </cfif>
                    <cfif listfind(attributes.listing_type,17)>
                        <th colspan="2"><cf_get_lang dictionary_id='29471.Fire'></th>
                    </cfif>
                    <cfif listfind(attributes.listing_type,12)>
                        <th colspan="2"><cf_get_lang dictionary_id ='39192.Depolararası Sevk İrsaliye'></th>
                    </cfif>
                <cfelse>
                    <cfif attributes.report_type eq 1>
                        <th colspan="4" rowspan="2"><cf_get_lang dictionary_id='57657.Ürün'> <cf_get_lang dictionary_id='57989.ve'> <cf_get_lang dictionary_id='39489.Hizmetler'></th>
                    <cfelseif attributes.report_type eq 2>
                        <th colspan="2" rowspan="2"><cf_get_lang dictionary_id='29533.Tedarikçi'></th>
                    <cfelseif attributes.report_type eq 3>
                        <th width="100" rowspan="2" colspan="2"><cf_get_lang dictionary_id='58847.Marka'> </th>
                    <cfelseif attributes.report_type eq 4>
                        <!---<th rowspan="2"><cf_get_lang dictionary_id ='58585.Kod '></th>--->
                        <th colspan="3" rowspan="2"><cf_get_lang dictionary_id ='57486.Kategori '></th>
                    </cfif>
                    <cfif len(session.ep.money2) and attributes.report_type neq 6>
                        <cfset colspan_money_ = 7>
                    <cfelse>
                        <cfset colspan_money_ = 5>
                    </cfif>
                    <cfoutput>
                    <cfif listfind(attributes.listing_type,1)>
                        <th colspan="#colspan_money_#"><cf_get_lang dictionary_id='58123.Planlama'></th>
                    </cfif>
                    <cfif listfind(attributes.listing_type,2)>
                        <th colspan="#colspan_money_#"><cf_get_lang dictionary_id='58176.Alış'> <cf_get_lang dictionary_id='57611.Sipariş'></th>
                    </cfif>
                    <cfif listfind(attributes.listing_type,3)>
                        <th colspan="#colspan_money_#"><cf_get_lang dictionary_id='57448.Satış'> <cf_get_lang dictionary_id='57611.Sipariş'></th>
                    </cfif>
                    <cfif listfind(attributes.listing_type,4)>
                        <th colspan="#colspan_money_#"><cf_get_lang dictionary_id='58176.Alış'> <cf_get_lang dictionary_id='57773.İrsaliye'></th>
                    </cfif>
                    <cfif listfind(attributes.listing_type,6)>
                        <th colspan="#colspan_money_#"><cf_get_lang dictionary_id='39495.İthalat'></th>
                    </cfif>
                    <cfif listfind(attributes.listing_type,5)>
                        <th colspan="#colspan_money_#"><cf_get_lang dictionary_id='57448.Satış'> <cf_get_lang dictionary_id='57773.İrsaliye'></th>
                    </cfif>
                    <cfif listfind(attributes.listing_type,7)>
                        <th colspan="#colspan_money_#"><cf_get_lang dictionary_id='30009.Sarf'></th>
                    </cfif>
                    <cfif listfind(attributes.listing_type,17)>
                        <th colspan="#colspan_money_#"><cf_get_lang dictionary_id='29471.Fire'></th>
                    </cfif>
                    <cfif listfind(attributes.listing_type,8)>
                        <th colspan="#colspan_money_#"><cf_get_lang dictionary_id='39088.Üretim Fişleri'></th>
                    </cfif>
                    <cfif listfind(attributes.listing_type,9)>
                        <th colspan="#colspan_money_#" ><cf_get_lang dictionary_id='58176.Alış'> <cf_get_lang dictionary_id='57441.Fatura'></th>
                    </cfif>
                    <cfif listfind(attributes.listing_type,10)>
                        <th colspan="#colspan_money_#"><cf_get_lang dictionary_id='57448.Satış'> <cf_get_lang dictionary_id='57441.Fatura'></th>
                    </cfif>
                    <cfif listfind(attributes.listing_type,11)>
                        <th colspan="#colspan_money_#"><cf_get_lang dictionary_id='39506.Hakediş'></th>
                    </cfif>
                    <cfif listfind(attributes.listing_type,12)>
                        <th colspan="#colspan_money_#"><cf_get_lang dictionary_id ='39192.Depolararası Sevk İrsaliye'></th>
                    </cfif>
                    <cfif listfind(attributes.listing_type,13)>
                        <th colspan="#colspan_money_#"><cf_get_lang dictionary_id ='40039.İç Talepler'></th>
                    </cfif>
                    <cfif listfind(attributes.listing_type,14)>
                        <th colspan="2"><cf_get_lang dictionary_id='40037.Üretim Emirleri'></th>
                    </cfif>
                    <cfif listfind(attributes.listing_type,15)>
                        <th colspan="#colspan_money_#"><cf_get_lang dictionary_id='33263.Satınalma Talepleri'></th>
                    </cfif>
                    <cfif listfind(attributes.listing_type,16)>
                        <th colspan="#colspan_money_#"><cf_get_lang dictionary_id='47243.Üretim Talepleri'></th>
                    </cfif>
                    </cfoutput>
                </cfif>
            <cfelse>
                <th colspan="8"><cf_get_lang dictionary_id ='40040.Kümülatif Bazda'></th>
            </cfif>
            </tr>
            <cfif isdefined("is_form_submitted")>
            <tr align="center">
                <cfif attributes.report_type neq 5>
                    <cfif listfind(attributes.listing_type,1)>
                        <th><cf_get_lang dictionary_id ='57635.Miktar'></th>
                        <th><cf_get_lang dictionary_id ='57673.Tutar'></th>
                        <th colspan="2"><cf_get_lang dictionary_id ='40042.Tutar kdv siz'></th>
                        <cfif len(session.ep.money2) and attributes.report_type neq 6>
                            <th><cf_get_lang dictionary_id ='39656.Döviz Tutar'></th>
                            <th colspan="2"><cf_get_lang dictionary_id ='40043.Döviz Tutar kdvsiz'></th>
                        </cfif>
                    </cfif>
                    <cfif listfind(attributes.listing_type,2)>
                        <th><cf_get_lang dictionary_id ='57635.Miktar'></th>
                        <th><cf_get_lang dictionary_id ='57673.Tutar'></th>
                        <th colspan="2"><cf_get_lang dictionary_id ='40042.Tutar kdv siz'></th>
                        <cfif len(session.ep.money2) and attributes.report_type neq 6>
                            <th><cf_get_lang dictionary_id ='39656.Döviz Tutar'></th>
                            <th colspan="2"><cf_get_lang dictionary_id ='40043.Döviz Tutar kdvsiz'></th>
                        </cfif>
                    </cfif>
                    <cfif listfind(attributes.listing_type,3)>
                        <th><cf_get_lang dictionary_id ='57635.Miktar'></th>
                        <th><cf_get_lang dictionary_id ='57673.Tutar'></th>
                        <th colspan="2"><cf_get_lang dictionary_id ='40042.Tutar kdv siz'></th>
                        <cfif len(session.ep.money2) and attributes.report_type neq 6>
                            <th><cf_get_lang dictionary_id ='39656.Döviz Tutar'></th>
                            <th colspan="2"><cf_get_lang dictionary_id ='40043.Döviz Tutar kdvsiz'></th>
                        </cfif>
                    </cfif>
                    <cfif listfind(attributes.listing_type,4)>
                        <th><cf_get_lang dictionary_id ='57635.Miktar'></th>
                        <th><cf_get_lang dictionary_id ='57673.Tutar'></th>
                        <th colspan="2"><cf_get_lang dictionary_id ='40042.Tutar kdv siz'></th>
                        <cfif len(session.ep.money2) and attributes.report_type neq 6>
                            <th><cf_get_lang dictionary_id ='39656.Döviz Tutar'></th>
                            <th colspan="2"><cf_get_lang dictionary_id ='40043.Döviz Tutar kdvsiz'></th>
                        </cfif>
                    </cfif>
                    <cfif listfind(attributes.listing_type,6)>
                        <th><cf_get_lang dictionary_id ='57635.Miktar'></th>
                        <th><cf_get_lang dictionary_id ='57673.Tutar'></th>
                        <th colspan="2"><cf_get_lang dictionary_id ='40042.Tutar kdv siz'></th>
                        <cfif len(session.ep.money2) and attributes.report_type neq 6>
                            <th><cf_get_lang dictionary_id ='39656.Döviz Tutar'></th>
                            <th colspan="2"><cf_get_lang dictionary_id ='40043.Döviz Tutar kdvsiz'></th>
                        </cfif>
                    </cfif>
                    <cfif listfind(attributes.listing_type,5)>
                        <th><cf_get_lang dictionary_id ='57635.Miktar'></th>
                        <th><cf_get_lang dictionary_id ='57673.Tutar'></th>
                        <th colspan="2"><cf_get_lang dictionary_id ='40042.Tutar kdv siz'></th>
                        <cfif len(session.ep.money2) and attributes.report_type neq 6>
                            <th><cf_get_lang dictionary_id ='39656.Döviz Tutar'></th>
                            <th colspan="2"><cf_get_lang dictionary_id ='40043.Döviz Tutar kdvsiz'></th>
                        </cfif>
                    </cfif>
                    <cfif listfind(attributes.listing_type,7)><!--- Sarf --->
                        <th width="100"><cf_get_lang dictionary_id ='57635.Miktar'></th>
                        <th width="100"><cf_get_lang dictionary_id ='57673.Tutar'></th>
                        <cfif attributes.report_type neq 6>
                            <th colspan="2"><cf_get_lang dictionary_id ='40042.Tutar kdv siz'></th>
                        </cfif>
                        <cfif len(session.ep.money2) and attributes.report_type neq 6>
                            <th><cf_get_lang dictionary_id ='39656.Döviz Tutar'></th>
                            <cfif attributes.report_type neq 6>
                                <th colspan="2"><cf_get_lang dictionary_id ='40043.Döviz Tutar kdvsiz'></th>
                            </cfif>
                        </cfif>
                    </cfif>
                    <cfif listfind(attributes.listing_type,17)><!--- Sarf --->
                        <th width="100"><cf_get_lang dictionary_id ='57635.Miktar'></th>
                        <th width="100"><cf_get_lang dictionary_id ='57673.Tutar'></th>
                        <cfif attributes.report_type neq 6>
                            <th colspan="2"><cf_get_lang dictionary_id ='40042.Tutar kdv siz'></th>
                        </cfif>
                        <cfif len(session.ep.money2) and attributes.report_type neq 6>
                            <th><cf_get_lang dictionary_id ='39656.Döviz Tutar'></th>
                            <cfif attributes.report_type neq 6>
                                <th colspan="2"><cf_get_lang dictionary_id ='40043.Döviz Tutar kdvsiz'></th>
                            </cfif>
                        </cfif>
                    </cfif>
                    <cfif listfind(attributes.listing_type,8)>
                        <th><cf_get_lang dictionary_id ='57635.Miktar'></th>
                        <th><cf_get_lang dictionary_id ='57673.Tutar'></th>
                        <th colspan="2"><cf_get_lang dictionary_id ='40042.Tutar kdv siz'></th>
                        <cfif len(session.ep.money2) and attributes.report_type neq 6>
                            <th><cf_get_lang dictionary_id ='39656.Döviz Tutar'></th>
                            <th colspan="2"><cf_get_lang dictionary_id ='40043.Döviz Tutar kdvsiz'></th>
                        </cfif>
                    </cfif>
                    <cfif listfind(attributes.listing_type,9)>
                        <th><cf_get_lang dictionary_id ='57635.Miktar'></th>
                        <th><cf_get_lang dictionary_id ='57673.Tutar'></th>
                        <th colspan="2"><cf_get_lang dictionary_id ='40042.Tutar kdv siz'></th>
                        <cfif len(session.ep.money2) and attributes.report_type neq 6>
                            <th><cf_get_lang dictionary_id ='39656.Döviz Tutar'></th>
                            <th colspan="2"><cf_get_lang dictionary_id ='40043.Döviz Tutar kdvsiz'></th>
                        </cfif>
                    </cfif>
                    <cfif listfind(attributes.listing_type,10)>
                        <th width="100"><cf_get_lang dictionary_id ='57635.Miktar'></th>
                        <th width="100"><cf_get_lang dictionary_id ='57673.Tutar'></th>
                        <cfif attributes.report_type neq 6>
                            <th colspan="2"><cf_get_lang dictionary_id ='40042.Tutar kdv siz'></th>
                        </cfif>
                        <cfif len(session.ep.money2) and attributes.report_type neq 6>
                            <th><cf_get_lang dictionary_id ='39656.Döviz Tutar'></th>
                            <cfif attributes.report_type neq 6>
                                <th colspan="2"><cf_get_lang dictionary_id ='40043.Döviz Tutar kdvsiz'></th>
                            </cfif>
                        </cfif>
                    </cfif>	
                    <cfif listfind(attributes.listing_type,11)>
                        <th><cf_get_lang dictionary_id ='57635.Miktar'></th>
                        <th><cf_get_lang dictionary_id ='57673.Tutar'></th>
                        <th colspan="2"><cf_get_lang dictionary_id ='40042.Tutar kdv siz'></th>
                        <cfif len(session.ep.money2) and attributes.report_type neq 6>
                            <th><cf_get_lang dictionary_id ='39656.Döviz Tutar'></th>
                            <th colspan="2"><cf_get_lang dictionary_id ='40043.Döviz Tutar kdvsiz'></th>
                        </cfif>
                    </cfif>
                    <cfif listfind(attributes.listing_type,12)>
                        <th><cf_get_lang dictionary_id ='57635.Miktar'></th>
                        <th><cf_get_lang dictionary_id ='57673.Tutar'></th>
                        <cfif attributes.report_type neq 6>
                            <th colspan="2"><cf_get_lang dictionary_id ='40042.Tutar kdv siz'></th>
                        </cfif>
                        <cfif len(session.ep.money2) and attributes.report_type neq 6>
                            <th><cf_get_lang dictionary_id ='39656.Döviz Tutar'></th>
                            <cfif attributes.report_type neq 6>
                                <th colspan="2"><cf_get_lang dictionary_id ='40043.Döviz Tutar kdvsiz'></th>
                            </cfif>
                        </cfif>
                    </cfif>	
                    <cfif listfind(attributes.listing_type,13)>
                        <th><cf_get_lang dictionary_id ='57635.Miktar'></th>
                        <th><cf_get_lang dictionary_id ='57673.Tutar'></th>
                        <th colspan="2"><cf_get_lang dictionary_id ='40042.Tutar kdv siz'></th>
                        <cfif len(session.ep.money2) and attributes.report_type neq 6>
                            <th><cf_get_lang dictionary_id ='39656.Döviz Tutar'></th>
                            <th colspan="2"><cf_get_lang dictionary_id ='40043.Döviz Tutar kdvsiz'></th>
                        </cfif>
                    </cfif>
                    <cfif listfind(attributes.listing_type,14)>
                        <th colspan="2"><cf_get_lang dictionary_id ='57635.Miktar'></th>
                    </cfif>
                    <cfif listfind(attributes.listing_type,15)>
                        <th><cf_get_lang dictionary_id ='57635.Miktar'></th>
                        <th><cf_get_lang dictionary_id ='57673.Tutar'></th>
                        <th colspan="2"><cf_get_lang dictionary_id ='40042.Tutar kdv siz'></th>
                        <cfif len(session.ep.money2) and attributes.report_type neq 6>
                            <th><cf_get_lang dictionary_id ='39656.Döviz Tutar'></th>
                            <th colspan="2"><cf_get_lang dictionary_id ='40043.Döviz Tutar kdvsiz'></th>
                        </cfif>
                    </cfif>
                    <cfif listfind(attributes.listing_type,16)>
                        <th><cf_get_lang dictionary_id ='57635.Miktar'></th>
                        <th><cf_get_lang dictionary_id ='57673.Tutar'></th>
                        <th colspan="2"><cf_get_lang dictionary_id ='40042.Tutar kdv siz'></th>
                        <cfif len(session.ep.money2) and attributes.report_type neq 6>
                            <th><cf_get_lang dictionary_id ='39656.Döviz Tutar'></th>
                            <th colspan="2"><cf_get_lang dictionary_id ='40043.Döviz Tutar kdvsiz'></th>
                        </cfif>
                    </cfif>
                <cfelse>
                    <th><cf_get_lang dictionary_id='57800.İşlem Tipi'></th>
                    <th><cf_get_lang dictionary_id ='57635.Miktar'></th>
                    <th><cf_get_lang dictionary_id ='57673.Tutar'></th>
                    <th colspan="2"><cf_get_lang dictionary_id ='40042.Tutar kdv siz'></th>
                    <cfif len(session.ep.money2) and attributes.report_type neq 6>
                        <th><cf_get_lang dictionary_id ='39656.Döviz Tutar'></th>
                        <th colspan="2"><cf_get_lang dictionary_id ='40043.Döviz Tutar kdvsiz'></th>
                    </cfif>
                </cfif>
            </tr>
            </cfif> 
        </thead><!-- sil -->
        <tbody> <!-- sil -->
            <cfscript>
                for(elemet_i=1;elemet_i lte 86;elemet_i=elemet_i+1)
                {
                    page_totals[1][#elemet_i#] = 0;
                /*if(not isdefined('attributes.is_total'))
                    page_totals[2][#elemet_i#] = 0;*/
                }
            </cfscript>
            <cfif attributes.report_type eq 5>
                <cfset hakedis_miktar =0>
                <cfset hakedis_tutar =0>
                <cfset hakedis_tutar_kdvsiz =0>
                <cfset hakedis_doviz_tutar =0>
                <cfset hakedis_doviz_tutar_kdvsiz =0>
                <cfoutput>
                <cfloop list="#attributes.listing_type#" index="pro_index">
                    <tr>
                        <td><cfif pro_index eq 1><cf_get_lang dictionary_id='58123.Planlama'>
                            <cfelseif pro_index eq 2><cf_get_lang dictionary_id ='39499.Alış Siparişleri'>
                            <cfelseif pro_index eq 3><cf_get_lang dictionary_id='58207.Satış Siparişleri'>
                            <cfelseif pro_index eq 4><cf_get_lang dictionary_id ='39502.Satış İrsaliyeleri'>
                            <cfelseif pro_index eq 5><cf_get_lang dictionary_id ='39500.Alış İrsaliyeleri'>
                            <cfelseif pro_index eq 6><cf_get_lang dictionary_id ='39495.İthalat'>
                            <cfelseif pro_index eq 7><cf_get_lang dictionary_id ='30009.Sarflar'>
                            <cfelseif pro_index eq 8><cf_get_lang dictionary_id ='39088.Üretim Fişleri'>
                            <cfelseif pro_index eq 9><cf_get_lang dictionary_id ='39503.Alış Faturaları'>
                            <cfelseif pro_index eq 10><cf_get_lang dictionary_id ='39504.Satış Faturaları'>
                            <cfelseif pro_index eq 11><cf_get_lang dictionary_id ='39506.Hakediş'>
                            <cfelseif pro_index eq 12><cf_get_lang dictionary_id ='40227.Depolararası Sevk'>
                            <cfelseif pro_index eq 13><cf_get_lang dictionary_id ='40039.İç Talepler'>
                            <cfelseif pro_index eq 14><cf_get_lang dictionary_id ='40037.Üretim Emirleri'>
                            <cfelseif pro_index eq 15><cf_get_lang dictionary_id ='33263.Satınalma Talepleri'>
                            <cfelseif pro_index eq 16><cf_get_lang dictionary_id ='47243.Üretim Talepleri'>
                            </cfif>
                        </td>
                        <td style="text-align:right;">
                            <cfif pro_index eq 1>
                                <cfif isdefined('miktar_toplam_1') and len(miktar_toplam_1)>
                                    #TLFormat(miktar_toplam_1)#
                                <cfelse>
                                    -
                                </cfif>
                            <cfelseif pro_index eq 2>
                                <cfif isdefined('miktar_toplam_2') and len(miktar_toplam_2)>
                                    #TLFormat(miktar_toplam_2)#
                                <cfelse>
                                    -
                                </cfif>
                            <cfelseif pro_index eq 3>
                                <cfif isdefined('miktar_toplam_3') and len(miktar_toplam_3)>
                                    #TLFormat(miktar_toplam_3)#
                                <cfelse>
                                    -
                                </cfif>
                            <cfelseif pro_index eq 4>
                                <cfif isdefined('miktar_toplam_4') and len(miktar_toplam_4)>
                                    #TLFormat(miktar_toplam_4)#
                                <cfelse>
                                    -
                                </cfif>
                            <cfelseif pro_index eq 5>
                                <cfif isdefined('miktar_toplam_5') and len(miktar_toplam_5)>
                                    #TLFormat(miktar_toplam_5)#
                                <cfelse>
                                    -
                                </cfif>
                            <cfelseif pro_index eq 6>
                                <cfif isdefined('miktar_toplam_6') and len(miktar_toplam_6)>
                                    #TLFormat(miktar_toplam_6)#
                                <cfelse>
                                    -
                                </cfif>
                            <cfelseif pro_index eq 7>
                                <cfif isdefined('miktar_toplam_7') and len(miktar_toplam_7)>
                                    #TLFormat(miktar_toplam_7)#
                                <cfelse>
                                    -
                                </cfif>
                            <cfelseif pro_index eq 8>
                                <cfif isdefined('miktar_toplam_8') and len(miktar_toplam_8)>
                                    #TLFormat(miktar_toplam_8)#
                                <cfelse>
                                    -
                                </cfif>
                            <cfelseif pro_index eq 9>
                                <cfif isdefined('miktar_toplam_9') and len(miktar_toplam_9)>
                                    #TLFormat(miktar_toplam_9)#
                                <cfelse>
                                    -
                                </cfif>
                            <cfelseif pro_index eq 10>
                                <cfif isdefined('miktar_toplam_10') and len(miktar_toplam_10)>
                                    #TLFormat(miktar_toplam_10)#
                                <cfelse>
                                    -
                                </cfif>
                            <cfelseif pro_index eq 11>
                                <cfif isdefined('miktar_toplam_10') and len(miktar_toplam_10)>
                                    <cfset hakedis_miktar = hakedis_miktar + miktar_toplam_10>
                                </cfif>
                                <cfif isdefined('miktar_toplam_7') and len(miktar_toplam_7)>
                                    <cfset hakedis_miktar = hakedis_miktar - miktar_toplam_7>
                                </cfif>
                                #TLFormat(hakedis_miktar)# 
                            <cfelseif pro_index eq 12>
                                <cfif isdefined('miktar_toplam_12') and len(miktar_toplam_12)>
                                    #TLFormat(miktar_toplam_12)#
                                <cfelse>
                                    -
                                </cfif>
                            <cfelseif pro_index eq 13>
                                <cfif isdefined('miktar_toplam_13') and len(miktar_toplam_13)>
                                    #TLFormat(miktar_toplam_13)#
                                <cfelse>
                                    -
                                </cfif>
                            <cfelseif pro_index eq 14>
                                <cfif isdefined('miktar_toplam_14') and len(miktar_toplam_14)>
                                    #TLFormat(miktar_toplam_14)#
                                <cfelse>
                                    -
                                </cfif>
                            <cfelseif pro_index eq 15>
                                <cfif isdefined('miktar_toplam_15') and len(miktar_toplam_15)>
                                    #TLFormat(miktar_toplam_15)#
                                <cfelse>
                                    -
                                </cfif>
                            <cfelseif pro_index eq 16>
                                <cfif isdefined('miktar_toplam_16') and len(miktar_toplam_16)>
                                    #TLFormat(miktar_toplam_16)#
                                <cfelse>
                                    -
                                </cfif>
                            </cfif>
                        </td>
                        <td style="text-align:right;">
                            <cfif pro_index eq 1>
                                <cfif isdefined('tutar_toplam_1') and len(tutar_toplam_1)>
                                    #TLFormat(tutar_toplam_1)#
                                <cfelse>
                                    -
                                </cfif>
                            <cfelseif pro_index eq 2>
                                <cfif isdefined('tutar_toplam_2') and len(tutar_toplam_2)>
                                    #TLFormat(tutar_toplam_2)#
                                <cfelse>
                                    -
                                </cfif>
                            <cfelseif pro_index eq 3>
                                <cfif isdefined('tutar_toplam_3') and len(tutar_toplam_3)>
                                    #TLFormat(tutar_toplam_3)#
                                <cfelse>
                                    -
                                </cfif>
                            <cfelseif pro_index eq 4>
                                <cfif isdefined('tutar_toplam_4') and len(tutar_toplam_4)>
                                    #TLFormat(tutar_toplam_4)#
                                <cfelse>
                                    -
                                </cfif>
                            <cfelseif pro_index eq 5>
                                <cfif isdefined('tutar_toplam_5') and len(tutar_toplam_5)>
                                    #TLFormat(tutar_toplam_5)#
                                <cfelse>
                                    -
                                </cfif>
                            <cfelseif pro_index eq 6>
                                <cfif isdefined('tutar_toplam_6') and len(tutar_toplam_6)>
                                    #TLFormat(tutar_toplam_6)#
                                <cfelse>
                                    -
                                </cfif>
                            <cfelseif pro_index eq 7>
                                <cfif isdefined('tutar_toplam_7') and len(tutar_toplam_7)>
                                    #TLFormat(tutar_toplam_7)#
                                <cfelse>
                                    -
                                </cfif>
                            <cfelseif pro_index eq 8>
                                <cfif isdefined('tutar_toplam_8') and len(tutar_toplam_8)>
                                    #TLFormat(tutar_toplam_8)#
                                <cfelse>
                                    -
                                </cfif>
                            <cfelseif pro_index eq 9>
                                <cfif isdefined('tutar_toplam_9') and len(tutar_toplam_9)>
                                    #TLFormat(tutar_toplam_9)#
                                <cfelse>
                                    -
                                </cfif>
                            <cfelseif pro_index eq 10>
                                <cfif isdefined('tutar_toplam_10') and len(tutar_toplam_10)>
                                    #TLFormat(tutar_toplam_10)#
                                <cfelse>
                                    -
                                </cfif>
                            <cfelseif pro_index eq 11>
                                <cfif isdefined('tutar_toplam_10') and len(tutar_toplam_10)>
                                    <cfset hakedis_tutar = hakedis_tutar + tutar_toplam_10>
                                </cfif>
                                <cfif isdefined('tutar_toplam_7') and len(tutar_toplam_7)>
                                    <cfset hakedis_tutar = hakedis_tutar - tutar_toplam_7>
                                </cfif>
                                #TLFormat(hakedis_tutar)# 
                            <cfelseif pro_index eq 12>
                                <cfif isdefined('tutar_toplam_12') and len(tutar_toplam_12)>
                                    #TLFormat(tutar_toplam_12)#
                                <cfelse>
                                    -
                                </cfif>
                            <cfelseif pro_index eq 13>
                                <cfif isdefined('tutar_toplam_13') and len(tutar_toplam_13)>
                                    #TLFormat(tutar_toplam_13)#
                                <cfelse>
                                    -
                                </cfif>
                            <cfelseif pro_index eq 15>
                                <cfif isdefined('tutar_toplam_15') and len(tutar_toplam_15)>
                                    #TLFormat(tutar_toplam_15)#
                                <cfelse>
                                    -
                                </cfif>
                            <cfelseif pro_index eq 16>
                                <cfif isdefined('tutar_toplam_16') and len(tutar_toplam_16)>
                                    #TLFormat(tutar_toplam_16)#
                                <cfelse>
                                    -
                                </cfif>
                            </cfif>
                        </td>
                        <td style="text-align:right;">
                            <cfif pro_index eq 1>
                                <cfif isdefined('tutar_toplam_1_kdvsiz') and len(tutar_toplam_1_kdvsiz)>
                                    #TLFormat(tutar_toplam_1_kdvsiz)#
                                <cfelse>
                                    -
                                </cfif>
                            <cfelseif pro_index eq 2>
                                <cfif isdefined('tutar_toplam_2_kdvsiz') and len(tutar_toplam_2_kdvsiz)>
                                    #TLFormat(tutar_toplam_2_kdvsiz)#
                                <cfelse>
                                    -
                                </cfif>
                            <cfelseif pro_index eq 3>
                                <cfif isdefined('tutar_toplam_3_kdvsiz') and len(tutar_toplam_3_kdvsiz)>
                                    #TLFormat(tutar_toplam_3_kdvsiz)#
                                <cfelse>
                                    -
                                </cfif>
                            <cfelseif pro_index eq 4>
                                <cfif isdefined('tutar_toplam_4_kdvsiz') and len(tutar_toplam_4_kdvsiz)>
                                    #TLFormat(tutar_toplam_4_kdvsiz)#
                                <cfelse>
                                    -
                                </cfif>
                            <cfelseif pro_index eq 5>
                                <cfif isdefined('tutar_toplam_5_kdvsiz') and len(tutar_toplam_5_kdvsiz)>
                                    #TLFormat(tutar_toplam_5_kdvsiz)#
                                <cfelse>
                                    -
                                </cfif>
                            <cfelseif pro_index eq 6>
                                <cfif isdefined('tutar_toplam_6_kdvsiz') and len(tutar_toplam_6_kdvsiz)>
                                    #TLFormat(tutar_toplam_6_kdvsiz)#
                                <cfelse>
                                    -
                                </cfif>
                            <cfelseif pro_index eq 7>
                                <cfif isdefined('tutar_toplam_7_kdvsiz') and len(tutar_toplam_7_kdvsiz)>
                                    #TLFormat(tutar_toplam_7_kdvsiz)#
                                <cfelse>
                                    -
                                </cfif>
                            <cfelseif pro_index eq 8>
                                <cfif isdefined('tutar_toplam_8_kdvsiz') and len(tutar_toplam_8_kdvsiz)>
                                    #TLFormat(tutar_toplam_8_kdvsiz)#
                                <cfelse>
                                    -
                                </cfif>
                            <cfelseif pro_index eq 9>
                                <cfif isdefined('tutar_toplam_9_kdvsiz') and len(tutar_toplam_9_kdvsiz)>
                                    #TLFormat(tutar_toplam_9_kdvsiz)#
                                <cfelse>
                                    -
                                </cfif>
                            <cfelseif pro_index eq 10>
            
                                <cfif isdefined('tutar_toplam_10_kdvsiz') and len(tutar_toplam_10_kdvsiz)>
                                    #TLFormat(tutar_toplam_10_kdvsiz)#
                                <cfelse>
                                    -
                                </cfif>
                            <cfelseif pro_index eq 11>
                                <cfif isdefined('tutar_toplam_10_kdvsiz') and len(tutar_toplam_10_kdvsiz)>
                                    <cfset hakedis_tutar_kdvsiz = hakedis_tutar_kdvsiz + tutar_toplam_10_kdvsiz>
                                </cfif>
                                <cfif isdefined('tutar_toplam_7_kdvsiz') and len(tutar_toplam_7_kdvsiz)>
                                    <cfset hakedis_tutar_kdvsiz = hakedis_tutar_kdvsiz - tutar_toplam_7_kdvsiz>
                                </cfif>
                                #TLFormat(hakedis_tutar_kdvsiz)# 
                            <cfelseif pro_index eq 12>
                                <cfif isdefined('tutar_toplam_12_kdvsiz') and len(tutar_toplam_12_kdvsiz)>
                                    #TLFormat(tutar_toplam_12_kdvsiz)#
                                <cfelse>
                                    -
                                </cfif>
                            <cfelseif pro_index eq 13>
                                <cfif isdefined('tutar_toplam_13_kdvsiz') and len(tutar_toplam_13_kdvsiz)>
                                    #TLFormat(tutar_toplam_13_kdvsiz)#
                                <cfelse>
                                    -
                                </cfif>
                            <cfelseif pro_index eq 15>
                                <cfif isdefined('tutar_toplam_15_kdvsiz') and len(tutar_toplam_15_kdvsiz)>
                                    #TLFormat(tutar_toplam_15_kdvsiz)#
                                <cfelse>
                                    -
                                </cfif>
                            <cfelseif pro_index eq 16>
                                <cfif isdefined('tutar_toplam_16_kdvsiz') and len(tutar_toplam_16_kdvsiz)>
                                    #TLFormat(tutar_toplam_16_kdvsiz)#
                                <cfelse>
                                    -
                                </cfif>
                            </cfif>
                        </td>
                        <td>#session.ep.money#</td>
                        <cfif len(session.ep.money2)>
                            <td style="text-align:right;">
                                <cfif pro_index eq 1>
                                    <cfif isdefined('tutar_doviz_toplam_1') and len(tutar_doviz_toplam_1)>
                                        #TLFormat(tutar_doviz_toplam_1)#
                                    <cfelse>
                                        -
                                    </cfif>
                                <cfelseif pro_index eq 2>
                                    <cfif isdefined('tutar_doviz_toplam_2') and len(tutar_doviz_toplam_2)>
                                        #TLFormat(tutar_doviz_toplam_2)#
                                    <cfelse>
                                        -
                                    </cfif>
                                <cfelseif pro_index eq 3>
                                    <cfif isdefined('tutar_doviz_toplam_3') and len(tutar_doviz_toplam_3)>
                                        #TLFormat(tutar_doviz_toplam_3)#
                                    <cfelse>
                                        -
                                    </cfif>
                                <cfelseif pro_index eq 4>
                                    <cfif isdefined('tutar_doviz_toplam_4') and len(tutar_doviz_toplam_4)>
                                        #TLFormat(tutar_doviz_toplam_4)#
                                    <cfelse>
                                        -
                                    </cfif>
                                <cfelseif pro_index eq 5>
                                    <cfif isdefined('tutar_doviz_toplam_5') and len(tutar_doviz_toplam_5)>
                                        #TLFormat(tutar_doviz_toplam_5)#
                                    <cfelse>
                                        -
                                    </cfif>
                                <cfelseif pro_index eq 6>
                                    <cfif isdefined('tutar_doviz_toplam_6') and len(tutar_doviz_toplam_6)>
                                        #TLFormat(tutar_doviz_toplam_6)#
                                    <cfelse>
                                        -
                                    </cfif>
                                <cfelseif pro_index eq 7>
                                    <cfif isdefined('tutar_doviz_toplam_7') and len(tutar_doviz_toplam_7)>
                                        #TLFormat(tutar_doviz_toplam_7)#
                                    <cfelse>
                                        -
                                    </cfif>
                                <cfelseif pro_index eq 8>
                                    <cfif isdefined('tutar_doviz_toplam_8') and len(tutar_doviz_toplam_8)>
                                        #TLFormat(tutar_doviz_toplam_8)#
                                    <cfelse>
                                        -
                                    </cfif>
                                <cfelseif pro_index eq 9>
                                    <cfif isdefined('tutar_doviz_toplam_9') and len(tutar_doviz_toplam_9)>
                                        #TLFormat(tutar_doviz_toplam_9)#
                                    <cfelse>
                                        -
                                    </cfif>
                                <cfelseif pro_index eq 10>
                                    <cfif isdefined('tutar_doviz_toplam_10') and len(tutar_doviz_toplam_10)>
                                        #TLFormat(tutar_doviz_toplam_10)#
                                    <cfelse>
                                        -
                                    </cfif>
                                <cfelseif pro_index eq 11>
                                    <cfif isdefined('tutar_doviz_toplam_10') and len(tutar_doviz_toplam_10)>
                                        <cfset hakedis_doviz_tutar = hakedis_doviz_tutar + tutar_doviz_toplam_10>
                                    </cfif>
                                    <cfif isdefined('tutar_doviz_toplam_7') and len(tutar_doviz_toplam_7)>
                                        <cfset hakedis_doviz_tutar = hakedis_doviz_tutar - tutar_doviz_toplam_7>
                                    </cfif>
                                    #TLFormat(hakedis_doviz_tutar)# 
                                <cfelseif pro_index eq 12>
                                    <cfif isdefined('tutar_doviz_toplam_12') and len(tutar_doviz_toplam_12)>
                                        #TLFormat(tutar_doviz_toplam_12)#
                                    <cfelse>
                                        -
                                    </cfif>
                                <cfelseif pro_index eq 13>
                                    <cfif isdefined('tutar_doviz_toplam_13') and len(tutar_doviz_toplam_13)>
                                        #TLFormat(tutar_doviz_toplam_13)#
                                    <cfelse>
                                        -
                                    </cfif>
                                <cfelseif pro_index eq 15>
                                    <cfif isdefined('tutar_doviz_toplam_15') and len(tutar_doviz_toplam_15)>
                                        #TLFormat(tutar_doviz_toplam_15)#
                                    <cfelse>
                                        -
                                    </cfif>
                                <cfelseif pro_index eq 16>
                                    <cfif isdefined('tutar_doviz_toplam_16') and len(tutar_doviz_toplam_16)>
                                        #TLFormat(tutar_doviz_toplam_16)#
                                    <cfelse>
                                        -
                                    </cfif>
                                </cfif>
                            </td>
                            <td style="text-align:right;">
                                <cfif pro_index eq 1>
                                    <cfif isdefined('tutar_doviz_toplam_1_kdvsiz') and len(tutar_doviz_toplam_1_kdvsiz)>
                                        #TLFormat(tutar_doviz_toplam_1_kdvsiz)#
                                    <cfelse>
                                        -
                                    </cfif>
                                <cfelseif pro_index eq 2>
                                    <cfif isdefined('tutar_doviz_toplam_2_kdvsiz') and len(tutar_doviz_toplam_2_kdvsiz)>
                                        #TLFormat(tutar_doviz_toplam_2_kdvsiz)#
                                    <cfelse>
                                        -
                                    </cfif>
                                <cfelseif pro_index eq 3>
                                    <cfif isdefined('tutar_doviz_toplam_3_kdvsiz') and len(tutar_doviz_toplam_3_kdvsiz)>
                                        #TLFormat(tutar_doviz_toplam_3_kdvsiz)#
                                    <cfelse>
                                        -
                                    </cfif>
                                <cfelseif pro_index eq 4>
                                    <cfif isdefined('tutar_doviz_toplam_4_kdvsiz') and len(tutar_doviz_toplam_4_kdvsiz)>
                                        #TLFormat(tutar_doviz_toplam_4_kdvsiz)#
                                    <cfelse>
                                        -
                                    </cfif>
                                <cfelseif pro_index eq 5>
                                    <cfif isdefined('tutar_doviz_toplam_5_kdvsiz') and len(tutar_doviz_toplam_5_kdvsiz)>
                                        #TLFormat(tutar_doviz_toplam_5_kdvsiz)#
                                    <cfelse>
                                        -
                                    </cfif>
                                <cfelseif pro_index eq 6>
                                    <cfif isdefined('tutar_doviz_toplam_6_kdvsiz') and len(tutar_doviz_toplam_6_kdvsiz)>
                                        #TLFormat(tutar_doviz_toplam_6_kdvsiz)#
                                    <cfelse>
                                        -
                                    </cfif>
                                <cfelseif pro_index eq 7>
                                    <cfif isdefined('tutar_doviz_toplam_7_kdvsiz') and len(tutar_doviz_toplam_7_kdvsiz)>
                                        #TLFormat(tutar_doviz_toplam_7_kdvsiz)#
                                    <cfelse>
                                        -
                                    </cfif>
                                <cfelseif pro_index eq 8>
                                    <cfif isdefined('tutar_doviz_toplam_8_kdvsiz') and len(tutar_doviz_toplam_8_kdvsiz)>
                                        #TLFormat(tutar_doviz_toplam_8_kdvsiz)#
                                    <cfelse>
                                        -
                                    </cfif>
                                <cfelseif pro_index eq 9>
                                    <cfif isdefined('tutar_doviz_toplam_9_kdvsiz') and len(tutar_doviz_toplam_9_kdvsiz)>
                                        #TLFormat(tutar_doviz_toplam_9_kdvsiz)#
                                    <cfelse>
                                        -
                                    </cfif>
                                <cfelseif pro_index eq 10>
                                    <cfif isdefined('tutar_doviz_toplam_10_kdvsiz') and len(tutar_doviz_toplam_10_kdvsiz)>
                                        #TLFormat(tutar_doviz_toplam_10_kdvsiz)#
                                    <cfelse>
                                        -
                                    </cfif>
                                <cfelseif pro_index eq 11>
                                    <cfif isdefined('tutar_doviz_toplam_10_kdvsiz') and len(tutar_doviz_toplam_10_kdvsiz)>
                                        <cfset hakedis_doviz_tutar_kdvsiz = hakedis_doviz_tutar_kdvsiz + tutar_doviz_toplam_10_kdvsiz>
                                    </cfif>
                                    <cfif isdefined('tutar_doviz_toplam_7_kdvsiz') and len(tutar_doviz_toplam_7_kdvsiz)>
                                        <cfset hakedis_doviz_tutar_kdvsiz = hakedis_doviz_tutar_kdvsiz - tutar_doviz_toplam_7_kdvsiz>
                                    </cfif>
                                    #TLFormat(hakedis_doviz_tutar_kdvsiz)# 
                                <cfelseif pro_index eq 12>
                                    <cfif isdefined('tutar_doviz_toplam_12_kdvsiz') and len(tutar_doviz_toplam_12_kdvsiz)>
                                        #TLFormat(tutar_doviz_toplam_12_kdvsiz)#
                                    <cfelse>
                                        -
                                    </cfif>
                                <cfelseif pro_index eq 13>
                                    <cfif isdefined('tutar_doviz_toplam_13_kdvsiz') and len(tutar_doviz_toplam_13_kdvsiz)>
                                        #TLFormat(tutar_doviz_toplam_13_kdvsiz)#
                                    <cfelse>
                                        -
                                    </cfif>
                                <cfelseif pro_index eq 15>
                                    <cfif isdefined('tutar_doviz_toplam_15_kdvsiz') and len(tutar_doviz_toplam_15_kdvsiz)>
                                        #TLFormat(tutar_doviz_toplam_15_kdvsiz)#
                                    <cfelse>
                                        -
                                    </cfif>
                                <cfelseif pro_index eq 16>
                                    <cfif isdefined('tutar_doviz_toplam_16_kdvsiz') and len(tutar_doviz_toplam_16_kdvsiz)>
                                        #TLFormat(tutar_doviz_toplam_16_kdvsiz)#
                                    <cfelse>
                                        -
                                    </cfif>
                                </cfif>
                            </td>
                            <td>#session.ep.money2#</td>
                        </cfif>
                    </tr>
                </cfloop>
                </cfoutput>
            <cfelseif isdefined('get_all_stock') and get_all_stock.recordcount>
                <cfoutput query="get_all_stock" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                    <cfset hakedis_miktar =0>
                    <cfset hakedis_tutar=0>
                    <cfset hakedis_doviz_tutar=0>
                    <tr>
                        <td width="7">#get_all_stock.currentrow#</td>
                        <!--- stok bazında --->
                        <cfif attributes.report_type eq 1>
                            <td>#stock_code#</td>
                            <td  colspan="2" width="180">#aciklama#</td>
                        <cfelseif attributes.report_type eq 2><!--- tedarikci bazında --->
                            <td  width="120">#aciklama#</td>
                        <cfelseif attributes.report_type eq 3><!--- marka bazında --->
                            <td  width="120">#aciklama#</td>
                        <cfelseif attributes.report_type eq 4><!--- kategori bazında --->
                            <td  width="50">#hierarchy#</td>
                            <td  width="120">#aciklama#</td>
                        </cfif>
                        <cfif listfind(attributes.listing_type,1)>
                            <td  style="text-align:right;">
                                <cfif isdefined('pro_material_miktar_#report_groupby_id#') and len(evaluate("pro_material_miktar_#report_groupby_id#"))>
                                    <cfset page_totals[1][1] = page_totals[1][1] + evaluate("pro_material_miktar_#report_groupby_id#")><!--- soracam--->
                                    #tlformat(evaluate("pro_material_miktar_#report_groupby_id#"))#
                                <cfelse>
                                    -
                                </cfif>
                            </td>
                            <td  style="text-align:right;">
                                <cfif isdefined('pro_material_tutar_#report_groupby_id#') and len(evaluate("pro_material_tutar_#report_groupby_id#"))>
                                    <cfset page_totals[1][2] = page_totals[1][2] + evaluate("pro_material_tutar_#report_groupby_id#")><!--- soracam--->
                                    #tlformat(evaluate("pro_material_tutar_#report_groupby_id#"))#
                                <cfelse>
                                    -
                                </cfif>
                            </td>
                            <td  style="text-align:right;">
                                <cfif isdefined('pro_material_tutar_kdvsiz_#report_groupby_id#') and len(evaluate("pro_material_tutar_kdvsiz_#report_groupby_id#"))>
                                    <cfset page_totals[1][50] = page_totals[1][50] + evaluate("pro_material_tutar_kdvsiz_#report_groupby_id#")><!--- soracam--->
                                    #tlformat(evaluate("pro_material_tutar_kdvsiz_#report_groupby_id#"))#
                                <cfelse>
                                    -
                                </cfif>
                            </td>
                            <td>#session.ep.money#</td>
                            <cfif len(session.ep.money2)>
                                <td  style="text-align:right;">
                                    <cfif isdefined('pro_material_doviz_tutar_#report_groupby_id#') and len(evaluate("pro_material_doviz_tutar_#report_groupby_id#"))>
                                        <cfset page_totals[1][3] = page_totals[1][3] + evaluate("pro_material_doviz_tutar_#report_groupby_id#")><!--- soracam--->
                                        #TLFormat(evaluate("pro_material_doviz_tutar_#report_groupby_id#"))#
                                    <cfelse>
                                        -
                                    </cfif>
                                </td>
                                <td  style="text-align:right;">
                                    <cfif isdefined('pro_material_doviz_tutar_kdvsiz_#report_groupby_id#') and len(evaluate("pro_material_doviz_tutar_kdvsiz_#report_groupby_id#"))>
                                        <cfset page_totals[1][51] = page_totals[1][51] + evaluate("pro_material_doviz_tutar_kdvsiz_#report_groupby_id#")><!--- soracam--->
                                        #TLFormat(evaluate("pro_material_doviz_tutar_kdvsiz_#report_groupby_id#"))#
                                    <cfelse>
                                        -
                                    </cfif>
                                </td>
                                <td>#session.ep.money2#</td>
                            </cfif>
                        </cfif>
                        <cfif listfind(attributes.listing_type,2)>
                            <td  style="text-align:right;">
                                <cfif isdefined('alis_siparis_miktar_#report_groupby_id#') and len(evaluate("alis_siparis_miktar_#report_groupby_id#"))>
                                    <cfset page_totals[1][4] = page_totals[1][4] + evaluate("alis_siparis_miktar_#report_groupby_id#")><!--- proje için yapılmış alış siparişleri miktar--->
                                    #TLFormat(evaluate("alis_siparis_miktar_#report_groupby_id#"))#
                                <cfelse>
                                    -
                                </cfif>
                            </td>
                            <td  style="text-align:right;">
                                <cfif isdefined('alis_siparis_tutar_#report_groupby_id#') and len(evaluate("alis_siparis_tutar_#report_groupby_id#"))>
                                    <cfset page_totals[1][5] = page_totals[1][5] + evaluate("alis_siparis_tutar_#report_groupby_id#")><!--- proje için yapılmış satış siparişleri tutar--->
                                    #TLFormat(evaluate("alis_siparis_tutar_#report_groupby_id#"))#
                                <cfelse>
                                    -
                                </cfif>
                            </td>
                            <td  style="text-align:right;">
                                <cfif isdefined('alis_siparis_tutar_kdvsiz_#report_groupby_id#') and len(evaluate("alis_siparis_tutar_kdvsiz_#report_groupby_id#"))>
                                    <cfset page_totals[1][52] = page_totals[1][52] + evaluate("alis_siparis_tutar_kdvsiz_#report_groupby_id#")><!--- soracam--->
                                    #TLFormat(evaluate("alis_siparis_tutar_kdvsiz_#report_groupby_id#"))#
                                <cfelse>
                                    -
                                </cfif>
                            </td>
                            <td>#session.ep.money#</td>
                            <cfif len(session.ep.money2)>
                                <td  style="text-align:right;">
                                    <cfif isdefined('alis_siparis_doviz_tutar_#report_groupby_id#') and len(evaluate("alis_siparis_doviz_tutar_#report_groupby_id#"))>
                                        <cfset page_totals[1][6] = page_totals[1][6] + evaluate("alis_siparis_doviz_tutar_#report_groupby_id#")><!--- proje için yapılmış satış siparişleri tutar--->
                                        #TLFormat(evaluate("alis_siparis_doviz_tutar_#report_groupby_id#"))#
                                    <cfelse>
                                        -
                                    </cfif>
                                </td>
                                <td  style="text-align:right;">
                                    <cfif isdefined('alis_siparis_doviz_tutar_kdvsiz_#report_groupby_id#') and len(evaluate("alis_siparis_doviz_tutar_kdvsiz_#report_groupby_id#"))>
                                        <cfset page_totals[1][53] = page_totals[1][53] + evaluate("alis_siparis_doviz_tutar_kdvsiz_#report_groupby_id#")><!--- soracam--->
                                        #TLFormat(evaluate("alis_siparis_doviz_tutar_kdvsiz_#report_groupby_id#"))#
                                    <cfelse>
                                        -
                                    </cfif>
                                </td>
                                <td>#session.ep.money2#</td>
                            </cfif>
                        </cfif>
                        <cfif listfind(attributes.listing_type,3)>
                            <td  style="text-align:right;">
                                <cfif isdefined('satis_siparis_miktar_#report_groupby_id#') and len(evaluate("satis_siparis_miktar_#report_groupby_id#"))>
                                    <cfset page_totals[1][7] = page_totals[1][7] + evaluate("satis_siparis_miktar_#report_groupby_id#")><!--- proje için yapılmış satış siparişleri miktar--->
                                    #TLFormat(evaluate("satis_siparis_miktar_#report_groupby_id#"))#
                                <cfelse>
                                    -
                                </cfif>
                            </td>
                            <td  style="text-align:right;">
                                <cfif isdefined('satis_siparis_tutar_#report_groupby_id#') and len(evaluate("satis_siparis_tutar_#report_groupby_id#"))>
                                    <cfset page_totals[1][8] = page_totals[1][8] + evaluate("satis_siparis_tutar_#report_groupby_id#")><!--- proje için yapılmış satış siparişleri tutar--->
                                    #TLFormat(evaluate("satis_siparis_tutar_#report_groupby_id#"))#
                                <cfelse>
                                    -
                                </cfif>
                            </td>
                            <td  style="text-align:right;">
                                <cfif isdefined('satis_siparis_tutar_kdvsiz_#report_groupby_id#') and len(evaluate("satis_siparis_tutar_kdvsiz_#report_groupby_id#"))>
                                    <cfset page_totals[1][54] = page_totals[1][54] + evaluate("satis_siparis_tutar_kdvsiz_#report_groupby_id#")><!--- soracam--->
                                    #TLFormat(evaluate("satis_siparis_tutar_kdvsiz_#report_groupby_id#"))#
                                <cfelse>
                                    -
                                </cfif>
                            </td>
                            <td>#session.ep.money#</td>
                            <cfif len(session.ep.money2)>
                                <td  style="text-align:right;">
                                    <cfif isdefined('satis_siparis_doviz_tutar_#report_groupby_id#') and len(evaluate("satis_siparis_doviz_tutar_#report_groupby_id#"))>
                                        <cfset page_totals[1][9] = page_totals[1][9] + evaluate("satis_siparis_doviz_tutar_#report_groupby_id#")><!--- proje için yapılmış satış siparişleri tutar--->
                                        #TLFormat(evaluate("satis_siparis_doviz_tutar_#report_groupby_id#"))#
                                    <cfelse>
                                        -
                                    </cfif>
                                </td>
                                <td  style="text-align:right;">
                                    <cfif isdefined('satis_siparis_doviz_tutar_kdvsiz_#report_groupby_id#') and len(evaluate("satis_siparis_doviz_tutar_kdvsiz_#report_groupby_id#"))>
                                        <cfset page_totals[1][55] = page_totals[1][55] + evaluate("satis_siparis_doviz_tutar_kdvsiz_#report_groupby_id#")><!--- soracam--->
                                        #TLFormat(evaluate("satis_siparis_doviz_tutar_kdvsiz_#report_groupby_id#"))#
                                    <cfelse>
                                        -
                                    </cfif>
                                </td>
                                <td>#session.ep.money2#</td>
                            </cfif>
                        </cfif>
                        <cfif listfind(attributes.listing_type,4)>
                            <td  style="text-align:right;">
                                <cfif isdefined('alis_irs_miktar_#report_groupby_id#') and len(evaluate("alis_irs_miktar_#report_groupby_id#"))>
                                    <cfset page_totals[1][10] = page_totals[1][10] + evaluate("alis_irs_miktar_#report_groupby_id#")><!--- proje için yapılmış alış irsaliye miktar--->
                                    #TLFormat(evaluate("alis_irs_miktar_#report_groupby_id#"))#
                                <cfelse>
                                    -
                                </cfif>
                            </td>
                            <td  style="text-align:right;">
                                <cfif isdefined('alis_irs_tutar_#report_groupby_id#') and len(evaluate("alis_irs_tutar_#report_groupby_id#"))>
                                    <cfset page_totals[1][11] = page_totals[1][11] + evaluate("alis_irs_tutar_#report_groupby_id#")><!--- proje için yapılmış alış irsaliye tutar--->
                                    #TLFormat(evaluate("alis_irs_tutar_#report_groupby_id#"))#
                                <cfelse>
                                    -
                                </cfif>
                            </td>
                            <td  style="text-align:right;">
                                <cfif isdefined('alis_irs_tutar_kdvsiz_#report_groupby_id#') and len(evaluate("alis_irs_tutar_kdvsiz_#report_groupby_id#"))>
                                    <cfset page_totals[1][56] = page_totals[1][56] + evaluate("alis_irs_tutar_kdvsiz_#report_groupby_id#")><!--- soracam--->
                                    #TLFormat(evaluate("alis_irs_tutar_kdvsiz_#report_groupby_id#"))#
                                <cfelse>
                                    -
                                </cfif> 
                            </td>
                            <td>#session.ep.money#</td>
                            <cfif len(session.ep.money2) >
                                <td  style="text-align:right;">
                                    <cfif isdefined('alis_irs_doviz_tutar_#report_groupby_id#') and len(evaluate("alis_irs_doviz_tutar_#report_groupby_id#"))>
                                        <cfset page_totals[1][12] = page_totals[1][12] + evaluate("alis_irs_doviz_tutar_#report_groupby_id#")><!--- proje için yapılmış alış irsaliye tutar--->
                                        #TLFormat(evaluate("alis_irs_doviz_tutar_#report_groupby_id#"))#
                                    <cfelse>
                                        -
                                    </cfif>
                                </td>
                                <td  style="text-align:right;">
                                    <cfif isdefined('alis_irs_doviz_tutar_kdvsiz_#report_groupby_id#') and len(evaluate("alis_irs_doviz_tutar_kdvsiz_#report_groupby_id#"))>
                                        <cfset page_totals[1][57] = page_totals[1][57] + evaluate("alis_irs_doviz_tutar_kdvsiz_#report_groupby_id#")><!--- soracam--->
                                        #TLFormat(evaluate("alis_irs_doviz_tutar_kdvsiz_#report_groupby_id#"))#
                                    <cfelse>
                                        -
                                    </cfif>
                                </td>
                                <td>#session.ep.money2#</td>
                            </cfif>
                        </cfif>
                        <cfif listfind(attributes.listing_type,6)>
                            <td  style="text-align:right;">
                                <cfif isdefined('ithalat_irs_miktar_#report_groupby_id#') and len(evaluate("ithalat_irs_miktar_#report_groupby_id#"))>
                                    <cfset page_totals[1][13] = page_totals[1][13] + evaluate("ithalat_irs_miktar_#report_groupby_id#")><!--- proje için yapılmış ithalat irsaliye miktar--->
                                    #TLFormat(evaluate("ithalat_irs_miktar_#report_groupby_id#"))#
                                <cfelse>
                                    -
                                </cfif>
                            </td>
                            <td  style="text-align:right;">
                                <cfif isdefined('ithalat_irs_tutar_#report_groupby_id#') and len(evaluate("ithalat_irs_tutar_#report_groupby_id#"))>
                                    <cfset page_totals[1][14] = page_totals[1][14] + evaluate("ithalat_irs_tutar_#report_groupby_id#")><!--- proje için yapılmış ithalat irsaliye tutar--->
                                    #TLFormat(evaluate("ithalat_irs_tutar_#report_groupby_id#"))#
                                <cfelse>
                                    -
                                </cfif>
                            </td>
                            <td  style="text-align:right;">
                                <cfif isdefined('ithalat_irs_tutar_kdvsiz_#report_groupby_id#') and len(evaluate("ithalat_irs_tutar_kdvsiz_#report_groupby_id#"))>
                                    <cfset page_totals[1][58] = page_totals[1][58] + evaluate("ithalat_irs_tutar_kdvsiz_#report_groupby_id#")><!--- soracam--->
                                    #TLFormat(evaluate("ithalat_irs_tutar_kdvsiz_#report_groupby_id#"))#
                                <cfelse>
                                    -
                                </cfif>
                            </td>
                            <td>#session.ep.money#</td>
                            <cfif len(session.ep.money2)>
                                <td  style="text-align:right;">
                                    <cfif isdefined('ithalat_irs_doviz_tutar_#report_groupby_id#') and len(evaluate("ithalat_irs_doviz_tutar_#report_groupby_id#"))>
                                        <cfset page_totals[1][15] = page_totals[1][15] + evaluate("ithalat_irs_doviz_tutar_#report_groupby_id#")><!--- proje için yapılmış ithalat irsaliye tutar--->
                                        #TLFormat(evaluate("ithalat_irs_doviz_tutar_#report_groupby_id#"))#
                                    <cfelse>
                                        -
                                    </cfif>
                                </td>
                                <td  style="text-align:right;">
                                    <cfif isdefined('ithalat_irs_doviz_tutar_kdvsiz_#report_groupby_id#') and len(evaluate("ithalat_irs_doviz_tutar_kdvsiz_#report_groupby_id#"))>
                                        <cfset page_totals[1][59] = page_totals[1][59] + evaluate("ithalat_irs_doviz_tutar_kdvsiz_#report_groupby_id#")><!--- soracam--->
                                        #TLFormat(evaluate("ithalat_irs_doviz_tutar_kdvsiz_#report_groupby_id#"))#
                                    <cfelse>
                                        -
                                    </cfif>
                                </td>
                                <td>#session.ep.money2#</td>
                            </cfif>
                        </cfif>
                        <cfif listfind(attributes.listing_type,5)>
                            <td  style="text-align:right;">
                                <cfif isdefined('satis_irs_miktar_#report_groupby_id#') and len(evaluate("satis_irs_miktar_#report_groupby_id#"))>
                                    <cfset page_totals[1][16] = page_totals[1][16] + evaluate("satis_irs_miktar_#report_groupby_id#")><!--- proje için yapılmış satiş irsaliye miktar--->
                                    #TLFormat(evaluate("satis_irs_miktar_#report_groupby_id#"))#
                                <cfelse>
                                    -
                                </cfif>
                            </td>
                            <td  style="text-align:right;">
                                <cfif isdefined('satis_irs_tutar_#report_groupby_id#') and len(evaluate("satis_irs_tutar_#report_groupby_id#"))>
                                    <cfset page_totals[1][17] = page_totals[1][17] + evaluate("satis_irs_tutar_#report_groupby_id#")><!--- proje için yapılmış satiş irsaliye tutar--->
                                    #TLFormat(evaluate("satis_irs_tutar_#report_groupby_id#"))#
                                <cfelse>
                                    -
                                </cfif>
                            </td>
                            <td  style="text-align:right;">
                                <cfif isdefined('satis_irs_tutar_kdvsiz_#report_groupby_id#') and len(evaluate("satis_irs_tutar_kdvsiz_#report_groupby_id#"))>
                                    <cfset page_totals[1][60] = page_totals[1][60] + evaluate("satis_irs_tutar_kdvsiz_#report_groupby_id#")><!--- soracam--->
                                    #TLFormat(evaluate("satis_irs_tutar_kdvsiz_#report_groupby_id#"))#
                                <cfelse>
                                    -
                                </cfif>
                            </td>
                            <td>#session.ep.money#</td>
                            <cfif len(session.ep.money2)>
                                <td  style="text-align:right;">
                                    <cfif isdefined('satis_irs_doviz_tutar_#report_groupby_id#') and len(evaluate("satis_irs_doviz_tutar_#report_groupby_id#"))>
                                        <cfset page_totals[1][18] = page_totals[1][18] + evaluate("satis_irs_doviz_tutar_#report_groupby_id#")><!--- proje için yapılmış satiş irsaliye tutar--->
                                        #TLFormat(evaluate("satis_irs_doviz_tutar_#report_groupby_id#"))#
                                    <cfelse>
                                        -
                                    </cfif>
                                </td>
                                <td  style="text-align:right;">
                                    <cfif isdefined('satis_irs_doviz_tutar_kdvsiz_#report_groupby_id#') and len(evaluate("satis_irs_doviz_tutar_kdvsiz_#report_groupby_id#"))>
                                        <cfset page_totals[1][61] = page_totals[1][61] + evaluate("satis_irs_doviz_tutar_kdvsiz_#report_groupby_id#")><!--- soracam--->
                                        #TLFormat(evaluate("satis_irs_doviz_tutar_kdvsiz_#report_groupby_id#"))#
                                    <cfelse>
                                        -
                                    </cfif>
                                </td>
                                <td>#session.ep.money2#</td>
                            </cfif>
                        </cfif>
                        <cfif listfind(attributes.listing_type,7)>
                            <td  style="text-align:right;">
                                <cfif isdefined('sarf_miktar_#report_groupby_id#') and len(evaluate("sarf_miktar_#report_groupby_id#"))>
                                    <cfset page_totals[1][19] = page_totals[1][19] + evaluate("sarf_miktar_#report_groupby_id#")><!--- proje için yapılmış sarflar miktar--->
                                    #TLFormat(evaluate("sarf_miktar_#report_groupby_id#"))#
                                <cfelse>
                                    -
                                </cfif>
                            </td>
                            <td  style="text-align:right;">
                                <cfif isdefined('sarf_tutar_#report_groupby_id#') and len(evaluate("sarf_tutar_#report_groupby_id#"))>
                                    <cfset page_totals[1][20] = page_totals[1][20] + evaluate("sarf_tutar_#report_groupby_id#")><!--- proje için yapılmış sarflar tutar--->
                                    #TLFormat(evaluate("sarf_tutar_#report_groupby_id#"))#
                                <cfelse>
                                    -
                                </cfif>
                            </td>
                            <td  style="text-align:right;">
                                <cfif isdefined('sarf_tutar_kdvsiz_#report_groupby_id#') and len(evaluate("sarf_tutar_kdvsiz_#report_groupby_id#"))>
                                    <cfset page_totals[1][62] = page_totals[1][62] + evaluate("sarf_tutar_kdvsiz_#report_groupby_id#")><!--- soracam--->
                                    #TLFormat(evaluate("sarf_tutar_kdvsiz_#report_groupby_id#"))#
                                <cfelse>
                                    -
                                </cfif>
                            </td>
                            <td>#session.ep.money#</td>
                            <cfif len(session.ep.money2)>
                                <td  style="text-align:right;">
                                    <cfif isdefined('sarf_doviz_tutar_#report_groupby_id#') and len(evaluate("sarf_doviz_tutar_#report_groupby_id#"))>
                                        <cfset page_totals[1][21] = page_totals[1][21] + evaluate("sarf_doviz_tutar_#report_groupby_id#")><!--- proje için yapılmış sarflar tutar--->
                                        #TLFormat(evaluate("sarf_doviz_tutar_#report_groupby_id#"))#
                                    <cfelse>
                                        -
                                    </cfif>
                                </td>
                                <td  style="text-align:right;">
                                    <cfif isdefined('sarf_doviz_tutar_kdvsiz_#report_groupby_id#') and len(evaluate("sarf_doviz_tutar_kdvsiz_#report_groupby_id#"))>
                                        <cfset page_totals[1][63] = page_totals[1][63] + evaluate("sarf_doviz_tutar_kdvsiz_#report_groupby_id#")><!--- soracam--->
                                        #TLFormat(evaluate("sarf_doviz_tutar_kdvsiz_#report_groupby_id#"))#
                                    <cfelse>
                                        -
                                    </cfif>
                                </td>
                                <td>#session.ep.money2#</td>
                            </cfif>
                        </cfif>
                        <cfif listfind(attributes.listing_type,17)>
                            <td  style="text-align:right;">
                                <cfif isdefined('fire_miktar_#report_groupby_id#') and len(evaluate("fire_miktar_#report_groupby_id#"))>
                                    <cfset page_totals[1][82] = page_totals[1][82] + evaluate("fire_miktar_#report_groupby_id#")><!--- proje için yapılmış sarflar miktar--->
                                    #TLFormat(evaluate("fire_miktar_#report_groupby_id#"))#
                                <cfelse>
                                    -
                                </cfif>
                            </td>
                            <td  style="text-align:right;">
                                <cfif isdefined('fire_tutar_#report_groupby_id#') and len(evaluate("fire_tutar_#report_groupby_id#"))>
                                    <cfset page_totals[1][83] = page_totals[1][83] + evaluate("fire_tutar_#report_groupby_id#")><!--- proje için yapılmış sarflar tutar--->
                                    #TLFormat(evaluate("fire_tutar_#report_groupby_id#"))#
                                <cfelse>
                                    -
                                </cfif>
                            </td>
                            <td  style="text-align:right;">
                                <cfif isdefined('fire_tutar_kdvsiz_#report_groupby_id#') and len(evaluate("fire_tutar_kdvsiz_#report_groupby_id#"))>
                                    <cfset page_totals[1][84] = page_totals[1][84] + evaluate("fire_tutar_kdvsiz_#report_groupby_id#")><!--- soracam--->
                                    #TLFormat(evaluate("fire_tutar_kdvsiz_#report_groupby_id#"))#
                                <cfelse>
                                    -
                                </cfif>
                            </td>
                            <td>#session.ep.money#</td>
                            <cfif len(session.ep.money2)>
                                <td  style="text-align:right;">
                                    <cfif isdefined('fire_doviz_tutar_#report_groupby_id#') and len(evaluate("fire_doviz_tutar_#report_groupby_id#"))>
                                        <cfset page_totals[1][85] = page_totals[1][85] + evaluate("fire_doviz_tutar_#report_groupby_id#")><!--- proje için yapılmış sarflar tutar--->
                                        #TLFormat(evaluate("fire_doviz_tutar_#report_groupby_id#"))#
                                    <cfelse>
                                        -
                                    </cfif>
                                </td>
                                <td  style="text-align:right;">
                                    <cfif isdefined('fire_doviz_tutar_kdvsiz_#report_groupby_id#') and len(evaluate("fire_doviz_tutar_kdvsiz_#report_groupby_id#"))>
                                        <cfset page_totals[1][86] = page_totals[1][86] + evaluate("fire_doviz_tutar_kdvsiz_#report_groupby_id#")><!--- soracam--->
                                        #TLFormat(evaluate("fire_doviz_tutar_kdvsiz_#report_groupby_id#"))#
                                    <cfelse>
                                        -
                                    </cfif>
                                </td>
                                <td>#session.ep.money2#</td>
                            </cfif>
                        </cfif>
                        <cfif listfind(attributes.listing_type,8)>
                            <td  style="text-align:right;">
                                <cfif isdefined('uretim_miktar_#report_groupby_id#') and len(evaluate("uretim_miktar_#report_groupby_id#"))>
                                    <cfset page_totals[1][22] = page_totals[1][22] + evaluate("uretim_miktar_#report_groupby_id#")><!--- proje için yapılmış üretim miktar--->
                                    #TLFormat(evaluate("uretim_miktar_#report_groupby_id#"))#
                                <cfelse>
                                    -
                                </cfif>
                            </td>
                            <td  style="text-align:right;">
                                <cfif isdefined('uretim_tutar_#report_groupby_id#') and len(evaluate("uretim_tutar_#report_groupby_id#"))>
                                    <cfset page_totals[1][23] = page_totals[1][23] + evaluate("uretim_tutar_#report_groupby_id#")><!--- proje için yapılmış üretim tutar--->
                                    #TLFormat(evaluate("uretim_tutar_#report_groupby_id#"))#
                                <cfelse>
                                    -
                                </cfif>
                            </td>
                            <td  style="text-align:right;">
                                <cfif isdefined('uretim_tutar_kdvsiz_#report_groupby_id#') and len(evaluate("uretim_tutar_kdvsiz_#report_groupby_id#"))>
                                    <cfset page_totals[1][64] = page_totals[1][64] + evaluate("uretim_tutar_kdvsiz_#report_groupby_id#")><!--- soracam--->
                                    #TLFormat(evaluate("uretim_tutar_kdvsiz_#report_groupby_id#"))#
                                <cfelse>
                                    -
                                </cfif>
                            </td>
                            <td>#session.ep.money#</td>
                            <cfif len(session.ep.money2)>
                                <td  style="text-align:right;">
                                    <cfif isdefined('uretim_doviz_tutar_#report_groupby_id#') and len(evaluate("uretim_doviz_tutar_#report_groupby_id#"))>
                                        <cfset page_totals[1][24] = page_totals[1][24] + evaluate("uretim_doviz_tutar_#report_groupby_id#")><!--- proje için yapılmış üretim döviz tutar--->
                                        #TLFormat(evaluate("uretim_doviz_tutar_#report_groupby_id#"))#
                                    <cfelse>
                                        -
                                    </cfif>
                                </td>
                                <td  style="text-align:right;">
                                    <cfif isdefined('uretim_doviz_tutar_kdvsiz_#report_groupby_id#') and len(evaluate("uretim_doviz_tutar_kdvsiz_#report_groupby_id#"))>
                                        <cfset page_totals[1][65] = page_totals[1][65] + evaluate("uretim_doviz_tutar_kdvsiz_#report_groupby_id#")><!--- soracam--->
                                        #TLFormat(evaluate("uretim_doviz_tutar_kdvsiz_#report_groupby_id#"))#
                                    <cfelse>
                                        -
                                    </cfif>
                                </td>
                                <td>#session.ep.money2#</td>
                            </cfif>
                        </cfif>
                        <cfif listfind(attributes.listing_type,9)>
                            <td  style="text-align:right;">
                                <cfif isdefined('alis_fat_miktar_#report_groupby_id#') and len(evaluate("alis_fat_miktar_#report_groupby_id#"))>
                                    <cfset page_totals[1][25] = page_totals[1][25] + evaluate("alis_fat_miktar_#report_groupby_id#")><!--- projeye ait alış faturası miktar--->
                                    #TLFormat(evaluate("alis_fat_miktar_#report_groupby_id#"))#
                                <cfelse>
                                    -
                                </cfif>
                            </td>
                            <td  style="text-align:right;">
                                <cfif isdefined('alis_fat_tutar_#report_groupby_id#') and len(evaluate("alis_fat_tutar_#report_groupby_id#"))>
                                    <cfset page_totals[1][26] = page_totals[1][26] + evaluate("alis_fat_tutar_#report_groupby_id#")><!--- projeye ait alış faturası tutar--->
                                    #TLFormat(evaluate("alis_fat_tutar_#report_groupby_id#"))#
                                <cfelse>
                                    -
                                </cfif>
                            </td>
                            <td  style="text-align:right;">
                                <cfif isdefined('alis_fat_tutar_kdvsiz_#report_groupby_id#') and len(evaluate("alis_fat_tutar_kdvsiz_#report_groupby_id#"))>
                                    <cfset page_totals[1][66] = page_totals[1][66] + evaluate("alis_fat_tutar_kdvsiz_#report_groupby_id#")><!--- soracam--->
                                    #TLFormat(evaluate("alis_fat_tutar_kdvsiz_#report_groupby_id#"))#
                                <cfelse>
                                    -
                                </cfif>
                            </td>
                            <td>#session.ep.money#</td>
                            <cfif len(session.ep.money2)>
                                <td  style="text-align:right;">
                                    <cfif isdefined('alis_fat_doviz_tutar_#report_groupby_id#') and len(evaluate("alis_fat_doviz_tutar_#report_groupby_id#"))>
                                        <cfset page_totals[1][27] = page_totals[1][27] + evaluate("alis_fat_doviz_tutar_#report_groupby_id#")><!--- projeye ait alış faturası tutar--->
                                        #TLFormat(evaluate("alis_fat_doviz_tutar_#report_groupby_id#"))#
                                    <cfelse>
                                        -
                                    </cfif>
                                </td>
                                <td  style="text-align:right;">
                                    <cfif isdefined('alis_fat_doviz_tutar_kdvsiz_#report_groupby_id#') and len(evaluate("alis_fat_doviz_tutar_kdvsiz_#report_groupby_id#"))>
                                        <cfset page_totals[1][67] = page_totals[1][67] + evaluate("alis_fat_doviz_tutar_kdvsiz_#report_groupby_id#")><!--- soracam--->
                                        #TLFormat(evaluate("alis_fat_doviz_tutar_kdvsiz_#report_groupby_id#"))#
                                    <cfelse>
                                        -
                                    </cfif>
                                </td>
                                <td>#session.ep.money2#</td>
                            </cfif>
                        </cfif>
                        <cfif listfind(attributes.listing_type,10)>
                            <td  style="text-align:right;">
                                <cfif isdefined('satis_fat_miktar_#report_groupby_id#') and len(evaluate("satis_fat_miktar_#report_groupby_id#"))>
                                    <cfset page_totals[1][28] = page_totals[1][28] + evaluate("satis_fat_miktar_#report_groupby_id#")><!--- projeye ait satış faturası miktar--->
                                    #TLFormat(evaluate("satis_fat_miktar_#report_groupby_id#"))#
                                <cfelse>
                                    -
                                </cfif>
                            </td>
                            <td  style="text-align:right;">
                                <cfif isdefined('satis_fat_tutar_#report_groupby_id#') and len(evaluate("satis_fat_tutar_#report_groupby_id#"))>
                                    <cfset page_totals[1][29] = page_totals[1][29] + evaluate("satis_fat_tutar_#report_groupby_id#")><!--- projeye ait satış faturası tutar--->
                                    #TLFormat(evaluate("satis_fat_tutar_#report_groupby_id#"))#
                                <cfelse>
                                    -
                                </cfif>
                            </td>
                            <td  style="text-align:right;">
                                <cfif isdefined('satis_fat_tutar_kdvsiz_#report_groupby_id#') and len(evaluate("satis_fat_tutar_kdvsiz_#report_groupby_id#"))>
                                    <cfset page_totals[1][68] = page_totals[1][68] + evaluate("satis_fat_tutar_kdvsiz_#report_groupby_id#")><!--- soracam--->
                                    #TLFormat(evaluate("satis_fat_tutar_kdvsiz_#report_groupby_id#"))#
                                <cfelse>
                                    -
                                </cfif>
                            </td>
                            <td>#session.ep.money#</td>
                            <cfif len(session.ep.money2)>
                                <td  style="text-align:right;">
                                    <cfif isdefined('satis_fat_doviz_tutar_#report_groupby_id#') and len(evaluate("satis_fat_doviz_tutar_#report_groupby_id#"))>
                                        <cfset page_totals[1][30] = page_totals[1][30] + evaluate("satis_fat_doviz_tutar_#report_groupby_id#")><!--- projeye ait satış faturası tutar--->
                                        #TLFormat(evaluate("satis_fat_doviz_tutar_#report_groupby_id#"))#
                                    <cfelse>
                                        -
                                    </cfif>
                                </td>
                                <td  style="text-align:right;">
                                    <cfif isdefined('satis_fat_doviz_tutar_kdvsiz_#report_groupby_id#') and len(evaluate("satis_fat_doviz_tutar_kdvsiz_#report_groupby_id#"))>
                                        <cfset page_totals[1][69] = page_totals[1][69] + evaluate("satis_fat_doviz_tutar_kdvsiz_#report_groupby_id#")><!--- soracam--->
                                        #TLFormat(evaluate("satis_fat_doviz_tutar_kdvsiz_#report_groupby_id#"))#
                                    <cfelse>
                                        -
                                    </cfif>
                                </td>
                                <td>#session.ep.money2#</td>
                            </cfif>
                        </cfif>
                        <cfif listfind(attributes.listing_type,11)>
                            <td  style="text-align:right;">
                                <cfif isdefined('satis_fat_miktar_#report_groupby_id#') and len(evaluate("satis_fat_miktar_#report_groupby_id#"))>
                                    <cfset hakedis_miktar = hakedis_miktar + evaluate("satis_fat_miktar_#report_groupby_id#")>
                                </cfif>
                                <cfif isdefined('sarf_miktar_#report_groupby_id#') and len(evaluate("sarf_miktar_#report_groupby_id#"))>
                                    <cfset hakedis_miktar = hakedis_miktar - evaluate("sarf_miktar_#report_groupby_id#")>
                                </cfif>
                                <cfset page_totals[1][31] = page_totals[1][31] + hakedis_miktar>
                                #TLFormat(hakedis_miktar)#
                            </td>
                            <td  style="text-align:right;">
                                <cfif isdefined('satis_fat_tutar_#report_groupby_id#') and len(evaluate("satis_fat_tutar_#report_groupby_id#"))>
                                    <cfset hakedis_tutar = hakedis_tutar + evaluate("satis_fat_tutar_#report_groupby_id#")>
                                </cfif>
                                <cfif isdefined('sarf_tutar_#report_groupby_id#') and len(evaluate("sarf_tutar_#report_groupby_id#"))>
                                    <cfset hakedis_tutar = hakedis_tutar - evaluate("sarf_tutar_#report_groupby_id#")>
                                </cfif>		
                                <cfset page_totals[1][32] = page_totals[1][32] + hakedis_tutar>	
                                #TLFormat(hakedis_tutar)#
                            </td>
                            <td  style="text-align:right;">
                                -
                            </td>
                            <td>#session.ep.money#</td>
                            <cfif len(session.ep.money2)>
                                <td  style="text-align:right;">
                                    <cfif isdefined('satis_fat_doviz_tutar_#report_groupby_id#') and len(evaluate("satis_fat_doviz_tutar_#report_groupby_id#"))>
                                        <cfset hakedis_doviz_tutar = hakedis_doviz_tutar + evaluate("satis_fat_doviz_tutar_#report_groupby_id#")>
                                    </cfif>
                                    <cfif isdefined('sarf_doviz_tutar_#report_groupby_id#') and len(evaluate("sarf_doviz_tutar_#report_groupby_id#"))>
                                        <cfset hakedis_doviz_tutar = hakedis_doviz_tutar - evaluate("sarf_doviz_tutar_#report_groupby_id#")>
                                    </cfif>
                                    <cfset page_totals[1][33] = page_totals[1][33] + hakedis_doviz_tutar>	
                                    #TLFormat(hakedis_doviz_tutar)#
                                </td>
                                <td  style="text-align:right;">
                                -
                                </td>
                                <td>#session.ep.money2#</td>
                            </cfif>
                        </cfif>
                        <cfif listfind(attributes.listing_type,12)>
                            <td  style="text-align:right;">
                                <cfif isdefined('depo_irs_miktar_#report_groupby_id#') and len(evaluate("depo_irs_miktar_#report_groupby_id#"))>
                                    <cfset page_totals[1][34] = page_totals[1][34] + evaluate("depo_irs_miktar_#report_groupby_id#")><!--- proje için yapılmış depo irsaliye miktar--->
                                    #TLFormat(evaluate("depo_irs_miktar_#report_groupby_id#"))#
                                <cfelse>
                                    -
                                </cfif>
                            </td>
                            <td  style="text-align:right;">
                                <cfif isdefined('depo_irs_tutar_#report_groupby_id#') and len(evaluate("depo_irs_tutar_#report_groupby_id#"))>
                                    <cfset page_totals[1][35] = page_totals[1][35] + evaluate("depo_irs_tutar_#report_groupby_id#")><!--- proje için yapılmış depo irsaliye tutar--->
                                    #TLFormat(evaluate("depo_irs_tutar_#report_groupby_id#"))#
                                <cfelse>
                                    -
                                </cfif>
                            </td>
                            <td  style="text-align:right;">
                                <cfif isdefined('depo_irs_tutar_kdvsiz_#report_groupby_id#') and len(evaluate("depo_irs_tutar_kdvsiz_#report_groupby_id#"))>
                                    <cfset page_totals[1][70] = page_totals[1][70] + evaluate("depo_irs_tutar_kdvsiz_#report_groupby_id#")><!--- soracam--->
                                    #TLFormat(evaluate("depo_irs_tutar_kdvsiz_#report_groupby_id#"))#
                                <cfelse>
                                    -
                                </cfif>
                            </td>
                            <td>#session.ep.money#</td>
                            <cfif len(session.ep.money2)>
                                <td  style="text-align:right;">
                                    <cfif isdefined('depo_irs_doviz_tutar_#report_groupby_id#') and len(evaluate("depo_irs_doviz_tutar_#report_groupby_id#"))>
                                        <cfset page_totals[1][36] = page_totals[1][36] + evaluate("depo_irs_doviz_tutar_#report_groupby_id#")><!--- proje için yapılmış depo irsaliye tutar--->
                                        #TLFormat(evaluate("depo_irs_doviz_tutar_#report_groupby_id#"))#
                                    <cfelse>
                                        -
                                    </cfif>
                                </td>
                                <td  style="text-align:right;">
                                    <cfif isdefined('depo_irs_doviz_tutar_kdvsiz_#report_groupby_id#') and len(evaluate("depo_irs_doviz_tutar_kdvsiz_#report_groupby_id#"))>
                                        <cfset page_totals[1][71] = page_totals[1][71] + evaluate("depo_irs_doviz_tutar_kdvsiz_#report_groupby_id#")><!--- soracam--->
                                        #TLFormat(evaluate("depo_irs_doviz_tutar_kdvsiz_#report_groupby_id#"))#
                                    <cfelse>
                                        -
                                    </cfif>
                                </td>
                                <td>#session.ep.money2#</td>
                            </cfif>
                        </cfif>
                        <cfif listfind(attributes.listing_type,13)>
                            <td  style="text-align:right;">
                                <cfif isdefined('ic_talep_miktar_#report_groupby_id#') and len(evaluate("ic_talep_miktar_#report_groupby_id#"))>
                                    <cfset page_totals[1][37] = page_totals[1][37] + evaluate("ic_talep_miktar_#report_groupby_id#")><!--- proje için yapılmış iç talep irsaliye miktar--->
                                    #TLFormat(evaluate("ic_talep_miktar_#report_groupby_id#"))#
                                <cfelse>
                                    -
                                </cfif>
                            </td>
                            <td  style="text-align:right;">
                                <cfif isdefined('ic_talep_tutar_#report_groupby_id#') and len(evaluate("ic_talep_tutar_#report_groupby_id#"))>
                                    <cfset page_totals[1][38] = page_totals[1][38] + evaluate("ic_talep_tutar_#report_groupby_id#")><!--- proje için yapılmış iç talep irsaliye tutar--->
                                    #TLFormat(evaluate("ic_talep_tutar_#report_groupby_id#"))#
                                <cfelse>
                                    -
                                </cfif>
                            </td>
                            <td  style="text-align:right;">
                                <cfif isdefined('ic_talep_tutar_kdvsiz_#report_groupby_id#') and len(evaluate("ic_talep_tutar_kdvsiz_#report_groupby_id#"))>
                                    <cfset page_totals[1][72] = page_totals[1][72] + evaluate("ic_talep_tutar_kdvsiz_#report_groupby_id#")><!--- soracam--->
                                    #TLFormat(evaluate("ic_talep_tutar_kdvsiz_#report_groupby_id#"))#
                                <cfelse>
                                    -
                                </cfif>
                            </td>
                            <td>#session.ep.money#</td>
                            <cfif len(session.ep.money2)>
                                <td  style="text-align:right;">
                                    <cfif isdefined('ic_talep_doviz_tutar_#report_groupby_id#') and len(evaluate("ic_talep_doviz_tutar_#report_groupby_id#"))>
                                        <cfset page_totals[1][39] = page_totals[1][39] + evaluate("ic_talep_doviz_tutar_#report_groupby_id#")><!--- proje için yapılmış iç talep irsaliye tutar--->
                                        #TLFormat(evaluate("ic_talep_doviz_tutar_#report_groupby_id#"))#
                                    <cfelse>
                                        -
                                    </cfif>
                                </td>
                                <td  style="text-align:right;">
                                    <cfif isdefined('ic_talep_doviz_tutar_kdvsiz_#report_groupby_id#') and len(evaluate("ic_talep_doviz_tutar_kdvsiz_#report_groupby_id#"))>
                                        <cfset page_totals[1][73] = page_totals[1][73] + evaluate("ic_talep_doviz_tutar_kdvsiz_#report_groupby_id#")><!--- soracam--->
                                        #TLFormat(evaluate("ic_talep_doviz_tutar_kdvsiz_#report_groupby_id#"))#
                                    <cfelse>
                                        -
                                    </cfif>
                                </td>
                                <td>#session.ep.money2#</td>
                            </cfif>
                        </cfif>
                        <cfif listfind(attributes.listing_type,14)>
                            <td colspan="2"  style="text-align:right;">
                                <cfif isdefined('uretim_emir_miktar_#report_groupby_id#') and len(evaluate("uretim_emir_miktar_#report_groupby_id#"))>
                                    <cfset page_totals[1][40] = page_totals[1][40] + evaluate("uretim_emir_miktar_#report_groupby_id#")><!--- proje için yapılmış üretim emirleri--->
                                    #TLFormat(evaluate("uretim_emir_miktar_#report_groupby_id#"))# <cf_get_lang dictionary_id ='670.Adet'>
                                <cfelse>
                                    -
                                </cfif>
                            </td>
                        </cfif>
                        <cfif listfind(attributes.listing_type,15)>
                            <td  style="text-align:right;">
                                <cfif isdefined('satinalma_talep_miktar_#report_groupby_id#') and len(evaluate("satinalma_talep_miktar_#report_groupby_id#"))>
                                    <cfset page_totals[1][41] = page_totals[1][41] + evaluate("satinalma_talep_miktar_#report_groupby_id#")><!--- proje için yapılmış iç talep irsaliye miktar--->
                                    #TLFormat(evaluate("satinalma_talep_miktar_#report_groupby_id#"))#
                                <cfelse>
                                    -
                                </cfif>
                            </td>
                            <td  style="text-align:right;">
                                <cfif isdefined('satinalma_talep_tutar_#report_groupby_id#') and len(evaluate("satinalma_talep_tutar_#report_groupby_id#"))>
                                    <cfset page_totals[1][42] = page_totals[1][42] + evaluate("satinalma_talep_tutar_#report_groupby_id#")><!--- proje için yapılmış iç talep irsaliye tutar--->
                                    #TLFormat(evaluate("satinalma_talep_tutar_#report_groupby_id#"))#
                                <cfelse>
                                    -
                                </cfif>
                            </td>
                            <td  style="text-align:right;">
                                <cfif isdefined('satinalma_talep_tutar_kdvsiz_#report_groupby_id#') and len(evaluate("satinalma_talep_tutar_kdvsiz_#report_groupby_id#"))>
                                    <cfset page_totals[1][74] = page_totals[1][74] + evaluate("satinalma_talep_tutar_kdvsiz_#report_groupby_id#")><!--- soracam--->
                                    #TLFormat(evaluate("satinalma_talep_tutar_kdvsiz_#report_groupby_id#"))#
                                <cfelse>
                                    -
                                </cfif>
                            </td>
                            <td>#session.ep.money#</td>
                            <cfif len(session.ep.money2)>
                                <td  style="text-align:right;">
                                    <cfif isdefined('satinalma_talep_doviz_tutar_#report_groupby_id#') and len(evaluate("satinalma_talep_doviz_tutar_#report_groupby_id#"))>
                                        <cfset page_totals[1][43] = page_totals[1][43] + evaluate("satinalma_talep_doviz_tutar_#report_groupby_id#")><!--- proje için yapılmış iç talep irsaliye tutar--->
                                        #TLFormat(evaluate("satinalma_talep_doviz_tutar_#report_groupby_id#"))#
                                    <cfelse>
                                        -
                                    </cfif>
                                </td>
                                <td  style="text-align:right;">
                                    <cfif isdefined('satinalma_talep_doviz_tutar_kdvsiz_#report_groupby_id#') and len(evaluate("satinalma_talep_doviz_tutar_kdvsiz_#report_groupby_id#"))>
                                        <cfset page_totals[1][75] = page_totals[1][75] + evaluate("satinalma_talep_doviz_tutar_kdvsiz_#report_groupby_id#")><!--- soracam--->
                                        #TLFormat(evaluate("satinalma_talep_doviz_tutar_kdvsiz_#report_groupby_id#"))#
                                    <cfelse>
                                        -
                                    </cfif>
                                </td>
                                <td>#session.ep.money2#</td>
                            </cfif>
                        </cfif>
                        <cfif listfind(attributes.listing_type,16)>
                            <td  style="text-align:right;">
                                <cfif isdefined('uretim_talep_miktar_#report_groupby_id#') and len(evaluate("uretim_talep_miktar_#report_groupby_id#"))>
                                    <cfset page_totals[1][44] = page_totals[1][44] + evaluate("uretim_talep_miktar_#report_groupby_id#")><!--- proje için yapılmış iç talep irsaliye miktar--->
                                    #TLFormat(evaluate("uretim_talep_miktar_#report_groupby_id#"))#
                                <cfelse>
                                    -
                                </cfif>
                            </td>
                            <td  style="text-align:right;">
                                <cfif isdefined('uretim_talep_tutar_#report_groupby_id#') and len(evaluate("uretim_talep_tutar_#report_groupby_id#"))>
                                    <cfset page_totals[1][45] = page_totals[1][45] + evaluate("uretim_talep_tutar_#report_groupby_id#")><!--- proje için yapılmış iç talep irsaliye tutar--->
                                    #TLFormat(evaluate("uretim_talep_tutar_#report_groupby_id#"))#
                                <cfelse>
                                    -
                                </cfif>
                            </td>
                            <td  style="text-align:right;">
                                <cfif isdefined('uretim_talep_tutar_kdvsiz_#report_groupby_id#') and len(evaluate("uretim_talep_tutar_kdvsiz_#report_groupby_id#"))>
                                    <cfset page_totals[1][76] = page_totals[1][76] + evaluate("uretim_talep_tutar_kdvsiz_#report_groupby_id#")><!--- soracam--->
                                    #TLFormat(evaluate("uretim_talep_tutar_kdvsiz_#report_groupby_id#"))#
                                <cfelse>
                                    -
                                </cfif>
                            </td>
                            <td>#session.ep.money#</td>
                            <cfif len(session.ep.money2)>
                                <td  style="text-align:right;">
                                    <cfif isdefined('uretim_talep_doviz_tutar_#report_groupby_id#') and len(evaluate("uretim_talep_doviz_tutar_#report_groupby_id#"))>
                                        <cfset page_totals[1][46] = page_totals[1][46] + evaluate("uretim_talep_doviz_tutar_#report_groupby_id#")><!--- proje için yapılmış iç talep irsaliye tutar--->
                                        #TLFormat(evaluate("uretim_talep_doviz_tutar_#report_groupby_id#"))#
                                    <cfelse>
                                        -
                                    </cfif>
                                </td>
                                <td  style="text-align:right;">
                                    <cfif isdefined('uretim_talep_doviz_tutar_kdvsiz_#report_groupby_id#') and len(evaluate("uretim_talep_doviz_tutar_kdvsiz_#report_groupby_id#"))>
                                        <cfset page_totals[1][77] = page_totals[1][77] + evaluate("uretim_talep_doviz_tutar_kdvsiz_#report_groupby_id#")><!--- soracam--->
                                        #TLFormat(evaluate("uretim_talep_doviz_tutar_kdvsiz_#report_groupby_id#"))#
                                    <cfelse>
                                        -
                                    </cfif>
                                </td>
                                <td>#session.ep.money2#</td>
                            </cfif>
                        </cfif>
                    </tr>
                </cfoutput>
                <tr class="total">
                    <!--- stok bazında --->
                    <cfif attributes.report_type eq 1>
                        <td colspan="4"  style="text-align:right;"><b><cf_get_lang dictionary_id ='57492.Toplam'></b>&nbsp;&nbsp;</td>
                    <cfelseif attributes.report_type eq 2><!--- tedarikci bazında --->
                        <td colspan="2"  style="text-align:right;"><b><cf_get_lang dictionary_id ='57492.Toplam'></b>&nbsp;&nbsp;</td>
                    <cfelseif attributes.report_type eq 3><!--- marka bazında --->
                        <td colspan="2"  style="text-align:right;"><b><cf_get_lang dictionary_id ='57492.Toplam'></b>&nbsp;&nbsp;</td>
                    <cfelseif attributes.report_type eq 4><!--- kategori bazında --->
                        <td colspan="3"  style="text-align:right;"><b><cf_get_lang dictionary_id ='57492.Toplam'></b>&nbsp;&nbsp;</td>
                    </cfif>
                    <cfif listfind(attributes.listing_type,1)>
                        <td  style="text-align:right;">
                            <cfoutput>#TLFormat(page_totals[1][1])#</cfoutput>
                        </td>
                        <td  style="text-align:right;">
                            <cfoutput>#TLFormat(page_totals[1][2])#</cfoutput>
                        </td>
                        <td  style="text-align:right;"><cfoutput>#TLFormat(page_totals[1][50])#</cfoutput></td>
                        <td><cfoutput>#session.ep.money#</cfoutput></td>
                        <cfif len(session.ep.money2)>
                            <td  style="text-align:right;">
                                <cfoutput>#TLFormat(page_totals[1][3])#</cfoutput>
                            </td>
                            <td  style="text-align:right;"><cfoutput>#TLFormat(page_totals[1][51])#</cfoutput></td>
                            <td><cfoutput>#session.ep.money2#</cfoutput></td>
                        </cfif>
                    </cfif>
                    <cfif listfind(attributes.listing_type,2)>
                        <td  style="text-align:right;">
                            <cfoutput>#TLFormat(page_totals[1][4])#</cfoutput>
                        </td>
                        <td  style="text-align:right;">
                            <cfoutput>#TLFormat(page_totals[1][5])#</cfoutput>
                        </td>
                        <td  style="text-align:right;"><cfoutput>#TLFormat(page_totals[1][52])#</cfoutput></td>
                        <td><cfoutput>#session.ep.money#</cfoutput></td>
                        <cfif len(session.ep.money2)>
                            <td  style="text-align:right;">
                                <cfoutput>#TLFormat(page_totals[1][6])#</cfoutput>
                            </td>
                            <td  style="text-align:right;"><cfoutput>#TLFormat(page_totals[1][53])#</cfoutput></td>
                            <td><cfoutput>#session.ep.money2#</cfoutput></td>
                        </cfif>
                    </cfif>
                    <cfif listfind(attributes.listing_type,3)>
                        <td  style="text-align:right;">
                            <cfoutput>#TLFormat(page_totals[1][7])#</cfoutput>
                        </td>
                        <td  style="text-align:right;">
                            <cfoutput>#TLFormat(page_totals[1][8])#</cfoutput>
                        </td>
                        <td  style="text-align:right;"><cfoutput>#TLFormat(page_totals[1][54])#</cfoutput></td>
                        <td><cfoutput>#session.ep.money#</cfoutput></td>
                        <cfif len(session.ep.money2)>
                            <td  style="text-align:right;">
                                <cfoutput>#TLFormat(page_totals[1][9])#</cfoutput>
                            </td>
                            <td  style="text-align:right;"><cfoutput>#TLFormat(page_totals[1][55])#</cfoutput></td>
                            <td><cfoutput>#session.ep.money2#</cfoutput></td>
                        </cfif>
                    </cfif>
                    <cfif listfind(attributes.listing_type,4)>
                        <td  style="text-align:right;">
                            <cfoutput>#TLFormat(page_totals[1][10])#</cfoutput>
                        </td>
                        <td  style="text-align:right;">
                            <cfoutput>#TLFormat(page_totals[1][11])#</cfoutput>
                        </td>
                        <td  style="text-align:right;"><cfoutput>#TLFormat(page_totals[1][56])#</cfoutput></td>
                        <td><cfoutput>#session.ep.money#</cfoutput></td>
                        <cfif len(session.ep.money2)>
                            <td  style="text-align:right;">
                                <cfoutput>#TLFormat(page_totals[1][12])#</cfoutput>
                            </td>
                            <td  style="text-align:right;"><cfoutput>#TLFormat(page_totals[1][57])#</cfoutput></td>
                            <td><cfoutput>#session.ep.money2#</cfoutput></td>
                        </cfif>
                    </cfif>
                    <cfif listfind(attributes.listing_type,6)>
                        <td  style="text-align:right;">
                            <cfoutput>#TLFormat(page_totals[1][13])#</cfoutput>
                        </td>
                        <td  style="text-align:right;">
                            <cfoutput>#TLFormat(page_totals[1][14])#</cfoutput>
                        </td>
                        <td  style="text-align:right;"><cfoutput>#TLFormat(page_totals[1][58])#</cfoutput></td>
                        <td><cfoutput>#session.ep.money#</cfoutput></td>
                        <cfif len(session.ep.money2)>
                            <td  style="text-align:right;">
                                <cfoutput>#TLFormat(page_totals[1][15])#</cfoutput>
                            </td>
                            <td  style="text-align:right;"><cfoutput>#TLFormat(page_totals[1][59])#</cfoutput></td>
                            <td><cfoutput>#session.ep.money2#</cfoutput></td>
                        </cfif>
                    </cfif>
                    <cfif listfind(attributes.listing_type,5)>
                        <td  style="text-align:right;">
                            <cfoutput>#TLFormat(page_totals[1][16])#</cfoutput>
                        </td>
                        <td  style="text-align:right;">
                            <cfoutput>#TLFormat(page_totals[1][17])#</cfoutput>
                        </td>
                        <td  style="text-align:right;"><cfoutput>#TLFormat(page_totals[1][60])#</cfoutput></td>
                        <td><cfoutput>#session.ep.money#</cfoutput></td>
                        <cfif len(session.ep.money2)>
                            <td  style="text-align:right;">
                                <cfoutput>#TLFormat(page_totals[1][18])#</cfoutput>
                            </td>
                            <td  style="text-align:right;"><cfoutput>#TLFormat(page_totals[1][61])#</cfoutput></td>
                            <td><cfoutput>#session.ep.money2#</cfoutput></td>
                        </cfif>
                    </cfif>
                    <cfif listfind(attributes.listing_type,7)>
                        <td  style="text-align:right;">
                            <cfoutput>#TLFormat(page_totals[1][19])#</cfoutput>
                        </td>
                        <td  style="text-align:right;">
                            <cfoutput>#TLFormat(page_totals[1][20])#</cfoutput>
                        </td>
                        <td  style="text-align:right;"><cfoutput>#TLFormat(page_totals[1][62])#</cfoutput></td>
                        <td><cfoutput>#session.ep.money#</cfoutput></td>
                        <cfif len(session.ep.money2)>
                            <td  style="text-align:right;">
                                <cfoutput>#TLFormat(page_totals[1][21])#</cfoutput>
                            </td>
                            <td  style="text-align:right;"><cfoutput>#TLFormat(page_totals[1][63])#</cfoutput></td>
                            <td><cfoutput>#session.ep.money2#</cfoutput></td>
                        </cfif>
                    </cfif>
                    <cfif listfind(attributes.listing_type,17)>
                        <td  style="text-align:right;">
                            <cfoutput>#TLFormat(page_totals[1][82])#</cfoutput>
                        </td>
                        <td  style="text-align:right;">
                            <cfoutput>#TLFormat(page_totals[1][83])#</cfoutput>
                        </td>
                        <td  style="text-align:right;"><cfoutput>#TLFormat(page_totals[1][84])#</cfoutput></td>
                        <td><cfoutput>#session.ep.money#</cfoutput></td>
                        <cfif len(session.ep.money2)>
                            <td  style="text-align:right;">
                                <cfoutput>#TLFormat(page_totals[1][85])#</cfoutput>
                            </td>
                            <td  style="text-align:right;"><cfoutput>#TLFormat(page_totals[1][86])#</cfoutput></td>
                            <td><cfoutput>#session.ep.money2#</cfoutput></td>
                        </cfif>
                    </cfif>
                    <cfif listfind(attributes.listing_type,8)>
                        <td  style="text-align:right;">
                            <cfoutput>#TLFormat(page_totals[1][22])#</cfoutput>
                        </td>
                        <td  style="text-align:right;">
                            <cfoutput>#TLFormat(page_totals[1][23])#</cfoutput>
                        </td>
                        <td  style="text-align:right;"><cfoutput>#TLFormat(page_totals[1][64])#</cfoutput></td>
                        <td><cfoutput>#session.ep.money#</cfoutput></td>
                        <cfif len(session.ep.money2)>
                            <td  style="text-align:right;">
                                <cfoutput>#TLFormat(page_totals[1][24])#</cfoutput>
                            </td>
                            <td  style="text-align:right;"><cfoutput>#TLFormat(page_totals[1][65])#</cfoutput></td>
                            <td><cfoutput>#session.ep.money2#</cfoutput></td>
                        </cfif>
                    </cfif>
                    <cfif listfind(attributes.listing_type,9)>
                        <td  style="text-align:right;">
                            <cfoutput>#TLFormat(page_totals[1][25])#</cfoutput>
                        </td>
                        <td  style="text-align:right;">
                            <cfoutput>#TLFormat(page_totals[1][26])#</cfoutput>
                        </td>
                        <td  style="text-align:right;"><cfoutput>#TLFormat(page_totals[1][66])#</cfoutput></td>
                        <td><cfoutput>#session.ep.money#</cfoutput></td>
                        <cfif len(session.ep.money2)>
                            <td  style="text-align:right;">
                                <cfoutput>#TLFormat(page_totals[1][27])#</cfoutput>
                            </td>
                            <td  style="text-align:right;"><cfoutput>#TLFormat(page_totals[1][67])#</cfoutput></td>
                            <td><cfoutput>#session.ep.money2#</cfoutput></td>
                        </cfif>
                    </cfif>
                    <cfif listfind(attributes.listing_type,10)>
                        <td  style="text-align:right;">
                            <cfoutput>#TLFormat(page_totals[1][28])#</cfoutput>
                        </td>
                        <td  style="text-align:right;">
                            <cfoutput>#TLFormat(page_totals[1][29])#</cfoutput>
                        </td>
                        <td  style="text-align:right;"><cfoutput>#TLFormat(page_totals[1][68])#</cfoutput></td>
                        <td><cfoutput>#session.ep.money#</cfoutput></td>
                        <cfif len(session.ep.money2)>
                            <td  style="text-align:right;">
                                <cfoutput>#TLFormat(page_totals[1][30])#</cfoutput>
                            </td>
                            <td  style="text-align:right;"><cfoutput>#TLFormat(page_totals[1][69])#</cfoutput></td>
                            <td><cfoutput>#session.ep.money2#</cfoutput></td>
                        </cfif>
                    </cfif>
                    <cfif listfind(attributes.listing_type,11)>
                        <td  style="text-align:right;">
                            <cfoutput>#TLFormat(page_totals[1][31])#</cfoutput>
                        </td>
                        <td  style="text-align:right;">
                            <cfoutput>#TLFormat(page_totals[1][32])#</cfoutput>
                        </td>
                        <td  style="text-align:right;"><cfoutput>#TLFormat(page_totals[1][70])#</cfoutput></td>
                        <td><cfoutput>#session.ep.money#</cfoutput></td>
                        <cfif len(session.ep.money2)>
                            <td  style="text-align:right;">
                                <cfoutput>#TLFormat(page_totals[1][33])#</cfoutput>
                            </td>
                            <td  style="text-align:right;"><cfoutput>#TLFormat(page_totals[1][71])#</cfoutput></td>
                            <td><cfoutput>#session.ep.money2#</cfoutput></td>
                        </cfif>
                    </cfif>
                    <cfif listfind(attributes.listing_type,12)>
                        <td  style="text-align:right;">
                            <cfoutput>#TLFormat(page_totals[1][34])#</cfoutput>
                        </td>
                        <td  style="text-align:right;">
                            <cfoutput>#TLFormat(page_totals[1][35])#</cfoutput>
                        </td>
                        <td  style="text-align:right;"><cfoutput>#TLFormat(page_totals[1][74])#</cfoutput></td>
                        <td><cfoutput>#session.ep.money#</cfoutput></td>
                        <cfif len(session.ep.money2)>
                            <td  style="text-align:right;">
                                <cfoutput>#TLFormat(page_totals[1][36])#</cfoutput>
                            </td>
                            <td  style="text-align:right;"><cfoutput>#TLFormat(page_totals[1][75])#</cfoutput></td>
                            <td><cfoutput>#session.ep.money2#</cfoutput></td>
                        </cfif>
                    </cfif>
                    <cfif listfind(attributes.listing_type,13)>
                        <td  style="text-align:right;">
                            <cfoutput>#TLFormat(page_totals[1][37])#</cfoutput>
                        </td>
                        <td  style="text-align:right;">
                            <cfoutput>#TLFormat(page_totals[1][38])#</cfoutput>
                        </td>
                        <td  style="text-align:right;"><cfoutput>#TLFormat(page_totals[1][76])#</cfoutput></td>
                        <td><cfoutput>#session.ep.money#</cfoutput></td>
                        <cfif len(session.ep.money2)>
                            <td  style="text-align:right;">
                                <cfoutput>#TLFormat(page_totals[1][39])#</cfoutput>
                            </td>
                            <td  style="text-align:right;"><cfoutput>#TLFormat(page_totals[1][77])#</cfoutput></td>
                            <td><cfoutput>#session.ep.money2#</cfoutput></td>
                        </cfif>
                    </cfif>
                    <cfif listfind(attributes.listing_type,14)>
                        <td colspan="2"  style="text-align:right;">
                            <cfoutput>#TLFormat(page_totals[1][40])#</cfoutput><cf_get_lang dictionary_id ='670.ADET'>
                        </td>
                    </cfif>
                    <cfif listfind(attributes.listing_type,15)>
                        <td  style="text-align:right;">
                            <cfoutput>#TLFormat(page_totals[1][41])#</cfoutput>
                        </td>
                        <td  style="text-align:right;">
                            <cfoutput>#TLFormat(page_totals[1][42])#</cfoutput>
                        </td>
                        <td  style="text-align:right;"><cfoutput>#TLFormat(page_totals[1][78])#</cfoutput></td>
                        <td><cfoutput>#session.ep.money#</cfoutput></td>
                        <cfif len(session.ep.money2)>
                            <td  style="text-align:right;">
                                <cfoutput>#TLFormat(page_totals[1][43])#</cfoutput>
                            </td>
                            <td  style="text-align:right;"><cfoutput>#TLFormat(page_totals[1][79])#</cfoutput></td>
                            <td><cfoutput>#session.ep.money2#</cfoutput></td>
                        </cfif>
                    </cfif>
                    <cfif listfind(attributes.listing_type,16)>
                        <td  style="text-align:right;">
                            <cfoutput>#TLFormat(page_totals[1][44])#</cfoutput>
                        </td>
                        <td  style="text-align:right;">
                            <cfoutput>#TLFormat(page_totals[1][45])#</cfoutput>
                        </td>
                        <td  style="text-align:right;"><cfoutput>#TLFormat(page_totals[1][80])#</cfoutput></td>
                        <td><cfoutput>#session.ep.money#</cfoutput></td>
                        <cfif len(session.ep.money2)>
                            <td  style="text-align:right;">
                                <cfoutput>#TLFormat(page_totals[1][46])#</cfoutput>
                            </td>
                            <td  style="text-align:right;"><cfoutput>#TLFormat(page_totals[1][81])#</cfoutput></td>
                            <td><cfoutput>#session.ep.money2#</cfoutput></td>
                        </cfif>
                    </cfif>
                </tr>
            <cfelseif attributes.report_type eq 6 and  isdefined('urun_id_list') and len(urun_id_list) and len(secim_liste)>
                <cfset fatura_genel_toplam=0>
                <cfset fatura_genel_toplam_adet=0>
                <cfset sarf_genel_toplam=0>
                <cfset sarf_genel_toplam_adet=0>
                <cfset fire_genel_toplam=0>
                <cfset fire_genel_toplam_adet=0>
                <cfset d_sevk_genel_toplam=0>
                <cfset d_sevk_genel_toplam_adet=0>
                <cfloop from="1" to="#listlen(urun_id_list)#" index="sayac">
                <cfoutput>
                <tr>
                    <cfif isdefined('secim_liste') and len(secim_liste)>
                        <cfquery name="GET_STOCK_CODE" dbtype="query">
                            SELECT STOCK_CODE,PRODUCT_NAME FROM get_product_ship_cost WHERE PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ListGetAt(urun_id_list,sayac,',')#">
                        </cfquery>
                        <td style="text-align:center;">#sayac#</td>
                        <td>#get_stock_code.stock_code#</td>
                        <td colspan="2" >
                            #get_stock_code.product_name#
                        </td>
                        <cfif listfind(secim_liste,10,',')>
                            <cfif isdefined('fatura_maliyet_#ListGetAt(urun_id_list,sayac,',')#_1')>
                                <td style="text-align:center;" >#Evaluate('fatura_amount_#ListGetAt(urun_id_list,sayac,',')#_1')#</td>
                                <td  style="text-align:right;">#TLFormat(Evaluate('fatura_maliyet_#ListGetAt(urun_id_list,sayac,',')#_1'))#</td>
                                <cfset fatura_genel_toplam = fatura_genel_toplam + Evaluate('fatura_maliyet_#ListGetAt(urun_id_list,sayac,',')#_1')>
                                <cfset fatura_genel_toplam_adet = fatura_genel_toplam_adet + Evaluate('fatura_amount_#ListGetAt(urun_id_list,sayac,',')#_1')>
                            <cfelse>
                                <td style="text-align:center;" >---</td>
                                <td  style="text-align:right;">---</td>
                            </cfif>
                        </cfif>			
                        <cfif listfind(secim_liste,7,',')>
                            <cfif isdefined('sarf_maliyet_#ListGetAt(urun_id_list,sayac,',')#_2')>
                                <td style="text-align:center;" >#Evaluate('sarf_amount_#ListGetAt(urun_id_list,sayac,',')#_2')#</td>
                                <td  style="text-align:right;">#TLFormat(Evaluate('sarf_maliyet_#ListGetAt(urun_id_list,sayac,',')#_2'))#</td>
                                <cfset sarf_genel_toplam=sarf_genel_toplam + Evaluate('sarf_maliyet_#ListGetAt(urun_id_list,sayac,',')#_2') >
                                <cfset sarf_genel_toplam_adet=sarf_genel_toplam_adet + Evaluate('sarf_amount_#ListGetAt(urun_id_list,sayac,',')#_2')>
                            <cfelse>
                                <td style="text-align:center;" >---</td>
                                <td  style="text-align:right;">---</td>	
                            </cfif>
                        </cfif>
                        <cfif listfind(secim_liste,17,',')>
                            <cfif isdefined('fire_maliyet_#ListGetAt(urun_id_list,sayac,',')#_4')>
                                <td style="text-align:center;" >#Evaluate('fire_amount_#ListGetAt(urun_id_list,sayac,',')#_4')#</td>
                                <td  style="text-align:right;">#TLFormat(Evaluate('fire_maliyet_#ListGetAt(urun_id_list,sayac,',')#_4'))#</td>
                                <cfset fire_genel_toplam=fire_genel_toplam + Evaluate('fire_maliyet_#ListGetAt(urun_id_list,sayac,',')#_4') >
                                <cfset fire_genel_toplam_adet=fire_genel_toplam_adet + Evaluate('fire_amount_#ListGetAt(urun_id_list,sayac,',')#_4')>
                            <cfelse>
                                <td style="text-align:center;" >---</td>
                                <td  style="text-align:right;">---</td>	
                            </cfif>
                        </cfif>
                        <cfif listfind(secim_liste,12,',')>
                            <cfif isdefined('sevk_maliyet_#ListGetAt(urun_id_list,sayac,',')#_3')>
                                <td style="text-align:center;" >#Evaluate('sevk_amount_#ListGetAt(urun_id_list,sayac,',')#_3')#</td>
                                <td  style="text-align:right;">#TLFormat(Evaluate('sevk_maliyet_#ListGetAt(urun_id_list,sayac,',')#_3'))#</td>
                                <cfset d_sevk_genel_toplam=d_sevk_genel_toplam + Evaluate('sevk_maliyet_#ListGetAt(urun_id_list,sayac,',')#_3')>
                                <cfset d_sevk_genel_toplam_adet=d_sevk_genel_toplam_adet + Evaluate('sevk_amount_#ListGetAt(urun_id_list,sayac,',')#_3') >
                            <cfelse>
                                <td style="text-align:center;" >---</td>
                                <td  style="text-align:right;">---</td>
                            </cfif>
                        </cfif>
                    </cfif>	
                </tr>
                </cfoutput>	
                </cfloop>
                <cfif isdefined('secim_liste') and len(secim_liste)>
                    <tr class="total">
                        <cfoutput>
                            <td colspan="4" style="text-align:center;" class="txtbold"><cf_get_lang dictionary_id ='40035.Genel Toplamlar'></td>
                            <cfif listfind(secim_liste,10,',')>
                                <td style="text-align:center;" class="txtbold">#fatura_genel_toplam_adet#</td>
                                <td class="txtbold" style="text-align:right;">#TLFormat(fatura_genel_toplam)#</td>
                            </cfif>
                            <cfif listfind(secim_liste,7,',')>
                                <td style="text-align:center;" class="txtbold">#sarf_genel_toplam_adet#</td>
                                <td class="txtbold" style="text-align:right;">#TLFormat(sarf_genel_toplam)#</td>
                            </cfif>
                            <cfif listfind(secim_liste,17,',')>
                                <td style="text-align:center;" class="txtbold">#fire_genel_toplam_adet#</td>
                                <td class="txtbold" style="text-align:right;">#TLFormat(fire_genel_toplam)#</td>
                            </cfif>
                            <cfif listfind(secim_liste,12,',')>
                                <td style="text-align:center;" class="txtbold">#d_sevk_genel_toplam_adet#</td>
                                <td class="txtbold" style="text-align:right;">#TLFormat(d_sevk_genel_toplam)#</td>
                            </cfif>
                        </cfoutput>
                    </tr>
                </cfif>	
            <cfelse>
                <tr>
                    <td colspan="<cfoutput>#colspan_number+21#</cfoutput>"><cfif isdefined('is_form_submitted')><cf_get_lang dictionary_id ='57484.Kayıt Yok'>!<cfelse><cf_get_lang dictionary_id ='57701.Filtre Ediniz'>!</cfif></td>
                </tr>
            </cfif><!-- sil -->
        </tbody>
    </cf_report_list>
</cfif>
<cfif isdefined('attributes.totalrecords') and  attributes.totalrecords gt attributes.maxrows>
	<cfset adres = "#submit_url#">
	<cfset adres="#adres#&report_type=#attributes.report_type#">
	<cfif isdefined('url.pro_met_id') and len(url.pro_met_id)>
		<cfset adres="#adres#&pro_met_id=#attributes.pro_met_id#">
	</cfif>
	<cfif isdefined('attributes.listing_type')>
		<cfset adres="#adres#&listing_type=#attributes.listing_type#">
	</cfif>	
    <cfif len(attributes.project_id) and len(attributes.project_id)>
		<cfset adres="#adres#&project_id=#attributes.project_id#">
	</cfif>	  
    <cfif len(attributes.project_head) and len(attributes.project_head)>
		<cfset adres="#adres#&project_head=#attributes.project_head#">
	</cfif>	   
	<cfif isdate(attributes.start_date)>
		<cfset adres = "#adres#&start_date=#dateformat(attributes.start_date,dateformat_style)#">
	</cfif>
	<cfif isdate(attributes.finish_date)>
		<cfset adres = "#adres#&finish_date=#dateformat(attributes.finish_date,dateformat_style)#">
	</cfif>
	<cfif len(attributes.is_inventory)>
		<cfset adres = "#adres#&is_inventory=#attributes.is_inventory#">
	</cfif>
	<cf_paging page="#attributes.page#" 
			maxrows="#attributes.maxrows#"
			totalrecords="#attributes.totalrecords#"
			startrow="#attributes.startrow#"
			adres="#adres#&is_form_submitted=1">	
</cfif>

<script type="text/javascript">
	function get_process_types(deger)
	{	
		if(deger==6)
		{
			uzunluk = document.getElementById('listing_type').length;
			document.getElementById('listing_type').value = '';
			for(var i=0;i<uzunluk;i++)
			{
				//if(i!=8||i!=11||i!=13)
				document.getElementById('listing_type').options[0]=null;
			}
			document.getElementById('listing_type').options[0]=new Option('<cf_get_lang dictionary_id="30009.Sarf">',7);
			document.getElementById('listing_type').options[1]=new Option('<cf_get_lang dictionary_id="39504.Satış Faturaları">',10);
			document.getElementById('listing_type').options[2]=new Option('<cf_get_lang dictionary_id="40038.Depolararası Sevk">',12);	
            document.getElementById('listing_type').options[3]=new Option('<cf_get_lang dictionary_id="29471.Fire">',17);
			<cfif len(attributes.listing_type)>
			sayac = 0;
				<cfoutput>
					<cfloop from="1" to="#listlen(attributes.listing_type)#" index="cc">
						<cfif listfind("7,10,12,17",#listgetat(attributes.listing_type,cc)#)>
							window.document.getElementById('listing_type').options[sayac].setAttribute("selected", "selected");
							sayac = sayac + 1;
						</cfif>
					</cfloop>
				</cfoutput>
			</cfif>
		}
		else
		{
			
			document.getElementById('listing_type').options[0]=new Option('<cf_get_lang dictionary_id="58123.Planlama">',1);
			document.getElementById('listing_type').options[1]=new Option('<cf_get_lang dictionary_id="39499.Alış Siparişleri">',2);
			document.getElementById('listing_type').options[2]=new Option('<cf_get_lang dictionary_id="58207.Satış Siparişleri">',3);	
			document.getElementById('listing_type').options[3]=new Option('<cf_get_lang dictionary_id="39500.Alış İrsaliyeleri">',4);
			document.getElementById('listing_type').options[4]=new Option('<cf_get_lang dictionary_id="39502.Satış İrsaliyeleri">',5);
			document.getElementById('listing_type').options[5]=new Option('<cf_get_lang dictionary_id="39495.İthalat">',6);	
			document.getElementById('listing_type').options[6]=new Option('<cf_get_lang dictionary_id="30009.Sarf">',7);
			document.getElementById('listing_type').options[7]=new Option('<cf_get_lang dictionary_id="39088.Üretim Fişleri">',8);
			document.getElementById('listing_type').options[8]=new Option('<cf_get_lang dictionary_id="39503.Alış Faturaları">',9);
			document.getElementById('listing_type').options[9]=new Option('<cf_get_lang dictionary_id="39504.Satış Faturaları">',10);
			document.getElementById('listing_type').options[10]=new Option('<cf_get_lang dictionary_id="39506.Hakediş">',11);	
			document.getElementById('listing_type').options[11]=new Option('<cf_get_lang dictionary_id="40038.Depolararası Sevk">',12);		
			document.getElementById('listing_type').options[12]=new Option('<cf_get_lang dictionary_id="40039.İç Talepler">',13);	
			document.getElementById('listing_type').options[13]=new Option('<cf_get_lang dictionary_id="40037.Üretim Emirleri">',14);
			document.getElementById('listing_type').options[14]=new Option('<cf_get_lang dictionary_id="33263.Satınalma Talepleri">',15);	
			document.getElementById('listing_type').options[15]=new Option('<cf_get_lang dictionary_id="47243.Üretim Talepleri">',16);
            document.getElementById('listing_type').options[17]=new Option('<cf_get_lang dictionary_id="29471.Fire">',17);		
			<cfif len(attributes.listing_type)>
				<cfoutput>
					<cfloop list="#attributes.listing_type#" index="cc">
						window.document.getElementById('listing_type').options[#cc-1#].setAttribute("selected", "selected");
					</cfloop>
				</cfoutput>
			</cfif>
		}
	}
	function control()	
        {
            
            var date1 = search_form.start_date;
            var date2 = search_form.finish_date;
            if(date1.value != '' && date2.value != ''){
                if(!date_check(date1,date2,"<cf_get_lang dictionary_id ='40310.Başlama Tarihi Bitiş Tarihinden Küçük Olmalıdır'>!")) return false;
            }
             
            if ((document.getElementById('project_id').value == "") || (document.getElementById('project_head').value == ""))
            {
                alert("<cf_get_lang dictionary_id ='40045.Proje Seçmelisiniz'>!");
                return false;
            }
        
            if(document.getElementById('listing_type').value == "")
            {
                alert("<cf_get_lang dictionary_id='58950.En az bir listeleme tipi için filtre etmelisiniz'>!");
                return false;
            }
            

            if(document.search_form.is_excel.checked==false)
            {
                document.search_form.action="<cfoutput>#request.self#?fuseaction=#attributes.fuseaction#</cfoutput>"
                return true;
            }
            else
                document.search_form.action="<cfoutput>#request.self#?fuseaction=#fusebox.circuit#.emptypopup_pro_material_result</cfoutput>"
    }
</script>
