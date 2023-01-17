<!--- Satirlarda, Detayinda Uretiliyor Secili Olan Urunlerin Siparisteki Asamasini Uretim Olarak Update Eder --->

<cfif isdefined("attributes.process_stage") and isdefined("attributes.action_id")>
	<cfquery name="GetOrderRowInfo" datasource="#Attributes.Data_Source#">
		SELECT
			OW.ORDER_ROW_ID,
			OW.PRODUCT_ID,
			P.IS_PRODUCTION
		FROM
			#caller.dsn3_alias#.ORDER_ROW OW,
			#caller.dsn1_alias#.PRODUCT P
		WHERE
			OW.PRODUCT_ID = P.PRODUCT_ID AND
			P.IS_PRODUCTION = 1 AND
			OW.ORDER_ID = #attributes.action_id#
	</cfquery>
	<cfloop query="GetOrderRowInfo">
		<cfquery name="UpdorderRowInfo" datasource="#Attributes.Data_Source#">
			UPDATE #caller.dsn3_alias#.ORDER_ROW SET ORDER_ROW_CURRENCY = -5 WHERE ORDER_ROW_ID = #GetOrderRowInfo.Order_Row_Id#
		</cfquery>
	</cfloop>
</cfif>
