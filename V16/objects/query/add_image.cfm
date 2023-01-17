<!---
    File: add_image.cfm
    Folder: V16\objects\query\
	Controller:
    Author:
    Date:
    Description:
        
    History:
        Gramoni-Mahmut Çifçi mahmut.cifci@gramoni.com
        2019-12-30 14:09:40
        Yükleme yapılan dizinlerin var olup olmadığı kontrol edildi. Dizin yok ise oluşturulması sağlandı.
    To Do:

--->

<cfif attributes.type eq "product">
    <cfif Not directoryExists('#upload_folder#product')>
        <cfset directoryCreate('#upload_folder#product') />
    </cfif>
    <cfif attributes.image_type eq "brand"><!--- Ürün kategorilerinden Eklenmişse --->
        <cfset table = "PRODUCT_BRANDS_IMAGES">
        <cfset identity_column = "BRAND_ID">
    <cfelseif attributes.image_type eq "product"><!--- Ürün den eklenmişse --->
        <cfset table = "PRODUCT_IMAGES">
        <cfset identity_column = "PRODUCT_ID">
    </cfif>
    <cfif isDefined("attributes.image_file")  and len(attributes.image_file) and isDefined("attributes.image_url_link")  and len(attributes.image_url_link)>
        <cftry>
            <cfset file_name = createUUID()>
            <cffile action="UPLOAD" 
                    destination="#upload_folder#product#dir_seperator#" 
                    filefield="image_file"  
                    nameconflict="MAKEUNIQUE"> <!---accept="image/*"---> 
            <cffile action="rename" source="#upload_folder#product#dir_seperator##cffile.serverfile#" destination="#upload_folder#product#dir_seperator##file_name#.#cffile.serverfileext#">
            <cfcatch type="any">
                <script type="text/javascript">
                    alert("Lütfen imaj dosyası giriniz!");
                    history.back();
                </script>
                <cfabort>
            </cfcatch>
        </cftry>
        <cfset assetTypeName = listlast(cffile.serverfile,'.')>
        <cfset blackList = 'php,php2,php3,php4,php5,phtml,pwml,inc,asp,aspx,ascx,jsp,cfm,cfml,cfc,pl,bat,exe,com,dll,vbs,reg,cgi,htaccess,asis'>
        <cfif listfind(blackList,assetTypeName,',')>
            <cffile action="delete" file="#upload_folder#product#dir_seperator##file_name#.#cffile.serverfileext#">
            <script type="text/javascript">
                alert("\'php\',\'jsp\',\'asp\',\'cfm\',\'cfml\' Formatlarında Dosya Girmeyiniz!!");
                history.back();
            </script>
            <cfabort>
        </cfif>
        <cfset  session.imFile = #file_name#&"."&#cffile.serverfileext#>
    
        <cfif (findnocase("gif","#CFFILE.SERVERFILE#",1) neq 0) and isDefined("rd")>
            <cfscript>
                CFFILE.SERVERFILE = listgetat(CFFILE.SERVERFILE,1,".")&"."&"jpg";
                cffile.serverfileext = "jpg";
            </cfscript>
        </cfif>
        <cfset size = cffile.fileSize / 1024>
        
        <cfquery name="ADD_IMAGE" datasource="#DSN1#">
            INSERT INTO 
                #table#
                (
                    IS_INTERNET,
                    #identity_column#,
                    PATH,
                    PATH_SERVER_ID,
                    PRD_IMG_NAME,
                    IMAGE_SIZE,
                    <cfif attributes.image_type eq "product">
                        STOCK_ID,
                    </cfif>
                    LANGUAGE_ID,
                    UPDATE_DATE,
                    UPDATE_EMP,
                    UPDATE_IP,
                    IS_EXTERNAL_LINK,
                    VIDEO_LINK,
                    VIDEO_PATH,
                    DETAIL
                )
                VALUES
                (
                    <cfif isdefined("attributes.is_internet")>1,<cfelse>0,</cfif>
                    #attributes.image_action_id#,
                    '#file_name#.#cffile.serverfileext#',
                    '#fusebox.server_machine#',
                    #sql_unicode()#'#attributes.image_name#', 
                    <cfif isdefined("attributes.size") and len(attributes.size)>#attributes.size#,<cfelse>NULL,</cfif>
                    <cfif attributes.image_type eq "product">
                        <cfif isdefined("attributes.stock_id") and len(attributes.stock_id)>',#attributes.stock_id#,'<cfelse>NULL</cfif>,
                    </cfif>
                    '#attributes.language_id#',
                    #NOW()#,
                    <cfif listfindnocase(employee_url,'#cgi.http_host#',';')>
                    #session.ep.userid#,
                    <cfelseif listfindnocase(partner_url,'#cgi.http_host#',';')>
                    #session.pp.userid# ,
                    </cfif>
                    '#cgi.REMOTE_ADDR#',
                    1,
                    0,
                    '#attributes.image_url_link#',
                    '#attributes.DETAIL#'
                )
        </cfquery>
        <cfset session.resim = 4>
        <cfif not isDefined("rd")>
            <script type="text/javascript">
                <cfif not isdefined("attributes.draggable")>
                    location.href = document.referrer;
                    window.close();
                <cfelse>
                    closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>','unique_imgs_get');
                </cfif>
            </script>
            <cfabort>
        </cfif>
    <cfelseif isDefined("attributes.image_url_link")  and len(attributes.image_url_link)>
        <cfquery name="ADD_IMAGE" datasource="#DSN1#">
            INSERT INTO 
                #table#
                (
                    IS_INTERNET,
                    #identity_column#,
                    VIDEO_PATH,
                    PRD_IMG_NAME,
                    IMAGE_SIZE,
                    STOCK_ID,
                    UPDATE_DATE,
                    UPDATE_EMP,
                    UPDATE_IP,
                    PATH_SERVER_ID,
                    IS_EXTERNAL_LINK,
                    VIDEO_LINK,
                    DETAIL
                )
                VALUES
                (
                    <cfif isdefined("attributes.is_internet")>1,<cfelse>0,</cfif>
                    #attributes.image_action_id#,
                    '#attributes.image_url_link#',
                    #sql_unicode()#'#attributes.image_name#', 
                    <cfif isdefined("attributes.size") and len(attributes.size)>#attributes.size#,<cfelse>NULL,</cfif>
                    <cfif isdefined("attributes.stock_id") and len(attributes.stock_id)>',#attributes.stock_id#,'<cfelse>NULL</cfif>,
                    #now()#,
                    <cfif listfindnocase(employee_url,'#cgi.http_host#',';')>
                        #session.ep.userid#,
                    <cfelseif listfindnocase(partner_url,'#cgi.http_host#',';')>
                        #session.pp.userid# ,
                    </cfif>
                    '#cgi.remote_addr#',
                    NULL,
                    1,
                    <cfif isdefined('attributes.video_link') and len(attributes.video_link)>1<cfelse>0</cfif>,
                    '#attributes.DETAIL#'
                )
        </cfquery>
        <script type="text/javascript">
            <cfif not isdefined("attributes.draggable")>
                location.href = document.referrer;
                window.close();
            <cfelse>
                closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>','unique_imgs_get');
            </cfif>
        </script>
        <cfabort>
    <cfelse>
        <cftry>
            <cfset file_name = createUUID()>
            <cffile action="UPLOAD" 
                    destination="#upload_folder#product#dir_seperator#" 
                    filefield="image_file"  
                    nameconflict="MAKEUNIQUE"> <!--- <!---accept="image/*"---> --->
                
            <cffile action="rename" source="#upload_folder#product#dir_seperator##cffile.serverfile#" destination="#upload_folder#product#dir_seperator##file_name#.#cffile.serverfileext#">
            <cfcatch type="any">
                <script type="text/javascript">
                    alert("Lütfen imaj dosyası giriniz!");
                    <cfif not isdefined("attributes.draggable")>
                        history.back();
                    <cfelse>
                        closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );
                    </cfif>
                </script>
                <cfabort>
            </cfcatch>
        </cftry>
        <cfset assetTypeName = listlast(cffile.serverfile,'.')>
        <cfset blackList = 'php,php2,php3,php4,php5,phtml,pwml,inc,asp,aspx,ascx,jsp,cfm,cfml,cfc,pl,bat,exe,com,dll,vbs,reg,cgi,htaccess,asis'>
        <cfif listfind(blackList,assetTypeName,',')>
            <cffile action="delete" file="#upload_folder#product#dir_seperator##file_name#.#cffile.serverfileext#">
            <script type="text/javascript">
                alert("\'php\',\'jsp\',\'asp\',\'cfm\',\'cfml\' Formatlarında Dosya Girmeyiniz!!");
                history.back();
            </script>
            <cfabort>
        </cfif>
        <cfset  session.imFile = #file_name#&"."&#cffile.serverfileext#>
    
        <cfif (findnocase("gif","#CFFILE.SERVERFILE#",1) neq 0) and isDefined("rd")>
            <cfscript>
                CFFILE.SERVERFILE = listgetat(CFFILE.SERVERFILE,1,".")&"."&"jpg";
                cffile.serverfileext = "jpg";
            </cfscript>
        </cfif>
        <cfset size = cffile.fileSize / 1024>
        
        <cfquery name="ADD_IMAGE" datasource="#DSN1#">
            INSERT INTO 
                #table#
                (
                    IS_INTERNET,
                    #identity_column#,
                    PATH,
                    PATH_SERVER_ID,
                    PRD_IMG_NAME,
                    IMAGE_SIZE,
                    <cfif attributes.image_type eq "product">
                        STOCK_ID,
                    </cfif>
                    LANGUAGE_ID,
                    UPDATE_DATE,
                    UPDATE_EMP,
                    UPDATE_IP,
                    IS_EXTERNAL_LINK,
                    VIDEO_LINK,
                    DETAIL
                )
                VALUES
                (
                    <cfif isdefined("attributes.is_internet")>1,<cfelse>0,</cfif>
                    #attributes.image_action_id#,
                    '#file_name#.#cffile.serverfileext#',
                    '#fusebox.server_machine#',
                    #sql_unicode()#'#attributes.image_name#', 
                    <cfif isdefined("attributes.size") and len(attributes.size)>#attributes.size#,<cfelse>NULL,</cfif>
                    <cfif attributes.image_type eq "product">
                        <cfif isdefined("attributes.stock_id") and len(attributes.stock_id)>',#attributes.stock_id#,'<cfelse>NULL</cfif>,
                    </cfif>
                    '#attributes.language_id#',
                    #NOW()#,
                    <cfif listfindnocase(employee_url,'#cgi.http_host#',';')>
                    #session.ep.userid#,
                    <cfelseif listfindnocase(partner_url,'#cgi.http_host#',';')>
                    #session.pp.userid# ,
                    </cfif>
                    '#cgi.REMOTE_ADDR#',
                    0,
                    0,
                    '#attributes.DETAIL#'
                )
        </cfquery>
        <cfset session.resim = 4>
        <cfif not isDefined("rd")>
            <script type="text/javascript">
                <cfif not isdefined("attributes.draggable")>
                location.href = document.referrer;
                window.close();
            <cfelse>
                closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>','unique_imgs_get');
            </cfif>
            </script>
            <cfabort>
        </cfif>
    </cfif>
    <cfif isDefined("rd")>
        <cfinclude template="../display/rd.cfm">
    </cfif>
