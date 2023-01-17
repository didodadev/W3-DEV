<cfif not isdefined("attributes.woLang") and not(isdefined("attributes.data_services") and len(attributes.data_services))>
    <cfset wroController = createObject("component","V16/settings/cfc/wroControl") />
    <cfset wroController.readFilePath( release_date: dateformat(dateadd('d',-1800,now()),'yyyy-mm-dd H:m:s'), new_release_date: dateformat(Now(),'yyyy-mm-dd H:m:s') ) />
    <cfset getWroList = wroController.getTable( is_work : 0 ) />

    <div class="col col-12 col-md-12 col-xs-12 pl-0 pr-0">
        <div class="col col-12 release_info">
            <div class="before-release col col-12">
                <p><cf_get_lang dictionary_id = "51003.Tüm WRO sorgularını çalıştırmak için devam butonuna basın">.</p>
                <div class="col-md-12 mt-3">
                    <p><i class="fa fa-2x fa-bookmark-o"></i> : <cf_get_lang dictionary_id = "52128.Çalıştırmaya hazır"></p> 
                    <p><i class="fa fa-2x fa-bookmark flagTrue"></i> : <cf_get_lang dictionary_id = "52131.Başarılı bir şekilde çalıştırıldı"></p> 
                    <p><i class="fa fa-2x fa-bookmark flagWarning"></i> : <cf_get_lang dictionary_id = "52144.Daha önce başarılı şekilde gerçekleşmiş bir işlem tekrarlandı"></p> 
                    <p><i class="fa fa-2x fa-bookmark flagFalse"></i> : <cf_get_lang dictionary_id = "52151.Çalıştırılamadı"></p>
                </div>
            </div>
        </div>
        <div class="col col-12 col-md-12 mt-3">
            <cf_grid_list>
                <thead>
                    <tr>
                        <th>Row</th>
                        <th>Date</th>
                        <th style="width:50px;">Description</th>
                        <th>File Name</th>
                        <th>Destination</th>
                        <th>Developer</th>
                        <th>Company</th>
                        <th>Status</th>
                        <th></th>
                    </tr>
                </thead>
                <tbody>
                    <cfif getWroList.recordCount>
                    <cfoutput query="getWroList">
                        <tr>
                            <td>#currentrow#</td>
                            <td>#dateformat(last_update,dateformat_style)#</td>
                            <td>#DESCRIPTION#</td>
                            <td>#GetFileFromPath(FILE_NAME)#</td>
                            <td>#DESTINATION#</td>
                            <td>#DEVELOPER#</td>
                            <td><cfif len(developer_company)>#developer_company#<cfelse>Workcube</cfif></td>
                            <td><i class="fa fa-2x fa-bookmark-o"></i><input type="checkbox" data-type="fileids" name="fileids_#DBUPGRADE_SCRIPT_ID#" id="fileids_#DBUPGRADE_SCRIPT_ID#" data-id="fileids_#currentrow#" value="#DBUPGRADE_SCRIPT_ID#" checked style="display:none;"></td>
                            <td><i class="fa fa-2x fa-angle-down" onclick="getFileContent(#DBUPGRADE_SCRIPT_ID#,'tr_#DBUPGRADE_SCRIPT_ID#')"></i></td>
                        </tr>
                        <tr>
                            <td style="display:none;" id="tr_#DBUPGRADE_SCRIPT_ID#" colspan="9"></td>
                        </tr>
                    </cfoutput>
                    <cfelse>
                        <tr><td colspan="9"><cf_get_lang dictionary_id='63778.Çalıştırılacak sql dosyası bulunamadı'>!</td></tr>
                    </cfif>
                </tbody>
            </cf_grid_list>
        </div>
        <div class="col col-12 formContentFooter mt-3">
            <cfform name="form_run_wro" id="form_run_wro" method="post" action="" type="formControl">
                <input type="hidden" name="file_name">
                <input type="hidden" name="file_id">
                <div class="col col-9 col-xs-12" id="warningMessage"></div>
                <div class="col col-3 col-xs-12">
                    <input type="submit" class="flt-r ui-wrk-btn ui-wrk-btn-success" name="upgrade_submit" value="<cf_get_lang dictionary_id='44097.Devam Et'>">
                </div>
            </cfform>
        </div>
    </div>
