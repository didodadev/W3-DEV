<cfsetting showdebugoutput="no">
<cf_get_lang_set module_name="project"><!--- sayfanin en altinda kapanisi var --->
<cfif isdefined('attributes.is_del') and isdefined('attributes.del_work_id')>
	<cfquery name="upd_work" datasource="#dsn#">
		UPDATE 
        	PRO_WORKS 
        SET 
			<cfif attributes.contract_type eq 1>PURCHASE_CONTRACT_ID = NULL,PURCHASE_CONTRACT_AMOUNT = NULL<cfelse>SALE_CONTRACT_ID = NULL,SALE_CONTRACT_AMOUNT = NULL</cfif> 
        WHERE 
        	WORK_ID = #attributes.del_work_id#
	</cfquery>
</cfif>
<cfquery name="get_contract_works" datasource="#dsn#">
	SELECT 
		 CASE 
			WHEN IS_MILESTONE = 1 THEN WORK_ID
			WHEN IS_MILESTONE <> 1 THEN ISNULL(MILESTONE_WORK_ID,0)
		END AS NEW_WORK_ID,
		CASE 
			WHEN IS_MILESTONE = 1 THEN 0
			WHEN IS_MILESTONE <> 1 THEN 1
		END AS TYPE,
		WORK_ID,
		WORK_HEAD,
		WORK_NO,
		ESTIMATED_TIME,
		TO_COMPLETE,
		COMPLETED_AMOUNT,
		SALE_CONTRACT_AMOUNT,
		PURCHASE_CONTRACT_AMOUNT,
		RC.CONTRACT_TYPE,
		RC.CONTRACT_CALCULATION,
		RC.CONTRACT_AMOUNT,
        PRO_WORKS.AVERAGE_AMOUNT,
        PRO_WORKS.AVERAGE_AMOUNT_UNIT,
        PRO_WORKS.EXPECTED_BUDGET,
        PRO_WORKS.EXPECTED_BUDGET_MONEY,
        SU.UNIT
	FROM 
		PRO_WORKS
		RIGHT JOIN #dsn3_alias#.RELATED_CONTRACT RC ON (RC.CONTRACT_TYPE = 1 AND RC.CONTRACT_ID = PRO_WORKS.PURCHASE_CONTRACT_ID) OR (RC.CONTRACT_TYPE = 2 AND RC.CONTRACT_ID = PRO_WORKS.SALE_CONTRACT_ID)
		RIGHT JOIN OUR_COMPANY OC ON OC.COMP_ID = RC.OUR_COMPANY_ID AND OC.COMP_ID = PRO_WORKS.OUR_COMPANY_ID
        LEFT JOIN SETUP_UNIT SU ON PRO_WORKS.AVERAGE_AMOUNT_UNIT = SU.UNIT_ID
    WHERE 
		RC.CONTRACT_ID = #attributes.contract_id#
	ORDER BY
		NEW_WORK_ID, 
		TYPE,
		TARGET_START 
