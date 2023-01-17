<cf_get_lang_set module_name="training">
<cfif isdefined('session.ep')>
	<cfquery name="GET_BRANCHS" datasource="#DSN#">
		SELECT 
			BRANCH_ID
		FROM 
			BRANCH
		WHERE
			BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#)
		ORDER BY 
			BRANCH_ID
	</cfquery>
<cfelse>
	<cfset get_branchs.recordcount = 0>
</cfif>
<cfif get_branchs.recordcount>
	<cfset branch_id_list = listsort(valuelist(get_branchs.branch_id,','),"Numeric","Desc")>
<cfelse>
	<cfset branch_id_list = 0>
</cfif>
<cfscript>
	get_class_action = createObject("component","V16.training.cfc.get_class");
	get_class_action.dsn = dsn;
	get_class = get_class_action.get_class_fnc
					(
						module_name : fusebox.circuit,
						class_id : attributes.class_id
					);
</cfscript>
<cfinclude template="../query/get_class_attenders.cfm">
<cfinclude template="../query/get_class_information.cfm">
<cfquery name="GET_TRAINER" datasource="#DSN#" maxrows="1">
	SELECT EMP_ID,PAR_ID,CONS_ID FROM TRAINING_CLASS_TRAINERS WHERE CLASS_ID = #attributes.class_id#
</cfquery>
<cfinclude template="../../rules/display/rule_menu.cfm">
<cfif len(get_class.start_date)>
	<cfif isdefined('session.ep')>
		<cfset start_date_ = date_add('h', session.ep.time_zone, get_class.start_date)>
	<cfelseif isdefined('session.pp')>
		<cfset start_date_ = date_add('h', session.pp.time_zone, get_class.start_date)>
	</cfif>
</cfif>
<cfif len(get_class.finish_date)>
	<cfif isdefined('session.ep')>
		<cfset finish_date_ = date_add('h', session.ep.time_zone, get_class.finish_date)>
	<cfelseif isdefined('session.pp')>
		<cfset finish_date_ = date_add('h', session.pp.time_zone, get_class.finish_date)>
	</cfif>
</cfif>
<cfif get_class_attender_emps.recordcount and isdefined('session.ep')>
	<cfquery dbtype="query" name="get_class_attender_status">
		SELECT STATUS FROM GET_CLASS_ATTENDER_EMPS WHERE EMP_ID=#session.ep.userid#
	</cfquery>
<cfelseif isdefined('session.pp') and get_class_attender_pars.recordcount>
	<cfquery dbtype="query" name="get_class_attender_status">
		SELECT STATUS FROM GET_CLASS_ATTENDER_PARS WHERE PAR_ID=#session.pp.userid#
	</cfquery>		
<cfelseif isdefined('session.ww.userid') and get_class_attender_cons.recordcount>
	<cfquery name="get_class_attender_status"  dbtype="query">
		SELECT STATUS FROM GET_CLASS_ATTENDER_CONS WHERE CON_ID=#session.ww.userid#
	</cfquery>
<cfelse>
	<cfset Kontrol.Sayim = 0>
