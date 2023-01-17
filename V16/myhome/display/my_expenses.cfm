<!--- gündem-ben altındaki harcamalarım sayfası --->

<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.srch_date1" default='#dateformat(date_add("d", -1, now()),dateformat_style)#'>
<cfparam name="attributes.srch_date2" default='#dateformat(now(),dateformat_style)#'>
<cfparam name="attributes.employee_id" default="">
<cfparam name="attributes.expense_employee" default="">
<cfparam name="attributes.expense_item_id" default="">
<cfparam name="attributes.expense_center_id" default="">
<cfparam name="attributes.activity_type" default="">
<cfparam name="attributes.form_exist" default="">
<cfparam name="attributes.asset_id" default="">
<cfparam name="attributes.asset" default="">
<cfparam name="attributes.project_id" default="">
<cfparam name="attributes.project" default="">
<cfif len(attributes.srch_date1)>
  <cf_date tarih='attributes.srch_date1'>
</cfif>
<cfif len(attributes.srch_date2)>
  <cf_date tarih='attributes.srch_date2'>
</cfif>
<cfquery name="GET_EXPENSE_ITEM" datasource="#dsn2#">
	SELECT EXPENSE_ITEM_ID, EXPENSE_ITEM_NAME FROM EXPENSE_ITEMS ORDER BY EXPENSE_ITEM_NAME
</cfquery>
<cfquery name="GET_EXPENSE_CENTER" datasource="#dsn2#">
	SELECT EXPENSE_ID, EXPENSE FROM EXPENSE_CENTER ORDER BY EXPENSE
</cfquery>
<cfquery name="GET_ACTIVITY_TYPES" datasource="#dsn#">
	SELECT ACTIVITY_ID, ACTIVITY_NAME FROM SETUP_ACTIVITY ORDER BY ACTIVITY_NAME
</cfquery>
<cfif  isdefined("attributes.form_exist")>
	<cfinclude template="../query/get_expense_rows.cfm">
	<cfparam name="attributes.totalrecords" default="#get_expense_item_row_all.recordcount#">
<cfelse>
	<cfparam name="attributes.totalrecords" default="0">
</cfif>
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.maxrows" default="#session.ep.maxrows#">
<cfset attributes.startrow = ((attributes.page-1)*attributes.maxrows) + 1>

