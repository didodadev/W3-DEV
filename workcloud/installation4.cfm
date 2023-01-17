<cfset parameter.setParameterFromDB() /><!--- Parametreleri veritabanından getirir --->
<cfset getParameter = parameter.getParameter() />
<div class="ui-info-text">
    <h1>Upload Workcube System Datas</h1>
</div>
<cfform name="installation_4" id="installation_4" type="formControl" action="#installUrl#" method="post">
    <div class="ui-form-list">
        <div class="col col-12" id="installList">
            <table class="ui-table-list">
                <tr>
                    <td>Upload Langs</td>
                    <td style="width:25px" class="text-center"><i class="fa fa-2x fa-bookmark-o"></i></td>
                </tr>
                <tr>
                    <td>Upload Dictionaries</td>
                    <td style="width:25px" class="text-center"><i class="fa fa-2x fa-bookmark-o"></i></td>
                </tr>
                <tr>
                    <td>Upload Solutions</td>
                    <td style="width:25px" class="text-center"><i class="fa fa-2x fa-bookmark-o"></i></td>
                </tr>
                <tr>
                    <td>Upload Families</td>
                    <td style="width:25px" class="text-center"><i class="fa fa-2x fa-bookmark-o"></i></td>
                </tr>
                <tr>
                    <td>Upload Module</td>
                    <td style="width:25px" class="text-center"><i class="fa fa-2x fa-bookmark-o"></i></td>
                </tr>
                <tr>
                    <td>Upload Modules</td>
                    <td style="width:25px" class="text-center"><i class="fa fa-2x fa-bookmark-o"></i></td>
                </tr>
                <tr>
                    <td>Upload Objects</td>
                    <td style="width:25px" class="text-center"><i class="fa fa-2x fa-bookmark-o"></i></td>
                </tr>
                <tr>
                    <td>Upload Widgets</td>
                    <td style="width:25px" class="text-center"><i class="fa fa-2x fa-bookmark-o"></i></td>
                </tr>
                <tr>
                    <td>Upload WEXs</td>
                    <td style="width:25px" class="text-center"><i class="fa fa-2x fa-bookmark-o"></i></td>
                </tr>
                <tr>
                    <td>Upload Output Templates</td>
                    <td style="width:25px" class="text-center"><i class="fa fa-2x fa-bookmark-o"></i></td>
                </tr>
                <tr>
                    <td>Upload Process Templates</td>
                    <td style="width:25px" class="text-center"><i class="fa fa-2x fa-bookmark-o"></i></td>
                </tr>
            </table>
        </div>
    </div>
    <div class="ui-form-list-btn">
        <div class="col-md-12 paddingLess">
            <div class="form-group button-panel">
                <input  class="btn btn-info" type="submit" value="Next Step">
            </div>
        </div>
    </div>
</cfform>

<script>

    function startWoLangAjaxRequest( processes, row ) {
        
        var flag = $("div#installList table.ui-table-list tr:eq("+row+") td > i");
        $(flag).removeClass('fa-bookmark-o').addClass('fa-cog fa-spin font-yellow-casablanca');
        $.ajax({
            url: "cfc/upgrade_workcube_woLang.cfc?method=runWoLang",
            dataType: "json",
            method: "post",
            data: { functionName: processes[row]['functionName'], recordSettings: JSON.stringify( processes[row]['recordSettings'] ) },
            success: function( response ) {
                if( response.status ){
                    if( response.mode == 'finish' ){
                        $(flag).removeClass('fa-cog fa-spin font-yellow-casablanca').addClass('fa-bookmark flagTrue');
                        row += 1;
                    }
                    else{
						processes[row]['recordSettings']['startrow'] += processes[row]['recordSettings']['maxrows'];
					}
                    if( processes[row] != undefined ) startWoLangAjaxRequest( processes, row );
                    else location.href = '<cfoutput>#installUrl#?installation_type=5</cfoutput>';
                }else{
                    $(flag).removeClass('fa-cog fa-spin font-yellow-casablanca').addClass('fa-bookmark flagFalse').attr({ 'onclick' : 'showWoLangMistakeMessage('+row+')' }).css({ 'cursor' : 'pointer' });
                    
                    $('tr#woLang_'+row+'').remove();

                    $(flag).parents('tr').after(
                        $('<tr>').attr({ 'id' : 'woLang_' + row + '' }).append(
                            $('<td>').attr({ 'colspan' : 2 }).append(
                                $('<table>').addClass('ui-table-list').css({ 'width' : '100%' }).append(
                                    $('<tr>').append($('<td>').css({ 'color' : '#f00' }).text('Type'), $('<td>').text( response.error.type )),
                                    $('<tr>').append($('<td>').css({ 'color' : '#f00' }).text('Message'), $('<td>').text( response.error.message )),
                                    $('<tr>').append($('<td>').css({ 'color' : '#f00' }).text('Detail'), $('<td>').text( response.error.detail ))
                                )
                            )
                        ).hide()
                    );

                    if( response.error.type == 'database' ){
                        $("#woLang_" + row + " table tr:last-child").after(
                            $('<tr>').append($('<td>').css({ 'color' : '#f00' }).text('Sql'), $('<td>').text( response.error.sql )),
                            $('<tr>').append($('<td>').css({ 'color' : '#f00' }).text('Queryerror'), $('<td>').text( response.error.queryerror ))
                        )
                    }

                    $("span.loading").remove();

                }
            }
        });

    }

    $("form[name = installation_4]").submit(function(){

        $("div#installList table.ui-table-list tr td > i").removeClass("fa-bookmark flagFalse").addClass("fa-bookmark-o");

        var processes = [
            { functionName: 'getNewLangs', recordSettings: {} },
            { functionName: 'getNewLanguages', recordSettings: { startrow: 1, maxrows: 2000 } },
            { functionName: 'getNewSolution', recordSettings: {} },
            { functionName: 'getNewFamily', recordSettings: {} },
            { functionName: 'getNewModule', recordSettings: {} },
            { functionName: 'getNewModules', recordSettings: {} },
            { functionName: 'getNewWO', recordSettings: { startrow: 1, maxrows: 1000 } },
            { functionName: 'getNewWidget', recordSettings: { startrow: 1, maxrows: 1000 } },
            { functionName: 'getNewWEX', recordSettings: {} },
            { functionName: 'getNewOutputTemplates', recordSettings: {} },
            { functionName: 'getNewProcessTemplates', recordSettings: {} }

        ];

        startWoLangAjaxRequest( processes, 0 );

        return false;

    });

    function showWoLangMistakeMessage( index ) {
        if( $('tr#woLang_'+index+'').hasClass("activeTr") ) 
            $('tr#woLang_'+index+'').hide().removeClass("activeTr");
        else $('tr#woLang_'+index+'').show().addClass("activeTr");
    }

</script>