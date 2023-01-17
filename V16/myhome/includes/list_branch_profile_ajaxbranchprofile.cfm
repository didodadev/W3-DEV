<cfsetting showdebugoutput="no">
<cfparam name="attributes.selection" default="1">
<cfif month(now()) neq 1>
	<cfparam name="attributes.sal_mon_" default="#month(now())-1#">
<cfelse>
	<cfparam name="attributes.sal_mon_" default="12">
</cfif>
<div id="div_branch_profile_det">
<cfform name="branch_profile" method="post" action="">
<cfinclude template="../query/get_list_branch_profile.cfm"> 
<div class="ui-form-list flex-end">
	<div class="form-group">
		<div class="col col-5">
			<select name="sal_mon_" id="sal_mon_" onchange="change_det(document.branch_profile.selection.value,this.value);">
				<cfloop from="1" to="12" index="i">
					<cfoutput>
						<option value="#i#" <cfif attributes.sal_mon_ eq i>selected</cfif>>#listgetat(ay_list(),i,',')#</option>
					</cfoutput>
				</cfloop>
			</select>
		</div>
		<div class="col col-7">
			<select name="selection" id="selection" onchange="change_det(this.value,document.branch_profile.sal_mon_.value);">
				<option value="1" <cfif attributes.selection eq 1>selected</cfif>><cf_get_lang_main no='846.Maliyet'></option>
				<option value="2" <cfif attributes.selection eq 2>selected</cfif>><cf_get_lang no='109.Mesai'></option>
				<option value="3" <cfif attributes.selection eq 3>selected</cfif>><cf_get_lang no='114.Toplam Kazanç'></option>
			</select> 
		</div>
	</div>
