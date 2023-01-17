<!--- muavin defterini pdf olarak almak icin --->
<cfsetting showdebugoutput="no">
<cfparam name="attributes.page" default="1">
<cfflush interval = "3000">
<cfparam name="attributes.maxrows" default="#session.ep.maxrows#">
<cfset attributes.startrow = (attributes.page-1)*attributes.maxrows+1 >
<cfparam name="attributes.module_id_control" default="22">
<cfinclude template="report_authority_control.cfm">
<cfparam name="attributes.code1" default="">
<cfparam name="attributes.code2" default="">
<cfparam name="attributes.pdf_page_row" default="55">
<cfparam name="attributes.acc_card_type" default="">
<cfparam name="attributes.acc_code_type" default="0">
<cfparam name="attributes.date1" default="#dateformat(session.ep.period_start_date,dateformat_style)#">
<cfparam name="attributes.date2" default="#dateformat(session.ep.period_finish_date,dateformat_style)#">
	<cfif isdefined("is_submitted")>
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
			<cfif isdefined("attributes.page") and attributes.page eq 1>
				<cfif not DirectoryExists("#upload_folder##dir_seperator#reserve_files#dir_seperator##session.ep.userid#")>
						<cfdirectory action="create" name="#session.ep.userid#" directory="#upload_folder##dir_seperator#reserve_files#dir_seperator##session.ep.userid#">
				<cfelse>
						<cfdirectory  action="delete" directory="#upload_folder##dir_seperator#reserve_files#dir_seperator##session.ep.userid#" recurse="yes">
						<cfdirectory action="create" name="#session.ep.userid#" directory="#upload_folder##dir_seperator#reserve_files#dir_seperator##session.ep.userid#">
				</cfif>
			</cfif>
			<cfset zip_filename = "#dateformat(now(),'YYYYMMDD')&timeformat(now(),'HHmmss')#_#createuuid()#.zip">
			<cfif isdefined("attributes.page") and attributes.page eq 1 >
				<cfif not DirectoryExists("#upload_folder##dir_seperator#reserve_files#dir_seperator##session.ep.userid#_zip")>
					<cfdirectory action="create" name="#session.ep.userid#" directory="#upload_folder##dir_seperator#reserve_files#dir_seperator##session.ep.userid#_zip">
				<cfelse>
					<cfdirectory  action="delete" directory="#upload_folder##dir_seperator#reserve_files#dir_seperator##session.ep.userid#_zip" recurse="yes">
					<cfdirectory action="create" name="#session.ep.userid#" directory="#upload_folder##dir_seperator#reserve_files#dir_seperator##session.ep.userid#_zip">
				</cfif>
			</cfif>
	</cfif>
