<cfparam name="attributes.employee_id" default="">
<cfparam name="attributes.employee_name" default="">
<cfparam name="attributes.source_system" default="">
<cfif isdefined("attributes.start_date") and len(attributes.start_date) and isdate(attributes.start_date)>
	<cf_date tarih='attributes.start_date'>
<cfelse>
	<cfset attributes.start_date = date_add('d',-1,createodbcdatetime('#year(now())#-#month(now())#-#day(now())#'))>
</cfif>
<cfif isdefined("attributes.finish_date") and len(attributes.finish_date) and isdate(attributes.finish_date)>
	<cf_date tarih='attributes.finish_date'>
<cfelse>
	<cfset attributes.finish_date = createodbcdatetime('#year(now())#-#month(now())#-#day(now())#')>	
</cfif>
<cfif isdefined("attributes.form_varmi")>
	<cfset arama_yapilmali = 0>
	<cfquery name="GET_PROVISION_IMPORTS" datasource="#dsn2#">
		SELECT
			*
		FROM
			FILE_IMPORTS
		WHERE
			PROCESS_TYPE = -8 AND
			RECORD_DATE BETWEEN #attributes.start_date# AND #DATEADD("d",1,attributes.finish_date)#
		<cfif len(attributes.source_system)>
			AND SOURCE_SYSTEM = #attributes.source_system#
		</cfif>
		<cfif len(attributes.employee_name) and len(attributes.employee_id)>
			AND RECORD_EMP = #attributes.employee_id#
		</cfif>
		ORDER BY
			I_ID DESC
	</cfquery>
