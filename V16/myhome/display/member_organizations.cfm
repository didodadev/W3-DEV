<cfsetting showdebugoutput="no">
<cfquery name="get_company_details" datasource="#dsn#">
	SELECT
		O.ORGANIZATION_ID,
		OA.CON_ID,
		OA.PAR_ID,
		O.ORGANIZATION_HEAD,
		O.START_DATE AS STARTDATE,
		O.FINISH_DATE,
		OC.ORGANIZATION_CAT_NAME,
		PTR.STAGE,
		ORR.RESULT_HEAD
	FROM 
		ORGANIZATION_ATTENDER OA,
		ORGANIZATION O
			LEFT JOIN ORGANIZATION_CAT OC ON OC.ORGANIZATION_CAT_ID = O.ORGANIZATION_CAT_ID
			LEFT JOIN PROCESS_TYPE_ROWS PTR ON PTR.PROCESS_ROW_ID = O.ORG_STAGE
			LEFT JOIN ORGANIZATION_RESULT_REPORT ORR ON ORR.ORGANIZATION_ID = O.ORGANIZATION_ID
	WHERE 
		O.ORGANIZATION_ID = OA.ORGANIZATION_ID
		<cfif isdefined('attributes.cpid') and len(attributes.cpid)>
			AND OA.PAR_ID IN (SELECT PARTNER_ID FROM COMPANY_PARTNER WHERE COMPANY_ID = #attributes.cpid#)
		<cfelseif isdefined('attributes.cid') and len(attributes.cid)>
			AND
			(
				OA.CON_ID = #attributes.cid# OR
				OA.PAR_ID IN (SELECT PARTNER_ID FROM COMPANY_PARTNER WHERE RELATED_CONSUMER_ID = #attributes.cid#)
			)
		</cfif>
</cfquery>
<cf_ajax_list>
	<thead>
		<tr>
			<th><cf_get_lang dictionary_id='57742.Tarih'></th>
			<th><cf_get_lang dictionary_id='57570.Ad Soyad'></th>
			<th><cf_get_lang dictionary_id='57480.Konu'></th>
			<th><cf_get_lang dictionary_id='57486.Kategori'></th>
			<th><cf_get_lang dictionary_id='58859.Süreç'></th>
			<th><cf_get_lang dictionary_id='59952.Sonuç Bilgisi'></th>
		</tr>
	</thead>
	<cfif get_company_details.recordcount>
		<cfset partner_list = "">
		<cfset consumer_list = "">
		<cfoutput query="get_company_details">
			<cfif Len(par_id) and not ListFind(partner_list,par_id)>
				<cfset partner_list = ListAppend(partner_list,par_id)>
			</cfif>
			<cfif Len(con_id) and not ListFind(consumer_list,con_id)>
				<cfset consumer_list = ListAppend(consumer_list,con_id)>
			</cfif>
		</cfoutput>
		<cfif ListLen(partner_list)>
			<cfquery name="Get_Partner_Info" datasource="#dsn#">
				SELECT PARTNER_ID, COMPANY_PARTNER_NAME, COMPANY_PARTNER_SURNAME FROM COMPANY_PARTNER WHERE PARTNER_ID IN (#partner_list#) ORDER BY PARTNER_ID
			</cfquery>
			<cfset partner_list = ListSort(ListDeleteDuplicates(ValueList(Get_Partner_Info.Partner_Id)),'numeric','asc',',')>
		</cfif>
		<cfif ListLen(consumer_list)>
			<cfquery name="Get_Consumer_Info" datasource="#dsn#">
				SELECT CONSUMER_ID, CONSUMER_NAME, CONSUMER_SURNAME FROM CONSUMER WHERE CONSUMER_ID IN (#consumer_list#) ORDER BY CONSUMER_ID
			</cfquery>
			<cfset consumer_list = ListSort(ListDeleteDuplicates(ValueList(Get_Consumer_Info.Consumer_Id)),'numeric','asc',',')>
		</cfif>
		<cfoutput query="get_company_details">
		<tbody>
			<tr>
				<td width="250">
					<cfset startdate1 = date_add('h', session.ep.time_zone, startdate)>
					<cfset finishdate = date_add('h', session.ep.time_zone, finish_date)>
					#dateformat(startdate1,dateformat_style)# (#timeformat(startdate1,timeformat_style)#) - #dateformat(finishdate,dateformat_style)# (#timeformat(finishdate,timeformat_style)#)</td>
				<td width="110">
					<cfif Len(par_id)>
						<a href="javascript://"  onclick="windowopen('#request.self#?fuseaction=objects.popup_par_det&par_id=#par_id#','medium');" class="tableyazi">#Get_Partner_Info.Company_Partner_Name[ListFind(partner_list,par_id)]# #Get_Partner_Info.Company_Partner_SurName[ListFind(partner_list,par_id)]#</a>
					<cfelseif Len(con_id)>
						<a href="javascript://"  onclick="windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id=#con_id#','medium');" class="tableyazi">#Get_Consumer_Info.Consumer_Name[ListFind(consumer_list,con_id)]# #Get_Consumer_Info.Consumer_SurName[ListFind(consumer_list,con_id)]#</a>
					</cfif>
					<!--- <a href="javascript://"  onclick="windowopen('#request.self#?<cfif isdefined('attributes.cpid') and len(attributes.cpid)>fuseaction=objects.popup_par_det&par_id=#get_company_details.member_id#<cfelseif isdefined('attributes.cid') and len(attributes.cid)>fuseaction=objects.popup_con_det&con_id=#get_company_details.member_id# </cfif>','medium');" class="tableyazi">#get_company_details.member_name# #get_company_details.member_surname#</a> --->
				</td>
				<td width="250"><a href="#request.self#?fuseaction=campaign.list_organization&event=upd&org_id=#organization_id#" class="tableyazi">#organization_head#</a></td>
				<td>#organization_cat_name#</td>
				<td>#stage#</td>
				<td>
					<a onclick="windowopen('#request.self#?fuseaction=campaign.popup_organization_result_report&organization_id=#organization_id#','list')" href="javascript:;">
						#result_head#
					</a>
				</td>
			</tr>
		</cfoutput>
		<cfelse>
		<tr>
			<td colspan="3"><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
		</tr>
	</cfif>
    </tbody>
</cf_ajax_list>
