<cfsavecontent variable="title"><cf_get_lang dictionary_id='49081.Watalogy Integrations'></cfsavecontent>
<cf_box id="list_wizards" closable="0" collapsable="0" title="#title#"> 
  <div class="row">
      <div class="col col-12 col-xs-12 uniqueRow">
        <div class="row" formContent>
          <div class="row" type="row">
            <!--- Left --->
            <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
              <div class="form-group" id="item-product">
                <h3><cf_get_lang_main no="245.Ürün"></h3>
              </div>
              <div class="form-group" id="item-productList" style="margin-bottom:50px;">
                  <div class='col col-6 col-xs-12'>
                    <a href="<cfoutput>#request.self#</cfoutput>?fuseaction=worknet.productexportwex&event=add"> 1 - Product-Price-Stock Wizard </a>
                  </div>
              </div>

              <div class="form-group" id="item-support">
                  <h3><cf_get_lang dictionary_id="48650.Destek"></h3>
              </div>
              <div class="form-group" id="item-supportList">
                    <div class='col col-6 col-xs-12'>
                    </div>
              </div>
            </div>
            <!--- --->
            <!--- Right --->
            <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
              <div class="form-group" id="item-price">
                <h3><cf_get_lang dictionary_id="57611.Siparis"> & <cf_get_lang dictionary_id="33103.Sevkiyat"></h3>
              </div>
              <div class="form-group" id="item-priceList" style="margin-bottom:60px;">
                  
              </div>

              <div class="form-group" id="item-pay">
                  <h3><cf_get_lang dictionary_id="57847.Odeme"></h3>
              </div>
              <div class="form-group" id="item-payList">
                    <div class='col col-6 col-xs-12'>
                    </div>
              </div>
            </div>
            <!--- --->
          </div>
        </div>
      </div>
    </div>
</cf_box>