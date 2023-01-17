<cfscript>
    if ( isDefined("attributes.id") and len( attributes.id ) ) 
    {
        if( IsDefined("attributes.componentFile") ){

            upload_folder = application.systemParam.systemParam().upload_folder;
            download_folder = application.systemParam.systemParam().download_folder;
            fileSystem = createObject("component","V16/asset/cfc/file_system");

            get_bp = get_bp(attributes.id);
            response = StructNew();

            if( get_bp.recordcount ){
                
                fileSystem.newFolder( upload_folder, "wbp" );

                try {
                    uploadedFile = fileUpload( "#upload_folder#wbp", "componentFile", "application/zip", "MakeUnique" );
                    if (not listFindNoCase("zip", uploadedFile.serverFileExt)) {
                        response = { status : false, message : "The uploaded file is not of type ZIP." };
                    }else{
                        update_bp_file_path( 
                            id: attributes.id, 
                            file_path: "documents/wbp/#uploadedFile.clientFileName#"
                        );
                        cfzip( action:"unzip", destination:"#download_folder#/documents/wbp", file:"#download_folder#/documents/wbp/#uploadedFile.clientFileName#.zip" );
                        fileDelete("#download_folder#/documents/wbp/#uploadedFile.clientFileName#.zip");
                        response = { status : true, message : "Upload has been successfuly!", file_path : "documents/wbp/#uploadedFile.clientFileName#" };
                    }
                } catch ( coldfusion.tagext.io.FileUtils$InvalidUploadTypeException e ) {
                    response = { status : false, message : "Your upload file only accepts ZIP files." };
                }

            }else response = { status : false, message : "Best Bractise has been not found!" };

            GetPageContext().getCFOutput().clear();
            WriteOutput(LCase( Replace( SerializeJson( response ), "//", "" ) ));
            abort;

        }else{

            get_bp = get_bp(attributes.id);

            if( not len( attributes.file_path ) and FindNoCase("documents", get_bp.BESTPRACTICE_FILE_PATH) ){//File Path önceden documents içeriyorsa ve değeri boşaltılmışsa documents altındaki folder silinir
                directoryDelete(path:"#download_folder#/#Replace(get_bp.BESTPRACTICE_FILE_PATH,'\','/','all')#", recurse:true);
            }

            update_bp( 
                id: attributes.id, 
                name: attributes.bpname, 
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
                icon_path: attributes.icon_path,
                publish_date: attributes.publish_date
            );
        }
    }
    else 
    {
        attributes.id = insert_bp( 
            name: attributes.bpname, 
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
            icon_path: attributes.icon_path,
            publish_date: attributes.publish_date
        );

        attributes.actionId = attributes.id;

    }
</cfscript>