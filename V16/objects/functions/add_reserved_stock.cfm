<cfsetting showdebugoutput="no">
<cfif isdefined('attributes.reserve_type_') and attributes.reserve_type_ eq 0>
	<!---<cfquery name="DEL_ROW_RESERVE" datasource="#dsn3#">
		DELETE FROM ORDER_ROW_RESERVED WHERE PRE_ORDER_ID='#CFTOKEN#'
	</cfquery>--->
    <cfstoredproc procedure="DEL_ORDER_ROW_RESERVED" datasource="#dsn3#">
        <cfprocparam cfsqltype="cf_sql_varchar" value="#CFTOKEN#">
    </cfstoredproc>
<cfelseif isdefined('attributes.reserve_type_') and attributes.reserve_type_ eq 2><!--- sayfa yenilendiginde satır id ler sıfırlanıyor --->
	<cfquery name="DEL_ROW_RESERVE" datasource="#dsn3#">
		UPDATE ORDER_ROW_RESERVED SET ORDER_ROW_ID=NULL WHERE PRE_ORDER_ID='#CFTOKEN#'
	</cfquery>
<cfelse>
	<cfquery name="DEL_ROW_RESERVE" datasource="#dsn3#">
		DELETE FROM
			ORDER_ROW_RESERVED 
		WHERE 
			PRE_ORDER_ID='#CFTOKEN#'
			<cfif isdefined('attributes.product_row_id_') and len(attributes.product_row_id_)>
			AND ORDER_ROW_ID=#attributes.product_row_id_#
			</cfif>
	</cfquery>
	<cfif isdefined('attributes.r_stock_code') and len(attributes.r_stock_code)>
		<cfquery name="get_product_detail_" datasource="#dsn3#">
			SELECT 
				PRODUCT_ID, STOCK_ID,PRODUCT_UNIT_ID,TAX, PROPERTY,PRODUCT_NAME
			FROM 
				STOCKS 
			WHERE
			<cfif isdefined('attributes.use_prod_code_type') and attributes.use_prod_code_type eq 2>
				(STOCK_CODE_2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.r_stock_code#"> OR STOCK_CODE_2 LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%.#attributes.r_stock_code#">)
			<cfelse>
				(STOCK_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.r_stock_code#"> OR STOCK_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%.#attributes.r_stock_code#">)
			</cfif>
		</cfquery>
		<cfif get_product_detail_.recordcount>
			<cfset attributes.r_stock_id = get_product_detail_.STOCK_ID>
		</cfif>
	</cfif>
	<cfif isdefined('attributes.r_stock_id') and len(attributes.r_stock_id) and len(attributes.r_amount) and attributes.r_amount neq 0>
		<cfquery name="add_reserve_" datasource="#dsn3#">
			INSERT INTO 
				ORDER_ROW_RESERVED
				(
					STOCK_ID,
					PRODUCT_ID,
					RESERVE_STOCK_OUT,
					ORDER_ROW_ID,
					PRE_ORDER_ID
				) 
				VALUES
				(
					#get_product_detail_.STOCK_ID#,
					#get_product_detail_.PRODUCT_ID#,
					#attributes.r_amount#,
					#attributes.product_row_id_#,
					'#CFTOKEN#'
					
				)
		</cfquery>
	</cfif>
</cfif>
