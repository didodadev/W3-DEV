<cfquery name="get_partner_relation" datasource="#dsn#">
SELECT 
	CPB.PARTNER_COMPANY_ID,
	CPB.PARTNER_RELATION_ID,
	C.NICKNAME,
	C.MANAGER_PARTNER_ID,
	SPR.PARTNER_RELATION  
FROM 
	COMPANY C, 
	COMPANY_PARTNER_RELATION CPB,
	SETUP_PARTNER_RELATION  SPR
WHERE 
	CPB.PARTNER_COMPANY_ID = C.COMPANY_ID 
	AND CPB.COMPANY_ID  = #attributes.company_id# 
	AND SPR.PARTNER_RELATION_ID=CPB.PARTNER_RELATION_ID
ORDER BY PARTNER_RELATION
</cfquery>
<table width="99%" align="center">
	<tr class="color-list">
		<td colspan="4" height="25" class="txtboldblue">Kurumsal Üye İlişkisi:</td>
	</tr>
	 <cfset partner_relation_list=''>
				<cfoutput query="get_partner_relation">
					<cfif not listfind(partner_relation_list,get_partner_relation.PARTNER_RELATION)>
					<cfset partner_relation_list=listappend(partner_relation_list,get_partner_relation.PARTNER_RELATION)>
					<cfquery name="get_partners" dbtype="query">
						SELECT 
							NICKNAME,
							PARTNER_RELATION
						FROM 
							get_partner_relation 
						WHERE 
							PARTNER_RELATION='#get_partner_relation.PARTNER_RELATION#'
					</cfquery>
					<tr>
						<td colspan="4">#get_partners.PARTNER_RELATION#:&nbsp;#valuelist(get_partners.NICKNAME,',')#</td>
					</tr>
					</cfif>
				</cfoutput>
 </tr>

</table>
