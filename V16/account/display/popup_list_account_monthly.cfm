<cfparam name="attributes.startdate" default="01/#month(now())#/#SESSION.EP.PERIOD_YEAR#">
<cfparam name="attributes.finishdate" default="#dateformat(now(),dateformat_style)#">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.maxrows" default="#session.ep.maxrows#">
<cfquery name="get_money" datasource="#dsn2#">
	SELECT MONEY FROM SETUP_MONEY WHERE MONEY_STATUS =1<!---  AND MONEY <> '#session.ep.money#' --->
</cfquery>
<cfset money_list=valuelist(get_money.MONEY)>
<cfloop  list="#money_list#" index="kk">
	<cfset 'toplam_#kk#'=0>
	<cfset 'alacak_#kk#'=0>
	<cfset 'other_bakiye_#kk#'=0>
</cfloop>
<cfquery name="get_sub_acount" datasource="#dsn2#">
	SELECT SUB_ACCOUNT FROM ACCOUNT_PLAN WHERE ACCOUNT_CODE = '#CODE#'
</cfquery>
<cfquery name="GET_BORC" datasource="#dsn2#">
	SELECT
		SUM(ACR.AMOUNT) AS AMOUNT,
		SUM(ACR.AMOUNT_2) AS AMOUNT_2,
		ACR.AMOUNT_CURRENCY_2,
	<cfif (database_type is 'MSSQL')>
		Datepart("m",ACTION_DATE) AS BU_AY
	<cfelseif (database_type is 'DB2')>
		MONTH(ACTION_DATE) AS BU_AY
	</cfif>				
	FROM
		ACCOUNT_CARD_ROWS ACR,
		ACCOUNT_CARD AC
	WHERE
		<cfif get_sub_acount.SUB_ACCOUNT eq 1>
			ACR.ACCOUNT_ID LIKE '#CODE#.%' AND
		<cfelse>
			ACR.ACCOUNT_ID = '#CODE#' AND
		</cfif>
			ACR.CARD_ID=AC.CARD_ID AND
			ACR.BA = 0			
	GROUP BY
		<cfif (database_type is 'MSSQL')>
			Datepart("m",ACTION_DATE),
		<cfelseif (database_type is 'DB2')>
			MONTH(ACTION_DATE),
		</cfif>		
		ACR.AMOUNT_CURRENCY_2
</cfquery>
<cfset borc_ay_list=ListDeleteDuplicates(valuelist(GET_BORC.BU_AY))>
<cfquery name="GET_ALACAK" datasource="#dsn2#">
	SELECT
		SUM(ACR.AMOUNT) AS AMOUNT,
		SUM(ACR.AMOUNT_2) AS AMOUNT_2,
		ACR.AMOUNT_CURRENCY_2,
	<cfif (database_type is 'MSSQL')>
		Datepart("m",ACTION_DATE) AS BU_AY
	<cfelseif (database_type is 'DB2')>
		MONTH(ACTION_DATE) AS BU_AY
	</cfif>				
	FROM
		ACCOUNT_CARD_ROWS ACR,
		ACCOUNT_CARD AC
	WHERE
		<cfif get_sub_acount.SUB_ACCOUNT eq 1>
			ACR.ACCOUNT_ID LIKE '#CODE#.%' AND
		<cfelse>
			ACR.ACCOUNT_ID = '#CODE#' AND
		</cfif>
			ACR.CARD_ID=AC.CARD_ID AND
			ACR.BA = 1		
	GROUP BY
		<cfif (database_type is 'MSSQL')>
			Datepart("m",ACTION_DATE),
		<cfelseif (database_type is 'DB2')>
			MONTH(ACTION_DATE),
		</cfif>		
		ACR.AMOUNT_CURRENCY_2
