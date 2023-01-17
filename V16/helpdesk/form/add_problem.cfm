<cfset queryJsonConverter = createObject("component","cfc.queryJSONConverter") />
<cfset upgrade_notes = createObject( "component","V16.objects.cfc.upgrade_notes" ) />
<cfset workcube_license = upgrade_notes.get_license_information() />
<cfset get_release_version = upgrade_notes.GET_RELEASE_VERSION() />
<cfset systemParam = application.systemParam.systemParam() />
<cfset last_upgrade_date = '#dateformat(len(get_release_version.UPDATE_DATE) ? get_release_version.UPDATE_DATE : get_release_version.RECORD_DATE, "DD-MM-YYYY")# #timeformat(len(get_release_version.UPDATE_DATE) ? get_release_version.UPDATE_DATE : get_release_version.RECORD_DATE, "HH:MM")#' />

<cfparam name="attributes.error_code" type="string" default="">
<cfparam name="attributes.extra_info" type="string" default="">

<cfif IsDefined("attributes.help") and len( attributes.help )>
	<cfquery name = "getFuseactionInfo" datasource = "#dsn#">
		SELECT 
			FULL_FUSEACTION
			,FILE_PATH
			,WRK_OBJECTS_ID
			,CONTROLLER_FILE_PATH
			,LICENCE
			,STATUS
			,IS_MENU
			,FILE_NAME
			,EXTERNAL_FUSEACTION
			,ADDOPTIONS_CONTROLLER_FILE_PATH
			,DISPLAY_BEFORE_PATH
			,DISPLAY_AFTER_PATH
			,ACTION_BEFORE_PATH
			,ACTION_AFTER_PATH
			,'#workcube_license.RELEASE_NO#' AS RELEASE_NO
			,'#workcube_license.RELEASE_DATE#' AS RELEASE_DATE
			,'#workcube_license.PATCH_NO#' AS PATCH_NO
			,'#workcube_license.PATCH_DATE#' AS PATCH_DATE
			,'#last_upgrade_date#' AS LAST_UPGRADE_DATE
			,'#systemParam.fusebox.server_machine_list#' AS DOMAIN
			,'#browserdetect()#' AS BROWSER_INFO
			,'#session.ep.company_id#' AS COMPANY_ID
			,'#session.ep.company#' AS COMPANY
			,'#session.ep.period_id#' AS PERIOD_ID
			,'#session.ep.period_year#' AS PERIOD_YEAR
			,'#dateformat(session.ep.period_date,"DD-MM-YYYY")#' AS PERIOD_DATE
			,'#attributes.error_code#' AS ERROR_CODE
		FROM WRK_OBJECTS 
		WHERE FULL_FUSEACTION = <cfqueryparam value = "#attributes.help#" CFSQLType = "cf_sql_nvarchar">
	</cfquery>

	<cfif getFuseactionInfo.recordcount>

		<cfset extraInformations = StructNew() />
		<cfset extraInformations = queryJsonConverter.returnData(Replace(SerializeJson(getFuseactionInfo),"//",""))[1] />

		<!--- Fuseactionla ilişkili olan xml parametreleri alınır --->

		<cfquery name="getFuseactionXmlProperty" datasource="#dsn#">
			SELECT 
				PROPERTY_VALUE,
				PROPERTY_NAME
			FROM
				FUSEACTION_PROPERTY
			WHERE
			<cfif isdefined("session.ep.userid")>
				OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
			<cfelseif isdefined("session.ww.userid")>
				OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.our_company_id#"> AND
			<cfelseif isdefined("session.pp.userid")>
				OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.our_company_id#"> AND
			</cfif>
			FUSEACTION_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.help#">
		</cfquery>

		<cftry>

			<cfscript>
				if(getFuseactionXmlProperty.recordcount){
					for(xml_ind_pro=1;xml_ind_pro lte getFuseactionXmlProperty.RECORDCOUNT;xml_ind_pro=xml_ind_pro+1){
						extraInformations["FUSEACTION_XML_PROPERTY"][getFuseactionXmlProperty.PROPERTY_NAME[xml_ind_pro]] = getFuseactionXmlProperty.PROPERTY_VALUE[xml_ind_pro];
					}
				}
			</cfscript>

			<cfset _modul_name_ = ListGetAt(attributes.help,1,'.')>
			<cfif _modul_name_ is 'prod'><cfset _modul_name_ = 'production_plan'></cfif>
			<cfif _modul_name_ is 'call'><cfset _modul_name_ = 'callcenter'></cfif>
			<cfif _modul_name_ is 'invent'><cfset _modul_name_ = 'inventory'></cfif>
			<cfif _modul_name_ is 'ehesap'><cfset _modul_name_ = 'hr/ehesap'></cfif>
			<cfif _modul_name_ is 'add_options'><cfset _modul_name_ = 'add_options'></cfif>

			<cfset folder_name = "#index_folder##_modul_name_##dir_seperator#xml#dir_seperator#">

			<cfif FileExists("#folder_name#faction_list.xml")>
				<cffile action="read" file="#folder_name#faction_list.xml" variable="xmldosyam" charset="UTF-8"><!--- Eğerki dosya bulunduysa faction_list.xml dosyası içinde verilen linkin işaret ettiği xml dosyası bulunacak ve veriler set edilecek. --->
				<cfscript>
					dosyam = XmlParse(xmldosyam);
					xml_dizi =dosyam.SETUP_SITE.XmlChildren;
					d_boyut = ArrayLen(xml_dizi);
					for(xind=1;xind lte d_boyut;xind=xind+1){
						if(ListLen(dosyam.SETUP_SITE.SETUPSITE[xind].LINK_FILE.XmlText,'.') gt 1){//eğerki faction list dosyasındaki linki gösteren yerin uzunluğu varsa burayı döndürüyoruz ve belirtilen dosyayı okumaya çalışıyoruz.
							xml_file_link = dosyam.SETUP_SITE.SETUPSITE[xind].LINK_FILE.XmlText;
							for(xfi=1;xfi lte ListLen(xml_file_link,',');xfi=xfi+1){//link_file'ları burda döndürüyoruz ve belirtilen sayfaya ait bir kayıt varmı ona erişmeye çalışıyoruz.
								if(ListGetAt(attributes.help,1,',') is ListGetAt(xml_file_link,xfi,',')){//eğerki link_file'da dosyamız bulunur ise link_file'in içinde virgüllü olarak 1den fazla xml sayfa ismi olabileceğininden her zaman ilk ismi alıcaz.çünkü standart olarak XML klasörünün içine her zaman LINK_FLE'IN içine yazılan ilk dosya adını alıcaz.
									xml_setting_file_name = '#folder_name##ListLast(ListFirst(xml_file_link,','),'.')#.xml';//burda faction list içinde belirttiğmiz ilgili sayfa ile ilgili değerleri tutan sayfanın adını aldık.Eğer bu değişken tanımlı değil ise yada boş ise,sayfaya ait bir xml sayfası oluşturulmamıştır.
								}	
							}
						}
					}
				</cfscript>
				<cfif isDefined("xml_setting_file_name") and len(xml_setting_file_name) and FileExists("#xml_setting_file_name#")><!---Faction List'de bir dosya ismi tanımlanmış mı ve Faction List'de bulduğumuz dosya adı ile kaydedilmiş bir XML dosyası varmı... --->
					<cffile action="read" file="#xml_setting_file_name#" variable="xmlsettingfile" charset="UTF-8">
					<cfscript>
						xml_setting_file = XmlParse(xmlsettingfile);
						new_xml_array = xml_setting_file.OBJECT_PROPERTIES.XmlChildren;
						new_array_len = ArrayLen(new_xml_array);
						for(xsfi=1;xsfi lte new_array_len;xsfi=xsfi+1){
							if( structKeyExists( extraInformations, 'FUSEACTION_XML_PROPERTY' ) and not structKeyExists( extraInformations["FUSEACTION_XML_PROPERTY"], xml_setting_file.OBJECT_PROPERTIES.OBJECT_PROPERTY[xsfi].PROPERTY.XmlText ) ){
								extraInformations["FUSEACTION_XML_PROPERTY"][xml_setting_file.OBJECT_PROPERTIES.OBJECT_PROPERTY[xsfi].PROPERTY.XmlText] = xml_setting_file.OBJECT_PROPERTIES.OBJECT_PROPERTY[xsfi].PROPERTY_DEFAULT.XmlText;
							}
						}
					</cfscript>
				</cfif>
			</cfif>
		
		<cfcatch type = "any"></cfcatch>
		</cftry>

		<cfquery name="getCompanyParameterInfo" datasource="#dsn#">
			SELECT * FROM OUR_COMPANY_INFO
			WHERE OUR_COMPANY_INFO.COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">;
		</cfquery>

		<cfif getCompanyParameterInfo.recordCount>
			<cfset extraInformations["COMPANY_PARAMETER_INFO"] = queryJsonConverter.returnData(Replace(SerializeJson(getCompanyParameterInfo),"//",""))[1] />
		</cfif>

		<cfset attributes.extra_info = LCase(Replace(SerializeJson(extraInformations),"//","")) />

	<cfelse>
		<script>
			alert("Bu fuseaction veritabanınızda mevcut değil! Lütfen eksik fuseaction'ı Dev WO - Workdev üzerinden ekleyerek yeniden deneyiniz!");
			window.close();
		</script>
	</cfif>
