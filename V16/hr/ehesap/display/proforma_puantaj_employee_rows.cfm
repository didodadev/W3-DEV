<cfparam name="attributes.sort_type" default="1">
<cfparam name="attributes.sort_order" default="ASC">

<cfscript>
	get_days = createObject("component","V16.hr.ehesap.cfc.proforma_puantaj");
	get_days.dsn = dsn;
	get_days.ssk_office = attributes.ssk_office;
	get_days.sal_year = attributes.sal_year;
	get_days.sal_mon = attributes.sal_mon;
	get_days.sort_order = attributes.sort_order;
	get_days.sort_type = attributes.sort_type;
	
	get_emps = get_days.get_emps();
</cfscript>
<cfset p_baslangic = createodbcdatetime(createdatetime(attributes.sal_year,attributes.sal_mon,1))>
<cfset aydaki_gun_sayisi = daysinmonth(p_baslangic)>
<cfset p_bitis = createodbcdatetime(createdatetime(attributes.sal_year,attributes.sal_mon,aydaki_gun_sayisi))>


<cfif not get_emps.recordcount>
	<cfexit method="exittemplate">
</cfif>

<cfscript>
	get_offtime_cats = get_days.get_offtime_cats();
	get_offtimes = get_days.get_offtimes(employee_ids:'#valuelist(get_emps.EMPLOYEE_ID)#');
</cfscript>


<cfset cat_code_list = "">
<cfset cat_id_list = valuelist(get_offtime_cats.OFFTIMECAT_ID)>
<cfset cat_name_list = valuelist(get_offtime_cats.OFFTIMECAT)>
<cfset cat_u_list = valuelist(get_offtime_cats.UCRETLIMI)>
<cfoutput query="get_offtime_cats">	
	<cfif offtimecat_id lt 0>
		<cfset offtimecat_id_ = replace( offtimecat_id, "-","_", "all")>
	<cfelse>
		<cfset offtimecat_id_ = offtimecat_id>
	</cfif>
	<cfset 'total_#offtimecat_id_#' = 0>
	<cfset 'offtime_code_#offtimecat_id_#' = "">
	<cfif listlen(offtimecat,' ') eq 1>
		<cfset 'offtime_code_#offtimecat_id_#' = UCASETR(left(offtimecat,3))>
	<cfelse>
		<cfloop list="#offtimecat#" delimiters=" " index="c">
			<cfset d_ = ucasetr(left(c,1))>
			<cfset 'offtime_code_#offtimecat_id_#' = "#evaluate('offtime_code_#offtimecat_id_#')##d_#">
		</cfloop>
	</cfif>
	<cfset cat_code_list = listappend(cat_code_list,evaluate('offtime_code_#offtimecat_id_#'))>
</cfoutput>

