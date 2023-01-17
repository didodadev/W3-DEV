<cfparam name="attributes.price_transfer_type" default="2"><!---Ürün Kartı Bağlantısız Fiyat Dosyası Aktarımı İçin--->
<cfif isdefined('attributes.upd')> <!---Mutfak Aktarım Fiyat Aktarım Sonrası Satır Fiyat Güncelleme--->
	<cfif isdefined('is_price_change')>
        <cfquery name="upd_row" datasource="#dsn3#">
            UPDATE       
                EZGI_VIRTUAL_OFFER_ROW
            SET                
                PRICE = #attributes.toplam#, 
                OTHER_MONEY = '#attributes.money#',
              	PURCHASE_PRICE = #attributes.purchase_total#,
             	PURCHASE_PRICE_MONEY = '#attributes.money#',
             	COST_PRICE = #attributes.cost_total#,
             	COST_PRICE_MONEY = '#attributes.money#'
            WHERE        
                EZGI_ID = #attributes.ezgi_id#
        </cfquery>
    </cfif>
    <script type="text/javascript">
		wrk_opener_reload();
		window.close();
	</script>
<cfelseif isdefined('attributes.price_upd')> <!---Maliyet ve Bayi Alış Güncelleme Yapılacaksa--->
	<cfquery name="upd_row" datasource="#dsn3#">
     	UPDATE       
        	EZGI_VIRTUAL_OFFER_ROW
      	SET                
       		PURCHASE_PRICE = #FilterNum(attributes.purchase_price_,2)#,
        	PURCHASE_PRICE_MONEY = '#attributes.purchase_price_money_#',
         	COST_PRICE = #FilterNum(attributes.cost_price_,2)#,
         	COST_PRICE_MONEY = '#attributes.cost_price_money_#'
     	WHERE        
       		EZGI_ID = #attributes.ezgi_id#
  	</cfquery>
    <script type="text/javascript">
		alert('<cf_get_lang_main no='1428.Güncelleme İşleminiz Başarıyla Tamamlanmıştır.'>!');
		wrk_opener_reload();
		window.close();
	</script>
    <cfabort>
