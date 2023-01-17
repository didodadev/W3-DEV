	<cfset upload_folder = "#upload_folder#temp#dir_seperator#">
	<cftry>
		<cffile action = "upload" 
				fileField = "uploaded_file" 
				destination = "#upload_folder#"
				nameConflict = "MakeUnique"  
				mode="777" charset="#attributes.file_format#">
		<cfset file_name = "#createUUID()#.#cffile.serverfileext#">	
		
		<cffile action="rename" source="#upload_folder##cffile.serverfile#" destination="#upload_folder##file_name#" charset="utf-8">
		
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
	<!--- <cfquery name="GET_UNIT_ALL" datasource="#dsn#">
		SELECT UNIT_ID,UNIT FROM SETUP_UNIT
	</cfquery> --->
	<cfquery name="GET_PRODUCT_ALL" datasource="#DSN3#">
		SELECT 
			P.PRODUCT_ID,
			<cfif isdefined("attributes.product_type") and  attributes.product_type eq 0>GSB.BARCODE<cfelse>0 BARCODE</cfif>,
			P.STOCK_CODE,
			P.STOCK_CODE_2
		FROM 
			STOCKS P
		<cfif isdefined("attributes.product_type") and attributes.product_type eq 0>
			,GET_STOCK_BARCODES GSB
		WHERE
			P.STOCK_ID = GSB.STOCK_ID 
		</cfif>
	</cfquery>
	<cfquery name="PRODUCT_UNIT_ALL" datasource="#DSN1#">
		SELECT 
			* 
		FROM 
			PRODUCT_UNIT
	</cfquery>
<cfloop from="2" to="#line_count#" index="i">
	<cftry>
		<cfscript>
			error_flag = 0;
			counter = counter + 1;
			satir=dosya[i];
			product = trim(listgetat(satir,1,"#ayirac#"));
			unit = trim(listgetat(satir,2,"#ayirac#"));
			if(listlen(satir,'#ayirac#') gt 2) multiplier_static = Replace(trim(listgetat(satir,3,"#ayirac#")),',','.','all'); else multiplier_static = 1;
			if(listlen(satir,'#ayirac#') gt 3) dimention = trim(listgetat(satir,4,"#ayirac#")); else dimention = '';
			if(listlen(satir,'#ayirac#') gt 4) weight= Replace(trim(listgetat(satir,5,"#ayirac#")),',','.','all'); else weight='';
			if(listlen(satir,'#ayirac#') gt 5) volume= Replace(trim(listgetat(satir,6,"#ayirac#")),',','.','all'); else volume='';
			if(listlen(satir,'#ayirac#') gt 6) is_add_unit=Replace(trim(listgetat(satir,7,"#ayirac#")),',','.','all'); else is_add_unit ='';
			
			if(not isdefined('multiplier_static') or not multiplier_static gt 0) multiplier_static = 1;
			if(not isdefined('dimention') or not len(trim(dimention))) dimention = '';
			if(not isdefined('weight') or not len(trim(weight))) weight = '';
			if(not isdefined('volume') or not len(trim(volume))) volume = '';
			if(not isdefined('is_add_unit') or not len(trim(is_add_unit))) is_add_unit = '';
		</cfscript>
		<cfcatch type="Any">
			<cfoutput>#i#. satırda okuma sırasında hata oldu.<br/></cfoutput>
		</cfcatch>
	</cftry>
	<cftry>  
		<cfquery name="GET_PRODUCT" dbtype="query">
			SELECT 
				PRODUCT_ID,
				BARCODE,
				STOCK_CODE,
				STOCK_CODE_2
			FROM 
				GET_PRODUCT_ALL
			WHERE
				<cfif isdefined("attributes.product_type") and attributes.product_type eq 0>
					BARCODE = '#product#' 
				<cfelseif isdefined("attributes.product_type") and attributes.product_type eq 1>
					STOCK_CODE_2 = '#product#' 
				<cfelse>
					STOCK_CODE = '#product#'
				</cfif>
		</cfquery>
		<cfif GET_PRODUCT.RECORDCOUNT eq 1>
			<cfset product_id=GET_PRODUCT.PRODUCT_ID>
			<cfquery name="GET_UNIT" datasource="#dsn#">
				SELECT UNIT,UNIT_ID FROM SETUP_UNIT WHERE UNIT = '#unit#'
			</cfquery>
			<cfif GET_UNIT.RECORDCOUNT>
				<cfquery name="CHECK_UNIT" dbtype="query">
					SELECT 
						* 
					FROM 
						PRODUCT_UNIT_ALL 
					WHERE 
						PRODUCT_UNIT_STATUS = 1 AND
						PRODUCT_ID = #product_id# AND 
						UNIT_ID = #GET_UNIT.UNIT_ID#
				</cfquery>
				<cfif not CHECK_UNIT.recordcount>
					<cfquery name="GET_MAIN" dbtype="query">
						SELECT 
							MAIN_UNIT,
							MAIN_UNIT_ID
						FROM 
							PRODUCT_UNIT_ALL
						WHERE 
							PRODUCT_ID = #product_id# AND IS_MAIN=1
					</cfquery>
					<cfquery name="ADD_UNIT" datasource="#dsn1#">
                    <cfif is_add_unit eq 1>
                        UPDATE 
                            PRODUCT_UNIT 
                        SET 
                            IS_ADD_UNIT = 0 
                        WHERE 
                            PRODUCT_ID =  #product_id#  AND IS_ADD_UNIT = 1
                     </cfif>
					  INSERT INTO PRODUCT_UNIT 
						  (
							  PRODUCT_ID,
							  MAIN_UNIT,
							  MAIN_UNIT_ID,
							  ADD_UNIT,
							  UNIT_ID,
							  MULTIPLIER,
							  DIMENTION,
							  WEIGHT,
                              VOLUME,
                  			  RECORD_EMP,
                  			  RECORD_DATE,
                              IS_ADD_UNIT
						  )
					  VALUES 
						  (
							  #product_id#,
							  '#GET_MAIN.MAIN_UNIT#',
							  #GET_MAIN.MAIN_UNIT_ID#,
							  '#GET_UNIT.UNIT#',
							  #GET_UNIT.UNIT_ID#,
							  #multiplier_static#,
							  <cfif len(dimention)>#dimention#<cfelse>NULL</cfif>,
							  <cfif len(weight)>#weight#<cfelse>NULL</cfif>,
                              <cfif len(volume)>#volume#<cfelse>NULL</cfif>,
                  			  <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                  			  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                              <cfif is_add_unit eq 1>1<cfelse>0</cfif>
						  )
                        
                           
					</cfquery>
				<cfelse>
					<cfoutput>#i#. satırdaki birim bu ürüne zaten eklenmiş<br/></cfoutput>
				</cfif>
			<cfelse>
				<cfoutput>#i#. satırdaki birim sistemde kayıtlı değil(#unit#).<br/></cfoutput>
			</cfif>
		<cfelse>
			<cfoutput>#i#. satırdaki ürün sistemde kayıtlı değil yada birden çok ürün bulundu(#product#)<br/></cfoutput>
		</cfif>
	<cfcatch type="Any">
		<cfoutput>#i#. satırda Kayıt sırasında hata oldu.<br/></cfoutput>
	</cfcatch>
	</cftry>
</cfloop>
<br/><cf_get_lang dictionary_id='44493.Aktarım Tamamlandı'>
<script>
	window.location.href = "<cfoutput>#request.self#</cfoutput>?fuseaction=settings.import_unit"
</script>

