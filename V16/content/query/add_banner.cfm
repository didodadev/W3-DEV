<!--- add banner --->
<cfif len(attributes.start_date)>
	<cf_date tarih="attributes.start_date">
</cfif>
<cfif len(attributes.finish_date)>
	<cf_date tarih="attributes.finish_date">
</cfif>
<cfif not DirectoryExists("#upload_folder#content#dir_seperator#banner")>
    <cfdirectory action="create" directory="#upload_folder#content#dir_seperator#banner">
</cfif>
<cfif not len(attributes.content)>
<cftry>
    <cffile action="UPLOAD" 
        nameconflict="OVERWRITE" 
        filefield="banner" 
        destination="#upload_folder#content#dir_seperator#banner#dir_seperator#">
	<cfset file_name = "#createUUID()#.#cffile.serverfileext#">
	<cffile action="rename" source="#upload_folder#content#dir_seperator#banner#dir_seperator##cffile.serverfile#" destination="#upload_folder#content#dir_seperator#banner#dir_seperator##file_name#">		
	<!---Script dosyalarını engelle  02092010 ND --->
	<cfset assetTypeName = listlast(cffile.serverfile,'.')>
	<cfset blackList = 'php,php2,php3,php4,php5,phtml,pwml,inc,asp,aspx,ascx,jsp,cfm,cfml,cfc,pl,bat,exe,com,dll,vbs,reg,cgi,htaccess,asis'>
	<cfif listfind(blackList,assetTypeName,',')>
		<cffile action="delete" file="#upload_folder#content#dir_seperator#banner#dir_seperator##file_name#">
		<script type="text/javascript">
			alert("<cf_get_lang dictionary_id='54967.php,jsp,asp,cfm,cfml Formatlarda Dosya Girmeyiniz !'>");
			history.back();
		</script>
		<cfabort>
	</cfif>	
    <cfcatch type="any">
        <script type="text/javascript">
            alert("<cf_get_lang dictionary_id='57455.Dosyanız Upload Edilemedi ! Dosyanızı Kontrol Ediniz'>!");
            history.back();
        </script>
	<cfabort>
    </cfcatch>	
</cftry>
<cftry>
    <cffile action="UPLOAD" 
        nameconflict="OVERWRITE" 
        filefield="banner_2" 
        destination="#upload_folder#content#dir_seperator#banner#dir_seperator#">
	<cfset file_name_2 = "#createUUID()#.#cffile.serverfileext#">
	<cffile action="rename" source="#upload_folder#content#dir_seperator#banner#dir_seperator##cffile.serverfile#" destination="#upload_folder#content#dir_seperator#banner#dir_seperator##file_name_2#">		
	<!---Script dosyalarını engelle--->
	<cfset assetTypeName = listlast(cffile.serverfile,'.')>
	<cfset blackList = 'php,php2,php3,php4,php5,phtml,pwml,inc,asp,aspx,ascx,jsp,cfm,cfml,cfc,pl,bat,exe,com,dll,vbs,reg,cgi,htaccess,asis'>
	<cfif listfind(blackList,assetTypeName,',')>
		<cffile action="delete" file="#upload_folder#content#dir_seperator#banner#dir_seperator##file_name_2#">
		<script type="text/javascript">
			alert("<cf_get_lang dictionary_id='54967.php,jsp,asp,cfm,cfml Formatlarda Dosya Girmeyiniz !'>");
			history.back();
		</script>
		<cfabort>
	</cfif>	
    <cfcatch type="any">
        <script type="text/javascript">
            alert("<cf_get_lang dictionary_id='57455.Dosyanız Upload Edilemedi ! Dosyanızı Kontrol Ediniz'>!");
            history.back();
        </script>
	<cfabort>
    </cfcatch>	
