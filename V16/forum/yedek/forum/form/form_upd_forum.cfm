<cfset xfa.upd="forum.upd_forum">
<cfset xfa.del="forum.del_forum">
<cfinclude template="../query/get_forum.cfm">
<cfinclude template="../query/get_company_cats.cfm">
<cfinclude template="../query/get_consumer_cats.cfm">
<cfif session.ep.admin eq 1>
	<cfset is_update_ = 1>
<cfelseif listlen(forum.admin_pos) and listfindnocase(forum.admin_pos,get_position_id(session.ep.position_code))>
	<cfset is_update_ = 1>
<cfelse>
	<cfset is_update_ = 0>
</cfif>

<cfsavecontent variable="img">
<div class="w3-forum w3-forum-form">
	<a class="wrk-circular-button-add" href="<cfoutput>#request.self#</cfoutput>?fuseaction=forum.form_add_forum"></a>
</div>
</cfsavecontent>


<cfform name="upd_forum" method="post"  action="#request.self#?fuseaction=forum.upd_forum">
<input type="Hidden" name="forumid" id="forumid" value="<cfoutput>#attributes.forumid#</cfoutput>">
<cf_form_box title="#getLang('forum',69)#" right_images="#img#">

<div class="w3-forum-form">
	<div class="row">
	<div class="col col-12 uniqueRow">
    	<div class="row ">
		
			<div class="container formContent">
        	<div class="row" type="row">
			
				<div class="col col-10 col-md-12 col-xs-12">
				
				<div class="col col-3 col-xs-12">
					<h5 class="head-col">Yayın Alanı</h5>
					<div class="yayin-alani">	

						<label class="col col-12">
							<input type="checkbox" name="all" id="all" value="1" onclick="hepsi();"><cf_get_lang_main no='540.Herkes'>
						</label>

							<div class="col col-12">
								<cf_get_lang no='16.Partner Portal'>
							</div>

							<cfoutput query="company_cats"> 
								<label class="col col-12">
									  <input type="Checkbox" name="forum_comp_cats" id="forum_comp_cats" value="#companycat_id#" <cfif listfindnocase(forum.forum_comp_cats,companycat_id) neq 0>checked</cfif>>
                                		#companycat#
								</label>
							</cfoutput>

							<div class="col col-12 text-bold">
								<cf_get_lang no='15.Public Portal'>
							</div>

							<cfoutput query="consumer_cats">
								<label  class="col col-12">
									<input type="Checkbox" name="forum_cons_cats" id="forum_cons_cats" value="#conscat_id#" <cfif listfindnocase(forum.forum_cons_cats,conscat_id) neq 0>checked</cfif>>
                                	#conscat#
								</label>		
							</cfoutput>

							<div  class="col col-12">
								<cf_get_lang no='11.Employee Portal'>
							</div>

							<label  class="col col-12">
								<input type="Checkbox" name="forum_emps" id="forum_emps" value="1" <cfif forum.forum_emps eq 1>checked</cfif>><cf_get_lang_main no='1463.Çalışanlar'>
							</label>

							<label  class="col col-12">
								 <input type="checkbox" name="is_internet" id="is_internet" value="1" <cfif forum.is_internet eq 1>checked</cfif>><cf_get_lang_main no='667.İnternet'>
							</label>
							
					</div>
				</div>
				
				<div class="col col-5 col-xs-12">
					<h5 class="head-col">Forum Bilgileri</h5>
					<div class="form-group">
						<label class="col col-4 col-xs-12"></label>
						<div class="col col-8 col-xs-12 input-group">
							<input type="Checkbox" name="status" id="status" value="1" <cfif forum.status eq 1>checked</cfif>><cf_get_lang_main no='81.Aktif'>
						</div>
					</div>

					<div class="form-group">
						<label class="col col-4 col-xs-12">
							<cf_get_lang no='65.Forum Adı'>*
						</label>
						<div class="col col-8 col-xs-12 input-group">
							<cfsavecontent variable="message"><cf_get_lang_main no='59.Eksik Veri'>:<cf_get_lang no='65.Forum Adı'></cfsavecontent>
							<cfinput type="Text" name="forumname" id="forumname" maxlength="250" size="30" value="#forum.forumname#" required="Yes" message="#message#">
						</div>
					</div>
					
					<div class="form-group">
						<label class="col col-4 col-xs-12">
							<cf_get_lang_main no='217.Açıklama'>
						</label>
						<div class="col col-8 col-xs-12 input-group">
								<textarea name="description" id="description" ><cfoutput>#forum.description#</cfoutput></textarea>
						</div>
					</div>

					
				</div>

				<div class="col col-4 col-xs-12">
					<h5 class="head-col">Yöneticiler</h5>
					<div class="form-group">
						<div class="col col-12 yoneticiler">
							  <cfsavecontent variable="msg_txt"><cf_get_lang no='30.Yöneticiler'> *</cfsavecontent>				
								<cf_workcube_to_cc 
								is_update = "1" 
								to_dsp_name = "#msg_txt#" 
								form_name = "upd_forum" 
								str_list_param = "1,7,8"
								action_dsn = "#DSN#"
								str_action_names = " ADMIN_POS AS TO_POS,ADMIN_PARS AS TO_PAR,ADMIN_CONS AS TO_CON "
								action_table = "FORUM_MAIN"
								action_id_name = "FORUMID"
								action_id = "#attributes.forumid#"
								data_type = "1"
								str_alias_names = "">
						</div>
					</div>

				</div>

				<div class="clear"></div>
				<div class="col col-12 footer">
				<cf_form_box_footer>
					 <cf_record_info query_name="forum">
							<cfif is_update_ eq 1 or forum.record_emp eq session.ep.userid>
								<cf_workcube_buttons 
								is_upd='1' 
								delete_page_url='#request.self#?fuseaction=forum.del_forum&forumid=#attributes.forumid#&head=#forum.forumname#' 
								add_function='check()'>
							</cfif>
				</cf_form_box_footer>
				</div>
				</div>
				</div>
			
			</div>
		
		</div>
	</div>
	</div>
