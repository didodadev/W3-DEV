<cfset xml_page_control_list ='is_invoice,note,etkilesim,kampanya,eğitim,etkinlik,yazisma,visit,firsat,teklif,siparis,taksit,service,analiz,call_center,project,system,takip,reference'>
<cf_xml_page_edit page_control_list="#xml_page_control_list#" default_value="1" fuseact="myhome.my_company_details">
<cfif session.ep.member_view_control eq 1>
	<cfquery name="view_control" datasource="#dsn#">
		SELECT
			IS_MASTER
		FROM
			WORKGROUP_EMP_PAR
		WHERE
			COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cpid#"> AND
			OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
			POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">
	</cfquery>
	<cfif not view_control.recordcount>
		<script type="text/javascript">
			alert("<cf_get_lang dictionary_id ='31918.Bu Üyeyi Görmek İçin Yetkiniz Yok'>!");
			history.back();
		</script>
	</cfif>
</cfif>
<cfif isdefined("x_control_ims") and x_control_ims eq 1 and session.ep.our_company_info.sales_zone_followup eq 1>
	<cfinclude template="../../member/query/get_ims_control.cfm">
</cfif>
<!--- Satış Bölge Kontrolü İçin Gerekli Created By MCP 18092013 --->
<cfif session.ep.our_company_info.sales_zone_followup eq 1>
		<cfquery name="GET_HIERARCHIES" datasource="#DSN#">
			SELECT
				DISTINCT
				SZ_HIERARCHY
			FROM
				SALES_ZONES_ALL_1
			WHERE
				POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">
		</cfquery>
        <cfset row_block = 500>
	</cfif>
