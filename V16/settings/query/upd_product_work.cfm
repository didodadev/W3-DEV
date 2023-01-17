<!--- ürün sorumlusu değiştir --->
<cf_date tarih="attributes.startdate_">
<cf_date tarih="attributes.finishdate_">
<cfset attributes.startdate=date_add("h", attributes.START_HOUR - session.ep.TIME_ZONE, attributes.startdate_)>
<cfset attributes.finishdate=date_add("h", attributes.FINISH_HOUR - session.ep.TIME_ZONE, attributes.finishdate_)>
<cfquery name="getproducts" datasource="#DSN1#">
	SELECT
		  PRODUCT_ID
	FROM 
		  PRODUCT
	WHERE 
		  PRODUCT_MANAGER = #attributes.old_position_code2# AND
		  RECORD_DATE BETWEEN #attributes.startdate# AND #attributes.finishdate_#
</cfquery>
<cfset getproducts_list=valuelist(getproducts.PRODUCT_ID)>
<cfif not listlen(getproducts_list)>
	<script type="text/javascript">
		{
		alert("<cf_get_lang no ='2551.Aktarılacak ürün sorumlu kaydı yok'>!");
		history.back();
		}
	</script>
<cfelse>
	<cfquery name="update_productmanager" datasource="#dsn1#">
		UPDATE PRODUCT SET PRODUCT_MANAGER = #attributes.position_code2# WHERE PRODUCT_ID IN(#getproducts_list#)
	</cfquery>
  <cflocation addtoken="no" url="#request.self#?fuseaction=settings.transfer_work_product"> 
</cfif>

 
