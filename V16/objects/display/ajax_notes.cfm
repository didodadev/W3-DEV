<cfparam name="attributes.show_alert" default="1">

<cfset url_str = ''>
<cfif isDefined('attributes.style') and len(attributes.style)><cfset url_str =url_str&'&style=#attributes.style#'></cfif>
<cfif isDefined('attributes.design_id') and len(attributes.design_id)><cfset url_str =url_str&'&design_id=#attributes.design_id#'></cfif>
<cfif isDefined('attributes.is_special') and len(attributes.is_special)><cfset url_str =url_str&'&is_special=#attributes.is_special#'></cfif>
<cfif isDefined('attributes.action_type') and len(attributes.action_type)><cfset url_str =url_str&'&action_type=#attributes.action_type#'></cfif>
<cfif isDefined('attributes.is_delete') and len(attributes.is_delete)><cfset url_str =url_str&'&is_delete=#attributes.is_delete#'></cfif>
<cfif isDefined('attributes.action_section') and len(attributes.action_section)><cfset url_str =url_str&'&action_section=#attributes.action_section#'></cfif>
<cfif isDefined('attributes.action_id') and len(attributes.action_id)><cfset url_str =url_str&'&action_id=#attributes.action_id#'></cfif>
<cfif isDefined('attributes.is_open_det') and len(attributes.is_open_det)><cfset url_str =url_str&'&is_open_det=#attributes.is_open_det#'></cfif>
<cfif isdefined("attributes.period_id") and len(attributes.period_id)><cfset url_str =url_str&'&period_id=#attributes.period_id#'></cfif>
<cfif isdefined("attributes.action_id_2") and len(attributes.action_id_2)><cfset url_str =url_str&'&action_id_2=#attributes.action_id_2#'></cfif>
<cfif isdefined("attributes.company_id") and len(attributes.company_id)><cfset url_str =url_str&'&company_id=#attributes.company_id#'></cfif>

<cfquery name="GET_NOTE" datasource="#DSN#">
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
	<cfif isdefined("related_id") and isdefined("related_section")>
		UNION ALL
		SELECT
		*
	FROM
		NOTES
	WHERE
		ACTION_SECTION = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ucase(attributes.related_section)#">
	<cfif attributes.action_type eq 0>
		AND ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.related_id#">
	<cfelse>
		AND ACTION_VALUE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.related_id#">
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
	</cfif>
	ORDER BY
		RECORD_DATE
</cfquery>

<cf_ajax_list>
    <cfif get_note.recordcount>
        <thead>
        <tr>
            <cfoutput>
                <th><cf_get_lang dictionary_id='57480.Konu'></th>
				<th style="width:50px;"><cf_get_lang dictionary_id='57742.Tarih'></th>
				<th></th>
            </cfoutput>
        </tr>
        </thead>
        <tbody>
        <cfoutput query="get_note">
            <tr id="notes_#currentrow#">
            	<td>
            		<a href="javascript://" onClick="gizle_goster(notes_detail#currentrow#);" class="tableyazi"><img id="main_notes#currentrow#" border="0" src="/images/acters.gif" width="7" height="12" align="absmiddle"></a>&nbsp;&nbsp;
					<cfif len(is_link) and is_link eq 1>
						<cfif not Find("://",note_head)>
							<cfset link_url = "https://"&note_head>
						<cfelse>
							<cfset link_url = note_head>
						</cfif> 
						<a target="_blank" href="#link_url#" class="tableyazi"><font><cfif len(note_head) gt 25>#left(note_head, 25)#...<cfelse>#note_head#</cfif></font></a>
					<cfelse>
						<cfif isdefined('is_open_det') and attributes.is_open_det eq 1><a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=objects.popup_form_upd_note&note_id=#note_id#&is_delete=#attributes.is_delete##url_str#')" class="tableyazi"><font><cfif len(note_head) gt 25>#left(note_head, 25)#...<cfelse>#note_head#</cfif></font></a><cfelse><cfif len(note_head) gt 25>#left(note_head, 25)#...<cfelse>#note_head#</cfif></cfif>
					</cfif>
				</td>
                <!---<td><a href="javascript:" onClick="windowopen('#request.self#?fuseaction=objects.popup_form_upd_note&note_id=#note_id#&is_delete=#attributes.is_delete#','small','popup_form_upd_note')" class="tableyazi">#note_head#</a></td>--->
				<td>#dateformat(record_date,dateformat_style)#</td>
				<td>
					<cfif isdefined('is_open_det') and attributes.is_open_det eq 1>
						<a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=objects.popup_form_upd_note&note_id=#note_id#&is_delete=#attributes.is_delete##url_str#')" class="tableyazi"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a>
					</cfif>
				</td>
            </tr>
            <tr class="nohover" id="notes_detail#currentrow#" style="">
            	<td colspan="3">
            		<div id="show_notes_detail#currentrow#" style="width:100%;">
            			<div style="overflow:auto;border:1;" >
							<table width="100%">
								<tr>
									<td colspan="3" width="100%">
										#note_body#
									</td>
								</tr>
								<tr>
									<!--- <td colspan="2">
										<cfif len(record_emp)>Kayıt: #get_emp_info(record_emp,0,0)# #dateformat(record_date,dateformat_style)# #Timeformat(date_add("h", session.ep.time_zone, record_date),timeformat_style)#</cfif>
										<cfif len(update_emp)>Güncelleme: #get_emp_info(update_emp,0,0)# #dateformat(update_date,dateformat_style)# #Timeformat(date_add("h", session.ep.time_zone, update_date),timeformat_style)#</cfif>
									</td> --->
									<cfquery name="current_get_note" dbtype="query">
										SELECT * FROM get_note WHERE NOTE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#note_id#">
									</cfquery>
									<td colspan="2"><cf_record_info query_name="current_get_note"></td>
								</tr>
							</table>
						</div>
            		</div>
            	</td>
            </tr>
        </cfoutput>
    <cfelse>
        <cfoutput>
            <tr>
                <td><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
                <td></td>
            </tr>
        </cfoutput>
    </cfif>
    </tbody>
</cf_ajax_list>

<script type="text/javascript">
	$( document ).ready(function() {
		<cfif get_note.recordcount>
			$('.ui-cfmodal__alert .required_list li').remove();
			temp = 0;
			<cfloop query="get_note">
				<cfif is_warning eq 1 and alert_date gte now()>
					temp++;
					$('.ui-cfmodal__alert .required_list').append('<li class="required"><i class="fa fa-terminal"></i><cfoutput>#getLang(dictionary_id:44341)# : #note_head#</cfoutput></li>');
				</cfif>
			</cfloop>
			<cfif attributes.show_alert eq 1>
				if( temp != 0 ) $('.ui-cfmodal__alert').fadeIn();
			</cfif>
		</cfif>
	});

	function connectAjax(row_id,note_id)
	{
		var bb = "<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_detail_note&id="+note_id;
		AjaxPageLoad(bb,'show_notes_detail'+row_id+'',0);
	}
</script>