<cfelse>
    <div id="ShowDiv" style="padding-left:5px;"></div>
    <cfif not attributes.woLang>
        <cfform name="form_basket" id="form_basket" method="post">
            <div class="bold" style="font-size:16px; padding-left:5px;">WO Upgrade</div>
            <div class="row" type="row">
                <cf_box_elements>
                    <div class="col col-4 col-md-8 col-sm-8 col-xs-12" type="column" index="1" sort="true">
                        <div class="form-group">
                            <label class="col col-6  bold">Solutions</label>
                            <label class="col col-6"><input type="checkbox" name="Solutions" id="Solutions" value="1"></label>
                        </div>
                        <div class="form-group">
                            <label class="col col-6  bold">Family</label>
                            <label class="col col-6"><input type="checkbox" name="Family" id="Family" value="1"></label>
                        </div>
                        <div class="form-group">
                            <label class="col col-6  bold">Module</label>
                            <label class="col col-6"><input type="checkbox" name="Module" id="Module" value="1"></label>
                        </div>
                        <div class="form-group">
                            <label class="col col-6  bold">Objects</label>
                            <label class="col col-6"><input type="checkbox" name="Objects" id="Objects" value="1"></label>
                        </div>
                        <div class="form-group">
                            <label class="col col-6  bold">Widget</label>
                            <label class="col col-6"><input type="checkbox" name="Widget" id="Widget" value="1"></label>
                        </div>
                        <div class="form-group">
                            <label class="col col-6  bold">WEX</label>
                            <label class="col col-6"><input type="checkbox" name="Wex" id="Wex" value="1"></label>
                        </div>
                        <div class="form-group">
                            <label class="col col-6  bold">Output Templates</label>
                            <label class="col col-6"><input type="checkbox" name="Output_Templates" id="Output_Templates" value="1"></label>
                        </div>
                        <div class="form-group">
                            <label class="col col-6  bold">Process Templates</label>
                            <label class="col col-6"><input type="checkbox" name="Process_Templates" id="Process_Templates" value="1"></label>
                        </div>
                        <div class="form-group">
                            <label class="col col-6 bold"><cf_get_lang dictionary_id="58690.Tarih Aralığı"></label>
                            <div class="col col-6">
                                <select name="date_range_value_wo" id="date_range_value_wo">
                                    <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                    <option value="1"><cf_get_lang dictionary_id="29398.Son"><cf_get_lang dictionary_id="40832.7 Gün"></option>
                                    <option value="2"><cf_get_lang dictionary_id="33613.Son 30 Gün"></option>
                                    <option value="3"><cf_get_lang dictionary_id="29398.Son"><cf_get_lang dictionary_id="58879.3 Ay"></option>
                                    <option value="4"><cf_get_lang dictionary_id="29398.Son"><cf_get_lang dictionary_id="33611.1 Yıl"></option>
                                </select>
                            </div>
                        </div>
                    </div>
                </cf_box_elements>
            </div>
            <div style="font-size:12px; font-style:italic; padding-left:5px;"><cf_get_lang dictionary_id='63779.Release tarihleri arasında açılmış yeni objeler ve güncellemeler sisteme upgrade edilir'></div>
            <cf_box_footer>
                <button type="button" name="upgradeWo" id="upgradeWo" class="ui-wrk-btn ui-wrk-btn-success">Upgrade</button>           
            </cf_box_footer>
        </cfform>
    <cfelse>
        <cfform name="form_basket" id="form_basket" method="post">
            <div class="bold" style="font-size:16px; padding-left:5px;">Dictionary Upgrade</div>
            <div class="row" type="row">			
                <cf_box_elements>
                    <div class="col col-4 col-md-8 col-sm-8 col-xs-12" type="column" index="1" sort="true">	
                        <div class="form-group">
                            <label class="col col-6 bold" title="Son eklenen ve güncellenen kelimeler sisteme aktarılır.">Dictionary</label>
                            <label class="col col-6"><input type="checkbox" name="Dictionary" id="Dictionary" value="1"></label>
                        </div>
                        <div class="form-group">
                            <label class="col col-6 bold"><cf_get_lang dictionary_id="58690.Tarih Aralığı"></label>
                            <div class="col col-6">
                                <select name="date_range_value" id="date_range_value">
                                    <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                    <option value="1"><cf_get_lang dictionary_id="29398.Son"><cf_get_lang dictionary_id="40832.7 Gün"></option>
                                    <option value="2"><cf_get_lang dictionary_id="33613.Son 30 Gün"></option>
                                    <option value="3"><cf_get_lang dictionary_id="29398.Son"><cf_get_lang dictionary_id="58879.3 Ay"></option>
                                    <option value="4"><cf_get_lang dictionary_id="29398.Son"><cf_get_lang dictionary_id="33611.1 Yıl"></option>
                                </select>
                            </div>
                        </div>
                    </div>
                </cf_box_elements>
            </div>
            <div style="font-size:12px; font-style:italic; padding-left:5px;"><cf_get_lang dictionary_id='63780.Release tarihleri arasında dilde yapılmış güncellemeler sisteme upgrade edilir'></div>
            <cf_box_footer>
                <input type="hidden" name="woLangAction" id="woLangAction">  
                <button type="button" name="upgradeLang" id="upgradeLang" class="ui-wrk-btn ui-wrk-btn-success">Upgrade</button>           
            </cf_box_footer>
        </cfform>
    </cfif>