</cfquery>
<cfset alacak_ay_list=ListDeleteDuplicates(valuelist(GET_ALACAK.BU_AY))>
<cfquery name="OTHER_BORC_ALACAK" datasource="#dsn2#">
	SELECT
		SUM(ACR.OTHER_AMOUNT) AS OTHER_AMOUNT,
		ACR.OTHER_CURRENCY,
	<cfif (database_type is 'MSSQL')>
		Datepart("m",ACTION_DATE) AS BU_AY,
	<cfelseif (database_type is 'DB2')>
		MONTH(ACTION_DATE) AS BU_AY,
	</cfif>				
		ACR.BA AS BORC_ALACAK
	FROM
		ACCOUNT_CARD_ROWS ACR,
		ACCOUNT_CARD AC
	WHERE
		<cfif get_sub_acount.SUB_ACCOUNT eq 1>
			ACR.ACCOUNT_ID LIKE '#CODE#.%' AND
		<cfelse>
			ACR.ACCOUNT_ID = '#CODE#' AND
		</cfif>
			ACR.CARD_ID=AC.CARD_ID AND 
			ACR.OTHER_CURRENCY IS NOT NULL
	GROUP BY
		<cfif (database_type is 'MSSQL')>
			Datepart("m",ACTION_DATE),
		<cfelseif (database_type is 'DB2')>
			MONTH(ACTION_DATE),
		</cfif>		
			ACR.OTHER_CURRENCY,
			ACR.BA		
</cfquery>
<cfscript>
	borc_total = 0 ;
	alacak_total = 0 ;
	borc2_total = 0 ;
	alacak2_total = 0 ;
	bakiye_total = 0 ;
	bakiye2_total = 0 ;
</cfscript>	
<cfsavecontent variable="right">
	<cfif get_sub_acount.SUB_ACCOUNT neq 1>
		<li><a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=account.popup_list_account_plan_rows&code=#attributes.code#</cfoutput>','wide','popup_list_account_plan_rows');">
		<i class="catalyst-bar-chart" alt="<cf_get_lang dictionary_id='57919.Hareketler'>" title="<cf_get_lang dictionary_id='57919.Hareketler'>"></i></a></li>
	</cfif>