</cftry>
</cfif>
<cflock name="#CREATEUUID()#" timeout="20">
	<cftransaction>	
        <cfquery name="ADD_BANNER" datasource="#DSN#" result="MAX_ID">
            INSERT INTO 
                CONTENT_BANNERS 
                (
                    IS_LOGIN_PAGE_EMPLOYEE,
                    IS_LOGIN_PAGE,
                    IS_ACTIVE,
                    IS_HOMEPAGE,				   
                    BANNER_NAME,
                    BANNER_FILE,
                    MOBILE_BANNER_FILE,
                    URL,
                    URL_PATH,
                    DETAIL,
                    BACK_COLOR,
                    MENU_ID,
                    <cfif len(attributes.banner_property_id)>BANNER_PROPERTY_ID,</cfif>	
                    <cfif len(attributes.contentcat_name) and len(attributes.contentcat_id)>CONTENTCAT_ID,</cfif>				 
                    <cfif len(attributes.chapter_name) and len(attributes.chapter_id)>CHAPTER_ID,</cfif>		
                    <cfif len(attributes.content_name) and len(attributes.content_id)>CONTENT_ID,</cfif>
                    <cfif len(attributes.banner_area_id)>BANNER_AREA_ID,</cfif>	
                    <cfif len(attributes.start_date)>START_DATE,</cfif> 
                    <cfif len(attributes.finish_date)>FINISH_DATE,</cfif>
                    <cfif len(attributes.product_name) and len(attributes.banner_product_id)>BANNER_PRODUCT_ID,</cfif>
                    <cfif len(attributes.camp_name) and len(attributes.campaign_id)>BANNER_CAMPAIGN_ID,</cfif>
                    <cfif len(attributes.product_cat) and len(attributes.banner_productcat_id)>BANNER_PRODUCTCAT_ID,</cfif>		
                    <cfif len(attributes.brand_name) and len(attributes.banner_brand_id)>BANNER_BRAND_ID,</cfif>
                    <cfif len(attributes.banner_width)>BANNER_WIDTH,</cfif>
                    <cfif len(attributes.banner_height)>BANNER_HEIGHT,</cfif>
                    RECORD_DATE,				 
                    RECORD_EMP,
                    RECORD_IP,
                    BANNER_SERVER_ID,
                    BANNER_TARGET,
                    <cfif len(attributes.sequence)>SEQUENCE,</cfif>
                    LANGUAGE,
                    CONTENT			 
                )
            VALUES 
                (
                    <cfif isdefined("attributes.is_login_page_employee")>1,<cfelse>0,</cfif>
                    <cfif isdefined("attributes.is_login_page")>1,<cfelse>0,</cfif>
                    <cfif isdefined("attributes.is_active") and len(attributes.is_active)>1,<cfelse>0,</cfif>
                    <cfif isdefined("attributes.is_homepage")>1,<cfelse>0,</cfif>             
                    #sql_unicode()#'#attributes.banner_name#',
                    <cfif isdefined("file_name") and len(file_name)><cfqueryparam value="#file_name#" cfsqltype="cf_sql_varchar"><cfelse>NULL</cfif>,
                    <cfif isdefined("file_name_2") and len(file_name_2)><cfqueryparam value="#file_name_2#" cfsqltype="cf_sql_varchar"><cfelse>NULL</cfif>, 
                    '#attributes.url#',
                    '#attributes.url_path#',
                    #sql_unicode()#'#left(attributes.explanation,250)#',
                    '#attributes.back_color#',
                    <cfif len(attributes.menu_id)>#attributes.menu_id#,<cfelse>null,</cfif>
                    <cfif len(attributes.banner_property_id)>#attributes.banner_property_id#,</cfif>	
                    <cfif len(attributes.contentcat_name) and len(attributes.contentcat_id)>#attributes.contentcat_id#,</cfif>				
                    <cfif len(attributes.chapter_name) and len(attributes.chapter_id)>#attributes.chapter_id#,</cfif>										
                    <cfif len(attributes.content_name) and len(attributes.content_id)>#attributes.content_id#,</cfif>
                    <cfif len(attributes.banner_area_id)>#attributes.banner_area_id#,</cfif>	
                    <cfif len(attributes.start_date)>#attributes.start_date#,</cfif>
                    <cfif len(attributes.finish_date)>#attributes.finish_date#,</cfif>
                    <cfif len(attributes.product_name) and len(attributes.banner_product_id)>#attributes.banner_product_id#,</cfif>
                    <cfif len(attributes.camp_name) and len(attributes.campaign_id)>#attributes.campaign_id#,</cfif>
                    <cfif len(attributes.product_cat) and len(attributes.banner_productcat_id)>#attributes.banner_productcat_id#,</cfif>
                    <cfif len(attributes.brand_name) and len(attributes.banner_brand_id)>#attributes.banner_brand_id#,</cfif>
                    <cfif len(attributes.banner_width)>#attributes.banner_width#,</cfif>
                    <cfif len(attributes.banner_height)>#attributes.banner_height#,</cfif>
                    #now()#,
                    #session.ep.userid#,
                    '#CGI.remote_addr#',
                    #fusebox.server_machine#,
                    '#attributes.banner_target#',
                    <cfif len(attributes.sequence)>#attributes.sequence#,</cfif>
                    '#attributes.language_id#',
                    '#attributes.content#'
                )
        </cfquery>
    </cftransaction>
</cflock>
<cfif isdefined("attributes.companycat_id") and listlen(attributes.companycat_id)>
	<cfloop list="#attributes.companycat_id#" index="c_id">
		<cfquery name="ADD_" datasource="#DSN#">
			INSERT INTO
				CONTENT_BANNERS_USERS
                (
                    BANNER_ID,
                    COMPANYCAT_ID
                )
				VALUES
                (
                    #max_id.identitycol#,
                    #c_id#
                )
		</cfquery>
	</cfloop>
</cfif>

<cfif isdefined("attributes.conscat_id") and listlen(attributes.conscat_id)>
	<cfloop list="#attributes.conscat_id#" index="cc_id">
		<cfquery name="ADD_" datasource="#DSN#">
			INSERT INTO
				CONTENT_BANNERS_USERS
                (
                    BANNER_ID,
                    CONSCAT_ID
                )
				VALUES
                (
                    #max_id.identitycol#,
                    #cc_id#
                )
		</cfquery>
	</cfloop>
</cfif>
<cfif isdefined("attributes.carrier_id") and listlen(attributes.carrier_id)>
	<cfloop list="#attributes.carrier_id#" index="ccc_id">
		<cfquery name="ADD_" datasource="#DSN#">
			INSERT INTO
				CONTENT_BANNERS_USERS
                (
                    BANNER_ID,
                    CARRIER_ID
                )
				VALUES
                (
                    #max_id.identitycol#,
                    #ccc_id#
                )
		</cfquery>
	</cfloop>
</cfif>

<cfif isdefined("attributes.is_internet")>
	<cfquery name="ADD_" datasource="#DSN#">
		INSERT INTO
			CONTENT_BANNERS_USERS
            (
                BANNER_ID,
                IS_INTERNET
            )
			VALUES
            (
            	#max_id.identitycol#,
                1
            )
	</cfquery>
</cfif>
<cfif isdefined("attributes.is_career")>
	<cfquery name="ADD_" datasource="#DSN#">
		INSERT INTO
			CONTENT_BANNERS_USERS
            (
                BANNER_ID,
                IS_CAREER
            )
			VALUES
            (
                #max_id.identitycol#,
                1
            )
	</cfquery>
</cfif>
<cflocation url="#request.self#?fuseaction=content.list_banners&event=upd&banner_id=#max_id.identitycol#" addtoken="no">
