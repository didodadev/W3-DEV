<cfquery name="CHIEFS_CANDIDATE" datasource="#dsn#">
	SELECT 
		SB_ID, 
		CANDIDATE_POS_1, 
		CANDIDATE_POS_2, 
		CANDIDATE_POS_3, 
		CHIEF1_CODE,
		CHIEF2_CODE, 
		CHIEF3_CODE 
	FROM 
		EMPLOYEE_POSITIONS_STANDBY 
	WHERE 
		POSITION_CODE = #attributes.active_position_code#
</cfquery>
<div class="ui-block">
	<p><b><cf_get_lang dictionary_id='31049.Amirler'> - <cf_get_lang dictionary_id='31470.Yedekler'></b></p>
		<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
			<p><b><cf_get_lang dictionary_id='35927.Birinci Amir'></b></p>
			<cfif len(chiefs_candidate.chief1_code)>
				<p>
					<cfset attributes.position_code = chiefs_candidate.chief1_code>
					<cfinclude template="../query/get_position_info.cfm">
					<cfoutput><a href="javascript://"  onClick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#get_position_info.employee_id#','medium');" class="tableyazi">#get_position_info.employee_name# #get_position_info.employee_surname#</a> / #get_position_info.position_name#</cfoutput>
				</p>
			</cfif>
					
			<p><b><cf_get_lang dictionary_id='35921.İkinci Amir'></b></p>
			<cfif len(chiefs_candidate.chief2_code)>
				<p>
					<cfset attributes.position_code = chiefs_candidate.chief2_code>
					<cfinclude template="../query/get_position_info.cfm">
					<cfoutput><a href="javascript://"  onClick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#get_position_info.employee_id#','medium');" class="tableyazi">#get_position_info.employee_name# #get_position_info.employee_surname#</a> / #get_position_info.position_name#</cfoutput>
				</p>
			</cfif>
		</div>
		<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
			<p><b>1.<cf_get_lang dictionary_id='31034.Yedek'></b></p>
			<cfif len(chiefs_candidate.CANDIDATE_POS_1)>
				<p>
					<cfset attributes.position_code = chiefs_candidate.CANDIDATE_POS_1>
					<cfinclude template="../query/get_position_info.cfm">
					<cfoutput><a href="javascript://"  onClick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#get_position_info.employee_id#','medium');" class="tableyazi">#get_position_info.employee_name# #get_position_info.employee_surname#</a> / #get_position_info.position_name#</cfoutput>
				</p>
			</cfif>
			<p><b>2.<cf_get_lang dictionary_id='31034.Yedek'></b></p>
			<cfif len(chiefs_candidate.CANDIDATE_POS_2)>
				<p>
					<cfset attributes.position_code = chiefs_candidate.CANDIDATE_POS_2>
					<cfinclude template="../query/get_position_info.cfm">
					<cfoutput><a href="javascript://"  onClick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#get_position_info.employee_id#','medium');" class="tableyazi">#get_position_info.employee_name# #get_position_info.employee_surname#</a> / #get_position_info.position_name#</cfoutput>
				</p>
			</cfif>
			<p><b>3.<cf_get_lang dictionary_id='31034.Yedek'></b></p>		
				<cfif len(chiefs_candidate.CANDIDATE_POS_3)>
					<p>
						<cfset attributes.position_code = chiefs_candidate.CANDIDATE_POS_3>
						<cfinclude template="../query/get_position_info.cfm">
						<cfoutput><a href="javascript://"  onClick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#get_position_info.employee_id#','medium');" class="tableyazi">#get_position_info.employee_name# #get_position_info.employee_surname#</a>/#get_position_info.position_name#</cfoutput>
					</p>	
				</cfif>	
		</div>
</div>
<p><b><cf_get_lang dictionary_id='29908.Görüş Bildiren'></b></p>	
	<cfif len(chiefs_candidate.chief3_code)>
		<p>
			<cfset attributes.position_code = chiefs_candidate.chief3_code>
			<cfinclude template="../query/get_position_info.cfm">
			<cfoutput><a href="javascript://"  onClick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#get_position_info.employee_id#','medium');" class="tableyazi">#get_position_info.employee_name# #get_position_info.employee_surname#</a> / #get_position_info.position_name#</cfoutput>
		</p>
	</cfif>

<cfquery name="get_company" datasource="#dsn#">
	SELECT COMPANY_NAME,COMP_ID,NICK_NAME FROM OUR_COMPANY WHERE MANAGER_POSITION_CODE = #attributes.active_position_code#
</cfquery>
<cfquery name="get_branch_" datasource="#dsn#">
	SELECT DISTINCT  BRANCH_ID, BRANCH_NAME,ADMIN1_POSITION_CODE,ADMIN2_POSITION_CODE FROM BRANCH WHERE ADMIN1_POSITION_CODE = #attributes.active_position_code# OR ADMIN2_POSITION_CODE = #attributes.active_position_code#
</cfquery>
<cfquery name="get_department_" datasource="#dsn#">
	SELECT DISTINCT DEPARTMENT_HEAD,ADMIN1_POSITION_CODE,ADMIN2_POSITION_CODE,DEPARTMENT_ID FROM DEPARTMENT WHERE ADMIN1_POSITION_CODE = #attributes.active_position_code# OR ADMIN2_POSITION_CODE = #attributes.active_position_code#
</cfquery>
<cfif get_branch_.recordcount or get_department_.recordcount or get_company.recordcount>
<p><b><cf_get_lang dictionary_id ='31546.Yönetici Olduğum Birimler'></b></p>
<div class="ui-block">
	<cfif get_company.recordcount>
		<div class="col col-4 col-md-4 col-xs-6 col-xs-12">	
			<p><cf_get_lang dictionary_id ='57574.Şirket'></p>
			<cfoutput query="get_company">
				<p>#NICK_NAME#</p>	
			</cfoutput>
		</div>
	</cfif>
	<cfif get_branch_.recordcount>
		<div class="col col-4 col-md-4 col-xs-6 col-xs-12">
			<p><cf_get_lang dictionary_id ='57453.Şube'></p>
			<cfoutput query="get_branch_">
				<p><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_detail_branch&id=#branch_id#','list');" class="tableyazi">#BRANCH_NAME#</a> - <cfif get_branch_.ADMIN1_POSITION_CODE eq attributes.active_position_code>1.<cf_get_lang dictionary_id='29511.Yönetici'><cfelse>2.<cf_get_lang dictionary_id='29511.Yönetici'></cfif></p>
			</cfoutput>
		</div>
	</cfif>
	<cfif get_department_.recordcount>
		<div class="col col-4 col-md-4 col-xs-6 col-xs-12">	
			<p><cf_get_lang dictionary_id ='57572.Departman'></p>
			<cfoutput query="get_department_">
				<p><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_list_department_position&department_id=#department_id#','list');" class="tableyazi">#department_head#</a>-<cfif get_department_.ADMIN1_POSITION_CODE eq attributes.active_position_code>1.<cf_get_lang dictionary_id='29511.Yönetici'><cfelse>2.<cf_get_lang dictionary_id='29511.Yönetici'></cfif></p>
			</cfoutput>
		</div>
	</cfif>
</div>	
</cfif>
