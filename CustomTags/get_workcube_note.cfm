<!---
Description :
    Document Template
Parameters :
    action_section  'required : table name used in the action id
    action_id		'required : action id for every record in a module
	design_id		'not required : design type for use area
	company_id		'not required : sirket db den gelen degerler icin (order, offer gibi) zorunlu main den gelenler (employees gibi) icin degil
	style			'not required : default notlar gorunmuyor, gorunmesi icin parametre 1 olarak verilmeli
	is_special		'not required : default ozel not secenegi bos geliyor, checked gelmesi icin parametre 1 olmali
	action_type      .-.- > verinin numeric mi nvarchar mı oldugunu belirtir 0:numeric 1:nvarchar
	is_delete		'required : default sil butonu geliyor, gorunmemesi icin parametre 0 veya yazılmamalıdır
Syntax :
	<cf_get_workcube_note action_section='<table name>' action_id='<integer value>'>
Sample :
	<cf_get_workcube_note company_id='2' action_section='CONTENT' action_id='#attributes.cntid#'>

	created EK20030719
	modified 20050910
 --->
<cfparam name="attributes.design_id" default="1">
<cfparam name="attributes.style" default="1"><!--- 1 : acik, 0 kapali --->
<cfparam name="attributes.is_special" default="0"><!--- 1 : checked, 0 unchecked --->
<cfparam name="attributes.action_type" default="0">
<cfparam name="attributes.is_delete" default="1">
<cfparam name="attributes.is_open_det" default="1">
<cfparam name="attributes.no_border" default="0">
<cfparam name="attributes.action_section" default="">
<cfparam name="attributes.action_id" default="">
<cfparam name="attributes.action_id_2" default="">
<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.period_id" default="">
<cfparam name="attributes.related_id" default="">
<cfparam name="attributes.related_section" default="">
<cfparam name="attributes.box_id" default="get_notes">

<cfif attributes.action_type eq 0 and len(attributes.action_id) and not isNumeric(attributes.action_id)>
	<cfset attributes.action_id= '#caller.contentEncryptingandDecodingAES(isEncode:0,content:attributes.action_id,accountKey:'wrk')#'>  
</cfif>
<cfif isdefined("attributes.action_id_2") and len(attributes.action_id_2) and not isNumeric(attributes.action_id_2)>
	<cfset attributes.action_id_2= '#caller.contentEncryptingandDecodingAES(isEncode:0,content:attributes.action_id_2,accountKey:'wrk')#'>  
</cfif>