<cfelseif isdefined('attributes.upd_standart')><!---Kapı Tanımlama Sayfasından Geliyorsa--->
	<cftransaction>
        <cfquery name="upd_row" datasource="#dsn3#">
            UPDATE       
                EZGI_VIRTUAL_OFFER_ROW
            SET    
            	<cfif isdefined('is_price_change')>            
                    PRICE = #attributes.toplam#, 
                    OTHER_MONEY = '#attributes.money#',
                    PURCHASE_PRICE = <cfif len(attributes.purchase_total)>#attributes.purchase_total#<cfelse>0</cfif>,
                    PURCHASE_PRICE_MONEY = '#attributes.money#',
                    COST_PRICE = <cfif len(attributes.cost_total)>#attributes.cost_total#<cfelse>0</cfif>,
                    COST_PRICE_MONEY = '#attributes.money#',
                </cfif>
                BOY = #attributes.height#,
                EN = #attributes.width#,
                DERINLIK = #attributes.depth#,
                YON = #attributes.side#
            WHERE        
                EZGI_ID = #attributes.ezgi_id#
        </cfquery>
        <cfquery name="del_row" datasource="#dsn3#">
       		DELETE FROM EZGI_VIRTUAL_OFFER_ROW_DETAIL WHERE EZGI_ID = #attributes.ezgi_id#
     	</cfquery>
        <cfif ListLen(attributes.piece_row_id)><!--- Kapı İçin Soru sorulan veya hesap yapılan satır varmı--->
            <cfloop list="#attributes.piece_row_id#" index="i">
                <cfif isdefined('attributes.piece_type_#i#') and Evaluate('attributes.piece_type_#i#') eq 4><!---Satır Hammadde ise--->
                    <cfif isdefined('attributes.alternative_stock_id_4_#i#')><!---Alternatif Sorulmuşmu--->
                        <cfquery name="get_stock_id" datasource="#dsn3#">
                            SELECT 
                                STOCK_ID,
                                PRODUCT_CODE, 
                                PRODUCT_NAME, 
                                (SELECT MAIN_UNIT FROM PRODUCT_UNIT WHERE PRODUCT_UNIT_ID = STOCKS.PRODUCT_UNIT_ID AND IS_MAIN = 1) AS MAIN_UNIT
                            FROM 
                                STOCKS 
                            WHERE 
                                STOCK_ID=#Evaluate('attributes.alternative_stock_id_4_#i#')#
                        </cfquery>
                    <cfelse><!---Alternatif Soulmadıysa Kendisi--->
                        <cfquery name="get_stock_id" datasource="#dsn3#">
                            SELECT        
                                PIECE_ROW_ID STOCK_ID, 
                                PIECE_NAME PRODUCT_NAME, 
                                PIECE_CODE PRODUCT_CODE,
                                (SELECT DEFAULT_PIECE_UNIT FROM EZGI_DESIGN_DEFAULTS) AS MAIN_UNIT
                            FROM            
                                EZGI_DESIGN_PIECE_ROWS
                            WHERE        
                                PIECE_ROW_ID = #i#
                        </cfquery>
                    </cfif>
                <cfelseif isdefined('attributes.piece_type_#i#') and Evaluate('attributes.piece_type_#i#') eq 1> <!---Satır Yonga Levha İse (1)--->
                    <cfif isdefined('attributes.alternative_stock_id_1_#i#')><!---Alternatif Sorulmuşmu--->
                        <cfquery name="get_stock_id" datasource="#dsn3#">
                            SELECT        
                                PIECE_ROW_ID STOCK_ID, 
                                PIECE_NAME PRODUCT_NAME, 
                                PIECE_CODE PRODUCT_CODE,
                                (SELECT DEFAULT_PIECE_UNIT FROM EZGI_DESIGN_DEFAULTS) AS MAIN_UNIT
                            FROM            
                                EZGI_DESIGN_PIECE_ROWS
                            WHERE        
                                PIECE_ROW_ID = #Evaluate('attributes.alternative_stock_id_1_#i#')#
                        </cfquery>
                    <cfelse><!---Alternatif Soulmadıysa Kendisi--->
                        <cfquery name="get_stock_id" datasource="#dsn3#">
                            SELECT        
                                PIECE_ROW_ID STOCK_ID, 
                                PIECE_NAME PRODUCT_NAME, 
                                PIECE_CODE PRODUCT_CODE,
                                (SELECT DEFAULT_PIECE_UNIT FROM EZGI_DESIGN_DEFAULTS) AS MAIN_UNIT
                            FROM            
                                EZGI_DESIGN_PIECE_ROWS
                            WHERE        
                                PIECE_ROW_ID = #i#
                        </cfquery>
                    </cfif>
              	<cfelseif isdefined('attributes.piece_type_#i#') and Evaluate('attributes.piece_type_#i#') eq 2> <!---Satır Genel Reçete İse (2)--->
                    <cfif isdefined('attributes.alternative_stock_id_2_#i#')><!---Alternatif Sorulmuşmu--->
                        <cfquery name="get_stock_id" datasource="#dsn3#">
                            SELECT        
                                PIECE_ROW_ID STOCK_ID, 
                                PIECE_NAME PRODUCT_NAME, 
                                PIECE_CODE PRODUCT_CODE,
                                (SELECT DEFAULT_PIECE_UNIT FROM EZGI_DESIGN_DEFAULTS) AS MAIN_UNIT
                            FROM            
                                EZGI_DESIGN_PIECE_ROWS
                            WHERE        
                                PIECE_ROW_ID = #Evaluate('attributes.alternative_stock_id_2_#i#')#
                        </cfquery>
                    <cfelse><!---Alternatif Soulmadıysa Kendisi--->
                        <cfquery name="get_stock_id" datasource="#dsn3#">
                            SELECT        
                                PIECE_ROW_ID STOCK_ID, 
                                PIECE_NAME PRODUCT_NAME, 
                                PIECE_CODE PRODUCT_CODE,
                                (SELECT DEFAULT_PIECE_UNIT FROM EZGI_DESIGN_DEFAULTS) AS MAIN_UNIT
                            FROM            
                                EZGI_DESIGN_PIECE_ROWS
                            WHERE        
                                PIECE_ROW_ID = #i#
                        </cfquery>
                    </cfif>
              	<cfelseif isdefined('attributes.piece_type_#i#') and Evaluate('attributes.piece_type_#i#') eq 3> <!---Satır Montaj Ürünü İse (3)--->
                    <cfif isdefined('attributes.alternative_stock_id_3_#i#')><!---Alternatif Sorulmuşmu--->
                        <cfquery name="get_stock_id" datasource="#dsn3#">
                            SELECT        
                                PIECE_ROW_ID STOCK_ID, 
                                PIECE_NAME PRODUCT_NAME, 
                                PIECE_CODE PRODUCT_CODE,
                                (SELECT DEFAULT_PIECE_UNIT FROM EZGI_DESIGN_DEFAULTS) AS MAIN_UNIT
                            FROM            
                                EZGI_DESIGN_PIECE_ROWS
                            WHERE        
                                PIECE_ROW_ID = #Evaluate('attributes.alternative_stock_id_3_#i#')#
                        </cfquery>
                    <cfelse><!---Alternatif Soulmadıysa Kendisi--->
                        <cfquery name="get_stock_id" datasource="#dsn3#">
                            SELECT        
                                PIECE_ROW_ID STOCK_ID, 
                                PIECE_NAME PRODUCT_NAME, 
                                PIECE_CODE PRODUCT_CODE,
                                (SELECT DEFAULT_PIECE_UNIT FROM EZGI_DESIGN_DEFAULTS) AS MAIN_UNIT
                            FROM            
                                EZGI_DESIGN_PIECE_ROWS
                            WHERE        
                                PIECE_ROW_ID = #i#
                        </cfquery>
                    </cfif>
                <cfelseif isdefined('attributes.piece_type_#i#') and Evaluate('attributes.piece_type_#i#') eq 0> <!---Satır Ana Ürün mü--->
                	<cfquery name="get_stock_id" datasource="#dsn3#">
                     	SELECT 
                        	STOCK_ID,
                          	PRODUCT_CODE, 
                          	PRODUCT_NAME, 
                          	(SELECT MAIN_UNIT FROM PRODUCT_UNIT WHERE PRODUCT_UNIT_ID = STOCKS.PRODUCT_UNIT_ID AND IS_MAIN = 1) AS MAIN_UNIT
                     	FROM 
                         	STOCKS 
                     	WHERE 
                         	STOCK_ID= #attributes.stock_id_0#
                 	</cfquery>
                </cfif>
                <cfquery name="add_row" datasource="#dsn3#"> <!---Kapının Satır Detayları Kaydediliyor--->
                    INSERT INTO 
                        EZGI_VIRTUAL_OFFER_ROW_DETAIL
                            (
                                EZGI_ID, 
                                AMOUNT, 
                                LAST_AMOUNT, 
                                SALES_PRICE, 
                                SALES_PRICE_MONEY, 
                                PURCHASE_PRICE, 
                                PURCHASE_PRICE_MONEY, 
                                COST_PRICE, 
                                COST_PRICE_MONEY, 
                                STOCK_ID, 
                                PRODUCT_CODE, 
                                PRODUCT_NAME, 
                                MAIN_UNIT,
                                PIECE_ROW_ID,
                                PIECE_TYPE,
                                QUESTION_ID,
                                IS_AMOUNT_CHANGE,
                                IS_PRICE_CHANGE,
                                BOY_FORMUL,
                                EN_FORMUL,
                                AMOUNT_FORMUL,
                                NOT_STANDART_RATE,
                              	DESIGN_BOY,
                           		DESIGN_EN,
                                PRIVATE_PRICE_TYPE, 
                                PRIVATE_PRICE_MONEY, 
                                PRIVATE_PRICE,
                                RECORD_DATE, 
                            	RECORD_EMP, 
                             	RECORD_IP
                            )
                    VALUES        
                            (
                                #attributes.ezgi_id#,
                                #FilterNum(Evaluate('piece_amount_#i#'),2)#,
                                <cfif isdefined('amount2_#i#')>#FilterNum(Evaluate('amount2_#i#'),2)#<cfelse>#FilterNum(Evaluate('piece_amount_#i#'),2)#</cfif>,
                                <cfif len(Evaluate('attributes.SALES_PRICE_#i#'))>#Evaluate('attributes.SALES_PRICE_#i#')#<cfelse>0</cfif>,
                                '#Evaluate('attributes.SALES_PRICE_MONEY_#i#')#',
                                <cfif len(Evaluate('attributes.PURCHASE_PRICE_#i#'))>#Evaluate('attributes.PURCHASE_PRICE_#i#')#<cfelse>0</cfif>,
                                '#Evaluate('attributes.PURCHASE_PRICE_MONEY_#i#')#',
                                <cfif len(Evaluate('attributes.COST_PRICE_#i#'))>#Evaluate('attributes.COST_PRICE_#i#')#<cfelse>0</cfif>,
                                '#Evaluate('attributes.COST_PRICE_MONEY_#i#')#',
                                #get_stock_id.STOCK_ID#,
                                '#get_stock_id.PRODUCT_CODE#',
                                '#get_stock_id.PRODUCT_NAME#',
                                '#get_stock_id.MAIN_UNIT#',
                                #i#,
                                #Evaluate('attributes.PIECE_TYPE_#i#')#,
                                <cfif isdefined('attributes.QUESTION_ID_#i#') and LEN(Evaluate('attributes.QUESTION_ID_#i#'))>#Evaluate('attributes.QUESTION_ID_#i#')#<cfelse>NULL</cfif>,
                                #Evaluate('attributes.IS_AMOUNT_CHANGE_#i#')#,
                                #Evaluate('attributes.IS_PRICE_CHANGE_#i#')#,
                                <cfif isdefined('attributes.BOY_FORMUL_#i#') and LEN(Evaluate('attributes.BOY_FORMUL_#i#'))>'#Evaluate('attributes.BOY_FORMUL_#i#')#'<cfelse>NULL</cfif>,
                                <cfif isdefined('attributes.EN_FORMUL_#i#') and LEN(Evaluate('attributes.EN_FORMUL_#i#'))>'#Evaluate('attributes.EN_FORMUL_#i#')#'<cfelse>NULL</cfif>,
                                <cfif isdefined('attributes.AMOUNT_FORMUL_#i#') and LEN(Evaluate('attributes.AMOUNT_FORMUL_#i#'))>'#Evaluate('attributes.AMOUNT_FORMUL_#i#')#'<cfelse>NULL</cfif>,
                                <cfif isdefined('attributes.not_standart_rate') and len(attributes.not_standart_rate)>#attributes.not_standart_rate#<cfelse>0</cfif>,
                             	<cfif isdefined('attributes.BOY_#i#') and len(Evaluate('attributes.BOY_#i#'))>#Evaluate('attributes.BOY_#i#')#<cfelse>0</cfif>,
                                <cfif isdefined('attributes.EN_#i#') and len(Evaluate('attributes.EN_#i#'))>#Evaluate('attributes.EN_#i#')#<cfelse>0</cfif>,
                                <cfif isdefined('attributes.PRIVATE_PRICE_TYPE_#i#') and len(Evaluate('attributes.PRIVATE_PRICE_TYPE_#i#'))>#Evaluate('attributes.PRIVATE_PRICE_TYPE_#i#')#<cfelse>0</cfif>,
                                <cfif isdefined('attributes.PRIVATE_PRICE_MONEY_#i#') and len(Evaluate('attributes.PRIVATE_PRICE_MONEY_#i#'))>'#Evaluate('attributes.PRIVATE_PRICE_MONEY_#i#')#'<cfelse>NULL</cfif>,
                                <cfif isdefined('attributes.PRIVATE_PRICE_#i#') and len(Evaluate('attributes.PRIVATE_PRICE_#i#'))>#	FilterNum(Evaluate('attributes.PRIVATE_PRICE_#i#'),2)#<cfelse>0</cfif>,
                             	#now()#,
                                #session.ep.userid#,
                                '#cgi.remote_addr#'
                            )
                </cfquery>
            </cfloop>
        </cfif>
    </cftransaction>
    <script type="text/javascript">
		wrk_opener_reload();
		window.close();
	</script>          
