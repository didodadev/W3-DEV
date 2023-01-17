<cfquery name="GET_HIERARCHIES" datasource="#DSN#">
	SELECT
		DISTINCT
		SZ_HIERARCHY
	FROM
		SALES_ZONES_ALL_1
	WHERE
		POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">
</cfquery>
<cfset row_block = 500>
<cfquery name="GET_RETURNS" datasource="#DSN3#" cachedwithin="#fusebox.general_cached_time#">
	SELECT
		SPR.RETURN_ID,
		SPR.SERVICE_PARTNER_ID,
		SPR.SERVICE_COMPANY_ID,
		SPR.SERVICE_CONSUMER_ID,
		SPR.SERVICE_EMPLOYEE_ID,
		SPR.RECORD_DATE,
        SPR.UPDATE_DATE,
		SPR.INVOICE_ID,
        SPR.PAPER_NO
		<cfif isdefined('attributes.listing_type') and attributes.listing_type eq 2>
			,SPRR.IS_SHIP,
			SPRR.AMOUNT,
			SPRR.RETURN_ROW_ID,
			SPRR.RETURN_ACT_TYPE,
			SPRR.RETURN_TYPE ROW_RETURN_TYPE,
			SPRR.RETURN_ACT_TYPE ROW_RETURN_ACT_TYPE,
			SPRR.RETURN_STAGE,
			SPRR.STOCK_ID,
			SPRR.INVOICE_ROW_ID,
            SPRR.RETURN_PERIOD_ID,
			S.PRODUCT_NAME,
			S.PROPERTY,
			S.PRODUCT_ID
		</cfif>
	FROM
		SERVICE_PROD_RETURN SPR WITH (NOLOCK),
		SERVICE_PROD_RETURN_ROWS SPRR WITH (NOLOCK),
		STOCKS S WITH (NOLOCK)
	WHERE
		SPR.RETURN_ID = SPRR.RETURN_ID AND
		SPRR.STOCK_ID = S.STOCK_ID AND
	
		<cfif len(attributes.keyword)>
			(
				SPR.PAPER_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI OR
			<cfif isdefined("attributes.return_type") and len(attributes.return_type)>
				S.PRODUCT_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI
			<cfelse>
				SPR.RETURN_ID IN (SELECT RETURN_ID FROM SERVICE_PROD_RETURN_ROWS,STOCKS WHERE SERVICE_PROD_RETURN_ROWS.STOCK_ID = STOCKS.STOCK_ID AND SERVICE_PROD_RETURN_ROWS.IS_SHIP = 1 AND STOCKS.PRODUCT_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI)
			</cfif>
			)
			AND
		</cfif>
		SPR.RETURN_ID IS NOT NULL
		<cfif isdefined("attributes.is_irsaliye") and attributes.is_irsaliye eq 1>
			<cfif isdefined('attributes.listing_type') and attributes.listing_type eq 2>AND SPRR.IS_SHIP = 1<cfelse>AND SPR.RETURN_ID IN (SELECT RETURN_ID FROM SERVICE_PROD_RETURN_ROWS WHERE IS_SHIP = 1)</cfif>
		<cfelseif isdefined("attributes.is_irsaliye") and attributes.is_irsaliye eq 0>
			<cfif isdefined('attributes.listing_type') and attributes.listing_type eq 2>AND (SPRR.IS_SHIP <> 1 OR SPRR.IS_SHIP IS NULL)<cfelse>AND SPR.RETURN_ID IN (SELECT RETURN_ID FROM SERVICE_PROD_RETURN_ROWS WHERE (IS_SHIP <> 1 OR IS_SHIP IS NULL))</cfif>
		</cfif>
		<cfif isdefined("attributes.start_date") and len(attributes.start_date)>
			AND SPR.RECORD_DATE >= #attributes.start_date#
		</cfif>
		<cfif  isdefined("attributes.finish_date") and  len(attributes.finish_date)>
			AND SPR.RECORD_DATE < #DATEADD("d",1,attributes.finish_date)#
		</cfif>
		<cfif isdefined("attributes.return_stage") and len(attributes.return_stage)>
			<cfif isdefined('attributes.listing_type') and attributes.listing_type eq 2>AND SPRR.RETURN_STAGE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.return_stage#"><cfelse>AND SPR.RETURN_ID IN (SELECT RETURN_ID FROM SERVICE_PROD_RETURN_ROWS WHERE RETURN_STAGE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.return_stage#">)</cfif>
		</cfif>
		<cfif isdefined("attributes.return_type") and len(attributes.return_type)>
			<cfif isdefined('attributes.listing_type') and attributes.listing_type eq 2>AND SPRR.RETURN_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.return_type#"><cfelse>AND SPR.RETURN_ID IN (SELECT RETURN_ID FROM SERVICE_PROD_RETURN_ROWS WHERE RETURN_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.return_type#">)</cfif>
		</cfif>
		<cfif isdefined("attributes.member_type") and attributes.member_type is 'partner' and len(attributes.company_id) and len(attributes.member_name)>
			AND SPR.SERVICE_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
		<cfelseif isdefined("attributes.member_type") and attributes.member_type is 'consumer' and len(attributes.consumer_id) and len(attributes.member_name)>
			AND SPR.SERVICE_CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
		</cfif>
		<cfif isdefined("attributes.product_process_type") and len(attributes.product_process_type)>
			AND  ( SPR.RETURN_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_process_type#"> OR SPRR.RETURN_ACT_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_process_type#">	)
		</cfif>
		<cfif session.ep.our_company_info.sales_zone_followup eq 1>
			<!--- Satis Takimda Ekip Lideri veya Satıs Takiminda Ekipde ise ilgili IMS ler--->
			AND 
			(
				<!--- Kurumsal üye ise --->
				(
					SPR.SERVICE_COMPANY_ID IS NOT NULL AND
					(
						SPR.SERVICE_COMPANY_ID IN (
											SELECT
												C.COMPANY_ID
											FROM
												#dsn_alias#.SALES_ZONES_ALL_2,
												#dsn_alias#.COMPANY C
											WHERE
												POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#"> 
												AND C.IMS_CODE_ID = SALES_ZONES_ALL_2.IMS_ID
										 )
						<!--- Satis bolgeleri ekibinde veya Satis bolgesinde yonetici ise kendisi ve altindaki IMS ler--->			
						<cfif get_hierarchies.recordcount>
							OR SPR.SERVICE_COMPANY_ID IN (
												SELECT
													C.COMPANY_ID
												FROM
													#dsn_alias#.SALES_ZONES_ALL_1,
													#dsn_alias#.COMPANY C
												WHERE
													C.IMS_CODE_ID = SALES_ZONES_ALL_1.IMS_ID AND									
													<cfloop index="page_stock" from="0" to="#(ceiling(get_hierarchies.recordcount/row_block))-1#">
														<cfset start_row=(page_stock*row_block)+1>	
														<cfset end_row=start_row+(row_block-1)>
														<cfif (end_row) gte get_hierarchies.recordcount>
															<cfset end_row=get_hierarchies.recordcount>
														</cfif>
															(
															<cfloop index="add_stock" from="#start_row#" to="#end_row#">
																<cfif (add_stock mod row_block) neq 1> OR</cfif> SZ_HIERARCHY+'.' LIKE '#get_hierarchies.sz_hierarchy[add_stock]#%'
															</cfloop>
															
															)<cfif (ceiling(get_hierarchies.recordcount/row_block))-1 neq page_stock> OR</cfif>													
													</cfloop>											
											)
						  </cfif>
					  )
				  )
				  OR
				  <!--- Bireysel üye ise --->
				  (
					SPR.SERVICE_CONSUMER_ID IS NOT NULL AND
					(
						SPR.SERVICE_CONSUMER_ID IN (
											SELECT
												C.CONSUMER_ID
											FROM
												#dsn_alias#.SALES_ZONES_ALL_2,
												#dsn_alias#.CONSUMER C
											WHERE
												POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#"> 
												AND C.IMS_CODE_ID = SALES_ZONES_ALL_2.IMS_ID
										 )
						<!--- Satis bolgeleri ekibinde veya Satis bolgesinde yonetici ise kendisi ve altindaki IMS ler--->			
						<cfif get_hierarchies.recordcount>
							OR SPR.SERVICE_CONSUMER_ID IN (
												SELECT
													C.CONSUMER_ID
												FROM
													#dsn_alias#.SALES_ZONES_ALL_1,
													#dsn_alias#.CONSUMER C
												WHERE
													C.IMS_CODE_ID = SALES_ZONES_ALL_1.IMS_ID AND									
													<cfloop index="page_stock" from="0" to="#(ceiling(get_hierarchies.recordcount/row_block))-1#">
														<cfset start_row=(page_stock*row_block)+1>	
														<cfset end_row=start_row+(row_block-1)>
														<cfif (end_row) gte get_hierarchies.recordcount>
															<cfset end_row=get_hierarchies.recordcount>
														</cfif>
															(
															<cfloop index="add_stock" from="#start_row#" to="#end_row#">
																<cfif (add_stock mod row_block) neq 1> OR</cfif> SZ_HIERARCHY+'.' LIKE '#get_hierarchies.sz_hierarchy[add_stock]#%'
															</cfloop>
															
															)<cfif (ceiling(get_hierarchies.recordcount/row_block))-1 neq page_stock> OR</cfif>													
													</cfloop>											
											)
						  </cfif>
					  )
				  )
			 )
		</cfif>
		GROUP BY 
		SPR.RETURN_ID,
		SPR.SERVICE_PARTNER_ID,
		SPR.SERVICE_COMPANY_ID,
		SPR.SERVICE_CONSUMER_ID,
		SPR.SERVICE_EMPLOYEE_ID,
		SPR.RECORD_DATE,
        SPR.UPDATE_DATE,
		SPR.INVOICE_ID,
        SPR.PAPER_NO
		<cfif isdefined('attributes.listing_type') and attributes.listing_type eq 2>
			,SPRR.IS_SHIP,
			SPRR.AMOUNT,
			SPRR.RETURN_ROW_ID,
			SPRR.RETURN_ACT_TYPE,
			SPRR.RETURN_TYPE,
			SPRR.RETURN_ACT_TYPE,
			SPRR.RETURN_STAGE,
			SPRR.STOCK_ID,
			SPRR.INVOICE_ROW_ID,
            SPRR.RETURN_PERIOD_ID,
			S.PRODUCT_NAME,
			S.PROPERTY,
			S.PRODUCT_ID
		</cfif>
	ORDER BY
		SPR.RECORD_DATE DESC
</cfquery>
