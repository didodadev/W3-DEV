<cfparam name="attributes.is_mix_pocket" default="">
<cfparam name="attributes.is_main" default="1">
<cfquery name="GET_MONEY" datasource="#DSN2#">
	SELECT MONEY FROM SETUP_MONEY
</cfquery>
<cfset money_list = ValueList(get_money.money)>
<cfif not isdefined('attributes.uploaded_file')>
<cfquery name="GET_PRICE_CAT" datasource="#DSN3#">
	SELECT PRICE_CAT,PRICE_CATID,IS_SALES,IS_PURCHASE FROM PRICE_CAT WHERE PRICE_CAT_STATUS = 1 ORDER BY PRICE_CAT
</cfquery>
<cf_catalystHeader>
  <cfform name="formimport" action="" enctype="multipart/form-data" method="post">
	<cf_area>
	  	<div class="row">
	        <div class="col col-12 uniqueRow">
	            <div class="row formContent">
	                <div class="row" type="row">
	                    <div class="col col-4 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                        	<div class="form-group" id="item-file_format">
                            	<label class="col col-4 col-xs-12"><cf_get_lang no ='752.Belge Formatı'></label>
                                <div class="col col-8 col-xs-12">
                                	<select name="file_format" id="file_format" style="width:120px;">
										<option value="UTF-8"><cf_get_lang no="359.UTF-8"></option>
									</select>
                            	</div>
                            </div>
                            <div class="form-group" id="item-uploaded_file">
                            	<label class="col col-4 col-xs-12"><cf_get_lang_main no ='56.Belge'> *</label>
                                <div class="col col-8 col-xs-12">
                                	<input type="file" name="uploaded_file" id="uploaded_file" style="width:180px;">
                            	</div>
                            </div>
                            <div class="form-group" id="item-product_type">
                            	<label class="col col-4 col-xs-12"><cf_get_lang_main no='1372.Referans'><cf_get_lang_main no ='218.Tip'></label>
                                <div class="col col-8 col-xs-12">
                                	<select name="product_type" id="product_type" style="width:120px;">
										<option value="1"><cf_get_lang_main no ='106.Stok Kodu'></option>
										<option value="2"><cf_get_lang_main no ='377.Özel Kod'></option>
										<option value="3"><cf_get_lang_main no ='221.Barkod'></option>
									</select>
                            	</div>
                            </div>
                            <div class="form-group" id="item-startdate">
                            	<label class="col col-4 col-xs-12"><cf_get_lang_main no ='641.Başlangıç Tarihi'> *</label>
                                <div class="col col-8 col-xs-12">
                                	<div class="input-group">
										<cfinput type="text" name="startdate" value="" validate="#validate_style#" required="yes" style="width:71px;">
                                    	<span class="input-group-addon"><cf_wrk_date_image date_field="startdate"></span>
                                    </div>
                            	</div>
                            </div>
                            <div class="form-group" id="item-start_clock">
                            	<label class="col col-4 col-xs-12"><cf_get_lang_main no ='79.Saat'></label>
                                <div class="col col-8 col-xs-12">
                                	<div class="input-group">
                                    	<cf_wrkTimeFormat name="start_clock" value="0">
                                    	<span class="input-group-addon no-bg"></span>
                                        <select name="start_min" id="start_min" style="width:40px;">
										<cfloop from="0" to="55" step="5" index="i">
											<cfoutput><option value="#NumberFormat(i,00)#">#NumberFormat(i,00)#</option></cfoutput>
										</cfloop>
										</select>
                                    </div>
                            	</div>
                            </div>
                            <div class="form-group" id="item-price_cat">
                            	<label class="col col-4 col-xs-12"><cf_get_lang_main no ='672.Fiyat'></label>
                                <div class="col col-8 col-xs-12">
                                	<select name="price_cat" id="price_cat" style="width:120px;">
										<option value="-1"><cf_get_lang_main no='1310.Standart Alış'></option>
										<option value="-2"><cf_get_lang_main no='1309.Standart Satış'></option>
										<cfoutput query="get_price_cat"> 
										<option value="#price_catid#">#price_cat#</option>
										</cfoutput>
									</select>
                            	</div>
                            </div>
							<div class="form-group" id="item-is_main_unit">
                            	<label class="col col-4 col-xs-12 hide"><cfoutput>#getlang('objects',1104,'Aktarımda Ana Birim Kullanılsın')#</cfoutput></label>
                                <div class="col col-8 col-xs-12">
                                	<label><cfoutput>#getlang('objects',1104,'Aktarımda Ana Birim Kullanılsın')#</cfoutput><input type="checkbox" value="1" name="is_main" id="is_main"<cfif attributes.is_main eq 1>checked</cfif>></label>
                            	</div>
                            </div>
                            <div class="form-group" id="item-is_mix_pocket">
                            	<label class="col col-4 col-xs-12 hide"><cfoutput>#getlang('objects',1103,'Karma Koli İçerikleri Güncellensin')#</cfoutput></label>
                                <div class="col col-8 col-xs-12">
                                	<label><cfoutput>#getlang('objects',1103,'Karma Koli İçerikleri Güncellensin')#</cfoutput><input type="checkbox" value="1" name="is_mix_pocket" id="is_mix_pocket"<cfif attributes.is_mix_pocket eq 1>checked</cfif>></label>
                            	</div>
                            </div>
	                    </div>
                        <div class="col col-8 col-xs-12" type="column" index="2" sort="false">
                            <div class="col col-8 col-xs-12">
                                <cftry>
                                    <cfinclude template="#file_web_path#templates/import_example/fiyatimport_#session.ep.language#.html">
                                    <cfcatch>
                                        <script type="text/javascript">
                                            alertObject({message: "<cfoutput><cf_get_lang_main no='1963.Yardım Dosyası Bulunamadı Lutfen Kontrol Ediniz'></cfoutput>"})
                                        </script>
                                    </cfcatch>
                                </cftry>
                            </div>
                            <label class="col col-12 bold font-red-mint"><cf_get_lang_main no='1555.Örnek'></label>
                            <div class="col col-12">
                                <table>
                                    <tr>
                                        <td class="txtbold"><cf_get_lang_main no='1388.Ürün Kodu'>(<cf_get_lang_main no ='106.Stok Kodu'>,<cf_get_lang_main no ='377.Özel Kod'><cf_get_lang_main no ='586.veya'><cf_get_lang_main no ='221.Barkod'>)</td>
                                        <td class="txtbold"><cf_get_lang_main no ='672.Fiyat'></td>
                                        <td class="txtbold"><cf_get_lang_main no ='77.Para Birimi'></td>
                                        <td class="txtbold"><cf_get_lang_main no ='224.Birim'></td>
                                        <td class="txtbold"><cf_get_lang_main no ='227.Kdv'></td>
                                        <td class="txtbold"><cf_get_lang no="343.Spect Main Id"></td>
                                    </tr>
                                    <tr>
                                        <td>BG.YY45878454</td>
                                        <td align="center">300.5</td>
                                        <td align="center">TL</td>
                                        <td align="center"><cf_get_lang_main no="670.Adet"></td>
                                        <td align="center">0</td>
                                        <td align="center">4319</td>
                                    </tr>
                                    <tr>
                                        <td>BG.BLUECDWR</td>
                                        <td align="center">98.5</td>
                                        <td align="center"><cf_get_lang no="333.USD"></td>
                                        <td align="center"><cf_get_lang_main no="670.Adet"></td>
                                        <td align="center">1</td>
                                        <td></td>
                                    </tr>
                                </table>
                            </div>
	                    </div>
	    			</div>
                    <div class="row formContentFooter">
	                    <div class="col col-12 text-right">
                            <cfsavecontent variable="message"><cf_get_lang_main no='49.Kaydet'></cfsavecontent>
                            <cf_wrk_search_button button_type="2" button_name="#message#" search_function='kontrol()'>
	                    </div>
                	</div>
    			</div>
    		</div>
    	</div>
		</cf_area>
		<cf_area>
		
	</cf_area>
