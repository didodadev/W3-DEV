<!--- 
	basit kullanıcı bilgisi
	ZORUNLU girdiler : 
		contact_type : "p" / "c" / "e" {partner / consumer / employee}
		contact_id   : istenen şahsın "id" si
 --->
<cfinclude template="../query/get_account_simple.cfm">
<table  border="0">
  <tr>
  <td colspan="2" class="txtboldblue"><cf_get_lang dictionary_id='57584.Üye Hesap Bilgileri'></td>
  </tr>
  <tr> 
    <td> 
	<cfif contact_type is "e">
	<cf_get_lang dictionary_id='57576.Çalışan'>
	    <cfelseif contact_type is "p">
        <cfoutput>#get_account_simple.COMPANYCAT#</cfoutput> 
        <cfelseif contact_type is "c">
        <cfoutput>#get_account_simple.CONSCAT#</cfoutput> 
		</cfif> 
	</td>
  </tr>
    <td>
	<cfif contact_type is "e">
	<cfoutput query="GET_ACCOUNT_SIMPLE">#TITLE#</cfoutput>
	<cfelseif contact_type is "p">
		<cfoutput>
		
		<cfif get_module_user(4)>
		<a href="javascript://" onClick="window.parent.location.href='#request.self#?fuseaction=member.form_list_company&event=upd&cpid=#get_account_simple.company_id#';" class="tableyazi">#get_account_simple.company_name#</a>
		<cfelse>
		<a href="javascript://"  onclick="windowopen('#request.self#?fuseaction=objects.popup_com_det&company_id=#get_account_simple.company_id#','medium');" class="tableyazi">#get_account_simple.company_name#</a>
		</cfif>
		
		</cfoutput>
	<cfelseif contact_type is "c">
		<cfoutput>#get_account_simple.company_name#</cfoutput>
	</cfif>	
	</td>
  </tr>
  <tr> 
    <td>
	<cfif contact_type is "p">
		<cfoutput>
		<cfif get_module_user(4)>
		<a href="javascript://" onClick="window.parent.location.href='#request.self#?fuseaction=member.list_contact&event=upd&pid=#get_account_simple.partner_id#';" class="tableyazi">#get_account_simple.name# #get_account_simple.surname#</a>
		<cfelse>
		<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_par_det&par_id=#contact_id#','medium');" class="tableyazi">#get_account_simple.name# #get_account_simple.surname#</a>
		</cfif>		
		</cfoutput>
	<cfelseif contact_type is "e">
		<!--- gelecek --->
		-
	<cfelseif contact_type is "c">
		<cfoutput>
		<cfif get_module_user(4)>
		<a href="javascript://" onClick="window.parent.location.href='#request.self#?fuseaction=member.consumer_list&event=det&cid=#contact_id#';" class="tableyazi">#get_account_simple.name# #get_account_simple.surname#</a>
		<cfelse>
		<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id=#contact_id#','medium');" class="tableyazi">#get_account_simple.name# #get_account_simple.surname#</a>
		</cfif>
		</cfoutput>		
	</cfif>
	</td>
  </tr>
  <tr> 
    <td> <cf_get_lang dictionary_id='57587.Borç'>:
    <cfif contact_type is "p">
			<cfif not get_remainder.recordcount>
				<cfset borc = 0>
				<cfset alacak = 0>
				<cfset bakiye = 0>				
			<cfelse>
				<cfset borc = get_remainder.borc>
				<cfset alacak = get_remainder.alacak>
				<cfset bakiye = get_remainder.bakiye>
			</cfif>
	<cfoutput>#TLFormat(ABS(borc))# &nbsp; #session.ep.money#&nbsp;</cfoutput> 
     </cfif>
	</td>
  </tr>
  <tr> 
    <td><cf_get_lang dictionary_id='57588.Alacak'>:  
    <cfif contact_type is "p" or contact_type is "c">	
			<cfif not get_remainder.recordcount>
				<cfset borc = 0>
				<cfset alacak = 0>
				<cfset bakiye = 0>				
			<cfelse>
				<cfset borc = get_remainder.borc>
				<cfset alacak = get_remainder.alacak>
				<cfset bakiye = get_remainder.bakiye>				
			</cfif>
         <cfoutput>
		 #TLFormat(ABS(alacak))#&nbsp;#session.ep.money#&nbsp;
		 </cfoutput> 
      </cfif>
	</td>
  </tr>
  <tr> 
    <td><cf_get_lang dictionary_id='57589.Bakiye'>:   
      <cfif contact_type is "p" or contact_type is "c">
			<cfif get_remainder.recordcount eq 0>
				<cfset borc = 0>
				<cfset alacak = 0>
				<cfset bakiye = 0>				
			<cfelse>
				<cfset borc = get_remainder.borc>
				<cfset alacak = get_remainder.alacak>
				<cfset bakiye = get_remainder.bakiye>				
			</cfif>
       		<cfoutput>
			<cfif contact_type is "p">
			 <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_list_comp_extre&company_id=#get_account_simple.company_id#','list');" class="tableyazi">#TLFormat(ABS(bakiye))#&nbsp;#session.ep.money#&nbsp;</a>
			 <cfelse>
			 <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_list_comp_extre&is_self=1&member_id=#contact_id#&member_type=consumer','list');" class="tableyazi">#TLFormat(ABS(bakiye))#&nbsp;#session.ep.money#&nbsp;</a>
			</cfif>
			</cfoutput> 
      </cfif>
	</td>
  </tr>
</table>

