<!--- <cfsetting showdebugoutput="no"> --->
<cfif not len(attributes.startdate)>
	<cfset attributes.startdate = dateformat(now(),dateformat_style)>
</cfif>
<cfset attributes.processdate=attributes.startdate>
<cf_date tarih='attributes.processdate'>
<cf_date tarih="attributes.startdate">
<cfset startdate_00 = attributes.startdate>
<cfset attributes.startdate = date_add("h", attributes.start_hour, attributes.startdate)>
<cfset attributes.startdate = date_add("n", attributes.start_min, attributes.startdate)>
<cflock name="#CreateUUID()#" timeout="20">
	<cftransaction>
		<cfset attributes.upload_folder = "#upload_folder#store#dir_seperator#">
		<cftry>
			<cffile action = "upload" fileField = "uploaded_file" destination = "#attributes.upload_folder#" nameConflict = "MakeUnique" mode="777">
			
			<cfset file_name = "#createUUID()#.#cffile.serverfileext#">
			<cffile action="rename" source="#attributes.upload_folder##cffile.serverfile#" destination="#attributes.upload_folder##file_name#">	
			<!---Script dosyalarını engelle  02092010 FA-ND --->
			<cfset assetTypeName = listlast(cffile.serverfile,'.')>
			<cfset blackList = 'php,php2,php3,php4,php5,phtml,pwml,inc,asp,aspx,ascx,jsp,cfm,cfml,cfc,pl,bat,exe,com,dll,vbs,reg,cgi,htaccess,asis'>
			<cfif listfind(blackList,assetTypeName,',')>
				<cffile action="delete" file="#attributes.upload_folder##file_name#">
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
		
		<cfquery name="ADD_FILE" datasource="#DSN2#">
			INSERT INTO
				FILE_IMPORTS
			(	
				SOURCE_SYSTEM,
				PROCESS_TYPE,
				STARTDATE,
				FILE_NAME,
				FILE_SERVER_ID,
				FILE_SIZE,
				IS_MUHASEBE,
				<!--- DEPARTMENT_ID,
				DEPARTMENT_LOCATION, --->
				IMPORTED,
				RECORD_DATE,
				RECORD_IP,
				RECORD_EMP,
				PRICE_CATID
			)
			VALUES
			(
				#target_pos#,
				-10,
				#attributes.processdate#,
				'#file_name#',
				#fusebox.server_machine#,
				#file_size#,
				0,
				<!--- #department_id#,
				<cfif isdefined("department_location")>#department_location#<cfelse>NULL</cfif>, --->
				0,
				#now()#,		
				'#cgi.remote_addr#',
				#session.ep.userid#,
				#attributes.price_catid#
			)
		</cfquery>
		<cfquery name="GET_MAX_ID" datasource="#DSN2#">
			SELECT MAX(I_ID) MAX_ID FROM FILE_IMPORTS WHERE PROCESS_TYPE=-10 AND SOURCE_SYSTEM=#target_pos#
		</cfquery>
	</cftransaction>
</cflock>
<cfset attributes.i_id=GET_MAX_ID.MAX_ID>
<!--- import işlemine başlıyor--->
<cfset upload_folder = "#upload_folder#store#dir_seperator#">
<cfscript>
	GET_UNIT=cfquery(SQLString:"SELECT UNIT_ID, UNIT FROM SETUP_UNIT",is_select:1,Datasource:dsn);
	if(GET_UNIT.recordcount)
	{
		unit_list=ValueList(GET_UNIT.UNIT_ID,',');
		unit_list_name=ValueList(GET_UNIT.UNIT,',');
	}
	else
	{
		unit_list='';
		unit_list_name='';
	}
	all_barcode=cfquery(SQLString:"SELECT STOCKS_BARCODES.STOCK_ID,STOCKS_BARCODES.BARCODE,STOCKS_BARCODES.UNIT_ID,STOCKS.PRODUCT_ID FROM STOCKS_BARCODES,STOCKS WHERE STOCKS.STOCK_ID=STOCKS_BARCODES.STOCK_ID",is_select:1,Datasource:dsn1);
</cfscript>

<cffile action="read" file="#upload_folder##file_name#" variable="dosya" charset="utf-8"><!---charset="#attributes.file_format#"  --->

<cfset hata_file_name = "#CreateUUID()#.xml">
<cffile action="write" output="" addnewline="no" file="#upload_folder##hata_file_name#" charset="utf-8">

