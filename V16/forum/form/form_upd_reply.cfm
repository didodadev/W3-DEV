<cfset forumCFC = CreateObject("component","V16.forum.cfc.forum").init(dsn = application.systemParam.systemParam().dsn)>

<cfinclude template="../query/get_reply.cfm">
<cfparam name="attributes.topicid" default="#reply.topicid#">
<cfinclude template="../query/get_email_alert.cfm">
<cfquery name="GET_SPECIAL_DEFINITION" datasource="#DSN#">
	SELECT SPECIAL_DEFINITION_ID,SPECIAL_DEFINITION FROM SETUP_SPECIAL_DEFINITION WHERE SPECIAL_DEFINITION_TYPE = 8
</cfquery>
<cfquery name="GET_WORK" datasource="#DSN#">
	SELECT WORK_ID, WORK_HEAD FROM PRO_WORKS WHERE FORUM_REPLY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#reply.replyid#">
</cfquery>
<cfsavecontent variable="img"><a href="<cfoutput>#request.self#?fuseaction=forum.form_add_reply&topicid=#attributes.topicid#</cfoutput>"><img src="/images/plus1.gif" border="0" align="absmiddle" title="<cf_get_lang_main no='170.Ekle'>"></cfsavecontent>

<link rel="stylesheet" href="/css/assets/template/w3-intranet/forum.css" type="text/css">
<link rel="stylesheet" href="/css/assets/template/w3-intranet/intranet.css" type="text/css">
<!--- 
<header class="intranet_header">

	<div class="row">
		<cfinclude template="../../rules/display/rule_menu.cfm">
	</div>
	<div class="row">
		<cfinclude template="../display/module_header.cfm">
	</div>	

</header> --->
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cfform enctype="multipart/form-data" method="post" name="upd_reply" action="#request.self#?fuseaction=forum.emptypopup_upd_reply">
		<input type="Hidden" name="replyid" id="replyid" value="<cfoutput>#replyid#</cfoutput>">
		<input type="Hidden" name="topicid" id="topicid" value="<cfoutput>#attributes.topicid#</cfoutput>">
		<input type="Hidden" name="forumid" id="forumid" value="<cfoutput>#attributes.forumid#</cfoutput>">
		<input type="Hidden" name="reply_attach" id="reply_attach" value="<cfoutput>#reply.forum_reply_file#</cfoutput>">
		<input type="Hidden" name="reply_attach_server_id" id="reply_attach_server_id" value="<cfoutput>#reply.forum_reply_file_server_id#</cfoutput>">
		<cfsavecontent variable="head"><cf_get_lang dictionary_id='53634.Update Reply'></cfsavecontent>
		<cf_box title="#head#" popup_box="1">
		
			
			<!---
			<div class="row" type="row">
				<div class="col col-6" type="column" index="1" sort="true">
					<div class="form-group">
						<label class="col col-12 col-xs-12">
							<cf_get_lang no='5.Özel Tanım'>
						</label>
					</div>
					<div class="form-group">
						<select name="special_definition" id="special_definition" style="width:142px">
							<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
							<cfoutput query="get_special_definition">
								<option value="#special_definition_id#" <cfif reply.special_definition_id eq special_definition_id>selected</cfif>>#special_definition#</option>
							</cfoutput>
						</select>
					</div>
				</div>
				<div class="col col-6" type="column" index="1" sort="true">
					<div class="form-group">
						<label class="col col-12 col-xs-12">
							<cf_get_lang no='21.İlişkili İş'>
						</label>
					</div>
					<div class="form-group">
						<div class="input-group">
							<input type="hidden" name="work_id" id="work_id" value="<cfif get_work.recordcount><cfoutput>#get_work.work_id#</cfoutput></cfif>">
							<input type="text" name="work_head" id="work_head" style="width:125px;" value="<cfif get_work.recordcount><cfoutput>#get_work.work_head#</cfoutput></cfif>">
							<span class="input-group-addon btn_Pointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_add_work&field_id=upd_reply.work_id&field_name=upd_reply.work_head','list');"></span>
						</div>
					</div>
				</div>
			</div>
			--->
			<cf_box_elements vertical="1">
				<div class="col col-12" type="column" index="3" sort="true">
					<cfmodule
						template="/fckeditor/fckeditor.cfm"
						toolbarset="WRKContent"
						basepath="/fckeditor/"
						instancename="replys"
						valign="top"
						value="#reply.reply#"
						width="100%"
						height="150">
				</div>
			</cf_box_elements>
			<!--- <div class="row form-inline">
				<div class="col col-12 col-md-12 col-sm-12 col xs-12 checkPanel" style="padding:20px 0 20px;">
					<div class="form-inline">
						<!---
						<div class="form-group col-xs-6">
							<label class="container"><cf_get_lang no='56.Cevapları Mail Gönder'>
							<input type="Checkbox" name="email_emp" id="email_emp" value="<cfoutput>#session.ep.userid#</cfoutput>" <cfif listfindnocase(valuelist(email_alert.email_emps),session.ep.userid)>checked</cfif>>
							<span class="checkmark"></span>
							</label>
						</div>
						<div class="form-group col-xs-6">
							<label class="container"><cf_get_lang_main no='81.Aktif'>
							<input type="Checkbox" name="is_active" id="is_active" <cfif reply.is_active eq 1>checked</cfif> value="1">
							<span class="checkmark"></span>
							</label>
						</div>
						<div class="form-group col-xs-6">
							<div class="fileButtonArea">
								<div class="input-file-container txt-r">  
									<input class="input-file" id="attach_reply_file" name="attach_reply_file" type="file">
									<label tabindex="0" for="attach_reply_file" class="input-file-trigger">Dosya Ekle</label>
								</div>
							</div>
							<cf_get_lang_main no='56.Belge'> 
							<cfif len(reply.forum_reply_file)>
								<cfoutput><a href="javascript://" onclick="windowopen('#file_web_path#forum/#reply.forum_reply_file#','large')"><img src="/images/asset.gif" border="0" title="<cf_get_lang no='29.Belgeyi Gör'>" align="absmiddle"></cfoutput></a>
								<input type="checkbox" name="delete" id="delete" value="">
								<cf_get_lang no='61.Eski Belgeyi Sil'>
							<cfelse>
								<cf_get_lang no='62.Ekli Belge Yok'>
							</cfif>
						</div>
						--->
					</div>
				</div>
			</div> --->
			<cf_box_footer>
				<div class="col col-6 col-xs-12">
					<cf_record_info query_name="reply">
				</div>
				<div class="col col-6 col-xs-12">
					<cfif reply.record_emp eq session.ep.userid> 
						<cf_workcube_buttons 
						is_upd='1'  
						delete_page_url='#request.self#?fuseaction=forum.emptypopup_del_reply&replyid=#reply.replyid#&topicid=#reply.topicid#'>
					</cfif>
				</div>	  
			</cf_box_footer>		
		</cf_box>
	</cfform>
</div>