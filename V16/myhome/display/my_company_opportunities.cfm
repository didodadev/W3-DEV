<cf_xml_page_edit default_value="1" fuseact="myhome.my_company_details">
<cfsetting showdebugoutput="no">
<cfquery name="GET_OPPORTUNITY_LIST" datasource="#DSN3#">
	SELECT
		OPP_ID,
		OPP_NO,
		OPP_HEAD,
		OPP_DATE,
		OPP_STAGE,
		OPP_STATUS,
		PROBABILITY,
		OPP_CURRENCY_ID,
		(SELECT TOP 1 O.OPP_ID FROM OFFER O WHERE O.OPP_ID = OPPORTUNITIES.OPP_ID) OFFER_OPP_ID
	FROM
		OPPORTUNITIES
	WHERE
		OPP_ID IS NOT NULL
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
		OPP_DATE DESC
</cfquery>
<cf_ajax_list>
	<thead>
		<tr>
			<th><cf_get_lang dictionary_id='57487.No'></th>
			<th><cf_get_lang dictionary_id='57742.Tarih'></th>
			<cfif is_gecen_gun eq 1>
			<th style="text-align:center"><cf_get_lang dictionary_id='29986.Geçen Gün'></th>
			</cfif>
			<th><cf_get_lang dictionary_id='58652.Olasılık'></th>
			<th><cf_get_lang dictionary_id='57629.Açıklama'></th>
			<th><cf_get_lang dictionary_id='58859.Süreç'></th>
			<th><cf_get_lang dictionary_id='57756.Durum'></th>
		</tr>
	</thead>
	<tbody>
		<cfset opp_stage_list =''>
		<cfset opp_process_list =''>
		<cfset probability_list = "">
		<cfoutput query="get_opportunity_list" startrow="1" maxrows="#attributes.maxrows#">
			<cfif len(opp_currency_id) and not listfind(opp_stage_list,opp_currency_id)>
				<cfset opp_stage_list=listappend(opp_stage_list,opp_currency_id)>
			</cfif>
			<cfif len(opp_stage) and not listfind(opp_process_list,opp_stage)>
				<cfset opp_process_list=listappend(opp_process_list,opp_stage)>
			</cfif>
			<cfif len(probability) and not listfind(probability_list,probability)>
				<cfset probability_list=listappend(probability_list,probability)>
			</cfif>
		</cfoutput>
		<cfif ListLen(opp_process_list)>
			<cfquery name="GET_PROCESS_NAME" datasource="#DSN#">
				SELECT PROCESS_ROW_ID, STAGE FROM PROCESS_TYPE_ROWS WHERE PROCESS_ROW_ID IN (#opp_process_list#) ORDER BY PROCESS_ROW_ID
			</cfquery>
			<cfset opp_process_list = listsort(listdeleteduplicates(valuelist(get_process_name.process_row_id,',')),'numeric','ASC',',')>
		</cfif>
		<cfif ListLen(probability_list)>
			<cfquery name="get_probability" datasource="#dsn3#">
				SELECT PROBABILITY_RATE_ID,PROBABILITY_NAME FROM SETUP_PROBABILITY_RATE  WHERE PROBABILITY_RATE_ID IN (#probability_list#) ORDER BY PROBABILITY_RATE_ID
			</cfquery>
			<cfset probability_list = listsort(listdeleteduplicates(valuelist(get_probability.probability_rate_id,',')),"numeric","ASC",",")>
		</cfif>    
		<cfset colspan_ = 6>
		<cfoutput query="get_opportunity_list" startrow="1" maxrows="#attributes.maxrows#">
			<tr>
				<td>#opp_no#</td>
				<td>#dateformat(opp_date,dateformat_style)#</td>
				<cfif is_gecen_gun eq 1>
					<td style="text-align:center"><cfif len(get_opportunity_list.offer_opp_id)>0<cfelseif len(opp_date)>#datediff('d',opp_date,now())#</cfif>
						<cfset colspan_ = colspan_ + 1>
					</td>
				</cfif>
				<td><cfif len(probability)>#get_probability.probability_name[listfind(probability_list,probability,',')]#</cfif></td>
				<td><a href="#request.self#?fuseaction=sales.list_opportunity&event=det&opp_id=#opp_id#" class="tableyazi">#opp_head#</a></td>
				<td><cfif len(opp_stage)>#get_process_name.stage[listfind(opp_process_list,opp_stage,',')]#</cfif></td>
				<td><cfif get_opportunity_list.opp_status eq 0><cf_get_lang dictionary_id='57494.Pasif'><cfelseif get_opportunity_list.opp_status eq 1><cf_get_lang dictionary_id='57493.Aktif'></cfif></td>
			</tr>
		</cfoutput>
		<cfif not get_opportunity_list.recordcount>
			<tr>
				<td colspan="<cfoutput>#colspan_#</cfoutput>"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'> !</td>
			</tr>
		</cfif>
	</tbody>
</cf_ajax_list>
