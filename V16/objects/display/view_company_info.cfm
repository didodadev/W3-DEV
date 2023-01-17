<!--- FBS 20081007 sirket parametrelerine secenek eklenerek istege gore sirket veya sube bilgilerinin getirilmesi saglandi --->
<cfquery name="GET_OUR_COMPANY_INFO" datasource="#DSN#">
	SELECT LOGO_TYPE FROM OUR_COMPANY_INFO WHERE COMP_ID = 
			<cfif isDefined("session.ep.company_id")>
				<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
			<cfelseif isDefined("session.pp.our_company_id")>	
				<cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.our_company_id#">
			<cfelseif isDefined("session.ww.our_company_id")>
				<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.our_company_id#">
			<cfelseif isDefined("session.cp.our_company_id")>
				<cfqueryparam cfsqltype="cf_sql_integer" value="#session.cp.our_company_id#">
			</cfif>    
</cfquery>
<cfif get_our_company_info.logo_type is 'is_branch' and isdefined('session.ep.userid')>
	<cfquery name="VIEW_INFO" datasource="#DSN#">
		SELECT
			BRANCH_FULLNAME NAME_,
			BRANCH_TELCODE TELCODE_,
			BRANCH_TEL1 TEL1_,
			BRANCH_TEL2 TEL2_,
			BRANCH_TEL3 TEL3_,
			BRANCH_FAX FAX_,
			BRANCH_ADDRESS ADDRESS_,
			BRANCH_EMAIL EMAIL_,
			'' WEB_,
            '' TAX_NO
		FROM
			BRANCH
		WHERE 
			<cfif isDefined("session.ep.user_location")>
				BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(session.ep.user_location,2,'-')#">
			<cfelseif isDefined("session.ep.company_id")>
				COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
			<cfelseif isDefined("session.pp.our_company_id")>	
				COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.our_company_id#">
			<cfelseif isDefined("session.ww.our_company_id")>
				COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.our_company_id#">
			<cfelseif isDefined("session.cp.our_company_id")>
				COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.cp.our_company_id#">
			</cfif>
	</cfquery>
<cfelse>
	<cfquery name="VIEW_INFO" datasource="#DSN#">
		SELECT
			COMPANY_NAME NAME_,
			TEL_CODE TELCODE_,
			TEL TEL1_,
			TEL2 TEL2_,
			TEL3 TEL3_,
			FAX FAX_,
			ADDRESS ADDRESS_,
			EMAIL EMAIL_,
			WEB WEB_
		FROM
			OUR_COMPANY
		WHERE 
		<cfif isdefined("attributes.our_company_id")>
			COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.our_company_id#">
		<cfelse>
			<cfif isDefined("session.ep.company_id")>
				COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
			<cfelseif isDefined("session.pp.our_company_id")>	
				COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.our_company_id#">
			<cfelseif isDefined("session.ww.our_company_id")>
				COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.our_company_id#">
			<cfelseif isDefined("session.cp.our_company_id")>
				COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.cp.our_company_id#">
			</cfif>
		</cfif> 
	</cfquery>
</cfif>
<cfset attributes.type = 1>
<cfinclude template="../../settings/query/get_template_dimension.cfm">
<table bgcolor="FFFFFF" align="<cfoutput>#get_template_dimension.template_align#" style="width:#get_template_dimension.template_width##get_template_dimension.template_unit#</cfoutput>"> 
	<tr> 
		<td align="<cfoutput>#get_template_dimension.template_align#</cfoutput>">
		<hr noshade style="height:1px;">
		<cfoutput>
			<table>
				<tr>
					<td colspan="2"><b>#view_info.name_#</b></td>
				</tr>
				<tr>
					<td><cfif len(view_info.tel1_) or len(view_info.tel2_) or  len(view_info.tel3_)><b><cf_get_lang dictionary_id = '49272.Tel'>:</b> (#view_info.telcode_#) - #view_info.tel1_# &nbsp; #view_info.tel2_# &nbsp; #view_info.tel3_#</cfif>&nbsp;</td>
                    <td><cfif len(view_info.fax_)><b><cf_get_lang dictionary_id = '57488.Fax'>:</b> (#view_info.telcode_#) - #view_info.fax_#</cfif>&nbsp;</td>
				</tr>
				<tr>
					<td colspan="2" style="width:350px;">#view_info.address_#</td>
				</tr>
				<tr>
					<td>#view_info.email_#</td>
				</tr>
				<tr>
					<td><a href="http://#view_info.web_#">#view_info.web_#</a></td>
				</tr>
			</table>
		</cfoutput>	
		</td>
	</tr>
</table>
