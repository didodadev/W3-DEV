

<cfif isdefined("attributes.req_id")>
	<cfquery name="get_related_order" datasource="#dsn3#">
		SELECT *FROM 
			ORDERS
		WHERE ORDER_ID 
				IN(
				SELECT ORDER_ID FROM ORDER_ROW
				WHERE RELATED_ACTION_ID=#attributes.req_id# AND RELATED_ACTION_TABLE='TEXTILE_SAMPLE_REQUEST'
				)
	</cfquery>

</cfif>

<cfif isdefined("attributes.req_id")>
	<cfquery name="get_related_project" datasource="#dsn#">
		SELECT 
			*
		FROM 
			PRO_PROJECTS
		WHERE
			<cfif len(GET_OPPORTUNITY.related_project_id)>
				PROJECT_ID=#GET_OPPORTUNITY.related_project_id#
			<cfelse>
				1=2
			</cfif>
		UNION ALL
		
		SELECT 
			*
		FROM 
			PRO_PROJECTS
		WHERE
			<cfif len(GET_OPPORTUNITY.related_project_id)>
				RELATED_PROJECT_ID=#GET_OPPORTUNITY.related_project_id#
			<cfelse>
				1=2
			</cfif>
		ORDER BY PROJECT_ID
		
			
	</cfquery>
</cfif>
<cfif isdefined("attributes.req_id")>
	<cfquery name="get_related_req" datasource="#dsn#">
		SELECT 
			REQ.REQ_NO,
			REQ.REQ_ID,
			SOT.OPPORTUNITY_TYPE
		FROM
			PRO_PROJECTS,
			[workcube_akarteks_1].TEXTILE_SAMPLE_REQUEST REQ,
			[workcube_akarteks_1].[SETUP_OPPORTUNITY_TYPE] SOT
		WHERE
			REQ.PROJECT_ID=PRO_PROJECTS.PROJECT_ID AND
			REQ.REQ_TYPE_ID=SOT.OPPORTUNITY_TYPE_ID AND
			<cfif len(GET_OPPORTUNITY.related_project_id)>
			PRO_PROJECTS.PROJECT_ID=#GET_OPPORTUNITY.related_project_id#
			<cfelse>
				1=2
			</cfif>
		UNION ALL
		SELECT 
			REQ.REQ_NO,
			REQ.REQ_ID,
			SOT.OPPORTUNITY_TYPE
		FROM
			[workcube_akarteks].PRO_PROJECTS,
			[workcube_akarteks_1].TEXTILE_SAMPLE_REQUEST REQ,
			[workcube_akarteks].[workcube_akarteks_1].[SETUP_OPPORTUNITY_TYPE] SOT
		WHERE
			REQ.PROJECT_ID=PRO_PROJECTS.PROJECT_ID AND
			REQ.REQ_TYPE_ID=SOT.OPPORTUNITY_TYPE_ID AND
			<cfif len(GET_OPPORTUNITY.related_project_id)>
			RELATED_PROJECT_ID=#GET_OPPORTUNITY.related_project_id#
			<cfelse>
				1=2
			</cfif>
		ORDER BY 
			REQ.REQ_NO	
	</cfquery>
</cfif>


<cfif isdefined("attributes.req_id")>
	<cfquery name="get_related_porder" datasource="#dsn#">
		SELECT 
			PORDER.PARTY_NO,
			PORDER.PARTY_ID
		FROM 
			#dsn3#.TEXTILE_PRODUCTION_ORDERS_MAIN PORDER
		WHERE
			PORDER.REQ_ID=#attributes.req_id#
	</cfquery>
</cfif>
    
	
		
<!---uye hesap bilgileri-----
<cfif isdefined("contact_type")><cf_display_member action_id="#member_id#" action_type_id="#contact_type#" dsp_account="#dsp_account#"></cfif>
---->


<!--- Belgeler --->
<cf_get_workcube_asset company_id="#session.ep.company_id#" asset_cat_id="-3" module_id='99' action_section='REQUEST_ID' action_id='#attributes.req_id#'>
<!---iliskili siparişler--->
<cf_box
title="İLİŞKİLİ SİPARİŞLER"
>
<table>
	
	<cfif get_related_order.recordcount>
	<cfoutput query="get_related_order">
		<tr>
			<td><a href="#request.self#?fuseaction=sales.list_order&event=upd&order_id=#order_id#" class="tableyazi">#order_number#</a></td>
		</tr>
	</cfoutput>
	<cfelse>
		<tr><td>Kayıt Yok!</td></tr>
	</cfif>
	</tr>
</table>
</cf_box>
<cf_box title="İLİŞKİLİ PROJELER">
<table>
	<cfif get_related_project.recordcount>
	<cfoutput query="get_related_project">
		<tr>
			<td><a href="#request.self#?fuseaction=project.projects&event=det&id=#project_id#" class="tableyazi">#project_head#</a></td>
		</tr>
	</cfoutput>
	<cfelse>
		<tr><td>Kayıt Yok!</td></tr>
	</cfif>
</table>
</cf_box>
<cf_box title="İLİŞKİLİ MODELLER">
	<table>
		<cfif get_related_project.recordcount>
			<cfoutput query="get_related_req">
				
				
					<tr>
						<td><a href="#request.self#?fuseaction=textile.list_sample_request&event=det&req_id=#req_id#&req_no=#req_no#" class="tableyazi">#req_no#</a>-#OPPORTUNITY_TYPE#</td>
						
					</tr>
				
			</cfoutput>
		<cfelse>
			<tr><td>Kayıt Yok!</td></tr>
		</cfif>
	</table>
</cf_box>

<!----
<cf_box title="ÜRETİM EMİRLERİ">
	<table>
		<cfif get_related_porder.recordcount>
		<cfoutput query="get_related_porder">
			<tr>
				<td><a href="#request.self#?fuseaction=textile.order&event=upd&party_id=#party_id#" class="tableyazi">#party_no#</a></td>
			</tr>
		</cfoutput>
		<cfelse>
			<tr><td>Kayıt Yok!</td></tr>
		</cfif>
	</table>
</cf_box>
---->

<cf_box title="PLANLANAN KURLAR">
		<cfinclude template="../../objects/display/dsp_money.cfm">
</cf_box>



<!---//ilişkili siparişler--->

<!--- XML de Fırsatta analiz girilsinmi parametresi BK 20090112 --->
<!---
	<cf_get_member_analysis action_type='OPPORTUNITY' action_type_id='#attributes.opp_id#' company_id='#get_opportunity.company_id#' partner_id='#get_opportunity.partner_id#' consumer_id='#get_opportunity.consumer_id#'>
--->

