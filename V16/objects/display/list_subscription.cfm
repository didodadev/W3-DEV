<cf_xml_page_edit fuseact="objects.popup_list_subscription">
<cfparam name="attributes.keyword" default=''>
<cfparam name="attributes.subscription_status" default='1'>
 
<cfif isdefined("attributes.is_submitted") or (isdefined("attributes.keyword") and len(attributes.keyword))>
	<cfinclude template="../query/get_subscription.cfm">
<cfelse>
	<cfset get_subscriptions.recordcount=0>
</cfif>

<cfparam name="attributes.page" default='1'>
<cfparam name="attributes.modal_id" default="">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default="#get_subscriptions.recordcount#">
<cfset attributes.startrow = ((attributes.page-1)*attributes.maxrows)+1 >
<cfset url_string = "">
<cfif isdefined("attributes.is_submitted")>
	<cfset url_string = "#url_string#&is_submitted=#attributes.is_submitted#">
</cfif>
<cfif isdefined("attributes.field_id")>
	<cfset url_string = "#url_string#&field_id=#attributes.field_id#">
</cfif>
<cfif isdefined("attributes.field_no")>
	<cfset url_string = "#url_string#&field_no=#attributes.field_no#">
</cfif>
<cfif isdefined("attributes.field_head")>
	<cfset url_string = "#url_string#&field_head=#attributes.field_head#">
</cfif>
<cfif isdefined("attributes.field_project_id")>
	<cfset url_string = "#url_string#&field_project_id=#attributes.field_project_id#">
</cfif>
<cfif isdefined("attributes.field_project_name")>
	<cfset url_string = "#url_string#&field_project_name=#attributes.field_project_name#">
</cfif>
<cfif isdefined("attributes.field_member_id")>
	<cfset url_string = "#url_string#&field_member_id=#attributes.field_member_id#">
</cfif>
<cfif isdefined("attributes.field_member_name")>
	<cfset url_string = "#url_string#&field_member_name=#attributes.field_member_name#">
</cfif>
<cfif isdefined("attributes.field_member_type")>
	<cfset url_string = "#url_string#&field_member_type=#attributes.field_member_type#">
</cfif>
<cfif isdefined("attributes.field_company_id")>
	<cfset url_string = "#url_string#&field_company_id=#attributes.field_company_id#">
</cfif>
<cfif isdefined("attributes.field_company_name")>
	<cfset url_string = "#url_string#&field_company_name=#attributes.field_company_name#">
</cfif>
<cfif isdefined("attributes.field_ship_address")>
	<cfset url_string = "#url_string#&field_ship_address=#attributes.field_ship_address#">
</cfif>
<cfif isdefined("attributes.field_ship_city_id")>
	<cfset url_string = "#url_string#&field_ship_city_id=#attributes.field_ship_city_id#">
</cfif>
<cfif isdefined("attributes.field_ship_county_id")>
	<cfset url_string = "#url_string#&field_ship_county_id=#attributes.field_ship_county_id#">
</cfif>
<cfif isdefined("attributes.field_ship_county_name")>
	<cfset url_string = "#url_string#&field_ship_county_name=#attributes.field_ship_county_name#">
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
<cfif isDefined('attributes.satir') and len(attributes.satir)>
	<cfset url_string = "#url_string#&satir=#attributes.satir#">
</cfif>
<cfif isDefined('attributes.draggable') and len(attributes.draggable)>
	<cfset url_string = "#url_string#&draggable=#attributes.draggable#">
