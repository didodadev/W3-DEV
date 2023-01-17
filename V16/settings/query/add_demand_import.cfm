<cfset temp_record_date = now()>
<cfflush interval="3000">
<cfsetting showdebugoutput="no">
<cfset upload_folder = "#upload_folder#settings#dir_seperator#">
<cftry>	
	<cffile action = "upload" 
		filefield = "uploaded_file" 
		destination = "#upload_folder#"
		nameconflict = "MakeUnique"  
		mode="777" charset="utf-8">
	<cfset file_name = "#createUUID()#.#cffile.serverfileext#">
	<cffile action="rename" source="#upload_folder##cffile.serverfile#" destination="#upload_folder##file_name#" charset="#attributes.file_format#">
	<cfset file_size = cffile.filesize>
	<cfcatch type="any">
		<script type="text/javascript">
			alert("<cf_get_lang_main no='43.Dosyaniz Upload Edilemedi Lütfen Konrol Ediniz '>!");
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
            alert("Dosya Okunamadı! Karakter Seti Yanlış Seçilmiş Olabilir.");
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
	add_record = 0;
</cfscript>

<cfif attributes.recort_type eq 0>
	<cfset temp_alan='BARCOD'>
	<cfset temp_detail='Barkod'>
<cfelseif attributes.recort_type eq 1>
	<cfset temp_alan='STOCK_CODE_2'>
	<cfset temp_detail='Özel Kod'>
<cfelseif attributes.recort_type eq 2>
	<cfset temp_alan='STOCK_CODE'>
	<cfset temp_detail='Stok Kod'>
</cfif>

<cfquery name="GET_ALL_STOCK" datasource="#DSN3#">
	SELECT 
		BARCOD,
		STOCK_CODE_2,
		STOCK_CODE,
		STOCK_ID,
		PRODUCT_ID		
	FROM 
		STOCKS 
</cfquery>

<cfquery name="GET_CONSUMER" datasource="#DSN#">
	SELECT
		MEMBER_CODE, 
		CONSUMER_NAME,
		CONSUMER_ID
	FROM 
		CONSUMER 
</cfquery> 

