<cfswitch expression="#attributes.basket_id#">
	<cfcase value="1,2,18,20"><!--- fatura-store satınalma,satış --->
		<cfinclude template="get_basket_1.cfm">
	</cfcase>
	<cfcase value="3"><!--- satış teklifi --->
		<cfinclude template="get_basket_3.cfm">
	</cfcase>
	<cfcase value="4,38,51"><!--- satış siparişi,şube satış siparişi(38),taksitli satıs(51) --->
		<cfinclude template="get_basket_4.cfm">
	</cfcase>
	<cfcase value="5"><!--- satınalma teklifi --->
		<cfinclude template="get_basket_5.cfm">
	</cfcase>
	<cfcase value="6"><!--- satınalma siparişi --->
		<cfinclude template="get_basket_6.cfm">
	</cfcase>
	<cfcase value="7,8,39"><!--- ic talep satinalma modulu  --->
		<cfinclude template="get_basket_7.cfm">
	</cfcase>
	<cfcase value="10,11,17,21"><!--- stok-store satis irsaliye ekle-update --->
		<cfinclude template="get_basket_10.cfm">
	</cfcase>	
	<cfcase value="12,19"><!--- stok-store fis ekle-update --->
		<cfinclude template="get_basket_12.cfm">
	</cfcase>
	<cfcase value="13"><!--- stok açılış / devir siparişi --->
		<cfinclude template="get_basket_13.cfm">
	</cfcase>	
	<cfcase value="14"><!--- stok satış siparişi --->
		<cfinclude template="get_basket_14.cfm">
	</cfcase>
	<cfcase value="15"><!--- stok alim siparişi --->
		<cfinclude template="get_basket_15.cfm">
	</cfcase>
	<cfcase value="24"><!--- partner offer --->
		<cfinclude template="get_basket_24.cfm">
	</cfcase>
	<cfcase value="25"><!--- partner order --->
		<cfinclude template="get_basket_25.cfm">
	</cfcase>		
	<cfcase value="29"><!--- kataloglar --->
		<cfinclude template="get_basket_29.cfm">
	</cfcase>		
	<cfcase value="31,32"><!--- stok-store sevk irsaliyesi --->
		<cfinclude template="get_basket_31.cfm">
	</cfcase>
	<cfcase value="33"><!--- Fatura diğer alış --->
		<cfinclude template="get_basket_33.cfm">
	</cfcase>
	<cfcase value="37"><!--- store alim siparisten irsaliyesi --->
		<cfinclude template="get_basket_37.cfm">
	</cfcase>
	<cfcase value="40,41"><!--- store & stock hal irsaliye --->
		<cfinclude template="get_basket_40.cfm">
	</cfcase>
	<cfcase value="42,43"><!--- invoice & store hal irsaliye --->
		<cfinclude template="get_basket_42.cfm">
	</cfcase>
	<cfcase value="44,45"><!--- sevk talep sube ve stock--->
		<cfinclude template="get_basket_44.cfm">
	</cfcase>
	<cfcase value="46"><!--- Abonelik ekle --->
		<cfinclude template="get_basket_46.cfm">
	</cfcase>
	<cfcase value="47"><!--- servis alis irsaliye ekle-update --->
		<cfinclude template="get_basket_47.cfm">
	</cfcase>
	<cfcase value="48"><!--- servis satis irsaliye ekle-update --->
		<cfinclude template="get_basket_48.cfm">
	</cfcase>	
	<cfcase value="49"><!--- stock: ithal mal girisi ekle-update --->
		<cfinclude template="get_basket_49.cfm">
	</cfcase>
	<cfcase value="50"><!--- Proje Malzeme Planı--->
		<cfinclude template="get_basket_50.cfm">
	</cfcase>
	<cfcase value="52"><!---fatura: z raporu --->
		<cfinclude template="get_basket_52.cfm">
	</cfcase>
	<cfdefaultcase>
		Sepet İçerik Doldurma Sayfası Eksik, objects/query/get_basket_contents.cfm sayfasına bakınız !
		<cfabort>
	</cfdefaultcase>
</cfswitch>