<cfscript>
	counter = 0;
	problem_counter = 0;
	
	dosyam = XmlParse(dosya);
	xml_dizi = dosyam.PRODUCT_PRICE.XmlChildren;
	d_boyut = ArrayLen(xml_dizi);
	
	//islem uzun surmesi halinde session kaybedebillir diye bir degiskene aldik
	session_comp_id=SESSION.EP.COMPANY_ID;
	session_user_id=SESSION.EP.USERID;
	session_userkey=SESSION.EP.USERKEY;
	session_money=SESSION.EP.MONEY;
		
	//LİSANS VE DOSYA BİLGİLERİ
	server_date = trim(dosyam.PRODUCT_PRICE.PRODUCT_DESCRIPTION[1].CREATION_SERVER_DATE.XmlText);
	server_id = trim(dosyam.PRODUCT_PRICE.PRODUCT_DESCRIPTION[1].WORKCUBE_ID.XmlText);
	server_company = trim(dosyam.PRODUCT_PRICE.PRODUCT_DESCRIPTION[1].SERVER_COMPANY.XmlText);
	destination_company = trim(dosyam.PRODUCT_PRICE.PRODUCT_DESCRIPTION[1].DESTINATION_COMPANY.XmlText);
	destination_company_id = trim(dosyam.PRODUCT_PRICE.PRODUCT_DESCRIPTION[1].DESTINATION_COMPANY_ID.XmlText);
	
	//hatalı satırları yazmak için yeni xml dosyası
	hata_index = 1;
	my_doc = XmlNew();
	my_doc.xmlRoot = XmlElemNew(my_doc,"PRODUCT_PRICE");
	my_doc.xmlRoot.XmlChildren[hata_index] = XmlElemNew(my_doc,"PRODUCT_DESCRIPTION");
	my_doc.xmlRoot.XmlChildren[hata_index].XmlChildren[1] = XmlElemNew(my_doc,"CREATION_SERVER_DATE");
	my_doc.xmlRoot.XmlChildren[hata_index].XmlChildren[1].XmlText = "#dateformat(NOW(),dateformat_style)# #timeformat(date_add("h",session.ep.time_zone,NOW()),timeformat_style)#";
	my_doc.xmlRoot.XmlChildren[hata_index].XmlChildren[2] = XmlElemNew(my_doc,"WORKCUBE_ID");
	my_doc.xmlRoot.XmlChildren[hata_index].XmlChildren[2].XmlText = server_id;
	my_doc.xmlRoot.XmlChildren[hata_index].XmlChildren[3] = XmlElemNew(my_doc,"SERVER_COMPANY");
	my_doc.xmlRoot.XmlChildren[hata_index].XmlChildren[3].XmlText = server_company;
	my_doc.xmlRoot.XmlChildren[hata_index].XmlChildren[4] = XmlElemNew(my_doc,"DESTINATION_COMPANY");
	my_doc.xmlRoot.XmlChildren[hata_index].XmlChildren[4].XmlText = destination_company;
	my_doc.xmlRoot.XmlChildren[hata_index].XmlChildren[5] = XmlElemNew(my_doc,"DESTINATION_COMPANY_ID");
	my_doc.xmlRoot.XmlChildren[hata_index].XmlChildren[5].XmlText = destination_company_id;
	hata_index = hata_index+1;
</cfscript>
<!--- belge formati kontorlu icin  --->
<cfif not len(server_date) eq 16 and not isdate(server_date)>
	<script type="text/javascript">
		alert('Dosya Formatı hatalı. Dosyanın doğru olduğundan emin olun');
		wrk_opener_reload();
		//window.close();
	</script>
<cfelse>
	<cfset server_date=CreateODBCDateTime(server_date)>
</cfif>
<table>
	<tr><td colspan="3" align="center">Import Sonuç</td></tr>
	<tr><td width="15">Satır</td><td width="75">Barcode</td><td>Hata</td></tr>
