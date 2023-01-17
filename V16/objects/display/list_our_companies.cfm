<!--- Bu popup FB 20070619 da eklenen is_our_comp ve is_branch parametreleri ile calisir hale getirilmistir. 
	is_our_comp : yetkili olunmayan sirketlerin gelmemesi
	is_branch : yetkili olunan subelerin gelmesi --->
<cfif isdefined("attributes.is_our_comp")>
	<cfquery name="get_my_company" datasource="#dsn#">
			SELECT DISTINCT
				SP.OUR_COMPANY_ID
			FROM 
				SETUP_PERIOD SP, 
				EMPLOYEE_POSITION_PERIODS EP 
			WHERE 
				EP.PERIOD_ID = SP.PERIOD_ID AND 
				EP.POSITION_ID IN (SELECT POSITION_ID FROM EMPLOYEE_POSITIONS WHERE POSITION_CODE = #session.ep.position_code#)
			ORDER BY
				SP.OUR_COMPANY_ID
	</cfquery>
</cfif>
<cfif isdefined("attributes.is_branch")>
	<cfquery name="get_branch" datasource="#dsn#">
		SELECT 
			BRANCH.BRANCH_ID
		FROM
			BRANCH,
			EMPLOYEE_POSITION_BRANCHES 
		WHERE
			BRANCH.BRANCH_ID = EMPLOYEE_POSITION_BRANCHES.BRANCH_ID AND
			EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = #session.ep.position_code#
			<cfif isdefined("attributes.is_our_comp")>
			AND BRANCH.COMPANY_ID IN (#valuelist(get_my_company.our_company_id,',')#)
			</cfif>
	</cfquery>
	<cfquery name="get_our_companies" datasource="#dsn#">
		SELECT
			OC.COMP_ID,
			OC.COMPANY_NAME,
			B.BRANCH_ID,
			B.BRANCH_NAME
		FROM
			OUR_COMPANY OC,
			BRANCH B
		WHERE
			1=1
			<cfif isdefined("attributes.is_our_comp")>
			AND OC.COMP_ID IN (#valuelist(get_my_company.our_company_id,',')#)
			</cfif>
			<cfif isdefined("attributes.is_branch") and get_branch.recordcount>
			AND B.BRANCH_ID IN (#valuelist(get_branch.branch_id,',')#)
			<cfelseif isdefined("attributes.is_branch") and not get_branch.recordcount>
			AND 1=0
			</cfif>
			AND B.COMPANY_ID = OC.COMP_ID
		ORDER BY
			OC.COMPANY_NAME,
			B.BRANCH_NAME
	</cfquery>
<cfelse>
	<cfquery name="get_our_companies" datasource="#dsn#">
		SELECT
			OC.COMP_ID,
			OC.COMPANY_NAME
		FROM
			OUR_COMPANY OC
		
		<cfif isdefined("attributes.is_our_comp")>
		WHERE
			OC.COMP_ID IN (#valuelist(get_my_company.our_company_id,',')#)
		</cfif>
		ORDER BY
			OC.COMPANY_NAME
	</cfquery>
</cfif>
<cfparam name="attributes.modal_id" default="">
<cfsavecontent variable="message"><cf_get_lang dictionary_id='33349.Şirketlerimiz'></cfsavecontent>
<cf_box title="#message#"   popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<cf_flat_list>
		<thead>
			<tr> 
				<th width="55"><cf_get_lang dictionary_id='57487.No'></th>
				<th><cf_get_lang dictionary_id='58485.Şirket Adı'></th>
				<cfif isdefined("attributes.is_branch")><th><cf_get_lang dictionary_id='29532.Şube Adı'></th></cfif>
			</tr>
		</thead>
		<tbody>
			<cfif get_our_companies.recordcount>
				<cfoutput query="get_our_companies">
					<tr>
						<td>#currentrow#</td>
						<td><a href="javascript://" onClick="add_company('#comp_id#','#company_name#');" class="tableyazi">#company_name#</a></td>
						<cfif isdefined("attributes.is_branch")><td>#branch_name#</td></cfif>
					</tr>
				</cfoutput>
				<cfelse>
					<tr>
						<td colspan="4"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
					</tr>
			</cfif>
		</tbody>
	</cf_flat_list>
</cf_box>
<script type="text/javascript">
function add_company(id,name)
{
	<cfif isdefined("attributes.field_name")>
		<cfif isdefined("attributes.draggable")>document<cfelse>window.opener</cfif>.<cfoutput>#field_name#</cfoutput>.value = name;
	</cfif>
	<cfif isdefined("attributes.field_id")>
		<cfif isdefined("attributes.draggable")>document<cfelse>window.opener</cfif>.<cfoutput>#field_id#</cfoutput>.value = id;
	</cfif>
<cfif not isdefined("attributes.draggable")>window.close();<cfelseif isdefined("attributes.draggable")>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );</cfif>
}
</script>
