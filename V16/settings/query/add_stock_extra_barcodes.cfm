<cfsetting showdebugoutput="no">
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
			alert("<cf_get_lang dictionary_id='44501.Display Dosyanız Upload Edilemedi ! Dosyanızı Kontrol Ediniz'>!");
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
		alert("<cf_get_lang dictionary_id='29450.Dosya Okunamadı! Karakter Seti Yanlış Seçilmiş Olabilir'>");
		history.back();
	</script>
	<cfabort>
</cfcatch>
</cftry>
	
<cfscript>
	ayirac = ';';
	CRLF = Chr(13) & Chr(10);// satır atlama karakteri
	dosya = Replace(dosya,'#ayirac##ayirac#','#ayirac# #ayirac#','all');
	dosya = Replace(dosya,'#ayirac##ayirac#','#ayirac# #ayirac#','all');
	dosya = ListToArray(dosya,CRLF);
	line_count = ArrayLen(dosya);
	counter = 0;
	liste = "";
</cfscript>
<!--- bu bloktakiler sadece dosyadaki stoklara ait bilgileri çekecek şekilde düzenlenecek --->
<cfquery name="GET_STOCK_ALL" datasource="#dsn3#">
	SELECT STOCK_ID,PRODUCT_ID,STOCK_CODE,STOCK_CODE_2, PRODUCT_UNIT_ID,BARCOD FROM STOCKS
</cfquery>
<cfquery name="PRODUCT_UNIT_ALL" datasource="#dsn1#">
	SELECT 
    	PRODUCT_UNIT_ID, 
        PRODUCT_UNIT_STATUS, 
        PRODUCT_ID, 
        UNIT_ID, 
        ADD_UNIT, 
        RECORD_DATE, 
        RECORD_EMP, 
        UPDATE_DATE, 
        UPDATE_EMP 
    FROM 
	    PRODUCT_UNIT 
    WHERE 
    	PRODUCT_UNIT_STATUS = 1
</cfquery> 
<cfquery name="GET_SETUP_UNIT" datasource="#dsn#">
	SELECT 
    	UNIT_ID, 
        UNIT, 
        RECORD_DATE, 
        RECORD_EMP, 
        RECORD_IP, 
        UPDATE_DATE, 
        UPDATE_EMP, 
        UPDATE_IP
    FROM 
    	SETUP_UNIT
</cfquery>
<cfquery name="GET_ALL_STOCK_BARCODES_" datasource="#dsn1#">
	SELECT STOCK_ID,BARCODE	FROM GET_STOCK_BARCODES_ALL
