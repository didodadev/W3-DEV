<!---Select ifadeleri düzenlendi,getcirty functionu sadece my_consumer_adress_detail sayfası içinde çagrılıyor ve gerekli alan sadece CITY_NAME--->
<cfcomponent>
	<cffunction name="addCityFnc" access="public" returntype="any">
		<cfargument name="city_name" type="string" required="no">
		<cfargument name="country_id" type="numeric" required="no" default="0">
		<cfargument name="phone_code" type="string" required="no" default="">
		<cfargument name="plate_code" type="string" required="no" default="">
		<cfargument name="priority" type="string" required="no" default="">
		
		<cfquery name="Add_City" datasource="#this.dsn#">
			INSERT INTO
				SETUP_CITY
			(
				COUNTRY_ID,
				CITY_NAME,
				PHONE_CODE,
				PLATE_CODE,
				PRIORITY,
				RECORD_IP,
				RECORD_DATE,
				RECORD_EMP
			)
			VALUES
			(
				<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.country_id#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.city_name#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.phone_code#">,
				<cfif len(arguments.plate_code)><cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.plate_code)#"><cfelse>NULL</cfif>,
				<cfif len(arguments.priority)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.priority#"><cfelse>NULL</cfif>,
				'#cgi.remote_addr#',
				#now()#,
				#session.ep.userid#
			)
		</cfquery>
	</cffunction>

	<cffunction name="updCityFnc" access="public" returntype="any">
		<cfargument name="city_id" type="numeric" required="no" default="0">
		<cfargument name="city_name" type="string" required="no">
		<cfargument name="country_id" type="numeric" required="no" default="0">
		<cfargument name="phone_code" type="string" required="no" default="">
		<cfargument name="plate_code" type="string" required="no" default="">
		<cfargument name="priority" type="string" required="no" default="">
		
		<cfquery name="Upd_City" datasource="#this.dsn#">
			UPDATE 
				SETUP_CITY
			SET 
				COUNTRY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.country_id#">,
				CITY_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.city_name#">,
				PHONE_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.phone_code#">,
				PLATE_CODE = <cfif len(arguments.plate_code)><cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.plate_code)#"><cfelse>NULL</cfif>,
				PRIORITY = <cfif len(arguments.priority)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.priority#"><cfelse>NULL</cfif>,
				UPDATE_IP = '#cgi.remote_addr#',
				UPDATE_DATE = #now()#,
				UPDATE_EMP = #session.ep.userid#	 
			WHERE 
				CITY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.city_id#">
		</cfquery>
		<cfreturn true>
	</cffunction>
	
	<cffunction name="getCity" access="public" returntype="query">
		<cfargument name="city_id" type="numeric" required="yes" default="0">
		<cfargument name="sortdir" type="string" required="no" default="ASC">
		<cfargument name="sortfield" type="string" required="no" default="CITY_NAME">
		
		<cfquery name="Get_City" datasource="#this.dsn#">
			SELECT 
				CITY_NAME
			FROM 
				SETUP_CITY
				<cfif arguments.city_id gt 0>
					WHERE
						CITY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.city_id#">
				</cfif>
			ORDER BY 
				#arguments.sortfield# #arguments.sortdir# 
		</cfquery>
		<cfreturn Get_City>
	</cffunction>
    <cffunction name="GET_CITY_COUNTY_1_FNC" returntype="query">
        
    	<cfargument name="special_state" default="">
        <cfargument name="keyword" default="">
        <cfargument name="country" default="">
        <cfargument name="xml_dsp_special_state" default="">
    	<cfquery name="GET_CITY_COUNTY_1" datasource="#this.dsn#">
            SELECT 
                SETUP_CITY.CITY_NAME AS CITY_NAME,
                SETUP_CITY.CITY_ID AS CITY_ID,
                SETUP_COUNTY.SPECIAL_STATE_CAT_ID,
                SETUP_COUNTY.COUNTY_NAME AS COUNTY_NAME,
                SETUP_COUNTY.COUNTY_ID AS COUNTY_ID,
                SETUP_COUNTY.CITY AS CITY,
                SETUP_CITY.PHONE_CODE AS PHONE_CODE,
                SETUP_CITY.PLATE_CODE AS PLATE_CODE,
                SETUP_COUNTRY.COUNTRY_NAME,
                SETUP_COUNTRY.COUNTRY_PHONE_CODE
            FROM 
                SETUP_COUNTY,
                SETUP_CITY,
                SETUP_COUNTRY
            WHERE 
                SETUP_COUNTRY.COUNTRY_ID = SETUP_CITY.COUNTRY_ID AND
                SETUP_CITY.CITY_ID = SETUP_COUNTY.CITY 
                <cfif xml_dsp_special_state and len(special_state)>
                AND SETUP_COUNTY.SPECIAL_STATE_CAT_ID = #special_state#
                AND COUNTY_ID IS NOT NULL
                AND COUNTY_ID <> ''
                </cfif>
            <cfif len(keyword)><!--- Bu kontrol buradan gelen queryde yapılmalı query of queryde kontrol edildiğinde büyük küçük harf duyarlılığı kayboluyor  20060321 senay--->
                AND 
                (
                    SETUP_CITY.CITY_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#keyword#%"> OR
                    SETUP_COUNTY.COUNTY_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#keyword#%">
                )
            </cfif>
            <cfif isDefined('country') and len(country)>
                AND SETUP_COUNTRY.COUNTRY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#country#">
            </cfif>
        </cfquery>
        <cfreturn GET_CITY_COUNTY_1>
    </cffunction>
    
