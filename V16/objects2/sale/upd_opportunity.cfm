<!---<cfinclude template="../query/get_emps_pars_cons.cfm">--->
<cfquery name="GET_COMPANY_PARTNERS" datasource="#DSN#">
	SELECT PARTNER_ID,COMPANY_PARTNER_NAME,COMPANY_PARTNER_SURNAME FROM COMPANY_PARTNER WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.company_id#">
</cfquery>
<cfquery name="GET_OPPORTUNITY" datasource="#DSN3#">
	SELECT 
		PARTNER_ID, 
		COMPANY_ID,
        CONSUMER_ID, 
		OPP_HEAD, 
		OPP_ID, 
		OPP_NO, 
		OPP_STATUS, 
		OPP_DETAIL, 
		OPP_DATE, 
		OPPORTUNITY_TYPE_ID, 
		SALES_PARTNER_ID, 
		ACTIVITY_TIME, 
		OPP_CURRENCY_ID,
		IS_PROCESSED,
		RECORD_PAR,
		COMMETHOD_ID, 
		PROBABILITY,
		COST,
		INCOME,
		SALE_ADD_OPTION_ID, 
		MONEY, 
		RECORD_EMP,
		RECORD_PAR,
		RECORD_IP,
		RECORD_DATE,
		UPDATE_EMP,
		UPDATE_PAR,
		UPDATE_IP,
		UPDATE_DATE,
		PROJECT_ID 
	FROM 
		OPPORTUNITIES 
	WHERE 
		OPP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.opp_id#"> AND 
		SALES_PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#">
</cfquery>
<cfif not get_opportunity.recordcount>
	<br/><font class="txtbold"><!---<cf_get_lang_main no='1531.Böyle Bir Kayıt Bulunmamaktadır'>--->Satış Çalışanı Olmadığınız Fırsatlar Üzerinde Güncelleme Yapamazsınız!</font>
	<cfexit method="exittemplate">
</cfif>
<cfquery name="GET_PROJECT" datasource="#DSN#">
	SELECT 
		DISTINCT(PRO_PROJECTS.PROJECT_ID),
		PRO_PROJECTS.PROJECT_HEAD
	FROM 
		WORK_GROUP WG,
		WORKGROUP_EMP_PAR WEP,
		PRO_PROJECTS
	WHERE
		WG.WORKGROUP_ID = WEP.WORKGROUP_ID AND 
		(	
			PRO_PROJECTS.PROJECT_ID = WG.PROJECT_ID OR 
			WG.PROJECT_ID IS NULL 
		)
		AND
		(	
			PRO_PROJECTS.OUTSRC_PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#"> OR
			PRO_PROJECTS.OUTSRC_CMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.company_id#"> OR
			PRO_PROJECTS.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.company_id#"> OR
			PRO_PROJECTS.UPDATE_PAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#"> OR
			PRO_PROJECTS.RECORD_PAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#"> OR
			WEP.PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#"> OR
			WEP.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.company_id#">
		)
		AND PRO_PROJECTS.PROJECT_STATUS=1
</cfquery>
<cfquery name="GET_OPP_CURRENCIES" datasource="#DSN3#">
	SELECT OPP_CURRENCY_ID, OPP_CURRENCY FROM OPPORTUNITY_CURRENCY ORDER BY OPP_CURRENCY
</cfquery>
<cfquery name="GET_COMMETHOD_CATS" datasource="#dsn#">
	SELECT COMMETHOD_ID, COMMETHOD FROM SETUP_COMMETHOD ORDER BY COMMETHOD
</cfquery>
<cfinclude template="../query/get_moneys.cfm">
<cfquery name="GET_OPPORTUNITY_TYPE" datasource="#DSN3#">
	SELECT OPPORTUNITY_TYPE_ID, OPPORTUNITY_TYPE FROM SETUP_OPPORTUNITY_TYPE WHERE IS_INTERNET = 1 ORDER BY OPPORTUNITY_TYPE
</cfquery>
<cfquery name="GET_SALE_ADD_OPTION" datasource="#DSN3#">
	SELECT SALES_ADD_OPTION_ID,SALES_ADD_OPTION_NAME FROM SETUP_SALES_ADD_OPTIONS WHERE IS_INTERNET = 1
