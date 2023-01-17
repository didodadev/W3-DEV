

<cfif attributes.image_type eq "product">
	<cfif attributes.image_type eq "brand"><!--- Ürün kategorilerinden Eklenmişse --->
		<cfset table = "PRODUCT_BRANDS_IMAGES">
		<cfset identity_column = "BRAND_IMAGEID">
	<cfelseif attributes.image_type eq "product"><!--- Ürün den eklenmişse --->
		<cfset table = "PRODUCT_IMAGES">
		<cfset identity_column = "PRODUCT_IMAGEID">
	</cfif>
    <cfquery name="upd_language" datasource="#dsn#">
        UPDATE 
            SETUP_LANGUAGE_INFO 
        SET 
            ITEM = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.detail#">
        WHERE 
            UNIQUE_COLUMN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.image_action_id#"> AND
            COLUMN_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="DETAIL"> AND
            TABLE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#table#"> AND
            LANGUAGE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.language#">
    </cfquery>
	<cfif isDefined("attributes.image_file")  and len(attributes.image_file) and isDefined("attributes.image_url_link")  and len(attributes.image_url_link)>
		<cfset file_name = createUUID()>
		<cfif isDefined("attributes.image_file") and len(attributes.image_file)>
			<cffile action="UPLOAD" 
				destination="#upload_folder#product#dir_seperator#" 
				filefield="image_file"  
				nameconflict="MAKEUNIQUE" accept="image/*">
				
			<cffile action="rename" source="#upload_folder#product#dir_seperator##cffile.serverfile#" destination="#upload_folder#product#dir_seperator##file_name#.#cffile.serverfileext#">
			<cfset assetTypeName = listlast(cffile.serverfile,'.')>
			<cfset blackList = 'php,php2,php3,php4,php5,phtml,pwml,inc,asp,aspx,ascx,jsp,cfm,cfml,cfc,pl,bat,exe,com,dll,vbs,reg,cgi,htaccess,asis'>
			<cfif listfind(blackList,assetTypeName,',')>
				
				<script type="text/javascript">
					alert("\'php\',\'jsp\',\'asp\',\'cfm\',\'cfml\' Formatlarında Dosya Girmeyiniz!!");
					history.back();
				</script>
				<cfabort>
			</cfif>
		</cfif>
		<cfquery name="UPD_UNIT" datasource="#DSN1#">
			UPDATE 
				#table# 
			SET 
				PATH_SERVER_ID = '#fusebox.server_machine#',
				PATH = '#file_name#.#cffile.serverfileext#',
				PRD_IMG_NAME = '#attributes.IMAGE_NAME#',
				<cfif not isDefined("attributes.image_file") and not len(attributes.image_file)> PATH_SERVER_ID = NULL,</cfif>
				VIDEO_PATH = '#attributes.image_url_link#',
				IS_INTERNET = <cfif isdefined("attributes.is_internet")>1<cfelse>0</cfif>,
				DETAIL = '#attributes.detail#',
				IMAGE_SIZE = <cfif isdefined("attributes.size") and len(attributes.size)>#attributes.size#<cfelse>NULL</cfif>,
				<cfif attributes.image_type eq "product">
					STOCK_ID = <cfif isdefined("attributes.stock_id")>',#attributes.stock_id#,'<cfelse>NULL</cfif>,
				</cfif>
				LANGUAGE_ID = '#attributes.language_id#',
				UPDATE_DATE = #NOW()#,
				UPDATE_EMP = #SESSION.EP.USERID#,
				UPDATE_IP = '#CGI.REMOTE_ADDR#',
				IS_EXTERNAL_LINK = 1,
				VIDEO_LINK =   <cfif isdefined('attributes.video_link') and len(attributes.video_link)>1<cfelse>0</cfif>
			WHERE 
				#identity_column# = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.image_action_id#">
		</cfquery>
		<script type="text/javascript">
            <cfif not isDefined("attributes.draggable")>
                location.href = document.referrer;
                window.close();
            <cfelse>
                closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>','unique_imgs_get');
            </cfif>
		</script>
	<cfelseif isDefined("attributes.image_url_link")  and len(attributes.image_url_link)>
		<cfquery name="UPD_UNIT" datasource="#DSN1#">
			UPDATE 
					#table# 
				SET 
					PATH = NULL,
					PRD_IMG_NAME = '#attributes.IMAGE_NAME#',
					PATH_SERVER_ID = <cfif isDefined("attributes.image_file") and len(attributes.image_file)>'#fusebox.server_machine#'<cfelse>NULL</cfif>,
					VIDEO_PATH = '#attributes.image_url_link#',
					IS_INTERNET = <cfif isdefined("attributes.is_internet")>1<cfelse>0</cfif>,
					DETAIL = '#attributes.detail#',
					IMAGE_SIZE = <cfif isdefined("attributes.size") and len(attributes.size)>#attributes.size#<cfelse>NULL</cfif>,
					<cfif attributes.image_type eq "product">
						STOCK_ID = <cfif isdefined("attributes.stock_id")>',#attributes.stock_id#,'<cfelse>NULL</cfif>,
					</cfif>
					LANGUAGE_ID = '#attributes.language_id#',
					UPDATE_DATE = #NOW()#,
					UPDATE_EMP = #SESSION.EP.USERID#,
					UPDATE_IP = '#CGI.REMOTE_ADDR#',
					IS_EXTERNAL_LINK = 1,
					VIDEO_LINK =   <cfif isdefined('attributes.video_link') and len(attributes.video_link)>1<cfelse>0</cfif>
				WHERE 
					#identity_column# = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.image_action_id#">
			</cfquery>
			<script type="text/javascript">
                <cfif not isDefined("attributes.draggable")>
                    location.href = document.referrer;
                    window.close();
                <cfelse>
                    closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>','unique_imgs_get');
                </cfif>
            </script>
	<cfelse>
		<cfset file_name = createUUID()>
		<cfif isDefined("attributes.image_file") and len(attributes.image_file)>
			<cffile action="UPLOAD" 
				destination="#upload_folder#product#dir_seperator#" 
				filefield="image_file"  
				nameconflict="MAKEUNIQUE" accept="image/*">
				
			<cffile action="rename" source="#upload_folder#product#dir_seperator##cffile.serverfile#" destination="#upload_folder#product#dir_seperator##file_name#.#cffile.serverfileext#">
			<cfset assetTypeName = listlast(cffile.serverfile,'.')>
			<cfset blackList = 'php,php2,php3,php4,php5,phtml,pwml,inc,asp,aspx,ascx,jsp,cfm,cfml,cfc,pl,bat,exe,com,dll,vbs,reg,cgi,htaccess,asis'>
			<cfif listfind(blackList,assetTypeName,',')>
				<script type="text/javascript">
					alert("\'php\',\'jsp\',\'asp\',\'cfm\',\'cfml\' Formatlarında Dosya Girmeyiniz!!");
					history.back();
				</script>
				<cfabort>
			</cfif>
		</cfif>
		<cfquery name="UPD_UNIT" datasource="#DSN1#">
			UPDATE 
				#table# 
			SET 
				PRD_IMG_NAME = '#attributes.IMAGE_NAME#',
				<cfif isDefined("attributes.image_file") and len(attributes.image_file)>
					PATH_SERVER_ID = '#fusebox.server_machine#',
					PATH = '#file_name#.#cffile.serverfileext#',
				</cfif>
				<cfif len(attributes.image_url_link)>
					<cfif not isDefined("attributes.image_file") and not len(attributes.image_file)> PATH_SERVER_ID = NULL,</cfif>
					VIDEO_PATH = '#attributes.image_url_link#',
				<cfelse>
					VIDEO_PATH = NULL,
				</cfif>
				IS_INTERNET = <cfif isdefined("attributes.is_internet")>1<cfelse>0</cfif>,
				DETAIL = '#attributes.detail#',
				IMAGE_SIZE = <cfif isdefined("attributes.size") and len(attributes.size)>#attributes.size#<cfelse>NULL</cfif>,
				<cfif attributes.image_type eq "product">
					STOCK_ID = <cfif isdefined("attributes.stock_id")>',#attributes.stock_id#,'<cfelse>NULL</cfif>,
				</cfif>
				LANGUAGE_ID = '#attributes.language_id#',
				UPDATE_DATE = #NOW()#,
				UPDATE_EMP = #SESSION.EP.USERID#,
				UPDATE_IP = '#CGI.REMOTE_ADDR#',
				IS_EXTERNAL_LINK = 0,
				VIDEO_LINK =   <cfif isdefined('attributes.video_link') and len(attributes.video_link)>1<cfelse>0</cfif>
			WHERE 
				#identity_column# = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.image_action_id#">
		</cfquery>
		<script type="text/javascript">
            <cfif not isDefined("attributes.draggable")>
                location.href = document.referrer;
                window.close();
            <cfelse>
                closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>','unique_imgs_get');
            </cfif>
		</script>
	</cfif>
