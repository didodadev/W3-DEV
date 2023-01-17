<cfset wroController = createObject("component","V16/settings/cfc/wroControl")>

<!--- SETUP_LANGUAGE upgrade --->
<!--- <cfif isDefined("attributes.lang") and attributes.lang eq 1>
    <cfset responseData = wroController.getWoLang(typeList:"getNewLangs")>
    <cfif responseData.STATUS>
        <cfif arraylen(responseData.DATA) gt 0>
            <cfloop index="i" from="1" to="#arraylen(responseData.DATA)#"> 
                <cfquery name="add_r" datasource="#dsn#">
                    IF NOT EXISTS(SELECT LANGUAGE_ID FROM SETUP_LANGUAGE where LANGUAGE_SET = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["LANGUAGE_SET"]#">)
                    BEGIN
                    INSERT INTO SETUP_LANGUAGE
                        (
                            LANGUAGE_ID,
                            LANGUAGE_SET,
                            LANGUAGE_SHORT,
                            IS_ACTIVE,
                            RECORD_DATE,
                            RECORD_EMP,
                            RECORD_IP
                        ) 
                        VALUES(
                            (SELECT MAX(LANGUAGE_ID) FROM SETUP_LANGUAGE) +1,
                            <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["LANGUAGE_SET"]#">,
                            <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["LANGUAGE_SHORT"]#">,
                            <cfif responseData.DATA[i]["IS_ACTIVE"] is 'NO'>0<cfelse>1</cfif>,
                            <cfqueryparam cfsqltype="cf_sql_timestamp" value="#NOW()#">,
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                            <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#cgi.remote_addr#">
                        )
                    END;
                </cfquery>
            </cfloop>
        </cfif>
    </cfif>
</cfif> --->

<!--- SETUP_LANGUAGE_TR upgrade --->
<cfif isdefined("attributes.Dictionary") and attributes.Dictionary eq 1>
    <!--- Yeni eklenen dillerin sisteme alınması --->
    <cfset responseData = wroController.getWoLang(typeList:"getNewLanguages",dateRangeValue:attributes.date_range_value)>
    <cfif responseData.STATUS>
        <cfif arraylen(responseData.DATA) gt 0>
            <cfloop index="i" from="1" to="#arraylen(responseData.DATA)#"> 
                <cfquery name="add_r" datasource="#dsn#">
                    IF NOT EXISTS(SELECT DICTIONARY_ID FROM SETUP_LANGUAGE_TR where DICTIONARY_ID = #responseData.DATA[i]["DICTIONARY_ID"]# )
                        BEGIN
                            INSERT INTO SETUP_LANGUAGE_TR
                            (
                                DICTIONARY_ID,
                                ITEM_ID,
                                MODULE_ID,
                                ITEM,
                                ITEM_TR,
                                ITEM_ARB,
                                ITEM_DE,
                                ITEM_ENG,
                                ITEM_ES,
                                ITEM_RUS,
                                ITEM_UKR,
                                ITEM_FR,
                                ITEM_IT,
                                IS_SPECIAL,
                                RECORD_DATE,
                                RECORD_EMP,
                                RECORD_IP
                            )
                            VALUES 
                            (
                                <cfqueryparam cfsqltype="cf_sql_integer" value="#responseData.DATA[i]["DICTIONARY_ID"]#">,
                                <cfqueryparam cfsqltype="cf_sql_integer" value="#responseData.DATA[i]["ITEM_ID"]#">,
                                <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["MODULE_ID"]#">,
                                <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["ITEM"]#">,
                                <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["ITEM_TR"]#">,
                                <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["ITEM_ARB"]#">,
                                <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["ITEM_DE"]#">,
                                <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["ITEM_ENG"]#">,
                                <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["ITEM_ES"]#">,
                                <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["ITEM_RUS"]#">,
                                <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["ITEM_UKR"]#">,
                                <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["ITEM_FR"]#">,
                                <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["ITEM_IT"]#">,
                                <cfif responseData.DATA[i]["IS_SPECIAL"] is 'NO'>0<cfelse>1</cfif>,
                                <cfqueryparam cfsqltype="cf_sql_timestamp" value="#NOW()#">,
                                <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                                <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#cgi.remote_addr#">
                            )
                        END
                    ELSE
                        BEGIN
                            UPDATE SETUP_LANGUAGE_TR
                            SET
                                ITEM_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#responseData.DATA[i]["ITEM_ID"]#">,
                                MODULE_ID = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["MODULE_ID"]#">,
                                ITEM = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["ITEM"]#">,
                                ITEM_TR = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["ITEM_TR"]#">,
                                ITEM_ARB = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["ITEM_ARB"]#">,
                                ITEM_DE = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["ITEM_DE"]#">,
                                ITEM_ENG = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["ITEM_ENG"]#">,
                                ITEM_ES = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["ITEM_ES"]#">,
                                ITEM_RUS = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["ITEM_RUS"]#">,
                                ITEM_UKR = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["ITEM_UKR"]#">,
                                ITEM_FR = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["ITEM_FR"]#">,
                                ITEM_IT = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["ITEM_IT"]#">,
                                IS_SPECIAL = <cfif responseData.DATA[i]["IS_SPECIAL"] is 'NO'>0<cfelse>1</cfif>,
                                UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#NOW()#">,
                                UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                                UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#cgi.remote_addr#">
                            WHERE 
                                DICTIONARY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#responseData.DATA[i]["DICTIONARY_ID"]#">
                                AND
                                (IS_SPECIAL = 0  or IS_SPECIAL IS NULL )
                        END
                </cfquery>
            </cfloop>
        </cfif>
    </cfif>
    <!--- End --->

    <!--- Güncellenen dillerin sisteme alınması --->
    <cfset responseData = wroController.getWoLang(typeList:"getUpdatedLanguages",dateRangeValue:attributes.date_range_value)>
    <cfif responseData.STATUS>
        <cfif arraylen(responseData.DATA) gt 0>
            <cfloop index="i" from="1" to="#arraylen(responseData.DATA)#">
                <cfquery name="add_r" datasource="#dsn#">
                    UPDATE SETUP_LANGUAGE_TR
                    SET
                        ITEM_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#responseData.DATA[i]["ITEM_ID"]#">,
                        MODULE_ID = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["MODULE_ID"]#">,
                        ITEM = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["ITEM"]#">,
                        ITEM_TR = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["ITEM_TR"]#">,
                        ITEM_ENG = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["ITEM_ENG"]#">,
                        ITEM_ES = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["ITEM_ES"]#">,
                        ITEM_RUS = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["ITEM_RUS"]#">,
                        ITEM_UKR = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["ITEM_UKR"]#">,
                        ITEM_FR = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["ITEM_FR"]#">,
                        ITEM_IT = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["ITEM_IT"]#">,
                        IS_SPECIAL = <cfif responseData.DATA[i]["IS_SPECIAL"] is 'NO'>0<cfelse>1</cfif>,
                        UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#NOW()#">,
                        UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                        UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#cgi.remote_addr#">
                    WHERE 
                        DICTIONARY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#responseData.DATA[i]["DICTIONARY_ID"]#">
                        AND 
                        (IS_SPECIAL = 0  or IS_SPECIAL IS NULL )
                </cfquery>
            </cfloop>
        </cfif>
    </cfif>
    <!--- End --->
</cfif>

<!--- WRK_SOLUTION upgrade --->
<cfif isDefined("attributes.Solutions") and attributes.Solutions eq 1>
    <!--- Yeni eklenen solution'ların eklenmesi --->
    <cfset responseData = wroController.getWoLang(typeList:"getNewSolution",dateRangeValue:attributes.date_range_value_wo)>
    <cfif responseData.STATUS>
        <cfif arraylen(responseData.DATA) gt 0>
            <cfloop index="i" from="1" to="#arraylen(responseData.DATA)#">
                <cfquery name="add_r" datasource="#dsn#">
                    IF NOT EXISTS( SELECT SOLUTION FROM WRK_SOLUTION WHERE SOLUTION = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["SOLUTION"]#"> )
                        BEGIN
                            INSERT INTO WRK_SOLUTION
                            (
                                SOLUTION,
                                SOLUTION_DICTIONARY_ID,
                                SOLUTION_TYPE,
                                IS_MENU,
                                RANK_NUMBER,
                                SOLUTION_LANG_ID,
                                THEME_PATH,
                                UP,
                                RECORD_DATE,
                                RECORD_EMP,
                                RECORD_IP,
                                ICON
                            )
                            VALUES
                            (
                                <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["SOLUTION"]#" null='#iif(len(responseData.DATA[i]["SOLUTION"]),DE("no"),DE("yes"))#'>,
                                <cfqueryparam cfsqltype="cf_sql_integer" value="#responseData.DATA[i]["SOLUTION_DICTIONARY_ID"]#" null='#iif(len(responseData.DATA[i]["SOLUTION_DICTIONARY_ID"]),DE("no"),DE("yes"))#'>,
                                <cfqueryparam cfsqltype="cf_sql_integer" value="#responseData.DATA[i]["SOLUTION_TYPE"]#" null='#iif(len(responseData.DATA[i]["SOLUTION_TYPE"]),DE("no"),DE("yes"))#'>,
                                <cfqueryparam cfsqltype="cf_sql_bit" value="#responseData.DATA[i]["IS_MENU"]#" null='#iif(len(responseData.DATA[i]["IS_MENU"]),DE("no"),DE("yes"))#'>,
                                <cfqueryparam cfsqltype="cf_sql_integer" value="#responseData.DATA[i]["RANK_NUMBER"]#" null='#iif(len(responseData.DATA[i]["RANK_NUMBER"]),DE("no"),DE("yes"))#'>,
                                <cfqueryparam cfsqltype="cf_sql_integer" value="#responseData.DATA[i]["SOLUTION_LANG_ID"]#" null='#iif(len(responseData.DATA[i]["SOLUTION_LANG_ID"]),DE("no"),DE("yes"))#'>,
                                <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["THEME_PATH"]#" null='#iif(len(responseData.DATA[i]["THEME_PATH"]),DE("no"),DE("yes"))#'>,
                                <cfqueryparam cfsqltype="cf_sql_integer" value="#responseData.DATA[i]["UP"]#" null='#iif(len(responseData.DATA[i]["UP"]),DE("no"),DE("yes"))#'>,
                                <cfqueryparam cfsqltype="cf_sql_timestamp" value="#NOW()#">,
                                <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                                <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#cgi.remote_addr#">,
                                <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["ICON"]#" null='#iif(len(responseData.DATA[i]["ICON"]),DE("no"),DE("yes"))#'>
                            )
                        END
                    ELSE
                        BEGIN
                            UPDATE WRK_SOLUTION
                            SET  
                                SOLUTION = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["SOLUTION"]#" null='#iif(len(responseData.DATA[i]["SOLUTION"]),DE("no"),DE("yes"))#'>,
                                SOLUTION_DICTIONARY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#responseData.DATA[i]["SOLUTION_DICTIONARY_ID"]#" null='#iif(len(responseData.DATA[i]["SOLUTION_DICTIONARY_ID"]),DE("no"),DE("yes"))#'>,
                                SOLUTION_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#responseData.DATA[i]["SOLUTION_TYPE"]#" null='#iif(len(responseData.DATA[i]["SOLUTION_TYPE"]),DE("no"),DE("yes"))#'>,
                                IS_MENU = <cfqueryparam cfsqltype="cf_sql_bit" value="#responseData.DATA[i]["IS_MENU"]#" null='#iif(len(responseData.DATA[i]["IS_MENU"]),DE("no"),DE("yes"))#'>,
                                RANK_NUMBER = <cfqueryparam cfsqltype="cf_sql_integer" value="#responseData.DATA[i]["RANK_NUMBER"]#" null='#iif(len(responseData.DATA[i]["RANK_NUMBER"]),DE("no"),DE("yes"))#'>,
                                SOLUTION_LANG_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#responseData.DATA[i]["SOLUTION_LANG_ID"]#" null='#iif(len(responseData.DATA[i]["SOLUTION_LANG_ID"]),DE("no"),DE("yes"))#'>,
                                THEME_PATH = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["THEME_PATH"]#" null='#iif(len(responseData.DATA[i]["THEME_PATH"]),DE("no"),DE("yes"))#'>,
                                UP = <cfqueryparam cfsqltype="cf_sql_integer" value="#responseData.DATA[i]["UP"]#" null='#iif(len(responseData.DATA[i]["UP"]),DE("no"),DE("yes"))#'>,
                                UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#NOW()#">,
                                UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                                UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#cgi.remote_addr#">,
                                ICON = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["ICON"]#" null='#iif(len(responseData.DATA[i]["ICON"]),DE("no"),DE("yes"))#'>
                            WHERE
                                SOLUTION = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["SOLUTION"]#">
                        END
                </cfquery>
            </cfloop>
        </cfif>
    </cfif>

    <!--- Güncellenen solution'ların güncellenmesi --->
    <cfset responseData = wroController.getWoLang(typeList:"getUpdatedSolution",dateRangeValue:attributes.date_range_value_wo)>
    <cfif responseData.STATUS>
        <cfif arraylen(responseData.DATA) gt 0>
            <cfloop index="i" from="1" to="#arraylen(responseData.DATA)#"> 
                <cfquery name="add_r" datasource="#dsn#">
                    UPDATE WRK_SOLUTION
                    SET  
                        SOLUTION = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["SOLUTION"]#" null='#iif(len(responseData.DATA[i]["SOLUTION"]),DE("no"),DE("yes"))#'>,
                        SOLUTION_DICTIONARY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#responseData.DATA[i]["SOLUTION_DICTIONARY_ID"]#" null='#iif(len(responseData.DATA[i]["SOLUTION_DICTIONARY_ID"]),DE("no"),DE("yes"))#'>,
                        SOLUTION_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#responseData.DATA[i]["SOLUTION_TYPE"]#" null='#iif(len(responseData.DATA[i]["SOLUTION_TYPE"]),DE("no"),DE("yes"))#'>,
                        IS_MENU = <cfqueryparam cfsqltype="cf_sql_bit" value="#responseData.DATA[i]["IS_MENU"]#" null='#iif(len(responseData.DATA[i]["IS_MENU"]),DE("no"),DE("yes"))#'>,
                        RANK_NUMBER = <cfqueryparam cfsqltype="cf_sql_integer" value="#responseData.DATA[i]["RANK_NUMBER"]#" null='#iif(len(responseData.DATA[i]["RANK_NUMBER"]),DE("no"),DE("yes"))#'>,
                        SOLUTION_LANG_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#responseData.DATA[i]["SOLUTION_LANG_ID"]#" null='#iif(len(responseData.DATA[i]["SOLUTION_LANG_ID"]),DE("no"),DE("yes"))#'>,
                        THEME_PATH = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["THEME_PATH"]#" null='#iif(len(responseData.DATA[i]["THEME_PATH"]),DE("no"),DE("yes"))#'>,
                        UP = <cfqueryparam cfsqltype="cf_sql_integer" value="#responseData.DATA[i]["UP"]#" null='#iif(len(responseData.DATA[i]["UP"]),DE("no"),DE("yes"))#'>,
                        UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#NOW()#">,
                        UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                        UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#cgi.remote_addr#">,
                        ICON = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["ICON"]#" null='#iif(len(responseData.DATA[i]["ICON"]),DE("no"),DE("yes"))#'>
                    WHERE
                        SOLUTION = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["SOLUTION"]#">
                </cfquery>
            </cfloop>
        </cfif>
    </cfif>
</cfif>

<!--- WRK_FAMILY upgrade --->
<cfif isDefined("attributes.Family") and attributes.Family eq 1>
    <!--- Yeni eklenen family'lerin eklenmesi --->
    <cfset responseData = wroController.getWoLang(typeList:"getNewFamily",dateRangeValue:attributes.date_range_value_wo)>
    <cfif responseData.STATUS>
        <cfif arraylen(responseData.DATA) gt 0>
            <cfloop index="i" from="1" to="#arraylen(responseData.DATA)#">
                <cfquery name="add_r" datasource="#dsn#">
                    IF NOT EXISTS( SELECT FAMILY FROM WRK_FAMILY WHERE FAMILY = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["FAMILY"]#"> )
                        BEGIN
                            INSERT INTO WRK_FAMILY
                            (
                                FAMILY,
                                FAMILY_DICTIONARY_ID,
                                FAMILY_TYPE,
                                WRK_SOLUTION_ID,
                                IS_MENU,
                                RANK_NUMBER,
                                THEME_PATH,
                                UP,
                                CU,
                                RECORD_DATE,
                                RECORD_EMP,
                                RECORD_IP,
                                ICON
                            )
                            VALUES 
                            (
                                <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["FAMILY"]#" null='#iif(len(responseData.DATA[i]["FAMILY"]),DE("no"),DE("yes"))#'>,
                                <cfqueryparam cfsqltype="cf_sql_integer" value="#responseData.DATA[i]["FAMILY_DICTIONARY_ID"]#" null='#iif(len(responseData.DATA[i]["FAMILY_DICTIONARY_ID"]),DE("no"),DE("yes"))#'>,
                                <cfqueryparam cfsqltype="cf_sql_integer" value="#responseData.DATA[i]["FAMILY_TYPE"]#" null='#iif(len(responseData.DATA[i]["FAMILY_TYPE"]),DE("no"),DE("yes"))#'>,
                                <cfqueryparam cfsqltype="cf_sql_integer" value="#responseData.DATA[i]["WRK_SOLUTION_ID"]#" null='#iif(len(responseData.DATA[i]["WRK_SOLUTION_ID"]),DE("no"),DE("yes"))#'>,
                                <cfqueryparam cfsqltype="cf_sql_bit" value="#responseData.DATA[i]["IS_MENU"]#" null='#iif(len(responseData.DATA[i]["IS_MENU"]),DE("no"),DE("yes"))#'>,
                                <cfqueryparam cfsqltype="cf_sql_integer" value="#responseData.DATA[i]["RANK_NUMBER"]#" null='#iif(len(responseData.DATA[i]["RANK_NUMBER"]),DE("no"),DE("yes"))#'>,
                                <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["THEME_PATH"]#" null='#iif(len(responseData.DATA[i]["THEME_PATH"]),DE("no"),DE("yes"))#'>,
                                <cfqueryparam cfsqltype="cf_sql_integer" value="#responseData.DATA[i]["UP"]#" null='#iif(len(responseData.DATA[i]["UP"]),DE("no"),DE("yes"))#'>,
                                <cfqueryparam cfsqltype="cf_sql_integer" value="#responseData.DATA[i]["CU"]#" null='#iif(len(responseData.DATA[i]["CU"]),DE("no"),DE("yes"))#'>,
                                <cfqueryparam cfsqltype="cf_sql_timestamp" value="#NOW()#">,
                                <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                                <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#cgi.remote_addr#">,
                                <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["ICON"]#" null='#iif(len(responseData.DATA[i]["ICON"]),DE("no"),DE("yes"))#'>
                            )
                        END
                    ELSE
                        BEGIN
                            UPDATE WRK_FAMILY
                            SET  
                                FAMILY = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["FAMILY"]#" null='#iif(len(responseData.DATA[i]["FAMILY"]),DE("no"),DE("yes"))#'>,
                                FAMILY_DICTIONARY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#responseData.DATA[i]["FAMILY_DICTIONARY_ID"]#" null='#iif(len(responseData.DATA[i]["FAMILY_DICTIONARY_ID"]),DE("no"),DE("yes"))#'>,
                                FAMILY_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#responseData.DATA[i]["FAMILY_TYPE"]#" null='#iif(len(responseData.DATA[i]["FAMILY_TYPE"]),DE("no"),DE("yes"))#'>,
                                WRK_SOLUTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#responseData.DATA[i]["WRK_SOLUTION_ID"]#" null='#iif(len(responseData.DATA[i]["WRK_SOLUTION_ID"]),DE("no"),DE("yes"))#'>,
                                IS_MENU = <cfqueryparam cfsqltype="cf_sql_bit" value="#responseData.DATA[i]["IS_MENU"]#" null='#iif(len(responseData.DATA[i]["IS_MENU"]),DE("no"),DE("yes"))#'>,
                                RANK_NUMBER = <cfqueryparam cfsqltype="cf_sql_integer" value="#responseData.DATA[i]["RANK_NUMBER"]#" null='#iif(len(responseData.DATA[i]["RANK_NUMBER"]),DE("no"),DE("yes"))#'>,
                                THEME_PATH = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["THEME_PATH"]#" null='#iif(len(responseData.DATA[i]["THEME_PATH"]),DE("no"),DE("yes"))#'>,
                                UP = <cfqueryparam cfsqltype="cf_sql_integer" value="#responseData.DATA[i]["UP"]#" null='#iif(len(responseData.DATA[i]["UP"]),DE("no"),DE("yes"))#'>,
                                CU = <cfqueryparam cfsqltype="cf_sql_integer" value="#responseData.DATA[i]["CU"]#" null='#iif(len(responseData.DATA[i]["CU"]),DE("no"),DE("yes"))#'>,
                                UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#NOW()#">,
                                UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                                UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#cgi.remote_addr#">,
                                ICON = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["ICON"]#" null='#iif(len(responseData.DATA[i]["ICON"]),DE("no"),DE("yes"))#'>
                            WHERE
                                FAMILY = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["FAMILY"]#">
                        END
                </cfquery>
            </cfloop>
        </cfif>
    </cfif>

    <!--- Güncellenen family'lerin güncellenmesi --->
    <cfset responseData = wroController.getWoLang(typeList:"getUpdatedFamily",dateRangeValue:attributes.date_range_value_wo)>
    <cfif responseData.STATUS>
        <cfif arraylen(responseData.DATA) gt 0>
            <cfloop index="i" from="1" to="#arraylen(responseData.DATA)#"> 
                <cfquery name="add_r" datasource="#dsn#">
                    UPDATE WRK_FAMILY
                    SET  
                        FAMILY = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["FAMILY"]#" null='#iif(len(responseData.DATA[i]["FAMILY"]),DE("no"),DE("yes"))#'>,
                        FAMILY_DICTIONARY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#responseData.DATA[i]["FAMILY_DICTIONARY_ID"]#" null='#iif(len(responseData.DATA[i]["FAMILY_DICTIONARY_ID"]),DE("no"),DE("yes"))#'>,
                        FAMILY_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#responseData.DATA[i]["FAMILY_TYPE"]#" null='#iif(len(responseData.DATA[i]["FAMILY_TYPE"]),DE("no"),DE("yes"))#'>,
                        WRK_SOLUTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#responseData.DATA[i]["WRK_SOLUTION_ID"]#" null='#iif(len(responseData.DATA[i]["WRK_SOLUTION_ID"]),DE("no"),DE("yes"))#'>,
                        IS_MENU = <cfqueryparam cfsqltype="cf_sql_bit" value="#responseData.DATA[i]["IS_MENU"]#" null='#iif(len(responseData.DATA[i]["IS_MENU"]),DE("no"),DE("yes"))#'>,
                        RANK_NUMBER = <cfqueryparam cfsqltype="cf_sql_integer" value="#responseData.DATA[i]["RANK_NUMBER"]#" null='#iif(len(responseData.DATA[i]["RANK_NUMBER"]),DE("no"),DE("yes"))#'>,
                        THEME_PATH = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["THEME_PATH"]#" null='#iif(len(responseData.DATA[i]["THEME_PATH"]),DE("no"),DE("yes"))#'>,
                        UP = <cfqueryparam cfsqltype="cf_sql_integer" value="#responseData.DATA[i]["UP"]#" null='#iif(len(responseData.DATA[i]["UP"]),DE("no"),DE("yes"))#'>,
                        CU = <cfqueryparam cfsqltype="cf_sql_integer" value="#responseData.DATA[i]["CU"]#" null='#iif(len(responseData.DATA[i]["CU"]),DE("no"),DE("yes"))#'>,
                        UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#NOW()#">,
                        UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                        UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#cgi.remote_addr#">,
                        ICON = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["ICON"]#" null='#iif(len(responseData.DATA[i]["ICON"]),DE("no"),DE("yes"))#'>
                    WHERE
                        FAMILY = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["FAMILY"]#">
                </cfquery>
            </cfloop>
        </cfif>
    </cfif>
</cfif>

<!--- WRK_MODULE upgrade --->
<cfif isDefined("attributes.Module") and attributes.Module eq 1>
    <!--- Yeni eklenen module'lerin eklenmesi --->
    <cfset responseData = wroController.getWoLang(typeList:"getNewModule",dateRangeValue:attributes.date_range_value_wo)>
    <cfif responseData.STATUS>
        <cfif arraylen(responseData.DATA) gt 0>
            <cfloop index="i" from="1" to="#arraylen(responseData.DATA)#">
                <cfquery name="add_r" datasource="#dsn#">
                    IF NOT EXISTS( SELECT MODULE_NO FROM WRK_MODULE where MODULE_NO = <cfqueryparam cfsqltype="cf_sql_integer" value="#responseData.DATA[i]["MODULE_NO"]#"> )
                        BEGIN
                            INSERT INTO WRK_MODULE
                            (
                                MODULE_NO,
                                MODULE,
                                MODULE_DICTIONARY_ID,
                                FAMILY_ID,
                                IS_MENU,
                                MODULE_TYPE,
                                RANK_NUMBER,
                                THEME_PATH,
                                UP,
                                RECORD_DATE,
                                RECORD_EMP,
                                RECORD_IP,
                                ICON
                            )
                            VALUES 
                            (
                                <cfqueryparam cfsqltype="cf_sql_integer" value="#responseData.DATA[i]["MODULE_NO"]#" null='#iif(len(responseData.DATA[i]["MODULE_NO"]),DE("no"),DE("yes"))#'>,
                                <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["MODULE"]#" null='#iif(len(responseData.DATA[i]["MODULE"]),DE("no"),DE("yes"))#'>,
                                <cfqueryparam cfsqltype="cf_sql_integer" value="#responseData.DATA[i]["MODULE_DICTIONARY_ID"]#" null='#iif(len(responseData.DATA[i]["MODULE_DICTIONARY_ID"]),DE("no"),DE("yes"))#'>,
                                <cfqueryparam cfsqltype="cf_sql_integer" value="#responseData.DATA[i]["FAMILY_ID"]#" null='#iif(len(responseData.DATA[i]["FAMILY_ID"]),DE("no"),DE("yes"))#'>,
                                <cfqueryparam cfsqltype="cf_sql_bit" value="#responseData.DATA[i]["IS_MENU"]#" null='#iif(len(responseData.DATA[i]["IS_MENU"]),DE("no"),DE("yes"))#'>,
                                <cfqueryparam cfsqltype="cf_sql_integer" value="#responseData.DATA[i]["MODULE_TYPE"]#" null='#iif(len(responseData.DATA[i]["MODULE_TYPE"]),DE("no"),DE("yes"))#'>,
                                <cfqueryparam cfsqltype="cf_sql_integer" value="#responseData.DATA[i]["RANK_NUMBER"]#" null='#iif(len(responseData.DATA[i]["RANK_NUMBER"]),DE("no"),DE("yes"))#'>,
                                <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["THEME_PATH"]#" null='#iif(len(responseData.DATA[i]["THEME_PATH"]),DE("no"),DE("yes"))#'>,
                                <cfqueryparam cfsqltype="cf_sql_integer" value="#responseData.DATA[i]["UP"]#" null='#iif(len(responseData.DATA[i]["UP"]),DE("no"),DE("yes"))#'>,
                                <cfqueryparam cfsqltype="cf_sql_timestamp" value="#NOW()#">,
                                <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                                <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#cgi.remote_addr#">,
                                <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["ICON"]#" null='#iif(len(responseData.DATA[i]["ICON"]),DE("no"),DE("yes"))#'>
                            )
                        END
                    ELSE
                        BEGIN
                            UPDATE WRK_MODULE
                            SET  
                                MODULE_NO = <cfqueryparam cfsqltype="cf_sql_integer" value="#responseData.DATA[i]["MODULE_NO"]#" null='#iif(len(responseData.DATA[i]["MODULE_NO"]),DE("no"),DE("yes"))#'>,
                                MODULE = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["MODULE"]#" null='#iif(len(responseData.DATA[i]["MODULE"]),DE("no"),DE("yes"))#'>,
                                MODULE_DICTIONARY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#responseData.DATA[i]["MODULE_DICTIONARY_ID"]#" null='#iif(len(responseData.DATA[i]["MODULE_DICTIONARY_ID"]),DE("no"),DE("yes"))#'>,
                                FAMILY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#responseData.DATA[i]["FAMILY_ID"]#" null='#iif(len(responseData.DATA[i]["FAMILY_ID"]),DE("no"),DE("yes"))#'>,
                                IS_MENU = <cfqueryparam cfsqltype="cf_sql_bit" value="#responseData.DATA[i]["IS_MENU"]#" null='#iif(len(responseData.DATA[i]["IS_MENU"]),DE("no"),DE("yes"))#'>,
                                MODULE_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#responseData.DATA[i]["MODULE_TYPE"]#" null='#iif(len(responseData.DATA[i]["MODULE_TYPE"]),DE("no"),DE("yes"))#'>,
                                RANK_NUMBER = <cfqueryparam cfsqltype="cf_sql_integer" value="#responseData.DATA[i]["RANK_NUMBER"]#" null='#iif(len(responseData.DATA[i]["RANK_NUMBER"]),DE("no"),DE("yes"))#'>,
                                THEME_PATH = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["THEME_PATH"]#" null='#iif(len(responseData.DATA[i]["THEME_PATH"]),DE("no"),DE("yes"))#'>,
                                UP = <cfqueryparam cfsqltype="cf_sql_integer" value="#responseData.DATA[i]["UP"]#" null='#iif(len(responseData.DATA[i]["UP"]),DE("no"),DE("yes"))#'>,
                                UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#NOW()#">,
                                UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                                UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#cgi.remote_addr#">,
                                ICON = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["ICON"]#" null='#iif(len(responseData.DATA[i]["ICON"]),DE("no"),DE("yes"))#'>
                            WHERE
                                MODULE_NO = <cfqueryparam cfsqltype="cf_sql_integer" value="#responseData.DATA[i]["MODULE_NO"]#">
                        END
                </cfquery>
            </cfloop>
        </cfif>
    </cfif>

    <!--- Güncellenen module'lerin güncellenmesi --->
    <cfset responseData = wroController.getWoLang(typeList:"getUpdatedModule",dateRangeValue:attributes.date_range_value_wo)>
    <cfif responseData.STATUS>
        <cfif arraylen(responseData.DATA) gt 0>
            <cfloop index="i" from="1" to="#arraylen(responseData.DATA)#"> 
                <cfquery name="add_r" datasource="#dsn#">
                    UPDATE WRK_MODULE
                    SET  
                        MODULE_NO = <cfqueryparam cfsqltype="cf_sql_integer" value="#responseData.DATA[i]["MODULE_NO"]#" null='#iif(len(responseData.DATA[i]["MODULE_NO"]),DE("no"),DE("yes"))#'>,
                        MODULE = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["MODULE"]#" null='#iif(len(responseData.DATA[i]["MODULE"]),DE("no"),DE("yes"))#'>,
                        MODULE_DICTIONARY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#responseData.DATA[i]["MODULE_DICTIONARY_ID"]#" null='#iif(len(responseData.DATA[i]["MODULE_DICTIONARY_ID"]),DE("no"),DE("yes"))#'>,
                        FAMILY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#responseData.DATA[i]["FAMILY_ID"]#" null='#iif(len(responseData.DATA[i]["FAMILY_ID"]),DE("no"),DE("yes"))#'>,
                        IS_MENU = <cfqueryparam cfsqltype="cf_sql_bit" value="#responseData.DATA[i]["IS_MENU"]#" null='#iif(len(responseData.DATA[i]["IS_MENU"]),DE("no"),DE("yes"))#'>,
                        MODULE_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#responseData.DATA[i]["MODULE_TYPE"]#" null='#iif(len(responseData.DATA[i]["MODULE_TYPE"]),DE("no"),DE("yes"))#'>,
                        RANK_NUMBER = <cfqueryparam cfsqltype="cf_sql_integer" value="#responseData.DATA[i]["RANK_NUMBER"]#" null='#iif(len(responseData.DATA[i]["RANK_NUMBER"]),DE("no"),DE("yes"))#'>,
                        THEME_PATH = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["THEME_PATH"]#" null='#iif(len(responseData.DATA[i]["THEME_PATH"]),DE("no"),DE("yes"))#'>,
                        UP = <cfqueryparam cfsqltype="cf_sql_integer" value="#responseData.DATA[i]["UP"]#" null='#iif(len(responseData.DATA[i]["UP"]),DE("no"),DE("yes"))#'>,
                        UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#NOW()#">,
                        UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                        UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#cgi.remote_addr#">,
                        ICON = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["ICON"]#" null='#iif(len(responseData.DATA[i]["ICON"]),DE("no"),DE("yes"))#'>
                    WHERE
                        MODULE_NO = <cfqueryparam cfsqltype="cf_sql_integer" value="#responseData.DATA[i]["MODULE_NO"]#">
                </cfquery>
            </cfloop>
        </cfif>
    </cfif>
</cfif>

<!--- WRK_OBJECTS upgrade --->
<cfif isDefined("attributes.Objects") and attributes.Objects eq 1>
    <!--- Yeni eklenen object'lerin eklenmesi --->
    <cfset responseData = wroController.getWoLang(typeList:"getNewWO",dateRangeValue:attributes.date_range_value_wo)>
    <cfif responseData.STATUS>
        <cfif arraylen(responseData.DATA) gt 0>
            <cfloop index="i" from="1" to="#arraylen(responseData.DATA)#">
                <cfquery name="add_r" datasource="#dsn#">
                    IF NOT EXISTS( SELECT FULL_FUSEACTION FROM WRK_OBJECTS where FULL_FUSEACTION = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["FULL_FUSEACTION"]#"> )
                        BEGIN
                            INSERT INTO WRK_OBJECTS
                            (
                                IS_ACTIVE,
                                MODULE_NO,
                                HEAD,
                                DICTIONARY_ID,
                                FRIENDLY_URL,
                                FULL_FUSEACTION,
                                FULL_FUSEACTION_VARIABLES,
                                FILE_PATH,
                                CONTROLLER_FILE_PATH,
                                STANDART_ADDON,
                                LICENCE,
                                EVENT_TYPE,
                                STATUS,
                                IS_DEFAULT,
                                IS_MENU,
                                WINDOW,
                                VERSION,
                                IS_CATALYST_MOD,
                                MENU_SORT_NO,
                                USE_PROCESS_CAT,
                                USE_SYSTEM_NO,
                                USE_WORKFLOW,
                                AUTHOR,
                                OBJECTS_COUNT,
                                DESTINATION_MODUL,
                                RECORD_IP,
                                RECORD_EMP,
                                RECORD_DATE,
                                SECURITY,
                                STAGE,
                                MODUL,
                                BASE,
                                MODUL_SHORT_NAME,
                                FUSEACTION,
                                FUSEACTION2,
                                FOLDER,
                                FILE_NAME,
                                IS_ADD,
                                IS_UPDATE,
                                IS_DELETE,
                                LEFT_MENU_NAME,
                                IS_WBO_DENIED,
                                IS_WBO_FORM_LOCK,
                                IS_WBO_LOCK,
                                IS_WBO_LOG,
                                IS_SPECIAL,
                                IS_TEMP,
                                EVENT_ADD,
                                EVENT_DASHBOARD,
                                EVENT_DEFAULT,
                                EVENT_DETAIL,
                                EVENT_LIST,
                                EVENT_UPD,
                                TYPE,
                                POPUP_TYPE,
                                RANK_NUMBER,
                                EXTERNAL_FUSEACTION,
                                IS_LEGACY,
                                ADDOPTIONS_CONTROLLER_FILE_PATH,
                                THEME_PATH,
                                IS_ONLY_SHOW_PAGE,
                                ICON,
                                XML_PATH,
                                DATA_CFC
                            )
                            VALUES 
                            (
                                <cfqueryparam cfsqltype="cf_sql_bit" value="#responseData.DATA[i]["IS_ACTIVE"]#" null='#iif(len(responseData.DATA[i]["IS_ACTIVE"]),DE("no"),DE("yes"))#'>,
                                <cfqueryparam cfsqltype="cf_sql_integer" value="#responseData.DATA[i]["MODULE_NO"]#" null='#iif(len(responseData.DATA[i]["MODULE_NO"]),DE("no"),DE("yes"))#'>,
                                <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["HEAD"]#" null='#iif(len(responseData.DATA[i]["HEAD"]),DE("no"),DE("yes"))#'>,
                                <cfqueryparam cfsqltype="cf_sql_integer" value="#responseData.DATA[i]["DICTIONARY_ID"]#" null='#iif(len(responseData.DATA[i]["DICTIONARY_ID"]),DE("no"),DE("yes"))#'>,
                                <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["FRIENDLY_URL"]#" null='#iif(len(responseData.DATA[i]["FRIENDLY_URL"]),DE("no"),DE("yes"))#'>,
                                <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["FULL_FUSEACTION"]#" null='#iif(len(responseData.DATA[i]["FULL_FUSEACTION"]),DE("no"),DE("yes"))#'>,
                                <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["FULL_FUSEACTION_VARIABLES"]#" null='#iif(len(responseData.DATA[i]["FULL_FUSEACTION_VARIABLES"]),DE("no"),DE("yes"))#'>,
                                <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["FILE_PATH"]#" null='#iif(len(responseData.DATA[i]["FILE_PATH"]),DE("no"),DE("yes"))#'>,
                                <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["CONTROLLER_FILE_PATH"]#" null='#iif(len(responseData.DATA[i]["CONTROLLER_FILE_PATH"]),DE("no"),DE("yes"))#'>,
                                <cfqueryparam cfsqltype="cf_sql_integer" value="#responseData.DATA[i]["STANDART_ADDON"]#" null='#iif(len(responseData.DATA[i]["STANDART_ADDON"]),DE("no"),DE("yes"))#'>,
                                <cfqueryparam cfsqltype="cf_sql_integer" value="#responseData.DATA[i]["LICENCE"]#" null='#iif(len(responseData.DATA[i]["LICENCE"]),DE("no"),DE("yes"))#'>,
                                <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["EVENT_TYPE"]#" null='#iif(len(responseData.DATA[i]["EVENT_TYPE"]),DE("no"),DE("yes"))#'>,
                                <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["STATUS"]#" null='#iif(len(responseData.DATA[i]["STATUS"]),DE("no"),DE("yes"))#'>,
                                <cfqueryparam cfsqltype="cf_sql_bit" value="#responseData.DATA[i]["IS_DEFAULT"]#" null='#iif(len(responseData.DATA[i]["IS_DEFAULT"]),DE("no"),DE("yes"))#'>,
                                <cfqueryparam cfsqltype="cf_sql_bit" value="#responseData.DATA[i]["IS_MENU"]#" null='#iif(len(responseData.DATA[i]["IS_MENU"]),DE("no"),DE("yes"))#'>,
                                <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["WINDOW"]#" null='#iif(len(responseData.DATA[i]["WINDOW"]),DE("no"),DE("yes"))#'>,
                                <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["VERSION"]#" null='#iif(len(responseData.DATA[i]["VERSION"]),DE("no"),DE("yes"))#'>,
                                <cfqueryparam cfsqltype="cf_sql_bit" value="#responseData.DATA[i]["IS_CATALYST_MOD"]#" null='#iif(len(responseData.DATA[i]["IS_CATALYST_MOD"]),DE("no"),DE("yes"))#'>,
                                <cfqueryparam cfsqltype="cf_sql_integer" value="#responseData.DATA[i]["MENU_SORT_NO"]#" null='#iif(len(responseData.DATA[i]["MENU_SORT_NO"]),DE("no"),DE("yes"))#'>,
                                <cfqueryparam cfsqltype="cf_sql_bit" value="#responseData.DATA[i]["USE_PROCESS_CAT"]#" null='#iif(len(responseData.DATA[i]["USE_PROCESS_CAT"]),DE("no"),DE("yes"))#'>,
                                <cfqueryparam cfsqltype="cf_sql_bit" value="#responseData.DATA[i]["USE_SYSTEM_NO"]#" null='#iif(len(responseData.DATA[i]["USE_SYSTEM_NO"]),DE("no"),DE("yes"))#'>,
                                <cfqueryparam cfsqltype="cf_sql_bit" value="#responseData.DATA[i]["USE_WORKFLOW"]#" null='#iif(len(responseData.DATA[i]["USE_WORKFLOW"]),DE("no"),DE("yes"))#'>,
                                <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["AUTHOR"]#" null='#iif(len(responseData.DATA[i]["AUTHOR"]),DE("no"),DE("yes"))#'>,
                                <cfqueryparam cfsqltype="cf_sql_integer" value="#responseData.DATA[i]["OBJECTS_COUNT"]#" null='#iif(len(responseData.DATA[i]["OBJECTS_COUNT"]),DE("no"),DE("yes"))#'>,
                                <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["DESTINATION_MODUL"]#" null='#iif(len(responseData.DATA[i]["DESTINATION_MODUL"]),DE("no"),DE("yes"))#'>,
                                <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#cgi.remote_addr#">,
                                <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                                <cfqueryparam cfsqltype="cf_sql_timestamp" value="#NOW()#">,
                                <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["SECURITY"]#" null='#iif(len(responseData.DATA[i]["SECURITY"]),DE("no"),DE("yes"))#'>,
                                <cfqueryparam cfsqltype="cf_sql_integer" value="#responseData.DATA[i]["STAGE"]#" null='#iif(len(responseData.DATA[i]["STAGE"]),DE("no"),DE("yes"))#'>,
                                <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["MODUL"]#" null='#iif(len(responseData.DATA[i]["MODUL"]),DE("no"),DE("yes"))#'>,
                                <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["BASE"]#" null='#iif(len(responseData.DATA[i]["BASE"]),DE("no"),DE("yes"))#'>,
                                <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["MODUL_SHORT_NAME"]#" null='#iif(len(responseData.DATA[i]["MODUL_SHORT_NAME"]),DE("no"),DE("yes"))#'>,
                                <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["FUSEACTION"]#" null='#iif(len(responseData.DATA[i]["FUSEACTION"]),DE("no"),DE("yes"))#'>,
                                <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["FUSEACTION2"]#" null='#iif(len(responseData.DATA[i]["FUSEACTION2"]),DE("no"),DE("yes"))#'>,
                                <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["FOLDER"]#" null='#iif(len(responseData.DATA[i]["FOLDER"]),DE("no"),DE("yes"))#'>,
                                <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["FILE_NAME"]#" null='#iif(len(responseData.DATA[i]["FILE_NAME"]),DE("no"),DE("yes"))#'>,
                                <cfqueryparam cfsqltype="cf_sql_bit" value="#responseData.DATA[i]["IS_ADD"]#" null='#iif(len(responseData.DATA[i]["IS_ADD"]),DE("no"),DE("yes"))#'>,
                                <cfqueryparam cfsqltype="cf_sql_bit" value="#responseData.DATA[i]["IS_UPDATE"]#" null='#iif(len(responseData.DATA[i]["IS_UPDATE"]),DE("no"),DE("yes"))#'>,
                                <cfqueryparam cfsqltype="cf_sql_bit" value="#responseData.DATA[i]["IS_DELETE"]#" null='#iif(len(responseData.DATA[i]["IS_DELETE"]),DE("no"),DE("yes"))#'>,
                                <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["LEFT_MENU_NAME"]#" null='#iif(len(responseData.DATA[i]["LEFT_MENU_NAME"]),DE("no"),DE("yes"))#'>,
                                <cfqueryparam cfsqltype="cf_sql_bit" value="#responseData.DATA[i]["IS_WBO_DENIED"]#" null='#iif(len(responseData.DATA[i]["IS_WBO_DENIED"]),DE("no"),DE("yes"))#'>,
                                <cfqueryparam cfsqltype="cf_sql_bit" value="#responseData.DATA[i]["IS_WBO_FORM_LOCK"]#" null='#iif(len(responseData.DATA[i]["IS_WBO_FORM_LOCK"]),DE("no"),DE("yes"))#'>,
                                <cfqueryparam cfsqltype="cf_sql_bit" value="#responseData.DATA[i]["IS_WBO_LOCK"]#" null='#iif(len(responseData.DATA[i]["IS_WBO_LOCK"]),DE("no"),DE("yes"))#'>,
                                <cfqueryparam cfsqltype="cf_sql_bit" value="#responseData.DATA[i]["IS_WBO_LOG"]#" null='#iif(len(responseData.DATA[i]["IS_WBO_LOG"]),DE("no"),DE("yes"))#'>,
                                <cfqueryparam cfsqltype="cf_sql_bit" value="#responseData.DATA[i]["IS_SPECIAL"]#" null='#iif(len(responseData.DATA[i]["IS_SPECIAL"]),DE("no"),DE("yes"))#'>,
                                <cfqueryparam cfsqltype="cf_sql_bit" value="#responseData.DATA[i]["IS_TEMP"]#" null='#iif(len(responseData.DATA[i]["IS_TEMP"]),DE("no"),DE("yes"))#'>,
                                <cfqueryparam cfsqltype="cf_sql_bit" value="#responseData.DATA[i]["EVENT_ADD"]#" null='#iif(len(responseData.DATA[i]["EVENT_ADD"]),DE("no"),DE("yes"))#'>,
                                <cfqueryparam cfsqltype="cf_sql_bit" value="#responseData.DATA[i]["EVENT_DASHBOARD"]#" null='#iif(len(responseData.DATA[i]["EVENT_DASHBOARD"]),DE("no"),DE("yes"))#'>,
                                <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["EVENT_DEFAULT"]#" null='#iif(len(responseData.DATA[i]["EVENT_DEFAULT"]),DE("no"),DE("yes"))#'>,
                                <cfqueryparam cfsqltype="cf_sql_bit" value="#responseData.DATA[i]["EVENT_DETAIL"]#" null='#iif(len(responseData.DATA[i]["EVENT_DETAIL"]),DE("no"),DE("yes"))#'>,
                                <cfqueryparam cfsqltype="cf_sql_bit" value="#responseData.DATA[i]["EVENT_LIST"]#" null='#iif(len(responseData.DATA[i]["EVENT_LIST"]),DE("no"),DE("yes"))#'>,
                                <cfqueryparam cfsqltype="cf_sql_bit" value="#responseData.DATA[i]["EVENT_UPD"]#" null='#iif(len(responseData.DATA[i]["EVENT_UPD"]),DE("no"),DE("yes"))#'>,
                                <cfqueryparam cfsqltype="cf_sql_integer" value="#responseData.DATA[i]["TYPE"]#" null='#iif(len(responseData.DATA[i]["TYPE"]),DE("no"),DE("yes"))#'>,
                                <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["POPUP_TYPE"]#" null='#iif(len(responseData.DATA[i]["POPUP_TYPE"]),DE("no"),DE("yes"))#'>,
                                <cfqueryparam cfsqltype="cf_sql_integer" value="#responseData.DATA[i]["RANK_NUMBER"]#" null='#iif(len(responseData.DATA[i]["RANK_NUMBER"]),DE("no"),DE("yes"))#'>,
                                <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["EXTERNAL_FUSEACTION"]#" null='#iif(len(responseData.DATA[i]["EXTERNAL_FUSEACTION"]),DE("no"),DE("yes"))#'>,
                                <cfqueryparam cfsqltype="cf_sql_integer" value="#responseData.DATA[i]["IS_LEGACY"]#" null='#iif(len(responseData.DATA[i]["IS_LEGACY"]),DE("no"),DE("yes"))#'>,
                                <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["ADDOPTIONS_CONTROLLER_FILE_PATH"]#" null='#iif(len(responseData.DATA[i]["ADDOPTIONS_CONTROLLER_FILE_PATH"]),DE("no"),DE("yes"))#'>,
                                <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["THEME_PATH"]#" null='#iif(len(responseData.DATA[i]["THEME_PATH"]),DE("no"),DE("yes"))#'>,
                                <cfqueryparam cfsqltype="cf_sql_bit" value="#responseData.DATA[i]["IS_ONLY_SHOW_PAGE"]#" null='#iif(len(responseData.DATA[i]["IS_ONLY_SHOW_PAGE"]),DE("no"),DE("yes"))#'>,
                                <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["ICON"]#" null='#iif(len(responseData.DATA[i]["ICON"]),DE("no"),DE("yes"))#'>,
                                <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["XML_PATH"]#" null='#iif(len(responseData.DATA[i]["XML_PATH"]),DE("no"),DE("yes"))#'>,
                                <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["DATA_CFC"]#" null='#iif(len(responseData.DATA[i]["DATA_CFC"]),DE("no"),DE("yes"))#'>
                            )
                        END
                    ELSE
                        BEGIN
                            UPDATE WRK_OBJECTS
                            SET  
                                IS_ACTIVE = <cfqueryparam cfsqltype="cf_sql_bit" value="#responseData.DATA[i]["IS_ACTIVE"]#" null='#iif(len(responseData.DATA[i]["IS_ACTIVE"]),DE("no"),DE("yes"))#'>,
                                MODULE_NO = <cfqueryparam cfsqltype="cf_sql_integer" value="#responseData.DATA[i]["MODULE_NO"]#" null='#iif(len(responseData.DATA[i]["MODULE_NO"]),DE("no"),DE("yes"))#'>,
                                HEAD = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["HEAD"]#" null='#iif(len(responseData.DATA[i]["HEAD"]),DE("no"),DE("yes"))#'>,
                                DICTIONARY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#responseData.DATA[i]["DICTIONARY_ID"]#" null='#iif(len(responseData.DATA[i]["DICTIONARY_ID"]),DE("no"),DE("yes"))#'>,
                                FRIENDLY_URL = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["FRIENDLY_URL"]#" null='#iif(len(responseData.DATA[i]["FRIENDLY_URL"]),DE("no"),DE("yes"))#'>,
                                FULL_FUSEACTION = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["FULL_FUSEACTION"]#" null='#iif(len(responseData.DATA[i]["FULL_FUSEACTION"]),DE("no"),DE("yes"))#'>,
                                FULL_FUSEACTION_VARIABLES = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["FULL_FUSEACTION_VARIABLES"]#" null='#iif(len(responseData.DATA[i]["FULL_FUSEACTION_VARIABLES"]),DE("no"),DE("yes"))#'>,
                                FILE_PATH = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["FILE_PATH"]#" null='#iif(len(responseData.DATA[i]["FILE_PATH"]),DE("no"),DE("yes"))#'>,
                                CONTROLLER_FILE_PATH = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["CONTROLLER_FILE_PATH"]#" null='#iif(len(responseData.DATA[i]["CONTROLLER_FILE_PATH"]),DE("no"),DE("yes"))#'>,
                                STANDART_ADDON = <cfqueryparam cfsqltype="cf_sql_integer" value="#responseData.DATA[i]["STANDART_ADDON"]#" null='#iif(len(responseData.DATA[i]["STANDART_ADDON"]),DE("no"),DE("yes"))#'>,
                                LICENCE = <cfqueryparam cfsqltype="cf_sql_integer" value="#responseData.DATA[i]["LICENCE"]#" null='#iif(len(responseData.DATA[i]["LICENCE"]),DE("no"),DE("yes"))#'>,
                                EVENT_TYPE = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["EVENT_TYPE"]#" null='#iif(len(responseData.DATA[i]["EVENT_TYPE"]),DE("no"),DE("yes"))#'>,
                                STATUS = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["STATUS"]#" null='#iif(len(responseData.DATA[i]["STATUS"]),DE("no"),DE("yes"))#'>,
                                IS_DEFAULT = <cfqueryparam cfsqltype="cf_sql_bit" value="#responseData.DATA[i]["IS_DEFAULT"]#" null='#iif(len(responseData.DATA[i]["IS_DEFAULT"]),DE("no"),DE("yes"))#'>,
                                IS_MENU = <cfqueryparam cfsqltype="cf_sql_bit" value="#responseData.DATA[i]["IS_MENU"]#" null='#iif(len(responseData.DATA[i]["IS_MENU"]),DE("no"),DE("yes"))#'>,
                                WINDOW = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["WINDOW"]#" null='#iif(len(responseData.DATA[i]["WINDOW"]),DE("no"),DE("yes"))#'>,
                                VERSION = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["VERSION"]#" null='#iif(len(responseData.DATA[i]["VERSION"]),DE("no"),DE("yes"))#'>,
                                IS_CATALYST_MOD = <cfqueryparam cfsqltype="cf_sql_bit" value="#responseData.DATA[i]["IS_CATALYST_MOD"]#" null='#iif(len(responseData.DATA[i]["IS_CATALYST_MOD"]),DE("no"),DE("yes"))#'>,
                                MENU_SORT_NO = <cfqueryparam cfsqltype="cf_sql_integer" value="#responseData.DATA[i]["MENU_SORT_NO"]#" null='#iif(len(responseData.DATA[i]["MENU_SORT_NO"]),DE("no"),DE("yes"))#'>,
                                USE_PROCESS_CAT = <cfqueryparam cfsqltype="cf_sql_bit" value="#responseData.DATA[i]["USE_PROCESS_CAT"]#" null='#iif(len(responseData.DATA[i]["USE_PROCESS_CAT"]),DE("no"),DE("yes"))#'>,
                                USE_SYSTEM_NO = <cfqueryparam cfsqltype="cf_sql_bit" value="#responseData.DATA[i]["USE_SYSTEM_NO"]#" null='#iif(len(responseData.DATA[i]["USE_SYSTEM_NO"]),DE("no"),DE("yes"))#'>,
                                USE_WORKFLOW = <cfqueryparam cfsqltype="cf_sql_bit" value="#responseData.DATA[i]["USE_WORKFLOW"]#" null='#iif(len(responseData.DATA[i]["USE_WORKFLOW"]),DE("no"),DE("yes"))#'>,
                                AUTHOR = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["AUTHOR"]#" null='#iif(len(responseData.DATA[i]["AUTHOR"]),DE("no"),DE("yes"))#'>,
                                OBJECTS_COUNT = <cfqueryparam cfsqltype="cf_sql_integer" value="#responseData.DATA[i]["OBJECTS_COUNT"]#" null='#iif(len(responseData.DATA[i]["OBJECTS_COUNT"]),DE("no"),DE("yes"))#'>,
                                DESTINATION_MODUL = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["DESTINATION_MODUL"]#" null='#iif(len(responseData.DATA[i]["DESTINATION_MODUL"]),DE("no"),DE("yes"))#'>,
                                UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#cgi.remote_addr#">,
                                UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                                UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#NOW()#">,
                                SECURITY = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["SECURITY"]#" null='#iif(len(responseData.DATA[i]["SECURITY"]),DE("no"),DE("yes"))#'>,
                                STAGE = <cfqueryparam cfsqltype="cf_sql_integer" value="#responseData.DATA[i]["STAGE"]#" null='#iif(len(responseData.DATA[i]["STAGE"]),DE("no"),DE("yes"))#'>,
                                MODUL = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["MODUL"]#" null='#iif(len(responseData.DATA[i]["MODUL"]),DE("no"),DE("yes"))#'>,
                                BASE = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["BASE"]#" null='#iif(len(responseData.DATA[i]["BASE"]),DE("no"),DE("yes"))#'>,
                                MODUL_SHORT_NAME = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["MODUL_SHORT_NAME"]#" null='#iif(len(responseData.DATA[i]["MODUL_SHORT_NAME"]),DE("no"),DE("yes"))#'>,
                                FUSEACTION = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["FUSEACTION"]#" null='#iif(len(responseData.DATA[i]["FUSEACTION"]),DE("no"),DE("yes"))#'>,
                                FUSEACTION2 = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["FUSEACTION2"]#" null='#iif(len(responseData.DATA[i]["FUSEACTION2"]),DE("no"),DE("yes"))#'>,
                                FOLDER = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["FOLDER"]#" null='#iif(len(responseData.DATA[i]["FOLDER"]),DE("no"),DE("yes"))#'>,
                                FILE_NAME = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["FILE_NAME"]#" null='#iif(len(responseData.DATA[i]["FILE_NAME"]),DE("no"),DE("yes"))#'>,
                                IS_ADD = <cfqueryparam cfsqltype="cf_sql_bit" value="#responseData.DATA[i]["IS_ADD"]#" null='#iif(len(responseData.DATA[i]["IS_ADD"]),DE("no"),DE("yes"))#'>,
                                IS_UPDATE = <cfqueryparam cfsqltype="cf_sql_bit" value="#responseData.DATA[i]["IS_UPDATE"]#" null='#iif(len(responseData.DATA[i]["IS_UPDATE"]),DE("no"),DE("yes"))#'>,
                                IS_DELETE = <cfqueryparam cfsqltype="cf_sql_bit" value="#responseData.DATA[i]["IS_DELETE"]#" null='#iif(len(responseData.DATA[i]["IS_DELETE"]),DE("no"),DE("yes"))#'>,
                                LEFT_MENU_NAME = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["LEFT_MENU_NAME"]#" null='#iif(len(responseData.DATA[i]["LEFT_MENU_NAME"]),DE("no"),DE("yes"))#'>,
                                IS_WBO_DENIED = <cfqueryparam cfsqltype="cf_sql_bit" value="#responseData.DATA[i]["IS_WBO_DENIED"]#" null='#iif(len(responseData.DATA[i]["IS_WBO_DENIED"]),DE("no"),DE("yes"))#'>,
                                IS_WBO_FORM_LOCK = <cfqueryparam cfsqltype="cf_sql_bit" value="#responseData.DATA[i]["IS_WBO_FORM_LOCK"]#" null='#iif(len(responseData.DATA[i]["IS_WBO_FORM_LOCK"]),DE("no"),DE("yes"))#'>,
                                IS_WBO_LOCK = <cfqueryparam cfsqltype="cf_sql_bit" value="#responseData.DATA[i]["IS_WBO_LOCK"]#" null='#iif(len(responseData.DATA[i]["IS_WBO_LOCK"]),DE("no"),DE("yes"))#'>,
                                IS_WBO_LOG = <cfqueryparam cfsqltype="cf_sql_bit" value="#responseData.DATA[i]["IS_WBO_LOG"]#" null='#iif(len(responseData.DATA[i]["IS_WBO_LOG"]),DE("no"),DE("yes"))#'>,
                                IS_SPECIAL = <cfqueryparam cfsqltype="cf_sql_bit" value="#responseData.DATA[i]["IS_SPECIAL"]#" null='#iif(len(responseData.DATA[i]["IS_SPECIAL"]),DE("no"),DE("yes"))#'>,
                                IS_TEMP = <cfqueryparam cfsqltype="cf_sql_bit" value="#responseData.DATA[i]["IS_TEMP"]#" null='#iif(len(responseData.DATA[i]["IS_TEMP"]),DE("no"),DE("yes"))#'>,
                                EVENT_ADD = <cfqueryparam cfsqltype="cf_sql_bit" value="#responseData.DATA[i]["EVENT_ADD"]#" null='#iif(len(responseData.DATA[i]["EVENT_ADD"]),DE("no"),DE("yes"))#'>,
                                EVENT_DASHBOARD = <cfqueryparam cfsqltype="cf_sql_bit" value="#responseData.DATA[i]["EVENT_DASHBOARD"]#" null='#iif(len(responseData.DATA[i]["EVENT_DASHBOARD"]),DE("no"),DE("yes"))#'>,
                                EVENT_DEFAULT = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["EVENT_DEFAULT"]#" null='#iif(len(responseData.DATA[i]["EVENT_DEFAULT"]),DE("no"),DE("yes"))#'>,
                                EVENT_DETAIL = <cfqueryparam cfsqltype="cf_sql_bit" value="#responseData.DATA[i]["EVENT_DETAIL"]#" null='#iif(len(responseData.DATA[i]["EVENT_DETAIL"]),DE("no"),DE("yes"))#'>,
                                EVENT_LIST = <cfqueryparam cfsqltype="cf_sql_bit" value="#responseData.DATA[i]["EVENT_LIST"]#" null='#iif(len(responseData.DATA[i]["EVENT_LIST"]),DE("no"),DE("yes"))#'>,
                                EVENT_UPD = <cfqueryparam cfsqltype="cf_sql_bit" value="#responseData.DATA[i]["EVENT_UPD"]#" null='#iif(len(responseData.DATA[i]["EVENT_UPD"]),DE("no"),DE("yes"))#'>,
                                TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#responseData.DATA[i]["TYPE"]#" null='#iif(len(responseData.DATA[i]["TYPE"]),DE("no"),DE("yes"))#'>,
                                POPUP_TYPE = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["POPUP_TYPE"]#" null='#iif(len(responseData.DATA[i]["POPUP_TYPE"]),DE("no"),DE("yes"))#'>,
                                RANK_NUMBER = <cfqueryparam cfsqltype="cf_sql_integer" value="#responseData.DATA[i]["RANK_NUMBER"]#" null='#iif(len(responseData.DATA[i]["RANK_NUMBER"]),DE("no"),DE("yes"))#'>,
                                EXTERNAL_FUSEACTION = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["EXTERNAL_FUSEACTION"]#" null='#iif(len(responseData.DATA[i]["EXTERNAL_FUSEACTION"]),DE("no"),DE("yes"))#'>,
                                IS_LEGACY = <cfqueryparam cfsqltype="cf_sql_integer" value="#responseData.DATA[i]["IS_LEGACY"]#" null='#iif(len(responseData.DATA[i]["IS_LEGACY"]),DE("no"),DE("yes"))#'>,
                                ADDOPTIONS_CONTROLLER_FILE_PATH = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["ADDOPTIONS_CONTROLLER_FILE_PATH"]#" null='#iif(len(responseData.DATA[i]["ADDOPTIONS_CONTROLLER_FILE_PATH"]),DE("no"),DE("yes"))#'>,
                                THEME_PATH = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["THEME_PATH"]#" null='#iif(len(responseData.DATA[i]["THEME_PATH"]),DE("no"),DE("yes"))#'>,
                                IS_ONLY_SHOW_PAGE = <cfqueryparam cfsqltype="cf_sql_bit" value="#responseData.DATA[i]["IS_ONLY_SHOW_PAGE"]#" null='#iif(len(responseData.DATA[i]["IS_ONLY_SHOW_PAGE"]),DE("no"),DE("yes"))#'>,
                                ICON = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["ICON"]#" null='#iif(len(responseData.DATA[i]["ICON"]),DE("no"),DE("yes"))#'>,
                                XML_PATH = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["XML_PATH"]#" null='#iif(len(responseData.DATA[i]["XML_PATH"]),DE("no"),DE("yes"))#'>,
                                DATA_CFC = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["DATA_CFC"]#" null='#iif(len(responseData.DATA[i]["DATA_CFC"]),DE("no"),DE("yes"))#'>
                            WHERE
                                FULL_FUSEACTION = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["FULL_FUSEACTION"]#">
                                AND ADDOPTIONS_CONTROLLER_FILE_PATH IS NULL 
                                AND FILE_PATH NOT LIKE '%add_options%'
                        END
                </cfquery>
            </cfloop>
        </cfif>
    </cfif>

    <!--- Güncellenen object'lerin güncellenmesi --->
    <cfset responseData = wroController.getWoLang(typeList:"getUpdatedWO",dateRangeValue:attributes.date_range_value_wo)>
    <cfif responseData.STATUS>
        <cfif arraylen(responseData.DATA) gt 0>
            <cfloop index="i" from="1" to="#arraylen(responseData.DATA)#"> 
                <cfquery name="add_r" datasource="#dsn#">
                    UPDATE WRK_OBJECTS
                    SET  
                        IS_ACTIVE = <cfqueryparam cfsqltype="cf_sql_bit" value="#responseData.DATA[i]["IS_ACTIVE"]#" null='#iif(len(responseData.DATA[i]["IS_ACTIVE"]),DE("no"),DE("yes"))#'>,
                        MODULE_NO = <cfqueryparam cfsqltype="cf_sql_integer" value="#responseData.DATA[i]["MODULE_NO"]#" null='#iif(len(responseData.DATA[i]["MODULE_NO"]),DE("no"),DE("yes"))#'>,
                        HEAD = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["HEAD"]#" null='#iif(len(responseData.DATA[i]["HEAD"]),DE("no"),DE("yes"))#'>,
                        DICTIONARY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#responseData.DATA[i]["DICTIONARY_ID"]#" null='#iif(len(responseData.DATA[i]["DICTIONARY_ID"]),DE("no"),DE("yes"))#'>,
                        FRIENDLY_URL = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["FRIENDLY_URL"]#" null='#iif(len(responseData.DATA[i]["FRIENDLY_URL"]),DE("no"),DE("yes"))#'>,
                        FULL_FUSEACTION = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["FULL_FUSEACTION"]#" null='#iif(len(responseData.DATA[i]["FULL_FUSEACTION"]),DE("no"),DE("yes"))#'>,
                        FULL_FUSEACTION_VARIABLES = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["FULL_FUSEACTION_VARIABLES"]#" null='#iif(len(responseData.DATA[i]["FULL_FUSEACTION_VARIABLES"]),DE("no"),DE("yes"))#'>,
                        FILE_PATH = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["FILE_PATH"]#" null='#iif(len(responseData.DATA[i]["FILE_PATH"]),DE("no"),DE("yes"))#'>,
                        CONTROLLER_FILE_PATH = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["CONTROLLER_FILE_PATH"]#" null='#iif(len(responseData.DATA[i]["CONTROLLER_FILE_PATH"]),DE("no"),DE("yes"))#'>,
                        STANDART_ADDON = <cfqueryparam cfsqltype="cf_sql_integer" value="#responseData.DATA[i]["STANDART_ADDON"]#" null='#iif(len(responseData.DATA[i]["STANDART_ADDON"]),DE("no"),DE("yes"))#'>,
                        LICENCE = <cfqueryparam cfsqltype="cf_sql_integer" value="#responseData.DATA[i]["LICENCE"]#" null='#iif(len(responseData.DATA[i]["LICENCE"]),DE("no"),DE("yes"))#'>,
                        EVENT_TYPE = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["EVENT_TYPE"]#" null='#iif(len(responseData.DATA[i]["EVENT_TYPE"]),DE("no"),DE("yes"))#'>,
                        STATUS = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["STATUS"]#" null='#iif(len(responseData.DATA[i]["STATUS"]),DE("no"),DE("yes"))#'>,
                        IS_DEFAULT = <cfqueryparam cfsqltype="cf_sql_bit" value="#responseData.DATA[i]["IS_DEFAULT"]#" null='#iif(len(responseData.DATA[i]["IS_DEFAULT"]),DE("no"),DE("yes"))#'>,
                        IS_MENU = <cfqueryparam cfsqltype="cf_sql_bit" value="#responseData.DATA[i]["IS_MENU"]#" null='#iif(len(responseData.DATA[i]["IS_MENU"]),DE("no"),DE("yes"))#'>,
                        WINDOW = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["WINDOW"]#" null='#iif(len(responseData.DATA[i]["WINDOW"]),DE("no"),DE("yes"))#'>,
                        VERSION = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["VERSION"]#" null='#iif(len(responseData.DATA[i]["VERSION"]),DE("no"),DE("yes"))#'>,
                        IS_CATALYST_MOD = <cfqueryparam cfsqltype="cf_sql_bit" value="#responseData.DATA[i]["IS_CATALYST_MOD"]#" null='#iif(len(responseData.DATA[i]["IS_CATALYST_MOD"]),DE("no"),DE("yes"))#'>,
                        MENU_SORT_NO = <cfqueryparam cfsqltype="cf_sql_integer" value="#responseData.DATA[i]["MENU_SORT_NO"]#" null='#iif(len(responseData.DATA[i]["MENU_SORT_NO"]),DE("no"),DE("yes"))#'>,
                        USE_PROCESS_CAT = <cfqueryparam cfsqltype="cf_sql_bit" value="#responseData.DATA[i]["USE_PROCESS_CAT"]#" null='#iif(len(responseData.DATA[i]["USE_PROCESS_CAT"]),DE("no"),DE("yes"))#'>,
                        USE_SYSTEM_NO = <cfqueryparam cfsqltype="cf_sql_bit" value="#responseData.DATA[i]["USE_SYSTEM_NO"]#" null='#iif(len(responseData.DATA[i]["USE_SYSTEM_NO"]),DE("no"),DE("yes"))#'>,
                        USE_WORKFLOW = <cfqueryparam cfsqltype="cf_sql_bit" value="#responseData.DATA[i]["USE_WORKFLOW"]#" null='#iif(len(responseData.DATA[i]["USE_WORKFLOW"]),DE("no"),DE("yes"))#'>,
                        AUTHOR = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["AUTHOR"]#" null='#iif(len(responseData.DATA[i]["AUTHOR"]),DE("no"),DE("yes"))#'>,
                        OBJECTS_COUNT = <cfqueryparam cfsqltype="cf_sql_integer" value="#responseData.DATA[i]["OBJECTS_COUNT"]#" null='#iif(len(responseData.DATA[i]["OBJECTS_COUNT"]),DE("no"),DE("yes"))#'>,
                        DESTINATION_MODUL = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["DESTINATION_MODUL"]#" null='#iif(len(responseData.DATA[i]["DESTINATION_MODUL"]),DE("no"),DE("yes"))#'>,
                        UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#cgi.remote_addr#">,
                        UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                        UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#NOW()#">,
                        SECURITY = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["SECURITY"]#" null='#iif(len(responseData.DATA[i]["SECURITY"]),DE("no"),DE("yes"))#'>,
                        STAGE = <cfqueryparam cfsqltype="cf_sql_integer" value="#responseData.DATA[i]["STAGE"]#" null='#iif(len(responseData.DATA[i]["STAGE"]),DE("no"),DE("yes"))#'>,
                        MODUL = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["MODUL"]#" null='#iif(len(responseData.DATA[i]["MODUL"]),DE("no"),DE("yes"))#'>,
                        BASE = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["BASE"]#" null='#iif(len(responseData.DATA[i]["BASE"]),DE("no"),DE("yes"))#'>,
                        MODUL_SHORT_NAME = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["MODUL_SHORT_NAME"]#" null='#iif(len(responseData.DATA[i]["MODUL_SHORT_NAME"]),DE("no"),DE("yes"))#'>,
                        FUSEACTION = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["FUSEACTION"]#" null='#iif(len(responseData.DATA[i]["FUSEACTION"]),DE("no"),DE("yes"))#'>,
                        FUSEACTION2 = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["FUSEACTION2"]#" null='#iif(len(responseData.DATA[i]["FUSEACTION2"]),DE("no"),DE("yes"))#'>,
                        FOLDER = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["FOLDER"]#" null='#iif(len(responseData.DATA[i]["FOLDER"]),DE("no"),DE("yes"))#'>,
                        FILE_NAME = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["FILE_NAME"]#" null='#iif(len(responseData.DATA[i]["FILE_NAME"]),DE("no"),DE("yes"))#'>,
                        IS_ADD = <cfqueryparam cfsqltype="cf_sql_bit" value="#responseData.DATA[i]["IS_ADD"]#" null='#iif(len(responseData.DATA[i]["IS_ADD"]),DE("no"),DE("yes"))#'>,
                        IS_UPDATE = <cfqueryparam cfsqltype="cf_sql_bit" value="#responseData.DATA[i]["IS_UPDATE"]#" null='#iif(len(responseData.DATA[i]["IS_UPDATE"]),DE("no"),DE("yes"))#'>,
                        IS_DELETE = <cfqueryparam cfsqltype="cf_sql_bit" value="#responseData.DATA[i]["IS_DELETE"]#" null='#iif(len(responseData.DATA[i]["IS_DELETE"]),DE("no"),DE("yes"))#'>,
                        LEFT_MENU_NAME = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["LEFT_MENU_NAME"]#" null='#iif(len(responseData.DATA[i]["LEFT_MENU_NAME"]),DE("no"),DE("yes"))#'>,
                        IS_WBO_DENIED = <cfqueryparam cfsqltype="cf_sql_bit" value="#responseData.DATA[i]["IS_WBO_DENIED"]#" null='#iif(len(responseData.DATA[i]["IS_WBO_DENIED"]),DE("no"),DE("yes"))#'>,
                        IS_WBO_FORM_LOCK = <cfqueryparam cfsqltype="cf_sql_bit" value="#responseData.DATA[i]["IS_WBO_FORM_LOCK"]#" null='#iif(len(responseData.DATA[i]["IS_WBO_FORM_LOCK"]),DE("no"),DE("yes"))#'>,
                        IS_WBO_LOCK = <cfqueryparam cfsqltype="cf_sql_bit" value="#responseData.DATA[i]["IS_WBO_LOCK"]#" null='#iif(len(responseData.DATA[i]["IS_WBO_LOCK"]),DE("no"),DE("yes"))#'>,
                        IS_WBO_LOG = <cfqueryparam cfsqltype="cf_sql_bit" value="#responseData.DATA[i]["IS_WBO_LOG"]#" null='#iif(len(responseData.DATA[i]["IS_WBO_LOG"]),DE("no"),DE("yes"))#'>,
                        IS_SPECIAL = <cfqueryparam cfsqltype="cf_sql_bit" value="#responseData.DATA[i]["IS_SPECIAL"]#" null='#iif(len(responseData.DATA[i]["IS_SPECIAL"]),DE("no"),DE("yes"))#'>,
                        IS_TEMP = <cfqueryparam cfsqltype="cf_sql_bit" value="#responseData.DATA[i]["IS_TEMP"]#" null='#iif(len(responseData.DATA[i]["IS_TEMP"]),DE("no"),DE("yes"))#'>,
                        EVENT_ADD = <cfqueryparam cfsqltype="cf_sql_bit" value="#responseData.DATA[i]["EVENT_ADD"]#" null='#iif(len(responseData.DATA[i]["EVENT_ADD"]),DE("no"),DE("yes"))#'>,
                        EVENT_DASHBOARD = <cfqueryparam cfsqltype="cf_sql_bit" value="#responseData.DATA[i]["EVENT_DASHBOARD"]#" null='#iif(len(responseData.DATA[i]["EVENT_DASHBOARD"]),DE("no"),DE("yes"))#'>,
                        EVENT_DEFAULT = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["EVENT_DEFAULT"]#" null='#iif(len(responseData.DATA[i]["EVENT_DEFAULT"]),DE("no"),DE("yes"))#'>,
                        EVENT_DETAIL = <cfqueryparam cfsqltype="cf_sql_bit" value="#responseData.DATA[i]["EVENT_DETAIL"]#" null='#iif(len(responseData.DATA[i]["EVENT_DETAIL"]),DE("no"),DE("yes"))#'>,
                        EVENT_LIST = <cfqueryparam cfsqltype="cf_sql_bit" value="#responseData.DATA[i]["EVENT_LIST"]#" null='#iif(len(responseData.DATA[i]["EVENT_LIST"]),DE("no"),DE("yes"))#'>,
                        EVENT_UPD = <cfqueryparam cfsqltype="cf_sql_bit" value="#responseData.DATA[i]["EVENT_UPD"]#" null='#iif(len(responseData.DATA[i]["EVENT_UPD"]),DE("no"),DE("yes"))#'>,
                        TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#responseData.DATA[i]["TYPE"]#" null='#iif(len(responseData.DATA[i]["TYPE"]),DE("no"),DE("yes"))#'>,
                        POPUP_TYPE = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["POPUP_TYPE"]#" null='#iif(len(responseData.DATA[i]["POPUP_TYPE"]),DE("no"),DE("yes"))#'>,
                        RANK_NUMBER = <cfqueryparam cfsqltype="cf_sql_integer" value="#responseData.DATA[i]["RANK_NUMBER"]#" null='#iif(len(responseData.DATA[i]["RANK_NUMBER"]),DE("no"),DE("yes"))#'>,
                        EXTERNAL_FUSEACTION = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["EXTERNAL_FUSEACTION"]#" null='#iif(len(responseData.DATA[i]["EXTERNAL_FUSEACTION"]),DE("no"),DE("yes"))#'>,
                        IS_LEGACY = <cfqueryparam cfsqltype="cf_sql_integer" value="#responseData.DATA[i]["IS_LEGACY"]#" null='#iif(len(responseData.DATA[i]["IS_LEGACY"]),DE("no"),DE("yes"))#'>,
                        ADDOPTIONS_CONTROLLER_FILE_PATH = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["ADDOPTIONS_CONTROLLER_FILE_PATH"]#" null='#iif(len(responseData.DATA[i]["ADDOPTIONS_CONTROLLER_FILE_PATH"]),DE("no"),DE("yes"))#'>,
                        THEME_PATH = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["THEME_PATH"]#" null='#iif(len(responseData.DATA[i]["THEME_PATH"]),DE("no"),DE("yes"))#'>,
                        IS_ONLY_SHOW_PAGE = <cfqueryparam cfsqltype="cf_sql_bit" value="#responseData.DATA[i]["IS_ONLY_SHOW_PAGE"]#" null='#iif(len(responseData.DATA[i]["IS_ONLY_SHOW_PAGE"]),DE("no"),DE("yes"))#'>,
                        ICON = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["ICON"]#" null='#iif(len(responseData.DATA[i]["ICON"]),DE("no"),DE("yes"))#'>,
                        XML_PATH = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["XML_PATH"]#" null='#iif(len(responseData.DATA[i]["XML_PATH"]),DE("no"),DE("yes"))#'>,
                        DATA_CFC = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["DATA_CFC"]#" null='#iif(len(responseData.DATA[i]["DATA_CFC"]),DE("no"),DE("yes"))#'>
                    WHERE
                        FULL_FUSEACTION = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["FULL_FUSEACTION"]#">
                </cfquery>
            </cfloop>
        </cfif>
    </cfif>
</cfif>

<!--- WRK_WIDGET upgrade --->
<cfif isDefined("attributes.Widget") and attributes.Widget eq 1>
    <!--- Yeni eklenen widget'ların eklenmesi --->
    <cfset responseData = wroController.getWoLang(typeList:"getNewWidget",dateRangeValue:attributes.date_range_value_wo)>
    <cfif responseData.STATUS>
        <cfif arraylen(responseData.DATA) gt 0>
            <cfloop index="i" from="1" to="#arraylen(responseData.DATA)#">
                <cfquery name="add_r" datasource="#dsn#">
                    IF NOT EXISTS( SELECT WIDGET_FRIENDLY_NAME FROM WRK_WIDGET WHERE WIDGET_FRIENDLY_NAME = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["WIDGET_FRIENDLY_NAME"]#">)
                        BEGIN
                            INSERT INTO WRK_WIDGET
                            (
                                WIDGET_FUSEACTION,
                                WIDGET_TITLE,
                                WIDGET_TITLE_DICTIONARY_ID,
                                WIDGET_EVENT_TYPE,
                                WIDGET_VERSION,
                                WIDGET_STRUCTURE,
                                WIDGET_CODE,
                                WIDGET_STATUS,
                                WIDGET_STAGE,
                                WIDGET_TOOL,
                                WIDGET_FILE_PATH,
                                WIDGETSOLUTIONID,
                                WIDGETSOLUTION,
                                WIDGETFAMILYID,
                                WIDGETFAMILY,
                                WIDGETMODULEID,
                                WIDGETMODULENO,
                                WIDGETMODULE,
                                WIDGET_DESCRIPTION,
                                WIDGET_LICENSE,
                                WIDGET_AUTHOR,
                                WIDGET_DEPENDS,
                                RECORD_DATE,
                                RECORD_EMP,
                                RECORD_IP,
                                IS_PUBLIC,
                                IS_EMPLOYEE,
                                IS_COMPANY,
                                IS_CONSUMER,
                                IS_EMPLOYEE_APP,
                                IS_MACHINES,
                                IS_LIVESTOCK,
                                IS_TEMPLATE_WIDGET,
                                WIDGET_FRIENDLY_NAME,
                                XML_PATH
                            )
                            VALUES 
                            (
                                <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["WIDGET_FUSEACTION"]#" null='#iif(len(responseData.DATA[i]["WIDGET_FUSEACTION"]),DE("no"),DE("yes"))#'>,
                                <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["WIDGET_TITLE"]#" null='#iif(len(responseData.DATA[i]["WIDGET_TITLE"]),DE("no"),DE("yes"))#'>,
                                <cfqueryparam cfsqltype="cf_sql_integer" value="#responseData.DATA[i]["WIDGET_TITLE_DICTIONARY_ID"]#" null='#iif(len(responseData.DATA[i]["WIDGET_TITLE_DICTIONARY_ID"]),DE("no"),DE("yes"))#'>,
                                <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["WIDGET_EVENT_TYPE"]#" null='#iif(len(responseData.DATA[i]["WIDGET_EVENT_TYPE"]),DE("no"),DE("yes"))#'>,
                                <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["WIDGET_VERSION"]#" null='#iif(len(responseData.DATA[i]["WIDGET_VERSION"]),DE("no"),DE("yes"))#'>,
                                <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["WIDGET_STRUCTURE"]#" null='#iif(len(responseData.DATA[i]["WIDGET_STRUCTURE"]),DE("no"),DE("yes"))#'>,
                                <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["WIDGET_CODE"]#" null='#iif(len(responseData.DATA[i]["WIDGET_CODE"]),DE("no"),DE("yes"))#'>,
                                <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["WIDGET_STATUS"]#" null='#iif(len(responseData.DATA[i]["WIDGET_STATUS"]),DE("no"),DE("yes"))#'>,
                                <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["WIDGET_STAGE"]#" null='#iif(len(responseData.DATA[i]["WIDGET_STAGE"]),DE("no"),DE("yes"))#'>,
                                <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["WIDGET_TOOL"]#" null='#iif(len(responseData.DATA[i]["WIDGET_TOOL"]),DE("no"),DE("yes"))#'>,
                                <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["WIDGET_FILE_PATH"]#" null='#iif(len(responseData.DATA[i]["WIDGET_FILE_PATH"]),DE("no"),DE("yes"))#'>,
                                <cfqueryparam cfsqltype="cf_sql_integer" value="#responseData.DATA[i]["WIDGETSOLUTIONID"]#" null='#iif(len(responseData.DATA[i]["WIDGETSOLUTIONID"]),DE("no"),DE("yes"))#'>,
                                <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["WIDGETSOLUTION"]#" null='#iif(len(responseData.DATA[i]["WIDGETSOLUTION"]),DE("no"),DE("yes"))#'>,
                                <cfqueryparam cfsqltype="cf_sql_integer" value="#responseData.DATA[i]["WIDGETFAMILYID"]#" null='#iif(len(responseData.DATA[i]["WIDGETFAMILYID"]),DE("no"),DE("yes"))#'>,
                                <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["WIDGETFAMILY"]#" null='#iif(len(responseData.DATA[i]["WIDGETFAMILY"]),DE("no"),DE("yes"))#'>,
                                <cfqueryparam cfsqltype="cf_sql_integer" value="#responseData.DATA[i]["WIDGETMODULEID"]#" null='#iif(len(responseData.DATA[i]["WIDGETMODULEID"]),DE("no"),DE("yes"))#'>,
                                <cfqueryparam cfsqltype="cf_sql_integer" value="#responseData.DATA[i]["WIDGETMODULENO"]#" null='#iif(len(responseData.DATA[i]["WIDGETMODULENO"]),DE("no"),DE("yes"))#'>,
                                <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["WIDGETMODULE"]#" null='#iif(len(responseData.DATA[i]["WIDGETMODULE"]),DE("no"),DE("yes"))#'>,
                                <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["WIDGET_DESCRIPTION"]#" null='#iif(len(responseData.DATA[i]["WIDGET_DESCRIPTION"]),DE("no"),DE("yes"))#'>,
                                <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["WIDGET_LICENSE"]#" null='#iif(len(responseData.DATA[i]["WIDGET_LICENSE"]),DE("no"),DE("yes"))#'>,
                                <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["WIDGET_AUTHOR"]#" null='#iif(len(responseData.DATA[i]["WIDGET_AUTHOR"]),DE("no"),DE("yes"))#'>,
                                <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["WIDGET_DEPENDS"]#" null='#iif(len(responseData.DATA[i]["WIDGET_DEPENDS"]),DE("no"),DE("yes"))#'>,
                                <cfqueryparam cfsqltype="cf_sql_timestamp" value="#NOW()#">,
                                <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                                <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#cgi.remote_addr#">,
                                <cfqueryparam cfsqltype="cf_sql_bit" value="#responseData.DATA[i]["IS_PUBLIC"]#" null='#iif(len(responseData.DATA[i]["IS_PUBLIC"]),DE("no"),DE("yes"))#'>,
                                <cfqueryparam cfsqltype="cf_sql_bit" value="#responseData.DATA[i]["IS_EMPLOYEE"]#" null='#iif(len(responseData.DATA[i]["IS_EMPLOYEE"]),DE("no"),DE("yes"))#'>,
                                <cfqueryparam cfsqltype="cf_sql_bit" value="#responseData.DATA[i]["IS_COMPANY"]#" null='#iif(len(responseData.DATA[i]["IS_COMPANY"]),DE("no"),DE("yes"))#'>,
                                <cfqueryparam cfsqltype="cf_sql_bit" value="#responseData.DATA[i]["IS_CONSUMER"]#" null='#iif(len(responseData.DATA[i]["IS_CONSUMER"]),DE("no"),DE("yes"))#'>,
                                <cfqueryparam cfsqltype="cf_sql_bit" value="#responseData.DATA[i]["IS_EMPLOYEE_APP"]#" null='#iif(len(responseData.DATA[i]["IS_EMPLOYEE_APP"]),DE("no"),DE("yes"))#'>,
                                <cfqueryparam cfsqltype="cf_sql_bit" value="#responseData.DATA[i]["IS_MACHINES"]#" null='#iif(len(responseData.DATA[i]["IS_MACHINES"]),DE("no"),DE("yes"))#'>,
                                <cfqueryparam cfsqltype="cf_sql_bit" value="#responseData.DATA[i]["IS_LIVESTOCK"]#" null='#iif(len(responseData.DATA[i]["IS_LIVESTOCK"]),DE("no"),DE("yes"))#'>,
                                <cfqueryparam cfsqltype="cf_sql_bit" value="#responseData.DATA[i]["IS_TEMPLATE_WIDGET"]#" null='#iif(len(responseData.DATA[i]["IS_TEMPLATE_WIDGET"]),DE("no"),DE("yes"))#'>,
                                <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["WIDGET_FRIENDLY_NAME"]#" null='#iif(len(responseData.DATA[i]["WIDGET_FRIENDLY_NAME"]),DE("no"),DE("yes"))#'>,
                                <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["XML_PATH"]#" null='#iif(len(responseData.DATA[i]["XML_PATH"]),DE("no"),DE("yes"))#'>
                            )
                        END
                    ELSE
                        BEGIN
                            UPDATE WRK_WIDGET
                            SET 
                                WIDGET_FUSEACTION = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["WIDGET_FUSEACTION"]#" null='#iif(len(responseData.DATA[i]["WIDGET_FUSEACTION"]),DE("no"),DE("yes"))#'>,
                                WIDGET_TITLE = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["WIDGET_TITLE"]#" null='#iif(len(responseData.DATA[i]["WIDGET_TITLE"]),DE("no"),DE("yes"))#'>,
                                WIDGET_TITLE_DICTIONARY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#responseData.DATA[i]["WIDGET_TITLE_DICTIONARY_ID"]#" null='#iif(len(responseData.DATA[i]["WIDGET_TITLE_DICTIONARY_ID"]),DE("no"),DE("yes"))#'>,
                                WIDGET_EVENT_TYPE = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["WIDGET_EVENT_TYPE"]#" null='#iif(len(responseData.DATA[i]["WIDGET_EVENT_TYPE"]),DE("no"),DE("yes"))#'>,
                                WIDGET_VERSION = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["WIDGET_VERSION"]#" null='#iif(len(responseData.DATA[i]["WIDGET_VERSION"]),DE("no"),DE("yes"))#'>,
                                WIDGET_STRUCTURE = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["WIDGET_STRUCTURE"]#" null='#iif(len(responseData.DATA[i]["WIDGET_STRUCTURE"]),DE("no"),DE("yes"))#'>,
                                WIDGET_CODE = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["WIDGET_CODE"]#" null='#iif(len(responseData.DATA[i]["WIDGET_CODE"]),DE("no"),DE("yes"))#'>,
                                WIDGET_STATUS = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["WIDGET_STATUS"]#" null='#iif(len(responseData.DATA[i]["WIDGET_STATUS"]),DE("no"),DE("yes"))#'>,
                                WIDGET_STAGE = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["WIDGET_STAGE"]#" null='#iif(len(responseData.DATA[i]["WIDGET_STAGE"]),DE("no"),DE("yes"))#'>,
                                WIDGET_TOOL = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["WIDGET_TOOL"]#" null='#iif(len(responseData.DATA[i]["WIDGET_TOOL"]),DE("no"),DE("yes"))#'>,
                                WIDGET_FILE_PATH = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["WIDGET_FILE_PATH"]#" null='#iif(len(responseData.DATA[i]["WIDGET_FILE_PATH"]),DE("no"),DE("yes"))#'>,
                                WIDGETSOLUTIONID = <cfqueryparam cfsqltype="cf_sql_integer" value="#responseData.DATA[i]["WIDGETSOLUTIONID"]#" null='#iif(len(responseData.DATA[i]["WIDGETSOLUTIONID"]),DE("no"),DE("yes"))#'>,
                                WIDGETSOLUTION = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["WIDGETSOLUTION"]#" null='#iif(len(responseData.DATA[i]["WIDGETSOLUTION"]),DE("no"),DE("yes"))#'>,
                                WIDGETFAMILYID = <cfqueryparam cfsqltype="cf_sql_integer" value="#responseData.DATA[i]["WIDGETFAMILYID"]#" null='#iif(len(responseData.DATA[i]["WIDGETFAMILYID"]),DE("no"),DE("yes"))#'>,
                                WIDGETFAMILY = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["WIDGETFAMILY"]#" null='#iif(len(responseData.DATA[i]["WIDGETFAMILY"]),DE("no"),DE("yes"))#'>,
                                WIDGETMODULEID = <cfqueryparam cfsqltype="cf_sql_integer" value="#responseData.DATA[i]["WIDGETMODULEID"]#" null='#iif(len(responseData.DATA[i]["WIDGETMODULEID"]),DE("no"),DE("yes"))#'>,
                                WIDGETMODULENO = <cfqueryparam cfsqltype="cf_sql_integer" value="#responseData.DATA[i]["WIDGETMODULENO"]#" null='#iif(len(responseData.DATA[i]["WIDGETMODULENO"]),DE("no"),DE("yes"))#'>,
                                WIDGETMODULE = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["WIDGETMODULE"]#" null='#iif(len(responseData.DATA[i]["WIDGETMODULE"]),DE("no"),DE("yes"))#'>,
                                WIDGET_DESCRIPTION = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["WIDGET_DESCRIPTION"]#" null='#iif(len(responseData.DATA[i]["WIDGET_DESCRIPTION"]),DE("no"),DE("yes"))#'>,
                                WIDGET_LICENSE = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["WIDGET_LICENSE"]#" null='#iif(len(responseData.DATA[i]["WIDGET_LICENSE"]),DE("no"),DE("yes"))#'>,
                                WIDGET_AUTHOR = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["WIDGET_AUTHOR"]#" null='#iif(len(responseData.DATA[i]["WIDGET_AUTHOR"]),DE("no"),DE("yes"))#'>,
                                WIDGET_DEPENDS = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["WIDGET_DEPENDS"]#" null='#iif(len(responseData.DATA[i]["WIDGET_DEPENDS"]),DE("no"),DE("yes"))#'>,
                                UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#NOW()#">,
                                UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                                UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#cgi.remote_addr#">,
                                IS_PUBLIC = <cfqueryparam cfsqltype="cf_sql_bit" value="#responseData.DATA[i]["IS_PUBLIC"]#" null='#iif(len(responseData.DATA[i]["IS_PUBLIC"]),DE("no"),DE("yes"))#'>,
                                IS_EMPLOYEE = <cfqueryparam cfsqltype="cf_sql_bit" value="#responseData.DATA[i]["IS_EMPLOYEE"]#" null='#iif(len(responseData.DATA[i]["IS_EMPLOYEE"]),DE("no"),DE("yes"))#'>,
                                IS_COMPANY = <cfqueryparam cfsqltype="cf_sql_bit" value="#responseData.DATA[i]["IS_COMPANY"]#" null='#iif(len(responseData.DATA[i]["IS_COMPANY"]),DE("no"),DE("yes"))#'>,
                                IS_CONSUMER = <cfqueryparam cfsqltype="cf_sql_bit" value="#responseData.DATA[i]["IS_CONSUMER"]#" null='#iif(len(responseData.DATA[i]["IS_CONSUMER"]),DE("no"),DE("yes"))#'>,
                                IS_EMPLOYEE_APP = <cfqueryparam cfsqltype="cf_sql_bit" value="#responseData.DATA[i]["IS_EMPLOYEE_APP"]#" null='#iif(len(responseData.DATA[i]["IS_EMPLOYEE_APP"]),DE("no"),DE("yes"))#'>,
                                IS_MACHINES = <cfqueryparam cfsqltype="cf_sql_bit" value="#responseData.DATA[i]["IS_MACHINES"]#" null='#iif(len(responseData.DATA[i]["IS_MACHINES"]),DE("no"),DE("yes"))#'>,
                                IS_LIVESTOCK = <cfqueryparam cfsqltype="cf_sql_bit" value="#responseData.DATA[i]["IS_LIVESTOCK"]#" null='#iif(len(responseData.DATA[i]["IS_LIVESTOCK"]),DE("no"),DE("yes"))#'>,
                                IS_TEMPLATE_WIDGET = <cfqueryparam cfsqltype="cf_sql_bit" value="#responseData.DATA[i]["IS_TEMPLATE_WIDGET"]#" null='#iif(len(responseData.DATA[i]["IS_TEMPLATE_WIDGET"]),DE("no"),DE("yes"))#'>,
                                WIDGET_FRIENDLY_NAME = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["WIDGET_FRIENDLY_NAME"]#" null='#iif(len(responseData.DATA[i]["WIDGET_FRIENDLY_NAME"]),DE("no"),DE("yes"))#'>,
                                XML_PATH = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["XML_PATH"]#" null='#iif(len(responseData.DATA[i]["XML_PATH"]),DE("no"),DE("yes"))#'>
                            WHERE
                                WIDGET_FRIENDLY_NAME = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["WIDGET_FRIENDLY_NAME"]#">
                        END
                </cfquery>
            </cfloop>
        </cfif>
    </cfif>

    <!--- Güncellenen widget'ların güncellenmesi --->
    <cfset responseData = wroController.getWoLang(typeList:"getUpdatedWidget",dateRangeValue:attributes.date_range_value_wo)>
    <cfif responseData.STATUS>
        <cfif arraylen(responseData.DATA) gt 0>
            <cfloop index="i" from="1" to="#arraylen(responseData.DATA)#"> 
                <cfquery name="add_r" datasource="#dsn#">
                    UPDATE WRK_WIDGET
                    SET 
                        WIDGET_FUSEACTION = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["WIDGET_FUSEACTION"]#" null='#iif(len(responseData.DATA[i]["WIDGET_FUSEACTION"]),DE("no"),DE("yes"))#'>,
                        WIDGET_TITLE = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["WIDGET_TITLE"]#" null='#iif(len(responseData.DATA[i]["WIDGET_TITLE"]),DE("no"),DE("yes"))#'>,
                        WIDGET_TITLE_DICTIONARY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#responseData.DATA[i]["WIDGET_TITLE_DICTIONARY_ID"]#" null='#iif(len(responseData.DATA[i]["WIDGET_TITLE_DICTIONARY_ID"]),DE("no"),DE("yes"))#'>,
                        WIDGET_EVENT_TYPE = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["WIDGET_EVENT_TYPE"]#" null='#iif(len(responseData.DATA[i]["WIDGET_EVENT_TYPE"]),DE("no"),DE("yes"))#'>,
                        WIDGET_VERSION = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["WIDGET_VERSION"]#" null='#iif(len(responseData.DATA[i]["WIDGET_VERSION"]),DE("no"),DE("yes"))#'>,
                        WIDGET_STRUCTURE = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["WIDGET_STRUCTURE"]#" null='#iif(len(responseData.DATA[i]["WIDGET_STRUCTURE"]),DE("no"),DE("yes"))#'>,
                        WIDGET_CODE = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["WIDGET_CODE"]#" null='#iif(len(responseData.DATA[i]["WIDGET_CODE"]),DE("no"),DE("yes"))#'>,
                        WIDGET_STATUS = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["WIDGET_STATUS"]#" null='#iif(len(responseData.DATA[i]["WIDGET_STATUS"]),DE("no"),DE("yes"))#'>,
                        WIDGET_STAGE = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["WIDGET_STAGE"]#" null='#iif(len(responseData.DATA[i]["WIDGET_STAGE"]),DE("no"),DE("yes"))#'>,
                        WIDGET_TOOL = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["WIDGET_TOOL"]#" null='#iif(len(responseData.DATA[i]["WIDGET_TOOL"]),DE("no"),DE("yes"))#'>,
                        WIDGET_FILE_PATH = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["WIDGET_FILE_PATH"]#" null='#iif(len(responseData.DATA[i]["WIDGET_FILE_PATH"]),DE("no"),DE("yes"))#'>,
                        WIDGETSOLUTIONID = <cfqueryparam cfsqltype="cf_sql_integer" value="#responseData.DATA[i]["WIDGETSOLUTIONID"]#" null='#iif(len(responseData.DATA[i]["WIDGETSOLUTIONID"]),DE("no"),DE("yes"))#'>,
                        WIDGETSOLUTION = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["WIDGETSOLUTION"]#" null='#iif(len(responseData.DATA[i]["WIDGETSOLUTION"]),DE("no"),DE("yes"))#'>,
                        WIDGETFAMILYID = <cfqueryparam cfsqltype="cf_sql_integer" value="#responseData.DATA[i]["WIDGETFAMILYID"]#" null='#iif(len(responseData.DATA[i]["WIDGETFAMILYID"]),DE("no"),DE("yes"))#'>,
                        WIDGETFAMILY = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["WIDGETFAMILY"]#" null='#iif(len(responseData.DATA[i]["WIDGETFAMILY"]),DE("no"),DE("yes"))#'>,
                        WIDGETMODULEID = <cfqueryparam cfsqltype="cf_sql_integer" value="#responseData.DATA[i]["WIDGETMODULEID"]#" null='#iif(len(responseData.DATA[i]["WIDGETMODULEID"]),DE("no"),DE("yes"))#'>,
                        WIDGETMODULENO = <cfqueryparam cfsqltype="cf_sql_integer" value="#responseData.DATA[i]["WIDGETMODULENO"]#" null='#iif(len(responseData.DATA[i]["WIDGETMODULENO"]),DE("no"),DE("yes"))#'>,
                        WIDGETMODULE = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["WIDGETMODULE"]#" null='#iif(len(responseData.DATA[i]["WIDGETMODULE"]),DE("no"),DE("yes"))#'>,
                        WIDGET_DESCRIPTION = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["WIDGET_DESCRIPTION"]#" null='#iif(len(responseData.DATA[i]["WIDGET_DESCRIPTION"]),DE("no"),DE("yes"))#'>,
                        WIDGET_LICENSE = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["WIDGET_LICENSE"]#" null='#iif(len(responseData.DATA[i]["WIDGET_LICENSE"]),DE("no"),DE("yes"))#'>,
                        WIDGET_AUTHOR = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["WIDGET_AUTHOR"]#" null='#iif(len(responseData.DATA[i]["WIDGET_AUTHOR"]),DE("no"),DE("yes"))#'>,
                        WIDGET_DEPENDS = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["WIDGET_DEPENDS"]#" null='#iif(len(responseData.DATA[i]["WIDGET_DEPENDS"]),DE("no"),DE("yes"))#'>,
                        UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#NOW()#">,
                        UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                        UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#cgi.remote_addr#">,
                        IS_PUBLIC = <cfqueryparam cfsqltype="cf_sql_bit" value="#responseData.DATA[i]["IS_PUBLIC"]#" null='#iif(len(responseData.DATA[i]["IS_PUBLIC"]),DE("no"),DE("yes"))#'>,
                        IS_EMPLOYEE = <cfqueryparam cfsqltype="cf_sql_bit" value="#responseData.DATA[i]["IS_EMPLOYEE"]#" null='#iif(len(responseData.DATA[i]["IS_EMPLOYEE"]),DE("no"),DE("yes"))#'>,
                        IS_COMPANY = <cfqueryparam cfsqltype="cf_sql_bit" value="#responseData.DATA[i]["IS_COMPANY"]#" null='#iif(len(responseData.DATA[i]["IS_COMPANY"]),DE("no"),DE("yes"))#'>,
                        IS_CONSUMER = <cfqueryparam cfsqltype="cf_sql_bit" value="#responseData.DATA[i]["IS_CONSUMER"]#" null='#iif(len(responseData.DATA[i]["IS_CONSUMER"]),DE("no"),DE("yes"))#'>,
                        IS_EMPLOYEE_APP = <cfqueryparam cfsqltype="cf_sql_bit" value="#responseData.DATA[i]["IS_EMPLOYEE_APP"]#" null='#iif(len(responseData.DATA[i]["IS_EMPLOYEE_APP"]),DE("no"),DE("yes"))#'>,
                        IS_MACHINES = <cfqueryparam cfsqltype="cf_sql_bit" value="#responseData.DATA[i]["IS_MACHINES"]#" null='#iif(len(responseData.DATA[i]["IS_MACHINES"]),DE("no"),DE("yes"))#'>,
                        IS_LIVESTOCK = <cfqueryparam cfsqltype="cf_sql_bit" value="#responseData.DATA[i]["IS_LIVESTOCK"]#" null='#iif(len(responseData.DATA[i]["IS_LIVESTOCK"]),DE("no"),DE("yes"))#'>,
                        IS_TEMPLATE_WIDGET = <cfqueryparam cfsqltype="cf_sql_bit" value="#responseData.DATA[i]["IS_TEMPLATE_WIDGET"]#" null='#iif(len(responseData.DATA[i]["IS_TEMPLATE_WIDGET"]),DE("no"),DE("yes"))#'>,
                        WIDGET_FRIENDLY_NAME = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["WIDGET_FRIENDLY_NAME"]#" null='#iif(len(responseData.DATA[i]["WIDGET_FRIENDLY_NAME"]),DE("no"),DE("yes"))#'>,
                        XML_PATH = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["XML_PATH"]#" null='#iif(len(responseData.DATA[i]["XML_PATH"]),DE("no"),DE("yes"))#'>
                    WHERE
                        WIDGET_FRIENDLY_NAME = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["WIDGET_FRIENDLY_NAME"]#">
                </cfquery>
            </cfloop>
        </cfif>
    </cfif>
</cfif>

<!--- WEX upgrade --->
<cfif isDefined("attributes.Wex") and attributes.Wex eq 1>
    <!--- Yeni eklenen wex'lerinn eklenmesi --->
    <cfset responseData = wroController.getWoLang(typeList:"getNewWEX",dateRangeValue:attributes.date_range_value_wo)>
    <cfif responseData.STATUS>
        <cfif arraylen(responseData.DATA) gt 0>
            <cfloop index="i" from="1" to="#arraylen(responseData.DATA)#">
                <cfquery name="add_r" datasource="#dsn#">
                    IF NOT EXISTS( SELECT REST_NAME FROM WRK_WEX WHERE REST_NAME = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["REST_NAME"]#">)
                        BEGIN
                            INSERT INTO WRK_WEX
                            (
                                IS_ACTIVE,
                                MODULE,
                                HEAD,
                                DICTIONARY_ID,
                                VERSION,
                                TYPE,
                                LICENCE,
                                REST_NAME,
                                TIME_PLAN_TYPE,
                                TIME_PLAN,
                                AUTHENTICATION,
                                STATUS,
                                STAGE,
                                AUTHOR,
                                FILE_PATH,
                                RELATED_WO,
                                IMAGE,
                                DETAIL,
                                SOURCE_WO,
                                WEX_FILE_ID,
                                RECORD_DATE,
                                RECORD_EMP,
                                RECORD_IP,
                                DATA_CONVERTER,
                                IS_DATASERVICE
                            )
                            VALUES 
                            (
                                <cfqueryparam cfsqltype="cf_sql_bit" value="#responseData.DATA[i]["IS_ACTIVE"]#" null='#iif(len(responseData.DATA[i]["IS_ACTIVE"]),DE("no"),DE("yes"))#'>,
                                <cfqueryparam cfsqltype="cf_sql_integer" value="#responseData.DATA[i]["MODULE"]#" null='#iif(len(responseData.DATA[i]["MODULE"]),DE("no"),DE("yes"))#'>,
                                <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["HEAD"]#" null='#iif(len(responseData.DATA[i]["HEAD"]),DE("no"),DE("yes"))#'>,
                                <cfqueryparam cfsqltype="cf_sql_integer" value="#responseData.DATA[i]["DICTIONARY_ID"]#" null='#iif(len(responseData.DATA[i]["DICTIONARY_ID"]),DE("no"),DE("yes"))#'>,
                                <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["VERSION"]#" null='#iif(len(responseData.DATA[i]["VERSION"]),DE("no"),DE("yes"))#'>,
                                <cfqueryparam cfsqltype="cf_sql_integer" value="#responseData.DATA[i]["TYPE"]#" null='#iif(len(responseData.DATA[i]["TYPE"]),DE("no"),DE("yes"))#'>,
                                <cfqueryparam cfsqltype="cf_sql_integer" value="#responseData.DATA[i]["LICENCE"]#" null='#iif(len(responseData.DATA[i]["LICENCE"]),DE("no"),DE("yes"))#'>,
                                <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["REST_NAME"]#" null='#iif(len(responseData.DATA[i]["REST_NAME"]),DE("no"),DE("yes"))#'>,
                                <cfqueryparam cfsqltype="cf_sql_integer" value="#responseData.DATA[i]["TIME_PLAN_TYPE"]#" null='#iif(len(responseData.DATA[i]["TIME_PLAN_TYPE"]),DE("no"),DE("yes"))#'>,
                                <cfqueryparam cfsqltype="cf_sql_integer" value="#responseData.DATA[i]["TIME_PLAN"]#" null='#iif(len(responseData.DATA[i]["TIME_PLAN"]),DE("no"),DE("yes"))#'>,
                                <cfqueryparam cfsqltype="cf_sql_integer" value="#responseData.DATA[i]["AUTHENTICATION"]#" null='#iif(len(responseData.DATA[i]["AUTHENTICATION"]),DE("no"),DE("yes"))#'>,
                                <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["STATUS"]#" null='#iif(len(responseData.DATA[i]["STATUS"]),DE("no"),DE("yes"))#'>,
                                <cfqueryparam cfsqltype="cf_sql_integer" value="#responseData.DATA[i]["STAGE"]#" null='#iif(len(responseData.DATA[i]["STAGE"]),DE("no"),DE("yes"))#'>,
                                <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["AUTHOR"]#" null='#iif(len(responseData.DATA[i]["AUTHOR"]),DE("no"),DE("yes"))#'>,
                                <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["FILE_PATH"]#" null='#iif(len(responseData.DATA[i]["FILE_PATH"]),DE("no"),DE("yes"))#'>,
                                <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["RELATED_WO"]#" null='#iif(len(responseData.DATA[i]["RELATED_WO"]),DE("no"),DE("yes"))#'>,
                                <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["IMAGE"]#" null='#iif(len(responseData.DATA[i]["IMAGE"]),DE("no"),DE("yes"))#'>,
                                <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["DETAIL"]#" null='#iif(len(responseData.DATA[i]["DETAIL"]),DE("no"),DE("yes"))#'>,
                                <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["SOURCE_WO"]#" null='#iif(len(responseData.DATA[i]["SOURCE_WO"]),DE("no"),DE("yes"))#'>,
                                <cfqueryparam cfsqltype="cf_sql_integer" value="#responseData.DATA[i]["WEX_FILE_ID"]#" null='#iif(len(responseData.DATA[i]["WEX_FILE_ID"]),DE("no"),DE("yes"))#'>,
                                <cfqueryparam cfsqltype="cf_sql_timestamp" value="#NOW()#">,
                                <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                                <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#cgi.remote_addr#">,
                                <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["DATA_CONVERTER"]#" null='#iif(len(responseData.DATA[i]["DATA_CONVERTER"]),DE("no"),DE("yes"))#'>,
                                <cfqueryparam cfsqltype="cf_sql_bit" value="#responseData.DATA[i]["IS_DATASERVICE"]#" null='#iif(len(responseData.DATA[i]["IS_DATASERVICE"]),DE("no"),DE("yes"))#'>
                            )
                        END
                    ELSE
                        BEGIN
                            UPDATE WRK_WEX
                            SET 
                                IS_ACTIVE = <cfqueryparam cfsqltype="cf_sql_bit" value="#responseData.DATA[i]["IS_ACTIVE"]#" null='#iif(len(responseData.DATA[i]["IS_ACTIVE"]),DE("no"),DE("yes"))#'>,
                                MODULE = <cfqueryparam cfsqltype="cf_sql_integer" value="#responseData.DATA[i]["MODULE"]#" null='#iif(len(responseData.DATA[i]["MODULE"]),DE("no"),DE("yes"))#'>,
                                HEAD = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["HEAD"]#" null='#iif(len(responseData.DATA[i]["HEAD"]),DE("no"),DE("yes"))#'>,
                                DICTIONARY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#responseData.DATA[i]["DICTIONARY_ID"]#" null='#iif(len(responseData.DATA[i]["DICTIONARY_ID"]),DE("no"),DE("yes"))#'>,
                                VERSION = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["VERSION"]#" null='#iif(len(responseData.DATA[i]["VERSION"]),DE("no"),DE("yes"))#'>,
                                TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#responseData.DATA[i]["TYPE"]#" null='#iif(len(responseData.DATA[i]["TYPE"]),DE("no"),DE("yes"))#'>,
                                LICENCE = <cfqueryparam cfsqltype="cf_sql_integer" value="#responseData.DATA[i]["LICENCE"]#" null='#iif(len(responseData.DATA[i]["LICENCE"]),DE("no"),DE("yes"))#'>,
                                REST_NAME = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["REST_NAME"]#" null='#iif(len(responseData.DATA[i]["REST_NAME"]),DE("no"),DE("yes"))#'>,
                                TIME_PLAN_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#responseData.DATA[i]["TIME_PLAN_TYPE"]#" null='#iif(len(responseData.DATA[i]["TIME_PLAN_TYPE"]),DE("no"),DE("yes"))#'>,
                                TIME_PLAN = <cfqueryparam cfsqltype="cf_sql_integer" value="#responseData.DATA[i]["TIME_PLAN"]#" null='#iif(len(responseData.DATA[i]["TIME_PLAN"]),DE("no"),DE("yes"))#'>,
                                AUTHENTICATION = <cfqueryparam cfsqltype="cf_sql_integer" value="#responseData.DATA[i]["AUTHENTICATION"]#" null='#iif(len(responseData.DATA[i]["AUTHENTICATION"]),DE("no"),DE("yes"))#'>,
                                STATUS = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["STATUS"]#" null='#iif(len(responseData.DATA[i]["STATUS"]),DE("no"),DE("yes"))#'>,
                                STAGE = <cfqueryparam cfsqltype="cf_sql_integer" value="#responseData.DATA[i]["STAGE"]#" null='#iif(len(responseData.DATA[i]["STAGE"]),DE("no"),DE("yes"))#'>,
                                AUTHOR = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["AUTHOR"]#" null='#iif(len(responseData.DATA[i]["AUTHOR"]),DE("no"),DE("yes"))#'>,
                                FILE_PATH = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["FILE_PATH"]#" null='#iif(len(responseData.DATA[i]["FILE_PATH"]),DE("no"),DE("yes"))#'>,
                                RELATED_WO = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["RELATED_WO"]#" null='#iif(len(responseData.DATA[i]["RELATED_WO"]),DE("no"),DE("yes"))#'>,
                                IMAGE = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["IMAGE"]#" null='#iif(len(responseData.DATA[i]["IMAGE"]),DE("no"),DE("yes"))#'>,
                                DETAIL = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["DETAIL"]#" null='#iif(len(responseData.DATA[i]["DETAIL"]),DE("no"),DE("yes"))#'>,
                                SOURCE_WO = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["SOURCE_WO"]#" null='#iif(len(responseData.DATA[i]["SOURCE_WO"]),DE("no"),DE("yes"))#'>,
                                WEX_FILE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#responseData.DATA[i]["WEX_FILE_ID"]#" null='#iif(len(responseData.DATA[i]["WEX_FILE_ID"]),DE("no"),DE("yes"))#'>,
                                UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#NOW()#">,
                                UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                                UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#cgi.remote_addr#">,
                                DATA_CONVERTER = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["DATA_CONVERTER"]#" null='#iif(len(responseData.DATA[i]["DATA_CONVERTER"]),DE("no"),DE("yes"))#'>,
                                IS_DATASERVICE = <cfqueryparam cfsqltype="cf_sql_bit" value="#responseData.DATA[i]["IS_DATASERVICE"]#" null='#iif(len(responseData.DATA[i]["IS_DATASERVICE"]),DE("no"),DE("yes"))#'>
                            WHERE
                                REST_NAME = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["REST_NAME"]#">
                        END
                </cfquery>
            </cfloop>
        </cfif>
    </cfif>

    <!--- Güncellenen wexlerin güncellenmesi --->
    <cfset responseData = wroController.getWoLang(typeList:"getUpdatedWEX",dateRangeValue:attributes.date_range_value_wo)>
    <cfif responseData.STATUS>
        <cfif arraylen(responseData.DATA) gt 0>
            <cfloop index="i" from="1" to="#arraylen(responseData.DATA)#"> 
                <cfquery name="add_r" datasource="#dsn#">
                    UPDATE WRK_WEX
                    SET 
                        IS_ACTIVE = <cfqueryparam cfsqltype="cf_sql_bit" value="#responseData.DATA[i]["IS_ACTIVE"]#" null='#iif(len(responseData.DATA[i]["IS_ACTIVE"]),DE("no"),DE("yes"))#'>,
                        MODULE = <cfqueryparam cfsqltype="cf_sql_integer" value="#responseData.DATA[i]["MODULE"]#" null='#iif(len(responseData.DATA[i]["MODULE"]),DE("no"),DE("yes"))#'>,
                        HEAD = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["HEAD"]#" null='#iif(len(responseData.DATA[i]["HEAD"]),DE("no"),DE("yes"))#'>,
                        DICTIONARY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#responseData.DATA[i]["DICTIONARY_ID"]#" null='#iif(len(responseData.DATA[i]["DICTIONARY_ID"]),DE("no"),DE("yes"))#'>,
                        VERSION = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["VERSION"]#" null='#iif(len(responseData.DATA[i]["VERSION"]),DE("no"),DE("yes"))#'>,
                        TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#responseData.DATA[i]["TYPE"]#" null='#iif(len(responseData.DATA[i]["TYPE"]),DE("no"),DE("yes"))#'>,
                        LICENCE = <cfqueryparam cfsqltype="cf_sql_integer" value="#responseData.DATA[i]["LICENCE"]#" null='#iif(len(responseData.DATA[i]["LICENCE"]),DE("no"),DE("yes"))#'>,
                        REST_NAME = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["REST_NAME"]#" null='#iif(len(responseData.DATA[i]["REST_NAME"]),DE("no"),DE("yes"))#'>,
                        TIME_PLAN_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#responseData.DATA[i]["TIME_PLAN_TYPE"]#" null='#iif(len(responseData.DATA[i]["TIME_PLAN_TYPE"]),DE("no"),DE("yes"))#'>,
                        TIME_PLAN = <cfqueryparam cfsqltype="cf_sql_integer" value="#responseData.DATA[i]["TIME_PLAN"]#" null='#iif(len(responseData.DATA[i]["TIME_PLAN"]),DE("no"),DE("yes"))#'>,
                        AUTHENTICATION = <cfqueryparam cfsqltype="cf_sql_integer" value="#responseData.DATA[i]["AUTHENTICATION"]#" null='#iif(len(responseData.DATA[i]["AUTHENTICATION"]),DE("no"),DE("yes"))#'>,
                        STATUS = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["STATUS"]#" null='#iif(len(responseData.DATA[i]["STATUS"]),DE("no"),DE("yes"))#'>,
                        STAGE = <cfqueryparam cfsqltype="cf_sql_integer" value="#responseData.DATA[i]["STAGE"]#" null='#iif(len(responseData.DATA[i]["STAGE"]),DE("no"),DE("yes"))#'>,
                        AUTHOR = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["AUTHOR"]#" null='#iif(len(responseData.DATA[i]["AUTHOR"]),DE("no"),DE("yes"))#'>,
                        FILE_PATH = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["FILE_PATH"]#" null='#iif(len(responseData.DATA[i]["FILE_PATH"]),DE("no"),DE("yes"))#'>,
                        RELATED_WO = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["RELATED_WO"]#" null='#iif(len(responseData.DATA[i]["RELATED_WO"]),DE("no"),DE("yes"))#'>,
                        IMAGE = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["IMAGE"]#" null='#iif(len(responseData.DATA[i]["IMAGE"]),DE("no"),DE("yes"))#'>,
                        DETAIL = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["DETAIL"]#" null='#iif(len(responseData.DATA[i]["DETAIL"]),DE("no"),DE("yes"))#'>,
                        SOURCE_WO = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["SOURCE_WO"]#" null='#iif(len(responseData.DATA[i]["SOURCE_WO"]),DE("no"),DE("yes"))#'>,
                        WEX_FILE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#responseData.DATA[i]["WEX_FILE_ID"]#" null='#iif(len(responseData.DATA[i]["WEX_FILE_ID"]),DE("no"),DE("yes"))#'>,
                        UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#NOW()#">,
                        UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                        UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#cgi.remote_addr#">
                    WHERE
                        REST_NAME = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["REST_NAME"]#">
                </cfquery>
            </cfloop>
        </cfif>
    </cfif>
</cfif>

<!--- Output Template upgrade --->
<cfif isDefined("attributes.Output_Templates") and attributes.Output_Templates eq 1>
    <!--- Yeni eklenen output templatelerin eklenmesi --->
    <cfset responseData = wroController.getWoLang(typeList:"getNewOutputTemplates",dateRangeValue:attributes.date_range_value_wo)>
    <cfif responseData.STATUS>
        <cfif arraylen(responseData.DATA) gt 0>
            <cfloop index="i" from="1" to="#arraylen(responseData.DATA)#">
                <cfquery name="add_r" datasource="#dsn#">
                    IF NOT EXISTS( SELECT WRK_OUTPUT_TEMPLATE_ID FROM WRK_OUTPUT_TEMPLATES WHERE WRK_OUTPUT_TEMPLATE_ID = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["WRK_OUTPUT_TEMPLATE_ID"]#">)
                        BEGIN
                            INSERT INTO WRK_OUTPUT_TEMPLATES
                            (
                                WRK_OUTPUT_TEMPLATE_NAME,
                                WRK_OUTPUT_TEMPLATE_PATENT,
                                IS_ACTIVE,
                                BEST_PRACTISE_CODE,
                                OUTPUT_TEMPLATE_DETAIL,
                                WORKCUBE_PRODUCT_ID,
                                LICENCE_TYPE,
                                RELATED_WO,
                                AUTHOR_PARTNER_ID,
                                AUTHOR_NAME,
                                OUTPUT_TEMPLATE_VIEW_PATH,
                                OUTPUT_TEMPLATE_PATH,
                                OUTPUT_TEMPLATE_SECTORS,
                                WRK_PROCESS_STAGE,
                                PRINT_TYPE,
                                OUTPUT_TEMPLATE_VERSION,
                                RECORD_DATE,
                                RECORD_EMP,
                                RECORD_IP,
                                USE_LOGO,
                                USE_ADRESS,
                                PAGE_WIDTH,
                                PAGE_HEIGHT,
                                PAGE_MARGIN_LEFT,
                                PAGE_MARGIN_RIGHT,
                                PAGE_MARGIN_TOP,
                                PAGE_MARGIN_BOTTOM,
                                PAGE_HEADER_HEIGHT,
                                PAGE_FOOTER_HEIGHT,
                                RULE_UNIT
                            )
                            VALUES 
                            (
                                <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["WRK_OUTPUT_TEMPLATE_NAME"]#" null='#iif(len(responseData.DATA[i]["WRK_OUTPUT_TEMPLATE_NAME"]),DE("no"),DE("yes"))#'>,
                                <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["WRK_OUTPUT_TEMPLATE_PATENT"]#" null='#iif(len(responseData.DATA[i]["WRK_OUTPUT_TEMPLATE_PATENT"]),DE("no"),DE("yes"))#'>,
                                <cfqueryparam cfsqltype="cf_sql_bit" value="#responseData.DATA[i]["IS_ACTIVE"]#" null='#iif(len(responseData.DATA[i]["IS_ACTIVE"]),DE("no"),DE("yes"))#'>,
                                <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["BEST_PRACTISE_CODE"]#" null='#iif(len(responseData.DATA[i]["BEST_PRACTISE_CODE"]),DE("no"),DE("yes"))#'>,
                                <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["OUTPUT_TEMPLATE_DETAIL"]#" null='#iif(len(responseData.DATA[i]["OUTPUT_TEMPLATE_DETAIL"]),DE("no"),DE("yes"))#'>,
                                <cfqueryparam cfsqltype="cf_sql_integer" value="#responseData.DATA[i]["WORKCUBE_PRODUCT_ID"]#" null='#iif(len(responseData.DATA[i]["WORKCUBE_PRODUCT_ID"]),DE("no"),DE("yes"))#'>,
                                <cfqueryparam cfsqltype="cf_sql_integer" value="#responseData.DATA[i]["LICENCE_TYPE"]#" null='#iif(len(responseData.DATA[i]["LICENCE_TYPE"]),DE("no"),DE("yes"))#'>,
                                <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["RELATED_WO"]#" null='#iif(len(responseData.DATA[i]["RELATED_WO"]),DE("no"),DE("yes"))#'>,
                                <cfqueryparam cfsqltype="cf_sql_integer" value="#responseData.DATA[i]["AUTHOR_PARTNER_ID"]#" null='#iif(len(responseData.DATA[i]["AUTHOR_PARTNER_ID"]),DE("no"),DE("yes"))#'>,
                                <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["AUTHOR_NAME"]#" null='#iif(len(responseData.DATA[i]["AUTHOR_NAME"]),DE("no"),DE("yes"))#'>,
                                <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["OUTPUT_TEMPLATE_VIEW_PATH"]#" null='#iif(len(responseData.DATA[i]["OUTPUT_TEMPLATE_VIEW_PATH"]),DE("no"),DE("yes"))#'>,
                                <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["OUTPUT_TEMPLATE_PATH"]#" null='#iif(len(responseData.DATA[i]["OUTPUT_TEMPLATE_PATH"]),DE("no"),DE("yes"))#'>,
                                <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["OUTPUT_TEMPLATE_SECTORS"]#" null='#iif(len(responseData.DATA[i]["OUTPUT_TEMPLATE_SECTORS"]),DE("no"),DE("yes"))#'>,
                                <cfqueryparam cfsqltype="cf_sql_integer" value="#responseData.DATA[i]["WRK_PROCESS_STAGE"]#" null='#iif(len(responseData.DATA[i]["WRK_PROCESS_STAGE"]),DE("no"),DE("yes"))#'>,
                                <cfqueryparam cfsqltype="cf_sql_integer" value="#responseData.DATA[i]["PRINT_TYPE"]#" null='#iif(len(responseData.DATA[i]["PRINT_TYPE"]),DE("no"),DE("yes"))#'>,
                                <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["OUTPUT_TEMPLATE_VERSION"]#" null='#iif(len(responseData.DATA[i]["OUTPUT_TEMPLATE_VERSION"]),DE("no"),DE("yes"))#'>,
                                <cfqueryparam cfsqltype="cf_sql_timestamp" value="#NOW()#">,
                                <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                                <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#cgi.remote_addr#">,
                                <cfqueryparam cfsqltype="cf_sql_bit" value="#responseData.DATA[i]["USE_LOGO"]#" null='#iif(len(responseData.DATA[i]["USE_LOGO"]),DE("no"),DE("yes"))#'>,
                                <cfqueryparam cfsqltype="cf_sql_bit" value="#responseData.DATA[i]["USE_ADRESS"]#" null='#iif(len(responseData.DATA[i]["USE_ADRESS"]),DE("no"),DE("yes"))#'>,
                                <cfqueryparam cfsqltype="cf_sql_float" value="#responseData.DATA[i]["PAGE_WIDTH"]#" null='#iif(len(responseData.DATA[i]["PAGE_WIDTH"]),DE("no"),DE("yes"))#'>,
                                <cfqueryparam cfsqltype="cf_sql_float" value="#responseData.DATA[i]["PAGE_HEIGHT"]#" null='#iif(len(responseData.DATA[i]["PAGE_HEIGHT"]),DE("no"),DE("yes"))#'>,
                                <cfqueryparam cfsqltype="cf_sql_float" value="#responseData.DATA[i]["PAGE_MARGIN_LEFT"]#" null='#iif(len(responseData.DATA[i]["PAGE_MARGIN_LEFT"]),DE("no"),DE("yes"))#'>,
                                <cfqueryparam cfsqltype="cf_sql_float" value="#responseData.DATA[i]["PAGE_MARGIN_RIGHT"]#" null='#iif(len(responseData.DATA[i]["PAGE_MARGIN_RIGHT"]),DE("no"),DE("yes"))#'>,
                                <cfqueryparam cfsqltype="cf_sql_float" value="#responseData.DATA[i]["PAGE_MARGIN_TOP"]#" null='#iif(len(responseData.DATA[i]["PAGE_MARGIN_TOP"]),DE("no"),DE("yes"))#'>,
                                <cfqueryparam cfsqltype="cf_sql_float" value="#responseData.DATA[i]["PAGE_MARGIN_BOTTOM"]#" null='#iif(len(responseData.DATA[i]["PAGE_MARGIN_BOTTOM"]),DE("no"),DE("yes"))#'>,
                                <cfqueryparam cfsqltype="cf_sql_float" value="#responseData.DATA[i]["PAGE_HEADER_HEIGHT"]#" null='#iif(len(responseData.DATA[i]["PAGE_HEADER_HEIGHT"]),DE("no"),DE("yes"))#'>,
                                <cfqueryparam cfsqltype="cf_sql_float" value="#responseData.DATA[i]["PAGE_FOOTER_HEIGHT"]#" null='#iif(len(responseData.DATA[i]["PAGE_FOOTER_HEIGHT"]),DE("no"),DE("yes"))#'>,
                                <cfqueryparam cfsqltype="cf_sql_integer" value="#responseData.DATA[i]["RULE_UNIT"]#" null='#iif(len(responseData.DATA[i]["RULE_UNIT"]),DE("no"),DE("yes"))#'>
                            )
                        END
                    ELSE
                        BEGIN
                            UPDATE WRK_OUTPUT_TEMPLATES
                            SET 
                                WRK_OUTPUT_TEMPLATE_NAME = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["WRK_OUTPUT_TEMPLATE_NAME"]#" null='#iif(len(responseData.DATA[i]["WRK_OUTPUT_TEMPLATE_NAME"]),DE("no"),DE("yes"))#'>,
                                WRK_OUTPUT_TEMPLATE_PATENT = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["WRK_OUTPUT_TEMPLATE_PATENT"]#" null='#iif(len(responseData.DATA[i]["WRK_OUTPUT_TEMPLATE_PATENT"]),DE("no"),DE("yes"))#'>,
                                IS_ACTIVE = <cfqueryparam cfsqltype="cf_sql_bit" value="#responseData.DATA[i]["IS_ACTIVE"]#" null='#iif(len(responseData.DATA[i]["IS_ACTIVE"]),DE("no"),DE("yes"))#'>,
                                BEST_PRACTISE_CODE = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["BEST_PRACTISE_CODE"]#" null='#iif(len(responseData.DATA[i]["BEST_PRACTISE_CODE"]),DE("no"),DE("yes"))#'>,
                                OUTPUT_TEMPLATE_DETAIL = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["OUTPUT_TEMPLATE_DETAIL"]#" null='#iif(len(responseData.DATA[i]["OUTPUT_TEMPLATE_DETAIL"]),DE("no"),DE("yes"))#'>,
                                WORKCUBE_PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#responseData.DATA[i]["WORKCUBE_PRODUCT_ID"]#" null='#iif(len(responseData.DATA[i]["WORKCUBE_PRODUCT_ID"]),DE("no"),DE("yes"))#'>,
                                LICENCE_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#responseData.DATA[i]["LICENCE_TYPE"]#" null='#iif(len(responseData.DATA[i]["LICENCE_TYPE"]),DE("no"),DE("yes"))#'>,
                                RELATED_WO = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["RELATED_WO"]#" null='#iif(len(responseData.DATA[i]["RELATED_WO"]),DE("no"),DE("yes"))#'>,
                                AUTHOR_PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#responseData.DATA[i]["AUTHOR_PARTNER_ID"]#" null='#iif(len(responseData.DATA[i]["AUTHOR_PARTNER_ID"]),DE("no"),DE("yes"))#'>,
                                AUTHOR_NAME = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["AUTHOR_NAME"]#" null='#iif(len(responseData.DATA[i]["AUTHOR_NAME"]),DE("no"),DE("yes"))#'>,
                                OUTPUT_TEMPLATE_VIEW_PATH = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["OUTPUT_TEMPLATE_VIEW_PATH"]#" null='#iif(len(responseData.DATA[i]["OUTPUT_TEMPLATE_VIEW_PATH"]),DE("no"),DE("yes"))#'>,
                                OUTPUT_TEMPLATE_PATH = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["OUTPUT_TEMPLATE_PATH"]#" null='#iif(len(responseData.DATA[i]["OUTPUT_TEMPLATE_PATH"]),DE("no"),DE("yes"))#'>,
                                OUTPUT_TEMPLATE_SECTORS = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["OUTPUT_TEMPLATE_SECTORS"]#" null='#iif(len(responseData.DATA[i]["OUTPUT_TEMPLATE_SECTORS"]),DE("no"),DE("yes"))#'>,
                                WRK_PROCESS_STAGE = <cfqueryparam cfsqltype="cf_sql_integer" value="#responseData.DATA[i]["WRK_PROCESS_STAGE"]#" null='#iif(len(responseData.DATA[i]["WRK_PROCESS_STAGE"]),DE("no"),DE("yes"))#'>,
                                PRINT_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#responseData.DATA[i]["PRINT_TYPE"]#" null='#iif(len(responseData.DATA[i]["PRINT_TYPE"]),DE("no"),DE("yes"))#'>,
                                OUTPUT_TEMPLATE_VERSION = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["OUTPUT_TEMPLATE_VERSION"]#" null='#iif(len(responseData.DATA[i]["OUTPUT_TEMPLATE_VERSION"]),DE("no"),DE("yes"))#'>,
                                UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#NOW()#">,
                                UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                                UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#cgi.remote_addr#">,
                                USE_LOGO = <cfqueryparam cfsqltype="cf_sql_bit" value="#responseData.DATA[i]["USE_LOGO"]#" null='#iif(len(responseData.DATA[i]["USE_LOGO"]),DE("no"),DE("yes"))#'>,
                                USE_ADRESS = <cfqueryparam cfsqltype="cf_sql_bit" value="#responseData.DATA[i]["USE_ADRESS"]#" null='#iif(len(responseData.DATA[i]["USE_ADRESS"]),DE("no"),DE("yes"))#'>,
                                PAGE_WIDTH = <cfqueryparam cfsqltype="cf_sql_float" value="#responseData.DATA[i]["PAGE_WIDTH"]#" null='#iif(len(responseData.DATA[i]["PAGE_WIDTH"]),DE("no"),DE("yes"))#'>,
                                PAGE_HEIGHT = <cfqueryparam cfsqltype="cf_sql_float" value="#responseData.DATA[i]["PAGE_HEIGHT"]#" null='#iif(len(responseData.DATA[i]["PAGE_HEIGHT"]),DE("no"),DE("yes"))#'>,
                                PAGE_MARGIN_LEFT = <cfqueryparam cfsqltype="cf_sql_float" value="#responseData.DATA[i]["PAGE_MARGIN_LEFT"]#" null='#iif(len(responseData.DATA[i]["PAGE_MARGIN_LEFT"]),DE("no"),DE("yes"))#'>,
                                PAGE_MARGIN_RIGHT = <cfqueryparam cfsqltype="cf_sql_float" value="#responseData.DATA[i]["PAGE_MARGIN_RIGHT"]#" null='#iif(len(responseData.DATA[i]["PAGE_MARGIN_RIGHT"]),DE("no"),DE("yes"))#'>,
                                PAGE_MARGIN_TOP = <cfqueryparam cfsqltype="cf_sql_float" value="#responseData.DATA[i]["PAGE_MARGIN_TOP"]#" null='#iif(len(responseData.DATA[i]["PAGE_MARGIN_TOP"]),DE("no"),DE("yes"))#'>,
                                PAGE_MARGIN_BOTTOM = <cfqueryparam cfsqltype="cf_sql_float" value="#responseData.DATA[i]["PAGE_MARGIN_BOTTOM"]#" null='#iif(len(responseData.DATA[i]["PAGE_MARGIN_BOTTOM"]),DE("no"),DE("yes"))#'>,
                                PAGE_HEADER_HEIGHT = <cfqueryparam cfsqltype="cf_sql_float" value="#responseData.DATA[i]["PAGE_HEADER_HEIGHT"]#" null='#iif(len(responseData.DATA[i]["PAGE_HEADER_HEIGHT"]),DE("no"),DE("yes"))#'>,
                                PAGE_FOOTER_HEIGHT = <cfqueryparam cfsqltype="cf_sql_float" value="#responseData.DATA[i]["PAGE_FOOTER_HEIGHT"]#" null='#iif(len(responseData.DATA[i]["PAGE_FOOTER_HEIGHT"]),DE("no"),DE("yes"))#'>,
                                RULE_UNIT = <cfqueryparam cfsqltype="cf_sql_integer" value="#responseData.DATA[i]["RULE_UNIT"]#" null='#iif(len(responseData.DATA[i]["RULE_UNIT"]),DE("no"),DE("yes"))#'>
                            WHERE
                                WRK_OUTPUT_TEMPLATE_ID = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["WRK_OUTPUT_TEMPLATE_ID"]#">
                        END
                </cfquery>
            </cfloop>
        </cfif>
    </cfif>

    <!--- Güncellenen output tepmlatelerin güncellenmesi --->
    <cfset responseData = wroController.getWoLang(typeList:"getUpdatedOutputTemplates",dateRangeValue:attributes.date_range_value_wo)>
    <cfif responseData.STATUS>
        <cfif arraylen(responseData.DATA) gt 0>
            <cfloop index="i" from="1" to="#arraylen(responseData.DATA)#"> 
                <cfquery name="add_r" datasource="#dsn#">
                    UPDATE WRK_OUTPUT_TEMPLATES
                    SET 
                        WRK_OUTPUT_TEMPLATE_NAME = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["WRK_OUTPUT_TEMPLATE_NAME"]#" null='#iif(len(responseData.DATA[i]["WRK_OUTPUT_TEMPLATE_NAME"]),DE("no"),DE("yes"))#'>,
                        WRK_OUTPUT_TEMPLATE_PATENT = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["WRK_OUTPUT_TEMPLATE_PATENT"]#" null='#iif(len(responseData.DATA[i]["WRK_OUTPUT_TEMPLATE_PATENT"]),DE("no"),DE("yes"))#'>,
                        IS_ACTIVE = <cfqueryparam cfsqltype="cf_sql_bit" value="#responseData.DATA[i]["IS_ACTIVE"]#" null='#iif(len(responseData.DATA[i]["IS_ACTIVE"]),DE("no"),DE("yes"))#'>,
                        BEST_PRACTISE_CODE = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["BEST_PRACTISE_CODE"]#" null='#iif(len(responseData.DATA[i]["BEST_PRACTISE_CODE"]),DE("no"),DE("yes"))#'>,
                        OUTPUT_TEMPLATE_DETAIL = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["OUTPUT_TEMPLATE_DETAIL"]#" null='#iif(len(responseData.DATA[i]["OUTPUT_TEMPLATE_DETAIL"]),DE("no"),DE("yes"))#'>,
                        WORKCUBE_PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#responseData.DATA[i]["WORKCUBE_PRODUCT_ID"]#" null='#iif(len(responseData.DATA[i]["WORKCUBE_PRODUCT_ID"]),DE("no"),DE("yes"))#'>,
                        LICENCE_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#responseData.DATA[i]["LICENCE_TYPE"]#" null='#iif(len(responseData.DATA[i]["LICENCE_TYPE"]),DE("no"),DE("yes"))#'>,
                        RELATED_WO = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["RELATED_WO"]#" null='#iif(len(responseData.DATA[i]["RELATED_WO"]),DE("no"),DE("yes"))#'>,
                        AUTHOR_PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#responseData.DATA[i]["AUTHOR_PARTNER_ID"]#" null='#iif(len(responseData.DATA[i]["AUTHOR_PARTNER_ID"]),DE("no"),DE("yes"))#'>,
                        AUTHOR_NAME = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["AUTHOR_NAME"]#" null='#iif(len(responseData.DATA[i]["AUTHOR_NAME"]),DE("no"),DE("yes"))#'>,
                        OUTPUT_TEMPLATE_VIEW_PATH = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["OUTPUT_TEMPLATE_VIEW_PATH"]#" null='#iif(len(responseData.DATA[i]["OUTPUT_TEMPLATE_VIEW_PATH"]),DE("no"),DE("yes"))#'>,
                        OUTPUT_TEMPLATE_PATH = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["OUTPUT_TEMPLATE_PATH"]#" null='#iif(len(responseData.DATA[i]["OUTPUT_TEMPLATE_PATH"]),DE("no"),DE("yes"))#'>,
                        OUTPUT_TEMPLATE_SECTORS = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["OUTPUT_TEMPLATE_SECTORS"]#" null='#iif(len(responseData.DATA[i]["OUTPUT_TEMPLATE_SECTORS"]),DE("no"),DE("yes"))#'>,
                        WRK_PROCESS_STAGE = <cfqueryparam cfsqltype="cf_sql_integer" value="#responseData.DATA[i]["WRK_PROCESS_STAGE"]#" null='#iif(len(responseData.DATA[i]["WRK_PROCESS_STAGE"]),DE("no"),DE("yes"))#'>,
                        PRINT_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#responseData.DATA[i]["PRINT_TYPE"]#" null='#iif(len(responseData.DATA[i]["PRINT_TYPE"]),DE("no"),DE("yes"))#'>,
                        OUTPUT_TEMPLATE_VERSION = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["OUTPUT_TEMPLATE_VERSION"]#" null='#iif(len(responseData.DATA[i]["OUTPUT_TEMPLATE_VERSION"]),DE("no"),DE("yes"))#'>,
                        UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#NOW()#">,
                        UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                        UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#cgi.remote_addr#">,
                        USE_LOGO = <cfqueryparam cfsqltype="cf_sql_bit" value="#responseData.DATA[i]["USE_LOGO"]#" null='#iif(len(responseData.DATA[i]["USE_LOGO"]),DE("no"),DE("yes"))#'>,
                        USE_ADRESS = <cfqueryparam cfsqltype="cf_sql_bit" value="#responseData.DATA[i]["USE_ADRESS"]#" null='#iif(len(responseData.DATA[i]["USE_ADRESS"]),DE("no"),DE("yes"))#'>,
                        PAGE_WIDTH = <cfqueryparam cfsqltype="cf_sql_float" value="#responseData.DATA[i]["PAGE_WIDTH"]#" null='#iif(len(responseData.DATA[i]["PAGE_WIDTH"]),DE("no"),DE("yes"))#'>,
                        PAGE_HEIGHT = <cfqueryparam cfsqltype="cf_sql_float" value="#responseData.DATA[i]["PAGE_HEIGHT"]#" null='#iif(len(responseData.DATA[i]["PAGE_HEIGHT"]),DE("no"),DE("yes"))#'>,
                        PAGE_MARGIN_LEFT = <cfqueryparam cfsqltype="cf_sql_float" value="#responseData.DATA[i]["PAGE_MARGIN_LEFT"]#" null='#iif(len(responseData.DATA[i]["PAGE_MARGIN_LEFT"]),DE("no"),DE("yes"))#'>,
                        PAGE_MARGIN_RIGHT = <cfqueryparam cfsqltype="cf_sql_float" value="#responseData.DATA[i]["PAGE_MARGIN_RIGHT"]#" null='#iif(len(responseData.DATA[i]["PAGE_MARGIN_RIGHT"]),DE("no"),DE("yes"))#'>,
                        PAGE_MARGIN_TOP = <cfqueryparam cfsqltype="cf_sql_float" value="#responseData.DATA[i]["PAGE_MARGIN_TOP"]#" null='#iif(len(responseData.DATA[i]["PAGE_MARGIN_TOP"]),DE("no"),DE("yes"))#'>,
                        PAGE_MARGIN_BOTTOM = <cfqueryparam cfsqltype="cf_sql_float" value="#responseData.DATA[i]["PAGE_MARGIN_BOTTOM"]#" null='#iif(len(responseData.DATA[i]["PAGE_MARGIN_BOTTOM"]),DE("no"),DE("yes"))#'>,
                        PAGE_HEADER_HEIGHT = <cfqueryparam cfsqltype="cf_sql_float" value="#responseData.DATA[i]["PAGE_HEADER_HEIGHT"]#" null='#iif(len(responseData.DATA[i]["PAGE_HEADER_HEIGHT"]),DE("no"),DE("yes"))#'>,
                        PAGE_FOOTER_HEIGHT = <cfqueryparam cfsqltype="cf_sql_float" value="#responseData.DATA[i]["PAGE_FOOTER_HEIGHT"]#" null='#iif(len(responseData.DATA[i]["PAGE_FOOTER_HEIGHT"]),DE("no"),DE("yes"))#'>,
                        RULE_UNIT = <cfqueryparam cfsqltype="cf_sql_integer" value="#responseData.DATA[i]["RULE_UNIT"]#" null='#iif(len(responseData.DATA[i]["RULE_UNIT"]),DE("no"),DE("yes"))#'>
                    WHERE
                        WRK_OUTPUT_TEMPLATE_ID = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["WRK_OUTPUT_TEMPLATE_ID"]#">
                </cfquery>
            </cfloop>
        </cfif>
    </cfif>
</cfif>

<!--- Process Template upgrade --->
<cfif isDefined("attributes.Process_Templates") and attributes.Process_Templates eq 1>
    <!--- Yeni eklenen process templatelerin eklenmesi --->
    <cfset responseData = wroController.getWoLang(typeList:"getNewProcessTemplates",dateRangeValue:attributes.date_range_value_wo)>
    <cfif responseData.STATUS>
        <cfif arraylen(responseData.DATA) gt 0>
            <cfloop index="i" from="1" to="#arraylen(responseData.DATA)#">
                <cfquery name="add_r" datasource="#dsn#">
                    IF NOT EXISTS( SELECT WRK_PROCESS_TEMPLATE_ID FROM WRK_PROCESS_TEMPLATES WHERE WRK_PROCESS_TEMPLATE_ID = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["WRK_PROCESS_TEMPLATE_ID"]#">)
                        BEGIN
                            INSERT INTO WRK_PROCESS_TEMPLATES
                            (
                                WRK_PROCESS_TEMPLATE_NAME,
                                IS_ACTIVE,
                                IS_ACTION,
                                IS_DISPLAY,
                                IS_STAGE,
                                IS_MAIN,
                                BEST_PRACTISE_CODE,
                                PROCESS_TEMPLATE_DETAIL,
                                WORKCUBE_PRODUCT_ID,
                                LICENCE_TYPE,
                                RELATED_WO,
                                AUTHOR_PARTNER_ID,
                                AUTHOR_NAME,
                                PROCESS_TEMPLATE_ICON_PATH,
                                PROCESS_TEMPLATE_PATH,
                                PROCESS_TEMPLATE_SECTORS,
                                WRK_PROCESS_STAGE,
                                MODULE_ID,
                                PROCESS_TEMPLATE_VERSION,
                                RECORD_DATE,
                                RECORD_EMP,
                                RECORD_IP
                            )
                            VALUES 
                            (
                                <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["WRK_PROCESS_TEMPLATE_NAME"]#" null='#iif(len(responseData.DATA[i]["WRK_PROCESS_TEMPLATE_NAME"]),DE("no"),DE("yes"))#'>,
                                <cfqueryparam cfsqltype="cf_sql_bit" value="#responseData.DATA[i]["IS_ACTIVE"]#" null='#iif(len(responseData.DATA[i]["IS_ACTIVE"]),DE("no"),DE("yes"))#'>,
                                <cfqueryparam cfsqltype="cf_sql_bit" value="#responseData.DATA[i]["IS_ACTION"]#" null='#iif(len(responseData.DATA[i]["IS_ACTION"]),DE("no"),DE("yes"))#'>,
                                <cfqueryparam cfsqltype="cf_sql_bit" value="#responseData.DATA[i]["IS_DISPLAY"]#" null='#iif(len(responseData.DATA[i]["IS_DISPLAY"]),DE("no"),DE("yes"))#'>,
                                <cfqueryparam cfsqltype="cf_sql_bit" value="#responseData.DATA[i]["IS_STAGE"]#" null='#iif(len(responseData.DATA[i]["IS_STAGE"]),DE("no"),DE("yes"))#'>,
                                <cfqueryparam cfsqltype="cf_sql_bit" value="#responseData.DATA[i]["IS_MAIN"]#" null='#iif(len(responseData.DATA[i]["IS_MAIN"]),DE("no"),DE("yes"))#'>,
                                <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["BEST_PRACTISE_CODE"]#" null='#iif(len(responseData.DATA[i]["BEST_PRACTISE_CODE"]),DE("no"),DE("yes"))#'>,
                                <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["PROCESS_TEMPLATE_DETAIL"]#" null='#iif(len(responseData.DATA[i]["PROCESS_TEMPLATE_DETAIL"]),DE("no"),DE("yes"))#'>,
                                <cfqueryparam cfsqltype="cf_sql_integer" value="#responseData.DATA[i]["WORKCUBE_PRODUCT_ID"]#" null='#iif(len(responseData.DATA[i]["WORKCUBE_PRODUCT_ID"]),DE("no"),DE("yes"))#'>,
                                <cfqueryparam cfsqltype="cf_sql_integer" value="#responseData.DATA[i]["LICENCE_TYPE"]#" null='#iif(len(responseData.DATA[i]["LICENCE_TYPE"]),DE("no"),DE("yes"))#'>,
                                <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["RELATED_WO"]#" null='#iif(len(responseData.DATA[i]["RELATED_WO"]),DE("no"),DE("yes"))#'>,
                                <cfqueryparam cfsqltype="cf_sql_integer" value="#responseData.DATA[i]["AUTHOR_PARTNER_ID"]#" null='#iif(len(responseData.DATA[i]["AUTHOR_PARTNER_ID"]),DE("no"),DE("yes"))#'>,
                                <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["AUTHOR_NAME"]#" null='#iif(len(responseData.DATA[i]["AUTHOR_NAME"]),DE("no"),DE("yes"))#'>,
                                <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["PROCESS_TEMPLATE_ICON_PATH"]#" null='#iif(len(responseData.DATA[i]["PROCESS_TEMPLATE_ICON_PATH"]),DE("no"),DE("yes"))#'>,
                                <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["PROCESS_TEMPLATE_PATH"]#" null='#iif(len(responseData.DATA[i]["PROCESS_TEMPLATE_PATH"]),DE("no"),DE("yes"))#'>,
                                <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["PROCESS_TEMPLATE_SECTORS"]#" null='#iif(len(responseData.DATA[i]["PROCESS_TEMPLATE_SECTORS"]),DE("no"),DE("yes"))#'>,
                                <cfqueryparam cfsqltype="cf_sql_integer" value="#responseData.DATA[i]["WRK_PROCESS_STAGE"]#" null='#iif(len(responseData.DATA[i]["WRK_PROCESS_STAGE"]),DE("no"),DE("yes"))#'>,
                                <cfqueryparam cfsqltype="cf_sql_integer" value="#responseData.DATA[i]["MODULE_ID"]#" null='#iif(len(responseData.DATA[i]["MODULE_ID"]),DE("no"),DE("yes"))#'>,
                                <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["PROCESS_TEMPLATE_VERSION"]#" null='#iif(len(responseData.DATA[i]["PROCESS_TEMPLATE_VERSION"]),DE("no"),DE("yes"))#'>,
                                <cfqueryparam cfsqltype="cf_sql_timestamp" value="#NOW()#">,
                                <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                                <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#cgi.remote_addr#">
                            )
                        END
                    ELSE
                        BEGIN
                            UPDATE WRK_PROCESS_TEMPLATES
                            SET 
                                WRK_PROCESS_TEMPLATE_NAME = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["WRK_PROCESS_TEMPLATE_NAME"]#" null='#iif(len(responseData.DATA[i]["WRK_PROCESS_TEMPLATE_NAME"]),DE("no"),DE("yes"))#'>,
                                IS_ACTIVE = <cfqueryparam cfsqltype="cf_sql_bit" value="#responseData.DATA[i]["IS_ACTIVE"]#" null='#iif(len(responseData.DATA[i]["IS_ACTIVE"]),DE("no"),DE("yes"))#'>,
                                IS_ACTION = <cfqueryparam cfsqltype="cf_sql_bit" value="#responseData.DATA[i]["IS_ACTION"]#" null='#iif(len(responseData.DATA[i]["IS_ACTION"]),DE("no"),DE("yes"))#'>,
                                IS_DISPLAY = <cfqueryparam cfsqltype="cf_sql_bit" value="#responseData.DATA[i]["IS_DISPLAY"]#" null='#iif(len(responseData.DATA[i]["IS_DISPLAY"]),DE("no"),DE("yes"))#'>,
                                IS_STAGE = <cfqueryparam cfsqltype="cf_sql_bit" value="#responseData.DATA[i]["IS_STAGE"]#" null='#iif(len(responseData.DATA[i]["IS_STAGE"]),DE("no"),DE("yes"))#'>,
                                IS_MAIN = <cfqueryparam cfsqltype="cf_sql_bit" value="#responseData.DATA[i]["IS_MAIN"]#" null='#iif(len(responseData.DATA[i]["IS_MAIN"]),DE("no"),DE("yes"))#'>,
                                BEST_PRACTISE_CODE = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["BEST_PRACTISE_CODE"]#" null='#iif(len(responseData.DATA[i]["BEST_PRACTISE_CODE"]),DE("no"),DE("yes"))#'>,
                                PROCESS_TEMPLATE_DETAIL = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["PROCESS_TEMPLATE_DETAIL"]#" null='#iif(len(responseData.DATA[i]["PROCESS_TEMPLATE_DETAIL"]),DE("no"),DE("yes"))#'>,
                                WORKCUBE_PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#responseData.DATA[i]["WORKCUBE_PRODUCT_ID"]#" null='#iif(len(responseData.DATA[i]["WORKCUBE_PRODUCT_ID"]),DE("no"),DE("yes"))#'>,
                                LICENCE_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#responseData.DATA[i]["LICENCE_TYPE"]#" null='#iif(len(responseData.DATA[i]["LICENCE_TYPE"]),DE("no"),DE("yes"))#'>,
                                RELATED_WO = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["RELATED_WO"]#" null='#iif(len(responseData.DATA[i]["RELATED_WO"]),DE("no"),DE("yes"))#'>,
                                AUTHOR_PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#responseData.DATA[i]["AUTHOR_PARTNER_ID"]#" null='#iif(len(responseData.DATA[i]["AUTHOR_PARTNER_ID"]),DE("no"),DE("yes"))#'>,
                                AUTHOR_NAME = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["AUTHOR_NAME"]#" null='#iif(len(responseData.DATA[i]["AUTHOR_NAME"]),DE("no"),DE("yes"))#'>,
                                PROCESS_TEMPLATE_ICON_PATH = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["PROCESS_TEMPLATE_ICON_PATH"]#" null='#iif(len(responseData.DATA[i]["PROCESS_TEMPLATE_ICON_PATH"]),DE("no"),DE("yes"))#'>,
                                PROCESS_TEMPLATE_PATH = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["PROCESS_TEMPLATE_PATH"]#" null='#iif(len(responseData.DATA[i]["PROCESS_TEMPLATE_PATH"]),DE("no"),DE("yes"))#'>,
                                PROCESS_TEMPLATE_SECTORS = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["PROCESS_TEMPLATE_SECTORS"]#" null='#iif(len(responseData.DATA[i]["PROCESS_TEMPLATE_SECTORS"]),DE("no"),DE("yes"))#'>,
                                WRK_PROCESS_STAGE = <cfqueryparam cfsqltype="cf_sql_integer" value="#responseData.DATA[i]["WRK_PROCESS_STAGE"]#" null='#iif(len(responseData.DATA[i]["WRK_PROCESS_STAGE"]),DE("no"),DE("yes"))#'>,
                                MODULE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#responseData.DATA[i]["MODULE_ID"]#" null='#iif(len(responseData.DATA[i]["MODULE_ID"]),DE("no"),DE("yes"))#'>,
                                PROCESS_TEMPLATE_VERSION = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["PROCESS_TEMPLATE_VERSION"]#" null='#iif(len(responseData.DATA[i]["PROCESS_TEMPLATE_VERSION"]),DE("no"),DE("yes"))#'>,
                                UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#NOW()#">,
                                UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                                UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#cgi.remote_addr#">
                            WHERE
                                WRK_PROCESS_TEMPLATE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#responseData.DATA[i]["WRK_PROCESS_TEMPLATE_ID"]#">
                        END
                </cfquery>
            </cfloop>
        </cfif>
    </cfif>

    <!--- Güncellenen process tepmlatelerin güncellenmesi --->
    <cfset responseData = wroController.getWoLang(typeList:"getUpdatedProcessTemplates",dateRangeValue:attributes.date_range_value_wo)>
    <cfif responseData.STATUS>
        <cfif arraylen(responseData.DATA) gt 0>
            <cfloop index="i" from="1" to="#arraylen(responseData.DATA)#"> 
                <cfquery name="add_r" datasource="#dsn#">
                    UPDATE WRK_PROCESS_TEMPLATES
                    SET 
                        WRK_PROCESS_TEMPLATE_NAME = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["WRK_PROCESS_TEMPLATE_NAME"]#" null='#iif(len(responseData.DATA[i]["WRK_PROCESS_TEMPLATE_NAME"]),DE("no"),DE("yes"))#'>,
                        IS_ACTIVE = <cfqueryparam cfsqltype="cf_sql_bit" value="#responseData.DATA[i]["IS_ACTIVE"]#" null='#iif(len(responseData.DATA[i]["IS_ACTIVE"]),DE("no"),DE("yes"))#'>,
                        IS_ACTION = <cfqueryparam cfsqltype="cf_sql_bit" value="#responseData.DATA[i]["IS_ACTION"]#" null='#iif(len(responseData.DATA[i]["IS_ACTION"]),DE("no"),DE("yes"))#'>,
                        IS_DISPLAY = <cfqueryparam cfsqltype="cf_sql_bit" value="#responseData.DATA[i]["IS_DISPLAY"]#" null='#iif(len(responseData.DATA[i]["IS_DISPLAY"]),DE("no"),DE("yes"))#'>,
                        IS_STAGE = <cfqueryparam cfsqltype="cf_sql_bit" value="#responseData.DATA[i]["IS_STAGE"]#" null='#iif(len(responseData.DATA[i]["IS_STAGE"]),DE("no"),DE("yes"))#'>,
                        IS_MAIN = <cfqueryparam cfsqltype="cf_sql_bit" value="#responseData.DATA[i]["IS_MAIN"]#" null='#iif(len(responseData.DATA[i]["IS_MAIN"]),DE("no"),DE("yes"))#'>,
                        BEST_PRACTISE_CODE = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["BEST_PRACTISE_CODE"]#" null='#iif(len(responseData.DATA[i]["BEST_PRACTISE_CODE"]),DE("no"),DE("yes"))#'>,
                        PROCESS_TEMPLATE_DETAIL = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["PROCESS_TEMPLATE_DETAIL"]#" null='#iif(len(responseData.DATA[i]["PROCESS_TEMPLATE_DETAIL"]),DE("no"),DE("yes"))#'>,
                        WORKCUBE_PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#responseData.DATA[i]["WORKCUBE_PRODUCT_ID"]#" null='#iif(len(responseData.DATA[i]["WORKCUBE_PRODUCT_ID"]),DE("no"),DE("yes"))#'>,
                        LICENCE_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#responseData.DATA[i]["LICENCE_TYPE"]#" null='#iif(len(responseData.DATA[i]["LICENCE_TYPE"]),DE("no"),DE("yes"))#'>,
                        RELATED_WO = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["RELATED_WO"]#" null='#iif(len(responseData.DATA[i]["RELATED_WO"]),DE("no"),DE("yes"))#'>,
                        AUTHOR_PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#responseData.DATA[i]["AUTHOR_PARTNER_ID"]#" null='#iif(len(responseData.DATA[i]["AUTHOR_PARTNER_ID"]),DE("no"),DE("yes"))#'>,
                        AUTHOR_NAME = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["AUTHOR_NAME"]#" null='#iif(len(responseData.DATA[i]["AUTHOR_NAME"]),DE("no"),DE("yes"))#'>,
                        PROCESS_TEMPLATE_ICON_PATH = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["PROCESS_TEMPLATE_ICON_PATH"]#" null='#iif(len(responseData.DATA[i]["PROCESS_TEMPLATE_ICON_PATH"]),DE("no"),DE("yes"))#'>,
                        PROCESS_TEMPLATE_PATH = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["PROCESS_TEMPLATE_PATH"]#" null='#iif(len(responseData.DATA[i]["PROCESS_TEMPLATE_PATH"]),DE("no"),DE("yes"))#'>,
                        PROCESS_TEMPLATE_SECTORS = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["PROCESS_TEMPLATE_SECTORS"]#" null='#iif(len(responseData.DATA[i]["PROCESS_TEMPLATE_SECTORS"]),DE("no"),DE("yes"))#'>,
                        WRK_PROCESS_STAGE = <cfqueryparam cfsqltype="cf_sql_integer" value="#responseData.DATA[i]["WRK_PROCESS_STAGE"]#" null='#iif(len(responseData.DATA[i]["WRK_PROCESS_STAGE"]),DE("no"),DE("yes"))#'>,
                        MODULE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#responseData.DATA[i]["MODULE_ID"]#" null='#iif(len(responseData.DATA[i]["MODULE_ID"]),DE("no"),DE("yes"))#'>,
                        PROCESS_TEMPLATE_VERSION = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#responseData.DATA[i]["PROCESS_TEMPLATE_VERSION"]#" null='#iif(len(responseData.DATA[i]["PROCESS_TEMPLATE_VERSION"]),DE("no"),DE("yes"))#'>,
                        UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#NOW()#">,
                        UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                        UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#cgi.remote_addr#">
                    WHERE
                        WRK_PROCESS_TEMPLATE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#responseData.DATA[i]["WRK_PROCESS_TEMPLATE_ID"]#">
                </cfquery>
            </cfloop>
        </cfif>
    </cfif>
</cfif>