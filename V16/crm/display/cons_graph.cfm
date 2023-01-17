<cfquery name="GET_CONSUMER_COUNT1" datasource="#DSN#">
	SELECT COUNT(COMPANY_ID) AS COUNT_CONSUMER FROM COMPANY WHERE IS_ADAY = 0 AND ISPOTANTIAL = 1 AND IS_RED = 0
</cfquery>
<cfquery name="GET_CONSUMER_COUNT2" datasource="#DSN#">
	SELECT COUNT(COMPANY_ID) AS COUNT_CONSUMER FROM COMPANY WHERE IS_ADAY = 0 AND ISPOTANTIAL = 0 AND IS_RED = 0
</cfquery>
<cfquery name="GET_CONSUMER_COUNT3" datasource="#DSN#">
	SELECT COUNT(COMPANY_ID) AS COUNT_CONSUMER FROM COMPANY WHERE IS_ADAY = 1 AND ISPOTANTIAL = 0 AND IS_RED = 0
</cfquery>
<cfquery name="GET_CONSUMER_COUNT4" datasource="#DSN#">
	SELECT COUNT(COMPANY_ID) AS COUNT_CONSUMER FROM COMPANY WHERE IS_ADAY = 0 AND ISPOTANTIAL = 0 AND IS_RED = 1
</cfquery>

<cfquery name="COMPANYCATS" datasource="#dsn#">
	SELECT 
    	COMPANYCAT_ID, 
        COMPANYCAT, 
        DETAIL, 
        RECORD_EMP, 
        RECORD_DATE, 
        RECORD_IP, 
        UPDATE_DATE, 
        UPDATE_EMP, 
        UPDATE_IP 
    FROM 
    	COMPANY_CAT 
    ORDER BY 
    	COMPANYCAT
</cfquery>
<table cellspacing="0" cellpadding="0" border="0" width="100%" height="100%">
  <tr class="color-border"> 
    <td valign="top"> 
      <table cellspacing="1" cellpadding="2" border="0" width="100%" height="100%">
        <tr class="color-list"> 
          <td height="25"  style="text-align:right;"> 
			<table align="center" width="100%">
			<cfform action="" method="post" name="form_stock">			
              <tr>
			    <td class="headbold" height="35"><cfoutput><cf_get_lang no='19.Müşteri Profili'>
			       &nbsp;&nbsp;<font class="txtbold">(#Dateformat(date_add("h",session.ep.time_zone,now()),dateformat_style)# #timeformat(date_add("h",session.ep.time_zone,now()),timeformat_style)#)</font></cfoutput></td>
                 <td width="100"  style="text-align:right;"> 
                  <select name="graph_type" id="graph_type" style="width:100px;">
                    <option value="" selected><cf_get_lang_main no='538.Grafik Format'></option>
                    <option value="pie"><cf_get_lang_main no='1316.Pasta'></option>
                    <option value="line"><cf_get_lang_main no='253.Eğri'></option>
					<option value="bar"><cf_get_lang_main no='251.Bar'></option>
                  </select>
                </td>
                <td width="18" style="text-align:right;"><cf_wrk_search_button></td>
              </tr>
            </cfform>
			</table>
          </td>
        </tr>
		<tr bgcolor="#FFFFFF">
          <td><cfif isDefined("form.graph_type") and len(form.graph_type)>
				<cfset graph_type = form.graph_type>
			<cfelse>
				<cfset graph_type = "pie">
			</cfif>
			<cfchart show3d="yes" labelformat="number" pieslicestyle="solid" format="jpg"> 
			<cfchartseries type="#graph_type#" itemcolumn="deneme"> 
			<cfoutput query="companycats">
				<cfquery name="GET_CONSUMER_COUNT" datasource="#DSN#">
					SELECT COUNT(COMPANY_ID) AS COUNT_CONSUMER FROM COMPANY WHERE CUSTOMER_TYPE =  #companycat_id#
				</cfquery>				
				<cfchartdata item="#companycat#" value="#get_consumer_count.count_consumer#">
			</cfoutput>
			</cfchartseries>
			</cfchart></td>
        </tr>
		<tr bgcolor="#FFFFFF">
          <td><cfif isDefined("form.graph_type") and len(form.graph_type)>
				<cfset graph_type = form.graph_type>
			<cfelse>
				<cfset graph_type = "pie">
			</cfif>
			<cfchart show3d="yes" labelformat="number" pieslicestyle="solid" format="jpg"> 
			<cfchartseries type="#graph_type#" itemcolumn="deneme"> 
				<cfchartdata item="Aktif Müşteriler" value="#get_consumer_count1.count_consumer#">
				<cfchartdata item="Onay Bekleyen Müşteriler" value="#get_consumer_count2.count_consumer#">
				<cfchartdata item="Aday Müşteriler" value="#get_consumer_count3.count_consumer#">
				<cfchartdata item="Red Edilen Müşteriler" value="#get_consumer_count4.count_consumer#">
			</cfchartseries>
		</cfchart></td>
        </tr>
      </table>
    </td>
  </tr>
</table>
