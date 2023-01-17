<cfsetting showdebugoutput="no">
<cfquery name="DETAIL_NOTES_VISITED" datasource="#DSN#">
	<cfif  isdefined ("attributes.note_id")>
        DELETE 
        FROM
            VISITING_NOTES
        WHERE
            V_NOTE_ID=#attributes.note_id# 
    <cfelse> 
         SELECT
            *
        FROM
            VISITING_NOTES
        WHERE
            V_NOTE_ID=#attributes.id# AND
		   NOTE_TAKEN_TYPE = 1 AND
            NOTE_TAKEN_ID = #SESSION.EP.USERID# 
        ORDER BY 
            V_NOTE_ID DESC
    </cfif>
</cfquery>
<!--- <cfdump var="#DETAIL_NOTES_VISITED#"> --->
<cfoutput>
<div style="overflow:auto;border:0;">
    <table border="0"cellpadding="2" width="100%" cellspacing="1" class="color-border" align="center">
        <tr class="color-list" id="notes_#attributes.id#">
            <td>
                <table width="100%">
                    <tr>
                      <td class="txtbold"><cf_get_lang dictionary_id='30907.Not Bırakan'></td>
                      <td><!--- <cfif len(#detail_notes_visited.record_emp#)>#get_emp_info(detail_notes_visited.record_emp,0,0)#<cfelse> --->#detail_notes_visited.NOTE_GIVEN#---#get_emp_info(detail_notes_visited.record_emp,0,0)#<!--- </cfif> ---></td>
                    </tr>
                    <tr>
                      <td class="txtbold"><cf_get_lang dictionary_id='57499.Telefon'></td>
                      <td>#detail_notes_visited.tel#</td>
                    </tr>
                    <tr>
                      <td class="txtbold"><cf_get_lang dictionary_id='57428.E-Mail'></td>
                      <td>#detail_notes_visited.email#</td>
                    </tr>
                    <tr>
                      <td class="txtbold" valign="top"><cf_get_lang dictionary_id='57629.Açıklama'></td>
                      <td></td>
                    </tr>
                    <tr>
                    	<td colspan="2" width="100%">
	                     #detail_notes_visited.DETAIL#
                        </td>
                    </tr>
                    <tr>
                        <td class="txtbold" colspan="2"><cf_get_lang dictionary_id='57483.Kayıt'> :
                         <cfif isdefined("detail_notes_visited.record_emp") and len(detail_notes_visited.RECORD_EMP)>
                            #get_emp_info(detail_notes_visited.RECORD_EMP,0,0)#
                        <cfelseif isdefined("detail_notes_visited.RECORD_PAR") and len(detail_notes_visited.RECORD_PAR)>
                            #get_par_info(detail_notes_visited.RECORD_PAR,0,-1,0)#
                        <cfelseif isdefined("detail_notes_visited.RECORD_CON") and len(detail_notes_visited.RECORD_CON)>
                            #get_cons_info(detail_notes_visited.RECORD_CON,0,0)#
                        </cfif>
                            #dateformat(detail_notes_visited.RECORD_DATE,dateformat_style)#
                       </tr>
                       <cfif not isdefined (attributes.satir_id)> 
                    <tr>
                      <td colspan="2"  style="text-align:right;">
                      <cfset employee_id = get_emp_info(detail_notes_visited.RECORD_EMP,0,0)>
                        <input type="button" value="Cevap Ver" style="width:65" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_add_nott&employee_id=#detail_notes_visited.RECORD_EMP#','small');">
					    <!--- <input type="button" value="<cf_get_lang_main no='51.Sil'>" style="width:65" onClick="if(confirm('Kayıtlı Notu Siliyorsunuz. Emin misiniz?')) <!--- window.location.href='#request.self#?fuseaction=objects.emptypopup_del_visiting_notes&note_id=#attributes.id#&ajax=1';else return false;" --->{AjaxPageLoad('#request.self#?fuseaction=objects.emptypopup_del_visiting_notes&note_id=#attributes.id#','notes_ajax',1,'Siliniyor...');gizle(notes_#attributes.satir_id#);gizle(NOTES_DETAIL#attributes.satir_id#);}else return false;"> --->
                    </td>
                   </tr>
                    </cfif> 
                </table>
            </td>
        </tr>
    </table>
</div>
</cfoutput>

