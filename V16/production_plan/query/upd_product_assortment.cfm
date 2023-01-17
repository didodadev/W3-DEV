<!--- 
	Bu sayfalar teklif ve siparis basketlerinde listelenecek olan 
	asorti ile ilgili islemler fakat bu sayfalari kullanilip kullanilmamasi implementasyona irakildigindan sistem icinde 
	kullanilmayabilir. ARZU BT 06112003	
--->
<cfinclude template="get_prod_property_detail.cfm"> 
<cfquery name="del_ass_row" datasource="#DSN3#">
	DELETE FROM PRODUCT_ASSORTMENTS WHERE ACTION_ID = #attributes.row_id# AND ACTION_TYPE_ID = 2
</cfquery>
<cfloop query="get_product_property">
	<cfset counter = get_product_property.PROPERTY_ID[currentrow]>
	<cfset top_currentrow=currentrow>
	<cfquery name="GET_PROPERTY_DETAIL" datasource="#DSN1#">
		SELECT 
			* 
		FROM 
			PRODUCT_PROPERTY_DETAIL 
		WHERE 
			PRPT_ID = #get_product_property.property_id[top_currentrow]#
		ORDER BY
			PRPT_ID,
			PROPERTY_DETAIL_ID
	</cfquery>
	<cfloop query="get_property_detail">
	
		<cfset sub_counter = get_property_detail.PROPERTY_DETAIL_ID[currentrow]>
		<cfset amount_value=evaluate("validation_#counter#_#sub_counter#")>
		
		<cfif amount_value neq 0>
			<cfquery name="add_assort" datasource="#DSN3#">
				INSERT INTO 
					PRODUCT_ASSORTMENTS
				(
					ACTION_ID,
					ACTION_TYPE_ID,
					AMOUNT,
					PROPERTY_ID,
					PROPERTY_DETAIL_ID
				)
				VALUES
				(
					 #attributes.row_id#,
					 2,
					 #amount_value#,
					 #counter#,
					 #sub_counter#
				 )
			</cfquery>
		</cfif>
	</cfloop>					
</cfloop>

<script type="text/javascript">
	window.close();
</script>
