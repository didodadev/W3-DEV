<cfset uploadFolder = application.systemParam.systemParam().upload_folder>
<cfset cmp = createObject("component","V16.worknet.cfc.product") />

<cfset getProduct = cmp.getProduct(product_id:attributes.pid)>

<cffile action="delete" file="#uploadFolder##getProduct.PATH#">

<cfset deleteImageDb = cmp.delProductImage(product_id:attributes.pid)>
<cfset deleteProduct = cmp.delProduct(product_id:attributes.pid)>
<cfset deleteRelationWorknet = cmp.delProductWorknet(product_id:attributes.pid)>