</cfsavecontent>
<cf_box title='#SESSION.EP.PERIOD_YEAR# #getLang("main",505)# : #attributes.code#' right_images='#right#' uidrop="1" hide_table_column="1" responsive_table="1"  collapsable="1" resize="1">
	<cf_grid_list>
		<thead>
		<tr>
			<th width="65"><cf_get_lang dictionary_id='58724.Ay'></th>
			<th width="150" style="text-align:right;"><cf_get_lang dictionary_id='57587.Borç'></th>
			<th width="150" style="text-align:right;"><cf_get_lang dictionary_id='57588.Alacak'></th>
			<th width="150" style="text-align:right;"><cf_get_lang dictionary_id='57589.Bakiye'></th>
			<cfif len(session.ep.money2)>
				<cfoutput>
				<th  style="text-align:right;">#session.ep.money2# <cf_get_lang dictionary_id='57587.Borç'></th>
				<th  nowrap="nowrap" style="text-align:right;">#session.ep.money2# <cf_get_lang dictionary_id='57588.Alacak'></th>
				<th  style="text-align:right;">#session.ep.money2# <cf_get_lang dictionary_id='57589.Bakiye'></th>
				</cfoutput>
			</cfif>
			<cfoutput>
			<cfloop  list="#money_list#" index="kk">
				<th  nowrap="nowrap" style="text-align:right;"><cf_get_lang dictionary_id='58121.İşlem Dövizi'><br /> <cf_get_lang dictionary_id='57587.Borç'>(#kk#)</th>
				<th  nowrap="nowrap" style="text-align:right;"><cf_get_lang dictionary_id='58121.İşlem Dövizi'><br /> <cf_get_lang dictionary_id='57588.Alacak'>(#kk#)</th>
				<th  nowrap="nowrap" style="text-align:right;"><cf_get_lang dictionary_id='58121.İşlem Dövizi'><br /><cf_get_lang dictionary_id='57589.Bakiye'>(#kk#)</th>
			</cfloop>
			</cfoutput>
		</tr>
		</thead>
		<tbody>
		<cfloop from="1" to="12" index= "i">
			<cfset borc = 0>
			<cfset alacak = 0>
			<cfset borc2 = 0>
			<cfset alacak2 = 0>
			<cfquery name="OTHER_AMOUNT_B" dbtype="query">
				SELECT
					SUM(OTHER_AMOUNT) AS OTHER_AMOUNT,
					OTHER_CURRENCY
				FROM
					OTHER_BORC_ALACAK
				WHERE
					BU_AY = #i# AND BORC_ALACAK = 0
				GROUP BY
					OTHER_CURRENCY
			</cfquery>
			<cfset borc_money_list=valuelist(OTHER_AMOUNT_B.OTHER_CURRENCY)>
			<cfquery name="OTHER_AMOUNT_A" dbtype="query">
				SELECT
					SUM(OTHER_AMOUNT) AS OTHER_AMOUNT,
					OTHER_CURRENCY
				FROM
					OTHER_BORC_ALACAK
				WHERE
					BU_AY = #i# AND BORC_ALACAK =1
				GROUP BY
					OTHER_CURRENCY
			</cfquery>
			<cfset alacak_money_list=valuelist(OTHER_AMOUNT_A.OTHER_CURRENCY)>
			<cfoutput>
			<tr>
              <td nowrap="nowrap">#listgetat(ay_list(), i)#</td> 
              <td  nowrap="nowrap" style="text-align:right;">
			  <cfloop query="GET_BORC">
				<cfif GET_BORC.BU_AY eq i>
					<cfset borc = borc + GET_BORC.AMOUNT>
				</cfif>
			  </cfloop>
				#TLFormat(borc)# #session.ep.money#
				<cfset borc_total = borc_total + borc>
			  </td>
              <td  nowrap="nowrap" style="text-align:right;">
			   <cfloop query="GET_ALACAK">
				<cfif GET_ALACAK.BU_AY eq i>
					<cfset alacak = alacak + GET_ALACAK.AMOUNT>
				</cfif>
				</cfloop>
				#TLFormat(alacak)# #session.ep.money#
				<cfset alacak_total = alacak_total + alacak>
			  </td>
              <td  nowrap="nowrap" style="text-align:right;">
				  <cfset bakiye = borc-alacak>
				  	#TLFormat(abs(bakiye))#
				  <cfif bakiye lt 0>
					(A)
				  <cfelseif bakiye gt 0>
					(B)
				  </cfif>
				  <cfset bakiye_total = bakiye_total + bakiye>
			  </td>
				<cfif len(session.ep.money2)>		 
					<td  nowrap="nowrap" style="text-align:right;">
						<cfif len(GET_BORC.AMOUNT_2[listfind(borc_ay_list,i)])>
							<cfset borc2 = GET_BORC.AMOUNT_2[listfind(borc_ay_list,i)]>
						</cfif>
						#TLFormat(borc2)#
						<cfset borc2_total = borc2_total + borc2>
					</td>
					<td  nowrap="nowrap" style="text-align:right;">
						<cfif len(GET_ALACAK.AMOUNT_2[listfind(alacak_ay_list,i)])>
							<cfset alacak2 = GET_ALACAK.AMOUNT_2[listfind(alacak_ay_list,i)]>
						</cfif>
						#TLFormat(alacak2)#
						<cfset alacak2_total = alacak2_total + alacak2>
					</td>
					<td  nowrap="nowrap" style="text-align:right;">
						<cfset bakiye2 = borc2-alacak2>
							#TLFormat(abs(bakiye2))#
						<cfif bakiye2 lt 0>
							(A)
						<cfelseif bakiye2 gt 0>
							(B)
						</cfif> 
						<cfset bakiye2_total = bakiye2_total + bakiye2>
					</td>
				</cfif>	
			<cfloop  list="#money_list#" index="kk">
				<td  nowrap="nowrap" style="text-align:right;">
				<cfif len(OTHER_AMOUNT_B.OTHER_AMOUNT[listfind(borc_money_list,kk)])>
					#TLFormat(OTHER_AMOUNT_B.OTHER_AMOUNT[listfind(borc_money_list,kk)])#
					<cfset 'toplam_#kk#' =evaluate('toplam_#kk#') + OTHER_AMOUNT_B.OTHER_AMOUNT[listfind(borc_money_list,kk)]>
				<cfelse>
					#TLFormat(0)#</cfif>
				</td>
				<td  nowrap="nowrap" style="text-align:right;">
				<cfif len(OTHER_AMOUNT_A.OTHER_AMOUNT[listfind(alacak_money_list,kk)])>
					#TLFormat(OTHER_AMOUNT_A.OTHER_AMOUNT[listfind(alacak_money_list,kk)])#
					<cfset 'alacak_#kk#' =evaluate('alacak_#kk#') + OTHER_AMOUNT_A.OTHER_AMOUNT[listfind(alacak_money_list,kk)]>
				<cfelse>#TLFormat(0)#</cfif></td>
				<td  nowrap="nowrap" style="text-align:right;">
				<cfset other_bakiye = 0>
				<cfif len(OTHER_AMOUNT_B.OTHER_AMOUNT[listfind(borc_money_list,kk)])>
					<cfset other_bakiye = other_bakiye + OTHER_AMOUNT_B.OTHER_AMOUNT[listfind(borc_money_list,kk)]>
					<cfset 'other_bakiye_#kk#' =evaluate('other_bakiye_#kk#') + OTHER_AMOUNT_B.OTHER_AMOUNT[listfind(borc_money_list,kk)]>
				</cfif> 
				<cfif len(OTHER_AMOUNT_A.OTHER_AMOUNT[listfind(alacak_money_list,kk)])>
					<cfset other_bakiye = other_bakiye -OTHER_AMOUNT_A.OTHER_AMOUNT[listfind(alacak_money_list,kk)]>
					<cfset 'other_bakiye_#kk#' =evaluate('other_bakiye_#kk#') -OTHER_AMOUNT_A.OTHER_AMOUNT[listfind(alacak_money_list,kk)]>
				</cfif>
					#TLFormat(abs(other_bakiye))# <cfif other_bakiye lt 0>(A)<cfelseif other_bakiye gt 0>(B)</cfif>
				</td>
			</cfloop>
            </tr>
				</tbody>
			</cfoutput>
		</cfloop>
		<cfoutput>
		<tfoot>
				<tr>
				<td class="txtboldblue"><cf_get_lang dictionary_id='57492.Toplam'></td>
				<td  style="text-align:right;">#TLFormat(borc_total)##session.ep.money#</td>
				<td  style="text-align:right;">#TLFormat(alacak_total)##session.ep.money#</td>
				<td  style="text-align:right;">#TLFormat(abs(bakiye_total))#<cfif bakiye_total lt 0>(A)<cfelseif bakiye_total gt 0>(B)</cfif></td>
				<cfif len(session.ep.money2)>
				<td  style="text-align:right;">#TLFormat(borc2_total)#</td>
				<td  style="text-align:right;">#TLFormat(alacak2_total)#</td>
				<td  style="text-align:right;">#TLFormat(abs(bakiye2_total))#<cfif bakiye2_total lt 0>(A)<cfelseif bakiye2_total gt 0>(B)</cfif></td>
				</cfif>
				<cfloop  list="#money_list#" index="kk">
					<td  nowrap="nowrap" style="text-align:right;">
						<cfif isdefined('toplam_#kk#')>
							#TLFormat(evaluate('toplam_#kk#'))#
						</cfif>
					</td>
					<td  nowrap="nowrap" style="text-align:right;">
						<cfif isdefined('alacak_#kk#') and len('alacak_#kk#')>
								#TLFormat(evaluate('alacak_#kk#'))#
						</cfif>
					</td>
					<td nowrap="nowrap" style="text-align:right;">
					<cfif isdefined('other_bakiye_#kk#') and len('other_bakiye_#kk#')>
						#TLFormat(abs(evaluate('other_bakiye_#kk#')))#
					</cfif>
					<cfif other_bakiye lt 0>(A)<cfelseif other_bakiye gt 0>(B)</cfif>
					</td>
				</cfloop>
			</tr>
			</tfoot>
		</cfoutput>
	</cf_grid_list>
</cf_box>
