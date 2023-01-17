<cfquery name="get_COMP_INFO" datasource="#dsn#">
	select
		WEB,
		EMAIL,
		COMPANY_NAME
	from
		OUR_COMPANY
</cfquery>
<cfquery name="get_LOGOS" datasource="#dsn#">
	select
		ASSET_FILE_NAME
	from
		OUR_COMPANY_ASSET
</cfquery>
<table width="500" height="500" border="0" cellpadding="1" cellspacing="0" bgcolor="#CCCCFF">
  <tr> 
    <td height="50" colspan="3" bgcolor="#FFFFFF"><IMG src="<cfoutput>#user_domain##file_web_path#settings/#get_logos.asset_file_name#</cfoutput>" alt="" BORDER="0"></td>
  </tr>
  <tr> 
    <td width="20" rowspan="5">&nbsp;</td>
    <td valign="top"><br/>
      <br/>
      <font size="2" face="Verdana, Arial, Helvetica, sans-serif"> 
      Sayın<cfoutput> #receiver#  
       <br/><br/>
	  #campaign_head#<br/><br/>
        #campaign_detail#</font></cfoutput>
      </td>
    <td width="20" rowspan="5">&nbsp;</td>
  </tr>
 
  
  <cfif camp_proms.recordcount>
  <tr> 
      <td>Kampanya Promosyonları : <br/>
	<table>
	<cfif camp_proms.recordcount>
	  <cfoutput query="camp_proms">
	     <tr> 
	       	<td><!--- <a href="#user_domain##request.self#?fuseaction=campaign.form_upd_prom&prom_id=#prom_id#" class="tableyazi"></a> 20030306 --->#prom_head#</td>
	     </tr>
	  </cfoutput>
	</cfif>
	</table>
	</td>
  </tr>
  </cfif>
  
  <tr align="center" bgcolor="#CCCCFF"> 
    <td height="50" colspan="3"> <font size="1" face="Verdana, Arial, Helvetica, sans-serif"><cfoutput> 
        #get_COMP_INFO.company_name#<br/>
        <a href="#get_COMP_INFO.web#">#get_COMP_INFO.web#, </a><a href="mailto:#get_COMP_INFO.email#">#get_COMP_INFO.email#</a><br/>
      </cfoutput></font><font face="Verdana, Arial, Helvetica, sans-serif"><cfoutput> 
      </cfoutput><cfoutput> 
      </cfoutput></font><cfoutput> </cfoutput> </td>
  </tr>
</table>

