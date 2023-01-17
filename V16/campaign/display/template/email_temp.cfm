<cfquery name="get_COMP_INFO" datasource="#dsn#">
	SELECT
		WEB,
		EMAIL,
		COMPANY_NAME
	FROM
		OUR_COMPANY
</cfquery>
<cfquery name="get_LOGOS" datasource="#dsn#">
	SELECT
		ASSET_FILE_NAME
	FROM
		OUR_COMPANY_ASSET
</cfquery>
<table width="550">
  <tr> 
    <td colspan="3" height="50"><IMG src="<cfoutput>#user_domain##file_web_path#settings/#get_logos.asset_file_name#</cfoutput>" alt="" BORDER="0"></td>
  </tr>
  <tr> 
    <td rowspan="5" width="20">&nbsp;</td>
    <td>Sayın <cfoutput>#receiver#</cfoutput></td>
    <td rowspan="5" width="20">&nbsp;</td>
  </tr>
  <tr> 
    <td><cfoutput>#campaign_head#</cfoutput></td>
  </tr>
  <tr> 
    <td><cfoutput>#campaign_detail#</cfoutput></td>
  </tr>
  <cfif camp_proms.recordcount>
  <tr> 
    <td>Kampanya Promosyonları : <br/>
	<table>
	<cfif camp_proms.recordcount>
	  <cfoutput query="camp_proms">
	     <tr> 
	       	<td><!--- <a href="#user_domain##request.self#?fuseaction=objects.popup_detail_promotion_unique&prom_id=#prom_id#" class="tableyazi"></a> 20030306 --->#prom_head#</td>
	     </tr>
	  </cfoutput>
	</cfif>
	</table>
	</td>
  </tr>
  </cfif>
  <tr> 
    <td>&nbsp;</td>
  </tr>
  <tr align="center"> 
    <td colspan="3">
	<cfoutput>
	#get_COMP_INFO.company_name#<br/>
	<a href="#get_COMP_INFO.web#">#get_COMP_INFO.web#</a><br/>
	<a href="mailto:#get_COMP_INFO.email#">#get_COMP_INFO.email#</a><br/>
	</cfoutput>
	</td>
  </tr>
</table>
