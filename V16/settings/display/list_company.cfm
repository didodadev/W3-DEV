<cfquery name="GET_COMPANY_LIST" datasource="#DSN#">
	SELECT COMP_ID,COMPANY_NAME FROM OUR_COMPANY
</cfquery>
	<ul class="ui-list">
		<cfif GET_COMPANY_LIST.recordcount>
			<cfoutput query="GET_COMPANY_LIST">
				<li>
					<a onclick="send_ajax(#comp_id#)">
						<div class="ui-list-left">
							#COMPANY_NAME#
						</div>
					<div class="ui-list-right">
						<i class="fa fa-pencil"></i>
					</div>
				</a>
			</li>
			</cfoutput>
		<cfelse>
			<cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!
		 </cfif>
	</ul>
<!--- <cf_get_lang dictionary_id='29531.Şirketler'> --->

<script>
	function send_ajax(id){
	  AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=settings.form_list_company&callAjax=1&is_settings_page=1&ourcompany_id=' + id,'detail_div');               
	}
</script>