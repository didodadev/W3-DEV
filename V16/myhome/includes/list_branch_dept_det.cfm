<cfsetting showdebugoutput="no">
<cfparam name="attributes.dept_selection" default="1">
<cfif month(now()) neq 1>
	<cfparam name="attributes.sal_mon" default="#month(now())-1#">
<cfelse>
	<cfparam name="attributes.sal_mon" default="12">
</cfif>
<div id="div_branch_dept_det">
<cfform name="branch_dept_det" method="post" action="">
<input type="hidden" name="comp_id" id="comp_id" value="<cfoutput>#attributes.comp_id#</cfoutput>">
<input type="hidden" name="branch_id" id="branch_id" value="<cfoutput>#attributes.branch_id#</cfoutput>">
<cfquery name="get_depts" datasource="#DSN#">
	SELECT
		D.DEPARTMENT_ID,
		D.DEPARTMENT_HEAD,
		B.BRANCH_ID
	FROM
		DEPARTMENT D,
		BRANCH B
	WHERE
		D.DEPARTMENT_STATUS = 1
		AND D.BRANCH_ID = B.BRANCH_ID
		AND B.BRANCH_ID = #attributes.branch_id#
</cfquery>	
<table width="100%" cellpadding="2" cellspacing="1" border="0" class="color-row">
	<tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
		<td class="txtbold" style="text-align:right" colspan="7">
			 <select name="sal_mon" id="sal_mon" onChange="change_det4_(document.branch_dept_det.dept_selection.value,this.value);">
				<cfloop from="1" to="12" index="i">
					<cfoutput>
						<option value="#i#" <cfif attributes.sal_mon eq i>selected</cfif>>#listgetat(ay_list(),i,',')#</option>
					</cfoutput>
				</cfloop>
			</select>
			<select name="dept_selection" id="dept_selection" onChange="change_det4_(this.value,document.branch_dept_det.sal_mon.value);">
				<option value="1" <cfif attributes.dept_selection eq 1>selected</cfif>><cf_get_lang_main no='846.Maliyet'></option>
				<option value="2" <cfif attributes.dept_selection eq 2>selected</cfif>><cf_get_lang no='109.Mesai'></option>
				<option value="3" <cfif attributes.dept_selection eq 3>selected</cfif> ><cf_get_lang no='114.Toplam Kazanç'></option>
				<option value="4" <cfif attributes.dept_selection eq 4>selected</cfif>><cf_get_lang no='115.Devir Hızı'></option> 
			</select> 
			<a href="javascript://" onClick="back4_();"><img src="/images/ac_c.gif" border="0"></a>
		</td>
	</tr>
	<tr id="dept_selection_1" height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row" <cfif attributes.dept_selection neq 1>style="display:none;"</cfif>>
		<td>&nbsp;</td>
		<td class="txtbold" style="text-align:center"><cf_get_lang no='124.Çalışan Sayısı'></td>
		<td class="txtbold" style="text-align:center;width:200px" nowrap><cf_get_lang no='131.İşveren Maliyeti'><br/><cf_get_lang no='130.İndirimsiz'></td>
		<td class="txtbold" style="text-align:center"><cf_get_lang no='131.İşveren Maliyeti'></td>
		<td class="txtbold" style="text-align:center"><cf_get_lang no='132.Ortalama Maliyet'></td>
	</tr>
	<tr id="dept_selection_2" height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row" <cfif attributes.dept_selection neq 2>style="display:none;"</cfif>>
		<td>&nbsp;</td>
		<td class="txtbold" style="text-align:center"><cf_get_lang no='124.Çalışan Sayısı'></td>
		<td class="txtbold" style="text-align:center" nowrap><cf_get_lang_main no='80.Toplam'><cf_get_lang no='140.Mesai Saati'></td>
		<td class="txtbold" style="text-align:center"><cf_get_lang_main no='80.Toplam'><cf_get_lang no='147.Mesai Tutarı'></td>
		<td class="txtbold" style="text-align:center"><cf_get_lang no='148.Ortalama'><cf_get_lang no='147.Mesai Tutarı'></td>
	</tr>
	<tr id="dept_selection_3" height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row" <cfif attributes.dept_selection neq 3>style="display:none;"</cfif>>
		<td>&nbsp;</td>
		<td class="txtbold" style="text-align:center"><cf_get_lang no='124.Çalışan Sayısı'></td>
		<td class="txtbold" style="text-align:center" nowrap><cf_get_lang no='114.Toplam Kazanç'></td>
		<td class="txtbold" style="text-align:center"><cf_get_lang no='114.Toplam Kazanç'> <cf_get_lang no='155.Artış Oranı'></td>
		<td class="txtbold" style="text-align:center"><cf_get_lang no='148.Ortalama'><cf_get_lang no='160.Kazanç'></td>
	</tr>
	<tr id="dept_selection_4" height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row" <cfif attributes.dept_selection neq 4>style="display:none;"</cfif>>
		<th width="20%">&nbsp;</th>
		<th style="text-align:center;width:200px;" valign="top" class="txtbold"><cf_get_lang no='124.Çalışan Sayısı'></th>
		<th style="text-align:center;width:200px;" valign="top" class="txtbold"><cf_get_lang_main no='142.Giriş'> <cf_get_lang_main no='80.Toplam'></th>
		<th style="text-align:center;width:200px;" valign="top" class="txtbold"><cf_get_lang_main no='19.Çıkış'> <cf_get_lang_main no='80.Toplam'></th>
		<th style="text-align:center;width:200px;" valign="top" class="txtbold"><cf_get_lang no='115.Devir Hızı'></th>
		<th style="text-align:center;width:200px;" valign="top" class="txtbold"><cf_get_lang_main no='142.Giriş'><cf_get_lang_main no='19.Çıkış'><cf_get_lang_main no='1259.Oranı'></th>
		<th style="text-align:center;width:200px;" valign="top" class="txtbold"><cf_get_lang no='170.İstikrar Endeksi'></th>
	</tr> 
	<cfif get_depts.recordcount>
		<cfoutput query="get_depts">
			<cfinclude template="../query/get_branch_profile_dept_det.cfm">  
			<cfif get_branch_profile_det.recordcount eq 0>
				<cfset emp_amount = 1>
			<cfelse>
				<cfset emp_amount = get_branch_profile_det.recordcount>
			</cfif>
				
			<tr class="color-row" id="dept_selection_1_" <cfif attributes.dept_selection neq 1>style="display:none;"</cfif>>
				<td class="txtbold">#get_depts.DEPARTMENT_HEAD#</td>
				<td style="text-align:center">#get_branch_profile_det.recordcount#</td>
				<td style="text-align:center">#TLFormat(t_toplam_kazanc+t_ext_salary+t_issizlik_isveren_hissesi+t_ssk_primi_isveren_hesaplanan+t_ssdf_isveren_hissesi+genel_odenek_total+(t_ssk_primi_isci-t_ssk_primi_isci_devirsiz)+(t_issizlik_isci_hissesi-t_issizlik_isci_hissesi_devirsiz)+t_sgdp_devir)#</td>
				<td style="text-align:center">#TLFormat(t_toplam_kazanc + t_ext_salary + t_issizlik_isveren_hissesi + t_ssk_primi_isveren + t_ssdf_isveren_hissesi + genel_odenek_total - t_ssk_primi_isveren_gov - t_ssk_primi_isveren_5921 - t_ssk_primi_isveren_5746 - t_ssk_primi_isveren_6111 + (t_ssk_primi_isci - t_ssk_primi_isci_devirsiz) + (t_issizlik_isci_hissesi - t_issizlik_isci_hissesi_devirsiz) + t_sgdp_devir)#</td>
				<td style="text-align:center">#TLFormat((t_toplam_kazanc + t_ext_salary + t_issizlik_isveren_hissesi + t_ssk_primi_isveren + t_ssdf_isveren_hissesi + genel_odenek_total - t_ssk_primi_isveren_gov - t_ssk_primi_isveren_5921 - t_ssk_primi_isveren_5746 - t_ssk_primi_isveren_6111 + (t_ssk_primi_isci - t_ssk_primi_isci_devirsiz) + (t_issizlik_isci_hissesi - t_issizlik_isci_hissesi_devirsiz) + t_sgdp_devir)/emp_amount)#</td>
			</tr>
			<tr class="color-row" id="dept_selection_2_" <cfif attributes.dept_selection neq 2>style="display:none;"</cfif>>
				<td class="txtbold">#get_depts.DEPARTMENT_HEAD#</td>
				<td style="text-align:center">#get_branch_profile_det.recordcount#</td>
				<td style="text-align:center">#t_ext_work_hours_0 + t_ext_work_hours_1 + t_ext_work_hours_2#</td>
				<td style="text-align:center">#TLFormat(t_ext_Salary)#</td>
				<td style="text-align:center">#TLFormat(t_ext_Salary/emp_amount)#</td>
			</tr>
			<tr class="color-row" id="dept_selection_3_" <cfif attributes.dept_selection neq 3>style="display:none;"</cfif>>
				<td class="txtbold">#get_depts.DEPARTMENT_HEAD#</td>
				<td style="text-align:center">#get_branch_profile_det.recordcount#</td>
				<td style="text-align:center">#TLFormat(t_toplam_kazanc+genel_odenek_total+t_ext_Salary)#</td>
				<td style="text-align:center">
					<cfif get_branch_profile_det2_.recordcount>
						 <cfif t_toplam_kazanc2+genel_odenek_total2+t_ext_Salary2 eq 0>
							#TLFormat(((t_toplam_kazanc+genel_odenek_total+t_ext_Salary)/(1)-1)*100)#
						<cfelse>
							#TLFormat(((t_toplam_kazanc+genel_odenek_total+t_ext_Salary)/(t_toplam_kazanc2+genel_odenek_total2+t_ext_Salary2)-1)*100)#
						</cfif>
					<cfelse>
						#TLFormat(0)#
					</cfif></td>
				<td style="text-align:center">#TLFormat((t_toplam_kazanc+genel_odenek_total+t_ext_Salary)/emp_amount)#</td>
			</tr>
			<tr class="color-row" id="dept_selection_4_" <cfif attributes.dept_selection neq 4>style="display:none;"</cfif>>
				<cfset total_emp_number_ = (get_branch_profile_det.recordcount-get_emp_out_total_) + (emp_number_previous_month-get_emp_out_total_previous_month)>
				<td width="20%" class="txtbold">#get_depts.DEPARTMENT_HEAD#</td>
				<td style="text-align:center">#get_branch_profile_det.recordcount#</td>
				<td style="text-align:center">#get_emp_in_total_#</td>
				<td style="text-align:center">#get_emp_out_total_#</td>
				<td style="text-align:center"><cfif total_emp_number_ neq 0>#TLFormat(get_emp_out_total_/(total_emp_number_/2)*100)#<cfelse>#TLFormat(get_emp_out_total_*100)#</cfif></td>
				<td style="text-align:center">
					<cfif get_emp_in_total_ eq 0>
						#TLFormat(get_emp_out_total_*100)#
					<cfelse>
						#TLFormat(get_emp_out_total_/get_emp_in_total_*100)#
					</cfif>
				</td>
				<td style="text-align:center">
					<cfif get_emp_in_the_past_ eq 0>
						#TLFormat(get_emp_in_the_past*100)#
					<cfelse>
						#TLFormat(get_emp_in_the_past/get_emp_in_the_past_*100)#
					</cfif>
				</td>
			</tr>
		</cfoutput>
	</cfif>
