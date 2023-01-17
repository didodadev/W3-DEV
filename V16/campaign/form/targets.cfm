<cfset attributes.start_date = CreateDate(dateformat(now(),'YYYY'),1,1)>
<cfset attributes.finish_date= CreateDate(date_add('Y',1,dateformat(now(),'YYYY')),1,1)>
<cfinclude template="../query/get_campaign.cfm">
<cfquery name="get_target_cat" datasource="#dsn#">
	SELECT TARGETCAT_ID,TARGETCAT_NAME FROM TARGET_CAT
</cfquery>
<cfset camp_id_list = ValueList(CAMPAIGN.CAMP_ID,',')>
<cfquery name="get_target_select" datasource="#dsn#">
   SELECT 
        TARGETCAT_ID,
        TARGET_HEAD
    FROM
        TARGET 
    WHERE
        CAMP_ID IS NOT NULL
    GROUP BY TARGETCAT_ID,TARGET_HEAD
</cfquery>
<cfset pageHead = #getLang('campaign',369)#>
<cf_catalystHeader>
<cfsavecontent variable="option_target_values"><cfoutput query="get_target_cat"><option value="#TARGETCAT_ID#">#TARGETCAT_NAME#</option></cfoutput></cfsavecontent>
<cfsavecontent variable="calculation_type_values"><option value="1"> + (<cf_get_lang no ='364.Artis Hedefi'>)</option><option value="2">- (<cf_get_lang no ='365.Düsüs Hedefi'>)</option><option value="3">+% (<cf_get_lang no ='366.Yüzde Artis Hedefi'>)</option><option value="4"> -% (<cf_get_lang no ='367.Yüzde Düsüs Hedefi'>)</option><option value="5"> = (<cf_get_lang no ='368.Hedeflenen Rakam'>)</option></cfsavecontent>
	<div class="col col-12 col-md-12 col-sm-12 col-xs-12">	
		<cf_box>
			<cfform name="add_multiple_targets" method="post" action="#request.self#?fuseaction=campaign.emptypopup_add_multiple_targets">
				<cfinput type="hidden" name="record_num" value="#get_target_select.recordcount#"><cfinput type="hidden" name="camp_id_list" value="#camp_id_list#">        
				<cf_grid_list>
					<thead>
						<tr>
							<th width="15"><a href="javascript://" onclick="add_row();" title="<cf_get_lang dictionary_id='57582.Ekle'>"><i class="fa fa-plus"></i></a></th>
							<th><cf_get_lang_main no="74.Kategori">*</th>
							<th><cf_get_lang_main no="217.Açiklama"></th>
							<cfloop query="CAMPAIGN">
								<!--- Bu iki alani query sayfasinda seçilen querylerin baslangiç ve bitis tarihlerinin target tablosuna yazmak için tutuyoruz. --->
								<cfinput type="hidden" name="camp_startdate#CAMP_ID#" value="#CAMP_STARTDATE#">
								<cfinput type="hidden" name="camp_finishdate#CAMP_ID#" value="#CAMP_FINISHDATE#">
								<cfoutput><th nowrap="nowrap" class="txtbold" title="<cf_get_lang_main no='34.Kampanya'> :#CAMP_HEAD#">#left(CAMP_HEAD,25)#</th></cfoutput>
							</cfloop>
						</tr>
					</thead>
					<tbody id="table_1">
						<cfif get_target_select.recordcount>
							<cfoutput query="get_target_select">
								<tr id="frm_row#currentrow#">
									<td width="15"><input  type="hidden"  value="1"  name="row_kontrol#currentrow#" id="row_kontrol#currentrow#"><a href="javascript://" onclick="sil(#currentrow#);" title="<cf_get_lang dictionary_id='57463.sil'>"><i class="fa fa-minus"></i></a></td>
									<td>
										<div class="form-group">
											<div class="x-15">
												<select name="target_cats#currentrow#" id="target_cats#currentrow#" style="width:120px;">
													<option value="">Seçiniz</option>
													<cfloop query="get_target_cat">
														<option value="#TARGETCAT_ID#"<cfif get_target_select.TARGETCAT_ID eq TARGETCAT_ID>selected</cfif>>#TARGETCAT_NAME#</option>
													</cfloop>
												</select>                                        
											</div>
										</div>
									</td>
									<td nowrap="nowrap">
										<div class="form-group">
											<div class="x-15">
												<input type="text" name="detail#currentrow#" id="detail#currentrow#" value="#get_target_select.TARGET_HEAD#" style="width:120px;">
												</div>
										</div>
									</td>
									<cfquery name="get_target_in_camp" datasource="#dsn#"><!--- Yukarida gruplayarak aldigimiz kampanya kategorilerine ait verileri çekicez. --->
										SELECT CAMP_ID,TARGET_NUMBER,CALCULATION_TYPE FROM TARGET WHERE CAMP_ID IS NOT NULL AND TARGETCAT_ID=#TARGETCAT_ID#
									</cfquery>
									<cfloop query="get_target_in_camp">
										<cfscript>
											'target_number_#get_target_select.TARGETCAT_ID#_#CAMP_ID#' = TARGET_NUMBER;
											'calculation_type_#get_target_select.TARGETCAT_ID#_#CAMP_ID#' = CALCULATION_TYPE;
											</cfscript>
									</cfloop> 
									<cfloop query="CAMPAIGN">
										<td nowrap="nowrap">
											<div class="form-group">
												<div class="col col-12">
													<div class="input-group x-25">
														<input type="text" id="target_number_#CAMPAIGN.CAMP_ID#_#get_target_select.currentrow#" name="target_number_#CAMPAIGN.CAMP_ID#_#get_target_select.currentrow#" <cfif isdefined('target_number_#get_target_select.TARGETCAT_ID#_#CAMPAIGN.CAMP_ID#')> value="#filternum(tlformat(Evaluate('target_number_#get_target_select.TARGETCAT_ID#_#CAMPAIGN.CAMP_ID#')))#"</cfif> style="width:50px;" onkeyup="FormatCurrency(this,event);" />
														<span class="input-group-addon">
																<select name="calculation_type_#CAMPAIGN.CAMP_ID#_#get_target_select.currentrow#" id="calculation_type_#CAMPAIGN.CAMP_ID#_#get_target_select.currentrow#" style="width:142px">
																<option value="1" <cfif isdefined('calculation_type_#get_target_select.TARGETCAT_ID#_#CAMPAIGN.CAMP_ID#') and Evaluate('calculation_type_#get_target_select.TARGETCAT_ID#_#CAMPAIGN.CAMP_ID#') eq 1>selected</cfif>> + (<cf_get_lang no ='364.Artis Hedefi'>)</option>
																<option value="2" <cfif isdefined('calculation_type_#get_target_select.TARGETCAT_ID#_#CAMPAIGN.CAMP_ID#') and Evaluate('calculation_type_#get_target_select.TARGETCAT_ID#_#CAMPAIGN.CAMP_ID#') eq 2>selected</cfif>>- (<cf_get_lang no ='365.Düsüs Hedefi'>)</option>
																<option value="3" <cfif isdefined('calculation_type_#get_target_select.TARGETCAT_ID#_#CAMPAIGN.CAMP_ID#') and Evaluate('calculation_type_#get_target_select.TARGETCAT_ID#_#CAMPAIGN.CAMP_ID#') eq 3>selected</cfif>>+% (<cf_get_lang no ='366.Yüzde Artis Hedefi'>)</option>
																<option value="4" <cfif isdefined('calculation_type_#get_target_select.TARGETCAT_ID#_#CAMPAIGN.CAMP_ID#') and Evaluate('calculation_type_#get_target_select.TARGETCAT_ID#_#CAMPAIGN.CAMP_ID#') eq 4>selected</cfif>> -% (<cf_get_lang no ='367.Yüzde Düsüs Hedefi'>)</option>
																<option value="5" <cfif isdefined('calculation_type_#get_target_select.TARGETCAT_ID#_#CAMPAIGN.CAMP_ID#') and Evaluate('calculation_type_#get_target_select.TARGETCAT_ID#_#CAMPAIGN.CAMP_ID#') eq 5>selected</cfif>> = (<cf_get_lang no ='368.Hedeflenen Rakam'>)</option>
															</select>
														</span>
													</div>
												</div>
											</div>
										</td>												
									</cfloop>
								</tr>
							</cfoutput>
						</cfif>
					</tbody>
				</cf_grid_list>
				<cf_box_footer>
					<cf_workcube_buttons type_format='1' is_upd='0'  add_function='kontrol()'>
				</cf_box_footer>						
			</cfform>
		</cf_box>
	</div>
