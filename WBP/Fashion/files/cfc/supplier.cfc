<cfcomponent>
    <cfset dsn = application.systemParam.systemParam().dsn>
	<cfset dsn3 = "#dsn#_#session.ep.company_id#">
    <cffunction name="list_supplier" access="public" returntype="query">
        <cfargument name="req_id" type="any">
		 <cfargument name="req_type" type="any">
		<cfquery name="get_supplier" datasource="#dsn#_#session.ep.company_id#">
			SELECT * FROM TEXTILE_SR_SUPLIERS WHERE REQ_ID = #arguments.req_id# and ISNULL(REQUEST_TYPE,0)=#arguments.req_type#
		</cfquery>
		<cfreturn get_supplier>
    </cffunction>

	
    <cffunction name="add_supplier" access="public" returntype="any">
        <cfargument name="req_id" type="any">
		<cfargument name="form_company_id" type="any">
		<cfargument name="form_stock_id" type="any">
        <cfargument name="form_product_id" type="any">
        <cfargument name="form_product" type="any">
		<cfargument name="form_unit_id" type="any">
        <cfargument name="form_unit" type="any">
		<cfargument name="form_product_catid" type="any">
			<cfargument name="form_product_cat" type="any">
		<cfargument name="form_money" type="any">
		<cfargument name="form_operation_id" type="any">
		<cfargument name="form_company_stock" type="any">
		<cfargument name="form_req_type" type="any">
		<cfargument name="form_quantity" type="any">
		<cfargument name="form_price" type="any">
			<cfargument name="form_en" type="any">
			<cfargument name="form_workrequest" type="any">
		<cfargument name="form_revize_quantity" type="any">
		<cfargument name="form_revize_price" type="any">
		<cfargument name="form_work_id" type="any">
		<cfargument name="form_wrk_row_id" type="any">
		<cfargument name="form_image" type="any">
		<cfargument name="form_row_detail" type="any">
		<cfargument name="form_row_status" type="any">
		<cfargument name="form_row_revize" type="any">
		<cfargument name="form_row_variant" type="any">
		
        <cflock name="#createUUID()#" timeout="20">
        <cftransaction>
		<cfquery name="query_add_supplier" datasource="#dsn3#" result="add_supplier">
				INSERT INTO
					TEXTILE_SR_SUPLIERS
					(
						REQ_ID,
						COMPANY_ID,
							PRODUCT_CATID,
						<cfif isdefined("arguments.form_product_id")>
							PRODUCT_ID,
							STOCK_ID,
							PRODUCT_NAME,
						</cfif>
						MONEY_TYPE,
						OPERATION_ID,
						REQUEST_COMPANY_STOCK,
						REQUEST_TYPE,
						QUANTITY,
						PRICE,
						WORK_ID,
						WRK_ROW_ID,
						UNIT_ID,
						UNIT,
						IMAGE_PATH,
						ROW_DETAIL,
						EN,
						REVIZE_QUANTITY,
						REVIZE_PRICE,
						IS_STATUS,
						IS_REVISION,
						VARIANT
					)
					VALUES
					(
						<cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.req_id#'>,
						<cfif IsDefined("arguments.form_company_id") and  len(arguments.form_company_id)><cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.form_company_id#'><cfelse>NULL</cfif>,
						<cfif IsDefined("arguments.form_product_catid") and  len(arguments.form_product_catid)><cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.form_product_catid#'><cfelse>NULL</cfif>,
					<cfif isdefined("arguments.form_product_id")>
						<cfif len(form_product_id) and len(form_product)><cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.form_product_id#'><cfelse>NULL</cfif>,
						<cfif len(form_stock_id) and len(form_product)><cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.form_stock_id#'><cfelse>NULL</cfif>,
						<cfif len(form_product)><cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.form_product#'><cfelse>NULL</cfif>,
					</cfif>
						<cfif isdefined("arguments.form_money") and len(arguments.form_money)>
							<cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.form_money#'>
						<cfelse>
							NULL
						</cfif>,
						<cfif isdefined("arguments.form_operation_id") and len(arguments.form_operation_id)><cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.form_operation_id#'><cfelse>NULL</cfif>,
						<cfif isdefined("arguments.form_company_stock") and len(arguments.form_company_stock)><cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.form_company_stock#'><cfelse>NULL</cfif>,
						<cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.form_req_type#'>,
						<cfif isdefined("arguments.form_quantity") and len(arguments.form_quantity)><cfqueryparam cfsqltype='CF_SQL_FLOAT' value='#arguments.form_quantity#'><cfelse>NULL</cfif>,
						<cfif isdefined("arguments.form_price") and len(arguments.form_price)><cfqueryparam cfsqltype='CF_SQL_FLOAT' value='#arguments.form_price#'><cfelse>NULL</cfif>,
						<cfif len(form_work_id)><cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.form_work_id#'><cfelse>NULL</cfif>,
						<cfif len(form_wrk_row_id)><cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.form_wrk_row_id#'><cfelse>NULL</cfif>,
						<cfif isdefined("arguments.form_unit_id") and len(arguments.form_unit_id)><cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.form_unit_id#'><cfelse>NULL</cfif>,
						<cfif isdefined("arguments.form_unit") and len(arguments.form_unit)><cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.form_unit#'><cfelse>NULL</cfif>,
						<cfif isdefined("arguments.form_image") and len(arguments.form_image)><cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.form_image#'><cfelse>NULL</cfif>,
						<cfif isdefined("arguments.form_row_detail") and len(arguments.form_row_detail)><cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.form_row_detail#'><cfelse>NULL</cfif>,
						<cfif isdefined("arguments.form_en") and len(arguments.form_en)><cfqueryparam cfsqltype='CF_SQL_FLOAT' value='#arguments.form_en#'><cfelse>NULL</cfif>,
						<cfif isdefined("arguments.form_revize_quantity") and len(arguments.form_revize_quantity)><cfqueryparam cfsqltype='CF_SQL_FLOAT' value='#arguments.form_revize_quantity#'><cfelse>NULL</cfif>,
						<cfif isdefined("arguments.form_revize_price") and len(arguments.form_revize_price)><cfqueryparam cfsqltype='CF_SQL_FLOAT' value='#arguments.form_revize_price#'><cfelse>NULL</cfif>,
						<cfif len(arguments.form_row_status)>#arguments.form_row_status#<cfelse>0</cfif>,
						<cfif len(arguments.form_row_revize)>#arguments.form_row_revize#<cfelse>0</cfif>,
						<cfif len(arguments.form_row_variant)>#arguments.form_row_variant#<cfelse>NULL</cfif>
					)
			</cfquery>
        </cftransaction>
        </cflock>
        <cfreturn add_supplier>
    </cffunction>
	<cffunction name="upd_supplier" access="public" returntype="any">
		  <cfargument name="form_rowid" type="any">
        <cfargument name="req_id" type="any">
		<cfargument name="form_company_id" type="any">
		<cfargument name="form_stock_id" type="any">
        <cfargument name="form_product_id" type="any">
        <cfargument name="form_product" type="any">
			<cfargument name="form_unit_id" type="any">
        <cfargument name="form_unit" type="any">
		<cfargument name="form_product_catid" type="any">
		<cfargument name="form_product_cat" type="any">
		<cfargument name="form_money" type="any">
		<cfargument name="form_operation_id" type="any">
		<cfargument name="form_company_stock" type="any">
		<cfargument name="form_req_type" type="any">
		<cfargument name="form_quantity" type="any">
		<cfargument name="form_price" type="any">
		<cfargument name="form_en" type="any">
		<cfargument name="form_workrequest" type="any">
		<cfargument name="form_revize_quantity" type="any">
		<cfargument name="form_revize_price" type="any">
		<cfargument name="form_work_id" type="any">
		<cfargument name="form_wrk_row_id" type="any">
		<cfargument name="form_image" type="any">
			<cfargument name="form_row_detail" type="any">
		<cfargument name="form_row_status" type="any" default="">
		<cfargument name="form_row_revize" type="any" default="">
		<cfargument name="form_row_variant" type="any">
		
        <cflock name="#createUUID()#" timeout="20">
        <cftransaction>
		<cftry>
		<cfquery name="query_upd_supplier" datasource="#dsn3#" result="upd_supplier">
				UPDATE
					TEXTILE_SR_SUPLIERS
					
				SET	
					<cfif isdefined("arguments.form_company_id") and len(arguments.form_company_id)>
						COMPANY_ID=<cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.form_company_id#'>,
					</cfif>
					<cfif isdefined("arguments.form_product_catid") and len(arguments.form_product_catid)>
						PRODUCT_CATID=<cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.form_product_catid#'>,
					</cfif>
						<cfif isdefined("arguments.form_product_id") and len(arguments.form_product_id)>
							PRODUCT_ID=<cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.form_product_id#'>,
							STOCK_ID=<cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.form_stock_id#'>,
							PRODUCT_NAME=<cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.form_product#'>,
						</cfif>
					<cfif isdefined("arguments.form_money") and len(arguments.form_money)>
						MONEY_TYPE=<cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.form_money#'>,
					</cfif>
					<cfif isdefined("arguments.form_operation_id") and len(arguments.form_operation_id)>
						OPERATION_ID=<cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.form_operation_id#'>,
					</cfif>
					<cfif isdefined("arguments.form_company_stock") and len(arguments.form_company_stock)>
						REQUEST_COMPANY_STOCK=<cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.form_company_stock#'>,
					</cfif>
						REQUEST_TYPE=<cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.form_req_type#'>,
					<cfif isdefined("arguments.form_quantity") and len(arguments.form_quantity)>
						QUANTITY=<cfqueryparam cfsqltype='CF_SQL_FLOAT' value='#arguments.form_quantity#'>,
					</cfif>
					<cfif isdefined("arguments.form_price") and len(arguments.form_price)>
						PRICE=<cfqueryparam cfsqltype='CF_SQL_FLOAT' value='#arguments.form_price#'>,
					</cfif>
					<cfif isdefined("arguments.form_unit") and len(arguments.form_unit)>	
						UNIT=<cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.form_unit#'>,
					</cfif>
					<cfif isdefined("arguments.form_unit_id") and len(arguments.form_unit_id)>	
						UNIT_ID=<cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.form_unit_id#'>,
					</cfif>
					<cfif isdefined("arguments.form_image") and len(arguments.form_image)>
						IMAGE_PATH=<cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.form_image#'>,
					</cfif>
					<cfif isdefined("arguments.form_row_detail") and len(arguments.form_row_detail)>
						ROW_DETAIL=<cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.form_row_detail#'>,
					</cfif>
					<cfif isdefined("arguments.form_en") and len(arguments.form_en)>
							EN=<cfqueryparam cfsqltype='CF_SQL_FLOAT' value='#arguments.form_en#'>,
					</cfif>
					<cfif isdefined("arguments.form_revize_quantity") and len(arguments.form_revize_quantity)>
						REVIZE_QUANTITY=<cfqueryparam cfsqltype='CF_SQL_FLOAT' value='#arguments.form_revize_quantity#'>,
					</cfif>
					<cfif isdefined("arguments.form_revize_price") and len(arguments.form_revize_price)>
						REVIZE_PRICE=<cfqueryparam cfsqltype='CF_SQL_FLOAT' value='#arguments.form_revize_price#'>,
					</cfif>
					<cfif isDefined("arguments.form_row_variant") and len(arguments.form_row_variant)>
						VARIANT = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.form_row_variant#'>,
					<cfelse>
						VARIANT = NULL,
					</cfif>
					REQ_ID=<cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.req_id#'>,
					IS_STATUS=<cfif len(arguments.form_row_status)>#arguments.form_row_status#<cfelse>0</cfif>,
					IS_REVISION=<cfif len(arguments.form_row_revize)>#arguments.form_row_revize#<cfelse>0</cfif>
					WHERE	
						REQ_ID=<cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.req_id#'> 
						and ID=<cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.form_rowid#'>
						
							
			</cfquery>
			
			<cfcatch>
				<cfdump var="#arguments#">
					<cfabort>
			</cfcatch>
			</cftry>
        </cftransaction>
        </cflock>
        <cfreturn upd_supplier>
	</cffunction>
	<cffunction name="delrow_supplier" access="public" returntype="any">
		<cfargument name="form_rowid" type="any">
        <cfargument name="req_id" type="any">
		<cfquery name="del_suplier" datasource="#dsn3#" result="del_supplier">
				DELETE
					TEXTILE_SR_SUPLIERS	
				WHERE
						REQ_ID=<cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.req_id#'> 
						AND ID=<cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.form_rowid#'>
		</cfquery>
		<cfreturn del_supplier>
	</cffunction>
	<cffunction name="copy_supplier" access="public" returntype="any">
		<cfargument name="old_req_id" type="any">
		<cfargument name="new_req_id" type="any">
		<cfquery name="add_suplier" datasource="#dsn3#" result="add_supplier">
				INSERT INTO
					TEXTILE_SR_SUPLIERS	
					(
						[REQ_ID]
					   ,[COMPANY_ID]
					   ,[BRAND_ID]
					   ,[PRODUCT_CATID]
					   ,[PRODUCT_ID]
					   ,[STOCK_ID]
					   ,[PRODUCT_NAME]
					   ,[UNIT_ID]
					   ,[UNIT]
					   ,[ESTIMATED_INCOME]
					   ,[ESTIMATED_COST]
					   ,[ESTIMATED_PROFIT]
					   ,[MONEY_TYPE]
					   ,[OPERATION_ID]
					   ,[REQUEST_COMPANY_STOCK]
					   ,[REQUEST_TYPE]
					   ,[QUANTITY]
					   ,[PRICE]
					   ,[WRK_ROW_ID]
					   ,[WORK_ID]
					   ,[IMAGE_PATH]
					   ,[ROW_DETAIL]
					   ,EN
					   ,REVIZE_QUANTITY
					   ,REVIZE_PRICE
					   ,IS_STATUS
						,IS_REVISION
						,VARIANT
					)
				select
						#arguments.new_req_id#
					   ,[COMPANY_ID]
					   ,[BRAND_ID]
					   ,[PRODUCT_CATID]
					   ,[PRODUCT_ID]
					   ,[STOCK_ID]
					   ,[PRODUCT_NAME]
					   ,[UNIT_ID]
					   ,[UNIT]
					   ,[ESTIMATED_INCOME]
					   ,[ESTIMATED_COST]
					   ,[ESTIMATED_PROFIT]
					   ,[MONEY_TYPE]
					   ,[OPERATION_ID]
					   ,[REQUEST_COMPANY_STOCK]
					   ,[REQUEST_TYPE]
					   ,[QUANTITY]
					   ,[PRICE]
					   ,[WRK_ROW_ID]
					   ,[WORK_ID]
					   ,[IMAGE_PATH]
					   ,[ROW_DETAIL]
					   ,EN
					   ,REVIZE_QUANTITY
					   ,REVIZE_PRICE
					   ,IS_STATUS
					   ,IS_REVISION
					   ,VARIANT
				from
				TEXTILE_SR_SUPLIERS
				WHERE
						IS_STATUS = 1 AND
						REQ_ID=<cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.old_req_id#'> 
		</cfquery>

		<cfreturn add_supplier>
	</cffunction>	
	<cffunction name="copy_supplier_empty" access="public" returntype="any">
		<cfargument name="old_req_id" type="any">
		<cfargument name="new_req_id" type="any">
		<cfquery name="add_suplier" datasource="#dsn3#" result="add_supplier">
			INSERT INTO
				TEXTILE_SR_SUPLIERS	
				(
					[REQ_ID]
				   ,[COMPANY_ID]
				   ,[BRAND_ID]
				   ,[PRODUCT_CATID]
				   ,[PRODUCT_ID]
				   ,[STOCK_ID]
				   ,[PRODUCT_NAME]
				   ,[UNIT_ID]
				   ,[UNIT]
				   ,[ESTIMATED_INCOME]
				   ,[ESTIMATED_COST]
				   ,[ESTIMATED_PROFIT]
				   ,[MONEY_TYPE]
				   ,[OPERATION_ID]
				   ,[REQUEST_COMPANY_STOCK]
				   ,[REQUEST_TYPE]
				   ,[QUANTITY]
				   ,[PRICE]
				   ,[WRK_ROW_ID]
				   ,[WORK_ID]
				   ,[IMAGE_PATH]
				   ,[ROW_DETAIL]
				   ,EN
				   ,REVIZE_QUANTITY
				   ,REVIZE_PRICE
				   ,IS_STATUS
					,IS_REVISION
				
				)
			select
					#arguments.new_req_id#
				   ,NULL
				   ,NULL
				   ,[PRODUCT_CATID]
				   ,NULL
				   ,NULL
				   ,NULL
				   ,NULL
				   ,NULL
				   ,NULL
				   ,NULL
				   ,NULL
				   ,[MONEY_TYPE]
				   ,[OPERATION_ID]
				   ,[REQUEST_COMPANY_STOCK]
				   ,[REQUEST_TYPE]
				   ,0
				   ,0
				   ,NULL
				   ,NULL
				   ,NULL
				   ,NULL
				   ,NULL
				   ,NULL
				   ,NULL
				   ,1
				   ,0
			from
			TEXTILE_SR_SUPLIERS
			WHERE
					IS_STATUS = 1 AND
					REQ_ID=<cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.old_req_id#'> 
	</cfquery>
		<cfreturn add_supplier>
	</cffunction>
	<cffunction name="copy_process" access="public" returntype="any">
		<cfargument name="old_req_id" type="any">
		<cfargument name="new_req_id" type="any">
		<cfquery name="add_process_" datasource="#dsn3#" result="add_process">
				INSERT INTO TEXTILE_SR_PROCESS
					   ([REQUEST_ID]
					   ,[PROCESS]
					   ,[PROCESS_ID]
					   ,[DETAIL]
					   ,[IMAGE_PATH]
					   ,[PRICE]
					   ,[MONEY]
					   ,[PRODUCT_ID]
					   ,[STOCK_ID]
					   ,[PRODUCT_CATID]
					   ,[IS_ORJINAL]
					   ,[REVIZE_PRICE]
					   ,[IS_STATUS]
					   ,[IS_REVISION]
					   ,[OPERATION_ID])
				select
						#arguments.new_req_id#
					   ,[PROCESS]
					   ,[PROCESS_ID]
					   ,[DETAIL]
					   ,[IMAGE_PATH]
					   ,[PRICE]
					   ,[MONEY]
					   ,[PRODUCT_ID]
					   ,[STOCK_ID]
					   ,[PRODUCT_CATID]
					   ,[IS_ORJINAL]
					   ,[REVIZE_PRICE]
					   ,[IS_STATUS]
					   ,[IS_REVISION]
					   ,[OPERATION_ID]
					from
					TEXTILE_SR_PROCESS
					WHERE
						REQUEST_ID=<cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.old_req_id#'> 
		</cfquery>
			<cfreturn add_process>
	</cffunction>
	<cffunction name="copy_process_empty" access="public" returntype="any">
		<cfargument name="old_req_id" type="any">
		<cfargument name="new_req_id" type="any">
		<cfquery name="add_process_" datasource="#dsn3#" result="add_process">
				INSERT INTO TEXTILE_SR_PROCESS
					   ([REQUEST_ID]
					   ,[PROCESS]
					   ,[PROCESS_ID]
					   ,[DETAIL]
					   ,[IMAGE_PATH]
					   ,[PRICE]
					   ,[MONEY]
					   ,[PRODUCT_ID]
					   ,[STOCK_ID]
					   ,[PRODUCT_CATID]
					   ,[IS_ORJINAL]
					   ,[REVIZE_PRICE]
					   ,[IS_STATUS]
					   ,[IS_REVISION]
					   ,[OPERATION_ID])
				select
						#arguments.new_req_id#
					   ,NULL
					   ,NULL
					   ,NULL
					   ,NULL
					   ,0
					   ,NULL
					   ,[PRODUCT_ID]
					   ,[STOCK_ID]
					   ,[PRODUCT_CATID]
					   ,0
					   ,NULL
					   ,1
					   ,0
					   ,[OPERATION_ID]
					from
					TEXTILE_SR_PROCESS
					WHERE
						REQUEST_ID=<cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.old_req_id#'> 
		</cfquery>
		<cfreturn add_process>
	</cffunction>
	<cffunction name="copy_asset" access="public" returntype="any">
		<cfargument name="old_req_id" type="any">
		<cfargument name="new_req_id" type="any">
		<cfquery name="add_asset_" datasource="#dsn3#" result="add_asset">
				INSERT INTO 
					#dsn#.ASSET
					(
						PERIOD_ID,
						ASSET_NO,
						MODULE_NAME,
						MODULE_ID,
						ACTION_SECTION,
						PROJECT_ID,
						PROJECT_MULTI_ID,
						ACTION_ID,
						ACTION_VALUE,
						COMPANY_ID,
						ASSETCAT_ID,
						ASSET_FILE_NAME,
						ASSET_FILE_REAL_NAME,
                        ASSET_FILE_PATH_NAME,
						ASSET_FILE_SIZE,
						ASSET_FILE_SERVER_ID,
						ASSET_NAME,
						ASSET_DETAIL,
						IS_INTERNET,
						RECORD_DATE,
						RECORD_EMP,
						RECORD_PUB,
						RECORD_PAR,               
						RECORD_IP,
						PROPERTY_ID,
						ASSET_DESCRIPTION,
						IS_LIVE,
						FEATURED,
						IS_SPECIAL,
						SERVER_NAME,
						IS_IMAGE
						,ASSET_STAGE
						,LIVE
						,IS_DPL
						,IS_ACTIVE
						,PRODUCT_ID
						,REVISION_NO
                        ,VALIDATE_START_DATE
                        ,VALIDATE_FINISH_DATE
					)
				select
						PERIOD_ID,
						ASSET_NO,
						MODULE_NAME,
						MODULE_ID,
						ACTION_SECTION,
						PROJECT_ID,
						PROJECT_MULTI_ID,
						#arguments.new_req_id#,
						ACTION_VALUE,
						COMPANY_ID,
						ASSETCAT_ID,
						ASSET_FILE_NAME,
						ASSET_FILE_REAL_NAME,
                            ASSET_FILE_PATH_NAME,
						ASSET_FILE_SIZE,
						ASSET_FILE_SERVER_ID,
						ASSET_NAME,
						ASSET_DETAIL,
						IS_INTERNET,
						RECORD_DATE,
						RECORD_EMP,
						RECORD_PUB,
						RECORD_PAR,               
						RECORD_IP,
						PROPERTY_ID,
						ASSET_DESCRIPTION,
						IS_LIVE,
						FEATURED,
						IS_SPECIAL,
						SERVER_NAME,
						IS_IMAGE
						,ASSET_STAGE
						,LIVE
						,IS_DPL
						,IS_ACTIVE
						,PRODUCT_ID
						,REVISION_NO
                        ,VALIDATE_START_DATE
                        ,VALIDATE_FINISH_DATE
					from
						#dsn#.ASSET
					WHERE
						ACTION_SECTION='REQ_ID' and ACTION_ID=<cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.old_req_id#'> 
		</cfquery>
			<cfreturn add_asset>
	 </cffunction>	 
</cfcomponent>