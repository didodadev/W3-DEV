<!--- Egitim Katilimci Importu --->
<cf_form_box title="#getLang('training_management',3)#">
<cfform name="formimport" action="" enctype="multipart/form-data" method="post">
	<table>
		<tr>
			<td valign="top">
				<table>
					<tr>
						<td width="100" class="txtboldblue"><cf_get_lang no='41.Belge Formatı'></td>
						<td>
							<select name="file_format" id="file_format" style="width:200;">
								<option value="UTF-8">UTF-8</option>
							</select>
						</td>
					</tr>
					<tr>
						<td class="txtboldblue"><cf_get_lang_main no='56.Belge'>*</td>
						<td><input type="file" name="uploaded_file" id="uploaded_file" style="width:200;"></td>
					</tr>
				</table>
			</td>
			<td valign="top"> 
				&nbsp;<strong><cf_get_lang_main no ='217.Açıklama'></strong>:<br/>
				&nbsp;&nbsp;<cf_get_lang_main no='2309.Dosya uzantısı csv olmalı kaydedilirken karakter desteği olarak UTF-8 seçilmelidir Alan araları noktalı virgül(;) ile ayrılmalı sayısal değerler için nokta(.) ayrac olarak kullanılmalıdır'><br/>
				&nbsp;&nbsp;Aktarım işlemi dosyanın 2 satırından itibaren başlar bu yüzden birinci satırda alan isimleri mutlaka olmalıdır.<br/>
				&nbsp;&nbsp;Belgede toplam 2 alan olacaktır alanlar sırasi ile;<br/><br/>
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;1-TC Kimlik Numarası<br/>
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;2-Eğitim ID<br/>
			</td>
		</tr>
	</table>
	<cf_form_box_footer><cf_workcube_buttons type_format="1" is_upd='0' add_function='kontrol()'></cf_form_box_footer>
</cfform>
</cf_form_box>
<script type="text/javascript">
	function kontrol()
		{
			windowopen('','small','cc_edu');
			formimport.action='<cfoutput>#request.self#</cfoutput>?fuseaction=training_management.emptypopup_add_edu_parti_import';
			formimport.target='cc_edu';
			formimport.submit();
			return false;
		}
</script>
