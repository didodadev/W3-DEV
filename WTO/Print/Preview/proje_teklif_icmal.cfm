<cfquery name="OUR_COMPANY" datasource="#DSN#">
	SELECT 
		ASSET_FILE_NAME1,
		ASSET_FILE_NAME1_SERVER_ID
	FROM 
	    OUR_COMPANY 
	WHERE 
	   <cfif isDefined("SESSION.EP.COMPANY_ID")>
		COMP_ID = #SESSION.EP.COMPANY_ID#
	<cfelseif isDefined("SESSION.PP.COMPANY")>	
		COMP_ID = #SESSION.PP.COMPANY#
	</cfif>
</cfquery>
<cfquery name="GET_ORDER_CURRENCIES" datasource="#dsn3#">
	SELECT
		ORDER_CURRENCY_ID, 
		ORDER_CURRENCY
	FROM
		ORDER_CURRENCY
	ORDER BY
		ORDER_CURRENCY
</cfquery>
<cfset order_currency_list = valuelist(GET_ORDER_CURRENCIES.ORDER_CURRENCY_ID)>
<cfquery name="GET_OFFER_CURRENCIES" datasource="#dsn3#">
	SELECT 
		OFFER_CURRENCY_ID, 
		OFFER_CURRENCY 
	FROM 
		OFFER_CURRENCY
	ORDER BY
		OFFER_CURRENCY
</cfquery>
<cfset offer_currency_list = valuelist(GET_OFFER_CURRENCIES.OFFER_CURRENCY_ID)>

<cfquery name="PROJECT_DETAIL" datasource="#dsn#">
	SELECT 
		*
	FROM 
		PRO_PROJECTS,		
		SETUP_PRIORITY
	WHERE
		PRO_PROJECTS.PROJECT_ID=#attributes.action_id# AND 		
		PRO_PROJECTS.PRO_PRIORITY_ID=SETUP_PRIORITY.PRIORITY_ID 
	ORDER BY 
		PRO_PROJECTS.RECORD_DATE
</cfquery>

<cfquery name="GET_LAST_REC" datasource="#dsn#">
	SELECT
		MAX(HISTORY_ID) AS HIS_ID
	FROM
		PRO_HISTORY
	WHERE
		PROJECT_ID=#attributes.action_id#		
</cfquery>

<cfset hist_id=get_last_rec.HIS_ID>

<cfif LEN(hist_id)>
	<cfquery name="GET_HIST_DETAIL" datasource="#dsn#">
		SELECT
			*
		FROM
			PRO_HISTORY,
			SETUP_PRIORITY
		WHERE
			PRO_HISTORY.PRO_PRIORITY_ID=SETUP_PRIORITY.PRIORITY_ID AND
			PRO_HISTORY.HISTORY_ID = #HIST_ID#
	</cfquery>
</cfif>
<cfquery name="get_pro_work" datasource="#DSN#">
	SELECT
		*
	FROM
		PRO_WORKS,
		SETUP_PRIORITY
	WHERE
		PRO_WORKS.WORK_PRIORITY_ID=SETUP_PRIORITY.PRIORITY_ID AND
		PRO_WORKS.PROJECT_ID = #ATTRIBUTES.action_id#
	ORDER BY
		PRO_WORKS.TARGET_FINISH ASC	