</div>
<cf_flat_list>
 	<thead>
		<tr id="selection_1" <cfif attributes.selection neq 1>style="display:none;"</cfif>>
			<th width="20%">&nbsp;</th>
			<th style="text-align:center;width:200px;"><cf_get_lang no='124.Çalışan Sayısı'></th>
			<th style="text-align:center;width:200px;"><cf_get_lang no='131.İşveren Maliyeti'><cf_get_lang no='130.İndirimsiz'></th>
			<th style="text-align:center;width:200px;" ><cf_get_lang no='131.İşveren Maliyeti'></th>
			<th style="text-align:center;width:200px;"><cf_get_lang no='132.Ortalama Maliyet'></th>
	    </tr>
		<tr id="selection_2" <cfif attributes.selection neq 2>style="display:none;"</cfif>>
			<th width="20%">&nbsp;</th>
			<th style="text-align:center;width:200px;"><cf_get_lang no='124.Çalışan Sayısı'></th>
			<th style="text-align:center;width:200px;"><cf_get_lang_main no='80.Toplam'><cf_get_lang no='140.Mesai Saati'></th>
			<th style="text-align:center;width:200px;"><cf_get_lang_main no='80.Toplam'><cf_get_lang no='147.Mesai Tutarı'></th>
			<th style="text-align:center;width:200px;"><cf_get_lang no='148.Ortalama'><cf_get_lang no='147.Mesai Tutarı'></th>
		</tr>
		<tr id="selection_3" <cfif attributes.selection neq 3>style="display:none;"</cfif>>
			<th width="20%">&nbsp;</th>
			<th style="text-align:center;width:200px;"><cf_get_lang no='124.Çalışan Sayısı'></th>
			<th style="text-align:center;width:200px;"><cf_get_lang no='114.Toplam Kazanç'></th>
			<th style="text-align:center;width:200px;"><cf_get_lang no='114.Toplam Kazanç'> <cf_get_lang no='155.Artış Oranı'></th>
			<th style="text-align:center;width:200px;"><cf_get_lang no='148.Ortalama'><cf_get_lang no='160.Kazanç'></th>
		</tr>
		 <tr id="selection_4" <cfif attributes.selection neq 4>style="display:none;"</cfif>>
			<th width="20%">&nbsp;</th>
			<th style="text-align:center;width:200px;"><cf_get_lang no='124.Çalışan Sayısı'></th>
			<th style="text-align:center;width:200px;"><cf_get_lang_main no='142.Giriş'> <cf_get_lang_main no='80.Toplam'></th>
			<th style="text-align:center;width:200px;"><cf_get_lang_main no='19.Çıkış'> <cf_get_lang_main no='80.Toplam'></th>
			<th style="text-align:center;width:200px;"><cf_get_lang no='115.Devir Hızı'></th>
			<th style="text-align:center;width:200px;"><cf_get_lang_main no='142.Giriş'><cf_get_lang_main no='19.Çıkış'><cf_get_lang_main no='1259.Oranı'></th>
			<th style="text-align:center;width:200px;"><cf_get_lang no='170.İstikrar Endeksi'></th>
		 </tr>
	</thead>
	<cfoutput>
	<cfif evaluate('emp_number_#attributes.sal_mon_#') eq 0>
		<cfset emp_number_ = 1>
	<cfelse>
		<cfset emp_number_ = evaluate('emp_number_#attributes.sal_mon_#')>
	</cfif>
	<tbody>
	<tr id="selection_1_" <cfif attributes.selection neq 1>style="display:none;"</cfif>>
		<td width="20%"><a href="javascript://" onclick="load_our_company_(document.branch_profile.selection.value,document.branch_profile.sal_mon_.value);"><cf_get_lang_main no='1734.Şirketler'></a></td>
		<td style="text-align:center">#emp_number_#</td>
		<td style="text-align:center" width="20%">#TLFormat(evaluate('isveren_maliyeti_indirimsiz_#attributes.sal_mon_#'))#</td>
		<td style="text-align:center">#TLFormat(evaluate('isveren_maliyeti_#attributes.sal_mon_#'))#</td>
		<td style="text-align:center">#TLFormat(evaluate('isveren_maliyeti_#attributes.sal_mon_#')/emp_number_)#</td>
	</tr>
	<tr id="selection_2_" <cfif attributes.selection neq 2>style="display:none;"</cfif>>
		<td width="20%"><a href="javascript://" onclick="load_our_company_(document.branch_profile.selection.value,document.branch_profile.sal_mon_.value);"><cf_get_lang_main no='1734.Şirketler'></a></td>
		<td style="text-align:center">#emp_number_#</td>
		<td style="text-align:center">#evaluate('toplam_mesai_saati_#attributes.sal_mon_#')#</td>
		<td style="text-align:center">#TLFormat(evaluate('t_ext_Salary_#attributes.sal_mon_#'))#</td>
		<td style="text-align:center">#TLFormat(evaluate('t_ext_Salary_#attributes.sal_mon_#')/emp_number_)#</td>
	</tr>
	<tr class="color-row" id="selection_3_" <cfif attributes.selection neq 3>style="display:none;"</cfif>>
		<td width="20%"><a href="javascript://" onclick="load_our_company_(document.branch_profile.selection.value,document.branch_profile.sal_mon_.value);"><cf_get_lang_main no='1734.Şirketler'></a></td>
		<td style="text-align:center">#emp_number_#</td>
		<td style="text-align:center"><cfif isdefined("get_total_gain_") and get_total_gain_.recordcount>#TLFormat(evaluate('toplam_kazanc_#attributes.sal_mon_#'))#</cfif></td>
		<td style="text-align:center"><cfif isdefined("get_total_gain_") and get_total_gain_.recordcount>#TLFormat(evaluate('toplam_kazanc_#attributes.sal_mon_#')/(evaluate('toplam_kazanc_artis_orani_#attributes.sal_mon_#')-1)*100)#<cfelse>0</cfif></td>
		<td style="text-align:center"><cfif isdefined("get_total_gain_") and get_total_gain_.recordcount>#TLFormat((t_toplam_kazanc+genel_odenek_total+t_ext_Salary)/emp_number_)#</cfif></td>
	</tr>
	<tr class="color-row" id="selection_4_" <cfif attributes.selection neq 4>style="display:none;"</cfif>>
		<cfif attributes.sal_mon_ eq 1>
			<cfset total_emp_number_ = (evaluate('emp_number_12')-evaluate('get_emp_out_total_12')) + (evaluate('emp_number_#attributes.sal_mon_#')-evaluate('get_emp_out_total_#attributes.sal_mon_#'))>
		<cfelse>
			<cfset total_emp_number_ = (evaluate('emp_number_#attributes.sal_mon_-1#')-evaluate('get_emp_out_total_#attributes.sal_mon_-1#')) + (evaluate('emp_number_#attributes.sal_mon_#')-evaluate('get_emp_out_total_#attributes.sal_mon_#'))>
		</cfif>
		<cfif total_emp_number_ eq 0>
			<cfset total_emp_number_ = 1>
		</cfif>
		<td width="20%"><a href="javascript://" onclick="load_our_company_(document.branch_profile.selection.value,document.branch_profile.sal_mon_.value);"><cf_get_lang_main no='1734.Şirketler'></a></td>
		<td style="text-align:center">#emp_number_#</td>
		<td style="text-align:center">#evaluate('get_emp_in_total_#attributes.sal_mon_#')#</td>
		<td style="text-align:center">#evaluate('get_emp_out_total_#attributes.sal_mon_#')#</td>
		<td style="text-align:center">#TLFormat((evaluate('get_emp_out_total_#attributes.sal_mon_#')/(total_emp_number_/2))*100)#</td>
		<td style="text-align:center">
			<cfif evaluate('get_emp_in_total_#attributes.sal_mon_#') eq 0>
				#TLFormat(evaluate('get_emp_out_total_#attributes.sal_mon_#')/1*100)#
			<cfelse>
				#TLFormat(evaluate('get_emp_out_total_#attributes.sal_mon_#')/evaluate('get_emp_in_total_#attributes.sal_mon_#')*100)#
			</cfif>
		</td>
		<td style="text-align:center">
			<cfif evaluate('get_emp_in_the_past_#attributes.sal_mon_#') eq 0>
				#TLFormat(evaluate('get_emp_in_the_past#attributes.sal_mon_#')/1*100)#
			<cfelse>
				#TLFormat(evaluate('get_emp_in_the_past#attributes.sal_mon_#')/evaluate('get_emp_in_the_past_#attributes.sal_mon_#')*100)#
			</cfif>
		</td>
	</tr>
	</cfoutput>
	</tbody>
