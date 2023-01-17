<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
	<cffunction name="getOppSupplier">
		<cfargument name="req_id" type="any">
		<cfargument name="req_type" type="any">
		<cfargument name="access" type="any">
		<cfargument name="plan_id" type="any" default="">
		<cfquery name="get_opp_supplier" datasource="#dsn#_#session.ep.company_id#">
			SELECT * FROM 
			TEXTILE_SR_SUPLIERS
			OUTER APPLY
			(
					select
						TOP 1	
						I_ID,
						I_ROW_ID,
						INTERNAL_NUMBER
					from 
							INTERNALDEMAND_ROW,
							INTERNALDEMAND
					WHERE
					  INTERNAL_ID=INTERNALDEMAND_ROW.I_ID AND
						WRK_ROW_RELATION_ID=CONVERT(NVARCHAR(50),TEXTILE_SR_SUPLIERS.ID) AND
						STOCK_ID=TEXTILE_SR_SUPLIERS.STOCK_ID
			) AS IROW
			WHERE 
				REQ_ID = #arguments.req_id# and ISNULL(REQUEST_TYPE,0)=#arguments.req_type#
				<cfif isDefined("arguments.access") and arguments.access eq 1> 
						AND PRODUCT_CATID IN(
							SELECT PRODUCT_CATID FROM #dsn#_product.PRODUCT_CAT_POSITIONS 
							where POSITION_CODE=#session.ep.position_code#
						)
				</cfif>
				<cfif len(arguments.plan_id)>
					AND PLAN_ID=#arguments.plan_id#
				</cfif>
			ORDER BY 
				PRODUCT_CATID desc,
				ISNULL(IS_STATUS,1) 
		</cfquery>
		<cfreturn get_opp_supplier>
	</cffunction>

	<cffunction name="getReqProcess">
		<cfargument name="req_id" type="any">
		<cfargument name="pcatid" type="any">
		<cfargument name="plan_status" type="any">
		<cfargument name="access" type="any">
		<cfargument name="plan_id" type="any" default="">
		<cfquery name="get_process" datasource="#dsn#_#session.ep.company_id#">
			SELECT 
				*,
				ISNULL(TP.STOCK_ID,0) SEC,
				ISNULL(TP.IS_ORJINAL,0) SEC_ORJ,
				ISNULL(TP.PRICE,PS.PRICE) AS REQ_PRICE,
				ISNULL(TP.MONEY,PS.MONEY) AS REQ_MONEY,
				TP.DETAIL AS DETAIL_
				FROM 
				PRODUCT P,
				PRICE_STANDART PS,
				PRODUCT_CAT PC,
				STOCKS S
				LEFT JOIN TEXTILE_SR_PROCESS TP ON TP.STOCK_ID=S.STOCK_ID 
				AND TP.REQUEST_ID = #arguments.req_id#
				and TP.PRODUCT_CATID=#arguments.pcatid#
			WHERE
				P.PRODUCT_CATID=PC.PRODUCT_CATID AND
				PS.PRODUCT_ID=P.PRODUCT_ID and
				PS.PURCHASESALES=0 AND
				PS.PRICESTANDART_STATUS=1 AND
				P.PRODUCT_STATUS=1 AND
				S.STOCK_STATUS=1 AND
				S.PRODUCT_ID=P.PRODUCT_ID AND
				PC.PRODUCT_CATID=#arguments.pcatid#
				<cfif isDefined("arguments.plan_status") and arguments.plan_status eq 1>
					AND TP.STOCK_ID IS NOT NULL
				</cfif>	
				<cfif isDefined("arguments.access") and arguments.access eq 1> 
					AND P.PRODUCT_MANAGER=#session.ep.position_code#
				</cfif>
				<cfif len(arguments.plan_id)>
					AND TP.PLAN_ID=#arguments.plan_id#
				</cfif>
				ORDER BY 
				ISNULL(TP.STOCK_ID,0) desc,
				ISNULL(IS_STATUS,1)
		</cfquery>
		<cfreturn get_process>
	</cffunction>
	
	 <cffunction name="getOppRival">
	 	<cfif listlen(arguments.req_id) gt 1><cfset arguments.req_id = listfirst(arguments.req_id)></cfif>
		<cfquery name="get_opp_rival" datasource="#dsn#_#session.ep.company_id#">
				SELECT * FROM SampleRequestRivals WHERE REQ_ID = #arguments.req_id#
		</cfquery>
		<cfreturn get_opp_rival>
	</cffunction>
	<cffunction name="getWorkstation">
        <cfquery name="GET_STATION" datasource="#dsn#_#session.ep.company_id#">
            select * from WORKSTATIONS
        </cfquery>
		<cfreturn GET_STATION>
    </cffunction>
	<cffunction name="getOperation">
        <cfquery name="GET_OPERATION" datasource="#dsn#_#session.ep.company_id#">
				select 
					OPERATION_TYPE_ID,
					OPERATION_TYPE,
					OPERATION_CODE
				from OPERATION_TYPES
				order by 
					OPERATION_CODE
        </cfquery>
		<cfreturn GET_OPERATION>
    </cffunction>
	 <cffunction name="getMoney">
		<cfquery name="GET_MONEY" datasource="#dsn#">
			SELECT MONEY FROM SETUP_MONEY WHERE PERIOD_ID = #session.ep.period_id# AND MONEY_STATUS = 1 ORDER BY MONEY DESC
		</cfquery>
		<cfreturn GET_MONEY>
	</cffunction>
	
	 <cffunction name="getRivalPreferenceReasons">
		<cfquery name="GET_RIVAL_PREFERENCE_REASONS" datasource="#DSN#">
			SELECT
				PREFERENCE_REASON_ID,
				PREFERENCE_REASON
			FROM
				SETUP_RIVAL_PREFERENCE_REASONS
			ORDER BY
				PREFERENCE_REASON
		</cfquery>
		<cfreturn GET_RIVAL_PREFERENCE_REASONS>
	</cffunction>
	<cffunction name="getOffRival">
	 	<cfif listlen(arguments.offer_id) gt 1><cfset arguments.offer_id = listfirst(arguments.offer_id)></cfif>
		<cfquery name="get_off_rival" datasource="#dsn#_#session.ep.company_id#">
			SELECT * FROM OFFER_RIVALS WHERE OFFER_ID = #arguments.offer_id#
		</cfquery>
		<cfreturn get_off_rival>   
    </cffunction>
	<cffunction name="getProductCat">
		<cfargument name="product_catid" type="any">
		<cfargument name="access" type="any">
		<cfquery name="get_pcat" datasource="#dsn#_product">
			SELECT * FROM 
			PRODUCT_CAT
			WHERE 
				PRODUCT_CATID IN(#arguments.product_catid#)
				<cfif isDefined("arguments.access") and arguments.access eq 1> 
						AND PRODUCT_CATID IN(
							SELECT PRODUCT_CAT_ID FROM PRODUCT_CAT_POSITIONS 
							where POSITION_CODE=#session.ep.position_code#
						)
				</cfif>
		</cfquery>
		<cfreturn get_pcat>
	</cffunction>
	<cffunction name="getProcessAuthority">
		<cfargument name="process_stage" type="any">
		<cfquery name="getQuery" datasource="#dsn#">
			SELECT 
				DISTINCT PO.EMPLOYEE_ID 
			FROM 
				PROCESS_TYPE PT,
				PROCESS_TYPE_ROWS PRT,
				PROCESS_TYPE_ROWS_POSID PPP,
				EMPLOYEE_POSITIONS PO
			WHERE 
				PT.PROCESS_ID=PRT.PROCESS_ID AND PPP.PROCESS_ROW_ID=PRT.PROCESS_ROW_ID
				AND PO.POSITION_ID=PPP.PRO_POSITION_ID
				AND PRT.PROCESS_ROW_ID=#process_stage#
				AND PO.EMPLOYEE_ID=#session.ep.userid#	
		</cfquery>
		<cfreturn getQuery.recordcount>
	</cffunction>
	<cffunction name="get_supplier_by_productcat" access="remote" returnFormat="JSON">
		<cfargument name="productcat_id" type="any">
		<cfset response = structNew()>
		<cfquery name="get_supplier_by_productcat" datasource="#dsn#_#session.ep.company_id#">
			SELECT * FROM TEXTILE_CAT_SUPLIERS WHERE PRODUCT_CATID = #arguments.productcat_id#  
		</cfquery>
		<cfif get_supplier_by_productcat.recordcount>
			<cfset response.STATUS = true>
			<cfset response.PRODUCT_CATID = get_supplier_by_productcat.PRODUCT_CATID>
			<cfset response.SUPLIERS_ID = get_supplier_by_productcat.SUPLIERS_ID>
		<cfelse>
			<cfset response.STATUS = false>
		</cfif>
		<cfreturn Replace(SerializeJson(response),"//","")>
	</cffunction>
</cfcomponent>

