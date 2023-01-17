<!--- bu sayfada unicodelar icin sql_unicode fonksiyonu kullanildi --->
<cfif isDefined('attributes.start_date') and len(attributes.start_date)>
	<cf_date tarih="attributes.start_date">
</cfif>
<cfif isDefined('attributes.finish_date') and len(attributes.finish_date)>
	<cf_date tarih="attributes.finish_date">
</cfif>
<cfif len(attributes.banner)>
		<cfif isdefined("attributes.banner_file") and len(attributes.banner_file)>
			<cf_del_server_file output_file="content/banner/#attributes.banner_file#" output_server="#attributes.banner_file_server_id#">
		</cfif>
		<cftry>
			<cffile action="UPLOAD" 
			nameconflict="OVERWRITE" 
			filefield="banner" 
			destination="#upload_folder#content#dir_seperator#banner#dir_seperator#">			
		<cfset file_name = "#createUUID()#.#cffile.serverfileext#">
		
		<cffile action="rename" source="#upload_folder#content#dir_seperator#banner#dir_seperator##cffile.serverfile#" destination="#upload_folder#content#dir_seperator#banner#dir_seperator##file_name#">
				
	<cfcatch type="any">
		<script type="text/javascript">
			alert("<cf_get_lang dictionary_id='57455.Dosyanız Upload Edilemedi ! Dosyanızı Kontrol Ediniz'>!");
			history.back();
		</script>
		<cfabort>
	</cfcatch>	
	</cftry>
</cfif>
<cfif len(attributes.banner_2)>
	<cfif isdefined("attributes.banner_file_2") and len(attributes.banner_file_2)>
		<cf_del_server_file output_file="content/banner/#attributes.banner_file_2#" output_server="#attributes.banner_file_server_id#">
	</cfif>
	<cftry>
		<cffile action="UPLOAD" 
		nameconflict="OVERWRITE" 
		filefield="banner_2" 
		destination="#upload_folder#content#dir_seperator#banner#dir_seperator#">			
	<cfset file_name_2 = "#createUUID()#.#cffile.serverfileext#">
	
	<cffile action="rename" source="#upload_folder#content#dir_seperator#banner#dir_seperator##cffile.serverfile#" destination="#upload_folder#content#dir_seperator#banner#dir_seperator##file_name_2#">
			
<cfcatch type="any">
	<script type="text/javascript">
		alert("<cf_get_lang dictionary_id='57455.Dosyanız Upload Edilemedi ! Dosyanızı Kontrol Ediniz'>!");
		history.back();
	</script>
	<cfabort>
</cfcatch>	
</cftry>
</cfif>
<cfquery name="add_banner" datasource="#dsn#">
	UPDATE 
		CONTENT_BANNERS
	SET 
		IS_ACTIVE = <cfif isdefined("attributes.is_active") and len(attributes.is_active)>1,<cfelse>0,</cfif>	   
		IS_HOMEPAGE = <cfif isdefined("attributes.is_homepage")>1,<cfelse>0,</cfif>
		IS_LOGIN_PAGE = <cfif isdefined("attributes.is_login_page")>1,<cfelse>0,</cfif>
		IS_LOGIN_PAGE_EMPLOYEE = <cfif isdefined("attributes.is_login_page_employee")>1,<cfelse>0,</cfif>
		MENU_ID = <cfif len(attributes.MENU_ID)>#attributes.MENU_ID#,<cfelse>NULL,</cfif>
		BANNER_NAME = #sql_unicode()#'#attributes.banner_name#' ,
		<cfif len(attributes.banner)>BANNER_FILE = '#file_name#',</cfif>
		<cfif len(attributes.banner)>BANNER_SERVER_ID = #fusebox.server_machine#,</cfif>
		URL = '#attributes.url#',
		URL_PATH = '#attributes.url_path#',
		DETAIL = #sql_unicode()#'#left(attributes.explanation,250)#',
		BACK_COLOR = '#attributes.back_color#',
		<cfif len(attributes.contentcat_name) and len(attributes.CONTENTCAT_ID)>CONTENTCAT_ID = #attributes.CONTENTCAT_ID#,<cfelse>CONTENTCAT_ID = NULL,</cfif>				 
		<cfif len(attributes.chapter_name) and attributes.chapter_id neq ''>CHAPTER_ID = #attributes.chapter_id#,<cfelse>CHAPTER_ID = NULL,</cfif>		
		<cfif len(attributes.content_name) and attributes.content_id neq ''>CONTENT_ID = #attributes.content_id#,<cfelse>CONTENT_ID = NULL,</cfif>
		<cfif len(attributes.BANNER_PROPERTY_ID)>BANNER_PROPERTY_ID = #attributes.BANNER_PROPERTY_ID#,<cfelse>BANNER_PROPERTY_ID = NULL,</cfif>
		<cfif len(attributes.BANNER_AREA_ID)>BANNER_AREA_ID = #attributes.BANNER_AREA_ID#,<cfelse>BANNER_AREA_ID = NULL,</cfif>
		<cfif len(attributes.START_DATE)>START_DATE = #attributes.start_date#,</cfif>
		<cfif len(attributes.FINISH_DATE)>FINISH_DATE = #attributes.FINISH_DATE#,</cfif>
		<cfif len(attributes.product_name) and len(attributes.banner_product_id)>BANNER_PRODUCT_ID = #attributes.banner_product_id#,<cfelse>BANNER_PRODUCT_ID = NULL,</cfif>
		<cfif len(attributes.camp_name) and len(attributes.campaign_id)>BANNER_CAMPAIGN_ID = #attributes.campaign_id#,<cfelse>BANNER_CAMPAIGN_ID = NULL,</cfif>
		<cfif len(attributes.product_cat) and len(attributes.banner_productcat_id)>BANNER_PRODUCTCAT_ID = #attributes.banner_productcat_id#,<cfelse>BANNER_PRODUCTCAT_ID = NULL,</cfif>
		<cfif len(attributes.brand_name) and len(attributes.banner_brand_id)>BANNER_BRAND_ID = #attributes.banner_brand_id#,<cfelse>BANNER_BRAND_ID = NULL,</cfif>
		<cfif len(attributes.banner_width)>BANNER_WIDTH = #attributes.banner_width#,<cfelse>BANNER_WIDTH = NULL,</cfif>
		<cfif len(attributes.banner_height)>BANNER_HEIGHT = #attributes.banner_height#,<cfelse>BANNER_HEIGHT = NULL,</cfif>
		BANNER_TARGET = '#attributes.banner_target#',
		UPDATE_DATE = #now()#,
		UPDATE_EMP  = #session.ep.userid#,
        <cfif len(attributes.sequence)>SEQUENCE = #attributes.sequence#,<cfelse>SEQUENCE = NULL,</cfif>
        LANGUAGE =  <cfqueryparam value="#attributes.language_id#" cfsqltype="cf_sql_varchar">,
		CONTENT = <cfqueryparam value="#attributes.content#" cfsqltype="cf_sql_varchar">, 
		MOBILE_BANNER_FILE= <cfqueryparam value="#file_name_2#" cfsqltype="cf_sql_varchar">
	WHERE 
		BANNER_ID   = #attributes.banner_id#
