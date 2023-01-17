<cf_form_box title="#getLang('main',1111)#">
<cfform name="formexport" enctype="multipart/form-data" method="post" action="#request.self#?fuseaction=settings.import_seri_no_subscription">
	<cf_area width="300">
        <table>
            <tr>
                <td><cf_get_lang no='1402.Belge Formatı'></td>
                <td>
                    <select name="file_format" id="file_format" style="width:200px;">
                        <option value="utf-8"><cf_get_lang no='1405.UTF-8'></option>
                        <option value="iso-8859-9"><cf_get_lang no='1403.ISO-8859-9 (Türkçe)'></option>
                    </select>
                </td>
            </tr>
            <tr>
                <td><cf_get_lang_main no='56.Belge'>*</td>
                <td><input type="file" name="uploaded_file" id="uploaded_file" style="width:200px;"></td>
            </tr>
            <tr>
                    <td><cf_get_lang no='1688.Örnek Ürün Dosyası'></td>
                    <td><a  href="/IEF/standarts/import_example_file/seri_no_aktarim.csv"><strong><cf_get_lang no='1692.İndir'></strong></a></td>
             </tr>
        </table>
    </cf_area>
	<cf_area>
    	<table>
        	<tr height="30">
                <td class="headbold" valign="top"><cf_get_lang_main no='1182.Format'></td>
            </tr>
            <tr>
            	<td>
                    <span class="formbold"><cf_get_lang no ='2164.Dosya İçeriği'></span><br/><br/>
                    * <cf_get_lang no ='2170.Dosya Virgüller İle Ayrılmış txt formatında olmalıdır'>! <br/>
                    *<cf_get_lang no ='2171.Dosya içersindeki elemanlar virgül sayısına göre alınacağı için boş geçilecek eleman içinde ,, şeklinde diziliş tamamlanmalıdır'>!<br/><br/>
                    <span class="formbold"><cf_get_lang no ='2165.Eleman Sırası'></span><br/><br/>
                    1- <cf_get_lang_main no ='225.Seri No'><br/>
                    2- <cf_get_lang_main no ='106.Stok Kodu'> (<cf_get_lang_main no='2004.Zorunlu'>)<br/>
                    3- <cf_get_lang_main no ='1705.abone Kodu'> (<cf_get_lang_main no='2004.Zorunlu'>)<br/>
                    4- Satış Garanti Kategorisi Id (<cf_get_lang_main no='2004.Zorunlu'>)<br />
                    5- <cf_get_lang no ='2168.Garanti Başlama Tarihi'>  - gg.aa.yyyy (<cf_get_lang_main no='2004.Zorunlu'>)
                </td>
            </tr>
       </table>         
    </cf_area>
    <cf_form_box_footer>
    	<cf_workcube_buttons is_upd='0'>
    </cf_form_box_footer>
