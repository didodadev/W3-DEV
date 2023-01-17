<cfparam name="attributes.startdate" default="">
<cfparam name="attributes.finishdate" default="">
<cfparam name="attributes.send_type" default="">
<cfif len(attributes.startdate)>
	<cf_date tarih='attributes.startdate'>
</cfif>
<cfif len(attributes.finishdate)>
	<cf_date tarih='attributes.finishdate'>
</cfif>
<cfquery name="GETCARI" datasource="#dsn2#">
	SELECT 
		COUNT(CARI_LETTER_ROW.CARI_LETTER_ROW_ID) TOTAL,
		CARI_LETTER.CARI_LETTER_ID,
		CARI_LETTER.START_DATE,
		CARI_LETTER.FINISH_DATE,
		CARI_LETTER.SEARCH_TYPE_ID,
		CARI_LETTER.IS_CH,
		CARI_LETTER.IS_CR,
		CARI_LETTER.IS_BA,
		CARI_LETTER.IS_BS,
		CARI_LETTER.BABS_AMOUNT,
		CARI_LETTER.RECORD_DATE,
		CARI_LETTER.UPDATE_DATE,
		EMPLOYEES.EMPLOYEE_NAME,
		EMPLOYEES.EMPLOYEE_SURNAME
	FROM 
		CARI_LETTER,
		CARI_LETTER_ROW,
		#dsn_alias#.EMPLOYEES
	WHERE 
		CARI_LETTER_ROW.CARI_LETTER_ID = CARI_LETTER.CARI_LETTER_ID AND 
		EMPLOYEES.EMPLOYEE_ID = CARI_LETTER.RECORD_EMP 
		<cfif len(attributes.send_type) and attributes.send_type eq 1>AND CARI_LETTER.IS_CH = 1</cfif>
		<cfif len(attributes.send_type) and attributes.send_type eq 2>AND CARI_LETTER.IS_CR = 1</cfif>
		<cfif len(attributes.send_type) and attributes.send_type eq 3>AND CARI_LETTER.IS_BA = 1</cfif>
		<cfif len(attributes.send_type) and attributes.send_type eq 4>AND CARI_LETTER.IS_BS = 1</cfif>
		<cfif len(attributes.startdate)>AND CARI_LETTER.START_DATE >= #attributes.startdate#</cfif>
		<cfif len(attributes.finishdate)>AND CARI_LETTER.START_DATE <= #attributes.finishdate#</cfif>
	GROUP BY 
		CARI_LETTER.CARI_LETTER_ID,
		CARI_LETTER.START_DATE,
		CARI_LETTER.FINISH_DATE,
		CARI_LETTER.SEARCH_TYPE_ID,
		CARI_LETTER.IS_CH,
		CARI_LETTER.IS_CR,
		CARI_LETTER.IS_BA,
		CARI_LETTER.IS_BS,
		CARI_LETTER.BABS_AMOUNT,
		CARI_LETTER.RECORD_DATE,
		CARI_LETTER.UPDATE_DATE,
		EMPLOYEES.EMPLOYEE_NAME,
		EMPLOYEES.EMPLOYEE_SURNAME
	ORDER BY 
		CARI_LETTER.RECORD_DATE 
	DESC
