<!--- defteri kebiri pdf olarak almak icin --->
<cfparam name="attributes.page" default="0">
<cfparam name="attributes.maxrows" default="2000">
<cfset attributes.startrow = (attributes.page-1)*attributes.maxrows+1 >
<cfparam name="attributes.module_id_control" default="22">
<cfinclude template="report_authority_control.cfm">
<cfparam name="attributes.acc_code_type" default="0">
<cfparam name="attributes.pagetype" default="a4;29;21">
<cfparam name="attributes.character_account_code" default="100">
<cfparam name="attributes.character_detail" default="100">
<cfparam name="attributes.pdf_page_row" default="60">
<cfset page_count_ = 65000>
	<cfparam name="attributes.acc_card_type" default="">
	<cfparam name="attributes.code1" default="">
	<cfparam name="attributes.code2" default="">
		<cfif isdefined("attributes.date1") and isdate(attributes.date1)>
			<cf_date tarih="attributes.date1">		
		<cfelse>
			<cfset attributes.date1 = "01/01/#session.ep.period_year#">
		</cfif>
		<cfif isdefined("attributes.date2") and isdate(attributes.date2)>
			<cf_date tarih="attributes.date2">		
		<cfelse>
			<cfset attributes.date2 = "#daysinmonth(now())#/#month(now())#/#session.ep.period_year#">
		</cfif>
