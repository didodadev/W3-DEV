<cfset xml_show_project = isdefined("xml_show_project") ? 1 : 0>
<cfset xml_show_product = isdefined("xml_show_product") ? 1 : 0>
<cfset x_dont_show_file_by_digital_asset_group = (isdefined("x_dont_show_file_by_digital_asset_group") and x_dont_show_file_by_digital_asset_group eq 1) ? 1 : 0>
<cfscript>
    ids = "";
	module = 1;
	for(ind = 1 ; ind lte ListLen(session.ep.user_level,",") ; ind = ind + 1){		
		if (ListGetAt(session.ep.user_level, ind))	ids = ids & "," & module;
		module = module + 1;
	}
	ids = Right(ids,(Len(ids) - 1));
</cfscript>

<!--- Yetkili olduğum tüm şirketlerin dijital varlıklarını çekebilmek için --->
<cfquery name="GET_POSITION_COMPANIES" datasource="#DSN#">
	SELECT 
	DISTINCT
		SP.OUR_COMPANY_ID,
		O.NICK_NAME
	FROM
		EMPLOYEE_POSITIONS EP,
		SETUP_PERIOD SP,
		EMPLOYEE_POSITION_PERIODS EPP,
		OUR_COMPANY O
	WHERE 
		SP.OUR_COMPANY_ID = O.COMP_ID AND
		SP.PERIOD_ID = EPP.PERIOD_ID AND
		EP.POSITION_ID = EPP.POSITION_ID AND
		EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
</cfquery>
<cfset asset_comp_list = valuelist(get_position_companies.our_company_id)> 

