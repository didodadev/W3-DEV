
$(function () {

    var parentFolder = "messageFiles";
    var counterImage = 0;
    var counter = 0, jsonData = "", ext = "";
    var childFolder = document.getElementById("foldername").value;
    var messageDelete = document.getElementById("message_Del").value;
    var messageCancel = document.getElementById("message_Cancel").value;

    function removeFile( file ) {
        window.messageFiles.forEach((element, index) => {
            if( element.fileName == file.name ) window.messageFiles.splice( index, 1 );
        });
    }

    function getFile( file ) {
        return window.messageFiles.filter((element) => {
            return element.fileName.toLowerCase() == file.name.toLowerCase();
        });
    }

    //try{
        Dropzone.autoDiscover = false;
        Dropzone.options.myAwesomeDropzone = false;
        var myDropzone = new Dropzone('#file-dropzone', {  
            url: "V16/asset/cfc/file_system.cfc?method=upload",
            method:"post",  
            paramName: "file",
            params: {parentFolder:parentFolder,childFolder:childFolder,encryptedName:true,isAjax:1},
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
            /*acceptedMimeTypes: "image/jpeg,image/png,image/gif,audio/mpeg,video/mp4,video/mpeg,text/plain,application/msword,application/vnd.openxmlformats-officedocument.wordprocessingml.document,application/vnd.ms-excel,application/vnd.openxmlformats-officedocument.spreadsheetml.sheet,application/pdf,application/vnd.ms-powerpoint,application/vnd.openxmlformats-officedocument.presentationml.presentation,application/zip,audio/mp3,video/x-msvideo,image/bmp,text/csv,image/gif,text/html,image/x-icon,application/vnd.oasis.opendocument.presentation,application/vnd.oasis.opendocument.spreadsheet,application/vnd.oasis.opendocument.text,application/rtf,application/x-shockwave-flash",*/
            init: function() {
                this.on("addedfile", function(file){
                    $("#messageFileUploadButton").prop("disabled",false);
                    sendButtonManagement();
                });
                this.on("removedfile", function(file){
                    
                    fileInfo = getFile( file );
                    dropThis = this;

                    let data = new FormData();
                    data.append('fileFullPath', fileInfo[0].fileFullPath);

                    AjaxControlPostData( "V16/asset/cfc/file_system.cfc?method=delete", data, function( response ) {

                        if( response ){

                            removeFile( file );
                            
                            if(dropThis.files.length == 0){

                                var deleteFolderUrl = "V16/asset/cfc/file_system.cfc?method=deleteFolder";
                                var deleteFolderdata = "folderPath=" + parentFolder + "/" + childFolder;
                        
                                AjaxRequest(GetAjaxConnector(), deleteFolderUrl, 'GET', deleteFolderdata);
    
                                counterImage--;
                            }

                        }

                        sendButtonManagement();

                    } );
                    
                });
                this.on("canceled", function(file){

                    if(this.files.length == 0){

                        var deleteFolderUrl = "V16/asset/cfc/file_system.cfc?method=deleteFolder";
                        var deleteFolderdata = "folderPath=" + parentFolder + "/" + childFolder;
                
                        AjaxRequest(GetAjaxConnector(), deleteFolderUrl, 'GET', deleteFolderdata);

                    }
                    sendButtonManagement();
                    
                });
                this.on("error",function(file){
                    
                    counterImage++;
                    sendButtonManagement();
                    
                });
                this.on('resetFiles', function() {
                    if(this.files.length != 0){
                        for(i=0; i<this.files.length; i++){
                            var _ref;
                            if ((_ref = this.files[i].previewElement) != null) {
                                _ref.parentNode.removeChild(this.files[i].previewElement);
                            }
                            this._updateMaxFilesReachedClass();
                        }
                    }
                    window.messageFiles = [];
                });
            },
            success: function(file,r){
                
                jsonData = JSON.parse(r);
                
                if(jsonData[counter].status){
                    
                    ext = (jsonData[counter].ext).toLowerCase();
                
                    if((ext != 'jpg') && (ext != 'jpeg') && (ext != 'png')){
                        $(".dropzone .dz-preview:eq("+counterImage+") img").attr({"src": "images/intranet/" + ext + ".png"}).addClass("icon");
                    }
                    
                    counterImage++;

                    window.messageFiles = jsonData;

                }else{

                    alert(jsonData[counter].mistakeMessage);              
                    $(".dropzone .dz-preview:eq("+counterImage+")").remove();
                    if(counterImage != 0) counterImage--; 
                    
                }
                
                if(jsonData.length == counter + 1) counter = 0
                else counter++;

                sendButtonManagement();

            }
        
        });
   /*  }
    catch(err){
        alert(err);
    } */

});