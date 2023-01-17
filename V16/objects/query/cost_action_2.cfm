<cfsetting showdebugoutput="no">
<cfquery name="GET_COMPS_PER" datasource="#FORM.DSN#">
	SELECT 
		SP2.PERIOD_ID,
		SP2.PERIOD_YEAR,
		SP2.OUR_COMPANY_ID,
		SP.INVENTORY_CALC_TYPE
	FROM 
		SETUP_PERIOD SP,
		SETUP_PERIOD SP2
	WHERE 
		SP.PERIOD_ID = <cfqueryparam value="#form.session_period_id#" cfsqltype="cf_sql_integer"> AND
		SP.OUR_COMPANY_ID = SP2.OUR_COMPANY_ID
</cfquery>
<cfscript>
	if(GET_COMPS_PER.RECORDCOUNT)
	{
		comp_period_list=ValueList(GET_COMPS_PER.PERIOD_ID);
		comp_period_year_list=ValueList(GET_COMPS_PER.PERIOD_YEAR);
		our_comp_id=GET_COMPS_PER.OUR_COMPANY_ID;
	}
	if(not isdefined('comp_period_list') or not len(comp_period_list))//bu ihtimal yok ama yinede olsun
	{
		comp_period_list=form.session_period_id;
		comp_period_year_list=year(now());
		our_comp_id=form.session_company_id;
	}
	//belge idsi ve tipi paper_action degiskenlerine aktardık genel degerler olarak kullanalım iç içe çağırıldığında karışmasın
	paper_product_id=form.aktarim_product_id;
	paper_action_id=form.action_id;
	paper_action_type=form.action_type;//ne için maliyet oluşturulduğunu tutoyor.4 ise üretim mesela...
	paper_action_period_id=form.session_period_id;
	paper_action_row_id = form.action_row_id;
	paper_query_type=form.query_type;//buda silinecekmi eklenecekmi yenidenmi oluşturulacak onu tutuyor.
</cfscript>
<cfif len(our_comp_id)>
	<cfquery name="GET_COST_CALC_TYPE" datasource="#dsn#">
		SELECT COST_CALC_TYPE FROM OUR_COMPANY_INFO WHERE COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#our_comp_id#">
	</cfquery>
	<cfif GET_COST_CALC_TYPE.RECORDCOUNT and len(GET_COST_CALC_TYPE.COST_CALC_TYPE)>
		<cfset comp_cost_calc_type=GET_COST_CALC_TYPE.COST_CALC_TYPE>
	<cfelse>
		<cfset comp_cost_calc_type =1>
	</cfif>
<cfelse>
	<cfset comp_cost_calc_type =1>
</cfif>
<!--- //calistirilan sirkete ait periodlar aliniyor --->
<!--- maliyet oluşmayacak lokasyonalar alınıyor --->
<cfquery name="GET_NOT_DEP_COST" datasource="#DSN#">
	SELECT DEPARTMENT_ID,LOCATION_ID FROM STOCKS_LOCATION STOCKS_LOCATION WHERE ISNULL(IS_COST_ACTION,0)=1
</cfquery>

<cfif paper_query_type eq 1>
<!--- ekleme tipinde cagrilmis fonksiyon ama daha once maliyet eklemisse ise guncelleme olarak calisir --->
	<cfquery datasource="#FORM.DSN1#" name="GET_COST_INS">
		SELECT 
			PRODUCT_COST_ID,
			START_DATE,
			SPECT_MAIN_ID,
			PRODUCT_ID
		FROM 
			PRODUCT_COST
		WHERE
			ACTION_ID = <cfqueryparam value="#paper_action_id#" cfsqltype="cf_sql_integer"> AND
			ACTION_TYPE = <cfqueryparam value="#paper_action_type#" cfsqltype="cf_sql_integer"> AND
			ACTION_PERIOD_ID = <cfqueryparam value="#paper_action_period_id#" cfsqltype="cf_sql_integer">
	</cfquery>
	<cfif GET_COST_INS.RECORDCOUNT>
		<cfset form.query_type=2>
		<cfset paper_query_type=2>
	</cfif>