<cfelseif attributes.type eq "content">
    <cfif Not directoryExists('#upload_folder#content')>
        <cfset directoryCreate('#upload_folder#content') />
    </cfif>
    <!--- bu sayfada unicodelar icin sql_unicode fonksiyonu kullanildi --->
    <style type="text/css">
        .not_upload {
            background:url(test/osman/design/image/warning.png) no-repeat;
            height:40px;
            padding:5px 40px;
            color:#F00;
            margin:0 auto;
            width:200px;
        }
    </style><!--- accept="image/x-png, image/gif, image/jpeg"--->

    <cfif isDefined("attributes.image_file")  and len(attributes.image_file) and isDefined("attributes.image_url_link")  and len(attributes.image_url_link)>
        <cftry>
            <cfset file_name = createUUID()> 
            <cffile action="upload" nameconflict="makeunique" filefield="image_file" destination="#upload_folder#content" accept="image/jpeg, image/png, image/bmp, image/gif, image/jpg, image/x-png, image/*">
                            
            <cfset  session.imFile = '#file_name#.#cffile.serverfileext#'>		
            <cffile action="rename" source="#upload_folder#content/#cffile.serverfile#" destination="#upload_folder#content/#file_name#.#cffile.serverfileext#">
            <cfif ((cffile.serverfileext eq 'gif') or (cffile.serverfileext eq 'gif')) and isDefined("attributes.rd")>
                <cfset cffile.serverfileext = 'jpg'>
            </cfif>
            <cfcatch>
                <div class="not_upload">
                    <cf_get_lang dictionary_id='57455.Dosyanız Upload Edilemedi ! Dosyanızı Kontrol Ediniz'>
                </div>
                <cfabort>
            </cfcatch>
        </cftry> 
        <cfquery name="ADD_IMAGE" datasource="#DSN#">
            INSERT INTO 
                CONTENT_IMAGE 
                (
                    IMAGE_SIZE,
                    CONTENT_ID,
                    CNT_IMG_NAME,
                    CONTIMAGE_SMALL,
                    IMAGE_SERVER_ID,
                    DETAIL,
                    ASSET_FILE_SIZE,
                    UPDATE_DATE,
                    UPDATE_EMP,
                    UPDATE_IP,
                    IS_EXTERNAL_LINK,
                    VIDEO_LINK,
                    PATH,
                    LANGUAGE_ID,
                    RECORD_DATE
                )
                VALUES 
                (
                    <cfif isdefined("attributes.size") and len(attributes.size)>#attributes.size#<cfelse>NULL</cfif>,
                    #attributes.process_id#,	
                    #sql_unicode()#'#attributes.image_name#', 						
                    '#file_name#.#cffile.serverfileext#',
                    #fusebox.server_machine#,
                    #sql_unicode()#'#attributes.detail#',
                    #ROUND(CFFILE.FILESIZE/1024)#,
                    #now()#,
                    #session.ep.userid#,
                    '#CGI.REMOTE_ADDR#',
                    1,
                    <cfif isdefined('attributes.video_link') and len(attributes.video_link)>1<cfelse>0</cfif>,
                    '#attributes.image_url_link#',
                    '#attributes.language_id#',
                    #now()#,
                )
        </cfquery>
    <cfelseif isDefined("attributes.image_url_link")  and len(attributes.image_url_link)>
        <cfquery name="ADD_IMAGE" datasource="#DSN#">
            INSERT INTO 
                CONTENT_IMAGE 
                (
                    IMAGE_SIZE,
                    CONTENT_ID,
                    CNT_IMG_NAME,
                    IMAGE_SERVER_ID,
                    DETAIL,
                    ASSET_FILE_SIZE,
                    UPDATE_DATE,
                    UPDATE_EMP,
                    UPDATE_IP,
                    IS_EXTERNAL_LINK,
                    VIDEO_LINK,
                    PATH,
                    LANGUAGE_ID,
                    RECORD_DATE
                )
                VALUES 
                (
                    <cfif isdefined("attributes.size") and len(attributes.size)>#attributes.size#<cfelse>NULL</cfif>,
                    #attributes.process_id#,	
                    #sql_unicode()#'#attributes.image_name#', 						
                    #fusebox.server_machine#,
                    #sql_unicode()#'#attributes.detail#',
                    NULL,
                    #now()#,
                    #session.ep.userid#,
                    '#CGI.REMOTE_ADDR#',
                    1,
                    <cfif isdefined('attributes.video_link') and len(attributes.video_link)>1<cfelse>0</cfif>,
                    '#attributes.image_url_link#',
                    '#attributes.language_id#',
                    #now()#
                )
        </cfquery>
    <cfelse>
        <cftry>
            <cfset file_name = createUUID()> 
            <cffile action="upload" nameconflict="makeunique" filefield="image_file" destination="#upload_folder#content" accept="image/jpeg, image/png, image/bmp, image/gif, image/jpg, image/x-png, image/*">
                            
            <cfset  session.imFile = '#file_name#.#cffile.serverfileext#'>		
            <cffile action="rename" source="#upload_folder#content/#cffile.serverfile#" destination="#upload_folder#content/#file_name#.#cffile.serverfileext#">
            <cfif ((cffile.serverfileext eq 'gif') or (cffile.serverfileext eq 'gif')) and isDefined("attributes.rd")>
                <cfset cffile.serverfileext = 'jpg'>
            </cfif>
            <cfcatch>
                <div class="not_upload">
                    <cf_get_lang dictionary_id='57455.Dosyanız Upload Edilemedi ! Dosyanızı Kontrol Ediniz'>
                </div>
                <cfabort>
            </cfcatch>
        </cftry> 
        <cfquery name="ADD_IMAGE" datasource="#DSN#">
            INSERT INTO 
                CONTENT_IMAGE 
                (
                    IMAGE_SIZE,
                    CONTENT_ID,
                    CNT_IMG_NAME,
                    CONTIMAGE_SMALL,
                    IMAGE_SERVER_ID,
                    DETAIL,
                    ASSET_FILE_SIZE,
                    UPDATE_DATE,
                    UPDATE_EMP,
                    UPDATE_IP,
                    IS_EXTERNAL_LINK,
                    VIDEO_LINK,
                    LANGUAGE_ID,
                    RECORD_DATE
                )
                VALUES 
                (
                    <cfif isDefined("attributes.size") and len(attributes.size)>#attributes.size#<cfelse>NULL</cfif>,
                    #attributes.process_id#,	
                    #sql_unicode()#'#attributes.image_name#', 						
                    '#file_name#.#cffile.serverfileext#',
                    #fusebox.server_machine#,
                    #sql_unicode()#'#attributes.detail#',
                    #ROUND(CFFILE.FILESIZE/1024)#,
                    #now()#,
                    #session.ep.userid#,
                    '#CGI.REMOTE_ADDR#',
                    0,
                    0,			
                    '#attributes.language_id#',
                    #now()#
                )
        </cfquery>
    </cfif>

    <cfif isDefined("rd")>
        <cfinclude template="../display/rd.cfm">
    <cfelse>	
        <script type="text/javascript">
            <cfif not isdefined("attributes.draggable")>
                location.href = document.referrer;
                window.close();
            <cfelse>
                closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>','unique_imgs_get');
            </cfif>
        </script>
    </cfif>
