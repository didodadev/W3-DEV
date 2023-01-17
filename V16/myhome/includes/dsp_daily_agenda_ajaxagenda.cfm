<cf_xml_page_edit fuseact ="myhome.welcome">
<cfsetting showdebugoutput="no">
<cfset add_format_ = "D"><!--- Gonderilecek Format Gundemde Gun Bazinda --->
<cfset is_gundem = 1><!--- Gundem ekraninda rin gosterimi ajanda ile farkli oldugundan ayirt edici parametre gonderiliyor --->
<cfset attributes.to_day = CreateDate(year(now()),month(now()), day(now()))>
<cfset tarih = dateformat(date_add("h",session.ep.time_zone,attributes.to_day),dateformat_style)>
<cfinclude template="../../agenda/query/get_all_agenda_department_branch.cfm"><!--- Yetkili Oldugum Sube ve Departmanlar --->

<cfquery name="MY_SETT1" datasource="#DSN#">
	SELECT DAY_AGENDA, ISNULL(PRIVATE_AGENDA,0) PRIVATE_AGENDA, ISNULL(BRANCH_AGENDA,0) BRANCH_AGENDA, ISNULL(DEPARTMENT_AGENDA,0 )DEPARTMENT_AGENDA FROM MY_SETTINGS WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"> 
</cfquery>
<cfif len(MY_SETT1.day_agenda)>
	<cfif MY_SETT1.department_agenda eq 1>
		<cfset attributes.view_agenda = 1>
	<cfelseif MY_SETT1.branch_agenda eq 1>		
		<cfset attributes.view_agenda = 2>
	<cfelseif MY_SETT1.department_agenda eq 0 and MY_SETT1.branch_agenda eq 0 and MY_SETT1.private_agenda eq 0>
		<cfset attributes.view_agenda = 3>
	</cfif>
</cfif>

