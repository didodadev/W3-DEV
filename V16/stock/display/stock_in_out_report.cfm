<cfparam name="attributes.date1" default="#dateformat(date_add("d",-1,now()),dateformat_style)#">
<cfparam name="attributes.date2" default="#dateformat(now(),dateformat_style)#">
<cfparam name="attributes.DEPARTMENT_ID" default="">
<cfif len(attributes.date1) and attributes.date1 neq "NULL" ><cf_date tarih="attributes.date1"><cfelse><cfset attributes.date1 = "" ></cfif>
<cfif len(attributes.date2) and attributes.date2 neq "NULL" ><cf_date tarih="attributes.date2"><cfelse><cfset attributes.date2 = "" ></cfif>

<cffunction name="get_in_out_report_stockmodule">
	<cfargument name="process_type" >
	<cfargument name="department_id" >
	<cfargument name="company_id" >
	<cfargument name="consumer_id" >
	<cfif ListFind("70,71,72,73,74,75,76,77,78,79,80,1081,81", arguments.process_type, ",")>
		<cfif arguments.process_type eq 1081><cfset process_tp = 81 ><cfelse><cfset process_tp = arguments.process_type ></cfif>
		<cfset str_str=" SELECT SUM(NETTOTAL) AS TOTAL  FROM SHIP WHERE SHIP_TYPE = #process_tp# ">
		<cfif ListFind("73,74,75,76,77,1081", arguments.process_type, ",") and isdefined("arguments.department_id") and len(arguments.department_id) ><!--- alim --->
			<cfset str_str = "#str_str# AND DEPARTMENT_IN = #arguments.department_id#">
		<cfelseif isdefined("arguments.department_id") and len(arguments.department_id) >
			<cfset str_str = "#str_str# AND DELIVER_STORE_ID = #arguments.department_id#">
		</cfif>
		<cfif len(attributes.date1) and len(attributes.date2)>
			<cfset str_str = "#str_str# AND SHIP_DATE BETWEEN #attributes.date1# AND #attributes.date2# ">
		</cfif>
		<cfset str_str="#str_str# GROUP BY SHIP_TYPE ">		
	</cfif>
	<cfquery name="get_data" datasource="#DSN2#">#PreserveSingleQuotes(str_str)#</cfquery>
	<cfif len(get_data.TOTAL)>
		<cfreturn get_data.TOTAL >
	<cfelse>
		<cfreturn 0 >
	</cfif>
</cffunction>
<table width="98%" cellpadding="0" cellspacing="0" border="0" align="center">
<tr>
  <td class="headbold" height="35">Depo Özet Raporu</td>
</tr>
<table>

