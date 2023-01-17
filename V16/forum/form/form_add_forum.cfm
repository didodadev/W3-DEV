<cfset forumCFC = CreateObject("component","V16.forum.cfc.forum").init(dsn = application.systemParam.systemParam().dsn)>
<cfinclude template="../query/get_company_cats.cfm">
<!--- Sadece aktif kategorilerin gelmesi için --->
<cfset attributes.is_active_consumer_cat = 1>
<cfinclude template="../query/get_consumer_cats.cfm">

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
	<cfsavecontent variable="head"><cf_get_lang dictionary_id='55017.Add Discussion Board'></cfsavecontent>
	<cf_box title="#head#" popup_box="1">
		<cfform name="add_forum" method="post" action="#request.self#?fuseaction=forum.emptypopup_add_forum">
			<cf_box_elements vertical="1">
				<div class="col col-12 col-md-12 col-sm-12 col-xs-12" type="column" index="1" sort="true">
					<div class="form-group">
						<label><cf_get_lang_main no='81.Aktif'>
							<input type="checkbox" name="status" id="status" value="1" checked="checked">
						</label>
					</div>				
					<div class="form-group">
						<label>
							<cf_get_lang no='65.Forum Adı'>*
						</label>
						<cfsavecontent variable="message"><cf_get_lang_main no='59.Eksik Veri'>:<cf_get_lang no='65.Forum Adı'></cfsavecontent>
						<cfinput type="Text" name="forumname" maxlength="150" value="" required="Yes" message="#message#">						
					</div>
					<div class="form-group">
						<cf_get_lang_main no='217.Açıklama'>
						<cfmodule
						template="/fckeditor/fckeditor.cfm"
						toolbarSet="WRKContent"
						basePath="/fckeditor/"
						instanceName="description"
						valign="top"
						value=""
						width="100%"
						height="100">
					</div>
				</div>
				<div class="col col-12 col-md-12 col-sm-12 col-xs-12" type="column" index="2" sort="true">
					<div class="form-group">
						<div class="col col-12">
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
			</cf_box_elements>
			<cf_box_elements>
				<div class="col col-12 col-md-12 col-sm-12 col xs-12" type="column" index="3" sort="true">					
					<div class="checkPanelTitle">
						<h4><cfoutput>#getLang('assetcare',318)#</cfoutput></h4>
					</div>
					<div class="form-group col col-3 col-md-3 col-sm-6 col-xs-12" id="item-employee_view">
							<label><cfoutput>#getLang('assetcare',287)#</cfoutput>
							<input type="checkbox" name="forum_emps" id="forum_emps" value="1">							
							</label>
					</div>
					<div class="form-group col col-3 col-md-3 col-sm-6 col-xs-12" id="item-employee_view">
							<label><cfoutput>#getLang('asset',59)#</cfoutput>
							<input type="checkbox" name="is_internet" id="is_internet" value="1">							
							</label>
					</div>
					<div class="form-group col col-3 col-md-3 col-sm-6 col-xs-12" id="item-is_extranet">
							<label><cfoutput>#getLang('assetcare',295)#</cfoutput>
							<input type="checkbox" name="is_extranet" id="is_extranet" value="1" onclick="checkedElement('item-comp_cat_all','is_extranet');">							
							</label>
					</div>
					<div class="form-group col col-3 col-md-3 col-sm-6 col-xs-12" id="item-is_portal">
							<label><cfoutput>#getLang('forum',27)#</cfoutput>
							<input type="checkbox" name="is_portal" id="is_portal" value="1" onclick="checkedElement('portal-panel','is_portal');">							
							</label>
					</div>
				</div>
			</cf_box_elements>
			<!--- <cf_seperator id="broadcast_area" header="#getLang('forum',32)#" is_closed="0">Yayın Alanı --->
			<div class="archive_form forum-detail">
				<div class="archive_form_step">
					<div class="row">
						<div class="col col-12">					
							<div class="sub_title" id="user_power">
								<span class="btnPointer"><cf_get_lang dictionary_id='54998.Click for forum access permission'><i class='fa fa-angle-down bold'></i></span>
							</div>
						</div>
					</div>
			
					<div class="row" type="row" id="broadcast_area" style="display:none">
						<div class="col col-6 col-md-6 col-sm-12 col-xs-12" type="column" index="3" sort="true">
							<div class="form-group" id="item-comp_cat_all">
								<label style="display:none"><cf_get_lang dictionary_id='30426.Partner Portal'></label>
									<div class="archive_form_list_title">
										<i class="fa fa-angle-down"></i>
										<cf_get_lang dictionary_id='30426.Partner Portal'>
									</div>
									<div class="archive_form_list_item">
										<div id="item-comp_cat_all">
											<div class="ui-form-list ui-form-block">
												<cfoutput query="company_cats"> 
													<div class="form-group col col-12">												
														<input type="checkbox" name="forum_comp_cats" id="forum_comp_cats" value="#companycat_id#">												
														<label>#companycat#</label>
													</div>
												</cfoutput>
											</div>
										</div>								
									</div>
									<!--- Eski hali Partner Portal--->
								<!--- <div class="checkbox-content">
									<div class="checkbox-header"><label style="display:none"><cfoutput>#getLang("forum",16)#</cfoutput></label>
										<cfoutput>#getLang("forum",16)#</cfoutput>
									</div>
									<div class="scrollbar" style="position:relative; height:200px; z-index:88; overflow:auto;">
										<cfoutput query="company_cats"> 
											<div class="col col-12">
												<label class="container">#companycat#
												<input type="checkbox" name="forum_comp_cats" id="forum_comp_cats" value="#companycat_id#">
												<span class="checkmark"></span>
												</label>
											</div>
										</cfoutput>
									</div>
								</div> --->
							</div>
						</div>
						<div class="col col-6 col-md-6 col-sm-12 col-xs-12" type="column" index="4" sort="true">
							<div class="form-group" id="portal-panel">
								<label style="display:none"><cf_get_lang dictionary_id='30283.Public Portal'></label>
									<div class="archive_form_list_title">
										<i class="fa fa-angle-down"></i>
										<cf_get_lang dictionary_id='30283.Public Portal'>
									</div>
									<div class="archive_form_list_item">
										<div id="item-comp_cat_all">
											<div class="ui-form-list ui-form-block">
												<cfoutput query="consumer_cats">
													<div class="form-group col col-12">											
														<input type="checkbox" name="forum_cons_cats" id="forum_cons_cats" value="#conscat_id#">											
														<label>#conscat#</label>
													</div>
												</cfoutput>
											</div>
										</div>	
									</div>
								<!--- Eski Hali Public Portal --->	
								<!--- <div class="checkbox-content">
									<div class="checkbox-header"><label style="display:none"><cfoutput>#getLang("forum",15)#</cfoutput></label>
										<cfoutput>#getLang("forum",15)#</cfoutput>
									</div>
									<div class="scrollbar" style="position:relative; height:200px; z-index:88; overflow:auto;">
										<cfoutput query="consumer_cats">
											<div class="col col-12">
												<label class="container">#conscat#
												<input type="checkbox" name="forum_cons_cats" id="forum_cons_cats" value="#conscat_id#">
												<span class="checkmark"></span>
												</label>
											</div>
										</cfoutput>
									</div>
								</div> --->
							</div>
						</div>
					</div>
				</div>
			</div>						
	
			<cf_box_footer>
				<cf_workcube_buttons is_='0' type_format="1" add_function='check()'>
			</cf_box_footer>

		</cfform>
	</cf_box>
