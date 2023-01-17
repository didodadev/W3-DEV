<cfsetting showdebugoutput="yes">
<cf_get_lang_set module_name="product">
<cf_xml_page_edit fuseact="product.form_add_product_cost">
<cfparam name="attributes.department_id" default="">
<cfparam name="attributes.graph_type" default="">
<cfparam name="attributes.start_date" default="">
<cfparam name="attributes.finish_date" default="">
<cfparam name="attributes.modal_id" default="">
<!--- Tarih Filitresindeki Verilerin gg/aa/yyyy şeklinde gelmesi için kullanıldı.Created by MCP 20130917 --->
<cfif isdefined("attributes.start_date") and isdate(attributes.start_date)>
	<cf_date tarih="attributes.start_date">
<cfelse>
	<cfparam name="attributes.start_date" default="">
</cfif>
<cfif isdefined("attributes.finish_date") and isdate(attributes.finish_date)>
	<cf_date tarih="attributes.finish_date">
<cfelse>
	<cfparam name="attributes.finish_date" default="">
</cfif>
<!--- Sayfalamada, Filitrede seçilen verilerini diğer sayfaya aktarması için kullanıldı.Created by MCP 20130917 --->
<cfset adres = url.fuseaction>
<cfset adres = "#adres#&product.popup_list_product_cost_detail&pid=#attributes.pid#&department_id=#attributes.department_id#&graph_type=#attributes.graph_type#">
<cfinclude template="../../stock/query/get_stores.cfm">
<cfquery name="GET_ALL_LOCATION" datasource="#DSN#">
	SELECT DEPARTMENT_ID, LOCATION_ID, COMMENT, STATUS FROM STOCKS_LOCATION ORDER BY COMMENT
</cfquery>
<cfsavecontent variable="ay1"><cf_get_lang dictionary_id='57592.Ocak'></cfsavecontent>
<cfsavecontent variable="ay2"><cf_get_lang dictionary_id='57593.Şubat'></cfsavecontent>
<cfsavecontent variable="ay3"><cf_get_lang dictionary_id='57594.Mart'></cfsavecontent>
<cfsavecontent variable="ay4"><cf_get_lang dictionary_id='57595.Nisan'></cfsavecontent>
<cfsavecontent variable="ay5"><cf_get_lang dictionary_id='57596.Mayıs'></cfsavecontent>
<cfsavecontent variable="ay6"><cf_get_lang dictionary_id='57597.Haziran'></cfsavecontent>
<cfsavecontent variable="ay7"><cf_get_lang dictionary_id='57598.Temmuz'></cfsavecontent>
<cfsavecontent variable="ay8"><cf_get_lang dictionary_id='57599.Ağustos'></cfsavecontent>
<cfsavecontent variable="ay9"><cf_get_lang dictionary_id='57600.Eylül'></cfsavecontent>
<cfsavecontent variable="ay10"><cf_get_lang dictionary_id='57601.Ekim'></cfsavecontent>
<cfsavecontent variable="ay11"><cf_get_lang dictionary_id='57602.Kasım'></cfsavecontent>
<cfsavecontent variable="ay12"><cf_get_lang dictionary_id='57603.Aralık'></cfsavecontent>
	
