<cfsetting showdebugoutput="no">
Promosyon Belgesi Oluşturma İşlemi Başladı, Lütfen Bekleyiniz...<br/>

<cf_date tarih="attributes.startdate">
<cfset attributes.startdate = date_add('h', attributes.start_hour, attributes.startdate)>
<cfset attributes.startdate = date_add('n', attributes.start_min, attributes.startdate)>

<cf_date tarih="attributes.finishdate">
<cfset attributes.finishdate = date_add('h', attributes.finish_hour, attributes.finishdate)>
<cfset attributes.finishdate = date_add('n', attributes.finish_min, attributes.finishdate)>

<cfscript>
	CRLF = Chr(13) & Chr(10); // satır atlama karakteri
	upload_folder = "#upload_folder#store#dir_seperator#";
	file_name = "#CreateUUID()#.GTF";
	dosya = ArrayNew(1);
</cfscript>

<!--- Promosyondaki Urunler Alinir --->
<cfquery name="GET_PROMS" datasource="#DSN3#">
	SELECT
		0 TYPE,
		S.PRODUCT_ID,
		P.*		
	FROM
		PROMOTIONS P,
		STOCKS S
	WHERE
		P.PROM_STATUS = 1 AND
		(P.STARTDATE >= #attributes.startdate# AND P.STARTDATE <= #attributes.finishdate#) AND
		P.LIMIT_TYPE = 1 AND
		P.LIMIT_VALUE IS NOT NULL	AND
		P.STOCK_ID IS NOT NULL AND
		(P.DISCOUNT IS NOT NULL OR P.AMOUNT_DISCOUNT IS NOT NULL) AND
		P.FREE_STOCK_ID IS NOT NULL AND
		P.FREE_STOCK_AMOUNT IS NOT NULL AND
		P.FREE_STOCK_ID = P.STOCK_ID AND
		S.STOCK_ID = P.STOCK_ID
	UNION ALL
	SELECT
		2 TYPE,
		S.PRODUCT_ID,
		P.*		
	FROM
		PROMOTIONS P,
		STOCKS S
	WHERE
		P.PROM_STATUS = 1 AND
		(P.FINISHDATE >= #attributes.startdate# AND P.FINISHDATE <= #attributes.finishdate#) AND
		P.LIMIT_TYPE = 1 AND
		P.LIMIT_VALUE IS NOT NULL AND
		P.STOCK_ID IS NOT NULL AND
		(P.DISCOUNT IS NOT NULL OR P.AMOUNT_DISCOUNT IS NOT NULL) AND
		P.FREE_STOCK_ID IS NOT NULL AND
		P.FREE_STOCK_AMOUNT IS NOT NULL AND
		P.FREE_STOCK_ID = P.STOCK_ID AND
		S.STOCK_ID = P.STOCK_ID
	ORDER BY
		TYPE
</cfquery>
<cfif not get_proms.recordcount>
	<script type="text/javascript">
		alert("Girdiğiniz Koşullara Uygun Kayıt Bulunamadı!");
		history.back();
	</script>
	<cfabort>
<cfelse>
	<br/>
	<strong>Ürün Sayısı : <cfoutput>#get_proms.recordcount#</cfoutput> <br/></strong>
	
	<cffile action="write" output="<SIGNATURE=GNDPROMOTION.GDF><VERSION=0227000>" addnewline="yes" file="#upload_folder##file_name#">
	
	<cfoutput query="get_proms">
	  <cftry>
		<cfscript>
			///////////////////////////////////////////   1. SATIR   ////////////////////////////////////////
			/*satir1 = "01 " & repeatString(" ", 500);										// satir no 
			satir1 = yerles(satir1, "0", 3, 1, " ");										//işlem türü
			satir1 = yerles(satir1, "#left('#PRODUCT_ID#.#STOCK_ID#',24)#", 4, 24, " ");					//ürün kodu
			satir1 = yerles(satir1, "2", 28, 12, " ");										//promosyon tipi (standart şu an için 2- buda iki kesin tarih arası demektir...)			
			satir1 = yerles(satir1, "0", 40, 1, " ");
			satir1 = yerles(satir1, "#dateformat(get_genius_promotion.startdate,'yyyymmdd')##timeformat(get_genius_promotion.startdate,'HHMM')#00", 41, 14, " ");
			satir1 = yerles(satir1, "#dateformat(get_genius_promotion.finishdate,'yyyymmdd')##timeformat(get_genius_promotion.finishdate,'HHMM')#00", 55, 14, " ");
			satir1 = yerles(satir1, "", 69, 3, "0");
			satir1 = yerles(satir1, "", 72, 2, "0");
			satir1 = yerles(satir1, "#get_genius_promotion.discount#", 74, 15, "0");
			satir1 = yerles(satir1, "", 89, 15, "0");
			satir1 = yerles(satir1, "", 104, 15, "0");
			satir1 = yerles(satir1, "0", 119, 1, "0");*/
			
			
			//yerles kullanimi :nereye,neyi,baslangic_kolonu,uzunluk,ne ile tamamlayacak
		
			satir1 = "01" & repeatString(" ", 292);	
			bas = 3 ;																			//Toplamda 255 * olarak bas istediginde gormek icin
			
			satir1 = yerles(satir1,"#type#",bas,1,'');											//İslem türü
			bas = bas + 1;										
			satir1 = yerles(satir1, "#product_id#.#stock_id#", bas, 24, " ");					//Urun Kodu product_id.stock_id aldik
			bas = bas + 24;
			satir1 = yerles(satir1, 1, bas, 12, " ");											//Promosyon Tipi
			bas = bas + 12;
			
			satir1 = yerles_saga(satir1, "#limit_value#", bas, 4, "0");							//Ne kadar urunde indirim yapilacagi
			bas = bas + 4;
			satir1 = yerles_saga(satir1, "#free_stock_amount#", bas, 4, "0");					//Ne kadar ürüne yapilacagi
			bas = bas + 4;
			
			if(len(discount)) //Yuzde indirimi dolu ise
				satir1 = yerles_saga(satir1, "#discount#", bas, 15, "0");						//Urune ne kadar yuzde indirim yapilacagi
			else
				satir1 = yerles_saga(satir1,"", bas, 15, "0");
			bas = bas + 15;
		
			if(len(amount_discount)) //Tutar indirimi dolu ise
				satir1 = yerles_saga(satir1, "#amount_discount#", bas, 15, "0");				//Urune ne kadar tutar indirim yapilacagi
			else
				satir1 = yerles_saga(satir1,"", bas, 15, "0");
			bas = bas + 15;
			
			satir1 = yerles_saga(satir1,"1", bas, 1, "1");										// O degeri tum kartlarda kullanimini temsil eder
	
			ArrayAppend(dosya,satir1);
		</cfscript>
		#product_id#.#stock_id#<br/> 
		<cfcatch type="any">
			#currentrow#. Satırda hata !<br/>
		</cfcatch>
	  </cftry>		
	</cfoutput>
	
	<cffile action="append" output="#ArrayToList(dosya,CRLF)#" addnewline="yes" file="#upload_folder##file_name#" charset="utf-8">
	
	<!--- Tabloya kaydedilir --->
	<cfquery name="ADD_FILE" datasource="#DSN2#">
		INSERT INTO
			FILE_EXPORTS
		(
			TARGET_SYSTEM,
			PROCESS_TYPE,
			PRODUCT_COUNT,
			FILE_NAME,
			FILE_SERVER_ID,
			STARTDATE,
			FINISHDATE,
			DEPARTMENT_ID,
			RECORD_EMP,
			RECORD_DATE,
			RECORD_IP
		)
		VALUES
		(
			#target_pos#,
			-4,
			#get_proms.recordcount#,
			'#file_name#',
			#fusebox.server_machine#,
			#attributes.startdate#,
			#attributes.finishdate#,
			NULL,
			#session.ep.userid#,
			#now()#,
			'#cgi.remote_addr#'
		)
	</cfquery>
	
	Promosyon Belgesi Oluşturuldu.<br/>
	<input type="button" value=" Kapat " onClick="window.close();">
</cfif>
