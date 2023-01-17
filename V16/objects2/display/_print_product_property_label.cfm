<cfparam name="attributes.print_type" default="">
<cfset adres="">
	<cfif len(attributes.print_type)>
<cfset adres="#adres#&print_type=#attributes.print_type#">
</cfif>
<cfquery name="GET_PRODUCT" datasource="#dsn3#">
	SELECT * FROM PRODUCT WHERE PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_id#">
</cfquery>
<cfquery name="GET_PROPERTY" datasource="#DSN1#">
	SELECT 
		PRODUCT_DT_PROPERTIES.DETAIL,
		PRODUCT_DT_PROPERTIES.VARIATION_ID,
		PRODUCT_PROPERTY.PROPERTY
	FROM 
		PRODUCT_DT_PROPERTIES,
		PRODUCT_PROPERTY,
		#dsn3_alias#.PRODUCT PRODUCT
	WHERE 
		PRODUCT.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_id#"> AND
		PRODUCT_DT_PROPERTIES.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_id#"> AND
		PRODUCT_DT_PROPERTIES.PROPERTY_ID = PRODUCT_PROPERTY.PROPERTY_ID AND
		PRODUCT_DT_PROPERTIES.IS_INTERNET = 1
	ORDER BY	
		PRODUCT_DT_PROPERTIES.LINE_VALUE,
		PRODUCT_DT_PROPERTIES.PRODUCT_DT_PROPERTY_ID
</cfquery>
<!-- sil -->
<cfform name="change_width" method="post" action="#request.self#?fuseaction=objects2.popup_print_product_label&product_id=#attributes.product_id#">
<table align="right">
	<tr>
		<td>
			<select name="print_type" id="print_type" style="width:150px" onChange="change_width.submit();">
				<option value=""><cf_get_lang_main no='322.Etiket Seçiniz'></option>
				<option value="1" <cfif attributes.print_type eq 1>selected</cfif>>10x10 <cf_get_lang no='362.Etiket'></option>
				<option value="2" <cfif attributes.print_type eq 2>selected</cfif>>7x6 <cf_get_lang no='362.Etiket'></option>
			</select>
		</td>
		<td align="right" style="text-align:right;"><cf_workcube_file_action pdf='0' mail='0' doc='0' print='1' trail='0'></td>
	</tr>
</table>
<!-- sil -->
<br/><br/><br/>
<table align="center" <cfif attributes.print_type eq 1>style="width:100mm;height:100mm" <cfelse>style="width:60mm;height:70mm"</cfif>>
<style type="text/css">.printbold {font-size: 8px; color: #000000}</style>
<style type="text/css">.print {font-size: 8px; color: #000000}</style>
	<cfoutput query="get_product">
	<tr>
		<td colspan="2">
		<table width="100%">
			<tr>
				<td class="printbold" ><cf_get_lang_main no='245.Ürün'></td>
				<td colspan="2" class="printbold" >#get_product.product_name#</td>
			</tr>
			<tr valign="top">
				<td class="printbold"><cf_get_lang_main no='672.Fiyat'></td>
					<cfinclude template="../query/get_product_price.cfm">
					<cfquery name="get_money_info" datasource="#dsn2#">
						SELECT (RATE2/RATE1) RATE FROM SETUP_MONEY WHERE MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#get_price.money#">
					</cfquery>
				<td  class="print">#TLFormat(get_price.price)#	#get_price.money# + KDV</td>
			</tr>
		</table>
	</tr>
	</cfoutput>
	<cfset count_ = 0>
	<cfif GET_PROPERTY.recordcount>
		<cfif attributes.print_type eq 1><cfset this_maxrow = 30>
		<cfelseif attributes.print_type eq 2><cfset this_maxrow = 15>
		<cfelse><cfset this_maxrow = 12>
		</cfif>
			<tr>
				<td colspan="2" valign="top">
				<table width="100%">
					<tr>
						<td <cfif attributes.print_type eq 1>width="100"<cfelse>width="80"</cfif>class="printbold" bgcolor="999999"><cf_get_lang_main no='220.Özellik'></td>
						<td class="printbold" bgcolor="999999"><cf_get_lang_main no='217.Açıklama'></td>
					</tr>
					<cfoutput query="GET_PROPERTY" maxrows="#this_maxrow#">
						<cfif len(VARIATION_ID) or len(DETAIL)>
							<cfset count_ = count_ + 1>
							<tr <cfif count_ mod 2>bgcolor="D2D2D2"</cfif>>
								<td class="printbold">#PROPERTY#</td>
								<td  class="print">
									<cfif len(VARIATION_ID)>
										<cfquery name="get_variation" datasource="#DSN1#">
											SELECT PROPERTY_DETAIL FROM PRODUCT_PROPERTY_DETAIL WHERE PROPERTY_DETAIL_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#variation_id#">
										</cfquery>
										<cfif get_variation.recordcount>#get_variation.PROPERTY_DETAIL#</cfif>
									</cfif>
									#DETAIL#
								</td>
							</tr>
						</cfif>
					</cfoutput>
				</table>
				</td>
			</tr>
		</cfif>
	</table>
</cfform>