<cfset offtime_emp_list = ''>
<cfoutput query="get_offtimes">
	<cfif not listfind(offtime_emp_list,employee_id)>
		<cfset offtime_emp_list = listappend(offtime_emp_list,employee_id)>
    </cfif>
    
	<cfif year(start_date) eq year(p_baslangic) and month(start_date) eq month(p_baslangic)>
		<cfset kisi_start = start_date>
	<cfelse>
		<cfset kisi_start = p_baslangic>
	</cfif>
	<cfif len(FINISH_DATE) and year(FINISH_DATE) eq year(p_bitis) and month(FINISH_DATE) eq month(p_bitis)>
		<cfset kisi_finish = FINISH_DATE>
	<cfelse>
		<cfset kisi_finish = p_bitis>
	</cfif>
	
	<cfif datediff('d',startdate,kisi_start) gt 0>
		<cfset izin_start = kisi_start>
	<cfelse>
		<cfset izin_start = startdate>
	</cfif>
    
    <cfif datediff('d',kisi_finish,finishdate) gt 0>
		<cfset izin_bitis = kisi_finish>
        <cfset izin_bitis = dateadd("h",hour(FINISHDATE),izin_bitis)>
	<cfelse>
		<cfset izin_bitis = FINISHDATE>
	</cfif>
    
    <cfif datediff('d',p_bitis,izin_bitis) gt 0>
    	<cfset izin_bitis = p_bitis>
        <cfset izin_bitis = dateadd('h',hour(FINISHDATE),izin_bitis)>
    </cfif>

	<cfset fark_ = datediff('d',izin_start,izin_bitis)>
    
    <cfif day(izin_start) eq 1 and (month(izin_start) neq month(izin_bitis) or day(izin_bitis) eq aydaki_gun_sayisi)>
    	<cfset fark_ = aydaki_gun_sayisi - 1>
    </cfif>
    
    <cfif fark_ gt aydaki_gun_sayisi>
    	<cfset fark_ = aydaki_gun_sayisi - 1>
    </cfif>

	<cfloop from="0" to="#fark_#" index="day_">
		<cfscript>
			temp_izin_gunu = date_add("d",day_,izin_start);
			daycode = '#dateformat(temp_izin_gunu,"ddmmyyyy")#';
		</cfscript>
		
		<cfif month(temp_izin_gunu) eq month(p_baslangic) and year(temp_izin_gunu) eq year(p_baslangic)>
        	<cfif not len(VALID)>
                <cfset 'kisi_izin_wait_#employee_id#_#daycode#' = 1>
            </cfif>
            
            <cfset 'kisi_izin_#employee_id#_#daycode#' = OFFTIMECAT_ID>
            <cfset 'kisi_izin_recorder_#employee_id#_#daycode#' = record_emp>
            <cfset 'kisi_izin_id_#employee_id#_#daycode#' = OFFTIME_ID>
            <cfif isdefined("kisi_total_#employee_id#_#offtimecat_id_#")>
                <cfset 'kisi_total_#employee_id#_#offtimecat_id_#' = evaluate("kisi_total_#employee_id#_#offtimecat_id_#") + 1>
            <cfelse>
                <cfset 'kisi_total_#employee_id#_#offtimecat_id_#' = 1>
            </cfif>
            
            <cfif UCRETLIMI eq 0>
                <cfif isdefined("kisi_ucretsiz_total_#employee_id#")>
                    <cfset 'kisi_ucretsiz_total_#employee_id#' = evaluate("kisi_ucretsiz_total_#employee_id#") + 1>
                <cfelse>
                    <cfset 'kisi_ucretsiz_total_#employee_id#' = 1>
                </cfif>
            </cfif>
            
            <cfset 'total_#offtimecat_id_#' = evaluate("total_#offtimecat_id_#") + 1>
       </cfif>
	</cfloop>    
</cfoutput>

<cfset gun_isimleri_kisa = "#getLang('','Pz','29698')#,#getLang('','Pz','29698')#,#getLang('','Pzt','57619')#,#getLang('','Sl','29700')#,#getLang('','Çrş','57621')#,#getLang('','Prş','57622')#,#getLang('','Cu','57623')#,#getLang('','Cmt','57624')#">
<cfsavecontent variable = "include_val">
	<cf_get_lang dictionary_id = "57529.Tanımlar">
</cfsavecontent>
<cf_seperator id="include_" title="#include_val#" is_closed="1">
<table id="include_">
	<tr>
		<td>
			<li style="float:left; padding-left:2px;"><cf_get_lang dictionary_id='64864.ARGE Vergi İstina Gün Sayısı'><b>(<cf_get_lang dictionary_id='64865.ARV'>)</b>&nbsp;&nbsp;</li>
			<li style="float:left; padding-left:2px;"><cf_get_lang dictionary_id='64866.ARGE SSK Gün Sayısı'><b>(<cf_get_lang dictionary_id='64867.AGS'>)</b>&nbsp;&nbsp;</li>
			<li style="float:left; padding-left:2px;"><cf_get_lang dictionary_id='64868.ARGE Zaman Harcaması'><b>(<cf_get_lang dictionary_id='64869.ARG'>)</b>&nbsp;&nbsp;</li>
			<cfoutput query="get_offtime_cats">
				<li style="float:left; padding-left:2px;">#offtimecat# <b>(#evaluate('offtime_code_#offtimecat_id_#')#)</b>&nbsp;&nbsp;</li>
			</cfoutput>
		</td>
	</tr>
	</table>
	<table>
	<tr>
		<td width="10"><div style="width:10px; height:10px; background-color:green"></div></td><td><cf_get_lang dictionary_id='46124.Kendi Kaydı'></td>
		<td width="10"><div style="width:10px; height:10px; background-color:blue"></div></td><td><cf_get_lang dictionary_id='64870.İK Kaydı'></td>
		<td width="10">?</td><td><cf_get_lang dictionary_id='31105.Onay Bekleyen İzinler'></td>
	</tr>
