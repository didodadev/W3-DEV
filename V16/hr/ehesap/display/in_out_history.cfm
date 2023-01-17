<cfquery name="get_in_out" datasource="#dsn#">
	SELECT 
		EI.START_DATE,
		E.EMPLOYEE_NAME,
		E.EMPLOYEE_SURNAME 
	FROM 
		EMPLOYEES_IN_OUT EI,
		EMPLOYEES E 
	WHERE 
		EI.EMPLOYEE_ID = E.EMPLOYEE_ID AND
		IN_OUT_ID=#attributes.in_out_id#
</cfquery>
<cfquery name="get_in_out_history" datasource="#dsn#">
	SELECT * FROM EMPLOYEES_IN_OUT_HISTORY WHERE IN_OUT_ID=#attributes.in_out_id# ORDER BY RECORD_DATE DESC
</cfquery>

<cf_box title="#getLang('','Giriş Çıkış Tarihçesi',53671)# : #get_in_out.EMPLOYEE_NAME# #get_in_out.EMPLOYEE_SURNAME# - #dateformat(get_in_out.START_DATE,dateformat_style)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">	
	<cf_grid_list>
		<thead>
			<tr>
				<th width="35"><cf_get_lang dictionary_id ='53237.SGK No'></th>
				<th width="100"><cf_get_lang dictionary_id ='53553.SSK Statüsü'></th>
				<th width="35"><cf_get_lang dictionary_id ='54124.Sakatlık'></th>
				<th width="100"><cf_get_lang dictionary_id ='53690.Vergi İndirimi'></th>
				<th width="100"><cf_get_lang dictionary_id ='54125.SSK lı'></th>
				<th width="100"><cf_get_lang dictionary_id ='57483.Kayıt'></th>
				<th width="100"><cf_get_lang dictionary_id='57627.Kayıt Tarihi'></th>
				<th width="100"><cf_get_lang dictionary_id ='54126.Mesai'></th>
				<th width="35">5084</th>
			</tr>
		</thead>
		<tbody>
			<cfif get_in_out_history.recordcount>
				<cfoutput query="get_in_out_history">
					<tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
						<td>#SOCIALSECURITY_NO#</td>
						<td>
							<cfif SSK_STATUTE eq 1><cf_get_lang dictionary_id ='53043.Normal'></cfif>
							<cfif SSK_STATUTE eq 2><cf_get_lang dictionary_id ='58541.Emekli'></cfif>
							<cfif SSK_STATUTE eq 3><cf_get_lang dictionary_id ='54076.Stajyer Öğrenci'></cfif>
							<cfif SSK_STATUTE eq 4><cf_get_lang dictionary_id ='54077.Çırak'></cfif>
							<cfif SSK_STATUTE eq 75><cf_get_lang dictionary_id ='54078.Mesleki Stajyer'></cfif>
							<cfif SSK_STATUTE eq 5><cf_get_lang dictionary_id ='54079.Anlaşmaya Tabi Olmayan Yabancı'></cfif>
							<cfif SSK_STATUTE eq 6><cf_get_lang dictionary_id ='54080.Anlaşmalı Ülke Yabancı Uyruk'></cfif>
							<cfif SSK_STATUTE eq 7><cf_get_lang dictionary_id ='54081.Deniz,Basım,Azot,Şeker'></cfif>
							<cfif SSK_STATUTE eq 8><cf_get_lang dictionary_id ='54082.Yeraltı Sürekli'></cfif>
							<cfif SSK_STATUTE eq 9><cf_get_lang dictionary_id ='54083.Yeraltı Gruplu'></cfif>
							<cfif SSK_STATUTE eq 10><cf_get_lang dictionary_id ='54084.Yerüstü Gruplu'></cfif>
							<cfif SSK_STATUTE eq 11><cf_get_lang dictionary_id ='54127.YÖK Kısmi İstihdam Öğrenci'></cfif>
							<cfif SSK_STATUTE eq 12><cf_get_lang dictionary_id ='58542.Aylık Sigorta Prim İşsizlik Hariç'></cfif>
							<cfif SSK_STATUTE eq 13><cf_get_lang dictionary_id ='54129.LIBYA'></cfif>
							<cfif SSK_STATUTE eq 14><cf_get_lang dictionary_id ='54130.2098 Sayılı Kanun İşsizlik Hariç'></cfif>
							<cfif SSK_STATUTE eq 15><cf_get_lang dictionary_id ='54131.2098 Görevli Malül Aylığı Alanlar'></cfif>
							<cfif SSK_STATUTE eq 16><cf_get_lang dictionary_id ='54085.Görev Malüllük Aylığı Alanlar'></cfif>
							<cfif SSK_STATUTE eq 17><cf_get_lang dictionary_id ='54086.İş Kazası,Mes Hast ,Analık ve Hast  Sig  Tabi'></cfif>
							<cfif SSK_STATUTE eq 50><cf_get_lang dictionary_id ='54132.Emekli Sandığı'></cfif>
							<cfif SSK_STATUTE eq 60><cf_get_lang dictionary_id ='54087.Banka ve Diğerleri'></cfif>
							<cfif SSK_STATUTE eq 70><cf_get_lang dictionary_id ='53956.Bağ-kur'></cfif>
							<cfif SSK_STATUTE eq 71><cf_get_lang dictionary_id ='54088.Yabancı Uyruk Özel Anlaşma'></cfif>
							<cfif SSK_STATUTE eq 72><cf_get_lang dictionary_id ='54089.Nöbetçi Doktor'></cfif>
							<cfif SSK_STATUTE eq 73><cf_get_lang dictionary_id ='54090.Ders Saati Ücretliler'></cfif>
							<cfif SSK_STATUTE eq 74><cf_get_lang dictionary_id ='54091.Sabit Ücretliler'></cfif>
							<cfif SSK_STATUTE eq 33><cf_get_lang dictionary_id='63737.5434 Sayılı Kanuna Tabi Çalışan'></cfif>
						</td>
						<td>#DEFECTION_LEVEL#</td>
						<td>
							<cfif USE_TAX eq 1><cf_get_lang dictionary_id='29492.Kullanıyor'><cfelse><cf_get_lang dictionary_id='29493.Kullanmıyor'></cfif>
						</td>
						<td>
							<cfif USE_SSK eq 1><cf_get_lang dictionary_id ='57495.Evet'><cfelse><cf_get_lang dictionary_id ='57496.Hayır'></cfif>
						</td>
						<td>#get_emp_info(record_emp,0,0)#</td>
						<td>#dateformat_style# #dateformat(date_add('h',session.ep.time_zone,RECORD_DATE),dateformat_style)# #timeformat(date_add('h',session.ep.time_zone,RECORD_DATE),timeformat_style)# </td>
						<td>
							<cfif is_vardiya eq 1 or is_vardiya eq 2><cf_get_lang dictionary_id='58545.Vardiyalı'><cfelse><cf_get_lang dictionary_id='58544.Sabit'></cfif>
						</td>
						<td>
							<cfif IS_5084 eq 1><cf_get_lang dictionary_id ='57495.Evet'><cfelse><cf_get_lang dictionary_id ='57496.Hayır'></cfif>
						</td>
					</tr>
				</cfoutput>
				<cfelse>
				<tr class="color-row">
					<td colspan="9"><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
				</tr>
			</cfif>
		</tbody>
	</cf_grid_list>
</cf_box>