<cfif attributes.design_id eq 0>
    <cfquery name="GET_NOTE" datasource="#CALLER.DSN#">
        SELECT
            *
        FROM
            NOTES
        WHERE
            ACTION_SECTION = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ucase(attributes.action_section)#">
        <cfif attributes.action_type eq 0>
            AND ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_id#">
        <cfelse>
            AND ACTION_VALUE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.action_id#">
        <cfif isdefined("attributes.action_id_2")>
            AND	ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_id_2#">
        </cfif>
        </cfif>
        <cfif isdefined("attributes.company_id") and len(attributes.company_id)>
            AND COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
        </cfif>
		<cfif isDefined('attributes.period_id') and len(attributes.period_id)>
            AND PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.period_id#">
         </cfif>
            AND
            (
                IS_SPECIAL = 0
              <cfif isdefined("session.ep")>
                OR (IS_SPECIAL = 1 AND (RECORD_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"> OR UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">))
              <cfelseif isDefined('session.pp')>
                OR (IS_SPECIAL = 1 AND (RECORD_PAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#"> OR UPDATE_PAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#">))
              <cfelseif isDefined('session.ww')>
                OR (IS_SPECIAL = 1 AND (RECORD_CONS = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#"> OR UPDATE_CONS = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#">))
              </cfif>
            )
        ORDER BY
            RECORD_DATE
    </cfquery>
	<cf_grid_list>
		<thead>
			<tr>
				<th  width="100%" onclick="gizle_goster(notes);"><cfoutput>#caller.getLang('main',10)#</cfoutput></th> <!--- Notlar --->
				<th style="width:20px;"><cfoutput><a href="javascript:void(0)" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_form_add_note&action=#attributes.action_section#&action_id=#attributes.action_id#&is_special=#attributes.is_special#&action_type=#attributes.action_type#<cfif isdefined("attributes.action_id_2")>&action_id_2=#attributes.action_id_2#</cfif>','','ui-draggable-box-medium')" border="0" alt="#caller.getLang('main',170)#"><i class="fa fa-plus"></i></a></cfoutput></th>
			</tr>
		</thead>
		<tbody>
			<cfoutput query="get_note">
				<tr>
					<td width="80%"><cfif attributes.is_open_det neq 0><a href="javascript:" onclick="windowopen('#request.self#?fuseaction=objects.popup_form_upd_note&note_id=#NOTE_ID#&is_delete=#attributes.is_delete#','small','popup_form_upd_note')" class="tableyazi">#note_head#</a><cfelse>#note_head#</cfif></td>
					<td>#dateformat(record_date,'dd/mm/yyyy')#</td>
				</tr>
			</cfoutput>
			<cfif not get_note.recordcount>
				<cfoutput>
					<tr>
						<td>#caller.getLang('main',72)# !</td>
					</tr>
				</cfoutput>
			</cfif>
		</tbody>
	</cf_grid_list>
<cfelse>
	<cfset add_ = "">
	<cfif isdefined("attributes.action_id_2")>
        <cfset add_ = add_ & "&action_id_2=#attributes.action_id_2#">
	</cfif>
	<cfif isdefined("attributes.company_id") and len(attributes.company_id)>
		<cfset add_ = add_ & '&company_id=#attributes.company_id#'>
	</cfif>
	<cfif isdefined("attributes.period_id")>
		<cfset add_ = add_ & '&period_id=#attributes.period_id#'>
	</cfif>
	<cfif len(attributes.is_open_det)>
		<cfset add_ = add_ & '&is_open_det=#attributes.is_open_det#'>
	</cfif>
	<cfif len(attributes.is_delete)>
		<cfset add_ = add_ & '&is_delete=#attributes.is_delete#'>
	</cfif>
	<cfset url_str = ''>
    <cfif len(attributes.style)><cfset url_str =url_str&'&style=#attributes.style#'></cfif>
	<cfif len(attributes.design_id)><cfset url_str =url_str&'&design_id=#attributes.design_id#'></cfif>
	<cfif len(attributes.is_special)><cfset url_str =url_str&'&is_special=#attributes.is_special#'></cfif>
	<cfif len(attributes.action_type)><cfset url_str =url_str&'&action_type=#attributes.action_type#'></cfif>
	<cfif len(attributes.is_delete)><cfset url_str =url_str&'&is_delete=#attributes.is_delete#'></cfif>
	<cfif len(attributes.action_section)><cfset url_str =url_str&'&action_section=#attributes.action_section#'></cfif>
	<cfif len(attributes.related_id)><cfset url_str =url_str&'&related_id=#attributes.related_id#'></cfif>
	<cfif len(attributes.related_section)><cfset url_str =url_str&'&related_section=#attributes.related_section#'></cfif>
	<cfif len(attributes.action_id)><cfset url_str =url_str&'&action_id=#attributes.action_id#'></cfif>
	<cfif len(attributes.is_open_det)><cfset url_str =url_str&'&is_open_det=#attributes.is_open_det#'></cfif>
	<cfif isdefined("attributes.period_id")><cfset url_str =url_str&'&period_id=#attributes.period_id#'></cfif>
	<cfif isdefined("attributes.action_id_2") and len(attributes.action_id_2)><cfset url_str =url_str&'&action_id_2=#attributes.action_id_2#'></cfif>
	<cfif isdefined("attributes.company_id") and len(attributes.company_id)><cfset url_str =url_str&'&company_id=#attributes.company_id#'></cfif>
	<cfset maxi = ( attributes.no_border eq 1 ) ? "Maxi" : "">
	<cfif isDefined('session.pp.userid')>
    		<cf_box class="#maxi#" id="#attributes.box_id#" closable="0" add_href="openBoxDraggable('#request.self#?fuseaction=objects.popup_form_add_note&action=#attributes.action_section#&action_id=#attributes.action_id#&is_special=#attributes.is_special#&action_type=#attributes.action_type##add_#')" add_href_size="small" collapsed="#iif(attributes.style,1,0)#" title="#caller.getLang('main',10)#" box_page="#request.self#?fuseaction=objects2.ajax_notes&#url_str#"></cf_box>
	<cfelse>
    		<cf_box class="#maxi#" id="#attributes.box_id#" closable="0" add_href="openBoxDraggable('#request.self#?fuseaction=objects.popup_form_add_note&action=#attributes.action_section#&action_id=#attributes.action_id#&is_special=#attributes.is_special#&action_type=#attributes.action_type##add_#')" add_href_size="small" collapsed="#iif(attributes.style,1,0)#" title="#caller.getLang('main',10)#" box_page="#request.self#?fuseaction=objects.ajax_notes&#url_str#"></cf_box>
	</cfif>
</cfif>