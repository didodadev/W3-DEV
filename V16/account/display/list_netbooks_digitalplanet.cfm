<!--- Digital Planet edefter listesi --->
<cfif isdefined("attributes.start_date")>
	<cfparam name="attributes.start_date" default="#wrk_get_today()#">
<cfelse>
	<cfparam name="attributes.start_date" default="01/01/#session.ep.period_year#">
</cfif>
<cfif isdefined("attributes.finish_date")>
	<cfparam name="attributes.finish_date" default="#wrk_get_today()#">
<cfelse>
	<cfparam name="attributes.finish_date" default="31/12/#session.ep.period_year#">
</cfif>
<cfparam name="attributes.record_start_date" default="">
<cfparam name="attributes.record_finish_date" default="">
<cfif len(attributes.record_start_date)>
	<cf_date tarih="attributes.record_start_date">
</cfif>
<cfif len(attributes.record_finish_date)>
	<cf_date tarih="attributes.record_finish_date">
</cfif>
<cfparam name="attributes.defter_status" default="1">
<cfparam name="attributes.file_name" default="">
<cfparam name="attributes.status_message" default="">
<cfparam name="attributes.type" default="">
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfparam name="attributes.totalrecords" default='0'>
<cfscript>
	netbook = createObject("component","V16.e_government.cfc.netbook");
	netbook.dsn = dsn;
	netbook.dsn2 = dsn2;
</cfscript>
<cfif isdefined("attributes.form_varmi")>
	<cfif isdate(attributes.start_date)>
		<cf_date tarih = "attributes.start_date">
	</cfif>
	<cfif isdate(attributes.finish_date)>
		<cf_date tarih = "attributes.finish_date">
	</cfif>
	<cfscript>
        get_netbooks = netbook.getNetbooks(
		                    start_date : attributes.start_date,
							finish_date : attributes.finish_date,
							defter_status : attributes.defter_status,
							record_start_date : attributes.record_start_date,
							record_finish_date : attributes.record_finish_date,
							status_message : attributes.status_message,
							file_name : attributes.file_name
											);
    </cfscript>
	<cfset attributes.totalrecords=get_netbooks.recordcount>
