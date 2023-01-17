<cfquery name="GET_OFFER" datasource="#DSN3#">
	SELECT
		OPP_ID,
        COMPANY_ID,
        PARTNER_ID,
        OFFER_DATE,
        OFFER_NUMBER,
        REF_PARTNER_ID,
        REF_COMPANY_ID,
        REF_CONSUMER_ID,
        OFFER_STAGE,
        OFFER_HEAD,
        SALES_ADD_OPTION_ID,
        FINISHDATE,
        SALES_EMP_ID,
        OFFER_ZONE,
        PROJECT_ID,
        PRICE,
        OTHER_MONEY_VALUE,
        SALES_PARTNER_ID,
        SA_DISCOUNT,
        IS_PROCESSED,
        RECORD_MEMBER,
        RECORD_DATE,
        UPDATE_MEMBER,
        UPDATE_DATE
	FROM
		OFFER
	WHERE
		OFFER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.offer_id#">
</cfquery>

<cfif len(get_offer.project_id)>
    <cfquery name="GET_PROJECT" datasource="#DSN#">
        SELECT PROJECT_HEAD, PROJECT_ID FROM PRO_PROJECTS WHERE PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_offer.project_id#">
    </cfquery>
</cfif>

<cfif len(get_offer.offer_stage)>
	<cfquery name="PROCESS_TYPE" datasource="#DSN#">
		SELECT STAGE, PROCESS_ROW_ID FROM PROCESS_TYPE_ROWS WHERE PROCESS_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_offer.offer_stage#">
	</cfquery>
</cfif>
                        
<cfquery name="GET_OFFER_ROW" datasource="#DSN3#">
	SELECT
		PRICE
	FROM
		OFFER_ROW
	WHERE
		OFFER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.offer_id#">
</cfquery>

<cfif len(get_offer.company_id)>
    <cfquery name="GET_COMPANY" datasource="#DSN#">
        SELECT
            COMPANY_ID,
            FULLNAME
        FROM
            COMPANY 
        WHERE
            COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_offer.company_id#">
    </cfquery>
</cfif>

<cfif len(get_offer.partner_id)>
    <cfquery name="GET_PARTNER" datasource="#DSN#">
        SELECT 
            PARTNER_ID,
            COMPANY_PARTNER_NAME,
            COMPANY_PARTNER_SURNAME
        FROM 
            COMPANY_PARTNER
        WHERE 
            PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_offer.partner_id#">
    </cfquery>
</cfif>

<table border="0" cellpadding="0" cellspacing="0" align="center" style="width:98%">
	<tr style="height:35px;">
		<td class="headbold">Teklif: <cfoutput>#get_offer.offer_number#</cfoutput></td>
		<td align="right">
		</td>
	</tr>
</table>

<table cellpadding="2" cellspacing="1" border="0" class="color-border" align="center" style="width:98%">	
	<tr>
		<td class="color-row">
			<table>
				<cfset member_name_ = "">
                <cfif len(get_offer.ref_partner_id)>
                    <cfset member_name_= get_par_info(get_offer.ref_partner_id,0,-1,0)>
                </cfif>
                <tr style="height:20px;">
                    <td><cf_get_lang_main no='159.Unvan'></td>
                    <td>
                        <cfif len(get_offer.company_id)>
                            <cfoutput><a href="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.detail_company&cpid=#get_company.company_id#" class="tableyazi">#get_company.fullname# - #get_partner.company_partner_name# #get_partner.company_partner_surname#</a></cfoutput>
                        </cfif>
                    </td>
                </tr>
                <tr>
                    <td><cf_get_lang_main no='68.Başlık'> *</td>
                    <td><cfoutput>#get_offer.offer_head#</cfoutput></td>
                </tr>
                <tr>
                    <td>Teklif Tarihi</td>
                    <td>
                        <cfoutput>#dateformat(get_offer.offer_date,'dd/mm/yyyy')#</cfoutput>
                    </td>
                </tr>
                <tr>
                    <td>Tutar</td>
                    <td>
                        <cfoutput>#TLformat(get_offer.price,2)# #session.pda.money#</cfoutput>
                    </td>
                </tr>
                <tr>
                    <td>Dövizli Tutar</td>
                    <td>
                        <cfoutput>#TLformat(get_offer.other_money_value,2)# #session.pda.money#</cfoutput>
                    </td>
                </tr>
                <tr>
                    <td>Proje</td>
                    <td>
                        <cfif len(get_offer.project_id)>
                            <cfoutput>#get_project.project_head#</cfoutput>
                        <cfelse> 
                            Projesiz
                        </cfif>
                    </td>
                </tr>
                <tr>
                    <td>Yöntem</td>
                    <td>
                        <cfif get_offer.offer_zone eq 0>Verilen
                        <cfelseif get_offer.offer_zone eq 1>Partner
                        <cfelseif get_offer.offer_zone eq 2>Public
                        </cfif>
                    </td>
                </tr>
                <tr style="height:40px;">
                    <td style="vertical-align:top;">Aşama</td>
                    <td style="vertical-align:top;"><cfif len(get_offer.offer_stage)><cfoutput>#process_type.stage#</cfoutput></cfif></td>
                </tr>
                <tr>
                    <td colspan="2" align="left">
                        <cfoutput>
                            <cf_get_lang_main no='71.Kayit'> :
                            #get_emp_info(get_offer.record_member,0,0)# #dateformat(date_add('h',session.pda.time_zone,get_offer.record_date),'dd/mm/yyyy')# #timeformat(date_add('h',session.pda.time_zone,get_offer.record_date),'HH:MM')#
                            <cfif len(get_offer.update_member)>
                                <br>Güncelleme : #get_emp_info(get_offer.update_member,0,0)# #dateformat(date_add('h',session.pda.time_zone,get_offer.update_date),'dd/mm/yyyy')# #timeformat(date_add('h',session.pda.time_zone,get_offer.update_date),'HH:MM')#
                            </cfif>
                        </cfoutput>
                    </td>
                </tr>		
			</table>
		</td>
	</tr>
</table>
<br>
