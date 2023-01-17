 <cfif isdefined("attributes.is_form_submitted")>
	<cfset form_varmi = 1>
<cfelse>
	<cfset form_varmi = 0>
</cfif>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.page" default=1>
<cfinclude template="../query/get_assign_targets.cfm">
<cfparam name="attributes.totalrecords" default=#get_assign_targets.recordcount#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfset url_str = "">
<cfif isdefined("attributes.keyword")>
<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
</cfif>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box>
		<cfform action="#request.self#?fuseaction=myhome.my_assign_targets" method="post" name="search">
			<cf_box_search more="0">
				<cfinput type="hidden" name="is_form_submitted" value="1">
				<div class="form-group" id="item-keyword">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57460.Filtre'></cfsavecontent>
					<cfinput type="text" name="keyword" id="keyword" placeholder="#message#" maxlength="50" value="#attributes.keyword#">
				</div>		
				<cfinclude template="../query/get_departments.cfm">
				<div class="form-group small">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='31858.Lütfen En Fazla Kayıt Sayısını Giriniz'></cfsavecontent>
					<cfinput name="maxrows" type="Text" value="#attributes.maxrows#" maxlength="3" range="1," required="yes" onKeyUp="isNumber(this)" message="#message#" style="width:25px;">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4">
					<cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'>
				</div>
			</cf_box_search>
		</cfform>
	</cf_box>
	<cfsavecontent variable="message"><cf_get_lang dictionary_id='31147.Verdiğim Hedefler'></cfsavecontent>
	<cf_box title="#message#" uidrop="1" hide_table_column="1" add_href="?fuseaction=objects.popup_form_add_target&fbx=myhome">
		<cf_flat_list>
			<thead>
				<tr>
					<th width="30"><cf_get_lang dictionary_id='58577.Sıra'></th>
					<th width="30"><cf_get_lang dictionary_id='57487.No'></th>
					<th><cf_get_lang dictionary_id='57486.Kategori'></th>
					<th><cf_get_lang dictionary_id='57951.Hedef'></th>
					<th><cf_get_lang dictionary_id='30968.Rakam'></th>
					<th><cf_get_lang dictionary_id='31151.Hesaplama Tekniği'></th>
					<th><cf_get_lang dictionary_id='57570.Ad Soyad'></th>
					<th><cf_get_lang dictionary_id='57501.Başlangıç'></th>
					<th><cf_get_lang dictionary_id='57502.Bitiş'></th>
					<th class="header_icn_none"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></th>
					<!--- <th class="header_icn_none"> <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_form_add_target&fbx=myhome','medium');"><img src="images/plus_list.gif" title="<cf_get_lang_main no='170.Ekle'>"></a></th><!-- sil -->--->
				</tr> 
			</thead>
			<tbody>
				<cfif get_assign_targets.recordcount and form_varmi eq 1>				
					<cfset target_emp_list=''>
					<cfoutput query="get_assign_targets" maxrows="#attributes.maxrows#" startrow="#attributes.startrow#">
						<cfif len(position_code) and not listfind(target_emp_list,position_code)>
						<cfset target_emp_list=listappend(target_emp_list,position_code)>
						</cfif>
					</cfoutput>
					<cfif len(target_emp_list)>
					<cfset target_emp_list=listsort(target_emp_list,"numeric","ASC",",")>
						<cfquery name="get_target_emp" datasource="#dsn#">
							SELECT
								EMPLOYEE_NAME,
								EMPLOYEE_SURNAME
							FROM
								EMPLOYEE_POSITIONS
							WHERE
								POSITION_CODE IN (#target_emp_list#)
							ORDER BY
								POSITION_CODE
						</cfquery>
					</cfif>
					<cfoutput query="get_assign_targets" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<tr>
							<cfif fusebox.circuit eq 'myhome'>
								<cfset target_id_ = contentEncryptingandDecodingAES(isEncode:1,content:get_assign_targets.target_id,accountKey:session.ep.userid)>
								<cfset position_code_ = contentEncryptingandDecodingAES(isEncode:1,content:SESSION.EP.POSITION_CODE,accountKey:session.ep.userid)>
								<cfif len(get_assign_targets.position_code)>
									<cfset upd_position_code_ = contentEncryptingandDecodingAES(isEncode:1,content:get_assign_targets.position_code,accountKey:session.ep.userid)>
								</cfif>
							<cfelse>
								<cfset target_id_ = get_assign_targets.target_id>
								<cfset position_code_ = SESSION.EP.POSITION_CODE>
								<cfif len(get_assign_targets.position_code)>
									<cfset upd_position_code_ = get_assign_targets.position_code>
								</cfif>
							</cfif>
							<td width="35">#currentrow#</td>
							<td>#get_assign_targets.target_id#</td>
							<td><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=myhome.popup_dsp_my_target&target_id=#target_id_#&position_code=#position_code_#','small');" class="tableyazi">#TARGETCAT_NAME#</a></td>
							<td>#get_assign_targets.TARGET_HEAD#</td>
							<td  style="text-align:right;">#TLFormat(target_number)#</td>
							<td><cfif get_assign_targets.CALCULATION_TYPE eq 1>+ (<cf_get_lang dictionary_id='31142.Artış Hedefi'>)
									<cfelseif get_assign_targets.CALCULATION_TYPE eq 2>- (<cf_get_lang dictionary_id='31143.Düşüş Hedefi'>)
									<cfelseif get_assign_targets.CALCULATION_TYPE eq 3>+ % (<cf_get_lang dictionary_id='31144.Yüzde Artış Hedefi'>)
									<cfelseif get_assign_targets.CALCULATION_TYPE eq 4>- % (<cf_get_lang dictionary_id='31145.Yüzde Düşüş Hedefi'>)
									<cfelseif get_assign_targets.CALCULATION_TYPE eq 5>= (<cf_get_lang dictionary_id='31146.Hedeflenen Rakam'>)
								</cfif>
							</td>
							<td>
								<cfif len(emp_id) and  len(target_emp_list)>
									<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#emp_id#','medium');" class="tableyazi">#get_target_emp.EMPLOYEE_NAME[listfind(target_emp_list,position_code,',')]#&nbsp; #get_target_emp.EMPLOYEE_SURNAME[listfind(target_emp_list,position_code,',')]#</a>
								</cfif>
							</td>
							<td>#dateformat(startdate,dateformat_style)#</td>
							<td>#dateformat(finishdate,dateformat_style)#</td>
							<!-- sil --><td><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_form_add_target&event=upd&fbx=myhome&target_id=#target_id_#&position_code=<cfif len(get_assign_targets.position_code)>#upd_position_code_#</cfif>','medium');"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></td><!-- sil -->
						</tr>
					</cfoutput>
					<cfelse>
						<tr>
							<td colspan="10"><cfif isdefined("attributes.is_form_submitted")><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'>!</cfif></td>
						</tr>
					</cfif>
			</tbody>
		</cf_flat_list>
		<cfif isdefined("attributes.is_form_submitted") and len(attributes.is_form_submitted)>
			<cfset url_str = '#url_str#&is_form_submitted=#attributes.is_form_submitted#'>
		</cfif>
		<cf_paging
			page="#attributes.page#"
			maxrows="#attributes.maxrows#"
			totalrecords="#attributes.totalrecords#"
			startrow="#attributes.startrow#"
			adres="myhome.my_assign_targets#url_str#">
	</cf_box>
</div>
<script type="text/javascript">
	document.getElementById('keyword').focus();
</script>