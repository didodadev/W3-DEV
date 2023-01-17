<!--- Standart XML Aktarim Islemi--->

<!--- SETUP_LANGUAGE tablosu Sozluk icin dil secenekleri--->
<cfquery name="CHECK" datasource="#DSN#">
	SELECT LANGUAGE_ID FROM SETUP_LANGUAGE
</cfquery>
<cfif not check.recordcount>
	<cffile action="read" file="#attributes.upload_folder#xml#dir_seperator#setup_language.xml" variable="xmldosyam" charset="UTF-8">
	<cfset dosyam = XmlParse(xmldosyam)>
	<cfset xml_dizi = dosyam.SETUP_LANGUAGE.XmlChildren>
	<cfset d_boyut = ArrayLen(xml_dizi)>
	<cfloop index="i" from = "1" to = "#d_boyut#">
		<cfquery name="ADD_LANGUAGE" datasource="#DSN#">
			INSERT INTO
				SETUP_LANGUAGE
			(
				LANGUAGE_ID,
				LANGUAGE_SET,
				LANGUAGE_SHORT,
                IS_ACTIVE
			)
			VALUES
			(
				  #dosyam.SETUP_LANGUAGE.LANGUAGE[i].LANGUAGE_ID.XmlText#,
				  #sql_unicode()#'#dosyam.SETUP_LANGUAGE.LANGUAGE[i].LANGUAGE_SET.XmlText#',
				  #sql_unicode()#'#dosyam.SETUP_LANGUAGE.LANGUAGE[i].LANGUAGE_SHORT.XmlText#',
                  1
			)
		</cfquery>
	</cfloop>
</cfif>

<!--- SETUP_KNOWLEVEL tabosu IK Bilgi Seviyesi --->
<cfquery name="CHECK" datasource="#DSN#">
	SELECT KNOWLEVEL_ID FROM SETUP_KNOWLEVEL
</cfquery>
<cfif not check.recordcount>
	<cffile action="read" file="#attributes.upload_folder#xml#dir_seperator#knowledge_level.xml" variable="xmldosyam" charset = "UTF-8">
	<cfset dosyam = XmlParse(xmldosyam)>
	<cfset xml_dizi = dosyam.SETUP_KNOWLEVEL.XmlChildren>
	<cfset d_boyut = ArrayLen(xml_dizi)>
	<cfloop index="i" from = "1" to = "#d_boyut#">
		<cfquery name="ADD_SETUP_KNOWLEVEL" datasource="#DSN#">
			INSERT INTO
				SETUP_KNOWLEVEL
			(
				KNOWLEVEL
			)
			VALUES
			(
				 #sql_unicode()#'#dosyam.SETUP_KNOWLEVEL.KNOWLEDGE[i].KNOWLEVEL.XmlText#'
			)
		</cfquery>
	</cfloop>
</cfif>

<!--- SETUP_SCHOOL tablosu IK Universiteler --->
<cfquery name="CHECK" datasource="#DSN#">
	SELECT SCHOOL_ID FROM SETUP_SCHOOL
</cfquery>
<cfif not check.recordcount>
	<cffile action="read" file="#attributes.upload_folder#xml#dir_seperator#setup_school_names.xml" variable="xmldosyam" charset = "UTF-8">
	<cfset dosyam = XmlParse(xmldosyam)>
	<cfset xml_dizi = dosyam.SETUP_SCHOOL.XmlChildren>
	<cfset d_boyut = ArrayLen(xml_dizi)>
	<cfloop index="i" from = "1" to = "#d_boyut#">
		<cfquery name="ADD_SETUP_SCHOOL" datasource="#DSN#">
			INSERT INTO
				SETUP_SCHOOL
			(
				SCHOOL_NAME,
                SCHOOL_TYPE
			)
			VALUES
			(
				#sql_unicode()#'#dosyam.SETUP_SCHOOL.SCHOOL[i].SCHOOL_NAME.XmlText#',
                #sql_unicode()#'#dosyam.SETUP_SCHOOL.SCHOOL[i].SCHOOL_TYPE.XmlText#'
			)
		</cfquery>
	</cfloop>
</cfif>

<!--- SETUP_SCHOOL_PART tablosu IK Universite Bolumleri --->
<cfquery name="CHECK" datasource="#DSN#">
	SELECT PART_ID FROM SETUP_SCHOOL_PART
