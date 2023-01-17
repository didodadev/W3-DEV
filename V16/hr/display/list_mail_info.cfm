<cfquery name="get_email_list" datasource="#dsn#">
	SELECT 
		EMPLOYEE_ID,MAILBOX_ID,EMAIL,ACCOUNT,POP,SMTP 
	FROM 
		CUBE_MAIL
	WHERE 
		EMPLOYEE_ID=#attributes.employee_id#
</cfquery>
<cfsavecontent variable="message"><cf_get_lang dictionary_id="55261.Mail Hesapları"></cfsavecontent>
<cf_box title="#message# : #get_emp_info(attributes.employee_id,0,0)#" scroll="1" collapsable="0" resize="0" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<cf_flat_list>
		<thead>
			<tr>
				<th><cf_get_lang dictionary_id='57551.Kullanıcı Adı'></th>
				<th width="150"><cf_get_lang dictionary_id='57428.Eposta'></th>
				<th width="150"><cf_get_lang dictionary_id='39189.pop'></th>
				<th width="150"><cf_get_lang dictionary_id='39191.smtp'></th>
				<th width="15"><a href="javascript://" onClick="open_add_mail();" title="<cf_get_lang dictionary_id='44630.Ekle'>"><i class="fa fa-plus"></i></a></th>
			</tr>
		</thead>
		<tbody>
			<cfif get_email_list.recordcount>
				<cfoutput query="get_email_list">
					<tr>
						<td>#ACCOUNT#</td>
						<td>#EMAIL#</td>
						<td>#POP#</td>
						<td>#SMTP#</td>
						<td><a href="javascript://" onClick="open_upd_mail(#mailbox_id#);" title="<cf_get_lang dictionary_id='57464.Güncelle'>"><i class="fa fa-pencil"></i></a></td>
					</tr>
				</cfoutput>
			<cfelse>
				<tr>
					<td colspan="5"><cf_get_lang dictionary_id='57484.kayit yok'></td>
				</tr>
			</cfif>
		</tbody>
	</cf_flat_list>
</cf_box>
<script type="text/javascript">
function open_add_mail()
{
	openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_crate_mail_account&employee_id=<cfoutput>#attributes.employee_id#</cfoutput>','','ui-draggable-box-medium');
}
function open_upd_mail(mbox_id)
{
	openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_upd_email&employee_id=<cfoutput>#attributes.employee_id#</cfoutput>&mailbox_id='+mbox_id, 'mail_info_upd','ui-draggable-box-medium');
}
</script>