</cfquery>
<cfif get_pro_work.recordcount>
	<cfquery name="GET_MATERIALS" datasource="#DSN#">
		SELECT
			PRO_MATERIAL_ID,
			WORK_ID,
			NETTOTAL
		FROM
			PRO_MATERIAL
		WHERE
			WORK_ID IN (#valuelist(get_pro_work.work_id)#)
	</cfquery>
</cfif>
<table border="0"  cellpadding="1" cellspacing="1" width="700" align="center">
	<tr>
		<td height="50" class="headbold"></td>
	</tr>
</table>
<table border="1" cellpadding="1" cellspacing="1" width="700" align="center">
<tr bordercolor="000000">
<td>
<table cellpadding="0" cellspacing="0" border="0" width="700" align="center">
  <tr height="16">
	  <td class="txtbold" width="30"><cf_get_lang_main no='4.PROJE'></td>
	  <td><cfoutput>:#PROJECT_DETAIL.PROJECT_HEAD#</cfoutput></td>
	  <td rowspan="4" style="text-align:right;"><cf_get_server_file output_file="settings/#our_company.asset_file_name1#" output_server="#our_company.asset_file_name1_server_id#" output_type="0"></td>
  </tr>  
  <cfif len(PROJECT_DETAIL.AGREEMENT_NO)>
  <tr height="16">
	  <td class="txtbold"><cf_get_lang_main no='1725.SÖZLEŞME NO'></td>
	  <td><cfoutput>:#PROJECT_DETAIL.AGREEMENT_NO#</cfoutput></td>
  </tr>
  </cfif>
	 <tr height="16">
	  <td class="txtbold">İŞVEREN</td>
	  <td>
		<cfif len(PROJECT_DETAIL.PARTNER_ID)>
			<cfoutput>:#GET_PAR_INFO(PROJECT_DETAIL.PARTNER_ID,0,1,0)#</cfoutput>
		<cfelseif len(PROJECT_DETAIL.CONSUMER_ID)>
			<cfoutput>:#GET_CONS_INFO(PROJECT_DETAIL.CONSUMER_ID,0,0)#</cfoutput>
		</cfif>
	  </td>
	 </tr>
	 <tr height="16">
		<td class="txtbold">PROJE LİDERİ</td>
	    <td>
			<cfif get_hist_detail.PROJECT_EMP_ID neq 0 and len(get_hist_detail.PROJECT_EMP_ID)>
				<cfoutput>:#GET_EMP_INFO(get_hist_detail.PROJECT_EMP_ID,0,0)#</cfoutput>
			</cfif>						
			<cfif (project_detail.OUTSRC_PARTNER_ID NEQ 0) and len(project_detail.OUTSRC_PARTNER_ID)>
				<cfoutput>:#GET_PAR_INFO(project_detail.OUTSRC_PARTNER_ID,0,0,0)#</cfoutput>
			</cfif>
	  	</td>
	</tr>
</table>
</td>
</tr>
</table>
  
<br/><br/><br/>
<table border="0"  cellpadding="1" cellspacing="1" width="700" align="center">
	<tr>
		<td height="50" class="headbold" align="center"><font size="5" face="Verdana, Arial, Helvetica, sans-serif">TEKLİF İCMALİ</FONT></td>
	</tr>
</table>
<cfset genel_toplam=0>
<cfoutput query="get_pro_work">
<cfset yerel_toplam=0>
		<cfquery name="GET_MATERIAL" dbtype="query">
			SELECT
				PRO_MATERIAL_ID,
				NETTOTAL
			FROM
				GET_MATERIALS
			WHERE
				WORK_ID IN (#WORK_ID#)
		</cfquery>
		<cfif len(GET_MATERIAL.NETTOTAL)>
			<cfset yerel_toplam=yerel_toplam+GET_MATERIAL.NETTOTAL>
		</cfif>
		<table cellpadding="1" cellspacing="1" border="0" width="700" align="center">
			<tr>
				<td nowrap="nowrap" class="txtbold"><font size="2"> #currentrow# - &nbsp;&nbsp;#WORK_HEAD#&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</font></td>
				<td style="text-align:right;" class="txtbold">#TLFORMAT(yerel_toplam)# #session.ep.money#</td>
			</tr>	
		</table>
			<cfset genel_toplam=genel_toplam+yerel_toplam>
</cfoutput>
<table border="0"  cellpadding="1" cellspacing="1" width="700" align="center">
	<tr>
		<td height="50" class="txtbold"><font size="3" face="Verdana, Arial, Helvetica, sans-serif"><cf_get_lang_main no='268.GENEL TOPLAM'></FONT></td><td style="text-align:right;" class="txtbold"><cfoutput>#TLFormat(genel_toplam)# #session.ep.money#</cfoutput></td>
	</tr>
</table>


