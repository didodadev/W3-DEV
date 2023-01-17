<script language="JavaScript">
    function process_cat_show (e){
        if($(e).prop('checked') == true)
            $("#div_process_cat").show();
        else
            $("#div_process_cat").hide();
            
    }
    function loadFamilies(solutionId,target,related,selected)
    {
        $('#'+related+" option[value!='']").remove();
        $.ajax({
              url: '/WMO/GeneralFunctions.cfc?method=getFamily&dsn=<cfoutput>#dsn#</Cfoutput>&solutionId=' + solutionId,
              success: function(data) {
                if(data)
                {
                    $('#'+target+" option[value!='']").remove();
                    data = $.parseJSON( data );
                    for(i=0;i<data.DATA.length;i++)
                    {
                        var option = $('<option/>');
                        if(selected && selected == data.DATA[i][0])
                            option.attr({ 'value': data.DATA[i][0], 'selected':'selected' }).text(data.DATA[i][1]);
                        else
                            option.attr({ 'value': data.DATA[i][0] }).text(data.DATA[i][1]);
                        $('#'+target).append(option);
                    }
                }
              }
           });
    }
    function loadModules(familyId,target,selected)
    {
        $.ajax({
              url: '/WMO/GeneralFunctions.cfc?method=getModule&dsn=<cfoutput>#dsn#</Cfoutput>&familyId=' + familyId,
              success: function(data) {
                if(data)
                {
                    $('#'+target+" option[value!='']").remove();
                    data = $.parseJSON( data );
                    for(i=0;i<data.DATA.length;i++)
                    {
                        var option = $('<option/>');
                        if(selected && selected == data.DATA[i][0])
                            option.attr({ 'value': data.DATA[i][0], 'selected':'selected' }).text(data.DATA[i][1]);
                        else
                            option.attr({ 'value': data.DATA[i][0] }).text(data.DATA[i][1]);
                        $('#'+target).append(option);
                    }
                }
              }
           });
    }
    $(function(){
        <cfif len(get_wrk_fuseactions.SOLUTION_ID)>
            loadFamilies('<cfoutput>#get_wrk_fuseactions.SOLUTION_ID#</cfoutput>','family','module','<cfoutput>#get_wrk_fuseactions.FAMILY_ID#</cfoutput>');
        </cfif>
        <cfif len(get_wrk_fuseactions.FAMILY_ID)>
            loadModules('<cfoutput>#get_wrk_fuseactions.FAMILY_ID#</cfoutput>','module','<cfoutput>#get_wrk_fuseactions.MODULE_NO#</cfoutput>');
        </cfif>
        
        });
    function OnFormSubmit()
    {
        if ( process_cat_dsp_function !== undefined ) {
            if ( ! process_cat_dsp_function() ) {
                return false;
            }
        }
        
        if ( ! $("#updFuseactionForm")[0].checkValidity() ) {
            $("#hidden_submit_btn").trigger("click");
            return false;
        }

        if( document.getElementById('is_legacy').value != '2' && document.getElementById('file_path').value == '' )
        {
            alert('Objeye ait dosya yolunu tanımlayınız !');
            return false;	
        }
        if(document.getElementById('fuseaction_name').value == '')
        {
            alert('Fuseaction Tanımlayınız !');
            return false;	
        }
        
        
        if(CKEDITOR.instances['wo_detail'] != undefined)
            $("#wo_detail").val(CKEDITOR.instances['wo_detail'].getData());
      /*   AjaxFormSubmit('updFuseactionForm','fuseactionControlDiv',1,'Güncelleniyor','Güncellendi','','',1);
        return false; */
    }
    function showHide(e)
    {
        if( $(e).val() == 3 ){
            $('#addOptionsController').removeClass('hide');
            $('#controllerFilePath').addClass('hide');
        }else{
            $('#addOptionsController').addClass('hide');
            $('#controllerFilePath').removeClass('hide');
        }
    }
    </script>