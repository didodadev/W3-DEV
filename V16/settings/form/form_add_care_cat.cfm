<cfparam name="attributes.ust_cat" default="">
<cfquery name="GET_CARE_CATS" datasource="#DSN#">
	SELECT 
    	CARE_CAT_ID, 
        HIERARCHY, 
        CARE_CAT, 
        DETAIL, 
        UPDATE_IP 
    FROM 
	    SETUP_CARE_CAT 
    ORDER BY 
    	HIERARCHY
</cfquery>	
<cfparam name="attributes.modal_id" default="">
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box id="item_add" title="#getLang('','Bakım Kategorileri','42903')#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
        <cfform name="add_care_cat" method="post" action="#request.self#?fuseaction=settings.care_cat_add">
            <cf_box_elements>
                <input type="hidden" id="counter" name="counter">
                <div class="col col-6 col-sm-6 col-xs-12" type="column" sort="true" index="1">
                    <div class="form-group" id="item-category">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='29736.Üst Kategori'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <select value="<cfif len(attributes.ust_cat)><cfoutput>#attributes.ust_cat#</cfoutput></cfif>" name="hierarchy" id="hierarchy" onChange="document.add_care_cat.head_cat_code.value=document.add_care_cat.hierarchy[document.add_care_cat.hierarchy.selectedIndex].value;" style="width:200px;">
                                <option value="" selected><cf_get_lang dictionary_id='57734.Seçiniz'>
                                <cfoutput query="get_care_cats">
                                    <option value="#hierarchy#"<cfif len(attributes.ust_cat) and (attributes.ust_cat is hierarchy)> selected</cfif>>#hierarchy# #care_cat#</option>
                                </cfoutput>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-head_cat_code">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='43389.Kategori Kodu'> *</label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                                <input type="text" name="head_cat_code" id="head_cat_code" value="<cfif len(attributes.ust_cat)><cfoutput>#attributes.ust_cat#</cfoutput></cfif>" disabled>
                            </div>
                            <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='43390.Kategori Kodu Girmelisiniz'></cfsavecontent>
                                <cfinput type="text" name="care_cat_code" id="care_cat_code" value="" maxlength="50" required="yes" message="#message#">
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-care_cat">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57486.Kategori'>*</label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='58555.Kategori Adı Girmelisiniz'></cfsavecontent>
                            <cfinput type="text" name="care_cat" id="care_cat" value="" maxlength="50" required="Yes" message="#message#">
                        </div>
                    </div>
                    <div class="form-group" id="item-detail">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <textarea name="detail" id="detail" style="width:200px;height:40px;" maxlength="100" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="Maksimum Karakter Sayısı : 100"></textarea>
                        </div>
                    </div>
                </div>
            </cf_box_elements>
            <cf_box_footer>
                <cf_workcube_buttons is_upd='0' add_function='form_check();kontrol()'>
            </cf_box_footer>
        </cfform>
    </cf_box>
</div>
<script type="text/javascript">
function form_check()
{
	x = (100 - add_care_cat.detail.value.length);
	if ( x < 0 )
	{ 
		alert ("<cf_get_lang dictionary_id='57771.Detay'> "+ ((-1) * x) +" <cf_get_lang dictionary_id='29538.Karakter Uzun'>");
		return false;
	}
	
	our_pro_str = add_care_cat.care_cat_code.value;
	for(;;)
	{
			if (our_pro_str.search(" ") != -1)
			{      
				our_pro_str = our_pro_str.replace(" ","");
				add_care_cat.care_cat_code.value = our_pro_str;
			}
			else
			{
				break;
			}
	}
    
	if (add_care_cat.care_cat_code.value.indexOf('.') != -1)
	{
		alert("<cf_get_lang dictionary_id='44503.Bu Kod kullanılmakta başka kod kullanınız'>!");
		return false;
	}
	return true;
}
</script>
