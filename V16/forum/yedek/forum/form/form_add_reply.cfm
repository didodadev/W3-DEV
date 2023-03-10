<cfinclude template="../query/get_email_alert.cfm">
<cfquery name="GET_SPECIAL_DEFINITION" datasource="#DSN#">
	SELECT SPECIAL_DEFINITION_ID,SPECIAL_DEFINITION FROM SETUP_SPECIAL_DEFINITION WHERE SPECIAL_DEFINITION_TYPE = 8
</cfquery>
<cfif isDefined('attributes.work_id') and len(attributes.work_id)>
	<cfquery name="GET_WORK" datasource="#DSN#">
		SELECT WORK_HEAD FROM PRO_WORKS WHERE WORK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.work_id#">
	</cfquery>
</cfif>
<cfquery name="GET_FORUM_TOPIC_TITLE" datasource="#DSN#">
	SELECT 
        FT.TITLE,
        FM.FORUMNAME
    FROM 
        FORUM_TOPIC FT,
        FORUM_MAIN FM
    WHERE
        FT.FORUMID = FM.FORUMID AND
        FT.TOPICID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.topicid#">
</cfquery>
<cf_form_box title="#getLang('forum',54)# ( #get_forum_topic_title.forumname# - #get_forum_topic_title.title# )">
<cfform enctype="multipart/form-data" action="#request.self#?fuseaction=forum.emptypopup_add_reply" method="post" name="add_reply">
<cfoutput>
<cfif isdefined("attributes.replyid")>
	<cfquery name="GET_HIERARCHY" datasource="#DSN#">
    	SELECT HIERARCHY FROM FORUM_REPLYS WHERE REPLYID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.replyid#">
    </cfquery>
	<input type="hidden" name="first_hie" id="first_hie" value="#get_hierarchy.hierarchy#">
<cfelse>
	<input type="hidden" name="first_hie" id="first_hie" value="">
</cfif>    
	<input type="Hidden" name="topicid" id="topicid" value="#attributes.topicid#">

	   <div class="w3-forum-form">
        <div class="row">   
            <div class="container formContent">
                <div class="row">
                    <div class="col col-5 col-md-8 col-xs-12">

						<div class="form-group">	
							<div class="col col-12 col-xs-12">
								 <cfmodule
									template="/fckeditor/fckeditor.cfm"
									toolbarset="WRKContent"
									basepath="/fckeditor/"
									instancename="reply"
									valign="top"
									value=""
									width="600"
									height="300">
							</div>
						</div>

						<div class="form-group">
							<label class="col col-12 ">
								<input type="checkbox" name="email_emp" id="email_emp" value="#session.ep.userid#" <cfif listfindnocase(valuelist(email_alert.email_emps),session.ep.userid)>checked</cfif>>
								<cf_get_lang no='56.Cevaplar?? Mail G??nder'>
							</label>
							
						</div>

						<div class="form-group">
							<label class="col col-3 col-xs-12">
								<cf_get_lang_main no='103.Dosya Ekle'>
							</label>
							<div class="col col-9 col-xs-12 ">
								<div class="input-group">
									<input type="file" name="attach_reply_file" id="attach_reply_file">
								</div>
								
							</div>
						</div>

						<div class="form-group">
							<label class="col col-3 col-xs-12">
								<cf_get_lang no='5.??zel Tan??m'>
							</label>
							<div class="col col-9 col-xs-12">
							<div class="input-group">
								 <select name="special_definition" id="special_definition" >
									<option value=""><cf_get_lang_main no='322.Se??iniz'></option>
									<cfloop query="get_special_definition">
										<option value="#special_definition_id#">#special_definition#</option>
									</cfloop>
								</select>
								</div>      
							</div>
						</div>

						<div class="form-group">
							<label class="col col-3 col-xs-12">
								<cf_get_lang no='21.??li??kili ????'>
							</label>
							<div class="col col-9 col-xs-12">
								<div class="input-group">
									<input type="hidden" name="work_id" id="work_id" value="<cfif isDefined('attributes.work_id') and len(attributes.work_id)><cfoutput>#attributes.work_id#</cfoutput></cfif>">
									<input type="text" name="work_head" id="work_head" style="width:125px;" value="<cfif isDefined('attributes.work_head') and len(attributes.work_head)><cfoutput>#get_work.work_head#</cfoutput></cfif>">
									<span class="input-group-addon icom-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_add_work&field_id=add_reply.work_id&field_name=add_reply.work_head','list');"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></span>
								</div>
								
							</div>
						</div>

						<div class="col col-12">
							<cf_form_box_footer><cf_workcube_buttons type_format="1" is_upd='0'></cf_form_box_footer>
						</div>

					</div>
				</div>
			</div>
		</div>
	</div>	

	
</cfoutput>

</cfform>
</cf_form_box>