</cfif>
<div class="training_detail">
	<div class="col col-9 col-xs-12">
		<div class="training_detail_right">
			<div class="training_detail_item">
				<div class="training_detail_top">
					<h1>Eğitimin Adı: <cfoutput>#get_class.class_name#</cfoutput></h1>
						<ul class="training_detail_top_icon">
							<cfoutput>
								<cfif get_module_user(34)>
									<li><a href="#request.self#?fuseaction=training_management.list_class&event=upd&class_id=#attributes.class_id#"><i class="wrk-uF0139" title="<cf_get_lang_main no ='52.Güncelle'>"/></i></a></li>
								</cfif>
								<cfif len(get_class.finish_date) and len(get_class.start_date) AND ((datediff('n',now(),get_class.start_date) lte 15) and (datediff('n',now(),get_class.finish_date) gte 0)) and (get_class.online eq 1)>
									<cfif (isdefined("flashComServerApplicationsPath")) and (len(flashComServerApplicationsPath))>
										<li><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.popup_online_white_board&class_id=#attributes.class_id#&trainer_emp=#get_trainer.emp_id#&trainer_par=#get_trainer.par_id#&trainer_cons=#get_trainer.cons_id#&educationName=#get_class.class_name#','white_board');"><i class="wrk-uF0181"></i></a></li>
									</cfif>
								</cfif>
								
								<cfif not isdefined('session.ep')><div style="position:absolute;display:none; right:50px; height:250px;width:250px; z-index:1px;color:red;" id="add_my_attender_<cfoutput>#get_class.class_id#</cfoutput>"></div>
									<cfif isdefined("session_base.userid")>
										<li><a href="javascript://" onClick="goster(add_my_attender_<cfoutput>#get_class.class_id#</cfoutput>); add_open_attender(<cfoutput>#get_class.class_id#</cfoutput>);"><i class="wrk-uF0093" title="<cf_get_lang no='117.Katılmak İçin Not Bırak'>"></i></a></li>
									  <cfelse>
										<li><a href="javascript://" onClick="goster(add_my_attender_<cfoutput>#get_class.class_id#</cfoutput>); add_open_attender(<cfoutput>#get_class.class_id#</cfoutput>);"><i class="wrk-uF0093" title="<cf_get_lang no='117.Katılmak İçin Not Bırak'>"></i></a></li>
									  </cfif>
								</cfif>
								
								<cfif len(get_trainer.emp_id)>
									<cfif get_workcube_app_user(get_trainer.emp_id, 0).recordcount>
										<li><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_message&employee_id=#get_trainer.emp_id#','small');"><i class="wrk-uF0089" title="<cf_get_lang no='85.Soru Sor'>"></i></a></li>
									<cfelse>
										<li><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_add_nott&public=1&employee_id=#get_trainer.emp_id#','small');"><i class="wrk-uF0089" title="<cf_get_lang no='85.Soru Sor'>"></i></a></li>
									</cfif>
								<cfelseif len(get_trainer.par_id)>
									<cfif get_workcube_app_user(get_trainer.par_id, 0).recordcount>
										<li><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_message&partner_id=#get_trainer.par_id#','small');"><i class="wrk-uF0089" title="<cf_get_lang no='85.Soru Sor'>"></i></a></li>
									<cfelse>
										<li><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_add_nott&partner=1&partner_id=#get_trainer.par_id#','small');"><i class="wrk-uF0089" title="<cf_get_lang no='85.Soru Sor'>"></i></a></li>
									</cfif>
								</cfif>
								
								<cfif not listfindnocase(denied_pages,'training.popup_form_add_training_note')>
									<li><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.popup_form_add_training_note&class_id=#attributes.class_id#','medium');"><i class="wrk-uF0045" title="<cf_get_lang_main no='53.Not Ekle'>"></i></a></li>
								</cfif>
								<li><a href="javascript://"  onClick="windowopen('#request.self#?fuseaction=training.popup_form_add_suggested&class_id=#attributes.class_id#','small');"><i class="wrk-uF0140" title="Eğitimi Öner"></i></a></li>
							</cfoutput>
						</ul>
				</div>
					
				<div class="training_detail_contents">
					<cfinclude template="training_summary.cfm">
				</div>
				<cfif isdefined("get_class_attender_status.status") and get_class_attender_status.recordcount and ((get_class_attender_status.status neq 1 or get_class_attender_status.status neq 0) or (get_class_attender_status.status eq 1 or get_class_attender_status.status eq 0))>
					<cfinclude template="training_demand_form.cfm">
				<cfelse><!---katılımcı olmayan kullanıcılar eğitimi talep edebilir--->
					<cfinclude template="training_request_form.cfm">
				</cfif>
			</div>
			<div class="training_detail_item">
				<h2><cf_get_lang no='107.Egitim İçeriği'></h2>
				<div id="training_detail_item_ajax1"></div>
			</div>
			
			<div class="training_detail_item">
				<h2><cf_get_lang_main no='639.Testler'></h2>
				<div id="training_detail_item_ajax6"></div>
			</div>
		</div>
	</div>
	<div class="col col-3 col-xs-12">
		<div class="training_detail_left">
			<cf_get_workcube_form_generator action_type='9' related_type='9' xml_is_survey_add='1' action_type_id='#url.class_id#' design='2'>
			<div class="training_detail_item">
				<h2><cf_get_lang no='91.notlarım'></h2>
				<div id="training_detail_item_ajax4"></div>
			</div>
			<div class="training_detail_item">
				<h2><cf_get_lang_main no='156.Belgeler'></h2>
				<div id="training_detail_item_ajax3"></div>
			</div>
			<div class="training_detail_item">
				<h2><cf_get_lang_main no='178.Katılımcılar'></h2>
				<div id="training_detail_item_ajax5"></div>
			</div>
			<div class="training_detail_item">
				<h2>Scorm <cf_get_lang_main no='241.İçerik'></h2>
				<div id="training_detail_item_ajax2"></div>
			</div>
			<script>
				AjaxPageLoad('<cfoutput>#request.self#?fuseaction=training.training_contents_ajax&class_id=#attributes.class_id#</cfoutput>', 'training_detail_item_ajax1');
				AjaxPageLoad('<cfoutput>#request.self#?fuseaction=training.training_scorm_contents_ajax&class_id=#attributes.class_id#</cfoutput>', 'training_detail_item_ajax2');
				AjaxPageLoad('<cfoutput>#request.self#?fuseaction=training.training_asset_ajax&class_id=#attributes.class_id#</cfoutput>', 'training_detail_item_ajax3');
				AjaxPageLoad('<cfoutput>#request.self#?fuseaction=training.training_notes_form_ajax&class_id=#attributes.class_id#</cfoutput>', 'training_detail_item_ajax4');
				AjaxPageLoad('<cfoutput>#request.self#?fuseaction=training.training_to_cc_ajax&class_id=#attributes.class_id#&branch_id_list</cfoutput>', 'training_detail_item_ajax5');
				AjaxPageLoad('<cfoutput>#request.self#?fuseaction=training.training_test_ajax&class_id=#attributes.class_id#</cfoutput>', 'training_detail_item_ajax6');
			</script>
		</div>
	</div>
