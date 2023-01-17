<cfinclude template="../query/get_content_cat.cfm">
<cfinclude template="../query/get_content_property.cfm">
<cfquery name="GET_CHAPTER_MENU" datasource="#DSN#">
	SELECT 
		CHAPTER_ID,
		CHAPTER 
	FROM 
		CONTENT_CHAPTER
<cfif isDefined("attributes.cont_catid") and len(attributes.cont_catid)>
	WHERE 
		CONTENTCAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cont_catid#">
</cfif>
	ORDER BY 
		HIERARCHY
</cfquery>
<cfquery name="get_content_process_stages" datasource="#DSN#">
	SELECT 
		PTR.PROCESS_ROW_ID AS STAGE_ID,
		PTR.STAGE STAGE_NAME 
	FROM 
		PROCESS_TYPE PT, 
		PROCESS_TYPE_ROWS PTR,
		PROCESS_TYPE_OUR_COMPANY PTOC 
	WHERE
		PT.IS_ACTIVE = 1 AND
		PT.PROCESS_ID = PTOC.PROCESS_ID AND
		PTOC.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
		PT.FACTION LIKE 'content.%' AND
		PT.PROCESS_ID = PTR.PROCESS_ID
	ORDER BY
		PTR.LINE_NUMBER
</cfquery>
<cfform name="search_content" action="" method="post">
	<table style="width:100%;" border="0">
		<tr>
			<td><cf_get_lang_main no ='68.Konu'></td>
			<td colspan="3"><input type="text" name="content" id="content" value="" style="width:437px;"></td>
		</tr>
		<tr>
			<td style="width:90px;"><cf_get_lang_main no ='487.Kaydeden'></td>
			<td style="width:190px;">
				<input type="hidden" name="record_id" id="record_id" value="">
				<input type="text" name="record" id="record" value="" style="width:150px;">
				<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=search_content.record_id&field_name=search_content.record&select_list=1','list');"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>
			</td>
			<td style="width:90px;"><cf_get_lang_main no ='479.Gncelleyen'></td>
			<td><input type="hidden" name="upd_id" id="upd_id" value="">
				<input type="text" name="upd" id="upd" value="" style="width:150px;">
				<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=search_content.upd_id&field_name=search_content.upd&select_list=1','list');"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>
			</td>
		</tr>
		<tr>
			<td><cf_get_lang_main no ='74.Kategori'></td>
			<td><select name="cat" id="cat" onChange="redirect(this.options.selectedIndex);" style="width:150px;">
					<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
					<cfoutput query="get_content_cat">
						<option value="#contentcat_id#"<cfif isdefined("attributes.cat") and attributes.cat is "#contentcat_id#">selected</cfif>>#contentcat# </option>
					</cfoutput>
				</select>
			</td>
			<td><cf_get_lang_main no ='583.Blm'></td>
			<td><select name="chapter" id="chapter" style="width:150px;">
					<option value="" selected="selected"><cf_get_lang_main no='322.Seçiniz'></option>
					<cfoutput query="get_chapter_menu">
						<option value="#chapter_id#"<cfif isdefined("attributes.chapter") and attributes.chapter eq chapter_id>selected</cfif>>#chapter#</option>
					</cfoutput>
				</select>
			</td>
		</tr>
		<tr>
			<td><cf_get_lang_main no ='218.Tip'></td>
			<td><select name="content_property_id" id="content_property_id" style="width:150px;">
					<option value="" selected><cf_get_lang_main no='322.Seçiniz'>
					<cfoutput query="get_content_property">
						<option value="#content_property_id#"<cfif isdefined("attributes.content_property_id") and attributes.content_property_id eq content_property_id>selected</cfif>>#name# 
					</cfoutput>
				</select>
			</td>
			<td><cf_get_lang_main no='1584.Dil'></td>
			<td><select name="language_id" id="language_id" style="width:150px;">
					<option value=""><cf_get_lang_main no='322.Seçiniz'>
					<option value="tr" <cfif isdefined("attributes.language_id") and attributes.language_id is "tr">selected</cfif>>Türkçe
					<option value="eng" <cfif isdefined("attributes.language_id") and attributes.language_id is "eng">selected</cfif>>English
					<option value="de" <cfif isdefined("attributes.language_id") and attributes.language_id is "de">selected</cfif>>Deutch
				</select>
			</td>
		</tr>
		<tr>
			<td><cf_get_lang_main no ='344.Durumu'></td>
			<td><select name="status" id="status" style="width:150px;">
					<option value="1" <cfif isdefined("attributes.status") and attributes.status is 1>selected</cfif>><cf_get_lang_main no='81.Aktif'></option>
					<option value="2" <cfif isdefined("attributes.status") and attributes.status is 2>selected</cfif>><cf_get_lang_main no='82.Pasif'></option>
					<option value="3" <cfif isdefined("attributes.status") and attributes.status is 3>selected</cfif>><cf_get_lang_main no='296.Tümü'></option>
				</select>
			</td>
			<td><cf_get_lang_main no ='73.Öncelik'></td>
			<td><select name="priority" id="priority" style="width:150px;">
					<option value=""><cf_get_lang_main no='322.Seçiniz'>
					<option value="1">1</option>
					<option value="2">2</option>
					<option value="3">3</option>
					<option value="4">4</option>
					<option value="5">5</option>
					<option value="6">6</option>
					<option value="7">7</option>
					<option value="8">8</option>
					<option value="9">9</option>
					<option value="10">10</option>
				</select>
			</td>
		</tr>
		<tr>
			<td><cf_get_lang_main no ='215.Kayit Tarihi'></td>
			<td><cfinput type="text" name="search_date1" id="search_date1" value="" validate="eurodate" style="width:80px;" maxlength="10">
				<cf_wrk_date_image date_field="search_date1">
			</td>
			<td><cf_get_lang no ='5.Güncelleme Tarihi'></td>
			<td><cfinput type="text" name="search_date2" id="search_date2" value="" validate="eurodate" style="width:80px;" maxlength="10">
				<cf_wrk_date_image date_field="search_date2">
			</td>
		</tr>
		<tr>
			<td class="txtbold" colspan="4"><cf_get_lang no ='21.İçerigin Yayınlandığı Yer'></td>
		</tr>
		<tr>
			<td colspan="2">
				<input type="checkbox" name="ana_sayfa" id="ana_sayfa" onclick="chk_poz(1)" value="1"><cf_get_lang no ='23.Anasayfa'>
				<input type="checkbox" name="ana_sayfayani" id="ana_sayfayani" onclick="chk_poz(2)" value="2"><cf_get_lang no ='24.Anasayfa Yanı'>
			</td>
			<td colspan="2">
				<input type="checkbox" name="kategori_basi" id="kategori_basi" onclick="chk_poz(3)" value="3"><cf_get_lang no ='20.Kategori Başı'>
				<input type="checkbox" name="kategori_yani" id="kategori_yani" onclick="chk_poz(4)" value="4"><cf_get_lang no ='18.Kategori Yanı'>
			</td>
		</tr>
		<tr>
			<td colspan="2">
				<input type="checkbox" name="ch_bas" id="ch_bas" onclick="chk_poz(5)" value="5"><cf_get_lang no ='12.Bölüm Başı'>
				<input type="checkbox" name="ch_yan" id="ch_yan" onclick="chk_poz(6)" value="6"><cf_get_lang no ='11.Bölüm Yanı'>
			</td>
			<td colspan="2">
				<input type="checkbox" name="none_tree" id="none_tree"><cf_get_lang no ='10.Bolum Icerigini Gosterme'>
				<input type="checkbox" name="spot" id="spot">Spot
			</td>			
		</tr>
		<tr>
			<td colspan="4" style="text-align:right;"><input type="button" value="<cf_get_lang_main no ='153.Ara'>" onClick="gonder();"></td><!--- open_list_content(); --->
		</tr>
	</table>