</cfif>
<!--- //onhazırlıklar degiskenler listeler v.s. hazırlandı --->
<!--- functions maliyet işlemi esnasında kullandığımız fonksiyonlar--->
<cfinclude template="../../../fbx_workcube_funcs.cfm">
<!--- işlerler başlıyor --->
<cfif paper_query_type neq 3>
<!--- ekleme yada güncelleme islemleri ise bu blok calisacak --->
	<cfif paper_action_type eq 1><!--- belge tipi fatura --->
		<cfquery name="GET_INV_SHIP" datasource="#form.period_dsn_type#"><!--- faturadan irsaliye olusmussa fatura satırındaki ship_id bos oluyor bunun icin is_with_ship alanina bkarak faturadanmı oluşmuş yoksa ayrımı onu anlıyoruz bu ilişki düzeldiğinde bu kodda düzenlensin --->
			SELECT IS_WITH_SHIP FROM INVOICE_SHIPS WHERE INVOICE_SHIPS.INVOICE_ID = <cfqueryparam value="#paper_action_id#" cfsqltype="cf_sql_integer">
		</cfquery>
		<cfif GET_INV_SHIP.RECORDCOUNT>
			<!--- faturadan maliyet olusurken stok tarihleri yüzünden sorun oluyor bu yuzden irs id ve irsaliyedeki filli sevk tarihi aliniyor --->
			<cfif GET_INV_SHIP.IS_WITH_SHIP eq 0>
				<cfif len(paper_product_id)>
                	<cfstoredproc procedure="GET_ACTION_PRODUCT" datasource="#form.period_dsn_type#">
                    	<cfprocparam cfsqltype="cf_sql_integer" value="1">
                        <cfprocparam cfsqltype="cf_sql_bit" value="0">
                        <cfprocparam cfsqltype="cf_sql_integer" value="#paper_product_id#">
                        <cfprocparam cfsqltype="cf_sql_integer" value="#paper_action_id#">
                        <cfprocparam cfsqltype="cf_sql_integer" value="1">
                        <cfprocparam cfsqltype="cf_sql_varchar" value="#form.cost_money_system_2#">	
                        <cfprocresult name="GET_ACTION">
                    </cfstoredproc>
                <cfelse>
                	<cfstoredproc procedure="GET_ACTION" datasource="#form.period_dsn_type#">
                    	<cfprocparam cfsqltype="cf_sql_integer" value="1">
                        <cfprocparam cfsqltype="cf_sql_bit" value="0">
                        <cfprocparam cfsqltype="cf_sql_integer" value="null" null="yes">
                        <cfprocparam cfsqltype="cf_sql_integer" value="#paper_action_id#">
                        <cfprocparam cfsqltype="cf_sql_integer" value="1">
                        <cfprocparam cfsqltype="cf_sql_varchar" value="#form.cost_money_system_2#">	
                        <cfprocresult name="GET_ACTION">
                    </cfstoredproc>
                </cfif>
				<!---<cfquery name="GET_ACTION" datasource="#form.period_dsn_type#">
					SELECT
						SHIP.SHIP_ID,
						INVOICE_ROW.INVOICE_ROW_ID ACTION_ROW_ID,
						INVOICE.RECORD_DATE INSERT_DATE,
						INVOICE.INVOICE_DATE PAPER_DATE,
						ISNULL(SHIP.DELIVER_DATE,SHIP.SHIP_DATE) ACTION_DATE,
						INVOICE_ROW.AMOUNT AMOUNT,
						INVOICE_ROW.SPECT_VAR_ID SPEC_ID,
						STOCKS.STOCK_ID,
						STOCKS.PRODUCT_ID,
						PRODUCT.INVENTORY_CALC_TYPE,
						INVOICE.PROCESS_CAT,
						INVOICE.DEPARTMENT_ID ACTION_DEPARTMENT_ID,
						INVOICE.DEPARTMENT_LOCATION ACTION_LOCATION_ID,
						INVOICE_ROW.DUE_DATE,
						INVOICE.INVOICE_DATE
					FROM
						SHIP,
						INVOICE,
						INVOICE_ROW,
						#FORM.DSN1_alias#.STOCKS STOCKS,
						#FORM.DSN1_alias#.PRODUCT PRODUCT
					WHERE
						INVOICE.INVOICE_ID = <cfqueryparam value="#paper_action_id#" cfsqltype="cf_sql_integer"> AND
						INVOICE.INVOICE_ID=INVOICE_ROW.INVOICE_ID AND
						INVOICE_ROW.SHIP_ID=SHIP.SHIP_ID AND
						STOCKS.STOCK_ID=INVOICE_ROW.STOCK_ID AND
						STOCKS.PRODUCT_ID=PRODUCT.PRODUCT_ID AND
						PRODUCT.IS_COST=1
						<cfif len(paper_product_id)>
							AND PRODUCT.PRODUCT_ID = #paper_product_id#
						</cfif>
					ORDER BY
						ISNULL(SHIP.DELIVER_DATE,SHIP.SHIP_DATE),
						STOCKS.PRODUCT_ID,
						INVOICE_ROW.INVOICE_ROW_ID
				</cfquery>--->
			<cfelse>
				<!---<cfquery name="GET_ACTION" datasource="#form.period_dsn_type#">
					SELECT
						SHIP.SHIP_ID,
						INVOICE_ROW.INVOICE_ROW_ID ACTION_ROW_ID,
						INVOICE.RECORD_DATE INSERT_DATE,
						INVOICE.INVOICE_DATE PAPER_DATE,
						ISNULL(SHIP.DELIVER_DATE,SHIP.SHIP_DATE) ACTION_DATE,
						INVOICE_ROW.AMOUNT AMOUNT,
						INVOICE_ROW.SPECT_VAR_ID SPEC_ID,
						STOCKS.STOCK_ID,
						STOCKS.PRODUCT_ID,
						PRODUCT.INVENTORY_CALC_TYPE,
						INVOICE.PROCESS_CAT,
						INVOICE.DEPARTMENT_ID ACTION_DEPARTMENT_ID,
						INVOICE.DEPARTMENT_LOCATION ACTION_LOCATION_ID,
						INVOICE_ROW.DUE_DATE,
						INVOICE.INVOICE_DATE
					FROM
						SHIP,
						INVOICE,
						INVOICE_ROW,
						INVOICE_SHIPS,
						#FORM.DSN1_alias#.STOCKS STOCKS,
						#FORM.DSN1_alias#.PRODUCT PRODUCT
					WHERE
						INVOICE.INVOICE_ID = <cfqueryparam value="#paper_action_id#" cfsqltype="cf_sql_integer"> AND
						INVOICE.INVOICE_ID=INVOICE_ROW.INVOICE_ID AND
						INVOICE_SHIPS.SHIP_ID=SHIP.SHIP_ID AND
						INVOICE_SHIPS.INVOICE_ID=INVOICE.INVOICE_ID AND
						STOCKS.STOCK_ID=INVOICE_ROW.STOCK_ID AND
						STOCKS.PRODUCT_ID=PRODUCT.PRODUCT_ID AND
						PRODUCT.IS_COST=1
						<cfif len(paper_product_id)>
							AND PRODUCT.PRODUCT_ID = #paper_product_id#
						</cfif>
					ORDER BY
						ISNULL(SHIP.DELIVER_DATE,SHIP.SHIP_DATE),
						STOCKS.PRODUCT_ID,
						INVOICE_ROW.INVOICE_ROW_ID
				</cfquery>--->
                <cfif len(paper_product_id)>
                	<cfstoredproc procedure="GET_ACTION_PRODUCT" datasource="#form.period_dsn_type#">
                    	<cfprocparam cfsqltype="cf_sql_integer" value="1">
                        <cfprocparam cfsqltype="cf_sql_bit" value="1">
                        <cfprocparam cfsqltype="cf_sql_integer" value="#paper_product_id#">
                        <cfprocparam cfsqltype="cf_sql_integer" value="#paper_action_id#">
                        <cfprocparam cfsqltype="cf_sql_integer" value="1">
                        <cfprocparam cfsqltype="cf_sql_varchar" value="#form.cost_money_system_2#">	
                        <cfprocresult name="GET_ACTION">
                    </cfstoredproc>
                <cfelse>
                	<cfstoredproc procedure="GET_ACTION" datasource="#form.period_dsn_type#">
                    	<cfprocparam cfsqltype="cf_sql_integer" value="1">
                        <cfprocparam cfsqltype="cf_sql_bit" value="1">
                        <cfprocparam cfsqltype="cf_sql_integer" value="null" null="yes">
                        <cfprocparam cfsqltype="cf_sql_integer" value="#paper_action_id#">
                        <cfprocparam cfsqltype="cf_sql_integer" value="1">
                        <cfprocparam cfsqltype="cf_sql_varchar" value="#form.cost_money_system_2#">	
                        <cfprocresult name="GET_ACTION">
                    </cfstoredproc>
                </cfif>
			</cfif>
		</cfif>
		<cfif not GET_INV_SHIP.RECORDCOUNT><!--- irsaliyesi olmayan bir fatura ise fiyat farkı olabilir bu fatura ozaman hangi faturaya karşılık kesildi ise ana fatura maliyeti fiyat farkındaki tutari düşülerek güncelleniyor--->
            <!---<cfquery name="GET_ACTION" datasource="#form.period_dsn_type#">
				SELECT DISTINCT
					1 INV_CONT_COMP,
					SHIP.SHIP_ID,
					INVOICE.INVOICE_ID,
					INVOICE_ROW.INVOICE_ROW_ID ACTION_ROW_ID,
					INVOICE.RECORD_DATE INSERT_DATE,
					INVOICE.INVOICE_DATE PAPER_DATE,
					ISNULL(SHIP.DELIVER_DATE,SHIP.SHIP_DATE) ACTION_DATE,
					INVOICE_ROW.AMOUNT AMOUNT,
					INVOICE_ROW.SPECT_VAR_ID SPEC_ID,
					STOCKS.STOCK_ID,
					STOCKS.PRODUCT_ID,
					PRODUCT.INVENTORY_CALC_TYPE,
					INVOICE.PROCESS_CAT,
					INVOICE.DEPARTMENT_ID ACTION_DEPARTMENT_ID,
					INVOICE.DEPARTMENT_LOCATION ACTION_LOCATION_ID,
					INVOICE_ROW.DUE_DATE,
					INVOICE.INVOICE_DATE
				FROM
					SHIP,
					INVOICE,
					INVOICE_ROW,
					INVOICE_SHIPS,
					INVOICE_CONTRACT_COMPARISON,
					#FORM.DSN1_alias#.STOCKS STOCKS,
					#FORM.DSN1_alias#.PRODUCT PRODUCT
				WHERE
					INVOICE_CONTRACT_COMPARISON.DIFF_INVOICE_ID = <cfqueryparam value="#paper_action_id#" cfsqltype="cf_sql_integer"> AND
					INVOICE.INVOICE_ID=INVOICE_CONTRACT_COMPARISON.MAIN_INVOICE_ID AND
					INVOICE.INVOICE_ID=INVOICE_ROW.INVOICE_ID AND
					INVOICE_SHIPS.SHIP_ID=SHIP.SHIP_ID AND
					INVOICE_SHIPS.INVOICE_ID=INVOICE.INVOICE_ID AND
					STOCKS.STOCK_ID=INVOICE_ROW.STOCK_ID AND
					STOCKS.PRODUCT_ID=PRODUCT.PRODUCT_ID AND
					PRODUCT.IS_COST=1
					<cfif len(paper_product_id)>
						AND PRODUCT.PRODUCT_ID = #paper_product_id#
					</cfif>
				ORDER BY
					ISNULL(SHIP.DELIVER_DATE,SHIP.SHIP_DATE),
                    STOCKS.PRODUCT_ID,
                    INVOICE_ROW.INVOICE_ROW_ID
			</cfquery>--->
            	<cfif len(paper_product_id)>
                	<cfstoredproc procedure="GET_ACTION_PRODUCT" datasource="#form.period_dsn_type#">
                    	<cfprocparam cfsqltype="cf_sql_integer" value="0">
                        <cfprocparam cfsqltype="cf_sql_bit" value="null" null="yes">
                        <cfprocparam cfsqltype="cf_sql_integer" value="#paper_product_id#">
                        <cfprocparam cfsqltype="cf_sql_integer" value="#paper_action_id#">
                        <cfprocparam cfsqltype="cf_sql_integer" value="1">
                        <cfprocparam cfsqltype="cf_sql_varchar" value="#form.cost_money_system_2#">	
                        <cfprocresult name="GET_ACTION">
                    </cfstoredproc>
                <cfelse>
                	<cfstoredproc procedure="GET_ACTION" datasource="#form.period_dsn_type#">
                    	<cfprocparam cfsqltype="cf_sql_integer" value="0">
                        <cfprocparam cfsqltype="cf_sql_bit" value="null" null="yes">
                        <cfprocparam cfsqltype="cf_sql_integer" value="null" null="yes" >
                        <cfprocparam cfsqltype="cf_sql_integer" value="#paper_action_id#">
                        <cfprocparam cfsqltype="cf_sql_integer" value="1">
                        <cfprocparam cfsqltype="cf_sql_varchar" value="#form.cost_money_system_2#">	
                        <cfprocresult name="GET_ACTION">
                    </cfstoredproc>
                </cfif>
			<cfif GET_ACTION.RECORDCOUNT>
				<!--- fiyat farkı ise fonksiyona gelen belge id vs ana faturanın ki ile değiştiriliyor. --->
				<cfset form.action_id = GET_ACTION.INVOICE_ID>
				<cfset paper_action_id = GET_ACTION.INVOICE_ID>
				<cfset form.query_type = 2>
				<cfset paper_query_type =2>
			</cfif>
		</cfif>
	<cfelseif paper_action_type eq 2><!--- belge tipi irsaliye --->
		<!---<cfquery name="GET_ACTION" datasource="#form.period_dsn_type#">
			SELECT
				SHIP.SHIP_ID,
				SHIP_ROW.SHIP_ROW_ID ACTION_ROW_ID,
				SHIP.RECORD_DATE INSERT_DATE,
				SHIP.SHIP_DATE PAPER_DATE,
				SHIP.DELIVER_DATE ACTION_DATE,
				SHIP_ROW.AMOUNT AMOUNT,
				SHIP_ROW.SPECT_VAR_ID SPEC_ID,
				STOCKS.STOCK_ID,
				STOCKS.PRODUCT_ID,
				PRODUCT.INVENTORY_CALC_TYPE,
				SHIP.PROCESS_CAT,
				ISNULL(SHIP.DEPARTMENT_IN,SHIP.DELIVER_STORE_ID) ACTION_DEPARTMENT_ID,
				ISNULL(SHIP.LOCATION_IN,SHIP.LOCATION) ACTION_LOCATION_ID
			FROM 
				SHIP,
				SHIP_ROW,
				#FORM.DSN1_alias#.STOCKS STOCKS,
				#FORM.DSN1_alias#.PRODUCT PRODUCT
			WHERE
				SHIP.SHIP_ID = <cfqueryparam value="#paper_action_id#" cfsqltype="cf_sql_integer"> AND
				SHIP.SHIP_ID = SHIP_ROW.SHIP_ID AND
				STOCKS.STOCK_ID = SHIP_ROW.STOCK_ID AND
				STOCKS.PRODUCT_ID = PRODUCT.PRODUCT_ID AND
				PRODUCT.IS_COST = 1
				<cfif len(paper_product_id)>
					AND PRODUCT.PRODUCT_ID = #paper_product_id#
				</cfif>
			ORDER BY
            	STOCKS.PRODUCT_ID,SHIP_ROW.SHIP_ROW_ID
		</cfquery>--->
				<cfif len(paper_product_id)>
                    <cfstoredproc procedure="GET_ACTION_PRODUCT" datasource="#form.period_dsn_type#">
                        <cfprocparam cfsqltype="cf_sql_integer" value="0">
                        <cfprocparam cfsqltype="cf_sql_bit" value="0">
                        <cfprocparam cfsqltype="cf_sql_integer" value="#paper_product_id#">
                        <cfprocparam cfsqltype="cf_sql_integer" value="#paper_action_id#">
                        <cfprocparam cfsqltype="cf_sql_integer" value="2">
                        <cfprocparam cfsqltype="cf_sql_varchar" value="#form.cost_money_system_2#">	
                        <cfprocresult name="GET_ACTION">
                    </cfstoredproc>
                <cfelse>
                    <cfstoredproc procedure="GET_ACTION" datasource="#form.period_dsn_type#">
                        <cfprocparam cfsqltype="cf_sql_integer" value="0">
                        <cfprocparam cfsqltype="cf_sql_bit" value="0">
                        <cfprocparam cfsqltype="cf_sql_integer" value="0">
                        <cfprocparam cfsqltype="cf_sql_integer" value="#paper_action_id#">
                        <cfprocparam cfsqltype="cf_sql_integer" value="2">
                        <cfprocparam cfsqltype="cf_sql_varchar" value="#form.cost_money_system_2#">	
                        <cfprocresult name="GET_ACTION">
                    </cfstoredproc>
                </cfif>
       <!--- <br/>GET_ACTION: <CFdump var="#GET_ACTION#"> --->
	<cfelseif paper_action_type eq 3><!--- belge tipi fis --->
		<!---<cfquery name="GET_ACTION" datasource="#form.period_dsn_type#">
			SELECT
				STOCK_FIS_ROW.STOCK_FIS_ROW_ID ACTION_ROW_ID,
				STOCK_FIS.RECORD_DATE INSERT_DATE,
				STOCK_FIS.FIS_DATE PAPER_DATE,
				STOCK_FIS.FIS_DATE ACTION_DATE,
				STOCK_FIS_ROW.AMOUNT AMOUNT,
				STOCK_FIS_ROW.SPECT_VAR_ID SPEC_ID,
				STOCKS.STOCK_ID,
				STOCKS.PRODUCT_ID,
				PRODUCT.INVENTORY_CALC_TYPE,
				STOCK_FIS.PROCESS_CAT,
				STOCK_FIS.DEPARTMENT_IN ACTION_DEPARTMENT_ID,
				STOCK_FIS.LOCATION_IN ACTION_LOCATION_ID,
				ISNULL(STOCK_FIS_ROW.DUE_DATE,0) DUE_DATE,<!--- stok yaşı gün olarak gelir bu alandan --->
				STOCK_FIS_ROW.RESERVE_DATE<!--- REZERVE tarihi tarih olarak gelir bu alandan vade için kullanılacak umarım birgün alanlar acılır ve doğru alanlardan alınır--->
			FROM 
				STOCK_FIS,
				STOCK_FIS_ROW,
				#FORM.DSN1_alias#.STOCKS STOCKS,
				#FORM.DSN1_alias#.PRODUCT PRODUCT
			WHERE
				STOCK_FIS.FIS_ID = <cfqueryparam value="#paper_action_id#" cfsqltype="cf_sql_integer"> AND
				STOCK_FIS.FIS_ID = STOCK_FIS_ROW.FIS_ID AND
				STOCKS.STOCK_ID = STOCK_FIS_ROW.STOCK_ID AND
				STOCKS.PRODUCT_ID = PRODUCT.PRODUCT_ID AND
				PRODUCT.IS_COST=1 
				--AND STOCK_FIS.PROD_ORDER_NUMBER IS NULL
				<cfif len(paper_product_id)>
					AND PRODUCT.PRODUCT_ID = #paper_product_id#
				</cfif>
			ORDER BY
            	STOCKS.PRODUCT_ID,STOCK_FIS_ROW.STOCK_FIS_ROW_ID
		</cfquery>--->
        <cfif len(paper_product_id)>
            <cfstoredproc procedure="GET_ACTION_PRODUCT" datasource="#form.period_dsn_type#">
                <cfprocparam cfsqltype="cf_sql_integer" value="null" null="yes" >
                <cfprocparam cfsqltype="cf_sql_bit" value="null" null="yes">
                <cfprocparam cfsqltype="cf_sql_integer" value="#paper_product_id#">
                <cfprocparam cfsqltype="cf_sql_integer" value="#paper_action_id#">
                <cfprocparam cfsqltype="cf_sql_integer" value="3">
                <cfprocparam cfsqltype="cf_sql_varchar" value="#form.cost_money_system_2#">	
                <cfprocresult name="GET_ACTION">
            </cfstoredproc>
        <cfelse>
            <cfstoredproc procedure="GET_ACTION" datasource="#form.period_dsn_type#">
                <cfprocparam cfsqltype="cf_sql_integer" value="null" null="yes" >
                <cfprocparam cfsqltype="cf_sql_bit" value="null" null="yes" >
                <cfprocparam cfsqltype="cf_sql_integer"  value="null" null="yes">
                <cfprocparam cfsqltype="cf_sql_integer" value="#paper_action_id#">
                <cfprocparam cfsqltype="cf_sql_integer" value="3">
                <cfprocparam cfsqltype="cf_sql_varchar" value="#form.cost_money_system_2#">	
                <cfprocresult name="GET_ACTION">
            </cfstoredproc>
        </cfif>
	<cfelseif paper_action_type eq 4><!--- belge tipi uretimse --->
       <cfquery name="GET_ACTION" datasource="#FORM.DSN3#">
        	--Verilen Belge Numarasına Göre Üretim Sonucundaki Verilere Ulaşıyoruz.
			SELECT
				PORR.PR_ORDER_ROW_ID ACTION_ROW_ID,
				ISNULL(POR.UPDATE_DATE,POR.RECORD_DATE) INSERT_DATE,
				POR.FINISH_DATE PAPER_DATE,
				POR.FINISH_DATE ACTION_DATE,
				PORR.AMOUNT,
				PORR.SPECT_ID SPEC_ID,
				PORR.SPEC_MAIN_ID EXCHANGE_SPECT_MAIN_ID,
				(PORR.PURCHASE_NET_SYSTEM++ISNULL(PORR.PURCHASE_EXTRA_COST_SYSTEM,0)) PURCHASE_NET_SYSTEM,
				PORR.PURCHASE_NET_SYSTEM_MONEY,
                (ISNULL(PORR.LABOR_COST_SYSTEM,0)+ISNULL(PORR.STATION_REFLECTION_COST_SYSTEM,0)) AS PURCHASE_EXTRA_COST_SYSTEM,
				<!--- PORR.PURCHASE_EXTRA_COST_SYSTEM, --->
				STOCKS.STOCK_ID,
				STOCKS.PRODUCT_ID,
				POR.PROCESS_ID PROCESS_CAT,
				POR.PRODUCTION_DEP_ID ACTION_DEPARTMENT_ID,
				POR.PRODUCTION_LOC_ID ACTION_LOCATION_ID,
				ISNULL(PORR.LABOR_COST_SYSTEM,0) as LABOR_COST_SYSTEM,
				ISNULL(PORR.STATION_REFLECTION_COST_SYSTEM,0) as STATION_REFLECTION_COST_SYSTEM
				<!--- uretim sevkdede malyiet olusmalıysa sevk depoyuda alacaz --->
			FROM 
				PRODUCTION_ORDERS PO,
				PRODUCTION_ORDER_RESULTS POR,
				PRODUCTION_ORDER_RESULTS_ROW PORR,
				#FORM.DSN1_alias#.STOCKS STOCKS,
				#FORM.DSN1_alias#.PRODUCT PRODUCT
			WHERE
				POR.PR_ORDER_ID = <cfqueryparam value="#paper_action_id#" cfsqltype="cf_sql_integer"> AND
				PO.P_ORDER_ID = POR.P_ORDER_ID AND
				POR.PR_ORDER_ID = PORR.PR_ORDER_ID AND
				STOCKS.STOCK_ID = PORR.STOCK_ID AND
				STOCKS.PRODUCT_ID = PRODUCT.PRODUCT_ID AND
				PRODUCT.IS_COST = 1 AND
				PORR.TYPE = 1 AND
				ISNULL(PORR.IS_FREE_AMOUNT,0) <> 1 AND
				PO.IS_DEMONTAJ <> 1
				<cfif len(paper_product_id)>
					AND PRODUCT.PRODUCT_ID = #paper_product_id#
				</cfif>
            ORDER BY
                STOCKS.PRODUCT_ID,PORR.PR_ORDER_ROW_ID
		</cfquery>
	<cfelseif listfind('5,7',paper_action_type,',')><!--- belge tipi stok virman --->
		<cfif len(paper_product_id)>
			<cfstoredproc procedure="GET_ACTION_PRODUCT" datasource="#form.period_dsn_type#">
				<cfprocparam cfsqltype="cf_sql_integer" value="null" null="yes" >
				<cfprocparam cfsqltype="cf_sql_bit" value="null" null="yes">
				<cfprocparam cfsqltype="cf_sql_integer" value="#paper_product_id#">
				<cfprocparam cfsqltype="cf_sql_integer" value="#paper_action_id#">
				<cfprocparam cfsqltype="cf_sql_integer" value="5">
				<cfprocparam cfsqltype="cf_sql_varchar" value="#form.cost_money_system_2#">	
				<cfprocresult name="GET_ACTION">
			</cfstoredproc>
		<cfelse>
			<cfstoredproc procedure="GET_ACTION" datasource="#form.period_dsn_type#">
				<cfprocparam cfsqltype="cf_sql_integer" value="null" null="yes" >
				<cfprocparam cfsqltype="cf_sql_bit" value="null" null="yes">
				<cfprocparam cfsqltype="cf_sql_integer" value="null" null="yes">
				<cfprocparam cfsqltype="cf_sql_integer" value="#paper_action_id#">
				<cfprocparam cfsqltype="cf_sql_integer" value="5">
				<cfprocparam cfsqltype="cf_sql_varchar" value="#form.cost_money_system_2#">	
				<cfprocresult name="GET_ACTION">
			</cfstoredproc>
		</cfif>	
		<!---<cfquery name="GET_ACTION" datasource="#form.period_dsn_type#">
			SELECT
				STOCK_EXCHANGE.EXCHANGE_NUMBER ACTION_NUMBER,
				STOCK_EXCHANGE.STOCK_EXCHANGE_ID ACTION_ROW_ID,
				STOCK_EXCHANGE.PROCESS_DATE INSERT_DATE,
				STOCK_EXCHANGE.PROCESS_DATE PAPER_DATE,
				STOCK_EXCHANGE.PROCESS_DATE ACTION_DATE,
				STOCK_EXCHANGE.AMOUNT,
				STOCK_EXCHANGE.SPECT_ID SPEC_ID,
				STOCK_EXCHANGE.SPECT_MAIN_ID EXCHANGE_SPECT_MAIN_ID,
				STOCK_EXCHANGE.STOCK_ID,
				STOCK_EXCHANGE.PRODUCT_ID,
				PRODUCT.INVENTORY_CALC_TYPE,
                PRODUCT.PRODUCT_ID,
				STOCK_EXCHANGE.PROCESS_CAT PROCESS_CAT,
				STOCK_EXCHANGE.DEPARTMENT_ID ACTION_DEPARTMENT_ID,
				STOCK_EXCHANGE.LOCATION_ID ACTION_LOCATION_ID
			FROM
				STOCK_EXCHANGE,
				#FORM.DSN1_alias#.PRODUCT PRODUCT
			WHERE
				PRODUCT.PRODUCT_ID=STOCK_EXCHANGE.PRODUCT_ID AND
				<cfif paper_action_type eq 5>
					STOCK_EXCHANGE.STOCK_EXCHANGE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#paper_action_id#">
				<cfelse>
					STOCK_EXCHANGE.EXCHANGE_NUMBER = <cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_ACTION_PAPER_NO.EXCHANGE_NUMBER#">
				</cfif>
				<cfif len(paper_product_id)>
					AND PRODUCT.PRODUCT_ID = #paper_product_id#
				</cfif>
			ORDER BY
            	PRODUCT.PRODUCT_ID,STOCK_EXCHANGE.STOCK_EXCHANGE_ID
		</cfquery>--->
	<cfelseif paper_action_type eq 6><!--- belge tipi masraf fişi --->
		<!---<cfquery name="GET_ACTION" datasource="#form.period_dsn_type#">
			SELECT
				EXPENSE_ITEMS_ROWS.EXP_ITEM_ROWS_ID ACTION_ROW_ID,
				EXPENSE_ITEM_PLANS.RECORD_DATE INSERT_DATE,
				EXPENSE_ITEM_PLANS.EXPENSE_DATE PAPER_DATE,
				EXPENSE_ITEM_PLANS.EXPENSE_DATE ACTION_DATE,
				EXPENSE_ITEMS_ROWS.QUANTITY AMOUNT,
				NULL SPEC_ID,
				NULL EXCHANGE_SPECT_MAIN_ID,
				EXPENSE_ITEMS_ROWS.STOCK_ID,
				EXPENSE_ITEMS_ROWS.PRODUCT_ID,
				PRODUCT.INVENTORY_CALC_TYPE,
				EXPENSE_ITEM_PLANS.PROCESS_CAT PROCESS_CAT,
				EXPENSE_ITEM_PLANS.DEPARTMENT_ID ACTION_DEPARTMENT_ID,
				EXPENSE_ITEM_PLANS.LOCATION_ID ACTION_LOCATION_ID
			FROM
				EXPENSE_ITEM_PLANS,
				EXPENSE_ITEMS_ROWS,
				#FORM.DSN1_alias#.PRODUCT PRODUCT
			WHERE
				EXPENSE_ITEM_PLANS.EXPENSE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#paper_action_id#"> AND
				EXPENSE_ITEM_PLANS.EXPENSE_ID = EXPENSE_ITEMS_ROWS.EXPENSE_ID AND
				PRODUCT.PRODUCT_ID = EXPENSE_ITEMS_ROWS.PRODUCT_ID
				<cfif len(paper_product_id)>
					AND PRODUCT.PRODUCT_ID = #paper_product_id#
				</cfif>
            ORDER BY
            	PRODUCT.PRODUCT_ID,EXPENSE_ITEMS_ROWS.EXP_ITEM_ROWS_ID
		</cfquery>--->
       	   <cfif len(paper_product_id)>
                <cfstoredproc procedure="GET_ACTION_PRODUCT" datasource="#form.period_dsn_type#">
                    <cfprocparam cfsqltype="cf_sql_integer" value="null" null="yes" >
                    <cfprocparam cfsqltype="cf_sql_bit" value="null" null="yes">
                    <cfprocparam cfsqltype="cf_sql_integer" value="#paper_product_id#">
                    <cfprocparam cfsqltype="cf_sql_integer" value="#paper_action_id#">
                    <cfprocparam cfsqltype="cf_sql_integer" value="6">
                    <cfprocparam cfsqltype="cf_sql_varchar" value="#form.cost_money_system_2#">	
                    <cfprocresult name="GET_ACTION">
                </cfstoredproc>
            <cfelse>
                <cfstoredproc procedure="GET_ACTION" datasource="#form.period_dsn_type#">
                    <cfprocparam cfsqltype="cf_sql_integer" value="null" null="yes">
                    <cfprocparam cfsqltype="cf_sql_bit" value="null" null="yes">
                    <cfprocparam cfsqltype="cf_sql_integer" value="null" null="yes">
                    <cfprocparam cfsqltype="cf_sql_integer" value="#paper_action_id#">
                    <cfprocparam cfsqltype="cf_sql_integer" value="6">
                    <cfprocparam cfsqltype="cf_sql_varchar" value="#form.cost_money_system_2#">	
                    <cfprocresult name="GET_ACTION">
                </cfstoredproc>
            </cfif>
	<cfelseif paper_action_type eq 8><!--- belge tipi fiyat farkı ekranından --->
		<cfquery name="GET_ACTION" datasource="#form.period_dsn_type#">
			SELECT		
				PRODUCT_COST_INVOICE.PRODUCT_COST_INVOICE_ID ACTION_ROW_ID,
				PRODUCT_COST_INVOICE.RECORD_DATE INSERT_DATE,
				PRODUCT_COST_INVOICE.COST_DATE PAPER_DATE,
				PRODUCT_COST_INVOICE.COST_DATE ACTION_DATE,
				PRODUCT_COST_INVOICE.AMOUNT,
				NULL SPEC_ID,
				PRODUCT_COST_INVOICE.SPECT_MAIN_ID EXCHANGE_SPECT_MAIN_ID,
				PRODUCT_COST_INVOICE.PRODUCT_ID,
				PRODUCT_COST_INVOICE.STOCK_ID,
				INVOICE.PROCESS_CAT,
				ISNULL(PRODUCT_COST_INVOICE.DEPARTMENT_ID,INVOICE.DEPARTMENT_ID)  ACTION_DEPARTMENT_ID,
				INVOICE.DEPARTMENT_LOCATION ACTION_LOCATION_ID,
				INVOICE.INVOICE_ID,
				PRODUCT.PRODUCT_ID,
				PRODUCT_COST_INVOICE.COST_TYPE_ID,
				PRODUCT_COST_INVOICE.PRICE_PROTECTION_TYPE,
				PRODUCT_COST_INVOICE.PRICE_PROTECTION,
				PRODUCT_COST_INVOICE.PRICE_PROTECTION_MONEY,
				PRODUCT_COST_INVOICE.TOTAL_PRICE_PROTECTION,
				ISNULL((
					SELECT TOP 1 MONEY FROM #FORM.dsn3_alias#.PRODUCT_COST 
					WHERE
						PRODUCT_ID = PRODUCT_COST_INVOICE.PRODUCT_ID AND
						START_DATE <= PRODUCT_COST_INVOICE.COST_DATE
						AND	ISNULL(SPECT_MAIN_ID,0) = ISNULL(PRODUCT_COST_INVOICE.SPECT_MAIN_ID,0)
					ORDER BY
						START_DATE DESC,
						RECORD_DATE DESC,
						PRODUCT_COST_ID DESC
				),'#form.cost_money_system_2#') MONEY
			FROM
				PRODUCT_COST_INVOICE,
				INVOICE,
				#FORM.DSN1_alias#.PRODUCT PRODUCT
			WHERE
				PRODUCT_COST_INVOICE.INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#paper_action_id#"> AND
				PRODUCT_COST_INVOICE.INVOICE_ID = INVOICE.INVOICE_ID AND
				PRODUCT.PRODUCT_ID = PRODUCT_COST_INVOICE.PRODUCT_ID
				<cfif len(paper_product_id)>
					AND PRODUCT.PRODUCT_ID = #paper_product_id#
				</cfif>
				<cfif len(paper_action_row_id) and paper_action_row_id neq 0>
					AND PRODUCT_COST_INVOICE_ID = #paper_action_row_id#
				</cfif>
			ORDER BY
            	PRODUCT_COST_INVOICE.COST_DATE,
            	PRODUCT.PRODUCT_ID,PRODUCT_COST_INVOICE.PRODUCT_COST_INVOICE_ID<!--- burada hata olursa kaldırılabilir! --->
		</cfquery>
       	 <!--- <cfif len(paper_product_id)>
                <cfstoredproc procedure="GET_ACTION_PRODUCT" datasource="#form.period_dsn_type#">
                    <cfprocparam cfsqltype="cf_sql_integer" value="null" null="yes" >
                    <cfprocparam cfsqltype="cf_sql_bit" value="null" null="yes">
                    <cfprocparam cfsqltype="cf_sql_integer" value="#paper_product_id#">
                    <cfprocparam cfsqltype="cf_sql_integer" value="#paper_action_id#">
                    <cfprocparam cfsqltype="cf_sql_integer" value="8">
                    <cfprocparam cfsqltype="cf_sql_varchar" value="#form.cost_money_system_2#">	
                    <cfprocresult name="GET_ACTION">
                </cfstoredproc>
            <cfelse>
                <cfstoredproc procedure="GET_ACTION" datasource="#form.period_dsn_type#">
                    <cfprocparam cfsqltype="cf_sql_integer" value="null" null="yes" >
                    <cfprocparam cfsqltype="cf_sql_bit" value="null" null="yes">
                    <cfprocparam cfsqltype="cf_sql_integer" value="null" null="yes">
                    <cfprocparam cfsqltype="cf_sql_integer" value="#paper_action_id#">
                    <cfprocparam cfsqltype="cf_sql_integer" value="8">
                    <cfprocparam cfsqltype="cf_sql_varchar" value="#form.cost_money_system_2#">	
                    <cfprocresult name="GET_ACTION">
                </cfstoredproc>
            </cfif>--->
	</cfif>
	<cfif NOT GET_ACTION.RECORDCOUNT><!---belde id göre kayıt yoksa fonksiyondan cikar --->
		<cfexit method="exittemplate">
	</cfif>
	<cfif paper_action_type eq 1>
		<!--- faturadan maliyet kaydolcak ise irsaliyesi maliyet kaydetmişmi kontrol edilir varsa maliyet silinir --->
		<cfset ship_id_list=valuelist(GET_ACTION.SHIP_ID,',')>
		<cfif listlen(ship_id_list,',')>
			<cfquery name="GET_NEWER_INV_SHIP_COST" datasource="#FORM.DSN1#">
				SELECT 
					PRODUCT_COST_ID,
					START_DATE,
					SPECT_MAIN_ID,
					PRODUCT_ID,
					RECORD_DATE,
					ACTION_ID,
					ACTION_TYPE,
					ISNULL(ACTION_ROW_ID,0) ACTION_ROW_ID,
					PRICE_PROTECTION,
					PRICE_PROTECTION_MONEY,
					STANDARD_COST,
					STANDARD_COST_MONEY,
					STANDARD_COST_RATE,
					MONEY
				FROM
					PRODUCT_COST 
				WHERE
					ACTION_ID IN (#ship_id_list#) AND
					ACTION_TYPE = 2 AND
					ACTION_PERIOD_ID = <cfqueryparam value="#form.session_period_id#" cfsqltype="cf_sql_integer">
			</cfquery>
		</cfif>
	</cfif>
	<cfscript>
		if(not len(GET_ACTION.ACTION_DATE))	ACTION_DATE=now(); //belgede tarih yoksa ki olmadigi yerler var
		if(paper_action_type eq 1)
		{//fatura tipinde ise irsaliyeden maliyet eklenmişse siliyor cünkü hem irsaliye hemde fatura maliyet oluştursun denmiş olabilir (ancak bunu silerken tüm belgeyi silmek hatalı sadece faturada olanları silmek gerek)
			del_cost(
						del_ship_id_list : '#ship_id_list#',
						del_dsn1 : form.dsn1,
						del_period_dsn : form.period_dsn_type,
						paper_product_id_ : paper_product_id,
						del_cost_period_id : form.session_period_id
					);
			for(shp_list_count=1;shp_list_count lte GET_NEWER_INV_SHIP_COST.RECORDCOUNT;shp_list_count=shp_list_count+1)
			{
			//irsaliyeden eklenen maliyet silindikten sonra oncelikle ondan sonraki maliyetler guncellenmeli cunku irsaliyede olan fakat faturaya çekilmemiş ürün olabilir v.b.
				upd_newer_cost(
								newer_action_id=evaluate('GET_NEWER_INV_SHIP_COST.ACTION_ID[#shp_list_count#]'),
								newer_action_row_id=evaluate('GET_NEWER_INV_SHIP_COST.ACTION_ROW_ID[#shp_list_count#]'),
								newer_spec_main_id=evaluate('GET_NEWER_INV_SHIP_COST.SPECT_MAIN_ID[#shp_list_count#]'),
								newer_product_id=evaluate('GET_NEWER_INV_SHIP_COST.PRODUCT_ID[#shp_list_count#]'),
								newer_action_date=evaluate('GET_NEWER_INV_SHIP_COST.START_DATE[#shp_list_count#]'),
								newer_record_date=evaluate('GET_NEWER_INV_SHIP_COST.RECORD_DATE[#shp_list_count#]'),
								newer_comp_period_list='#comp_period_list#',
								newer_comp_period_year_list='#comp_period_year_list#',
								newer_dsn=form.dsn,
								newer_dsn3=form.dsn3,
								newer_period_dsn_type=form.period_dsn_type,
								newer_our_company_id=GET_COMPS_PER.OUR_COMPANY_ID
							);
			}
		}
	</cfscript>
	<!---*** islem tipi guncelleme ise guncellenen belgeden daha once eklenmis maliyetler siliniyor ve daha ilerki tarihlerine maliyet varsa guncelleniyor (cunku guncellemede daha once eklenen urun cikarilmis olabilir) --->
	<cfif paper_query_type eq 2>
		<cfif isdefined('GET_ACTION.INV_CONT_COMP')><!--- FİYAT FARKI FATURASI İSE BİRDEN FAZLA FATURA ÇEKİLMİŞ OLABİLİR BİR FİYAT FARKI FATURASINA --->
			<cfset paper_action_id_list=valuelist(GET_ACTION.INVOICE_ID,',')>
		</cfif>
		<cfquery name="GET_P_COST_ID" datasource="#FORM.DSN1#">
			--Belge için oluşturulmuş olan maliyeti bulduk...
            SELECT 
				PRODUCT_COST_ID,
				START_DATE,
				SPECT_MAIN_ID,
				PRODUCT_ID,
				RECORD_DATE,
				ACTION_ID,
				ACTION_TYPE,
				ISNULL(ACTION_ROW_ID,0) ACTION_ROW_ID,
				ISNULL(PRICE_PROTECTION,0) PRICE_PROTECTION,
				PRICE_PROTECTION_MONEY,
				PRICE_PROTECTION_TYPE,
				ISNULL(STANDARD_COST,0) STANDARD_COST,
				STANDARD_COST_MONEY,
				ISNULL(STANDARD_COST_RATE,0) STANDARD_COST_RATE,
				MONEY,
				ISNULL(PRICE_PROTECTION_LOCATION,0) PRICE_PROTECTION_LOCATION,
				PRICE_PROTECTION_MONEY_LOCATION,
				ISNULL(STANDARD_COST_LOCATION,0) STANDARD_COST_LOCATION,
				STANDARD_COST_MONEY_LOCATION,
				ISNULL(STANDARD_COST_RATE_LOCATION,0) STANDARD_COST_RATE_LOCATION,
				MONEY_LOCATION,
                ISNULL(PRICE_PROTECTION_DEPARTMENT,0) PRICE_PROTECTION_DEPARTMENT,
				PRICE_PROTECTION_MONEY_DEPARTMENT,
				ISNULL(STANDARD_COST_DEPARTMENT,0) STANDARD_COST_DEPARTMENT,
				STANDARD_COST_MONEY_DEPARTMENT,
				ISNULL(STANDARD_COST_RATE_DEPARTMENT,0) STANDARD_COST_RATE_DEPARTMENT,
				MONEY_DEPARTMENT
			FROM 
				PRODUCT_COST 
			WHERE
				<cfif not isdefined('GET_ACTION.INV_CONT_COMP')>
					ACTION_ID = #paper_action_id# AND	<!--- <cfqueryparam value="#paper_action_id#" cfsqltype="cf_sql_integer">  --->
				<cfelse><!--- FİYAT FARKI FATURASI İSE BİRDEN FAZLA FATURA ÇEKİLMİŞ OLABİLİR BİR FİYAT FARKI FATURASINA --->
					ACTION_ID IN (#paper_action_id_list#) AND
				</cfif>
				<cfif len(paper_product_id)>
				PRODUCT_COST.PRODUCT_ID = #paper_product_id# AND 
				</cfif>
				<cfif len(paper_action_row_id) and paper_action_row_id neq 0 and paper_action_type eq 8>
				ACTION_ROW_ID = #paper_action_row_id# AND
				</cfif>
				ACTION_TYPE = #paper_action_type# AND
				ACTION_PERIOD_ID = #form.session_period_id#	
		</cfquery> 
<!---        
 get_action: <pre><cfdump var="#GET_ACTION#">
<br/>GET_P_COST_ID: <pre><cfdump var="#GET_P_COST_ID#"> --->
		<cfif GET_P_COST_ID.RECORDCOUNT>
			<cfscript>//fiyat koruma degerleri ve sabit maliyet girilmiş ise degerleri kaybetmemesi için.. kurları alıyoruz dongudede hesaplanacaklar
					rate_list=get_cost_rate(action_id : paper_action_id,
											action_type : paper_action_type,
											session_period_id : form.session_period_id,
											action_date : createodbcdate(GET_P_COST_ID.START_DATE),
											dsn_period_money : form.period_dsn_type,
											dsn_money : FORM.DSN
											);
					cost_action_date = dateformat(GET_P_COST_ID.START_DATE,dateformat_style);
					cost_rec_date = dateformat(GET_P_COST_ID.RECORD_DATE,dateformat_style);
			</cfscript>
			<cf_date tarih = cost_action_date>
			<cfloop query="GET_P_COST_ID"><!--- maliyetler dondurulurken eklenmiş fiyat kormu v.s. gibi degerler varsa onlarla degisken olusuyor sonra eklenmiş olan maliyet siliniyor ve o tarihten ilerki tarihli maliyetler guncelleniyor --->	
				<cfscript>
					if(not len(GET_P_COST_ID.PRICE_PROTECTION_TYPE)) GET_P_COST_ID.PRICE_PROTECTION_TYPE = 1;
					cost_spect_id=GET_P_COST_ID.SPECT_MAIN_ID;//degisken olusturuken product_id yetmeyecek ayni urun olabilir ancak specleri farklidir
					//fiyat koruma
					if(GET_P_COST_ID.PRICE_PROTECTION gt 0 and listfind(rate_list,GET_P_COST_ID.PRICE_PROTECTION_MONEY,';'))	
					{
						'prc_protec_sys_#PRODUCT_ID#_#cost_spect_id#' = GET_P_COST_ID.PRICE_PROTECTION*listgetat(rate_list,listfind(rate_list,GET_P_COST_ID.PRICE_PROTECTION_MONEY,';')-1,';');
						'prc_protec_#PRODUCT_ID#_#cost_spect_id#' = evaluate('prc_protec_sys_#PRODUCT_ID#_#cost_spect_id#')/listgetat(rate_list,listfind(rate_list,GET_P_COST_ID.MONEY,';')-1,';');
						'prc_protec_sys_2_#PRODUCT_ID#_#cost_spect_id#' = evaluate('prc_protec_sys_#PRODUCT_ID#_#cost_spect_id#')/listgetat(rate_list,listfind(rate_list,form.cost_money_system_2,';')-1,';');
						'prc_protec_org_#PRODUCT_ID#_#cost_spect_id#' = GET_P_COST_ID.PRICE_PROTECTION;
						'prc_protec_money_#PRODUCT_ID#_#cost_spect_id#' = GET_P_COST_ID.PRICE_PROTECTION_MONEY;
						'prc_protec_type_#PRODUCT_ID#_#cost_spect_id#' = GET_P_COST_ID.PRICE_PROTECTION_TYPE;
					}else
					{
						'prc_protec_sys_#PRODUCT_ID#_#cost_spect_id#'=0;
						'prc_protec_#PRODUCT_ID#_#cost_spect_id#'=0;
						'prc_protec_sys_2_#PRODUCT_ID#_#cost_spect_id#' = 0;
						'prc_protec_org_#PRODUCT_ID#_#cost_spect_id#' = 0;
						'prc_protec_money_#PRODUCT_ID#_#cost_spect_id#' = GET_P_COST_ID.PRICE_PROTECTION_MONEY;
						'prc_protec_type_#PRODUCT_ID#_#cost_spect_id#' = GET_P_COST_ID.PRICE_PROTECTION_TYPE;
					}
					//standart maliyet
					if(GET_P_COST_ID.STANDARD_COST gt 0 and listfind(rate_list,GET_P_COST_ID.STANDARD_COST_MONEY,';'))
					{
						'std_cost_sys_#PRODUCT_ID#_#cost_spect_id#' = GET_P_COST_ID.STANDARD_COST*listgetat(rate_list,listfind(rate_list,GET_P_COST_ID.STANDARD_COST_MONEY,';')-1,';');
						'std_cost_#PRODUCT_ID#_#cost_spect_id#' = evaluate('std_cost_sys_#PRODUCT_ID#_#cost_spect_id#')/listgetat(rate_list,listfind(rate_list,GET_P_COST_ID.MONEY,';')-1,';');
						'std_cost_sys_2_#PRODUCT_ID#_#cost_spect_id#' = evaluate('std_cost_sys_#PRODUCT_ID#_#cost_spect_id#')/listgetat(rate_list,listfind(rate_list,form.cost_money_system_2,';')-1,';');
						'std_cost_org_#PRODUCT_ID#_#cost_spect_id#' = GET_P_COST_ID.STANDARD_COST;
						'std_cost_money_#PRODUCT_ID#_#cost_spect_id#' = GET_P_COST_ID.STANDARD_COST_MONEY;
					}else
					{
						'std_cost_sys_#PRODUCT_ID#_#cost_spect_id#' = 0;
						'std_cost_#PRODUCT_ID#_#cost_spect_id#' = 0;
						'std_cost_sys_2_#PRODUCT_ID#_#cost_spect_id#' = 0;
						'std_cost_org_#PRODUCT_ID#_#cost_spect_id#' = 0;
						'std_cost_money_#PRODUCT_ID#_#cost_spect_id#' = '#form.cost_money_system#';
					}
					'std_cost_rate_#PRODUCT_ID#_#cost_spect_id#' = GET_P_COST_ID.STANDARD_COST_RATE;
					
					//lokasyon için fiyat koruma
					if(GET_P_COST_ID.PRICE_PROTECTION_LOCATION gt 0 and listfind(rate_list,GET_P_COST_ID.PRICE_PROTECTION_MONEY_LOCATION,';'))	
					{
						'prc_protec_sys_loc_#PRODUCT_ID#_#cost_spect_id#' = GET_P_COST_ID.PRICE_PROTECTION_LOCATION*listgetat(rate_list,listfind(rate_list,GET_P_COST_ID.PRICE_PROTECTION_MONEY_LOCATION,';')-1,';');
						'prc_protec_loc_#PRODUCT_ID#_#cost_spect_id#' = evaluate('prc_protec_sys_loc_#PRODUCT_ID#_#cost_spect_id#')/listgetat(rate_list,listfind(rate_list,GET_P_COST_ID.MONEY_LOCATION,';')-1,';');
						'prc_protec_sys_2_loc_#PRODUCT_ID#_#cost_spect_id#' = evaluate('prc_protec_sys_loc_#PRODUCT_ID#_#cost_spect_id#')/listgetat(rate_list,listfind(rate_list,form.cost_money_system_2,';')-1,';');
						'prc_protec_org_loc_#PRODUCT_ID#_#cost_spect_id#' = GET_P_COST_ID.PRICE_PROTECTION_LOCATION;
						'prc_protec_money_loc_#PRODUCT_ID#_#cost_spect_id#' = GET_P_COST_ID.PRICE_PROTECTION_MONEY_LOCATION;
					}else
					{
						'prc_protec_sys_loc_#PRODUCT_ID#_#cost_spect_id#'=0;
						'prc_protec_loc_#PRODUCT_ID#_#cost_spect_id#'=0;
						'prc_protec_sys_2_loc_#PRODUCT_ID#_#cost_spect_id#' = 0;
						'prc_protec_org_loc_#PRODUCT_ID#_#cost_spect_id#' = 0;
						'prc_protec_money_loc_#PRODUCT_ID#_#cost_spect_id#' = GET_P_COST_ID.PRICE_PROTECTION_MONEY_LOCATION;
					}
					
					//depo için fiyat koruma
					if(GET_P_COST_ID.PRICE_PROTECTION_DEPARTMENT gt 0 and listfind(rate_list,GET_P_COST_ID.PRICE_PROTECTION_MONEY_DEPARTMENT,';'))	
					{
						'prc_protec_sys_dep_#PRODUCT_ID#_#cost_spect_id#' = GET_P_COST_ID.PRICE_PROTECTION_DEPARTMENT*listgetat(rate_list,listfind(rate_list,GET_P_COST_ID.PRICE_PROTECTION_MONEY_DEPARTMENT,';')-1,';');
						'prc_protec_dep_#PRODUCT_ID#_#cost_spect_id#' = evaluate('prc_protec_sys_dep_#PRODUCT_ID#_#cost_spect_id#')/listgetat(rate_list,listfind(rate_list,GET_P_COST_ID.MONEY_DEPARTMENT,';')-1,';');
						'prc_protec_sys_2_dep_#PRODUCT_ID#_#cost_spect_id#' = evaluate('prc_protec_sys_dep_#PRODUCT_ID#_#cost_spect_id#')/listgetat(rate_list,listfind(rate_list,form.cost_money_system_2,';')-1,';');
						'prc_protec_org_dep_#PRODUCT_ID#_#cost_spect_id#' = GET_P_COST_ID.PRICE_PROTECTION_DEPARTMENT;
						'prc_protec_money_dep_#PRODUCT_ID#_#cost_spect_id#' = GET_P_COST_ID.PRICE_PROTECTION_MONEY_DEPARTMENT;
					}else
					{
						'prc_protec_sys_dep_#PRODUCT_ID#_#cost_spect_id#'=0;
						'prc_protec_dep_#PRODUCT_ID#_#cost_spect_id#'=0;
						'prc_protec_sys_2_dep_#PRODUCT_ID#_#cost_spect_id#' = 0;
						'prc_protec_org_dep_#PRODUCT_ID#_#cost_spect_id#' = 0;
						'prc_protec_money_dep_#PRODUCT_ID#_#cost_spect_id#' = GET_P_COST_ID.PRICE_PROTECTION_MONEY_DEPARTMENT;
					}
					
					
					//writeoutput(evaluate('prc_protec_#PRODUCT_ID#_#cost_spect_id#'));
					//lokasyon için standart maliyet
					if(GET_P_COST_ID.STANDARD_COST_LOCATION gt 0 and listfind(rate_list,GET_P_COST_ID.STANDARD_COST_MONEY_LOCATION,';'))
					{
						'std_cost_sys_loc_#PRODUCT_ID#_#cost_spect_id#' = GET_P_COST_ID.STANDARD_COST_LOCATION*listgetat(rate_list,listfind(rate_list,GET_P_COST_ID.STANDARD_COST_MONEY_LOCATION,';')-1,';');
						'std_cost_loc_#PRODUCT_ID#_#cost_spect_id#' = evaluate('std_cost_sys_loc_#PRODUCT_ID#_#cost_spect_id#')/listgetat(rate_list,listfind(rate_list,GET_P_COST_ID.MONEY_LOCATION,';')-1,';');
						'std_cost_sys_2_loc_#PRODUCT_ID#_#cost_spect_id#' = evaluate('std_cost_sys_loc_#PRODUCT_ID#_#cost_spect_id#')/listgetat(rate_list,listfind(rate_list,form.cost_money_system_2,';')-1,';');
						'std_cost_org_loc_#PRODUCT_ID#_#cost_spect_id#' = GET_P_COST_ID.STANDARD_COST_LOCATION;
						'std_cost_money_loc_#PRODUCT_ID#_#cost_spect_id#' = GET_P_COST_ID.STANDARD_COST_MONEY_LOCATION;
					}else
					{
						'std_cost_sys_loc_#PRODUCT_ID#_#cost_spect_id#' = 0;
						'std_cost_loc_#PRODUCT_ID#_#cost_spect_id#' = 0;
						'std_cost_sys_2_loc_#PRODUCT_ID#_#cost_spect_id#' = 0;
						'std_cost_org_loc_#PRODUCT_ID#_#cost_spect_id#' = 0;
						'std_cost_money_loc_#PRODUCT_ID#_#cost_spect_id#' = '#form.cost_money_system#';
					}
					'std_cost_rate_loc_#PRODUCT_ID#_#cost_spect_id#' = GET_P_COST_ID.STANDARD_COST_RATE_LOCATION;
					
					//depo için standart maliyet
					if(GET_P_COST_ID.STANDARD_COST_DEPARTMENT gt 0 and listfind(rate_list,GET_P_COST_ID.STANDARD_COST_MONEY_DEPARTMENT,';'))
					{
						'std_cost_sys_dep_#PRODUCT_ID#_#cost_spect_id#' = GET_P_COST_ID.STANDARD_COST_DEPARTMENT*listgetat(rate_list,listfind(rate_list,GET_P_COST_ID.STANDARD_COST_MONEY_DEPARTMENT,';')-1,';');
						'std_cost_dep_#PRODUCT_ID#_#cost_spect_id#' = evaluate('std_cost_sys_dep_#PRODUCT_ID#_#cost_spect_id#')/listgetat(rate_list,listfind(rate_list,GET_P_COST_ID.MONEY_DEPARTMENT,';')-1,';');
						'std_cost_sys_2_dep_#PRODUCT_ID#_#cost_spect_id#' = evaluate('std_cost_sys_dep_#PRODUCT_ID#_#cost_spect_id#')/listgetat(rate_list,listfind(rate_list,form.cost_money_system_2,';')-1,';');
						'std_cost_org_dep_#PRODUCT_ID#_#cost_spect_id#' = GET_P_COST_ID.STANDARD_COST_DEPARTMENT;
						'std_cost_money_dep_#PRODUCT_ID#_#cost_spect_id#' = GET_P_COST_ID.STANDARD_COST_MONEY_DEPARTMENT;
					}else
					{
						'std_cost_sys_dep_#PRODUCT_ID#_#cost_spect_id#' = 0;
						'std_cost_dep_#PRODUCT_ID#_#cost_spect_id#' = 0;
						'std_cost_sys_2_dep_#PRODUCT_ID#_#cost_spect_id#' = 0;
						'std_cost_org_dep_#PRODUCT_ID#_#cost_spect_id#' = 0;
						'std_cost_money_dep_#PRODUCT_ID#_#cost_spect_id#' = '#form.cost_money_system#';
					}
					'std_cost_rate_dep_#PRODUCT_ID#_#cost_spect_id#' = GET_P_COST_ID.STANDARD_COST_RATE_DEPARTMENT;
					
					
					////writeoutput('Verilen Belge Numarası İçin bulunan Maliyet Siliniyor..<br/>');
					del_cost(
							del_product_cost_id=GET_P_COST_ID.PRODUCT_COST_ID,
							del_dsn1=FORM.DSN1,
							del_period_dsn=form.period_dsn_type
							);
					/*Satırdaki maliyet silindikten hemen sonra sonraki maliyetleri güncellemeli mi?Yoksa aşağıda  mı her satır için kendisinden sonraki satırlar mı güncellenmeli,
					bu bloğu şimdilik kapatıyorum,çünkü sanki bir faydası yok gibi cost_rec_date CreateODBCDate(cost_rec_date)'den geçirildikten sonra gün ve ay yer değiştiriyor,yani
					zaten çalışsada doğru çalışmıyormuş gibi,yada biz düzeltmeye çalışırken bozduk,şimdilik kapatıyorum daha sonra testlerden sonra açıp açmamaya karar vericez..
							
					//writeoutput('<font color="blue">[#paper_action_id#---#cost_rec_date#--------#CreateODBCDate(cost_rec_date)#]Eklenen veya silinen maliyetten sonraki maliyetleri guncelliyor</font><br/>');		
					upd_newer_cost(
									newer_action_id=paper_action_id,
									newer_action_row_id=GET_P_COST_ID.ACTION_ROW_ID,
									newer_spec_main_id=GET_P_COST_ID.SPECT_MAIN_ID,
									newer_product_id=GET_P_COST_ID.PRODUCT_ID,
									newer_action_date=cost_action_date,
									newer_record_date=cost_rec_date,
									newer_comp_period_list='#comp_period_list#',
									newer_comp_period_year_list='#comp_period_year_list#',
									newer_dsn=form.dsn,
									newer_dsn3=form.dsn3,
									newer_period_dsn_type=form.period_dsn_type,
									newer_our_company_id=GET_COMPS_PER.OUR_COMPANY_ID
								);
					*/		
				</cfscript>
			</cfloop>
		<cfelse>
			<cfscript>//fiyat koruma degerleri ve sabit maliyet girilmiş ise degerleri kaybetmemesi için.. kurları alıyoruz dongudede hesaplanacaklar
					rate_list=get_cost_rate(action_id : paper_action_id,
											action_type : paper_action_type,
											session_period_id : form.session_period_id,
											action_date : GET_ACTION.PAPER_DATE,
											dsn_period_money : form.period_dsn_type,
											dsn_money : FORM.DSN
											);
			</cfscript>
		</cfif>
	</cfif>
<!--- //*** islem tipi guncelleme ise guncellenen belgeden daha once eklenmis maliyetler siliniyor ve daha ilerki tarihlerine maliyet varsa guncelleniyor (cunku guncellemede daha once eklenen urun cikarilmis olabilir) --->

	<cfquery name="GET_PROCESS_CAT" datasource="#FORM.DSN3#">
		SELECT
			PROCESS_CAT_ID,
			PROCESS_TYPE,
			IS_COST,
			IS_COST_ZERO_ROW,
			IS_COST_FIELD
		FROM
			SETUP_PROCESS_CAT 
		WHERE 
			PROCESS_CAT_ID = <cfqueryparam value="#GET_ACTION.PROCESS_CAT#" cfsqltype="cf_sql_integer">
	</cfquery>
	<cfif GET_PROCESS_CAT.IS_COST eq 1><!--- islem kategorisi maliyet islemi yapıyorsa--->
		<cfloop query="GET_ACTION">
			<cfoutput>
			<cfif isdefined('INV_CONT_COMP')>
				<!--- fiyat farkı ise fonksiyona gelen belge id vs ana faturanın ki ile değiştiriliyor. --->
				<cfset form.action_id = GET_ACTION.INVOICE_ID>
				<cfset paper_action_id = GET_ACTION.INVOICE_ID>
				<cfset form.query_type = 2><!--- tabiki ana fatura guncellenecegindn guncelleme tipi yapılıyor --->
				<cfset paper_query_type =2>
			</cfif>
			<!--- spec_id varsa stok hareketi ve maliyet kaydi main_spec le yapildigi icin main spec_id buluyoruz --->
			<cfset SPEC_MAIN_ID=''>
			<cfset STOCK_ID_=''>
			<cfif is_stock_based_cost eq 1>
				<cfset STOCK_ID_=GET_ACTION.STOCK_ID>
			</cfif>
			<cfif len(SPEC_ID)>
				<cfquery name="GET_SPEC" datasource="#FORM.DSN3#">
					SELECT SPECT_MAIN_ID FROM SPECTS WHERE SPECT_VAR_ID = <cfqueryparam value="#SPEC_ID#" cfsqltype="cf_sql_integer">
				</cfquery>
				<cfif GET_SPEC.RECORDCOUNT and is_prod_cost_type eq 0>
					<cfset SPEC_MAIN_ID=GET_SPEC.SPECT_MAIN_ID>
				</cfif>
			<cfelseif isdefined('EXCHANGE_SPECT_MAIN_ID') and len(EXCHANGE_SPECT_MAIN_ID) and is_prod_cost_type eq 0><!--- virman ve üretim sonucunda main spec üzerinden çalışabilir normal spec olmayabilir--->
				<cfset SPEC_MAIN_ID = EXCHANGE_SPECT_MAIN_ID>
			</cfif>
			<!--- simdi eklenmek istenilen tarihten sonraya bir maliyet varmi eger yoksa asagida eklenen maliyet aktif olacak digerleri pasif varsa eklenen maliyet pasif olarak eklenecek--->
			<cfquery name="GET_NEXT_PRODUCT_COST" datasource="#FORM.DSN3#" maxrows="1">
				SELECT 
					PRODUCT_COST_ID
				FROM 
					PRODUCT_COST 
				WHERE
					PRODUCT_ID = <cfqueryparam value="#PRODUCT_ID#" cfsqltype="cf_sql_integer"> AND
					<cfif isdefined('SPEC_MAIN_ID') and len(SPEC_MAIN_ID)>
						SPECT_MAIN_ID = <cfqueryparam value="#SPEC_MAIN_ID#" cfsqltype="cf_sql_integer"> AND
					<cfelseif is_prod_cost_type eq 0>
						IS_SPEC=0 AND
					</cfif>
					<cfif isdefined("STOCK_ID_") and len(STOCK_ID_)>
						STOCK_ID = <cfqueryparam value="#STOCK_ID_#" cfsqltype="cf_sql_integer"> AND
					</cfif>
					START_DATE >= <cfqueryparam value="#createodbcdatetime(ACTION_DATE)#" cfsqltype="cf_sql_timestamp">
					AND ACTION_PERIOD_ID IN (#comp_period_list#)
				ORDER BY START_DATE ASC,RECORD_DATE ASC,PRODUCT_COST_ID ASC
			</cfquery>
			<!--- hesaplanacak maliyettin para birimi urunun once alis yoksa satis fiyatı parabiriminde aliniyor --->
			<cfquery name="GET_STANDART_COST_MONEY_PURCHASE" datasource="#FORM.DSN3#">
				SELECT 
					MAX(PRICE) AS PRICE,
					MONEY 
				FROM
					PRICE_STANDART
				WHERE
					PRODUCT_ID = <cfqueryparam value="#PRODUCT_ID#" cfsqltype="cf_sql_integer"> AND
					PURCHASESALES=0 AND
					PRICESTANDART_STATUS=1
				GROUP BY MONEY
			</cfquery>
			<cfset cost_money = form.cost_money_system_2><!--- deger gelmeme olasiligi ile ilk sistem 2 parabirimi attik --->
			<cfif GET_STANDART_COST_MONEY_PURCHASE.RECORDCOUNT>
				<cfset cost_money = GET_STANDART_COST_MONEY_PURCHASE.MONEY>
			<cfelse>
				<cfquery name="GET_STANDART_COST_MONEY_SALES" datasource="#FORM.DSN3#">
					SELECT
						MAX(PRICE) AS PRICE,
						MONEY
					FROM
						PRICE_STANDART
					WHERE
						PRODUCT_ID = <cfqueryparam value="#PRODUCT_ID#" cfsqltype="cf_sql_integer"> AND
						PURCHASESALES=1 AND
						PRICESTANDART_STATUS=1
					GROUP BY MONEY
				</cfquery>
				<cfif GET_STANDART_COST_MONEY_SALES.recordcount and len(GET_STANDART_COST_MONEY_SALES.MONEY)>
					<cfset cost_money = GET_STANDART_COST_MONEY_SALES.MONEY>
				</cfif>
			</cfif>
			<!--- TL Birimden Maliyet Olussun Secili ise--->
			<cfif comp_cost_calc_type eq 1><cfset cost_money = form.cost_money_system></cfif>
			<cfscript>//maliyet fonsiyonuna main_spec_id yollaniyor
			if(year(createodbcdate(ACTION_DATE)) lt 2009 and cost_money is 'TL')
				cost_money='YTL';
			if(isdefined('SPEC_MAIN_ID') and len(SPEC_MAIN_ID))
			{
				maliyet = get_product_stock_cost(
							is_product_stock : 1,
							product_stock_id : PRODUCT_ID,
							tax_inc : 0,
							cost_method : GET_COMPS_PER.INVENTORY_CALC_TYPE,
							cost_date : createodbcdate(ACTION_DATE),
							cost_money : cost_money,
							action_id : paper_action_id,
							action_row_id : ACTION_ROW_ID,
							control_type : form.control_type,
							action_type : paper_action_type,
							spec_main_id : SPEC_MAIN_ID,
							stock_id : STOCK_ID_,
							period_dsn_type : form.period_dsn_type,
							action_comp_period_list : '#comp_period_list#',
							cost_money_system : form.cost_money_system,
							cost_money_system_2 : form.cost_money_system_2,
							is_cost_zero_row : iif(GET_PROCESS_CAT.IS_COST_ZERO_ROW eq 1,1,0),
							is_cost_field : iif(GET_PROCESS_CAT.IS_COST_FIELD eq 1,1,0),
							is_cost_calc_type : comp_cost_calc_type
							);
			}
			else
			{
				maliyet = get_product_stock_cost(
							is_product_stock : 1,
							product_stock_id : PRODUCT_ID,
							tax_inc : 0,
							cost_method : GET_COMPS_PER.INVENTORY_CALC_TYPE,
							cost_date : createodbcdate(ACTION_DATE),
							cost_money : cost_money,
							action_id : paper_action_id,
							action_row_id : ACTION_ROW_ID,
							control_type : form.control_type,
							action_type : paper_action_type,
							stock_id : STOCK_ID_,
							period_dsn_type : form.period_dsn_type,
							action_comp_period_list : '#comp_period_list#',
							cost_money_system : form.cost_money_system,
							cost_money_system_2 : form.cost_money_system_2,
							is_cost_zero_row :  iif(GET_PROCESS_CAT.IS_COST_ZERO_ROW eq 1,1,0),
							is_cost_field : iif(GET_PROCESS_CAT.IS_COST_FIELD eq 1,1,0),
							is_cost_calc_type : comp_cost_calc_type
							);	
			}
			</cfscript><!--- <cfdump var="#maliyet#"><br /> --->
			<cfset stok_bakma_tarihi = createodbcdatetime(ACTION_DATE)><!--- time olarak düzenlendi PY 220519 islem gunundeki aktif stok bulunuyor onun icin stok tarihi --->
			<!--- fonksiyondan dönen değer 0 dan büyük yada 0 satırlar maliyet oluştur seçili ise iade devir ambar fişlerinden biri değil ise oluşturur --->
			<cfif maliyet neq 'YOK' and ( listfirst(maliyet,';') gt 0 or (GET_PROCESS_CAT.IS_COST_ZERO_ROW eq 1 and not listfind('55,54,73,74,114,110,115',GET_PROCESS_CAT.PROCESS_TYPE,',')))>
				<cfscript>
					reference_money = cost_money;
					mevcut_son_alislar = "#listgetat(maliyet,3,';')#";
					//urun maliyet
					alis_net_fiyat_money = "#reference_money#";
					alis_net_fiyat = "#listfirst(maliyet,';')#";
					alis_ek_maliyet_money = "#reference_money#";
					alis_ek_maliyet = "#listgetat(maliyet,2,';')#";
					//sistem parabirimi
					alis_net_fiyat_money_system = form.cost_money_system;
					alis_net_fiyat_system = "#listgetat(maliyet,4,';')#";
					alis_ek_maliyet_system = "#listgetat(maliyet,5,';')#";
					alis_ek_maliyet_money_system = form.cost_money_system;
					//sistem 2. para birimi
					alis_net_fiyat_money_system_2 = form.cost_money_system_2;
					alis_net_fiyat_system_2 = "#listgetat(maliyet,6,';')#";
					alis_ek_maliyet_system_2 = "#listgetat(maliyet,7,';')#";
					alis_ek_maliyet_money_system_2 = form.cost_money_system_2;
					
					//LOKASYON
					mevcut_son_alislar_lokasyon = "#listgetat(maliyet,8,';')#";
					//urun maliyet lokasyon
					alis_net_fiyat_lokasyon = "#listgetat(maliyet,9,';')#";
					alis_ek_maliyet_lokasyon = "#listgetat(maliyet,10,';')#";
					//sistem parabirimi
					alis_net_fiyat_system_lokasyon = "#listgetat(maliyet,11,';')#";
					alis_ek_maliyet_system_lokasyon = "#listgetat(maliyet,12,';')#";
					//sistem 2. para birimi
					alis_net_fiyat_system_2_lokasyon = "#listgetat(maliyet,13,';')#";
					alis_ek_maliyet_system_2_lokasyon = "#listgetat(maliyet,14,';')#";
					
					//depo
					mevcut_son_alislar_department = "#listgetat(maliyet,17,';')#";
					//urun maliyet department
					alis_net_fiyat_department = "#listgetat(maliyet,18,';')#";
					alis_ek_maliyet_department = "#listgetat(maliyet,19,';')#";
					//sistem parabirimi
					alis_net_fiyat_system_department = "#listgetat(maliyet,20,';')#";
					alis_ek_maliyet_system_department = "#listgetat(maliyet,21,';')#";
					//sistem 2. para birimi
					alis_net_fiyat_system_2_department = "#listgetat(maliyet,22,';')#";
					alis_ek_maliyet_system_2_department = "#listgetat(maliyet,23,';')#";

					alis_reflection = "#listgetat(maliyet,24,';')#";
					alis_labor = "#listgetat(maliyet,25,';')#";
					alis_reflection_lokasyon = "#listgetat(maliyet,26,';')#";
					alis_labor_lokasyon = "#listgetat(maliyet,27,';')#";
					alis_reflection_department = "#listgetat(maliyet,28,';')#";
					alis_labor_department = "#listgetat(maliyet,29,';')#";
					
					alis_reflection_system = "#listgetat(maliyet,30,';')#";
					alis_labor_system = "#listgetat(maliyet,31,';')#";
					alis_reflection_system_lokasyon = "#listgetat(maliyet,32,';')#";
					alis_labor_system_lokasyon = "#listgetat(maliyet,33,';')#";
					alis_reflection_system_department = "#listgetat(maliyet,34,';')#";
					alis_labor_system_department = "#listgetat(maliyet,35,';')#";
					
					alis_reflection_system_2 = "#listgetat(maliyet,36,';')#";
					alis_labor_system_2 = "#listgetat(maliyet,37,';')#";
					alis_reflection_system_2_lokasyon = "#listgetat(maliyet,38,';')#";
					alis_labor_system_2_lokasyon = "#listgetat(maliyet,39,';')#";
					alis_reflection_system_2_department = "#listgetat(maliyet,40,';')#";
					alis_labor_system_2_department = "#listgetat(maliyet,41,';')#";
					
					//belge satır tutarı finansal ve fiziksel yaşlarda kullanıyoruz
					if(listlen(maliyet,';') gt 14) satir_fiyat_tutar = "#listgetat(maliyet,15,';')#"; else satir_fiyat_tutar = 0;
					if(listlen(maliyet,';') gt 15) satir_ekstra_tutar = "#listgetat(maliyet,16,';')#"; else satir_ekstra_tutar = 0;
					
					//fiyat farkı tipinde ise fark toplamı stok miktarına bölünerek birim fark bulunuyor
					if(paper_action_type eq 8){
							/*stok miktarına bölünecek ise
							price_protec_=TOTAL_PRICE_PROTECTION/mevcut_son_alislar;
							price_protec_amount_=mevcut_son_alislar;*/
							price_protec_=PRICE_PROTECTION;
							price_protec_amount_=AMOUNT;
							//fiyat koruma degerleri ve sabit maliyet girilmiş ise degerleri kaybetmemesi için.. kurları alıyoruz kurlar eklendiği faturadan alınıyor dongudede hesaplanacaklar
							rate_list_pr_p=get_cost_rate(action_id : paper_action_id,
													action_type : 1,
													session_period_id : form.session_period_id,
													action_date : createodbcdate(ACTION_DATE),
													dsn_period_money : form.period_dsn_type,
													dsn_money : FORM.DSN
													);
							cost_action_date = dateformat(ACTION_DATE,dateformat_style);
							cost_rec_date = dateformat(INSERT_DATE,dateformat_style);
							cost_spect_id=EXCHANGE_SPECT_MAIN_ID;//degisken olusturuken product_id yetmeyecek ayni urun olabilir ancak specleri farklidir
							//fiyat koruma
							_MONEY__ = MONEY;
							if(MONEY is 'YTL' and ListGetAt(rate_list_pr_p,2,";") is 'TL') _MONEY__ = 'TL';
							if(MONEY is 'TL' and ListGetAt(rate_list_pr_p,2,";") is 'YTL') _MONEY__ = 'YTL';
							'prc_protec_sys_#PRODUCT_ID#_#cost_spect_id#' = price_protec_*listgetat(rate_list_pr_p,listfind(rate_list_pr_p,PRICE_PROTECTION_MONEY,';')-1,';');
							'prc_protec_#PRODUCT_ID#_#cost_spect_id#' = evaluate('prc_protec_sys_#PRODUCT_ID#_#cost_spect_id#')/listgetat(rate_list_pr_p,listfind(rate_list_pr_p,_MONEY__,';')-1,';');
							'prc_protec_sys_2_#PRODUCT_ID#_#cost_spect_id#' = evaluate('prc_protec_sys_#PRODUCT_ID#_#cost_spect_id#')/listgetat(rate_list_pr_p,listfind(rate_list_pr_p,form.cost_money_system_2,';')-1,';');
							'prc_protec_org_#PRODUCT_ID#_#cost_spect_id#' = price_protec_;
							'prc_protec_money_#PRODUCT_ID#_#cost_spect_id#' = PRICE_PROTECTION_MONEY;
							'prc_protec_type_#PRODUCT_ID#_#cost_spect_id#' = PRICE_PROTECTION_TYPE;
							'prc_protec_cost_type_#PRODUCT_ID#_#cost_spect_id#' = '';
							'prc_protec_amount_#PRODUCT_ID#_#cost_spect_id#' = price_protec_amount_;
							'prc_protec_total_#PRODUCT_ID#_#cost_spect_id#' = TOTAL_PRICE_PROTECTION;
							//lokasyon için fiyat koruma
							'prc_protec_sys_loc_#PRODUCT_ID#_#cost_spect_id#' = price_protec_*listgetat(rate_list_pr_p,listfind(rate_list_pr_p,PRICE_PROTECTION_MONEY,';')-1,';');
							'prc_protec_loc_#PRODUCT_ID#_#cost_spect_id#' = evaluate('prc_protec_sys_loc_#PRODUCT_ID#_#cost_spect_id#')/listgetat(rate_list_pr_p,listfind(rate_list_pr_p,_MONEY__,';')-1,';');
							'prc_protec_sys_2_loc_#PRODUCT_ID#_#cost_spect_id#' = evaluate('prc_protec_sys_loc_#PRODUCT_ID#_#cost_spect_id#')/listgetat(rate_list_pr_p,listfind(rate_list_pr_p,form.cost_money_system_2,';')-1,';');
							'prc_protec_org_loc_#PRODUCT_ID#_#cost_spect_id#' = price_protec_;
							'prc_protec_money_loc_#PRODUCT_ID#_#cost_spect_id#' = PRICE_PROTECTION_MONEY;
							//depo için fiyat koruma
							'prc_protec_sys_dep_#PRODUCT_ID#_#cost_spect_id#' = price_protec_*listgetat(rate_list_pr_p,listfind(rate_list_pr_p,PRICE_PROTECTION_MONEY,';')-1,';');
							'prc_protec_dep_#PRODUCT_ID#_#cost_spect_id#' = evaluate('prc_protec_sys_loc_#PRODUCT_ID#_#cost_spect_id#')/listgetat(rate_list_pr_p,listfind(rate_list_pr_p,_MONEY__,';')-1,';');
							'prc_protec_sys_2_dep_#PRODUCT_ID#_#cost_spect_id#' = evaluate('prc_protec_sys_loc_#PRODUCT_ID#_#cost_spect_id#')/listgetat(rate_list_pr_p,listfind(rate_list_pr_p,form.cost_money_system_2,';')-1,';');
							'prc_protec_org_dep_#PRODUCT_ID#_#cost_spect_id#' = price_protec_;
							'prc_protec_money_dep_#PRODUCT_ID#_#cost_spect_id#' = PRICE_PROTECTION_MONEY;
					}
				</cfscript>

				<cfquery name="GET_SEVK" datasource="#form.period_dsn_type#">
					SELECT
						SUM(STOCK_OUT-STOCK_IN) AS MIKTAR
					FROM
						STOCKS_ROW
					WHERE
						PRODUCT_ID = <cfqueryparam value="#PRODUCT_ID#" cfsqltype="cf_sql_integer"> AND
						<cfif isdefined('SPEC_MAIN_ID') and len(SPEC_MAIN_ID)>
							SPECT_VAR_ID = <cfqueryparam value="#SPEC_MAIN_ID#" cfsqltype="cf_sql_integer">  AND
						<cfelseif is_prod_cost_type eq 0>
							(SPECT_VAR_ID IS NULL OR SPECT_VAR_ID = 0) AND
						</cfif>
						<cfif isdefined("STOCK_ID_") and len(STOCK_ID_)>
							STOCK_ID = <cfqueryparam value="#STOCK_ID_#" cfsqltype="cf_sql_integer"> AND
						</cfif>
						PROCESS_TYPE = 81 AND
						PROCESS_DATE <= <cfqueryparam value="#stok_bakma_tarihi#" cfsqltype="cf_sql_timestamp">
						<cfif GET_NOT_DEP_COST.RECORDCOUNT>
						AND
							( 
							<cfset rw_count=0>
							<cfloop query="GET_NOT_DEP_COST">
								<cfset rw_count=rw_count+1>
								NOT (STORE_LOCATION = <cfqueryparam value="#GET_NOT_DEP_COST.LOCATION_ID#" cfsqltype="cf_sql_integer"> AND STORE = <cfqueryparam value="#GET_NOT_DEP_COST.DEPARTMENT_ID#" cfsqltype="cf_sql_integer">)
								<cfif rw_count lt GET_NOT_DEP_COST.RECORDCOUNT>AND</cfif>
							</cfloop>
							)
						</cfif>
				</cfquery>
				<cfif GET_SEVK.RECORDCOUNT and len(GET_SEVK.MIKTAR)>
					<cfset yoldaki_stoklar = GET_SEVK.MIKTAR>
				<cfelse>
					<cfset yoldaki_stoklar = ''>
				</cfif>

				<cfif not GET_NEXT_PRODUCT_COST.RECORDCOUNT><!--- eklenen maliyetten tarih olarak sonra olan bir maliyet yoksa hepsi pasif olur yeni eklenen aktif olacagi icin--->
					<cfquery name="UPD_COST" datasource="#FORM.DSN1#">
						UPDATE 
							PRODUCT_COST
						SET 
							PRODUCT_COST_STATUS = 0
						WHERE 
							PRODUCT_ID = <cfqueryparam value="#PRODUCT_ID#" cfsqltype="cf_sql_integer">
							<cfif isdefined('SPEC_MAIN_ID') and len(SPEC_MAIN_ID)>
								AND SPECT_MAIN_ID = <cfqueryparam value="#SPEC_MAIN_ID#" cfsqltype="cf_sql_integer">
							<cfelseif is_prod_cost_type eq 0>
								AND IS_SPEC=0
							</cfif>
							<cfif isdefined("STOCK_ID_") and len(STOCK_ID_)>
								AND STOCK_ID = <cfqueryparam value="#STOCK_ID_#" cfsqltype="cf_sql_integer"> 
							<cfelseif is_stock_based_cost eq 0>
								AND STOCK_ID IS NULL
							</cfif>
							AND ACTION_PERIOD_ID IN (#comp_period_list#)
					</cfquery>
				</cfif>

				<cfquery name="GET_COST_FOR_ALL" datasource="#FORM.DSN1#">
					SELECT 
						DUE_DATE,
						DUE_DATE_LOCATION,
                        DUE_DATE_DEPARTMENT,
						PURCHASE_NET_SYSTEM+PURCHASE_EXTRA_COST_SYSTEM PROD_COST,
						PHYSICAL_DATE,
						PHYSICAL_DATE_LOCATION,
                        PHYSICAL_DATE_DEPARTMENT,
						START_DATE,
						RECORD_DATE,
						DEPARTMENT_ID,
						LOCATION_ID,
						ACTION_ID,
						ACTION_ROW_ID,
						PRODUCT_COST_ID
					FROM
						PRODUCT_COST
					WHERE
						PRODUCT_ID = <cfqueryparam value="#PRODUCT_ID#" cfsqltype="cf_sql_integer">
						<cfif isdefined('SPEC_MAIN_ID') and len(SPEC_MAIN_ID)>
							AND SPECT_MAIN_ID = <cfqueryparam value="#SPEC_MAIN_ID#" cfsqltype="cf_sql_integer">
						<cfelseif is_prod_cost_type eq 0>
							AND IS_SPEC=0
						</cfif>
						<cfif isdefined("STOCK_ID_") and len(STOCK_ID_)>
							AND STOCK_ID = <cfqueryparam value="#STOCK_ID_#" cfsqltype="cf_sql_integer"> 
						<cfelseif is_stock_based_cost eq 0>
							AND STOCK_ID IS NULL
						</cfif>
						<!---AND DUE_DATE IS NOT NULL--->
						AND ACTION_PERIOD_ID IN (#comp_period_list#)	
						AND 
						(
						<!--- aynı gune eklenmis bir belge olabilir ancak kayit tarihi farkli olabilir --->
							(
								START_DATE < <cfqueryparam value="#createodbcdatetime(ACTION_DATE)#" cfsqltype="cf_sql_timestamp">
							)
							OR
							(
								START_DATE = <cfqueryparam value="#createodbcdatetime(ACTION_DATE)#" cfsqltype="cf_sql_timestamp">
								AND RECORD_DATE < <cfqueryparam value="#createodbcdatetime(INSERT_DATE)#" cfsqltype="cf_sql_timestamp">
							)
						)
				</cfquery>
				<cfif listfind('59,114',GET_PROCESS_CAT.PROCESS_TYPE,',')><!--- finansal yaş sadece alım faturalarında ve stok açılış devir fişlerinde çalışacak --->
					<cfquery name="GET_COST_FOR_DUE" dbtype="query">
						SELECT 
							DUE_DATE COST_DUE_DATE,
							PROD_COST
						FROM
							GET_COST_FOR_ALL
						WHERE
							DUE_DATE IS NOT NULL
						ORDER BY
							START_DATE DESC,
							RECORD_DATE DESC,
							PRODUCT_COST_ID DESC
					</cfquery>
					<cfquery name="GET_COST_FOR_DUE_LOCATION" dbtype="query">
						SELECT 
							DUE_DATE_LOCATION COST_DUE_DATE,
							PROD_COST
						FROM
							GET_COST_FOR_ALL
						WHERE
							DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ACTION_DEPARTMENT_ID#"> AND
							LOCATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ACTION_LOCATION_ID#"> AND
							DUE_DATE IS NOT NULL
						ORDER BY
							START_DATE DESC,
							RECORD_DATE DESC,
							PRODUCT_COST_ID DESC
					</cfquery>
                    <cfquery name="GET_COST_FOR_DUE_DEPARTMENT" dbtype="query">
						SELECT 
							DUE_DATE_DEPARTMENT COST_DUE_DATE,
							PROD_COST
						FROM
							GET_COST_FOR_ALL
						WHERE
							DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ACTION_DEPARTMENT_ID#"> AND
							DUE_DATE IS NOT NULL
						ORDER BY
							START_DATE DESC,
							RECORD_DATE DESC,
							PRODUCT_COST_ID DESC
					</cfquery>
				<cfelse>
					<cfset GET_COST_FOR_DUE.RECORDCOUNT=0>
					<cfset GET_COST_FOR_DUE_LOCATION.RECORDCOUNT=0>
				</cfif>
				<cfquery name="GET_COST_FOR_PHYSICAL" dbtype="query">
					SELECT 
						PHYSICAL_DATE COST_PHYSICAL_DATE,
						PROD_COST
					FROM
						GET_COST_FOR_ALL
					WHERE
						PHYSICAL_DATE IS NOT NULL
					ORDER BY
						START_DATE DESC,
						RECORD_DATE DESC,
						PRODUCT_COST_ID DESC
				</cfquery>
				<cfquery name="GET_COST_FOR_PHYSICAL_LOCATION" dbtype="query">
					SELECT 
						PHYSICAL_DATE_LOCATION COST_PHYSICAL_DATE,
						PROD_COST
					FROM
						GET_COST_FOR_ALL
					WHERE
						DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ACTION_DEPARTMENT_ID#"> AND
						LOCATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ACTION_LOCATION_ID#"> AND
						PHYSICAL_DATE IS NOT NULL
					ORDER BY
						START_DATE DESC,
						RECORD_DATE DESC,
						PRODUCT_COST_ID DESC
				</cfquery>
                <cfquery name="GET_COST_FOR_PHYSICAL_DEPARTMENT" dbtype="query">
					SELECT 
						PHYSICAL_DATE_DEPARTMENT COST_PHYSICAL_DATE,
						PROD_COST
					FROM
						GET_COST_FOR_ALL
					WHERE
						DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ACTION_DEPARTMENT_ID#"> AND
						PHYSICAL_DATE IS NOT NULL
					ORDER BY
						START_DATE DESC,
						RECORD_DATE DESC,
						PRODUCT_COST_ID DESC
				</cfquery>
				<cfscript>
				if((GET_PROCESS_CAT.PROCESS_TYPE eq 59 and isdefined('DUE_DATE') and isdefined('INVOICE_DATE')) or (GET_PROCESS_CAT.PROCESS_TYPE eq 114) and isdefined('RESERVE_DATE') and len(RESERVE_DATE))
				{//finansal yaş için sadece bu alanlar geliyorsa girsin
					if(GET_COST_FOR_DUE.RECORDCOUNT and isdate(GET_COST_FOR_DUE.COST_DUE_DATE))
						due=dateformat(GET_COST_FOR_DUE.COST_DUE_DATE,dateformat_style);
					else
						due=dateformat(ACTION_DATE,dateformat_style);
					
					if(GET_PROCESS_CAT.PROCESS_TYPE eq 59)
					{
						due=dateformat(INVOICE_DATE,dateformat_style);
						act_date=dateformat(INVOICE_DATE,dateformat_style);
						due_date_count = DUE_DATE;
					}
					else if(GET_PROCESS_CAT.PROCESS_TYPE eq 114)//stok fişi ise
					{
						if(isdefined('RESERVE_DATE'))
							act_date=dateformat(RESERVE_DATE,dateformat_style);
						else
							act_date=dateformat(ACTION_DATE,dateformat_style);
						due_date_count = datediff('d',dateformat(RESERVE_DATE,dateformat_style),act_date);
					}
					due_date_=
						duedate_action(
							duedate: due,
							stock_amount:mevcut_son_alislar-AMOUNT,
							stock_value:iif(GET_COST_FOR_DUE.RECORDCOUNT,GET_COST_FOR_DUE.PROD_COST,0),
							action_date:act_date,
							action_duedate:due_date_count,
							action_amount:AMOUNT,
							action_value:satir_fiyat_tutar
						);
					if(GET_COST_FOR_DUE_LOCATION.RECORDCOUNT and isdate(GET_COST_FOR_DUE_LOCATION.COST_DUE_DATE))
						due_location=dateformat(GET_COST_FOR_DUE_LOCATION.COST_DUE_DATE,dateformat_style);
					if(GET_PROCESS_CAT.PROCESS_TYPE eq 59)
						due_location=dateformat(INVOICE_DATE,dateformat_style);
					else if(GET_PROCESS_CAT.PROCESS_TYPE eq 114)//stok fişi ise
						due_location=dateformat(ACTION_DATE,dateformat_style);
					
					due_date_location=
						duedate_action(
							duedate: due_location,
							stock_amount:mevcut_son_alislar_lokasyon-AMOUNT,
							stock_value:iif(GET_COST_FOR_DUE_LOCATION.RECORDCOUNT,GET_COST_FOR_DUE_LOCATION.PROD_COST,0),
							action_date:act_date,
							action_duedate:due_date_count,
							action_amount:AMOUNT,
							action_value:satir_fiyat_tutar
						);
						
					if(GET_COST_FOR_DUE_DEPARTMENT.RECORDCOUNT and isdate(GET_COST_FOR_DUE_DEPARTMENT.COST_DUE_DATE))
						due_department=dateformat(GET_COST_FOR_DUE_DEPARTMENT.COST_DUE_DATE,dateformat_style);
					if(GET_PROCESS_CAT.PROCESS_TYPE eq 59)
						due_department=dateformat(INVOICE_DATE,dateformat_style);
					else if(GET_PROCESS_CAT.PROCESS_TYPE eq 114)//stok fişi ise
						due_department=dateformat(ACTION_DATE,dateformat_style);
						
					due_date_department=
						duedate_action(
							duedate: due_department,
							stock_amount:mevcut_son_alislar_department-AMOUNT,
							stock_value:iif(GET_COST_FOR_DUE_DEPARTMENT.RECORDCOUNT,GET_COST_FOR_DUE_DEPARTMENT.PROD_COST,0),
							action_date:act_date,
							action_duedate:due_date_count,
							action_amount:AMOUNT,
							action_value:satir_fiyat_tutar
						);
				}
				//fiziksel yaş
				if(GET_PROCESS_CAT.PROCESS_TYPE eq 114)//stok devir fişinden geliyor ise vade tarihi fiziksel yaş olduğundan eksi olarak işlem görecek
					act_date=dateformat(date_add('d',(-1*DUE_DATE),ACTION_DATE),dateformat_style);
				else
					act_date=dateformat(ACTION_DATE,dateformat_style);
				if(not listfind('81,113',GET_PROCESS_CAT.PROCESS_TYPE))
				{
					if(GET_COST_FOR_PHYSICAL.RECORDCOUNT and isdate(GET_COST_FOR_PHYSICAL.COST_PHYSICAL_DATE))
						physical_=dateformat(GET_COST_FOR_PHYSICAL.COST_PHYSICAL_DATE,dateformat_style);
					else
						physical_=act_date;
	
					physical_date_ =
								physical_action(
									physicaldate: physical_,
									stock_amount:mevcut_son_alislar-AMOUNT,
									action_date:act_date,
									action_amount:AMOUNT
								);
				}else{
					if(GET_COST_FOR_PHYSICAL.RECORDCOUNT and isdate(GET_COST_FOR_PHYSICAL.COST_PHYSICAL_DATE))
						physical_date_=CreateODBCDateTime(GET_COST_FOR_PHYSICAL.COST_PHYSICAL_DATE);
					else
						physical_date_=CreateODBCDateTime(act_date);
				}
				
				if(GET_COST_FOR_PHYSICAL_LOCATION.RECORDCOUNT and isdate(GET_COST_FOR_PHYSICAL_LOCATION.COST_PHYSICAL_DATE))
					physical_location=dateformat(GET_COST_FOR_PHYSICAL_LOCATION.COST_PHYSICAL_DATE,dateformat_style);
				else
					physical_location=dateformat(ACTION_DATE,dateformat_style);
				physical_date_location =
							physical_action(
								physicaldate: physical_location,
								stock_amount:mevcut_son_alislar_lokasyon-AMOUNT,
								action_date:act_date,
								action_amount:AMOUNT
							);
							
				if(GET_COST_FOR_PHYSICAL_DEPARTMENT.RECORDCOUNT and isdate(GET_COST_FOR_PHYSICAL_DEPARTMENT.COST_PHYSICAL_DATE))
					physical_department=dateformat(GET_COST_FOR_PHYSICAL_DEPARTMENT.COST_PHYSICAL_DATE,dateformat_style);
				else
					physical_department=dateformat(ACTION_DATE,dateformat_style);
				physical_date_department =
							physical_action(
								physicaldate: physical_department,
								stock_amount:mevcut_son_alislar_department-AMOUNT,
								action_date:act_date,
								action_amount:AMOUNT
							);
				</cfscript>
				<cfif paper_query_type eq 1>
					<cflock name="#CREATEUUID()#" timeout="20">
						<cftransaction>
							<cfset purchase_net_all = 0>
							<cfset purchase_net_all_location = 0>
							<cfif alis_net_fiyat neq 0>
								<cfset rate_other = wrk_round(alis_net_fiyat_system/alis_net_fiyat,8)>
							<cfelse>
								<cfset rate_other =1>
							</cfif>
							<cfif isdefined("rate_list")>
								<cfset rate_price = listgetat(rate_list,listfind(rate_list,wrk_eval("prc_protec_money_#PRODUCT_ID#_#cost_spect_id#"),';')-1,';')>
							<cfelse>
								<cfset rate_price = 1>
							</cfif>
							<cfif alis_net_fiyat_system_2 neq 0>
								<cfset rate_2 = wrk_round(alis_net_fiyat_system/alis_net_fiyat_system_2,8)>
							<cfelse>
								<cfset rate_2 =1>
							</cfif>
                            <cfstoredproc procedure="ADD_COST_1" datasource="#FORM.DSN1#">		
                                <cfprocparam  cfsqltype="cf_sql_integer" value="#PRODUCT_ID#">
                                <cfprocparam cfsqltype="cf_sql_integer" value="#GET_COMPS_PER.INVENTORY_CALC_TYPE#">
                                <cfprocparam cfsqltype="cf_sql_float"  value="#wrk_round(alis_net_fiyat,8,1)+wrk_round(alis_ek_maliyet,8,1)#">
                                <cfprocparam cfsqltype="cf_sql_varchar" value="#reference_money#">
                                <cfprocparam cfsqltype="cf_sql_float" value="0">
                                <cfprocparam cfsqltype="cf_sql_varchar" value="#reference_money#">
                                <cfif len(alis_net_fiyat)>
                                    <cfprocparam cfsqltype="cf_sql_float" value="#alis_net_fiyat#">
                                <cfelse>
                                    <cfprocparam cfsqltype="cf_sql_float" value="0">
                                </cfif>
                                <cfif len(mevcut_son_alislar)>
                                    <cfprocparam cfsqltype="cf_sql_float"  value="#mevcut_son_alislar#">
                                <cfelse>
                                    <cfprocparam cfsqltype="cf_sql_float" value="0">
                                </cfif>
                                <cfprocparam cfsqltype="cf_sql_float" value="0">
                                <cfprocparam cfsqltype="cf_sql_varchar" value="NULL">
                                <cfprocparam cfsqltype="cf_sql_bit" value="0">
                                <cfprocparam cfsqltype="cf_sql_bit" value="0">
                                <cfprocparam cfsqltype="cf_sql_bit" value="0">
                                <cfprocparam cfsqltype="cf_sql_varchar" value="#reference_money#">
                                <cfif len(alis_ek_maliyet)>
                                    <cfprocparam cfsqltype="cf_sql_float" value="#wrk_round(alis_ek_maliyet,8,1)#">
                                <cfelse>
                                    <cfprocparam cfsqltype="cf_sql_float" value="0">
                                </cfif>
                                <cfprocparam cfsqltype="cf_sql_float" value="0">
                                <cfprocparam cfsqltype="cf_sql_varchar" value="#reference_money#">
                                <cfprocparam cfsqltype="cf_sql_float" value="0">
                                <cfif len(yoldaki_stoklar)>
                                    <cfprocparam value="#yoldaki_stoklar#" cfsqltype="cf_sql_float">
                                <cfelse>
                                    <cfprocparam cfsqltype="cf_sql_float" value="0">
                                </cfif>
                                <cfprocparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(INSERT_DATE)#"><!--- belgenin kayit tarihi maliyet kayit tarihi kabul ediliyor guncellemelerde sira belli olsun ve degismesin diye degistirilmemeli --->
                                <cfprocparam cfsqltype="cf_sql_timestamp" value="#stok_bakma_tarihi#">
                                <cfprocparam cfsqltype="cf_sql_integer" value="#form.session_userid#">
                                <cfprocparam cfsqltype="cf_sql_varchar" value="#cgi.REMOTE_ADDR#">
                                <cfprocparam cfsqltype="cf_sql_integer" value="1"><!---ak #FORM.UNIT_ID# burasi ise yaramiyorsa sonradan alan dahil hepsi kaldirilacak maliyetlerden --->
                                <cfif not GET_NEXT_PRODUCT_COST.RECORDCOUNT>
                                    <cfprocparam cfsqltype="cf_sql_bit" value="1">
                                <cfelse>
                                    <cfprocparam cfsqltype="cf_sql_bit" value="0">
                                </cfif>
                                <cfif len(ACTION_ID)>
                                    <cfprocparam cfsqltype="cf_sql_integer" value="#ACTION_ID#">
                                <cfelse>
                                    <cfprocparam cfsqltype="cf_sql_integer" value="NULL" null="yes">
                                </cfif>
                                <cfif len(ACTION_TYPE)>
                                    <cfprocparam cfsqltype="cf_sql_integer" value="#ACTION_TYPE#">
                                <cfelse>
                                    <cfprocparam cfsqltype="cf_sql_integer" value="NULL">
                                </cfif>
                                <cfprocparam cfsqltype="cf_sql_integer" value="#form.session_period_id#">
                                <cfprocparam cfsqltype="cf_sql_float" value="#AMOUNT#">
                                <cfprocparam cfsqltype="cf_sql_integer" value="#ACTION_ROW_ID#">
                                <cfprocparam cfsqltype="cf_sql_integer" value="#GET_PROCESS_CAT.PROCESS_TYPE#">
                                <cfprocparam cfsqltype="cf_sql_integer" value="#GET_PROCESS_CAT.PROCESS_CAT_ID#">
                                <cfprocparam cfsqltype="cf_sql_float" value="#satir_fiyat_tutar#">
                                <cfprocparam cfsqltype="cf_sql_float" value="#satir_ekstra_tutar#">
                                <cfif len(alis_net_fiyat_system)>
                                    <cfprocparam cfsqltype="cf_sql_float" value="#wrk_round(alis_net_fiyat_system,8)#">
                                <cfelse>
                                    <cfprocparam cfsqltype="cf_sql_float" value="0">
                                </cfif>
                                <cfif len(alis_ek_maliyet_system)>
                                    <cfprocparam cfsqltype="cf_sql_float" value="#wrk_round(alis_ek_maliyet_system,8,1)#">
                                <cfelse>
                                    <cfprocparam cfsqltype="cf_sql_float" value="0">
                                </cfif>
                                <cfprocparam cfsqltype="cf_sql_varchar" value="#alis_net_fiyat_money_system#">
                                <cfif isdefined('SPEC_MAIN_ID') and len(SPEC_MAIN_ID)>
                                    <cfprocparam cfsqltype="cf_sql_bit" value="1">
                                <cfelse>
                                    <cfprocparam cfsqltype="cf_sql_bit" value="0">
                                </cfif>
                                <cfif isdefined('SPEC_MAIN_ID') and len(SPEC_MAIN_ID)>
                                    <cfprocparam cfsqltype="cf_sql_integer" value="#SPEC_MAIN_ID#">
                                <cfelse>
                                    <cfprocparam cfsqltype="cf_sql_integer" value="NULL" null="yes">
                                </cfif>
                                <cfif isdefined('STOCK_ID_') and len(STOCK_ID_)>
                                    <cfprocparam cfsqltype="cf_sql_integer" value="#STOCK_ID_#">
                                <cfelse>
                                    <cfprocparam cfsqltype="cf_sql_integer" value="NULL" null="yes">
                                </cfif>
                                <cfif len(alis_net_fiyat_system_2)>
                                    <cfprocparam cfsqltype="cf_sql_float" value="#alis_net_fiyat_system_2#">
                                <cfelse>
                                    <cfprocparam cfsqltype="cf_sql_float" value="0">
                                </cfif>
                                <cfif len(alis_ek_maliyet_system_2)>
                                    <cfprocparam cfsqltype="cf_sql_float" value="#wrk_round(alis_ek_maliyet_system_2,8,1)#">
                                <cfelse>
                                    <cfprocparam cfsqltype="cf_sql_float" value="0">
                                </cfif>
                                <cfprocparam cfsqltype="cf_sql_varchar" value="#alis_net_fiyat_money_system_2#">
                                
                                <cfprocparam cfsqltype="cf_sql_integer" value="#ACTION_DEPARTMENT_ID#">
                                <cfprocparam cfsqltype="cf_sql_integer" value="#ACTION_LOCATION_ID#">
                                <cfif len(mevcut_son_alislar_lokasyon)>
                                    <cfprocparam cfsqltype="cf_sql_float" value="#mevcut_son_alislar_lokasyon#">
                                <cfelse>
                                    <cfprocparam cfsqltype="cf_sql_float" value="0">
                                </cfif>
                                <cfprocparam cfsqltype="cf_sql_float" value="0">
                                <cfprocparam cfsqltype="cf_sql_float" value="0"><!--- lokasyon yoldaki stok ? --->
                                <cfprocparam cfsqltype="cf_sql_float" value="#wrk_round(alis_net_fiyat_lokasyon,8)+wrk_round(alis_ek_maliyet_lokasyon,8,1)#">
                                <cfprocparam cfsqltype="cf_sql_varchar" value="#reference_money#">
                                <cfprocparam cfsqltype="cf_sql_float" value="0">
                                <cfprocparam cfsqltype="cf_sql_varchar" value="#reference_money#">
                                <cfprocparam cfsqltype="cf_sql_float" value="0">
                                <cfif len(alis_net_fiyat_lokasyon)>
                                    <cfprocparam cfsqltype="cf_sql_float" value="#alis_net_fiyat_lokasyon#">
                                <cfelse>
                                    <cfprocparam cfsqltype="cf_sql_float" value="0"> 
                                </cfif>
                                <cfprocparam cfsqltype="cf_sql_varchar" value="#reference_money#">
                                <cfif len(alis_ek_maliyet_lokasyon)>
                                    <cfprocparam cfsqltype="cf_sql_float" value="#wrk_round(alis_ek_maliyet_lokasyon,8,1)#">
                                <cfelse>
                                    <cfprocparam cfsqltype="cf_sql_float" value="0">
                                </cfif>
                                <cfprocparam cfsqltype="cf_sql_float" value="0">
                                <cfprocparam cfsqltype="cf_sql_varchar" value="#reference_money#">
                                <cfif len(alis_net_fiyat_system_lokasyon)>
                                    <cfprocparam cfsqltype="cf_sql_float" value="#alis_net_fiyat_system_lokasyon#">
                                <cfelse>
                                    <cfprocparam cfsqltype="cf_sql_float" value="0">
                                </cfif>
                                <cfprocparam cfsqltype="cf_sql_varchar" value="#alis_net_fiyat_money_system#">
                                <cfif len(alis_ek_maliyet_system_lokasyon)>
                                    <cfprocparam cfsqltype="cf_sql_float" value="#wrk_round(alis_ek_maliyet_system_lokasyon,8,1)#">
                                <cfelse>
                                    <cfprocparam cfsqltype="cf_sql_float" value="0">
                                </cfif>
                                <cfif len(alis_net_fiyat_system_2_lokasyon)>
                                    <cfprocparam cfsqltype="cf_sql_float" value="#alis_net_fiyat_system_2_lokasyon#">
                                <cfelse>
                                    <cfprocparam cfsqltype="cf_sql_float" value="0">
                                </cfif>
                                <cfprocparam cfsqltype="cf_sql_varchar" value="#alis_net_fiyat_money_system_2#">
                                <cfif len(alis_ek_maliyet_system_2_lokasyon)>
                                    <cfprocparam cfsqltype="cf_sql_float" value="#wrk_round(alis_ek_maliyet_system_2_lokasyon,8,1)#">
                                <cfelse>
                                    <cfprocparam cfsqltype="cf_sql_float" value="0">
                                 </cfif>
                                 
                                 <cfif len(mevcut_son_alislar_department)>
                                    <cfprocparam cfsqltype="cf_sql_float" value="#mevcut_son_alislar_department#">
                                <cfelse>
                                    <cfprocparam cfsqltype="cf_sql_float" value="0">
                                </cfif>
                                <cfprocparam cfsqltype="cf_sql_float" value="0">
                                <cfprocparam cfsqltype="cf_sql_float" value="0">
                                <cfprocparam cfsqltype="cf_sql_float" value="#wrk_round(alis_net_fiyat_department,8)+wrk_round(alis_ek_maliyet_department,8,1)#">
                                <cfprocparam cfsqltype="cf_sql_varchar" value="#reference_money#">
                                <cfprocparam cfsqltype="cf_sql_float" value="0">
                                <cfprocparam cfsqltype="cf_sql_varchar" value="#reference_money#">
                                <cfprocparam cfsqltype="cf_sql_float" value="0">
                                <cfif len(alis_net_fiyat_department)>
                                    <cfprocparam cfsqltype="cf_sql_float" value="#alis_net_fiyat_department#">
                                <cfelse>
                                    <cfprocparam cfsqltype="cf_sql_float" value="0"> 
                                </cfif>
                                <cfprocparam cfsqltype="cf_sql_varchar" value="#reference_money#">
                                <cfif len(alis_ek_maliyet_department)>
                                    <cfprocparam cfsqltype="cf_sql_float" value="#wrk_round(alis_ek_maliyet_department,8,1)#">
                                <cfelse>
                                    <cfprocparam cfsqltype="cf_sql_float" value="0">
                                </cfif>
                                <cfprocparam cfsqltype="cf_sql_float" value="0">
                                <cfprocparam cfsqltype="cf_sql_varchar" value="#reference_money#">
                                <cfif len(alis_net_fiyat_system_department)>
                                    <cfprocparam cfsqltype="cf_sql_float" value="#alis_net_fiyat_system_department#">
                                <cfelse>
                                    <cfprocparam cfsqltype="cf_sql_float" value="0">
                                </cfif>
                                <cfprocparam cfsqltype="cf_sql_varchar" value="#alis_net_fiyat_money_system#">
                                <cfif len(alis_ek_maliyet_system_department)>
                                    <cfprocparam cfsqltype="cf_sql_float" value="#wrk_round(alis_ek_maliyet_system_department,8,1)#">
                                <cfelse>
                                    <cfprocparam cfsqltype="cf_sql_float" value="0">
                                </cfif>
                                <cfif len(alis_net_fiyat_system_2_department)>
                                    <cfprocparam cfsqltype="cf_sql_float" value="#alis_net_fiyat_system_2_department#">
                                <cfelse>
                                    <cfprocparam cfsqltype="cf_sql_float" value="0">
                                </cfif>
                                <cfprocparam cfsqltype="cf_sql_varchar" value="#alis_net_fiyat_money_system_2#">
                                <cfif len(alis_ek_maliyet_system_2_department)>
                                    <cfprocparam cfsqltype="cf_sql_float" value="#wrk_round(alis_ek_maliyet_system_2_department,8,1)#">
                                <cfelse>
                                    <cfprocparam cfsqltype="cf_sql_float" value="0">
                                 </cfif>
                                <cfif isdefined('due_date_') and isdate(due_date_)>
                                    <cfprocparam cfsqltype="cf_sql_timestamp" value="#due_date_#">
                                <cfelse>
                                    <cfprocparam cfsqltype="cf_sql_timestamp" value="NULL" null="yes">
                                </cfif>,
                                <cfif isdefined('due_date_location') and isdate(due_date_location)>
                                    <cfprocparam cfsqltype="cf_sql_timestamp" value="#due_date_location#">
                                 <cfelse>
                                    <cfprocparam cfsqltype="cf_sql_timestamp" value="NULL" null="yes">
                                 </cfif>
                                 <cfif isdefined('due_date_department') and isdate(due_date_department)>
                                    <cfprocparam cfsqltype="cf_sql_timestamp" value="#due_date_department#">
                                 <cfelse>
                                    <cfprocparam cfsqltype="cf_sql_timestamp" value="NULL" null="yes">
                                 </cfif>
                                <cfif isdefined('physical_date_') and isdate(physical_date_)>
                                    <cfprocparam cfsqltype="cf_sql_timestamp" value="#physical_date_#">
                                <cfelse>
                                    <cfprocparam cfsqltype="cf_sql_timestamp" value="NULL" null="yes">
                                </cfif>,
                                <cfif isdefined('physical_date_location') and isdate(physical_date_location)>
                                    <cfprocparam cfsqltype="cf_sql_timestamp" value="#physical_date_location#">
                                <cfelse>
                                    <cfprocparam cfsqltype="cf_sql_timestamp" value="NULL" null="yes">
                                </cfif>
                                <cfif isdefined('physical_date_department') and isdate(physical_date_department)>
                                    <cfprocparam cfsqltype="cf_sql_timestamp" value="#physical_date_department#">
                                <cfelse>
                                    <cfprocparam cfsqltype="cf_sql_timestamp" value="NULL" null="yes">
                                </cfif>
                                <cfif len(PAPER_DATE)>
                                    <cfprocparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(PAPER_DATE)#">
                                <cfelse>
                                    <cfprocparam cfsqltype="cf_sql_timestamp" value="NULL" null="yes">
                                </cfif>
                                <cfif isdefined('DUE_DATE') and len(DUE_DATE)>
                                    <cfprocparam cfsqltype="cf_sql_integer" value="#DUE_DATE#">
                               <cfelse>
                                    <cfprocparam cfsqltype="cf_sql_integer" value="0">
                               </cfif>
								<cfif len(alis_reflection)>
									<cfprocparam cfsqltype="cf_sql_float" value="#wrk_round(alis_reflection,8,1)#">
								<cfelse>
									<cfprocparam cfsqltype="cf_sql_float" value="0">
								</cfif>
								<cfif len(alis_reflection_system)>
									<cfprocparam cfsqltype="cf_sql_float" value="#wrk_round(alis_reflection_system,8,1)#">
								<cfelse>
									<cfprocparam cfsqltype="cf_sql_float" value="0">
								</cfif>
								<cfif len(alis_reflection_system_2)>
									<cfprocparam cfsqltype="cf_sql_float" value="#wrk_round(alis_reflection_system_2,8,1)#">
								<cfelse>
									<cfprocparam cfsqltype="cf_sql_float" value="0">
								</cfif>
								<cfif len(alis_reflection_lokasyon)>
									<cfprocparam cfsqltype="cf_sql_float" value="#wrk_round(alis_reflection_lokasyon,8,1)#">
								<cfelse>
									<cfprocparam cfsqltype="cf_sql_float" value="0">
								</cfif>
								<cfif len(alis_reflection_system_lokasyon)>
									<cfprocparam cfsqltype="cf_sql_float" value="#wrk_round(alis_reflection_system_lokasyon,8,1)#">
								<cfelse>
									<cfprocparam cfsqltype="cf_sql_float" value="0">
								</cfif>
								<cfif len(alis_reflection_system_2_lokasyon)>
									<cfprocparam cfsqltype="cf_sql_float" value="#wrk_round(alis_reflection_system_2_lokasyon,8,1)#">
								<cfelse>
									<cfprocparam cfsqltype="cf_sql_float" value="0">
								</cfif>
								<cfif len(alis_reflection_department)>
									<cfprocparam cfsqltype="cf_sql_float" value="#wrk_round(alis_reflection_department,8,1)#">
								<cfelse>
									<cfprocparam cfsqltype="cf_sql_float" value="0">
								</cfif>
								<cfif len(alis_reflection_system_department)>
									<cfprocparam cfsqltype="cf_sql_float" value="#wrk_round(alis_reflection_system_department,8,1)#">
								<cfelse>
									<cfprocparam cfsqltype="cf_sql_float" value="0">
								</cfif>
								<cfif len(alis_reflection_system_2_department)>
									<cfprocparam cfsqltype="cf_sql_float" value="#wrk_round(alis_reflection_system_2_department,8,1)#">
								<cfelse>
									<cfprocparam cfsqltype="cf_sql_float" value="0">
								</cfif>
								<cfif len(alis_labor)>
									<cfprocparam cfsqltype="cf_sql_float" value="#wrk_round(alis_labor,8,1)#">
								<cfelse>
									<cfprocparam cfsqltype="cf_sql_float" value="0">
								</cfif>
								<cfif len(alis_labor_system)>
									<cfprocparam cfsqltype="cf_sql_float" value="#wrk_round(alis_labor_system,8,1)#">
								<cfelse>
									<cfprocparam cfsqltype="cf_sql_float" value="0">
								</cfif>
								<cfif len(alis_labor_system_2)>
									<cfprocparam cfsqltype="cf_sql_float" value="#wrk_round(alis_labor_system_2,8,1)#">
								<cfelse>
									<cfprocparam cfsqltype="cf_sql_float" value="0">
								</cfif>
								<cfif len(alis_labor_lokasyon)>
									<cfprocparam cfsqltype="cf_sql_float" value="#wrk_round(alis_labor_lokasyon,8,1)#">
								<cfelse>
									<cfprocparam cfsqltype="cf_sql_float" value="0">
								</cfif>
								<cfif len(alis_labor_system_lokasyon)>
									<cfprocparam cfsqltype="cf_sql_float" value="#wrk_round(alis_labor_system_lokasyon,8,1)#">
								<cfelse>
									<cfprocparam cfsqltype="cf_sql_float" value="0">
								</cfif>
								<cfif len(alis_labor_system_2_lokasyon)>
									<cfprocparam cfsqltype="cf_sql_float" value="#wrk_round(alis_labor_system_2_lokasyon,8,1)#">
								<cfelse>
									<cfprocparam cfsqltype="cf_sql_float" value="0">
								</cfif>
								<cfif len(alis_labor_department)>
									<cfprocparam cfsqltype="cf_sql_float" value="#wrk_round(alis_labor_department,8,1)#">
								<cfelse>
									<cfprocparam cfsqltype="cf_sql_float" value="0">
								</cfif>
								<cfif len(alis_labor_system_department)>
									<cfprocparam cfsqltype="cf_sql_float" value="#wrk_round(alis_labor_system_department,8,1)#">
								<cfelse>
									<cfprocparam cfsqltype="cf_sql_float" value="0">
								</cfif>
								<cfif len(alis_labor_system_2_department)>
									<cfprocparam cfsqltype="cf_sql_float" value="#wrk_round(alis_labor_system_2_department,8,1)#">
								<cfelse>
									<cfprocparam cfsqltype="cf_sql_float" value="0">
								</cfif>
							</cfstoredproc> 
                            <cfquery datasource="#FORM.DSN1#" name="GET_P_COST_ID">
								SELECT
									MAX(PRODUCT_COST_ID) AS MAX_ID 
								FROM 
									PRODUCT_COST 
								WHERE 
									PRODUCT_ID = <cfqueryparam value="#PRODUCT_ID#" cfsqltype="cf_sql_integer">
									<cfif isdefined('SPEC_MAIN_ID') and len(SPEC_MAIN_ID)>
										AND SPECT_MAIN_ID = <cfqueryparam value="#SPEC_MAIN_ID#" cfsqltype="cf_sql_integer">
									<cfelseif is_prod_cost_type eq 0>
										AND IS_SPEC=0
									</cfif>
									<cfif isdefined("STOCK_ID_") and len(STOCK_ID_)>
										AND STOCK_ID = <cfqueryparam value="#STOCK_ID_#" cfsqltype="cf_sql_integer"> 
									<cfelseif is_stock_based_cost eq 0>
										AND STOCK_ID IS NULL
									</cfif>
									AND ACTION_PERIOD_ID = <cfqueryparam value="#form.session_period_id#" cfsqltype="cf_sql_integer">
							</cfquery>
							<cfquery name="upd_cost" datasource="#dsn1#">
								UPDATE
									PRODUCT_COST
								SET
									PURCHASE_NET_ALL = PURCHASE_NET + (PRICE_PROTECTION*-1*ISNULL(PRICE_PROTECTION_TYPE,0)*#rate_price#/#rate_other#),
									PURCHASE_NET_SYSTEM_ALL = (PURCHASE_NET + (PRICE_PROTECTION*-1*ISNULL(PRICE_PROTECTION_TYPE,0)*#rate_price#/#rate_other#))*#rate_other#,
									PURCHASE_NET_SYSTEM_2_ALL = (PURCHASE_NET + (PRICE_PROTECTION*-1*ISNULL(PRICE_PROTECTION_TYPE,0)*#rate_price#/#rate_other#))*(#rate_other#/#rate_2#),
									PURCHASE_NET_LOCATION_ALL = PURCHASE_NET_LOCATION + (PRICE_PROTECTION*-1*ISNULL(PRICE_PROTECTION_TYPE,0)*#rate_price#/#rate_other#),
									PURCHASE_NET_SYSTEM_LOCATION_ALL = (PURCHASE_NET_LOCATION + (PRICE_PROTECTION*-1*ISNULL(PRICE_PROTECTION_TYPE,0)*#rate_price#/#rate_other#))*#rate_other#,
									PURCHASE_NET_SYSTEM_2_LOCATION_ALL = (PURCHASE_NET_LOCATION + (PRICE_PROTECTION*-1*ISNULL(PRICE_PROTECTION_TYPE,0)*#rate_price#/#rate_other#))*(#rate_other#/#rate_2#),
                                    PURCHASE_NET_DEPARTMENT_ALL = PURCHASE_NET_DEPARTMENT + (PRICE_PROTECTION*-1*ISNULL(PRICE_PROTECTION_TYPE,0)*#rate_price#/#rate_other#),
									PURCHASE_NET_SYSTEM_DEPARTMENT_ALL = (PURCHASE_NET_DEPARTMENT + (PRICE_PROTECTION*-1*ISNULL(PRICE_PROTECTION_TYPE,0)*#rate_price#/#rate_other#))*#rate_other#,
									PURCHASE_NET_SYSTEM_2_DEPARTMENT_ALL = (PURCHASE_NET_DEPARTMENT + (PRICE_PROTECTION*-1*ISNULL(PRICE_PROTECTION_TYPE,0)*#rate_price#/#rate_other#))*(#rate_other#/#rate_2#)
								WHERE
									PRODUCT_COST_ID = #GET_P_COST_ID.MAX_ID#
							</cfquery>
						</cftransaction>
					</cflock>
				<cfelseif paper_query_type eq 2>
					<cfscript>
						if(isdefined('SPEC_MAIN_ID') and len(SPEC_MAIN_ID)) cost_spect_id=SPEC_MAIN_ID; else cost_spect_id="";
						if(not isdefined('prc_protec_sys_#PRODUCT_ID#_#cost_spect_id#') or not len(evaluate('prc_protec_sys_#PRODUCT_ID#_#cost_spect_id#'))) 'prc_protec_sys_#PRODUCT_ID#_#cost_spect_id#'=0;
						if(not isdefined('prc_protec_sys_2_#PRODUCT_ID#_#cost_spect_id#') or not len(evaluate('prc_protec_sys_2_#PRODUCT_ID#_#cost_spect_id#'))) 'prc_protec_sys_2_#PRODUCT_ID#_#cost_spect_id#'=0;
						if(not isdefined('prc_protec_#PRODUCT_ID#_#cost_spect_id#') or not len(evaluate('prc_protec_#PRODUCT_ID#_#cost_spect_id#'))) 'prc_protec_#PRODUCT_ID#_#cost_spect_id#' = 0;
						if(not isdefined('prc_protec_org_#PRODUCT_ID#_#cost_spect_id#') or not len(evaluate('prc_protec_org_#PRODUCT_ID#_#cost_spect_id#'))) 'prc_protec_org_#PRODUCT_ID#_#cost_spect_id#' = 0;
						if(not isdefined('prc_protec_money_#PRODUCT_ID#_#cost_spect_id#') or not len(evaluate('prc_protec_money_#PRODUCT_ID#_#cost_spect_id#'))) 'prc_protec_money_#PRODUCT_ID#_#cost_spect_id#' = reference_money;
						if(not isdefined('prc_protec_type_#PRODUCT_ID#_#cost_spect_id#') or not len(evaluate('prc_protec_type_#PRODUCT_ID#_#cost_spect_id#'))) 'prc_protec_type_#PRODUCT_ID#_#cost_spect_id#' = 1;
						if(not isdefined('prc_protec_cost_type_#PRODUCT_ID#_#cost_spect_id#') or not len(evaluate('prc_protec_cost_type_#PRODUCT_ID#_#cost_spect_id#'))) 'prc_protec_cost_type_#PRODUCT_ID#_#cost_spect_id#' = '';
						if(not isdefined('prc_protec_amount_#PRODUCT_ID#_#cost_spect_id#') or not len(evaluate('prc_protec_amount_#PRODUCT_ID#_#cost_spect_id#'))) 'prc_protec_amount_#PRODUCT_ID#_#cost_spect_id#' = 1;
						if(not isdefined('prc_protec_total_#PRODUCT_ID#_#cost_spect_id#') or not len(evaluate('prc_protec_total_#PRODUCT_ID#_#cost_spect_id#'))) 'prc_protec_total_#PRODUCT_ID#_#cost_spect_id#' = evaluate('prc_protec_amount_#PRODUCT_ID#_#cost_spect_id#')*evaluate('prc_protec_org_#PRODUCT_ID#_#cost_spect_id#');
		
						if(not isdefined('std_cost_org_#PRODUCT_ID#_#cost_spect_id#') or not len(evaluate('std_cost_org_#PRODUCT_ID#_#cost_spect_id#'))) 'std_cost_org_#PRODUCT_ID#_#cost_spect_id#' = 0;
						if(not isdefined('std_cost_sys_#PRODUCT_ID#_#cost_spect_id#') or not len(evaluate('std_cost_sys_#PRODUCT_ID#_#cost_spect_id#'))) 'std_cost_sys_#PRODUCT_ID#_#cost_spect_id#' = 0;
						if(not isdefined('std_cost_sys_2_#PRODUCT_ID#_#cost_spect_id#') or not len(evaluate('std_cost_sys_2_#PRODUCT_ID#_#cost_spect_id#'))) 'std_cost_sys_2_#PRODUCT_ID#_#cost_spect_id#' = 0;
						if(not isdefined('std_cost_#PRODUCT_ID#_#cost_spect_id#') or not len(evaluate('std_cost_#PRODUCT_ID#_#cost_spect_id#'))) 'std_cost_#PRODUCT_ID#_#cost_spect_id#' = 0;
						if((not isdefined('std_cost_money_#PRODUCT_ID#_#cost_spect_id#') or not len(evaluate('std_cost_money_#PRODUCT_ID#_#cost_spect_id#'))) and year(createodbcdate(ACTION_DATE)) lt 2009) 'std_cost_money_#PRODUCT_ID#_#cost_spect_id#' = 'YTL';
						if((not isdefined('std_cost_money_#PRODUCT_ID#_#cost_spect_id#') or not len(evaluate('std_cost_money_#PRODUCT_ID#_#cost_spect_id#'))) and year(createodbcdate(ACTION_DATE)) gt 2008) 'std_cost_money_#PRODUCT_ID#_#cost_spect_id#' = 'TL';
						if(not isdefined('std_cost_rate_#PRODUCT_ID#_#cost_spect_id#') or not len(evaluate('std_cost_rate_#PRODUCT_ID#_#cost_spect_id#'))) 'std_cost_rate_#PRODUCT_ID#_#cost_spect_id#' = 0;
						//LOKASYON
						if(not isdefined('prc_protec_sys_loc_#PRODUCT_ID#_#cost_spect_id#') or not len(evaluate('prc_protec_sys_loc_#PRODUCT_ID#_#cost_spect_id#'))) 'prc_protec_sys_loc_#PRODUCT_ID#_#cost_spect_id#'=0;
						if(not isdefined('prc_protec_sys_2_loc_#PRODUCT_ID#_#cost_spect_id#') or not len(evaluate('prc_protec_sys_2_loc_#PRODUCT_ID#_#cost_spect_id#'))) 'prc_protec_sys_2_loc_#PRODUCT_ID#_#cost_spect_id#'=0;
						if(not isdefined('prc_protec_loc_#PRODUCT_ID#_#cost_spect_id#') or not len(evaluate('prc_protec_loc_#PRODUCT_ID#_#cost_spect_id#'))) 'prc_protec_loc_#PRODUCT_ID#_#cost_spect_id#' = 0;
						if(not isdefined('prc_protec_org_loc_#PRODUCT_ID#_#cost_spect_id#') or not len(evaluate('prc_protec_org_loc_#PRODUCT_ID#_#cost_spect_id#'))) 'prc_protec_org_loc_#PRODUCT_ID#_#cost_spect_id#' = 0;
						if(not isdefined('prc_protec_money_loc_#PRODUCT_ID#_#cost_spect_id#') or not len(evaluate('prc_protec_money_loc_#PRODUCT_ID#_#cost_spect_id#'))) 'prc_protec_money_loc_#PRODUCT_ID#_#cost_spect_id#' = reference_money;
						
						if(not isdefined('std_cost_org_loc_#PRODUCT_ID#_#cost_spect_id#') or not len(evaluate('std_cost_org_loc_#PRODUCT_ID#_#cost_spect_id#'))) 'std_cost_org_loc_#PRODUCT_ID#_#cost_spect_id#' = 0;
						if(not isdefined('std_cost_sys_loc_#PRODUCT_ID#_#cost_spect_id#') or not len(evaluate('std_cost_sys_loc_#PRODUCT_ID#_#cost_spect_id#'))) 'std_cost_sys_loc_#PRODUCT_ID#_#cost_spect_id#' = 0;
						if(not isdefined('std_cost_sys_2_loc_#PRODUCT_ID#_#cost_spect_id#') or not len(evaluate('std_cost_sys_2_loc_#PRODUCT_ID#_#cost_spect_id#'))) 'std_cost_sys_2_loc_#PRODUCT_ID#_#cost_spect_id#' = 0;
						if(not isdefined('std_cost_loc_#PRODUCT_ID#_#cost_spect_id#') or not len(evaluate('std_cost_loc_#PRODUCT_ID#_#cost_spect_id#'))) 'std_cost_loc_#PRODUCT_ID#_#cost_spect_id#' = 0;
						if((not isdefined('std_cost_money_loc_#PRODUCT_ID#_#cost_spect_id#') or not len(evaluate('std_cost_money_loc_#PRODUCT_ID#_#cost_spect_id#'))) and year(createodbcdate(ACTION_DATE)) lt 2009) 'std_cost_money_loc_#PRODUCT_ID#_#cost_spect_id#' = 'YTL';
						if((not isdefined('std_cost_money_loc_#PRODUCT_ID#_#cost_spect_id#') or not len(evaluate('std_cost_money_loc_#PRODUCT_ID#_#cost_spect_id#'))) and year(createodbcdate(ACTION_DATE)) gt 2008) 'std_cost_money_loc_#PRODUCT_ID#_#cost_spect_id#' = 'TL';
						if(not isdefined('std_cost_rate_loc_#PRODUCT_ID#_#cost_spect_id#') or not len(evaluate('std_cost_rate_loc_#PRODUCT_ID#_#cost_spect_id#'))) 'std_cost_rate_loc_#PRODUCT_ID#_#cost_spect_id#' = 0;
						
						//depo
						if(not isdefined('prc_protec_sys_dep_#PRODUCT_ID#_#cost_spect_id#') or not len(evaluate('prc_protec_sys_dep_#PRODUCT_ID#_#cost_spect_id#'))) 'prc_protec_sys_dep_#PRODUCT_ID#_#cost_spect_id#'=0;
						if(not isdefined('prc_protec_sys_2_dep_#PRODUCT_ID#_#cost_spect_id#') or not len(evaluate('prc_protec_sys_2_dep_#PRODUCT_ID#_#cost_spect_id#'))) 'prc_protec_sys_2_dep_#PRODUCT_ID#_#cost_spect_id#'=0;
						if(not isdefined('prc_protec_dep_#PRODUCT_ID#_#cost_spect_id#') or not len(evaluate('prc_protec_dep_#PRODUCT_ID#_#cost_spect_id#'))) 'prc_protec_dep_#PRODUCT_ID#_#cost_spect_id#' = 0;
						if(not isdefined('prc_protec_org_dep_#PRODUCT_ID#_#cost_spect_id#') or not len(evaluate('prc_protec_org_dep_#PRODUCT_ID#_#cost_spect_id#'))) 'prc_protec_org_dep_#PRODUCT_ID#_#cost_spect_id#' = 0;
						if(not isdefined('prc_protec_money_dep_#PRODUCT_ID#_#cost_spect_id#') or not len(evaluate('prc_protec_money_dep_#PRODUCT_ID#_#cost_spect_id#'))) 'prc_protec_money_dep_#PRODUCT_ID#_#cost_spect_id#' = reference_money;
						
						if(not isdefined('std_cost_org_dep_#PRODUCT_ID#_#cost_spect_id#') or not len(evaluate('std_cost_org_dep_#PRODUCT_ID#_#cost_spect_id#'))) 'std_cost_org_dep_#PRODUCT_ID#_#cost_spect_id#' = 0;
						if(not isdefined('std_cost_sys_dep_#PRODUCT_ID#_#cost_spect_id#') or not len(evaluate('std_cost_sys_dep_#PRODUCT_ID#_#cost_spect_id#'))) 'std_cost_sys_dep_#PRODUCT_ID#_#cost_spect_id#' = 0;
						if(not isdefined('std_cost_sys_2_dep_#PRODUCT_ID#_#cost_spect_id#') or not len(evaluate('std_cost_sys_2_dep_#PRODUCT_ID#_#cost_spect_id#'))) 'std_cost_sys_2_dep_#PRODUCT_ID#_#cost_spect_id#' = 0;
						if(not isdefined('std_cost_dep_#PRODUCT_ID#_#cost_spect_id#') or not len(evaluate('std_cost_dep_#PRODUCT_ID#_#cost_spect_id#'))) 'std_cost_dep_#PRODUCT_ID#_#cost_spect_id#' = 0;
						if((not isdefined('std_cost_money_dep_#PRODUCT_ID#_#cost_spect_id#') or not len(evaluate('std_cost_money_dep_#PRODUCT_ID#_#cost_spect_id#'))) and year(createodbcdate(ACTION_DATE)) lt 2009) 'std_cost_money_dep_#PRODUCT_ID#_#cost_spect_id#' = 'YTL';
						if((not isdefined('std_cost_money_dep_#PRODUCT_ID#_#cost_spect_id#') or not len(evaluate('std_cost_money_dep_#PRODUCT_ID#_#cost_spect_id#'))) and year(createodbcdate(ACTION_DATE)) gt 2008) 'std_cost_money_dep_#PRODUCT_ID#_#cost_spect_id#' = 'TL';
						if(not isdefined('std_cost_rate_dep_#PRODUCT_ID#_#cost_spect_id#') or not len(evaluate('std_cost_rate_dep_#PRODUCT_ID#_#cost_spect_id#'))) 'std_cost_rate_dep_#PRODUCT_ID#_#cost_spect_id#' = 0;
						////writeoutput('<br/> [alis_net_fiyat = #alis_net_fiyat# alis_ek_maliyet ███ #alis_ek_maliyet#] Ürün İçin Yeni Bir Maliyet Oluşturuldu : #alis_net_fiyat + alis_ek_maliyet + evaluate("std_cost_#PRODUCT_ID#_#cost_spect_id#")+ ((alis_net_fiyat*evaluate("std_cost_rate_#PRODUCT_ID#_#cost_spect_id#"))/100)- (evaluate("prc_protec_#PRODUCT_ID#_#cost_spect_id#")*evaluate("prc_protec_type_#PRODUCT_ID#_#cost_spect_id#"))#<br/>');
					</cfscript>
					<cflock name="#CREATEUUID()#" timeout="20">
						<cftransaction>
							<!--- eklerken bu belgeye iliskin eklenen maliyetler bulnur silinir ve o maliyetlerden ilerki tarihte maliyet varsa guncellenir --->
							<cfset purchase_net_all = alis_net_fiyat>
							<cfset purchase_net_all_location = alis_net_fiyat_lokasyon>
                            <cfset purchase_net_all_department = alis_net_fiyat_department>
							<cfset purchase_net_all_2 = alis_net_fiyat_system_2>
							<cfset purchase_net_all_location_2 = alis_net_fiyat_system_2_lokasyon>
                            <cfset purchase_net_all_department_2 = alis_net_fiyat_system_2_department>
							<cfset rate_other = listgetat(rate_list,listfind(rate_list,reference_money,';')-1,';')>
							<cfset rate_2 = listgetat(rate_list,listfind(rate_list,alis_net_fiyat_money_system_2,';')-1,';')>
							<cfif isdefined("rate_list")>
								<cfset rate_price = listgetat(rate_list,listfind(rate_list,wrk_eval("prc_protec_money_#PRODUCT_ID#_#cost_spect_id#"),';')-1,';')>
								<cfif evaluate("prc_protec_type_#PRODUCT_ID#_#cost_spect_id#") eq 1>
									<cfif mevcut_son_alislar neq 0>
										<cfset purchase_net_all = alis_net_fiyat - ((wrk_round(evaluate("prc_protec_org_#PRODUCT_ID#_#cost_spect_id#")*evaluate("prc_protec_amount_#PRODUCT_ID#_#cost_spect_id#")*rate_price/rate_other,8))/mevcut_son_alislar)>
										<cfset purchase_net_all_2 = alis_net_fiyat_system_2 - ((wrk_round(evaluate("prc_protec_org_#PRODUCT_ID#_#cost_spect_id#")*evaluate("prc_protec_amount_#PRODUCT_ID#_#cost_spect_id#")*rate_price/rate_2,8))/mevcut_son_alislar)>
                                    <cfelse>
										<cfset purchase_net_all = alis_net_fiyat - ((wrk_round(evaluate("prc_protec_org_#PRODUCT_ID#_#cost_spect_id#")*evaluate("prc_protec_amount_#PRODUCT_ID#_#cost_spect_id#")*rate_price/rate_other,8)))>
										<cfset purchase_net_all_2 = alis_net_fiyat_system_2 - ((wrk_round(evaluate("prc_protec_org_#PRODUCT_ID#_#cost_spect_id#")*evaluate("prc_protec_amount_#PRODUCT_ID#_#cost_spect_id#")*rate_price/rate_2,8)))>
									</cfif>
									<cfif mevcut_son_alislar_lokasyon neq 0>
										<cfset purchase_net_all_location = alis_net_fiyat_lokasyon - ((wrk_round(evaluate("prc_protec_org_loc_#PRODUCT_ID#_#cost_spect_id#")*evaluate("prc_protec_amount_#PRODUCT_ID#_#cost_spect_id#")*rate_price/rate_other,8))/mevcut_son_alislar_lokasyon)>
										<cfset purchase_net_all_location_2 = alis_net_fiyat_system_2_lokasyon - ((wrk_round(evaluate("prc_protec_org_loc_#PRODUCT_ID#_#cost_spect_id#")*evaluate("prc_protec_amount_#PRODUCT_ID#_#cost_spect_id#")*rate_price/rate_2,8))/mevcut_son_alislar_lokasyon)>
                                    <cfelse>
										<cfset purchase_net_all_location = alis_net_fiyat_lokasyon - ((wrk_round(evaluate("prc_protec_org_loc_#PRODUCT_ID#_#cost_spect_id#")*evaluate("prc_protec_amount_#PRODUCT_ID#_#cost_spect_id#")*rate_price/rate_other,8)))>
										<cfset purchase_net_all_location_2 = alis_net_fiyat_system_2_lokasyon - ((wrk_round(evaluate("prc_protec_org_loc_#PRODUCT_ID#_#cost_spect_id#")*evaluate("prc_protec_amount_#PRODUCT_ID#_#cost_spect_id#")*rate_price/rate_2,8)))>
									</cfif>
									<cfif mevcut_son_alislar_department neq 0>
										<cfset purchase_net_all_department = alis_net_fiyat_department - ((wrk_round(evaluate("prc_protec_org_dep_#PRODUCT_ID#_#cost_spect_id#")*evaluate("prc_protec_amount_#PRODUCT_ID#_#cost_spect_id#")*rate_price/rate_other,8))/mevcut_son_alislar_department)>
										<cfset purchase_net_all_department_2 = alis_net_fiyat_system_2_department - ((wrk_round(evaluate("prc_protec_org_dep_#PRODUCT_ID#_#cost_spect_id#")*evaluate("prc_protec_amount_#PRODUCT_ID#_#cost_spect_id#")*rate_price/rate_2,8))/mevcut_son_alislar_department)>
                                    <cfelse>
										<cfset purchase_net_all_department = alis_net_fiyat_department - ((wrk_round(evaluate("prc_protec_org_dep_#PRODUCT_ID#_#cost_spect_id#")*evaluate("prc_protec_amount_#PRODUCT_ID#_#cost_spect_id#")*rate_price/rate_other,8)))>                                    
										<cfset purchase_net_all_department_2 = alis_net_fiyat_system_2_department - ((wrk_round(evaluate("prc_protec_org_dep_#PRODUCT_ID#_#cost_spect_id#")*evaluate("prc_protec_amount_#PRODUCT_ID#_#cost_spect_id#")*rate_price/rate_2,8)))>
                                    </cfif>
								<cfelse>
									<cfif mevcut_son_alislar neq 0>
										<cfset purchase_net_all = alis_net_fiyat + ((wrk_round(evaluate("prc_protec_org_#PRODUCT_ID#_#cost_spect_id#")*evaluate("prc_protec_amount_#PRODUCT_ID#_#cost_spect_id#")*rate_price/rate_other,8))/mevcut_son_alislar)>
										<cfset purchase_net_all_2 = alis_net_fiyat_system_2 + ((wrk_round(evaluate("prc_protec_org_#PRODUCT_ID#_#cost_spect_id#")*evaluate("prc_protec_amount_#PRODUCT_ID#_#cost_spect_id#")*rate_price/rate_2,8))/mevcut_son_alislar)>
                                    <cfelse>
										<cfset purchase_net_all = alis_net_fiyat + ((wrk_round(evaluate("prc_protec_org_#PRODUCT_ID#_#cost_spect_id#")*evaluate("prc_protec_amount_#PRODUCT_ID#_#cost_spect_id#")*rate_price/rate_other,8)))>
										<cfset purchase_net_all_2 = alis_net_fiyat_system_2 + ((wrk_round(evaluate("prc_protec_org_#PRODUCT_ID#_#cost_spect_id#")*evaluate("prc_protec_amount_#PRODUCT_ID#_#cost_spect_id#")*rate_price/rate_2,8)))>
									</cfif>
									<cfif mevcut_son_alislar_lokasyon neq 0>
										<cfset purchase_net_all_location = alis_net_fiyat_lokasyon + ((wrk_round(evaluate("prc_protec_org_loc_#PRODUCT_ID#_#cost_spect_id#")*evaluate("prc_protec_amount_#PRODUCT_ID#_#cost_spect_id#")*rate_price/rate_other,8))/mevcut_son_alislar_lokasyon)>
										<cfset purchase_net_all_location_2 = alis_net_fiyat_system_2_lokasyon + ((wrk_round(evaluate("prc_protec_org_loc_#PRODUCT_ID#_#cost_spect_id#")*evaluate("prc_protec_amount_#PRODUCT_ID#_#cost_spect_id#")*rate_price/rate_2,8))/mevcut_son_alislar_lokasyon)>
                                    <cfelse>
										<cfset purchase_net_all_location = alis_net_fiyat_lokasyon + ((wrk_round(evaluate("prc_protec_org_loc_#PRODUCT_ID#_#cost_spect_id#")*evaluate("prc_protec_amount_#PRODUCT_ID#_#cost_spect_id#")*rate_price/rate_other,8)))>
										<cfset purchase_net_all_location_2 = alis_net_fiyat_system_2_lokasyon + ((wrk_round(evaluate("prc_protec_org_loc_#PRODUCT_ID#_#cost_spect_id#")*evaluate("prc_protec_amount_#PRODUCT_ID#_#cost_spect_id#")*rate_price/rate_2,8)))>
									</cfif>
									<cfif mevcut_son_alislar_department neq 0>
										<cfset purchase_net_all_department = alis_net_fiyat_department + ((wrk_round(evaluate("prc_protec_org_dep_#PRODUCT_ID#_#cost_spect_id#")*evaluate("prc_protec_amount_#PRODUCT_ID#_#cost_spect_id#")*rate_price/rate_other,8))/mevcut_son_alislar_department)>
										<cfset purchase_net_all_department_2 = alis_net_fiyat_system_2_department + ((wrk_round(evaluate("prc_protec_org_dep_#PRODUCT_ID#_#cost_spect_id#")*evaluate("prc_protec_amount_#PRODUCT_ID#_#cost_spect_id#")*rate_price/rate_2,8))/mevcut_son_alislar_department)>
                                    <cfelse>
										<cfset purchase_net_all_department = alis_net_fiyat_department + ((wrk_round(evaluate("prc_protec_org_dep_#PRODUCT_ID#_#cost_spect_id#")*evaluate("prc_protec_amount_#PRODUCT_ID#_#cost_spect_id#")*rate_price/rate_other,8)))>
										<cfset purchase_net_all_department_2 = alis_net_fiyat_system_2_department + ((wrk_round(evaluate("prc_protec_org_dep_#PRODUCT_ID#_#cost_spect_id#")*evaluate("prc_protec_amount_#PRODUCT_ID#_#cost_spect_id#")*rate_price/rate_2,8)))>
                                    </cfif>
								</cfif>
							</cfif>
							<cfquery name="ADD_COST" datasource="#FORM.DSN1#" result="MY_RESULT">
								INSERT INTO
									PRODUCT_COST
								(
									PRODUCT_ID,
									INVENTORY_CALC_TYPE,
									PRODUCT_COST,
									MONEY,
									STANDARD_COST,
									STANDARD_COST_MONEY,
									PURCHASE_NET,
									AVAILABLE_STOCK,
									STANDARD_COST_RATE,
									COST_DESCRIPTION,
									IS_STANDARD_COST,
									IS_ACTIVE_STOCK,
									IS_PARTNER_STOCK,
									PURCHASE_NET_MONEY,
									PURCHASE_EXTRA_COST,
									PRICE_PROTECTION,
									PRICE_PROTECTION_MONEY,
									COST_TYPE_ID,
									PRICE_PROTECTION_TYPE,
									PRICE_PROTECTION_TOTAL,
									PRICE_PROTECTION_AMOUNT,
									PARTNER_STOCK,
									ACTIVE_STOCK,
									RECORD_DATE,
									START_DATE,
									RECORD_EMP,
									RECORD_IP,
									UNIT_ID,
									PRODUCT_COST_STATUS,
									ACTION_ID,
									ACTION_TYPE,
									ACTION_PERIOD_ID,
									ACTION_AMOUNT,
									ACTION_ROW_ID,
									ACTION_PROCESS_TYPE,
									ACTION_PROCESS_CAT_ID,
									ACTION_ROW_PRICE,
									ACTION_EXTRA_COST,
									PURCHASE_NET_SYSTEM,
									PURCHASE_EXTRA_COST_SYSTEM,
									PURCHASE_NET_SYSTEM_MONEY,
									IS_SPEC,
									SPECT_MAIN_ID,
									STOCK_ID,
									PURCHASE_NET_SYSTEM_2,
									PURCHASE_EXTRA_COST_SYSTEM_2,
									PURCHASE_NET_SYSTEM_MONEY_2,									
									DEPARTMENT_ID,
									LOCATION_ID,
									AVAILABLE_STOCK_LOCATION,
									PARTNER_STOCK_LOCATION,
									ACTIVE_STOCK_LOCATION,
									PRODUCT_COST_LOCATION,
									MONEY_LOCATION,
									STANDARD_COST_LOCATION,
									STANDARD_COST_MONEY_LOCATION,
									STANDARD_COST_RATE_LOCATION,
									PURCHASE_NET_LOCATION,
									PURCHASE_NET_MONEY_LOCATION,
									PURCHASE_EXTRA_COST_LOCATION,
									PRICE_PROTECTION_LOCATION,
									PRICE_PROTECTION_MONEY_LOCATION,		
									PURCHASE_NET_SYSTEM_LOCATION,
									PURCHASE_NET_SYSTEM_MONEY_LOCATION,
									PURCHASE_EXTRA_COST_SYSTEM_LOCATION,
									PURCHASE_NET_SYSTEM_2_LOCATION,
									PURCHASE_NET_SYSTEM_MONEY_2_LOCATION,
									PURCHASE_EXTRA_COST_SYSTEM_2_LOCATION,
                                    AVAILABLE_STOCK_DEPARTMENT,
									PARTNER_STOCK_DEPARTMENT,
									ACTIVE_STOCK_DEPARTMENT,
									PRODUCT_COST_DEPARTMENT,
									MONEY_DEPARTMENT,
									STANDARD_COST_DEPARTMENT,
									STANDARD_COST_MONEY_DEPARTMENT,
									STANDARD_COST_RATE_DEPARTMENT,
									PURCHASE_NET_DEPARTMENT,
									PURCHASE_NET_MONEY_DEPARTMENT,
									PURCHASE_EXTRA_COST_DEPARTMENT,
									PRICE_PROTECTION_DEPARTMENT,
									PRICE_PROTECTION_MONEY_DEPARTMENT,		
									PURCHASE_NET_SYSTEM_DEPARTMENT,
									PURCHASE_NET_SYSTEM_MONEY_DEPARTMENT,
									PURCHASE_EXTRA_COST_SYSTEM_DEPARTMENT,
									PURCHASE_NET_SYSTEM_2_DEPARTMENT,
									PURCHASE_NET_SYSTEM_MONEY_2_DEPARTMENT,
									PURCHASE_EXTRA_COST_SYSTEM_2_DEPARTMENT,										
									DUE_DATE,
									DUE_DATE_LOCATION,
                                    DUE_DATE_DEPARTMENT,
									PHYSICAL_DATE,
									PHYSICAL_DATE_LOCATION,
                                    PHYSICAL_DATE_DEPARTMENT,
									ACTION_DATE,
									ACTION_DUE_DATE,
									UPDATE_DATE,
									UPDATE_EMP,
									UPDATE_IP,
									PURCHASE_NET_ALL,
									PURCHASE_NET_SYSTEM_ALL,
									PURCHASE_NET_SYSTEM_2_ALL,
									PURCHASE_NET_LOCATION_ALL,
									PURCHASE_NET_SYSTEM_LOCATION_ALL,
									PURCHASE_NET_SYSTEM_2_LOCATION_ALL,
                                    PURCHASE_NET_DEPARTMENT_ALL,
									PURCHASE_NET_SYSTEM_DEPARTMENT_ALL,
									PURCHASE_NET_SYSTEM_2_DEPARTMENT_ALL,
									STATION_REFLECTION_COST,
									STATION_REFLECTION_COST_SYSTEM,
									STATION_REFLECTION_COST_SYSTEM_2,
									STATION_REFLECTION_COST_LOCATION,
									STATION_REFLECTION_COST_SYSTEM_LOCATION,
									STATION_REFLECTION_COST_SYSTEM_2_LOCATION,
									STATION_REFLECTION_COST_DEPARTMENT,
									STATION_REFLECTION_COST_SYSTEM_DEPARTMENT,
									STATION_REFLECTION_COST_SYSTEM_2_DEPARTMENT,
									LABOR_COST,
									LABOR_COST_SYSTEM,
									LABOR_COST_SYSTEM_2,
									LABOR_COST_LOCATION,
									LABOR_COST_SYSTEM_LOCATION,
									LABOR_COST_SYSTEM_2_LOCATION,
									LABOR_COST_DEPARTMENT,
									LABOR_COST_SYSTEM_DEPARTMENT,
									LABOR_COST_SYSTEM_2_DEPARTMENT
								)
								VALUES
								(
									#PRODUCT_ID#,
									#GET_COMPS_PER.INVENTORY_CALC_TYPE#,
									<cfif mevcut_son_alislar neq 0>
										#alis_net_fiyat + wrk_round(alis_ek_maliyet,8,1) + evaluate("std_cost_#PRODUCT_ID#_#cost_spect_id#")+ ((alis_net_fiyat*evaluate("std_cost_rate_#PRODUCT_ID#_#cost_spect_id#"))/100)- (evaluate("prc_protec_sys_#PRODUCT_ID#_#cost_spect_id#")*evaluate("prc_protec_type_#PRODUCT_ID#_#cost_spect_id#")*evaluate("prc_protec_amount_#PRODUCT_ID#_#cost_spect_id#")/mevcut_son_alislar)#,<!--- #wrk_round(alis_net_fiyat+alis_ek_maliyet,4)#, ---><!--- #wrk_round((form.PURCHASE_NET+form.PURCHASE_EXTRA_COST+form.STANDARD_COST+((form.PURCHASE_NET*form.STANDARD_COST_RATE)/100)-form.PRICE_PROTECTION),4)#, --->
									<cfelse>
										#alis_net_fiyat + wrk_round(alis_ek_maliyet,8,1) + evaluate("std_cost_#PRODUCT_ID#_#cost_spect_id#")+ ((alis_net_fiyat*evaluate("std_cost_rate_#PRODUCT_ID#_#cost_spect_id#"))/100)- (evaluate("prc_protec_sys_#PRODUCT_ID#_#cost_spect_id#")*evaluate("prc_protec_type_#PRODUCT_ID#_#cost_spect_id#")*evaluate("prc_protec_amount_#PRODUCT_ID#_#cost_spect_id#"))#,<!--- #wrk_round(alis_net_fiyat+alis_ek_maliyet,4)#, ---><!--- #wrk_round((form.PURCHASE_NET+form.PURCHASE_EXTRA_COST+form.STANDARD_COST+((form.PURCHASE_NET*form.STANDARD_COST_RATE)/100)-form.PRICE_PROTECTION),4)#, --->
									</cfif>
									'#reference_money#',
									#evaluate("std_cost_org_#PRODUCT_ID#_#cost_spect_id#")#,
									'#wrk_eval("std_cost_money_#PRODUCT_ID#_#cost_spect_id#")#',
									<cfif len(alis_net_fiyat)>#alis_net_fiyat#,<cfelse>0,</cfif>
									<cfif len(mevcut_son_alislar)>#mevcut_son_alislar#,<cfelse>0,</cfif>
									<cfif len(evaluate('std_cost_rate_#PRODUCT_ID#_#cost_spect_id#'))>#evaluate('std_cost_rate_#PRODUCT_ID#_#cost_spect_id#')#,<cfelse>0,</cfif>
									NULL,
									0,
									0,
									0,
									'#reference_money#',
									<cfif len(alis_ek_maliyet)>#wrk_round(alis_ek_maliyet,8,1)#,<cfelse>0,</cfif>
									<cfif mevcut_son_alislar neq 0>
										#evaluate("prc_protec_org_#PRODUCT_ID#_#cost_spect_id#")*evaluate("prc_protec_amount_#PRODUCT_ID#_#cost_spect_id#")/mevcut_son_alislar#,
									<cfelse>
										#evaluate("prc_protec_org_#PRODUCT_ID#_#cost_spect_id#")*evaluate("prc_protec_amount_#PRODUCT_ID#_#cost_spect_id#")#,
									</cfif>
									'#wrk_eval("prc_protec_money_#PRODUCT_ID#_#cost_spect_id#")#',
									<cfif len(evaluate("prc_protec_cost_type_#PRODUCT_ID#_#cost_spect_id#"))>#evaluate("prc_protec_cost_type_#PRODUCT_ID#_#cost_spect_id#")#<cfelse>NULL</cfif>,
									#evaluate("prc_protec_type_#PRODUCT_ID#_#cost_spect_id#")#,
									#evaluate("prc_protec_total_#PRODUCT_ID#_#cost_spect_id#")#,
									#evaluate("prc_protec_amount_#PRODUCT_ID#_#cost_spect_id#")#,
									0,
									<cfif len(yoldaki_stoklar)>#yoldaki_stoklar#,<cfelse>0,</cfif>
									#CreateODBCDateTime(INSERT_DATE)#,<!--- belgenin kayit tarihi maliyet kayit tarihi kabul ediliyor guncellemelerde sira belli olsun ve degismesin diye degistirilmemeli --->
									#stok_bakma_tarihi#,
									#form.session_userid#,
									'#cgi.REMOTE_ADDR#',
									1,
									<cfif not GET_NEXT_PRODUCT_COST.RECORDCOUNT>1<cfelse>0</cfif>,
									<cfif len(ACTION_ID)>#ACTION_ID#<cfelse>NULL</cfif>,
									<cfif len(ACTION_TYPE)>#ACTION_TYPE#<cfelse>NULL</cfif>,
									#form.session_period_id#,
									#AMOUNT#,
									#ACTION_ROW_ID#,
									#GET_PROCESS_CAT.PROCESS_TYPE#,
									#GET_PROCESS_CAT.PROCESS_CAT_ID#,
									#satir_fiyat_tutar#,
									#satir_ekstra_tutar#,
									#wrk_round(alis_net_fiyat_system,8,1)#,
									#wrk_round(alis_ek_maliyet_system,8,1) + evaluate("std_cost_sys_#PRODUCT_ID#_#cost_spect_id#") + ((wrk_round(alis_net_fiyat_system,8)*evaluate("std_cost_rate_#PRODUCT_ID#_#cost_spect_id#"))/100)#,
									'#alis_net_fiyat_money_system#',
									<cfif isdefined('SPEC_MAIN_ID') and len(SPEC_MAIN_ID)>1<cfelse>0</cfif>,
									<cfif isdefined('SPEC_MAIN_ID') and len(SPEC_MAIN_ID)>#SPEC_MAIN_ID#<cfelse>NULL</cfif>,
									<cfif isdefined('STOCK_ID_') and len(STOCK_ID_)>#STOCK_ID_#<cfelse>NULL</cfif>,
									#alis_net_fiyat_system_2#,
									#alis_ek_maliyet_system_2 + evaluate("std_cost_sys_2_#PRODUCT_ID#_#cost_spect_id#") + ((alis_net_fiyat_system_2*evaluate("std_cost_rate_#PRODUCT_ID#_#cost_spect_id#"))/100)#,
									'#alis_net_fiyat_money_system_2#',
									#ACTION_DEPARTMENT_ID#,
									#ACTION_LOCATION_ID#,
									<cfif len(mevcut_son_alislar_lokasyon)>#mevcut_son_alislar_lokasyon#,<cfelse>0,</cfif>
									0,
									0,
									#alis_net_fiyat_lokasyon + alis_ek_maliyet_lokasyon + evaluate("std_cost_loc_#PRODUCT_ID#_#cost_spect_id#")+ ((alis_net_fiyat_lokasyon*evaluate("std_cost_rate_loc_#PRODUCT_ID#_#cost_spect_id#"))/100)- (evaluate("prc_protec_loc_#PRODUCT_ID#_#cost_spect_id#")*evaluate("prc_protec_type_#PRODUCT_ID#_#cost_spect_id#"))#,
									'#reference_money#',
									#evaluate("std_cost_org_loc_#PRODUCT_ID#_#cost_spect_id#")#,
									'#wrk_eval("std_cost_money_loc_#PRODUCT_ID#_#cost_spect_id#")#',
									<cfif len(evaluate('std_cost_rate_loc_#PRODUCT_ID#_#cost_spect_id#'))>#evaluate('std_cost_rate_loc_#PRODUCT_ID#_#cost_spect_id#')#<cfelse>0</cfif>,
									<cfif len(alis_net_fiyat_lokasyon)>#alis_net_fiyat_lokasyon#<cfelse>0</cfif>,
									'#reference_money#',
									<cfif len(alis_ek_maliyet_lokasyon)>#alis_ek_maliyet_lokasyon#<cfelse>0</cfif>,
									#evaluate("prc_protec_org_#PRODUCT_ID#_#cost_spect_id#")#,
									'#wrk_eval("prc_protec_money_#PRODUCT_ID#_#cost_spect_id#")#',
									
									#alis_net_fiyat_system_lokasyon - (evaluate("prc_protec_sys_loc_#PRODUCT_ID#_#cost_spect_id#")*evaluate("prc_protec_type_#PRODUCT_ID#_#cost_spect_id#"))#,
									'#alis_net_fiyat_money_system#',
									#alis_ek_maliyet_system_lokasyon + evaluate("std_cost_sys_loc_#PRODUCT_ID#_#cost_spect_id#") + ((alis_net_fiyat_system_lokasyon*evaluate("std_cost_rate_loc_#PRODUCT_ID#_#cost_spect_id#"))/100)#,
									#alis_net_fiyat_system_2_lokasyon - (evaluate("prc_protec_sys_2_loc_#PRODUCT_ID#_#cost_spect_id#")*evaluate("prc_protec_type_#PRODUCT_ID#_#cost_spect_id#"))#,
									'#alis_net_fiyat_money_system_2#',
									#alis_ek_maliyet_system_2_lokasyon + evaluate("std_cost_sys_2_loc_#PRODUCT_ID#_#cost_spect_id#") + ((alis_net_fiyat_system_2_lokasyon*evaluate("std_cost_rate_loc_#PRODUCT_ID#_#cost_spect_id#"))/100)#,
									<cfif len(mevcut_son_alislar_department)>#mevcut_son_alislar_department#,<cfelse>0,</cfif>
									0,
									0,
									#alis_net_fiyat_department + alis_ek_maliyet_department + evaluate("std_cost_dep_#PRODUCT_ID#_#cost_spect_id#")+ ((alis_net_fiyat_department*evaluate("std_cost_rate_dep_#PRODUCT_ID#_#cost_spect_id#"))/100)- (evaluate("prc_protec_dep_#PRODUCT_ID#_#cost_spect_id#")*evaluate("prc_protec_type_#PRODUCT_ID#_#cost_spect_id#"))#,
									'#reference_money#',
									#evaluate("std_cost_org_dep_#PRODUCT_ID#_#cost_spect_id#")#,
									'#wrk_eval("std_cost_money_dep_#PRODUCT_ID#_#cost_spect_id#")#',
									<cfif len(evaluate('std_cost_rate_dep_#PRODUCT_ID#_#cost_spect_id#'))>#evaluate('std_cost_rate_dep_#PRODUCT_ID#_#cost_spect_id#')#<cfelse>0</cfif>,
									<cfif len(alis_net_fiyat_department)>#alis_net_fiyat_department#<cfelse>0</cfif>,
									'#reference_money#',
									<cfif len(alis_ek_maliyet_department)>#alis_ek_maliyet_department#<cfelse>0</cfif>,
									#evaluate("prc_protec_org_dep_#PRODUCT_ID#_#cost_spect_id#")#,
									'#wrk_eval("prc_protec_money_dep_#PRODUCT_ID#_#cost_spect_id#")#',
									
									#alis_net_fiyat_system_department - (evaluate("prc_protec_sys_dep_#PRODUCT_ID#_#cost_spect_id#")*evaluate("prc_protec_type_#PRODUCT_ID#_#cost_spect_id#"))#,
									'#alis_net_fiyat_money_system#',
									#alis_ek_maliyet_system_department + evaluate("std_cost_sys_dep_#PRODUCT_ID#_#cost_spect_id#") + ((alis_net_fiyat_system_department*evaluate("std_cost_rate_dep_#PRODUCT_ID#_#cost_spect_id#"))/100)#,
									#alis_net_fiyat_system_2_department - (evaluate("prc_protec_sys_2_dep_#PRODUCT_ID#_#cost_spect_id#")*evaluate("prc_protec_type_#PRODUCT_ID#_#cost_spect_id#"))#,
									'#alis_net_fiyat_money_system_2#',
									#alis_ek_maliyet_system_2_department + evaluate("std_cost_sys_2_dep_#PRODUCT_ID#_#cost_spect_id#") + ((alis_net_fiyat_system_2_department*evaluate("std_cost_rate_dep_#PRODUCT_ID#_#cost_spect_id#"))/100)#,
                                    
									<cfif isdefined('due_date_') and isdate(due_date_)>#due_date_#<cfelse>NULL</cfif>,
									<cfif isdefined('due_date_location') and isdate(due_date_location)>#due_date_location#<cfelse>NULL</cfif>,
                                    <cfif isdefined('due_date_department') and isdate(due_date_department)>#due_date_department#<cfelse>NULL</cfif>,
									<cfif isdefined('physical_date_') and isdate(physical_date_)>#physical_date_#<cfelse>NULL</cfif>,
									<cfif isdefined('physical_date_location') and isdate(physical_date_location)>#physical_date_location#<cfelse>NULL</cfif>,
                                    <cfif isdefined('physical_date_department') and isdate(physical_date_department)>#physical_date_department#<cfelse>NULL</cfif>,
									<cfif len(PAPER_DATE)>#CreateODBCDateTime(PAPER_DATE)#<cfelse>NULL</cfif>,
									<cfif isdefined('DUE_DATE') and len(DUE_DATE)>#DUE_DATE#<cfelse>0</cfif>,
									#NOW()#,
									#form.session_userid#,
									'#cgi.REMOTE_ADDR#',
									<cfif len(purchase_net_all)>#purchase_net_all#<cfelse>0</cfif>,
									<cfif len(purchase_net_all)>#wrk_round(purchase_net_all*rate_other,8)#<cfelse>0</cfif>,
									<cfif len(purchase_net_all_2)>#purchase_net_all_2#<cfelse>0</cfif>,
									<cfif len(purchase_net_all_location)>#purchase_net_all_location#<cfelse>0</cfif>,
									<cfif len(purchase_net_all_location)>#wrk_round(purchase_net_all_location*rate_other,8)#<cfelse>0</cfif>,
									<cfif len(purchase_net_all_location_2)>#purchase_net_all_location_2#<cfelse>0</cfif>,
                                    <cfif len(purchase_net_all_department)>#purchase_net_all_department#<cfelse>0</cfif>,
									<cfif len(purchase_net_all_department)>#wrk_round(purchase_net_all_department*rate_other,8)#<cfelse>0</cfif>,
									<cfif len(purchase_net_all_department_2)>#purchase_net_all_department_2#<cfelse>0</cfif>,
									#alis_reflection#,
                                    #alis_reflection_system#,
                                    #alis_reflection_system_2#,
                                    #alis_reflection_lokasyon#,
                                    #alis_reflection_system_lokasyon#,
                                    #alis_reflection_system_2_lokasyon#,
                                    #alis_reflection_department#,
                                    #alis_reflection_system_department#,
                                    #alis_reflection_system_2_department#,
                                    #alis_labor#,
                                    #alis_labor_system#,
                                    #alis_labor_system_2#,
                                    #alis_labor_lokasyon#,
                                    #alis_labor_system_lokasyon# ,
                                    #alis_labor_system_2_lokasyon# ,
                                    #alis_labor_department#,
                                    #alis_labor_system_department#,
                                    #alis_labor_system_2_department#
								)
							</cfquery>
						   <cfquery datasource="#FORM.DSN1#" name="GET_P_COST_ID">
								SELECT 
									MAX(PRODUCT_COST_ID) AS MAX_ID 
								FROM 
									PRODUCT_COST 
								WHERE 
									PRODUCT_ID = #PRODUCT_ID#
									<cfif isdefined('SPEC_MAIN_ID') and len(SPEC_MAIN_ID)>
										AND SPECT_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#SPEC_MAIN_ID#">
									<cfelseif is_prod_cost_type eq 0>
										AND IS_SPEC=0
									</cfif>
									<cfif isdefined("STOCK_ID_") and len(STOCK_ID_)>
										AND STOCK_ID = <cfqueryparam value="#STOCK_ID_#" cfsqltype="cf_sql_integer"> 
									<cfelseif is_stock_based_cost eq 0>
										AND STOCK_ID IS NULL
									</cfif>
									AND ACTION_PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.session_period_id#">
							</cfquery>
						</cftransaction>
					</cflock>
				</cfif>
				<cfquery name="ins_cost_id" datasource="#form.period_dsn_type#">
					INSERT INTO 
						PRODUCT_COST_REFERENCE						
					(
						PRODUCT_COST_ID,
						ACTION_ID,
						ACTION_TYPE,
						AMOUNT
					)
					VALUES
					(
						#GET_P_COST_ID.MAX_ID#,
						#paper_action_id#,
						#paper_action_type#,
						#AMOUNT#
					)
				</cfquery>
				<!--- speclerine gore kontrol eklenecek, aynı urun 2 satırda farklı speclerle eklenmiş olabilir
				bu şartla, belge içerisinde aynı üründen birden fazla satır bulunuyorsa, önce bu satırlar için maliyet yazılıyor ardından aynı ürünün sonraki maliyetleri güncelleniyor --->
				<cfif not isdefined("form.aktarim_is_date_kontrol")><!--- Sadece Seçilen Tarih Aralığındaki Maliyetler Güncellensin seçeneği seçilirse dönem bakım işlemlerinde buraya girmesin --->
					<cfif (GET_ACTION.PRODUCT_ID neq GET_ACTION.PRODUCT_ID[currentrow+1]) or (currentrow eq GET_ACTION.recordcount)>
						<cfscript>
						//writeoutput('<font color="red">#INSERT_DATE#<br/><br/>#ACTION_ID# ID LI BELGENİN SATIRLARI İÇİN MALİYETLER EKLENDİ ŞİMDİ BU #ACTION_ID# NUMARALI BELGEDEN SONRA BİR BELGE VARSA BUNLAR BULUNUP ONLARI MALİYET ALANLARI UPDATE EDİLCEK..</font>');
						upd_newer_cost(
										newer_action_id=ACTION_ID,
										newer_action_row_id=ACTION_ROW_ID,
										newer_spec_main_id=SPEC_MAIN_ID,
										newer_stock_id=STOCK_ID_,
										newer_product_id=PRODUCT_ID,
										newer_action_date=ACTION_DATE,
										newer_record_date=INSERT_DATE,
										newer_comp_period_list='#comp_period_list#',
										newer_comp_period_year_list='#comp_period_year_list#',
										newer_dsn=form.dsn,
										newer_dsn3=form.dsn3,
										newer_period_dsn_type=form.period_dsn_type,
										newer_our_company_id=GET_COMPS_PER.OUR_COMPANY_ID
									);
						</cfscript>
					</cfif>
				</cfif>
			</cfif>
			</cfoutput>
             <cfquery name="updShipSevk" datasource="#form.period_dsn_type#">
			  IF EXISTS (SELECT * FROM tempdb.sys.tables where name = '####GET_INVOICE')
			  BEGIN
             	UPDATE
                    SHIP_ROW
                    SET
                        COST_PRICE=ISNULL(XXX.p1,0),            
                        EXTRA_COST=ISNULL((XXX.r1),0)
                    FROM 
                        SHIP_ROW
                    OUTER APPLY 
                        (
                            SELECT
                                        TOP 1 
											<cfif isdefined('attributes.aktarim_is_location_based_cost') and attributes.aktarim_is_location_based_cost eq 1> 
                                                ROUND((PURCHASE_NET_SYSTEM_LOCATION),4) AS p1
                                               ,ROUND((PURCHASE_EXTRA_COST_SYSTEM_LOCATION),4) AS r1
											<cfelseif isdefined('attributes.aktarim_is_location_based_cost') and attributes.aktarim_is_location_based_cost eq 2> <!--- depo bazlı maliyet--->
												ROUND((PURCHASE_NET_SYSTEM_DEPARTMENT),4) AS p1
                                                ,ROUND((PURCHASE_EXTRA_COST_SYSTEM_DEPARTMENT),4) AS r1
											<cfelse>
												ROUND((PURCHASE_NET_SYSTEM),4) AS p1
												,ROUND((PURCHASE_EXTRA_COST_SYSTEM),4) AS r1
											</cfif>
                                        FROM 
                                            #FORM.DSN3#.PRODUCT_COST GPCP
                                        WHERE
											GPCP.START_DATE <= (SELECT ISNULL(INV.DELIVER_DATE,INV.SHIP_DATE) AS SHIP_DATE FROM SHIP INV WHERE INV.SHIP_ID = SHIP_ROW.SHIP_ID)
                                            AND GPCP.PRODUCT_ID = SHIP_ROW.PRODUCT_ID
										<cfif isdefined('attributes.aktarim_is_location_based_cost') and attributes.aktarim_is_location_based_cost eq 1>
											AND GPCP.LOCATION_ID = (SELECT II.LOCATION FROM SHIP II WHERE II.SHIP_ID = SHIP_ROW.SHIP_ID)
                                            AND GPCP.DEPARTMENT_ID = (SELECT II.DELIVER_STORE_ID FROM SHIP II WHERE II.SHIP_ID = SHIP_ROW.SHIP_ID)
										<cfelseif isdefined('attributes.aktarim_is_location_based_cost') and attributes.aktarim_is_location_based_cost eq 2>
											AND GPCP.DEPARTMENT_ID = (SELECT II.DELIVER_STORE_ID FROM SHIP II WHERE II.SHIP_ID = SHIP_ROW.SHIP_ID)
										</cfif>
                                        ORDER BY 
                                            GPCP.START_DATE DESC,
                                            GPCP.RECORD_DATE DESC,
                                            GPCP.PRODUCT_COST_ID DESC
                        ) AS XXX
                    JOIN
                        ####GET_INVOICE GET_INVOICE ON SHIP_ROW.SHIP_ID = GET_INVOICE.ACTION_ID AND GET_INVOICE.SHIP_TYPE_NEW=81
                   WHERE
                   	SHIP_ROW.PRODUCT_ID = #PRODUCT_ID#
				END
             </cfquery>
			<cfif paper_action_type eq 4 and isdefined("form.aktarim_date2")>
				<cfscript>
					//üretim işleminden sonra sevkler güncellensin diye eklendi 0819 PY 
					upd_newer_cost(
						newer_action_id=ACTION_ID,
						newer_action_row_id=ACTION_ROW_ID,
						newer_spec_main_id=SPEC_MAIN_ID,
						newer_stock_id=STOCK_ID_,
						newer_product_id=PRODUCT_ID,
						newer_action_date=ACTION_DATE,
						newer_record_date=INSERT_DATE,
						newer_comp_period_list='#comp_period_list#',
						newer_comp_period_year_list='#comp_period_year_list#',
						newer_dsn=form.dsn,
						newer_dsn3=form.dsn3,
						newer_period_dsn_type=form.period_dsn_type,
						newer_action_process_type = 81,
						newer_action_finish_date= form.aktarim_date2,
						newer_our_company_id=GET_COMPS_PER.OUR_COMPANY_ID
					);
				</cfscript>
			</cfif>
		</cfloop>
	<cfelseif listfind('52,53,62,532,85,88,70,71,72,78,79,120',GET_PROCESS_CAT.PROCESS_TYPE,',')>
	<!--- belge tipi maliyet işlemi yapmıyor ama stok haraketi yapanlarda geçmişe dönük olabilir diye bu blok var
	satış faturaları ve masraf fişi için ise bu bölüm çalışacak belge maliyet eklemeyecek ancak kendi tarihinden bir önceki maliyet ekleyen belge bulunuyor ve güncelleniyor--->
		<cfscript>
			dsn3=form.dsn3;
			dsn2=form.period_dsn_type;
			session.ep = StructNew();
			session.ep.workcube_id=form.s_id;
			session.ep.money=form.cost_money_system;
			session.ep.money2=form.cost_money_system_2;
			session.ep.userid=session_userid;
			session.ep.period_id=form.session_period_id;
			session.ep.company_id=form.session_company_id;
		</cfscript>
		<cfoutput query="GET_ACTION">
			<cfquery name="get_stocks_pro" datasource="#form.dsn1#" maxrows="1">
				SELECT 
					ACTION_ID,
					ACTION_TYPE
				FROM
					PRODUCT_COST
				WHERE
					PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#PRODUCT_ID#"> AND
					START_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdate(ACTION_DATE)#"> AND
					ACTION_PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.session_period_id#"> AND
					ACTION_TYPE IS NOT NULL <!--- ELLE EKLENENLER SONRAKİ ALIŞ OLARAK GELMEMELİ --->
				ORDER BY
					START_DATE,
					RECORD_DATE
			</cfquery>
			<cfif get_stocks_pro.RECORDCOUNT>
				<cfif not isdefined('cost_action')>
					<cfinclude template="../../objects/functions/cost_action.cfm">
				</cfif>
				<cfscript>
					attributes.action_type=get_stocks_pro.ACTION_TYPE;
					attributes.action_id=get_stocks_pro.ACTION_ID;
					cost_action(action_type:attributes.action_type,action_id:attributes.action_id,query_type:2);
				</cfscript>
				
			</cfif>
		</cfoutput>
	</cfif><!--- //islem kategorisi maliyet islemi yapmıyorsa --->

<cfelse><!--- silme islemi ise --->
	<cfquery datasource="#form.period_dsn_type#" name="GET_PROD_COST">
		SELECT
			PCR.PRODUCT_COST_ID,
			PC.STOCK_ID,
			PC.PRODUCT_ID,
			PC.START_DATE ACTION_DATE,
			PC.RECORD_DATE INSERT_DATE,
			PC.SPECT_MAIN_ID SPEC_MAIN_ID,
			PC.RECORD_DATE,
			PC.ACTION_ROW_ID
		FROM 
			PRODUCT_COST_REFERENCE PCR,
			#FORM.DSN1_alias#.PRODUCT_COST PC
		WHERE 
			PC.PRODUCT_COST_ID = PCR.PRODUCT_COST_ID
			AND PCR.ACTION_ID = <cfqueryparam value="#paper_action_id#" cfsqltype="cf_sql_integer">
			AND ACTION_PERIOD_ID = <cfqueryparam value="#paper_action_period_id#" cfsqltype="cf_sql_integer">
			AND
			<cfif paper_action_type eq 1>
				(PCR.ACTION_TYPE = <cfqueryparam value="#paper_action_type#" cfsqltype="cf_sql_integer"> OR PCR.ACTION_TYPE = <cfqueryparam value="8" cfsqltype="cf_sql_integer">)
			<cfelse>
				PCR.ACTION_TYPE = <cfqueryparam value="#paper_action_type#" cfsqltype="cf_sql_integer">
			</cfif>
	</cfquery>
	<cfif GET_PROD_COST.RECORDCOUNT>
		<cfoutput query="GET_PROD_COST">
			<cfscript>
				del_cost(
						del_product_cost_id=PRODUCT_COST_ID,
						del_dsn1=FORM.DSN1,
						del_period_dsn=form.period_dsn_type
						);
				upd_newer_cost(
								newer_action_id=ACTION_ID,
								newer_action_row_id=ACTION_ROW_ID,
								newer_spec_main_id=SPEC_MAIN_ID,
								newer_stock_id=STOCK_ID,
								newer_product_id=PRODUCT_ID,
								newer_action_date=ACTION_DATE,
								newer_record_date=INSERT_DATE,
								newer_comp_period_list='#comp_period_list#',
								newer_comp_period_year_list='#comp_period_year_list#',
								newer_dsn=form.dsn,
								newer_dsn3=form.dsn3,
								newer_period_dsn_type=form.period_dsn_type,
								newer_our_company_id=GET_COMPS_PER.OUR_COMPANY_ID
							);
				</cfscript>
		</cfoutput>
	</cfif>
</cfif>