</cfquery>
<cfif not check.recordcount>
	<cffile action="read" file="#attributes.upload_folder#xml#dir_seperator#setup_school_parts.xml" variable="xmldosyam" charset = "UTF-8">
	<cfset dosyam = XmlParse(xmldosyam)>
	<cfset xml_dizi = dosyam.SETUP_SCHOOL_PART.XmlChildren>
	<cfset d_boyut = ArrayLen(xml_dizi)>
	<cfloop index="i" from = "1" to = "#d_boyut#">
		<cfquery name="ADD_SETUP_SCHOOL_PART" datasource="#DSN#">
			INSERT INTO
				SETUP_SCHOOL_PART
			(
				PART_NAME
			)
			VALUES
			(
				#sql_unicode()#'#dosyam.SETUP_SCHOOL_PART.SCHOOL_PART[i].PART_NAME.XmlText#'
			)
		</cfquery>
	</cfloop>
</cfif>

<!--- SETUP_HIGH_SCHOOL_PART tablosu IK Lise Bolumleri --->
<cfquery name="CHECK" datasource="#DSN#">
	SELECT HIGH_PART_ID FROM SETUP_HIGH_SCHOOL_PART
</cfquery>
<cfif not check.recordcount>
	<cffile action="read" file="#attributes.upload_folder#xml#dir_seperator#setup_high_school_parts.xml" variable="xmldosyam" charset = "UTF-8">
	<cfset dosyam = XmlParse(xmldosyam)>
	<cfset xml_dizi = dosyam.SETUP_HIGH_SCHOOL_PART.XmlChildren>
	<cfset d_boyut = ArrayLen(xml_dizi)>
	<cfloop index="i" from = "1" to = "#d_boyut#">
		<cfquery name="ADD_SETUP_HIGH_SCHOOL_PART" datasource="#DSN#">
			INSERT INTO
				SETUP_HIGH_SCHOOL_PART
			(
				HIGH_PART_NAME
			)
			VALUES
			(
				#sql_unicode()#'#dosyam.SETUP_HIGH_SCHOOL_PART.HIGH_SCHOOL_PART[i].PART_NAME.XmlText#'
			)
		</cfquery>
	</cfloop>
</cfif>

<!--- SETUP_COUNTRY tablosu Ulkeler  --->
<cfquery name="CHECK" datasource="#DSN#">
	SELECT COUNTRY_ID FROM SETUP_COUNTRY
</cfquery>
<cfif not check.recordcount>
	<cffile action="read" file="#attributes.upload_folder#xml#dir_seperator#setup_country.xml" variable="xmldosyam" charset = "UTF-8">
	<cfset dosyam = XmlParse(xmldosyam)>
	<cfset xml_dizi = dosyam.SETUP_COUNTRY.XmlChildren>
	<cfset d_boyut = ArrayLen(xml_dizi)>
	<cfloop index="i" from = "1" to = "#d_boyut#">
		<cfquery name="ADD_SETUP_COUNTRY" datasource="#DSN#">
			INSERT INTO
				SETUP_COUNTRY
			(
				COUNTRY_NAME
			)
			VALUES
			(
				#sql_unicode()#'#dosyam.SETUP_COUNTRY.COUNTRY[i].COUNTRY_NAME.XmlText#'
			)
		</cfquery>
	</cfloop>
</cfif>

<!--- SETUP_CITY tablosu Iller--->
<cfquery name="CHECK" datasource="#DSN#">
	SELECT CITY_ID FROM SETUP_CITY
