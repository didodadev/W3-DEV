<!--- 
	Amaç            : Bir fonksiyonla parametre gondererek şehir yada ilçelere ulaşılabilmesi.
	parametre adi   : 
	ayirma isareti  : ,
	kac parametreli : 2
	1. parametre    : id_residence 
	2.parametre     :Type 
					: 1 yada 2 olmak üzere iki farklı değer alabilir. 
	(
		type=1 ==> tip degerine göre şehir isimlerini çeker;
		type=2 ==> tip değerine göre ilçe isimlerini çeker;
		type=3 ==> tip değerine göre mahalle isimlerini çeker;
	)
	kullanim        : get_residence(type,id_residence)
	Yazan           : Cengiz Hark
	Tarih           : 21.05.2008
 --->
<cffunction name="get_residence" access="public" returnType="query" output="no">
	<cfargument name="type" required="yes" type="string">
	<cfargument name="id_residence" required="yes" type="string">
	<cfargument name="zone_control" required="no" type="string" default="">
	<cfif isDefined("session.ep")>
		<cfset language = session.ep.language>
	<cfelseif isDefined("session.pp")>
		<cfset language = session.pp.language>
	<cfelseif isDefined("session.ww")>
		<cfset language = session.ww.language>
	<cfelseif isDefined("session.qq")>
		<cfset language = session.qq.language>
	</cfif>
	<cfquery name="_get_residence_" datasource="#dsn#">
		<cfif arguments.type eq 1>
			SELECT 
				SC.CITY_ID,
				SU.COUNTRY_PHONE_CODE PHONE_CODE,
				CASE
					WHEN LEN(ITEM) > 0 THEN SLI.ITEM
					ELSE SC.CITY_NAME
				END AS CITY_NAME
			FROM 
				SETUP_CITY SC LEFT JOIN SETUP_LANGUAGE_INFO SLI ON SLI.UNIQUE_COLUMN_ID = SC.CITY_ID
				AND SLI.COLUMN_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="CITY_NAME">
				AND SLI.TABLE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="SETUP_CITY">
				AND SLI.LANGUAGE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#language#">,
				SETUP_COUNTRY SU
			WHERE 
				SC.COUNTRY_ID = SU.COUNTRY_ID AND
				SC.COUNTRY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.id_residence#">	
				<cfif len(arguments.zone_control) and arguments.zone_control neq 0>
					AND SC.CITY_ID IN (#arguments.zone_control#)
				</cfif>
			ORDER BY
				CITY_NAME
		<cfelseif arguments.type eq 2>	
			SELECT 
				SETUP_COUNTY.COUNTY_ID,
				SETUP_CITY.PHONE_CODE,
				CAST(ISNULL(SETUP_COUNTRY.COUNTRY_PHONE_CODE,'') + '' + SETUP_CITY.PHONE_CODE AS NVARCHAR(8)) AS PHONE_CODE_LONG,
				CASE
					WHEN LEN(ITEM) > 0 THEN SLI.ITEM
					ELSE SETUP_COUNTY.COUNTY_NAME
				END AS COUNTY_NAME
			FROM 
				SETUP_CITY,
				SETUP_COUNTRY,
				SETUP_COUNTY LEFT JOIN SETUP_LANGUAGE_INFO SLI ON SLI.UNIQUE_COLUMN_ID = SETUP_COUNTY.COUNTY_ID
				AND SLI.COLUMN_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="COUNTY_NAME">
				AND SLI.TABLE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="SETUP_COUNTY">
				AND SLI.LANGUAGE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#language#">
			WHERE 
				SETUP_CITY.COUNTRY_ID = SETUP_COUNTRY.COUNTRY_ID AND
				SETUP_COUNTY.CITY = SETUP_CITY.CITY_ID AND
				SETUP_COUNTY.CITY = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.id_residence#">
            ORDER BY
             	SETUP_COUNTY.COUNTY_NAME
		<cfelseif arguments.type eq 3>	
			SELECT 
				SETUP_DISTRICT.DISTRICT_ID,
				SETUP_DISTRICT.DISTRICT_NAME,
				SETUP_DISTRICT.POST_CODE,
				SETUP_DISTRICT.PART_NAME
			FROM 
				SETUP_COUNTY,
				SETUP_DISTRICT 
			WHERE 
				SETUP_COUNTY.COUNTY_ID = SETUP_DISTRICT.COUNTY_ID AND
				SETUP_DISTRICT.COUNTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.id_residence#">
			ORDER BY 
				DISTRICT_NAME
		<cfelseif arguments.type eq 4>
			SELECT 
				SIC.IMS_CODE_ID,
				SIC.IMS_CODE AS IMS_CODE,
				SIC.IMS_CODE_NAME AS IMS_CODE_NAME,
				SD.POST_CODE,
				SD.PART_NAME 
			FROM SETUP_DISTRICT SD 
			LEFT JOIN SETUP_IMS_CODE SIC 
			ON SIC.IMS_CODE_ID = SD.IMS_CODE_ID 
			WHERE SD.DISTRICT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.id_residence#">
		</cfif>
	</cfquery>
	<cfif arguments.type eq 2 and _get_residence_.recordcount eq 0>
		<cfquery name="_get_residence_" datasource="#dsn#">
			SELECT 
				'' COUNTY_ID,
				'' COUNTY_NAME,
				PHONE_CODE,
				PHONE_CODE AS PHONE_CODE_LONG
			FROM
				SETUP_CITY
			WHERE
				CITY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.id_residence#">
		</cfquery>
	</cfif>
	<cfreturn _get_residence_>
</cffunction>
