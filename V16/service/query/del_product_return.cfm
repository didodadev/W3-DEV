<!--- Iade talebine ait takip kaydi varmi ve takip sepete dusmus mu GIVEN_AMOUNT <> 0 kontrolu --->
<cfquery name="GET_DEMANDS" datasource="#DSN3#">
	SELECT GIVEN_AMOUNT FROM ORDER_DEMANDS WHERE RETURN_ROW_ID IS NOT NULL AND GIVEN_AMOUNT <> 0 AND RETURN_ROW_ID IN(SELECT RETURN_ROW_ID FROM SERVICE_PROD_RETURN_ROWS WHERE RETURN_ID = #attributes.return_id#)
</cfquery>
<cfif get_demands.recordcount>
	<script type="text/javascript">
		alert("İlgili İade Talebine Ait Takip Kaydı Bulunmaktadır. Kaydı Silemezsiniz !");
		history.back();
	</script>
	<cfabort>
</cfif>

<cflock name="#CreateUUID()#" timeout="30">
	<cftransaction>
		<cfquery name="DEL_DEMAND" datasource="#DSN3#">
			DELETE ORDER_DEMANDS WHERE RETURN_ROW_ID IS NOT NULL AND RETURN_ROW_ID IN(SELECT RETURN_ROW_ID FROM SERVICE_PROD_RETURN_ROWS WHERE RETURN_ID = #attributes.return_id#)
		</cfquery>
		<cfquery name="DEL_RETURN_ROWS" datasource="#DSN3#">
			DELETE SERVICE_PROD_RETURN_ROWS WHERE RETURN_ID = #attributes.return_id#
		</cfquery>
		<cfquery name="DEL_RETURN" datasource="#DSN3#">
			DELETE SERVICE_PROD_RETURN WHERE RETURN_ID = #attributes.return_id#
		</cfquery>
	</cftransaction>
</cflock>
<cflocation url="#request.self#?fuseaction=service.product_return" addtoken="no">
