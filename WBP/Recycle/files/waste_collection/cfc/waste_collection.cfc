<!---
	Atık toplama - Waste Collection işlemlerinin sorguları burada toplanır. Lojistik,
	nakliyat gibi operasyonlar bu belgeler baz alınarak ilerletilir. Recycle modül
	grubunun haricinde sadece atık toplama işlemi yapılan implementasyonlar için de
	en verimli kullanımı sunacak şekilde diğer objelerden bağımsız halde çalışarak
	lojistik odaklı firmaların da ihtiyaçlarının birebir karşılanması amaçlanır. Ayrıca
	insan kontrolünü minimuma indirmek için kaynak ve rota optimizasyonları ile araç
	takip sistemlerinden faydalanılır. CRM > Servis başvuruları modülü kayıtları ile
	atık alım taleplerini son kullanıcıdan alarak otomasyon sağlamak mümkündür.
--->

<cfcomponent>

	<cfset dsn = application.systemParam.systemParam().dsn />
	<cfset dsn2 = "#dsn#_#session.ep.period_year#_#session.ep.company_id#" />
	<cfset dsn3 = "#dsn#_#session.ep.company_id#" />
	<cfset dsn1 = "#dsn#_product" />

	<cfsetting requesttimeout="2000">

	<cffunction name="GetWasteCollection" access="public" returntype="any">
		<cfargument name = "waste_collection_id" default="" required="false">
		<cfargument name = "keyword" default="" required="false">
		<cfargument name = "process_stage" default="" required="false">

		<cfquery name="GetWasteCollection" datasource="#dsn#">
			SELECT
				REFI.WASTE_COLLECTION_EXPEDITIONS_ID,
				REFI.PROCESS_STAGE,
				REFI.ATS_NO,
				REFI.DRIVER_ID,
				REFI.YRD_DRIVER_ID,
				REFI.ASSETP_ID,
				REFI.ASSETP_DORSE_ID,
				REFI.EXPEDITION_ENTRY_TIME,
				REFI.EXPEDITION_EXIT_TIME,
				REFI.RECORD_EMP,
				REFI.RECORD_DATE,
				REFI.UPDATE_EMP,
				REFI.UPDATE_DATE,
				REFI.EXPEDITION_ENTRY_TIME,
				REFI.EXPEDITION_EXIT_TIME,
				EMP.EMPLOYEE_NAME AS DRIVER_EMPLOYEE_NAME,
				EMP.EMPLOYEE_SURNAME AS DRIVER_EMPLOYEE_SURNAME,
				EMP_YRD.EMPLOYEE_NAME AS YRD_EMPLOYEE_NAME,
				EMP_YRD.EMPLOYEE_SURNAME AS YRD_EMPLOYEE_SURNAME,
				ASS_CEKICI.ASSETP AS ASSETP_NAME,
				ASS_DORSE.ASSETP AS ASSETP_DORSE_NAME

			FROM 
				REFINERY_WASTE_COLLECTION AS REFI
			JOIN #dsn#.PROCESS_TYPE_ROWS AS PTR ON REFI.PROCESS_STAGE = PTR.PROCESS_ROW_ID
			LEFT JOIN EMPLOYEES AS EMP ON REFI.DRIVER_ID = EMP.EMPLOYEE_ID
			LEFT JOIN EMPLOYEES AS EMP_YRD ON REFI.YRD_DRIVER_ID = EMP_YRD.EMPLOYEE_ID
			LEFT JOIN ASSET_P AS ASS_CEKICI ON REFI.ASSETP_ID = ASS_CEKICI.ASSETP_ID
			LEFT JOIN ASSET_P AS ASS_DORSE ON REFI.ASSETP_DORSE_ID = ASS_DORSE.ASSETP_ID
			WHERE
				1 = 1
				AND REFI.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
				<cfif isDefined("arguments.waste_collection_id") and len(arguments.waste_collection_id)>
					AND REFI.WASTE_COLLECTION_EXPEDITIONS_ID = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.waste_collection_id#">
				</cfif>
				<cfif isDefined("arguments.process_stage") and len(arguments.process_stage)>
					AND REFI.PROCESS_STAGE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.process_stage#">
				</cfif>
		</cfquery>
		<cfreturn GetWasteCollection />
	</cffunction>
	<cffunction name="saveWasteCollection" access="public" returntype="any">
		<cfargument name="process_stage" required="true">
		<cfargument name="ats_no" required="false">
		<cfargument name="driver_id" required="false">
		<cfargument name="driver_name" required="false">
		<cfargument name="driver_yrd_id" required="false">
		<cfargument name="driver_yrd_name" required="false">
		<cfargument name="assetp_id" required="false">
		<cfargument name="assetp_name" required="false">
		<cfargument name="assetp_dorse_id" required="false">
		<cfargument name="assetp_dorse_name" required="false">
		<cfargument name="expedition_entry_time" required="false">
		<cfargument name="expedition_exit_time" required="false">

		<cfquery name="saveWasteCollection" datasource="#dsn#" result="result">
			INSERT INTO
				REFINERY_WASTE_COLLECTION
				(
					PROCESS_STAGE,
					ATS_NO,
					DRIVER_ID,
					YRD_DRIVER_ID,
					ASSETP_ID,
					ASSETP_DORSE_ID,
					EXPEDITION_ENTRY_TIME,
					EXPEDITION_EXIT_TIME,
					RECORD_EMP,
					RECORD_DATE,
					RECORD_IP,
					OUR_COMPANY_ID
				)
				VALUES
				(
					<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.process_stage#">,
					<cfif len(arguments.ats_no)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.ats_no#"><cfelse>NULL</cfif>,
					<cfif len(arguments.driver_id) AND len(arguments.driver_name)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.driver_id#"><cfelse>NULL</cfif>,
					<cfif len(arguments.driver_yrd_id) AND len(arguments.driver_yrd_name)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.driver_yrd_id#"><cfelse>NULL</cfif>,
					<cfif len(arguments.assetp_id) AND len(arguments.assetp_name)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.assetp_id#"><cfelse>NULL</cfif>,
					<cfif len(arguments.assetp_dorse_id) AND len(arguments.assetp_dorse_name)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.assetp_dorse_id#"><cfelse>NULL</cfif>,
					<cfif len(arguments.expedition_entry_time)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.expedition_entry_time#"><cfelse>NULL</cfif>,
					<cfif len(arguments.expedition_exit_time)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.expedition_exit_time#"><cfelse>NULL</cfif>,
					#session.ep.userid#,
					#now()#,
					<cfqueryparam cfsqltype="cf_sql_nvarchar" value="#cgi.REMOTE_ADDR#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
				)
		</cfquery>
		<cfreturn result>
	</cffunction>
	<cffunction name="updWasteCollection" access="public" returntype="any">
		<cfargument name="waste_collection_id" required="true">
		<cfargument name="process_stage" required="true">
		<cfargument name="ats_no" required="false">
		<cfargument name="driver_id" default="" required="false">
		<cfargument name="driver_name" default="" required="false">
		<cfargument name="driver_yrd_id" default="" required="false">
		<cfargument name="driver_yrd_name" default="" required="false">
		<cfargument name="assetp_id" default="" required="false">
		<cfargument name="assetp_name" default="" required="false">
		<cfargument name="assetp_dorse_id" default="" required="false">
		<cfargument name="assetp_dorse_name" default="" required="false">
		<cfargument name="expedition_entry_time" default="" required="false">
		<cfargument name="expedition_exit_time" default="" required="false">

		<cfquery name="updWasteCollection" datasource="#dsn#">
			UPDATE REFINERY_WASTE_COLLECTION
			SET
				PROCESS_STAGE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.process_stage#">,
				ATS_NO = <cfif len(arguments.ats_no)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.ats_no#"></cfif>,
				DRIVER_ID = <cfif len(arguments.driver_id) AND len(arguments.driver_name)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.driver_id#"><cfelse>NULL</cfif>,
				YRD_DRIVER_ID = <cfif len(arguments.driver_yrd_id) AND len(arguments.driver_yrd_name)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.driver_yrd_id#"><cfelse>NULL</cfif>,
				ASSETP_ID = <cfif len(arguments.assetp_id) AND len(arguments.assetp_name)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.assetp_id#"><cfelse>NULL</cfif>,
				ASSETP_DORSE_ID = <cfif len(arguments.assetp_dorse_id) AND len(arguments.assetp_dorse_name)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.assetp_dorse_id#"><cfelse>NULL</cfif>,
				EXPEDITION_ENTRY_TIME = <cfif len(arguments.expedition_entry_time)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.expedition_entry_time#"><cfelse>NULL</cfif>,
				EXPEDITION_EXIT_TIME = <cfif len(arguments.expedition_exit_time)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.expedition_exit_time#"><cfelse>NULL</cfif>, 
				UPDATE_EMP = #session.ep.userid#,
				UPDATE_DATE = #now()#,
				UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#cgi.REMOTE_ADDR#">
			WHERE 
				WASTE_COLLECTION_EXPEDITIONS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.waste_collection_id#">
		</cfquery>
	</cffunction>
	<cffunction name="GetWasteCollectionRows" access="public" returntype="any">
		<cfargument name = "waste_collection_id" default="" required="false">
		<cfquery name="GetWasteCollectionRows" datasource="#dsn#">
			SELECT
				REFI.*,
				S.SERVICE_NO,
				C.FULLNAME,
				CB.COMPBRANCH_ADDRESS ADDRESS,
                CB.COMPBRANCH_POSTCODE POSTCODE,
                CB.COUNTY_ID COUNTY,
                CB.CITY_ID CITY,
                CB.COUNTRY_ID COUNTRY,
                CB.SEMT SEMT,
				SCTRY.COUNTRY_NAME,
                SCITY.CITY_NAME,
                SCTY.COUNTY_NAME,
                P.COMPANY_PARTNER_ADDRESS,
                P.COMPANY_PARTNER_POSTCODE,
                P.SEMT P_SEMT,
                SCTRY2.COUNTRY_NAME P_COUNTRY_NAME,
                SCITY2.CITY_NAME P_CITY_NAME,
                SCTY2.COUNTY_NAME P_COUNTY_NAME,
                (SELECT SUM(ISNULL(AMOUNT,0)) AMOUNT FROM #dsn3#.SERVICE_OPERATION WHERE SERVICE_ID = REFI.SERVICE_ID) AMOUNT
			FROM 
				REFINERY_WASTE_COLLECTION_ROWS AS REFI
				LEFT JOIN #dsn3#.SERVICE S ON REFI.SERVICE_ID = S.SERVICE_ID
				LEFT JOIN #dsn#.COMPANY_BRANCH CB ON CB.COMPBRANCH_ID = S.OTHER_COMPANY_BRANCH_ID
                LEFT JOIN #dsn#.COMPANY C ON CB.COMPANY_ID = C.COMPANY_ID AND CB.COMPANY_ID = S.OTHER_COMPANY_ID
                LEFT JOIN #dsn#.SETUP_COUNTRY SCTRY ON SCTRY.COUNTRY_ID = CB.COUNTRY_ID
                LEFT JOIN #dsn#.SETUP_CITY SCITY ON SCITY.CITY_ID = CB.CITY_ID
                LEFT JOIN #dsn#.SETUP_COUNTY SCTY ON SCTY.COUNTY_ID = CB.COUNTY_ID
                LEFT JOIN #dsn#.COMPANY_PARTNER P ON S.SERVICE_COMPANY_ID = P.COMPANY_ID AND S.SERVICE_PARTNER_ID = P.PARTNER_ID
                LEFT JOIN #dsn#.SETUP_COUNTRY SCTRY2 ON SCTRY2.COUNTRY_ID = P.COUNTRY
                LEFT JOIN #dsn#.SETUP_CITY SCITY2 ON SCITY2.CITY_ID = P.CITY
                LEFT JOIN #dsn#.SETUP_COUNTY SCTY2 ON SCTY2.COUNTY_ID = P.COUNTY
			WHERE
				1 = 1
				<cfif isDefined("arguments.waste_collection_id") and len(arguments.waste_collection_id)>
					AND REFI.WASTE_COLLECTION_EXPEDITIONS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.waste_collection_id#">
				</cfif>
		</cfquery>
		<cfreturn GetWasteCollectionRows />
	</cffunction>
	<cffunction name="GetWasteCollectionServicesRows" access="remote" returntype="query">
        <cfargument name="service_id" default="">
        <cfquery name="GetWasteCollectionServicesRows" datasource="#DSN3#">
            SELECT 
                ISNULL(SO.AMOUNT,0) AMOUNT,
                SO.PREDICTED_AMOUNT,
                SO.WRK_ROW_ID,
                SO.SPARE_PART_ID,
                SO.SERVICE_EMP_ID,
                SO.SERIAL_NO,
                SO.STOCK_ID,
                SO.PRODUCT_ID,
                SO.PRODUCT_NAME,
                SO.DETAIL,
                SO.UNIT_ID,
                SO.UNIT,
                SO.PRICE,
                SO.TOTAL_PRICE,
                SO.CURRENCY,
                SO.IS_TOTAL,
                SO.SERVICE_OPE_ID,
                SSP.SPARE_PART,
                P.PRODUCT_CODE_2,
				P.PRODUCT_CODE_2 + '-' + P.PRODUCT_NAME P_FULLNAME
            FROM 
                SERVICE_OPERATION SO
                LEFT JOIN SERVICE_SPARE_PART SSP ON SO.SPARE_PART_ID = SSP.SPARE_PART_ID
                LEFT JOIN #dsn1#.PRODUCT P ON SO.PRODUCT_ID = P.PRODUCT_ID
            WHERE 
                SERVICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.service_id#">
        </cfquery>
        <cfreturn GetWasteCollectionExpeditionsServicesRows>
    </cffunction>
</cfcomponent>