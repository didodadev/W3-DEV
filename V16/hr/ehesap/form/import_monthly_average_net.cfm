<cf_get_lang_set module_name="settings"><!--- sayfanin en altinda kapanisi var --->
    <cfif not isdefined('attributes.uploaded_file')>
        <cfsavecontent variable="message"><cf_get_lang dictionary_id="61253.Aylık Ortalama Net Aktarım"></cfsavecontent>
        <cf_box title="#message#" closable="1" draggable="1">
            <cfform name="formimport" action="#request.self#?fuseaction=ehesap.import_monthly_average_net" enctype="multipart/form-data" method="post">
               <cf_box_elements>
                <div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="false">
                        <div class="form-group" id="item-file_format">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='43385.Belge Formatı'></label>
                            <div class="col col-8 col-xs-12"> 
                                <select name="file_format" id="file_format">
                                    <option value="UTF-8"><cf_get_lang dictionary_id='43388.UTF-8'></option>
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="item-uploaded_file">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57468.Belge'> *</label>
                            <div class="col col-8 col-xs-12"> 
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id ='32871.Belge Seçiniz'> !</cfsavecontent>
                                <cfinput type="file" name="uploaded_file" required="yes" message="#message#" style="width:197px;">
                            </div>
                        </div>
                    </div>
                    <div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="2" sort="false">
                        <div class="form-group">
                            <label class="col col-12 bold"><cf_get_lang dictionary_id='58594.Format'></label>
                        </div>
                        <div class="form-group" id="item-format">
                            <div class="col col-12"> 
                                    <cf_get_lang dictionary_id ='35657.Dosya uzantısı csv olacak ve alan araları noktalı virgül (;) ile ayrılacaktır'>
                                    <cf_get_lang dictionary_id ='44193.Aktarım işlemi dosyanın 2 satırından itibaren başlar bu yüzden birinci satırda alan isimleri olmalıdır'>.<br/>
                                    <cf_get_lang dictionary_id ="61255.Aylık Ortalama Net ondalık şekilde yazılacaksa (.) kullanılmalıdır, (,) kullanılmamalıdır."><br />
                                    <cf_get_lang dictionary_id ="35628.Belgede toplam 2 sutun olacaktır alanlar sırasi ile">;<br/><br/>
                                    1-<cf_get_lang dictionary_id ="51231.Sicil No">*<br/>
                                    2-<cf_get_lang dictionary_id ="61254.Aylık Ortalama Net : 125.23 formatında girilmelidir."><br/>
                            </div>
                        </div>
                    </div>
                </cf_box_elements> 
                <cf_box_footer>
                    <cf_workcube_buttons is_upd='0' add_function='kontrol()'>
                </cf_box_footer>
            </cfform>
        </cf_box>
        <script type="text/javascript">
            function kontrol()
            {
                if(formimport.uploaded_file.value.length==0)
                {
                    alert("<cf_get_lang dictionary_id='43424.Belge Seçiniz'>!");
                    return false;
                }
                    return true;
            }
        </script>
    <cfelse>
        <cfsetting showdebugoutput="no">
        <cfset upload_folder_ = "#upload_folder#temp#dir_seperator#">
        <cftry>
            <cffile action = "upload" 
                    filefield = "uploaded_file" 
                    destination = "#upload_folder_#"
                    nameconflict = "MakeUnique"  
                    mode="777" charset="#attributes.file_format#">
            <cfset file_name = "#createUUID()#.#cffile.serverfileext#">	
            <cffile action="rename" source="#upload_folder_##cffile.serverfile#" destination="#upload_folder_##file_name#" charset="#attributes.file_format#">	
            <cfset file_size = cffile.filesize>
            <cfcatch type="Any">
                <cfdump var="#cfcatch#" abort>
                <script type="text/javascript">
                    alert("<cf_get_lang dictionary_id='57455.Dosyanız Upload Edilemedi ! Dosyanızı Kontrol Ediniz'>.");
                    history.back();
                </script>
                <cfabort>
            </cfcatch>  
        </cftry>
        <cftry>
            <cffile action="read" file="#upload_folder_##file_name#" variable="dosya" charset="#attributes.file_format#">
            <cffile action="delete" file="#upload_folder_##file_name#">
        <cfcatch>
            <script type="text/javascript">
                alert("<cf_get_lang dictionary_id='29450.Dosya Okunamadı! Karakter Seti Yanlış Seçilmiş Olabilir.'>");
                history.back();
            </script>
            <cfabort>
        </cfcatch>
        </cftry>
        
        <cfscript>
            CRLF = Chr(13) & Chr(10);// satır atlama karakteri
            dosya = Replace(dosya,';;','; ;','all');
            dosya = Replace(dosya,';;','; ;','all');
            dosya = ListToArray(dosya,CRLF);
            line_count = ArrayLen(dosya);
            counter = 0;
            liste = "";
        </cfscript>
    
        <cfloop from="2" to="#line_count#" index="i">
            <cfset j= 1>
            <cfset error_flag = 0>
            <cftry>
                <cfscript>
                counter = counter + 1;
                //Sicil no
                sicil_no = Listgetat(dosya[i],j,";");
                sicil_no =trim(sicil_no);
                j=j+1;
                //Kümüle Vergi Tutarı
                aylik_ort_net = Listgetat(dosya[i],j,";");
                aylik_ort_net =trim(aylik_ort_net);
                j=j+1;
                </cfscript>
                
                <cfcatch type="Any">
                    <cfset liste=ListAppend(liste,i&'. satırda okuma sırasında hata oldu <br/>',',')>
                    <cfoutput>#i#</cfoutput>. <cf_get_lang dictionary_id='58508.satır'> <cf_get_lang dictionary_id='44947.Birinci adımda sorun oluştu'><br/>
                    <cfset error_flag = 1>
                </cfcatch>
            </cftry>
             <cfif len(sicil_no) and len(aylik_ort_net) and error_flag neq 1>
                    <cfquery name="GET_EMPLOYEE_INFO" maxrows="1" datasource="#dsn#">
                        SELECT 
                            EIO.IN_OUT_ID,
                            EIO.EMPLOYEE_ID
                        FROM
                            EMPLOYEES_IN_OUT EIO,
                            EMPLOYEES E
                        WHERE
                            EIO.EMPLOYEE_ID = E.EMPLOYEE_ID AND
                            E.EMPLOYEE_NO = '#sicil_no#'
                        ORDER BY
                            EIO.IN_OUT_ID DESC
                    </cfquery>
                    <cfif GET_EMPLOYEE_INFO.recordcount>
                        <cftry>
                            <cfquery datasource="#dsn#" name="UPD_MONTHLY_AVERAGE_NET">
                                UPDATE
                                    EMPLOYEES_IN_OUT
                                SET 
                                    MONTHLY_AVERAGE_NET = #aylik_ort_net#
                                WHERE 
                                    IN_OUT_ID = #GET_EMPLOYEE_INFO.IN_OUT_ID#
                            </cfquery>
                        <cfcatch type="Any">
                                <cfset liste=ListAppend(liste,i&'. satırda kayıt sırasında hata oldu <br/>',',')>
                                <cfoutput>#i#</cfoutput>. <cf_get_lang dictionary_id='58508.satır'> <cf_get_lang dictionary_id='44948.İkinci adımda sorun oluştu'><br/>
                            </cfcatch>
                        </cftry>
                    <cfelse>
                        <cfset liste=ListAppend(liste,i&'. satırın employee_id veya in_out_id si yok <br/>',',')>
                    </cfif>
            <cfelse>
                <cfset liste=ListAppend(liste,i&'. satırın sicil no ,aylık ortalama net maaşı alanlarından herhangi biri eksiktir <br/>',',')>	
            </cfif>
        </cfloop>
        <cfoutput>#liste#</cfoutput>
        <cfif error_flag neq 1>
            <cf_get_lang dictionary_id='44519.İŞLEM TAMAMLANDI'> (<cf_get_lang dictionary_id='44949.SAYFAYI YENİLEMEYİNİZ HATALI KAYIT VARSA ONLARI İNCELEYEREK SAYFAYI KAPATINIZ'>)......
        </cfif>
    </cfif>
    <cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
    