<cf_get_lang_set module_name = 'myhome'>
<cfif not isdefined("attributes.event") or (isdefined("attributes.event") and attributes.event is 'list')>
    <cfinclude template="../myhome/query/get_employee_cautions.cfm">
    <cfif GET_EMPLOYEE_CAUTIONS.RECORDCOUNT>
        <cfoutput query="GET_EMPLOYEE_CAUTIONS">
            <cfif fusebox.circuit eq 'myhome'><!---20131108--->
                <cfset caution_id_ = contentEncryptingandDecodingAES(isEncode:1,content:caution_id,accountKey:session.ep.userid)>
            <cfelse>
                <cfset caution_id_ = caution_id>
            </cfif>
            <cfif len(CAUTION_TYPE_ID)>
                <cfquery name="get_type" datasource="#dsn#">
                    SELECT
                        CAUTION_TYPE
                    FROM
                        SETUP_CAUTION_TYPE
                    WHERE
                        CAUTION_TYPE_ID = #CAUTION_TYPE_ID#
                </cfquery>
            </cfif>
        </cfoutput>
    </cfif>
<cfelseif isdefined("attributes.event") and attributes.event is 'upd'>
	<cfif fusebox.circuit eq 'myhome'><!---20131108--->
        <cfset attributes.caution_id = contentEncryptingandDecodingAES(isEncode:0,content:attributes.caution_id,accountKey:session.ep.userid)>
    </cfif>
    <cfinclude template="../myhome/query/get_caution.cfm">
</cfif>
<cfscript>
	// Switch //
	WOStruct = StructNew();
	WOStruct['#attributes.fuseaction#'] = structNew();
	
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'myhome.list_my_caution';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'myhome/display/list_my_caution.cfm';
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'myhome.list_my_caution';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'myhome/display/view_caution.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'myhome/query/apology_add.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'myhome.list_my_caution';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'CAUTION_ID=##get_caution.CAUTION_ID##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##get_caution.CAUTION_ID##';
</cfscript>
