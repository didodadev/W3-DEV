<cf_get_lang_set module_name="ch">
<cfif isdefined("attributes.period_id") and len(attributes.period_id) >
	<cfquery name="get_period" datasource="#DSN#">
		SELECT PERIOD_YEAR,OUR_COMPANY_ID FROM SETUP_PERIOD WHERE PERIOD_ID = #attributes.period_id#
	</cfquery>
	<cfset db_adres = "#dsn#_#get_period.period_year#_#get_period.our_company_id#">
<cfelse>
	<cfset db_adres = "#dsn2#">
</cfif>
<cfquery name="GET_CARI_OPEN" datasource="#db_adres#">
	SELECT 
		CR.ACTION_CURRENCY_ID,
		CR.ACTION_CURRENCY_2,
		CR.ACTION_NAME,
		CR.TO_CMP_ID,
		CR.FROM_CMP_ID,
		CR.ACTION_VALUE,
		CR.ACTION_VALUE_2,
		CR.OTHER_MONEY,
		CR.OTHER_CASH_ACT_VALUE,
		C.NICKNAME,
		CR.ACTION_DATE
	FROM 
		CARI_ROWS CR,
		#dsn_alias#.COMPANY C 
	WHERE 
		CR.ACTION_TYPE_ID=40 AND 
		(CR.FROM_CMP_ID = C.COMPANY_ID OR CR.TO_CMP_ID = C.COMPANY_ID)
	UNION ALL
	SELECT 
		CR.ACTION_CURRENCY_ID,
		CR.ACTION_CURRENCY_2,
		CR.ACTION_NAME,
		CR.TO_CMP_ID,
		CR.FROM_CMP_ID,
		CR.ACTION_VALUE,
		CR.ACTION_VALUE_2,
		CR.OTHER_MONEY,
		CR.OTHER_CASH_ACT_VALUE,
		C.CONSUMER_NAME+' '+C.CONSUMER_SURNAME NICKNAME,
		CR.ACTION_DATE
	FROM 
		CARI_ROWS CR,
		#dsn_alias#.CONSUMER C 
	WHERE 
		CR.ACTION_TYPE_ID=40 AND 
		(CR.FROM_CONSUMER_ID = C.CONSUMER_ID OR CR.TO_CONSUMER_ID = C.CONSUMER_ID)
</cfquery>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default=#GET_CARI_OPEN.recordcount#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfquery name="GET_CARD" datasource="#dsn2#">
	SELECT
		ACS.CARD_ID
	FROM
		ACCOUNT_CARD ACS
	WHERE
		ACS.ACTION_TYPE = 40
		AND ACS.ACTION_ID = #attributes.id#
</cfquery>
<cfsavecontent variable="right">
	<cfif GET_CARD.recordcount  and isdefined("session.ep.user_level") and listgetat(session.ep.user_level,22)>
		<li><a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=account.popup_list_card_rows&action_id=#attributes.id#&process_cat=40</cfoutput>','page');" class="font-red-pink"><span class="icn-md icon-chart" title="<cfoutput>#getLang('main',2577)#</cfoutput>"></span></a></li>
	</cfif>
</cfsavecontent>

<cf_box title="#getLang('ch',7)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#" right_images="#right#">
	<cfform method="post" name="dsp_ch">
		<cf_grid_list>
			<thead>
				<tr>
					<th><cf_get_lang dictionary_id='57487.No'></th>
					<th><cf_get_lang dictionary_id='57652.Hesap'></th>
					<th><cf_get_lang dictionary_id='57692.İşlem'></th>
					<th><cf_get_lang dictionary_id='57673.Tutar'> </th>
					<th><cfoutput>#session.ep.money2#</cfoutput></th>
					<th><cf_get_lang dictionary_id='58121.İşlem Dövizi'></th>
				</tr>		
			</thead>
			
				<tbody>
					<cfif get_cari_open.recordcount>
						<cfoutput query="get_cari_open" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
							<tr class="color-row">
								<td>#currentrow#</td>
								<td>#NICKNAME#</td>
								<td>#dateformat(ACTION_DATE,dateformat_style)#</td>
								<td class="text-right">#TLFormat(ACTION_VALUE)#&nbsp;<cfif len(TO_CMP_ID)>(<cf_get_lang dictionary_id='58591.B'>)<cfelse>(<cf_get_lang dictionary_id='29684.A'>)</cfif>&nbsp;#ACTION_CURRENCY_ID#</td>
								<td class="text-right">#TLFormat(ACTION_VALUE_2)#&nbsp;<cfif len(TO_CMP_ID)>(<cf_get_lang dictionary_id='58591.B'>)<cfelse>(<cf_get_lang dictionary_id='29684.A'>)</cfif>&nbsp;<cfif len(session.ep.money2)>#ACTION_CURRENCY_2#</cfif></td>
								<td class="text-right">#TLFormat(OTHER_CASH_ACT_VALUE)#&nbsp;<cfif len(TO_CMP_ID)>(<cf_get_lang dictionary_id='58591.B'>)<cfelse>(<cf_get_lang dictionary_id='29684.A'>)</cfif>&nbsp;<cfif len(session.ep.money2)>#OTHER_MONEY#</cfif></td>
							</tr>
						</cfoutput>
					<cfelse>
						<tr class="color-row" >
							<td colspan="6"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
						</tr>
					</cfif>		
				</tbody>
			
		</cf_grid_list>
	</cfform>
	<cfif attributes.maxrows lt attributes.totalrecords>
		<cfset adres="ch.popup_dsp_account_open" >
		<cfif isDefined('attributes.action') and len(attributes.action)>
			<cfset adres = adres&"&action="&attributes.action>
		</cfif>
		<cfif isDefined('attributes.keyword') and len(attributes.keyword)>
			<cfset adres = adres&"&keyword="&attributes.keyword>
		</cfif>
		<cfif isDefined('attributes.oby') and len(attributes.oby)>
			<cfset adres = adres&'&oby='&attributes.oby>
		</cfif>
		<cfif isDefined('attributes.id') and len(attributes.id)>
			<cfset adres = adres&'&id='&attributes.id>
		</cfif>
		<cf_paging 
			page="#attributes.page#" 
			maxrows="#attributes.maxrows#" 
			totalrecords="#attributes.totalrecords#" 
			startrow="#attributes.startrow#" 
			adres="#adres#"
			isAjax="#iif(isdefined("attributes.draggable"),1,0)#">
	</cfif>
</cf_box>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