</cf_flat_list>
<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
	<table width="100%" cellpadding="2" cellspacing="1" class="color-row" border="0">
		<tr valign="top">
			<td height="100%" align="left" width="50%">
				<cfset label_list = 'Ocak,Şubat,Mart,Nisan,Mayıs,Haziran,Temmuz,Ağustos,Eylül,Ekim,Kasım,Aralık'>
				<cfset label_list_value = ''>
				<cfset label_list_value2 = ''>
				<cfset label_list_value3 = ''>
				<cfloop from="1" to="12" index="month_">
					<cfif attributes.selection eq 1>
						<cfset label_list_value = listappend(label_list_value,evaluate("isveren_maliyeti_#month_#"))>
					<cfelseif attributes.selection eq 2>
						<cfset label_list_value = listappend(label_list_value,evaluate("toplam_mesai_tutari_#month_#"))>
					<cfelseif attributes.selection eq 3>
						<cfset label_list_value = listappend(label_list_value,evaluate("toplam_kazanc_#month_#"))>
					<cfelseif attributes.selection eq 4>
						<cfif evaluate('get_emp_in_total_#month_#') eq 0>
							<cfset giris_cikis_orani = evaluate('get_emp_out_total_#month_#')/1*100>
						<cfelse>
							<cfset giris_cikis_orani = evaluate('get_emp_out_total_#month_#')/evaluate('get_emp_in_total_#month_#')*100>
						</cfif>
						<cfif evaluate('get_emp_in_the_past_#month_#') eq 0>
							<cfset istikrar_endeksi = evaluate('get_emp_in_the_past#month_#')*100>
						<cfelse>
							<cfset istikrar_endeksi = evaluate('get_emp_in_the_past#month_#')/evaluate('get_emp_in_the_past_#month_#')*100>
						</cfif>
						<cfset label_list_value = listappend(label_list_value,evaluate('get_emp_out_total_#month_#')/(total_emp_number_/2)*100)>
						<cfset label_list_value2 = listappend(label_list_value2,giris_cikis_orani)>
						<cfset label_list_value3 = listappend(label_list_value3,istikrar_endeksi)> 
					</cfif>
				</cfloop>
				<script src="JS/Chart.min.js"></script>
						<cfloop list="#label_list#" index="kk">
							<cfset item="#kk#">
							<cfset value="#listgetat(label_list_value,listfind(label_list,kk))#">
						</cfloop>
						<canvas id="myChartprofile" ></canvas>
					<script>
						var ctx = document.getElementById('myChartprofile');
							var myChartprofile = new Chart(ctx, {
								type: 'bar',
								data: {
									labels: [<cfloop list="#label_list#" index="kk">
													<cfoutput>"#kk#"</cfoutput>,</cfloop>],
									datasets: [{
										label: "grafik yuzdesi",
										backgroundColor: [<cfloop list="#label_list#" index="kk">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>],
										data: [<cfloop list="#label_list#" index="kk"><cfoutput>"#listgetat(label_list_value,listfind(label_list,kk))#"</cfoutput>,</cfloop>],
									}]
								},
								options: {
									legend: {
										display: false
									}
								}
						});
					</script>
				
					<cfif attributes.selection eq 4>
						
							<cfloop list="#label_list#" index="kk2">
								<cfset item="#kk2#"> 
								<cfset value="#listgetat(label_list_value2,listfind(label_list,kk2))#">
							</cfloop>
								<canvas id="myChartprofile" style="float:left;max-height:300px;max-width:300px;"></canvas>
					<script>
						var ctx = document.getElementById('myChartprofile');
							var myChartprofile = new Chart(ctx, {
								type: 'bar',
								data: {
									labels: [<cfloop list="#label_list#" index="kk">
													<cfoutput>"#kk#"</cfoutput>,</cfloop>],
									datasets: [{
										label: "grafik yuzdesi",
										backgroundColor: [<cfloop list="#label_list#" index="kk">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>],
										data: [<cfloop list="#label_list#" index="kk"><cfoutput>"#listgetat(label_list_value2,listfind(label_list,kk))#"</cfoutput>,</cfloop>],
									}]
								},
								options: {
									legend: {
										display: false
									}
								}
						});
					</script>
						
							<cfloop list="#label_list#" index="kk3">
								<cfset item="#kk3#"> <cfset value="#listgetat(label_list_value3,listfind(label_list,kk3))#">
							</cfloop>
							<canvas id="myChartprofile" style="float:left;max-height:300px;max-width:300px;"></canvas>
					<script>
						var ctx = document.getElementById('myChartprofile');
							var myChartprofile = new Chart(ctx, {
								type: 'bar',
								data: {
									labels: [<cfloop list="#label_list#" index="kk">
													<cfoutput>"#kk#"</cfoutput>,</cfloop>],
									datasets: [{
										label: "grafik yuzdesi",
										backgroundColor: [<cfloop list="#label_list#" index="kk">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>],
										data: [<cfloop list="#label_list#" index="kk"><cfoutput>"#listgetat(label_list_value3,listfind(label_list,kk))#"</cfoutput>,</cfloop>],
									}]
								},
								options: {
									legend: {
										display: false
									}
								}
						});
					</script>
					</cfif>   
				
			</td> 
		</tr>
	</table>
