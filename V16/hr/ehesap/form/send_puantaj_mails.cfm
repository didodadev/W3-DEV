<cfquery name="get_mail_warnings" datasource="#dsn#">
	SELECT 
		* 
	FROM 
		SETUP_MAIL_WARNING
	ORDER BY
		MAIL_CAT
</cfquery>
<cfinclude template="../query/get_puantaj.cfm">
<cfif not get_puantaj.recordcount>
	<script type="text/javascript">
		alert("<cf_get_lang dictionary_id='53712.Puantaj kaydı bulunmamaktadır'>. <cf_get_lang dictionary_id='35822.Bilgilerinizi kontrol ediniz.'>");
		window.close();
	</script>
	<cfabort>
</cfif>
<cfquery name="get_puantaj_branch" datasource="#dsn#" maxrows="1">
	SELECT BRANCH_ID,BRANCH_NAME,COMPANY_ID FROM BRANCH WHERE SSK_OFFICE = '#get_puantaj.SSK_OFFICE#' AND SSK_NO = '#get_puantaj.SSK_OFFICE_NO#'
</cfquery>
<cf_box title="#getLang('ehesap',670)# : #get_puantaj_branch.branch_name#(#listgetat(ay_list(),get_puantaj.sal_mon)# - #get_puantaj.sal_year#)">
	<cfform name="send_" action="#request.self#?fuseaction=ehesap.emptypopup_send_puantaj_mails">
		<cf_box_elements>
			<cfinput type="hidden" name="puantaj_id" id="puantaj_id" value="#get_puantaj.puantaj_id#">
			<cfif isdefined("attributes.employee_id")>
				<cfinput type="hidden" name="employee_id" id="employee_id" value="#attributes.employee_id#">
			</cfif>
			<div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
				<div class="form-group" id="item-is_send_all">
					<label class="col col-4 col-md-4 col-sm-4 col-xs-12"></label>
					<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
						<input type="checkbox" name="is_send_all" id="is_send_all" value="1"><cf_get_lang dictionary_id='59678.Daha önce mail gönderilen kişilerde dahil edillsin'>
					</div>
				</div>
				<div class="form-group" id="item-send_type">
					<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57143.Gönderim Tipi'></label>
					<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
						<select name="send_type" id="send_type">
							<option value="0"><cf_get_lang dictionary_id='59676.İçeriği Link Olarak Yolla'></option>
							<option value="1" selected="selected"><cf_get_lang dictionary_id='59677.İçeriği Mail Olarak Yolla'></option>
						</select>
					</div>
				</div>
				<div class="form-group" id="item-message_type">
					<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id="53617.Mesaj Tipi"></label>
					<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
						<select name="message_type" id="message_type" onChange="make_action(this.value);">
								<option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option>
								<cfoutput query="get_mail_warnings">
									<option value="#MAIL_CAT_ID#">#MAIL_CAT#</option>
								</cfoutput>
						</select>
					</div>
				</div>
				<div class="form-group" id="item-detail">
					<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id="57629.Açıklama"></label>
					<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
						<cfoutput query="get_mail_warnings">
							<div id="alan_#MAIL_CAT_ID#" class="alan" style="display:none;">
								<td>#DETAIL#</td>
							</div>
						</cfoutput>
					</div>
				</div>
			</div>
		</cf_box_elements>
		<cf_box_footer>
			<cf_workcube_buttons is_upd='0'>
		</cf_box_footer>
	</cfform>
</cf_box>
<script type="text/javascript">
	function make_action(message_type)
	{
		$('.alan').hide();
		my_query = wrk_query('SELECT DETAIL FROM SETUP_MAIL_WARNING WHERE MAIL_CAT_ID = ' + message_type,'dsn',1);
		if ( my_query.recordcount != 0) {
           $('#alan_'+message_type).val('my_query.DETAIL');
		   $('#alan_'+message_type).show();
        }   
	}
</script>
