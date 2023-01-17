<script language="JavaScript" type="text/javascript">
function secim(ship_id,stock_id,stock_name,belge_no,miktar,serials){
	window.opener.<cfoutput>#attributes.out_ship_id#</cfoutput>.value=ship_id;
	window.opener.<cfoutput>#attributes.out_stock_id#</cfoutput>.value=stock_id;
	window.opener.<cfoutput>#attributes.out_stock_name#</cfoutput>.value=stock_name;
	window.opener.<cfoutput>#attributes.out_belge_no#</cfoutput>.value=belge_no;
	window.opener.<cfoutput>#attributes.out_miktar#</cfoutput>.value=miktar;
	window.opener.<cfoutput>#attributes.out_serials#</cfoutput>.value=serials;
	window.close();
}
</script>
<cfparam name="attributes.belge_no" default="">
<cfset url_str = "&out_ship_id=#attributes.out_ship_id#&out_stock_id=#attributes.out_stock_id#&out_stock_name=#attributes.out_stock_name#&out_belge_no=#attributes.out_belge_no#&out_miktar=#attributes.out_miktar#&islem_type=#attributes.islem_type#&out_serials=#attributes.out_serials#">

<cfset this_year = session.ep.period_year>
<cfscript>
	if (database_type is 'MSSQL') 
		{last_year_dsn2 = '#dsn#_#this_year-1#_#session.ep.company_id#';}
	else if (database_type is 'DB2') 
		{last_year_dsn2 = '#dsn#_#session.ep.company_id#_#this_year-1#';}	
</cfscript>
<cfquery name="get_old_serials1" datasource="#dsn2#">
	SELECT 
		SR.NAME_PRODUCT,
		SR.STOCK_ID,
		SR.AMOUNT,
		S.SHIP_TYPE,
		S.SHIP_NUMBER,
		S.SHIP_DATE,
		S.COMPANY_ID,
		S.CONSUMER_ID,
		S.SHIP_ID
	FROM 
		SHIP S,
		SHIP_ROW SR 
	WHERE 
		SR.SHIP_ID = S.SHIP_ID AND 
		S.SHIP_TYPE = #attributes.islem_type# AND
		S.SHIP_NUMBER LIKE '%#attributes.belge_no#%'
	ORDER BY 
		S.SHIP_ID DESC
</cfquery>
<cftry>
	<cfquery name="get_old_serials2" datasource="#last_year_dsn2#">
		SELECT 
			SR.NAME_PRODUCT,
			SR.STOCK_ID,
			SR.AMOUNT,
			S.SHIP_TYPE,
			S.SHIP_NUMBER,
			S.SHIP_DATE,
			S.COMPANY_ID,
			S.CONSUMER_ID,
			S.SHIP_ID 
		FROM 
			SHIP S,
			SHIP_ROW SR 
		WHERE 
			SR.SHIP_ID = S.SHIP_ID AND 
			S.SHIP_TYPE = #attributes.islem_type# AND
			S.SHIP_NUMBER LIKE '%#attributes.belge_no#%'
		ORDER BY 
			S.SHIP_ID DESC
	</cfquery>
	<cfcatch type="any"></cfcatch>
</cftry>

<cfif isdefined("get_old_serials2")>
	<cfquery name="get_old_serials" dbtype="query">
		 SELECT * FROM get_old_serials1 UNION SELECT * FROM get_old_serials2
	</cfquery>
<cfelse>
	<cfquery name="get_old_serials" dbtype="query">
		 SELECT * FROM get_old_serials1
	</cfquery>
</cfif>


<cfparam name="attributes.page" default=1>
<cfparam name="attributes.totalrecords" default='#get_old_serials.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<table width="98%" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
	<td height="35" class="headbold"><cf_get_lang dictionary_id ='34090.İrsaliyeler'></td>
	<td  style="text-align:right;">
		<table>
			<cfform name="search_asset" action="#request.self#?fuseaction=objects.popup_list_serials_in#url_str#" method="post">
			<tr>
				<td><cf_get_lang dictionary_id='57880.Belge No'></td>
				<td><input type="text" value="<cfoutput>#attributes.belge_no#</cfoutput>" name="belge_no" id="belge_no"></td>
				<td><cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
				<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
				</td>
				<td><cf_wrk_search_button></td>
			</tr>
			</cfform>
		</table>
	</td>
  </tr>
</table>
<table width="98%" border="0" align="center" cellpadding="0" cellspacing="0">
<tr>
<td width="2855" class="color-border">	
	<table width="100%" border="0" align="center" cellpadding="2" cellspacing="1">
	 <tr class="color-header" height="22">
	  <td class="form-title"><cf_get_lang dictionary_id='58211.Sipariş No'></td>
	  <td width="125" class="form-title"><cf_get_lang dictionary_id ='58533.Belge Tipi'></td>
	  <td width="60" class="form-title"><cf_get_lang dictionary_id ='57742.Tarih'></td>
	  <td class="form-title"><cf_get_lang dictionary_id ='57519.Cari Hesap'></td>
	  <td width="100" class="form-title"><cf_get_lang dictionary_id ='57452.Stok'></td>
	 </tr>
	<cfif get_old_serials.recordcount>
	<cfoutput query="get_old_serials" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
		<cfquery name="get_serials" datasource="#dsn3#"> 
			SELECT SERIAL_NO FROM SERVICE_GUARANTY_NEW WHERE STOCK_ID = #stock_id#  AND PROCESS_ID = #SHIP_ID# AND PROCESS_CAT = #SHIP_TYPE# AND PERIOD_ID = #SESSION.EP.PERIOD_ID#
 		</cfquery>
		<tr class="color-row" height="20">
			<td>#ship_number#</td>
			<td>#get_process_name(SHIP_TYPE)#</td>
			<td>#dateformat(ship_date,dateformat_style)#</td>
			<td>
			<cfif len(COMPANY_ID)>
				#get_par_info(COMPANY_ID,1,0,1)#
			<cfelseif len(CONSUMER_ID)>
				#get_cons_info(CONSUMER_ID,0,0)#
			</cfif>
			</td>
			<td><a href="javascript://" onClick="secim('#ship_id#','#stock_id#','#name_product#','#ship_number#','#amount#','<cfloop query="get_serials">#get_serials.serial_no#,</cfloop>');" class="tableyazi">#name_product#</a></td>
		</tr>
	</cfoutput>
	<cfelse>
		<tr class="color-row" height="20">
			<td colspan="5"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
		</tr>
	</cfif>
	</table>
</td>
</tr>
</table>
<cfset adres=attributes.fuseaction>
<cfset url_str = "#url_str#&belge_no=#attributes.belge_no#">
<cfif attributes.totalrecords gt attributes.maxrows>
  <table cellpadding="0" cellspacing="0" border="0" align="center" width="98%">
    <tr>
      <td>
        <cf_pages page="#attributes.page#"
			maxrows="#attributes.maxrows#"
			totalrecords="#attributes.totalrecords#"
			startrow="#attributes.startrow#"
			adres="#adres##url_str#"> </td>
      <!-- sil --><td height="30"  style="text-align:right;"> <cfoutput> <cf_get_lang dictionary_id='57540.Toplam Kayıt'>:#attributes.totalrecords#&nbsp;-&nbsp;<cf_get_lang dictionary_id='57581.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td><!-- sil -->
    </tr>
  </table>
</cfif>
