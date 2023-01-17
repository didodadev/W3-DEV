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
			alert("<cf_get_lang dictionary_id='63329.Dosyaniz Upload Edilemedi Lütfen Konrol Ediniz'>!");
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
		alert("<cf_get_lang dictionary_id='63330.Dosya Okunamadı! Karakter Seti Yanlış Seçilmiş Olabilir.'>");
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
	satir_no =0;
	satir_say =0;
</cfscript>
<cfloop from="2" to="#line_count#" index="i">
	<cfset j = 1>
	<cfset error_flag = 0>
	<cftry>
		<cfscript>
			satir_say=satir_say+1;
			
			//stok kodu/özel kod
			stock_code= Listgetat(dosya[i],j,";");
			stock_code = trim(stock_code);
			j=j+1;	

			//operasyon kodu
			operation_code = Listgetat(dosya[i],j,";");
			operation_code = trim(operation_code);
			j=j+1;
			
			//bağlı olduğu ürün
			main_stock_code= Listgetat(dosya[i],j,";");
			main_stock_code = trim(main_stock_code);
			j=j+1;
			
			//İstasyon
			station_id= Listgetat(dosya[i],j,";");
			station_id = trim(station_id);
			j=j+1;
			
			//kapasite
			capasity= Listgetat(dosya[i],j,";");
			capasity = trim(capasity);
			j=j+1;
			
			//setup dk
			setup_time= Listgetat(dosya[i],j,";");
			setup_time = trim(setup_time);
			j=j+1;
			
			//Üretim Zamanı
			production_time= Listgetat(dosya[i],j,";");
			production_time = trim(production_time);
			j=j+1;
			
			//Minimum Üretim Miktarı
			min_prod_amount= Listgetat(dosya[i],j,";");
			min_prod_amount = trim(min_prod_amount);
			j=j+1;
			
			//tip
			type= Listgetat(dosya[i],j,";");
			type = trim(type);
			j=j+1;
			
			//Fiziki Varlık
			if(listlen(dosya[i],';') gte j)
			{
				asset_id = Listgetat(dosya[i],j,";");
				asset_id = trim(asset_id);
			}				
			else
				asset_id = '' ;
		</cfscript>
		<cfcatch type="Any">
			<cfoutput>#i#</cfoutput>.<cf_get_lang dictionary_id='63328.satır 1. adımda sorun oluştu'>.<br/>
			<cfset error_flag = 1>
		</cfcatch>
	</cftry>
	<cfif error_flag neq 1>
		<cfif not len(station_id) or (not len(stock_code) and not len(operation_code)) or not len(capasity) or not len(setup_time) or not len(production_time) or not len(min_prod_amount) or not len(type)>
			<cfoutput>station_id:#station_id#---stock_code:#stock_code#**operation_code:#operation_code#**<br />capasity:#capasity#**setup_time:#setup_time#**<br />
			production_time:#production_time#**min_prod_amount:#min_prod_amount#**type:#type#<cfabort>
				<script type="text/javascript">
					alert("#satir_say#. <cf_get_lang dictionary_id='44496.satırdaki zorunlu alanlarda eksik değerler var. Lütfen dosyanızı kontrol ediniz'> !");
					history.back();
				</script>
			</cfoutput>
			<cfabort>
		</cfif>
		<cfif len(main_stock_code)>
			<cfquery name="GET_MAIN_STOCK_INFO" datasource="#dsn3#">
				SELECT STOCK_ID FROM STOCKS WHERE PRODUCT_CODE_2 = '#main_stock_code#' OR STOCK_CODE = '#main_stock_code#'
			</cfquery>
			<cfif get_main_stock_info.recordcount><!--- Ana ürün varsa --->	
				<cfset main_stock_id = GET_MAIN_STOCK_INFO.STOCK_ID>
			<cfelse>
				<cfset main_stock_id = ''>
			</cfif>
		<cfelse>
			<cfset main_stock_id = ''>
		</cfif>
		<cfset row_stock_id = ''>
		<cfset row_operation_type_id = ''>
		<cfif len(stock_code)><!--- stock_id bilgisini almak için --->
			<cfquery name="GET_STOCK_INFO" datasource="#dsn3#">
				SELECT PROPERTY,PRODUCT_NAME,PRODUCT_UNIT_ID,STOCK_ID,PRODUCT_ID FROM STOCKS WHERE PRODUCT_CODE_2 = '#stock_code#' OR STOCK_CODE = '#stock_code#'
			</cfquery>
			<cfif GET_STOCK_INFO.recordcount>
				<cfset row_stock_id = GET_STOCK_INFO.STOCK_ID>
			</cfif>
		<cfelseif len(operation_code)><!--- operaion_id bilgisini almak için --->
			<cfquery name="GET_OP_INFO" datasource="#dsn3#">
				SELECT OPERATION_TYPE_ID,OPERATION_TYPE FROM OPERATION_TYPES WHERE OPERATION_CODE = '#operation_code#'
			</cfquery>
			<cfif GET_OP_INFO.recordcount>
				<cfset row_operation_type_id = GET_OP_INFO.OPERATION_TYPE_ID>
			</cfif>
		</cfif>
		<cfif len(row_operation_type_id) or len(row_stock_id)>
			<cfquery name="GET_WORKSTATION_INFO" datasource="#dsn3#">
				SELECT STATION_ID FROM WORKSTATIONS WHERE STATION_ID = #station_id#
			</cfquery>
			<cfif GET_WORKSTATION_INFO.recordcount><!--- istsyon kaydı varsa --->
				<cfset satir_no = satir_no + 1>
				<cfset row_station_id = GET_WORKSTATION_INFO.STATION_ID>
				<cfquery name="add_product" datasource="#dsn3#">
					INSERT INTO
						WORKSTATIONS_PRODUCTS
						(
							WS_ID,
							STOCK_ID,
							OPERATION_TYPE_ID,
							MAIN_STOCK_ID,
							CAPACITY,
							PRODUCTION_TIME,
							PRODUCTION_TIME_TYPE,
							PRODUCTION_TYPE,
							MIN_PRODUCT_AMOUNT,
							SETUP_TIME,
							RECORD_DATE,
							RECORD_EMP,
							RECORD_IP,
							ASSET_ID
						)
						VALUES
						(
							#row_station_id#,
							<cfif len(row_stock_id)>#row_stock_id#<cfelse>NULL</cfif>,
							<cfif len(row_operation_type_id)>#row_operation_type_id#<cfelse>NULL</cfif>,
							<cfif len(main_stock_id)>#main_stock_id#<cfelse>NULL</cfif>,
							#capasity#,
							#production_time#,
							1,
							#type#,
							#min_prod_amount#,
							#setup_time#,								
							#now()#,
							#session.ep.userid#,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">,
							<cfif len(asset_id)>#asset_id#<cfelse>NULL</cfif>
						)
				</cfquery>			
			<cfelse>
				<cfoutput>#satir_say#</cfoutput>.<cf_get_lang dictionary_id='60547.Satırda İstasyon Eksik'> !<br/>
			</cfif>
		<cfelse>
			<cfoutput>#satir_say#</cfoutput>.<cf_get_lang dictionary_id='63400.Satırda Ürün veya Operasyon Bulunamadı'> !<br/>
		</cfif>
		<cftry>	
			<cfcatch type="Any">
				<cfoutput>#satir_say#</cfoutput>. <cf_get_lang dictionary_id='63401.satır 2. adımda sorun oluştu'>.<br/>
			</cfcatch>
		</cftry>
	</cfif>
</cfloop>
<cfoutput><cf_get_lang dictionary_id='44647.İmport edilen satır sayısı'> : #satir_no# !!!</cfoutput><br/>
<cfoutput><cf_get_lang dictionary_id='44638.Toplam belge satır sayısı'> : #satir_say# !!!</cfoutput>
<script type="text/javascript">
	window.location.href='<cfoutput>#request.self#</cfoutput>?fuseaction=settings.form_add_workstation_import';
</script>