<cfloop index="i" from="1" to="#d_boyut-1#">
	<cfset j= 1>
	<cfset error_flag = 0>	
	<cfset barcode_list="">
	<cftry>
		<cfscript>
			barcode = dosyam.PRODUCT_PRICE.PRODUCT[i].BARCOD.XmlText;
			urun_adi = dosyam.PRODUCT_PRICE.PRODUCT[i].PRODUCT_NAME.XmlText;
			fiyat_kdvsiz = dosyam.PRODUCT_PRICE.PRODUCT[i].PRICE.XmlText;
			fiyat_kdvli = dosyam.PRODUCT_PRICE.PRODUCT[i].PRICE_KDV.XmlText;
			money = dosyam.PRODUCT_PRICE.PRODUCT[i].MONEY.XmlText;
			birim = dosyam.PRODUCT_PRICE.PRODUCT[i].ADD_UNIT.XmlText;
		</cfscript>
		<cfcatch type="Any">
			<tr><cfoutput><td>#i#.</td><td>satırda</td></cfoutput><td>okuma sırasında hata oldu</td></tr>
			<cfset error_flag = 1>
			<cfset problem_counter =problem_counter + 1>
 		</cfcatch>
	</cftry>

	<cfif len(barcode) and error_flag eq 0>
		<cfscript>
		error_flag=0;
		if(len(barcode) gt 0)
		{
			check_same=cfquery(SQLString:"SELECT STOCK_ID,BARCODE,UNIT_ID,PRODUCT_ID FROM all_barcode WHERE BARCODE = '#barcode#'",is_select:1,Datasource:'',dbtype:'query');
			if(check_same.recordcount eq 0)
			{
				writeoutput('<tr><td>'&i&'</td><td>'&barcode&'</td><td>barcodlu bir ürün bulunamadı </td><tr>');
				error_flag = 1;
				problem_counter =problem_counter + 1;
			}else
			{
				upd_stock_id=check_same.STOCK_ID;
				upd_product_id=check_same.PRODUCT_ID;
			}
		}
		//birim adi kontrolu
		if(error_flag eq 0)
		{
			if(len(birim))
			{
				yer=ListFindNoCase(unit_list_name,birim,',');
				if(yer gt 0)
				{
					unit_name=listgetat(unit_list_name,yer,',');
					unit_id=listgetat(unit_list,yer,',');
				}else
				{
					writeoutput('<tr><td>'&i&'</td><td>'&barcode&'</td><td>birim kaydı yok </td><tr>');
					error_flag = 1;
					problem_counter =problem_counter + 1;
				}
			}else{
				writeoutput('<tr><td>'&i&'</td><td>'&barcode&'</td><td>ürünün birimi yok </td><tr>');
				error_flag = 1;
				problem_counter =problem_counter + 1;
			}
		}
		</cfscript>
 		<cfif error_flag neq 1>
			<cftry>
				<cfif len(birim) and len(urun_adi)>
					<cfquery name="GET_PRODUCT_UNIT" datasource="#dsn1#">
						SELECT PRODUCT_UNIT_ID FROM PRODUCT_UNIT WHERE PRODUCT_ID = #upd_product_id# AND PRODUCT_UNIT_STATUS = 1 AND UNIT_ID=#unit_id#
					</cfquery>
					<cfif GET_PRODUCT_UNIT.recordcount>
						<cfset bugun_00 = DateFormat(now(),dateformat_style)>
						<cf_date tarih='bugun_00'>
						
						<cfif attributes.price_catid eq -2>
							<!--- ayni gune 2 fiyat olamaz diye siliyoruz bugun eklenen fiyatlari --->
							<cfquery name="DEL_PRODUCT_PRICE_SALES" datasource="#dsn1#">
								DELETE FROM
									PRICE_STANDART
								WHERE
									PRODUCT_ID = #upd_product_id# AND
									PURCHASESALES = 1 AND
									UNIT_ID = #GET_PRODUCT_UNIT.PRODUCT_UNIT_ID# AND
									START_DATE = #bugun_00#
							</cfquery>
							<!--- daha onceki fiyatlari pasif yapiyoruz --->
							<cfquery name="STD_PRICE_PAS" datasource="#dsn1#">
								UPDATE 
									PRICE_STANDART
								SET 
									PRICESTANDART_STATUS = 0,
									RECORD_EMP=#SESSION.EP.USERID#
								WHERE 
									PRODUCT_ID = #upd_product_id# AND 
									PURCHASESALES = 1 AND
									UNIT_ID = #GET_PRODUCT_UNIT.PRODUCT_UNIT_ID# AND
									PRICESTANDART_STATUS = 1
							</cfquery>
						
							<!---satış fiyatı--->
							<cfquery name="ADD_STD_PRICE" datasource="#dsn1#">
								INSERT INTO PRICE_STANDART
								(
									PRODUCT_ID, 
									PURCHASESALES, 
									PRICE,
									PRICE_KDV,
									IS_KDV,
									ROUNDING,
									MONEY,
									START_DATE,
									RECORD_DATE,
									PRICESTANDART_STATUS,
									UNIT_ID,
									RECORD_EMP
								)
								VALUES
								(
									#upd_product_id#,
									1,
									<cfif not IsNumeric(fiyat_kdvsiz)>0<cfelse>#fiyat_kdvsiz#</cfif>,
									<cfif not isnumeric(fiyat_kdvli)>0<cfelse>#fiyat_kdvli#</cfif>,
									1,
									0,
									<cfif len(money)>'#money#'<cfelse>'#session_money#'</cfif>,
									#bugun_00#,
									#NOW()#,
									1,
									#GET_PRODUCT_UNIT.PRODUCT_UNIT_ID#,
									#session_user_id#
								)
							</cfquery>
							<!---satış fiyatı--->
						<cfelseif attributes.price_catid neq -2>
							
							<cfquery datasource="#dsn3#" name="new_price_add_method" timeout="300">
								exec add_price
									#upd_product_id#,
									#GET_PRODUCT_UNIT.PRODUCT_UNIT_ID#,
									#attributes.price_catid#,
									#bugun_00#,
									#fiyat_kdvsiz#,<!--- #satis_fiyat_kdvsiz#, --->
									<cfif len(money)>'#money#'<cfelse>'#session_money#'</cfif>,<!--- <cfif len(sales_money)>'#sales_money#'<cfelse>'#session_money#'</cfif>, --->
									1,
									#fiyat_kdvli#,<!--- #satis_fiyat_kdvli#, --->
									-1,
									#session_user_id#,
									'#cgi.remote_addr#',
									0,
									0,
									0
							</cfquery>
						</cfif>
					<cfelse>
						<tr><cfoutput><td>#i#</td><td>#barcode#</td></cfoutput><td>ürün birimi eklenmemis</td></tr>
						<cfset problem_counter =problem_counter + 1>
					</cfif>
				</cfif>
		
 				<cfcatch type="Any">
					<tr><cfoutput><td>#i#</td><td>#barcode#</td></cfoutput><td>kayıt sırasında hata oldu</td></tr>
					<cfset problem_counter =problem_counter + 1>
				</cfcatch>
			</cftry>
        <cfelse>
        	<cfscript>
				my_doc.xmlRoot.XmlChildren[index_array] = XmlElemNew(my_doc,"PRODUCT_PRICE");
				my_doc.xmlRoot.XmlChildren[index_array].XmlChildren[1] = XmlElemNew(my_doc,"BARCOD");
				my_doc.xmlRoot.XmlChildren[index_array].XmlChildren[1].XmlText = barcode;
				my_doc.xmlRoot.XmlChildren[index_array].XmlChildren[2] = XmlElemNew(my_doc,"PRODUCT_NAME");
				my_doc.xmlRoot.XmlChildren[index_array].XmlChildren[2].XmlText = urun_adi;
				my_doc.xmlRoot.XmlChildren[index_array].XmlChildren[3] = XmlElemNew(my_doc,"PRICE");
				my_doc.xmlRoot.XmlChildren[index_array].XmlChildren[3].XmlText = fiyat_kdvsiz;
				my_doc.xmlRoot.XmlChildren[index_array].XmlChildren[4] = XmlElemNew(my_doc,"PRICE_KDV");
				my_doc.xmlRoot.XmlChildren[index_array].XmlChildren[4].XmlText = fiyat_kdvli;
				my_doc.xmlRoot.XmlChildren[index_array].XmlChildren[5] = XmlElemNew(my_doc,"MONEY");
				my_doc.xmlRoot.XmlChildren[index_array].XmlChildren[5].XmlText = money;
				my_doc.xmlRoot.XmlChildren[index_array].XmlChildren[6] = XmlElemNew(my_doc,"ADD_UNIT");
				my_doc.xmlRoot.XmlChildren[index_array].XmlChildren[6].XmlText = birim;
				index_array = index_array+1;
				urun_say = urun_say + 1;
			</cfscript>
		</cfif>
	<cfelse>
		<tr><cfoutput><td>#i#</td><td>#barcode#</td></cfoutput><td>barcod yok (satır okunamadığından hata dosyasınada yazılamadı)</td></tr>
		<cfset problem_counter =problem_counter + 1>
	</cfif>
