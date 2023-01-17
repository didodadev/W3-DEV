<cfquery name="GET_PARTNER" datasource="#DSN#">
	SELECT 
		*
	FROM 
		COMPANY_PARTNER CP, 
		COMPANY C
	WHERE 
		CP.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#"> AND 
		CP.COMPANY_ID = C.COMPANY_ID AND
		COMPANY_PARTNER_STATUS=1
	ORDER BY
		CP.COMPANY_PARTNER_NAME
</cfquery>

<cfset list_partner=ValueList(get_partner.partner_id,',')>
<cfparam name="attributes.totalrecords" default='#get_partner.recordcount#'>
<div class="table-responsive-lg">
	<table class="table">
		<thead class="main-bg-color">
			<tr>
				<td><cf_get_lang dictionary_id='35445.Kontak Kişiler'></td>
				<td><cf_get_lang dictionary_id='58143.İletişim'></td>
			</tr>
		</thead>
		<tbody>
			<cfoutput query="get_partner">
				<tr>
					<td>
						<cfif isdefined('attributes.is_partner_upd') and attributes.is_partner_upd eq 1>
							<a href="#request.self#?fuseaction=objects2.form_upd_partner&pid=#partner_id#" class="tableyazi">#company_partner_name# #company_partner_surname#  - #title#</a>
						<cfelse>
							#company_partner_name# #company_partner_surname#  - #title#
						</cfif>
					</td>
					<td>
						<cfif len(company_partner_email)><a href="mailto:#company_partner_email#"><i class="fa fa-edit"> <cf_get_lang dictionary_id="32508.E-mail">: #company_partner_email#</i></a></cfif>
						<cfif len(company_partner_tel)><i class="icon-phone"> <cf_get_lang dictionary_id="51263.Tel">: #company_partner_tel#</i></cfif>
						<cfif len(company_partner_fax)><i class="fa fa-fax"> <cf_get_lang dictionary_id="57488.Fax">: #company_partner_fax#</i></cfif>
						<cfif len(mobiltel)><i class="fa fa-mobile-phone"> <cf_get_lang dictionary_id="30181.Mobil">: #MOBIL_CODE# - #mobiltel#</i></cfif>
					</td>
				</tr>
			</cfoutput>
		</tbody>
	</table>
</div>