<!---<cfdump var='#attributes#'><cfabort>---><cfparam name="attributes.price_protection_type" default="1">
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
<!--- FONKSİON İÇİND KULLAILIYOR --->
<cfquery name="GET_NOT_DEP_COST" datasource="#DSN#">
	SELECT 
		DEPARTMENT_ID,LOCATION_ID 
	FROM 
		STOCKS_LOCATION STOCKS_LOCATION
	WHERE 
		ISNULL(IS_COST_ACTION,0)=1
</cfquery>
<!---// FONKSİON İÇİND KULLAILIYOR --->
<cfif not len(session.ep.money2)>
	<cfset system_2_money='USD'>
<cfelse>
	<cfset system_2_money='#session.ep.money2#'>
</cfif>
<cfif isdefined('MONEY_#session.ep.money#')>
	<cfset purchase_net_sys_2=attributes.purchase_net_system/evaluate('MONEY_#system_2_money#')>
	<cfset purchase_extra_sys_2=wrk_round(attributes.purchase_extra_cost_system/evaluate('MONEY_#system_2_money#'),attributes.round_number,1)>
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
	<cfset purchase_net_sys_2=attributes.purchase_net_system/GET_MONEY_2.RATE>
	<cfset purchase_extra_sys_2=attributes.purchase_extra_cost_system/GET_MONEY_2.RATE>
	<cfset purchase_net_sys_2_loc=attributes.purchase_net_system_location/GET_MONEY_2.RATE>
	<cfset purchase_extra_sys_2_loc=attributes.purchase_extra_cost_system/GET_MONEY_2.RATE>
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
			PRICE_PROTECTION_TYPE,
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
			<cfif len(attributes.location_id)>
				AND STORE_LOCATION = #attributes.location_id#
			</cfif>
			<cfif len(attributes.spect_main_id)>
				AND SPECT_VAR_ID=#attributes.spect_main_id#
			<cfelse>
				AND SPECT_VAR_ID IS NULL
			</cfif>
	</cfquery>
	<cfquery name="GET_LOC_ACTIVE_STOCK" datasource="#dsn2#">
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
</cfif>

