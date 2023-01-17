<cflock timeout="80">
	<cftransaction>
		<cfquery name="add_product_formula" datasource="#dsn3#" result="MAX_ID">
			INSERT INTO 
				SETUP_PRODUCT_FORMULA
				(
					IS_ACTIVE,
					FORMULA_NAME,
                    FORMULA_STOCK_ID,
					RECORD_EMP, 
					RECORD_IP, 
					RECORD_DATE
				)
			VALUES
				(
					<cfif isdefined("attributes.is_active")>1<cfelse>0</cfif>,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.formula_name#">,
                    <cfif len(attributes.product_name) and len(attributes.stock_id)>#attributes.stock_id#<cfelse>NULL</cfif>,
                    #session.ep.userid#,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#REMOTE_ADDR#">,
                    #now()#
				)
		</cfquery>
	</cftransaction>
</cflock>
<cflocation url="#request.self#?fuseaction=product.popup_upd_product_formula&id=#MAX_ID.IDENTITYCOL#" addtoken="no">
