<table width="98%" height="35" border="0" align="center" cellpadding="0" cellspacing="0" >
	<tr>
		<td  class="headbold"><cf_get_lang no='593.İletişim Yöntemi Güncelle'></td>
		<td align="right" style="text-align:right;"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=settings.form_add_com_method"><img src="/images/plus1.gif" border="0" align="absmiddle" alt="<cf_get_lang_main no='170.Ekle'>"></a></td>
	</tr>
</table>
<table width="98%" border="0" align="center" cellpadding="2" cellspacing="1" class="color-border">
	<tr class="color-row">
		<td width="200" valign="top">
			<cfinclude template="../display/list_com_method.cfm">
		</td>
		<td valign="top" >
			<table border="0">
				<cfform action="#request.self#?fuseaction=settings.emptypopup_com_method_upd" method="post" name="com_method" >
					<input type="Hidden" ID="clicked" value="">
					<cfquery name="CATEGORY" datasource="#dsn#">
						SELECT 
                        	COMMETHOD_ID, 
                            COMMETHOD, 
                            IS_DEFAULT, 
                            RECORD_DATE, 
                            RECORD_EMP, 
                            RECORD_IP, 
                            UPDATE_DATE, 
                            UPDATE_EMP, 
                            UPDATE_IP 
                        FROM 
                        	SETUP_COMMETHOD 
                        WHERE 
                        	COMMETHOD_ID=#URL.ID#
					</cfquery>
					<input type="hidden" name="comMethod_ID" id="comMethod_ID" value="<cfoutput>#URL.ID#</cfoutput>">
					<tr>
						<td width="100"><cf_get_lang_main no='74.Kategori'>*</td>
						<td>
							<cfsavecontent variable="message"><cf_get_lang_main no='720.Kategori girmelisiniz'></cfsavecontent>
							<cfinput type="Text" name="comMethod" style="width:150px;" value="#category.comMethod#" maxlength="20" required="Yes" message="#message#">
							<cf_language_info 
									table_name="SETUP_COMMETHOD" 
									column_name="COMMETHOD" 
									column_id_value="#attributes.id#" 
									maxlength="500" 
									datasource="#dsn#" 
									column_id="COMMETHOD_ID" 
									control_type="0">
						</td>
					</tr>
					<tr>
						<td></td>
						<td><input type="checkbox" name="is_default" id="is_default" value="1"<cfif category.is_default eq 1> checked</cfif>><cf_get_lang no ='1132.Standart Seçenek Olarak Gelsin'> (Default)</td>
					</tr>	
					<tr height="35">
						<td></td>
						<td>
							<cf_workcube_buttons is_upd='1' is_delete='0'>
						</td>
					</tr>
					<tr>
						<td colspan="2"><p><br/>
							<cfoutput>
								<cfif len(category.record_emp)>
									<cf_get_lang_main no='71.Kayıt'> : #get_emp_info(category.record_emp,0,0)# - #dateformat(category.record_date,dateformat_style)#
								</cfif><br/>
								<cfif len(category.update_emp)>
									<cf_get_lang_main no='291.Son Güncelleme'> : #get_emp_info(category.update_emp,0,0)# - #dateformat(category.update_date,dateformat_style)#
								</cfif>
							</cfoutput>
						</td>
					</tr>
				</cfform>
			</table>
		</td>
	</tr>
</table>

