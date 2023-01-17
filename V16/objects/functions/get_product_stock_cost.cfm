<cfsetting showdebugoutput="no">
<cfsetting enablecfoutputonly="yes"><cfprocessingdirective suppresswhitespace="yes">
<cffunction name="get_product_stock_cost" output="true">
<!--- Oluşturma geçmiş zaman ve yapan belli değil ancak nerde ise tamamen değişti
TolgaS 20061205
	notes : İstenen ürün veya stoğun istenen yönteme göre maliyetini hesaplar
	Arguments:
		-is_product_stock:		1:product_id veya 2:stock_id
		-product_stock_id:		product_id veya stock_id
		-tax_inc:		KDV Dahil(1), KDV Hariç(0)
		-cost_method:	
			Yöntemler
			---------
			1: fifo:	İlk Giren İlk Çıkar
			2: lifo:	Son Giren İlk Çıkar
			3: gpa:		Ağırlıklı Ortalama
			4: lpp:		Son Alış Fiyatı
			5: fpp:		İlk Alış Fiyatı
			6: st:		Standart Alış
			7: st:		Standart Satış
		-cost_money : maliyetin hesaplanacagi parabrimi (standart satış genelde)
		-action_id : belge idsi (maliyetti eklenecek belge)
		-action_row_id : belge satır idsi
		-action_type : 1 fatura, 2 israliye,3 stok fisi,4 üretim, 5 stok virman,-1 Excelden aktarım ile...
		-spec_id:
		-spec_main_id :	maliyet eklenecek urun main spec idsi
		-period_dsn_type : donemlerde sorun olmaması icin calistirilacak donem yollanmalı
		-pur_sale : alış satış mı
		-cost_date :
		-cost_money_system : sistem parabirimi maliyeti hesaplanırken kullanılır
		-cost_money_system_2 : 2 sistem para brimi
		-action_comp_period_list : agirlikli ortalama icin sirket donem id listesi
		-action_cost_id : guncellenen maliyetin ilerki tarihli maliyetleri guncellenirken elle eklenenler için cost_id yollanıyor
		-is_cost_zero_row : 0 tutarlı satırlar maliyet oluştursunmu 1 oluşturur 0 oluşturmaz
		-is_cost_zero_row : 0 tutarlar net maliyetdenmi fiyatdanmı alınsın
	usage :
		get_product_stock_cost(is_product_stock:1,product_stock_id:11,tax_inc:1,cost_method:1,cost_money:'USD',action_id:1,action_type:1,spec_main_id:50)
		get_product_stock_cost(is_product_stock:2,product_stock_id:22,tax_inc:0,cost_method:6,cost_money:'EURO')
--->
	<cfargument name="is_product_stock" type="boolean" required="yes">
	<cfargument name="product_stock_id" type="numeric" required="yes">
	<cfargument name="tax_inc" type="boolean" required="yes">
	<cfargument name="cost_method" required="yes">
	<cfargument name="pur_sale" type="boolean" required="no">
	<cfargument name="cost_date" type="date" default="#now()#" required="no">
	<cfargument name="cost_money" type="string" required="yes"><!--- maliyetin hesaplanacagi parabrimi (standart satış genelde) --->
	<cfargument name="cost_money_system" type="string" required="no" default="#session.ep.money#">
	<cfargument name="cost_money_system_2" type="string" required="no" default="USD"><!--- sistem 2. para birimi --->
	<cfargument name="action_id" type="numeric" required="no" default="0">
	<cfargument name="action_row_id" type="string" required="no" default="0">
	<cfargument name="action_type" type="numeric" required="no" default="1">
	<cfargument name="spec_id" type="numeric" required="no">
	<cfargument name="spec_main_id" type="numeric" required="no">
	<cfargument name="period_dsn_type" type="string" required="no" default="#dsn2#">
	<cfargument name="action_comp_period_list" type="string" required="no" default="0"><!--- agirlikli ortalama icin sirket donem id listesi --->
	<cfargument name="action_cost_id" type="numeric" required="no" default="0"><!--- guncellenen maliyetin ilerki tarihli maliyetleri guncellenirken elle eklenenler için cost_id yollanıyor --->
	<cfargument name="is_cost_zero_row" type="numeric" required="no">
	<cfargument name="is_cost_field" type="numeric" required="no">
	<cfargument name="control_type" type="numeric" required="no" default="0">
	<cfargument name="is_cost_calc_type" type="numeric" required="no" default="1">
<!--- <CFDUMP var="#arguments#"> --->
	<cfswitch expression="#arguments.cost_method#">
		<cfcase value="1">
			<cfinclude template="../display/price_fifo.cfm">
		</cfcase>
		<cfcase value="2">
			<cfinclude template="../display/price_lifo.cfm">
		</cfcase>
		<cfcase value="3">
			<cfinclude template="../display/price_gpa.cfm">
		</cfcase>
		<cfcase value="4">
			<cfinclude template="../display/price_lpp.cfm">
		</cfcase>
		<cfcase value="5">
			<cfinclude template="../display/price_fpp.cfm">
		</cfcase>
		<cfcase value="6,7">
			<cfinclude template="../display/price_st.cfm">
		</cfcase>
		<cfcase value="8">
			<cfinclude template="../display/price_production.cfm">
		</cfcase>
	</cfswitch>
	<cfreturn stock_cost>
</cffunction>

<cffunction name="get_cost_rate" returntype="string">
<!--- vereilen belge degerleri ile maliyetin eklendigi kur bulunur historyden almak icin once setup money alınıyor o donerken hıstory varmı diye bakıyor cunku yeni kur eklenmis olabilir yada historyde olmaya bilir--->
	<cfargument name="action_id" type="numeric" required="yes">
	<cfargument name="action_type" type="numeric" required="yes">
	<cfargument name="action_date" type="string" required="yes">
	<cfargument name="dsn_period_money" type="string" required="yes" default="#form.dsn3#">
	<cfargument name="dsn_money" type="string" required="yes" default="#form.dsn#">
	<cfargument name="session_period_id" type="numeric" required="no">
	<cfset  GET_MONEY_FK.RECORDCOUNT=0><!--- fonskiyon 2.3. olarak çağrılıyor olabilir o yüzden 0 set ettik --->
	<cfif arguments.action_type eq 1>
		<cfquery name="GET_MONEY_FK" datasource="#arguments.dsn_period_money#">
			SELECT (RATE2/RATE1) RATE,MONEY_TYPE FROM INVOICE_MONEY WHERE ACTION_ID = <cfqueryparam value="#arguments.action_id#" cfsqltype="cf_sql_integer">
		</cfquery>
	<cfelseif arguments.action_type eq 8>
		<cfquery name="GET_MONEY_FK" datasource="#arguments.dsn_period_money#">
			SELECT (RATE2/RATE1) RATE,MONEY_TYPE FROM INVOICE_MONEY WHERE ACTION_ID = <cfqueryparam value="#arguments.action_id#" cfsqltype="cf_sql_integer">
		</cfquery>
	<cfelseif arguments.action_type eq 2>
        <cfstoredproc procedure="GET_SHIP_TYPE" datasource="#arguments.dsn_period_money#">
        	<cfprocparam cfsqltype="cf_sql_integer" value="#arguments.action_id#">
        	<cfprocresult name="GET_SHIP_TYPE">
        </cfstoredproc>
		<!---<cfif get_ship_type.ship_type eq 811 and isdefined("arguments.session_period_id")>
			<cfquery name="get_invoice_id" datasource="#arguments.dsn_period_money#">
				SELECT IMPORT_INVOICE_ID,IMPORT_PERIOD_ID FROM INVOICE_SHIPS WHERE SHIP_ID = <cfqueryparam value="#arguments.action_id#" cfsqltype="cf_sql_integer">
			</cfquery>
			<cfif get_invoice_id.recordcount>
				<cfif get_invoice_id.import_period_id eq arguments.session_period_id>
					<cfquery name="GET_MONEY_FK" datasource="#arguments.dsn_period_money#">
						SELECT (RATE2/RATE1) RATE,MONEY_TYPE FROM INVOICE_MONEY WHERE ACTION_ID = #get_invoice_id.IMPORT_INVOICE_ID#
					</cfquery>
				<cfelse>
					<cfquery name="get_period_info" datasource="#dsn_money#">
						SELECT PERIOD_YEAR,OUR_COMPANY_ID FROM SETUP_PERIOD WHERE PERIOD_ID = #arguments.session_period_id#
					</cfquery>
					<cfquery name="GET_MONEY_FK" datasource="#arguments.dsn_period_money#">
						SELECT (RATE2/RATE1) RATE,MONEY_TYPE FROM #dsn#_#get_period_info.period_year-1#_#get_period_info.our_company_id#.INVOICE_MONEY WHERE ACTION_ID = #get_invoice_id.IMPORT_INVOICE_ID#
					</cfquery>
				</cfif>
			<cfelse>
				<cfquery name="GET_MONEY_FK" datasource="#arguments.dsn_period_money#">
					SELECT (RATE2/RATE1) RATE, MONEY_TYPE FROM SHIP_MONEY WHERE	ACTION_ID = <cfqueryparam value="#arguments.action_id#" cfsqltype="cf_sql_integer">
				</cfquery>
			</cfif>
		<cfelse> --->
			<cfquery name="GET_MONEY_FK" datasource="#arguments.dsn_period_money#">
				SELECT (RATE2/RATE1) RATE, MONEY_TYPE FROM SHIP_MONEY WHERE	ACTION_ID = <cfqueryparam value="#arguments.action_id#" cfsqltype="cf_sql_integer">
			</cfquery>	
		<!--- </cfif> --->
		<cfif not(isdefined("GET_MONEY_FK") and GET_MONEY_FK.recordcount)>
			<cfquery name="GET_MONEY_FK" datasource="#arguments.dsn_period_money#">
				SELECT (RATE2/RATE1) RATE, MONEY_TYPE FROM SHIP_MONEY WHERE	ACTION_ID = <cfqueryparam value="#arguments.action_id#" cfsqltype="cf_sql_integer">
			</cfquery>
		</cfif>
	<cfelseif arguments.action_type eq 3>
		<cfquery name="GET_MONEY_FK" datasource="#arguments.dsn_period_money#">
			SELECT (RATE2/RATE1) RATE, MONEY_TYPE FROM STOCK_FIS_MONEY WHERE ACTION_ID = <cfqueryparam value="#arguments.action_id#" cfsqltype="cf_sql_integer">
		</cfquery>
	</cfif>
	<cfset  cost_money_rate_=''>
	<cfif isdefined('GET_MONEY_FK') and GET_MONEY_FK.RECORDCOUNT and arguments.action_type gt 0>
		<cfoutput query="GET_MONEY_FK">
			<cfset  cost_money_rate_='#cost_money_rate_##RATE#;#MONEY_TYPE#;'>
		</cfoutput>
	<cfelse>
		<cfquery name="GET_MONEY_FK" datasource="#arguments.dsn_period_money#">
			SELECT (RATE2/RATE1) RATE, MONEY MONEY_TYPE,PERIOD_ID FROM SETUP_MONEY
		</cfquery>
		<cfoutput query="GET_MONEY_FK">
            <cfstoredproc procedure="GET_MONEY_HISTORY" datasource="#dsn_money#">
            	<cfprocparam cfsqltype="cf_sql_timestamp" value="#CREATEODBCDATETIME(arguments.action_date)#">
            	<cfprocparam cfsqltype="cf_sql_varchar" value="#MONEY_TYPE#">
                <cfprocparam cfsqltype="cf_sql_varchar" value="#PERIOD_ID#">
                <cfprocresult name="GET_MONEY_HISTORY">
            </cfstoredproc>
			<cfif GET_MONEY_HISTORY.RECORDCOUNT>
				<cfset  cost_money_rate_='#cost_money_rate_##GET_MONEY_HISTORY.RATE#;#GET_MONEY_HISTORY.MONEY_TYPE#;'>
			<cfelse>
				<cfset  cost_money_rate_='#cost_money_rate_##RATE#;#MONEY_TYPE#;'>
			</cfif>
		</cfoutput>
	</cfif>
	<cfreturn cost_money_rate_>
