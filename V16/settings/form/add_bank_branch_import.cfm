<cfset controlDataImport = createObject("component","WDO.development.cfc.data_import_library").getData(fuseaction : attributes.fuseaction) />
<cfset type_names = "#getLang('dictionary_id','Logo',58637)#,#getLang('dictionary_id','Mikro',62669)#,#getLang('dictionary_id','SAP Hana',62670)#,
                    #getLang('dictionary_id','Netsis',62671)#,#getLang('dictionary_id','Eta',62672)#,#getLang('dictionary_id','NetSuite',62673)#,
                    #getLang('dictionary_id','SAP Business One',62674)#,#getLang('dictionary_id','Workday',62671)#" />

<cfsavecontent variable="title">
    <cf_get_lang dictionary_id='44747.Banka Şubesi Aktarım'>
</cfsavecontent>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box title="#title#">
        <cfform name="formimport" action="#request.self#?fuseaction=settings.emptypopup_add_bank_branch_import" enctype="multipart/form-data" method="post">
            <cf_box_elements>
                <div class="col col-4 col-md-4 col-sm-4 col-xs-12" type="column" index="1" sort="true">
                    <div class="form-group" id="item-file_format">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='43385.Belge Formatı'></label>
                        <div class="col col-6 col-md-8 col-sm-8 col-xs-12">
                            <select name="file_format" id="file_format" style="width:200px;">
                                <option value="UTF-8"><cf_get_lang dictionary_id='43388.UTF-8'></option>
                                <cfif controlDataImport.recordcount>
                                    <option value="data_import"><cf_get_lang dictionary_id='62732.Data İmport Library'></option>
                                </cfif>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-uploaded_file">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57468.Belge'>*</label>
                        <div class="col col-6 col-md-8 col-sm-8 col-xs-12">
                            <input type="file" name="uploaded_file" style="width:200px;">
                        </div>
                    </div>
                    <div class="form-group" id="item-download-link">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='43671.Örnek Ürün Dosyası'></label>
                        <div class="col col-6 col-md-8 col-sm-8 col-xs-12">
                            <a href="/IEF/standarts/import_example_file/Banka_subesi_aktarim.csv"><strong><cf_get_lang dictionary_id='43675.İndir'></strong></a>
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
                                                <option value="#DATA_IMPORT_ID#" type_id="#TYPE#" is_comp="#IS_COMP#" is_period="#IS_PERIOD#">#NAME# - #listGetAt(type_names,TYPE)#</option>
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
                                <div class="form-group" id="item-data_import_comp_id" style="display:none;">
                                    <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57574.Şirket'>*</label>
                                    <div class="col col-6 col-md-8 col-sm-8 col-xs-12">
                                        <select name="comp_id" id="comp_id">
                                            <option value=""><cf_get_lang dictionary_id='62852.Lütfen data source seçiniz'></option>
                                        </select>
                                    </div>
                                </div>
                                <div class="form-group" id="item-data_import_period_id" style="display:none;">
                                    <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58472.Dönem'>*</label>
                                    <div class="col col-6 col-md-8 col-sm-8 col-xs-12">
                                        <select name="period_id" id="period_id">
                                            <option value=""><cf_get_lang dictionary_id='62852.Lütfen data source seçiniz'></option>
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
                        <cf_get_lang dictionary_id='57629.Açıklama'>:<br/>
                        <cf_get_lang dictionary_id='44342.Dosya uzantısı csv olmalı,alan araları noktalı virgül (;) ile ayrılmalı ve kaydedilirken karakter desteği olarak UTF-8 seçilmelidir'>.<br/>
                        <cf_get_lang dictionary_id='44193.Aktarım işlemi dosyanın 2. satırından itibaren başlar bu yüzden birinci satırda alan isimleri olmalıdır'>.<br/>
                        <cf_get_lang dictionary_id='44970.Belgede toplam 9 alan olacaktır alanlar sırasi ile;'><br/>
                        1-<cf_get_lang dictionary_id='44973.Banka Kodu (Zorunlu) : Şubenin bağlı olduğu bankanun kodu girilmelidir. Eğer sistemde bu kod ile kayıtlı banka bulunmazsa şube kaydedilmez.'><br/>
                        2-<cf_get_lang dictionary_id='44974.Şube Adı (Zorunlu)'><br/>
                        3-<cf_get_lang dictionary_id='44975.Şube Kodu (Zorunlu)'><br/>
                        4-<cf_get_lang dictionary_id='44976.Şehir(Zorunlu) : Şubenin bulunduğu şehir adı girilmelidir.'><br/>
                        5-<cf_get_lang dictionary_id='44977.Yetkili : Şubenin yetkilisinin adı soyadı girilebilir.'><br/>
                        6-<cf_get_lang dictionary_id='44978.Telefon : Şubenin telefon numarası girilebilir.'><br/>
                        7-<cf_get_lang dictionary_id='44979.Adres : Şubenin adresi girilebilir.'><br/>
                        8-<cf_get_lang dictionary_id='44980.Posta Kodu : Şubenin bağlı olduğu posta kodu girilebilir.'><br/>
                        9-<cf_get_lang dictionary_id='44981.Ülke : Şubenin bulunduğu ülke girilebilir.'><br/>
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
                var import_dsn_id_control = $('#import_id option:selected').attr('type_id');
                var is_comp_control = $('#import_id option:selected').attr('is_comp');
                var is_period_control = $('#import_id option:selected').attr('is_period');
                if(is_comp_control == 1 && import_dsn_id_control == 1 && $('#comp_id').val() == ''){
                    alert("<cf_get_lang dictionary_id='43432.Lütfen şirket seçiniz'>!");
                    $('#comp_id').focus();
                    return false;
                }
                if(is_period_control == 1 && import_dsn_id_control == 1 && $('#period_id').val() == ''){
                    alert("<cf_get_lang dictionary_id='39035.Dönem seçiniz'>!");
                    $('#period_id').focus();
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

                is_comp = $('#import_id option:selected').attr('is_comp');
                $('#comp_id').empty();
                $('#comp_id').append(new Option('<cf_get_lang dictionary_id='62852.Lütfen data source seçiniz'>', ''));
                if(is_comp == 1 && import_dsn_id == 1) $('#item-data_import_comp_id').css('display','');
                else $('#item-data_import_comp_id').css('display','none');

                is_period = $('#import_id option:selected').attr('is_period');
                $('#period_id').empty();
                $('#period_id').append(new Option('<cf_get_lang dictionary_id='62852.Lütfen data source seçiniz'>', ''));
                if(is_period == 1 && import_dsn_id == 1) $('#item-data_import_period_id').css('display','');
                else $('#item-data_import_period_id').css('display','none');
            }
            else{
                $('#import_dsn').empty();
                $('#import_dsn').append(new Option('<cf_get_lang dictionary_id='62851.Lütfen import tipi seçiniz'>', ''));

                $('#comp_id').empty();
                $('#comp_id').append(new Option('<cf_get_lang dictionary_id='62852.Lütfen data source seçiniz'>', ''));
                $('#item-data_import_comp_id').css('display','none');

                $('#period_id').empty();
                $('#period_id').append(new Option('<cf_get_lang dictionary_id='62852.Lütfen data source seçiniz'>', ''));
                $('#item-data_import_period_id').css('display','none');
            }
        });

        $("#import_dsn").change( function(){
            var import_dsn_id_control = $('#import_id option:selected').attr('type_id');
            var is_comp_control = $('#import_id option:selected').attr('is_comp');
            var is_period_control = $('#import_id option:selected').attr('is_period');
            if($("#import_dsn").val() != ''){
                var data = new FormData();
                data.append("data_source_id", $('#import_dsn').val());
                
                if(is_comp_control == 1 && import_dsn_id_control == 1){
                    $('#comp_id').empty();
                    $('#comp_id').append(new Option('<cf_get_lang dictionary_id="57734.Seçiniz">', ''));

                    if(is_period_control == 1){
                        $('#period_id').empty();
                        $('#period_id').append(new Option('<cf_get_lang dictionary_id='43432.Lütfen Şirket Seçiniz'>', ''));
                    }

                    AjaxControlPostDataJson('WDO/development/cfc/data_import_library.cfc?method=getDBCompanies', data, function(response) {
                        if(response.length > 0){
                            response.forEach((e) => {
                                $('#comp_id').append(new Option(e.NAME, e.NR));
                            });
                        }
                    });
                }
            }
            else{
                $('#comp_id').empty();
                $('#comp_id').append(new Option('<cf_get_lang dictionary_id='62852.Lütfen data source seçiniz'>', ''));
                $('#item-data_import_comp_id').css('display', is_comp_control == 1 && import_dsn_id_control == 1 ? '' : 'none');

                $('#period_id').empty();
                $('#period_id').append(new Option('<cf_get_lang dictionary_id='62852.Lütfen data source seçiniz'>', ''));
                $('#item-data_import_period_id').css('display', is_period_control == 1 && import_dsn_id_control == 1 ? '' : 'none');
            }
        });

        $("#comp_id").change( function(){
            var import_dsn_id_control = $('#import_id option:selected').attr('type_id');
            var is_comp_control = $('#import_id option:selected').attr('is_comp');
            var is_period_control = $('#import_id option:selected').attr('is_period');

            if(is_period_control == 1 && import_dsn_id_control == 1){
                if($("#comp_id").val() != ''){
                    var data = new FormData();
                    data.append("data_source_id", $('#import_dsn').val());
                    data.append("comp_id", $('#comp_id').val());
                    
                    $('#period_id').empty();
                    $('#period_id').append(new Option('<cf_get_lang dictionary_id="57734.Seçiniz">', ''));

                    AjaxControlPostDataJson('WDO/development/cfc/data_import_library.cfc?method=getDBPeriods', data, function(response) {
                        if(response.length > 0){
                            response.forEach((e) => {
                                $('#period_id').append(new Option(e.BEGDATE + ' - ' + e.ENDDATE, e.NR));
                            });
                        }
                    });
                }
                else{
                    $('#period_id').empty();
                    $('#period_id').append(new Option('<cf_get_lang dictionary_id='43432.Lütfen Şirket Seçiniz'>', ''));
                    $('#item-data_import_period_id').css('display', is_period_control == 1 && import_dsn_id_control == 1 ? '' : 'none');
                }
            }
        });
    </cfif>
</script>