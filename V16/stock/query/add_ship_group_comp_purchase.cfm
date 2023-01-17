<cfquery name="get_per" datasource="#DSN#" >
	SELECT 
    	* 
    FROM 
    	SETUP_PERIOD 
    WHERE 
    	PERIOD_ID = #attributes.period_id#
</cfquery>

<cfquery name="get_per_old" datasource="#DSN#" >
	SELECT 
    	* 
    FROM 
    	SETUP_PERIOD 
    WHERE 
    	PERIOD_ID = #attributes.old_period_id#
</cfquery>

<cfscript>
	new_dsn3 = '#dsn#_#get_per.OUR_COMPANY_ID#';			
	if (database_type IS 'MSSQL') {new_dsn2 = '#dsn#_#get_per.PERIOD_YEAR#_#get_per.OUR_COMPANY_ID#';new_dsn2_alias='#new_dsn2#';new_dsn3_alias = '#dsn3#';}
	else if (database_type IS 'DB2') {new_dsn2 = '#dsn#_#get_per.OUR_COMPANY_ID#_#right(get_per.PERIOD_YEAR,2)#';new_dsn2_alias='#new_dsn2#_dbo';new_dsn3_alias = '#dsn3#_dbo';}

	if (database_type IS 'MSSQL') {old_dsn2 = '#dsn#_#get_per_old.PERIOD_YEAR#_#get_per_old.OUR_COMPANY_ID#';old_dsn2_alias='#old_dsn2#';}
	else if (database_type IS 'DB2') {old_dsn2 = '#dsn#_#get_per_old.OUR_COMPANY_ID#_#right(get_per_old.PERIOD_YEAR,2)#';old_dsn2_alias='#old_dsn2#_dbo';}
</cfscript>
	
<cfquery name="get_ship" datasource="#old_dsn2#">
	SELECT * FROM SHIP WHERE SHIP_ID = #attributes.ship_id# AND IS_EXPORTED IS NULL
