<cfsetting requesttimeout="3600">
<cfsetting showdebugoutput="no">
<cf_xml_page_edit fuseact="objects.popup_collected_barcode">
	<cf_catalystHeader>
<cfif isdefined("attributes.barcode_file") and len(attributes.barcode_file)>
	<cfset CRLF = Chr(13) & Chr(10)>
	<cftry>
		<cfset file_name = createUUID()>
		<cffile action="upload" nameconflict="makeunique" filefield="barcode_file" destination="#upload_folder#objects">
		<cffile action="rename" source="#upload_folder#objects#dir_seperator##cffile.serverfile#" destination="#upload_folder#objects#dir_seperator##file_name#.#cffile.serverfileext#">
		<!---Script dosyalarını engelle  02092010 FA-ND --->
		<cfset assetTypeName = listlast(cffile.serverfile,'.')>
		<cfset blackList = 'php,php2,php3,php4,php5,phtml,pwml,inc,asp,aspx,ascx,jsp,cfm,cfml,cfc,pl,bat,exe,com,dll,vbs,reg,cgi,htaccess,asis'>
		<cfif listfind(blackList,assetTypeName,',')>
			<cffile action="delete" file="#upload_folder#objects#dir_seperator##file_name#.#cffile.serverfileext#">
			<script type="text/javascript">
				alert("\'php\',\'jsp\',\'asp\',\'cfm\',\'cfml\' Formatlarında Dosya Girmeyiniz!!");
				history.back();
			</script>
			<cfabort>
		</cfif>
		<cfcatch>
			<script type="text/javascript">
				alert("<cf_get_lang dictionary_id ='57455.Dosyanız upload edilemedi ! Dosyanızı kontrol ediniz'> !");
				history.back();
			</script>
			<cfabort>
		</cfcatch>
	</cftry>
	
	<cffile action="read" file="#upload_folder#objects#dir_seperator##file_name#.#cffile.serverfileext#" variable="dosya">
	<cfscript>
		CRLF1 = Chr(13) & Chr(10);
		dosya1 = ListToArray(dosya,CRLF1);
		line_count = ArrayLen(dosya1);
	</cfscript>	
	<cffile action="delete" file="#upload_folder#objects#dir_seperator##file_name#.#cffile.serverfileext#">
	<cfif line_count gt 500>
		<script type="text/javascript">
			alert('<cf_get_lang dictionary_id ="60021.Dosyadan Gelen Barkod Sayısı"> : ' + <cfoutput>#line_count#</cfoutput> + '\n<cf_get_lang dictionary_id ="34184.500 den Fazla Barkod Aynı Anda Yazdırılamaz"> !');
			history.go(-1);
		</script>
		<cfabort>
	</cfif>
<cfelseif isdefined("attributes.barcode_name") and len(attributes.barcode_name)>
	<cftry>
		<cfset CRLF = Chr(13) & Chr(10)>
		<cffile action="read" file="#upload_folder#pda\label_print\#attributes.barcode_name#" variable="dosya">
		<cfscript>
			CRLF1 = Chr(13) & Chr(10);
			dosya1 = ListToArray(dosya,CRLF1);
			line_count = ArrayLen(dosya1);
		</cfscript>	
		<cfif line_count gt 500>
			<script type="text/javascript">
				alert('<cf_get_lang dictionary_id ="60021.Dosyadan Gelen Barkod Sayısı"> : ' + <cfoutput>#line_count#</cfoutput> + '\n<cf_get_lang dictionary_id ="34184.500 den Fazla Barkod Aynı Anda Yazdırılamaz"> !');
				history.go(-1);
			</script>
			<cfabort>
		</cfif>
		<cfcatch>
			<script type="text/javascript">
				alert("<cf_get_lang dictionary_id ='57455.Dosyanız upload edilemedi ! Dosyanızı kontrol ediniz'> !");
				history.back();
			</script>
			<cfabort>
		</cfcatch>
	</cftry>
</cfif>
<script type="text/javascript">
function add_row(barcode,amount,name)
{
	var newRow;
	var newCell;
	
	newRow = document.getElementById("table_1").insertRow(document.getElementById("table_1").rows.length);
	newRow.setAttribute("name","frm_row");
	newRow.setAttribute("NAME","frm_row");
	
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<a title="<cf_get_lang dictionary_id='57463.Sil'>" style="cursor:pointer" class="eklebutton" onclick="table_1.deleteRow(this.parentNode.parentNode.rowIndex-1)"><i class="fa fa-minus"></i></a>';
	
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<input type="text" name="barcode" id="barcode" class="barcode" value="'+barcode+'" style="width:120px;">';

	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<input type="text" name="barcode_count" class="barcode_count" value="'+amount+'" maxlength="2" class="moneybox" style="width:40px;">';
	
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<input type="text" name="name" value="'+name+'" style="width:150px;">';
	
}
</script>
<cfquery name="GET_PRICE_CAT" datasource="#DSN3#">
	SELECT 
		PRICE_CATID,
		PRICE_CAT
	FROM 
		PRICE_CAT
  <cfif isdefined("attributes.is_branch")>
	WHERE
		BRANCH LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#listgetat(session.ep.user_location,2,'-')#,%">
  </cfif> 
	ORDER BY
		PRICE_CAT
</cfquery>
<cfif isdefined("attributes.is_branch")>
  	<cfparam name="attributes.price_catid" default="#get_price_cat.price_catid#">
<cfelse>
  	<cfparam name="attributes.price_catid" default="-2">
</cfif>
<cfset getPrintTemplate = createObject("component","cfc.get_print_template")>
<cfset get_templates = getPrintTemplate.get_templates( action : attributes.fuseaction )>

	<cfform name="search_barcode" method="post" action="" enctype="multipart/form-data">
		<cf_box title="#getlang('','Etiket listesi oluşturmak İçin dosya yüklemeli veya ürün seçmelisiniz','63512')#." collapsable="0" resize="0">
			<cf_box_search>
				<div class="form-group" id="item-csv_name">
					<cf_get_lang dictionary_id ='63511.Csv Etiket Dosyası'>
				</div>
			<div class="form-group large" id="item-folder">
				<cfinput type="file" id="barcode_file" name="barcode_file" style="width:165px;height:19px;">
			</div>
		<cfif x_is_view_pda_files eq 1>
			<div class="form-group" id="item-barcode_name">
				<input type="text" placeholder="Pda barkod ismi" name="barcode_name" id="barcode_name" value="" style="width:110px;">
			</div>
			<div class="form-group small" id="item-pda">
				<input type="button" class="ui-wrk-btn-extra" name="popup_direct" id="popup_direct" value="PDA" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_barcode_pda_info&barcode_name='+search_barcode.barcode_name.value+'');">
			</div>
	</cfif>
	<div class="form-group" id="item-seperator">
		<cf_get_lang dictionary_id="63517.Kolon Ayracı">
	</div>
		<div class="form-group" id="item-comma">
			<select name="seperator_type" id="seperator_type">
				<option value="," <cfif isdefined("attributes.seperator_type") and attributes.seperator_type is ','>selected</cfif>><cf_get_lang dictionary_id='32873.Virgül'> (,) </option>
				<option value=";" <cfif isdefined("attributes.seperator_type") and attributes.seperator_type is ';'>selected</cfif>><cf_get_lang dictionary_id='32874.Noktalı Virgül'> (;) </option>
			</select>
			</div>
		<div class="form-group" id="item-run">
			<button class="ui-wrk-btn ui-wrk-btn-success" onclick='kontrol(); return false; '><i class="fa fa-download"></i> <cf_get_lang dictionary_id ='63513.Dosya İle Etiket Listesi Oluştur'> </button>
		</div>
		<div class="form-group" id="item-extra">
			<button class="ui-wrk-btn ui-wrk-btn-extra" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_barcod_search2</cfoutput>'); return false; "><i class="fa fa-barcode"></i> <cf_get_lang dictionary_id ='63514.Etiket Listesine Manuel Ürün Ekle'> </button>
		</div>
</cf_box_search>
</cf_box>
	</cfform>
    <cfform name="print_barcode" method="post" action="" is_blank="1">
		<cf_box title="#getLang('','Etiket Listesi',64005)#" collapsable="0" resize="0">
			<div class="col col-6">
		<cf_grid_list>
        	<thead>  
            	<tr>
                	<th width="15"><a title="<cf_get_lang dictionary_id='57582.Ekle'>" onClick="add_row('','1','');"><i class="fa fa-plus"></i></a></th>
                    <th width="120"><cf_get_lang dictionary_id='57633.Barkod'>/<cf_get_lang dictionary_id='57518.Stok Kodu'></th>
                    <th width="40"><cf_get_lang dictionary_id='32879.Sayı'></th>
                    <th width="150"><cf_get_lang dictionary_id='58221.Ürün Adı'></th>
                </tr>
            </thead>
            <tbody name="table_1" id="table_1"></tbody>
        </cf_grid_list>
	</div>
	</cf_box>
		<cfif isdefined("attributes.startdate") and len(attributes.startdate)>
			<cfset bas_gun = dateformat(attributes.startdate,dateformat_style)>
			<cfset bas_saat = timeformat(attributes.startdate,"HH")>
			<cfset bas_dk = timeformat(attributes.startdate,"MM")>
			<cfelse>
			<cfset bas_gun = "">
			<cfset bas_saat = "">
			<cfset bas_dk = "">
		</cfif>
		<cfif isdefined("attributes.finishdate") and len(attributes.finishdate)>
			<cfset son_gun = dateformat(attributes.finishdate,dateformat_style)>
			<cfset son_saat = timeformat(attributes.finishdate,"HH")>
			<cfset son_dk = timeformat(attributes.finishdate,"MM")>
		<cfelse>
			<cfset son_gun = "">
			<cfset son_saat = "">
			<cfset son_dk = "">
		</cfif>
		<cfif isdefined("attributes.recorddate") and len(attributes.recorddate)>
			<cfset kayit_gun = dateformat(attributes.recorddate,dateformat_style)>
			<cfset kayit_saat = timeformat(attributes.recorddate,"HH")>
			<cfset kayit_dk = timeformat(attributes.recorddate,"MM")>
		<cfelse>
			<cfset kayit_gun = "">
			<cfset kayit_saat = "">
			<cfset kayit_dk = "">
		</cfif>
  <cf_box>
	<cf_box_search>
		<div class="form-group" id="item-price_name">
			<cf_get_lang dictionary_id='58964.Fiyat Listesi'>
		</div>
		<div class="form-group" id="item-price">
				<select name="price_catid" id="price_catid" style="width:200px;">
					<option value="-2"><cf_get_lang dictionary_id='58721.Standart Satış'></option>
					<cfoutput query="get_price_cat"> 
						<option value="#price_catid#" <cfif (price_catid eq attributes.price_catid)>selected</cfif>>#price_cat#</option>
					</cfoutput>
				</select>
		</div>
		<div class="form-group" id="item-start">
			<cf_get_lang dictionary_id='37628.Fiyat Başlama Tarihi'>
		</div>
		<div class="form-group" id="item-start_date">
			<cfsavecontent variable="message"><cf_get_lang dictionary_id='30122.Başlangıç Tarihini Kontrol Ediniz'></cfsavecontent>
				<div class="input-group">
                <cfinput type="text" name="startdate" value="#bas_gun#" maxlength="10" message="#message#" style="width:70px;">
				<span class="input-group-addon"><cf_wrk_date_image date_field="startdate"></span></div>
			</div><div class="form-group" id="item-start_hour">
                <select name="start_hour" id="start_hour">
                    <cfloop from="0" to="23" index="i">
                        <cfif len(i) eq 1>
                            <cfset i = "0#i#">
                        </cfif>
                        <cfoutput>
                            <option value="#i#"<cfif bas_saat is i> selected</cfif>>#i#</option>
                        </cfoutput>
                    </cfloop>
                </select>
			</div><div class="form-group" id="item-start_min">
                <select name="start_min" id="start_min">
                    <option value="00">00</option>
                    <cfloop from="5" to="55" index="i" step="5">
                        <cfoutput>
                            <option value="#i#"<cfif bas_dk is i> selected</cfif>>#i#</option>
                        </cfoutput>
                    </cfloop>
                </select>
		</div>
			<div class="form-group" id="item-finish_name">
				<cf_get_lang dictionary_id='37629.Fiyat Bitiş Tarihi'>
			</div>
			<div class="form-group" id="item-finish">
                <cfsavecontent variable="message"><cf_get_lang dictionary_id ='30123.Bitiş Tarihini Kontrol Ediniz'></cfsavecontent>
					<div class="input-group">
					<cfinput type="text" name="finishdate" value="#son_gun#" maxlength="10" message="#message#" style="width:70px;">
                    <span class="input-group-addon"><cf_wrk_date_image date_field="finishdate"></span></div>
					</div><div class="form-group" id="item-finish_hour">
                    <select name="finish_hour" id="finish_hour">
                        <cfloop from="0" to="23" index="i">
                            <cfif len(i) eq 1>
                                <cfset i = "0#i#">
                            </cfif>
                            <cfoutput>
                                <option value="#i#"<cfif son_saat is i> selected</cfif>>#i#</option>
                            </cfoutput>
                        </cfloop>
                    </select>
				</div><div class="form-group" id="item-finish_min">
                    <select name="finish_min" id="finish_min">
                        <option value="00">00</option>
                        <cfloop from="5" to="55" index="i" step="5">
                            <cfoutput>
                                <option value="#i#"<cfif son_dk is i> selected</cfif>>#i#</option>
                            </cfoutput>
                        </cfloop>
                    </select>
				</div>
			</cf_box_search>
		<cf_box_search>
			<div class="form-group" id="item-record_name">
				<cf_get_lang dictionary_id='57627.Kayıt Tarihi'>
				</div>
				<div class="form-group" id="item-record_date">
				   <cfsavecontent variable="message"><cf_get_lang dictionary_id='32877.Kayıt Tarihini Kontrol Ediniz'></cfsavecontent>
					<div class="input-group">
					<cfinput type="text" name="recorddate" value="#kayit_gun#" maxlength="10" message="#message#" style="width:97px;">
					<span class="input-group-addon"><cf_wrk_date_image date_field="recorddate"></span></div>
					</div><div class="form-group" id="item-record_hour">
					<select name="kayit_hour" id="kayit_hour">
						<cfloop from="0" to="23" index="i">
							<cfif len(i) eq 1>
								<cfset i = "0#i#">
							</cfif>
							<cfoutput>
								<option value="#i#"<cfif kayit_saat is i> selected</cfif>>#i#</option>
							</cfoutput>
						</cfloop>
					</select>
				</div><div class="form-group" id="item-record_min">
					<select name="kayit_min" id="kayit_min">
						<option value="00">00</option>
						<cfloop from="5" to="55" index="i" step="5">
							<cfoutput>
								<option value="#i#"<cfif kayit_dk is i> selected</cfif>>#i#</option>
							</cfoutput>
						</cfloop>
					</select>
				</div>
				<div class="form-group" id="item-print">
				<button class=" ui-wrk-btn ui-wrk-btn-red" onClick="return gonder('2');"><i class="fa fa-print"></i> <cf_get_lang dictionary_id ="63515.WOC'a Gönder"> </button>
				</div><div class="form-group" id="item-download">
				<button class="ui-wrk-btn ui-wrk-btn-extra" onClick="return gonder('1');"><i class="fa fa-download"></i> <cf_get_lang dictionary_id ="63516.Dosya Olarak İndir"> </button>
				</div>
		</cf_box_search>
    </cfform>

<cfif (isdefined("attributes.barcode_file") and len(attributes.barcode_file)) or ( isdefined("attributes.barcode_name") and len(attributes.barcode_name))>
<!--- barcode_file gozat ile gelenleri, barcode_name pda ile gelenleri ifade eder FB --->
	<script type="text/javascript">
		<cfloop list="#dosya#" index="i" delimiters="#CRLF#">
			<cfif listlen(i,'#attributes.seperator_type#') eq 2>
				<cfif isnumeric(listgetat(i,2,'#attributes.seperator_type#'))>
					<cfoutput>add_row('#trim(listfirst(i,'#attributes.seperator_type#'))#','#trim(listgetat(i,2,'#attributes.seperator_type#'))#','');</cfoutput>
				</cfif>
			<cfelseif listlen(i,'#attributes.seperator_type#') eq 3>
				<cfif isnumeric(listgetat(i,2,'#attributes.seperator_type#'))>
					<cfoutput>add_row('#listfirst(i,'#attributes.seperator_type#')#','#listgetat(i,2,'#attributes.seperator_type#')#','#listgetat(i,3,'#attributes.seperator_type#')#');</cfoutput>
				</cfif>
			</cfif>
		</cfloop>
	</script>
<cfelseif isdefined("from_genius_barcode_file")>
	<cftry>
		<cfset CRLF = Chr(13) & Chr(10)>
		<cffile action="read" file="#from_genius_barcode_file#" variable="dosya">
		<cffile action="delete" file="#from_genius_barcode_file#">
		<script type="text/javascript">
		<cfloop list="#dosya#" index="i" delimiters="#CRLF#">
			<cfif isnumeric(listgetat(i,2,','))>
				<cfoutput>add_row('#trim(listfirst(i))#','#trim(listgetat(i,2,','))#','#trim(listgetat(i,3,','))#');</cfoutput>
			</cfif>
		</cfloop>
		</script>
		<cfcatch>
			<script type="text/javascript">
				alert("<cf_get_lang dictionary_id='32880.Dosya İçeriğinde Sorun Oluştu! Lütfen Dosyanızı Kontrol Ediniz'>");
				history.back();
			</script>
			<cfabort>
		</cfcatch>
	</cftry>
<cfelseif isdefined("from_inter_barcode_file")><!--- MPOS icin --->
	<cftry>
		<cfset CRLF = Chr(13) & Chr(10)>
		<cffile action="read" file="#from_inter_barcode_file#" variable="dosya">
		<script type="text/javascript">
		<cfloop list="#dosya#" index="i" delimiters="#CRLF#">
				<cfoutput>add_row('#trim(Mid(i,4,13))#','1','#trim(Mid(i,37,20))#');</cfoutput>
		</cfloop>
		</script>
		<cfcatch>
			<script type="text/javascript">
				alert("<cf_get_lang dictionary_id='32880.Dosya İçeriğinde Sorun Oluştu! Lütfen Dosyanızı Kontrol Ediniz'>");
				history.back();
			</script>
			<cfabort>
		</cfcatch>
	</cftry>
<cfelseif isdefined("from_ncr_barcode_file")><!--- ncr için --->
	<cftry>
		<cfset CRLF = Chr(13) & Chr(10)>
		<cffile action="read" file="#from_ncr_barcode_file#" variable="dosya">
		<script type="text/javascript">
		<cfloop list="#dosya#" index="i" delimiters="#CRLF#">
				<cfoutput>add_row('#trim(Mid(i,4,13))#','1','#trim(Mid(i,37,20))#');</cfoutput>
		</cfloop>
		</script>
		<cfcatch>
			<script type="text/javascript">
				alert("<cf_get_lang dictionary_id='32880.Dosya İçeriğinde Sorun Oluştu! Lütfen Dosyanızı Kontrol Ediniz'>");
				history.back();
			</script>
			<cfabort>
		</cfcatch>
	</cftry>
</cfif>

<script type="text/javascript">
function kontrol()
{

	if(document.search_barcode.barcode_file.value == '' <cfif x_is_view_pda_files eq 1>&& document.search_barcode.barcode_name.value == ''</cfif>)
	{
		alert("<cf_get_lang dictionary_id='32871.Belge Seçiniz'>!");
			return false;
	}
	else
	{
		search_barcode.submit();
		return true;
	}
}

function gonder(file_flag)
{
	if(!CheckEurodate(document.print_barcode.startdate.value,"<cf_get_lang dictionary_id ='58053.Başlangıç Tarihi'>"))
		return false;
	if(!CheckEurodate(document.print_barcode.finishdate.value,"<cf_get_lang dictionary_id ='57700.Bitiş Tarihi'>"))
		return false;
	if(!CheckEurodate(document.print_barcode.recorddate.value,"<cf_get_lang dictionary_id ='57627.Kayıt Tarihi'>"))
		return false;
	
	
	if(file_flag ==1)//kaydedilecekse buraya git
		{print_barcode.action="<cfoutput>#request.self#?fuseaction=objects.emptypopup_save_collected_barcodes</cfoutput>";	}		
	else if(file_flag == 2)//yazdırılacaksa buraya
	{
		barcode=barcode();
		barcode_count=count();
		print_barcode.action="<cfoutput>#request.self#?fuseaction=objects.popup_print_files&action=objects.collected_barcode</cfoutput>&barcode=" +barcode+"&barcode_count="+barcode_count ;
	}else
	{
		print_barcode.action="<cfoutput>#request.self#?fuseaction=objects.popupflush_print_collected_barcodes</cfoutput>";
	}
	if(print_barcode.barcode==undefined) 
	{
		alert("<cf_get_lang dictionary_id='32881.Barkod Alanını Kontrol Ediniz'>! ");
		return false;
	}
	
	if ((print_barcode.barcode_count.length != undefined) && (print_barcode.barcode_count.length > 500))
	{
		if(file_flag ==1)
			if(confirm('<cf_get_lang dictionary_id ="34186.Yazdırmaya Çalıştığınız Barkod Sayısı"> : ' + print_barcode.barcode_count.length + '\n<cf_get_lang dictionary_id ="34184.500 den Fazla Barkod Aynı Anda Yazdırılamaz"> ! \n<cf_get_lang dictionary_id ="34187.Dosyanızı 500 Satır Olacak Şekilde Bölmeniz Gerekiyor"> !')); else return false;
		else
		{		
			alert('<cf_get_lang dictionary_id ="34186.Yazdırmaya Çalıştığınız Barkod Sayısı"> : ' + print_barcode.barcode_count.length + '\n\n<cf_get_lang dictionary_id ="34184.500 den Fazla Barkod Aynı Anda Yazdırılamaz">!');
			return false;
		}
	}

	if (print_barcode.barcode.length != undefined) /* n tane*/
	{
		for (i=0; i < print_barcode.barcode.length; i++)
		{
			//if(print_barcode.barcode[i].value != parseFloat(print_barcode.barcode[i].value)) print_barcode.barcode[i].value = '';
			if(!(print_barcode.barcode[i].value.length>0))
			{
			  	alert("<cf_get_lang dictionary_id='32881.Barkod Alanını Kontrol Ediniz'>! ");
			 	return false;
			}								
		}
	}
	else /* 1 tane*/
	{			
		//burası sadece barkoada göre çalıştığı için kaldırdım artık stok koda görede çalışıcak.
		//if (print_barcode.barcode.value != parseFloat(print_barcode.barcode.value)) print_barcode.barcode.value = '';
		if(!(print_barcode.barcode.value.length>0))
		{
			alert("<cf_get_lang dictionary_id='32881.Barkod Alanını Kontrol Ediniz'>! ")
			return false;
		}					
	}		
	
	if (print_barcode.barcode_count.length != undefined) /* n tane*/
	{
		for (i=0; i < print_barcode.barcode_count.length; i++)
		{
		if(print_barcode.barcode_count[i].value != parseFloat(print_barcode.barcode_count[i].value)) print_barcode.barcode_count[i].value = '';
		if(!(print_barcode.barcode_count[i].value>0))
		{
			alert("<cf_get_lang dictionary_id='32882.Barkod Yazdırma Sayısını Kontrol Ediniz!'> ")
			return false;
			}					
		}
	}
	else /* 1 tane*/
	{
		if(print_barcode.barcode_count.value != parseInt(print_barcode.barcode_count.value)) print_barcode.barcode_count.value = '';
		if(!(print_barcode.barcode_count.value>0))
		{
			alert("<cf_get_lang dictionary_id='32882.Barkod Yazdırma Sayısını Kontrol Ediniz!'> ")
			return false;
		}	
	}		
	print_barcode.submit();
	return false;
}	
function barcode(){
	barcode='';
	var barcode_val= $(".barcode");
	for (i=0; i < barcode_val.length; i++)
		{
		barcode+=barcode_val[i].value;
		if(i!=(barcode_val.length-1)){barcode+=","}
		}	
		return barcode;
}
function count(){
	barcode_count='';
	var count_= $(".barcode_count");
	for (i=0; i < count_.length; i++)
		{
			barcode_count+=count_[i].value;
		if(i!=(count_.length-1)){barcode_count+=","}
		}	
		return barcode_count;
}
</script>