<cfelse> <!---Mutfak Aktarım Sayfasından Geliyorsa--->
	<cfset upload_folder = "#upload_folder#temp#dir_seperator#">
    <cftry>
        <cffile action = "upload" 
                fileField = "uploaded_file" 
                destination = "#upload_folder#"
                nameConflict = "MakeUnique"  
                mode="777">
      	<cfif attributes.import_file_type eq 4 and cffile.serverfileext neq 'PDF'>
        	<script type="text/javascript">
             	alert("<cfoutput>#getLang('main',2947)# #getLang('main',1936)#</cfoutput>.");
             	history.back();
         	</script>
         	<cfabort>
        </cfif>
        <cfset file_name = "#createUUID()#.#cffile.serverfileext#">	
        <cffile action="rename" source="#upload_folder##cffile.serverfile#" destination="#upload_folder##file_name#">	
        <cfset file_size = cffile.filesize>
        <cfcatch type="Any">
                <cfoutput>#cfcatch.detail#</cfoutput>
            <cfabort>
        </cfcatch>  
    </cftry>
    <cfquery name="del_file" datasource="#dsn3#"> <!---Satırla İlgili Varsa Kayıt Siliniyor--->
     	DELETE FROM EZGI_VIRTUAL_OFFER_ROW_IMPORT_FILE WHERE EZGI_ID = #attributes.ezgi_id# AND FILE_TYPE_ID = #attributes.import_file_type#
  	</cfquery>
	<cfquery name="add_fie" datasource="#dsn3#"><!--- Yeni İçeriye Alınan Dosyanın Database Kaydı Yapılıyor--->
   		INSERT INTO 
     		EZGI_VIRTUAL_OFFER_ROW_IMPORT_FILE
          	(
         		EZGI_ID, 
             	FILE_TYPE_ID, 
          		FILE_NAME,
                RECORD_DATE, 
              	RECORD_EMP, 
        		RECORD_IP
          	)
      	VALUES        
         	(
           		#attributes.ezgi_id#,
             	#attributes.import_file_type#,
              	'#file_name#',
                #now()#,
               	#session.ep.userid#,
             	'#cgi.remote_addr#'
      		)
 	</cfquery>
    <cfif isdefined('attributes.import_file_type') and attributes.import_file_type eq 1> <!---Mutfak Fiyat Aktarımından Geliyorsa--->
        <cftry>
            <cfspreadsheet action="read" src="#upload_folder##file_name#" query="satirlar" sheetname ="FIYAT" headerrow ="1" rows="2-10000">	
            <cfspreadsheet action="read" src="#upload_folder##file_name#" query="details" sheetname ="ACIKLAMA" headerrow ="1" rows="2-20">
            <cfspreadsheet action="read" src="#upload_folder##file_name#" query="montage" sheetname ="MONTAJ" headerrow ="1" rows="2-20">
            <!---<cfdump var="#details#">
            <cfdump var="#montage#">--->
            <cfcatch>
                <script type="text/javascript">
                     alert("<cfoutput>#getLang('ehesap',1112)#</cfoutput>.");
                    history.back();
                </script>
                <cfabort>
            </cfcatch>
        </cftry>
        <cfif satirlar.recordcount>
            <cftransaction>
                <cfquery name="del_row" datasource="#dsn3#"><!---Varsa Detay Satırları Siliniyor--->
                    DELETE FROM EZGI_VIRTUAL_OFFER_ROW_DETAIL WHERE EZGI_ID = #attributes.ezgi_id#
                </cfquery>
                <cfquery name="del_row" datasource="#dsn3#"><!---Varsa Montaj Satırları Siliniyor--->
                    DELETE FROM EZGI_VIRTUAL_OFFER_ROW_MONTAGE WHERE EZGI_ID = #attributes.ezgi_id#
                </cfquery>
                <cfquery name="del_row" datasource="#dsn3#"><!---Varsa Açıklama Satırları Siliniyor--->
                    DELETE FROM EZGI_VIRTUAL_OFFER_ROW_DESCRIPTION WHERE EZGI_ID = #attributes.ezgi_id#
                </cfquery>
                <cfif attributes.price_transfer_type eq 1> <!---Aktarım İçin Ürün Kartı Bağlantısı Aranacaksa--->
                    <cfloop query="satirlar">
                        <cfif len(satirlar.code)>
                            <cfquery name="get_stock_id" datasource="#dsn3#">
                                SELECT 
                                    STOCK_ID,
                                    PRODUCT_CODE, 
                                    PRODUCT_NAME, 
                                    (SELECT MAIN_UNIT FROM PRODUCT_UNIT WHERE PRODUCT_UNIT_ID = STOCKS.PRODUCT_UNIT_ID AND IS_MAIN = 1) AS MAIN_UNIT
                                FROM 
                                    STOCKS 
                                WHERE 
                                    PRODUCT_CODE_2 = '#satirlar.code#'
                            </cfquery>
                            <cfif get_stock_id.recordcount>
                                <cfif get_stock_id.recordcount gt 1>
                                    <script type="text/javascript">
                                        alert("<cfoutput>#satirlar.code#</cfoutput> Kodu Ürün Kodlarında Birden Fazla Tanımlanmıştır!");
                                        window.close()
                                    </script>
                                    <cfdump var="#get_stock_id#">
                                    <cfabort>
                                <cfelse>
                                    <cfquery name="get_price" datasource="#dsn3#">
                                        SELECT        
                                            OFR.SALES_PRICE, 
                                            OFR.SALES_PRICE_MONEY,
                                            OFR.PURCHASE_PRICE,
                                            OFR.PURCHASE_PRICE_MONEY,
                                            OFR.COST_PRICE,
                                            OFR.COST_PRICE_MONEY
                                        FROM
                                            EZGI_VIRTUAL_OFFER_PRICE_ROW AS OFR INNER JOIN
                                            EZGI_VIRTUAL_OFFER_PRICE_LIST AS OFL ON OFR.PRICE_CAT_ID = OFL.PRICE_CAT_ID
                                        WHERE        
                                            OFR.PRICE_CAT_ID = 1 AND 
                                            OFL.STATUS = 1 AND 
                                            OFR.STOCK_ID = #get_stock_id.STOCK_ID#
                                    </cfquery>
                                    <cfif get_price.recordcount>
                                        <cfquery name="add_row" datasource="#dsn3#">
                                            INSERT INTO 
                                                EZGI_VIRTUAL_OFFER_ROW_DETAIL
                                                (
                                                    EZGI_ID, 
                                                    AMOUNT, 
                                                    SALES_PRICE, 
                                                    SALES_PRICE_MONEY, 
                                                    PURCHASE_PRICE, 
                                                    PURCHASE_PRICE_MONEY, 
                                                    COST_PRICE, 
                                                    COST_PRICE_MONEY, 
                                                    STOCK_ID, 
                                                    PRODUCT_CODE, 
                                                    PRODUCT_NAME, 
                                                    MAIN_UNIT,
                                                    RECORD_DATE, 
                                                	RECORD_EMP, 
                                                	RECORD_IP
                                                )
                                            VALUES        
                                                (
                                                    #attributes.ezgi_id#,
                                                    #satirlar.miktar#,
                                                    #get_price.SALES_PRICE#,
                                                    '#get_price.SALES_PRICE_MONEY#',
                                                     #get_price.PURCHASE_PRICE#,
                                                    '#get_price.PURCHASE_PRICE_MONEY#',
                                                     #get_price.COST_PRICE#,
                                                    '#get_price.COST_PRICE_MONEY#',
                                                    #get_stock_id.STOCK_ID#,
                                                    '#get_stock_id.PRODUCT_CODE#',
                                                    '#get_stock_id.PRODUCT_NAME#',
                                                    '#get_stock_id.MAIN_UNIT#',
                                                    #now()#,
                                                    #session.ep.userid#,
                                                    '#cgi.remote_addr#'
                                                )
                                        </cfquery>
                                    <cfelse>
                                        <script type="text/javascript">
                                            alert("<cfoutput>#satirlar.code#</cfoutput> Kodul Ürün Fiyat Listesinde Kayıtlı Değildir!");
                                            window.close()
                                        </script>
                                        <cfabort>
                                    </cfif>
                                </cfif>
                            <cfelse>
                                <script type="text/javascript">
                                    alert("<cfoutput>#satirlar.code#</cfoutput> Kodu Ürün Kodlarında Kayıtlı Değildir!");
                                    window.close()
                                </script>
                                <cfabort>
                            </cfif>
                        </cfif>
                    </cfloop>
              	<cfelse> <!---Şu an Bursaı Çalışıyor Ürün Kartı Bağlantısız Direk EZGI_VIRTUAL_OFFER_PRICE_ROW tablosundaki Özel Kodla Alınıyor--->
                	<cfloop query="satirlar">
                        <cfif len(satirlar.code)>
                            <cfquery name="get_price" datasource="#dsn3#">
                                SELECT    
                                     WR.*
                                FROM            
                                    EZGI_VIRTUAL_OFFER_PRICE_ROW AS WR INNER JOIN
                                    EZGI_VIRTUAL_OFFER_PRICE_LIST AS WL ON WR.PRICE_CAT_ID = WL.PRICE_CAT_ID
                                WHERE        
                                    WR.PRODUCT_CODE_2 = '#satirlar.code#' AND 
                                    WL.STATUS = 1
                            </cfquery>
                            <cfif get_price.recordcount>
                                <cfif get_price.recordcount gt 1>
                                    <script type="text/javascript">
                                        alert("<cfoutput>#satirlar.code#</cfoutput> Kodu Ürün Kodlarında Birden Fazla Tanımlanmıştır!");
                                        window.close()
                                    </script>
                                    <cfdump var="#get_price#">
                                    <cfabort>
                                <cfelse>
                                    <cfquery name="add_row" datasource="#dsn3#"> <!--- Mutfak adekodan gelen satırlar Detay Sayfası Kaydediliyor--->
                                        INSERT INTO 
                                            EZGI_VIRTUAL_OFFER_ROW_DETAIL
                                            (
                                                EZGI_ID, 
                                                AMOUNT, 
                                                SALES_PRICE, 
                                                SALES_PRICE_MONEY, 
                                                PURCHASE_PRICE, 
                                                PURCHASE_PRICE_MONEY, 
                                                COST_PRICE, 
                                                COST_PRICE_MONEY, 
                                                PRODUCT_CODE, 
                                                PRODUCT_NAME,
                                                RECORD_DATE, 
                                                RECORD_EMP, 
                                                RECORD_IP
                                            )
                                        VALUES        
                                            (
                                                #attributes.ezgi_id#,
                                                #satirlar.miktar#,
                                               	<cfif len(get_price.SALES_PRICE)>#get_price.SALES_PRICE#<cfelse>0</cfif>,
                                                <cfif len(get_price.SALES_PRICE_MONEY)>'#get_price.SALES_PRICE_MONEY#'<cfelse>NULL</cfif>,
                                                <cfif len(get_price.PURCHASE_PRICE)>#get_price.PURCHASE_PRICE#<cfelse>0</cfif>,
                                                <cfif len(get_price.PURCHASE_PRICE_MONEY)>'#get_price.PURCHASE_PRICE_MONEY#'<cfelse>NULL</cfif>,
                                                <cfif len(get_price.COST_PRICE)>#get_price.COST_PRICE#<cfelse>0</cfif>,
                                                <cfif len(get_price.COST_PRICE_MONEY)>'#get_price.COST_PRICE_MONEY#'<cfelse>NULL</cfif>,
                                                '#get_price.PRODUCT_CODE_2#',
                                                '#get_price.PRODUCT_NAME#',
                                                #now()#,
                                                #session.ep.userid#,
                                                '#cgi.remote_addr#'
                                            )
                                    </cfquery>
                                </cfif>
                            <cfelse>
                                <script type="text/javascript">
                                    alert("<cfoutput>#satirlar.code#</cfoutput> Kodu Ürün Kodlarında Tanımlanmamıştır!");
                                    window.close()
                                </script>
                                <cfdump var="#get_price#">
                                <cfabort>
                            </cfif>
                    	</cfif>
                    </cfloop>
                </cfif>
                <cfif details.recordcount>
                	<cfloop query="details">
                		<cfif len(details.kod)>
                        	<cfquery name="add_description" datasource="#dsn3#"><!--- Adekodan Gelen Açıklamalar Açıklama Dosyasına Kaydediliyor--->
                                INSERT INTO 
                                    EZGI_VIRTUAL_OFFER_ROW_DESCRIPTION
                                    (
                                        EZGI_ID, 
                                        DESCRIPTION
                                    )
                                VALUES        
                                    (
                                        #attributes.ezgi_id#,
                                        '#details.aciklama#'  
                                    )
                        	</cfquery>
                        </cfif>
                	</cfloop>
                </cfif>
                <cfif MONTAGE.recordcount>
                	<cfloop query="MONTAGE">
                		<cfif len(MONTAGE.CODE) and len(MONTAGE.miktar) and isnumeric(MONTAGE.miktar)> <!---Adekodan Gelen Montaj Ölçüsü Kontrol ediliyor--->
                        	<cfquery name="get_des_stock_id" datasource="#dsn3#">
                                SELECT 
                                    STOCK_ID
                                FROM 
                                    STOCKS 
                                WHERE 
                                    PRODUCT_CODE_2 = '#MONTAGE.code#'
                            </cfquery>
                            <cfif get_des_stock_id.recordcount gt 1>
                                <script type="text/javascript">
                                    alert("<cfoutput>#montage.code#</cfoutput> Montaj Kodu Ürün Kodlarında Birden Fazla Tanımlanmıştır!");
                                    window.close()
                                </script>
                                <cfdump var="#get_des_stock_id#">
                                <cfabort>
                          	<cfelseif not get_des_stock_id.recordcount>
                            	<script type="text/javascript">
                                    alert("<cfoutput>#montage.code#</cfoutput> Montaj Kodu Ürün Kodlarında Bulunamamıştır!");
                                    window.close()
                                </script>
                                <cfdump var="#get_des_stock_id#">
                                <cfabort>
                         	<cfelse>    
                                <cfquery name="add_montage" datasource="#dsn3#"> <!---Adekodan Gelen Montaj Ölçüsü Montaj Dosyasına Kaydediliyor.--->
                                    INSERT INTO 
                                        EZGI_VIRTUAL_OFFER_ROW_MONTAGE
                                        (
                                            EZGI_ID, 
                                            STOCK_ID,
                                            AMOUNT
                                        )
                                    VALUES        
                                        (
                                            #attributes.ezgi_id#,
                                            #get_des_stock_id.STOCK_ID#,
                                            #MONTAGE.miktar# 
                                        )
                                </cfquery>
                            </cfif>
                        </cfif>
                	</cfloop>
                </cfif>
            </cftransaction>
        <cfelse>
            Hatalı Dosya
        </cfif>
  	<cfelseif isdefined('attributes.import_file_type') and attributes.import_file_type eq 3> <!---Mutfak İmalat Dosyası Aktarımı İse--->
    	<cfinclude template="/V16/add_options/ezgi/e_furniture/imp_ezgi_virtual_offer_row_spect_aktar.cfm">
    </cfif>
</cfif>
<cfif isdefined('attributes.upd') or isdefined('attributes.UPD_STANDART')>
	<script type="text/javascript">
        alert("Güncelleme Tamamlanmıştır!");
        wrk_opener_reload();
        window.close()
    </script>
<cfelse>
	<cflocation url="#request.self#?fuseaction=prod.popup_upd_ezgi_virtual_offer_row_spect&ezgi_id=#attributes.ezgi_id#" addtoken="No">
</cfif>