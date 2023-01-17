<cfinclude template="../query/get_commethods.cfm">
<cfinclude template="../query/get_quiz_stages.cfm">
<cfinclude template="../query/get_position_cats.cfm">
<cfform name="add_quiz" method="post" action="#request.self#?fuseaction=training_management.emptypopup_add_eval_quiz">
<table width="98%" align="center" cellpadding="0" cellspacing="0" border="0">
	<tr style="height:30px;">
		<td class="headbold"><cf_get_lang no='313.Değerlendirme Formu'></td>
	</tr>
</table>
<table width="98%" align="center" cellpadding="0" cellspacing="0" border="0">
	<tr class="color-border">
		<td>
		<table width="100%" cellpadding="2" cellspacing="1" border="0">
			<tr class="color-row">
				<td valign="top">
				<table border="0">
					<tr>
						<td colspan="3" class="formbold"><cf_get_lang_main no='2086.Form Bilgileri'> </td>
					</tr>
					<tr>
						<td><cf_get_lang_main no='68.Başlık'>*</td>
						<td>
							<cfsavecontent variable="message"><cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='1408.başlık'></cfsavecontent>
							<cfinput type="text" name="quiz_head" style="width:330px;" required="Yes" message="#message#">
							<input type="checkbox" name="IS_ACTIVE" id="IS_ACTIVE"><cf_get_lang_main no='81.Aktif'> 
						</td>
					</tr>
					<tr>
						<td><cf_get_lang no='32.Amaç'> / <cf_get_lang_main no='217.Açıklama'></td>
						<td><textarea name="quiz_objective" id="quiz_objective" style="width:400px;height:100px;"></textarea></td>
					</tr>
					<input type="hidden" name="COMMETHOD_ID" id="COMMETHOD_ID" value="5">
					<input type="hidden" name="PERIOD_PART" id="PERIOD_PART" value="1">
					<tr>
						<td><cf_get_lang no='244.Yayın Aşama'></td>
						<td>
							<select name="STAGE_ID" id="STAGE_ID">
							<cfoutput query="get_quiz_stages">
							<option value="#stage_id#">#stage_name# 
							</cfoutput>
							</select>
							&nbsp;
							<select name="IS_TYPE" id="IS_TYPE">
							<option value="IS_EDUCATION"><cf_get_lang no='246.Eğitim Yönetiminde Kullanılacak'></option>
							<option value="IS_TRAINER"><cf_get_lang no='245.Eğitimci için kullanılacak'></option>
							</select>
						</td>					
					</tr>
					<tr>
						<td height="25" colspan="2" style="text-align:right;"><cf_workcube_buttons is_upd='0'></td>
					</tr>
				</table>
				</td>
			</tr>
		</table>
		</td>
	</tr>
</table>
</cfform>

