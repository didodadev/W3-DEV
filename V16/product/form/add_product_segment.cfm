<!--- <cf_catalystHeader> --->
<cfparam name="attributes.modal_id" default="">
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box title="#getLang('','Ürün Hedef Pazar',37251)# : #getLang('', 'Yeni Kayıt', 45697)#" collapsable="0" resize="0" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
        <cfform name="upd_product_segment" action="#request.self#?fuseaction=product.emptypopup_add_product_segment" method="post">
            <cfparam name="attributes.modal_id" default="">
            <cfif isdefined("attributes.draggable")>
                <cfinput type="hidden" name="draggable" id="draggable" value="#attributes.draggable#">
                <cfinput type="hidden" name="modal_id" id="modal_id" value="#attributes.modal_id#">
            </cfif>
            <cf_box_elements vertical="1">
                <div class="col col-12 col-xs-12" type="column" index="1" sort="true">
                    <div class="form-group" id="item-PRO_SEG">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='37035.Hedef Pazar'>*</label>
                        <div class="col col-8 col-xs-12">
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id ='37759.Hedef Pazar Girmelisiniz'>!</cfsavecontent>
                            <cfinput type="text" name="PRO_SEG" value="" maxlength="50" required="yes" message="#message#">
                        </div>
                    </div>
                    <div class="form-group" id="item-detail">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
                        <div class="col col-8 col-xs-12">
                            <textarea name="detail" id="detail" maxlength="150" value=""></textarea>
                        </div>
                    </div>
                </div>   
                <div class="col col-12 col-xs-12" type="column" index="2" sort="false">                     
                    <div class="form-group" id="item-">
                        <label class="col col-4 bold"><cf_get_lang dictionary_id ='37692.Seviye'></label>
                        <label class="col col-4 bold"><cf_get_lang dictionary_id='58908.Min'></label>
                        <label class="col col-4 bold"><cf_get_lang dictionary_id='58909.Max'></label>
                    </div>
                    <div class="form-group" id="item-">
                        <label class="col col-4">1.<cf_get_lang dictionary_id ='37692.Seviye'></label>
                        <div class="col col-8">
                            <div class="input-group">
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='60453.Seviye Değeri Sayısal Olmalıdır'> !</cfsavecontent>
                                <cfinput type="text" validate="integer" onKeyUp="isNumber(this);" message="#message#" name="min_point_1">
                                <span class="input-group-addon no-bg"></span>
                                <cfinput type="text" validate="integer" onKeyUp="isNumber(this);" message="#message#" name="max_point_1">
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-">
                        <label class="col col-4">2.<cf_get_lang dictionary_id ='37692.Seviye'></label>
                        <div class="col col-8">
                            <div class="input-group">
                                <cfinput type="text" validate="integer" onKeyUp="isNumber(this);" message="#message#" name="min_point_2">
                                <span class="input-group-addon no-bg"></span>
                                <cfinput type="text" validate="integer" onKeyUp="isNumber(this);" message="#message#" name="max_point_2">
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-">
                        <label class="col col-4">3.<cf_get_lang dictionary_id ='37692.Seviye'></label>
                        <div class="col col-8">
                            <div class="input-group">
                                <cfinput type="text" validate="integer" onKeyUp="isNumber(this);" message="#message#" name="min_point_3">
                                <span class="input-group-addon no-bg"></span>
                                <cfinput type="text" validate="integer" onKeyUp="isNumber(this);" message="#message#" name="max_point_3">
                            </div>
                        </div>
                    </div>
                </div>
            </cf_box_elements>
            <cf_box_footer>                        
                <cf_workcube_buttons type_format='1' is_upd='0' add_function='kontrol()&&#iif(isdefined("attributes.draggable"),DE("loadPopupBox('upd_product_segment' , #attributes.modal_id#)"),DE(""))#'>
            </cf_box_footer>
        </cfform>
    </cf_box>
</div>
<script type="text/javascript">
	function kontrol()
	{		 
		if($('#detail').val().length > 150)
		{
			alert("<cf_get_lang dictionary_id='57629.Aciklama'><cf_get_lang dictionary_id='29725.Max Karakter Sayisi'>:150");
			return false;
		}			
		var error_ = 0;
		if(document.upd_product_segment.min_point_1.value.length>0 && document.upd_product_segment.max_point_1.value.length==0)
			error_ = 1;
		if(document.upd_product_segment.max_point_1.value.length>0 && document.upd_product_segment.min_point_1.value.length==0)
			error_ = 1;
		if(document.upd_product_segment.min_point_2.value.length>0 && document.upd_product_segment.max_point_2.value.length==0)
			error_ = 1;
		if(document.upd_product_segment.max_point_2.value.length>0 && document.upd_product_segment.min_point_2.value.length==0)
			error_ = 1;
		if(document.upd_product_segment.min_point_3.value.length>0 && document.upd_product_segment.max_point_3.value.length==0)
			error_ = 1;
		if(document.upd_product_segment.max_point_3.value.length>0 && document.upd_product_segment.min_point_3.value.length==0)
			error_ = 1;
	
		if(error_==1)
		{
			alert("<cf_get_lang dictionary_id ='37758.Seviye Değerlerini Düzenleyiniz'>!");
			return false;
		}
			
		if(document.upd_product_segment.min_point_1.value.length>0 && parseInt(document.upd_product_segment.min_point_1.value)>=parseInt(document.upd_product_segment.max_point_1.value))
			error_ = 1;
		if(document.upd_product_segment.min_point_2.value.length>0 && parseInt(document.upd_product_segment.min_point_2.value)>=parseInt(document.upd_product_segment.max_point_2.value))
			error_ = 1;
		if(document.upd_product_segment.min_point_3.value.length>0 && parseInt(document.upd_product_segment.min_point_3.value)>=parseInt(document.upd_product_segment.max_point_3.value))
			error_ = 1;
			
		if(error_==1)
		{
			alert("<cf_get_lang dictionary_id ='37758.Seviye Değerlerini Düzenleyiniz'>!");
			return false;
		}
	}
</script>
