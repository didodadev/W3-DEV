<cfquery name="GET_NOTE" datasource="#DSN#">
select
	*from
	(
	SELECT
			0 TYPE,
			CONT_BODY NOTE_BODY,
			CONTENT.CONTENT_ID NOTE_ID,
			'Standart Kritik' NOTE_HEAD,
			CONTENT.RECORD_DATE,
			CONTENT.RECORD_MEMBER RECORD_EMP,
			CONTENT.UPDATE_DATE,
			CONTENT.UPDATE_MEMBER UPDATE_EMP
	FROM
		CONTENT,
		CONTENT_RELATION
	WHERE
		CONTENT.CONTENT_ID=CONTENT_RELATION.CONTENT_ID AND
		CONTENT_RELATION.ACTION_TYPE='COMPANY_ID' AND
		CONTENT_RELATION.ACTION_TYPE_ID=#attributes.company_id#

	UNION ALL
	SELECT
				1 TYPE,
			NOTE_BODY,
			NOTE_ID,
			NOTE_HEAD,
			RECORD_DATE,
			RECORD_EMP,
			UPDATE_DATE,
			UPDATE_EMP
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
		AND COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
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
	
		
		)
		as T 
		ORDER BY
			T.RECORD_DATE DESC
</cfquery>
<cf_ajax_list>
    <cfif get_note.recordcount>
        <thead>
        <tr>
            <cfoutput>
                <th>Kritik</th> <!--- Konu --->
                <th style="width:50px;">#getLang('main',330)#</th> <!--- Tarih --->
            </cfoutput>
        </tr>
        </thead>
        <tbody>
        <cfoutput query="get_note">
            <tr id="notes_#currentrow#">
            	<td>
            		<a href="javascript://" onClick="gizle_goster(notes_detail#currentrow#);" class="tableyazi"><img id="main_notes#currentrow#" border="0" src="/images/acters.gif" width="7" height="12" align="absmiddle"></a>&nbsp;&nbsp;
            		<cfif type eq 1>
						<cfif isdefined('is_open_det') and attributes.is_open_det eq 1><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=textile.popup_form_upd_critic&note_id=#note_id#&is_delete=#attributes.is_delete#','small','popup_form_upd_note')" class="tableyazi"><font><cfif len(note_head) gt 25>#left(note_head, 25)#...<cfelse>#note_head#</cfif></font></a><cfelse><cfif len(note_head) gt 25>#left(note_head, 25)#...<cfelse>#note_head#</cfif></cfif>
					<cfelse>
						<font><cfif len(note_head) gt 25>#left(note_head, 25)#...<cfelse>#note_head#</cfif></font>
					</cfif>
					
				</td>
                <!---<td><a href="javascript:" onClick="windowopen('#request.self#?fuseaction=objects.popup_form_upd_note&note_id=#note_id#&is_delete=#attributes.is_delete#','small','popup_form_upd_note')" class="tableyazi">#note_head#</a></td>--->
                <td>#dateformat(record_date,dateformat_style)#</td>
            </tr>
            <tr class="nohover" id="notes_detail#currentrow#" style="">
            	<td colspan="2">
            		<div id="show_notes_detail#currentrow#" style="width:100%;">
            			<div style="overflow:auto;border:1;" >
							<table width="100%">
								<tr>
									<td colspan="2" width="100%">
										#note_body#
									</td>
								</tr>
								<tr>
									<td colspan="2">
										<cfif len(record_emp)>Kayıt: #get_emp_info(record_emp,0,0)# #dateformat(record_date,dateformat_style)# #Timeformat(date_add("h", session.ep.time_zone, record_date),timeformat_style)#</cfif>
										<cfif len(update_emp)>Güncelleme: #get_emp_info(update_emp,0,0)# #dateformat(update_date,dateformat_style)# #Timeformat(date_add("h", session.ep.time_zone, update_date),timeformat_style)#</cfif>
									</td>
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
                <td>#getLang('main',72)# !</td>
                <td></td>
            </tr>
        </cfoutput>
    </cfif>
    </tbody>
</cf_ajax_list>

<script type="text/javascript">
function connectAjax(row_id,note_id)
{
	var bb = "<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_detail_note&id="+note_id;
	AjaxPageLoad(bb,'show_notes_detail'+row_id+'',0);
}
</script>
