<cfquery name="del_rows" datasource="#dsn3#">
	DELETE FROM SETUP_PRODUCT_CONFIGURATOR_MODES WHERE PRODUCT_CONFIGURATOR_ID =  #attributes.id# 
</cfquery>

<cfloop from="1" to="#attributes.mode_rowcount#" index="ccc">
	<cfif evaluate("attributes.mode_row_input_#ccc#") eq 1>
		<cfquery name="add_" datasource="#dsn3#">
			INSERT INTO
				SETUP_PRODUCT_CONFIGURATOR_MODES
					(
					PRODUCT_CONFIGURATOR_ID,
					CONFIGURATOR_VARIATION_ID_1,
					CONFIGURATOR_VARIATION_ID_2,
					CONFIGURATOR_VARIATION_ID_3,
					RULE_TYPE_1,
					RULE_TYPE_2,
					STOCK_ID,
					STOCK_ID_COUNT,
					MODE_TYPE
					)
				VALUES
					(
					#attributes.id#,
					<cfif len(evaluate("attributes.CONFIGURATOR_VARIATION_ID_1_#ccc#"))>#evaluate("attributes.CONFIGURATOR_VARIATION_ID_1_#ccc#")#<cfelse>NULL</cfif>,
					<cfif len(evaluate("attributes.CONFIGURATOR_VARIATION_ID_2_#ccc#"))>#evaluate("attributes.CONFIGURATOR_VARIATION_ID_2_#ccc#")#<cfelse>NULL</cfif>,
					<cfif len(evaluate("attributes.CONFIGURATOR_VARIATION_ID_3_#ccc#"))>#evaluate("attributes.CONFIGURATOR_VARIATION_ID_3_#ccc#")#<cfelse>NULL</cfif>,
					<cfif len(evaluate("attributes.RULE_TYPE_1_#ccc#"))>#evaluate("attributes.RULE_TYPE_1_#ccc#")#<cfelse>NULL</cfif>,
					<cfif len(evaluate("attributes.RULE_TYPE_2_#ccc#"))>#evaluate("attributes.RULE_TYPE_2_#ccc#")#<cfelse>NULL</cfif>,
					<cfif len(evaluate("attributes.mode_stock_id_#ccc#"))>#evaluate("attributes.mode_stock_id_#ccc#")#<cfelse>NULL</cfif>,
					<cfif len(evaluate("attributes.stock_id_count_#ccc#"))>#evaluate("attributes.stock_id_count_#ccc#")#<cfelse>NULL</cfif>,
					<cfif len(evaluate("attributes.MODE_TYPE_#ccc#"))>#evaluate("attributes.MODE_TYPE_#ccc#")#<cfelse>NULL</cfif>
					)
		</cfquery>
	</cfif>
</cfloop>
<cflocation url="#request.self#?fuseaction=product.popup_upd_product_cat_configuration&id=#attributes.id#" addtoken="no">

