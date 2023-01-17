<cfquery name="get_period" datasource="#dsn#">
	SELECT * FROM SETUP_PERIOD
</cfquery>
<cfloop query="get_period">
	<cfset period_index = get_period.currentrow >
	<cfif database_type eq "MSSQL" >
		<cfset dsn2 = "#dsn#_#get_period.PERIOD_YEAR#_#get_period.OUR_COMPANY_ID#">
	<cfelseif database_type eq "DB2">
		<cfset dsn2 = "#dsn#_#get_period.OUR_COMPANY_ID#_#MID(get_period.PERIOD_YEAR,3,2)#">
	</cfif>
	<cfset dsn3 = "#dsn#_#get_period.OUR_COMPANY_ID#">

	<cfquery name="get_sales_imports" datasource="#dsn2#">
		SELECT
			SAYIMLAR.GIRIS_ID,
			SAYIMLAR.FILE_NAME,
			SAYIMLAR.RECORD_DATE,
			SAYIMLAR.RECORD_EMP,
			SAYIMLAR.DESCRIPTION,
			#DSN_ALIAS#.EMPLOYEES.EMPLOYEE_NAME,
			#DSN_ALIAS#.EMPLOYEES.EMPLOYEE_SURNAME,
			#DSN_ALIAS#.BRANCH.BRANCH_ID,
			#DSN_ALIAS#.BRANCH.BRANCH_NAME
		FROM
			SAYIMLAR,
			#DSN_ALIAS#.EMPLOYEES,
			#DSN_ALIAS#.BRANCH
		WHERE
			#DSN_ALIAS#.BRANCH.BRANCH_ID = SAYIMLAR.BRANCH_ID AND
			SAYIMLAR.RECORD_EMP = #DSN_ALIAS#.EMPLOYEES.EMPLOYEE_ID AND
			SAYIMLAR.TOPLAM_MALIYET IS NULL
		ORDER BY
			SAYIMLAR.RECORD_DATE DESC
	</cfquery>
	<cfset dosya_yolu = "#upload_folder#store#dir_seperator#">
	<cfoutput query="get_sales_imports">
		<cftry>
		<cfset dosya = "">
		<cfset sayim_no = GIRIS_ID>
		<cffile action="read" file="#dosya_yolu##file_name#" variable="dosya">
		<cfscript>
			CRLF = Chr(13)&Chr(10); // satır atlama karakteri
			dosya = ListToArray(dosya,CRLF);
			line_count = ArrayLen(dosya);
		</cfscript>
		<cfset barcod_list = "">
		<cfloop from="1" to="#line_count#" index="kall">
			<cfif len(ListGetAt(dosya[kall],1,";"))>
				<cfset barcod_list = ListAppend(barcod_list,"'#ListGetAt(dosya[kall],1,";")#'")>
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
				GSB.BARCODE IN (#preservesinglequotes(barcod_list)#) AND
				PS.PURCHASESALES = 0 AND
				PS.PRICESTANDART_STATUS = 1 AND
				PU.IS_MAIN = 1 AND
				P.PRODUCT_ID = S.PRODUCT_ID AND
				S.STOCK_ID = GSB.STOCK_ID AND
				PS.PRODUCT_ID = P.PRODUCT_ID AND
				PS.UNIT_ID = PU.PRODUCT_UNIT_ID AND
				PU.PRODUCT_ID = P.PRODUCT_ID
		</cfquery>
		<cfset net_total = 0>
		<cfquery name="delete_sayim_satirlar" datasource="#DSN2#">
			DELETE FROM SAYIM_SATIRLAR WHERE SAYIM_ID = #sayim_no#
		</cfquery>
		<cfloop from="1" to="#line_count#" index="k">
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
					MAIN_UNIT
				FROM
					get_product_main_all
				WHERE
					BARCODE = '#ListGetAt(dosya[k],1,";")#'
			</cfquery>
			<cfif get_product_main.recordcount >
				<cfloop query="get_product_main">
					<cfif MAIN_UNIT is "Kg">
						<cfset satir_toplam = (trim(ListGetAt(dosya[k],2,";")) * price) / 1000>
						<cfset miktar_sp = trim(ListGetAt(dosya[k],2,";")) / 1000>
					<cfelse>
						<cfset satir_toplam = trim(ListGetAt(dosya[k],2,";")) * price>
						<cfset miktar_sp = trim(ListGetAt(dosya[k],2,";"))>
					</cfif>
					<cfset barcode_str = ListGetAt(dosya[k],1,";")>
					<!--- barcode : #ListGetAt(dosya[k],1,";")#<br/>
					k : #k#<br/>
					stock_code : #stock_code#<br/>
					product : #product_name# #property#<br/>
					manufactur_code : #manufact_code#<br/>
					product_id : #product_id#<br/>
					stok_id : #stock_id#<br/>
					miktar : #ListGetAt(dosya[k],2,";")#<br/>
					miktar_sp : #miktar_sp#<br/>
					Satır Toplam : #TLFormat(satir_toplam)# #money#<br/><br/> --->
					<cfset net_total = net_total + satir_toplam>
					<cfquery name="add_sayim_satirlar" datasource="#dsn2#">
						INSERT
							SAYIM_SATIRLAR(
								SAYIM_ID,
								PRODUCT_ID,
								STOCK_ID,
								MIKTAR,
								STANDART_ALIS,
								BARCODE,
								PRODUCT_NAME,
								STOCK_PROPERTY
							)
							VALUES(
								#sayim_no#,
								#product_id#,
								#stock_id#,
								#miktar_sp#,
								#price#,
								'#barcode_str#',
								'#product_name#',
								'#property#'
							)
					</cfquery>
				</cfloop>
			</cfif>
		</cfloop>
		<cfquery name="update_sayim" datasource="#dsn2#">
			UPDATE 
				SAYIMLAR 
			SET 
				TOPLAM_MALIYET = #net_total#
			WHERE 
				GIRIS_ID = #GIRIS_ID#
		</cfquery>
		<cfcatch>
			<cftry>
				<cfmail to="#listfirst(server_detail)#" from="#listlast(server_detail)#<#listfirst(server_detail)#>" subject="#cgi.SERVER_NAME# Sayim İsleme Hata Bildirim Mesaji" type="html">
					#BRANCH_NAME# Şube #GIRIS_ID# ID li (#DESCRIPTION#) sayim dosyasında problem oluştu..<br/> - (#get_period.PERIOD[period_index]#)
				</cfmail>
				<cfcatch></cfcatch>
			</cftry>
		</cfcatch>
		</cftry>
	</cfoutput>
</cfloop>
