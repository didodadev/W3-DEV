<cfcomponent rest="true" restpath="/Utils">
	<cfset dsn = "workcube_ussas">
		<!--- Ülkeler --->
	<cffunction name="ListSetupCountry"
		access="remote"
		httpmethod="GET"
		restpath="SetupCountry"
		returntype="string"
		produces="application/json">
		<cfquery name="GetCountry" datasource="#dsn#">
			SELECT COUNTRY_ID, COUNTRY_NAME FROM SETUP_COUNTRY ORDER BY COUNTRY_NAME
		</cfquery>
		<cfreturn Replace(serializeJSON(GetCountry),'//','')>
	</cffunction>
	<!--- Sehirler --->
	<cffunction name="ListSetupCity"
		access="remote"
		httpmethod="GET"
		restpath="SetupCity"
		returntype="string"
		produces="application/json">
		<cfquery name="GetCity" datasource="#dsn#">
			SELECT CITY_ID, CITY_NAME FROM SETUP_CITY ORDER BY CITY_NAME
		</cfquery>
		<cfreturn Replace(serializeJSON(GetCity),'//','')>
	</cffunction>
	<!--- Ilçeler --->
	<cffunction name="ListSetupCounty"
		access="remote"
		httpmethod="GET"
		restpath="SetupCounty"
		returntype="string"
		produces="application/json">
		<cfquery name="GetCounty" datasource="#dsn#">
			SELECT COUNTY_ID, COUNTY_NAME FROM SETUP_COUNTY ORDER BY COUNTY_NAME
		</cfquery>
		<cfreturn Replace(serializeJSON(GetCounty),'//','')>
	</cffunction>
	<!--- Egitim Durumu --->
	<cffunction name="ListSetupEducationLevel"
		access="remote"
		httpmethod="GET"
		restpath="SetupEducationLevel"
		returntype="string"
		produces="application/json">
		<cfquery name="GetEducationLevel" datasource="#dsn#">
			SELECT EDU_LEVEL_ID, EDUCATION_NAME FROM SETUP_EDUCATION_LEVEL ORDER BY EDUCATION_NAME
		</cfquery>
		<cfreturn Replace(serializeJSON(GetEducationLevel),'//','')>
	</cffunction>
	<!--- Üniversite --->
	<cffunction name="ListSetupUniversity"
		access="remote"
		httpmethod="GET"
		restpath="SetupUniversity"
		returntype="string"
		produces="application/json">
		<cfquery name="GetUniversity" datasource="#dsn#">
			SELECT SCHOOL_ID, SCHOOL_NAME FROM SETUP_SCHOOL ORDER BY SCHOOL_NAME
		</cfquery>
		<cfreturn Replace(serializeJSON(GetUniversity),'//','')>
	</cffunction>
	<!--- Üniversite Bölümleri --->
	<cffunction name="ListSetupUniversityPart"
		access="remote"
		httpmethod="GET"
		restpath="SetupUniversityPart"
		returntype="string"
		produces="application/json">
		<cfquery name="GetUniversityPart" datasource="#dsn#">
			SELECT PART_ID, PART_NAME FROM SETUP_SCHOOL_PART ORDER BY PART_NAME
		</cfquery>
		<cfreturn Replace(serializeJSON(GetUniversityPart),'//','')>
	</cffunction>
	<!--- Lise Bölümleri --->
	<cffunction name="ListSetupHighSchoolPart"
		access="remote"
		httpmethod="GET"
		restpath="SetupHighSchoolPart"
		returntype="string"
		produces="application/json">
		<cfquery name="GetHighSchoolPart" datasource="#dsn#">
			SELECT HIGH_PART_ID, HIGH_PART_NAME FROM SETUP_HIGH_SCHOOL_PART ORDER BY HIGH_PART_NAME
		</cfquery>
		<cfreturn Replace(serializeJSON(GetHighSchoolPart),'//','')>
	</cffunction>
	<!--- Diller --->
	<cffunction name="ListSetupLanguage"
		access="remote"
		httpmethod="GET"
		restpath="SetupLanguage"
		returntype="string"
		produces="application/json">
		<cfquery name="GetSetupLanguage" datasource="#dsn#">
			SELECT LANGUAGE_ID, LANGUAGE_SET FROM SETUP_LANGUAGES ORDER BY LANGUAGE_SET
		</cfquery>
		<cfreturn Replace(serializeJSON(GetSetupLanguage),'//','')>
	</cffunction>
	<!--- Meslekler --->
	<cffunction name="ListSetupVocationType"
		access="remote"
		httpmethod="GET"
		restpath="SetupVocationType"
		returntype="string"
		produces="application/json">
		<cfquery name="GetVocationType" datasource="#dsn#">
			SELECT VOCATION_TYPE_ID, VOCATION_TYPE FROM SETUP_VOCATION_TYPE ORDER BY VOCATION_TYPE
		</cfquery>
		<cfreturn Replace(serializeJSON(GetVocationType),'//','')>
	</cffunction>
</cfcomponent>