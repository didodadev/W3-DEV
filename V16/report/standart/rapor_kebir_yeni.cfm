<!--- defteri kebiri pdf olarak almak icin --->
<cfparam name="attributes.acc_code_type" default="0">
<cfparam name="attributes.pagetype" default="a4;29;21">
<cfif not isdefined("is_submitted")>
	<cfparam name="attributes.acc_card_type" default="">
	<cfparam name="attributes.code1" default="">
	<cfparam name="attributes.code2" default="">
	<cfif isdefined("attributes.date1") and isdate(attributes.date1)>
		<cf_date tarih="attributes.date1">
		<cfset attributes.date1 = dateformat(attributes.date1,dateformat_style)>
	<cfelse>
		<cfset attributes.date1 = "01/#month(now())#/#session.ep.period_year#">
	</cfif>
	<cfif isdefined("attributes.date2") and isdate(attributes.date2)>
		<cf_date tarih="attributes.date2">
		<cfset attributes.date2 = dateformat(attributes.date2,dateformat_style)>
	<cfelse>
		<cfset attributes.date2 = "#daysinmonth(now())#/#month(now())#/#session.ep.period_year#">
	</cfif>
	<table border="0" cellspacing="0" cellpadding="0" width="98%" align="center">
		<tr>
			<td class="headbold" height="35"><a href="javascript:gizle_goster(search);">&raquo;<cf_get_lang dictionary_id='39163.Defter-i Kebir'> (<cf_get_lang dictionary_id='39164.Hesap Seçimli'>)</a></td>
		</tr>
		<tr class="color-border" id="search">
			<td colspan="2">
			<table border="0" cellspacing="1" cellpadding="2" width="100%">
				<tr class="color-row">
					<td valign="top">
					<table>
					<cfform name="list_kebir" method="post" action="index.cfm?fuseaction=#attributes.fuseaction#&">
					<input type="hidden" name="is_submitted" id="is_submitted" value="0">
						<tr>
							<td colspan="2"></td>
						</tr>
						<tr>
							<td class="txtbold" width="100"><cf_get_lang dictionary_id='57652.Hesap'>1</td>
							<td>
								<input type="hidden" name="code1" id="code1" value="<cfoutput>#attributes.code1#</cfoutput>">							
								<cfinput message="Hesap Kodu Seçmediniz" type="Text" value="#attributes.code1#" name="name1" id="name1" style="width:95px;" onFocus="AutoComplete_Create('name1','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'1\',0','ACCOUNT_CODE','code1','','3','200');"><!--- onkeyup="get_wrk_acc_code_1();" --->
								<a href="javascript://" onClick="javascript:pencere_ac_kebir('list_kebir.code1','list_kebir.name1','list_kebir.name1');"><img src="/images/plus_thin.gif" border="0" align="absmiddle"></a>
							</td>				
						</tr>
							<td class="txtbold"><cf_get_lang dictionary_id='57652.Hesap'>2</td>
							<td>
								<input type="hidden" name="code2" id="code2" value="<cfoutput>#attributes.code2#</cfoutput>">
								<cfinput message="Hesap Kodu Seçmediniz" type="Text"  value="#attributes.code2#" name="name2" id="name2" style="width:95px;" onFocus="AutoComplete_Create('name2','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'1\',0','ACCOUNT_CODE','code2','','3','200');"><!--- onkeyup="get_wrk_acc_code_2();" --->
								<a href="javascript://" onClick="javascript:pencere_ac_kebir('list_kebir.code2','list_kebir.name2','list_kebir.name2');"><img src="/images/plus_thin.gif" border="0" align="absmiddle"></a>
							</td>		
						</tr>
						<tr>
							<td class="txtbold"><!--- <cf_get_lang dictionary_id='1825.Hesap tipi'> ---><cf_get_lang dictionary_id='38857.Hesap Türü'></td>	
							<td><select name="acc_code_type" id="acc_code_type" style="width:105px;">
									<option value="0" <cfif attributes.acc_code_type eq 0>selected</cfif>><cf_get_lang dictionary_id='58793.Tek Düzen'></option>
									<option value="1" <cfif attributes.acc_code_type eq 1>selected</cfif>><cf_get_lang dictionary_id='58308.UFRS'></option>
								</select>
							</td>
						</tr>	
						<tr>
							<td class="txtbold"><cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></td>
							<td><cfsavecontent variable="message"><cf_get_lang dictionary_id='57782.Tarih Değerini Kontrol Ediniz'></cfsavecontent>
								<cfinput value="#attributes.date1#" required="Yes" message="#message#" type="text" name="date1" style="width:85px;" validate="#validate_style#" maxlength="10">
								<cf_wrk_date_image date_field="date1">
							</td>
						</tr>
						<tr>
							<td class="txtbold"><cf_get_lang dictionary_id='57700.Bitiş T'></td>
							<td><cfinput value="#attributes.date2#" required="Yes" message="#message#" type="text" name="date2" style="width:85px;" validate="#validate_style#" maxlength="10">
								<cf_wrk_date_image date_field="date2">
							</td>
						</tr>
						<tr>
							<td class="txtbold" valign="top"><cf_get_lang dictionary_id='57800.İşlem Tipi'></td>
							<td nowrap="nowrap" id="acc_detail_search" valign="top">
								<cfquery name="get_acc_card_type" datasource="#dsn3#">
									SELECT PROCESS_TYPE,PROCESS_CAT_ID,PROCESS_CAT FROM SETUP_PROCESS_CAT WHERE PROCESS_TYPE IN (10,11,12,13,14,19) ORDER BY PROCESS_TYPE
								</cfquery>
								<select multiple="multiple" name="acc_card_type" id="acc_card_type" style="width:188px;height:60px;">
									<cfoutput query="get_acc_card_type" group="process_type">
										<cfoutput>
										<option value="#process_type#-#process_cat_id#" <cfif listfind(attributes.acc_card_type,'#process_type#-#process_cat_id#',',')>selected</cfif>>#process_cat#</option>
										</cfoutput>
									</cfoutput>
								</select>
							</td>
						</tr>
						<tr>
							<td class="txtbold"><cf_get_lang dictionary_id='58960.Rapor Tipi'></td>
							<td><select name="kebir_report_type" id="kebir_report_type" style="width:188px;">
									<option value="1" <cfif isdefined("attributes.kebir_report_type") and attributes.kebir_report_type eq 1>selected</cfif>><cf_get_lang dictionary_id ='39904.Standart Döküm'></option>
									<option value="4" <cfif isdefined("attributes.kebir_report_type") and attributes.kebir_report_type eq 4>selected</cfif>><cf_get_lang dictionary_id ='39915.Standart Döküm Çoklu PDF'></option>
									<option value="2" <cfif isdefined("attributes.kebir_report_type") and attributes.kebir_report_type eq 2>selected</cfif>><cf_get_lang dictionary_id ='39916.Sayfa Toplamlı Döküm'></option>
									<option value="3" <cfif isdefined("attributes.kebir_report_type") and attributes.kebir_report_type eq 3>selected</cfif>><cf_get_lang dictionary_id ='39917.Devreden Bakiyeli Döküm'></option>
									<option value="5" <cfif isdefined("attributes.kebir_report_type") and attributes.kebir_report_type eq 5>selected</cfif>><cf_get_lang dictionary_id ='39918.Devreden Bakiyeli Döküm Çoklu PDF'></option>
									<option value="6" <cfif isdefined("attributes.kebir_report_type") and attributes.kebir_report_type eq 6>selected</cfif>><cf_get_lang dictionary_id='38859.Fiş Türüne Göre Bakiyesiz PDF'></option>
									<option value="7" <cfif isdefined("attributes.kebir_report_type") and attributes.kebir_report_type eq 7>selected</cfif>><cf_get_lang dictionary_id ='40543.Devreden Bakiyeli Satır Çoklu Pdf'></option>
									<option value="8" <cfif isdefined("attributes.kebir_report_type") and attributes.kebir_report_type eq 8>selected</cfif>><cf_get_lang dictionary_id='39907.Hesap Bazında Gruplamalı'> <cf_get_lang dictionary_id='29733.Pdf'></option>
									<option value="9" <cfif isdefined("attributes.kebir_report_type") and attributes.kebir_report_type eq 9>selected</cfif>><cf_get_lang dictionary_id='39908.Üst Hesap Bazında Gruplamalı'> <cf_get_lang dictionary_id='29733.Pdf'></option>
								</select>
							</td>
						</tr>
						<tr>
							<td class="txtbold"><cf_get_lang dictionary_id='39145.Sayfa Yapısı'></td>
							<td><select name="pagetype" id="pagetype" style="width:188px;">
									<option value="a4;29;21">A4 (297-210 mm)</option>
									<option value="letter;27.94;21.59">Letter (27,94-21,59 mm)</option>
								</select>
							</td>
						</tr>
						<tr>
							<td class="txtbold"><cf_get_lang dictionary_id='57685.Font'> - <cf_get_lang dictionary_id='58952.Font Ölçüsü'></td>
							<td><select name="fontfamily" id="fontfamily" style="width:133px;">
									<option value="Verdana, Arial, Helvetica, sans-serif">Verdana</option>
									<option value="Geneva, Arial, Helvetica, sans-serif">Geneva</option>
									<option value="Arial, Helvetica, sans-serif">Arial</option>
									<option value='"Times New Roman", Times, serif'>Times New Roman</option>
									<option value='"Courier New", Courier, monospace' selected>Courier New</option>
									<option value='Georgia, "Times New Roman", Times, serif'>Georgia</option>
									<option value='Tahoma'>Tahoma</option>
								</select>
								<select name="fontsize" id="fontsize" style="width:52px;">
									<option value="5px">5 px.</option>
									<option value="6px">6 px.</option>
									<option value="7px">7 px.</option>
									<option value="8px" selected>8 px.</option>
									<option value="9px">9 px.</option>
									<option value="10px">10 px.</option>
									<option value="11px">11 px.</option>
									<option value="12px">12 px.</option>
									<option value="13px">13 px.</option>
								</select>
							</td>
						</tr>
						<tr>
							<td class="txtbold"><cf_get_lang dictionary_id='39345.Dosya Tipi'></td>
							<td><select name="filetype" id="filetype" style="width:72px;">
									<option value="pdf">PDF</option>
								</select>&nbsp;&nbsp;&nbsp;&nbsp;
								<strong><cf_get_lang dictionary_id ='39444.Satır Sayısı'></strong>&nbsp;
								<!---satır sayısı belirtilmemisse page_break kullanılmaz, pdf otomatik sayfalandırır  --->
								<cfinput type="text" name="pdf_page_row" value="55" onkeyup="return(FormatCurrency(this,event));" style="width:30px;" validate="integer">
							</td>
						</tr>
						<tr>
							<td></td>
							<td><cfsavecontent variable="message"><cf_get_lang dictionary_id='58966.Oluştur'></cfsavecontent>
								<cf_workcube_buttons insert_info='#message#' add_function='kontrol()'>
							</td>
						</tr>					
					</cfform>
					</table>
					</td>
				</tr>
			</table>
			</td>
		</tr>
	</table>