<cfoutput>   
<script type="text/javascript">
var row_count = #get_target_select.recordcount#;
function sil(sy){
	var my_element=eval("add_multiple_targets.row_kontrol"+sy);
	my_element.value=0;
	var my_element=eval("frm_row"+sy);
	my_element.style.display="none";
}
function add_row(){
		row_count++;
		var newRow;
		var newCell;
		newRow = document.getElementById("table_1").insertRow(document.getElementById("table_1").rows.length);	
		newRow.setAttribute("name","frm_row" + row_count);
		newRow.setAttribute("id","frm_row" + row_count);
		document.add_multiple_targets.record_num.value=row_count;
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input  type="hidden"  value="1"  id="row_kontrol'  + row_count +'"  name="row_kontrol'  + row_count +'" ><a href="javascript://" onclick="sil(' + row_count + ');"  title="<cf_get_lang dictionary_id='57463.sil'>"><i class="fa fa-minus"></i></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.style.width='120px';
		newCell.innerHTML = '<div class="form-group"><div class="x-15"><select name="target_cats'+row_count+'" id="target_cats'+row_count+'" style="width:120px;"><option value="">Seçiniz</option><cfoutput>#option_target_values#</cfoutput></select></div></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.style.width='120px';
		newCell.innerHTML = '<div class="form-group"><div class="x-15"><input type="text" name="detail'+row_count+'"></div></div>';
		<cfloop query="CAMPAIGN">
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.style.width='192px';
			newCell.setAttribute("nowrap","nowrap");
			newCell.innerHTML = '<div class="form-group"><div class="col col-12"><div class="input-group x-25"><input type="text" id="target_number" name="target_number_#CAMP_ID#_'+row_count+'" onkeyup="FormatCurrency(this,event);"><span class="input-group-addon"><select name="calculation_type_#CAMP_ID#_'+row_count+'" style="width:142px"><cfoutput>#calculation_type_values#</cfoutput></select></span></div></div></div>';
		</cfloop>
	}
