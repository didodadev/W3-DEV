<!--- Aktif Teklifler Satış Çalışanını Değiştir --->
<cfquery name="get_offer" datasource="#DSN3#">
	SELECT
		OFFER_ID
	FROM
		OFFER
	WHERE
		OFFER_STATUS = 1  AND
		SALES_EMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.old_offer_pos_code#">  
</cfquery>
 <!--- SALES_POSITION_CODE alanı tabloda olmadığı için hata veriyordu, employee_id üzerinden aktarım yapıldı  --->

<cfset get_offer_list=valuelist(get_offer.OFFER_ID)>
<cfif not listlen(get_offer_list)>
	<script type="text/javascript">
		{
			alert("<cf_get_lang dictionary_id='44533.Aktarılacak Satış Çalışan Kaydı Yok'>!");
			location.href= document.referrer;
		}
	</script>
<cfelse>
<cfquery name="upd_offer" datasource="#DSN3#">
	UPDATE OFFER SET SALES_EMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.offer_pos_code#"> WHERE OFFER_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#get_offer_list#" list="yes">) 
</cfquery>
</cfif>

<cflocation addtoken="no" url="#request.self#?fuseaction=settings.transfer_work_product">
