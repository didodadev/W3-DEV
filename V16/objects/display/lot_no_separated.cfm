<cfparam name="attributes.modal_id" default="">
<cfsetting requesttimeout="3600">
<cfsetting showdebugoutput="no">
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
				alert("<cf_get_lang dictionary_id='47804.\php\,\jsp\,\asp\,\cfm\,\cfml\ Formatlarında Dosya Girmeyiniz!!'>");
					closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );
			</script>
			<cfabort>
		</cfif>
		<cfcatch>
			<script type="text/javascript">
				alert("<cf_get_lang dictionary_id ='57455.Dosyanız upload edilemedi ! Dosyanızı kontrol ediniz'> !");
					closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );
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
				closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );
		</script>
		<cfabort>
	</cfif>
<cfelseif isdefined("attributes.barcode_name") and len(attributes.barcode_name)>
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
</cfif>
<script type="text/javascript">
function add_row(lot_no,amount,seri_no)
{
	var newRow;
	var newCell;
	
	newRow = document.getElementById("table_1").insertRow(document.getElementById("table_1").rows.length);
	newRow.setAttribute("name","frm_row");
	newRow.setAttribute("NAME","frm_row");
		
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<input type="text" name="lot_no" value="'+lot_no+'" >';

	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<input type="text" name="barcode_count" value="'+amount+'" maxlength="2" class="moneybox" >';
	
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<input type="text" name="seri_no" value="'+seri_no+'" >';
	
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<a  title="<cf_get_lang dictionary_id='57582.57463'>" onclick="table_1.deleteRow(this.parentNode.parentNode.rowIndex)"><i class="fa fa-minus"></i></a>';
}

</script>
<cfquery name="GET_PRICE_CAT" datasource="#DSN3#">
	SELECT 
		* 
	FROM 
		PRICE_CAT
  <cfif isdefined("attributes.is_branch")>
	WHERE
		BRANCH LIKE '%,#listgetat(session.ep.user_location,2,"-")#,%'
  </cfif> 
	ORDER BY
		PRICE_CAT
</cfquery>
<cfif isdefined("attributes.is_branch")>
  	<cfparam name="attributes.price_catid" default="#get_price_cat.price_catid#">
<cfelse>
  	<cfparam name="attributes.price_catid" default="-2">
</cfif>
<div class="col col-12">
<cf_box title="#getLang('','Toplu Seri ve Lot No Yazdır',32819)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
		<cfform name="search_barcode" method="post" action="" enctype="multipart/form-data">
			<cf_box_elements>	
		<div class="form-group" id="item-folder">
			<label class="col col-4 col-md-4 col-xs-12"><cf_get_lang dictionary_id='57691.Dosya'></label>
		<div class="col col-8 col-md-8 col-xs-12">
			<cfinput type="file" name="barcode_file" id="barcode_file">
		</div><div class="col col-4 col-md-4 col-xs-12">
			<input type="button" class="ui-wrk-btn ui-wrk-btn-success" value="<cf_get_lang dictionary_id='63485'>" onclick='kontrol()'>
		</div>
		</div>
	</cf_box_elements>
	</cfform>
	<cfform name="print_barcode" method="post">
		<cf_box_elements>
			<div class="form-group" id="item-det">
				<label class="col col-4 col-md-4 col-xs-12"><cf_get_lang dictionary_id="58640.Şablon"> </label>
				<div class="col col-8 col-md-8 col-xs-12">
					<cfquery name="GET_DET_FORM" datasource="#DSN#">
						SELECT 
							SPF.TEMPLATE_FILE,
							SPF.FORM_ID,
							SPF.IS_DEFAULT,
							SPF.NAME,
							SPF.PROCESS_TYPE,
							SPF.MODULE_ID,
							SPFC.PRINT_NAME
						FROM 
							#dsn3_alias#.SETUP_PRINT_FILES SPF,
							SETUP_PRINT_FILES_CATS SPFC,
							MODULES MOD
						WHERE
							SPF.ACTIVE = 1 AND
							SPF.MODULE_ID = MOD.MODULE_ID AND
							SPFC.PRINT_TYPE = SPF.PROCESS_TYPE AND 
							SPFC.PRINT_TYPE = 192
						ORDER BY
							SPF.NAME
						</cfquery>
							<select name="form_type" id="form_type" >
								<option value=""><cf_get_lang dictionary_id='57792.Modül İçi Yazıcı Belgeleri'></option>
								<cfoutput query="GET_DET_FORM">
									<option value="#form_id#" <cfif (isdefined("attributes.form_type") and attributes.form_type eq form_id) or (not isdefined("attributes.form_type") and IS_DEFAULT eq 1)>selected</cfif>>#name# - #print_name#</option>
								</cfoutput>
							</select>
				</div>
			</div>
		<cf_grid_list  name="table_1" id="table_1">
			<thead><tr>
				<th width="90"><cf_get_lang dictionary_id='45498.Lot No'></th>
				<th width="40"><cf_get_lang dictionary_id='32879.Sayı'></th>
				<th width="150"><cf_get_lang dictionary_id='57637.Seri No'></th>
				<th width="15"><a title="<cf_get_lang dictionary_id='57582.Ekle'>" onClick="add_row('','1','');"><i class="fa fa-plus"></i></a></th>
			</tr></thead>
		</cf_grid_list>
	</cf_box_elements>
	<cf_box_footer>
		<input type="button" onClick="return gonder('2');" value="<cf_get_lang dictionary_id ='57474.Yazdır'>">
	</cf_box_footer>
	</cfform>
</cf_box>
</div>
<cfif (isdefined("attributes.barcode_file") and len(attributes.barcode_file)) or ( isdefined("attributes.barcode_name") and len(attributes.barcode_name))>
<cfif not isDefined("attributes.seperator_type")><cfset attributes.seperator_type = ";"></cfif>
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

	if(document.getElementById('barcode_file').value == '')
	{
		alert("<cf_get_lang dictionary_id='32871.Belge Seçiniz'>!");
		return false;
	}
	else{  
	<cfoutput>#iif(isdefined("attributes.draggable"),DE("loadPopupBox('search_barcode' , #attributes.modal_id#);"),DE(""))#</cfoutput>
}
}

function gonder(file_flag)
{
	if(file_flag == 2 && print_barcode.form_type.value.length=='')
	{
		alert("<cf_get_lang dictionary_id ='34185.Şablon Seçiniz'>!");
		return false;	
	}
		
	if(file_flag ==1)//kaydedilecekse buraya git
		print_barcode.action="<cfoutput>#request.self#?fuseaction=objects.emptypopup_save_collected_barcodes</cfoutput>";			
	else if(file_flag == 2)//yazdırılacaksa buraya
		{
		print_barcode.action="<cfoutput>#request.self#?fuseaction=objects.popup_print_files&print_type=192&template_id=</cfoutput>"+print_barcode.form_type.value+"";
		print_barcode.submit();
			return false;
	 	}
	else
		print_barcode.action="<cfoutput>#request.self#?fuseaction=objects.popup_print_files&print_type=192</cfoutput>";
	
	if(print_barcode.barcode==undefined) 
		return false;
	
	
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
			  	alert("<cf_get_lang dictionary_id='32881.Barkod Alanını Kontrol Ediniz'>! ")
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
</script>
