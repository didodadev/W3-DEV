<cfif not isdefined("get_price_all.recordcount")>
	<cfquery name="GET_PRICE_EXCEPTIONS_ALL" datasource="#DSN3#">
		SELECT
			PRODUCT_CATID,
			PRODUCT_ID,
			PRICE_CATID,
			BRAND_ID
		FROM 
			PRICE_CAT_EXCEPTIONS
		WHERE
			ACT_TYPE = 1 AND
		<cfif isdefined("attributes.company_id") and len(attributes.company_id)>
            COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
        <cfelseif isdefined("attributes.consumer_id") and len(attributes.consumer_id)>
            CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
        <cfelse>
            1=0
        </cfif>	
	</cfquery>
	<cfquery name="GET_PRICE_EXCEPTIONS_PID" dbtype="query">
		SELECT * FROM GET_PRICE_EXCEPTIONS_ALL WHERE PRODUCT_ID IS NOT NULL
	</cfquery>
	<cfquery name="GET_PRICE_EXCEPTIONS_PCATID" dbtype="query">
		SELECT * FROM GET_PRICE_EXCEPTIONS_ALL WHERE PRODUCT_CATID IS NOT NULL
	</cfquery>
	<cfquery name="GET_PRICE_EXCEPTIONS_BRID" dbtype="query">
		SELECT * FROM GET_PRICE_EXCEPTIONS_ALL WHERE BRAND_ID IS NOT NULL
	</cfquery>
	<cfquery name="GET_PRICE_ALL" datasource="#DSN3#">
		SELECT  
			P.CATALOG_ID,
			P.UNIT,
			P.PRICE,
			P.PRICE_KDV,
			P.PRODUCT_ID,
			P.MONEY,
			P.PRICE_CATID,
			ISNULL(P.STOCK_ID,0) STOCK_ID
		FROM 
			PRICE P,
			PRODUCT PR,
			PRODUCT_CAT PC
		WHERE 
			P.PRICE > 0 AND
			<cfif isdefined('add_basket_express_prod_id_list') and len(add_basket_express_prod_id_list)> <!--- hızlı siparis sayfasından cagrılıyorsa --->
				PR.PRODUCT_ID IN (#add_basket_express_prod_id_list#) AND 
			</cfif>
			PC.PRODUCT_CATID = PR.PRODUCT_CATID AND 
			P.PRODUCT_ID = PR.PRODUCT_ID AND
			ISNULL(P.SPECT_VAR_ID,0) = 0 AND 
			P.PRICE_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.price_catid#"> AND
			(
				P.STARTDATE <= #now()# AND
				(P.FINISHDATE >= #now()# OR P.FINISHDATE IS NULL)
			)
			AND
			(
				<cfif get_price_exceptions_pid.recordcount or get_price_exceptions_pcatid.recordcount or get_price_exceptions_brid.recordcount>
					<cfif get_price_exceptions_pid.recordcount>
						P.PRODUCT_ID NOT IN (#valuelist(get_price_exceptions_pid.product_id)#)
					</cfif>
					<cfif get_price_exceptions_pcatid.recordcount>
						<cfif get_price_exceptions_pid.recordcount>AND </cfif> PR.PRODUCT_CATID NOT IN (#valuelist(get_price_exceptions_pcatid.product_catid)#)
					</cfif>
					<cfif get_price_exceptions_brid.recordcount>
						<cfif get_price_exceptions_pid.recordcount or get_price_exceptions_pcatid.recordcount>AND </cfif> 
						(PR.BRAND_ID NOT IN (#valuelist(get_price_exceptions_brid.BRAND_ID)#) OR PR.BRAND_ID IS NULL )
					</cfif>
				<cfelse>
					1=1
				</cfif>
			)
			<cfif isdefined('get_product_hierarchy') and get_product_hierarchy.recordcount>
				AND 
					(PC.PRODUCT_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_product_hierarchy.product_catid#"> OR PC.HIERARCHY LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#get_product_hierarchy.hierarchy#.%">)
			</cfif>
			<cfif isdefined('attributes.employee') and len(attributes.employee) and isdefined('attributes.pos_code') and len(attributes.pos_code)>
				AND PR.PRODUCT_MANAGER = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pos_code#">
			</cfif>
			<cfif isdefined('attributes.get_company') and len(attributes.get_company) and isdefined('attributes.get_company_id') and len(attributes.get_company_id)>
				AND PR.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.get_company_id#">
			</cfif>
			<cfif isdefined('attributes.brand_id') and len(attributes.brand_id) and isdefined('attributes.brand_name') and len(attributes.brand_name)>
				AND PR.BRAND_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.brand_id#">
			</cfif>
			<cfif isDefined("attributes.keyword") and len(attributes.keyword) gt 1>
				AND
					(
						(
							PR.PRODUCT_CODE LIKE <cfqueryparam value="%#attributes.keyword#%" cfsqltype="cf_sql_varchar"> OR
							PR.PRODUCT_CODE_2 LIKE <cfqueryparam value="%#attributes.keyword#%" cfsqltype="cf_sql_varchar"> OR
							PR.PRODUCT_NAME LIKE <cfqueryparam value="%#attributes.keyword#%" cfsqltype="cf_sql_varchar"> OR
							PR.PRODUCT_DETAIL2 LIKE <cfqueryparam value="%#attributes.keyword#%" cfsqltype="cf_sql_varchar">
						)
						OR 
						PR.BARCOD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#"> OR
						PR.MANUFACT_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#">
					)
			<cfelseif isDefined("attributes.keyword") and len(attributes.keyword) eq 1>
				AND	PR.PRODUCT_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#">
			</cfif>
			<cfif isdefined("sepet_process_type") and (sepet_process_type neq -1)>
				<cfif ListFind("56,58,60,63",sepet_process_type)>
					AND PR.IS_INVENTORY = 0
				</cfif>
			</cfif>						
			<cfif get_price_exceptions_pid.recordcount>
                UNION
                    SELECT 
                        CATALOG_ID,
                        UNIT,
                        PRICE,
                        PRICE_KDV,
                        PRODUCT_ID,
                        MONEY,
                        PRICE_CATID,
                        0 STOCK_ID
                    FROM
                        PRICE
                    WHERE
                        PRICE > 0 AND
                        <cfif isdefined('add_basket_express_prod_id_list') and len(add_basket_express_prod_id_list)> <!--- hızlı siparis sayfasından cagrılıyorsa --->
                            PRODUCT_ID IN (#add_basket_express_prod_id_list#) AND 
                        </cfif>
                        ISNULL(STOCK_ID,0)=0 AND 
                        ISNULL(SPECT_VAR_ID,0)=0 AND 
                        STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> AND
                        (FINISHDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> OR FINISHDATE IS NULL) AND
                        <cfif get_price_exceptions_pid.recordcount gt 1>(</cfif>
                            <cfoutput query="get_price_exceptions_pid">
                                (PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#product_id#"> AND PRICE_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#price_catid#">)
                                <cfif get_price_exceptions_pid.recordcount neq get_price_exceptions_pid.currentrow>
                                OR
                                </cfif>
                            </cfoutput>
                        <cfif get_price_exceptions_pid.recordcount gt 1>)</cfif>
            </cfif>
            <cfif get_price_exceptions_pcatid.recordcount>
                UNION
                    SELECT
                        P.CATALOG_ID,
                        P.UNIT,
                        P.PRICE,
                        P.PRICE_KDV,
                        P.PRODUCT_ID,
                        P.MONEY,
                        P.PRICE_CATID,
                        0 STOCK_ID
                    FROM
                        PRICE P,
                        PRODUCT PR
                    WHERE 
                        P.PRICE > 0 AND
                        ISNULL(P.STOCK_ID,0)=0 AND 
                        ISNULL(P.SPECT_VAR_ID,0)=0 AND 
                        <cfif isdefined('add_basket_express_prod_id_list') and len(add_basket_express_prod_id_list)> <!--- hızlı siparis sayfasından cagrılıyorsa --->
                            PR.PRODUCT_ID IN (#add_basket_express_prod_id_list#) AND 
                        </cfif>
                        <cfif get_price_exceptions_pid.recordcount>
                            P.PRODUCT_ID NOT IN (#valuelist(get_price_exceptions_pid.PRODUCT_ID)#) AND
                        </cfif>
                        P.PRODUCT_ID = PR.PRODUCT_ID AND
                        P.STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> AND
                        (P.FINISHDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> OR P.FINISHDATE IS NULL) AND
                        <cfif get_price_exceptions_pcatid.recordcount gt 1>(</cfif>
                        <cfoutput query="get_price_exceptions_pcatid">
                            (PR.PRODUCT_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#product_catid#"> AND P.PRICE_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#price_catid#">)
                            <cfif get_price_exceptions_pcatid.recordcount neq get_price_exceptions_pcatid.currentrow>
                                OR
                            </cfif>
                        </cfoutput>
                        <cfif get_price_exceptions_pcatid.recordcount gt 1>)</cfif>
            </cfif>
            <cfif get_price_exceptions_brid.recordcount>
                UNION
                    SELECT
                        P.CATALOG_ID,
                        P.UNIT,
                        P.PRICE,
                        P.PRICE_KDV,
                        P.PRODUCT_ID,
                        P.MONEY,
                        P.PRICE_CATID,
                        0 STOCK_ID
                    FROM
                        PRICE P,
                        PRODUCT PR
                    WHERE 
                        P.PRICE > 0 AND
                        ISNULL(P.STOCK_ID,0)=0 AND 
                        ISNULL(P.SPECT_VAR_ID,0)=0 AND 
                        <cfif isdefined('add_basket_express_prod_id_list') and len(add_basket_express_prod_id_list)> <!--- hızlı siparis sayfasından cagrılıyorsa --->
                            PR.PRODUCT_ID IN (#add_basket_express_prod_id_list#) AND 
                        </cfif>
                        <cfif get_price_exceptions_pid.recordcount>
                            P.PRODUCT_ID NOT IN (#valuelist(get_price_exceptions_pid.PRODUCT_ID)#) AND
                        </cfif>
                        <cfif get_price_exceptions_pcatid.recordcount>
                            PR.PRODUCT_CATID NOT IN (#valuelist(get_price_exceptions_pcatid.PRODUCT_CATID)#) AND
                        </cfif>
                        P.PRODUCT_ID = PR.PRODUCT_ID AND
                        P.STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> AND
                        (P.FINISHDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> OR P.FINISHDATE IS NULL) AND
                        <cfif get_price_exceptions_brid.recordcount gt 1>(</cfif>
                        <cfoutput query="get_price_exceptions_brid">
                            (PR.BRAND_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#brand_id#"> AND P.PRICE_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#price_catid#">)
                            <cfif get_price_exceptions_brid.recordcount neq get_price_exceptions_brid.currentrow>
                                OR
                            </cfif>
                        </cfoutput>
                        <cfif get_price_exceptions_brid.recordcount gt 1>)</cfif>
            </cfif>
	</cfquery>
</cfif>
