<cfparam name="attributes.appcat_id" default="">
<cfif isdefined("attributes.start_date") and len(attributes.start_date)>
	<cfparam name="attributes.start_date" default="#attributes.start_date#">
<cfelse>
	<cfparam name="attributes.start_date" default="">
</cfif>
<cfif isdefined("attributes.finish_date") and len(attributes.finish_date)>
	<cfparam name="attributes.finish_date" default="#attributes.finish_date#">
<cfelse>
	<cfparam name="attributes.finish_date" default="">
</cfif>
<cfquery name="GET_SERVICE_APPCAT" datasource="#DSN#">
	SELECT SERVICECAT_ID,SERVICECAT FROM G_SERVICE_APPCAT ORDER BY SERVICECAT
</cfquery>

<cfquery name="GET_MY_APPCAT_SUB_ALL" datasource="#DSN#">
	SELECT SERVICE_SUB_CAT_ID, SERVICE_SUB_CAT, SERVICECAT_ID FROM G_SERVICE_APPCAT_SUB
</cfquery>

<cfquery name="GET_SERVICE_APPCAT_SUB_STATUS_ALL" datasource="#DSN#">
	SELECT SERVICE_SUB_CAT_ID,SERVICE_EXPLAIN, SERVICE_SUB_STATUS_ID, SERVICE_SUB_STATUS FROM G_SERVICE_APPCAT_SUB_STATUS
</cfquery>

<cfif len(attributes.appcat_id)>
	<cfif listlen(attributes.appcat_id,'-') eq 1>
		<cfset attributes.service_cat_id = listgetat(attributes.appcat_id,1,'-')>
        <cfset attributes.service_sub_cat_id = ''>
        <cfset attributes.service_sub_status_id = ''>
	</cfif>
	<cfif listlen(attributes.appcat_id,'-') eq 2>
		<cfset attributes.service_cat_id = listgetat(attributes.appcat_id,1,'-')>
		<cfset attributes.service_sub_cat_id = listgetat(attributes.appcat_id,2,'-')>
        <cfset attributes.service_sub_status_id = ''>
	</cfif>
    <cfif listlen(attributes.appcat_id,'-') eq 3>
		<cfset attributes.service_cat_id = listgetat(attributes.appcat_id,1,'-')>
		<cfset attributes.service_sub_cat_id = listgetat(attributes.appcat_id,2,'-')>
		<cfset attributes.service_sub_status_id = listgetat(attributes.appcat_id,3,'-')>
	</cfif>
</cfif>