<cfquery name="UPD_COST" datasource="#dsn1#">
	UPDATE 
		PRODUCT_COST 
	SET
    	<cfif isdefined('attributes.process_stage') and len(attributes.process_stage)>
			PROCESS_STAGE = #attributes.process_stage#,
		</cfif>
		INVENTORY_CALC_TYPE = #INVENTORY_CALC_TYPE#,
		IS_SPEC = <cfif len(attributes.spect_main_id)>1<cfelse>0</cfif>,
		SPECT_MAIN_ID=<cfif len(attributes.spect_main_id)>#attributes.spect_main_id#<cfelse>NULL</cfif>,
		COST_TYPE_ID=<cfif isdefined("attributes.cost_type") and len(attributes.cost_type)>#attributes.cost_type#<cfelse>NULL</cfif>,
		START_DATE = <cfif isdefined('attributes.start_date') and len(attributes.start_date)>#attributes.start_date#<cfelse>NULL</cfif>,
		COST_DESCRIPTION = <cfif len(attributes.cost_description)>'#cost_description#'<cfelse>NULL</cfif>,
		<cfif fusebox.Circuit eq 'product'>
			AVAILABLE_STOCK = <cfif len(attributes.available_stock)>#attributes.available_stock#<cfelse>NULL</cfif>,
			ACTION_AMOUNT = <cfif len(attributes.available_stock)>#attributes.available_stock#<cfelse>0</cfif>,
			PARTNER_STOCK = <cfif len(attributes.partner_stock)>#attributes.partner_stock#<cfelse>NULL</cfif>,
			ACTIVE_STOCK = <cfif len(attributes.active_stock)>#attributes.active_stock#<cfelse>NULL</cfif>,
			PRODUCT_COST = <cfif len(attributes.product_cost_)>#wrk_round(attributes.product_cost_,attributes.round_number)#<cfelse>0</cfif>,
			STANDARD_COST = <cfif len(attributes.standard_cost)>#attributes.standard_cost#<cfelse>0</cfif>,
			STANDARD_COST_MONEY = '#attributes.standard_cost_money#',
			STANDARD_COST_RATE = <cfif len(attributes.standard_cost_rate)>#attributes.standard_cost_rate#<cfelse>0</cfif>,
			PURCHASE_NET = <cfif len(attributes.purchase_net)>#attributes.purchase_net#<cfelse>0</cfif>,
			PURCHASE_NET_MONEY = '#attributes.purchase_net_money#',
			PURCHASE_EXTRA_COST = <cfif len(attributes.purchase_extra_cost)>#attributes.purchase_extra_cost#<cfelse>0</cfif>,
			PRICE_PROTECTION = <cfif len(attributes.price_protection)>#attributes.price_protection#<cfelse>0</cfif>,
			PRICE_PROTECTION_MONEY = '#attributes.price_protection_money#',
			PURCHASE_NET_SYSTEM = <cfif len(attributes.purchase_net_system)>#attributes.purchase_net_system#<cfelse>0</cfif>,
			PURCHASE_NET_SYSTEM_MONEY = '#SESSION.EP.MONEY#',
			PURCHASE_EXTRA_COST_SYSTEM = <cfif len(attributes.purchase_extra_cost_system)>#attributes.purchase_extra_cost_system#<cfelse>0</cfif>,	
			PURCHASE_NET_SYSTEM_2 = #purchase_net_sys_2#,
			PURCHASE_EXTRA_COST_SYSTEM_2 = #purchase_extra_sys_2#,
			PURCHASE_NET_SYSTEM_MONEY_2='#system_2_money#',
			DUE_DATE=<cfif isdefined("attributes.due_date") and len(attributes.due_date)>#attributes.due_date#<cfelse>NULL</cfif>,
			PHYSICAL_DATE=<cfif isdefined("attributes.physical_date") and len(attributes.physical_date)>#attributes.physical_date#<cfelse>NULL</cfif>,
			<cfif len(attributes.department_id) and len(attributes.department)>
				DEPARTMENT_ID=#attributes.department_id#,
				<cfif len(attributes.location_id)>
					LOCATION_ID=#attributes.location_id#,
                </cfif>
				<cfif attributes.action_type gt 0>
					AVAILABLE_STOCK_LOCATION =<cfif isdefined('GET_LOC_AVAILABLE_STOCK') and len(GET_LOC_AVAILABLE_STOCK.PRODUCT_TOTAL_STOCK)>#GET_LOC_AVAILABLE_STOCK.PRODUCT_TOTAL_STOCK#<cfelse>0</cfif>,
					ACTIVE_STOCK_LOCATION = <cfif isdefined('GET_LOC_ACTIVE_STOCK') and len(GET_LOC_ACTIVE_STOCK.PRODUCT_TOTAL_STOCK)>#GET_LOC_ACTIVE_STOCK.PRODUCT_TOTAL_STOCK#<cfelse>0</cfif>,
                </cfif>
				PRODUCT_COST_LOCATION = #wrk_round(attributes.PURCHASE_NET+attributes.PURCHASE_EXTRA_COST+attributes.STANDARD_COST+((attributes.PURCHASE_NET*attributes.STANDARD_COST_RATE)/100)-(attributes.PRICE_PROTECTION_LOCATION * attributes.price_protection_type),attributes.round_number)#,
				MONEY_LOCATION = '#attributes.product_cost_money#',
				STANDARD_COST_LOCATION = <cfif len(attributes.standard_cost)>#attributes.standard_cost#<cfelse>0</cfif>,
				STANDARD_COST_MONEY_LOCATION = '#attributes.standard_cost_money#',
				STANDARD_COST_RATE_LOCATION = <cfif len(attributes.standard_cost_rate)>#attributes.standard_cost_rate#<cfelse>0</cfif>,
				PURCHASE_NET_LOCATION=<cfif len(attributes.purchase_net)>#attributes.purchase_net#<cfelse>0</cfif>,
				PURCHASE_NET_MONEY_LOCATION='#attributes.purchase_net_money#',
				PURCHASE_EXTRA_COST_LOCATION=<cfif len(attributes.purchase_extra_cost)>#attributes.purchase_extra_cost#<cfelse>0</cfif>,
				PRICE_PROTECTION_LOCATION = <cfif isdefined("attributes.price_protection_location") and len(attributes.price_protection_location)>#attributes.price_protection_location#<cfelse>0</cfif>,
				PRICE_PROTECTION_MONEY_LOCATION = <cfif isdefined("attributes.price_protection_money_location") and len(attributes.price_protection_money_location)>'#attributes.price_protection_money_location#'<cfelse>'#session.ep.money#'</cfif>,
				PURCHASE_NET_SYSTEM_LOCATION = <cfif len(attributes.purchase_net_system_location)>#attributes.purchase_net_system_location#<cfelse>0</cfif>,
				PURCHASE_NET_SYSTEM_MONEY_LOCATION = '#SESSION.EP.MONEY#',
				PURCHASE_EXTRA_COST_SYSTEM_LOCATION = <cfif len(attributes.purchase_extra_cost_system)>#attributes.purchase_extra_cost_system#<cfelse>0</cfif>,
				PURCHASE_NET_SYSTEM_2_LOCATION = #purchase_net_sys_2_loc#,
				PURCHASE_NET_SYSTEM_MONEY_2_LOCATION = '#system_2_money#',
				PURCHASE_EXTRA_COST_SYSTEM_2_LOCATION = #purchase_extra_sys_2_loc#,
				DUE_DATE_LOCATION=<cfif isdefined("attributes.due_date") and len(attributes.due_date)>#attributes.due_date#<cfelse>NULL</cfif>,
				PHYSICAL_DATE_LOCATION=<cfif isdefined("attributes.physical_date") and len(attributes.physical_date)>#attributes.physical_date#<cfelse>NULL</cfif>,
			</cfif>
		<cfelse>
            <cfif attributes.action_type gt 0>
				AVAILABLE_STOCK = <cfif isdefined('GET_GENERAL_AVAILABLE_STOCK') and len(GET_GENERAL_AVAILABLE_STOCK.PRODUCT_TOTAL_STOCK)>#GET_GENERAL_AVAILABLE_STOCK.PRODUCT_TOTAL_STOCK#<cfelse>0</cfif>,
				ACTION_AMOUNT = <cfif len(attributes.available_stock)>#attributes.available_stock#<cfelse>0</cfif>,
				PARTNER_STOCK = NULL,
				ACTIVE_STOCK = <cfif isdefined('GET_GENERAL_ACTIVE_STOCK') and len(GET_GENERAL_ACTIVE_STOCK.PRODUCT_TOTAL_STOCK)>#GET_GENERAL_ACTIVE_STOCK.PRODUCT_TOTAL_STOCK#<cfelse>0</cfif>,
			</cfif>
			PRODUCT_COST = #GET_GENERAL_COST.PRODUCT_COST#,
			MONEY = '#GET_GENERAL_COST.MONEY#',
			STANDARD_COST = <cfif len(GET_GENERAL_COST.STANDARD_COST)>#GET_GENERAL_COST.STANDARD_COST#<cfelse>0</cfif>,
			STANDARD_COST_MONEY = '#GET_GENERAL_COST.STANDARD_COST_MONEY#',
			STANDARD_COST_RATE = <cfif len(GET_GENERAL_COST.STANDARD_COST_RATE)>#GET_GENERAL_COST.STANDARD_COST_RATE#<cfelse>0</cfif>,
			PURCHASE_NET = <cfif len(GET_GENERAL_COST.PURCHASE_NET)>#GET_GENERAL_COST.PURCHASE_NET#<cfelse>0</cfif>,
			PURCHASE_NET_MONEY = '#GET_GENERAL_COST.PURCHASE_NET_MONEY#',
			PURCHASE_EXTRA_COST = <cfif len(GET_GENERAL_COST.PURCHASE_EXTRA_COST)>#GET_GENERAL_COST.PURCHASE_EXTRA_COST#<cfelse>0</cfif>,
			PRICE_PROTECTION = <cfif len(GET_GENERAL_COST.PRICE_PROTECTION)>#GET_GENERAL_COST.PRICE_PROTECTION#<cfelse>0</cfif>,
			PRICE_PROTECTION_MONEY = '#GET_GENERAL_COST.PRICE_PROTECTION_MONEY#',
			
			PURCHASE_NET_SYSTEM = <cfif len(GET_GENERAL_COST.PURCHASE_NET_SYSTEM)>#GET_GENERAL_COST.PURCHASE_NET_SYSTEM#<cfelse>0</cfif>,
			PURCHASE_NET_SYSTEM_MONEY = '#GET_GENERAL_COST.PURCHASE_NET_SYSTEM_MONEY#',
			PURCHASE_EXTRA_COST_SYSTEM = <cfif len(GET_GENERAL_COST.PURCHASE_EXTRA_COST_SYSTEM)>#GET_GENERAL_COST.PURCHASE_EXTRA_COST_SYSTEM#<cfelse>0</cfif>,
			PURCHASE_NET_SYSTEM_2 = #GET_GENERAL_COST.PURCHASE_NET_SYSTEM_2#,
			PURCHASE_NET_SYSTEM_MONEY_2 = '#GET_GENERAL_COST.PURCHASE_NET_SYSTEM_MONEY_2#',
			PURCHASE_EXTRA_COST_SYSTEM_2 = #GET_GENERAL_COST.PURCHASE_EXTRA_COST_SYSTEM_2#,
			DUE_DATE=<cfif isdefined('GET_GENERAL_COST.DUE_DATE') and len(GET_GENERAL_COST.DUE_DATE)>#createodbcdatetime(GET_GENERAL_COST.DUE_DATE)#<cfelse>NULL</cfif>,
			PHYSICAL_DATE=<cfif isdefined('GET_GENERAL_COST.PHYSICAL_DATE') and len(GET_GENERAL_COST.PHYSICAL_DATE)>#createodbcdatetime(GET_GENERAL_COST.PHYSICAL_DATE)#<cfelse>NULL</cfif>,
			<cfif len(attributes.department_id) and len(attributes.department)>
				DEPARTMENT_ID=#attributes.department_id#,
				<cfif len(attributes.location_id)>
					LOCATION_ID=#attributes.location_id#,
                </cfif>
                <cfif attributes.action_type gt 0>
					AVAILABLE_STOCK_LOCATION =<cfif isdefined('GET_LOC_AVAILABLE_STOCK') and len(GET_LOC_AVAILABLE_STOCK.PRODUCT_TOTAL_STOCK)>#GET_LOC_AVAILABLE_STOCK.PRODUCT_TOTAL_STOCK#<cfelse>0</cfif>,
					ACTIVE_STOCK_LOCATION = <cfif isdefined('GET_LOC_ACTIVE_STOCK') and len(GET_LOC_ACTIVE_STOCK.PRODUCT_TOTAL_STOCK)>#GET_LOC_ACTIVE_STOCK.PRODUCT_TOTAL_STOCK#<cfelse>0</cfif>,
                </cfif>
				PRODUCT_COST_LOCATION = #wrk_round(attributes.product_cost_,attributes.round_number)#,
				MONEY_LOCATION = '#attributes.product_cost_money#',
				STANDARD_COST_LOCATION = <cfif len(attributes.standard_cost)>#attributes.standard_cost#<cfelse>0</cfif>,
				STANDARD_COST_MONEY_LOCATION = '#attributes.standard_cost_money#',
				STANDARD_COST_RATE_LOCATION = <cfif len(attributes.standard_cost_rate)>#attributes.standard_cost_rate#<cfelse>0</cfif>,
				PURCHASE_NET_LOCATION=<cfif len(attributes.purchase_net)>#attributes.purchase_net#<cfelse>0</cfif>,
				PURCHASE_NET_MONEY_LOCATION='#attributes.purchase_net_money#',
				PURCHASE_EXTRA_COST_LOCATION=<cfif len(attributes.purchase_extra_cost)>#attributes.purchase_extra_cost#<cfelse>0</cfif>,
				PRICE_PROTECTION_LOCATION = <cfif len(attributes.price_protection)>#attributes.price_protection#<cfelse>0</cfif>,
				PRICE_PROTECTION_MONEY_LOCATION = '#attributes.price_protection_money#',
				PURCHASE_NET_SYSTEM_LOCATION = <cfif len(attributes.purchase_net_system)>#attributes.purchase_net_system#<cfelse>0</cfif>,
				PURCHASE_NET_SYSTEM_MONEY_LOCATION = '#SESSION.EP.MONEY#',
				PURCHASE_EXTRA_COST_SYSTEM_LOCATION = <cfif len(attributes.purchase_extra_cost_system)>#attributes.purchase_extra_cost_system#<cfelse>0</cfif>,
				PURCHASE_NET_SYSTEM_2_LOCATION = #purchase_net_sys_2#,
				PURCHASE_NET_SYSTEM_MONEY_2_LOCATION = '#system_2_money#',
				PURCHASE_EXTRA_COST_SYSTEM_2_LOCATION = #purchase_extra_sys_2#,
				DUE_DATE_LOCATION=<cfif isdefined("attributes.due_date") and len(attributes.due_date)>#attributes.due_date#<cfelse>NULL</cfif>,
				PHYSICAL_DATE_LOCATION=<cfif isdefined("attributes.physical_date") and len(attributes.physical_date)>#attributes.physical_date#<cfelse>NULL</cfif>,
			</cfif>
		</cfif>
		PRICE_PROTECTION_TOTAL = <cfif isdefined('attributes.total_price_prot') and len(attributes.total_price_prot)>#attributes.total_price_prot#<cfelse>0</cfif>,
		PRICE_PROTECTION_AMOUNT = <cfif isdefined('attributes.price_prot_amount') and len(attributes.price_prot_amount)>#attributes.price_prot_amount#<cfelse>0</cfif>,
		PRICE_PROTECTION_TYPE =	#attributes.price_protection_type#,
		UPDATE_DATE = #now()#,
		UPDATE_EMP = #session.ep.userid#,
		UPDATE_IP = '#cgi.REMOTE_ADDR#'
	WHERE 
		PRODUCT_COST_ID = #attributes.pcid#
