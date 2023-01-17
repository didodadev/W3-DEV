<cfset cmp_dataservice = createObject("component","WEX/dataservices/cfc/data_services") />
    <!--- TODO: url değiştirilecek --->
    <cfhttp result="result" charset="utf-8" url="https://dev.workcube.com/wex.cfm/dataservices/get_dataservice"> 
        <cfhttpparam name="version" type="formField" value="#application.systemParam.systemParam().workcube_version#">
    </cfhttp> 
    
    <cfset result_data = deserializeJSON(result.filecontent)>
    
    <cfif len(result.Errordetail)>
        <cfset result_error = result.Errordetail>
    <cfelse>
        <cfset result_error = ''>
    </cfif>
    <style>.fa-angle-down{cursor:pointer;}.activeTr{background:#f5f5f5;}.flagTrue{color:green;}.flagFalse{color:red;}.flagWarning{color:orange;}</style>
<div class="wrapper">
    <div id="wiki" class="col col-12 col-md-12 col-sm-12 col-xs-12">
        <cf_box class="clever">
            <label style="font-size:20px;color:red;"><img src="css/assets/icons/catalyst-icon-svg/ctl-office-material-4.svg" width="50px" height="50px"> Workcube Data Services</label>
            <p style="font-size: 15px;font-weight: bold!important"><cf_get_lang dictionary_id='62322.Veri Servisleri Workcube Uzamanlar Topluluğu tarafından sunulan ücretsiz bir hizmettir.'></p>
            <label class="text-bold"><cf_get_lang dictionary_id='62323.Yayınlamış bir veriyi almanız sisteminizde bazı değişikliklere neden olabilir. Parametreler, Genel Ayarlar, Kural Setleri gibi işlemlerin ayarlarını değiştirebilir, güncelleyebilir. Bu servislerden dolayı değişen parametreler ve ayarlar ve kural setlerinden dolayı Workcube sorumlu tutulamaz. Herhangi bir veri servisini çalıştırmadan önce inceleyiniz.'></label>
            <div class="col-md-12 mt-3">
                <p>
                    <label style="min-width:150px;"><i class="fa fa-2x fa-bookmark-o"></i>  <cf_get_lang dictionary_id = "52128.Çalıştırmaya hazır"></label>
                    <label style="min-width:200px;"><i class="fa fa-2x fa-bookmark flagTrue"></i>  <cf_get_lang dictionary_id = "52131.Başarılı bir şekilde çalıştırıldı"></label>
                    <label><i class="fa fa-2x fa-bookmark flagFalse"></i>  <cf_get_lang dictionary_id = "52151.Çalıştırılamadı"></label>
                </p>
            </div>
        </cf_box>
        <cfif arrayLen(result_data)>
            <cfoutput>
                <!--- Gelen değerleri tabloya yazar. --->
                <cfset add_dataservice = cmp_dataservice.add_dataservice(result_data : result_data)>
                <cfset i = 1>
                <cfloop array="#result_data#" index="data">
                    <cf_box class="clever">
                        <cfset get_wex_fnc = cmp_dataservice.get_wex_fnc(wex_id : data.wex_id, main_version : data.main_version, version : data.version, is_work : 1)>
                        <cfset service_id = cmp_dataservice.get_wex_fnc(wex_id : data.wex_id, main_version : data.main_version, version : data.version)>
                        <div class="reply_item">
                            <p class="name"><a href="">#data.head# <cfif get_wex_fnc.recordcount eq 0><i class="badge"><cf_get_lang dictionary_id='58674.Yeni'></i></cfif></a></p>
                            <div class="text col col-12">#data.DETAIL# 
                                <p>
                                    <i class="fa fa-2x fa-bookmark-o"></i>
                                    <input type="checkbox" name="row_id_#data.REST_NAME#" id="row_id_#data.REST_NAME#" value="#data.REST_NAME#" style="display:none;">
                                </p>
                            </div>
                            <div class="category">
                                <div class="text-bold col col-2 col-xs-12"><cf_get_lang dictionary_id='63652.Publisher'> : #data.AUTHOR#</div>
                                <div class="text-bold col col-2 col-xs-12"><cf_get_lang dictionary_id='46832.Yayın Tarihi'> : #dateformat(data.PUBLISHING_DATE,dateformat_style)#</div>
                                <div class="text-bold col col-2 col-xs-12"><cf_get_lang dictionary_id='63653.Son Alım Tarihi'> : <cfif len(service_id.UPDATE_DATE)>#dateformat(service_id.UPDATE_DATE,dateformat_style)#<cfelse>#dateformat(service_id.UPDATE_DATE,dateformat_style)#</cfif></div>
                                <div class="text-bold col col-2 col-xs-12"><i class="fa fa-history" style="color:coral;font-size:large;" onclick="getDataServiceHistory(#data.WEX_ID#,'tr_#data.WEX_ID#')" title='<cf_get_lang dictionary_id='57473.Tarihçe'>'></i> <cf_get_lang dictionary_id='63655.Veri Tarihçesi İçin Tıklayın'></div>
                                   
                                <div class="text-bold col col-4 col-xs-12">
                                    <input type="checkbox" data-type="dataservices" name="dataservices_#data.REST_NAME#" id="dataservices_#data.REST_NAME#" data-id="dataservices_#i#" value="#data.REST_NAME#">
                                    <input type="checkbox" name="dataservice_id_#data.REST_NAME#" id="dataservice_id_#data.REST_NAME#" value="#service_id.WRK_DATA_SERVICE_ID#" style="display:none;">
                                    <label><cf_get_lang dictionary_id='63654.Çalıştırmak için seçiniz'>!</label>
                                    
                                </div>
                            </div>
                        </div>
                        <cfset i++>
                    </cf_box>
                </cfloop>
            </cfoutput>
        <cfelse>
            <tr><td colspan="9"><cf_get_lang dictionary_id='63648.Çalıştırılacak servis bulunamadı!'>!</td></tr>
        </cfif>
        <cf_box>
                <cfform name="form_run_wds" id="form_run_wds" method="post" action="" type="formControl">
                    <cfset get_release_info = cmp_dataservice.get_release_info()>
                    <cfset last_release_date = get_release_info.release_date[2]>
                    <cfif get_release_info.recordcount eq 1>
						<cfset last_release_date = get_release_info.release_date>
					</cfif>
                    <cfinput name="start_date" type="hidden" value="#CreateDateTime(year(last_release_date),month(last_release_date),day(last_release_date),hour(last_release_date),minute(last_release_date),second(last_release_date))#" />
                    <cfinput name="finish_date" type="hidden" value="#now()#" />
                    <input type="hidden" name="file_name">
                    <input type="hidden" name="file_id">
                    <div class="col col-9 col-xs-12" id="warningMessage"></div>
                    <div class="col col-3 col-xs-12">
                        <input type="submit" class="flt-r ui-wrk-btn ui-wrk-btn-success" name="wds_submit" value="<cf_get_lang dictionary_id='62533.Seçili Olanları Çalıştır'>">
                    </div>
                </cfform>
        </cf_box>
    </div>
</div>
<script>
var errorCounter = successCounter = warningCounter = 0;
    var runWro = false;
    function getDataServiceHistory(wex_id, showResponseid) {
        openBoxDraggable('<cfoutput>#request.self#?fuseaction=settings.dataservice_history</cfoutput>&wex_id='+wex_id);
    }
    /* Workcube Data Service Functions */

    function sendDataServiceRequest(dataservice_name, i) {

        var flag = $("input#row_id_"+dataservice_name+"").parent('p').find('i');
        //flag.removeClass('fa-bookmark').addClass('fa-cog fa-spin font-yellow-casablanca');
        var start_date = $("form[name = form_run_wds] input[name = start_date]").val();
        var finish_date = $("form[name = form_run_wds] input[name = finish_date]").val();

        $.ajax({
            url: "V16/settings/cfc/dataservice_control.cfc?method=runWexService",
            method: "post",
            dataType: "json",
            data: {
                functionName:dataservice_name, 
                start_date : start_date, 
                finish_date : finish_date
            },
            success: function( response ){                
                var row_dataservice_id = $("#dataservice_id_"+dataservice_name).val();
                //console.log(response);
                if( response.STATUS == true ){
                    $.ajax({
                        url: "WEX/dataservices/cfc/data_services.cfc?method=set_returnTrue",
                        method: "post",
                        data: {row_id : row_dataservice_id},
                        success: function(rtrn_val){
                            $(flag).removeClass('fa-cog fa-spin font-yellow-casablanca').addClass('fa-bookmark flagTrue');
                            successCounter++;
                            if(($('input[data-type =dataservices]:checkbox:checked').length-1)>i++) 
                                startDataServiceRequest(i++);
                            else
                                warning_func();
                            
                        },
                        error: function( objResponse ){
                            console.log(objResponse);
                            if(objResponse.ERRORMESSAGE != undefined)
                            {
                                return_error = objResponse.ERRORMESSAGE;
                            }
                            else
                                return_error = objResponse.responseText;

                            $(flag).removeClass('fa-cog fa-spin font-yellow-casablanca').addClass('fa-bookmark flagFalse').attr({ 'onclick' : 'showMistakeMessage("'+dataservice_name+'")' }).css({ 'cursor' : 'pointer' });
                            $("input#row_id_"+dataservice_name+"").parents('tr').after(
                                $('<tr>').attr({ 'id' : 'msgid_' + dataservice_name + '' }).append(
                                    $('<td>').attr({ 'colspan' : 9 }).append(
                                        $('<table>').addClass('WorkDevList').css({ 'width' : '100%' }).append(
                                            $('<tr>').append($('<td>').css({ 'color' : '#f00' }).text('Message'), $('<td>').html(return_error)),
                                        )
                                    )
                                ).hide()
                            );
                            errorCounter++;
                            if(($('input[data-type =dataservices]:checkbox:checked').length-1)>i++) 
                                startDataServiceRequest(i++);
                            else
                                warning_func(); 
                        }
                    }); 
                    
                } 
                else
                {
                    if(response.ERRORMESSAGE != undefined && response.ERRORMESSAGE.LocalizedMessage != undefined)
                        return_error = response.ERRORMESSAGE.LocalizedMessage;
                    else if(response.ERRORMESSAGE != undefined )
                        return_error = response.ERRORMESSAGE;
                    else
                        return_error = response.responseText;

                    $(flag).removeClass('fa-cog fa-spin font-yellow-casablanca').addClass('fa-bookmark flagFalse').attr({ 'onclick' : 'showMistakeMessage("'+dataservice_name+'")' }).css({ 'cursor' : 'pointer' });
                    $("input#row_id_"+dataservice_name+"").parents('tr').after(
                        $('<tr>').attr({ 'id' : 'msgid_' + dataservice_name + '' }).append(
                            $('<td>').attr({ 'colspan' : 9 }).append(
                                $('<table>').addClass('WorkDevList').css({ 'width' : '100%' }).append(
                                    $('<tr>').append($('<td>').css({ 'color' : '#f00' }).text('Message'), $('<td>').html(return_error)),
                                )
                            )
                        ).hide()
                    );
                    errorCounter++;
                    console.log("response : ",return_error);
                }

            },
            error: function( objResponse ){

                if(objResponse.ERRORMESSAGE != undefined)
                {
                    return_error = objResponse.ERRORMESSAGE;
                }
                else
                    return_error = objResponse.responseText;

                $(flag).removeClass('fa-cog fa-spin font-yellow-casablanca').addClass('fa-bookmark flagFalse').attr({ 'onclick' : 'showMistakeMessage("'+dataservice_name+'")' }).css({ 'cursor' : 'pointer' });
                $("input#row_id_"+dataservice_name+"").parents('tr').after(
                    $('<tr>').attr({ 'id' : 'msgid_' + dataservice_name + '' }).append(
                        $('<td>').attr({ 'colspan' : 9 }).append(
                            $('<table>').addClass('WorkDevList').css({ 'width' : '100%' }).append(
                                $('<tr>').append($('<td>').css({ 'color' : '#f00' }).text('Message'), $('<td>').html(return_error)),
                            )
                        )
                    ).hide()
                );
                errorCounter++;
                if(($('input[data-type =dataservices]:checkbox:checked').length-1)>i++) 
                    startDataServiceRequest(i++);
                else
                    warning_func();
                ///console.log("error1 : ",objResponse);
            }
        }); 
        }

        function startDataServiceRequest(i){

        var dataservice_name = $('input[data-type =dataservices]:checkbox:checked')[i].value;   
        var flag = $("input#row_id_"+dataservice_name+"").parent('p').find('i');
        flag.removeClass('fa-bookmark-o').addClass('fa-cog fa-spin font-yellow-casablanca');
                
        sendDataServiceRequest(dataservice_name,i);  
        }

        function warning_func()
        {
            Swal.fire({
                title: '<cf_get_lang dictionary_id='54688.Tüm WRO dosyaları çalıştırıldı'>!',
                html:   '<table class="workDevList">'+
                        '<tr><td width="50"><b><cf_get_lang dictionary_id='55387.Başarılı'></b></td><td>'+successCounter+'</td></tr>'+
                        '<tr><td width="50"><b><cf_get_lang dictionary_id='54686.Hatalı'></b></td><td>'+errorCounter+'</td></tr>'+
                        '</table>',
                type: 'warning',
                showCancelButton: true,
                confirmButtonColor: '#1fbb39',
                cancelButtonColor: '#3085d6',
                confirmButtonText: '<cf_get_lang dictionary_id='44097.Devam Et'>',
                cancelButtonText: '<cf_get_lang dictionary_id='54685.Sonuçları İncele'>',
                closeOnConfirm: false,
                allowOutsideClick:false
            }).then((result) => {
                if (result.value) {
                    location.reload();
                }
            });
        }

        /* Workcube Data Service Submit */
        var runWds = false;
        $("form[name = form_run_wds]").submit(function(){

        if( !runWds ){

            startDataServiceRequest(0);
            $(this).find('input[type = submit]').prop('disabled', true);
            
        }else 
        {
            location.reload();
        }
        return false;

        });
</script>