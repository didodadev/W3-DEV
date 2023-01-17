<cfscript>
	get_product_list_action = createObject("component", "V16.product.cfc.get_product");
	get_product_list_action.dsn1 = dsn1;
	get_product_list_action.dsn_alias = dsn_alias;
	GET_PRODUCT = get_product_list_action.get_product_
	(
		module_name : fusebox.circuit,
		pid : attributes.pid
	);
</cfscript>
<cfinclude template="../query/get_rivals.cfm">
<cfinclude template="../query/get_money.cfm">
<cfinclude template="../query/get_product_unit.cfm">
<cfsavecontent variable="message"><cf_get_lang dictionary_id='37328.Rakip Fiyat'></cfsavecontent>
<cf_box title="#message#"  scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
<cfform action="#request.self#?fuseaction=product.emptypopup_add_rival_price" method="post" name="price" >
  <cf_box_elements>
    <div class="col col-12 col-md-12 col-xs-12">
  <div class="form-group">
    <label class="col col-4 col-md-4 col-xs-12"><cf_get_lang dictionary_id='57657.Ürün'></label>
    <div class="col col-8 col-md-8 col-xs-12">
      <cfoutput>#get_product.product_name#</cfoutput> 
    </div>
  </div>
  <div class="form-group">
    <label class="col col-4 col-md-4 col-xs-12"><cf_get_lang dictionary_id='58779.Rakip'>*</label>
    <div class="col col-8 col-md-8 col-xs-12">
      <select name="r_id" id="r_id" >
        <cfoutput query="get_rivals"> 
          <option value="#R_ID#">#rival_name# 
        </cfoutput> 
      </select>
    </div>
  </div>
  <div class="form-group">
    <label class="col col-4 col-md-4 col-xs-12"><cf_get_lang dictionary_id='58084.Fiyat'>*</label>
    <div class="col col-8 col-md-8 col-xs-12">
      <input type="Hidden" name="pid" id="pid" value="<cfoutput>#url.pid#</cfoutput>">
      <!---  <input type="Hidden" name="stock_id" value="<cfoutput>#url.stock_id#</cfoutput>"> --->
      <div class="col col-9 col-md-9 col-xs-12">   
      <cfsavecontent variable="message"><cf_get_lang dictionary_id='37416.Fiyat girmelisiniz'></cfsavecontent>
      <cfinput type="text" name="price_" id="price_"  required="yes" message="#message#" validate="float">
    </div><div class="col col-3 col-md-3 col-xs-12">     
        <select name="money" id="money">
       <cfoutput query="get_money"> 
         <option value="#get_money.money#">#get_money.money# 
       </cfoutput> 
     </select></div>
    </div>

  </div>
  <div class="form-group">
    <label class="col col-4 col-md-4 col-xs-12"><cf_get_lang dictionary_id='57636.Birim'></label>
    <div class="col col-8 col-md-8 col-xs-12">
      <select name="unit_id" id="unit_id" >
        <cfoutput query="get_product_unit"> 
          <option value="#PRODUCT_UNIT_ID#">#add_unit# 
        </cfoutput> 
      </select>
    </div>
  </div>
  <div class="form-group">
    <label class="col col-4 col-md-4 col-xs-12"><cf_get_lang dictionary_id='57655.Başlangıç Tarihi'>*</label>
    <div class="col col-8 col-md-8 col-xs-12">
      <div class="input-group">
      <cfsavecontent variable="message"><cf_get_lang dictionary_id='57738.Başlangıç Tarihi girmelisiniz'></cfsavecontent>
        <cfinput required="Yes" validate="#validate_style#" message="#message#" type="text" id="startdate" name="startdate" maxlength="10">
        <span class="input-group-addon">
        <cf_wrk_date_image date_field="startdate">
        </span>
      </div>
    </div>
  </div>
  <div class="form-group">
    <label class="col col-4 col-md-4 col-xs-12"><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></label>
    <div class="col col-8 col-md-8 col-xs-12">
      <div class="input-group">
      <cfinput validate="#validate_style#" type="text" name="finishdate"  maxlength="10">
      <span class="input-group-addon">
      <cf_wrk_date_image date_field="finishdate">
      </span>
    </div>
  </div>
  </div>
</div>
  </cf_box_elements>
<cf_box_footer>      
	<cf_workcube_buttons is_upd='0' add_function='kontrol()'>
</cf_box_footer>

</cfform>   
</cf_box> 
<script type="text/javascript">
	function kontrol()
	{
		if(document.getElementById("price_").value == "")
		{
			alert("<cf_get_lang dictionary_id='41288.Fiyat Girmelisiniz'> !");
			return false;
		}
    else if(document.getElementById("startdate").value == "")
    {
      alert("<cf_get_lang dictionary_id='36485.Başlangıç tarihi Giriniz'> !");
			return false;
    }
		return true;
	}
</script>
