<br/>
<cfquery name="GET_RETURNS" datasource="#DSN3#">
	SELECT
		SGNR.*,
		S.PRODUCT_NAME
	FROM
		SERVICE_GUARANTY_NEW_RETURNS SGNR,
		STOCKS S
	WHERE
		S.STOCK_ID = SGNR.STOCK_ID AND
		SGNR.PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#">
	ORDER BY
		RECORD_DATE DESC
</cfquery>

<cfquery name="GET_PARTNER_POINT" datasource="#DSN#">
	SELECT (USER_POINT-ISNULL(USED_USER_POINT,0)) USER_POINT FROM COMPANY_PARTNER_POINTS WHERE PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#">
</cfquery>

<cfparam name="attributes.maxrows" default="#session.pp.maxrows#">
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.totalrecords" default = "#get_returns.recordcount#">
<cfset attributes.startrow = ((attributes.page-1)*attributes.maxrows) + 1>
<table cellspacing="2" cellpadding="2" border="0" style="width:100%;">
  	<tr style="height:22px;">
		<td class="formbold" colspan="7">Size Ait Seri Girişleri - ( Toplam Hediye Puanınız : <cfif get_partner_point.recordcount><cfoutput>#get_partner_point.user_point#</cfoutput><cfelse>0</cfif> )</td>
  	</tr>
  	<tr class="color-list" style="height:22px;">
        <td class="txtboldblue" style="width:50px;">No</td>
        <td class="txtboldblue" style="width:65px;"><cf_get_lang_main no='330.Tarih'></td>
        <td class="txtboldblue" style="width:100px;">Ürün</td>
        <td class="txtboldblue" nowrap="nowrap" style="width:100px;">Seri No</td>
        <td class="txtboldblue" nowrap="nowrap" style="width:80px;">Güvenlik No</td>
  	</tr>
  	<cfif get_returns.recordcount>
		<cfoutput query="get_returns" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
          	<tr class="color-row" style="height:20px;">
                <td>#currentrow#</td>
                <td>#dateformat(record_date,'dd/mm/yyyy')#</td>
                <td>#product_name#</td>
                <td>#serial_no#</td>
                <td>#lot_no#</td>
          	</tr>
        </cfoutput>
	<cfelse>
        <tr class="color-row" style="height:20px;">
          	<td td colspan="5"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</td>
        </tr>
  	</cfif>
</table>
<cfif attributes.totalrecords gt attributes.maxrows>
  	<table cellspacing="0" cellpadding="0" border="0" align="center" style="width:98%;">
    	<tr>
      		<td>
            	<cf_pages page="#attributes.page#" 
					maxrows="#attributes.maxrows#" 
					totalrecords="#attributes.totalrecords#" 
					startrow="#attributes.startrow#" 
					adres="objects2.#fusebox.fuseaction#"></td>
	  		<!-- sil -->
            <td align="right" style="text-align:right;"><cfoutput><cf_get_lang_main no='128.Toplam Kayıt'>:#get_returns.recordcount# - <cf_get_lang_main no='169.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td><!-- sil -->
    	</tr>
  	</table>
</cfif>
