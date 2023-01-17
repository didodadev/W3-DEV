<!--- stock_identity_type 1 ise barkod 2 ise stok kodu ile sayım dosyası olusturulmustur --->
<cfif isdefined("attributes.file_import_id")>
	<cfloop from="1" to="#attributes.line_count#" index="i">
		<cfset spect_main_id = trim(evaluate("attributes.spect_main_id_"&i))>
		<cfset spect_main_name = trim(evaluate("attributes.spect_main_name_"&i))>
		<cfset shelf_id = trim(evaluate("attributes.shelf_id_"&i))>
		<cfset shelf_number = trim(evaluate("attributes.shelf_number_"&i))>
		<cfset deliver_date = trim(evaluate("attributes.deliver_date_"&i))>
        <cfset lot_no = trim(evaluate("attributes.lot_no_"&i))>
		<cfset miktar = replace(trim(evaluate("attributes.miktar_"&i)),',','.','all')>
		<cf_date tarih='deliver_date'>
		<cfquery name="upd_row" datasource="#dsn2#">
			UPDATE
				FILE_IMPORTS_TOTAL
			SET
				SPECT_MAIN_ID = <cfif len(spect_main_id) and len(spect_main_name)>#spect_main_id#<cfelse>NULL</cfif>,
				SHELF_NUMBER = <cfif len(shelf_number) and len(shelf_id)>#shelf_id#<cfelse>NULL</cfif>,
				DELIVER_DATE = <cfif len(deliver_date)>#deliver_date#<cfelse>NULL</cfif>,
                LOT_NO = <cfif len(lot_no)>'#lot_no#'<cfelse>NULL</cfif>,
				FILE_AMOUNT = #miktar#
			WHERE
				FILE_IMPORTS_TOTAL_ID = #evaluate("attributes.file_imports_total_id_#i#")#
				AND FIS_ID IS NULL
		</cfquery>
	</cfloop>
	<cfquery name="upd_main" datasource="#dsn2#">
		UPDATE
			FILE_IMPORTS_TOTAL_SAYIMLAR
		SET
			UPDATE_DATE = #now()#,
			UPDATE_EMP = #session.ep.userid#,
			UPDATE_IP = '#cgi.remote_addr#'
		WHERE
			FILE_IMPORTS_TOTAL_SAYIM_ID = #attributes.file_import_id#
	</cfquery>
	<cfoutput>
		<script type="text/javascript">
			alert("<cf_get_lang no ='151.Dosyanız Başarıyla Güncellendi'>.");
			window.location.href='#request.self#?fuseaction=pos.list_sayimlar';
		</script>
	</cfoutput>
