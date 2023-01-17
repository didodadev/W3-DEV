<!--- yevmiye defterini pdf olarak almak icin --->
<!--- yeni muhasebe standartlarına uygun olması için düzenlemeler yapıldı, 'detaylı' seçeneği işaretlendiğinde ek parametrelerde display ediliyor OZDEN20060928--->
<cfparam name="attributes.module_id_control" default="22">
<cfinclude template="report_authority_control.cfm">
<cf_xml_page_edit fuseact ="report.rapor_yevmiye">
<cfparam name="attributes.date1" default="">
<cfparam name="attributes.date2" default="">
<cfparam name="attributes.acc_card_type" default="">
<cfparam name="attributes.row_number" default="60">
<cfparam name="attributes.acc_code_type" default="0">
<cfparam name="attributes.pagetype" default="a4;29;21">
<cfparam name="attributes.character_account_code" default="20">
<cfparam name="attributes.character_detail" default="30">
<cfparam name="attributes.pdf_row_count" default="5000">
<cfset page_count_ = 65000>
<cfif not (isdefined('attributes.date1') and isdate(attributes.date1) and isdefined('attributes.date2') and isdate(attributes.date2))>
	<cfset attributes.date1 = dateformat(session.ep.period_start_date,dateformat_style)>
    <cfset attributes.date2 = dateformat(session.ep.period_finish_date,dateformat_style)>
</cfif>
<cfif isdate(attributes.date1) and isdate(attributes.date2)>
	<cf_date tarih = "attributes.date1">
    <cfset attributes.date1 = dateformat(attributes.date1,dateformat_style)>
	<cf_date tarih = "attributes.date2">
    <cfset attributes.date2 = dateformat(attributes.date2,dateformat_style)>
