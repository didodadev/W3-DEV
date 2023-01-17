<cfsetting showdebugoutput="no">
<cfset day_start = createdatetime(year(now()),month(now()),day(now()),0,0,0)>
<cfset day_finish = createdatetime(year(now()),month(now()),day(now()),23,59,59)>
<cfquery name="GET_PRODUCTS" datasource="#DSN3#"> 
	SELECT
		P.PRODUCT_NAME,
		P.SHELF_LIFE,
		P.PRODUCT_ID,
		S.PROPERTY,		
		GSB.BARCODE,
		PRC.PRICE,
		PRC.PRICE_KDV,
		PRC.IS_KDV,
	<cfif attributes.price_cat_id neq -1>
		ISNULL(PRC.PRICE_DISCOUNT,0) PRICE_DISCOUNT,
	<cfelse>
		0 PRICE_DISCOUNT,
	</cfif>
	<cfif attributes.ext eq -5>
		PU.MAIN_UNIT,
	</cfif>
		ST.TAX
	FROM
		#dsn2_alias#.SETUP_TAX ST,
		PRODUCT P,
		STOCKS S,
		GET_STOCK_BARCODES GSB,
	<cfif attributes.ext eq -5>
		PRODUCT_UNIT PU,
	</cfif>
	<cfif attributes.price_cat_id neq -1>
		PRICE PRC
	<cfelse>
		PRICE_STANDART PRC
	</cfif>
	WHERE
		P.PRODUCT_STATUS = 1 AND
		S.STOCK_STATUS = 1 AND
		P.IS_TERAZI = 1 AND
	<cfif attributes.ext eq -5>
		P.PRODUCT_ID = PU.PRODUCT_ID AND 
		PU.PRODUCT_UNIT_STATUS = 1 AND
		PU.IS_MAIN = 1 AND
	</cfif>
	<cfif attributes.price_cat_id neq -1>
		PRC.PRICE_CATID = #attributes.price_cat_id# AND
 	  <cfif isdefined("attributes.is_daily")>
		PRC.STARTDATE BETWEEN #day_start# AND #day_finish# AND
		(PRC.FINISHDATE >= #now()# OR PRC.FINISHDATE IS NULL) AND
	  <cfelse>
		PRC.STARTDATE <= #now()# AND
		(PRC.FINISHDATE >= #now()# OR PRC.FINISHDATE IS NULL) AND
	  </cfif>
	<cfelse>
		PRC.PRICESTANDART_STATUS = 1 AND
		PRC.PURCHASESALES = 1 AND
	</cfif>
	<cfif isdefined("attributes.product_code") and len(attributes.product_code)>
		P.PRODUCT_CODE LIKE '#attributes.product_code#%' AND
	</cfif>
	<cfif attributes.price_cat_id neq -1>
		PRC.UNIT = S.PRODUCT_UNIT_ID AND
	<cfelse>
		PRC.UNIT_ID = S.PRODUCT_UNIT_ID AND
	</cfif>
		ST.TAX = P.TAX AND
		P.PRODUCT_ID = PRC.PRODUCT_ID AND
		GSB.PRODUCT_ID = PRC.PRODUCT_ID AND
		GSB.STOCK_ID = S.STOCK_ID AND
		LEN(GSB.BARCODE) = 7
</cfquery> 
<cfscript>
	// satır atlama karakteri
	CRLF=chr(13)&chr(10);
	file_content = ArrayNew(1);
	index_array = 1;
	satir1 = "";
	satir2 = "";
	dosya_turu=attributes.ext;
	satir = "";
	if(attributes.ext eq -1 or attributes.ext eq -5 or attributes.ext eq -7)
		attributes.ext = '.txt';
	else if(attributes.ext eq -6)
		attributes.ext = '.plu';
	else
		attributes.ext = '.dat';
</cfscript>

<cfswitch expression="#dosya_turu#">
	<cfcase value="-1,-2"><!--- Mettler,Bizerba --->
		<cfloop query="get_products">
			<cfif is_kdv is "1">
				<cfset urun_fiyat = price_kdv>
			<cfelse>
				<cfset urun_fiyat = wrk_round((price*(100+tax)) / 100)>
			</cfif>
			<!--- kart indiriminin terazi dosyasına yansıması icin BK 20100209 --->
			<cfif attributes.xml_price_discount_show eq 1 and dosya_turu eq -2>
				<cfset urun_fiyat2 = urun_fiyat-price_discount>
				<cfif urun_fiyat eq urun_fiyat2>
					<cfset urun_fiyat2 = 0>
				</cfif>
				<cfset urun_fiyat2 = Replace(TLFormat(urun_fiyat2),'.','','ALL')>
				<cfif len(urun_fiyat2) gte 10>
					<cfset c3 = "">
				<cfelse>
					<cfset c3 = repeatString("0",10-len(urun_fiyat2))>
				</cfif>					
			</cfif>

			<cfset urun_fiyat = Replace(TLFormat(urun_fiyat),'.','','ALL')>
			<cfset urun_adi = left("#Product_name# #Property#",25)>
			<cfif len(urun_adi) lt 25>
				<cfset urun_adi = urun_adi&repeatString(" ",25-len(urun_adi))>
			</cfif>
			<cfset urun_adi = ReplaceList(urun_adi, "Ü,Ğ,İ,Ş,Ç,Ö,ü,ğ,ı,ş,ç,ö", "U,G,I,S,C,O,u,g,i,s,c,o")>
			<cfif len(urun_fiyat) gte 10>
				<cfset b3 = "">
			<cfelse>
				<cfset b3 = repeatString("0",10-len(urun_fiyat))>
			</cfif>
			
			<!--- Urun detayındaki raf omru numeric ve uzunlugu varmi? --->
			<cfif isnumeric(left(shelf_life,2)) and len(shelf_life)>
				<cfset raf_omru = left(trim("#shelf_life#"),2)>
				<!--- elde edilen ifadenin uzunlugu 1 karakter ise basina 0 ekle --->
				<cfif len(raf_omru) eq 1>
					<cfset raf_omru = repeatString("0",1)&raf_omru>
				</cfif>
			<cfelse>
				<cfset raf_omru = '00'>
			</cfif>
			<cfif attributes.xml_price_discount_show eq 1 and dosya_turu eq -2>
				<cfset satir = "#satir##barcode##urun_adi##right(barcode,4)##b3##urun_fiyat##raf_omru#00001#c3##urun_fiyat2##CRLF#">
			<cfelse>
				<cfset satir = "#satir##barcode##urun_adi##right(barcode,4)##b3##urun_fiyat##raf_omru#00001#CRLF#">
			</cfif>
			<!--- <cfset satir = "#satir##barcode##urun_adi##right(barcode,4)##b3##urun_fiyat##raf_omru#00001#CRLF#"> --->
		</cfloop>
	</cfcase>
	<cfcase value="-3"><!--- Diji --->	
		<cfloop query="get_products">
			<cfif is_kdv is "1">
				<cfset urun_fiyat = price_kdv>
			<cfelse>
				<cfset urun_fiyat = wrk_round((price*(100+tax)) / 100)>
			</cfif>
			<cfset urun_fiyat=Replace(left((urun_fiyat*100),6),".","")>
			<cfset urun_adi = left("#Product_name# #Property#",20)>
			<cfif len(urun_adi) lt 20>
				<cfset urun_adi = "#urun_adi##repeatString(" ",20-len(urun_adi))#">
			</cfif>
			<cfset urun_adi = ReplaceList(urun_adi, "Ü,Ğ,İ,Ş,Ç,Ö,ü,ğ,ı,ş,ç,ö", "U,G,I,S,C,O,u,g,i,s,c,o")>
			<cfset raf_omru = left(trim("#shelf_life#"),3)>
			<cfscript>
				tab=chr(9);
				fiyat_uzunluk=len(trim(urun_fiyat));
				satir1 = "WHFA" & repeatString(" ",51+fiyat_uzunluk);
				satir1=yerles(satir1,right(barcode,5),5,5," ");
				satir1=yerles(satir1,tab,10,1," ");
				satir1=yerles(satir1,"B",11,1," ");
				satir1=yerles(satir1,urun_fiyat,12,fiyat_uzunluk," ");
				yer=12+fiyat_uzunluk;	
				satir1=yerles(satir1,tab,yer,1," ");
				yer=yer+1;
				satir1=yerles(satir1,"C17",yer,3," ");
				yer=yer+3;
				satir1=yerles(satir1,tab,yer,1," ");
				yer=yer+1;
				satir1=yerles(satir1,"E5",yer,2," ");
				yer=yer+2;
				satir1=yerles(satir1,tab,yer,1," ");
				yer=yer+1;
				satir1=yerles(satir1,"F",yer,1," ");
				yer=yer+1;
				satir1=yerles(satir1,barcode,yer,13,'0');
				yer=yer+13;
				satir1=yerles(satir1,"1",yer,1,'1');//ağırlıklı ürünse 1 adetli ise 2 olacak
				yer=yer+1;
				satir1=yerles(satir1,tab,yer,1," ");
				yer=yer+1;
				satir1=yerles(satir1,"G0997",yer,5," ");//default değer
				yer=yer+5;
				satir1=yerles(satir1,tab,yer,1," ");
				yer=yer+1;
				satir1=yerles(satir1,"H0",yer,2," ");//son ürünün alındığı tarih max 3
				yer=yer+2;
				satir1=yerles(satir1,tab,yer,1," ");
				yer=yer+1;
				satir1 = yerles_saga(satir1,"K",yer,1," ");
				yer=yer+1;		
				satir1=yerles_saga(satir1,raf_omru,yer,3,"0");//raf ömrü
				yer=yer+3;
				satir1=yerles(satir1,tab,yer,1," ");
				yer=yer+1;
				satir1=yerles(satir1,"Q7400",yer,5," ");//ağırlıklı ürünse q7400 adetli ise q7500 olacak
				yer=yer+5;
				satir1=yerles(satir1,tab,yer,1," ");
	
				urun_uzunluk=len(trim(urun_adi));
				satir2 = "WHHA" & repeatString(" ",14+urun_uzunluk);
				satir2=yerles(satir2,right(barcode,5),5,5," ");
				satir2=yerles(satir2,tab,10,1," ");
				satir2=yerles(satir2,"B1",11,2," ");
				satir2=yerles(satir2,tab,13,1," ");
				satir2=yerles(satir2,"C7",14,2," ");
				satir2=yerles(satir2,tab,16,1," ");
				satir2=yerles(satir2,'D',17,1," ");
				satir2=yerles(satir2,trim(urun_adi),18,urun_uzunluk," ");
				yer2=18+urun_uzunluk;
				satir2=yerles(satir2,tab,yer2,1," ");
				
				file_content[index_array] = "#satir1#";
				index_array = index_array+1;
				file_content[index_array] = "#satir2#";
				index_array = index_array+1;
			</cfscript>
		</cfloop>			
		<cfset satir = ArraytoList(file_content,CRLF)>
	</cfcase>
	<cfcase value="-4,-6"><!--- Epelsa,CAS.plu --->
		<cfloop query="get_products">
			<cfif is_kdv is "1">
				<cfset urun_fiyat = price_kdv>
			<cfelse>
				<cfset urun_fiyat = wrk_round((price*(100+tax)) / 100)>
			</cfif>
			<cfset urun_fiyat=Replace(left((urun_fiyat*100),10),".","")>
			<cfset urun_adi = left("#Product_name# #Property#",25)>
			<cfif len(urun_adi) lt 25>
				<cfset urun_adi = "#urun_adi##repeatString(" ",25-len(urun_adi))#">
			</cfif>
			<cfset urun_adi = ReplaceList(urun_adi, "Ü,Ğ,İ,Ş,Ç,Ö,ü,ğ,ı,ş,ç,ö", "U,G,I,S,C,O,u,g,i,s,c,o")>			
			<cfset raf_omru = left(trim("#shelf_life#"),3)>
			<cfscript>
				satir1 = "#barcode#" & repeatString(" ",49);
				satir1=yerles(satir1,urun_adi,8,25," ");
				satir1=yerles(satir1,right("#barcode#",4),33,4," ");
				satir1=yerles_saga(satir1,urun_fiyat,37,10," ");
				satir1=yerles(satir1,"0100001",47,7," ");
				satir1=yerles_saga(satir1,raf_omru,54,3,"0");//raf ömrü	
				file_content[index_array] = "#satir1#";
				index_array = index_array+1;
			</cfscript>
		</cfloop>
		<cfset satir = ArraytoList(file_content,CRLF)>
	</cfcase>
	<cfcase value="-5"><!--- CAS.txt --->
		<cfloop query="get_products">
			<cfif is_kdv is "1">
				<cfset urun_fiyat = price_kdv>
			<cfelse>
				<cfset urun_fiyat = wrk_round((price*(100+tax)) / 100)>
			</cfif>
			<cfset urun_fiyat=Replace(left((urun_fiyat*100),10),".","")>
			<cfset urun_adi = left("#Product_name# #Property#",25)>
			<cfif len(urun_adi) lt 25>
				<cfset urun_adi = "#urun_adi##repeatString(" ",25-len(urun_adi))#">
			</cfif>
			<cfset urun_adi = ReplaceList(urun_adi, "Ü,Ğ,İ,Ş,Ç,Ö,ü,ğ,ı,ş,ç,ö", "U,G,I,S,C,O,u,g,i,s,c,o")>			
			<cfset raf_omru = left(trim("#shelf_life#"),3)>
			<!--- Urun ana birimi adetmi degilmi onun kontrolu BK 20090414 --->
			<cfif main_unit eq 'Adet'>
				<cfset temp_unit = 2>
			<cfelse>
				<cfset temp_unit = 1>
			</cfif>
			<cfscript>
				satir1 = "#barcode#" & repeatString(" ",50);
				satir1=yerles(satir1,urun_adi,8,25," ");
				satir1=yerles(satir1,right("#barcode#",4),33,4," ");
				satir1=yerles_saga(satir1,urun_fiyat,37,10,"0");
				satir1=yerles(satir1,"0100001",47,7," ");
				satir1=yerles_saga(satir1,raf_omru,54,3,"0");		//raf omru
				satir1=yerles_saga(satir1,temp_unit,57,1,"1");		//adet mi kg mi? Terazideki plu_type ifadesine karsilik gelmekte
				file_content[index_array] = "#satir1#";
				index_array = index_array+1;
			</cfscript>
		</cfloop>
		<cfset satir = ArraytoList(file_content,CRLF)>
		<!--- Papoglundaki ozel durum icin eklendi. Son satir iki satir oluyor. BK 20090523 --->
		<cfset satir = satir & "#CRLF##satir1#">
	</cfcase>
	<cfcase value="-7"><!--- AveryBerkel.txt --->
		<cfloop query="get_products">
			<cfif is_kdv is "1">
				<cfset urun_fiyat = price_kdv>
			<cfelse>
				<cfset urun_fiyat = wrk_round((price*(100+tax)) / 100)>
			</cfif>
			<cfset urun_fiyat=Replace(left((urun_fiyat*100),10),".","")>
			
			<cfif len(urun_fiyat) gte 6>
				<cfset b3 = "">
			<cfelse>
				<cfset b3 = repeatString("0",6-len(urun_fiyat))>
			</cfif>
			<cfset urun_fiyat = "#b3##urun_fiyat#">
			<cfset urun_adi = left("#Product_name# #Property#",52)>
			<cfif len(urun_adi) lt 52>
				<cfset urun_adi = "#urun_adi##repeatString(" ",52-len(urun_adi))#">
			</cfif>
			<cfset urun_adi = ReplaceList(urun_adi, "Ü,Ğ,İ,Ş,Ç,Ö,ü,ğ,ı,ş,ç,ö", "U,G,I,S,C,O,u,g,i,s,c,o")>			
			<cfscript>
				satir1 = "#urun_adi#" & repeatString(" ",18);
				satir1 = yerles(satir1,urun_fiyat,52,10,"0");
				satir1 = yerles_saga(satir1,barcode,63,7," ");
				file_content[index_array] = "#satir1#";
				index_array = index_array+1;
			</cfscript>
		</cfloop>
		<cfset satir = ArraytoList(file_content,CRLF)>
	</cfcase>
	<cfdefaultcase>
	</cfdefaultcase>
</cfswitch>

<cfheader name="Expires" value="#Now()#">
<cfcontent type="text/vnd.plain;charset=ISO-8859-9">
<cfheader name="Content-Disposition" value="attachment; filename=#attributes.file_name##attributes.ext#">
<cfoutput>#satir##CRLF#</cfoutput>
