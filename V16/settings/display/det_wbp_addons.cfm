<cfif IsDefined("attributes.wbp_p_code") and len(attributes.wbp_p_code)>
    <cfhttp url="https://dev.workcube.com/web_services/best_practice_service.cfc?method=getBestPractice" result="response" charset="utf-8">
        <cfhttpparam name="bestpractice_product_code" type="formfield" value="#attributes.wbp_p_code#">
    </cfhttp>
        
    <cfif response.Statuscode eq '200 OK'>

        <cfset responseData =  DeserializeJSON(response.filecontent) />
        <cfif arrayLen(responseData)>

            <style>.fa-angle-down{cursor:pointer;}.activeTr{background:#f5f5f5;}.flagTrue{color:green;}.flagFalse{color:red;}.flagWarning{color:orange;}</style>

            <link rel="stylesheet" href="/css/assets/template/codemirror/codemirror.css">
            <script type="text/javascript" src="/JS/codemirror/codemirror.js"></script>
            <script type="text/javascript" src="/JS/codemirror/simplescrollbars.js"></script>
            <script type="text/javascript" src="/JS/codemirror/sql.js"></script>

            <cffunction  name="get_file_list">
                <cfargument  name="file_path">
            
                <cfif DirectoryExists( arguments.file_path )>
                    <cfdirectory action="list" directory="#arguments.file_path#" recurse="false" name="fileList">
                    <cfreturn fileList>
                <cfelse>
                    <cfreturn { recordCount : 0 }>
                </cfif>
            
            </cffunction>

            <cfquery name="OUR_COMPANY" datasource="#dsn#">
                SELECT DISTINCT OC.COMP_ID, OC.COMPANY_NAME, OC.NICK_NAME
                FROM OUR_COMPANY AS OC
                JOIN OUR_COMPANY_INFO AS OCI ON OC.COMP_ID = OCI.COMP_ID
                WHERE OC.COMP_STATUS = 1 AND <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#attributes.wbp_p_code#"> NOT IN (SELECT * FROM #dsn#.fnSplit((OCI.PROD), ','))
                ORDER BY OC.COMPANY_NAME
            </cfquery>

            <div class="col col-12 col-md-12">
                <div class="row">
                    <cfform name="upload_wbp" type="formControl" action="" method="post">
                        <cfinput type="hidden" name="wbp_name" id="wbp_name" value="#listLast(replace( responseData[1].BESTPRACTICE_FILE_PATH, '\', '/','all' ),'/')#">
                        <cfinput type="hidden" name="wbp_code" id="wbp_code" value="#attributes.wbp_p_code#">
                        <cfinput type="hidden" name="isAjax" id="isAjax" value="1">
                        <div class="col col-8 col-md-8 col-xs-12">
                            <cf_box title="WBP: #responseData[1].BESTPRACTICE_NAME#">
                                <cf_box_elements>
                                    <!--- db_objects --->
                                    <cfset fileList = get_file_list( '#replace( download_folder & responseData[1].BESTPRACTICE_FILE_PATH, '\', '/','all' )#/install/db_objects' ) />
                                    <cfif fileList.recordCount>
                                        <cfset counter = 1 />
                                        <cfset rowStatus = false />
                                        <cf_seperator title="Database tables, views, procedures, functions" id="table_db_objects">
                                        <cf_flat_list id="table_db_objects">
                                            <thead>
                                                <tr>
                                                    <th>Schema</th>
                                                    <th>File</th>
                                                    <th>Status</th>
                                                    <th></th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <cfoutput query="fileList">
                                                    <cfset schemaName = Name />
                                                    <cfif Type eq 'Dir'>
                                                        <cfset dirFileList = get_file_list( '#Directory#/#Name#' ) />
                                                        <cfif dirFileList.recordCount>
                                                            <cfloop query="#dirFileList#">
                                                                <cfif Size gt 0>
                                                                    <tr id="row_db_objects_#counter#">
                                                                        <td>#schemaName#</td>
                                                                        <td>#Name#</td>
                                                                        <td style="width:25px" class="text-center status"><i class="fa fa-2x fa-bookmark-o" data-schema_type="#schemaName#" data-wbp_type="" data-object_type="#listFirst(Name,'.')#"></i></td>
                                                                        <td style="width:25px" class="text-center"><i class="fa fa-2x fa-angle-down" onclick="getFileContent('db_objects','#schemaName#','','#listFirst(Name,'.')#','tr_db_objects_#counter#')"></i></td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td style="display:none; overflow:auto; width:100%;" id="tr_db_objects_#counter#" colspan="4"></td>
                                                                    </tr>
                                                                    <cfset counter++ />
                                                                    <cfset rowStatus = true />
                                                                </cfif>
                                                            </cfloop>
                                                        </cfif>
                                                    </cfif>
                                                </cfoutput>
                                                <cfif !rowStatus><tr><td colspan="4">There is no db object file</td></tr></cfif>
                                            </tbody>
                                        </cf_flat_list>
                                    </cfif>
                                    
                                    <!--- data_library --->
                                    <cfset fileList = get_file_list( '#replace( download_folder & responseData[1].BESTPRACTICE_FILE_PATH, '\', '/','all' )#/install/data_library' ) />
                                    <cfif fileList.recordCount>
                                        <cfset rowStatus = false />
                                        <cfset counter = 1 />
                                        <cf_seperator title="Definitions and Master Datas" id="table_data_library">
                                        <cf_flat_list id="table_data_library">
                                            <thead>
                                                <tr>
                                                    <th>Name</th>
                                                    <th>Schema</th>
                                                    <th>Type</th>
                                                    <th>File</th>
                                                    <th>Status</th>
                                                    <th></th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <cfoutput query="fileList">
                                                    <cfif Type eq 'Dir'>
                                                        <cfset schemaName = Name />
                                                        <cfset dirFileList = get_file_list( '#Directory#/#Name#' ) />
                                                        <cfif dirFileList.recordCount>
                                                            <cfloop query="#dirFileList#">
                                                                <cfif Type eq 'Dir'>
                                                                    <cfset wbpType = Name />
                                                                    <cfset dirTypeFileList = get_file_list( '#Directory#/#wbpType#' ) />
                                                                    <cfif dirTypeFileList.recordCount>
                                                                        <cfloop query="#dirTypeFileList#">
                                                                            <cfif Size gt 0>
                                                                                <tr id="row_data_library_#counter#">
                                                                                    <td>#replace(listFirst(Name,'.'),'_',' ','all')#</td>
                                                                                    <td>#schemaName#</td>
                                                                                    <td>#wbpType#</td>
                                                                                    <td>#Name#</td>
                                                                                    <td style="width:25px" class="text-center status"><i class="fa fa-2x fa-bookmark-o" data-schema_type="#schemaName#" data-wbp_type="#wbpType#" data-object_type="#listFirst(Name,'.')#"></i></td>
                                                                                    <td style="width:25px" class="text-center"><i class="fa fa-2x fa-angle-down" onclick="getFileContent('data_library','#schemaName#','#wbpType#','#listFirst(Name,'.')#','tr_data_library_#counter#')"></i></td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td style="display:none; overflow:auto; width:100%;" id="tr_data_library_#counter#" colspan="6"></td>
                                                                                </tr>
                                                                                <cfset counter++ />
                                                                                <cfset rowStatus = true />
                                                                            </cfif>
                                                                        </cfloop>
                                                                    </cfif>
                                                                </cfif>
                                                            </cfloop>
                                                        </cfif>
                                                    </cfif>
                                                </cfoutput>
                                                <cfif !rowStatus><tr><td colspan="6">There is no data library file</td></tr></cfif>
                                            </tbody>
                                        </cf_flat_list>
                                    </cfif>
                                </cf_box_elements>
                            </cf_box>
                        </div>
                        <div class="col col-4 col-md-4 col-xs-12">
                            <cf_box>
                                <cf_box_elements>
                                    <div class="col-md-12">
                                        <cfif FileExists("#download_folder#/responseData[1].BESTPRACTICE_ICON_PATH")>
                                            <img src = "<cfoutput>#download_folder#/responseData[1].BESTPRACTICE_ICON_PATH</cfoutput>" width="100%">
                                        </cfif>
                                    </div>
                                    <div class="col col-12 col-md-12">
                                        <cf_flat_list>
                                            <tbody>
                                                <cfoutput>
                                                    <tr>
                                                        <td>Developer</td>
                                                        <td>#responseData[1].BESTPRACTICE_AUTHOR#</td>
                                                    </tr>
                                                    <tr>
                                                        <td>Publish Date</td>
                                                        <td>#dateformat(responseData[1].BESTPRACTICE_PUBLISH_DATE,'dd/mm/yyyy')#</td>
                                                    </tr>
                                                    <tr>
                                                        <td>Last Update Date</td>
                                                        <td>#dateformat(responseData[1].UPDATE_DATE,'dd/mm/yyyy')#</td>
                                                    </tr>
                                                    <tr>
                                                        <td>License</td>
                                                        <td>#responseData[1].BESTPRACTICE_LICENSE eq 1 ? 'Standart' : 'Addon'#</td>
                                                    </tr>
                                                    <tr>
                                                        <td>Price</td>
                                                        <td>?</td>
                                                    </tr>
                                                </cfoutput>
                                            </tbody>
                                        </cf_flat_list>    
                                    </div>
                                </cf_box_elements>
                                <cf_box_footer>
                                    <div class="col col-9 col-md-9">
                                        <div class="form-group medium">
                                            <cf_multiselect_check query_name="OUR_COMPANY" name="our_company_ids" option_value="COMP_ID" option_name="NICK_NAME" is_option_text="1" option_text="#getLang('','Şirket Seçiniz',47851)#">	
                                        </div>
                                    </div>
                                    <div class="col col-3 col-md-3">
                                        <div class="form-group medium">
                                            <button type="submit" id="run_wbp" class="ui-wrk-btn ui-wrk-btn-success" style="width:100%; margin:0 0 0 5px;"><cf_get_lang dictionary_id='48868.Yükle'></button>
                                        </div>
                                    </div>
                                </cf_box_footer>
                            </cf_box>
                        </div>
                    </cfform>
                </div>
            </div>

            <script>
            
                function startDBObjectsAjaxRequest( form, row ) {
                    
                    var flag = $("table#table_db_objects tr#row_db_objects_"+ row +" td.status i");
                    
                    if( flag.length > 0 ){
                    
                        flag.removeClass("fa-bookmark-o flagFalse").addClass("fa-cog fa-spin font-yellow-casablanca");

                        var data = "schema_type="+ flag.attr('data-schema_type') +"&wbp_type="+ flag.attr('data-wbp_type') +"&object_type="+ flag.attr('data-object_type') +"&" + form;

                        $.ajax({
                            url: "<cfoutput>#fusebox.server_machine_list#</cfoutput>/V16/settings/cfc/install_wbp.cfc?method=createObject",
                            dataType: "json",
                            method: "post",
                            data: data,
                            success: function( response ) {
                                if( response.STATUS ){
                                    $(flag).removeClass('fa-cog fa-spin font-yellow-casablanca').addClass('fa-bookmark flagTrue');
                                    row += 1;
                                    if( $("table#table_db_objects tr#row_db_objects_"+ row +" td.status i").length > 0 ) startDBObjectsAjaxRequest( form, row );
                                    else startDataLibraryAjaxRequest( form, 1 );
                                }else{
                                    $(flag).removeClass('fa-cog fa-spin font-yellow-casablanca').addClass('fa-bookmark flagFalse').attr({ 'onclick' : 'showInstallMistakeMessage("db_objects","'+row+'")' }).css({ 'cursor' : 'pointer' });
                                    
                                    $('tr#tr_db_objects_mistake_'+row+'').remove();

                                    $(flag).parents('tr').after(
                                        $('<tr>').attr({ 'id' : 'tr_db_objects_mistake_' + row + '' }).append(
                                            $('<td>').attr({ 'colspan' : 4 }).append(
                                                $('<table>').addClass('ajax_list').css({ 'width' : '100%' })
                                            )
                                        ).hide()
                                    );
                                    if( response.MESSAGE != '' ){
                                        $('tr#tr_db_objects_mistake_' + row + ' table').append(
                                            $('<tr>').append($('<td>').css({ 'color' : '#f00' }).text('Message'), $('<td>').text( response.MESSAGE ))
                                        );
                                    }else{
                                        $('tr#tr_db_objects_mistake_' + row + ' table').append(
                                            $('<tr>').append($('<td>').css({ 'color' : '#f00' }).text('Type'), $('<td>').text( response.ERRORMESSAGE.Type )),
                                            $('<tr>').append($('<td>').css({ 'color' : '#f00' }).text('Message'), $('<td>').text( response.ERRORMESSAGE.Message )),
                                            $('<tr>').append($('<td>').css({ 'color' : '#f00' }).text('Detail'), $('<td>').text( response.ERRORMESSAGE.Detail ))
                                        );
                                    }
                                    if( response.ERRORMESSAGE.queryError != undefined ){
                                        $('tr#tr_db_objects_mistake_' + row + ' table').append(
                                            $('<tr>').append($('<td>').css({ 'color' : '#f00' }).text('queryError'), $('<td>').text( response.ERRORMESSAGE.queryError )),
                                            $('<tr>').append($('<td>').css({ 'color' : '#f00' }).text('Sql'), $('<td>').text( response.ERRORMESSAGE.Sql ))
                                        );
                                    }
                                    $("span.loading").remove();
                                }
                            }
                        });
                        
                    }else startDataLibraryAjaxRequest( form, 1 );

                }

                function startDataLibraryAjaxRequest( form, row ) {
                    
                    var flag = $("table#table_data_library tr#row_data_library_"+ row +" td.status i");

                    if( flag.length > 0 ){

                        flag.removeClass("fa-bookmark-o flagFalse").addClass("fa-cog fa-spin font-yellow-casablanca");

                        var data = "schema_type="+ flag.attr('data-schema_type') +"&wbp_type="+ flag.attr('data-wbp_type') +"&object_type="+ flag.attr('data-object_type') +"&" + form;

                        $.ajax({
                            url: "<cfoutput>#fusebox.server_machine_list#</cfoutput>/V16/settings/cfc/install_wbp.cfc?method=InstallDataLibrary",
                            dataType: "json",
                            method: "post",
                            data: data,
                            success: function( response ) {
                                if( response.STATUS ){
                                    $(flag).removeClass('fa-cog fa-spin font-yellow-casablanca').addClass('fa-bookmark flagTrue');
                                }else{
                                    $(flag).removeClass('fa-cog fa-spin font-yellow-casablanca').addClass('fa-bookmark flagFalse').attr({ 'onclick' : 'showInstallMistakeMessage("data_library","'+row+'")' }).css({ 'cursor' : 'pointer' });
                                    
                                    $('tr#tr_data_library_mistake_'+row+'').remove();

                                    $(flag).parents('tr').after(
                                        $('<tr>').attr({ 'id' : 'tr_data_library_mistake_' + row + '' }).append(
                                            $('<td>').attr({ 'colspan' : 6 }).append(
                                                $('<table>').addClass('ajax_list').css({ 'width' : '100%' })
                                            )
                                        ).hide()
                                    );
                                    if( response.MESSAGE != '' ){
                                        $('tr#tr_data_library_mistake_' + row + ' table').append(
                                            $('<tr>').append($('<td>').css({ 'color' : '#f00' }).text('Message'), $('<td>').text( response.MESSAGE ))
                                        );
                                    }else{
                                        $('tr#tr_data_library_mistake_' + row + ' table').append(
                                            $('<tr>').append($('<td>').css({ 'color' : '#f00' }).text('Type'), $('<td>').text( response.ERRORMESSAGE.Type )),
                                            $('<tr>').append($('<td>').css({ 'color' : '#f00' }).text('Message'), $('<td>').text( response.ERRORMESSAGE.Message )),
                                            $('<tr>').append($('<td>').css({ 'color' : '#f00' }).text('Detail'), $('<td>').text( response.ERRORMESSAGE.Detail ))
                                        );
                                    }
                                    if( response.ERRORMESSAGE.queryError != undefined ){
                                        $('tr#tr_data_library_mistake_' + row + ' table').append(
                                            $('<tr>').append($('<td>').css({ 'color' : '#f00' }).text('queryError'), $('<td>').text( response.ERRORMESSAGE.queryError )),
                                            $('<tr>').append($('<td>').css({ 'color' : '#f00' }).text('Sql'), $('<td>').text( response.ERRORMESSAGE.Sql ))
                                        );
                                    }
                                    //$("span.loading").remove();
                                }
                                row += 1;
                                if( $("table#table_data_library tr#row_data_library_"+ row +" td.status i").length > 0 ) startDataLibraryAjaxRequest( form, row );
                                else complete_wbp_upload( form );
                            }
                        });

                    }else{
                        $("button[id = run_wbp]").prop('disabled',false).html("<cf_get_lang dictionary_id='48868.Yükle'>");
                        alert("<cf_get_lang dictionary_id='62865.WBP yükleme işlemi başarıyla tamamlandı'>");
                        location.reload();
                    }

                }

                function complete_wbp_upload( form ) {
                    
                    $.ajax({
                        url: "<cfoutput>#fusebox.server_machine_list#</cfoutput>/V16/settings/cfc/install_wbp.cfc?method=complete_wbp_upload",
                        dataType: "json",
                        method: "post",
                        data: form,
                        success: function( response ) {
                            if( response.STATUS ){
                                $("button[id = run_wbp]").prop('disabled',false).html("<cf_get_lang dictionary_id='48868.Yükle'>");
                                alert("<cf_get_lang dictionary_id='62865.WBP yükleme işlemi başarıyla tamamlandı'>");
                                location.reload();
                            }else{
                                alert("<cf_get_lang dictionary_id='52126.Bir hata oluştu'>");
                            }
                        }
                    });

                }
                
                $("form[name = upload_wbp]").submit(function(){

                    if( confirm( "<cf_get_lang dictionary_id='31761.Devam etmek istediğinize emin misiniz'>?" ) ){
                        if( $("select[name = our_company_ids]").val() != null ){
                            $("button[id = run_wbp]").prop('disabled',true).html('<i class="fa fa-spin fa-spinner"></i>');
                            startDBObjectsAjaxRequest( $(this).serialize(), 1 );
                        }else{
                            alert("<cf_get_lang dictionary_id='62928.En az bir adet şirket seçmelisiniz'>!");
                        }
                    }
                    return false;

                });

                function getFileContent(folder_type, schemaName, wbpType, fileName, showResponseid) {
                    if( $("#"+showResponseid+"").hasClass("activeTr") )
                        $("#"+showResponseid+"").html('').hide().removeClass("activeTr");
                    else{
                        $("#"+showResponseid+"").show().addClass("activeTr");
                        $.ajax({
                            url: "<cfoutput>#fusebox.server_machine_list#</cfoutput>/V16/settings/cfc/install_wbp.cfc?method=getFileContent",
                            method: "post",
                            data: {
                                type: 'HTML',
                                folder_type: folder_type, 
                                wbp_name: document.getElementById('wbp_name').value, 
                                schema_type: schemaName,
                                wbp_type: wbpType,
                                object_type: fileName
                            },
                            success: function( response ) {
                                $("#"+showResponseid+"").html( response );
                                var tableWidth = $("#table_" + folder_type + "").width();
                                setTimeout(function(){
                                    var content = document.getElementById("content_" + folder_type + "_" + fileName);
                                    var editor = CodeMirror.fromTextArea(content, {
                                        mode: "text/x-sql",
                                        lineNumbers: true
                                    });
                                    $(".CodeMirror-scroll").width( tableWidth );
                                }, 1000);
                            }
                        });
                    }
                }

                function showInstallMistakeMessage( folder_type, cmpName ) {
                    if( $('tr#tr_' + folder_type + '_mistake_' + cmpName + '').hasClass("activeTr") ) 
                        $('tr#tr_' + folder_type + '_mistake_'+cmpName+'').hide().removeClass("activeTr");
                    else $('tr#tr_' + folder_type + '_mistake_'+cmpName+'').show().addClass("activeTr");
                }

            </script>
        <cfelse>
            Please choose a WBP!
        </cfif>

    </cfif>

</cfif>