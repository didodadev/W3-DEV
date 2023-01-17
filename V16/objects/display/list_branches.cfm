<!--- is_get_all paragondermetresi bütün subeleri gormek istedigimizde kullaniliyor. --->
<cfif ((not session.ep.ehesap and not isDefined("attributes.is_get_all")) or isdefined("attributes.is_store_module"))>
	<cfinclude template="../../hr/query/get_emp_branches.cfm">
</cfif>
<cfparam name="attributes.keyword" default="">
<cfif isdefined("attributes.is_form_submitted") >
    <cfquery name="GET_BRANCHES" datasource="#dsn#">
        SELECT 
            ZONE.ZONE_NAME,
            BRANCH.BRANCH_NAME,
            BRANCH.BRANCH_ID,
            OUR_COMPANY.NICK_NAME
        FROM 
            BRANCH,
            ZONE,
            OUR_COMPANY
        WHERE 
            BRANCH.COMPANY_ID = OUR_COMPANY.COMP_ID AND 
            ZONE.ZONE_ID = BRANCH.ZONE_ID AND
            ZONE_STATUS = 1 AND
            BRANCH_STATUS = 1
            <cfif len(attributes.keyword)>AND BRANCH.BRANCH_NAME LIKE '%#attributes.keyword#%'</cfif>
            <cfif ((not session.ep.ehesap and not isDefined("attributes.is_get_all")) or isdefined("attributes.is_store_module"))>AND BRANCH.BRANCH_ID IN (#emp_branch_list#)</cfif>
            <cfif isdefined("attributes.branch_hier")>AND BRANCH.HIERARCHY LIKE '%.MESB'</cfif>
            <!--- branch_hier parametresi hierarşi kodunda MESB arar; merkez şubeleri getirir GA30052005 --->
        ORDER BY
            BRANCH.HIERARCHY,
            ZONE.ZONE_NAME,
            BRANCH.BRANCH_NAME
    </cfquery>
<cfelse>
	<cfset GET_BRANCHES.recordcount = 0>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default="#GET_BRANCHES.recordcount#">
<cfparam name="attributes.modal_id" default="">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<script type="text/javascript">
<cfif isdefined('attributes.field_row_count')>
	rowCount = parseInt(<cfif isdefined("attributes.draggable")>document<cfelse>opener.document</cfif>.getElementById('<cfoutput>#attributes.field_row_count#</cfoutput>').value);
</cfif>
<cfif not isdefined("attributes.coklu_secim")>
	function gonder(branch_id,branch)
	{
		<cfoutput>
			<cfif isdefined("field_branch_id")>
				<cfif isdefined("attributes.draggable")>document<cfelse>opener.document</cfif>.#field_branch_id#.value = branch_id;
			</cfif>	
			<cfif isdefined("field_branch_name")>
				<cfif isdefined("attributes.draggable")>document<cfelse>opener.document</cfif>.#field_branch_name#.value = branch;
			</cfif>
		</cfoutput>
		<cfif not isdefined("attributes.draggable")>window.close();<cfelse>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );</cfif>
	}