<cfelse>
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
						LOCATION_IN,
						DEPARTMENT_IN,
						FILE_NAME,
						FILE_SERVER_ID,
						STOCK_IDENTITY_TYPE,
						RECORD_DATE,
						RECORD_EMP,
						DESCRIPTION,
						DELIMITERS,
						EXTRA_COLUMNS
					)
					VALUES
					(
						#attributes.location_in#,
						#attributes.department_in#,
						'#attributes.file_name#',
						#fusebox.server_machine#,
						<cfif isdefined('attributes.stock_identity_type') and len(attributes.stock_identity_type)>
							#attributes.stock_identity_type#,
						<cfelse>
							NULL,
						</cfif>
						#now()#,
						#session.ep.userid#,
						'#attributes.description#',
						'#attributes.seperator_type#',
						'<cfif len(attributes.add_file_format_1)>#attributes.add_file_format_1#,</cfif><cfif len(attributes.add_file_format_2)>#attributes.add_file_format_2#,</cfif><cfif len(attributes.add_file_format_3)>#attributes.add_file_format_3#,</cfif><cfif len(attributes.add_file_format_4)>#attributes.add_file_format_4#,</cfif><cfif len(attributes.add_file_format_5)>#attributes.add_file_format_5#,</cfif><cfif len(attributes.add_file_format_6)>#attributes.add_file_format_6#,</cfif><cfif len(attributes.add_file_format_7)>#attributes.add_file_format_7#,</cfif>'
					)
				</cfquery>
				<cfquery name="get_sayim" datasource="#DSN2#">
					SELECT MAX(GIRIS_ID) AS SAYIM_ID FROM SAYIMLAR
				</cfquery>
			</cftransaction>
		</cflock>
	</cfif>
	<cfscript>
		document_seperator = chr(attributes.seperator_type);
		net_total = 0;
		barcod_list = "";
		for(i=1; i lte attributes.line_count;i=i+1)
		{
			if(isdefined("attributes.miktar_#i#"))
			{
				temp_barcod = evaluate("attributes.barcode_"&i);
				if(len(temp_barcod))
					barcod_list = ListAppend(barcod_list,temp_barcod,'#document_seperator#');
			}else
			{
				barcod_list = ListAppend(barcod_list,' ','#document_seperator#');
			}
		}
	</cfscript>
	<cfquery name="get_product_main_all" datasource="#dsn3#">
		SELECT
		<cfif isdefined('attributes.stock_identity_type') and len(attributes.stock_identity_type) and attributes.stock_identity_type eq 1>
			GSB.BARCODE,
		</cfif>
			S.STOCK_ID,
			S.PRODUCT_ID,
			S.STOCK_CODE,
			S.PROPERTY,
			P.PRODUCT_NAME,
			S.STOCK_CODE_2,
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
		<cfif isdefined('attributes.stock_identity_type') and len(attributes.stock_identity_type) and attributes.stock_identity_type eq 1>
			GET_STOCK_BARCODES AS GSB,
		</cfif>
			PRICE_STANDART AS PS,
			PRODUCT_UNIT AS PU
		WHERE
		<cfif isdefined('attributes.stock_identity_type') and len(attributes.stock_identity_type) and attributes.stock_identity_type eq 1>
			(
			<cfset count=0>
			<cfloop list="#barcod_list#" delimiters="#document_seperator#" index="barcode_ind">
				<cfset count=count+1>
				GSB.BARCODE = '#barcode_ind#'
				<cfif listlen(barcod_list,document_seperator) gt count>OR</cfif>
			</cfloop>
			) AND
			S.STOCK_ID = GSB.STOCK_ID AND
		<cfelseif isdefined('attributes.stock_identity_type') and len(attributes.stock_identity_type) and attributes.stock_identity_type eq 3>
			(
			<cfset count=0>
			<cfloop list="#barcod_list#" delimiters="#document_seperator#" index="barcode_ind">
				<cfset count=count+1>
				S.STOCK_CODE_2 = '#barcode_ind#'
				<cfif listlen(barcod_list,document_seperator) gt count>OR</cfif>
			</cfloop>
			) AND
		<cfelse>
			(
			<cfset count=0>
			<cfloop list="#barcod_list#" delimiters="#document_seperator#" index="barcode_ind">
				<cfset count=count+1>
				S.STOCK_CODE = '#barcode_ind#'
				<cfif listlen(barcod_list,document_seperator) gt count>OR</cfif>
			</cfloop>
			) AND
		</cfif>
			PS.PURCHASESALES = 0 AND
			PS.PRICESTANDART_STATUS = 1 AND
			PU.IS_MAIN = 1 AND
			P.PRODUCT_ID = S.PRODUCT_ID AND
			PS.PRODUCT_ID = P.PRODUCT_ID AND
			PS.UNIT_ID = PU.PRODUCT_UNIT_ID AND
			PU.PRODUCT_ID = P.PRODUCT_ID
	</cfquery>
	<cfloop from="1" to="#attributes.line_count#" index="i">
		<cfif isdefined("attributes.miktar_#i#")>
			<cfset temp_barcod = trim(ListGetAt(barcod_list,i,"#document_seperator#"))>
				<cfquery name="get_product_main" dbtype="query">
					SELECT
					<cfif isdefined('attributes.stock_identity_type') and len(attributes.stock_identity_type) and attributes.stock_identity_type eq 1>
						BARCODE,
					</cfif>
						STOCK_ID,
						PRODUCT_ID,
						STOCK_CODE,
						PROPERTY,					
						PRODUCT_NAME,
						STOCK_CODE_2,
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
					<cfif isdefined('attributes.stock_identity_type') and len(attributes.stock_identity_type) and attributes.stock_identity_type eq 1>
						BARCODE = '#temp_barcod#'
					<cfelseif isdefined('attributes.stock_identity_type') and len(attributes.stock_identity_type) and attributes.stock_identity_type eq 3>
						STOCK_CODE_2 = '#temp_barcod#'
					<cfelse>
						STOCK_CODE = '#temp_barcod#'
					</cfif>
				</cfquery>
			<cfif not isdefined("attributes.file_id")><!--- dosya güncellenmede degistirlmez ilk eklerken yapılan degerlere gore bir kere duzenlenir birdaha yapılmaz--->
				<cfset str_icerik='#evaluate("attributes.barcode_"&i)##document_seperator##evaluate("attributes.miktar_"&i)#'>
				<cfloop from="1" to="7" index="add_colum_ind">
					<cfif evaluate('attributes.add_file_format_#add_colum_ind#') eq 'SPECT_MAIN_ID'>
						<cfif len(trim(evaluate("attributes.spect_main_id_"&i))) and len(trim(evaluate("attributes.spect_main_name_"&i)))><cfset str_icerik = str_icerik&"#document_seperator##evaluate("attributes.spect_main_id_"&i)#"></cfif>
					<cfelseif evaluate('attributes.add_file_format_#add_colum_ind#') eq 'SHELF_CODE'>
						<cfif len(trim(evaluate("attributes.shelf_number_"&i))) and len(trim(evaluate("attributes.shelf_id_"&i)))><cfset str_icerik = str_icerik&"#document_seperator##evaluate("attributes.shelf_number_"&i)#"></cfif>
					<cfelseif evaluate('attributes.add_file_format_#add_colum_ind#') eq 'DELIVER_DATE'>
						<cfif len(trim(evaluate("attributes.deliver_date_"&i))) and len(trim(evaluate("attributes.deliver_date_"&i)))><cfset str_icerik = str_icerik&"#document_seperator##evaluate("attributes.deliver_date_"&i)#"></cfif>
					<cfelseif evaluate('attributes.add_file_format_#add_colum_ind#') eq 'LOT_NO'>
						<cfif len(trim(evaluate("attributes.lot_no_"&i))) and len(trim(evaluate("attributes.lot_no_"&i)))><cfset str_icerik = str_icerik&"#document_seperator##evaluate("attributes.lot_no_"&i)#"></cfif>
					<cfelseif evaluate('attributes.add_file_format_#add_colum_ind#') eq 'PHYSICAL_AGE'>
						<cfif len(trim(evaluate("attributes.physical_age_"&i))) and len(trim(evaluate("attributes.physical_age_"&i)))><cfset str_icerik = str_icerik&"#document_seperator##evaluate("attributes.physical_age_"&i)#"></cfif>
					<cfelseif evaluate('attributes.add_file_format_#add_colum_ind#') eq 'FINANCE_DATE'>
						<cfif len(trim(evaluate("attributes.finance_date_"&i))) and len(trim(evaluate("attributes.finance_date_"&i)))><cfset str_icerik = str_icerik&"#document_seperator##evaluate("attributes.finance_date_"&i)#"></cfif>
					<cfelseif evaluate('attributes.add_file_format_#add_colum_ind#') eq 'COST_PRICE'>
						<cfif len(trim(evaluate("attributes.cost_price_"&i))) and len(trim(evaluate("attributes.cost_price_"&i)))><cfset str_icerik = str_icerik&"#document_seperator##evaluate("attributes.cost_price_"&i)#"></cfif>
					<cfelseif evaluate('attributes.add_file_format_#add_colum_ind#') eq 'EXTRA_COST'>
						<cfif len(trim(evaluate("attributes.extra_cost_"&i))) and len(trim(evaluate("attributes.extra_cost_"&i)))><cfset str_icerik = str_icerik&"#document_seperator##evaluate("attributes.extra_cost_"&i)#"></cfif>
					</cfif>
				</cfloop>
				<cfif i is 1>
					<cffile action='write' output='#str_icerik#' file='#attributes.file_path_and_name#' addnewline='yes' nameconflict="overwrite">
				<cfelse>
					<cffile action='append' output='#str_icerik#' file='#attributes.file_path_and_name#' addnewline='yes'>
				</cfif>
			</cfif>
			<cfif not len(get_product_main.price)><cfset get_product_main.price=0></cfif>
			<cfset satir_toplam = trim(Replace(evaluate("attributes.miktar_"&i),',','.','all') )* get_product_main.price>
			<cfset miktar_sp = trim(evaluate("attributes.miktar_"&i))>
			<cfset spect_main_id = trim(evaluate("attributes.spect_main_id_"&i))>
			<cfset spect_main_name = trim(evaluate("attributes.spect_main_name_"&i))>
			<cfset shelf_id = trim(evaluate("attributes.shelf_id_"&i))>
			<cfset shelf_number = trim(evaluate("attributes.shelf_number_"&i))>
			<cfset deliver_date = trim(evaluate("attributes.deliver_date_"&i))>
            <cfset lot_no = trim(evaluate("attributes.lot_no_"&i))>
			<cfset finance_date = trim(evaluate("attributes.finance_date_"&i))>
			<cfset physical_age = trim(evaluate("attributes.physical_age_"&i))>
			<cfset cost_price = filternum(trim(evaluate("attributes.cost_price_"&i)),8)>
			<cfset extra_cost = filternum(trim(evaluate("attributes.extra_cost_"&i)),8)>
			<cf_date tarih='deliver_date'>
			<cf_date tarih='finance_date'>
			<cfif get_product_main.MAIN_UNIT is "Kg">
				<cfset satir_toplam = satir_toplam/1000>
				<cfset Replace(miktar_sp,',','.','all')/1000>
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
					<cfif isdefined('attributes.stock_identity_type') and len(attributes.stock_identity_type) and attributes.stock_identity_type eq 1>
						BARCODE,
					</cfif>
						PRODUCT_NAME,
						STOCK_PROPERTY,
						OTHER_MONEY,
						MONEY_RATE,
						SPECT_MAIN_ID,
						SPECT_MAIN_NAME,
						SHELF_NUMBER,
						DELIVER_DATE,
                        LOT_NO,
						FINANCE_DATE,
						PHYSICAL_AGE,
						COST_PRICE,
						EXTRA_COST
					)
					VALUES
					(
						<cfif isdefined("attributes.file_id")>#attributes.file_id#<cfelse>#get_sayim.SAYIM_ID#</cfif>,
						#get_product_main.product_id#,
						#get_product_main.stock_id#,
						#miktar_sp#,
						#get_product_main.price#,
					<cfif isdefined('attributes.stock_identity_type') and len(attributes.stock_identity_type) and attributes.stock_identity_type eq 1>
						'#temp_barcod#',
					</cfif>
						'#get_product_main.product_name#',
						<cfif len(get_product_main.property)>'#get_product_main.property#'<cfelse>NULL</cfif>,
						'#get_product_main.money#',
						<cfif get_product_main.money neq session.ep.money>#get_money_rate.rate2#<cfelse>1</cfif>,
						<cfif len(spect_main_id) and len(spect_main_name)>#spect_main_id#<cfelse>NULL</cfif>,
						<cfif len(spect_main_id) and len(spect_main_name)>'#spect_main_name#'<cfelse>NULL</cfif>,
						<cfif len(shelf_number) and len(shelf_id)>#shelf_id#<cfelse>NULL</cfif>,
						<cfif len(deliver_date)>#deliver_date#<cfelse>NULL</cfif>,
                        <cfif len(lot_no)>'#lot_no#'<cfelse>NULL</cfif>,
						<cfif len(finance_date)>#finance_date#<cfelse>NULL</cfif>,
						<cfif len(physical_age)>#physical_age#<cfelse>NULL</cfif>,
						<cfif len(cost_price)>#cost_price#<cfelse>NULL</cfif>,
						<cfif len(extra_cost)>#extra_cost#<cfelse>NULL</cfif>
					)
			</cfquery>
		</cfif>
	</cfloop>
	<cfif isdefined("attributes.file_id")>
		<cfquery name="add_sayim" datasource="#DSN2#">
			UPDATE
				SAYIMLAR
			SET 
				UPDATE_DATE = #now()#,
				UPDATE_EMP = #session.ep.userid#,
				TOPLAM_MALIYET = #net_total#
			WHERE
				GIRIS_ID = #attributes.file_id#
		</cfquery>
		<cfoutput>
			<script type="text/javascript">
				alert("<cf_get_lang no ='151.Dosyanız Başarıyla Güncellendi'>.");
				window.location.href ='#request.self#?fuseaction=pos.list_sayim&event=upd&file_id=#attributes.file_id#';
			</script>
		</cfoutput>
	<cfelse>
		<cfquery name="add_sayim" datasource="#DSN2#">
			UPDATE
				SAYIMLAR
			SET 
				UPDATE_DATE = #now()#,
				UPDATE_EMP = #session.ep.userid#,
				TOPLAM_MALIYET = #net_total#
			WHERE
				GIRIS_ID = #get_sayim.SAYIM_ID#
		</cfquery>
		<cfoutput>
			<script type="text/javascript">
				alert("<cf_get_lang no ='150.Dosyanız Başarıyla Yüklendi'>.");
				window.location.href ='#request.self#?fuseaction=pos.list_sayim';
			</script>
		</cfoutput>
	</cfif> 
</cfif>