</div>


<!--- <table width="98%" border="0" align="center" cellpadding="5" cellspacing="0">
	<tr>
		<td valign="top">
			<cfinclude template="training_summary.cfm">
			<!---<cfinclude template="training_contents.cfm">--->
            <cfsavecontent variable="message"><cf_get_lang no='107.Egitim İçeriği'></cfsavecontent>
            <cf_box
                id="contents_id"
                closable="0"
                box_page="#request.self#?fuseaction=training.training_contents_ajax&class_id=#attributes.class_id#"
                title="#message#"
                body_style="height:95%;">
            </cf_box>
			<!---<cfinclude template="training_scorm_contents.cfm">--->
            <cfsavecontent variable="messagee">Scorm <cf_get_lang_main no='241.İçerik'></cfsavecontent>
            <cf_box
                id="scorm_id"
                closable="0"
                box_page="#request.self#?fuseaction=training.training_scorm_contents_ajax&class_id=#attributes.class_id#"
                title="#messagee#"
                body_style="height:95%;">
            </cf_box>
			<!---<cfinclude template="training_asset.cfm">--->
            <cfsavecontent variable="message"><cf_get_lang_main no='156.Belgeler'></cfsavecontent>
            <cf_box
                id="asset_id_"
                closable="0"
                box_page="#request.self#?fuseaction=training.training_asset_ajax&class_id=#attributes.class_id#"
                title="#message#"
                body_style="height:95%;">
            </cf_box>
			<!---<cfinclude template="training_notes_form.cfm">--->
            <cfsavecontent variable="notes"><cf_get_lang no='91.notlarım'></cfsavecontent>
            <cf_box
                id="notes_id"
                closable="0"
                box_page="#request.self#?fuseaction=training.training_notes_form_ajax&class_id=#attributes.class_id#"
                title="#notes#"
                body_style="height:95%;">
            </cf_box>
			<cfif isdefined("get_class_attender_status.status") and get_class_attender_status.recordcount and ((get_class_attender_status.status neq 1 or get_class_attender_status.status neq 0) or (get_class_attender_status.status eq 1 or get_class_attender_status.status eq 0))>
				<cfinclude template="training_demand_form.cfm">
			<cfelse><!---katılımcı olmayan kullanıcılar eğitimi talep edebilir--->
				<cfinclude template="training_request_form.cfm">
			</cfif>
			</td>
			<td width="250" valign="top">
            <!---<cfinclude template="training_to_cc.cfm">--->
            <cfsavecontent variable="tocc"><cf_get_lang_main no='178.Katılımcılar'></cfsavecontent>
            <cf_box
                id="to_cc_id"
                closable="0"
                box_page="#request.self#?fuseaction=training.training_to_cc_ajax&class_id=#attributes.class_id#&branch_id_list"
                title="#tocc#"
                body_style="height:95%;">
            </cf_box>
            
			<!---<cfinclude template="training_test.cfm">--->
            <cfsavecontent variable="tests"><cf_get_lang_main no='639.Testler'></cfsavecontent>
            <cf_box
                id="test_id"
                closable="0"
                box_page="#request.self#?fuseaction=training.training_test_ajax&class_id=#attributes.class_id#"
                title="#tests#"
                body_style="height:95%;">
            </cf_box>
			
			<!---degerlendirme formları form generator dan cekilecegi icin simdilik kapatildi form generator devreye alindiktan sonra değerlendirme formlari kaldirilacak SG 20120703
			<cfinclude template="training_critics_form.cfm">
			--->
			<cf_get_workcube_form_generator action_type='9' related_type='9' action_type_id='#attributes.class_id#' design='0'><!---Değerlendirme formları --->
		</td>
	</tr>
</table>--->
<script type="text/javascript">
	function add_open_attender(id)
	{
		AjaxPageLoad('<cfoutput>#request.self#?fuseaction=objects2.popup_add_class_attender&class_id='+id+'','add_my_attender_'+id+'</cfoutput>',1);
		document.getElementById('add_my_attender_'+id+'').style.display = '';
	}
	
	function openCourse(courseID, e,control)
	{
		if(control > 0){
			alert("Bu İçeriği İzlemek için Öncelikle İlişkili Eğitimi Tamamlamalısınız!");
			return false;
		}
		else
		{
			window.open("index.cfm?fuseaction=training.popup_rte&id=" + courseID);
		}
	}
</script>
