<cfobject name="recepie" component="WBP.Fashion.files.cfc.washing_recepie">
<cfset recepie_head = recepie.get_recepie_head(attributes.rid)>
<cfset recepie_rows = recepie.get_recepie_rows(attributes.rid)>
<div style="margin-top: 20px;"></div>
<cf_catalystHeader>
    <div style="clear: both"></div>
<cf_box title="YIKAMA REÇETESİ">
    <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
        <div class="form-group" id="item-">
            <label class="col col-4 col-xs-12">REÇETE NO</label>
            <div class="col col-8 col-xs-12">
                <input type="text" readonly value="RN-<cfoutput>#recepie_head.WASHING_RECEPIE_ID#</cfoutput>">
            </div>
        </div>
    </div>
    <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
        <div class="form-group" id="item-">
            <label class="col col-4 col-xs-12">SİPARİŞ NO</label>
            <div class="col col-8 col-xs-12">
                <input type="text" readonly value="<cfoutput>#recepie_head.ORDER_ID#</cfoutput>">
            </div>
        </div>
    </div>
    <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
        <div class="form-group" id="item-">
            <label class="col col-4 col-xs-12">PROJE NO</label>
            <div class="col col-8 col-xs-12">
                <input type="text" readonly value="<cfoutput>#recepie_head.PROJECT_HEAD#</cfoutput>">
            </div>
        </div>
    </div>
    <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="4" sort="true">
        <div class="form-group" id="item-">
            <label class="col col-4 col-xs-12">İSTASYON</label>
            <div class="col col-8 col-xs-12">
                <input type="text" readonly value="<cfoutput>#recepie_head.STATION_NAME#</cfoutput>">
            </div>
        </div>
    </div>
    <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="5" sort="true">
        <div class="form-group" id="item-">
            <label class="col col-4 col-xs-12">GÖREVLİ</label>
            <div class="col col-8 col-xs-12">
                <input type="text" readonly value="<cfoutput>#recepie_head.EMP_NAME#</cfoutput>">
            </div>
        </div>
    </div>
    <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="6" sort="true">
        <div class="form-group" id="item-">
            <label class="col col-4 col-xs-12">ONAY</label>
            <div class="col col-8 col-xs-12">
                <input type="checkbox" value="1" <cfoutput>#recepie_head.APPROVED?"checked":""#</cfoutput>>
            </div>
        </div>
    </div>
    <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="7" sort="true">
        <div class="form-group" id="item-">
            <label class="col col-4 col-xs-12">DURUM</label>
            <div class="col col-8 col-xs-12">
                <input type="checkbox" value="1" <cfoutput>#recepie_head.STATUS?"checked":""#</cfoutput>>
            </div>
        </div>
    </div>
</cf_box>

<cf_box>
    <table class="basket_list" style="width: 100%">
        <thead>
            <tr>
                <td>Ürün</td>
                <td>Miktar</td>
            </tr>
        </thead>
        <tbody>
            <cfoutput query="recepie_rows">
                <tr>
                    <td style="text-align: left;">#PRODUCT_NAME#</td>
                    <td>#AMOUNT#</td>
                </tr>
            </cfoutput>
        </tbody>
    </table>
</cf_box>