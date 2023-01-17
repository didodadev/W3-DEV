<cfinclude template="../query/get_email_alert.cfm">
<cf_form_box title="#getLang('forum',54)#">
<cfform enctype="multipart/form-data" action="#request.self#?fuseaction=forum.emptypopup_add_reply" method="post" name="add_reply">
<cfoutput>
<cfif isdefined("attributes.replyid")>
	<cfquery name="get_hierarchy" datasource="#dsn#">
    	SELECT HIERARCHY FROM FORUM_REPLYS WHERE REPLYID = #attributes.replyid#
    </cfquery>
	<input type="hidden" name="first_hie" id="first_hie" value="#get_hierarchy.hierarchy#">
<cfelse>
	<input type="hidden" name="first_hie" id="first_hie" value="">
</cfif>    
	<input type="Hidden" name="topicid" id="topicid" value="#attributes.TOPICID#">
	<table>
		<tr>
			<td colspan="2">
				 <cfmodule
					template="/fckeditor/fckeditor.cfm"
					toolbarSet="WRKContent"
					basePath="/fckeditor/"
					instanceName="reply"
					valign="top"
					value=""
					width="600"
					height="300">
			</td>
		</tr>
		<tr>
			<td><cf_get_lang_main no='103.Dosya Ekle'>
				<input type="file" name="attach_reply_file" id="attach_reply_file" style="width:300">
			</td>
		</tr>
		<tr>
			<td><input type="checkbox" name="email_emp" id="email_emp" value="#session.ep.userid#" <cfif listfindnocase(valuelist(email_alert.email_emps),session.ep.userid)>checked</cfif>>
				<cf_get_lang no='56.Cevapları Mail Gönder'>
			</td>
			<td  style="text-align:right;"></td><!---  add_function='OnFormSubmit()' --->
		</tr>
	</table>
</cfoutput>
<cf_form_box_footer><cf_workcube_buttons type_format="1" is_upd='0'></cf_form_box_footer>
</cfform>
</cf_form_box>
