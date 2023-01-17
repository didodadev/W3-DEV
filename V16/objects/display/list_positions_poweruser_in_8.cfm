<cfform  name="me" action="#request.self#?fuseaction=myhome.emptypopup_settings_process&id=center_down" method="POST">
	<cf_box_elements>
		<div class="form-group"> 
			<div>
				<cf_get_lang dictionary_id='33451.Kişisel İletişim Grupları'><a href="##" onclick="windowopen('<cfoutput>#request.self#?fuseaction=settings.popup_add_users&process=sett</cfoutput>','list')"><span class="icn-md icon-add"></span></a>
			</div>
		</div>
		<cfquery name="GET" datasource="#DSN#">
			SELECT 
				* 
			FROM 
				USERS
			WHERE
				<cfif isDefined("attributes.employee_id")>
					RECORD_MEMBER = #attributes.employee_id#
				<cfelse>
					RECORD_MEMBER = #session.ep.userid#
				</cfif>	
		</cfquery>
		<cfoutput>
			<cfloop from="1" to="#get.recordcount#" index="i">
				<div class="form-group">
					<div>
						<a href="##" onclick="windowopen('#request.self#?fuseaction=settings.popup_upd_users&group_id=#get.GROUP_ID[i]#&process=sett','list')" class="tableyazi">#get.GROUP_NAME[i]#</a>
					</div>
					<div>
						<cfset attributes.par_ids = #get.partners[i]#>
						<cfif len(attributes.par_ids)>
							<cfinclude template="../../myhome/query/get_company_partner.cfm">
							<cfloop list="#valuelist(get_company_partner.fullname)#" index="j">#j#,</cfloop>
						</cfif>
						
						<cfset attributes.cons=#get.consumers[i]#>
						<cfif len(attributes.cons)>
							<cfinclude template="../../myhome/query/get_consumer_det.cfm">
							<cfloop list="#valuelist(get_consumer_det.consumer_name)#" index="s">#s#,</cfloop>
						</cfif>
					</div>
				</div>
			</cfloop>
		</cfoutput>
	</cf_box_elements>
	<cf_box_elements>
		<cfquery name="GET_MYGROUPS" datasource="#DSN#">
			SELECT 
				WORKGROUP_NAME,
				WORKGROUP_ID
			FROM
				WORK_GROUP
			WHERE
				WORKGROUP_ID IN (SELECT WORKGROUP_ID FROM WORKGROUP_EMP_PAR WHERE EMPLOYEE_ID = #attributes.employee_id#)
		</cfquery>
		<div class="form-group">
			<label><cf_get_lang dictionary_id='29818.İş Grupları'></label>
		</div>
		<cfif get_mygroups.recordcount>
			<cfoutput query="get_mygroups">
				<div class="col col-12 col-md-12 col-sm-12 col-xs-12"> 
					<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
						<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_detail_workgroup&workgroup_id=#workgroup_id#','small');" class="tableyazi">#workgroup_name#</a>
					</div>
				</div>
			</cfoutput>
		<cfelse>
			<div>
				<label><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'></label>
			</div>
		</cfif>	
	</cf_box_elements>
</cfform>
