<!--- Standart Egitim Katilimci Bildirim --->
<cf_get_lang_set module_name="training_management"><!--- sayfanin en altinda kapanisi var --->
<cfset attributes.train_group_id = attributes.action_id>
<cfinclude template="../../../V16/training_management/query/get_training_group_attenders.cfm">
<cfquery name="get_training_class_groups" datasource="#dsn#">
	SELECT
		*
	FROM
		TRAINING_CLASS_GROUPS TCG
			INNER JOIN EMPLOYEES E ON E.EMPLOYEE_ID = TCG.GROUP_EMP
	WHERE
		TCG.TRAIN_GROUP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_id#">
</cfquery>

<cfset attributes.training_id = get_training_class_groups.train_group_id>
<cfif len(get_training_class_groups.start_date)>
	<cfset start_date = date_add('h', session.ep.time_zone, get_training_class_groups.start_date)>
</cfif>
<cfif len(get_training_class_groups.finish_date)>
	<cfset finish_date = date_add('h', session.ep.time_zone, get_training_class_groups.finish_date)>
</cfif>
<table style="text-align:center" cellpadding="0" cellspacing="0" border="0" height="35" style="width:180mm;">
	<tr><td style="height:10mm;">&nbsp;</td></tr>
    <tr>
		<td class="headbold"><cf_get_lang no='101.EĞİTİM BİLDİRİM FORMU'></td>
	</tr>
</table><br/>
<table border="0" style="text-align:center;width:180mm;">
	<cfoutput>
	<tr>
		<td style="width:15mm;">&nbsp;</td>
        <td style="width:35mm;height:6mm;text-align:left;" class="txtbold"><cf_get_lang dictionary_id='62393.Sınıf Adı'></td>
		<td style="width:5mm;"> :</td>
        <td style="text-align:left;">&nbsp;#get_training_class_groups.group_head#</td>
	</tr>
    <tr>
    	<td style="width:15mm;">&nbsp;</td>
		<td style="width:35mm;height:6mm;text-align:left;" class="txtbold"><cf_get_lang_main no='641.Başlangıç Tarihi'> / <cf_get_lang_main no='79.Saat'></td>
		<td style="width:5mm;"> :</td>
        <td style="text-align:left;">&nbsp;<cfif len(get_training_class_groups.start_date)>#dateformat(start_date,dateformat_style)# #timeformat(start_date,timeformat_style)#</cfif></td>
	</tr>
	<tr>
    	<td style="width:15mm;">&nbsp;</td>
		<td style="width:35mm;height:6mm;text-align:left;" class="txtbold"><cf_get_lang_main no='288.Bitiş Tarihi'> / <cf_get_lang_main no='79.Saat'></td>
		<td style="width:5mm;"> :</td>
        <td style="text-align:left;">&nbsp;<cfif len(get_training_class_groups.finish_date)>#dateformat(finish_date,dateformat_style)# #timeformat(finish_date,timeformat_style)#</cfif></td>
	</tr>
	<tr>
    	<td style="width:15mm;">&nbsp;</td>
		<td style="width:35mm;height:6mm;text-align:left;" class="txtbold"><cf_get_lang no='117.Eğitmen'></td>
		<td style="width:5mm;"> :</td>
		<td style="text-align:left;">#get_training_class_groups.employee_name# #get_training_class_groups.employee_surname#</td>
	</tr>
	</cfoutput>
	<!--- <cfset mails = ""> --->
	<cfset admins = "">
	<cfset participations = "">
    <tr>
    	<td style="width:15mm;">&nbsp;</td>
		<td colspan="3">
		<table cellSpacing="0" cellpadding="0" border="0" width="100%" style="text-align:center">
			<tr class="color-border"> 
				<td colspan="3">
				<table border="0" width="100%">
					<tr class="color-header">
                        <!--- <td><cf_get_lang dictionary_id='57487.No'></td> --->
						<td><cf_get_lang dictionary_id='55649.TC. Kimlik No'></td>
						<td><cf_get_lang dictionary_id='57570.Ad Soyad'></td>
						<td><cf_get_lang dictionary_id='42014.Rol'></td>
					</tr>
					<cfoutput query="get_attender_emps">
						<tr class="color-row">
							<td>#tc_no#</td>
							<td>#ad# #soyad#</td>
							<td>#position#</td>
						</tr>
					</cfoutput>
					<cfoutput query="get_attender_pars">
						<tr class="color-row">
							<td>#tc_no#</td>
							<td>#ad# #soyad#</td>
							<td>#position#</td>
						</tr>
					</cfoutput>
					<cfoutput query="get_attender_cons">
						<tr class="color-row">
							<td>#tc_no#</td>
							<td>#ad# #soyad#</td>
							<td>#position#</td>
						</tr>
					</cfoutput>
					<cfoutput query="get_attender_grps">
						<tr class="color-row">
							<td>#tc_no#</td>
							<td>#ad# #soyad#</td>
							<td>#position#</td>
						</tr>
					</cfoutput>
				</table>
				</td>
			</tr>
		</table>
		</td>
	</tr>
</table>
<table border="0" style="width:180mm;">
    <tr><td style="height:8mm;">&nbsp;</td></tr>
    <tr><td style="height:8mm; text-align:center;"><cf_get_lang no="202.Yukarıda Belirtilen Bilgiler Doğrultusunda İlgili Tarih ve Saatlerde Eğitim Yerinde Bulunmanızı Rica Ederiz"></td></tr>
</table>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