</table>
</cfform>
</div>
<script language="javascript">
	function change_det4_(dept_selection,sal_mon)
	{
		if(document.getElementById("dept_selection").value = 1)
		{
			document.getElementById("dept_selection_1").style.display = '';
		}
		else
		{	
			document.getElementById("dept_selection_1").style.display = none;
		}
		if(document.getElementById("dept_selection").value = 2)
		{
			document.getElementById("dept_selection_2").style.display = '';
		}
		else
		{	
			document.getElementById("dept_selection_2").style.display = none;
		}
		if(document.getElementById("dept_selection").value = 3)
		{
			document.getElementById("dept_selection_3").style.display = '';
		}
		else
		{	
			document.getElementById("dept_selection_3").style.display = none;
		}
		AjaxPageLoad('<cfoutput>#request.self#?fuseaction=myhome.emptypopup_list_branch_dept_det&dept_selection='+dept_selection+'&sal_mon='+sal_mon+'&comp_id='+document.branch_dept_det.comp_id.value+'&branch_id='+document.branch_dept_det.branch_id.value+'</cfoutput>','div_branch_dept_det',1);
		return true;

	}
	function back4_()
	{	
		AjaxPageLoad('<cfoutput>#request.self#?fuseaction=myhome.emptypopup_list_branch_det&comp_id='+document.branch_dept_det.comp_id.value+'&branch_id='+document.branch_dept_det.branch_id.value+'&branch_selection='+document.branch_dept_det.dept_selection.value+'&sal_mon='+document.branch_dept_det.sal_mon.value+'</cfoutput>','div_branch_det',1);
		return false;
	}
</script>
