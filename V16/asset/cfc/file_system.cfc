<!--- 
    Author : Uğur Hamurpet
    Create Date : 01/12/2018
    methods : {
        newFolder : 'CREATE NEW FOLDER',
        fileListinFolder : 'FILE LIST IN FOLDER',
        deleteFolder : 'DELETE FOLDER',
        fileControl : 'FILE CONTROL'
        upload : 'FILE UPLOAD'
        copy : 'COPY FILE'
        write : 'WRITE FILE'
        rename : 'RENAME FILE'
        delete : 'DELETE FILE'
        fileType : 'FILE TYPE'
    }
--->

<cfcomponent>

    <cfset uploadFolder = application.systemParam.systemParam().upload_folder>
    <cfset dsn = application.systemParam.systemParam().dsn>

    <cffunction name="newFolder" access="remote" displayName="CREATE NEW FOLDER" returntype="any">
        <cfargument name="folderPath" type="string" required="true">
        <cfargument name="folderName" type="string" required="true">

        <cfif not directoryexists("#folderPath & "/" & folderName#")>
            <cfdirectory action="create" directory="#folderPath & "/" & folderName#">
        </cfif>

    </cffunction>

    <cffunction name="fileListinFolder" access="remote" displayName="FILE LIST IN FOLDER" recurse="false" type="file" returntype="any">
        <cfargument name="folderPath" type="string" required="true">

        <cfif directoryexists("#uploadFolder##folderPath#")>
            <cfdirectory action="list" directory="#uploadFolder##folderPath#" recurse="false" name="fileList">
            <cfreturn fileList>
        <cfelse>
            <cfdirectory action="create" directory="#uploadFolder##folderPath#">
        </cfif>
    </cffunction>

    <cffunction name="deleteFolder" access="remote" displayName="DELETE FOLDER" returntype="any">
        <cfargument name="folderPath" type="string" required="true">

        <cfif directoryexists("#uploadFolder##folderPath#")>
            <cfdirectory action="delete" directory="#uploadFolder##folderPath#">
        </cfif>

    </cffunction>

    <cffunction name="fileControl" access="remote" displayName="FILE CONTROL" returntype="any" returnFormat="json">
        <cfargument name="filePath" type="string" required="true">
        <cfargument name="file" required="true">

        <cfset assetTypeName = listlast(file.SERVERFILE,'.')>
        <!---<cfif (listlen(file.SERVERFILE,'.') eq 2) and (FindNoCase(",",file.SERVERFILE) eq 0)>---->
            <!---Script dosyalarını engelle--->  
            <cfset blackList = 'php,php2,php3,php4,php5,phtml,pwml,inc,asp,aspx,ascx,jsp,cfm,cfml,cfc,pl,bat,exe,com,dll,vbs,reg,cgi,htaccess,asis'>
            <cfif listfind(blackList,file.SERVERFILEEXT,',')>

                <cfif FileExists("#filePath#/#file.SERVERFILENAME#")>
                    <cffile action="delete" file="#filePath#/#file.SERVERFILENAME#">
                </cfif>
                <cfset answer["status"] = false>
                <cfset answer["message"] = "<cf_get_lang no='133.php,jsp,asp,cfm,cfml Formatlarda Dosya Girmeyiniz'>">
            
            <cfelse>

                <!---Büyük dosya Boyutlarını Engelle --->
                <cfquery name="GET_FILE_SIZE_COMP" datasource="#dsn#">
                    SELECT ISNULL(FILE_SIZE,0) AS FILE_SIZE,ISNULL(IS_FILE_SIZE,0) IS_FILE_SIZE FROM OUR_COMPANY_INFO WHERE COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
                </cfquery>
                <cfif len(get_file_size_comp.is_file_size) and get_file_size_comp.is_file_size>
                    <cfquery name="GET_FILE_SIZE" datasource="#dsn#">
                        SELECT FORMAT_SYMBOL,FORMAT_SIZE FROM SETUP_FILE_FORMAT WHERE FORMAT_SYMBOL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#assetTypeName#">
                    </cfquery>
                    <cfif get_file_size.recordcount and len(get_file_size.format_size)>
                        <cfset dt_size=get_file_size.format_size * 1048576>
                        <cfif INT(dt_size) lte INT(file.FILESIZE) and file.FILESIZE gt 0>

                            <cfif FileExists("#filePath#/#file.SERVERFILENAME#")>
                                <cffile action="delete" file="#filePath#/#file.SERVERFILENAME#">
                            </cfif>
                            <cfset answer["status"] = false>
                            <cfset answer["message"] = "#file.SERVERFILENAME# : (#getLang('assetcare',478)# : 0.1MB) - (#getLang('assetcare',476)# : #get_file_size.format_size#MB)">
                    
                        <cfelse>

                            <cfset answer["status"] = true>

                        </cfif>
                    <cfelse>
                        <cfif len(get_file_size_comp.file_size) and (get_file_size_comp.file_size * 1048576) lte file.fileSize and file.fileSize gt 0>
                                
                                <cfif FileExists("#filePath#/#file.SERVERFILENAME#")>
                                    <cffile action="delete" file="#filePath#/#file.SERVERFILENAME#">
                                </cfif>
                                <cfset answer["status"] = false>
                                <cfset answer["message"] = "#file.SERVERFILENAME# : (#getLang('assetcare',478)# : 0.1MB) - (#getLang('assetcare',476)# : #get_file_size.format_size#MB)">

                        <cfelse>

                            <cfset answer["status"] = true>

                        </cfif>  
                    </cfif>

                <cfelse>

                    <cfset answer["status"] = true>

                </cfif>

            </cfif>
        <!----<cfelse>
            
            <cfset answer["status"] = false>
            <cfset answer["message"] = "Hatalı dosya adi girdiniz.">
            	
        </cfif>---->
        <cfreturn answer>

    </cffunction>

    <cffunction name="upload" access="remote"  displayName="FILE UPLOAD" returntype="any" returnFormat="json">
        <cfargument name="parentFolder" type="string" required="true">
        <cfargument name="childFolder" type="string" required="false" default="">
        <cfargument name="encryptedName" type="boolean" required="false" default="false">

        <cfset arguments.files = []>
        
        <cfif not directoryexists("#uploadFolder & "/" & parentFolder#")>
            <cfset newFolder(folderPath:uploadFolder,folderName:parentFolder) />
        </cfif>

        <cfif len(childFolder)>
            <cfset path = uploadFolder & parentFolder>
            <cfset filePath = path & "/" & childFolder>
            <cfset fileFolder = parentFolder & "/" & childFolder>
            <cfset newFolder(folderPath:path,folderName:childFolder)>
        <cfelse>
            <cfset filePath = uploadFolder & parentFolder>
            <cfset fileFolder = parentFolder>
        </cfif>

        <cffile action="uploadAll" destination="#filePath#"  result="UPLOADALL_RESULTS" NAMECONFLICT="Overwrite"><!--- Tüm dosyaları yükler --->
        <cfloop from="1" to="#arrayLen(UPLOADALL_RESULTS)#" index="i">
              <cfset file = UPLOADALL_RESULTS[i]>
              <cfscript>
              suitableFile = fileControl(filePath:filePath,file:file);
              
              if(suitableFile["status"] eq true){

                    newFileName = newFullFileName = "";

                    if( encryptedName ){
                        newFileName = createUUID();
                        newFullFileName = newFileName & "." & file.SERVERFILEEXT;
                        this.rename(
                            filePath: fileFolder & "/" & file.SERVERFILE,
                            newfilePath: filePath & "/" & newFullFileName  
                        );
                    }

                    arguments.files[i]['status'] = true;
                    arguments.files[i]['fileName'] = file.SERVERFILE;
                    arguments.files[i]['encryptedName'] = newFileName;
                    arguments.files[i]['fullfileName'] = file.SERVERFILENAME;
                    arguments.files[i]['fullEncryptedName'] = newFullFileName;
                    arguments.files[i]['filePath'] = filePath;
                    arguments.files[i]['fileFullPath'] = filePath & "/" & newFullFileName;
                    arguments.files[i]['ext'] = file.SERVERFILEEXT;
                    arguments.files[i]['fileSize'] = file.FILESIZE;
                    arguments.files[i]['mimeType']  = file.CONTENTTYPE;
                    arguments.files[i]['folderInfo']  = {
                        parentFolder: arguments.parentFolder,
                        childFolder: arguments.childFolder
                    };
                    
              }else{

                    arguments.files[i]['status'] = false;
                    arguments.files[i]['mistakeMessage'] = suitableFile["message"];

              }
                
              </cfscript>
              
        </cfloop>

        <cfreturn Replace(SerializeJSON(arguments.files),'//','')>

    </cffunction>

    <cffunction name="copy" access="remote" displayName="COPY FILE" returntype="any">
        <cfargument name="filePath" type="string" required="true">
        <cfargument name="newfilePath" type="string" required="true">

        <cffile action="copy" source="#filePath#" destination="#newfilePath#">

    </cffunction>

    <cffunction name="write" access="remote" displayName="WRITE FILE" returntype="any">
        <cfargument name="filePath" type="string" required="true">
        <cfargument name="output" type="string" required="true">
        <cfargument name="charset" type="string" default="utf-8" required="false">

        <cffile action="write" file="#filePath#" output="#output#" charset="#charset#" />

    </cffunction>

    <cffunction name="rename" access="remote" displayName="RENAME FILE" returntype="any" NAMECONFLICT="Overwrite">
        <cfargument name="filePath" type="string" required="true">
        <cfargument name="newfilePath" type="string" required="true">
        <cfif FileExists("#uploadFolder##filePath#")>
            <cffile action="rename" source="#uploadFolder##filePath#" destination="#newfilePath#">
        <cfelse>
            <cffile action="rename" source="#filePath#" destination="#newfilePath#">
        </cfif>
    </cffunction>

    <cffunction name="delete" access="remote" displayName="DELETE FILE" returntype="any">
        <cfargument name="filePath" type="string">
        <cfargument name="fileFullPath" type="string">
        
        <cfset file_full_path = (isdefined("arguments.fileFullPath") and len( arguments.fileFullPath )) ? arguments.fileFullPath : "#uploadFolder#/#filePath#" />

        <cftry>
            <cfif FileExists(file_full_path) >
                <cffile action="Delete" file="#file_full_path#">
            </cfif>
            <cfreturn true>
        <cfcatch type = "any">
            <cfreturn false>
        </cfcatch>
        </cftry>
        
    </cffunction>

    <cffunction name="fileType" access="remote" displayName="FILE TYPE" returntype="any">
        <cfargument name="ext" type="string" required="true">
        
        <cfset docExt   =   ["pdf","doc","docx","xls","xlsx","ppt","pptx","dwg"]>
        <cfset otherExt =   ["txt","zip","rar","ico","ai","xml","avi","flv","mov","swf","bmp","cdd","cdmz","cfm","csv","eml","exe","fla","htm","html","ini","java","mdb","ods","odt","psd","rtf","swf","wma","vsd"]> <!--- "avi","flv","swf" (html5 video etiketi desteklemediği için) --->
        <cfset videoExt =   ["mp4","mpeg"]>
        <cfset audioExt =   ["mp3","ogg","wav"]>
        <cfset imageExt =   ["jpg","jpeg","png","gif"]>

        <cfif ArrayFindNoCase(docExt,lcase(ext))>
            
            <cfset returnInfo["fileType"] = "document">
        
        <cfelseif ArrayFindNoCase(otherExt,lcase(ext))>

            <cfset returnInfo["fileType"] = "other">

        <cfelseif ArrayFindNoCase(videoExt,lcase(ext))>

            <cfset returnInfo["fileType"] = "video">

        <cfelseif ArrayFindNoCase(audioExt,lcase(ext))>

            <cfset returnInfo["fileType"] = "audio">

        <cfelseif ArrayFindNoCase(imageExt,lcase(ext))>

            <cfset returnInfo["fileType"] = "image">

        <cfelse>

            <cfset returnInfo["fileType"] = "noType">

        </cfif>

        <cfreturn returnInfo>

    </cffunction>

</cfcomponent>