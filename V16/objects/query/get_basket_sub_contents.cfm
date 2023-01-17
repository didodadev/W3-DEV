<cfswitch expression="#attributes.basket_sub_id#">
	<cfcase value="1"><!--- satis irsaliye --->
		<cfinclude template="get_sub_basket_1.cfm">
	</cfcase>	
	<cfcase value="2"><!--- alis irsaliye --->
		<cfinclude template="get_sub_basket_2.cfm">
	</cfcase>
	<cfcase value="21"><!--- phl den satis irsaliye olusturma --->
		<cfinclude template="get_sub_basket_21.cfm">
	</cfcase>
	<cfcase value="3"><!--- fark faturasi --->
		<cfinclude template="get_sub_basket_3.cfm">
	</cfcase>
	<cfcase value="31"><!--- abonelik faturasi --->
		<cfinclude template="get_sub_basket_31.cfm">
	</cfcase>
	<cfcase value="32"><!--- fiziki varlik --->
		<cfinclude template="get_sub_basket_32.cfm">
	</cfcase>
	<cfcase value="4"><!--- irsaliye alim file & satınalma siparişi file &şube iç talep file--->
		<cfinclude template="get_sub_basket_4.cfm">
	</cfcase>
	<cfcase value="8"><!--- irsaliye alim file --->
		<cfinclude template="get_sub_basket_8.cfm">
	</cfcase>
	<cfcase value="8_2"><!--- irsaliye alim subscription --->
		<cfinclude template="get_sub_basket_8_2.cfm">
	</cfcase>
	<cfcase value="41"><!--- depo sevk irsaliyesi phl den oluştururken--->
		<cfinclude template="get_sub_basket_4_1.cfm">
	</cfcase>
	<cfcase value="42,43"><!--- hal faturasi icin --->
		<cfinclude template="get_sub_basket_42.cfm">
	</cfcase>	
	<cfcase value="44,45"><!--- sevk talep to ship --->
		<cfset attributes.ship_id = attributes.dispatch_ship_id>
		<cfinclude template="get_basket_44.cfm">
	</cfcase>
	<cfcase value="46"><!--- abonelikten siparise donusum --->
		<cfinclude template="get_sub_basket_46.cfm">
	</cfcase>	
	<cfcase value="5"><!--- satinalma ic talebin teklif veya siparise donusmesi --->
		<cfinclude template="get_sub_basket_5.cfm">
	</cfcase>
	<cfcase value="6"><!---order--->
		<cfinclude template="get_basket_6.cfm">
	</cfcase>
	<cfcase value="7"><!---şiparişten fatura oluşturma--->
		<cfinclude template="get_sub_basket_7.cfm">
	</cfcase>
	<cfcase value="12"><!---stok fisi phlden olusturulurken--->
		<cfinclude template="get_sub_basket_12.cfm">
	</cfcase>
	<cfcase value="22"><!---satınalma teklifi phlden olusturulurken--->
		<cfinclude template="get_sub_basket_22.cfm">
	</cfcase>
	<cfcase value="13"><!---açılış devir fişi phlden olusturulurken--->
		<cfinclude template="get_sub_basket_13.cfm">
	</cfcase>
	<cfcase value="47"> <!--- irsaliye, sipariş, üretim sonucunun paket ekranına düşürülmesi --->
		<cfinclude template="get_sub_basket_47.cfm">
	</cfcase>
	<cfdefaultcase>
		Sepet İçerik Doldurma Sayfası Eksik !
		<cfabort>
	</cfdefaultcase>
</cfswitch>