<cfinclude template="../login/send_login.cfm">
<cfif not isdefined("session_base.userid")><cfexit method="exittemplate"></cfif>
<cfset offer = createObject("component","V16.objects2.sale.cfc.offer")>
<cfparam name="attributes.offer_stage" default="">
<cfparam name="attributes.status" default="">
<cfparam name="attributes.start_date" default="">
<cfparam name="attributes.finish_date" default="">
<cfif isdefined("attributes.start_date") and isdate(attributes.start_date)><cf_date tarih="attributes.start_date"></cfif>
<cfif isdefined("attributes.finish_date") and isdate(attributes.finish_date)><cf_date tarih="attributes.finish_date"></cfif>
<cfif isdefined('attributes.form_submitted')>
	<cfset GET_OFFER_LIST = offer.GET_OFFER_LIST(
													offer_stage : '#IIf(IsDefined("attributes.offer_stage"),"attributes.offer_stage",DE(''))#',
													keyword : '#IIf(IsDefined("attributes.keyword"),"attributes.keyword",DE(''))#',
													status : '#IIf(IsDefined("attributes.status"),"attributes.status",DE(''))#',
													start_date : '#IIf(IsDefined("attributes.start_date"),"attributes.start_date",DE(''))#',	
													finish_date : '#IIf(IsDefined("attributes.finish_date"),"attributes.finish_date",DE(''))#'
												)>
<cfelse>
	<cfset get_offer_list.recordcount = 0>
</cfif>
<cfif isdefined("session.pp.our_company_id")>
	<cfset my_our_comp_ = session.pp.our_company_id>
<cfelseif isdefined("session.ww.our_company_id")>
	<cfset my_our_comp_ = session.ww.our_company_id>
<cfelse>
	<cfset my_our_comp_ = session.ep.company_id>
</cfif>

<div class="table-responsive">
<table class="table">
	<thead>
		<tr> 
			<td><cf_get_lang dictionary_id='57487.No'></td>
			<td><cf_get_lang dictionary_id='58820.Başlık'></td>			
			<td><cf_get_lang dictionary_id='35513.Teklifi Veren'></td>
			<td><cf_get_lang dictionary_id='58859.Süreç'></td>
			<td><cf_get_lang dictionary_id='30631.Tarih'></td>
			<td class="text-right"><cf_get_lang dictionary_id='58056.Dövizli Tutar'></td>
			<td class="text-right"><cf_get_lang dictionary_id='57673.Tutar'></td>
		</tr>
	</thead>
	<cfset partner_id_list = ''>
	<cfset consumer_id_list = ''>
	<cfset offer_id_list = ''>
	<cfset stage_list = ''>
	<cfif get_offer_list.recordcount>
	<cfoutput query="get_offer_list" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
		<cfif len(partner_id) and not listfind(partner_id_list,partner_id)>
			<cfset partner_id_list=listappend(partner_id_list,partner_id)>
		</cfif>
		<cfif len(consumer_id) and not listfind(consumer_id_list,consumer_id)>
			<cfset consumer_id_list=listappend(consumer_id_list,consumer_id)>
		</cfif>
		<cfif len(offer_id) and not listfind(offer_id_list,offer_id) and (is_processed eq 1)>
			<cfset offer_id_list=listappend(offer_id_list,offer_id)>
		</cfif>
		<cfif len(offer_stage) and not listfind(stage_list,offer_stage)>
			<cfset stage_list=listappend(stage_list,offer_stage)>
		</cfif>	
	</cfoutput>
	<cfif len(stage_list)>
		<cfset stage_list=listsort(stage_list,"numeric","ASC",",")>
		<cfset GET_OFFERS_STAGE = offer.GET_OFFERS_STAGE(my_our_comp_: my_our_comp_, stage_list: stage_list)>
		
	</cfif>
	<cfif len(offer_id_list)>
		<cfset offer_id_list=listsort(offer_id_list,"numeric","ASC",",")>
		<cfset GET_OFFERS_SHIP = offer.GET_OFFERS_SHIP(offer_id_list : offer_id_list)>
		
	</cfif>
	<cfif len(partner_id_list)>
		<cfset partner_id_list=listsort(partner_id_list,"numeric","ASC",",")>
		<cfset get_partner = offer.get_partner(partner_id_list: partner_id_list)>
	<cfelseif isdefined('session.ww.userid')>
		<cfset consumer_id_list=listsort(consumer_id_list,"numeric","ASC",",")>
		<cfset GET_CONSUMER = offer.GET_CONSUMER(consumer_id_list: consumer_id_list)>

	</cfif>
	<cfoutput query="get_offer_list" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
		<tr>
			<td><a href="/#get_page.DET_PAGE_URL#/#offer_id#">#offer_number#</a></td>
			<td><a href="/#get_page.DET_PAGE_URL#/#offer_id#">#offer_head#</a></td>			
			<td><cfif len(partner_id_list)>
					#get_partner.company_partner_name[listfind(partner_id_list,get_offer_list.partner_id,',')]# #get_partner.company_partner_surname[listfind(partner_id_list,get_offer_list.partner_id,',')]#
				<cfelseif isdefined('session.ww.userid')>
					#get_consumer.consumer_name[listfind(consumer_id_list,get_offer_list.consumer_id,',')]# #get_consumer.consumer_surname[listfind(consumer_id_list,get_offer_list.consumer_id,',')]#
				</cfif>
			</td>
			<td>
				<div style="background-color:##fff4de;color:##ffa800;" class="process">
					#get_offers_stage.stage[listfind(stage_list,get_offer_list.offer_stage,',')]#
				</div>
			</td>
			<td>#dateformat(offer_date,'dd/mm/yyyy')#</td>
			<td class="text-right"><cfif len(update_date)><cfif len(other_money_value)>#TLFormat(other_money_value)# #other_money#</cfif></cfif></td>
			<td class="text-right">
				<cfif len(update_date)>
					<cfif price neq "0">
						#TLFormat(price)# <cfif isdefined("session.pp.money")>#session.pp.money#<cfelse>#session.ww.money#</cfif>
					<cfelse>
						<cfif offer.HESAPLA_TOTAL(offer_id) neq "yok">
							#TLFormat(offer.HESAPLA_TOTAL(offer_id))# <cfif isdefined("session.pp.money")>#session.pp.money#<cfelse>#session.ww.money#</cfif>
						<cfelse>
							<cf_get_lang dictionary_id='29399.Bedelsiz'>
						</cfif>
					</cfif>
				<cfelse>
					<cf_get_lang dictionary_id='34479.Fiyat Verilmemiş'>
				</cfif>
			</td>
		</tr>
	</cfoutput> 
	<cfelse>
		<tr> 
			<td colspan="7"><cfif isdefined('attributes.form_submitted')><cf_get_lang dictionary_id='57484.Kayıt Yok'> !<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'> !</cfif></td>
		</tr>
	</cfif>
</table>
</div>
<cfif attributes.maxrows lt attributes.totalrecords> 
	<div class="table-responsive">
		<table class="table">
			<tr> 
				<td> 
					<cf_pages page="#attributes.page#" 
						maxrows="#attributes.maxrows#"
						totalrecords="#attributes.totalrecords#"
						startrow="#attributes.startrow#"
						adres="objects2.view_list_offer&#url_str#"> 
				</td>
				<td class="text-right"><cfoutput> <cf_get_lang_main no="128.Toplam Kayıt">: #attributes.totalrecords# - <cf_get_lang_main no="169.Sayfa"> : #attributes.page# / #lastpage#</cfoutput></td>
			</tr>
		</table>
	</div>
</cfif>
