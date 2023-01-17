<cfsetting showdebugoutput="no">
<cflock name="#CREATEUUID()#" timeout="20">
	<cftransaction>
		<cfif isdefined("is_del") and is_del eq 1>
			<cfquery name="del_price_list" datasource="#dsn3#">
				DELETE FROM PRICE_CAT_EXCEPTIONS WHERE PRICE_CAT_EXCEPTION_ID = #attributes.pid#
			</cfquery>
		<cfelse>
			<cfquery name="add_price_list_for_company" datasource="#dsn3#">
				UPDATE
					PRICE_CAT_EXCEPTIONS
				SET
					COMPANY_ID = <cfif isdefined('attributes.company_id') and len(attributes.company_id) and isdefined('attributes.company') and len(attributes.company)>#attributes.company_id#<cfelse>NULL</cfif>,
					CONSUMER_ID = <cfif isdefined('attributes.consumer_id') and len(attributes.consumer_id) and isdefined('attributes.company') and len(attributes.company)>#attributes.consumer_id#<cfelse>NULL</cfif>,
					PRODUCT_CATID = <cfif isdefined('attributes.product_cat_id') and len(attributes.product_cat_id) and len(attributes.product_cat_name)>#attributes.product_cat_id#<cfelse>NULL</cfif>,
					BRAND_ID = <cfif isdefined('attributes.brand_id') and len(attributes.brand_id) and len(attributes.brand_name)>#attributes.brand_id#<cfelse>NULL</cfif>,
					PRODUCT_ID = <cfif isdefined('attributes.product_id') and len(attributes.product_id) and len(attributes.product_name)>#attributes.product_id#<cfelse>NULL</cfif>,
					PRICE_CATID = #attributes.price_cat#,
					SUPPLIER_ID = <cfif isDefined("attributes.supplier_id") and isDefined("attributes.supplier_name") and len(attributes.supplier_id) and len(attributes.supplier_name)>#attributes.supplier_id#<cfelse>NULL</cfif>,
					COMPANYCAT_ID = <cfif isDefined("attributes.comp_cat") and len(attributes.comp_cat)>#attributes.comp_cat#<cfelse>NULL</cfif>,
					DISCOUNT_RATE = <cfif isDefined("attributes.discount_info") and len(attributes.discount_info)>#filterNum(attributes.discount_info)#<cfelse>NULL</cfif>,
					UPDATE_EMP = #session.ep.userid#,
					UPDATE_IP = '#remote_addr#',
					UPDATE_DATE = #now()#
				WHERE
					PRICE_CAT_EXCEPTION_ID = #attributes.pid#
			</cfquery>
		</cfif>
	</cftransaction>
</cflock>
<script type="text/javascript">
	location.href = document.referrer;
</script>