<cfelseif attributes.type eq "training">
    <cfif Not directoryExists('#upload_folder#training')>
        <cfset directoryCreate('#upload_folder#training') />
    </cfif>
    <cfif isDefined("attributes.image_file")  and len(attributes.image_file) and isDefined("attributes.image_url_link")  and len(attributes.image_url_link)>
        <cftry>
            <cfset file_name = createUUID()> 
            <cffile action="upload" nameconflict="makeunique" filefield="image_file" destination="#upload_folder#training" accept="image/jpeg, image/png, image/bmp, image/gif, image/jpg, image/x-png, image/*">
                            
            <cfset  session.imFile = '#file_name#.#cffile.serverfileext#'>		
            <cffile action="rename" source="#upload_folder#training/#cffile.serverfile#" destination="#upload_folder#training/#file_name#.#cffile.serverfileext#">
            <cfif ((cffile.serverfileext eq 'gif') or (cffile.serverfileext eq 'gif')) and isDefined("attributes.rd")>
                <cfset cffile.serverfileext = 'jpg'>
            </cfif>
            <cfcatch>
                <div class="not_upload">
                    <cf_get_lang dictionary_id='57455.Dosyanız Upload Edilemedi ! Dosyanızı Kontrol Ediniz'>
                </div>
                <cfabort>
            </cfcatch>
        </cftry> 
        <cfquery name="ADD_IMAGE" datasource="#DSN#">
            UPDATE
				TRAINING_CLASS 
            SET
				IMAGE_SIZE = <cfif len(attributes.size)>#attributes.size#<cfelse>NULL</cfif>,
				TRN_IMG_NAME = <cfif len(attributes.image_name)>'#attributes.image_name#'<cfelse>NULL</cfif>,
				PATH = '#file_name#.#cffile.serverfileext#',
				TRN_IMG_DETAIL = <cfif len(attributes.detail)>#sql_unicode()#'#attributes.detail#'<cfelse>NULL</cfif>,				
				IS_EXTERNAL_LINK =  1,
				VIDEO_LINK = <cfif isdefined('attributes.video_link') and len(attributes.video_link)>1<cfelse>0</cfif>,
				VIDEO_PATH = <cfif len(attributes.image_url_link)>'#attributes.image_url_link#'<cfelse>NULL</cfif>,
				LANGUAGE = '#session.ep.language#'
			WHERE 
				CLASS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.class_id#">
        </cfquery>
        <cfelseif isDefined("attributes.image_url_link")  and len(attributes.image_url_link)>
            <cfquery name="ADD_IMAGE" datasource="#DSN#">
                UPDATE
                    TRAINING_CLASS 
                SET
                    IMAGE_SIZE =  <cfif len(attributes.size)>#attributes.size#<cfelse>NULL</cfif>,
                    PATH = NULL,
                    TRN_IMG_NAME = <cfif len(attributes.image_name)>'#attributes.image_name#'<cfelse>NULL</cfif>,
                    TRN_IMG_DETAIL = <cfif len(attributes.detail)>#sql_unicode()#'#attributes.detail#'<cfelse>NULL</cfif>,               
                    IS_EXTERNAL_LINK = 1,
                    VIDEO_LINK = <cfif isdefined('attributes.video_link') and len(attributes.video_link)>1<cfelse>0</cfif>,
                    VIDEO_PATH = <cfif len(attributes.image_url_link)>'#attributes.image_url_link#'<cfelse>NULL</cfif>,
                    LANGUAGE = '#session.ep.language#'
                WHERE 
                    CLASS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.class_id#">
            </cfquery>
        <cfelse>
            <cftry>
                <cfset file_name = createUUID()> 
                <cffile action="upload" nameconflict="makeunique" filefield="image_file" destination="#upload_folder#training" accept="image/jpeg, image/png, image/bmp, image/gif, image/jpg, image/x-png, image/*">
                                
                <cfset  session.imFile = '#file_name#.#cffile.serverfileext#'>		
                <cffile action="rename" source="#upload_folder#training/#cffile.serverfile#" destination="#upload_folder#training/#file_name#.#cffile.serverfileext#">
                <cfif ((cffile.serverfileext eq 'gif') or (cffile.serverfileext eq 'gif')) and isDefined("attributes.rd")>
                    <cfset cffile.serverfileext = 'jpg'>
                </cfif>
                <cfcatch>
                    <div class="not_upload">
                        <cf_get_lang dictionary_id='57455.Dosyanız Upload Edilemedi ! Dosyanızı Kontrol Ediniz'>
                    </div>
                    <cfabort>
                </cfcatch>
            </cftry>
            
            <cfquery name="ADD_IMAGE" datasource="#DSN#">
                UPDATE
                    TRAINING_CLASS 
                SET
                    IMAGE_SIZE = <cfif len(attributes.size)>#attributes.size#<cfelse>NULL</cfif>,  
                    TRN_IMG_DETAIL = <cfif len(attributes.detail)>#sql_unicode()#'#attributes.detail#'<cfelse>NULL</cfif>,
                    TRN_IMG_NAME = <cfif len(attributes.image_name)>'#attributes.image_name#'<cfelse>NULL</cfif>,
                    PATH = '#file_name#.#cffile.serverfileext#',                  
                    IS_EXTERNAL_LINK = 0,
                    <cfif len(attributes.image_url_link)>
                        VIDEO_PATH = '#attributes.image_url_link#',
                    <cfelse>
                        VIDEO_PATH = NULL,
                    </cfif>
                    VIDEO_LINK = 0,	
                    LANGUAGE = '#session.ep.language#'
                WHERE 
                    CLASS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.class_id#">
            </cfquery>
        
    </cfif>
    <cfif isDefined("rd")>
        <cfinclude template="../display/rd.cfm">
    <cfelse>	
        <script type="text/javascript">
            <cfif not isdefined("attributes.draggable")>
                location.href = document.referrer;
                window.close();
            <cfelse>
                closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>','unique_imgs_get');
            </cfif>
        </script>
    </cfif>