<cfsavecontent variable="message"><cf_get_lang dictionary_id='31116.Harcamalar'></cfsavecontent>
<cf_box title="#message#" closable="0">
<cfform name="search_asset2" action="#request.self#?fuseaction=myhome.my_expenses" method="post">
<input name="form_exist" id="form_exist" type="hidden" value="1">
	<cf_big_list_search_area>
		<div class="row form-inline">
				<input type="hidden" name="employee_id" id="employee_id" value="<cfoutput>#session.ep.userid#</cfoutput>">
			<div class="form-group" id="item-keyword">
				<div class="input-group x-12">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57460.Filtre'></cfsavecontent>
					<cfinput type="text" name="keyword" id="keyword" placeholder="#message#" value="#attributes.keyword#" maxlength="50">
				</div>
			</div>
				<div class="form-group">
					<div class="input-group x-14">			
						<cfif len(attributes.asset) and len(attributes.asset_id)>
								<input type="hidden" name="asset_id" id="asset_id" value="<cfoutput>#attributes.asset_id#</cfoutput>">
								<cfsavecontent variable="message"><cf_get_lang dictionary_id='29452.Varlık'></cfsavecontent>
								<input type="text" name="asset" id="asset" value="<cfoutput>#attributes.asset#</cfoutput>" placeholder="<cfoutput>#message#</cfoutput>">
							<cfelse>
								<input type="hidden" name="asset_id" id="asset_id" value="">
								<input type="text" name="asset" id="asset" value="" placeholder="<cfoutput>#message#</cfoutput>">
							</cfif>
							<span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=assetcare.popup_list_assetps&field_id=search_asset2.asset_id&field_name=search_asset2.asset&event_id=0','list');"></span>
					</div>	
				</div>
				<div class="form-group">
					<div class="input-group x-14">
						<cfif len(attributes.project_id) and len(attributes.project)>
							<input type="hidden" name="project_id" id="project_id" value="<cfoutput>#attributes.project_id#</cfoutput>">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='57416.Proje'></cfsavecontent>
							<input type="text" name="project" id="project" value="<cfoutput>#attributes.project#</cfoutput>" placeholder="<cfoutput>#message#</cfoutput>">
						<cfelse>
							<input type="hidden" name="project_id" id="project_id" value="">
							<input type="text" name="project" id="project" value="" placeholder="<cfoutput>#message#</cfoutput>">					
						</cfif>
						<span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_projects&project_id=search_asset2.project_id&project_head=search_asset2.project');"></span>
					</div>
				</div>
				<div class="form-group">
					<div class="input-group x-15">
						<select name="expense_center_id" id="expense_center_id" style="width:160px;" class="txt">
								<option value=""><cf_get_lang dictionary_id='58460.Masraf Merkezi'></option>
								<cfoutput query="get_expense_center">
									<option value="#expense_id#" <cfif attributes.expense_center_id eq expense_id>selected</cfif>>#expense#</option>
								</cfoutput>
							</select>
					</div>
				</div>
				<div class="form-group">
					<div class="input-group x-26">
						<select name="expense_item_id" id="expense_item_id" style="width:160px;" class="txt">
								<option value=""><cf_get_lang dictionary_id='31062.Gider Kalemi'></option>
								<cfoutput query="get_expense_item">
									<option value="#expense_item_id#" <cfif attributes.expense_item_id eq expense_item_id>selected</cfif>>#expense_item_name#</option>
								</cfoutput>
							</select>
					</div>	
				</div>
				<div class="form-group">
					<div class="input-group x-12">
						<select name="activity_type" id="activity_type" style="width:160px;" class="txt">
							<option value=""><cf_get_lang dictionary_id='31172.Aktivite Tipi'></option>
							<cfoutput query="get_activity_types">
								<option value="#activity_id#" <cfif attributes.activity_type eq activity_id>selected</cfif>>#activity_name#</option>
							</cfoutput>
						</select>
					</div>
				</div>
				<div class="form-group">
					<div class="input-group x-12">		
						<cfinput type="text" name="srch_date1" value="#dateformat(attributes.srch_date1,dateformat_style)#" maxlength="10" validate="#validate_style#" style="width:65px;">
						<span class="input-group-addon"><cf_wrk_date_image date_field="srch_date1"></span>
					</div>
				</div>
				<div class="form-group">
					<div class="input-group x-12">		
						<cfinput type="text" name="srch_date2" value="#dateformat(attributes.srch_date2,dateformat_style)#" maxlength="10" validate="#validate_style#" style="width:65px;">
						<span class="input-group-addon"><cf_wrk_date_image date_field="srch_date2"></span>
					</div>
				</div>
				
				<div class="form-group x-3_5">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
				</div>
				<div class="form-group x-3_5">		
					<cfsavecontent variable="message_date"><cf_get_lang dictionary_id='57782.Tarih Değerini Kontrol Ediniz'>!</cfsavecontent>
					<cf_wrk_search_button search_function="date_check(search_asset2.srch_date1,search_asset2.srch_date2,'#message_date#')">
				</div>
				<cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'>
			
				
					
				
		</div>			
				
		
		
	</cf_big_list_search_area>
	<!--- <cf_big_list_search_detail_area>
		
	
	</cf_big_list_search_detail_area> --->

