<cfif isdefined("attributes.file_id")>
	<cfquery name="delete_sayim_satirlar" datasource="#DSN2#">
		DELETE FROM SAYIM_SATIRLAR WHERE SAYIM_ID = #attributes.file_id#
	</cfquery>
<cfelse>
	<cflock name="#CreateUUID()#" timeout="20">
		<cftransaction>
			<cfquery name="add_sayim" datasource="#DSN2#">
				INSERT
					SAYIMLAR
					(
						BRANCH_ID,
						LOCATION_IN,
						DEPARTMENT_IN,
						FILE_NAME,
						FILE_SERVER_ID,
						RECORD_DATE,
						RECORD_EMP,
						DESCRIPTION
					)
					VALUES
					(
						#attributes.branch_id#,
						#attributes.location_in#,
						#attributes.department_in#,
						'#attributes.file_name#',
						#fusebox.server_machine#,
						#now()#,
						#session.ep.userid#,
						'#attributes.description#'
					)
			</cfquery>
			<cfquery name="get_sayim" datasource="#DSN2#">
				SELECT MAX(GIRIS_ID) AS SAYIM_ID FROM SAYIMLAR
			</cfquery>
		</cftransaction>
	</cflock>
</cfif>
<cfset net_total = 0>
<cfset barcod_list = "">
<cfloop from="1" to="#attributes.line_count#" index="i">
<cfif isdefined("attributes.miktar_#i#")>
	<cfset temp_barcod = evaluate("attributes.barcode_"&i)>
	<cfif len(temp_barcod)>
		<cfset barcod_list = ListAppend(barcod_list,temp_barcod,',')>
	</cfif>
<cfelse>
	<cfset barcod_list = ListAppend(barcod_list,' ',',')>