<cfelseif attributes.image_type eq 'content'>
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
            UPDATE
                CONTENT_IMAGE 
            SET
				IMAGE_SIZE = <cfif len(attributes.size)>#attributes.size#<cfelse>NULL</cfif>,
				CONTENT_ID = #attributes.process_id#,
                CNT_IMG_NAME = '#attributes.image_name#',
				CONTIMAGE_SMALL =  '#file_name#.#cffile.serverfileext#',
				IMAGE_SERVER_ID =  #fusebox.server_machine#,
				DETAIL =   #sql_unicode()#'#attributes.detail#',
				ASSET_FILE_SIZE = NULL,
				UPDATE_DATE =   #now()#,
				UPDATE_EMP =  #session.ep.userid#,
				UPDATE_IP = '#CGI.REMOTE_ADDR#',
				IS_EXTERNAL_LINK =  1,
				VIDEO_LINK = <cfif isdefined('attributes.video_link') and len(attributes.video_link)>1<cfelse>0</cfif>,
				PATH = '#attributes.image_url_link#',
				LANGUAGE_ID = '#attributes.language_id#',
                RECORD_DATE = #now()#
			WHERE 
				CONTIMAGE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.image_action_id#">
        </cfquery>
    <cfelseif isDefined("attributes.image_url_link")  and len(attributes.image_url_link)>
        <cftry>
            <cfset file_name = createUUID()> 
            <cffile action="upload" nameconflict="makeunique" filefield="image_file" destination="#upload_folder#content" accept="image/jpeg, image/png, image/bmp, image/gif, image/jpg, image/x-png, image/*">
                            <cfdump  var="#file_name#" abort>
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
            UPDATE
                CONTENT_IMAGE 
            SET
				IMAGE_SIZE =  <cfif len(attributes.size)>#attributes.size#<cfelse>NULL</cfif>,
				CONTENT_ID = #attributes.process_id#,
				CONTIMAGE_SMALL =  '#file_name#.#cffile.serverfileext#',
				CNT_IMG_NAME = '#attributes.image_name#',  	
				IMAGE_SERVER_ID = #fusebox.server_machine#,
				DETAIL = #sql_unicode()#'#attributes.detail#',
				ASSET_FILE_SIZE = NULL,
				UPDATE_DATE = #now()#,
				UPDATE_EMP = #session.ep.userid#,
				UPDATE_IP = '#CGI.REMOTE_ADDR#',
				IS_EXTERNAL_LINK = 1,
				VIDEO_LINK = <cfif isdefined('attributes.video_link') and len(attributes.video_link)>1<cfelse>0</cfif>,
				PATH = '#attributes.image_url_link#',
				LANGUAGE_ID = '#attributes.language_id#',
                RECORD_DATE = #now()#
			WHERE 
				CONTIMAGE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.image_action_id#">
        </cfquery>
    <cfelse>
	   <!--- resim varken tekrar upload etmesine gerek duyulmadıgından kaldırıldı --->
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
            UPDATE
                CONTENT_IMAGE 
            SET
				IMAGE_SIZE = <cfif len(attributes.size)>#attributes.size#<cfelse>NULL</cfif>,
				CONTENT_ID = #attributes.process_id#,
                CNT_IMG_NAME = '#attributes.image_name#', 
                CONTIMAGE_SMALL =  '#file_name#.#cffile.serverfileext#',
				IMAGE_SERVER_ID = #fusebox.server_machine#,
				DETAIL = #sql_unicode()#'#attributes.detail#',
                ASSET_FILE_SIZE = NULL,
				UPDATE_DATE = #now()#,
				UPDATE_EMP = #session.ep.userid#,
				UPDATE_IP = '#CGI.REMOTE_ADDR#',
				IS_EXTERNAL_LINK = 0,
				<cfif len(attributes.image_url_link)>
					PATH = '#attributes.image_url_link#',
				<cfelse>
					PATH = NULL,
				</cfif>
				VIDEO_LINK = 0,	
				LANGUAGE_ID = '#attributes.language_id#',
                RECORD_DATE = #now()#
			WHERE 
				CONTIMAGE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.image_action_id#">
        </cfquery>
    </cfif>

    <cfif isDefined("rd")>
        <cfinclude template="../display/rd.cfm">
    <cfelse>	
        <script type="text/javascript">
            <cfif not isDefined("attributes.draggable")>
                location.href = document.referrer;
                window.close();
            <cfelse>
                closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>','unique__content_related_images_');
            </cfif>
		</script>
    </cfif>

