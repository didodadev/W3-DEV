<!--- Aktif Siparişler Satış Çalışanını Değiştirme --->
<cfquery name="get_orders" datasource="#DSN3#">
	SELECT
		ORDER_ID
	FROM
		ORDERS
	WHERE
		ORDER_STATUS = 1  AND
		ORDER_EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.old_sal_pos_code#">
</cfquery>
 <!--- SALES_POSITION_CODE alanı tabloda olmadığı için hata veriyordu, employee_id üzerinden aktarım yapıldı  --->
<cfset get_orders_list=valuelist(get_orders.ORDER_ID)>
<cfif not listlen(get_orders_list)>
	<script type="text/javascript">
		{
			alert("<cf_get_lang dictionary_id='44533.Aktarılacak Satış Çalışan Kaydı Yok'>!");
			location.href= document.referrer;
		}
	</script>
<cfelse>
<cfquery name="upd_orders" datasource="#DSN3#">
	UPDATE ORDERS SET ORDER_EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_pos_code#"> WHERE ORDER_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#get_orders_list#" list="yes">) 
</cfquery>
</cfif>

<cflocation addtoken="no" url="#request.self#?fuseaction=settings.transfer_work_product">
