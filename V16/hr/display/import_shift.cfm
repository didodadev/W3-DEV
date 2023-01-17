<cf_get_lang_set module_name="settings"><!--- sayfanin en altinda kapanisi var --->
    <cfif not isdefined('attributes.uploaded_file')>
        <cfsavecontent variable="message"><cf_get_lang dictionary_id='61512.Vardiya İmport'></cfsavecontent>
        <cf_box title="#message#" closable="1" draggable="1" popup_box="1">
            <cfform name="formimport" action="#request.self#?fuseaction=hr.import_shift" enctype="multipart/form-data" method="post">
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
                                    <cf_get_lang dictionary_id='35508.Belgede toplam 4 alan olacaktır alanlar sırasi ile'>;<br/><br/>
                                    1-<cf_get_lang dictionary_id='58487.Çalışan No'>(<cf_get_lang dictionary_id='32328.Sicil No'>)<br />
                                        <br/>
                                    2-<cf_get_lang dictionary_id='53063.Vardiya'><cf_get_lang dictionary_id='58527.ID'><br />
                                        <br/>
                                    3-<cf_get_lang dictionary_id='58053.Başlangıç Tarihi'>:15.06.2007 <cf_get_lang dictionary_id ='44253.formatında olmalıdır'>.<br />
                                        <br/>
                                    4-<cf_get_lang dictionary_id='57700.Bitiş Tarihi'>:15.06.2007 <cf_get_lang dictionary_id ='44253.formatında olmalıdır'>.<br />
                                            <br/>
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
                //Çalışan ID
                employee_id = Listgetat(dosya[i],j,";");
                employee_id =trim(employee_id);
                j=j+1;
                //Vardiya ID
                shift_id = Listgetat(dosya[i],j,";");
                shift_id =trim(shift_id);
                j=j+1;

                 //Baslangıc Tarihi
                 start_date = Listgetat(dosya[i],j,";");
                 start_date =trim(start_date);
                 j=j+1;
                 //Bitiş Tarihi
                 finish_date = Listgetat(dosya[i],j,";");
                 finish_date =trim(finish_date);

                 if(len(start_date) and (start_date neq 0) and isdate(start_date)) start_date=dateformat(start_date,dateformat_style);
                 if(len(finish_date) and (finish_date neq 0) and isdate(finish_date)) finish_date=dateformat(finish_date,dateformat_style);
                </cfscript>

                <cfcatch type="Any">
                    <cfset liste=ListAppend(liste,i&'. satırda okuma sırasında hata oldu <br/>',',')>
                    <cfoutput>#i#</cfoutput>. <cf_get_lang dictionary_id='58508.satır'> <cf_get_lang dictionary_id='44947.Birinci adımda sorun oluştu'><br/>
                    <cfset error_flag = 1>
                </cfcatch>
            </cftry>
             <cfif len(employee_id) and len(shift_id) and len(start_date) and len(finish_date) and error_flag neq 1>
                <cfquery name="GET_EMP_SHIFT" maxrows="1" datasource="#dsn#">
                    SELECT 
                        EIO.IS_VARDIYA,
                        EIO.EMPLOYEE_ID
                    FROM
                        EMPLOYEES E
                        LEFT JOIN EMPLOYEES_IN_OUT EIO ON EIO.EMPLOYEE_ID = E.EMPLOYEE_ID
                    WHERE
                        E.EMPLOYEE_NO = <cfqueryparam cfsqltype="cf_sql_nvarchar" value='#employee_id#'>
                    ORDER BY
                        EIO.IN_OUT_ID DESC
                </cfquery>
                <cfif GET_EMP_SHIFT.IS_VARDIYA eq 1 or GET_EMP_SHIFT.IS_VARDIYA eq 2>
                    <cftry>
                        <cfquery name="control" datasource="#dsn#">
                            SELECT 
                                START_DATE, 
                                FINISH_DATE, 
                                SETUP_SHIFT_EMPLOYEE_ID, 
                                SHIFT_ID  
                            FROM 
                                SETUP_SHIFT_EMPLOYEE 
                            WHERE 
                                EMPLOYEE_ID = #GET_EMP_SHIFT.employee_id# 
                                AND ((START_DATE <= #CreateODBCDateTime(start_date)# AND FINISH_DATE >= #CreateODBCDateTime(finish_date)#) 
                                OR (START_DATE >= #CreateODBCDateTime(start_date)# AND START_DATE <= #CreateODBCDateTime(finish_date)# AND FINISH_DATE <= #CreateODBCDateTime(finish_date)#) 
                                OR ( START_DATE <= #CreateODBCDateTime(start_date)# AND FINISH_DATE >= #CreateODBCDateTime(start_date)# AND FINISH_DATE <= #CreateODBCDateTime(finish_date)#) 
                                OR ( START_DATE >= #CreateODBCDateTime(start_date)# AND FINISH_DATE <= #CreateODBCDateTime(finish_date)#) 
                                OR ( START_DATE >= #CreateODBCDateTime(start_date)# AND FINISH_DATE >= #CreateODBCDateTime(finish_date)# AND START_DATE <= #CreateODBCDateTime(finish_date)# ))
                        </cfquery>
                        <cfif control.recordcount eq 0>
                            <cfquery name="importModel" datasource="#dsn#">
                                INSERT INTO
                                    SETUP_SHIFT_EMPLOYEE
                                    (
                                        EMPLOYEE_ID
                                        ,SHIFT_ID
                                        ,START_DATE
                                        ,FINISH_DATE
                                    )
                                VALUES
                                    (
                                    <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_EMP_SHIFT.employee_id#">,
                                    <cfqueryparam cfsqltype="cf_sql_integer" value="#shift_id#">,
                                    <cfif len(start_date) and (start_date neq 0) and isdate(start_date)>#CreateODBCDateTime(start_date)#<cfelse>NULL</cfif>,
                                    <cfif len(finish_date) and (finish_date neq 0) and isdate(finish_date)>#CreateODBCDateTime(finish_date)#<cfelse>NULL</cfif>
                                    )
                            </cfquery>
                        <cfelse>
                             <cfset liste=ListAppend(liste,i&'. #employee_id# Çalışanın  #start_date# - #finish_date# tarihleri arasında çakışan vardiyası vardır<br/>',',')>	
                        </cfif>
                    <cfcatch type="Any">
                            <cfset liste=ListAppend(liste,i&'. satırda kayıt sırasında hata oldu <br/>',',')>
                            <cfoutput>#i#</cfoutput>. <cf_get_lang dictionary_id='58508.satır'> <cf_get_lang dictionary_id='44948.İkinci adımda sorun oluştu'><br/>
                        </cfcatch>
                    </cftry>
                <cfelse>
                    <cfset liste=ListAppend(liste,i&'. satırdaki #employee_id# ID li Çalışan vardiyalı olarak çalışmamaktadır. <br/>',',')>
                </cfif>
            <cfelse>
                <cfset liste=ListAppend(liste,i&'. satırın çalışan id ,vardiya id , baslangıc tarihi veya bitis tarihi alanlarından herhangi biri eksiktir <br/>',',')>	
            </cfif>
        </cfloop>
        <cfoutput>#liste#</cfoutput>
        <cfif error_flag neq 1>
            <cf_get_lang dictionary_id='44519.İŞLEM TAMAMLANDI'> (<cf_get_lang dictionary_id='44949.SAYFAYI YENİLEMEYİNİZ HATALI KAYIT VARSA ONLARI İNCELEYEREK SAYFAYI KAPATINIZ'>)......
        </cfif>
    </cfif>
    <cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
    