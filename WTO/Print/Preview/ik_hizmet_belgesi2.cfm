<cfset attributes.ID = attributes.action_id>
<cfset attributes.ID = action_id>
<cfquery name="get_in_out" datasource="#DSN#">
	SELECT
		EMPLOYEE_ID,
		START_DATE,
		FINISH_DATE,
		EXPLANATION_ID,
		SOCIALSECURITY_NO,
		VALID_EMP
	FROM
		EMPLOYEES_IN_OUT
	WHERE
		IN_OUT_ID = #attributes.ID#
</cfquery>

<cfset attributes.employee_id = get_in_out.EMPLOYEE_ID>
<cfif not len(attributes.employee_id)>
	<script type="text/javascript">
		alert("Çalışan Kaydı Bulunamadı !");
		history.back();
	</script>
	<cfabort>
</cfif>
<cfquery name="get_emp_short_info" datasource="#DSN#">
	SELECT 	
		MEMBER_CODE,
		PHOTO,
		EMPLOYEE_NAME,
		EMPLOYEE_SURNAME,
		GROUP_STARTDATE,
		PHOTO_SERVER_ID,
		EI.TC_IDENTY_NO
	FROM 
		EMPLOYEES E,
		EMPLOYEES_IDENTY EI
	WHERE 
		E.EMPLOYEE_ID = #attributes.employee_id# AND
		E.EMPLOYEE_ID = EI.EMPLOYEE_ID
</cfquery>
<cfquery name="get_last_position_name" datasource="#DSN#" maxrows="1">
SELECT 	
	EPH.POSITION_NAME,
	D.DEPARTMENT_HEAD,
	ST.TITLE,
	B.BRANCH_NAME
FROM 
	EMPLOYEE_POSITIONS_HISTORY EPH,
	DEPARTMENT D,
	SETUP_TITLE ST,
	BRANCH B
WHERE
	EPH.EMPLOYEE_ID = #attributes.employee_id#
	AND D.DEPARTMENT_ID = EPH.DEPARTMENT_ID
	AND EPH.IS_MASTER = 1
	AND ST.TITLE_ID = EPH.TITLE_ID
	AND B.BRANCH_ID = D.BRANCH_ID
ORDER BY 
	HISTORY_ID DESC
</cfquery>
<table>
	<tr>
		<td width="135">&nbsp;</td>
		<td><cfinclude template="/V16/objects/display/view_company_logo.cfm"></td>
	</tr>
</table>
<table width="650" align="center">
	<tr>
		<td align="center" width="115" height="150">
		<cfif len(get_emp_short_info.photo)>
			<cf_get_server_file output_file="hr/#get_emp_short_info.photo#" output_server="#get_emp_short_info.photo_server_id#" output_type="0" image_width="105" image_height="136">
		<cfelse>
			Foto
		</cfif>
		</td>
		<td style="text-align:right;" valign="bottom"><cfoutput>#dateformat(NOW(),'DD.MM.YYYY')#</cfoutput></td>
	</tr>