<cfinclude template="../../agenda/query/get_all_agenda_classes.cfm"><!--- Egitimler ---> 
<cfinclude template="../../agenda/query/get_daily_events.cfm"><!--- Ajanda Kayitlari --->
<cfinclude template="../../agenda/query/get_event_plan_rows.cfm"><!--- Ziyaret Planlari --->
<cfinclude template="../../agenda/query/get_daily_warning.cfm"><!--- Uyarilar (Ajanda ve Uyari) --->
<cfinclude template="../../agenda/query/get_all_organizations.cfm"><!--- Etkinlikler --->
<cfsavecontent variable="agendamessage"><cf_get_lang_main no='3.Ajanda'></cfsavecontent>
<cfset attributes.to_day = CreateDate(year(now()),month(now()), day(now()))>
<cfset tarih = dateformat(date_add("h",session.ep.time_zone,attributes.to_day),dateformat_style)>
<cfset visit_analyse = "">
<ul class="lightList agendaDayTime text-left">

		<cfloop from="8" to="20" index="i">
		
			<cfoutput>
            <li class="lightListHead "><a href="#request.self#?fuseaction=agenda.view_daily&event=add&amp;temp_date=#tarih#&hour=#i#"><i class="catalyst-clock"></i>#timeformat("#i#:00",timeformat_style)#</a></li>			
				<cfset attributes.hourstart=date_add('h',i-session.ep.time_zone,attributes.to_day)>
				<cfset attributes.hourfinish=date_add('h',i-session.ep.time_zone+1,attributes.to_day)>
				
				<cfloop query="get_daily_events">					
					<cfif ((get_daily_events.startdate gte attributes.hourstart) and (get_daily_events.startdate lt attributes.hourfinish)) or ((get_daily_events.finishdate gte attributes.hourstart) and (get_daily_events.finishdate lt attributes.hourfinish))>
						<li>
						<!--- Bu bolum sorun olursa konntrol edilmeli,sube ve departmen ve herkes gorsun olayı. Gerekirse eski if bloklarına bakalım BK 20080331 --->
						<cfif get_daily_events.startdate gte attributes.hourstart and get_daily_events.startdate lt attributes.hourfinish>
                       		<i class="catalyst-bell font-green-turquoise" title="<cf_get_lang_main no='1055.Start'>"></i>							
						<cfelse>
                            <i class="catalyst-bell font-red-intense" title="<cf_get_lang_main no='90.Bitiş'>"></i>
						</cfif>
						<cfquery name="get_eventcat_colour" datasource="#dsn#">
							SELECT COLOUR FROM EVENT_CAT WHERE EVENTCAT = <cfqueryparam cfsqltype="cf_sql_varchar" value="#eventcat#">
						</cfquery>
						<a href="#request.self#?fuseaction=agenda.view_daily&event=upd&event_id=#event_id#"  title="#mid(event_detail,1,250)#">#eventcat#-#event_head#</a>	
						<cfif get_daily_events.event_place_id eq 1><span class="font-blue">(<cf_get_lang no='110.Ofisiçi'>)</span></cfif>
						<cfif get_daily_events.event_place_id eq 2><span class="font-blue">(<cf_get_lang no='119.Ofis Dışı'>)</span></cfif>
						<cfif get_daily_events.event_place_id eq 3><span class="font-blue">(<cf_get_lang no='1607.Müşteri Ofisi'>)</span></cfif>
						<!--- Bu bolum sorun olursa konntrol edilmeli,sube ve departmen ve herkes gorsun olayı. Gerekirse eski if bloklarına bakalım BK 20080331 --->
						<cfif len(get_daily_events.validator_position_code) and  not len(get_daily_events.VALID)>
							(<cf_get_lang_main no='203.Onay Bekliyor'>)
						</cfif>	
                        </li>					
					</cfif>                    
				</cfloop>
				<cfloop query="get_event_plan">
					<cfif len(is_sales)>
						<cfset value_is_sales = is_sales>
					<cfelse>
						<cfset value_is_sales = 0>
					</cfif>
					<cfif hour(attributes.hourstart) eq hour(date_add("h",-2,get_event_plan.start_date))>
						<cfif not len(event_plan_id)>
							<li><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=crm.popup_form_upd_visit&eventid=#event_plan_id#&event_plan_row_id=#event_plan_row_id#&member_id=#member_id#&type=#value_is_sales#','project');"><!--- <cfif get_event_plan.is_sales eq 1>#get_event_cat.eventcat[ListFind(event_cat_list,warning_id,',')]#<cfelse>#get_cat.visit_type[ListFind(cat_list,warning_id,',')]#</cfif> ---><cfif listlen(event_plan_head,'-') gte 2>#listfirst(event_plan_head,'-')# - <cfelse>#left(event_plan_head,20)# - </cfif><cfif Len(fullname)>#fullname# - </cfif>#member_name# #member_surname# - <span class="font-green-turquoise"> Ziyaret</span></a></li>
						<cfelse>
							<li><a href="##" onClick="pencere_ac_upd(#event_plan_id#,#event_plan_row_id#,#member_id#,#company_id#,#value_is_sales#);"><!--- <cfif get_event_plan.is_sales eq 1>#get_event_cat.eventcat[ListFind(event_cat_list,warning_id,',')]#<cfelse>#get_cat.visit_type[ListFind(cat_list,warning_id,',')]#</cfif> ---><cfif listlen(event_plan_head,'-') gte 2>#listfirst(event_plan_head,'-')# - <cfelse>#left(event_plan_head,20)# - </cfif><cfif Len(fullname)>#fullname# - </cfif>#member_name# #member_surname# - <span class="font-green-turquoise">Ziyaret</span></a></li>
							
						</cfif>
					</cfif>
					<cfif x_show_visit_analyse_form eq 1 and Len(analyse_id)>
						<cfquery name="get_analyse_member" datasource="#dsn#">
							SELECT
								MAR.RESULT_ID
							FROM
								MEMBER_ANALYSIS MA,
								MEMBER_ANALYSIS_RESULTS MAR
							WHERE
								MA.ANALYSIS_ID = MAR.ANALYSIS_ID AND
								MA.ANALYSIS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#analyse_id#"> AND
								<cfif Len(company_id)>
									MAR.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#company_id#"> AND
									MAR.PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#member_id#">
								<cfelseif Len(consumer_id)>
									MAR.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#member_id#">
								</cfif>
						</cfquery>
						<cfset visit_analyse = analyse_id><!--- Analiz Formu Varsa Asagida Kullanilacak --->
						<cfif get_analyse_member.recordcount><cfset visit_analyse_result_id = get_analyse_member.result_id><cfelse><cfset visit_analyse_result_id = ""></cfif>
					</cfif>
				</cfloop>
			
			</cfoutput> 
		
		</cfloop>
		<cfset attributes.fromHome=true> 
	  <cfif get_daily_warnings.recordcount>
		<tr>
			<td><img src="/images/listele.gif" width="7" height="12" align="absmiddle"><cf_get_lang no='107.Uyarılar'></td>
		</tr>
		<tr>
			<td>
			<table>
			  <cfoutput query="get_daily_warnings">
			        <cfset parent_id_ = contentEncryptingandDecodingAES(isEncode:1,content:#parent_event_id#,accountKey:'wrk')>
					<cfset event_id_ = contentEncryptingandDecodingAES(isEncode:1,content:#event_id#,accountKey:'wrk')>
				<tr>
					<td>*&nbsp;
						<cfif type eq 1>
							<a href="#request.self#?fuseaction=agenda.view_daily&event=upd&event_id=#event_id#" class="tableyazi">#event_head#</a>
						<cfelse>
							<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=myhome.popup_dsp_warning&warning_id=#parent_id_#&warning_is_active=0&sub_warning_id=#event_id_#','medium');" class="tableyazi">#event_head#</a> (Uyarı)
						</cfif>
						<cfif not len(event_place_id)>
						<cfelseif event_place_id eq 1><font color=red>(<cf_get_lang no='110.Ofisiçi'>)
						<cfelseif event_place_id eq 2><font color=red>(<cf_get_lang no='119.Ofis Dışı'>)
						<cfelseif event_place_id eq 3><font color=red>(<cf_get_lang no='111.3 Parti Kurum'>)
						</cfif>
					</td>
				</tr>
			  </cfoutput>
			</table>
			</td>
		</tr>
	</cfif>
	<cfif get_all_agenda_classes.recordcount>
		<tr>
			<td><img src="/images/listele.gif" align="absmiddle"><cf_get_lang_main no='2115.Eğitimler'></td>
		</tr>
	 <cfoutput query="get_all_agenda_classes">
		<tr>
			<td><a href="#request.self#?fuseaction=training.view_class&class_id=#class_id#" class="tableyazi">#class_name#</a></td>
		</tr>
	  </cfoutput>
	<cfelseif get_all_agenda_classes_inform.recordcount>
		<tr>
			<td><img src="/images/listele.gif" align="absmiddle"><cf_get_lang_main no='2115.Eğitimler'></td>
		</tr>
		<cfoutput query="get_all_agenda_classes_inform">
		<tr>
			<td><a href="#request.self#?fuseaction=training.view_class&class_id=#class_id#" class="tableyazi">#class_name#</a>(Bilgi Amaçlı)</td>
		</tr>
		</cfoutput>
	</cfif>
	<cfif get_all_organizations.recordcount><!--- Etkinlikler --->
		<tr>
			<td><img src="/images/listele.gif" align="absmiddle"><cf_get_lang_main no='1668.Etkinlik'></td>
		</tr>
		<cfoutput query="get_all_organizations">
		<tr>
			<td>
				<a href="#request.self#?fuseaction=campaign.form_upd_organization&org_id=#organization_id#" class="tableyazi">
				<cfif dateformat(now(),dateformat_style) eq dateformat(start_date,dateformat_style)>
					<img src="/images/starton.gif" border="0"  title="<cf_get_lang_main no='1055.Start'>" align="absmiddle"><font style="color:009900">#organization_head#</font>
				</cfif>
				<cfif dateformat(now(),dateformat_style) eq dateformat(finish_date,dateformat_style)>
					<img src="/images/stop.gif" border="0" title="<cf_get_lang_main no='90.Bitiş'>"  align="absmiddle"><font style="color:FF0000">#organization_head#</font>
				</cfif>
				<cfif dateformat(now(),dateformat_style) neq dateformat(finish_date,dateformat_style) and dateformat(now(),dateformat_style) neq dateformat(start_date,dateformat_style)>
					#organization_head#
				</cfif>
				</a>
			</td>
		</tr>
		</cfoutput>
	</cfif> 

</ul>

<script type="text/javascript">
	<cfoutput>
	<cfif x_show_visit_analyse_form eq 1 and Len(visit_analyse)>
		function open_event_result(event_plan_id,event_plan_row_id,member_id,company_id,visit_analyse,type)
		{
			if(visit_analyse != "")
			{	
				if(type == 1) var member_type_ = "partner"; else var member_type_ = "consumer";
				member_links = '&member_type='+member_type_+'&company_id='+company_id+'&partner_id='+member_id+'&consumer_id='+member_id;
				if("#visit_analyse_result_id#" != "")
					windowopen('#request.self#?fuseaction=member.popup_upd_member_analysis_result&action_type=MEMBER&analysis_id='+visit_analyse+'&result_id=#visit_analyse_result_id#'+member_links ,'page');
				else
					windowopen('#request.self#?fuseaction=member.popup_add_member_analysis_result&action_type=MEMBER&action_type_id=&analysis_id='+visit_analyse+member_links,'page');
			}
		}
	</cfif>
	
	function pencere_ac_upd(event_plan_id,event_plan_row_id,partner_id,company_id,result_id)
	{
		openBoxDraggable('#request.self#?fuseaction=objects.event_plan_result&event=upd&eventid=' + event_plan_id +'&event_plan_row_id=' + event_plan_row_id + '&partner_id=' + partner_id + '&result_id=' + result_id,'project');
		<cfif x_show_visit_analyse_form eq 1 and Len(visit_analyse)>
			open_event_result(event_plan_id,event_plan_row_id,partner_id,company_id,"#visit_analyse#",result_id);
		</cfif>
	}
	function pencere_ac(event_plan_id,event_plan_row_id,partner_id,company_id)
	{
		openBoxDraggable('#request.self#?fuseaction=objects.event_plan_result&eventid=' + event_plan_id +'&event_plan_row_id=' + event_plan_row_id + '&partner_id=' + partner_id,'project');
		<cfif x_show_visit_analyse_form eq 1 and Len(visit_analyse)>
			open_event_result(event_plan_id,event_plan_row_id,member_id,company_id,"#visit_analyse#",result_id);
		</cfif>
	}
	</cfoutput>
</script>



