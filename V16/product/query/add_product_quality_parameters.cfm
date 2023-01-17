<cfset get_inspection_level = createObject("component","V16.settings.cfc.setupInspectionLevel").getInspectionLevel(dsn3:dsn3,is_active:1)>

<cftransaction>
<cfset createObject("component", "V16.product.cfc.get_product_quality_parameters").delQualityParameters(
	dsn3				: dsn3,
	product_cat_id		: iif(isDefined("attributes.product_cat_id") and Len(attributes.product_cat_id),"#attributes.product_cat_id#",de("")),
	product_id			: iif(isDefined("attributes.product_id") and Len(attributes.product_id),"#attributes.product_id#",de(""))
)>
<cfset line_number_ = 0>
<cfloop from="1" to="#attributes.record_num_qcp#" index="qcp">
	<cfif Evaluate("attributes.row_kontrol_qcp#qcp#") neq 0>
		<cfset line_number_ = line_number_ + 1>
		<cfloop query="get_inspection_level">
			<cfset createObject("component", "V16.product.cfc.get_product_quality_parameters").addQualityParameters(
				dsn3				: dsn3,
				product_cat_id		: iif(isDefined("attributes.product_cat_id") and Len(attributes.product_cat_id),"#attributes.product_cat_id#",de("")),
				product_id			: iif(isDefined("attributes.product_id") and Len(attributes.product_id),"#attributes.product_id#",de("")),
				line_number			: line_number_,
				inspection_level_id	: get_inspection_level.inspection_level_id,
				min_quantity		: Evaluate("attributes.min_quantity#qcp#"),
				max_quantity		: Evaluate("attributes.max_quantity#qcp#"),
				sample_quantity		: Evaluate("attributes.sample_#get_inspection_level.inspection_level_id#_quantity#qcp#"),
				acceptance_quantity	: Evaluate("attributes.acceptance_#get_inspection_level.inspection_level_id#_quantity#qcp#"),
				rejection_quantity	: Evaluate("attributes.rejection_#get_inspection_level.inspection_level_id#_quantity#qcp#")
			)>
		</cfloop>
	</cfif>
</cfloop>
</cftransaction>
<cfif isDefined("attributes.product_cat_id") and Len(attributes.product_cat_id)>
	<cflocation url="#request.self#?fuseaction=product.list_product_cat&event=upd&id=#attributes.product_cat_id#" addtoken="no">
<cfelse>
	<script type="text/javascript">
		location.href= document.referrer;
	</script>
</cfif>
