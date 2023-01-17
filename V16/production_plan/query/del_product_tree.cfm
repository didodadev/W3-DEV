<cfquery name="del_product_tree" datasource="#dsn3#">
	DELETE FROM PRODUCT_TREE WHERE STOCK_ID = #attributes.stock_id#
</cfquery>
<cflocation url="#request.self#?fuseaction=prod.list_product_tree&event=upd&stock_id=#attributes.stock_id#" addtoken="no">