</cfquery>
<cfif not check.recordcount>
	<cffile action="read" file="#attributes.upload_folder#xml#dir_seperator#setup_city.xml" variable="xmldosyam" charset = "UTF-8">
	<cfset dosyam = XmlParse(xmldosyam)>
	<cfset xml_dizi = dosyam.SETUP_CITY.XmlChildren>
	<cfset d_boyut = ArrayLen(xml_dizi)>
	<cfloop index="i" from = "1" to = "#d_boyut#">
		<cfquery name="ADD_SETUP_CITY" datasource="#DSN#">
			INSERT INTO
				SETUP_CITY
			(
				CITY_NAME,
				PHONE_CODE,
				PLATE_CODE,
				COUNTRY_ID
			)
			VALUES
			(
				#sql_unicode()#'#dosyam.SETUP_CITY.CITY[i].CITY_NAME.XmlText#',
				#sql_unicode()#'#dosyam.SETUP_CITY.CITY[i].PHONE_CODE.XmlText#',
				#sql_unicode()#'#dosyam.SETUP_CITY.CITY[i].PLATE_CODE.XmlText#',
				#sql_unicode()#'#dosyam.SETUP_CITY.CITY[i].COUNTRY_ID.XmlText#'
			)
		</cfquery>
	</cfloop>
</cfif>

<!--- SETUP_COUNTY tablosu Ilceler --->
<cfquery name="CHECK" datasource="#DSN#">
	SELECT COUNTY_ID FROM SETUP_COUNTY
</cfquery>
<cfif not check.recordcount>
	<cffile action="read" file="#attributes.upload_folder#xml#dir_seperator#setup_county.xml" variable="xmldosyam" charset = "UTF-8">
	<cfset dosyam = XmlParse(xmldosyam)>
	<cfset xml_dizi = dosyam.SETUP_COUNTY.XmlChildren>
	<cfset d_boyut = ArrayLen(xml_dizi)>
	<cfloop index="i" from = "1" to = "#d_boyut#">
		<cfquery name="ADD_SETUP_COUNTY" datasource="#DSN#">
			INSERT INTO
				SETUP_COUNTY
			(
				COUNTY_NAME,
				CITY
			)
			VALUES
			(
				#sql_unicode()#'#dosyam.SETUP_COUNTY.COUNTY[i].COUNTY_NAME.XmlText#',
				#sql_unicode()#'#dosyam.SETUP_COUNTY.COUNTY[i].CITY.XmlText#'
			)
		</cfquery>
	</cfloop>
</cfif>

<!---  SETUP_COMPANY_SIZE_CATS tablosu Sirket Calisan Sayisi--->
<cfquery name="CHECK" datasource="#DSN#">
	SELECT COMPANY_SIZE_CAT_ID FROM SETUP_COMPANY_SIZE_CATS