</cfform>
<cf_ajax_list>
	<div class="extra_list">
		<thead>
			<tr>
				<th width="30"><cf_get_lang dictionary_id='58577.Sıra'></th>
				<th width="170"><cf_get_lang dictionary_id='31033.Masraf/Gelir Merkezi'></th>
				<th width="170"><cf_get_lang dictionary_id='31062.Gider Kalemi'> </th>
				<th><cf_get_lang dictionary_id='57742.Tarih'></th>
				<th width="180"><cf_get_lang dictionary_id='31173.Harcama Yapan'></th>
				<th width="120"><cf_get_lang dictionary_id='58056.Dövizli Tutar'></th>
				<th width="120"><cf_get_lang dictionary_id='57673.Tutar'></th>		 
				<th width="120"><cf_get_lang dictionary_id='57639.KDV'></th>		 
				<th width="120"><cf_get_lang dictionary_id='31175.KDV li Tutar'></th>	
			</tr>
		</thead>
		<tbody>
			<cfif len(attributes.form_exist)>
				<cfif  get_expense_item_row_all.recordcount>
				<cfscript>
					toplam1 = 0;
					toplam2 = 0;
					toplam3 = 0;
					toplam4 = 0;
					toplam5 = 0;
					toplam6 = 0;
				</cfscript>
				<cfoutput query="get_expense_item_row_all">
					<cfscript>
						toplam1 = toplam1 + amount;				
						toplam2 = toplam2 + amount_kdv;
						toplam3 = toplam3 + total_amount;
					</cfscript>
				</cfoutput>
				<cfoutput query="get_expense_item_row_all" maxrows="#attributes.maxrows#" startrow="#attributes.startrow#">
					<cfscript>
						toplam4 = toplam4 + amount;				
						toplam5 = toplam5 + amount_kdv;
						toplam6 = toplam6 + amount + amount_kdv;
					</cfscript>
					<tr>
					  <td>#currentrow#</td>
					  <td>#expense#</td>
					  <td>#expense_item_name#</td>
					  <td>#dateformat(expense_date,dateformat_style)#</td>
					  <td><cfif member_type eq 'partner'>#get_par_info(company_partner_id,0,-1,1)# - #get_par_info(company_partner_id,0,1,1)#<cfelseif member_type eq 'consumer'>#get_cons_info(company_partner_id,0,1)# - #get_cons_info(expense_employee,2,1)#<cfelseif member_type eq 'employee'>#get_emp_info(company_partner_id,0,1)#<cfelse>#get_emp_info(company_partner_id,0,1)#</cfif></td>
					  <td  style="text-align:right;">#other_money_value# #money_currency_id#</td>
					  <td  style="text-align:right;">#tlformat(amount)# #session.ep.money#</td>
					  <td  style="text-align:right;"><cfif len(amount_kdv)>#tlformat(amount_kdv)# #session.ep.money#<cfelse>0 #session.ep.money#</cfif></td>
					  <td  style="text-align:right;"><cfif len(total_amount)>#tlformat(total_amount)# #session.ep.money#<cfelse>
						  <cfif len(amount_kdv)>
							<cfset kvd_deger = amount_kdv>
						  <cfelse>
							<cfset kvd_deger = 0>
						  </cfif>
						 #tlformat((kvd_deger + amount))# #session.ep.money#
					  </cfif></td>
					</tr>
				</cfoutput>
					<tr class="color-list">
						<td colspan="6"  class="txtbold" style="text-align:right;"><cf_get_lang dictionary_id='31130.Sayfa Toplam'></td>
						<td  class="txtbold" style="text-align:right;"><cfoutput>#TLFormat(toplam4)# #session.ep.money#</cfoutput></td>
						<td  class="txtbold" style="text-align:right;"><cfoutput>#TLFormat(toplam5)# #session.ep.money#</cfoutput></td>
						<td  class="txtbold" style="text-align:right;"><cfoutput>#TLFormat(toplam6)# #session.ep.money#</cfoutput></td>
					</tr>
					<tr class="color-list">
						<td colspan="6"  class="txtbold" style="text-align:right;"><cf_get_lang dictionary_id='57680.Genel Toplam'></td>
						<td  class="txtbold" style="text-align:right;"><cfoutput>#TLFormat(toplam1)# #session.ep.money#</cfoutput></td>
						<td  class="txtbold" style="text-align:right;"><cfoutput>#TLFormat(toplam2)# #session.ep.money#</cfoutput></td>
						<td  class="txtbold" style="text-align:right;"><cfoutput>#TLFormat(toplam3)# #session.ep.money#</cfoutput></td>
					</tr>
				<cfelse>
					<tr>
						<td colspan="9"><cf_get_lang dictionary_id='57484.Kayıt Yok'> !</td>
					</tr>
				</cfif>
				<cfelse>
					<tr class="color-row">
						<td colspan="9"><cf_get_lang dictionary_id='57701.Filtre Ediniz'> !</td>
					</tr>
				</cfif>
		</tbody>
	</div>
</cf_ajax_list>
</cf_box>

<cfinclude  template="../display/list_my_expense_requests.cfm">
		

<!--- </cf_big_list> --->
<cfscript>
		url_str = "" ;
	if ( len(attributes.keyword) )
		url_str = "#url_str#&keyword=attributes.keyword";
	if ( len(attributes.srch_date1) )
		url_str = "#url_str#&srch_date1=#dateformat(attributes.srch_date1,dateformat_style)#";
	if ( len(attributes.srch_date2) )
		url_str = "#url_str#&srch_date2=#dateformat(attributes.srch_date2,dateformat_style)#";
	if ( len(attributes.employee_id) )
		url_str = "#url_str#&employee_id=#attributes.employee_id#";
	if ( len(attributes.expense_employee) )
		url_str = "#url_str#&expense_employee=#attributes.expense_employee#";
	if ( len(attributes.expense_item_id) )
		url_str = "#url_str#&expense_item_id=#attributes.expense_item_id#";
	if ( len(attributes.expense_center_id) )
		url_str = "#url_str#&expense_center_id=#attributes.expense_center_id#";
	if ( len(attributes.activity_type) )
		url_str = "#url_str#&activity_type=#attributes.activity_type#";
	if ( len(attributes.form_exist) and isdefined("attributes.form_exist"))
		url_str = "#url_str#&form_exist=#attributes.form_exist#";
</cfscript>
<cf_paging 
    page="#attributes.page#"
    maxrows="#attributes.maxrows#"
    totalrecords="#attributes.totalrecords#"
    startrow="#attributes.startrow#"
    adres="myhome.my_expenses#url_str#">
<script type="text/javascript">
	document.getElementById('keyword').focus();
</script>