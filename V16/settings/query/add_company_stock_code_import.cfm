<cfsetting showdebugoutput="no">
<cfset upload_folder = "#upload_folder#temp#dir_seperator#">
<cftry>
	<cffile action = "upload" fileField = "uploaded_file" destination = "#upload_folder#" nameConflict = "MakeUnique" mode="777" charset="#attributes.file_format#">
	<cfset file_name = "#createUUID()#.#cffile.serverfileext#">	
	<cffile action="rename" source="#upload_folder##cffile.serverfile#" destination="#upload_folder##file_name#" charset="#attributes.file_format#">	
	<cfset file_size = cffile.filesize>
	<cfcatch type="Any">
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
	ayirac = ';';
	CRLF = Chr(13) & Chr(10);// satır atlama karakteri
	dosya = Replace(dosya,'#ayirac##ayirac#','#ayirac# #ayirac#','all');
	dosya = Replace(dosya,'#ayirac##ayirac#','#ayirac# #ayirac#','all');
	dosya = ListToArray(dosya,CRLF);
	line_count = ArrayLen(dosya);
	counter = 0;
	liste = "";
</cfscript>
<cfquery name="GET_COMPANY_STOCK" datasource="#DSN1#">
	SELECT COMPANY_STOCK_ID,COMPANY_ID,STOCK_ID FROM SETUP_COMPANY_STOCK_CODE
</cfquery>
<cfloop from="2" to="#line_count#" index="i">
	<cftry>
		<cfscript>
			error_flag = 0;
			counter = counter + 1;
			satir=dosya[i];
			member_code = trim(listgetat(satir,1,"#ayirac#"));
			stock_code =trim(listgetat(satir,2,"#ayirac#"));
			company_stock_code = trim(listgetat(satir,3,"#ayirac#"));
			
			if(listlen(satir,';') lt 3)
			{
				liste=ListAppend(liste,i&'. Satırda Eksik veya Fazla Kolon Bulunmaktadır - Kolon:#listlen(satir,';')#',',');
				error_flag=1;
			}
			else
			{
				if(len(company_stock_code) gte 150)
					company_stock_code=left(trim(company_stock_code),75);
				else
					company_stock_code=trim(company_stock_code);
			}
		</cfscript>
		<cfcatch type="Any">
			<cfoutput>#i#. satırda okuma sırasında hata oldu.<br/></cfoutput>
		</cfcatch>
	</cftry>
	<cfquery name="company_control" datasource="#dsn#">
		SELECT COMPANY_ID FROM COMPANY WHERE MEMBER_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#member_code#"> 
	</cfquery>
	<cfif not company_control.recordcount>
		<cfoutput>#i#. satırdaki üye sistemde kayıtlı değil<br/></cfoutput>
	<cfelse>
		<cfquery name="get_stock_no" datasource="#dsn1#">
			SELECT TOP 1 
				STOCK_ID 
			FROM 
				STOCKS
			WHERE 
				<cfif attributes.transfer_type eq 0>
					BARCOD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#stock_code#">
				<cfelseif attributes.transfer_type eq 1>
					STOCK_CODE_2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#stock_code#">
				<cfelse>
					STOCK_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#stock_code#">
				</cfif>
		</cfquery>
		<cfif not get_stock_no.recordcount>
			<cfoutput>#i#. satırdaki stok sistemde kayıtlı değil<br /></cfoutput>
		<cfelse>
		<cfquery name="stock_control" datasource="#dsn1#">
			SELECT
				* 
			FROM 
				SETUP_COMPANY_STOCK_CODE
			WHERE 
				COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#company_control.COMPANY_ID#"> AND 
				STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_stock_no.STOCK_ID#">
		</cfquery>
			<cfif stock_control.recordcount>
				<cfoutput>#i#. satırdaki stok bu üyeye zaten eklenmiş<br/></cfoutput>
			<cfelse>
				<cfquery name="ADD_COMPANY_STOCK_CODE" datasource="#dsn1#">
					INSERT INTO
						SETUP_COMPANY_STOCK_CODE
					(	
						COMPANY_ID,
						STOCK_ID,
						COMPANY_STOCK_CODE,
						RECORD_EMP,
						RECORD_DATE,
						RECORD_IP
					)
				VALUES
					(
						<cfqueryparam cfsqltype="cf_sql_integer" value="#company_control.COMPANY_ID#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#get_stock_no.STOCK_ID#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#company_stock_code#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
					)
				</cfquery>
				<cfoutput>#i#. satırdaki kayıt sorunsuz kaydedildi.<br /></cfoutput>
			</cfif>
		 </cfif> 
	</cfif>
	<cftry>
	<cfcatch type="Any">
		<cfoutput>#i#. satırda kayıt sırasında hata oldu.<br/></cfoutput>
	</cfcatch>
	</cftry>
</cfloop>
<script>
	location.href = document.referrer;
</script>