</cfif>
<cfquery name="GET_MAIL" datasource="#DSN#">
	SELECT
		EMPLOYEE_EMAIL
	FROM
		EMPLOYEES
	WHERE
		EMPLOYEE_ID = #session.ep.userid#
</cfquery>
<form name="pop_gonder" action="" method="post">
	<input type="hidden" name="workcube_id" id="workcube_id" value="<cfoutput>#workcube_license.WORKCUBE_ID#</cfoutput>">
	<input type="hidden" name="app_name" id="app_name" value="<cfoutput>#session.ep.name# #session.ep.surname#</cfoutput>">
	<input type="hidden" name="email" id="email" value="<cfoutput>#get_mail.employee_email#</cfoutput>">
	<input type="hidden" name="help_page" id="help_page" value="<cfoutput>#attributes.help#</cfoutput>">
	<input type="hidden" name="full_url" id="full_url" value="<cfoutput><cfif len(workcube_license.implementation_project_domain) and getFuseactionInfo.recordcount>#workcube_license.implementation_project_domain#/index.cfm?fuseaction=dev.wo&event=upd&fuseact=#attributes.help#&woid=#getFuseactionInfo.WRK_OBJECTS_ID#&Calls_#cgi.referer#</cfif></cfoutput>">
	<input type="hidden" name="language" id="language" value="<cfoutput>#session.ep.language#</cfoutput>">
	<input type="hidden" name="company" id="company" value="<cfoutput>#workcube_license.OWNER_COMPANY_TITLE#</cfoutput>">
	<input type="hidden" name="release_no" id="release_no" value="<cfoutput>#systemParam.workcube_version#</cfoutput>">
	<input type="hidden" name="patch_no" id="patch_no" value="<cfoutput>#workcube_license.PATCH_NO#</cfoutput>">
	<textarea name="extra_info" id="extra_info" style = "display:none;"><cfoutput>#attributes.extra_info#</cfoutput></textarea>
</form>
<cfswitch expression="#session.ep.language#">
	<cfcase value="tr">
		<cfset site_lang = "tr">
	</cfcase>
	<cfcase value="de">
		<cfset site_lang = "de">
	</cfcase>
	<cfdefaultcase>
		<cfset site_lang = "en">
	</cfdefaultcase>
</cfswitch>
<script type="text/javascript">
	pop_gonder.action='https://wiki.workcube.com/<cfoutput>#site_lang#</cfoutput>/WorkcubeSupport';
	pop_gonder.submit();
</script>