<cfform name="list_kebir" method="post" action="index.cfm?fuseaction=#attributes.fuseaction#">
<input type="hidden" name="is_submitted" id="is_submitted" value="0" />
<input type="hidden" name="page" id="page" value="<cfoutput>#(attributes.page+1)#</cfoutput>"/>
	<cfsavecontent variable="title"><cf_get_lang dictionary_id='39163.Defter-i Kebir'> <cf_get_lang dictionary_id='39164.Hesap Seçimli'></cfsavecontent>
    <cf_report_list_search title="#title#">
        <cf_report_list_search_area>		
            <div class="row">
                <div class="col col-12 col-xs-12">
                    <div class="row formContent">
                        <div class="row" type="row">
                            <div class="col col-5 col-md-4 col-sm-6 col-xs-12">
                                <div class="form-group">
									<div class="col col-6">
                                        <label><cf_get_lang dictionary_id='57652.Hesap'>1*</label>
										<div class="input-group">
											<input type="hidden" name="code1" id="code1" value="<cfoutput>#attributes.code1#</cfoutput>">							
                                            <cfinput message="Hesap Kodu Seçmediniz" type="Text" value="#attributes.code1#" name="name1" id="name1" style="width:95px;" onFocus="AutoComplete_Create('name1','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'1\',0','ACCOUNT_CODE','code1','','3','200');"><!--- onkeyup="get_wrk_acc_code_1();" --->
                                            <span class="input-group-addon btnPointer icon-ellipsis" onclick="javascript:pencere_ac_kebir('list_kebir.code1','list_kebir.name1','list_kebir.name1');"></span>											
										</div>
									</div>
                                    <div class="col col-6">
                                        <label><cf_get_lang dictionary_id='57652.Hesap'>2*</label>
                                        <div class="input-group">
                                            <input type="hidden" name="code2" id="code2" value="<cfoutput>#attributes.code2#</cfoutput>">
                                            <cfinput message="Hesap Kodu Seçmediniz" type="Text"  value="#attributes.code2#" name="name2" id="name2" style="width:95px;" onFocus="AutoComplete_Create('name2','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'1\',0','ACCOUNT_CODE','code2','','3','200');"><!--- onkeyup="get_wrk_acc_code_2();" --->
                                            <span class="input-group-addon btnPointer icon-ellipsis" onclick="javascript:pencere_ac_kebir('list_kebir.code2','list_kebir.name2','list_kebir.name2');"></span>
										</div>
									</div>
								</div>
								<div class="form-group">
									<label class="col col-12"><cf_get_lang dictionary_id='38857.Hesap Türü'></label>
									<div class="col col-12">
										<select name="acc_code_type">
											<option value="0" <cfif attributes.acc_code_type eq 0>selected</cfif>><cf_get_lang dictionary_id='58793.Tek Düzen'></option>
											<option value="1" <cfif attributes.acc_code_type eq 1>selected</cfif>><cf_get_lang dictionary_id='58308.UFRS'></option>
                                    	</select>
									</div>
								</div>
                                <div class="form-group">
                                    <label class="col col-12"><cf_get_lang dictionary_id='58690.Tarih Aralığı'>*</label>
									<div class="col col-6">
										<div class="input-group">
											<cfsavecontent variable="message"><cf_get_lang dictionary_id="57471.Eksik Veri"> : <cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></cfsavecontent>
                                            <cfinput value="#dateformat(attributes.date1,dateformat_style)#" required="yes" message="#message#" type="text" name="date1" validate="#validate_style#" maxlength="10">
                                            <span class="input-group-addon"><cf_wrk_date_image date_field="date1"></span>
                                        </div>
                                    </div>
                                    <div class="col col-6">
										<div class="input-group">
											<cfsavecontent variable="message"><cf_get_lang dictionary_id="57471.Eksik Veri"> : <cf_get_lang dictionary_id='57700.Bitiş Tarihi'></cfsavecontent>
                                            <cfinput value="#dateformat(attributes.date2,dateformat_style)#" required="yes" message="#message#" type="text" name="date2" validate="#validate_style#" maxlength="10">
                                            <span class="input-group-addon"><cf_wrk_date_image date_field="date2"></span>
                                        </div>
                                    </div>   
                                </div>
                                <div class="form-group">
                                    <label class="col col-12"><cf_get_lang dictionary_id='57800.İşlem Tipi'></label>
                                    <div class="col col-12" id="acc_detail_search">
                                        <cfquery name="get_acc_card_type" datasource="#dsn3#">
                                            SELECT PROCESS_TYPE,PROCESS_CAT_ID,PROCESS_CAT FROM SETUP_PROCESS_CAT WHERE PROCESS_TYPE IN (10,11,12,13,14,19) ORDER BY PROCESS_TYPE
                                        </cfquery>
                                        <select multiple="multiple" name="acc_card_type">
                                            <cfoutput query="get_acc_card_type" group="process_type">
                                                <cfoutput>
                                                <option value="#process_type#-#process_cat_id#" <cfif listfind(attributes.acc_card_type,'#process_type#-#process_cat_id#',',')>selected</cfif>>#process_cat#</option>
                                                </cfoutput>
                                            </cfoutput>
                                        </select>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="col col-12"><cf_get_lang dictionary_id='58960.Rapor Tipi'></label>
                                    <div class="col col-12">
                                        <select name="kebir_report_type">
                                            <option value="1" <cfif isdefined("attributes.kebir_report_type") and attributes.kebir_report_type eq 1>selected</cfif>><cf_get_lang dictionary_id ='39904.Standart Döküm'> <cf_get_lang dictionary_id='29731.Excel'></option>
                                            <option value="2" <cfif isdefined("attributes.kebir_report_type") and attributes.kebir_report_type eq 2>selected</cfif>><cf_get_lang dictionary_id ='39916.Sayfa Toplamlı Döküm'> <cf_get_lang dictionary_id='29731.Excel'></option>
                                            <option value="3" <cfif isdefined("attributes.kebir_report_type") and attributes.kebir_report_type eq 3>selected</cfif>><cf_get_lang dictionary_id ='39917.Devreden Bakiyeli Döküm'> <cf_get_lang dictionary_id='29731.Excel'></option>
                                            <option value="17" <cfif isdefined("attributes.kebir_report_type") and attributes.kebir_report_type eq 17>selected</cfif>><cf_get_lang dictionary_id='60790.Standart Döküm Çoklu Excel'></option>
                                            <option value="16" <cfif isdefined("attributes.kebir_report_type") and attributes.kebir_report_type eq 16>selected</cfif>><cf_get_lang dictionary_id='60791.Devreden Bakiyeli Satır Açıklamalı Çoklu Excel'></option>	
                                            <option value="15" <cfif isdefined("attributes.kebir_report_type") and attributes.kebir_report_type eq 15>selected</cfif>><cf_get_lang dictionary_id='39907.Hesap Bazında Gruplamalı'> <cf_get_lang dictionary_id='29731.Excel'></option>
                                            <option value="14" <cfif isdefined("attributes.kebir_report_type") and attributes.kebir_report_type eq 14>selected</cfif>><cf_get_lang dictionary_id='39908.Üst Hesap Bazında Gruplamalı'> <cf_get_lang dictionary_id='29731.Excel'></option>
                                            <!---<option value="4" <cfif isdefined("attributes.kebir_report_type") and attributes.kebir_report_type eq 4>selected</cfif>><cf_get_lang dictionary_id ='39915.Standart Döküm Çoklu PDF'></option>--->
                                            <option value="18" <cfif isdefined("attributes.kebir_report_type") and attributes.kebir_report_type eq 18>selected</cfif>><cf_get_lang dictionary_id='60792.Devreden Bakiyeli Döküm Çoklu Excel'></option>
                                            <option value="10" <cfif isdefined("attributes.kebir_report_type") and attributes.kebir_report_type eq 10>selected</cfif>><cf_get_lang dictionary_id='60793.Fiş Türüne Göre Bakiyesiz Excel'></option>
                                            <option value="13" <cfif isdefined("attributes.kebir_report_type") and attributes.kebir_report_type eq 13>selected</cfif>><cf_get_lang dictionary_id ='39904.Standart Döküm'> <cf_get_lang dictionary_id='29733.PDF'></option>
                                            <option value="12" <cfif isdefined("attributes.kebir_report_type") and attributes.kebir_report_type eq 12>selected</cfif>><cf_get_lang dictionary_id ='39916.Sayfa Toplamlı Döküm'> <cf_get_lang dictionary_id='29733.PDF'></option>									
                                            <!---<option value="11" <cfif isdefined("attributes.kebir_report_type") and attributes.kebir_report_type eq 11>selected</cfif>><cf_get_lang dictionary_id ='39917.Devreden Bakiyeli Döküm'> PDF</option>--->								
                                            <!---<option value="5" <cfif isdefined("attributes.kebir_report_type") and attributes.kebir_report_type eq 5>selected</cfif>><cf_get_lang dictionary_id ='39918.Devreden Bakiyeli Döküm Çoklu PDF'></option>--->
                                            <option value="6" <cfif isdefined("attributes.kebir_report_type") and attributes.kebir_report_type eq 6>selected</cfif>><cf_get_lang dictionary_id='38859.Fiş Türüne Göre Bakiyesiz PDF'></option>
                                            <option value="7" <cfif isdefined("attributes.kebir_report_type") and attributes.kebir_report_type eq 7>selected</cfif>><cf_get_lang dictionary_id ='40543.Devreden Bakiyeli Satır Çoklu Pdf'></option>
                                            <option value="8" <cfif isdefined("attributes.kebir_report_type") and attributes.kebir_report_type eq 8>selected</cfif>><cf_get_lang dictionary_id='39907.Hesap Bazında Gruplamalı'> <cf_get_lang dictionary_id='29733.PDF'></option>
                                            <option value="9" <cfif isdefined("attributes.kebir_report_type") and attributes.kebir_report_type eq 9>selected</cfif>><cf_get_lang dictionary_id='39908.Üst Hesap Bazında Gruplamalı'> <cf_get_lang dictionary_id='29733.PDF'></option>
                                        </select>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="col col-12"><cf_get_lang dictionary_id='39145.Sayfa Yapısı'></label>
                                    <div class="col col-12">
                                        <select name="pagetype" style="width:188px;">
                                            <option value="a4;29;21">A4 (297-210 mm)</option>
                                            <option value="letter;27.94;21.59">Letter (27,94-21,59 mm)</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <div class="col col-6">
										<label><cf_get_lang dictionary_id="38890.Hesap Adı"></label>
										<cfsavecontent variable="message"><cf_get_lang dictionary_id='47845.Hesap Adı alanına en fazla 50 karakter girebilirsiniz'></cfsavecontent>
                                        <cfinput type="text" name="character_account_code" id="character_account_code" range="1,100" value="#attributes.character_account_code#" message="#message#"/>
                                    </div>
                                    <div class="col col-6">
										<label><cf_get_lang dictionary_id="57629.Açıklama"></label>
										<cfsavecontent variable="message"><cf_get_lang dictionary_id='51349.Açıklama Alanına 50 Karakterden Fazla Girmeyiniz. Fazla Karakter Sayısı'></cfsavecontent>
										<cfinput type="text" name="character_detail" id="character_detail" range="1,150" value="#attributes.character_detail#" message="#message#"/>
                                    </div>
                                </div>
                                <div class="form-group">
                                  <div class="col col-6">
                                     <label><cf_get_lang dictionary_id="39022.Satır Fontu"></label>
                                     <select name="fontfamily">
                                         <option value="Arial" <cfif isdefined("attributes.fontfamily") and attributes.fontfamily is 'Arial'>selected</cfif>>Arial</option>
                                         <option value="Verdana" <cfif isdefined("attributes.fontfamily") and attributes.fontfamily is 'Verdana'>selected</cfif>>Verdana</option>
                                         <option value="Geneva" <cfif isdefined("attributes.fontfamily") and attributes.fontfamily is 'Geneva'>selected</cfif>>Geneva</option>
                                         <option value="Times New Roman" <cfif isdefined("attributes.fontfamily") and attributes.fontfamily is 'Times New Roman'>selected</cfif>>Times New Roman</option>
                                         <option value="Courier New" <cfif isdefined("attributes.fontfamily") and attributes.fontfamily is 'Courier New'>selected</cfif>>Courier New</option>
                                         <option value="Georgia" <cfif isdefined("attributes.fontfamily") and attributes.fontfamily is 'Georgia'>selected</cfif>>Georgia</option>
                                         <option value="Tahoma" <cfif isdefined("attributes.fontfamily") and attributes.fontfamily is 'Tahoma'>selected</cfif>>Tahoma</option>
                                    </select>
                                  </div>
                                  <div class="col col-6">
                                     <label><cf_get_lang dictionary_id="39050.Başlık Fontu"></label>
                                     <select name="bigfontfamily">
                                         <option value="Arial" <cfif isdefined("attributes.bigfontfamily") and attributes.bigfontfamily is 'Arial'>selected</cfif>>Arial</option>
                                         <option value="Verdana" <cfif isdefined("attributes.bigfontfamily") and attributes.bigfontfamily is 'Verdana'>selected</cfif>>Verdana</option>
                                         <option value="Geneva" <cfif isdefined("attributes.bigfontfamily") and attributes.bigfontfamily is 'Geneva'>selected</cfif>>Geneva</option>
                                         <option value="Times New Roman" <cfif isdefined("attributes.bigfontfamily") and attributes.bigfontfamily is 'Times New Roman'>selected</cfif>>Times New Roman</option>
                                         <option value="Courier New" <cfif isdefined("attributes.bigfontfamily") and attributes.bigfontfamily is 'Courier New'>selected</cfif>>Courier New</option>
                                         <option value="Georgia" <cfif isdefined("attributes.bigfontfamily") and attributes.bigfontfamily is 'Georgia'>selected</cfif>>Georgia</option>
                                         <option value="Tahoma" <cfif isdefined("attributes.bigfontfamily") and attributes.bigfontfamily is 'Tahoma'>selected</cfif>>Tahoma</option>
                                    </select>
                                  </div>
                                </div>
                                <div class="form-group">								   
								   <div class="col col-6">
									  <label><cf_get_lang dictionary_id='58508.satır'><cf_get_lang dictionary_id='58952.Font Ölçüsü'></label>
										<select name="fontsize">
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
								   <div class="col col-6">
									  <label><cf_get_lang dictionary_id='58820.başlık'><cf_get_lang dictionary_id='58952.Font Ölçüsü'></label>
										<select name="bigfontsize">
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
								</div>
								<div class="form-group"> 
									<div class="col col-12">
										<label class="col col-12"><cf_get_lang dictionary_id ='39444.Satır Sayısı'></label>
											<div class="col col-3">
												<cfinput type="text" name="pdf_page_row" value="#attributes.pdf_page_row#" onKeyUp="return(FormatCurrency(this,event));" validate="integer">
											</div>
											<!---satır sayısı belirtilmemisse page_break kullanılmaz, pdf otomatik sayfalandırır  --->
											<div class="col col-9">
												<label> <input type="checkbox" name="no_process" id="no_process" value="1" checked><cf_get_lang dictionary_id='39914.Hareketi Olmayan Hesapları Getirme'></label>
											</div>
									</div> 
                                </div>
							</div>
							<div class="col col-5 col-md-4 col-sm-6 col-xs-12">
								<div class="form-group">
									<label class="col col-12 col-xs-12"></label>
									<div class="col col-12 col-xs-12">
										<cftry>
											<cfinclude template="#file_web_path#templates/import_example/defterikebir_#session.ep.language#.html">
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
						<cfsavecontent variable="buttun_name"><cf_get_lang dictionary_id='58966.Oluştur'></cfsavecontent>
                         <cf_wrk_report_search_button search_function='kontrol()' button_name='#buttun_name#' is_excel="0" button_type='2'>
                       </div>
                    </div>
                </div>
            </div>
        </cf_report_list_search_area>
    </cf_report_list_search>