</cfquery>

<cfquery name="del_" datasource="#dsn#">
	DELETE FROM CONTENT_BANNERS_USERS WHERE BANNER_ID = #attributes.banner_id#
</cfquery>

<cfif isdefined("attributes.COMPANYCAT_ID") and listlen(attributes.COMPANYCAT_ID)>
	<cfloop list="#attributes.COMPANYCAT_ID#" index="c_id">
		<cfquery name="add_" datasource="#dsn#">
			INSERT INTO
				CONTENT_BANNERS_USERS
					(
					BANNER_ID,
					COMPANYCAT_ID
					)
				VALUES
					(
					#attributes.banner_id#,
					#c_id#
					)
		</cfquery>
	</cfloop>
</cfif>

<cfif isdefined("attributes.CONSCAT_ID") and listlen(attributes.CONSCAT_ID)>
	<cfloop list="#attributes.CONSCAT_ID#" index="cc_id">
		<cfquery name="add_" datasource="#dsn#">
			INSERT INTO
				CONTENT_BANNERS_USERS
					(
					BANNER_ID,
					CONSCAT_ID
					)
				VALUES
					(
					#attributes.banner_id#,
					#cc_id#
					)
		</cfquery>
	</cfloop>
</cfif>
<cfif isdefined("attributes.carrier_id") and listlen(attributes.carrier_id)>
	<cfloop list="#attributes.carrier_id#" index="ccc_id">
		<cfquery name="add_" datasource="#DSN#">
			INSERT INTO
				CONTENT_BANNERS_USERS
                (
                    BANNER_ID,
                    CARRIER_ID
                )
				VALUES
                (
                    #attributes.banner_id#,
                    #ccc_id#
                )
		</cfquery>
	</cfloop>
</cfif>

<cfif isdefined("attributes.is_internet")>
	<cfquery name="add_" datasource="#dsn#">
		INSERT INTO
			CONTENT_BANNERS_USERS
				(
				BANNER_ID,
				IS_INTERNET
				)
			VALUES
				(
				#attributes.banner_id#,
				1
				)
	</cfquery>
</cfif>
<cfif isdefined("attributes.is_career")>
	<cfquery name="add_" datasource="#dsn#">
		INSERT INTO
			CONTENT_BANNERS_USERS
				(
				BANNER_ID,
				IS_CAREER
				)
			VALUES
				(
				#attributes.banner_id#,
				1
				)
	</cfquery>
</cfif>
<cflocation url="#request.self#?fuseaction=content.list_banners&event=upd&banner_id=#attributes.banner_id#" addtoken="no">
