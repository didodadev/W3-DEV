<cfparam name="attributes.start_dates" default="">
<cfparam name="attributes.finish_dates" default="">
<cfif len(attributes.start_dates) and isdate(attributes.start_dates)>
	<cf_date tarih = "attributes.start_dates">
</cfif>
<cfif len(attributes.finish_dates) and isdate(attributes.finish_dates)>
	<cf_date tarih = "attributes.finish_dates">
</cfif>
<cfinclude template="../query/get_analysis.cfm">
<cfinclude template="../query/get_analysis_questions.cfm">
<cfinclude template="../query/get_analysis_results.cfm">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.employee_id" default="">
<cfparam name="attributes.employee" default="">
<cfparam name="attributes.member_id" default="">
<cfparam name="attributes.member_type" default="">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default="#get_analysis_results.recordcount#">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfsavecontent variable="message"><cf_get_lang dictionary_id="29779.Analiz Sonucu"></cfsavecontent>
<cfsavecontent variable="message1"><cf_get_lang dictionary_id="30285.Toplam Soru"></cfsavecontent>
<cf_CatalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box title="#getLang('','Analiz Sonucu',29779)#: #get_analysis.analysis_head# - #getLang('','Toplam Soru',30285)# : #get_analysis_questions.recordCount#" uidrop="1" hide_table_column="1" collapsable="0" resize="0"> 
		<cfform name="list_analysis" method="post" action="#request.self#?fuseaction=member.list_analysis&event=det&analysis_id=#analysis_id#">
			<input type="hidden" name="is_form_submitted" id="is_form_submitted" value="1">
			<cf_box_search>
				<div class="form-group">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id="57460.Filtre"></cfsavecontent>
					<cfinput type="text" name="keyword" maxlength="50" value="#attributes.keyword#" placeholder="#message#">
				</div>
				<div class="form-group">
					<div class="input-group">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id ='57738.Başlama Tarihi Girmelisiniz'>!</cfsavecontent>
						<cfinput name="start_dates" validate="#validate_style#" maxlength="10" value="#dateformat(attributes.start_dates,dateformat_style)#" message="#message#">							
						<span class="input-group-addon"><cf_wrk_date_image date_field="start_dates"></span>
					</div>
				</div>
				<div class="form-group">
					<div class="input-group">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id ='57739.Bitiş Tarihi Girmelisiniz'> !</cfsavecontent>
						<cfinput name="finish_dates" validate="#validate_style#" maxlength="10" value="#dateformat(attributes.finish_dates,dateformat_style)#" message="#message#">														
						<span class="input-group-addon"><cf_wrk_date_image date_field="finish_dates"></span>
					</div>
				</div>
				<div class="form-group small">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4">
				</div>
				<!--- <div class="form-group">
					<a class="ui-btn ui-btn-gray" href="javascript://" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=member.list_analysis&event=add-result&analysis_id=#attributes.analysis_id#');"><i class="fa fa-plus"></i></a>
				</div> --->

			</cf_box_search>
			<cf_box_search_detail>
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
					<div class="form-group" id="item-employee_id">
						<div class="input-group">
							<input type="hidden" name="employee_id" id="employee_id" value="<cfif len(attributes.employee_id) and len(attributes.employee)><cfoutput>#attributes.employee_id#</cfoutput></cfif>">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id="57899.Kaydeden"></cfsavecontent>
							<input name="employee" id="employee" type="text" placeholder="<cfoutput>#message#</cfoutput>" style="width:100px;" onfocus="AutoComplete_Create('employee','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','employee_id','','3','135');" value="<cfif len(attributes.employee_id) and len(attributes.employee)><cfoutput>#attributes.employee#</cfoutput></cfif>" maxlength="255" autocomplete="off" >
							<span class="input-group-addon icon-ellipsis btnPointer" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=employee_id&field_name=employee&select_list=1','list','popup_list_positions');"></span>
						</div>
					</div>
					<div class="form-group" id="item-member_id">
						<div class="input-group">
							<input type="hidden" name="member_id" id="member_id" value="<cfif len(attributes.member_id) and len(attributes.member_name)><cfoutput>#attributes.member_id#</cfoutput></cfif>">
							<input type="hidden" name="member_type" id="member_type" value="<cfif len(attributes.member_id) and len(attributes.member_name)><cfoutput>#attributes.member_type#</cfoutput></cfif>">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id ='57658.Üye'></cfsavecontent>
							<cfsavecontent variable="placehold"><cf_get_lang dictionary_id="29780.Katılımcı"></cfsavecontent>
							<input type="text" name="member_name" id="member_name" placeholder="<cfoutput>#placehold#</cfoutput>" value="<cfif isdefined("attributes.member_name") and len(attributes.member_name) and attributes.member_type is 'consumer'><cfoutput>#get_cons_info(attributes.member_id,0,0)#</cfoutput><cfelseif isdefined("attributes.member_name") and len(attributes.member_name) and attributes.member_type is 'partner'><cfoutput>#get_par_info(attributes.member_id,0,-1,0)#</cfoutput></cfif>" message="<cfoutput>#message#</cfoutput>" passthrough="readonly" style="width:100px;">
							<span class="input-group-addon icon-ellipsis btnPointer" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&select_list=7,8&field_id=member_id&field_name=member_name&field_type=member_type','list','popup_list_pars');"></span>
						</div>
					</div>
				</div>	
			</cf_box_search_detail>
		</cfform>
		<cf_grid_list>
			<thead>
				<th width="30"><cf_get_lang dictionary_id='58577.Sıra'></th>
				<th><cf_get_lang dictionary_id='29780.Katılımcı'></th>		
				<th><cf_get_lang dictionary_id='57612.Fırsat'></th>
				<th><cf_get_lang dictionary_id='57545.Teklif'></th>
				<th><cf_get_lang dictionary_id='57416.Proje'></th>
				<th><cf_get_lang dictionary_id='58984.Puan'></th>
				<th><cf_get_lang dictionary_id='29779.Analiz Sonucu'></th>
				<th><cf_get_lang dictionary_id='58472.Dönem'></th>
				<th><cf_get_lang dictionary_id="59871.Katılım Tarihi"></th>
				<th><cf_get_lang dictionary_id='57899.Kaydeden'></th>
				<th class="header_icn_none" width="20"><a href="javascript://"><i class="fa fa-print"></i></a></th>				
				<th width="20" class="header_icn_none text-center">
					<cfif not listfindnocase(denied_pages,'member.popup_analysis_results_only_member')><cfoutput><a href="javascript://" onclick="openBoxDraggable('#request.self#?fuseaction=member.list_analysis&event=add-result&analysis_id=#attributes.analysis_id#');"><i class="fa fa-plus" title="<cf_get_lang dictionary_id ='57582.Ekle'>" alt="<cf_get_lang dictionary_id ='57582.Ekle'>"></i></a></cfoutput></cfif>
				</th>
			</thead>
			<tbody>
				<cfif get_analysis_results.recordcount>
				<cfoutput query="get_analysis_results" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
					<tr height="20" onmouseover="this.className='color-light';" onmouseout="this.className='color-row';" class="color-row">
						<td>#currentrow#</td>
						<td>
							<!--- Kurumsal ise --->
							<cfif type eq 1>
								<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_par_det&par_id=#partner_id#','medium','popup_par_det');" class="tableyazi">#member_partner_name#</a>
								(<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_com_det&company_id=#company_id#','medium','popup_com_det');" class="tableyazi">#member_name#</a>)
							<!--- bireysel ise --->
							<cfelseif len(consumer_id)>
								<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id=#consumer_id#','medium','popup_con_det');" class="tableyazi">#member_name#</a>
							<cfelse>
								#MEMBER_PARTNER_NAME#(#MEMBER_NAME#)
							</cfif>
						</td>
						<td align="center"><cfif len(opportunity_id)>X</cfif></td>
						<td align="center"><cfif len(offer_id)>X</cfif></td>
						<td align="center"><cfif len(project_id)>X</cfif></td>
						<td  style="text-align:right;">#user_point# / #get_analysis.total_points#</td>
						<td align="left">
							<cfif USER_POINT lt get_analysis.score5 or USER_POINT eq get_analysis.score5>
								#get_analysis.comment5#
							<cfelseif USER_POINT gt get_analysis.score5 and (USER_POINT lt get_analysis.score4 or USER_POINT eq get_analysis.score4)>
								#get_analysis.COMMENT4#
							<cfelseif USER_POINT gt get_analysis.score4 and (USER_POINT lt get_analysis.score3 or USER_POINT eq get_analysis.score3)>
								#get_analysis.COMMENT3#
							<cfelseif USER_POINT gt get_analysis.score3 and (USER_POINT lt get_analysis.score2 or USER_POINT eq get_analysis.score2)>
								#get_analysis.COMMENT2#
							<cfelseif USER_POINT gt get_analysis.score2 and (USER_POINT lt get_analysis.score1 or USER_POINT eq get_analysis.score1)>
								#get_analysis.COMMENT1#
							</cfif>
						</td>
						<td>#term#</td>
						<td><cfif len(attendance_date)>#dateformat(attendance_date,dateformat_style)#<cfelse>#dateformat(record_date,dateformat_style)#</cfif></td>
						<td align="center">#get_emp_info(record_emp,0,1)#</td>
						<cfif not listfindnocase(denied_pages,'member.popup_upd_member_analysis_result')>
							<cfif type eq 1>
								<cfset temp_member_type = 'member_type=partner&company_id=#company_id#&partner_id=#partner_id#'>
							<cfelse>
								<cfset temp_member_type = 'member_type=consumer&consumer_id=#consumer_id#'>
							</cfif>
							<td><a href="javascript://" onclick="window.open('#request.self#?fuseaction=objects.popup_print_files&action_id=#analysis_id#&action=#attributes.fuseaction#&action_row_id=#result_id#&#temp_member_type#','WOC');"><i class="fa fa-print"></i></a></td>
							<td>							
								<cfif len(opportunity_id)>
									<cfset temp_action_type='OPPORTUNITY'>
								<cfelseif len(offer_id)>
									<cfset temp_action_type='OFFER'>
								<cfelseif len(project_id)>
									<cfset temp_action_type='PROJECT'>
								<cfelse>
									<cfset temp_action_type='MEMBER'>
								</cfif>
								<a href="javascript://" onclick="openBoxDraggable('#request.self#?fuseaction=member.list_analysis&event=upd-result&action_type=#temp_action_type#&analysis_id=#analysis_id#&result_id=#result_id#&#temp_member_type#');"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a><!--- /images/quiz.gif --->
							</td>
						</cfif>
					</tr>
				</cfoutput>
			<cfelse>
				<tr>
					<td colspan="11"><cfif isdefined("attributes.is_form_submitted")><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'> !<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz '>!</cfif></td>
				</tr>
			</cfif>
			</tbody>
		</cf_grid_list> 
		<cfset url_str = "">
		<cfif attributes.totalrecords gt attributes.maxrows>
			<cfset url_str="member.list_analysis&event=det&analysis_id=#attributes.analysis_id#">
			<cfif isdefined("attributes.member_type") and len(attributes.member_type)>
				<cfset url_str = "#url_str#&member_type=#attributes.member_type#">
			</cfif>	
			<cfif len(attributes.keyword)>
				<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
			</cfif>
			<cfif len(attributes.employee)>
				<cfset url_str = "#url_str#&employee=#attributes.employee#">
			</cfif>
			<cfif len(attributes.employee_id)>
				<cfset url_str = "#url_str#&employee_id=#attributes.employee_id#">
			</cfif>
			<cfif len(attributes.start_dates)>
				<cfset url_str="#url_str#&start_dates=#dateformat(attributes.start_dates,dateformat_style)#">
			</cfif>
			<cfif len(attributes.finish_dates)>
				<cfset url_str="#url_str#&finish_dates=#dateformat(attributes.finish_dates,dateformat_style)#">
			</cfif>
			<cfif isdefined("attributes.member_id") and len(attributes.member_id)>
				<cfset url_str = "#url_str#&member_id=#attributes.member_id#">
			</cfif>	
			<cf_paging page="#attributes.page#" 
				maxrows="#attributes.maxrows#" 
				totalrecords="#attributes.totalrecords#" 
				startrow="#attributes.startrow#" 
				adres="#url_str#">
		</cfif>
 	</cf_box>
</div>	