</cfif>
<cfform name="search__" action="" method="post">
<input type="hidden" name="is_submitted" id="is_submitted" value="0">
<cfsavecontent  variable="head"><cf_get_lang dictionary_id='39033.Yevmiye Raporu'></cfsavecontent>
<cf_report_list_search title="#head#">
	<cf_report_list_search_area>		
        <div class="row">
            <div class="col col-12 col-xs-12">
                <div class="row formContent">
                    <div class="row" type="row">
                        <div class="col col-5 col-md-4 col-sm-6 col-xs-12">
                            <div class="form-group col col-6 col-md-6 col-sm-6 col-xs-12">
                                <label><cf_get_lang dictionary_id='58053.Başlangıç Tarihi'>*</label>
                                <div class="input-group">
                                    <cfsavecontent variable="message1"><cf_get_lang dictionary_id="58194.Zorunlu Alan"> : <cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></cfsavecontent>
                                    <cfinput value="#attributes.date1#" required="Yes" message="#message1#" type="text" name="date1" validate="#validate_style#" maxlength="10">
                                    <span class="input-group-addon"><cf_wrk_date_image date_field="date1"></span>
                                </div>
                            </div>
                            <div class="form-group col col-6 col-md-6 col-sm-6 col-xs-12">
                                <label><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></label>
                                <div class="input-group">
                                    <cfsavecontent variable="message2"><cf_get_lang dictionary_id="58194.Zorunlu Alan"> : <cf_get_lang dictionary_id='57700.Bitiş Tarihi'></cfsavecontent>
                                    <cfinput value="#attributes.date2#" required="Yes" message="#message2#" type="text" name="date2" validate="#validate_style#" maxlength="10">
                                    <span class="input-group-addon"><cf_wrk_date_image date_field="date2"></span>
                                </div>
                            </div>
                            <div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12">
                                <label><cf_get_lang dictionary_id='38857.Hesap Türü'></label>
                                <select name="acc_code_type" id="acc_code_type">
                                    <option value="0" <cfif attributes.acc_code_type eq 0>selected</cfif>><cf_get_lang dictionary_id='58793.Tek Düzen'></option>
                                    <option value="1" <cfif attributes.acc_code_type eq 1>selected</cfif>><cf_get_lang dictionary_id='58308.UFRS'></option>
                                </select>
                            </div>
                            <div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12">
                                <label><cf_get_lang dictionary_id='57800.İşlem Tipi'></label>
                                <cfquery name="get_acc_card_type" datasource="#dsn3#">
                                    SELECT PROCESS_TYPE,PROCESS_CAT_ID,PROCESS_CAT FROM SETUP_PROCESS_CAT WHERE PROCESS_TYPE IN (10,11,12,13,14,19) ORDER BY PROCESS_TYPE
                                </cfquery>
                                <select multiple name="acc_card_type" id="acc_card_type">
                                    <cfoutput query="get_acc_card_type" group="process_type">
                                        <cfoutput>
                                        <option value="#process_type#-#process_cat_id#" <cfif listfind(attributes.acc_card_type,'#process_type#-#process_cat_id#',',')>selected</cfif>>#process_cat#</option>
                                        </cfoutput>
                                    </cfoutput>
                                </select>
                            </div>
                            <div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12">
                                <label><cf_get_lang dictionary_id='58960.Rapor Tipi'></label>
                                <select name="yevmiye_report_type" id="yevmiye_report_type">
                                    <option value="1" <cfif isdefined("attributes.yevmiye_report_type") and attributes.yevmiye_report_type is '1'>selected</cfif>><cf_get_lang dictionary_id ='39904.Standart Döküm'></option>							
                                    <option value="9" <cfif isdefined("attributes.yevmiye_report_type") and attributes.yevmiye_report_type is '9'>selected</cfif>><cf_get_lang dictionary_id ='39904.Standart Döküm'> <cf_get_lang dictionary_id ='29731.Excel'></option>
                                    <option value="8" <cfif isdefined("attributes.yevmiye_report_type") and attributes.yevmiye_report_type is '8'>selected</cfif>><cf_get_lang dictionary_id ='39904.Standart Döküm'> <cf_get_lang dictionary_id ='29733.PDF'></option>	
                                    <option value="16" <cfif isdefined("attributes.yevmiye_report_type") and attributes.yevmiye_report_type is '16'>selected</cfif>><cf_get_lang dictionary_id ='39031.Standart Döküm Fis Toplamli PDF'></option>                        								
                                    <option value="10" <cfif isdefined("attributes.yevmiye_report_type") and attributes.yevmiye_report_type is '10'>selected</cfif>><cf_get_lang dictionary_id ='58953.Üst Hesaplı'> <cf_get_lang dictionary_id ='39904.Standart Döküm'> <cf_get_lang dictionary_id ='29731.Excel'></option>
                                    <option value="6" <cfif isdefined("attributes.yevmiye_report_type") and attributes.yevmiye_report_type is '6'>selected</cfif>><cf_get_lang dictionary_id ='58953.Üst Hesaplı'> <cf_get_lang dictionary_id ='39904.Standart Döküm'> <cf_get_lang dictionary_id ='29733.PDF'></option>									
                                    <option value="11" <cfif isdefined("attributes.yevmiye_report_type") and attributes.yevmiye_report_type is '11'>selected</cfif>><cf_get_lang dictionary_id ='58953.Üst Hesaplı'> <cf_get_lang dictionary_id ='58032.Çoklu'> <cf_get_lang dictionary_id ='29731.Excel'></option>
                                    <option value="2" <cfif isdefined("attributes.yevmiye_report_type") and attributes.yevmiye_report_type is '2'>selected</cfif>><cf_get_lang dictionary_id ='39905.Üst Hesaplı Çoklu Pdf'></option>
                                    <option value="12" <cfif isdefined("attributes.yevmiye_report_type") and attributes.yevmiye_report_type is '12'>selected</cfif>><cf_get_lang dictionary_id ='59200.Devreden Bakiyeli'> <cf_get_lang dictionary_id ='58032.Çoklu'> <cf_get_lang dictionary_id ='29731.Excel'></option>
                                    <option value="3" <cfif isdefined("attributes.yevmiye_report_type") and attributes.yevmiye_report_type is '3'>selected</cfif>><cf_get_lang dictionary_id ='39906.Devreden Bakiyeli Çoklu Pdf'></option>
                                    <option value="13" <cfif isdefined("attributes.yevmiye_report_type") and attributes.yevmiye_report_type is '13'>selected</cfif>><cf_get_lang dictionary_id ='39907.Hesap Bazında Gruplamalı'> <cf_get_lang dictionary_id ='29731.Excel'></option>
                                    <option value="4" <cfif isdefined("attributes.yevmiye_report_type") and attributes.yevmiye_report_type is '4'>selected</cfif>><cf_get_lang dictionary_id ='39907.Hesap Bazında Gruplamalı'> <cf_get_lang dictionary_id ='29733.PDF'></option>								
                                    <option value="14" <cfif isdefined("attributes.yevmiye_report_type") and attributes.yevmiye_report_type is '14'>selected</cfif>><cf_get_lang dictionary_id ='39908.Üst Hesap Bazında Gruplamalı'> <cf_get_lang dictionary_id ='29731.Excel'></option>
                                    <option value="5" <cfif isdefined("attributes.yevmiye_report_type") and attributes.yevmiye_report_type is '5'>selected</cfif>><cf_get_lang dictionary_id ='39908.Üst Hesap Bazında Gruplamalı'> <cf_get_lang dictionary_id ='29733.PDF'></option>								
                                    <option value="15" <cfif isdefined("attributes.yevmiye_report_type") and attributes.yevmiye_report_type is '15'>selected</cfif>><cf_get_lang dictionary_id ='39373.Yevmiye No'><cf_get_lang dictionary_id='58601.Bazında'> <cf_get_lang dictionary_id ='29731.Excel'></option>			
                                    <option value="7" <cfif isdefined("attributes.yevmiye_report_type") and attributes.yevmiye_report_type is '7'>selected</cfif>><cf_get_lang dictionary_id ='39373.Yevmiye No'><cf_get_lang dictionary_id='58601.Bazında'> <cf_get_lang dictionary_id ='29733.PDF'></option>																					
                                </select>
                            </div>
                            <div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12">
                                <label><cf_get_lang dictionary_id='39145.Sayfa Yapısı'></label>
                                <select name="pagetype" id="pagetype" style="width:180px;">
                                    <option value="a4;29;21"<cfif isdefined("attributes.pagetype") and attributes.pagetype is 'a4;29;21'>selected</cfif>>A4 (297-210 mm)</option>
                                    <option value="letter;27.94;21.59"<cfif isdefined("attributes.pagetype") and attributes.pagetype is 'letter;27.94;21.59'>selected</cfif>>Letter (279.4-215.9 mm)</option>
                                    <option value="custom;42;29.7"<cfif isdefined("attributes.pagetype") and attributes.pagetype is 'custom;42;29.7'>selected</cfif>>A3 (297-420 mm)</option>
                                </select>
                            </div>
                            <div class="form-group col col-6 col-md-6 col-sm-6 col-xs-12">
                                <label><cf_get_lang dictionary_id='39022.Satır Fontu'></label>
                                <select name="fontfamily" id="fontfamily">
                                    <option value="Arial" <cfif isdefined("attributes.fontfamily") and attributes.fontfamily is 'Arial'>selected</cfif>>Arial</option>
                                    <option value="Verdana" <cfif isdefined("attributes.fontfamily") and attributes.fontfamily is 'Verdana'>selected</cfif>>Verdana</option>
                                    <option value="Geneva" <cfif isdefined("attributes.fontfamily") and attributes.fontfamily is 'Geneva'>selected</cfif>>Geneva</option>
                                    <option value="Times New Roman" <cfif isdefined("attributes.fontfamily") and attributes.fontfamily is 'Times New Roman'>selected</cfif>>Times New Roman</option>
                                    <option value="Courier New" <cfif isdefined("attributes.fontfamily") and attributes.fontfamily is 'Courier New'>selected</cfif>>Courier New</option>
                                    <option value="Georgia" <cfif isdefined("attributes.fontfamily") and attributes.fontfamily is 'Georgia'>selected</cfif>>Georgia</option>
                                    <option value="Tahoma" <cfif isdefined("attributes.fontfamily") and attributes.fontfamily is 'Tahoma'>selected</cfif>>Tahoma</option>
                                </select>
                            </div>
                            <div class="form-group col col-6 col-md-6 col-sm-6 col-xs-12">
                                <label><cf_get_lang dictionary_id='39050.Başlık Fontu'></label>
                                <select name="bigfontfamily" id="bigfontfamily">
                                    <option value="Arial" <cfif isdefined("attributes.bigfontfamily") and attributes.bigfontfamily is 'Arial'>selected</cfif>>Arial</option>
                                    <option value="Verdana" <cfif isdefined("attributes.bigfontfamily") and attributes.bigfontfamily is 'Verdana'>selected</cfif>>Verdana</option>
                                    <option value="Geneva" <cfif isdefined("attributes.bigfontfamily") and attributes.bigfontfamily is 'Geneva'>selected</cfif>>Geneva</option>
                                    <option value="Times New Roman" <cfif isdefined("attributes.bigfontfamily") and attributes.bigfontfamily is 'Times New Roman'>selected</cfif>>Times New Roman</option>
                                    <option value="Courier New" <cfif isdefined("attributes.bigfontfamily") and attributes.bigfontfamily is 'Courier New'>selected</cfif>>Courier New</option>
                                    <option value="Georgia" <cfif isdefined("attributes.bigfontfamily") and attributes.bigfontfamily is 'Georgia'>selected</cfif>>Georgia</option>
                                    <option value="Tahoma" <cfif isdefined("attributes.bigfontfamily") and attributes.bigfontfamily is 'Tahoma'>selected</cfif>>Tahoma</option>
                                </select>
                            </div>
                            <div class="form-group col col-6 col-md-6 col-sm-6 col-xs-12">
                                <label><cf_get_lang dictionary_id='60798.Satır Font Ölçüsü'></label>
                                <select name="fontsize" id="fontsize" style="width:90px;">
                                    <option value="10" <cfif isdefined ("attributes.fontsize") and attributes.fontsize is '10'>selected</cfif>>10 px</option>								
                                    <option value="5" <cfif isdefined ("attributes.fontsize") and attributes.fontsize is '5'>selected</cfif>>5 px</option>
                                    <option value="6" <cfif isdefined ("attributes.fontsize") and attributes.fontsize is '6'>selected</cfif>>6 px</option>
                                    <option value="7" <cfif isdefined ("attributes.fontsize") and attributes.fontsize is '7'>selected</cfif>>7 px</option>
                                    <option value="8" <cfif isdefined ("attributes.fontsize") and attributes.fontsize is '8'>selected</cfif>>8 px</option>
                                    <option value="9" <cfif isdefined ("attributes.fontsize") and attributes.fontsize is '9'>selected</cfif>>9 px</option>
                                    <option value="11" <cfif isdefined ("attributes.fontsize") and attributes.fontsize is '11'>selected</cfif>>11 px</option>
                                    <option value="12" <cfif isdefined ("attributes.fontsize") and attributes.fontsize is '12'>selected</cfif>>12 px</option>
                                    <option value="13" <cfif isdefined ("attributes.fontsize") and attributes.fontsize is '13'>selected</cfif>>13 px</option>
                                </select>
                            </div>
                            <div class="form-group col col-6 col-md-6 col-sm-6 col-xs-12">
                                <label><cf_get_lang dictionary_id='58820.Başlık'> <cf_get_lang dictionary_id='58952.Font Ölçüsü'></label>
                                <select name="bigfontsize" id="bigfontsize" style="width:90px;">
                                    <option value="12" <cfif isdefined ("attributes.bigfontsize") and attributes.bigfontsize is '12'>selected</cfif>>12 px</option>
                                    <option value="5" <cfif isdefined ("attributes.bigfontsize") and attributes.bigfontsize is '5'>selected</cfif>>5 px</option>
                                    <option value="6" <cfif isdefined ("attributes.bigfontsize") and attributes.bigfontsize is '6'>selected</cfif>>6 px</option>
                                    <option value="7" <cfif isdefined ("attributes.bigfontsize") and attributes.bigfontsize is '7'>selected</cfif>>7 px</option>
                                    <option value="8" <cfif isdefined ("attributes.bigfontsize") and attributes.bigfontsize is '8'>selected</cfif>>8 px</option>
                                    <option value="9" <cfif isdefined ("attributes.bigfontsize") and attributes.bigfontsize is '9'>selected</cfif>>9 px</option>
                                    <option value="10" <cfif isdefined ("attributes.bigfontsize") and attributes.bigfontsize is '10'>selected</cfif>>10 px</option>
                                    <option value="11" <cfif isdefined ("attributes.bigfontsize") and attributes.bigfontsize is '11'>selected</cfif>>11 px</option>
                                    <option value="13" <cfif isdefined ("attributes.bigfontsize") and attributes.bigfontsize is '13'>selected</cfif>>13 px</option>
                                    <option value="14" <cfif isdefined ("attributes.bigfontsize") and attributes.bigfontsize is '14'>selected</cfif>>14 px</option>
                                    <option value="15" <cfif isdefined ("attributes.bigfontsize") and attributes.bigfontsize is '15'>selected</cfif>>15 px</option>
                                    <option value="16" <cfif isdefined ("attributes.bigfontsize") and attributes.bigfontsize is '16'>selected</cfif>>16 px</option>
                                    <option value="17" <cfif isdefined ("attributes.bigfontsize") and attributes.bigfontsize is '17'>selected</cfif>>17 px</option>
                                    <option value="18" <cfif isdefined ("attributes.bigfontsize") and attributes.bigfontsize is '18'>selected</cfif>>18 px</option>
                                </select>
                            </div>
                            <div class="form-group col col-6 col-md-6 col-sm-6 col-xs-12">
                                <label><cf_get_lang dictionary_id='38890.Hesap Adı'></label>
                                <cfinput type="text" name="character_account_code" id="character_account_code" range="1,100" value="#attributes.character_account_code#" style="width:30px;" message="#getLang('','Hesap Adı alanına en fazla 50 karakter girebilirsiniz',60794)#"/>
                            </div>
                            <div class="form-group col col-6 col-md-6 col-sm-6 col-xs-12">
                                <label><cf_get_lang dictionary_id='57629.Açıklama'></label>
                                <cfinput type="text" name="character_detail" id="character_detail" range="1,150" value="#attributes.character_detail#" style="width:30px;" message="#getLang('','En Fazla 100 Karakter Giriniz',29509)#"/>
                            </div>
                            <div class="form-group col col-6 col-md-6 col-sm-6 col-xs-12">
                                <label><cf_get_lang dictionary_id ='39444.Satır Sayısı'></label>
                                <cfinput type="text" name="row_number" value="#attributes.row_number#" onKeyUp="return(FormatCurrency(this,event));" style="width:30px;" validate="integer">
                            </div>
                            <div class="form-group col col-6 col-md-6 col-sm-6 col-xs-12">
                                <label><cf_get_lang dictionary_id='59205.Sayfa(PDF) Kırılım Sayısı'></label>
                                <cfinput type="text" name="pdf_row_count" value="#attributes.pdf_row_count#" style="width:30px;" validate="integer">
                            </div>
                            <div class="form-group col col-2 col-md-2 col-sm-6 col-xs-12">
                                <label>
                                    <cf_get_lang dictionary_id='57771.Detay'>
                                    <input type="checkbox" name="is_detail" id="is_detail" value="1" <cfif isdefined("attributes.is_detail")>checked</cfif>>
                                </label>
                            </div>
                        </div>
                        <div class="col col-5 col-md-4 col-sm-6 col-xs-12">
                            <div class="form-group">
                                <label class="col col-12 col-xs-12"></label>
                                <div class="col col-12 col-xs-12">
                                    <cftry>
                                        <cfinclude template="#file_web_path#templates/import_example/yevmiyedefteri_#session.ep.language#.html">
                                        <cfcatch>
                                            <script type="text/javascript">
                                                alert("<cf_get_lang dictionary_id='29760.Yardım Dosyası Bulunamadı Lutfen Kontrol Ediniz'>");
                                            </script>
                                        </cfcatch>
                                    </cftry>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="row ReportContentBorder">
                    <div class="ReportContentFooter">
                        <cfsavecontent  variable="ozet_bılgı"><cf_get_lang dictionary_id='51552.Özet Bilgi'></cfsavecontent>
                        <cfsavecontent  variable="olustur"><cf_get_lang dictionary_id='58966.Oluştur'></cfsavecontent>
                        <cf_wrk_report_search_button button_name='#ozet_bılgı#' button_type='2' is_excel="0" search_function='kontrol()'>
                        <cf_wrk_report_search_button search_function='kontrol2()' button_name='#olustur#' is_excel="0" button_type='2'>
                    </div>
                </div>
            </div>
        </div>
    </cf_report_list_search_area>
