<cfparam name="attributes.allCompanySave" default="0">

<cfif isdefined("attributes.isDelFromDet") and attributes.isDelFromDet eq 1>
    <cfquery name="DEL_DB" datasource="#DSN#">
        DELETE FROM MODIFIED_PAGE WHERE COMPANY_ID = #session.ep.company_id# AND CONTROLLER_NAME = '#attributes.controllerName#' AND EVENT_LIST='detSort'
    </cfquery>
<cfelse>
	<cfif isdefined('attributes.fromModified') and attributes.fromModified eq 0>
        <cfif attributes.allCompanySave	eq 1><!--- Düzenleme Tüm Şirketlerde Yapılır --->
            <cfquery name="ALL_COMP" datasource="#DSN#">
                SELECT COMP_ID FROM OUR_COMPANY
            </cfquery>                        
            <cfloop query="ALL_COMP">
                <cfquery name="DEL_DB_ALL" datasource="#DSN#">
                    DELETE FROM MODIFIED_PAGE WHERE COMPANY_ID = #COMP_ID# AND CONTROLLER_NAME = '#attributes.controllerName#' AND EVENT_LIST='#attributes.eventlist#' AND JSON_TYPE IS NULL
                </cfquery>
            </cfloop>
        <cfelse>
            <cfquery name="DEL_DB" datasource="#DSN#">
                DELETE FROM MODIFIED_PAGE WHERE COMPANY_ID = #session.ep.company_id# AND CONTROLLER_NAME = '#attributes.controllerName#' AND EVENT_LIST='#attributes.eventlist#'
            </cfquery>
        </cfif> 
    <cfelse>
        <cfif isdefined("form.modifieData") and len(form.modifieData)><!--- Ekran üzerinden kolonlar arasındaki yer değişiklikleri yetkiler burada düzenleniyor. --->
            <cfset modifieData = DeserializeJSON(URLDecode(form.modifieData, "utf-8"))>
            <cfquery name="getModifiedPage" datasource="#DSN#">
                SELECT RECORD_EMP, RECORD_DATE, RECORD_IP FROM MODIFIED_PAGE WHERE COMPANY_ID = #session.ep.company_id# AND CONTROLLER_NAME = '#attributes.controllerName#' AND EVENT_LIST='#attributes.eventlist#'
            </cfquery>
            <cfif attributes.allCompanySave	eq 1><!--- Düzenleme Tüm Şirketlerde Yapılır --->
                <cfquery name="ALL_COMP" datasource="#DSN#">
                    SELECT COMP_ID FROM OUR_COMPANY
                </cfquery>                        
                <cfloop query="ALL_COMP">
                    <cfquery name="DEL_DB_ALL" datasource="#DSN#">
                        DELETE FROM MODIFIED_PAGE WHERE COMPANY_ID = #COMP_ID# AND CONTROLLER_NAME = '#attributes.controllerName#' AND EVENT_LIST='#attributes.eventlist#'
                    </cfquery>
                </cfloop>
            <cfelse>
                <cfquery name="DEL_DB" datasource="#DSN#">
                    DELETE FROM MODIFIED_PAGE WHERE COMPANY_ID = #session.ep.company_id# AND CONTROLLER_NAME = '#attributes.controllerName#' AND EVENT_LIST='#attributes.eventlist#'
                </cfquery>
            </cfif> 
            <cfloop collection="#modifieData#" item="ind">
                <cfif ind is 'positions'>
                    <cfloop index="ind2" from="1" to="#arrayLen(modifieData.positions)#">
                        <cfif left(serializeJson(modifieData.positions[ind2]), 2) is "//">
                            <cfset data_ = mid(serializeJson(modifieData.positions[ind2]), 3, len(serializeJson(modifieData.positions[ind2])) - 2)>
                        <cfelse>
                            <cfset data_ = serializeJson(modifieData.positions[ind2])>
                        </cfif>
                        <cfset positionCode = Replace(Replace(listFirst(data_,':'),'{','','all'),'"','','all')>
                        <cfif attributes.allCompanySave	eq 1><!--- Düzenleme Tüm Şirketlerde Yapılır --->
                            <cfquery name="ALL_COMP" datasource="#DSN#">
                                SELECT COMP_ID FROM OUR_COMPANY
                            </cfquery>                        
                            <cfloop query="ALL_COMP">
                                <cfquery name="INSERT_DB_ALL" datasource="#DSN#">
                                    INSERT INTO
                                        MODIFIED_PAGE
                                    (
                                        CONTROLLER_NAME,
                                        EVENT_LIST,
                                        COMPANY_ID,
                                        PERIOD_ID,
                                        POSITION_CODE,
                                        JSON_DATA,
                                        RECORD_DATE,
                                        RECORD_IP,
                                        RECORD_EMP
                                        <cfif getModifiedPage.recordCount gt 0>
                                            ,UPDATE_DATE,
                                            UPDATE_IP,
                                            UPDATE_EMP
                                        </cfif>
                                    )
                                    VALUES
                                    (
                                        '#attributes.controllerName#',
                                        '#attributes.eventlist#',
                                        #COMP_ID#,
                                        #session.ep.period_id#,
                                        #positionCode#,
                                        '#data_#',
                                        <cfif getModifiedPage.recordCount gt 0>
                                            <cfqueryparam cfsqltype="cf_sql_timestamp" value="#getModifiedPage.RECORD_DATE#">,
                                            <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#getModifiedPage.RECORD_IP#">,
                                            <cfqueryparam cfsqltype="cf_sql_integer" value="#getModifiedPage.RECORD_EMP#">,
                                            #now()#,
                                            '#CGI.REMOTE_ADDR#',
                                            #session.ep.userid#
                                        <cfelse>
                                            #now()#,
                                            '#CGI.REMOTE_ADDR#',
                                            #session.ep.userid#
                                        </cfif>
                                    )
                                </cfquery>
                            </cfloop>
                        <cfelse>
                            <cfquery name="INSERT_DB" datasource="#DSN#">
                                INSERT INTO
                                    MODIFIED_PAGE
                                (
                                    CONTROLLER_NAME,
                                    EVENT_LIST,
                                    COMPANY_ID,
                                    PERIOD_ID,
                                    POSITION_CODE,
                                    JSON_DATA,
                                    RECORD_DATE,
                                    RECORD_IP,
                                    RECORD_EMP
                                    <cfif getModifiedPage.recordCount gt 0>
                                        ,UPDATE_DATE,
                                        UPDATE_IP,
                                        UPDATE_EMP
                                    </cfif>
                                )
                                VALUES
                                (
                                    '#attributes.controllerName#',
                                    '#attributes.eventlist#',
                                    #session.ep.company_id#,
                                    #session.ep.period_id#,
                                    #positionCode#,
                                    '#data_#',
                                    <cfif getModifiedPage.recordCount gt 0>
                                        <cfqueryparam cfsqltype="cf_sql_timestamp" value="#getModifiedPage.RECORD_DATE#">,
                                        <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#getModifiedPage.RECORD_IP#">,
                                        <cfqueryparam cfsqltype="cf_sql_integer" value="#getModifiedPage.RECORD_EMP#">,
                                        #now()#,
                                        '#CGI.REMOTE_ADDR#',
                                        #session.ep.userid#
                                    <cfelse>
                                        #now()#,
                                        '#CGI.REMOTE_ADDR#',
                                        #session.ep.userid#
                                    </cfif>
                                )
                            </cfquery>
                        </cfif>                        
                    </cfloop>
                <cfelseif ind is 'all'>
                    <cfif left(serializeJson(modifieData.all), 2) is "//">
                        <cfset data_ = mid(serializeJson(modifieData.all), 3, len(serializeJson(modifieData.all)) - 2)>
                    <cfelse>
                        <cfset data_ = serializeJson(modifieData.all)>
                    </cfif>
                    
                    <cfif attributes.allCompanySave	eq 1><!--- Düzenleme Tüm Şirketlerde Yapılır --->
                        <cfquery name="ALL_COMP" datasource="#DSN#">
                            SELECT COMP_ID FROM OUR_COMPANY
                        </cfquery>                        
                        <cfloop query="ALL_COMP">
                            <cfquery name="INSERT_DB_ALL" datasource="#DSN#">
                                INSERT INTO
                                    MODIFIED_PAGE
                                (
                                    CONTROLLER_NAME,
                                    EVENT_LIST,
                                    COMPANY_ID,
                                    PERIOD_ID,
                                    POSITION_CODE,
                                    JSON_DATA,
                                    RECORD_DATE,
                                    RECORD_IP,
                                    RECORD_EMP
                                    <cfif getModifiedPage.recordCount gt 0>
                                        ,UPDATE_DATE,
                                        UPDATE_IP,
                                        UPDATE_EMP
                                    </cfif>
                                )
                                VALUES
                                (
                                    '#attributes.controllerName#',
                                    '#attributes.eventlist#',
                                    #COMP_ID#,
                                    #session.ep.period_id#,
                                    0,
                                    '#data_#',
                                    <cfif getModifiedPage.recordCount gt 0>
                                        <cfqueryparam cfsqltype="cf_sql_timestamp" value="#getModifiedPage.RECORD_DATE#">,
                                        <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#getModifiedPage.RECORD_IP#">,
                                        <cfqueryparam cfsqltype="cf_sql_integer" value="#getModifiedPage.RECORD_EMP#">,
                                        #now()#,
                                        '#CGI.REMOTE_ADDR#',
                                        #session.ep.userid#
                                    <cfelse>
                                        #now()#,
                                        '#CGI.REMOTE_ADDR#',
                                        #session.ep.userid#
                                    </cfif>
                                )
                            </cfquery>
                        </cfloop>
                    <cfelse>                    
                        <cfquery name="INSERT_DB" datasource="#DSN#">
                            INSERT INTO
                                MODIFIED_PAGE
                            (
                                CONTROLLER_NAME,
                                EVENT_LIST,
                                COMPANY_ID,
                                PERIOD_ID,
                                POSITION_CODE,
                                JSON_DATA,
                                RECORD_DATE,
                                RECORD_IP,
                                RECORD_EMP
                                <cfif getModifiedPage.recordCount gt 0>
                                    ,UPDATE_DATE,
                                    UPDATE_IP,
                                    UPDATE_EMP
                                </cfif>
                            )
                            VALUES
                            (
                                '#attributes.controllerName#',
                                '#attributes.eventlist#',
                                #session.ep.company_id#,
                                #session.ep.period_id#,
                                0,
                                '#data_#',
                                <cfif getModifiedPage.recordCount gt 0>
                                    <cfqueryparam cfsqltype="cf_sql_timestamp" value="#getModifiedPage.RECORD_DATE#">,
                                    <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#getModifiedPage.RECORD_IP#">,
                                    <cfqueryparam cfsqltype="cf_sql_integer" value="#getModifiedPage.RECORD_EMP#">,
                                    #now()#,
                                    '#CGI.REMOTE_ADDR#',
                                    #session.ep.userid#
                                <cfelse>
                                    #now()#,
                                    '#CGI.REMOTE_ADDR#',
                                    #session.ep.userid#
                                </cfif>
                            )
                        </cfquery>
                    </cfif>
                <cfelseif ind is 'column'>
                    <cfif left(serializeJson(modifieData.column), 2) is "//">
                        <cfset data_ = mid(serializeJson(modifieData.column), 3, len(serializeJson(modifieData.column)) - 2)>
                    <cfelse>
                        <cfset data_ = serializeJson(modifieData.column)>
                    </cfif>
                    <cfif attributes.allCompanySave	eq 1><!--- Düzenleme Tüm Şirketlerde Yapılır --->
                        <cfquery name="ALL_COMP" datasource="#DSN#">
                            SELECT COMP_ID FROM OUR_COMPANY
                        </cfquery>                        
                        <cfloop query="ALL_COMP">
                            <cfquery name="INSERT_DB_ALL" datasource="#DSN#">
                                INSERT INTO
                                    MODIFIED_PAGE
                                (
                                    CONTROLLER_NAME,
                                    EVENT_LIST,
                                    COMPANY_ID,
                                    PERIOD_ID,
                                    POSITION_CODE,
                                    JSON_DATA,
                                    RECORD_DATE,
                                    RECORD_IP,
                                    RECORD_EMP
                                    <cfif getModifiedPage.recordCount gt 0>
                                        ,UPDATE_DATE,
                                        UPDATE_IP,
                                        UPDATE_EMP
                                    </cfif>
                                )
                                VALUES
                                (
                                    '#attributes.controllerName#',
                                    '#attributes.eventlist#',
                                    #COMP_ID#,
                                    #session.ep.period_id#,
                                    -1,
                                    '#data_#',
                                    <cfif getModifiedPage.recordCount gt 0>
                                        <cfqueryparam cfsqltype="cf_sql_timestamp" value="#getModifiedPage.RECORD_DATE#">,
                                        <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#getModifiedPage.RECORD_IP#">,
                                        <cfqueryparam cfsqltype="cf_sql_integer" value="#getModifiedPage.RECORD_EMP#">,
                                        #now()#,
                                        '#CGI.REMOTE_ADDR#',
                                        #session.ep.userid#
                                    <cfelse>
                                        #now()#,
                                        '#CGI.REMOTE_ADDR#',
                                        #session.ep.userid#
                                    </cfif>
                                )
                            </cfquery>
                        </cfloop>
                    <cfelse>
                        <cfquery name="INSERT_DB" datasource="#DSN#">
                            INSERT INTO
                                MODIFIED_PAGE
                            (
                                CONTROLLER_NAME,
                                EVENT_LIST,
                                COMPANY_ID,
                                PERIOD_ID,
                                POSITION_CODE,
                                JSON_DATA,
                                RECORD_DATE,
                                RECORD_IP,
                                RECORD_EMP
                                <cfif getModifiedPage.recordCount gt 0>
                                    ,UPDATE_DATE,
                                    UPDATE_IP,
                                    UPDATE_EMP
                                </cfif>
                            )
                            VALUES
                            (
                                '#attributes.controllerName#',
                                '#attributes.eventlist#',
                                #session.ep.company_id#,
                                #session.ep.period_id#,
                                -1,
                                '#data_#',
                                <cfif getModifiedPage.recordCount gt 0>
                                    <cfqueryparam cfsqltype="cf_sql_timestamp" value="#getModifiedPage.RECORD_DATE#">,
                                    <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#getModifiedPage.RECORD_IP#">,
                                    <cfqueryparam cfsqltype="cf_sql_integer" value="#getModifiedPage.RECORD_EMP#">,
                                    #now()#,
                                    '#CGI.REMOTE_ADDR#',
                                    #session.ep.userid#
                                <cfelse>
                                    #now()#,
                                    '#CGI.REMOTE_ADDR#',
                                    #session.ep.userid#
                                </cfif>
                            )
                        </cfquery>
                    </cfif> 
                </cfif>
            </cfloop>
        <cfelse>
            <cfset attributes.JsonDataFormBuilder = Replace(form.formElements,'{"fields":','')>
            <cfset attributes.JsonDataFormBuilder = left(attributes.JsonDataFormBuilder,len(attributes.JsonDataFormBuilder)-1)>
            
            <cfset attributes.woStructEvents = DeserializeJSON(URLDecode(attributes.extendWoStruct, "utf-8"))>
            
            <cfset formElements = DeserializeJSON(form.formElements)>
            <cfloop collection="#formElements#" item='k'>
                <cfif k is 'fields'>
                    <cfloop from="1" to="#arrayLen(formElements[k])#" index="element">
                        <cfloop collection="#formElements[k][element]#" item="elementItem">
                            <cfif elementItem is 'field_options'>
                                <cfloop collection="#formElements[k][element]['field_options']#" item="elementOptions">
                                    <cfif elementOptions is 'maxlength'>
                                        <cfset attributes["maxlength#element#"] = formElements[k][element]['field_options'][elementOptions]>
                                    <cfelseif elementOptions is 'minlength'>
                                        <cfset attributes["minlength#element#"] = formElements[k][element]['field_options'][elementOptions]>
                                    <cfelseif elementOptions is 'size'>
                                        <cfset attributes["size#element#"] = formElements[k][element]['field_options'][elementOptions]>
                                    <cfelseif elementOptions is 'include_blank_option'>
                                        <cfset attributes["include_blank_option#element#"] = formElements[k][element]['field_options'][elementOptions]>
                                    <cfelseif elementOptions is 'multiple'>
                                        <cfset attributes["multiple#element#"] = formElements[k][element]['field_options'][elementOptions]>
                                    <cfelseif elementOptions is 'description'>
                                        <cfset attributes["description#element#"] = formElements[k][element]['field_options'][elementOptions]>
                                    <cfelseif elementOptions is 'options'>
                                        <cfloop from="1" to="#arrayLen(formElements[k][element]['field_options']['options'])#" index="index">
                                            <cfloop collection="#formElements[k][element]['field_options']['options'][index]#" item="indexLast">
                                                <cfif indexLast is 'checked'>
                                                    <cfif not isdefined("attributes.checkedList#element#")>
                                                        <cfset attributes["checkedList#element#"] = formElements[k][element]['field_options']['options'][index]['checked']>
                                                    <cfelse>
                                                        <cfset attributes["checkedList#element#"] = attributes["checkedList#element#"] & ',' & formElements[k][element]['field_options']['options'][index]['checked']>
                                                    </cfif>
                                                <cfelseif indexLast is 'label'>
                                                    <cfif not isdefined("attributes.labelList#element#")>
                                                        <cfset attributes["labelList#element#"] = formElements[k][element]['field_options']['options'][index]['label']>
                                                    <cfelse>
                                                        <cfset attributes["labelList#element#"] = attributes["labelList#element#"] & ',' & formElements[k][element]['field_options']['options'][index]['label']>
                                                    </cfif>
                                                <cfelseif indexLast is 'value'>
                                                    <cfif not isdefined("attributes.valueList#element#")>
                                                        <cfset attributes["valueList#element#"] = formElements[k][element]['field_options']['options'][index]['value']>
                                                    <cfelse>
                                                        <cfset attributes["valueList#element#"] = attributes["valueList#element#"] & ',' & formElements[k][element]['field_options']['options'][index]['value']>
                                                    </cfif>
                                                </cfif>
                                            </cfloop>
                                        </cfloop>
                                    </cfif>
                                </cfloop>
                            <cfelse>
                                <cfset attributes["#elementItem##element#"] = formElements[k][element][elementItem]>
                            </cfif>
                        </cfloop>
                    </cfloop>
                </cfif>
            </cfloop>
            
            <cfset attributes.dataSourceName = attributes.woStructEvents["dataSourceName"]>
            
            <cfquery name="GET_IDENTITY_COLUMN" datasource="#attributes.dataSourceName#">
                SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = '#attributes.woStructEvents['pageTableName']#'and COLUMNPROPERTY(object_id(TABLE_NAME), COLUMN_NAME, 'IsIdentity') = 1 AND TABLE_SCHEMA='#attributes.woStructEvents['dataSourceName']#'
            </cfquery>
            
            <cfquery name="GET_CONTROLLER_INFO" datasource="#dsn#">
                SELECT
                    FIELD_ID
                FROM
                    EXTENDED_FIELDS
                WHERE
                    CONTROLLER_NAME = '#attributes.pageControllerName#'
                    <cfif attributes.woStructEvents['dataSourceName'] is 'period'>
                        AND PERIOD_ID_LIST = #session.ep.period_id#
                    <cfelseif attributes.woStructEvents['dataSourceName'] is 'company'>
                        AND COMPANY_ID_LIST = #session.ep.company_id#
                    </cfif>
                ORDER BY
                    FIELD_ID DESC
            </cfquery>
            <cfset fieldList = valuelist(GET_CONTROLLER_INFO.FIELD_ID,',')>
            
            <cfif not GET_CONTROLLER_INFO.recordcount>
                <cfquery name="INSERT_DB" datasource="#dsn#">
                    <cfloop index="aaa" from="1" to="#arrayLen(formElements['fields'])#">
                        INSERT INTO
                            EXTENDED_FIELDS
                        (
                            CONTROLLER_NAME,
                            EVENT_LIST,
                            FIELD_TYPE,
                            LABEL,
                            REQURITY, 
                            SIZE,
                            FIELD_ID,
                            MIN_LENGTH,
                            MAX_LENGTH,
                            DESCRIPTION,
                            BLANK_SPACE,
                            OPTION_CHECKED_LIST,
                            OPTION_VALUE_LIST,
                            OPTION_LABEL_LIST,
                            MULTIPLE,
                            TABLE_NAME,
                            IDENTITY_COLUMN_NAME,
                            DATASOURCE_NAME,
                            COMPANY_ID_LIST,
                            PERIOD_ID_LIST,
                            JSON_DATA
                        )
                        VALUES
                        (
                            '#attributes.pageControllerName#',
                            '#attributes.woStructEvents['pageExtendedEventList']#',
                            '#attributes['field_type#aaa#']#',
                            '#attributes['label#aaa#']#',
                            <cfif attributes['required#aaa#'] is 'YES'>1<cfelse>0</cfif>,
                            <cfif isdefined("attributes.size#aaa#")>'#attributes['size#aaa#']#'<cfelse>NULL</cfif>,
                            '#attributes['cid#aaa#']#',
                            <cfif isdefined("attributes.minlength#aaa#")>#attributes['minlength#aaa#']#<cfelse>NULL</cfif>,
                            <cfif isdefined("attributes.maxlength#aaa#")>#attributes['maxlength#aaa#']#<cfelse>NULL</cfif>,
                            <cfif isdefined("attributes.description#aaa#")>'#attributes['description#aaa#']#'<cfelse>NULL</cfif>,
                            <cfif isdefined("attributes.include_blank_option#aaa#") and attributes['include_blank_option#aaa#'] eq 1>1<cfelse>0</cfif>,
                            <cfif isdefined("attributes.checkedList#aaa#")>'#attributes['checkedList#aaa#']#'<cfelse>NULL</cfif>,
                            <cfif isdefined("attributes.valueList#aaa#")>'#attributes['valueList#aaa#']#'<cfelse>NULL</cfif>,
                            <cfif isdefined("attributes.labelList#aaa#")>'#attributes['labelList#aaa#']#'<cfelse>NULL</cfif>,
                            <cfif isdefined("attributes.multiple#aaa#") and attributes['multiple#aaa#'] eq 1>1<cfelse>0</cfif>,
                            '#attributes.woStructEvents['pageTableName']#',
                            '#GET_IDENTITY_COLUMN.COLUMN_NAME#',
                            '#attributes.dataSourceName#',
                            '#session.ep.company_id#',
                            '#session.ep.period_id#',
                            '#attributes.JsonDataFormBuilder#'
                        )
                        <cfif attributes['field_type#aaa#'] is 'date'>
                            ALTER TABLE #attributes.dataSourceName#.#attributes.woStructEvents['pageTableName']# ADD #UCase(attributes['cid#aaa#'])# datetime
                        <cfelse>
                            ALTER TABLE #attributes.dataSourceName#.#attributes.woStructEvents['pageTableName']# ADD #UCase(attributes['cid#aaa#'])# nvarchar(100)
                        </cfif>
                    </cfloop>
                </cfquery>
            <cfelse><!--- Update işlemi yapılacak --->
                <cfset attrList = ''>
                <cfloop collection="#attributes#" item="att">
                    <cfif att contains 'cid'>
                        <cfset attrList = listAppend(attrList,attributes['#att#'],',')>
                    </cfif>
                </cfloop>
                
                <cfloop index="index" from="1" to="#listlen(fieldList,',')#">
                    <cfif not listFindNoCase(attrList,listGetAt(fieldList,index,','),',')>
                        <cfquery name="DELETE_EXTENDED_COLUMNS" datasource="#dsn#">
                            ALTER TABLE #attributes.dataSourceName#.#attributes.woStructEvents['pageTableName']# DROP COLUMN #UCase(listGetAt(fieldList,index,','))#
                            DELETE FROM EXTENDED_FIELDS WHERE FIELD_ID = '#listGetAt(fieldList,index,',')#' AND CONTROLLER_NAME = '#attributes.pageControllerName#'
                        </cfquery>
                    </cfif>  
                </cfloop>
                <cfloop index="aaa" from="1" to="#arrayLen(formElements['fields'])#">
                    <cfif listFindNoCase(fieldList,attributes['cid#aaa#'],',')>
                        <cfquery name="UPDATE_EXTENDED_FIELDS" datasource="#dsn#">
                            UPDATE 
                                EXTENDED_FIELDS 
                            SET
                                LABEL = '#attributes['label#aaa#']#',
                                REQURITY = <cfif attributes['required#aaa#'] is 'YES'>1<cfelse>0</cfif>,
                                SIZE = <cfif isdefined("attributes.size#aaa#")>'#attributes['size#aaa#']#'<cfelse>NULL</cfif>,
                                MIN_LENGTH = <cfif isdefined("attributes.minlength#aaa#")>#attributes['minlength#aaa#']#<cfelse>NULL</cfif>,
                                MAX_LENGTH = <cfif isdefined("attributes.maxlength#aaa#")>#attributes['maxlength#aaa#']#<cfelse>NULL</cfif>,
                                DESCRIPTION = <cfif isdefined("attributes.description#aaa#")>'#attributes['description#aaa#']#'<cfelse>NULL</cfif>,
                                BLANK_SPACE = <cfif isdefined("attributes.include_blank_option#aaa#") and attributes['include_blank_option#aaa#'] eq 1>1<cfelse>0</cfif>,
                                OPTION_CHECKED_LIST = <cfif isdefined("attributes.checkedList#aaa#")>'#attributes['checkedList#aaa#']#'<cfelse>NULL</cfif>,
                                OPTION_VALUE_LIST = <cfif isdefined("attributes.valueList#aaa#")>'#attributes['valueList#aaa#']#'<cfelse>NULL</cfif>,
                                OPTION_LABEL_LIST = <cfif isdefined("attributes.labelList#aaa#")>'#attributes['labelList#aaa#']#'<cfelse>NULL</cfif>,
                                MULTIPLE = <cfif isdefined("attributes.multiple#aaa#") and attributes['multiple#aaa#'] eq 1>1<cfelse>0</cfif>,
                                JSON_DATA = '#attributes.JsonDataFormBuilder#'
                            WHERE 
                                FIELD_ID = '#UCase(attributes['cid#aaa#'])#' AND 
                                CONTROLLER_NAME = '#attributes.pageControllerName#'
                        </cfquery>
                    <cfelse>
                        <cfquery name="INSERT_COLUMNS" datasource="#dsn#">
                            INSERT INTO
                                EXTENDED_FIELDS
                            (
                                CONTROLLER_NAME,
                                EVENT_LIST,
                                FIELD_TYPE,
                                LABEL,
                                REQURITY, 
                                SIZE,
                                FIELD_ID,
                                MIN_LENGTH,
                                MAX_LENGTH,
                                DESCRIPTION,
                                BLANK_SPACE,
                                OPTION_CHECKED_LIST,
                                OPTION_VALUE_LIST,
                                OPTION_LABEL_LIST,
                                MULTIPLE,
                                TABLE_NAME,
                                IDENTITY_COLUMN_NAME,
                                DATASOURCE_NAME,
                                COMPANY_ID_LIST,
                                PERIOD_ID_LIST,
                                JSON_DATA
                            )
                            VALUES
                            (
                                '#attributes.pageControllerName#',
                                '#attributes.woStructEvents['pageExtendedEventList']#',
                                '#attributes['field_type#aaa#']#',
                                '#attributes['label#aaa#']#',
                                <cfif attributes['required#aaa#'] is 'YES'>1<cfelse>0</cfif>,
                                <cfif isdefined("attributes.size#aaa#")>'#attributes['size#aaa#']#'<cfelse>NULL</cfif>,
                                '#attributes['cid#aaa#']#',
                                <cfif isdefined("attributes.minlength#aaa#")>#attributes['minlength#aaa#']#<cfelse>NULL</cfif>,
                                <cfif isdefined("attributes.maxlength#aaa#")>#attributes['maxlength#aaa#']#<cfelse>NULL</cfif>,
                                <cfif isdefined("attributes.description#aaa#")>'#attributes['description#aaa#']#'<cfelse>NULL</cfif>,
                                <cfif isdefined("attributes.include_blank_option#aaa#")>1<cfelse>0</cfif>,
                                <cfif isdefined("attributes.checkedList#aaa#")>'#attributes['checkedList#aaa#']#'<cfelse>NULL</cfif>,
                                <cfif isdefined("attributes.valueList#aaa#")>'#attributes['valueList#aaa#']#'<cfelse>NULL</cfif>,
                                <cfif isdefined("attributes.labelList#aaa#")>'#attributes['labelList#aaa#']#'<cfelse>NULL</cfif>,
                                <cfif isdefined("attributes.multiple#aaa#") and attributes['multiple#aaa#'] eq 1>1<cfelse>0</cfif>,
                                '#attributes.woStructEvents['pageTableName']#',
                                '#GET_IDENTITY_COLUMN.COLUMN_NAME#',
                                '#attributes.dataSourceName#',
                                '#session.ep.company_id#',
                                '#session.ep.period_id#',
                                '#attributes.JsonDataFormBuilder#'
                            )
                            <cfif attributes['field_type#aaa#'] is 'date'>
                                ALTER TABLE #attributes.dataSourceName#.#attributes.woStructEvents['pageTableName']# ADD #UCase(attributes['cid#aaa#'])# datetime
                            <cfelse>
                                ALTER TABLE #attributes.dataSourceName#.#attributes.woStructEvents['pageTableName']# ADD #UCase(attributes['cid#aaa#'])# nvarchar(100)
                            </cfif>
                        </cfquery>
                    </cfif>
                </cfloop>
            </cfif>
        </cfif>
    </cfif>
</cfif>
<script type="text/javascript">
	alert("<cf_get_lang dictionary_id='61210.İşlem Başarılı'>");
	window.location.reload(true);
</script>