function kontrol(){
	var campaign = <cfoutput>#CAMPAIGN.recordcount#</cfoutput>;
	if(campaign == 0)
	{
		alert("<cf_get_lang dictionary_id='60782.Tanımlı Kampanya Bulunmamaktadır.'>");
		return false;
	}
	var target_cats_select_list='0';

	for(i=1;i<=row_count;i++){
		if(document.getElementById('row_kontrol'+i).value == 1)
		{   //Satir Silinmemis ise!
			if(document.getElementById('target_cats'+i).value == '')
			{
				alert("<cf_get_lang_main no='782.Zorunlu Alan'> : <cf_get_lang_main no='74.Kategori'>");
				 return false;
			}
			if(list_find(target_cats_select_list,document.getElementById('target_cats'+i).value)==0)//kategori daha önce seçilmemis ise seçilen kategoriler listesine al.
				target_cats_select_list +=','+document.getElementById('target_cats'+i).value;
			else
			{
				alert("<cf_get_lang_main no='13.uyari'>:<cf_get_lang_main no='74.kategori'> <cf_get_lang no ='781.tekrari'>!");
				return false;
			}
		}
	}
	for(il=0;il<=document.getElementsByName('target_number').length-1;il++)
		document.getElementsByName('target_number')[il].value = filterNum(document.getElementsByName('target_number')[il].value);
}
</script>
</cfoutput>