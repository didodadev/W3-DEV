var parentFolder = "asset_preview";
var childFolder = document.getElementsByName("foldername")[0].value; 
var counterImage = 0;
var counter = 0, jsonData = "", ext = "";
var messageDelete = document.getElementById("message_Del").value;
var messageCancel = document.getElementById("message_Cancel").value;
var allowedfiles = document.getElementById("acceptedfiles") ? document.getElementById("acceptedfiles").value : null;

try{
    Dropzone.autoDiscover = false;
    Dropzone.options.myAwesomeDropzone = false;
    var myDropzone = new Dropzone('#file-dropzone', {  
        url: "V16/asset/cfc/file_system.cfc?method=upload",
        method:"post",  
        paramName: "file",
        params: {parentFolder:parentFolder,childFolder:childFolder} , 
        maxFilesize: 999999999.0, 
        parallelUploads: 10000,
        thumbnailWidth: 100,
        thumbnailHeight: 100,
        uploadMultiple: true,
        autoProcessQueue: true,
        addRemoveLinks: true,
        editFileName: false,
        dictDefaultMessage : 'Dosyayı buraya sürükleyin ya da tıklayıp seçin',
        dictRemoveFile: messageDelete,
        dictFileTooBig : "Büyük dosya boyutu ({{filesize}}MB). Max yükleme boyutu: {{maxFilesize}}MB.",
        dictCancelUpload : messageCancel,
        dictCancelUploadConfirmation    :   "İptal etmek istediğinize emin misiniz?",
        dictInvalidFileType: "Bu tipte bir dosyayı yükleyemezsiniz!",
        acceptedFiles: allowedfiles,
        /*acceptedMimeTypes: "image/jpeg,image/png,image/gif,audio/mpeg,video/mp4,video/mpeg,text/plain,application/msword,application/vnd.openxmlformats-officedocument.wordprocessingml.document,application/vnd.ms-excel,application/vnd.openxmlformats-officedocument.spreadsheetml.sheet,application/pdf,application/vnd.ms-powerpoint,application/vnd.openxmlformats-officedocument.presentationml.presentation,application/zip,audio/mp3,video/x-msvideo,image/bmp,text/csv,image/gif,text/html,image/x-icon,application/vnd.oasis.opendocument.presentation,application/vnd.oasis.opendocument.spreadsheet,application/vnd.oasis.opendocument.text,application/rtf,application/x-shockwave-flash",*/
        init: function() {
            this.on("addedfile", function(file){
                document.getElementById("asset").value = "1";
                $("#wrk_submit_button").prop("disabled",false);
                //$(uploadBadge).find('span.badge').html(this.files.length);
            });
            this.on("removedfile", function(file){
                
                var deleteFileUrl = "V16/asset/cfc/file_system.cfc?method=delete";
                var deleteFiledata = "filePath=" + parentFolder + "/" + childFolder + "/" + file.name;
                counterImage--;
                AjaxRequest(GetAjaxConnector(), deleteFileUrl, 'GET', deleteFiledata);
               
                if(this.files.length == 0){

                    var deleteFolderUrl = "V16/asset/cfc/file_system.cfc?method=deleteFolder";
                    var deleteFolderdata = "folderPath=" + parentFolder + "/" + childFolder;
            
                    AjaxRequest(GetAjaxConnector(), deleteFolderUrl, 'GET', deleteFolderdata);
                    if($("input[name=embcode]").val() == "") $("#wrk_submit_button").prop("disabled",true);
                    document.getElementById("asset").value = ""; 
                }
                //$(uploadBadge).find('span.badge').html(this.files.length);
            });
            this.on("canceled", function(file){

                if(this.files.length == 0){

                    var deleteFolderUrl = "V16/asset/cfc/file_system.cfc?method=deleteFolder";
                    var deleteFolderdata = "folderPath=" + parentFolder + "/" + childFolder;
            
                    AjaxRequest(GetAjaxConnector(), deleteFolderUrl, 'GET', deleteFolderdata);
                    document.getElementById("asset").value = "";

                }

            });
            this.on("error",function(file){
                
                counterImage++;

            });
        },
        success: function(file,r){
            
            jsonData = jQuery.parseJSON(r);
            
            if(jsonData[counter].status){
                
                ext = (jsonData[counter].ext).toLowerCase();
            
                if((ext != 'jpg') && (ext != 'jpeg') && (ext != 'png')){
                    $(".dropzone .dz-preview:eq("+counterImage+") img").attr({"src": "images/intranet/" + ext + ".png"}).addClass("icon");
                }
                
                counterImage++;
                $("#wrk_submit_button").prop("disabled",false);
            }else{

                alert(jsonData[counter].mistakeMessage);         
                $("#wrk_submit_button").prop("disabled",true);       
                $(".dropzone .dz-preview:eq("+counterImage+")").remove();
                if(counterImage != 0) counterImage--; 
                
            }
            
            if(jsonData.length == counter + 1) counter = 0
            else counter++;

        }
    
    });
}
catch(err){
    alert(err);
}

$(function(){

    $('#remove-all').on('click', function () {
        myDropzone.removeAllFiles();
        //$(uploadBadge).find('span.badge').html(myDropzone.files.length);
    });

    $('#close-all').on('click', function () {
        $('#fileUpload').modal('hide');
    });

});