</cfform>
<cfif isdefined("is_submitted")>
	<!--- <cf_date tarih="attributes.date1">
	<cf_date tarih="attributes.date2"> --->
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
	<cfset is_zip = 0>
	
	<cfset filename_ = "#upload_folder#account/fintab/#session.ep.userid#/#replace(date1,'/','-','all')#_#replace(date2,'/','-','all')#_#createuuid()#">
	<!--- Daha Once Kullanilan ve Isi Biten Klasorler Olusturulup Temizleniyor --->
	<cfif attributes.page eq 1>
		<cfif not DirectoryExists("#upload_folder##dir_seperator#account#dir_seperator#fintab#dir_seperator##session.ep.userid#")>
            <irectory action="create" name="#session.ep.userid#" directory="#upload_folder##dir_seperator#account#dir_seperator#fintab#dir_seperator##session.ep.userid#">
        <cfelse>
                <irectory  action="delete" directory="#upload_folder##dir_seperator#account#dir_seperator#fintab#dir_seperator##session.ep.userid#" recurse="yes">
                <irectory action="create" name="#session.ep.userid#" directory="#upload_folder##dir_seperator#account#dir_seperator#fintab#dir_seperator##session.ep.userid#">
        </cfif>
    </cfif>
	
	<cfset zip_filename = "#dateformat(now(),'YYYYMMDD')&timeformat(now(),'HHmmss')#_#createuuid()#.zip">
	<cfif attributes.page eq 1>
	<cfif not DirectoryExists("#upload_folder##dir_seperator#account#dir_seperator#fintab#dir_seperator##session.ep.userid#_zip")>
		<irectory action="create" name="#session.ep.userid#" directory="#upload_folder##dir_seperator#account#dir_seperator#fintab#dir_seperator##session.ep.userid#_zip">
	<cfelse>
		<irectory  action="delete" directory="#upload_folder##dir_seperator#account#dir_seperator#fintab#dir_seperator##session.ep.userid#_zip" recurse="yes">
		<irectory action="create" name="#session.ep.userid#" directory="#upload_folder##dir_seperator#account#dir_seperator#fintab#dir_seperator##session.ep.userid#_zip">
	</cfif>
    </cfif>
	<!--- //Daha Once Kullanilan ve Isi Biten Klasorler Olusturulup Temizleniyor --->

	<cfif isdefined('attributes.kebir_report_type') and attributes.kebir_report_type eq 1>
		<cfinclude template="rapor_kebir_standart_excel.cfm">
	<cfelseif isdefined('attributes.kebir_report_type') and attributes.kebir_report_type eq 2>
		<cfinclude template="rapor_kebir_sayfa_toplamli_excel.cfm">
	<cfelseif isdefined('attributes.kebir_report_type') and attributes.kebir_report_type eq 3>
		<cfinclude template="rapor_kebir_devreden_bakiyeli_excel.cfm">
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
	<cfelseif isdefined('attributes.kebir_report_type') and attributes.kebir_report_type eq 10>
		<cfinclude template="rapor_kebir_fis_turune_gore_bakiyesiz_excel.cfm">		
	<cfelseif isdefined('attributes.kebir_report_type') and attributes.kebir_report_type eq 11>
		<cfinclude template="rapor_kebir_devreden_bakiyeli.cfm">
	<cfelseif isdefined('attributes.kebir_report_type') and attributes.kebir_report_type eq 12>
		<cfinclude template="rapor_kebir_sayfa_toplamli.cfm">	
	<cfelseif isdefined('attributes.kebir_report_type') and attributes.kebir_report_type eq 13>
		<cfinclude template="rapor_kebir_standart_pdf.cfm">	
	<cfelseif isdefined('attributes.kebir_report_type') and attributes.kebir_report_type eq 14>
		<cfinclude template="rapor_kebir_ust_hesap_bazinda_gruplamali_excel.cfm">
	<cfelseif isdefined('attributes.kebir_report_type') and attributes.kebir_report_type eq 15>
		<cfinclude template="rapor_kebir_hesap_bazinda_gruplamali_excel.cfm">
	<cfelseif isdefined('attributes.kebir_report_type') and attributes.kebir_report_type eq 16>
		<cfinclude template="rapor_kebir_bakiyeli_satir_aciklamali_multi_excel.cfm">
	<cfelseif isdefined('attributes.kebir_report_type') and attributes.kebir_report_type eq 17>
		<cfinclude template="rapor_kebir_standart_multi_excel.cfm">	
	<cfelseif isdefined('attributes.kebir_report_type') and attributes.kebir_report_type eq 18>
		<cfinclude template="rapor_kebir_devreden_bakiyeli_multi_excel.cfm">														
	</cfif>
