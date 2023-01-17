<cfscript>

    if ( not FileExists( application.systemParam.systemParam().download_folder & "dsn.txt" ) ) {
        fileWrite( "#application.systemParam.systemParam().download_folder#dsn.txt", application.systemParam.systemParam().dsn );
    }

    paramsSettings = createObject("component","V16/settings/cfc/params_settings");
    getParamsSetting = createObject( "component", "cfc/params_controller" ).getParamsSetting();

    paramsData = paramsSettings.getAllParams( getParamsSetting.data, 'systemParam' );
    hasChildParamList = getParamsSetting.hasChildParamList;

</cfscript>

<cf_box title="#getLang('','Sistem parametre ayarları',43947)#">
    <div class="col col-12 col-md-12">
        <cfform name="form_params_settings" id="form_params_settings" method="post" type="formControl">
            <div class="col col-12 col-md-12 mt-3">
                <cfoutput>
                    <cf_flat_list id = "paramsettings">
                        <thead>
                            <tr>
                                <th align="right">R</th>
                                <th><cf_get_lang dictionary_id='48413.sistem parametre adı'></th>
                                <th><cf_get_lang dictionary_id='58660.değeri'></th>
                                <th width="20" class="text-center"><a href = "javascript://" onclick="add_row();"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>
                            </tr>
                        </thead>
                        <tbody>
                            <cfset currentRow = 1>
                            <cfloop collection="#paramsData#" item="key">
                                <cfif ArrayFindNoCase( hasChildParamList, key )>
                                    <cfloop collection="#paramsData[key]#" item="childKey">
                                        <tr id="param_#currentrow#">
                                            <td align="right">#iif((paramsData[key][childKey]['required']), DE('*'), DE(''))#</td>
                                            <td><div class="form-group"><input type="text" style="width:100%;" value="#LCase(key)#.#LCase(childKey)#" #iif((paramsData[key][childKey]['required']), DE('required'), DE(''))# #iif((paramsData[key][childKey]['readonlyKey']), DE('readonly'), DE(''))# placeholder="<cf_get_lang dictionary_id='48413.sistem parametre adı'>" name="name_row#currentrow#" id="name_row#currentrow#"></div></td>
                                            <td>
                                                <div class="form-group">
                                                    <cfif LCase(key) eq 'git' and LCase(childKey) is 'git_password'>
                                                        <div class="input-group">
                                                            <input type="#paramsData[key][childKey]['type']#" style="width:100%;" value="#paramsData[key][childKey]['val']#" #iif((paramsData[key][childKey]['required']), DE('required'), DE(''))# #iif((paramsData[key][childKey]['readonlyValue']), DE('readonly'), DE(''))# placeholder="<cf_get_lang dictionary_id='58660.değeri'>" name="value_row#currentrow#" id="value_row#currentrow#">
                                                            <span class="input-group-addon btn_Pointer" title="<cf_get_lang dictionary_id='65265.Bitbucket App Password Al'>" onclick="getAppPassword('value_row#currentrow#')"><i class="fa fa-bitbucket"></i></span>
                                                        </div>
                                                    <cfelse>
                                                        <cfif paramsData[key][childKey]['type'] eq "select">
                                                            <select name="value_row#currentrow#" id="value_row#currentrow#">
                                                                <cfloop array="#paramsData[key][childKey]['option']#" index="i" item="item">
                                                                    <option value="#item.value#" #paramsData[key][childKey]['val'] eq item.value ? 'selected' : ''#>#item.text#</option>
                                                                </cfloop>
                                                            </select>
                                                        <cfelse>
                                                            <input type="#paramsData[key][childKey]['type']#" style="width:100%;" value="#paramsData[key][childKey]['val']#" #iif((paramsData[key][childKey]['required']), DE('required'), DE(''))# #iif((paramsData[key][childKey]['readonlyValue']), DE('readonly'), DE(''))# placeholder="<cf_get_lang dictionary_id='58660.değeri'>" name="value_row#currentrow#" id="value_row#currentrow#">
                                                        </cfif>
                                                    </cfif>
                                                </div>
                                            </td>
                                            <td width="20" class="text-center"><a href = "##" onclick="del_row('param_#currentrow#', #iif((paramsData[key][childKey]['required']), DE('1'), DE('0'))#);return false;"><i class="fa fa-minus" title="<cf_get_lang dictionary_id='57463.Sil'>"></i></a></td>
                                        </tr>
                                    </cfloop>
                                <cfelse>
                                    <tr id="param_#currentrow#">
                                        <td align="right">#iif((paramsData[key]['required']), DE('*'), DE(''))#</td>
                                        <td><div class="form-group"><input type="text" style="width:100%;" value="#LCase(key)#" #iif((paramsData[key]['required']), DE('required'), DE(''))# #iif((paramsData[key]['readonlyKey']), DE('readonly'), DE(''))# placeholder="<cf_get_lang dictionary_id='48413.sistem parametre adı'>" name="name_row#currentrow#" id="name_row#currentrow#"></div></td>
                                        <td>
                                            <div class="form-group">
                                                <cfif paramsData[key]['type'] eq "select">
                                                    <select name="value_row#currentrow#" id="value_row#currentrow#">
                                                        <cfloop array="#paramsData[key]['option']#" index="i" item="item">
                                                            <option value="#item.value#" #paramsData[key]['val'] eq item.value ? 'selected' : ''#>#item.text#</option>
                                                        </cfloop>
                                                    </select>
                                                <cfelse>
                                                    <input type="#paramsData[key]['type']#" style="width:100%;" value="#paramsData[key]['val']#" #iif((paramsData[key]['required']), DE('required'), DE(''))# #iif((paramsData[key]['readonlyValue']), DE('readonly'), DE(''))# placeholder="<cf_get_lang dictionary_id='58660.değeri'>" name="value_row#currentrow#" id="value_row#currentrow# ">
                                                </cfif>
                                            </div>
                                        </td>
                                        <td width="20" class="text-center"><a href = "##" onclick="del_row('param_#currentrow#', #iif((paramsData[key]['required']), DE('1'), DE('0'))#);return false;"><i class="fa fa-minus" title="<cf_get_lang dictionary_id='57463.Sil'>"></i></a></td>
                                    </tr>
                                </cfif>
                                <cfset currentRow = currentRow + 1>
                            </cfloop>
                        </tbody>
                    </cf_flat_list>
                    <cf_box_footer>
                        <div class="col col-8 col-xs-12" id="warningMessage"></div>
                        <div class="col col-4 col-xs-12 mt-2 pdn-r-0">
                            <input type="submit" class="pull-right ui-wrk-btn ui-wrk-btn-success" value="<cf_get_lang dictionary_id='57461. Kaydet'>">
                        </div>
                    </cf_box_footer>
                </cfoutput>
            </div>
        </cfform>
    </div>
