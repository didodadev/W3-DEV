<cfquery name="GET_APP" datasource="#DSN#">
	SELECT APP_POS_ID FROM EMPLOYEES_APP_POS WHERE APP_POS_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.app_pos_id#"> AND EMPAPP_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.cp.userid#">
</cfquery>
<cfif get_app.recordcount>
	<cfquery name="GET_MAILS" datasource="#dsn#">
		SELECT 
			RECORD_DATE,
			MAIL_HEAD,
			MAIL_CONTENT,
			EMP_APP_MAIL_ID
		FROM
			EMPLOYEES_APP_MAILS
		WHERE
			<cfif isdefined('attributes.empapp_id') and len(attributes.empapp_id)>
				EMPAPP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.empapp_id#">
			<cfelse>
				APP_POS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.app_pos_id#">
			</cfif>
	</cfquery>
	<table cellspacing="0" cellpadding="0" border="0" height="100%" width="100%">
		<tr> 
			<td valign="middle"> 
				<table cellspacing="1" cellpadding="2" border="0" width="100%" height="100%">
					<tr bgcolor="#FFB74A" valign="middle"> 
						<td height="35"> 
							<table width="98%" align="center">
								<tr> 
									<td valign="bottom" class="txtbold"><cf_get_lang no='914.Cevap Mektupları'></td>
							  	</tr>
							</table>
					  	</td>
					</tr>
					<tr class="color-row" valign="top"> 
						<td> 
							<table align="center" width="98%" cellpadding="0" cellspacing="0" border="0">
								<tr>
									<td colspan="2">
										<cfif get_mails.recordcount>
											<table>
												<cfoutput query="get_mails">
												<tr>
													<td class="txtbold" width="20"><cf_get_lang_main no='330.Tarih'>:</td>
													<td>#dateformat(get_mails.record_date,'dd/mm/yyyy')#</td>
												</tr>
												<tr>
													<td class="txtbold"><cf_get_lang_main no='68.Başlık'>:</td>
													<td>#get_mails.mail_head#</td>
												</tr>
												<tr>
													<td colspan="2">#get_mails.mail_content#</td>
												</tr>
												<tr>
													<td colspan="2"><hr></td>
												</tr>
												</cfoutput>
											</table>
										</cfif>
									</td>
								</tr>
								<tr height="35"> 
									<td colspan="2"  class="txtbold" style="text-align:right;"><a href="javascript:window.close();">&laquo; <cf_get_lang_main no='141.Kapat'> &raquo;</a></td>
								</tr>
							</table>
						</td>
					</tr>
		  		</table>
			</td>
	  	</tr>
	</table>
<cfelse>
	<cflocation url="#request.self#?fuseaction=objects2.list_app_pos" addtoken="no">
</cfif>