</cfform>
</cf_form_box>
<cfif isdefined("attributes.file_format")>
<cfset upload_folder = "#upload_folder#temp#dir_seperator#">
        <cftry>
            <cffile action = "upload" 
                    fileField = "uploaded_file" 
                    destination = "#upload_folder#"
                    nameConflict = "MakeUnique"  
                    mode="777" charset="#attributes.file_format#">
            <cfset file_name = "#createUUID()#.#cffile.serverfileext#">	
            
            <cffile action="rename" source="#upload_folder##cffile.serverfile#" destination="#upload_folder##file_name#" charset="#attributes.file_format#">
            
            <cfset file_size = cffile.filesize>
            <cfcatch type="Any">
                <script type="text/javascript">
                    alert("<cf_get_lang_main no='43.Dosyanız Upload Edilemedi ! Dosyanızı Kontrol Ediniz '>!");
                    history.back();
                </script>
                <cfabort>
            </cfcatch>  
        </cftry>
        
        <cftry>
            <cffile action="read" file="#upload_folder##file_name#" variable="dosya" charset="#attributes.file_format#">
            <cffile action="delete" file="#upload_folder##file_name#">
        <cfcatch>
            <script type="text/javascript">
                alert("Dosya Okunamadı ! Karakter Seti Yanlış Seçilmiş Olabilir.");
                history.back();
            </script>
            <cfabort>
        </cfcatch>
        </cftry>
        
        <cfscript>
            CRLF = Chr(13) & Chr(10);// satır atlama karakteri
            dosya = Replace(dosya,',,',', ,','all');
            dosya = Replace(dosya,',,',', ,','all');
            dosya = ListToArray(dosya,CRLF);
            line_count = ArrayLen(dosya);
            counter = 0;
            liste = "";
        </cfscript>
    <cfset my_is_purchase = 0>
    <cfset my_is_sale = 0>
    <cfset my_in_out = 0>
    <cfset islem_date_ = now()>
    <cfloop from="2" to="#line_count#" index="i">
        <cftry>
            <cfscript>
                error_flag = 0;
                counter = counter + 1;
                satir=dosya[i];
                seri_no_ = trim(listgetat(satir,1,";"));
                stock_code_ = trim(listgetat(satir,2,";"));
				sub_code = trim(listgetat(satir,3,";"));
                baslama_tarihi_=trim(listgetat(satir,5,";"));
            </cfscript>
            <cfcatch type="Any">
                <cfoutput>#i#. satırda okuma sırasında hata oldu.</cfoutput><br />
            </cfcatch>
        </cftry>
        <cftry>
            <cfquery name="get_stock_" datasource="#dsn3#" maxrows="1">
                SELECT STOCK_ID,PRODUCT_ID FROM STOCKS WHERE STOCK_CODE = '#stock_code_#'
            </cfquery>
            <cfquery name="get_guaranty" datasource="#dsn3#">
                SELECT SALE_GUARANTY_CAT_ID FROM PRODUCT_GUARANTY WHERE PRODUCT_ID = #get_stock_.PRODUCT_ID#
            </cfquery>
            <cfset baslama_tarihi_ = replace(baslama_tarihi_,'.','/','all')>
            <cf_date tarih="baslama_tarihi_">
            <cfif get_guaranty.recordcount>
                <cfquery name="get_guaranty_time_" datasource="#dsn3#">
                    SELECT (SELECT GUARANTYCAT_TIME FROM #dsn_alias#.SETUP_GUARANTYCAT_TIME WHERE GUARANTYCAT_TIME_ID = SETUP_GUARANTY.GUARANTYCAT_TIME) GUARANTYCAT_TIME_ 
                    FROM  
                    #dsn_alias#.SETUP_GUARANTY
                     WHERE 
                     GUARANTYCAT_ID = #get_guaranty.SALE_GUARANTY_CAT_ID#
                </cfquery>
                <cfif isdefined("baslama_tarihi_") and isdate(baslama_tarihi_) and isdefined("get_guaranty_time_.GUARANTYCAT_TIME_") and Len(get_guaranty_time_.GUARANTYCAT_TIME_)>
                    <cfset temp_date = date_add("m",get_guaranty_time_.GUARANTYCAT_TIME_,baslama_tarihi_)>
                </cfif>
            </cfif>
            <cfquery name="get_member1" datasource="#dsn3#">
                SELECT COMPANY_ID,SUBSCRIPTION_ID FROM SUBSCRIPTION_CONTRACT WHERE SUBSCRIPTION_NO = '#sub_code#'
            </cfquery>
            <cfif get_member1.recordcount>
                <cfquery name="get_member" datasource="#dsn#">
                    SELECT COMPANY_ID,MANAGER_PARTNER_ID FROM COMPANY WHERE COMPANY_ID = #get_member1.COMPANY_ID#
                </cfquery>   
            </cfif>
            <cfif get_stock_.recordcount>
                <cflock name="#CreateUUID()#" timeout="90">
                    <cftransaction>
                        <cfquery name="add_guaranty" datasource="#dsn3#" result="MAX_ID">
                            INSERT INTO 
                                SERVICE_GUARANTY_NEW
                            (
                                STOCK_ID,
                                SALE_GUARANTY_CATID,
                                SALE_START_DATE,
                                SALE_FINISH_DATE,
                                SALE_COMPANY_ID,
                                SALE_PARTNER_ID,
                                IN_OUT,
                                IS_SALE,
                                IS_PURCHASE,
                                IS_SERVICE,
                                IS_SARF,
                                IS_RMA,
                                PROCESS_ID,
                                PROCESS_NO,
                                PROCESS_CAT,
                                PERIOD_ID,
                                SERIAL_NO,
                                RECORD_EMP,
                                RECORD_IP,
                                RECORD_DATE,
                                RMA_NO,
                                REFERENCE_NO,
                                IS_SERI_SONU,
                                IS_RETURN,
                                LOT_NO
                              				
                            )
                            VALUES
                            (
                                #get_stock_.STOCK_ID#,
                                #get_guaranty.SALE_GUARANTY_CAT_ID#,
                                #baslama_tarihi_#,
                                <cfif isdefined("temp_date")>#temp_date#<cfelse>NULL</cfif>,
                                <cfif isdefined("get_member.company_id")>#get_member.company_id#<cfelse>NULL</cfif>,
                                <cfif isdefined("get_member.manager_partner_id")>#get_member.manager_partner_id#<cfelse>NULL</cfif>,
                                #my_in_out#,
                                #my_is_sale#,
                                #my_is_purchase#,
                                0,
                                0,
                                0,
                                #get_member1.SUBSCRIPTION_ID#,
                                '#sub_code#',
                                1193,
                                #session.ep.period_id#,
                                '#trim(seri_no_)#',
                                #SESSION.EP.USERID#,
                                '#CGI.REMOTE_ADDR#',
                                #islem_date_#,
                                '',
                                '',
                                0,
                                0,
                                ''
                            )
                        </cfquery>
                    </cftransaction>
                </cflock>
            <cfelse>
                <cfoutput>#i#. satırda yazma sırasında stok bulunamadı!</cfoutput>
            </cfif>
            <cfcatch type="Any">
                <cfoutput>#i#. satırda yazma sırasında hata oldu.</cfoutput>
            </cfcatch>
        </cftry>
    </cfloop>
    <script type="text/javascript">
        alert("<cf_get_lang no ='2510.Aktarım Tamamland'>");
        window.location.href='<cfoutput>#request.self#</cfoutput>?fuseaction=settings.import_seri_no_subscription';
    </script>
</cfif>