</cfif>
<div id="wrk_report_button_info_box" style="display:none;position:absolute;width:400px;" class="pod_box">
	<div id="wrk_report_button_info_box_header" class="header" style="height:15px;">
		<table cellpadding="0" cellspacing="0" width="100%">
			<tr>
				<td style="font-weight:bold;"><cf_get_lang dictionary_id='29728.Dosya İndir'></td>
				<td width="1px">
					<table align="right">
						<tr>
							<td><a href="javascript://" onclick="gizle(wrk_report_button_info_box);"><img src="/images/pod_close.gif" alt="<cf_get_lang dictionary_id='57553.Kapat'>" border="0" align="absmiddle"></a></td>
						</tr>
					</table>
				</td>
				<td width="1px" class="clearer"></td>
			</tr>
		</table>
	</div>
	<div id="wrk_report_button_info_box_body" class="body">
		<div id="downloading" align="center"></div>
	</div>
</div>
<script type="text/javascript">

	function report_dosya_ver(file_,type_id_)
	{
		wrk_report_button_info_box.style.left=(document.body.clientWidth-400)/2;
		wrk_report_button_info_box.style.top=(document.body.clientHeight-120)/2;
		goster(wrk_report_button_info_box);
		if(type_id_ == 3)
		{
			document.getElementById('downloading').innerHTML = 'Dosya Türü : <b>PDF</b>';
			target_ = 'blank';
		}
		document.getElementById('downloading').innerHTML += '<br/><br/><a href="' + file_ + '" target="'+ target_ +'" onclick="gizle(wrk_report_button_info_box);" class="tableyazi"><img src="/images/digital_asset.png" border="0"></a>';
	}

	function pencere_ac_kebir(str_alan_1,str_alan_2,str_alan)
	{
		var txt_keyword = eval(str_alan + ".value" );
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan_all&field_id='+str_alan_1+'&field_id2='+str_alan_2+'&keyword='+txt_keyword,'list');
	}
	
	function search_kontrol()
	{
		if(list_kebir.date1.value.length && list_kebir.date2.value.length) 
		{
			if (!global_date_check_value("01/01/<cfoutput>#SESSION.EP.PERIOD_YEAR#</cfoutput>",list_kebir.date1.value, "<cf_get_lang dictionary_id='55062.Girilen kaydın başlangıç ve bitiş tarihi aynı çalışma dönemi içerisinde olmalıdır!'>"))
				return false;
		}
		return true;
	}
	
	function kontrol()
	{
	     if ((document.list_kebir.date1.value != '') && (document.list_kebir.date2.value != '') &&
         !date_check(list_kebir.date1,list_kebir.date2,"<cf_get_lang dictionary_id ='39814.Başlangıç Tarihi Bitiş Tarihinden Küçük Olmalıdır'>!"))
         return false;
        document.getElementById('page').value = 1;
		if ((document.list_kebir.code1.value=='') || (document.list_kebir.code2.value==''))
			{
				alert("<cf_get_lang dictionary_id="57471.Eksik Veri"> : <cf_get_lang dictionary_id="38889.Hesap Kodu">");
				return false;
		}
		
		if ((document.list_kebir.date1.value=='') || (document.list_kebir.date2.value==''))
		{
			alert("<cf_get_lang dictionary_id="57471.Eksik Veri"> : <cf_get_lang dictionary_id='58690.Tarih Aralığı'>");
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
</script>

<cfif isdefined("attributes.is_submitted")>
	<cfif isdefined('attributes.kebir_report_type') and (attributes.kebir_report_type eq 13 or attributes.kebir_report_type eq 12 )> 
        <script type="text/javascript">
					<cfif isdefined("GET_ACCOUNT_CARD_ROWS.query_count") and isdefined("son_satir") and GET_ACCOUNT_CARD_ROWS.query_count gt son_satir>
                        function submitForm() 
                        { 
                            // submits form
                            document.forms["list_kebir"].submit();
                        }
                        if (document.getElementById("list_kebir")) 
                            {
                                setTimeout("submitForm()", 5000); // set timout 
                            }
                    </cfif>
        </script>
    </cfif>
</cfif>
