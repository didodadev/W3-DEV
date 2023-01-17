<cfparam name="attributes.modal_id" default="">
<cfparam name="attributes.is_page" default="1">
<cfinclude template="../query/get_language.cfm">

<cfquery name="get_dic_id" datasource="#DSN#">
    SELECT 
        DICTIONARY_ID,
        MODULE_ID,
        ITEM_ID ,
        RECORD_EMP,
        RECORD_DATE,
        UPDATE_EMP,
        UPDATE_DATE
    FROM 
        SETUP_LANGUAGE_TR 
    WHERE
   <cfif isDefined("attributes.dictionary_id") >
        DICTIONARY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.dictionary_id#"> 
   <cfelseif isDefined("attributes.item_id")>
        ITEM_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.item_id#"> AND MODULE_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.strmodule#">
   </cfif> 
</cfquery>

<cfquery name="GET_SPECIAL_LANG" datasource="#DSN#">
    SELECT ITEM_ID FROM SETUP_LANG_SPECIAL WHERE MODULE_ID = '#get_dic_id.MODULE_ID#' AND ITEM_ID = #get_dic_id.ITEM_ID#
</cfquery>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box title="#getLang('','Sözlük',57932)# - #getLang('','Kelime',55052)#" scroll="1" collapsable="1" resize="0" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
        <cfform name="upd_sub_name" action="#request.self#?fuseaction=settings.emptypopup_upd_lang_item" method="post">
            <input name="module_name" id="module_name" value="<cfoutput>#get_dic_id.MODULE_ID#</cfoutput>" type="hidden">
            <input name="item_id" id="item_id" value="<cfoutput>#get_dic_id.ITEM_ID#</cfoutput>" type="hidden">
            <input name="is_page" id="is_page" value="<cfoutput>#attributes.is_page#</cfoutput>" type="hidden">
            <cf_box_elements>
                <div class="col col-6 col-xs-12">
                    <div class="form-group">
                        <label class="col"><cf_get_lang_main no='567.Özel'></label>
                        <input type="checkbox" name="is_special" id="is_special" value="1" <cfif get_special_lang.recordcount>checked</cfif>>
                    </div>
                    <div class="form-group">
                        <label class="col col-3">Dictionary Id</label>
                        <div class="col col-9">
                            <input  type="text"  name="dictionary_id" id="dictionary_id" value="<cfoutput>#get_dic_id.dictionary_id#</cfoutput>" readonly>  
                        </div>
                    </div>
                    <cfset sayi=0>
                    <cfloop from="1" to="#get_language.recordcount#" index="i">
                        <cfset NEW_COLUMN_NAME="ITEM_#UCASE(get_language.LANGUAGE_SHORT[i])#">
                        <cfif DATABASE_TYPE IS "MSSQL">
                            <cfquery name="get_language_db" datasource="#DSN#">
                                SELECT * FROM 	sysobjects 
                                WHERE id = object_id(N'[SETUP_LANGUAGE_TR]') and OBJECTPROPERTY(id, N'IsUserTable') = 1
                            </cfquery>
                        <cfelseif DATABASE_TYPE IS "DB2">
                            <cfquery name="get_language_db" datasource="#DSN#">
                                SELECT TBNAME FROM SYSIBM.SYSCOLUMNS WHERE TBNAME='SETUP_LANGUAGE_TR'
                            </cfquery>
                        </cfif>				   
                        <cfif get_language_db.recordcount>
                            <div class="form-group">
                                <cfset sayi=sayi+1>
                                <cfquery name="get_value" datasource="#DSN#">
                                    SELECT
                                        *
                                    FROM
                                        SETUP_LANGUAGE_TR
                                    WHERE
                                    <cfif isDefined("attributes.dictionary_id") >
                                            DICTIONARY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.dictionary_id#"> 
                                    <cfelseif isDefined("attributes.item_id")>
                                            ITEM_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.item_id#">  AND MODULE_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.strmodule#">
                                    </cfif> 
                                </cfquery>
                                <cfif get_value.recordcount>
                                    <cfset str_value=evaluate("get_value.#NEW_COLUMN_NAME#")>
                                <cfelse>
                                    <cfset str_value="">
                                </cfif>
                                <label class="col col-3"><cfoutput>#GET_LANGUAGE.LANGUAGE_SET[i]#*</cfoutput></label>
                                <input  type="hidden"  name="kolon_isimleri<cfoutput>#sayi#</cfoutput>" id="kolon_isimleri<cfoutput>#sayi#</cfoutput>" value="<cfoutput>#UCASE(GET_LANGUAGE.LANGUAGE_SHORT[i])#</cfoutput>">
                                <div class="col col-9">
                                    <cfinput type="text" required="yes" name="item_name_#sayi#" id="item_name_#sayi#" value="#str_value#"message="#getLang('','Kelime girmelisiniz',42707)#"  maxlength="500">
                                </div>
                            </div>
                        </cfif> 
                    </cfloop>
                    <input type="hidden" name="sayi" id="sayi" value="<cfoutput>#sayi#</cfoutput>">
                </div>
            </cf_box_elements>
            <cf_box_footer>
                <cf_record_info query_name="get_dic_id" record_emp="RECORD_EMP" update_emp="UPDATE_EMP">
                <cf_workcube_buttons is_upd='1' is_delete='0' add_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('upd_sub_name' , #attributes.modal_id#)"),DE(""))#">
            </cf_box_footer>
        </cfform>
    </cf_box>
</div>