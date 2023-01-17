<cf_get_lang_set module_name="settings"><!--- sayfanin en altinda kapanisi var --->

<cfset controlDataImport = createObject("component","WDO.development.cfc.data_import_library").getData(fuseaction : attributes.fuseaction) />
<cfset type_names = "#getLang('dictionary_id','Logo',58637)#,#getLang('dictionary_id','Mikro',62669)#,#getLang('dictionary_id','SAP Hana',62670)#,
                    #getLang('dictionary_id','Netsis',62671)#,#getLang('dictionary_id','Eta',62672)#,#getLang('dictionary_id','NetSuite',62673)#,
                    #getLang('dictionary_id','SAP Business One',62674)#,#getLang('dictionary_id','Workday',62671)#" />

<cfsavecontent variable="message"><cf_get_lang dictionary_id='43256.Çalışan Aktarım'></cfsavecontent>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box title="#message#">
        <cfform name="formimport" enctype="multipart/form-data" method="post" action="#request.self#?fuseaction=ehesap.emptypopup_import_employee">
        <input type="hidden" name="html_file" id="html_file" value="<cfoutput>#createUUID()#</cfoutput>.html">
            <cf_box_elements>
                <div class="col col-4 col-md-4 col-sm-4 col-xs-12" type="column" index="1" sort="true">
                    <div class="form-group" id="item-file_format">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='43385.Belge Formatı'></label>
                        <div class="col col-6 col-md-8 col-sm-8 col-xs-12">
                            <select name="file_format" id="file_format" style="width:200px;">
                                <option value="utf-8"><cf_get_lang dictionary_id='43388.UTF-8'></option>
                                <cfif controlDataImport.recordcount>
                                    <option value="data_import"><cf_get_lang dictionary_id='62732.Data İmport Library'></option>
                                </cfif>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-uploaded_file">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57468.Belge'>*</label>
                        <div class="col col-6 col-md-8 col-sm-8 col-xs-12">
                            <input type="file" name="uploaded_file" id="uploaded_file" style="width:200px;">
                        </div>
                    </div>
                    <div class="form-group" id="item-download-link">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='43671.Örnek Ürün Dosyası'></label>
                        <div class="col col-6 col-md-8 col-sm-8 col-xs-12">
                            <a  href="/IEF/standarts/import_example_file/calisan_aktarim.csv"><cf_get_lang dictionary_id='43675.İndir'></a>
                        </div>
                    </div>
                    <div class="form-group" id="item-process">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id="58859.Süreç">*</label>
                        <div class="col col-6 col-md-8 col-sm-8 col-xs-12">
                            <cf_workcube_process is_upd='0' process_cat_width='200' is_detail='0'>
                        </div>
                    </div>
                    <cfif controlDataImport.recordcount>
                        <div id="data_import_library" style="display:none;">
                            <cf_seperator title="#getLang('','Data İmport Library',62732)#" id="detail_data_import">
                            <div style="display: none;" id="detail_data_import">
                                <div class="form-group" id="item-data_import_library">
                                    <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='62732.Data İmport Library'>*</label>
                                    <div class="col col-6 col-md-8 col-sm-8 col-xs-12">
                                        <select name="import_id" id="import_id" type_id="">
                                            <option value="" type_id=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                            <cfoutput query="controlDataImport">
                                                <option value="#DATA_IMPORT_ID#" type_id="#TYPE#">#NAME# - #listGetAt(type_names,TYPE)#</option>
                                            </cfoutput>
                                        </select>
                                    </div>
                                </div>
                                <div class="form-group" id="item-data_import_dsn">
                                    <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='62668.DATA SOURCE'>*</label>
                                    <div class="col col-6 col-md-8 col-sm-8 col-xs-12">
                                        <select name="import_dsn" id="import_dsn">
                                            <option value=""><cf_get_lang dictionary_id='62851.Lütfen import tipi seçiniz'></option>
                                        </select>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </cfif>
                </div>
                <div class="col col-8 col-md-8 col-sm-8 col-xs-12" type="column" index="2" sort="true">
                    <div class="form-group" id="item-format">
						<label><b><cf_get_lang dictionary_id='58594.Format'></b></label>
					</div>
                    <div class="form-group" id="item-exp1">
                        <cf_get_lang dictionary_id='57629.Açıklama'>:<cf_get_lang dictionary_id ='44342.Dosya uzantısı csv olamalı ,alan araları noktalı virgül (;) ile ayrılmalı ve kaydedilirken karakter desteği olarak UTF-8 seçilmelidir'>
                        <cf_get_lang dictionary_id ='44193.Aktarım işlemi dosyanın 2 satırından itibaren başlar bu yüzden birinci satırda alan isimleri mutlaka olmalıdır'>.
                        <cf_get_lang dictionary_id ='44271. Ad, soyad dışındaki alanlar boş bırakılabilir Ama 1 satırda isimleri mutlaka olmalıdır'>.<br/>
					</div>
                    <div class="form-group" id="item-exp2">
                        <cf_get_lang dictionary_id ='44272.En az ad ve soyad bilgileri girilerek import yapılması gerekir'>.<cf_get_lang dictionary_id ='44273.Diğer alanlar zorunlu değil'> .<br/>
                    </div>
                    <div class="form-group" id="item-exp3">
                        <cf_get_lang dictionary_id ='44707.İlk satır başlıklar olur.'> <cf_get_lang dictionary_id='44708.Dosya Okumaya 2 satırdan başlar.'> <cf_get_lang dictionary_id='44709.CSV formatında'>(;)<cf_get_lang dictionary_id='44710.ile ayrılmış dosya upload edilmelidir!'><br />
                    </div> 
                    <div class="form-group" id="item-exp4">
                        1-<cf_get_lang dictionary_id ='58487.Çalışan No'> (<cf_get_lang dictionary_id ='44946.Boş Bırakılırsa Otomatik Sistem No Alır'>)<br/>
                        2-<cf_get_lang dictionary_id ='57631.Ad'> (<cf_get_lang dictionary_id='29801.Zorunlu'>)<br/>
                        3-<cf_get_lang dictionary_id ='58726.Soyad'> (<cf_get_lang dictionary_id='29801.Zorunlu'>)<br/>
                        4-<cf_get_lang dictionary_id ='57551.Kullanıcı Adı'><br/>
                        5-<cf_get_lang dictionary_id ='57428.E-mail'><br/>
                        6-<cf_get_lang dictionary_id ='57428.E-mail'><cf_get_lang dictionary_id='29688.Kişisel'><br/>
                        7-<cf_get_lang dictionary_id ='44252.Gruba Giriş Tarihi'> :15.06.2007 <cf_get_lang dictionary_id ='44253.formatında olmalıdır'>.<br/>
                        8-<cf_get_lang dictionary_id ='44254.Kıdem Baz Tarihi'> :15.06.2007 <cf_get_lang dictionary_id ='44253.formatında olmalıdır'>.<br/>
                        9-<cf_get_lang dictionary_id ='44255.İzin Baz Tarihi'> :15.06.2007 <cf_get_lang dictionary_id ='44253.formatında olmalıdır'>.<br/>
                        10-<cf_get_lang dictionary_id ='58025.TC Kimlik No'><br/>
                        11-<cf_get_lang dictionary_id ='42931.SSK No'><br/>
                        12-<cf_get_lang dictionary_id ='44256.Medeni Durum'> :<cf_get_lang dictionary_id ='44257.Evli-->1 Bekar-->0 olacak şekilde girilmelidir'> .<br/>
                        13-<cf_get_lang dictionary_id ='57764.Cinsiyet'> :<cf_get_lang dictionary_id ='44258.Erkek-->1 Kadın-->0 olacak şekilde girilmelidir'> .<br/>
                        14- <cf_get_lang dictionary_id = "31241.Dini"><br/>
                        15-<cf_get_lang dictionary_id ='44259.Nüfus Cüzdanı Seri No'><br/>
                        16-<cf_get_lang dictionary_id ='44260.Nüfus Cüzdan No'><br/>
                        17-<cf_get_lang dictionary_id ='58033.Baba Adı'><br/>
                        18-<cf_get_lang dictionary_id ='58440.Anne Adı'><br/>
                        19-<cf_get_lang dictionary_id ='58727.Doğum Tarihi'> :15.06.2007 <cf_get_lang dictionary_id ='44253.formatında olmalıdır'>.<br/>
                        20-<cf_get_lang dictionary_id='57790.Doğum Yeri'><br/>
                        21- <cf_get_lang dictionary_id='55640.Önceki Soyadı'><br/>
                        22- <cf_get_lang dictionary_id='57790.Doğum Yeri'> : <cf_get_lang dictionary_id='59581.ID Değildir'><br/>
                        23-<cf_get_lang dictionary_id ='44262.Nüfusa Kayıtlı Olduğu İl'> :<cf_get_lang dictionary_id ='44263.ID değildir Yazı ile girilmesi gerekir'> .<br/>
                        24-<cf_get_lang dictionary_id ='44264.Nüfusa Kayıtlı Olduğu İlçe'> :<cf_get_lang dictionary_id ='44263.ID değildir Yazı ile girilmesi gerekir'>.<br/>
                        25-<cf_get_lang dictionary_id='58735.Mahalle'><br />
                        26- <cf_get_lang dictionary_id='30326.Köy'><br />
                        27-<cf_get_lang dictionary_id ='44265.Cilt No'><br/>
                        28-<cf_get_lang dictionary_id ='44266.Aile Sıra No'><br/>
                        29-<cf_get_lang dictionary_id ='44267.Sıra No'><br/>
                        30- <cf_get_lang dictionary_id ='55647.Verildiği Yer'><br/>
                        31- <cf_get_lang dictionary_id ='55648.Veriliş Nedeni'><br/>
                        32- <cf_get_lang dictionary_id ='34670.Kayıt No'><br />
                        33-<cf_get_lang dictionary_id='44866.Veriliş Tarihi'><br />
                        34-<cf_get_lang dictionary_id ='44180.Ev Adresi'><br/>
                        35-<cf_get_lang dictionary_id='44182.Ev Posta Kodu'><br/>
                        36-<cf_get_lang dictionary_id='58638.İlçe'> : <cf_get_lang dictionary_id ='44263.ID değildir Yazı ile girilmesi gerekir'><cf_get_lang dictionary_id='44686.Büyük harflerle yazılmalıdır'><br/>
                        37-<cf_get_lang dictionary_id='57971.Şehir'>: <cf_get_lang dictionary_id ='44263.ID değildir Yazı ile girilmesi gerekir'><cf_get_lang dictionary_id='44686.Büyük harflerle yazılmalıdır'><br/>
                        38-<cf_get_lang dictionary_id='58219.Ülke'>: <cf_get_lang dictionary_id ='44263.ID değildir Yazı ile girilmesi gerekir'><cf_get_lang dictionary_id='44687.Baş harfleri büyük, kalan kısmı küçük harflerle yazılmalıdır'><br/>
                        39-<cf_get_lang dictionary_id ='44269.Ev Telefonu Alan Kodu'><br/>
                        40-<cf_get_lang dictionary_id='58814.Ev Telefon '><br/>
                        41-<cf_get_lang dictionary_id='42500.Dahili Tel'><br/>
                        42-<cf_get_lang dictionary_id='44600.Mobil Tel'><cf_get_lang dictionary_id='45084.Alan Kodu'><br/>
                        43-<cf_get_lang dictionary_id='44600.Mobil Tel'><br/>
                        44-<cf_get_lang dictionary_id='44600.Mobil Tel'><cf_get_lang dictionary_id='45084.Alan Kodu'><cf_get_lang dictionary_id='29688.Kişisel'><br/>
                        45-<cf_get_lang dictionary_id='44600.Mobil Tel'><cf_get_lang dictionary_id='29688.Kişisel'><br/>
                        46-<cf_get_lang dictionary_id='58441.Kan Grubu'>(0=0 Rh+,1=0 Rh-,2=A Rh+,3=A Rh-,4=B Rh+,5=B Rh-,6=AB Rh+,7=AB Rh-)<br/>
                        47-<cf_get_lang dictionary_id='44599.Askerlik'>(0=<cf_get_lang dictionary_id='44594.Yapmadı'>,1=<cf_get_lang dictionary_id='44595.Yaptı'>,2=<cf_get_lang dictionary_id='44596.Muaf'>,3=<cf_get_lang dictionary_id='44597.Yabancı'>,4=<cf_get_lang dictionary_id='44598.Tecilli'>)<br/>
                        48-<cf_get_lang dictionary_id='42503.Öğrenim Durumu'> <cf_get_lang dictionary_id="58527.ID"><br/>
                        49-<cf_get_lang dictionary_id='57789.Özel Kod'> (<cf_get_lang dictionary_id='57761.Hiyerarşi'>)<br/><br/>
					</div>
                </div>
            </cf_box_elements>
            <cf_box_footer>
                <cf_workcube_buttons is_upd='0' add_function='kontrol()'>
            </cf_box_footer>
        </cfform>
    </cf_box>