<cfsavecontent variable="title"><cf_get_lang dictionary_id='39166.Muavin Defter Raporu'></cfsavecontent>	
<cf_report_list_search title="#title#">
    <cf_report_list_search_area>
		<cfform name="search__" action="" method="post">
			<input type="hidden" name="is_submitted" id="is_submitted" value="0">
			<input type="hidden" name="page" id="page" value="<cfoutput>#attributes.page#</cfoutput>"/>			
			<div class="row">
				<div class="col col-12 col-xs-12">
					<div class="row formContent">
						<div class="row" type="row">
							<div class="col col-4 col-md-6 col-sm-6 col-xs-12">
								<div class="form-group">
									<label class="col col-12"><cf_get_lang dictionary_id='57652.Hesap'>1*</label>
									<div class="col col-12">
										<div class="input-group">
											<cfsavecontent variable="message2">1.<cf_get_lang dictionary_id ='39340.Hesap Kodu Seçmediniz'></cfsavecontent>
											<cf_wrk_account_codes form_name='search__' account_code='code1' is_multi_no ='1'>
											<cfinput required="yes" message="#message2#" type="Text"  name="code1" style="width:110px;"  value="#attributes.code1#" onFocus="AutoComplete_Create('code1','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'1\',0','ACCOUNT_CODE','code1','','3','200');">
											<span class="input-group-addon btnPointer icon-ellipsis" onclick="javascript:pencere_ac_muavin('search__.code1','search__.name1','search__.name1');"></span>
										</div>
									</div>
								</div>
								<div class="form-group">
									<label class="col col-12"><cf_get_lang dictionary_id='57652.Hesap'>2*</label>
									<div class="col col-12">
										<div class="input-group">
											<cfsavecontent variable="message3">2<cf_get_lang dictionary_id='39340.Hesap Kodu Seçmediniz'></cfsavecontent>
											<cf_wrk_account_codes form_name='search__' account_code='code2' is_multi_no ='2'>
											<cfinput required="yes"  value="#attributes.code2#" message="#message3#" type="Text"  name="code2" onFocus="AutoComplete_Create('code2','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'1\',0','ACCOUNT_CODE','code2','','3','200');">
											<span class="input-group-addon btnPointer icon-ellipsis" onclick="javascript:pencere_ac_muavin('search__.code2','search__.name2','search__.name2');"></span>
										</div>
									</div>
								</div>
								<div class="form-group">
									<label class="col col-12"><cf_get_lang dictionary_id='38857.Hesap Türü'></label>
									<div class="col col-12">
										<select name="acc_code_type" id="acc_code_type">
											<option value="0" <cfif attributes.acc_code_type eq 0>selected</cfif>><cf_get_lang dictionary_id='58793.Tek Düzen'></option>
											<option value="1" <cfif attributes.acc_code_type eq 1>selected</cfif>><cf_get_lang dictionary_id='58308.UFRS'></option>
										</select>
									</div>
								</div>
								<div class="form-group">
									<label class="col col-12"><cf_get_lang dictionary_id='57416.Proje'></label>
									<div class="col col-12">	
										<cfif isdefined('attributes.pro_id') and len(attributes.pro_id)>
											<cfset project_id_ = attributes.pro_id>
										<cfelse>
											<cfset project_id_ = ''>
										</cfif>
										<cf_wrkProject
											project_Id="#project_id_#"
											width="110"
											AgreementNo="1" Customer="2" Employee="3" Priority="4" Stage="5"
											boxwidth="600"
											boxheight="400">
									</div>
								</div>
							</div>
							<div class="col col-4 col-md-6 col-sm-6 col-xs-12">
								<div class="form-group">
									<label class="col col-12"><cf_get_lang dictionary_id='58690.Tarih Aralığı'></label>
									<div class="col col-6">
										<div class="input-group">
											<cfsavecontent variable="message"><cf_get_lang dictionary_id="57471.Eksik Veri"> : <cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></cfsavecontent>                            
											<cfinput value="#attributes.date1#" message="#message#" type="text" name="date1" required="yes" validate="#validate_style#" maxlength="10">
											<span class="input-group-addon"><cf_wrk_date_image date_field="date1"></span>
										</div>
									</div>
									<div class="col col-6">
										<div class="input-group">
											<cfsavecontent variable="message"><cf_get_lang dictionary_id="57471.Eksik Veri"> : <cf_get_lang dictionary_id='57700.Bitiş Tarihi'></cfsavecontent>                            
											<cfinput value="#attributes.date2#" message="#message#" type="text" name="date2" required="yes" validate="#validate_style#" maxlength="10">
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
										<select multiple="multiple" style="height:110px;" name="acc_card_type" id="acc_card_type">
											<cfoutput query="get_acc_card_type" group="process_type">
												<cfoutput>
													<option value="#process_type#-#process_cat_id#" <cfif listfind(attributes.acc_card_type,'#process_type#-#process_cat_id#',',')>selected</cfif>>#process_cat#</option>
												</cfoutput>
											</cfoutput>
										</select>
									</div>
								</div>
							</div>
							<div class="col col-4 col-md-6 col-sm-6 col-xs-12">
								<div class="form-group">		
									<div class="col col-6">
										<label><cf_get_lang dictionary_id='39022.Satır Fontu'></label>
										<select name="fontfamily" id="fontfamily" style="width:90px;">
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
										<label><cf_get_lang dictionary_id='39050.Başlık Fontu'></label>								
										<select name="bigfontfamily" id="bigfontfamily" style="width:90px;">
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
									<div class="col col-6">	
										<label><cf_get_lang dictionary_id='58820.Başlık'> <cf_get_lang dictionary_id='58952.Font Ölçüsü'></label>								
										<select name="bigfontsize" id="bigfontsize">
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
									<div class="col col-6">
										<label><cf_get_lang dictionary_id='39345.Dosya Tipi'></label>
										<select name="filetype" id="filetype">
											<option value="excel" <cfif isdefined("attributes.filetype") and attributes.filetype is 'excel'>selected</cfif>><cf_get_lang dictionary_id ='29731.Excel'></option>
											<option value="pdf" <cfif isdefined("attributes.filetype") and attributes.filetype is 'pdf'>selected</cfif>><cf_get_lang dictionary_id ='29733.PDF'></option>
										</select>
									</div>
									<div class="col col-6">	
										<label><cf_get_lang dictionary_id ='39444.Satır Sayısı'></label><!---satır sayısı belirtilmemisse page_break kullanılmaz, pdf otomatik sayfalandırır  --->							
										<cfinput type="text" name="pdf_page_row" value="#attributes.pdf_page_row#" onKeyUp="return(FormatCurrency(this,event));" style="width:23px;" validate="integer">
									</div>
								</div>
								<div class="form-group">
									<div class="col col-12">
										<label><cf_get_lang dictionary_id='39914.Hareketi Olmayan Hesapları Getirme'><input type="checkbox" name="is_acc_with_action" id="is_acc_with_action" value="1" <cfif isdefined('attributes.is_acc_with_action') and attributes.is_acc_with_action eq 1>checked</cfif>></label>
										<label><cf_get_lang dictionary_id="59115.Hesap Bazında Sayfalama Yapılsın"><input type="checkbox" name="is_acc_based_page" id="is_acc_based_page" value="1" <cfif isdefined('attributes.is_acc_based_page') and attributes.is_acc_based_page eq 1>checked</cfif>></label>
										<label><cf_get_lang dictionary_id="59114.Sayfa Devreden Bilgisi Gelsin"><input type="checkbox" name="is_show_cumulative_sum" id="is_show_cumulative_sum" value="1" <cfif isdefined('attributes.is_show_cumulative_sum') and attributes.is_show_cumulative_sum eq 1>checked</cfif>></label>
									</div>
								</div>
							</div>
						</div>
					</div>
					<div class="row ReportContentBorder">
						<div class="ReportContentFooter">
							<cfsavecontent variable="buttun_name"><cf_get_lang dictionary_id='58966.Oluştur'></cfsavecontent>
							<cf_wrk_report_search_button  search_function='control()' button_name='#buttun_name#' button_type='2' is_excel='0'>       
						</div>
					</div>
				</div>
			</div>
		</cfform>
	</cf_report_list_search_area>
