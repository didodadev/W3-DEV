<cfquery name="CHECK" datasource="#DSN#">
	SELECT
	    COMPANY_NAME,
		TEL_CODE,
		TEL,TEL2,
		TEL3,
		TEL4,
		FAX,
		ADDRESS,
		WEB,
		EMAIL
	FROM
	    OUR_COMPANY
	WHERE 
	<cfif isdefined("attributes.our_company_id")>
		COMP_ID = #attributes.our_company_id#
	<cfelse>
		<cfif isDefined("SESSION.EP.COMPANY_ID")>
			COMP_ID = #SESSION.EP.COMPANY_ID#
		<cfelseif isDefined("SESSION.PP.OUR_COMPANY_ID")>	
			COMP_ID = #session.pp.OUR_COMPANY_ID#
		<cfelseif isDefined("SESSION.WW.OUR_COMPANY_ID")>
			COMP_ID = #SESSION.WW.OUR_COMPANY_ID#
		<cfelseif isDefined("SESSION.CP.OUR_COMPANY_ID")>
			COMP_ID = #SESSION.CP.OUR_COMPANY_ID#
		</cfif>
	</cfif>
</cfquery>
<cfset attributes.type = 1>
<cfinclude template="../../settings/query/get_template_dimension.cfm">
<table cellpadding="10" cellspacing="10" bgcolor="FFFFFF" align="center" style="width:<cfoutput>#GET_TEMPLATE_DIMENSION.TEMPLATE_WIDTH##GET_TEMPLATE_DIMENSION.TEMPLATE_UNIT#</cfoutput>"> 
    <tr> 
      <td align="<cfoutput>#GET_TEMPLATE_DIMENSION.TEMPLATE_ALIGN#</cfoutput>">
	  <hr noshade style="height:1px;">
	  <cfoutput>
		  <b>#CHECK.company_name#</b><br/>
		  <cfif len(CHECK.tel_code) or len(CHECK.tel) or len(CHECK.address) or len(CHECK.web) or len(CHECK.email)>
		  <b><cf_get_lang dictionary='57499.Telefon'>:</b>(#CHECK.tel_code#) - #CHECK.tel#  #CHECK.tel2#  #CHECK.tel3# #CHECK.tel4# <b><cf_get_lang dictionary='57488.Fax'>:</b>#CHECK.fax#<br/>
		  #CHECK.address#<br/>
		  #CHECK.web# - #CHECK.email#
		  </cfif>
	  </cfoutput>
	  </td>
    </tr>
</table>