<cfelseif attributes.type eq "train_subject">
    <cfif Not directoryExists('#upload_folder#train_subject')>
        <cfset directoryCreate('#upload_folder#train_subject') />
    </cfif>
    <cfif isDefined("attributes.image_file")  and len(attributes.image_file) and isDefined("attributes.image_url_link")  and len(attributes.image_url_link)>
        <cftry>
            <cfset file_name = createUUID()> 
            <cffile action="upload" nameconflict="makeunique" filefield="image_file" destination="#upload_folder#train_subject" accept="image/jpeg, image/png, image/bmp, image/gif, image/jpg, image/x-png, image/*">
                            
            <cfset  session.imFile = '#file_name#.#cffile.serverfileext#'>		
            <cffile action="rename" source="#upload_folder#train_subject/#cffile.serverfile#" destination="#upload_folder#train_subject/#file_name#.#cffile.serverfileext#">
            <cfif ((cffile.serverfileext eq 'gif') or (cffile.serverfileext eq 'gif')) and isDefined("attributes.rd")>
                <cfset cffile.serverfileext = 'jpg'>
            </cfif>
            <cfcatch>
                <div class="not_upload">
                    <cf_get_lang dictionary_id='57455.Dosyanız Upload Edilemedi ! Dosyanızı Kontrol Ediniz'>
                </div>
                <cfabort>
            </cfcatch>
        </cftry> 
        <cfquery name="ADD_IMAGE" datasource="#DSN#">
            UPDATE
				TRAINING 
            SET
				IMAGE_SIZE = <cfif len(attributes.size)>#attributes.size#<cfelse>NULL</cfif>,
				TRN_IMG_NAME = <cfif len(attributes.image_name)>'#attributes.image_name#'<cfelse>NULL</cfif>,
				PATH = '#file_name#.#cffile.serverfileext#',
				TRN_IMG_DETAIL = <cfif len(attributes.detail)>#sql_unicode()#'#attributes.detail#'<cfelse>NULL</cfif>,				
				IS_EXTERNAL_LINK =  1,
				VIDEO_LINK = <cfif isdefined('attributes.video_link') and len(attributes.video_link)>1<cfelse>0</cfif>,
				VIDEO_PATH = <cfif len(attributes.image_url_link)>'#attributes.image_url_link#'<cfelse>NULL</cfif>,
				LANGUAGE = '#session.ep.language#'
			WHERE 
				TRAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.train_id#">
        </cfquery>
        <cfelseif isDefined("attributes.image_url_link")  and len(attributes.image_url_link)>
            <cfquery name="ADD_IMAGE" datasource="#DSN#">
                UPDATE
                    TRAINING 
                SET
                    IMAGE_SIZE =  <cfif len(attributes.size)>#attributes.size#<cfelse>NULL</cfif>,
                    PATH = NULL,
                    TRN_IMG_NAME = <cfif len(attributes.image_name)>'#attributes.image_name#'<cfelse>NULL</cfif>,
                    TRN_IMG_DETAIL = <cfif len(attributes.detail)>#sql_unicode()#'#attributes.detail#'<cfelse>NULL</cfif>,               
                    IS_EXTERNAL_LINK = 1,
                    VIDEO_LINK = <cfif isdefined('attributes.video_link') and len(attributes.video_link)>1<cfelse>0</cfif>,
                    VIDEO_PATH = <cfif len(attributes.image_url_link)>'#attributes.image_url_link#'<cfelse>NULL</cfif>,
                    LANGUAGE = '#session.ep.language#'
                WHERE 
                    TRAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.train_id#">
            </cfquery>
        <cfelse>
            <cftry>
                <cfset file_name = createUUID()> 
                <cffile action="upload" nameconflict="makeunique" filefield="image_file" destination="#upload_folder#train_subject" accept="image/jpeg, image/png, image/bmp, image/gif, image/jpg, image/x-png, image/*">
                                
                <cfset  session.imFile = '#file_name#.#cffile.serverfileext#'>		
                <cffile action="rename" source="#upload_folder#train_subject/#cffile.serverfile#" destination="#upload_folder#train_subject/#file_name#.#cffile.serverfileext#">
                <cfif ((cffile.serverfileext eq 'gif') or (cffile.serverfileext eq 'gif')) and isDefined("attributes.rd")>
                    <cfset cffile.serverfileext = 'jpg'>
                </cfif>
                <cfcatch>
                    <div class="not_upload">
                        <cf_get_lang dictionary_id='57455.Dosyanız Upload Edilemedi ! Dosyanızı Kontrol Ediniz'>
                    </div>
                    <cfabort>
                </cfcatch>
            </cftry>
            
            <cfquery name="ADD_IMAGE" datasource="#DSN#">
                UPDATE
                    TRAINING 
                SET
                    IMAGE_SIZE = <cfif len(attributes.size)>#attributes.size#<cfelse>NULL</cfif>,  
                    TRN_IMG_DETAIL = <cfif len(attributes.detail)>#sql_unicode()#'#attributes.detail#'<cfelse>NULL</cfif>,
                    TRN_IMG_NAME = <cfif len(attributes.image_name)>'#attributes.image_name#'<cfelse>NULL</cfif>,
                    PATH = '#file_name#.#cffile.serverfileext#',                  
                    IS_EXTERNAL_LINK = 0,
                    <cfif len(attributes.image_url_link)>
                        VIDEO_PATH = '#attributes.image_url_link#',
                    <cfelse>
                        VIDEO_PATH = NULL,
                    </cfif>
                    VIDEO_LINK = 0,	
                    LANGUAGE = '#session.ep.language#'
                WHERE 
                    TRAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.train_id#">
            </cfquery>
        
    </cfif>
    <cfif isDefined("rd")>
        <cfinclude template="../display/rd.cfm">
    <cfelse>	
        <script type="text/javascript">
            <cfif not isdefined("attributes.draggable")>
                location.href = document.referrer;
                window.close();
            <cfelse>
                closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>','unique_imgs_get');
            </cfif>
        </script>
    </cfif>