</div>
</cfform>
</div>
<script language="javascript">
	function load_our_company_(selection,sal_mon_)
	{
		AjaxPageLoad('<cfoutput>#request.self#?fuseaction=myhome.emptypopup_list_branch_comp_det&comp_selection='+selection+'&sal_mon_='+sal_mon_+'</cfoutput>','div_branch_profile_det',1);
		return false;
	}
	function change_det(selection,sal_mon_)
	{
		if(document.branch_profile.selection.value == 1)
		{
			selection_1.style.display = '';
			selection_1_.style.display = '';
			selection_2.style.display = 'none';
			selection_2_.style.display = 'none';
			selection_3.style.display = 'none';
			selection_3_.style.display = 'none';
			selection_4.style.display = 'none';
			selection_4_.style.display = 'none';
		}
		if(document.branch_profile.selection.value == 2)
		{
			selection_2.style.display = '';
			selection_2_.style.display = '';
			selection_1.style.display = 'none';
			selection_1_.style.display = 'none';
			selection_3.style.display = 'none';
			selection_3_.style.display = 'none';
			selection_4.style.display = 'none';
			selection_4_.style.display = 'none';
		}
		if(document.branch_profile.selection.value == 3)
		{
			selection_3.style.display = '';
			selection_3_.style.display = '';
			selection_1.style.display = 'none';
			selection_1_.style.display = 'none';
			selection_2.style.display = 'none';
			selection_2_.style.display = 'none';
			selection_4.style.display = 'none';
			selection_4_.style.display = 'none';
		}
		if(document.branch_profile.selection.value == 4)
		{
			selection_4.style.display = '';
			selection_4_.style.display = '';
			selection_1.style.display = 'none';
			selection_1_.style.display = 'none';
			selection_2.style.display = 'none';
			selection_2_.style.display = 'none';
			selection_3.style.display = 'none';
			selection_3_.style.display = 'none';
		}
		AjaxPageLoad('<cfoutput>#request.self#?fuseaction=myhome.emptypopup_list_branch_profile_ajaxbranchprofile&selection='+selection+'&sal_mon_='+sal_mon_+'</cfoutput>','div_branch_profile_det',1);
		return true;
	}
</script>
