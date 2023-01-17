<cfset forumCFC = CreateObject("component","V16.forum.cfc.forum").init(dsn = application.systemParam.systemParam().dsn)>
<cfinclude template="../query/get_topic.cfm">
<cfif session.ep.admin eq 1>
	<cfset is_update_ = 1>
<!---<cfelseif len(forums.ADMIN_POS) and listfindnocase(forums.ADMIN_POS,get_position_id(session.ep.position_code))>
	<cfset is_update_ = 1>--->
<cfelse>
	<cfset is_update_ = 0>    
</cfif> 
<cfparam name="attributes.forumid" default="">

<link rel="stylesheet" href="/css/assets/template/w3-intranet/forum.css" type="text/css">
<link rel="stylesheet" href="/css/assets/template/w3-intranet/intranet.css" type="text/css">

<!--- <header class="intranet_header">

	<div class="row">
		<cfinclude template="../../rules/display/rule_menu.cfm">
	</div>
	<div class="row">
		<cfinclude template="../display/module_header.cfm">
	</div>	

</header> --->
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cfform enctype="multipart/form-data" action="#request.self#?fuseaction=forum.emptypopup_upd_topic" method="post" name="upd_topic">
	<input type="Hidden" name="forumid" id="forumid" value="<cfoutput>#topic.forumid#</cfoutput>">
	<input type="Hidden" name="topicid" id="topicid" value="<cfoutput>#topic.topicid#</cfoutput>">
	<input type="Hidden" name="topic_attach" id="topic_attach" value="<cfoutput>#topic.FORUM_TOPIC_FILE#</cfoutput>">
	<input type="Hidden" name="topic_attach_server_id" id="topic_attach_server_id" value="<cfoutput>#topic.FORUM_TOPIC_FILE_SERVER_ID#</cfoutput>">
	<cfsavecontent variable="head"><cf_get_lang dictionary_id='61838.?'></cfsavecontent>
		<cf_box title="#head#" popup_box="1">
			<cf_box_elements vertical="1">	
				<div class="col col-12 col-md-12 col-sm-12 col-xs-12" type="column" index="1" sort="true">
					<div class="form-group">
						<cf_get_lang_main no='217.Açıklama'>
						<cfmodule
						template="/fckeditor/fckeditor.cfm"
						toolbarSet="WRKContent"
						basePath="/fckeditor/"
						instanceName="topics"
						valign="top"
						value="#TOPIC.TOPIC#"
						width="650"
						height="325">
					</div>
				</div>
			</cf_box_elements>
			<cf_box_elements vertical="1">
				<div class="col col-12">
					<div class="form-group col col-3 col-md-3 col-sm-6 col-xs-12">
						<label><cf_get_lang no='56.Cevapları Mail Gönder'>
						<input type="Checkbox" name="email_emp" id="email_emp" value="<cfoutput>#session.ep.userid#</cfoutput>" <cfif listfindnocase(topic.email_emps,session.ep.userid) neq 0>checked</cfif>>						
						</label>
					</div>
					<div class="form-group  col col-3 col-md-3 col-sm-6 col-xs-12">
						<label><cf_get_lang no='66.Yeni Cevap Kapalı'>
						<input type="Checkbox" name="locked" id="locked" value="1" <cfif topic.locked eq 1>checked</cfif>>							
						</label>
					</div>
					<div class="form-group col col-1 col-md-1 col-sm-6 col-xs-12">
						<label><cf_get_lang_main no='81.Aktif'>
						<input type="checkbox" name="topic_status" id="topic_status" value="1" <cfif topic.topic_status eq 1>checked</cfif>>							
						</label>
					</div>
					<!---
					<div class="form-group col-xs-12">
						<label class="container"><cf_get_lang no='71.Forum Yöneticisine Mail Gönder'>
						<input type="checkbox" name="email" id="email" value="1">
						<span class="checkmark"></span>
						</label>
					</div>
					--->
					<div class="form-group col col-2 col-md-2 col-sm-6 col-xs-12">	
						<cfif len(topic.FORUM_TOPIC_FILE)>
							<label><input type="Checkbox" name="delete" id="delete" value=""><cf_get_lang no='61.Eski Belgeyi Sil'></label>
						<cfelse>
							<label><cf_get_lang no='62.Ekli Belge Yok'></label>
						</cfif>
					</div>
					<div class=" col col-3 col-md-3 col-sm-6 col-xs-12 padding-0">
						<div class="form-group">						
							<div class="fileButtonArea">
								<cfif len(topic.FORUM_TOPIC_FILE)>
									<a href="javascript://" class="ui-wrk-btn ui-wrk-btn-red mt-0 pull-right" onClick="<cfoutput>windowopen('#file_web_path#forum/#topic.FORUM_TOPIC_FILE#','large')</cfoutput>"><i class="fa fa-download" title="<cf_get_lang no='29.Belgeyi Gör'>"></i></a>			
								</cfif>
								<input class="input-file" id="attach_topic_file" name="attach_topic_file" type="file" hidden>
								<!--- <label tabindex="0" for="attach_topic_file" class="input-file-trigger">Dosya Ekle</label> --->
								<label tabindex="0" for="attach_topic_file" class="ui-wrk-btn ui-wrk-btn-extra ui-wrk-btn-addon-left  pull-right"><i class="fa fa-cloud-upload"></i>Dosya Yükle</label>
								
								<p class="file-return"></p>
							</div>						
						</div>
					</div>					
				</div>
			</cf_box_elements>	
			<cf_box_footer>
				<div class="col col-8">
					<cf_record_info query_name="topic">
				</div>
				<div class="col col-4">
					<cfif is_update_ eq 1 or topic.record_emp eq session.ep.userid> 
						<cf_workcube_buttons type_format="1" 
						is_upd='1' 
						delete_page_url='#request.self#?fuseaction=forum.emptypopup_del_topic&topicid=#attributes.topicid#' 
						add_function='kontrol()'>
					</cfif>
				</div>	  
			</cf_box_footer>
		</cf_box>
	</cfform>
</div>
<script type="text/javascript">
	function kontrol()
	{
		if(document.getElementById("title").value.trim() == '')
		{
			alert("<cf_get_lang_main no='782.Zorunlu Alan'> : <cfoutput>#getLang('main',68)#</cfoutput>");
			return false;
		}
		return true;
	}
</script>