<cfelse>
	function gonder(branch_id,branch)
	{
		<cfif isdefined('attributes.field_row_count')>
			var newRow;
			var newCell;
			rowCount = rowCount + 1;
			newRow = <cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.getElementById('branches').insertRow(<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.getElementById("branches").rows.length);
			<cfif isdefined("attributes.draggable")>document<cfelse>opener.document</cfif>.getElementById('<cfoutput>#attributes.last_record#</cfoutput>').value = parseInt(<cfif isdefined("attributes.draggable")>document<cfelse>opener.document</cfif>.getElementById('<cfoutput>#attributes.last_record#</cfoutput>').value) + 1;
			<cfif isdefined('attributes.last_record')>
				newRow.setAttribute("id","branch_row"+<cfif isdefined("attributes.draggable")>document<cfelse>opener.document</cfif>.getElementById('<cfoutput>#attributes.last_record#</cfoutput>').value);
			<cfelse>
				newRow.setAttribute("id","branch_row"+rowCount);		
			</cfif>
			newRow.setAttribute("style","display:''");
			newCell = newRow.insertCell(newRow.cells.length);		
			<cfif isdefined('attributes.last_record')>
				<cfif isdefined('attributes.ajanda') and len(attributes.ajanda)>
					newCell.innerHTML = '<a href="javascript://" onClick="del_row('+<cfif isdefined("attributes.draggable")>document<cfelse>opener.document</cfif>.getElementById('<cfoutput>#attributes.last_record#</cfoutput>').value+');"><i class="fa fa-minus"></i></a>&nbsp;<input type="hidden" name="row_count" value="'+<cfif isdefined("attributes.draggable")>document<cfelse>opener.document</cfif>.getElementById('<cfoutput>#attributes.last_record#</cfoutput>').value+'"><input type="hidden" name="branch_id'+<cfif isdefined("attributes.draggable")>document<cfelse>opener.document</cfif>.getElementById('<cfoutput>#attributes.last_record#</cfoutput>').value+'" id="branch_id'+<cfif isdefined("attributes.draggable")>document<cfelse>opener.document</cfif>.getElementById('<cfoutput>#attributes.last_record#</cfoutput>').value+'" value="' + branch_id + '">' ;
					newCell = newRow.insertCell(newRow.cells.length);
					newCell.innerHTML = branch ;
				<cfelse>
					newCell.innerHTML = '<a href="javascript://" onClick="del_row('+<cfif isdefined("attributes.draggable")>document<cfelse>opener.document</cfif>.getElementById('<cfoutput>#attributes.last_record#</cfoutput>').value+');"><img src="/images/delete_list.gif"  align="absmiddle" border="0"></a>&nbsp;<input type="hidden" name="row_count" value="'+<cfif isdefined("attributes.draggable")>document<cfelse>opener.document</cfif>.getElementById('<cfoutput>#attributes.last_record#</cfoutput>').value+'"><input type="hidden" name="branch_id'+<cfif isdefined("attributes.draggable")>document<cfelse>opener.document</cfif>.getElementById('<cfoutput>#attributes.last_record#</cfoutput>').value+'" id="branch_id'+<cfif isdefined("attributes.draggable")>document<cfelse>opener.document</cfif>.getElementById('<cfoutput>#attributes.last_record#</cfoutput>').value+'" value="' + branch_id + '">' + branch + '';
				</cfif>
			
			<cfelse>
				newCell.innerHTML = '<a href="javascript://" onClick="del_row('+rowCount+');"><img src="/images/delete_list.gif"  align="absmiddle" border="0"></a>&nbsp;<input type="hidden" name="row_count" value="'+rowCount+'"><input type="hidden" name="branch_id'+rowCount+'" id="branch_id'+rowCount+'" value="' + branch_id + '">' + branch + '';
			</cfif>
			<cfif isdefined("attributes.draggable")>document<cfelse>opener.document</cfif>.getElementById('<cfoutput>#attributes.field_row_count#</cfoutput>').value = parseInt(rowCount);
		<cfelse>
			var kontrol =0;
			uzunluk=opener.<cfoutput>#attributes.field_name#</cfoutput>.length;
			for(i=0;i<uzunluk;i++){
				if(<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.field_name#</cfoutput>.options[i].value==branch_id){
					kontrol=1;
				}
			}
			if(kontrol==0){
				<cfif isDefined("attributes.field_name")>
					x = <cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.field_name#</cfoutput>.length;
					<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.field_name#</cfoutput>.length = parseInt(x + 1);
					<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.field_name#</cfoutput>.options[x].value = branch_id;
					<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.field_name#</cfoutput>.options[x].text = branch;
				</cfif>
				}
		</cfif>
		
	}
</cfif>
</script>
<cfset url_string = "">
<cfif isdefined("attributes.field_branch_id")>
	<cfset url_string = "#url_string#&field_branch_id=#attributes.field_branch_id#">
</cfif>
<cfif isdefined("attributes.field_branch_name")>
	<cfset url_string = "#url_string#&field_branch_name=#attributes.field_branch_name#">
</cfif>
<cfif isdefined("attributes.coklu_secim")>
	<cfset url_string = "#url_string#&coklu_secim=#attributes.coklu_secim#">
</cfif>
<cfif isdefined("attributes.ajanda")>
	<cfset url_string = "#url_string#&ajanda=#attributes.ajanda#">
