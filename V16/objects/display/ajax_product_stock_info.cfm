<!---
	PRODUCT_ID = attributes.pid
	STOCK_ID = attributes.sid
	şeklinden gönderilmelidir.
	Not : Bu sayfa bir çok yerden çağırılıyor,yaptığınız değişikliklere dikkat edin lütfen! M.ER 01.01.2008 
	İlerde Compenet Sayfası Haline Getirilebilir...
---> 
<cfif not isdefined("attributes.is_show_prod_amount")>
	<cfset attributes.is_show_prod_amount = 1>
</cfif>
<cfif not isdefined("attributes.x_show_serial_stock")>
    <cfset attributes.x_show_serial_stock = 0>
</cfif>
<cfif not isdefined("attributes.x_show_lot_stock")>
    <cfset attributes.x_show_lot_stock = 0>
</cfif>
<!--- Satış Durumları ---->
<cfif isdefined('attributes.sales')>
<div class="col col-6 col-md-6 col-sm-12 col-xs-12">
    <cfinclude template="../../objects/display/popup_sales_info.cfm">
</div>
</cfif>
<!--- Alış Durumları --->
<cfif isdefined('attributes.purchase')>
    <div class="col col-6 col-md-6 col-sm-12 col-xs-12">
        <cfinclude template="../../objects/display/popup_purchase_info.cfm">
    </div>
</cfif>
<!--- kapatılmamış siparişler --->
<cfif isdefined('attributes.show_stock_order')>
    <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
        <cfinclude template="../../objects/display/ajax_order_stock_detail.cfm">
    </div>
</cfif>			
<!--- Stok Durumları --->
<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
    <cfinclude template="../../objects/display/stock_status_info.cfm">
</div>
<cfif isdefined('attributes.sales')>
    <cfset order_type_ = 'sales'>
    <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
        <cfinclude template="../../objects/display/popup_order_row_currency.cfm">
    </div>
</cfif>
<cfif isdefined('attributes.purchase')>
    <cfset order_type_ = 'purchase'>
    <div class="col col-6 col-md-6 col-sm-12 col-xs-12">
        <cfinclude template="../../objects/display/popup_order_row_currency.cfm">
    </div>
</cfif>
<!--- Depolara Göre Stoklar --->
<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
    <cfinclude template="../../objects/display/location_stock_status_info.cfm">
</div>
<!--- seri no lara göre stoklar --->
<cfif attributes.x_show_serial_stock eq 1>
    <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
        <cfinclude template="../../objects/display/seri_no_stock_status_info.cfm">
    </div>
</cfif>
<!--- lot no ya göre stoklar --->
<cfif attributes.x_show_lot_stock eq 1>
    <div class="col col-8 col-md-8 col-sm-12 col-xs-12">
        <cfinclude template="../../objects/display/lot_no_status_info.cfm">
    </div>
</cfif>

<cfif attributes.is_show_prod_amount eq 1>
    <!--- Malzeme İhtiyaçları --->
    <cfif isdefined('attributes.tree_stock_status') and isdefined('attributes.spect_main_id') and isdefined('attributes.sid') and len(attributes.sid)>
        <cfset attributes.stock_id = attributes.sid>
        <cfset attributes.this_production_amount = attributes.amount>
        <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
            <cfinclude template="../../production_plan/display/order_products_stock_status.cfm">
        </div>
    </cfif>
</cfif>