</table>
<cf_grid_list>
	<thead>
		<tr>
			<th style="width:20px;text-align:center;font-weight:bold;"><cf_get_lang dictionary_id='58577.Sıra'></th>
			<th style="text-align:center;font-weight:bold;"><cf_get_lang dictionary_id='58025.TC Kimlik No'></th>
			<th style="text-align:center;font-weight:bold;"><cf_get_lang dictionary_id='57570.Ad Soyad'></a></th>
			<th style="text-align:center;font-weight:bold;"><cf_get_lang dictionary_id='57571.Ünvan'></th>
			<th title="Çalışma Gün Sayısı" style="text-align:center;font-weight:bold;"><cf_get_lang dictionary_id='64871.ÇGS'></th>
			<th title="ARGE SSK Gün Sayısı" style="text-align:center;font-weight:bold;"nowrap="nowrap"><cf_get_lang dictionary_id='64867.AGS'></th>
			<th title="ARGE Vergi İstina Gün Sayısı" style="text-align:center; width:20px; color:black; font-weight:bold;" nowrap="nowrap" ><cf_get_lang dictionary_id='64872.AGV'></th>
			<th></th>
			<th nowrap="nowrap" style="text-align:center;font-weight:bold;"><cf_get_lang dictionary_id='58571.Mevcut'> <br /><cf_get_lang dictionary_id='55539.Çalışma Durumu'></th>
			<cfloop from="1" to="#aydaki_gun_sayisi#" index="gun_">
				<cfset temp_ = createodbcdatetime(createdate(year(p_baslangic),month(p_baslangic),gun_))>
				<cfoutput><th width="12" style="text-align:center; color:black; font-weight:bold;">#gun_# <br />#listgetat(gun_isimleri_kisa,dayofweek(temp_))#</th></cfoutput>
			</cfloop>
			<th width="2"></th>
			<cfif get_offtime_cats.recordcount>
				<cfoutput query="get_offtime_cats">
					<th style="width:20px; text-align:center; color:black; font-weight:bold;" nowrap="nowrap"><div class="rightcol">#evaluate('offtime_code_#offtimecat_id_#')#</div></th>
				</cfoutput>
			</cfif>
		</tr>
	</thead>
	<tbody>
	<cfset gun_toplam = 0>
	<cfoutput query="get_emps">
		<cfset employee_id_ = employee_id>
		<cfif year(start_date) eq year(p_baslangic) and month(start_date) eq month(p_baslangic)>
			<cfset kisi_start = createodbcdatetime(createdate(year(start_date),month(start_date),day(start_date)))>
			<cfset bu_ay_basladi = 1>
		<cfelse>
			<cfset kisi_start = p_baslangic>
			<cfset bu_ay_basladi = 0>
		</cfif>
		<cfif len(FINISH_DATE) and year(FINISH_DATE) eq year(p_bitis) and month(FINISH_DATE) eq month(p_bitis)>
            <cfset kisi_finish = createodbcdatetime(createdate(year(FINISH_DATE),month(FINISH_DATE),day(FINISH_DATE)))>
			<cfset bu_ay_cikti = 1>
		<cfelse>
			<cfset kisi_finish = p_bitis>
			<cfset bu_ay_cikti = 0>
		</cfif>
		<cfset calisma_gun_sayisi = datediff('d',kisi_start,kisi_finish)+1>
        
		<cfset reel_calisma_gun_sayisi = datediff('d',kisi_start,kisi_finish)+1>
		
		<cfif isdefined("kisi_ucretsiz_total_#employee_id#")>
			<cfset calisma_gun_sayisi = calisma_gun_sayisi - evaluate("kisi_ucretsiz_total_#employee_id#")>
		</cfif>
        
        <cfif isdefined("kisi_gun_ek_#employee_id#")>
        	<cfset calisma_gun_sayisi = calisma_gun_sayisi + evaluate("kisi_gun_ek_#employee_id#")>
        </cfif>
		
		<cfif calisma_gun_sayisi gt 30>
			<cfset calisma_gun_sayisi = 30>
		</cfif>
		<cfset gun_toplam = gun_toplam + calisma_gun_sayisi>
		
		<tr class="color-row">
			<cfset get_ags_agv = get_days.GET_AGS_AGV(
				sal_mon : attributes.sal_mon,
				sal_year : attributes.sal_year,
				emp_id : employee_id,
				ssk_office : attributes.ssk_office
			)>

			<td>#currentrow#</td>
			<td>
            <cfif listgetat(session.ep.user_level, 3)>
            	<a href="#request.self#?fuseaction=hr.list_hr&event=upd&employee_id=#employee_id#" target="hr_profil" class="tableyazi">#tc_identy_no#</a>
            <cfelse>
            	#tc_identy_no#
            </cfif> 
            </td>
			<td style="font-weight:bold;" nowrap="nowrap">
            	<cfset add_adress_ = "#request.self#?fuseaction=ehesap.offtimes&event=add&employee_id=#employee_id#&kalan_izin=0">
            	<a href="javascript://" style="color:<cfif bu_ay_basladi eq 1>green<cfelseif bu_ay_cikti eq 1>red<cfelseif reel_calisma_gun_sayisi lt aydaki_gun_sayisi>blue</cfif>;" onclick="windowopen('#add_adress_#','medium');" class="tableyazi">#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#</a>
            	<cfif DUTY_TYPE eq 6>(<cf_get_lang dictionary_id='55896.Kısmi İstihdam'>)</cfif>
                 <cfif SSK_STATUTE eq 2 or SSK_STATUTE eq 18>(<cf_get_lang dictionary_id='58541.Emekli'>)</cfif><!---Muzaffer Yeraltı Emeli--->
            </td>
			<td nowrap="nowrap">#POS_NAME#</td>
			<td style="text-align:center; font-weight:bold;color:<cfif bu_ay_basladi eq 1>green<cfelseif bu_ay_cikti eq 1>red<cfelseif reel_calisma_gun_sayisi lt aydaki_gun_sayisi>blue</cfif>;">#calisma_gun_sayisi#</td>
			<td nowrap="nowrap"><input type = "text" type = "boxtext" id = "ags_value#currentrow#" style = "width:30px;" value = "#get_ags_agv.RD_TIMECOST_DAY#" onblur="submit_ajax(#EMPLOYEE_ID#,#currentrow#,2)" onkeyup="return(FormatCurrency(this,event,2));" disabled></td>
			<td nowrap="nowrap"><input type = "text" type = "boxtext" id = "agv_value#currentrow#" style = "width:30px;" value = "#get_ags_agv.TAX_TIMECOST_DAY#" onblur="submit_ajax(#EMPLOYEE_ID#,#currentrow#,1)" onkeyup="return(FormatCurrency(this,event,2));" disabled></td>
			<td nowrap="nowrap"><a href="javascript://" onclick = "edit_agv_ags(#EMPLOYEE_ID#,#currentrow#);"> <i class = "fa fa-long-arrow-up"></i></a></td>
			<td style="font-weight:bold;color:<cfif bu_ay_basladi eq 1>green<cfelseif bu_ay_cikti eq 1>red<cfelseif reel_calisma_gun_sayisi lt aydaki_gun_sayisi>blue</cfif>;">
				<cfif bu_ay_basladi eq 1><cf_get_lang dictionary_id='57554.Giriş'><cfelseif bu_ay_cikti eq 1><cf_get_lang dictionary_id='57431.Çıkış'><cfelse><cf_get_lang dictionary_id='58126.Devam'></cfif>
			</td>
			<cfloop from="1" to="#aydaki_gun_sayisi#" index="gun">
				<cfset temp_ = createodbcdatetime(createdate(year(p_bitis),month(p_bitis),gun))>
                <td style="text-align:right; <cfif not (gun gte day(kisi_start) and gun lte day(kisi_finish))>background-color:##FFC;<cfelseif HAFTA_TATILI eq dayofweek(temp_)>background-color:##E9E9E9;</cfif>">
					<cfif gun gte day(kisi_start) and (gun lte day(kisi_finish) or month(kisi_finish) neq attributes.sal_mon)>
						<cfset daycode = '#dateformat(temp_,"ddmmyyyy")#'>
						<cfif isdefined('kisi_izin_#employee_id#_#daycode#')>
							<cfset deger_ = evaluate('kisi_izin_#employee_id#_#daycode#')>
                            <cfset deger_recorder = evaluate('kisi_izin_recorder_#employee_id#_#daycode#')>
								<cfset sira_ = listfind(cat_id_list,deger_)>
								<cfset ucretlimi = listgetat(cat_u_list,sira_)>
								<cfset izin_id_ = evaluate("kisi_izin_id_#employee_id#_#daycode#")>
								<cfset code_ = listgetat(cat_code_list,sira_)>
								<cfset add_ = "">
								<cfif isdefined("kisi_izin_wait_#employee_id#_#daycode#")>
									<cfset add_ = "?">
								</cfif>  
								<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=ehesap.offtimes&event=upd&is_view_agenda=1&x_event_catid=&offtime_id=#izin_id_#','medium');">
									<cfif deger_recorder eq employee_id_>
										<b style="color:green">
									<cfelse>
										<b style="color:blue">
									</cfif>
										#code_##add_#
									</b>
								</a>
						<cfelse>
							1
						</cfif>
					<cfelse>
						
					</cfif>
				</td>
			</cfloop>
			<td width="2"></td>
			<cfif get_offtime_cats.recordcount>
				<cfloop query="get_offtime_cats">
					<cfif offtimecat_id lt 0>
						<cfset offtimecat_id_2 = replace( get_offtime_cats.OFFTIMECAT_ID, "-","_", "all")>
					<cfelse>
						<cfset offtimecat_id_2 =  get_offtime_cats.OFFTIMECAT_ID>
					</cfif>
					<td style="text-align:center;" nowrap="nowrap">
						<cfif isdefined("kisi_total_#employee_id_#_#offtimecat_id_2#")>
							#evaluate("kisi_total_#employee_id_#_#offtimecat_id_2#")#
						</cfif>
					</td>
				</cfloop>
			</cfif>
		</tr>
	</cfoutput>
	</tbody>
	<tfoot>
	<cfoutput>
		<tr class="color-list">
			<td colspan="2" class="formbold" style="text-align:right;"><cf_get_lang dictionary_id='53263.Toplamlar'></td>
			<td style="text-align:center;" class="formbold">#get_emps.recordcount# <cf_get_lang dictionary_id='29831.Kişi'></td>
			<td style="text-align:center;">&nbsp;</td>
			<td style="text-align:center;" class="formbold">#gun_toplam#</td>
			<td style="text-align:center;">&nbsp;</td>
			<td colspan="#aydaki_gun_sayisi#" style="text-align:center;"></td>
			<td width="2"></td>
			<cfif get_offtime_cats.recordcount>
				<cfloop query="get_offtime_cats">
					<cfif offtimecat_id lt 0>
						<cfset offtimecat_id_3 = replace( get_offtime_cats.OFFTIMECAT_ID, "-","_", "all")>
					<cfelse>
						<cfset offtimecat_id_3 =  get_offtime_cats.OFFTIMECAT_ID>
					</cfif>
					<td style="text-align:center;" class="formbold">#evaluate("total_#offtimecat_id_3#")#</td>
				</cfloop>
			</cfif>
		</tr>
	</cfoutput>
    <tr>
		<td colspan="3" class="color-list"><div id="action_div_ext" style="font-weight:bold; color:blue;"></div></td>
		<td colspan="53" style="text-align:right; height:30px;" class="color-list">
		</td>
	</tr>
	</tfoot>
