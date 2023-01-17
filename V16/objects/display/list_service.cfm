<cfparam name="attributes.keyword" default=''>
<cfparam name="attributes.modal_id" default="">
<cfif isdefined("attributes.is_submitted")or (isdefined("attributes.keyword") and len(attributes.keyword))>
	<cfquery name="get_service" datasource="#dsn3#">
			SELECT  
				S.SERVICE_ID,
				S.SERVICE_NO,
				S.SERVICE_HEAD,
				CONVERT(VARCHAR(30), S.APPLY_DATE, 103)+' '+CONVERT(VARCHAR(30), S.APPLY_DATE, 108) APPLY_DATE
				,S.SUBSCRIPTION_ID
				,SC.SUBSCRIPTION_NO
			FROM 
				<cfif isDefined("is_callcenter") and is_callcenter>#dsn_alias#.G_SERVICE S WITH (NOLOCK)<cfelse>SERVICE S WITH (NOLOCK)</cfif>
				LEFT JOIN SUBSCRIPTION_CONTRACT SC ON S.SUBSCRIPTION_ID = SC.SUBSCRIPTION_ID
				LEFT JOIN #DSN_ALIAS#.BRANCH ON BRANCH.BRANCH_ID  =S.SERVICE_BRANCH_ID      
				LEFT JOIN #DSN_ALIAS#.EMPLOYEES ON EMPLOYEES.EMPLOYEE_ID = S.RECORD_MEMBER
				LEFT JOIN #DSN_ALIAS#.COMPANY_PARTNER ON COMPANY_PARTNER.PARTNER_ID = S.RECORD_PAR   
				<cfif not (isDefined("is_callcenter") and is_callcenter)>
					LEFT JOIN #DSN3_ALIAS#.SERVICE_SUBSTATUS ON SERVICE_SUBSTATUS.SERVICE_SUBSTATUS_ID = S.SERVICE_SUBSTATUS_ID
					LEFT JOIN #DSN_ALIAS#.SETUP_CITY ON SETUP_CITY.CITY_ID  =  S.SERVICE_CITY_ID
					LEFT JOIN #DSN_ALIAS#.SETUP_COUNTY ON SETUP_COUNTY.COUNTY_ID = S.SERVICE_COUNTY_ID
				</cfif>
				LEFT JOIN #DSN_ALIAS#.PRO_PROJECTS ON PRO_PROJECTS.PROJECT_ID = S.PROJECT_ID
				,SERVICE_APPCAT WITH (NOLOCK),
				#dsn_alias#.SETUP_PRIORITY AS SP WITH (NOLOCK),
				#dsn_alias#.PROCESS_TYPE_ROWS AS PROCESS_TYPE_ROWS WITH (NOLOCK)
			WHERE 
				S.SERVICECAT_ID = SERVICE_APPCAT.SERVICECAT_ID
				AND SP.PRIORITY_ID = S.PRIORITY_ID
				AND S.SERVICE_STATUS_ID = PROCESS_TYPE_ROWS.PROCESS_ROW_ID
				--S.SERVICE_ID IS NOT NULL
				--AND S.SUBSCRIPTION_ID = SC.SUBSCRIPTION_ID
			<cfif len(attributes.keyword)>
				AND (
					S.SERVICE_DETAIL LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR
					S.SERVICE_HEAD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR
					S.SERVICE_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR
					S.SUBSCRIPTION_ID IN (
												SELECT 
													SUBSCRIPTION_ID
												FROM 
													SUBSCRIPTION_CONTRACT 
												WHERE 
												  SUBSCRIPTION_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
												)
					)
			</cfif>
			<cfif isdefined("attributes.subscription_id") and len(attributes.subscription_id)>
				AND S.SUBSCRIPTION_ID = #attributes.subscription_id#
			</cfif>	
			<cfif isdefined("attributes.company_id") and len(attributes.company_id)>
				AND S.SERVICE_COMPANY_ID = #attributes.company_id#
			</cfif>
			<cfif isDefined("attributes.process_stage") and len(attributes.process_stage)>
				AND S.SERVICE_STATUS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_stage#">
			</cfif>
			<cfif isDefined("attributes.service_cat_id") and len(attributes.service_cat_id)>
				AND S.SERVICECAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.service_cat_id#">
			</cfif>
	</cfquery>
<cfelse>
	<cfset get_service.recordcount=0>
</cfif>
<cfparam name="attributes.page" default='1'>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default="#get_service.recordcount#">
<cfset attributes.startrow = ((attributes.page-1)*attributes.maxrows)+1 >
<cfset url_string = "">
<cfif isdefined("attributes.field_id")>
	<cfset url_string = "#url_string#&field_id=#attributes.field_id#">
</cfif>
<cfif isDefined("attributes.field_subs_id")>
	<cfset url_string = "#url_string#&field_subs_id=#attributes.field_subs_id#">
</cfif>
<cfif isDefined("attributes.field_subs_no")>
	<cfset url_string = "#url_string#&field_subs_no=#attributes.field_subs_no#">
</cfif>
<cfif isdefined("attributes.subscription_id")>
	<cfset url_string = "#url_string#&subscription_id=#attributes.subscription_id#">
</cfif>
<cfif isdefined("attributes.company_id")>
	<cfset url_string = "#url_string#&company_id=#attributes.company_id#">
</cfif>
<cfif isdefined("attributes.process_stage")>
	<cfset url_string = "#url_string#&process_stage=#attributes.process_stage#">
