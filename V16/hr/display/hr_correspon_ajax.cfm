<cfsetting showdebugoutput="no">
<cf_flat_list>
	<thead>
		<tr>
			<th><cf_get_lang dictionary_id='57480.Konu'></th>
			<th><cf_get_lang dictionary_id='33152.Email'></th>
			<th><cf_get_lang dictionary_id='57742.Tarih'></th>
			<th  width="30"><a><i class="fa fa-pencil" border="0"></i></a></th>
		</tr>
	</thead>
	<tbody>
	<cfquery name="GET_EMPAPP_MAIL" datasource="#DSN#">
		SELECT * FROM EMPLOYEES_APP_MAILS WHERE EMPAPP_ID = #attributes.EMPAPP_ID# AND APP_POS_ID IS NULL AND LIST_ID IS NULL ORDER BY RECORD_DATE DESC
	</cfquery> 
	<!--- 13062005<cfinclude template="../query/get_app_position_quiz.cfm">--->
	<cfif isDefined("GET_EMPAPP_MAIL") and GET_EMPAPP_MAIL.recordcount>
		<cfoutput query="GET_EMPAPP_MAIL">
		<tr>
			<td>#GET_EMPAPP_MAIL.MAIL_HEAD#</td>
			<td>#GET_EMPAPP_MAIL.EMPAPP_MAIL#</td>
			<td>#dateFormat(GET_EMPAPP_MAIL.RECORD_DATE,dateformat_style)#</td>
			<td width="30"><a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=hr.popup_app_upd_mail&empapp_id=#attributes.empapp_id#&EMP_APP_MAIL_ID=#EMP_APP_MAIL_ID#&draggable=1');"><i class="fa fa-pencil"></a></td>
		</tr>
		</cfoutput>
	</cfif>
	<cfif isDefined("GET_EMPAPP_MAIL") and (GET_EMPAPP_MAIL.recordcount eq 0)>
		<tr>
			<td colspan="2"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'> !</td>
		</tr>
	</cfif>
    </tbody>
</cf_flat_list>

