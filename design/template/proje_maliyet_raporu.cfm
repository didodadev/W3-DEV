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
<cfquery name="GET_MATERIALS" datasource="#DSN#">
	SELECT
		PRO_MATERIAL_ROW.PRICE,
		PRO_MATERIAL_ROW.PRO_MATERIAL_ID,
		PRO_MATERIAL_ROW.COST_PRICE,
		PRO_MATERIAL_ROW.AMOUNT
	FROM
		PRO_MATERIAL,
		PRO_MATERIAL_ROW
	WHERE
		PRO_MATERIAL.PROJECT_ID = #attributes.action_id# AND
		PRO_MATERIAL.PRO_MATERIAL_ID = PRO_MATERIAL_ROW.PRO_MATERIAL_ID
</cfquery>
<br/><br/>
<table border="0"  cellpadding="1" cellspacing="1" style="width:200mm;" align="center">
	<tr>
    	<td width="40">&nbsp;</td>
		<td><cf_get_server_file output_file="settings/#our_company.asset_file_name1#" output_server="#our_company.asset_file_name1_server_id#" output_type="5"></td>
		<td align="left" class="headbold"><font size="+2">TEKLİF MALİYET RAPORU</font></td>
	</tr>
</table>
<br/><br/><br/>
<table cellpadding="3" cellspacing="0" border="1" style="width:170mm;" align="center">
    <tr>
        <td class="txtbold" colspan="2">İşin Adı : <cfoutput>#PROJECT_DETAIL.PROJECT_HEAD#</cfoutput></td> 
    </tr>
    <tr>
        <td class="txtbold" colspan="2"><cf_get_lang_main no='800.Teklif No'> : <cfif len(PROJECT_DETAIL.AGREEMENT_NO)><cfoutput>#PROJECT_DETAIL.AGREEMENT_NO#</cfoutput></cfif></td>
    </tr>
	<tr class="txtbold">
        <td width="300" align="center"><cf_get_lang_main no='217.AÇIKLAMA'></td>
        <td align="center">
            <table cellpadding="3" cellspacing="0" border="1"  align="center" style=" width:100%">
                <tr class="txtbold">
                    <td width="200" colspan="2" align="center"><cf_get_lang_main no='133.TEKLİF'>&nbsp;&nbsp;&nbsp;&nbsp;</td>
                </tr>
                <tr class="txtbold">
                    <td align="center" width="50%">TÜRK LİRASI</td>
                    <td align="center" width="50%"><cf_get_lang_main no='265.DÖVİZ'></td>
                </tr>
            </table>
		</td>
	</tr>
</table>
<br/>
<cfset alis_toplam=0>
<cfset satis_toplam=0>
<cfset usd_toplam1=0>
<cfset usd_toplam2=0>
<cfset fark=0>
<cfset fark_usd=0>
<cfif GET_MATERIALS.recordcount>
	<cfoutput query="get_materials">
       <cfquery name="GET_MONEY" datasource="#DSN#">
		SELECT
			RATE2
		FROM
			PRO_MATERIAL_MONEY
		WHERE
			ACTION_ID=#GET_MATERIALS.PRO_MATERIAL_ID# AND
			MONEY_TYPE = '#session.ep.money2#'
	    </cfquery>
		<cfset alis_toplam=alis_toplam+cost_price*amount>
		<cfset satis_toplam=satis_toplam+price*amount>
		<cfset usd_toplam1=usd_toplam1+((cost_price*amount)/GET_MONEY.RATE2)>
		<cfset usd_toplam2=usd_toplam2+((price*amount)/GET_MONEY.RATE2)>
	</cfoutput>
	<cfset fark=satis_toplam-alis_toplam>
	<cfset fark_usd=fark/get_money.rate2>
</cfif>
<table border="0"  cellpadding="1" cellspacing="1" style="width:200mm;" align="center">
	<tr><td width="50">&nbsp;</td>
		<td align="left" class="headbold">MALZEME</td>
	</tr>
</table>
<table cellpadding="3" cellspacing="0" border="1" style="width:170mm;" align="center">
	<tr>
        <td width="300">Toplam Malzeme Alışı</td>
        <td style="text-align:right;"><cfoutput>#TLFormat(alis_toplam)# #session.ep.money#</cfoutput></td>
        <td style="text-align:right;"><cfoutput>#TLFormat(usd_toplam1)# #session.ep.money2#</cfoutput></td>
	</tr>
	<tr>
        <td>Toplam Malzeme Satışı</td>
        <td style="text-align:right;"><cfoutput>#TLFormat(satis_toplam)# #session.ep.money#</cfoutput></td>
        <td style="text-align:right;"><cfoutput>#TLFormat(usd_toplam2)# #session.ep.money2#</cfoutput></td>
	</tr>
	<tr>
        <td>Malzeme Karı</td>
        <td style="text-align:right;"><cfoutput>#TLFormat(fark)# #session.ep.money#</cfoutput></td>
        <td style="text-align:right;"><cfoutput>#TLFormat(fark_usd)# #session.ep.money2#</cfoutput></td>
	</tr>
	<tr>
        <td>%Kar</td>
        <td style="text-align:right;"><cfoutput><cfif alis_toplam gt 0>#TLFormat(fark/alis_toplam)#<cfelse>0</cfif>%</cfoutput></td>
        <td>&nbsp;</td>
	</tr>
</table>
