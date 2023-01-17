<cfinclude template="../query/get_quiz.cfm">
<cfsavecontent variable="message"><cf_get_lang dictionary_id="55650.Form Kopyalama"></cfsavecontent>
<cf_form_box title="#message#:#get_quiz.quiz_head#">
    <cfform name="upd_quiz" method="post" action="#request.self#?fuseaction=hr.emptypopup_copy_quiz"> 
        <input type="hidden" name="quiz_id" id="quiz_id" value="<cfoutput>#attributes.quiz_id#</cfoutput>">
        <table>
            <tr>
                <td><cf_get_lang dictionary_id="55643.Yeni Form Adı"></td>
                <td><input type="text" name="new_quiz_head" id="new_quiz_head" style="width:350px;" value="<cfoutput>#get_quiz.quiz_head#</cfoutput>"></td>
            </tr>
            <tr>
                <td><cf_get_lang dictionary_id="55644.Yeni Form Dönemi"></td>
                <td>
                    <select name="new_form_year" id="new_form_year" style="width:65px;">
                        <cfoutput>
                            <cfloop from="1" to="5" index="i">
                                <option value="#i#">#i#</option>
                            </cfloop>
                        </cfoutput>
                    </select>
                </td>
            </tr>
            <tr>
                <td><cf_get_lang dictionary_id="55763.Tarihler"></td>
                <td>
                <cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='57655.Başlangıç Tarihi'></cfsavecontent>
                <cfinput required="Yes" message="#message#" type="text" name="start_date" validate="#validate_style#" value="#dateformat(get_quiz.start_date,dateformat_style)#" style="width:80px;">
                <cf_wrk_date_image date_field="start_date">
                <cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='57700.Bitiş Tarihi'></cfsavecontent>
                <cfinput required="Yes" message="#message#" type="text" name="finish_date" validate="#validate_style#" value="#dateformat(get_quiz.finish_date,dateformat_style)#" style="width:77px;">
                <cf_wrk_date_image date_field="finish_date">
                </td>
            </tr>
        </table>
		<cf_form_box_footer><cf_workcube_buttons is_upd='0'></cf_form_box_footer>
	</cfform>
</cf_form_box>
<!---
<table cellpadding="0" cellspacing="0" width="98%" align="center">
	<tr>
		<td class="headbold" height="35">Form Kopyalama : <cfoutput>#get_quiz.quiz_head#</cfoutput></td>
	</tr>
</table>
<table width="98%" cellpadding="2" cellspacing="1" border="0" class="color-border" align="center">
<cfform name="upd_quiz" method="post" action="#request.self#?fuseaction=hr.emptypopup_copy_quiz"> 
<input type="hidden" name="quiz_id" value="<cfoutput>#attributes.quiz_id#</cfoutput>">
	<tr class="color-list"> 
		<td>
			<table>
				<tr>
					<td>Yeni Form Adı</td>
					<td><input type="text" name="new_quiz_head" style="width:350px;" value="<cfoutput>#get_quiz.quiz_head#</cfoutput>"></td>
				</tr>
				<tr>
					<td>Yeni Form Dönemi</td>
					<td>
						<select name="new_form_year" style="width:65px;">
							<cfoutput>
								<cfloop from="1" to="5" index="i">
									<option value="#get_quiz.form_year#+i">#get_quiz.form_year#+i</option>
								</cfloop>
							</cfoutput>
						</select>
					</td>
				</tr>
				<tr>
					<td>Tarihler</td>
					<td>
					<cfsavecontent variable="message"><cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='243.Başlangıç Tarihi'></cfsavecontent>
					<cfinput required="Yes" message="#message#" type="text" name="start_date" validate="#validate_style#" value="#dateformat(get_quiz.start_date,dateformat_style)#" style="width:80px;">
					<cf_wrk_date_image date_field="start_date">
					<cfsavecontent variable="message"><cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='288.Bitiş Tarihi'></cfsavecontent>
					<cfinput required="Yes" message="#message#" type="text" name="finish_date" validate="#validate_style#" value="#dateformat(get_quiz.finish_date,dateformat_style)#" style="width:77px;">
					<cf_wrk_date_image date_field="finish_date">
					</td>
				</tr>
				<tr>
					<td colspan="2"  style="text-align:right;"><cf_workcube_buttons is_upd='0'></td>
				</tr>
			</table>
		</td>
	</tr>
</cfform>
</table>
--->
