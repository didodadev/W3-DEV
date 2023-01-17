<cfsetting showdebugoutput="no">
<cfif len(attributes.new_list_req) gt 1>
	<cfset attributes.new_list_req = right(attributes.new_list_req,len(attributes.new_list_req)-1)>
</cfif>
<cfif len(attributes.new_list_price_type) gt 1>
	<cfset attributes.new_list_price_type = right(attributes.new_list_price_type,len(attributes.new_list_price_type)-1)>
</cfif>
<cfif len(attributes.new_list_amount) gt 1>
	<cfset attributes.new_list_amount = right(attributes.new_list_amount,len(attributes.new_list_amount)-1)>
</cfif>
<cfif len(attributes.new_list_amount_value) gt 1>
	<cfset attributes.new_list_amount_value = right(attributes.new_list_amount_value,len(attributes.new_list_amount_value)-1)>
</cfif>
<cfif len(attributes.new_list_property) gt 1>
	<cfset attributes.new_list_property = right(attributes.new_list_property,len(attributes.new_list_property)-1)>
</cfif>
<cfif len(attributes.new_list_property_row) gt 1>
	<cfset attributes.new_list_property_row = right(attributes.new_list_property_row,len(attributes.new_list_property_row)-1)>
</cfif>
<cfif len(attributes.new_list_formula_id) gt 1>
	<cfset attributes.new_list_formula_id = right(attributes.new_list_formula_id,len(attributes.new_list_formula_id)-1)>
</cfif>
<cfquery name="get_formula_rows" datasource="#dsn3#">
	SELECT * FROM SETUP_PRODUCT_FORMULA_ROWS WHERE PRODUCT_CONFIGURATOR_ID = #attributes.configurator_id# ORDER BY ORDER_NO
</cfquery>
<cfloop from="1" to="#listlen(attributes.new_list_req,'_')#" index="kk">
	<cfset req_type = listgetat(attributes.new_list_req,kk,'_')>
	<cfset property = listgetat(attributes.new_list_property,kk,'_')>
	<cfset property_row = listgetat(attributes.new_list_property_row,kk,'_')>
	<cfset formula_row = listgetat(attributes.new_list_formula_id,kk,'_')>
	<cfset "all_price_#property#" = 0>
	<cfset req_value = listgetat(attributes.new_list_req,kk,'_')>
	<cfset price_type = listgetat(attributes.new_list_price_type,kk,'_')>
	<cfset amount = 0>
	<cfset amount_value = 0>
	<cfif req_type eq 1>
		<cfset amount = filterNum(listgetat(attributes.new_list_amount,kk,'_'),4)>
		<cfset amount_value = filterNum(listgetat(attributes.new_list_amount_value,kk,'_'),4)>
	</cfif>
	<cfif price_type eq 1>
		<cfif not (len(formula_row) and formula_row neq 0)>
			<cfset "all_price_#property#" = evaluate("all_price_#property#") + (attributes.price*amount)>
		<cfelse>
			<cfset "all_price_#property#" = evaluate("all_price_#property#") + (amount)>
		</cfif>
		<cfset "all_price_#property#" = evaluate("all_price_#property#") + amount_value>
	<cfelseif price_type eq 2>
		<cfset "all_price_#property#" = evaluate("all_price_#property#") + amount_value>
	<cfelseif price_type eq 3>
		<cfset "all_price_#property#" = evaluate("all_price_#property#") + (evaluate("all_price_#property_row#")*amount)>
	</cfif>
	<cfquery name="get_formula_rows_" datasource="#dsn3#">
		SELECT * FROM SETUP_PRODUCT_FORMULA_ROWS WHERE PRODUCT_FORMULA_ID = #formula_row# ORDER BY ORDER_NO
	</cfquery>
	<cfoutput query="get_formula_rows_">
		<cfset proprty_id_ = get_formula_rows_.property_id>
		<cfset proprty_id_1_ = get_formula_rows_.property_id1>
		<cfset order_no_ = get_formula_rows_.order_no>
		<cfset act_type_ = get_formula_rows_.act_type>
		<cfset first_amount =  0>
		<cfset last_amount =  0>
		<cfif len(proprty_id_)>
			<cfset first_amount = evaluate("all_price_#proprty_id_#")>
		</cfif>
		<cfif len(proprty_id_1_)>
			<cfset last_amount = evaluate("all_price_#proprty_id_1_#")>
		</cfif>
		<cfif len(related_row)>
			<cfset first_amount = evaluate("all_price_last_rows_#related_row#")>
		</cfif>
		<cfif len(related_row1)>
			<cfset last_amount = evaluate("all_price_last_rows_#related_row1#")>
		</cfif>
		<cfif len(pro_amount)>
			<cfset first_amount = pro_amount>
		</cfif>
		<cfif len(pro_amount1)>
			<cfset last_amount = pro_amount1>
		</cfif>
		<cfif act_type_ eq 1>		
			<cfset "all_price_last_rows_#order_no_#" = first_amount + last_amount>
		<cfelse>
			<cfset "all_price_last_rows_#order_no_#" = first_amount * last_amount>
		</cfif>
		<cfif kk neq 1>
			<cfset pro_row = listgetat(attributes.new_list_property,kk-1,'_')>
		<cfelse>	
			<cfset pro_row = property>
		</cfif>
		<cfif get_formula_rows_.currentrow eq get_formula_rows_.recordcount><cfset "all_price_#pro_row#" = evaluate("all_price_last_rows_#order_no_#")></cfif>
	</cfoutput>
</cfloop>
<cfoutput query="get_formula_rows">
	<cfset first_amount =  0>
	<cfset last_amount =  0>
	<cfset "all_price_last_#order_no#" =  0>
	<cfif len(property_id)>
		<cfset first_amount = evaluate("all_price_#property_id#")>
	</cfif>
	<cfif len(property_id1)>
		<cfset last_amount = evaluate("all_price_#property_id1#")>
	</cfif>
	<cfif len(related_row) and isdefined("all_price_last_#related_row#")>
		<cfset first_amount = evaluate("all_price_last_#related_row#")>
	</cfif>
	<cfif len(related_row1) and isdefined("all_price_last_#related_row1#")>
		<cfset last_amount = evaluate("all_price_last_#related_row1#")>
	</cfif>
	<cfif act_type eq 1>		
		<cfset "all_price_last_#order_no#" = first_amount + last_amount>
	<cfelse>
		<cfset "all_price_last_#order_no#" = first_amount * last_amount>
	</cfif>
	<cfif currentrow eq get_formula_rows.recordcount><cfset all_price = evaluate("all_price_last_#order_no#")></cfif>
</cfoutput>
<cfif not isdefined("all_price")>
	<cfset all_price = 0>
</cfif>
<cf_get_lang dictionary_id='45991.Yeni Fiyat'> :<cfoutput>#tlformat(all_price,2)#</cfoutput>
<script>
	document.all.new_price.value = '<cfoutput>#tlformat(all_price,2)#</cfoutput>';
</script>