</cfquery>
<cfloop from="2" to="#line_count#" index="i">
	<cftry>
		<cfscript>
			error_flag = 0;
			counter = counter + 1;
			satir=dosya[i];
			product = listgetat(satir,1,"#ayirac#");
			unit = trim(listgetat(satir,2,"#ayirac#"));
			extra_barcod = trim(listgetat(satir,3,"#ayirac#"));
		</cfscript>
		<cfcatch type="Any">
			<cfoutput>#i#. satırda okuma sırasında hata oldu.<br/></cfoutput>
		</cfcatch>
	</cftry>
	<cftry>
	<cfquery name="GET_PRODUCT" dbtype="query">
		SELECT 
			PRODUCT_ID,
			STOCK_ID,
			BARCOD,
			STOCK_CODE,
			STOCK_CODE_2,
			PRODUCT_UNIT_ID
		FROM 
			GET_STOCK_ALL
		WHERE
		<cfif attributes.product_type eq 1> <!--- özel kod --->
			STOCK_CODE_2 = '#product#'
		<cfelse> <!--- stok kodu --->
			STOCK_CODE = '#product#'
		</cfif>
	</cfquery>
	<cfif GET_PRODUCT.RECORDCOUNT eq 1>
		<cfset row_product_id=GET_PRODUCT.PRODUCT_ID>
		<cfset row_stock_id=GET_PRODUCT.STOCK_ID>
		<cfquery name="CONTROL_SETUP_UNIT" dbtype="query"><!--- satırdaki birim sisteme kayıtlı mı --->
			SELECT UNIT,UNIT_ID FROM GET_SETUP_UNIT WHERE UNIT = '#unit#'
		</cfquery>
		<!--- MT: Barkod ve Diğer barkod alanları eklendi 29.05.2014--->
        <cfquery name="get_barcod_control" datasource="#dsn1#">
            SELECT BARCOD FROM STOCKS WHERE STOCK_ID = #row_stock_id#
        </cfquery>
        <cfif get_barcod_control.recordcount and not len(get_barcod_control.BARCOD) and attributes.record_field eq 1>
            <cfquery name="upd_stocks" datasource="#DSN3#">
                UPDATE 
                    STOCKS 
                SET 
                    BARCOD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#extra_barcod#">,
                    UPDATE_EMP = #session.ep.userid#,
                    UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#REMOTE_ADDR#">,
                    UPDATE_DATE =  #now()# 
                WHERE 
                    STOCK_ID = #row_stock_id#
            </cfquery>
            <cfquery name="get_barcod_control" datasource="#dsn1#">
                SELECT BARCOD FROM STOCKS WHERE STOCK_ID = #row_stock_id#
            </cfquery>
        </cfif>
        <!--- MT: Barkod ve Diğer barkod alanları eklendi 29.05.2014--->
		<cfif CONTROL_SETUP_UNIT.recordcount>
			<cfquery name="GET_PRODUCT_UNIT" dbtype="query"><!--- satırdaki birim, urun birimleri arasında var mı --->
				SELECT PRODUCT_UNIT_ID,UNIT_ID,ADD_UNIT FROM PRODUCT_UNIT_ALL WHERE ADD_UNIT = '#unit#' AND PRODUCT_ID=#row_product_id#
			</cfquery>
			<cfif GET_PRODUCT_UNIT.RECORDCOUNT><!--- barkod farklı bir stok icin kullanmış mı  kullanılmadıysa--->
				<cfquery name="CHECK_CODE" dbtype="query">
					SELECT 
						STOCK_ID
					FROM 
						GET_ALL_STOCK_BARCODES_
					WHERE 
						BARCODE='#extra_barcod#'
				</cfquery>
				<cfif not CHECK_CODE.recordcount> 
					<cfquery name="CONTROL_STOCK_BARCOD" datasource="#dsn1#"><!--- ustteki queryden ozellikle cekilmedi, x satırda stoktaki barkd bilgisi update edilse bile (x+1). satırda hala boş gorundugunden yeniden update ediliyordu. --->
						SELECT BARCOD,STOCK_ID,PRODUCT_UNIT_ID FROM STOCKS WHERE STOCK_ID=#row_stock_id#
					</cfquery>
					<cfif (not len(CONTROL_STOCK_BARCOD.BARCOD) or CONTROL_STOCK_BARCOD.BARCOD is '') and CONTROL_STOCK_BARCOD.PRODUCT_UNIT_ID eq GET_PRODUCT_UNIT.PRODUCT_UNIT_ID><!--- stogun kendi barkodu bos ise ve satırdaki birim stok birimiyle aynıysa, barkod stogun ana barkodu olarak update edilir --->
						<cfquery name="UPD_STOCK_CODE" datasource="#DSN1#">
							UPDATE 
								STOCKS 
							SET 
								BARCOD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#extra_barcod#">,
								UPDATE_EMP = #session.ep.userid#,
								UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#REMOTE_ADDR#">,
								UPDATE_DATE =  #now()# 
							WHERE 
								STOCK_ID = #row_stock_id#
						</cfquery>
						<cfquery name="GET_PROD_BARCOD_STOCK" datasource="#DSN3#">
							SELECT MIN(STOCK_ID) MIN_STOCK_ID FROM STOCKS WHERE PRODUCT_ID=#row_product_id#
						</cfquery><!--- product id ile tum stok idleri alınıyor,stock_id si en kücük olan satırdaki stoga eşitse bu stok ana cesittir ve product tablosundada barcode yazılır --->
						<cfif GET_PROD_BARCOD_STOCK.MIN_STOCK_ID eq row_stock_id>
							<cfquery name="UPD_PRODUCT" datasource="#DSN1#">
								UPDATE PRODUCT SET 
									BARCOD= <cfqueryparam cfsqltype="cf_sql_varchar" value="#extra_barcod#">,
									UPDATE_EMP = #session.ep.userid#,
									UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#REMOTE_ADDR#">,
									UPDATE_DATE =  #now()#
								WHERE
									PRODUCT_ID = #row_product_id#
							</cfquery>
							<cfoutput>#i#. satırdaki barkod, satırdaki stok ve baglı oldugu ürünün barkodu olarak tanımlandı. (#unit#)<br/></cfoutput>
						<cfelse>
							<cfoutput>#i#. satırdaki stogun barkod bilgisi sistemde kayıtlı olmadığından satırdaki barkod ile stogun ana barkodu olarak tanımlandı. (#unit#)<br/></cfoutput>
						</cfif>
					</cfif>
					<cfquery name="GET_BARCODE_NULL" datasource="#DSN1#">
						SELECT STOCK_ID,UNIT_ID FROM STOCKS_BARCODES WHERE STOCK_ID=#row_stock_id# AND BARCODE=''
					</cfquery>
					<cfif GET_BARCODE_NULL.RECORDCOUNT>
						<cfquery name="UPD_STOCK_BARCODES" datasource="#DSN1#">
							UPDATE 
								STOCKS_BARCODES
							SET
								STOCK_ID=#row_stock_id#,
								BARCODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#extra_barcod#">,
								UNIT_ID=#GET_PRODUCT_UNIT.PRODUCT_UNIT_ID#
							WHERE 
								STOCK_ID=#GET_BARCODE_NULL.STOCK_ID# AND
								BARCODE='' AND
								UNIT_ID=#GET_BARCODE_NULL.UNIT_ID#
						</cfquery>
					<cfelseif len(get_barcod_control.BARCOD) and attributes.record_field eq 2>
						<cfquery name="ADD_STOCK_CODE" datasource="#DSN1#">
							INSERT INTO 
								STOCKS_BARCODES
								(
								STOCK_ID,
								BARCODE,
								UNIT_ID
								)
							VALUES 
								(
								#row_stock_id#,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#extra_barcod#">,
								#GET_PRODUCT_UNIT.PRODUCT_UNIT_ID#
								)
						</cfquery>
					</cfif>
				<cfelse>
					<cfoutput>#i#. satırdaki barkod başka bir stok tarafından kullanılmakta. (#unit#)<br/></cfoutput>
				</cfif>
			<cfelse>
				<cfoutput>#i#. satırdaki birim bu urunun birimi olarak kayıtlı değil. (#unit#)<br/></cfoutput>
			</cfif>
		<cfelse>
			<cfoutput>#i#. satırdaki birim sistemde kayıtlı değil. (#unit#)<br/></cfoutput>
		</cfif>
	<cfelse>
		<cfoutput>#i#. satırdaki ürün sistemde kayıtlı değil yada birden çok ürün bulundu. (#product#)<br/></cfoutput>
	</cfif>
	<cfcatch type="Any">
		<cfoutput>#i#. satırda Kayıt sırasında hata oldu.<br/></cfoutput>
	</cfcatch>
	</cftry>
</cfloop>
<br/><cf_get_lang dictionary_id='44493.Aktarım Tamamlandı'>
<script>
	window.location.href = "<cfoutput>#request.self#</cfoutput>?fuseaction=settings.import_stock_extra_barcodes"
</script>
