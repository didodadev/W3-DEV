<cfset get_inspection_level = createObject("component","V16.settings.cfc.setupInspectionLevel").getInspectionLevel(dsn3:dsn3,is_active:1)>

<cftransaction>
<cfset createObject("component", "V16.product.cfc.get_product_member_inspection_level").delProductMemberInspectionLevel(
	dsn3				: dsn3,
	product_cat_id		: iif(isDefined("attributes.product_cat_id") and Len(attributes.product_cat_id),"attributes.product_cat_id",de("")),
	product_id			: iif(isDefined("attributes.product_id") and Len(attributes.product_id),"attributes.product_id",de(""))
)>
<cfloop from="1" to="#attributes.record_num_pmilevel#" index="pml"><br />
	<cfif Evaluate("attributes.row_kontrol_pmilevel#pml#") neq 0>
		<cfset createObject("component", "V16.product.cfc.get_product_member_inspection_level").addProductMemberInspectionLevel(
			dsn3				: dsn3,
			product_cat_id		: iif(isDefined("attributes.product_cat_id") and Len(attributes.product_cat_id),"#attributes.product_cat_id#",de("")),
			product_id			: iif(isDefined("attributes.product_id") and Len(attributes.product_id),"#attributes.product_id#",de("")),
			inspection_level_id	: Evaluate("attributes.inspection_level_id#pml#"),
			company_id			: Evaluate("attributes.company_id#pml#")
		)>
	</cfif>
</cfloop>
</cftransaction>
<cfif isDefined("attributes.product_cat_id") and Len(attributes.product_cat_id)>
	<cflocation url="#request.self#?fuseaction=product.list_product_cat&event=upd&id=#attributes.product_cat_id#" addtoken="no">
<cfelse>
	<script type="text/javascript">
		window.close();
	</script>
</cfif>