</table>
<table width="650" align="center">
	<tr align="center">
		<td colspan="2" class="headbold" height="30">HİZMET BELGESİ</td>
	</tr>
	<tr>
		<td width="75"><cf_get_lang_main no='158.Adı Soyadı'></td>
		<td>: <cfoutput>#get_emp_short_info.employee_name# #get_emp_short_info.employee_surname#</cfoutput></td>
	</tr>
	<tr>
		<td>Sicil No</td>
		<td>: <cfoutput>#get_emp_short_info.member_code#</cfoutput></td>
	</tr>
	<tr>
		<td><cf_Get_lang_main no='159.Ünvanı'></td>
		<td>:
		<cfif get_last_position_name.recordcount>
			<cfoutput>#get_last_position_name.TITLE#</cfoutput>
		<cfelse>
			YOK!
		</cfif>
		</td>
	</tr>
	<tr>
		<td>Son Görev Yeri</td>
		<td>:
		<cfif get_last_position_name.recordcount>
			<cfoutput>#get_last_position_name.BRANCH_NAME# - #get_last_position_name.DEPARTMENT_HEAD#</cfoutput>
		</cfif>
		</td>
	</tr>
	<tr>
		<td>Başlama Tarihi</td>
		<td>: <cfoutput query="get_in_out">#dateformat(START_DATE,dateformat_style)#</cfoutput></td>
	</tr>
	<tr>
		<td>Ayrılma Tarihi</td>
		<td>: <cfoutput query="get_in_out">#dateformat(FINISH_DATE,dateformat_style)#</cfoutput></td>
	</tr>
	<tr>
		<td>Ayrılma Nedeni</td>
		<td>: 
		<cfif get_in_out.explanation_id eq 1>(4857 29)Toplu İşçi Çıkarma<!--- 12 ---></cfif>
		<cfif get_in_out.explanation_id eq 2>(4857 17)Bildirimli Fesih İşçi Tarafından<!--- 13 ---></cfif>
		<cfif get_in_out.explanation_id eq 26>(4857 17)Bildirimli Fesih İşveren Tarafından<!--- 12 ---></cfif>
		<cfif get_in_out.explanation_id eq 27>Belirli Süreli Sözleşmenin Bitimi<!--- 11 ---></cfif>
		<cfif get_in_out.explanation_id eq 21>(4857 15)Deneme Süresi İçinde İşçi Tarafından<!--- 1 ---></cfif>
		<cfif get_in_out.explanation_id eq 25>(4857 15)Deneme Süresi İçinde İşveren Tarafından<!--- 2 ---></cfif>
		<cfif get_in_out.explanation_id eq 6>(1475 14)Askerlik<!--- 11 ---></cfif>
		<cfif get_in_out.explanation_id eq 7>(1475 14)Evlenme<!--- 10 ---></cfif>
		<cfif get_in_out.explanation_id eq 3>(1475 14)Malülen Emeklilik<!--- 9 ---></cfif>
		<cfif get_in_out.explanation_id eq 4>(1475 14)Normal Emeklilik<!--- 9 ---></cfif>
		<cfif get_in_out.explanation_id eq 5>(1475 14)Ölüm<!--- 7 ---></cfif>
		<cfif get_in_out.explanation_id eq 29>(1475 14)Emeklilik İçin Yaş Dışında Diğer Şartların Tamamlanması<!--- 14 ---></cfif>
		<cfif get_in_out.explanation_id eq 14>(4857 24-1)Sağlık Nedeni İle<!--- 4 ---></cfif>
		<cfif get_in_out.explanation_id eq 9>(4857 25-1)Sağlık Nedeni İle<!--- 3 ---></cfif>
		<cfif get_in_out.explanation_id eq 10>(4857 24-2)İşverenin Ahlak ve İyi Niyetine Aykırı Hareketi<!--- 4 ---></cfif>
		<cfif get_in_out.explanation_id eq 8>(4857 16)İşe Ara Verme(Zorunlu Nedenler)<!--- 11 ---></cfif>
		<cfif get_in_out.explanation_id eq 13>(4857 17)İşe Ara Verme(Zorunlu Nedenler)<!--- 11 ---></cfif>
		<cfif get_in_out.explanation_id eq 15>(4857 25-2)İşçinin Ahlak ve İyi Niyet Kurallarına Aykırı Hareketi<!--- 3 ---></cfif>
		<cfif get_in_out.explanation_id eq 11>(4857 25-2)Disiplin Kurulu Kararı İle Fesih<!--- 3 ---></cfif>
		<cfif get_in_out.explanation_id eq 12>(4857 25-2)Devamsızlık<!--- 3 ---></cfif>
		<cfif get_in_out.explanation_id eq 17>İşin Sona Ermesi<!--- 12 ---></cfif>
		<cfif get_in_out.explanation_id eq 18>Nakil<!--- 11 ---></cfif>
		<cfif get_in_out.explanation_id eq 19>İşyerinin Kapanması<!--- 12 ---></cfif>
		<cfif get_in_out.explanation_id eq 20>Vize Süresinin Bitimi<!--- 11 ---></cfif>
		<cfif get_in_out.explanation_id eq 22>Mevsim Bitimi<!--- 11 ---></cfif>
		<cfif get_in_out.explanation_id eq 23>Kampanya Bitimi<!--- 11 ---></cfif>
		<cfif get_in_out.explanation_id eq 24>Statü Değişikliği(Memur Sözleşmeli)<!--- 11 ---></cfif>
		<cfif get_in_out.explanation_id eq 28>Diğer Nedenler</cfif>
		</td>
	</tr>
	<tr>
		<td>T.C. No</td>
		<td>: <cfoutput>#get_emp_short_info.TC_IDENTY_NO#</cfoutput></td>
	</tr>
</table>
<br/>
<table width="650" align="center">
	<tr>
		<td>Yukarıda kimliği yazılı kişinin kurumumuzda çalıştığı süreyi
		gösterir işbu belge isteği üzerine verilmiştir.<br/><br/>
		Saygılarımızla</td>
	</tr>
	<tr>
		<td class="txtbold">
			<br/><br/>Onaylayan : <cfoutput>#get_emp_info(GET_IN_OUT.VALID_EMP,0,0)#</cfoutput>
		</td>
	</tr>
	<tr>
		<td class="txtbold">
			<br/><br/>
		</td>
	</tr>
</table>
