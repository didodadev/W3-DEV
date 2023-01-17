<cfset upload_folder = "#upload_folder#store#dir_seperator#" >
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
	<cfset dosya_yolu = "#upload_folder##file_name#" >
	<cffile action="read" file="#dosya_yolu#" variable="dosya">
	<cffile action="delete" file="#dosya_yolu#">
	<cfcatch type="Any">
		<script type="text/javascript">
			alert("Dosyanız upload edilemedi ! Dosyanızı kontrol ediniz !");
			history.back();
		</script>
		<cfabort>
	</cfcatch>  
</cftry>
<cfscript>
	CRLF = Chr(13)&Chr(10); // satır atlama karakteri
	dosya = ListToArray(dosya,CRLF);
	line_count = ArrayLen(dosya);
</cfscript>
<cfset document_seperator = chr(attributes.seperator_type)>
<cfset barcod_list = "">
<cfloop from="1" to="#line_count#" index="i">
	<cfset temp_barcod = trim(listfirst(dosya[i],'#document_seperator#'))>
	<cfif len(temp_barcod) and not listfind(barcod_list,temp_barcod)>			
		<cfset barcod_list = Listappend(barcod_list,temp_barcod)>
	</cfif>
</cfloop>
<cfif not listlen(barcod_list)>
	<script type="text/javascript">
		alert('Belgenizde Barkod Listesi Bulunamadı. Lütfen Belgenizi Kontrol Ediniz !');
		window.history.back();
	</script>
	<cfabort>
