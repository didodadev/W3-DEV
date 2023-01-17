

<cfset attributes.action_id=attributes.req_id>
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
        ORDER BY
            RECORD_DATE
    </cfquery>
	<table>
   		<tr height="25">
			<td  width="100%" onclick="gizle_goster(notes);"><cfoutput>#caller.getLang('textile',15)#</cfoutput>***</td> <!--- Notlar --->
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
								<td>222#caller.getLang('main',72)# !</td>
							</tr>
						</cfoutput>
					</cfif>
				</table>
			</td>
		</tr>
	</table>