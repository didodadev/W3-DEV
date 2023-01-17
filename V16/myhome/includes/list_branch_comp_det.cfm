<cfsetting showdebugoutput="no">
<cfparam name="attributes.comp_selection" default="#attributes.comp_selection#">
<cfif month(now()) neq 1>
	<cfparam name="attributes.sal_mon" default="#month(now())-1#">
<cfelse>
	<cfparam name="attributes.sal_mon" default="12">
</cfif>

<cfquery name="get_comp" datasource="#dsn#">
	SELECT COMP_ID,NICK_NAME FROM OUR_COMPANY ORDER BY NICK_NAME
</cfquery>
<div id="div_branch_comp_det">
<cfform name="branch_comp_det" method="post" action="">
<table width="100%" cellpadding="2" cellspacing="1" border="0" class="color-row">
	<tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
		<td colspan="2">&nbsp;</td>
		<td class="txtbold" style="text-align:right" colspan="7">
			 <select name="sal_mon" id="sal_mon" onChange="change_det_(document.branch_comp_det.comp_selection.value,this.value);">
				<cfloop from="1" to="12" index="i">
					<cfoutput>
						<option value="#i#" <cfif attributes.sal_mon eq i>selected</cfif>>#listgetat(ay_list(),i,',')#</option>
					</cfoutput>
				</cfloop>
			</select>
			<select name="comp_selection" id="comp_selection" onChange="change_det_(this.value,document.branch_comp_det.sal_mon.value);">
				<option value="1" <cfif attributes.comp_selection eq 1>selected</cfif>><cf_get_lang_main no='846.Maliyet'></option>
				<option value="2" <cfif attributes.comp_selection eq 2>selected</cfif>><cf_get_lang no='109.Mesai'></option>
				<option value="3" <cfif attributes.comp_selection eq 3>selected</cfif>><cf_get_lang no='114.Toplam Kazanç'></option>
				<option value="4" <cfif attributes.comp_selection eq 4>selected</cfif>><cf_get_lang no='115.Devir Hızı'></option> 
			</select> 
			<a href="javascript://" onClick="back2_();"><img src="/images/ac_c.gif" border="0"></a>
		</td>
	</tr>
	<tr id="comp_selection_1" height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row" <cfif attributes.comp_selection neq 1>style="display:none;"</cfif>>
		<td>&nbsp;</td>
		<td class="txtbold" style="text-align:center" width="15%" valign="top"><cf_get_lang no='124.Çalışan Sayısı'></td>
		<td class="txtbold" style="text-align:center" nowrap width="15%"><cf_get_lang no='131.İşveren Maliyeti'><br/><cf_get_lang no='130.İndirimsiz'></td>
		<td class="txtbold" style="text-align:center" width="15%" valign="top"><cf_get_lang no='131.İşveren Maliyeti'></td>
		<td class="txtbold" style="text-align:center" width="15%" valign="top"><cf_get_lang no='132.Ortalama Maliyet'></td>
	</tr>
	<tr id="comp_selection_2" height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row" <cfif attributes.comp_selection neq 2>style="display:none;"</cfif>>
		<td>&nbsp;</td>
		<td class="txtbold" style="text-align:center;width:200px;" valign="top"><cf_get_lang no='124.Çalışan Sayısı'></td>
		<td class="txtbold" style="text-align:center;width:200px;" valign="top"><cf_get_lang_main no='80.Toplam'><cf_get_lang no='140.Mesai Saati'></td>
		<td class="txtbold" style="text-align:center;width:200px;" valign="top"><cf_get_lang_main no='80.Toplam'><cf_get_lang no='147.Mesai Tutarı'></td>
		<td class="txtbold" style="text-align:center;width:200px;" valign="top"><cf_get_lang no='148.Ortalama'><cf_get_lang no='147.Mesai Tutarı'></td>
	</tr>
	<tr id="comp_selection_3" height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row" <cfif attributes.comp_selection neq 3>style="display:none;"</cfif>>
		<td>&nbsp;</td>
		<td class="txtbold" style="text-align:center" width="15%"><cf_get_lang no='124.Çalışan Sayısı'></td>
		<td class="txtbold" style="text-align:center" nowrap width="15%"><cf_get_lang no='114.Toplam Kazanç'></td>
		<td class="txtbold" style="text-align:center" width="25%"><cf_get_lang no='114.Toplam Kazanç'> <cf_get_lang no='155.Artış Oranı'></td>
		<td class="txtbold" style="text-align:center" width="15%"><cf_get_lang no='148.Ortalama'><cf_get_lang no='160.Kazanç'></td>
	</tr>
	<tr id="comp_selection_4" height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row" <cfif attributes.comp_selection neq 4>style="display:none;"</cfif>>
		<th width="20%">&nbsp;</th>
		<th style="text-align:center;width:200px;" valign="top" class="txtbold"><cf_get_lang no='124.Çalışan Sayısı'></th>
		<th style="text-align:center;width:200px;" valign="top" class="txtbold"><cf_get_lang_main no='142.Giriş'> <cf_get_lang_main no='80.Toplam'></th>
		<th style="text-align:center;width:200px;" valign="top" class="txtbold"><cf_get_lang_main no='19.Çıkış'> <cf_get_lang_main no='80.Toplam'></th>
		<th style="text-align:center;width:200px;" valign="top" class="txtbold"><cf_get_lang no='115.Devir Hızı'></th>
		<th style="text-align:center;width:200px;" valign="top" class="txtbold"><cf_get_lang_main no='142.Giriş'><cf_get_lang_main no='19.Çıkış'><cf_get_lang_main no='1259.Oranı'></th>
		<th style="text-align:center;width:200px;" valign="top" class="txtbold"><cf_get_lang no='170.İstikrar Endeksi'></th>
	</tr> 
	<cfif get_comp.recordcount>
		<cfoutput query="get_comp">
			<cfinclude template="../query/get_branch_profile_comp_det.cfm">
			<cfif get_branch_profile_det.recordcount eq 0>
				<cfset emp_amount = 1>
			<cfelse>
				<cfset emp_amount = get_branch_profile_det.recordcount>
			</cfif>
			<tr class="color-row" id="comp_selection_1_" <cfif attributes.comp_selection neq 1>style="display:none;"</cfif>>
				<td class="txtbold" nowrap="nowrap"><a href="javascript://" OnClick="load_branch_('#comp_id#');">#get_comp.nick_name#</a></td>
				<td style="text-align:center">#get_branch_profile_det.recordcount#</td>
				<td style="text-align:center">#TLFormat(t_toplam_kazanc+t_ext_salary+t_issizlik_isveren_hissesi+t_ssk_primi_isveren_hesaplanan+t_ssdf_isveren_hissesi+genel_odenek_total+(t_ssk_primi_isci-t_ssk_primi_isci_devirsiz)+(t_issizlik_isci_hissesi-t_issizlik_isci_hissesi_devirsiz)+t_sgdp_devir)#</td>
				<td style="text-align:center">#TLFormat(t_toplam_kazanc + t_ext_salary + t_issizlik_isveren_hissesi + t_ssk_primi_isveren + t_ssdf_isveren_hissesi + genel_odenek_total - t_ssk_primi_isveren_gov - t_ssk_primi_isveren_5921 - t_ssk_primi_isveren_5746 - t_ssk_primi_isveren_6111 + (t_ssk_primi_isci - t_ssk_primi_isci_devirsiz) + (t_issizlik_isci_hissesi - t_issizlik_isci_hissesi_devirsiz) + t_sgdp_devir)#</td>
				<td style="text-align:center">#TLFormat((t_toplam_kazanc + t_ext_salary + t_issizlik_isveren_hissesi + t_ssk_primi_isveren + t_ssdf_isveren_hissesi + genel_odenek_total - t_ssk_primi_isveren_gov - t_ssk_primi_isveren_5921 - t_ssk_primi_isveren_5746 - t_ssk_primi_isveren_6111 + (t_ssk_primi_isci - t_ssk_primi_isci_devirsiz) + (t_issizlik_isci_hissesi - t_issizlik_isci_hissesi_devirsiz) + t_sgdp_devir)/emp_amount)#</td>
			</tr>
			<tr class="color-row" id="comp_selection_2_" <cfif attributes.comp_selection neq 2>style="display:none;"</cfif>>
				<td class="txtbold" nowrap="nowrap"><a href="javascript://" OnClick="load_branch_('#comp_id#');">#get_comp.nick_name#</a></td>
				<td style="text-align:center">#get_branch_profile_det.recordcount#</td>
				<td style="text-align:center">#t_ext_work_hours_0 + t_ext_work_hours_1 + t_ext_work_hours_2#</td>
				<td style="text-align:center">#TLFormat(t_ext_Salary)#</td>
				<td style="text-align:center">#TLFormat(t_ext_Salary/emp_amount)#</td>
			</tr>
			<tr class="color-row" id="comp_selection_3_" <cfif attributes.comp_selection neq 3>style="display:none;"</cfif>>
				<td class="txtbold" nowrap="nowrap"><a href="javascript://" OnClick="load_branch_('#comp_id#');">#get_comp.nick_name#</a></td>
				<td style="text-align:center">#get_branch_profile_det.recordcount#</td>
				<td style="text-align:center">#TLFormat(t_toplam_kazanc+genel_odenek_total+t_ext_Salary)#</td>
				<td style="text-align:center"><cfif get_branch_profile_det2_.recordcount>#TLFormat(((t_toplam_kazanc+genel_odenek_total+t_ext_Salary)/(t_toplam_kazanc2+genel_odenek_total2+t_ext_Salary2)-1)*100)#<cfelse>#TLFormat(0)#</cfif></td>
				<td style="text-align:center">#TLFormat((t_toplam_kazanc+genel_odenek_total+t_ext_Salary)/emp_amount)#</td>
			</tr>
			<tr class="color-row" id="comp_selection_4_" <cfif attributes.comp_selection neq 4>style="display:none;"</cfif>>
				<cfset total_emp_number_ = (get_branch_profile_det.recordcount-get_emp_out_total_) + (emp_number_previous_month-get_emp_out_total_previous_month)>
				<td width="20%" class="txtbold" nowrap="nowrap"><a href="javascript://" OnClick="load_branch_('#comp_id#');">#get_comp.nick_name#</a></td>
				<td style="text-align:center">#get_branch_profile_det.recordcount#</td>
				<td style="text-align:center">#get_emp_in_total_#</td>
				<td style="text-align:center">#get_emp_out_total_#</td>
				<td style="text-align:center">#get_emp_out_total_previous_month#<cfif total_emp_number_ neq 0>#TLFormat(get_emp_out_total_/(total_emp_number_/2)*100)#<cfelse>#TLFormat(get_emp_out_total_*100)#</cfif></td>
				<td style="text-align:center">
					<cfif get_emp_in_total_ eq 0>
						#TLFormat(get_emp_out_total_*100)#
					<cfelse>
						#TLFormat(get_emp_out_total_/get_emp_in_total_*100)#
					</cfif>
				</td>
				<td style="text-align:center">
					<cfif get_emp_in_the_past eq 0>
						#TLFormat(get_emp_in_the_past*100)#
					<cfelse>
						#TLFormat(get_emp_in_the_past/get_emp_in_the_past*100)#
					</cfif>
				</td>
			</tr>
		</cfoutput>
	</cfif>
