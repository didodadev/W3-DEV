<cfquery name="get_list_training_trainer" datasource="#dsn#">
	SELECT
		*
	FROM
		TRAINING_TRAINER
	WHERE
		<cfif isdefined("attributes.employee_id") and len(attributes.employee_id) and attributes.employee_id neq 0>
			EMPLOYEE_ID = #attributes.employee_id#
		<!--- <cfelseif isdefined("attributes.partner_id") and len(attributes.partner_id) and attributes.partner_id neq 0>
			PARTNER_ID = #attributes.partner_id# --->
		<cfelseif isdefined("attributes.partner_company_id") and len(attributes.partner_company_id) and attributes.partner_company_id neq 0>
			PARTNER_COMPANY_ID = #attributes.partner_company_id#
		<cfelseif isdefined("attributes.consumer_id") and len(attributes.consumer_id) and attributes.consumer_id neq 0>
			CONSUMER_ID = #attributes.consumer_id#
		</cfif>
</cfquery>
<cfset trainingsec_id_list=''>
<cfoutput query="get_list_training_trainer">
	 <cfif not listfind(trainingsec_id_list,training_sec_id)>
		<cfset trainingsec_id_list=listappend(trainingsec_id_list,training_sec_id)>
	 </cfif>
</cfoutput>

<cfif len(trainingsec_id_list)>
	<cfquery name="get_training_sec" datasource="#dsn#">
		SELECT
			TRAINING_CAT.TRAINING_CAT_ID,
			TRAINING_SEC.TRAINING_SEC_ID,
			TRAINING_SEC.SECTION_NAME,
			TRAINING_CAT.TRAINING_CAT
		FROM
			TRAINING_SEC,
			TRAINING_CAT
		WHERE
			TRAINING_SEC.TRAINING_CAT_ID = TRAINING_CAT.TRAINING_CAT_ID
			AND TRAINING_SEC.TRAINING_SEC_ID IN (#trainingsec_id_list#)
	</cfquery>
</cfif>
<cfset trainingsec_id_list=listsort(trainingsec_id_list,"numeric")>
<cfsavecontent variable="head_">
	<cf_get_lang dictionary_id ='33522.Eğitimci'>: 
	 <cfif isdefined("attributes.employee_id") and len(attributes.employee_id)>
		<cfoutput>#get_emp_info(attributes.employee_id,0,0)#</cfoutput>
	<cfelseif isdefined("attributes.partner_id") and len(attributes.partner_id)>
		<cfoutput>#get_par_info(attributes.partner_id,0,-1,0)#</cfoutput>
	<cfelseif isdefined("attributes.partner_company_id") and len(attributes.partner_company_id)>
		<cfoutput>#get_par_info(attributes.partner_company_id,1,1,0)#</cfoutput>
	<cfelseif isdefined("attributes.consumer_id") and len(attributes.consumer_id)>
		<cfoutput>#get_cons_info(attributes.consumer_id,0,0)#</cfoutput>
	</cfif>
</cfsavecontent>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box title="#head_#" scroll="1" collapsable="1" uidrop="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
<cf_grid_list>
	<thead>
		<tr>
			<th colspan="3" height="25" class="form-title"><cf_get_lang dictionary_id ='34032.Eğitim Konuları'></th>
		</tr>
		<tr>
			<th width="100"><cf_get_lang dictionary_id ='34033.Kategori Bölüm'></th>
			<th><cf_get_lang dictionary_id='58258.Maliyet'></th>
			<th width="200"><cf_get_lang dictionary_id ='57629.Açıklama'></th>
		</tr>
	</thead>
	<tbody>
		<cfif get_list_training_trainer.RecordCount>
			<cfoutput query="get_list_training_trainer">
			  <tr>
				  <td>#get_training_sec.training_cat[listfind(trainingsec_id_list,TRAINING_SEC_ID,',')]# / #get_training_sec.section_name[listfind(trainingsec_id_list,TRAINING_SEC_ID,',')]#
				  </td>
				  <td>#training_cost# #training_cost_money#</td>
				  <td>#training_detail#</td>
			   </tr>
			</cfoutput>
		<cfelse>
			<tr>
			  <td colspan="3"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
			</tr>
		</cfif>
	</tbody>
</cf_grid_list>
</cf_box>
</div>