</cfif>
<cfquery name="get_product_main_all" datasource="#dsn3#">
	SELECT
		GSB.BARCODE,
		S.STOCK_ID,
		S.PRODUCT_ID,
		S.STOCK_CODE,
		S.PROPERTY,					
		P.PRODUCT_NAME,
		P.MANUFACT_CODE,
		PS.PRICE,
		PS.MONEY,
		PU.MAIN_UNIT,
		PS.PURCHASESALES,
		PS.PRICESTANDART_STATUS,
		PU.IS_MAIN
	FROM
		PRODUCT P,
		STOCKS AS S,
		GET_STOCK_BARCODES AS GSB,
		PRICE_STANDART AS PS,
		PRODUCT_UNIT AS PU
	WHERE
		GSB.BARCODE IN (#listqualify(barcod_list,"'")#) AND
		PS.PURCHASESALES = 0 AND
		PS.PRICESTANDART_STATUS = 1 AND
		PU.IS_MAIN = 1 AND
		P.PRODUCT_ID = S.PRODUCT_ID AND
		S.STOCK_ID = GSB.STOCK_ID AND
		PS.PRODUCT_ID = P.PRODUCT_ID AND
		PS.UNIT_ID = PU.PRODUCT_UNIT_ID AND
		PU.PRODUCT_ID = P.PRODUCT_ID
</cfquery>

<table width="98%" cellpadding="0" cellspacing="0" border="0" align="center">
	<tr>
		<td width="100%" height="35" class="headbold">PHL Dökümanı İçeriği</td>
		<!-- sil -->
		<td width="100" style="text-align:right;">&nbsp;</td>
		<cf_workcube_file_action pdf='0' mail='0' doc='1' print='1'>
		<!-- sil -->
	</tr>
</table>
<table width="98%" align="center" cellpadding="0" cellspacing="0" border="0">
<form action="<cfoutput>#request.self#?fuseaction=store.emptypopup_write_document</cfoutput>" method="post" name="add_ship_file" id="add_ship_file">
<input type="hidden" name="file_path_and_name" id="file_path_and_name" value="<cfoutput>#dosya_yolu#</cfoutput>">
<input type="hidden" name="file_name" id="file_name" value="<cfoutput>#file_name#</cfoutput>">
<input type="hidden" name="location_in" id="location_in" value="<cfoutput>#attributes.location_in#</cfoutput>">
<input type="hidden" name="department_in" id="department_in" value="<cfoutput>#attributes.department_in#</cfoutput>">
<input type="hidden" name="branch_id" id="branch_id" value="<cfoutput>#attributes.branch_id#</cfoutput>">
<input type="hidden" name="line_count" id="line_count" value="<cfoutput>#line_count#</cfoutput>">
<input type="hidden" name="description" id="description" value="<cfoutput>#attributes.description#</cfoutput>">
  <tr class="color-border">
	<td>
	  <table width="100%" cellpadding="2" cellspacing="1">
		<tr class="color-header" height="22">
			<td class="form-title" width="70"><cf_get_lang_main no='221.Barkod'></td>
			<td class="form-title"><cf_get_lang_main no='106.Stok Kodu'></td>
			<td class="form-title"><cf_get_lang_main no='245.Ürün'></td>
			<td class="form-title"><cf_get_lang_main no='222.Üretici Kodu'></td>			
			<td class="form-title"><cf_get_lang_main no='223.Miktar'></td>
			<td class="form-title" style="text-align:right;">Toplam Maliyet</td>						
		</tr>
		<cftry>
		<cfset net_total = 0>
		<cfloop from="1" to="#line_count#" index="k">
			<cfset temp_barcod = trim(ListGetAt(dosya[k],1,"#document_seperator#"))>
				<cfquery name="get_product_main" dbtype="query">
					SELECT
						BARCODE,
						STOCK_ID,
						PRODUCT_ID,
						STOCK_CODE,
						PROPERTY,					
						PRODUCT_NAME,
						MANUFACT_CODE,
						PRICE,
						MONEY,
						MAIN_UNIT
					FROM
						get_product_main_all
					WHERE
						BARCODE = '#temp_barcod#'
				</cfquery>
			<cfif get_product_main.recordcount>
					<cfoutput query="get_product_main">
					<cfif MAIN_UNIT is "Kg">
						<cfset satir_toplam = (trim(ListGetAt(dosya[k],2,"#document_seperator#")) * price) / 1000>
					<cfelse>
						<cfset satir_toplam = trim(ListGetAt(dosya[k],2,"#document_seperator#")) * price>
					</cfif>
					<input type="hidden" name="barcode_#k#" id="barcode_#k#" value="#ListGetAt(dosya[k],1,"#document_seperator#")#">
					<tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
					  <td>#BARCODE#</td>
					  <td>#STOCK_CODE#</td>
					  <td>#PRODUCT_NAME# #PROPERTY#</td>
					  <td>#MANUFACT_CODE#</td>
					  <td><input type="text" name="miktar_#k#" id="miktar_#k#" maxlength="10" style="width:50;" value="#ListGetAt(dosya[k],2,"#document_seperator#")+0#"></td>
					  <td style="text-align:right;">#TLFormat(satir_toplam)# #money#</td>
					</tr>
						<!--- wrk_not düzelmeli: 20050705 gelen money sistem dövizi cinsinden degilse sorun olur,
								bu yüzden session.ep.money e esit olmayanlar cevrilerek yazilmali --->
						<cfif money neq session.ep.money>
							<cfquery name="get_money_rate" datasource="#dsn#" maxrows="1">
								SELECT
									RATE2
								FROM
									SETUP_MONEY
								WHERE
									COMPANY_ID =#session.ep.company_id# AND
									PERIOD_ID = #session.ep.period_id# AND
									MONEY_STATUS = 1 AND
									MONEY='#money#'
								ORDER BY
									MONEY_ID DESC
							</cfquery>
							<cfif get_money_rate.recordcount>
								<cfset satir_toplam=satir_toplam*get_money_rate.rate2>
							</cfif>
						<!--- kod yazilacak --->
						</cfif>
						<cfset net_total = net_total + satir_toplam>
				</cfoutput>
			</cfif>
		</cfloop>
		<cfoutput>
			<tr class="color-header" height="22">
				<td colspan="5" class="form-title" style="text-align:right;">Toplam Maliyet</td>
				<td style="text-align:right;">#TLFormat(net_total)# #session.ep.money#</td>
			</tr>
		</cfoutput>
		<cfcatch>!!! DOSYA OKUMADA HATA VAR !!!</cfcatch>
	</cftry>
	  </table>
	</td>
  </tr>
  <tr>
   <td height="50" valign="middle" style="text-align:right;"><input type="button" value="Kaydet" onClick="kaydet_control();"></td>
  </tr>
</form>
</table>
<script language="JavaScript" type="text/javascript">
function kaydet_control(){
	document.add_ship_file.submit();
}
</script>
