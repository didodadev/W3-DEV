<!---
	Her çeşit atık hareketi ve işlemi "Atık Belgesi" üzerinden yönetilir. Esas
	itibariyle "kabul, gönderim, bertaraf, değerlendirme" işlem kategorilerinden
	lazım olanlar tanımlanarak firmanın ihtiyaçlarına göre kullanıma açılır ve
	atık belgelerinin stok hareketlerinin de kaydedilmiş olmaları sağlanarak
	lojistik operasyonun giriş-çıkışa kadarki kısmı stokla entegre tutulmuş olur.
--->

<cfcomponent>

	<cfset dsn = application.systemParam.systemParam().dsn />
	<cfset dsn2 = "#dsn#_#session.ep.period_year#_#session.ep.company_id#" />
	<cfset dsn3 = "#dsn#_#session.ep.company_id#" />
	<cfset dsn1 = "#dsn#_product" />

	<cfsetting requesttimeout="2000">

	<cffunction name="getWasteOperation" access="public" returntype="any">
		<cfargument name = "waste_operation_id" default="" required="false">
		<cfargument name = "keyword" default="" required="false">
		<cfargument name = "consumer_id" default="" required="false">
		<cfargument name = "company_id" default="" required="false">
		<cfargument name = "member_name" default="" required="false">
		<cfargument name = "process_stage" default="" required="false">
		<cfargument name = "is_exit_date_null" default="0" required="false">
		<cfargument name = "is_analyzeLab" default="0" required="false">
		<cfargument name = "analyzeLabId" default="" required="false">
		
		<cfquery name="getWasteOperation" datasource="#dsn2#">
			SELECT 
				REF.REFINERY_WASTE_OIL_ID,
				REF.CAR_NUMBER,
				REF.DORSE_PLAKA,
				REF.BO_NUMBER,
				REF.CAR_ENTRY_TIME,
				REF.CAR_ENTRY_KG,
				REF.CAR_EXIT_TIME,
				REF.CAR_EXIT_KG,
				REF.CONSUMER_ID,
				REF.COMPANY_ID,
				REF.MEMBER_TYPE,
				REF.CARRIER_CONSUMER_ID,
				REF.CARRIER_COMPANY_ID,
				REF.CARRIER_MEMBER_TYPE,
				REF.DRIVER_PARTNER_ID,
				REF.DRIVER_YRD_PARTNER_ID,
				REF.PROCESS_STAGE,
				REF.GENERAL_PAPER_NO,
				REF.PRODUCT_ID,
				REF.STOCK_ID AS PRODUCT_STOCK_ID,
				REF.PRODUCT_MAIN_UNIT_ID,
				REF.PROPERTY_ID,
				REF.BRANCH_ID,
				REF.DEPARTMENT_ID,
				REF.LOCATION_ID,
				CON.CONSUMER_NAME,
				CON.CONSUMER_SURNAME,
				COM.FULLNAME,
				CON_CARRIER.CONSUMER_NAME AS CARRIER_CONSUMER_NAME,
				CON_CARRIER.CONSUMER_SURNAME AS CARRIER_CONSUMER_SURNAME,
				COM_CARRIER.FULLNAME AS CARRIER_FULLNAME,
				COMP.COMPANY_PARTNER_NAME,
				COMP.COMPANY_PARTNER_SURNAME,
				COMP_HELPER.COMPANY_PARTNER_NAME AS HELPER_COMPANY_PARTNER_NAME,
				COMP_HELPER.COMPANY_PARTNER_SURNAME AS HELPER_COMPANY_PARTNER_SURNAME,
				#dsn#.#dsn#.Get_Dynamic_Language(PROCESS_ROW_ID,'#ucase(session.ep.language)#','PROCESS_TYPE_ROWS','STAGE',NULL,NULL,STAGE) AS STAGE,
				PROD.PRODUCT_NAME,
				PROD.PRODUCT_CODE,
				EMP.EMPLOYEE_NAME,
				EMP.EMPLOYEE_SURNAME,
				PROD.BARCOD,
				STCK.STOCK_ID,
				STCK.STOCK_CODE,
				STCK.STOCK_CODE_2,
				REF.RECORD_EMP,
				EMP.EMPLOYEE_NAME,
				EMP.EMPLOYEE_SURNAME,
				REF.SHIP_ID,
				SU.UNIT
			FROM 
				#dsn#.REFINERY_WASTE_OPERATION AS REF
			JOIN #dsn#.PROCESS_TYPE_ROWS AS PTR ON REF.PROCESS_STAGE = PTR.PROCESS_ROW_ID
			JOIN #dsn#.EMPLOYEES AS EMP ON REF.RECORD_EMP = EMP.EMPLOYEE_ID
			LEFT JOIN #dsn#.CONSUMER AS CON ON REF.CONSUMER_ID = CON.CONSUMER_ID
			LEFT JOIN #dsn#.COMPANY AS COM ON REF.COMPANY_ID = COM.COMPANY_ID
			LEFT JOIN #dsn#.CONSUMER AS CON_CARRIER ON REF.CARRIER_CONSUMER_ID = CON_CARRIER.CONSUMER_ID
			LEFT JOIN #dsn#.COMPANY AS COM_CARRIER ON REF.CARRIER_COMPANY_ID = COM_CARRIER.COMPANY_ID
			LEFT JOIN #dsn#.COMPANY_PARTNER AS COMP ON REF.DRIVER_PARTNER_ID = COMP.PARTNER_ID 
			LEFT JOIN #dsn#.COMPANY_PARTNER AS COMP_HELPER ON REF.DRIVER_YRD_PARTNER_ID = COMP_HELPER.PARTNER_ID
			LEFT JOIN #dsn#_product.PRODUCT AS PROD ON REF.PRODUCT_ID = PROD.PRODUCT_ID
			LEFT JOIN #dsn#_product.STOCKS AS STCK ON REF.STOCK_ID = STCK.STOCK_ID
			LEFT JOIN #dsn#.SETUP_UNIT AS SU ON SU.UNIT_ID = REF.PRODUCT_MAIN_UNIT_ID
			WHERE 1 = 1 AND REF.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
			<cfif isDefined("arguments.waste_operation_id") and len(arguments.waste_operation_id)>
				AND REF.REFINERY_WASTE_OIL_ID = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.waste_operation_id#">
			</cfif>
			<cfif isDefined("arguments.process_stage") and len(arguments.process_stage)>
				AND REF.PROCESS_STAGE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.process_stage#">
			</cfif>
			<cfif isDefined("arguments.consumer_id") and len(arguments.consumer_id) and isDefined("arguments.member_name") and len(arguments.member_name)>
				AND REF.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.consumer_id#">
			</cfif>
			<cfif isDefined("arguments.company_id") and len(arguments.company_id) and isDefined("arguments.member_name") and len(arguments.member_name)>
				AND REF.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.company_id#">
			</cfif>
			<cfif isDefined("arguments.is_exit_date_null") and arguments.is_exit_date_null eq 1>
				AND REF.CAR_EXIT_TIME IS NULL
			</cfif>
			<cfif isDefined("arguments.is_analyzeLab") and arguments.is_analyzeLab eq 1>
				AND REF.REFINERY_WASTE_OIL_ID NOT IN (SELECT DISTINCT REFINERY_WASTE_OIL_ID FROM #dsn#.REFINERY_LAB_TESTS WHERE REFINERY_WASTE_OIL_ID IS NOT NULL <cfif isDefined("arguments.analyzeLabId") and len(arguments.analyzeLabId)>AND REFINERY_LAB_TEST_ID <> <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.analyzeLabId#"></cfif>)
			</cfif>
			<cfif isDefined("arguments.keyword") and len(arguments.keyword)>
				AND 
					(
						REF.CAR_NUMBER LIKE <cfqueryparam cfsqltype="cf_sql_nvarchar" value="%#arguments.keyword#%">
					)
			</cfif>
		</cfquery>
		<cfreturn getWasteOperation />
	</cffunction>
	<cffunction name="getWasteOperationRow" access="public" returntype="any">
		<cfargument name = "waste_operation_id" default="" required="false">
		<cfargument name = "waste_operation_row_id" default="" required="false">
		
		<cfquery name="getWasteOperationRow" datasource="#dsn2#">
			SELECT REFR.*, ASSET.ASSET_FILE_NAME, ASSET.ASSET_NAME, ASSET.ASSET_FILE_REAL_NAME, ASSET.ASSETCAT_ID, ASSET_CAT.ASSETCAT_PATH
			FROM #dsn#.REFINERY_WASTE_OPERATION_ROW AS REFR
			LEFT JOIN #dsn#.ASSET ON REFR.ASSET_ID = ASSET.ASSET_ID
			LEFT JOIN #dsn#.ASSET_CAT ON ASSET.ASSETCAT_ID = ASSET_CAT.ASSETCAT_ID
			WHERE
				1 = 1 
				<cfif len( arguments.waste_operation_id )>AND REFR.REFINERY_WASTE_OIL_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.waste_operation_id#"> </cfif>
				<cfif len( arguments.waste_operation_row_id )>AND REFR.REFINERY_WASTE_OIL_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.waste_operation_row_id#"> </cfif>
			ORDER BY REFINERY_WASTE_OIL_ROW_NUMBER
		</cfquery>
		<cfreturn getWasteOperationRow />
	</cffunction>
	<cffunction name="getWasteOperationRowDocs" access="public" returntype="any">
		<cfargument name = "row_number" default="" required="false">
		<cfargument name = "member_type" default="" required="false">
		<cfargument name = "member_id" default="" required="false">
		<cfargument name = "dorse_plaka" default="" required="false">
		<cfargument name = "driver_id" default="" required="false">
		
		<cfquery name="getWasteOperationRowDocs" datasource="#dsn2#">
			SELECT TOP 1 REFR.*, ASSET.ASSET_FILE_NAME, ASSET.ASSET_NAME, ASSET.ASSET_FILE_REAL_NAME, ASSET.ASSETCAT_ID, ASSET_CAT.ASSETCAT_PATH
			FROM #dsn#.REFINERY_WASTE_OPERATION_ROW AS REFR
			JOIN #dsn#.REFINERY_WASTE_OPERATION AS REF ON REFR.REFINERY_WASTE_OIL_ID = REF.REFINERY_WASTE_OIL_ID
			LEFT JOIN #dsn#.ASSET ON REFR.ASSET_ID = ASSET.ASSET_ID
			LEFT JOIN #dsn#.ASSET_CAT ON ASSET.ASSETCAT_ID = ASSET_CAT.ASSETCAT_ID
			WHERE
				REFR.ASSET_ID IS NOT NULL 
				<cfif len( arguments.row_number )> AND REFR.REFINERY_WASTE_OIL_ROW_NUMBER = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.row_number#"></cfif>
				<cfif len( arguments.member_type ) and arguments.member_type eq 'partner'>
					AND REF.CARRIER_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.member_id#">
				<cfelseif len(arguments.member_type) and arguments.member_type eq 'consumer'>
					AND REF.CARRIER_CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.member_id#">
				</cfif>
				<cfif len( arguments.dorse_plaka )> AND REF.DORSE_PLAKA = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.dorse_plaka#"></cfif>
				<cfif len( arguments.driver_id )> AND REF.DRIVER_PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.driver_id#"></cfif>
			ORDER BY REFR.UPDATE_DATE DESC, REFR.RECORD_DATE DESC
		</cfquery>
		<cfreturn getWasteOperationRowDocs />
	</cffunction>
	<cffunction name="getDrivers" access="public" returntype="any">
		<cfargument name = "company_id" default="" required="false">
		
		<cfquery name="getDrivers" datasource="#dsn#">
			SELECT PARTNER_ID, COMPANY_PARTNER_NAME, COMPANY_PARTNER_SURNAME
			FROM COMPANY_PARTNER
			WHERE
				COMPANY_PARTNER_STATUS = 1
				<cfif len( arguments.company_id )>AND COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.company_id#"> </cfif>
		</cfquery>
		<cfreturn getDrivers />
	</cffunction>
	<cffunction name="delWastOilRow" access="public" returntype="any">
		<cfargument name = "REFINERY_WASTE_OIL_ROW_ID" default="" required="false">
		
		<cfquery name="delWastOilRow" datasource="#dsn2#">
			DELETE FROM #dsn#.REFINERY_WASTE_OPERATION_ROW WHERE REFINERY_WASTE_OIL_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.waste_operation_row_id#">
		</cfquery>
	</cffunction>
	<cffunction name="getWasteOperation_weighbridge" returnType="any" access="remote" returnformat="JSON">
		<cfargument name="plaka" required="true">
		<!---
		<cfquery name="getWeighBridge" datasource="#dsn#_kantar">
			SELECT
			(SELECT TOP 1 ISNULL(CONVERT(INT,Tartim1),0) FROM dbo.Tartim1 WHERE Plaka = <cfqueryparam value = "#arguments.plaka#" cfsqltype="cf_sql_nvarchar"> ORDER BY Tarih1 DESC, Saat1 DESC) AS TARTIM1,
			(SELECT TOP 1 ISNULL(CONVERT(INT,Tartim2),0) FROM dbo.Tartim2 WHERE Plaka = <cfqueryparam value = "#arguments.plaka#" cfsqltype="cf_sql_nvarchar"> ORDER BY Tarih2 DESC, Saat2 DESC) AS TARTIM2
		</cfquery>
		--->
		<cfquery name="getWeighBridge" datasource="#dsn#_kantar">
			SELECT TOP 1 ISNULL(CONVERT(INT,Tartim1),0) AS TARTIM1, ISNULL(CONVERT(INT,Tartim2),0) AS TARTIM2 FROM dbo.Tartim2 
			WHERE Plaka = <cfqueryparam value = "#arguments.plaka#" cfsqltype="cf_sql_nvarchar">
			ORDER BY No DESC
		</cfquery>
	

		<cfreturn Replace(SerializeJson( { tartim_1: getWeighBridge.TARTIM1, tartim_2: getWeighBridge.TARTIM2 } ), "//", "") />
	</cffunction>
	<cffunction name="addWasteOperation" access="public" returntype="any">
		<cfargument name="process_stage" required="true">
		<cfargument name="general_paper_no" required="true">
		<cfargument name="carNumber" required="true">
		<cfargument name="consumer_id" default="" required="false">
		<cfargument name="company_id" default="" required="false">
		<cfargument name="member_name" default="" required="false">
		<cfargument name="member_type" default="" required="false">
		<cfargument name="dorse_plaka" default="" required="true">
		<cfargument name="bo_number" default="" required="true">
		<cfargument name="driver_id" default="" required="false">
		<cfargument name="yrd_driver_id" default="" required="false">
		<cfargument name="car_entry_time" default="" required="false">
		<cfargument name="car_entry_kg" default="" required="false">
		<cfargument name="car_exit_time" default="" required="false">
		<cfargument name="car_exit_kg" default="" required="false">
		<cfargument name="car_entry_hour" default="" required="false">
		<cfargument name="car_entry_minute" default="" required="false">
		<cfargument name="car_exit_hour" default="" required="false">
		<cfargument name="car_exit_minute" default="" required="false">
		<cfargument name="product_id" default="" required="false">
		<cfargument name="product_name" default="" required="false">
		<cfargument name="property_id" default="" required="false">
		<cfargument name="branch_id" default="" required="false">
		<cfargument name="department_id" default="" required="false">
		<cfargument name="location_id" default="" required="false">
		<cfargument name="department_name" default="" required="false">
		<cfargument name="carrier_consumer_id" default="" required="false">
		<cfargument name="carrier_company_id" default="" required="false">
		<cfargument name="carrier_member_name" default="" required="false">
		<cfargument name="carrier_member_type" default="" required="false">
		<cfargument name="stock_id" default="" required="false">
		<cfargument name="main_unit_id" default="" required="false">

		<cfquery name="addWasteOperation" datasource="#dsn2#" result="result">
			INSERT INTO
			#dsn#.REFINERY_WASTE_OPERATION
			(
				CAR_NUMBER,
				CONSUMER_ID,
				COMPANY_ID,
				MEMBER_TYPE,
				CARRIER_CONSUMER_ID,
				CARRIER_COMPANY_ID,
				CARRIER_MEMBER_TYPE,
				DORSE_PLAKA,
				BO_NUMBER,
				DRIVER_PARTNER_ID,
				DRIVER_YRD_PARTNER_ID,
				CAR_ENTRY_KG,
				CAR_EXIT_KG,
				PROCESS_STAGE,
				GENERAL_PAPER_NO,
				PRODUCT_ID,
				PROPERTY_ID,
				BRANCH_ID,
				DEPARTMENT_ID,
				LOCATION_ID,
				RECORD_EMP,
				RECORD_DATE,
				RECORD_IP,
				STOCK_ID,
				PRODUCT_MAIN_UNIT_ID,
				OUR_COMPANY_ID
			)
			VALUES
			(
				<cfif len(arguments.carNumber)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.carNumber#"><cfelse>NULL</cfif>,
				<cfif len(arguments.consumer_id) AND len(arguments.member_name)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.consumer_id#"><cfelse>NULL</cfif>,
				<cfif len(arguments.company_id) AND len(arguments.member_name)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.company_id#"><cfelse>NULL</cfif>,
				<cfif len(arguments.member_type)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.member_type#"><cfelse>NULL</cfif>,
				<cfif len(arguments.carrier_consumer_id) AND len(arguments.carrier_member_name)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.carrier_consumer_id#"><cfelse>NULL</cfif>,
				<cfif len(arguments.carrier_company_id) AND len(arguments.carrier_member_name)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.carrier_company_id#"><cfelse>NULL</cfif>,
				<cfif len(arguments.carrier_member_type)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.carrier_member_type#"><cfelse>NULL</cfif>,
				<cfif len(arguments.dorse_plaka)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.dorse_plaka#"><cfelse>NULL</cfif>,
				<cfif len(arguments.bo_number)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.bo_number#"><cfelse>NULL</cfif>,
				<cfif len(arguments.driver_partner_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.driver_partner_id#"><cfelse>NULL</cfif>,
				<cfif len(arguments.driver_yrd_partner_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.driver_yrd_partner_id#"><cfelse>NULL</cfif>,
				<cfif len(arguments.car_entry_kg)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.car_entry_kg#"><cfelse>NULL</cfif>,
				<cfif len(arguments.car_exit_kg)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.car_exit_kg#"><cfelse>NULL</cfif>,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.process_stage#">,
				<cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.general_paper_no#">,
				<cfif len(arguments.product_id) and len(arguments.product_name)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.product_id#"><cfelse>NULL</cfif>,
				<cfif len(arguments.property_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.property_id#"><cfelse>NULL</cfif>,
				<cfif len(arguments.branch_id) and len(arguments.department_name)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.branch_id#"><cfelse>NULL</cfif>,
				<cfif len(arguments.department_id) and len(arguments.department_name)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.department_id#"><cfelse>NULL</cfif>,
				<cfif len(arguments.location_id) and len(arguments.department_name)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.location_id#"><cfelse>NULL</cfif>,
				#session.ep.userid#,
				#now()#,
				<cfqueryparam cfsqltype="cf_sql_nvarchar" value="#cgi.REMOTE_ADDR#">,
				<cfif len(arguments.stock_id) and len(arguments.product_name)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.stock_id#"><cfelse>NULL</cfif>,
				<cfif len(arguments.main_unit_id) and len(arguments.product_name)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.main_unit_id#"><cfelse>NULL</cfif>,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
			)
		</cfquery>
		<cfreturn result>
	</cffunction>
 	<cffunction name="updWasteOperation" access="public" returntype="any">
		<cfargument name="waste_operation_id" default="" required="true">
		<cfargument name="process_stage" required="true">
		<cfargument name="general_paper_no" required="true">
		<cfargument name="carNumber" default="" required="false">
		<cfargument name="consumer_id" default="" required="false">
		<cfargument name="company_id" default="" required="false">
		<cfargument name="member_name" default="" required="false">
		<cfargument name="member_type" default="" required="false">
		<cfargument name="dorse_plaka" default="" required="false">
		<cfargument name="bo_number" default="" required="false">
		<cfargument name="driver_partner_id" default="" required="false">
		<cfargument name="driver_yrd_partner_id" default="" required="false">
		<cfargument name="car_entry_time" default="" required="false">
		<cfargument name="car_entry_kg" default="" required="false">
		<cfargument name="car_exit_time" default="" required="false">
		<cfargument name="car_exit_kg" default="" required="false">
		<cfargument name="car_entry_hour" default="" required="false">
		<cfargument name="car_entry_minute" default="" required="false">
		<cfargument name="car_exit_hour" default="" required="false">
		<cfargument name="car_exit_minute" default="" required="false">
		<cfargument name="product_id" default="" required="false">
		<cfargument name="product_name" default="" required="false">
		<cfargument name="property_id" default="" required="false">
		<cfargument name="branch_id" default="" required="false">
		<cfargument name="department_id" default="" required="false">
		<cfargument name="location_id" default="" required="false">
		<cfargument name="department_name" default="" required="false">
		<cfargument name="carrier_consumer_id" default="" required="false">
		<cfargument name="carrier_company_id" default="" required="false">
		<cfargument name="carrier_member_name" default="" required="false">
		<cfargument name="carrier_member_type" default="" required="false">
		<cfargument name="stock_id" default="" required="false">
		<cfargument name="main_unit_id" default="" required="false">

		<cfquery name="updWasteOperation" datasource="#dsn2#">
			UPDATE #dsn#.REFINERY_WASTE_OPERATION
			SET
				CAR_NUMBER = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.carNumber#">,
				CONSUMER_ID = <cfif len(arguments.consumer_id) AND len(arguments.member_name)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.consumer_id#"><cfelse>NULL</cfif>,
				COMPANY_ID = <cfif len(arguments.company_id) AND len(arguments.member_name)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.company_id#"><cfelse>NULL</cfif>,
				MEMBER_TYPE = <cfif len(arguments.member_type)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.member_type#"><cfelse>NULL</cfif>,
				CARRIER_CONSUMER_ID = <cfif len(arguments.carrier_consumer_id) AND len(arguments.carrier_member_name)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.carrier_consumer_id#"><cfelse>NULL</cfif>,
				CARRIER_COMPANY_ID = <cfif len(arguments.carrier_company_id) AND len(arguments.carrier_member_name)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.carrier_company_id#"><cfelse>NULL</cfif>,
				CARRIER_MEMBER_TYPE = <cfif len(arguments.carrier_member_type)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.carrier_member_type#"><cfelse>NULL</cfif>,
				DORSE_PLAKA = <cfif len(arguments.dorse_plaka)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.dorse_plaka#"><cfelse>NULL</cfif>,
				BO_NUMBER = <cfif len(arguments.bo_number)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.bo_number#"><cfelse>NULL</cfif>,
				DRIVER_PARTNER_ID = <cfif len(arguments.driver_partner_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.driver_partner_id#"><cfelse>NULL</cfif>,
				DRIVER_YRD_PARTNER_ID = <cfif len(arguments.driver_yrd_partner_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.driver_yrd_partner_id#"><cfelse>NULL</cfif>,
				CAR_ENTRY_KG = <cfif len(arguments.car_entry_kg)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.car_entry_kg#"><cfelse>NULL</cfif>,
				CAR_EXIT_KG = <cfif len(arguments.car_exit_kg)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.car_exit_kg#"><cfelse>NULL</cfif>,
				PROCESS_STAGE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.process_stage#">,
				GENERAL_PAPER_NO = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.general_paper_no#">,
				PRODUCT_ID = <cfif len(arguments.product_id) and len(arguments.product_name)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.product_id#"><cfelse>NULL</cfif>,
				PROPERTY_ID = <cfif len(arguments.property_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.property_id#"><cfelse>NULL</cfif>,
				BRANCH_ID = <cfif len(arguments.branch_id) and len(arguments.department_name)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.branch_id#"><cfelse>NULL</cfif>,
				DEPARTMENT_ID = <cfif len(arguments.department_id) and len(arguments.department_name)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.department_id#"><cfelse>NULL</cfif>,
				LOCATION_ID = <cfif len(arguments.location_id) and len(arguments.department_name)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.location_id#"><cfelse>NULL</cfif>,
				UPDATE_EMP = #session.ep.userid#,
				UPDATE_DATE = #now()#,
				UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#cgi.REMOTE_ADDR#">,
				STOCK_ID = <cfif len(arguments.stock_id) and len(arguments.product_name)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.stock_id#"><cfelse>NULL</cfif>,
				PRODUCT_MAIN_UNIT_ID = <cfif len(arguments.main_unit_id) and len(arguments.product_name)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.main_unit_id#"><cfelse>NULL</cfif>
			WHERE 
				REFINERY_WASTE_OIL_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.waste_operation_id#">
		</cfquery>
	</cffunction>
	<cffunction name="getAsset" access="public" returntype="any">
		<cfargument name="asset_id" required="false">

		<cfquery name="getAsset" datasource="#dsn2#">
			SELECT ASSET_FILE_NAME, ASSET_NAME, ASSET_FILE_REAL_NAME FROM #dsn#.ASSET
			WHERE ASSET_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.asset_id#">
		</cfquery>
		<cfreturn getAsset />
	</cffunction>
	<cffunction name="addAsset" access="public" returntype="any">
		<cfargument name="module_name" required="false">
		<cfargument name="module_id" required="false">
		<cfargument name="action_section" required="false">
		<cfargument name="action_id" required="false">
		<cfargument name="assetcat_id" required="false">
		<cfargument name="asset_file_name" required="true">
		<cfargument name="asset_file_size" required="true">
		<cfargument name="asset_file_server_id" default="1" required="false">
		<cfargument name="asset_name" default="" required="false">
		<cfargument name="asset_file_server_name" default="" required="false">
		<cfargument name="asset_file_real_name" default="" required="false">
		<cfargument name="property_id" default="" required="false">

		<cfset info = { company_id: session.ep.company_id, period_id: session.ep.period_id } />

		<cfquery name="addAsset" datasource="#dsn2#" result="result">
			INSERT INTO #dsn#.[ASSET]
			(
				[MODULE_NAME]
				,[MODULE_ID]
				,[ACTION_SECTION]
				,[ACTION_ID]
				,[ASSETCAT_ID]
				,[ASSET_FILE_NAME]
				,[ASSET_FILE_SIZE]
				,[ASSET_FILE_SERVER_ID]
				,[ASSET_FILE_FORMAT]
				,[ASSET_NAME]
				,[COMPANY_ID]
				,[RECORD_DATE]
				,[RECORD_EMP]
				,[RECORD_IP]
				,[SERVER_NAME]
				,[IS_LIVE]
				,[ASSET_FILE_REAL_NAME]
				,[PERIOD_ID]
				,[IS_ACTIVE]
				,[PROPERTY_ID]
			)
			VALUES
			(
				<cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.module_name#">
				,<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.module_id#">
				,<cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.action_section#">
				,<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.action_id#">
				,<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.assetcat_id#">
				,<cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.asset_file_name#">
				,<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.asset_file_size#">
				,<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.asset_file_server_id#">
				,0
				,<cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.asset_name#">
				,#info.company_id#
				,#now()#
				,#session.ep.userid#
				,<cfqueryparam cfsqltype="cf_sql_nvarchar" value="#cgi.REMOTE_ADDR#">
				,<cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.asset_file_server_name#">
				,0
				,<cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.asset_file_real_name#">
				,#info.period_id#
				,1
				,<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.property_id#">
			)
		</cfquery>

		<cfreturn result />

	</cffunction>
	<cffunction name="updAsset" access="public" returntype="any">
		<cfargument name="asset_id" required="false">
		<cfargument name="action_id" required="false">
		<cfargument name="asset_file_name" required="true">
		<cfargument name="asset_file_size" required="true">
		<cfargument name="asset_name" default="" required="false">
		<cfargument name="asset_file_real_name" default="" required="false">
		<cfargument name="property_id" default="" required="false">

		<cfset info = { company_id: session.ep.company_id, period_id: session.ep.period_id } />

		<cfquery datasource="#dsn2#" result="result">
			UPDATE #dsn#.ASSET 
			SET
				[ACTION_ID] = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.action_id#">,
				[ASSET_FILE_NAME] = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.asset_file_name#">,
				[ASSET_FILE_SIZE] = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.asset_file_size#">,
				[ASSET_NAME] = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.asset_name#">,
				[UPDATE_DATE] = #now()#,
				[UPDATE_EMP] = #session.ep.userid#,
				[UPDATE_IP] = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#cgi.REMOTE_ADDR#">,
				[ASSET_FILE_REAL_NAME] = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.asset_file_real_name#">,
				[PROPERTY_ID] = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.property_id#">
			WHERE ASSET_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.asset_id#">
		</cfquery>

		<cfreturn result />

	</cffunction>
	<cffunction name="delAsset" access="public" returntype="any">
		<cfargument name="asset_id" required="false">

		<cfquery datasource="#dsn2#">
			DELETE FROM #dsn#.ASSET WHERE ASSET_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.asset_id#">
		</cfquery>
	</cffunction>

	<cffunction name = "getWasteOperationDocumentSettings" access="public" returntype="any">
		<cfscript>
			recycleDocuments = [
				{
					"head" : "Araç-Dorse Evrakları",
					"asset_module" : "member",
					"asset_module_id" : 4,
					"assetcat_id" : -9,
					"asset_action" : "COMPANY_ID",
					"waste_operation_fields" : "carrier_company_id,dorse_plaka",
					"documents" : [
						{"name" : "Atık Taşıma Lisansı", "code" : "01.01"},
						{"name" : "Mali Zorunluluk Sigortası", "code" : "01.02"},
						{"name" : "ADR/TSE Belgesi", "code" : "01.03"},
						{"name" : "Muayene", "code" : "01.04"}
					]
				},
				{
					"head" : "Personel Evrakları",
					"asset_module" : "member",
					"asset_module_id" : 4,
					"assetcat_id" : -9,
					"asset_action" : "PARTNER_ID",
					"waste_operation_fields" : "carrier_company_id,driver_id",
					"documents" : [
						{"name" : "Kimlik Fotokopisi", "code" : "02.01"},
						{"name" : "SGK Bildirgesi", "code" : "02.02"},
						{"name" : "I.S.G Eğitimi", "code" : "02.03"},
						{"name" : "EK-2 Periyodik Muayene Formu", "code" : "02.04"},
						{"name" : "Sürücü SRCS Belgesi", "code" : "02.05"}
					]
				}
			];
		
			recycleAssetcatID = 8;
		</cfscript>

		<cfreturn recycleDocuments>
	</cffunction>

	<cffunction name="saveDocument" access="public" returntype="any">
		<cfargument name = "documentId" default="">
		<cfargument name = "docStatus" default="">
		<cfargument name = "documentDeleted" default="">
		<cfargument name = "category" default="">
		<cfargument name = "name" default="">
		<cfargument name = "code" default="">
		<cfargument name = "module" default="">
		<cfargument name = "module_id" default="">
		<cfargument name = "assetcat" default="">
		<cfargument name = "target" default="">
		<cfargument name = "related_fields" default="">

		<cfquery name="upd_document" datasource="#dsn#">
			<cfif len(arguments.documentId)>
				<cfif arguments.documentDeleted eq 0>
					UPDATE
						WASTE_OPERATION_DOCUMENTS
					SET
						CATEGORY = <cfif len(arguments.category)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.category#"><cfelse>NULL</cfif>,
						ASSET_MODULE = <cfif len(arguments.module)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.module#"><cfelse>NULL</cfif>,
						ASSET_MODULE_ID = <cfif len(arguments.module_id)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.module_id#"><cfelse>NULL</cfif>,
						ASSETCAT_ID = <cfif len(arguments.assetcat)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.assetcat#"><cfelse>NULL</cfif>,
						ASSET_ACTION = <cfif len(arguments.target)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.target#"><cfelse>NULL</cfif>,
						RELATED_WO_FIELDS = <cfif len(arguments.related_fields)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.related_fields#"><cfelse>NULL</cfif>,
						DOC_NAME = <cfif len(arguments.name)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.name#"><cfelse>NULL</cfif>,
						DOC_CODE = <cfif len(arguments.code)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.code#"><cfelse>NULL</cfif>,
						DOC_STATUS = <cfif len(arguments.docStatus)><cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.docStatus#"><cfelse>NULL</cfif>
					WHERE
						DOC_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.documentId#">
				<cfelse>
					DELETE FROM WASTE_OPERATION_DOCUMENTS WHERE DOC_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.documentId#">
				</cfif>
			<cfelse>
				INSERT INTO
					WASTE_OPERATION_DOCUMENTS
				(
					CATEGORY,
					ASSET_MODULE,
					ASSET_MODULE_ID,
					ASSETCAT_ID,
					ASSET_ACTION,
					RELATED_WO_FIELDS,
					DOC_NAME,
					DOC_CODE,
					DOC_STATUS,
					OUR_COMPANY_ID
				)
				VALUES
				(
					<cfif len(arguments.category)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.category#"><cfelse>NULL</cfif>,
					<cfif len(arguments.module)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.module#"><cfelse>NULL</cfif>,
					<cfif len(arguments.module_id)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.module_id#"><cfelse>NULL</cfif>,
					<cfif len(arguments.assetcat)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.assetcat#"><cfelse>NULL</cfif>,
					<cfif len(arguments.target)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.target#"><cfelse>NULL</cfif>,
					<cfif len(arguments.related_fields)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.related_fields#"><cfelse>NULL</cfif>,
					<cfif len(arguments.name)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.name#"><cfelse>NULL</cfif>,
					<cfif len(arguments.code)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.code#"><cfelse>NULL</cfif>,
					<cfif len(arguments.docStatus)><cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.docStatus#"><cfelse>NULL</cfif>,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
				)
			</cfif>
		</cfquery>
		<cfreturn 1>
	</cffunction>
	<cffunction name="delDocument" access="public" returntype="any">
		<cfargument name = "documentId" default="">
		<cfquery name="del_document" datasource="#dsn#">
			DELETE FROM WASTE_OPERATION_DOCUMENTS WHERE DOC_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.documentId#">
		</cfquery>
	</cffunction>
</cfcomponent>