</cfif>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
		<cfform name="edefter" action="#request.self#?fuseaction=account.#listlast(attributes.fuseaction,'.')#" method="post">
			<input type="hidden" name="form_varmi" id="form_varmi" value="1">
			<cf_box_search>
				<div class="form-group">
					<cfsavecontent variable="place"><cf_get_lang dictionary_id="29800.Dosya Adı"></cfsavecontent>
					<cfinput name="file_name" id="file_name" placeholder="#place#" value="#attributes.file_name#">
				</div>
				<div class="form-group">
					<select name="status_message" id="status_message" style="width:130px;">
						<option value="" ><cf_get_lang dictionary_id="57756.Durum"></option>
						<option value="nbNotCreated" <cfif attributes.status_message eq 'nbNotCreated'>selected</cfif>><cf_get_lang dictionary_id="34235.Defter Yüklendi"></option>
						<option value="nbCreated" <cfif attributes.status_message eq 'nbCreated'>selected</cfif>><cf_get_lang dictionary_id="34214.Defter Oluşturuldu"></option>
						<option value="nbSigned" <cfif attributes.status_message eq 'nbSigned'>selected</cfif>><cf_get_lang dictionary_id="34213.Defter İmzalandı"></option>
						<option value="certCreated" <cfif attributes.status_message eq 'certCreated'>selected</cfif>><cf_get_lang dictionary_id="34210.Berat Oluşturuldu"></option>
						<option value="certSigned" <cfif attributes.status_message eq 'certSigned'>selected</cfif>><cf_get_lang dictionary_id="34209.Berat İmzalandı"></option>
						<option value="nbLegal" <cfif attributes.status_message eq 'nbLegal'>selected</cfif>><cf_get_lang dictionary_id="34238.Resmi Defter"></option>
						<option value="errSchema" <cfif attributes.status_message eq 'errSchema'>selected</cfif>><cf_get_lang dictionary_id="34237.Schematron Sonucu Hatalı"></option>
					</select>
				</div>
				<div class="form-group">
					<div class="input-group">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id ='58053.Başlangıç Tarihi'></cfsavecontent>
						<cfinput type="text" name="start_date" id="start_date" value="#dateformat(attributes.start_date,dateformat_style)#" style="width:65px;" validate="#validate_style#" maxlength="10" placeholder="#message#" message="#message#">
						<span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>
					</div>
				</div>
				<div class="form-group">
					<div class="input-group">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id ='57700.Bitiş Tarihi'></cfsavecontent>
						<cfinput type="text" name="finish_date" id="finish_date" value="#dateformat(attributes.finish_date,dateformat_style)#" style="width:65px;" validate="#validate_style#" maxlength="10" placeholder="#message#" message="#message#">
						<span class="input-group-addon"><cf_wrk_date_image date_field="finish_date"></span>
					</div>
				</div>
				<div class="form-group">
					<select name="defter_status" id="defter_status" style="width:130px;">
						<option value="1" <cfif isdefined("attributes.defter_status") and attributes.defter_status eq 1>selected</cfif>><cf_get_lang dictionary_id="47280.Defterler"></option>
						<option value="-1" <cfif isdefined("attributes.defter_status") and attributes.defter_status eq -1>selected</cfif>><cf_get_lang dictionary_id="34222.Hatalı Defterler"></option>
					</select>
				</div>
				<div class="form-group">
					<select name="type" id="type" style="width:130px;">
						<option value=""><cf_get_lang dictionary_id="57630.Tip"></option>
						<option value="YEVMIYE" <cfif isdefined("attributes.type") and attributes.type eq 'YEVMIYE'>selected</cfif>><cf_get_lang dictionary_id="47281.Yevmiye"></option>
						<option value="KEBIR" <cfif isdefined("attributes.type") and attributes.type eq 'KEBIR'>selected</cfif>><cf_get_lang dictionary_id="47142.Kebir"></option>
					</select>
				</div>
				<div class="form-group">
					<div class="input-group">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id ='58053.Başlangıç Tarihi'></cfsavecontent>
						<cfinput type="text" name="record_start_date" id="record_start_date" value="#dateformat(attributes.record_start_date,dateformat_style)#" style="width:65px;" validate="#validate_style#" maxlength="10" placeholder="#message#" message="#message#">
						<span class="input-group-addon"><cf_wrk_date_image date_field="record_start_date"></span>
					</div>
				</div>
				<div class="form-group">
					<div class="input-group">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id ='57700.Bitiş Tarihi'></cfsavecontent>
						<cfinput type="text" name="record_finish_date" id="record_finish_date" value="#dateformat(attributes.record_finish_date,dateformat_style)#" style="width:65px;" validate="#validate_style#" maxlength="10" placeholder="#message#" message="#message#">
						<span class="input-group-addon"><cf_wrk_date_image date_field="record_finish_date"></span>
					</div>
				</div>
				<div class="form-group small">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" id="maxrows" style="width:25px;" maxlength="3" value="#attributes.maxrows#" validate="integer" range="1,250" required="yes" onKeyUp="isNumber(this)" message="#message#">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4" search_function='input_control()'>
					<cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'>
				</div>
				
			</cf_box_search>
		</cfform>
	</cf_box>
	<cfsavecontent variable="message"> <cf_get_lang dictionary_id="30802.E-Defter"> </cfsavecontent>
	<cf_box title="#message#" uidrop="1" hide_table_column="1">
		<cf_grid_list>
			<thead>
				<tr>
					<th width="30"><cf_get_lang dictionary_id='58577.Sıra'></th>
					<th><cf_get_lang dictionary_id="34221.Benzersiz Dosya Adı"></th>
					<cfif attributes.defter_status eq 1>
						<th><cf_get_lang dictionary_id="57756.Durum"></th>
						<th><cf_get_lang dictionary_id="57630.Tip"></th>
						<th><cf_get_lang dictionary_id="31234.Kimlik"></th>
						<th><cf_get_lang dictionary_id="34220.Defter Dosya Adı"></th>
						<th><cf_get_lang dictionary_id="34219.Dönem Başlangıç"></th>
						<th><cf_get_lang dictionary_id="34218.Dönem Bitiş"></th>
						<th><cf_get_lang dictionary_id="34217.Yevmiye Başlangıç"></th>
						<th><cf_get_lang dictionary_id="34216.Yevmiye Bitiş"></th>
					<cfelse>
						<th><cf_get_lang dictionary_id="34215.Hata Mesajı"></th>
					</cfif>
					<th><cf_get_lang dictionary_id="36199.Açıklama"></th>
					<th><cf_get_lang dictionary_id='57627.Kayıt Tarihi'></th>
					<th><cf_get_lang dictionary_id='57899.Kaydeden'></th>
					<!-- sil --><th class="header_icn_none text-center" ><a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=account.popup_form_create_netbook</cfoutput>','small','edefter');"><i class="fa fa-plus" title="<cf_get_lang dictionary_id ='57582.Ekle'>" alt="<cf_get_lang dictionary_id ='57582.Ekle'>"></i></a></th><!-- sil -->
				</tr>
			</thead>
			<tbody>
				<cfif isdefined("attributes.form_varmi") and get_netbooks.recordcount>
					<cfoutput query="get_netbooks" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<tr oncontextmenu="javascript:right_menu('#UNIQUE_FILE_NAME#',#status_code#,#attributes.defter_status#,#integration_document_id#);return false;">
							<td>#currentrow#</td>
							<td>#UNIQUE_FILE_NAME#</td>
							<cfif attributes.defter_status eq 1>
								<td>
									<cfswitch expression = "#status_message#">
										<cfcase value="nbCreated">
											<cf_get_lang dictionary_id="34214.Defter Oluşturuldu">
										</cfcase>
										<cfcase value="nbSigned">
											<cf_get_lang dictionary_id="34213.Defter İmzalandı">
										</cfcase>
										<cfcase value="certCreated">
											<cf_get_lang dictionary_id="34210.Berat Oluşturuldu">
										</cfcase>
										<cfcase value="certSigned">
											<cf_get_lang dictionary_id="34209.Berat İmzalandı">
										</cfcase>
										<cfcase value="nbLegal">
											<cf_get_lang dictionary_id="34238.Resmi Defter">
										</cfcase>
										<cfcase value="errSchema">
											<cf_get_lang dictionary_id="34237.Schematron Sonucu Hatalı">
										</cfcase>
										<cfcase value="errVerifySchema">
											<cf_get_lang dictionary_id="34237.Schematron Sonucu Hatalı">
										</cfcase>
										<cfcase value="MofNetbookServiceGenericError">
											<cf_get_lang dictionary_id="34236.Netbook Service Genel Hata">
										</cfcase>
										<cfdefaultcase>
											<cf_get_lang dictionary_id="34235.Defter Yüklendi">
										</cfdefaultcase>
									</cfswitch>
								</td>
								<td>#type#</td>
								<td>#uniqueid#</td>
								<td>#listfirst(file_name,'.')#</td>
								<td>#dateformat(start_date,dateformat_style)#</td>
								<td>#dateformat(finish_date,dateformat_style)#</td>
								<td>#BILL_START_NUMBER#</td>
								<td>#BILL_FINISH_NUMBER#</td>
							<cfelse>
								<td>#htmleditformat(error_detail)#</td>
							</cfif>
							<td>#detail#</td>
							<td>#dateformat(record_date,dateformat_style)#</td>
							<td><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#record_emp#','medium');" class="tableyazi">#record_name#</a></td>
							<td></td>
						</tr>
					</cfoutput>
				<cfelse>
					<tr>
						<td colspan="15"><cfif isdefined("attributes.form_varmi")><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'> !</cfif></td>
					</tr>
				</cfif>
			</tbody>
		</cf_grid_list>
		<cfset adres="account.#listlast(attributes.fuseaction,'.')#">
		<cfif isdefined("attributes.start_date")>
			<cfset adres = "#adres#&start_date=#dateFormat(attributes.start_date,dateformat_style)#">
		</cfif>
		<cfif isdefined("attributes.finish_date")>
			<cfset adres = "#adres#&finish_date=#dateFormat(attributes.finish_date,dateformat_style)#">
		</cfif>
		<cfif isdefined("attributes.defter_status")>
			<cfset adres = "#adres#&defter_status=#attributes.defter_status#">
		</cfif>
		<cfif isdefined("attributes.form_varmi")>
			<cfset adres = "#adres#&form_varmi=#attributes.form_varmi#">
		</cfif>
		<cf_paging page="#attributes.page#"
			maxrows="#attributes.maxrows#"
			totalrecords="#attributes.totalrecords#"
			startrow="#attributes.startrow#"
			adres="#adres#">
	</cf_box>