</table>
</cfform>
</div>
<script language="javascript">
	function back2_()
	{
		AjaxPageLoad('<cfoutput>#request.self#?fuseaction=myhome.emptypopup_list_branch_profile_ajaxbranchprofile&selection='+document.branch_comp_det.comp_selection.value+'&sal_mon='+document.branch_comp_det.sal_mon.value+'</cfoutput>','div_branch_profile_det',1);
		return false;
	}
	function load_branch_(comp_id)
	{
		AjaxPageLoad('<cfoutput>#request.self#?fuseaction=myhome.emptypopup_list_branch_det&comp_id='+comp_id+'&branch_selection='+document.branch_comp_det.comp_selection.value+'&sal_mon='+document.branch_comp_det.sal_mon.value+'</cfoutput>','div_branch_comp_det',1);
		return false;
	}
	function change_det_(comp_selection,sal_mon)
	{
		if(document.branch_comp_det.comp_selection.value == 1)
		{
			document.getElementById("comp_selection_1").style.display = '';
			document.getElementById("comp_selection_1_").style.display = '';
		}
		else
		{
			document.getElementById("comp_selection_1").style.display = 'none';
			document.getElementById("comp_selection_1_").style.display = 'none';
		}
		if(document.branch_comp_det.comp_selection.value == 2)
		{
			document.getElementById("comp_selection_2").style.display = '';
			document.getElementById("comp_selection_2").style.display = '';
		}
		else
		{
			document.getElementById("comp_selection_2").style.display = 'none';
			document.getElementById("comp_selection_2_").style.display = 'none';
		}
		if(document.branch_comp_det.comp_selection.value == 3)
		{
			document.getElementById("comp_selection_3").style.display = '';
			document.getElementById("comp_selection_3_").style.display = '';
		}
		else
		{
			document.getElementById("comp_selection_3").style.display = 'none';
			document.getElementById("comp_selection_3_").style.display = 'none';
		}
		AjaxPageLoad('<cfoutput>#request.self#?fuseaction=myhome.emptypopup_list_branch_comp_det&comp_selection='+comp_selection+'&sal_mon='+sal_mon+'</cfoutput>','div_branch_comp_det',1);
		return true;
	}
</script>