<cfelse>
	<cf_date tarih="attributes.date1">
	<cf_date tarih="attributes.date2">
	<cfscript>
		/**
		 * Create a zip file of a directory or just a file.
		 * @param zipPath  File name of the zip to create. (Required)
		 * @param toZip  Folder or full path to file to add to zip. (Required)
		 * @param relativeFrom  Some or all of the toZip path, from which the entries in the zip file will be relative (Optional)
		 * @return Returns nothing. 
		 * @author Nathan Dintenfass (nathan@changemedia.com) 
		 * @version 1.1, January 19, 2004 
		 */
		function zipFileNew(zipPath,toZip)
		{
			var output = createObject("java","java.io.FileOutputStream").init(zipPath);
			var zipOutput = createObject("java","java.util.zip.ZipOutputStream").init(output);
			var byteArray = repeatString(" ",1024).getBytes();
			var input = "";
			var zipEntry = "";
			var zipEntryPath = "";
			var len = 0;
			var ii = 1;
			var fileArray = arrayNew(1);
			var directoriesToTraverse = arrayNew(1);
			var directoryContents = "";
			var fileObject = createObject("java","java.io.File").init(toZip);
			var relativeFrom = "";
			if(structCount(arguments) GT 2){
				relativeFrom = arguments[3];
			}
			if(fileObject.isDirectory())
				arrayAppend(directoriesToTraverse,fileObject);
			else
				arrayAppend(fileArray,fileObject);
			while(arrayLen(directoriesToTraverse)){
				directoryContents = directoriesToTraverse[1].listFiles();
				for(ii = 1; ii LTE arrayLen(directoryContents); ii = ii + 1){
					if(directoryContents[ii].isDirectory())
						arrayAppend(directoriesToTraverse,directoryContents[ii]);
					else
						arrayAppend(fileArray,directoryContents[ii]);
				}
				arrayDeleteAt(directoriesToTraverse,1);
			} 
			zipOutput.setLevel(9);
			for(ii = 1; ii LTE arrayLen(fileArray); ii = ii + 1){
				input = createObject("java","java.io.FileInputStream").init(fileArray[ii].getPath());
				zipEntryPath = fileArray[ii].getPath();
				if(len(relativeFrom)){
					zipEntryPath = replace(zipEntryPath,relativeFrom,"");
				} 
				zipEntry = createObject("java","java.util.zip.ZipEntry").init(zipEntryPath);
				zipOutput.putNextEntry(zipEntry);
				len = input.read(byteArray);
				while (len GT 0) {
					zipOutput.write(byteArray, 0, len);
					len = input.read(byteArray);
				}
				zipOutput.closeEntry();
				input.close();
			}
			zipOutput.close();
			return "";
		}
	</cfscript>
	<cfset pdf_row_count = 1000><!---8000 pdf sayısını belirler --->
	<cfset file_name_list = ''>
	<cfif isdefined('attributes.kebir_report_type') and attributes.kebir_report_type eq 1>
		<cfinclude template="rapor_kebir_standart.cfm">
	<cfelseif isdefined('attributes.kebir_report_type') and attributes.kebir_report_type eq 2>
		<cfinclude template="rapor_kebir_sayfa_toplamli.cfm">
	<cfelseif isdefined('attributes.kebir_report_type') and attributes.kebir_report_type eq 3>
		<cfinclude template="rapor_kebir_devreden_bakiyeli.cfm">
	<cfelseif isdefined('attributes.kebir_report_type') and attributes.kebir_report_type eq 4>
		<cfinclude template="rapor_kebir_standart_multi_pdf.cfm">
	<cfelseif isdefined('attributes.kebir_report_type') and attributes.kebir_report_type eq 5>
		<cfinclude template="rapor_kebir_devreden_bakiyeli_multi_pdf.cfm">
	<cfelseif isdefined('attributes.kebir_report_type') and attributes.kebir_report_type eq 6>
		<cfinclude template="rapor_kebir_fis_turune_gore_bakiyesiz.cfm">
	<cfelseif isdefined('attributes.kebir_report_type') and attributes.kebir_report_type eq 7>
		<cfinclude template="rapor_kebir_bakiyeli_satir_aciklamali_multi_pdf.cfm">
	<cfelseif isdefined('attributes.kebir_report_type') and attributes.kebir_report_type eq 8>
		<cfinclude template="rapor_kebir_hesap_bazinda_gruplamali_pdf.cfm">
	<cfelseif isdefined('attributes.kebir_report_type') and attributes.kebir_report_type eq 9>
		<cfinclude template="rapor_kebir_ust_hesap_bazinda_gruplamali_pdf.cfm">
	</cfif>