</cfquery>
<table border="0" cellspacing="0" cellpadding="5" style="width:100%">
	<tr style="height:35px;">
    	<td class="headbold"><cf_get_lang_main no='200.Fırsat'>: <cfif len(get_opportunity.partner_id)><a href="<cfoutput>#request.self#?fuseaction=objects2.upd_my_member&company_id=#get_opportunity.company_id#</cfoutput>" class="tableyazi"><cfoutput>#get_par_info(get_opportunity.company_id,1,0,0)#</cfoutput></a><cfelseif len(get_opportunity.consumer_id)><a href="<cfoutput>#request.self#?fuseaction=objects2.upd_my_consumer&consumer_id=#get_opportunity.consumer_id#</cfoutput>" class="tableyazi"><cfoutput>#get_cons_info(get_opportunity.consumer_id,0,0,0)#</cfoutput></a><cfelse><cfoutput>#get_opportunity.opp_head#</cfoutput></cfif></td>
        <td></td>
    </tr>
    <tr>
		<td style="vertical-align:top">
        	<cf_box>
            	<cfinclude template="opportunity_form.cfm">
            </cf_box>
            <cfsavecontent variable="pluss"><cf_get_lang no ='608.Takipler'></cfsavecontent>
            <cf_box title="#pluss#" id="SHOW_LIST_PAGE" add_href=""  closable="0">
            	<cfinclude template="list_opportunity_plus.cfm">
            </cf_box>
			<br/>
		</td>
        <cfif (isdefined('attributes.is_opp_asset') and attributes.is_opp_asset eq 1) or (isdefined('attributes.is_opp_event') and attributes.is_opp_event eq 1)>
			<td style="width:200px; vertical-align:top">
				<cfif isdefined('attributes.is_opp_asset') and attributes.is_opp_asset eq 1>
                	<cfsavecontent variable="assets"><cf_get_lang_main no ='156.Belgeler'></cfsavecontent>
					<cf_box title="#assets#" closable="0">
                    	<cfinclude template="opp_relation_asset.cfm">
                    </cf_box>
				</cfif>
				<cfif isdefined('attributes.is_opp_event') and attributes.is_opp_event eq 1>
                	<cfsavecontent variable="events"><cf_get_lang_main no ='581.Olaylar'></cfsavecontent>
					<cf_box title="#events#" add_href="#request.self#?fuseaction=objects2.form_add_event&action_id=#attributes.opp_id#&action_section=OPPORTUNITY_ID" closable="0">
					<cfinclude template="opportunity_relation_events.cfm">
                    </cf_box>
				</cfif>
				<cfif isdefined('attributes.is_opp_analyse') and attributes.is_opp_analyse eq 1>
                	<cfsavecontent variable="analyss"><cf_get_lang_main no ='1387.Analizler'></cfsavecontent>
					<cf_box title="#analyss#"  closable="0">
                    <cfinclude template="../survey/list_analyses.cfm">
                    </cf_box>
				</cfif>
			</td>
		</cfif>
    </tr>
</table>
<br/>

<script type="text/javascript">
	function kontrol()
	{
		if (document.upd_opp.opportunity_type_id[upd_opp.opportunity_type_id.selectedIndex].value == '')
		{
			alert ("<cf_get_lang_main no='1535.Kategori Seçmelisiniz'>");
			return false;
		}
		if (document.getElementById('to_par_ids') == undefined && document.getElementById('to_cons_ids') == undefined)
		{
			alert ("<cf_get_lang no='467.Müşteri Seçmelisiniz'>!");
			return false;
		}	
		/*if ((document.getElementById('member_name').value == '' || document.getElementById('partner_id').value == '') && (document.getElementById('member_name').value == '' || document.getElementById('consumer_id').value == ''))
		{
			alert ("<cf_get_lang no='467.Müşteri Seçmelisiniz'>!");
			return false;
		}*/
		//return OnFormSubmit();
	}
	
	function unformat_fields()
	{
		document.getElementById('income').value = filterNum(document.getElementById('income').value);
		document.getElementById('cost').value = filterNum(document.getElementById('cost').value);
	}
</script>
