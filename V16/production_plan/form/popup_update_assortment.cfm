<!--- 
	Bu sayfalar teklif ve siparis basketlerinde listelenecek olan 
	asorti ile ilgili islemler fakat bu sayfalari kullanilip kullanilmamasi implementasyona irakildigindan sistem icinde 
	kullanilmayabilir. ARZU BT 06112003	
--->

<cfinclude template="../query/get_prod_property_detail.cfm"> 
   <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" height="100%">
    <tr clasS="color-border">
      <td>
        <table cellspacing="1" cellpadding="2" width="100%" border="0" height="100%">
			<tr class="color-list">
				  <td height="35" class="headbold">&nbsp;<cf_get_lang dictionary_id='36684.Dağılımlar'></td>
			</tr>
		 <tr class="color-row">
		<td valign="top">	
		<cfif get_product_property.recordcount and len(attributes.order_row_id)>			
			<cfform name="add_assortment" method="post" action="#request.self#?fuseaction=prod.emptypopup_upd_product_assortment">
			<input name="row_id" id="row_id" type="hidden" value="<cfoutput>#attributes.order_row_id#</cfoutput>">	
			<input name="stock_id" id="stock_id" type="hidden" value="<cfoutput>#attributes.stock_id#</cfoutput>">		
			<table>
				<tr>
					<cfloop query="get_product_property">
						<td><cfoutput>#PROPERTY#</cfoutput></td>
					</cfloop>
				</tr>
				<tr>
					<cfloop query="get_product_property">
						<cfset counter = get_product_property.PROPERTY_ID[currentrow]>
						<cfset top_currentrow=currentrow>
						<td valign="top" >
							<table width="100%" >
								<cfquery name="get_property_detail" datasource="#DSN1#">
									SELECT * FROM PRODUCT_PROPERTY_DETAIL WHERE PRPT_ID = #get_product_property.PROPERTY_ID[top_currentrow]# ORDER BY PRPT_ID,PROPERTY_DETAIL_ID
								</cfquery>
								<cfloop query="get_property_detail">
									<cfset sub_counter = get_property_detail.PROPERTY_DETAIL_ID[currentrow]>
									<tr>
										<td><cfoutput>#PROPERTY_DETAIL#</cfoutput></td>
										<td>
											<cfset amount_property = get_property(counter,sub_counter,order_row_id)>
											<cfsavecontent variable="message"><cf_get_lang dictionary_id='52318.Sayısal Değer Girmelisiniz'></cfsavecontent>
											<cfinput name="validation_#counter#_#sub_counter#" validate="integer" message="#message#" value="#amount_property#"style="width=30;">
										</td>
									</tr>
								</cfloop>					
							</table>
						</td>
					</cfloop>
				</tr>
				<tr>
					<td colspan="<cfoutput>#get_product_property.recordcount#</cfoutput>" align="right" style="text-align:right;" >
						<cf_workcube_buttons is_upd='0' >
					</td>
				</tr>
			</table>
			</cfform>
		<cfelse>
			<br/>&nbsp;&nbsp;<cf_get_lang dictionary_id='36685.Kayıtlı Ürün Özelliği veya Asorti Bulunamadı'>
		</cfif>
		</td>
			</tr>
		</table>
	</td>
	</tr>
</table> 