<cflock name="#createuuid()#" timeout="500">
	<cfset kont=0>
	<cftransaction>
		<cfloop from="2" to="#line_count#" index="i"> 
			<cfset j= 1>
			<cfset error_flag = 0>
			<cftry>
				<cfscript>
					satir_no=satir_no+1;
					//1 Bireysel Uye Kodu
					member_code = trim(Listgetat(dosya[i],j,";")); 
					j=j+1;
					//Aktarım tipidir.Stok kodu, Barkod kodu veya Ozel Kodu
					recort_type_value = Listgetat(dosya[i],j,";");
					j=j+1;
					//KDV li Fiyat
					price_with_vat = trim(Listgetat(dosya[i],j,";"));
					j=j+1;
					//Takip Turu
					demand_type = trim(Listgetat(dosya[i],j,";"));
					j=j+1;
					//Miktar
					quantity = trim(Listgetat(dosya[i],j,";"));
					j=j+1;
					//Birim
					unit = trim(Listgetat(dosya[i],j,";"));
					j=j+1;
					//Aciklama
					detail = trim(Listgetat(dosya[i],j,";"));
					j=j+1;	
				</cfscript>
                <cfcatch type="any">
                    <cfoutput>#i#</cfoutput>.Satırda Hata Oluştu.<br/>
                    <cfset error_flag = 1>
					<cfset kont = 1>
                </cfcatch>
			</cftry>
			<cfif error_flag neq 1>
				<cfif not len(recort_type_value) or not len(price_with_vat) or not len(demand_type) or not len(quantity)  or not len(unit)>
					<cfoutput>
						#i#.satırdaki zorunlu alanlarda eksik değerler var Lütfen dosyanızı kontrol ediniz !.<br/>
					</cfoutput>
					<cfset error_flag = 1>
					<cfset kont = 1>
				</cfif>
				<cfif listfind('1,2,3',demand_type,',') eq 0>
					<cfoutput>#satır_no#. Satırdaki Takip Türü Hatalı<br/></cfoutput>
					<cfset error_flag=1>
					<cfset kont = 1>
				</cfif>
				<cfif error_flag neq 1>
					<cfquery name="GET_CONSUMER_ROW" dbtype="query">
						SELECT 
							CONSUMER_ID
						FROM 
							GET_CONSUMER 
						WHERE 
							MEMBER_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#member_code#">				
					</cfquery>
					
					<cfquery name="GET_ROW_STOCK" dbtype="query">
						SELECT 
							STOCK_ID,
							PRODUCT_ID 
						FROM 
							GET_ALL_STOCK 
						WHERE 
							#temp_alan# = '#recort_type_value#'
					</cfquery>
					<cfset get_product_unit.recordcount = 0>
					<cfif get_row_stock.recordcount>
						<cfquery name="GET_PRODUCT_UNIT" datasource="#DSN3#">
							SELECT 
								PRODUCT_UNIT_ID,
								ADD_UNIT 
							FROM 
								PRODUCT_UNIT 
							WHERE 
								PRODUCT_UNIT_STATUS = 1 AND 
								ADD_UNIT IN ('#unit#') AND 
								PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_row_stock.product_id#">
						</cfquery>
						<cfquery name="GET_STOCK_ACTION_TYPE" datasource="#DSN3#">
							SELECT
								SST.STOCK_ACTION_TYPE
							FROM
								STOCK_STRATEGY ST,
								SETUP_SALEABLE_STOCK_ACTION SST
							WHERE				
								ST.STOCK_ACTION_ID = SST.STOCK_ACTION_ID AND
								ST.STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_row_stock.stock_id#"> 
						</cfquery>
						<cfquery name="GET_STOCK_ID" datasource="#DSN3#">
							SELECT
								PRODUCT_UNIT_ID,
								TAX
							FROM
								STOCKS
							WHERE
								STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_row_stock.stock_id#">
						</cfquery>
					</cfif>
					
					<cfif get_consumer_row.recordcount and get_row_stock.recordcount and get_product_unit.recordcount>	
						<!--- Ekleme islemi  --->
						<cfquery name="ADD_DEMAND" datasource="#DSN3#">
							INSERT INTO
								ORDER_DEMANDS
							(
								DEMAND_STATUS,
								STOCK_ID,
								DEMAND_TYPE,
								PRICE,
								PRICE_KDV,
								PRICE_MONEY,
								DEMAND_AMOUNT,
								GIVEN_AMOUNT,
								DEMAND_UNIT_ID,
								<!---DOMAIN_NAME,--->
                                MENU_ID,
								STOCK_ACTION_TYPE,
								DEMAND_NOTE,
								RECORD_CON,
								RECORD_PAR,
								RECORD_EMP,
								RECORD_DATE,
								RECORD_IP				
							)
							VALUES
							(
								1,
								#get_row_stock.stock_id#,
								#demand_type#,
								#wrk_round(((price_with_vat*100)/(100+get_stock_id.tax)),4)#,
								#price_with_vat#,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money#">,
								#quantity#,
								0,
								#get_product_unit.product_unit_id#,
								<!---<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.http_host#">,--->
                                #session.ep.menu_id#,
								<cfif get_stock_action_type.recordcount and len(get_stock_action_type.stock_action_type)>#get_stock_action_type.stock_action_type#<cfelse>NULL</cfif>,
								<cfif isdefined("detail") and len(detail)><cfqueryparam cfsqltype="cf_sql_varchar" value="#detail#"><cfelse>NULL</cfif>,
								#get_consumer_row.consumer_id#,
								NULL,
								#session.ep.userid#,
								#temp_record_date#,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
							)
						</cfquery>	
						<cfset add_record = ++add_record>
					<cfelse>
						<cfif get_consumer_row.recordcount eq 0>
							<cfoutput>#i#. Satırdaki Üye Kodu Bulunamadı.<br/></cfoutput>
						<cfelseif get_row_stock.recordcount eq 0>
							<cfoutput>#i#. Satırdaki Ürün Kodu Bulunamadı.<br/></cfoutput>
						<cfelse>
							<cfoutput>#i#. Satırdaki Ürün Birimi Bulunamadı.<br/></cfoutput>
						</cfif>
						<cfset kont = 1>
					</cfif>
				</cfif>
			</cfif>
		</cfloop>
	</cftransaction>
	<cfoutput>
	<br/>Dosyadaki Eklenecek Takip Sayısı : #satir_no# <br/>
	Kaydedilen Takip Sayısı : #add_record#
	</cfoutput> 
	<cfif kont eq 0>
		<script type="text/javascript">
			window.close();
		</script>
	</cfif>
</cflock>
<cfabort>
