<cfsetting showdebugoutput="no">
<cfquery name="get_company_details" datasource="#dsn#">
	SELECT
		TC.CLASS_ID,
		T.CON_ID,
		T.PAR_ID,
		TC.CLASS_NAME,
		TC.START_DATE AS STARTDATE,
		TC.FINISH_DATE
	FROM 
		TRAINING_CLASS_ATTENDER T,
		TRAINING_CLASS TC
	WHERE 
		TC.CLASS_ID = T.CLASS_ID
		<cfif isdefined('attributes.cpid') and len(attributes.cpid)>
			AND T.PAR_ID IN (SELECT PARTNER_ID FROM COMPANY_PARTNER WHERE COMPANY_ID = #attributes.cpid#)
		<cfelseif isdefined('attributes.cid') and len(attributes.cid)>
			AND
			(
				T.CON_ID = #attributes.cid# OR
				T.PAR_ID IN (SELECT PARTNER_ID FROM COMPANY_PARTNER WHERE RELATED_CONSUMER_ID = #attributes.cid#)
			)
		</cfif>
	UNION
		SELECT
			TC.CLASS_ID,
			<!---TC.TRAINER_PAR,
			TC.TRAINER_CONS,--->
			TCT.CONS_ID AS CON_ID,
			TCT.PAR_ID AS PAR_ID,
			TC.CLASS_NAME,
			TC.START_DATE,
			TC.FINISH_DATE
		FROM 
			TRAINING_CLASS TC,
			TRAINING_CLASS_TRAINERS TCT
		WHERE	
			TC.CLASS_ID = TCT.CLASS_ID
			<cfif isdefined('attributes.cpid') and len(attributes.cpid)>
				<!--- TC.TRAINER_PAR IN (SELECT PARTNER_ID FROM COMPANY_PARTNER WHERE COMPANY_ID = #attributes.cpid#) --->
				AND TCT.PAR_ID IN(SELECT PARTNER_ID FROM COMPANY_PARTNER WHERE COMPANY_ID = #attributes.cpid#)
			<cfelseif isdefined('attributes.cid') and len(attributes.cid)>
				AND (
					<!---TC.TRAINER_CONS = #attributes.cid# OR
					TC.TRAINER_PAR IN (SELECT PARTNER_ID FROM COMPANY_PARTNER WHERE RELATED_CONSUMER_ID = #attributes.cid#)--->
					TCT.CONS_ID = #attributes.cid# OR
					TCT.CONS_ID IN (SELECT PARTNER_ID FROM COMPANY_PARTNER WHERE RELATED_CONSUMER_ID = #attributes.cid#)
				)
			</cfif>
		ORDER BY 
			STARTDATE DESC
</cfquery>
<cf_ajax_list>
	<thead>
		<tr>
			<th><cf_get_lang dictionary_id='57742.Tarih'></th>
			<th><cf_get_lang dictionary_id='57570.Ad Soyad'></th>
			<th><cf_get_lang dictionary_id='57419.Eğitim'></th>
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
				<td width="250"><a href="#request.self#?fuseaction=training_management.form_upd_class&class_id=#class_id#" class="tableyazi">#class_name#</a></td>
			</tr>
		</cfoutput>
		<cfelse>
		<tr>
			<td colspan="3"><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
		</tr>
	</cfif>
    </tbody>
</cf_ajax_list>