</div>
<script type="text/javascript">
	$(document).ready(function(e) {
        $('input[name="file_name"]').focus();
    });
	function input_control()
	{
		if ((document.getElementById('finish_date').value.length == 0 || document.getElementById('start_date').value.length == 0 ))
		{
			alert("<cf_get_lang dictionary_id='56195.Lütfen Tarih Seçiniz'>!");
			return false;
		}
		return true;
	}

	function right_menu(unique_file,status_code,defter_status,integration_document_id){
		if(document.getElementById('right_menu_div'))
		{
			document.onclick = function(){document.getElementById("right_menu_div").style.visibility = "hidden";};//sol tuşa basıldığında divimiz kaybolsun..
			document.getElementById('right_menu_div').style.visibility= 'visible';
			var pageX=event.clientX + document.body.scrollLeft;
			var pageY=event.clientY + document.body.scrollTop;
			document.getElementById("right_menu_div").style.top=pageY + 'px';
			document.getElementById("right_menu_div").style.left=pageX + 'px';
			document.getElementById("right_menu_div").style.display = 'table';
			document.getElementById("right_menu_div").style.visibility = "visible";
			right_menu_str ='<table class="contextMenuContent">';
			if(defter_status == 1)
			{
				if(status_code != 3 || status_code == -1)
					right_menu_str +='<tr><td id="td3"><a href="javascript://" onClick="windowopen(\'<cfoutput>#request.self#</cfoutput>?fuseaction=account.popup_netbook_status&type=2&unique_file_name='+unique_file+'\',\'small\')">Durum Sorgula</a></td></tr>';
				if(status_code != -1)
				{
					right_menu_str +='<tr><td id="td3"><a href="javascript://" onClick="windowopen(\'<cfoutput>#request.self#</cfoutput>?fuseaction=account.popup_netbook_status&type=1&unique_file_name='+unique_file+'&integration_document_id='+integration_document_id+'\',\'wwide1\')"><cf_get_lang dictionary_id='61335.Defteri Görüntüle'></a></td></tr>';
					if(status_code == 1)
						right_menu_str +='<tr><td id="td3"><a href="javascript://" onClick="windowopen(\'<cfoutput>#request.self#</cfoutput>?fuseaction=account.popup_netbook_status&type=3&unique_file_name='+unique_file+'\',\'small\')">İmzala</a></td></tr>';
					if(status_code != 1)
						right_menu_str +='<tr><td id="td3"><a href="javascript://" onClick="windowopen(\'<cfoutput>#request.self#</cfoutput>?fuseaction=account.popup_netbook_status&type=4&unique_file_name='+unique_file+'&integration_document_id='+integration_document_id+'\',\'wwide1\')"><cf_get_lang dictionary_id='61336.Beratı Görüntüle'></a></td></tr>';
					if(status_code == 3 || status_code == 2)
						right_menu_str +='<tr><td id="td3"><a href="javascript://" onClick="windowopen(\'<cfoutput>#request.self#</cfoutput>?fuseaction=account.popup_netbook_status&type=7&unique_file_name='+unique_file+'&integration_document_id='+integration_document_id+'\',\'small\')"><cf_get_lang dictionary_id='61337.Defteri İndir'></a></td></tr>';
					if(status_code == 2)
					{
						right_menu_str +='<tr><td id="td3"><a href="javascript://" onClick="windowopen(\'<cfoutput>#request.self#</cfoutput>?fuseaction=account.popup_netbook_status&type=5&unique_file_name='+unique_file+'&integration_document_id='+integration_document_id+'\',\'small\')"><cf_get_lang dictionary_id='61338.Beratı İndir'></a></td></tr>';
						//right_menu_str +='<tr><td id="td3"><a href="javascript://" onClick="windowopen(\'<cfoutput>#request.self#</cfoutput>?fuseaction=account.popup_netbook_status&type=6&bulkUpload=0&unique_file_name='+unique_file+'&integration_document_id='+integration_document_id+'\',\'small\')">Gib Onaylı Beratı Yükle</a></td></tr>';
						right_menu_str +='<tr><td id="td3"><a href="javascript://" onClick="windowopen(\'<cfoutput>#request.self#</cfoutput>?fuseaction=account.popup_netbook_status&type=6&bulkUpload=1&unique_file_name='+unique_file+'&integration_document_id='+integration_document_id+'\',\'small\')"><cf_get_lang dictionary_id='61339.Toplu Berat Yükle'></a></td></tr>';
						right_menu_str +='<tr><td id="td3"><a href="javascript://" onClick="windowopen(\'<cfoutput>#request.self#</cfoutput>?fuseaction=account.popup_netbook_status&type=9&unique_file_name='+unique_file+'\',\'small\')">GİB e gönder</a></td></tr>';
					}
				}
				if(status_code != 3 && integration_document_id != 0)
					right_menu_str +='<tr><td id="td3"><a href="javascript://" onClick="windowopen(\'<cfoutput>#request.self#</cfoutput>?fuseaction=account.popup_netbook_status&type=0&unique_file_name='+unique_file+'\',\'small\')"><cf_get_lang dictionary_id='61340.Defteri Sil'></a></td></tr>';
			} else if (defter_status == -1)
				right_menu_str +='<tr><td id="td3"><a href="javascript://" onClick="windowopen(\'<cfoutput>#request.self#</cfoutput>?fuseaction=account.popup_netbook_status&type=0&unique_file_name='+unique_file+'\',\'small\')"><cf_get_lang dictionary_id='57541.Hata'> <cf_get_lang dictionary_id='57463.Sil'></a></td></tr>';
			right_menu_str +='</table>';
			document.getElementById('right_menu_div').innerHTML=right_menu_str;
			return false;
		}
		{
		   var menu_div = document.createElement('div');
		   menu_div.setAttribute('id', 'right_menu_div');
		   menu_div.style.position = 'absolute';
		   menu_div.style.visibility = 'hidden';
		   menu_div.style.width = '200px';
		   document.body.appendChild(menu_div);
		   right_menu(unique_file,status_code,defter_status,integration_document_id)
		   if (/MSIE (\d+\.\d+);/.test(navigator.userAgent)){
			 $('#right_menu_div').css('position','fixed')
		   }
		}
	}
</script>