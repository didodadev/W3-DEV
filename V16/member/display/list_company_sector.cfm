<cfparam name="field_name" default="">
<cfparam name="attributes.modal_id" default="">

<cfquery name="GET_UPPER_SECTOR" datasource="#DSN#">
	SELECT SECTOR_UPPER_ID,SECTOR_CAT,SECTOR_CAT_CODE FROM SETUP_SECTOR_CAT_UPPER ORDER BY SECTOR_CAT_CODE,SECTOR_CAT
</cfquery>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box id="box_counter" title="#getLang('sales','Sektor',57579)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),DE(1),DE(0))#">
		<cf_box_elements>
			<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
				<div class="form-group" id="item-process_stage">
					<label class="col col-4"><cf_get_lang dictionary_id='30278.Üst Sektörler'></label>
					<div class="col col-8">
						<select name="main_Sector" id="main_Sector" size="5" onchange="loadajaxsubcategory();">
							<cfoutput query="GET_UPPER_SECTOR">
								<option value="#SECTOR_UPPER_ID#">#IIf(len(SECTOR_CAT_CODE), DE(SECTOR_CAT_CODE), DE(""))# #SECTOR_CAT#</option>
							</cfoutput>
						</select>
					</div>
				</div>
				<div class="form-group" id="item-process_stage">
					<label class="col col-4"><cf_get_lang dictionary_id='30276.Alt Sektorler'></label>
					<div class="col col-8">
						<div id="subCompanySectorDiv">
							<select name="subCompanySector" id="subCompanySector" size="5"></select>
						</div>
					</div>
				</div>
			</div>
		</cf_box_elements>
		<cf_box_footer>
			<input type="button" name="" value="<cf_get_lang dictionary_id='57582.Ekle'>" onclick="addCompanyCategory();" />
		</cf_box_footer>
		<cf_box_elements>
			<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
				<div class="form-group" id="item-process_stage">
					<label class="col col-4"></label>
					<div class="col col-8">
						<select name="CompanySector" id="CompanySector" style="width:550px;height:100px;" size="5" multiple="multiple" ></select>
					</div>
				</div>
			</div>
		</cf_box_elements>
		<cf_box_footer>
			<input type="button" name="" value="<cf_get_lang dictionary_id='58743.Gönder'>" onclick="sendCompanyCategory();" />&nbsp;<input type="button" name="" value="<cf_get_lang dictionary_id='57463.Sil'>" onclick="removeCompanyCategory();" />
		</cf_box_footer>
	</cf_box>
</div>



