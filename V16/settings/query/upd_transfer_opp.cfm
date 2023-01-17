<!--- Aktif Fırsatlar Satış Çalışanını Değiştirme --->
<cfquery name="get_opportunity" datasource="#DSN3#">
	SELECT
		OPP_ID
	FROM
		OPPORTUNITIES
	WHERE
		OPP_STATUS = 1  AND
		SALES_POSITION_CODE = #attributes.old_sales_position_code# 
</cfquery>
<cfset get_opportunity_list=valuelist(get_opportunity.OPP_ID)>
<cfif not listlen(get_opportunity_list)>
	<script type="text/javascript">
		{
			alert("<cf_get_lang dictionary_id='44533.Aktarılacak Satış Çalışan Kaydı Yok'>!");
			location.href= document.referrer;
		}
	</script>
<cfelse>
	<cfquery name="upd_opportunity" datasource="#DSN3#">
		UPDATE OPPORTUNITIES SET SALES_POSITION_CODE = #attributes.sales_position_code# WHERE OPP_ID IN (#get_opportunity_list#) 
	</cfquery>
	<cflocation addtoken="no" url="#request.self#?fuseaction=settings.transfer_work_product">
</cfif>


