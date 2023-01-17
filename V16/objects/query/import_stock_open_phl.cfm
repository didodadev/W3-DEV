<!--- PHL Stok Açılış Belgesi 
ergün koçak 200402006
--->


<cffunction name="cfquerytoquery" access="public" returntype="query">
	<cfargument name="SQLString" type="string" required="true">
	<cfquery name="recordset" dbtype="query">
		#preserveSingleQuotes(arguments.SQLString)#
	</cfquery>
	<cfreturn recordset>
</cffunction>

<cfif listlen(attributes.store_id,"-") eq 2>
	<cfset location_id = listlast(attributes.store_id,"-")>
	<cfset store_id =  listfirst(attributes.store_id,"-")>
<cfelse>
	<cfset store_id = attributes.store_id>
</cfif>

<!--- stok açılış kontrol et --->
<cfquery name="GET_RECORD_OPEN_FIS" datasource="#DSN2#">
	SELECT 
		DEPARTMENT_IN
	FROM 
		STOCK_FIS
	WHERE 
		DEPARTMENT_IN = #store_id# AND 
		FIS_TYPE = 114
	<cfif isdefined('location_id') and len(location_id)>
		AND LOCATION_IN=#location_id#
	</cfif>
</cfquery>

<cfif GET_RECORD_OPEN_FIS.RECORDCOUNT>
	<script type="text/javascript">
		alert("Seçtiğiniz Depoya ait Açılış Fişi Bulunmaktadır.");
		history.back();
	</script>
	<CFABORT>
</cfif>

<cfset upload_folder = "#upload_folder#store#dir_seperator#">
<cftry>
		<cffile action = "upload" 
				  fileField = "uploaded_file" 
				  destination = "#upload_folder#"
				  nameConflict = "MakeUnique"  
				  mode="777">
		<cfset file_name = "#createUUID()#.#cffile.serverfileext#">	
		<cffile action="rename" source="#upload_folder##cffile.serverfile#" destination="#upload_folder##file_name#">	
		<!---Script dosyalarını engelle  02092010 FA-ND --->
		<cfset assetTypeName = listlast(cffile.serverfile,'.')>
		<cfset blackList = 'php,php2,php3,php4,php5,phtml,pwml,inc,asp,aspx,ascx,jsp,cfm,cfml,cfc,pl,bat,exe,com,dll,vbs,reg,cgi,htaccess,asis'>
		<cfif listfind(blackList,assetTypeName,',')>
			<cffile action="delete" file="#upload_folder##file_name#">
			<script type="text/javascript">
				alert("\'php\',\'jsp\',\'asp\',\'cfm\',\'cfml\' Formatlarında Dosya Girmeyiniz!!");
				history.back();
			</script>
			<cfabort>
		</cfif>
		<cfset file_size = cffile.filesize>
	<cfcatch type="Any">
		<script type="text/javascript">
			alert("Dosyanız upload edilemedi ! Dosyanızı kontrol ediniz!");
			history.back();
		</script>
		<cfabort>
	</cfcatch>  
</cftry>

<CFFILE action="read" file="#upload_folder##file_name#" variable="dosya">

<cfscript>
	CRLF = Chr(13) & Chr(10);
	dosya = ListToArray(dosya,CRLF);
	
	line_count = ArrayLen(dosya);
	TOTAL_PRODUCTS = 0;
	hata_flag = 0;
	for (temp_count=1; temp_count lte line_count; temp_count=temp_count+1)
		if ( 
			Listlen(dosya[temp_count], ",") lt 2 
			or 
			not len(ListGetat(dosya[temp_count], 1, ",")) 
			or 
			not isnumeric(ListGetat(dosya[temp_count], 2, ",")) 
			)
			{
			hata_flag = 1;
			writeoutput("#temp_count#,");
			}
</cfscript>

<cfif hata_flag>
	<cf_get_lang no='733.Satırlarında Miktar veya Barkod Bilgisi Eksik'>
	<cfabort>