<cfset aylar = "#ay1#,#ay2#,#ay3#,#ay4#,#ay5#,#ay6#,#ay7#,#ay8#,#ay9#,#ay10#,#ay11#,#ay12#">
<cfif session.ep.isBranchAuthorization eq 0>
	<cfquery name="GET_PRODUCT_COST" datasource="#DSN3#">
		SELECT 
			(SELECT S.STOCK_CODE FROM STOCKS S WHERE S.STOCK_ID = PRODUCT_COST.STOCK_ID) STOCK_CODE,
			ACTION_PERIOD_ID,
			ACTION_TYPE,
			ACTION_PROCESS_TYPE,
			ACTION_ID,
			ACTION_ROW_ID,
			PRODUCT_COST_ID,
			ISNULL(STANDARD_COST_LOCATION,0) STANDARD_COST_LOCATION,
			ISNULL(STANDARD_COST_MONEY_LOCATION,0) STANDARD_COST_MONEY_LOCATION,
            ISNULL(STANDARD_COST_DEPARTMENT,0) STANDARD_COST_DEPARTMENT,
			ISNULL(STANDARD_COST_MONEY_DEPARTMENT,0) STANDARD_COST_MONEY_DEPARTMENT,
			ISNULL(STANDARD_COST,0) STANDARD_COST,
			ISNULL(STANDARD_COST_MONEY,0) STANDARD_COST_MONEY,
			ISNULL(STANDARD_COST_RATE,0) STANDARD_COST_RATE,
			ISNULL(STANDARD_COST_RATE_LOCATION,0) STANDARD_COST_RATE_LOCATION,
            ISNULL(STANDARD_COST_RATE_DEPARTMENT,0) STANDARD_COST_RATE_DEPARTMENT,
			ISNULL(PRICE_PROTECTION,0) PRICE_PROTECTION,
			ISNULL(PRICE_PROTECTION_LOCATION,0) PRICE_PROTECTION_LOCATION,
            ISNULL(PRICE_PROTECTION_DEPARTMENT,0) PRICE_PROTECTION_DEPARTMENT,
			ISNULL(PRICE_PROTECTION_MONEY,0) PRICE_PROTECTION_MONEY,
			ISNULL(PRICE_PROTECTION_MONEY_LOCATION,0) PRICE_PROTECTION_MONEY_LOCATION,
            ISNULL(PRICE_PROTECTION_MONEY_DEPARTMENT,0) PRICE_PROTECTION_MONEY_DEPARTMENT,
			ISNULL(SPECT_MAIN_ID,0) SPECT_MAIN_ID,
			START_DATE,
			MONTH(START_DATE) MONTH_START_DATE,
			ISNULL(PURCHASE_NET,0) PURCHASE_NET,
			ISNULL(PURCHASE_NET_LOCATION,0) PURCHASE_NET_LOCATION,
            ISNULL(PURCHASE_NET_DEPARTMENT,0) PURCHASE_NET_DEPARTMENT,
			ISNULL(PURCHASE_NET_MONEY,0) PURCHASE_NET_MONEY,
			ISNULL(PURCHASE_NET_MONEY_LOCATION,0) PURCHASE_NET_MONEY_LOCATION,
            ISNULL(PURCHASE_NET_MONEY_DEPARTMENT,0) PURCHASE_NET_MONEY_DEPARTMENT,
			ISNULL(PURCHASE_EXTRA_COST,0) PURCHASE_EXTRA_COST,
			ISNULL(PURCHASE_EXTRA_COST_LOCATION,0) PURCHASE_EXTRA_COST_LOCATION,
            ISNULL(PURCHASE_EXTRA_COST_DEPARTMENT,0) PURCHASE_EXTRA_COST_DEPARTMENT,
			ISNULL(PRODUCT_COST,0) PRODUCT_COST,
			ISNULL(PRODUCT_COST_LOCATION,0) PRODUCT_COST_LOCATION,
            ISNULL(PRODUCT_COST_LOCATION,0) PRODUCT_COST_DEPARTMENT,
			MONEY,
			MONEY_LOCATION,
            MONEY_DEPARTMENT,
			ISNULL(PURCHASE_NET_SYSTEM,0) AS PURCHASE_NET_SYSTEM,
			ISNULL(PURCHASE_NET_SYSTEM_LOCATION,0) PURCHASE_NET_SYSTEM_LOCATION,
            ISNULL(PURCHASE_NET_SYSTEM_DEPARTMENT,0) PURCHASE_NET_SYSTEM_DEPARTMENT,
			ISNULL(PURCHASE_NET_SYSTEM_MONEY,0) PURCHASE_NET_SYSTEM_MONEY,
			ISNULL(PURCHASE_NET_SYSTEM_MONEY_LOCATION,0) PURCHASE_NET_SYSTEM_MONEY_LOCATION,
            ISNULL(PURCHASE_NET_SYSTEM_MONEY_DEPARTMENT,0) PURCHASE_NET_SYSTEM_MONEY_DEPARTMENT,
			ISNULL(PURCHASE_EXTRA_COST_SYSTEM,0) PURCHASE_EXTRA_COST_SYSTEM,
			ISNULL(PURCHASE_EXTRA_COST_SYSTEM_LOCATION,0) PURCHASE_EXTRA_COST_SYSTEM_LOCATION,
            ISNULL(PURCHASE_EXTRA_COST_SYSTEM_DEPARTMENT,0) PURCHASE_EXTRA_COST_SYSTEM_DEPARTMENT,
			ISNULL(PURCHASE_NET_SYSTEM_2,0) PURCHASE_NET_SYSTEM_2,
			ISNULL(PURCHASE_NET_SYSTEM_2_LOCATION,0) PURCHASE_NET_SYSTEM_2_LOCATION,
            ISNULL(PURCHASE_NET_SYSTEM_2_DEPARTMENT,0) PURCHASE_NET_SYSTEM_2_DEPARTMENT,
			ISNULL(PURCHASE_EXTRA_COST_SYSTEM_2,0) PURCHASE_EXTRA_COST_SYSTEM_2,
			ISNULL(PURCHASE_EXTRA_COST_SYSTEM_2_LOCATION,0) PURCHASE_EXTRA_COST_SYSTEM_2_LOCATION,
            ISNULL(PURCHASE_EXTRA_COST_SYSTEM_2_DEPARTMENT,0) PURCHASE_EXTRA_COST_SYSTEM_2_DEPARTMENT,
			AVAILABLE_STOCK,
			AVAILABLE_STOCK_LOCATION,
            AVAILABLE_STOCK_DEPARTMENT,
			PARTNER_STOCK,
			PARTNER_STOCK_LOCATION,
            PARTNER_STOCK_DEPARTMENT,
			ACTIVE_STOCK,
			ACTIVE_STOCK_LOCATION,
            ACTIVE_STOCK_DEPARTMENT,
			DUE_DATE,
			DUE_DATE_LOCATION,
            DUE_DATE_DEPARTMENT,
			PHYSICAL_DATE,
			PHYSICAL_DATE_LOCATION,
            PHYSICAL_DATE_DEPARTMENT,
			PRODUCT_ID,
			'' DEPARTMENT,
			ISNULL(PURCHASE_NET_ALL,0) PURCHASE_NET_ALL,
			ISNULL(PURCHASE_NET_SYSTEM_ALL,0) PURCHASE_NET_SYSTEM_ALL,
			ISNULL(PURCHASE_NET_SYSTEM_2_ALL,0) PURCHASE_NET_SYSTEM_2_ALL,
			ISNULL(PURCHASE_NET_LOCATION_ALL,0) PURCHASE_NET_LOCATION_ALL,
			ISNULL(PURCHASE_NET_SYSTEM_LOCATION_ALL,0) PURCHASE_NET_SYSTEM_LOCATION_ALL,
			ISNULL(PURCHASE_NET_SYSTEM_2_LOCATION_ALL,0) PURCHASE_NET_SYSTEM_2_LOCATION_ALL,
			ISNULL(PURCHASE_NET_DEPARTMENT_ALL,0) PURCHASE_NET_DEPARTMENT_ALL,
			ISNULL(PURCHASE_NET_SYSTEM_DEPARTMENT_ALL,0) PURCHASE_NET_SYSTEM_DEPARTMENT_ALL,
			ISNULL(PURCHASE_NET_SYSTEM_2_DEPARTMENT_ALL,0) PURCHASE_NET_SYSTEM_2_DEPARTMENT_ALL,
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
	        ISNULL(LABOR_COST_SYSTEM_2_DEPARTMENT,0) LABOR_COST_SYSTEM_2_DEPARTMENT,
			PRODUCT_COST.INVENTORY_CALC_TYPE
		FROM 
			PRODUCT_COST 
		WHERE 
			PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pid#">
			<cfif isdefined('attributes.location')>
				AND DEPARTMENT_ID IS NULL
			</cfif>
			<cfif isdefined("attributes.department_id") and len(attributes.department_id)>
				AND DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(attributes.department_id,1,'-')#">
				<cfif listlen(attributes.department_id,'-') eq 2>
					AND LOCATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(attributes.department_id,2,'-')#">
				</cfif>
			</cfif>
            <cfif isdefined('attributes.start_date') and len(attributes.start_date)>
			AND PRODUCT_COST.START_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#"><!---#attributes.start_date#--->
			</cfif>
			<cfif isdefined('attributes.finish_date') and len(attributes.finish_date)>
			AND PRODUCT_COST.START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date#"><!---#attributes.finish_date#--->
			</cfif>
		<cfif isdefined('attributes.location')>
		UNION
			SELECT 
				(SELECT S.STOCK_CODE FROM STOCKS S WHERE S.STOCK_ID = PRODUCT_COST.STOCK_ID) STOCK_CODE,
                ACTION_PERIOD_ID,
                ACTION_TYPE,
                ACTION_PROCESS_TYPE,
                ACTION_ID,
                ACTION_ROW_ID,
                PRODUCT_COST_ID,
                ISNULL(STANDARD_COST_LOCATION,0) STANDARD_COST_LOCATION,
                ISNULL(STANDARD_COST_MONEY_LOCATION,0) STANDARD_COST_MONEY_LOCATION,
                ISNULL(STANDARD_COST_DEPARTMENT,0) STANDARD_COST_DEPARTMENT,
                ISNULL(STANDARD_COST_MONEY_DEPARTMENT,0) STANDARD_COST_MONEY_DEPARTMENT,
                ISNULL(STANDARD_COST,0) STANDARD_COST,
                ISNULL(STANDARD_COST_MONEY,0) STANDARD_COST_MONEY,
                ISNULL(STANDARD_COST_RATE,0) STANDARD_COST_RATE,
                ISNULL(STANDARD_COST_RATE_LOCATION,0) STANDARD_COST_RATE_LOCATION,
                ISNULL(STANDARD_COST_RATE_DEPARTMENT,0) STANDARD_COST_RATE_DEPARTMENT,
                ISNULL(PRICE_PROTECTION,0) PRICE_PROTECTION,
                ISNULL(PRICE_PROTECTION_LOCATION,0) PRICE_PROTECTION_LOCATION,
                ISNULL(PRICE_PROTECTION_DEPARTMENT,0) PRICE_PROTECTION_DEPARTMENT,
                ISNULL(PRICE_PROTECTION_MONEY,0) PRICE_PROTECTION_MONEY,
                ISNULL(PRICE_PROTECTION_MONEY_LOCATION,0) PRICE_PROTECTION_MONEY_LOCATION,
                ISNULL(PRICE_PROTECTION_MONEY_DEPARTMENT,0) PRICE_PROTECTION_MONEY_DEPARTMENT,
                ISNULL(SPECT_MAIN_ID,0) SPECT_MAIN_ID,
                START_DATE,
                MONTH(START_DATE) MONTH_START_DATE,
                ISNULL(PURCHASE_NET,0) PURCHASE_NET,
                ISNULL(PURCHASE_NET_LOCATION,0) PURCHASE_NET_LOCATION,
                ISNULL(PURCHASE_NET_DEPARTMENT,0) PURCHASE_NET_DEPARTMENT,
                ISNULL(PURCHASE_NET_MONEY,0) PURCHASE_NET_MONEY,
                ISNULL(PURCHASE_NET_MONEY_LOCATION,0) PURCHASE_NET_MONEY_LOCATION,
                ISNULL(PURCHASE_NET_MONEY_DEPARTMENT,0) PURCHASE_NET_MONEY_DEPARTMENT,
                ISNULL(PURCHASE_EXTRA_COST,0) PURCHASE_EXTRA_COST,
                ISNULL(PURCHASE_EXTRA_COST_LOCATION,0) PURCHASE_EXTRA_COST_LOCATION,
                ISNULL(PURCHASE_EXTRA_COST_DEPARTMENT,0) PURCHASE_EXTRA_COST_DEPARTMENT,
                ISNULL(PRODUCT_COST,0) PRODUCT_COST,
                ISNULL(PRODUCT_COST_LOCATION,0) PRODUCT_COST_LOCATION,
                ISNULL(PRODUCT_COST_LOCATION,0) PRODUCT_COST_DEPARTMENT,
                MONEY,
                MONEY_LOCATION,
                MONEY_DEPARTMENT,
                ISNULL(PURCHASE_NET_SYSTEM,0) AS PURCHASE_NET_SYSTEM,
                ISNULL(PURCHASE_NET_SYSTEM_LOCATION,0) PURCHASE_NET_SYSTEM_LOCATION,
                ISNULL(PURCHASE_NET_SYSTEM_DEPARTMENT,0) PURCHASE_NET_SYSTEM_DEPARTMENT,
                ISNULL(PURCHASE_NET_SYSTEM_MONEY,0) PURCHASE_NET_SYSTEM_MONEY,
                ISNULL(PURCHASE_NET_SYSTEM_MONEY_LOCATION,0) PURCHASE_NET_SYSTEM_MONEY_LOCATION,
                ISNULL(PURCHASE_NET_SYSTEM_MONEY_DEPARTMENT,0) PURCHASE_NET_SYSTEM_MONEY_DEPARTMENT,
                ISNULL(PURCHASE_EXTRA_COST_SYSTEM,0) PURCHASE_EXTRA_COST_SYSTEM,
                ISNULL(PURCHASE_EXTRA_COST_SYSTEM_LOCATION,0) PURCHASE_EXTRA_COST_SYSTEM_LOCATION,
                ISNULL(PURCHASE_EXTRA_COST_SYSTEM_DEPARTMENT,0) PURCHASE_EXTRA_COST_SYSTEM_DEPARTMENT,
                ISNULL(PURCHASE_NET_SYSTEM_2,0) PURCHASE_NET_SYSTEM_2,
                ISNULL(PURCHASE_NET_SYSTEM_2_LOCATION,0) PURCHASE_NET_SYSTEM_2_LOCATION,
                ISNULL(PURCHASE_NET_SYSTEM_2_DEPARTMENT,0) PURCHASE_NET_SYSTEM_2_DEPARTMENT,
                ISNULL(PURCHASE_EXTRA_COST_SYSTEM_2,0) PURCHASE_EXTRA_COST_SYSTEM_2,
                ISNULL(PURCHASE_EXTRA_COST_SYSTEM_2_LOCATION,0) PURCHASE_EXTRA_COST_SYSTEM_2_LOCATION,
                ISNULL(PURCHASE_EXTRA_COST_SYSTEM_2_DEPARTMENT,0) PURCHASE_EXTRA_COST_SYSTEM_2_DEPARTMENT,
                AVAILABLE_STOCK,
                AVAILABLE_STOCK_LOCATION,
                AVAILABLE_STOCK_DEPARTMENT,
                PARTNER_STOCK,
                PARTNER_STOCK_LOCATION,
                PARTNER_STOCK_DEPARTMENT,
                ACTIVE_STOCK,
                ACTIVE_STOCK_LOCATION,
                ACTIVE_STOCK_DEPARTMENT,
                DUE_DATE,
                DUE_DATE_LOCATION,
                DUE_DATE_DEPARTMENT,
                PHYSICAL_DATE,
                PHYSICAL_DATE_LOCATION,
                PHYSICAL_DATE_DEPARTMENT,
                PRODUCT_ID,
                DEPARTMENT_HEAD DEPARTMENT,
                ISNULL(PURCHASE_NET_ALL,0) PURCHASE_NET_ALL,
                ISNULL(PURCHASE_NET_SYSTEM_ALL,0) PURCHASE_NET_SYSTEM_ALL,
                ISNULL(PURCHASE_NET_SYSTEM_2_ALL,0) PURCHASE_NET_SYSTEM_2_ALL,
                ISNULL(PURCHASE_NET_LOCATION_ALL,0) PURCHASE_NET_LOCATION_ALL,
                ISNULL(PURCHASE_NET_SYSTEM_LOCATION_ALL,0) PURCHASE_NET_SYSTEM_LOCATION_ALL,
                ISNULL(PURCHASE_NET_SYSTEM_2_LOCATION_ALL,0) PURCHASE_NET_SYSTEM_2_LOCATION_ALL,
                ISNULL(PURCHASE_NET_DEPARTMENT_ALL,0) PURCHASE_NET_DEPARTMENT_ALL,
                ISNULL(PURCHASE_NET_SYSTEM_DEPARTMENT_ALL,0) PURCHASE_NET_SYSTEM_DEPARTMENT_ALL,
				ISNULL(PURCHASE_NET_SYSTEM_2_DEPARTMENT_ALL,0) PURCHASE_NET_SYSTEM_2_DEPARTMENT_ALL,
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
                PRODUCT_COST.INVENTORY_CALC_TYPE
			FROM 
				PRODUCT_COST PC,
				#DSN_ALIAS#.STOCKS_LOCATION SL,
				#DSN_ALIAS#.DEPARTMENT D
			WHERE 
				PC.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pid#">
				AND PC.ACTION_PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">
				AND SL.LOCATION_ID = PC.LOCATION_ID
				AND SL.DEPARTMENT_ID = PC.DEPARTMENT_ID
				AND D.DEPARTMENT_ID = SL.DEPARTMENT_ID
		</cfif>
		ORDER BY 
			START_DATE DESC,
			PRODUCT_COST_ID DESC,
            RECORD_DATE DESC
	</cfquery>