</cfquery>
<cfif get_ship.recordcount>
	<cfquery name="get_ship_row" datasource="#old_dsn2#">
		SELECT * FROM SHIP_ROW WHERE SHIP_ID = #attributes.ship_id#
	</cfquery>
	<!--- irsaliyenin kaydedileceği firmada irsaliyedeki ürünlerin tanımlı olup olmadığı kontrol ediliyor --->
	 <cfif get_ship_row.recordcount>
			<cfoutput query="get_ship_row">
			<cfquery name="control_other_comp_product" datasource="#dsn1#">
				SELECT 
					*
				FROM
					PRODUCT_OUR_COMPANY
				WHERE
					PRODUCT_ID=#get_ship_row.PRODUCT_ID#
					AND OUR_COMPANY_ID=#session.ep.company_id#
			</cfquery>
			<cfif not control_other_comp_product.recordcount>
				<cfquery name="get_prod_name" datasource="#dsn1#">
					SELECT PRODUCT_NAME FROM PRODUCT WHERE PRODUCT_ID=#get_ship_row.PRODUCT_ID#
				</cfquery>
				<script type="text/javascript">
					alert("<cf_get_lang no ='536.Bu irsaliyedeki ürün,seçtiğiniz  şirkette tanımlı değil'>.<cf_get_lang_main no ='245.Ürün'> :#get_prod_name.PRODUCT_NAME#");
					window.opener.reload;
					window.close();
				</script>
				<cfabort>
			</cfif>
		</cfoutput>
	</cfif> 
	<!--- //irsaliyenin kaydedileceği firmada irsaliyedeki ürünlerin tanımlı olup olmadığı kontrol ediliyor --->
	<cfquery name="get_ship_money" datasource="#old_dsn2#">
		SELECT * FROM SHIP_MONEY WHERE ACTION_ID = #attributes.ship_id#
	</cfquery>
	<cfquery name="get_process_type" datasource="#new_dsn3#">
		SELECT 
			PROCESS_TYPE,
			IS_CARI,
			IS_ACCOUNT,
			IS_STOCK_ACTION
		 FROM 
			SETUP_PROCESS_CAT 
		WHERE 
			PROCESS_CAT_ID = #form.process_cat#
	</cfquery>
	
	<cfif not len(attributes.location_id) >
		<cfset attributes.location_id = "NULL" >
	</cfif>
	
	<cflock name="#CreateUUID()#" timeout="60">
		<cftransaction>
		<cfif isdate(get_ship.DELIVER_DATE)>
			<cfset attributes.deliver_date = CreateODBCDateTime(get_ship.DELIVER_DATE)>	
		</cfif>
		<cfset attributes.ship_date = CreateODBCDateTime(get_ship.SHIP_DATE)>
		<cfquery name="ADD_PURCHASE" datasource="#new_dsn2#" result="MAX_ID">
			INSERT INTO
				SHIP
				(
					PURCHASE_SALES,
					SHIP_NUMBER,
					SHIP_TYPE,
					PROCESS_CAT,
					<cfif len(get_ship.SHIP_METHOD)>SHIP_METHOD,</cfif>
					SHIP_DATE,
					COMPANY_ID,
					PARTNER_ID,	
					ADDRESS,
					DELIVER_DATE,
					DELIVER_EMP,
					DELIVER_EMP_ID,
					DISCOUNTTOTAL,
					NETTOTAL,
					GROSSTOTAL,
					TAXTOTAL,
					DEPARTMENT_IN,
					LOCATION_IN,
					RECORD_DATE,
					IS_WITH_SHIP,
					RECORD_EMP,
					ORDER_ID
				)
			VALUES
				(
					0,
					'#get_ship.SHIP_NUMBER#',
					#get_process_type.PROCESS_TYPE#,
					#form.process_cat#,
					<cfif len(get_ship.SHIP_METHOD)>#get_ship.SHIP_METHOD#,</cfif>
					#attributes.ship_date#,
					#attributes.company_id#,
					#attributes.partner_id#,
					'#attributes.comp_address#',
					<cfif isdate(get_ship.DELIVER_DATE)>#attributes.deliver_date#,<cfelse>NULL,</cfif>
					<cfif isdefined("attributes.deliver_get") and len(attributes.deliver_get)>'#attributes.deliver_get#'<cfelse>NULL</cfif>,
					<cfif isdefined("attributes.deliver_get_id") and len(attributes.deliver_get_id)>#attributes.deliver_get_id#<cfelse>NULL</cfif>,
					<cfif len(get_ship.DISCOUNTTOTAL)>#get_ship.DISCOUNTTOTAL#,<cfelse>0,</cfif>
					<cfif len(get_ship.NETTOTAL)>#get_ship.NETTOTAL#,<cfelse>0,</cfif>
					<cfif len(get_ship.GROSSTOTAL)>#get_ship.GROSSTOTAL#,<cfelse>0,</cfif>
					<cfif len(get_ship.TAXTOTAL)>#get_ship.TAXTOTAL#,<cfelse>0,</cfif>
					#attributes.department_id#,
					#attributes.location_id#,
					#now()#,
					0,
					#session.ep.userid#,
					NULL
				)
		</cfquery>
		<cfloop from="1" to="#get_ship_row.recordcount#" index="i">
			<cfquery name="ADD_SHIP_ROW" datasource="#new_dsn2#">
				INSERT INTO
					SHIP_ROW
					(
						NAME_PRODUCT,
						PAYMETHOD_ID, 
						SHIP_ID,
						STOCK_ID,
						PRODUCT_ID,
						AMOUNT,
						UNIT,
						UNIT_ID,				
						TAX,
					<cfif len(get_ship_row.PRICE[i])>
						PRICE,
					</cfif>
						PURCHASE_SALES,
						DISCOUNT,
						DISCOUNT2,
						DISCOUNT3,
						DISCOUNT4,
						DISCOUNT5,
						DISCOUNT6,
						DISCOUNT7,
						DISCOUNT8,
						DISCOUNT9,
						DISCOUNT10,
						DISCOUNTTOTAL,
						GROSSTOTAL,
						NETTOTAL,
						TAXTOTAL,						
						DELIVER_DEPT,
						DELIVER_LOC,
					<cfif len(get_ship_row.SPECT_VAR_ID[i]) >					
						SPECT_VAR_ID,
						SPECT_VAR_NAME,
					</cfif>
						LOT_NO,
						OTHER_MONEY,
						OTHER_MONEY_VALUE,				
						PRICE_OTHER,
						OTHER_MONEY_GROSS_TOTAL,
						IS_PROMOTION
					)
				VALUES
					(
						'#get_ship_row.NAME_PRODUCT[i]#',
						<cfif len(get_ship_row.PAYMETHOD_ID[i])>#get_ship_row.PAYMETHOD_ID[i]#,<cfelse>NULL,</cfif>
						#MAX_ID.IDENTITYCOL#,
						#get_ship_row.STOCK_ID[i]#,
						#get_ship_row.PRODUCT_ID[i]#,
						#get_ship_row.AMOUNT[i]#,
						'#get_ship_row.UNIT[i]#',
						<cfif len(get_ship_row.UNIT_ID[i]) >#get_ship_row.UNIT_ID[i]#,<cfelse>NULL,</cfif>
						#get_ship_row.TAX[i]#,
						<cfif len(get_ship_row.PRICE[i])>
							#get_ship_row.PRICE[i]#,
						</cfif>
						0,
						<cfif len(get_ship_row.DISCOUNT[i])>#get_ship_row.DISCOUNT[i]#<cfelse>0</cfif>,
						<cfif len(get_ship_row.DISCOUNT2[i])>#get_ship_row.DISCOUNT2[i]#<cfelse>0</cfif>,
						<cfif len(get_ship_row.DISCOUNT3[i])>#get_ship_row.DISCOUNT3[i]#<cfelse>0</cfif>,
						<cfif len(get_ship_row.DISCOUNT4[i])>#get_ship_row.DISCOUNT4[i]#<cfelse>0</cfif>,
						<cfif len(get_ship_row.DISCOUNT5[i])>#get_ship_row.DISCOUNT5[i]#<cfelse>0</cfif>,
						<cfif len(get_ship_row.DISCOUNT6[i])>#get_ship_row.DISCOUNT6[i]#<cfelse>0</cfif>,
						<cfif len(get_ship_row.DISCOUNT7[i])>#get_ship_row.DISCOUNT7[i]#<cfelse>0</cfif>,
						<cfif len(get_ship_row.DISCOUNT8[i])>#get_ship_row.DISCOUNT8[i]#<cfelse>0</cfif>,
						<cfif len(get_ship_row.DISCOUNT9[i])>#get_ship_row.DISCOUNT9[i]#<cfelse>0</cfif>,
						<cfif len(get_ship_row.DISCOUNT10[i])>#get_ship_row.DISCOUNT10[i]#<cfelse>0</cfif>,
						<cfif len(get_ship_row.DISCOUNTTOTAL[i])>#get_ship_row.DISCOUNTTOTAL[i]#<cfelse>0</cfif>,
						<cfif len(get_ship_row.GROSSTOTAL[i])>#get_ship_row.GROSSTOTAL[i]#<cfelse>0</cfif>,
						<cfif len(get_ship_row.NETTOTAL[i])>#get_ship_row.NETTOTAL[i]#<cfelse>0</cfif>,
						<cfif len(get_ship_row.TAXTOTAL[i])>#get_ship_row.TAXTOTAL[i]#<cfelse>0</cfif>,
						#attributes.department_id#,
						#attributes.location_id#,
					<cfif len(get_ship_row.SPECT_VAR_ID[i]) >
						#get_ship_row.SPECT_VAR_ID[i]#,
						'#get_ship_row.SPECT_VAR_NAME[i]#',
					</cfif>
					<cfif len(get_ship_row.LOT_NO[i])>#get_ship_row.LOT_NO[i]#<cfelse>NULL</cfif>,
					<cfif len(get_ship_row.OTHER_MONEY[i])>'#get_ship_row.OTHER_MONEY[i]#'<cfelse>NULL</cfif>,
					<cfif len(get_ship_row.OTHER_MONEY_VALUE[i])>#get_ship_row.OTHER_MONEY_VALUE[i]#<cfelse>NULL</cfif>,
					<cfif len(get_ship_row.PRICE_OTHER[i])>#get_ship_row.PRICE_OTHER[i]#<cfelse>NULL</cfif>,
					<cfif len(get_ship_row.OTHER_MONEY_GROSS_TOTAL[i])>#get_ship_row.OTHER_MONEY_GROSS_TOTAL[i]#<cfelse>0</cfif>,
						0
					)
			</cfquery>
			<cfif get_process_type.IS_STOCK_ACTION eq 1><!--- Stok hareketi yapılsın --->
				<cfquery name="GET_UNIT" datasource="#new_dsn2#">
					SELECT 
						ADD_UNIT,
						MULTIPLIER,
						MAIN_UNIT,
						PRODUCT_UNIT_ID
					FROM
						#new_dsn3_alias#.PRODUCT_UNIT 
					WHERE 
						PRODUCT_ID = #get_ship_row.PRODUCT_ID[i]# AND
						ADD_UNIT = '#get_ship_row.UNIT[i]#'
				</cfquery>
				<cfif get_unit.recordcount  and len(get_unit.multiplier) >
					<cfset multi = get_unit.multiplier*get_ship_row.AMOUNT[i]>
				<cfelse>
					<cfset multi = get_ship_row.AMOUNT[i]>
				</cfif>
				<cfquery name="ADD_STOCK_ROW" datasource="#new_DSN2#">
					INSERT INTO 
						STOCKS_ROW
						(
							UPD_ID,
							PRODUCT_ID,
							STOCK_ID,
							PROCESS_TYPE,
							STOCK_IN,
							STORE,
							STORE_LOCATION,
							PROCESS_DATE,
						<cfif len(get_ship_row.SPECT_VAR_ID[i]) >		
							SPECT_VAR_ID,
						</cfif>
							LOT_NO
						)
						VALUES
						(
							#MAX_ID.IDENTITYCOL#,
							#get_ship_row.PRODUCT_ID[i]#,
							#get_ship_row.STOCK_ID[i]#,				
							#get_process_type.PROCESS_TYPE#,
							#multi#,
							#attributes.department_id#,
							#attributes.location_id#,
							<cfif isdate(get_ship.DELIVER_DATE)>#attributes.deliver_date#,<cfelse>NULL,</cfif>
							<cfif len(get_ship_row.SPECT_VAR_ID[i])>#get_ship_row.SPECT_VAR_ID[i]#,</cfif>
							<cfif len(get_ship_row.LOT_NO[i])>#get_ship_row.lot_no[i]#<cfelse>NULL</cfif>
						)
				</cfquery>
			</cfif>
		</cfloop>
		<cfoutput query="get_ship_money">
			<cfquery name="add_mon" datasource="#new_DSN2#">
				INSERT INTO SHIP_MONEY
				(
					MONEY_TYPE,
					RATE2,
					RATE1,
					IS_SELECTED,
					ACTION_ID
				)
				VALUES
				(
					'#MONEY_TYPE#',
					#RATE2#,
					#RATE1#,
					#IS_SELECTED#,
					#MAX_ID.IDENTITYCOL#
				)
			</cfquery>
		</cfoutput>	
		
		<cfquery name="ADD_GROUP_SHIP" datasource="#new_dsn2#">
			UPDATE #old_dsn2_alias#.SHIP SET IS_EXPORTED = 1 WHERE SHIP_ID = #attributes.ship_id#
		</cfquery>
		
		</cftransaction>
	</cflock>
	<script type="text/javascript">
		location.href=document.referrer;
	</script>
<cfelse>
	<script type="text/javascript">
		alert("<cf_get_lang dictionary_id ='45726.Bu İrsaliye Daha Önce Aktarılmış'>");
		location.href=document.referrer;
	</script>
	<cfabort>
</cfif>