</cfif>
<cfquery name="get_product_main" datasource="#dsn3#">
	SELECT
		S.STOCK_ID,
		S.PRODUCT_ID,
		PU.ADD_UNIT,
		S.PROPERTY,
		S.STOCK_CODE,
		P.PRODUCT_NAME,
		GSB.BARCODE
	FROM
		STOCKS AS S,
		PRODUCT_UNIT AS PU,
		GET_STOCK_BARCODES AS GSB,
		PRODUCT AS P
	WHERE
		S.STOCK_ID=GSB.STOCK_ID AND
		S.PRODUCT_UNIT_ID = PU.PRODUCT_UNIT_ID AND
		S.PRODUCT_ID = PU.PRODUCT_ID AND
		S.PRODUCT_ID = P.PRODUCT_ID
</cfquery>

<!--- Belge Kontrol Ediliyor --->
<table width="98%" border="1" align="center">
		<tr>
			<td class="headbold" height="35"><cf_get_lang no='734.Stok Import Öncesi Rapor'></td>
			<!-- sil -->
			<cfif not isdefined("attributes.trail")>
				<cfset attributes.trail = 1> 
			</cfif>			
			<td  nowrap style="text-align:right;">
			<cfoutput>
				<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.emptypopup_get_document2&module=#fusebox.circuit#&faction=#fusebox.fuseaction#&trail=#attributes.trail#&name=#ListGetAt(file_name,1,'.')#&extension=xls','small')"><img src="/images/save.gif" border="0" title="Farklı Kaydet"></a>
				<a href="javascript://" onClick="window.print();"><img src="/images/print.gif" border="0" title="Print"></a>
			</cfoutput>
			</td>
			<!-- sil -->
		</tr>
	</table>

	<table border="1">	
	<tr height="22">
		<td width="30"><cf_get_lang no='300.No'></td>
		<td height="20" width="100"><cf_get_lang no='735.Workcube Kod'></td>
		<td width="100"><cf_get_lang_main no='221.Barkod'></td>
		<td><cf_get_lang no='736.Workcubedeki Adı'></td>
		<td width="350"><cf_get_lang no='737.Belgedeki Adı'></td>
		<td width="50"><cf_get_lang_main no='223.Miktar'></td>
		<td width="50"><cf_get_lang_main no='224.Birim'></td>
	</tr>
<cfsavecontent variable="satir"><cf_get_lang_main no='1096.Satır'></cfsavecontent>
<cfsavecontent variable="yok"><cf_get_lang no='738.de isim yok'></cfsavecontent>	
<cfscript>
	CRLF=chr(13)&chr(10);
	file_content = ArrayNew(1);
	file_content2 = ArrayNew(1);	
	
	for(i = 1; i lte line_count; i = i + 1){
	
		SQLString = "SELECT
						*
					 FROM
						get_product_main
					 WHERE
						BARCODE = '#listfirst(dosya[i], ",")#'";
		get_product = cfquerytoquery(SQLString : SQLString);
		
		ext = '';
		if(listlen(dosya[i],',') gt 2) 
			ext = listgetat(dosya[i], 3, ',');
		else  
		ext = ':' & satir & i & yok & '...';
		file_content[i] = '<tr>';
		file_content[i] = file_content[i] & '	<td height="20">#i#</td>';
		file_content[i] = file_content[i] & '	<td>#get_product.STOCK_CODE#</td>';
		file_content[i] = file_content[i] & '	<td>#listfirst(dosya[i],',')#</td>';
		file_content[i] = file_content[i] & '	<td>#get_product.PRODUCT_NAME#-#get_product.PROPERTY#</td>';
		file_content[i] = file_content[i] & '	<td>' & ext & '</td>';
		file_content[i] = file_content[i] & '	<td>#listgetat(dosya[i], 2, ",")#</td>';
		file_content[i] = file_content[i] & '	<td>#get_product.ADD_UNIT#</td>';
		file_content2[i] = file_content[i] & '</tr>';
		file_content[i] = file_content[i] & '</tr>' & CRLF;
		
		writeoutput(file_content[i]);
	
	}	

</cfscript>		
	