<!---  Ilcesi olmayan illeri getirmek icin eklendi --->
    <cffunction name="GET_CITY_COUNTY_2_FNC" returntype="query">
        <cfargument name="special_state" default="">
        <cfargument name="keyword" default="">
        <cfargument name="xml_dsp_special_state" default="">
    	<cfquery name="GET_CITY_COUNTY_2" datasource="#this.dsn#">
            SELECT 
                SETUP_CITY.CITY_NAME,
                SETUP_CITY.CITY_ID,
                0 AS SPECIAL_STATE_CAT_ID,
                '' AS COUNTY_NAME,
                0 AS COUNTY_ID,
                0 AS CITY,
                SETUP_CITY.PHONE_CODE AS PHONE_CODE,
                SETUP_CITY.PLATE_CODE AS PLATE_CODE,
                SETUP_COUNTRY.COUNTRY_NAME,
                SETUP_COUNTRY.COUNTRY_PHONE_CODE
            FROM 
                SETUP_CITY,
                SETUP_COUNTRY
            WHERE 
                SETUP_COUNTRY.COUNTRY_ID = SETUP_CITY.COUNTRY_ID AND
                SETUP_CITY.CITY_ID NOT IN ( SELECT DISTINCT CITY FROM SETUP_COUNTY WHERE CITY IS NOT NULL )
            <cfif len(keyword)>  <!--- Bu kontrol buradan gelen queryde yapılmalı query of queryde kontrol edildiğinde büyük küçük harf duyarlılığı kayboluyor  20060321 senay--->
                AND (SETUP_CITY.CITY_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#keyword#%">)
            </cfif>
            <cfif isDefined('country') and len(country)>
                AND SETUP_COUNTRY.COUNTRY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#country#">
            </cfif>
        </cfquery>
        <cfreturn GET_CITY_COUNTY_2>
    </cffunction>
    
    <cffunction name="GET_CITY_COUNTY_FNC" returntype="query">
    	<cfquery name="GET_CITY_COUNTY_" dbtype="query">
            SELECT * FROM GET_CITY_COUNTY_1 UNION ALL SELECT * FROM GET_CITY_COUNTY_2 ORDER BY CITY_NAME,COUNTY_NAME 
        </cfquery>
        <cfreturn GET_CITY_COUNTY_>
    </cffunction>
    
    <cffunction name="GET_SPECIAL_STATE_FNC" returntype="query">
        <cfquery name="GET_SPECIAL_STATE" datasource="#this.dsn#">
            SELECT
                SPECIAL_STATE_CAT_ID,
                SPECIAL_STATE_CAT 
            FROM 
                SETUP_SPECIAL_STATE_CAT 
            ORDER BY 
                SPECIAL_STATE_CAT
        </cfquery>
        <cfreturn GET_SPECIAL_STATE>
    </cffunction>

</cfcomponent>