</cf_report_list_search> 
</cfform>
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
<cfset pdf_row_count =attributes.pdf_row_count><!---8000 pdf sayısını belirler --->
<cfset file_name_list = ''>
<cfif isdefined('attributes.row_number') and attributes.row_number gt 0>
	<cfset pdf_page_row = attributes.row_number>
<cfelse>
	<cfset pdf_page_row =55>
</cfif>
<cfif isdefined('attributes.yevmiye_report_type') and attributes.yevmiye_report_type eq 1>
	<cfinclude template="rapor_yevmiye_standart.cfm">
<cfelseif isdefined('attributes.yevmiye_report_type') and attributes.yevmiye_report_type eq 9>
	<cfinclude template="rapor_yevmiye_standart_excel.cfm">
<cfelseif isdefined('attributes.yevmiye_report_type') and attributes.yevmiye_report_type eq 8>
	<cfinclude template="rapor_yevmiye_standart_pdf.cfm">	
<cfelseif isdefined('attributes.yevmiye_report_type') and attributes.yevmiye_report_type eq 16>
	<cfinclude template="rapor_yevmiye_standart_fis_bazinda_pdf.cfm">    
<cfelseif isdefined('attributes.yevmiye_report_type') and attributes.yevmiye_report_type eq 10>
	<cfinclude template="rapor_yevmiye_ust_hesapli_standart_excel.cfm">