<!--- 	<cfloop from="1" to="#line_count#" index="i">
	<cfquery name="get_product" dbtype="query">
		SELECT
			*
		FROM
			get_product_main
		WHERE
			BARCODE = '#listfirst(dosya[i], ",")#'
	</cfquery>
	<cfoutput>
		<tr>
			<td height="20">#i#</td>
			<td>#get_product.STOCK_CODE#</td>
			<td>#listfirst(dosya[i],",")#</td>
			<td>#get_product.PRODUCT_NAME#-#get_product.PROPERTY#</td>
			<td><cfif listlen(dosya[i],",") gt 2>#listgetat(dosya[i], 3, ",")#<cfelse> <cf_get_lang_main no='1096.Satır'> : #i# <cf_get_lang no='738.de isim yok'>...</cfif></td>
			<td>#listgetat(dosya[i], 2, ",")#</td>
			<td>#get_product.ADD_UNIT#</td>
		</tr>
	</cfoutput>
</cfloop> --->
<!-- sil -->

<cfoutput>
<form action="#request.self#?fuseaction=objects.emptypopup_import_stock_open_phl" method="post" name="send">
	<input type="hidden" name="processdate" id="processdate" value="#DateFormat(attributes.processdate,dateformat_style)#">
	<cfif IsDefined("location_id")>
	<input type="hidden" name="location_id" id="location_id" value="#location_id#">
	</cfif>
	<input type="hidden" name="operation_type" id="operation_type" value="#operation_type#">
	<input type="hidden" name="store_id" id="store_id" value="#store_id#">
	<input type="hidden" name="form_kontrol" id="form_kontrol" value="">
	<input type="hidden" name="file_name" id="file_name" value="#file_name#">
	<input type="hidden" name="target_pos" id="target_pos" value="#attributes.target_pos#">
	<input type="hidden" name="file_size" id="file_size" value="#file_size#">
	<textarea name="html_content" id="html_content" style="display:none;"></textarea>
	<textarea name="dosya_content" id="dosya_content" style="display:none;"></textarea>
	<tr>
		<td colspan="10"  style="text-align:right;"><cf_workcube_buttons is_upd='0'></td>
	</tr>
</form>
</cfoutput>
	
</table>
<cfset content2 = '<tr><td colspan="10" style="text-align:right;"></td></tr></table>'>
<cfsavecontent variable="rapor"><cf_get_lang no='734.Stok Import Öncesi Rapor'></cfsavecontent>
<cfsavecontent variable="no"><cf_get_lang no='300.No'></cfsavecontent>
<cfsavecontent variable="Barkod"><cf_get_lang_main no='221.Barkod'></cfsavecontent>
<cfsavecontent variable="kod"><cf_get_lang no='735.Workcube Kod'></cfsavecontent>
<cfsavecontent variable="ad"><cf_get_lang no='736.Workcubedeki Adı'></cfsavecontent>
<cfsavecontent variable="belge"><cf_get_lang no='737.Belgedeki Adı'></cfsavecontent>
<cfsavecontent variable="miktar"><cf_get_lang_main no='223.Miktar'></cfsavecontent>
<cfsavecontent variable="birim"><cf_get_lang_main no='224.Birim'></cfsavecontent>

<cfset content1 = '<table width="98%" border="1" align="center"><tr><td class="headbold" height="35">#rapor#</td></tr></table><table border="1"><tr height="22"><td width="30">#no#</td><td height="20" width="100">#Barkod#</td><td width="100">#kod#</td><td>#ad#</td><td width="350">#belge#</td><td width="50">#miktar#</td><td width="50">#birim#</td></tr>'>

<script type="text/javascript">
	/*alert('sdfsdf');*/
	document.send.html_content.value = '<cfoutput>#content1##ArraytoList(file_content2," ")##content2#</cfoutput>';
	document.send.dosya_content.value = '<cfoutput>#ArraytoList(dosya,"$")#</cfoutput>';	
</script>
<!-- sil -->
<!--- <cffile action="write" output="#content1# & #ArraytoList(file_content,CRLF)# & #content2#" addnewline="yes" file="#upload_folder##attributes.html_file#" charset="ISO-8859-9"> --->
<!--- Belge Kontrol Edildi --->
<CFFILE action="delete" file="#upload_folder##file_name#">