</cfif> 
<script type="text/javascript">
	
	function pencere_ac_kebir(str_alan_1,str_alan_2,str_alan)
	{
		var txt_keyword = eval(str_alan + ".value" );
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan_all&field_id='+str_alan_1+'&field_id2='+str_alan_2+'&keyword='+txt_keyword,'list');
	}
	
	function search_kontrol()
	{
		if(list_kebir.date1.value.length){
			if (!global_date_check_value("01/01/<cfoutput>#SESSION.EP.PERIOD_YEAR#</cfoutput>",list_kebir.date1.value, "<cf_get_lang dictionary_id='58053.Başlangıç Tarihi'>"))
				return false;
		}
		
		if(list_kebir.date2.value.length){
			if (!global_date_check_value("01/01/<cfoutput>#SESSION.EP.PERIOD_YEAR#</cfoutput>",list_kebir.date2.value, "<cf_get_lang dictionary_id='57700.Bitiş Tarihi'>"))
				return false;
		}
		return true;
	}
	
	function kontrol()
	{
		if ((document.list_kebir.code1.value=='') || (document.list_kebir.code2.value==''))
			{
				alert("<cf_get_lang dictionary_id='39376.Önce Hesap Kodlarını Seçiniz'>!");
				return false;
		}
		
		if ((document.list_kebir.date1.value=='') || (document.list_kebir.date2.value==''))
		{
			alert("<cf_get_lang dictionary_id='39377.Önce Tarihleri Seçiniz'>!");
			return false;
		}
		else if (!search_kontrol())
			return false;
		
		else
		{
			document.list_kebir.is_submitted.value=1
			return true;
		}
	}
	<cfif isdefined("attributes.is_submitted") and (attributes.is_submitted eq 1) and <!--- attributes.kebir_report_type neq 4 ---> not listFind("4,5,7,8,9",attributes.kebir_report_type)>
		<cfoutput>windowopen('#user_domain#documents/account/fintab/#filename#.pdf','list');</cfoutput>
	</cfif>
</script>

