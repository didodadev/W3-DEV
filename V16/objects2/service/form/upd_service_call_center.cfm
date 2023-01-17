<cfset attributes.id = attributes.service_id>
<cfquery name="GET_SERVICE_DETAIL" datasource="#DSN#">
	SELECT 
		S.PRIORITY_ID,
        S.COMMETHOD_ID,
        S.SERVICE_HEAD,
        S.SERVICE_DETAIL,
        S.SERVICE_BRANCH_ID,
        S.SERVICECAT_ID,
        S.SERVICE_ID,
        S.SERVICE_COMPANY_ID,
        S.SERVICE_PARTNER_ID,
        S.SERVICE_CONSUMER_ID,
        S.SERVICE_EMPLOYEE_ID,
        S.PROJECT_ID,
        S.SERVICE_STATUS_ID,
        S.SERVICE_NO,
        S.REF_NO,
        S.SERVICE_ACTIVE,
        S.APPLICATOR_NAME,
        S.APPLY_DATE,
        S.START_DATE,
        S.FINISH_DATE,
        S.RECORD_PAR  
	FROM
		G_SERVICE S,
		G_SERVICE_APPCAT SA,
		SETUP_COMMETHOD AS SCM,
		SETUP_PRIORITY SP
	WHERE 
		S.SERVICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.service_id#"> AND
		S.SERVICECAT_ID = SA.SERVICECAT_ID AND
		SCM.COMMETHOD_ID = S.COMMETHOD_ID AND
		SP.PRIORITY_ID = S.PRIORITY_ID AND
		<cfif isdefined("session.pp.company_id")>
			(
				S.SERVICE_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.company_id#"> OR
				S.SERVICE_COMPANY_ID IN (SELECT COMPANY_ID FROM COMPANY WHERE HIERARCHY_ID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.company_id#">) OR
				S.SERVICE_CONSUMER_ID IN (SELECT CONSUMER_ID FROM CONSUMER WHERE HIERARCHY_ID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.company_id#">)
			)
		<cfelseif isdefined("session.ww.userid")>
			(
				S.SERVICE_CONSUMER_ID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#"> OR
				<!---S.SERVICE_CONSUMER_ID IN (SELECT CONSUMER_ID FROM CONSUMER WHERE REF_POS_CODE =  <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#">)--->
				S.RECORD_CONS = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#">
			)
		<cfelse>
			1 = 0
		</cfif>
</cfquery>
<cfif not get_service_detail.recordcount>
	<script type="text/javascript">
		alert("Böyle Bir Kayıt Bulunamadı veya Yetkiniz Yok!");
		history.back(-1);
	</script>
	<cfabort>
</cfif>
<cfif len(get_service_detail.priority_id)>
	<cfquery name="GET_PRIORITY" datasource="#DSN#">
		SELECT 
			PRIORITY 
		FROM 
			SETUP_PRIORITY
		WHERE 
			PRIORITY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_service_detail.priority_id#">
		ORDER BY
			PRIORITY
	</cfquery>
</cfif>
<cfif len(get_service_detail.commethod_id)>
	<cfquery name="GET_COM_METHOD" datasource="#DSN#">
		SELECT 
			COMMETHOD 
		FROM  
			SETUP_COMMETHOD 
		WHERE 
			COMMETHOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_service_detail.commethod_id#">
	</cfquery>
</cfif>
<cfif len(get_service_detail.service_branch_id)>
	<cfquery name="GET_BRANCH" datasource="#DSN#">
		SELECT
			BRANCH_STATUS,
			BRANCH_ID,
			BRANCH_NAME,
			BRANCH_CITY
		FROM
			BRANCH 
		WHERE
			BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_service_detail.service_branch_id#">
		ORDER BY
			BRANCH_NAME
	</cfquery>
</cfif>
<cfquery name="GET_SERVICE_APPCAT" datasource="#DSN#">
	SELECT 
		SERVICECAT, 
		SERVICECAT_ID 
	FROM 
		G_SERVICE_APPCAT 
	WHERE 
		SERVICECAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_service_detail.servicecat_id#"> 
	ORDER BY 
		SERVICECAT
</cfquery>
<cfquery name="GET_SERVICE_APPCAT_SUB" datasource="#DSN#">
	SELECT 
		SERVICE_SUB_CAT_ID,
		SERVICE_SUB_CAT,
		SERVICECAT_ID 
	FROM 
		G_SERVICE_APPCAT_SUB 
	ORDER BY 
		SERVICE_SUB_CAT
</cfquery>
<cfquery name="GET_SERVICE_APPCAT_SUB_STATUS" datasource="#DSN#">
	SELECT SERVICE_SUB_STATUS_ID,SERVICE_SUB_CAT_ID,SERVICE_SUB_STATUS FROM G_SERVICE_APPCAT_SUB_STATUS ORDER BY SERVICE_SUB_STATUS
</cfquery>
<cfquery name="GET_SERVICE_APP_ROWS" datasource="#DSN#">
	SELECT SERVICE_SUB_STATUS_ID FROM G_SERVICE_APP_ROWS WHERE SERVICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.service_id#">
</cfquery>
<cfset app_rows = valuelist(get_service_app_rows.service_sub_status_id,',')>
<cfset service_id=get_service_detail.service_id>
<cfscript>
	attributes.company_id=get_service_detail.service_company_id;
	attributes.partner_id=get_service_detail.service_partner_id;
	attributes.consumer_id=get_service_detail.service_consumer_id;
	attributes.employee_id = get_service_detail.service_employee_id;
</cfscript>


<cfif len(get_service_detail.project_id)>
	<cfquery name="GET_PROJECT" datasource="#DSN#">
		SELECT 
			PROJECT_HEAD
		FROM 
			PRO_PROJECTS
		WHERE
			PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_service_detail.project_id#">
	</cfquery>
</cfif>
<cfif len(get_service_detail.service_status_id)>
	<cfquery name="GET_STAGE" datasource="#DSN#">
		SELECT 
			STAGE
		FROM 
			PROCESS_TYPE_ROWS
		WHERE 	
			PROCESS_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_service_detail.service_status_id#">
	</cfquery>
</cfif>
<cfform name="add_service" method="post" action="#request.self#?fuseaction=objects2.emptypopup_upd_service_call_center">
	<cfoutput>
		<input type="hidden" name="old_app_rows" id="old_app_rows" value="#app_rows#">
		<input type="hidden" name="appcat_id" id="appcat_id" value="#get_service_detail.servicecat_id#">
		<input type="hidden" name="service_id" id="service_id" value="#attributes.service_id#">
		<table align="center" cellpadding="0" cellspacing="0" border="0" style="width:98%; height:35px;">
			<tr>
				<td class="headbold"><cf_get_lang no ='900.Başvuru No'>: <cfoutput>#get_service_detail.service_no#</cfoutput></td>
			</tr>
		</table>
	</cfoutput>
	<table border="0" cellspacing="0" cellpadding="0" align="center" style="width:98%;">
		<tr>
			<td style="vertical-align:top;">
				<table border="0" cellspacing="1" cellpadding="2" class="color-border" style="width:100%;">                
					<tr class="color-row">
						<td style="vertical-align:top;">
							<!--- Başvuru Bilgileri --->
							<table>
								<tr>
									<cfif len(get_service_detail.ref_no)>
                                        <td class="txtbold"><cf_get_lang_main no='1382.Referans No'></td>
                                        <td><cfoutput>#get_service_detail.ref_no#</cfoutput></td>
                                    </cfif>
                                    <td class="txtbold"><cf_get_lang_main no='344.Durum'></td>
									<td>
										<cfif get_service_detail.service_active eq 1>
                                        	<cf_get_lang_main no ='81.Aktif'>
                                        <cfelse>
                                        	<cf_get_lang_main no ='82.Pasif'>
                                        </cfif>
									</td>
								</tr>
								<tr>
									<td class="txtbold"><cf_get_lang_main no='1717.Başvuru Yapan'> </td>
									<td colspan="3">
										<cfoutput>#get_service_detail.applicator_name#</cfoutput>
									</td>
								</tr>
								<cfif len(get_service_detail.service_branch_id)>
                                    <tr>
                                        <td class="txtbold"><cf_get_lang_main no='41.Şube'> </td>
                                        <td colspan="3"><cfoutput>#get_branch.branch_name#</cfoutput></td>
                                    </tr>
                                </cfif>
								<tr>
									<td class="txtbold"><cf_get_lang_main no ='73.Öncelik'></td>
									<td><cfif len (get_service_detail.priority_id)><cfoutput>#get_priority.priority#</cfoutput></cfif></td>
									<td class="txtbold" style="width:90px;"><cf_get_lang no ='468.Başvuru Tarihi'></td>
									<td style="width:150px;"><cfoutput>#dateformat(get_service_detail.apply_date,'dd/mm/yyyy')#,#timeformat(date_add('h',session_base.time_zone,get_service_detail.apply_date),'HH:MM')#</cfoutput></td>
								</tr>
								<tr>
									<td class="txtbold"><cf_get_lang_main no='74.Kategori'></td>
									<td><cfoutput>#get_service_appcat.servicecat#</cfoutput></td>
									<td class="txtbold"><cf_get_lang no ='605.Kabul Tarihi'></td>
									<td><cfoutput>#dateformat(get_service_detail.start_date,'dd/mm/yyyy')#</cfoutput></td>
								</tr>
								<tr>
									<td class="txtbold"><cf_get_lang_main no='70.Aşama'></td>
									<td><cfif len(get_service_detail.service_status_id)><cfoutput>#get_stage.stage#</cfoutput></cfif></td>
									<td class="txtbold"><cf_get_lang_main no ='288.Bitiş Tarihi'></td>
									<td><cfoutput>#dateformat(get_service_detail.finish_date,'dd/mm/yyyy')#</cfoutput></td>
								</tr>
								<tr>                        
									<td class="txtbold"><cf_get_lang_main no='731.İletişim'></td>
									<td><cfif len(get_service_detail.commethod_id)><cfoutput>#get_com_method.commethod#</cfoutput></cfif></td>
									<cfif len( get_service_detail.project_id )>
                                        <td class="txtbold"><cf_get_lang_main no= '4.Proje'></td>
                                        <td><cfoutput>#get_project.project_head#</cfoutput></td>
                                    </cfif>
								</tr>
								<tr>
									<td class="txtbold"><cf_get_lang_main no ='68.Konu'></td>
									<td colspan="3"><cfoutput>#get_service_detail.service_head#</cfoutput></td>
								</tr>
								<tr>
									<td valign="top" class="txtbold"><cf_get_lang_main no ='217.Açıklama'></td>
									<td colspan="3">
										<cfif isdefined('attributes.is_history_add') and attributes.is_history_add eq 1>
											<cfquery name="GET_HISTORY_DETAIL" datasource="#DSN#" maxrows="1">
												SELECT SERVICE_DETAIL FROM G_SERVICE_HISTORY WHERE SERVICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.service_id#"> ORDER BY SERVICE_HISTORY_ID ASC
											</cfquery>
											<cfoutput>#get_history_detail.service_detail#</cfoutput>
										<cfelse>
											<cfoutput>#get_service_detail.service_detail#</cfoutput>
										</cfif>
									</td>
								</tr>
								<tr>
									<td colspan="2"></td>
									<cfif len(get_service_detail.record_par) and get_service_detail.record_par eq session.pp.userid>
										<td colspan="2" align="right" style="text-align:right;">
											<cf_workcube_buttons is_upd='1' is_delete='0'>&nbsp;&nbsp;&nbsp;
										</td>
									</cfif>
								</tr>
							</table>
						</td>
						<td style="vertical-align:top;">
							<cfoutput query="GET_SERVICE_APPCAT" group="servicecat_id">
                                <cfquery name="GET_SERVICE_APPCAT_SUB_ORD" dbtype="query">
                                    SELECT SERVICE_SUB_CAT_ID,SERVICE_SUB_CAT,SERVICECAT_ID FROM GET_SERVICE_APPCAT_SUB WHERE SERVICECAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_service_appcat.servicecat_id#">
                                </cfquery>
                                <table>
                                    <tr class="color-header">
                                        <td class="form-title" colspan="3" style="width:250px;">&nbsp;#servicecat#</td>
                                    </tr>
                                    <cfloop query="GET_SERVICE_APPCAT_SUB_ORD">
                                        <cfquery name="GET_SERVICE_APPCAT_SUB_STATUS_ORD" dbtype="query">
                                            SELECT SERVICE_SUB_STATUS_ID,SERVICE_SUB_CAT_ID,SERVICE_SUB_STATUS FROM GET_SERVICE_APPCAT_SUB_STATUS WHERE SERVICE_SUB_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_service_appcat_sub_ord.service_sub_cat_id#">
                                        </cfquery>
                                        <tr class="color-list">
                                            <td class="txtbold" style="width:90px;">#service_sub_cat#</td>
                                            <td class="color-row">
												<cfif len(get_service_detail.record_par) and get_service_detail.record_par eq session.pp.userid>
                                                    <select name="service_sub_cat_id_#service_sub_cat_id#" id="service_sub_cat_id_#service_sub_cat_id#" style="width:150px;">
                                                <cfelse>
                                                    <select name="service_sub_cat_id_#service_sub_cat_id#" id="service_sub_cat_id_#service_sub_cat_id#" style="width:150px;" disabled="disabled">
                                                </cfif>
                                                <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                                    <cfloop query="get_service_appcat_sub_status_ord">
                                                        <option value="#service_sub_status_id#" <cfif listfindnocase(app_rows,service_sub_status_id,',')>selected</cfif>>#service_sub_status#</option>
                                                    </cfloop>
                                                </select>
                                            </td>
                                        </tr>	
                                    </cfloop>
                                </table>
							</cfoutput>
						</td>
					</tr>
				</table>
				<br/>
				<cfquery name="GET_SERVICE_PLUS" datasource="#DSN#">
						SELECT 
							RECORD_EMP,							
							RECORD_DATE,
							PLUS_CONTENT
						FROM 
							G_SERVICE_PLUS
						WHERE   
							SERVICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.id#">
						<cfif isDefined("attributes.service_plus_id")>
							AND SERVICE_PLUS_ID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.service_plus_id#">
						</cfif>	
				</cfquery>
				<table cellspacing="1" cellpadding="2" border="0" class="color-border" style="width:100%;">
					<tr class="color-header">
						<td class="form-title">
							<a href="javascript://" onclick="gizle_goster(orderp_img12,orderp_img22,list_offers_take_menu2);"><img src="/images/listele_down.gif" title="Gizle" width="12" height="7" border="0" align="absmiddle" id="orderp_img12" style="cursor:pointer;"></a>
							<a href="javascript://" onclick="gizle_goster(orderp_img12,orderp_img22,list_offers_take_menu2);"><img src="/images/listele.gif" title="Göster" width="7" height="12" border="0" align="absmiddle" id="orderp_img22" style="display:none;cursor:pointer;"></a><cf_get_lang no='608.Takipler'>
						</td>
					</tr>
					<tr id="list_offers_take_menu2" style="height:20px;">
						<td colspan="2" class="color-row">		
							<table border="0" cellpadding="0" cellspacing="0" style="width:100%;">
								<cfif get_service_plus.recordcount>
									<cfoutput query="get_service_plus">
                                        <tr class="color-row" style="height:20px;">
                                            <td>
												<cfif currentrow neq 1><br/></cfif>
                                                &nbsp;#plus_content#<br/>
                                                <b><cf_get_lang_main no='71.Kayıt'></b>:  
                                                <cfif (isdefined("attributes.is_record_emp") and attributes.is_record_emp eq 1) or not(isdefined("attributes.is_record_emp"))>
                                                    #get_emp_info(record_emp,0,0)# - 
                                                </cfif>
                                                #Dateformat(record_date,'dd/mm/yyyy')# #TimeFormat(date_add('h',session_base.time_zone,record_date),'HH:MM')# 
                                            </td>
                                        </tr>
                                        <tr>
                                            <td><hr style="height:0.1px;" /></td>
                                        </tr>
                                    </cfoutput>
                                <cfelse>
                                	<tr class="color-row" style="height:20px;">
                                        <td><cf_get_lang_main no='72.Kayıt Yok'>!</td>
                                    </tr>
                                </cfif>
							</table>
						</td>
					</tr>
				</table>    
			</td>
		</tr>
	</table>
</cfform>

<script type="text/javascript">
	function substatus()
	{
		document.getElementById('service_substatus_id').value = document.getElementById('service_status_id').value;
	}
	function servistarihi()
	{
		var send_address = "<cfoutput>#request.self#?fuseaction=call.popup_ajax_service_history&service_id=#attributes.service_id#</cfoutput>";
		AjaxPageLoad(send_address,'show_history_info',1,'Servis Tarihleri');
	}
	function servisrelated()
	{
		var send_address = "<cfoutput>#request.self#?fuseaction=call.popup_ajax_service_related&SERVICE_ID=#attributes.service_id#&company_id=#get_service_detail.service_company_id#&consumer_id=#get_service_detail.service_consumer_id#</cfoutput>";
		AjaxPageLoad(send_address,'show_related_services',1,'Önceki Başvurular');
	}
</script>