</cfif>
<cfif isdefined("attributes.branch_hier")>
	<cfset url_string = "#url_string#&branch_hier">
</cfif>
<cfif isdefined("attributes.is_store_module")>
	<cfset url_string = "#url_string#&is_store_module=#attributes.is_store_module#">
</cfif>
<cfif isDefined("attributes.field_name")>
	<cfset url_string = "#url_string#&field_name=branches">
</cfif>
<cfif isDefined("attributes.field_row_name")>
	<cfset url_string = "#url_string#&field_row_name=branch_row">
</cfif>
<cfif isDefined("attributes.field_row_count")>
	<cfset url_string = "#url_string#&field_row_count=row_count">
</cfif>
<cfif isDefined("attributes.is_get_all")>
  <cfset url_string = "#url_string#&is_get_all">
</cfif>
<cfif isDefined("attributes.last_record")>
	<cfset url_string = "#url_string#&last_record=last_record">
</cfif>
<cfif isDefined("attributes.is_form_submitted")>
	<cfset url_string = "#url_string#&is_form_submitted=is_form_submitted">
</cfif>

<cf_box title="#getLang('','Şubeler',29434)#"  scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<cf_wrk_alphabet keyword="url_string" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<cfform action="#request.self#?fuseaction=#attributes.fuseaction##url_string#" method="post" name="search" id="search">
		<cfinput type="hidden" name="is_form_submitted" value="1">
		<cf_box_search more="0">
			<!--- <cfinput name="field_branch_id" type="hidden" value="#attributes.field_branch_id#">
			<cfinput name="field_branch_name" type="hidden" value="#attributes.field_branch_name#">--->
			<!-- sil -->
				<div class="form-group" id="keyword">
					<cfinput type="text"  tabindex="1" name="keyword" id="keyword" placeholder="#getLang('','Filtre',57460)#" value="#attributes.keyword#" maxlength="50">
				</div>
				<div class="form-group small">
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,999" message="#getLang('','Kayıt Sayısı Hatalı',57537)#" maxlength="3">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4" search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('search' , #attributes.modal_id#)"),DE(""))#" >    
				</div>
			<!-- sil -->
		</cf_box_search>
	</cfform>
	<cf_flat_list>
		<thead>
			<tr>
				<th><cf_get_lang dictionary_id='57992.Bölge'></th>
				<th><cf_get_lang dictionary_id='57574.Şirket'></th>
				<th><cf_get_lang dictionary_id='57453.Şube'></th>
			</tr>
		</thead>
		<tbody>
			<cfif get_branches.recordcount>
			<cfoutput query="get_branches" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
				<tr>
					<td>#zone_name#</td>
					<td>#nick_name#</td>
					<td>
						<cfif not isdefined("attributes.coklu_secim")>
							<a href="javascript://" onClick="gonder('#branch_id#','#branch_name#');" class="tableyazi">#branch_name#</a>
						<cfelse>
							<a href="javascript://" onClick="gonder('#branch_id#','#branch_name#');" class="tableyazi">#branch_name#</a>
						</cfif>				
					</td>
				</tr>
			</cfoutput>
			<cfelse>
			<tr>
				<td colspan="4"><cfif isdefined("attributes.is_form_submitted")><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'></cfif></td>
			</tr>
			</cfif>
		</tbody>
	</cf_flat_list>
	<cfif attributes.maxrows lt attributes.totalrecords>
		<cfif isDefined("attributes.draggable") and len(attributes.draggable)>
			<cfset url_string = '#url_string#&draggable=#attributes.draggable#'>
		<cfelse>
			<cfset url_string = "#url_string#&is_form_submitted=1">
		</cfif>
		<cf_paging 
			page="#attributes.page#" 
			maxrows="#attributes.maxrows#" 
			totalrecords="#attributes.totalrecords#" 
			startrow="#attributes.startrow#" 
			adres="objects.popup_list_branches#url_string#"
			isAjax="#iif(isdefined("attributes.draggable"),1,0)#">
	</cfif>
</cf_box>
<script type="text/javascript">
	$(document).ready(function(){
		$( "#keyword" ).focus();
	});
</script>
