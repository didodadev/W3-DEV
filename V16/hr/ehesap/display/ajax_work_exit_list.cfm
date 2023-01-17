<cfsetting showdebugoutput="no"> 
<cfquery name="get_branch_work" datasource="#dsn#">
	SELECT
		EIO.IN_OUT_ID,
		E.EMPLOYEE_ID,
		E.EMPLOYEE_NAME,
		E.EMPLOYEE_SURNAME,
		B.BRANCH_NAME,
		EIO.START_DATE,
		EIO.SSK_STATUTE,
		DEPARTMENT_HEAD
	FROM
		EMPLOYEES E,
		EMPLOYEES_IN_OUT EIO,
		DEPARTMENT D,
		BRANCH B
	WHERE
		EIO.DEPARTMENT_ID=D.DEPARTMENT_ID AND
		D.BRANCH_ID=B.BRANCH_ID AND
		E.EMPLOYEE_ID=EIO.EMPLOYEE_ID AND 
		B.BRANCH_ID=#attributes.BRANCH_ID# AND
        <cfif isdefined("attributes.department_id") and len(attributes.department_id)>
        	D.DEPARTMENT_ID = #attributes.department_id# AND
        </cfif>
 		EIO.FINISH_DATE IS NULL
	ORDER BY 
		EMPLOYEE_NAME
</cfquery>
<cfsavecontent variable="header">
	<cfif isdefined("attributes.department_id") and len(attributes.department_id)>
    	<cfoutput>#get_branch_work.department_head#</cfoutput>&nbsp;<cf_get_lang dictionary_id='63267.Departman Çalışanları'>
    <cfelse>
		<cfoutput>#get_branch_work.BRANCH_NAME#</cfoutput>&nbsp;<cf_get_lang dictionary_id='30195.Şube Çalışanları'>
    </cfif>
