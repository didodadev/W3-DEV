<cfinclude template="../query/get_training_style.cfm">
<table width="98%" height="35" border="0" align="center" cellpadding="0" cellspacing="0" >
	<tr>
		<td  class="headbold"><cf_get_lang no='1332.Eğitim Şekli Bilgisi Güncelle'></td>
		<td align="right" style="text-align:right;">
			<cfif listfirst(url.fuseaction,'.') is 'training_management'>
				<a href="<cfoutput>#request.self#</cfoutput>?fuseaction=training_management.form_add_training_style&is_training_management=1"><img align="right" src="/images/plus1.gif" border="0" alt="<cf_get_lang_main no='170.Ekle'>"></a>
			<cfelse>
				<a href="<cfoutput>#request.self#</cfoutput>?fuseaction=settings.form_add_training_style"><img align="right" src="/images/plus1.gif" border="0" alt="Eğitim Şekli Ekle"></a>
			</cfif>
		</td>
	</tr>
</table>
<table width="98%" border="0" align="center" cellpadding="2" cellspacing="1" class="color-border">
	<tr class="color-row">
		<td width="200" valign="top"><cfinclude template="../display/list_training_style.cfm"></td>
		<td valign="top">
		<table>
		<cfform name="upd_training_style" action="#request.self#?fuseaction=settings.emptypopup_upd_training_style">
		<input type="hidden" name="training_sytle_id" id="training_sytle_id" value="<cfoutput>#attributes.training_sytle_id#</cfoutput>">
			<tr>
				<td width="100"><cf_get_lang_main no='81.Aktif'></td>
				<td><input type="checkbox" name="is_aktif" id="is_aktif" value="1" <cfif GET_TRAIN.IS_ACTIVE>checked</cfif>></td>
			</tr>
			<tr>
				<td width="100"><cf_get_lang no='1035.Eğitim Şekli'>*</td>
				<td>
					<cfsavecontent variable="message"><cf_get_lang no='1191.Eğitim Şekli Girmelisiniz'></cfsavecontent>
					<cfinput type="text" name="train_style_name" value="#GET_TRAIN.TRAINING_STYLE#" maxlength="50" required="Yes" message="#message#" style="width:150px;">
					<cf_language_info 
					table_name="SETUP_TRAINING_STYLE" 
					column_name="TRAINING_STYLE" 
					column_id_value="#attributes.training_sytle_id#" 
					maxlength="500" 
					datasource="#dsn#" 
					column_id="TRAINING_STYLE_ID" 
					control_type="0">
				</td>
			</tr>
			<tr>
				<td width="100"><cf_get_lang_main no='217.Açıklama'></td>
				<td><textarea name="detail" id="detail" style="width:150px;height:50px" maxlength="150" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="150 Karakterden Fazla Yazmayınız!!"><cfoutput>#GET_TRAIN.DETAIL#</cfoutput></textarea></td>
			</tr>
			<tr>
				<td></td>
				<td height="35"><cf_workcube_buttons is_upd='1' is_delete='0'></td>
			</tr>
			<tr>
				<td colspan="2" align="left">
					<p><br/>
					<cf_get_lang_main no='71.Kayıt'> :<cfoutput>#get_emp_info(GET_TRAIN.RECORD_EMP,0,0)# - #dateformat(GET_TRAIN.RECORD_DATE,dateformat_style)#</cfoutput>
				</td>
			</tr>
		<cfif len(GET_TRAIN.UPDATE_EMP)>
			<tr>
				<td colspan="2"><cf_get_lang_main no='291.Son Güncelleme'> :<cfoutput>#get_emp_info(GET_TRAIN.UPDATE_EMP,0,0)# - #dateformat(GET_TRAIN.UPDATE_DATE,dateformat_style)#</cfoutput></td>
			</tr>
		</cfif>
		</cfform>
		</table>
		</td>
	</tr>
</table>
