<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.months" default="">
<cfparam name="attributes.years" default="">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.form_submitted" default="">
<cfquery name="GET_BRANCH" datasource="#DSN#">
	SELECT BRANCH_ID,BRANCH_NAME FROM BRANCH ORDER BY BRANCH_NAME
</cfquery>
<cfif len(attributes.form_submitted)>
	<cfquery name="GET_SHIP" datasource="#DSN#">
		SELECT
			ASSET_P_SHIP_ANALYSIS.SHIP_ID,
			ASSET_P_SHIP_ANALYSIS.SHIP_DATE,
			BRANCH.BRANCH_NAME,
			ASSET_P_SHIP_ANALYSIS.SHIP_NUM,
			ASSET_P_SHIP_ANALYSIS.SHIP_AREA,
			ASSET_P_SHIP_ANALYSIS.DISTANCE,
			ASSET_P_SHIP_ANALYSIS.STORE_QUANTITY,
			ASSET_P_SHIP_ANALYSIS.TOUR_NUMBER,
			ASSET_P_SHIP_ANALYSIS.ENDORSEMENT,
			ASSET_P_SHIP_ANALYSIS.CURRENCY,
			ASSET_P_SHIP_ANALYSIS.SPECIAL_CODE,
			ASSET_P_SHIP_ANALYSIS.DAYS
		FROM
			ASSET_P_SHIP_ANALYSIS,
			BRANCH
		WHERE
			ASSET_P_SHIP_ANALYSIS.SHIP_ID IS NOT NULL AND
			<!--- Sadece yetkili olunan şubeler gözüksün. Onur P. --->
			ASSET_P_SHIP_ANALYSIS.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#)												
			<cfif len(attributes.branch_id)>AND ASSET_P_SHIP_ANALYSIS.BRANCH_ID = #attributes.branch_id#</cfif>
			<cfif len(attributes.months) and len(attributes.years)>
			AND ASSET_P_SHIP_ANALYSIS.SHIP_DATE = #CreateODBCDateTime('#attributes.months# - 01 - #attributes.years#')#
			</cfif>
			<cfif len(attributes.keyword) and isNumeric(attributes.keyword)>AND ASSET_P_SHIP_ANALYSIS.SHIP_NUM = #attributes.keyword#</cfif>
			<cfif len(attributes.keyword) and not isNumeric(attributes.keyword)>AND ASSET_P_SHIP_ANALYSIS.SHIP_AREA LIKE  '%#attributes.keyword#%'</cfif>
			AND BRANCH.BRANCH_ID = ASSET_P_SHIP_ANALYSIS.BRANCH_ID
	</cfquery>
		<cfparam name="attributes.totalrecords" default='#get_ship.recordcount#'>
	<cfelse>
		<cfparam name="attributes.totalrecords" default='0'>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
		<cfform name="search_ship" method="post" action="#request.self#?fuseaction=assetcare.list_ship_analysis">
			<cfsavecontent variable="messageb"><cf_get_lang dictionary_id="57460.Filtre"></cfsavecontent>	
			<cf_box_search>
				<div class="form-group" id="form_submitted">
					<input type="hidden" name="form_submitted" id="form_submitted" value="1">
					<cfinput type="text" name="keyword" value="#attributes.keyword#" maxlength="50" placeholder="#messageb#">
				</div>
				<cfsavecontent variable="messagebb"><cf_get_lang dictionary_id="57453.Şube"></cfsavecontent>
				<div class="form-group" id="branch_id">				
					<div class="input-group">
						<input type="hidden" name="branch_id" id="branch_id" value=""> 
						<cfinput name="branch" id="branch" placeholder="#messagebb#">
						<span class="input-group-addon icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_branches&field_branch_id=search_ship.branch_id&field_branch_name=search_ship.branch','list');"></span>
					</div>
				</div>
				<div class="form-group" id="months">				
					<cfsavecontent variable="ay1"><cf_get_lang dictionary_id='57592.Ocak'></cfsavecontent>
					<cfsavecontent variable="ay2"><cf_get_lang dictionary_id='57593.Şubat'></cfsavecontent>
					<cfsavecontent variable="ay3"><cf_get_lang dictionary_id='57594.Mart'></cfsavecontent>
					<cfsavecontent variable="ay4"><cf_get_lang dictionary_id='57595.Nisan'></cfsavecontent>
					<cfsavecontent variable="ay5"><cf_get_lang dictionary_id='57596.Mayıs'></cfsavecontent>
					<cfsavecontent variable="ay6"><cf_get_lang dictionary_id='57597.Haziran'></cfsavecontent>
					<cfsavecontent variable="ay7"><cf_get_lang dictionary_id='57598.Temmuz'></cfsavecontent>
					<cfsavecontent variable="ay8"><cf_get_lang dictionary_id='57599.Ağustos'></cfsavecontent>
					<cfsavecontent variable="ay9"><cf_get_lang dictionary_id='57600.Eylül'></cfsavecontent>
					<cfsavecontent variable="ay10"><cf_get_lang dictionary_id='57601.Ekim'></cfsavecontent>
					<cfsavecontent variable="ay11"><cf_get_lang dictionary_id='57602.Kasım'></cfsavecontent>
					<cfsavecontent variable="ay12"><cf_get_lang dictionary_id='57603.Aralık'></cfsavecontent>
					<cfset ay_listesi = "#ay1#,#ay2#,#ay3#,#ay4#,#ay5#,#ay6#,#ay7#,#ay8#,#ay9#,#ay10#,#ay11#,#ay12#">
					<select name="months" id="months">
						<option value=""><cf_get_lang dictionary_id='58724.Ay'></option>
						<cfoutput>
							<cfloop index="i" from="1" to="#ListLen(ay_listesi)#">
							<option value="#i#" <cfif attributes.months eq i>selected</cfif>>#ListGetAt(ay_listesi,i)#</option>
							</cfloop>
						</cfoutput>
					</select>
				</div>
				<div class="form-group" id="years">				
					<select name="years" id="years">
						<option value=""><cf_get_lang dictionary_id='58455.Yıl'></option>
						<cfoutput>
							<cfloop index="i" from="#dateFormat(now(),'yyyy')#" to="2000" step="-1">
								<option value="#i#" <cfif attributes.years eq i>selected</cfif>>#i#</option>
							</cfloop>
						</cfoutput>
					</select>
				</div>
				<div class="form-group small" id="item_maxrows">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" onKeyUp="isNumber (this)">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4" search_function='kontrol()'>
					<cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'>
				</div>
			</cf_box_search>
		</cfform>
	</cf_box>
	<cf_box title="#getLang(171,'Sevkiyat Analizi',48042)#" uidrop="1" hide_table_column="1">
		<cf_grid_list>
			<thead>
				<tr>
					<th width="35"><cf_get_lang dictionary_id='58577.Sıra'></th>
					<th><cf_get_lang dictionary_id='58672.Aylar'></th>
					<th><cf_get_lang dictionary_id='57453.Şube'></th>
					<th><cf_get_lang dictionary_id='48256.Bölge No'></th>
					<th><cf_get_lang dictionary_id='48191.Sevk Bölgesi'></th>
					<th><cf_get_lang dictionary_id='57789.Özel Kod'></th>
					<th><cf_get_lang dictionary_id='48211.Rut Uzunluğu'></th>
					<th><cf_get_lang dictionary_id='48196.Günlük Sevk Sayısı'></th>
					<th><cf_get_lang dictionary_id='37168.Müşteri Sayısı'></th>
					<th><cf_get_lang dictionary_id='48188.Gün Sayısı'></th>
					<th><cf_get_lang dictionary_id='48221.KM Toplam'></th>
					<th><cf_get_lang dictionary_id='30010.Ciro'></th>
					<!-- sil -->
					<th width="20" class="header_icn_none text-center"><a href="javascript://" class="tableyazi" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=assetcare.list_ship_analysis&event=add','medium','popup_add_ship_analysis');"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>" alt="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>
					<!-- sil -->
				</tr>
			</thead>
			<tbody>
				<cfif len(attributes.form_submitted)>
					<cfif get_ship.recordCount>
						<cfoutput query="get_ship" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<tr>
							<td width="35">#currentrow#</td>
							<td>#ListGetAt(ay_listesi,dateFormat(ship_date,'mm'),',')# / #dateFormat(ship_date,'yyyy')#</td>
							<td>#branch_name#</td>
							<td>#ship_num#</td>
							<td>#ship_area#</td>
							<td>#special_code#</td>
							<td  style="text-align:right;">#distance# km.</td>
							<td  style="text-align:right;">#tour_number#</td>
							<td  style="text-align:right;">#store_quantity#</td>
							<td  style="text-align:right;">#days#</td>
							<td  style="text-align:right;">#days * tour_number * distance#</td>
							<td  style="text-align:right;">#tlformat(endorsement,2)# #currency#</td>
							<!-- sil --><td align="center" style="text-align:center;"><a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=assetcare.list_ship_analysis&event=upd&ship_id=#ship_id#','medium','popup_upd_ship_analysis');"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></td><!-- sil -->
						</tr>
						</cfoutput>
					<cfelse>
						<tr>
							<td height="22" colspan="13"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'> !</td>
						</tr>
					</cfif>
				<cfelse>
				<tr>
						<td height="22" colspan="13"><cf_get_lang dictionary_id='57701.Filtre Et'> !</td>
				</tr>
				</cfif>
			</tbody>
		</cf_grid_list>

		<cfset url_str = "">
		<cfif len(attributes.keyword)>
		<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
		</cfif>
		<cfif len(attributes.years)>
		<cfset url_str = "#url_str#&years=#attributes.years#">
		</cfif>
		<cfif len(attributes.months)>
		<cfset url_str = "#url_str#&months=#attributes.months#">
		</cfif>
		<cfif len(attributes.branch_id)>
		<cfset url_str = "#url_str#&branch_id=#attributes.branch_id#">
		</cfif>
		<cfif isdefined("attributes.form_submitted") and len(attributes.form_submitted)>
		<cfset url_str = "#url_str#&form_submitted=#attributes.form_submitted#">
		</cfif>
		<cf_paging
			page="#attributes.page#"
			maxrows="#attributes.maxrows#"
			totalrecords="#attributes.totalrecords#"
			startrow="#attributes.startrow#"
			adres="assetcare.list_ship_analysis#url_str#">
	</cf_box>
</div>
<script type="text/javascript">
document.getElementById('keyword').focus();
function kontrol()
{
	a = document.search_ship.months.selectedIndex;
	b = document.search_ship.years.selectedIndex;
	if(document.search_ship.months[a].value != "" || document.search_ship.years[b].value != "")
	{
		if((document.search_ship.months[a].value == ""  || document.search_ship.years[b].value ==""))
		{
			alert("<cf_get_lang dictionary_id='48222.Ay Değeri Yıl İle Birlikte Seçilmelidir'>!");
			return false;
		}
	}
	return true;
}
</script>