<cfelseif attributes.type eq "train_group">
    <cfif Not directoryExists('#upload_folder#train_group')>
        <cfset directoryCreate('#upload_folder#train_group') />
    </cfif>
    <cfif isDefined("attributes.image_file")  and len(attributes.image_file) and isDefined("attributes.image_url_link")  and len(attributes.image_url_link)>
        <cftry>
            <cfset file_name = createUUID()> 
            <cffile action="upload" nameconflict="makeunique" filefield="image_file" destination="#upload_folder#train_group" accept="image/jpeg, image/png, image/bmp, image/gif, image/jpg, image/x-png, image/*">
                            
            <cfset  session.imFile = '#file_name#.#cffile.serverfileext#'>		
            <cffile action="rename" source="#upload_folder#train_group/#cffile.serverfile#" destination="#upload_folder#train_group/#file_name#.#cffile.serverfileext#">
            <cfif ((cffile.serverfileext eq 'gif') or (cffile.serverfileext eq 'gif')) and isDefined("attributes.rd")>
                <cfset cffile.serverfileext = 'jpg'>
            </cfif>
            <cfcatch>
                <div class="not_upload">
                    <cf_get_lang dictionary_id='57455.Dosyanız Upload Edilemedi ! Dosyanızı Kontrol Ediniz'>
                </div>
                <cfabort>
            </cfcatch>
        </cftry> 
        <cfquery name="ADD_IMAGE" datasource="#DSN#">
            UPDATE
                TRAINING_CLASS_GROUPS 
            SET
				IMAGE_SIZE = <cfif len(attributes.size)>#attributes.size#<cfelse>NULL</cfif>,
				TRN_IMG_NAME = <cfif len(attributes.image_name)>'#attributes.image_name#'<cfelse>NULL</cfif>,
				PATH = '#file_name#.#cffile.serverfileext#',
				TRN_IMG_DETAIL = <cfif len(attributes.detail)>#sql_unicode()#'#attributes.detail#'<cfelse>NULL</cfif>,				
				IS_EXTERNAL_LINK =  1,
				VIDEO_LINK = <cfif isdefined('attributes.video_link') and len(attributes.video_link)>1<cfelse>0</cfif>,
				VIDEO_PATH = <cfif len(attributes.image_url_link)>'#attributes.image_url_link#'<cfelse>NULL</cfif>,
				LANGUAGE = '#session.ep.language#'
			WHERE 
                TRAIN_GROUP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.train_group_id#">
        </cfquery>
        <cfelseif isDefined("attributes.image_url_link")  and len(attributes.image_url_link)>
            <cfquery name="ADD_IMAGE" datasource="#DSN#">
                UPDATE
                    TRAINING_CLASS_GROUPS 
                SET
                    IMAGE_SIZE =  <cfif len(attributes.size)>#attributes.size#<cfelse>NULL</cfif>,
                    PATH = NULL,
                    TRN_IMG_NAME = <cfif len(attributes.image_name)>'#attributes.image_name#'<cfelse>NULL</cfif>,
                    TRN_IMG_DETAIL = <cfif len(attributes.detail)>#sql_unicode()#'#attributes.detail#'<cfelse>NULL</cfif>,                    
                    IS_EXTERNAL_LINK = 1,
                    VIDEO_LINK = <cfif isdefined('attributes.video_link') and len(attributes.video_link)>1<cfelse>0</cfif>,
                    VIDEO_PATH = <cfif len(attributes.image_url_link)>'#attributes.image_url_link#'<cfelse>NULL</cfif>,
                    LANGUAGE = '#session.ep.language#'
                WHERE 
                    TRAIN_GROUP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.train_group_id#">
            </cfquery>
        <cfelse>
            <cftry>
                <cfset file_name = createUUID()> 
                <cffile action="upload" nameconflict="makeunique" filefield="image_file" destination="#upload_folder#train_group" accept="image/jpeg, image/png, image/bmp, image/gif, image/jpg, image/x-png, image/*">
                                
                <cfset  session.imFile = '#file_name#.#cffile.serverfileext#'>		
                <cffile action="rename" source="#upload_folder#train_group/#cffile.serverfile#" destination="#upload_folder#train_group/#file_name#.#cffile.serverfileext#">
                <cfif ((cffile.serverfileext eq 'gif') or (cffile.serverfileext eq 'gif')) and isDefined("attributes.rd")>
                    <cfset cffile.serverfileext = 'jpg'>
                </cfif>
                <cfcatch>
                    <div class="not_upload">
                        <cf_get_lang dictionary_id='57455.Dosyanız Upload Edilemedi ! Dosyanızı Kontrol Ediniz'>
                    </div>
                    <cfabort>
                </cfcatch>
            </cftry>
            
            <cfquery name="ADD_IMAGE" datasource="#DSN#">
                UPDATE
                    TRAINING_CLASS_GROUPS 
                SET
                    IMAGE_SIZE = <cfif len(attributes.size)>#attributes.size#<cfelse>NULL</cfif>,  
                    TRN_IMG_DETAIL = <cfif len(attributes.detail)>#sql_unicode()#'#attributes.detail#'<cfelse>NULL</cfif>,
                    TRN_IMG_NAME = <cfif len(attributes.image_name)>'#attributes.image_name#'<cfelse>NULL</cfif>,
                    PATH = '#file_name#.#cffile.serverfileext#',                   
                    IS_EXTERNAL_LINK = 0,
                    <cfif len(attributes.image_url_link)>
                        VIDEO_PATH = '#attributes.image_url_link#',
                    <cfelse>
                        VIDEO_PATH = NULL,
                    </cfif>
                    VIDEO_LINK = 0,	
                    LANGUAGE = '#session.ep.language#'
                WHERE 
                    TRAIN_GROUP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.train_group_id#">
            </cfquery>
        
    </cfif>
    <cfif isDefined("rd")>
        <cfinclude template="../display/rd.cfm">
    <cfelse>	
        <script type="text/javascript">
            <cfif not isdefined("attributes.draggable")>
                location.href = document.referrer;
                window.close();
            <cfelse>
                closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>','unique_imgs_get');
            </cfif>
        </script>
    </cfif>