</cffunction>

<cffunction name="duedate_action" output="false" returntype="numeric">
<!--- finansal yas hesaplar--->
	<cfargument name="duedate" type="date" required="yes"><!--- stokdaki ürünlerin vade tarihi (maliyet tablosundaki due_date)--->
	<cfargument name="stock_amount" type="numeric" required="yes"><!--- stok miktarı--->
	<cfargument name="stock_value" type="numeric" required="yes"><!--- birim stok tutarı--->
	<cfargument name="action_date" type="date" required="yes"><!--- belge işlem tarihi ınvoice_date--->
	<cfargument name="action_duedate" type="numeric" required="yes"><!--- belgedeki vade gün sayısı --->
	<cfargument name="action_amount" type="numeric" required="yes"><!--- belge miktarı --->
	<cfargument name="action_value" type="numeric" required="yes"><!--- belgedeki birim ürün tutarı --->
		<cfif arguments.stock_amount lt 0><cfset arguments.stock_amount=0></cfif>
		<cfif arguments.action_duedate gt 0>
			<cfset action_due_date_ = dateformat(date_add('d',arguments.action_duedate,dateformat(arguments.action_date,dateformat_style)),dateformat_style)>
		<cfelse>
			<cfset action_due_date_ = arguments.action_date>
		</cfif>
		<cfset duedate_day = datediff('d',dateformat(action_due_date_,dateformat_style),dateformat(arguments.duedate,dateformat_style))>
		<cfset due_day_arg=arguments.stock_amount*arguments.stock_value+arguments.action_amount*arguments.action_value>
		<cfif due_day_arg gt 0>
			<cfset duedate_value = INT((arguments.stock_amount*arguments.stock_value*duedate_day)/due_day_arg)>
		<cfelse>
			<cfset duedate_value = 0>
		</cfif>
		<cfset duedate_value = date_add('d',duedate_value,dateformat(action_due_date_,dateformat_style))>
	<cfreturn duedate_value>
</cffunction>

<cffunction name="physical_action" output="false" returntype="numeric">
<!--- fiziksel yas hesaplar--->
	<cfargument name="physicaldate" type="date" required="yes"><!--- stokdaki ürünlerin fiziksel yaşı--->
	<cfargument name="stock_amount" type="numeric" required="yes"><!--- stok miktarı--->
	<cfargument name="action_date" type="date" required="yes"><!--- ürünün stoğa giriş tarihi--->
	<cfargument name="action_amount" type="numeric" required="yes"><!--- belge miktarı --->
		<cfif arguments.stock_amount lt 0><cfset arguments.stock_amount=0></cfif>
		<cfset physical_day = datediff('d',dateformat(arguments.physicaldate,dateformat_style),dateformat(arguments.action_date,dateformat_style))>
		<cfset physical_value_arg = arguments.stock_amount+arguments.action_amount>
		<cfif physical_value_arg gt 0>
			<cfset physical_value = INT((arguments.stock_amount*physical_day)/physical_value_arg)>
		<cfelse>
			<cfset physical_value_arg = 0>
		</cfif>
		<cfset physical_value = date_add('d',-1*physical_value,dateformat(arguments.action_date,dateformat_style))>
	<cfreturn physical_value>
</cffunction>

<cffunction name="del_cost" output="false">
<!--- maliyet idsi yollanır ve maliyet silinir--->
	<cfargument name="del_product_cost_id" type="numeric" required="no" default="0">
	<cfargument name="del_dsn1" type="string" required="yes">
	<cfargument name="del_period_dsn" type="string" required="yes">
	<cfargument name="del_ship_id_list" type="string" required="no" default="0">
	<cfargument name="del_cost_period_id" type="string" required="no" default="0">
	<cfargument name="paper_product_id_" type="string" required="no" default="0">
	
	<cfif arguments.del_product_cost_id gt 0>
        <cfstoredproc procedure="DEL_COST_PRODUCT" datasource="#arguments.del_period_dsn#">
        	<cfprocparam cfsqltype="cf_sql_integer" value="#arguments.del_product_cost_id#">
        </cfstoredproc>
        
	<cfelseif arguments.del_ship_id_list gt 0>
        <cfstoredproc procedure="DEL_COST_SHIP" datasource="#arguments.del_period_dsn#">
            <cfprocparam cfsqltype="cf_sql_varchar" value="#arguments.del_ship_id_list#">
            <cfprocparam cfsqltype="cf_sql_integer" value="#del_cost_period_id#">
            <cfif len(arguments.paper_product_id_) and arguments.paper_product_id_ neq 0>
                <cfprocparam cfsqltype="cf_sql_integer" value="#arguments.paper_product_id_#">
            <cfelse>
                <cfprocparam cfsqltype="cf_sql_integer" value="0">
            </cfif>
        </cfstoredproc>
    </cfif>
</cffunction>

