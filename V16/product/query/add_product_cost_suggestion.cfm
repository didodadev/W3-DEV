    <!---<cfdump var="#attributes#"><cfabort>--->
<cfif FORM.ACTION_PERIOD_ID neq session.ep.period_id>
	<script type="text/javascript">
		alert("<cf_get_lang no ='886.Döneminiz uygun değil ! Kayıt yapamazsınız'>...");
		window.close();
	</script>
	<cfabort>
</cfif>
<cfif isdefined('attributes.start_date') and len(attributes.start_date)>
	<cf_date tarih='attributes.start_date'>
</cfif>
<cfif isdefined('MONEY_#session.ep.money#')>
	<cfset purchase_net_sys_2=attributes.purchase_net_system/evaluate('MONEY_#session.ep.money2#')>
	<cfset purchase_extra_sys_2=attributes.purchase_extra_cost_system/evaluate('MONEY_#session.ep.money2#')>
	<cfset purchase_net_sys_2_loc=attributes.purchase_net_system_location/evaluate('MONEY_#session.ep.money2#')>
	<cfset purchase_extra_sys_2_loc=attributes.purchase_extra_cost_system/evaluate('MONEY_#session.ep.money2#')><!--- ekmaliyette degismiyor birdek fiyat koruma degisiyor --->
<cfelse>
	<cfquery name="GET_MONEY_2" datasource="#arguments.period_dsn_type#">
		SELECT 
			(RATE2/RATE1) RATE,
			MONEY
		FROM
			SETUP_MONEY
		WHERE
			MONEY = <cfqueryparam value="#session.ep.money2#" cfsqltype="cf_sql_varchar">
	</cfquery>
	<cfset purchase_net_sys_2 = attributes.purchase_net_system/GET_MONEY_2.RATE>
	<cfset purchase_extra_sys_2 = attributes.purchase_extra_cost_system/GET_MONEY_2.RATE>
	<cfset purchase_net_sys_2_loc = attributes.purchase_net_system_location/GET_MONEY_2.RATE>
	<cfset purchase_extra_sys_2_loc = attributes.purchase_extra_cost_system/GET_MONEY_2.RATE>
</cfif>

<cfif session.ep.isBranchAuthorization><!--- store maliyeti ise mevcut genel maliyet alınır ve o degismemesi için kaydedilir --->
	<cfquery name="GET_GENERAL_COST" datasource="#DSN3#">
		SELECT
			START_DATE,
			COST_TYPE_ID,
			PRODUCT_COST,
			MONEY,
			STANDARD_COST,
			STANDARD_COST_MONEY,
			STANDARD_COST_RATE,
			PURCHASE_NET,
			PURCHASE_NET_MONEY,
			PURCHASE_EXTRA_COST,
			PRICE_PROTECTION,
			PRICE_PROTECTION_MONEY,
			PURCHASE_NET_SYSTEM,
			PURCHASE_NET_SYSTEM_MONEY,
			PURCHASE_EXTRA_COST_SYSTEM,
			PRODUCT_COST_SYSTEM,
			PURCHASE_NET_SYSTEM_2,
			PURCHASE_NET_SYSTEM_MONEY_2,
			PURCHASE_EXTRA_COST_SYSTEM_2,
			AVAILABLE_STOCK,
			PARTNER_STOCK,
			ACTIVE_STOCK,
			IS_STANDARD_COST,
			IS_ACTIVE_STOCK,
			IS_PARTNER_STOCK
		FROM
			PRODUCT_COST_SUGGESTION
		WHERE
			PRODUCT_ID=#attributes.product_id#
			AND ACTION_PERIOD_ID = #session.ep.period_id#
			AND START_DATE <= #attributes.start_date#
			<cfif len(attributes.spect_main_id)>
				AND SPECT_MAIN_ID=#attributes.spect_main_id#
			<cfelse>
				AND IS_SPEC=0
			</cfif>
		ORDER BY 
			START_DATE DESC,
			RECORD_DATE DESC
	</cfquery>
	<cfif not GET_GENERAL_COST.RECORDCOUNT>
		<script type="text/javascript">
			alert("<cf_get_lang no ='887.Şube lokasyon maliyeti ekleyebilmek için genel maliyet kaydının olması gerekmektedir'>!");
			history.go(-1);
		</script>
		<cfabort>
	</cfif>
	
	<cfquery name="GET_GENERAL_AVAILABLE_STOCK" datasource="#dsn2#">
		SELECT 
			SUM(SR.STOCK_IN - SR.STOCK_OUT) AS PRODUCT_TOTAL_STOCK 
		FROM 
			STOCKS_ROW SR 
		WHERE 
			SR.PRODUCT_ID = #attributes.product_id# 
			AND PROCESS_DATE <= #attributes.start_date#
			<cfif len(attributes.spect_main_id)>
				AND SPECT_VAR_ID=#attributes.spect_main_id#
			<cfelse>
				AND SPECT_VAR_ID IS NULL
			</cfif>
	</cfquery>
	<cfquery name="GET_GENERAL_ACTIVE_STOCK" datasource="#dsn2#">
		SELECT 
			SUM(SR.STOCK_IN - SR.STOCK_OUT) AS PRODUCT_TOTAL_STOCK 
		FROM 
			STOCKS_ROW SR 
		WHERE 
			SR.PRODUCT_ID = #attributes.product_id# 
			AND PROCESS_DATE <= #attributes.start_date#
			AND PROCESS_TYPE = 81
			<cfif len(attributes.spect_main_id)>
				AND SPECT_VAR_ID=#attributes.spect_main_id#
			<cfelse>
				AND SPECT_VAR_ID IS NULL
			</cfif>
	</cfquery>
