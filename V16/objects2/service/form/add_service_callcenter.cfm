<cfinclude template="../../login/send_login.cfm">
<cfif not isdefined("session_base.userid")><cfexit method="exittemplate"></cfif>
<cfquery name="GET_PRIORITY" datasource="#DSN#">
	SELECT 
		PRIORITY_ID, 
		PRIORITY 
	FROM 
		SETUP_PRIORITY 
	ORDER BY 
		PRIORITY
</cfquery>

<cfquery name="GET_SERVICE_APPCAT" datasource="#DSN#">
	SELECT 
		SERVICECAT_ID, 
		SERVICECAT 
	FROM 
		G_SERVICE_APPCAT 
	WHERE 
		IS_INTERNET = 1 
	ORDER BY 
		SERVICECAT
</cfquery>
<cfquery name="GET_ALL_PRE_ORDER_ROWS" datasource="#DSN3#">
	SELECT 
		TO_CONS,
		TO_PAR,
		TO_COMP
	FROM
		ORDER_PRE_ROWS
	WHERE
		<cfif isdefined("session.pp")>
			RECORD_PAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#"> AND
		<cfelseif isdefined("session.ww.userid")>
			RECORD_CONS = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#"> AND
		<cfelseif isdefined("session.ep.userid")>
			RECORD_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"> AND
		<cfelse>
			1=2 AND
		</cfif>
		STOCK_ID IS NOT NULL
</cfquery>
<cfscript>
	if(get_all_pre_order_rows.recordcount gt 0)
	{
		basket_express_cons_list=listsort(listdeleteduplicates(valuelist(get_all_pre_order_rows.TO_CONS)),'numeric','asc');
		basket_express_partner_list=listsort(listdeleteduplicates(valuelist(get_all_pre_order_rows.TO_PAR)),'numeric','asc');
		basket_express_comp_list=listsort(listdeleteduplicates(valuelist(get_all_pre_order_rows.TO_COMP)),'numeric','asc');
	}
	else
	{
		basket_express_cons_list='';
		basket_express_partner_list='';
		basket_express_comp_list='';
	}
	if(len(basket_express_cons_list))
	{
		attributes.consumer_id=listfirst(basket_express_cons_list);
	}
	else if(len(basket_express_partner_list) and len(basket_express_comp_list))
	{
		attributes.partner_id=listfirst(basket_express_partner_list);
		attributes.company_id=listfirst(basket_express_comp_list);
	}
	else if(isdefined("session.pp.userid"))
	{
		attributes.partner_id=session.pp.userid;
		attributes.company_id=session.pp.company_id;
	}
	else if(isdefined("session.ww.userid") )
		attributes.consumer_id=session.ww.userid;
	
	if(isdefined("session.ww"))
		session.ww.basket_cons_id = attributes.consumer_id;
</cfscript>
<cfif isdefined("session.ww.userid") or (isdefined("attributes.consumer_id") and len(attributes.consumer_id))>
	<cfquery name="GET_BLOCK_INFO" datasource="#DSN#">
		SELECT 
			BG.BLOCK_GROUP_PERMISSIONS AS BLOCK_STATUS
		FROM 
			COMPANY_BLOCK_REQUEST CBL,
			BLOCK_GROUP BG 
		WHERE 
			CBL.BLOCK_GROUP_ID = BG.BLOCK_GROUP_ID AND 
			CBL.BLOCK_START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> AND
			ISNULL(CBL.BLOCK_FINISH_DATE,GETDATE()) >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> AND
			<cfif isdefined("session.ww.userid")>
                CBL.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#">
            <cfelse>
                CBL.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
            </cfif>
	</cfquery>
	<cfquery name="GET_REF_MEMBERS" datasource="#DSN#">
		SELECT 
			CONSUMER_ID 
		FROM 
			CONSUMER 
		WHERE 
			<cfif isdefined("session.ww.userid")>
                REF_POS_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#">
            <cfelse>
                REF_POS_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
            </cfif>
	</cfquery>
<cfelse>
	<cfset get_block_info.recordcount = 0>
</cfif>