<cffunction name="upd_newer_cost" output="true">
<!--- eklenen veya silinen maliyetlerden sonra tarihli maliyetler guncelleniyor --->
	<cfargument name="newer_action_id" type="numeric" required="yes">
	<cfargument name="newer_action_row_id" type="numeric" required="yes">
	<cfargument name="newer_product_cost_id" type="numeric" required="no">
	<cfargument name="newer_spec_main_id" type="string">
	<cfargument name="newer_product_id" type="numeric" required="yes">
	<cfargument name="newer_stock_id" type="string" required="no">
	<cfargument name="newer_action_date" type="string" required="yes">
	<cfargument name="newer_record_date" type="string" required="yes">
	<cfargument name="newer_comp_period_list" type="string" required="yes">
	<cfargument name="newer_comp_period_year_list" type="string" required="yes">
	<cfargument name="newer_dsn" type="string" required="yes">
	<cfargument name="newer_dsn3" type="string" required="yes">
	<cfargument name="newer_period_dsn_type" type="string" required="yes">
	<cfargument name="newer_our_company_id" type="numeric" required="yes">
	<cfif not isdefined('comp_cost_calc_type')>
		<cfif len(arguments.newer_our_company_id)>
			<cfquery name="GET_COST_CALC_TYPE" datasource="#dsn#">
				SELECT COST_CALC_TYPE FROM OUR_COMPANY_INFO WHERE COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.newer_our_company_id#">
			</cfquery>
			<cfif GET_COST_CALC_TYPE.RECORDCOUNT and len(GET_COST_CALC_TYPE.COST_CALC_TYPE)>
				<cfset comp_cost_calc_type=GET_COST_CALC_TYPE.COST_CALC_TYPE>
			<cfelse>
				<cfset comp_cost_calc_type =1>
			</cfif>
		<cfelse>
			<cfset comp_cost_calc_type =1>
		</cfif>
	</cfif>
	<cfquery name="GET_NEWER_P_COSTS" datasource="#arguments.newer_dsn3#">
		<!--- --eklenen yada silinen maliyetten sonra ki maliyetleri çekiyoruz... --->
        SELECT
			PRODUCT_COST_ID,
			INVENTORY_CALC_TYPE,
			PRODUCT_ID,
			START_DATE,
			SPECT_MAIN_ID,	
			<cfif isdefined("arguments.newer_stock_id") and len(arguments.newer_stock_id)>	
				STOCK_ID,
			<cfelse>
				'' STOCK_ID,
			</cfif>	
			ISNULL(PURCHASE_NET,0) PURCHASE_NET,
			ISNULL(PURCHASE_EXTRA_COST,0) PURCHASE_EXTRA_COST,
			ISNULL(PURCHASE_NET_MONEY,0) PURCHASE_NET_MONEY,
			ISNULL(PURCHASE_NET_SYSTEM_MONEY,0) PURCHASE_NET_SYSTEM_MONEY,
			ISNULL(PURCHASE_NET_SYSTEM_MONEY_2,0) PURCHASE_NET_SYSTEM_MONEY_2,
			MONEY,
			PRICE_PROTECTION_MONEY,
			PRICE_PROTECTION,
			PRICE_PROTECTION_TYPE,
			STANDARD_COST,
			STANDARD_COST_RATE,
			STANDARD_COST_MONEY,
			ISNULL(MONEY_LOCATION,0) MONEY_LOCATION,
			ISNULL(PRICE_PROTECTION_MONEY_LOCATION,0) PRICE_PROTECTION_MONEY_LOCATION,
			ISNULL(PRICE_PROTECTION_LOCATION,0) PRICE_PROTECTION_LOCATION,
			ISNULL(STANDARD_COST_LOCATION,0) STANDARD_COST_LOCATION,
			ISNULL(STANDARD_COST_RATE_LOCATION,0) STANDARD_COST_RATE_LOCATION,
			ISNULL(STANDARD_COST_MONEY_LOCATION,0) STANDARD_COST_MONEY_LOCATION,
            ISNULL(MONEY_DEPARTMENT,0) MONEY_DEPARTMENT,
			ISNULL(PRICE_PROTECTION_MONEY_DEPARTMENT,0) PRICE_PROTECTION_MONEY_DEPARTMENT,
			ISNULL(PRICE_PROTECTION_DEPARTMENT,0) PRICE_PROTECTION_DEPARTMENT,
			ISNULL(STANDARD_COST_DEPARTMENT,0) STANDARD_COST_DEPARTMENT,
			ISNULL(STANDARD_COST_RATE_DEPARTMENT,0) STANDARD_COST_RATE_DEPARTMENT,
			ISNULL(STANDARD_COST_MONEY_DEPARTMENT,0) STANDARD_COST_MONEY_DEPARTMENT,
			ISNULL(ACTION_ID,0) ACTION_ID,
			ISNULL(ACTION_TYPE,0) ACTION_TYPE,
			ISNULL(ACTION_ROW_ID,0) ACTION_ROW_ID,
			ACTION_PERIOD_ID,
			DUE_DATE,
			PHYSICAL_DATE,
			ISNULL(DUE_DATE_LOCATION,0) DUE_DATE_LOCATION,
			ISNULL(PHYSICAL_DATE_LOCATION,0) PHYSICAL_DATE_LOCATION,
            ISNULL(DUE_DATE_DEPARTMENT,0) DUE_DATE_DEPARTMENT,
			ISNULL(PHYSICAL_DATE_DEPARTMENT,0) PHYSICAL_DATE_DEPARTMENT,
			RECORD_DATE,
			ACTION_AMOUNT,
			ACTION_DATE,
			ACTION_DUE_DATE,
			DEPARTMENT_ID,
			LOCATION_ID,
			ISNULL(PURCHASE_NET_SYSTEM_MONEY_2_LOCATION,0) PURCHASE_NET_SYSTEM_MONEY_2_LOCATION,
            ISNULL(PURCHASE_NET_SYSTEM_MONEY_2_DEPARTMENT,0) PURCHASE_NET_SYSTEM_MONEY_2_DEPARTMENT,
			ACTION_PROCESS_CAT_ID,
			ACTION_PROCESS_TYPE,
			ISNULL(STATION_REFLECTION_COST_SYSTEM,0) STATION_REFLECTION_COST_SYSTEM,
            ISNULL(LABOR_COST_SYSTEM,0) LABOR_COST_SYSTEM,
            ISNULL(STATION_REFLECTION_COST_SYSTEM_DEPARTMENT,0) STATION_REFLECTION_COST_SYSTEM_DEPARTMENT,
            ISNULL(LABOR_COST_SYSTEM_DEPARTMENT,0) LABOR_COST_SYSTEM_DEPARTMENT,
            ISNULL(STATION_REFLECTION_COST_SYSTEM_LOCATION,0) STATION_REFLECTION_COST_SYSTEM_LOCATION,
            ISNULL(LABOR_COST_SYSTEM_LOCATION,0) LABOR_COST_SYSTEM_LOCATION,
            ISNULL(STATION_REFLECTION_COST,0) STATION_REFLECTION_COST,
            ISNULL(STATION_REFLECTION_COST_SYSTEM_2,0) STATION_REFLECTION_COST_SYSTEM_2,
            ISNULL(STATION_REFLECTION_COST_LOCATION,0) STATION_REFLECTION_COST_LOCATION,
            ISNULL(STATION_REFLECTION_COST_SYSTEM_2_LOCATION,0) STATION_REFLECTION_COST_SYSTEM_2_LOCATION,
            ISNULL(STATION_REFLECTION_COST_DEPARTMENT,0) STATION_REFLECTION_COST_DEPARTMENT,
            ISNULL(STATION_REFLECTION_COST_SYSTEM_2_DEPARTMENT,0) STATION_REFLECTION_COST_SYSTEM_2_DEPARTMENT,
            ISNULL(LABOR_COST,0) LABOR_COST,
            ISNULL(LABOR_COST_SYSTEM_2,0) LABOR_COST_SYSTEM_2,
            ISNULL(LABOR_COST_LOCATION,0) LABOR_COST_LOCATION,
            ISNULL(LABOR_COST_SYSTEM_2_LOCATION,0) LABOR_COST_SYSTEM_2_LOCATION,
            ISNULL(LABOR_COST_DEPARTMENT,0) LABOR_COST_DEPARTMENT,
            ISNULL(LABOR_COST_SYSTEM_2_DEPARTMENT,0) LABOR_COST_SYSTEM_2_DEPARTMENT
		FROM
			PRODUCT_COST 
		WHERE
			PRODUCT_ID = #arguments.newer_product_id# <!--- <cfqueryparam value="#arguments.newer_product_id#" cfsqltype="cf_sql_integer"> --->
			<cfif len(arguments.newer_spec_main_id)>
				AND SPECT_MAIN_ID = #arguments.newer_spec_main_id# <!--- <cfqueryparam value="#arguments.newer_spec_main_id#" cfsqltype="cf_sql_integer"> --->
			<cfelse>
				AND ISNULL(IS_SPEC,0)=0
			</cfif>
			<cfif isdefined("arguments.newer_stock_id") and len(arguments.newer_stock_id)>
				AND STOCK_ID = #arguments.newer_stock_id# <!--- <cfqueryparam value="#arguments.newer_spec_main_id#" cfsqltype="cf_sql_integer"> --->
			<cfelse>
				AND STOCK_ID IS NULL
			</cfif>
			<cfif isdefined('arguments.newer_action_row_id') and arguments.newer_action_row_id gt 0>
				AND ISNULL(ACTION_ROW_ID,0) <> #arguments.newer_action_row_id# <!--- <cfqueryparam value="#arguments.newer_action_row_id#" cfsqltype="cf_sql_integer"> --->
			<cfelseif isdefined('arguments.newer_product_cost_id') and arguments.newer_product_cost_id gt 0>
				AND PRODUCT_COST_ID <> #arguments.newer_product_cost_id# <!--- <cfqueryparam value="#arguments.newer_product_cost_id#" cfsqltype="cf_sql_integer"> --->
			<cfelse>
				AND ISNULL(ACTION_ID,0) <> #arguments.newer_action_id# <!--- <cfqueryparam value="#arguments.newer_action_id#" cfsqltype="cf_sql_integer"> --->
			</cfif>
            AND ISNULL(ACTION_TYPE,0) <> -1 <!--- Excelden oluştulan maliyetler güncellenmesin! --->
			<!--- AND ACTION_ID IS NOT NULL ELLE EKLENEN MALİYET GUNCELLENMESİN DİYE eklenmişti kaldırıldı  --->
			AND (
					START_DATE > #CreateODBCDate(arguments.newer_action_date)# <!--- <cfqueryparam value="#CreateODBCDate(arguments.newer_action_date)#" cfsqltype="cf_sql_date"> --->
				OR
					(START_DATE = #CreateODBCDate(arguments.newer_action_date)# AND<!--- <cfqueryparam value="#CreateODBCDate(arguments.newer_action_date)#" cfsqltype="cf_sql_date"> ---> 
                    RECORD_DATE > #CreateODBCDateTime(arguments.newer_record_date)#
					 <!--- RECORD_DATE >#CreateODBCDate(arguments.newer_record_date)# --->
					<cfif arguments.newer_action_id gt 0>AND ACTION_ID <> #arguments.newer_action_id# <!--- <cfqueryparam value="#arguments.newer_action_id#" cfsqltype="cf_sql_integer"> ---></cfif>
					<cfif isdefined('arguments.newer_product_cost_id') and arguments.newer_product_cost_id gt 0>AND PRODUCT_COST_ID <> #arguments.newer_product_cost_id#<!--- <cfqueryparam value="#arguments.newer_product_cost_id#" cfsqltype="cf_sql_integer"> ---></cfif>
					)
				)
			AND ACTION_PERIOD_ID IN (#arguments.newer_comp_period_list#)
		ORDER BY 
			START_DATE,RECORD_DATE,PRODUCT_COST_ID
	</cfquery>
	<cfif GET_NEWER_P_COSTS.RECORDCOUNT>
		<cfloop query="GET_NEWER_P_COSTS">
			<cfif len(GET_NEWER_P_COSTS.ACTION_PROCESS_CAT_ID)>
				<cfquery name="GET_PROCESS_NEWER_COST" datasource="#DSN3#"><!--- Kategoriye göre maliyetin oluşturma özellikleri çekiliyor. --->
					SELECT 
						PROCESS_TYPE,
						IS_COST,
						IS_COST_ZERO_ROW,
						IS_COST_FIELD
					FROM
						SETUP_PROCESS_CAT 
					WHERE 
						PROCESS_CAT_ID = <cfqueryparam value="#GET_NEWER_P_COSTS.ACTION_PROCESS_CAT_ID#" cfsqltype="cf_sql_integer">
				</cfquery>
			<cfelse>
				<cfset GET_PROCESS_NEWER_COST.RECORDCOUNT=0>
			</cfif>
			<cfif GET_PROCESS_NEWER_COST.RECORDCOUNT>
				<cfset is_cost_field_newer = GET_PROCESS_NEWER_COST.IS_COST_FIELD>
				<cfset is_cost_zero_row_newer = GET_PROCESS_NEWER_COST.IS_COST_ZERO_ROW>
			<cfelse>
				<cfset is_cost_field_newer = 0>
				<cfset is_cost_zero_row_newer = 1>
			</cfif>
			<cfset "cost_date_#PRODUCT_COST_ID#" = dateformat(GET_NEWER_P_COSTS.START_DATE,dateformat_style)>
			<cf_date tarih = 'cost_date_#PRODUCT_COST_ID#'>	
			<cfscript>
				if(len(GET_NEWER_P_COSTS.ACTION_PERIOD_ID))
				{
					period_year_=listgetat(arguments.newer_comp_period_year_list,listfind(arguments.newer_comp_period_list,GET_NEWER_P_COSTS.ACTION_PERIOD_ID,','));
					newer_period_dsn='#arguments.newer_dsn#_#period_year_#_#arguments.newer_our_company_id#';
				}else{
					newer_period_dsn=arguments.newer_period_dsn_type;
				}
				if(len(GET_NEWER_P_COSTS.SPECT_MAIN_ID))
					{
						"maliyet_#PRODUCT_COST_ID#" = get_product_stock_cost(
															is_product_stock:1,
															product_stock_id:GET_NEWER_P_COSTS.PRODUCT_ID,
															tax_inc:0,
															cost_method:GET_NEWER_P_COSTS.INVENTORY_CALC_TYPE,
															cost_date:evaluate('cost_date_#PRODUCT_COST_ID#'),
															cost_money:GET_NEWER_P_COSTS.MONEY,
															action_id=GET_NEWER_P_COSTS.ACTION_ID,
															action_row_id=GET_NEWER_P_COSTS.ACTION_ROW_ID,
															action_type=GET_NEWER_P_COSTS.ACTION_TYPE,
															spec_main_id=GET_NEWER_P_COSTS.SPECT_MAIN_ID,
															stock_id=GET_NEWER_P_COSTS.STOCK_ID,
															period_dsn_type=newer_period_dsn,
															action_comp_period_list='#comp_period_list#',
															action_cost_id=GET_NEWER_P_COSTS.PRODUCT_COST_ID,
															cost_money_system : GET_NEWER_P_COSTS.PURCHASE_NET_SYSTEM_MONEY,
															cost_money_system_2 : GET_NEWER_P_COSTS.PURCHASE_NET_SYSTEM_MONEY_2,
															is_cost_zero_row :  is_cost_zero_row_newer,
															is_cost_field : is_cost_field_newer,
															is_cost_calc_type : comp_cost_calc_type
													);
					}else{
						"maliyet_#PRODUCT_COST_ID#" = get_product_stock_cost(
															is_product_stock : 1,
															product_stock_id : GET_NEWER_P_COSTS.PRODUCT_ID,
															tax_inc : 0,
															cost_method : GET_NEWER_P_COSTS.INVENTORY_CALC_TYPE,
															cost_date : evaluate('cost_date_#PRODUCT_COST_ID#'),
															cost_money : GET_NEWER_P_COSTS.MONEY,
															action_id : GET_NEWER_P_COSTS.ACTION_ID,
															stock_id=GET_NEWER_P_COSTS.STOCK_ID,
															action_row_id : GET_NEWER_P_COSTS.ACTION_ROW_ID,
															action_type : GET_NEWER_P_COSTS.ACTION_TYPE,
															period_dsn_type : newer_period_dsn,
															action_comp_period_list : '#comp_period_list#',
															action_cost_id : GET_NEWER_P_COSTS.PRODUCT_COST_ID,
															cost_money_system : GET_NEWER_P_COSTS.PURCHASE_NET_SYSTEM_MONEY,
															cost_money_system_2 : GET_NEWER_P_COSTS.PURCHASE_NET_SYSTEM_MONEY_2,
															is_cost_zero_row :  is_cost_zero_row_newer,
															is_cost_field : is_cost_field_newer,
															is_cost_calc_type : comp_cost_calc_type
															);
					}
					"alis_net_fiyat_#PRODUCT_COST_ID#" = "#listfirst(evaluate('maliyet_#PRODUCT_COST_ID#'),';')#";
					"alis_ek_maliyet_#PRODUCT_COST_ID#" = "#listgetat(evaluate('maliyet_#PRODUCT_COST_ID#'),2,';')#";
					"alis_net_fiyat_system_#PRODUCT_COST_ID#" = "#listgetat(evaluate('maliyet_#PRODUCT_COST_ID#'),4,';')#";
					"alis_ek_maliyet_system_#PRODUCT_COST_ID#" = "#listgetat(evaluate('maliyet_#PRODUCT_COST_ID#'),5,';')#";
					"alis_net_fiyat_system_2_#PRODUCT_COST_ID#" = "#listgetat(evaluate('maliyet_#PRODUCT_COST_ID#'),6,';')#";
					"alis_ek_maliyet_system_2_#PRODUCT_COST_ID#" = "#listgetat(evaluate('maliyet_#PRODUCT_COST_ID#'),7,';')#";
					"mevcut_son_alislar_#PRODUCT_COST_ID#" = "#listgetat(evaluate('maliyet_#PRODUCT_COST_ID#'),3,';')#";
					
					"mevcut_son_alislar_lokasyon_#PRODUCT_COST_ID#" = "#listgetat(evaluate('maliyet_#PRODUCT_COST_ID#'),8,';')#";
					"alis_net_fiyat_lokasyon_#PRODUCT_COST_ID#" = "#listgetat(evaluate('maliyet_#PRODUCT_COST_ID#'),9,';')#";
					"alis_ek_maliyet_lokasyon_#PRODUCT_COST_ID#" = "#listgetat(evaluate('maliyet_#PRODUCT_COST_ID#'),10,';')#";
					"alis_net_fiyat_system_lokasyon_#PRODUCT_COST_ID#" = "#listgetat(evaluate('maliyet_#PRODUCT_COST_ID#'),11,';')#";
					"alis_ek_maliyet_system_lokasyon_#PRODUCT_COST_ID#" = "#listgetat(evaluate('maliyet_#PRODUCT_COST_ID#'),12,';')#";
					"alis_net_fiyat_system_2_lokasyon_#PRODUCT_COST_ID#" = "#listgetat(evaluate('maliyet_#PRODUCT_COST_ID#'),13,';')#";
					"alis_ek_maliyet_system_2_lokasyon_#PRODUCT_COST_ID#" = "#listgetat(evaluate('maliyet_#PRODUCT_COST_ID#'),14,';')#";
					if(listlen(evaluate('maliyet_#PRODUCT_COST_ID#'),';') gt 14) "satir_fiyat_tutar_#PRODUCT_COST_ID#"="#listgetat(evaluate('maliyet_#PRODUCT_COST_ID#'),15,';')#";
					
					"mevcut_son_alislar_department_#PRODUCT_COST_ID#" = "#listgetat(evaluate('maliyet_#PRODUCT_COST_ID#'),17,';')#";
					"alis_net_fiyat_department_#PRODUCT_COST_ID#" = "#listgetat(evaluate('maliyet_#PRODUCT_COST_ID#'),18,';')#";
					"alis_ek_maliyet_department_#PRODUCT_COST_ID#" = "#listgetat(evaluate('maliyet_#PRODUCT_COST_ID#'),19,';')#";
					"alis_net_fiyat_system_department_#PRODUCT_COST_ID#" = "#listgetat(evaluate('maliyet_#PRODUCT_COST_ID#'),20,';')#";
					"alis_ek_maliyet_system_department_#PRODUCT_COST_ID#" = "#listgetat(evaluate('maliyet_#PRODUCT_COST_ID#'),21,';')#";
					"alis_net_fiyat_system_2_department_#PRODUCT_COST_ID#" = "#listgetat(evaluate('maliyet_#PRODUCT_COST_ID#'),22,';')#";
					"alis_ek_maliyet_system_2_department_#PRODUCT_COST_ID#" = "#listgetat(evaluate('maliyet_#PRODUCT_COST_ID#'),23,';')#";

					"alis_reflection_maliyet_#PRODUCT_COST_ID#" = "#listgetat(evaluate('maliyet_#PRODUCT_COST_ID#'),24,';')#";
					"alis_labor_maliyet_#PRODUCT_COST_ID#" = "#listgetat(evaluate('maliyet_#PRODUCT_COST_ID#'),25,';')#";
					"alis_reflection_maliyet_lokasyon_#PRODUCT_COST_ID#" = "#listgetat(evaluate('maliyet_#PRODUCT_COST_ID#'),26,';')#";
					"alis_labor_maliyet_lokasyon_#PRODUCT_COST_ID#" = "#listgetat(evaluate('maliyet_#PRODUCT_COST_ID#'),27,';')#";
					"alis_reflection_maliyet_department_#PRODUCT_COST_ID#" = "#listgetat(evaluate('maliyet_#PRODUCT_COST_ID#'),28,';')#";
					"alis_labor_maliyet_department_#PRODUCT_COST_ID#" = "#listgetat(evaluate('maliyet_#PRODUCT_COST_ID#'),29,';')#";
					
					"alis_reflection_maliyet_system_#PRODUCT_COST_ID#" = "#listgetat(evaluate('maliyet_#PRODUCT_COST_ID#'),30,';')#";
					"alis_labor_maliyet_system_#PRODUCT_COST_ID#" = "#listgetat(evaluate('maliyet_#PRODUCT_COST_ID#'),31,';')#";
					"alis_reflection_maliyet_system_lokasyon_#PRODUCT_COST_ID#" = "#listgetat(evaluate('maliyet_#PRODUCT_COST_ID#'),32,';')#";
					"alis_labor_maliyet_system_lokasyon_#PRODUCT_COST_ID#" = "#listgetat(evaluate('maliyet_#PRODUCT_COST_ID#'),33,';')#";
					"alis_reflection_maliyet_system_department_#PRODUCT_COST_ID#" = "#listgetat(evaluate('maliyet_#PRODUCT_COST_ID#'),34,';')#";
					"alis_labor_maliyet_system_department_#PRODUCT_COST_ID#" = "#listgetat(evaluate('maliyet_#PRODUCT_COST_ID#'),35,';')#";
					
					"alis_reflection_maliyet_system_2_#PRODUCT_COST_ID#" = "#listgetat(evaluate('maliyet_#PRODUCT_COST_ID#'),36,';')#";
					"alis_labor_maliyet_system_2_#PRODUCT_COST_ID#" = "#listgetat(evaluate('maliyet_#PRODUCT_COST_ID#'),37,';')#";
					"alis_reflection_maliyet_system_2_lokasyon_#PRODUCT_COST_ID#" = "#listgetat(evaluate('maliyet_#PRODUCT_COST_ID#'),38,';')#";
					"alis_labor_maliyet_system_2_lokasyon_#PRODUCT_COST_ID#" = "#listgetat(evaluate('maliyet_#PRODUCT_COST_ID#'),39,';')#";
					"alis_reflection_maliyet_system_2_department_#PRODUCT_COST_ID#" = "#listgetat(evaluate('maliyet_#PRODUCT_COST_ID#'),40,';')#";
					"alis_labor_maliyet_system_2_department_#PRODUCT_COST_ID#" = "#listgetat(evaluate('maliyet_#PRODUCT_COST_ID#'),41,';')#";

					
					if(not len(GET_NEWER_P_COSTS.STANDARD_COST))GET_NEWER_P_COSTS.STANDARD_COST=0;
					if(not len(GET_NEWER_P_COSTS.PRICE_PROTECTION))GET_NEWER_P_COSTS.PRICE_PROTECTION=0;
					if(not len(GET_NEWER_P_COSTS.STANDARD_COST_RATE))GET_NEWER_P_COSTS.STANDARD_COST_RATE=0;
					if(not len(GET_NEWER_P_COSTS.PRICE_PROTECTION_TYPE))GET_NEWER_P_COSTS.PRICE_PROTECTION_TYPE=1;//tip gelmiyorsa malyiet düşürmek içindir düzenleme tutarı
					//writeoutput('Ürünün Maliyeti Oluşturuluyor..#evaluate("alis_net_fiyat_system_#PRODUCT_COST_ID#")# <br/>');
			</cfscript>
			<!--- burda işlem kategoresine göre 0 sa maliyet kaydedecekmi etmeyecekmi belirlenmelii --->
			<cfif evaluate('maliyet_#PRODUCT_COST_ID#') neq 'YOK'><!--- and listfirst(evaluate('maliyet_#PRODUCT_COST_ID#'),';') gt 0 --->
				<!--- stok miktarlarida guncellenmeli --->
				<cfquery name="GET_SEVK" datasource="#newer_period_dsn#">
					SELECT 
						SUM(STOCK_OUT-STOCK_IN) AS MIKTAR 
					FROM 
						STOCKS_ROW 
					WHERE
						PRODUCT_ID = #arguments.newer_product_id# AND
						<cfif isdefined('arguments.newer_spec_main_id') and len(arguments.newer_spec_main_id)>
							SPECT_VAR_ID=#arguments.newer_spec_main_id# AND
						<cfelse>
							(SPECT_VAR_ID IS NULL OR SPECT_VAR_ID = 0) AND
						</cfif>
						PROCESS_TYPE = 81 AND
						PROCESS_DATE <= #evaluate('cost_date_#PRODUCT_COST_ID#')#
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
				<!--- fiyat koruma degerleri ve sabit maliyet girilmiş ise degerleri kaybetmemesi için çünkü yeni hesaplanan degerlere göre --->
				<cfscript>
					upd_func_rate_list=get_cost_rate(action_id:GET_NEWER_P_COSTS.ACTION_ID,session_period_id:GET_NEWER_P_COSTS.ACTION_PERIOD_ID,action_type:GET_NEWER_P_COSTS.ACTION_TYPE,action_date:createodbcdate(GET_NEWER_P_COSTS.START_DATE) ,dsn_period_money:newer_period_dsn ,dsn_money:#arguments.newer_dsn#);
					if(GET_NEWER_P_COSTS.PRICE_PROTECTION gt 0 and listfind(upd_func_rate_list,GET_NEWER_P_COSTS.PRICE_PROTECTION_MONEY,';'))	
					{
						prc_protec_sys = (GET_NEWER_P_COSTS.PRICE_PROTECTION*listgetat(upd_func_rate_list,listfind(upd_func_rate_list,GET_NEWER_P_COSTS.PRICE_PROTECTION_MONEY,';')-1,';'))*GET_NEWER_P_COSTS.PRICE_PROTECTION_TYPE;
						prc_protec = prc_protec_sys/listgetat(upd_func_rate_list,listfind(upd_func_rate_list,GET_NEWER_P_COSTS.MONEY,';')-1,';');
						prc_protec_sys_2 = prc_protec_sys/listgetat(upd_func_rate_list,listfind(upd_func_rate_list,GET_NEWER_P_COSTS.PURCHASE_NET_SYSTEM_MONEY_2,';')-1,';');
					}else
					{
						prc_protec_sys = 0;
						prc_protec = 0;
						prc_protec_sys_2 = 0;
					}
				//	writeoutput('sonuc:#prc_protec_sys#-#GET_NEWER_P_COSTS.PRICE_PROTECTION#-#listgetat(upd_func_rate_list,listfind(upd_func_rate_list,GET_NEWER_P_COSTS.PRICE_PROTECTION_MONEY,';')-1,';')#-#GET_NEWER_P_COSTS.PRICE_PROTECTION_TYPE#');
					
					if(GET_NEWER_P_COSTS.STANDARD_COST gt 0 and listfind(upd_func_rate_list,GET_NEWER_P_COSTS.STANDARD_COST_MONEY,';'))	
					{
						std_cost_sys=GET_NEWER_P_COSTS.STANDARD_COST*listgetat(upd_func_rate_list,listfind(upd_func_rate_list,GET_NEWER_P_COSTS.STANDARD_COST_MONEY,';')-1,';');
						std_cost=std_cost_sys/listgetat(upd_func_rate_list,listfind(upd_func_rate_list,GET_NEWER_P_COSTS.MONEY,';')-1,';');
						std_cost_sys_2=std_cost_sys/listgetat(upd_func_rate_list,listfind(upd_func_rate_list,GET_NEWER_P_COSTS.PURCHASE_NET_SYSTEM_MONEY_2,';')-1,';');
					}else
					{
						std_cost_sys = 0;
						std_cost = 0;
						std_cost_sys_2 = 0;
					}
					
					//lokasyon
					if(GET_NEWER_P_COSTS.PRICE_PROTECTION_LOCATION gt 0 and listfind(upd_func_rate_list,GET_NEWER_P_COSTS.PRICE_PROTECTION_MONEY_LOCATION,';'))	
					{
						prc_protec_sys_loc = (GET_NEWER_P_COSTS.PRICE_PROTECTION_LOCATION*listgetat(upd_func_rate_list,listfind(upd_func_rate_list,GET_NEWER_P_COSTS.PRICE_PROTECTION_MONEY_LOCATION,';')-1,';'))*GET_NEWER_P_COSTS.PRICE_PROTECTION_TYPE;
						prc_protec_loc = prc_protec_sys_loc/listgetat(upd_func_rate_list,listfind(upd_func_rate_list,GET_NEWER_P_COSTS.MONEY_LOCATION,';')-1,';');
						prc_protec_sys_2_loc = prc_protec_sys_loc/listgetat(upd_func_rate_list,listfind(upd_func_rate_list,GET_NEWER_P_COSTS.PURCHASE_NET_SYSTEM_MONEY_2_LOCATION,';')-1,';');
					}else
					{
						prc_protec_sys_loc = 0;
						prc_protec_loc = 0;
						prc_protec_sys_2_loc = 0;
					}
					if(GET_NEWER_P_COSTS.STANDARD_COST_LOCATION gt 0 and listfind(upd_func_rate_list,GET_NEWER_P_COSTS.STANDARD_COST_MONEY_LOCATION,';'))	
					{
						std_cost_sys_loc = GET_NEWER_P_COSTS.STANDARD_COST_LOCATION*listgetat(upd_func_rate_list,listfind(upd_func_rate_list,GET_NEWER_P_COSTS.STANDARD_COST_MONEY_LOCATION,';')-1,';');
						std_cost_loc = std_cost_sys_loc/listgetat(upd_func_rate_list,listfind(upd_func_rate_list,GET_NEWER_P_COSTS.MONEY_LOCATION,';')-1,';');
						std_cost_sys_2_loc = std_cost_sys_loc/listgetat(upd_func_rate_list,listfind(upd_func_rate_list,GET_NEWER_P_COSTS.PURCHASE_NET_SYSTEM_MONEY_2_LOCATION,';')-1,';');
					}else
					{
						std_cost_sys_loc = 0;
						std_cost_loc = 0;
						std_cost_sys_2_loc = 0;
					}
					
					//department
					if(GET_NEWER_P_COSTS.PRICE_PROTECTION_DEPARTMENT gt 0 and listfind(upd_func_rate_list,GET_NEWER_P_COSTS.PRICE_PROTECTION_MONEY_DEPARTMENT,';'))	
					{
						prc_protec_sys_dep = (GET_NEWER_P_COSTS.PRICE_PROTECTION_DEPARTMENT*listgetat(upd_func_rate_list,listfind(upd_func_rate_list,GET_NEWER_P_COSTS.PRICE_PROTECTION_MONEY_DEPARTMENT,';')-1,';'))*GET_NEWER_P_COSTS.PRICE_PROTECTION_TYPE;
						prc_protec_dep = prc_protec_sys_dep/listgetat(upd_func_rate_list,listfind(upd_func_rate_list,GET_NEWER_P_COSTS.MONEY_DEPARTMENT,';')-1,';');
						prc_protec_sys_2_dep = prc_protec_sys_dep/listgetat(upd_func_rate_list,listfind(upd_func_rate_list,GET_NEWER_P_COSTS.PURCHASE_NET_SYSTEM_MONEY_2_DEPARTMENT,';')-1,';');
					}else
					{
						prc_protec_sys_dep = 0;
						prc_protec_dep = 0;
						prc_protec_sys_2_dep = 0;
					}
					//writeoutput('depo #prc_protec_sys_dep#-#prc_protec_dep#');
					if(GET_NEWER_P_COSTS.STANDARD_COST_DEPARTMENT gt 0 and listfind(upd_func_rate_list,GET_NEWER_P_COSTS.STANDARD_COST_MONEY_DEPARTMENT,';'))	
					{
						std_cost_sys_dep = GET_NEWER_P_COSTS.STANDARD_COST_DEPARTMENT*listgetat(upd_func_rate_list,listfind(upd_func_rate_list,GET_NEWER_P_COSTS.STANDARD_COST_MONEY_DEPARTMENT,';')-1,';');
						std_cost_dep = std_cost_sys_dep/listgetat(upd_func_rate_list,listfind(upd_func_rate_list,GET_NEWER_P_COSTS.MONEY_DEPARTMENT,';')-1,';');
						std_cost_sys_2_dep = std_cost_sys_dep/listgetat(upd_func_rate_list,listfind(upd_func_rate_list,GET_NEWER_P_COSTS.PURCHASE_NET_SYSTEM_MONEY_2_DEPARTMENT,';')-1,';');
					}else
					{
						std_cost_sys_dep = 0;
						std_cost_dep = 0;
						std_cost_sys_2_dep = 0;
					}
					//writeoutput('Fiyat Koruma ve Sabit Maliyetler Sonrasında ki Ürünün Maliyeti :#evaluate("alis_net_fiyat_system_#PRODUCT_COST_ID#")# <br/>');
				</cfscript>
				<cfquery name="GET_COST_FOR_ALL" datasource="#FORM.DSN1#">
                    SELECT 
						DUE_DATE,
						DUE_DATE_LOCATION,
						PURCHASE_NET_SYSTEM+PURCHASE_EXTRA_COST_SYSTEM PROD_COST,
						PHYSICAL_DATE,
						PHYSICAL_DATE_LOCATION,
						START_DATE,
						RECORD_DATE,
						DEPARTMENT_ID,
						LOCATION_ID,
						PRODUCT_COST_ID
					FROM
						PRODUCT_COST
					WHERE
						PRODUCT_ID = <cfqueryparam value="#GET_NEWER_P_COSTS.PRODUCT_ID#" cfsqltype="cf_sql_integer">
						<cfif isdefined('GET_NEWER_P_COSTS.SPEC_MAIN_ID') and len(GET_NEWER_P_COSTS.SPEC_MAIN_ID)>
							AND SPECT_MAIN_ID = <cfqueryparam value="#GET_NEWER_P_COSTS.SPEC_MAIN_ID#" cfsqltype="cf_sql_integer">
						<cfelse>
							AND IS_SPEC=0
						</cfif>
						<cfif isdefined('GET_NEWER_P_COSTS.STOCK_ID') and len(GET_NEWER_P_COSTS.STOCK_ID)>
							AND STOCK_ID = <cfqueryparam value="#GET_NEWER_P_COSTS.STOCK_ID#" cfsqltype="cf_sql_integer">
						<cfelse>
							AND STOCK_ID IS NULL
						</cfif>
						AND ACTION_PERIOD_ID IN (#arguments.newer_comp_period_list#)	
						AND 

						(
						<!--- aynı gune eklenmis bir belge olabilir ancak kayit tarihi farkli olabilir --->
							(
								START_DATE < <cfqueryparam value="#createodbcdatetime(GET_NEWER_P_COSTS.START_DATE)#" cfsqltype="cf_sql_timestamp">
							)
							OR
							(
								START_DATE = <cfqueryparam value="#createodbcdatetime(GET_NEWER_P_COSTS.START_DATE)#" cfsqltype="cf_sql_timestamp">
								AND RECORD_DATE < <cfqueryparam value="#createodbcdatetime(GET_NEWER_P_COSTS.RECORD_DATE)#" cfsqltype="cf_sql_timestamp">
							)
						)
				</cfquery>
				<cfif GET_NEWER_P_COSTS.ACTION_ID gt 0> <!--- elle eklenen maliyetlerde finansal ve fiziksel yaşı taşımalı--->
					<cfif len(GET_NEWER_P_COSTS.DUE_DATE)><!--- finansal yaş sadece alım faturalarında ve açılış stok fişlerinde çalışacak burdada işlem tipini bilmediğimdan güncellenen maliyetde due_date varsa zaten bunlardan biridir--->
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
								DEPARTMENT_ID <cfif len(GET_NEWER_P_COSTS.DEPARTMENT_ID)>= #GET_NEWER_P_COSTS.DEPARTMENT_ID#<cfelse>IS NULL</cfif> AND
								LOCATION_ID <cfif len(GET_NEWER_P_COSTS.LOCATION_ID)>= #GET_NEWER_P_COSTS.LOCATION_ID#<cfelse>IS NULL</cfif> AND
								DUE_DATE IS NOT NULL
							ORDER BY
								START_DATE DESC,
								RECORD_DATE DESC,
								PRODUCT_COST_ID DESC
						</cfquery>
                        <cfquery name="GET_COST_FOR_DUE_DEPARTMENT" dbtype="query">
							SELECT 
								DUE_DATE_LOCATION COST_DUE_DATE,
								PROD_COST
							FROM
								GET_COST_FOR_ALL
							WHERE
								DEPARTMENT_ID <cfif len(GET_NEWER_P_COSTS.DEPARTMENT_ID)>= #GET_NEWER_P_COSTS.DEPARTMENT_ID#<cfelse>IS NULL</cfif> AND
								DUE_DATE IS NOT NULL
							ORDER BY
								START_DATE DESC,
								RECORD_DATE DESC,
								PRODUCT_COST_ID DESC
						</cfquery>
					<cfelse>
						<cfset GET_COST_FOR_DUE.RECORDCOUNT=0>
						<cfset GET_COST_FOR_DUE_LOCATION.RECORDCOUNT=0>
						<cfset GET_COST_FOR_DUE_DEPARTMENT.RECORDCOUNT=0>
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
							DEPARTMENT_ID <cfif len(GET_NEWER_P_COSTS.DEPARTMENT_ID)>= #GET_NEWER_P_COSTS.DEPARTMENT_ID#<cfelse>IS NULL</cfif> AND
							LOCATION_ID <cfif len(GET_NEWER_P_COSTS.LOCATION_ID)>= #GET_NEWER_P_COSTS.LOCATION_ID#<cfelse>IS NULL</cfif> AND
							PHYSICAL_DATE IS NOT NULL
						ORDER BY
							START_DATE DESC,
							RECORD_DATE DESC,
							PRODUCT_COST_ID DESC
					</cfquery>
                    <cfquery name="GET_COST_FOR_PHYSICAL_DEPARTMENT" dbtype="query">
						SELECT 
							PHYSICAL_DATE_LOCATION COST_PHYSICAL_DATE,
							PROD_COST
						FROM
							GET_COST_FOR_ALL
						WHERE
							DEPARTMENT_ID <cfif len(GET_NEWER_P_COSTS.DEPARTMENT_ID)>= #GET_NEWER_P_COSTS.DEPARTMENT_ID#<cfelse>IS NULL</cfif> AND
							PHYSICAL_DATE IS NOT NULL
						ORDER BY
							START_DATE DESC,
							RECORD_DATE DESC,
							PRODUCT_COST_ID DESC
					</cfquery>
					<cfscript>
						if(GET_COST_FOR_DUE.RECORDCOUNT gt 0 and len(GET_NEWER_P_COSTS.DUE_DATE) and isdefined('GET_NEWER_P_COSTS.DUE_DATE') and isdefined('GET_NEWER_P_COSTS.ACTION_DATE'))// sadece bu alanlar geliyorsa girsin değerler fatura tipinde geliyor
						{
							if(GET_COST_FOR_DUE.RECORDCOUNT and isdate(GET_COST_FOR_DUE.COST_DUE_DATE))
								due=dateformat(GET_COST_FOR_DUE.COST_DUE_DATE,dateformat_style);
							else
								due=dateformat(GET_NEWER_P_COSTS.ACTION_DATE,dateformat_style);
								
							'due_date_#PRODUCT_COST_ID#'=
								duedate_action(
									duedate: due,
									stock_amount:evaluate('mevcut_son_alislar_#PRODUCT_COST_ID#')-GET_NEWER_P_COSTS.ACTION_AMOUNT,
									stock_value:iif(GET_COST_FOR_DUE.RECORDCOUNT,GET_COST_FOR_DUE.PROD_COST,0),
									action_date:dateformat(GET_NEWER_P_COSTS.ACTION_DATE,dateformat_style),
									action_duedate:GET_NEWER_P_COSTS.ACTION_DUE_DATE,
									action_amount:GET_NEWER_P_COSTS.ACTION_AMOUNT,
									action_value:evaluate('satir_fiyat_tutar_#PRODUCT_COST_ID#')
								);
							
							if(GET_COST_FOR_DUE_LOCATION.RECORDCOUNT and isdate(GET_COST_FOR_DUE_LOCATION.COST_DUE_DATE))
								due_lokasyon=dateformat(GET_COST_FOR_DUE_LOCATION.COST_DUE_DATE,dateformat_style);
							else
								due_lokasyon=dateformat(GET_NEWER_P_COSTS.ACTION_DATE,dateformat_style);
							'due_date_location_#PRODUCT_COST_ID#'=
								duedate_action(
									duedate: due_lokasyon,
									stock_amount:evaluate('mevcut_son_alislar_lokasyon_#PRODUCT_COST_ID#')-GET_NEWER_P_COSTS.ACTION_AMOUNT,
									stock_value:iif(GET_COST_FOR_DUE_LOCATION.RECORDCOUNT,GET_COST_FOR_DUE_LOCATION.PROD_COST,0),
									action_date:dateformat(GET_NEWER_P_COSTS.ACTION_DATE,dateformat_style),
									action_duedate:GET_NEWER_P_COSTS.ACTION_DUE_DATE,
									action_amount:GET_NEWER_P_COSTS.ACTION_AMOUNT,
									action_value:evaluate('satir_fiyat_tutar_#PRODUCT_COST_ID#')
								);
								
							if(GET_COST_FOR_DUE_DEPARTMENT.RECORDCOUNT and isdate(GET_COST_FOR_DUE_DEPARTMENT.COST_DUE_DATE))
								due_department=dateformat(GET_COST_FOR_DUE_DEPARTMENT.COST_DUE_DATE,dateformat_style);
							else
								due_department=dateformat(GET_NEWER_P_COSTS.ACTION_DATE,dateformat_style);
							'due_date_department_#PRODUCT_COST_ID#'=
								duedate_action(
									duedate: due_department,
									stock_amount:evaluate('mevcut_son_alislar_department_#PRODUCT_COST_ID#')-GET_NEWER_P_COSTS.ACTION_AMOUNT,
									stock_value:iif(GET_COST_FOR_DUE_DEPARTMENT.RECORDCOUNT,GET_COST_FOR_DUE_DEPARTMENT.PROD_COST,0),
									action_date:dateformat(GET_NEWER_P_COSTS.ACTION_DATE,dateformat_style),
									action_duedate:GET_NEWER_P_COSTS.ACTION_DUE_DATE,
									action_amount:GET_NEWER_P_COSTS.ACTION_AMOUNT,
									action_value:evaluate('satir_fiyat_tutar_#PRODUCT_COST_ID#')
								);
						}
						if(GET_COST_FOR_PHYSICAL.RECORDCOUNT gt 0)
						{
							if(GET_COST_FOR_PHYSICAL.RECORDCOUNT and isdate(GET_COST_FOR_PHYSICAL.COST_PHYSICAL_DATE))
								physical_=dateformat(GET_COST_FOR_PHYSICAL.COST_PHYSICAL_DATE,dateformat_style);
							else
								physical_=dateformat(GET_NEWER_P_COSTS.START_DATE,dateformat_style);
							if(not listfind('81,113',GET_NEWER_P_COSTS.ACTION_PROCESS_TYPE))
							{
								'physical_date_#PRODUCT_COST_ID#' =
											physical_action(
												physicaldate: physical_,
												stock_amount:evaluate('mevcut_son_alislar_#PRODUCT_COST_ID#')-GET_NEWER_P_COSTS.ACTION_AMOUNT,
												action_date:dateformat(GET_NEWER_P_COSTS.START_DATE,dateformat_style),
												action_amount:GET_NEWER_P_COSTS.ACTION_AMOUNT
											);
							}else{
								if(GET_COST_FOR_PHYSICAL.RECORDCOUNT and isdate(GET_COST_FOR_PHYSICAL.COST_PHYSICAL_DATE))
									'physical_date_#PRODUCT_COST_ID#'=CreateODBCDateTime(GET_COST_FOR_PHYSICAL.COST_PHYSICAL_DATE);
								else
									'physical_date_#PRODUCT_COST_ID#'=CreateODBCDateTime(GET_NEWER_P_COSTS.START_DATE);
							}
							if(GET_COST_FOR_PHYSICAL_LOCATION.RECORDCOUNT and isdate(GET_COST_FOR_PHYSICAL_LOCATION.COST_PHYSICAL_DATE))
								physical_lokasyon=dateformat(GET_COST_FOR_PHYSICAL_LOCATION.COST_PHYSICAL_DATE,dateformat_style);
							else
								physical_lokasyon=dateformat(GET_NEWER_P_COSTS.START_DATE,dateformat_style);
							'physical_date_location_#PRODUCT_COST_ID#' =
										physical_action(
											physicaldate: physical_lokasyon,
											stock_amount:evaluate('mevcut_son_alislar_lokasyon_#PRODUCT_COST_ID#')-GET_NEWER_P_COSTS.ACTION_AMOUNT,
											action_date:dateformat(GET_NEWER_P_COSTS.START_DATE,dateformat_style),
											action_amount:GET_NEWER_P_COSTS.ACTION_AMOUNT
										);
										
							if(GET_COST_FOR_PHYSICAL_DEPARTMENT.RECORDCOUNT and isdate(GET_COST_FOR_PHYSICAL_DEPARTMENT.COST_PHYSICAL_DATE))
								physical_department=dateformat(GET_COST_FOR_PHYSICAL_DEPARTMENT.COST_PHYSICAL_DATE,dateformat_style);
							else
								physical_department=dateformat(GET_NEWER_P_COSTS.START_DATE,dateformat_style);
							'physical_date_department_#PRODUCT_COST_ID#' =
										physical_action(
											physicaldate: physical_department,
											stock_amount:evaluate('mevcut_son_alislar_department_#PRODUCT_COST_ID#')-GET_NEWER_P_COSTS.ACTION_AMOUNT,
											action_date:dateformat(GET_NEWER_P_COSTS.START_DATE,dateformat_style),
											action_amount:GET_NEWER_P_COSTS.ACTION_AMOUNT
										);
						}
					</cfscript>
				<cfelse>
					<cfset GET_COST_FOR_DUE.RECORDCOUNT=0>
					<cfset GET_COST_FOR_DUE_LOCATION.RECORDCOUNT=0>
                    <cfset GET_COST_FOR_DUE_DEPARTMENT.RECORDCOUNT=0>
					<cfset GET_COST_FOR_PHYSICAL.RECORDCOUNT=0>
					<cfset GET_COST_FOR_PHYSICAL_LOCATION.RECORDCOUNT=0>
                    <cfset GET_COST_FOR_PHYSICAL_DEPARTMENT.RECORDCOUNT=0>
					<cfif len(GET_NEWER_P_COSTS.DUE_DATE)>
						<cfset 'due_date_#PRODUCT_COST_ID#'= createodbcdatetime(GET_NEWER_P_COSTS.DUE_DATE)>
					</cfif>
					<cfif len(GET_NEWER_P_COSTS.DUE_DATE_LOCATION)>
						<cfset 'due_date_location_#PRODUCT_COST_ID#'=createodbcdatetime(GET_NEWER_P_COSTS.DUE_DATE_LOCATION)>
					</cfif>
                    <cfif len(GET_NEWER_P_COSTS.DUE_DATE_DEPARTMENT)>
						<cfset 'due_date_department_#PRODUCT_COST_ID#'=createodbcdatetime(GET_NEWER_P_COSTS.DUE_DATE_DEPARTMENT)>
					</cfif>
					<cfif len(GET_NEWER_P_COSTS.PHYSICAL_DATE)>
						<cfset 'physical_date_#PRODUCT_COST_ID#'=createodbcdatetime(GET_NEWER_P_COSTS.PHYSICAL_DATE)>
					</cfif>
					<cfif len(GET_NEWER_P_COSTS.PHYSICAL_DATE_LOCATION)>
						<cfset 'physical_date_location_#PRODUCT_COST_ID#' =createodbcdatetime(GET_NEWER_P_COSTS.PHYSICAL_DATE_LOCATION)>
					</cfif>
                    <cfif len(GET_NEWER_P_COSTS.PHYSICAL_DATE_DEPARTMENT)>
						<cfset 'physical_date_department_#PRODUCT_COST_ID#' =createodbcdatetime(GET_NEWER_P_COSTS.PHYSICAL_DATE_DEPARTMENT)>
					</cfif>
				</cfif>
				<!--- //fiyat koruma degerleri ve sabit maliyet girilmiş ise degerleri kaybetmemesi için --->
				<cfif GET_NEWER_P_COSTS.ACTION_TYPE gt 0><!--- elle eklenen maliyetler güncellenmesin... --->
                <cfquery name="UPD_COST" datasource="#FORM.DSN1#">
					UPDATE
						PRODUCT_COST
					SET
						<cfif GET_NEWER_P_COSTS.ACTION_TYPE gt 0><!--- elle eklenmisse maliyet miktarı guncellemeyelim --->
							ACTIVE_STOCK = <cfif len(yoldaki_stoklar)>#yoldaki_stoklar#<cfelse>0</cfif>,
							AVAILABLE_STOCK = <cfif len(evaluate('mevcut_son_alislar_#PRODUCT_COST_ID#'))>#evaluate('mevcut_son_alislar_#PRODUCT_COST_ID#')#<cfelse>0</cfif>,
						</cfif>
						PRODUCT_COST = #(evaluate("alis_net_fiyat_#PRODUCT_COST_ID#")+evaluate("alis_ek_maliyet_#PRODUCT_COST_ID#")+std_cost+((evaluate("alis_net_fiyat_#PRODUCT_COST_ID#")*GET_NEWER_P_COSTS.STANDARD_COST_RATE)/100)-prc_protec)#,
						PURCHASE_NET = #evaluate("alis_net_fiyat_#PRODUCT_COST_ID#")#,
						PURCHASE_EXTRA_COST = #evaluate("alis_ek_maliyet_#PRODUCT_COST_ID#")#,
						PURCHASE_NET_SYSTEM = #(evaluate("alis_net_fiyat_system_#PRODUCT_COST_ID#")-prc_protec_sys)#,
						PURCHASE_EXTRA_COST_SYSTEM = #evaluate("alis_ek_maliyet_system_#PRODUCT_COST_ID#")+std_cost_sys+((evaluate("alis_net_fiyat_system_#PRODUCT_COST_ID#")*GET_NEWER_P_COSTS.STANDARD_COST_RATE)/100)#,
						PURCHASE_NET_SYSTEM_2 = #(evaluate("alis_net_fiyat_system_2_#PRODUCT_COST_ID#")-prc_protec_sys_2)#,
						PURCHASE_EXTRA_COST_SYSTEM_2 = #evaluate("alis_ek_maliyet_system_2_#PRODUCT_COST_ID#")+std_cost_sys_2+((evaluate("alis_net_fiyat_system_2_#PRODUCT_COST_ID#")*GET_NEWER_P_COSTS.STANDARD_COST_RATE)/100)#,

						ACTIVE_STOCK_LOCATION = 0,
						AVAILABLE_STOCK_LOCATION = <cfif len(evaluate('mevcut_son_alislar_lokasyon_#PRODUCT_COST_ID#'))>#evaluate('mevcut_son_alislar_lokasyon_#PRODUCT_COST_ID#')#<cfelse>0</cfif>,
						PRODUCT_COST_LOCATION = #(evaluate("alis_net_fiyat_lokasyon_#PRODUCT_COST_ID#")+evaluate("alis_ek_maliyet_lokasyon_#PRODUCT_COST_ID#")+std_cost_loc+((evaluate("alis_net_fiyat_lokasyon_#PRODUCT_COST_ID#")*GET_NEWER_P_COSTS.STANDARD_COST_RATE_LOCATION)/100)-prc_protec_loc)#,
						PURCHASE_NET_LOCATION = #evaluate("alis_net_fiyat_lokasyon_#PRODUCT_COST_ID#")#,
						PURCHASE_EXTRA_COST_LOCATION = #evaluate("alis_ek_maliyet_lokasyon_#PRODUCT_COST_ID#")#,
						PURCHASE_NET_MONEY_LOCATION = '#GET_NEWER_P_COSTS.PURCHASE_NET_MONEY#', 
						PURCHASE_NET_SYSTEM_LOCATION = #(evaluate("alis_net_fiyat_system_lokasyon_#PRODUCT_COST_ID#")-prc_protec_sys)#,
						PURCHASE_EXTRA_COST_SYSTEM_LOCATION = #evaluate("alis_ek_maliyet_system_lokasyon_#PRODUCT_COST_ID#")+std_cost_sys+((evaluate("alis_net_fiyat_system_lokasyon_#PRODUCT_COST_ID#")*GET_NEWER_P_COSTS.STANDARD_COST_RATE_LOCATION)/100)#,
						<!--- PURCHASE_NET_SYSTEM_MONEY_LOCATION = <cfif len(GET_NEWER_P_COSTS.PURCHASE_NET_SYSTEM_MONEY)>'#GET_NEWER_P_COSTS.PURCHASE_NET_SYSTEM_MONEY#'<cfelse>'#form.cost_money_system#'</cfif>, --->
						PURCHASE_NET_SYSTEM_2_LOCATION = #(evaluate("alis_net_fiyat_system_2_lokasyon_#PRODUCT_COST_ID#")-prc_protec_sys_2)#,
						PURCHASE_EXTRA_COST_SYSTEM_2_LOCATION = #evaluate("alis_ek_maliyet_system_2_lokasyon_#PRODUCT_COST_ID#")+std_cost_sys_2+((evaluate("alis_net_fiyat_system_2_lokasyon_#PRODUCT_COST_ID#")*GET_NEWER_P_COSTS.STANDARD_COST_RATE_LOCATION)/100)#,
						<!--- PURCHASE_NET_SYSTEM_MONEY_2_LOCATION = <cfif len(GET_NEWER_P_COSTS.PURCHASE_NET_SYSTEM_MONEY_2)>'#GET_NEWER_P_COSTS.PURCHASE_NET_SYSTEM_MONEY_2#'<cfelse>'#form.cost_money_system_2#'</cfif>, --->
						
                        ACTIVE_STOCK_DEPARTMENT = 0,
						AVAILABLE_STOCK_DEPARTMENT = <cfif len(evaluate('mevcut_son_alislar_department_#PRODUCT_COST_ID#'))>#evaluate('mevcut_son_alislar_department_#PRODUCT_COST_ID#')#<cfelse>0</cfif>,
						PRODUCT_COST_DEPARTMENT = #(evaluate("alis_net_fiyat_department_#PRODUCT_COST_ID#")+evaluate("alis_ek_maliyet_department_#PRODUCT_COST_ID#")+std_cost_dep+((evaluate("alis_net_fiyat_department_#PRODUCT_COST_ID#")*GET_NEWER_P_COSTS.STANDARD_COST_RATE_DEPARTMENT)/100)-prc_protec_dep)#,
						PURCHASE_NET_DEPARTMENT = #evaluate("alis_net_fiyat_department_#PRODUCT_COST_ID#")#,
						PURCHASE_EXTRA_COST_DEPARTMENT = #evaluate("alis_ek_maliyet_department_#PRODUCT_COST_ID#")#,
						PURCHASE_NET_MONEY_DEPARTMENT = '#GET_NEWER_P_COSTS.PURCHASE_NET_MONEY#', 
						PURCHASE_NET_SYSTEM_DEPARTMENT = #(evaluate("alis_net_fiyat_system_department_#PRODUCT_COST_ID#")-prc_protec_sys)#,
						PURCHASE_EXTRA_COST_SYSTEM_DEPARTMENT = #evaluate("alis_ek_maliyet_system_department_#PRODUCT_COST_ID#")+std_cost_sys+((evaluate("alis_net_fiyat_system_department_#PRODUCT_COST_ID#")*GET_NEWER_P_COSTS.STANDARD_COST_RATE_DEPARTMENT)/100)#,
						<!--- PURCHASE_NET_SYSTEM_MONEY_DEPARTMENT = <cfif len(GET_NEWER_P_COSTS.PURCHASE_NET_SYSTEM_MONEY)>'#GET_NEWER_P_COSTS.PURCHASE_NET_SYSTEM_MONEY#'<cfelse>'#form.cost_money_system#'</cfif>, --->
						PURCHASE_NET_SYSTEM_2_DEPARTMENT = #(evaluate("alis_net_fiyat_system_2_department_#PRODUCT_COST_ID#")-prc_protec_sys_2)#,
						PURCHASE_EXTRA_COST_SYSTEM_2_DEPARTMENT = #evaluate("alis_ek_maliyet_system_2_department_#PRODUCT_COST_ID#")+std_cost_sys_2+((evaluate("alis_net_fiyat_system_2_department_#PRODUCT_COST_ID#")*GET_NEWER_P_COSTS.STANDARD_COST_RATE_DEPARTMENT)/100)#,
						<!--- PURCHASE_NET_SYSTEM_MONEY_2_DEPARTMENT = <cfif len(GET_NEWER_P_COSTS.PURCHASE_NET_SYSTEM_MONEY_2)>'#GET_NEWER_P_COSTS.PURCHASE_NET_SYSTEM_MONEY_2#'<cfelse>'#form.cost_money_system_2#'</cfif>, --->

						
						<cfif GET_COST_FOR_DUE.RECORDCOUNT>DUE_DATE=<cfif isdefined('due_date_#PRODUCT_COST_ID#') and isdate(evaluate('due_date_#PRODUCT_COST_ID#'))>#evaluate('due_date_#PRODUCT_COST_ID#')#<cfelse>NULL</cfif>,</cfif>
						<cfif GET_COST_FOR_DUE_LOCATION.RECORDCOUNT>DUE_DATE_LOCATION=<cfif isdefined('due_date_location_#PRODUCT_COST_ID#') and isdate(evaluate('due_date_location_#PRODUCT_COST_ID#'))>#evaluate('due_date_location_#PRODUCT_COST_ID#')#<cfelse>NULL</cfif>,</cfif>
						<cfif GET_COST_FOR_DUE_DEPARTMENT.RECORDCOUNT>DUE_DATE_DEPARTMENT=<cfif isdefined('due_date_department_#PRODUCT_COST_ID#') and isdate(evaluate('due_date_department_#PRODUCT_COST_ID#'))>#evaluate('due_date_department_#PRODUCT_COST_ID#')#<cfelse>NULL</cfif>,</cfif>
						<cfif GET_COST_FOR_PHYSICAL.RECORDCOUNT>PHYSICAL_DATE=<cfif isdefined('physical_date_#PRODUCT_COST_ID#') and isdate(evaluate('physical_date_#PRODUCT_COST_ID#'))>#evaluate('physical_date_#PRODUCT_COST_ID#')#<cfelse>NULL</cfif>,</cfif>
						<cfif GET_COST_FOR_PHYSICAL_LOCATION.RECORDCOUNT>PHYSICAL_DATE_LOCATION=<cfif isdefined('physical_date_location_#PRODUCT_COST_ID#') and isdate(evaluate('physical_date_location_#PRODUCT_COST_ID#'))>#evaluate('physical_date_location_#PRODUCT_COST_ID#')#<cfelse>NULL</cfif>,</cfif>
						<cfif GET_COST_FOR_PHYSICAL_DEPARTMENT.RECORDCOUNT>PHYSICAL_DATE_DEPARTMENT=<cfif isdefined('physical_date_department_#PRODUCT_COST_ID#') and isdate(evaluate('physical_date_department_#PRODUCT_COST_ID#'))>#evaluate('physical_date_department_#PRODUCT_COST_ID#')#<cfelse>NULL</cfif>,</cfif>

						STATION_REFLECTION_COST_SYSTEM = #evaluate("alis_reflection_maliyet_system_#PRODUCT_COST_ID#")#,
						LABOR_COST_SYSTEM = #evaluate("alis_labor_maliyet_system_#PRODUCT_COST_ID#")#,
						STATION_REFLECTION_COST_SYSTEM_LOCATION = #evaluate("alis_reflection_maliyet_system_lokasyon_#PRODUCT_COST_ID#")#,
						LABOR_COST_SYSTEM_LOCATION = #evaluate("alis_labor_maliyet_system_lokasyon_#PRODUCT_COST_ID#")#,
						STATION_REFLECTION_COST_SYSTEM_DEPARTMENT = #evaluate("alis_reflection_maliyet_system_department_#PRODUCT_COST_ID#")#,
						LABOR_COST_SYSTEM_DEPARTMENT = #evaluate("alis_labor_maliyet_system_department_#PRODUCT_COST_ID#")#,
						
						STATION_REFLECTION_COST = #evaluate("alis_reflection_maliyet_#PRODUCT_COST_ID#")#,
						STATION_REFLECTION_COST_SYSTEM_2 = #evaluate("alis_reflection_maliyet_system_2_#PRODUCT_COST_ID#")#,
						STATION_REFLECTION_COST_LOCATION = #evaluate("alis_reflection_maliyet_lokasyon_#PRODUCT_COST_ID#")#,
						STATION_REFLECTION_COST_SYSTEM_2_LOCATION = #evaluate("alis_reflection_maliyet_system_2_lokasyon_#PRODUCT_COST_ID#")#,
						STATION_REFLECTION_COST_DEPARTMENT = #evaluate("alis_reflection_maliyet_department_#PRODUCT_COST_ID#")#,
						STATION_REFLECTION_COST_SYSTEM_2_DEPARTMENT = #evaluate("alis_reflection_maliyet_system_2_department_#PRODUCT_COST_ID#")#,
						
						LABOR_COST = #evaluate("alis_labor_maliyet_#PRODUCT_COST_ID#")#,
						LABOR_COST_SYSTEM_2 =#evaluate("alis_labor_maliyet_system_2_#PRODUCT_COST_ID#")#,
						LABOR_COST_LOCATION  = #evaluate("alis_labor_maliyet_lokasyon_#PRODUCT_COST_ID#")#,
						LABOR_COST_SYSTEM_2_LOCATION =#evaluate("alis_labor_maliyet_system_2_lokasyon_#PRODUCT_COST_ID#")#,
						LABOR_COST_DEPARTMENT =#evaluate("alis_labor_maliyet_department_#PRODUCT_COST_ID#")#,
						LABOR_COST_SYSTEM_2_DEPARTMENT =  #evaluate("alis_labor_maliyet_system_2_department_#PRODUCT_COST_ID#")#,
                        
						PRODUCT_COST_STATUS=<cfif GET_NEWER_P_COSTS.RECORDCOUNT eq GET_NEWER_P_COSTS.CURRENTROW>1<cfelse>0</cfif>,
						UPDATE_DATE = #now()#,
						UPDATE_EMP = 0,
						UPDATE_IP = '#cgi.REMOTE_ADDR#'
					WHERE
						PRODUCT_COST_ID = #PRODUCT_COST_ID#
				</cfquery>
                </cfif>
			</cfif>
		</cfloop> 
	</cfif>
</cffunction>
</cfprocessingdirective><cfsetting enablecfoutputonly="no">