</div>
<script type="text/javascript">
	
	var is_portal = "is_portal";
	var is_extranet = "is_extranet";
	var domaincheckedCounter = 0;
	var partnercheckedCounter = 0;
	var domainsCount = checkboxCount("#internet-panel input[type = checkbox]");
	var partnersCount = checkboxCount("#item-comp_cat_all input[type = checkbox]");

	function checkboxCount(element){

		var counter = 0;

		$(element).each(function(){
			
			counter++;

		});

		return counter;

	}
	
	function checkedElement(panelid,checkedName){
		$("#"+panelid + " input[type = checkbox]").each(function(){
			
			if($("input[name = "+checkedName+"]").is(":checked")){

				this.checked = true;
				if(checkedName == is_portal) domaincheckedCounter++;
				else if(checkedName == is_extranet) partnercheckedCounter++;
				
			}else {

				this.checked = false;
				if(checkedName == is_portal) domaincheckedCounter--;
				else if(checkedName == is_extranet) partnercheckedCounter--;

			}

		});
	}
	
	$("#internet-panel input[type = checkbox]").click(function(){
		
		var id = $(this).attr("id");

		if($(this).is(":checked")){

			this.checked = true;
			domaincheckedCounter++;
			
		}else {

			this.checked = false;
			domaincheckedCounter--;

		}

		if(domaincheckedCounter == 0) $("input[name = is_portal]").prop("checked",false);
		else if(domaincheckedCounter > 0) $("input[name = is_portal]").prop("checked",true);
	
	});


	$("#item-comp_cat_all input[type = checkbox]").click(function(){
		
		if($(this).is(":checked")){

			this.checked = true;
			partnercheckedCounter++;
			
		}else {

			this.checked = false;
			partnercheckedCounter--;

		}

		if(partnercheckedCounter == 0) $("input[name = is_extranet]").prop("checked",false);
		else if(partnercheckedCounter > 0) $("input[name = is_extranet]").prop("checked",true);
	
	});
	
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

	$("#user_power").click(function(){
		$("#broadcast_area").stop().slideToggle();   
		$(this).toggleClass("flex-row-open");      
	});	
</script>

