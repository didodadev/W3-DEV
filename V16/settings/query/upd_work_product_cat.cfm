<!--- ürün kategori sorumlusu görevi aktar --->
<cfquery name="update_productcat_manager" datasource="#dsn1#">
	UPDATE PRODUCT_CAT SET POSITION_CODE=#attributes.position_code# WHERE POSITION_CODE = #attributes.old_position_code#
</cfquery>
<cfquery name="update_productcat_manager2" datasource="#dsn1#">
	UPDATE PRODUCT_CAT SET POSITION_CODE2=#attributes.position_code# WHERE POSITION_CODE2 = #attributes.old_position_code#
</cfquery>

<cflocation addtoken="no" url="#request.self#?fuseaction=settings.transfer_work_product">