</cfquery>
<cfparam name="attributes.startrow" default='1'>
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default="#getcari.recordcount#">

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
		<cfform name="search" action="#request.self#?fuseaction=finance.list_cari_letter" method="post">
			<cf_box_search>        
				<div class="form-group">
					<div class="input-group">
						<cfsavecontent variable="placeholdermessage"><cf_get_lang dictionary_id="57627.Kayıt Tarihi"></cfsavecontent>
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='58503.Lütfen Tarih giriniz'></cfsavecontent>
						<cfinput type="text" name="startdate" value="#dateformat(attributes.startdate,dateformat_style)#" placeholder="#placeholdermessage#" maxlength="10" style="width:65px" validate="#validate_style#" message="#message#">
						<span class="input-group-addon"><cf_wrk_date_image date_field="startdate"></span>
					</div>
				</div>
				<div class="form-group">
					<div class="input-group">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='57655.Başlama Tarihi'></cfsavecontent>
						<cfinput type="text" name="finishdate" value="#dateformat(attributes.finishdate,dateformat_style)#" maxlength="10" style="width:65px" validate="#validate_style#" message="#message#">
						<span class="input-group-addon"><cf_wrk_date_image date_field="finishdate"></span>
					</div>
				</div>
				<div class="form-group">
					<select name="send_type" id="send_type">
						<option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option>
						<option value="1" <cfif attributes.send_type eq 1>selected</cfif>><cf_get_lang dictionary_id="31568.Mutabakat"></option>
						<option value="2" <cfif attributes.send_type eq 2>selected</cfif>><cf_get_lang dictionary_id="33786.Cari Hatırlatma"></option>
						<option value="3" <cfif attributes.send_type eq 3>selected</cfif>><cf_get_lang dictionary_id="60230.BA"></option>
						<option value="3" <cfif attributes.send_type eq 3>selected</cfif>><cf_get_lang dictionary_id="33806.BS"></option>
					</select>
				</div>
				<div class="form-group small">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" onKeyUp="isNumber (this)" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4">
					<cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'>
				</div>
			</cf_box_search>
		</cfform>
	</cf_box>
	<cfsavecontent variable="message"><cf_get_lang dictionary_id="49865.Mutabakat Mektubu"></cfsavecontent>
	<cf_box title="#message#" uidrop="1" hide_table_column="1">
		<cf_grid_list>
			<thead>
				<tr>
					<th width="30"><cf_get_lang dictionary_id="57487.No"></th>
					<th><cf_get_lang dictionary_id="57501.Başlangıç"></th>
					<th><cf_get_lang dictionary_id="57502.Bitiş"></th>
					<th><cf_get_lang dictionary_id="57486.Kategori"></th>
					<!-- sil -->	
						<th><cf_get_lang dictionary_id="31568.Mutabakat"></th>
					<!-- sil -->
					<th><cf_get_lang dictionary_id="33786.Cari Hatırlatma"></th>
					<th><cf_get_lang dictionary_id="60230.BA"></th>
					<th><cf_get_lang dictionary_id="33806.BS"></th>
					<th><cf_get_lang dictionary_id="33804.BA/BS Limiti"></th>
					<th><cf_get_lang dictionary_id="43121.Kayıt Eden"></th>
					<th><cf_get_lang dictionary_id="57627.Kayıt Tarihi"></th>
					<th><cf_get_lang dictionary_id="58050.Son Güncelleme"></th>
					<th><cf_get_lang dictionary_id="33750.Toplam Şirket Sayısı"></th>
					<!-- sil -->
						<th width="20"><a href="index.cfm?fuseaction=finance.list_cari_letter&event=add"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='44630.Ekle'>" alt="<cf_get_lang dictionary_id='44630.Ekle'>"></i></a></th>
					<!-- sil -->
				</tr>
			</thead>
			<tbody>
				<cfif getcari.recordcount>
					<cfoutput query="getcari" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<tr>
							<td>#currentrow#</td>
							<td>#dateformat(start_date,'dd/mm/yyyy')#</td>
							<td>#dateformat(finish_date,'dd/mm/yyyy')#</td>
							<td><cfif search_type_id eq 0><cf_get_lang dictionary_id="33749.Alacaklılar"></cfif><cfif search_type_id eq 1><cf_get_lang dictionary_id="33957.Borçlular"></cfif><cfif search_type_id eq ""><cf_get_lang dictionary_id="33955.Alacaklılar ve Borçlular"></cfif></td>
							<!-- sil --><td style="text-align:center;color:green"><cfif is_ch eq 1><i class="fa fa-check-square" align="absmiddle" border="0"></i></cfif></td><!-- sil -->
							<td style="text-align:center;color:green"><cfif is_cr eq 1><i class="fa fa-check-square" align="absmiddle" border="0"></i></cfif></td>
							<td style="text-align:center;color:green"><cfif is_ba eq 1><i class="fa fa-check-square" align="absmiddle" border="0"></i></cfif></td>
							<td style="text-align:center;color:green"><cfif is_bs eq 1><i class="fa fa-check-square" align="absmiddle" border="0"></i></cfif></td>
							<td class="moneybox"><cfif is_ba eq 1 or is_bs eq 1><cfif len(babs_amount)>#tlformat(babs_amount)#</cfif></cfif></td>
							<td>#employee_name# #employee_surname#</td>
							<td>#dateformat(record_date,'dd/mm/yyyy')#</td>
							<td>#dateformat(update_date,'dd/mm/yyyy')#</td>
							<td class="moneybox">#total#</td>
							<!-- sil --><td width="20"><a href="index.cfm?fuseaction=finance.list_cari_letter&event=upd&cari_letter_id=#cari_letter_id#"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"/></i></a></td><!-- sil -->
						</tr>
					</cfoutput>
				<cfelse>
				<tr class="color-row" height="20">
					<td colspan="14"><cf_get_lang dictionary_id='58486.Kayıt Bulunamadı'>!</td>
				</tr>
				</cfif>
			</tbody>
		</cf_grid_list>
		<cfif attributes.totalrecords gt attributes.maxrows>
			<cfset adres=attributes.fuseaction>
			<cfif isdefined("attributes.startdate") and len(attributes.startdate)>
				<cfset adres = "#adres#&startdate=#attributes.startdate#">
			</cfif>
			<cfif isdefined("attributes.finishdate") and len(attributes.finishdate)>
				<cfset adres = "#adres#&finishdate=#attributes.finishdate#">
			</cfif>
			<cfif isdefined("attributes.send_type") and len(attributes.send_type)>
				<cfset adres = "#adres#&send_type=#attributes.send_type#">
			</cfif>
			
			<cf_paging page="#attributes.page#" maxrows="#attributes.maxrows#" totalrecords="#attributes.totalrecords#" startrow="#attributes.startrow#" adres="#adres#">
		</cfif>
	</cf_box>
</div>