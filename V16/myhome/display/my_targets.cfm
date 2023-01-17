<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.page" default=1>
<cfif isdefined('attributes.is_submit')>
	<cfinclude template="../query/get_targets.cfm">
<cfelse>
	<cfset get_targets.recordcount = 0>
</cfif>
<cfparam name="attributes.totalrecords" default=#get_targets.recordcount#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
    <cfset url_str = "">
    <cfif isdefined("attributes.keyword")>
      <cfset url_str = "#url_str#&keyword=#attributes.keyword#">
    </cfif> 
<cfform action="#request.self#?fuseaction=myhome.my_targets" method="post" name="search">
<input type="hidden" name="is_submit" id="is_submit" value="1">
<!--- <cf_big_list_search_area>
	<div class="row"> 
		<div class="col col-12 form-inline">
			<div class="form-group">
				<cfinput type="text" name="keyword" maxlength="50" value="#attributes.keyword#" placeholder="#getLang('main',48)#">
			</div>
			<div class="form-group x-3_5">
				<cfinclude template="../query/get_departments.cfm">
				<cfsavecontent variable="message1"><cf_get_lang no ='1100.Lütfen En Fazla Kayıt Sayısını Giriniz'></cfsavecontent>
				<cfinput name="maxrows" type="Text" value="#attributes.maxrows#"  range="1," maxlength="3" required="yes" onKeyUp="isNumber(this)" message="#message1#" style="width:25px;">
			</div>
			<div class="form-group">
				<cf_wrk_search_button><cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'>
			</div>
		</div>
	</div>
</cf_big_list_search_area> --->
</cfform>

<cfsavecontent variable="message"><cf_get_lang dictionary_id='57964.Hedefler'></cfsavecontent>
<cf_box title="#message#" closable="0">
	<cf_ajax_list>
		<div class="extra_list">
			<thead>
				<tr>
					<th><cf_get_lang dictionary_id='58577.Sıra'></th>
					<th><cf_get_lang dictionary_id='57487.No'></th>
					<th><cf_get_lang dictionary_id='57501.Başlangıç'> - <cf_get_lang dictionary_id='57700.Bitiş Tarihi'></th>
					<th><cf_get_lang dictionary_id='57951.Hedef'></th>
					<th><cf_get_lang dictionary_id='30968.Rakam'></th>				
					<th><cf_get_lang dictionary_id='31152.Hedef Veren'></th>
				</tr>	
			</thead>
			<tbody>
				<cfif get_targets.recordcount>				
					<cfset target_emp_list=''>
					<cfoutput query="get_targets" maxrows="#attributes.maxrows#" startrow="#attributes.startrow#">
						<cfif len(target_emp) and not listfind(target_emp_list,target_emp)>
						<cfset target_emp_list=listappend(target_emp_list,target_emp)>
						</cfif>
					</cfoutput>
						<cfif len(target_emp_list)>
						<cfset target_emp_list=listsort(target_emp_list,"numeric","ASC",",")>
						<cfquery name="get_target_emp" datasource="#dsn#">
							SELECT
								EMPLOYEE_NAME,
								EMPLOYEE_SURNAME
							FROM
								EMPLOYEES
							WHERE
								EMPLOYEE_ID IN (#target_emp_list#)
							ORDER BY
								EMPLOYEE_ID
						</cfquery>
				</cfif>
				<cfoutput query="get_targets" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
					<tr>
						<cfif fusebox.circuit eq 'myhome'><!---20131112--->
							<cfset target_id_ = contentEncryptingandDecodingAES(isEncode:1,content:target_id,accountKey:session.ep.userid)>
							<cfset position_code_ = contentEncryptingandDecodingAES(isEncode:1,content:session.ep.position_code,accountKey:session.ep.userid)>
						<cfelse>
							<cfset target_id_ = target_id>
							<cfset position_code_ = session.ep.position_code>
						</cfif>
						<td>#currentrow#</td>
						<td>#get_targets.target_id#</td>
						<td>#dateformat(startdate,dateformat_style)# - #dateformat(finishdate,dateformat_style)#</td>
						<td>
							<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=myhome.popup_dsp_my_target&target_id=#target_id_#&position_code=#position_code_#','small');" class="tableyazi">#TARGETCAT_NAME#</a><br />
							#get_targets.TARGET_HEAD#
						</td>
						<td>
							#TLFormat(target_number)#
							<cfif get_targets.CALCULATION_TYPE eq 1>+ (<cf_get_lang dictionary_id='31142.Artış Hedefi'>)
							<cfelseif get_targets.CALCULATION_TYPE eq 2>- (<cf_get_lang dictionary_id='31143.Düşüş Hedefi'>)
							<cfelseif get_targets.CALCULATION_TYPE eq 3>+ % (<cf_get_lang dictionary_id='31144.Yüzde Artış Hedefi'>)
							<cfelseif get_targets.CALCULATION_TYPE eq 4>- % (<cf_get_lang dictionary_id='31145.Yüzde Düşüş Hedefi'>)
							<cfelseif get_targets.CALCULATION_TYPE eq 5>= (<cf_get_lang dictionary_id='31146.Hedeflenen Rakam'>)
							</cfif>
						</td>
						<td>
							<cfif len(target_emp)>
								<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#target_emp#','medium');" class="tableyazi">#get_target_emp.EMPLOYEE_NAME[listfind(target_emp_list,TARGET_EMP,',')]#&nbsp; #get_target_emp.EMPLOYEE_SURNAME[listfind(target_emp_list,TARGET_EMP,',')]#</a>
							</cfif>
						</td>
						
					</tr>
				</cfoutput>
				<cfelse>
					<tr>
						<td colspan="9"><cfif isdefined('attributes.is_submit')><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'><cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'></cfif>!</td>
					</tr>
				</cfif>
			</tbody>
		</div>
	</cf_ajax_list>
</cf_box>

<cfinclude  template="../display/list_my_prizes.cfm">
<cfinclude  template="../display/list_my_caution.cfm">
<cfinclude  template="../display/list_my_quotas.cfm">

<cfif isdefined("attributes.is_submit") and len(attributes.is_submit)>
	<cfset url_str = '#url_str#&is_submit=#attributes.is_submit#'>
</cfif>
<cf_paging
	page="#attributes.page#"
    maxrows="#attributes.maxrows#"
    totalrecords="#attributes.totalrecords#"
    startrow="#attributes.startrow#"
    adres="myhome.my_targets#url_str#">
<script type="text/javascript">
	document.getElementById('keyword').focus();
</script>