</div>
<script type="text/javascript">
    function kontrol()
    {
        <cfif controlDataImport.recordcount>
            if($( "#file_format" ).val() != 'data_import'){
                if(formimport.uploaded_file.value.length==0){
                    alert("<cf_get_lang dictionary_id ='43930.İmport Edilecek Belge Girmelisiniz'>!");
                    return false;
                }
            }
            else{
                if($('#import_id').val() == ''){
                    alert("<cf_get_lang dictionary_id='62851.Lütfen import tipi seçiniz'>!");
                    $('#import_id').focus();
                    return false;
                }
                if($('#import_dsn').val() == ''){
                    alert("<cf_get_lang dictionary_id='62852.Lütfen data source seçiniz'>!");
                    $('#import_dsn').focus();
                    return false;
                }
            }
        <cfelse>
            if(formimport.uploaded_file.value.length==0)
            {
                alert("<cf_get_lang dictionary_id ='43930.İmport Edilecek Belge Girmelisiniz'>!");
                return false;
            }
        </cfif>
        if(formimport.process_stage.value.length==0)
        {
            alert("<cf_get_lang dictionary_id ='38475.Aşama Seçmelisiniz'>!");
            return false;
        }
            return true;
    }
    <cfif controlDataImport.recordcount>
        $("#file_format").change( function(){
            $("#data_import_library").css("display", $( "#file_format" ).val() == 'data_import' ? '' : 'none');
        });

        $("#import_id").change( function(){
            if($("#import_id").val() != ''){
                $('#import_dsn').empty();
                $('#import_dsn').append(new Option('<cf_get_lang dictionary_id="57734.Seçiniz">', ''));
                import_dsn_id = $('#import_id option:selected').attr('type_id');
                var get_data_import_dsn = wrk_safe_query('get_data_import_dsn','dsn',0,import_dsn_id);
                if(get_data_import_dsn.recordcount){
                    for(i = 0;i<get_data_import_dsn.recordcount;i++){
                        $('#import_dsn').append(new Option(get_data_import_dsn.DATA_SOURCE_NAME[i], get_data_import_dsn.DATA_SOURCE_ID[i]));
                    }
                }
            }
            else{
                $('#import_dsn').empty();
                $('#import_dsn').append(new Option('<cf_get_lang dictionary_id='62851.Lütfen import tipi seçiniz'>', ''));
            }
        });
    </cfif>
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->