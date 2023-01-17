<cfif fusebox.circuit eq 'myhome'>
	<cfset attributes.notice_id = contentEncryptingandDecodingAES(isEncode:0,content:attributes.notice_id,accountKey:session.ep.userid)>
</cfif>
<cfquery name="GET_NOTICE" datasource="#dsn#">
	SELECT
		NOTICE_HEAD, 
		NOTICE_NO,
		STATUS,
		STATUS_NOTICE,
		DETAIL, 
		POSITION_ID,
		POSITION_NAME,
		POSITION_CAT_ID,
		POSITION_CAT_NAME,
		INTERVIEW_POSITION_CODE, 
		VALIDATOR_POSITION_CODE,
		VALID, 
		VALID_DATE, 
		VALID_EMP,
		STARTDATE, 
		FINISHDATE, 	
		PUBLISH, 
		COMPANY_ID,
		OUR_COMPANY_ID,
		DEPARTMENT_ID,
		BRANCH_ID,
		RECORD_DATE,
		RECORD_IP,
		RECORD_EMP,
		UPDATE_IP,
		UPDATE_DATE,
		UPDATE_EMP,
		NOTICE_CITY,
		COUNT_STAFF,
		WORK_DETAIL,
		PIF_ID,
		IS_VIEW_LOGO,
		IS_VIEW_COMPANY_NAME,
		VIEW_VISUAL_NOTICE,
		SERVER_VISUAL_NOTICE_ID,
		VISUAL_NOTICE
	FROM
		NOTICES
	WHERE
		NOTICE_ID = #attributes.NOTICE_ID#
</cfquery>
<cfsavecontent variable="message"><cf_get_lang dictionary_id="31638.İlan Detay"></cfsavecontent>
<cf_box title="#message#: #get_notice.notice_head#">
	<cf_box_elements>
		<cfif len(get_notice.visual_notice) and isdefined("get_notice.view_visual_notice")>
			<div class="col col-3 col-md-6 col-sm-6 col-xs-12">				
				<cf_get_server_file output_file="hr/#get_notice.visual_notice#" output_server="#get_notice.SERVER_VISUAL_NOTICE_ID#" output_type="0" image_link="0">				
			</div>
			<div class="col col-3 col-md-6 col-sm-6 col-xs-12">	
			<cfelse>
				<div class="col col-3 col-md-6 col-sm-12 col-xs-12">			
		</cfif>
			
				<label class="col col-3 col-md-6 col-sm-6 col-xs-12 bold">
					<cfoutput>(#get_notice.notice_no#)
					<cfif listlen(get_notice.notice_city)>
					<cfset row_count = 0>
					<cfloop list="#get_notice.notice_city#" index="i">
					<cfset row_count = row_count + 1>
					<cfquery name="GET_CITY" datasource="#dsn#">
						SELECT CITY_NAME FROM SETUP_CITY WHERE CITY_ID = #i# 
					</cfquery>
					#GET_CITY.city_name# <cfif row_count lt listlen(get_notice.notice_city,',')>-</cfif>
					</cfloop>
					</cfif>
					</cfoutput>
				</label>
				<tr>
					<td colspan="4" >
						<table width="100%">
						<tr>
							<td>
							<cfif get_notice.is_view_logo eq 1 and len(get_notice.our_company_id)>
								<cfquery name="CHECK" datasource="#DSN#">
									SELECT
										ASSET_FILE_NAME3
									FROM
									OUR_COMPANY
									WHERE
										COMP_ID = #get_notice.our_company_id#
								</cfquery>
								<cfif len(CHECK.asset_file_name3)><cfoutput><img src="#user_domain##file_web_path#settings/#CHECK.asset_file_name3#" border="0"></cfoutput></cfif>
							<cfelse>
							&nbsp;
							</cfif>
							</td>						
							<td style="text-align:right;"><cf_get_lang dictionary_id ='31639.Yayın Tarihi'>: &nbsp;&nbsp;
							<cfif len(get_notice.startdate)><cfoutput>#dateformat(get_notice.startdate,dateformat_style)#</cfoutput></cfif>
							-	  	  
							<cfif len(get_notice.finishdate)><cfoutput>#dateformat(get_notice.finishdate,dateformat_style)#</cfoutput></cfif>
							</td>
						</tr>
						</table>
					</td>
				</tr>
				<tr> 
					<td valign="top" class="txtbold" width="100"><cf_get_lang dictionary_id ='31640.Genel Nitelikler'></td>
					<td colspan="3">
					<cfoutput>#get_notice.detail#</cfoutput>
					</td>
				</tr>
				<tr> 
				<td valign="top" class="txtbold"><cf_get_lang dictionary_id ='31641.İşin Tanımı'></td>
				<td colspan="3"><cfoutput>#get_notice.work_detail#</cfoutput></td>
				</tr>
				<tr>
					<td style="text-align:right;" colspan="2">
						<cfquery name="get_app_pos" datasource="#dsn#">
							SELECT
								APP_POS_ID
							FROM
								EMPLOYEES_APP_POS,
								EMPLOYEES_APP
							WHERE
								EMPLOYEES_APP_POS.NOTICE_ID= #attributes.notice_id#
								AND EMPLOYEES_APP_POS.EMPAPP_ID = EMPLOYEES_APP.EMPAPP_ID
								AND EMPLOYEES_APP.EMPLOYEE_ID= #session.ep.userid#
						</cfquery>
						<cfquery name="GET_APP" datasource="#dsn#">
							SELECT
								EMPAPP_ID
							FROM
								EMPLOYEES_APP
							WHERE
								EMPLOYEE_ID = #session.ep.userid#
						</cfquery>
						<cfif get_app_pos.recordcount>
							<span><B><cf_get_lang dictionary_id='31642.Bu ilana daha önce başvuru yapmıştınız'>.</B></span>
						<cfelseif not get_app.recordcount>
							<a href="javascript://" onClick="window.close();window.open('<cfoutput>#request.self#?fuseaction=myhome.my_profile</cfoutput>','small')"><b><cf_get_lang dictionary_id ='31643.İlana Başvur'> &raquo;</b></a>
						<cfelse>
							<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=myhome.popup_add_app_pos&notice_id=#attributes.notice_id#&empapp_id=#get_app.empapp_id#</cfoutput>','small')"><b><cf_get_lang dictionary_id ='31643.İlana Başvur'>&raquo;</b></a>
						</cfif>

					</td>
				</tr>
				
			</div>
	</cf_box_elements>
</cf_box>
