<cfinclude template="../query/get_consumer_cat.cfm">
<cfset consumer_cat_list = valuelist(get_consumer_cat.conscat_id,',')>
<cfquery name="get_ourcmp_info" datasource="#dsn#">
	SELECT IS_STORE_FOLLOWUP FROM OUR_COMPANY_INFO WHERE COMP_ID = #session.ep.company_id#
</cfquery>
<cfif session.ep.our_company_info.sales_zone_followup eq 1>
	<cfquery name="GET_HIERARCHIES" datasource="#DSN#">
		SELECT
			DISTINCT
			SZ_HIERARCHY
		FROM
			SALES_ZONES_ALL_1
		WHERE
			POSITION_CODE = #session.ep.position_code#
	</cfquery>
	<cfset row_block = 500>
</cfif>
<cfquery name="GET_CONSUMER" datasource="#DSN#">
	SELECT
		C.*,
        '' AS UPDATE_CONS,
		C.WANT_CALL
		<cfif session.ep.isBranchAuthorization and get_ourcmp_info.is_store_followup eq 1>
			,COMPANY_BRANCH_RELATED.*
		</cfif>
	FROM
		CONSUMER C
	<cfif session.ep.isBranchAuthorization and get_ourcmp_info.is_store_followup eq 1>
		,COMPANY_BRANCH_RELATED
	</cfif>
	WHERE
		<cfif isdefined("url.cid")>
			C.CONSUMER_ID = #url.cid#	
		<cfelseif isdefined("attributes.consumer_id")>
			C.CONSUMER_ID = #attributes.consumer_id#
		</cfif>
		<cfif session.ep.isBranchAuthorization and get_ourcmp_info.is_store_followup eq 1>
			AND COMPANY_BRANCH_RELATED.CONSUMER_ID = C.CONSUMER_ID
			AND COMPANY_BRANCH_RELATED.DEPOT_DAK IS NULL
			AND COMPANY_BRANCH_RELATED.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
		</cfif>
		<cfif len(consumer_cat_list)>
			AND CONSUMER_CAT_ID IN (#consumer_cat_list#)
		</cfif>
		<cfif session.ep.our_company_info.sales_zone_followup eq 1>
			<!--- Satis Takimda Ekip Lideri veya Satıs Takiminda Ekipde ise ilgili IMS ler--->
			AND 
			(
				C.IMS_CODE_ID IN (
											SELECT
												IMS_ID
											FROM
												SALES_ZONES_ALL_2
											WHERE
												POSITION_CODE = #session.ep.position_code# 
												AND (CONSUMER_CAT_IDS IS NULL OR (CONSUMER_CAT_IDS IS NOT NULL AND ','+CONSUMER_CAT_IDS+',' LIKE '%,'+CAST(C.CONSUMER_CAT_ID AS NVARCHAR)+',%'))
										)
			<!--- Satis bolgeleri ekibinde veya Satis bolgesinde yonetici ise kendisi ve altindaki IMS ler--->			
			<cfif get_hierarchies.recordcount>
			OR C.IMS_CODE_ID IN (
											SELECT
												IMS_ID
											FROM
												SALES_ZONES_ALL_1
											WHERE											
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
			  <cfif isdefined("attributes.is_zone_info")>OR C.IMS_CODE_ID IS NULL</cfif>					
			)
		</cfif>        
</cfquery>
