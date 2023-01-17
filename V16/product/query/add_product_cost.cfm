
<cfparam name="attributes.price_protection_type" default="1">
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
<cfif isdefined('attributes.physical_date') and len(attributes.physical_date)>
	<cf_date tarih='attributes.physical_date'>
</cfif>
<cfif isdefined('attributes.due_date') and len(attributes.due_date)>
	<cf_date tarih='attributes.due_date'>
</cfif>
<!--- FONKSİYON İÇİNDE KULLANILIYOR kaldirmayin--->
<cfquery name="GET_NOT_DEP_COST" datasource="#DSN#">
	SELECT
		DEPARTMENT_ID,LOCATION_ID 
	FROM 
		STOCKS_LOCATION STOCKS_LOCATION
	WHERE 
		ISNULL(IS_COST_ACTION,0)=1
</cfquery>
<!---// FONKSİON İÇİND KULLAILIYOR kaldrımayın---> 
<!--- BAZI FİRMALARDA session.ep.money2 BOŞ SEÇİLEBİLİYOR! burda direkt olarak session.ep.money2'i USD olarak set edersek başka yerlerde soruna sebibiyet verebilir bu sebeble 
ara bir değişken kullanarak sayfamızı şekillendiriyoruz!
 --->
<cfif not len(session.ep.money2)>
	<cfset system_2_money='USD'>
<cfelse>
	<cfset system_2_money='#session.ep.money2#'>
</cfif>
<cfif isdefined('MONEY_#session.ep.money#')>
	<cfset purchase_net_sys_2=attributes.purchase_net_system/evaluate('MONEY_#system_2_money#')>
	<cfset purchase_extra_sys_2=attributes.purchase_extra_cost_system/evaluate('MONEY_#system_2_money#')>
	<cfset purchase_net_sys_2_loc=attributes.purchase_net_system_location/evaluate('MONEY_#system_2_money#')>
	<cfset purchase_extra_sys_2_loc=attributes.purchase_extra_cost_system/evaluate('MONEY_#system_2_money#')><!--- ekmaliyette degismiyor birdek fiyat koruma degisiyor --->