</cfloop>

<cfif problem_counter gt 0>
	<!--- hatali satirlarin oluşturdugu dosya olusturuluyor --->
	<cffile action="append" output="#toString(my_doc)#" file="#UPLOAD_FOLDER##hata_file_name#" charset="utf-8">
<cfelse>
   	<!--- hatalı satır yok hata dosyasını silelim --->
    <cf_del_server_file output_file="#upload_folder##hata_file_name#" output_server="#session.ep.SERVER_MACHINE#">
</cfif>

<!--- meta bolumundeki bilgiler kayit ediliyor --->
<cfquery name="UPD_FILE" datasource="#dsn2#">
	UPDATE 
		FILE_IMPORTS 
	SET
		SERVER_DATE=#server_date#,
		SERVER_ID='#server_id#',
		SERVER_COMPANY='#server_company#',
		DESTINATION_COMPANY='#LEFT(destination_company,150)#',
		IMPORTED=1,
		PROBLEMS_COUNT=#problem_counter#,
		PROBLEMS_FILE_NAME=<cfif problem_counter gt 0>'#hata_file_name#'<cfelse>NULL</cfif>
	WHERE
		I_ID = #attributes.I_ID#
</cfquery>
	<tr><td colspan="3"><hr></td></tr>
	<tr><td colspan="3">Toplam Satır:<cfoutput>#counter#</cfoutput></td></tr>
	<tr><td colspan="3">Hatalı Satır:<cfoutput>#problem_counter#</cfoutput></td></tr>
</table>
<br/><br/>işlem tamamlandı
