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
	dosya = Replace(dosya,',,',', ,','all');
	dosya = Replace(dosya,',,',', ,','all');
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
			
			stock_code_ = trim(listgetat(satir,1,","));
			toplam_sayi_=trim(listgetat(satir,2,","));
			alis_baslama_tarihi_=trim(listgetat(satir,3,","));
			alis_bitis_tarihi_=trim(listgetat(satir,4,","));
			departman_id_ = attributes.department_id;
			lokasyon_id_ = attributes.location_id;
			alis_garanti_kategori_id_ = attributes.guaranty_cat_id;
			lot_no_ = '';
		</cfscript>
		<cfcatch type="Any">
			<cfoutput>#i#. satırda okuma sırasında hata oldu.</cfoutput>
		</cfcatch>
	</cftry>
	
	<cftry>
		<cf_date tarih="alis_baslama_tarihi_">
		<cf_date tarih="alis_bitis_tarihi_">
		
		<cfquery name="get_stock_" datasource="#dsn3#" maxrows="1">
			SELECT 
				S.SERIAL_BARCOD,
				S.STOCK_ID
			FROM 
				STOCKS S,
				PRODUCT_GUARANTY PG
			WHERE 
				S.STOCK_CODE = '#stock_code_#' AND
				PG.PRODUCT_ID = S.PRODUCT_ID AND
				PG.IS_LOCAL_SERIAL = 1
		</cfquery>
		<cfif get_stock_.recordcount>
			<cfset attributes.STOCK_ID = "#get_stock_.STOCK_ID#">
			<cfset stock_ = "#attributes.STOCK_ID#">
			<cfloop from="1" to="#6-len(attributes.STOCK_ID)#" index="smk">
				<cfset stock_ = "0" & stock_>
			</cfloop>
			
			<cfif len(get_stock_.serial_barcod)>
				<cfset seri_ = get_stock_.serial_barcod>
			<cfelse>
				<cfset seri_ = 0>
			</cfif>

			
		<cfloop from="1" to="#toplam_sayi_#" index="ccc">
			<cfset seri_ = seri_ + 1>
			<cfset my_seri_ = seri_>
			<cfloop from="1" to="#8-len(seri_)#" index="smk">
				<cfset my_seri_ = "0" & my_seri_>
			</cfloop>
			
			<cfset seri_no_ = '#stock_##my_seri_#'>
			<cflock name="#CreateUUID()#" timeout="90">
				<cftransaction>
					<cfquery name="add_guaranty" datasource="#dsn3#" result="MAX_ID">
						INSERT INTO SERVICE_GUARANTY_NEW
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
							RECORD_EMP,
							RECORD_IP,
							RECORD_DATE					
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
							#SESSION.EP.USERID#,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">,
							#islem_date_#
							)
					  </cfquery>
				  </cftransaction>
			</cflock>
				
			<!--- fbs 20130611 asagidaki blokla birlikte kaldirilabilir, history icin eklenmis burasi da
			<cfquery name="get_history_row" datasource="#dsn3#">
				SELECT * FROM SERVICE_GUARANTY_NEW WHERE GUARANTY_ID = #MAX_ID.IDENTITYCOL#
			</cfquery>
			 --->
			<!--- BK kaldirdi 6 aya kaldirilmali. 20130529
			<cfquery name="add_guaranty_history" datasource="#dsn3#">
				INSERT INTO 
					SERVICE_GUARANTY_NEW_HISTORY
				(
					GUARANTY_ID,
					STOCK_ID,
					MAIN_STOCK_ID,
					LOT_NO,
					PROMOTION_ID,
					PURCHASE_GUARANTY_CATID,
					PURCHASE_START_DATE,
					PURCHASE_FINISH_DATE,
					PURCHASE_COMPANY_ID,
					PURCHASE_CONSUMER_ID,
					PURCHASE_PARTNER_ID,
					SALE_GUARANTY_CATID,
					SALE_START_DATE,
					SALE_FINISH_DATE,
					SALE_COMPANY_ID,
					SALE_CONSUMER_ID,
					SALE_PARTNER_ID,
					IN_OUT,
					IS_TRASH,
					IS_RMA,
					IS_RETURN,
					IS_SALE,
					IS_PURCHASE,
					IS_SERVICE,
					IS_SARF,
					PROCESS_ID,
					PROCESS_NO,
					PROCESS_CAT,
					PERIOD_ID,
					DEPARTMENT_ID,
					LOCATION_ID,
					SERIAL_NO,
					SPECT_ID,
					RETURN_SERIAL_NO,
					RETURN_STOCK_ID,
					RETURN_PROCESS_ID,
					RECORD_EMP,
					RECORD_IP,
					RECORD_DATE					
				)
				VALUES
				(
					#MAX_ID.IDENTITYCOL#,
					#get_stock_.STOCK_ID#,
					NULL,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#lot_no_#">,
					NULL,
					<cfif len(get_history_row.PURCHASE_GUARANTY_CATID)>#get_history_row.PURCHASE_GUARANTY_CATID#<cfelse>NULL</cfif>,
					<cfif len(get_history_row.PURCHASE_START_DATE)>#CREATEODBCDATETIME(get_history_row.PURCHASE_START_DATE)#<cfelse>NULL</cfif>,
					<cfif len(get_history_row.PURCHASE_FINISH_DATE)>#CREATEODBCDATETIME(get_history_row.PURCHASE_FINISH_DATE)#<cfelse>NULL</cfif>,
					<cfif len(get_history_row.PURCHASE_COMPANY_ID)>#get_history_row.PURCHASE_COMPANY_ID#<cfelse>NULL</cfif>,
					<cfif len(get_history_row.PURCHASE_CONSUMER_ID)>#get_history_row.PURCHASE_CONSUMER_ID#<cfelse>NULL</cfif>,
					<cfif len(get_history_row.PURCHASE_PARTNER_ID)>#get_history_row.PURCHASE_PARTNER_ID#<cfelse>NULL</cfif>,
					<cfif len(get_history_row.SALE_GUARANTY_CATID)>#get_history_row.SALE_GUARANTY_CATID#<cfelse>NULL</cfif>,
					<cfif len(get_history_row.SALE_START_DATE)>#CREATEODBCDATETIME(get_history_row.SALE_START_DATE)#<cfelse>NULL</cfif>,
					<cfif len(get_history_row.SALE_FINISH_DATE)>#CREATEODBCDATETIME(get_history_row.SALE_FINISH_DATE)#<cfelse>NULL</cfif>,
					<cfif len(get_history_row.SALE_COMPANY_ID)>#get_history_row.SALE_COMPANY_ID#<cfelse>NULL</cfif>,
					<cfif len(get_history_row.SALE_CONSUMER_ID)>#get_history_row.SALE_CONSUMER_ID#<cfelse>NULL</cfif>,
					<cfif len(get_history_row.SALE_PARTNER_ID)>#get_history_row.SALE_PARTNER_ID#<cfelse>NULL</cfif>,
					#my_in_out#,
					0,
					0,
					0,
					#my_is_sale#,
					#my_is_purchase#,
					0,
					0,
					NULL,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#process_no_#">,
					1190,
					#session.ep.period_id#,
					#departman_id_#,
					#lokasyon_id_#,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(seri_no_)#">,
					NULL,
					NULL,
					NULL,
					NULL,
					#SESSION.EP.USERID#,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">,
					#islem_date_#
				)
			</cfquery> --->
		</cfloop>
		<cfquery name="upd_stock_" datasource="#dsn1#">
			UPDATE STOCKS SET SERIAL_BARCOD=#seri_# WHERE STOCK_ID = #attributes.STOCK_ID#
		</cfquery>
		<cfelse>
			<cfoutput>#i#. satırda yazma sırasında stok bulunamadı!</cfoutput>
		</cfif>
		<cfcatch type="Any">
			<cfoutput>#i#. satırda yazım sırasında hata oldu.</cfoutput>
		</cfcatch>
	</cftry>
</cfloop>
<script type="text/javascript">
	alert("<cf_get_lang no ='2510.Aktarım Tamamland'>");
	window.location.href='<cfoutput>#request.self#</cfoutput>?fuseaction=settings.import_seri_no_local';
</script>
