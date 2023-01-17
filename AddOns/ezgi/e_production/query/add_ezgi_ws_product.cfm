<cfif (isdefined('attributes.stock_id0') or isdefined('attributes.operation_type_id0')) and isdefined('attributes.is_add')>
	<cfquery name="add_product" datasource="#dsn3#">
		INSERT INTO
			WORKSTATIONS_PRODUCTS
			(
				WS_ID,
				STOCK_ID,
                OPERATION_TYPE_ID,
                MAIN_STOCK_ID,
				CAPACITY,
				PRODUCTION_TIME,
				PRODUCTION_TIME_TYPE,
				PRODUCTION_TYPE,
				MIN_PRODUCT_AMOUNT,
				SETUP_TIME,
				ASSET_ID
			)
			VALUES
			(
				#attributes.STATION_ID0#,
				<cfif isdefined('attributes.stock_id0') and len(attributes.stock_id0)>#attributes.stock_id0#<cfelse>NULL</cfif>,
				<cfif isdefined('attributes.operation_type_id0') and len(attributes.operation_type_id0)>#attributes.operation_type_id0#<cfelse>NULL</cfif>,
                <cfif isdefined('attributes.main_stock_id') and len(attributes.main_stock_id)>#attributes.main_stock_id#<cfelseif isdefined('attributes.stock_id0') and len(attributes.stock_id0)>#attributes.stock_id0#<cfelse>NULL</cfif>,
				#filterNum(attributes.CAPACITY0,6)#,
				#filterNum(attributes.production_time0,6)#,
				#filterNum(attributes.production_time_type0,6)#,
				#filterNum(attributes.production_type0,6)#,
				#filterNum(attributes.min_product_amount0,6)#,
				#filterNum(attributes.setup_time0,6)#,
				<cfif isdefined('attributes.asset_id0') and len(attributes.asset_id0) and len(attributes.asset0)>#attributes.asset_id0#<cfelse>NULL</cfif>
			)
	</cfquery><cfabort>
<cfelseif isdefined('attributes.UPD_ROW_ID') and isdefined('attributes.SELECTED_ROW_ID')>
	<cfif isdefined('attributes.ws_default#SELECTED_ROW_ID#') and isdefined('attributes.operation_type_id#SELECTED_ROW_ID#')>
    	<cfquery name="upd_product1" datasource="#dsn3#">
            UPDATE 
                WORKSTATIONS_PRODUCTS 
             SET
             	DEFAULT_STATUS = 1
          	WHERE
            	WS_P_ID = #attributes.UPD_ROW_ID#
    	</cfquery>
      	<cfquery name="upd_product2" datasource="#dsn3#">
            UPDATE 
                WORKSTATIONS_PRODUCTS 
             SET
             	DEFAULT_STATUS = 0
          	WHERE
            	WS_P_ID <> #attributes.UPD_ROW_ID#
                AND OPERATION_TYPE_ID = #Evaluate("attributes.operation_type_id#SELECTED_ROW_ID#")#
    	</cfquery>
    </cfif>
	<cfquery name="upd_product" datasource="#dsn3#">
		 UPDATE 
			WORKSTATIONS_PRODUCTS 
		 SET 
			WS_ID = #Evaluate("attributes.station_id#SELECTED_ROW_ID#")#,
			STOCK_ID = <cfif isdefined("attributes.STOCK_ID#SELECTED_ROW_ID#") and len(Evaluate("attributes.STOCK_ID#SELECTED_ROW_ID#"))>#Evaluate("attributes.STOCK_ID#SELECTED_ROW_ID#")#<cfelse>NULL</cfif>,
			OPERATION_TYPE_ID = <cfif isdefined("attributes.operation_type_id#SELECTED_ROW_ID#") and len(Evaluate("attributes.operation_type_id#SELECTED_ROW_ID#"))>#Evaluate("attributes.operation_type_id#SELECTED_ROW_ID#")#<cfelse>NULL</cfif>,
			MAIN_STOCK_ID = <cfif isdefined('attributes.main_stock_id#SELECTED_ROW_ID#') and len(Evaluate("attributes.main_stock_id#SELECTED_ROW_ID#"))>#Evaluate("attributes.main_stock_id#SELECTED_ROW_ID#")#<cfelseif isdefined("attributes.STOCK_ID#SELECTED_ROW_ID#") and len(Evaluate("attributes.STOCK_ID#SELECTED_ROW_ID#"))>#Evaluate("attributes.STOCK_ID#SELECTED_ROW_ID#")#<cfelse>NULL</cfif>,
			CAPACITY = #filterNum(Evaluate("attributes.CAPACITY#SELECTED_ROW_ID#"),6)#,
			PRODUCTION_TIME = #filterNum(Evaluate("attributes.PRODUCTION_TIME#SELECTED_ROW_ID#"),6)#,
			PRODUCTION_TYPE = #filterNum(Evaluate("attributes.PRODUCTION_TYPE#SELECTED_ROW_ID#"),6)#,
			PRODUCTION_TIME_TYPE = #filterNum(Evaluate("attributes.PRODUCTION_TIME_TYPE#SELECTED_ROW_ID#"),6)#,
			MIN_PRODUCT_AMOUNT = #filterNum(Evaluate("attributes.MIN_PRODUCT_AMOUNT#SELECTED_ROW_ID#"),6)#,
			SETUP_TIME = #filterNum(Evaluate("attributes.SETUP_TIME#SELECTED_ROW_ID#"),6)#
			<cfif isdefined('attributes.asset_id#SELECTED_ROW_ID#') and len(Evaluate("attributes.asset_id#SELECTED_ROW_ID#")) and len(Evaluate("attributes.asset#SELECTED_ROW_ID#"))>,ASSET_ID = #Evaluate("attributes.asset_id#SELECTED_ROW_ID#")#</cfif>
		 WHERE
			WS_P_ID = #attributes.UPD_ROW_ID# 
	</cfquery>
<cfelseif isdefined('attributes.del_row_id')>
	<cfquery name="DELETE_ROW" datasource="#dsn3#">
		DELETE FROM WORKSTATIONS_PRODUCTS WHERE WS_P_ID = #attributes.del_row_id#
	</cfquery>
</cfif>