<cfif isdefined("attributes.start_date") and len(attributes.start_date)><cf_date tarih="attributes.start_date"></cfif>
<cfif isdefined("attributes.finish_date") and len(attributes.finish_date)><cf_date tarih="attributes.finish_date"></cfif>
<cfif isdefined("attributes.form_submitted")>
	<cfquery name="GET_SERVICE" datasource="#DSN#">
		SELECT
			<cfif isdefined('attributes.is_history_detail') and attributes.is_history_detail eq 1>
				(SELECT TOP 1 SERVICE_DETAIL FROM G_SERVICE_HISTORY WHERE SERVICE_ID = SERVICE.SERVICE_ID ORDER BY SERVICE_HISTORY_ID) SERVICE_DETAIL2,
			</cfif>		
			SERVICE.SERVICE_ID,
			SERVICE.ISREAD,
			SERVICE.SERVICE_COMPANY_ID,
			SERVICE.APPLICATOR_NAME,
			SERVICE.SERVICE_PARTNER_ID,
			SERVICE.SERVICE_CONSUMER_ID,
			SERVICE.SERVICE_EMPLOYEE_ID,
			SERVICE.SERVICE_STATUS_ID,
			SERVICE.SERVICE_NO,
			SERVICE.APPLY_DATE,
			SERVICE.SERVICE_HEAD,
			SERVICE.SERVICE_DETAIL,
			SERVICE.RECORD_MEMBER,
			SERVICE.RECORD_PAR,
			SERVICE.RECORD_CONS,
			SERVICE.SERVICE_BRANCH_ID,
			SERVICE_APPCAT.SERVICECAT,
			SERVICE.SERVICECAT_ID,
			SCM.COMMETHOD,
			SP.PRIORITY,
			SP.COLOR,
			PROCESS_TYPE_ROWS.STAGE
		FROM
			G_SERVICE SERVICE,
			G_SERVICE_APPCAT SERVICE_APPCAT,
			SETUP_COMMETHOD SCM,
			SETUP_PRIORITY SP,
			PROCESS_TYPE_ROWS PROCESS_TYPE_ROWS
		WHERE
			<cfif isdefined('session.pp.our_company_id')>
                SERVICE.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.our_company_id#"> AND
            <cfelseif isdefined('session.ww.our_company_id')>
            	SERVICE.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.our_company_id#"> AND
			</cfif>
			SERVICE.SERVICECAT_ID = SERVICE_APPCAT.SERVICECAT_ID AND
			SCM.COMMETHOD_ID = SERVICE.COMMETHOD_ID AND
			SP.PRIORITY_ID = SERVICE.PRIORITY_ID AND
			SERVICE.SERVICE_STATUS_ID = PROCESS_TYPE_ROWS.PROCESS_ROW_ID AND
			<cfif isDefined("attributes.keyword") and len(attributes.keyword)>
				(
					SERVICE.SERVICE_DETAIL LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR
					SERVICE.SERVICE_HEAD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR
					SERVICE.PRO_SERIAL_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR
					SERVICE.SERVICE_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
				) AND
			</cfif>
			<cfif isdefined("attributes.start_date") and len(attributes.start_date)>
				SERVICE.APPLY_DATE >= #attributes.start_date# AND
			</cfif>
			<cfif isdefined("attributes.finish_date") and len(attributes.finish_date)>
				SERVICE.APPLY_DATE < #attributes.finish_date# AND
			</cfif>
			<cfif isdefined("attributes.subscription_id") and len(attributes.subscription_id) and len(attributes.subscription_no)>
				SERVICE.SUBSCRIPTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.subscription_id#"> AND
			</cfif>
			<cfif isdefined("attributes.process_stage") and len(attributes.process_stage)>
				SERVICE.SERVICE_STATUS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_stage#">  AND
			</cfif>
            <cfif len(attributes.appcat_id) and (len(attributes.service_cat_id) or len(attributes.service_sub_cat_id) or len(attributes.service_sub_status_id))>
                SERVICE.SERVICE_ID IN (
                						SELECT 
                                            SERVICE_ID 
                                        FROM 
                                            G_SERVICE_APP_ROWS 
                                        WHERE 
                                            SERVICE_ID IS NOT NULL 
                                            <cfif listlen(attributes.appcat_id,'-') eq 1>
                                                AND SERVICECAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.service_cat_id#">
                                            </cfif>
                                            <cfif listlen(attributes.appcat_id,'-') eq 2>
                                                AND SERVICE_SUB_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.service_sub_cat_id#">
                                            </cfif>
                                            <cfif listlen(attributes.appcat_id,'-') eq 3>
                                                AND SERVICE_SUB_STATUS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.service_sub_status_id#">
                                            </cfif>
                                        ) AND
            </cfif>
			<cfif isdefined('attributes.company_id') and len(attributes.company_id) and isdefined('attributes.company_name') and len(attributes.company_name)>
				SERVICE.SERVICE_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#"> AND
			</cfif>
            <cfif isdefined('attributes.consumer_id') and len(attributes.consumer_id) and isdefined('attributes.company_name') and len(attributes.company_name)>
				SERVICE.SERVICE_CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#"> AND
			</cfif>
			<cfif isdefined("session.pp.company_id")>
				(
					<cfif isdefined('attributes.is_callcenter_hier') and (attributes.is_callcenter_hier eq 0 or attributes.is_callcenter_hier eq 2)>
                        SERVICE.SERVICE_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.company_id#">
                        <cfif isdefined('attributes.is_callcenter_hier') and attributes.is_callcenter_hier eq 2>OR</cfif>
                    </cfif>
                    <cfif isdefined('attributes.is_callcenter_hier') and (attributes.is_callcenter_hier eq 1 or attributes.is_callcenter_hier eq 2)>
                        SERVICE.SERVICE_COMPANY_ID IN (SELECT COMPANY_ID FROM COMPANY WHERE HIERARCHY_ID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.company_id#">) OR
                        SERVICE.SERVICE_CONSUMER_ID IN (SELECT CONSUMER_ID FROM CONSUMER WHERE HIERARCHY_ID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.company_id#">)
                    </cfif>
                )
			<cfelseif isdefined("session.ww.userid")>
				(
					<cfif isdefined('attributes.is_callcenter_hier') and (attributes.is_callcenter_hier eq 0 or attributes.is_callcenter_hier eq 2)>
                        SERVICE.SERVICE_CONSUMER_ID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#">
                        <cfif isdefined('attributes.is_callcenter_hier') and attributes.is_callcenter_hier eq 2>OR</cfif>
                     </cfif>
                    <!---<cfif isdefined('attributes.is_callcenter_hier') and (attributes.is_callcenter_hier eq 1 or attributes.is_callcenter_hier eq 2)>
                        SERVICE.SERVICE_CONSUMER_ID IN (SELECT CONSUMER_ID FROM CONSUMER WHERE REF_POS_CODE =  <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#">)
                    </cfif>--->
                    <!--- Üst kısımda yer alan partner için olan kod yapısından farklı olarak kaydedeni sorguluyor, çünkü pasife geçmiş ve ayrılmış üyelerinde başvurularının gelmesi sağlanacak --->
                    <cfif isdefined('attributes.is_callcenter_hier') and (attributes.is_callcenter_hier eq 1 or attributes.is_callcenter_hier eq 2)>
                       <!--- SERVICE.RECORD_CONS IN (SELECT CONSUMER_ID FROM CONSUMER WHERE REF_POS_CODE =  <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#">)--->
                        SERVICE.RECORD_CONS = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#">   
                    </cfif>
				)
			<cfelse>
				1 = 0
			</cfif>
		ORDER BY
			SERVICE.RECORD_DATE DESC
	</cfquery>
<cfelse>
  	<cfset get_service.recordcount = 0>
</cfif>

<cfquery name="GET_PROCESS_TYPES" datasource="#DSN#">
	SELECT
		PTR.STAGE,
		PTR.PROCESS_ROW_ID 
	FROM
		PROCESS_TYPE_ROWS PTR,
		PROCESS_TYPE_OUR_COMPANY PTO,
		PROCESS_TYPE PT
	WHERE
		PT.IS_ACTIVE = 1 AND
		PT.PROCESS_ID = PTR.PROCESS_ID AND
		PT.PROCESS_ID = PTO.PROCESS_ID AND
		<cfif isdefined("session.pp")>
			PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.our_company_id#"> AND
		<cfelseif isdefined("session.ww")>
			PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.our_company_id#"> AND
		</cfif>
		PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%call.list_service,%">
	ORDER BY
		PTR.PROCESS_ROW_ID
</cfquery>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.maxrows" default='#session_base.maxrows#'>
<cfparam name="attributes.totalrecords" default="#get_service.recordcount#">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<!-- sil -->
<cfform name="call_center" method="post" action="#request.self#?fuseaction=objects2.list_service_call_center">
	<table cellspacing="0" cellpadding="0" style="width:98%;">
		<input type="hidden" name="form_submitted" id="form_submitted" value="1">
		<tr style="height:35px;"> 
			<td style="text-align:right;"><cf_get_lang_main no='48.Filtre'>
				<cfinput type="text" name="keyword" id="keyword" value="#attributes.keyword#" style="width:80px;">
				<cfif isdefined('attributes.is_callcenter_system') and attributes.is_callcenter_system eq 1>
					<cf_get_lang_main no='1420.Abone'>
					<input type="hidden" name="subscription_id" id="subscription_id" value="<cfif isdefined('attributes.subscription_id') and len(attributes.subscription_id)><cfoutput>#attributes.subscription_id#</cfoutput></cfif>">
					<input type="text" name="subscription_no" id="subscription_no" value="<cfif isdefined('attributes.subscription_no') and len(attributes.subscription_no)><cfoutput>#attributes.subscription_no#</cfoutput></cfif>" style="width:100px;">
					<cfset str_subscription_link="field_partner=&field_id=call_center.subscription_id&field_no=call_center.subscription_no">
					<a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects2.popup_list_subscriptions&#str_subscription_link#'</cfoutput>,'list','popup_list_subscriptions');"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>
                <cfelse>
					<input type="hidden" name="subscription_id" id="subscription_id" value="<cfif isdefined('attributes.subscription_id') and len(attributes.subscription_id)><cfoutput>#attributes.subscription_id#</cfoutput></cfif>">
					<input type="hidden" name="subscription_no" id="subscription_no" value="<cfif isdefined('attributes.subscription_no') and len(attributes.subscription_no)><cfoutput>#attributes.subscription_no#</cfoutput></cfif>" style="width:100px;">
				</cfif>
				<cfif isdefined('attributes.is_callcenter_hier') and (attributes.is_callcenter_hier eq 1 or attributes.is_callcenter_hier eq 2)>
					<cf_get_lang_main no='780.Müşteri'>
					<input type="hidden" name="consumer_id" id="consumer_id" value="<cfif isdefined("attributes.consumer_id")><cfoutput>#attributes.consumer_id#</cfoutput></cfif>">
                    <input type="hidden" name="company_id" id="company_id" value="<cfif isdefined("attributes.company_id")><cfoutput>#attributes.company_id#</cfoutput></cfif>">								  
					<input type="text" name="company_name" id="company_name" value="<cfif isdefined("attributes.company_name")><cfoutput>#attributes.company_name#</cfoutput></cfif>" style="width:130px;" onfocus="AutoComplete_Create('company_name','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_relation_member_objects2','\'1,2\',0,0,0','CONSUMER_ID,COMPANY_ID','consumer_id,company_id','call_center','3','250');" autocomplete="off">
				<cfelse>
					<input type="hidden" name="consumer_id" id="consumer_id" value="<cfif isdefined("attributes.consumer_id")><cfoutput>#attributes.consumer_id#</cfoutput></cfif>">
                    <input type="hidden" name="company_id" id="company_id" value="<cfif isdefined("attributes.company_id")><cfoutput>#attributes.company_id#</cfoutput></cfif>">								  
					<input type="hidden" name="company_name" id="company_name" value="<cfif isdefined("attributes.company_name")><cfoutput>#attributes.company_name#</cfoutput></cfif>" style="width:130px;" onfocus="AutoComplete_Create('company_name','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_relation_member_objects2','\'1,2\',0,0,0','CONSUMER_ID,COMPANY_ID','consumer_id,company_id','call_center','3','250');" autocomplete="off">
				</cfif>
				<cfif isdefined('attributes.is_filter_stage') and attributes.is_filter_stage eq 1>
					<select name="process_stage" id="process_stage" style="width:110px">
						<option value="" selected><cf_get_lang_main no='70.Aşama'></option>
						<cfoutput query="get_process_types">
							<option value="#process_row_id#" <cfif isdefined("attributes.process_stage") and (attributes.process_stage eq process_row_id)>selected</cfif>>#stage#</option>
						</cfoutput>
					</select>
				</cfif>
				<select name="appcat_id" id="appcat_id" style="width:150px;">
                 	<option value=""><cf_get_lang_main no='74.Kategori'></option>
                 	<cfoutput query="get_service_appcat">
                  		<option value="#servicecat_id#" <cfif listlen(attributes.appcat_id,'-') eq 1 and attributes.service_cat_id eq servicecat_id>selected</cfif>>#servicecat#</option>
                    	<cfquery name="GET_MY_APPCAT_SUB" dbtype="query">
							SELECT * FROM GET_MY_APPCAT_SUB_ALL WHERE SERVICECAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#servicecat_id#">
						</cfquery>
						<cfloop query="get_my_appcat_sub">
							<option value="#get_service_appcat.servicecat_id#-#service_sub_cat_id#" <cfif listlen(attributes.appcat_id,'-') eq 2 and attributes.service_sub_cat_id eq service_sub_cat_id>selected</cfif>>&nbsp;&nbsp;#service_sub_cat#</option>
							 <cfquery name="GET_SERVICE_APPCAT_SUB_STATUS" dbtype="query">
								SELECT * FROM GET_SERVICE_APPCAT_SUB_STATUS_ALL WHERE SERVICE_SUB_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_my_appcat_sub.service_sub_cat_id#">
							</cfquery>
							<cfloop query="get_service_appcat_sub_status">
								<option value="#get_service_appcat.servicecat_id#-#service_sub_cat_id#-#service_sub_status_id#" <cfif listlen(attributes.appcat_id,'-') eq 3 and attributes.service_sub_status_id eq service_sub_status_id>selected</cfif>>&nbsp;&nbsp;&nbsp;&nbsp;#service_sub_status#</option>
							</cfloop>
						</cfloop>
                	</cfoutput>
              	</select>
				<cfinput type="text" name="start_date" id="start_date" maxlength="10" value="#dateformat(attributes.start_date,"dd/mm/yyyy")#" style="width:65px;" validate="eurodate">
				<cf_wrk_date_image date_field="start_date">
				<cfinput type="text" name="finish_date" id="finish_date" maxlength="10" value="#dateformat(attributes.finish_date,"dd/mm/yyyy")#" style="width:65px;" validate="eurodate">
				<cf_wrk_date_image date_field="finish_date">
				<cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
				<cfinput type="text" name="maxrows" id="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
				<cf_wrk_search_button>
			</td>
		</tr>
	</table>
</cfform>
<!-- sil -->
<table cellspacing="1" cellpadding="1" align="center" class="color-border" style="width:98%;">
	<!-- sil -->
	<tr class="color-header" style="height:20px;">
		<td class="form-title" style="width:8%;"><cf_get_lang_main no='75.No'></td>
		<td class="form-title" style="width:10%;"><cf_get_lang_main no ='330.Tarih'></td>
		<td class="form-title" style="width:10%;"><cf_get_lang no='82.İleten'></td>
		<td class="form-title" style="width:20%;"><cf_get_lang_main no='1717.Başvuru Yapan'></td>
		<td class="form-title" style="width:10%;"><cf_get_lang no='1508.Üye Kodu'></td>
		<cfif isdefined('attributes.is_service_head') and attributes.is_service_head eq 1>
			<td class="form-title"><cf_get_lang_main no='68.Konu'></td>
		</cfif>
		<td class="form-title" style="width:10%;"><cf_get_lang_main no='74.Kategori'></td>
		<cfif isdefined('attributes.is_sub_cat') and attributes.is_sub_cat eq 1>
			<td class="form-title" style="width:12%;"><cf_get_lang no='1639.Alt Kategori'></td>
		</cfif>
		<cfif isdefined('attributes.is_filter_stage') and attributes.is_filter_stage eq 1>
			<td class="form-title" style="width:8%;"><cf_get_lang_main no='70.Aşama'></td> 
		</cfif>
		<td class="form-title" style="width:10%;"><cf_get_lang_main no ='217.Açıklama'></td>
	</tr>
	<cfif get_service.recordcount>
		<cfset partner_id_list = "">
		<cfset consumer_id_list = "">
		<cfset employee_id_list = "">
		<cfset company_id_list = "">
		<cfoutput query="get_service" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
			<cfif len(service_partner_id) and not listfind(partner_id_list,service_partner_id)>
				<cfset partner_id_list=listappend(partner_id_list,service_partner_id)>
			</cfif>
			<cfif len(service_company_id) and not listfind(company_id_list,service_company_id)>
				<cfset company_id_list=listappend(company_id_list,service_company_id)>
			</cfif>
			<cfif len(service_consumer_id) and not listfind(consumer_id_list,service_consumer_id)>
				<cfset consumer_id_list=listappend(consumer_id_list,service_consumer_id)>
			</cfif>
			<cfif len(record_cons) and not listfind(consumer_id_list,record_cons)>
				<cfset consumer_id_list=listappend(consumer_id_list,record_cons)>
			</cfif>			
			<cfif len(service_employee_id) and not listfind(employee_id_list,service_employee_id)>
				<cfset employee_id_list=listappend(employee_id_list,service_employee_id)>
			</cfif>
	  	</cfoutput>
	  	<cfif len(partner_id_list)>
			<cfset partner_id_list=listsort(partner_id_list,"numeric","ASC",",")>
			<cfquery name="GET_PARTNER_DETAIL" datasource="#DSN#">
				SELECT COMPANY_PARTNER_NAME,COMPANY_PARTNER_SURNAME,PARTNER_ID FROM COMPANY_PARTNER WHERE PARTNER_ID IN (#partner_id_list#) ORDER BY PARTNER_ID
			</cfquery>
			<cfset partner_id_list = valuelist(get_partner_detail.partner_id,',')>
	  	</cfif>
	   	<cfif len(company_id_list)>
			<cfset company_id_list=listsort(company_id_list,"numeric","ASC",",")>
			<cfquery name="GET_COMPANY_DETAIL" datasource="#DSN#">
				SELECT FULLNAME,COMPANY_ID, MEMBER_CODE FROM COMPANY WHERE COMPANY_ID IN (#company_id_list#)
			</cfquery>
			<cfset company_id_list = valuelist(get_company_detail.company_id,',')>
	  	</cfif>
	  	<cfif len(consumer_id_list)>
			<cfset consumer_id_list=listsort(consumer_id_list,"numeric","ASC",",")>
			<cfquery name="GET_CONSUMER_DETAIL" datasource="#DSN#">
				SELECT CONSUMER_NAME,CONSUMER_SURNAME,CONSUMER_ID, MEMBER_CODE FROM CONSUMER WHERE CONSUMER_ID IN (#consumer_id_list#) ORDER BY CONSUMER_ID
			</cfquery>
			<cfset consumer_id_list = valuelist(get_consumer_detail.consumer_id,',')>
	  	</cfif>
	  	<cfif len(employee_id_list)>
			<cfset employee_id_list=listsort(employee_id_list,"numeric","ASC",",")>
			<cfquery name="GET_EMPLOYEE_DETAIL" datasource="#DSN#">
				SELECT EMPLOYEE_NAME,EMPLOYEE_SURNAME,EMPLOYEE_ID FROM EMPLOYEES WHERE EMPLOYEE_ID IN(#employee_id_list#)
			</cfquery>
			<cfset employee_id_list = valuelist(get_branch.branch_id,',')>
	  	</cfif>
		<cfoutput query="get_service" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
			<tr onmouseover="this.className='color-light';" onmouseout="this.className='color-row';" class="color-row" style="height:20px;">
				<td><a href="#request.self#?fuseaction=objects2.upd_service_call_center&service_id=#service_id#" class="tableyazi">#service_no#</a></td>
				<td><cfif len(apply_date)>#dateformat(apply_date,'dd/mm/yyyy')#,#timeformat(date_add('h',session_base.time_zone,APPLY_DATE),'HH:MM')#</cfif></td>  
				<td>
					<cfif len(get_service.record_cons)>#get_consumer_detail.consumer_name[listfind(consumer_id_list,get_service.record_cons,',')]# #get_consumer_detail.consumer_surname[listfind(consumer_id_list,get_service.record_cons,',')]#</cfif>
				</td>            
				<td>
					<cfif len(get_service.service_company_id) and (get_service.service_company_id neq 0)>
						<a href="#request.self#?fuseaction=objects2.upd_my_member&company_id=#service_company_id#" class="tableyazi">
							#get_company_detail.fullname[listfind(company_id_list,service_company_id,',')]#
						</a>
						<cfif len(get_service.service_partner_id) and (get_service.service_partner_id neq 0) and not len(get_service.applicator_name)>
							-<a href="javascript://"  onclick="windowopen('#request.self#?fuseaction=objects2.popup_par_det&par_id=#service_partner_id#','medium');" class="tableyazi">
								#get_partner_detail_row.company_partner_name[listfind(partner_id_list,service_partner_id,',')]# #get_partner_detail_row.company_partner_surname[listfind(partner_id_list,service_partner_id,',')]#
							</a>
						<cfelseif len(get_service.applicator_name)>
							- #get_service.applicator_name#
						</cfif>
					<cfelseif len(get_service.service_consumer_id) and  (get_service.service_consumer_id neq 0)>
						#get_consumer_detail.consumer_name[listfind(consumer_id_list,service_consumer_id,',')]# #get_consumer_detail.consumer_surname[listfind(consumer_id_list,service_consumer_id,',')]#
					<cfelseif len(get_service.service_employee_id) and (get_service.service_employee_id neq 0)>
						#get_employee_detail.employee_name[listfind(employee_id_list,service_employee_id,',')]# #get_employee_detail.employee_surname[listfind(employee_id_list,service_employee_id,',')]#
					</cfif>
				</td>
				<td>
					<cfif len(get_service.service_company_id)>
						#get_company_detail.member_code[listfind(company_id_list,get_service.service_company_id,',')]# 
					<cfelseif len(get_service.service_consumer_id)>
						#get_consumer_detail.member_code[listfind(consumer_id_list,get_service.service_consumer_id,',')]# 
					</cfif>
				</td>
				<cfif isdefined('attributes.is_service_head') and attributes.is_service_head eq 1>
					<td>#service_head#</td>
				</cfif>
				<td>#servicecat#</td>
				<td>
					<cfquery name="GET_APP_ROWS" datasource="#DSN#">
						SELECT SERVICE_SUB_STATUS_ID FROM G_SERVICE_APP_ROWS WHERE SERVICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#service_id#">
					</cfquery>
					<cfif get_app_rows.recordcount>
						<cfquery name="GET_SERVICE_APP_ROW" dbtype="query">
							SELECT 
								GET_SERVICE_APPCAT_SUB_STATUS_ALL.SERVICE_SUB_STATUS
							FROM 
								GET_APP_ROWS,
								GET_SERVICE_APPCAT_SUB_STATUS_ALL
							WHERE
								GET_APP_ROWS.SERVICE_SUB_STATUS_ID = GET_SERVICE_APPCAT_SUB_STATUS_ALL.SERVICE_SUB_STATUS_ID
						</cfquery>
						<cfloop query="get_service_app_row">#service_sub_status#<cfif currentrow neq get_service_app_row.recordcount>,<br/></cfif></cfloop>
					</cfif>
				</td>
				<cfif isdefined('attributes.is_filter_stage') and attributes.is_filter_stage eq 1>
					<td>#stage#</td>
				</cfif>
				<td><cfif isdefined('attributes.is_history_detail') and attributes.is_history_detail eq 1>#left(service_detail2,20)#<cfelse>#left(service_detail,20)#</cfif></td>
			</tr>
		</cfoutput>
	<cfelse>
		<tr class="color-row" style="height:20px;">
			<td colspan="12"><cfif isdefined("attributes.form_submitted") and attributes.form_submitted eq 1><cf_get_lang_main no='72.Kayıt Yok'>!<cfelse><cf_get_lang_main no='289.Filtre Ediniz'> !</cfif></td>
		</tr>
	</cfif>
</table>
<cfif attributes.totalrecords gt attributes.maxrows>
	<cfset adres="objects2.list_service_call_center">
	<cfset adres = adres&"&keyword="&attributes.keyword>
	<cfif isDefined('attributes.start_date') and len(attributes.start_date)>
		<cfset adres = adres&"&start_date="&dateformat(attributes.start_date,'dd/mm/yyyy')>
	</cfif>
	<cfif isDefined('attributes.finish_date') and len(attributes.finish_date)>
		<cfset adres = adres&"&finish_date="&dateformat(attributes.finish_date,'dd/mm/yyyy')>
	</cfif>
	<cfif isDefined('attributes.process_stage') and len(attributes.process_stage)>
		<cfset adres = adres&"&process_stage="&attributes.process_stage>
	</cfif>
	<cfif isdefined("attributes.company_id") and len(attributes.company_id) and isdefined("attributes.company_name") and len(attributes.company_name)>
		<cfset adres = "#adres#&company_id=#attributes.company_id#&company_name=#attributes.company_name#">
	</cfif>
	<cfif isdefined("attributes.subscription_id") and len(attributes.subscription_id) and isdefined("attributes.subscription_no") and len(attributes.subscription_no)>
		<cfset adres = "#adres#&subscription_id=#attributes.subscription_id#&subscription_no=#attributes.subscription_no#">
	</cfif>
	<table cellpadding="0" cellspacing="0" border="0" align="center" height="5" style="width:98%;">
		<tr>
			<td>					
				<cf_pages page="#attributes.page#" 
				maxrows="#attributes.maxrows#" 
				totalrecords="#attributes.totalrecords#" 
				startrow="#attributes.startrow#" 
				adres="#adres#&form_submitted=1"> 
			</td>
			 <!-- sil --> 
			<td align="right" style="text-align:right;"> <cfoutput> <cf_get_lang_main no='128.Toplam Kayıt'>:#get_service.recordcount# - <cf_get_lang_main no='169.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td>
			 <!-- sil --> 
		</tr>
	</table>
</cfif>