</cf_box>

<script>
    (function() {
        function toJSONString( form ) {
            var obj = {};
            var elements = form.querySelectorAll( "input,select" );
            for( var i = 0; i < elements.length-1;i=i+2 ) {
               var element = elements[i];
                var name = element.name;
                var value = element.value;
                value = value.replace(/"/g,'');
                value = value.replace(/'/g,'');
                value = value.replace(/</g,'');
                value = value.replace(/>/g,'');
                value = value.replace(/`/g,'');
                value = value.replace(/ /g,'');
                var element2 = elements[i+1];
                var name2 = element2.name;
                var value2 = element2.value;
                value2 = value2.replace(/"/g,'');
                value2 = value2.replace(/'/g,'');
                value2 = value2.replace(/</g,'');
                value2 = value2.replace(/>/g,'');
                value2 = value2.replace(/`/g,'');
                if( value ) {
                    obj[value] = value2;
                }  
            }
            return JSON.stringify( obj );
        }
        document.addEventListener( "DOMContentLoaded", function() {
            if( document.getElementById( "form_params_settings" ) != undefined ){
                var form = document.getElementById( "form_params_settings" );
                form.addEventListener( "submit", function( e ) {
                    if(confirm('<cf_get_lang dictionary_id='54693.Tüm parametre ayarlarınızın doğruluğundan eminseniz tamam tuşuna basarak ilerleyebilirsiniz'>!')){
                        e.preventDefault();
                        json = toJSONString( this );
                        $.ajax({
                            type:'POST',
                            url:'V16/settings/cfc/params_settings.cfc?method=UPDATE_PARAMS_COL',
                            data: { json : json },
                            success: function ( response ) {
                                if( response ){
                                    alert("<cf_get_lang dictionary_id='35324.Kayıt İşleminiz Başarıyla Tamamlanmıştır'>");
                                    if(confirm('<cfoutput>#getLang("","Devam et tuşuna bastığınızda sisteminiz yeniden başlatılacak ve kullanmaya devam edebileceksiniz",60334)#</cfoutput>')){
                                        window.location="<cfoutput>#request.self#</cfoutput>?fuseaction=myhome.welcome&restart=1";
                                    }
                                }else alert("<cf_get_lang dictionary_id='54694.Parametreleriniz kaydedilirken bir hata oluştu'>");
                            },
                            error: function (msg)
                            {
                                alert("<cf_get_lang dictionary_id='52126.Bir hata oluştu'>!");
                                return false;
                            }
                        });
                    }else return false;
                }, false);
            }
        });
    })();
    function add_row() {
        var table = $("table#paramsettings");
        var elements = $(table).find("input[type=text]");
        var currentrow = elements.length/2;
        var row = '<tr id="param_'+currentrow+'"><td></td><td><div class="form-group"><input type="text" style="width:100%;" placeholder="<cf_get_lang dictionary_id="48413.sistem parametre adı">" name="name_row'+currentrow+'" id="name_row'+currentrow+'"></div></td><td><div class="form-group"><input type="text" style="width:100%;" placeholder="<cf_get_lang dictionary_id="58660.değeri">" name="value_row'+currentrow+'" id="value_row'+currentrow+'"></div></td><td width="20" class="text-center"><a href = "javascript://" onclick="del_row(\'param_'+currentrow+'\',0);return false;"><i class="fa fa-minus" title="<cf_get_lang dictionary_id='57463.Sil'>"></i></a></td></tr>';
        $(table).find("tbody").prepend(row);
        return false;
    }
    function del_row(currentrow, required) {
        if( !required ){
            var confirmed = confirm("<cfoutput>#getLang('','Silmek istediğinize emin misiniz?',62142)#</cfoutput>");
            if(confirmed) document.getElementById(currentrow).remove();
        }else alert("<cf_get_lang dictionary_id='54691.Zorunlu bir alanı kaldıramazsınız'>!");
    }
    function getAppPassword(el){
        var data = new FormData();
        AjaxControlPostDataJson( "V16/settings/cfc/params_settings.cfc?method=GET_BITBUCKET_APP_PASSWORD", data, function(response){
            if(response.STATUS) $("#"+el+"").val(response.MESSAGE);
            else alert(response.MESSAGE);
        });
    }
    $(function(){
        $("form[type=formControl]").submit(function(){
            
            var submitButton = $(this).find("input[type=submit]");
            submitButton.prop("disabled",true).after('<span class="loading flt-r"><?xml version="1.0" encoding="utf-8"?><svg width="32px" height="32px" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100" preserveAspectRatio="xMidYMid" class="uil-ring-alt"><rect x="0" y="0" width="100" height="100" fill="none" class="bk"></rect><circle cx="50" cy="50" r="40" stroke="rgba(255,255,255,0)" fill="none" stroke-width="10" stroke-linecap="round"></circle><circle cx="50" cy="50" r="40" stroke="#ff8a00" fill="none" stroke-width="6" stroke-linecap="round"><animate attributeName="stroke-dashoffset" dur="2s" repeatCount="indefinite" from="0" to="502"></animate><animate attributeName="stroke-dasharray" dur="2s" repeatCount="indefinite" values="150.6 100.4;1 250;150.6 100.4"></animate></circle></svg></span>');
        
        });
    });
</script>