</cfif>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box title="#getLang('','Abone',58832)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
		<cf_wrk_alphabet keyword="url_string" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
     	<cfform name="search_subscription" method="post" action="#request.self#?fuseaction=objects.popup_list_subscription&#url_string#">
			<input type="hidden" name="is_submitted" id="is_submitted" value="1">
			<cfif isDefined("attributes.draggable")><input type="hidden" name="draggable" value="1"></cfif>
	   		<cf_box_search more="0">
                <div class="form-group" id="keyword">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57460.Filtre'></cfsavecontent>
					<cfinput type="text" name="keyword" placeholder="#message#" id="keyword" value="#attributes.keyword#" maxlength="50">
                </div>
                <div class="form-group" id="member_name">
					<div class="input-group">
						<cfif isdefined("attributes.satir")>
							<cfinput type="hidden" name="satir" value="#attributes.satir#">
						</cfif>
						<input type="hidden" name="consumer_id" id="consumer_id" value="<cfif isdefined("attributes.consumer_id")><cfoutput>#attributes.consumer_id#</cfoutput></cfif>">	
						<input type="hidden" name="company_id" id="company_id" value="<cfif isdefined("attributes.company_id")><cfoutput>#attributes.company_id#</cfoutput></cfif>">
						<input type="hidden" name="member_type" id="member_type" value="<cfif isdefined("attributes.member_type")><cfoutput>#attributes.member_type#</cfoutput></cfif>">
						<input type="text" name="member_name" placeholder="<cfoutput>#getLang('','Üye',57658)#</cfoutput>"id="member_name" value="<cfif isdefined("attributes.member_name") and len(attributes.member_name)><cfoutput>#attributes.member_name#</cfoutput></cfif>">
						<span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_all_pars&field_consumer=search_subscription.consumer_id&field_comp_id=search_subscription.company_id&field_member_name=search_subscription.member_name&field_type=search_subscription.member_type&select_list=7,8&keyword='+encodeURIComponent(document.search_subscription.member_name.value));"></span>
					</div>
                </div>
                <div class="form-group" id="subscription_status">
					<select name="subscription_status" id="subscription_status">
						<option value="1" <cfif isdefined("attributes.subscription_status") and attributes.subscription_status eq 1>selected</cfif>><cf_get_lang dictionary_id='57493.Aktif'></option>
						<option value="0" <cfif isdefined("attributes.subscription_status") and attributes.subscription_status eq 0>selected</cfif>><cf_get_lang dictionary_id='57494.Pasif'></option>
						<option value="2" <cfif isdefined("attributes.subscription_status") and attributes.subscription_status eq 2>selected</cfif>><cf_get_lang dictionary_id='57708.Tümü'></option>
					</select>
                </div>
                <div class="form-group small">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,999" message="#message#" maxlength="3">
                </div>
                <div class="form-group">
                	<cf_wrk_search_button button_type="4" search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('search_subscription' , #attributes.modal_id#)"),DE(""))#">
                </div>
			</cf_box_search>
		</cfform>
		<cf_flat_list>
			<thead>
				<tr>
					<th><cf_get_lang dictionary_id='29502.Abone No'></th>
					<th><cf_get_lang dictionary_id='58832.Abone'></th>
					<th><cf_get_lang dictionary_id='58233.Tanım'></th>
					<th><cf_get_lang dictionary_id='57482.Asama'></th>
					<th><cf_get_lang dictionary_id='57486.Kategori'></th>
				</tr>
			</thead>
			<tbody>
				<cfif get_subscriptions.recordcount>
					<cfset partner_id_list=''>
					<cfset project_id_list=''>
					<cfset consumer_id_list=''>
					<cfset county_id_list=''>
					<cfoutput query="get_subscriptions" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<cfif len(partner_id) and not listfind(partner_id_list,partner_id)>
							<cfset partner_id_list = Listappend(partner_id_list,partner_id)>
						</cfif>
						<cfif len(consumer_id) and not listfind(consumer_id_list,consumer_id)>
							<cfset consumer_id_list = Listappend(consumer_id_list,consumer_id)>
						</cfif>
						<cfif len(project_id) and not listfind(project_id_list,project_id)>
							<cfset project_id_list = Listappend(project_id_list,project_id)>
						</cfif>
						<cfif len(ship_county_id) and not listfind(county_id_list,ship_county_id)>
							<cfset county_id_list = Listappend(county_id_list,ship_county_id)>
						</cfif>
					</cfoutput>
					<cfif len(partner_id_list)>
						<cfset partner_id_list=listsort(partner_id_list,"numeric","ASC",",")>
						<cfquery name="GET_PARTNER_DETAIL" datasource="#DSN#">
							SELECT
								CP.COMPANY_PARTNER_NAME,
								CP.COMPANY_PARTNER_SURNAME,
								CP.PARTNER_ID,
								CP.COMPANY_ID,
								C.FULLNAME
							FROM
								COMPANY_PARTNER CP,
								COMPANY C
							WHERE
								CP.COMPANY_ID = C.COMPANY_ID AND
								CP.PARTNER_ID IN (#partner_id_list#)
							ORDER BY
								CP.PARTNER_ID
						</cfquery>
						<cfset main_partner_id_list = listsort(listdeleteduplicates(valuelist(get_partner_detail.partner_id,',')),'numeric','ASC',',')>
					</cfif>
					<cfif len(consumer_id_list)>
						<cfset consumer_id_list=listsort(consumer_id_list,"numeric","ASC",",")>
						<cfquery name="GET_CONSUMER_DETAIL" datasource="#DSN#">
							SELECT
								CONSUMER_ID,
								CONSUMER_NAME,
								CONSUMER_SURNAME
							FROM
								CONSUMER
							WHERE
								CONSUMER_ID IN (#consumer_id_list#)
							ORDER BY
								CONSUMER_ID
						</cfquery>
						<cfset main_consumer_id_list = listsort(listdeleteduplicates(valuelist(get_consumer_detail.consumer_id,',')),'numeric','ASC',',')>
					</cfif>
					<cfif len(project_id_list)>
						<cfset project_id_list=listsort(project_id_list,"numeric","ASC",",")>
						<cfquery name="GET_PROJECT_DETAIL" datasource="#DSN#">
							SELECT
								PROJECT_ID,
								PROJECT_HEAD
							FROM
								PRO_PROJECTS
							WHERE
								PROJECT_ID IN (#project_id_list#)
							ORDER BY
								PROJECT_ID
						</cfquery>
						<cfset main_project_id_list = listsort(listdeleteduplicates(valuelist(get_project_detail.project_id,',')),'numeric','ASC',',')>
					</cfif>
					<cfif len(county_id_list)>
						<cfset county_id_list=listsort(county_id_list,"numeric","ASC",",")>	
						<cfquery name="GET_COUNTY_NAME" datasource="#DSN#">
							SELECT 
								COUNTY_ID,
								COUNTY_NAME 
							FROM 
								SETUP_COUNTY 
							WHERE 
								COUNTY_ID IN (#county_id_list#) 
							ORDER BY 
								COUNTY_ID
						</cfquery>				
					</cfif>
					<cfoutput query="get_subscriptions" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<tr>
							<td>
							<cfif len(partner_id)>
								<cfset member_id_ = partner_id>
								<cfset member_name_ = get_partner_detail.company_partner_name[listfind(main_partner_id_list,get_subscriptions.partner_id,',')] &' '& get_partner_detail.company_partner_surname[listfind(main_partner_id_list,get_subscriptions.partner_id,',')]>
								<cfset member_type_ = 'partner'>
								<cfset company_name_= get_partner_detail.fullname[listfind(main_partner_id_list,get_subscriptions.partner_id,',')]>
							<cfelse>
								<cfset member_id_ = consumer_id>
								<cfset member_name_ = get_consumer_detail.consumer_name[listfind(main_consumer_id_list,get_subscriptions.consumer_id,',')] &' '& get_consumer_detail.consumer_surname[listfind(main_consumer_id_list,get_subscriptions.consumer_id,',')]>
								<cfset member_type_ = 'consumer'>
								<cfset company_name_= ''>
							</cfif>
							<cfif len(project_id)>
								<cfset p_id = project_id>
								<cfset p_name = get_project_detail.project_head[listfind(main_project_id_list,get_subscriptions.project_id,',')]>
							<cfelse>
								<cfset p_id = ''>
								<cfset p_name = ''>
							</cfif>
							<cfset ship_address_new= replacelist(ship_address,"#chr(10)#"," ")>
							<cfset ship_address_new = replacelist(ship_address_new,"#chr(13)#"," ")>
							<cfset subscription_head_new = replacelist(subscription_head,"'"," ")>
							<cfif len(county_id_list)>
								<cfset county_ = '#get_county_name.county_name[listfind(county_id_list,ship_county_id,',')]#'>
							<cfelse>
								<cfset county_ = ''>
							</cfif>
							<a href="javascript://" class="tableyazi" onclick="gonder('#subscription_id#','#subscription_no#','#subscription_no# - #subscription_head_new#','#member_id_#','#member_name_#','#member_type_#','#company_id#','#company_name_#','#ship_address_new#','#p_id#','#p_name#','#subscription_head_new#','#ship_city_id#','#ship_county_id#','#county_#');open_note_info('#subscription_id#');">#subscription_no#</a></td>
							<td>
								<cfif len(partner_id)>
									#get_partner_detail.fullname[listfind(main_partner_id_list,get_subscriptions.partner_id,',')]# -  #get_partner_detail.company_partner_name[listfind(main_partner_id_list,get_subscriptions.partner_id,',')]# #get_partner_detail.company_partner_surname[listfind(main_partner_id_list,get_subscriptions.partner_id,',')]#
								<cfelse>
									#get_consumer_detail.consumer_name[listfind(main_consumer_id_list,get_subscriptions.consumer_id,',')]# #get_consumer_detail.consumer_surname[listfind(main_consumer_id_list,get_subscriptions.consumer_id,',')]#
								</cfif>
							</td>
							<td>#subscription_head#</td>
							<td>#stage#</td>
							<td>#subscription_type#</td>
						</tr>
					</cfoutput>
				<cfelse>
					<tr>
						<td colspan="6"><cfif isdefined("attributes.is_submitted")><cf_get_lang dictionary_id='57484.Kayit Yok'>!<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'>!</cfif></td>
					</tr>
				</cfif>
			</tbody>
		</cf_flat_list>
		<cfif attributes.maxrows lt attributes.totalrecords>
			<cfset url_string2=attributes.fuseaction>
			<cfif len(attributes.keyword)>
				<cfset url_string2 = "#url_string2#&keyword=#attributes.keyword#">
			</cfif>
			<cfif isdefined("attributes.is_submitted")>
				<cfset url_string2 = "#url_string2#&is_submitted=#attributes.is_submitted#">
			</cfif>
			<cfif isdefined("attributes.subscription_status") and len(attributes.subscription_status)>
				<cfset url_string2 = "#url_string2#&subscription_status=#attributes.subscription_status#">
			</cfif>
			<cfif isdefined("attributes.member_name") and len(attributes.member_name)>
				<cfset url_string2 = "#url_string2#&member_name=#attributes.member_name#">
			</cfif>
			<cfif len(url_string)>
				<cfset url_string2 = "#url_string2##url_string#">
			</cfif>
			<cfif isdefined("attributes.draggable")>
				<cfset url_string2 = "#url_string2#&draggable=#attributes.draggable#">
			</cfif>
			<cf_paging page="#attributes.page#"
				maxrows="#attributes.maxrows#"
				totalrecords="#attributes.totalrecords#"
				startrow="#attributes.startrow#"
				adres="#url_string2#"
				isAjax="#iif(isdefined("attributes.draggable"),1,0)#">
		</cfif>
	</cf_box>
</div>
<script type="text/javascript">
	$(document).ready(function(){
    $( "form[name=search_subscription] #keyword" ).focus();
});
	
	function gonder(field_id,field_no,field_head,field_member_id,field_member_name,field_member_type,field_company_id,field_company_name,field_ship_address,project_id,project_name,subscription_head,field_ship_city_id,field_ship_county_id,field_ship_county_name)
	{
		<cfif not IsDefined("satir")>
			<cfoutput>
				<cfif isDefined("attributes.field_id")>
					<cfif listlen(attributes.field_id,'.') eq 1>
						<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.getElementById('#attributes.field_id#').value = field_id;
					<cfelse>
						<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.#attributes.field_id#.value = field_id;
					</cfif>
				</cfif>
				<cfif xml_is_subscription_head eq 1>
				<cfif isDefined("attributes.field_no")>
					<cfif listlen(attributes.field_no,'.') eq 1>
						<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.getElementById('#attributes.field_no#').value =  field_head;					
					<cfelse>
						<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.#attributes.field_no#.value = field_head;					
					</cfif>
				</cfif>
				</cfif>
				<cfif xml_is_subscription_head eq 0>
					<cfif isDefined("attributes.field_no")>
					<cfif listlen(attributes.field_no,'.') eq 1>
						<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.getElementById('#attributes.field_no#').value =  field_no;					
					<cfelse>
						<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.#attributes.field_no#.value = field_no;					
					</cfif>
				</cfif>
				</cfif>
				<cfif isDefined("attributes.field_head")>			
					<cfif listlen(attributes.field_head,'.') eq 1>
						<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.getElementById('#attributes.field_head#').value = field_head;
					<cfelse>
						<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.#attributes.field_head#.value = field_head;
					</cfif>
				</cfif>
				<cfif isDefined("attributes.field_project_id")>
					<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.#attributes.field_project_id#.value = project_id;
				</cfif>
				<cfif isDefined("attributes.field_project_name")>
					<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.#attributes.field_project_name#.value = project_name;
				</cfif>
				<cfif isDefined("attributes.field_member_id")>
					<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.#attributes.field_member_id#.value = field_member_id;
				</cfif>
				<cfif isDefined("attributes.field_member_name")>
					<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.#attributes.field_member_name#.value = field_member_name;
				</cfif>	
				<cfif isDefined("attributes.field_member_type")>
					<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.#attributes.field_member_type#.value = field_member_type;
				</cfif>
				<cfif isDefined("attributes.field_company_id")>
					<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.#attributes.field_company_id#.value = field_company_id;
				</cfif>
				<cfif isDefined("attributes.field_company_name")>
					<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.#attributes.field_company_name#.value = field_company_name;
				</cfif>
				<cfif isDefined("attributes.field_ship_address")>
					<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.#attributes.field_ship_address#.value = field_ship_address;
				</cfif>
				<cfif isDefined("attributes.field_ship_city_id")>
					<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.#attributes.field_ship_city_id#.value = field_ship_city_id;
				</cfif>
				<cfif isDefined("attributes.field_ship_county_id")>
					<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.#attributes.field_ship_county_id#.value = field_ship_county_id;
				</cfif>
				<cfif isDefined("attributes.field_ship_county_name")>
					<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.#attributes.field_ship_county_name#.value = field_ship_county_name;
				</cfif>
				<cfif isdefined('attributes.call_function') and isdefined('attributes.call_function_param')>
					<cfif not isdefined("attributes.draggable")>window.opener.</cfif>#attributes.call_function#('#attributes.call_function_param#');
				<cfelseif isdefined("attributes.call_function")>
					<cfif not isdefined("attributes.draggable")>window.opener.</cfif>#call_function#();
				</cfif>
				<cfif isdefined("attributes.call_money_function")>
					try{<cfif not isdefined("attributes.draggable")>window.opener.document.</cfif>#attributes.call_money_function#;}
						catch(e){};
				</cfif>
			</cfoutput>
		<cfelse>
			//Baskete abone düşürmek için eklendi
			//upd: 02/10/2019 - Uğur Hamurpet
			<cfif isdefined("attributes.satir") and len(attributes.satir)>
				var satir = <cfoutput>#attributes.satir#</cfoutput>;
			<cfelse>
				var satir = -1;
			</cfif>
			if(<cfif not isdefined("attributes.draggable")>window.opener.</cfif>basket && satir > -1)
				<cfif not isdefined("attributes.draggable")>window.opener.</cfif>updateBasketItemFromPopup(satir, { ROW_SUBSCRIPTION_ID: field_id, ROW_SUBSCRIPTION_NAME: field_head });
		</cfif>
		<cfif not isdefined("attributes.draggable")>window.close();<cfelseif isdefined("attributes.draggable")>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );</cfif>
	}
	
	function open_note_info(subscription_id)
	{
		var get_note = wrk_safe_query('obj_get_note','dsn',0,subscription_id);
		if(get_note.recordcount)
		{
			window.open('<cfoutput>#request.self#?fuseaction=objects.popup_detail_company_note&subs_id='+ subscription_id +'</cfoutput>','','scrollbars=0, resizable=0,width=500,height=500,left='+(screen.width-500)/2+',top='+(screen.height-500)/2+"'");
			window.close();
		}
	}
</script>
