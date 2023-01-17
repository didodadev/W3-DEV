<cfset getParameter = parameter.getParameter() />

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
            
            <div class="ui-info-text">
                <h1>WBP: <cfoutput>#responseData[1].BESTPRACTICE_NAME#</cfoutput></h1>
            </div>
            
            <div class="col-md-12 paddingLess">
                <div class="row">
                    <cfform name="installation_9" type="formControl" action="#installUrl#" method="post">
                        <cfinput type="hidden" name="wbp_name" id="wbp_name" value="#listLast(replace( responseData[1].BESTPRACTICE_FILE_PATH, '\', '/','all' ),'/')#">
                        <cfinput type="hidden" name="wbp_code" id="wbp_code" value="#attributes.wbp_p_code#">
                        <cfinput type="hidden" name="our_company_ids" id="our_company_ids" value="1">
                        <div class="col-md-8 pdnr">
                            <cfif attributes.wbp_p_code neq 'FS023'>
                            <!--- db_objects --->
                            <div style="margin-bottom:20px;">
                                <cfset fileList = get_file_list( '#index_folder##replace( responseData[1].BESTPRACTICE_FILE_PATH, '\', '/','all' )#/install/db_objects' ) />
                                <cfif fileList.recordCount>
                                    <cfset counter = 1 />
                                    <cfset rowStatus = false />
                                    <h4 style="color:#e69192;">Database tables, views, procedures, functions</h4>
                                    <table class="ui-table-list" id="table_db_objects">
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
                                    </table>
                                </cfif>
                            </div>
                            </cfif>
                            
                            <!--- data_library --->
                            <div>
                                <cfset fileList = get_file_list( '#index_folder##replace( responseData[1].BESTPRACTICE_FILE_PATH, '\', '/','all' )#/install/data_library' ) />
                                <cfif fileList.recordCount>
                                    <cfset rowStatus = false />
                                    <cfset counter = 1 />
                                    <h4 style="color:#e69192;">Definitions and Master Datas</h4>
                                    <table class="ui-table-list" id="table_data_library">
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
                                                                <cfif (isdefined('url.stepimp') and url.stepimp eq 1 and attributes.wbp_p_code eq 'FS023' and wbpType eq 'implementation_step') or not isdefined('url.stepimp')>
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
                                                            </cfif>
                                                        </cfloop>
                                                    </cfif>
                                                </cfif>
                                            </cfoutput>
                                            <cfif !rowStatus><tr><td colspan="6">There is no data library file</td></tr></cfif>
                                        </tbody>
                                    </table>
                                </cfif>
                            </div>
                            <div class="ui-form-list-btn">
                                <div class="form-group button-panel">
                                    <input  class="btn btn-info" type="submit" value="Install">
                                </div>
                            </div>
                        </div>
                        <div class="col-md-4 pdnr">
                            <div class="col-md-12">
                                <cfif FileExists("#index_folder#/responseData[1].BESTPRACTICE_ICON_PATH")>
                                    <img src = "<cfoutput>#installUrl#/responseData[1].BESTPRACTICE_ICON_PATH</cfoutput>" width="100%">
                                </cfif>
                            </div>
                            <div class="col-md-12">
                                <table class="ui-table-list">
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
                                </table>    
                            </div>
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
                            url: "cfc/install_wbp.cfc?method=createObject",
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
                                                $('<table>').addClass('ui-table-list').css({ 'width' : '100%' })
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
                            url: "cfc/install_wbp.cfc?method=InstallDataLibrary",
                            dataType: "json",
                            method: "post",
                            data: data,
                            success: function( response ) {
                                if( response.STATUS ){
                                    $(flag).removeClass('fa-cog fa-spin font-yellow-casablanca').addClass('fa-bookmark flagTrue');
                                    row += 1;
                                    if( $("table#table_data_library tr#row_data_library_"+ row +" td.status i").length > 0 ) startDataLibraryAjaxRequest( form, row );
                                    else complete_wbp_upload( form );
                                }else{
                                    $(flag).removeClass('fa-cog fa-spin font-yellow-casablanca').addClass('fa-bookmark flagFalse').attr({ 'onclick' : 'showInstallMistakeMessage("data_library","'+row+'")' }).css({ 'cursor' : 'pointer' });
                                    
                                    $('tr#tr_data_library_mistake_'+row+'').remove();

                                    $(flag).parents('tr').after(
                                        $('<tr>').attr({ 'id' : 'tr_data_library_mistake_' + row + '' }).append(
                                            $('<td>').attr({ 'colspan' : 6 }).append(
                                                $('<table>').addClass('ui-table-list').css({ 'width' : '100%' })
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
                                    $("span.loading").remove();
                                }
                            }
                        });

                    }else{
                        //else location.href = '<cfoutput>#installUrl#?installation_type=6</cfoutput>';
                    }

                }

                function complete_wbp_upload( form ) {
                    
                    $.ajax({
                        url: "cfc/install_wbp.cfc?method=complete_wbp_upload",
                        dataType: "json",
                        method: "post",
                        data: form,
                        success: function( response ) {
                            if( response.STATUS ){
                                alert("WBP Upload Completed");
                                location.href = '<cfoutput>#listFirst(getParameter.fusebox.server_machine_list)#</cfoutput>';
                            }else{
                                alert("There is an error!");
                            }
                        }
                    });

                }

                $("form[name = installation_9]").submit(function(){

                    startDBObjectsAjaxRequest( $(this).serialize(), 1 );
                    return false;

                });

                function getFileContent(folder_type, schemaName, wbpType, fileName, showResponseid) {
                    if( $("#"+showResponseid+"").hasClass("activeTr") )
                        $("#"+showResponseid+"").html('').hide().removeClass("activeTr");
                    else{
                        $("#"+showResponseid+"").show().addClass("activeTr");
                        $.ajax({
                            url: "cfc/install_wbp.cfc?method=getFileContent",
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