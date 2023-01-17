	<cfset upload_folder = "#upload_folder#temp#dir_seperator#">
	<cftry>
		<cffile action = "upload" 
				fileField = "uploaded_file" 
				destination = "#upload_folder#"
				nameConflict = "MakeUnique"  
				mode="777" charset="#attributes.file_format#">
		<cfset file_name = "#createUUID()#.#cffile.serverfileext#">	
		
		<cffile action="rename" source="#upload_folder##cffile.serverfile#" destination="#upload_folder##file_name#" charset="#attributes.file_format#">
		
		<cfset file_size = cffile.filesize>
		<cfcatch type="Any">
			<script type="text/javascript">
				alert("<cf_get_lang_main no='43.Dosyanız Upload Edilemedi ! Dosyanızı Kontrol Ediniz '>!");
				history.back();
			</script>
			<cfabort>
		</cfcatch>  
	</cftry>
	
	<cftry>
		<cffile action="read" file="#upload_folder##file_name#" variable="dosya" charset="#attributes.file_format#">
		<cffile action="delete" file="#upload_folder##file_name#">
	<cfcatch>
		<script type="text/javascript">
			alert("Dosya Okunamadı ! Karakter Seti Yanlış Seçilmiş Olabilir.");
			history.back();
		</script>
		<cfabort>
	</cfcatch>
	</cftry>
	
	<cfscript>
		CRLF = Chr(13) & Chr(10);// satır atlama karakteri
		dosya = Replace(dosya,';;','; ;','all');
		dosya = Replace(dosya,';;','; ;','all');
		dosya = ListToArray(dosya,CRLF);
		line_count = ArrayLen(dosya);
		counter = 0;
		liste = "";
	</cfscript>
	
<cfset my_is_purchase = 1>
<cfset my_is_sale = 0>
<cfset my_in_out = 1>
<cfset process_no_ = "#createUUID()#">	
<cfset islem_date_ = now()>
<cfloop from="1" to="#line_count#" index="i">
	<cftry>
		<cfscript>
			error_flag = 0;
			counter = counter + 1;
			satir=dosya[i];
			seri_no_ = trim(listgetat(satir,1,";"));
			lot_no_ = trim(listgetat(satir,2,";"));
			reference_no_ = trim(listgetat(satir,3,";"));
			stock_code_ = trim(listgetat(satir,4,";"));
			departman_id_=trim(listgetat(satir,5,";"));
			lokasyon_id_=trim(listgetat(satir,6,";"));
			alis_garanti_kategori_id_=trim(listgetat(satir,7,";"));
			alis_baslama_tarihi_=trim(listgetat(satir,8,";"));
			alis_bitis_tarihi_=trim(listgetat(satir,9,";"));
			unit_row_quantity=trim(listgetat(satir,10,";"));
		</cfscript>
		<cfcatch type="Any">
			<cfoutput>#i#. satırda okuma sırasında hata oldu.</cfoutput><br />
		</cfcatch>
	</cftry>
	
	<cftry>
		<cf_date tarih="alis_baslama_tarihi_">
		<cf_date tarih="alis_bitis_tarihi_">
		
		<cfquery name="get_stock_" datasource="#dsn3#" maxrows="1">
			SELECT STOCK_ID FROM STOCKS WHERE STOCK_CODE = '#stock_code_#'
		</cfquery>
		
		<cfif get_stock_.recordcount>
			<cflock name="#CreateUUID()#" timeout="90">
				<cftransaction>
					<cfquery name="add_guaranty" datasource="#dsn3#" result="MAX_ID">
						INSERT INTO 
							SERVICE_GUARANTY_NEW
						(
							STOCK_ID,
							LOT_NO,
							PURCHASE_GUARANTY_CATID,
							PURCHASE_START_DATE,
							PURCHASE_FINISH_DATE,
							IN_OUT,
							IS_SALE,
							IS_PURCHASE,
							IS_SERVICE,
							IS_SARF,
							IS_RMA,
							PROCESS_ID,
							PROCESS_NO,
							PROCESS_CAT,
							PERIOD_ID,
							DEPARTMENT_ID,
							LOCATION_ID,
							SERIAL_NO,
							REFERENCE_NO,
							RECORD_EMP,
							RECORD_IP,
							RECORD_DATE,
							UNIT_ROW_QUANTITY,
							WRK_ROW_ID			
						)
						VALUES
						(
							#get_stock_.STOCK_ID#,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#lot_no_#">,
							#alis_garanti_kategori_id_#,
							#alis_baslama_tarihi_#,
							#alis_bitis_tarihi_#,
							#my_in_out#,
							#my_is_sale#,
							#my_is_purchase#,
							0,
							0,
							0,
							NULL,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#process_no_#">,
							1190,
							#session.ep.period_id#,
							#departman_id_#,
							#lokasyon_id_#,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(seri_no_)#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(reference_no_)#">,
							#SESSION.EP.USERID#,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">,
							#islem_date_#,
							<cfqueryparam cfsqltype="cf_sql_float" value="#unit_row_quantity#">,
							<cfqueryparam cfsqltype="cf_sql_nvarchar" value="WRK#i##round(rand()*65)##dateformat(now(),'YYYYMMDD')##timeformat(now(),'HHmmssL')##session.ep.userid##round(rand()*100)##i#">
						)
					</cfquery>
				</cftransaction>
			</cflock>
		<cfelse>
			<cfoutput>#i#. satırda yazma sırasında stok bulunamadı!</cfoutput>
		</cfif>
		<cfcatch type="Any">
			<cfoutput>#i#. satırda yazma sırasında hata oldu.</cfoutput>
		</cfcatch>
	</cftry>
</cfloop>
<script type="text/javascript">
	alert("<cf_get_lang no ='2510.Aktarım Tamamland'>");
	window.location.href='<cfoutput>#request.self#</cfoutput>?fuseaction=settings.import_seri_no';
</script>
