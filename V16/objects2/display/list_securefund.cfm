<cfparam name="attributes.keyword" default="">
<cfquery name="get_company_securefund" datasource="#DSN#">
	SELECT 
		SS.SECUREFUND_CAT,
		CS.COMPANY_ID,
		CS.GIVE_TAKE,
		CS.FINISH_DATE,
		CS.ACTION_VALUE,
		CS.SECUREFUND_TOTAL,
		CS.MONEY_CAT
	FROM 
		COMPANY_SECUREFUND CS,
		OUR_COMPANY OC ,
		SETUP_SECUREFUND SS
	WHERE 
		<cfif isdefined("attributes.keyword")>
			SS.SECUREFUND_CAT LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> AND
		</cfif>
		CS.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.our_company_id#">
		AND CS.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.company_id#">
		AND CS.OUR_COMPANY_ID = OC.COMP_ID	
		AND CS.SECUREFUND_CAT_ID = SS.SECUREFUND_CAT_ID
	ORDER BY 
		CS.FINISH_DATE DESC
</cfquery>

<cfquery name="get_money" datasource="#DSN#">
	SELECT MONEY FROM SETUP_MONEY WHERE PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.period_id#"> AND MONEY_STATUS = 1 ORDER BY MONEY_ID
</cfquery>

<cfoutput query="get_money">
	<cfset 'toplam_#money#' = 0>
</cfoutput>
<cfset toplam_ = 0>
<cfset url_str = "">
<cfif len(attributes.keyword)><cfset url_str = "#url_str#&keyword=#attributes.keyword#"></cfif>

<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.pp.maxrows#'>
<cfparam name="attributes.totalrecords" default="#get_company_securefund.recordcount#">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<table width="100%" align="center" cellpadding="0" cellspacing="0" border="0" height="35">
	<tr>
		<td class="headbold">&nbsp;&nbsp;&nbsp;&nbsp;Teminatlar</td>
		 <td class="headbold" style="text-align:right;"> 
			<table>
			<cfform name="search" method="post" action="">
				<tr>
					<td>Filtre</td>
					<td><cfinput type="text" name="keyword" style="width:100px;" value="#attributes.keyword#" maxlength="255"></td>
					<td><cfsavecontent variable="message">Sayı Hatası Mesajı</cfsavecontent>
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;"></td>
					<td><cf_wrk_search_button is_excel="0">&nbsp;&nbsp;&nbsp;&nbsp;</td>
				</tr>
			</cfform>
			</table>
		</td>
	</tr>
</table>
<table cellpadding="1" cellpadding="2" width="98%" border="0" class="color-border" align="center">
	<tr class="color-header" height="22">
		<td class="form-title" width="100">Cari Hesap</td>
		<td class="form-title" width="100">Alınan - Verilen</td>
		<td class="form-title">Teminat</td>
		<td class="form-title" width="65">Bitiş Tarihi</td>
		<td class="form-title" style="text-align:right;">Tutar</td>
		<td class="form-title" style="text-align:right;">Döviz Tutar</td>
	</tr>
	<cfif attributes.page neq 1>
		<cfoutput query="GET_COMPANY_SECUREFUND" startrow="1" maxrows="#attributes.startrow-1#">
			<cfif len(securefund_total)>
				<cfset 'toplam_#money_cat#' = evaluate('toplam_#money_cat#') + securefund_total>
			</cfif>
			<cfif len(action_value)>
				<cfset toplam_ = toplam_ + action_value>
			</cfif>
		</cfoutput>	
	</cfif>
<cfif get_company_securefund.recordcount>
	<cfoutput query="GET_COMPANY_SECUREFUND" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
		<tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row" <cfif finish_date lt now() or finish_date lt date_add("d",60,now())>style="color:red;"</cfif>>
			<td><cfif len(company_id)>
					  <!---<a href="#request.self#?fuseaction=objects2.view_member&company_id=#company_id#" class="tableyazi">--->#get_par_info(company_id,1,0,0)#<!---</a>--->
				</cfif>
			</td>
			<td><cfif GIVE_TAKE eq 0>Alınan<cfelse>Verilen</cfif></td>
			<td>#securefund_cat#</td>
			<td>#dateformat(finish_date,'dd/mm/yyyy')#</td>
			<td style="text-align:right;">#tlformat(action_value)# #session.pp.money#</td>
			<cfif len(ACTION_VALUE)>
				<cfset toplam_ = toplam_ + ACTION_VALUE>
			</cfif>
			<td style="text-align:right;">#tlformat(securefund_total)# #money_cat#</td>
			<cfif len(SECUREFUND_TOTAL)>
				<cfset 'toplam_#money_cat#' = evaluate('toplam_#money_cat#') + SECUREFUND_TOTAL>
			</cfif>
		</tr>
	</cfoutput>
	<tr height="20" onMouseOver="this.class_name='color-light';" onMouseOut="this.className='color-row';" class="color-row">
		<td colspan="4" style="text-align:right;">Genel Toplam</td>
		<td style="text-align:right;">
			<cfif toplam_ gt 0>
				<cfoutput>#Tlformat(toplam_)# #session.pp.money#</cfoutput>
			</cfif>
		</td>
		 <td style="text-align:right;">
			<cfoutput query="get_money">
				<cfif evaluate('toplam_#money#') gt 0>
					#Tlformat(evaluate('toplam_#money#'))# #money#<br/>
				</cfif>
			</cfoutput>
		</td> 
	</tr>
<cfelse>
	<tr class="color-row" height="20">
		<td colspan="8">Kayıt Yok</td>
	</tr>
</cfif>
</table>

<cfif attributes.totalrecords gt attributes.maxrows>
	<cfif isdefined("attributes.company_id") and Len(attributes.company_id)><cfset url_str = "#url_str#&company_id=#attributes.company_id#"></cfif>
	<table cellpadding="0" cellspacing="0" border="0" width="98%" height="35" align="center">
	  <tr> 
		<td>
		<cf_pages 
			page="#attributes.page#" 
			maxrows="#attributes.maxrows#" 
			totalrecords="#attributes.totalrecords#" 
			startrow="#attributes.startrow#" 
			adres="objects2.list_securefund#url_str#"> 
		</td>
		<!-- sil --><td style="text-align:right;"><cfoutput>Toplam Kayıt :#attributes.totalrecords#&nbsp;-&nbsp;Sayfa:#attributes.page#/#lastpage#</cfoutput></td><!-- sil -->
	  </tr>
	</table>
</cfif>


