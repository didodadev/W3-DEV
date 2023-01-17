<cfscript>
    if ( isDefined("attributes.id") and len( attributes.id ) ) 
    {
        if( IsDefined("attributes.componentFile") ){

            upload_folder = application.systemParam.systemParam().upload_folder;
            download_folder = application.systemParam.systemParam().download_folder;
            main_folder = Replace(application.systemParam.systemParam().index_folder,"V16/","");
            fileSystem = createObject("component","V16/asset/cfc/file_system");

            get_theme = get_theme(attributes.id);
            response = StructNew();

            if( get_theme.recordcount ){
                
                fileSystem.newFolder( upload_folder, "wpt" );

                try {
                    uploadedFile = fileUpload( "#upload_folder#wpt", "componentFile", "application/zip", "MakeUnique" );
                    if (not listFindNoCase("zip", uploadedFile.serverFileExt)) {
                        response = { status : false, message : "The uploaded file is not of type ZIP." };
                    }else{
                        update_theme_file_path( 
                            id: attributes.id, 
                            file_path: "wpt/#uploadedFile.clientFileName#"
                        );
                        cfzip( action:"unzip", destination:"#main_folder#wpt", file:"#download_folder#/documents/wpt/#uploadedFile.clientFileName#.zip" );
                        fileDelete("#download_folder#/documents/wpt/#uploadedFile.clientFileName#.zip");
                        response = { status : true, message : "Upload has been successfuly!", file_path : "wpt/#uploadedFile.clientFileName#" };
                    }
                } catch ( coldfusion.tagext.io.FileUtils$InvalidUploadTypeException e ) {
                    response = { status : false, message : "Your upload file only accepts ZIP files." };
                }

            }else response = { status : false, message : "Theme has been not found!" };

            GetPageContext().getCFOutput().clear();
            WriteOutput(LCase( Replace( SerializeJson( response ), "//", "" ) ));
            abort;

        }else{

            get_theme = get_theme(attributes.id);

            if( not len( attributes.file_path ) and FindNoCase("documents", get_theme.THEME_FILE_PATH) ){//File Path önceden documents içeriyorsa ve değeri boşaltılmışsa documents altındaki folder silinir
                directoryDelete(path:"#download_folder#/#Replace(get_theme.THEME_FILE_PATH,'\','/','all')#", recurse:true);
            }

            update_theme( 
                id: attributes.id, 
                theme_name: attributes.theme_name, 
                detail: attributes.bpdetail,
                author: attributes.author,
                authorid: attributes.authorid,
                product_id: attributes.product_id,
                file_path: Replace(attributes.file_path,"\","/","all"),
                license: attributes.license,
                is_active: IsDefined("attributes.is_active") ? attributes.is_active : 0,
                process_stage: len(attributes.process_stage) ? attributes.process_stage : 0,
                sector_cats: attributes.sector_cats,
                workcube_product_code: attributes.workcube_product_code,
                preview_path: attributes.preview_path,
                publish_date: attributes.publish_date
            );
        }
    }
    else 
    {
        attributes.id = insert_theme( 
            theme_name: attributes.theme_name, 
            detail: attributes.bpdetail, 
            author: attributes.author,
            authorid: attributes.authorid,
            product_id: attributes.product_id,
            file_path: Replace(attributes.file_path,"\","/","all"),
            license: attributes.license,
            is_active: IsDefined("attributes.is_active") ? attributes.is_active : 0,
            process_stage: len(attributes.process_stage) ? attributes.process_stage : 0,
            sector_cats: attributes.sector_cats,
            workcube_product_code: attributes.workcube_product_code,
            preview_path: attributes.preview_path,
            publish_date: attributes.publish_date
        );

        attributes.actionId = attributes.id;

    }
</cfscript>