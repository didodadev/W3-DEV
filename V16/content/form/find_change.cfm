
<cfparam  name="attributes.submit_" default="">
<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
	<cf_box title="#getLang('content',165)#">
		<cfform name="find_change" action="" method="post">
			<cf_box_elements>
				<div class="col col-12 col-md-12 col-sm-12 col-xs-12" type="column" index="1" sort="true">
					<div class="form-group" id="item-old_text">
						<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
							<label><cf_get_lang dictionary_id='63076.Bul'>*</label>
							<input type="hidden" name="submit_" id="submit_"  value="0"> 
							<input type="text" name="old_text" id="old_text"  value="<cfif isdefined("attributes.old_text")><cfoutput>#Left(attributes.old_text,50)#</cfoutput></cfif>" maxlength="50" tabindex="7"> 
						</div>
					</div>
					<div class="form-group" id="item-new_text">
						<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
							<label><cf_get_lang dictionary_id='47334.Değiştir'>*</label>
							<input type="text" name="new_text" id="new_text" value="<cfif isdefined("attributes.new_text")><cfoutput>#Left(attributes.new_text,50)#</cfoutput></cfif>" maxlength="50" tabindex="7"> 
						</div>
					</div>
					<div class="form-group" id="item-contentcat_id">
						<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
							<label ><cf_get_lang dictionary_id='57486.Kategori'> <cfif session.ep.our_company_info.sales_zone_followup eq 1> </cfif></label>
							<div class="input-group">
								<input type="hidden" name="contentcat_id" id="contentcat_id">
								<input type="text" name="contentcat_name" tabindex="62" id="contentcat_name" readonly="yes">
								<span class="input-group-addon btnPointer icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#?fuseaction=content.popup_list_content_cat</cfoutput>&id=find_change.contentcat_id&alan=find_change.contentcat_name','list','popup_list_ims_code');return false"></span>
							</div>
						</div>
					</div>  
					<div class="form-group" id="item-chapter_id">
						<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
							<label ><cf_get_lang dictionary_id='57995.Bölüm'> <cfif session.ep.our_company_info.sales_zone_followup eq 1> </cfif></label>
							<div class="input-group">
								<input type="hidden" name="chapter_id" id="chapter_id">
								<input type="text" name="chapter_name" tabindex="62" id="chapter_name" readonly="yes">
								<span class="input-group-addon btnPointer icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#?fuseaction=content.popup_list_chapter</cfoutput>&id=find_change.chapter_id&alan=find_change.chapter_name','list','popup_list_ims_code');return false"></span>
							</div>
						</div>
					</div> 
					<div class="form-group" id="item-search_type">
						<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
							<label ><cf_get_lang dictionary_id='50669.Kriter'></label>
							<select name="search_type" id="search_type">
								<option value="0"><cf_get_lang dictionary_id='50670.Herhangi bir kelimeyle eşleşsin'></option>
								<option value="1"><cf_get_lang dictionary_id='50671.Tüm kelimelerle eşleşsin'></option>
								<option value="2"><cf_get_lang dictionary_id='50672.Noktalama Duyarlı Tam Sözcük'></option>
							</select>
						</div>
					</div>
					<div class="form-group" id="item-heads">
						<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
							<label ><cf_get_lang dictionary_id='50676.Bul-Değiştir Yapılacak Alanlar'></label>
							<div><cf_get_lang dictionary_id='50673.Başlıklar'> <input type="checkbox" name="heads" id="heads" value="checkbox">&nbsp;&nbsp;&nbsp;
							<cf_get_lang dictionary_id='50674.Özetler'>  <input type="checkbox" name="summary" id="summary" value="checkbox"> &nbsp;&nbsp;&nbsp;
							<cf_get_lang dictionary_id='58045.İçerikler'> <input type="Checkbox" name="contents" id="contents"></div>
						</div>
					</div>
					<div class="form-inline col col-12 col-md-12 col-sm-12 col-xs-12" type="column" index="3" sort="true">
						<div class="form-group" >
							<font color="#FF0000">* <cf_get_lang dictionary_id='50675.Arama Büyük-Küçük harfe duyarlıdır'>!</font>
						</div>
					</div>	
				</div>	
			</cf_box_elements>
			<cf_box_footer>
				<div class="form-group" >
					<cf_wrk_search_button button_type='1' search_function='checkBoxControl()' is_excel='0'>
				</div>
			</cf_box_footer>
		</cfform>
	</cf_box>
</div>
 <!--- Bu sayfanin amacini anlayamadim. Ayrıca CONT_BODY alani icin CONTAINS ile Fulltext Search arama yapmalı. BK 20130112 --->

<div class="col col-9 col-md-9 col-sm-9 col-xs-12">
	<cf_box title="#getLang('','sonuçlar','58135')#"> 
		<cfinclude  template="find_change_process.cfm">
	</cf_box>
</div>
<script type="text/javascript">
	function checkBoxControl()
	{
		if (!document.getElementById('heads').checked &&
			!document.getElementById('summary').checked &&
			!document.getElementById('contents').checked)
			{
				alert("<cf_get_lang dictionary_id='58194.Zorunlu Alan'>:<cf_get_lang dictionary_id='50676.Bul-Değiştir Yapılacak Alanlar'>!");
				return false;
			}
		if(document.getElementById('old_text').value == document.getElementById('new_text').value)
		{
			alert("<cf_get_lang dictionary_id='50677.Aranacak kelime ile Yeni kelime aynı olamaz'>!");
				return false;
		}
		
		if(document.getElementById('old_text').value == "")
		{
			alert("<cf_get_lang dictionary_id='58194.Zorunlu Alan'>:<cf_get_lang dictionary_id='63076.Bul'>!");
			document.getElementById('old_text').focus();
			return false;
		}
		if(document.getElementById('new_text').value == "")
		{
			alert("<cf_get_lang dictionary_id='58194.Zorunlu Alan'>:<cf_get_lang dictionary_id='47334.Değiştir'>!");
			document.getElementById('new_text').focus();
			return false;
		}
		
		if(confirm("<cf_get_lang dictionary_id='63075.Bu yaptığınız eylem kalıcı sonuçlara dönüşür emin misiniz'>?"))
			document.find_change.submit();
		else 
			return false;
	}

</script>


<!--- Bu sayfanin amacini anlayamadim. Ayrıca CONT_BODY alani icin CONTAINS ile Fulltext Search arama yapmalı. BK 20130112 --->
