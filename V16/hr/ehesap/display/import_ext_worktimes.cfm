<cfquery name="get_related_company" datasource="#dsn#">
	SELECT DISTINCT
		RELATED_COMPANY
	FROM 
		BRANCH
	WHERE
		BRANCH_ID IS NOT NULL
		<cfif not session.ep.ehesap>
			AND BRANCH_ID IN ( SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = #session.ep.position_code# )
		</cfif>
	ORDER BY 
			RELATED_COMPANY
</cfquery>
<cfif month(now()) eq 1>
	<cfparam name="attributes.sal_mon" default="1">
<cfelse>
	<cfparam name="attributes.sal_mon" default="#dateformat(date_add('m',-1,now()),'MM')#">
</cfif>	
<cfparam name="attributes.sal_year" default="#session.ep.period_year#">
<cfparam name="attributes.related_company" default="">
<cfsavecontent variable="ay1"><cf_get_lang dictionary_id='57592.Ocak'></cfsavecontent>
<cfsavecontent variable="ay2"><cf_get_lang dictionary_id='57593.Şubat'></cfsavecontent>
<cfsavecontent variable="ay3"><cf_get_lang dictionary_id='57594.Mart'></cfsavecontent>
<cfsavecontent variable="ay4"><cf_get_lang dictionary_id='57595.Nisan'></cfsavecontent>
<cfsavecontent variable="ay5"><cf_get_lang dictionary_id='57596.Mayıs'></cfsavecontent>
<cfsavecontent variable="ay6"><cf_get_lang dictionary_id='57597.Haziran'></cfsavecontent>
<cfsavecontent variable="ay7"><cf_get_lang dictionary_id='57598.Temmuz'></cfsavecontent>
<cfsavecontent variable="ay8"><cf_get_lang dictionary_id='57599.Ağustos'></cfsavecontent>
<cfsavecontent variable="ay9"><cf_get_lang dictionary_id='57600.Eylül'></cfsavecontent>
<cfsavecontent variable="ay10"><cf_get_lang dictionary_id='57601.Ekim'></cfsavecontent>
<cfsavecontent variable="ay11"><cf_get_lang dictionary_id='57602.Kasım'></cfsavecontent>
<cfsavecontent variable="ay12"><cf_get_lang dictionary_id='57603.Aralık'></cfsavecontent>
<table width="98%" align="center" cellpadding="0" cellspacing="0" border="0" height="35">
<tr>
   <td class="headbold"><cf_get_lang dictionary_id ='53672.Fazla Mesai İmport'></td>
</tr>
</table>	
<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
  <tr class="color-border">
  	<td>
	<table width="100%" border="0" cellspacing="1" cellpadding="2">
	  <tr class="color-row">
		<td width="460" valign="top">
		<table border="0">
		<cfform action="" name="import_worktimes" method="post" enctype="multipart/form-data">
			<cfinclude template="../query/get_our_comp_and_branchs.cfm">
			<tr>
				<td><cf_get_lang dictionary_id ='53701.İlgili Şirket'> *</td>
				<td colspan="2">
				<select name="related_company" id="related_company" style="width:250px;">
					<option value=""><cf_get_lang dictionary_id ='57734.Seçiniz'></option>
					<cfoutput query="get_related_company">
						<cfif len(related_company)>
							<option value="#related_company#" <cfif attributes.related_company is related_company>selected</cfif>>#related_company#</option>
						</cfif>					
					</cfoutput>
				</select>
				</td>
			</tr>
			<tr>
				<td><cf_get_lang dictionary_id ='57453.Şube'> *</td>
				<td colspan="2">
				<select name="branch_id" id="branch_id" style="width:250px;">
					<option value=""><cf_get_lang dictionary_id ='57734.Seçiniz'></option>
					<cfoutput query="get_our_comp_and_branchs">
						<option value="#BRANCH_ID#"<cfif isdefined("attributes.branch_id") and (attributes.branch_id eq branch_id)> selected</cfif>>#BRANCH_NAME#</option>
					</cfoutput>
				</select>
				</td>
			</tr>
			<tr>
			<td><cf_get_lang dictionary_id ='53808.Ay/Yıl'></td>
			<td>
			<select name="sal_mon" id="sal_mon" style="width:145px;">
			  <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
				<cfloop from="1" to="12" index="i">
				  <cfoutput><option value="#i#" <cfif attributes.sal_mon is i>selected</cfif> >#listgetat(ay_list(),i,',')#</option></cfoutput>
				</cfloop>
			</select>
			<input type="text" name="sal_year" id="sal_year" value="<cfif isdefined("attributes.sal_year")><cfoutput>#attributes.sal_year#</cfoutput></cfif>" style="width:87px;">
			</td>
			</tr>
			<tr>
				<td><cf_get_lang dictionary_id='53599.Mesai Türü'></td>
				<td>
					<select name="mesai_type" id="mesai_type">
						<option value="1"><cf_get_lang dictionary_id='53260.Saatlik'></option>
						<option value="2"><cf_get_lang dictionary_id='54198.Dakikalık'></option>
					</select>
				</td>
			</tr>
			<tr class="color-row">
				<td><cf_get_lang dictionary_id ='57468.Belge'> *</td>
				<td colspan="2">
					<input type="file" name="uploaded_file" id="uploaded_file" style="width:200px;"><br /><input type="checkbox" value="1" name="is_puantaj_off" id="is_puantaj_off"><cf_get_lang dictionary_id ='53662.Puantajda Görüntülenmesin'>
				</td>
			</tr>
			<tr class="color-row">
			<cfsavecontent variable="message"><cf_get_lang dictionary_id ='54053.İmport Et'></cfsavecontent>
				<td colspan="3" align="center"><cf_workcube_buttons is_upd='0'insert_info="#message#" is_cancel='0' add_function='import_et()'></td>
			</tr>
		</cfform>
       </table>
  </td>
  <td valign="top">
		<table>
			<tr>
				<td>
					<b><cf_get_lang dictionary_id='58594.Format'></b><br/>
					&nbsp;&nbsp;-<cf_get_lang dictionary_id='30106.Dosya uzantısı csv olmalı kaydedilirken karakter desteği olarak UTF-8 seçilmelidir Alan araları noktalı virgül(;) ile ayrılmalı sayısal değerler için nokta(.) ayrac olarak kullanılmalıdır'><br/>
					&nbsp;&nbsp;-<cf_get_lang dictionary_id='54200.Aktarım işlemi dosyanın 2 satırından itibaren başlar bu yüzden birinci satırda alan isimleri mutlaka olmalıdır.'><br/>
					&nbsp;&nbsp;-<cf_get_lang dictionary_id='54201.Form üzerinden import işleminin yapılacağı şube ve ilişkili şirket seçilir Buradaki seçime göre belgedeki çalışanlara import yapılır.'><br/>
					&nbsp;&nbsp;&nbsp;<cf_get_lang dictionary_id='54202.Bu yüzden şubelerin çalışanları için ayrı ayrı dosya hazırlanmalıdır.'><br/>
					&nbsp;&nbsp;-<cf_get_lang dictionary_id='54203.Form üzerinden import işleminin yapılacağı ay ve yıl değerleri girilir.'><br/>
					&nbsp;&nbsp;-<cf_get_lang dictionary_id='54204.Belgede ilk 5 alan çalışan bilgilerini belirtir  6. alan Süreci 7. alan Mesai Karşılığını belirtir. Sonraki alanlarda 1 den 31 e kadar her gün için mesai saati girilir Olmayan günler için'> 
					&nbsp;&nbsp;&nbsp;<cf_get_lang dictionary_id='54205.0 değeri girilmelidir.'><br/>
					&nbsp;&nbsp;-<cf_get_lang dictionary_id='54206.Son alanda ise toplam mesai saati belirtilir.'>
					&nbsp;&nbsp;<cf_get_lang dictionary_id='54207.Belgede toplam'> <font color="FFF0000"><b>39</b></font> <cf_get_lang dictionary_id='54208.alan olacaktır alanlar sırasi ile'>;<br/>
					&nbsp;&nbsp;1-<cf_get_lang dictionary_id='54209.No(Zorunlu)'> :  <cf_get_lang dictionary_id='54210.Satırların sıra nosunu belirtir.'><br/>
					&nbsp;&nbsp;2-<cf_get_lang dictionary_id='54211.TC Kimlik No (Zorunlu)'>  : <cf_get_lang dictionary_id='54212.İmport işlemi yapılacak çalışanın TC Kimlik No su girilmelidir.'><br/>
					&nbsp;&nbsp;3-<cf_get_lang dictionary_id='54213.Çalışan Ad-Soyad (Zorunlu)'> : <cf_get_lang dictionary_id='54214.İmport işlemi yapılacak çalışanın adı soyadı girilmelidir.'><br/>
					&nbsp;&nbsp;4-<cf_get_lang dictionary_id='54215.Çalışan Şube(Zorunlu)'> : <cf_get_lang dictionary_id='54216.Çalışanın bağlı olduğu şubesi girilmelidir.'><br/>
					&nbsp;&nbsp;5-<cf_get_lang dictionary_id='54217.Çalışan Pozisyon(Zorunlu)'> : <cf_get_lang dictionary_id='54218.Çalışanın pozisyonu girilmelidir.'><br/>
					&nbsp;&nbsp;6-<cf_get_lang dictionary_id='58859.Süreç'> : <cf_get_lang dictionary_id='44142.Süreç ID girmelisiniz'><br/>
					&nbsp;&nbsp;7-<cf_get_lang dictionary_id='30866.Mesai'><cf_get_lang dictionary_id='42004.Karşılığı'> : <cf_get_lang dictionary_id='61426.Mesai Karşılığı Alanına 1 veya 2 değerleri girilmelidir; 1- Serbest Zaman , 2 - Ücrete Eklensin.'><br/>
					&nbsp;&nbsp;8-<cf_get_lang dictionary_id='54219.Mesai Saat(Zorunlu)'> : <cf_get_lang dictionary_id='54220.1 gün yapılan mesai.'> <cf_get_lang dictionary_id='54221.Örn'> : 3<br/>
					&nbsp;&nbsp;9-<cf_get_lang dictionary_id='54219.Mesai Saat(Zorunlu)'> : <cf_get_lang dictionary_id='54222.2 gün yapılan mesai.'> <cf_get_lang dictionary_id='54221.Örn'> : 5<br/>
					&nbsp;&nbsp;.<br/>
					&nbsp;&nbsp;.<br/>
					&nbsp;&nbsp;.<br/>
					&nbsp;&nbsp;38-<cf_get_lang dictionary_id='54219.Mesai Saat(Zorunlu)'> : <cf_get_lang dictionary_id='54223.31 gün yapılan mesai(31 çekmeyen aylar için 0 girilmelidir).'> <cf_get_lang dictionary_id='54221.Örn'> : 5<br/>	
					&nbsp;&nbsp;39-<cf_get_lang dictionary_id='54224.Toplam Mesai(Zorunlu)'> : <cf_get_lang dictionary_id='54225.Ay boyunca çalışanın yaptığı toplam mesai.'> <cf_get_lang dictionary_id='54221.Örn'> : 14
					<br/><br/>
					&nbsp;&nbsp;
					<b><cf_get_lang dictionary_id='57467.Not'> :</b> <cf_get_lang dictionary_id='54226.Saatlik Fazla mesai için dakika girmek isterseniz 1:37 (1 saat 37 dakika) şeklinde giriş yapabilirsiniz'>!
				</td>
			</tr>
		</table>  
  </td>
</tr>
</table>
<script type="text/javascript">
function import_et()
	{
		if(document.import_worktimes.branch_id.value == ""&& document.import_worktimes.related_company.value == "")
		{
			alert("<cf_get_lang dictionary_id ='54051.Lütfen Şube veya İlgili Şirket Seçiniz'> !");
			return false;
		}
		if(document.import_worktimes.uploaded_file.value == "")
		{
			alert("<cf_get_lang dictionary_id ='54052.Lütfen İmport Edilecek Belge Giriniz'> !");
			return false;
		}
		windowopen('','small','cc_paym');
		import_worktimes.action='<cfoutput>#request.self#?fuseaction=ehesap.emptypopup_import_worktimes</cfoutput>';
		import_worktimes.target='cc_paym';
		import_worktimes.submit();
		return false;
	}
</script>

