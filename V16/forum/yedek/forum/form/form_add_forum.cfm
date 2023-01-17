<cfinclude template="../query/get_company_cats.cfm">
<!--- Sadece aktif kategorilerin gelmesi için --->
<cfset attributes.is_active_consumer_cat = 1>
<cfinclude template="../query/get_consumer_cats.cfm">
<cfform name="add_forum" method="post" action="#request.self#?fuseaction=forum.emptypopup_add_forum">
<cf_form_box title="#getLang('forum',51)#" >
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
									<input type="Checkbox" name="forum_comp_cats" id="forum_comp_cats" value="#companycat_id#">#companycat#
								</label>
							</cfoutput>

							<div class="col col-12 text-bold">
								<cf_get_lang no='15.Public Portal'>
							</div>

							<cfoutput query="consumer_cats">
								<label  class="col col-12">
									<input type="checkbox" name="forum_cons_cats" id="forum_cons_cats" value="#conscat_id#">#conscat#
								</label>		
							</cfoutput>

							<div  class="col col-12">
								<cf_get_lang no='11.Employee Portal'>
							</div>

							<label  class="col col-12">
								<input type="checkbox" name="forum_emps" id="forum_emps" value="1"><cf_get_lang_main no='1463.Çalışanlar'>
							</label>

							<label  class="col col-12">
								<input type="checkbox" name="is_internet" id="is_internet" value="1"><cf_get_lang_main no='667.İnternet'>
							</label>
							
					</div>
				</div>
				
				<div class="col col-5 col-xs-12">
					<h5 class="head-col">Forum Bilgileri</h5>
					<div class="form-group">
						<label class="col col-4 col-xs-12"></label>
						<div class="col col-8 col-xs-12 input-group">
							<input type="checkbox" name="status" id="status" value="1" checked><cf_get_lang_main no='81.Aktif'>
						</div>
					</div>

					<div class="form-group">
						<label class="col col-4 col-xs-12">
							<cf_get_lang no='65.Forum Adı'>*
						</label>
						<div class="col col-8 col-xs-12 input-group">
							<cfsavecontent variable="message"><cf_get_lang_main no='59.Eksik Veri'>:<cf_get_lang no='65.Forum Adı'></cfsavecontent>
							<cfinput type="Text" name="forumname" maxlength="150" size="30" value="" style="width:250px;" required="Yes" message="#message#">
						</div>
					</div>
					
					<div class="form-group">
						<label class="col col-4 col-xs-12">
							<cf_get_lang_main no='217.Açıklama'>
						</label>
						<div class="col col-8 col-xs-12 input-group">
								<textarea name="description" id="description"  class="col col-12"></textarea>
						</div>
					</div>

					
				</div>

				<div class="col col-4 col-xs-12">
					<h5 class="head-col">Yöneticiler</h5>
					<div class="form-group">
						<div class="col col-12 yoneticiler">
							<cfsavecontent variable="txt_1"><cf_get_lang no='30.Yöneticiler'>*</cfsavecontent>
							<cf_workcube_to_cc
								is_update="0"
								to_dsp_name="#txt_1#"
								form_name="add_forum"
								str_list_param="1,7,8"
								data_type="1">
						</div>
					</div>

				</div>

				<div class="clear"></div>
				<div class="col col-12 footer">
				<cf_form_box_footer>
					<cf_workcube_buttons is_upd='0' type_format="1" add_function='check()'>
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
				if (document.add_forum.forum_comp_cats.length > 1)
					for(i=0; i<document.add_forum.forum_comp_cats.length; i++) document.add_forum.forum_comp_cats[i].checked = true;
				else
					document.getElementById('forum_comp_cats').checked = true;
			</cfif>
						
			<cfif consumer_cats.recordcount>
				if (document.add_forum.forum_cons_cats.length > 1)
					for(i=0; i<document.add_forum.forum_cons_cats.length; i++) document.add_forum.forum_cons_cats[i].checked = true;
				else
					document.getElementById('forum_cons_cats').checked = true;
			</cfif>
			document.getElementById('forum_emps').checked = true;
		}	
		else
		{
			<cfif company_cats.recordcount>
				if (document.add_forum.forum_comp_cats.length > 1)
					for(i=0; i<document.add_forum.forum_comp_cats.length; i++) document.add_forum.forum_comp_cats[i].checked = false;
				else
					document.getElementById('forum_comp_cats').checked = false;
			</cfif>
			
			<cfif consumer_cats.recordcount>
				if (document.add_forum.forum_cons_cats.length > 1)
					for(i=0; i<document.add_forum.forum_cons_cats.length; i++) document.add_forum.forum_cons_cats[i].checked = false;
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
			if (document.add_forum.forum_comp_cats.length > 1)
			{
				for(i=0; i<document.add_forum.forum_comp_cats.length; i++)
					if (document.add_forum.forum_comp_cats[i].checked)
						flag = 1;
			}
			else
				if (document.add_forum.forum_comp_cats[i].checked)
					flag = 1;
		</cfif>
	
		
		<cfif consumer_cats.recordcount>
			if (document.add_forum.forum_cons_cats.length > 1)
			{
				for(i=0; i<document.add_forum.forum_cons_cats.length; i++)
					if (document.add_forum.forum_cons_cats[i].checked)
						flag = 1;
			}
			else
				if (document.add_forum.forum_cons_cats.checked)
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

