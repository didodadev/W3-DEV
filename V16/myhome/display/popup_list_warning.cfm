<cfset attributes.warning_date = dateformat(now(),dateformat_style)>
<cf_date tarih="attributes.warning_date">
<!--- Aksiyon butonlarına tıkladıktan sonra şerh düşmek amacıyla gelen ekranı oluşturur! ---->
<cfif IsDefined("attributes.mode") and attributes.mode eq 'getactionnote'>
	<cfparam name="attributes.view_mode" type="string" default="flex"><!--- flex - box --->
	<cfform name="actionNote" action="#request.self#?fuseaction=myhome.emptypopup_upd_list_warning&fuseaction_=#attributes.fuseaction_#&#attributes.type#_ids=#attributes.id##attributes.view_mode eq 'box' ? '&reload_link=1':''#">
		<cfinput type="hidden" name="mandate_position" id="mandate_position" value="#(isDefined('attributes.mandate_position_code') and len(attributes.mandate_position_code)) ? attributes.mandate_position_code : ''#">
		
		<cfswitch expression="#attributes.type#">
			<cfcase value="valid"><cfsavecontent variable = "buttonTitle"><cf_get_lang dictionary_id ='58475.Onayla'></cfsavecontent><cfset spanClass = "fa-thumbs-o-up" /></cfcase>
			<cfcase value="refusal"><cfsavecontent variable = "buttonTitle"><cf_get_lang dictionary_id ='58461.Reddet'></cfsavecontent><cfset spanClass = "fa-thumbs-o-down" /></cfcase>
			<cfcase value="again"><cfsavecontent variable = "buttonTitle"><cf_get_lang dictionary_id ='57214.Tekrar Yap'></cfsavecontent><cfset spanClass = "fa-rotate-right" /></cfcase>
			<cfcase value="support"><cfsavecontent variable = "buttonTitle"><cf_get_lang dictionary_id ='57218.Başkasına Gönder'></cfsavecontent><cfset spanClass = "fa-support" /></cfcase>
			<cfcase value="cancel"><cfsavecontent variable = "buttonTitle"><cf_get_lang dictionary_id ='58506.İptal'></cfsavecontent><cfset spanClass = "fa-cut" /></cfcase>
			<cfcase value="comment"><cfsavecontent variable = "buttonTitle"><cfif attributes.view_mode eq 'flex'><cf_get_lang dictionary_id ='32970.Yorum Yap'><cfelse><cf_get_lang dictionary_id = '61116.Bildirim Yap'></cfif></cfsavecontent><cfset spanClass = "fa-comment-o" /></cfcase>
		</cfswitch>
		
		<cfif attributes.view_mode eq 'flex'>
			<div class="ui-form-list flex-list flex-center">
				<div class="form-group"><textarea name="actionNoteText" id="actionNoteText" placeholder="<cf_get_lang dictionary_id ='61092.Gerekçe veya açıklama ekleyebilirsiniz'>!" style="width:500px !important;" <cfoutput>#attributes.comment_required ? 'required' : ''#</cfoutput>></textarea></div>
				<div class="form-group"><button type="submit" class="ui-btn ui-btn-success" style="margin-left:5px;"><cfoutput><span class="popover fa #spanClass#"></span> #buttonTitle#</button></cfoutput></div>
				<div class="form-group"><button type="reset" class="ui-btn ui-btn-delete cleanRow" style="margin-left:5px;"><cfoutput><span class="popover fa fa-remove"></span> <cf_get_lang dictionary_id ='57462.Vazgeç'></button></cfoutput></div>
			</div>
		<cfelse>
			<cf_box title="#getLang('','','61116')#" collapsable="0" resize="0" closable="1">
				<div class="ui-form-list ui-form-block">
					<div class="form-group mt-2">
						<textarea name="actionNoteText" id="actionNoteText" placeholder="<cf_get_lang dictionary_id ='61092.Gerekçe veya açıklama ekleyebilirsiniz'>!" style="width:500px !important;" <cfoutput>#attributes.comment_required ? 'required' : ''#</cfoutput>></textarea>
					</div>
				</div>
				<div class="ui-form-list-btn">
					<div class="mt-2"><button type="submit" class="ui-btn ui-btn-success" style="margin-left:5px;"><cfoutput><span class="popover fa #spanClass#"></span> #buttonTitle#</button></cfoutput></div>
				</div>
			</cf_box>
		</cfif>
	</cfform>
	<script>
		$(function(){
			$("form[name=actionNote]").submit(function(){
				if( confirm( "<cf_get_lang dictionary_id='31762.Yapmakta olduğunuz bu işlem şirketinizi ve sizi bağlayacak konular içerebilir'>\n<cf_get_lang dictionary_id='31761.Devam etmek istediğinize emin misiniz'>?" ) ){
					var url = $(this).attr("action") + '&actionNoteText='+document.getElementById("actionNoteText").value + '&mandate_position=' + document.getElementById("mandate_position").value;
					AjaxPageLoad(url, 'warnings_div_');
					<cfif isDefined("attributes.reload") and attributes.reload eq 1>
						location.reload();
					</cfif>
				}
				return false;
			});
			$(".cleanRow").click(function() {
				$(this).closest("tr.actionNoteArea").prev("tr").css({"border-color":"#ddd"}).next("tr").remove();
			});
		});
	</script>
    <cfabort>
