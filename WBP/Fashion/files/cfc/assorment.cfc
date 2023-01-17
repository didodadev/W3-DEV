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

    <cffunction name="add_assortment" access="public" returntype="any">
        <cfargument name="req_id" type="any">
		<cfargument name="form_company_id" type="any">
		<cfargument name="form_product_id" type="any">
		<cfargument name="form_stock_id" type="any">
		<cfargument name="form_color_id" type="any">
		<cfargument name="form_size_id" type="any">
		<cfargument name="form_len_id" type="any">
		<cfargument name="form_assorment_amount" type="any">
		<cfargument name="form_order_amount" type="any">
		<cfargument name="form_order_id" type="any">
		<cfargument name="form_order_row_id" type="any">
		<cfquery name="query_add_assortment" datasource="#dsn3#" result="add_assortment">
				INSERT INTO [TEXTILE_ASSORTMENT]
					   (
					    REQUEST_ID
					   ,[PRODUCT_ID]
					   ,[STOCK_ID]
					   ,[COLOR_ID]
					   ,[SIZE_ID]
					   ,[LEN_ID]
					   ,[ASSORTMENT_AMOUNT]
					   ,[ORDER_ID]
					   ,[ORDER_ROW_ID]
					   ,[WRK_ROW_ID]
					   ,[ORDER_AMOUNT]
					   )
				 VALUES
					   (
					   <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.req_id#'>,
					    <cfif isdefined("arguments.form_product_id") and len(arguments.form_product_id)><cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.form_product_id#'><cfelse>NULL</cfif>,
					   <cfif isdefined("arguments.form_stock_id") and len(arguments.form_stock_id)><cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.form_stock_id#'><cfelse>NULL</cfif>,
					   <cfif isdefined("arguments.form_color_id") and len(arguments.form_color_id)><cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.form_color_id#'><cfelse>NULL</cfif>,
					   <cfif isdefined("arguments.form_size_id") and len(arguments.form_size_id)><cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.form_size_id#'><cfelse>NULL</cfif>,
					   <cfif isdefined("arguments.form_len_id") and len(arguments.form_len_id)><cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.form_len_id#'><cfelse>NULL</cfif>,
					   <cfif isdefined("arguments.form_assorment_amount") and len(arguments.form_assorment_amount)><cfqueryparam cfsqltype='CF_SQL_FLOAT' value='#form_assorment_amount#'><cfelse>NULL</cfif>,
					   <cfif isdefined("arguments.form_order_id") and len(arguments.form_order_id)><cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.form_order_id#'><cfelse>NULL</cfif>,
					   <cfif isdefined("arguments.form_order_row_id") and len(arguments.form_order_row_id)><cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#form_order_row_id#'><cfelse>NULL</cfif>,
					   <cfif isdefined("arguments.form_wrk_row_id") and len(arguments.form_wrk_row_id)><cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.form_wrk_row_id#'><cfelse>NULL</cfif>,
					   <cfif isdefined("arguments.form_order_amount") and len(arguments.form_order_amount)><cfqueryparam cfsqltype='CF_SQL_FLOAT' value='#arguments.form_order_amount#'><cfelse>NULL</cfif>
					   )

			</cfquery>
      
        <cfreturn add_assortment>
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
		<cfargument name="form_workstation" type="any">
		<cfargument name="form_company_stock" type="any">
		<cfargument name="form_req_type" type="any">
		<cfargument name="form_quantity" type="any">
		<cfargument name="form_price" type="any">
		<cfargument name="form_work_id" type="any">
		<cfargument name="form_wrk_row_id" type="any">
		
		

		
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
					<cfif isdefined("arguments.form_workstation") and len(arguments.form_workstation)>
						WORK_STATION=<cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.form_workstation#'>,
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
					REQ_ID=<cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.req_id#'> 
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
</cfcomponent>