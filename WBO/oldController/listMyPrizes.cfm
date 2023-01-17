<cf_get_lang_set module_name="myhome">
<cfif not isdefined("attributes.event") or isdefined("attributes.event") and attributes.event is 'list'>
    <cfinclude template="../myhome/query/get_employee_prizes.cfm">  
    <cfif GET_EMPLOYEE_PRIZES.RECORDCOUNT>
        <cfoutput query="GET_EMPLOYEE_PRIZES">
            <cfif fusebox.circuit eq 'myhome'><!---20131109--->
                <cfset prize_id_ = contentEncryptingandDecodingAES(isEncode:1,content:prize_id,accountKey:session.ep.userid)>
            <cfelse>
                <cfset prize_id_ = prize_id>
            </cfif>
            <cfif len(PRIZE_TYPE_ID)>
                <cfquery name="get_type" datasource="#dsn#">
                    SELECT
                        PRIZE_TYPE
                    FROM
                        SETUP_PRIZE_TYPE
                    WHERE
                        PRIZE_TYPE_ID = #PRIZE_TYPE_ID#
                </cfquery>
            </cfif>
        </cfoutput>
  	</cfif>
<cfelseif isdefined("attributes.event") and attributes.event is 'det'>
	<cfif fusebox.circuit eq 'myhome'><!---20131109--->
		<cfset attributes.prize_id = contentEncryptingandDecodingAES(isEncode:0,content:attributes.prize_id,accountKey:session.ep.userid)>
    </cfif>
    <cfquery name="GET_PRIZE" datasource="#DSN#">
      SELECT * FROM EMPLOYEES_PRIZE WHERE PRIZE_ID = #attributes.PRIZE_ID#
    </cfquery>
</cfif>
<cfscript>
	// Switch //
	WOStruct = StructNew();
	WOStruct['#attributes.fuseaction#'] = structNew();
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	if(not isdefined('attributes.event'))
		attributes.event = WOStruct['#attributes.fuseaction#']['default'];
		
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'myhome.list_my_prizes';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'myhome/display/list_my_prizes.cfm';
	
	WOStruct['#attributes.fuseaction#']['det'] = structNew();
	WOStruct['#attributes.fuseaction#']['det']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['det']['fuseaction'] = 'myhome.popup_view_prize';
	WOStruct['#attributes.fuseaction#']['det']['filePath'] = 'myhome/display/view_prize.cfm';
	WOStruct['#attributes.fuseaction#']['det']['parameters'] = 'prize_id=##attributes.prize_id##';
	WOStruct['#attributes.fuseaction#']['det']['Identity'] = '##attributes.prize_id##';

/*	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'hr.form_add_notice';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'hr/form/form_add_notice.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'hr/query/add_notice.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'hr.list_notice&event=upd';*/
	
</cfscript>
