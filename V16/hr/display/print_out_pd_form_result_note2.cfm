<cfoutput>
<table style="height:275mm;" cellpadding="0" cellspacing="0" align="center">
<tr>
<td valign="top">
<br/><br/>
	<table width="700" align="center">
		<tr>
			<td class="formbold" align="center"><cf_get_lang dictionary_id="35892.DÜŞÜK PERFORMANS BİLDİRİM TUTANAĞI"> (#attributes.performance_note#)</td>
		</tr>
	</table>
	<br/>
	<br/>
	<table width="700" align="center">
		<tr>
			<td><cf_get_lang dictionary_id="35889.Sn."> <strong>#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#</strong> #attributes.perform_year# <cf_get_lang dictionary_id="35891.yılında düşük performans göstermiş ve şirketimizin beklentilerini tam olarak karşılayamamıştır."></td>
		</tr>
		<tr>
			<td>
			<br/><br/>
			....... <cf_get_lang dictionary_id="57593.Şubat"> #attributes.perform_year+1# <cf_get_lang dictionary_id="35888.tarihinde, şirketimizin çalışanı Sn."> ................................ <cf_get_lang dictionary_id="35887.ile gerçekleştirilen toplantıda"> #attributes.perform_year# <cf_get_lang dictionary_id="35886.yılı performans değerlendirme notu ve ilgili çalışan hakkında yöneticileri tarafından yapılan değerlendirmeler,
				 değerlendirme formu üzerinde detaylı olarak kendisi ile paylaşılmıştır.">
			</td>
		</tr>
		<tr>
			<td>
			<br/><br/>
			<cf_get_lang dictionary_id="35835.Söz konusu toplantıda,"> <cf_get_lang dictionary_id="35889.Sn."> <strong>#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#</strong> 'a 15 <cf_get_lang dictionary_id="57593.Şubat"> #attributes.perform_year+1# - 15<cf_get_lang dictionary_id="57596.Mayıs"> #attributes.perform_year+1# <cf_get_lang dictionary_id="35831.tarihleri arasında, 3 aylık ek değerlendirme süresi verilmiş, bu süre zarfında aşağıdaki konularda performansını beklenen düzeye getirmesi konusunda uyarı yapılmıştır.">
			</td>
		</tr>
		<tr>
			<td>
			<br/><br/>
			<u class="txtbold"><cf_get_lang dictionary_id="35830.Performansının düşük kaldığı ve iyileştirmesi gereken konular">:</u>
			</td>
		</tr>
		<tr>
			<td>
			<br/>
			1- #POWERFUL_ASPECTS#
			</td>
		</tr>
		<tr>
			<td>
			<br/>
			2- #TRAIN_NEED_ASPECTS#
			</td>
		</tr>
		<tr>
			<td>
			<br/>
			3- #MANAGER_2_EVALUATION#
			</td>
		</tr>
	</table>
	<table width="700" align="center">
		<tr>
			<td>
			<br/><br/>
			<cf_get_lang dictionary_id="35978.3 aylık değerlendirme süresinin sonunda"><cf_get_lang dictionary_id="35889.Sn."> <strong>#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#</strong>'ın <cf_get_lang dictionary_id="36117.performansı tekrar değerlendirilecek ve hakkında aşağıdaki kararlardan biri alınacaktır.">
			<br/><br/>
			<li><cf_get_lang dictionary_id="36092.Aynı göreve devamı">,</li>
			<li><cf_get_lang dictionary_id="36139.Yönetici değişikliği">,</li>
			<li><cf_get_lang dictionary_id="36056.Görev değişikliği">,</li>
			<li><cf_get_lang dictionary_id="36049.İş akdi fesih">,</li>
			<br/><br/>
			<cf_get_lang dictionary_id="36048.Yapılan toplantının sonuçları ve şirketimizin Sn."> <strong>#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#</strong>'dan <cf_get_lang dictionary_id="36214.beklentileri bu tutanak ile tespit edilmiştir.">
			</td>
		</tr>
	</table>
	<br/><br/>
	<table width="650" align="center">
		<tr>
			<td width="33%" align="center"><u><cf_get_lang dictionary_id="36209.Çalışanın"></u><br/><cf_get_lang dictionary_id="36207.Adı ve Soyadı"></td>
			<td width="33%" align="center"><u><cf_get_lang dictionary_id="36160.1.Değerlendirme Yöneticisinin"></u><br/><cf_get_lang dictionary_id="36207.Adı ve Soyadı"></td>
			<td width="34%" align="center"><u><cf_get_lang dictionary_id="36154.2.Değerlendirme Yöneticisinin"></u><br/><cf_get_lang dictionary_id="36207.Adı ve Soyadı"></td>
		</tr>
		<tr height="50">
			<td align="center" valign="top"><strong>#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#</strong></td>
			<td align="center" valign="top">
			<cfif len(MANAGER_1_EMP_ID)>
				<cfquery dbtype="query" name="get_manager_name">
					SELECT * FROM get_employee_names WHERE EMPLOYEE_ID = #MANAGER_1_EMP_ID#
				</cfquery>
				<strong>#get_manager_name.EMPLOYEE_NAME# #get_manager_name.EMPLOYEE_SURNAME#</strong>
			</cfif>
			</td>
			<td align="center" valign="top">
			<cfif len(MANAGER_2_EMP_ID)>
				<cfquery dbtype="query" name="get_manager_name">
					SELECT * FROM get_employee_names WHERE EMPLOYEE_ID = #MANAGER_2_EMP_ID#
				</cfquery>
				<strong>#get_manager_name.EMPLOYEE_NAME# #get_manager_name.EMPLOYEE_SURNAME#</strong>
			</cfif>
			</td>
		</tr>
		<tr>
			<td align="center"><cf_get_lang dictionary_id="58957.İmza"></td>
			<td align="center"><cf_get_lang dictionary_id="58957.İmza"></td>
			<td align="center"><cf_get_lang dictionary_id="58957.İmza"></td>
		</tr>
	</table>	
</td>
</tr>
</table>
</cfoutput>