<cfelseif len(attributes.department_id) and len(attributes.department)><!--- product_modülünde vede departman seçil ise departan stoklarını bulmak için --->
	<cfquery name="GET_LOC_AVAILABLE_STOCK" datasource="#dsn2#">
		SELECT 
			SUM(SR.STOCK_IN - SR.STOCK_OUT) AS PRODUCT_TOTAL_STOCK 
		FROM 
			STOCKS_ROW SR 
		WHERE 
			SR.PRODUCT_ID = #attributes.product_id# 
			AND PROCESS_DATE <= #attributes.start_date#
			AND STORE = #attributes.department_id#
			AND STORE_LOCATION = #attributes.location_id#
			<cfif len(attributes.spect_main_id)>
				AND SPECT_VAR_ID=#attributes.spect_main_id#
			<cfelse>
				AND SPECT_VAR_ID IS NULL
			</cfif>
	</cfquery>
</cfif>

<cftransaction>
	<cflock timeout="20">
		<cfquery name="ADD_COST_SUGGESTION" datasource="#dsn1#">
			INSERT INTO
				PRODUCT_COST_SUGGESTION
					(
						COMPANY_ID,
						FROM_COST,
						INVENTORY_CALC_TYPE,
						COST_TYPE_ID,
						START_DATE,
						PRODUCT_ID,
						UNIT_ID,
						IS_SPEC,
						SPECT_MAIN_ID,
						IS_STANDARD_COST,
						IS_ACTIVE_STOCK,
						IS_PARTNER_STOCK,
						COST_DESCRIPTION,
						ACTION_ID,
						ACTION_TYPE,
						ACTION_PERIOD_ID,
						ACTION_AMOUNT,
						ACTION_ROW_ID,
						AVAILABLE_STOCK,
						PARTNER_STOCK,
						ACTIVE_STOCK,
						PRODUCT_COST,
						MONEY,
						STANDARD_COST,
						STANDARD_COST_MONEY,
						STANDARD_COST_RATE,
						PURCHASE_NET,
						PURCHASE_NET_MONEY,
						PURCHASE_EXTRA_COST,
						PRICE_PROTECTION,
						PRICE_PROTECTION_MONEY,
						PURCHASE_NET_SYSTEM,
						PURCHASE_NET_SYSTEM_MONEY,
						PURCHASE_EXTRA_COST_SYSTEM,
						PURCHASE_NET_SYSTEM_2,
						PURCHASE_NET_SYSTEM_MONEY_2,
						PURCHASE_EXTRA_COST_SYSTEM_2,
						<cfif len(attributes.department_id) and len(attributes.department)>
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
						</cfif>
						RECORD_DATE,
						RECORD_EMP,
						RECORD_IP
					)
				VALUES
					(
						<cfif isdefined('attributes.td_company_id') and len(attributes.td_company_id)>#attributes.td_company_id#<cfelse>NULL</cfif>,
						<cfif fusebox.Circuit eq 'product'>0<cfelse>1</cfif>,
						<cfif isdefined('attributes.inventory_calc_type') and len(attributes.inventory_calc_type)>#attributes.inventory_calc_type#<cfelse>NULL</cfif>,
						<cfif isdefined("attributes.cost_type") and len(attributes.cost_type)>#attributes.cost_type#<cfelse>NULL</cfif>,
						<cfif isdefined('attributes.start_date') and len(attributes.start_date)>#attributes.start_date#<cfelse>NULL</cfif>,
						#attributes.product_id#,
						#attributes.unit_id#,
						<cfif len(trim(attributes.spect_main_id))>1<cfelse>0</cfif>,
						<cfif len(trim(attributes.spect_main_id))>#attributes.spect_main_id#<cfelse>NULL</cfif>,
						<cfif isdefined('attributes.is_standard_cost')>1<cfelse>0</cfif>,
						<cfif isdefined('attributes.is_active_stock')>1<cfelse>0</cfif>,
						<cfif isdefined('attributes.is_partner_stock')>1<cfelse>0</cfif>,
						<cfif len(attributes.COST_DESCRIPTION)>'#attributes.COST_DESCRIPTION#'<cfelse>NULL</cfif>,
						<cfif len(attributes.action_id)>#attributes.action_id#<cfelse>NULL</cfif>,<!--- artık bos NULL OLUYOR HERZAMAN --->
						<cfif len(attributes.action_type)>#attributes.action_type#<cfelse>NULL</cfif>,						
                        #attributes.action_period_id#,	
                        <cfif len(attributes.action_amount)>#attributes.action_amount#<cfelse>NULL</cfif>,
                        <cfif len(attributes.action_row_id)>#attributes.action_row_id#<cfelse>NULL</cfif>,				
					<cfif fusebox.Circuit eq 'product'>
						<!--- PRODUCT TAN EKLENIYORSA SUBEDE GENEL MALİYET İÇİNDE AYNI DEGER YAZILIYOR --->
						<cfif len(attributes.available_stock)>#attributes.available_stock#<cfelse>NULL</cfif>,
						<cfif len(attributes.partner_stock)>#attributes.partner_stock#<cfelse>NULL</cfif>,
						<cfif len(attributes.active_stock)>#attributes.active_stock#<cfelse>NULL</cfif>,
						<cfif len(attributes.product_cost)>#wrk_round(attributes.product_cost,4)#<cfelse>0</cfif>,<!--- (attributes.PURCHASE_NET+attributes.PURCHASE_EXTRA_COST+attributes.STANDARD_COST+((attributes.PURCHASE_NET*attributes.STANDARD_COST_RATE)/100)-attributes.PRICE_PROTECTION) --->
						  <cfif isdefined('attributes.product_cost_money') and len(attributes.product_cost_money)>'#attributes.product_cost_money#'<cfelseif isdefined('attributes.purchase_net_money') and len(attributes.purchase_net_money)>'#attributes.purchase_net_money#'<cfelse>NULL</cfif>,
						<cfif len(attributes.standard_cost)>#attributes.standard_cost#<cfelse>0</cfif>,
						'#attributes.standard_cost_money#',
						<cfif len(attributes.standard_cost_rate)>#attributes.standard_cost_rate#<cfelse>0</cfif>,
						<cfif len(attributes.purchase_net)>#purchase_net#<cfelse>0</cfif>,
						'#attributes.purchase_net_money#',
						<cfif len(attributes.purchase_extra_cost)>#attributes.purchase_extra_cost#<cfelse>0</cfif>,
						<cfif len(attributes.price_protection)>#attributes.price_protection#<cfelse>0</cfif>,
						'#attributes.price_protection_money#',
						<cfif len(attributes.purchase_net_system)>#attributes.purchase_net_system#<cfelse>0</cfif>,
						'#SESSION.EP.MONEY#',
						<cfif len(attributes.purchase_extra_cost_system)>#attributes.purchase_extra_cost_system#<cfelse>0</cfif>,
						#purchase_net_sys_2#,
						'#session.ep.money2#',
						#purchase_extra_sys_2#,
						<cfif len(attributes.department_id) and len(attributes.department)>
							#attributes.department_id#,
							#attributes.location_id#,
							
							<cfif isdefined('GET_LOC_AVAILABLE_STOCK') and len(GET_LOC_AVAILABLE_STOCK.PRODUCT_TOTAL_STOCK)>#GET_LOC_AVAILABLE_STOCK.PRODUCT_TOTAL_STOCK#<cfelse>0</cfif>,
							NULL,
							0,<!--- <cfif isdefined('GET_LOC_ACTIVE_STOCK') and len(GET_LOC_ACTIVE_STOCK.PRODUCT_TOTAL_STOCK)>#GET_LOC_ACTIVE_STOCK.PRODUCT_TOTAL_STOCK#<cfelse>0</cfif>, --->
							#wrk_round(attributes.purchase_net+attributes.purchase_extra_cost+attributes.standard_cost+((attributes.purchase_net*attributes.standard_cost_rate)/100)-(attributes.price_protection_location*1),4)#,
							<cfif isdefined('attributes.product_cost_money') and len(attributes.product_cost_money)>#attributes.product_cost_money#<cfelse>NULL</cfif>,
							<cfif len(attributes.standard_cost)>#attributes.standard_cost#<cfelse>0</cfif>,
							'#attributes.standard_cost_money#',
							<cfif len(attributes.standard_cost_rate)>#attributes.standard_cost_rate#<cfelse>0</cfif>,
							<cfif len(attributes.purchase_net)>#attributes.purchase_net#<cfelse>0</cfif>,
							'#attributes.purchase_net_money#',
							<cfif len(attributes.purchase_extra_cost)>#attributes.purchase_extra_cost#<cfelse>0</cfif>,
							<cfif isdefined("attributes.price_protection_location") and len(attributes.price_protection_location)>#attributes.price_protection_location#<cfelse>0</cfif>,
							'#attributes.price_protection_money_location#',
							
							<cfif len(attributes.purchase_net_system_location)>#attributes.purchase_net_system_location#<cfelse>0</cfif>,
							'#SESSION.EP.MONEY#',
							<cfif len(attributes.purchase_extra_cost_system)>#attributes.purchase_extra_cost_system#<cfelse>0</cfif>,
							#purchase_net_sys_2_loc#,
							'#session.ep.money2#',
							#purchase_extra_sys_2_loc#,
						</cfif>
					<cfelse>
						<!--- SUBEDEN EKLENİYORSA GENEL MALİYET AYNEN KALMASI ICIN --->
						<cfif isdefined('GET_GENERAL_AVAILABLE_STOCK') and len(GET_GENERAL_AVAILABLE_STOCK.PRODUCT_TOTAL_STOCK)>#GET_GENERAL_AVAILABLE_STOCK.PRODUCT_TOTAL_STOCK#<cfelse>0</cfif>,
						NULL,
						<cfif isdefined('GET_GENERAL_ACTIVE_STOCK') and len(GET_GENERAL_ACTIVE_STOCK.PRODUCT_TOTAL_STOCK)>#GET_GENERAL_ACTIVE_STOCK.PRODUCT_TOTAL_STOCK#<cfelse>0</cfif>,
						#GET_GENERAL_COST.PRODUCT_COST#,
						'#GET_GENERAL_COST.MONEY#',
						<cfif len(GET_GENERAL_COST.STANDARD_COST)>#GET_GENERAL_COST.STANDARD_COST#<cfelse>0</cfif>,
						'#GET_GENERAL_COST.STANDARD_COST_MONEY#',
						<cfif len(GET_GENERAL_COST.STANDARD_COST_RATE)>#GET_GENERAL_COST.STANDARD_COST_RATE#<cfelse>0</cfif>,
						<cfif len(GET_GENERAL_COST.PURCHASE_NET)>#GET_GENERAL_COST.PURCHASE_NET#<cfelse>0</cfif>,
						'#GET_GENERAL_COST.PURCHASE_NET_MONEY#',
						<cfif len(GET_GENERAL_COST.PURCHASE_EXTRA_COST)>#GET_GENERAL_COST.PURCHASE_EXTRA_COST#<cfelse>0</cfif>,
						<cfif len(GET_GENERAL_COST.PRICE_PROTECTION)>#GET_GENERAL_COST.PRICE_PROTECTION#<cfelse>0</cfif>,
						'#GET_GENERAL_COST.PRICE_PROTECTION_MONEY#',
						<cfif len(GET_GENERAL_COST.PURCHASE_NET_SYSTEM)>#GET_GENERAL_COST.PURCHASE_NET_SYSTEM#<cfelse>0</cfif>,
						'#GET_GENERAL_COST.PURCHASE_NET_SYSTEM_MONEY#',
						<cfif len(GET_GENERAL_COST.PURCHASE_EXTRA_COST_SYSTEM)>#GET_GENERAL_COST.PURCHASE_EXTRA_COST_SYSTEM#<cfelse>0</cfif>,
						#GET_GENERAL_COST.PURCHASE_NET_SYSTEM_2#,
						'#GET_GENERAL_COST.PURCHASE_NET_SYSTEM_MONEY_2#',
						#GET_GENERAL_COST.PURCHASE_EXTRA_COST_SYSTEM_2#,
						<cfif len(attributes.department_id) and len(attributes.department)>
							#attributes.department_id#,
							#attributes.location_id#,							
							<cfif len(attributes.available_stock)>#attributes.available_stock#<cfelse>NULL</cfif>,
							<cfif len(attributes.partner_stock)>#attributes.partner_stock#<cfelse>NULL</cfif>,
							<cfif len(attributes.active_stock)>#attributes.active_stock#<cfelse>NULL</cfif>,
							#wrk_round(attributes.product_cost,4)#,<!--- (attributes.PURCHASE_NET+attributes.PURCHASE_EXTRA_COST+attributes.STANDARD_COST+((attributes.PURCHASE_NET*attributes.STANDARD_COST_RATE)/100)-attributes.PRICE_PROTECTION) --->
							  <cfif isdefined('attributes.product_cost_money') and len(attributes.product_cost_money)>#attributes.product_cost_money#<cfelse>NULL</cfif>,
							<cfif len(attributes.standard_cost)>#attributes.standard_cost#<cfelse>0</cfif>,
							'#attributes.standard_cost_money#',
							<cfif len(attributes.standard_cost_rate)>#attributes.standard_cost_rate#<cfelse>0</cfif>,
							<cfif len(attributes.purchase_net)>#attributes.purchase_net#<cfelse>0</cfif>,
							'#attributes.purchase_net_money#',
							<cfif len(attributes.purchase_extra_cost)>#attributes.purchase_extra_cost#<cfelse>0</cfif>,
							<cfif len(attributes.price_protection)>#attributes.price_protection#<cfelse>0</cfif>,
							'#attributes.price_protection_money#',
							
							<cfif len(attributes.purchase_net_system)>#attributes.purchase_net_system#<cfelse>0</cfif>,
							'#SESSION.EP.MONEY#',				
							<cfif len(attributes.purchase_extra_cost_system)>#attributes.purchase_extra_cost_system#<cfelse>0</cfif>,
							#purchase_net_sys_2#,
							'#session.ep.money2#',
							#purchase_extra_sys_2#,
						</cfif>					
					</cfif>		
						#NOW()#,
						#SESSION.EP.USERID#,
						'#cgi.REMOTE_ADDR#'
					)
		</cfquery>
	</cflock>
</cftransaction>
<!--- Buraya kadar alıcaz fiyat önerisi için PRODUCT_COST_SUGGESTION TABLOSU AÇILDI BURDA MALİYET ÖNERİLERİ TUTULACAK. --->
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
