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
            RECORD_DATE DESC
    </cfquery>
	<table>
   		<tr height="25">
			<td  width="100%" onclick="gizle_goster(notes);"><cfoutput>#getLang('','','57422')#</cfoutput>***</td> <!--- Notlar --->
			<td align="right"><cfoutput><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_form_add_note&action=#attributes.action_section#&action_id=#attributes.action_id#&is_special=#attributes.is_special#&action_type=#attributes.action_type#<cfif isdefined("attributes.action_id_2")>&action_id_2=#attributes.action_id_2#</cfif>','small','popup_form_add_note')"><img src="/images/plus_list.gif" border="0" alt="#caller.getLang('textile',15)#"></a></cfoutput></td>
	  	</tr>
		<tr id="notes" height="20" <cfif not attributes.style>style="display=none;"</cfif>>
			<td colspan="2">
				<table width="100%">
					<cfoutput query="get_note">
						<tr>
							<td width="80%"><cfif is_open_det neq 0><a href="javascript:" onclick="windowopen('#request.self#?fuseaction=objects.popup_form_upd_note&note_id=#NOTE_ID#&is_delete=#attributes.is_delete#','small','popup_form_upd_note')" class="tableyazi">#note_head#</a><cfelse>#note_head#</cfif></td>
							<td>#dateformat(record_date,'dd/mm/yyyy')#</td>
						</tr>
					</cfoutput>
					<cfif not get_note.recordcount>
						<cfoutput>
							<tr>
								<td><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
							</tr>
						</cfoutput>
					</cfif>
				</table>
			</td>
		</tr>
	</table>
<cfelse>
	<cfif isdefined("attributes.action_id_2")>
        <cfset add_ = "&action_id_2=#attributes.action_id_2#">
    <cfelse>
        <cfset add_ = "">
    </cfif>
	<cfset url_str = ''>
    <cfif len(attributes.style)><cfset url_str =url_str&'&style=#attributes.style#'></cfif>
	<cfif len(attributes.design_id)><cfset url_str =url_str&'&design_id=#attributes.design_id#'></cfif>
	<cfif len(attributes.is_special)><cfset url_str =url_str&'&is_special=#attributes.is_special#'></cfif>
	<cfif len(attributes.action_type)><cfset url_str =url_str&'&action_type=#attributes.action_type#'></cfif>
	<cfif len(attributes.is_delete)><cfset url_str =url_str&'&is_delete=#attributes.is_delete#'></cfif>
	<cfif len(attributes.action_section)><cfset url_str =url_str&'&action_section=#attributes.action_section#'></cfif>
	<cfif len(attributes.action_id)><cfset url_str =url_str&'&action_id=#attributes.action_id#'></cfif>
    <cfif len(attributes.is_open_det)><cfset url_str =url_str&'&is_open_det=#attributes.is_open_det#'></cfif>
	<cfif isdefined("attributes.period_id")><cfset url_str =url_str&'&period_id=#attributes.period_id#'></cfif>
	<cfif isdefined("attributes.action_id_2") and len(attributes.action_id_2)><cfset url_str =url_str&'&action_id_2=#attributes.action_id_2#'></cfif>
	<cfif isdefined("attributes.company_id") and len(attributes.company_id)><cfset url_str =url_str&'&company_id=#attributes.company_id#'></cfif>
	<cfsavecontent  variable="message"><cf_get_lang dictionary_id='62735.Kritikler'></cfsavecontent>
    		<cf_box id="get_notes" closable="0" title="#message#" add_href="openBoxDraggable('#request.self#?fuseaction=textile.popup_form_add_critic&action=#attributes.action_section#&action_id=#attributes.action_id#&is_special=#attributes.is_special#&action_type=#attributes.action_type##add_#','','ui-draggable-box-medium')" add_href_size="small" collapsed="#iif(attributes.style,1,0)#" box_page="#request.self#?fuseaction=textile.ajax_critics&#url_str#"></cf_box>

</cfif>
