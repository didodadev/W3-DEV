<!--- uygun dosya yüklenip yüklenmediğini kontrol ediyorum--->
<cfset upload_folder_ = "#upload_folder#settings#dir_seperator#">
<cftry>
	<cffile action = "upload" 
			fileField = "uploaded_file" 
			destination = "#upload_folder_#"
			nameConflict = "MakeUnique"  
			mode="777" charset="utf-8">
	<cfset file_name = "#createUUID()#.#cffile.serverfileext#">	
	<cffile action="rename" source="#upload_folder_##cffile.serverfile#" destination="#upload_folder_##file_name#" charset="utf-8">	
	<cfset file_size = cffile.filesize>
<cfcatch type="Any">
	<script type="text/javascript">
		alert("<cf_get_lang_main no='43.Dosyaniz Yüklenemedi. Lütfen Konrol Ediniz '>!");
		history.back();
	</script>
	<cfabort>
	</cfcatch>  
</cftry>
	
<cfif listlast(file_name,'.') neq 'csv'>
	<cf_del_server_file output_file="sales/#file_name#" output_server="#fusebox.server_machine#">
	<script type="text/javascript">
		alert("Girdiğiniz Dosya Bir CSV Dosyası Değil !");
		history.back();
	</script>
	<cfabort>
</cfif>


<cffile action="read" file="#attributes.uploaded_file#" variable="csvfile"   >

<cfscript>
	CRLF = Chr(13) & Chr(10);// satır atlama karakteri
	csvfile = ListToArray(csvfile,CRLF);
	line_count = ArrayLen(csvfile);
	
</cfscript>

<!--- Dosyadaki Zorunlu alanların Doldulup doldurulmadığını kontrol ediyorum--->

<cfset ustKategoriKodu = "">
 <cfset kategoriAdi = "">
 <cfset aciklama = "">
 <cfset kategoriKodu = "">
 <cfset kod = "">

<cftry>
	<cfloop index="control" from="2" to="#line_count#">
		<cfset list = csvfile[control].Split(";")>
		<cfset ustKategoriKodu = Trim(list[1])>
		<cfset kategoriAdi = Trim(list[2])>
		<cfset aciklama =Trim(list[3])>
		<cfset kategoriKodu =Trim(list[4])>
		<cfif len(kategoriAdi) eq 0>	
			<script type="text/javascript">
				alert("Lütfen Kategori Adı ve Kategori Kodu Kısımlarını Boş Bırakmayınız. Zorunlu Alanlar Doldurulmalı!! Dosyada Zorunlu Alanlar Boş!");
				location.reload();
			</script>
			<cfabort>
		</cfif>
	</cfloop> 
<cfcatch>
	<script type="text/javascript">
		alert("Lütfen Kategori Adı ve Kategori Kodu Kısımlarını Boş Bırakmayınız. Zorunlu Alanlar Doldurulmalı!! Dosyada Zorunlu Alanlar Boş!");
		location.reload();
	</script>
	<cfabort>
</cfcatch>
</cftry>
<!--- Dosyadaki verileri ilgili tabloya ekliyorum--->
<cftry>

	<cfloop index="i" from="2" to="#line_count#">

		<cfset list = csvfile[i].Split(";")>
		<cfset ustKategoriKodu = Trim(list[1])>
		<cfset kategoriAdi = Trim(list[2])>
		<cfset aciklama =Trim(list[3])>
		<cfset kategoriKodu =Trim(list[4])>

		<cfif  Len(ustKategoriKodu) gt 0 >
			<cfset kod = ustKategoriKodu&"."&kategoriKodu >
		<cfelse>
			<cfset kod = kategoriKodu >
		</cfif>
		
		<cfquery name="add_category" datasource="#dsn2#">
			INSERT INTO 
				EXPENSE_CATEGORY
			(
				EXPENSE_CAT_NAME,
				EXPENSE_CAT_CODE,
				EXPENSE_CAT_DETAIL,
				RECORD_EMP,
				RECORD_IP,
				RECORD_DATE
			)
			VALUES
			(
				<cfqueryparam value="#kategoriAdi#" cfsqltype="cf_sql_nvarchar">,
				<cfqueryparam value="#kod#" cfsqltype="cf_sql_nvarchar">,
				<cfqueryparam value="#aciklama#" cfsqltype="cf_sql_nvarchar">,
				#session.ep.userid#,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
				#now()#	
			)
		</cfquery>
	</cfloop> 
	<script type="text/javascript">
		alert("İşlem Başarıyla Gerçekleşti");
		location.reload();
	</script>
<cfcatch>
	<script type="text/javascript">
		alert("İşlem Başarısız! Bir Sorun Oluştu");
		location.reload();
	</script>
</cfcatch>
</cftry>






