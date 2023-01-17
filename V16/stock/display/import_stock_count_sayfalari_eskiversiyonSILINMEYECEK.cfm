<!--- şubede stok sayım ekleme sayfasının eski versiyonudur. Dosyadan sayım eklendikten sonra direk şube ve fire fişine çevrilmektedir
örnek olarak saklanmaktadır,action sayfasida alt kısımdadır... 
Yeni versiyonda dosya eklendikten sonra sayım ve fşre fişine çevrilmek iin önce toplu sayımları yapılmalıdır sonra fişe çevrilmelidir.
(aysenur 20050725)
--->
<cf_papers paper_type="STOCK_FIS">
<cfquery name="get_user_process_cat1" datasource="#dsn3#">
	SELECT
		DISTINCT
		SPC.PROCESS_CAT_ID,
		SPC.PROCESS_CAT,
		SPC.PROCESS_TYPE,
		SPC.IS_ACCOUNT,
		SPC.IS_DEFAULT
	FROM
		SETUP_PROCESS_CAT_ROWS AS SPCR,
		SETUP_PROCESS_CAT_FUSENAME AS SPCF,
		#dsn_alias#.EMPLOYEE_POSITIONS AS EP,
		SETUP_PROCESS_CAT SPC
	WHERE
		SPC.PROCESS_CAT_ID = SPCR.PROCESS_CAT_ID AND
		SPC.PROCESS_CAT_ID = SPCF.PROCESS_CAT_ID AND
		SPC.PROCESS_TYPE = 115 AND
		(
			(SPCR.POSITION_CODE=#session.ep.POSITION_CODE# AND SPCR.POSITION_CODE=EP.POSITION_CODE) OR
			(EP.POSITION_CODE=#session.ep.POSITION_CODE# AND SPCR.POSITION_CAT_ID=EP.POSITION_CAT_ID)
		)
	ORDER BY
		SPC.PROCESS_CAT
</cfquery>
<cfquery name="get_user_process_cat2" datasource="#dsn3#">
	SELECT
		DISTINCT
		SPC.PROCESS_CAT_ID,
		SPC.PROCESS_CAT,
		SPC.PROCESS_TYPE,
		SPC.IS_ACCOUNT,
		SPC.IS_DEFAULT
	FROM
		SETUP_PROCESS_CAT_ROWS AS SPCR,
		SETUP_PROCESS_CAT_FUSENAME AS SPCF,
		#dsn_alias#.EMPLOYEE_POSITIONS AS EP,
		SETUP_PROCESS_CAT SPC
	WHERE
		SPC.PROCESS_CAT_ID = SPCR.PROCESS_CAT_ID AND
		SPC.PROCESS_CAT_ID = SPCF.PROCESS_CAT_ID AND
		SPC.PROCESS_TYPE = 112 AND
		(
			(SPCR.POSITION_CODE=#session.ep.POSITION_CODE# AND SPCR.POSITION_CODE=EP.POSITION_CODE) OR
			(EP.POSITION_CODE=#session.ep.POSITION_CODE# AND SPCR.POSITION_CAT_ID=EP.POSITION_CAT_ID)
		)
	ORDER BY
		SPC.PROCESS_CAT
</cfquery>
<cfform name="form_basket" enctype="multipart/form-data" method="post" action="#request.self#?fuseaction=store.popup_add_import_stock_count_display">
  <!--- emptypopup_import_stock_open_genius --->
  <input  type="hidden" name="html_file" id="html_file" value="<cfoutput>#createUUID()#</cfoutput>.html">
  <table width="100%" align="center" cellpadding="0" cellspacing="0" border="0" height="100%">
    <tr>
      <td class="color-border">
        <table width="100%" align="center" cellpadding="2" cellspacing="1" border="0" height="100%">
          <tr height="35" class="color-list">
            <td class="headbold">&nbsp;Stok Sayımı</td>
          </tr>
          <tr class="color-row">
            <td valign="top"><table>
                <tr>
                  <td width="5"></td>
                  <td>Sayım İçin</td>
                  <td>
				  <select name="process_cat1" id="process_cat1" style="width:200;">
					<option value="" selected>Seçiniz</option>
					<cfoutput query="get_user_process_cat1">
					<option value="#PROCESS_CAT_ID#">#PROCESS_CAT#</option>
					</cfoutput>
				   </select>
				   </td>
                </tr>
                <tr>
                  <td width="5"></td>
                  <td>Fire İçin</td>
                  <td>
				  <select name="process_cat2" id="process_cat2" style="width:200;">
					<option value="" selected>Seçiniz</option>
					<cfoutput query="get_user_process_cat2">
					<option value="#PROCESS_CAT_ID#">#PROCESS_CAT#</option>
					</cfoutput>
				  </select>
				  </td>
                </tr>
				<tr>
                  <td width="5"></td>
                  <td>Belge Ayracı</td>
                  <td>
				  <select name="seperator_type" id="seperator_type" style="width:200;">
					<option value="59">Noktalı Virgül</option>
					<option value="44">Virgül</option>
				  </select>
				  </td>
                </tr>
				
                <tr>
                  <td></td>
                  <td>Belge *</td>
                  <td><input type="file" name="uploaded_file" id="uploaded_file" style="width:200;"></td>
                </tr>
                <tr>
                  <td></td>
                  <td>Depo-Lokasyon *</td>
					<input type="hidden" name="location_id" id="location_id">								
					<input type="hidden" name="department_id" id="department_id">
				  <td><cfsavecontent variable="message">Depo Lokasyon Girmelisiniz !</cfsavecontent>
				  	<cfinput type="text" name="store" style="width:200;" value="" required="yes" message="#message#" readonly>                    
					<a href="javascript://" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_stores_locations&is_branch=1&form_name=form_basket&field_name=store&field_id=department_id&field_location_id=location_id','list','popup_list_stores_locations')" ><img src="/images/plus_thin.gif" border="0" align="absmiddle"></a></td>
                </tr>
                <tr>
                  <td></td>
                  <td>Tarih *</td>
                  <td><cfsavecontent variable="message">Tarih Girmelisiniz !</cfsavecontent>
                    <cfinput type="text" name="process_date" value="" validate="#validate_style#" required="yes" message="#message#" maxlength="10" style="width:200px;">
                    <cf_wrk_date_image date_field="process_date"></td>
                </tr>
                <tr>
				  <td colspan="2"></td>
                  <td><cf_workcube_buttons is_upd='0' add_function='kontrol()'></td>
                </tr>
              </table>
            </td>
          </tr>
        </table>
      </td>
    </tr>
  </table>
</cfform>
<script type="text/javascript">
function kontrol()
{
	x = document.form_basket.process_cat1.selectedIndex;
	if (document.form_basket.process_cat1[x].value == "")
	{
		alert("Sayım Belge Tipi Seçimiz !");
		return false;
	}
	y = document.form_basket.process_cat2.selectedIndex;
	if (document.form_basket.process_cat2[y].value == "")
	{
		alert("Fire Belge Tipi Seçimiz !");
		return false;
	}	
	return true;
}
</script>


<!--- action_sayfasi --->
<cf_date tarih='attributes.process_date'>
<cfset get_stock_date = date_add("h",23,attributes.process_date)>
<cfset get_stock_date = date_add("n",59,get_stock_date)>
<cfset negative = 0>
<cfset positive = 0>
<cffunction name="get_stock_amount">
	<cfargument name="barcode">
	<cfquery name="get_pro_stock" datasource="#DSN2#">
		SELECT
			SUM(SR.STOCK_IN - SR.STOCK_OUT) AS product_stock
		FROM
			#dsn3_alias#.GET_STOCK_BARCODES S,
			STOCKS_ROW SR
		WHERE
			S.STOCK_ID = SR.STOCK_ID AND
			SR.STORE = #department_id# AND
			S.BARCODE = '#barcode#' AND
			SR.PROCESS_DATE <= #get_stock_date#	<!--- BK 20050705 Sayımdaki tarih sorunu icin eklendi --->
			<cfif isdefined("location_id") and len(location_id)>
				AND SR.STORE_LOCATION = #location_id#
			</cfif>			
	</cfquery>
	<cfreturn get_pro_stock.product_stock>
</cffunction>

<cfquery name="GET_RECORD_OPEN_FIS" datasource="#DSN2#">
	SELECT 
		* 
	FROM 
		STOCK_FIS
	WHERE 
		DEPARTMENT_IN = #department_id# AND 
		FIS_TYPE = 115 AND
		LOCATION_IN = #location_id#
</cfquery>

<cfset upload_folder = "#upload_folder#store#dir_seperator#">
<cftry>
	<cffile
		action = "upload" 
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
			alert("Dosyanız Upload Edilemedi ! Dosyanızı Kontrol Ediniz !");
			history.back();
		</script>
		<cfabort>
	</cfcatch>  
</cftry>
<cffile action="read" file="#upload_folder##file_name#" variable="dosya">
<cfscript>
	CRLF = Chr(13) & Chr(10);// satır atlama karakteri
	dosya1 = ListToArray(dosya,CRLF);
	line_count = ArrayLen(dosya1);
</cfscript>
<cfset document_seperator = chr(attributes.seperator_type)>
<table width="98%" border="0" cellspacing="0" cellpadding="0" height="35" align="center">
	<tr><td class="headbold">Stok Sayım Sonuçları</td></tr>
</table>
<cfform action="#request.self#?fuseaction=objects.emptypopup_stock_count" method="post" name="aa">
	<cfset barcod_id_list=''>
	<cfloop from="1" to="#line_count#" index="i">
		<cfset temp_barcod = trim(listfirst(dosya1[i],'#document_seperator#'))>
		<cfif len(temp_barcod) and not listfind(barcod_id_list,temp_barcod)>			
			<cfset barcod_id_list = Listappend(barcod_id_list,temp_barcod)>
		</cfif>
	</cfloop>
	<cfif not listlen(barcod_id_list)>
		<script type="text/javascript">
			alert('Belgenizde Barkod Listesi Bulunamadı. Lütfen Belgenizi Kontrol Ediniz !');
			window.history.back();
		</script>
		<cfabort>
	</cfif>
	<cfquery name="get_product" datasource="#dsn3#">
		SELECT
			GET_STOCK_BARCODES.BARCODE,
			GET_STOCK_BARCODES.PRODUCT_ID,
			GET_STOCK_BARCODES.STOCK_ID,
			STOCKS.STOCK_CODE,
			STOCKS.PRODUCT_NAME,
			STOCKS.PROPERTY	,	
			STOCKS.TAX_PURCHASE,
			PRICE_STANDART.PRICE,
			PRODUCT_UNIT.ADD_UNIT,
			PRODUCT_UNIT.PRODUCT_UNIT_ID
		FROM
			GET_STOCK_BARCODES,
			STOCKS,
			PRODUCT_UNIT,
			PRICE_STANDART
		WHERE
			PRODUCT_UNIT.IS_MAIN = 1 AND
			GET_STOCK_BARCODES.BARCODE IN (#listqualify(barcod_id_list,"'")#) AND
			STOCKS.STOCK_ID = GET_STOCK_BARCODES.STOCK_ID AND
			PRODUCT_UNIT.PRODUCT_ID = GET_STOCK_BARCODES.PRODUCT_ID AND
			PRICE_STANDART.UNIT_ID = PRODUCT_UNIT.PRODUCT_UNIT_ID AND
			PRICE_STANDART.PRICESTANDART_STATUS = 1 AND
			PRICE_STANDART.PURCHASESALES = 0
		ORDER BY
			GET_STOCK_BARCODES.BARCODE
	</cfquery>
	<input type="hidden" name="fis_date" id="fis_date" value="<cfoutput>#dateformat(process_date,dateformat_style)#</cfoutput>">
	<input type="hidden" name="file_path" id="file_path" value="<cfoutput>#upload_folder##file_name#</cfoutput>">	
	<input type="hidden" name="location" id="location" value="<cfoutput>#location_id#</cfoutput>">
	<input type="hidden" name="department" id="department" value="<cfoutput>#department_id#</cfoutput>">
	<input type="hidden" name="file_name" id="file_name" value="<cfoutput>#file_name#</cfoutput>">
	<input type="hidden" name="file_size" id="file_size" value="<cfoutput>#file_size#</cfoutput>">
	<table width="98%" align="center" cellpadding="0" cellspacing="0" border="0">
	  <tr class="color-border">
		<td>
			<table cellpadding="2" cellspacing="1" border="0" width="100%">
				<tr class="color-header" height="22">
					<td width="30" class="form-title">Barkod</td>
					<td class="form-title">Ürün</td>
					<td class="form-title">Olması Gereken</td>
					<td class="form-title">Sayılan</td>
					<td class="form-title">Fark</td>				
				</tr>
				<input type="hidden" name="total_record" id="total_record" value="<cfoutput>#line_count#</cfoutput>">
				<cfloop from="1" to="#line_count#" index="i">
					<cfset barcode = trim(listfirst(dosya1[i],"#document_seperator#"))>
 					<cfquery name="get_product_name" dbtype="query">
						SELECT PRODUCT_NAME, PROPERTY, ADD_UNIT FROM get_product WHERE BARCODE='#barcode#'
					</cfquery>
					<cfif get_product_name.recordcount>
						<cfif get_product_name.ADD_UNIT is "Kg">
							<cfset amount = (listlast(dosya1[i],"#document_seperator#")+0)/1000>
						<cfelse>
							<cfset amount = listlast(dosya1[i],"#document_seperator#")+0>
						</cfif>
						<cfset deger = get_stock_amount(barcode)>
						<cfif not len(deger)>
							<cfset deger = 0>
						</cfif>
						<cfset fark = amount-deger>
						<cfset 'barcod_#i#' = barcode>
						<cfset 'amount_#i#' = amount>
						<cfset 'deger_#i#' = deger>
						<cfset 'fark_#i#' = fark>
						<cfset 'exist_#i#' = 1>
						<cfoutput>
						<tr class="color-row" height="20">
							<td>#barcode#</td>
							<td>#get_product_name.PRODUCT_NAME# - #get_product_name.PROPERTY#</td>
						<cfif get_product_name.ADD_UNIT is "Kg">
							<td align="right" style="text-align:right;">#TLFormat(deger,3)#</td>
							<td align="right" style="text-align:right;">#TLFormat(amount,3)#</td>
							<td align="right" style="text-align:right;">#TLFormat(fark,3)#</td>
						<cfelse>
							<td align="right" style="text-align:right;">#TLFormat(deger,0)#</td>
							<td align="right" style="text-align:right;">#TLFormat(amount,0)#</td>
							<td align="right" style="text-align:right;">#TLFormat(fark,0)#</td>
						</cfif>
						</tr>
						</cfoutput>	
					<cfelse>
						<cfset 'exist_#i#'=0>
						<cfoutput>
						<tr class="color-row" height="20">
							<td>#barcode# (<font color="##FF0000">Bu Ürün Kayıtlı Değil !</font>)</td>
							<td>??</td>
							<td>??</td>
							<td>#listlast(dosya1[i],"#document_seperator#")#</td>
							<td>??</td>
						</tr>										
						</cfoutput>
					</cfif>
					<cfif evaluate("exist_#i#") eq 1>
						<cfif evaluate("fark_#i#") gt 0>
							<cfset positive = 1>
						</cfif>
						<cfif evaluate("fark_#i#") lt 0>
							<cfset negative = 1>						
						</cfif>						
					</cfif>
				</cfloop>
				<cf_papers paper_type="STOCK_FIS">
				<cfset system_paper_no=paper_code & '-' & paper_number>
				<cfset system_paper_no_add = paper_number>
				
				<cflock timeout="60">
					<cftransaction>	
						<cfif positive eq 1>
							<cfquery name="ADD_STOCK_FIS" datasource="#dsn2#">
								INSERT INTO
								STOCK_FIS
								(
									FIS_TYPE,
									PROCESS_CAT,
									FIS_NUMBER,
									FIS_DATE,
									EMPLOYEE_ID,
									RECORD_DATE,
									DEPARTMENT_IN,
									LOCATION_IN			
								)
								VALUES
								(
									115,
									#attributes.process_cat1#,
									'#system_paper_no#',
									#attributes.process_date#,				
									#session.ep.userid#,
									#now()#,
									#attributes.department_id#,
									#attributes.location_id#
								)
							</cfquery>
							<cfloop from="1" to="#line_count#" index="i">
								<cfif evaluate("exist_#i#") eq 1>
									<cfif evaluate("fark_#i#") gt 0>
									<cfset miktar = evaluate("fark_#i#")>
									
									<cfquery name="get_product_record" dbtype="query">
										SELECT * FROM GET_PRODUCT WHERE BARCODE = '#evaluate("barcod_#i#")#'
									</cfquery>
									
									<cfscript>
										satir_toplam = miktar * get_product_record.price;
										satir_toplam_net = miktar * get_product_record.price;
										kdv_toplam = (satir_toplam_net *get_product_record.tax_purchase)/100;
									</cfscript>
									
									<cfquery name="add_stock_row" datasource="#DSN2#">
										INSERT INTO 
										STOCK_FIS_ROW
										(
											FIS_ID,
											FIS_NUMBER,
											STOCK_ID,
											AMOUNT,
											UNIT,
											UNIT_ID,							
											PRICE,
											TAX,
											DISCOUNT1,
											DISCOUNT2,
											DISCOUNT3,
											DISCOUNT4,
											DISCOUNT5,				
											TOTAL,
											TOTAL_TAX,
											NET_TOTAL
										)
										VALUES
										(
											#MAX_ID.IDENTITYCOL#,
											'#system_paper_no#',							
											#get_product_record.stock_id#,
											#miktar#,
											'#get_product_record.add_unit#',
											#get_product_record.product_unit_id#,							
											#get_product_record.price#,
											#get_product_record.tax_purchase#,
											0,
											0,
											0,
											0,
											0,
											#satir_toplam#,
											#kdv_toplam#,
											#satir_toplam_net#
										)
									</cfquery>									
									<cfquery name="ADD_STOCK_ROW" datasource="#dsn2#">
										INSERT INTO
										STOCKS_ROW
											(
											UPD_ID,
											PRODUCT_ID,
											STOCK_ID,
											PROCESS_TYPE,
											STOCK_IN,
											STORE,
											STORE_LOCATION,
											PROCESS_DATE
										)
										VALUES
										(
											#MAX_ID.IDENTITYCOL#,
											#get_product_record.product_id#,
											#get_product_record.stock_id#,
											115,
											#miktar#,
											#attributes.department_id#,
											#attributes.location_id#,
											#attributes.process_date#
										)
									</cfquery>
									</cfif>									
								</cfif>
							</cfloop>
							<cfquery name="UPD_GEN_PAP" datasource="#DSN2#">
								UPDATE 
									#dsn3_alias#.GENERAL_PAPERS
								SET
									STOCK_FIS_NUMBER=#system_paper_no_add#
								WHERE
									STOCK_FIS_NUMBER IS NOT NULL
							</cfquery>
						</cfif>
						<cfif negative eq 1>
							<cfif positive eq 1>
								<cfset system_paper_number = paper_number + 1>
							<cfelse>
								<cfset system_paper_number = paper_number>
							</cfif>
							<cfset system_paper_no=paper_code & '-' & system_paper_number>
							<cfquery name="ADD_STOCK_FIS" datasource="#dsn2#" result="MAX_ID">
								INSERT INTO
								STOCK_FIS
								(
									FIS_TYPE,
									PROCESS_CAT,
									FIS_NUMBER,
									FIS_DATE,
									EMPLOYEE_ID,
									RECORD_DATE,
									DEPARTMENT_OUT,
									LOCATION_OUT			
								)
								VALUES
								(
									112,
									#attributes.process_cat2#,
									'#system_paper_no#',
									#attributes.process_date#,				
									#session.ep.userid#,
									#now()#,
									#attributes.department_id#,
									#attributes.location_id#
								)
							</cfquery>
							<cfloop from="1" to="#line_count#" index="i">
								<cfif evaluate("exist_#i#") eq 1>
									<cfif evaluate("fark_#i#") lt 0>
									<cfset miktar = evaluate("fark_#i#")*(-1)>
									<cfquery name="get_product_record" dbtype="query">
										SELECT * FROM GET_PRODUCT WHERE BARCODE = '#evaluate("barcod_#i#")#'
									</cfquery>
									
									<cfscript>
										satir_toplam = miktar * get_product_record.price;
										satir_toplam_net = miktar * get_product_record.price;
										kdv_toplam = (satir_toplam_net *get_product_record.tax_purchase)/100;
									</cfscript>
									
									<cfquery name="add_stock_row" datasource="#DSN2#">
										INSERT INTO 
										STOCK_FIS_ROW
										(
											FIS_ID,
											FIS_NUMBER,
											STOCK_ID,
											AMOUNT,
											UNIT,
											UNIT_ID,							
											PRICE,
											TAX,
											DISCOUNT1,
											DISCOUNT2,
											DISCOUNT3,
											DISCOUNT4,
											DISCOUNT5,				
											TOTAL,
											TOTAL_TAX,
											NET_TOTAL
										)
										VALUES
										(
											#MAX_ID.IDENTITYCOL#,
											'#system_paper_no#',							
											#get_product_record.stock_id#,
											#miktar#,
											'#get_product_record.add_unit#',
											#get_product_record.product_unit_id#,							
											#get_product_record.price#,
											#get_product_record.tax_purchase#,
											0,
											0,
											0,
											0,
											0,
											#satir_toplam#,
											#kdv_toplam#,
											#satir_toplam_net#
										)
									</cfquery>									
									<cfquery name="ADD_STOCK_ROW" datasource="#dsn2#">
										INSERT INTO
										STOCKS_ROW
											(
											UPD_ID,
											PRODUCT_ID,
											STOCK_ID,
											PROCESS_TYPE,
											STOCK_OUT,
											STORE,
											STORE_LOCATION,
											PROCESS_DATE
										)
										VALUES
										(
											#MAX_ID.IDENTITYCOL#,
											#get_product_record.product_id#,
											#get_product_record.stock_id#,
											112,
											#miktar#,
											#attributes.department_id#,
											#attributes.location_id#,
											#attributes.process_date#
										)
									</cfquery>
									</cfif>									
								</cfif>
							</cfloop>
							<cfquery name="UPD_GEN_PAP" datasource="#DSN2#">
								UPDATE
									#dsn3_alias#.GENERAL_PAPERS
								SET
									STOCK_FIS_NUMBER=#system_paper_number#
								WHERE
									STOCK_FIS_NUMBER IS NOT NULL
							</cfquery>
						</cfif>
				<!--- dosya loglanır... --->
				<cfif (positive eq 1) or (negative eq 1)>
					<cfquery name="add_file" datasource="#dsn2#">
						INSERT INTO	FILE_IMPORTS
						(
							PROCESS_TYPE,
							PRODUCT_COUNT,
							FILE_NAME,
							FILE_SIZE,
							DEPARTMENT_ID,
							STARTDATE,
							RECORD_DATE,
							RECORD_IP,
							RECORD_EMP,
							FIS_NUMBER
						)
						VALUES
						(
							-5,
							#line_count#,
							'#file_name#',
							#file_size#,
							#attributes.department_id#,
							#attributes.process_date#,
							#NOW()#,
							'#CGI.REMOTE_ADDR#',
							#SESSION.EP.USERID#,
							'#system_paper_no#'
						)
					</cfquery>
				</cfif>
				</cftransaction>
			</cflock>
			</table>
			</td>
		</tr>
	</table>
</cfform>