<cfelseif attributes.image_type eq 'training'>
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
            <cfif not isDefined("attributes.draggable")>
                location.href = document.referrer;
                window.close();
            <cfelse>
                closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>','unique_imgs_get');
            </cfif>
		</script>
    </cfif>

<cfelseif attributes.image_type eq 'train_subject'>
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
                    CLASS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.train_id#">
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
            <cfif not isDefined("attributes.draggable")>
                location.href = document.referrer;
                window.close();
            <cfelse>
                closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>','unique_imgs_get');
            </cfif>
		</script>
    </cfif>

<cfelseif attributes.image_type eq 'train_group'>
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
            <cfif not isDefined("attributes.draggable")>
                location.href = document.referrer;
                window.close();
            <cfelse>
                closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>','unique_imgs_get');
            </cfif>
		</script>
    </cfif>
<cfelseif attributes.image_type eq 'sample'>
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
        <cfquery name="ADD_SAMPLE_IMAGE" datasource="#DSN3#">
           UPDATE
            PRODUCT_SAMPLE_IMAGE 
            SET
                IMAGE_SIZE = <cfif isdefined("attributes.size") and len(attributes.size)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.size#"><cfelse>NULL</cfif>,
                PRODUCT_SAMPLE_IMG_NAME = <cfif len(attributes.image_name)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.image_name#"><cfelse>NULL</cfif>,
                PRODUCT_SAMPLE_FILE_NAME = <cfif len(attributes.image_file)>'#file_name#.#cffile.serverfileext#'<cfelse>'#attributes.old_image_file#'</cfif>,
                PRODUCT_SAMPLE_IMG_DETAIL = <cfif len(attributes.detail)>#sql_unicode()#'#attributes.detail#'<cfelse>NULL</cfif>,
                IMAGE_SERVER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#fusebox.server_machine#">,				
                IS_EXTERNAL_LINK =  1,
                VIDEO_LINK = <cfif isdefined('attributes.video_link') and len(attributes.video_link)>1<cfelse>0</cfif>,
                VIDEO_PATH = <cfif len(attributes.image_url_link)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.image_url_link#"><cfelse>NULL</cfif>,
                LANGUAGE_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.language_id#">
            WHERE 
            PRODUCT_SAMPLE_IMAGE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.image_action_id#">
        </cfquery>
    <cfelseif isDefined("attributes.image_url_link")  and len(attributes.image_url_link)>
        <cfquery name="ADD_SAMPLE_IMAGE" datasource="#DSN3#">
            UPDATE
                PRODUCT_SAMPLE_IMAGE 
            SET
                IMAGE_SIZE = <cfif isdefined("attributes.size") and len(attributes.size)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.size#"><cfelse>NULL</cfif>,
                PRODUCT_SAMPLE_IMG_NAME = <cfif len(attributes.image_name)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.image_name#"><cfelse>NULL</cfif>,
                PRODUCT_SAMPLE_FILE_NAME = <cfif len(attributes.image_file)>'#file_name#.#cffile.serverfileext#'<cfelseif len(attributes.old_image_file)>'#attributes.old_image_file#'<cfelse>NULL</cfif>,
                PRODUCT_SAMPLE_IMG_DETAIL = <cfif len(attributes.detail)>#sql_unicode()#'#attributes.detail#'<cfelse>NULL</cfif>,
                IMAGE_SERVER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#fusebox.server_machine#">,				
                IS_EXTERNAL_LINK =  1,
                VIDEO_LINK = <cfif isdefined('attributes.video_link') and len(attributes.video_link)>1<cfelse>0</cfif>,
                VIDEO_PATH = <cfif isDefined("attributes.image_url_link")  and len(attributes.image_url_link)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.image_url_link#"><cfelse>NULL</cfif>,
                LANGUAGE_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.language_id#">
            WHERE 
            PRODUCT_SAMPLE_IMAGE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.image_action_id#">
        </cfquery>
    <cfelse>
        <cfquery name="ADD_SAMPLE_IMAGE" datasource="#DSN3#">
            UPDATE
                PRODUCT_SAMPLE_IMAGE 
            SET
            IMAGE_SIZE = <cfif isdefined("attributes.size") and len(attributes.size)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.size#"><cfelse>NULL</cfif>,
                PRODUCT_SAMPLE_IMG_NAME = <cfif len(attributes.image_name)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.image_name#"><cfelse>NULL</cfif>,
                PRODUCT_SAMPLE_FILE_NAME = <cfif len(attributes.image_file)>'#file_name#.#cffile.serverfileext#'<cfelseif len(attributes.old_image_file)>'#attributes.old_image_file#'<cfelse>NULL</cfif>,
                PRODUCT_SAMPLE_IMG_DETAIL = <cfif len(attributes.detail)>#sql_unicode()#'#attributes.detail#'<cfelse>NULL</cfif>,
                IMAGE_SERVER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#fusebox.server_machine#">,				
                IS_EXTERNAL_LINK =  0,
                VIDEO_LINK = 0,
                VIDEO_PATH = <cfif isDefined("attributes.image_url_link")  and len(attributes.image_url_link)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.image_url_link#"><cfelse>NULL</cfif>,
                LANGUAGE_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.language_id#">
            WHERE 
            PRODUCT_SAMPLE_IMAGE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.image_action_id#">
        </cfquery>
    </cfif>

    <cfif isDefined("rd")>
        <cfinclude template="../display/rd.cfm">
    <cfelse>	
        <script type="text/javascript">
            <cfif not isDefined("attributes.draggable")>
                location.href = document.referrer;
                window.close();
            <cfelse>
                closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>','unique_imgs_get');
            </cfif>
        </script>
    </cfif>

</cfif>