<cfif isdefined('attributes.is_alt_tree_cat') and (attributes.is_alt_tree_cat eq 1 or attributes.is_alt_tree_cat eq 2)>
    <cfquery name="GET_SERVICE_APPCAT_SUB" datasource="#DSN#">
        SELECT SERVICE_SUB_CAT_ID,SERVICE_SUB_CAT,SERVICECAT_ID FROM G_SERVICE_APPCAT_SUB ORDER BY SERVICE_SUB_CAT
    </cfquery>
    <cfquery name="GET_SERVICE_APPCAT_SUB_STATUS" datasource="#DSN#">
        SELECT SERVICE_SUB_CAT_ID,SERVICE_SUB_STATUS_ID,SERVICE_SUB_STATUS, SERVICE_EXPLAIN,IS_STATUS FROM G_SERVICE_APPCAT_SUB_STATUS ORDER BY SERVICE_SUB_STATUS
    </cfquery>
</cfif>

<table cellspacing="0" cellpadding="0" border="0" align="center" style="width:98%;">
	<tr>
		<td>
			<cfform name="add_service_callcenter" method="post" action="#request.self#?fuseaction=objects2.emptypopup_add_service_call">
                <input type="hidden" name="is_alt_tree_cat" id="is_alt_tree_cat" value="<cfif isdefined('attributes.is_alt_tree_cat') and attributes.is_alt_tree_cat eq 2>2<cfelseif isdefined('attributes.is_alt_tree_cat') and attributes.is_alt_tree_cat eq 1>1<cfelse>0</cfif>" />
                <input type="hidden" name="is_callcenter_process" id="is_callcenter_process" value="<cfif isdefined('attributes.is_callcenter_process') and attributes.is_callcenter_process eq 1>1<cfelse>0</cfif>">
                <input type="hidden" name="ref_no" id="ref_no" value="<cfif isdefined('attributes.order_no') and len(attributes.order_no)><cfoutput>#attributes.order_no#</cfoutput></cfif>" />
                <input type="hidden" name="servis_call_type" id="servis_call_type" value="<cfif attributes.fuseaction contains 'popup'>1</cfif>">
                <input type="hidden" name="commethod_id" id="commethod_id" value="<cfif isdefined('attributes.commethod_id') and len(attributes.commethod_id)><cfoutput>#attributes.commethod_id#</cfoutput><cfelse>1</cfif>">
                <input type="hidden" name="temp_service_sub_cat_id" id="temp_service_sub_cat_id" value="">
                <table cellspacing="1" cellpadding="2" border="0" style="width:100%;">               
                    <tr>
          				<td style="width:40%; vertical-align:top;">
							<!-- Başvuru Bilgileri -->
							<table> 
								<tr>
									<td style="width:100px;"><cf_get_lang no='40.Başvuru Yapan'> *</td>
									<td>
										<cfif isdefined('attributes.is_callcenter_application') and attributes.is_callcenter_application eq 1>
											<cfif isdefined('attributes.is_reference_app') and attributes.is_reference_app eq 0>
												<input type="hidden" name="consumer_id" id="consumer_id" value="<cfif isdefined("attributes.consumer_id")><cfoutput>#attributes.consumer_id#</cfoutput></cfif>">
												<input type="hidden" name="company_id" id="company_id" value="<cfif isdefined("attributes.company_id")><cfoutput>#attributes.company_id#</cfoutput></cfif>">
												<input type="hidden" name="partner_id" id="partner_id" value="<cfif isdefined("attributes.partner_id")><cfoutput>#attributes.partner_id#</cfoutput></cfif>">								  
												<input type="text" name="member_name" id="member_name" value="<cfif isdefined("attributes.member_name")><cfoutput>#attributes.member_name#</cfoutput></cfif>" style="width:235px;" onfocus="AutoComplete_Create('member_name','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_relation_member_objects2','\'1,2\',0,0,0','CONSUMER_ID,COMPANY_ID,PARTNER_ID','consumer_id,company_id,partner_id','add_service_callcenter','3','250');"  autocomplete="off">
											<cfelseif isdefined('attributes.is_reference_app') and attributes.is_reference_app eq 1>
												<cfquery name="GET_CONS_REF_CODE" datasource="#DSN#">
													SELECT CONSUMER_REFERENCE_CODE,CONSUMER_CAT_ID FROM CONSUMER WHERE CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#">
												</cfquery>
												<cfquery name="GET_CAMP_ID" datasource="#DSN3#">
													SELECT 
														CAMP_ID,
														CAMP_HEAD
													FROM 
														CAMPAIGNS 
													WHERE 
														CAMP_STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> AND
														CAMP_FINISHDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
												</cfquery>
												<cfif get_camp_id.recordcount>
													<cfquery name="GET_LEVEL" datasource="#DSN3#">
														SELECT ISNULL(MAX(PREMIUM_LEVEL),0) AS PRE_LEVEL FROM SETUP_CONSCAT_PREMIUM WHERE CONSCAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_cons_ref_code.consumer_cat_id#"> AND CAMPAIGN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_camp_id.camp_id#">
													</cfquery>
													<cfset ref_count = get_level.pre_level + listlen(get_cons_ref_code.consumer_reference_code,'.')>
												<cfelse>
													<cfset ref_count = 0>
												</cfif>
												<cfquery name="GET_REF_INFO" datasource="#DSN#">
													SELECT 
														CC.IS_REF_ORDER 
													FROM 
														CONSUMER C,
														CONSUMER_CAT CC
													WHERE 
														C.CONSUMER_CAT_ID = CC.CONSCAT_ID AND
														C.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#">                              
												</cfquery>
												<cfif get_ref_info.recordcount and get_ref_info.is_ref_order eq 0>
													: <cfoutput>#get_cons_info(attributes.consumer_id,0,0)#</cfoutput>
													<input type="hidden" name="member_name" id="member_name" <cfif len(basket_express_cons_list) or len(basket_express_partner_list) or get_ref_members.recordcount eq 0>readonly</cfif> value="<cfoutput>#get_cons_info(attributes.consumer_id,0,0)#</cfoutput>">
												<cfelse>
													<input type="hidden" name="consumer_id" id="consumer_id" value="<cfif isdefined('attributes.consumer_id') and len(attributes.consumer_id)><cfoutput>#attributes.consumer_id#</cfoutput></cfif>">
													<input type="hidden" name="company_id" id="company_id" value="<cfif isdefined('attributes.company_id') and len(attributes.company_id)><cfoutput>#attributes.company_id#</cfoutput></cfif>">
													<input type="hidden" name="partner_id" id="partner_id" value="<cfif isdefined('attributes.partner_id') and len(attributes.partner_id)><cfoutput>#attributes.partner_id#</cfoutput></cfif>">
													<input type="text" name="member_name" id="member_name" <cfif len(basket_express_cons_list) or len(basket_express_partner_list) or get_ref_members.recordcount eq 0>readonly</cfif> value="<cfoutput>#get_cons_info(attributes.consumer_id,0,0)#</cfoutput>" <cfif not len(basket_express_cons_list) and not len(basket_express_partner_list) and get_ref_members.recordcount gt 0>onFocus="AutoComplete_Create('member_name','MEMBER_NAME,MEMBER_CODE','MEMBER_NAME,MEMBER_CODE','get_member_objects2','\'2\',<cfif (get_block_info.recordcount and listgetat(get_block_info.block_status,5,',') eq 1) or get_ref_info.recordcount and get_ref_info.is_ref_order eq 0>\'2\'<cfelse>\'0\'</cfif>,\'\',\'2\',\'1\',\'0\',\'<cfoutput>#ref_count#</cfoutput>\'','COMPANY_ID,PARTNER_ID,CONSUMER_ID','company_id,partner_id,consumer_id','add_basket_exp','3','150');"</cfif> style="width:235px;">
												</cfif>
											</cfif>
										<cfelse>
											<cfif isdefined("attributes.company_id") and len(attributes.company_id)>
												<input type="hidden" name="company_id" id="company_id" value="<cfoutput>#attributes.company_id#</cfoutput>">
												<input type="text" name="member_name" id="member_name" style="width:235px;" value="<cfoutput>#get_par_info(attributes.company_id,2,0,0)#</cfoutput>">
											<cfelseif isdefined("attributes.subscription_id") and len(attributes.subscription_id)>
												<cfquery name="GET_SUBSCRIPTION" datasource="#DSN3#">
													SELECT COMPANY_ID,PARTNER_ID,CONSUMER_ID FROM SUBSCRIPTION_CONTRACT WHERE SUBSCRIPTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.subscription_id#">
												</cfquery>
												<cfif len(get_subscription.company_id)>
													<input type="hidden" name="company_id" id="company_id" value="<cfoutput>#get_subscription.company_id#</cfoutput>">
													<input type="hidden" name="partner_id" id="partner_id" value="<cfoutput>#get_subscription.partner_id#</cfoutput>">	
													<input type="text" name="member_name" id="member_name" style="width:235px;" value="<cfoutput>#get_par_info(get_subscription.partner_id,0,-1,0)#</cfoutput>">
												<cfelse>
													<input type="text" name="consumer_id" id="consumer_id" value="<cfoutput>#get_subscription.consumer_id#</cfoutput>">
													<input type="text" name="member_name" id="member_name" style="width:235px;" value="<cfoutput>#get_cons_info(get_subscription.consumer_id,0,0,0)#</cfoutput>">
												</cfif>
											<cfelseif isdefined("session.ww.userid") and len(session.ww.userid)>
												<input type="text" name="member_name" id="member_name" value="<cfoutput>#session.ww.name# #session.ww.surname#</cfoutput>" maxlength="255" style="width:235px;" readonly>
											<cfelseif isdefined("session.pp.userid")>
												<input type="text" name="member_name" id="member_name" value="<cfoutput>#session.pp.name# #session.pp.surname#</cfoutput>" maxlength="255" style="width:235px;" readonly>
											<cfelse>
												<input type="text" name="member_name" id="member_name" value="" maxlength="255" style="width:235px;">
											</cfif>
										</cfif>
									</td>
			  					</tr>
							  	<cfif isdefined('attributes.is_callcenter_process') and attributes.is_callcenter_process eq 1>
									<tr>
										<td><cf_get_lang_main no="1447.Süreç">*</td>
									  	<td><cf_workcube_process is_upd='0' process_cat_width='235' is_detail='0'></td>
								  	</tr>
							  	</cfif>
              					<tr>
									<td><cf_get_lang_main no='74.Kategori'> *</td>
									<td>
										<select name="appcat_id" id="appcat_id" style="width:235px;" <cfif isdefined('attributes.is_alt_tree_cat') and (attributes.is_alt_tree_cat eq 1 or attributes.is_alt_tree_cat eq 2)>onChange="kategori_getir();"</cfif>>
											<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
											<cfoutput query="get_service_appcat">
												<cfif session_base.language neq 'tr'>
                                                    <cfquery name="GET_FOR_G_SERV_CAT" dbtype="query">
                                                        SELECT 
                                                            * 
                                                        FROM 
                                                            GET_ALL_FOR_LANGS 
                                                        WHERE 
                                                            TABLE_NAME = 'G_SERVICE_APPCAT' AND 
                                                            COLUMN_NAME = 'SERVICECAT' AND
                                                            UNIQUE_COLUMN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#servicecat_id#">
                                                    </cfquery>
													<cfif get_for_g_serv_cat.recordcount>
                                                        <option value="#get_for_g_serv_cat.unique_column_id#" <cfif isdefined("attributes.servicecat_id") and attributes.servicecat_id eq get_for_g_serv_cat.unique_column_id>selected</cfif>>#get_for_g_serv_cat.item#</option>
													<cfelse>
                                                        <option value="#servicecat_id#" <cfif isdefined("attributes.servicecat_id") and attributes.servicecat_id eq servicecat_id>selected</cfif>>#servicecat#</option>
													</cfif>
                                                <cfelse>
	                                                <option value="#servicecat_id#" <cfif isdefined("attributes.servicecat_id") and attributes.servicecat_id eq servicecat_id>selected</cfif>>#servicecat#</option>
                                            	</cfif>
											</cfoutput>
									  	</select>						  
									</td>
			  					</tr>
								<cfif isdefined('attributes.is_priority_select') and attributes.is_priority_select eq 1>
									<tr>
										<td><cf_get_lang_main no='73.Öncelik'>*</td>
										<td>
											<select name="priority_id" id="priority_id"  style="width:235px;">
												<cfoutput query="get_priority">
												  <option value="#priority_id#">#priority#</option>
												</cfoutput>
											</select>
										</td>
									</tr>
								<cfelse>
									<input type="hidden" name="priority_id" id="priority_id" value="<cfif isdefined('attributes.priority_id') and len(attributes.priority_id)><cfoutput>#attributes.priority_id#</cfoutput><cfelse>1</cfif>" />
								</cfif>
							  	<cfif isdefined('attributes.is_callcenter_system') and attributes.is_callcenter_system eq 1 and isdefined('session.pp.userid')>
									<tr>
										<td><cf_get_lang_main no='1420.Abone'></td>
										<td>
											<input type="hidden" name="subscription_id" id="subscription_id" value="<cfif isdefined("attributes.subscription_id")><cfoutput>#attributes.subscription_id#</cfoutput></cfif>">
										  	<input type="text" name="subscription_no" id="subscription_no" value="<cfif isdefined("attributes.subs_no")><cfoutput>#attributes.subs_no#</cfoutput></cfif>" readonly style="width:235px;">
										  	<cfset str_subscription_link="field_partner=&field_id=add_service_callcenter.subscription_id&field_no=add_service_callcenter.subscription_no">
										  	<a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects2.popup_list_subscriptions&#str_subscription_link#'</cfoutput>,'list','popup_list_subscriptions');"><img src="/images/plus_list.gif" align="absmiddle" border="0"></a>
										</td>
								  	</tr>
							  	</cfif>
								<cfif isdefined('attributes.is_service_head') and attributes.is_service_head neq 2>
                                    <tr style="height:25px;">
                                        <td><cf_get_lang_main no='68.Konu'></td>
                                        <cfif isdefined('attributes.is_service_head') and attributes.is_service_head eq 1>
                                            <td>
                                                <cfsavecontent variable="message"><cf_get_lang_main no ='647.Başlık girmelisiniz'></cfsavecontent>
                                                <cfinput type="text" name="service_head" id="service_head" value="" maxlength="50" style="width:235px;">
                                            </td>
                                        <cfelse>
                                            <td>
                                                <cfinput type="text" name="service_head" id="service_head" value="Konusuz" maxlength="50" style="width:235px;" readonly>
                                            </td>
                                        </cfif>
                                    </tr>
								<cfelse>
									<cfinput type="hidden" name="service_head" id="service_head" value="Konusuz">
								</cfif>
								<tr>
									<td style="vertical-align:top;"><cf_get_lang_main no='217.Açıklama'></td>
									<td><textarea name="service_detail" id="service_detail" style="width:235px;height:100px;"></textarea></td>
			  					</tr>
		   						<tr>
									<td></td>
									<td><cf_workcube_buttons is_upd='0' add_function='chk_form()'></td>
			  					</tr>
								<cfif isdefined("attributes.is_save")>
									<tr>
										<td colspan="4"><font color="red"><cf_get_lang no='571.Başvuru Kaydınız Başarıyla Alındı Teşekkürler'></font></td>
									</tr>
								</cfif>
							</table>                  
		  				</td>
					  	<cfif isdefined('attributes.is_alt_tree_cat') and (attributes.is_alt_tree_cat eq 1 or attributes.is_alt_tree_cat eq 2)>
							<td style="vertical-align:top;">
								<cfoutput query="get_service_appcat" group="servicecat_id">
									<cfquery name="GET_FOR_G_SERV_CAT" dbtype="query">
                                        SELECT 
                                            * 
                                        FROM 
                                            GET_ALL_FOR_LANGS 
                                        WHERE 
                                            TABLE_NAME = 'G_SERVICE_APPCAT' AND 
                                            COLUMN_NAME = 'SERVICECAT' AND
                                            UNIQUE_COLUMN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#servicecat_id#">
                                    </cfquery>
									<cfquery name="GET_SERVICE_APPCAT_SUB_ORD" dbtype="query">
										SELECT SERVICE_SUB_CAT_ID,SERVICE_SUB_CAT,SERVICECAT_ID FROM GET_SERVICE_APPCAT_SUB WHERE SERVICECAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_service_appcat.servicecat_id#">
									</cfquery>
									<table id="anakategori_#replace(servicecat_id,'-','e','all')#" <cfif isdefined("attributes.servicecat_id") and attributes.servicecat_id eq serviceCAT_ID>style="display:;"<cfelse>style="display:none;"</cfif>>
										<tr class="color-header">
											<td class="form-title" colspan="3" style="width:250px;">
                                            	<cfif get_for_g_serv_cat.recordcount>	
                                            		&nbsp;#get_for_g_serv_cat.item#-#servicecat_id#                                                
                                                <cfelse>	
                                            		&nbsp;#servicecat#-#servicecat_id#
                                            	</cfif>
                                            </td>
										</tr>
										<cfoutput>
											<cfloop query="get_service_appcat_sub_ord">
												<cfquery name="GET_SERVICE_APPCAT_SUB_STATUS_ORD" dbtype="query">
													SELECT SERVICE_SUB_STATUS_ID,SERVICE_SUB_CAT_ID,SERVICE_SUB_STATUS,SERVICE_EXPLAIN  FROM GET_SERVICE_APPCAT_SUB_STATUS WHERE IS_STATUS = 1 AND SERVICE_SUB_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_service_appcat_sub_ord.service_sub_cat_id#">
												</cfquery>
												<tr class="color-list">
													<td class="txtbold" style="width:90px;">
                                                    	<cfif session_base.language neq 'tr'>
                                                            <cfquery name="GET_FOR_G_SERV_CAT_SUB" dbtype="query">
                                                                SELECT 
                                                                    * 
                                                                FROM 
                                                                    GET_ALL_FOR_LANGS 
                                                                WHERE 
                                                                    TABLE_NAME = 'G_SERVICE_APPCAT_SUB' AND 
                                                                    COLUMN_NAME = 'SERVICE_SUB_CAT' AND
                                                                    UNIQUE_COLUMN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#service_sub_cat_id#">
                                                            </cfquery>
                                                            <cfif get_for_g_serv_cat_sub.recordcount>
                                                            	#get_for_g_serv_cat_sub.item#
                                                            <cfelse>
                                                            	#service_sub_cat#
                                                            </cfif>                                                    	
                                                    	<cfelse>
                                                        	#service_sub_cat#
                                                        </cfif>
                                                    </td>
													<td class="color-row">
														<input type="hidden" name="old_appcat_id" id="old_appcat_id" value="<cfif isdefined("get_service_appcat_sub_status_ord.service_sub_status_id")><cfoutput>#get_service_appcat_sub_status_ord.service_sub_status_id#</cfoutput></cfif>">
														<select name="service_sub_cat_id_#service_sub_cat_id#" id="service_sub_cat_id_#service_sub_cat_id#" style="width:150px;"  onchange="chk_list(#service_sub_cat_id#)">
															<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
															<cfloop query="get_service_appcat_sub_status_ord">
                                                            	<cfif session_base.language neq 'tr'>
                                                                    <cfquery name="GET_FOR_G_SERV_CAT_SUB_STATUS" dbtype="query">
                                                                        SELECT 
                                                                            * 
                                                                        FROM 
                                                                            GET_ALL_FOR_LANGS 
                                                                        WHERE 
                                                                            TABLE_NAME = 'G_SERVICE_APPCAT_SUB_STATUS' AND 
                                                                            COLUMN_NAME = 'SERVICE_SUB_STATUS' AND
                                                                            UNIQUE_COLUMN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#service_sub_status_id#">
                                                                    </cfquery>
                                                                    <cfif get_for_g_serv_cat_sub_status.recordcount>
																		<option value="#get_for_g_serv_cat_sub_status.unique_column_id#" <cfif isdefined("attributes.service_id") and listfindnocase(app_rows,get_for_g_serv_cat_sub_status.unique_column_id,',')>selected</cfif>>#get_for_g_serv_cat_sub_status.item#</option>                                                                
																	<cfelse>
																		<option value="#service_sub_status_id#" <cfif isdefined("attributes.service_id") and listfindnocase(app_rows,service_sub_status_id,',')>selected</cfif>>#service_sub_status#</option>                                                                
																	</cfif>
                                                                <cfelse>
																	<option value="#service_sub_status_id#" <cfif isdefined("attributes.service_id") and listfindnocase(app_rows,service_sub_status_id,',')>selected</cfif>>#service_sub_status#</option>
																</cfif>
															</cfloop>
														</select>
													</td>
												</tr>	
											</cfloop>
										</cfoutput>	
									</table>
								</cfoutput>
							</td>
						</cfif>
						<td id="serv_det" style="display:none; color:#FF0000; font-weight:bold; vertical-align:top; width:30%;"></td>
                    </tr>
                </table> 
            </cfform>	
		</td>
  	</tr>
