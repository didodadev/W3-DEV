<cfsetting showdebugoutput="no">
<cfset attributes.xml_price_discount_show = 1>
<cfset day_start = createdatetime(year(now()),month(now()),day(now()),0,0,0)>
<cfset day_finish = createdatetime(year(now()),month(now()),day(now()),23,59,59)>


<cfquery name="GET_PRODUCTS" datasource="#DSN3#"> 
	SELECT
		P.PRODUCT_NAME,
		P.SHELF_LIFE,
		P.PRODUCT_ID,
        PC.HIERARCHY,
        S.STOCK_ID,	
		S.PROPERTY,		
		GSB.BARCODE,
		PRC.PRICE,
		ISNULL(( 
                SELECT TOP 1 
                    PT1.NEW_PRICE_KDV
                FROM
                    #DSN_DEV#.PRICE_TABLE PT1
                WHERE
                    PT1.IS_ACTIVE_S = 1 AND
                    PT1.STARTDATE <= #bugun_# AND DATEADD("d",-1,PT1.FINISHDATE) >= #bugun_# AND
                    (PT1.STOCK_ID = S.STOCK_ID OR (PT1.STOCK_ID IS NULL AND PT1.PRODUCT_ID = P.PRODUCT_ID)) AND
                    PT1.ROW_ID NOT IN (SELECT PTD1.ROW_ID FROM #DSN_DEV#.PRICE_TABLE_DEPARTMENTS PTD1)
                ORDER BY               
			PT1.STARTDATE DESC, 	
			PT1.ROW_ID DESC
            ),PRC.PRICE_KDV) AS LISTE_FIYATI,
        ISNULL(( 
                SELECT TOP 1 
                    PT1.NEW_PRICE_KDV
                FROM
                    #DSN_DEV#.PRICE_TABLE PT1
                WHERE
                    PT1.IS_ACTIVE_S = 1 AND
                    (
                    PT1.STARTDATE <= #bugun_# AND DATEADD("d",-1,PT1.FINISHDATE) >= #bugun_#
                    ) 
                    AND
                    (PT1.STOCK_ID = S.STOCK_ID OR (PT1.STOCK_ID IS NULL AND PT1.PRODUCT_ID = P.PRODUCT_ID))
                    AND
                    PT1.ROW_ID IN (SELECT PTD1.ROW_ID FROM #DSN_DEV#.PRICE_TABLE_DEPARTMENTS PTD1 WHERE PTD1.DEPARTMENT_ID = #attributes.department_id#)
                ORDER BY
                	PT1.STARTDATE DESC,
					PT1.ROW_ID DESC
            ),-1) AS PRICE_KDV_DEPT,
		PRC.IS_KDV,
		0 PRICE_DISCOUNT,
		ST.TAX
	FROM
		#dsn2_alias#.SETUP_TAX ST,
		PRODUCT P,
        PRODUCT_CAT PC,
		STOCKS S,
		GET_STOCK_BARCODES GSB,
		PRICE_STANDART PRC
	WHERE
    	P.PRODUCT_CATID = PC.PRODUCT_CATID AND
		P.PRODUCT_STATUS = 1 AND
		S.STOCK_STATUS = 1 AND
		P.IS_TERAZI = 1 AND
        PRC.PURCHASESALES = 1 AND
		PRC.PRICESTANDART_STATUS = 1 AND
	<cfif attributes.is_all eq 0>
    	<cfif isdate(attributes.product_startdate)>
                (
                S.PRODUCT_ID IN 
                    (
                        SELECT 
                            PRODUCT_ID
                        FROM
                            #DSN_DEV#.PRICE_TABLE PT1
                        WHERE
                            PT1.IS_ACTIVE_S = 1 AND
                            (
                                PT1.STARTDATE BETWEEN #attributes.product_startdate# AND #attributes.product_finishdate# OR
                                DATEADD("d",-1,PT1.FINISHDATE) BETWEEN #attributes.product_startdate# AND #attributes.product_finishdate#
                            )
                    )
                OR
                (
                PRC.START_DATE >= #attributes.product_startdate# AND 
                PRC.START_DATE < #dateadd('d',1,attributes.product_finishdate)#
                )
                OR
                P.RECORD_DATE BETWEEN #attributes.product_startdate# AND #dateadd('d',1,attributes.product_finishdate)#
                OR
                S.UPDATE_DATE BETWEEN #attributes.product_startdate# AND #dateadd('d',1,attributes.product_finishdate)#
             ) 
             AND
        </cfif>	
    </cfif>
	<cfif isdefined("attributes.product_code") and len(attributes.product_code)>
		PC.HIERARCHY LIKE '#attributes.product_code#.%' AND
	</cfif>
		PRC.UNIT_ID = S.PRODUCT_UNIT_ID AND
		ST.TAX = P.TAX AND
		P.PRODUCT_ID = PRC.PRODUCT_ID AND
		GSB.PRODUCT_ID = PRC.PRODUCT_ID AND
		GSB.STOCK_ID = S.STOCK_ID AND
		LEN(GSB.BARCODE) = 7
        <cfif isdefined("form.product_cat_id") and len(form.product_cat_id)>
		AND 
        	(
            <cfset count_ = 0>
            <cfloop list="#attributes.product_cat_id#" index="ccc">
                <cfset count_ = count_ + 1>
                P.PRODUCT_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#ccc#.%">
                <cfif count_ Neq listlen(attributes.product_cat_id)>
                    OR
                </cfif>
            </cfloop>
            )
	</cfif>
</cfquery>

<cfscript>
	attributes.ext = -2;
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

		<cfloop query="get_products">
			<cfif len(PRICE_KDV_DEPT) and PRICE_KDV_DEPT gt -1>
            	<cfset urun_fiyat = PRICE_KDV_DEPT>
            <cfelse>
				<cfset urun_fiyat = LISTE_FIYATI>
            </cfif>
            
            <cfset stock_id_ = stock_id>
            <cfset stock_id_ = repeatString("0",6-len(stock_id_)) & stock_id_>
            <cfset stock_id_ = stock_id_ & repeatString(" ",2)>
            <cfset stock_id_ = stock_id_ & '0'>

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
            
            <cfset urun_oncesi_bosluk = repeatString(" ",5)>

			<cfset urun_fiyat = Replace(TLFormat(urun_fiyat),'.','','ALL')>
            <cfset urun_fiyat = Replace(urun_fiyat,',','.','ALL')>
            
			<cfset urun_adi = left("#Property#",25)>
			<cfif len(trim(urun_adi)) eq 0>
            	<cfset urun_adi = left("#product_name#",25)>
            </cfif>
            
            <cfset urun_adi = ReplaceList(urun_adi, "Ü,Ğ,İ,Ş,Ç,Ö,ü,ğ,ı,ş,ç,ö", "U,G,I,S,C,O,u,g,i,s,c,o")>
            <cfset urun_adi = replace(urun_adi,'@','','all')>
            <cfset urun_adi = replace(urun_adi,'*','','all')>
            <cfset urun_adi = replace(urun_adi,'##','','all')>
            <cfset urun_adi = replace(urun_adi,'"','','all')>
            <cfset urun_adi = replace(urun_adi,"'","",'all')>
            <cfset urun_adi = replace(urun_adi,"$","",'all')>
            <cfset urun_adi = replace(urun_adi,'_','','all')>
            <cfset urun_adi = replace(urun_adi,'£','','all')>
            
			<cfif len(urun_adi) lt 25>
				<cfset urun_adi = urun_adi & repeatString(" ",25-len(urun_adi))>
			</cfif>
            
			<cfif len(urun_fiyat) gte 7>
				<cfset b3 = urun_fiyat>
			<cfelse>
				<cfset b3 = repeatString(" ",7-len(urun_fiyat)) & urun_fiyat>
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
            
            <cfset ozel_durum_ = "00 0000">
            <cfset ozel_durum_ = repeatString(" ",3) & ozel_durum_ & repeatString(" ",2)>
            
			<cfif attributes.xml_price_discount_show eq 1 and dosya_turu eq -2>
				<cfset satir = "#satir##stock_id_##barcode##urun_oncesi_bosluk##urun_adi##b3##ozel_durum_##CRLF#">
			<cfelse>
				<cfset satir = "#satir##barcode##urun_adi##right(barcode,4)##b3##urun_fiyat##raf_omru#00001#CRLF#">
			</cfif>
		</cfloop>
<cfif get_products.recordcount>
	<cffile action="write" output="#satir##CRLF#" addnewline="yes" file="#upload_folder#sube_terazi_dosyasi.dat" charset="utf-8">
</cfif>