</cfif>
<cfif isdefined("attributes.service_cat_id")>
	<cfset url_string = "#url_string#&service_cat_id=#attributes.service_cat_id#">
</cfif>
<cfif isdefined("attributes.field_no")>
	<cfset url_string = "#url_string#&field_no=#attributes.field_no#">
</cfif>
<cfif isdefined("attributes.is_callcenter")>
	<cfset url_string = "#url_string#&is_callcenter=#attributes.is_callcenter#">
</cfif>
<cfif isdefined("attributes.is_submitted")>
	<cfset url_string = "#url_string#&is_submitted=#attributes.is_submitted#">
</cfif>
<cfif isdefined("attributes.call_money_function")>
	<cfset url_string = "#url_string#&call_money_function=#attributes.call_money_function#">
</cfif>
<cfif isDefined('attributes.call_function') and len(attributes.call_function)>
	<cfset url_string = "#url_string#&call_function=#attributes.call_function#">
</cfif>
<cfif isDefined('attributes.call_function_param') and len(attributes.call_function_param)>
	<cfset url_string = "#url_string#&call_function_param=#attributes.call_function_param#">
</cfif>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cfsavecontent  variable="ser_bas"><cf_get_lang dictionary_id='30039.Servis Başvuruları'></cfsavecontent>
	<cfsavecontent  variable="call_bas"><cf_get_lang dictionary_id='58468.Call Center Başvuruları'></cfsavecontent>
	<cfif isDefined("is_callcenter") and is_callcenter><cfset title_ = '#call_bas#'><cfelse><cfset title_ = '#ser_bas#'></cfif>
	<cf_box title="#title_#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
		<cfform name="search_service" method="post" action="#request.self#?fuseaction=objects.popup_list_service&#url_string#">
			<input name="is_submitted" id="is_submitted" type="hidden" value="1">
			<cf_box_search>
				<div class="form-group" id="item-keyword">
					<cfinput type="text" name="keyword" value="#attributes.keyword#" placeholder="#getLang('','Filtre',57460)#" maxlength="50">
				</div>	
				<div class="form-group small">
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,999" message="#getLang('','Kayıt Sayısı Hatalı',57537)#" maxlength="3">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4" search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('search_service' , #attributes.modal_id#)"),DE(""))#">
				</div>
			</cf_box_search>
		</cfform>
		<cf_flat_list>
			<thead>
				<tr>
					<th width="20"><cf_get_lang dictionary_id='57487.No'></th>
					<th><cf_get_lang dictionary_id='32417.Başvuru No'></th>
					<th><cf_get_lang dictionary_id='57742.Tarih'></th>
					<th><cf_get_lang dictionary_id='57480.Konu'></th>
				</tr>
			</thead>
			<tbody>
				<cfif get_service.recordcount>
					<cfoutput query="get_service" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<tr>
							<td>#currentrow#</td>
							<td><a href="javascript://" class="tableyazi" onclick="gonder('#service_id#','#service_no#','#subscription_id#','#subscription_no#');">#service_no#</a></td>
							<td>#dateformat(apply_date,dateformat_style)#</td>
							<td>#service_head#</td>
						</tr>
					</cfoutput>
					<cfelse>
						<tr>
							<td colspan="6" class="color-row"><cfif isdefined("attributes.is_submitted")><cf_get_lang dictionary_id='57484.Kayit Yok'><cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'> !</cfif></td>
						</tr>
				</cfif>
			</tbody>
		</cf_flat_list>
		<cfif attributes.maxrows lt attributes.totalrecords>
			<cfset url_string2=attributes.fuseaction>
			<cfif len(attributes.keyword)>
				<cfset url_string2 = "#url_string2#&keyword=#attributes.keyword#">
			</cfif>
			<cfif len(url_string)>
				<cfset url_string2 = "#url_string2#&#url_string#">
			</cfif>
			<cf_paging 
				page="#attributes.page#"
				maxrows="#attributes.maxrows#"
				totalrecords="#attributes.totalrecords#"
				startrow="#attributes.startrow#"
				adres="#url_string2#"
				isAjax="#iif(isdefined("attributes.draggable"),1,0)#">
		</cfif>
	</cf_box>
</div>
<script type="text/javascript">
document.getElementById('keyword').focus();
function gonder(field_id,field_no,field_subs_id,field_subs_no)
{
	<cfoutput>
		<cfif isDefined("attributes.field_id")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.#attributes.field_id#.value = field_id;
		</cfif>
		<cfif isDefined("attributes.field_no")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.#attributes.field_no#.value = field_no;
		</cfif>
		<cfif isDefined("attributes.field_subs_id")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.#attributes.field_subs_id#.value = field_subs_id;
		</cfif>
		<cfif isDefined("attributes.field_subs_no")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.#attributes.field_subs_no#.value = field_subs_no;
		</cfif>
		<cfif isdefined('attributes.call_function') and isdefined('attributes.call_function_param')>
			<cfif not isdefined("attributes.draggable")>window.opener</cfif>.#attributes.call_function#('#attributes.call_function_param#');
		<cfelseif isdefined("attributes.call_function")>
			<cfif not isdefined("attributes.draggable")>window.opener</cfif>.#call_function#();
		</cfif>
		<cfif isdefined("attributes.call_money_function")>
			try{<cfif not isdefined("attributes.draggable")>window.opener</cfif>.document.#attributes.call_money_function#;}
				catch(e){};
		</cfif>
	</cfoutput>
	<cfif not isdefined("attributes.draggable")>window.close();<cfelse>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );</cfif>
}
</script>
