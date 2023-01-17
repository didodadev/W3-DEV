<cf_xml_page_edit default_value="1" fuseact="myhome.my_company_details">
<cfsetting showdebugoutput="no">
<cfquery name="GET_OFFER_LIST" datasource="#DSN3#">
	SELECT 
		OFFER_NUMBER,
		OFFER_HEAD,
		OFFER_DATE,
		OFFER_STATUS,
		OFFER_STAGE,
		PRICE,
		OTHER_MONEY,
		OTHER_MONEY_VALUE,
		OFFER_ZONE,
		OFFER_ID,
		FINISHDATE,
		(SELECT TOP 1 O.OFFER_ID FROM ORDERS O WHERE O.OFFER_ID = OFFER.OFFER_ID) ORDER_OFFER_ID
	FROM 
		OFFER
	WHERE
		(
			(OFFER.PURCHASE_SALES = 1 AND OFFER.OFFER_ZONE = 0)	OR
			(OFFER.PURCHASE_SALES = 0 AND OFFER.OFFER_ZONE = 1)
		)
		<cfif isdefined ("attributes.cpid") and len ("attributes.cpid")>
		AND COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cpid#">
		<cfelseif isdefined ("attributes.cid") and len ("attributes.cid")>
		AND
		(
			CONSUMER_ID = #attributes.cid# OR
			COMPANY_ID IN (SELECT COMPANY_ID FROM #dsn_alias#.COMPANY_PARTNER WHERE RELATED_CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cid#">)
		)
		</cfif>
	ORDER BY
		OFFER_DATE DESC
</cfquery>
<cfif isdefined ("attributes.cid") and len(attributes.cid)>
	<cfquery name="Get_Related_Consumer" datasource="#dsn#">
		SELECT PARTNER_ID FROM COMPANY_PARTNER WHERE RELATED_CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cid#">
	</cfquery>
</cfif>
<cfquery name="GET_OFFER_LIST2" datasource="#DSN3#">
	SELECT 
		OFFER_NUMBER,
		OFFER_HEAD,
		OFFER_DATE,
		OFFER_STAGE,
		OFFER_STATUS,
		PRICE,
		OTHER_MONEY,
		OTHER_MONEY_VALUE,
		OFFER_ZONE,
		OFFER_ID
	FROM 
		OFFER
	WHERE
		OFFER_ZONE = 0 AND 
		PURCHASE_SALES = 0 AND
		<cfif isdefined ("attributes.cpid") and len(attributes.cpid)>
				OFFER_TO LIKE '%,#attributes.cpid#,%'
		<cfelseif isdefined ("attributes.cid") and len(attributes.cid)>
			(
				OFFER_TO = '#attributes.cid#' 
				<cfif Get_Related_Consumer.recordcount>OR</cfif>
				<cfloop query="Get_Related_Consumer">
					OFFER_TO_PARTNER LIKE '%,#Get_Related_Consumer.Partner_Id#,%'
					<cfif Get_Related_Consumer.CurrentRow neq Get_Related_Consumer.RecordCount> OR</cfif>
				</cfloop>
			)
		</cfif>	
	ORDER BY
		OFFER_DATE DESC
</cfquery>

<cf_seperator title="#getLang('','Satış','57448')#" id="satis">
	<div id="satis">
		<cf_ajax_list>
			<thead>
				<tr>
					<th><cf_get_lang dictionary_id='57487.No'></th>
					<th><cf_get_lang dictionary_id='57742.Tarih'></th>
					<cfif is_gecerlilik_suresi eq 1>
					<th style="text-align:center"><cf_get_lang dictionary_id='30966.Geçerlilik Süresi'></th>
					</cfif>
					<cfif is_gecen_gun eq 1>
					<th style="text-align:center"><cf_get_lang dictionary_id='29986.Geçen Gün'></th>
					</cfif>
					<th><cf_get_lang dictionary_id='57629.Açıklama'></th>
					<th><cf_get_lang dictionary_id='57756.Durum'></th>
					<th><cf_get_lang dictionary_id='57482.Aşama'></th>
					<th style="text-align:right;"><cf_get_lang dictionary_id='57673.Tutar'></th>
					<th style="text-align:right;"><cf_get_lang dictionary_id='31382.Döviz Tutar'></th>
				</tr>
			</thead>
			<tbody>
				<cfset colspan_ = 7>
				<cfif is_gecerlilik_suresi eq 1><cfset colspan_ = colspan_ + 1></cfif>
				<cfif is_gecen_gun eq 1><cfset colspan_ = colspan_ + 1></cfif>
				<cfset offer_stage_list =''>
				<cfoutput query="get_offer_list" startrow="1" maxrows="#attributes.maxrows#">
					<cfif len(offer_stage) and not listfind(offer_stage_list,offer_stage)>
						<cfset offer_stage_list=listappend(offer_stage_list,offer_stage)>
					</cfif>
				</cfoutput>
				<cfif len(offer_stage_list)>
					<cfset offer_stage_list = listsort(offer_stage_list,"numeric","ASC",",")>
					<cfquery name="GET_PROCESS_STAGE" datasource="#DSN#">
						SELECT PROCESS_ROW_ID, STAGE FROM PROCESS_TYPE_ROWS WHERE PROCESS_ROW_ID IN (#offer_stage_list#) ORDER BY PROCESS_ROW_ID
					</cfquery>
					<cfset offer_stage_list = listsort(listdeleteduplicates(valuelist(GET_PROCESS_STAGE.process_row_id,',')),'numeric','ASC',',')>
				</cfif>
				<cfoutput query="get_offer_list" startrow="1" maxrows="#attributes.maxrows#">
					<tr>
						<td>#offer_number#</td>
						<td>#dateformat(offer_date,dateformat_style)#</td>
						<cfif is_gecerlilik_suresi eq 1>
							<td style="text-align:center"><cfif len(finishdate) and len(offer_date)>#datediff('d',offer_date,finishdate)#</cfif>
								<!--- <cfset colspan_ = colspan_ + 1> --->
							</td>
						</cfif>
						<cfif is_gecen_gun eq 1>
							<td style="text-align:center"><cfif len(get_offer_list.order_offer_id)>0<cfelseif len(offer_date)>#datediff('d',offer_date,now())#</cfif>
								<!--- <cfset colspan_ = colspan_ + 1> --->
							</td>
						</cfif>
						<td><a href="#request.self#?fuseaction=<cfif offer_zone is 1>sales.detail_offer_pta<cfelseif offer_zone is 0>sales.list_offer&event=upd</cfif>&offer_id=#offer_id#" class="tableyazi">#offer_head#</a></td>
						<td><cfif get_offer_list.offer_status eq 0><cf_get_lang dictionary_id='57494.Pasif'><cfelseif get_offer_list.offer_status eq 1><cf_get_lang dictionary_id='57493.Aktif'></cfif></td>
						<td><cfif len(offer_stage)>#get_process_stage.stage[listfind(offer_stage_list,offer_stage,',')]#</cfif></td>
						<td style="text-align:right;"><cfif price neq 0 and len(trim(price))>#TLFormat(price)#&nbsp;#session.ep.money#</cfif></td>
						<td style="text-align:right;">
							<cfif other_money neq '#session.ep.money#'>
								<cfif price neq 0 and len(trim(price))>#TLFormat(other_money_value)#&nbsp;#other_money#</cfif>
							</cfif>
						</td>
					</tr>
				</cfoutput>
				<cfif not get_offer_list.recordcount>
					<tr>
						<td colspan="<cfoutput>#colspan_#</cfoutput>"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'> !</td>
					</tr>
				</cfif>
			</tbody>
		</cf_ajax_list>
	</div>

	<cf_seperator title="#getLang('','Satın alma','57449')#" id="satinalma">
		<div id="satinalma">
			<cf_ajax_list>
				<thead>
					<tr>
						<th><cf_get_lang dictionary_id='57487.No'></th>
						<th><cf_get_lang dictionary_id='57742.Tarih'></th>
						<cfif is_gecerlilik_suresi eq 1>
						<th style="text-align:center"><cf_get_lang dictionary_id='30966.Geçerlilik Süresi'></th>
						</cfif>
						<cfif is_gecen_gun eq 1>
						<th style="text-align:center"><cf_get_lang dictionary_id='29986.Geçen Gün'></th>
						</cfif>
						<th><cf_get_lang dictionary_id='57629.Açıklama'></th>
						<th><cf_get_lang dictionary_id='57756.Durum'></th>
						<th><cf_get_lang dictionary_id='57482.Aşama'></th>
						<th style="text-align:right;"><cf_get_lang dictionary_id='57673.Tutar'></th>
						<th style="text-align:right;"><cf_get_lang dictionary_id='31382.Döviz Tutar'></th>
					</tr>
				</thead>
				<tbody>
					<cfset offer_stage_list_2 =''>
					<cfoutput query="get_offer_list2" startrow="1" maxrows="#attributes.maxrows#">
						<cfif len(offer_stage) and not listfind(offer_stage_list_2,offer_stage)>
							<cfset offer_stage_list_2=listappend(offer_stage_list_2,offer_stage)>
						</cfif>
					</cfoutput>
					<cfif len(offer_stage_list_2)>
						<cfset offer_stage_list_2 = listsort(offer_stage_list_2,"numeric","ASC",",")>
							<cfquery name="GET_PROCESS_STAGE_2" datasource="#DSN#">
								SELECT PROCESS_ROW_ID, STAGE FROM PROCESS_TYPE_ROWS WHERE PROCESS_ROW_ID IN (#offer_stage_list_2#) ORDER BY PROCESS_ROW_ID
							</cfquery>
						</cfif>
					<cfoutput query="get_offer_list2" startrow="1" maxrows="#attributes.maxrows#">
					<tr>
						<td>#offer_number#</td>
						<td>#dateformat(offer_date,dateformat_style)#</td>
						<cfif is_gecerlilik_suresi eq 1>
							<td><cfset colspan_ = colspan_ + 1></td>
						</cfif>
						<cfif is_gecen_gun eq 1>
							<td><cfset colspan_ = colspan_ + 1></td>
						</cfif>
						<td><a href="#request.self#?fuseaction=<cfif offer_zone is 1>purchase.detail_offer_ptv<cfelseif offer_zone is 0>purchase.list_offer&event=upd</cfif>&offer_id=#offer_id#" class="tableyazi">#offer_head#</a></td>
						<td><cfif get_offer_list2.offer_status eq 0><cf_get_lang dictionary_id='57494.Pasif'><cfelseif get_offer_list2.offer_status eq 1><cf_get_lang dictionary_id='57493.Aktif'></cfif></td>
						<td><cfif len(offer_stage)>#get_process_stage_2.stage[listfind(offer_stage_list_2,offer_stage,',')]#</cfif></td>
						<td style="text-align:right;"><cfif price neq 0 and len(trim(price))>#TLFormat(price)#&nbsp;#session.ep.money#</cfif></td>
						<td style="text-align:right;">
							<cfif other_money neq '#session.ep.money#'>
								<cfif price neq 0 and len(trim(price))>
									#TLFormat(other_money_value)#&nbsp;#other_money#
								</cfif>
							</cfif>
						</td>
					</tr>
					</cfoutput>
					<cfif not get_offer_list2.recordcount>
						<tr>
							<td colspan="<cfoutput>#colspan_#</cfoutput>"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'> !</td>
						</tr>
					</cfif>
				</tbody>
			</cf_ajax_list>
		</div>