<cfquery name="GET_COMPANY" datasource="#DSN#">
	SELECT
		COMPANY.COMPANY_STATUS,
        COMPANY.MEMBER_CODE,
		COMPANY.ISPOTANTIAL,
        COMPANY.FULLNAME, 
		COMPANY.COMPANY_ID, 
		COMPANY.COMPANY_TELCODE, 
		COMPANY.COMPANY_TEL1, 
		COMPANY.TAXNO, 
		COMPANY.DISTRICT, 
		COMPANY.TAXOFFICE, 
		COMPANY.MAIN_STREET, 
		COMPANY.COMPANY_ADDRESS, 
		COMPANY.DUKKAN_NO, 
		COMPANY.COMPANY_TEL2, 
		COMPANY.COMPANY_TEL3, 
		COMPANY.SEMT, 
		COMPANY.COMPANY_FAX_CODE, 
		COMPANY.COMPANY_FAX, 
		COMPANY.COMPANY_EMAIL, 
		COMPANY.COMPANY_POSTCODE, 
		COMPANY.COUNTY, 
		COMPANY.CITY, 
		COMPANY.COUNTRY,
		COMPANY.HOMEPAGE, 
		COMPANY.MANAGER_PARTNER_ID, 
		COMPANY.PARTNER_ID,
		COMPANY.STREET,
		COMPANY.COMPANY_VALUE_ID,
		COMPANY.SALES_COUNTY,
		COMPANY.IMS_CODE_ID,
		COMPANY.MOBIL_CODE,
		COMPANY.MOBILTEL,
		COMPANY_CAT.COMPANYCAT, 
		COMPANY_CAT.COMPANYCAT_ID,
        (SELECT COUNT(COMPANY_ID) COUNT FROM COMPANY_LAW_REQUEST WHERE COMPANY.COMPANY_ID = COMPANY_LAW_REQUEST.COMPANY_ID AND COMPANY_LAW_REQUEST.REQUEST_STATUS = 1) COMPANY_LAW_REQUEST
	FROM 
		COMPANY,
		COMPANY_CAT, 
		COMPANY_PARTNER
	WHERE 
		COMPANY.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cpid#">
		AND COMPANY_CAT.COMPANYCAT_ID = COMPANY.COMPANYCAT_ID  
		AND COMPANY_PARTNER.COMPANY_ID = COMPANY.COMPANY_ID  
        <cfif session.ep.our_company_info.sales_zone_followup eq 1>
        	 <!---Satis Takimda Ekip Lideri veya Satıs Takiminda Ekipde ise ilgili IMS ler--->
			AND 
			(
				COMPANY.IMS_CODE_ID IN (
											SELECT 
												DISTINCT IMS_ID
											FROM
												SALES_ZONES_ALL_2
											WHERE
												POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#"> 
												AND (COMPANY_CAT_IDS IS NULL OR (COMPANY_CAT_IDS IS NOT NULL AND ','+COMPANY_CAT_IDS+',' LIKE '%,'+CAST(COMPANY.COMPANYCAT_ID AS NVARCHAR)+',%'))
										)
        <!--- Satis bolgeleri ekibinde veya Satis bolgesinde yonetici ise kendisi ve altindaki IMS ler--->			
		  	<cfif get_hierarchies.recordcount>
			OR COMPANY.IMS_CODE_ID IN (
											SELECT
												DISTINCT IMS_ID
											FROM
												SALES_ZONES_ALL_1
											WHERE											
												<cfloop index="page_stock" from="0" to="#(ceiling(get_hierarchies.recordcount/row_block))-1#">
													<cfset start_row=(page_stock*row_block)+1>	
													<cfset end_row=start_row+(row_block-1)>
													<cfif (end_row) gte get_hierarchies.recordcount>
														<cfset end_row=get_hierarchies.recordcount>
													</cfif>
														(
														<cfloop index="add_stock" from="#start_row#" to="#end_row#">
															<cfif (add_stock mod row_block) neq 1> OR</cfif> SZ_HIERARCHY+'.' LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#get_hierarchies.sz_hierarchy[add_stock]#%">
														</cfloop>													
														)<cfif (ceiling(get_hierarchies.recordcount/row_block))-1 neq page_stock> OR</cfif>													
												</cfloop>											
										)                                
                                        
               </cfif>                         
            )
        </cfif>
		<cfif isdefined("x_control_ims") and x_control_ims eq 1 and session.ep.our_company_info.sales_zone_followup eq 1>
			AND
				(
				(COMPANY.COMPANY_ID IS NULL) 
				OR (COMPANY.COMPANY_ID IN (#PreserveSingleQuotes(my_ims_comp_list)#))
				)
		</cfif> 
</cfquery>
<cfif not GET_COMPANY.recordcount>
	<br />
	<cfset hata  = 11>
	<cfsavecontent variable="message"><cf_get_lang dictionary_id='57997.Şube Yetkiniz Uygun Değil'> <cf_get_lang dictionary_id='57998.Veya'> <cf_get_lang dictionary_id='58001.Böyle Bir Üye Bulunamadı'> !</cfsavecontent>
	<cfset hata_mesaj  = message>
	<cfinclude template="../../dsp_hata.cfm">
	<cfexit method="exittemplate">
</cfif>
<cfparam name="attributes.page" default='1'>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<script type="text/javascript">
	function connectAjax(div_id,data,assetpId)
	{
		if (div_id == 'ADD_MY_COMPANY_SYSTEMS')//sistem ekle
			var page = '<cfoutput>#request.self#?fuseaction=member.popupajax_add_company_subscription&cpid=#attributes.cpid#&get_company.manager_partner_id=#get_company.manager_partner_id#</cfoutput>';
		if (div_id == 'UPD_MY_COMPANY_ASSETS'+assetpId+'')//fiziki varlık ekle
			var page = '<cfoutput>#request.self#?fuseaction=member.popupajax_upd_company_physical_assets&cpid=#attributes.cpid#&assetp_id='+assetpId+'</cfoutput>';
		if (div_id == 'LIST_MY_COMPANY_WORKS')//İşler
			var page = '<cfoutput>#request.self#?fuseaction=myhome.popupajax_my_company_works&cpid=#attributes.cpid#&maxrows=#attributes.maxrows#</cfoutput>';
		AjaxPageLoad(page,''+div_id+'',1);
	}
</script>
<cfset icra="">
<cfif GET_COMPANY.COMPANY_LAW_REQUEST gt 0>
	<cfset icra="( " & #getLang('myhome',65)# & " )" >
</cfif>
<cfset pageHead = #getLang('main',173)# & " : " & #get_par_info(attributes.cpid,1,1,0)# & " " & #icra# >
<!---
<table class="dph">
	<tr>
		<td class="dpht">
        	<cf_get_lang_main no='173.Kurumsal Üye'> : <cfoutput><a href="#request.self#?fuseaction=member.form_list_company&event=det&cpid=#attributes.cpid#" >#get_par_info(attributes.cpid,1,1,0)#</a></cfoutput> <cfif GET_COMPANY.COMPANY_LAW_REQUEST gt 0><font color="FF0000">( <cf_get_lang no='65.İcralık'> )</font></cfif>
		</td>
		<td class="dphb">
        	
		</td>
	</tr>
</table> --->

<!--- Sayfa başlığı ve ikonlar--->
<!--- <cf_catalystHeader> --->

<!--- Sayfa ana kısım  --->
<cf_catalystHeader>
<cfset index=1>
<div class="col col-9 col-md-9 col-sm-12 col-xs-12">
	<!---Geniş alan: içerik---> 
	<cfinclude template="my_company_details_content.cfm">
</div>
<div class="col col-3 col-md-3 col-sm-12 col-xs-12">
	<!--- Yan kısım--->
	<cfinclude template="my_company_details_side.cfm">
</div>
<script>
	function send_link(){
		window.location.href = '<cfoutput>#request.self#?fuseaction=member.form_list_company&event=det&cpid=#attributes.cpid#</cfoutput>';
	}
</script>