<cfelse>
	<cfquery name="GET_MONEY_2" datasource="#arguments.period_dsn_type#">
		SELECT 
			(RATE2/RATE1) RATE,
			MONEY
		FROM
			SETUP_MONEY
		WHERE
			MONEY = <cfqueryparam value="#system_2_money#" cfsqltype="cf_sql_varchar">
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
			IS_PARTNER_STOCK,
			DUE_DATE,
			PHYSICAL_DATE,
			DUE_DATE_LOCATION,
			PHYSICAL_DATE_LOCATION
		FROM
			PRODUCT_COST
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
		<cfquery name="UPD_COST" datasource="#dsn1#">
			UPDATE
				PRODUCT_COST 
			SET
				PRODUCT_COST_STATUS = 0
			WHERE
				PRODUCT_ID = #attributes.product_id#
				AND START_DATE <= #attributes.start_date#
		</cfquery>
		<cfquery name="GET_COST_STATUS" datasource="#dsn1#">
			SELECT
				PRODUCT_COST_STATUS
			FROM
				PRODUCT_COST 
			WHERE
				PRODUCT_COST_STATUS = 1
				AND	PRODUCT_ID = #attributes.product_id#
				AND START_DATE > #attributes.start_date#
		</cfquery>
		<cfquery name="ADD_COST" datasource="#dsn1#">
			INSERT INTO
				PRODUCT_COST
					(
						PRODUCT_COST_STATUS,
						PROCESS_STAGE,
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
						DUE_DATE,
						PHYSICAL_DATE,
						<cfif len(attributes.department_id) and len(attributes.department)>
							DEPARTMENT_ID,
							LOCATION_ID,
							AVAILABLE_STOCK_LOCATION,
							PARTNER_STOCK_LOCATION,
							ACTIVE_STOCK_LOCATION,
                             <cfif not isdefined('attributes.is_suggest')>
							PRODUCT_COST_LOCATION,
                            </cfif>
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
							DUE_DATE_LOCATION,
							PHYSICAL_DATE_LOCATION,
						</cfif>
						PRICE_PROTECTION_TOTAL,
						PRICE_PROTECTION_AMOUNT,
						PRICE_PROTECTION_TYPE,
						IS_SUGGEST,
						RECORD_DATE,
						RECORD_EMP,
						RECORD_IP
					)
				VALUES
					(
						<cfif GET_COST_STATUS.RECORDCOUNT>0<cfelse>1</cfif>,
						#attributes.process_stage#,
                        <cfif isdefined("attributes.inventory_calc_type") and len(attributes.inventory_calc_type)>#attributes.inventory_calc_type#<cfelse>NULL</cfif>,
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
						<cfif len(attributes.available_stock)>#attributes.available_stock#<cfelse>NULL</cfif>,<!--- burdada stok miktarını attık elle eklendiğinde vedaha sonra guncellendiğinde sorun olmaması için burda tutyoruz --->
						NULL,

					<cfif session.ep.isBranchAuthorization>
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
						<cfif isdefined('GET_GENERAL_COST.DUE_DATE') and len(GET_GENERAL_COST.DUE_DATE)>#createodbcdatetime(GET_GENERAL_COST.DUE_DATE)#<cfelse>NULL</cfif>,
						<cfif isdefined('GET_GENERAL_COST.PHYSICAL_DATE') and len(GET_GENERAL_COST.PHYSICAL_DATE)>#createodbcdatetime(GET_GENERAL_COST.PHYSICAL_DATE)#<cfelse>NULL</cfif>,
						<cfif len(attributes.department_id) and len(attributes.department)>
							#attributes.department_id#,
							#attributes.location_id#,
							<cfif len(attributes.available_stock)>#attributes.available_stock#<cfelse>NULL</cfif>,
							<cfif len(attributes.partner_stock)>#attributes.partner_stock#<cfelse>NULL</cfif>,
							<cfif len(attributes.active_stock)>#attributes.active_stock#<cfelse>NULL</cfif>,
							<cfif not isdefined('attributes.is_suggest')>
							#wrk_round(attributes.product_cost_,8)#,<!--- (attributes.PURCHASE_NET+attributes.PURCHASE_EXTRA_COST+attributes.STANDARD_COST+((attributes.PURCHASE_NET*attributes.STANDARD_COST_RATE)/100)-attributes.PRICE_PROTECTION) --->
							</cfif>
							<cfif isdefined('attributes.product_cost_money') and len(attributes.product_cost_money)>'#attributes.product_cost_money#'<cfelse>NULL</cfif>,                            
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
							'#system_2_money#',
							#purchase_extra_sys_2#,
							<cfif isdefined('attributes.due_date') and len(attributes.due_date)>#attributes.due_date#<cfelse>NULL</cfif>,
							<cfif isdefined('attributes.physical_date') and len(attributes.physical_date)>#attributes.physical_date#<cfelse>NULL</cfif>,
						</cfif>
					<cfelse>
								<!--- PRODUCT TAN EKLENIYORSA SUBEDE GENEL MALİYET İÇİNDE AYNI DEGER YAZILIYOR --->
						<cfif len(attributes.available_stock)>#attributes.available_stock#<cfelse>NULL</cfif>,
							<cfif len(attributes.partner_stock)>#attributes.partner_stock#<cfelse>NULL</cfif>,
							<cfif len(attributes.active_stock)>#attributes.active_stock#<cfelse>NULL</cfif>,
							 <cfif isdefined("attributes.product_cost_") and len(attributes.product_cost_)>#wrk_round(attributes.product_cost_,8)#<cfelseif isdefined("attributes.product_cost") and len(attributes.product_cost)>#wrk_round(attributes.product_cost,8)#<cfelse>NULL</cfif>,<!--- (attributes.PURCHASE_NET+attributes.PURCHASE_EXTRA_COST+attributes.STANDARD_COST+((attributes.PURCHASE_NET*attributes.STANDARD_COST_RATE)/100)-attributes.PRICE_PROTECTION) --->					
							 <cfif isdefined("attributes.product_cost_money") and len(attributes.product_cost_money)>'#attributes.product_cost_money#'<cfelseif isdefined('attributes.purchase_net_money') and len(attributes.purchase_net_money)>'#attributes.purchase_net_money#'<cfelse>NULL</cfif>,							
							<cfif len(attributes.standard_cost)>#attributes.standard_cost#<cfelse>0</cfif>,
							'#attributes.standard_cost_money#',
							<cfif len(attributes.standard_cost_rate)>#attributes.standard_cost_rate#<cfelse>0</cfif>,
							<cfif len(attributes.purchase_net)>#purchase_net#<cfelse>0</cfif>,
							'#attributes.purchase_net_money#',
							<cfif len(attributes.purchase_extra_cost)>#attributes.purchase_extra_cost#<cfelse>0</cfif>,
							<cfif attributes.available_stock neq 0>
								<cfif isdefined('attributes.price_prot_amount') and len(attributes.price_protection)>#attributes.price_protection*attributes.price_prot_amount/attributes.available_stock#<cfelse>0</cfif>,
							<cfelse>
								0,
							</cfif>
							'#attributes.price_protection_money#',
							<cfif len(attributes.purchase_net_system)>#attributes.purchase_net_system#<cfelse>0</cfif>,
							'#SESSION.EP.MONEY#',
							<cfif len(attributes.purchase_extra_cost_system)>#attributes.purchase_extra_cost_system#<cfelse>0</cfif>,
							#purchase_net_sys_2#,
							'#system_2_money#',
							#purchase_extra_sys_2#,
							<cfif isdefined('attributes.due_date') and len(attributes.due_date)>#attributes.due_date#<cfelse>NULL</cfif>,
							<cfif isdefined('attributes.physical_date') and len(attributes.physical_date)>#attributes.physical_date#<cfelse>NULL</cfif>,
											
							<cfif len(attributes.department_id) and len(attributes.department)>
								#attributes.department_id#,
								#attributes.location_id#,
								<cfif isdefined('GET_LOC_AVAILABLE_STOCK') and len(GET_LOC_AVAILABLE_STOCK.PRODUCT_TOTAL_STOCK)>#GET_LOC_AVAILABLE_STOCK.PRODUCT_TOTAL_STOCK#<cfelse>0</cfif>,
								NULL,
								0,
								<cfif not isdefined('attributes.is_suggest')>
								#wrk_round(attributes.PURCHASE_NET+attributes.PURCHASE_EXTRA_COST+attributes.STANDARD_COST+((attributes.PURCHASE_NET*attributes.STANDARD_COST_RATE)/100)-(attributes.PRICE_PROTECTION_LOCATION*attributes.price_protection_type),8)#,
								</cfif>
								<cfif isdefined('attributes.product_cost_money') and len(attributes.product_cost_money)>'#attributes.product_cost_money#'<cfelse>NULL</cfif>,
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
								'#system_2_money#',
								#purchase_extra_sys_2_loc#,
								<cfif isdefined('attributes.due_date') and len(attributes.due_date)>#attributes.due_date#<cfelse>NULL</cfif>,
								<cfif isdefined('attributes.physical_date') and len(attributes.physical_date)>#attributes.physical_date#<cfelse>NULL</cfif>,
							</cfif>
					</cfif>
						<cfif isdefined('attributes.total_price_prot') and len(attributes.total_price_prot)>#attributes.total_price_prot#<cfelse>0</cfif>,
						<cfif isdefined('attributes.price_prot_amount') and len(attributes.price_prot_amount)>#attributes.price_prot_amount#<cfelse>0</cfif>,
						#attributes.price_protection_type#,<!--- işlemlerde zaten cıkarma şeklinde olduğundan 1 kaydediliyorsa cıkarıyor -1 ise topluyor--->
						<cfif isdefined('attributes.is_suggest')>#attributes.is_suggest#<cfelse>NULL</cfif>,
						#NOW()#,
						#SESSION.EP.USERID#,
						'#cgi.REMOTE_ADDR#'
					)
		</cfquery>
		<!--- Eğer öneriden maliyete dönüştürülüyorsa. --->
		<cfif isdefined('attributes.is_suggest')>
			<cfquery name="UPD_SUGGEST" datasource="#dsn1#">
				UPDATE PRODUCT_COST_SUGGESTION SET COST_SUGGESTION_STATUS = 1 WHERE PRODUCT_COST_SUGGESTION_ID = #attributes.is_suggest#
			</cfquery>
		</cfif>
		<cfquery datasource="#dsn1#" name="get_p_cost_id">
			SELECT MAX(PRODUCT_COST_ID) AS MAX_ID FROM PRODUCT_COST WHERE PRODUCT_ID = #PRODUCT_ID#
		</cfquery>
		<cfset "rate_#session.ep.money#" = 1>
		<cfquery name="get_money" datasource="#dsn1#">
			SELECT * FROM #dsn2_alias#.SETUP_MONEY
		</cfquery>
		<cfloop query="get_money">
			<cfquery name="get_rate" datasource="#dsn1#" maxrows="1">
				SELECT
					(RATE2/RATE1) AS RATE
					,MONEY 
				FROM 
					#dsn_alias#.MONEY_HISTORY
				WHERE 
					VALIDATE_DATE <= #attributes.start_date#
					AND COMPANY_ID = #session.ep.company_id#
					AND PERIOD_ID = #session.ep.period_id#
					AND MONEY = '#get_money.MONEY#'
				ORDER BY
					VALIDATE_DATE DESC,
					MONEY_HISTORY_ID DESC
			</cfquery>
			<cfoutput query="get_rate">
				<cfset "rate_#money#" = rate>
			</cfoutput>
		</cfloop>
		<cfquery name="get_cost" datasource="#dsn1#">
			SELECT PRICE_PROTECTION_MONEY FROM PRODUCT_COST WHERE PRODUCT_COST_ID = #get_p_cost_id.MAX_ID#
		</cfquery>
		<cfif attributes.purchase_net neq 0>
			<cfset rate_other = wrk_round(attributes.purchase_net_system/attributes.purchase_net,8)>
		<cfelse>
			<cfset rate_other =1>
		</cfif>
		<cfif purchase_net_sys_2 neq 0>
			<cfset rate_2 = wrk_round(attributes.purchase_net_system/purchase_net_sys_2,8)>
		<cfelse>
			<cfset rate_2 =1>
		</cfif>
		<cfquery name="upd_cost" datasource="#dsn1#">
			UPDATE
				PRODUCT_COST
			SET
				PURCHASE_NET_ALL = PURCHASE_NET + (PRICE_PROTECTION*-1*ISNULL(PRICE_PROTECTION_TYPE,1)*#evaluate("rate_#get_cost.PRICE_PROTECTION_MONEY#")#/#rate_other#),
				PURCHASE_NET_SYSTEM_ALL = (PURCHASE_NET + (PRICE_PROTECTION*-1*ISNULL(PRICE_PROTECTION_TYPE,1)*#evaluate("rate_#get_cost.PRICE_PROTECTION_MONEY#")#/#rate_other#))*#rate_other#,
				PURCHASE_NET_SYSTEM_2_ALL = (PURCHASE_NET + (PRICE_PROTECTION*-1*ISNULL(PRICE_PROTECTION_TYPE,1)*#evaluate("rate_#get_cost.PRICE_PROTECTION_MONEY#")#/#rate_other#))*(#rate_other#/#rate_2#),
				PURCHASE_NET_LOCATION_ALL = PURCHASE_NET_LOCATION + (PRICE_PROTECTION*-1*ISNULL(PRICE_PROTECTION_TYPE,1)*#evaluate("rate_#get_cost.PRICE_PROTECTION_MONEY#")#/#rate_other#),
				PURCHASE_NET_SYSTEM_LOCATION_ALL = (PURCHASE_NET_LOCATION + (PRICE_PROTECTION*-1*ISNULL(PRICE_PROTECTION_TYPE,1)*#evaluate("rate_#get_cost.PRICE_PROTECTION_MONEY#")#/#rate_other#))*#rate_other#,
				PURCHASE_NET_SYSTEM_2_LOCATION_ALL = (PURCHASE_NET_LOCATION + (PRICE_PROTECTION*-1*ISNULL(PRICE_PROTECTION_TYPE,1)*#evaluate("rate_#get_cost.PRICE_PROTECTION_MONEY#")#/#rate_other#))*(#rate_other#/#rate_2#)
			WHERE
				PRODUCT_COST_ID = #get_p_cost_id.MAX_ID#
		</cfquery>
		<cf_workcube_process
			is_upd='1'
			data_source ='#dsn1#'
			old_process_line='0'
			process_stage='#attributes.process_stage#' 
			record_member='#session.ep.userid#' 
			record_date='#now()#' 
			action_table='PRODUCT_COST'
			action_column='PRODUCT_COST_ID'
			action_id='#PRODUCT_ID#'
			action_page='#request.self#?fuseaction=product.form_add_product_cost&pid=#PRODUCT_ID#' 
			warning_description="#getLang('','Maliyet Ekleme',64682)# : #get_p_cost_id.MAX_ID#">
	</cflock>
</cftransaction>
<!--- Buraya kadar alıcaz fiyat önerisi için PRODUCT_COST_SUGGESTION TABLOSU AÇILDI BURDA MALİYET ÖNERİLERİ TUTULACAK. --->
<cfquery name="GET_COMPS_PER" datasource="#DSN#">
	SELECT 
		SP2.PERIOD_ID,
		SP2.PERIOD_YEAR,
		SP2.OUR_COMPANY_ID
	FROM 
		SETUP_PERIOD SP,
		SETUP_PERIOD SP2
	WHERE 
		SP.PERIOD_ID=#session.ep.period_id#
		AND SP.OUR_COMPANY_ID=SP2.OUR_COMPANY_ID
</cfquery>
<cfif GET_COMPS_PER.RECORDCOUNT>
	<cfset comp_period_list=ValueList(GET_COMPS_PER.PERIOD_ID)><!--- sirket bazli maliyet oldugu icin sirkete ait priodlar bir listeye aliniyor ve o periodlardaki maliyetlerde islemler yapiliyor --->
	<cfset comp_period_year_list=ValueList(GET_COMPS_PER.PERIOD_YEAR)><!--- sirket bazli maliyet oldugu icin sirkete ait priodlar bir listeye aliniyor ve o periodlardaki maliyetlerde islemler yapiliyor --->
</cfif>
<cfif not isdefined('comp_period_list') or not len(comp_period_list)><!--- bu ihtimal yok ama yinede olsun --->
	<cfset comp_period_list=session.ep.period_id>
	<cfset comp_period_year_list=year(now())>
</cfif>
<cfif len(attributes.spect_main_id)>
	<cfset newer_spec_id=attributes.spect_main_id>
<cfelse>
	<cfset newer_spec_id=''>
</cfif>
<cfscript>
form.dsn1=dsn1;
upd_newer_cost(
					newer_action_id=0,
					newer_action_row_id=0,
					newer_product_cost_id=get_p_cost_id.MAX_ID,
					newer_spec_main_id=newer_spec_id,
					newer_product_id=attributes.product_id,
					newer_action_date=CreateODBCDate(attributes.start_date),
					newer_record_date=now(),
					newer_comp_period_list='#comp_period_list#',
					newer_comp_period_year_list='#comp_period_year_list#',
					newer_dsn=dsn,
					newer_dsn3=dsn3,
					newer_period_dsn_type=dsn2,
					newer_our_company_id=GET_COMPS_PER.OUR_COMPANY_ID
				);
</cfscript>
<cfif attributes.cost_control eq 1><!--- fiyat koruma kaydı yapilacaksa --->
	<cfset attributes.cost_id=get_p_cost_id.MAX_ID>
	<cfinclude template="add_price_protection_control.cfm">
</cfif>
<script type="text/javascript">
	window.location.href = '<cfoutput>#cgi.HTTP_REFERER#</cfoutput>';
</script>
