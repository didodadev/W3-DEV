var fillSelectbox = function(e,method,target,selectedVal){
    standartOption = $("#"+target + ' option:first');
    $("#"+target + ' option').remove();
    standartOption.appendTo($("#"+target));
    if($(e).val())
    {
    $.ajax({
        url: 'cfc/components.cfc?method='+method+'&data='+$(e).val(),
        success: function(Returning) {
            if(Returning.length)
            {
                returnData = $.parseJSON(Returning);
                for(i=0;i<returnData['DATA'].length;i++)
                {
                    $("<option>").val(returnData['DATA'][i][0]).text(returnData['DATA'][i][1]).appendTo($("#"+target));
                }
            }
        },
        error: function(jqXHR, textStatus, errorThrown) {
            //error message
        }//error
    });//ajax
    }
    if($("#"+target).attr('onchange'))
    $("#"+target).trigger( "onchange" );
    return false;
};

/* $( function() {

    try{ */
    Dropzone.autoDiscover = false;
    myDropzone = new Dropzone('#file-dropzone', {     
        url: "/cfc/workcube_support.cfc?method=GET_FILE_UPLOAD",
        method:"post",  
        paramName: "dosya", 
        maxFilesize: 3.0, 
        parallelUploads: 10000,
        uploadMultiple: true,
        autoProcessQueue: false,
        addRemoveLinks: true,
        editFileName: true,
        dictDefaultMessage : language.dropzone.dictDefaultMessage,
        dictRemoveFile : language.dropzone.dictRemoveFile,
        dictCancelUploadConfirmation : language.dropzone.dictCancelUploadConfirmation,
        dictInvalidFileType : language.dropzone.dictInvalidFileType,
        dictFileTooBig : "büyük dosya boyutu ({{filesize}}MB). Max yükleme boyutu: {{maxFilesize}}MB.",

        init: function() {
            this.on("addedfile", function(file){
                $(uploadBadge).find('span.badge').html(this.files.length);
                });
            this.on("removedfile", function(file){
                $(uploadBadge).find('span.badge').html(this.files.length);
                });
        },

        success: function(file,r){
        
            returningValue = r;     
        }

    });
    /* }
    catch(err){alert(err);} */

    $('#remove-all').on('click', function () {
    myDropzone.removeAllFiles();
    $(uploadBadge).find('span.badge').html(myDropzone.files.length);
    });

    $('#close-all').on('click', function () {
    $('#fileUpload').modal('hide');
    });

/* }); */

var callPage = function(page,formName){
    $("form[name="+formName+"] input[name=page]").val(page);
    $("form[name="+formName+"]").submit();
};

var controlPaging = function(obj){
    $(obj).closest('form').find('input[name=page]').val(1);
}

var fileUploadModal = function(obj){
    uploadBadge = obj;
    actionId = $(obj).parent('div').parent('div').find('input.noteId').val();
    actionSection = 'note';
    $("#fileUpload").modal('show');
};

var fileUploadCallCenter = function(obj,serviceId){
    $("#fileUpload").modal('show');
    uploadBadge = obj;
    actionSection = 'callCenter';
    $("#assetcat_id").val("30");
    $("#property_id").val("26");
    if($("div.modal-footer").find("button#saveAllFileCallCenter").length<1)
    $("<button>").attr({'id':'saveAllFileCallCenter','onclick':'saveCallCenterUpload('+serviceId+')'}).addClass('btn btn-success').html('Kaydet').insertBefore($("button#remove-all"));
}