</cf_grid_list>
<script>
	function edit_agv_ags(emp_id,row_id){
		if(document.getElementById("agv_value"+row_id).disabled)
		{
			document.getElementById("agv_value"+row_id).disabled = false;
			document.getElementById("ags_value"+row_id).disabled = false;
		}else{
			document.getElementById("agv_value"+row_id).disabled = true;
			document.getElementById("ags_value"+row_id).disabled = true;
			
		}
	}
	function submit_ajax(emp_id,row_id,type){

		agv_value = document.getElementById("agv_value"+row_id).value;
		agv_value = filterNum(agv_value);
		ags_value = document.getElementById("ags_value"+row_id).value;
		ags_value = filterNum(ags_value);

		sal_mon = "<cfoutput>#attributes.sal_mon#</cfoutput>";
		sal_year = "<cfoutput>#attributes.sal_year#</cfoutput>";
		ssk_office = "<cfoutput>#attributes.ssk_office#</cfoutput>";
			$.ajax({ 
				type:'POST',  
				url:'V16/hr/ehesap/cfc/proforma_puantaj.cfc?method=UPD_AGS_AGV',  
				data: { 
					agv_value : agv_value,
					sal_mon : sal_mon,
					sal_year : sal_year,
					emp_id : emp_id,
					ssk_office : ssk_office,
					type : type,
					ags_value : ags_value
				},
				success: function (returnData) {
					console.log('success');
					return false;
				},
				error: function () 
				{
					console.log('CODE:8 please, try again..');
					return false; 
				}
			}); 
		
		
			
        return false; 
	}
</script>