<table width="98%" align="center" cellpadding="0" cellspacing="0" border="0">
  <tr class="color-border">
    <td align="right" style="text-align:right;">
      <table width="100%" cellpadding="2" cellspacing="1">
        <tr>
          <td colspan="3" align="right" class="color-row" style="text-align:right;">
		  <cfform name="form_stock_report">
            <table>
              <tr>			  
				 <td>
					<cfsavecontent variable="message">Başlangıç Tarihi Girmelisiniz !</cfsavecontent>
					<cfinput type="text" name="date1" value="#dateformat(attributes.date1,dateformat_style)#"  message="#message#" style="width:80px;" validate="#validate_style#">
					<cf_wrk_date_image date_field="date1">
					<cfsavecontent variable="message">Bitiş Tarihi Girmelisiniz !</cfsavecontent>
					<cfinput type="text" name="date2" value="#dateformat(attributes.date2,dateformat_style)#" message="#message#" style="width:80px;" validate="#validate_style#">
					<cf_wrk_date_image date_field="date2">
				 </td>
                <td>
				  <cfinclude template="../query/get_stores.cfm">
				  <select name="department_id" id="department_id">
					<option value=""><cf_get_lang no='171.Tüm Depolar'></option>
					<cfoutput query="stores">
						<option value="#DEPARTMENT_ID#"<cfif isDefined("attributes.DEPARTMENT_ID") and attributes.DEPARTMENT_ID eq DEPARTMENT_ID> selected</cfif>>#department_head#</option>
					</cfoutput>
				  </select>
                </td>
				<td><cf_wrk_search_button></td>
              </tr>
            </table>
			</cfform>
          </td>
        </tr>
        <tr class="color-header" height="20">
          <td class="form-title">İşlem</td>
          <td align="right" class="form-title" style="text-align:right;">Girişler</td>
          <td align="right" class="form-title" style="text-align:right;">Çıkışlar</td>
        </tr>
		<cfset toplam_alim = 0 >
		<cfset toplam_satim = 0 >
		<cfoutput>
        <tr class="color-row" height="20">
          <td><cf_get_lang_main no='1784.Mal Alım İrsaliyesi'></td>
          <td align="right" style="text-align:right;">
			  <cfset deger = get_in_out_report_stockmodule(process_type:76,department_id:attributes.DEPARTMENT_ID) >
			  <cfset toplam_alim = toplam_alim + deger >
			  #TLFormat(deger)# #SESSION.EP.MONEY#
		  </td>
          <td align="right" style="text-align:right;">&nbsp;</td>
        </tr>
        <tr class="color-row" height="20">
          <td><cf_get_lang_main no='1787.Alım İade İrsaliyesi'></td>
          <td align="right" style="text-align:right;">&nbsp;</td>
          <td align="right" style="text-align:right;">
		   <cfset deger = get_in_out_report_stockmodule(process_type:78,department_id:attributes.DEPARTMENT_ID)>
		   <cfset toplam_satim = toplam_satim + deger >
		  	#TLFormat(deger)# #SESSION.EP.MONEY#
		  </td>
        </tr>
        <tr class="color-row" height="20">
          <td><cf_get_lang no='214.Depolararası Sevk İrsaliyesi'></td>
          <td align="right" style="text-align:right;">
			<cfset deger = get_in_out_report_stockmodule(process_type:1081,department_id:attributes.DEPARTMENT_ID) >
			<cfset toplam_alim = toplam_alim + deger >		  
			#TLFormat(deger)# #SESSION.EP.MONEY#		  
		  </td>
          <td align="right" style="text-align:right;">
		   <cfset deger = get_in_out_report_stockmodule(process_type:81,department_id:attributes.DEPARTMENT_ID)>
		   <cfset toplam_satim = toplam_satim + deger >
		  	#TLFormat(deger)# #SESSION.EP.MONEY#		  
		  </td>
        </tr>
        <tr class="color-row" height="20">
          <td><cf_get_lang no='79.Konsinye Giriş'></td>
          <td align="right" style="text-align:right;">
			<cfset deger = get_in_out_report_stockmodule(process_type:77,department_id:attributes.DEPARTMENT_ID) >
			<cfset toplam_alim = toplam_alim + deger >		  
			#TLFormat(deger)# #SESSION.EP.MONEY#
		  </td>
          <td align="right" style="text-align:right;">&nbsp;</td>
        </tr>
        <tr class="color-row" height="20">
          <td><cf_get_lang no='80.Konsinye Giriş İade'></td>
          <td align="right" style="text-align:right;">&nbsp;</td>
          <td align="right" style="text-align:right;">
		   <cfset deger = get_in_out_report_stockmodule(process_type:79,department_id:attributes.DEPARTMENT_ID)>
		   <cfset toplam_satim = toplam_satim + deger >
		  	#TLFormat(deger)# #SESSION.EP.MONEY#		  
		  </td>
        </tr>
        <tr class="color-row" height="20">
          <td><cf_get_lang_main no='1782.Parekande Satış İrsaliyesi'></td>
          <td align="right" style="text-align:right;">&nbsp;</td>
          <td align="right" style="text-align:right;">
		   <cfset deger = get_in_out_report_stockmodule(process_type:70,department_id:attributes.DEPARTMENT_ID)>
		   <cfset toplam_satim = toplam_satim + deger >
		   #TLFormat(deger)# #SESSION.EP.MONEY#			  
		  </td>
        </tr>
        <tr class="color-row" height="20">
          <td><cf_get_lang_main no='1340.Toptan Satış İrsaliyesi'></td>
          <td align="right" style="text-align:right;">&nbsp;</td>
          <td align="right" style="text-align:right;">
		   <cfset deger = get_in_out_report_stockmodule(process_type:71,department_id:attributes.DEPARTMENT_ID)>
		   <cfset toplam_satim = toplam_satim + deger >
		   #TLFormat(deger)# #SESSION.EP.MONEY#					  
		</td>
        </tr>
        <tr class="color-row" height="20">
          <td><cf_get_lang_main no='1341.Konsinye Çıkış İrsaliyesi'></td>
          <td align="right" style="text-align:right;">&nbsp;</td>
          <td align="right" style="text-align:right;">
		   <cfset deger = get_in_out_report_stockmodule(process_type:72,department_id:attributes.DEPARTMENT_ID)>
		   <cfset toplam_satim = toplam_satim + deger >
		   #TLFormat(deger)# #SESSION.EP.MONEY#		  
		  </td>
        </tr>
        <tr class="color-row" height="20">
          <td><cf_get_lang_main no='1342.Parekande Satış İade İrsaliyesi'></td>
          <td align="right" style="text-align:right;">
			<cfset deger = get_in_out_report_stockmodule(process_type:73,department_id:attributes.DEPARTMENT_ID) >
			<cfset toplam_alim = toplam_alim + deger >
			#TLFormat(deger)# #SESSION.EP.MONEY#
		  </td>
          <td align="right" style="text-align:right;">&nbsp;</td>
        </tr>
        <tr class="color-row" height="20">
          <td><cf_get_lang_main no='1783.Toptan Satış İade İrsaliyesi'></td>
          <td align="right" style="text-align:right;">
			<cfset deger = get_in_out_report_stockmodule(process_type:74,department_id:attributes.DEPARTMENT_ID) >
			<cfset toplam_alim = toplam_alim + deger >
			#TLFormat(deger)# #SESSION.EP.MONEY#		  
		  </td>
          <td align="right" style="text-align:right;">&nbsp;</td>
        </tr>
        <tr class="color-row" height="20">
          <td><cf_get_lang_main no='1343.Konsinye Çıkış İade İrsaliyesi'></td>
          <td align="right" style="text-align:right;">
			<cfset deger = get_in_out_report_stockmodule(process_type:75,department_id:attributes.DEPARTMENT_ID) >
			<cfset toplam_alim = toplam_alim + deger >
			#TLFormat(deger)# #SESSION.EP.MONEY#			  
		 </td>
          <td >&nbsp;</td>
        </tr>

