<cfquery name="ORDERS" datasource="#dsn#">
	SELECT * FROM ORDER_STATUS
</cfquery>		
<cfif orders.recordcount>
	<cfoutput query="orders">
		<a href="#request.self#?fuseaction=settings.form_upd_order_status&ID=#orderStatus_ID#">#orderStatus#</a><br/>
	</cfoutput>
<cfelse>
	<font class="ikaz"><cf_get_lang no='137.Kayıtlı Kategori yok'></font>
</cfif>

