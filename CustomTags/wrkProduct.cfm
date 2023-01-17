<!--- 
	Ürün popupları yerine kullanılacak custom tag,
	gönderilen değişkenlere göre getProduct.cfc den aldığı değerleri wrk_list_page kullanarak listeler.
	created SM 20090709
 --->

<cfparam name="attributes.listPage" default="0"><!--- Liste sayfası olup olmadığı --->
<cfparam name="attributes.addPageUrl" default="product.form_add_product"><!--- Ekleme sayfası url --->
<cfparam name="attributes.updPageUrl" default="product.form_upd_product█pid="><!--- Güncelleme sayfası url --->
<cfparam name="attributes.returnInputValue" default="product_id,product_name"><!--- değer gönderilecek input isimleri..--->
<cfparam name="attributes.returnQueryValue" default="PRODUCT_ID,PRODUCT_NAME"><!--- Queryden gönderileeck değerler --->
<cfparam name="attributes.compenent_name" default="getProduct"><!--- component id --->
<cfparam name="attributes.fieldName" default="product_name"><!--- Oluşturulan input isim--->
<cfparam name="attributes.fieldId" default="product_id"><!--- Oluşturulan input id--->
<cfparam name="attributes.width" default="140"><!--- imput width --->
<cfparam name="attributes.boxwidth" default="200"><!--- div width --->
<cfparam name="attributes.boxheight" default="250"><!--- div height --->
<cfparam name="attributes.js_page" default="0"><!--- js den çağrılıp çağrılmadığı --->
<cfparam name="attributes.product_id" default=""><!--- Update sayfasına gidecekse gönderilecek parametre --->
<cfparam name="attributes.product_name" default=""><!--- Update sayfasına gidecekse gönderilecek isim --->
<cfparam name="attributes.title" default="#caller.getLang('main',152)#"><!--- Başlık ---><!---Ürünler--->
<cfparam name="attributes.formName" default="form">

<cfif not (attributes.listPage neq 1)>
	<cfset attributes.boxwidth = 1024>
    <cfset attributes.boxheight = 1280>
</cfif>
<cfif len(attributes.product_id)>
    <cfquery name="getSelectedProductName" datasource="#CALLER.DSN3#">
        SELECT
            PRODUCT_NAME
        FROM 
            PRODUCT
        WHERE 
			PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_id#">
    </cfquery>
    <cfset attributes.product_name = getSelectedProductName.product_name>
</cfif>

<cfoutput>
	<input type="hidden" name="#attributes.fieldId#"  id="#attributes.fieldId#" style="width:#attributes.width#px" value="#evaluate('attributes.#attributes.fieldId#')#">
	<input type="text" name="#attributes.fieldName#" id="#attributes.fieldName#" style="width:#attributes.width#px" value="#attributes.product_name#" onFocus = "AutoComplete_Create('#attributes.fieldName#','PRODUCT_NAME,STOCK_CODE','PRODUCT_NAME,STOCK_CODE','get_product_autocomplete','3','PRODUCT_ID','#attributes.fieldId#','form','3','135')">
	<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_product_names&product_id=#attributes.formName#.#attributes.fieldId#&field_name=#attributes.formName#.#attributes.fieldName#','list');"><img src="/images/plus_thin.gif" border="0" align="absmiddle"></a>
</cfoutput>