<!---         <tr class="color-row" height="20">
          <td><cf_get_lang no='81.Müstahsil Makbuz'></td>
          <td align="right">&nbsp;</td>
          <td align="right">&nbsp;</td>
        </tr>
        <tr class="color-row" height="20">
          <td><cf_get_lang_main no='1831.Sarf Fişi'></td>
          <td align="right">&nbsp;</td>
          <td align="right">&nbsp;</td>
        </tr>
        <tr class="color-row" height="20">
          <td><cf_get_lang_main no='1832.Fire Fişi'></td>
          <td align="right">&nbsp;</td>
          <td align="right">&nbsp;</td>
        </tr>
        <tr class="color-row" height="20">
          <td><cf_get_lang no='90.Üretimden Giriş Fişi'></td>
          <td align="right">&nbsp;</td>
          <td align="right">&nbsp;</td>
        </tr> --->
       <tr class="color-list" height="20">
          <td class="txtbold">Toplam</td>
          <td  align="right" class="txtbold" style="text-align:right;">#TLFormat(toplam_alim)# #SESSION.EP.MONEY#</td>
          <td  align="right" class="txtbold" style="text-align:right;">#TLFormat(toplam_satim)# #SESSION.EP.MONEY#</td>
        </tr>
		</cfoutput>		
      </table>
    </td>
  </tr>
</table>

