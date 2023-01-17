<cfif isdefined("attributes.req_id")>
	<cfquery name="get_related_order" datasource="#dsn3#">
		SELECT ORD.*,
		CASE
			WHEN LEN(SLI.ITEM) > 0 THEN SLI.ITEM
			ELSE PRT.PRIORITY
		END AS PRIORITY
		FROM 
			ORDERS ORD
			LEFT JOIN #dsn#.SETUP_PRIORITY PRT ON ORD.PRIORITY_ID = PRT.PRIORITY_ID
			LEFT JOIN #dsn#.SETUP_LANGUAGE_INFO SLI ON SLI.UNIQUE_COLUMN_ID = PRT.PRIORITY_ID
			AND SLI.COLUMN_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="PRIORITY">
			AND SLI.TABLE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="SETUP_PRIORITY">
			AND SLI.LANGUAGE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.language#">
		WHERE ORD.ORDER_ID 
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
			left join [SETUP_PRIORITY] on [SETUP_PRIORITY].PRIORITY_ID = PRO_PROJECTS.PRO_PRIORITY_ID
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
			left join [SETUP_PRIORITY] on [SETUP_PRIORITY].PRIORITY_ID = PRO_PROJECTS.PRO_PRIORITY_ID
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
			#dsn3#.TEXTILE_SAMPLE_REQUEST REQ,
			#dsn3#.[SETUP_OPPORTUNITY_TYPE] SOT
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
			PRO_PROJECTS,
			#dsn3#.TEXTILE_SAMPLE_REQUEST REQ,
			#dsn3#.[SETUP_OPPORTUNITY_TYPE] SOT
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
<!--- imajlar --->
<cf_wrk_images pid="#attributes.pid#" action_id='#attributes.req_id#' type="product" >
<!--- Belgeler --->
<cf_get_workcube_asset company_id="#session.ep.company_id#" asset_cat_id="-3" module_id='99' action_section='REQUEST_ID' action_id='#attributes.req_id#'>
<!---iliskili siparişler--->
<cfsavecontent  variable="message1"><cf_get_lang dictionary_id='32837.İlişkili Siparişler'>
</cfsavecontent>
<cf_box title="#message1#">
<table>
	<cfif get_related_order.recordcount>
	<cfoutput query="get_related_order">
		<tr>
			<td><a href="#request.self#?fuseaction=sales.list_order&event=upd&order_id=#order_id#" class="tableyazi">#order_number# - #PRIORITY#</a></td>
		</tr>
	</cfoutput>
	<cfelse>
		<tr>
			<td>
				<cf_get_lang dictionary_id='57484.Kayıt Yok'>
				</td>
			</tr>
	</cfif>
	</tr>
</table>
</cf_box>
<cfsavecontent  variable="message"><cf_get_lang dictionary_id='38303.İlişkili Projeler'>
</cfsavecontent>
<cf_box title="#message#">
<table>
	<cfif get_related_project.recordcount>
	<cfoutput query="get_related_project">
		<tr>
			<td><a href="#request.self#?fuseaction=project.projects&event=det&id=#project_id#" class="tableyazi">#project_head# #PRIORITY#</a></td>
		</tr>
	</cfoutput>
	<cfelse>
		<tr><td><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td></tr>
	</cfif>
</table>
</cf_box>

<!----
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
<cfsavecontent  variable="title"><cf_get_lang dictionary_id='62846.Planlanan Kurlar'>
</cfsavecontent>
<cf_box title="#title#">
		<cfinclude template="../../objects/display/dsp_money.cfm">
</cf_box>
<!---
<cfquery name="get_images" datasource="#dsn3#">
	SELECT IMAGE_ID,MEASURE_FILENAME 
	FROM TEXTILE_SAMPLE_REQUEST_IMAGE 
	WHERE REQ_ID = #GET_OPPORTUNITY.req_id#
	ORDER BY IMAGE_ID DESC
</cfquery>


<cf_box title="ÖLÇÜ TABLOSU">
	<cfform name="add_measure" action="#request.self#?fuseaction=textile.emptypopup_sample_add_image&type=add" enctype="multipart/form-data">
	   <input type="file" name="olcu_tablo" value="">
	   <input type="hidden" name="req_id" id="req_id" value="<cfoutput>#GET_OPPORTUNITY.req_id#</cfoutput>">
	   <input type="hidden" name="totalImagesCount" value="<cfoutput>#get_images.recordcount#</cfoutput>">
	   <input type="submit" class="btn btn-primary btn-small" value="Kaydet">
	   <div class="col col-12"> 	
			<table class="workDevList" id="body_olcu">
				<cfloop query="get_images">
					<tr>
						<td><a class="tableyazi" href="#request.self#?fuseaction=objects.popup_download_file&file_name=olcutablo/#get_images.measure_filename#"> #get_images.measure_filename#</a></td>
						<td><a style="cursor:pointer;" onclick="javascript:if(confirm('#getLang('main',1057)#')) location.href='#request.self#?fuseaction=textile.emptypopup_sample_add_image&type=del&image_id=#get_images.IMAGE_ID#&req_id=#GET_OPPORTUNITY.req_id#'; else return false;"><img src="/images/delete_list.gif" border="0" alt="#getLang('main',51)#"></a>	</td>
					</tr>
				</cfloop>
			</table>
	   </div>
   </cfform>
</cf_box>	
--->
<!---//ilişkili siparişler--->

<!--- XML de Fırsatta analiz girilsinmi parametresi BK 20090112 --->
<!---
	<cf_get_member_analysis action_type='OPPORTUNITY' action_type_id='#attributes.opp_id#' company_id='#get_opportunity.company_id#' partner_id='#get_opportunity.partner_id#' consumer_id='#get_opportunity.consumer_id#'>
--->