<cfelseif isdefined('attributes.yevmiye_report_type') and attributes.yevmiye_report_type eq 6>
	<cfinclude template="rapor_yevmiye_ust_hesapli_standart_pdf.cfm">	
<cfelseif isdefined('attributes.yevmiye_report_type') and attributes.yevmiye_report_type eq 11>
	<cfinclude template="rapor_yevmiye_ust_hesapli_multi_excel.cfm">
<cfelseif isdefined('attributes.yevmiye_report_type') and attributes.yevmiye_report_type eq 2>
	<cfinclude template="rapor_yevmiye_ust_hesapli_multi_pdf.cfm">	
<cfelseif isdefined('attributes.yevmiye_report_type') and attributes.yevmiye_report_type eq 12>
	<cfinclude template="rapor_yevmiye_devreden_bakiyeli_multi_excel.cfm">	
<cfelseif isdefined('attributes.yevmiye_report_type') and attributes.yevmiye_report_type eq 3>
	<cfinclude template="rapor_yevmiye_devreden_bakiyeli_multi_pdf.cfm">
<cfelseif isdefined('attributes.yevmiye_report_type') and attributes.yevmiye_report_type eq 4>
	<cfinclude template="rapor_yevmiye_hesap_bazinda_gruplamali.cfm">
<cfelseif isdefined('attributes.yevmiye_report_type') and attributes.yevmiye_report_type eq 13>
	<cfinclude template="rapor_yevmiye_hesap_bazinda_gruplamali_excel.cfm">	