</cfquery>
<cfset "rate_#session.ep.money#" = 1>
<cfquery name="get_money" datasource="#dsn2#">
	SELECT * FROM SETUP_MONEY
</cfquery>
<cfloop query="get_money">
	<cfquery name="get_rate" datasource="#dsn#" maxrows="1">
		SELECT
			(RATE2/RATE1) AS RATE
			,MONEY 
		FROM 
			MONEY_HISTORY
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
<cfif attributes.purchase_net neq 0>
	<cfset rate_other = wrk_round(attributes.purchase_net_system/attributes.purchase_net,attributes.round_number)>
<cfelse>
	<cfset rate_other =1>
</cfif>
<cfif purchase_net_sys_2 neq 0>
	<cfset rate_2 = wrk_round(attributes.purchase_net_system/purchase_net_sys_2,attributes.round_number)>
<cfelse>
	<cfset rate_2 =1>
</cfif>
<cfquery name="get_cost" datasource="#dsn1#">
	SELECT PRICE_PROTECTION_MONEY FROM PRODUCT_COST WHERE PRODUCT_COST_ID =#attributes.pcid#
</cfquery>
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
		PRODUCT_COST_ID =#attributes.pcid#
</cfquery>
<cfif isdefined('attributes.process_stage') and len(attributes.process_stage)>
<cf_workcube_process 
	is_upd='1'
	data_source='#dsn1#'
	old_process_line='#attributes.old_process_line#'
	process_stage='#attributes.process_stage#' 
	record_member='#session.ep.userid#'
	record_date='#now()#' 
	action_table='PRODUCT_COST'
	action_column='PRODUCT_COST_ID'
	action_id='#attributes.product_id#' 
	action_page='#request.self#?fuseaction=product.form_add_product_cost&pid=#attributes.product_id#' 
	warning_description='Maliyet Güncelleme : #FORM.pcid#'>
</cfif>
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
				newer_product_cost_id=attributes.pcid,
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
	<cfset attributes.cost_id=#FORM.pcid#>
	<cfinclude template="add_price_protection_control.cfm">
</cfif>
<script type="text/javascript">
	location.href = document.referrer;
	window.close();
</script>