</cfsavecontent>
<div class="text-bold"><cfoutput>#header#</cfoutput></div>
<cf_ajax_list>
	<thead>
		<tr height="22">
			<th align="left"><cf_get_lang dictionary_id='57570.Ad Soyad'></th>
			<th align="left"><cf_get_lang dictionary_id='38993.SGK Statüsü'></th>
			<th align="left" width="60"><cf_get_lang dictionary_id='53348.İşe Giriş Tarihi'></th>
			<cfif get_branch_work.recordcount>
				<th align="left" width="20"><input type="checkbox" name="change_id_list" id="change_id_list" onClick="Check_()" checked></th>
				<th width="20" class="text-center"><i class="fa fa-cube" title="Çalışan Detay"></i></th>
			</cfif>
		</tr>
	</thead>
	<tbody>
		<cfif get_branch_work.recordcount>
			<input type="hidden" value="<cfoutput>#get_branch_work.recordcount#</cfoutput>" name="worker_count" id="worker_count">
			<cfoutput query="get_branch_work">
				<tr height="20">
					<td>#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#</td>
					<td>
						<cfif SSK_STATUTE eq 1><cf_get_lang dictionary_id="55514.Normal"></cfif>
						<cfif SSK_STATUTE eq 2><cf_get_lang dictionary_id="58541.Emekli"></cfif>
						<cfif SSK_STATUTE eq 3><cf_get_lang dictionary_id="54076.Stajyer Öğrenci"></cfif>
						<cfif SSK_STATUTE eq 4><cf_get_lang dictionary_id="54077.Çırak"></cfif>
						<cfif SSK_STATUTE eq 75><cf_get_lang dictionary_id="54078.Mesleki Stajyer"></cfif>
						<cfif SSK_STATUTE eq 5><cf_get_lang dictionary_id="54079.Anlaşmaya Tabi Olmayan Yabancı"></cfif>
						<cfif SSK_STATUTE eq 6><cf_get_lang dictionary_id="54080.Anlaşmalı Ülke Yabancı Uyruk"></cfif>
						<cfif SSK_STATUTE eq 7><cf_get_lang dictionary_id="56412.Deniz,Basım,Azot,Şeker"></cfif>
						<cfif SSK_STATUTE eq 8><cf_get_lang dictionary_id="54082.Yeraltı Sürekli"></cfif>
						<cfif SSK_STATUTE eq 9><cf_get_lang dictionary_id="54083.Yeraltı Gruplu"></cfif>
						<cfif SSK_STATUTE eq 10><cf_get_lang dictionary_id="54084.Yerüstü Gruplu"></cfif>
						<cfif SSK_STATUTE eq 11><cf_get_lang dictionary_id="54127.YÖK Kısmi İstihdam Öğrenci"></cfif>
						<cfif SSK_STATUTE eq 12><cf_get_lang dictionary_id="58542.Aylık Sigorta Prim İşsizlik Hariç"></cfif>
						<cfif SSK_STATUTE eq 13><cf_get_lang dictionary_id="54129.LIBYA"></cfif>
						<cfif SSK_STATUTE eq 14><cf_get_lang dictionary_id="54130.2098 Sayılı Kanun İşsizlik Hariç"></cfif>
						<cfif SSK_STATUTE eq 15><cf_get_lang dictionary_id="54131.2098 Görevli Malül. Aylığı Alanlar"></cfif>
						<cfif SSK_STATUTE eq 16><cf_get_lang dictionary_id="54085.Görev Malüllük Aylığı Alanlar"></cfif>
						<cfif SSK_STATUTE eq 17><cf_get_lang dictionary_id="54086.İş Kazası,Mes.Hast.,Analık ve Hast. Sig. Tabi"></cfif>
						<cfif SSK_STATUTE eq 50><cf_get_lang dictionary_id="54132.Emekli Sandığı"></cfif>
						<cfif SSK_STATUTE eq 60><cf_get_lang dictionary_id="54087.Banka ve Diğerleri"></cfif>
						<cfif SSK_STATUTE eq 70><cf_get_lang dictionary_id="53956.Bağ-kur"></cfif>
						<cfif SSK_STATUTE eq 71><cf_get_lang dictionary_id="54088.Yabancı Uyruk Özel Anlaşma"></cfif>
						<cfif SSK_STATUTE eq 72><cf_get_lang dictionary_id="54089.Nöbetçi Doktor"></cfif>
						<cfif SSK_STATUTE eq 73><cf_get_lang dictionary_id="54090.Ders Saati Ücretliler"></cfif>
						<cfif SSK_STATUTE eq 74><cf_get_lang dictionary_id="54091.Sabit Ücretliler"></cfif>
                    	<cfif SSK_STATUTE eq 33><cf_get_lang dictionary_id='63737.5434 Sayılı Kanuna Tabi Çalışan'></cfif>
					</td>
					<td>#dateformat(START_DATE,dateformat_style)#</td>
					<td>
						<input type="checkbox" name="in_out_id_list" id="in_out_id_list#currentrow#" value="#IN_OUT_ID#" checked>
					</td>
					<td class="text-center">
						<a href="javascript://" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_page_work_detail&employee_id=#get_branch_work.employee_id#');"><i class="fa fa-cube" title="Çalışan Detay"></i></a>
					</td>
				</tr>
			</cfoutput>
		<cfelse>
			<tr class="color-row">
				<td colspan="4"><cf_get_lang dictionary_id="41546.Çalışan Yok">!</td>
			</tr>
		</cfif>
	</tbody>
	</cf_ajax_list>
<script type="text/javascript">
	function Check_()
	{
		if(document.getElementById("change_id_list").checked==true)
		{

			for (i = 1; i <= <cfoutput>#get_branch_work.recordcount#</cfoutput>; i++)
			document.getElementById("in_out_id_list"+i).checked = true ;
		}
		else
		{
			for (i = 1; i <= <cfoutput>#get_branch_work.recordcount#</cfoutput>; i++) 
			document.getElementById("in_out_id_list"+i).checked = false ;
		}
	}
</script>