<cfelseif attributes.type eq "sample">
    <cfif Not directoryExists('#upload_folder#sample')>
        <cfset directoryCreate('#upload_folder#sample') />
    </cfif>
    <cfif isDefined("attributes.image_file")  and len(attributes.image_file) >
        <cftry>
            <cfset file_name = createUUID()> 
            <cffile action="upload" nameconflict="makeunique" filefield="image_file" destination="#upload_folder#sample" accept="image/jpeg, image/png, image/bmp, image/gif, image/jpg, image/x-png, image/*">
                            
            <cfset  session.imFile = '#file_name#.#cffile.serverfileext#'>		
            <cffile action="rename" source="#upload_folder#sample/#cffile.serverfile#" destination="#upload_folder#sample/#file_name#.#cffile.serverfileext#">
            <cfif ((cffile.serverfileext eq 'gif') or (cffile.serverfileext eq 'gif')) and isDefined("attributes.rd")>
                <cfset cffile.serverfileext = 'jpg'>
            </cfif>
            <cfcatch>
                <div class="not_upload">
                    <cf_get_lang dictionary_id='57455.Dosyanız Upload Edilemedi ! Dosyanızı Kontrol Ediniz'>
                </div>
                <cfabort>
            </cfcatch>
        </cftry> 
        <cfquery name="ADD_IMAGE" datasource="#DSN3#">
            INSERT INTO 
            PRODUCT_SAMPLE_IMAGE 
                (
                 PRODUCT_SAMPLE_ID
                , PRODUCT_SAMPLE_FILE_NAME 
                , IS_EXTERNAL_LINK 
                , PRODUCT_SAMPLE_IMG_NAME 
                ,IMAGE_SERVER_ID
                , PRODUCT_SAMPLE_IMG_DETAIL  
                , IMAGE_SIZE 
                , VIDEO_PATH 
                , VIDEO_LINK 
                , LANGUAGE_ID 
                , UPDATE_DATE
                , UPDATE_EMP
                , UPDATE_IP
                )
                VALUES 
                (
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_sample_id#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#file_name#.#cffile.serverfileext#">,
                    1,
                    <cfif len(attributes.image_name)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.image_name#"><cfelse>NULL</cfif>,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#fusebox.server_machine#">,	
                    #sql_unicode()#'#attributes.detail#',
                    <cfif isdefined("attributes.size") and len(attributes.size)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.size#"><cfelse>NULL</cfif>,
                    <cfif isDefined("attributes.image_url_link")  and len(attributes.image_url_link)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.image_url_link#"><cfelse>NULL</cfif>, 
                    <cfif isdefined('attributes.video_link') and len(attributes.video_link)>1<cfelse>0</cfif>,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.language_id#">,
                    <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
                )
        </cfquery>
    <cfelseif isDefined("attributes.image_url_link")  and len(attributes.image_url_link)>
        <cfquery name="ADD_IMAGE" datasource="#DSN3#">
            INSERT INTO 
            PRODUCT_SAMPLE_IMAGE 
                (
                PRODUCT_SAMPLE_ID 
                , PRODUCT_SAMPLE_FILE_NAME 
                , IS_EXTERNAL_LINK 
                , PRODUCT_SAMPLE_IMG_NAME 
                , IMAGE_SERVER_ID
                , PRODUCT_SAMPLE_IMG_DETAIL  
                , IMAGE_SIZE 
                , VIDEO_PATH 
                , VIDEO_LINK 
                , LANGUAGE_ID 
                , UPDATE_DATE
                , UPDATE_EMP
                , UPDATE_IP
                )
                VALUES 
                (
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_sample_id#">,
                    <cfif isdefined ("attributes.image_file") and len(attributes.image_file)><cfqueryparam cfsqltype="cf_sql_varchar" value="#file_name#.#cffile.serverfileext#"><cfelse>NULL</cfif>,
                    1,
                    <cfif len(attributes.image_name)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.image_name#"><cfelse>NULL</cfif>,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#fusebox.server_machine#">,	
                    <cfif len(attributes.detail)>#sql_unicode()#'#attributes.detail#'<cfelse>NULL</cfif>,
                    <cfif isdefined("attributes.size") and len(attributes.size)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.size#"><cfelse>NULL</cfif>,
                    <cfif isDefined("attributes.image_url_link")  and len(attributes.image_url_link)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.image_url_link#"><cfelse>NULL</cfif>, 
                    <cfif isdefined('attributes.video_link') and len(attributes.video_link)>1<cfelse>0</cfif>,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.language_id#">,
                    <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
                )
        </cfquery>
    <cfelse>
        <cfquery name="ADD_IMAGE" datasource="#DSN3#">
            INSERT INTO 
            PRODUCT_SAMPLE_IMAGE 
                (
                PRODUCT_SAMPLE_ID 
                , PRODUCT_SAMPLE_FILE_NAME 
                , IS_EXTERNAL_LINK 
                , PRODUCT_SAMPLE_IMG_NAME
                ,IMAGE_SERVER_ID 
                , PRODUCT_SAMPLE_IMG_DETAIL  
                , IMAGE_SIZE 
                , VIDEO_PATH 
                , VIDEO_LINK 
                , LANGUAGE_ID 
                , UPDATE_DATE
                , UPDATE_EMP
                , UPDATE_IP
                )
                VALUES 
                (
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_sample_id#">,
                    <cfif isdefined ("attributes.image_file") and len(attributes.image_file)><cfqueryparam cfsqltype="cf_sql_varchar" value="#file_name#.#cffile.serverfileext#"><cfelse>NULL</cfif>,
                    0,
                    #sql_unicode()#'#attributes.image_name#', 
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#fusebox.server_machine#">,	
                    <cfif len(attributes.detail)>#sql_unicode()#'#attributes.detail#'<cfelse>NULL</cfif>,
                    <cfif isdefined("attributes.size") and len(attributes.size)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.size#"><cfelse>NULL</cfif>,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.image_url_link#">, 
                    <cfif isdefined('attributes.video_link') and len(attributes.video_link)>1<cfelse>0</cfif>,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.language_id#">,
                    <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
                )
        </cfquery>
    </cfif>

    <cfif isDefined("rd")>
        <cfinclude template="../display/rd.cfm">
    <cfelse>	
        <script type="text/javascript">
            <cfif not isdefined("attributes.draggable")>
                location.href = document.referrer;
                window.close();
            <cfelse>
                closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>','unique_imgs_get');
            </cfif>
        </script>
    </cfif>
</cfif>