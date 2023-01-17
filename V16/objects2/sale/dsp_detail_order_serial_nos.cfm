<cfif get_order_det.is_processed eq 1>
	<cfquery name="get_order_ships" datasource="#dsn3#">
			SELECT 
				S.SHIP_ID,
				S.SHIP_TYPE
			FROM
				#dsn2_alias#.SHIP S,
				ORDERS_SHIP OS
			WHERE
				S.SHIP_ID = OS.SHIP_ID AND
				OS.ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_order_det.order_id#">
	</cfquery>
	<cfif get_order_ships.recordcount>
	<table>
		<tr>
			<td class="headbold"><cf_get_lang no ='1453.Seri No Tanımlamaları'></td>
		</tr>
		<cfform name="add_serial_no" action="" method="post">
			<input type="hidden" name="ship_id" id="ship_id" value="<cfoutput>#get_order_ships.SHIP_ID#</cfoutput>">
			<input type="hidden" name="ship_type" id="ship_type" value="<cfoutput>#get_order_ships.SHIP_TYPE#</cfoutput>">
			<tr>
				<td>
					<table>
						<tr>
							<td><cf_get_lang_main no='809.Ürün Adı'></td>
							<td><cf_get_lang no ='637.Garanti Kategorisi'></td>
							<td><cf_get_lang_main no ='225.Seri No'></td>
						</tr>
						<cfoutput query="get_order_row">
							<cfset product_name_ = PRODUCT_NAME>
							<cfset product_id_ = PRODUCT_ID>
							<cfset sira_ = quantity>
							<cfloop from="1" to="#sira_#" index="cc">
								<tr>
									<td>#product_name_#</td>
									<td></td>
									<td><input type="text" name="serial_no_#product_id_#_#cc#" id="serial_no_#product_id_#_#cc#" value=""></td>
								</tr>
							</cfloop>
						</cfoutput>
					</table>
				</td>
			</tr>
		</cfform>
	</table>
	</cfif>
</cfif>