</cfquery>
<cfif not check.recordcount>
	<cffile action="read" file="#attributes.upload_folder#xml#dir_seperator#company_size.xml" variable="xmldosyam" charset = "UTF-8">
	<cfset dosyam = XmlParse(xmldosyam)>
	<cfset xml_dizi = dosyam.SETUP_COMPANY_SIZE_CATS.XmlChildren>
	<cfset d_boyut = ArrayLen(xml_dizi)>
	<cfset Sorgum = QueryNew("ID,COMPANY_SIZE_CAT")>
	<cfset temp = QueryAddRow(Sorgum, #d_boyut#)>
	<cfloop index="i" from = "1" to = #d_boyut#>
	   <cfset temp = QuerySetCell(Sorgum, "ID",#dosyam.SETUP_COMPANY_SIZE_CATS.COMPANY[i].COMPANY_SIZE_CAT_ID.XmlText#, #i#)>
	   <cfset temp = QuerySetCell(Sorgum, "COMPANY_SIZE_CAT",'#dosyam.SETUP_COMPANY_SIZE_CATS.COMPANY[i].COMPANY_SIZE_CAT.XmlText#', #i#)>
	</cfloop>

	<cfquery name="COMPANY_SIZE" dbtype="query">
		SELECT
			*
		FROM
			sorgum
		ORDER BY ID
	</cfquery>

	<cfoutput query="COMPANY_SIZE">
		<cfquery name="ADD_COMPANY_SIZE_CAT" datasource="#DSN#">
			INSERT INTO
				SETUP_COMPANY_SIZE_CATS
			(
				COMPANY_SIZE_CAT
			)
			VALUES
			(
				#sql_unicode()#'#COMPANY_SIZE_CAT#'
			)
		</cfquery>
	</cfoutput>
</cfif>

<!---  SETUP_COMMETHOD tablosu Iletisim Yontemleri --->
<cfquery name="CHECK" datasource="#DSN#">
	SELECT COMMETHOD_ID FROM SETUP_COMMETHOD
</cfquery>
<cfif not check.recordcount>
	<cffile action="read" file="#attributes.upload_folder#xml#dir_seperator#commetod.xml" variable="xmldosyam" charset = "UTF-8">
	<cfset dosyam = XmlParse(xmldosyam)>
	<cfset xml_dizi = dosyam.SETUP_COMMETHOD.XmlChildren>
	<cfset d_boyut = ArrayLen(xml_dizi)>
	<cfloop index="i" from = "1" to = "#d_boyut#">
		<cfquery name="ADD_SETUP_COMMETHOD" datasource="#DSN#">
			INSERT INTO
				SETUP_COMMETHOD
			(
				COMMETHOD
			)
			VALUES
			(
				 #sql_unicode()#'#dosyam.SETUP_COMMETHOD.SETUP_COM[i].COMMETHOD.XmlText#'
			)
		</cfquery>
	</cfloop>
</cfif>

<!---  COMPANY_CAT tablosu Kurumsal Uye Kategorileri --->
<cfquery name="CHECK" datasource="#DSN#">
	SELECT COMPANYCAT_ID FROM COMPANY_CAT
</cfquery>
<cfif not check.recordcount>
	<cffile action="read" file="#attributes.upload_folder#xml#dir_seperator#company_cat.xml" variable="xmldosyam" charset = "UTF-8">
	<cfset dosyam = XmlParse(xmldosyam)>
	<cfset xml_dizi = dosyam.COMPANY_CAT.XmlChildren>
	<cfset d_boyut = ArrayLen(xml_dizi)>
	<cfloop index="i" from = "1" to = "#d_boyut#">
		<cfquery name="ADD_COMPANY_CAT" datasource="#DSN#">
			INSERT INTO
				COMPANY_CAT
			(
				COMPANYCAT
			)
			VALUES
			(
				 #sql_unicode()#'#dosyam.COMPANY_CAT.COMPANY[i].COMPANYCAT.XmlText#'
			)
		</cfquery>
	</cfloop>
</cfif>

<!---  SETUP_IDENTYCARD tablosu Kimlik Karti Kategorileri --->
<cfquery name="CHECK" datasource="#DSN#">
	SELECT IDENTYCAT_ID FROM SETUP_IDENTYCARD
</cfquery>
<cfif not check.recordcount>
	<cffile action="read" file="#attributes.upload_folder#xml#dir_seperator#identity.xml" variable="xmldosyam" charset = "UTF-8">
	<cfset dosyam = XmlParse(xmldosyam)>
	<cfset xml_dizi = dosyam.SETUP_IDENTYCARD.XmlChildren>
	<cfset d_boyut = ArrayLen(xml_dizi)>
	<cfloop index="i" from = "1" to = "#d_boyut#">
		<cfquery name="ADD_SETUP_IDENTYCARD" datasource="#DSN#">
			INSERT INTO
				SETUP_IDENTYCARD
			(
				IDENTYCAT
			)
			VALUES
			(
				 #sql_unicode()#'#dosyam.SETUP_IDENTYCARD.IDENTITY[i].IDENTYCAT.XmlText#'
			)
		</cfquery>
	</cfloop>
</cfif>

<!---  SETUP_IM tablosu IM Kategorileri --->
<cfquery name="CHECK" datasource="#DSN#">
	SELECT IMCAT_ID FROM SETUP_IM
</cfquery>
<cfif not check.recordcount>
	<cffile action="read" file="#attributes.upload_folder#xml#dir_seperator#imcat.xml" variable="xmldosyam" charset = "UTF-8">
	<cfset dosyam = XmlParse(xmldosyam)>
	<cfset xml_dizi = dosyam.SETUP_IM.XmlChildren>
	<cfset d_boyut = ArrayLen(xml_dizi)>
	<cfloop index="i" from = "1" to = "#d_boyut#">
		<cfquery name="ADD_SETUP_IM" datasource="#DSN#">
			INSERT INTO
				SETUP_IM
			(
				IMCAT
			)
			VALUES
			(
				 #sql_unicode()#'#dosyam.SETUP_IM.CAT[i].IMCAT.XmlText#'
			)
		</cfquery>
	</cfloop>
</cfif>

<!--- ASSET_CAT tablosu Varlik Kategorileri --->
<cfquery name="CHECK" datasource="#DSN#">
	SELECT ASSETCAT_ID FROM ASSET_CAT
</cfquery>
<cfif not check.recordcount>
	<cffile action="read" file="#attributes.upload_folder#xml#dir_seperator#asset_cat.xml" variable="xmldosyam" charset = "UTF-8">
	<cfset dosyam = XmlParse(xmldosyam)>
	<cfset xml_dizi = dosyam.ASSET_CAT.XmlChildren>
	<cfset d_boyut = ArrayLen(xml_dizi)>
	<cfloop index="i" from = "1" to = "#d_boyut#">
		<cfquery name="ADD_ASSET_CAT" datasource="#DSN#">
			INSERT INTO
				ASSET_CAT
			(
				ASSETCAT_ID,
				ASSETCAT,
				ASSETCAT_PATH,
				ASSETCAT_DETAIL
			)
			VALUES
			(
				 #dosyam.ASSET_CAT.ASSETCAT[i].ASSETCAT_ID.XmlText#,
				 #sql_unicode()#'#dosyam.ASSET_CAT.ASSETCAT[i].ASSETCAT.XmlText#',
				 #sql_unicode()#'#dosyam.ASSET_CAT.ASSETCAT[i].ASSETCAT_PATH.XmlText#',
				 #sql_unicode()#'#dosyam.ASSET_CAT.ASSETCAT[i].ASSETCAT_DETAIL.XmlText#'
			)
		</cfquery>
	</cfloop>
</cfif>

<!--- MODULES tablosu Moduller --->
<cfquery name="CHECK" datasource="#DSN#">
	SELECT MODULE_ID FROM MODULES
</cfquery>
<cfif not check.recordcount>
	<cffile action="read" file="#attributes.upload_folder#xml#dir_seperator#modules.xml" variable="xmldosyam" charset="UTF-8">
	<cfset dosyam = XmlParse(xmldosyam)>
	<cfset xml_dizi = dosyam.MODULES.XmlChildren>
	<cfset d_boyut = ArrayLen(xml_dizi)>
	<cfloop index="i" from = "1" to = "#d_boyut#">
		<cfquery name="ADD_MODULE" datasource="#DSN#">
			INSERT INTO
				MODULES
			(
				MODULE_ID,
				MODULE_NAME,
				MODULE_NAME_TR,
				MODULE_SHORT_NAME,
				FOLDER
			)
			VALUES
			(
				   #dosyam.MODULES.MODULE[i].MODULE_ID.XmlText#,
				 #sql_unicode()#'#dosyam.MODULES.MODULE[i].MODULE_NAME.XmlText#',
				 #sql_unicode()#'#dosyam.MODULES.MODULE[i].MODULE_NAME_TR.XmlText#',
				 #sql_unicode()#'#dosyam.MODULES.MODULE[i].MODULE_SHORT_NAME.XmlText#',
				 #sql_unicode()#'#dosyam.MODULES.MODULE[i].FOLDER.XmlText#'
			)
		</cfquery>
	</cfloop>
</cfif>

<!--- SETUP_MOBILCAT tablosu Mobil Telefon Kodlari --->
<cfquery name="CHECK_MOB" datasource="#DSN#">
	SELECT MOBILCAT_ID FROM SETUP_MOBILCAT
</cfquery>
<cfif not check_mob.recordcount>
	<cffile action="read" file="#attributes.upload_folder#xml#dir_seperator#setup_mobilcat.xml" variable="xmldosyam" charset="UTF-8">
	<cfset dosyam = XmlParse(xmldosyam)>
	<cfset xml_dizi = dosyam.SETUP_MOB.XmlChildren>
	<cfset d_boyut = ArrayLen(xml_dizi)>
	<cfloop index="i" from = "1" to = "#d_boyut#">
		<cfquery name="ADD_MOBILCAT" datasource="#DSN#">
			INSERT INTO
				SETUP_MOBILCAT
			(
				MOBILCAT
			)
			VALUES
			(
				#sql_unicode()#'#dosyam.SETUP_MOB.MOB[i].MOBCAT.XmlText#'
			)
		</cfquery>
	</cfloop>
</cfif>

<!--- SETUP_PRIORITY tablosu Oncelik Kategorileri --->
<cfquery name="CHECK" datasource="#DSN#">
	SELECT PRIORITY_ID FROM SETUP_PRIORITY
</cfquery>
<cfif not check.recordcount>
	<cffile action="read" file="#attributes.upload_folder#xml#dir_seperator#setup_priority.xml" variable="xmldosyam" charset="UTF-8">
	<cfset dosyam = XmlParse(xmldosyam)>
	<cfset xml_dizi = dosyam.SETUP_PRIORITY.XmlChildren>
	<cfset d_boyut = ArrayLen(xml_dizi)>
	<cfloop index="i" from = "1" to = "#d_boyut#">
		<cfquery name="ADD_SETUP_PRIORITY" datasource="#DSN#">
			INSERT INTO
				SETUP_PRIORITY
			(
				PRIORITY,
				COLOR
			)
			VALUES
			(
				#sql_unicode()#'#dosyam.SETUP_PRIORITY.SET[i].PRIORITY.XmlText#',
				#sql_unicode()#'#dosyam.SETUP_PRIORITY.SET[i].COLOR.XmlText#'
			)
		</cfquery>
	</cfloop>
</cfif>

<!---- SETUP_ACTION_STAGES tablosu Aksiyon Asamalari ---->
<cfquery name="GET_stages" datasource="#DSN#">
	SELECT STAGE_ID FROM SETUP_ACTION_STAGES
</cfquery>	
<cfif not get_stages.recordcount>
	<cffile action="read" file="#attributes.upload_folder#xml#dir_seperator#action_stages.xml" variable="xmldosyam" charset = "UTF-8">
	<cfset dosyam = XmlParse(xmldosyam)>
	<cfset xml_dizi = dosyam.STAGES.XmlChildren>
	<cfset d_boyut = ArrayLen(xml_dizi)>
	<cfloop index="i" from = "1" to = "#d_boyut#">
		<cfquery name="ADD_STAGE" datasource="#DSN#">
			INSERT INTO
				SETUP_ACTION_STAGES
			(
				STAGE_ID,
				STAGE_NAME
			)
			VALUES
			(
				 #dosyam.STAGES.STAGE[i].STAGE_ID.XmlText#,
				#sql_unicode()#'#dosyam.STAGES.STAGE[i].STAGE_NAME.XmlText#'					 
			)
		</cfquery>
	</cfloop>
</cfif>

<!---- SETUP_QUIZ_STAGE tablosu IK Test Asamalari ---->
<cfquery name="GET_CATALOGS" datasource="#DSN#">
	SELECT STAGE_ID FROM SETUP_QUIZ_STAGE
</cfquery>	
<cfif not get_catalogs.recordcount>
	<cffile action="read" file="#attributes.upload_folder#xml#dir_seperator#setup_quiz_stage.xml" variable="xmldosyam" charset = "UTF-8">
	<cfset dosyam = XmlParse(xmldosyam)>
	<cfset xml_dizi = dosyam.STAGES.XmlChildren>
	<cfset d_boyut = ArrayLen(xml_dizi)>
	<cfloop index="i" from = "1" to = "#d_boyut#">
		<cfquery name="ADD_STAGE" datasource="#DSN#">
			INSERT INTO
				SETUP_QUIZ_STAGE
			(
				STAGE_ID,
				STAGE_NAME
			)
			VALUES
			(
				 #dosyam.STAGES.STAGE[i].STAGE_ID.XmlText#,
				#sql_unicode()#'#dosyam.STAGES.STAGE[i].STAGE_NAME.XmlText#'					 
			)
		</cfquery>
	</cfloop>
</cfif>

<!---- EVENT_CAT tablosu Olay Kategorileri ---->
<cfquery name="GET_EVENT_CATS" datasource="#DSN#">
	SELECT EVENTCAT_ID FROM EVENT_CAT
</cfquery>	
<cfif not get_event_cats.recordcount>
	<cffile action="read" file="#attributes.upload_folder#xml#dir_seperator#event_cat.xml" variable="xmldosyam" charset = "UTF-8">
	<cfset dosyam = XmlParse(xmldosyam)>
	<cfset xml_dizi = dosyam.EVENT_CAT.XmlChildren>
	<cfset d_boyut = ArrayLen(xml_dizi)>
	<cfloop index="i" from = "1" to = "#d_boyut#">
		<cfquery name="ADD_EVENT_CAT" datasource="#DSN#">
			INSERT INTO
				EVENT_CAT
			(
				EVENTCAT,                                           
				COLOUR,
				IS_VIP
			)
			VALUES
			(
				#sql_unicode()#'#dosyam.EVENT_CAT.EVENTCAT_MAIN[i].EVENTCAT.XmlText#',
				#sql_unicode()#'#dosyam.EVENT_CAT.EVENTCAT_MAIN[i].COLOUR.XmlText#',
				#dosyam.EVENT_CAT.EVENTCAT_MAIN[i].IS_VIP.XmlText#				 
			)
		</cfquery>
	</cfloop>
</cfif>

<!---- SETUP_CORR tablosu Yazisma Kategorileri ---->
<cfquery name="GET_SETUP_CORR" datasource="#DSN#">
	SELECT CORRCAT_ID FROM SETUP_CORR
</cfquery>	
<cfif not get_setup_corr.recordcount>
	<cffile action="read" file="#attributes.upload_folder#xml#dir_seperator#setup_corr.xml" variable="xmldosyam" charset = "UTF-8">
	<cfset dosyam = XmlParse(xmldosyam)>
	<cfset xml_dizi = dosyam.SETUP_CORR.XmlChildren>
	<cfset d_boyut = ArrayLen(xml_dizi)>
	<cfloop index="i" from = "1" to = "#d_boyut#">
		<cfquery name="ADD_SETUP_CORR" datasource="#DSN#">
			INSERT INTO
				SETUP_CORR
			(
			  CORRCAT,    
			  DETAIL
			)
			VALUES
			(
				#sql_unicode()#'#dosyam.SETUP_CORR.SETUPCORR[i].CORRCAT.XmlText#',
				#sql_unicode()#'#dosyam.SETUP_CORR.SETUPCORR[i].DETAIL.XmlText#'					 
			)
		</cfquery>
	</cfloop>
</cfif>

<!---- SHIP_METHOD tablosu Sevk Yontemleri ---->
<cfquery name="SHIP_METHOD" datasource="#DSN#">
	SELECT SHIP_METHOD_ID FROM SHIP_METHOD
</cfquery>	
<cfif not ship_method.recordcount>
	<cffile action="read" file="#attributes.upload_folder#xml#dir_seperator#ship_method.xml" variable="xmldosyam" charset = "UTF-8">
	<cfset dosyam = XmlParse(xmldosyam)>
	<cfset xml_dizi = dosyam.SHIP_METHOD.XmlChildren>
	<cfset d_boyut = ArrayLen(xml_dizi)>
	<cfloop index="i" from = "1" to = "#d_boyut#">
		<cfquery name="ADD_SHIP_METHOD" datasource="#DSN#">
			INSERT INTO
				SHIP_METHOD
			(
				  
			  SHIP_METHOD
			)
			VALUES
			(
				#sql_unicode()#'#dosyam.SHIP_METHOD.SHIPMETHOD[i].SHIP_METHOD_VALUE.XmlText#'
			)
		</cfquery>
	</cfloop>
</cfif>
 
<!---- SETUP_PAGE_TYPES tablosu Sayfa Tipleri ---->
<cfquery name="GET_PAGE_TYPES" datasource="#DSN#">
	SELECT PAGE_TYPE_ID FROM SETUP_PAGE_TYPES
</cfquery>	
<cfif not get_page_types.recordcount>
	<cffile action="read" file="#attributes.upload_folder#xml#dir_seperator#setup_page_types.xml" variable="xmldosyam" charset = "UTF-8">
	<cfset dosyam = XmlParse(xmldosyam)>
	<cfset xml_dizi = dosyam.TYPES.XmlChildren>
	<cfset d_boyut = ArrayLen(xml_dizi)>
	<cfloop index="i" from = "1" to = "#d_boyut#">
		<cfquery name="ADD_TYPE" datasource="#DSN#">
			INSERT INTO
				SETUP_PAGE_TYPES
			(
				PAGE_TYPE_ID,
				PAGE_TYPE
			)
			VALUES
			(
				 #dosyam.TYPES.TYPE[i].PAGE_TYPE_ID.XmlText#,
				#sql_unicode()#'#dosyam.TYPES.TYPE[i].PAGE_TYPE.XmlText#'					 
			)
		</cfquery>
	</cfloop>
</cfif>

<!--- SETUP_COST_TYPE tablosu Maliyet Tipleri --->
<cfquery name="CHECK" datasource="#DSN#">
	SELECT COST_TYPE_ID FROM SETUP_COST_TYPE
</cfquery>
<cfif not check.recordcount>
	<cffile action="read" file="#attributes.upload_folder#xml#dir_seperator#setup_cost_type.xml" variable="xmldosyam" charset = "UTF-8">
	<cfset dosyam = XmlParse(xmldosyam)>
	<cfset xml_dizi = dosyam.SETUP_COST_TYPE.XmlChildren>
	<cfset d_boyut = ArrayLen(xml_dizi)>
	<cfloop index="i" from = "1" to = "#d_boyut#">
		<cfquery name="ADD_SETUP_COST_TYPE" datasource="#DSN#">
			INSERT INTO
				SETUP_COST_TYPE
			(
				COST_TYPE_NAME,
				COST_TYPE_DETAIL
			)
			VALUES
			(
				 #sql_unicode()#'#dosyam.SETUP_COST_TYPE.COST_TYPE[i].COST_TYPE_NAME.XmlText#',
				 #sql_unicode()#'#dosyam.SETUP_COST_TYPE.COST_TYPE[i].COST_TYPE_DETAIL.XmlText#'
			)
		</cfquery>
	</cfloop>
</cfif>
<!--- SETUP_COST_TYPE tablosu Maliyet Tipleri --->
<cfquery name="CHECK" datasource="#DSN#">
	SELECT RESERVATION_ID FROM SETUP_RESERVATION
</cfquery>
<cfif not check.recordcount>
	<cffile action="read" file="#attributes.upload_folder#xml#dir_seperator#reservation_status.xml" variable="xmldosyam" charset = "UTF-8">
	<cfset dosyam = XmlParse(xmldosyam)>
	<cfset xml_dizi = dosyam.RESERVATIONS.XmlChildren>
	<cfset d_boyut = ArrayLen(xml_dizi)>
	<cfloop index="i" from = "1" to = "#d_boyut#">
		<cfquery name="ADD_SETUP_RESERVATION" datasource="#DSN#">
			INSERT INTO
				SETUP_RESERVATION
			(
				RESERVATION,
				COLOR
			)
			VALUES
			(
				 #sql_unicode()#'#dosyam.RESERVATIONS.RESERVATION[i].RESERVATION_NAME.XmlText#',
				 #sql_unicode()#'#dosyam.RESERVATIONS.RESERVATION[i].RESERVATION_COLOR.XmlText#'
			)
		</cfquery>
	</cfloop>
</cfif>
<!--- SETUP_ACC_TYPE tablosu cari hesap Tipleri --->
<cfquery name="CHECK" datasource="#DSN#">
	SELECT ACC_TYPE_ID FROM SETUP_ACC_TYPE
</cfquery>
<cfif not check.recordcount>
	<cffile action="read" file="#attributes.upload_folder#xml#dir_seperator#setup_acc_types.xml" variable="xmldosyam" charset = "UTF-8">
	<cfset dosyam = XmlParse(xmldosyam)>
	<cfset xml_dizi = dosyam.SETUP_ACC_TYPES.XmlChildren>
	<cfset d_boyut = ArrayLen(xml_dizi)>
	<cfloop index="i" from = "1" to = "#d_boyut#">
		<cfquery name="ADD_SETUP_ACC_TYPE" datasource="#DSN#">
			SET IDENTITY_INSERT SETUP_ACC_TYPE ON
			INSERT INTO
				SETUP_ACC_TYPE
			(
				ACC_TYPE_ID,
				ACC_TYPE_NAME
			)
			VALUES
			(
				 #sql_unicode()#'#dosyam.SETUP_ACC_TYPES.SET[i].ACC_TYPE_ID.XmlText#',
				 #sql_unicode()#'#dosyam.SETUP_ACC_TYPES.SET[i].ACC_TYPE.XmlText#'
			)
			SET IDENTITY_INSERT SETUP_ACC_TYPE OFF
		</cfquery>
	</cfloop>
</cfif>
