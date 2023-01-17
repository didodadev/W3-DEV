<cfquery name="GET_OPPORTUNITY_PLUSES" datasource="#DSN3#">
    SELECT 
    	PLUS_DATE,
        EMPLOYEE_ID,
        RECORD_EMP,
        COMMETHOD_ID,
        MAIL_SENDER,
        MAIL_CC,
        PLUS_CONTENT,
        IS_EMAIL,
        PLUS_ID  OPP_PLUS_ID
    FROM 
    	TEXTILE_SR_PLUS
    WHERE 
    	REQ_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#req_id#"> 
    ORDER BY 
    	RECORD_DATE DESC
</cfquery>


	<cfoutput query="get_opportunity_pluses">
	<table>
   		<tr height="25">
			<td  width="100%" onclick="gizle_goster(notes_#currentrow#);"><cfoutput>#getLang('textile',15)#</cfoutput></td> <!--- Notlar --->
			<td align="right"></td>
	  	</tr>
		<tr id="notes_#currentrow#" height="20">
			<td colspan="2">
				<table width="100%">
					
						<tr>
							<td width="80%">
								<!---<a href="javascript:" onclick="windowopen('#request.self#?fuseaction=objects.popup_form_upd_note&note_id=#NOTE_ID#&is_delete=#attributes.is_delete#','small','popup_form_upd_note')" class="tableyazi">#note_head#</a><cfelse>#note_head#</cfif>--->
								 <a href="javascript://" class="tableyazi"  onclick="windowopen('#request.self#?fuseaction=textile.popup_form_upd_opp_plus&opp_plus_id=#opp_plus_id#','medium');"><img src="/images/update_list.gif" border="0"> #plus_content#</a>
							</td>
							<td><cfif len(plus_date)><b><cf_get_lang_main no='71.Kayit'></b> #dateformat(plus_date,dateformat_style)#</cfif> -
                        <cfif len(employee_id)>#get_emp_info(record_emp,0,0)#</cfif></td>
						</tr>
					
				</table>
			</td>
		</tr>
				<cfif not get_opportunity_pluses.recordcount>
						<cfoutput>
							<tr>
								<td>#getLang('main',72)# !</td>
							</tr>
						</cfoutput>
					</cfif>
	</table>
	</cfoutput>
			

<!---
<cf_ajax_list>
    <tbody>
	
		<tr height="25">
			<td  width="100%" onclick="gizle_goster(notes);"><cfoutput>#getLang('main',10)#</cfoutput></td> <!--- Notlar --->
			<td align="right"><!---<cfoutput><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_form_add_note&action=#attributes.action_section#&action_id=#attributes.action_id#&is_special=#attributes.is_special#&action_type=#attributes.action_type#<cfif isdefined("attributes.action_id_2")>&action_id_2=#attributes.action_id_2#</cfif>','small','popup_form_add_note')"><img src="/images/plus_list.gif" border="0" alt="#caller.getLang('main',170)#"></a></cfoutput>---></td>
	  	</tr>
		<tr id="notes" height="20" >
			<td colspan="2">
				<table width="100%">
					<cfoutput query="get_opportunity_pluses">
						<tr>
							<td width="80%"><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=sales.popup_form_upd_opp_plus&opp_plus_id=#opp_plus_id#','medium');"><img src="/images/update_list.gif" border="0"></a></td>
							<td><cfif len(plus_date)><b><cf_get_lang_main no='71.Kayit'></b> #dateformat(plus_date,dateformat_style)#</cfif> -
                        <cfif len(employee_id)>#get_emp_info(record_emp,0,0)#</cfif>
						
								#plus_content#
							</td>
						</tr>
					</cfoutput>
					<cfif not get_opportunity_pluses.recordcount>
						<cfoutput>
							<tr>
								<td>#getLang('main',72)# !</td>
							</tr>
						</cfoutput>
					</cfif>
				</table>
			</td>
		</tr>
	
		<!---<cfif get_opportunity_pluses.recordcount>	
			<cfoutput query="get_opportunity_pluses">
                <tr>
                    <td>
						<cfif len(plus_date)><b><cf_get_lang_main no='71.Kayit'></b> #dateformat(plus_date,dateformat_style)#</cfif> -
                        <cfif len(employee_id)>#get_emp_info(record_emp,0,0)#</cfif>
                        <cfif len(commethod_id)>&nbsp; -
							<cfset attributes.commethod_id = commethod_id>
                            <cfinclude template="/V16/sales/query/get_commethod.cfm">
                        	#get_commethod.commethod#
                        </cfif>
                        <cfif mail_sender neq '' and is_email eq 1><b><cf_get_lang no='48.E-posta Gonderilenler'></b> : #mail_sender#</cfif>
                        <cfif mail_cc neq ''><b><br/><br/><cf_get_lang_main no='1361.Bilgi Verilecekler'></b> : #mail_cc#</cfif><br/><br/>
                        #plus_content#
                    </td>
                    <td width="15" valign="top"><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=sales.popup_form_upd_opp_plus&opp_plus_id=#opp_plus_id#','medium');"><img src="/images/update_list.gif" border="0"></a></td>
                </tr>
            </cfoutput>
        <cfelse>
            <tr>
                <td colspan="2"><cf_get_lang_main no='72.Kayit Yok'> !</td>
            </tr>
        </cfif>--->
    </tbody>
</cf_ajax_list>
--->
