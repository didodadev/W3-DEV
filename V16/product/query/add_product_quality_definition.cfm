<!--- Kalite Kontrol Tanimlari FBS&IA 20121005 --->
<cftransaction>
<cfset createObject("component", "V16.product.cfc.get_product_quality_types").delProductQualityTypes(
	dsn3				: dsn3,
	product_cat_id		: iif(isDefined("attributes.product_cat_id") and Len(attributes.product_cat_id),"#attributes.product_cat_id#",de("")),
	product_id			: iif(isDefined("attributes.product_id") and Len(attributes.product_id),"#attributes.product_id#",de(""))
)>
<cfloop from="1" to="#attributes.record_num_qt#" index="qt">
	<cfif Evaluate("attributes.row_kontrol_qt#qt#") neq 0>
		<cfif isDefined("attributes.quality_type_id#qt#") and Len(ListFirst(Evaluate('attributes.quality_type_id#qt#'),";"))><cfset quality_type_id = ListFirst(Evaluate('attributes.quality_type_id#qt#'),";")><cfelse><cfset quality_type_id = ""></cfif>
		<cfif isDefined("attributes.op_id_list_#qt#") and Len(Evaluate('attributes.op_id_list_#qt#'))><cfset operation_type_id = Evaluate('attributes.op_id_list_#qt#')><cfelse><cfset operation_type_id = ""></cfif>
		<cfif isDefined("attributes.order_no#qt#") and Len(Evaluate('attributes.order_no#qt#'))><cfset order_no = Evaluate('attributes.order_no#qt#')><cfelse><cfset order_no = ""></cfif>
		<cfif isDefined("attributes.default_value#qt#") and Len(Evaluate('attributes.default_value#qt#'))><cfset default_value = filterNum(Evaluate('attributes.default_value#qt#'),4)><cfelse><cfset default_value = ""></cfif>
		<cfif isDefined("attributes.tolerance_#qt#") and Len(Evaluate('attributes.tolerance_#qt#'))><cfset tolerance_ = filterNum(Evaluate('attributes.tolerance_#qt#'),4)><cfelse><cfset tolerance_ = ""></cfif>
		<cfif isDefined("attributes.tolerance_2_#qt#") and Len(Evaluate('attributes.tolerance_2_#qt#'))><cfset tolerance_2_ = filterNum(Evaluate('attributes.tolerance_2_#qt#'),4)><cfelse><cfset tolerance_2_ = ""></cfif>
		<cfif isDefined("attributes.quality_rule#qt#") and Len(Evaluate('attributes.quality_rule#qt#'))><cfset quality_rule = Evaluate('attributes.quality_rule#qt#')><cfelse><cfset quality_rule = 0></cfif>
		<cfif isDefined("attributes.quality_sample_method#qt#") and Len(Evaluate('attributes.quality_sample_method#qt#'))><cfset quality_sample_method = Evaluate('attributes.quality_sample_method#qt#')><cfelse><cfset quality_sample_method = ""></cfif>
		<cfif isDefined("attributes.quality_sample_number#qt#") and Len(Evaluate('attributes.quality_sample_number#qt#'))><cfset quality_sample_number = filterNum(Evaluate('attributes.quality_sample_number#qt#'),4)><cfelse><cfset quality_sample_number = ""></cfif>
		<cfif isDefined("attributes.quality_sample_type#qt#") and Len(Evaluate('attributes.quality_sample_type#qt#'))><cfset quality_sample_type = Evaluate('attributes.quality_sample_type#qt#')><cfelse><cfset quality_sample_type = ""></cfif>
		<cfif isDefined("attributes.process_cat#qt#") and Len(ListFirst(Evaluate('attributes.process_cat#qt#'),";"))><cfset process_cat = ListFirst(Evaluate('attributes.process_cat#qt#'),";")><cfelse><cfset process_cat = ""></cfif>
		<cfset createObject("component", "V16.product.cfc.get_product_quality_types").addProductQualityTypes(
			dsn3				: dsn3,
			product_cat_id		: iif(isDefined("attributes.product_cat_id") and Len(attributes.product_cat_id),"#attributes.product_cat_id#",de("")),
			product_id			: iif(isDefined("attributes.product_id") and Len(attributes.product_id),"#attributes.product_id#",de("")),
			quality_type_id		: quality_type_id,
			operation_type_id	: operation_type_id,
			order_no			: order_no,
			default_value		: default_value,
			tolerance			: tolerance_,
			tolerance_2			: tolerance_2_,
			quality_rule		: quality_rule,
			quality_sample_type :quality_sample_type,
			quality_sample_method:quality_sample_method,
			quality_sample_number :quality_sample_number,
			process_cat			: process_cat
			
		)>
	</cfif>
</cfloop>
</cftransaction>
<cfif isDefined("attributes.product_cat_id") and Len(attributes.product_cat_id)>
	<script type="text/javascript">
		window.location.href="<cfoutput>#request.self#?fuseaction=product.list_product_cat&event=upd&id=#attributes.product_cat_id#</cfoutput>" ;
	</script>
<cfelse>
	<script type="text/javascript">
		window.location.replace(document.referrer);
	</script>
</cfif>
