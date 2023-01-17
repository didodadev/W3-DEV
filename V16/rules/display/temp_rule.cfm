<cfsetting showdebugoutput="no">
<cfset attributes.cntid = attributes.id>
<cfinclude template="../query/get_content.cfm">
<cfinclude template="../query/get_company_cat.cfm">
<cfinclude template="../query/get_chapter_menu.cfm">
<cfinclude template="../query/get_content_cat.cfm">
<cfinclude template="../query/get_customer_cat.cfm">
<cfinclude template="../query/get_content_property.cfm">
<!---<cfdump var="#get_content#"><cfabort>--->
<!---
<cfif len(get_content.catalog_id) neq 0 and get_content.catalog_id neq 0 and get_content.IS_CATALOG_CONTENT IS 1>
	<cfset CATALOG_ID = GET_CONTENT.CATALOG_ID>
</cfif>
--->
<cfif isdefined("url.pid")>
	<input type="Hidden" name="product_id_" id="product_id_" value="<cfoutput>#url.pid#</cfoutput>">
</cfif>
<input type="Hidden" name="cntid" id="cntid" value="<cfoutput>#attributes.cntid#</cfoutput>">
<cfif fuseaction contains "popup">
	<cfset is_popup=1>
<cfelse>
	<cfset is_popup=0>
</cfif>
<cfsavecontent variable="cont_body_mail">
<table width="590">
    <tr height="18">
        <td width="65" class="txtbold"><cf_get_lang_main no='583.Bölüm'></td>
            <td><cf_get_lang_main no='6.Literatür'></STRONG> / 
            <cfoutput query="get_chapter_menu"> 
            	<cfif get_content.CHAPTER_ID is CHAPTER_ID>#chapter#</cfif> 
            </cfoutput> 
        </td>
    </tr>
    <tr height="18">
        <td class="txtbold"><cf_get_lang_main no='218.Tip'></td>
        <td><cfoutput query="get_CONTENT_PROPERTY">					
				<cfif get_content.CONTENT_PROPERTY_ID is CONTENT_PROPERTY_ID>#name#</cfif>
            </cfoutput>
        </td>
    </tr>
        <tr height="18">
        <td class="txtbold"><cf_get_lang_main no='68.Başlık'></td>
        <td><cfoutput>#get_content.cont_head# </cfoutput></td>
    </tr>
    <tr height="20" valign="top">
        <td class="txtbold"><cf_get_lang_main no='640.Özet'></td>
        <td><cfoutput>#get_content.cont_summary#</cfoutput></td>
    </tr>
</table>
<table width="590">
    <tr>
        <td class="headbold"><hr></td>
    </tr>
    <tr>
        <td><cfoutput>#get_content.cont_body#</cfoutput></td>
    </tr> 
</table>
<table width="590">
    <tr>
        <td>
			<cfoutput>
                <cf_get_lang_main no='771.Yazan'>: 
                #get_content.employee_name# #get_content.employee_surname#
                <cfif len(get_content.record_date)>
                	#dateformat(date_add('h',session.ep.time_zone,get_content.record_date),'dd/mm/yy')# #timeformat(date_add('h',session.ep.time_zone,get_content.record_date),timeformat_style)# 
                </cfif>
                <cfif len(get_content.update_date)>
                	<cf_get_lang_main no='1640.Son Güncelleyen'>:
                	<cfset attributes.employee_id = get_content.update_member>
                    <cfinclude template="../query/get_employee_name.cfm">
                	#get_employee_name.employee_name# #get_employee_name.employee_surname# - #dateformat(date_add('h',session.ep.time_zone,get_content.update_date),'dd/mm/yy')# #timeformat(date_add('h',session.ep.time_zone,get_content.update_date),timeformat_style)#
                </cfif>
            </cfoutput>
        </td>
    </tr>
</table>
</cfsavecontent>
<cfoutput>#cont_body_mail#</cfoutput>