</cfquery>
<cfset work_h_list = ''>
<cfif get_contract_works.recordcount>
	<cfset work_h_list = valuelist(get_contract_works.WORK_ID)>
	<cfquery name="get_harcanan_zaman" datasource="#DSN#">
		SELECT
			SUM(ISNULL(EXPENSED_MINUTE,0)) AS HARCANAN_DAKIKA,
			WORK_ID
		FROM
			TIME_COST
		WHERE
			WORK_ID IN (#work_h_list#)
		GROUP BY
			WORK_ID
	</cfquery>
	<cfset work_h_list = listsort(listdeleteduplicates(valuelist(get_harcanan_zaman.WORK_ID,',')),'numeric','ASC',',')>
	<cfquery name="getToplamAs" dbtype="query">
		SELECT SUM(ESTIMATED_TIME)/60 TOPLAM_AS FROM get_contract_works
	</cfquery>
</cfif>
<div id="contract_work_div_<cfoutput>#attributes.contract_id#</cfoutput>">
<cf_grid_list>
    <thead>
		<tr>
			<th width="15"></th>
			<th width="100"><cf_get_lang no='352.İş No'></th>
			<th width="200"><cf_get_lang no='93.İş'></th>
			<th><cf_get_lang no='95.Öngörülen Süre'></th>
			<th><cf_get_lang no='55.Tahmini Bütçe'></th>
            <th><cf_get_lang_main no='1888.Tahmini'><cf_get_lang_main no='223.Miktar'></th>
			<th><cf_get_lang no="22.Tamamlanan Miktar"></th>
			<th><cf_get_lang no='187.Tamamlanma'> %</th>
			<th><cf_get_lang no='186.Gerçekleşen Süre'></th>
			<th width="55"><cf_get_lang_main no="226.Birim Fiyat"></th>
			<th width="15"><a href="javascript://"><i class="fa fa-pencil"></i></a></th>
			<th width="15"><a href="javascript://" onClick="pencere_ac_works();"><i class="fa fa-plus"></i></a></th>
		</tr>
        </thead>
        <tbody>
		<cfif get_contract_works.recordcount>
			<cfoutput query="get_contract_works">
				<input type="hidden" name="work_id" id="work_id" value="#work_id#" />
				<tr>
					<td>#currentrow#</td>
					<td><a href="#request.self#?fuseaction=project.works&event=det&id=#work_id#" target="_blank">#work_no#</a></td>
					<td><a href="#request.self#?fuseaction=project.works&event=det&id=#work_id#" target="_blank"><cfif type eq 0><font color="CC0000"><b>(M) #work_head#</b></font><cfelse>&nbsp;&nbsp;&nbsp;#work_head#</cfif></a></td>
					<td>
						<cfif isdefined('estimated_time') and len(estimated_time)>
							<cfset liste=estimated_time/60>
							<cfset saat=listfirst(liste,'.')>
							<cfset dak=estimated_time-saat*60>
							#saat# saat #dak# dk
						</cfif>
					</td>
					<td class="text-right" id="expected_budget">
						<cfif attributes.x_contract_work_budget eq 0>
							<cfif CONTRACT_CALCULATION eq 1>
								<cfif len(ESTIMATED_TIME) and ESTIMATED_TIME neq 0>
									<cfset adam_saat = ESTIMATED_TIME/60>
								<cfelse>
									<cfset adam_saat = 0>
								</cfif>
								<cfif (len(CONTRACT_AMOUNT) and CONTRACT_AMOUNT neq 0) and (len(adam_saat) and adam_saat neq 0) and (len(getToplamAs.toplam_as) and getToplamAs.toplam_as neq 0)>
									<cfset expected_budget_ = (CONTRACT_AMOUNT/getToplamAs.toplam_as)*adam_saat>
								<cfelse>
									<cfset expected_budget_ = 0>
								</cfif>
								#TLFormat(expected_budget_,2)#
							</cfif>
						<cfelse>
							#TLFormat(expected_budget,2)# #EXPECTED_BUDGET_MONEY#
						</cfif>
					</td>
					<td class="text-right">#TLFormat(AVERAGE_AMOUNT,2)# #UNIT#</td>
                    <td class="text-right">#TLFormat(COMPLETED_AMOUNT,2)#</td>
					<td class="text-right">#to_complete# %</td>
					<td class="text-right">
						<cfif listfindnocase(work_h_list,work_id)>
							<cfset harcanan_ = get_harcanan_zaman.HARCANAN_DAKIKA[listfind(work_h_list,work_id,',')]>
							<cfset liste=harcanan_/60>
							<cfset saat=listfirst(liste,'.')>
							<cfset dak=harcanan_-saat*60>
							#saat# <cf_get_lang_main no="79.saat"> #dak# <cf_get_lang_main no="1415.dk">
						</cfif>
					</td>
					<td class="text-right">
						<cfif contract_type eq 1>#TLFormat(PURCHASE_CONTRACT_AMOUNT,2)#<cfelse>#TLFormat(SALE_CONTRACT_AMOUNT,2)#</cfif>
                    </td>
					<td><a href="#request.self#?fuseaction=project.works&event=det&id=#work_id#" target="_blank"><i class="fa fa-pencil"></i></a></td>
					<td><a href="javascript://" onClick="delete_contract_work(#work_id#,#contract_type#);"><i class="fa fa-minus"></i></a></td> 
				</tr>
		   </cfoutput>
		<cfelse>
			<tr>
				<td colspan="12"><cf_get_lang_main no='72.Kayıt Bulunamadı'> !</td>
			</tr>
		</cfif>
    </tbody>
</cf_grid_list>
</div>
<script type="text/javascript">
function delete_contract_work(work_id,contract_type)
{
if(confirm("<cf_get_lang dictionary_id='54755.İş ile sözleşmenin ilişkisi kaldırılacak'>. <cf_get_lang dictionary_id='48488.Emin misiniz'>"))
	{
	div_id = 'contract_work_div_<cfoutput>#attributes.contract_id#</cfoutput>';
	var send_address = '<cfoutput>#request.self#?fuseaction=contract.emptypopup_list_contract_works&contract_id=#attributes.contract_id#&x_project_works=#attributes.x_project_works#&x_contract_work_budget=#attributes.x_contract_work_budget#&x_contract_work_price=#attributes.x_contract_work_price#&is_del=1&del_work_id='+work_id+'&contract_type='+contract_type</cfoutput>;
	AjaxPageLoad(send_address,div_id,1);
	}
else
	{
	return false;
	}
}
function loader_page(work_id)
{
	div_id = 'contract_work_div_<cfoutput>#attributes.contract_id#</cfoutput>';
	var send_address = '<cfoutput>#request.self#?fuseaction=contract.emptypopup_list_contract_works&contract_id=#attributes.contract_id#&x_project_works=#attributes.x_project_works#&x_contract_work_budget=#attributes.x_contract_work_budget#&x_contract_work_price=#attributes.x_contract_work_price#</cfoutput>';
	AjaxPageLoad(send_address,div_id,0);
}
function pencere_ac_works()
{
	<cfif attributes.x_project_works eq 1>
		if(document.getElementById('project_id')){
			if(document.getElementById('project_id').value != document.getElementById('old_project_id').value)
			{
				alert("<cf_get_lang dictionary_id='54756.Projeyi Değiştirdiniz Lütfen Sözleşmeyi Güncelleyiniz'>");
				return false;
			}
			if(document.getElementById('project_id') == undefined || document.getElementById('project_id').value == "" || document.getElementById('project_head').value == "")
			{
				alert("<cf_get_lang_main no='59.Eksik Veri'> : <cf_get_lang_main no='4.Proje'>");
				return false;
			}
			windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_add_related_work&multiple_selection=1&related_contract_id=#attributes.contract_id#&project_id='+document.getElementById('project_id').value+'&project_head='+document.getElementById('project_head').value+'&form_submitted=1&call_function=loader_page(#attributes.contract_id#)</cfoutput>','medium');
		}
		<cfif isdefined("attributes.project_id") and len(attributes.project_id)>
			windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_add_related_work&multiple_selection=1&related_contract_id=#attributes.contract_id#&project_id=#attributes.project_id#&project_head=#get_project_name(attributes.project_id)#&form_submitted=1&call_function=loader_page(#attributes.contract_id#)</cfoutput>','medium');
		<cfelse>
			alert("<cf_get_lang dictionary_id='57471.Eksik Veri'> : <cf_get_lang dictionary_id='57416.Proje'>");
			return false;
		</cfif>
	<cfelse>
		windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_add_related_work&multiple_selection=1&related_contract_id=#attributes.contract_id#&form_submitted=1&call_function=loader_page(#attributes.contract_id#)</cfoutput>','medium');
	</cfif>
}
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