</table>

<br/>
<script type="text/javascript">
	//document.add_service_callcenter.member_name.focus();
	function chk_form()
	{  
		if(document.getElementById('member_name').value== "")
		{
			alert("<cf_get_lang no='44.Başvuru Yapan Girmelisiniz'>");
			return false;
		}
		if(document.getElementById('appcat_id').value== "")
		{
			alert("<cf_get_lang no='572.Servis Kategorisini Seçmelisiniz'>!");
			return false;
		}
		if(document.getElementById('priority_id').value=="")
		{
			alert("<cf_get_lang no='573.Öncelik Kategorisini Seçmelisiniz'>");
			return false;
		}
		
		<cfif isdefined('attributes.is_alt_tree_cat') and attributes.is_alt_tree_cat eq 2>
			var listParam = <cfoutput>'#ValueList(get_service_appcat.servicecat_id,',')#'</cfoutput>;
			var get_serv_cats = wrk_safe_query("obj2_get_serv_appcat",'dsn',0,listParam);	
			var kontrol =0;
			for(i=0;i<get_serv_cats.recordcount;i++)
			{
				if(eval("document.getElementById('service_sub_cat_id_"+get_serv_cats.SERVICE_SUB_CAT_ID[i]+"')").value != '')
				{
					var kontrol = 1;
					break;
				}
				else
					var kontrol = 0;
			}

			if(kontrol == 0)
			{
				alert('Alt Kategori Seçimi Yapınız!');
				return false;
			}
		</cfif>
		
		x = (document.getElementById('service_detail').value.length);
		if ( x < 10 )
		{
			alert ("<cf_get_lang no='574.İşlem Açıklaması En Az 10 Karakter Olmalıdır'>!");
			return false;
		}
		return true;
	}
	function chk_list(ssci)
	{
		<cfif isdefined('attributes.is_multiple_select') and attributes.is_multiple_select eq 0>
			if(document.getElementById('temp_service_sub_cat_id').value != '')
			{
				goster(serv_det);
				var temp_sel = document.getElementById('temp_service_sub_cat_id').value;
				document.getElementById('service_sub_cat_id_'+temp_sel).value="";
			}
			document.getElementById('temp_service_sub_cat_id').value = parseInt(ssci);
			document.getElementById('service_detail').value = '';
		</cfif>

		if(list_getat(document.getElementById('service_sub_cat_id_'+ssci).value,2,',') != "")//list_getat(document.getElementById('service_sub_cat_id_'+ssci).value,2,',')
		{	
			var get_serv_explain = wrk_safe_query("obj2_get_call_subcat_infos",'dsn',0,list_getat(document.getElementById('service_sub_cat_id_'+ssci).value,2,','));
			goster(serv_det);
			if(get_serv_explain.SERVICE_EXPLAIN != undefined)
				serv_det.innerHTML = get_serv_explain.SERVICE_EXPLAIN;
		}
		else
		{
				goster(serv_det);
				serv_det.innerHTML = '';
		}
	}
	

	function kategori_getir()
	{
		<cfif isdefined('attributes.is_multiple_select') and attributes.is_multiple_select eq 0>
			serv_det.innerHTML = '';
		</cfif>
		kategori = document.getElementById('appcat_id').value;
		if(kategori != '')
		{
			var re = new RegExp ('-', 'gi') ;
			var kategori = kategori.replace(re,'e') ;
			<cfoutput query="get_service_appcat">
				gizle(anakategori_#replace(servicecat_id,'-','e','all')#);
			</cfoutput>
				goster(eval('anakategori_'+kategori));
		}
		else
		{
			<cfoutput query="get_service_appcat">
				gizle(anakategori_#replace(servicecat_id,'-','e','all')#);
			</cfoutput>		
		}
	}
</script>
