<cfquery name="GET_SECRET_QUESTIONS" datasource="#DSN#">
    SELECT 
        QUESTION,
        QUESTION_ID 
    FROM 
        SECRET_QUESTION
</cfquery>
<cfquery name="get_consumer_question" datasource="#dsn#"> 
	SELECT 
    	*
	FROM 
    	MEMBER_SECRET_ANSWER
	WHERE
    	CONSUMER_ID = #attributes.consumer_id#
</cfquery>
<cfsavecontent variable="message"><cf_get_lang dictionary_id="30209.Sorunuz ve Gizli Yanıtınız"></cfsavecontent>
<cf_popup_box title="#message#">
<cfform name="secret_question_form" action="#request.self#?fuseaction=member.emptypopup_member_secret_answer&consumer_id=#attributes.consumer_id#" method="post">
<input type="text" name="control" id="control" style="display:none;" value="1" />
	<table border="0">
		<tr>
			<td><cf_get_lang dictionary_id='58810.Soru'></td>
			<td>
				<select name="secret_question" id="secret_question" style="width:300px;">
					<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
					<cfoutput query="get_secret_questions">
						<option value="#question_id#"<cfif question_id eq get_consumer_question.question_id>selected</cfif>>#QUESTION#</option>
					</cfoutput>
				</select>
			</td>
		</tr>
		<tr>
			<td><cf_get_lang dictionary_id='30300.Gizli Yanıt'></td>
			<td>
				<cfsavecontent variable="message"><cf_get_lang dictionary_id="59908.Cevap Giriniz"> !</cfsavecontent>
				<cfinput type="text" name="secret_answer" value="#get_consumer_question.answer#" maxlength="100" required="yes" message="#message#" style="width:300px;">
			</td>
		</tr>
	</table>
	<cf_popup_box_footer>
		<cfif get_consumer_question.recordcount>
			<cf_record_info query_name="get_consumer_question" record_emp="record_emp">          
		</cfif>
		<cfif get_consumer_question.recordcount>
			<cf_workcube_buttons type_format="1" is_upd='0' insert_info='Güncelle' add_function='kontrol_question()'>
		<cfelse>
			<cf_workcube_buttons type_format="1" is_upd='0' add_function='kontrol_question()'>
		</cfif>
	</cf_popup_box_footer>
</cfform>
</cf_popup_box>
<script type="text/javascript">
function kontrol_question()
{
	if(document.getElementById('secret_question').value == "")
	{
		alert("<cf_get_lang dictionary_id='30303.Gizli Soru Seçiniz !'>");
		return false;
	}
}
</script>
