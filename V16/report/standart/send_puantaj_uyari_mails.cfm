<cfif not isdefined("attributes.employee_id_list") or not listlen(attributes.employee_id_list)>
	<script type="text/javascript">
		alert('Çalışan Seçmediğiniz İçin Uyarı Maili Gönderemezsiniz!');
		window.close();
	</script>
	<cfabort>
</cfif>
<cfquery name="get_mail_warnings" datasource="#dsn#">
	SELECT 
		* 
	FROM 
		SETUP_MAIL_WARNING
	ORDER BY
		MAIL_CAT
</cfquery>
<cfsavecontent variable="head"><cf_get_lang dictionary_id='55720'></cfsavecontent>
<cfform name="send_" action="#request.self#?fuseaction=report.emptypopup_send_puantaj_uyari_mails">
<cf_big_list_search title='#head#'>
	<cf_big_list_search_area>
		<div class="row warningsGenel">
			<cfoutput>
				<input type="hidden" name="sal_mon" id="sal_mon" value="#attributes.sal_mon#">
				<input type="hidden" name="sal_year" id="sal_year" value="#attributes.sal_year#">
				<input type="hidden" name="employee_id_list" id="employee_id_lists" value="#attributes.employee_id_list#">
				<div class="form-group col col-9 col-md-9">
					<label class="col col-3 col-md-3"><cf_get_lang dictionary_id='53617'></label>
					<div class="col col-9 col-md-9">
						<div class="input-group x-14">
							<select name="message_type" id="message_type" style="width:200px;" onChange="make_action();">
									<option value="">Seçiniz</option>
								<cfloop query="get_mail_warnings">
									<option value="#MAIL_CAT_ID#">#MAIL_CAT#</option>
								</cfloop>
							</select>
						</div>
					</div>
				</div>
				<div class="form-group col col-3">
					<div class="input-group">
						<cf_workcube_buttons is_upd='0'>
					</div>
				</div>
			</cfoutput>
		</div>
		<div class="row ReportContentBorder">
			<label class="col col-12 col-md-12 col-xs-12"><cf_get_lang dictionary_id='57629'></label>
			<cfoutput query="get_mail_warnings">
				<div class="ReportContentFooter" id="alan_#MAIL_CAT_ID#" <cfif currentrow neq 1>style="display:none;"</cfif>>
					#DETAIL#
				</div>
			</cfoutput>
		</div>
	</cf_big_list_search_area>
</cf_big_list_search>
</cfform>
<!--- <table cellspacing="1" cellpadding="2" border="0" width="100%" height="100%" class="color-border">
	<cfform name="send_" action="#request.self#?fuseaction=report.emptypopup_send_puantaj_uyari_mails">
		<tr class="color-list" valign="middle">
		<td height="35" class="headbold">Uyarı Maili Gönder</td>
		</tr>
		<tr class="color-row">
			<td valign="top">
				<cfoutput>
				<table>
						<input type="hidden" name="sal_mon" id="sal_mon" value="#attributes.sal_mon#">
						<input type="hidden" name="sal_year" id="sal_year" value="#attributes.sal_year#">
						<input type="hidden" name="employee_id_list" id="employee_id_lists" value="#attributes.employee_id_list#">
						
					<tr>
						<td>Mesaj Tipi</td>
						<td>
							<select name="message_type" id="message_type" style="width:200px;" onChange="make_action();">
									<option value="">Seçiniz</option>
								<cfloop query="get_mail_warnings">
									<option value="#MAIL_CAT_ID#">#MAIL_CAT#</option>
								</cfloop>
							</select>
						</td>
					</tr>
					<tr>
						<td></td>
						<td height="30" align="right" style="text-align:right;"><cf_workcube_buttons is_upd='0'></td>
					</tr>
				</table>
				</cfoutput>
				<br/><br/>
				&nbsp;<b>Açıklama</b><br/>
				<table>
					<cfoutput query="get_mail_warnings">
					<tr id="alan_#MAIL_CAT_ID#" <cfif currentrow neq 1>style="display:none;"</cfif>>
						<td>#DETAIL#</td>
					</tr>
					</cfoutput>
				</table>
			</td>
		</tr>
	</cfform>
</table> --->
<script type="text/javascript">
	function make_action()
	{
	<cfoutput query="get_mail_warnings">
		gizle(alan_#MAIL_CAT_ID#);
		goster(eval("alan_"+document.send_.message_type.value));
	</cfoutput>
	}
</script>
