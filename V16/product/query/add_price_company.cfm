<cfsetting showdebugoutput="no">
<cflock name="#CREATEUUID()#" timeout="20">
	<cftransaction>
		<cfquery name="add_price_list_for_company" datasource="#DSN3#">
			INSERT INTO
				PRICE_CAT_EXCEPTIONS
				(
					IS_GENERAL,
					COMPANY_ID,
					CONSUMER_ID,
					ACT_TYPE,
					PRODUCT_CATID, 
					BRAND_ID, 
					PRODUCT_ID,
					PRICE_CATID,
					SUPPLIER_ID,
					COMPANYCAT_ID,
					DISCOUNT_RATE,
					RECORD_EMP,
					RECORD_IP,
					RECORD_DATE
				)
			VALUES
				(
					1,
					<cfif isdefined('attributes.company_id') and len(attributes.company_id) and isdefined('attributes.company') and len(attributes.company)>#attributes.company_id#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.consumer_id') and len(attributes.consumer_id) and isdefined('attributes.company') and len(attributes.company)>#attributes.consumer_id#<cfelse>NULL</cfif>,
					3,
					<cfif isdefined('attributes.product_cat_id') and len(attributes.product_cat_id) and len(attributes.product_cat_name)>#attributes.product_cat_id#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.brand_id') and len(attributes.brand_id) and len(attributes.brand_name)>#attributes.brand_id#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.product_id') and len(attributes.product_id) and len(attributes.product_name)>#attributes.product_id#<cfelse>NULL</cfif>,
					#attributes.price_cat#,
					<cfif isDefined("attributes.supplier_id") and isDefined("attributes.supplier_name") and len(attributes.supplier_id) and len(attributes.supplier_name)>#attributes.supplier_id#<cfelse>NULL</cfif>,
					<cfif isDefined("attributes.comp_cat") and len(attributes.comp_cat)>#attributes.comp_cat#,<cfelse>NULL,</cfif>
					<cfif isDefined("attributes.discount_info") and len(attributes.discount_info)>#filterNum(attributes.discount_info)#<cfelse>NULL</cfif>,
					#session.ep.userid#,
					'#remote_addr#',
					#now()#
				)
		</cfquery>
	</cftransaction>
</cflock>
<script type="text/javascript">
	location.reload();
</script>