</cfform>
<script type="text/javascript">

	function kontrol()
	{
		if(!$("#startdate").val().length)
		{
			alertObject({message: "<cfoutput><cf_get_lang_main no='326.Baslangic Tarihi Girmelisiniz'></cfoutput>"})    
			return false;
		}
		
		if(formimport.uploaded_file.value.length==0)
		{
			alert("<cf_get_lang no='913.Belge Seçmelisiniz'>!");
			return false;
		}
			return true;
	}
</script>
<cfelse>
	<cfset attributes.rounding = 0>
	<cf_date tarih = "attributes.startdate">
	<cfset end_price_without_kdv = 0>
	<cfset end_price_with_kdv = 0>
	<cfif attributes.price_cat eq -1>
		<cfset round_num = session.ep.our_company_info.purchase_price_round_num>
	<cfelseif attributes.price_cat eq -2>
		<cfset round_num = session.ep.our_company_info.sales_price_round_num>
	<cfelse><!--- eğer fiyat listesinden geliyorsa alış satış seçimlerini kontrol ediyoruz PY--->
		<cfquery name="pricecat_sales" datasource="#DSN3#">
			SELECT IS_SALES,IS_PURCHASE FROM PRICE_CAT WHERE PRICE_CATID = #attributes.price_cat#
		</cfquery>
		<cfif pricecat_sales.is_purchase eq 1 and pricecat_sales.is_sales eq 0>
			<cfset round_num = session.ep.our_company_info.purchase_price_round_num>
		<cfelse>
			<cfset round_num = session.ep.our_company_info.sales_price_round_num>
		</cfif>
	</cfif>
	<cfscript>
		attributes.startdate_fn = date_add("n",attributes.start_min,date_add("h",attributes.start_clock,attributes.startdate));
	</cfscript>
	<cfset upload_folder_ = "#upload_folder#temp#dir_seperator#">
	<cftry>
		<cffile action = "upload" 
				fileField = "uploaded_file" 
				destination = "#upload_folder_#"
				nameConflict = "MakeUnique"  
				mode="777" charset="#attributes.file_format#">
		<cfset file_name = "#createUUID()#.#cffile.serverfileext#">	
		<cffile action="rename" source="#upload_folder_##cffile.serverfile#" destination="#upload_folder_##file_name#" charset="#attributes.file_format#">	
		<cfset assetTypeName = listlast(cffile.serverfile,'.')>
		<cfset blackList = 'php,php2,php3,php4,php5,phtml,pwml,inc,asp,aspx,ascx,jsp,cfm,cfml,cfc,pl,bat,exe,com,dll,vbs,reg,cgi,htaccess,asis'>
		<cfif listfind(blackList,assetTypeName,',')>
			<cftry>
				<cffile action="delete" file="#attributes.file_format#">
				<cfcatch type="Any">
				</cfcatch>
			</cftry>
			<script type="text/javascript">
				alert("\'php\',\'jsp\',\'asp\',\'cfm\',\'cfml\' Formatlarında Dosya Girmeyiniz!!");
				history.back();
			</script>
			<cfabort>
        <cfelseif 'csv' neq assetTypeName>
			<cftry>
				<cffile action="delete" file="#attributes.file_format#">
				<cfcatch type="Any">
				</cfcatch>
			</cftry>
			<script type="text/javascript">
				alert("'csv\' Formatı Dışında  Dosya Girmeyiniz!");
				history.back();
			</script>
			<cfabort> 
		</cfif>
		<cfset file_size = cffile.filesize>
		<cfcatch type="Any">
			<script type="text/javascript">
				alert("<cf_get_lang_main no ='43.Dosyanız upload edilemedi! Dosyanızı kontrol ediniz'>!");
				history.back();
			</script>
			<cfabort>
		</cfcatch>  
	</cftry>
	<cffile action="read" file="#upload_folder_##file_name#" variable="dosya" charset="#attributes.file_format#">
	<cfscript>
		CRLF = Chr(13) & Chr(10);// satır atlama karakteri
		dosya = Replace(dosya,';;','; ;','all');
		dosya = Replace(dosya,';;','; ;','all');
		dosya = ListToArray(dosya,CRLF);
		line_count = ArrayLen(dosya);
		counter = 0;
		liste = "";
	</cfscript>
	<cfoutput>#line_count-1# <cf_get_lang_main no="1096.Satır"> <cf_get_lang_main no="1152.Var"><br/></cfoutput>

	<!--- birimler --->
	<cfquery name="GET_PRODUCT_UNIT_ALL" datasource="#dsn3#">
		SELECT 
        	PRODUCT_ID,
            PRODUCT_UNIT_ID,
            ADD_UNIT 
       	FROM 
        	PRODUCT_UNIT 
      	WHERE 
        	PRODUCT_UNIT_STATUS = 1
       		<cfif isdefined('attributes.is_main') and attributes.is_main eq 1>
            	AND IS_MAIN = 1
            </cfif>
	</cfquery>
	<cfquery name="GET_PRODUCT_ALL" datasource="#DSN3#">
		SELECT
			S.PRODUCT_ID,
			S.PRODUCT_CODE,
			S.TAX_PURCHASE,
			S.TAX,
			S.STOCK_CODE,
			S.STOCK_ID
		<cfif attributes.product_type eq 2>
			,P.PRODUCT_CODE_2
		<cfelseif attributes.product_type eq 3>
			,SB.BARCODE
		</cfif>
		FROM   
			STOCKS S
		<cfif attributes.product_type eq 2>
			,PRODUCT P
		<cfelseif attributes.product_type eq 3>
			,STOCKS_BARCODES SB
		</cfif>
		<cfif attributes.product_type eq 2>
		WHERE
			S.PRODUCT_ID = P.PRODUCT_ID 
		<cfelseif attributes.product_type eq 3>
		WHERE
			SB.STOCK_ID = S.STOCK_ID
		</cfif>			
	</cfquery>
	<cfquery name="GET_SPECT_ALL" datasource="#DSN3#">
		SELECT
			STOCK_ID,
			SPECT_MAIN_ID
		FROM   
			SPECT_MAIN
	</cfquery>
	<cfloop from="2" to="#line_count#" index="i">
		<cfset j= 1>
		<cfset is_kdv=''>
		<cfset error_flag = 0>
		<cfset spect_main_id_ = 0>
		<cftry>
			<cfscript>
				counter = counter + 1;
				//prod_kod
				prod_code = Listgetat(dosya[i],j,";");
				prod_code =trim(prod_code);
				j=j+1;
				//fiyat
				price = Listgetat(dosya[i],j,";");
				price = replace(price,' ','','all');
				price = replace(price,',','.','all');
				j=j+1;
				//para 
				money_type = Listgetat(dosya[i],j,";");
				money_type = trim(money_type);
				//Birim
				j=j+1;
				unit_name = Listgetat(dosya[i],j,";");
				unit_name = ucase(trim(unit_name));
				//Kdv_dahil
				j=j+1;
				is_kdv = Listgetat(dosya[i],j,";");
				is_kdv = trim(is_kdv);
				//spect ID
				j=j+1;
				if(listlen(dosya[i],';') gte j)
				{
					spect_id = Listgetat(dosya[i],j,";");
					spect_id = trim(spect_id);
				}				
				else
					spect_id = '';
			</cfscript>
		<cfcatch type="Any">
			<cfoutput>#i#. <cf_get_lang_main no="362.satırda okuma sırasında hata oldu"> <br/></cfoutput>
			<cfset error_flag = 1>
		</cfcatch>
		</cftry>
 		<cfif (attributes.is_main neq 1 and len(unit_name) and len(prod_code) and len(price) and len(money_type) and len(is_kdv)) or 
			  (attributes.is_main eq 1 and len(prod_code) and len(price) and len(money_type) and len(is_kdv))><!--- belge tam mı --->
 			
			<cfquery name="GET_PRODUCT" dbtype="query">
				SELECT
					*
				FROM   
					GET_PRODUCT_ALL
				WHERE
					<cfif attributes.product_type eq 1>
						STOCK_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#prod_code#">
					<cfelseif attributes.product_type eq 2>
						PRODUCT_CODE_2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#prod_code#">
					<cfelseif attributes.product_type eq 3>
						BARCODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#prod_code#">
					</cfif>
			</cfquery>
			<cfif get_product.recordcount eq 1><!--- ürün varmı --->
				
				<cfquery name="GET_PRODUCT_UNIT" dbtype="query">
					SELECT 
                    	PRODUCT_UNIT_ID 
                  	FROM 
                    	GET_PRODUCT_UNIT_ALL 
                   	WHERE 
                    	<cfif isdefined('attributes.is_main') and attributes.is_main eq 1>
                        	PRODUCT_ID = #get_product.product_id#
                        <cfelse>
                            PRODUCT_ID = #get_product.product_id# 
                            AND UPPER(ADD_UNIT) = '#ucasetr(unit_name)#'
                        </cfif>
				</cfquery>
				<cfif get_product_unit.recordcount and ListFind(money_list,money_type,',')><!--- birim varmı --->
					<cfset end_price = wrk_round(price,round_num)>
					<cfif attributes.price_cat eq "-1">
						<cfquery name="DEL_PRODUCT_PRICE_PURCHASE" datasource="#DSN3#">
							DELETE FROM
								#dsn1_alias#.PRICE_STANDART
							WHERE
								PRODUCT_ID = #get_product.product_id# AND
								PURCHASESALES = 0 AND
								UNIT_ID = #get_product_unit.product_unit_id# AND
								START_DATE = #attributes.startdate_fn#						
						</cfquery>
						<cfif is_kdv><!---KDV'li ise --->
							<cfset end_price_without_kdv = wrk_round((price/(get_product.tax_purchase+100))*100,round_num)>							
						<cfelse><!---KDV'li değil ise --->
							<cfset end_price_with_kdv = wrk_round((price/100)*(get_product.tax_purchase+100),round_num)>
						</cfif>
						<cfquery name="ADD_PRODUCT_PRICE_PURCHASE" datasource="#DSN3#">
							INSERT INTO
								#dsn1_alias#.PRICE_STANDART
							(
								PRICESTANDART_STATUS,
								PRODUCT_ID,
								PURCHASESALES,
								PRICE,
								PRICE_KDV,
								IS_KDV,
								ROUNDING,
								MONEY,
								UNIT_ID,
								START_DATE,
								RECORD_DATE,
								RECORD_EMP,
								RECORD_IP
							)
							VALUES
							(
								0,
								#get_product.product_id#,
								0,
							<cfif is_kdv>
								#end_price_without_kdv#,
								#end_price#,
							<cfelse>
								#end_price#,
								#end_price_with_kdv#,
							</cfif>
								#is_kdv#,
								#attributes.rounding#,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#money_type#">,
								#get_product_unit.product_unit_id#,
								#attributes.startdate_fn#,
								#now()#,
								#session.ep.userid#,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
							)
						</cfquery>
						<cfquery name="UPD_PRICE_STANDART_PURCHASE_STAT_0" datasource="#DSN3#">
							UPDATE
								#dsn1_alias#.PRICE_STANDART
							SET
								PRICESTANDART_STATUS = 0
							WHERE
								PRODUCT_ID = #get_product.product_id# AND
								PURCHASESALES = 0 AND
								UNIT_ID = #get_product_unit.product_unit_id# AND
								PRICESTANDART_STATUS = 1
						</cfquery>
						<cfquery name="GET_MAX_ST_DATE_ID_PURC" datasource="#DSN3#" maxrows="1">
							SELECT 
								MAX(PRICESTANDART_ID) AS PRICESTANDART_ID
							FROM 
								#dsn1_alias#.PRICE_STANDART 
							WHERE 
								PRODUCT_ID = #get_product.product_id# AND
								PURCHASESALES = 0 AND
								UNIT_ID = #get_product_unit.product_unit_id# AND 
								START_DATE = (	SELECT MAX(START_DATE) AS START_DATE 
												FROM #dsn1_alias#.PRICE_STANDART 
												WHERE PRODUCT_ID = #get_product.product_id# AND PURCHASESALES = 0 AND UNIT_ID = #get_product_unit.product_unit_id#)
						</cfquery>
						<cfquery name="UPD_PRICE_STANDART_SALES_STAT_1" datasource="#DSN3#" maxrows="1">
							UPDATE
								#dsn1_alias#.PRICE_STANDART
							SET
								PRICESTANDART_STATUS = 1
							WHERE	
								PRICESTANDART_ID = #get_max_st_date_id_purc.pricestandart_id#
						</cfquery>
					<cfelseif attributes.price_cat eq "-2">
						<cfquery name="DEL_PRODUCT_PRICE_SALES" datasource="#DSN3#">
							DELETE FROM
								#dsn1_alias#.PRICE_STANDART
							WHERE
								PRODUCT_ID = #get_product.product_id# AND
								PURCHASESALES = 1 AND
								UNIT_ID = #get_product_unit.product_unit_id# AND
								START_DATE = #attributes.startdate_fn#						
						</cfquery>
						
						<cfif is_kdv><!---KDV'li ise --->
							<cfset end_price_without_kdv = wrk_round((price/(get_product.tax+100))*100,round_num)>
						<cfelse><!---KDV'li değil ise --->
							<cfset end_price_with_kdv = wrk_round((price/100)*(get_product.tax+100),round_num)>
						</cfif>
						<cfquery name="ADD_PRODUCT_PRICE_SALES" datasource="#DSN3#">
							INSERT INTO
								#dsn1_alias#.PRICE_STANDART
							(
								PRICESTANDART_STATUS,
								PRODUCT_ID,
								PURCHASESALES,
								PRICE,
								PRICE_KDV,
								IS_KDV,
								ROUNDING,
								MONEY,
								UNIT_ID,
								START_DATE,
								RECORD_DATE,
								RECORD_EMP,
								RECORD_IP
							)
							VALUES
							(
								0,
								#get_product.product_id#,
								1,
							<cfif is_kdv>
								#end_price_without_kdv#,
								#end_price#,
							<cfelse>
								#end_price#,
								#end_price_with_kdv#,
							</cfif>
								#is_kdv#,
								#attributes.rounding#,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#money_type#">,
								#get_product_unit.product_unit_id#,
								#attributes.startdate_fn#,
								#now()#,
								#session.ep.userid#,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
							)
						</cfquery>
						<cfquery name="UPD_PRICE_STANDART_SALES_STAT" datasource="#DSN3#">
							UPDATE
								#dsn1_alias#.PRICE_STANDART
							SET
								PRICESTANDART_STATUS = 0
							WHERE
								PRODUCT_ID = #get_product.product_id# AND
								PURCHASESALES = 1 AND
								UNIT_ID = #get_product_unit.product_unit_id# AND
								PRICESTANDART_STATUS = 1
						</cfquery>
						<cfquery name="GET_MAX_ST_DATE_ID" datasource="#DSN3#" maxrows="1">
							SELECT 
								MAX(PRICESTANDART_ID) AS PRICESTANDART_ID
							FROM 
								#dsn1_alias#.PRICE_STANDART 
							WHERE 
								PRODUCT_ID = #get_product.product_id# AND
								PURCHASESALES = 1 AND
								UNIT_ID = #get_product_unit.product_unit_id# AND 
								START_DATE = (	SELECT MAX(START_DATE) AS START_DATE 
												FROM #dsn1_alias#.PRICE_STANDART 
												WHERE PRODUCT_ID = #get_product.product_id# AND PURCHASESALES = 1 AND UNIT_ID = #get_product_unit.product_unit_id#)
						</cfquery>
						<cfquery name="UPD_PRICE_STANDART_SALES_STAT_1" datasource="#DSN3#">
							UPDATE
								#dsn1_alias#.PRICE_STANDART
							SET
								PRICESTANDART_STATUS = 1
							WHERE
								PRICESTANDART_ID = #get_max_st_date_id.pricestandart_id#
						</cfquery>
				<cfelse>
				
				<!--- diğer fiyat listeleri --->
					<cfif is_kdv><!---KDV'li ise --->
						<cfset end_price_without_kdv = wrk_round((price/(get_product.tax_purchase+100))*100,round_num)>
					<cfelse><!---KDV'li değil ise --->
						<cfset end_price_with_kdv = wrk_round((price/100)*(get_product.tax_purchase+100),round_num)>
					</cfif>
					<cfif len(spect_id)>
						<cfquery name="get_spect_stock" dbtype="query">
							SELECT STOCK_ID FROM GET_SPECT_ALL WHERE SPECT_MAIN_ID = #spect_id#
						</cfquery>
						<cfif get_spect_stock.recordcount>
							<cfset spect_main_id_ = spect_id>
							<cfset stock_id_ = get_spect_stock.stock_id>
						<cfelse>	
							<cfif get_product.product_code neq get_product.stock_code>
								<cfset stock_id_ = get_product.stock_id>
							<cfelse>
								<cfset stock_id_ = 0>
							</cfif>
						</cfif>
					<cfelse>
						<cfset stock_id_ = get_product.stock_id>
					</cfif>
					
					<cfif attributes.is_mix_pocket eq 1><!---Karma Koli İçerikleri Güncellensin İşaretli İse...--->
						<cfif is_kdv><!---KDV'li ise --->
								<cfset end_price_without_kdv = wrk_round((price/(get_product.tax+100))*100,round_num)>
						<cfelse><!---KDV'li değil ise --->
								<cfset end_price_with_kdv = wrk_round((price/100)*(get_product.tax+100),round_num)>
						</cfif>
						
						<cfquery name="get_mix_pocket" datasource="#DSN3#">
							SELECT 
								KARMA_PRODUCT_ID,
								STOCK_ID,
								SALES_PRICE,
								SALES_PRICE_KDV,
								START_DATE,
								PRICE_CATID,
								MONEY,
                                ENTRY_ID
							FROM 
								KARMA_PRODUCTS_PRICE 
							WHERE 
								PRODUCT_ID =#get_product.product_id# AND
								PRICE_CATID = #attributes.price_cat# AND
                                STOCK_ID = #get_product.stock_id#
						</cfquery>
						
						<cfquery name="upd_mix_pocket" datasource="#DSN3#"><!---Karma Koli içeriği Güncelleniyor. --->
							UPDATE 
								KARMA_PRODUCTS_PRICE 
							SET 
								SALES_PRICE=#end_price_without_kdv#,
								SALES_PRICE_KDV = #end_price_with_kdv#,
								START_DATE = #attributes.startdate_fn#,
                                <cfif is_kdv>
                                TOTAL_PRODUCT_PRICE=#end_price_without_kdv#
                                <cfelse>
                                 TOTAL_PRODUCT_PRICE=#end_price_with_kdv#
                                </cfif>
							WHERE 
								PRODUCT_ID =#get_product.product_id# AND
								PRICE_CATID = #attributes.price_cat# AND
								STOCK_ID=#get_product.stock_id#
						</cfquery>
                        <cfif get_mix_pocket.recordcount gt 0>
						<cfquery name="upd_mix_pocket_price" datasource="#DSN3#" >
							UPDATE PRICE SET PRICE =(SELECT 
								sum(SALES_PRICE) as TOTAL
							FROM 
								KARMA_PRODUCTS_PRICE 
							WHERE 
								PRODUCT_ID =#get_product.product_id# AND
								PRICE_CATID = #attributes.price_cat#)   WHERE PRICE_CATID = #attributes.price_cat# AND PRODUCT_ID=#get_mix_pocket.KARMA_PRODUCT_ID#
						</cfquery>
                        <cfquery name ="upd_mix_pocket_list_price" datasource="#DSN1#">
                        		UPDATE 
									KARMA_PRODUCTS 
								SET 
                                <cfif is_kdv><!---KDV'li ise --->
                                    LIST_PRICE =#end_price_without_kdv#,
                                    SALES_PRICE=#end_price_without_kdv#
                                <cfelse><!---KDV'li değil ise --->
                                    LIST_PRICE =#end_price_with_kdv# ,
                                    SALES_PRICE=#end_price_with_kdv#
                                </cfif>
								WHERE 
									ENTRY_ID IN (SELECT ENTRY_ID FROM #DSN3_alias#.KARMA_PRODUCTS_PRICE WHERE PRICE_CATID = #attributes.price_cat# AND KARMA_PRODUCT_ID=#get_mix_pocket.KARMA_PRODUCT_ID# AND ENTRY_ID =#get_mix_pocket.ENTRY_ID# )
                        </cfquery>
                        </cfif>
					</cfif>
					<cfquery name="new_price_add_method" datasource="#dsn3#" timeout="600">
						exec add_price
								#get_product.product_id#,
								#get_product_unit.product_unit_id#,
								#attributes.price_cat#,
								#attributes.startdate_fn#,
								#iif(is_kdv,end_price_without_kdv,end_price)#,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#money_type#">,
								#is_kdv#,
								#iif(is_kdv,end_price,end_price_with_kdv)#,
								-1,
								#session.ep.userid#,
								'#cgi.remote_addr#',
								0,
								#stock_id_#,
								#spect_main_id_#
					</cfquery>
				</cfif>
				<cfelse>
					<cfoutput>#i-1#. <cf_get_lang no="366.satırdaki"> 
							<cfif not get_product_unit.recordcount>
							<cf_get_lang no='370.ürünün birimi'>
							<cfelseif not ListFind(money_list,money_type,',')>
							<cf_get_lang no="375.ürünün para birimi">
							</cfif>  <cf_get_lang no="393.ile ilgili hata oluştu"> <br/>
					</cfoutput>
				</cfif><!--- birim varmı --->
			<cfelse>
				<cfoutput>#i-1#. <cf_get_lang no="366.satırdaki"> <cfif not get_product.recordcount><cf_get_lang no="403.ürün işlem yapılan şirkette kayıtlı değil"><cfelse><cf_get_lang no="404.ürün birden fazla bulundu"></cfif><br/></cfoutput>
			</cfif><!--- ürün varmı --->
		<cfelse>
				<cfoutput>#i-1#.<cf_get_lang no="411.satırın belgedeki bilgileri yetersiz"> <br/></cfoutput>
		</cfif><!--- belge tammı --->
        
	</cfloop>
	<cf_get_lang no="414.İŞLEM TAMAMLANDI (SAYFAYI YENİLEMEYİN HATALI KAYIT VARSA ONLARI INCELEYEREK SAYFAYI KAPATINIZ)">...
</cfif>