<cftransaction>
	<cfquery name="GET_PRODUCTCAT" datasource="#dsn1#">
		SELECT HIERARCHY FROM PRODUCT_CAT WHERE PRODUCT_CATID=#attributes.PRODUCT_CATID#
	</cfquery>
	<cfquery name="DELPRODUCTCAT" datasource="#dsn1#">
		DELETE FROM PRODUCT_CAT WHERE PRODUCT_CATID=#attributes.PRODUCT_CATID#
	</cfquery>
	<cfquery name="DEL_PRODUCT_CAT_BRANDS" datasource="#dsn1#">
		DELETE FROM PRODUCT_CAT_BRANDS WHERE PRODUCT_CAT_ID=#attributes.PRODUCT_CATID#
	</cfquery>
	<cfquery name="DEL_PRODUCT_CAT_OUR_COMPANY" datasource="#dsn1#">
		DELETE FROM PRODUCT_CAT_OUR_COMPANY WHERE PRODUCT_CATID=#attributes.PRODUCT_CATID#
	</cfquery>	
	<!--- VE TÜM ALT DALLARDA SILINIR --->
	<cfquery name="DELPRODUCTCAT" datasource="#dsn1#">
		DELETE FROM PRODUCT_CAT	WHERE HIERARCHY LIKE '#attributes.OLDHIERARCHY#.%'
	</cfquery>
	<cfif GET_PRODUCTCAT.HIERARCHY contains '.'>
		<cfset son_alan_len = len(ListLast(GET_PRODUCTCAT.HIERARCHY,'.'))>
		<cfset tum_len = len(GET_PRODUCTCAT.HIERARCHY)>
		<cfset oldhierarchy_root = Left(GET_PRODUCTCAT.HIERARCHY,tum_len-son_alan_len-1)>
	<cfelse>
		<cfset oldhierarchy_root = GET_PRODUCTCAT.HIERARCHY>
	</cfif>
	<cfquery name="GET_SUB_PRODUCT_CAT" datasource="#DSN1#">
		SELECT 
			HIERARCHY
		FROM
			PRODUCT_CAT
		WHERE
			HIERARCHY LIKE '#oldhierarchy_root#.%'
	</cfquery>
	<cfif not GET_SUB_PRODUCT_CAT.RecordCount>
		<cfquery name="ADD_SUB_PRODUCT_CAT" datasource="#DSN1#">
			UPDATE 
				PRODUCT_CAT
			SET
				IS_SUB_PRODUCT_CAT = 0
			WHERE
				HIERARCHY = '#oldhierarchy_root#'
		</cfquery>
	</cfif>
</cftransaction>
<cflocation url="#request.self#?fuseaction=product.list_product_cat" addtoken="no">
