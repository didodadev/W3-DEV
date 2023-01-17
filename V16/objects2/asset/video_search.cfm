<cf_box title="Video Arama">

<div style="width:300px;">
	<cfform name="video_search_form" method="post" action="#request.self#?fuseaction=objects2.list_videos">
		<table>
			<tr>
				<td><cfinput type="text" name="keyword" value="<cf_get_lang no='168.Video Ara'>" onFocus="this.value='';">
					<input type="image" src="../documents/images/search.jpg" align="absmiddle"><br/>
				</td>
			</tr>
			<tr>
				<td onClick="gizle_goster(VideoSearchForm);" style="cursor:pointer;" align="right"><cf_get_lang no='169.Gelişmiş Arama'></td>
			</tr>
		</table>
	</cfform>
</div>

<cfinclude template="../../asset/query/get_asset_cats.cfm">
<table id="VideoSearchForm" style="display:none">
	<cfform name="video_search_advenced" method="post" action="#request.self#?fuseaction=objects2.list_videos">
		<tr>
			<td><cf_get_lang_main no ='89.Başlangıç'>:</td>
			<td nowrap="nowrap"><cfinput type="text" name="StartDate" validate="eurodate" value=""><cf_wrk_date_image date_field="StartDate"></td>
		</tr>
		<tr>
			<td><cf_get_lang_main no ='90.Bitiş'>:</td>
			<td nowrap="nowrap"><cfinput type="text" name="EndDate" validate="eurodate" value=""><cf_wrk_date_image date_field="EndDate"></td>
		</tr>
		<tr>
			<td><cf_get_lang_main no ='218.Tip'></td>
			<td><select name="search_" id="search_" style="width:140px;">
					<option value=""><cf_get_lang_main no ='322.Seçiniz'></option>
					<option value="1"><cf_get_lang no ='1132.En Çok İzlenenler'></option>
					<option value="2"><cf_get_lang no ='1133.En Çok Yorumlananlar'></option>
					<option value="3"><cf_get_lang no ='1134.En Çok İndirilenler'></option>
				</select>
			</td>
		</tr>
		<tr>
			<td><cf_get_lang_main no='74.Kategori'></td>
			<td><select name="search_assetcat_id" id="search_assetcat_id" style="width:140px;">
					<option value=""><cf_get_lang_main no ='322.Seçiniz'></option>
					<cfoutput query="get_asset_cats"> 
					<option value="#assetcat_id#">#assetcat#</option>
					</cfoutput> 
				</select>
			</td>
		</tr>
		<tr>
			<td colspan="2"  style="text-align:right;">
            	<input type="hidden" name="advanced_video_search" id="advanced_video_search" value="1" />
            	<input type="submit" name="video_submit" id="video_submit" value="<cf_get_lang_main no='153.Ara'>" />
				<input type="button" name="video_cancel" id="video_cancel" value="<cf_get_lang_main no='1094.İptal'>" onclick="gizle_goster(VideoSearchForm);" />
			</td>
		</tr>
	</cfform>
</table>
</cf_box>

