<cf_xml_page_edit fuseact="myhome.my_position">
	<cfquery name="GET_My_Profile" datasource="#dsn#">                        
		SELECT 
			W.NAME,
			W.SURNAME ,                            
			W.POSITION_NAME,
			E.PHOTO,  
			E2.SEX                                                     
		FROM
			WRK_SESSION AS W
			LEFT JOIN EMPLOYEES AS E ON E.EMPLOYEE_ID = W.USERID
			LEFT JOIN EMPLOYEES_DETAIL AS E2 ON E2.EMPLOYEE_ID = W.USERID                             
		WHERE
		   W.USERID=#session.ep.userid#
		</cfquery> 
		<cfloop query="GET_My_Profile" startrow=1 endrow="#GET_My_Profile.recordcount#">
		<cfset My_Name = Name>
		<cfset My_Surname = SURNAME>
		<cfset My_Position = POSITION_NAME> 
		<cfset My_Photo = PHOTO> 
		<cfset My_Sex = SEX>  
		</cfloop> 
	<cf_catalystHeader>
	<cfquery name="GET_POSITION_DETAIL" datasource="#DSN#">
		SELECT
			*
		FROM
			EMPLOYEE_POSITIONS,
			DEPARTMENT,
			BRANCH,
			OUR_COMPANY,
			ZONE
		WHERE
			EMPLOYEE_POSITIONS.DEPARTMENT_ID=DEPARTMENT.DEPARTMENT_ID AND
			DEPARTMENT.BRANCH_ID=BRANCH.BRANCH_ID AND
			OUR_COMPANY.COMP_ID=BRANCH.COMPANY_ID AND
			BRANCH.ZONE_ID=ZONE.ZONE_ID AND 
			EMPLOYEE_POSITIONS.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
	</cfquery>
	<cfinclude template="../query/get_modules.cfm">
	<div class="col col-2 col-xs-12 uniqueRow">
		<cf_box>
			<div class="row divBox">
				<div class="profile-userpic text-center">  
					<cfif len(My_Photo)>
						<img class="img-circle" title="<cfoutput>#My_Position# - #My_Name# #My_Surname#</cfoutput>" src="../documents/hr/<cfoutput>#My_Photo#</cfoutput>" />
					<cfelseif My_Sex eq 1>
						<img class="img-circle" title="<cfoutput>#My_Name# #My_Surname#</cfoutput>" src="../images/male.jpg" />
					<cfelse>
						<img class="img-circle" title="<cfoutput>#My_Name# #My_Surname#</cfoutput>" src="../images/female.jpg" />
					</cfif>
					<div class="profile-usertitle-name"><cfoutput>#My_Name# #My_Surname#</cfoutput></div>
					<div class="profile-usertitle-job"><cfoutput>#My_Position#</cfoutput></div>
				</div>
				<div class="profile-usermenu">
					<ul class="navBox acordionUl">
						<li><a style="font-size:15px!important;" href="<cfoutput>#request.self#</cfoutput>?fuseaction=myhome.my_position"><i class="icn-md catalyst-briefcase" style="font-size:15px!important;" title="<cf_get_lang dictionary_id='30793.Pozisyonum'>"></i>&nbsp;<cf_get_lang dictionary_id='30793.Pozisyonum'></a></li>
						<li><a style="font-size:15px!important;" href="<cfoutput>#request.self#</cfoutput>?fuseaction=myhome.my_profile"><i class="icn-md catalyst-book-open" style="font-size:15px!important;" title="<cf_get_lang dictionary_id='49821.Özgeçmiş'>"></i>&nbsp;<cf_get_lang dictionary_id='49821.Özgeçmiş'></a></li>
						<li><a style="font-size:15px!important;" href="<cfoutput>#request.self#</cfoutput>?fuseaction=myhome.my_detail"><i class="icn-md catalyst-info" style="font-size:15px!important;" title="<cf_get_lang dictionary_id='31150.Bilgilerim'>"></i>&nbsp;<cf_get_lang dictionary_id='31150.Bilgilerim'></a></li>
						<!--- <li><a style="font-size:15px!important;" href="javascript:;" onclick="pageLoad('myhome.my_profile')"><i class="icn-md catalyst-pie-chart" style="font-size:15px!important;" title="<cf_get_lang dictionary_id='31446.Özgeçmiş'>"></i>&nbsp;<cf_get_lang dictionary_id='31446.Özgeçmiş'></a></li>
						<li><a style="font-size:15px!important;" href="javascript:;" onclick="pageLoad('myhome.my_detail')"><i class="icn-md catalyst-users" style="font-size:15px!important;"></i>&nbsp;<cf_get_lang dictionary_id='31150.Bilgilerim'></a></li> --->
						<li><a style="font-size:15px!important;" href="<cfoutput>#request.self#</cfoutput>?fuseaction=myhome.dashboard" target="_blank"><i class="icn-md catalyst-pie-chart" style="font-size:15px!important;"></i>&nbsp;<cf_get_lang dictionary_id='63588.Dashboard'></a></li>
						<!--- <li><a style="font-size:15px!important;" href="javascript:;" onclick="pageLoad('myhome.hr')"><i class="icn-md catalyst-users" style="font-size:15px!important;"></i>&nbsp;IK İşlemleri</a></li> --->
						<li><a style="font-size:15px!important;" href="<cfoutput>#request.self#</cfoutput>?fuseaction=myhome.hr" target="_blank"><i class="icn-md catalyst-users" style="font-size:15px!important;"></i>&nbsp;<cf_get_lang dictionary_id='47630.IK İşlemleri'></a></li>
						<li><a style="font-size:15px!important;" href="<cfoutput>#request.self#</cfoutput>?fuseaction=myhome.other_hr" target="_blank"><i class="icn-md catalyst-plane" style="font-size:15px!important;"></i>&nbsp;<cf_get_lang dictionary_id='48428.Diğer İşlemler'></a></li>
						<li><a style="font-size:15px!important;" href="<cfoutput>#request.self#</cfoutput>?fuseaction=myhome.myTeam" target="_blank"><i class="icn-md catalyst-target" style="font-size:15px!important;"></i>&nbsp;<cf_get_lang dictionary_id='61183.Ekibim ve Ben'></a></li>
						
						<li><a style="font-size:15px!important;" href="<cfoutput>#request.self#</cfoutput>?fuseaction=myhome.upd_myweek" target="_blank"><i class="icn-md catalyst-clock" style="font-size:15px!important;"></i>&nbsp;<cf_get_lang dictionary_id='32219.Zaman Yönetimi'></a></li>
						<!--- <li><a href="javascript:;" onclick="pageLoad('myhome.my_extre')"><i></i><cf_get_lang dictionary_id='57809.Hesap Ekstresi'></a></li>
						<li><a href="javascript:;" onclick="pageLoad('myhome.list_my_extra_times')"><i></i><cf_get_lang dictionary_id='30866.Mesai'></a></li>                           
						<li><a href="javascript:;" onclick="pageLoad('myhome.my_offtimes')"><i></i><cf_get_lang dictionary_id='30820.İzinler'></a></li>
						<li><a href="javascript:;" onclick="pageLoad('myhome.my_targets')"><i></i><cf_get_lang dictionary_id='57964.hedeflerim'></a></li>
						<li><a href="javascript:;" onclick="pageLoad('myhome.health_expense_approve')"><i></i><cf_get_lang dictionary_id='45055.Sağlık'></a></li>
						<li><a href="javascript:;" onclick="pageLoad('myhome.list_travel_demands')"><i></i><cf_get_lang dictionary_id='59973.Seyahat'></a></li>
						<li><a href="javascript:;" onclick="pageLoad('myhome.mytime_management')"><i></i><cf_get_lang_main dictionary_id='32219.Zaman Yönetimi'></a></li>
						<li><a href="javascript:;" onclick="pageLoad('myhome.my_expenses')"><i></i><cf_get_lang dictionary_id='31116.Harcamalar'></a></li>     
						<li><a href="javascript:;" onclick="pageLoad('myhome.list_my_tranings')"><i></i><cf_get_lang_main dictionary_id='57419.Eğitim'></a></li>    
						<li><a href="javascript:;" onclick="pageLoad('myhome.list_assetp')"><i></i><cf_get_lang dictionary_id='57420.Varlıklar'></a></li>
						<li><a href="javascript:;" onclick="pageLoad('myhome.allowance_expense')"><i></i><cf_get_lang dictionary_id='59777.Harcırahlar'></a></li> --->
					</ul>
				</div>
			</div>
		</cf_box>
	</div>
	<div class="col col-10 col-xs-12 uniqueRow">  
		<cf_box title="#getLang('','Pozisyon',58497)# : #session.ep.position_name#" closable="0">
			<div class="ui-info-text">
				<cfoutput query="get_position_detail">
					<cfif len(user_group_id)>
						<p><b><cf_get_lang dictionary_id='31009.Kullanıcı Grubu'></b></p>
						<p><cfinclude template="../query/get_user_groups.cfm">#get_user_groups.user_group_name#</p>
					</cfif>
					<p><b><cf_get_lang dictionary_id='57972.Organizasyon'></b></h2>
					<p>#zone_name# - #nick_name# - #branch_name# - <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_list_department_position&department_id=#department_id#','list');" class="tableyazi">#department_head#</a></p>
					<cfset attributes.active_position_code = GET_POSITION_DETAIL.position_code>
					<cfinclude template="my_position_standby.cfm">
					
					<cfset attributes.position_id = get_position_detail.position_id>
					<cfinclude template="../query/get_position_content.cfm">
					
					<cfset attributes.POSITION_CAT_ID = get_position_detail.POSITION_CAT_ID>
					<cfinclude template="../query/get_positioncat_content.cfm">
					
					<cfif get_position_content.recordcount>
						<cfloop query="GET_POSITION_CONTENT">
							<cfif get_position_content.recordcount or get_positioncat_content.recordcount>				
								<p><b><cf_get_lang dictionary_id='31014.Yetki ve Sorumluluklar'></b></p>		
							</cfif>				
							<p>#GET_POSITION_CONTENT.AUTHORITY_HEAD#</p>
							<p>#GET_POSITION_CONTENT.AUTHORITY_DETAIL#<p>
						</cfloop>
					</cfif>
	
					<cfif get_positioncat_content.recordcount>
						<cfloop query="GET_POSITIONCAT_CONTENT">
							<p>#GET_POSITIONCAT_CONTENT.AUTHORITY_HEAD# (<cf_get_lang dictionary_id='59004.Pozisyon Tipi'>)</p>
							<p>#GET_POSITIONCAT_CONTENT.AUTHORITY_DETAIL#</p>
						</cfloop>
					</cfif>        
				</cfoutput>  
			</div>
		</cf_box>
		<cf_box title="#getLang('','İş Grubu',58140)#">
			<cf_flat_list>
				<tbody>
					<cfquery name="get_pos_code" datasource="#DSN#">
						SELECT POSITION_CODE FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
					</cfquery>
					<cfquery name="get_mygroups" datasource="#DSN#">
						SELECT WORKGROUP_NAME, WORKGROUP_ID FROM WORK_GROUP WHERE WORKGROUP_ID IN (SELECT WORKGROUP_ID FROM WORKGROUP_EMP_PAR WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_pos_code.position_code#"> OR EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">)
					</cfquery>
					<thead>
						<th></th>
					</thead>
					<tbody>
						<cfif get_mygroups.recordcount>
							<cfoutput query="get_mygroups">
								<tr>
									<td><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_detail_workgroup&workgroup_id=#workgroup_id#','small');" class="tableyazi">#workgroup_name#</a></td>
								</tr>
							</cfoutput>
						<cfelse>
							<tr>
								<td colspan="2"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
							</tr>
						</cfif>
					</tbody>
				</tbody>
			</cf_flat_list>
		</cf_box>
	</div>

	<script type="text/javascript">
		$(document).ready(function(){
			$(".ui-multiselect-menu").css({"display" : "none"});
			<cfif isdefined("attributes.section")>
				pageLoad('<cfoutput>#attributes.section#</cfoutput>');	
			</cfif>
		});	
		
		function connectAjax(row_id,row_act_id)
		{
			var page = '<cfoutput>#request.self#?fuseaction=myhome.popupajax_authority_responsible&auth_id='+row_act_id+'</cfoutput>';
			AjaxPageLoad(page,'LIST_POSITIONCAT_CONTENT'+row_id+'',1);
		}
		function connectAjax2(row_id,row_act_id)
		{
			var page = '<cfoutput>#request.self#?fuseaction=myhome.popupajax_authority_responsible&auth_id='+row_act_id+'</cfoutput>';
			AjaxPageLoad(page,'LIST_POSITION_CONTENT'+row_id+'',1);
		}
	
	$(function(){
	$(".portBox").find(".fa-angle-down").click(function(){	
		$(this).parent().next(".portBody").slideToggle(100);
		
		});
	
	});//ready
	function pageVariablesFunction(page,formName)
	{
		
		window.basket = [];
		
		var pageLink = '';
		
		$("#"+formName).find("input,select,textarea").each(function(index,element){

				
				if($(element).is("input") && $(element).attr("type") == "checkbox")
				{
					if($(element).is(":checked"))
						pageLink = pageLink + '&' + $(element).attr("name") + '=1';

				}
				else if($(element).is("input") && $(element).attr("type") == "radio")
				{
					if ($(element).is(":checked"))
						pageLink = pageLink + '&' + $(element).attr("name") + '='+$(element).val();

				}
				else
				{
					pageLink = pageLink + '&' + $(element).attr("name") + '='+$(element).val();

				}
				
			})
			
		 pageLoad(page+pageLink);
	}

	function pageLoad(page){
        AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction='+page+'&spa=1','ajaxContent');
	}
	</script>	
	