<cfelse>
	<cfquery name="GET_PRODUCT_COST" datasource="#DSN3#">
		SELECT 
			(SELECT S.STOCK_CODE FROM STOCKS S WHERE S.STOCK_ID = PC.STOCK_ID) STOCK_CODE,
			ACTION_PERIOD_ID,
			ACTION_TYPE,
			ACTION_PROCESS_TYPE,
			ACTION_ID,
			ACTION_ROW_ID,
			PRODUCT_COST_ID,
			ISNULL(STANDARD_COST_LOCATION,0) STANDARD_COST_LOCATION,
			ISNULL(STANDARD_COST_MONEY_LOCATION,0) STANDARD_COST_MONEY_LOCATION,
            ISNULL(STANDARD_COST_DEPARTMENT,0) STANDARD_COST_DEPARTMENT,
			ISNULL(STANDARD_COST_MONEY_DEPARTMENT,0) STANDARD_COST_MONEY_DEPARTMENT,
			ISNULL(STANDARD_COST,0) STANDARD_COST,
			ISNULL(STANDARD_COST_MONEY,0) STANDARD_COST_MONEY,
			ISNULL(STANDARD_COST_RATE,0) STANDARD_COST_RATE,
			ISNULL(STANDARD_COST_RATE_LOCATION,0) STANDARD_COST_RATE_LOCATION,
            ISNULL(STANDARD_COST_RATE_DEPARTMENT,0) STANDARD_COST_RATE_DEPARTMENT,
			ISNULL(PRICE_PROTECTION,0) PRICE_PROTECTION,
			ISNULL(PRICE_PROTECTION_LOCATION,0) PRICE_PROTECTION_LOCATION,
            ISNULL(PRICE_PROTECTION_DEPARTMENT,0) PRICE_PROTECTION_DEPARTMENT,
			ISNULL(PRICE_PROTECTION_MONEY,0) PRICE_PROTECTION_MONEY,
			ISNULL(PRICE_PROTECTION_MONEY_LOCATION,0) PRICE_PROTECTION_MONEY_LOCATION,
            ISNULL(PRICE_PROTECTION_MONEY_DEPARTMENT,0) PRICE_PROTECTION_MONEY_DEPARTMENT,
			ISNULL(SPECT_MAIN_ID,0) SPECT_MAIN_ID,
			START_DATE,
			MONTH(START_DATE) MONTH_START_DATE,
			ISNULL(PURCHASE_NET,0) PURCHASE_NET,
			ISNULL(PURCHASE_NET_LOCATION,0) PURCHASE_NET_LOCATION,
            ISNULL(PURCHASE_NET_DEPARTMENT,0) PURCHASE_NET_DEPARTMENT,
			ISNULL(PURCHASE_NET_MONEY,0) PURCHASE_NET_MONEY,
			ISNULL(PURCHASE_NET_MONEY_LOCATION,0) PURCHASE_NET_MONEY_LOCATION,
            ISNULL(PURCHASE_NET_MONEY_DEPARTMENT,0) PURCHASE_NET_MONEY_DEPARTMENT,
			ISNULL(PURCHASE_EXTRA_COST,0) PURCHASE_EXTRA_COST,
			ISNULL(PURCHASE_EXTRA_COST_LOCATION,0) PURCHASE_EXTRA_COST_LOCATION,
            ISNULL(PURCHASE_EXTRA_COST_DEPARTMENT,0) PURCHASE_EXTRA_COST_DEPARTMENT,
			ISNULL(PRODUCT_COST,0) PRODUCT_COST,
			ISNULL(PRODUCT_COST_LOCATION,0) PRODUCT_COST_LOCATION,
            ISNULL(PRODUCT_COST_LOCATION,0) PRODUCT_COST_DEPARTMENT,
			MONEY,
			MONEY_LOCATION,
            MONEY_DEPARTMENT,
			ISNULL(PURCHASE_NET_SYSTEM,0) AS PURCHASE_NET_SYSTEM,
			ISNULL(PURCHASE_NET_SYSTEM_LOCATION,0) PURCHASE_NET_SYSTEM_LOCATION,
            ISNULL(PURCHASE_NET_SYSTEM_DEPARTMENT,0) PURCHASE_NET_SYSTEM_DEPARTMENT,
			ISNULL(PURCHASE_NET_SYSTEM_MONEY,0) PURCHASE_NET_SYSTEM_MONEY,
			ISNULL(PURCHASE_NET_SYSTEM_MONEY_LOCATION,0) PURCHASE_NET_SYSTEM_MONEY_LOCATION,
            ISNULL(PURCHASE_NET_SYSTEM_MONEY_DEPARTMENT,0) PURCHASE_NET_SYSTEM_MONEY_DEPARTMENT,
			ISNULL(PURCHASE_EXTRA_COST_SYSTEM,0) PURCHASE_EXTRA_COST_SYSTEM,
			ISNULL(PURCHASE_EXTRA_COST_SYSTEM_LOCATION,0) PURCHASE_EXTRA_COST_SYSTEM_LOCATION,
            ISNULL(PURCHASE_EXTRA_COST_SYSTEM_DEPARTMENT,0) PURCHASE_EXTRA_COST_SYSTEM_DEPARTMENT,
			ISNULL(PURCHASE_NET_SYSTEM_2,0) PURCHASE_NET_SYSTEM_2,
			ISNULL(PURCHASE_NET_SYSTEM_2_LOCATION,0) PURCHASE_NET_SYSTEM_2_LOCATION,
            ISNULL(PURCHASE_NET_SYSTEM_2_DEPARTMENT,0) PURCHASE_NET_SYSTEM_2_DEPARTMENT,
			ISNULL(PURCHASE_EXTRA_COST_SYSTEM_2,0) PURCHASE_EXTRA_COST_SYSTEM_2,
			ISNULL(PURCHASE_EXTRA_COST_SYSTEM_2_LOCATION,0) PURCHASE_EXTRA_COST_SYSTEM_2_LOCATION,
            ISNULL(PURCHASE_EXTRA_COST_SYSTEM_2_DEPARTMENT,0) PURCHASE_EXTRA_COST_SYSTEM_2_DEPARTMENT,
			AVAILABLE_STOCK,
			AVAILABLE_STOCK_LOCATION,
            AVAILABLE_STOCK_DEPARTMENT,
			PARTNER_STOCK,
			PARTNER_STOCK_LOCATION,
            PARTNER_STOCK_DEPARTMENT,
			ACTIVE_STOCK,
			ACTIVE_STOCK_LOCATION,
            ACTIVE_STOCK_DEPARTMENT,
			DUE_DATE,
			DUE_DATE_LOCATION,
            DUE_DATE_DEPARTMENT,
			PHYSICAL_DATE,
			PHYSICAL_DATE_LOCATION,
            PHYSICAL_DATE_DEPARTMENT,
			PRODUCT_ID,
			DEPARTMENT_HEAD DEPARTMENT,
			ISNULL(PURCHASE_NET_ALL,0) PURCHASE_NET_ALL,
			ISNULL(PURCHASE_NET_SYSTEM_ALL,0) PURCHASE_NET_SYSTEM_ALL,
			ISNULL(PURCHASE_NET_SYSTEM_2_ALL,0) PURCHASE_NET_SYSTEM_2_ALL,
			ISNULL(PURCHASE_NET_LOCATION_ALL,0) PURCHASE_NET_LOCATION_ALL,
			ISNULL(PURCHASE_NET_SYSTEM_LOCATION_ALL,0) PURCHASE_NET_SYSTEM_LOCATION_ALL,
			ISNULL(PURCHASE_NET_SYSTEM_2_LOCATION_ALL,0) PURCHASE_NET_SYSTEM_2_LOCATION_ALL,
            ISNULL(PURCHASE_NET_DEPARTMENT_ALL,0) PURCHASE_NET_DEPARTMENT_ALL,
			ISNULL(PURCHASE_NET_SYSTEM_DEPARTMENT_ALL,0) PURCHASE_NET_SYSTEM_DEPARTMENT_ALL,
			ISNULL(PURCHASE_NET_SYSTEM_2_DEPARTMENT_ALL,0) PURCHASE_NET_SYSTEM_2_DEPARTMENT_ALL,
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
			ISNULL(LABOR_COST_SYSTEM_2_DEPARTMENT,0) LABOR_COST_SYSTEM_2_DEPARTMENT,
			PC.INVENTORY_CALC_TYPE
		FROM 
			PRODUCT_COST PC,
			#DSN_ALIAS#.STOCKS_LOCATION SL,
			#DSN_ALIAS#.DEPARTMENT D
		WHERE 
			PC.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pid#">
			AND SL.LOCATION_ID = PC.LOCATION_ID
			AND SL.DEPARTMENT_ID = PC.DEPARTMENT_ID
			AND D.DEPARTMENT_ID = SL.DEPARTMENT_ID
			<cfif isdefined('attributes.location')>
			AND PC.DEPARTMENT_ID IN (SELECT DEPARTMENT_ID FROM #dsn_alias#.DEPARTMENT WHERE BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ListGetAt(session.ep.user_location,2,'-')#">)
			</cfif>
		ORDER BY 
			START_DATE DESC,
			PRODUCT_COST_ID DESC,
            PC.RECORD_DATE DESC
	</cfquery>
</cfif>
<cfquery name="get_product" datasource="#dsn3#"><!--- Burada ürün ismi ve calc_type getiriliyor --->
	SELECT 
		PRODUCT_NAME,
		IS_PRODUCTION,
		PRODUCT_CODE
	FROM 
		PRODUCT 
	WHERE 
		PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pid#">
</cfquery>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default="#get_product_cost.recordcount#">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfsavecontent variable="message"><cf_get_lang dictionary_id='37292.Maliyet Tarihçesi'></cfsavecontent>
<cf_box title="#message#:#get_product.product_code# - #get_product.product_name#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
<cfform name="stock_search2" method="post" action="#request.self#?fuseaction=#attributes.fuseaction#">
    <input type="hidden" name="is_submit" id="is_submit" value="1"><!--- Sayfalama İçin Gerekli --->
    <input type="hidden" name="pid" id="pid" value="<cfoutput>#attributes.pid#</cfoutput>">
	<input type="hidden" name="round_number" id="round_number" value="<cfoutput>#round_number#</cfoutput>">
		<cf_box_search more="0">
						<div class="form-group" id="item-department">
						<select name="department_id" id="department_id" style="width:140px">
							<option value=""><cf_get_lang dictionary_id='37094.Tüm Depolar'></option>
							<cfoutput query="stores">
								<option value="#department_id#"<cfif attributes.department_id eq department_id>selected</cfif>>#department_head#</option>
								<cfquery name="GET_LOCATION" dbtype="query">
									SELECT * FROM GET_ALL_LOCATION WHERE DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#stores.department_id[currentrow]#">
								</cfquery>		 
								<cfif get_location.recordcount>
									<cfloop from="1" to="#get_location.recordcount#" index="s">
										<option <cfif not get_location.status[s]>style="color:##FF0000"</cfif> value="#department_id#-#get_location.location_id[s]#" <cfif attributes.department_id eq '#department_id#-#get_location.location_id[s]#'>selected</cfif>>&nbsp;&nbsp;&nbsp;#get_location.comment[s]#<cfif not get_location.status[s]> - <cf_get_lang dictionary_id='57494.Pasif'></cfif></option>
									</cfloop>
							</cfif>	
							</cfoutput>
						</select>
					</div>
						<div class="form-group" id="item-graph_type">
						<select name="graph_type" id="graph_type" style="width:90px;">
							<option value=""><cf_get_lang dictionary_id='58696.Grafik Göster'></option>
							<option value="0" <cfif Len(attributes.graph_type) and attributes.graph_type eq 0>selected</cfif>><cf_get_lang dictionary_id='58932.Ay Bazında'></option>
							<option value="1" <cfif Len(attributes.graph_type) and attributes.graph_type eq 1>selected</cfif>><cf_get_lang dictionary_id='58457.Gün Bazında'></option>
						</select>
					</div>
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='57782.Tarih Değerini Kontrol Ediniz'></cfsavecontent>
                        <div class="form-group" id="item-start_date">
							<div class="input-group">
							<cfinput type="text" placeholder="#getlang('','Başlangıç','57501')#" name="start_date" value="#dateformat(attributes.start_date,dateformat_style)#" validate="#validate_style#" maxlength="10" message="#message#" style="width:65px;">
							<span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>
							</div>
						</div>
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='57782.Tarih Değerini Kontrol Ediniz'></cfsavecontent>
							<div class="form-group" id="item-finish_date">
							<div class="input-group">
							<cfinput type="text" placeholder="#getlang('','Bitiş','57502')#" name="finish_date" value="#dateformat(attributes.finish_date,dateformat_style)#" validate="#validate_style#" maxlength="10" message="#message#" style="width:65px;">
							<span class="input-group-addon"><cf_wrk_date_image date_field="finish_date"></span>
						</div>
					</div>
                    	<div class="form-group" id="item-graph_type"><cf_wrk_search_button button_type="4" search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('stock_search2' , #attributes.modal_id#)"),DE(""))#">	</div>
		</cf_box_search>
</cfform>
<cf_grid_list>
	<thead>
		<tr>
			<th width="15"></th>
			<th width="15"></th>
			<cfset colspan_info = 2>
			<!--- Satirlardaki Veriler Degisken Olarak Geliyor --->
			<cfloop list="#ListDeleteDuplicates(xml_stock_based_cost_rows)#" index="xlr">
				<cfswitch expression="#xlr#">
					<cfcase value="1">
						<cfset colspan_info = colspan_info + 1>
						<th class="txtboldblue" style="text-align:left"><cf_get_lang dictionary_id='57487.No'></th>
					</cfcase>
					<cfcase value="2">
						<cfset colspan_info = colspan_info + 1>
						<th class="txtboldblue" style="text-align:left"><cf_get_lang dictionary_id='57742.Tarih'></th>
					</cfcase>
					<cfcase value="3">
						<cfset colspan_info = colspan_info + 1>
						<th class="txtboldblue" style="text-align:left"><cf_get_lang dictionary_id='37510.Envanter Yöntemi'></th>
					</cfcase>
					<cfcase value="4">
						<cfif session.ep.isBranchAuthorization>
							<cfset colspan_info = colspan_info + 1>
							<th class="txtboldblue" align="center"><cf_get_lang dictionary_id='57572.Departman'></th>
						</cfif>
					</cfcase>
					<cfcase value="5">
						<cfset colspan_info = colspan_info + 1>
						<th class="txtboldblue"><cf_get_lang dictionary_id='37358.Net Maliyet'></th>
					</cfcase>
					<cfcase value="6">
						<cfset colspan_info = colspan_info + 1>
						<th class="txtboldblue"><cf_get_lang dictionary_id='37183.Ek Maliyet'></th>
					</cfcase>
					<cfcase value="7">
						<cfset colspan_info = colspan_info + 1>
						<th class="txtboldblue"><cf_get_lang dictionary_id='37358.Net Maliyet'> (<cfoutput>#session.ep.money2#</cfoutput>)</th>
					</cfcase>
					<cfcase value="8">
						<cfset colspan_info = colspan_info + 1>
						<th class="txtboldblue"><cf_get_lang dictionary_id='37183.Ek Maliyet'> (<cfoutput>#session.ep.money2#</cfoutput>)</th>
					</cfcase>
					<cfcase value="9">
						<cfset colspan_info = colspan_info + 1>
						<th class="txtboldblue"><cf_get_lang dictionary_id='37358.Net Maliyet'> (<cfoutput>#session.ep.money#</cfoutput>)</th>
					</cfcase>
					<cfcase value="10">
						<cfset colspan_info = colspan_info + 1>
						<th class="txtboldblue"><cf_get_lang dictionary_id='37183.Ek Maliyet'> (<cfoutput>#session.ep.money#</cfoutput>)</th>
					</cfcase>
					<cfcase value="11">
						<cfset colspan_info = colspan_info + 1>
						<th class="txtboldblue"><cf_get_lang dictionary_id='37524.Std Maliyet'></th>
					</cfcase>
					<cfcase value="12">
						<cfset colspan_info = colspan_info + 1>
						<th class="txtboldblue"><cf_get_lang dictionary_id='37524.Std Maliyet'> %</th>
					</cfcase>
					<cfcase value="13">
						<cfset colspan_info = colspan_info + 1>
						<th class="txtboldblue"><cf_get_lang dictionary_id='37518.Fiyat Koruma'></th>
					</cfcase>
					<cfcase value="14">
						<th class="txtboldblue"><cf_get_lang dictionary_id='37497.Maliyet'></th>
						<cfset colspan_info = colspan_info + 1>
					</cfcase>
					<cfcase value="15">
						<cfset colspan_info = colspan_info + 1>
						<th class="txtboldblue"><cf_get_lang dictionary_id='37497.Maliyet'> (<cfoutput>#session.ep.money2#</cfoutput>)</th>
					</cfcase>
					<cfcase value="16">
						<cfset colspan_info = colspan_info + 1>
						<th class="txtboldblue"><cf_get_lang dictionary_id='37497.Maliyet'> (<cfoutput>#session.ep.money#</cfoutput>)</th>
					</cfcase>
					<cfcase value="17">
						<cfset colspan_info = colspan_info + 1>
						<th class="txtboldblue"><cf_get_lang dictionary_id='37512.Mevcut Stok'></th>
					</cfcase>
					<cfcase value="18">
						<cfset colspan_info = colspan_info + 1>
						<th class="txtboldblue"><cf_get_lang dictionary_id='37514.İş Ortakları Stoğu'></th>
					</cfcase>
					<cfcase value="19">
						<cfset colspan_info = colspan_info + 1>
						<th class="txtboldblue"><cf_get_lang dictionary_id='58047.Yoldaki Stok'></th>
					</cfcase>
					<cfcase value="20">
						<cfif session.ep.our_company_info.is_stock_based_cost eq 1>
							<cfset colspan_info = colspan_info + 1>
							<th class="txtboldblue" style="text-align:center"><cf_get_lang dictionary_id='57518.Stok Kodu'></th>
						</cfif>
					</cfcase>
					<cfcase value="21">
						<cfset colspan_info = colspan_info + 1>
						<th class="txtboldblue" style="text-align:left;"><cf_get_lang dictionary_id='54850.Spec ID'></th>
					</cfcase>
					<cfcase value="22">
						<cfset colspan_info = colspan_info + 1>
						<th class="txtboldblue" style="text-align:center"><cf_get_lang dictionary_id='37615.Finansal Yaş'></th>
					</cfcase>
					<cfcase value="23">
						<cfset colspan_info = colspan_info + 1>
						<th class="txtboldblue" style="text-align:center"><cf_get_lang dictionary_id='37616.Fiziksel Yaş'></th>
					</cfcase>
					<cfcase value="24">
						<cfset colspan_info = colspan_info + 1>
							<th class="txtboldblue" style="text-align:center"><cf_get_lang dictionary_id="47561.Yansıyan Maliyet"></th>
						</cfcase>
					<cfcase value="25">
						<cfset colspan_info = colspan_info + 1>
						<th class="txtboldblue" style="text-align:center"><cf_get_lang dictionary_id="47560.İşçilik Maliyet"></th>
					</cfcase>
					<cfcase value="26">
						<cfset colspan_info = colspan_info + 1>
						<th class="txtboldblue" style="text-align:center"><cf_get_lang dictionary_id="47561.Yansıyan Maliyet">(<cfoutput>#session.ep.money2#</cfoutput>)</th>
					</cfcase>
					<cfcase value="27">
						<cfset colspan_info = colspan_info + 1>
						<th class="txtboldblue" style="text-align:center"><cf_get_lang dictionary_id="47560.İşçilik Maliyet">(<cfoutput>#session.ep.money2#</cfoutput>)</th>
					</cfcase>
					<cfcase value="28">
						<cfset colspan_info = colspan_info + 1>
						<th class="txtboldblue" style="text-align:center"><cf_get_lang dictionary_id="47561.Yansıyan Maliyet">(<cfoutput>#session.ep.money#</cfoutput>)</th>
					</cfcase>
					<cfcase value="29">
						<cfset colspan_info = colspan_info + 1>
						<th class="txtboldblue" style="text-align:center"><cf_get_lang dictionary_id="47560.İşçilik Maliyet">(<cfoutput>#session.ep.money#</cfoutput>)</th>
					</cfcase>
				</cfswitch>
			</cfloop>
		</tr>
	</thead>
	<tbody>
		<cfif get_product_cost.recordcount>
			<cfoutput query="get_product_cost" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
				<cfsavecontent variable="cost_title">
					<cf_get_lang dictionary_id ='37725.Bu maliyet'>,<cfif get_product_cost.action_type eq 1><cf_get_lang dictionary_id ='37726.Faturadan'><cfelseif get_product_cost.action_type eq 2><cf_get_lang dictionary_id ='37727.İrsaliyeden'><cfelseif get_product_cost.action_type eq 3><cf_get_lang dictionary_id ='37728.Stok Fişinden'><cfelseif get_product_cost.action_type eq 4><cf_get_lang dictionary_id ='37729.Üretimden'><cfelseif get_product_cost.action_type eq 7><cf_get_lang dictionary_id ='37730.Stok Virmandan'><cfelseif get_product_cost.action_type eq -1>Excel Aktarımdan<cfelseif get_product_cost.action_type eq 8>Fiyat Farkı Ekranından<cfelse><cf_get_lang dictionary_id ='37731.Elle'></cfif><cf_get_lang dictionary_id ='37732.oluşturulmuştur'>.
				</cfsavecontent>
				<tr>
					<td width="15">
					<cfif get_product_cost.action_type eq 4>
						<cfquery name="get_prod_order_result" datasource="#DSN3#">
							SELECT P_ORDER_ID FROM PRODUCTION_ORDER_RESULTS WHERE PR_ORDER_ID = #action_id#
						</cfquery>
						<cfset p_orderid = get_prod_order_result.P_ORDER_ID>
					</cfif>
					<cfset open_action_type = "">
					<cfif get_product_cost.action_type eq 1 and action_process_type neq 62>
						<cfset open_action_type = "1,#action_id#">
					<cfelseif get_product_cost.action_type eq 1 and action_process_type eq 62>
						<cfset open_action_type = "5,#action_id#">
					<cfelseif get_product_cost.action_type eq 2 and not listfind('81,811',action_process_type)>
						<cfset open_action_type = "2,#action_id#">
                    <cfelseif get_product_cost.action_type eq 2 and action_process_type eq 81>
						<cfset open_action_type = "9,#action_id#">
					<cfelseif get_product_cost.action_type eq 2 and action_process_type eq 811>
						<cfset open_action_type = "6,#action_id#">
					<cfelseif get_product_cost.action_type eq 3>
                    	<cfif get_product_cost.action_procesS_type eq 114>
						<cfset open_action_type = "11,#action_id#"> 
                        <CFELSE>   
						<cfset open_action_type = "3,#action_id#">
                        </cfif>
					<cfelseif get_product_cost.action_type eq 8>
						<cfset open_action_type = "8,#action_id#">
					<cfelseif get_product_cost.action_type eq 4>
						<cfset open_action_type = "4,#action_id#,#p_orderid#">
                    <cfelseif get_product_cost.action_type eq 7>
						<cfset open_action_type = "7,#action_id#">
                    
                    <cfelseif get_product_cost.action_procesS_type eq 118>
						<cfset open_action_type = "12,#action_id#">
                    <cfelseif get_product_cost.action_procesS_type eq 1182>
						<cfset open_action_type = "13,#action_id#">    
					</cfif>
					<a href="javascript://" onclick="open_action(#open_action_type#);" title="#cost_title#"><i class="icon-file-text"></i></a></td>
					<td width="15" align="center"><a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.popup_form_upd_product_cost&pcid=#PRODUCT_COST_ID#')"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" border="0"></i></a></td>
					<!--- Satirlardaki Veriler Degisken Olarak Geliyor --->
					<cfloop list="#ListDeleteDuplicates(xml_stock_based_cost_rows)#" index="xlr">
						<cfswitch expression="#xlr#">
							<cfcase value="1"><!--- No --->
								<td>#ACTION_ID#-#ACTION_ROW_ID#-#PRODUCT_COST_ID#</td>
							</cfcase>
							<cfcase value="2"><!--- Tarih --->
								<td>#dateformat(START_DATE,dateformat_style)#</td>
							</cfcase>
							<cfcase value="3"><!--- Envanter Yöntemi --->
								<td>
									<cfif get_product_cost.inventory_calc_type eq 1><cf_get_lang dictionary_id='37080.İlk Giren İlk Çıkar'></cfif>
									<cfif get_product_cost.inventory_calc_type eq 2><cf_get_lang dictionary_id='37081.Son Giren İlk Çıkar'></cfif>
									<cfif get_product_cost.inventory_calc_type eq 3><cf_get_lang dictionary_id='37082.Ağırlıklı Ortalama'></cfif>
									<cfif get_product_cost.inventory_calc_type eq 4><cf_get_lang dictionary_id='37083.Son Alış Fiyatı'></cfif>
									<cfif get_product_cost.inventory_calc_type eq 5><cf_get_lang dictionary_id='37084.İlk Alış Fiyatı'></cfif>
									<cfif get_product_cost.inventory_calc_type eq 6><cf_get_lang dictionary_id='58722.Standart Alış'></cfif>
									<cfif get_product_cost.inventory_calc_type eq 7><cf_get_lang dictionary_id='58721.Standart Satış'></cfif>
									<cfif get_product_cost.inventory_calc_type eq 8><cf_get_lang dictionary_id='37085.Üretim Maliyeti'></cfif>
								</td>
							</cfcase>
							<cfcase value="4"><!--- Departman --->
								<cfif session.ep.isBranchAuthorization><td>#DEPARTMENT#</td></cfif>
							</cfcase>
							<cfcase value="5"><!--- Net Maliyet --->
								<td style="text-align:right;">
								<cfif isdefined('attributes.location') or session.ep.isBranchAuthorization or (isdefined("attributes.department_id") and len(attributes.department_id)  AND listlen(attributes.department_id,'-') eq 2)>
                                	#tlformat(PURCHASE_NET_LOCATION,round_number)# #PURCHASE_NET_MONEY_LOCATION#
								<cfelseif  isdefined('attributes.location') or session.ep.isBranchAuthorization or (isdefined("attributes.department_id") and len(attributes.department_id) AND listlen(attributes.department_id,'-') neq 2)>
                                    #tlformat(PURCHASE_NET_DEPARTMENT,round_number)# #PURCHASE_NET_MONEY_DEPARTMENT#
                                <cfelse>
                                	#tlformat(PURCHASE_NET,round_number)# #PURCHASE_NET_MONEY#
                                </cfif></td>
							</cfcase>
							<cfcase value="6"><!--- Ek Maliyet --->
								<td style="text-align:right;"><a href="javascript://" onclick="open_extra_cost('#attributes.pid#','#action_id#')">
								<cfif isdefined('attributes.location') or session.ep.isBranchAuthorization or (isdefined("attributes.department_id") and len(attributes.department_id) AND listlen(attributes.department_id,'-') eq 2)>
                                    #tlformat(wrk_round(PURCHASE_EXTRA_COST_LOCATION,round_number,1),round_number)# #PURCHASE_NET_MONEY_LOCATION#
								<cfelseif isdefined('attributes.location') or session.ep.isBranchAuthorization or (isdefined("attributes.department_id") and len(attributes.department_id) AND listlen(attributes.department_id,'-') neq 2)>
                                	#tlformat(wrk_round(PURCHASE_EXTRA_COST_DEPARTMENT,round_number,1),round_number)# #PURCHASE_NET_MONEY_DEPARTMENT#
                                <cfelse>
                                	#tlformat(wrk_round(PURCHASE_EXTRA_COST,round_number,1),round_number)# #PURCHASE_NET_MONEY#
                                </cfif></a></td>
							</cfcase>
							<cfcase value="7"><!--- Net Maliyet (<cfoutput>#session.ep.money2#</cfoutput>)--->
								<td style="text-align:right;">
									<cfif isdefined('attributes.location') or session.ep.isBranchAuthorization or (isdefined("attributes.department_id") and len(attributes.department_id) and listlen(attributes.department_id,'-') eq 2)>
										#tlformat(PURCHASE_NET_SYSTEM_2_LOCATION,round_number)# #session.ep.money2#
                                    <cfelseif  isdefined('attributes.location') or session.ep.isBranchAuthorization or (isdefined("attributes.department_id") and len(attributes.department_id) AND listlen(attributes.department_id,'-') neq 2)>
                                    	#tlformat(PURCHASE_NET_SYSTEM_2_DEPARTMENT,round_number)# #session.ep.money2#
									<cfelse>
										#tlformat(PURCHASE_NET_SYSTEM_2,round_number)# #session.ep.money2#
									</cfif>
								</td>
							</cfcase>
							<cfcase value="8"><!--- Ek Maliyet (<cfoutput>#session.ep.money2#</cfoutput>)--->
								<td style="text-align:right;">
									<cfif isdefined('attributes.location') or session.ep.isBranchAuthorization or (isdefined("attributes.department_id") and len(attributes.department_id) AND listlen(attributes.department_id,'-') eq 2)>
										#tlformat(wrk_round(PURCHASE_EXTRA_COST_SYSTEM_2_LOCATION,round_number,1),round_number)# #session.ep.money2#
                                    <cfelseif  isdefined('attributes.location') or session.ep.isBranchAuthorization or (isdefined("attributes.department_id") and len(attributes.department_id) AND listlen(attributes.department_id,'-') neq 2)>
                                    	#tlformat(wrk_round(PURCHASE_EXTRA_COST_SYSTEM_2_DEPARTMENT,round_number,1),round_number)# #session.ep.money2#
                                    <cfelse>
										#tlformat(wrk_round(PURCHASE_EXTRA_COST_SYSTEM_2,round_number,1),round_number)# #session.ep.money2#
									</cfif>
								</td>
							</cfcase>
							<cfcase value="9"><!--- Maliyet --->
								<td style="text-align:right;">
								<cfif isdefined('attributes.location') or session.ep.isBranchAuthorization or (isdefined("attributes.department_id") and len(attributes.department_id) AND listlen(attributes.department_id,'-') eq 2)>
                                	#tlformat(PURCHASE_NET_SYSTEM_LOCATION,round_number)# #PURCHASE_NET_SYSTEM_MONEY_LOCATION#
                                <cfelseif  isdefined('attributes.location') or session.ep.isBranchAuthorization or (isdefined("attributes.department_id") and len(attributes.department_id) AND listlen(attributes.department_id,'-') neq 2)>
                                	#tlformat(PURCHASE_NET_SYSTEM_DEPARTMENT,round_number)# #PURCHASE_NET_SYSTEM_MONEY_DEPARTMENT#
                                <cfelse>
                                	#tlformat(PURCHASE_NET_SYSTEM,round_number)# #PURCHASE_NET_SYSTEM_MONEY#
                                </cfif></td>
							</cfcase>
							<cfcase value="10"><!--- Ek Maliyet (<cfoutput>#session.ep.money#</cfoutput>) --->
								<td style="text-align:right;">
								<cfif isdefined('attributes.location') or session.ep.isBranchAuthorization or (isdefined("attributes.department_id") and len(attributes.department_id) AND listlen(attributes.department_id,'-') eq 2)>
                                	#tlformat(wrk_round(PURCHASE_EXTRA_COST_SYSTEM_LOCATION,round_number,1),round_number)# #PURCHASE_NET_SYSTEM_MONEY_LOCATION#
                                <cfelseif  isdefined('attributes.location') or session.ep.isBranchAuthorization or (isdefined("attributes.department_id") and len(attributes.department_id) AND listlen(attributes.department_id,'-') neq 2)>
                                	#tlformat(wrk_round(PURCHASE_EXTRA_COST_SYSTEM_DEPARTMENT,round_number,1),round_number)# #PURCHASE_NET_SYSTEM_MONEY_DEPARTMENT#
                                <cfelse>
                                	#tlformat(wrk_round(PURCHASE_EXTRA_COST_SYSTEM,round_number,1),round_number)# #PURCHASE_NET_SYSTEM_MONEY#
                                </cfif></td>
							</cfcase>
							<cfcase value="11"><!--- Std Maliyet --->
								<td style="text-align:right;">
								<cfif isdefined('attributes.location') or session.ep.isBranchAuthorization or (isdefined("attributes.department_id") and len(attributes.department_id) AND listlen(attributes.department_id,'-') eq 2)>
                                	#tlformat(STANDARD_COST_LOCATION,round_number)# #STANDARD_COST_MONEY_LOCATION#
                                <cfelseif  isdefined('attributes.location') or session.ep.isBranchAuthorization or (isdefined("attributes.department_id") and len(attributes.department_id) AND listlen(attributes.department_id,'-') neq 2)>
                                	#tlformat(STANDARD_COST_DEPARTMENT,round_number)# #STANDARD_COST_MONEY_DEPARTMENT#
                                <cfelse>
                                	#tlformat(STANDARD_COST,round_number)# #STANDARD_COST_MONEY#
                                </cfif></td>
							</cfcase>
							<cfcase value="12"><!--- Std Maliyet % --->
								<td style="text-align:right;">
								<cfif isdefined('attributes.location') or session.ep.isBranchAuthorization or (isdefined("attributes.department_id") and len(attributes.department_id) AND listlen(attributes.department_id,'-') eq 2)>
                                	% #tlformat(STANDARD_COST_RATE_LOCATION)#
                                <cfelseif  isdefined('attributes.location') or session.ep.isBranchAuthorization or (isdefined("attributes.department_id") and len(attributes.department_id) AND listlen(attributes.department_id,'-') neq 2)>
                                	% #tlformat(STANDARD_COST_RATE_DEPARTMENT)#
                                <cfelse>
                                	% #tlformat(STANDARD_COST_RATE)#
                                </cfif></td>
							</cfcase>
							<cfcase value="13"><!--- Fiyat Koruma --->
								<td style="text-align:right;">
								<cfif isdefined('attributes.location') or session.ep.isBranchAuthorization or (isdefined("attributes.department_id") and len(attributes.department_id) AND listlen(attributes.department_id,'-') eq 2)>
                                	#tlformat(PRICE_PROTECTION_LOCATION,4)# #PRICE_PROTECTION_MONEY_LOCATION#
                                <cfelseif  isdefined('attributes.location') or session.ep.isBranchAuthorization or (isdefined("attributes.department_id") and len(attributes.department_id) AND listlen(attributes.department_id,'-') neq 2)>
                                	#tlformat(PRICE_PROTECTION_DEPARTMENT,4)# #PRICE_PROTECTION_MONEY_DEPARTMENT#
                                <cfelse>
                                	#tlformat(PRICE_PROTECTION,4)# #PRICE_PROTECTION_MONEY#
                                </cfif></td>
							</cfcase>							
							<cfcase value="14"><!--- Maliyet --->
								<td style="text-align:right;">
									<cfif isdefined('attributes.location') or session.ep.isBranchAuthorization or (isdefined("attributes.department_id") and len(attributes.department_id) AND listlen(attributes.department_id,'-') eq 2)>
										#tlformat(PURCHASE_NET_LOCATION_ALL+wrk_round(PURCHASE_EXTRA_COST_LOCATION,round_number,1),round_number)# #MONEY_LOCATION#
                                    <cfelseif  isdefined('attributes.location') or session.ep.isBranchAuthorization or (isdefined("attributes.department_id") and len(attributes.department_id) AND listlen(attributes.department_id,'-') neq 2)>
                                    	#tlformat(PURCHASE_NET_DEPARTMENT_ALL+wrk_round(PURCHASE_EXTRA_COST_DEPARTMENT,round_number,1),round_number)# #MONEY_DEPARTMENT#
									<cfelse>
										#tlformat(PURCHASE_NET_ALL+wrk_round(PURCHASE_EXTRA_COST,round_number,1),round_number)# #PURCHASE_NET_MONEY#
									</cfif>
								</td>
							</cfcase>
							<cfcase value="15"><!--- Toplam Maliyet  (<cfoutput>#session.ep.money2#</cfoutput>)--->
								<td style="text-align:right;">
									<cfif isdefined('attributes.location') or session.ep.isBranchAuthorization or (isdefined("attributes.department_id") and len(attributes.department_id) AND listlen(attributes.department_id,'-') eq 2)>
										#tlformat(PURCHASE_NET_SYSTEM_2_LOCATION_ALL+wrk_round(PURCHASE_EXTRA_COST_SYSTEM_2_LOCATION,round_number,1),round_number)# #session.ep.money2#
                                    <cfelseif  isdefined('attributes.location') or session.ep.isBranchAuthorization or (isdefined("attributes.department_id") and len(attributes.department_id) AND listlen(attributes.department_id,'-') neq 2)>
                                    	#tlformat(PURCHASE_NET_SYSTEM_2_DEPARTMENT_ALL+wrk_round(PURCHASE_EXTRA_COST_SYSTEM_2_DEPARTMENT,round_number,1),round_number)# #session.ep.money2#
									<cfelse>
										#tlformat(PURCHASE_NET_SYSTEM_2_ALL+wrk_round(PURCHASE_EXTRA_COST_SYSTEM_2,round_number,1),round_number)# #session.ep.money2#
									</cfif>
								</td>
							</cfcase>
							<cfcase value="16"><!--- Toplam Maliyet (<cfoutput>#session.ep.money#</cfoutput>) --->
								<td style="text-align:right;">
									<cfif isdefined('attributes.location') or session.ep.isBranchAuthorization or (isdefined("attributes.department_id") and len(attributes.department_id) AND listlen(attributes.department_id,'-') eq 2)>
										#tlformat(PURCHASE_NET_SYSTEM_LOCATION_ALL+wrk_round(PURCHASE_EXTRA_COST_SYSTEM_LOCATION,round_number,1),round_number)# #session.ep.money#
                                    <cfelseif  isdefined('attributes.location') or session.ep.isBranchAuthorization or (isdefined("attributes.department_id") and len(attributes.department_id) AND listlen(attributes.department_id,'-') neq 2)>
                                    	#tlformat(PURCHASE_NET_SYSTEM_DEPARTMENT_ALL+wrk_round(PURCHASE_EXTRA_COST_SYSTEM_DEPARTMENT,round_number,1),round_number)# #session.ep.money#
									<cfelse>
										#tlformat(PURCHASE_NET_SYSTEM_ALL+wrk_round(PURCHASE_EXTRA_COST_SYSTEM,round_number,1),round_number)# #session.ep.money#
									</cfif>
								</td>
							</cfcase>
							<cfcase value="17"><!--- Mevcut Stok --->
								<td style="text-align:right;">
								<cfif isdefined('attributes.location') or session.ep.isBranchAuthorization or (isdefined("attributes.department_id") and len(attributes.department_id) AND listlen(attributes.department_id,'-') eq 2)>
                                	#tlformat(AVAILABLE_STOCK_LOCATION)#
                                <cfelseif  isdefined('attributes.location') or session.ep.isBranchAuthorization or (isdefined("attributes.department_id") and len(attributes.department_id) AND listlen(attributes.department_id,'-') neq 2)>
                                	#tlformat(AVAILABLE_STOCK_DEPARTMENT)#
                                <cfelse>
                                	#tlformat(AVAILABLE_STOCK)#
                                </cfif></td>
							</cfcase>
							<cfcase value="18"><!--- İş Ortakları Stoğu --->
								<td style="text-align:right;">
								<cfif isdefined('attributes.location') or session.ep.isBranchAuthorization or (isdefined("attributes.department_id") and len(attributes.department_id) AND listlen(attributes.department_id,'-') eq 2)>
                                	#tlformat(PARTNER_STOCK_LOCATION)#
                                <cfelseif  isdefined('attributes.location') or session.ep.isBranchAuthorization or (isdefined("attributes.department_id") and len(attributes.department_id) AND listlen(attributes.department_id,'-') neq 2)>
                                	#tlformat(PARTNER_STOCK_DEPARTMENT)#
                                <cfelse>
                                	#tlformat(PARTNER_STOCK)#
                                </cfif></td>
							</cfcase>
							<cfcase value="19"><!--- Yoldaki Stok --->
								<td style="text-align:right;">
								<cfif isdefined('attributes.location') or session.ep.isBranchAuthorization or (isdefined("attributes.department_id") and len(attributes.department_id) AND listlen(attributes.department_id,'-') eq 2)>
                                	#tlformat(ACTIVE_STOCK_LOCATION)#
                                <cfelseif  isdefined('attributes.location') or session.ep.isBranchAuthorization or (isdefined("attributes.department_id") and len(attributes.department_id) AND listlen(attributes.department_id,'-') neq 2)>
                                	#tlformat(ACTIVE_STOCK_DEPARTMENT)#
                                <cfelse>
                                	#tlformat(ACTIVE_STOCK)#
                                </cfif></td>
							</cfcase>
							<cfcase value="20"><!--- Stok Kodu --->
								<cfif session.ep.our_company_info.is_stock_based_cost eq 1>
									<td style="text-align:right;" nowrap>#STOCK_CODE#</td>
								</cfif>
							</cfcase>
							<cfcase value="21"><!--- Spec ID --->
								<td style="text-align:right;"><cfif SPECT_MAIN_ID neq 0>#SPECT_MAIN_ID#</cfif></td>
							</cfcase>
							<cfcase value="22"><!--- Finansal Yaş --->
								<td style="text-align:right;">
								<cfif isdefined('attributes.location') or session.ep.isBranchAuthorization or (isdefined("attributes.department_id") and len(attributes.department_id) AND listlen(attributes.department_id,'-') eq 2)>
									<cfif len(DUE_DATE_LOCATION)>#dateformat(DUE_DATE_LOCATION,dateformat_style)#</cfif>
                                <cfelseif  isdefined('attributes.location') or session.ep.isBranchAuthorization or (isdefined("attributes.department_id") and len(attributes.department_id) AND listlen(attributes.department_id,'-') neq 2)>
                                	<cfif len(DUE_DATE_DEPARTMENT)>#dateformat(DUE_DATE_DEPARTMENT,dateformat_style)#</cfif>
                                <cfelse>
									<cfif len(DUE_DATE)>#dateformat(DUE_DATE,dateformat_style)#</cfif>
                                </cfif></td>
							</cfcase>
							<cfcase value="23"><!--- Fiziksel Yaş --->
								<td style="text-align:right;">
								<cfif isdefined('attributes.location') or session.ep.isBranchAuthorization or (isdefined("attributes.department_id") and len(attributes.department_id) AND listlen(attributes.department_id,'-') eq 2)>
									<cfif len(PHYSICAL_DATE_LOCATION)>#dateformat(PHYSICAL_DATE_LOCATION,dateformat_style)#</cfif>
                                <cfelseif  isdefined('attributes.location') or session.ep.isBranchAuthorization or (isdefined("attributes.department_id") and len(attributes.department_id) AND listlen(attributes.department_id,'-') neq 2)>
                                	<cfif len(PHYSICAL_DATE_DEPARTMENT)>#dateformat(PHYSICAL_DATE_DEPARTMENT,dateformat_style)#</cfif>
                                <cfelse>
									<cfif len(PHYSICAL_DATE)>#dateformat(PHYSICAL_DATE,dateformat_style)#</cfif>
                                </cfif></td>
							</cfcase>
							<cfcase value="24">
								<td style="text-align:right;"><cfif fusebox.Circuit eq 'store'>#tlformat(wrk_round(STATION_REFLECTION_COST_LOCATION,round_number,1),round_number)# #PURCHASE_NET_MONEY_LOCATION#<cfelse>#tlformat(wrk_round(STATION_REFLECTION_COST,round_number,1),round_number)# #PURCHASE_NET_MONEY#</cfif></td>
							</cfcase>
							<cfcase value="25">
								<td style="text-align:right;"><cfif fusebox.Circuit eq 'store'>#tlformat(wrk_round(LABOR_COST_LOCATION,round_number,1),round_number)# #PURCHASE_NET_MONEY_LOCATION#<cfelse>#tlformat(wrk_round(LABOR_COST,round_number,1),round_number)# #PURCHASE_NET_MONEY#</cfif></td>
							</cfcase>
							<cfcase value="26">
								<td style="text-align:right;">
									<cfif fusebox.Circuit eq 'store'>
										#tlformat(wrk_round(STATION_REFLECTION_COST_SYSTEM_2_LOCATION,round_number,1),round_number)# #session.ep.money2#
									<cfelse>
										#tlformat(wrk_round(STATION_REFLECTION_COST_SYSTEM_2,round_number,1),round_number)# #session.ep.money2#
									</cfif>
								</td>
							</cfcase>
							<cfcase value="27">
								<td style="text-align:right;">
									<cfif fusebox.Circuit eq 'store'>
										#tlformat(wrk_round(LABOR_COST_SYSTEM_2_LOCATION,round_number,1),round_number)# #session.ep.money2#
									<cfelse>
										#tlformat(wrk_round(LABOR_COST_SYSTEM_2,round_number,1),round_number)# #session.ep.money2#
									</cfif>
								</td>
							</cfcase>
							<cfcase value="28">
								<td style="text-align:right;">
									<cfif fusebox.Circuit eq 'store'>
										#tlformat(wrk_round(STATION_REFLECTION_COST_SYSTEM_LOCATION,round_number,1),round_number)# #PURCHASE_NET_SYSTEM_MONEY_LOCATION#
									<cfelse>
										#tlformat(wrk_round(STATION_REFLECTION_COST_SYSTEM,round_number,1),round_number)# #PURCHASE_NET_SYSTEM_MONEY#
									</cfif>
								</td>
							</cfcase>
							<cfcase value="29">
								<td style="text-align:right;">
									<cfif fusebox.Circuit eq 'store'>
										#tlformat(wrk_round(LABOR_COST_SYSTEM_LOCATION,round_number,1),round_number)# #PURCHASE_NET_SYSTEM_MONEY_LOCATION#
									<cfelse>
									#tlformat(wrk_round(LABOR_COST_SYSTEM,round_number,1),round_number)# #PURCHASE_NET_SYSTEM_MONEY#
									</cfif>
								</td>
							</cfcase>
						</cfswitch>
					</cfloop>
				</tr>
			</cfoutput>
		<cfelse>
			<tr>
				<td height="20" colspan="<cfoutput>#colspan_info#</cfoutput>"><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
			</tr>
		</cfif>
	</tbody>
</cf_grid_list>
<cf_box_footer>
	<cfif attributes.totalrecords gt attributes.maxrows>
		<table width="99%" border="0" cellpadding="0" cellspacing="0" height="35" align="center">
			<tr>
				<td>
                <!--- Sayfalar Arası Geçiş Yapıldığında Tarih Filitresinin Diğer Sayfalarda Çalışması İçin Eklendi.Created By MCP 20130917 --->
            		<cfif isdate(attributes.start_date)>
					<cfset adres = "#adres#&start_date=#dateformat(attributes.start_date,dateformat_style)#" >
				</cfif>
				<cfif isdate(attributes.finish_date)>
                	<cfset adres = "#adres#&finish_date=#dateformat(attributes.finish_date,dateformat_style)#" >
				</cfif>
					<cf_paging page="#attributes.page#" 
					maxrows="#attributes.maxrows#" 
					totalrecords="#attributes.totalrecords#" 
					startrow="#attributes.startrow#" 
                    adres="#adres#"
					isAjax="#iif(isdefined("attributes.draggable"),1,0)#">
				</td>
				<!-- sil -->
				<td style="text-align:right;"><cfoutput><cf_get_lang dictionary_id='57540.Toplam Kayıt'>:#attributes.totalrecords# - <cf_get_lang dictionary_id='57581.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td>
				<!-- sil -->
			</tr>
		</table>
	</cfif> 
</cf_box_footer>
<div class="col col-12 col-md-12 col-xs-12" id="extra_cost_det"></div>
<!--- Grafik Bolumu --->
<cfif get_product_cost.recordcount and Len(attributes.graph_type)>
<table align="center">
	<tr>
		<td style="text-align:left;">
			<cfset color_list = "gray,purple,fuchsia,green,lime,olive,yellow,gold,orange,blue,navy,teal,aqua">
			<cfif attributes.graph_type eq 0>
				<!--- Aylik --->
				<cfquery name="get_price_standart" datasource="#dsn3#">
					SELECT
						MONTH(START_DATE) MONTH_START_DATE,
						PRICE PRODUCT_COST,
						0 SPECT_MAIN_ID
					FROM
						PRICE_STANDART
					WHERE
						PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pid#">
						AND PURCHASESALES = 0
				</cfquery>
				<cfquery name="get_last_product_cost" dbtype="query">
					SELECT
						MONTH_START_DATE,
						START_DATE,
						PRODUCT_COST,
						SPECT_MAIN_ID
					FROM 
						GET_PRODUCT_COST 
					WHERE 
						ACTION_PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">
					GROUP BY
						MONTH_START_DATE,
						PRODUCT_COST,
						SPECT_MAIN_ID,
						START_DATE
					ORDER BY
						SPECT_MAIN_ID,
						START_DATE
				</cfquery>
				<cfset Spect_Id_List = ListSort(ListDeleteDuplicates(ValueList(get_last_product_cost.spect_main_id)),"numeric","asc",",")>				
				<cfset color_count = 0>
			
					<cfloop list="#Spect_Id_List#" index="spl">
						<cfif spl eq 0><cfset spl_ = ""><cfset spl_name = ""><cfelse><cfset spl_ = spl><cfset spl_name = "Spect : #spl_#"></cfif>
						<cfif color_count eq ListLen(color_list)><cfset color_count = 0><cfelse><cfset color_count = color_count + 1></cfif>
						<cfset spl_color = ListGetAt(color_list,color_count)>
						<cfif not isDefined("new_#spl_#_count")>
							<cfset "new_#spl_#_count" = 0>
						</cfif>
						<cfloop from="1" to="12" index="mnt">
							<cfquery name="get_last_product_cost" dbtype="query">
								SELECT
									MONTH_START_DATE,
									PRODUCT_COST,
									SPECT_MAIN_ID
								FROM 
									GET_PRODUCT_COST 
								WHERE 
									ACTION_PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#"> AND
									SPECT_MAIN_ID = #spl# AND
									MONTH_START_DATE <= #mnt#
								GROUP BY
									START_DATE,
									MONTH_START_DATE,
									PRODUCT_COST,
									SPECT_MAIN_ID
								ORDER BY
									START_DATE,
									SPECT_MAIN_ID
							</cfquery>
							<cfif get_last_product_cost.month_start_date eq mnt>
								<cfset "new_#spl_#_count" = get_last_product_cost.product_cost>
							</cfif>
							<cfloop query="get_last_product_cost">
								<cfif get_last_product_cost.month_start_date eq mnt>
									<cfset "new_#spl_#_count" = get_last_product_cost.product_cost>
								</cfif>
							</cfloop>
						</cfloop>
						
							<cfif not isDefined("new_price_#spl_#_count")>
								<cfset "new_price_#spl_#_count" = 0>
							</cfif>
							<cfloop from="1" to="12" index="mnt">
								<cfquery name="get_last_price" dbtype="query">
									SELECT
										MONTH_START_DATE,
										PRODUCT_COST,
										SPECT_MAIN_ID
									FROM 
										get_price_standart 
									WHERE 
										SPECT_MAIN_ID = #spl# AND
										MONTH_START_DATE = #mnt#
									GROUP BY
										MONTH_START_DATE,
										PRODUCT_COST,
										SPECT_MAIN_ID
									ORDER BY
										SPECT_MAIN_ID
								</cfquery>
								<cfif get_last_price.month_start_date eq mnt>
									<cfset "new_price_#spl_#_count" = get_last_price.product_cost>
								</cfif>
							
							</cfloop>
					
					</cfloop>
   				<script src="JS/Chart.min.js"></script> 
                <canvas id="myChart" style="height:100%;"></canvas>
                <script>
                    var ctx = document.getElementById('myChart');
                    var myChart = new Chart(ctx, {
                        type: 'line',
                        data: {
                                labels: [<cfloop from="1" to="12" index="mnt">
                                                        <cfoutput>"#ListGetAt(aylar,mnt)#"</cfoutput>,</cfloop>],
                                datasets: [{
                                            label: "Maliyet <cfoutput>#spl_name#</cfoutput>",
                                            backgroundColor: [<cfloop from="1" to="12" index="mnt">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>'rgb(255, 99, 132)'],
                                            data: [<cfloop from="1" to="12" index="mnt"><cfoutput>#Evaluate('new_#spl_#_count')#</cfoutput>,</cfloop>],
                                        },
                                        {
                                            label: "Standart Alış <cfoutput>#spl_name#</cfoutput>",
                                            backgroundColor: [<cfloop from="1" to="12" index="mnt">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>'rgba(255, 99, 132, 0.2)'],
                                            data: [<cfloop from="1" to="12" index="mnt"><cfoutput>#Evaluate('new_price_#spl_#_count')#</cfoutput>,</cfloop>],
                                        }
                                        ]
                                    },
                        options: {}
                        });
                </script> 

				<!--- //Aylik --->
			<cfelse>
				<!--- Gunluk --->
				<cfquery name="get_price_standart" datasource="#dsn3#">
					SELECT
						START_DATE,
						PRICE PRODUCT_COST,
						0 SPECT_MAIN_ID
					FROM
						PRICE_STANDART
					WHERE
						PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pid#">
						AND PURCHASESALES = 0
				</cfquery>
				<cfquery name="get_last_product_cost" dbtype="query">
					SELECT
						START_DATE,
						PRODUCT_COST,
						SPECT_MAIN_ID
					FROM 
						GET_PRODUCT_COST 
					WHERE 
						ACTION_PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">
					GROUP BY
						START_DATE,
						PRODUCT_COST,
						SPECT_MAIN_ID
					ORDER BY
						SPECT_MAIN_ID
				</cfquery>
				<cfset Date_List = "">
				<cfset Spect_Id_List = ListSort(ListDeleteDuplicates(ValueList(get_last_product_cost.spect_main_id)),"numeric","asc",",")>
				<cfset color_count = 0>
				<cfoutput query="get_last_product_cost">
					<cfset start_date_ = DateFormat(start_date,'yyyy-mm-dd')>
					<cfif not ListFind(Date_List,start_date_)>
						<cfset Date_List = ListAppend(Date_List,start_date_)>
					</cfif>
				</cfoutput>
				<cfset Date_List = ListSort(Date_List,"text")>
					<cfloop list="#Spect_Id_List#" index="spl">
						<cfif spl eq 0><cfset spl_ = ""><cfset spl_name = ""><cfelse><cfset spl_ = spl><cfset spl_name = "Spect : #spl_#"></cfif>
						<cfif color_count eq ListLen(color_list)><cfset color_count = 0><cfelse><cfset color_count = color_count + 1></cfif>
						<cfset spl_color = ListGetAt(color_list,color_count)>
						<cfif not isDefined("new_#spl_#_count")>
							<cfset "new_#spl_#_count" = 0>
						</cfif>
						<cfloop list="#Date_List#" index="dl">
							<cfquery name="get_last_product_cost" dbtype="query">
								SELECT
									START_DATE,
									PRODUCT_COST,
									SPECT_MAIN_ID
								FROM 
									GET_PRODUCT_COST 
								WHERE 
									ACTION_PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#"> AND
									SPECT_MAIN_ID = #spl# AND
									START_DATE = #CreateDate(ListGetAt(dl,1,'-'),ListGetAt(dl,2,'-'),ListGetAt(dl,3,'-'))#
								GROUP BY
									START_DATE,
									PRODUCT_COST,
									SPECT_MAIN_ID
								ORDER BY
									SPECT_MAIN_ID
							</cfquery>
							<cfif DateFormat(get_last_product_cost.start_date,'yyyy-mm-dd') is dl>
								<cfset "new_#spl_#_count" = get_last_product_cost.product_cost>
							</cfif>
						</cfloop>
						<cfif not isDefined("new_price_#spl_#_count")>
							<cfset "new_price_#spl_#_count" = 0>
						</cfif>
						<cfloop list="#Date_List#" index="dl">
							<cfquery name="get_last_price" dbtype="query">
								SELECT
									START_DATE,
									PRODUCT_COST,
									SPECT_MAIN_ID
								FROM 
									get_price_standart 
								WHERE 
									SPECT_MAIN_ID = #spl# AND
									START_DATE = #CreateDate(ListGetAt(dl,1,'-'),ListGetAt(dl,2,'-'),ListGetAt(dl,3,'-'))#
								GROUP BY
									START_DATE,
									PRODUCT_COST,
									SPECT_MAIN_ID
								ORDER BY
									SPECT_MAIN_ID
							</cfquery>
							<cfif DateFormat(get_last_price.start_date,'yyyy-mm-dd') is dl>
								<cfset "new_price_#spl_#_count" = get_last_price.product_cost>
							</cfif>
						</cfloop>
					</cfloop>
             <canvas id="myChart2" style="height:100%;"></canvas>
                <script>
                    var ctx = document.getElementById('myChart2');
                    var myChart = new Chart(ctx, {
                        type: 'line',
                        data: {
                                labels: [<cfloop list="#Date_List#" index="dl">
                                                        <cfoutput>"#dl#"</cfoutput>,</cfloop>],
                                datasets: [{
                                            label: "Maliyet <cfoutput>#spl_name#</cfoutput>",
                                            backgroundColor: [<cfloop from="1" to="12" index="mnt">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>'rgb(255, 99, 132)'],
                                            data: [<cfloop list="#Date_List#" index="dl"><cfoutput>#Evaluate('new_#spl_#_count')#</cfoutput>,</cfloop>],
                                        },
                                        {
                                            label: "Standart Alış <cfoutput>#spl_name#</cfoutput>",
                                            backgroundColor: [<cfloop from="1" to="12" index="mnt">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>'rgba(255, 99, 132, 0.2)'],
                                            data: [<cfloop list="#Date_List#" index="dl"><cfoutput>#Evaluate('new_price_#spl_#_count')#</cfoutput>,</cfloop>],
                                        }
                                        ]
                                    },
                        options: {}
                        });
                </script> 	
					<!--- //Gunluk --->			
			</cfif>
		</td>
	</tr>
</table>
</cfif>
</cf_box>
<!--- //Grafik Bolumu --->
<script type="text/javascript">
	function open_action(type,process_id,pid)
	{
		if(type == 1)
			window.open('<cfoutput>#request.self#?fuseaction=invoice.form_add_bill_purchase&event=upd&iid='+process_id+'</cfoutput>','wide');
		else if(type == 2)
			window.open('<cfoutput>#request.self#?fuseaction=stock.form_add_purchase&event=upd&ship_id='+process_id+'</cfoutput>','wide');
		else if(type == 3)
			window.open('<cfoutput>#request.self#?fuseaction=stock.form_add_fis&event=upd&upd_id='+process_id+'</cfoutput>','wide');

		else if(type == 4)
		{
			var p_orderid = pid;
			window.open('<cfoutput>#request.self#?fuseaction=prod.list_results&event=upd&p_order_id='+p_orderid +'&pr_order_id='+process_id+'</cfoutput>','wide');
		}
		else if(type == 5)
			window.open('<cfoutput>#request.self#?fuseaction=invoice.form_add_bill&event=upd&iid='+process_id+'</cfoutput>','wide');
		else if(type == 6)
			window.open('<cfoutput>#request.self#?fuseaction=stock.add_stock_in_from_customs&event=upd&ship_id='+process_id+'</cfoutput>','wide');
		else if(type == 8)
			window.open('<cfoutput>#request.self#?fuseaction=invoice.form_add_bill&event=upd&iid='+process_id+'</cfoutput>','wide');
		else if(type == 7)
			window.open('<cfoutput>#request.self#?fuseaction=stock.form_add_stock_exchange&event=upd&exchange_id='+process_id+'</cfoutput>','wide');
		else if(type == 9)
			window.open('<cfoutput>#request.self#?fuseaction=stock.add_ship_dispatch&event=upd&ship_id='+process_id+'</cfoutput>','wide');
		else if(type == 11)
			window.open('<cfoutput>#request.self#?fuseaction=stock.form_add_ship_open_fis&event=upd&upd_id='+process_id+'</cfoutput>','wide');
		else if(type == 12)	
			window.open('<cfoutput>#request.self#?fuseaction=invent.add_invent_stock_fis&event=upd&fis_id='+process_id+'</cfoutput>','wide');
		else if(type == 13)	
			window.open('<cfoutput>#request.self#?fuseaction=invent.add_invent_stock_fis_return&event=upd&fis_id='+process_id+'</cfoutput>','wide');
	}
	function open_extra_cost(product_id,pr_order_id)
	{
		AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=product.emptypopup_list_extra_cost_detail&pid='+product_id+'&pr_order_id='+pr_order_id,'extra_cost_det',1);
	}
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