</cfif>
<cfif not isdefined("attributes.page_type")>
	<cfparam name="attributes.page_type" default="0">
</cfif>
<cfif attributes.fuseaction neq 'process.list_warnings'><cf_xml_page_edit fuseact="#fusebox.circuit#.popup_list_warning"></cfif>
<cf_get_lang_set module_name="myhome">
<cfsavecontent variable="lang_2"><cf_get_lang dictionary_id='30761.onaylarim'></cfsavecontent>
<cfsavecontent variable="lang_3"><cf_get_lang dictionary_id='30766.Uyarılarım'></cfsavecontent>
<cf_get_lang_set module_name="process">
<cfsavecontent variable="lang_4"><cf_get_lang dictionary_id='36190.Uyarı ve Onaylar'></cfsavecontent>
<cf_get_lang_set module_name="#fusebox.circuit#">
<!--- Vekalet edilen kişileri alır --->
<cfset get_mandate = createObject("component", "WMO.process_authority").init().get_mandate() />

<cfset listDivId = "warnings_div_#session.ep.userid#" />
<cfset listEmpid = session.ep.userid />
<cfset listPosid = session.ep.position_code /> 
<cfset listEmpNameSurname = "Ben" />
<cfset listBeforeFunction = "beforeFunction( #session.ep.userid#, '#session.ep.name# #session.ep.surname#', #session.ep.position_code#, 0 )" />
<cfif get_mandate.recordCount>
	<cfoutput query="get_mandate">
		<cfset listDivId = listAppend( listDivId, "warnings_div_#MASTER_EMPLOYEE_ID#" ) />
		<cfset listEmpid = listAppend( listEmpid, MASTER_EMPLOYEE_ID ) />
		<cfset listEmpNameSurname = listAppend( listEmpNameSurname, NAMESURNAME, ";" ) />
		<cfset listPosid = listAppend( listPosid, POSITION_CODE ) />
		<cfset listBeforeFunction = listAppend( listBeforeFunction, "beforeFunction( #MASTER_EMPLOYEE_ID#, '#NAMESURNAME#', #POSITION_CODE#, 1 )", "|" ) />
	</cfoutput>
	<cf_tab defaultOpen="warnings_div_" divId="#listDivId#" divLang="#listEmpNameSurname#" beforeFunction="#listBeforeFunction#">
		<div id="warnings_div_" style="height:100% !important;" class="scrollbar">
			<cfinclude template="list_warnings_content.cfm">
		</div>
	</cf_tab>
<cfelse>
	<div id="warnings_div_" style="height:100% !important;" class="scrollbar">
		<cfinclude template="list_warnings_content.cfm">
	</div>
</cfif>
<cfif attributes.fuseaction eq 'process.list_warnings'><script>function openTab(key,actionUrl,messageUserid){window.open('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.workflowpages&tab=3&' + actionUrl + '','Workflow');}</script></cfif>