</cfif>
</cfloop>
<cfquery name="get_product_main_all" datasource="#dsn3#">
	SELECT
		GSB.BARCODE,
		S.STOCK_ID,
		S.PRODUCT_ID,
		S.STOCK_CODE,
		S.PROPERTY,					
		P.PRODUCT_NAME,
		P.MANUFACT_CODE,
		PS.PRICE,
		PS.MONEY,
		PU.MAIN_UNIT,
		PS.PURCHASESALES,
		PS.PRICESTANDART_STATUS,
		PU.IS_MAIN
	FROM
		PRODUCT P,
		STOCKS AS S,
		GET_STOCK_BARCODES AS GSB,
		PRICE_STANDART AS PS,
		PRODUCT_UNIT AS PU
	WHERE
		GSB.BARCODE IN (#listqualify(barcod_list,"'")#) AND
		PS.PURCHASESALES = 0 AND
		PS.PRICESTANDART_STATUS = 1 AND
		PU.IS_MAIN = 1 AND
		P.PRODUCT_ID = S.PRODUCT_ID AND
		S.STOCK_ID = GSB.STOCK_ID AND
		PS.PRODUCT_ID = P.PRODUCT_ID AND
		PS.UNIT_ID = PU.PRODUCT_UNIT_ID AND
		PU.PRODUCT_ID = P.PRODUCT_ID
</cfquery>

<cfloop from="1" to="#attributes.line_count#" index="i">
<cfif isdefined("attributes.miktar_#i#")>
		<cfset temp_barcod = trim(ListGetAt(barcod_list,i,","))>
			<cfquery name="get_product_main" dbtype="query">
				SELECT
					BARCODE,
					STOCK_ID,
					PRODUCT_ID,
					STOCK_CODE,
					PROPERTY,					
					PRODUCT_NAME,
					MANUFACT_CODE,
					PRICE,
					MONEY,
					MAIN_UNIT,
					PURCHASESALES,
					PRICESTANDART_STATUS,
					IS_MAIN
				FROM
					get_product_main_all
				WHERE
					BARCODE = '#temp_barcod#'
			</cfquery>
		<cfif not isdefined("attributes.file_id")>
			<cfif i is 1>
				<cffile action='write' output='#evaluate("attributes.barcode_"&i)#;#evaluate("attributes.miktar_"&i)#' file='#attributes.file_path_and_name#' addnewline='yes' nameconflict="overwrite">
			<cfelse>
				<cffile action='append' output='#evaluate("attributes.barcode_"&i)#;#evaluate("attributes.miktar_"&i)#' file='#attributes.file_path_and_name#' addnewline='yes'>
			</cfif>
		</cfif>
		<cfset satir_toplam = trim(evaluate("attributes.miktar_"&i)) * get_product_main.price>
		<cfset miktar_sp = trim(evaluate("attributes.miktar_"&i))>
		<cfif get_product_main.MAIN_UNIT is "Kg">
			<cfset satir_toplam = satir_toplam/1000>
			<cfset miktar_sp = miktar_sp/1000>
		</cfif>
		<cfif get_product_main.money neq session.ep.money>
			<cfquery name="get_money_rate" datasource="#dsn#" maxrows="1">
				SELECT
					RATE2
				FROM
					SETUP_MONEY
				WHERE
					COMPANY_ID =#session.ep.company_id# AND
					PERIOD_ID = #session.ep.period_id# AND
					MONEY_STATUS = 1 AND
					MONEY='#get_product_main.money#'
				ORDER BY
					MONEY_ID DESC
			</cfquery>
			<cfif get_money_rate.recordcount>
				<cfset satir_toplam=satir_toplam*get_money_rate.rate2>
			</cfif>
		<!--- kod yazilacak --->
		</cfif>
		<cfset net_total = net_total + satir_toplam>
		<cfquery name="add_sayim_satirlar" datasource="#dsn2#">
			INSERT
				SAYIM_SATIRLAR
				(
					SAYIM_ID,
					PRODUCT_ID,
					STOCK_ID,
					MIKTAR,
					STANDART_ALIS,
					BARCODE,
					PRODUCT_NAME,
					STOCK_PROPERTY,
					OTHER_MONEY,
					MONEY_RATE
				)
				VALUES
				(
					<cfif isdefined("attributes.file_id")>#attributes.file_id#<cfelse>#get_sayim.SAYIM_ID#</cfif>,
					#get_product_main.product_id#,
					#get_product_main.stock_id#,
					#miktar_sp#,
					#get_product_main.price#,
					'#temp_barcod#',
					'#get_product_main.product_name#',
					'#get_product_main.property#',
					'#get_product_main.money#',
					<cfif get_product_main.money neq session.ep.money>#get_money_rate.rate2#<cfelse>1</cfif>
				)
		</cfquery> 
	</cfif>
</cfloop>

<cfif isdefined("attributes.file_id")>
	<cfquery name="add_sayim" datasource="#DSN2#">
		UPDATE
			SAYIMLAR
		SET 
			RECORD_DATE = #now()#,
			RECORD_EMP = #session.ep.userid#,
			TOPLAM_MALIYET = #net_total#
		WHERE
			GIRIS_ID = #attributes.file_id#
	</cfquery>
	<cfoutput>
		<script type="text/javascript">
			alert("<cf_get_lang no='41.Dosyanız Başarıyla Güncellendi'>.");
			window.location='#request.self#?fuseaction=store.list_sayim';
		</script>
	</cfoutput>
<cfelse>
	<cfquery name="add_sayim" datasource="#DSN2#">
		UPDATE
			SAYIMLAR
		SET 
			RECORD_DATE = #now()#,
			RECORD_EMP = #session.ep.userid#,
			TOPLAM_MALIYET = #net_total#
		WHERE
			GIRIS_ID = #get_sayim.SAYIM_ID#
	</cfquery>
	<cfoutput>
		<script type="text/javascript">
			alert("<cf_get_lang no='42.Dosyanız Başarıyla Yüklendi'>.");
			window.location='#request.self#?fuseaction=store.list_sayim';
		</script>
	</cfoutput>
</cfif>