</cfif>
<script>
    
    /* WRO - Run */

    function getFileContent(file_id, showResponseid) {
        if( $("#"+showResponseid+"").hasClass("activeTr") ) 
            $("#"+showResponseid+"").hide().removeClass("activeTr");
        else{
            $("#"+showResponseid+"").show().addClass("activeTr");
            AjaxPageLoad('V16/settings/cfc/wroControl.cfc?method=getFileContent&release_date=<cfoutput>#dateformat(dateadd('d',-360,now()),'yyyy-mm-dd H:m:s')#</cfoutput>&new_release_date=<cfoutput>#dateformat(Now(),'yyyy-mm-dd H:m:s')#</cfoutput>&fileid='+file_id, showResponseid);
            setTimeout(function(){
                var content = document.getElementById("content_"+file_id);
                var editor = CodeMirror.fromTextArea(content, {
                    mode: "text/x-sql",
                    lineNumbers: true
                });
            }, 1000);
        }
    }

    function getDataServiceHistory(wex_id, showResponseid) {
            cfmodal('<cfoutput>#request.self#?fuseaction=settings.dataservice_history</cfoutput>&wex_id='+wex_id,'warning_modal');
    }

    function sendRequest( fileid, callback ) {
        
        $("input#fileids_"+ fileid +"").parent('td').find('i').removeClass('fa-bookmark-o').addClass('fa-cog fa-spin font-yellow-casablanca');
        $.ajax({
            url: "V16/settings/cfc/wroControl.cfc?method=execute_script_buffer",
            dataType: "json",
            method: "post",
            data: { fileid : fileid },
            success: callback
        });

    }

    var errorCounter = successCounter = warningCounter = 0;
    var runWro = false;

    function startRequest( fileid, checkboxid ){

        sendRequest( fileid, function( response ){
            
            var flag = $("input#fileids_"+response.FILEID+"").parent('td').find('i');
            if( response.STATUS ){
                $(flag).removeClass('fa-cog fa-spin font-yellow-casablanca').addClass('fa-bookmark flagTrue');
                successCounter++;
            }
            else{

                $(flag).removeClass('fa-cog fa-spin font-yellow-casablanca').addClass('fa-bookmark').attr({ 'onclick' : 'showMistakeMessage('+response.FILEID+')' }).css({ 'cursor' : 'pointer' });
                if(
                    (response.ERRORMESSAGE == "") ||
                    (response.ERRORMESSAGE.queryError == '') ||
                    (response.ERRORMESSAGE.queryError.includes('already exists')) ||
                    (response.ERRORMESSAGE.queryError.includes('There is already an object named')) ||
                    (response.ERRORMESSAGE.queryError.includes('Column names in each table must be unique'))
                ){
                    $(flag).addClass('flagWarning');
                    warningCounter++;
                }else{
                    $(flag).addClass('flagFalse');
                    errorCounter++;
                }

                if( response.ERRORMESSAGE.queryError != undefined ){

                    $("input#fileids_"+response.FILEID+"").parents('tr').after(
                        $('<tr>').attr({ 'id' : 'msgid_' + response.FILEID + '' }).append(
                            $('<td>').attr({ 'colspan' : 9 }).append(
                                $('<table>').addClass('WorkDevList').css({ 'width' : '100%' }).append(
                                    $('<tr>').append($('<td>').css({ 'color' : '#f00' }).text('Type'), $('<td>').text( response.ERRORMESSAGE.Type )),
                                    $('<tr>').append($('<td>').css({ 'color' : '#f00' }).text('Message'), $('<td>').text( response.ERRORMESSAGE.Message )),
                                    $('<tr>').append($('<td>').css({ 'color' : '#f00' }).text('DataSource'), $('<td>').text( response.ERRORMESSAGE.DataSource )),
                                    $('<tr>').append($('<td>').css({ 'color' : '#f00' }).text('queryError'), $('<td>').text( response.ERRORMESSAGE.queryError )),
                                    $('<tr>').append($('<td>').css({ 'color' : '#f00' }).text('Sql'), $('<td>').text( response.ERRORMESSAGE.Sql ))
                                )
                            )
                        ).hide()
                    );

                }

            }

            checkboxid += 1;
            if( $("input[data-id = fileids_"+ checkboxid +"]").length > 0 ){
                var nextfileid = $("input[data-id = fileids_"+ checkboxid +"]").val();
                startRequest( nextfileid, checkboxid );
            }else{
                
                runWro = true;

                $("span.loading").remove();
                $("input[name = upgrade_submit]").prop("disabled",false);

                Swal.fire({
                    title: '<cf_get_lang dictionary_id='54688.Tüm WRO dosyaları çalıştırıldı'>!',
                    html:   '<table class="workDevList">'+
                            '<tr><td width="50"><b><cf_get_lang dictionary_id='55387.Başarılı'></b></td><td>'+successCounter+'</td></tr>'+
                            '<tr><td width="50"><b><cf_get_lang dictionary_id='54686.Hatalı'></b></td><td>'+errorCounter+'</td></tr>'+
                            '<tr><td width="50"><b><cf_get_lang dictionary_id='57425.Uyarı'></b></td><td>'+warningCounter+'</td></tr>'+
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
                })
                
            }

        } );

    }

    $("form[name = form_run_wro]").submit(function(){

        if( !runWro ){
            var fileid = $("input[data-id = fileids_1]").val();
            $(this).find('input[type = submit]').prop('disabled', true);
            startRequest( fileid, 1 );
        }else location.reload();
        return false;

    });

    function showMistakeMessage( fileid ) {
        if( $('tr#msgid_'+fileid+'').hasClass("activeTr") ) 
            $('tr#msgid_'+fileid+'').hide().removeClass("activeTr");
        else $('tr#msgid_'+fileid+'').show().addClass("activeTr");
    }

    /* WRO - Run */

    $("#upgradeLang , #upgradeWo").click(function() {
        $('#form_basket').attr('action', "<cfoutput>#request.self#?fuseaction=settings.wro_control_action</cfoutput>");
        AjaxFormSubmit(form_basket,'ShowDiv','1','<cfoutput>#getLang("main",1926,"Güncelleniyor")#</cfoutput>..','<cfoutput>#getLang("main",1927,"Güncellendi")#</cfoutput>');
	});
</script>
