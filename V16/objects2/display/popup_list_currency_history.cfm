<cfparam name="attributes.date1" default="#dateformat(date_add("d",-7,now()),'dd/mm/yyyy')#">
<cfparam name="attributes.date2" default="#dateformat(now(),'dd/mm/yyyy')#">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.money" default="">
<cfif len(attributes.date1)><cf_date tarih="attributes.date1"></cfif>
<cfif len(attributes.date2)><cf_date tarih="attributes.date2"></cfif>

<cfif isdefined("session.pp")>
	<cfset active_company = session.pp.our_company_id>
	<cfset active_period = session.pp.period_id>
	<cfset active_money = session.pp.money>
<cfelse>
	<cfset active_company = session.ww.our_company_id>
	<cfset active_period = session.ww.period_id>
	<cfset active_money = session.ww.money>
</cfif>

<cfquery name="GET_CURRENCY" datasource="#DSN#">
	SELECT
		MH.MONEY,
		MH.VALIDATE_DATE,
	<cfif isDefined("session.pp")>
		MH.RATEPP2 RATE2,
		MH.RATEPP3 RATE3
	<cfelseif isDefined("session.ww")>
		MH.RATEWW2 RATE2,
		MH.RATEWW3 RATE3
	<cfelse>
		MH.RATE2,
		MH.RATE3
	</cfif>	
	FROM
		MONEY_HISTORY MH
	WHERE
		MH.MONEY <> <cfqueryparam cfsqltype="cf_sql_varchar" value="#active_money#"> AND
		MH.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#active_company#"> AND
		MH.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#active_period#">
	<cfif isdefined('attributes.money') and len(attributes.money)>
		AND MH.MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.money#">
	</cfif>
	<cfif len(attributes.date1)>
		AND MH.VALIDATE_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#">
	</cfif>
	<cfif len(attributes.date2)>
		AND MH.VALIDATE_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DATEADD('d',1,attributes.date2)#">
	</cfif>
	ORDER BY
		MH.VALIDATE_DATE DESC
</cfquery>

<cfquery name="GET_MONEY" datasource="#dsn#">
	SELECT 
		* 
	FROM 
		SETUP_MONEY 
	WHERE
		PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#active_period#"> AND
		MONEY_STATUS = 1 AND
		MONEY <> <cfqueryparam cfsqltype="cf_sql_varchar" value="#session_base.money#">
</cfquery>
	
<cfparam name="attributes.page" default=1>
<cfif isdefined("session.pp.period_id")>
	<cfparam name="attributes.maxrows" default='#session.pp.maxrows#'>
<cfelse>
	<cfparam name="attributes.maxrows" default='#session.ww.maxrows#'>
</cfif>
<cfparam name="attributes.totalrecords" default=#get_currency.recordcount#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
  <tr>
	<td height="35" class="headbold"><cf_get_lang no='140.Kur Bilgileri'></td>
    <!-- sil -->
	<td height="30"  class="headbold" style="text-align:right;">
      <!--- Arama --->
      <table>
        <cfform name="list_currency" method="post" action="#request.self#?fuseaction=objects2.popup_list_currency_history">
          <tr>
		 	<td>
				<select name="money" id="money">
				  <option  value=""><cf_get_lang_main no='77.Para Br'></option>
				  <cfif get_money.recordcount >
					<cfoutput query="get_money" >
					  <option  value="#money#" <cfif attributes.money eq money>selected</cfif>>#money#</option>
					</cfoutput>
				  </cfif>
				</select>
			</td> 
			<td>
				<cfinput type="text" name="date1" value="#dateformat(attributes.date1,'dd/mm/yyyy')#" validate="eurodate" maxlength="10" style="width:65px;">
				<cf_wrk_date_image date_field="date1">
			</td>
			<td>
				<cfinput type="text" name="date2" value="#dateformat(attributes.date2,'dd/mm/yyyy')#" validate="eurodate" maxlength="10" style="width:65px;">
				<cf_wrk_date_image date_field="date2">
			</td>
            <td>
				<cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
				<cfinput type="text" name="maxrows" style="width:25px;" value="#attributes.maxrows#" validate="integer" range="1,250" required="yes" message="#message#">
            </td>
            <td><cf_wrk_search_button></td>
		</tr>
		</cfform>
		</table>
		</td>
	<!-- sil -->
  </tr>
</table>
<table cellSpacing="0" cellpadding="0" width="97%" border="0" align="center">
  <tr class="color-border">
  	<td>
	<table cellspacing="1" cellpadding="2" width="100%" border="0">
	  <tr class="color-header" height="20">
		<td width="100" class="form-title"><cf_get_lang_main no='330.Tarih'></td>
		<td width="75" class="form-title"><cf_get_lang no ='1214.Para'></td>
		<td width="100"  class="form-title" style="text-align:right;"><cf_get_lang_main no='420.Doviz Alış'></td>
		<td width="100"  class="form-title" style="text-align:right;"><cf_get_lang_main no='421.Doviz Satış'></td>
	  </tr>
	  <cfif get_currency.recordcount>
		<cfoutput query="get_currency" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
		  <tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
			<td>
			<cfif isdefined("session.pp.time_zone")>
				#dateformat(date_add('h', session.pp.time_zone,VALIDATE_DATE),'dd/mm/yyyy')#
			<cfelse>
				#dateformat(date_add('h', session.ww.time_zone,VALIDATE_DATE),'dd/mm/yyyy')#
			</cfif>
			</td>
			<td>#get_currency.money#</td>
			<td  style="text-align:right;">#TLFormat(rate3,4)#</td>
			<td  style="text-align:right;">#TLFormat(rate2,4)#</td>
		  </tr>
		</cfoutput>
		<cfelse>
		<tr class="color-row" height="20">
		  <td colspan="7"><cf_get_lang_main no='72.Kayıt bulunamadı'>!</td>
		</tr>
	  </cfif>
	</table>
  </td>
</tr>
<cfif attributes.totalrecords gt attributes.maxrows>
<table cellpadding="0" cellspacing="0" width="98%" align="center" height="35">
  <tr>
	<td>
	  <cfset adres="">
	  <cfif len(attributes.keyword)>
		<cfset adres="#adres#&keyword=#attributes.keyword#">
	  </cfif>
	  <cfif len(attributes.date1)>
		<cfset adres="#adres#&date1=#dateformat(attributes.date1,'dd/mm/yyyy')#">
	  </cfif>
	  <cfif len(attributes.date2)>
		<cfset adres="#adres#&date2=#dateformat(attributes.date2,'dd/mm/yyyy')#">
	  </cfif>
	  <cfif len(attributes.money)>
		<cfset adres="#adres#&money=#attributes.money#">
	  </cfif>
	<cf_pages page="#attributes.page#" 
			maxrows="#attributes.maxrows#" 
			totalrecords="#attributes.totalrecords#" 
			startrow="#attributes.startrow#" 
			adres="objects2.popup_list_currency_history&#adres#"></td>
	<!-- sil --><td  style="text-align:right;"><cfoutput><cf_get_lang_main  no='128.Toplam Kayıt'> : #get_currency.recordcount#&nbsp;-&nbsp;<cf_get_lang_main  no='169.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td><!-- sil -->
  </tr>
</table>
</cfif>
</table>
<br/>