<script language="javascript">
	function loadajaxsubcategory()	
	{
		var send_address = "<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#</cfoutput>.subSector&upSector=";
		send_address += document.getElementById('main_Sector').value;
		AjaxPageLoad(send_address,'subCompanySectorDiv',1,'Alt Sektörler');
	}
	function addCompanyCategory()
	{
		catMainIndex = document.getElementById('main_Sector').selectedIndex;
		catSubIndex = document.getElementById('subCompanySector').selectedIndex;

		if(catMainIndex >= 0 && catSubIndex >= 0)
		{
			cat_main_text = document.getElementById("main_Sector").options[catMainIndex].text;
			sector_main_code = parseInt(cat_main_text.match(/[0-9]+?\s/g));
			if (!isInt (sector_main_code ))
				sector_main_code = '';
			else
				cat_main_text = cat_main_text.replace(/[0-9]+?\s/g," ");
			cat_main_id = document.getElementById("main_Sector").options[catMainIndex].value;	
			for(k=0;k<document.getElementById('subCompanySector').length;++k)
			{	
				if(document.getElementById('subCompanySector').options[k].selected)
				{
					cat_sub_text = document.getElementById("subCompanySector").options[k].text;
					sector_code = parseInt(cat_sub_text.match(/[0-9]+?\s/g));
					if (!isInt (sector_code ))
						sector_code = '';
					else
						cat_sub_text = cat_sub_text.replace(/[0-9]+?\s/g," ");
					cat_sub_id = document.getElementById("subCompanySector").options[k].value;
				
					var kontrol =0;
					uzunluk=document.getElementById('CompanySector').length;
					for(i=0;i<uzunluk;i++){
						if(document.getElementById('CompanySector').options[i].value==cat_sub_id){
							kontrol=1;
						}
					}
					if(kontrol==0){
						x = document.getElementById('CompanySector').length;
						document.getElementById('CompanySector').length = parseInt(x + 1);
						document.getElementById('CompanySector').options[x].value = cat_sub_id;
						if (sector_main_code == '' && sector_code == '')
						document.getElementById('CompanySector').options[x].text = cat_main_text +' > '+  cat_sub_text;
						else if (sector_main_code != '' && sector_code == '')
						document.getElementById('CompanySector').options[x].text = sector_main_code + ' ' + cat_main_text + ' > '+  cat_sub_text;
						else if (sector_main_code == '' && sector_code != '')
						document.getElementById('CompanySector').options[x].text = sector_code + ' ' + cat_main_text + ' > '+  cat_sub_text;
						else
						document.getElementById('CompanySector').options[x].text = sector_main_code + '-' + sector_code + ' ' + cat_main_text +' > '+  cat_sub_text;
					}
				}
			}
		}
		else
		{
			alert("<cf_get_lang dictionary_id='30560.Sektor Seçiniz'> !");
			return false;
		}
	}
	function removeCompanyCategory()
	{
		for (i=document.getElementById('CompanySector').options.length-1;i>-1;i--)
		{
			if (document.getElementById('CompanySector').options[i].selected==true)
				document.getElementById('CompanySector').options.remove(i);
		}
	}
	function sendCompanyCategory()
	{
		if(document.getElementById('CompanySector').options.length<=0)	{
			alert("<cf_get_lang dictionary_id='30560.Sektor Seçiniz'> !");
			return false;
		}
		var m = document.getElementById('CompanySector').length;
		for(zzz=0;zzz<m;zzz++)
		{
			document.getElementById('CompanySector').options[zzz].selected==true;
			cat_text = document.getElementById("CompanySector").options[zzz].text;
			cat_id = document.getElementById("CompanySector").options[zzz].value;
			
			var kontrol = 0;
			<cfif  Len(field_name)>
				<cfoutput>
					uzunluk = <cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.getElementById('#field_name#').length;
					for(i=0;i<uzunluk;i++)
					{
						if(<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.getElementById('#field_name#').options[i].value==cat_id)
						{
							kontrol=1;
							break;
						}
					}

					x = <cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.getElementById('#field_name#').length;

					if(kontrol==0)
					{
						var opt = <cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.createElement('option');
							opt.value = cat_id;
							opt.text = cat_text;
						
						<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.getElementById('#field_name#').appendChild(opt);
				    }
						/*
						x = <cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.getElementById('#field_name#').length;
						<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.getElementById('#field_name#').length = parseInt(x + 1);
						<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.getElementById('#field_name#').options[x].value = cat_id;
						<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.getElementById('#field_name#').options[x].text = cat_text;*/
				</cfoutput>
			 <cfelse> 
					<cfoutput>
					 uzunluk = <cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.getElementById('product_category').length;
					for(l=0;l<uzunluk;l++){
						if(<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.getElementById('product_category').options[l].value==cat_id){
							kontrol=1;
						}
					}
					if(kontrol==0){
						x = <cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.getElementById('product_category').length;
						<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.getElementById('product_category').length = parseInt(x + 1);
						<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.getElementById('product_category').options[x].value = cat_id;
						<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.getElementById('product_category').options[x].text = cat_text;
					}
				</cfoutput>
			 </cfif>
		}
		<cfif not isdefined("attributes.draggable")>window.close();<cfelse>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );</cfif>
	}
	function isInt(n) 
	{
   		return ((typeof n ==='number')&&(n%1===0));
	}
</script>
