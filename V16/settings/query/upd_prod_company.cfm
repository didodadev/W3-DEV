<!--- Ürün Tedarikçisi Değiştir --->
<cf_date tarih="attributes.startdate">
<cf_date tarih="attributes.finishdate">
<cfset attributes.startdate=date_add("h", attributes.START_HOUR - session.ep.TIME_ZONE, attributes.startdate)>
<cfset attributes.finishdate=date_add("h", attributes.FINISH_HOUR - session.ep.TIME_ZONE, attributes.finishdate)>
<cfquery name="getproducts" datasource="#DSN1#">
	SELECT
		  PRODUCT_ID
	FROM 
		  PRODUCT
	WHERE 
		  COMPANY_ID = #attributes.old_company_id# AND
		  RECORD_DATE BETWEEN #attributes.startdate# AND #attributes.finishdate#
</cfquery>
<cfset get_product_list=valuelist(getproducts.PRODUCT_ID)>
<cfif not listlen(get_product_list)>
	<script type="text/javascript">
		{
			alert("<cf_get_lang dictionary_id='44531.Aktarılacak Tedarikçi Kaydı yok'>!");
			location.href= document.referrer;
		}
	</script>
<cfelse>
	<cfquery name="update_product_company" datasource="#dsn1#">
		UPDATE PRODUCT SET COMPANY_ID = #attributes.comp_id# WHERE PRODUCT_ID IN(#get_product_list#)
	</cfquery>
	<cflocation addtoken="no" url="#request.self#?fuseaction=settings.transfer_work_product">
</cfif>