<cfquery name="GET_ASSETS" datasource="#DSN#">
WITH CTE1 AS(

	SELECT
		<cfif (session.ep.admin neq 1 and x_dont_show_file_by_digital_asset_group eq 1) or (isdefined('attributes.employee_view') and len(attributes.employee_view)) or (isdefined('attributes.is_extranet') and len(attributes.is_extranet))>
			DISTINCT
		</cfif>
        ASSET.MODULE_NAME,
		ASSET.ASSET_NO AS ASSET_NO,
        ASSET.ASSET_FILE_REAL_NAME,
        ASSET.ACTION_SECTION,
        ASSET.ACTION_ID,
        ASSET.ASSET_ID,
        ASSET.ASSET_NAME,
        ASSET.ASSET_FILE_NAME,
        ASSET.ASSET_FILE_SERVER_ID,
        ASSET.ASSET_FILE_SIZE,
        ASSET.RECORD_EMP,
        ASSET.RECORD_PUB,
        ASSET.RECORD_PAR,
        ASSET.RECORD_DATE AS RECORD_DATE,
        ASSET.UPDATE_DATE,
        ASSET.UPDATE_EMP,
        ASSET.UPDATE_PAR,
        ASSET_CAT.ASSETCAT,
        ASSET_CAT.ASSETCAT_PATH,
        ASSET_DETAIL AS DESCRIPTION,
        ASSET.ASSETCAT_ID,
        ASSET.PROPERTY_ID,
		ASSET.ASSET_STAGE,
        ASSET.IS_ACTIVE,
		ASSET.RELATED_COMPANY_ID,
        ASSET.RELATED_CONSUMER_ID,
        ASSET.RELATED_ASSET_ID,
        ISNULL(ASSET.REVISION_NO,0) REVISION_NO,
		ASSET.EMBEDCODE_URL,
        ASSET.LIVE,
		<cfif isdefined('attributes.process_stage') and len(attributes.process_stage)>
			PROCESS_TYPE_ROWS.STAGE,
		</cfif>
        ASSET.ASSET_FILE_PATH_NAME,
		ASSET.PASSWORD
        <cfif xml_show_project eq 1>
            ,ASSET.PROJECT_MULTI_ID
            ,ASSET.PROJECT_ID
        </cfif>
		<cfif xml_show_product eq 1>
        	,PRODUCT.PRODUCT_NAME
            ,PRODUCT.PRODUCT_CODE
        </cfif>
		,CASE WHEN ASSET.VALIDATE_START_DATE > 0 THEN (
			SELECT TOP 1 A.VALIDATE_START_DATE FROM ASSET A WHERE A.ASSET_NO = ASSET.ASSET_NO ORDER BY A.ASSET_ID ASC
		) ELSE NULL END VALIDITY_DATE
		,CASE WHEN ASSET.REVISION_NO > 0 THEN (
			SELECT TOP 1 A.VALIDATE_START_DATE FROM ASSET A WHERE A.ASSET_NO = ASSET.ASSET_NO ORDER BY A.ASSET_ID DESC
		) ELSE NULL END REVISION_DATE
    FROM 
        ASSET
        <cfif xml_show_product eq 1>
            LEFT JOIN #DSN1_ALIAS#.PRODUCT ON ASSET.PRODUCT_ID = PRODUCT.PRODUCT_ID
        </cfif>
		<cfif isdefined('attributes.process_stage') and len(attributes.process_stage)>
			,PROCESS_TYPE_ROWS
		</cfif>
		<cfif (isdefined('attributes.employee_view') and len(attributes.employee_view)) or (isdefined('attributes.is_extranet') and len(attributes.is_extranet))>
			JOIN ASSET_RELATED ON (ASSET.ASSET_ID = ASSET_RELATED.ASSET_ID) 
			<cfif (isdefined('attributes.is_extranet') and len(attributes.is_extranet))> AND (ASSET_RELATED.COMPANY_CAT_ID IS NOT NULL) </cfif> 
			<cfif (isdefined('attributes.employee_view') and len(attributes.employee_view))> AND ASSET.ASSET_ID IN (SELECT ASSET_ID FROM ASSET_RELATED WHERE ALL_EMPLOYEE = 1) </cfif>
		<cfelseif session.ep.admin neq 1 and x_dont_show_file_by_digital_asset_group eq 1>
			JOIN ASSET_RELATED ON (ASSET.ASSET_ID = ASSET_RELATED.ASSET_ID)
		</cfif>
		<cfif session.ep.admin neq 1 and isdefined("x_show_by_digital_asset_group") and x_show_by_digital_asset_group eq 1>
        JOIN DIGITAL_ASSET_GROUP_PERM DAGP
            ON ASSET.ASSETCAT_ID = DAGP.ASSETCAT_ID 
            AND DAGP.GROUP_ID IN (SELECT GROUP_ID FROM DIGITAL_ASSET_GROUP_PERM WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)  
        </cfif>
		,ASSET_CAT
    WHERE
		<cfif isdefined("attributes.our_company_id") and len(attributes.our_company_id)>
			ASSET.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.our_company_id#"> AND
		<cfelseif listlen(asset_comp_list)>
			ASSET.COMPANY_ID IN (#asset_comp_list#) AND
		<cfelse>
			ASSET.COMPANY_ID IS NULL AND
		</cfif>
			ASSET.ASSETCAT_ID = ASSET_CAT.ASSETCAT_ID AND
			ASSET.MODULE_ID IN (#ids#) 
			<cfif isdefined("attributes.fuseaction") and attributes.fuseaction eq 'asset.tv'>
				AND ASSET.MODULE_NAME IN ('content','training','asset','product')
			</cfif>
		<cfif isDefined("attributes.keyword") and len(attributes.keyword)>
			AND (
					ASSET.ASSET_NAME LIKE <cfqueryparam cfsqltype="cf_sql_nvarchar" value="%#attributes.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI OR
					ASSET.ASSET_DESCRIPTION LIKE <cfqueryparam cfsqltype="cf_sql_nvarchar" value="%#attributes.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI OR
					ASSET.ASSET_DETAIL LIKE <cfqueryparam cfsqltype="cf_sql_nvarchar" value="%#attributes.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI OR
					ASSET.ASSET_NO LIKE <cfqueryparam cfsqltype="cf_sql_nvarchar" value="%#attributes.keyword#%">
				)
		</cfif>
		<cfif isDefined("attributes.format") and len(attributes.format) and attributes.format neq "video">
			<cfif attributes.format eq ".gif">
				AND (ASSET.ASSET_FILE_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%.gif%"> OR ASSET.ASSET_FILE_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%.GIF%">) 
			<cfelse>
				AND ASSET.ASSET_FILE_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.format#%">
			</cfif>
			
		</cfif>
		<cfif isDefined("ext_formats") and len(ext_formats)>
			AND 
			(
				<cfloop from="1" to="4" index="i">
					ASSET.ASSET_FILE_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#listgetat(ext_formats,i,',')#"> 
					<cfif i neq 4>
						OR
					</cfif>
				</cfloop>
			)
		</cfif>
		<cfif isDefined("attributes.assetcat_name") and len(attributes.assetcat_name) and isDefined("attributes.assetcat_id") and len(attributes.assetcat_id)>
			AND ASSET.ASSETCAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.assetcat_id#">
		</cfif>
		<cfif isDefined("attributes.property_id") and len(attributes.property_id)>
			AND ASSET.PROPERTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.property_id#">
		</cfif>
		<cfif isdefined("attributes.record_date1") and len(attributes.record_date1)>
			AND ASSET.RECORD_DATE > #createodbcdatetime(attributes.record_date1)#
		</cfif>
		<cfif isdefined("attributes.record_date2") and len(attributes.record_date2)>
			AND ASSET.RECORD_DATE < #createodbcdatetime(dateadd("d",1,attributes.record_date2))#
		</cfif>
		<cfif isdefined("attributes.record_member") and len(attributes.record_member) and len(attributes.record_emp_id)>
			AND ASSET.RECORD_EMP =  <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.record_emp_id#">
		<cfelseif isdefined("attributes.record_member") and len(attributes.record_member) and len(attributes.record_par_id)>
			AND ASSET.RECORD_PAR =  <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.record_par_id#">
		</cfif>
		<cfif isdefined("attributes.site_domain") and len(attributes.site_domain)>
			AND ASSET.ASSET_ID IN (SELECT ASSET_ID FROM ASSET_SITE_DOMAIN WHERE SITE_DOMAIN = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.site_domain#">)
		</cfif>
		<cfif (isdefined("attributes.is_view") and len(attributes.is_view)) or (isdefined("attributes.is_internet") and len(attributes.is_internet))>
			AND ASSET.IS_INTERNET = 1
		</cfif>
		<cfif isdefined("attributes.process_stage")>
        	<cfif len(attributes.process_stage)>
                AND PROCESS_TYPE_ROWS.PROCESS_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_stage#">
                AND ASSET.ASSET_STAGE = PROCESS_TYPE_ROWS.PROCESS_ROW_ID
                AND ASSET.ASSET_STAGE IS NOT NULL
            </cfif>
		</cfif>
		<cfif isdefined("attributes.project_id") and len(attributes.project_id) and len(attributes.project_head)>
			AND (ASSET.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#"> OR ASSET.PROJECT_MULTI_ID LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#attributes.project_id#,%">)
		</cfif>
		<cfif isdefined("attributes.product_id") and len(attributes.product_id) and len(attributes.product_name)>
			AND
			(
			( ASSET.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_id#">)
			 or 
			(ASSET.ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_id#"> AND ASSET.ACTION_SECTION = 'PRODUCT_ID')
			)
		</cfif>
		<cfif isdefined("attributes.is_active")>
			AND (ASSET.IS_ACTIVE = 1 OR ASSET.IS_ACTIVE IS NULL)
		<cfelse> 
			AND (ASSET.IS_ACTIVE = 0 OR ASSET.IS_ACTIVE IS NULL)
		</cfif>
		<cfif isdefined("attributes.is_special") and len(attributes.is_special)>
        AND
        ASSET.IS_SPECIAL = 1 AND (ASSET.RECORD_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">  OR  ASSET.UPDATE_EMP =  <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">)
		</cfif>
		<cfif isdefined("attributes.featured") and len(attributes.featured)>
        AND ASSET.FEATURED = 1
		</cfif>
		<cfif isdefined("attributes.format") and len(attributes.format) and attributes.format eq "video">
			AND ASSET.EMBEDCODE_URL IS NOT NULL
		<cfelseif isdefined("attributes.fuseaction") and attributes.fuseaction eq 'asset.tv'>
        	AND( (ASSET.EMBEDCODE_URL LIKE '%loom.com%' OR ASSET.EMBEDCODE_URL LIKE '%youtube.com%' OR ASSET.EMBEDCODE_URL LIKE '%youtu.be%' OR ASSET.EMBEDCODE_URL LIKE '%vimeo.com%') OR ASSET.ASSET_FILE_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value='%.MP4%'>)
		</cfif>
        AND (ASSET.IS_LIVE = 0 OR ASSET.IS_LIVE IS NULL)
		<cfif isdefined("attributes.is_revision") and len(attributes.is_revision) and attributes.is_revision eq 1>
			AND (ASSET.REVISION_NO = 0 OR ASSET.REVISION_NO IS NULL ) 
		</cfif>
),
CTE2 AS (
			SELECT
				CTE1.*,
				ROW_NUMBER() OVER (	 
					<cfif isDefined('attributes.sort_type') and attributes.sort_type eq 1>
            			ORDER BY
                			RECORD_DATE DESC						
					<cfelseif  isDefined('attributes.sort_type') and attributes.sort_type eq 2>
						ORDER BY
							ASSET_NO ASC
					<cfelse>
						ORDER BY
							RECORD_DATE DESC						    							    
					</cfif> 
				) AS RowNum,
				(SELECT COUNT(*) FROM CTE1) AS QUERY_COUNT
			FROM
				CTE1
		)
		SELECT
			CTE2.*
		FROM
			CTE2
		WHERE
			RowNum BETWEEN #attributes.startrow# and #attributes.startrow#+(#attributes.maxrows#-1)

</cfquery>