<cfelse>
  	<cfset arama_yapilmali = 1>
  	<cfset GET_PROVISION_IMPORTS.recordcount = 0>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#GET_PROVISION_IMPORTS.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
		<cfform name="search_form" method="post" action="#request.self#?fuseaction=bank.list_multi_pos_import">
		<input name="form_varmi" id="form_varmi" value="1" type="hidden">
			<cf_box_search> 
				<div class="form-group">
					<div class="input-group">
						<input type="hidden" name="employee_id" id="employee_id" value="<cfoutput>#attributes.employee_id#</cfoutput>">
						<input name="employee_name" type="text" id="employee_name" style="width:130px;" onFocus="AutoComplete_Create('employee_name','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_PARTNER_NAME2,MEMBER_NAME2','get_member_autocomplete','\'1,2,3\'','EMPLOYEE_ID','employee_id','','3','250');" value="<cfoutput>#attributes.employee_name#</cfoutput>" autocomplete="off" placeholder="<cfoutput><cf_get_lang dictionary_id='57899.Kaydeden'></cfoutput>">
						<span class="input-group-addon icon-ellipsis btnPointer" title="<cf_get_lang dictionary_id='57899.Kaydeden'>" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=search_form.employee_id&field_name=search_form.employee_name&select_list=1,7,8','list','popup_list_positions');"></span>
					</div>
				</div>
				<div class="form-group">
					<select name="source_system" id="source_system" style="width:100px"><!--- toplu pos dönüşünde sadece çalıştıgımız bankalardrr --->
						<option value="" <cfif attributes.source_system eq 0>selected</cfif>><cf_get_lang dictionary_id ='29449.Banka Hesabı'></option>
						<option value="10" <cfif attributes.source_system eq 10>selected</cfif>><cf_get_lang dictionary_id="48737.Akbank"></option>
						<option value="11" <cfif attributes.source_system eq 11>selected</cfif>><cf_get_lang dictionary_id="48730.İş Bankası"></option>
						<option value="12" <cfif attributes.source_system eq 12>selected</cfif>><cf_get_lang dictionary_id="48720.HSBC"></option>
						<option value="13" <cfif attributes.source_system eq 13>selected</cfif>><cf_get_lang dictionary_id="57717.Garanti"></option>
						<option value="14" <cfif attributes.source_system eq 14>selected</cfif>><cf_get_lang dictionary_id="48732.Yapı Kredi"></option>
						<option value="15" <cfif attributes.source_system eq 15>selected</cfif>><cf_get_lang dictionary_id="48765.Finansbank"></option>
					</select>
				</div>
				<div class="form-group">
					<div class="input-group">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id ='58053.Başlangıç Tarihi'></cfsavecontent>
						<cfinput type="text" name="start_date" value="#dateformat(attributes.start_date,dateformat_style)#" style="width:65px;" validate="#validate_style#" maxlength="10" required="yes" message="#message#">
						<span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>
					</div>
				</div>
				<div class="form-group">
					<div class="input-group">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id ='57700.Bitiş Tarihi'></cfsavecontent>
						<cfinput type="text" name="finish_date" value="#dateformat(attributes.finish_date,dateformat_style)#" style="width:65px;" validate="#validate_style#" maxlength="10" required="yes" message="#message#">
						<span class="input-group-addon"><cf_wrk_date_image date_field="finish_date"></span>
					</div>
				</div>
				<div class="form-group small">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" maxlength="3" onKeyUp="isNumber(this)" style="width:25px;" value="#attributes.maxrows#" validate="integer" range="1,250" required="yes" message="#message#">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4" search_function="kontrol()">
				</div>
			</cf_box_search>
		</cfform>
	</cf_box>	
	<cf_box title="#getLang(216,'Toplu Pos Dönüşleri',48877)#" uidrop="1" hide_table_column="1">
		<cf_grid_list>
			<thead>
				<tr>
					<th width="20"><cf_get_lang dictionary_id="58577.Sıra"></th>
					<th><cf_get_lang dictionary_id='57521.Banka'></th>
					<!-- sil --><th><cf_get_lang dictionary_id='57468.Belge'></th><!-- sil -->
					<th><cf_get_lang dictionary_id='57627.Kayıt Tarihi'></th>
					<th><cf_get_lang dictionary_id='57899.Kaydeden'></th>
					<!-- sil -->
					<th width="20" class="header_icn_none">
						<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=bank.list_multi_pos_import&event=add</cfoutput>','small');"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a>
					</th>
					<!-- sil -->
				</tr>
			</thead>
			<tbody>
				<cfif GET_PROVISION_IMPORTS.recordcount>
					<cfset employee_id_list=''>
					<cfoutput query="GET_PROVISION_IMPORTS" maxrows="#attributes.maxrows#" startrow="#attributes.startrow#">
						<cfif len(RECORD_EMP) and not listfind(employee_id_list,RECORD_EMP)>
							<cfset employee_id_list=listappend(employee_id_list,RECORD_EMP)>
						</cfif>
					</cfoutput>
					<cfif len(employee_id_list)>
						<cfset employee_id_list=listsort(employee_id_list,"numeric","ASC",",")>
						<cfquery name="get_emp_detail" datasource="#dsn#">
							SELECT EMPLOYEE_NAME,EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEE_ID IN (#employee_id_list#) ORDER BY EMPLOYEE_ID
						</cfquery>
					</cfif>
					<cfoutput query="GET_PROVISION_IMPORTS" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
					<tr>
						<td>#currentrow#</td>
						<td>
							<cfif SOURCE_SYSTEM eq 10><cf_get_lang dictionary_id="48737.Akbank">
							<cfelseif SOURCE_SYSTEM eq 11><cf_get_lang dictionary_id="48730.İş Bankası">
							<cfelseif SOURCE_SYSTEM eq 12><cf_get_lang dictionary_id="48720.HSBC">
							<cfelseif SOURCE_SYSTEM eq 13><cf_get_lang dictionary_id="48725.Garanti">
							<cfelseif SOURCE_SYSTEM eq 14><cf_get_lang dictionary_id="48732.Yapı Kredi">
							<cfelseif SOURCE_SYSTEM eq 15><cf_get_lang dictionary_id="48765.Finansbank">
							</cfif>
						</td>
						<!-- sil --><td>
						<cf_get_server_file output_file="finance/#file_name#" output_server="#file_server_id#" output_type="2" small_image="images/attach.gif" image_link="1">
						</td><!-- sil -->
						<td>#dateformat(RECORD_DATE,dateformat_style)# (#timeformat(RECORD_DATE,timeformat_style)#)</td>
						<td><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#RECORD_EMP#','medium');" class="tableyazi"> #get_emp_detail.EMPLOYEE_NAME[listfind(employee_id_list,RECORD_EMP,',')]#&nbsp; #get_emp_detail.EMPLOYEE_SURNAME[listfind(employee_id_list,RECORD_EMP,',')]#</a></td>
						<!-- sil -->
						<td nowrap="nowrap">
						<cfif IMPORTED eq 0><!--- bank.emptypopupflush_import_pos_file&i_id=#I_ID# --->
							<cfsavecontent variable="message"><cf_get_lang dictionary_id ='48981.Pos Dönüş Belgesini İmport Etmek İstediğinizden Emin misiniz'></cfsavecontent>
							<a href="javascript://" onClick="if (confirm('#message#')) windowopen('#request.self#?fuseaction=bank.popup_add_currency_info&i_id=#I_ID#','small');"><img src="/images/cubexport.gif" alt="<cf_get_lang dictionary_id ='48972.İmport Et'>" title="<cf_get_lang dictionary_id ='48972.İmport Et'>"></a>
							<cfsavecontent variable="message"><cf_get_lang dictionary_id ='48982.Pos Belgesini Silmek İstediğinizden Emin misiniz'></cfsavecontent>
							<a href="javascript://" onClick="if (confirm('#message#')) windowopen('#request.self#?fuseaction=bank.emptypopup_del_pos_import_file&i_id=#I_ID#','small');"><img src="/images/delete_list.gif" alt="<cf_get_lang dictionary_id ='48973.Belge Sil'>" title="<cf_get_lang dictionary_id ='48973.Belge Sil'>"></a><!---Provizyon belgeleri silme sayfasıyla aynıdır--->
						<cfelse>
							<cfsavecontent variable="message"><cf_get_lang dictionary_id ='48983.İşlemi Geri Almak İstediğinizden Emin misiniz'></cfsavecontent>
							<a href="javascript://" onClick="if (confirm('#message#')) windowopen('#request.self#?fuseaction=bank.emptypopup_del_bank_pos_rows&i_id=#I_ID#','small');"><img src="/images/delete_list.gif"  alt="<cf_get_lang dictionary_id ='48984.İşlemi Geri Al'>" title="<cf_get_lang dictionary_id ='48984.İşlemi Geri Al'>"></a>
							<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=bank.popup_list_import_bank_pos_rows&i_id=#I_ID#','horizantal');"><img src="/images/transfer.gif" alt="<cf_get_lang dictionary_id ='48985.Pos Satırları'>" title="<cf_get_lang dictionary_id ='48985.Pos Satırları'>"></a>
							<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=bank.popup_list_bank_pos_rows&i_id=#I_ID#','horizantal');"><img src="/images/plus_list.gif" alt="<cf_get_lang dictionary_id ='48986.Tahsilat İşlemleri'>" title="<cf_get_lang dictionary_id ='48986.Tahsilat İşlemleri'>"></a>				
						</cfif>
						</td>
						<!-- sil -->
					</tr>
					</cfoutput>
				<cfelse>
					<tr>
						<td colspan="9">
							<cfif arama_yapilmali neq 1><cf_get_lang dictionary_id ='57484.Kayıt Yok'>!
							<cfelse><cf_get_lang dictionary_id ='57701.Filtre Ediniz'>!</cfif> 
						</td>
					</tr>
				</cfif>
			</tbody>
		</cf_grid_list>
		
		<cfset url_string = ''>
		<cfif isdefined("attributes.start_date") and len(attributes.start_date)>
			<cfset url_string = '#url_string#&start_date=#dateformat(attributes.start_date,dateformat_style)#'>
		</cfif>
		<cfif isdefined("attributes.finish_date") and len(attributes.finish_date)>
			<cfset url_string = '#url_string#&finish_date=#dateformat(attributes.finish_date,dateformat_style)#'>
		</cfif>
		<cfif isdefined("attributes.source_system") and len(attributes.source_system)>
			<cfset url_string = '#url_string#&source_system=#attributes.source_system#'>
		</cfif>
		<cfif isdefined("attributes.employee_id") and len(attributes.employee_id)>
			<cfset url_string = '#url_string#&employee_id=#attributes.employee_id#'>
		</cfif>
		<cfif isdefined("attributes.employee_name") and len(attributes.employee_name)>
			<cfset url_string = '#url_string#&employee_name=#attributes.employee_name#'>
		</cfif>
		<cf_paging 
			page="#attributes.page#" 
			maxrows="#attributes.maxrows#"
			totalrecords="#attributes.totalrecords#"
			startrow="#attributes.startrow#"
			adres="bank.list_multi_pos_import&form_varmi=1&#url_string#">
	</cf_box>
</div>

    <script>
	document.getElementById('employee_name').focus();
    	function kontrol()
		{
			if( !date_check(document.getElementById('start_date'),document.getElementById('finish_date'), "<cf_get_lang dictionary_id='58862.Başlangıç Tarihi Bitiş Tarihinden Büyük Olamaz'>!") )
				return false;
			else
				return true;
		}
    </script>
