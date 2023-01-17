<cf_popup_box title="#getLang('main',61)#">
	<cfif isDefined("attributes.help_id")>
		<cfquery name="get_help_history" datasource="#dsn#">
		SELECT
			*,
			CASE WHEN UPDATE_MEMBER = 'e' THEN (SELECT EMPLOYEE_NAME + ' ' + EMPLOYEE_SURNAME NAME_SURNAME FROM EMPLOYEES WHERE EMPLOYEE_ID = UPDATE_ID) ELSE '' END AS UPDATE_EMPLOYEE
		FROM
			HELP_DESK_HISTORY
		WHERE
			HELP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.help_id#">
		ORDER BY
			HELP_HISTORY_ID DESC
		</cfquery>
		<cfif get_help_history.recordcount>
			<cfoutput query="get_help_history">
			<table>
				<!---<tr>
					<td style="width:90px;">&nbsp;</td>
					<td><label class="txtbold"><cf_get_lang_main no='1584.Dil'></label> : #help_language# &nbsp;&nbsp;&nbsp;
						<label class="txtbold"><cf_get_lang_main no='1682.Yayın'></label> : <cfif is_internet eq 1><cf_get_lang_main no='83.Evet'><cfelse><cf_get_lang_main no='84.Hayır'></cfif>  &nbsp;&nbsp;&nbsp;
						<label class="txtbold">SSS</label> : <cfif is_faq eq 1><cf_get_lang_main no='83.Evet'><cfelse><cf_get_lang_main no='84.Hayır'></cfif>
					</td>
				</tr> --->
				<tr>
					<td class="txtbold"><cf_get_lang_main no='1584.Dil'></td>
					<td>: </td>
					<td>#help_language#</td>
				</tr>
				<tr>
					<td class="txtbold"><cf_get_lang_main no='1682.Yayın'></td>
					<td>: </td>
					<td><cfif is_internet eq 1><cf_get_lang_main no='83.Evet'><cfelse><cf_get_lang_main no='84.Hayır'></cfif></td>
				</tr>
				<tr>
					<td class="txtbold">SSS</td>
					<td>: </td>
					<td><cfif is_faq eq 1><cf_get_lang_main no='83.Evet'><cfelse><cf_get_lang_main no='84.Hayır'></cfif></td>
				</tr>
				<tr>
					<td class="txtbold"><cf_get_lang_main no='1584.Dil'></td>
					<td>: </td>
					<td>#help_language#</td>
				</tr>
				<tr>
					<td class="txtbold"><cf_get_lang_main no='169.Sayfa'></td>
					<td>: </td>
					<td>#help_circuit#.#help_fuseaction#</td>
				</tr>
				<tr>
					<td class="txtbold"><cf_get_lang_main no='291.Güncelleme'></td>
					<td>: </td>
					<td>#update_employee#</td>
				</tr>
				<tr>
					<td class="txtbold"><cf_get_lang_main no='330.Tarih'></td>
					<td>: </td>
					<td><cfif Len(update_date)>#DateFormat(update_date,dateformat_style)# #TimeFormat(DateAdd('h',session.ep.time_zone,update_date),timeformat_style)#</cfif></td>
				</tr>
				
				<tr>
					<td class="txtbold"><cf_get_lang_main no='68.Konu'></td>
					<td>: </td>
					<td>#help_head#</td>
				</tr>
				<tr>
					<td class="txtbold" valign="top"><cf_get_lang_main no='217.Açıklama'></td>
					<td>: </td>
					<td nowrap="nowrap"><div style="margin-top:-3x; margin-left:1px;">#help_topic#</div></td>
				</tr>
				<tr height="20">
					<td colspan="2">&nbsp;</td>
				</tr>
			 </table>
			</cfoutput>
		<cfelse>
			<table>
				<tr>
					<td><cf_get_lang_main no ='72.Kayıt Yok'>!</td>
				</tr>
			</table>
		</cfif>
	</cfif>
</cf_popup_box>
