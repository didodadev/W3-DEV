<cfquery name="get_PARS" datasource="#DSN#">
SELECT 
	COMPANY_PARTNER.COMPANY_PARTNER_NAME,
	COMPANY_PARTNER.COMPANY_PARTNER_SURNAME,
	COMPANY_PARTNER.COMPANY_ID,
	COMPANY_PARTNER.PARTNER_ID,
	COMPANY.NICKNAME,
	COMPANY_PARTNER_RELATION.REL_PARTNER_ID,
	COMPANY_PARTNER_RELATION.PARTNER_RELATION_ID
FROM 
	COMPANY_PARTNER,
	COMPANY,
	COMPANY_PARTNER_RELATION
 WHERE 
	COMPANY_PARTNER.PARTNER_ID = COMPANY_PARTNER_RELATION.PARTNER_ID
		AND
	COMPANY.COMPANY_ID = COMPANY_PARTNER.COMPANY_ID
		AND
	COMPANY_PARTNER_RELATION.COMPANY_ID=#attributes.CPID#
</cfquery> 

<table cellspacing="0" cellpadding="0" width="98%"  border="0" align="center">
  <tr class="color-border"> 
	<td> 
	  <table cellspacing="1" cellpadding="2" width="100%" border="0">
		<tr class="color-header" height="22" > 
		  <td class="form-title" width="235"><cf_get_lang no='684.Kurumsal Üye İlişki'></td>
		  <td  align="center" width="15">
			<cfif get_module_user(4)>
				<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=member.popup_form_add_par_rel&c_id=#url.cpid#&cp_id=#url.cpid#</cfoutput>','medium');"><img src="/images/plus_square.gif" border="0" alt="<cf_get_lang no='307.Kurumsal Üye Temsilcileri'>" align="absmiddle"></a>
		  	</cfif>
		  </td>
		</tr>
		<!---**************--->
		<cfset CCS = "">
		<tr class="color-row"> 
		  <td id="td_charges" colspan="2" HEIGHT="20"> 
		 		 
		  <cfoutput query="get_PARS">
		  <table>
			<tr>
			  <td width="115">#COMPANY_PARTNER_NAME# #COMPANY_PARTNER_NAME# - #nickname#</td>
			  <td width="90">
			  <cfif len(ROLE_ID)>
			   <cfquery name="GET_ROL_NAME" datasource="#DSN#">
				 SELECT 
				 	PARTNER_RELATION 
				 FROM 
				 	SETUP_PARTNER_RELATION 
				 WHERE 
				 	PARTNER_RELATION_ID = #PARTNER_RELATION_ID#
				</cfquery>
			  #GET_ROL_NAME2.PARTNER_RELATION#	
			  </cfif>				  
			  </td>
			  <td  width="20" align="center">
			   <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=member.emptypopup_member_del_par&partner_id=#partner_id#&cp_id=#attributes.CPID#','small');"><img src="/images/delete_list.gif" border="0"></a>
			  </td>				   
		   </tr>
		</table>
		  </cfoutput>
		   <!---*********************--->
		  </td>
		</tr>
	  </table>
	</td>
  </tr>
</table>
