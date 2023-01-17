<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfinclude template="../query/get_target_markets.cfm">			
<cfparam name="attributes.totalrecords" default="#tmarket.recordcount#">

<cfset url_str = "">
<cfif isdefined("attributes.keyword") and len(attributes.keyword)>
	<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
</cfif>
<cfif isdefined("attributes.camp_id") and len(attributes.camp_id)>
	<cfset url_str = "#url_str#&camp_id=#attributes.camp_id#">
<cfelse>
	<cfset camp_id = ''>
</cfif>
<cfif isDefined('attributes.is_money_credit') and attributes.is_money_credit eq 1>
	<cfset url_str = "#url_str#&is_money_credit=#attributes.is_money_credit#">
</cfif>
<cfparam  name="attributes.modal_id">
<cfsavecontent  variable="message"><cf_get_lang dictionary_id='57905.Target Groups'>
</cfsavecontent>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box title="#message#" uidrop="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
		<cfform name="search" method="post" action="#request.self#?fuseaction=campaign.popup_list_target_markets&camp_id=#camp_id#">
			<cf_box_search scroll="0">
				<div class="form-group">
					<cfinput type="text" name="keyword" maxlength="50" value="#attributes.keyword#" placeholder="#getLang('','Filtre','57460')#">
				</div>
				<div class="form-group small">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Kayıt Sayısı Hatalı!'></cfsavecontent>
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,999" message="#message#" maxlength="3" >
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4" search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('search' , #attributes.modal_id#)"),DE(""))#">
				</div>
				<div class="form-group">
					<a class="ui-btn ui-btn-gray" href="javascript://" onClick="<cfif not isdefined("attributes.draggable")>window.close();<cfelseif isdefined("attributes.draggable")>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );</cfif>"> <i class="icon-remove"alt="<cf_get_lang dictionary_id='32445.Seçme İşlemi Bitti'>" title="<cf_get_lang dictionary_id='32445.Seçme İşlemi Bitti'>"></i></a>
				</div>
			</cf_box_search>
		</cfform>
		<cf_flat_list>
			<thead>
				<tr> 
					<th><cf_get_lang dictionary_id='57487.No'></th>
					<th><cf_get_lang dictionary_id='49363.Hedef Kitle'></th>
					<th><cf_get_lang dictionary_id='49391.Katılan Kişi Sayısı'></th>
				</tr>
			</thead>
			<tbody>
				<cfset toplam = 0>
				<cfif tmarket.recordcount>
					<cfoutput query="tmarket" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<tr>
							<td>#tmarket_no#</td>
							<cfif fusebox.fuseaction contains "popup">
								<cfif isDefined('attributes.is_money_credit') and attributes.is_money_credit eq 1>
									<td><a onClick="add_target_market('#tmarket_id#','#tmarket_name#');" class="tableyazi">#tmarket_name#</a></td>  
									<script language="javascript"> 
										function add_target_market(tmarketid,tmarketname)
										{
											opener.document.getElementById('target_market_id').value = tmarketid;
											opener.document.getElementById('target_market').value = tmarketname;
											window.close(); 
										}
									</script> 
								<cfelse>
									<td><a href="#request.self#?fuseaction=campaign.add_camp_tmarket&tmarket_id=#tmarket_ID#<cfif isdefined("attributes.camp_id") and len(attributes.camp_id)>&camp_id=#attributes.camp_id#</cfif>" class="tableyazi">#tmarket_name#</a></td>
								</cfif>
							<cfelse>
								<td><a href="#request.self#?fuseaction=campaign.form_upd_target_market&tmarket_id=#tmarket_ID#" class="tableyazi">#tmarket_name#</a></td>
							</cfif>
							<cfset 'par_#TMARKET_ID#' = 0>
							<cfset 'cons_#TMARKET_ID#' =0>
							<cfset attributes.count=1>
							<cfif TARGET_MARKET_TYPE eq 0 or TARGET_MARKET_TYPE eq 2>
								<cfinclude template="../query/get_tmarket_consumers.cfm">
								<cfset 'cons_#TMARKET_ID#' = GET_TMARKET_USERS.count_consumer>
							</cfif>
							<cfif TARGET_MARKET_TYPE eq 0 or TARGET_MARKET_TYPE eq 1>
								<cfinclude template="../query/get_tmarket_partner_ids.cfm">
								<cfset 'par_#TMARKET_ID#' = GET_TMARKET_PARTNERS.count_partner>
							</cfif>
							<cfset total_no = evaluate("cons_#TMARKET_ID#") + evaluate("par_#TMARKET_ID#")>
							<td>#total_no#</td>
						</tr>
					</cfoutput>
				<cfelse>
					<tr> 
						<td colspan="3"><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
					</tr>
				</cfif>
			</tbody>
		</cf_flat_list>
		<cfif attributes.totalrecords gt attributes.maxrows>
			<cf_paging page="#attributes.page#" 
				maxrows="#attributes.maxrows#" 
				totalrecords="#attributes.totalrecords#" 
				startrow="#attributes.startrow#" 
				adres="campaign.popup_list_target_markets#url_str#"
				isAjax="#iif(isdefined("attributes.draggable"),1,0)#">
			
		</cfif>
	</cf_box>
</div>