</div>
</cf_form_box>
</cfform>
<script type="text/javascript">
	function hepsi()
	{
		if (document.getElementById('all').checked)
		{
			<cfif company_cats.recordcount>
				if (document.upd_forum.forum_comp_cats.length > 1)
					for(i=0; i<document.upd_forum.forum_comp_cats.length; i++) document.upd_forum.forum_comp_cats[i].checked = true;
				else
					document.getElementById('forum_comp_cats').checked = true;
			</cfif>
						
			<cfif consumer_cats.recordcount>
				if (document.upd_forum.forum_cons_cats.length > 1)
					for(i=0; i<document.upd_forum.forum_cons_cats.length; i++) document.upd_forum.forum_cons_cats[i].checked = true;
				else
					document.getElementById('forum_cons_cats').checked = true;
			</cfif>
			document.getElementById('forum_emps').checked = true;
		}	
		else
		{
			<cfif company_cats.recordcount>
				if (document.upd_forum.forum_comp_cats.length > 1)
					for(i=0; i<document.upd_forum.forum_comp_cats.length; i++) document.upd_forum.forum_comp_cats[i].checked = false;
				else
					document.getElementById('forum_comp_cats').checked = false;
			</cfif>
			
			<cfif consumer_cats.recordcount>
				if (document.upd_forum.forum_cons_cats.length > 1)
					for(i=0; i<document.upd_forum.forum_cons_cats.length; i++) document.upd_forum.forum_cons_cats[i].checked = false;
				else
					adocument.getElementById('forum_cons_cats').checked = false;
			</cfif>
			document.getElementById('forum_emps').checked = false;
		}
	}
	
	function check()
	{
		flag = 0;
		
		<cfif company_cats.recordcount>
			if (document.upd_forum.forum_comp_cats.length > 1)
			{
				for(i=0; i<document.upd_forum.forum_comp_cats.length; i++)
					if (document.upd_forum.forum_comp_cats[i].checked)
						flag = 1;
			}
			else
				if (document.upd_forum.forum_comp_cats[i].checked)
					flag = 1;
		</cfif>		
		
		<cfif consumer_cats.recordcount>
			if (document.upd_forum.forum_cons_cats.length > 1)
			{
				for(i=0; i<document.upd_forum.forum_cons_cats.length; i++)
					if (document.upd_forum.forum_cons_cats[i].checked)
						flag = 1;
			}
			else
				if (document.upd_forum.forum_cons_cats.checked)
					flag = 1;
		</cfif>
				
		if (document.getElementById('forum_emps').checked) flag = 1;
	
		if (flag == 0)
		{
			alert ("<cf_get_lang no='26.Forumu en az Bir Kullanıcı Grubuna Kaydedin !'>");
			return false;
		}

		if (document.getElementById('tbl_to_names_row_count').value == 0)
		{
			alert ("<cf_get_lang no='25.Foruma En Az Bir Yönetici Kaydedin !'>");
			return false;
		}
		return true;	
	}
</script>