</cf_report_list_search>
<cfif isdefined("is_submitted")>
	<cfsetting showdebugoutput="YES"> 
	<cfprocessingdirective suppresswhitespace="yes">
	<cfif isdefined("attributes.date1") and isdate(attributes.date1)>
		<cf_date tarih="attributes.date1">
	<cfelse>
		<cfset attributes.date1 = createodbcdatetime('#session.ep.period_year#-#month(now())#-1')>
	</cfif>
	<cfif isdefined("attributes.date2") and isdate(attributes.date2)>
		<cf_date tarih="attributes.date2">
	<cfelse>
		<cfset attributes.date2 = createodbcdatetime('#session.ep.period_year#-#month(now())#-#daysinmonth(now())#')>
	</cfif>
	<cfset filename = "#attributes.page#_#replace(date1,'/','-','all')#_#replace(date2,'/','-','all')#_#createuuid()#">
	<cfparam name="bakiye" default="0">
	<cfset satir_sayisi=0>
	<cfset page_count_ = 65000>
		<cfquery name="get_account_id" datasource="#dsn2#">
            SELECT 
			<cfif isdefined('attributes.acc_code_type') and attributes.acc_code_type eq 1>
				IFRS_CODE AS ACCOUNT_CODE,
				IFRS_NAME AS ACCOUNT_NAME
			<cfelse>
				ACCOUNT_CODE, 
				ACCOUNT_NAME
			</cfif>
			FROM 
				ACCOUNT_PLAN 
			WHERE 
				<cfif isdefined('attributes.acc_code_type') and attributes.acc_code_type eq 1>
					IFRS_CODE >= '#attributes.code1#' AND
					IFRS_CODE <= '#attributes.code2#' AND
				<cfelse>
					ACCOUNT_CODE >= '#attributes.code1#' AND
					ACCOUNT_CODE <= '#attributes.code2#' AND
				</cfif>
				SUB_ACCOUNT <> 1
				<cfif isdefined('attributes.is_acc_with_action') and attributes.is_acc_with_action eq 1> <!---secilen tarihler arasında hareketi olmayan hesapların gelmemesi icin --->
				AND ACCOUNT_CODE IN (SELECT 
										DISTINCT ACCOUNT_ID 
									FROM
										ACCOUNT_CARD ACC,
										ACCOUNT_CARD_ROWS ACC_R
									WHERE
										ACC.CARD_ID=ACC_R.CARD_ID
										<cfif isdefined('attributes.acc_card_type') and len(attributes.acc_card_type)><!---muhasebe işlem kategorilerine gore arama --->
											AND (
											<cfloop list="#attributes.acc_card_type#" delimiters="," index="type_ii">
												(ACC.CARD_TYPE = #listfirst(type_ii,'-')# AND ACC.CARD_CAT_ID = #listlast(type_ii,'-')#)
												<cfif type_ii neq listlast(attributes.acc_card_type,',') and listlen(attributes.acc_card_type,',') gte 1> OR</cfif>
											</cfloop>  
												)
										</cfif>
										AND ACC.ACTION_DATE BETWEEN #attributes.date1# AND #attributes.date2#
									)
				</cfif>
				<cfif isdefined('attributes.filetype') and (attributes.filetype is 'excel')> 
				<cfelse>
                		ORDER BY
						<cfif isdefined('attributes.acc_code_type') and attributes.acc_code_type eq 1>
                             IFRS_CODE
                        <cfelse>
                             ACCOUNT_CODE
                        </cfif>	
                </cfif>
		</cfquery>
		<cfset totalrecords = get_account_id.recordcount>
		<cfset display_hesap_codes=''>
		<cfset display_hesap_list=''>
		<cfloop from="1" to="#totalrecords#" index="i">
			<cfif i neq totalrecords>
				<cfset display_hesap_codes=display_hesap_codes&"'#get_account_id.ACCOUNT_CODE[i]#',">
				<cfset display_hesap_list=display_hesap_list&"#get_account_id.ACCOUNT_NAME[i]#§"><!--- Virgul § (Alt+789) olarak degistirildi bazi musterilerde fiyatlar virgullu ayrilmis --->
			<cfelse>
				<cfset display_hesap_codes=display_hesap_codes&"'#get_account_id.ACCOUNT_CODE[i]#'">
				<cfset display_hesap_list=display_hesap_list&"#get_account_id.ACCOUNT_NAME[i]#">
			</cfif>
		</cfloop>
		<cfquery name="get_account_card_rows_all" datasource="#dsn2#">
			SELECT 
				AC.BILL_NO,
				AC.CARD_TYPE,
				AC.CARD_TYPE_NO,
				AC.RECORD_DATE, 
				AC.ACTION_DATE,
				ACR.DETAIL,
				ACR.AMOUNT,
				ACR.BA,
                ACR.ACC_PROJECT_ID,
				ACR.ACCOUNT_ID,
				ACR.CARD_ID,
                PRO_PROJECTS.PROJECT_HEAD PROJECT_NAME
			FROM
				ACCOUNT_CARD AC,
				 <cfif attributes.acc_code_type eq 1>
					ACCOUNT_ROWS_IFRS ACR
				<cfelse>
					ACCOUNT_CARD_ROWS ACR
				</cfif>
                LEFT JOIN #dsn_alias#.PRO_PROJECTS ON PRO_PROJECTS.PROJECT_ID = ACR.ACC_PROJECT_ID

			WHERE 
				AC.CARD_ID = ACR.CARD_ID AND
				AC.ACTION_DATE <= #attributes.date2#
			<cfif isdefined('attributes.acc_card_type') and len(attributes.acc_card_type)><!---muhasebe işlem kategorilerine gore arama --->
				AND (
				<cfloop list="#attributes.acc_card_type#" delimiters="," index="type_ii">
					(AC.CARD_TYPE = #listfirst(type_ii,'-')# AND AC.CARD_CAT_ID = #listlast(type_ii,'-')#)
					<cfif type_ii neq listlast(attributes.acc_card_type,',') and listlen(attributes.acc_card_type,',') gte 1> OR</cfif>
				</cfloop>  
					)
			</cfif>
			<cfif attributes.code1 eq attributes.code2>
				AND ACR.ACCOUNT_ID LIKE '#attributes.code1#%'
			<cfelse>
				<cfif len(display_hesap_list)>
					AND ACCOUNT_ID IN (#PreserveSingleQuotes(display_hesap_codes)#)
				<cfelse>
					AND ACCOUNT_ID IS NULL
				</cfif>
			</cfif>	
				ORDER BY AC.ACTION_DATE
		</cfquery>
		<cfset muavin_borc =0>
		<cfset muavin_alacak =0>
		<cfset toplam_borc = 0>
		<cfset toplam_alacak = 0>
		<cfset toplam_bakiye = 0>
	<cfif attributes.filetype is 'excel'>
    	<cfset drc_name_="#session.ep.userid#" >
		<cf_wrk_html_table cellpadding="0" cellspacing="0"  border="0" width="100%" no_output="1" align="center" table_draw_type="1" filename="rapor_muavin#dateformat(now(),'ddmmyyyy')#_#timeformat(now(),'HHMMl')#_#session.ep.userid#" is_auto_page_break="0" is_auto_sheet_break="0" font_size_1="#attributes.fontsize#" font_size_2="#attributes.bigfontsize#" font_style_1="#attributes.fontfamily#" font_style_2="#attributes.bigfontfamily#">
		<cfloop from="1" to="#totalrecords#" index="I">
			<cfset dev_borc = 0>
			<cfset dev_alacak = 0>
			<cfset attributes.CODE = trim(get_account_id.ACCOUNT_CODE[I])>
			<cfset main_code = trim(get_account_id.ACCOUNT_CODE[I])>
			<cfif i eq 1>
				<cfset main_code_pre = trim(get_account_id.ACCOUNT_CODE[I])>
			<cfelse>
				<cfset main_code_pre = trim(get_account_id.ACCOUNT_CODE[I-1])>
			</cfif>
			<!--- devreden icin --->
            <cfquery name="devreden_alacak" dbtype="query">
                SELECT SUM(AMOUNT) AS AMOUNT FROM get_account_card_rows_all WHERE ACCOUNT_ID = '#attributes.CODE#' AND BA = 1 AND ACTION_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#"> <cfif len(attributes.project_id)> AND ACC_PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#"> </cfif>
            </cfquery>
            <cfquery name="devreden_borc" dbtype="query">
                SELECT SUM(AMOUNT) AS AMOUNT FROM get_account_card_rows_all WHERE ACCOUNT_ID = '#attributes.CODE#' AND BA = 0 AND ACTION_DATE  < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#"> <cfif len(attributes.project_id)> AND ACC_PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#"> </cfif>
            </cfquery>
			<cfif not len(devreden_borc.AMOUNT)><cfset dev_borc = 0 ><cfelse><cfset dev_borc = devreden_borc.AMOUNT ></cfif>
			<cfif not len(devreden_alacak.AMOUNT)><cfset dev_alacak = 0 ><cfelse><cfset dev_alacak = devreden_alacak.AMOUNT ></cfif>
			<cfset muavin_borc=muavin_borc+dev_borc>
			<cfset muavin_alacak=muavin_alacak+dev_alacak>
			<!--- //devreden son --->					
			<cfquery name="get_account_card_rows"  dbtype="query">
				SELECT
					*
				FROM
					get_account_card_rows_all
				WHERE
					ACCOUNT_ID = '#attributes.CODE#'
					AND ACTION_DATE BETWEEN  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#">
                    <cfif len(attributes.project_id)>
                		AND ACC_PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
                	</cfif>
				ORDER BY ACTION_DATE, BILL_NO
			</cfquery>
				<cfif i eq 1>
					<cf_wrk_html_tr>
						<cf_wrk_html_td colspan="9" align="center" class="headbold"><cf_get_lang dictionary_id='40645.Muavin Defteri'></cf_wrk_html_td>
					</cf_wrk_html_tr>
					<cf_wrk_html_tr>
						<cf_wrk_html_td colspan="9" align="center" class="txtbold"><cfoutput>#session.ep.company# (#DateFormat(attributes.date1,dateformat_style)# - #DateFormat(attributes.date2,dateformat_style)#)</cfoutput></cf_wrk_html_td>
					</cf_wrk_html_tr>
				</cfif>
				<cfif (isdefined("attributes.is_acc_based_page") and main_code neq main_code_pre)>
					<cfset satir_sayisi=0>
					<cf_wrk_html_page_break>
					<cf_wrk_html_sheet_break>
				</cfif>
				<cf_wrk_html_tr>
					<cfset satir_sayisi=satir_sayisi+1>
					<cf_wrk_html_td colspan="9" class="txtbold" align="center"><cfoutput>#attributes.CODE# / <cfif ListFindNoCase(display_hesap_codes,"'#attributes.CODE#'",',')>#listgetat(display_hesap_list,listfind(display_hesap_codes,"'#attributes.CODE#'",','),'§')#</cfif></cfoutput></cf_wrk_html_td>
				</cf_wrk_html_tr>
				<cfif satir_sayisi neq 1 and len(attributes.pdf_page_row) and attributes.pdf_page_row neq 0 and (satir_sayisi mod attributes.pdf_page_row) eq 1><!--- satır sayısı belirtilmisse sayfalama yapılıyor --->
					<cf_wrk_html_page_break>
					<cfif (satir_sayisi mod page_count_) eq 1>
						<cf_wrk_html_sheet_break>
					</cfif>
					<cfif isdefined("attributes.is_show_cumulative_sum") and attributes.is_show_cumulative_sum eq 1>
						<cf_wrk_html_tr>
						<cfset satir_sayisi=satir_sayisi+1>
							<cf_wrk_html_td width="435" colspan="6"></cf_wrk_html_td>
							<cf_wrk_html_td width="125" align="center"><cf_get_lang dictionary_id='60795.Devreden Borç'></cf_wrk_html_td>
							<cf_wrk_html_td width="125" align="center"><cf_get_lang dictionary_id='60796.Devreden Alacak'></cf_wrk_html_td>
							<cf_wrk_html_td width="155"></cf_wrk_html_td>
						</cf_wrk_html_tr>					
						<cf_wrk_html_tr>
						<cfset satir_sayisi=satir_sayisi+1>
							<cf_wrk_html_td width="435" colspan="6"><cf_get_lang dictionary_id='60797.Devreden Küm. Toplam'></cf_wrk_html_td>
							<cf_wrk_html_td width="125" align="right" style="text-align:right;" format="numeric"><cfoutput>#TLFormat(muavin_borc)#</cfoutput></cf_wrk_html_td>
							<cf_wrk_html_td width="125" align="right" style="text-align:right;" format="numeric"><cfoutput>#TLFormat(muavin_alacak)#</cfoutput></cf_wrk_html_td>
							<cf_wrk_html_td width="155"></cf_wrk_html_td>
						</cf_wrk_html_tr>
					</cfif>
				</cfif> 
				<cf_wrk_html_tr align="center" class="txtbold">
					<cfset satir_sayisi=satir_sayisi+1>
					<cf_wrk_html_td width="80" class="txtbold"><cf_get_lang dictionary_id='57742.Tarih'></cf_wrk_html_td>
					<cf_wrk_html_td width="50" class="txtbold"><cf_get_lang dictionary_id='57487.No'></cf_wrk_html_td>
					<cf_wrk_html_td width="70" class="txtbold"><cf_get_lang dictionary_id='39346.Fiş Türü'></cf_wrk_html_td>
					<cf_wrk_html_td width="50" class="txtbold"><cf_get_lang dictionary_id='57946.Fiş No'></cf_wrk_html_td>
                    <cf_wrk_html_td width="100" class="txtbold"><cf_get_lang dictionary_id='57416.Proje'></cf_wrk_html_td>
					<cf_wrk_html_td width="242" class="txtbold"><cf_get_lang dictionary_id='57629.Açıklama'></cf_wrk_html_td>
					<cf_wrk_html_td width="105" class="txtbold"><cf_get_lang dictionary_id='57587.Borç'></cf_wrk_html_td>
					<cf_wrk_html_td width="105" class="txtbold"><cf_get_lang dictionary_id='57588.Alacak'></cf_wrk_html_td>
					<cf_wrk_html_td width="155" class="txtbold"><cf_get_lang dictionary_id='57589.Bakiye'></cf_wrk_html_td>
					<cf_wrk_html_td width="155" class="txtbold">B/A</cf_wrk_html_td>	
				</cf_wrk_html_tr>
				<cfif len(attributes.pdf_page_row) and attributes.pdf_page_row neq 0 and (satir_sayisi mod attributes.pdf_page_row) eq 1><!--- satır sayısı belirtilmisse sayfalama yapılıyor --->
					<cf_wrk_html_page_break>
					<cfif (satir_sayisi mod page_count_) eq 1>
						<cf_wrk_html_sheet_break>
					</cfif>					
					<cfif isdefined("attributes.is_show_cumulative_sum") and attributes.is_show_cumulative_sum eq 1>
						<cf_wrk_html_tr>
						<cfset satir_sayisi=satir_sayisi+1>
							<cf_wrk_html_td width="435" colspan="6"></cf_wrk_html_td>
							<cf_wrk_html_td width="125" align="center"><cf_get_lang dictionary_id='60795.Devreden Borç'></cf_wrk_html_td>
							<cf_wrk_html_td width="125" align="center"><cf_get_lang dictionary_id='60796.Devreden Alacak'></cf_wrk_html_td>
							<cf_wrk_html_td width="155"></cf_wrk_html_td>
						</cf_wrk_html_tr>					
						<cf_wrk_html_tr class="txtbold">
						<cfset satir_sayisi=satir_sayisi+1>
							<cf_wrk_html_td width="435" colspan="6"><cf_get_lang dictionary_id='60797.Devreden Küm. Toplam'></cf_wrk_html_td>
							<cf_wrk_html_td width="125" align="right" style="text-align:right;" format="numeric"><cfoutput>#TLFormat(muavin_borc)#</cfoutput></cf_wrk_html_td>
							<cf_wrk_html_td width="125" align="right" style="text-align:right;" format="numeric"><cfoutput>#TLFormat(muavin_alacak)#</cfoutput></cf_wrk_html_td>
							<cf_wrk_html_td width="155"></cf_wrk_html_td>
						</cf_wrk_html_tr>
					</cfif>
				</cfif> 
				<cf_wrk_html_tr class="txtbold" valign="top" height="20">
					<cfset satir_sayisi=satir_sayisi+1>
					<cf_wrk_html_td colspan="6"><cf_get_lang dictionary_id ='58034.Devreden'></cf_wrk_html_td>
					<cf_wrk_html_td align="right" style="text-align:right;" format="numeric"><cfoutput>#TLFormat(dev_borc)#</cfoutput><!--- <cfset muavin_borc=muavin_borc+dev_borc> ---></cf_wrk_html_td>
					<cf_wrk_html_td align="right" style="text-align:right;" format="numeric"><cfoutput>#TLFormat(dev_alacak)#</cfoutput><!--- <cfset muavin_alacak=muavin_alacak+dev_alacak> ---></cf_wrk_html_td>				  
					<cf_wrk_html_td align="right" style="text-align:right;" format="numeric">
						<cfset bakiye = dev_borc-dev_alacak><cfoutput>#TLFormat(abs(bakiye))#</cfoutput>
					</cf_wrk_html_td>
					<cf_wrk_html_td align="right" style="text-align:right;">
						<cfif bakiye lt 0>(A)<cfelse>(B)</cfif>
					</cf_wrk_html_td>

				</cf_wrk_html_tr>
				<cfif len(attributes.pdf_page_row) and attributes.pdf_page_row neq 0 and (satir_sayisi mod attributes.pdf_page_row) eq 1><!--- satır sayısı belirtilmisse sayfalama yapılıyor --->
					<cf_wrk_html_page_break>
					<cfif (satir_sayisi mod page_count_) eq 1>
						<cf_wrk_html_sheet_break>
					</cfif>
					<cfif isdefined("attributes.is_show_cumulative_sum") and attributes.is_show_cumulative_sum eq 1>
						<cf_wrk_html_tr class="txtbold">
						<cfset satir_sayisi=satir_sayisi+1>
							<cf_wrk_html_td width="435" colspan="6"></cf_wrk_html_td>
							<cf_wrk_html_td width="125" align="center"><cf_get_lang dictionary_id='60795.Devreden Borç'></cf_wrk_html_td>
							<cf_wrk_html_td width="125" align="center"><cf_get_lang dictionary_id='60796.Devreden Alacak'></cf_wrk_html_td>
							<cf_wrk_html_td width="155"></cf_wrk_html_td>
						</cf_wrk_html_tr>					
						<cf_wrk_html_tr class="txtbold">
						<cfset satir_sayisi=satir_sayisi+1>
							<cf_wrk_html_td width="435" colspan="6"><cf_get_lang dictionary_id='60797.Devreden Küm. Toplam'></cf_wrk_html_td>
							<cf_wrk_html_td width="125" align="right" style="text-align:right;" format="numeric"><cfoutput>#TLFormat(muavin_borc)#</cfoutput></cf_wrk_html_td>
							<cf_wrk_html_td width="125" align="right" style="text-align:right;" format="numeric"><cfoutput>#TLFormat(muavin_alacak)#</cfoutput></cf_wrk_html_td>
							<cf_wrk_html_td width="155"></cf_wrk_html_td>
						</cf_wrk_html_tr>
					</cfif>
				</cfif>
				<cfif get_account_card_rows.RECORDCOUNT>
					<cfoutput query="get_account_card_rows">
						<cfif CARD_TYPE EQ 10><cfset TYPE='AÇILIŞ'><cfset CARD_TYPE_NO = 1>
						<cfelseif CARD_TYPE EQ 11><cfset TYPE='TAHSİL'>
						<cfelseif CARD_TYPE EQ 12><cfset TYPE='TEDİYE'>
						<cfelseif listfind('13,14',CARD_TYPE)><cfset TYPE='MAHSUP'>
						<cfelseif CARD_TYPE EQ 19><cfset TYPE='KAPANIS'></cfif>
						<cf_wrk_html_tr>
							<cfset satir_sayisi=satir_sayisi+1>
							<cf_wrk_html_td align="center">#dateformat(ACTION_DATE,dateformat_style)#</cf_wrk_html_td>
							<cf_wrk_html_td align="center">#BILL_NO#</cf_wrk_html_td>
							<cf_wrk_html_td align="center">#TYPE#</cf_wrk_html_td>
							<cf_wrk_html_td align="center">#CARD_TYPE_NO#</cf_wrk_html_td>
                            <cf_wrk_html_td>#PROJECT_NAME#</cf_wrk_html_td>
							<cf_wrk_html_td>#left(DETAIL,150)#</cf_wrk_html_td>
							<cfif BA eq 0><!--- borc --->
							<cf_wrk_html_td align="right" style="text-align:right;" format="numeric">#TLFormat(amount)#<cfset muavin_borc=muavin_borc+amount></cf_wrk_html_td>
							<cf_wrk_html_td align="right" style="text-align:right;"></cf_wrk_html_td>
							<cfset bakiye = bakiye + amount><cfset dev_borc = dev_borc + amount>
							<cfelse><!--- alacak --->
							<cf_wrk_html_td align="right" style="text-align:right;"></cf_wrk_html_td>
							<cf_wrk_html_td align="right" style="text-align:right;" format="numeric">#TLFormat(amount)#<cfset muavin_alacak=muavin_alacak+amount></cf_wrk_html_td>
							<cfset bakiye = bakiye - amount><cfset dev_alacak = dev_alacak + amount >
							</cfif>
							<cf_wrk_html_td align="right" style="text-align:right;" format="numeric">#TLFormat(abs(bakiye))#</cf_wrk_html_td>
							<cf_wrk_html_td align="right" style="text-align:right;"><cfif bakiye gte 0>(B)<cfelse>(A)</cfif></cf_wrk_html_td>
						</cf_wrk_html_tr>
						<cfif len(attributes.pdf_page_row) and attributes.pdf_page_row neq 0 and (satir_sayisi mod attributes.pdf_page_row) eq 1><!--- satır sayısı belirtilmisse sayfalama yapılıyor --->
							<cf_wrk_html_page_break>	
							<cfif (satir_sayisi mod page_count_) eq 1>
								<cf_wrk_html_sheet_break>
							</cfif>						
								<cfif isdefined("attributes.is_show_cumulative_sum") and attributes.is_show_cumulative_sum eq 1>
									<cf_wrk_html_tr class="txtbold">
									<cfset satir_sayisi=satir_sayisi+1>
										<cf_wrk_html_td width="435" colspan="5"></cf_wrk_html_td>
										<cf_wrk_html_td width="125" align="center"><cf_get_lang dictionary_id='60795.Devreden Borç'></cf_wrk_html_td>
										<cf_wrk_html_td width="125" align="center"><cf_get_lang dictionary_id='60796.Devreden Alacak'></cf_wrk_html_td>
										<cf_wrk_html_td width="155"></cf_wrk_html_td>
									</cf_wrk_html_tr>					
									<cf_wrk_html_tr class="txtbold">
									<cfset satir_sayisi=satir_sayisi+1>
										<cf_wrk_html_td width="435" colspan="5">;<cf_get_lang dictionary_id='60797.Devreden Küm. Toplam'></cf_wrk_html_td>
										<cf_wrk_html_td width="125" align="right" style="text-align:right;" format="numeric"><cfoutput>#TLFormat(muavin_borc)#</cfoutput></cf_wrk_html_td>
										<cf_wrk_html_td width="125" align="right" style="text-align:right;" format="numeric"><cfoutput>#TLFormat(muavin_alacak)#</cfoutput></cf_wrk_html_td>
										<cf_wrk_html_td width="155"></cf_wrk_html_td>
									</cf_wrk_html_tr>
								</cfif>
						</cfif>
					</cfoutput>
					<cf_wrk_html_tr class="txtbold">
						<cfset satir_sayisi=satir_sayisi+1>
						<cf_wrk_html_td colspan="6" align="right" style="text-align:right;" class="txtbold"><cf_get_lang dictionary_id='57492.Toplam'>:</cf_wrk_html_td>
						<cf_wrk_html_td align="center" style="text-align:right;" class="txtbold" format="numeric"><cfoutput>#TLFormat(Evaluate(dev_borc))#</cfoutput></cf_wrk_html_td>
						<cf_wrk_html_td align="right" style="text-align:right;" class="txtbold" format="numeric"><cfoutput>#TLFormat(Evaluate(dev_alacak))#</cfoutput></cf_wrk_html_td>
						<cf_wrk_html_td align="right" style="text-align:right;" class="txtbold" format="numeric">
							<cfoutput>#TLFormat(abs(evaluate(bakiye)))#</cfoutput>
						</cf_wrk_html_td>
						<cf_wrk_html_td align="right" style="text-align:right;" class="txtbold">
							<cfif bakiye gte 0>(B)<cfelse>(A)</cfif>
						</cf_wrk_html_td>
					</cf_wrk_html_tr>
					<cfset toplam_borc = toplam_borc + dev_borc>
					<cfset toplam_alacak = toplam_alacak + dev_alacak>
					<cfset toplam_bakiye = toplam_bakiye + bakiye>
					<cfif len(attributes.pdf_page_row) and attributes.pdf_page_row neq 0 and (satir_sayisi mod attributes.pdf_page_row) eq 1><!--- satır sayısı belirtilmisse sayfalama yapılıyor --->
					<cf_wrk_html_page_break>	
					<cfif (satir_sayisi mod page_count_) eq 1>
						<cf_wrk_html_sheet_break>
					</cfif>			
							<cfif isdefined("attributes.is_show_cumulative_sum") and attributes.is_show_cumulative_sum eq 1>
								<cf_wrk_html_tr class="txtbold">
								<cfset satir_sayisi=satir_sayisi+1>
									<cf_wrk_html_td width="435" colspan="5"></cf_wrk_html_td>
									<cf_wrk_html_td width="125" align="center"><cf_get_lang dictionary_id='60795.Devreden Borç'></cf_wrk_html_td>
									<cf_wrk_html_td width="125" align="center"><cf_get_lang dictionary_id='60796.Devreden Alacak'></cf_wrk_html_td>
									<cf_wrk_html_td width="155"></cf_wrk_html_td>
								</cf_wrk_html_tr>					
								<cf_wrk_html_tr class="txtbold">
								<cfset satir_sayisi=satir_sayisi+1>
									<cf_wrk_html_td width="435" colspan="5"><cf_get_lang dictionary_id='60797.Devreden Küm. Toplam'></cf_wrk_html_td>
									<cf_wrk_html_td width="125" align="right" style="text-align:right;" format="numeric"><cfoutput>#TLFormat(muavin_borc)#</cfoutput></cf_wrk_html_td>
									<cf_wrk_html_td width="125" align="right" style="text-align:right;" format="numeric"><cfoutput>#TLFormat(muavin_alacak)#</cfoutput></cf_wrk_html_td>
									<cf_wrk_html_td width="155"></cf_wrk_html_td>
								</cf_wrk_html_tr>
							</cfif>
					</cfif> 
				<cfelse>
					<cf_wrk_html_tr class="txtbold" valign="top" height="20">
						<cfset satir_sayisi=satir_sayisi+1>
						<cf_wrk_html_td colspan="8"><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</cf_wrk_html_td>
					</cf_wrk_html_tr>
					<cfif len(attributes.pdf_page_row) and attributes.pdf_page_row neq 0 and (satir_sayisi mod attributes.pdf_page_row) eq 1><!--- satır sayısı belirtilmisse sayfalama yapılıyor --->
					<cf_wrk_html_page_break>
					<cfif (satir_sayisi mod page_count_) eq 1>
						<cf_wrk_html_sheet_break>
					</cfif>			
						<cfif isdefined("attributes.is_show_cumulative_sum") and attributes.is_show_cumulative_sum eq 1>
							<cf_wrk_html_tr class="txtbold">
							<cfset satir_sayisi=satir_sayisi+1>
								<cf_wrk_html_td width="435" colspan="5"></cf_wrk_html_td>
								<cf_wrk_html_td width="125" align="center"><cf_get_lang dictionary_id='60795.Devreden Borç'></cf_wrk_html_td>
								<cf_wrk_html_td width="125" align="center"><cf_get_lang dictionary_id='60796.Devreden Alacak'></cf_wrk_html_td>
								<cf_wrk_html_td width="155"></cf_wrk_html_td>
							</cf_wrk_html_tr>					
							<cf_wrk_html_tr>
							<cfset satir_sayisi=satir_sayisi+1>
								<cf_wrk_html_td width="435" colspan="5"><cf_get_lang dictionary_id='60797.Devreden Küm. Toplam'></cf_wrk_html_td>
								<cf_wrk_html_td width="125" align="right" style="text-align:right;" format="numeric"><cfoutput>#TLFormat(muavin_borc)#</cfoutput></cf_wrk_html_td>
								<cf_wrk_html_td width="125" align="right" style="text-align:right;" format="numeric"><cfoutput>#TLFormat(muavin_alacak)#</cfoutput></cf_wrk_html_td>
								<cf_wrk_html_td width="155"></cf_wrk_html_td>
							</cf_wrk_html_tr>
						</cfif>	
					</cfif> 
				</cfif>
		</cfloop>
		</cf_wrk_html_table>
	<cfelse>
        <cfinclude template="rapor_muavin_pdf.cfm">
    </cfif>
	<cfsetting enablecfoutputonly="no">
	</cfprocessingdirective>
</cfif>
<script language="javascript">
	function control() {
		if ((document.search__.date1.value != '') && (document.search__.date2.value != '') &&
	    !date_check(search__.date1,search__.date2,"<cf_get_lang dictionary_id ='39814.Başlangıç Tarihi Bitiş Tarihinden Küçük Olmalıdır'>!"))
	        return false;
	}
	<!--- <cfif isdefined("attributes.is_submitted") >
		<cfif isdefined('attributes.filetype') and (attributes.filetype is 'excel')> 
			<cfif isdefined("get_account_id.query_count") and get_account_id.query_count neq  get_account_id.recordcount >
				function submitForm() 
				{ 
					// submits form
					document.forms["search__"].submit();
				}
				if (document.getElementById("search__")) 
					{
						setTimeout("submitForm()", 5000); // set timout 
					}
			</cfif>
		</cfif>
	</cfif>	 --->
	function pencere_ac_muavin(str_alan_1,str_alan_2,str_alan){
		var txt_keyword = eval(str_alan_1 + ".value" );
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan_all&field_id='+str_alan_1+'&field_id2='+str_alan_1+'&keyword='+txt_keyword,'list');
	}
</script>
<cfif isdefined('attributes.filetype') and (attributes.filetype is 'excel')>
	<!--- <cfif isdefined("get_account_id.query_count") and isdefined("get_account_id.recordcount")  and get_account_id.query_count eq get_account_id.recordcount > --->
        <cfzip file="#upload_folder#/reserve_files/#session.ep.userid#_zip/#zip_filename#" source="#upload_folder#/reserve_files/#dateFormat(now(),'yyyymmdd')#/#filename#.xlsx">

        <script type="text/javascript">
				<cfoutput>
					get_wrk_message_div("#getLang('main',1931)#","#getLang('main',1934)#","/documents/reserve_files/#session.ep.userid#_zip/#zip_filename#")  
				</cfoutput>
		    </script>
        <cfdirectory action="delete" directory="#upload_folder#reserve_files/#session.ep.userid#" recurse="yes">
   <!---  </cfif> --->
</cfif>
