<cfif isdefined("attributes.record_num_other") and len(attributes.record_num_other)>
	<cfloop from="1" to="#attributes.record_num_other#" index="ii">
		<cfscript>
			form_stock_id = evaluate("attributes.stock_id#ii#");
			form_ship_id = evaluate("attributes.ship_id#ii#");
			form_amount = filterNum(evaluate("attributes.amount#ii#"));
		</cfscript>
		<cfif form_amount gt 0>
			<cfquery name="ADD_SHIP_ROW" datasource="#DSN2#">
				INSERT INTO
					SHIP_RESULT_PACKAGE_PRODUCT
				(
					SHIP_RESULT_PACKAGE_ID,
					STOCK_ID,
					AMOUNT,
					SHIP_ID
				)
				VALUES
				(
					#attributes.ship_result_package_id#,
					#form_stock_id#,
					#form_amount#,
					#form_ship_id#
				)
			</cfquery>		
		</cfif>
	</cfloop>
</cfif>

<script type="text/javascript">
	window.close();
</script>