</cfform>
<br />
<div id="list_content_" style="position:absolute;"></div>
<script type="text/javascript">
function gonder()
{
	keyword_ = document.getElementById('content').value;
	language_id_ = document.getElementById('language_id').value;
	status_ = document.getElementById('status').value;
	content_property_id_ = document.getElementById('content_property_id').value;
	content_cat_ = document.getElementById('cat').value;
	chapter_ = document.getElementById('chapter').value;
	record_date_ = document.getElementById('search_date1').value;
	upd_date_ = document.getElementById('search_date2').value;
	record_id_ = document.getElementById('record_id').value;
	upd_id_ = document.getElementById('upd_id').value;
	priority_ = document.getElementById('priority').value;
	if (document.search_content.ana_sayfa.checked == true)
		ana_sayfa_ = document.search_content.ana_sayfa.value;
	else if (document.search_content.ana_sayfayani.checked == true)
		ana_sayfayani_ = document.search_content.ana_sayfayani.value;
	if (document.search_content.kategori_basi.checked == true)
		kategori_basi_ = document.search_content.kategori_basi.value;
	else if (document.search_content.kategori_yani.checked == true)
		kategori_yani_ = document.search_content.kategori_yani.value;
	if (document.search_content.ch_bas.checked == true)
		ch_bas_ = document.search_content.ch_bas.value;
	else if (document.search_content.ch_yan.checked == true)
		ch_yan_ = document.search_content.ch_yan.value;
	if (document.search_content.spot.checked == true)
		spot_ = document.search_content.spot.value;
	if (document.search_content.none_tree.checked == true)
		none_tree_ = document.search_content.none_tree.value;

	<cfoutput>
	url_string = '#request.self#?fuseaction=rule.list_rule&keyword1='+keyword_+'&language_id='+language_id_+'&status='+status_+'&content_property_id='+content_property_id_+'&cat='+content_cat_+'&search_date1='+record_date_+'&search_date2='+upd_date_+'&record_id='+record_id_+'&upd_id='+upd_id_+'&priority='+priority_+'&chapter='+chapter_;
	if (document.search_content.ana_sayfa.checked)
		url_string = url_string +'&ana_sayfa='+ana_sayfa_;
	else if (document.search_content.ana_sayfayani.checked)
		url_string = url_string +'&ana_sayfayani='+ana_sayfayani_;
	if (document.search_content.kategori_basi.checked)
		url_string = url_string +'&kategori_basi='+kategori_basi_;
	else if (document.search_content.kategori_yani.checked)
		url_string = url_string +'&kategori_yani='+kategori_yani_;
	if (document.search_content.ch_bas.checked)
		url_string = url_string +'&ch_bas='+ch_bas_;
	else if (document.search_content.ch_yan.checked)
		url_string = url_string +'&ch_yan='+ch_yan_;
	if (document.search_content.spot.checked)
		url_string = url_string +'&spot='+spot_;
	if (document.search_content.none_tree.checked)
		url_string = url_string +'&none_tree='+none_tree_;
	top.location.href= url_string;
	//window.close();
	</cfoutput>
}