<cfelseif isdefined('attributes.yevmiye_report_type') and attributes.yevmiye_report_type eq 14>
	<cfinclude template="rapor_yevmiye_ust_hesap_bazinda_gruplamali_excel.cfm">	
<cfelseif isdefined('attributes.yevmiye_report_type') and attributes.yevmiye_report_type eq 5>
	<cfinclude template="rapor_yevmiye_ust_hesap_bazinda_gruplamali.cfm">
<cfelseif isdefined('attributes.yevmiye_report_type') and attributes.yevmiye_report_type eq 15>
	<cfinclude template="rapor_yevmiye_no_bazinda_excel.cfm">	
<cfelseif isdefined('attributes.yevmiye_report_type') and attributes.yevmiye_report_type eq 7>
	<cfinclude template="rapor_yevmiye_no_bazinda_pdf.cfm">
</cfif>
<script type="text/javascript">
function kontrol()
{
     if ((document.search__.date1.value != '') && (document.search__.date2.value != '') &&
    !date_check(search__.date1,search__.date2,"<cf_get_lang dictionary_id ='39814.Başlangıç Tarihi Bitiş Tarihinden Küçük Olmalıdır'>!"))
        return false;
	if(document.search__.yevmiye_report_type.value == 1)
	{
		alert("<cf_get_lang dictionary_id ='39912.Standart Dökümde Yevmiye Defteri Oluşturulmamaktadır'>!");
		return false;
	}
	if(document.search__.yevmiye_report_type.value == 15 || document.search__.yevmiye_report_type.value == 14  || document.search__.yevmiye_report_type.value == 13 || document.search__.yevmiye_report_type.value == 12 || document.search__.yevmiye_report_type.value == 11 || document.search__.yevmiye_report_type.value == 10 || document.search__.yevmiye_report_type.value == 9)
	{
		alert("<cf_get_lang dictionary_id='60801.Özet Bilgi yalnızca PDF formatında alınabilir'>!");
		return false;
	}
	if(document.search__.row_number.value == '')
	{
		alert("<cf_get_lang dictionary_id ='39913.Satır Sayısı Girmelisiniz'>!");
		return false;
	}
	windowopen('','small','report_window');
	search__.action='<cfoutput>#request.self#?fuseaction=report.popup_rapor_yevmiye_pdf_info</cfoutput>';
	search__.target='report_window';
	search__.submit();
}
function kontrol2()
{
    
	search__.target='';
	search__.action='';
	if(document.search__.row_number.value == '')
	{
		alert("<cf_get_lang dictionary_id ='39913.Satır Sayısı Girmelisiniz'>!");
		return false;
	}
    if ((document.search__.date1.value != '') && (document.search__.date2.value != '') &&
    !date_check(search__.date1,search__.date2,"<cf_get_lang dictionary_id ='39814.Başlangıç Tarihi Bitiş Tarihinden Küçük Olmalıdır'>!"))
        return false;
    /* if (document.getElementById('yevmiye_report_type').value == 9){
        document.search__.action="<cfoutput>#request.self#?fuseaction=report.emptypopup_rapor_yevmiye</cfoutput>"; } */
    
}
</script>
