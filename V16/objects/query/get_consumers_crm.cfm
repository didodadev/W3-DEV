<cfquery name="GET_HIERARCHIES" datasource="#DSN#">
	SELECT
		SZ.SZ_HIERARCHY
	FROM
		SALES_ZONES SZ,
		SALES_ZONE_GROUP SZG
	WHERE
		SZG.SZ_ID = SZ.SZ_ID AND
		SZG.POSITION_CODE = #session.ep.position_code#
	UNION
	SELECT
		SZ.SZ_HIERARCHY
	FROM
		SALES_ZONES SZ
	WHERE
		SZ.RESPONSIBLE_POSITION_CODE = #session.ep.position_code#
</cfquery>
<cfset row_block = 500>
<cfif get_hierarchies.recordcount>
	<!--- satis bolgelerine ait yetki varsa (bolge yonetici veya satis grubu) satis bolgelerine hiyerarsi ile bakmali --->
	<cfquery name="GET_SALES_ZONES" datasource="#DSN#">
		SELECT
			SZ_ID,
			SZ_NAME,
			SZ_HIERARCHY
		FROM
			SALES_ZONES
		WHERE
			<cfloop query="get_hierarchies"><cfif get_hierarchies.currentrow gt 1>OR</cfif> SALES_ZONES.SZ_HIERARCHY+'.' LIKE '#get_hierarchies.sz_hierarchy#%'</cfloop>
		ORDER BY
			SZ_HIERARCHY
	</cfquery>
<cfelse>
	<cfset get_sales_zones.recordcount = 0>
</cfif>
<cfquery name="GET_CONSUMER" datasource="#DSN#">
	SELECT
		CONSUMER.CONSUMER_NAME + ' ' + CONSUMER.CONSUMER_SURNAME FULLNAME,
		CONSUMER.CONSUMER_ID,
		CONSUMER.COMPANY,
		CONSUMER.CONSUMER_WORKTELCODE,
		CONSUMER.CONSUMER_WORKTEL,
		CONSUMER.TC_IDENTY_NO,
		CONSUMER.IMS_CODE_ID,
		CONSUMER.WORK_COUNTY_ID,
		CONSUMER.WORK_CITY_ID,
		CONSUMER_CAT.CONSCAT
	FROM
		CONSUMER,
		CONSUMER_CAT
	WHERE
		CONSUMER.CONSUMER_STATUS = <cfqueryparam cfsqltype="cf_sql_smallint" value="#attributes.is_active#"> AND
		<cfif len(attributes.ims_code_id) and len(attributes.ims_code_name)>
			CONSUMER.IMS_CODE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ims_code_id#"> AND
		</cfif>
		<cfif len(attributes.fullname)>
			CONSUMER.CONSUMER_NAME + ' ' + CONSUMER.CONSUMER_SURNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.fullname#%"> AND
		</cfif>
		<cfif len(attributes.pos_code) and len(attributes.pos_code_text)>
			CONSUMER.CONSUMER_ID IN (SELECT CONSUMER_ID FROM WORKGROUP_EMP_PAR WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pos_code#"> AND IS_MASTER = 1 AND OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND CONSUMER_ID IS NOT NULL) AND
		</cfif>
		<cfif len(attributes.conscat)>
			CONSUMER.CONSUMER_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.conscat#"> AND
		</cfif>
		<cfif len(attributes.sales_county)>
			CONSUMER.SALES_COUNTY = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sales_county#"> AND
		</cfif>
		<cfif len(attributes.customer_value)>
			CONSUMER.CUSTOMER_VALUE_ID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.customer_value#"> AND
		</cfif>
		<cfif len(attributes.pro_rows)>
			CONSUMER.CONSUMER_STAGE =  <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pro_rows#"> AND
		</cfif>
		<cfif len(attributes.city)>
			(	CONSUMER.WORK_CITY_ID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.city#"> OR
				CONSUMER.HOME_CITY_ID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.city#">
			) AND
		</cfif>
		<cfif len(attributes.county) and Len(attributes.county_id)>
			(	CONSUMER.WORK_COUNTY_ID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.county_id#"> OR
				CONSUMER.HOME_COUNTY_ID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.county_id#">
			) AND
		</cfif>
		<cfif isdefined('session.ep.our_company_info.sales_zone_followup') and session.ep.our_company_info.sales_zone_followup eq 1>
			<!--- Satis Takimda Ekip Lideri veya Satıs Takiminda Ekipde ise ilgili IMS ler--->
			(
				CONSUMER.IMS_CODE_ID IN (
											SELECT
												IMS_ID
											FROM
												SALES_ZONES_ALL_2
											WHERE
												POSITION_CODE = #session.ep.position_code# 
												AND (CONSUMER_CAT_IDS IS NULL OR (CONSUMER_CAT_IDS IS NOT NULL AND ','+CONSUMER_CAT_IDS+',' LIKE '%,'+CAST(CONSUMER.CONSUMER_CAT_ID AS NVARCHAR)+',%'))
										 )
			<!--- Satis bolgeleri ekibinde veya Satis bolgesinde yonetici ise kendisi ve altindaki IMS ler--->			
			<cfif get_hierarchies.recordcount>
			OR CONSUMER.IMS_CODE_ID IN (
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
			)
			AND 
		</cfif>
		CONSUMER_CAT.CONSCAT_ID = CONSUMER.CONSUMER_CAT_ID
	ORDER BY
		FULLNAME
</cfquery>