function chk_poz(gelen)
{
	if ( (gelen == 1) && (search_content.ana_sayfayani.checked) ) search_content.ana_sayfayani.checked = false;
	if ( (gelen == 2) && (search_content.ana_sayfa.checked) ) search_content.ana_sayfa.checked = false;
	if ( (gelen == 3) && (search_content.kategori_yani.checked) ) search_content.kategori_yani.checked = false;
	if ( (gelen == 4) && (search_content.kategori_basi.checked) ) search_content.kategori_basi.checked = false;
	if ( (gelen == 5) && (search_content.ch_yan.checked) ) search_content.ch_yan.checked = false;
	if ( (gelen == 6) && (search_content.ch_bas.checked) ) search_content.ch_bas.checked = false;
}

var groups=document.search_content.cat.options.length;
var group=new Array(groups);

for (i=0; i<groups; i++)
group[i]=new Array();

group[0][0]=new Option("Blm Seiniz","");

<cfset cnt_cat = ArrayNew(1)>
<cfoutput query="get_content_cat">
	<cfset Cnt_cat[currentrow] = #CONTENTCAT_ID#>
</cfoutput>
<cfloop from="1" to="#ArrayLen(Cnt_cat)#" index="indexer">
	<cfquery name="CHPT_SEC" datasource="#dsn#">
		SELECT CHAPTER_ID,CHAPTER FROM CONTENT_CHAPTER WHERE CONTENTCAT_ID = #CNT_CAT[INDEXER]#
	</cfquery>
	<cfif CHPT_SEC.recordcount>
		<cfoutput query="Chpt_sec">
			<cfset deg = currentrow -1>
			group[#indexer#][#deg#]=new Option("#chapter#","#chapter_ID#");
		</cfoutput>
	<cfelse>
		<cfset deg = 0>
		<cfoutput>
			group[#indexer#][#deg#]=new Option("<cf_get_lang no ='4.Bölüm Seçiniz'>","");
		</cfoutput>
	</cfif>
</cfloop>

var temp=document.search_content.chapter;
function redirect(x)
{
	for (m=temp.options.length-1;m>0;m--)
		temp.options[m]=null;
	for (i=0;i<group[x].length;i++)
	{
		temp.options[i]=new Option(group[x][i].text,group[x][i].value);
	}
	document.search_content.style.display = "";
}

function open_list_content()
{
	AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=rule.list_rule#url_address#' ,'list_content_','0');
}
</script>
